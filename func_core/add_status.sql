-- DROP FUNCTION core.add_status();

CREATE OR REPLACE FUNCTION core.add_status()
 RETURNS integer
 LANGUAGE plpgsql
AS $function$
BEGIN
    BEGIN
        -- Проверка и добавление колонки, если её нет
        IF NOT EXISTS (
            SELECT 1
            FROM information_schema.columns
            WHERE table_schema = 'stage'
              AND table_name = 'stage_pars_hh'
              AND column_name = 'status'
        ) THEN
            EXECUTE 'ALTER TABLE stage.stage_pars_hh ADD COLUMN status int4;';
        END IF;

        -- Обновление статуса
        UPDATE stage.stage_pars_hh h
        SET status = CASE
            WHEN EXISTS (
                SELECT 1
                FROM core.fact_vacancy f
                WHERE f.id = h.id
                  AND f.vacancy_hash = h.vacancy_hash
            ) THEN 1
            WHEN EXISTS (
                SELECT 1
                FROM core.fact_vacancy f
                WHERE f.id = h.id
                  AND f.vacancy_hash != h.vacancy_hash
            ) THEN 2
            ELSE 0
        END;

        RETURN 0;  -- Adjust the return value based on your requirements

    EXCEPTION
        WHEN OTHERS THEN
            -- Log the error or handle it as needed
            RAISE NOTICE 'Error occurred: %', SQLERRM;
            RETURN -1;  -- Indicate error occurrence
    END;
END;
$function$
;
