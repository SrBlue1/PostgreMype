--
-- PostgreSQL database dump
--

\restrict W9o6WuS3OL78fXI5ip87FIMR2zZTkYSIrkg8PgSvTD0hDmnbdbs0RrkYLubE49s

-- Dumped from database version 17.11
-- Dumped by pg_dump version 17.11

-- Started on 2026-09-25 20:26:44

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET transaction_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- TOC entry 232 (class 1255 OID 24779)
-- Name: fn_obtener_igv_comerciante(integer); Type: FUNCTION; Schema: public; Owner: romero
--

CREATE FUNCTION public.fn_obtener_igv_comerciante(p_id_comerciante integer) RETURNS numeric
    LANGUAGE plpgsql STABLE
    AS $$
DECLARE
    c_igv_contingencia CONSTANT NUMERIC(4,2) := 18.00;
    v_igv NUMERIC(4,2);
BEGIN
    IF p_id_comerciante IS NULL THEN
        RETURN c_igv_contingencia;
    END IF;

    SELECT igv_porcentaje
    INTO v_igv
    FROM public.configuracion
    WHERE comerciante_id_comerciante = p_id_comerciante;

    
    IF NOT FOUND OR v_igv IS NULL THEN
        RETURN c_igv_contingencia;
    END IF;

    RETURN v_igv;
END;
$$;


ALTER FUNCTION public.fn_obtener_igv_comerciante(p_id_comerciante integer) OWNER TO romero;

--
-- TOC entry 231 (class 1255 OID 24777)
-- Name: fn_registrar_acceso_llanos(integer, character varying); Type: FUNCTION; Schema: public; Owner: llanos
--

CREATE FUNCTION public.fn_registrar_acceso_llanos(p_id_empleado integer, p_dispositivo character varying) RETURNS void
    LANGUAGE plpgsql
    AS $$
BEGIN
    -- Validar la integridad referencial antes de auditar el acceso
    IF EXISTS (SELECT 1 FROM public.empleado WHERE id_empleado = p_id_empleado) THEN
        INSERT INTO public.historial_login (dispositivo, empleado_id_empleado) 
        VALUES (p_dispositivo, p_id_empleado);
    ELSE
        RAISE EXCEPTION 'Error de seguridad: El ID de empleado % no existe.', p_id_empleado;
    END IF;
END;
$$;


ALTER FUNCTION public.fn_registrar_acceso_llanos(p_id_empleado integer, p_dispositivo character varying) OWNER TO llanos;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- TOC entry 220 (class 1259 OID 24668)
-- Name: comerciante; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.comerciante (
    id_comerciante integer NOT NULL,
    ruc character varying(11) NOT NULL,
    nombre_comcercial character varying(150) NOT NULL,
    razon_social character varying(150) NOT NULL,
    telefono character varying(9) NOT NULL,
    fecha_registro timestamp without time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.comerciante OWNER TO postgres;

--
-- TOC entry 219 (class 1259 OID 24667)
-- Name: comerciante_id_comerciante_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.comerciante ALTER COLUMN id_comerciante ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.comerciante_id_comerciante_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 222 (class 1259 OID 24679)
-- Name: configuracion; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.configuracion (
    id_configuracion integer NOT NULL,
    moneda character varying(3) DEFAULT 'PEN'::character varying NOT NULL,
    igv_porcentaje numeric(4,2) DEFAULT 18.00 NOT NULL,
    comerciante_id_comerciante integer NOT NULL
);


ALTER TABLE public.configuracion OWNER TO postgres;

--
-- TOC entry 221 (class 1259 OID 24678)
-- Name: configuracion_id_configuracion_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.configuracion ALTER COLUMN id_configuracion ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.configuracion_id_configuracion_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 224 (class 1259 OID 24688)
-- Name: empleado; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.empleado (
    id_empleado integer NOT NULL,
    dni character varying(8) NOT NULL,
    nombres character varying(100) NOT NULL,
    apellidos character varying(100) NOT NULL,
    correo character varying(100) NOT NULL,
    clave character varying(255) NOT NULL,
    estado boolean NOT NULL,
    rol_id_rol integer NOT NULL,
    sucursal_id_sucursal integer NOT NULL
);


ALTER TABLE public.empleado OWNER TO postgres;

--
-- TOC entry 223 (class 1259 OID 24687)
-- Name: empleado_id_empleado_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.empleado ALTER COLUMN id_empleado ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.empleado_id_empleado_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 230 (class 1259 OID 24715)
-- Name: historial_login; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.historial_login (
    id_log integer NOT NULL,
    fecha_hora timestamp without time zone DEFAULT now() NOT NULL,
    dispositivo character varying(150) NOT NULL,
    empleado_id_empleado integer NOT NULL
);


ALTER TABLE public.historial_login OWNER TO postgres;

--
-- TOC entry 229 (class 1259 OID 24714)
-- Name: historial_login_id_log_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.historial_login ALTER COLUMN id_log ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.historial_login_id_log_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 218 (class 1259 OID 24658)
-- Name: rol; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.rol (
    id_rol integer NOT NULL,
    nombre_rol character varying(50) NOT NULL,
    descripcion text NOT NULL
);


ALTER TABLE public.rol OWNER TO postgres;

--
-- TOC entry 217 (class 1259 OID 24657)
-- Name: rol_id_rol_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.rol ALTER COLUMN id_rol ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.rol_id_rol_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 226 (class 1259 OID 24700)
-- Name: sucursal; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.sucursal (
    id_sucursal integer NOT NULL,
    nombre_sucursal character varying(100) NOT NULL,
    direccion character varying(250) NOT NULL,
    comerciante_id_comerciante integer NOT NULL
);


ALTER TABLE public.sucursal OWNER TO postgres;

--
-- TOC entry 225 (class 1259 OID 24699)
-- Name: sucursal_id_sucursal_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.sucursal ALTER COLUMN id_sucursal ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.sucursal_id_sucursal_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 228 (class 1259 OID 24708)
-- Name: suscripcion; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.suscripcion (
    id_suscripcion integer NOT NULL,
    tipo_plan character varying(50) NOT NULL,
    fecha_inicio date DEFAULT now() NOT NULL,
    fecha_fin date NOT NULL,
    estado_pago character varying(20) NOT NULL,
    comerciante_id_comerciante integer NOT NULL
);


ALTER TABLE public.suscripcion OWNER TO postgres;

--
-- TOC entry 227 (class 1259 OID 24707)
-- Name: suscripcion_id_suscripcion_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.suscripcion ALTER COLUMN id_suscripcion ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.suscripcion_id_suscripcion_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 4965 (class 0 OID 24668)
-- Dependencies: 220
-- Data for Name: comerciante; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.comerciante (id_comerciante, ruc, nombre_comcercial, razon_social, telefono, fecha_registro) FROM stdin;
1	20601234561	Minimarket Don Lucho	Inversiones Comerciales Lucho S.A.C.	912345678	2026-09-19 16:12:53.042136
2	20559876542	Boutique Mía	Corporación Textil Moda del Perú E.I.R.L.	987654321	2026-09-19 16:12:53.042136
3	20441122333	TecnoWilson	Importaciones Tecnológicas del Centro S.A.	944556677	2026-09-19 16:12:53.042136
\.


--
-- TOC entry 4967 (class 0 OID 24679)
-- Dependencies: 222
-- Data for Name: configuracion; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.configuracion (id_configuracion, moneda, igv_porcentaje, comerciante_id_comerciante) FROM stdin;
1	PEN	18.00	1
2	PEN	18.00	2
3	USD	18.00	3
\.


--
-- TOC entry 4969 (class 0 OID 24688)
-- Dependencies: 224
-- Data for Name: empleado; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.empleado (id_empleado, dni, nombres, apellidos, correo, clave, estado, rol_id_rol, sucursal_id_sucursal) FROM stdin;
1	45678901	Luis Alberto	Mendoza Castro	luis.mendoza@donlucho.com	hash_secure_password_1	t	1	1
2	71234567	Carlos Ivan	Gomez Rivas	carlos.gomez@donlucho.com	hash_secure_password_2	t	2	2
3	72345678	Ana Maria	Palacios Quispe	ana.palacios@donlucho.com	hash_secure_password_3	t	3	1
4	73456789	Pedro Jose	Huaman Ortiz	pedro.huaman@donlucho.com	hash_secure_password_4	t	3	2
5	40112233	Milagros Elena	Salazar Paz	m.salazar@boutiquemia.pe	hash_secure_password_5	t	1	3
6	41223344	Sofia Belen	Díaz Torres	s.diaz@boutiquemia.pe	hash_secure_password_6	t	2	4
7	42334455	Jorge Luis	Guerrero Flores	j.guerrero@boutiquemia.pe	hash_secure_password_7	t	3	3
8	43445566	Elena Maria	Benites Soto	e.benites@boutiquemia.pe	hash_secure_password_8	f	3	4
9	46556677	Ricardo Alfonzo	Vargas Luna	rvargas@tecnowilson.com	hash_secure_password_9	t	1	5
10	47667788	Christian David	Zegarra Rios	czegarra@tecnowilson.com	hash_secure_password_10	t	3	5
\.


--
-- TOC entry 4975 (class 0 OID 24715)
-- Dependencies: 230
-- Data for Name: historial_login; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.historial_login (id_log, fecha_hora, dispositivo, empleado_id_empleado) FROM stdin;
1	2026-09-19 08:00:23	Windows 11 - Chrome V120	1
2	2026-09-19 08:15:10	Android 14 - App Mobile	2
3	2026-09-19 08:30:00	Windows 10 - Edge V119	3
4	2026-09-19 08:45:12	Windows 11 - Chrome V120	4
5	2026-09-19 09:00:05	macOS Sonoma - Safari V17	5
6	2026-09-19 09:05:44	iOS 17 - App Mobile	6
7	2026-09-19 09:15:30	Windows 10 - Chrome V120	7
8	2026-09-19 09:30:18	Windows 11 - Firefox V121	9
9	2026-09-19 09:45:00	Windows 11 - Chrome V120	10
10	2026-09-19 14:22:15	Windows 11 - Chrome V120	1
11	2026-09-22 17:52:21.197757	Android App - Xiaomi Redmi Note 13	1
\.


--
-- TOC entry 4963 (class 0 OID 24658)
-- Dependencies: 218
-- Data for Name: rol; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.rol (id_rol, nombre_rol, descripcion) FROM stdin;
1	Administrador	Acceso total al sistema, configuraciones globales y gestión de sucursales.
2	Supervisor	Gestión operativa de la sucursal asignada, reportes y control de personal.
3	Cajero	Operaciones exclusivas del punto de venta, apertura, facturación y cierre de caja.
\.


--
-- TOC entry 4971 (class 0 OID 24700)
-- Dependencies: 226
-- Data for Name: sucursal; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.sucursal (id_sucursal, nombre_sucursal, direccion, comerciante_id_comerciante) FROM stdin;
1	Don Lucho - Sede Principal Los Olivos	Av. Las Palmeras 1420, Los Olivos, Lima	1
2	Don Lucho - Express San Juan	Av. Chimú 455, San Juan de Lurigancho, Lima	1
3	Boutique Mía - Real Plaza Salaverry	Av. Salaverry 2370, Jesús María, Lima	2
4	Boutique Mía - Jockey Plaza	Av. Javier Prado Este 4200, Santiago de Surco, Lima	2
5	TecnoWilson - Principal Cercado	Av. Garcilaso de la Vega 1250, Cercado de Lima	3
\.


--
-- TOC entry 4973 (class 0 OID 24708)
-- Dependencies: 228
-- Data for Name: suscripcion; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.suscripcion (id_suscripcion, tipo_plan, fecha_inicio, fecha_fin, estado_pago, comerciante_id_comerciante) FROM stdin;
1	Plan Emprende Mensual	2026-09-01	2026-10-01	Activo	1
2	Plan Corporativo Anual	2026-01-15	2027-01-15	Activo	2
3	Plan Emprende Mensual	2026-09-10	2026-10-10	Activo	3
\.


--
-- TOC entry 4995 (class 0 OID 0)
-- Dependencies: 219
-- Name: comerciante_id_comerciante_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.comerciante_id_comerciante_seq', 3, true);


--
-- TOC entry 4996 (class 0 OID 0)
-- Dependencies: 221
-- Name: configuracion_id_configuracion_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.configuracion_id_configuracion_seq', 3, true);


--
-- TOC entry 4997 (class 0 OID 0)
-- Dependencies: 223
-- Name: empleado_id_empleado_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.empleado_id_empleado_seq', 10, true);


--
-- TOC entry 4998 (class 0 OID 0)
-- Dependencies: 229
-- Name: historial_login_id_log_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.historial_login_id_log_seq', 11, true);


--
-- TOC entry 4999 (class 0 OID 0)
-- Dependencies: 217
-- Name: rol_id_rol_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.rol_id_rol_seq', 3, true);


--
-- TOC entry 5000 (class 0 OID 0)
-- Dependencies: 225
-- Name: sucursal_id_sucursal_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.sucursal_id_sucursal_seq', 5, true);


--
-- TOC entry 5001 (class 0 OID 0)
-- Dependencies: 227
-- Name: suscripcion_id_suscripcion_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.suscripcion_id_suscripcion_seq', 3, true);


--
-- TOC entry 4784 (class 2606 OID 24673)
-- Name: comerciante comerciante_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.comerciante
    ADD CONSTRAINT comerciante_pkey PRIMARY KEY (id_comerciante);


--
-- TOC entry 4793 (class 2606 OID 24686)
-- Name: configuracion configuracion_comerciante_id_comerciante_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.configuracion
    ADD CONSTRAINT configuracion_comerciante_id_comerciante_key UNIQUE (comerciante_id_comerciante);


--
-- TOC entry 4795 (class 2606 OID 24684)
-- Name: configuracion configuracion_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.configuracion
    ADD CONSTRAINT configuracion_pkey PRIMARY KEY (id_configuracion);


--
-- TOC entry 4797 (class 2606 OID 24698)
-- Name: empleado correo_uq; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.empleado
    ADD CONSTRAINT correo_uq UNIQUE (correo);


--
-- TOC entry 4799 (class 2606 OID 24696)
-- Name: empleado dni_uq; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.empleado
    ADD CONSTRAINT dni_uq UNIQUE (dni);


--
-- TOC entry 4801 (class 2606 OID 24694)
-- Name: empleado empleado_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.empleado
    ADD CONSTRAINT empleado_pkey PRIMARY KEY (id_empleado);


--
-- TOC entry 4810 (class 2606 OID 24720)
-- Name: historial_login historial_login_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.historial_login
    ADD CONSTRAINT historial_login_pkey PRIMARY KEY (id_log);


--
-- TOC entry 4780 (class 2606 OID 24666)
-- Name: rol nom_rol_UQ; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.rol
    ADD CONSTRAINT "nom_rol_UQ" UNIQUE (nombre_rol);


--
-- TOC entry 4804 (class 2606 OID 24706)
-- Name: sucursal nom_sucursal_uq; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.sucursal
    ADD CONSTRAINT nom_sucursal_uq UNIQUE (nombre_sucursal);


--
-- TOC entry 4787 (class 2606 OID 24677)
-- Name: comerciante razon_uq; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.comerciante
    ADD CONSTRAINT razon_uq UNIQUE (razon_social);


--
-- TOC entry 4782 (class 2606 OID 24664)
-- Name: rol rol_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.rol
    ADD CONSTRAINT rol_pkey PRIMARY KEY (id_rol);


--
-- TOC entry 4789 (class 2606 OID 24752)
-- Name: comerciante ruc_uq; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.comerciante
    ADD CONSTRAINT ruc_uq UNIQUE (ruc);


--
-- TOC entry 4806 (class 2606 OID 24704)
-- Name: sucursal sucursal_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.sucursal
    ADD CONSTRAINT sucursal_pkey PRIMARY KEY (id_sucursal);


--
-- TOC entry 4808 (class 2606 OID 24713)
-- Name: suscripcion suscripcion_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.suscripcion
    ADD CONSTRAINT suscripcion_pkey PRIMARY KEY (id_suscripcion);


--
-- TOC entry 4791 (class 2606 OID 24675)
-- Name: comerciante telefono_uq; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.comerciante
    ADD CONSTRAINT telefono_uq UNIQUE (telefono);


--
-- TOC entry 4785 (class 1259 OID 24780)
-- Name: idx_comerciante_ruc; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_comerciante_ruc ON public.comerciante USING btree (ruc);


--
-- TOC entry 4802 (class 1259 OID 24778)
-- Name: idx_empleado_estado_llanos; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_empleado_estado_llanos ON public.empleado USING btree (estado);


--
-- TOC entry 4811 (class 2606 OID 24721)
-- Name: configuracion configuracion_comerciante_id_comerciante_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.configuracion
    ADD CONSTRAINT configuracion_comerciante_id_comerciante_fkey FOREIGN KEY (comerciante_id_comerciante) REFERENCES public.comerciante(id_comerciante) NOT VALID;


--
-- TOC entry 4812 (class 2606 OID 24726)
-- Name: empleado empleado_rol_id_rol_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.empleado
    ADD CONSTRAINT empleado_rol_id_rol_fkey FOREIGN KEY (rol_id_rol) REFERENCES public.rol(id_rol) NOT VALID;


--
-- TOC entry 4813 (class 2606 OID 24731)
-- Name: empleado empleado_sucursal_id_sucursal_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.empleado
    ADD CONSTRAINT empleado_sucursal_id_sucursal_fkey FOREIGN KEY (sucursal_id_sucursal) REFERENCES public.sucursal(id_sucursal) NOT VALID;


--
-- TOC entry 4816 (class 2606 OID 24746)
-- Name: historial_login historial_login_empleado_id_empleado_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.historial_login
    ADD CONSTRAINT historial_login_empleado_id_empleado_fkey FOREIGN KEY (empleado_id_empleado) REFERENCES public.empleado(id_empleado) NOT VALID;


--
-- TOC entry 4814 (class 2606 OID 24736)
-- Name: sucursal sucursal_comerciante_id_comerciante_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.sucursal
    ADD CONSTRAINT sucursal_comerciante_id_comerciante_fkey FOREIGN KEY (comerciante_id_comerciante) REFERENCES public.comerciante(id_comerciante) NOT VALID;


--
-- TOC entry 4815 (class 2606 OID 24741)
-- Name: suscripcion suscripcion_comerciante_id_comerciante_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.suscripcion
    ADD CONSTRAINT suscripcion_comerciante_id_comerciante_fkey FOREIGN KEY (comerciante_id_comerciante) REFERENCES public.comerciante(id_comerciante) NOT VALID;


--
-- TOC entry 4981 (class 0 OID 0)
-- Dependencies: 5
-- Name: SCHEMA public; Type: ACL; Schema: -; Owner: pg_database_owner
--

GRANT CREATE ON SCHEMA public TO llanos;
GRANT CREATE ON SCHEMA public TO romero;
GRANT CREATE ON SCHEMA public TO mescua;
GRANT CREATE ON SCHEMA public TO zorrilla;


--
-- TOC entry 4982 (class 0 OID 0)
-- Dependencies: 220
-- Name: TABLE comerciante; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT,INSERT,UPDATE ON TABLE public.comerciante TO rol_configuracion_pg;
GRANT SELECT ON TABLE public.comerciante TO rol_sucursales_pg;
GRANT SELECT ON TABLE public.comerciante TO rol_analista_pg;


--
-- TOC entry 4983 (class 0 OID 0)
-- Dependencies: 219
-- Name: SEQUENCE comerciante_id_comerciante_seq; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT,USAGE ON SEQUENCE public.comerciante_id_comerciante_seq TO rol_seguridad_pg;
GRANT SELECT,USAGE ON SEQUENCE public.comerciante_id_comerciante_seq TO rol_configuracion_pg;
GRANT SELECT,USAGE ON SEQUENCE public.comerciante_id_comerciante_seq TO rol_sucursales_pg;


--
-- TOC entry 4984 (class 0 OID 0)
-- Dependencies: 222
-- Name: TABLE configuracion; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT,INSERT,UPDATE ON TABLE public.configuracion TO rol_configuracion_pg;


--
-- TOC entry 4985 (class 0 OID 0)
-- Dependencies: 221
-- Name: SEQUENCE configuracion_id_configuracion_seq; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT,USAGE ON SEQUENCE public.configuracion_id_configuracion_seq TO rol_seguridad_pg;
GRANT SELECT,USAGE ON SEQUENCE public.configuracion_id_configuracion_seq TO rol_configuracion_pg;
GRANT SELECT,USAGE ON SEQUENCE public.configuracion_id_configuracion_seq TO rol_sucursales_pg;


--
-- TOC entry 4986 (class 0 OID 0)
-- Dependencies: 223
-- Name: SEQUENCE empleado_id_empleado_seq; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT,USAGE ON SEQUENCE public.empleado_id_empleado_seq TO rol_configuracion_pg;
GRANT SELECT,USAGE ON SEQUENCE public.empleado_id_empleado_seq TO rol_sucursales_pg;


--
-- TOC entry 4987 (class 0 OID 0)
-- Dependencies: 230
-- Name: TABLE historial_login; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT,INSERT,UPDATE ON TABLE public.historial_login TO rol_seguridad_pg;


--
-- TOC entry 4988 (class 0 OID 0)
-- Dependencies: 229
-- Name: SEQUENCE historial_login_id_log_seq; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT,USAGE ON SEQUENCE public.historial_login_id_log_seq TO rol_seguridad_pg;
GRANT SELECT,USAGE ON SEQUENCE public.historial_login_id_log_seq TO rol_configuracion_pg;
GRANT SELECT,USAGE ON SEQUENCE public.historial_login_id_log_seq TO rol_sucursales_pg;


--
-- TOC entry 4989 (class 0 OID 0)
-- Dependencies: 218
-- Name: TABLE rol; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT ON TABLE public.rol TO rol_seguridad_pg;


--
-- TOC entry 4990 (class 0 OID 0)
-- Dependencies: 217
-- Name: SEQUENCE rol_id_rol_seq; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT,USAGE ON SEQUENCE public.rol_id_rol_seq TO rol_seguridad_pg;
GRANT SELECT,USAGE ON SEQUENCE public.rol_id_rol_seq TO rol_configuracion_pg;
GRANT SELECT,USAGE ON SEQUENCE public.rol_id_rol_seq TO rol_sucursales_pg;


--
-- TOC entry 4991 (class 0 OID 0)
-- Dependencies: 226
-- Name: TABLE sucursal; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT,INSERT,UPDATE ON TABLE public.sucursal TO rol_sucursales_pg;


--
-- TOC entry 4992 (class 0 OID 0)
-- Dependencies: 225
-- Name: SEQUENCE sucursal_id_sucursal_seq; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT,USAGE ON SEQUENCE public.sucursal_id_sucursal_seq TO rol_seguridad_pg;
GRANT SELECT,USAGE ON SEQUENCE public.sucursal_id_sucursal_seq TO rol_configuracion_pg;
GRANT SELECT,USAGE ON SEQUENCE public.sucursal_id_sucursal_seq TO rol_sucursales_pg;


--
-- TOC entry 4993 (class 0 OID 0)
-- Dependencies: 228
-- Name: TABLE suscripcion; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT ON TABLE public.suscripcion TO rol_analista_pg;


--
-- TOC entry 4994 (class 0 OID 0)
-- Dependencies: 227
-- Name: SEQUENCE suscripcion_id_suscripcion_seq; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT,USAGE ON SEQUENCE public.suscripcion_id_suscripcion_seq TO rol_seguridad_pg;
GRANT SELECT,USAGE ON SEQUENCE public.suscripcion_id_suscripcion_seq TO rol_configuracion_pg;
GRANT SELECT,USAGE ON SEQUENCE public.suscripcion_id_suscripcion_seq TO rol_sucursales_pg;


-- Completed on 2026-09-25 20:26:47

--
-- PostgreSQL database dump complete
--

\unrestrict W9o6WuS3OL78fXI5ip87FIMR2zZTkYSIrkg8PgSvTD0hDmnbdbs0RrkYLubE49s

