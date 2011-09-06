-- Convert schema '/home/devin/web-devel/PerlFu/script/../sql/_source/deploy/1/001-auto.yml' to '/home/devin/web-devel/PerlFu/script/../sql/_source/deploy/3/001-auto.yml':;

;
BEGIN;

;
ALTER TABLE posts ADD COLUMN created_at timestamp NOT NULL;

;
ALTER TABLE posts ADD COLUMN updated_at timestamp;

;
ALTER TABLE posts ALTER COLUMN path DROP NOT NULL;

;
CREATE INDEX posts_idx_parent on posts (parent);

;
ALTER TABLE posts ADD FOREIGN KEY (parent)
  REFERENCES posts (postid) ON DELETE CASCADE ON UPDATE CASCADE DEFERRABLE;

;

COMMIT;

