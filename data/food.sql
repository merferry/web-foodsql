-- 1. create bare table for storing food details
CREATE TABLE IF NOT EXISTS "food" (
  "Id" INT NOT NULL,
  PRIMARY KEY ("Id")
);


CREATE OR REPLACE FUNCTION "food_tobase" (JSONB)
RETURNS JSONB AS $$
  -- 4. aggregate all keys and values to jsonb
  SELECT jsonb_object_agg("key", "value") FROM (
  -- 2. field names to base field names
  SELECT coalesce(term_value("key"), "key") AS "key",
  -- 3. unit values to base unit values
  unit_convert("value", coalesce(term_value("key"), "key")) AS "value"
  -- 1. get keys, values from input
  FROM jsonb_each_text($1) t) u;
$$ LANGUAGE SQL;


CREATE OR REPLACE FUNCTION "food_insertone" (_a JSONB)
RETURNS VOID AS $$
DECLARE
  -- 1. get base jsonb and row jsonb
  _b   JSONB := food_tobase(_a);
  _row JSONB := row_to_json(jsonb_populate_record(NULL::"food", _b))::JSONB;
BEGIN
  -- 2. does it fit in the row (no extra columns)?
  IF NOT jsonb_keys(_row) @> jsonb_keys(_b) THEN
    RAISE EXCEPTION 'invalid column(s): %',
    array_removes(jsonb_keys(_b), jsonb_keys(_row))::TEXT;
  END IF;
  -- 3. insert to table (hopefully valid data)
  INSERT INTO "food" SELECT * FROM
  jsonb_populate_record(NULL::"food", table_default('food')||_b);
END;
$$ LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION "food_deleteone" (JSONB)
RETURNS VOID AS $$
  DELETE FROM "food" WHERE "Id"=($1->>'Id')::INT;
$$ LANGUAGE SQL;


CREATE OR REPLACE FUNCTION "food_selectone" (JSONB)
RETURNS SETOF "food" AS $$
  SELECT * FROM "food" WHERE "Id"=($1->>'Id')::INT;
$$ LANGUAGE SQL;


/* DEFAULT VALUES */
INSERT INTO "type" VALUES ('Id', 'INT NOT NULL')
ON CONFLICT ("id") DO NOTHING;
SELECT type_insertoneifnotexists('Name', 'TEXT NOT NULL');
SELECT type_insertoneifnotexists('Food Group', 'TEXT');
SELECT type_insertoneifnotexists('Carbohydrate Factor', 'REAL');
SELECT type_insertoneifnotexists('Fat Factor', 'REAL');
SELECT type_insertoneifnotexists('Protein Factor', 'REAL');
SELECT type_insertoneifnotexists('Nitrogen to Protein Conversion Factor', 'REAL');
SELECT type_insertoneifnotexists('Water', 'REAL');
SELECT type_insertoneifnotexists('Energy', 'REAL');
SELECT type_insertoneifnotexists('Protein', 'REAL');
SELECT type_insertoneifnotexists('Total lipid (fat)', 'REAL');
SELECT type_insertoneifnotexists('Ash', 'REAL');
SELECT type_insertoneifnotexists('Carbohydrate, by difference', 'REAL');
SELECT type_insertoneifnotexists('Fiber, total dietary', 'REAL');
SELECT type_insertoneifnotexists('Sugars, total', 'REAL');
SELECT type_insertoneifnotexists('Calcium, Ca', 'REAL');
SELECT type_insertoneifnotexists('Iron, Fe', 'REAL');
SELECT type_insertoneifnotexists('Magnesium, Mg', 'REAL');
SELECT type_insertoneifnotexists('Phosphorus, P', 'REAL');
SELECT type_insertoneifnotexists('Potassium, K', 'REAL');
SELECT type_insertoneifnotexists('Sodium, Na', 'REAL');
SELECT type_insertoneifnotexists('Zinc, Zn', 'REAL');
SELECT type_insertoneifnotexists('Copper, Cu', 'REAL');
SELECT type_insertoneifnotexists('Manganese, Mn', 'REAL');
SELECT type_insertoneifnotexists('Selenium, Se', 'REAL');
SELECT type_insertoneifnotexists('Fluoride, F', 'REAL');
SELECT type_insertoneifnotexists('Vitamin C, total ascorbic acid', 'REAL');
SELECT type_insertoneifnotexists('Thiamin', 'REAL');
SELECT type_insertoneifnotexists('Riboflavin', 'REAL');
SELECT type_insertoneifnotexists('Niacin', 'REAL');
SELECT type_insertoneifnotexists('Pantothenic acid', 'REAL');
SELECT type_insertoneifnotexists('Vitamin B-6', 'REAL');
SELECT type_insertoneifnotexists('Folate, total', 'REAL');
SELECT type_insertoneifnotexists('Folic acid', 'REAL');
SELECT type_insertoneifnotexists('Folate, food', 'REAL');
SELECT type_insertoneifnotexists('Folate, DFE', 'REAL');
SELECT type_insertoneifnotexists('Choline, total', 'REAL');
SELECT type_insertoneifnotexists('Betaine', 'REAL');
SELECT type_insertoneifnotexists('Vitamin B-12', 'REAL');
SELECT type_insertoneifnotexists('Vitamin B-12, added', 'REAL');
SELECT type_insertoneifnotexists('Vitamin A, RAE', 'REAL');
SELECT type_insertoneifnotexists('Retinol', 'REAL');
SELECT type_insertoneifnotexists('Carotene, beta', 'REAL');
SELECT type_insertoneifnotexists('Carotene, alpha', 'REAL');
SELECT type_insertoneifnotexists('Cryptoxanthin, beta', 'REAL');
SELECT type_insertoneifnotexists('Vitamin A, IU', 'REAL');
SELECT type_insertoneifnotexists('Lycopene', 'REAL');
SELECT type_insertoneifnotexists('Lutein + zeaxanthin', 'REAL');
SELECT type_insertoneifnotexists('Vitamin E (alpha-tocopherol)', 'REAL');
SELECT type_insertoneifnotexists('Vitamin E, added', 'REAL');
SELECT type_insertoneifnotexists('Tocopherol, beta', 'REAL');
SELECT type_insertoneifnotexists('Tocopherol, gamma', 'REAL');
SELECT type_insertoneifnotexists('Tocopherol, delta', 'REAL');
SELECT type_insertoneifnotexists('Vitamin D (D2 + D3)', 'REAL');
SELECT type_insertoneifnotexists('Vitamin D2 (ergocalciferol)', 'REAL');
SELECT type_insertoneifnotexists('Vitamin D3 (cholecalciferol)', 'REAL');
SELECT type_insertoneifnotexists('Vitamin D', 'REAL');
SELECT type_insertoneifnotexists('Vitamin K (phylloquinone)', 'REAL');
SELECT type_insertoneifnotexists('Fatty acids, total saturated', 'REAL');
SELECT type_insertoneifnotexists('Butanoic acid', 'REAL');
SELECT type_insertoneifnotexists('Hexanoic acid', 'REAL');
SELECT type_insertoneifnotexists('Octanoic acid', 'REAL');
SELECT type_insertoneifnotexists('Decanoic acid', 'REAL');
SELECT type_insertoneifnotexists('Dodecanoic acid', 'REAL');
SELECT type_insertoneifnotexists('Tetradecanoic acid', 'REAL');
SELECT type_insertoneifnotexists('Pentadecanoic acid', 'REAL');
SELECT type_insertoneifnotexists('Hexadecanoic acid', 'REAL');
SELECT type_insertoneifnotexists('Heptadecanoic acid', 'REAL');
SELECT type_insertoneifnotexists('Octadecanoic acid', 'REAL');
SELECT type_insertoneifnotexists('Eicosanoic acid', 'REAL');
SELECT type_insertoneifnotexists('Docosanoic acid', 'REAL');
SELECT type_insertoneifnotexists('Tetracosanoic acid', 'REAL');
SELECT type_insertoneifnotexists('Fatty acids, total monounsaturated', 'REAL');
SELECT type_insertoneifnotexists('Tetradecenoic acid', 'REAL');
SELECT type_insertoneifnotexists('Pentadecenoic acid', 'REAL');
SELECT type_insertoneifnotexists('Hexadecenoic acid', 'REAL');
SELECT type_insertoneifnotexists('Cis-hexadecenoic acid', 'REAL');
SELECT type_insertoneifnotexists('Trans-hexadecenoic acid', 'REAL');
SELECT type_insertoneifnotexists('Heptadecenoic acid', 'REAL');
SELECT type_insertoneifnotexists('Octadecenoic acid', 'REAL');
SELECT type_insertoneifnotexists('Cis-octadecenoic acid', 'REAL');
SELECT type_insertoneifnotexists('Trans-octadecenoic acid', 'REAL');
SELECT type_insertoneifnotexists('Eicosenoic acid', 'REAL');
SELECT type_insertoneifnotexists('Docosenoic acid', 'REAL');
SELECT type_insertoneifnotexists('Cis-docosenoic acid', 'REAL');
SELECT type_insertoneifnotexists('Trans-docosenoic acid', 'REAL');
SELECT type_insertoneifnotexists('Cis-tetracosenoic acid', 'REAL');
SELECT type_insertoneifnotexists('Fatty acids, total polyunsaturated', 'REAL');
SELECT type_insertoneifnotexists('Octadecadienoic acid', 'REAL');
SELECT type_insertoneifnotexists('Cis,cis-octadecadienoic n-6 acid', 'REAL');
SELECT type_insertoneifnotexists('Octadecadienoic CLAs acid', 'REAL');
SELECT type_insertoneifnotexists('Irans-Octadecadienoic acid', 'REAL');
SELECT type_insertoneifnotexists('Trans-octadecadienoic acid', 'REAL');
SELECT type_insertoneifnotexists('Cis,cis-eicosadienoic n-6 acid', 'REAL');
SELECT type_insertoneifnotexists('Octadecatrienoic acid', 'REAL');
SELECT type_insertoneifnotexists('Cis,cis,cis-octadecatrienoic n-3 acid', 'REAL');
SELECT type_insertoneifnotexists('Cis,cis,cis-octadecatrienoic n-6 acid', 'REAL');
SELECT type_insertoneifnotexists('Trans-octadecatrienoic acid', 'REAL');
SELECT type_insertoneifnotexists('Eicosatrienoic acid', 'REAL');
SELECT type_insertoneifnotexists('Eicosatrienoic n-6 acid', 'REAL');
SELECT type_insertoneifnotexists('Octadecatetraenoic acid', 'REAL');
SELECT type_insertoneifnotexists('Eicosatetraenoic acid', 'REAL');
SELECT type_insertoneifnotexists('Docosatetraenoic acid', 'REAL');
SELECT type_insertoneifnotexists('Eicosapentaenoic n-3 acid', 'REAL');
SELECT type_insertoneifnotexists('Docosapentaenoic n-3 acid', 'REAL');
SELECT type_insertoneifnotexists('Docosahexaenoic n-3 acid', 'REAL');
SELECT type_insertoneifnotexists('Fatty acids, total trans', 'REAL');
SELECT type_insertoneifnotexists('Fatty acids, total trans-monoenoic', 'REAL');
SELECT type_insertoneifnotexists('Fatty acids, total trans-polyenoic', 'REAL');
SELECT type_insertoneifnotexists('Cholesterol', 'REAL');
SELECT type_insertoneifnotexists('Stigmasterol', 'REAL');
SELECT type_insertoneifnotexists('Campesterol', 'REAL');
SELECT type_insertoneifnotexists('Beta-sitosterol', 'REAL');
SELECT type_insertoneifnotexists('Tryptophan', 'REAL');
SELECT type_insertoneifnotexists('Threonine', 'REAL');
SELECT type_insertoneifnotexists('Isoleucine', 'REAL');
SELECT type_insertoneifnotexists('Leucine', 'REAL');
SELECT type_insertoneifnotexists('Lysine', 'REAL');
SELECT type_insertoneifnotexists('Methionine', 'REAL');
SELECT type_insertoneifnotexists('Cystine', 'REAL');
SELECT type_insertoneifnotexists('Phenylalanine', 'REAL');
SELECT type_insertoneifnotexists('Tyrosine', 'REAL');
SELECT type_insertoneifnotexists('Valine', 'REAL');
SELECT type_insertoneifnotexists('Arginine', 'REAL');
SELECT type_insertoneifnotexists('Histidine', 'REAL');
SELECT type_insertoneifnotexists('Alanine', 'REAL');
SELECT type_insertoneifnotexists('Aspartic acid', 'REAL');
SELECT type_insertoneifnotexists('Glutamic acid', 'REAL');
SELECT type_insertoneifnotexists('Glycine', 'REAL');
SELECT type_insertoneifnotexists('Proline', 'REAL');
SELECT type_insertoneifnotexists('Serine', 'REAL');
SELECT type_insertoneifnotexists('Alcohol, ethyl', 'REAL');
SELECT type_insertoneifnotexists('Caffeine', 'REAL');
SELECT type_insertoneifnotexists('Theobromine', 'REAL');


/* DEFAULT VALUES */
INSERT INTO "term" VALUES ('id', 'Id')
ON CONFLICT ("id") DO NOTHING;
SELECT term_insertoneifnotexists('4:0', 'Butanoic acid');
SELECT term_insertoneifnotexists('6:0', 'Hexanoic acid');
SELECT term_insertoneifnotexists('8:0', 'Octanoic acid');
SELECT term_insertoneifnotexists('10:0', 'Decanoic acid');
SELECT term_insertoneifnotexists('12:0', 'Dodecanoic acid');
SELECT term_insertoneifnotexists('14:0', 'Tetradecanoic acid');
SELECT term_insertoneifnotexists('15:0', 'Pentadecanoic acid');
SELECT term_insertoneifnotexists('16:0', 'Hexadecanoic acid');
SELECT term_insertoneifnotexists('17:0', 'Heptadecanoic acid');
SELECT term_insertoneifnotexists('18:0', 'Octadecanoic acid');
SELECT term_insertoneifnotexists('20:0', 'Eicosanoic acid');
SELECT term_insertoneifnotexists('22:0', 'Docosanoic acid');
SELECT term_insertoneifnotexists('24:0', 'Tetracosanoic acid');
SELECT term_insertoneifnotexists('14:1', 'Tetradecenoic acid');
SELECT term_insertoneifnotexists('15:1', 'Pentadecenoic acid');
SELECT term_insertoneifnotexists('16:1 undifferentiated', 'Hexadecenoic acid');
SELECT term_insertoneifnotexists('16:1 c', 'Cis-hexadecenoic acid');
SELECT term_insertoneifnotexists('16:1 t', 'Trans-hexadecenoic acid');
SELECT term_insertoneifnotexists('17:1', 'Heptadecenoic acid');
SELECT term_insertoneifnotexists('18:1 undifferentiated', 'Octadecenoic acid');
SELECT term_insertoneifnotexists('18:1 c', 'Cis-octadecenoic acid');
SELECT term_insertoneifnotexists('18:1 t', 'Trans-octadecenoic acid');
SELECT term_insertoneifnotexists('20:1', 'Eicosenoic acid');
SELECT term_insertoneifnotexists('22:1 undifferentiated', 'Docosenoic acid');
SELECT term_insertoneifnotexists('22:1 c', 'Cis-docosenoic acid');
SELECT term_insertoneifnotexists('22:1 t', 'Trans-docosenoic acid');
SELECT term_insertoneifnotexists('24:1 c', 'Cis-tetracosenoic acid');
SELECT term_insertoneifnotexists('18:2 undifferentiated', 'Octadecadienoic acid');
SELECT term_insertoneifnotexists('18:2 n-6 c,c', 'Cis,cis-octadecadienoic n-6 acid');
SELECT term_insertoneifnotexists('18:2 CLAs', 'Octadecadienoic CLAs acid');
SELECT term_insertoneifnotexists('18:2 i', 'Irans-Octadecadienoic acid');
SELECT term_insertoneifnotexists('18:2 t not further defined', 'Trans-octadecadienoic acid');
SELECT term_insertoneifnotexists('20:2 n-6 c,c', 'Cis,cis-eicosadienoic n-6 acid');
SELECT term_insertoneifnotexists('18:3 undifferentiated', 'Octadecatrienoic acid');
SELECT term_insertoneifnotexists('18:3 n-3 c,c,c (ALA)', 'Cis,cis,cis-octadecatrienoic n-3 acid');
SELECT term_insertoneifnotexists('18:3 n-6 c,c,c', 'Cis,cis,cis-octadecatrienoic n-6 acid');
SELECT term_insertoneifnotexists('18:3i', 'Trans-octadecatrienoic acid');
SELECT term_insertoneifnotexists('20:3 undifferentiated', 'Eicosatrienoic acid');
SELECT term_insertoneifnotexists('20:3 n-6', 'Eicosatrienoic n-6 acid');
SELECT term_insertoneifnotexists('18:4', 'Octadecatetraenoic acid');
SELECT term_insertoneifnotexists('20:4 undifferentiated', 'Eicosatetraenoic acid');
SELECT term_insertoneifnotexists('22:4', 'Docosatetraenoic acid');
SELECT term_insertoneifnotexists('20:5 n-3 (EPA)', 'Eicosapentaenoic n-3 acid');
SELECT term_insertoneifnotexists('22:5 n-3 (DPA)', 'Docosapentaenoic n-3 acid');
SELECT term_insertoneifnotexists('22:6 n-3 (DHA)', 'Docosahexaenoic n-3 acid');
