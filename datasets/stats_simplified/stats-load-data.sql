SET GLOBAL local_infile = 1;

LOAD DATA LOCAL INFILE '/home/magnus/dev/priv/benchmark/datasets/stats_simplified/badges.csv' INTO TABLE badges FIELDS TERMINATED BY ',';
LOAD DATA LOCAL INFILE '/home/magnus/dev/priv/benchmark/datasets/stats_simplified/comments.csv' INTO TABLE comments FIELDS TERMINATED BY ',';
LOAD DATA LOCAL INFILE '/home/magnus/dev/priv/benchmark/datasets/stats_simplified/postHistory.csv' INTO TABLE postHistory FIELDS TERMINATED BY ',';
LOAD DATA LOCAL INFILE '/home/magnus/dev/priv/benchmark/datasets/stats_simplified/postLinks.csv' INTO TABLE postLinks FIELDS TERMINATED BY ',';
LOAD DATA LOCAL INFILE '/home/magnus/dev/priv/benchmark/datasets/stats_simplified/posts.csv' INTO TABLE posts FIELDS TERMINATED BY ',';
LOAD DATA LOCAL INFILE '/home/magnus/dev/priv/benchmark/datasets/stats_simplified/tags.csv' INTO TABLE tags FIELDS TERMINATED BY ',';
LOAD DATA LOCAL INFILE '/home/magnus/dev/priv/benchmark/datasets/stats_simplified/users.csv' INTO TABLE users FIELDS TERMINATED BY ',';
LOAD DATA LOCAL INFILE '/home/magnus/dev/priv/benchmark/datasets/stats_simplified/votes.csv' INTO TABLE votes FIELDS TERMINATED BY ',';
