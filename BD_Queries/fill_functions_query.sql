
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
			select sp_addCompany(p_launch_company);
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
			select sp_addCompany(p_manufacturer_company_name);
		end if;
		select c.company_id into comp_id from tbl_company as c where levenshtein(c.company_name, p_manufacturer_company_name) <= 3 order by 1 limit 1;
		insert into tbl_spacecraft
			(
				sc_height,
				sc_width,
				sc_length,
				construction_cost,
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
				p_design_cost,
				comp_id,
				p_produjction_site,
				p_engine_type 
			);
	END;
$$ LANGUAGE plpgsql