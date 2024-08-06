-- таблица с данными о вакансиях
CREATE TABLE stage.stage_pars_hh (
	id int8 NULL,
	"name" text NULL,
	area text NULL,
	alternate_url text NULL,
	approved bool NULL,
	archived bool NULL,
	description text NULL,
	employer_name text NULL,
	employer_url text NULL,
	employment text NULL,
	experience text NULL,
	has_test bool NULL,
	initial_created_at timestamp NULL,
	premium bool NULL,
	published_at timestamp NULL,
	created_at timestamp NULL,
	professional_roles text NULL,
	working_days text NULL,
	working_time_intervals text NULL,
	working_time_modes text NULL,
	salary_from float8 NULL,
	salary_to float8 NULL,
	salary_currency text NULL,
	schedule text NULL,
	address_city text NULL,
	address_street text NULL,
	address_lat float8 NULL,
	address_lng float8 NULL,
	vacancy_hash text NULL,
	status int4 NULL
);

-- таблица с навыками
CREATE TABLE stage.stage_pars_hh_skill (
	id int8 NULL,
	skill text NULL
);