-- Convert schema '/home/devin/web-devel/PerlFu/script/../sql/_source/deploy/8/001-auto.yml' to '/home/devin/web-devel/PerlFu/script/../sql/_source/deploy/9/001-auto.yml':;

;
BEGIN;

;
CREATE INDEX path_idx on posts (path);

;

COMMIT;

