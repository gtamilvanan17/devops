DO $$
DECLARE
    r RECORD;
    table_name_input TEXT := ''; -- Enter the table name here or leave empty for all tables
    case_option TEXT := ''; -- Choose 'lower' or 'upper' for case conversion
    excluded_tables TEXT[] := ARRAY['', '']; -- List tables to exclude
BEGIN
    IF case_option NOT IN ('lower', 'upper') THEN
        RAISE EXCEPTION 'Invalid case_option value. Use ''lower'' or ''upper''.';
    END IF;

    IF table_name_input = '' THEN
        -- Process all tables except the excluded ones
        FOR r IN 
            SELECT table_name, column_name 
            FROM information_schema.columns 
            WHERE table_schema = 'public'
              AND table_name NOT IN (SELECT unnest(excluded_tables))
        LOOP
            EXECUTE format('ALTER TABLE %I RENAME COLUMN %I TO %I', 
                           r.table_name, r.column_name, 
                           CASE WHEN case_option = 'lower' THEN lower(r.column_name) 
                                ELSE upper(r.column_name) 
                           END);
        END LOOP;
    ELSE
        -- Process only the specified table, excluding columns from the excluded tables list
        FOR r IN 
            SELECT column_name 
            FROM information_schema.columns 
            WHERE table_schema = 'public'
              AND table_name = table_name_input
        LOOP
            EXECUTE format('ALTER TABLE %I RENAME COLUMN %I TO %I', 
                           table_name_input, r.column_name, 
                           CASE WHEN case_option = 'lower' THEN lower(r.column_name) 
                                ELSE upper(r.column_name) 
                           END);
        END LOOP;
    END IF;
END $$;

-- List all tables
SELECT table_schema, table_name
FROM information_schema.tables
WHERE table_type = 'BASE TABLE'
  AND table_schema NOT IN ('information_schema', 'pg_catalog');
