-- Календарь
CREATE TABLE core.calendar (
	"date" date NULL,
	work_day bool NULL,
	holidays bool NULL,
	holidays_transfer bool NULL,
	to_work bool NULL,
	week_number int4 NULL,
	month_number int4 NULL,
	quarter int4 NULL,
	month_name_en varchar NULL,
	month_abbr_en varchar NULL,
	month_name varchar NULL,
	month_abbr varchar NULL
);

-- Курсы валют
CREATE TABLE core.rates (
	"date" timestamp NULL,
	currency text NULL,
	rate float8 NULL
);

-- Справочник адресов
CREATE TABLE core.ref_addres (
	id int4 GENERATED ALWAYS AS IDENTITY( INCREMENT BY 1 MINVALUE 1 MAXVALUE 2147483647 START 1 CACHE 1 NO CYCLE) NOT NULL,
	address_city text NULL,
	address_street text NULL,
	address_lat float8 NULL,
	address_lng float8 NULL,
	CONSTRAINT ref_addres_pk PRIMARY KEY (id)
);

-- Справочник регионов
CREATE TABLE core.ref_area (
	id int4 GENERATED ALWAYS AS IDENTITY( INCREMENT BY 1 MINVALUE 1 MAXVALUE 2147483647 START 1 CACHE 1 NO CYCLE) NOT NULL,
	city text NOT NULL,
	CONSTRAINT fer_area_pk PRIMARY KEY (id)
);

-- Справочник компаний
CREATE TABLE core.ref_company (
	id int4 GENERATED ALWAYS AS IDENTITY( INCREMENT BY 1 MINVALUE 1 MAXVALUE 2147483647 START 1 CACHE 1 NO CYCLE) NOT NULL,
	employer_name text NULL,
	employer_url text NULL,
	CONSTRAINT fer_company_pk PRIMARY KEY (id),
	CONSTRAINT ref_company_unique UNIQUE (employer_name, employer_url)
);

-- Справочник информации о вакансиях
CREATE TABLE core.ref_data_vacancy (
	id int4 GENERATED ALWAYS AS IDENTITY( INCREMENT BY 1 MINVALUE 1 MAXVALUE 2147483647 START 1 CACHE 1 NO CYCLE) NOT NULL,
	alternate_url text NULL,
	description text NULL,
	CONSTRAINT fer_data_vacancy_pk PRIMARY KEY (id),
	CONSTRAINT ref_data_vacancy_unique UNIQUE (alternate_url)
);

-- справочник типов занятости
CREATE TABLE core.ref_employment (
	id int4 GENERATED ALWAYS AS IDENTITY( INCREMENT BY 1 MINVALUE 1 MAXVALUE 2147483647 START 1 CACHE 1 NO CYCLE) NOT NULL,
	employment text NULL,
	CONSTRAINT fer_employment_pk PRIMARY KEY (id)
);

-- справочник опыта
CREATE TABLE core.ref_experience (
	id int4 GENERATED ALWAYS AS IDENTITY( INCREMENT BY 1 MINVALUE 1 MAXVALUE 2147483647 START 1 CACHE 1 NO CYCLE) NOT NULL,
	experience text NULL,
	CONSTRAINT fer_experience_pk PRIMARY KEY (id)
);

-- справочник названий вакансий
CREATE TABLE core.ref_name (
	id int4 GENERATED ALWAYS AS IDENTITY( INCREMENT BY 1 MINVALUE 1 MAXVALUE 2147483647 START 1 CACHE 1 NO CYCLE) NOT NULL,
	"name" text NULL,
	CONSTRAINT fer_name_pk PRIMARY KEY (id)
);

-- справочник профессий
CREATE TABLE core.ref_professional_roles (
	id int4 GENERATED ALWAYS AS IDENTITY( INCREMENT BY 1 MINVALUE 1 MAXVALUE 2147483647 START 1 CACHE 1 NO CYCLE) NOT NULL,
	professional_roles text NULL,
	CONSTRAINT fer_professional_roles_pk PRIMARY KEY (id)
);

-- справочник типов работы
CREATE TABLE core.ref_schedule (
	id int4 GENERATED ALWAYS AS IDENTITY( INCREMENT BY 1 MINVALUE 1 MAXVALUE 2147483647 START 1 CACHE 1 NO CYCLE) NOT NULL,
	schedule text NULL,
	CONSTRAINT fer_schedule_pk PRIMARY KEY (id)
);

-- справочник навыков
CREATE TABLE core.ref_skill (
	skill_id int4 GENERATED ALWAYS AS IDENTITY( INCREMENT BY 1 MINVALUE 1 MAXVALUE 2147483647 START 1 CACHE 1 NO CYCLE) NOT NULL,
	skill text NULL,
	CONSTRAINT ref_skill_pk PRIMARY KEY (skill_id),
	CONSTRAINT ref_skill_unique UNIQUE (skill)
);

-- справочник рабочих дней
CREATE TABLE core.ref_working_days (
	id int4 GENERATED ALWAYS AS IDENTITY( INCREMENT BY 1 MINVALUE 1 MAXVALUE 2147483647 START 1 CACHE 1 NO CYCLE) NOT NULL,
	working_days text NULL,
	CONSTRAINT ref_working_pk PRIMARY KEY (id)
);

-- справочник интервалов работы
CREATE TABLE core.ref_working_time_intervals (
	id int4 GENERATED ALWAYS AS IDENTITY( INCREMENT BY 1 MINVALUE 1 MAXVALUE 2147483647 START 1 CACHE 1 NO CYCLE) NOT NULL,
	working_time_intervals text NULL,
	CONSTRAINT ref_working_time_interval_pk PRIMARY KEY (id)
);

-- справочник моделей работы
CREATE TABLE core.ref_working_time_modes (
	id int4 GENERATED ALWAYS AS IDENTITY( INCREMENT BY 1 MINVALUE 1 MAXVALUE 2147483647 START 1 CACHE 1 NO CYCLE) NOT NULL,
	working_time_modes text NULL,
	CONSTRAINT ref_working_time_modes_pk PRIMARY KEY (id)
);

-- Основная таблица вакансий
CREATE TABLE core.fact_vacancy (
	id int4 NOT NULL,
	id_area int4 NULL,
	id_name int4 NULL,
	id_data_vacancy int4 NULL,
	id_company int4 NULL,
	id_schedule int4 NULL,
	id_professional_roles int4 NULL,
	id_experience int4 NULL,
	id_employment int4 NULL,
	salary_from int4 NULL,
	salary_to int4 NULL,
	salary_currency text NULL,
	published_at timestamp NULL,
	vacancy_hash text NULL,
	id_working_time_modes int4 NULL,
	id_addres int4 NULL,
	id_working_time_intervals int4 NULL,
	id_working_days int4 NULL,
	has_test bool NULL,
	CONSTRAINT id PRIMARY KEY (id),
	CONSTRAINT fact_vacancy_fer_area_fk FOREIGN KEY (id_area) REFERENCES core.ref_area(id),
	CONSTRAINT fact_vacancy_fer_company_fk FOREIGN KEY (id_company) REFERENCES core.ref_company(id),
	CONSTRAINT fact_vacancy_fer_data_vacancy_fk FOREIGN KEY (id_data_vacancy) REFERENCES core.ref_data_vacancy(id),
	CONSTRAINT fact_vacancy_fer_employment_fk FOREIGN KEY (id_employment) REFERENCES core.ref_employment(id),
	CONSTRAINT fact_vacancy_fer_experience_fk FOREIGN KEY (id_experience) REFERENCES core.ref_experience(id),
	CONSTRAINT fact_vacancy_fer_name_fk FOREIGN KEY (id_name) REFERENCES core.ref_name(id),
	CONSTRAINT fact_vacancy_fer_professional_roles_fk_1 FOREIGN KEY (id_professional_roles) REFERENCES core.ref_professional_roles(id),
	CONSTRAINT fact_vacancy_fer_schedule_fk FOREIGN KEY (id_schedule) REFERENCES core.ref_schedule(id),
	CONSTRAINT fact_vacancy_ref_addres_fk FOREIGN KEY (id_addres) REFERENCES core.ref_addres(id),
	CONSTRAINT fact_vacancy_ref_working_days_fk FOREIGN KEY (id_working_days) REFERENCES core.ref_working_days(id),
	CONSTRAINT fact_vacancy_ref_working_time_intervals_fk FOREIGN KEY (id_working_time_intervals) REFERENCES core.ref_working_time_intervals(id),
	CONSTRAINT fact_vacancy_ref_working_time_modes_fk FOREIGN KEY (id_working_time_modes) REFERENCES core.ref_working_time_modes(id)
);

-- Таблица мапинга Вакансии-навыки
CREATE TABLE core.vacancys_skills (
	vacancy_id int4 NULL,
	skill_id int4 NULL,
	CONSTRAINT vacancys_skills_vacancy_id_skill_id_key UNIQUE (vacancy_id, skill_id),
	CONSTRAINT vacancys_skills_skill_id_fk FOREIGN KEY (skill_id) REFERENCES core.ref_skill(skill_id),
	CONSTRAINT vacancys_skills_vacancy_id_fk FOREIGN KEY (vacancy_id) REFERENCES core.fact_vacancy(id)
);

-- Таблица устаревших вакансий
CREATE TABLE core.fact_vacancy_history (
	id int4 NOT NULL,
	id_area int4 NULL,
	id_name int4 NULL,
	id_data_vacancy int4 NULL,
	id_company int4 NULL,
	id_schedule int4 NULL,
	id_professional_roles int4 NULL,
	id_experience int4 NULL,
	id_employment int4 NULL,
	salary_from int4 NULL,
	salary_to int4 NULL,
	salary_currency text NULL,
	published_at timestamp NULL,
	vacancy_hash text NULL,
	id_working_time_modes int4 NULL,
	id_addres int4 NULL,
	id_working_time_intervals int4 NULL,
	id_working_days int4 NULL,
	copied_at timestamp DEFAULT CURRENT_TIMESTAMP NULL,
	has_test bool NULL,
	CONSTRAINT fk_fact_vacancy_fer_area FOREIGN KEY (id_area) REFERENCES core.ref_area(id),
	CONSTRAINT fk_fact_vacancy_fer_company FOREIGN KEY (id_company) REFERENCES core.ref_company(id),
	CONSTRAINT fk_fact_vacancy_fer_data_vacancy FOREIGN KEY (id_data_vacancy) REFERENCES core.ref_data_vacancy(id),
	CONSTRAINT fk_fact_vacancy_fer_employment FOREIGN KEY (id_employment) REFERENCES core.ref_employment(id),
	CONSTRAINT fk_fact_vacancy_fer_experience FOREIGN KEY (id_experience) REFERENCES core.ref_experience(id),
	CONSTRAINT fk_fact_vacancy_fer_name FOREIGN KEY (id_name) REFERENCES core.ref_name(id),
	CONSTRAINT fk_fact_vacancy_fer_professional_roles FOREIGN KEY (id_professional_roles) REFERENCES core.ref_professional_roles(id),
	CONSTRAINT fk_fact_vacancy_fer_schedule FOREIGN KEY (id_schedule) REFERENCES core.ref_schedule(id)
);