create or replace package  "API_FONT_PKG"
as

procedure font_name_extraction;

end;
/
create or replace package body "API_FONT_PKG"
as
	g_package										constant varchar2(30 char)	:= 'api_eo_pkg';

procedure font_name_extraction 
as
/* the call
begin
	api_font_pkg.font_name_extraction;
end;
*/
-- christina moore nov2022
	l_procedure				varchar2(100 char)	:= g_package || '.font_name_extraction';
	l_max							number							:= 0;
	l_start						number							:= 1;
	l_end							number							:= 1;
	l_snip_length			number							:= 0;
	l_select_count		number;
	l_font_css				clob;
	l_font_name				varchar2(4000 char);
begin
	apex_debug.message('begin: ' || l_procedure);
	select 
		body,
		dbms_lob.getlength(body) len
	into
		l_font_css,
		l_max
	from api_staging
	where staging_pk = 1340676;
	
	for i in 1 .. l_max loop
		l_start := instr(l_font_css,'}.',l_start) + 2;
		l_end		:= instr(l_font_css,':be',l_start);
		if l_start < l_end then
			l_snip_length :=  l_end - l_start;
		else
			l_snip_length := 4000;
		end if;
		l_font_name 	:= dbms_lob.substr (
			lob_loc => l_font_css,
			amount	=> l_snip_length,
			offset	=> l_start
			);
		if l_font_name like 'fa-%' then
			select count(1) into l_select_count
				from lu_font
				where font_pk = l_font_name;
			if l_select_count = 0 then
				insert into lu_font (
					font_pk
				) values (
				l_font_name
				);
			end if;
			--dbms_output.put_line(l_font_name);
		end if;
		l_start			:= l_end;		
	end loop;
	commit;
	apex_debug.message('end: ' || l_procedure);
end font_name_extraction;

end;
/
