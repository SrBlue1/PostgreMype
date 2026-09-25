GRANT USAGE ON SCHEMA public TO public;

CREATE ROLE rol_seguridad_pg;
GRANT SELECT, INSERT, UPDATE ON public.empleado TO rol_seguridad_pg;
GRANT SELECT, INSERT, UPDATE ON public.historial_login TO rol_seguridad_pg;
GRANT SELECT ON public.rol TO rol_seguridad_pg;
GRANT USAGE, SELECT ON ALL SEQUENCES IN SCHEMA public TO rol_seguridad_pg;

CREATE USER llanos WITH PASSWORD 'L123';
GRANT CREATE ON SCHEMA public TO llanos; 

GRANT rol_seguridad_pg TO llanos;



CREATE ROLE rol_configuracion_pg;
GRANT SELECT, INSERT, UPDATE ON public.comerciante TO rol_configuracion_pg;
GRANT SELECT, INSERT, UPDATE ON public.configuracion TO rol_configuracion_pg;
GRANT USAGE, SELECT ON ALL SEQUENCES IN SCHEMA public TO rol_configuracion_pg;

CREATE USER romero WITH PASSWORD 'R456';
GRANT CREATE ON SCHEMA public TO romero;

GRANT rol_configuracion_pg TO romero;



CREATE ROLE rol_sucursales_pg;
GRANT SELECT, INSERT, UPDATE ON public.sucursal TO rol_sucursales_pg;
GRANT SELECT ON public.comerciante TO rol_sucursales_pg;
GRANT USAGE, SELECT ON ALL SEQUENCES IN SCHEMA public TO rol_sucursales_pg;

CREATE USER mescua WITH PASSWORD 'M789';
GRANT CREATE ON SCHEMA public TO mescua;

GRANT rol_sucursales_pg TO mescua;



CREATE ROLE rol_analista_pg;
GRANT SELECT ON public.comerciante TO rol_analista_pg;
GRANT SELECT ON public.suscripcion TO rol_analista_pg;

CREATE USER zorrilla WITH PASSWORD 'Z012';
GRANT CREATE ON SCHEMA public TO zorrilla; 

GRANT rol_analista_pg TO zorrilla;