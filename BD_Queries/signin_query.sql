
Create or replace FUNCTION sp_createUser(
	p_name VARCHAR(20),
    p_username VARCHAR(20),
    p_password VARCHAR(20)
) RETURNS text
as $$
	BEGIN
		if ( select exists (select 1 from tbl_user where user_username = p_username) ) THEN

			return 'Username Exists !!';

		ELSE

			insert into tbl_user
			(
				user_name,
				user_username,
				user_password
			)
			values
			(
				p_name,
				p_username,
				p_password
			);
			return 'User created successfully';
		END IF;
	END;
$$ LANGUAGE plpgsql;

Create or replace function sp_validateLogin(
	p_username VARCHAR(20)
) returns tbl_user as $$
		select * from tbl_user where user_username = p_username;
$$ LANGUAGE sql;
