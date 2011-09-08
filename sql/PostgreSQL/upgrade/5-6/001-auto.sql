-- Convert schema '/home/devin/web-devel/PerlFu/script/../sql/_source/deploy/5/001-auto.yml' to '/home/devin/web-devel/PerlFu/script/../sql/_source/deploy/6/001-auto.yml':;

;
BEGIN;

;
ALTER TABLE sessions ALTER COLUMN session_data DROP NOT NULL;

;

COMMIT;

