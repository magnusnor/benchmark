# STATS

## Quick-Start

Connect to the MySQL database:

```shell
cd build/
./bin/mysql -u root -S <sock> --local-infile
```

Create the database tables:

```sqlmysql
SOURCE /home/magnus/dev/priv/benchmark/datasets/stats_simplified/stats-create-tables.sql
```

Load the simplified STATS data:

```sqlmysql
SOURCE /home/magnus/dev/priv/benchmark/datasets/stats_simplified/stats-load-data.sql
```

Create indexes on the database tables:

```sqlmysql
SOURCE /home/magnus/dev/priv/benchmark/datasets/stats_simplified/stats-index-tables.sql
```

## Tables

### `badges`

### `comments`

### `postHistory`

### `postLinks`

### `posts`

### `tags`

### `users`

### `votes`

## CSV File Format

### `badges`

```csv
Id,UserId,Date
```

### `comments`

```csv
Id,PostId,Score,CreationDate,UserId
```

### `postHistory`


```csv
Id,PostHistoryTypeId,PostId,CreationDate,UserId
```

### `postLinks`


```csv
Id,CreationDate,PostId,RelatedPostId,LinkTypeId
```

### `posts`


```csv
Id,PostTypeId,CreationDate,Score,ViewCount,OwnerUserId,AnswerCount,CommentCount,FavoriteCount,LastEditorUserId
```

### `tags`


```csv
Id,Count,ExcerptPostId
```

### `users`


```csv
Id,Reputation,CreationDate,Views,UpVotes,DownVotes
```

### `votes`


```csv
Id,PostId,VoteTypeId,CreationDate,UserId,BountyAmount
```
