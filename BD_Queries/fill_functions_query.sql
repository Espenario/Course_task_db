Create or replace FUNCTION sp_addCompany(
	p_name VARCHAR(50),
	p_date_of_founding DATE, 
	p_country VARCHAR(50),
	p_revenue MONEY,
	p_type_of_company VARCHAR(50)
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
				p_company_name,
				p_date_of_founding,
				p_country,
				p_revenue,
				p_type_of_company
			);
	END;
$$ LANGUAGE plpgsql;

Select sp_addCompany('12-11-2011'::date, 'ooo', 3333::money, 'fff');