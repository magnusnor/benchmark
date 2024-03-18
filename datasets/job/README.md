# Join Order Benchmark

> Based on [https://github.com/winkyao/join-order-benchmark](https://github.com/winkyao/join-order-benchmark)

This package contains the Join Order Benchmark (JOB) queries from:
"[How Good Are Query Optimizers, Really?](http://www.vldb.org/pvldb/vol9/p204-leis.pdf)"
by Viktor Leis, Andrey Gubichev, Atans Mirchev, Peter Boncz, Alfons Kemper, Thomas Neumann
PVLDB Volume 9, No. 3, 2015

## Quick-Start

Fetch the IMDb dataset:

```shell
cd csv_files/
wget http://homepages.cwi.nl/~boncz/job/imdb.tgz
tar -xvzf imdb.tgz
```

Connect to the MySQL database:

```shell
cd build/
./bin/mysql -u root -S <sock> --local-infile
```

Create the database tables:

```sqlmysql
SOURCE /home/magnus/dev/priv/benchmark/datasets/job/csv_files/imdb-create-tables.sql
```

Load the IMDb data:

```sqlmysql
SOURCE /home/magnus/dev/priv/benchmark/datasets/job/csv_files/imdb-load-data.sql
```

Create indexes on the database tables:

```sqlmysql
SOURCE /home/magnus/dev/priv/benchmark/datasets/job/csv_files/imdb-index-tables.sql
```

### Order Problem
Note that `queries/17b.sql` and `queries/8d.sql` may have order issues. This is due to different order rules from MySQL. However, this is not a real bug.