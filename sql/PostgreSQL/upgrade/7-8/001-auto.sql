-- Convert schema '/home/devin/web-devel/PerlFu/script/../sql/_source/deploy/7/001-auto.yml' to '/home/devin/web-devel/PerlFu/script/../sql/_source/deploy/8/001-auto.yml':;

;
BEGIN;

;
CREATE INDEX path_postid_idx on posts (path, postid);

;
CREATE INDEX post_author_idx on posts (postid, author);

;

COMMIT;

