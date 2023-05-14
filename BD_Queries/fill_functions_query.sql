
Create or replace FUNCTION sp_addCompany(
	p_name VARCHAR(50) default null,
	p_country VARCHAR(50) default 'Russia',
	p_revenue MONEY default null,
	p_type_of_company VARCHAR(50) default 'private',
	p_date_of_founding DATE = '04.04.2003'
) RETURNS void
as $$
	BEGIN
		insert into tbl_company
			(	
				company_name,
				date_of_founding, 
				country,
				revenue,
				type_of_company
			)
			values
			(	
				p_name,
				p_date_of_founding,
				p_country,
				p_revenue,
				p_type_of_company
			);
	END;
$$ LANGUAGE plpgsql;

Create or replace Function sp_addLaunch(
	p_rocket VARCHAR(50) default null,
	p_payload TEXT default 'Pigs',
	p_launch_company VARCHAR(50) default 'SpacePig',
	p_date_of_launch DATE = current_date
) RETURNS void
as $$ 
	declare comp_id BIGINT;
	BEGIN
		select c.company_id into comp_id from tbl_company as c where levenshtein(c.company_name, p_launch_company) <= 3 order by 1 limit 1; 
		if (comp_id is null) then 
			perform sp_addCompany(p_launch_company);
		end if;
		select c.company_id into comp_id from tbl_company as c where levenshtein(c.company_name, p_launch_company) <= 3 order by 1 limit 1;
		insert into tbl_launch
			(
				date_of_launch, 
				rocket,
				payload,
				launch_company_id
			)
			values 
			(
				p_date_of_launch, 
				p_rocket,
				p_payload,
				comp_id  
			);
	END;
$$ LANGUAGE plpgsql;

Create or replace Function sp_addSpacecraft(
	p_sc_height INT default null,
	p_sc_width INT default null,
	p_sc_length INT default null,
	p_construction_cost MONEY default null,
	p_name VARCHAR(50) default 'PigCraft',
	p_design_cost MONEY default null,
	p_manufacturer_company_name VARCHAR(50) default 'PigConstruction',
	p_produjction_site VARCHAR(50) default 'Moscow, Russia',
	p_engine_type VARCHAR(50) default null
) RETURNS void
as $$ 
	declare comp_id BIGINT;
	BEGIN
		select c.company_id into comp_id from tbl_company as c where levenshtein(c.company_name, p_manufacturer_company_name) <= 3 order by 1 limit 1; 
		if (comp_id is null) then 
			perform sp_addCompany(p_manufacturer_company_name);
		end if;
		select c.company_id into comp_id from tbl_company as c where levenshtein(c.company_name, p_manufacturer_company_name) <= 3 order by 1 limit 1;
		insert into tbl_spacecraft
			(
				sc_height,
				sc_width,
				sc_length,
				construction_cost,
				sc_name,
				design_cost,
				manufacturer_company_id,
				produjction_site,
				engine_type
			)
			values 
			(
				p_sc_height,
				p_sc_width,
				p_sc_length,
				p_construction_cost,
				p_name,
				p_design_cost,
				comp_id,
				p_produjction_site,
				p_engine_type 
			);
	END;
$$ LANGUAGE plpgsql;

Create or replace Function sp_addNeObject(
	p_spacecraft_name VARCHAR(50) default 'PigCraft',
	p_mission VARCHAR(50) default 'Reseach', 
	p_orbit VARCHAR(50) default null,
	p_altitude INT default 400,
	p_speed REAL default 8.0
) RETURNS void
as $$ 
	declare sc_id BIGINT;
	BEGIN
		select s.spacecraft_id into sc_id from tbl_spacecraft as s where levenshtein(s.sc_name, p_spacecraft_name) <= 3 order by 1 limit 1; 
		if (sc_id is null) then 
			perform sp_addspacecraft(p_name := p_spacecraft_name);
		end if;
		select s.spacecraft_id into sc_id from tbl_spacecraft as s where levenshtein(s.sc_name, p_spacecraft_name) <= 3 order by 1 limit 1; 
		insert into tbl_NEObject
			(
				spacecraft_id,
				type_of_mission, 
				orbit_type,
				altitude,
				speed
			)
			values 
			(
				sc_id,
				p_mission, 
				p_orbit,
				p_altitude,
				p_speed
			);
	END;
$$ LANGUAGE plpgsql;


Create or replace Function sp_addTransport(
	p_spacecraft_name VARCHAR(50) default 'PigCraft',
	p_cargo_volume INT default 10, 
	p_speed REAL default 10.0, 
	p_cur_destination TEXT default 'Mars',
	p_cargo_type TEXT default 'Pigs and Donats'
) RETURNS void
as $$ 
	declare sc_id BIGINT;
	BEGIN
		select s.spacecraft_id into sc_id from tbl_spacecraft as s where levenshtein(s.sc_name, p_spacecraft_name) <= 3 order by 1 limit 1; 
		if (sc_id is null) then 
			perform sp_addSpacecraft(p_name := p_spacecraft_name);
		end if;
		select s.spacecraft_id into sc_id from tbl_spacecraft as s where levenshtein(s.sc_name, p_spacecraft_name) <= 3 order by 1 limit 1; 
		insert into tbl_transport
			(
				spacecraft_id,
				cargo_volume,
				speed,
				cur_destination, 
				type_of_cargo
			)
			values 
			(
				sc_id,
				p_cargo_volume, 
				p_speed, 
				p_cur_destination,
				p_cargo_type
			);
	END;
$$ LANGUAGE plpgsql;

Create or replace Function sp_addMining(
	p_spacecraft_name VARCHAR(50) default 'PigCraft',
	p_production_rate INT default 1, 
	p_material TEXT default 'Water', 
	p_start_of_service DATE default CURRENT_DATE,
	p_planned_end_of_service DATE default CURRENT_DATE + interval '10 years'
) RETURNS void
as $$ 
	declare sc_id BIGINT;
	BEGIN
		select s.spacecraft_id into sc_id from tbl_spacecraft as s where levenshtein(s.sc_name, p_spacecraft_name) <= 3 order by 1 limit 1; 
		if (sc_id is null) then 
			perform sp_addSpacecraft(p_name := p_spacecraft_name);
		end if;
		select s.spacecraft_id into sc_id from tbl_spacecraft as s where levenshtein(s.sc_name, p_spacecraft_name) <= 3 order by 1 limit 1; 
		insert into tbl_mining
			(
				spacecraft_id,
				production_rate,
				mining_material,
				start_of_service, 
				planned_end_of_service
			)
			values 
			(
				sc_id,
				p_production_rate,
				p_material,
				p_start_of_service, 
				p_planned_end_of_service
			);
	END;
$$ LANGUAGE plpgsql;

Create or replace Function sp_addResearch(
	p_spacecraft_name VARCHAR(50) default 'PigCraft',
	p_object_of_study VARCHAR(50) default 'Space Pigs', 
	p_instruments_onboard TEXT default 'Camera', 
	p_start_of_service DATE default CURRENT_DATE
) RETURNS void
as $$ 
	declare sc_id BIGINT;
	BEGIN
		select s.spacecraft_id into sc_id from tbl_spacecraft as s where levenshtein(s.sc_name, p_spacecraft_name) <= 3 order by 1 limit 1; 
		if (sc_id is null) then 
			perform sp_addSpacecraft(p_name := p_spacecraft_name);
		end if;
		select s.spacecraft_id into sc_id from tbl_spacecraft as s where levenshtein(s.sc_name, p_spacecraft_name) <= 3 order by 1 limit 1; 
		insert into tbl_research
			(
				spacecraft_id,
				object_of_study,
				instruments_onboard,
				start_of_service
			)
			values 
			(
				sc_id,
				p_object_of_study,
				p_instruments_onboard,
				p_start_of_service
			);
	END;
$$ LANGUAGE plpgsql