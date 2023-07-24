CREATE OR REPLACE FUNCTION public.sp_procesar_registros()
 RETURNS character varying
 LANGUAGE plpgsql
AS $function$
declare
	_fecha varchar;

	begin

	_fecha='';

	/**********INICIO PASO 1**************/
	truncate table tiempo;
	insert into tiempo(fecha)
	select i::date from generate_series('2021-01-01',current_date, '1 day'::interval) i;
	
	/**********INICIO PASO 2**************/
	truncate table especie;
	insert into especie(id,especie,origen)
	Select *
	From dblink ('dbname=sigtp_prod42 port=5432 host=localhost user=postgres password=postgres',
	'select e.id,e.denominacion especie,o.denominacion origen  
	from especies e
	inner join origenes o on e.origen_id=o.id
	where o.id in (1,3)')ret (id int, especie varchar,origen varchar);

	/**********INICIO PASO 3**************/
	truncate table empresa;
	insert into empresa(id,ruc,razon_social)
	Select *
	From dblink ('dbname=sigtp_prod42 port=5432 host=localhost user=postgres password=postgres',
	'select id,ruc,razon_social from empresas order by 1')ret (id int, ruc varchar,razon_social varchar);

	/**********INICIO PASO 4**************/
	truncate table procedencia;
	insert into procedencia(id,procedencia)
	Select *
	From dblink ('dbname=sigtp_prod42 port=5432 host=localhost user=postgres password=postgres',
	'select id,denominacion from procedencias p order by 1')ret (id int, denominacion varchar);
	
	/**********INICIO PASO 5**************/
	truncate table ingreso_terminal;
	insert into ingreso_terminal(id_especie,id_empresa,id_procedencia,id_tiempo,peso)
	select id_especie,id_empresa,id_procedencia,t.id id_tiempo,peso from (
	Select *
	From dblink ('dbname=sigtp_prod42 port=5432 host=localhost user=postgres password=postgres',
	'select 
	e.id id_especie,e2.id id_empresa,p.id id_procedencia,
	to_char(fecha_ingreso,''yyyy-mm-dd'')fecha_ingreso,
	sum(abs(iv.peso_ingreso::decimal-iv.peso_salida::decimal)*pc.porcentaje/100) peso
	from especies e 
	inner join producto_cargas pc on e.denominacion=pc.producto 
	inner join ingreso_vehiculos iv on pc.ingreso_vehiculos_id=iv.id 
	inner join empresas e2 on iv.dueno_carga_documento=e2.ruc 
	inner join procedencias p on iv.procedencia=p.denominacion 
	where iv.estado=''Afuera''
	and pc.porcentaje!=0
	and iv.peso_salida<iv.peso_ingreso
	group by e.id,e2.id,p.id,to_char(fecha_ingreso,''yyyy-mm-dd'')
	order by to_char(fecha_ingreso,''yyyy-mm-dd'')::date desc,e.id')ret (id_especie int, id_empresa int, id_procedencia int, fecha_ingreso varchar, peso decimal)
	)R
	inner join tiempo t on R.fecha_ingreso=t.fecha;	


	return _fecha;	
	--return idp;
	/*EXCEPTION
	WHEN OTHERS THEN
        idp:=-1;
	return idp;*/
end;
$function$
;

