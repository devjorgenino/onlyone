--
-- PostgreSQL database dump
--

-- Dumped from database version 11.2
-- Dumped by pg_dump version 11.2

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: administracion; Type: SCHEMA; Schema: -; Owner: geekhack
--

CREATE SCHEMA administracion;


ALTER SCHEMA administracion OWNER TO geekhack;

--
-- Name: conciliacion; Type: SCHEMA; Schema: -; Owner: geekhack
--

CREATE SCHEMA conciliacion;


ALTER SCHEMA conciliacion OWNER TO geekhack;

--
-- Name: maestros; Type: SCHEMA; Schema: -; Owner: geekhack
--

CREATE SCHEMA maestros;


ALTER SCHEMA maestros OWNER TO geekhack;

--
-- Name: seguridad; Type: SCHEMA; Schema: -; Owner: geekhack
--

CREATE SCHEMA seguridad;


ALTER SCHEMA seguridad OWNER TO geekhack;

--
-- Name: dblink; Type: EXTENSION; Schema: -; Owner: 
--

CREATE EXTENSION IF NOT EXISTS dblink WITH SCHEMA public;


--
-- Name: EXTENSION dblink; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION dblink IS 'connect to other PostgreSQL databases from within a database';


--
-- Name: sp_actualizaremailpsw(integer, integer, text); Type: FUNCTION; Schema: seguridad; Owner: geekhack
--

CREATE FUNCTION seguridad.sp_actualizaremailpsw(cod integer, iduser integer, psw text) RETURNS integer
    LANGUAGE plpgsql
    AS $$
BEGIN
	case cod
		when 0 then
			update seguridad.usuario set
				clave = encode(convert_to(psw, 'utf-8'), 'base64'),
				cambio_pass = false
			where id=idUser;
			return 1;
		when 1 then
			update seguridad.usuario set
				clave = encode(convert_to(psw, 'utf-8'), 'base64'),
				cambio_pass = true
			where id=idUser;
			return 1;
		else
			return 0;
	end case;
END;

$$;


ALTER FUNCTION seguridad.sp_actualizaremailpsw(cod integer, iduser integer, psw text) OWNER TO geekhack;

--
-- Name: sp_registrarusuario(text[]); Type: FUNCTION; Schema: seguridad; Owner: geekhack
--

CREATE FUNCTION seguridad.sp_registrarusuario(arreglo text[]) RETURNS integer
    LANGUAGE plpgsql
    AS $$
DECLARE
	valor integer;
	cadena text;
	
BEGIN
	
	select count (*) into valor from seguridad.usuario where usuario = arreglo[1];
	if valor > 0 then
		return -3;
	else
		cadena:= encode(convert_to(arreglo[6], 'utf-8'), 'base64');
		insert into seguridad.usuario (empresa,role,usuario,clave,nombre,apellido,email,sexo)
		values(arreglo[7]::Integer,arreglo[5]::Integer,arreglo[1],cadena,lower(arreglo[2]), lower(arreglo[3]), lower(arreglo[4]),'');
		return 1;
	end if;

END;

$$;


ALTER FUNCTION seguridad.sp_registrarusuario(arreglo text[]) OWNER TO geekhack;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: facturas; Type: TABLE; Schema: administracion; Owner: geekhack
--

CREATE TABLE administracion.facturas (
    id integer NOT NULL,
    numero bigint NOT NULL,
    email character varying(30) NOT NULL,
    empresa integer NOT NULL,
    nombre_cliente character varying(30) NOT NULL,
    descripcion "char" NOT NULL,
    monto double precision NOT NULL,
    fecha date NOT NULL,
    fecha_creacion timestamp without time zone DEFAULT now(),
    estatus boolean DEFAULT false NOT NULL,
    estatus_fact integer DEFAULT 1 NOT NULL
);


ALTER TABLE administracion.facturas OWNER TO geekhack;

--
-- Name: facturas_id_seq; Type: SEQUENCE; Schema: administracion; Owner: geekhack
--

CREATE SEQUENCE administracion.facturas_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE administracion.facturas_id_seq OWNER TO geekhack;

--
-- Name: facturas_id_seq; Type: SEQUENCE OWNED BY; Schema: administracion; Owner: geekhack
--

ALTER SEQUENCE administracion.facturas_id_seq OWNED BY administracion.facturas.id;


--
-- Name: reporte_pagos; Type: TABLE; Schema: administracion; Owner: geekhack
--

CREATE TABLE administracion.reporte_pagos (
    id integer NOT NULL,
    nombre text NOT NULL,
    doc text NOT NULL,
    email text NOT NULL,
    empresa text NOT NULL,
    numero_operacion text NOT NULL,
    tipo_operacion text NOT NULL,
    idusuario integer NOT NULL,
    idcuenta integer NOT NULL,
    estatus boolean DEFAULT false NOT NULL,
    estatus_rep integer DEFAULT 1 NOT NULL,
    fecha_creacion date DEFAULT now() NOT NULL,
    movimiento integer DEFAULT 0,
    idbanco_tipo_operacion integer,
    fecha_pago date,
    codigocuenta character varying,
    numerocuenta character varying
);


ALTER TABLE administracion.reporte_pagos OWNER TO geekhack;

--
-- Name: reporte_pago_externo_id_seq; Type: SEQUENCE; Schema: administracion; Owner: geekhack
--

CREATE SEQUENCE administracion.reporte_pago_externo_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE administracion.reporte_pago_externo_id_seq OWNER TO geekhack;

--
-- Name: reporte_pago_externo_id_seq; Type: SEQUENCE OWNED BY; Schema: administracion; Owner: geekhack
--

ALTER SEQUENCE administracion.reporte_pago_externo_id_seq OWNED BY administracion.reporte_pagos.id;


--
-- Name: reporte_pago_factura; Type: TABLE; Schema: administracion; Owner: geekhack
--

CREATE TABLE administracion.reporte_pago_factura (
    id integer NOT NULL,
    idpago integer NOT NULL,
    numero_factura text NOT NULL,
    descripcion text,
    monto double precision
);


ALTER TABLE administracion.reporte_pago_factura OWNER TO geekhack;

--
-- Name: reporte_pago_factura_id_seq; Type: SEQUENCE; Schema: administracion; Owner: geekhack
--

CREATE SEQUENCE administracion.reporte_pago_factura_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE administracion.reporte_pago_factura_id_seq OWNER TO geekhack;

--
-- Name: reporte_pago_factura_id_seq; Type: SEQUENCE OWNED BY; Schema: administracion; Owner: geekhack
--

ALTER SEQUENCE administracion.reporte_pago_factura_id_seq OWNED BY administracion.reporte_pago_factura.id;


--
-- Name: v_reportre_pagos; Type: VIEW; Schema: administracion; Owner: geekhack
--

CREATE VIEW administracion.v_reportre_pagos AS
SELECT
    NULL::integer AS id,
    NULL::text AS empresa,
    NULL::double precision AS total,
    NULL::integer AS estatus_rep,
    NULL::integer AS movimiento;


ALTER TABLE administracion.v_reportre_pagos OWNER TO geekhack;

--
-- Name: v_conciliacionreportes; Type: VIEW; Schema: conciliacion; Owner: geekhack
--

CREATE VIEW conciliacion.v_conciliacionreportes AS
 SELECT dblink.id_reporte,
    dblink.total_c,
    dblink.total_nc,
    dblink.total_ncm,
    dblink.id_pago,
    dblink.fecha_reporte,
    ar.id,
    ar.nombre,
    ar.doc,
    ar.email,
    ar.empresa,
    ar.numero_operacion,
    ar.tipo_operacion,
    ar.idusuario,
    ar.idcuenta,
    ar.estatus,
    ar.estatus_rep,
    ar.fecha_creacion,
    ar.movimiento,
    ar.idbanco_tipo_operacion,
    ar.fecha_pago,
    ar.codigocuenta AS "codigoCuenta",
    ar.numerocuenta AS "numeroCuenta"
   FROM (public.dblink('hostaddr=127.0.0.1 port=5432 dbname=onlyone user=geekhack password=geekHACK-12345+'::text, 'SELECT id,total_c,total_nc, total_ncm,id_pago, fecha_creacion from conciliacion.v_cociliacionreporte'::text) dblink(id_reporte integer, total_c integer, total_nc integer, total_ncm integer, id_pago integer, fecha_reporte time with time zone)
     JOIN administracion.reporte_pagos ar ON ((dblink.id_pago = ar.id)));


ALTER TABLE conciliacion.v_conciliacionreportes OWNER TO geekhack;

--
-- Name: bancos; Type: TABLE; Schema: maestros; Owner: postgres
--

CREATE TABLE maestros.bancos (
    id integer NOT NULL,
    razon_comercial character varying(100),
    razon_social character varying(100),
    rif character varying(20),
    idciudad integer,
    idpais smallint,
    direccion text,
    idcontacto integer,
    estatus smallint,
    fecha_creacion timestamp with time zone DEFAULT now(),
    activo boolean DEFAULT false,
    codigo text,
    tipo integer
);


ALTER TABLE maestros.bancos OWNER TO postgres;

--
-- Name: bancos_id_seq; Type: SEQUENCE; Schema: maestros; Owner: postgres
--

CREATE SEQUENCE maestros.bancos_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE maestros.bancos_id_seq OWNER TO postgres;

--
-- Name: bancos_id_seq; Type: SEQUENCE OWNED BY; Schema: maestros; Owner: postgres
--

ALTER SEQUENCE maestros.bancos_id_seq OWNED BY maestros.bancos.id;


--
-- Name: tipo_operacion; Type: TABLE; Schema: maestros; Owner: geekhack
--

CREATE TABLE maestros.tipo_operacion (
    id integer NOT NULL,
    nombre character varying(50) NOT NULL,
    estatus boolean DEFAULT true NOT NULL
);


ALTER TABLE maestros.tipo_operacion OWNER TO geekhack;

--
-- Name: tipo_operacion_id_seq; Type: SEQUENCE; Schema: maestros; Owner: geekhack
--

CREATE SEQUENCE maestros.tipo_operacion_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE maestros.tipo_operacion_id_seq OWNER TO geekhack;

--
-- Name: tipo_operacion_id_seq; Type: SEQUENCE OWNED BY; Schema: maestros; Owner: geekhack
--

ALTER SEQUENCE maestros.tipo_operacion_id_seq OWNED BY maestros.tipo_operacion.id;


--
-- Name: estatus_facturas; Type: TABLE; Schema: seguridad; Owner: geekhack
--

CREATE TABLE seguridad.estatus_facturas (
    id integer NOT NULL,
    nombre character varying(30),
    estatus boolean DEFAULT true NOT NULL
);


ALTER TABLE seguridad.estatus_facturas OWNER TO geekhack;

--
-- Name: estatus_facturas_id_seq; Type: SEQUENCE; Schema: seguridad; Owner: geekhack
--

CREATE SEQUENCE seguridad.estatus_facturas_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE seguridad.estatus_facturas_id_seq OWNER TO geekhack;

--
-- Name: estatus_facturas_id_seq; Type: SEQUENCE OWNED BY; Schema: seguridad; Owner: geekhack
--

ALTER SEQUENCE seguridad.estatus_facturas_id_seq OWNED BY seguridad.estatus_facturas.id;


--
-- Name: estatus_reporte_pago; Type: TABLE; Schema: seguridad; Owner: geekhack
--

CREATE TABLE seguridad.estatus_reporte_pago (
    id integer NOT NULL,
    nombre character varying(30),
    estatus boolean DEFAULT true NOT NULL
);


ALTER TABLE seguridad.estatus_reporte_pago OWNER TO geekhack;

--
-- Name: estatus_reporte_pago_id_seq; Type: SEQUENCE; Schema: seguridad; Owner: geekhack
--

CREATE SEQUENCE seguridad.estatus_reporte_pago_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE seguridad.estatus_reporte_pago_id_seq OWNER TO geekhack;

--
-- Name: estatus_reporte_pago_id_seq; Type: SEQUENCE OWNED BY; Schema: seguridad; Owner: geekhack
--

ALTER SEQUENCE seguridad.estatus_reporte_pago_id_seq OWNED BY seguridad.estatus_reporte_pago.id;


--
-- Name: redes; Type: TABLE; Schema: seguridad; Owner: geekhack
--

CREATE TABLE seguridad.redes (
    _id integer NOT NULL,
    facebook text,
    linkedin text,
    idusuario integer NOT NULL
);


ALTER TABLE seguridad.redes OWNER TO geekhack;

--
-- Name: roles; Type: TABLE; Schema: seguridad; Owner: geekhack
--

CREATE TABLE seguridad.roles (
    id integer NOT NULL,
    nombre character varying(15) NOT NULL
);


ALTER TABLE seguridad.roles OWNER TO geekhack;

--
-- Name: roles_id_seq; Type: SEQUENCE; Schema: seguridad; Owner: geekhack
--

CREATE SEQUENCE seguridad.roles_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE seguridad.roles_id_seq OWNER TO geekhack;

--
-- Name: roles_id_seq; Type: SEQUENCE OWNED BY; Schema: seguridad; Owner: geekhack
--

ALTER SEQUENCE seguridad.roles_id_seq OWNED BY seguridad.roles.id;


--
-- Name: usuario; Type: TABLE; Schema: seguridad; Owner: geekhack
--

CREATE TABLE seguridad.usuario (
    id integer NOT NULL,
    empresa integer NOT NULL,
    role integer NOT NULL,
    usuario character varying(20) NOT NULL,
    clave character varying(20) NOT NULL,
    nombre character varying(30) NOT NULL,
    apellido character varying(30) NOT NULL,
    email character varying(30),
    sexo character(1) NOT NULL,
    fecha_nacimiento date,
    fecha_creacion timestamp without time zone DEFAULT now(),
    estatus boolean DEFAULT true NOT NULL,
    cambio_pass boolean DEFAULT false NOT NULL
);


ALTER TABLE seguridad.usuario OWNER TO geekhack;

--
-- Name: usuario_id_seq; Type: SEQUENCE; Schema: seguridad; Owner: geekhack
--

CREATE SEQUENCE seguridad.usuario_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE seguridad.usuario_id_seq OWNER TO geekhack;

--
-- Name: usuario_id_seq; Type: SEQUENCE OWNED BY; Schema: seguridad; Owner: geekhack
--

ALTER SEQUENCE seguridad.usuario_id_seq OWNED BY seguridad.usuario.id;


--
-- Name: usuario_invitado; Type: TABLE; Schema: seguridad; Owner: geekhack
--

CREATE TABLE seguridad.usuario_invitado (
    id integer NOT NULL,
    codigo character varying(50) NOT NULL,
    email character varying(30) NOT NULL,
    empresa integer NOT NULL,
    rol integer NOT NULL,
    fecha_creacion timestamp without time zone DEFAULT now(),
    estatus boolean DEFAULT true NOT NULL
);


ALTER TABLE seguridad.usuario_invitado OWNER TO geekhack;

--
-- Name: usuario_invitado_id_seq; Type: SEQUENCE; Schema: seguridad; Owner: geekhack
--

CREATE SEQUENCE seguridad.usuario_invitado_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE seguridad.usuario_invitado_id_seq OWNER TO geekhack;

--
-- Name: usuario_invitado_id_seq; Type: SEQUENCE OWNED BY; Schema: seguridad; Owner: geekhack
--

ALTER SEQUENCE seguridad.usuario_invitado_id_seq OWNED BY seguridad.usuario_invitado.id;


--
-- Name: facturas id; Type: DEFAULT; Schema: administracion; Owner: geekhack
--

ALTER TABLE ONLY administracion.facturas ALTER COLUMN id SET DEFAULT nextval('administracion.facturas_id_seq'::regclass);


--
-- Name: reporte_pago_factura id; Type: DEFAULT; Schema: administracion; Owner: geekhack
--

ALTER TABLE ONLY administracion.reporte_pago_factura ALTER COLUMN id SET DEFAULT nextval('administracion.reporte_pago_factura_id_seq'::regclass);


--
-- Name: reporte_pagos id; Type: DEFAULT; Schema: administracion; Owner: geekhack
--

ALTER TABLE ONLY administracion.reporte_pagos ALTER COLUMN id SET DEFAULT nextval('administracion.reporte_pago_externo_id_seq'::regclass);


--
-- Name: bancos id; Type: DEFAULT; Schema: maestros; Owner: postgres
--

ALTER TABLE ONLY maestros.bancos ALTER COLUMN id SET DEFAULT nextval('maestros.bancos_id_seq'::regclass);


--
-- Name: tipo_operacion id; Type: DEFAULT; Schema: maestros; Owner: geekhack
--

ALTER TABLE ONLY maestros.tipo_operacion ALTER COLUMN id SET DEFAULT nextval('maestros.tipo_operacion_id_seq'::regclass);


--
-- Name: estatus_facturas id; Type: DEFAULT; Schema: seguridad; Owner: geekhack
--

ALTER TABLE ONLY seguridad.estatus_facturas ALTER COLUMN id SET DEFAULT nextval('seguridad.estatus_facturas_id_seq'::regclass);


--
-- Name: estatus_reporte_pago id; Type: DEFAULT; Schema: seguridad; Owner: geekhack
--

ALTER TABLE ONLY seguridad.estatus_reporte_pago ALTER COLUMN id SET DEFAULT nextval('seguridad.estatus_reporte_pago_id_seq'::regclass);


--
-- Name: roles id; Type: DEFAULT; Schema: seguridad; Owner: geekhack
--

ALTER TABLE ONLY seguridad.roles ALTER COLUMN id SET DEFAULT nextval('seguridad.roles_id_seq'::regclass);


--
-- Name: usuario id; Type: DEFAULT; Schema: seguridad; Owner: geekhack
--

ALTER TABLE ONLY seguridad.usuario ALTER COLUMN id SET DEFAULT nextval('seguridad.usuario_id_seq'::regclass);


--
-- Name: usuario_invitado id; Type: DEFAULT; Schema: seguridad; Owner: geekhack
--

ALTER TABLE ONLY seguridad.usuario_invitado ALTER COLUMN id SET DEFAULT nextval('seguridad.usuario_invitado_id_seq'::regclass);


--
-- Data for Name: facturas; Type: TABLE DATA; Schema: administracion; Owner: geekhack
--

COPY administracion.facturas (id, numero, email, empresa, nombre_cliente, descripcion, monto, fecha, fecha_creacion, estatus, estatus_fact) FROM stdin;
\.


--
-- Data for Name: reporte_pago_factura; Type: TABLE DATA; Schema: administracion; Owner: geekhack
--

COPY administracion.reporte_pago_factura (id, idpago, numero_factura, descripcion, monto) FROM stdin;
223	209	00045	prueba mismo banco	5000
224	210	00078	PRUEBA OTRO BANCO	300000
225	211	00085	prueba pago movil	180000
226	212	4456	prueba otro banco	50000
227	213	00001	Mismo Banco	15000
228	213	000011	mismo Banco 2	6000
229	214	0003	prueba mismo banco	15000
230	215	001234	otro banco 1	100000
231	215	000344	otro banco 2	100000
232	216	1234	pago movil	406000
233	217	000013	prueba otros bancos	1000000
234	217	000014	prueba otros bancos	1000000
235	218	12334	prueba 2	400000
236	219	00001	PRUEBA MERCANTIL	4000
\.


--
-- Data for Name: reporte_pagos; Type: TABLE DATA; Schema: administracion; Owner: geekhack
--

COPY administracion.reporte_pagos (id, nombre, doc, email, empresa, numero_operacion, tipo_operacion, idusuario, idcuenta, estatus, estatus_rep, fecha_creacion, movimiento, idbanco_tipo_operacion, fecha_pago, codigocuenta, numerocuenta) FROM stdin;
211	Gemima Moreno	V013888896	gm@wek.io	6	10533501	2	1	328	f	1	2019-09-10	0	3	2019-07-12	0168	01680001458988755289
209	Gemima Moreno	V013888896	moreno.gemima@gmail.com	6	100117448	1	1	328	f	2	2019-09-10	80144	3	2019-07-30	0191	01910001402101027089
210	Gemima Moreno	V013888896	gemima_m@hotmail.com	6	23103301	2	1	328	f	2	2019-09-10	80133	3	2019-07-15	0168	01680049001112125665
212	Gemima Moreno	V014964040	gemima_m@hotmail.com	6	66767	2	1	331	f	2	2019-09-11	80310	4	2019-08-24	0128	01280001458865223556
213	Juan Moreno	V001255731	gemima_m@hotmail.com	6	02530695776	1	1	332	f	2	2019-09-11	80319	2	2019-09-03	0134	01340000345568690600
214	Santiago Moreno	V015160852	moreno.gemima@gmail.com	6	02531122874	1	1	332	f	2	2019-09-11	80320	2	2019-09-03	0134	01340123456789012345
216	Santiago Moreno	V013888896	moreno.gemima@gmail.com	6	84722214355	1	1	332	f	2	2019-09-11	80333	2	2019-09-06	0134	01340002939384884845
217	Gemima Moreno	J301780930	moreno.gemima@gmail.com	6	25515983364	2	1	333	f	1	2019-09-11	0	1	2019-09-09	0134	01340399849494500555
218	Gemima Moreno	V013888896	gm@wek.io	6	12100043815	2	1	333	f	1	2019-09-11	0	1	2019-09-05	0114	01140001223939947744
219	Gemima Moreno	V012123456	gm@wek.io	6	000025556666080	2	1	333	f	1	2019-09-11	0	1	2019-01-07	0102	01024566788899955222
215	Santiago Moreno	V014964040	moreno.gemima@gmail.com	6	00000560907	2	1	332	f	2	2019-09-11	80332	2	2019-09-06	0191	01910000344599044449
\.


--
-- Data for Name: bancos; Type: TABLE DATA; Schema: maestros; Owner: postgres
--

COPY maestros.bancos (id, razon_comercial, razon_social, rif, idciudad, idpais, direccion, idcontacto, estatus, fecha_creacion, activo, codigo, tipo) FROM stdin;
6	venezuela	banco de venezuela	G-20009997-6	1	1	caracas	1	1	2019-08-28 13:46:35.312224-04	t	0102	1
7	vzla de credito	banco venzolano de credito	J-00002970-9	1	1	caracas	1	1	2019-08-28 13:46:35.312224-04	t	0104	1
8	provincial	bbva provincial	J-00002967-9	1	1	caracas	1	1	2019-08-28 13:46:35.312224-04	t	0108	1
9	bancaribe	banco bancaribe	J-00002949-0	1	1	caracas	1	1	2019-08-28 13:46:35.312224-04	t	0114	1
10	exterior	banco exterior	J-00002950-4	1	1	caracas	1	1	2019-08-28 13:46:35.312224-04	t	0115	1
11	sofitasa	banco sofitasa	J-09028384-6	1	1	caracas	1	1	2019-08-28 13:46:35.312224-04	t	0137	1
12	plaza	banco plaza	J-00297055-3	1	1	caracas	1	1	2019-08-28 13:46:35.312224-04	t	0138	1
13	bfc	banco fondo comun	J-00072306-0	1	1	caracas	1	1	2019-08-28 13:46:35.312224-04	t	0151	1
14	100%banco	100% banco	J-08500776-8	1	1	caracas	1	1	2019-08-28 13:46:35.312224-04	t	0156	1
15	del sur	banco del sur	 J-00079723-4	1	1	caracas	1	1	2019-08-28 13:46:35.312224-04	t	0157	1
16	tesoro	banco del tesoro	G-20005187-6	1	1	caracas	1	1	2019-08-28 13:46:35.312224-04	t	0163	1
17	agricola	banco agricola	G-20005795-5	1	1	caracas	1	1	2019-08-28 13:46:35.312224-04	t	0166	1
18	bancrecer	banco bancrecer	J-31637417-3	1	1	carcas	1	1	2019-08-28 13:46:35.312224-04	t	0168	1
19	mi banco	banco mi banco	J-31594102-3	1	1	caracas	1	1	2019-08-28 13:46:35.312224-04	t	0169	1
20	activo	banco activo	J-08006622-7	1	1	caracas	1	1	2019-08-28 13:46:35.312224-04	t	0171	1
21	banplus	banco banplus	J-000423032	1	1	caracas	1	1	2019-08-28 13:46:35.312224-04	t	0174	1
22	bicentenario	banco bicentenario	G-20009148-7	1	1	caracas	1	1	2019-08-28 13:46:35.312224-04	t	0175	1
23	bafanb	banco de la fuerza armada nacional bolivariana	G-20010657-3	1	1	caracas	1	1	2019-08-28 13:46:35.312224-04	t	0177	1
2	banesco	banco banesco	J-07013380-5	1	1	caracas	1	1	2019-08-28 13:46:35.312224-04	t	0134	1
5	caroni	banco caroni	J-09504855-1	1	1	puerto ordaz	1	1	2019-08-28 13:46:35.312224-04	t	0128	1
3	bnc	banco nacional de credito	J-30984132-7	1	1	caracas	1	1	2019-08-28 13:46:35.312224-04	t	0191	1
4	bod	banco occidental de descuento	J-30061946-0	1	1	caracas	1	1	2019-08-28 13:46:35.312224-04	t	0116	1
1	mercantil	banco mercantil	J-00002961-0	1	1	caracas	1	1	2019-08-28 13:46:35.312224-04	t	0105	1
\.


--
-- Data for Name: tipo_operacion; Type: TABLE DATA; Schema: maestros; Owner: geekhack
--

COPY maestros.tipo_operacion (id, nombre, estatus) FROM stdin;
1	transferencia mismo banco	t
2	transferencia otros bancos	t
\.


--
-- Data for Name: estatus_facturas; Type: TABLE DATA; Schema: seguridad; Owner: geekhack
--

COPY seguridad.estatus_facturas (id, nombre, estatus) FROM stdin;
1	Pendiente Por pago	t
3	Pagada	t
2	Pendiente Aprobacion de  Pago	t
\.


--
-- Data for Name: estatus_reporte_pago; Type: TABLE DATA; Schema: seguridad; Owner: geekhack
--

COPY seguridad.estatus_reporte_pago (id, nombre, estatus) FROM stdin;
1	Pendiente Por Conciliacion	t
2	Conciliado	t
4	Rechazado	t
3	Conciliado con Monto Distintos	t
\.


--
-- Data for Name: redes; Type: TABLE DATA; Schema: seguridad; Owner: geekhack
--

COPY seguridad.redes (_id, facebook, linkedin, idusuario) FROM stdin;
\.


--
-- Data for Name: roles; Type: TABLE DATA; Schema: seguridad; Owner: geekhack
--

COPY seguridad.roles (id, nombre) FROM stdin;
1	pagador
\.


--
-- Data for Name: usuario; Type: TABLE DATA; Schema: seguridad; Owner: geekhack
--

COPY seguridad.usuario (id, empresa, role, usuario, clave, nombre, apellido, email, sexo, fecha_nacimiento, fecha_creacion, estatus, cambio_pass) FROM stdin;
25	1	1	jesus	QXVvaDBzckI=	jesus	indriago	jesus-indriago@hotmail.com	 	\N	2019-08-09 14:52:49.93949	t	f
26	5	1	bernardobg	YmIxMjM=	bernardo	bossio	bb@geekhack.net.ve	 	\N	2019-08-12 14:02:57.544557	t	t
27	6	1	aless717	YWxlc3MxMjM=	alessandra	morales	aless717@gmail.com	 	\N	2019-08-12 14:13:26.7448	t	t
\.


--
-- Data for Name: usuario_invitado; Type: TABLE DATA; Schema: seguridad; Owner: geekhack
--

COPY seguridad.usuario_invitado (id, codigo, email, empresa, rol, fecha_creacion, estatus) FROM stdin;
141	61y3hzwe5x85az5ffz3a9fvenl8e4o	jesus-indriago@hotmail.com	1	1	2019-08-09 14:52:18.642744	t
142	yqcaetbtozosovce398kzgfc3fp7h5	bb@geekhack.net.ve	5	1	2019-08-12 14:01:07.474943	t
143	8jrb7tknl03wwyw77bb9gwnqdh0np5	aless717@gmail.com	6	1	2019-08-12 14:08:11.618021	t
144	uvdlk40wx0dodz9hjqnwjmt1oiy3nf	jn@geekhack.net.ve	1	1	2019-08-21 09:49:28.611511	t
145	6zxf20ux2atpadzo2xmu58o0iz4bt8	jesusindria@gmail.com	1	1	2019-08-21 09:59:24.160612	t
\.


--
-- Name: facturas_id_seq; Type: SEQUENCE SET; Schema: administracion; Owner: geekhack
--

SELECT pg_catalog.setval('administracion.facturas_id_seq', 177, true);


--
-- Name: reporte_pago_externo_id_seq; Type: SEQUENCE SET; Schema: administracion; Owner: geekhack
--

SELECT pg_catalog.setval('administracion.reporte_pago_externo_id_seq', 219, true);


--
-- Name: reporte_pago_factura_id_seq; Type: SEQUENCE SET; Schema: administracion; Owner: geekhack
--

SELECT pg_catalog.setval('administracion.reporte_pago_factura_id_seq', 236, true);


--
-- Name: bancos_id_seq; Type: SEQUENCE SET; Schema: maestros; Owner: postgres
--

SELECT pg_catalog.setval('maestros.bancos_id_seq', 23, true);


--
-- Name: tipo_operacion_id_seq; Type: SEQUENCE SET; Schema: maestros; Owner: geekhack
--

SELECT pg_catalog.setval('maestros.tipo_operacion_id_seq', 2, true);


--
-- Name: estatus_facturas_id_seq; Type: SEQUENCE SET; Schema: seguridad; Owner: geekhack
--

SELECT pg_catalog.setval('seguridad.estatus_facturas_id_seq', 3, true);


--
-- Name: estatus_reporte_pago_id_seq; Type: SEQUENCE SET; Schema: seguridad; Owner: geekhack
--

SELECT pg_catalog.setval('seguridad.estatus_reporte_pago_id_seq', 4, true);


--
-- Name: roles_id_seq; Type: SEQUENCE SET; Schema: seguridad; Owner: geekhack
--

SELECT pg_catalog.setval('seguridad.roles_id_seq', 20, true);


--
-- Name: usuario_id_seq; Type: SEQUENCE SET; Schema: seguridad; Owner: geekhack
--

SELECT pg_catalog.setval('seguridad.usuario_id_seq', 27, true);


--
-- Name: usuario_invitado_id_seq; Type: SEQUENCE SET; Schema: seguridad; Owner: geekhack
--

SELECT pg_catalog.setval('seguridad.usuario_invitado_id_seq', 145, true);


--
-- Name: facturas facturas_numero_key; Type: CONSTRAINT; Schema: administracion; Owner: geekhack
--

ALTER TABLE ONLY administracion.facturas
    ADD CONSTRAINT facturas_numero_key UNIQUE (numero);


--
-- Name: facturas facturas_pkey; Type: CONSTRAINT; Schema: administracion; Owner: geekhack
--

ALTER TABLE ONLY administracion.facturas
    ADD CONSTRAINT facturas_pkey PRIMARY KEY (id);


--
-- Name: reporte_pagos reporte_pago_externo_pkey; Type: CONSTRAINT; Schema: administracion; Owner: geekhack
--

ALTER TABLE ONLY administracion.reporte_pagos
    ADD CONSTRAINT reporte_pago_externo_pkey PRIMARY KEY (id);


--
-- Name: reporte_pago_factura reporte_pago_factura_pkey; Type: CONSTRAINT; Schema: administracion; Owner: geekhack
--

ALTER TABLE ONLY administracion.reporte_pago_factura
    ADD CONSTRAINT reporte_pago_factura_pkey PRIMARY KEY (id);


--
-- Name: bancos bancos_pkey; Type: CONSTRAINT; Schema: maestros; Owner: postgres
--

ALTER TABLE ONLY maestros.bancos
    ADD CONSTRAINT bancos_pkey PRIMARY KEY (id);


--
-- Name: bancos bancos_rif_key; Type: CONSTRAINT; Schema: maestros; Owner: postgres
--

ALTER TABLE ONLY maestros.bancos
    ADD CONSTRAINT bancos_rif_key UNIQUE (rif);


--
-- Name: tipo_operacion tipo_operacion_pkey; Type: CONSTRAINT; Schema: maestros; Owner: geekhack
--

ALTER TABLE ONLY maestros.tipo_operacion
    ADD CONSTRAINT tipo_operacion_pkey PRIMARY KEY (id);


--
-- Name: estatus_facturas estatus_facturas_pkey; Type: CONSTRAINT; Schema: seguridad; Owner: geekhack
--

ALTER TABLE ONLY seguridad.estatus_facturas
    ADD CONSTRAINT estatus_facturas_pkey PRIMARY KEY (id);


--
-- Name: estatus_reporte_pago estatus_reporte_pago_pkey; Type: CONSTRAINT; Schema: seguridad; Owner: geekhack
--

ALTER TABLE ONLY seguridad.estatus_reporte_pago
    ADD CONSTRAINT estatus_reporte_pago_pkey PRIMARY KEY (id);


--
-- Name: roles roles_pkey; Type: CONSTRAINT; Schema: seguridad; Owner: geekhack
--

ALTER TABLE ONLY seguridad.roles
    ADD CONSTRAINT roles_pkey PRIMARY KEY (id);


--
-- Name: usuario usuario_email_key; Type: CONSTRAINT; Schema: seguridad; Owner: geekhack
--

ALTER TABLE ONLY seguridad.usuario
    ADD CONSTRAINT usuario_email_key UNIQUE (email);


--
-- Name: usuario_invitado usuario_invitado_email_key; Type: CONSTRAINT; Schema: seguridad; Owner: geekhack
--

ALTER TABLE ONLY seguridad.usuario_invitado
    ADD CONSTRAINT usuario_invitado_email_key UNIQUE (email);


--
-- Name: usuario_invitado usuario_invitado_pkey; Type: CONSTRAINT; Schema: seguridad; Owner: geekhack
--

ALTER TABLE ONLY seguridad.usuario_invitado
    ADD CONSTRAINT usuario_invitado_pkey PRIMARY KEY (id);


--
-- Name: usuario usuario_pkey; Type: CONSTRAINT; Schema: seguridad; Owner: geekhack
--

ALTER TABLE ONLY seguridad.usuario
    ADD CONSTRAINT usuario_pkey PRIMARY KEY (id);


--
-- Name: usuario usuario_usuario_key; Type: CONSTRAINT; Schema: seguridad; Owner: geekhack
--

ALTER TABLE ONLY seguridad.usuario
    ADD CONSTRAINT usuario_usuario_key UNIQUE (usuario);


--
-- Name: v_reportre_pagos _RETURN; Type: RULE; Schema: administracion; Owner: geekhack
--

CREATE OR REPLACE VIEW administracion.v_reportre_pagos WITH (security_barrier='false') AS
 SELECT rp.id,
    rp.empresa,
    sum(pf.monto) AS total,
    rp.estatus_rep,
    rp.movimiento
   FROM (administracion.reporte_pagos rp
     JOIN administracion.reporte_pago_factura pf ON ((rp.id = pf.idpago)))
  GROUP BY rp.id;


--
-- PostgreSQL database dump complete
--

