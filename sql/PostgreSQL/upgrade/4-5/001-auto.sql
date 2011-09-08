-- Convert schema '/home/devin/web-devel/PerlFu/script/../sql/_source/deploy/4/001-auto.yml' to '/home/devin/web-devel/PerlFu/script/../sql/_source/deploy/5/001-auto.yml':;

;
BEGIN;

;
CREATE TABLE "sessions" (
  "id" character(72) NOT NULL,
  "session_data" text NOT NULL,
  "expires" integer,
  PRIMARY KEY ("id")
);

;

COMMIT;

