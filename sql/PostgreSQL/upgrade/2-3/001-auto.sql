-- Convert schema '/home/devin/web-devel/PerlFu/script/../sql/_source/deploy/2/001-auto.yml' to '/home/devin/web-devel/PerlFu/script/../sql/_source/deploy/3/001-auto.yml':;

;
BEGIN;

;
ALTER TABLE users ALTER COLUMN password TYPE character(60);

;

COMMIT;

