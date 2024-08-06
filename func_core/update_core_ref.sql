-- DROP FUNCTION core.update_core_ref();

CREATE OR REPLACE FUNCTION core.update_core_ref()
 RETURNS void
 LANGUAGE plpgsql
AS $function$
BEGIN
    -- Insert new areas into core.ref_area
    INSERT INTO core.ref_area (city)
    SELECT DISTINCT area
    FROM stage.stage_pars_hh sph
    WHERE area NOT IN (SELECT city FROM core.ref_area);

    -- Insert new companies into core.ref_company
    INSERT INTO core.ref_company (employer_name, employer_url)
    SELECT DISTINCT sph.employer_name, employer_url
    FROM stage.stage_pars_hh sph
    WHERE employer_url NOT IN (SELECT employer_url FROM core.ref_company);

    -- Insert new data into core.ref_data_vacancy
    INSERT INTO core.ref_data_vacancy (alternate_url, description)
    SELECT DISTINCT sph.alternate_url, sph.description
    FROM stage.stage_pars_hh sph
    WHERE alternate_url NOT IN (SELECT alternate_url FROM core.ref_data_vacancy);

    -- Insert new employment types into core.ref_employment
    INSERT INTO core.ref_employment (employment)
    SELECT DISTINCT employment
    FROM stage.stage_pars_hh sph
    WHERE employment NOT IN (SELECT employment FROM core.ref_employment);

    -- Insert new experience types into core.ref_experience
    INSERT INTO core.ref_experience (experience)
    SELECT DISTINCT experience
    FROM stage.stage_pars_hh sph
    WHERE experience NOT IN (SELECT experience FROM core.ref_experience);

    -- Insert new professional roles into core.ref_professional_roles
    INSERT INTO core.ref_professional_roles (professional_roles)
    SELECT DISTINCT sph.professional_roles
    FROM stage.stage_pars_hh sph
    WHERE professional_roles NOT IN (SELECT professional_roles FROM core.ref_professional_roles);

    -- Insert new schedules into core.ref_schedule
    INSERT INTO core.ref_schedule (schedule)
    SELECT DISTINCT schedule
    FROM stage.stage_pars_hh sph
    WHERE schedule NOT IN (SELECT schedule FROM core.ref_schedule);

    -- Insert new names into core.ref_name
    INSERT INTO core.ref_name ("name")
    SELECT DISTINCT "name"
    FROM stage.stage_pars_hh sph
    WHERE "name" NOT IN (SELECT "name" FROM core.ref_name);

    INSERT INTO core.ref_working_days (working_days)
    SELECT DISTINCT working_days
    FROM stage.stage_pars_hh sph
    WHERE working_days NOT IN (SELECT working_days FROM core.ref_working_days);

    INSERT INTO core.ref_working_time_modes (working_time_modes)
    SELECT DISTINCT working_time_modes
    FROM stage.stage_pars_hh sph
    WHERE working_time_modes NOT IN (SELECT working_time_modes FROM core.ref_working_time_modes);

    INSERT INTO core.ref_working_time_intervals (working_time_intervals)
    SELECT DISTINCT working_time_intervals
    FROM stage.stage_pars_hh sph
    WHERE working_time_intervals NOT IN (SELECT working_time_intervals FROM core.ref_working_time_intervals);

    INSERT INTO core.ref_addres (address_city, address_street, address_lat, address_lng)
    SELECT DISTINCT sph.address_city, sph.address_street, sph.address_lat, sph.address_lng
    FROM stage.stage_pars_hh sph
    WHERE address_lat  NOT IN (SELECT address_lat FROM core.ref_addres) and address_lng  NOT IN (SELECT address_lng FROM core.ref_addres);

    INSERT INTO core.ref_skill (skill)
    SELECT DISTINCT skill
    FROM stage.stage_pars_hh_skill sph
    WHERE skill NOT IN (SELECT skill FROM core.ref_skill);



END;
$function$
;
