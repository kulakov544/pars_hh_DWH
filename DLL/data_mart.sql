-- Основное представление с данными вакансий
CREATE OR REPLACE VIEW data_mart.vw_vacancy_details
AS SELECT fv.id,
    ra.city AS area_name,
    rn.name,
    rdv.alternate_url AS url,
    rdv.description,
    rc.employer_name AS company_name,
    rc.employer_url AS company_url,
    rs.schedule AS schedule_name,
    rpr.professional_roles AS professional_role,
    re.experience,
    rem.employment,
    fv.salary_from::double precision * cur.rate AS salary_from,
    fv.salary_to::double precision * cur.rate AS salary_to,
    fv.salary_currency,
    fv.published_at,
    fv.vacancy_hash,
    wtm.working_time_modes,
    wti.working_time_intervals,
    wd.working_days,
    radd.address_city,
    radd.address_street,
    radd.address_lat,
    radd.address_lng,
    fv.has_test
   FROM core.fact_vacancy fv
     LEFT JOIN core.ref_area ra ON fv.id_area = ra.id
     LEFT JOIN core.ref_company rc ON fv.id_company = rc.id
     LEFT JOIN core.ref_data_vacancy rdv ON fv.id_data_vacancy = rdv.id
     LEFT JOIN core.ref_employment rem ON fv.id_employment = rem.id
     LEFT JOIN core.ref_experience re ON fv.id_experience = re.id
     LEFT JOIN core.ref_name rn ON fv.id_name = rn.id
     LEFT JOIN core.ref_addres radd ON fv.id_addres = radd.id
     LEFT JOIN core.ref_working_days wd ON fv.id_working_days = wd.id
     LEFT JOIN core.ref_working_time_intervals wti ON fv.id_working_time_intervals = wti.id
     LEFT JOIN core.ref_working_time_modes wtm ON fv.id_working_time_modes = wtm.id
     LEFT JOIN core.ref_professional_roles rpr ON fv.id_professional_roles = rpr.id
     LEFT JOIN core.ref_schedule rs ON fv.id_schedule = rs.id
     LEFT JOIN ( SELECT r.rate,
            r.currency
           FROM core.rates r
             JOIN ( SELECT rates.currency,
                    max(rates.date) AS max_date
                   FROM core.rates
                  GROUP BY rates.currency) latest ON r.currency = latest.currency AND r.date = latest.max_date) cur ON fv.salary_currency = cur.currency
  WHERE fv.id_professional_roles <> ALL (ARRAY[6, 10, 12, 17, 19, 26, 28, 29, 30, 40, 41, 43, 44, 46, 47, 48, 49, 50, 51, 52, 53, 54, 55, 56, 58, 59, 61, 62, 64, 65, 66, 67, 68, 69, 70, 71, 72, 73, 74, 75, 76, 77, 78, 79, 80, 81, 82, 83, 84, 85, 86, 87, 89, 90, 91, 92, 93, 94, 95, 96, 97, 98, 99, 100, 101, 102, 103, 104, 105, 106, 107, 108, 109, 110, 111, 112, 114, 115, 116, 117, 118, 119, 120, 121, 122, 123, 125, 126, 127, 128, 129, 130, 132, 133, 134, 135, 136, 137, 138, 139, 140, 141, 142, 143, 144, 145, 146, 147, 148, 149, 150, 151, 152, 153, 154, 155, 156, 157, 158, 159, 160, 161, 162, 163, 164, 165, 166, 167, 168, 169, 170]);

-- представление справочника вакансий
CREATE OR REPLACE VIEW data_mart.skills_skill_view
AS SELECT skill_id,
    skill
   FROM core.ref_skill;

-- Представление таблицы мапинга.
CREATE OR REPLACE VIEW data_mart.skills_id_view
AS SELECT vacancy_id,
    skill_id
   FROM core.vacancys_skills;