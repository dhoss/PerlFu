-- 
-- Created by SQL::Translator::Producer::PostgreSQL
-- Created on Tue Sep  6 13:18:40 2011
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
-- Table: users
--
CREATE TABLE "users" (
  "userid" serial NOT NULL,
  "name" character varying(255) NOT NULL,
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
  "created_at" timestamp NOT NULL,
  "updated_at" timestamp,
  PRIMARY KEY ("postid"),
  CONSTRAINT "posts_title" UNIQUE ("title")
);
CREATE INDEX "posts_idx_author" on "posts" ("author");
CREATE INDEX "posts_idx_forumid" on "posts" ("forumid");
CREATE INDEX "posts_idx_parent" on "posts" ("parent");

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

