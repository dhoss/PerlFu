-- Convert schema '/home/devin/web-devel/PerlFu/script/../sql/_source/deploy/9/001-auto.yml' to '/home/devin/web-devel/PerlFu/script/../sql/_source/deploy/10/001-auto.yml':;

;
BEGIN;

;
CREATE INDEX forum_name_idx on forums (forumid, name);

;

COMMIT;

