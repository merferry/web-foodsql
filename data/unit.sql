-- 1. create table to store unit conversion factors
CREATE TABLE IF NOT EXISTS "unit" (
  "id"    TEXT NOT NULL,
  "value" REAL NOT NULL,
  PRIMARY KEY ("id"),
  CHECK ("id"<>'')
);


CREATE OR REPLACE FUNCTION "unit_value" (TEXT)
RETURNS REAL AS $$
  SELECT "value" FROM "unit" WHERE "id"=$1;
$$ LANGUAGE SQL;


CREATE OR REPLACE FUNCTION "unit_tobase" (TEXT, TEXT)
RETURNS REAL AS $$
  -- 1. number * unit factor * column factor
  SELECT (split_part($1, ' ', 1)::REAL)*
  coalesce(unit_value(split_part($1, ' ', 2)), 1)*
  coalesce(unit_value($2), 1);
$$ LANGUAGE SQL;


CREATE OR REPLACE FUNCTION "unit_convert" (TEXT, TEXT)
RETURNS TEXT AS $$
  -- 1. convert only real numbers
  SELECT CASE WHEN type_value($2)<>'REAL' THEN $1
  ELSE unit_tobase($1, $2)::TEXT END;
$$ LANGUAGE SQL;


CREATE OR REPLACE FUNCTION "unit_insertone" (JSON)
RETURNS VOID AS $$
  INSERT INTO "unit" VALUES($1->>'id', ($1->>'value')::REAL);
$$ LANGUAGE SQL;


CREATE OR REPLACE FUNCTION "unit_deleteone" (JSON)
RETURNS VOID AS $$
  DELETE FROM "unit" WHERE "id"=$1->>'id';
$$ LANGUAGE SQL;


CREATE OR REPLACE FUNCTION "unit_upsertone" (JSON)
RETURNS VOID AS $$
  INSERT INTO "unit" VALUES($1->>'id', ($1->>'value')::REAL)
  ON CONFLICT ("id") DO UPDATE SET "value"=($1->>'value')::REAL;
$$ LANGUAGE SQL;


CREATE OR REPLACE FUNCTION "unit_selectone" (JSON)
RETURNS "unit" AS $$
  SELECT * FROM "unit" WHERE "id"=$1->>'id';
$$ LANGUAGE SQL;
