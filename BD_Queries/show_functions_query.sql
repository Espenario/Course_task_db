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


Create or replace FUNCTION sp_ShowSpacecraft(
	p_id BIGINT default -1,
	p_name VARCHAR(50) default 'Pig'
) RETURNS setof tbl_spacecraft
as $$
	begin
		if (p_id != -1) then
			return query select * from tbl_spacecraft as s where s.spacecraft_id = p_id;
		else
			return query select * from tbl_spacecraft as s where s.sc_name = p_name;
		end if;
	end;
$$ LANGUAGE plpgsql;

Create or replace FUNCTION sp_ShowSpacecraft_detail(
	p_id BIGINT default -1,
	p_name VARCHAR(50) default 'Pig'
) RETURNS setof tbl_spacecraft
as $$
	begin
		if (p_id != -1) then
			return query select * from tbl_spacecraft as s where s.spacecraft_id = p_id;
		else
			return query select * from tbl_spacecraft as s where s.sc_name = p_name;
		end if;
	end;
$$ LANGUAGE plpgsql;

Create or replace FUNCTION sp_showneobject(
	sc_id BIGINT default -1,
	neo_id BIGINT default 0
) RETURNS setof tbl_NEObject
as $$
	begin
		if (sc_id != -1) then
			return query select * from tbl_NEObject as n where n.neo_vehicle_id = neo_id and n.spacecraft_id = sc_id;
		else
			return query select * from tbl_NEObject as n where n.neo_vehicle_id = neo_id;
		end if;
	end;
$$ LANGUAGE plpgsql;

Create or replace FUNCTION sp_ShowNEobject_detail(
	neo_id BIGINT default 0
) RETURNS table (
				neo_vehicle_id BIGINT,
				spacecraft_id BIGINT,
				type_of_mission VARCHAR(50), 
				orbit_type VARCHAR(50),
				altitude INT,
				speed REAL,
				sc_height INT,
				sc_width INT,
				sc_length INT,
				construction_cost MONEY
				)
as $$
	SELECT
		n.neo_vehicle_id, 
		n.spacecraft_id,
		n.type_of_mission, 
		n.orbit_type,
		n.altitude,
		n.speed,
		s.sc_height,
		s.sc_width,
		s.sc_length,
		s.construction_cost
	from tbl_NEObject as n left join tbl_spacecraft as s on n.spacecraft_id = s.spacecraft_id
	where n.neo_vehicle_id = neo_id
$$ LANGUAGE sql;


Create or replace FUNCTION sp_showtransport(
	sc_id BIGINT default -1,
	tr_id BIGINT default 0
) RETURNS setof tbl_transport
as $$
	begin
		if (sc_id != -1) then
			return query select * from tbl_transport as t where t.transport_vehicle_id = tr_id and t.spacecraft_id = sc_id;
		else
			return query select * from tbl_transport as t where t.transport_vehicle_id = tr_id;
		end if;
	end;
$$ LANGUAGE plpgsql;

Create or replace FUNCTION sp_ShowTransport_detail(
	tr_id BIGINT default 0
) RETURNS table (
				transport_vehicle_id BIGINT,
				spacecraft_id BIGINT,
				cargo_volume INT,
				speed REAL,
				cur_destination TEXT, 
				type_of_cargo TEXT,
				sc_height INT,
				sc_width INT,
				sc_length INT,
				construction_cost MONEY
				)
as $$
	SELECT
		t.transport_vehicle_id,
		t.spacecraft_id,
		t.cargo_volume,
		t.speed,
		t.cur_destination, 
		t.type_of_cargo,
		s.sc_height,
		s.sc_width,
		s.sc_length,
		s.construction_cost
	from tbl_transport as t left join tbl_spacecraft as s on t.spacecraft_id = s.spacecraft_id
	where t.transport_vehicle_id = tr_id
$$ LANGUAGE sql;

Create or replace FUNCTION sp_showmining(
	sc_id BIGINT default -1,
	mn_id BIGINT default 0
) RETURNS setof tbl_mining
as $$
	begin
		if (sc_id != -1) then
			return query select * from tbl_mining as m where m.mining_vehicle_id = mn_id and m.spacecraft_id = sc_id;
		else
			return query select * from tbl_mining as m where m.mining_vehicle_id = mn_id;
		end if;
	end;
$$ LANGUAGE plpgsql;

Create or replace FUNCTION sp_ShowMining_detail(
	mn_id BIGINT default 0
) RETURNS table (
				mining_vehicle_id BIGINT,
				spacecraft_id BIGINT,
				production_rate INT,
				mining_material VARCHAR(50),
				start_of_service DATE,
				planned_end_of_service DATE,
				sc_height INT,
				sc_width INT,
				sc_length INT,
				construction_cost MONEY
				)
as $$
	SELECT
		m.mining_vehicle_id,
		m.spacecraft_id,
		m.production_rate,
		m.mining_material,
		m.start_of_service,
		m.planned_end_of_service,
		s.sc_height,
		s.sc_width,
		s.sc_length,
		s.construction_cost
	from tbl_mining as m left join tbl_spacecraft as s on m.spacecraft_id = s.spacecraft_id
	where m.mining_vehicle_id = mn_id
$$ LANGUAGE sql;


Create or replace FUNCTION sp_showresearch(
	sc_id BIGINT default -1,
	rs_id BIGINT default 0
) RETURNS setof tbl_research
as $$
	begin
		if (sc_id != -1) then
			return query select * from tbl_research as r where r.research_vehicle_id = rs_id and r.spacecraft_id = sc_id;
		else
			return query select * from tbl_research as r where r.research_vehicle_id = rs_id;
		end if;
	end;
$$ LANGUAGE plpgsql;

Create or replace FUNCTION sp_ShowResearch_detail(
	rs_id BIGINT default 0
) RETURNS table (
				research_vehicle_id BIGINT,
				spacecraft_id BIGINT,
				object_of_study VARCHAR(50),
				instruments_onboard TEXT,
				start_of_service DATE,
				sc_height INT,
				sc_width INT,
				sc_length INT,
				construction_cost MONEY
				)
as $$
	SELECT
		r.research_vehicle_id,
		r.spacecraft_id,
		r.object_of_study,
		r.instruments_onboard,
		r.start_of_service,
		s.sc_height,
		s.sc_width,
		s.sc_length,
		s.construction_cost
	from tbl_research as r left join tbl_spacecraft as s on r.spacecraft_id = s.spacecraft_id
	where r.research_vehicle_id = rs_id
$$ LANGUAGE sql;







