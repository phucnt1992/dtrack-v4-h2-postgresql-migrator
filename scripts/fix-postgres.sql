DO $$
DECLARE
    r RECORD;
BEGIN
    FOR r IN
        SELECT table_name, column_name, sequence_name
        FROM information_schema.columns
        CROSS JOIN LATERAL pg_get_serial_sequence(table_schema || '.' || table_name, column_name) AS sequence_name
        WHERE table_schema = 'public' AND sequence_name IS NOT NULL
    LOOP
        EXECUTE format('SELECT setval(%L, COALESCE((SELECT max(%I) FROM %I), 1))',
                       r.sequence_name, r.column_name, r.table_name);
    END LOOP;
END $$;
