-- 
-- Created by SQL::Translator::Producer::PostgreSQL
-- Created on Thu Sep  8 16:32:10 2011
-- 
;
--
-- Table: forums
--
CREATE TABLE "forums" (
  "forumid" serial NOT NULL,
  "name" character varying(255) NOT NULL,
  PRIMARY KEY ("forumid"),
  CONSTRAINT "forums_name" UNIQUE ("name")
);

;
--
-- Table: roles
--
CREATE TABLE "roles" (
  "roleid" integer NOT NULL,
  "name" character varying(255) NOT NULL,
  PRIMARY KEY ("roleid"),
  CONSTRAINT "roles_name" UNIQUE ("name")
);

;
--
-- Table: sessions
--
CREATE TABLE "sessions" (
  "id" character(72) NOT NULL,
  "session_data" text,
  "expires" integer,
  PRIMARY KEY ("id")
);

;
--
-- Table: users
--
CREATE TABLE "users" (
  "userid" integer NOT NULL,
  "name" character varying(255) NOT NULL,
  "password" character(60) NOT NULL,
  PRIMARY KEY ("userid"),
  CONSTRAINT "users_name" UNIQUE ("name")
);

;
--
-- Table: posts
--
CREATE TABLE "posts" (
  "postid" serial NOT NULL,
  "forumid" integer NOT NULL,
  "title" character varying(200) NOT NULL,
  "tags" character varying(255),
  "body" text NOT NULL,
  "author" integer NOT NULL,
  "parent" integer,
  "path" character varying(255),
  PRIMARY KEY ("postid"),
  CONSTRAINT "posts_title" UNIQUE ("title")
);
CREATE INDEX "posts_idx_author" on "posts" ("author");
CREATE INDEX "posts_idx_forumid" on "posts" ("forumid");
CREATE INDEX "posts_idx_parent" on "posts" ("parent");

;
--
-- Table: user_roles
--
CREATE TABLE "user_roles" (
  "roleid" integer NOT NULL,
  "userid" integer NOT NULL,
  PRIMARY KEY ("roleid", "userid")
);
CREATE INDEX "user_roles_idx_roleid" on "user_roles" ("roleid");
CREATE INDEX "user_roles_idx_userid" on "user_roles" ("userid");

;
--
-- Foreign Key Definitions
--

;
ALTER TABLE "posts" ADD FOREIGN KEY ("author")
  REFERENCES "users" ("userid") ON DELETE CASCADE ON UPDATE CASCADE DEFERRABLE;

;
ALTER TABLE "posts" ADD FOREIGN KEY ("forumid")
  REFERENCES "forums" ("forumid") ON DELETE CASCADE ON UPDATE CASCADE DEFERRABLE;

;
ALTER TABLE "posts" ADD FOREIGN KEY ("parent")
  REFERENCES "posts" ("postid") ON DELETE CASCADE ON UPDATE CASCADE DEFERRABLE;

;
ALTER TABLE "user_roles" ADD FOREIGN KEY ("roleid")
  REFERENCES "roles" ("roleid") ON DELETE CASCADE ON UPDATE CASCADE DEFERRABLE;

;
ALTER TABLE "user_roles" ADD FOREIGN KEY ("userid")
  REFERENCES "users" ("userid") DEFERRABLE;

