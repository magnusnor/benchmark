#!/bin/bash
set -e

CURDIR=$(cd `dirname $0`; pwd)
OUTDIR=$CURDIR/results/$1

if [ ! -e $OUTDIR ]; then
  mkdir -p $OUTDIR
fi

cd $CURDIR

mysql_client="/home/magnus/dev/priv/mysql-server/build-release/bin/mysql"
mysql_sock="/home/magnus/dev/priv/mysql-server/build-release/mysql-test/var/tmp/mysqld.1.sock"

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

output_folder="${OUTDIR}/baseline/"

if [ ! -e $output_folder ]; then
mkdir -p $output_folder
fi

for file in `ls workloads/$1/queries/*.sql`; do
    base_name=`basename $file`
    name=${base_name%.*}
    output_json=$output_folder/$name.json
    echo -e "${BIWhite}+-------------+${NC}"
    echo -e "${BIWhite}| Run $name.sql |${NC}"
    echo -e "${BIWhite}+-------------+${NC}"

    original_query=$(<$file)
    query=${original_query/";"/"\G"}

    if [ -s "$output_json" ]
    then
      echo "Results for $name already collected, skipping..."
      continue
    fi

    $mysql_connect -e "EXPLAIN ANALYZE format=json $query" | awk '
    /^{/ {start = 1}
    /^EXPLAIN: / {gsub(/^EXPLAIN: /, ""); start = 1}
    start {print}' > "$output_json"
done
