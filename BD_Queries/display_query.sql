Drop function if exists sp_showCompany

Create or replace FUNCTION sp_addCompany(
	p_date_of_founding DATE, 
	p_country VARCHAR(50),
	p_revenue MONEY,
	p_type_of_company VARCHAR(50)
) RETURNS void
as $$
	BEGIN
		insert into tbl_company
			(
				date_of_founding, 
				country,
				revenue,
				type_of_company
			)
			values
			(
				p_date_of_founding,
				p_country,
				p_revenue,
				p_type_of_company
			);
	END;
$$ LANGUAGE plpgsql;