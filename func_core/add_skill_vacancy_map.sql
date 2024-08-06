-- DROP FUNCTION core.add_skill_vacancy_map();

CREATE OR REPLACE FUNCTION core.add_skill_vacancy_map()
 RETURNS integer
 LANGUAGE plpgsql
AS $function$
BEGIN
    -- Вставка навыков для вакансий
    INSERT INTO core.vacancys_skills (vacancy_id, skill_id)
    SELECT DISTINCT sph.id, rs.skill_id
    FROM stage.stage_pars_hh_skill sph
    JOIN core.ref_skill rs ON rs.skill = sph.skill
    WHERE NOT EXISTS (
        SELECT 1
        FROM core.vacancys_skills vsk
        WHERE vsk.vacancy_id = sph.id
          AND vsk.skill_id = rs.skill_id
    );

    RETURN 1;  -- или другое подходящее значение
END;
$function$
;
