-- Convert schema '/home/devin/web-devel/PerlFu/script/../sql/_source/deploy/3/001-auto.yml' to '/home/devin/web-devel/PerlFu/script/../sql/_source/deploy/4/001-auto.yml':;

;
BEGIN;

;
CREATE TABLE "roles" (
  "roleid" integer NOT NULL,
  "name" character varying(255) NOT NULL,
  PRIMARY KEY ("roleid"),
  CONSTRAINT "roles_name" UNIQUE ("name")
);

;
CREATE TABLE "user_roles" (
  "roleid" integer NOT NULL,
  "userid" integer NOT NULL,
  PRIMARY KEY ("roleid", "userid")
);
CREATE INDEX "user_roles_idx_roleid" on "user_roles" ("roleid");
CREATE INDEX "user_roles_idx_userid" on "user_roles" ("userid");

;
ALTER TABLE "user_roles" ADD FOREIGN KEY ("roleid")
  REFERENCES "roles" ("roleid") ON DELETE CASCADE ON UPDATE CASCADE DEFERRABLE;

;
ALTER TABLE "user_roles" ADD FOREIGN KEY ("userid")
  REFERENCES "users" ("userid") DEFERRABLE;

;

COMMIT;

