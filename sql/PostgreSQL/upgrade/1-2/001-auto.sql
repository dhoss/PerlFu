-- Convert schema '/home/devin/web-devel/PerlFu/script/../sql/_source/deploy/1/001-auto.yml' to '/home/devin/web-devel/PerlFu/script/../sql/_source/deploy/2/001-auto.yml':;

;
BEGIN;

;
ALTER TABLE posts DROP COLUMN created_at;

;
ALTER TABLE posts DROP COLUMN updated_at;

;
ALTER TABLE users ADD COLUMN password character(59) NOT NULL;

;
ALTER TABLE users ALTER COLUMN userid TYPE integer;

;

COMMIT;

