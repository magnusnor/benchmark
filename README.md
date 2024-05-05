# Benchmark

This repository aims to generate cardinality estimates from MySQL for different workloads based on the IMDb dataset and the STATS dataset.

## Quick-Start

Split the SQL queries from the `.sql` file for the specified workload:

```shell
./split_sql_queries.sh <sql-file> <output-dir>
```

E.g., for the `job-light` workload:

```shell
./split_sql_queries.sh ./workloads/job-light/job_light_queries.sql ./workloads/job-light/queries
```

Ensure the MySQL server is running, e.g., with `mtr`, and that the IMDb dataset `imdbload` has been loaded into the database. For further instructions on how to load the IMDb dataset, see `/datasets/job/README.md`.

Run the workload queries to obtain the MySQL cardinality estimates, e.g., for the `job-light` workload:

```shell
./run_queries.sh job-light
```

This will generate the output from MySQL's `EXPLAIN ANALYZE` and output it to JSON. The results will be written to `/results/<workload>/baseline/`.

## Datasets

The dataset used is a snapshot version from May 2013 of the Internet Movie Database (IMDb).

### JOB

> Based on [https://github.com/winkyao/join-order-benchmark](https://github.com/winkyao/join-order-benchmark)

This package contains the Join Order Benchmark (JOB) queries from:
"[How Good Are Query Optimizers, Really?](http://www.vldb.org/pvldb/vol9/p204-leis.pdf)"
by Viktor Leis, Andrey Gubichev, Atans Mirchev, Peter Boncz, Alfons Kemper, Thomas Neumann
PVLDB Volume 9, No. 3, 2015

The `datasets/job/csv_files/imdb-create-tables.sql` and `datasets/job/queries/*.sql` are modified to MySQL syntax.

## Workloads

Several different workloads are used. `job-light`, `scale`, and `synthetic` are for the IMDb dataset, whereas the `stats-ceb` is for the STATS dataset.

### JOB-light

The JOB-light workload is a subset consisting of 70 of the original 113 queries from the JOB queries.

### Scale

A synthetically generated workload based on the schema for the IMDb dataset. Contains 500 queries, 100 each containing 0, 1, 2, 3, and 4 joins respectively.

### Synthetic

A synthetically generated workload based on the schema for the IMDb dataset. Contains 5000 unique queries, where each query contains between 0-2 joins.