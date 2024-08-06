-- DROP FUNCTION core.delete_old_vacancy();

CREATE OR REPLACE FUNCTION core.delete_old_vacancy()
 RETURNS void
 LANGUAGE plpgsql
AS $function$
BEGIN
    -- Вставка записей в core.fact_vacancy_history
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
   JOIN stage.old_vacancy ov ON f.id = ov.id;

    -- Удаление старых записей из core.vacancys_skills
    DELETE FROM core.vacancys_skills
    WHERE vacancy_id IN (
        SELECT ov.id
        FROM stage.old_vacancy ov
    );

    -- Удаление старых записей из core.fact_vacancy
    DELETE FROM core.fact_vacancy
    WHERE id IN (
        SELECT ov.id
        FROM stage.old_vacancy ov
    );
END;
$function$
;
