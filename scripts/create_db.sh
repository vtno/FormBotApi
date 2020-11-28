#! /bin/sh
set -e

mkdir -p sqlite
sqlite3 sqlite/dev.db 'create table if not exists auth_tokens (id INTEGER PRIMARY KEY, token TEXT, created_at DATETIME, expired_at DATETIME)'
sqlite3 sqlite/test.db 'create table if not exists auth_tokens (id INTEGER PRIMARY KEY, token TEXT, created_at DATETIME, expired_at DATETIME)'
sqlite3 sqlite/prod.db 'create table if not exists auth_tokens (id INTEGER PRIMARY KEY, token TEXT, created_at DATETIME, expired_at DATETIME)'