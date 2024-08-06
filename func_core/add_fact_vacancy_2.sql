-- DROP FUNCTION core.add_fact_vacancy_2();

CREATE OR REPLACE FUNCTION core.add_fact_vacancy_2()
 RETURNS integer
 LANGUAGE plpgsql
AS $function$
BEGIN
    -- Add new records with status = 2
    INSERT INTO core.fact_vacancy (
        id, id_area, id_name, id_data_vacancy, id_company, id_schedule,
        id_professional_roles, id_experience, id_employment, salary_from,
        salary_to, salary_currency, published_at, vacancy_hash,
        id_working_time_modes, id_addres, id_working_time_intervals,
        id_working_days, has_test
    )
    SELECT
        sph.id, ra.id, rn.id, rdv.id, rc.id, rs.id, rpr.id, rex.id, rem.id,
        sph.salary_from, sph.salary_to, sph.salary_currency, sph.published_at,
        sph.vacancy_hash, rwtm.id, ra2.id, rwti.id, rwd.id, sph.has_test
    FROM stage.stage_pars_hh sph
    LEFT JOIN core.ref_area ra ON ra.city = sph.area
    LEFT JOIN core.ref_company rc ON rc.employer_url = sph.employer_url AND rc.employer_name = sph.employer_name
    LEFT JOIN core.ref_data_vacancy rdv ON rdv.alternate_url = sph.alternate_url
    LEFT JOIN core.ref_employment rem ON rem.employment = sph.employment
    LEFT JOIN core.ref_experience rex ON rex.experience = sph.experience
    LEFT JOIN core.ref_name rn ON rn."name" = sph."name"
    LEFT JOIN core.ref_professional_roles rpr ON rpr.professional_roles = sph.professional_roles
    LEFT JOIN core.ref_schedule rs ON rs.schedule = sph.schedule
    LEFT JOIN core.ref_working_time_modes rwtm ON rwtm.working_time_modes = sph.working_time_modes
    LEFT JOIN core.ref_addres ra2 ON ra2.address_lat = sph.address_lat AND ra2.address_lng = sph.address_lng
    LEFT JOIN core.ref_working_time_intervals rwti ON rwti.working_time_intervals = sph.working_time_intervals
    LEFT JOIN core.ref_working_days rwd ON rwd.working_days = sph.working_days
    WHERE sph.status = 2;

    RETURN 1;  -- or another appropriate return value
END;
$function$
;
