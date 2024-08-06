-- DROP FUNCTION core.update_fact_history();

CREATE OR REPLACE FUNCTION core.update_fact_history()
 RETURNS integer
 LANGUAGE plpgsql
AS $function$
BEGIN
    -- Move old records to history
    INSERT INTO core.fact_vacancy_history (
        id, id_area, id_name, id_data_vacancy, id_company, id_schedule,
        id_professional_roles, id_experience, id_employment, salary_from,
        salary_to, salary_currency, published_at, vacancy_hash,
        id_working_time_modes, id_addres, id_working_time_intervals,
        id_working_days, copied_at, has_test
    )
    SELECT
        f.id, f.id_area, f.id_name, f.id_data_vacancy, f.id_company,
        f.id_schedule, f.id_professional_roles, f.id_experience,
        f.id_employment, f.salary_from, f.salary_to, f.salary_currency,
        f.published_at, f.vacancy_hash, f.id_working_time_modes,
        f.id_addres, f.id_working_time_intervals, f.id_working_days,
        CURRENT_TIMESTAMP, f.has_test
    FROM core.fact_vacancy f
    JOIN stage.stage_pars_hh h ON f.id = h.id
    WHERE h.status = 2;

    -- Delete old records from core.vacancys_skills
    DELETE FROM core.vacancys_skills
    WHERE vacancy_id IN (
        SELECT id
        FROM stage.stage_pars_hh
        WHERE status = 2
    );

    -- Delete old records from core.fact_vacancy
    DELETE FROM core.fact_vacancy
    WHERE id IN (
        SELECT id
        FROM stage.stage_pars_hh
        WHERE status = 2
    );

    RETURN 1;  -- or another appropriate return value
END;
$function$
;
