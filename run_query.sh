#!/bin/bash
set -e

CURDIR=$(cd `dirname $0`; pwd)
OUTDIR=$CURDIR/results/job/

if [ ! -e $OUTDIR ]; then
  mkdir -p $OUTDIR
fi

cd $CURDIR

mysql_client="/home/magnus/dev/priv/mysql-server/build/bin/mysql"
mysql_sock="/home/magnus/dev/priv/mysql-server/build/mysql-test/var/tmp/mysqld.1.sock"

export mysql_connect="$mysql_client -u root -S $mysql_sock -D imdbload -t"

eval "$mysql_connect<<eof
UPDATE mysql.engine_cost SET cost_value = 0.25 WHERE cost_name = 'io_block_read_cost';
UPDATE mysql.engine_cost SET cost_value = 0.25 WHERE cost_name = 'memory_block_read_cost';
FLUSH OPTIMIZER_COSTS;

SET PERSIST innodb_stats_persistent = 1;
SET PERSIST innodb_stats_auto_recalc = 0;

SET GLOBAL optimizer_switch='hypergraph_optimizer=on';
eof"

analyze="$mysql_connect<<eof > /dev/null
ANALYZE TABLE aka_name;
ANALYZE TABLE aka_title;
ANALYZE TABLE cast_info;
ANALYZE TABLE char_name;
ANALYZE TABLE company_name;
ANALYZE TABLE company_type;
ANALYZE TABLE comp_cast_type;
ANALYZE TABLE complete_cast;
ANALYZE TABLE info_type;
ANALYZE TABLE keyword;
ANALYZE TABLE kind_type;
ANALYZE TABLE link_type;
ANALYZE TABLE movie_companies;
ANALYZE TABLE movie_info;
ANALYZE TABLE movie_info_idx;
ANALYZE TABLE movie_keyword;
ANALYZE TABLE movie_link;
ANALYZE TABLE name;
ANALYZE TABLE person_info;
ANALYZE TABLE role_type;
ANALYZE TABLE title;
eof"

eval "$analyze"

output_folder_baseline="${OUTDIR}/baseline_plans/"
output_folder_ml="${OUTDIR}/ml_plans/"
output_folder_benchmark="${OUTDIR}/benchmark/"

if [ ! -e $output_folder_baseline ]; then
mkdir -p $output_folder_baseline
fi

if [ ! -e $output_folder_ml ]; then
mkdir -p $output_folder_ml
fi

if [ ! -e $output_folder_benchmark ]; then
mkdir -p $output_folder_benchmark
fi

file="datasets/job/queries/${1:-"1a"}.sql"
base_name=`basename $file`
name=${base_name%.*}
output_markdown_benchmark=$output_folder_benchmark/$name.md
output_json_baseline=$output_folder_baseline/$name.json
output_json_ml=$output_folder_ml/$name.json
output_json_benchmark=$output_folder_benchmark/$name.json

NC='\033[0m' 
BIWhite='\033[1;97m'
echo -e "${BIWhite}+-------------+${NC}"
echo -e "${BIWhite}| Run $name.sql |${NC}"
echo -e "${BIWhite}+-------------+${NC}"

original_query=$(<$file)
query=${original_query/";"/"\G"}

query_without_ml=${query}
query_with_ml=${query/"SELECT "/"SELECT /*+ ML_CARDINALITY_ESTIMATION(1) */ "}
query_compare_with_baseline=${query/"SELECT "/"SELECT /*+ ML_CARDINALITY_ESTIMATION(0) */ "}

if [ ! -s "$output_json_baseline" ]
then 
  $mysql_connect -e "EXPLAIN ANALYZE format=json $query_compare_with_baseline" > "$output_json_baseline"
else
  echo "Comparison results on baseline plan for $name already collected, skipping..."
fi

if [ ! -s "$output_json_ml" ]
then 
  $mysql_connect -e "EXPLAIN ANALYZE format=json $query_with_ml" > "$output_json_ml"
else
  echo "Comparison results on ML plan for $name already collected, skipping..."
fi

hyperfine \
  --warmup 2 \
  -r 10 \
  --export-json $output_json_benchmark \
  --export-markdown $output_markdown_benchmark \
  -n "without_ml" "$mysql_connect -e \"EXPLAIN ANALYZE $query_without_ml\"" \
  -n "with_ml" "$mysql_connect -e \"EXPLAIN ANALYZE $query_with_ml\""
