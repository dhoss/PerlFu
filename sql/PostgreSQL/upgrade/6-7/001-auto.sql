-- Convert schema '/home/devin/web-devel/PerlFu/script/../sql/_source/deploy/6/001-auto.yml' to '/home/devin/web-devel/PerlFu/script/../sql/_source/deploy/7/001-auto.yml':;

;
BEGIN;

;
ALTER TABLE posts ADD COLUMN created_at timestamp NOT NULL;

;
ALTER TABLE posts ADD COLUMN updated_at timestamp;

;

COMMIT;

