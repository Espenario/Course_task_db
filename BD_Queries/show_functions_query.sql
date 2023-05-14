Create or replace FUNCTION sp_ShowCompany(
	p_id BIGINT default -1,
	p_name VARCHAR(50) default 'PigConstruction'
) RETURNS setof tbl_company
as $$
	begin
		if (p_id != -1) then
			return query select * from tbl_company as c where c.company_id = p_id;
		else
			return query select * from tbl_company as c where c.company_name = p_name;
		end if;
	end;
$$ LANGUAGE plpgsql;


create or replace Function sp_ShowCompany_detail (
	p_id BIGINT DEFAULT 0
) returns table(
						company_id BIGINT,
						company_name VARCHAR(50), 
						date_of_founding DATE, 
						country VARCHAR(50),
						revenue MONEY,
						type_of_company VARCHAR(50),
	                    launch_id BIGINT,
						date_of_launch DATE, 
						rocket VARCHAR(50),
						payload TEXT,
						spacecraft_id BIGINT,
						sc_height INT,
						sc_width INT,
						sc_length INT,
						construction_cost MONEY,
						sc_name VARCHAR(50),
						design_cost MONEY,
						produjction_site VARCHAR(50),
						engine_type VARCHAR(50)
						)
as $$
	select
		c.company_id,
		c.company_name,
		c.date_of_founding,
		c.country,
		c.revenue,
		c.type_of_company,
		l.launch_id,
		l.date_of_launch,
		l.rocket,
		l.payload,
		s.spacecraft_id,
		s.sc_height,
		s.sc_width,
		s.sc_length,
		s.construction_cost,
		s.sc_name,
		s.design_cost,
		s.produjction_site,
		s.engine_type
	from tbl_company as c left join tbl_launch as l on l.launch_company_id = c.company_id
						  left join tbl_spacecraft as s on s.manufacturer_company_id = c.company_id
	where c.company_id = p_id
$$ language sql;

Create or replace FUNCTION sp_ShowLaunch(
	p_id BIGINT default -1,
	p_date VARCHAR(50) default '04.04.2003'
) RETURNS setof tbl_launch
as $$
	begin
		if (p_id != -1) then
			return query select * from tbl_launch as l where l.launch_id = p_id;
		else
			return query select * from tbl_launch as l where l.date_of_launch = p_date;
		end if;
	end;
$$ LANGUAGE plpgsql;

Create or replace FUNCTION sp_ShowLaunch_detail(
	p_id BIGINT default -1
) RETURNS table (
				launch_id BIGINT,
				date_of_launch DATE , 
				rocket VARCHAR(50),
				payload TEXT,
				launch_company_id BIGINT,
				company_name VARCHAR(50), 
				date_of_founding DATE, 
				country VARCHAR(50),
				revenue MONEY,
				type_of_company VARCHAR(50)
				)
as $$
	SELECT
		l.launch_id,
		l.date_of_launch,
		l.rocket,
		l.payload,
		l.launch_company_id,
		c.company_name,
		c.date_of_founding,
		c.country,
		c.revenue,
		c.type_of_company
	from tbl_launch as l left join tbl_company as c on c.company_id = l.launch_company_id
	where l.launch_id = p_id
						 
$$ LANGUAGE sql;









