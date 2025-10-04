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
-- Name: bancos; Type: SCHEMA; Schema: -; Owner: geekhack
--

CREATE SCHEMA bancos;


ALTER SCHEMA bancos OWNER TO geekhack;

--
-- Name: conciliacion; Type: SCHEMA; Schema: -; Owner: geekhack
--

CREATE SCHEMA conciliacion;


ALTER SCHEMA conciliacion OWNER TO geekhack;

--
-- Name: maestros; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA maestros;


ALTER SCHEMA maestros OWNER TO postgres;

--
-- Name: seguridad; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA seguridad;


ALTER SCHEMA seguridad OWNER TO postgres;

--
-- Name: dblink; Type: EXTENSION; Schema: -; Owner: 
--

CREATE EXTENSION IF NOT EXISTS dblink WITH SCHEMA public;


--
-- Name: EXTENSION dblink; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION dblink IS 'connect to other PostgreSQL databases from within a database';


--
-- Name: sp_actualizaremailpsw(integer, integer, text); Type: FUNCTION; Schema: seguridad; Owner: postgres
--

CREATE FUNCTION seguridad.sp_actualizaremailpsw(cod integer, id integer, psw text) RETURNS integer
    LANGUAGE plpgsql
    AS $$

BEGIN

	case cod

		when 0 then

			update seguridad.usuarios set

				contrasena = psw,

				cambio_pass = false

			where _id=id;

			return 1;

		when 1 then

			update seguridad.usuarios set

				contrasena = psw,

				cambio_pass = true

			where _id=id;

			return 1;

		else

			return 0;

	end case;

END;

$$;


ALTER FUNCTION seguridad.sp_actualizaremailpsw(cod integer, id integer, psw text) OWNER TO postgres;

--
-- Name: sp_registrarusarioredes(text, text, text, text); Type: FUNCTION; Schema: seguridad; Owner: postgres
--

CREATE FUNCTION seguridad.sp_registrarusarioredes(nomb text, ape text, idred text, redsocial text) RETURNS integer
    LANGUAGE plpgsql
    AS $$

DECLARE

 valor integer;

 idUsu integer;

BEGIN

	case redSocial

		when 'face' then

			select count(*) into valor from seguridad.redes where facebook=idRed;

			if valor = 0 then

				insert into seguridad.usuarios (nombre,apellido,email,contrasena,idrol,idstatus,fecharegistro,cambio_pass)

				values(nomb,ape,'','',2,1,current_timestamp,true);

 				idUsu:= lastval();

				insert into seguridad.redes (facebook,linkedin,idusuario)

				values(idRed,'',idUsu);

				return idUsu;

			else

				select idusuario into idUsu from seguridad.redes where facebook=idRed;

				return idUsu;

			end if;

		when 'link' then

			select count(*) into valor from seguridad.redes where linkedin=idRed;

			if valor = 0 then

				insert into seguridad.usuarios (nombre,apellido,email,contrasena,idrol,idstatus,fecharegistro,cambio_pass)

				values(nomb,ape,'','',2,1,current_timestamp,true);

 				idUsu:= lastval();

				insert into seguridad.redes (facebook,linkedin,idusuario)

				values('',idRed,idUsu);

				return idUsu;

			else

				select idusuario into idUsu from seguridad.redes where linkedin=idRed;

				return idUsu;

			end if;

		else

			return -1;

	end case;

END;

$$;


ALTER FUNCTION seguridad.sp_registrarusarioredes(nomb text, ape text, idred text, redsocial text) OWNER TO postgres;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: bancos; Type: TABLE; Schema: bancos; Owner: geekhack
--

CREATE TABLE bancos.bancos (
    id integer NOT NULL,
    razon_comercial character varying(100),
    razon_social character varying(100),
    rif character varying(20),
    "idCiudad" integer,
    "idPais" smallint,
    direccion text,
    "idContacto" integer,
    estatus smallint,
    fecha_creacion timestamp with time zone DEFAULT now(),
    activo boolean DEFAULT false,
    codigo text,
    tipo integer
);


ALTER TABLE bancos.bancos OWNER TO geekhack;

--
-- Name: COLUMN bancos.codigo; Type: COMMENT; Schema: bancos; Owner: geekhack
--

COMMENT ON COLUMN bancos.bancos.codigo IS 'codigo del banco';


--
-- Name: COLUMN bancos.tipo; Type: COMMENT; Schema: bancos; Owner: geekhack
--

COMMENT ON COLUMN bancos.bancos.tipo IS 'tipo de bancos virtual 1 fisico 2';


--
-- Name: bancos_id_seq; Type: SEQUENCE; Schema: bancos; Owner: geekhack
--

CREATE SEQUENCE bancos.bancos_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE bancos.bancos_id_seq OWNER TO geekhack;

--
-- Name: bancos_id_seq; Type: SEQUENCE OWNED BY; Schema: bancos; Owner: geekhack
--

ALTER SEQUENCE bancos.bancos_id_seq OWNED BY bancos.bancos.id;


--
-- Name: categorias; Type: TABLE; Schema: bancos; Owner: geekhack
--

CREATE TABLE bancos.categorias (
    id integer NOT NULL,
    codigo character varying(30),
    referencia character varying(30),
    titulo character varying(50),
    descripcion character varying(150),
    activo boolean,
    estatus integer,
    fecha_creacion timestamp with time zone DEFAULT now(),
    icono character varying(200),
    grupo character varying(20)
);


ALTER TABLE bancos.categorias OWNER TO geekhack;

--
-- Name: COLUMN categorias.estatus; Type: COMMENT; Schema: bancos; Owner: geekhack
--

COMMENT ON COLUMN bancos.categorias.estatus IS 'id estatus categoria';


--
-- Name: categorias_id_seq; Type: SEQUENCE; Schema: bancos; Owner: geekhack
--

CREATE SEQUENCE bancos.categorias_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE bancos.categorias_id_seq OWNER TO geekhack;

--
-- Name: categorias_id_seq; Type: SEQUENCE OWNED BY; Schema: bancos; Owner: geekhack
--

ALTER SEQUENCE bancos.categorias_id_seq OWNED BY bancos.categorias.id;


--
-- Name: cuentas; Type: TABLE; Schema: bancos; Owner: geekhack
--

CREATE TABLE bancos.cuentas (
    id integer NOT NULL,
    codigo character varying(30),
    referencia character varying(30),
    estatus integer,
    fecha_creacion timestamp with time zone DEFAULT now(),
    fecha_mod date,
    activo boolean,
    numero character varying(30),
    aba character varying(10),
    iban character varying(40),
    bic character varying(40),
    tipo integer,
    divisa smallint,
    banco integer,
    saldo_inicial double precision,
    titulo character varying(50),
    saldo double precision,
    fecha_saldo date,
    swift character varying(20),
    usuario integer
);


ALTER TABLE bancos.cuentas OWNER TO geekhack;

--
-- Name: COLUMN cuentas.estatus; Type: COMMENT; Schema: bancos; Owner: geekhack
--

COMMENT ON COLUMN bancos.cuentas.estatus IS 'id estatus cuenta';


--
-- Name: COLUMN cuentas.tipo; Type: COMMENT; Schema: bancos; Owner: geekhack
--

COMMENT ON COLUMN bancos.cuentas.tipo IS 'id tipo cuenta';


--
-- Name: COLUMN cuentas.divisa; Type: COMMENT; Schema: bancos; Owner: geekhack
--

COMMENT ON COLUMN bancos.cuentas.divisa IS 'id divisa';


--
-- Name: COLUMN cuentas.banco; Type: COMMENT; Schema: bancos; Owner: geekhack
--

COMMENT ON COLUMN bancos.cuentas.banco IS 'id banco';


--
-- Name: COLUMN cuentas.usuario; Type: COMMENT; Schema: bancos; Owner: geekhack
--

COMMENT ON COLUMN bancos.cuentas.usuario IS 'id usuario';


--
-- Name: cuentas_id_seq; Type: SEQUENCE; Schema: bancos; Owner: geekhack
--

CREATE SEQUENCE bancos.cuentas_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE bancos.cuentas_id_seq OWNER TO geekhack;

--
-- Name: cuentas_id_seq; Type: SEQUENCE OWNED BY; Schema: bancos; Owner: geekhack
--

ALTER SEQUENCE bancos.cuentas_id_seq OWNED BY bancos.cuentas.id;


--
-- Name: movimientos; Type: TABLE; Schema: bancos; Owner: geekhack
--

CREATE TABLE bancos.movimientos (
    id bigint NOT NULL,
    codigo character varying(30),
    referencia character varying(30),
    fecha_creacion timestamp with time zone DEFAULT now(),
    fecha date,
    monto double precision,
    divisa integer,
    tipo integer,
    operacion character varying(50),
    descripcion character varying(600),
    cuenta integer,
    usuario integer,
    aux integer DEFAULT 0 NOT NULL,
    referencia_2 character varying DEFAULT 1000
);


ALTER TABLE bancos.movimientos OWNER TO geekhack;

--
-- Name: COLUMN movimientos.cuenta; Type: COMMENT; Schema: bancos; Owner: geekhack
--

COMMENT ON COLUMN bancos.movimientos.cuenta IS 'id cuenta';


--
-- Name: COLUMN movimientos.usuario; Type: COMMENT; Schema: bancos; Owner: geekhack
--

COMMENT ON COLUMN bancos.movimientos.usuario IS 'id usuario';


--
-- Name: movimientos_id_seq; Type: SEQUENCE; Schema: bancos; Owner: geekhack
--

CREATE SEQUENCE bancos.movimientos_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE bancos.movimientos_id_seq OWNER TO geekhack;

--
-- Name: movimientos_id_seq; Type: SEQUENCE OWNED BY; Schema: bancos; Owner: geekhack
--

ALTER SEQUENCE bancos.movimientos_id_seq OWNED BY bancos.movimientos.id;


--
-- Name: movimientos_info; Type: TABLE; Schema: bancos; Owner: geekhack
--

CREATE TABLE bancos.movimientos_info (
    id bigint NOT NULL,
    categoria integer,
    subcategoria integer,
    titular bigint,
    nota text,
    estatus integer,
    activo boolean,
    fecha_creacion timestamp with time zone DEFAULT now()
);


ALTER TABLE bancos.movimientos_info OWNER TO geekhack;

--
-- Name: COLUMN movimientos_info.titular; Type: COMMENT; Schema: bancos; Owner: geekhack
--

COMMENT ON COLUMN bancos.movimientos_info.titular IS 'id del titular que emite o recibe el monto';


--
-- Name: COLUMN movimientos_info.estatus; Type: COMMENT; Schema: bancos; Owner: geekhack
--

COMMENT ON COLUMN bancos.movimientos_info.estatus IS 'id estatus movimiento';


--
-- Name: subcategorias; Type: TABLE; Schema: bancos; Owner: geekhack
--

CREATE TABLE bancos.subcategorias (
    id integer DEFAULT nextval('bancos.categorias_id_seq'::regclass) NOT NULL,
    codigo character varying(30),
    referencia character varying(30),
    titulo character varying(50),
    descripcion character varying(150),
    categoria integer,
    estatus integer,
    activo boolean,
    fecha_creacion timestamp with time zone DEFAULT now()
);


ALTER TABLE bancos.subcategorias OWNER TO geekhack;

--
-- Name: COLUMN subcategorias.categoria; Type: COMMENT; Schema: bancos; Owner: geekhack
--

COMMENT ON COLUMN bancos.subcategorias.categoria IS 'id categoria padre';


--
-- Name: tipos; Type: TABLE; Schema: bancos; Owner: geekhack
--

CREATE TABLE bancos.tipos (
    id integer NOT NULL,
    codigo character varying(30),
    referencia character varying(30),
    grupo character varying(10),
    tipo character varying(20),
    descripcion character varying(150),
    fecha_creacion timestamp with time zone DEFAULT now()
);


ALTER TABLE bancos.tipos OWNER TO geekhack;

--
-- Name: COLUMN tipos.grupo; Type: COMMENT; Schema: bancos; Owner: geekhack
--

COMMENT ON COLUMN bancos.tipos.grupo IS 'cuenta/movimiento/';


--
-- Name: tipos_id_seq; Type: SEQUENCE; Schema: bancos; Owner: geekhack
--

CREATE SEQUENCE bancos.tipos_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE bancos.tipos_id_seq OWNER TO geekhack;

--
-- Name: tipos_id_seq; Type: SEQUENCE OWNED BY; Schema: bancos; Owner: geekhack
--

ALTER SEQUENCE bancos.tipos_id_seq OWNED BY bancos.tipos.id;


--
-- Name: titulares; Type: TABLE; Schema: bancos; Owner: geekhack
--

CREATE TABLE bancos.titulares (
    id bigint NOT NULL,
    tipo integer,
    nombre character varying(100),
    apellido character varying(100),
    rif character varying(20),
    telefono character varying(20),
    email character varying(50),
    estatus smallint,
    activo boolean,
    "idCiudad" integer,
    "idPais" smallint,
    zona_postal character varying(20),
    fecha_creacion timestamp with time zone DEFAULT now(),
    usuario integer
);


ALTER TABLE bancos.titulares OWNER TO geekhack;

--
-- Name: COLUMN titulares.tipo; Type: COMMENT; Schema: bancos; Owner: geekhack
--

COMMENT ON COLUMN bancos.titulares.tipo IS 'id tipo titular (juridico/natural)';


--
-- Name: COLUMN titulares.nombre; Type: COMMENT; Schema: bancos; Owner: geekhack
--

COMMENT ON COLUMN bancos.titulares.nombre IS 'nombre o razon comercial';


--
-- Name: COLUMN titulares.apellido; Type: COMMENT; Schema: bancos; Owner: geekhack
--

COMMENT ON COLUMN bancos.titulares.apellido IS 'apellido o razon social';


--
-- Name: COLUMN titulares.rif; Type: COMMENT; Schema: bancos; Owner: geekhack
--

COMMENT ON COLUMN bancos.titulares.rif IS 'numero de identificacion fiscal';


--
-- Name: COLUMN titulares.estatus; Type: COMMENT; Schema: bancos; Owner: geekhack
--

COMMENT ON COLUMN bancos.titulares.estatus IS 'id estatus titular';


--
-- Name: COLUMN titulares.usuario; Type: COMMENT; Schema: bancos; Owner: geekhack
--

COMMENT ON COLUMN bancos.titulares.usuario IS 'id usuario';


--
-- Name: titulares_id_seq; Type: SEQUENCE; Schema: bancos; Owner: geekhack
--

CREATE SEQUENCE bancos.titulares_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE bancos.titulares_id_seq OWNER TO geekhack;

--
-- Name: titulares_id_seq; Type: SEQUENCE OWNED BY; Schema: bancos; Owner: geekhack
--

ALTER SEQUENCE bancos.titulares_id_seq OWNED BY bancos.titulares.id;


--
-- Name: titulares_tipo_seq; Type: SEQUENCE; Schema: bancos; Owner: geekhack
--

CREATE SEQUENCE bancos.titulares_tipo_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE bancos.titulares_tipo_seq OWNER TO geekhack;

--
-- Name: titulares_tipo_seq; Type: SEQUENCE OWNED BY; Schema: bancos; Owner: geekhack
--

ALTER SEQUENCE bancos.titulares_tipo_seq OWNED BY bancos.titulares.tipo;


--
-- Name: v_bancos4; Type: VIEW; Schema: bancos; Owner: geekhack
--

CREATE VIEW bancos.v_bancos4 AS
 SELECT cuentas.id,
    concat(( SELECT bancos.razon_comercial
           FROM bancos.bancos
          WHERE (bancos.id = cuentas.banco)), ' ', "substring"((cuentas.referencia)::text, 17, 4)) AS cuenta_detallada
   FROM bancos.cuentas;


ALTER TABLE bancos.v_bancos4 OWNER TO geekhack;

--
-- Name: v_bancosbod; Type: VIEW; Schema: bancos; Owner: postgres
--

CREATE VIEW bancos.v_bancosbod AS
 SELECT cuentas.id,
    concat("substring"((cuentas.numero)::text, 13, 3), '**', "substring"((cuentas.numero)::text, 18, 3)) AS codigo,
    cuentas.banco,
    cuentas.usuario
   FROM bancos.cuentas
  WHERE ((cuentas.codigo)::text = '0116'::text);


ALTER TABLE bancos.v_bancosbod OWNER TO postgres;

--
-- Name: v_bancosmercantil; Type: VIEW; Schema: bancos; Owner: postgres
--

CREATE VIEW bancos.v_bancosmercantil AS
 SELECT cuentas.id,
    "substring"((cuentas.numero)::text, 11, 10) AS codigo,
    cuentas.banco,
    cuentas.usuario
   FROM bancos.cuentas
  WHERE ((cuentas.codigo)::text = '0105'::text);


ALTER TABLE bancos.v_bancosmercantil OWNER TO postgres;

--
-- Name: productos; Type: TABLE; Schema: maestros; Owner: geekhack
--

CREATE TABLE maestros.productos (
    id integer NOT NULL,
    nombre character varying(100) NOT NULL,
    activo boolean DEFAULT true NOT NULL
);


ALTER TABLE maestros.productos OWNER TO geekhack;

--
-- Name: v_cuenta_descripcion; Type: VIEW; Schema: bancos; Owner: postgres
--

CREATE VIEW bancos.v_cuenta_descripcion AS
 SELECT cuentas.id,
        CASE
            WHEN (cuentas.tipo = 1) THEN ("substring"((cuentas.numero)::text, 17, 4))::character varying
            WHEN (cuentas.tipo = 2) THEN ("substring"((cuentas.numero)::text, 17, 4))::character varying
            WHEN (cuentas.tipo = 3) THEN ("substring"((cuentas.numero)::text, 9, 4))::character varying
            WHEN (cuentas.tipo = 4) THEN ("substring"((cuentas.numero)::text, 9, 4))::character varying
            ELSE cuentas.numero
        END AS cuenta,
    bancos.razon_comercial,
    bancos.id AS idb,
    cuentas.tipo,
    cuentas.usuario,
    ( SELECT productos.nombre
           FROM maestros.productos
          WHERE (productos.id = cuentas.tipo)) AS producto
   FROM (bancos.bancos
     JOIN bancos.cuentas ON ((bancos.id = cuentas.banco)));


ALTER TABLE bancos.v_cuenta_descripcion OWNER TO postgres;

--
-- Name: v_maestrobanco; Type: VIEW; Schema: bancos; Owner: postgres
--

CREATE VIEW bancos.v_maestrobanco AS
 SELECT banco.id AS idbanco,
    banco.razon_comercial AS nombrecomercial,
    banco.razon_social AS rasonsocial,
    banco.rif AS rifbanco,
    banco.direccion AS direccionbanco,
    banco.estatus AS estatubanco,
    banco.fecha_creacion AS fechacreacion,
    banco.activo AS activobanco,
    banco.codigo AS codbanco
   FROM bancos.bancos banco
  ORDER BY banco.razon_comercial;


ALTER TABLE bancos.v_maestrobanco OWNER TO postgres;

--
-- Name: v_movimientobanescoconciliar; Type: VIEW; Schema: bancos; Owner: geekhack
--

CREATE VIEW bancos.v_movimientobanescoconciliar AS
 SELECT "substring"((bm.descripcion)::text, 8, 4) AS codigo_trans,
    upper("substring"((bm.descripcion)::text, 13, 10)) AS cedula_trans,
    bm.id,
    bm.codigo,
    bm.referencia,
    bm.fecha_creacion,
    bm.fecha,
    bm.monto,
    bm.divisa,
    bm.tipo,
    bm.operacion,
    bm.descripcion,
    bm.cuenta,
    bm.usuario,
    bm.aux,
    bm.referencia_2
   FROM bancos.movimientos bm
  WHERE (((bm.descripcion)::text ~~ '%trf.ob%'::text) AND (( SELECT cuentas.banco
           FROM bancos.cuentas
          WHERE (cuentas.id = bm.cuenta)) = 2));


ALTER TABLE bancos.v_movimientobanescoconciliar OWNER TO geekhack;

--
-- Name: v_movimientobncconciliar; Type: VIEW; Schema: bancos; Owner: geekhack
--

CREATE VIEW bancos.v_movimientobncconciliar AS
 SELECT bm.id,
    bm.codigo,
    bm.referencia,
    bm.fecha_creacion,
    bm.fecha,
    bm.monto,
    bm.divisa,
    bm.tipo,
    bm.operacion,
    bm.descripcion,
    bm.cuenta,
    bm.usuario,
    bm.aux,
    bm.referencia_2
   FROM bancos.movimientos bm
  WHERE (( SELECT cuentas.banco
           FROM bancos.cuentas
          WHERE (cuentas.id = bm.cuenta)) = 3);


ALTER TABLE bancos.v_movimientobncconciliar OWNER TO geekhack;

--
-- Name: v_movimientobodconciliar; Type: VIEW; Schema: bancos; Owner: postgres
--

CREATE VIEW bancos.v_movimientobodconciliar AS
 SELECT mb.id,
    mb.codigo,
    mb.referencia,
    mb.fecha_creacion,
    mb.fecha,
    mb.monto,
    mb.divisa,
    mb.tipo,
    mb.operacion,
    mb.descripcion,
    mb.cuenta,
    mb.usuario,
    mb.aux,
    mb.referencia_2
   FROM bancos.movimientos mb
  WHERE (( SELECT cuentas.banco
           FROM bancos.cuentas
          WHERE (cuentas.id = mb.cuenta)) = 4);


ALTER TABLE bancos.v_movimientobodconciliar OWNER TO postgres;

--
-- Name: usuarios_id_seq; Type: SEQUENCE; Schema: seguridad; Owner: postgres
--

CREATE SEQUENCE seguridad.usuarios_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE seguridad.usuarios_id_seq OWNER TO postgres;

--
-- Name: usuarios; Type: TABLE; Schema: seguridad; Owner: postgres
--

CREATE TABLE seguridad.usuarios (
    id integer DEFAULT nextval('seguridad.usuarios_id_seq'::regclass) NOT NULL,
    codigo character varying(30),
    referencia character varying(30),
    nombre character varying(50),
    apellido character varying(50),
    estatus smallint,
    activo boolean DEFAULT false,
    passwd character varying(50),
    email character varying(100),
    telefono character varying(20),
    ciudad integer,
    pais integer,
    zona_postal character varying(20),
    fecha_creacion timestamp with time zone DEFAULT now(),
    empresa integer DEFAULT 0 NOT NULL
);


ALTER TABLE seguridad.usuarios OWNER TO postgres;

--
-- Name: COLUMN usuarios.referencia; Type: COMMENT; Schema: seguridad; Owner: postgres
--

COMMENT ON COLUMN seguridad.usuarios.referencia IS 'equivalente a nombre de usuario (username)';


--
-- Name: v_usuariocuenta; Type: VIEW; Schema: bancos; Owner: geekhack
--

CREATE VIEW bancos.v_usuariocuenta WITH (security_barrier='false') AS
 SELECT cuenta.id AS idcuenta,
    cuenta.codigo AS cod,
    cuenta.referencia,
    cuenta.estatus AS estatu,
    cuenta.fecha_creacion AS fechcreacion,
    cuenta.fecha_mod AS fechmod,
    cuenta.activo,
    cuenta.numero,
    cuenta.aba,
    cuenta.iban,
    cuenta.bic,
    cuenta.tipo,
    cuenta.divisa,
    cuenta.saldo_inicial AS saldoinicial,
    cuenta.titulo,
    cuenta.saldo,
    cuenta.fecha_saldo AS fechsaldo,
    cuenta.swift,
    banco.id AS idbanco,
    banco.razon_comercial AS nombrebanco,
    usuario.id AS idusuario,
    usuario.nombre AS nombreusuario,
        CASE
            WHEN ((cuenta.fecha_saldo + 2) <= now()) THEN 1
            ELSE 2
        END AS retrazado,
    ( SELECT count(*) AS count
           FROM bancos.movimientos
          WHERE (movimientos.cuenta = cuenta.id)) AS movimiento
   FROM ((bancos.cuentas cuenta
     JOIN seguridad.usuarios usuario ON ((cuenta.usuario = usuario.id)))
     JOIN bancos.bancos banco ON ((cuenta.banco = banco.id)))
  ORDER BY banco.razon_comercial;


ALTER TABLE bancos.v_usuariocuenta OWNER TO geekhack;

--
-- Name: v_usuariomovimiento; Type: VIEW; Schema: bancos; Owner: geekhack
--

CREATE VIEW bancos.v_usuariomovimiento AS
 SELECT movimiento.id AS idmovimiento,
    movimiento.codigo AS codigomovimiento,
    movimiento.referencia AS referenciamovimiento,
    movimiento.fecha_creacion AS fechcreacionmovimiento,
    movimiento.fecha AS fechmovimiento,
    movimiento.monto AS montomovimiento,
    movimiento.divisa AS divisamovimiento,
    movimiento.operacion AS operacionmovimiento,
    movimiento.descripcion AS descripcionmovimiento,
    movimiento.tipo AS idcategoria,
    cuenta.id AS idcuenta,
    cuenta.numero AS numerocuenta,
    cuenta.banco AS idbanco,
    movimiento.usuario AS idusuario,
    info.subcategoria AS idsubcategoria,
    info.nota,
    ( SELECT bancos.razon_social
           FROM bancos.bancos
          WHERE (bancos.id = cuenta.banco)) AS nombrebanco,
    ( SELECT categorias.titulo
           FROM bancos.categorias
          WHERE (categorias.id = movimiento.tipo)) AS titulocategoria,
    ( SELECT subcategorias.titulo
           FROM bancos.subcategorias
          WHERE (subcategorias.id = info.subcategoria)) AS titulosubcategoria
   FROM ((bancos.movimientos movimiento
     JOIN bancos.movimientos_info info ON ((info.id = movimiento.id)))
     JOIN bancos.cuentas cuenta ON ((cuenta.id = movimiento.cuenta)))
  WHERE (cuenta.estatus = 1)
  ORDER BY movimiento.id DESC;


ALTER TABLE bancos.v_usuariomovimiento OWNER TO geekhack;

--
-- Name: conciliacion_reporte; Type: TABLE; Schema: conciliacion; Owner: geekhack
--

CREATE TABLE conciliacion.conciliacion_reporte (
    id integer NOT NULL,
    fecha_creacion time with time zone DEFAULT now() NOT NULL,
    descripcion character varying(100),
    usuario integer NOT NULL,
    total_c integer NOT NULL,
    total_nc integer NOT NULL,
    total_ncm integer NOT NULL
);


ALTER TABLE conciliacion.conciliacion_reporte OWNER TO geekhack;

--
-- Name: conciliacion_reportepago; Type: TABLE; Schema: conciliacion; Owner: geekhack
--

CREATE TABLE conciliacion.conciliacion_reportepago (
    id integer NOT NULL,
    id_reporte integer NOT NULL,
    estatus boolean DEFAULT true NOT NULL,
    id_pago integer NOT NULL,
    usuario integer NOT NULL
);


ALTER TABLE conciliacion.conciliacion_reportepago OWNER TO geekhack;

--
-- Name: conciliacion_reportePago_id_reporte_seq; Type: SEQUENCE; Schema: conciliacion; Owner: geekhack
--

CREATE SEQUENCE conciliacion."conciliacion_reportePago_id_reporte_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE conciliacion."conciliacion_reportePago_id_reporte_seq" OWNER TO geekhack;

--
-- Name: conciliacion_reportePago_id_reporte_seq; Type: SEQUENCE OWNED BY; Schema: conciliacion; Owner: geekhack
--

ALTER SEQUENCE conciliacion."conciliacion_reportePago_id_reporte_seq" OWNED BY conciliacion.conciliacion_reportepago.id_reporte;


--
-- Name: conciliacion_reportePago_id_seq; Type: SEQUENCE; Schema: conciliacion; Owner: geekhack
--

CREATE SEQUENCE conciliacion."conciliacion_reportePago_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE conciliacion."conciliacion_reportePago_id_seq" OWNER TO geekhack;

--
-- Name: conciliacion_reportePago_id_seq; Type: SEQUENCE OWNED BY; Schema: conciliacion; Owner: geekhack
--

ALTER SEQUENCE conciliacion."conciliacion_reportePago_id_seq" OWNED BY conciliacion.conciliacion_reportepago.id;


--
-- Name: conciliacion_reporte_total_nc_seq; Type: SEQUENCE; Schema: conciliacion; Owner: geekhack
--

CREATE SEQUENCE conciliacion.conciliacion_reporte_total_nc_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE conciliacion.conciliacion_reporte_total_nc_seq OWNER TO geekhack;

--
-- Name: conciliacion_reporte_total_nc_seq; Type: SEQUENCE OWNED BY; Schema: conciliacion; Owner: geekhack
--

ALTER SEQUENCE conciliacion.conciliacion_reporte_total_nc_seq OWNED BY conciliacion.conciliacion_reporte.total_nc;


--
-- Name: conciliacion_reportepago_id_pago_seq; Type: SEQUENCE; Schema: conciliacion; Owner: geekhack
--

CREATE SEQUENCE conciliacion.conciliacion_reportepago_id_pago_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE conciliacion.conciliacion_reportepago_id_pago_seq OWNER TO geekhack;

--
-- Name: conciliacion_reportepago_id_pago_seq; Type: SEQUENCE OWNED BY; Schema: conciliacion; Owner: geekhack
--

ALTER SEQUENCE conciliacion.conciliacion_reportepago_id_pago_seq OWNED BY conciliacion.conciliacion_reportepago.id_pago;


--
-- Name: reporte_conciliacion_id_seq; Type: SEQUENCE; Schema: conciliacion; Owner: geekhack
--

CREATE SEQUENCE conciliacion.reporte_conciliacion_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE conciliacion.reporte_conciliacion_id_seq OWNER TO geekhack;

--
-- Name: reporte_conciliacion_id_seq; Type: SEQUENCE OWNED BY; Schema: conciliacion; Owner: geekhack
--

ALTER SEQUENCE conciliacion.reporte_conciliacion_id_seq OWNED BY conciliacion.conciliacion_reporte.id;


--
-- Name: v_cociliacionreporte; Type: VIEW; Schema: conciliacion; Owner: geekhack
--

CREATE VIEW conciliacion.v_cociliacionreporte AS
 SELECT cr.id,
    cr.fecha_creacion,
    cr.descripcion,
    cr.usuario,
    cr.total_c,
    cr.total_nc,
    cr.total_ncm,
    crp.id_pago
   FROM (conciliacion.conciliacion_reporte cr
     JOIN conciliacion.conciliacion_reportepago crp ON ((cr.id = crp.id_reporte)));


ALTER TABLE conciliacion.v_cociliacionreporte OWNER TO geekhack;

--
-- Name: ciudades; Type: TABLE; Schema: maestros; Owner: geekhack
--

CREATE TABLE maestros.ciudades (
    id integer NOT NULL,
    codigo character varying(30),
    referencia character varying(30),
    nombre character varying(50),
    descripcion character varying(100),
    estatus smallint,
    activo boolean,
    "idPais" integer,
    estado integer NOT NULL
);


ALTER TABLE maestros.ciudades OWNER TO geekhack;

--
-- Name: COLUMN ciudades.estatus; Type: COMMENT; Schema: maestros; Owner: geekhack
--

COMMENT ON COLUMN maestros.ciudades.estatus IS 'id estatus ciudad';


--
-- Name: ciudades_id_seq; Type: SEQUENCE; Schema: maestros; Owner: geekhack
--

CREATE SEQUENCE maestros.ciudades_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE maestros.ciudades_id_seq OWNER TO geekhack;

--
-- Name: ciudades_id_seq; Type: SEQUENCE OWNED BY; Schema: maestros; Owner: geekhack
--

ALTER SEQUENCE maestros.ciudades_id_seq OWNED BY maestros.ciudades.id;


--
-- Name: divisas; Type: TABLE; Schema: maestros; Owner: geekhack
--

CREATE TABLE maestros.divisas (
    id integer NOT NULL,
    nombre character varying(100) NOT NULL,
    nombreiso character varying(30) NOT NULL,
    codigo character varying(10) NOT NULL,
    simbolo character varying(10) NOT NULL,
    tipo character varying(10) DEFAULT 'fisica'::character varying NOT NULL,
    activo boolean DEFAULT false NOT NULL
);


ALTER TABLE maestros.divisas OWNER TO geekhack;

--
-- Name: divisas_id_seq; Type: SEQUENCE; Schema: maestros; Owner: geekhack
--

CREATE SEQUENCE maestros.divisas_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE maestros.divisas_id_seq OWNER TO geekhack;

--
-- Name: divisas_id_seq; Type: SEQUENCE OWNED BY; Schema: maestros; Owner: geekhack
--

ALTER SEQUENCE maestros.divisas_id_seq OWNED BY maestros.divisas.id;


--
-- Name: estados; Type: TABLE; Schema: maestros; Owner: geekhack
--

CREATE TABLE maestros.estados (
    id integer NOT NULL,
    codigo integer NOT NULL,
    nombre character varying(50) NOT NULL,
    estatus boolean DEFAULT true NOT NULL,
    idpais integer NOT NULL
);


ALTER TABLE maestros.estados OWNER TO geekhack;

--
-- Name: estados_id_seq; Type: SEQUENCE; Schema: maestros; Owner: geekhack
--

CREATE SEQUENCE maestros.estados_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE maestros.estados_id_seq OWNER TO geekhack;

--
-- Name: estados_id_seq; Type: SEQUENCE OWNED BY; Schema: maestros; Owner: geekhack
--

ALTER SEQUENCE maestros.estados_id_seq OWNED BY maestros.estados.id;


--
-- Name: funciones; Type: TABLE; Schema: maestros; Owner: postgres
--

CREATE TABLE maestros.funciones (
    _id integer NOT NULL,
    nombre text
);


ALTER TABLE maestros.funciones OWNER TO postgres;

--
-- Name: funciones_id_seq; Type: SEQUENCE; Schema: maestros; Owner: postgres
--

CREATE SEQUENCE maestros.funciones_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE maestros.funciones_id_seq OWNER TO postgres;

--
-- Name: funciones_id_seq; Type: SEQUENCE OWNED BY; Schema: maestros; Owner: postgres
--

ALTER SEQUENCE maestros.funciones_id_seq OWNED BY maestros.funciones._id;


--
-- Name: identificar_banco; Type: TABLE; Schema: maestros; Owner: geekhack
--

CREATE TABLE maestros.identificar_banco (
    id integer NOT NULL,
    descripcion character varying(500) NOT NULL,
    id_banco integer NOT NULL,
    activo boolean NOT NULL
);


ALTER TABLE maestros.identificar_banco OWNER TO geekhack;

--
-- Name: identificar_banco_id_seq; Type: SEQUENCE; Schema: maestros; Owner: geekhack
--

CREATE SEQUENCE maestros.identificar_banco_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE maestros.identificar_banco_id_seq OWNER TO geekhack;

--
-- Name: identificar_banco_id_seq; Type: SEQUENCE OWNED BY; Schema: maestros; Owner: geekhack
--

ALTER SEQUENCE maestros.identificar_banco_id_seq OWNED BY maestros.identificar_banco.id;


--
-- Name: modulos; Type: TABLE; Schema: maestros; Owner: postgres
--

CREATE TABLE maestros.modulos (
    _id integer NOT NULL,
    nombre text
);


ALTER TABLE maestros.modulos OWNER TO postgres;

--
-- Name: modulos_id_seq; Type: SEQUENCE; Schema: maestros; Owner: postgres
--

CREATE SEQUENCE maestros.modulos_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE maestros.modulos_id_seq OWNER TO postgres;

--
-- Name: modulos_id_seq; Type: SEQUENCE OWNED BY; Schema: maestros; Owner: postgres
--

ALTER SEQUENCE maestros.modulos_id_seq OWNED BY maestros.modulos._id;


--
-- Name: paises; Type: TABLE; Schema: maestros; Owner: geekhack
--

CREATE TABLE maestros.paises (
    id integer NOT NULL,
    codigo character varying(30),
    referencia character varying(30),
    nombre character varying(50),
    descripcion character varying(100),
    estatus smallint,
    activo boolean
);


ALTER TABLE maestros.paises OWNER TO geekhack;

--
-- Name: productos_id_seq; Type: SEQUENCE; Schema: maestros; Owner: geekhack
--

CREATE SEQUENCE maestros.productos_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE maestros.productos_id_seq OWNER TO geekhack;

--
-- Name: productos_id_seq; Type: SEQUENCE OWNED BY; Schema: maestros; Owner: geekhack
--

ALTER SEQUENCE maestros.productos_id_seq OWNED BY maestros.productos.id;


--
-- Name: status; Type: TABLE; Schema: maestros; Owner: postgres
--

CREATE TABLE maestros.status (
    _id integer NOT NULL,
    nombre text
);


ALTER TABLE maestros.status OWNER TO postgres;

--
-- Name: status_id_seq; Type: SEQUENCE; Schema: maestros; Owner: postgres
--

CREATE SEQUENCE maestros.status_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE maestros.status_id_seq OWNER TO postgres;

--
-- Name: status_id_seq; Type: SEQUENCE OWNED BY; Schema: maestros; Owner: postgres
--

ALTER SEQUENCE maestros.status_id_seq OWNED BY maestros.status._id;


--
-- Name: configuracion; Type: TABLE; Schema: seguridad; Owner: postgres
--

CREATE TABLE seguridad.configuracion (
    _id integer NOT NULL,
    nombre text NOT NULL,
    nombre_corto text,
    rif text NOT NULL,
    telefono text,
    telefono_movil text,
    email text,
    direccion text NOT NULL,
    logo character varying(100)
);


ALTER TABLE seguridad.configuracion OWNER TO postgres;

--
-- Name: configuracion__id_seq; Type: SEQUENCE; Schema: seguridad; Owner: postgres
--

CREATE SEQUENCE seguridad.configuracion__id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE seguridad.configuracion__id_seq OWNER TO postgres;

--
-- Name: configuracion__id_seq; Type: SEQUENCE OWNED BY; Schema: seguridad; Owner: postgres
--

ALTER SEQUENCE seguridad.configuracion__id_seq OWNED BY seguridad.configuracion._id;


--
-- Name: log; Type: TABLE; Schema: seguridad; Owner: geekhack
--

CREATE TABLE seguridad.log (
    id bigint NOT NULL,
    codigo character varying(30),
    referencia character varying(30),
    fecha_creacion timestamp with time zone DEFAULT now(),
    operacion character varying(30),
    tabla character varying(30),
    query text
);


ALTER TABLE seguridad.log OWNER TO geekhack;

--
-- Name: COLUMN log.operacion; Type: COMMENT; Schema: seguridad; Owner: geekhack
--

COMMENT ON COLUMN seguridad.log.operacion IS 'INSERT/UPDATE/DELETE';


--
-- Name: log_id_seq; Type: SEQUENCE; Schema: seguridad; Owner: geekhack
--

CREATE SEQUENCE seguridad.log_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE seguridad.log_id_seq OWNER TO geekhack;

--
-- Name: log_id_seq; Type: SEQUENCE OWNED BY; Schema: seguridad; Owner: geekhack
--

ALTER SEQUENCE seguridad.log_id_seq OWNED BY seguridad.log.id;


--
-- Name: perfil; Type: TABLE; Schema: seguridad; Owner: postgres
--

CREATE TABLE seguridad.perfil (
    _id integer NOT NULL,
    idrol integer NOT NULL,
    idmodulo integer NOT NULL,
    idfuncion integer NOT NULL
);


ALTER TABLE seguridad.perfil OWNER TO postgres;

--
-- Name: perfil_id_seq; Type: SEQUENCE; Schema: seguridad; Owner: postgres
--

CREATE SEQUENCE seguridad.perfil_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE seguridad.perfil_id_seq OWNER TO postgres;

--
-- Name: perfil_id_seq; Type: SEQUENCE OWNED BY; Schema: seguridad; Owner: postgres
--

ALTER SEQUENCE seguridad.perfil_id_seq OWNED BY seguridad.perfil._id;


--
-- Name: redes; Type: TABLE; Schema: seguridad; Owner: postgres
--

CREATE TABLE seguridad.redes (
    _id integer NOT NULL,
    facebook text,
    linkedin text,
    idusuario integer NOT NULL
);


ALTER TABLE seguridad.redes OWNER TO postgres;

--
-- Name: redes__id_seq; Type: SEQUENCE; Schema: seguridad; Owner: postgres
--

CREATE SEQUENCE seguridad.redes__id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE seguridad.redes__id_seq OWNER TO postgres;

--
-- Name: redes__id_seq; Type: SEQUENCE OWNED BY; Schema: seguridad; Owner: postgres
--

ALTER SEQUENCE seguridad.redes__id_seq OWNED BY seguridad.redes._id;


--
-- Name: roles; Type: TABLE; Schema: seguridad; Owner: postgres
--

CREATE TABLE seguridad.roles (
    _id integer NOT NULL,
    nombre text NOT NULL,
    idstatu integer NOT NULL
);


ALTER TABLE seguridad.roles OWNER TO postgres;

--
-- Name: roles__id_seq; Type: SEQUENCE; Schema: seguridad; Owner: postgres
--

CREATE SEQUENCE seguridad.roles__id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE seguridad.roles__id_seq OWNER TO postgres;

--
-- Name: roles__id_seq; Type: SEQUENCE OWNED BY; Schema: seguridad; Owner: postgres
--

ALTER SEQUENCE seguridad.roles__id_seq OWNED BY seguridad.roles._id;


--
-- Name: bancos id; Type: DEFAULT; Schema: bancos; Owner: geekhack
--

ALTER TABLE ONLY bancos.bancos ALTER COLUMN id SET DEFAULT nextval('bancos.bancos_id_seq'::regclass);


--
-- Name: categorias id; Type: DEFAULT; Schema: bancos; Owner: geekhack
--

ALTER TABLE ONLY bancos.categorias ALTER COLUMN id SET DEFAULT nextval('bancos.categorias_id_seq'::regclass);


--
-- Name: cuentas id; Type: DEFAULT; Schema: bancos; Owner: geekhack
--

ALTER TABLE ONLY bancos.cuentas ALTER COLUMN id SET DEFAULT nextval('bancos.cuentas_id_seq'::regclass);


--
-- Name: movimientos id; Type: DEFAULT; Schema: bancos; Owner: geekhack
--

ALTER TABLE ONLY bancos.movimientos ALTER COLUMN id SET DEFAULT nextval('bancos.movimientos_id_seq'::regclass);


--
-- Name: tipos id; Type: DEFAULT; Schema: bancos; Owner: geekhack
--

ALTER TABLE ONLY bancos.tipos ALTER COLUMN id SET DEFAULT nextval('bancos.tipos_id_seq'::regclass);


--
-- Name: titulares id; Type: DEFAULT; Schema: bancos; Owner: geekhack
--

ALTER TABLE ONLY bancos.titulares ALTER COLUMN id SET DEFAULT nextval('bancos.titulares_id_seq'::regclass);


--
-- Name: conciliacion_reporte id; Type: DEFAULT; Schema: conciliacion; Owner: geekhack
--

ALTER TABLE ONLY conciliacion.conciliacion_reporte ALTER COLUMN id SET DEFAULT nextval('conciliacion.reporte_conciliacion_id_seq'::regclass);


--
-- Name: conciliacion_reportepago id; Type: DEFAULT; Schema: conciliacion; Owner: geekhack
--

ALTER TABLE ONLY conciliacion.conciliacion_reportepago ALTER COLUMN id SET DEFAULT nextval('conciliacion."conciliacion_reportePago_id_seq"'::regclass);


--
-- Name: ciudades id; Type: DEFAULT; Schema: maestros; Owner: geekhack
--

ALTER TABLE ONLY maestros.ciudades ALTER COLUMN id SET DEFAULT nextval('maestros.ciudades_id_seq'::regclass);


--
-- Name: divisas id; Type: DEFAULT; Schema: maestros; Owner: geekhack
--

ALTER TABLE ONLY maestros.divisas ALTER COLUMN id SET DEFAULT nextval('maestros.divisas_id_seq'::regclass);


--
-- Name: estados id; Type: DEFAULT; Schema: maestros; Owner: geekhack
--

ALTER TABLE ONLY maestros.estados ALTER COLUMN id SET DEFAULT nextval('maestros.estados_id_seq'::regclass);


--
-- Name: funciones _id; Type: DEFAULT; Schema: maestros; Owner: postgres
--

ALTER TABLE ONLY maestros.funciones ALTER COLUMN _id SET DEFAULT nextval('maestros.funciones_id_seq'::regclass);


--
-- Name: identificar_banco id; Type: DEFAULT; Schema: maestros; Owner: geekhack
--

ALTER TABLE ONLY maestros.identificar_banco ALTER COLUMN id SET DEFAULT nextval('maestros.identificar_banco_id_seq'::regclass);


--
-- Name: modulos _id; Type: DEFAULT; Schema: maestros; Owner: postgres
--

ALTER TABLE ONLY maestros.modulos ALTER COLUMN _id SET DEFAULT nextval('maestros.modulos_id_seq'::regclass);


--
-- Name: productos id; Type: DEFAULT; Schema: maestros; Owner: geekhack
--

ALTER TABLE ONLY maestros.productos ALTER COLUMN id SET DEFAULT nextval('maestros.productos_id_seq'::regclass);


--
-- Name: status _id; Type: DEFAULT; Schema: maestros; Owner: postgres
--

ALTER TABLE ONLY maestros.status ALTER COLUMN _id SET DEFAULT nextval('maestros.status_id_seq'::regclass);


--
-- Name: configuracion _id; Type: DEFAULT; Schema: seguridad; Owner: postgres
--

ALTER TABLE ONLY seguridad.configuracion ALTER COLUMN _id SET DEFAULT nextval('seguridad.configuracion__id_seq'::regclass);


--
-- Name: log id; Type: DEFAULT; Schema: seguridad; Owner: geekhack
--

ALTER TABLE ONLY seguridad.log ALTER COLUMN id SET DEFAULT nextval('seguridad.log_id_seq'::regclass);


--
-- Name: perfil _id; Type: DEFAULT; Schema: seguridad; Owner: postgres
--

ALTER TABLE ONLY seguridad.perfil ALTER COLUMN _id SET DEFAULT nextval('seguridad.perfil_id_seq'::regclass);


--
-- Name: redes _id; Type: DEFAULT; Schema: seguridad; Owner: postgres
--

ALTER TABLE ONLY seguridad.redes ALTER COLUMN _id SET DEFAULT nextval('seguridad.redes__id_seq'::regclass);


--
-- Name: roles _id; Type: DEFAULT; Schema: seguridad; Owner: postgres
--

ALTER TABLE ONLY seguridad.roles ALTER COLUMN _id SET DEFAULT nextval('seguridad.roles__id_seq'::regclass);


--
-- Data for Name: bancos; Type: TABLE DATA; Schema: bancos; Owner: geekhack
--

COPY bancos.bancos (id, razon_comercial, razon_social, rif, "idCiudad", "idPais", direccion, "idContacto", estatus, fecha_creacion, activo, codigo, tipo) FROM stdin;
2	Banesco	Banesco Banco Universal	J-07013380-5	\N	\N	\N	\N	1	2019-03-31 11:08:13.925663-04	t	0134	1
7	LocalEthereum	LocalEthereum	0000000	1	1	https://localethereum.com/es/	1	1	2019-05-30 10:56:51.597613-04	t	LE00	2
1	Mercantil	Mercantil Banco	J-00002961-0	\N	\N	\N	\N	1	2019-03-31 11:07:30.495798-04	t	0105	1
3	BNC	Banco Nacional de Credito	226254452542	1	1	centro	1	1	2019-05-14 12:35:27.834138-04	t	0191	1
4	BOD	Banco Occidental de Descuento	2343242	1	1	centro	1	1	2019-05-14 12:39:58.059315-04	t	0116	1
5	LocalBitcoins	LocalBitcoins	000000	1	1	https://localbitcoins.com/	1	1	2019-05-30 10:55:01.933269-04	t	LB00	2
8	Bancrecer	Bancrecer	00	1	1	centro	1	1	2019-09-18 11:37:09.447981-04	t	0168	1
6	Bancaribe	Bancaribe	0000	1	1	centro	1	1	2019-09-18 11:35:11.188285-04	t	0114	1
\.


--
-- Data for Name: categorias; Type: TABLE DATA; Schema: bancos; Owner: geekhack
--

COPY bancos.categorias (id, codigo, referencia, titulo, descripcion, activo, estatus, fecha_creacion, icono, grupo) FROM stdin;
1	ING	ingreso	Ingresos	\N	t	1	2019-04-08 09:28:32.217027-04	\N	movimientos
2	EGR	egreso	Egreso	\N	t	1	2019-04-08 09:28:32.217027-04	\N	movimientos
\.


--
-- Data for Name: cuentas; Type: TABLE DATA; Schema: bancos; Owner: geekhack
--

COPY bancos.cuentas (id, codigo, referencia, estatus, fecha_creacion, fecha_mod, activo, numero, aba, iban, bic, tipo, divisa, banco, saldo_inicial, titulo, saldo, fecha_saldo, swift, usuario) FROM stdin;
326	0191	01910000000000000003	1	2019-09-10 09:18:16.819127-04	2019-09-10	t	01910000000000000003	aba	iban	bic	1	1	3	20000	titulo	117517.5	2019-09-10	swift	1
333	0105	01050001345677894005	1	2019-09-11 10:38:57.704658-04	2019-09-11	t	01050001345677894005	aba	iban	bic	1	1	1	2014567.78000000003	titulo	1848867.23000000021	2019-01-31	swift	6
328	0191	01910001451101045051	1	2019-09-10 14:57:15.898579-04	2019-09-10	t	01910001451101045051	aba	iban	bic	1	1	3	139970.380000000005	titulo	-14403.3299999999836	2019-09-13	swift	6
335	0114	01140000000000000001	1	2019-09-18 11:44:14.10463-04	2019-09-18	t	01140000000000000001	aba	iban	bic	1	1	6	100000	titulo	606439.300000000047	2019-09-19	swift	1
325	0105	01050000000000000002	1	2019-09-10 09:17:44.267681-04	2019-09-10	t	01050000000000000002	aba	iban	bic	1	1	1	1000000	titulo	2550855.31000000052	2019-09-19	swift	1
334	0134	01348686896868767687	1	2019-09-11 15:04:04.002023-04	2019-09-11	t	01348686896868767687	aba	iban	bic	1	3	2	333333.330000000016	titulo	4340160.67000000179	2019-09-19	swift	1
327	0116	01160000000000000004	1	2019-09-10 09:18:39.038423-04	2019-09-10	t	01160000000000000004	aba	iban	bic	1	1	4	190289.279999999999	titulo	188292.75999999998	2019-09-19	swift	1
324	0134	01340000000000000001	1	2019-09-10 09:17:17.973165-04	2019-09-10	t	01340000000000000001	aba	iban	bic	1	1	2	20000	titulo	4026827.34000000125	2019-01-31	swift	1
336	0168	01680000000000000011	1	2019-09-18 12:49:36.500228-04	2019-09-18	t	01680000000000000011	aba	iban	bic	1	3	8	1999999.98999999999	titulo	1864040.3899999999	2019-09-19	swift	1
338	0134	01341111111111111111	2	2019-09-23 18:31:38.777968-04	2019-09-23	t	01341111111111111111	aba	iban	bic	1	1	2	1	titulo	164222.090000000317	2019-09-23	swift	5
331	0116	01160002000314535588	1	2019-09-10 15:27:24.590278-04	2019-09-10	t	01160002000314535588	aba	iban	bic	1	1	4	1636.42000000000007	titulo	638.159999999998035	2019-08-30	swift	6
341	0114	01140000000000012222	1	2019-09-23 19:15:30.028626-04	2019-09-23	t	01140000000000012222	aba	iban	bic	1	1	6	2500000	titulo	2500000	2019-09-23	swift	8
332	0134	01340866140001163463	1	2019-09-11 09:09:36.776868-04	2019-09-11	t	01340866140001163463	aba	iban	bic	1	1	2	1245000.09000000008	titulo	1166400.17999999993	2019-09-24	swift	6
342	0134	01340000000000000003	1	2019-09-26 15:36:20.298081-04	2019-09-26	t	01340000000000000003	aba	iban	bic	1	1	2	25000	titulo	224728.649999999994	2019-09-26	swift	8
\.


--
-- Data for Name: movimientos; Type: TABLE DATA; Schema: bancos; Owner: geekhack
--

COPY bancos.movimientos (id, codigo, referencia, fecha_creacion, fecha, monto, divisa, tipo, operacion, descripcion, cuenta, usuario, aux, referencia_2) FROM stdin;
84111	390073	390073	2019-09-19 15:12:55.464669-04	2019-01-02	-1102	1	2	operacion	charcuteria el horreo  caracas       ven	336	1	0	390073
84112	331066	331066	2019-09-19 15:12:55.464669-04	2019-01-02	-4250	1	2	operacion	frigorifico alto tepuy ccs noroeste  ven	336	1	0	331066
84113	395707	395707	2019-09-19 15:12:55.464669-04	2019-01-02	-1425	1	2	operacion	verd y frut ana y alg  ccs noroeste  ven	336	1	0	395707
84114	121245	121245	2019-09-19 15:12:55.464669-04	2019-01-02	-680	1	2	operacion	farmacia riofaro       dtto capital  ven	336	1	0	121245
84115	519094	519094	2019-09-19 15:12:55.464669-04	2019-01-02	-2600	1	2	operacion	cmcial las tres gonzal ccs noroeste  ven	336	1	0	519094
84116	754447	754447	2019-09-19 15:12:55.464669-04	2019-01-02	-2800	1	2	operacion	carlos tortoza         dtto capital  ven	336	1	0	754447
84117	355072	355072	2019-09-19 15:12:55.464669-04	2019-01-02	-1300	1	2	operacion	lacteos da silva 2004  distrito capi ven	336	1	0	355072
84118	63675	63675	2019-09-19 15:12:55.464669-04	2019-01-02	-650	1	2	operacion	sumac tica ca          ccs noroeste  ven	336	1	0	63675
84119	1225	1225	2019-09-19 15:12:55.464669-04	2019-01-02	-800	1	2	operacion	yaritza chiquinquira e caracas       ven	336	1	0	1225
84120	110048	110048	2019-09-19 15:12:55.464669-04	2019-01-02	-980	1	2	operacion	bakery frespan ca      ccs noroeste  ven	336	1	0	110048
84121	965195	965195	2019-09-19 15:12:55.464669-04	2019-01-02	-2200	1	2	operacion	1000 pagos             caracas       ven	336	1	0	965195
84122	3473	3473	2019-09-19 15:12:55.464669-04	2019-01-02	-1400	1	2	operacion	perfumeria d y         distrito capi ven	336	1	0	3473
84123	1060	1060	2019-09-19 15:12:55.464669-04	2019-01-02	-5600	1	2	operacion	inversiones uni        distrito capi ven	336	1	0	1060
84124	318759	318759	2019-09-19 15:12:55.464669-04	2019-01-02	-19500	1	2	operacion	pago tortas	336	1	0	318759
84125	401951	401951	2019-09-19 15:12:55.464669-04	2019-01-02	-1500	1	2	operacion	xoco                   caracas       ven	336	1	0	401951
84126	8763135	8763135	2019-09-19 15:12:55.464669-04	2019-01-03	-10	1	2	operacion	pago diciembre pagos de tarjetas por ibanking.  ba	336	1	0	8763135
84127	8763195	8763195	2019-09-19 15:12:55.464669-04	2019-01-03	-1800	1	2	operacion	pago membresia santiago y gemima transf. interbanc	336	1	0	8763195
84128	319242	319242	2019-09-19 15:12:55.464669-04	2019-01-04	-8000	1	2	operacion	pago pinata madagaskar ale key	336	1	0	319242
84129	1081173	1081173	2019-09-19 15:12:55.464669-04	2019-01-04	-1000	1	2	operacion	retiro de cuenta - biometrico	336	1	0	1081173
84130	8776595	8776595	2019-09-19 15:12:55.464669-04	2019-01-04	-0.179999999999999993	1	2	operacion	comision cce cliente - cliente	336	1	0	8776595
84131	778233	778233	2019-09-19 15:12:55.464669-04	2019-01-07	-495	1	2	operacion	farmacia riofaro       dtto capital  ven	336	1	0	778233
84132	649055	649055	2019-09-19 15:12:55.464669-04	2019-01-07	-9400.01000000000022	1	2	operacion	prep alimen inter paic ccs noroeste  ven	336	1	0	649055
84133	8791257	8791257	2019-09-19 15:12:55.464669-04	2019-01-07	9630	1	1	operacion	transferencia de otro banco por uap. #refuap: 1070	336	1	0	8791257
84134	319624	319624	2019-09-19 15:12:55.464669-04	2019-01-07	-4000	1	2	operacion	pago azucar	336	1	0	319624
84135	366987	366987	2019-09-19 15:12:55.464669-04	2019-01-07	-1073.06999999999994	1	2	operacion	excelsior gama superm  miranda       ven	336	1	0	366987
84136	1086403	1086403	2019-09-19 15:12:55.464669-04	2019-01-07	-1000	1	2	operacion	retiro de cuenta - biometrico	336	1	0	1086403
84137	8799727	8799727	2019-09-19 15:12:55.464669-04	2019-01-08	4000	1	1	operacion	transferencia de otro banco por uap. #refuap: 1070	336	1	0	8799727
84138	319924	319924	2019-09-19 15:12:55.464669-04	2019-01-08	-2000	1	2	operacion	yenny	336	1	0	319924
84139	8808267	8808267	2019-09-19 15:12:55.464669-04	2019-01-08	2500	1	1	operacion	transfer	336	1	0	8808267
84140	8809615	8809615	2019-09-19 15:12:55.464669-04	2019-01-09	-500	1	2	operacion	diezmo y ofrenda transf. interbancaria por ibankin	336	1	0	8809615
84141	1097389	1097389	2019-09-19 15:12:55.464669-04	2019-01-09	-2000	1	2	operacion	retiro de cuenta - biometrico	336	1	0	1097389
84142	8825373	8825373	2019-09-19 15:12:55.464669-04	2019-01-10	-0.0500000000000000028	1	2	operacion	comision cce cliente - cliente	336	1	0	8825373
84143	8830017	8830017	2019-09-19 15:12:55.464669-04	2019-01-11	1500	1	1	operacion	transferencia de otro banco por uap. #refuap: 1072	336	1	0	8830017
84144	13	13	2019-09-19 15:12:55.464669-04	2019-01-14	-11	1	2	operacion	bancrecer sa banco mic ccs noroeste  ven	336	1	0	13
84145	8877099	8877099	2019-09-19 15:12:55.464669-04	2019-01-16	2000	1	1	operacion	g	336	1	0	8877099
84146	1123935	1123935	2019-09-19 15:12:55.464669-04	2019-01-16	-2000	1	2	operacion	retiro de cuenta - biometrico	336	1	0	1123935
84147	322376	322376	2019-09-19 15:12:55.464669-04	2019-01-16	-1100	1	2	operacion	pago	336	1	0	322376
84148	497566	497566	2019-09-19 15:12:55.464669-04	2019-01-17	-1500	1	2	operacion	1000 pagos             caracas       ven	336	1	0	497566
84149	8921173	8921173	2019-09-19 15:12:55.464669-04	2019-01-22	4000	1	1	operacion	transferencia de otro banco por uap. #refuap: 1076	336	1	0	8921173
84150	8923177	8923177	2019-09-19 15:12:55.464669-04	2019-01-22	8000	1	1	operacion	transferencia de otro banco por uap. #refuap: 1077	336	1	0	8923177
84151	324007	324007	2019-09-19 15:12:55.464669-04	2019-01-22	-10000	1	2	operacion	pago compra mantequilla y mayonesa	336	1	0	324007
84152	805426	805426	2019-09-19 15:12:55.464669-04	2019-01-22	-5019.98999999999978	1	2	operacion	farmatodo lider        miranda       ven	336	1	0	805426
84153	1148171	1148171	2019-09-19 15:12:55.464669-04	2019-01-22	-2000	1	2	operacion	retiro de cuenta - biometrico	336	1	0	1148171
84154	9002483	9002483	2019-09-19 15:12:55.464669-04	2019-01-31	86.5	1	1	operacion	pago de interes	336	1	0	9002483
84286	000084706765972	000084706765972	2019-09-19 15:14:06.623294-04	2019-01-15	5000	1	1		pago movil interbancario	325	1	0	000084706765972
84287	000025527730649	000025527730649	2019-09-19 15:14:06.623294-04	2019-01-15	-4500	1	2		pago a terceros via internet	325	1	0	000025527730649
84288	000026902462498	000026902462498	2019-09-19 15:14:06.623294-04	2019-01-15	-1303.17000000000007	1	2		pago luz electrica via internet	325	1	0	000026902462498
84289	000062000030333	000062000030333	2019-09-19 15:14:06.623294-04	2019-01-15	-2000	1	2		transferencia de fondos via internet	325	1	0	000062000030333
84290	000052500497289	000052500497289	2019-09-19 15:14:06.623294-04	2019-01-16	-0.100000000000000006	1	2		comision por recepcion servicios especiales	325	1	0	000052500497289
84291	000052300497289	000052300497289	2019-09-19 15:14:06.623294-04	2019-01-16	-1000	1	2		orden de pago segun nota	325	1	0	000052300497289
84292	000023900491979	000023900491979	2019-09-19 15:14:06.623294-04	2019-01-16	-100	1	2		recargo comision bcv res 10	325	1	0	000023900491979
84293	000052500491979	000052500491979	2019-09-19 15:14:06.623294-04	2019-01-16	-2.10000000000000009	1	2		comision por recepcion servicios especiales	325	1	0	000052500491979
84155	1700419018	1700419018	2019-09-19 15:13:19.553858-04	2019-08-30	-0.0100000000000000002	1	2	operacion	nd s/l comision cuota de mantenimiento mensual	335	1	0	1700419018
84156	1700419017	1700419017	2019-09-19 15:13:19.553858-04	2019-08-30	7769.51000000000022	1	1	operacion	n/c intereses/rendimientos ah	335	1	0	1700419017
84157	1689524365	1689524365	2019-09-19 15:13:19.553858-04	2019-08-30	-38	1	2	operacion	nd s/l comision retiro/consulta atm bancaribe	335	1	0	1689524365
84158	1689467047	1689467047	2019-09-19 15:13:19.553858-04	2019-08-30	-12000	1	2	operacion	retiro ahorros c/l	335	1	0	1689467047
84159	1689132097	1689132097	2019-09-19 15:13:19.553858-04	2019-08-30	-12600	1	2	operacion	nd s/l consumos pos nacional	335	1	0	1689132097
84160	11448648216	11448648216	2019-09-19 15:13:19.553858-04	2019-08-30	207710.459999999992	1	1	operacion	nc s/l transf. recib. comp. electronica	335	1	0	11448648216
84161	1680824670	1680824670	2019-09-19 15:13:19.553858-04	2019-08-28	-8500	1	2	operacion	nd s/l consumos pos nacional	335	1	0	1680824670
84162	456	456	2019-09-19 15:13:19.553858-04	2019-08-26	-23	1	2	operacion	nd s/l comision por operacion otros bancos	335	1	0	456
84163	456	456	2019-09-19 15:13:19.553858-04	2019-08-26	-23000	1	2	operacion	nd s/l transf. env. comp. electronica	335	1	0	456
84164	1665604482	1665604482	2019-09-19 15:13:19.553858-04	2019-08-26	-59100	1	2	operacion	nd s/l consumos pos nacional	335	1	0	1665604482
84165	1665430949	1665430949	2019-09-19 15:13:19.553858-04	2019-08-26	-42948	1	2	operacion	nd s/l consumos pos nacional	335	1	0	1665430949
84166	1663066066	1663066066	2019-09-19 15:13:19.553858-04	2019-08-23	-20000	1	2	operacion	retiro ahorros c/l	335	1	0	1663066066
84167	1662790388	1662790388	2019-09-19 15:13:19.553858-04	2019-08-23	-38	1	2	operacion	nd s/l comision retiro/consulta atm bancaribe	335	1	0	1662790388
84168	11432731978	11432731978	2019-09-19 15:13:19.553858-04	2019-08-23	174319.660000000003	1	1	operacion	nc s/l transf. recib. comp. electronica	335	1	0	11432731978
84169	1659021406	1659021406	2019-09-19 15:13:19.553858-04	2019-08-22	-50000	1	2	operacion	nd s/l consumos pos nacional	335	1	0	1659021406
84170	1658767365	1658767365	2019-09-19 15:13:19.553858-04	2019-08-22	-12000	1	2	operacion	retiro ahorros c/l	335	1	0	1658767365
84171	1648286912	1648286912	2019-09-19 15:13:19.553858-04	2019-08-20	-10000	1	2	operacion	nd s/l consumos pos nacional	335	1	0	1648286912
84172	11418076569	11418076569	2019-09-19 15:13:19.553858-04	2019-08-20	147880.309999999998	1	1	operacion	nc s/l transf. recib. comp. electronica	335	1	0	11418076569
84173	1645433224	1645433224	2019-09-19 15:13:19.553858-04	2019-08-20	-32500	1	2	operacion	nd s/l consumos pos nacional	335	1	0	1645433224
84174	1639110037	1639110037	2019-09-19 15:13:19.553858-04	2019-08-16	-52719	1	2	operacion	nd s/l consumos pos nacional	335	1	0	1639110037
84175	1638157606	1638157606	2019-09-19 15:13:19.553858-04	2019-08-16	-38	1	2	operacion	nd s/l comision retiro/consulta atm bancaribe	335	1	0	1638157606
84176	1637858704	1637858704	2019-09-19 15:13:19.553858-04	2019-08-16	-38	1	2	operacion	nd s/l comision retiro/consulta atm bancaribe	335	1	0	1637858704
84177	1629362912	1629362912	2019-09-19 15:13:19.553858-04	2019-08-14	-7000	1	2	operacion	nd s/l consumos pos nacional	335	1	0	1629362912
84178	1612629091	1612629091	2019-09-19 15:13:19.553858-04	2019-08-12	-6000	1	2	operacion	nd s/l consumos pos nacional	335	1	0	1612629091
84179	1612557152	1612557152	2019-09-19 15:13:19.553858-04	2019-08-12	-4600	1	2	operacion	nd s/l consumos pos nacional	335	1	0	1612557152
84180	1612517969	1612517969	2019-09-19 15:13:19.553858-04	2019-08-12	-24330	1	2	operacion	nd s/l consumos pos nacional	335	1	0	1612517969
84181	1612488046	1612488046	2019-09-19 15:13:19.553858-04	2019-08-12	-14000	1	2	operacion	nd s/l consumos pos nacional	335	1	0	1612488046
84182	1611441316	1611441316	2019-09-19 15:13:19.553858-04	2019-08-09	-82002	1	2	operacion	nd s/l consumos pos nacional	335	1	0	1611441316
84183	1610378835	1610378835	2019-09-19 15:13:19.553858-04	2019-08-09	-12000	1	2	operacion	retiro ahorros c/l	335	1	0	1610378835
84184	1609810950	1609810950	2019-09-19 15:13:19.553858-04	2019-08-09	-12000	1	2	operacion	nd s/l consumos pos nacional	335	1	0	1609810950
84185	11400663175	11400663175	2019-09-19 15:13:19.553858-04	2019-08-09	190427.660000000003	1	1	operacion	nc s/l transf. recib. comp. electronica	335	1	0	11400663175
84186	1602747098	1602747098	2019-09-19 15:13:19.553858-04	2019-08-08	-3200	1	2	operacion	nd s/l consumos pos nacional	335	1	0	1602747098
84187	1585868804	1585868804	2019-09-19 15:13:19.553858-04	2019-08-05	-19200	1	2	operacion	nd s/l consumos pos nacional	335	1	0	1585868804
84188	1585756556	1585756556	2019-09-19 15:13:19.553858-04	2019-08-05	-8000	1	2	operacion	nd s/l consumos pos nacional	335	1	0	1585756556
84189	1585610077	1585610077	2019-09-19 15:13:19.553858-04	2019-08-05	-91017	1	2	operacion	nd s/l consumos pos nacional	335	1	0	1585610077
84190	1582866372	1582866372	2019-09-19 15:13:19.553858-04	2019-08-02	-6000	1	2	operacion	retiro ahorros c/l	335	1	0	1582866372
84191	te0271899218	te0271899218	2019-09-19 15:13:19.553858-04	2019-08-02	150003.059999999998	1	1	operacion	nc s/l transf. recib. comp. electronica	335	1	0	te0271899218
84294	000052300491979	000052300491979	2019-09-19 15:14:06.623294-04	2019-01-16	-21078.4399999999987	1	2		orden de pago segun nota	325	1	0	000052300491979
84295	000023900491977	000023900491977	2019-09-19 15:14:06.623294-04	2019-01-16	-100	1	2		recargo comision bcv res 10	325	1	0	000023900491977
84296	000052500491977	000052500491977	2019-09-19 15:14:06.623294-04	2019-01-16	-3.08999999999999986	1	2		comision por recepcion servicios especiales	325	1	0	000052500491977
84297	000052300491977	000052300491977	2019-09-19 15:14:06.623294-04	2019-01-16	-30960.5699999999997	1	2		orden de pago segun nota	325	1	0	000052300491977
84298	000084405921567	000084405921567	2019-09-19 15:14:06.623294-04	2019-01-16	-45	1	2		comision pago movil interbancario	325	1	0	000084405921567
84299	000084705921567	000084705921567	2019-09-19 15:14:06.623294-04	2019-01-16	-15000	1	2		pago movil interbancario	325	1	0	000084705921567
84300	000023900488948	000023900488948	2019-09-19 15:14:06.623294-04	2019-01-16	-100	1	2		recargo comision bcv res 10	325	1	0	000023900488948
84301	000052500488948	000052500488948	2019-09-19 15:14:06.623294-04	2019-01-16	-7	1	2		comision por recepcion servicios especiales	325	1	0	000052500488948
84302	000052300488948	000052300488948	2019-09-19 15:14:06.623294-04	2019-01-16	-70000	1	2		orden de pago segun nota	325	1	0	000052300488948
84303	000025572361444	000025572361444	2019-09-19 15:14:06.623294-04	2019-01-16	-98000	1	2		pago a terceros via internet	325	1	0	000025572361444
84304	000025572359437	000025572359437	2019-09-19 15:14:06.623294-04	2019-01-16	-98000	1	2		pago a terceros via internet	325	1	0	000025572359437
84305	000047900042282	000047900042282	2019-09-19 15:14:06.623294-04	2019-01-16	600000	1	1		pago a proveedores en linea	325	1	0	000047900042282
84306	000052537177489	000052537177489	2019-09-19 15:14:06.623294-04	2019-01-16	-12.0800000000000001	1	2		comision por recepcion servicios especiales	325	1	0	000052537177489
84192	92377770005	92377770005	2019-09-19 15:13:40.977952-04	2019-07-19	-4158.39999999999964	1	2		impuestos a las transacciones financiera	325	1	0	92377770005
84193	85901762774	85901762774	2019-09-19 15:13:40.977952-04	2019-07-19	-207920	1	2		pago de servicios via internet	325	1	0	85901762774
84195	85901762773	85901762773	2019-09-19 15:13:40.977952-04	2019-07-19	-207920	1	2		pago de servicios via internet	325	1	0	85901762773
84196	92377770005	92377770005	2019-09-19 15:13:40.977952-04	2019-07-19	-16591.3199999999997	1	2		impuestos a las transacciones financiera	325	1	0	92377770005
84197	47900024800	47900024800	2019-09-19 15:13:40.977952-04	2019-07-19	-829566	1	2		pago a proveedores en linea	325	1	0	47900024800
84198	25515983364	25515983364	2019-09-19 15:13:40.977952-04	2019-07-19	2000000	1	1		pago a terceros via internet	325	1	0	25515983364
84199	92377770005	92377770005	2019-09-19 15:13:40.977952-04	2019-07-11	-2099	1	2		impuestos a las transacciones financiera	325	1	0	92377770005
84200	47900087936	47900087936	2019-09-19 15:13:40.977952-04	2019-07-11	-104950	1	2		pago a proveedores en linea	325	1	0	47900087936
84201	12100043815	12100043815	2019-09-19 15:13:40.977952-04	2019-07-09	400000	1	1		orden de pago	325	1	0	12100043815
84202	92377770005	92377770005	2019-09-19 15:13:40.977952-04	2019-07-02	-96	1	2		impuestos a las transacciones financiera	325	1	0	92377770005
84203	81234512009	81234512009	2019-09-19 15:13:40.977952-04	2019-07-02	-4800	1	2		pagos a banavih aportes ahorro habitacio	325	1	0	81234512009
84307	000034437177489	000034437177489	2019-09-19 15:14:06.623294-04	2019-01-16	-509	1	2		pago tarjetas de credito otros bancos	325	1	0	000034437177489
84308	000000000000000	000000000000000	2019-09-19 15:14:06.623294-04	2019-01-16	0.0700000000000000067	1	1		abono de intereses	325	1	0	000000000000000
84309	000098200760375	000098200760375	2019-09-19 15:14:06.623294-04	2019-01-16	-1890	1	2		consumo tarjeta llave mercantil maestro nac.	325	1	0	000098200760375
84310	000098200432333	000098200432333	2019-09-19 15:14:06.623294-04	2019-01-16	-23800	1	2		consumo tarjeta llave mercantil maestro nac.	325	1	0	000098200432333
84311	000098200024991	000098200024991	2019-09-19 15:14:06.623294-04	2019-01-17	-80000	1	2		consumo tarjeta llave mercantil maestro nac.	325	1	0	000098200024991
84312	000098200099525	000098200099525	2019-09-19 15:14:06.623294-04	2019-01-17	-1515	1	2		consumo tarjeta llave mercantil maestro nac.	325	1	0	000098200099525
84313	000084405985428	000084405985428	2019-09-19 15:14:06.623294-04	2019-01-17	-45	1	2		comision pago movil interbancario	325	1	0	000084405985428
84314	000084705985428	000084705985428	2019-09-19 15:14:06.623294-04	2019-01-17	-15000	1	2		pago movil interbancario	325	1	0	000084705985428
84315	000000000000000	000000000000000	2019-09-19 15:14:06.623294-04	2019-01-17	0.0299999999999999989	1	1		abono de intereses	325	1	0	000000000000000
84316	000098200634905	000098200634905	2019-09-19 15:14:06.623294-04	2019-01-17	-978	1	2		consumo tarjeta llave mercantil maestro nac.	325	1	0	000098200634905
84317	000098200618256	000098200618256	2019-09-19 15:14:06.623294-04	2019-01-17	-17245	1	2		consumo tarjeta llave mercantil maestro nac.	325	1	0	000098200618256
84318	000098200390911	000098200390911	2019-09-19 15:14:06.623294-04	2019-01-18	-978	1	2		consumo tarjeta llave mercantil maestro nac.	325	1	0	000098200390911
84319	000084405116488	000084405116488	2019-09-19 15:14:06.623294-04	2019-01-18	-45	1	2		comision pago movil interbancario	325	1	0	000084405116488
84320	000084705116488	000084705116488	2019-09-19 15:14:06.623294-04	2019-01-18	-15000	1	2		pago movil interbancario	325	1	0	000084705116488
84321	000098200016131	000098200016131	2019-09-19 15:14:06.623294-04	2019-01-18	-3275	1	2		consumo tarjeta llave mercantil maestro nac.	325	1	0	000098200016131
84322	000000000000000	000000000000000	2019-09-19 15:14:06.623294-04	2019-01-18	0.0299999999999999989	1	1		abono de intereses	325	1	0	000000000000000
84323	000098200676766	000098200676766	2019-09-19 15:14:06.623294-04	2019-01-18	-978	1	2		consumo tarjeta llave mercantil maestro nac.	325	1	0	000098200676766
84324	000098200313473	000098200313473	2019-09-19 15:14:06.623294-04	2019-01-18	-2450	1	2		consumo tarjeta llave mercantil maestro nac.	325	1	0	000098200313473
84325	000084405319580	000084405319580	2019-09-19 15:14:06.623294-04	2019-01-21	-18	1	2		comision pago movil interbancario	325	1	0	000084405319580
84326	000084705319580	000084705319580	2019-09-19 15:14:06.623294-04	2019-01-21	-6000	1	2		pago movil interbancario	325	1	0	000084705319580
84327	000098200097701	000098200097701	2019-09-19 15:14:06.623294-04	2019-01-21	-1100	1	2		consumo tarjeta llave mercantil maestro nac.	325	1	0	000098200097701
84328	000000000000000	000000000000000	2019-09-19 15:14:06.623294-04	2019-01-21	0.0299999999999999989	1	1		abono de intereses	325	1	0	000000000000000
84329	000075001475584	000075001475584	2019-09-19 15:14:06.623294-04	2019-01-21	-6600	1	2		consumo tarjeta de pago abra 24	325	1	0	000075001475584
84330	000098200000643	000098200000643	2019-09-19 15:14:06.623294-04	2019-01-21	-9950	1	2		consumo tarjeta llave mercantil maestro nac.	325	1	0	000098200000643
84331	000000000000000	000000000000000	2019-09-19 15:14:06.623294-04	2019-01-21	0.0100000000000000002	1	1		abono de intereses	325	1	0	000000000000000
84332	000098200033811	000098200033811	2019-09-19 15:14:06.623294-04	2019-01-21	-1800	1	2		consumo tarjeta llave mercantil maestro nac.	325	1	0	000098200033811
84333	000098200020903	000098200020903	2019-09-19 15:14:06.623294-04	2019-01-21	-3000	1	2		consumo tarjeta llave mercantil maestro nac.	325	1	0	000098200020903
84334	000098200002139	000098200002139	2019-09-19 15:14:06.623294-04	2019-01-21	-1900	1	2		consumo tarjeta llave mercantil maestro nac.	325	1	0	000098200002139
84335	000098200364705	000098200364705	2019-09-19 15:14:06.623294-04	2019-01-21	-34049	1	2		consumo tarjeta llave mercantil maestro nac.	325	1	0	000098200364705
84336	000075002458359	000075002458359	2019-09-19 15:14:06.623294-04	2019-01-21	-3550	1	2		consumo tarjeta de pago abra 24	325	1	0	000075002458359
84337	000098200763075	000098200763075	2019-09-19 15:14:06.623294-04	2019-01-21	-2429.61000000000013	1	2		consumo tarjeta llave mercantil maestro nac.	325	1	0	000098200763075
84338	000098200584507	000098200584507	2019-09-19 15:14:06.623294-04	2019-01-21	-3980	1	2		consumo tarjeta llave mercantil maestro nac.	325	1	0	000098200584507
84339	000084405321668	000084405321668	2019-09-19 15:14:06.623294-04	2019-01-21	-27	1	2		comision pago movil interbancario	325	1	0	000084405321668
84340	000084705321668	000084705321668	2019-09-19 15:14:06.623294-04	2019-01-21	-9000	1	2		pago movil interbancario	325	1	0	000084705321668
84341	000098200621417	000098200621417	2019-09-19 15:14:06.623294-04	2019-01-22	-1900	1	2		consumo tarjeta llave mercantil maestro nac.	325	1	0	000098200621417
84342	000098200332362	000098200332362	2019-09-19 15:14:06.623294-04	2019-01-22	-1646	1	2		consumo tarjeta llave mercantil maestro nac.	325	1	0	000098200332362
84343	000098200521548	000098200521548	2019-09-19 15:14:06.623294-04	2019-01-22	-2215.51999999999998	1	2		consumo tarjeta llave mercantil maestro nac.	325	1	0	000098200521548
84344	000047900096455	000047900096455	2019-09-19 15:14:06.623294-04	2019-01-24	250000	1	1		pago a proveedores en linea	325	1	0	000047900096455
84204	000000000000000	000000000000000	2019-09-19 15:14:06.623294-04	2019-01-02	0.0100000000000000002	1	1		abono de intereses	325	1	0	000000000000000
84205	000075002178541	000075002178541	2019-09-19 15:14:06.623294-04	2019-01-02	-4500	1	2		consumo tarjeta de pago abra 24	325	1	0	000075002178541
84206	000073700518026	000073700518026	2019-09-19 15:14:06.623294-04	2019-01-02	-626.059999999999945	1	2		pago master card via internet	325	1	0	000073700518026
84207	000018700359339	000018700359339	2019-09-19 15:14:06.623294-04	2019-01-02	-900	1	2		pago visa via internet	325	1	0	000018700359339
84208	000098200873077	000098200873077	2019-09-19 15:14:06.623294-04	2019-01-02	-2390	1	2		consumo tarjeta llave mercantil maestro nac.	325	1	0	000098200873077
84209	000025549770625	000025549770625	2019-09-19 15:14:06.623294-04	2019-01-02	-1425.71000000000004	1	2		pago a terceros via internet	325	1	0	000025549770625
84210	000025546702066	000025546702066	2019-09-19 15:14:06.623294-04	2019-01-02	-1390.27999999999997	1	2		pago a terceros via internet	325	1	0	000025546702066
84211	000098200149240	000098200149240	2019-09-19 15:14:06.623294-04	2019-01-02	-259	1	2		consumo tarjeta llave mercantil maestro nac.	325	1	0	000098200149240
84212	000098200601647	000098200601647	2019-09-19 15:14:06.623294-04	2019-01-02	-2200	1	2		consumo tarjeta llave mercantil maestro nac.	325	1	0	000098200601647
84213	000025574276442	000025574276442	2019-09-19 15:14:06.623294-04	2019-01-02	-2997.67999999999984	1	2		pago a terceros via internet	325	1	0	000025574276442
84214	000023900441230	000023900441230	2019-09-19 15:14:06.623294-04	2019-01-02	-100	1	2		recargo comision bcv res 10	325	1	0	000023900441230
84215	000052500441230	000052500441230	2019-09-19 15:14:06.623294-04	2019-01-02	-1.14999999999999991	1	2		comision por recepcion servicios especiales	325	1	0	000052500441230
84216	000052300441230	000052300441230	2019-09-19 15:14:06.623294-04	2019-01-02	-11500	1	2		orden de pago segun nota	325	1	0	000052300441230
84217	000084405594977	000084405594977	2019-09-19 15:14:06.623294-04	2019-01-02	-6	1	2		comision pago movil interbancario	325	1	0	000084405594977
84218	000084705594977	000084705594977	2019-09-19 15:14:06.623294-04	2019-01-02	-2000	1	2		pago movil interbancario	325	1	0	000084705594977
84220	000084405570987	000084405570987	2019-09-19 15:14:06.623294-04	2019-01-02	-6	1	2		comision pago movil interbancario	325	1	0	000084405570987
84221	000084705570987	000084705570987	2019-09-19 15:14:06.623294-04	2019-01-02	-2000	1	2		pago movil interbancario	325	1	0	000084705570987
84222	000098200848561	000098200848561	2019-09-19 15:14:06.623294-04	2019-01-02	-200	1	2		consumo tarjeta llave mercantil maestro nac.	325	1	0	000098200848561
84223	000098200847391	000098200847391	2019-09-19 15:14:06.623294-04	2019-01-02	-1350	1	2		consumo tarjeta llave mercantil maestro nac.	325	1	0	000098200847391
84224	000098200894339	000098200894339	2019-09-19 15:14:06.623294-04	2019-01-02	-2975	1	2		consumo tarjeta llave mercantil maestro nac.	325	1	0	000098200894339
84225	000098200620595	000098200620595	2019-09-19 15:14:06.623294-04	2019-01-02	-46398	1	2		consumo tarjeta llave mercantil maestro nac.	325	1	0	000098200620595
84226	000098200120273	000098200120273	2019-09-19 15:14:06.623294-04	2019-01-02	-2327.88000000000011	1	2		consumo tarjeta llave mercantil maestro nac.	325	1	0	000098200120273
84227	000098200685057	000098200685057	2019-09-19 15:14:06.623294-04	2019-01-02	-850	1	2		consumo tarjeta llave mercantil maestro nac.	325	1	0	000098200685057
84228	000075001165201	000075001165201	2019-09-19 15:14:06.623294-04	2019-01-02	-11160	1	2		consumo tarjeta de pago abra 24	325	1	0	000075001165201
84229	000075001092787	000075001092787	2019-09-19 15:14:06.623294-04	2019-01-02	-18699	1	2		consumo tarjeta de pago abra 24	325	1	0	000075001092787
84230	000098200859256	000098200859256	2019-09-19 15:14:06.623294-04	2019-01-02	-13370	1	2		consumo tarjeta llave mercantil maestro nac.	325	1	0	000098200859256
84231	000098200002200	000098200002200	2019-09-19 15:14:06.623294-04	2019-01-02	-3551.84999999999991	1	2		consumo tarjeta llave mercantil maestro nac.	325	1	0	000098200002200
84232	000084405496441	000084405496441	2019-09-19 15:14:06.623294-04	2019-01-02	-6	1	2		comision pago movil interbancario	325	1	0	000084405496441
84233	000084705496441	000084705496441	2019-09-19 15:14:06.623294-04	2019-01-02	-2000	1	2		pago movil interbancario	325	1	0	000084705496441
84234	000000000000000	000000000000000	2019-09-19 15:14:06.623294-04	2019-01-02	0.0899999999999999967	1	1		abono de intereses	325	1	0	000000000000000
84235	000084405433991	000084405433991	2019-09-19 15:14:06.623294-04	2019-01-02	-6	1	2		comision pago movil interbancario	325	1	0	000084405433991
84236	000084705433991	000084705433991	2019-09-19 15:14:06.623294-04	2019-01-02	-2000	1	2		pago movil interbancario	325	1	0	000084705433991
84237	000098200332818	000098200332818	2019-09-19 15:14:06.623294-04	2019-01-02	-259	1	2		consumo tarjeta llave mercantil maestro nac.	325	1	0	000098200332818
84238	000098200657891	000098200657891	2019-09-19 15:14:06.623294-04	2019-01-02	-966.299999999999955	1	2		consumo tarjeta llave mercantil maestro nac.	325	1	0	000098200657891
84239	000098200830267	000098200830267	2019-09-19 15:14:06.623294-04	2019-01-02	-1462	1	2		consumo tarjeta llave mercantil maestro nac.	325	1	0	000098200830267
84240	000025596883766	000025596883766	2019-09-19 15:14:06.623294-04	2019-01-02	-4800	1	2		pago a terceros via internet	325	1	0	000025596883766
84241	000098200086242	000098200086242	2019-09-19 15:14:06.623294-04	2019-01-02	-1201	1	2		consumo tarjeta llave mercantil maestro nac.	325	1	0	000098200086242
84242	000098200901176	000098200901176	2019-09-19 15:14:06.623294-04	2019-01-02	-259	1	2		consumo tarjeta llave mercantil maestro nac.	325	1	0	000098200901176
84243	000098200984636	000098200984636	2019-09-19 15:14:06.623294-04	2019-01-02	-3500	1	2		consumo tarjeta llave mercantil maestro nac.	325	1	0	000098200984636
84244	000084405328536	000084405328536	2019-09-19 15:14:06.623294-04	2019-01-02	-6	1	2		comision pago movil interbancario	325	1	0	000084405328536
84245	000084705328536	000084705328536	2019-09-19 15:14:06.623294-04	2019-01-02	-2000	1	2		pago movil interbancario	325	1	0	000084705328536
84246	000098200678115	000098200678115	2019-09-19 15:14:06.623294-04	2019-01-02	-8876.89999999999964	1	2		consumo tarjeta llave mercantil maestro nac.	325	1	0	000098200678115
84247	000098200545369	000098200545369	2019-09-19 15:14:06.623294-04	2019-01-03	-960	1	2		consumo tarjeta llave mercantil maestro nac.	325	1	0	000098200545369
84248	000098200301451	000098200301451	2019-09-19 15:14:06.623294-04	2019-01-03	-259	1	2		consumo tarjeta llave mercantil maestro nac.	325	1	0	000098200301451
84249	000084405649402	000084405649402	2019-09-19 15:14:06.623294-04	2019-01-03	-6	1	2		comision pago movil interbancario	325	1	0	000084405649402
84250	000084705649402	000084705649402	2019-09-19 15:14:06.623294-04	2019-01-03	-2000	1	2		pago movil interbancario	325	1	0	000084705649402
84251	000075001957984	000075001957984	2019-09-19 15:14:06.623294-04	2019-01-03	-612.149999999999977	1	2		consumo tarjeta de pago abra 24	325	1	0	000075001957984
84252	000098200598857	000098200598857	2019-09-19 15:14:06.623294-04	2019-01-03	-400	1	2		consumo tarjeta llave mercantil maestro nac.	325	1	0	000098200598857
84253	000098200251242	000098200251242	2019-09-19 15:14:06.623294-04	2019-01-04	-3510	1	2		consumo tarjeta llave mercantil maestro nac.	325	1	0	000098200251242
84254	000084706943527	000084706943527	2019-09-19 15:14:06.623294-04	2019-01-07	12000	1	1		pago movil interbancario	325	1	0	000084706943527
84255	000084706942576	000084706942576	2019-09-19 15:14:06.623294-04	2019-01-07	4800	1	1		pago movil interbancario	325	1	0	000084706942576
84256	000000000000000	000000000000000	2019-09-19 15:14:06.623294-04	2019-01-07	0.0200000000000000004	1	1		abono de intereses	325	1	0	000000000000000
84257	000062000074590	000062000074590	2019-09-19 15:14:06.623294-04	2019-01-07	-2000	1	2		transferencia de fondos via internet	325	1	0	000062000074590
84258	000084706804526	000084706804526	2019-09-19 15:14:06.623294-04	2019-01-07	15000	1	1		pago movil interbancario	325	1	0	000084706804526
84259	000025595008088	000025595008088	2019-09-19 15:14:06.623294-04	2019-01-07	-19000	1	2		pago a terceros via internet	325	1	0	000025595008088
84260	000084706962833	000084706962833	2019-09-19 15:14:06.623294-04	2019-01-07	20000	1	1		pago movil interbancario	325	1	0	000084706962833
84261	000098200010073	000098200010073	2019-09-19 15:14:06.623294-04	2019-01-07	-1500	1	2		consumo tarjeta llave mercantil maestro nac.	325	1	0	000098200010073
84262	000098200651844	000098200651844	2019-09-19 15:14:06.623294-04	2019-01-07	-487	1	2		consumo tarjeta llave mercantil maestro nac.	325	1	0	000098200651844
84263	000023900974328	000023900974328	2019-09-19 15:14:06.623294-04	2019-01-07	-100	1	2		recargo comision bcv res 10	325	1	0	000023900974328
84264	000052500974328	000052500974328	2019-09-19 15:14:06.623294-04	2019-01-07	-1.5	1	2		comision por recepcion servicios especiales	325	1	0	000052500974328
84265	000052300974328	000052300974328	2019-09-19 15:14:06.623294-04	2019-01-07	-15000	1	2		orden de pago segun nota	325	1	0	000052300974328
84266	000084405944335	000084405944335	2019-09-19 15:14:06.623294-04	2019-01-07	-45	1	2		comision pago movil interbancario	325	1	0	000084405944335
84267	000084705944335	000084705944335	2019-09-19 15:14:06.623294-04	2019-01-07	-15000	1	2		pago movil interbancario	325	1	0	000084705944335
84268	000084706454174	000084706454174	2019-09-19 15:14:06.623294-04	2019-01-11	22000	1	1		pago movil interbancario	325	1	0	000084706454174
84269	000084405472720	000084405472720	2019-09-19 15:14:06.623294-04	2019-01-11	-0.900000000000000022	1	2		comision pago movil interbancario	325	1	0	000084405472720
84270	000084705472720	000084705472720	2019-09-19 15:14:06.623294-04	2019-01-11	-300	1	2		pago movil interbancario	325	1	0	000084705472720
80117	662897	662897	2019-09-10 16:27:38.830395-04	2019-07-01	395000	1	1	operacion	telf.:584242325069 banco:0134 pmpp pago geo	328	6	0	584242325069
80118	5886402	5886402	2019-09-10 16:27:38.830395-04	2019-07-02	-156000	1	2	operacion	telf.:584149255543 ced.:024217603 banco:0134 compra camisa ricardo misberg	328	6	0	584149255543
80119	5886402	5886402	2019-09-10 16:27:38.830395-04	2019-07-02	-468	1	2	operacion	telf.:584149255543 ced.:024217603 banco:0134 compra camisa ricardo misberg	328	6	0	584149255543
80120	220117238	220117238	2019-09-10 16:27:38.830395-04	2019-07-02	-200000	1	2	operacion	transferencia a favor de: moreno pitalua gemima para la cuenta nro. 01910001402101027089 pago mami	328	6	0	220117238
80121	4242678253	4242678253	2019-09-10 16:27:38.830395-04	2019-07-08	-10000	1	2	operacion	recarga / pago movistar : 04242678253 tel.m?vil o internet m?vil prepago	328	6	0	1041377411
80122	4242325069	4242325069	2019-09-10 16:27:38.830395-04	2019-07-08	-20000	1	2	operacion	recarga / pago movistar : 04242325069 tel.m?vil o internet m?vil prepago	328	6	0	1041413543
80123	704248	704248	2019-09-10 16:27:38.830395-04	2019-07-08	-20000	1	2	operacion	recarga digitel telf: 04129580700 recarga	328	6	0	704248
80124	6177116	6177116	2019-09-10 16:27:38.830395-04	2019-07-09	-50000	1	2	operacion	telf.:584145884464 ced.:016033710 banco:0108 compra mateo jemi moreno	328	6	0	584145884464
80125	6177116	6177116	2019-09-10 16:27:38.830395-04	2019-07-09	-150	1	2	operacion	telf.:584145884464 ced.:016033710 banco:0108 compra mateo jemi moreno	328	6	0	584145884464
80126	709353	709353	2019-09-10 16:27:38.830395-04	2019-07-09	-15000	1	2	operacion	recarga digitel telf: 04126140650 pago forj	328	6	0	709353
80127	70047880	70047880	2019-09-10 16:27:38.830395-04	2019-07-10	-40000	1	2	operacion	transferencia a favor de: moreno pitalua gemima para la cuenta nro. 01910001402101027089 compra comida	328	6	0	70047880
80128	193666	193666	2019-09-10 16:27:38.830395-04	2019-07-12	180000	1	1	operacion	telf.:584168373924 banco:0168 pmpp diezmo y otros	328	6	0	584168373924
80129	71606398	71606398	2019-09-10 16:27:38.830395-04	2019-07-13	-120000	1	2	operacion	transferencia a favor de: moreno pitalua gemima para la cuenta nro. 01910001402101027089 compra comida	328	6	0	71606398
80130	728921	728921	2019-09-10 16:27:38.830395-04	2019-07-13	-5000	1	2	operacion	recarga digitel telf: 04123340187 recargar forj	328	6	0	728921
80131	6499677	6499677	2019-09-10 16:27:38.830395-04	2019-07-16	-48000	1	2	operacion	telf.:584242595969 ced.:013125260 banco:0134 pado depila nora prieto	328	6	0	584242595969
80132	6499677	6499677	2019-09-10 16:27:38.830395-04	2019-07-16	-144	1	2	operacion	telf.:584242595969 ced.:013125260 banco:0134 pado depila nora prieto	328	6	0	584242595969
80133	36223103301	36223103301	2019-09-10 16:27:38.830395-04	2019-07-16	300000	1	1	operacion	transferencia recibida de :bancrecer s.a. banco micr por cuenta de : gemima moreno pitalua ref...........: 23103301 / 00000000000023103301	328	6	0	49075100910482
80134	417690	417690	2019-09-10 16:27:38.830395-04	2019-07-17	6000	1	1	operacion	telf.:584168373924 banco:0102 pmpp pago movil bdv	328	6	0	584168373924
80135	6785914	6785914	2019-09-10 16:27:38.830395-04	2019-07-22	-48000	1	2	operacion	telf.:584160103739 ced.:081851886 banco:0134 pago 6 cartucheras gerhard niko	328	6	0	584160103739
80136	6785914	6785914	2019-09-10 16:27:38.830395-04	2019-07-22	-144	1	2	operacion	telf.:584160103739 ced.:081851886 banco:0134 pago 6 cartucheras gerhard niko	328	6	0	584160103739
80137	104346339	104346339	2019-09-10 16:27:38.830395-04	2019-07-23	-70000	1	2	operacion	transferencia a favor de: georgina de moreno para la cuenta nro. 01750381290076660392 compra de material renzo	328	6	0	104346339
80138	104346339	104346339	2019-09-10 16:27:38.830395-04	2019-07-23	-70	1	2	operacion		328	6	0	104346339
80139	75513973	75513973	2019-09-10 16:27:38.830395-04	2019-07-27	-45000	1	2	operacion	transferencia a favor de: moreno pitalua gemima para la cuenta nro. 01910001491101037996 pago deuda	328	6	0	75513973
80140	7032645	7032645	2019-09-10 16:27:38.830395-04	2019-07-28	-38000	1	2	operacion	telf.:584242325069 ced.:014964040 banco:0134 pago torta santiago moreno	328	6	0	584242325069
80141	7032645	7032645	2019-09-10 16:27:38.830395-04	2019-07-28	-114	1	2	operacion	telf.:584242325069 ced.:014964040 banco:0134 pago torta santiago moreno	328	6	0	584242325069
80142	7051648	7051648	2019-09-10 16:27:38.830395-04	2019-07-29	-50000	1	2	operacion	telf.:584128162852 ced.:009994050 banco:0102 pago taxi fernando juan moreno	328	6	0	584128162852
80143	7051648	7051648	2019-09-10 16:27:38.830395-04	2019-07-29	-150	1	2	operacion	telf.:584128162852 ced.:009994050 banco:0102 pago taxi fernando juan moreno	328	6	0	584128162852
80144	100117448	100117448	2019-09-10 16:27:38.830395-04	2019-07-30	5000	1	1	operacion	transferencia recibida del bco. nacional de credito a nombre de: moreno pitalua gemima de la cuenta nro. 01910001402101027089	328	6	0	10210027089
80145	7108120	7108120	2019-09-10 16:27:38.830395-04	2019-07-30	-110000	1	2	operacion	telf.:584125409830 ced.:013952493 banco:0102 cartucho 22 a color ?ngel camejo	328	6	0	584125409830
80146	7108120	7108120	2019-09-10 16:27:38.830395-04	2019-07-30	-330	1	2	operacion	telf.:584125409830 ced.:013952493 banco:0102 cartucho 22 a color ?ngel camejo	328	6	0	584125409830
80147	122396	122396	2019-09-10 16:27:38.830395-04	2019-07-31	15000	1	1	operacion	telf.:584168373924 banco:0168 pmpp recargam	328	6	0	584168373924
80148	4242678253	4242678253	2019-09-10 16:27:38.830395-04	2019-07-31	-8000	1	2	operacion	recarga / pago movistar : 04242678253 tel.m?vil o internet m?vil prepago	328	6	0	1044093134
80149	0	0	2019-09-10 16:27:38.830395-04	2019-07-31	3777.23000000000002	1	1	operacion	ints. abonados mes de julio     - 2019 de su cuenta remunerada al  21.0000% anual	328	6	0	0
80298	0	0	2019-09-10 21:34:37.213511-04	2019-07-01	-296	1	2	operacion	comi. envio estado de cuenta	331	6	0	0
80299	0	0	2019-09-10 21:34:37.213511-04	2019-07-31	-833	1	2	operacion	comision de mantenimiento de c	331	6	0	0
80300	0	0	2019-09-10 21:34:37.213511-04	2019-07-29	-185.430000000000007	1	2	operacion	comision de mantenimiento de c	331	6	0	0
80301	0	0	2019-09-10 21:34:37.213511-04	2019-07-22	-51.9200000000000017	1	2	operacion	c.comi.env.edo.cta  c 22/03/19	331	6	0	0
80302	217970564	217970564	2019-09-10 21:34:37.213511-04	2019-07-20	-1500	1	2	operacion	pago tarj credito internet	331	6	0	217970564
80303	0	0	2019-09-10 21:34:37.213511-04	2019-07-01	-12.0800000000000001	1	2	operacion	comi. envio estado de cuenta	331	6	0	0
80304	0	0	2019-09-10 21:34:37.213511-04	2019-08-30	-833	1	2	operacion	comision de mantenimiento de c	331	6	0	0
80305	230102353	230102353	2019-09-10 21:34:37.213511-04	2019-08-25	-35	1	2	operacion	comision por transferencia	331	6	0	230102353
80306	230102353	230102353	2019-09-10 21:34:37.213511-04	2019-08-25	-35000	1	2	operacion	te0230102353transf.banesco ban	331	6	0	230102353
80307	229546621	229546621	2019-09-10 21:34:37.213511-04	2019-08-24	-11308.2600000000002	1	2	operacion	pago tarj credito internet	331	6	0	229546621
80308	0	0	2019-09-10 21:34:37.213511-04	2019-08-24	-296	1	2	operacion	comision envio estado de cta.	331	6	0	0
80309	0	0	2019-09-10 21:34:37.213511-04	2019-08-24	-647.57000000000005	1	2	operacion	comision de mantenimiento de c	331	6	0	0
80310	66767	66767	2019-09-10 21:34:37.213511-04	2019-08-24	50000	1	1	operacion	cr cce tran:banco mercantil	331	6	0	66767
80311	11449653692	11449653692	2019-09-11 10:10:31.160177-04	2019-09-02	-53.0600000000000023	1	2	operacion	comision trf otros bcos	332	6	0	11449653692
80312	02528601908	02528601908	2019-09-11 10:10:31.160177-04	2019-09-02	-16500	1	2	operacion	trf.mb 0134 v015160852 gonzalez rojas le 3463	332	6	0	02528601908
80313	24314278510	24314278510	2019-09-11 10:10:31.160177-04	2019-09-02	-30000	1	2	operacion	compra pos cta/cte	332	6	0	24314278510
80314	40001448555	40001448555	2019-09-11 10:10:31.160177-04	2019-09-02	-25900	1	2	operacion	compra pos cta/cte	332	6	0	40001448555
80315	40001452647	40001452647	2019-09-11 10:10:31.160177-04	2019-09-02	-34000	1	2	operacion	compra pos cta/cte	332	6	0	40001452647
80316	24533696155	24533696155	2019-09-11 10:10:31.160177-04	2019-09-02	-20000	1	2	operacion	retiro atm cta/cte	332	6	0	24533696155
80317	24533696155	24533696155	2019-09-11 10:10:31.160177-04	2019-09-02	-600	1	2	operacion	c.serv.cajero aut.	332	6	0	24533696155
80318	24550050084	24550050084	2019-09-11 10:10:31.160177-04	2019-09-02	-63500	1	2	operacion	compra pos cta/cte farmacia riofaro	332	6	0	24550050084
80319	02530695776	02530695776	2019-09-11 10:10:31.160177-04	2019-09-03	21000	1	1	operacion	trf.mb 0134 v012557310 baez gregoric lui 3463	332	6	0	02530695776
80320	02531122874	02531122874	2019-09-11 10:10:31.160177-04	2019-09-03	15000	1	1	operacion	trf.mb 0134 v015160852 gonzalez rojas le 3463	332	6	0	02531122874
80321	02530901537	02530901537	2019-09-11 10:10:31.160177-04	2019-09-03	-10000	1	2	operacion	trf.mb 0134 v015160852 gonzalez rojas le 3463	332	6	0	02530901537
80322	48755623710	48755623710	2019-09-11 10:10:31.160177-04	2019-09-03	-20000	1	2	operacion	banesco pago movil	332	6	0	48755623710
80323	48755623710	48755623710	2019-09-11 10:10:31.160177-04	2019-09-03	-60	1	2	operacion	banesco pago movil	332	6	0	48755623710
80324	24633696894	24633696894	2019-09-11 10:10:31.160177-04	2019-09-03	-20000	1	2	operacion	retiro atm cta/cte	332	6	0	24633696894
80325	24633696894	24633696894	2019-09-11 10:10:31.160177-04	2019-09-03	-600	1	2	operacion	c.serv.cajero aut.	332	6	0	24633696894
80326	40001298916	40001298916	2019-09-11 10:10:31.160177-04	2019-09-03	-36300	1	2	operacion	compra pos cta/cte	332	6	0	40001298916
80327	24733697626	24733697626	2019-09-11 10:10:31.160177-04	2019-09-04	-20000	1	2	operacion	retiro atm cta/cte	332	6	0	24733697626
80328	24733697626	24733697626	2019-09-11 10:10:31.160177-04	2019-09-04	-600	1	2	operacion	c.serv.cajero aut.	332	6	0	24733697626
80329	02533957160	02533957160	2019-09-11 10:10:31.160177-04	2019-09-05	-100000	1	2	operacion	trf.mb 0134 v012397130 blanco garcia jua 3463	332	6	0	02533957160
80330	55634987535	55634987535	2019-09-11 10:10:31.160177-04	2019-09-05	-80000	1	2	operacion	banesco pago movil	332	6	0	55634987535
80331	08023060000	08023060000	2019-09-11 10:10:31.160177-04	2019-09-06	-27000	1	2	operacion	compra pos cta/cte	332	6	0	08023060000
80332	00000560907	00000560907	2019-09-11 10:10:31.160177-04	2019-09-06	200000	1	1	operacion	trf.ob 0191 v014964040 moreno pitalua sa 3463	332	6	0	00000560907
80333	84722214355	84722214355	2019-09-11 10:10:31.160177-04	2019-09-06	406000	1	1	operacion	banesco pago movil	332	6	0	84722214355
80334	84722215148	84722215148	2019-09-11 10:10:31.160177-04	2019-09-06	100000	1	1	operacion	banesco pago movil	332	6	0	84722215148
80335	02536440599	02536440599	2019-09-11 10:10:31.160177-04	2019-09-06	-100000	1	2	operacion	trf.mb 0134 v012557310 baez gregoric lui 3463	332	6	0	02536440599
80336	02536700128	02536700128	2019-09-11 10:10:31.160177-04	2019-09-06	230000	1	1	operacion	trf.mb 0134 v009098657 salas arismendi y 3463	332	6	0	02536700128
80337	02535421108	02535421108	2019-09-11 10:10:31.160177-04	2019-09-06	-406000	1	2	operacion	trf.mb 0134 v016342979 morales ferrer al 3463	332	6	0	02535421108
80338	53979309310	53979309310	2019-09-11 10:10:31.160177-04	2019-09-06	-203000	1	2	operacion	banesco pago movil	332	6	0	53979309310
80339	53979309310	53979309310	2019-09-11 10:10:31.160177-04	2019-09-06	-609	1	2	operacion	banesco pago movil	332	6	0	53979309310
80340	56003566512	56003566512	2019-09-11 10:10:31.160177-04	2019-09-10	-3500	1	2	operacion	banesco pago movil	332	6	0	56003566512
80341	56003566512	56003566512	2019-09-11 10:10:31.160177-04	2019-09-10	-10.5	1	2	operacion	com. banesco pago movil	332	6	0	56003566512
80342	49266777524	49266777524	2019-09-11 10:10:31.160177-04	2019-09-10	-32000	1	2	operacion	banesco pago movil	332	6	0	49266777524
80343	49266777524	49266777524	2019-09-11 10:10:31.160177-04	2019-09-10	-96	1	2	operacion	com. banesco pago movil	332	6	0	49266777524
80344	000000000000000	000000000000000	2019-09-11 13:53:18.983774-04	2019-01-02	0.0100000000000000002	1	1		abono de intereses	333	6	0	000000000000000
80345	000075002178541	000075002178541	2019-09-11 13:53:18.983774-04	2019-01-02	-4500	1	2		consumo tarjeta de pago abra 24	333	6	0	000075002178541
80346	000073700518026	000073700518026	2019-09-11 13:53:18.983774-04	2019-01-02	-626.059999999999945	1	2		pago master card via internet	333	6	0	000073700518026
80347	000018700359339	000018700359339	2019-09-11 13:53:18.983774-04	2019-01-02	-900	1	2		pago visa via internet	333	6	0	000018700359339
80348	000098200873077	000098200873077	2019-09-11 13:53:18.983774-04	2019-01-02	-2390	1	2		consumo tarjeta llave mercantil maestro nac.	333	6	0	000098200873077
80349	000025549770625	000025549770625	2019-09-11 13:53:18.983774-04	2019-01-02	-1425.71000000000004	1	2		pago a terceros via internet	333	6	0	000025549770625
80350	000025546702066	000025546702066	2019-09-11 13:53:18.983774-04	2019-01-02	-1390.27999999999997	1	2		pago a terceros via internet	333	6	0	000025546702066
80351	000098200149240	000098200149240	2019-09-11 13:53:18.983774-04	2019-01-02	-259	1	2		consumo tarjeta llave mercantil maestro nac.	333	6	0	000098200149240
80352	000098200601647	000098200601647	2019-09-11 13:53:18.983774-04	2019-01-02	-2200	1	2		consumo tarjeta llave mercantil maestro nac.	333	6	0	000098200601647
80353	000025574276442	000025574276442	2019-09-11 13:53:18.983774-04	2019-01-02	-2997.67999999999984	1	2		pago a terceros via internet	333	6	0	000025574276442
80354	000023900441230	000023900441230	2019-09-11 13:53:18.983774-04	2019-01-02	-100	1	2		recargo comision bcv res 10	333	6	0	000023900441230
80355	000052500441230	000052500441230	2019-09-11 13:53:18.983774-04	2019-01-02	-1.14999999999999991	1	2		comision por recepcion servicios especiales	333	6	0	000052500441230
80356	000052300441230	000052300441230	2019-09-11 13:53:18.983774-04	2019-01-02	-11500	1	2		orden de pago segun nota	333	6	0	000052300441230
80357	000084405594977	000084405594977	2019-09-11 13:53:18.983774-04	2019-01-02	-6	1	2		comision pago movil interbancario	333	6	0	000084405594977
80358	000084705594977	000084705594977	2019-09-11 13:53:18.983774-04	2019-01-02	-2000	1	2		pago movil interbancario	333	6	0	000084705594977
80360	000084405570987	000084405570987	2019-09-11 13:53:18.983774-04	2019-01-02	-6	1	2		comision pago movil interbancario	333	6	0	000084405570987
80361	000084705570987	000084705570987	2019-09-11 13:53:18.983774-04	2019-01-02	-2000	1	2		pago movil interbancario	333	6	0	000084705570987
80362	000098200848561	000098200848561	2019-09-11 13:53:18.983774-04	2019-01-02	-200	1	2		consumo tarjeta llave mercantil maestro nac.	333	6	0	000098200848561
80363	000098200847391	000098200847391	2019-09-11 13:53:18.983774-04	2019-01-02	-1350	1	2		consumo tarjeta llave mercantil maestro nac.	333	6	0	000098200847391
80364	000098200894339	000098200894339	2019-09-11 13:53:18.983774-04	2019-01-02	-2975	1	2		consumo tarjeta llave mercantil maestro nac.	333	6	0	000098200894339
80365	000098200620595	000098200620595	2019-09-11 13:53:18.983774-04	2019-01-02	-46398	1	2		consumo tarjeta llave mercantil maestro nac.	333	6	0	000098200620595
80366	000098200120273	000098200120273	2019-09-11 13:53:18.983774-04	2019-01-02	-2327.88000000000011	1	2		consumo tarjeta llave mercantil maestro nac.	333	6	0	000098200120273
80367	000098200685057	000098200685057	2019-09-11 13:53:18.983774-04	2019-01-02	-850	1	2		consumo tarjeta llave mercantil maestro nac.	333	6	0	000098200685057
80368	000075001165201	000075001165201	2019-09-11 13:53:18.983774-04	2019-01-02	-11160	1	2		consumo tarjeta de pago abra 24	333	6	0	000075001165201
80369	000075001092787	000075001092787	2019-09-11 13:53:18.983774-04	2019-01-02	-18699	1	2		consumo tarjeta de pago abra 24	333	6	0	000075001092787
80370	000098200859256	000098200859256	2019-09-11 13:53:18.983774-04	2019-01-02	-13370	1	2		consumo tarjeta llave mercantil maestro nac.	333	6	0	000098200859256
80371	000098200002200	000098200002200	2019-09-11 13:53:18.983774-04	2019-01-02	-3551.84999999999991	1	2		consumo tarjeta llave mercantil maestro nac.	333	6	0	000098200002200
80372	000084405496441	000084405496441	2019-09-11 13:53:18.983774-04	2019-01-02	-6	1	2		comision pago movil interbancario	333	6	0	000084405496441
80373	000084705496441	000084705496441	2019-09-11 13:53:18.983774-04	2019-01-02	-2000	1	2		pago movil interbancario	333	6	0	000084705496441
80374	000000000000000	000000000000000	2019-09-11 13:53:18.983774-04	2019-01-02	0.0899999999999999967	1	1		abono de intereses	333	6	0	000000000000000
80375	000084405433991	000084405433991	2019-09-11 13:53:18.983774-04	2019-01-02	-6	1	2		comision pago movil interbancario	333	6	0	000084405433991
80376	000084705433991	000084705433991	2019-09-11 13:53:18.983774-04	2019-01-02	-2000	1	2		pago movil interbancario	333	6	0	000084705433991
80377	000098200332818	000098200332818	2019-09-11 13:53:18.983774-04	2019-01-02	-259	1	2		consumo tarjeta llave mercantil maestro nac.	333	6	0	000098200332818
80378	000098200657891	000098200657891	2019-09-11 13:53:18.983774-04	2019-01-02	-966.299999999999955	1	2		consumo tarjeta llave mercantil maestro nac.	333	6	0	000098200657891
80379	000098200830267	000098200830267	2019-09-11 13:53:18.983774-04	2019-01-02	-1462	1	2		consumo tarjeta llave mercantil maestro nac.	333	6	0	000098200830267
80380	000025596883766	000025596883766	2019-09-11 13:53:18.983774-04	2019-01-02	-4800	1	2		pago a terceros via internet	333	6	0	000025596883766
80381	000098200086242	000098200086242	2019-09-11 13:53:18.983774-04	2019-01-02	-1201	1	2		consumo tarjeta llave mercantil maestro nac.	333	6	0	000098200086242
80382	000098200901176	000098200901176	2019-09-11 13:53:18.983774-04	2019-01-02	-259	1	2		consumo tarjeta llave mercantil maestro nac.	333	6	0	000098200901176
80383	000098200984636	000098200984636	2019-09-11 13:53:18.983774-04	2019-01-02	-3500	1	2		consumo tarjeta llave mercantil maestro nac.	333	6	0	000098200984636
80384	000084405328536	000084405328536	2019-09-11 13:53:18.983774-04	2019-01-02	-6	1	2		comision pago movil interbancario	333	6	0	000084405328536
80385	000084705328536	000084705328536	2019-09-11 13:53:18.983774-04	2019-01-02	-2000	1	2		pago movil interbancario	333	6	0	000084705328536
80386	000098200678115	000098200678115	2019-09-11 13:53:18.983774-04	2019-01-02	-8876.89999999999964	1	2		consumo tarjeta llave mercantil maestro nac.	333	6	0	000098200678115
80387	000098200545369	000098200545369	2019-09-11 13:53:18.983774-04	2019-01-03	-960	1	2		consumo tarjeta llave mercantil maestro nac.	333	6	0	000098200545369
80388	000098200301451	000098200301451	2019-09-11 13:53:18.983774-04	2019-01-03	-259	1	2		consumo tarjeta llave mercantil maestro nac.	333	6	0	000098200301451
80389	000084405649402	000084405649402	2019-09-11 13:53:18.983774-04	2019-01-03	-6	1	2		comision pago movil interbancario	333	6	0	000084405649402
80390	000084705649402	000084705649402	2019-09-11 13:53:18.983774-04	2019-01-03	-2000	1	2		pago movil interbancario	333	6	0	000084705649402
80391	000075001957984	000075001957984	2019-09-11 13:53:18.983774-04	2019-01-03	-612.149999999999977	1	2		consumo tarjeta de pago abra 24	333	6	0	000075001957984
80392	000098200598857	000098200598857	2019-09-11 13:53:18.983774-04	2019-01-03	-400	1	2		consumo tarjeta llave mercantil maestro nac.	333	6	0	000098200598857
80393	000098200251242	000098200251242	2019-09-11 13:53:18.983774-04	2019-01-04	-3510	1	2		consumo tarjeta llave mercantil maestro nac.	333	6	0	000098200251242
80394	000084706943527	000084706943527	2019-09-11 13:53:18.983774-04	2019-01-07	12000	1	1		pago movil interbancario	333	6	0	000084706943527
80395	000084706942576	000084706942576	2019-09-11 13:53:18.983774-04	2019-01-07	4800	1	1		pago movil interbancario	333	6	0	000084706942576
80396	000000000000000	000000000000000	2019-09-11 13:53:18.983774-04	2019-01-07	0.0200000000000000004	1	1		abono de intereses	333	6	0	000000000000000
80397	000062000074590	000062000074590	2019-09-11 13:53:18.983774-04	2019-01-07	-2000	1	2		transferencia de fondos via internet	333	6	0	000062000074590
80398	000084706804526	000084706804526	2019-09-11 13:53:18.983774-04	2019-01-07	15000	1	1		pago movil interbancario	333	6	0	000084706804526
80399	000025595008088	000025595008088	2019-09-11 13:53:18.983774-04	2019-01-07	-19000	1	2		pago a terceros via internet	333	6	0	000025595008088
80400	000084706962833	000084706962833	2019-09-11 13:53:18.983774-04	2019-01-07	20000	1	1		pago movil interbancario	333	6	0	000084706962833
80401	000098200010073	000098200010073	2019-09-11 13:53:18.983774-04	2019-01-07	-1500	1	2		consumo tarjeta llave mercantil maestro nac.	333	6	0	000098200010073
80402	000098200651844	000098200651844	2019-09-11 13:53:18.983774-04	2019-01-07	-487	1	2		consumo tarjeta llave mercantil maestro nac.	333	6	0	000098200651844
80403	000023900974328	000023900974328	2019-09-11 13:53:18.983774-04	2019-01-07	-100	1	2		recargo comision bcv res 10	333	6	0	000023900974328
80404	000052500974328	000052500974328	2019-09-11 13:53:18.983774-04	2019-01-07	-1.5	1	2		comision por recepcion servicios especiales	333	6	0	000052500974328
80405	000052300974328	000052300974328	2019-09-11 13:53:18.983774-04	2019-01-07	-15000	1	2		orden de pago segun nota	333	6	0	000052300974328
80406	000084405944335	000084405944335	2019-09-11 13:53:18.983774-04	2019-01-07	-45	1	2		comision pago movil interbancario	333	6	0	000084405944335
80407	000084705944335	000084705944335	2019-09-11 13:53:18.983774-04	2019-01-07	-15000	1	2		pago movil interbancario	333	6	0	000084705944335
80408	000084706454174	000084706454174	2019-09-11 13:53:18.983774-04	2019-01-11	22000	1	1		pago movil interbancario	333	6	0	000084706454174
80409	000084405472720	000084405472720	2019-09-11 13:53:18.983774-04	2019-01-11	-0.900000000000000022	1	2		comision pago movil interbancario	333	6	0	000084405472720
80410	000084705472720	000084705472720	2019-09-11 13:53:18.983774-04	2019-01-11	-300	1	2		pago movil interbancario	333	6	0	000084705472720
80411	000098200463233	000098200463233	2019-09-11 13:53:18.983774-04	2019-01-11	-3380	1	2		consumo tarjeta llave mercantil maestro nac.	333	6	0	000098200463233
80412	000098200916217	000098200916217	2019-09-11 13:53:18.983774-04	2019-01-11	-1344	1	2		consumo tarjeta llave mercantil maestro nac.	333	6	0	000098200916217
80413	000025589322876	000025589322876	2019-09-11 13:53:18.983774-04	2019-01-11	-22000	1	2		pago a terceros via internet	333	6	0	000025589322876
80414	000098200508017	000098200508017	2019-09-11 13:53:18.983774-04	2019-01-14	-784	1	2		consumo tarjeta llave mercantil maestro nac.	333	6	0	000098200508017
80415	000018700359339	000018700359339	2019-09-11 13:53:18.983774-04	2019-01-14	-82.25	1	2		pago visa via internet	333	6	0	000018700359339
80416	000073700518026	000073700518026	2019-09-11 13:53:18.983774-04	2019-01-14	-890	1	2		pago master card via internet	333	6	0	000073700518026
80417	000084706713755	000084706713755	2019-09-11 13:53:18.983774-04	2019-01-14	4500	1	1		pago movil interbancario	333	6	0	000084706713755
80418	000084405694419	000084405694419	2019-09-11 13:53:18.983774-04	2019-01-14	-1.77000000000000002	1	2		comision pago movil interbancario	333	6	0	000084405694419
80419	000084705694419	000084705694419	2019-09-11 13:53:18.983774-04	2019-01-14	-590	1	2		pago movil interbancario	333	6	0	000084705694419
80420	000084405658457	000084405658457	2019-09-11 13:53:18.983774-04	2019-01-14	-6	1	2		comision pago movil interbancario	333	6	0	000084405658457
80421	000084705658457	000084705658457	2019-09-11 13:53:18.983774-04	2019-01-14	-2000	1	2		pago movil interbancario	333	6	0	000084705658457
80422	000098200381761	000098200381761	2019-09-11 13:53:18.983774-04	2019-01-14	-1448	1	2		consumo tarjeta llave mercantil maestro nac.	333	6	0	000098200381761
80423	000025556666080	000025556666080	2019-09-11 13:53:18.983774-04	2019-01-14	4000	1	1		pago a terceros via internet	333	6	0	000025556666080
80424	000084405570168	000084405570168	2019-09-11 13:53:18.983774-04	2019-01-14	-10.5	1	2		comision pago movil interbancario	333	6	0	000084405570168
80425	000084705570168	000084705570168	2019-09-11 13:53:18.983774-04	2019-01-14	-3500	1	2		pago movil interbancario	333	6	0	000084705570168
80426	000084706765972	000084706765972	2019-09-11 13:53:18.983774-04	2019-01-15	5000	1	1		pago movil interbancario	333	6	0	000084706765972
80427	000025527730649	000025527730649	2019-09-11 13:53:18.983774-04	2019-01-15	-4500	1	2		pago a terceros via internet	333	6	0	000025527730649
80428	000026902462498	000026902462498	2019-09-11 13:53:18.983774-04	2019-01-15	-1303.17000000000007	1	2		pago luz electrica via internet	333	6	0	000026902462498
80429	000062000030333	000062000030333	2019-09-11 13:53:18.983774-04	2019-01-15	-2000	1	2		transferencia de fondos via internet	333	6	0	000062000030333
80430	000052500497289	000052500497289	2019-09-11 13:53:18.983774-04	2019-01-16	-0.100000000000000006	1	2		comision por recepcion servicios especiales	333	6	0	000052500497289
80431	000052300497289	000052300497289	2019-09-11 13:53:18.983774-04	2019-01-16	-1000	1	2		orden de pago segun nota	333	6	0	000052300497289
80432	000023900491979	000023900491979	2019-09-11 13:53:18.983774-04	2019-01-16	-100	1	2		recargo comision bcv res 10	333	6	0	000023900491979
80433	000052500491979	000052500491979	2019-09-11 13:53:18.983774-04	2019-01-16	-2.10000000000000009	1	2		comision por recepcion servicios especiales	333	6	0	000052500491979
80434	000052300491979	000052300491979	2019-09-11 13:53:18.983774-04	2019-01-16	-21078.4399999999987	1	2		orden de pago segun nota	333	6	0	000052300491979
80435	000023900491977	000023900491977	2019-09-11 13:53:18.983774-04	2019-01-16	-100	1	2		recargo comision bcv res 10	333	6	0	000023900491977
80436	000052500491977	000052500491977	2019-09-11 13:53:18.983774-04	2019-01-16	-3.08999999999999986	1	2		comision por recepcion servicios especiales	333	6	0	000052500491977
80437	000052300491977	000052300491977	2019-09-11 13:53:18.983774-04	2019-01-16	-30960.5699999999997	1	2		orden de pago segun nota	333	6	0	000052300491977
80438	000084405921567	000084405921567	2019-09-11 13:53:18.983774-04	2019-01-16	-45	1	2		comision pago movil interbancario	333	6	0	000084405921567
80439	000084705921567	000084705921567	2019-09-11 13:53:18.983774-04	2019-01-16	-15000	1	2		pago movil interbancario	333	6	0	000084705921567
80440	000023900488948	000023900488948	2019-09-11 13:53:18.983774-04	2019-01-16	-100	1	2		recargo comision bcv res 10	333	6	0	000023900488948
80441	000052500488948	000052500488948	2019-09-11 13:53:18.983774-04	2019-01-16	-7	1	2		comision por recepcion servicios especiales	333	6	0	000052500488948
80442	000052300488948	000052300488948	2019-09-11 13:53:18.983774-04	2019-01-16	-70000	1	2		orden de pago segun nota	333	6	0	000052300488948
80443	000025572361444	000025572361444	2019-09-11 13:53:18.983774-04	2019-01-16	-98000	1	2		pago a terceros via internet	333	6	0	000025572361444
80444	000025572359437	000025572359437	2019-09-11 13:53:18.983774-04	2019-01-16	-98000	1	2		pago a terceros via internet	333	6	0	000025572359437
80445	000047900042282	000047900042282	2019-09-11 13:53:18.983774-04	2019-01-16	600000	1	1		pago a proveedores en linea	333	6	0	000047900042282
80446	000052537177489	000052537177489	2019-09-11 13:53:18.983774-04	2019-01-16	-12.0800000000000001	1	2		comision por recepcion servicios especiales	333	6	0	000052537177489
80447	000034437177489	000034437177489	2019-09-11 13:53:18.983774-04	2019-01-16	-509	1	2		pago tarjetas de credito otros bancos	333	6	0	000034437177489
80448	000000000000000	000000000000000	2019-09-11 13:53:18.983774-04	2019-01-16	0.0700000000000000067	1	1		abono de intereses	333	6	0	000000000000000
80449	000098200760375	000098200760375	2019-09-11 13:53:18.983774-04	2019-01-16	-1890	1	2		consumo tarjeta llave mercantil maestro nac.	333	6	0	000098200760375
80450	000098200432333	000098200432333	2019-09-11 13:53:18.983774-04	2019-01-16	-23800	1	2		consumo tarjeta llave mercantil maestro nac.	333	6	0	000098200432333
80451	000098200024991	000098200024991	2019-09-11 13:53:18.983774-04	2019-01-17	-80000	1	2		consumo tarjeta llave mercantil maestro nac.	333	6	0	000098200024991
80452	000098200099525	000098200099525	2019-09-11 13:53:18.983774-04	2019-01-17	-1515	1	2		consumo tarjeta llave mercantil maestro nac.	333	6	0	000098200099525
80453	000084405985428	000084405985428	2019-09-11 13:53:18.983774-04	2019-01-17	-45	1	2		comision pago movil interbancario	333	6	0	000084405985428
80454	000084705985428	000084705985428	2019-09-11 13:53:18.983774-04	2019-01-17	-15000	1	2		pago movil interbancario	333	6	0	000084705985428
80455	000000000000000	000000000000000	2019-09-11 13:53:18.983774-04	2019-01-17	0.0299999999999999989	1	1		abono de intereses	333	6	0	000000000000000
80456	000098200634905	000098200634905	2019-09-11 13:53:18.983774-04	2019-01-17	-978	1	2		consumo tarjeta llave mercantil maestro nac.	333	6	0	000098200634905
80457	000098200618256	000098200618256	2019-09-11 13:53:18.983774-04	2019-01-17	-17245	1	2		consumo tarjeta llave mercantil maestro nac.	333	6	0	000098200618256
80458	000098200390911	000098200390911	2019-09-11 13:53:18.983774-04	2019-01-18	-978	1	2		consumo tarjeta llave mercantil maestro nac.	333	6	0	000098200390911
80459	000084405116488	000084405116488	2019-09-11 13:53:18.983774-04	2019-01-18	-45	1	2		comision pago movil interbancario	333	6	0	000084405116488
80460	000084705116488	000084705116488	2019-09-11 13:53:18.983774-04	2019-01-18	-15000	1	2		pago movil interbancario	333	6	0	000084705116488
80461	000098200016131	000098200016131	2019-09-11 13:53:18.983774-04	2019-01-18	-3275	1	2		consumo tarjeta llave mercantil maestro nac.	333	6	0	000098200016131
80462	000000000000000	000000000000000	2019-09-11 13:53:18.983774-04	2019-01-18	0.0299999999999999989	1	1		abono de intereses	333	6	0	000000000000000
80463	000098200676766	000098200676766	2019-09-11 13:53:18.983774-04	2019-01-18	-978	1	2		consumo tarjeta llave mercantil maestro nac.	333	6	0	000098200676766
80464	000098200313473	000098200313473	2019-09-11 13:53:18.983774-04	2019-01-18	-2450	1	2		consumo tarjeta llave mercantil maestro nac.	333	6	0	000098200313473
80465	000084405319580	000084405319580	2019-09-11 13:53:18.983774-04	2019-01-21	-18	1	2		comision pago movil interbancario	333	6	0	000084405319580
80466	000084705319580	000084705319580	2019-09-11 13:53:18.983774-04	2019-01-21	-6000	1	2		pago movil interbancario	333	6	0	000084705319580
80467	000098200097701	000098200097701	2019-09-11 13:53:18.983774-04	2019-01-21	-1100	1	2		consumo tarjeta llave mercantil maestro nac.	333	6	0	000098200097701
80468	000000000000000	000000000000000	2019-09-11 13:53:18.983774-04	2019-01-21	0.0299999999999999989	1	1		abono de intereses	333	6	0	000000000000000
80469	000075001475584	000075001475584	2019-09-11 13:53:18.983774-04	2019-01-21	-6600	1	2		consumo tarjeta de pago abra 24	333	6	0	000075001475584
80470	000098200000643	000098200000643	2019-09-11 13:53:18.983774-04	2019-01-21	-9950	1	2		consumo tarjeta llave mercantil maestro nac.	333	6	0	000098200000643
80471	000000000000000	000000000000000	2019-09-11 13:53:18.983774-04	2019-01-21	0.0100000000000000002	1	1		abono de intereses	333	6	0	000000000000000
80472	000098200033811	000098200033811	2019-09-11 13:53:18.983774-04	2019-01-21	-1800	1	2		consumo tarjeta llave mercantil maestro nac.	333	6	0	000098200033811
80473	000098200020903	000098200020903	2019-09-11 13:53:18.983774-04	2019-01-21	-3000	1	2		consumo tarjeta llave mercantil maestro nac.	333	6	0	000098200020903
80474	000098200002139	000098200002139	2019-09-11 13:53:18.983774-04	2019-01-21	-1900	1	2		consumo tarjeta llave mercantil maestro nac.	333	6	0	000098200002139
80475	000098200364705	000098200364705	2019-09-11 13:53:18.983774-04	2019-01-21	-34049	1	2		consumo tarjeta llave mercantil maestro nac.	333	6	0	000098200364705
80476	000075002458359	000075002458359	2019-09-11 13:53:18.983774-04	2019-01-21	-3550	1	2		consumo tarjeta de pago abra 24	333	6	0	000075002458359
80477	000098200763075	000098200763075	2019-09-11 13:53:18.983774-04	2019-01-21	-2429.61000000000013	1	2		consumo tarjeta llave mercantil maestro nac.	333	6	0	000098200763075
80478	000098200584507	000098200584507	2019-09-11 13:53:18.983774-04	2019-01-21	-3980	1	2		consumo tarjeta llave mercantil maestro nac.	333	6	0	000098200584507
80479	000084405321668	000084405321668	2019-09-11 13:53:18.983774-04	2019-01-21	-27	1	2		comision pago movil interbancario	333	6	0	000084405321668
80480	000084705321668	000084705321668	2019-09-11 13:53:18.983774-04	2019-01-21	-9000	1	2		pago movil interbancario	333	6	0	000084705321668
80481	000098200621417	000098200621417	2019-09-11 13:53:18.983774-04	2019-01-22	-1900	1	2		consumo tarjeta llave mercantil maestro nac.	333	6	0	000098200621417
80482	000098200332362	000098200332362	2019-09-11 13:53:18.983774-04	2019-01-22	-1646	1	2		consumo tarjeta llave mercantil maestro nac.	333	6	0	000098200332362
80483	000098200521548	000098200521548	2019-09-11 13:53:18.983774-04	2019-01-22	-2215.51999999999998	1	2		consumo tarjeta llave mercantil maestro nac.	333	6	0	000098200521548
80484	000047900096455	000047900096455	2019-09-11 13:53:18.983774-04	2019-01-24	250000	1	1		pago a proveedores en linea	333	6	0	000047900096455
80485	000098200406895	000098200406895	2019-09-11 13:53:18.983774-04	2019-01-24	-2200	1	2		consumo tarjeta llave mercantil maestro nac.	333	6	0	000098200406895
80486	000098200003454	000098200003454	2019-09-11 13:53:18.983774-04	2019-01-24	-4400	1	2		consumo tarjeta llave mercantil maestro nac.	333	6	0	000098200003454
80487	000000000000000	000000000000000	2019-09-11 13:53:18.983774-04	2019-01-24	0.0400000000000000008	1	1		abono de intereses	333	6	0	000000000000000
80488	000023900761564	000023900761564	2019-09-11 13:53:18.983774-04	2019-01-24	-100	1	2		recargo comision bcv res 10	333	6	0	000023900761564
80489	000052500761564	000052500761564	2019-09-11 13:53:18.983774-04	2019-01-24	-10	1	2		comision por recepcion servicios especiales	333	6	0	000052500761564
80490	000052300761564	000052300761564	2019-09-11 13:53:18.983774-04	2019-01-24	-100000	1	2		orden de pago segun nota	333	6	0	000052300761564
80491	000084403743636	000084403743636	2019-09-11 13:53:18.983774-04	2019-01-24	-45	1	2		comision pago movil interbancario	333	6	0	000084403743636
80492	000084703743636	000084703743636	2019-09-11 13:53:18.983774-04	2019-01-24	-15000	1	2		pago movil interbancario	333	6	0	000084703743636
80493	000000000000000	000000000000000	2019-09-11 13:53:18.983774-04	2019-01-25	0.160000000000000003	1	1		abono de intereses	333	6	0	000000000000000
80494	000047900030886	000047900030886	2019-09-11 13:53:18.983774-04	2019-01-25	513000	1	1		pago a proveedores en linea	333	6	0	000047900030886
80495	000098200500822	000098200500822	2019-09-11 13:53:18.983774-04	2019-01-25	-1650	1	2		consumo tarjeta llave mercantil maestro nac.	333	6	0	000098200500822
80496	000098200019916	000098200019916	2019-09-11 13:53:18.983774-04	2019-01-25	-17610	1	2		consumo tarjeta llave mercantil maestro nac.	333	6	0	000098200019916
80497	000098200700070	000098200700070	2019-09-11 13:53:18.983774-04	2019-01-25	-2650	1	2		consumo tarjeta llave mercantil maestro nac.	333	6	0	000098200700070
80498	000084405829027	000084405829027	2019-09-11 13:53:18.983774-04	2019-01-25	-30	1	2		comision pago movil interbancario	333	6	0	000084405829027
80499	000084705829027	000084705829027	2019-09-11 13:53:18.983774-04	2019-01-25	-10000	1	2		pago movil interbancario	333	6	0	000084705829027
80500	000052500907082	000052500907082	2019-09-11 13:53:18.983774-04	2019-01-25	-0.0400000000000000008	1	2		comision por recepcion servicios especiales	333	6	0	000052500907082
80501	000052300907082	000052300907082	2019-09-11 13:53:18.983774-04	2019-01-25	-400	1	2		orden de pago segun nota	333	6	0	000052300907082
80502	000052500907081	000052500907081	2019-09-11 13:53:18.983774-04	2019-01-25	-0.0400000000000000008	1	2		comision por recepcion servicios especiales	333	6	0	000052500907081
80503	000052300907081	000052300907081	2019-09-11 13:53:18.983774-04	2019-01-25	-400	1	2		orden de pago segun nota	333	6	0	000052300907081
80504	000098200399789	000098200399789	2019-09-11 13:53:18.983774-04	2019-01-25	-2980.23999999999978	1	2		consumo tarjeta llave mercantil maestro nac.	333	6	0	000098200399789
80505	000098200000381	000098200000381	2019-09-11 13:53:18.983774-04	2019-01-25	-49858.6999999999971	1	2		consumo tarjeta llave mercantil maestro nac.	333	6	0	000098200000381
80506	000084405777779	000084405777779	2019-09-11 13:53:18.983774-04	2019-01-25	-2.10000000000000009	1	2		comision pago movil interbancario	333	6	0	000084405777779
80507	000084705777779	000084705777779	2019-09-11 13:53:18.983774-04	2019-01-25	-700	1	2		pago movil interbancario	333	6	0	000084705777779
80508	000098200139921	000098200139921	2019-09-11 13:53:18.983774-04	2019-01-28	-2000	1	2		consumo tarjeta llave mercantil maestro nac.	333	6	0	000098200139921
80509	000000000000000	000000000000000	2019-09-11 13:53:18.983774-04	2019-01-28	0.140000000000000013	1	1		abono de intereses	333	6	0	000000000000000
80510	000098200689550	000098200689550	2019-09-11 13:53:18.983774-04	2019-01-28	-12600	1	2		consumo tarjeta llave mercantil maestro nac.	333	6	0	000098200689550
80511	000098200817491	000098200817491	2019-09-11 13:53:18.983774-04	2019-01-28	-1000	1	2		consumo tarjeta llave mercantil maestro nac.	333	6	0	000098200817491
80512	000098200817361	000098200817361	2019-09-11 13:53:18.983774-04	2019-01-28	-7200	1	2		consumo tarjeta llave mercantil maestro nac.	333	6	0	000098200817361
80513	000023900007290	000023900007290	2019-09-11 13:53:18.983774-04	2019-01-28	-100	1	2		recargo comision bcv res 10	333	6	0	000023900007290
80514	000052500007290	000052500007290	2019-09-11 13:53:18.983774-04	2019-01-28	-30	1	2		comision por recepcion servicios especiales	333	6	0	000052500007290
80515	000052300007290	000052300007290	2019-09-11 13:53:18.983774-04	2019-01-28	-300000	1	2		orden de pago segun nota	333	6	0	000052300007290
80516	000084405930757	000084405930757	2019-09-11 13:53:18.983774-04	2019-01-28	-24	1	2		comision pago movil interbancario	333	6	0	000084405930757
80517	000084705930757	000084705930757	2019-09-11 13:53:18.983774-04	2019-01-28	-8000	1	2		pago movil interbancario	333	6	0	000084705930757
80518	000098200932648	000098200932648	2019-09-11 13:53:18.983774-04	2019-01-28	-3690	1	2		consumo tarjeta llave mercantil maestro nac.	333	6	0	000098200932648
80519	000000000000000	000000000000000	2019-09-11 13:53:18.983774-04	2019-01-28	0.0200000000000000004	1	1		abono de intereses	333	6	0	000000000000000
80520	000098200000712	000098200000712	2019-09-11 13:53:18.983774-04	2019-01-28	-3500	1	2		consumo tarjeta llave mercantil maestro nac.	333	6	0	000098200000712
80521	000023900160932	000023900160932	2019-09-11 13:53:18.983774-04	2019-01-28	-100	1	2		recargo comision bcv res 10	333	6	0	000023900160932
80522	000052500160932	000052500160932	2019-09-11 13:53:18.983774-04	2019-01-28	-17.5	1	2		comision por recepcion servicios especiales	333	6	0	000052500160932
80523	000052300160932	000052300160932	2019-09-11 13:53:18.983774-04	2019-01-28	-175000	1	2		orden de pago segun nota	333	6	0	000052300160932
80524	000098200000778	000098200000778	2019-09-11 13:53:18.983774-04	2019-01-29	-3500	1	2		consumo tarjeta llave mercantil maestro nac.	333	6	0	000098200000778
80525	000084405227299	000084405227299	2019-09-11 13:53:18.983774-04	2019-01-29	-1.19999999999999996	1	2		comision pago movil interbancario	333	6	0	000084405227299
80526	000084705227299	000084705227299	2019-09-11 13:53:18.983774-04	2019-01-29	-400	1	2		pago movil interbancario	333	6	0	000084705227299
80527	000084405221442	000084405221442	2019-09-11 13:53:18.983774-04	2019-01-29	-15	1	2		comision pago movil interbancario	333	6	0	000084405221442
80528	000084705221442	000084705221442	2019-09-11 13:53:18.983774-04	2019-01-29	-5000	1	2		pago movil interbancario	333	6	0	000084705221442
80529	000098200784898	000098200784898	2019-09-11 13:53:18.983774-04	2019-01-29	-1000	1	2		consumo tarjeta llave mercantil maestro nac.	333	6	0	000098200784898
80530	000098200867941	000098200867941	2019-09-11 13:53:18.983774-04	2019-01-29	-3400	1	2		consumo tarjeta llave mercantil maestro nac.	333	6	0	000098200867941
80531	000098200862380	000098200862380	2019-09-11 13:53:18.983774-04	2019-01-29	-1999	1	2		consumo tarjeta llave mercantil maestro nac.	333	6	0	000098200862380
80532	000000000000000	000000000000000	2019-09-11 13:53:18.983774-04	2019-01-29	0.0100000000000000002	1	1		abono de intereses	333	6	0	000000000000000
80533	000000000000000	000000000000000	2019-09-11 13:53:18.983774-04	2019-01-30	0.0100000000000000002	1	1		abono de intereses	333	6	0	000000000000000
80534	000075001656579	000075001656579	2019-09-11 13:53:18.983774-04	2019-01-30	-1125	1	2		consumo tarjeta de pago abra 24	333	6	0	000075001656579
80535	000098200000226	000098200000226	2019-09-11 13:53:18.983774-04	2019-01-30	-1241	1	2		consumo tarjeta llave mercantil maestro nac.	333	6	0	000098200000226
80536	000084405341070	000084405341070	2019-09-11 13:53:18.983774-04	2019-01-30	-45	1	2		comision pago movil interbancario	333	6	0	000084405341070
80537	000084705341070	000084705341070	2019-09-11 13:53:18.983774-04	2019-01-30	-15000	1	2		pago movil interbancario	333	6	0	000084705341070
80538	000084705548172	000084705548172	2019-09-11 13:53:18.983774-04	2019-01-31	-1000	1	2		pago movil interbancario	333	6	0	000084705548172
80539	000098200000341	000098200000341	2019-09-11 13:53:18.983774-04	2019-01-31	-1241	1	2		consumo tarjeta llave mercantil maestro nac.	333	6	0	000098200000341
80540	000098200138854	000098200138854	2019-09-11 13:53:18.983774-04	2019-01-31	-5300	1	2		consumo tarjeta llave mercantil maestro nac.	333	6	0	000098200138854
80541	000098200155784	000098200155784	2019-09-11 13:53:18.983774-04	2019-01-31	-800	1	2		consumo tarjeta llave mercantil maestro nac.	333	6	0	000098200155784
80542	000075001042219	000075001042219	2019-09-11 13:53:18.983774-04	2019-01-31	-800	1	2		consumo tarjeta de pago abra 24	333	6	0	000075001042219
80543	000071600000000	000071600000000	2019-09-11 13:53:18.983774-04	2019-01-31	-4.83999999999999986	1	2		emision de estados de cuenta	333	6	0	000071600000000
80544	000084405548172	000084405548172	2019-09-11 13:53:18.983774-04	2019-01-31	-3	1	2		comision pago movil interbancario	333	6	0	000084405548172
83359	301130916	301130916	2019-09-13 16:46:32.415118-04	2019-03-01	-1000	1	2	operacion	soluciones catering    nueva esparta ven zona= banco:986220108    terminal:mc000001	328	6	0	301130916
83360	804588	804588	2019-09-13 16:46:32.415118-04	2019-03-01	15000	1	1	operacion	telf.:584147927663 banco:0559 pmpp traspaso	328	6	0	584147927663
83361	814796	814796	2019-09-13 16:46:32.415118-04	2019-03-01	6600	1	1	operacion	telf.:584147884590 banco:0134 pmpp pago	328	6	0	584147884590
83362	141642738	141642738	2019-09-13 16:46:32.415118-04	2019-03-01	-2000	1	2	operacion		328	6	0	141642738
83363	821273	821273	2019-09-13 16:46:32.415118-04	2019-03-01	10000	1	1	operacion	telf.:584167969171 banco:0104 pmpp otros	328	6	0	584167969171
83364	853333	853333	2019-09-13 16:46:32.415118-04	2019-03-02	10000	1	1	operacion	telf.:584147927663 banco:0559 pmpp traspaso	328	6	0	584147927663
83365	302165140	302165140	2019-09-13 16:46:32.415118-04	2019-03-02	-3400	1	2	operacion	andrade pan y past     ccs noroeste  ven zona= banco:000154150    terminal:mc000001	328	6	0	302165140
83366	302194314	302194314	2019-09-13 16:46:32.415118-04	2019-03-02	-900	1	2	operacion	roca bella ca          ccs noroeste  ven zona= banco:925400031    terminal:mc000001	328	6	0	302194314
83367	302200325	302200325	2019-09-13 16:46:32.415118-04	2019-03-02	-11200	1	2	operacion	farmacia la restinga m nueva esparta ven zona= banco:993731318    terminal:mc000001	328	6	0	302200325
83368	304193915	304193915	2019-09-13 16:46:32.415118-04	2019-03-04	-8800	1	2	operacion	restaurant mis nietos  ccs noroeste  ven zona= banco:000125862    terminal:mc000001	328	6	0	304193915
83369	2988907	2988907	2019-09-13 16:46:32.415118-04	2019-03-05	-9000	1	2	operacion	telf.:584147927663 ced.:012506929 banco:0102 traspaso bbg venezuela	328	6	0	584147927663
83370	2988907	2988907	2019-09-13 16:46:32.415118-04	2019-03-05	-27	1	2	operacion	telf.:584147927663 ced.:012506929 banco:0102 traspaso bbg venezuela	328	6	0	584147927663
83371	314173824	314173824	2019-09-13 16:46:32.415118-04	2019-03-14	-2000	1	2	operacion	roca bella ca          ccs noroeste  ven zona= banco:925400031    terminal:mc000001	328	6	0	314173824
83372	314222023	314222023	2019-09-13 16:46:32.415118-04	2019-03-14	-7480	1	2	operacion	hogar plaza ca02       pampatar      ven zona= banco:986221819    terminal:mc000001	328	6	0	314222023
83373	302020	302020	2019-09-13 16:46:32.415118-04	2019-03-20	15000	1	1	operacion	telf.:584147927663 banco:0134 pmpp traspaso	328	6	0	584147927663
83374	320142154	320142154	2019-09-13 16:46:32.415118-04	2019-03-20	-7100	1	2	operacion	el bodeguero, c.a.     pampatar      ven zona= banco:986220108    terminal:mc000001	328	6	0	320142154
83375	320142246	320142246	2019-09-13 16:46:32.415118-04	2019-03-20	-4200	1	2	operacion	el bodeguero, c.a.     pampatar      ven zona= banco:986220108    terminal:mc000001	328	6	0	320142246
83376	320202417	320202417	2019-09-13 16:46:32.415118-04	2019-03-20	-1200	1	2	operacion	est servicios los robl nueva esparta ven zona= banco:986220108    terminal:mc000001	328	6	0	320202417
83377	321121922	321121922	2019-09-13 16:46:32.415118-04	2019-03-21	-2000	1	2	operacion	roca bella ca          ccs noroeste  ven zona= banco:925400031    terminal:mc000001	328	6	0	321121922
83378	321144620	321144620	2019-09-13 16:46:32.415118-04	2019-03-21	-1000	1	2	operacion	roca bella ca          ccs noroeste  ven zona= banco:925400031    terminal:mc000001	328	6	0	321144620
83379	0	0	2019-09-13 16:46:32.415118-04	2019-03-31	126.060000000000002	1	1	operacion	ints. abonados mes de marzo     - 2019 de su cuenta remunerada al  21.0000% anual	328	6	0	0
84271	000098200463233	000098200463233	2019-09-19 15:14:06.623294-04	2019-01-11	-3380	1	2		consumo tarjeta llave mercantil maestro nac.	325	1	0	000098200463233
84272	000098200916217	000098200916217	2019-09-19 15:14:06.623294-04	2019-01-11	-1344	1	2		consumo tarjeta llave mercantil maestro nac.	325	1	0	000098200916217
84273	000025589322876	000025589322876	2019-09-19 15:14:06.623294-04	2019-01-11	-22000	1	2		pago a terceros via internet	325	1	0	000025589322876
84274	000098200508017	000098200508017	2019-09-19 15:14:06.623294-04	2019-01-14	-784	1	2		consumo tarjeta llave mercantil maestro nac.	325	1	0	000098200508017
84275	000018700359339	000018700359339	2019-09-19 15:14:06.623294-04	2019-01-14	-82.25	1	2		pago visa via internet	325	1	0	000018700359339
84276	000073700518026	000073700518026	2019-09-19 15:14:06.623294-04	2019-01-14	-890	1	2		pago master card via internet	325	1	0	000073700518026
84277	000084706713755	000084706713755	2019-09-19 15:14:06.623294-04	2019-01-14	4500	1	1		pago movil interbancario	325	1	0	000084706713755
84278	000084405694419	000084405694419	2019-09-19 15:14:06.623294-04	2019-01-14	-1.77000000000000002	1	2		comision pago movil interbancario	325	1	0	000084405694419
84279	000084705694419	000084705694419	2019-09-19 15:14:06.623294-04	2019-01-14	-590	1	2		pago movil interbancario	325	1	0	000084705694419
84280	000084405658457	000084405658457	2019-09-19 15:14:06.623294-04	2019-01-14	-6	1	2		comision pago movil interbancario	325	1	0	000084405658457
84281	000084705658457	000084705658457	2019-09-19 15:14:06.623294-04	2019-01-14	-2000	1	2		pago movil interbancario	325	1	0	000084705658457
84282	000098200381761	000098200381761	2019-09-19 15:14:06.623294-04	2019-01-14	-1448	1	2		consumo tarjeta llave mercantil maestro nac.	325	1	0	000098200381761
84283	000025556666080	000025556666080	2019-09-19 15:14:06.623294-04	2019-01-14	4000	1	1		pago a terceros via internet	325	1	0	000025556666080
84284	000084405570168	000084405570168	2019-09-19 15:14:06.623294-04	2019-01-14	-10.5	1	2		comision pago movil interbancario	325	1	0	000084405570168
84285	000084705570168	000084705570168	2019-09-19 15:14:06.623294-04	2019-01-14	-3500	1	2		pago movil interbancario	325	1	0	000084705570168
84345	000098200406895	000098200406895	2019-09-19 15:14:06.623294-04	2019-01-24	-2200	1	2		consumo tarjeta llave mercantil maestro nac.	325	1	0	000098200406895
84346	000098200003454	000098200003454	2019-09-19 15:14:06.623294-04	2019-01-24	-4400	1	2		consumo tarjeta llave mercantil maestro nac.	325	1	0	000098200003454
84347	000000000000000	000000000000000	2019-09-19 15:14:06.623294-04	2019-01-24	0.0400000000000000008	1	1		abono de intereses	325	1	0	000000000000000
84348	000023900761564	000023900761564	2019-09-19 15:14:06.623294-04	2019-01-24	-100	1	2		recargo comision bcv res 10	325	1	0	000023900761564
84349	000052500761564	000052500761564	2019-09-19 15:14:06.623294-04	2019-01-24	-10	1	2		comision por recepcion servicios especiales	325	1	0	000052500761564
84350	000052300761564	000052300761564	2019-09-19 15:14:06.623294-04	2019-01-24	-100000	1	2		orden de pago segun nota	325	1	0	000052300761564
84351	000084403743636	000084403743636	2019-09-19 15:14:06.623294-04	2019-01-24	-45	1	2		comision pago movil interbancario	325	1	0	000084403743636
84352	000084703743636	000084703743636	2019-09-19 15:14:06.623294-04	2019-01-24	-15000	1	2		pago movil interbancario	325	1	0	000084703743636
84353	000000000000000	000000000000000	2019-09-19 15:14:06.623294-04	2019-01-25	0.160000000000000003	1	1		abono de intereses	325	1	0	000000000000000
84354	000047900030886	000047900030886	2019-09-19 15:14:06.623294-04	2019-01-25	513000	1	1		pago a proveedores en linea	325	1	0	000047900030886
84355	000098200500822	000098200500822	2019-09-19 15:14:06.623294-04	2019-01-25	-1650	1	2		consumo tarjeta llave mercantil maestro nac.	325	1	0	000098200500822
84356	000098200019916	000098200019916	2019-09-19 15:14:06.623294-04	2019-01-25	-17610	1	2		consumo tarjeta llave mercantil maestro nac.	325	1	0	000098200019916
84357	000098200700070	000098200700070	2019-09-19 15:14:06.623294-04	2019-01-25	-2650	1	2		consumo tarjeta llave mercantil maestro nac.	325	1	0	000098200700070
84358	000084405829027	000084405829027	2019-09-19 15:14:06.623294-04	2019-01-25	-30	1	2		comision pago movil interbancario	325	1	0	000084405829027
84359	000084705829027	000084705829027	2019-09-19 15:14:06.623294-04	2019-01-25	-10000	1	2		pago movil interbancario	325	1	0	000084705829027
84360	000052500907082	000052500907082	2019-09-19 15:14:06.623294-04	2019-01-25	-0.0400000000000000008	1	2		comision por recepcion servicios especiales	325	1	0	000052500907082
84361	000052300907082	000052300907082	2019-09-19 15:14:06.623294-04	2019-01-25	-400	1	2		orden de pago segun nota	325	1	0	000052300907082
84362	000052500907081	000052500907081	2019-09-19 15:14:06.623294-04	2019-01-25	-0.0400000000000000008	1	2		comision por recepcion servicios especiales	325	1	0	000052500907081
84363	000052300907081	000052300907081	2019-09-19 15:14:06.623294-04	2019-01-25	-400	1	2		orden de pago segun nota	325	1	0	000052300907081
84364	000098200399789	000098200399789	2019-09-19 15:14:06.623294-04	2019-01-25	-2980.23999999999978	1	2		consumo tarjeta llave mercantil maestro nac.	325	1	0	000098200399789
84365	000098200000381	000098200000381	2019-09-19 15:14:06.623294-04	2019-01-25	-49858.6999999999971	1	2		consumo tarjeta llave mercantil maestro nac.	325	1	0	000098200000381
84366	000084405777779	000084405777779	2019-09-19 15:14:06.623294-04	2019-01-25	-2.10000000000000009	1	2		comision pago movil interbancario	325	1	0	000084405777779
84367	000084705777779	000084705777779	2019-09-19 15:14:06.623294-04	2019-01-25	-700	1	2		pago movil interbancario	325	1	0	000084705777779
84368	000098200139921	000098200139921	2019-09-19 15:14:06.623294-04	2019-01-28	-2000	1	2		consumo tarjeta llave mercantil maestro nac.	325	1	0	000098200139921
84369	000000000000000	000000000000000	2019-09-19 15:14:06.623294-04	2019-01-28	0.140000000000000013	1	1		abono de intereses	325	1	0	000000000000000
84370	000098200689550	000098200689550	2019-09-19 15:14:06.623294-04	2019-01-28	-12600	1	2		consumo tarjeta llave mercantil maestro nac.	325	1	0	000098200689550
84371	000098200817491	000098200817491	2019-09-19 15:14:06.623294-04	2019-01-28	-1000	1	2		consumo tarjeta llave mercantil maestro nac.	325	1	0	000098200817491
84372	000098200817361	000098200817361	2019-09-19 15:14:06.623294-04	2019-01-28	-7200	1	2		consumo tarjeta llave mercantil maestro nac.	325	1	0	000098200817361
84373	000023900007290	000023900007290	2019-09-19 15:14:06.623294-04	2019-01-28	-100	1	2		recargo comision bcv res 10	325	1	0	000023900007290
84374	000052500007290	000052500007290	2019-09-19 15:14:06.623294-04	2019-01-28	-30	1	2		comision por recepcion servicios especiales	325	1	0	000052500007290
84375	000052300007290	000052300007290	2019-09-19 15:14:06.623294-04	2019-01-28	-300000	1	2		orden de pago segun nota	325	1	0	000052300007290
84376	000084405930757	000084405930757	2019-09-19 15:14:06.623294-04	2019-01-28	-24	1	2		comision pago movil interbancario	325	1	0	000084405930757
84377	000084705930757	000084705930757	2019-09-19 15:14:06.623294-04	2019-01-28	-8000	1	2		pago movil interbancario	325	1	0	000084705930757
84378	000098200932648	000098200932648	2019-09-19 15:14:06.623294-04	2019-01-28	-3690	1	2		consumo tarjeta llave mercantil maestro nac.	325	1	0	000098200932648
84379	000000000000000	000000000000000	2019-09-19 15:14:06.623294-04	2019-01-28	0.0200000000000000004	1	1		abono de intereses	325	1	0	000000000000000
84380	000098200000712	000098200000712	2019-09-19 15:14:06.623294-04	2019-01-28	-3500	1	2		consumo tarjeta llave mercantil maestro nac.	325	1	0	000098200000712
84381	000023900160932	000023900160932	2019-09-19 15:14:06.623294-04	2019-01-28	-100	1	2		recargo comision bcv res 10	325	1	0	000023900160932
84382	000052500160932	000052500160932	2019-09-19 15:14:06.623294-04	2019-01-28	-17.5	1	2		comision por recepcion servicios especiales	325	1	0	000052500160932
84383	000052300160932	000052300160932	2019-09-19 15:14:06.623294-04	2019-01-28	-175000	1	2		orden de pago segun nota	325	1	0	000052300160932
84384	000098200000778	000098200000778	2019-09-19 15:14:06.623294-04	2019-01-29	-3500	1	2		consumo tarjeta llave mercantil maestro nac.	325	1	0	000098200000778
84385	000084405227299	000084405227299	2019-09-19 15:14:06.623294-04	2019-01-29	-1.19999999999999996	1	2		comision pago movil interbancario	325	1	0	000084405227299
84386	000084705227299	000084705227299	2019-09-19 15:14:06.623294-04	2019-01-29	-400	1	2		pago movil interbancario	325	1	0	000084705227299
84387	000084405221442	000084405221442	2019-09-19 15:14:06.623294-04	2019-01-29	-15	1	2		comision pago movil interbancario	325	1	0	000084405221442
84388	000084705221442	000084705221442	2019-09-19 15:14:06.623294-04	2019-01-29	-5000	1	2		pago movil interbancario	325	1	0	000084705221442
84389	000098200784898	000098200784898	2019-09-19 15:14:06.623294-04	2019-01-29	-1000	1	2		consumo tarjeta llave mercantil maestro nac.	325	1	0	000098200784898
84390	000098200867941	000098200867941	2019-09-19 15:14:06.623294-04	2019-01-29	-3400	1	2		consumo tarjeta llave mercantil maestro nac.	325	1	0	000098200867941
84391	000098200862380	000098200862380	2019-09-19 15:14:06.623294-04	2019-01-29	-1999	1	2		consumo tarjeta llave mercantil maestro nac.	325	1	0	000098200862380
84392	000000000000000	000000000000000	2019-09-19 15:14:06.623294-04	2019-01-29	0.0100000000000000002	1	1		abono de intereses	325	1	0	000000000000000
84393	000000000000000	000000000000000	2019-09-19 15:14:06.623294-04	2019-01-30	0.0100000000000000002	1	1		abono de intereses	325	1	0	000000000000000
84394	000075001656579	000075001656579	2019-09-19 15:14:06.623294-04	2019-01-30	-1125	1	2		consumo tarjeta de pago abra 24	325	1	0	000075001656579
84395	000098200000226	000098200000226	2019-09-19 15:14:06.623294-04	2019-01-30	-1241	1	2		consumo tarjeta llave mercantil maestro nac.	325	1	0	000098200000226
84396	000084405341070	000084405341070	2019-09-19 15:14:06.623294-04	2019-01-30	-45	1	2		comision pago movil interbancario	325	1	0	000084405341070
84397	000084705341070	000084705341070	2019-09-19 15:14:06.623294-04	2019-01-30	-15000	1	2		pago movil interbancario	325	1	0	000084705341070
84398	000084705548172	000084705548172	2019-09-19 15:14:06.623294-04	2019-01-31	-1000	1	2		pago movil interbancario	325	1	0	000084705548172
84399	000098200000341	000098200000341	2019-09-19 15:14:06.623294-04	2019-01-31	-1241	1	2		consumo tarjeta llave mercantil maestro nac.	325	1	0	000098200000341
84400	000098200138854	000098200138854	2019-09-19 15:14:06.623294-04	2019-01-31	-5300	1	2		consumo tarjeta llave mercantil maestro nac.	325	1	0	000098200138854
84401	000098200155784	000098200155784	2019-09-19 15:14:06.623294-04	2019-01-31	-800	1	2		consumo tarjeta llave mercantil maestro nac.	325	1	0	000098200155784
84402	000075001042219	000075001042219	2019-09-19 15:14:06.623294-04	2019-01-31	-800	1	2		consumo tarjeta de pago abra 24	325	1	0	000075001042219
84403	000071600000000	000071600000000	2019-09-19 15:14:06.623294-04	2019-01-31	-4.83999999999999986	1	2		emision de estados de cuenta	325	1	0	000071600000000
84404	000084405548172	000084405548172	2019-09-19 15:14:06.623294-04	2019-01-31	-3	1	2		comision pago movil interbancario	325	1	0	000084405548172
84405	84705570987	84705570987	2019-09-19 15:15:27.626385-04	2019-01-02	2000	1	1	operacion	banesco pago movil	334	1	0	84705570987
84406	56327109929	56327109929	2019-09-19 15:15:27.626385-04	2019-01-02	-2300	1	2	operacion	trans.ctas	334	1	0	56327109929
84407	02099440737	02099440737	2019-09-19 15:15:27.626385-04	2019-01-02	-12500	1	2	operacion	trans.ctas	334	1	0	02099440737
84408	02103748219	02103748219	2019-09-19 15:15:27.626385-04	2019-01-03	78500	1	1	operacion	trans.ctas	334	1	0	02103748219
84409	00418551733	00418551733	2019-09-19 15:15:27.626385-04	2019-01-04	-7000	1	2	operacion	banesco pago movil	334	1	0	00418551733
84410	00418551733	00418551733	2019-09-19 15:15:27.626385-04	2019-01-04	-21	1	2	operacion	banesco pago movil	334	1	0	00418551733
84411	00418496108	00418496108	2019-09-19 15:15:27.626385-04	2019-01-04	-7000	1	2	operacion	banesco pago movil	334	1	0	00418496108
84412	00418496108	00418496108	2019-09-19 15:15:27.626385-04	2019-01-04	-21	1	2	operacion	banesco pago movil	334	1	0	00418496108
84413	00418496358	00418496358	2019-09-19 15:15:27.626385-04	2019-01-04	-15000	1	2	operacion	banesco pago movil	334	1	0	00418496358
84414	00418496358	00418496358	2019-09-19 15:15:27.626385-04	2019-01-04	-45	1	2	operacion	banesco pago movil	334	1	0	00418496358
84415	02104427876	02104427876	2019-09-19 15:15:27.626385-04	2019-01-04	-25700	1	2	operacion	trans.ctas	334	1	0	02104427876
84416	02104568339	02104568339	2019-09-19 15:15:27.626385-04	2019-01-04	-12500	1	2	operacion	trans.ctas	334	1	0	02104568339
84417	02105335406	02105335406	2019-09-19 15:15:27.626385-04	2019-01-04	64000	1	1	operacion	trans.ctas	334	1	0	02105335406
84418	00413609971	00413609971	2019-09-19 15:15:27.626385-04	2019-01-04	-15000	1	2	operacion	compra pos cta/cte	334	1	0	00413609971
84419	00457280032	00457280032	2019-09-19 15:15:27.626385-04	2019-01-04	-300	1	2	operacion	compra pos cta/cte pan de paris	334	1	0	00457280032
84420	00457280004	00457280004	2019-09-19 15:15:27.626385-04	2019-01-04	-884.100000000000023	1	2	operacion	compra pos cta/cte pan de paris	334	1	0	00457280004
84421	00578890028	00578890028	2019-09-19 15:15:27.626385-04	2019-01-07	-642	1	2	operacion	compra pos cta/cte maggies	334	1	0	00578890028
84422	00528980008	00528980008	2019-09-19 15:15:27.626385-04	2019-01-07	-350	1	2	operacion	compra pos cta/cte vanadis	334	1	0	00528980008
84423	00528980005	00528980005	2019-09-19 15:15:27.626385-04	2019-01-07	-6800	1	2	operacion	compra pos cta/cte vanadis	334	1	0	00528980005
84424	00748890053	00748890053	2019-09-19 15:15:27.626385-04	2019-01-07	-650	1	2	operacion	compra pos cta/cte soluciones catering	334	1	0	00748890053
84425	00748890051	00748890051	2019-09-19 15:15:27.626385-04	2019-01-07	-1600	1	2	operacion	compra pos cta/cte soluciones catering	334	1	0	00748890051
84426	00513984004	00513984004	2019-09-19 15:15:27.626385-04	2019-01-07	-1000	1	2	operacion	compra pos cta/cte	334	1	0	00513984004
84427	00000002523	00000002523	2019-09-19 15:15:27.626385-04	2019-01-07	-6353	1	2	operacion	compra pos cta/cte	334	1	0	00000002523
84428	00000097542	00000097542	2019-09-19 15:15:27.626385-04	2019-01-07	-1450	1	2	operacion	compra pos cta/cte	334	1	0	00000097542
84429	40001312776	40001312776	2019-09-19 15:15:27.626385-04	2019-01-07	-23654	1	2	operacion	compra pos cta/cte	334	1	0	40001312776
84430	00718715368	00718715368	2019-09-19 15:15:27.626385-04	2019-01-07	-4800	1	2	operacion	banesco pago movil	334	1	0	00718715368
84431	00518567277	00518567277	2019-09-19 15:15:27.626385-04	2019-01-07	-15000	1	2	operacion	banesco pago movil	334	1	0	00518567277
84432	00718740377	00718740377	2019-09-19 15:15:27.626385-04	2019-01-07	-20000	1	2	operacion	banesco pago movil	334	1	0	00718740377
84433	00718715368	00718715368	2019-09-19 15:15:27.626385-04	2019-01-07	-14.4000000000000004	1	2	operacion	banesco pago movil	334	1	0	00718715368
84434	00518567277	00518567277	2019-09-19 15:15:27.626385-04	2019-01-07	-45	1	2	operacion	banesco pago movil	334	1	0	00518567277
84435	00718740377	00718740377	2019-09-19 15:15:27.626385-04	2019-01-07	-60	1	2	operacion	banesco pago movil	334	1	0	00718740377
84436	02109530045	02109530045	2019-09-19 15:15:27.626385-04	2019-01-07	111100	1	1	operacion	trans.ctas	334	1	0	02109530045
84437	02108299285	02108299285	2019-09-19 15:15:27.626385-04	2019-01-07	105000	1	1	operacion	trans.ctas a tercero en banesco	334	1	0	02108299285
84438	02105830548	02105830548	2019-09-19 15:15:27.626385-04	2019-01-07	-24000	1	2	operacion	trans.ctas	334	1	0	02105830548
84439	02109534875	02109534875	2019-09-19 15:15:27.626385-04	2019-01-07	-110000	1	2	operacion	trans.ctas	334	1	0	02109534875
84440	28335442929	28335442929	2019-09-19 15:15:27.626385-04	2019-01-08	-20000	1	2	operacion	trf transfer/otros bancos     0115	334	1	0	28335442929
84441	28335442929	28335442929	2019-09-19 15:15:27.626385-04	2019-01-08	-2	1	2	operacion	comision trf otros bcos	334	1	0	28335442929
84442	28335442929	28335442929	2019-09-19 15:15:27.626385-04	2019-01-08	-100	1	2	operacion	cce/recargo tx alto valor	334	1	0	28335442929
84443	00857280033	00857280033	2019-09-19 15:15:27.626385-04	2019-01-08	-800	1	2	operacion	compra pos cta/cte pan de paris	334	1	0	00857280033
84444	00872790019	00872790019	2019-09-19 15:15:27.626385-04	2019-01-08	-912	1	2	operacion	compra pos cta/cte hogar plaza	334	1	0	00872790019
84553	0	0	2019-09-19 15:15:51.413458-04	2019-08-01	-296	1	2	operacion	comi. envio estado de cuenta	327	1	0	0
84445	00857280082	00857280082	2019-09-19 15:15:27.626385-04	2019-01-08	-800	1	2	operacion	compra pos cta/cte pan de paris	334	1	0	00857280082
84446	40001064374	40001064374	2019-09-19 15:15:27.626385-04	2019-01-08	-5626.5	1	2	operacion	compra pos cta/cte	334	1	0	40001064374
84447	40001480280	40001480280	2019-09-19 15:15:27.626385-04	2019-01-08	-1500	1	2	operacion	compra pos cta/cte	334	1	0	40001480280
84448	00823750046	00823750046	2019-09-19 15:15:27.626385-04	2019-01-08	-4199.25	1	2	operacion	compra pos cta/cte inversiones awm	334	1	0	00823750046
84449	00823494739	00823494739	2019-09-19 15:15:27.626385-04	2019-01-08	-950	1	2	operacion	compra pos cta/cte	334	1	0	00823494739
84450	00919010849	00919010849	2019-09-19 15:15:27.626385-04	2019-01-09	-500	1	2	operacion	banesco pago movil	334	1	0	00919010849
84451	00919010849	00919010849	2019-09-19 15:15:27.626385-04	2019-01-09	-1.5	1	2	operacion	banesco pago movil	334	1	0	00919010849
84452	00914358191	00914358191	2019-09-19 15:15:27.626385-04	2019-01-09	-4248	1	2	operacion	compra pos cta/cte	334	1	0	00914358191
84453	00917335943	00917335943	2019-09-19 15:15:27.626385-04	2019-01-09	-575	1	2	operacion	compra pos cta/cte	334	1	0	00917335943
84454	00948890048	00948890048	2019-09-19 15:15:27.626385-04	2019-01-09	-2450	1	2	operacion	compra pos cta/cte soluciones catering	334	1	0	00948890048
84455	00972790047	00972790047	2019-09-19 15:15:27.626385-04	2019-01-09	-642	1	2	operacion	compra pos cta/cte hogar plaza	334	1	0	00972790047
84456	00920331382	00920331382	2019-09-19 15:15:27.626385-04	2019-01-09	-450	1	2	operacion	compra pos cta/cte	334	1	0	00920331382
84457	00978890027	00978890027	2019-09-19 15:15:27.626385-04	2019-01-09	-8991	1	2	operacion	compra pos cta/cte maggies	334	1	0	00978890027
84458	00188610398	00188610398	2019-09-19 15:15:27.626385-04	2019-01-10	-478.600000000000023	1	2	operacion	movistar cargo c/cta.	334	1	0	00188610398
84459	01012678693	01012678693	2019-09-19 15:15:27.626385-04	2019-01-10	-525	1	2	operacion	compra pos cta/cte	334	1	0	01012678693
84460	01072050030	01072050030	2019-09-19 15:15:27.626385-04	2019-01-10	-2200	1	2	operacion	compra pos cta/cte est servicios los rob	334	1	0	01072050030
84461	01078890119	01078890119	2019-09-19 15:15:27.626385-04	2019-01-10	-642	1	2	operacion	compra pos cta/cte maggies	334	1	0	01078890119
84462	01119266959	01119266959	2019-09-19 15:15:27.626385-04	2019-01-11	-22000	1	2	operacion	banesco pago movil	334	1	0	01119266959
84463	01119266959	01119266959	2019-09-19 15:15:27.626385-04	2019-01-11	-66	1	2	operacion	banesco pago movil	334	1	0	01119266959
84464	02118008007	02118008007	2019-09-19 15:15:27.626385-04	2019-01-11	24500	1	1	operacion	trans.ctas	334	1	0	02118008007
84465	01172790007	01172790007	2019-09-19 15:15:27.626385-04	2019-01-11	-280	1	2	operacion	compra pos cta/cte hogar plaza	334	1	0	01172790007
84466	01172790038	01172790038	2019-09-19 15:15:27.626385-04	2019-01-11	-724	1	2	operacion	compra pos cta/cte hogar plaza	334	1	0	01172790038
84467	01120335023	01120335023	2019-09-19 15:15:27.626385-04	2019-01-11	-1150	1	2	operacion	compra pos cta/cte	334	1	0	01120335023
84468	84705545687	84705545687	2019-09-19 15:15:27.626385-04	2019-01-14	2000	1	1	operacion	banesco pago movil	334	1	0	84705545687
84469	01419586556	01419586556	2019-09-19 15:15:27.626385-04	2019-01-14	-25000	1	2	operacion	banesco pago movil	334	1	0	01419586556
84470	01419586556	01419586556	2019-09-19 15:15:27.626385-04	2019-01-14	-75	1	2	operacion	banesco pago movil	334	1	0	01419586556
84471	01419586617	01419586617	2019-09-19 15:15:27.626385-04	2019-01-14	-4500	1	2	operacion	banesco pago movil	334	1	0	01419586617
84472	01419586617	01419586617	2019-09-19 15:15:27.626385-04	2019-01-14	-13.5	1	2	operacion	banesco pago movil	334	1	0	01419586617
84473	01419586711	01419586711	2019-09-19 15:15:27.626385-04	2019-01-14	-500	1	2	operacion	banesco pago movil	334	1	0	01419586711
84474	01419586711	01419586711	2019-09-19 15:15:27.626385-04	2019-01-14	-1.5	1	2	operacion	banesco pago movil	334	1	0	01419586711
84475	01219410111	01219410111	2019-09-19 15:15:27.626385-04	2019-01-14	-2.41999999999999993	1	2	operacion	com. banesco pago movil	334	1	0	01219410111
84476	01219410154	01219410154	2019-09-19 15:15:27.626385-04	2019-01-14	-550	1	2	operacion	banesco pago movil	334	1	0	01219410154
84477	01219410154	01219410154	2019-09-19 15:15:27.626385-04	2019-01-14	-1.64999999999999991	1	2	operacion	banesco pago movil	334	1	0	01219410154
84478	02123164465	02123164465	2019-09-19 15:15:27.626385-04	2019-01-14	230000	1	1	operacion	trans.ctas	334	1	0	02123164465
84479	02123225085	02123225085	2019-09-19 15:15:27.626385-04	2019-01-14	-7759.35999999999967	1	2	operacion	trans.ctas	334	1	0	02123225085
84480	01214070130	01214070130	2019-09-19 15:15:27.626385-04	2019-01-14	-1100	1	2	operacion	compra pos cta/cte	334	1	0	01214070130
84481	40001208628	40001208628	2019-09-19 15:15:27.626385-04	2019-01-14	-1000	1	2	operacion	compra pos cta/cte	334	1	0	40001208628
84482	01219174026	01219174026	2019-09-19 15:15:27.626385-04	2019-01-14	-1700	1	2	operacion	compra pos cta/cte	334	1	0	01219174026
84483	01478890042	01478890042	2019-09-19 15:15:27.626385-04	2019-01-14	-784	1	2	operacion	compra pos cta/cte maggies	334	1	0	01478890042
84484	01405460099	01405460099	2019-09-19 15:15:27.626385-04	2019-01-14	-3970	1	2	operacion	compra pos cta/cte prolicor pampatar	334	1	0	01405460099
84485	01405460100	01405460100	2019-09-19 15:15:27.626385-04	2019-01-14	-970	1	2	operacion	compra pos cta/cte prolicor pampatar	334	1	0	01405460100
84486	02952623593	02952623593	2019-09-19 15:15:27.626385-04	2019-01-15	-14.2899999999999991	1	2	operacion	pago cantv	334	1	0	02952623593
84487	02952627091	02952627091	2019-09-19 15:15:27.626385-04	2019-01-15	-14.2200000000000006	1	2	operacion	pago cantv	334	1	0	02952627091
84488	01519636220	01519636220	2019-09-19 15:15:27.626385-04	2019-01-15	-5000	1	2	operacion	banesco pago movil	334	1	0	01519636220
84489	01519636220	01519636220	2019-09-19 15:15:27.626385-04	2019-01-15	-15	1	2	operacion	banesco pago movil	334	1	0	01519636220
84490	01519619854	01519619854	2019-09-19 15:15:27.626385-04	2019-01-15	-20000	1	2	operacion	banesco pago movil	334	1	0	01519619854
84491	01519619854	01519619854	2019-09-19 15:15:27.626385-04	2019-01-15	-60	1	2	operacion	banesco pago movil	334	1	0	01519619854
84492	01519625026	01519625026	2019-09-19 15:15:27.626385-04	2019-01-15	-5000	1	2	operacion	banesco pago movil	334	1	0	01519625026
84493	01519625026	01519625026	2019-09-19 15:15:27.626385-04	2019-01-15	-15	1	2	operacion	banesco pago movil	334	1	0	01519625026
84494	40001433624	40001433624	2019-09-19 15:15:27.626385-04	2019-01-15	-45000	1	2	operacion	compra pos cta/cte	334	1	0	40001433624
84495	01557280005	01557280005	2019-09-19 15:15:27.626385-04	2019-01-15	-2375	1	2	operacion	compra pos cta/cte pan de paris	334	1	0	01557280005
84496	10744921641	10744921641	2019-09-19 15:15:27.626385-04	2019-01-16	-508.300000000000011	1	2	operacion	ptc pago tdc otros bancos     0116	334	1	0	10744921641
84497	10744921641	10744921641	2019-09-19 15:15:27.626385-04	2019-01-16	-0.0500000000000000028	1	2	operacion	comision ptc otros bcos	334	1	0	10744921641
84498	10744658893	10744658893	2019-09-19 15:15:27.626385-04	2019-01-16	-508.300000000000011	1	2	operacion	ptc pago tdc otros bancos     0116	334	1	0	10744658893
84499	10744658893	10744658893	2019-09-19 15:15:27.626385-04	2019-01-16	-0.0500000000000000028	1	2	operacion	comision ptc otros bcos	334	1	0	10744658893
84500	10744675788	10744675788	2019-09-19 15:15:27.626385-04	2019-01-16	-508.300000000000011	1	2	operacion	ptc pago tdc otros bancos     0116	334	1	0	10744675788
84501	10744675788	10744675788	2019-09-19 15:15:27.626385-04	2019-01-16	-0.0500000000000000028	1	2	operacion	comision ptc otros bcos	334	1	0	10744675788
84502	23451592929	23451592929	2019-09-19 15:15:27.626385-04	2019-01-16	-35000	1	2	operacion	trf transfer/otros bancos     0115	334	1	0	23451592929
84503	23451592929	23451592929	2019-09-19 15:15:27.626385-04	2019-01-16	-3.5	1	2	operacion	comision trf otros bcos	334	1	0	23451592929
84504	23451592929	23451592929	2019-09-19 15:15:27.626385-04	2019-01-16	-100	1	2	operacion	cce/recargo tx alto valor	334	1	0	23451592929
84505	01628260004	01628260004	2019-09-19 15:15:27.626385-04	2019-01-16	-600	1	2	operacion	compra pos cta/cte pasteleria charlies	334	1	0	01628260004
84506	01612603817	01612603817	2019-09-19 15:15:27.626385-04	2019-01-16	-1150	1	2	operacion	compra pos cta/cte	334	1	0	01612603817
84507	01624530118	01624530118	2019-09-19 15:15:27.626385-04	2019-01-16	-6935	1	2	operacion	compra pos cta/cte fressier	334	1	0	01624530118
84508	01621830999	01621830999	2019-09-19 15:15:27.626385-04	2019-01-16	-2872.96000000000004	1	2	operacion	compra pos cta/cte	334	1	0	01621830999
84509	10751757933	10751757933	2019-09-19 15:15:27.626385-04	2019-01-17	-10000	1	2	operacion	trf transfer/otros bancos     0174	334	1	0	10751757933
84510	10751757933	10751757933	2019-09-19 15:15:27.626385-04	2019-01-17	-1	1	2	operacion	comision trf otros bcos	334	1	0	10751757933
84511	84705985428	84705985428	2019-09-19 15:15:27.626385-04	2019-01-17	15000	1	1	operacion	banesco pago movil	334	1	0	84705985428
84512	01719875599	01719875599	2019-09-19 15:15:27.626385-04	2019-01-17	-250	1	2	operacion	banesco pago movil	334	1	0	01719875599
84513	01719875599	01719875599	2019-09-19 15:15:27.626385-04	2019-01-17	-0.75	1	2	operacion	banesco pago movil	334	1	0	01719875599
84514	39927655929	39927655929	2019-09-19 15:15:27.626385-04	2019-01-17	-33650	1	2	operacion	trans.ctas	334	1	0	39927655929
84515	01712260004	01712260004	2019-09-19 15:15:27.626385-04	2019-01-17	-28500	1	2	operacion	compra pos cta/cte solovision	334	1	0	01712260004
84516	84705116488	84705116488	2019-09-19 15:15:27.626385-04	2019-01-18	15000	1	1	operacion	banesco pago movil	334	1	0	84705116488
84517	02137045016	02137045016	2019-09-19 15:15:27.626385-04	2019-01-21	55000	1	1	operacion	trans.ctas	334	1	0	02137045016
84518	02120458568	02120458568	2019-09-19 15:15:27.626385-04	2019-01-21	-1900	1	2	operacion	compra pos cta/cte	334	1	0	02120458568
84519	21206669929	21206669929	2019-09-19 15:15:27.626385-04	2019-01-22	-30000	1	2	operacion	trf transfer/otros bancos     0115	334	1	0	21206669929
84520	21206669929	21206669929	2019-09-19 15:15:27.626385-04	2019-01-22	-3	1	2	operacion	comision trf otros bcos	334	1	0	21206669929
84521	21206669929	21206669929	2019-09-19 15:15:27.626385-04	2019-01-22	-100	1	2	operacion	cce/recargo tx alto valor	334	1	0	21206669929
84522	02220292636	02220292636	2019-09-19 15:15:27.626385-04	2019-01-22	-350	1	2	operacion	banesco pago movil	334	1	0	02220292636
84523	02220292636	02220292636	2019-09-19 15:15:27.626385-04	2019-01-22	-1.05000000000000004	1	2	operacion	banesco pago movil	334	1	0	02220292636
84524	02320437544	02320437544	2019-09-19 15:15:27.626385-04	2019-01-23	-600	1	2	operacion	banesco pago movil	334	1	0	02320437544
84525	02320422903	02320422903	2019-09-19 15:15:27.626385-04	2019-01-23	-500	1	2	operacion	banesco pago movil	334	1	0	02320422903
84526	02372050015	02372050015	2019-09-19 15:15:27.626385-04	2019-01-23	-2200	1	2	operacion	compra pos cta/cte est servicios los rob	334	1	0	02372050015
84527	00000115774	00000115774	2019-09-19 15:15:27.626385-04	2019-01-25	100000	1	1	operacion	trf desde otro bco  00000000000000761564 0105	334	1	0	00000115774
84528	02820937077	02820937077	2019-09-19 15:15:27.626385-04	2019-01-28	-30000	1	2	operacion	banesco pago movil	334	1	0	02820937077
84529	02820937077	02820937077	2019-09-19 15:15:27.626385-04	2019-01-28	-90	1	2	operacion	banesco pago movil	334	1	0	02820937077
84530	02672790049	02672790049	2019-09-19 15:15:27.626385-04	2019-01-28	-3861	1	2	operacion	compra pos cta/cte hogar plaza	334	1	0	02672790049
84531	02814597731	02814597731	2019-09-19 15:15:27.626385-04	2019-01-28	-500	1	2	operacion	compra pos cta/cte	334	1	0	02814597731
84532	02921057358	02921057358	2019-09-19 15:15:27.626385-04	2019-01-29	-30000	1	2	operacion	banesco pago movil	334	1	0	02921057358
84533	02921057358	02921057358	2019-09-19 15:15:27.626385-04	2019-01-29	-90	1	2	operacion	banesco pago movil	334	1	0	02921057358
84534	02151475233	02151475233	2019-09-19 15:15:27.626385-04	2019-01-29	-50911.3300000000017	1	2	operacion	trans.ctas	334	1	0	02151475233
84535	02912882560	02912882560	2019-09-19 15:15:27.626385-04	2019-01-29	-500	1	2	operacion	compra pos cta/cte	334	1	0	02912882560
84536	02972050051	02972050051	2019-09-19 15:15:27.626385-04	2019-01-29	-3200	1	2	operacion	compra pos cta/cte est servicios los rob	334	1	0	02972050051
84537	84705341070	84705341070	2019-09-19 15:15:27.626385-04	2019-01-30	15000	1	1	operacion	banesco pago movil	334	1	0	84705341070
84538	03021297865	03021297865	2019-09-19 15:15:27.626385-04	2019-01-30	-500	1	2	operacion	banesco pago movil	334	1	0	03021297865
84539	03021297865	03021297865	2019-09-19 15:15:27.626385-04	2019-01-30	-1.5	1	2	operacion	banesco pago movil	334	1	0	03021297865
84540	03021283394	03021283394	2019-09-19 15:15:27.626385-04	2019-01-30	-3000	1	2	operacion	banesco pago movil	334	1	0	03021283394
84541	02153741862	02153741862	2019-09-19 15:15:27.626385-04	2019-01-30	-30000	1	2	operacion	trans.ctas	334	1	0	02153741862
84542	03121389130	03121389130	2019-09-19 15:15:27.626385-04	2019-01-31	-30000	1	2	operacion	banesco pago movil	334	1	0	03121389130
84543	03121389130	03121389130	2019-09-19 15:15:27.626385-04	2019-01-31	-90	1	2	operacion	banesco pago movil	334	1	0	03121389130
84544	02156183145	02156183145	2019-09-19 15:15:27.626385-04	2019-01-31	300000	1	1	operacion	trans.ctas	334	1	0	02156183145
84545	02157086977	02157086977	2019-09-19 15:15:27.626385-04	2019-01-31	-40000	1	2	operacion	trans.ctas	334	1	0	02157086977
84546	00000000000	00000000000	2019-09-19 15:15:27.626385-04	2019-01-31	-0.170000000000000012	1	2	operacion	intereses por sobregiro	334	1	0	00000000000
84547	00000000000	00000000000	2019-09-19 15:15:27.626385-04	2019-01-31	-2.41999999999999993	1	2	operacion	com.serv.mtto cta	334	1	0	00000000000
84548	00000000000	00000000000	2019-09-19 15:15:27.626385-04	2019-01-31	-4.83999999999999986	1	2	operacion	emision de estado de cuenta	334	1	0	00000000000
84549	00000000000	00000000000	2019-09-19 15:15:27.626385-04	2019-01-31	0.510000000000000009	1	1	operacion	intereses	334	1	0	00000000000
84550	03119277959	03119277959	2019-09-19 15:15:27.626385-04	2019-01-31	-10695	1	2	operacion	compra pos cta/cte	334	1	0	03119277959
84551	03119985260	03119985260	2019-09-19 15:15:27.626385-04	2019-01-31	-3000	1	2	operacion	compra pos cta/cte	334	1	0	03119985260
84552	00000000403	00000000403	2019-09-19 15:15:27.626385-04	2019-01-31	-3760	1	2	operacion	compra pos cta/cte	334	1	0	00000000403
84554	0	0	2019-09-19 15:15:51.413458-04	2019-07-31	-833	1	2	operacion	comision de mantenimiento de c	327	1	0	0
84555	0	0	2019-09-19 15:15:51.413458-04	2019-03-29	-185.430000000000007	1	2	operacion	comision de mantenimiento de c	327	1	0	0
84556	0	0	2019-09-19 15:15:51.413458-04	2019-03-22	-51.9200000000000017	1	2	operacion	c.comi.env.edo.cta  c 22/03/19	327	1	0	0
84557	217970564	217970564	2019-09-19 15:15:51.413458-04	2019-03-20	-1500	1	2	operacion	pago tarj credito internet	327	1	0	217970564
84558	0	0	2019-09-19 15:15:51.413458-04	2019-03-01	-12.0800000000000001	1	2	operacion	comi. envio estado de cuenta	327	1	0	0
84559	0	0	2019-09-19 15:15:51.413458-04	2019-04-30	-833	1	2	operacion	comision de mantenimiento de c	327	1	0	0
84560	230102353	230102353	2019-09-19 15:15:51.413458-04	2019-04-25	-35	1	2	operacion	comision por transferencia	327	1	0	230102353
84561	230102353	230102353	2019-09-19 15:15:51.413458-04	2019-04-25	-35000	1	2	operacion	te0230102353transf.banesco ban	327	1	0	230102353
84562	229546621	229546621	2019-09-19 15:15:51.413458-04	2019-04-24	-11308.2600000000002	1	2	operacion	pago tarj credito internet	327	1	0	229546621
84563	0	0	2019-09-19 15:15:51.413458-04	2019-04-24	-296	1	2	operacion	comision envio estado de cta.	327	1	0	0
84564	0	0	2019-09-19 15:15:51.413458-04	2019-04-24	-647.57000000000005	1	2	operacion	comision de mantenimiento de c	327	1	0	0
84565	66767	66767	2019-09-19 15:15:51.413458-04	2019-04-24	50000	1	1	operacion	cr cce tran:banco mercantil	327	1	0	66767
84578	02478510465	02478510465	2019-09-23 18:33:55.379459-04	2019-08-01	9315002	1	1	operacion	trf.mb 0134 j400941300 d2 internacional  0689	338	5	0	02478510465
84579	02478571518	02478571518	2019-09-23 18:33:55.379459-04	2019-08-01	-1300000	1	2	operacion	trf.mb 0134 v011931237 quevedo martinez  0689	338	5	0	02478571518
84580	02478667130	02478667130	2019-09-23 18:33:55.379459-04	2019-08-01	-122000	1	2	operacion	trf.mb 0134 j313340189 grupo inmobiliari 0689	338	5	0	02478667130
84581	04167969171	04167969171	2019-09-23 18:33:55.379459-04	2019-08-02	-10000	1	2	operacion	pago cantv	338	5	0	04167969171
84582	21460370456	21460370456	2019-09-23 18:33:55.379459-04	2019-08-02	-500000	1	2	operacion	banesco pago movil	338	5	0	21460370456
84583	21460370456	21460370456	2019-09-23 18:33:55.379459-04	2019-08-02	-1500	1	2	operacion	banesco pago movil	338	5	0	21460370456
84584	21460248559	21460248559	2019-09-23 18:33:55.379459-04	2019-08-02	-640000	1	2	operacion	banesco pago movil	338	5	0	21460248559
84585	21460248559	21460248559	2019-09-23 18:33:55.379459-04	2019-08-02	-1920	1	2	operacion	banesco pago movil	338	5	0	21460248559
84586	21460086660	21460086660	2019-09-23 18:33:55.379459-04	2019-08-02	-200000	1	2	operacion	banesco pago movil	338	5	0	21460086660
84587	21460086660	21460086660	2019-09-23 18:33:55.379459-04	2019-08-02	-600	1	2	operacion	banesco pago movil	338	5	0	21460086660
84588	02481574231	02481574231	2019-09-23 18:33:55.379459-04	2019-08-02	-868000	1	2	operacion	trf.mb 0134 v016540700 martinez maldonad 0689	338	5	0	02481574231
84589	02481660868	02481660868	2019-09-23 18:33:55.379459-04	2019-08-02	-424068.159999999974	1	2	operacion	trf.mb 0134 j002314761 multipiscina c.a. 0689	338	5	0	02481660868
84590	02481799762	02481799762	2019-09-23 18:33:55.379459-04	2019-08-02	-36000	1	2	operacion	trf.mb 0134 v017408602 brito sanchez eri 0689	338	5	0	02481799762
84591	02480657987	02480657987	2019-09-23 18:33:55.379459-04	2019-08-02	-1300000	1	2	operacion	trf.mb 0134 v011931237 quevedo martinez  0689	338	5	0	02480657987
84592	02480685235	02480685235	2019-09-23 18:33:55.379459-04	2019-08-02	-490700.090000000026	1	2	operacion	trf.mb 0134 j303624731 conjunto parque r 0689	338	5	0	02480685235
84593	02480927167	02480927167	2019-09-23 18:33:55.379459-04	2019-08-02	-550000	1	2	operacion	trf.mb 0134 j297520902 lubri express, c. 0689	338	5	0	02480927167
84594	21761021583	21761021583	2019-09-23 18:33:55.379459-04	2019-08-05	-12000	1	2	operacion	banesco pago movil	338	5	0	21761021583
84595	21760995247	21760995247	2019-09-23 18:33:55.379459-04	2019-08-05	-2000	1	2	operacion	banesco pago movil	338	5	0	21760995247
84596	21761134642	21761134642	2019-09-23 18:33:55.379459-04	2019-08-05	-500000	1	2	operacion	banesco pago movil	338	5	0	21761134642
84597	21761134642	21761134642	2019-09-23 18:33:55.379459-04	2019-08-05	-1500	1	2	operacion	banesco pago movil	338	5	0	21761134642
84598	02482810981	02482810981	2019-09-23 18:33:55.379459-04	2019-08-05	-1280000	1	2	operacion	trf.mb 0134 v015005360 mateus menichilli 0689	338	5	0	02482810981
84599	02483885450	02483885450	2019-09-23 18:33:55.379459-04	2019-08-05	-540000	1	2	operacion	trf.mb 0134 v023590660 gonzalez rodrigue 0689	338	5	0	02483885450
84600	55923323929	55923323929	2019-09-23 18:33:55.379459-04	2019-08-05	-40000	1	2	operacion	trf.mb 0134 v013668736 fuentes guevara m 0689	338	5	0	55923323929
84601	11390476067	11390476067	2019-09-23 18:33:55.379459-04	2019-08-06	-155000	1	2	operacion	trf.ob 0174 j296370524 nostrum group ca 0689	338	5	0	11390476067
84602	11390476067	11390476067	2019-09-23 18:33:55.379459-04	2019-08-06	-155	1	2	operacion	comision trf otros bcos	338	5	0	11390476067
84603	21861424663	21861424663	2019-09-23 18:33:55.379459-04	2019-08-06	-400000	1	2	operacion	banesco pago movil	338	5	0	21861424663
84604	21861424663	21861424663	2019-09-23 18:33:55.379459-04	2019-08-06	-1200	1	2	operacion	banesco pago movil	338	5	0	21861424663
84605	74339520517	74339520517	2019-09-23 18:33:55.379459-04	2019-08-09	256000	1	1	operacion	banesco pago movil	338	5	0	74339520517
84606	00000003561	00000003561	2019-09-23 18:33:55.379459-04	2019-08-09	135000	1	1	operacion	banesco pago movil	338	5	0	00000003561
84607	22162942299	22162942299	2019-09-23 18:33:55.379459-04	2019-08-09	-150000	1	2	operacion	banesco pago movil	338	5	0	22162942299
84608	22162942299	22162942299	2019-09-23 18:33:55.379459-04	2019-08-09	-450	1	2	operacion	banesco pago movil	338	5	0	22162942299
84609	02492128181	02492128181	2019-09-23 18:33:55.379459-04	2019-08-09	-256000	1	2	operacion	trf.mb 0134 v009302000 villamizar luis j 0689	338	5	0	02492128181
84610	84722586394	84722586394	2019-09-23 18:33:55.379459-04	2019-08-12	202500	1	1	operacion	banesco pago movil	338	5	0	84722586394
84611	02495181606	02495181606	2019-09-23 18:33:55.379459-04	2019-08-12	-202500	1	2	operacion	trf.mb 0134 v011437061 castillo marcos j 0689	338	5	0	02495181606
84612	00000312120	00000312120	2019-09-23 18:33:55.379459-04	2019-08-14	1000	1	1	operacion	trf.ob 0105 v012506929 bossio grimaldi b 0689	338	5	0	00000312120
84613	22765133237	22765133237	2019-09-23 18:33:55.379459-04	2019-08-15	-1500000	1	2	operacion	banesco pago movil	338	5	0	22765133237
84614	22765133237	22765133237	2019-09-23 18:33:55.379459-04	2019-08-15	-4500	1	2	operacion	banesco pago movil	338	5	0	22765133237
84615	22765133597	22765133597	2019-09-23 18:33:55.379459-04	2019-08-15	-500000	1	2	operacion	banesco pago movil	338	5	0	22765133597
84616	22765133597	22765133597	2019-09-23 18:33:55.379459-04	2019-08-15	-1500	1	2	operacion	banesco pago movil	338	5	0	22765133597
84617	02501248052	02501248052	2019-09-23 18:33:55.379459-04	2019-08-15	5000000	1	1	operacion	trf.mb 0134 j400941300 d2 internacional  0689	338	5	0	02501248052
84618	02501437868	02501437868	2019-09-23 18:33:55.379459-04	2019-08-15	-643500	1	2	operacion	trf.mb 0134 v017408602 brito sanchez eri 0689	338	5	0	02501437868
84619	22865914595	22865914595	2019-09-23 18:33:55.379459-04	2019-08-16	-30000	1	2	operacion	banesco pago movil	338	5	0	22865914595
84620	22865914595	22865914595	2019-09-23 18:33:55.379459-04	2019-08-16	-90	1	2	operacion	banesco pago movil	338	5	0	22865914595
84621	22865456855	22865456855	2019-09-23 18:33:55.379459-04	2019-08-16	-4000	1	2	operacion	banesco pago movil	338	5	0	22865456855
84622	02503727451	02503727451	2019-09-23 18:33:55.379459-04	2019-08-16	-45000	1	2	operacion	trf.mb 0134 v013668736 fuentes guevara m 0689	338	5	0	02503727451
84623	60735102929	60735102929	2019-09-23 18:33:55.379459-04	2019-08-16	-87600	1	2	operacion	trf.mb 0134 j313340189 grupo inmobiliari 0689	338	5	0	60735102929
84624	23166647775	23166647775	2019-09-23 18:33:55.379459-04	2019-08-20	-85000	1	2	operacion	banesco pago movil	338	5	0	23166647775
84625	23166647775	23166647775	2019-09-23 18:33:55.379459-04	2019-08-20	-255	1	2	operacion	banesco pago movil	338	5	0	23166647775
84626	22966264702	22966264702	2019-09-23 18:33:55.379459-04	2019-08-20	-300000	1	2	operacion	banesco pago movil	338	5	0	22966264702
84627	22966264702	22966264702	2019-09-23 18:33:55.379459-04	2019-08-20	-900	1	2	operacion	banesco pago movil	338	5	0	22966264702
84628	22966264894	22966264894	2019-09-23 18:33:55.379459-04	2019-08-20	-300000	1	2	operacion	banesco pago movil	338	5	0	22966264894
84629	22966264894	22966264894	2019-09-23 18:33:55.379459-04	2019-08-20	-900	1	2	operacion	banesco pago movil	338	5	0	22966264894
84630	89701899929	89701899929	2019-09-23 18:33:55.379459-04	2019-08-20	-750000	1	2	operacion	trf.mb 0134 v011931237 quevedo martinez  0689	338	5	0	89701899929
84631	80225187929	80225187929	2019-09-23 18:33:55.379459-04	2019-08-20	-750000	1	2	operacion	trf.mb 0134 v011931237 quevedo martinez  0689	338	5	0	80225187929
84632	02514952923	02514952923	2019-09-23 18:33:55.379459-04	2019-08-23	2779500	1	1	operacion	trf.mb 0134 v009094694 muÑoz nancy janet 0689	338	5	0	02514952923
84633	02514973377	02514973377	2019-09-23 18:33:55.379459-04	2019-08-23	-2720000	1	2	operacion	trf.mb 0134 v012886858 fernandez castill 0689	338	5	0	02514973377
84634	84723225858	84723225858	2019-09-23 18:33:55.379459-04	2019-08-26	50000	1	1	operacion	banesco pago movil	338	5	0	84723225858
84635	34842818929	34842818929	2019-09-23 18:33:55.379459-04	2019-08-26	-100000	1	2	operacion	trf.mb 0134 v013668736 fuentes guevara m 0689	338	5	0	34842818929
84636	84723235276	84723235276	2019-09-23 18:33:55.379459-04	2019-08-27	90000	1	1	operacion	banesco pago movil	338	5	0	84723235276
84637	15905683929	15905683929	2019-09-23 18:33:55.379459-04	2019-08-27	-90000	1	2	operacion	trf.mb 0134 v011931237 quevedo martinez  0689	338	5	0	15905683929
84638	92400189304	92400189304	2019-09-23 18:33:55.379459-04	2019-08-28	-2000000	1	2	operacion	banesco pago movil	338	5	0	92400189304
84639	92400189304	92400189304	2019-09-23 18:33:55.379459-04	2019-08-28	-6000	1	2	operacion	banesco pago movil	338	5	0	92400189304
84640	92400486476	92400486476	2019-09-23 18:33:55.379459-04	2019-08-28	-37000	1	2	operacion	banesco pago movil	338	5	0	92400486476
84641	92400486476	92400486476	2019-09-23 18:33:55.379459-04	2019-08-28	-111	1	2	operacion	banesco pago movil	338	5	0	92400486476
84642	02520791949	02520791949	2019-09-23 18:33:55.379459-04	2019-08-28	10000000	1	1	operacion	trf.mb 0134 j400941300 d2 internacional  0689	338	5	0	02520791949
84643	02520811145	02520811145	2019-09-23 18:33:55.379459-04	2019-08-28	-500000	1	2	operacion	trf.mb 0134 v017408602 brito sanchez eri 0689	338	5	0	02520811145
84644	02520824551	02520824551	2019-09-23 18:33:55.379459-04	2019-08-28	-67997.679999999993	1	2	operacion	trf.mb 0134 j403888680 tecno occidente 2 0689	338	5	0	02520824551
84645	02520886396	02520886396	2019-09-23 18:33:55.379459-04	2019-08-28	-860000	1	2	operacion	trf.mb 0134 v018059198 colmenarez carruy 0689	338	5	0	02520886396
84646	02521257898	02521257898	2019-09-23 18:33:55.379459-04	2019-08-28	-6540000	1	2	operacion	trf.mb 0134 j313340189 grupo inmobiliari 0689	338	5	0	02521257898
84647	00000000000	00000000000	2019-09-23 18:33:55.379459-04	2019-08-30	-60	1	2	operacion	com.serv.mtto cta	338	5	0	00000000000
84648	00000000000	00000000000	2019-09-23 18:33:55.379459-04	2019-08-30	-120	1	2	operacion	emision de estado de cuenta	338	5	0	00000000000
84649	00000000000	00000000000	2019-09-23 18:33:55.379459-04	2019-08-30	8.01999999999999957	1	1	operacion	intereses	338	5	0	00000000000
84650	92452219718	92452219718	2019-09-23 18:33:55.379459-04	2019-09-02	-4000	1	2	operacion	banesco pago movil	338	5	0	92452219718
84651	92452007987	92452007987	2019-09-23 18:33:55.379459-04	2019-09-02	-35000	1	2	operacion	banesco pago movil	338	5	0	92452007987
84652	92451933286	92451933286	2019-09-23 18:33:55.379459-04	2019-09-02	-1000000	1	2	operacion	banesco pago movil	338	5	0	92451933286
84653	92451933286	92451933286	2019-09-23 18:33:55.379459-04	2019-09-02	-3000	1	2	operacion	banesco pago movil	338	5	0	92451933286
84654	92451933604	92451933604	2019-09-23 18:33:55.379459-04	2019-09-02	-200000	1	2	operacion	banesco pago movil	338	5	0	92451933604
84655	92451933604	92451933604	2019-09-23 18:33:55.379459-04	2019-09-02	-600	1	2	operacion	banesco pago movil	338	5	0	92451933604
84656	02528300069	02528300069	2019-09-23 18:33:55.379459-04	2019-09-02	5192938	1	1	operacion	trf.mb 0134 j400941300 d2 internacional  0689	338	5	0	02528300069
84657	02529297800	02529297800	2019-09-23 18:33:55.379459-04	2019-09-02	-1225000	1	2	operacion	trf.mb 0134 j313340189 grupo inmobiliari 0689	338	5	0	02529297800
84658	02529305308	02529305308	2019-09-23 18:33:55.379459-04	2019-09-02	-2450000	1	2	operacion	trf.mb 0134 v011931237 quevedo martinez  0689	338	5	0	02529305308
84659	02527043092	02527043092	2019-09-23 18:33:55.379459-04	2019-09-02	100000	1	1	operacion	trf.mb 0134 v011931237 quevedo martinez  0689	338	5	0	02527043092
84660	02527137717	02527137717	2019-09-23 18:33:55.379459-04	2019-09-02	-100000	1	2	operacion	trf.mb 0134 v013668736 fuentes guevara m 0689	338	5	0	02527137717
84661	90746713929	90746713929	2019-09-23 18:33:55.379459-04	2019-09-02	-30000	1	2	operacion	trf.mb 0134 v011931237 quevedo martinez  0689	338	5	0	90746713929
84662	84705570987	84705570987	2019-09-24 10:49:18.983056-04	2019-01-02	2000	1	1	operacion	banesco pago movil	332	6	0	84705570987
84663	56327109929	56327109929	2019-09-24 10:49:18.983056-04	2019-01-02	-2300	1	2	operacion	trans.ctas	332	6	0	56327109929
84664	02099440737	02099440737	2019-09-24 10:49:18.983056-04	2019-01-02	-12500	1	2	operacion	trans.ctas	332	6	0	02099440737
84665	02103748219	02103748219	2019-09-24 10:49:18.983056-04	2019-01-03	78500	1	1	operacion	trans.ctas	332	6	0	02103748219
84666	00418551733	00418551733	2019-09-24 10:49:18.983056-04	2019-01-04	-7000	1	2	operacion	banesco pago movil	332	6	0	00418551733
84667	00418551733	00418551733	2019-09-24 10:49:18.983056-04	2019-01-04	-21	1	2	operacion	banesco pago movil	332	6	0	00418551733
84668	00418496108	00418496108	2019-09-24 10:49:18.983056-04	2019-01-04	-7000	1	2	operacion	banesco pago movil	332	6	0	00418496108
84669	00418496108	00418496108	2019-09-24 10:49:18.983056-04	2019-01-04	-21	1	2	operacion	banesco pago movil	332	6	0	00418496108
84670	00418496358	00418496358	2019-09-24 10:49:18.983056-04	2019-01-04	-15000	1	2	operacion	banesco pago movil	332	6	0	00418496358
84671	00418496358	00418496358	2019-09-24 10:49:18.983056-04	2019-01-04	-45	1	2	operacion	banesco pago movil	332	6	0	00418496358
84672	02104427876	02104427876	2019-09-24 10:49:18.983056-04	2019-01-04	-25700	1	2	operacion	trans.ctas	332	6	0	02104427876
84673	02104568339	02104568339	2019-09-24 10:49:18.983056-04	2019-01-04	-12500	1	2	operacion	trans.ctas	332	6	0	02104568339
84674	02105335406	02105335406	2019-09-24 10:49:18.983056-04	2019-01-04	64000	1	1	operacion	trans.ctas	332	6	0	02105335406
84675	00413609971	00413609971	2019-09-24 10:49:18.983056-04	2019-01-04	-15000	1	2	operacion	compra pos cta/cte	332	6	0	00413609971
84676	00457280032	00457280032	2019-09-24 10:49:18.983056-04	2019-01-04	-300	1	2	operacion	compra pos cta/cte pan de paris	332	6	0	00457280032
84677	00457280004	00457280004	2019-09-24 10:49:18.983056-04	2019-01-04	-884.100000000000023	1	2	operacion	compra pos cta/cte pan de paris	332	6	0	00457280004
84678	00578890028	00578890028	2019-09-24 10:49:18.983056-04	2019-01-07	-642	1	2	operacion	compra pos cta/cte maggies	332	6	0	00578890028
84679	00528980008	00528980008	2019-09-24 10:49:18.983056-04	2019-01-07	-350	1	2	operacion	compra pos cta/cte vanadis	332	6	0	00528980008
84680	00528980005	00528980005	2019-09-24 10:49:18.983056-04	2019-01-07	-6800	1	2	operacion	compra pos cta/cte vanadis	332	6	0	00528980005
84681	00748890053	00748890053	2019-09-24 10:49:18.983056-04	2019-01-07	-650	1	2	operacion	compra pos cta/cte soluciones catering	332	6	0	00748890053
84682	00748890051	00748890051	2019-09-24 10:49:18.983056-04	2019-01-07	-1600	1	2	operacion	compra pos cta/cte soluciones catering	332	6	0	00748890051
84683	00513984004	00513984004	2019-09-24 10:49:18.983056-04	2019-01-07	-1000	1	2	operacion	compra pos cta/cte	332	6	0	00513984004
84684	00000002523	00000002523	2019-09-24 10:49:18.983056-04	2019-01-07	-6353	1	2	operacion	compra pos cta/cte	332	6	0	00000002523
84685	00000097542	00000097542	2019-09-24 10:49:18.983056-04	2019-01-07	-1450	1	2	operacion	compra pos cta/cte	332	6	0	00000097542
84686	40001312776	40001312776	2019-09-24 10:49:18.983056-04	2019-01-07	-23654	1	2	operacion	compra pos cta/cte	332	6	0	40001312776
84687	00718715368	00718715368	2019-09-24 10:49:18.983056-04	2019-01-07	-4800	1	2	operacion	banesco pago movil	332	6	0	00718715368
84688	00518567277	00518567277	2019-09-24 10:49:18.983056-04	2019-01-07	-15000	1	2	operacion	banesco pago movil	332	6	0	00518567277
84689	00718740377	00718740377	2019-09-24 10:49:18.983056-04	2019-01-07	-20000	1	2	operacion	banesco pago movil	332	6	0	00718740377
84690	00718715368	00718715368	2019-09-24 10:49:18.983056-04	2019-01-07	-14.4000000000000004	1	2	operacion	banesco pago movil	332	6	0	00718715368
84691	00518567277	00518567277	2019-09-24 10:49:18.983056-04	2019-01-07	-45	1	2	operacion	banesco pago movil	332	6	0	00518567277
84692	00718740377	00718740377	2019-09-24 10:49:18.983056-04	2019-01-07	-60	1	2	operacion	banesco pago movil	332	6	0	00718740377
84693	02109530045	02109530045	2019-09-24 10:49:18.983056-04	2019-01-07	111100	1	1	operacion	trans.ctas	332	6	0	02109530045
84694	02108299285	02108299285	2019-09-24 10:49:18.983056-04	2019-01-07	105000	1	1	operacion	trans.ctas a tercero en banesco	332	6	0	02108299285
84695	02105830548	02105830548	2019-09-24 10:49:18.983056-04	2019-01-07	-24000	1	2	operacion	trans.ctas	332	6	0	02105830548
84696	02109534875	02109534875	2019-09-24 10:49:18.983056-04	2019-01-07	-110000	1	2	operacion	trans.ctas	332	6	0	02109534875
84697	28335442929	28335442929	2019-09-24 10:49:18.983056-04	2019-01-08	-20000	1	2	operacion	trf transfer/otros bancos     0115	332	6	0	28335442929
84698	28335442929	28335442929	2019-09-24 10:49:18.983056-04	2019-01-08	-2	1	2	operacion	comision trf otros bcos	332	6	0	28335442929
84699	28335442929	28335442929	2019-09-24 10:49:18.983056-04	2019-01-08	-100	1	2	operacion	cce/recargo tx alto valor	332	6	0	28335442929
84700	00857280033	00857280033	2019-09-24 10:49:18.983056-04	2019-01-08	-800	1	2	operacion	compra pos cta/cte pan de paris	332	6	0	00857280033
84701	00872790019	00872790019	2019-09-24 10:49:18.983056-04	2019-01-08	-912	1	2	operacion	compra pos cta/cte hogar plaza	332	6	0	00872790019
84702	00857280082	00857280082	2019-09-24 10:49:18.983056-04	2019-01-08	-800	1	2	operacion	compra pos cta/cte pan de paris	332	6	0	00857280082
84703	40001064374	40001064374	2019-09-24 10:49:18.983056-04	2019-01-08	-5626.5	1	2	operacion	compra pos cta/cte	332	6	0	40001064374
84704	40001480280	40001480280	2019-09-24 10:49:18.983056-04	2019-01-08	-1500	1	2	operacion	compra pos cta/cte	332	6	0	40001480280
84705	00823750046	00823750046	2019-09-24 10:49:18.983056-04	2019-01-08	-4199.25	1	2	operacion	compra pos cta/cte inversiones awm	332	6	0	00823750046
84706	00823494739	00823494739	2019-09-24 10:49:18.983056-04	2019-01-08	-950	1	2	operacion	compra pos cta/cte	332	6	0	00823494739
84707	00919010849	00919010849	2019-09-24 10:49:18.983056-04	2019-01-09	-500	1	2	operacion	banesco pago movil	332	6	0	00919010849
84708	00919010849	00919010849	2019-09-24 10:49:18.983056-04	2019-01-09	-1.5	1	2	operacion	banesco pago movil	332	6	0	00919010849
84709	00914358191	00914358191	2019-09-24 10:49:18.983056-04	2019-01-09	-4248	1	2	operacion	compra pos cta/cte	332	6	0	00914358191
84710	00917335943	00917335943	2019-09-24 10:49:18.983056-04	2019-01-09	-575	1	2	operacion	compra pos cta/cte	332	6	0	00917335943
84711	00948890048	00948890048	2019-09-24 10:49:18.983056-04	2019-01-09	-2450	1	2	operacion	compra pos cta/cte soluciones catering	332	6	0	00948890048
84712	00972790047	00972790047	2019-09-24 10:49:18.983056-04	2019-01-09	-642	1	2	operacion	compra pos cta/cte hogar plaza	332	6	0	00972790047
84713	00920331382	00920331382	2019-09-24 10:49:18.983056-04	2019-01-09	-450	1	2	operacion	compra pos cta/cte	332	6	0	00920331382
84714	00978890027	00978890027	2019-09-24 10:49:18.983056-04	2019-01-09	-8991	1	2	operacion	compra pos cta/cte maggies	332	6	0	00978890027
84715	00188610398	00188610398	2019-09-24 10:49:18.983056-04	2019-01-10	-478.600000000000023	1	2	operacion	movistar cargo c/cta.	332	6	0	00188610398
84716	01012678693	01012678693	2019-09-24 10:49:18.983056-04	2019-01-10	-525	1	2	operacion	compra pos cta/cte	332	6	0	01012678693
84717	01072050030	01072050030	2019-09-24 10:49:18.983056-04	2019-01-10	-2200	1	2	operacion	compra pos cta/cte est servicios los rob	332	6	0	01072050030
84718	01078890119	01078890119	2019-09-24 10:49:18.983056-04	2019-01-10	-642	1	2	operacion	compra pos cta/cte maggies	332	6	0	01078890119
84719	01119266959	01119266959	2019-09-24 10:49:18.983056-04	2019-01-11	-22000	1	2	operacion	banesco pago movil	332	6	0	01119266959
84720	01119266959	01119266959	2019-09-24 10:49:18.983056-04	2019-01-11	-66	1	2	operacion	banesco pago movil	332	6	0	01119266959
84721	02118008007	02118008007	2019-09-24 10:49:18.983056-04	2019-01-11	24500	1	1	operacion	trans.ctas	332	6	0	02118008007
84722	01172790007	01172790007	2019-09-24 10:49:18.983056-04	2019-01-11	-280	1	2	operacion	compra pos cta/cte hogar plaza	332	6	0	01172790007
84723	01172790038	01172790038	2019-09-24 10:49:18.983056-04	2019-01-11	-724	1	2	operacion	compra pos cta/cte hogar plaza	332	6	0	01172790038
84724	01120335023	01120335023	2019-09-24 10:49:18.983056-04	2019-01-11	-1150	1	2	operacion	compra pos cta/cte	332	6	0	01120335023
84725	84705545687	84705545687	2019-09-24 10:49:18.983056-04	2019-01-14	2000	1	1	operacion	banesco pago movil	332	6	0	84705545687
84726	01419586556	01419586556	2019-09-24 10:49:18.983056-04	2019-01-14	-25000	1	2	operacion	banesco pago movil	332	6	0	01419586556
84727	01419586556	01419586556	2019-09-24 10:49:18.983056-04	2019-01-14	-75	1	2	operacion	banesco pago movil	332	6	0	01419586556
84728	01419586617	01419586617	2019-09-24 10:49:18.983056-04	2019-01-14	-4500	1	2	operacion	banesco pago movil	332	6	0	01419586617
84729	01419586617	01419586617	2019-09-24 10:49:18.983056-04	2019-01-14	-13.5	1	2	operacion	banesco pago movil	332	6	0	01419586617
84730	01419586711	01419586711	2019-09-24 10:49:18.983056-04	2019-01-14	-500	1	2	operacion	banesco pago movil	332	6	0	01419586711
84731	01419586711	01419586711	2019-09-24 10:49:18.983056-04	2019-01-14	-1.5	1	2	operacion	banesco pago movil	332	6	0	01419586711
84732	01219410111	01219410111	2019-09-24 10:49:18.983056-04	2019-01-14	-2.41999999999999993	1	2	operacion	com. banesco pago movil	332	6	0	01219410111
84733	01219410154	01219410154	2019-09-24 10:49:18.983056-04	2019-01-14	-550	1	2	operacion	banesco pago movil	332	6	0	01219410154
84734	01219410154	01219410154	2019-09-24 10:49:18.983056-04	2019-01-14	-1.64999999999999991	1	2	operacion	banesco pago movil	332	6	0	01219410154
84735	02123164465	02123164465	2019-09-24 10:49:18.983056-04	2019-01-14	230000	1	1	operacion	trans.ctas	332	6	0	02123164465
84736	02123225085	02123225085	2019-09-24 10:49:18.983056-04	2019-01-14	-7759.35999999999967	1	2	operacion	trans.ctas	332	6	0	02123225085
84737	01214070130	01214070130	2019-09-24 10:49:18.983056-04	2019-01-14	-1100	1	2	operacion	compra pos cta/cte	332	6	0	01214070130
84738	40001208628	40001208628	2019-09-24 10:49:18.983056-04	2019-01-14	-1000	1	2	operacion	compra pos cta/cte	332	6	0	40001208628
84739	01219174026	01219174026	2019-09-24 10:49:18.983056-04	2019-01-14	-1700	1	2	operacion	compra pos cta/cte	332	6	0	01219174026
84740	01478890042	01478890042	2019-09-24 10:49:18.983056-04	2019-01-14	-784	1	2	operacion	compra pos cta/cte maggies	332	6	0	01478890042
84741	01405460099	01405460099	2019-09-24 10:49:18.983056-04	2019-01-14	-3970	1	2	operacion	compra pos cta/cte prolicor pampatar	332	6	0	01405460099
84742	01405460100	01405460100	2019-09-24 10:49:18.983056-04	2019-01-14	-970	1	2	operacion	compra pos cta/cte prolicor pampatar	332	6	0	01405460100
84743	02952623593	02952623593	2019-09-24 10:49:18.983056-04	2019-01-15	-14.2899999999999991	1	2	operacion	pago cantv	332	6	0	02952623593
84744	02952627091	02952627091	2019-09-24 10:49:18.983056-04	2019-01-15	-14.2200000000000006	1	2	operacion	pago cantv	332	6	0	02952627091
84745	01519636220	01519636220	2019-09-24 10:49:18.983056-04	2019-01-15	-5000	1	2	operacion	banesco pago movil	332	6	0	01519636220
84746	01519636220	01519636220	2019-09-24 10:49:18.983056-04	2019-01-15	-15	1	2	operacion	banesco pago movil	332	6	0	01519636220
84747	01519619854	01519619854	2019-09-24 10:49:18.983056-04	2019-01-15	-20000	1	2	operacion	banesco pago movil	332	6	0	01519619854
84748	01519619854	01519619854	2019-09-24 10:49:18.983056-04	2019-01-15	-60	1	2	operacion	banesco pago movil	332	6	0	01519619854
84749	01519625026	01519625026	2019-09-24 10:49:18.983056-04	2019-01-15	-5000	1	2	operacion	banesco pago movil	332	6	0	01519625026
84750	01519625026	01519625026	2019-09-24 10:49:18.983056-04	2019-01-15	-15	1	2	operacion	banesco pago movil	332	6	0	01519625026
84751	40001433624	40001433624	2019-09-24 10:49:18.983056-04	2019-01-15	-45000	1	2	operacion	compra pos cta/cte	332	6	0	40001433624
84752	01557280005	01557280005	2019-09-24 10:49:18.983056-04	2019-01-15	-2375	1	2	operacion	compra pos cta/cte pan de paris	332	6	0	01557280005
84753	10744921641	10744921641	2019-09-24 10:49:18.983056-04	2019-01-16	-508.300000000000011	1	2	operacion	ptc pago tdc otros bancos     0116	332	6	0	10744921641
84754	10744921641	10744921641	2019-09-24 10:49:18.983056-04	2019-01-16	-0.0500000000000000028	1	2	operacion	comision ptc otros bcos	332	6	0	10744921641
84755	10744658893	10744658893	2019-09-24 10:49:18.983056-04	2019-01-16	-508.300000000000011	1	2	operacion	ptc pago tdc otros bancos     0116	332	6	0	10744658893
84756	10744658893	10744658893	2019-09-24 10:49:18.983056-04	2019-01-16	-0.0500000000000000028	1	2	operacion	comision ptc otros bcos	332	6	0	10744658893
84757	10744675788	10744675788	2019-09-24 10:49:18.983056-04	2019-01-16	-508.300000000000011	1	2	operacion	ptc pago tdc otros bancos     0116	332	6	0	10744675788
84758	10744675788	10744675788	2019-09-24 10:49:18.983056-04	2019-01-16	-0.0500000000000000028	1	2	operacion	comision ptc otros bcos	332	6	0	10744675788
84759	23451592929	23451592929	2019-09-24 10:49:18.983056-04	2019-01-16	-35000	1	2	operacion	trf transfer/otros bancos     0115	332	6	0	23451592929
84760	23451592929	23451592929	2019-09-24 10:49:18.983056-04	2019-01-16	-3.5	1	2	operacion	comision trf otros bcos	332	6	0	23451592929
84761	23451592929	23451592929	2019-09-24 10:49:18.983056-04	2019-01-16	-100	1	2	operacion	cce/recargo tx alto valor	332	6	0	23451592929
84762	01628260004	01628260004	2019-09-24 10:49:18.983056-04	2019-01-16	-600	1	2	operacion	compra pos cta/cte pasteleria charlies	332	6	0	01628260004
84763	01612603817	01612603817	2019-09-24 10:49:18.983056-04	2019-01-16	-1150	1	2	operacion	compra pos cta/cte	332	6	0	01612603817
84764	01624530118	01624530118	2019-09-24 10:49:18.983056-04	2019-01-16	-6935	1	2	operacion	compra pos cta/cte fressier	332	6	0	01624530118
84765	01621830999	01621830999	2019-09-24 10:49:18.983056-04	2019-01-16	-2872.96000000000004	1	2	operacion	compra pos cta/cte	332	6	0	01621830999
84766	10751757933	10751757933	2019-09-24 10:49:18.983056-04	2019-01-17	-10000	1	2	operacion	trf transfer/otros bancos     0174	332	6	0	10751757933
84767	10751757933	10751757933	2019-09-24 10:49:18.983056-04	2019-01-17	-1	1	2	operacion	comision trf otros bcos	332	6	0	10751757933
84768	84705985428	84705985428	2019-09-24 10:49:18.983056-04	2019-01-17	15000	1	1	operacion	banesco pago movil	332	6	0	84705985428
84769	01719875599	01719875599	2019-09-24 10:49:18.983056-04	2019-01-17	-250	1	2	operacion	banesco pago movil	332	6	0	01719875599
84770	01719875599	01719875599	2019-09-24 10:49:18.983056-04	2019-01-17	-0.75	1	2	operacion	banesco pago movil	332	6	0	01719875599
84771	39927655929	39927655929	2019-09-24 10:49:18.983056-04	2019-01-17	-33650	1	2	operacion	trans.ctas	332	6	0	39927655929
84772	01712260004	01712260004	2019-09-24 10:49:18.983056-04	2019-01-17	-28500	1	2	operacion	compra pos cta/cte solovision	332	6	0	01712260004
84773	84705116488	84705116488	2019-09-24 10:49:18.983056-04	2019-01-18	15000	1	1	operacion	banesco pago movil	332	6	0	84705116488
84774	02137045016	02137045016	2019-09-24 10:49:18.983056-04	2019-01-21	55000	1	1	operacion	trans.ctas	332	6	0	02137045016
84775	02120458568	02120458568	2019-09-24 10:49:18.983056-04	2019-01-21	-1900	1	2	operacion	compra pos cta/cte	332	6	0	02120458568
84776	21206669929	21206669929	2019-09-24 10:49:18.983056-04	2019-01-22	-30000	1	2	operacion	trf transfer/otros bancos     0115	332	6	0	21206669929
84777	21206669929	21206669929	2019-09-24 10:49:18.983056-04	2019-01-22	-3	1	2	operacion	comision trf otros bcos	332	6	0	21206669929
84778	21206669929	21206669929	2019-09-24 10:49:18.983056-04	2019-01-22	-100	1	2	operacion	cce/recargo tx alto valor	332	6	0	21206669929
84779	02220292636	02220292636	2019-09-24 10:49:18.983056-04	2019-01-22	-350	1	2	operacion	banesco pago movil	332	6	0	02220292636
84780	02220292636	02220292636	2019-09-24 10:49:18.983056-04	2019-01-22	-1.05000000000000004	1	2	operacion	banesco pago movil	332	6	0	02220292636
84781	02320437544	02320437544	2019-09-24 10:49:18.983056-04	2019-01-23	-600	1	2	operacion	banesco pago movil	332	6	0	02320437544
84782	02320422903	02320422903	2019-09-24 10:49:18.983056-04	2019-01-23	-500	1	2	operacion	banesco pago movil	332	6	0	02320422903
84783	02372050015	02372050015	2019-09-24 10:49:18.983056-04	2019-01-23	-2200	1	2	operacion	compra pos cta/cte est servicios los rob	332	6	0	02372050015
84784	00000115774	00000115774	2019-09-24 10:49:18.983056-04	2019-01-25	100000	1	1	operacion	trf desde otro bco  00000000000000761564 0105	332	6	0	00000115774
84785	02820937077	02820937077	2019-09-24 10:49:18.983056-04	2019-01-28	-30000	1	2	operacion	banesco pago movil	332	6	0	02820937077
84786	02820937077	02820937077	2019-09-24 10:49:18.983056-04	2019-01-28	-90	1	2	operacion	banesco pago movil	332	6	0	02820937077
84787	02672790049	02672790049	2019-09-24 10:49:18.983056-04	2019-01-28	-3861	1	2	operacion	compra pos cta/cte hogar plaza	332	6	0	02672790049
84788	02814597731	02814597731	2019-09-24 10:49:18.983056-04	2019-01-28	-500	1	2	operacion	compra pos cta/cte	332	6	0	02814597731
84789	02921057358	02921057358	2019-09-24 10:49:18.983056-04	2019-01-29	-30000	1	2	operacion	banesco pago movil	332	6	0	02921057358
84790	02921057358	02921057358	2019-09-24 10:49:18.983056-04	2019-01-29	-90	1	2	operacion	banesco pago movil	332	6	0	02921057358
84791	02151475233	02151475233	2019-09-24 10:49:18.983056-04	2019-01-29	-50911.3300000000017	1	2	operacion	trans.ctas	332	6	0	02151475233
84792	02912882560	02912882560	2019-09-24 10:49:18.983056-04	2019-01-29	-500	1	2	operacion	compra pos cta/cte	332	6	0	02912882560
84793	02972050051	02972050051	2019-09-24 10:49:18.983056-04	2019-01-29	-3200	1	2	operacion	compra pos cta/cte est servicios los rob	332	6	0	02972050051
84794	84705341070	84705341070	2019-09-24 10:49:18.983056-04	2019-01-30	15000	1	1	operacion	banesco pago movil	332	6	0	84705341070
84795	03021297865	03021297865	2019-09-24 10:49:18.983056-04	2019-01-30	-500	1	2	operacion	banesco pago movil	332	6	0	03021297865
84796	03021297865	03021297865	2019-09-24 10:49:18.983056-04	2019-01-30	-1.5	1	2	operacion	banesco pago movil	332	6	0	03021297865
84797	03021283394	03021283394	2019-09-24 10:49:18.983056-04	2019-01-30	-3000	1	2	operacion	banesco pago movil	332	6	0	03021283394
84798	02153741862	02153741862	2019-09-24 10:49:18.983056-04	2019-01-30	-30000	1	2	operacion	trans.ctas	332	6	0	02153741862
84799	03121389130	03121389130	2019-09-24 10:49:18.983056-04	2019-01-31	-30000	1	2	operacion	banesco pago movil	332	6	0	03121389130
84800	03121389130	03121389130	2019-09-24 10:49:18.983056-04	2019-01-31	-90	1	2	operacion	banesco pago movil	332	6	0	03121389130
84801	02156183145	02156183145	2019-09-24 10:49:18.983056-04	2019-01-31	300000	1	1	operacion	trans.ctas	332	6	0	02156183145
84802	02157086977	02157086977	2019-09-24 10:49:18.983056-04	2019-01-31	-40000	1	2	operacion	trans.ctas	332	6	0	02157086977
84803	00000000000	00000000000	2019-09-24 10:49:18.983056-04	2019-01-31	-0.170000000000000012	1	2	operacion	intereses por sobregiro	332	6	0	00000000000
84804	00000000000	00000000000	2019-09-24 10:49:18.983056-04	2019-01-31	-2.41999999999999993	1	2	operacion	com.serv.mtto cta	332	6	0	00000000000
84805	00000000000	00000000000	2019-09-24 10:49:18.983056-04	2019-01-31	-4.83999999999999986	1	2	operacion	emision de estado de cuenta	332	6	0	00000000000
84806	00000000000	00000000000	2019-09-24 10:49:18.983056-04	2019-01-31	0.510000000000000009	1	1	operacion	intereses	332	6	0	00000000000
84807	03119277959	03119277959	2019-09-24 10:49:18.983056-04	2019-01-31	-10695	1	2	operacion	compra pos cta/cte	332	6	0	03119277959
84808	03119985260	03119985260	2019-09-24 10:49:18.983056-04	2019-01-31	-3000	1	2	operacion	compra pos cta/cte	332	6	0	03119985260
84809	00000000403	00000000403	2019-09-24 10:49:18.983056-04	2019-01-31	-3760	1	2	operacion	compra pos cta/cte	332	6	0	00000000403
84810	84705570987	84705570987	2019-09-26 15:36:41.817712-04	2019-01-02	2000	1	1	operacion	banesco pago movil	342	8	0	84705570987
84811	56327109929	56327109929	2019-09-26 15:36:41.817712-04	2019-01-02	-2300	1	2	operacion	trans.ctas	342	8	0	56327109929
84812	02099440737	02099440737	2019-09-26 15:36:41.817712-04	2019-01-02	-12500	1	2	operacion	trans.ctas	342	8	0	02099440737
84813	02103748219	02103748219	2019-09-26 15:36:41.817712-04	2019-01-03	78500	1	1	operacion	trans.ctas	342	8	0	02103748219
84814	00418551733	00418551733	2019-09-26 15:36:41.817712-04	2019-01-04	-7000	1	2	operacion	banesco pago movil	342	8	0	00418551733
84815	00418551733	00418551733	2019-09-26 15:36:41.817712-04	2019-01-04	-21	1	2	operacion	banesco pago movil	342	8	0	00418551733
84816	00418496108	00418496108	2019-09-26 15:36:41.817712-04	2019-01-04	-7000	1	2	operacion	banesco pago movil	342	8	0	00418496108
84817	00418496108	00418496108	2019-09-26 15:36:41.817712-04	2019-01-04	-21	1	2	operacion	banesco pago movil	342	8	0	00418496108
84818	00418496358	00418496358	2019-09-26 15:36:41.817712-04	2019-01-04	-15000	1	2	operacion	banesco pago movil	342	8	0	00418496358
84819	00418496358	00418496358	2019-09-26 15:36:41.817712-04	2019-01-04	-45	1	2	operacion	banesco pago movil	342	8	0	00418496358
84820	02104427876	02104427876	2019-09-26 15:36:41.817712-04	2019-01-04	-25700	1	2	operacion	trans.ctas	342	8	0	02104427876
84821	02104568339	02104568339	2019-09-26 15:36:41.817712-04	2019-01-04	-12500	1	2	operacion	trans.ctas	342	8	0	02104568339
84822	02105335406	02105335406	2019-09-26 15:36:41.817712-04	2019-01-04	64000	1	1	operacion	trans.ctas	342	8	0	02105335406
84823	00413609971	00413609971	2019-09-26 15:36:41.817712-04	2019-01-04	-15000	1	2	operacion	compra pos cta/cte	342	8	0	00413609971
84824	00457280032	00457280032	2019-09-26 15:36:41.817712-04	2019-01-04	-300	1	2	operacion	compra pos cta/cte pan de paris	342	8	0	00457280032
84825	00457280004	00457280004	2019-09-26 15:36:41.817712-04	2019-01-04	-884.100000000000023	1	2	operacion	compra pos cta/cte pan de paris	342	8	0	00457280004
84826	00578890028	00578890028	2019-09-26 15:36:41.817712-04	2019-01-07	-642	1	2	operacion	compra pos cta/cte maggies	342	8	0	00578890028
84827	00528980008	00528980008	2019-09-26 15:36:41.817712-04	2019-01-07	-350	1	2	operacion	compra pos cta/cte vanadis	342	8	0	00528980008
84828	00528980005	00528980005	2019-09-26 15:36:41.817712-04	2019-01-07	-6800	1	2	operacion	compra pos cta/cte vanadis	342	8	0	00528980005
84829	00748890053	00748890053	2019-09-26 15:36:41.817712-04	2019-01-07	-650	1	2	operacion	compra pos cta/cte soluciones catering	342	8	0	00748890053
84830	00748890051	00748890051	2019-09-26 15:36:41.817712-04	2019-01-07	-1600	1	2	operacion	compra pos cta/cte soluciones catering	342	8	0	00748890051
84831	00513984004	00513984004	2019-09-26 15:36:41.817712-04	2019-01-07	-1000	1	2	operacion	compra pos cta/cte	342	8	0	00513984004
84832	00000002523	00000002523	2019-09-26 15:36:41.817712-04	2019-01-07	-6353	1	2	operacion	compra pos cta/cte	342	8	0	00000002523
84833	00000097542	00000097542	2019-09-26 15:36:41.817712-04	2019-01-07	-1450	1	2	operacion	compra pos cta/cte	342	8	0	00000097542
84834	40001312776	40001312776	2019-09-26 15:36:41.817712-04	2019-01-07	-23654	1	2	operacion	compra pos cta/cte	342	8	0	40001312776
84835	00718715368	00718715368	2019-09-26 15:36:41.817712-04	2019-01-07	-4800	1	2	operacion	banesco pago movil	342	8	0	00718715368
84836	00518567277	00518567277	2019-09-26 15:36:41.817712-04	2019-01-07	-15000	1	2	operacion	banesco pago movil	342	8	0	00518567277
84837	00718740377	00718740377	2019-09-26 15:36:41.817712-04	2019-01-07	-20000	1	2	operacion	banesco pago movil	342	8	0	00718740377
84838	00718715368	00718715368	2019-09-26 15:36:41.817712-04	2019-01-07	-14.4000000000000004	1	2	operacion	banesco pago movil	342	8	0	00718715368
84839	00518567277	00518567277	2019-09-26 15:36:41.817712-04	2019-01-07	-45	1	2	operacion	banesco pago movil	342	8	0	00518567277
84840	00718740377	00718740377	2019-09-26 15:36:41.817712-04	2019-01-07	-60	1	2	operacion	banesco pago movil	342	8	0	00718740377
84841	02109530045	02109530045	2019-09-26 15:36:41.817712-04	2019-01-07	111100	1	1	operacion	trans.ctas	342	8	0	02109530045
84842	02108299285	02108299285	2019-09-26 15:36:41.817712-04	2019-01-07	105000	1	1	operacion	trans.ctas a tercero en banesco	342	8	0	02108299285
84843	02105830548	02105830548	2019-09-26 15:36:41.817712-04	2019-01-07	-24000	1	2	operacion	trans.ctas	342	8	0	02105830548
84844	02109534875	02109534875	2019-09-26 15:36:41.817712-04	2019-01-07	-110000	1	2	operacion	trans.ctas	342	8	0	02109534875
84845	28335442929	28335442929	2019-09-26 15:36:41.817712-04	2019-01-08	-20000	1	2	operacion	trf transfer/otros bancos     0115	342	8	0	28335442929
84846	28335442929	28335442929	2019-09-26 15:36:41.817712-04	2019-01-08	-2	1	2	operacion	comision trf otros bcos	342	8	0	28335442929
84847	28335442929	28335442929	2019-09-26 15:36:41.817712-04	2019-01-08	-100	1	2	operacion	cce/recargo tx alto valor	342	8	0	28335442929
84848	00857280033	00857280033	2019-09-26 15:36:41.817712-04	2019-01-08	-800	1	2	operacion	compra pos cta/cte pan de paris	342	8	0	00857280033
84849	00872790019	00872790019	2019-09-26 15:36:41.817712-04	2019-01-08	-912	1	2	operacion	compra pos cta/cte hogar plaza	342	8	0	00872790019
84850	00857280082	00857280082	2019-09-26 15:36:41.817712-04	2019-01-08	-800	1	2	operacion	compra pos cta/cte pan de paris	342	8	0	00857280082
84851	40001064374	40001064374	2019-09-26 15:36:41.817712-04	2019-01-08	-5626.5	1	2	operacion	compra pos cta/cte	342	8	0	40001064374
84852	40001480280	40001480280	2019-09-26 15:36:41.817712-04	2019-01-08	-1500	1	2	operacion	compra pos cta/cte	342	8	0	40001480280
84853	00823750046	00823750046	2019-09-26 15:36:41.817712-04	2019-01-08	-4199.25	1	2	operacion	compra pos cta/cte inversiones awm	342	8	0	00823750046
84854	00823494739	00823494739	2019-09-26 15:36:41.817712-04	2019-01-08	-950	1	2	operacion	compra pos cta/cte	342	8	0	00823494739
84855	00919010849	00919010849	2019-09-26 15:36:41.817712-04	2019-01-09	-500	1	2	operacion	banesco pago movil	342	8	0	00919010849
84856	00919010849	00919010849	2019-09-26 15:36:41.817712-04	2019-01-09	-1.5	1	2	operacion	banesco pago movil	342	8	0	00919010849
84857	00914358191	00914358191	2019-09-26 15:36:41.817712-04	2019-01-09	-4248	1	2	operacion	compra pos cta/cte	342	8	0	00914358191
84858	00917335943	00917335943	2019-09-26 15:36:41.817712-04	2019-01-09	-575	1	2	operacion	compra pos cta/cte	342	8	0	00917335943
84859	00948890048	00948890048	2019-09-26 15:36:41.817712-04	2019-01-09	-2450	1	2	operacion	compra pos cta/cte soluciones catering	342	8	0	00948890048
84860	00972790047	00972790047	2019-09-26 15:36:41.817712-04	2019-01-09	-642	1	2	operacion	compra pos cta/cte hogar plaza	342	8	0	00972790047
84861	00920331382	00920331382	2019-09-26 15:36:41.817712-04	2019-01-09	-450	1	2	operacion	compra pos cta/cte	342	8	0	00920331382
84862	00978890027	00978890027	2019-09-26 15:36:41.817712-04	2019-01-09	-8991	1	2	operacion	compra pos cta/cte maggies	342	8	0	00978890027
84863	00188610398	00188610398	2019-09-26 15:36:41.817712-04	2019-01-10	-478.600000000000023	1	2	operacion	movistar cargo c/cta.	342	8	0	00188610398
84864	01012678693	01012678693	2019-09-26 15:36:41.817712-04	2019-01-10	-525	1	2	operacion	compra pos cta/cte	342	8	0	01012678693
84865	01072050030	01072050030	2019-09-26 15:36:41.817712-04	2019-01-10	-2200	1	2	operacion	compra pos cta/cte est servicios los rob	342	8	0	01072050030
84866	01078890119	01078890119	2019-09-26 15:36:41.817712-04	2019-01-10	-642	1	2	operacion	compra pos cta/cte maggies	342	8	0	01078890119
84867	01119266959	01119266959	2019-09-26 15:36:41.817712-04	2019-01-11	-22000	1	2	operacion	banesco pago movil	342	8	0	01119266959
84868	01119266959	01119266959	2019-09-26 15:36:41.817712-04	2019-01-11	-66	1	2	operacion	banesco pago movil	342	8	0	01119266959
84869	02118008007	02118008007	2019-09-26 15:36:41.817712-04	2019-01-11	24500	1	1	operacion	trans.ctas	342	8	0	02118008007
84870	01172790007	01172790007	2019-09-26 15:36:41.817712-04	2019-01-11	-280	1	2	operacion	compra pos cta/cte hogar plaza	342	8	0	01172790007
84871	01172790038	01172790038	2019-09-26 15:36:41.817712-04	2019-01-11	-724	1	2	operacion	compra pos cta/cte hogar plaza	342	8	0	01172790038
84872	01120335023	01120335023	2019-09-26 15:36:41.817712-04	2019-01-11	-1150	1	2	operacion	compra pos cta/cte	342	8	0	01120335023
84873	84705545687	84705545687	2019-09-26 15:36:41.817712-04	2019-01-14	2000	1	1	operacion	banesco pago movil	342	8	0	84705545687
84874	01419586556	01419586556	2019-09-26 15:36:41.817712-04	2019-01-14	-25000	1	2	operacion	banesco pago movil	342	8	0	01419586556
84875	01419586556	01419586556	2019-09-26 15:36:41.817712-04	2019-01-14	-75	1	2	operacion	banesco pago movil	342	8	0	01419586556
84876	01419586617	01419586617	2019-09-26 15:36:41.817712-04	2019-01-14	-4500	1	2	operacion	banesco pago movil	342	8	0	01419586617
84877	01419586617	01419586617	2019-09-26 15:36:41.817712-04	2019-01-14	-13.5	1	2	operacion	banesco pago movil	342	8	0	01419586617
84878	01419586711	01419586711	2019-09-26 15:36:41.817712-04	2019-01-14	-500	1	2	operacion	banesco pago movil	342	8	0	01419586711
84879	01419586711	01419586711	2019-09-26 15:36:41.817712-04	2019-01-14	-1.5	1	2	operacion	banesco pago movil	342	8	0	01419586711
84880	01219410111	01219410111	2019-09-26 15:36:41.817712-04	2019-01-14	-2.41999999999999993	1	2	operacion	com. banesco pago movil	342	8	0	01219410111
84881	01219410154	01219410154	2019-09-26 15:36:41.817712-04	2019-01-14	-550	1	2	operacion	banesco pago movil	342	8	0	01219410154
84882	01219410154	01219410154	2019-09-26 15:36:41.817712-04	2019-01-14	-1.64999999999999991	1	2	operacion	banesco pago movil	342	8	0	01219410154
84883	02123164465	02123164465	2019-09-26 15:36:41.817712-04	2019-01-14	230000	1	1	operacion	trans.ctas	342	8	0	02123164465
84884	02123225085	02123225085	2019-09-26 15:36:41.817712-04	2019-01-14	-7759.35999999999967	1	2	operacion	trans.ctas	342	8	0	02123225085
84885	01214070130	01214070130	2019-09-26 15:36:41.817712-04	2019-01-14	-1100	1	2	operacion	compra pos cta/cte	342	8	0	01214070130
84886	40001208628	40001208628	2019-09-26 15:36:41.817712-04	2019-01-14	-1000	1	2	operacion	compra pos cta/cte	342	8	0	40001208628
84887	01219174026	01219174026	2019-09-26 15:36:41.817712-04	2019-01-14	-1700	1	2	operacion	compra pos cta/cte	342	8	0	01219174026
84888	01478890042	01478890042	2019-09-26 15:36:41.817712-04	2019-01-14	-784	1	2	operacion	compra pos cta/cte maggies	342	8	0	01478890042
84889	01405460099	01405460099	2019-09-26 15:36:41.817712-04	2019-01-14	-3970	1	2	operacion	compra pos cta/cte prolicor pampatar	342	8	0	01405460099
84890	01405460100	01405460100	2019-09-26 15:36:41.817712-04	2019-01-14	-970	1	2	operacion	compra pos cta/cte prolicor pampatar	342	8	0	01405460100
84891	02952623593	02952623593	2019-09-26 15:36:41.817712-04	2019-01-15	-14.2899999999999991	1	2	operacion	pago cantv	342	8	0	02952623593
84892	02952627091	02952627091	2019-09-26 15:36:41.817712-04	2019-01-15	-14.2200000000000006	1	2	operacion	pago cantv	342	8	0	02952627091
84893	01519636220	01519636220	2019-09-26 15:36:41.817712-04	2019-01-15	-5000	1	2	operacion	banesco pago movil	342	8	0	01519636220
84894	01519636220	01519636220	2019-09-26 15:36:41.817712-04	2019-01-15	-15	1	2	operacion	banesco pago movil	342	8	0	01519636220
84895	01519619854	01519619854	2019-09-26 15:36:41.817712-04	2019-01-15	-20000	1	2	operacion	banesco pago movil	342	8	0	01519619854
84896	01519619854	01519619854	2019-09-26 15:36:41.817712-04	2019-01-15	-60	1	2	operacion	banesco pago movil	342	8	0	01519619854
84897	01519625026	01519625026	2019-09-26 15:36:41.817712-04	2019-01-15	-5000	1	2	operacion	banesco pago movil	342	8	0	01519625026
84898	01519625026	01519625026	2019-09-26 15:36:41.817712-04	2019-01-15	-15	1	2	operacion	banesco pago movil	342	8	0	01519625026
84899	40001433624	40001433624	2019-09-26 15:36:41.817712-04	2019-01-15	-45000	1	2	operacion	compra pos cta/cte	342	8	0	40001433624
84900	01557280005	01557280005	2019-09-26 15:36:41.817712-04	2019-01-15	-2375	1	2	operacion	compra pos cta/cte pan de paris	342	8	0	01557280005
84901	10744921641	10744921641	2019-09-26 15:36:41.817712-04	2019-01-16	-508.300000000000011	1	2	operacion	ptc pago tdc otros bancos     0116	342	8	0	10744921641
84902	10744921641	10744921641	2019-09-26 15:36:41.817712-04	2019-01-16	-0.0500000000000000028	1	2	operacion	comision ptc otros bcos	342	8	0	10744921641
84903	10744658893	10744658893	2019-09-26 15:36:41.817712-04	2019-01-16	-508.300000000000011	1	2	operacion	ptc pago tdc otros bancos     0116	342	8	0	10744658893
84904	10744658893	10744658893	2019-09-26 15:36:41.817712-04	2019-01-16	-0.0500000000000000028	1	2	operacion	comision ptc otros bcos	342	8	0	10744658893
84905	10744675788	10744675788	2019-09-26 15:36:41.817712-04	2019-01-16	-508.300000000000011	1	2	operacion	ptc pago tdc otros bancos     0116	342	8	0	10744675788
84906	10744675788	10744675788	2019-09-26 15:36:41.817712-04	2019-01-16	-0.0500000000000000028	1	2	operacion	comision ptc otros bcos	342	8	0	10744675788
84907	23451592929	23451592929	2019-09-26 15:36:41.817712-04	2019-01-16	-35000	1	2	operacion	trf transfer/otros bancos     0115	342	8	0	23451592929
84908	23451592929	23451592929	2019-09-26 15:36:41.817712-04	2019-01-16	-3.5	1	2	operacion	comision trf otros bcos	342	8	0	23451592929
84909	23451592929	23451592929	2019-09-26 15:36:41.817712-04	2019-01-16	-100	1	2	operacion	cce/recargo tx alto valor	342	8	0	23451592929
84910	01628260004	01628260004	2019-09-26 15:36:41.817712-04	2019-01-16	-600	1	2	operacion	compra pos cta/cte pasteleria charlies	342	8	0	01628260004
84911	01612603817	01612603817	2019-09-26 15:36:41.817712-04	2019-01-16	-1150	1	2	operacion	compra pos cta/cte	342	8	0	01612603817
84912	01624530118	01624530118	2019-09-26 15:36:41.817712-04	2019-01-16	-6935	1	2	operacion	compra pos cta/cte fressier	342	8	0	01624530118
84913	01621830999	01621830999	2019-09-26 15:36:41.817712-04	2019-01-16	-2872.96000000000004	1	2	operacion	compra pos cta/cte	342	8	0	01621830999
84914	10751757933	10751757933	2019-09-26 15:36:41.817712-04	2019-01-17	-10000	1	2	operacion	trf transfer/otros bancos     0174	342	8	0	10751757933
84915	10751757933	10751757933	2019-09-26 15:36:41.817712-04	2019-01-17	-1	1	2	operacion	comision trf otros bcos	342	8	0	10751757933
84916	84705985428	84705985428	2019-09-26 15:36:41.817712-04	2019-01-17	15000	1	1	operacion	banesco pago movil	342	8	0	84705985428
84917	01719875599	01719875599	2019-09-26 15:36:41.817712-04	2019-01-17	-250	1	2	operacion	banesco pago movil	342	8	0	01719875599
84918	01719875599	01719875599	2019-09-26 15:36:41.817712-04	2019-01-17	-0.75	1	2	operacion	banesco pago movil	342	8	0	01719875599
84919	39927655929	39927655929	2019-09-26 15:36:41.817712-04	2019-01-17	-33650	1	2	operacion	trans.ctas	342	8	0	39927655929
84920	01712260004	01712260004	2019-09-26 15:36:41.817712-04	2019-01-17	-28500	1	2	operacion	compra pos cta/cte solovision	342	8	0	01712260004
84921	84705116488	84705116488	2019-09-26 15:36:41.817712-04	2019-01-18	15000	1	1	operacion	banesco pago movil	342	8	0	84705116488
84922	02137045016	02137045016	2019-09-26 15:36:41.817712-04	2019-01-21	55000	1	1	operacion	trans.ctas	342	8	0	02137045016
84923	02120458568	02120458568	2019-09-26 15:36:41.817712-04	2019-01-21	-1900	1	2	operacion	compra pos cta/cte	342	8	0	02120458568
84924	21206669929	21206669929	2019-09-26 15:36:41.817712-04	2019-01-22	-30000	1	2	operacion	trf transfer/otros bancos     0115	342	8	0	21206669929
84925	21206669929	21206669929	2019-09-26 15:36:41.817712-04	2019-01-22	-3	1	2	operacion	comision trf otros bcos	342	8	0	21206669929
84926	21206669929	21206669929	2019-09-26 15:36:41.817712-04	2019-01-22	-100	1	2	operacion	cce/recargo tx alto valor	342	8	0	21206669929
84927	02220292636	02220292636	2019-09-26 15:36:41.817712-04	2019-01-22	-350	1	2	operacion	banesco pago movil	342	8	0	02220292636
84928	02220292636	02220292636	2019-09-26 15:36:41.817712-04	2019-01-22	-1.05000000000000004	1	2	operacion	banesco pago movil	342	8	0	02220292636
84929	02320437544	02320437544	2019-09-26 15:36:41.817712-04	2019-01-23	-600	1	2	operacion	banesco pago movil	342	8	0	02320437544
84930	02320422903	02320422903	2019-09-26 15:36:41.817712-04	2019-01-23	-500	1	2	operacion	banesco pago movil	342	8	0	02320422903
84931	02372050015	02372050015	2019-09-26 15:36:41.817712-04	2019-01-23	-2200	1	2	operacion	compra pos cta/cte est servicios los rob	342	8	0	02372050015
84932	00000115774	00000115774	2019-09-26 15:36:41.817712-04	2019-01-25	100000	1	1	operacion	trf desde otro bco  00000000000000761564 0105	342	8	0	00000115774
84933	02820937077	02820937077	2019-09-26 15:36:41.817712-04	2019-01-28	-30000	1	2	operacion	banesco pago movil	342	8	0	02820937077
84934	02820937077	02820937077	2019-09-26 15:36:41.817712-04	2019-01-28	-90	1	2	operacion	banesco pago movil	342	8	0	02820937077
84935	02672790049	02672790049	2019-09-26 15:36:41.817712-04	2019-01-28	-3861	1	2	operacion	compra pos cta/cte hogar plaza	342	8	0	02672790049
84936	02814597731	02814597731	2019-09-26 15:36:41.817712-04	2019-01-28	-500	1	2	operacion	compra pos cta/cte	342	8	0	02814597731
84937	02921057358	02921057358	2019-09-26 15:36:41.817712-04	2019-01-29	-30000	1	2	operacion	banesco pago movil	342	8	0	02921057358
84938	02921057358	02921057358	2019-09-26 15:36:41.817712-04	2019-01-29	-90	1	2	operacion	banesco pago movil	342	8	0	02921057358
84939	02151475233	02151475233	2019-09-26 15:36:41.817712-04	2019-01-29	-50911.3300000000017	1	2	operacion	trans.ctas	342	8	0	02151475233
84940	02912882560	02912882560	2019-09-26 15:36:41.817712-04	2019-01-29	-500	1	2	operacion	compra pos cta/cte	342	8	0	02912882560
84941	02972050051	02972050051	2019-09-26 15:36:41.817712-04	2019-01-29	-3200	1	2	operacion	compra pos cta/cte est servicios los rob	342	8	0	02972050051
84942	84705341070	84705341070	2019-09-26 15:36:41.817712-04	2019-01-30	15000	1	1	operacion	banesco pago movil	342	8	0	84705341070
84943	03021297865	03021297865	2019-09-26 15:36:41.817712-04	2019-01-30	-500	1	2	operacion	banesco pago movil	342	8	0	03021297865
84944	03021297865	03021297865	2019-09-26 15:36:41.817712-04	2019-01-30	-1.5	1	2	operacion	banesco pago movil	342	8	0	03021297865
84945	03021283394	03021283394	2019-09-26 15:36:41.817712-04	2019-01-30	-3000	1	2	operacion	banesco pago movil	342	8	0	03021283394
84946	02153741862	02153741862	2019-09-26 15:36:41.817712-04	2019-01-30	-30000	1	2	operacion	trans.ctas	342	8	0	02153741862
84947	03121389130	03121389130	2019-09-26 15:36:41.817712-04	2019-01-31	-30000	1	2	operacion	banesco pago movil	342	8	0	03121389130
84948	03121389130	03121389130	2019-09-26 15:36:41.817712-04	2019-01-31	-90	1	2	operacion	banesco pago movil	342	8	0	03121389130
84949	02156183145	02156183145	2019-09-26 15:36:41.817712-04	2019-01-31	300000	1	1	operacion	trans.ctas	342	8	0	02156183145
84950	02157086977	02157086977	2019-09-26 15:36:41.817712-04	2019-01-31	-40000	1	2	operacion	trans.ctas	342	8	0	02157086977
84951	00000000000	00000000000	2019-09-26 15:36:41.817712-04	2019-01-31	-0.170000000000000012	1	2	operacion	intereses por sobregiro	342	8	0	00000000000
84952	00000000000	00000000000	2019-09-26 15:36:41.817712-04	2019-01-31	-2.41999999999999993	1	2	operacion	com.serv.mtto cta	342	8	0	00000000000
84953	00000000000	00000000000	2019-09-26 15:36:41.817712-04	2019-01-31	-4.83999999999999986	1	2	operacion	emision de estado de cuenta	342	8	0	00000000000
84954	00000000000	00000000000	2019-09-26 15:36:41.817712-04	2019-01-31	0.510000000000000009	1	1	operacion	intereses	342	8	0	00000000000
84955	03119277959	03119277959	2019-09-26 15:36:41.817712-04	2019-01-31	-10695	1	2	operacion	compra pos cta/cte	342	8	0	03119277959
84956	03119985260	03119985260	2019-09-26 15:36:41.817712-04	2019-01-31	-3000	1	2	operacion	compra pos cta/cte	342	8	0	03119985260
84957	00000000403	00000000403	2019-09-26 15:36:41.817712-04	2019-01-31	-3760	1	2	operacion	compra pos cta/cte	342	8	0	00000000403
\.


--
-- Data for Name: movimientos_info; Type: TABLE DATA; Schema: bancos; Owner: geekhack
--

COPY bancos.movimientos_info (id, categoria, subcategoria, titular, nota, estatus, activo, fecha_creacion) FROM stdin;
84111	2	22	\N		1	t	2019-09-19 15:12:56.018496-04
84112	2	22	\N		1	t	2019-09-19 15:12:56.018496-04
84113	2	22	\N		1	t	2019-09-19 15:12:56.018496-04
84114	2	22	\N		1	t	2019-09-19 15:12:56.018496-04
84115	2	22	\N		1	t	2019-09-19 15:12:56.018496-04
84116	2	22	\N		1	t	2019-09-19 15:12:56.018496-04
84117	2	22	\N		1	t	2019-09-19 15:12:56.018496-04
84118	2	22	\N		1	t	2019-09-19 15:12:56.018496-04
84119	2	22	\N		1	t	2019-09-19 15:12:56.018496-04
84120	2	22	\N		1	t	2019-09-19 15:12:56.018496-04
84121	2	22	\N		1	t	2019-09-19 15:12:56.018496-04
84122	2	22	\N		1	t	2019-09-19 15:12:56.018496-04
84123	2	22	\N		1	t	2019-09-19 15:12:56.018496-04
84124	2	22	\N		1	t	2019-09-19 15:12:56.018496-04
84125	2	22	\N		1	t	2019-09-19 15:12:56.018496-04
84126	2	22	\N		1	t	2019-09-19 15:12:56.018496-04
84127	2	22	\N		1	t	2019-09-19 15:12:56.018496-04
84128	2	22	\N		1	t	2019-09-19 15:12:56.018496-04
84129	2	22	\N		1	t	2019-09-19 15:12:56.018496-04
84130	2	22	\N		1	t	2019-09-19 15:12:56.018496-04
84131	2	22	\N		1	t	2019-09-19 15:12:56.018496-04
84132	2	22	\N		1	t	2019-09-19 15:12:56.018496-04
84133	1	19	\N		1	t	2019-09-19 15:12:56.018496-04
84134	2	22	\N		1	t	2019-09-19 15:12:56.018496-04
84135	2	22	\N		1	t	2019-09-19 15:12:56.018496-04
84136	2	22	\N		1	t	2019-09-19 15:12:56.018496-04
84137	1	19	\N		1	t	2019-09-19 15:12:56.018496-04
84138	2	22	\N		1	t	2019-09-19 15:12:56.018496-04
84139	1	19	\N		1	t	2019-09-19 15:12:56.018496-04
84140	2	22	\N		1	t	2019-09-19 15:12:56.018496-04
84141	2	22	\N		1	t	2019-09-19 15:12:56.018496-04
84142	2	22	\N		1	t	2019-09-19 15:12:56.018496-04
84143	1	19	\N		1	t	2019-09-19 15:12:56.018496-04
84144	2	22	\N		1	t	2019-09-19 15:12:56.018496-04
84145	1	19	\N		1	t	2019-09-19 15:12:56.018496-04
84146	2	22	\N		1	t	2019-09-19 15:12:56.018496-04
84147	2	22	\N		1	t	2019-09-19 15:12:56.018496-04
84148	2	22	\N		1	t	2019-09-19 15:12:56.018496-04
84149	1	19	\N		1	t	2019-09-19 15:12:56.018496-04
84150	1	19	\N		1	t	2019-09-19 15:12:56.018496-04
84151	2	22	\N		1	t	2019-09-19 15:12:56.018496-04
84152	2	22	\N		1	t	2019-09-19 15:12:56.018496-04
84153	2	22	\N		1	t	2019-09-19 15:12:56.018496-04
84154	1	19	\N		1	t	2019-09-19 15:12:56.018496-04
84204	1	19	\N		1	t	2019-09-19 15:14:06.721307-04
84205	2	22	\N		1	t	2019-09-19 15:14:06.721307-04
84206	2	22	\N		1	t	2019-09-19 15:14:06.721307-04
84207	2	22	\N		1	t	2019-09-19 15:14:06.721307-04
84208	2	22	\N		1	t	2019-09-19 15:14:06.721307-04
84209	2	22	\N		1	t	2019-09-19 15:14:06.721307-04
84210	2	22	\N		1	t	2019-09-19 15:14:06.721307-04
84211	2	22	\N		1	t	2019-09-19 15:14:06.721307-04
84212	2	22	\N		1	t	2019-09-19 15:14:06.721307-04
84213	2	22	\N		1	t	2019-09-19 15:14:06.721307-04
84214	2	22	\N		1	t	2019-09-19 15:14:06.721307-04
84215	2	22	\N		1	t	2019-09-19 15:14:06.721307-04
84216	2	22	\N		1	t	2019-09-19 15:14:06.721307-04
84217	2	22	\N		1	t	2019-09-19 15:14:06.721307-04
84218	2	22	\N		1	t	2019-09-19 15:14:06.721307-04
84220	1	19	\N		1	t	2019-09-19 15:14:06.721307-04
84221	2	22	\N		1	t	2019-09-19 15:14:06.721307-04
84222	2	22	\N		1	t	2019-09-19 15:14:06.721307-04
84223	2	22	\N		1	t	2019-09-19 15:14:06.721307-04
84224	2	22	\N		1	t	2019-09-19 15:14:06.721307-04
84225	2	22	\N		1	t	2019-09-19 15:14:06.721307-04
84226	2	22	\N		1	t	2019-09-19 15:14:06.721307-04
84227	2	22	\N		1	t	2019-09-19 15:14:06.721307-04
84228	2	22	\N		1	t	2019-09-19 15:14:06.721307-04
84229	2	22	\N		1	t	2019-09-19 15:14:06.721307-04
84230	2	22	\N		1	t	2019-09-19 15:14:06.721307-04
84231	2	22	\N		1	t	2019-09-19 15:14:06.721307-04
84232	2	22	\N		1	t	2019-09-19 15:14:06.721307-04
84233	2	22	\N		1	t	2019-09-19 15:14:06.721307-04
84234	2	22	\N		1	t	2019-09-19 15:14:06.721307-04
84235	1	19	\N		1	t	2019-09-19 15:14:06.721307-04
84236	2	22	\N		1	t	2019-09-19 15:14:06.721307-04
84237	2	22	\N		1	t	2019-09-19 15:14:06.721307-04
84238	2	22	\N		1	t	2019-09-19 15:14:06.721307-04
84239	2	22	\N		1	t	2019-09-19 15:14:06.721307-04
84240	2	22	\N		1	t	2019-09-19 15:14:06.721307-04
84241	2	22	\N		1	t	2019-09-19 15:14:06.721307-04
84242	2	22	\N		1	t	2019-09-19 15:14:06.721307-04
84243	2	22	\N		1	t	2019-09-19 15:14:06.721307-04
84245	2	22	\N		1	t	2019-09-19 15:14:06.721307-04
84246	2	22	\N		1	t	2019-09-19 15:14:06.721307-04
84247	2	22	\N		1	t	2019-09-19 15:14:06.721307-04
84248	2	22	\N		1	t	2019-09-19 15:14:06.721307-04
84249	2	22	\N		1	t	2019-09-19 15:14:06.721307-04
84250	2	22	\N		1	t	2019-09-19 15:14:06.721307-04
84251	2	22	\N		1	t	2019-09-19 15:14:06.721307-04
84252	2	22	\N		1	t	2019-09-19 15:14:06.721307-04
84253	2	22	\N		1	t	2019-09-19 15:14:06.721307-04
84254	2	22	\N		1	t	2019-09-19 15:14:06.721307-04
84255	1	19	\N		1	t	2019-09-19 15:14:06.721307-04
84256	1	19	\N		1	t	2019-09-19 15:14:06.721307-04
84257	1	19	\N		1	t	2019-09-19 15:14:06.721307-04
84258	2	22	\N		1	t	2019-09-19 15:14:06.721307-04
84259	1	19	\N		1	t	2019-09-19 15:14:06.721307-04
84260	2	22	\N		1	t	2019-09-19 15:14:06.721307-04
84261	1	19	\N		1	t	2019-09-19 15:14:06.721307-04
84262	2	22	\N		1	t	2019-09-19 15:14:06.721307-04
84263	2	22	\N		1	t	2019-09-19 15:14:06.721307-04
84264	2	22	\N		1	t	2019-09-19 15:14:06.721307-04
84265	2	22	\N		1	t	2019-09-19 15:14:06.721307-04
84266	2	22	\N		1	t	2019-09-19 15:14:06.721307-04
84267	2	22	\N		1	t	2019-09-19 15:14:06.721307-04
84268	2	22	\N		1	t	2019-09-19 15:14:06.721307-04
84269	1	19	\N		1	t	2019-09-19 15:14:06.721307-04
84270	2	22	\N		1	t	2019-09-19 15:14:06.721307-04
84271	2	22	\N		1	t	2019-09-19 15:14:06.721307-04
84272	2	22	\N		1	t	2019-09-19 15:14:06.721307-04
84273	2	22	\N		1	t	2019-09-19 15:14:06.721307-04
84274	2	22	\N		1	t	2019-09-19 15:14:06.721307-04
84275	2	22	\N		1	t	2019-09-19 15:14:06.721307-04
84276	2	22	\N		1	t	2019-09-19 15:14:06.721307-04
84277	2	22	\N		1	t	2019-09-19 15:14:06.721307-04
84278	1	19	\N		1	t	2019-09-19 15:14:06.721307-04
84279	2	22	\N		1	t	2019-09-19 15:14:06.721307-04
84280	2	22	\N		1	t	2019-09-19 15:14:06.721307-04
84155	2	22	\N		1	t	2019-09-19 15:13:20.113894-04
84156	1	19	\N		1	t	2019-09-19 15:13:20.113894-04
84157	2	22	\N		1	t	2019-09-19 15:13:20.113894-04
84158	2	22	\N		1	t	2019-09-19 15:13:20.113894-04
84159	2	22	\N		1	t	2019-09-19 15:13:20.113894-04
84160	1	19	\N		1	t	2019-09-19 15:13:20.113894-04
84161	2	22	\N		1	t	2019-09-19 15:13:20.113894-04
84162	2	22	\N		1	t	2019-09-19 15:13:20.113894-04
84163	2	22	\N		1	t	2019-09-19 15:13:20.113894-04
84164	2	22	\N		1	t	2019-09-19 15:13:20.113894-04
84165	2	22	\N		1	t	2019-09-19 15:13:20.113894-04
84166	2	22	\N		1	t	2019-09-19 15:13:20.113894-04
84167	2	22	\N		1	t	2019-09-19 15:13:20.113894-04
84168	1	19	\N		1	t	2019-09-19 15:13:20.113894-04
84169	2	22	\N		1	t	2019-09-19 15:13:20.113894-04
84170	2	22	\N		1	t	2019-09-19 15:13:20.113894-04
84171	2	22	\N		1	t	2019-09-19 15:13:20.113894-04
84172	1	19	\N		1	t	2019-09-19 15:13:20.113894-04
84173	2	22	\N		1	t	2019-09-19 15:13:20.113894-04
84174	2	22	\N		1	t	2019-09-19 15:13:20.113894-04
84175	2	22	\N		1	t	2019-09-19 15:13:20.113894-04
84176	2	22	\N		1	t	2019-09-19 15:13:20.113894-04
84177	2	22	\N		1	t	2019-09-19 15:13:20.113894-04
84178	2	22	\N		1	t	2019-09-19 15:13:20.113894-04
84179	2	22	\N		1	t	2019-09-19 15:13:20.113894-04
84180	2	22	\N		1	t	2019-09-19 15:13:20.113894-04
84181	2	22	\N		1	t	2019-09-19 15:13:20.113894-04
84182	2	22	\N		1	t	2019-09-19 15:13:20.113894-04
84183	2	22	\N		1	t	2019-09-19 15:13:20.113894-04
84184	2	22	\N		1	t	2019-09-19 15:13:20.113894-04
84185	1	19	\N		1	t	2019-09-19 15:13:20.113894-04
84186	2	22	\N		1	t	2019-09-19 15:13:20.113894-04
84187	2	22	\N		1	t	2019-09-19 15:13:20.113894-04
84188	2	22	\N		1	t	2019-09-19 15:13:20.113894-04
84189	2	22	\N		1	t	2019-09-19 15:13:20.113894-04
84190	2	22	\N		1	t	2019-09-19 15:13:20.113894-04
84191	1	19	\N		1	t	2019-09-19 15:13:20.113894-04
84281	2	22	\N		1	t	2019-09-19 15:14:06.721307-04
84282	2	22	\N		1	t	2019-09-19 15:14:06.721307-04
84283	2	22	\N		1	t	2019-09-19 15:14:06.721307-04
84284	1	19	\N		1	t	2019-09-19 15:14:06.721307-04
84285	2	22	\N		1	t	2019-09-19 15:14:06.721307-04
84286	2	22	\N		1	t	2019-09-19 15:14:06.721307-04
84287	1	19	\N		1	t	2019-09-19 15:14:06.721307-04
84288	2	22	\N		1	t	2019-09-19 15:14:06.721307-04
84289	2	22	\N		1	t	2019-09-19 15:14:06.721307-04
84290	2	22	\N		1	t	2019-09-19 15:14:06.721307-04
84291	2	22	\N		1	t	2019-09-19 15:14:06.721307-04
84292	2	22	\N		1	t	2019-09-19 15:14:06.721307-04
84293	2	22	\N		1	t	2019-09-19 15:14:06.721307-04
84294	2	22	\N		1	t	2019-09-19 15:14:06.721307-04
84295	2	22	\N		1	t	2019-09-19 15:14:06.721307-04
84296	2	22	\N		1	t	2019-09-19 15:14:06.721307-04
84297	2	22	\N		1	t	2019-09-19 15:14:06.721307-04
84298	2	22	\N		1	t	2019-09-19 15:14:06.721307-04
84299	2	22	\N		1	t	2019-09-19 15:14:06.721307-04
84300	2	22	\N		1	t	2019-09-19 15:14:06.721307-04
84301	2	22	\N		1	t	2019-09-19 15:14:06.721307-04
84302	2	22	\N		1	t	2019-09-19 15:14:06.721307-04
84303	2	22	\N		1	t	2019-09-19 15:14:06.721307-04
84304	2	22	\N		1	t	2019-09-19 15:14:06.721307-04
84305	2	22	\N		1	t	2019-09-19 15:14:06.721307-04
84306	1	19	\N		1	t	2019-09-19 15:14:06.721307-04
84307	2	22	\N		1	t	2019-09-19 15:14:06.721307-04
84308	2	22	\N		1	t	2019-09-19 15:14:06.721307-04
84309	1	19	\N		1	t	2019-09-19 15:14:06.721307-04
84310	2	22	\N		1	t	2019-09-19 15:14:06.721307-04
84311	2	22	\N		1	t	2019-09-19 15:14:06.721307-04
84312	2	22	\N		1	t	2019-09-19 15:14:06.721307-04
84313	2	22	\N		1	t	2019-09-19 15:14:06.721307-04
84314	2	22	\N		1	t	2019-09-19 15:14:06.721307-04
84315	2	22	\N		1	t	2019-09-19 15:14:06.721307-04
84316	1	19	\N		1	t	2019-09-19 15:14:06.721307-04
84317	2	22	\N		1	t	2019-09-19 15:14:06.721307-04
84318	2	22	\N		1	t	2019-09-19 15:14:06.721307-04
84319	2	22	\N		1	t	2019-09-19 15:14:06.721307-04
84320	2	22	\N		1	t	2019-09-19 15:14:06.721307-04
84321	2	22	\N		1	t	2019-09-19 15:14:06.721307-04
84322	2	22	\N		1	t	2019-09-19 15:14:06.721307-04
84323	1	19	\N		1	t	2019-09-19 15:14:06.721307-04
84324	2	22	\N		1	t	2019-09-19 15:14:06.721307-04
84325	2	22	\N		1	t	2019-09-19 15:14:06.721307-04
84326	2	22	\N		1	t	2019-09-19 15:14:06.721307-04
84327	2	22	\N		1	t	2019-09-19 15:14:06.721307-04
84328	2	22	\N		1	t	2019-09-19 15:14:06.721307-04
84329	1	19	\N		1	t	2019-09-19 15:14:06.721307-04
84330	2	22	\N		1	t	2019-09-19 15:14:06.721307-04
84331	2	22	\N		1	t	2019-09-19 15:14:06.721307-04
84332	1	19	\N		1	t	2019-09-19 15:14:06.721307-04
84333	2	22	\N		1	t	2019-09-19 15:14:06.721307-04
80117	1	19	\N		1	t	2019-09-10 16:27:38.925803-04
80118	2	22	\N		1	t	2019-09-10 16:27:38.925803-04
80119	2	22	\N		1	t	2019-09-10 16:27:38.925803-04
80120	2	22	\N		1	t	2019-09-10 16:27:38.925803-04
80121	2	22	\N		1	t	2019-09-10 16:27:38.925803-04
80122	2	22	\N		1	t	2019-09-10 16:27:38.925803-04
80123	2	22	\N		1	t	2019-09-10 16:27:38.925803-04
80124	2	22	\N		1	t	2019-09-10 16:27:38.925803-04
80125	2	22	\N		1	t	2019-09-10 16:27:38.925803-04
80126	2	22	\N		1	t	2019-09-10 16:27:38.925803-04
80127	2	22	\N		1	t	2019-09-10 16:27:38.925803-04
80128	1	19	\N		1	t	2019-09-10 16:27:38.925803-04
80129	2	22	\N		1	t	2019-09-10 16:27:38.925803-04
80130	2	22	\N		1	t	2019-09-10 16:27:38.925803-04
80131	2	22	\N		1	t	2019-09-10 16:27:38.925803-04
80132	2	22	\N		1	t	2019-09-10 16:27:38.925803-04
80133	1	19	\N		1	t	2019-09-10 16:27:38.925803-04
80134	1	19	\N		1	t	2019-09-10 16:27:38.925803-04
80135	2	22	\N		1	t	2019-09-10 16:27:38.925803-04
80136	2	22	\N		1	t	2019-09-10 16:27:38.925803-04
80137	2	22	\N		1	t	2019-09-10 16:27:38.925803-04
80138	2	22	\N		1	t	2019-09-10 16:27:38.925803-04
80139	2	22	\N		1	t	2019-09-10 16:27:38.925803-04
80140	2	22	\N		1	t	2019-09-10 16:27:38.925803-04
80141	2	22	\N		1	t	2019-09-10 16:27:38.925803-04
80142	2	22	\N		1	t	2019-09-10 16:27:38.925803-04
80143	2	22	\N		1	t	2019-09-10 16:27:38.925803-04
80144	1	19	\N		1	t	2019-09-10 16:27:38.925803-04
80145	2	22	\N		1	t	2019-09-10 16:27:38.925803-04
80146	2	22	\N		1	t	2019-09-10 16:27:38.925803-04
80147	1	19	\N		1	t	2019-09-10 16:27:38.925803-04
80148	2	22	\N		1	t	2019-09-10 16:27:38.925803-04
80149	1	19	\N		1	t	2019-09-10 16:27:38.925803-04
80298	2	22	\N		1	t	2019-09-10 21:34:37.270879-04
80299	2	22	\N		1	t	2019-09-10 21:34:37.270879-04
80300	2	22	\N		1	t	2019-09-10 21:34:37.270879-04
80301	2	22	\N		1	t	2019-09-10 21:34:37.270879-04
80302	2	22	\N		1	t	2019-09-10 21:34:37.270879-04
80303	2	22	\N		1	t	2019-09-10 21:34:37.270879-04
80304	2	22	\N		1	t	2019-09-10 21:34:37.270879-04
80305	2	22	\N		1	t	2019-09-10 21:34:37.270879-04
80306	2	22	\N		1	t	2019-09-10 21:34:37.270879-04
80307	2	22	\N		1	t	2019-09-10 21:34:37.270879-04
80308	2	22	\N		1	t	2019-09-10 21:34:37.270879-04
80309	2	22	\N		1	t	2019-09-10 21:34:37.270879-04
80310	1	19	\N		1	t	2019-09-10 21:34:37.270879-04
80311	2	22	\N		1	t	2019-09-11 10:10:31.248153-04
80312	2	22	\N		1	t	2019-09-11 10:10:31.248153-04
80313	2	22	\N		1	t	2019-09-11 10:10:31.248153-04
80314	2	22	\N		1	t	2019-09-11 10:10:31.248153-04
80315	2	22	\N		1	t	2019-09-11 10:10:31.248153-04
80316	2	22	\N		1	t	2019-09-11 10:10:31.248153-04
80317	2	22	\N		1	t	2019-09-11 10:10:31.248153-04
80318	2	22	\N		1	t	2019-09-11 10:10:31.248153-04
80319	1	19	\N		1	t	2019-09-11 10:10:31.248153-04
80320	1	19	\N		1	t	2019-09-11 10:10:31.248153-04
80321	2	22	\N		1	t	2019-09-11 10:10:31.248153-04
80322	2	22	\N		1	t	2019-09-11 10:10:31.248153-04
80323	2	22	\N		1	t	2019-09-11 10:10:31.248153-04
80324	2	22	\N		1	t	2019-09-11 10:10:31.248153-04
80325	2	22	\N		1	t	2019-09-11 10:10:31.248153-04
80326	2	22	\N		1	t	2019-09-11 10:10:31.248153-04
80327	2	22	\N		1	t	2019-09-11 10:10:31.248153-04
80328	2	22	\N		1	t	2019-09-11 10:10:31.248153-04
80329	2	22	\N		1	t	2019-09-11 10:10:31.248153-04
80330	2	22	\N		1	t	2019-09-11 10:10:31.248153-04
80331	2	22	\N		1	t	2019-09-11 10:10:31.248153-04
80332	1	19	\N		1	t	2019-09-11 10:10:31.248153-04
80333	1	19	\N		1	t	2019-09-11 10:10:31.248153-04
80334	1	19	\N		1	t	2019-09-11 10:10:31.248153-04
80335	2	22	\N		1	t	2019-09-11 10:10:31.248153-04
80336	1	19	\N		1	t	2019-09-11 10:10:31.248153-04
80337	2	22	\N		1	t	2019-09-11 10:10:31.248153-04
80338	2	22	\N		1	t	2019-09-11 10:10:31.248153-04
80339	2	22	\N		1	t	2019-09-11 10:10:31.248153-04
80340	2	22	\N		1	t	2019-09-11 10:10:31.248153-04
80341	2	22	\N		1	t	2019-09-11 10:10:31.248153-04
80342	2	22	\N		1	t	2019-09-11 10:10:31.248153-04
80343	2	22	\N		1	t	2019-09-11 10:10:31.248153-04
80344	1	19	\N		1	t	2019-09-11 13:53:19.093511-04
80345	2	22	\N		1	t	2019-09-11 13:53:19.093511-04
80346	2	22	\N		1	t	2019-09-11 13:53:19.093511-04
80347	2	22	\N		1	t	2019-09-11 13:53:19.093511-04
80348	2	22	\N		1	t	2019-09-11 13:53:19.093511-04
80349	2	22	\N		1	t	2019-09-11 13:53:19.093511-04
80350	2	22	\N		1	t	2019-09-11 13:53:19.093511-04
80351	2	22	\N		1	t	2019-09-11 13:53:19.093511-04
80352	2	22	\N		1	t	2019-09-11 13:53:19.093511-04
80353	2	22	\N		1	t	2019-09-11 13:53:19.093511-04
80354	2	22	\N		1	t	2019-09-11 13:53:19.093511-04
80355	2	22	\N		1	t	2019-09-11 13:53:19.093511-04
80356	2	22	\N		1	t	2019-09-11 13:53:19.093511-04
80357	2	22	\N		1	t	2019-09-11 13:53:19.093511-04
80358	2	22	\N		1	t	2019-09-11 13:53:19.093511-04
80360	1	19	\N		1	t	2019-09-11 13:53:19.093511-04
80361	2	22	\N		1	t	2019-09-11 13:53:19.093511-04
80362	2	22	\N		1	t	2019-09-11 13:53:19.093511-04
80363	2	22	\N		1	t	2019-09-11 13:53:19.093511-04
80364	2	22	\N		1	t	2019-09-11 13:53:19.093511-04
80365	2	22	\N		1	t	2019-09-11 13:53:19.093511-04
80366	2	22	\N		1	t	2019-09-11 13:53:19.093511-04
80367	2	22	\N		1	t	2019-09-11 13:53:19.093511-04
80368	2	22	\N		1	t	2019-09-11 13:53:19.093511-04
80369	2	22	\N		1	t	2019-09-11 13:53:19.093511-04
80370	2	22	\N		1	t	2019-09-11 13:53:19.093511-04
80371	2	22	\N		1	t	2019-09-11 13:53:19.093511-04
80372	2	22	\N		1	t	2019-09-11 13:53:19.093511-04
80373	2	22	\N		1	t	2019-09-11 13:53:19.093511-04
80374	2	22	\N		1	t	2019-09-11 13:53:19.093511-04
80375	1	19	\N		1	t	2019-09-11 13:53:19.093511-04
80376	2	22	\N		1	t	2019-09-11 13:53:19.093511-04
80377	2	22	\N		1	t	2019-09-11 13:53:19.093511-04
80378	2	22	\N		1	t	2019-09-11 13:53:19.093511-04
80379	2	22	\N		1	t	2019-09-11 13:53:19.093511-04
80380	2	22	\N		1	t	2019-09-11 13:53:19.093511-04
80381	2	22	\N		1	t	2019-09-11 13:53:19.093511-04
80382	2	22	\N		1	t	2019-09-11 13:53:19.093511-04
80383	2	22	\N		1	t	2019-09-11 13:53:19.093511-04
80384	2	22	\N		1	t	2019-09-11 13:53:19.093511-04
80385	2	22	\N		1	t	2019-09-11 13:53:19.093511-04
80386	2	22	\N		1	t	2019-09-11 13:53:19.093511-04
80387	2	22	\N		1	t	2019-09-11 13:53:19.093511-04
80388	2	22	\N		1	t	2019-09-11 13:53:19.093511-04
80389	2	22	\N		1	t	2019-09-11 13:53:19.093511-04
80390	2	22	\N		1	t	2019-09-11 13:53:19.093511-04
80391	2	22	\N		1	t	2019-09-11 13:53:19.093511-04
80392	2	22	\N		1	t	2019-09-11 13:53:19.093511-04
80393	2	22	\N		1	t	2019-09-11 13:53:19.093511-04
80394	2	22	\N		1	t	2019-09-11 13:53:19.093511-04
80395	1	19	\N		1	t	2019-09-11 13:53:19.093511-04
80396	1	19	\N		1	t	2019-09-11 13:53:19.093511-04
80397	1	19	\N		1	t	2019-09-11 13:53:19.093511-04
80398	2	22	\N		1	t	2019-09-11 13:53:19.093511-04
80399	1	19	\N		1	t	2019-09-11 13:53:19.093511-04
80400	2	22	\N		1	t	2019-09-11 13:53:19.093511-04
80401	1	19	\N		1	t	2019-09-11 13:53:19.093511-04
80402	2	22	\N		1	t	2019-09-11 13:53:19.093511-04
80403	2	22	\N		1	t	2019-09-11 13:53:19.093511-04
80404	2	22	\N		1	t	2019-09-11 13:53:19.093511-04
80405	2	22	\N		1	t	2019-09-11 13:53:19.093511-04
80406	2	22	\N		1	t	2019-09-11 13:53:19.093511-04
80407	2	22	\N		1	t	2019-09-11 13:53:19.093511-04
80408	2	22	\N		1	t	2019-09-11 13:53:19.093511-04
80409	1	19	\N		1	t	2019-09-11 13:53:19.093511-04
80410	2	22	\N		1	t	2019-09-11 13:53:19.093511-04
80411	2	22	\N		1	t	2019-09-11 13:53:19.093511-04
80412	2	22	\N		1	t	2019-09-11 13:53:19.093511-04
80413	2	22	\N		1	t	2019-09-11 13:53:19.093511-04
80414	2	22	\N		1	t	2019-09-11 13:53:19.093511-04
80415	2	22	\N		1	t	2019-09-11 13:53:19.093511-04
80416	2	22	\N		1	t	2019-09-11 13:53:19.093511-04
80417	2	22	\N		1	t	2019-09-11 13:53:19.093511-04
80418	1	19	\N		1	t	2019-09-11 13:53:19.093511-04
80419	2	22	\N		1	t	2019-09-11 13:53:19.093511-04
80420	2	22	\N		1	t	2019-09-11 13:53:19.093511-04
80421	2	22	\N		1	t	2019-09-11 13:53:19.093511-04
80422	2	22	\N		1	t	2019-09-11 13:53:19.093511-04
80423	2	22	\N		1	t	2019-09-11 13:53:19.093511-04
80424	1	19	\N		1	t	2019-09-11 13:53:19.093511-04
80425	2	22	\N		1	t	2019-09-11 13:53:19.093511-04
80426	2	22	\N		1	t	2019-09-11 13:53:19.093511-04
80427	1	19	\N		1	t	2019-09-11 13:53:19.093511-04
80428	2	22	\N		1	t	2019-09-11 13:53:19.093511-04
80429	2	22	\N		1	t	2019-09-11 13:53:19.093511-04
80430	2	22	\N		1	t	2019-09-11 13:53:19.093511-04
80431	2	22	\N		1	t	2019-09-11 13:53:19.093511-04
80432	2	22	\N		1	t	2019-09-11 13:53:19.093511-04
80433	2	22	\N		1	t	2019-09-11 13:53:19.093511-04
80434	2	22	\N		1	t	2019-09-11 13:53:19.093511-04
80435	2	22	\N		1	t	2019-09-11 13:53:19.093511-04
80436	2	22	\N		1	t	2019-09-11 13:53:19.093511-04
80437	2	22	\N		1	t	2019-09-11 13:53:19.093511-04
80438	2	22	\N		1	t	2019-09-11 13:53:19.093511-04
80439	2	22	\N		1	t	2019-09-11 13:53:19.093511-04
80440	2	22	\N		1	t	2019-09-11 13:53:19.093511-04
80441	2	22	\N		1	t	2019-09-11 13:53:19.093511-04
80442	2	22	\N		1	t	2019-09-11 13:53:19.093511-04
80443	2	22	\N		1	t	2019-09-11 13:53:19.093511-04
80444	2	22	\N		1	t	2019-09-11 13:53:19.093511-04
80445	2	22	\N		1	t	2019-09-11 13:53:19.093511-04
80446	1	19	\N		1	t	2019-09-11 13:53:19.093511-04
80447	2	22	\N		1	t	2019-09-11 13:53:19.093511-04
80448	2	22	\N		1	t	2019-09-11 13:53:19.093511-04
80449	1	19	\N		1	t	2019-09-11 13:53:19.093511-04
80450	2	22	\N		1	t	2019-09-11 13:53:19.093511-04
80451	2	22	\N		1	t	2019-09-11 13:53:19.093511-04
80452	2	22	\N		1	t	2019-09-11 13:53:19.093511-04
80453	2	22	\N		1	t	2019-09-11 13:53:19.093511-04
80454	2	22	\N		1	t	2019-09-11 13:53:19.093511-04
80455	2	22	\N		1	t	2019-09-11 13:53:19.093511-04
80456	1	19	\N		1	t	2019-09-11 13:53:19.093511-04
80457	2	22	\N		1	t	2019-09-11 13:53:19.093511-04
80458	2	22	\N		1	t	2019-09-11 13:53:19.093511-04
80459	2	22	\N		1	t	2019-09-11 13:53:19.093511-04
80460	2	22	\N		1	t	2019-09-11 13:53:19.093511-04
80461	2	22	\N		1	t	2019-09-11 13:53:19.093511-04
80462	2	22	\N		1	t	2019-09-11 13:53:19.093511-04
80463	1	19	\N		1	t	2019-09-11 13:53:19.093511-04
80464	2	22	\N		1	t	2019-09-11 13:53:19.093511-04
80465	2	22	\N		1	t	2019-09-11 13:53:19.093511-04
80466	2	22	\N		1	t	2019-09-11 13:53:19.093511-04
80467	2	22	\N		1	t	2019-09-11 13:53:19.093511-04
80468	2	22	\N		1	t	2019-09-11 13:53:19.093511-04
80469	1	19	\N		1	t	2019-09-11 13:53:19.093511-04
80470	2	22	\N		1	t	2019-09-11 13:53:19.093511-04
80471	2	22	\N		1	t	2019-09-11 13:53:19.093511-04
80472	1	19	\N		1	t	2019-09-11 13:53:19.093511-04
80473	2	22	\N		1	t	2019-09-11 13:53:19.093511-04
80474	2	22	\N		1	t	2019-09-11 13:53:19.093511-04
80475	2	22	\N		1	t	2019-09-11 13:53:19.093511-04
80476	2	22	\N		1	t	2019-09-11 13:53:19.093511-04
80477	2	22	\N		1	t	2019-09-11 13:53:19.093511-04
80478	2	22	\N		1	t	2019-09-11 13:53:19.093511-04
80479	2	22	\N		1	t	2019-09-11 13:53:19.093511-04
80480	2	22	\N		1	t	2019-09-11 13:53:19.093511-04
80481	2	22	\N		1	t	2019-09-11 13:53:19.093511-04
80482	2	22	\N		1	t	2019-09-11 13:53:19.093511-04
80483	2	22	\N		1	t	2019-09-11 13:53:19.093511-04
80484	2	22	\N		1	t	2019-09-11 13:53:19.093511-04
80485	1	19	\N		1	t	2019-09-11 13:53:19.093511-04
80486	2	22	\N		1	t	2019-09-11 13:53:19.093511-04
80487	2	22	\N		1	t	2019-09-11 13:53:19.093511-04
80488	1	19	\N		1	t	2019-09-11 13:53:19.093511-04
80489	2	22	\N		1	t	2019-09-11 13:53:19.093511-04
80490	2	22	\N		1	t	2019-09-11 13:53:19.093511-04
80491	2	22	\N		1	t	2019-09-11 13:53:19.093511-04
80492	2	22	\N		1	t	2019-09-11 13:53:19.093511-04
80493	2	22	\N		1	t	2019-09-11 13:53:19.093511-04
80494	1	19	\N		1	t	2019-09-11 13:53:19.093511-04
80495	1	19	\N		1	t	2019-09-11 13:53:19.093511-04
80496	2	22	\N		1	t	2019-09-11 13:53:19.093511-04
80497	2	22	\N		1	t	2019-09-11 13:53:19.093511-04
80498	2	22	\N		1	t	2019-09-11 13:53:19.093511-04
80499	2	22	\N		1	t	2019-09-11 13:53:19.093511-04
80500	2	22	\N		1	t	2019-09-11 13:53:19.093511-04
80501	2	22	\N		1	t	2019-09-11 13:53:19.093511-04
80502	2	22	\N		1	t	2019-09-11 13:53:19.093511-04
80503	2	22	\N		1	t	2019-09-11 13:53:19.093511-04
80504	2	22	\N		1	t	2019-09-11 13:53:19.093511-04
80505	2	22	\N		1	t	2019-09-11 13:53:19.093511-04
80506	2	22	\N		1	t	2019-09-11 13:53:19.093511-04
80507	2	22	\N		1	t	2019-09-11 13:53:19.093511-04
80508	2	22	\N		1	t	2019-09-11 13:53:19.093511-04
80509	2	22	\N		1	t	2019-09-11 13:53:19.093511-04
80510	1	19	\N		1	t	2019-09-11 13:53:19.093511-04
80511	2	22	\N		1	t	2019-09-11 13:53:19.093511-04
80512	2	22	\N		1	t	2019-09-11 13:53:19.093511-04
80513	2	22	\N		1	t	2019-09-11 13:53:19.093511-04
80514	2	22	\N		1	t	2019-09-11 13:53:19.093511-04
80515	2	22	\N		1	t	2019-09-11 13:53:19.093511-04
80516	2	22	\N		1	t	2019-09-11 13:53:19.093511-04
80517	2	22	\N		1	t	2019-09-11 13:53:19.093511-04
80518	2	22	\N		1	t	2019-09-11 13:53:19.093511-04
80519	2	22	\N		1	t	2019-09-11 13:53:19.093511-04
80520	1	19	\N		1	t	2019-09-11 13:53:19.093511-04
80521	2	22	\N		1	t	2019-09-11 13:53:19.093511-04
80522	2	22	\N		1	t	2019-09-11 13:53:19.093511-04
80523	2	22	\N		1	t	2019-09-11 13:53:19.093511-04
80524	2	22	\N		1	t	2019-09-11 13:53:19.093511-04
80525	2	22	\N		1	t	2019-09-11 13:53:19.093511-04
80526	2	22	\N		1	t	2019-09-11 13:53:19.093511-04
80527	2	22	\N		1	t	2019-09-11 13:53:19.093511-04
80528	2	22	\N		1	t	2019-09-11 13:53:19.093511-04
80529	2	22	\N		1	t	2019-09-11 13:53:19.093511-04
80530	2	22	\N		1	t	2019-09-11 13:53:19.093511-04
80531	2	22	\N		1	t	2019-09-11 13:53:19.093511-04
80532	2	22	\N		1	t	2019-09-11 13:53:19.093511-04
80533	1	19	\N		1	t	2019-09-11 13:53:19.093511-04
80534	1	19	\N		1	t	2019-09-11 13:53:19.093511-04
80535	2	22	\N		1	t	2019-09-11 13:53:19.093511-04
80536	2	22	\N		1	t	2019-09-11 13:53:19.093511-04
80537	2	22	\N		1	t	2019-09-11 13:53:19.093511-04
80538	2	22	\N		1	t	2019-09-11 13:53:19.093511-04
80539	2	22	\N		1	t	2019-09-11 13:53:19.093511-04
80540	2	22	\N		1	t	2019-09-11 13:53:19.093511-04
80541	2	22	\N		1	t	2019-09-11 13:53:19.093511-04
80542	2	22	\N		1	t	2019-09-11 13:53:19.093511-04
80543	2	22	\N		1	t	2019-09-11 13:53:19.093511-04
80544	2	22	\N		1	t	2019-09-11 13:53:19.093511-04
83359	2	22	\N		1	t	2019-09-13 16:46:32.418097-04
83360	1	19	\N		1	t	2019-09-13 16:46:32.418097-04
83361	1	19	\N		1	t	2019-09-13 16:46:32.418097-04
83362	2	22	\N		1	t	2019-09-13 16:46:32.418097-04
83363	1	19	\N		1	t	2019-09-13 16:46:32.418097-04
83364	1	19	\N		1	t	2019-09-13 16:46:32.418097-04
83365	2	22	\N		1	t	2019-09-13 16:46:32.418097-04
83366	2	22	\N		1	t	2019-09-13 16:46:32.418097-04
83367	2	22	\N		1	t	2019-09-13 16:46:32.418097-04
83368	2	22	\N		1	t	2019-09-13 16:46:32.418097-04
83369	2	22	\N		1	t	2019-09-13 16:46:32.418097-04
83370	2	22	\N		1	t	2019-09-13 16:46:32.418097-04
83371	2	22	\N		1	t	2019-09-13 16:46:32.418097-04
83372	2	22	\N		1	t	2019-09-13 16:46:32.418097-04
83373	1	19	\N		1	t	2019-09-13 16:46:32.418097-04
83374	2	22	\N		1	t	2019-09-13 16:46:32.418097-04
83375	2	22	\N		1	t	2019-09-13 16:46:32.418097-04
83376	2	22	\N		1	t	2019-09-13 16:46:32.418097-04
83377	2	22	\N		1	t	2019-09-13 16:46:32.418097-04
83378	2	22	\N		1	t	2019-09-13 16:46:32.418097-04
83379	1	19	\N		1	t	2019-09-13 16:46:32.418097-04
84192	2	22	\N		1	t	2019-09-19 15:13:41.223915-04
84193	2	22	\N		1	t	2019-09-19 15:13:41.223915-04
84195	2	22	\N		1	t	2019-09-19 15:13:41.223915-04
84196	2	22	\N		1	t	2019-09-19 15:13:41.223915-04
84197	2	22	\N		1	t	2019-09-19 15:13:41.223915-04
84198	2	22	\N		1	t	2019-09-19 15:13:41.223915-04
84199	1	19	\N		1	t	2019-09-19 15:13:41.223915-04
84200	2	22	\N		1	t	2019-09-19 15:13:41.223915-04
84201	2	22	\N		1	t	2019-09-19 15:13:41.223915-04
84202	1	19	\N		1	t	2019-09-19 15:13:41.223915-04
84203	2	22	\N		1	t	2019-09-19 15:13:41.223915-04
84334	2	22	\N		1	t	2019-09-19 15:14:06.721307-04
84335	2	22	\N		1	t	2019-09-19 15:14:06.721307-04
84336	2	22	\N		1	t	2019-09-19 15:14:06.721307-04
84337	2	22	\N		1	t	2019-09-19 15:14:06.721307-04
84338	2	22	\N		1	t	2019-09-19 15:14:06.721307-04
84339	2	22	\N		1	t	2019-09-19 15:14:06.721307-04
84340	2	22	\N		1	t	2019-09-19 15:14:06.721307-04
84341	2	22	\N		1	t	2019-09-19 15:14:06.721307-04
84342	2	22	\N		1	t	2019-09-19 15:14:06.721307-04
84343	2	22	\N		1	t	2019-09-19 15:14:06.721307-04
84344	2	22	\N		1	t	2019-09-19 15:14:06.721307-04
84345	1	19	\N		1	t	2019-09-19 15:14:06.721307-04
84346	2	22	\N		1	t	2019-09-19 15:14:06.721307-04
84347	2	22	\N		1	t	2019-09-19 15:14:06.721307-04
84348	1	19	\N		1	t	2019-09-19 15:14:06.721307-04
84349	2	22	\N		1	t	2019-09-19 15:14:06.721307-04
84350	2	22	\N		1	t	2019-09-19 15:14:06.721307-04
84351	2	22	\N		1	t	2019-09-19 15:14:06.721307-04
84352	2	22	\N		1	t	2019-09-19 15:14:06.721307-04
84353	2	22	\N		1	t	2019-09-19 15:14:06.721307-04
84354	1	19	\N		1	t	2019-09-19 15:14:06.721307-04
84355	1	19	\N		1	t	2019-09-19 15:14:06.721307-04
84356	2	22	\N		1	t	2019-09-19 15:14:06.721307-04
84357	2	22	\N		1	t	2019-09-19 15:14:06.721307-04
84358	2	22	\N		1	t	2019-09-19 15:14:06.721307-04
84359	2	22	\N		1	t	2019-09-19 15:14:06.721307-04
84360	2	22	\N		1	t	2019-09-19 15:14:06.721307-04
84361	2	22	\N		1	t	2019-09-19 15:14:06.721307-04
84362	2	22	\N		1	t	2019-09-19 15:14:06.721307-04
84363	2	22	\N		1	t	2019-09-19 15:14:06.721307-04
84364	2	22	\N		1	t	2019-09-19 15:14:06.721307-04
84365	2	22	\N		1	t	2019-09-19 15:14:06.721307-04
84366	2	22	\N		1	t	2019-09-19 15:14:06.721307-04
84367	2	22	\N		1	t	2019-09-19 15:14:06.721307-04
84368	2	22	\N		1	t	2019-09-19 15:14:06.721307-04
84369	2	22	\N		1	t	2019-09-19 15:14:06.721307-04
84370	1	19	\N		1	t	2019-09-19 15:14:06.721307-04
84371	2	22	\N		1	t	2019-09-19 15:14:06.721307-04
84372	2	22	\N		1	t	2019-09-19 15:14:06.721307-04
84373	2	22	\N		1	t	2019-09-19 15:14:06.721307-04
84374	2	22	\N		1	t	2019-09-19 15:14:06.721307-04
84375	2	22	\N		1	t	2019-09-19 15:14:06.721307-04
84376	2	22	\N		1	t	2019-09-19 15:14:06.721307-04
84377	2	22	\N		1	t	2019-09-19 15:14:06.721307-04
84378	2	22	\N		1	t	2019-09-19 15:14:06.721307-04
84379	2	22	\N		1	t	2019-09-19 15:14:06.721307-04
84380	1	19	\N		1	t	2019-09-19 15:14:06.721307-04
84381	2	22	\N		1	t	2019-09-19 15:14:06.721307-04
84382	2	22	\N		1	t	2019-09-19 15:14:06.721307-04
84383	2	22	\N		1	t	2019-09-19 15:14:06.721307-04
84384	2	22	\N		1	t	2019-09-19 15:14:06.721307-04
84385	2	22	\N		1	t	2019-09-19 15:14:06.721307-04
84386	2	22	\N		1	t	2019-09-19 15:14:06.721307-04
84387	2	22	\N		1	t	2019-09-19 15:14:06.721307-04
84388	2	22	\N		1	t	2019-09-19 15:14:06.721307-04
84389	2	22	\N		1	t	2019-09-19 15:14:06.721307-04
84390	2	22	\N		1	t	2019-09-19 15:14:06.721307-04
84391	2	22	\N		1	t	2019-09-19 15:14:06.721307-04
84392	2	22	\N		1	t	2019-09-19 15:14:06.721307-04
84393	1	19	\N		1	t	2019-09-19 15:14:06.721307-04
84394	1	19	\N		1	t	2019-09-19 15:14:06.721307-04
84395	2	22	\N		1	t	2019-09-19 15:14:06.721307-04
84396	2	22	\N		1	t	2019-09-19 15:14:06.721307-04
84397	2	22	\N		1	t	2019-09-19 15:14:06.721307-04
84398	2	22	\N		1	t	2019-09-19 15:14:06.721307-04
84399	2	22	\N		1	t	2019-09-19 15:14:06.721307-04
84400	2	22	\N		1	t	2019-09-19 15:14:06.721307-04
84401	2	22	\N		1	t	2019-09-19 15:14:06.721307-04
84402	2	22	\N		1	t	2019-09-19 15:14:06.721307-04
84403	2	22	\N		1	t	2019-09-19 15:14:06.721307-04
84404	2	22	\N		1	t	2019-09-19 15:14:06.721307-04
84405	1	19	\N		1	t	2019-09-19 15:15:27.937722-04
84406	2	22	\N		1	t	2019-09-19 15:15:27.937722-04
84407	2	22	\N		1	t	2019-09-19 15:15:27.937722-04
84408	1	19	\N		1	t	2019-09-19 15:15:27.937722-04
84409	2	22	\N		1	t	2019-09-19 15:15:27.937722-04
84410	2	22	\N		1	t	2019-09-19 15:15:27.937722-04
84411	2	22	\N		1	t	2019-09-19 15:15:27.937722-04
84412	2	22	\N		1	t	2019-09-19 15:15:27.937722-04
84413	2	22	\N		1	t	2019-09-19 15:15:27.937722-04
84414	2	22	\N		1	t	2019-09-19 15:15:27.937722-04
84415	2	22	\N		1	t	2019-09-19 15:15:27.937722-04
84416	2	22	\N		1	t	2019-09-19 15:15:27.937722-04
84417	1	19	\N		1	t	2019-09-19 15:15:27.937722-04
84418	2	22	\N		1	t	2019-09-19 15:15:27.937722-04
84419	2	22	\N		1	t	2019-09-19 15:15:27.937722-04
84420	2	22	\N		1	t	2019-09-19 15:15:27.937722-04
84421	2	22	\N		1	t	2019-09-19 15:15:27.937722-04
84422	2	22	\N		1	t	2019-09-19 15:15:27.937722-04
84423	2	22	\N		1	t	2019-09-19 15:15:27.937722-04
84424	2	22	\N		1	t	2019-09-19 15:15:27.937722-04
84425	2	22	\N		1	t	2019-09-19 15:15:27.937722-04
84426	2	22	\N		1	t	2019-09-19 15:15:27.937722-04
84427	2	22	\N		1	t	2019-09-19 15:15:27.937722-04
84428	2	22	\N		1	t	2019-09-19 15:15:27.937722-04
84429	2	22	\N		1	t	2019-09-19 15:15:27.937722-04
84430	2	22	\N		1	t	2019-09-19 15:15:27.937722-04
84431	2	22	\N		1	t	2019-09-19 15:15:27.937722-04
84432	2	22	\N		1	t	2019-09-19 15:15:27.937722-04
84433	2	22	\N		1	t	2019-09-19 15:15:27.937722-04
84434	2	22	\N		1	t	2019-09-19 15:15:27.937722-04
84435	2	22	\N		1	t	2019-09-19 15:15:27.937722-04
84436	1	19	\N		1	t	2019-09-19 15:15:27.937722-04
84437	1	19	\N		1	t	2019-09-19 15:15:27.937722-04
84438	2	22	\N		1	t	2019-09-19 15:15:27.937722-04
84439	2	22	\N		1	t	2019-09-19 15:15:27.937722-04
84440	2	22	\N		1	t	2019-09-19 15:15:27.937722-04
84441	2	22	\N		1	t	2019-09-19 15:15:27.937722-04
84442	2	22	\N		1	t	2019-09-19 15:15:27.937722-04
84443	2	22	\N		1	t	2019-09-19 15:15:27.937722-04
84444	2	22	\N		1	t	2019-09-19 15:15:27.937722-04
84445	2	22	\N		1	t	2019-09-19 15:15:27.937722-04
84446	2	22	\N		1	t	2019-09-19 15:15:27.937722-04
84447	2	22	\N		1	t	2019-09-19 15:15:27.937722-04
84448	2	22	\N		1	t	2019-09-19 15:15:27.937722-04
84449	2	22	\N		1	t	2019-09-19 15:15:27.937722-04
84450	2	22	\N		1	t	2019-09-19 15:15:27.937722-04
84451	2	22	\N		1	t	2019-09-19 15:15:27.937722-04
84452	2	22	\N		1	t	2019-09-19 15:15:27.937722-04
84453	2	22	\N		1	t	2019-09-19 15:15:27.937722-04
84454	2	22	\N		1	t	2019-09-19 15:15:27.937722-04
84455	2	22	\N		1	t	2019-09-19 15:15:27.937722-04
84456	2	22	\N		1	t	2019-09-19 15:15:27.937722-04
84457	2	22	\N		1	t	2019-09-19 15:15:27.937722-04
84458	2	22	\N		1	t	2019-09-19 15:15:27.937722-04
84459	2	22	\N		1	t	2019-09-19 15:15:27.937722-04
84460	2	22	\N		1	t	2019-09-19 15:15:27.937722-04
84461	2	22	\N		1	t	2019-09-19 15:15:27.937722-04
84462	2	22	\N		1	t	2019-09-19 15:15:27.937722-04
84463	2	22	\N		1	t	2019-09-19 15:15:27.937722-04
84464	1	19	\N		1	t	2019-09-19 15:15:27.937722-04
84465	2	22	\N		1	t	2019-09-19 15:15:27.937722-04
84466	2	22	\N		1	t	2019-09-19 15:15:27.937722-04
84467	2	22	\N		1	t	2019-09-19 15:15:27.937722-04
84468	1	19	\N		1	t	2019-09-19 15:15:27.937722-04
84469	2	22	\N		1	t	2019-09-19 15:15:27.937722-04
84470	2	22	\N		1	t	2019-09-19 15:15:27.937722-04
84471	2	22	\N		1	t	2019-09-19 15:15:27.937722-04
84472	2	22	\N		1	t	2019-09-19 15:15:27.937722-04
84473	2	22	\N		1	t	2019-09-19 15:15:27.937722-04
84474	2	22	\N		1	t	2019-09-19 15:15:27.937722-04
84475	2	22	\N		1	t	2019-09-19 15:15:27.937722-04
84476	2	22	\N		1	t	2019-09-19 15:15:27.937722-04
84477	2	22	\N		1	t	2019-09-19 15:15:27.937722-04
84478	1	19	\N		1	t	2019-09-19 15:15:27.937722-04
84479	2	22	\N		1	t	2019-09-19 15:15:27.937722-04
84480	2	22	\N		1	t	2019-09-19 15:15:27.937722-04
84481	2	22	\N		1	t	2019-09-19 15:15:27.937722-04
84482	2	22	\N		1	t	2019-09-19 15:15:27.937722-04
84483	2	22	\N		1	t	2019-09-19 15:15:27.937722-04
84484	2	22	\N		1	t	2019-09-19 15:15:27.937722-04
84485	2	22	\N		1	t	2019-09-19 15:15:27.937722-04
84486	2	22	\N		1	t	2019-09-19 15:15:27.937722-04
84487	2	22	\N		1	t	2019-09-19 15:15:27.937722-04
84488	2	22	\N		1	t	2019-09-19 15:15:27.937722-04
84489	2	22	\N		1	t	2019-09-19 15:15:27.937722-04
84490	2	22	\N		1	t	2019-09-19 15:15:27.937722-04
84491	2	22	\N		1	t	2019-09-19 15:15:27.937722-04
84492	2	22	\N		1	t	2019-09-19 15:15:27.937722-04
84493	2	22	\N		1	t	2019-09-19 15:15:27.937722-04
84494	2	22	\N		1	t	2019-09-19 15:15:27.937722-04
84495	2	22	\N		1	t	2019-09-19 15:15:27.937722-04
84496	2	22	\N		1	t	2019-09-19 15:15:27.937722-04
84497	2	22	\N		1	t	2019-09-19 15:15:27.937722-04
84498	2	22	\N		1	t	2019-09-19 15:15:27.937722-04
84499	2	22	\N		1	t	2019-09-19 15:15:27.937722-04
84500	2	22	\N		1	t	2019-09-19 15:15:27.937722-04
84501	2	22	\N		1	t	2019-09-19 15:15:27.937722-04
84502	2	22	\N		1	t	2019-09-19 15:15:27.937722-04
84503	2	22	\N		1	t	2019-09-19 15:15:27.937722-04
84504	2	22	\N		1	t	2019-09-19 15:15:27.937722-04
84505	2	22	\N		1	t	2019-09-19 15:15:27.937722-04
84506	2	22	\N		1	t	2019-09-19 15:15:27.937722-04
84507	2	22	\N		1	t	2019-09-19 15:15:27.937722-04
84508	2	22	\N		1	t	2019-09-19 15:15:27.937722-04
84509	2	22	\N		1	t	2019-09-19 15:15:27.937722-04
84510	2	22	\N		1	t	2019-09-19 15:15:27.937722-04
84511	1	19	\N		1	t	2019-09-19 15:15:27.937722-04
84512	2	22	\N		1	t	2019-09-19 15:15:27.937722-04
84513	2	22	\N		1	t	2019-09-19 15:15:27.937722-04
84514	2	22	\N		1	t	2019-09-19 15:15:27.937722-04
84515	2	22	\N		1	t	2019-09-19 15:15:27.937722-04
84516	1	19	\N		1	t	2019-09-19 15:15:27.937722-04
84517	1	19	\N		1	t	2019-09-19 15:15:27.937722-04
84518	2	22	\N		1	t	2019-09-19 15:15:27.937722-04
84519	2	22	\N		1	t	2019-09-19 15:15:27.937722-04
84520	2	22	\N		1	t	2019-09-19 15:15:27.937722-04
84521	2	22	\N		1	t	2019-09-19 15:15:27.937722-04
84522	2	22	\N		1	t	2019-09-19 15:15:27.937722-04
84523	2	22	\N		1	t	2019-09-19 15:15:27.937722-04
84524	2	22	\N		1	t	2019-09-19 15:15:27.937722-04
84525	2	22	\N		1	t	2019-09-19 15:15:27.937722-04
84526	2	22	\N		1	t	2019-09-19 15:15:27.937722-04
84527	1	19	\N		1	t	2019-09-19 15:15:27.937722-04
84528	2	22	\N		1	t	2019-09-19 15:15:27.937722-04
84529	2	22	\N		1	t	2019-09-19 15:15:27.937722-04
84530	2	22	\N		1	t	2019-09-19 15:15:27.937722-04
84531	2	22	\N		1	t	2019-09-19 15:15:27.937722-04
84532	2	22	\N		1	t	2019-09-19 15:15:27.937722-04
84533	2	22	\N		1	t	2019-09-19 15:15:27.937722-04
84534	2	22	\N		1	t	2019-09-19 15:15:27.937722-04
84535	2	22	\N		1	t	2019-09-19 15:15:27.937722-04
84536	2	22	\N		1	t	2019-09-19 15:15:27.937722-04
84537	1	19	\N		1	t	2019-09-19 15:15:27.937722-04
84538	2	22	\N		1	t	2019-09-19 15:15:27.937722-04
84539	2	22	\N		1	t	2019-09-19 15:15:27.937722-04
84540	2	22	\N		1	t	2019-09-19 15:15:27.937722-04
84541	2	22	\N		1	t	2019-09-19 15:15:27.937722-04
84542	2	22	\N		1	t	2019-09-19 15:15:27.937722-04
84543	2	22	\N		1	t	2019-09-19 15:15:27.937722-04
84544	1	19	\N		1	t	2019-09-19 15:15:27.937722-04
84545	2	22	\N		1	t	2019-09-19 15:15:27.937722-04
84546	2	22	\N		1	t	2019-09-19 15:15:27.937722-04
84547	2	22	\N		1	t	2019-09-19 15:15:27.937722-04
84548	2	22	\N		1	t	2019-09-19 15:15:27.937722-04
84549	1	19	\N		1	t	2019-09-19 15:15:27.937722-04
84550	2	22	\N		1	t	2019-09-19 15:15:27.937722-04
84551	2	22	\N		1	t	2019-09-19 15:15:27.937722-04
84552	2	22	\N		1	t	2019-09-19 15:15:27.937722-04
84553	2	22	\N		1	t	2019-09-19 15:15:51.665433-04
84554	2	22	\N		1	t	2019-09-19 15:15:51.665433-04
84555	2	22	\N		1	t	2019-09-19 15:15:51.665433-04
84556	2	22	\N		1	t	2019-09-19 15:15:51.665433-04
84557	2	22	\N		1	t	2019-09-19 15:15:51.665433-04
84558	2	22	\N		1	t	2019-09-19 15:15:51.665433-04
84559	2	22	\N		1	t	2019-09-19 15:15:51.665433-04
84560	2	22	\N		1	t	2019-09-19 15:15:51.665433-04
84561	2	22	\N		1	t	2019-09-19 15:15:51.665433-04
84562	2	22	\N		1	t	2019-09-19 15:15:51.665433-04
84563	2	22	\N		1	t	2019-09-19 15:15:51.665433-04
84564	2	22	\N		1	t	2019-09-19 15:15:51.665433-04
84565	1	19	\N		1	t	2019-09-19 15:15:51.665433-04
84244	2	21	\N	3333	1	t	2019-09-19 15:14:06.721307-04
84566	2	22	\N		1	t	2019-09-23 18:33:13.353819-04
84567	2	22	\N		1	t	2019-09-23 18:33:13.353819-04
84569	2	22	\N		1	t	2019-09-23 18:33:13.353819-04
84570	2	22	\N		1	t	2019-09-23 18:33:13.353819-04
84571	2	22	\N		1	t	2019-09-23 18:33:13.353819-04
84572	2	22	\N		1	t	2019-09-23 18:33:13.353819-04
84573	1	19	\N		1	t	2019-09-23 18:33:13.353819-04
84574	2	22	\N		1	t	2019-09-23 18:33:13.353819-04
84575	2	22	\N		1	t	2019-09-23 18:33:13.353819-04
84576	1	19	\N		1	t	2019-09-23 18:33:13.353819-04
84577	2	22	\N		1	t	2019-09-23 18:33:13.353819-04
84578	1	19	\N		1	t	2019-09-23 18:33:55.750854-04
84579	2	22	\N		1	t	2019-09-23 18:33:55.750854-04
84580	2	22	\N		1	t	2019-09-23 18:33:55.750854-04
84581	2	22	\N		1	t	2019-09-23 18:33:55.750854-04
84582	2	22	\N		1	t	2019-09-23 18:33:55.750854-04
84583	2	22	\N		1	t	2019-09-23 18:33:55.750854-04
84584	2	22	\N		1	t	2019-09-23 18:33:55.750854-04
84585	2	22	\N		1	t	2019-09-23 18:33:55.750854-04
84586	2	22	\N		1	t	2019-09-23 18:33:55.750854-04
84587	2	22	\N		1	t	2019-09-23 18:33:55.750854-04
84588	2	22	\N		1	t	2019-09-23 18:33:55.750854-04
84589	2	22	\N		1	t	2019-09-23 18:33:55.750854-04
84590	2	22	\N		1	t	2019-09-23 18:33:55.750854-04
84591	2	22	\N		1	t	2019-09-23 18:33:55.750854-04
84592	2	22	\N		1	t	2019-09-23 18:33:55.750854-04
84593	2	22	\N		1	t	2019-09-23 18:33:55.750854-04
84594	2	22	\N		1	t	2019-09-23 18:33:55.750854-04
84595	2	22	\N		1	t	2019-09-23 18:33:55.750854-04
84596	2	22	\N		1	t	2019-09-23 18:33:55.750854-04
84597	2	22	\N		1	t	2019-09-23 18:33:55.750854-04
84598	2	22	\N		1	t	2019-09-23 18:33:55.750854-04
84599	2	22	\N		1	t	2019-09-23 18:33:55.750854-04
84600	2	22	\N		1	t	2019-09-23 18:33:55.750854-04
84601	2	22	\N		1	t	2019-09-23 18:33:55.750854-04
84602	2	22	\N		1	t	2019-09-23 18:33:55.750854-04
84603	2	22	\N		1	t	2019-09-23 18:33:55.750854-04
84604	2	22	\N		1	t	2019-09-23 18:33:55.750854-04
84605	1	19	\N		1	t	2019-09-23 18:33:55.750854-04
84606	1	19	\N		1	t	2019-09-23 18:33:55.750854-04
84607	2	22	\N		1	t	2019-09-23 18:33:55.750854-04
84608	2	22	\N		1	t	2019-09-23 18:33:55.750854-04
84609	2	22	\N		1	t	2019-09-23 18:33:55.750854-04
84610	1	19	\N		1	t	2019-09-23 18:33:55.750854-04
84611	2	22	\N		1	t	2019-09-23 18:33:55.750854-04
84612	1	19	\N		1	t	2019-09-23 18:33:55.750854-04
84613	2	22	\N		1	t	2019-09-23 18:33:55.750854-04
84614	2	22	\N		1	t	2019-09-23 18:33:55.750854-04
84615	2	22	\N		1	t	2019-09-23 18:33:55.750854-04
84616	2	22	\N		1	t	2019-09-23 18:33:55.750854-04
84617	1	19	\N		1	t	2019-09-23 18:33:55.750854-04
84618	2	22	\N		1	t	2019-09-23 18:33:55.750854-04
84619	2	22	\N		1	t	2019-09-23 18:33:55.750854-04
84620	2	22	\N		1	t	2019-09-23 18:33:55.750854-04
84621	2	22	\N		1	t	2019-09-23 18:33:55.750854-04
84622	2	22	\N		1	t	2019-09-23 18:33:55.750854-04
84623	2	22	\N		1	t	2019-09-23 18:33:55.750854-04
84624	2	22	\N		1	t	2019-09-23 18:33:55.750854-04
84625	2	22	\N		1	t	2019-09-23 18:33:55.750854-04
84626	2	22	\N		1	t	2019-09-23 18:33:55.750854-04
84627	2	22	\N		1	t	2019-09-23 18:33:55.750854-04
84628	2	22	\N		1	t	2019-09-23 18:33:55.750854-04
84629	2	22	\N		1	t	2019-09-23 18:33:55.750854-04
84630	2	22	\N		1	t	2019-09-23 18:33:55.750854-04
84631	2	22	\N		1	t	2019-09-23 18:33:55.750854-04
84632	1	19	\N		1	t	2019-09-23 18:33:55.750854-04
84633	2	22	\N		1	t	2019-09-23 18:33:55.750854-04
84634	1	19	\N		1	t	2019-09-23 18:33:55.750854-04
84635	2	22	\N		1	t	2019-09-23 18:33:55.750854-04
84636	1	19	\N		1	t	2019-09-23 18:33:55.750854-04
84637	2	22	\N		1	t	2019-09-23 18:33:55.750854-04
84638	2	22	\N		1	t	2019-09-23 18:33:55.750854-04
84639	2	22	\N		1	t	2019-09-23 18:33:55.750854-04
84640	2	22	\N		1	t	2019-09-23 18:33:55.750854-04
84641	2	22	\N		1	t	2019-09-23 18:33:55.750854-04
84642	1	19	\N		1	t	2019-09-23 18:33:55.750854-04
84643	2	22	\N		1	t	2019-09-23 18:33:55.750854-04
84644	2	22	\N		1	t	2019-09-23 18:33:55.750854-04
84645	2	22	\N		1	t	2019-09-23 18:33:55.750854-04
84646	2	22	\N		1	t	2019-09-23 18:33:55.750854-04
84647	2	22	\N		1	t	2019-09-23 18:33:55.750854-04
84648	2	22	\N		1	t	2019-09-23 18:33:55.750854-04
84649	1	19	\N		1	t	2019-09-23 18:33:55.750854-04
84650	2	22	\N		1	t	2019-09-23 18:33:55.750854-04
84651	2	22	\N		1	t	2019-09-23 18:33:55.750854-04
84652	2	22	\N		1	t	2019-09-23 18:33:55.750854-04
84653	2	22	\N		1	t	2019-09-23 18:33:55.750854-04
84654	2	22	\N		1	t	2019-09-23 18:33:55.750854-04
84655	2	22	\N		1	t	2019-09-23 18:33:55.750854-04
84656	1	19	\N		1	t	2019-09-23 18:33:55.750854-04
84657	2	22	\N		1	t	2019-09-23 18:33:55.750854-04
84658	2	22	\N		1	t	2019-09-23 18:33:55.750854-04
84659	1	19	\N		1	t	2019-09-23 18:33:55.750854-04
84660	2	22	\N		1	t	2019-09-23 18:33:55.750854-04
84661	2	22	\N		1	t	2019-09-23 18:33:55.750854-04
84662	1	19	\N		1	t	2019-09-24 10:49:19.315623-04
84663	2	22	\N		1	t	2019-09-24 10:49:19.315623-04
84664	2	22	\N		1	t	2019-09-24 10:49:19.315623-04
84665	1	19	\N		1	t	2019-09-24 10:49:19.315623-04
84666	2	22	\N		1	t	2019-09-24 10:49:19.315623-04
84667	2	22	\N		1	t	2019-09-24 10:49:19.315623-04
84668	2	22	\N		1	t	2019-09-24 10:49:19.315623-04
84669	2	22	\N		1	t	2019-09-24 10:49:19.315623-04
84670	2	22	\N		1	t	2019-09-24 10:49:19.315623-04
84671	2	22	\N		1	t	2019-09-24 10:49:19.315623-04
84672	2	22	\N		1	t	2019-09-24 10:49:19.315623-04
84673	2	22	\N		1	t	2019-09-24 10:49:19.315623-04
84674	1	19	\N		1	t	2019-09-24 10:49:19.315623-04
84675	2	22	\N		1	t	2019-09-24 10:49:19.315623-04
84676	2	22	\N		1	t	2019-09-24 10:49:19.315623-04
84677	2	22	\N		1	t	2019-09-24 10:49:19.315623-04
84678	2	22	\N		1	t	2019-09-24 10:49:19.315623-04
84679	2	22	\N		1	t	2019-09-24 10:49:19.315623-04
84680	2	22	\N		1	t	2019-09-24 10:49:19.315623-04
84681	2	22	\N		1	t	2019-09-24 10:49:19.315623-04
84682	2	22	\N		1	t	2019-09-24 10:49:19.315623-04
84683	2	22	\N		1	t	2019-09-24 10:49:19.315623-04
84684	2	22	\N		1	t	2019-09-24 10:49:19.315623-04
84685	2	22	\N		1	t	2019-09-24 10:49:19.315623-04
84686	2	22	\N		1	t	2019-09-24 10:49:19.315623-04
84687	2	22	\N		1	t	2019-09-24 10:49:19.315623-04
84688	2	22	\N		1	t	2019-09-24 10:49:19.315623-04
84689	2	22	\N		1	t	2019-09-24 10:49:19.315623-04
84690	2	22	\N		1	t	2019-09-24 10:49:19.315623-04
84691	2	22	\N		1	t	2019-09-24 10:49:19.315623-04
84692	2	22	\N		1	t	2019-09-24 10:49:19.315623-04
84693	1	19	\N		1	t	2019-09-24 10:49:19.315623-04
84694	1	19	\N		1	t	2019-09-24 10:49:19.315623-04
84695	2	22	\N		1	t	2019-09-24 10:49:19.315623-04
84696	2	22	\N		1	t	2019-09-24 10:49:19.315623-04
84697	2	22	\N		1	t	2019-09-24 10:49:19.315623-04
84698	2	22	\N		1	t	2019-09-24 10:49:19.315623-04
84699	2	22	\N		1	t	2019-09-24 10:49:19.315623-04
84700	2	22	\N		1	t	2019-09-24 10:49:19.315623-04
84701	2	22	\N		1	t	2019-09-24 10:49:19.315623-04
84702	2	22	\N		1	t	2019-09-24 10:49:19.315623-04
84703	2	22	\N		1	t	2019-09-24 10:49:19.315623-04
84704	2	22	\N		1	t	2019-09-24 10:49:19.315623-04
84705	2	22	\N		1	t	2019-09-24 10:49:19.315623-04
84706	2	22	\N		1	t	2019-09-24 10:49:19.315623-04
84707	2	22	\N		1	t	2019-09-24 10:49:19.315623-04
84708	2	22	\N		1	t	2019-09-24 10:49:19.315623-04
84709	2	22	\N		1	t	2019-09-24 10:49:19.315623-04
84710	2	22	\N		1	t	2019-09-24 10:49:19.315623-04
84711	2	22	\N		1	t	2019-09-24 10:49:19.315623-04
84712	2	22	\N		1	t	2019-09-24 10:49:19.315623-04
84713	2	22	\N		1	t	2019-09-24 10:49:19.315623-04
84714	2	22	\N		1	t	2019-09-24 10:49:19.315623-04
84715	2	22	\N		1	t	2019-09-24 10:49:19.315623-04
84716	2	22	\N		1	t	2019-09-24 10:49:19.315623-04
84717	2	22	\N		1	t	2019-09-24 10:49:19.315623-04
84718	2	22	\N		1	t	2019-09-24 10:49:19.315623-04
84719	2	22	\N		1	t	2019-09-24 10:49:19.315623-04
84720	2	22	\N		1	t	2019-09-24 10:49:19.315623-04
84721	1	19	\N		1	t	2019-09-24 10:49:19.315623-04
84722	2	22	\N		1	t	2019-09-24 10:49:19.315623-04
84723	2	22	\N		1	t	2019-09-24 10:49:19.315623-04
84724	2	22	\N		1	t	2019-09-24 10:49:19.315623-04
84725	1	19	\N		1	t	2019-09-24 10:49:19.315623-04
84726	2	22	\N		1	t	2019-09-24 10:49:19.315623-04
84727	2	22	\N		1	t	2019-09-24 10:49:19.315623-04
84728	2	22	\N		1	t	2019-09-24 10:49:19.315623-04
84729	2	22	\N		1	t	2019-09-24 10:49:19.315623-04
84730	2	22	\N		1	t	2019-09-24 10:49:19.315623-04
84731	2	22	\N		1	t	2019-09-24 10:49:19.315623-04
84732	2	22	\N		1	t	2019-09-24 10:49:19.315623-04
84733	2	22	\N		1	t	2019-09-24 10:49:19.315623-04
84734	2	22	\N		1	t	2019-09-24 10:49:19.315623-04
84735	1	19	\N		1	t	2019-09-24 10:49:19.315623-04
84736	2	22	\N		1	t	2019-09-24 10:49:19.315623-04
84737	2	22	\N		1	t	2019-09-24 10:49:19.315623-04
84738	2	22	\N		1	t	2019-09-24 10:49:19.315623-04
84739	2	22	\N		1	t	2019-09-24 10:49:19.315623-04
84740	2	22	\N		1	t	2019-09-24 10:49:19.315623-04
84741	2	22	\N		1	t	2019-09-24 10:49:19.315623-04
84742	2	22	\N		1	t	2019-09-24 10:49:19.315623-04
84743	2	22	\N		1	t	2019-09-24 10:49:19.315623-04
84744	2	22	\N		1	t	2019-09-24 10:49:19.315623-04
84745	2	22	\N		1	t	2019-09-24 10:49:19.315623-04
84746	2	22	\N		1	t	2019-09-24 10:49:19.315623-04
84747	2	22	\N		1	t	2019-09-24 10:49:19.315623-04
84748	2	22	\N		1	t	2019-09-24 10:49:19.315623-04
84749	2	22	\N		1	t	2019-09-24 10:49:19.315623-04
84750	2	22	\N		1	t	2019-09-24 10:49:19.315623-04
84751	2	22	\N		1	t	2019-09-24 10:49:19.315623-04
84752	2	22	\N		1	t	2019-09-24 10:49:19.315623-04
84753	2	22	\N		1	t	2019-09-24 10:49:19.315623-04
84754	2	22	\N		1	t	2019-09-24 10:49:19.315623-04
84755	2	22	\N		1	t	2019-09-24 10:49:19.315623-04
84756	2	22	\N		1	t	2019-09-24 10:49:19.315623-04
84757	2	22	\N		1	t	2019-09-24 10:49:19.315623-04
84758	2	22	\N		1	t	2019-09-24 10:49:19.315623-04
84759	2	22	\N		1	t	2019-09-24 10:49:19.315623-04
84760	2	22	\N		1	t	2019-09-24 10:49:19.315623-04
84761	2	22	\N		1	t	2019-09-24 10:49:19.315623-04
84762	2	22	\N		1	t	2019-09-24 10:49:19.315623-04
84763	2	22	\N		1	t	2019-09-24 10:49:19.315623-04
84764	2	22	\N		1	t	2019-09-24 10:49:19.315623-04
84765	2	22	\N		1	t	2019-09-24 10:49:19.315623-04
84766	2	22	\N		1	t	2019-09-24 10:49:19.315623-04
84767	2	22	\N		1	t	2019-09-24 10:49:19.315623-04
84768	1	19	\N		1	t	2019-09-24 10:49:19.315623-04
84769	2	22	\N		1	t	2019-09-24 10:49:19.315623-04
84770	2	22	\N		1	t	2019-09-24 10:49:19.315623-04
84771	2	22	\N		1	t	2019-09-24 10:49:19.315623-04
84772	2	22	\N		1	t	2019-09-24 10:49:19.315623-04
84773	1	19	\N		1	t	2019-09-24 10:49:19.315623-04
84774	1	19	\N		1	t	2019-09-24 10:49:19.315623-04
84775	2	22	\N		1	t	2019-09-24 10:49:19.315623-04
84776	2	22	\N		1	t	2019-09-24 10:49:19.315623-04
84777	2	22	\N		1	t	2019-09-24 10:49:19.315623-04
84778	2	22	\N		1	t	2019-09-24 10:49:19.315623-04
84779	2	22	\N		1	t	2019-09-24 10:49:19.315623-04
84780	2	22	\N		1	t	2019-09-24 10:49:19.315623-04
84781	2	22	\N		1	t	2019-09-24 10:49:19.315623-04
84782	2	22	\N		1	t	2019-09-24 10:49:19.315623-04
84783	2	22	\N		1	t	2019-09-24 10:49:19.315623-04
84784	1	19	\N		1	t	2019-09-24 10:49:19.315623-04
84785	2	22	\N		1	t	2019-09-24 10:49:19.315623-04
84786	2	22	\N		1	t	2019-09-24 10:49:19.315623-04
84787	2	22	\N		1	t	2019-09-24 10:49:19.315623-04
84788	2	22	\N		1	t	2019-09-24 10:49:19.315623-04
84789	2	22	\N		1	t	2019-09-24 10:49:19.315623-04
84790	2	22	\N		1	t	2019-09-24 10:49:19.315623-04
84791	2	22	\N		1	t	2019-09-24 10:49:19.315623-04
84792	2	22	\N		1	t	2019-09-24 10:49:19.315623-04
84793	2	22	\N		1	t	2019-09-24 10:49:19.315623-04
84794	1	19	\N		1	t	2019-09-24 10:49:19.315623-04
84795	2	22	\N		1	t	2019-09-24 10:49:19.315623-04
84796	2	22	\N		1	t	2019-09-24 10:49:19.315623-04
84797	2	22	\N		1	t	2019-09-24 10:49:19.315623-04
84798	2	22	\N		1	t	2019-09-24 10:49:19.315623-04
84799	2	22	\N		1	t	2019-09-24 10:49:19.315623-04
84800	2	22	\N		1	t	2019-09-24 10:49:19.315623-04
84801	1	19	\N		1	t	2019-09-24 10:49:19.315623-04
84802	2	22	\N		1	t	2019-09-24 10:49:19.315623-04
84803	2	22	\N		1	t	2019-09-24 10:49:19.315623-04
84804	2	22	\N		1	t	2019-09-24 10:49:19.315623-04
84805	2	22	\N		1	t	2019-09-24 10:49:19.315623-04
84806	1	19	\N		1	t	2019-09-24 10:49:19.315623-04
84807	2	22	\N		1	t	2019-09-24 10:49:19.315623-04
84808	2	22	\N		1	t	2019-09-24 10:49:19.315623-04
84809	2	22	\N		1	t	2019-09-24 10:49:19.315623-04
84810	1	19	\N		1	t	2019-09-26 15:36:41.890144-04
84811	2	22	\N		1	t	2019-09-26 15:36:41.890144-04
84812	2	22	\N		1	t	2019-09-26 15:36:41.890144-04
84813	1	19	\N		1	t	2019-09-26 15:36:41.890144-04
84814	2	22	\N		1	t	2019-09-26 15:36:41.890144-04
84815	2	22	\N		1	t	2019-09-26 15:36:41.890144-04
84816	2	22	\N		1	t	2019-09-26 15:36:41.890144-04
84817	2	22	\N		1	t	2019-09-26 15:36:41.890144-04
84818	2	22	\N		1	t	2019-09-26 15:36:41.890144-04
84819	2	22	\N		1	t	2019-09-26 15:36:41.890144-04
84820	2	22	\N		1	t	2019-09-26 15:36:41.890144-04
84821	2	22	\N		1	t	2019-09-26 15:36:41.890144-04
84822	1	19	\N		1	t	2019-09-26 15:36:41.890144-04
84823	2	22	\N		1	t	2019-09-26 15:36:41.890144-04
84824	2	22	\N		1	t	2019-09-26 15:36:41.890144-04
84825	2	22	\N		1	t	2019-09-26 15:36:41.890144-04
84826	2	22	\N		1	t	2019-09-26 15:36:41.890144-04
84827	2	22	\N		1	t	2019-09-26 15:36:41.890144-04
84828	2	22	\N		1	t	2019-09-26 15:36:41.890144-04
84829	2	22	\N		1	t	2019-09-26 15:36:41.890144-04
84830	2	22	\N		1	t	2019-09-26 15:36:41.890144-04
84831	2	22	\N		1	t	2019-09-26 15:36:41.890144-04
84832	2	22	\N		1	t	2019-09-26 15:36:41.890144-04
84833	2	22	\N		1	t	2019-09-26 15:36:41.890144-04
84834	2	22	\N		1	t	2019-09-26 15:36:41.890144-04
84835	2	22	\N		1	t	2019-09-26 15:36:41.890144-04
84836	2	22	\N		1	t	2019-09-26 15:36:41.890144-04
84837	2	22	\N		1	t	2019-09-26 15:36:41.890144-04
84838	2	22	\N		1	t	2019-09-26 15:36:41.890144-04
84839	2	22	\N		1	t	2019-09-26 15:36:41.890144-04
84840	2	22	\N		1	t	2019-09-26 15:36:41.890144-04
84841	1	19	\N		1	t	2019-09-26 15:36:41.890144-04
84842	1	19	\N		1	t	2019-09-26 15:36:41.890144-04
84843	2	22	\N		1	t	2019-09-26 15:36:41.890144-04
84844	2	22	\N		1	t	2019-09-26 15:36:41.890144-04
84845	2	22	\N		1	t	2019-09-26 15:36:41.890144-04
84846	2	22	\N		1	t	2019-09-26 15:36:41.890144-04
84847	2	22	\N		1	t	2019-09-26 15:36:41.890144-04
84848	2	22	\N		1	t	2019-09-26 15:36:41.890144-04
84849	2	22	\N		1	t	2019-09-26 15:36:41.890144-04
84850	2	22	\N		1	t	2019-09-26 15:36:41.890144-04
84851	2	22	\N		1	t	2019-09-26 15:36:41.890144-04
84852	2	22	\N		1	t	2019-09-26 15:36:41.890144-04
84853	2	22	\N		1	t	2019-09-26 15:36:41.890144-04
84854	2	22	\N		1	t	2019-09-26 15:36:41.890144-04
84855	2	22	\N		1	t	2019-09-26 15:36:41.890144-04
84856	2	22	\N		1	t	2019-09-26 15:36:41.890144-04
84857	2	22	\N		1	t	2019-09-26 15:36:41.890144-04
84858	2	22	\N		1	t	2019-09-26 15:36:41.890144-04
84859	2	22	\N		1	t	2019-09-26 15:36:41.890144-04
84860	2	22	\N		1	t	2019-09-26 15:36:41.890144-04
84861	2	22	\N		1	t	2019-09-26 15:36:41.890144-04
84862	2	22	\N		1	t	2019-09-26 15:36:41.890144-04
84863	2	22	\N		1	t	2019-09-26 15:36:41.890144-04
84864	2	22	\N		1	t	2019-09-26 15:36:41.890144-04
84865	2	22	\N		1	t	2019-09-26 15:36:41.890144-04
84866	2	22	\N		1	t	2019-09-26 15:36:41.890144-04
84867	2	22	\N		1	t	2019-09-26 15:36:41.890144-04
84868	2	22	\N		1	t	2019-09-26 15:36:41.890144-04
84869	1	19	\N		1	t	2019-09-26 15:36:41.890144-04
84870	2	22	\N		1	t	2019-09-26 15:36:41.890144-04
84871	2	22	\N		1	t	2019-09-26 15:36:41.890144-04
84872	2	22	\N		1	t	2019-09-26 15:36:41.890144-04
84873	1	19	\N		1	t	2019-09-26 15:36:41.890144-04
84874	2	22	\N		1	t	2019-09-26 15:36:41.890144-04
84875	2	22	\N		1	t	2019-09-26 15:36:41.890144-04
84876	2	22	\N		1	t	2019-09-26 15:36:41.890144-04
84877	2	22	\N		1	t	2019-09-26 15:36:41.890144-04
84878	2	22	\N		1	t	2019-09-26 15:36:41.890144-04
84879	2	22	\N		1	t	2019-09-26 15:36:41.890144-04
84880	2	22	\N		1	t	2019-09-26 15:36:41.890144-04
84881	2	22	\N		1	t	2019-09-26 15:36:41.890144-04
84882	2	22	\N		1	t	2019-09-26 15:36:41.890144-04
84883	1	19	\N		1	t	2019-09-26 15:36:41.890144-04
84884	2	22	\N		1	t	2019-09-26 15:36:41.890144-04
84885	2	22	\N		1	t	2019-09-26 15:36:41.890144-04
84886	2	22	\N		1	t	2019-09-26 15:36:41.890144-04
84887	2	22	\N		1	t	2019-09-26 15:36:41.890144-04
84888	2	22	\N		1	t	2019-09-26 15:36:41.890144-04
84889	2	22	\N		1	t	2019-09-26 15:36:41.890144-04
84890	2	22	\N		1	t	2019-09-26 15:36:41.890144-04
84891	2	22	\N		1	t	2019-09-26 15:36:41.890144-04
84892	2	22	\N		1	t	2019-09-26 15:36:41.890144-04
84893	2	22	\N		1	t	2019-09-26 15:36:41.890144-04
84894	2	22	\N		1	t	2019-09-26 15:36:41.890144-04
84895	2	22	\N		1	t	2019-09-26 15:36:41.890144-04
84896	2	22	\N		1	t	2019-09-26 15:36:41.890144-04
84897	2	22	\N		1	t	2019-09-26 15:36:41.890144-04
84898	2	22	\N		1	t	2019-09-26 15:36:41.890144-04
84899	2	22	\N		1	t	2019-09-26 15:36:41.890144-04
84900	2	22	\N		1	t	2019-09-26 15:36:41.890144-04
84901	2	22	\N		1	t	2019-09-26 15:36:41.890144-04
84902	2	22	\N		1	t	2019-09-26 15:36:41.890144-04
84903	2	22	\N		1	t	2019-09-26 15:36:41.890144-04
84904	2	22	\N		1	t	2019-09-26 15:36:41.890144-04
84905	2	22	\N		1	t	2019-09-26 15:36:41.890144-04
84906	2	22	\N		1	t	2019-09-26 15:36:41.890144-04
84907	2	22	\N		1	t	2019-09-26 15:36:41.890144-04
84908	2	22	\N		1	t	2019-09-26 15:36:41.890144-04
84909	2	22	\N		1	t	2019-09-26 15:36:41.890144-04
84910	2	22	\N		1	t	2019-09-26 15:36:41.890144-04
84911	2	22	\N		1	t	2019-09-26 15:36:41.890144-04
84912	2	22	\N		1	t	2019-09-26 15:36:41.890144-04
84913	2	22	\N		1	t	2019-09-26 15:36:41.890144-04
84914	2	22	\N		1	t	2019-09-26 15:36:41.890144-04
84915	2	22	\N		1	t	2019-09-26 15:36:41.890144-04
84916	1	19	\N		1	t	2019-09-26 15:36:41.890144-04
84917	2	22	\N		1	t	2019-09-26 15:36:41.890144-04
84918	2	22	\N		1	t	2019-09-26 15:36:41.890144-04
84919	2	22	\N		1	t	2019-09-26 15:36:41.890144-04
84920	2	22	\N		1	t	2019-09-26 15:36:41.890144-04
84921	1	19	\N		1	t	2019-09-26 15:36:41.890144-04
84922	1	19	\N		1	t	2019-09-26 15:36:41.890144-04
84923	2	22	\N		1	t	2019-09-26 15:36:41.890144-04
84924	2	22	\N		1	t	2019-09-26 15:36:41.890144-04
84925	2	22	\N		1	t	2019-09-26 15:36:41.890144-04
84926	2	22	\N		1	t	2019-09-26 15:36:41.890144-04
84927	2	22	\N		1	t	2019-09-26 15:36:41.890144-04
84928	2	22	\N		1	t	2019-09-26 15:36:41.890144-04
84929	2	22	\N		1	t	2019-09-26 15:36:41.890144-04
84930	2	22	\N		1	t	2019-09-26 15:36:41.890144-04
84931	2	22	\N		1	t	2019-09-26 15:36:41.890144-04
84932	1	19	\N		1	t	2019-09-26 15:36:41.890144-04
84933	2	22	\N		1	t	2019-09-26 15:36:41.890144-04
84934	2	22	\N		1	t	2019-09-26 15:36:41.890144-04
84935	2	22	\N		1	t	2019-09-26 15:36:41.890144-04
84936	2	22	\N		1	t	2019-09-26 15:36:41.890144-04
84937	2	22	\N		1	t	2019-09-26 15:36:41.890144-04
84938	2	22	\N		1	t	2019-09-26 15:36:41.890144-04
84939	2	22	\N		1	t	2019-09-26 15:36:41.890144-04
84940	2	22	\N		1	t	2019-09-26 15:36:41.890144-04
84941	2	22	\N		1	t	2019-09-26 15:36:41.890144-04
84942	1	19	\N		1	t	2019-09-26 15:36:41.890144-04
84943	2	22	\N		1	t	2019-09-26 15:36:41.890144-04
84944	2	22	\N		1	t	2019-09-26 15:36:41.890144-04
84945	2	22	\N		1	t	2019-09-26 15:36:41.890144-04
84946	2	22	\N		1	t	2019-09-26 15:36:41.890144-04
84947	2	22	\N		1	t	2019-09-26 15:36:41.890144-04
84948	2	22	\N		1	t	2019-09-26 15:36:41.890144-04
84949	1	19	\N		1	t	2019-09-26 15:36:41.890144-04
84950	2	22	\N		1	t	2019-09-26 15:36:41.890144-04
84951	2	22	\N		1	t	2019-09-26 15:36:41.890144-04
84952	2	22	\N		1	t	2019-09-26 15:36:41.890144-04
84953	2	22	\N		1	t	2019-09-26 15:36:41.890144-04
84954	1	19	\N		1	t	2019-09-26 15:36:41.890144-04
84955	2	22	\N		1	t	2019-09-26 15:36:41.890144-04
84956	2	22	\N		1	t	2019-09-26 15:36:41.890144-04
84957	2	22	\N		1	t	2019-09-26 15:36:41.890144-04
\.


--
-- Data for Name: subcategorias; Type: TABLE DATA; Schema: bancos; Owner: geekhack
--

COPY bancos.subcategorias (id, codigo, referencia, titulo, descripcion, categoria, estatus, activo, fecha_creacion) FROM stdin;
20	INT	interes	Intereses	\N	1	1	t	2019-04-08 09:46:43.861978-04
21	COM	comision	Comisiones	\N	2	1	t	2019-04-08 09:46:43.861978-04
22	OTG	otroegreso	Otros egresos	\N	2	1	t	2019-04-08 09:46:43.861978-04
19	OTE	otroingreso	Otros ingresos	\N	1	1	t	2019-04-08 09:46:43.861978-04
23	\N	\N	Ventas	\N	1	1	t	2019-04-29 18:14:37.405701-04
24	\N	\N	Comisiones		1	1	t	2019-04-29 18:14:53.518754-04
25	\N	\N	Prestamos		1	1	t	2019-04-29 18:15:15.336373-04
26	\N	\N	Pago ISLR	\N	2	1	t	2019-04-29 18:15:43.713588-04
27	\N	\N	Nomina	\N	2	1	t	2019-04-29 18:15:57.159017-04
28	\N	\N	Servicios	\N	2	1	t	2019-04-29 18:16:13.623642-04
29	\N	\N	Intereses	\N	2	1	t	2019-04-30 09:30:01.848782-04
\.


--
-- Data for Name: tipos; Type: TABLE DATA; Schema: bancos; Owner: geekhack
--

COPY bancos.tipos (id, codigo, referencia, grupo, tipo, descripcion, fecha_creacion) FROM stdin;
\.


--
-- Data for Name: titulares; Type: TABLE DATA; Schema: bancos; Owner: geekhack
--

COPY bancos.titulares (id, tipo, nombre, apellido, rif, telefono, email, estatus, activo, "idCiudad", "idPais", zona_postal, fecha_creacion, usuario) FROM stdin;
\.


--
-- Data for Name: conciliacion_reporte; Type: TABLE DATA; Schema: conciliacion; Owner: geekhack
--

COPY conciliacion.conciliacion_reporte (id, fecha_creacion, descripcion, usuario, total_c, total_nc, total_ncm) FROM stdin;
46	20:31:27.873515+00	\N	6	2	1	0
47	01:35:14.072723+00	\N	6	1	1	0
48	14:16:12.100802+00	\N	6	3	2	0
49	15:12:32.357616+00	\N	6	1	3	0
50	19:58:14.468048+00	\N	6	1	4	0
\.


--
-- Data for Name: conciliacion_reportepago; Type: TABLE DATA; Schema: conciliacion; Owner: geekhack
--

COPY conciliacion.conciliacion_reportepago (id, id_reporte, estatus, id_pago, usuario) FROM stdin;
200	46	t	209	6
201	46	t	210	6
202	47	t	212	6
203	48	t	213	6
204	48	t	214	6
205	48	t	216	6
\.


--
-- Data for Name: ciudades; Type: TABLE DATA; Schema: maestros; Owner: geekhack
--

COPY maestros.ciudades (id, codigo, referencia, nombre, descripcion, estatus, activo, "idPais", estado) FROM stdin;
1	1	\N	Maroa	\N	\N	t	\N	1
2	2	\N	Puerto Ayacucho	\N	\N	t	\N	1
3	3	\N	San Fernando de Atabapo	\N	\N	t	\N	1
4	4	\N	Anaco	\N	\N	t	\N	2
5	5	\N	Aragua de Barcelona	\N	\N	t	\N	2
6	6	\N	Barcelona	\N	\N	t	\N	2
7	7	\N	Boca de Uchire	\N	\N	t	\N	2
8	8	\N	Cantaura	\N	\N	t	\N	2
9	9	\N	Clarines	\N	\N	t	\N	2
10	10	\N	El Chaparro	\N	\N	t	\N	2
11	11	\N	El Pao Anzoátegui	\N	\N	t	\N	2
12	12	\N	El Tigre	\N	\N	t	\N	2
13	13	\N	El Tigrito	\N	\N	t	\N	2
14	14	\N	Guanape	\N	\N	t	\N	2
15	15	\N	Guanta	\N	\N	t	\N	2
16	16	\N	Lechería	\N	\N	t	\N	2
17	17	\N	Onoto	\N	\N	t	\N	2
18	18	\N	Pariaguán	\N	\N	t	\N	2
19	19	\N	Píritu	\N	\N	t	\N	2
20	20	\N	Puerto La Cruz	\N	\N	t	\N	2
21	21	\N	Puerto Píritu	\N	\N	t	\N	2
22	22	\N	Sabana de Uchire	\N	\N	t	\N	2
23	23	\N	San Mateo Anzoátegui	\N	\N	t	\N	2
24	24	\N	San Pablo Anzoátegui	\N	\N	t	\N	2
25	25	\N	San Tomé	\N	\N	t	\N	2
26	26	\N	Santa Ana de Anzoátegui	\N	\N	t	\N	2
27	27	\N	Santa Fe Anzoátegui	\N	\N	t	\N	2
28	28	\N	Santa Rosa	\N	\N	t	\N	2
29	29	\N	Soledad	\N	\N	t	\N	2
30	30	\N	Urica	\N	\N	t	\N	2
31	31	\N	Valle de Guanape	\N	\N	t	\N	2
32	43	\N	Achaguas	\N	\N	t	\N	3
33	44	\N	Biruaca	\N	\N	t	\N	3
34	45	\N	Bruzual	\N	\N	t	\N	3
35	46	\N	El Amparo	\N	\N	t	\N	3
36	47	\N	El Nula	\N	\N	t	\N	3
37	48	\N	Elorza	\N	\N	t	\N	3
38	49	\N	Guasdualito	\N	\N	t	\N	3
39	50	\N	Mantecal	\N	\N	t	\N	3
40	51	\N	Puerto Páez	\N	\N	t	\N	3
41	52	\N	San Fernando de Apure	\N	\N	t	\N	3
42	53	\N	San Juan de Payara	\N	\N	t	\N	3
43	54	\N	Barbacoas	\N	\N	t	\N	4
44	55	\N	Cagua	\N	\N	t	\N	4
45	56	\N	Camatagua	\N	\N	t	\N	4
46	58	\N	Choroní	\N	\N	t	\N	4
47	59	\N	Colonia Tovar	\N	\N	t	\N	4
48	60	\N	El Consejo	\N	\N	t	\N	4
49	61	\N	La Victoria	\N	\N	t	\N	4
50	62	\N	Las Tejerías	\N	\N	t	\N	4
51	63	\N	Magdaleno	\N	\N	t	\N	4
52	64	\N	Maracay	\N	\N	t	\N	4
53	65	\N	Ocumare de La Costa	\N	\N	t	\N	4
54	66	\N	Palo Negro	\N	\N	t	\N	4
55	67	\N	San Casimiro	\N	\N	t	\N	4
56	68	\N	San Mateo	\N	\N	t	\N	4
57	69	\N	San Sebastián	\N	\N	t	\N	4
58	70	\N	Santa Cruz de Aragua	\N	\N	t	\N	4
59	71	\N	Tocorón	\N	\N	t	\N	4
60	72	\N	Turmero	\N	\N	t	\N	4
61	73	\N	Villa de Cura	\N	\N	t	\N	4
62	74	\N	Zuata	\N	\N	t	\N	4
63	75	\N	Barinas	\N	\N	t	\N	5
64	76	\N	Barinitas	\N	\N	t	\N	5
65	77	\N	Barrancas	\N	\N	t	\N	5
66	78	\N	Calderas	\N	\N	t	\N	5
67	79	\N	Capitanejo	\N	\N	t	\N	5
68	80	\N	Ciudad Bolivia	\N	\N	t	\N	5
69	81	\N	El Cantón	\N	\N	t	\N	5
70	82	\N	Las Veguitas	\N	\N	t	\N	5
71	83	\N	Libertad de Barinas	\N	\N	t	\N	5
72	84	\N	Sabaneta	\N	\N	t	\N	5
73	85	\N	Santa Bárbara de Barinas	\N	\N	t	\N	5
74	86	\N	Socopó	\N	\N	t	\N	5
75	87	\N	Caicara del Orinoco	\N	\N	t	\N	6
76	88	\N	Canaima	\N	\N	t	\N	6
77	89	\N	Ciudad Bolívar	\N	\N	t	\N	6
78	90	\N	Ciudad Piar	\N	\N	t	\N	6
79	91	\N	El Callao	\N	\N	t	\N	6
80	92	\N	El Dorado	\N	\N	t	\N	6
81	93	\N	El Manteco	\N	\N	t	\N	6
82	94	\N	El Palmar	\N	\N	t	\N	6
83	95	\N	El Pao	\N	\N	t	\N	6
84	96	\N	Guasipati	\N	\N	t	\N	6
85	97	\N	Guri	\N	\N	t	\N	6
86	98	\N	La Paragua	\N	\N	t	\N	6
87	99	\N	Matanzas	\N	\N	t	\N	6
88	100	\N	Puerto Ordaz	\N	\N	t	\N	6
89	101	\N	San Félix	\N	\N	t	\N	6
90	102	\N	Santa Elena de Uairén	\N	\N	t	\N	6
91	103	\N	Tumeremo	\N	\N	t	\N	6
92	104	\N	Unare	\N	\N	t	\N	6
93	105	\N	Upata	\N	\N	t	\N	6
94	106	\N	Bejuma	\N	\N	t	\N	7
95	107	\N	Belén	\N	\N	t	\N	7
96	108	\N	Campo de Carabobo	\N	\N	t	\N	7
97	109	\N	Canoabo	\N	\N	t	\N	7
98	110	\N	Central Tacarigua	\N	\N	t	\N	7
99	111	\N	Chirgua	\N	\N	t	\N	7
100	112	\N	Ciudad Alianza	\N	\N	t	\N	7
101	113	\N	El Palito	\N	\N	t	\N	7
102	114	\N	Guacara	\N	\N	t	\N	7
103	115	\N	Guigue	\N	\N	t	\N	7
104	116	\N	Las Trincheras	\N	\N	t	\N	7
105	117	\N	Los Guayos	\N	\N	t	\N	7
106	118	\N	Mariara	\N	\N	t	\N	7
107	119	\N	Miranda	\N	\N	t	\N	7
108	120	\N	Montalbán	\N	\N	t	\N	7
109	121	\N	Morón	\N	\N	t	\N	7
110	122	\N	Naguanagua	\N	\N	t	\N	7
111	123	\N	Puerto Cabello	\N	\N	t	\N	7
112	124	\N	San Joaquín	\N	\N	t	\N	7
113	125	\N	Tocuyito	\N	\N	t	\N	7
114	126	\N	Urama	\N	\N	t	\N	7
115	127	\N	Valencia	\N	\N	t	\N	7
116	128	\N	Vigirimita	\N	\N	t	\N	7
117	129	\N	Aguirre	\N	\N	t	\N	8
118	130	\N	Apartaderos Cojedes	\N	\N	t	\N	8
119	131	\N	Arismendi	\N	\N	t	\N	8
120	132	\N	Camuriquito	\N	\N	t	\N	8
121	133	\N	El Baúl	\N	\N	t	\N	8
122	134	\N	El Limón	\N	\N	t	\N	8
123	135	\N	El Pao Cojedes	\N	\N	t	\N	8
124	136	\N	El Socorro	\N	\N	t	\N	8
125	137	\N	La Aguadita	\N	\N	t	\N	8
126	138	\N	Las Vegas	\N	\N	t	\N	8
127	139	\N	Libertad de Cojedes	\N	\N	t	\N	8
128	140	\N	Mapuey	\N	\N	t	\N	8
129	141	\N	Piñedo	\N	\N	t	\N	8
130	142	\N	Samancito	\N	\N	t	\N	8
131	143	\N	San Carlos	\N	\N	t	\N	8
132	144	\N	Sucre	\N	\N	t	\N	8
133	145	\N	Tinaco	\N	\N	t	\N	8
134	146	\N	Tinaquillo	\N	\N	t	\N	8
135	147	\N	Vallecito	\N	\N	t	\N	8
136	148	\N	Tucupita	\N	\N	t	\N	9
137	149	\N	Caracas	\N	\N	t	\N	24
138	150	\N	El Junquito	\N	\N	t	\N	24
139	151	\N	Adícora	\N	\N	t	\N	10
140	152	\N	Boca de Aroa	\N	\N	t	\N	10
141	153	\N	Cabure	\N	\N	t	\N	10
142	154	\N	Capadare	\N	\N	t	\N	10
143	155	\N	Capatárida	\N	\N	t	\N	10
144	156	\N	Chichiriviche	\N	\N	t	\N	10
145	157	\N	Churuguara	\N	\N	t	\N	10
146	158	\N	Coro	\N	\N	t	\N	10
147	159	\N	Cumarebo	\N	\N	t	\N	10
148	160	\N	Dabajuro	\N	\N	t	\N	10
149	161	\N	Judibana	\N	\N	t	\N	10
150	162	\N	La Cruz de Taratara	\N	\N	t	\N	10
151	163	\N	La Vela de Coro	\N	\N	t	\N	10
152	164	\N	Los Taques	\N	\N	t	\N	10
153	165	\N	Maparari	\N	\N	t	\N	10
154	166	\N	Mene de Mauroa	\N	\N	t	\N	10
155	167	\N	Mirimire	\N	\N	t	\N	10
156	168	\N	Pedregal	\N	\N	t	\N	10
157	169	\N	Píritu Falcón	\N	\N	t	\N	10
158	170	\N	Pueblo Nuevo Falcón	\N	\N	t	\N	10
159	171	\N	Puerto Cumarebo	\N	\N	t	\N	10
160	172	\N	Punta Cardón	\N	\N	t	\N	10
161	173	\N	Punto Fijo	\N	\N	t	\N	10
162	174	\N	San Juan de Los Cayos	\N	\N	t	\N	10
163	175	\N	San Luis	\N	\N	t	\N	10
164	176	\N	Santa Ana Falcón	\N	\N	t	\N	10
165	177	\N	Santa Cruz De Bucaral	\N	\N	t	\N	10
166	178	\N	Tocopero	\N	\N	t	\N	10
167	179	\N	Tocuyo de La Costa	\N	\N	t	\N	10
168	180	\N	Tucacas	\N	\N	t	\N	10
169	181	\N	Yaracal	\N	\N	t	\N	10
170	182	\N	Altagracia de Orituco	\N	\N	t	\N	11
171	183	\N	Cabruta	\N	\N	t	\N	11
172	184	\N	Calabozo	\N	\N	t	\N	11
173	185	\N	Camaguán	\N	\N	t	\N	11
174	196	\N	Chaguaramas Guárico	\N	\N	t	\N	11
175	197	\N	El Socorro	\N	\N	t	\N	11
176	198	\N	El Sombrero	\N	\N	t	\N	11
177	199	\N	Las Mercedes de Los Llanos	\N	\N	t	\N	11
178	200	\N	Lezama	\N	\N	t	\N	11
179	201	\N	Onoto	\N	\N	t	\N	11
180	202	\N	Ortíz	\N	\N	t	\N	11
181	203	\N	San José de Guaribe	\N	\N	t	\N	11
182	204	\N	San Juan de Los Morros	\N	\N	t	\N	11
183	205	\N	San Rafael de Laya	\N	\N	t	\N	11
184	206	\N	Santa María de Ipire	\N	\N	t	\N	11
185	207	\N	Tucupido	\N	\N	t	\N	11
186	208	\N	Valle de La Pascua	\N	\N	t	\N	11
187	209	\N	Zaraza	\N	\N	t	\N	11
188	210	\N	Aguada Grande	\N	\N	t	\N	12
189	211	\N	Atarigua	\N	\N	t	\N	12
190	212	\N	Barquisimeto	\N	\N	t	\N	12
191	213	\N	Bobare	\N	\N	t	\N	12
192	214	\N	Cabudare	\N	\N	t	\N	12
193	215	\N	Carora	\N	\N	t	\N	12
194	216	\N	Cubiro	\N	\N	t	\N	12
195	217	\N	Cují	\N	\N	t	\N	12
196	218	\N	Duaca	\N	\N	t	\N	12
197	219	\N	El Manzano	\N	\N	t	\N	12
198	220	\N	El Tocuyo	\N	\N	t	\N	12
199	221	\N	Guaríco	\N	\N	t	\N	12
200	222	\N	Humocaro Alto	\N	\N	t	\N	12
201	223	\N	Humocaro Bajo	\N	\N	t	\N	12
202	224	\N	La Miel	\N	\N	t	\N	12
203	225	\N	Moroturo	\N	\N	t	\N	12
204	226	\N	Quíbor	\N	\N	t	\N	12
205	227	\N	Río Claro	\N	\N	t	\N	12
206	228	\N	Sanare	\N	\N	t	\N	12
207	229	\N	Santa Inés	\N	\N	t	\N	12
208	230	\N	Sarare	\N	\N	t	\N	12
209	231	\N	Siquisique	\N	\N	t	\N	12
210	232	\N	Tintorero	\N	\N	t	\N	12
211	233	\N	Apartaderos Mérida	\N	\N	t	\N	13
212	234	\N	Arapuey	\N	\N	t	\N	13
213	235	\N	Bailadores	\N	\N	t	\N	13
214	236	\N	Caja Seca	\N	\N	t	\N	13
215	237	\N	Canaguá	\N	\N	t	\N	13
216	238	\N	Chachopo	\N	\N	t	\N	13
217	239	\N	Chiguara	\N	\N	t	\N	13
218	240	\N	Ejido	\N	\N	t	\N	13
219	241	\N	El Vigía	\N	\N	t	\N	13
220	242	\N	La Azulita	\N	\N	t	\N	13
221	243	\N	La Playa	\N	\N	t	\N	13
222	244	\N	Lagunillas Mérida	\N	\N	t	\N	13
223	245	\N	Mérida	\N	\N	t	\N	13
224	246	\N	Mesa de Bolívar	\N	\N	t	\N	13
225	247	\N	Mucuchíes	\N	\N	t	\N	13
226	248	\N	Mucujepe	\N	\N	t	\N	13
227	249	\N	Mucuruba	\N	\N	t	\N	13
228	250	\N	Nueva Bolivia	\N	\N	t	\N	13
229	251	\N	Palmarito	\N	\N	t	\N	13
230	252	\N	Pueblo Llano	\N	\N	t	\N	13
231	253	\N	Santa Cruz de Mora	\N	\N	t	\N	13
232	254	\N	Santa Elena de Arenales	\N	\N	t	\N	13
233	255	\N	Santo Domingo	\N	\N	t	\N	13
234	256	\N	Tabáy	\N	\N	t	\N	13
235	257	\N	Timotes	\N	\N	t	\N	13
236	258	\N	Torondoy	\N	\N	t	\N	13
237	259	\N	Tovar	\N	\N	t	\N	13
238	260	\N	Tucani	\N	\N	t	\N	13
239	261	\N	Zea	\N	\N	t	\N	13
240	262	\N	Araguita	\N	\N	t	\N	14
241	263	\N	Carrizal	\N	\N	t	\N	14
242	264	\N	Caucagua	\N	\N	t	\N	14
243	265	\N	Chaguaramas Miranda	\N	\N	t	\N	14
244	266	\N	Charallave	\N	\N	t	\N	14
245	267	\N	Chirimena	\N	\N	t	\N	14
246	268	\N	Chuspa	\N	\N	t	\N	14
247	269	\N	Cúa	\N	\N	t	\N	14
248	270	\N	Cupira	\N	\N	t	\N	14
249	271	\N	Curiepe	\N	\N	t	\N	14
250	272	\N	El Guapo	\N	\N	t	\N	14
251	273	\N	El Jarillo	\N	\N	t	\N	14
252	274	\N	Filas de Mariche	\N	\N	t	\N	14
253	275	\N	Guarenas	\N	\N	t	\N	14
254	276	\N	Guatire	\N	\N	t	\N	14
255	277	\N	Higuerote	\N	\N	t	\N	14
256	278	\N	Los Anaucos	\N	\N	t	\N	14
257	279	\N	Los Teques	\N	\N	t	\N	14
258	280	\N	Ocumare del Tuy	\N	\N	t	\N	14
259	281	\N	Panaquire	\N	\N	t	\N	14
260	282	\N	Paracotos	\N	\N	t	\N	14
261	283	\N	Río Chico	\N	\N	t	\N	14
262	284	\N	San Antonio de Los Altos	\N	\N	t	\N	14
263	285	\N	San Diego de Los Altos	\N	\N	t	\N	14
264	286	\N	San Fernando del Guapo	\N	\N	t	\N	14
265	287	\N	San Francisco de Yare	\N	\N	t	\N	14
266	288	\N	San José de Los Altos	\N	\N	t	\N	14
267	289	\N	San José de Río Chico	\N	\N	t	\N	14
268	290	\N	San Pedro de Los Altos	\N	\N	t	\N	14
269	291	\N	Santa Lucía	\N	\N	t	\N	14
270	292	\N	Santa Teresa	\N	\N	t	\N	14
271	293	\N	Tacarigua de La Laguna	\N	\N	t	\N	14
272	294	\N	Tacarigua de Mamporal	\N	\N	t	\N	14
273	295	\N	Tácata	\N	\N	t	\N	14
274	296	\N	Turumo	\N	\N	t	\N	14
275	297	\N	Aguasay	\N	\N	t	\N	15
276	298	\N	Aragua de Maturín	\N	\N	t	\N	15
277	299	\N	Barrancas del Orinoco	\N	\N	t	\N	15
278	300	\N	Caicara de Maturín	\N	\N	t	\N	15
279	301	\N	Caripe	\N	\N	t	\N	15
280	302	\N	Caripito	\N	\N	t	\N	15
281	303	\N	Chaguaramal	\N	\N	t	\N	15
282	305	\N	Chaguaramas Monagas	\N	\N	t	\N	15
283	307	\N	El Furrial	\N	\N	t	\N	15
284	308	\N	El Tejero	\N	\N	t	\N	15
285	309	\N	Jusepín	\N	\N	t	\N	15
286	310	\N	La Toscana	\N	\N	t	\N	15
287	311	\N	Maturín	\N	\N	t	\N	15
288	312	\N	Miraflores	\N	\N	t	\N	15
289	313	\N	Punta de Mata	\N	\N	t	\N	15
290	314	\N	Quiriquire	\N	\N	t	\N	15
291	315	\N	San Antonio de Maturín	\N	\N	t	\N	15
292	316	\N	San Vicente Monagas	\N	\N	t	\N	15
293	317	\N	Santa Bárbara	\N	\N	t	\N	15
294	318	\N	Temblador	\N	\N	t	\N	15
295	319	\N	Teresen	\N	\N	t	\N	15
296	320	\N	Uracoa	\N	\N	t	\N	15
297	321	\N	Altagracia	\N	\N	t	\N	16
298	322	\N	Boca de Pozo	\N	\N	t	\N	16
299	323	\N	Boca de Río	\N	\N	t	\N	16
300	324	\N	El Espinal	\N	\N	t	\N	16
301	325	\N	El Valle del Espíritu Santo	\N	\N	t	\N	16
302	326	\N	El Yaque	\N	\N	t	\N	16
303	327	\N	Juangriego	\N	\N	t	\N	16
304	328	\N	La Asunción	\N	\N	t	\N	16
305	329	\N	La Guardia	\N	\N	t	\N	16
306	330	\N	Pampatar	\N	\N	t	\N	16
307	331	\N	Porlamar	\N	\N	t	\N	16
308	332	\N	Puerto Fermín	\N	\N	t	\N	16
309	333	\N	Punta de Piedras	\N	\N	t	\N	16
310	334	\N	San Francisco de Macanao	\N	\N	t	\N	16
311	335	\N	San Juan Bautista	\N	\N	t	\N	16
312	336	\N	San Pedro de Coche	\N	\N	t	\N	16
313	337	\N	Santa Ana de Nueva Esparta	\N	\N	t	\N	16
314	338	\N	Villa Rosa	\N	\N	t	\N	16
315	339	\N	Acarigua	\N	\N	t	\N	17
316	340	\N	Agua Blanca	\N	\N	t	\N	17
317	341	\N	Araure	\N	\N	t	\N	17
318	342	\N	Biscucuy	\N	\N	t	\N	17
319	343	\N	Boconoito	\N	\N	t	\N	17
320	344	\N	Campo Elías	\N	\N	t	\N	17
321	345	\N	Chabasquén	\N	\N	t	\N	17
322	346	\N	Guanare	\N	\N	t	\N	17
323	347	\N	Guanarito	\N	\N	t	\N	17
324	348	\N	La Aparición	\N	\N	t	\N	17
325	349	\N	La Misión	\N	\N	t	\N	17
326	350	\N	Mesa de Cavacas	\N	\N	t	\N	17
327	351	\N	Ospino	\N	\N	t	\N	17
328	352	\N	Papelón	\N	\N	t	\N	17
329	353	\N	Payara	\N	\N	t	\N	17
330	354	\N	Pimpinela	\N	\N	t	\N	17
331	355	\N	Píritu de Portuguesa	\N	\N	t	\N	17
332	356	\N	San Rafael de Onoto	\N	\N	t	\N	17
333	357	\N	Santa Rosalía	\N	\N	t	\N	17
334	358	\N	Turén	\N	\N	t	\N	17
335	359	\N	Altos de Sucre	\N	\N	t	\N	18
336	360	\N	Araya	\N	\N	t	\N	18
337	361	\N	Cariaco	\N	\N	t	\N	18
338	362	\N	Carúpano	\N	\N	t	\N	18
339	363	\N	Casanay	\N	\N	t	\N	18
340	364	\N	Cumaná	\N	\N	t	\N	18
341	365	\N	Cumanacoa	\N	\N	t	\N	18
342	366	\N	El Morro Puerto Santo	\N	\N	t	\N	18
343	367	\N	El Pilar	\N	\N	t	\N	18
344	368	\N	El Poblado	\N	\N	t	\N	18
345	369	\N	Guaca	\N	\N	t	\N	18
346	370	\N	Guiria	\N	\N	t	\N	18
347	371	\N	Irapa	\N	\N	t	\N	18
348	372	\N	Manicuare	\N	\N	t	\N	18
349	373	\N	Mariguitar	\N	\N	t	\N	18
350	374	\N	Río Caribe	\N	\N	t	\N	18
351	375	\N	San Antonio del Golfo	\N	\N	t	\N	18
352	376	\N	San José de Aerocuar	\N	\N	t	\N	18
353	377	\N	San Vicente de Sucre	\N	\N	t	\N	18
354	378	\N	Santa Fe de Sucre	\N	\N	t	\N	18
355	379	\N	Tunapuy	\N	\N	t	\N	18
356	380	\N	Yaguaraparo	\N	\N	t	\N	18
357	381	\N	Yoco	\N	\N	t	\N	18
358	382	\N	Abejales	\N	\N	t	\N	19
359	383	\N	Borota	\N	\N	t	\N	19
360	384	\N	Bramon	\N	\N	t	\N	19
361	385	\N	Capacho	\N	\N	t	\N	19
362	386	\N	Colón	\N	\N	t	\N	19
363	387	\N	Coloncito	\N	\N	t	\N	19
364	388	\N	Cordero	\N	\N	t	\N	19
365	389	\N	El Cobre	\N	\N	t	\N	19
366	390	\N	El Pinal	\N	\N	t	\N	19
367	391	\N	Independencia	\N	\N	t	\N	19
368	392	\N	La Fría	\N	\N	t	\N	19
369	393	\N	La Grita	\N	\N	t	\N	19
370	394	\N	La Pedrera	\N	\N	t	\N	19
371	395	\N	La Tendida	\N	\N	t	\N	19
372	396	\N	Las Delicias	\N	\N	t	\N	19
373	397	\N	Las Hernández	\N	\N	t	\N	19
374	398	\N	Lobatera	\N	\N	t	\N	19
375	399	\N	Michelena	\N	\N	t	\N	19
376	400	\N	Palmira	\N	\N	t	\N	19
377	401	\N	Pregonero	\N	\N	t	\N	19
378	402	\N	Queniquea	\N	\N	t	\N	19
379	403	\N	Rubio	\N	\N	t	\N	19
380	404	\N	San Antonio del Tachira	\N	\N	t	\N	19
381	405	\N	San Cristobal	\N	\N	t	\N	19
382	406	\N	San José de Bolívar	\N	\N	t	\N	19
383	407	\N	San Josecito	\N	\N	t	\N	19
384	408	\N	San Pedro del Río	\N	\N	t	\N	19
385	409	\N	Santa Ana Táchira	\N	\N	t	\N	19
386	410	\N	Seboruco	\N	\N	t	\N	19
387	411	\N	Táriba	\N	\N	t	\N	19
388	412	\N	Umuquena	\N	\N	t	\N	19
389	413	\N	Ureña	\N	\N	t	\N	19
390	414	\N	Batatal	\N	\N	t	\N	20
391	415	\N	Betijoque	\N	\N	t	\N	20
392	416	\N	Boconó	\N	\N	t	\N	20
393	417	\N	Carache	\N	\N	t	\N	20
394	418	\N	Chejende	\N	\N	t	\N	20
395	419	\N	Cuicas	\N	\N	t	\N	20
396	420	\N	El Dividive	\N	\N	t	\N	20
397	421	\N	El Jaguito	\N	\N	t	\N	20
398	422	\N	Escuque	\N	\N	t	\N	20
399	423	\N	Isnotú	\N	\N	t	\N	20
400	424	\N	Jajó	\N	\N	t	\N	20
401	425	\N	La Ceiba	\N	\N	t	\N	20
402	426	\N	La Concepción de Trujllo	\N	\N	t	\N	20
403	427	\N	La Mesa de Esnujaque	\N	\N	t	\N	20
404	428	\N	La Puerta	\N	\N	t	\N	20
405	429	\N	La Quebrada	\N	\N	t	\N	20
406	430	\N	Mendoza Fría	\N	\N	t	\N	20
407	431	\N	Meseta de Chimpire	\N	\N	t	\N	20
408	432	\N	Monay	\N	\N	t	\N	20
409	433	\N	Motatán	\N	\N	t	\N	20
410	434	\N	Pampán	\N	\N	t	\N	20
411	435	\N	Pampanito	\N	\N	t	\N	20
412	436	\N	Sabana de Mendoza	\N	\N	t	\N	20
413	437	\N	San Lázaro	\N	\N	t	\N	20
414	438	\N	Santa Ana de Trujillo	\N	\N	t	\N	20
415	439	\N	Tostós	\N	\N	t	\N	20
416	440	\N	Trujillo	\N	\N	t	\N	20
417	441	\N	Valera	\N	\N	t	\N	20
418	442	\N	Carayaca	\N	\N	t	\N	21
419	443	\N	Litoral	\N	\N	t	\N	21
420	444	\N	Archipiélago Los Roques	\N	\N	t	\N	25
421	445	\N	Aroa	\N	\N	t	\N	22
422	446	\N	Boraure	\N	\N	t	\N	22
423	447	\N	Campo Elías de Yaracuy	\N	\N	t	\N	22
424	448	\N	Chivacoa	\N	\N	t	\N	22
425	449	\N	Cocorote	\N	\N	t	\N	22
426	450	\N	Farriar	\N	\N	t	\N	22
427	451	\N	Guama	\N	\N	t	\N	22
428	452	\N	Marín	\N	\N	t	\N	22
429	453	\N	Nirgua	\N	\N	t	\N	22
430	454	\N	Sabana de Parra	\N	\N	t	\N	22
431	455	\N	Salom	\N	\N	t	\N	22
432	456	\N	San Felipe	\N	\N	t	\N	22
433	457	\N	San Pablo de Yaracuy	\N	\N	t	\N	22
434	458	\N	Urachiche	\N	\N	t	\N	22
435	459	\N	Yaritagua	\N	\N	t	\N	22
436	460	\N	Yumare	\N	\N	t	\N	22
437	461	\N	Bachaquero	\N	\N	t	\N	23
438	462	\N	Bobures	\N	\N	t	\N	23
439	463	\N	Cabimas	\N	\N	t	\N	23
440	464	\N	Campo Concepción	\N	\N	t	\N	23
441	465	\N	Campo Mara	\N	\N	t	\N	23
442	466	\N	Campo Rojo	\N	\N	t	\N	23
443	467	\N	Carrasquero	\N	\N	t	\N	23
444	468	\N	Casigua	\N	\N	t	\N	23
445	469	\N	Chiquinquirá	\N	\N	t	\N	23
446	470	\N	Ciudad Ojeda	\N	\N	t	\N	23
447	471	\N	El Batey	\N	\N	t	\N	23
448	472	\N	El Carmelo	\N	\N	t	\N	23
449	473	\N	El Chivo	\N	\N	t	\N	23
450	474	\N	El Guayabo	\N	\N	t	\N	23
451	475	\N	El Mene	\N	\N	t	\N	23
452	476	\N	El Venado	\N	\N	t	\N	23
453	477	\N	Encontrados	\N	\N	t	\N	23
454	478	\N	Gibraltar	\N	\N	t	\N	23
455	479	\N	Isla de Toas	\N	\N	t	\N	23
456	480	\N	La Concepción del Zulia	\N	\N	t	\N	23
457	481	\N	La Paz	\N	\N	t	\N	23
458	482	\N	La Sierrita	\N	\N	t	\N	23
459	483	\N	Lagunillas del Zulia	\N	\N	t	\N	23
460	484	\N	Las Piedras de Perijá	\N	\N	t	\N	23
461	485	\N	Los Cortijos	\N	\N	t	\N	23
462	486	\N	Machiques	\N	\N	t	\N	23
463	487	\N	Maracaibo	\N	\N	t	\N	23
464	488	\N	Mene Grande	\N	\N	t	\N	23
465	489	\N	Palmarejo	\N	\N	t	\N	23
466	490	\N	Paraguaipoa	\N	\N	t	\N	23
467	491	\N	Potrerito	\N	\N	t	\N	23
468	492	\N	Pueblo Nuevo del Zulia	\N	\N	t	\N	23
469	493	\N	Puertos de Altagracia	\N	\N	t	\N	23
470	494	\N	Punta Gorda	\N	\N	t	\N	23
471	495	\N	Sabaneta de Palma	\N	\N	t	\N	23
472	496	\N	San Francisco	\N	\N	t	\N	23
473	497	\N	San José de Perijá	\N	\N	t	\N	23
474	498	\N	San Rafael del Moján	\N	\N	t	\N	23
475	499	\N	San Timoteo	\N	\N	t	\N	23
476	500	\N	Santa Bárbara Del Zulia	\N	\N	t	\N	23
477	501	\N	Santa Cruz de Mara	\N	\N	t	\N	23
478	502	\N	Santa Cruz del Zulia	\N	\N	t	\N	23
479	503	\N	Santa Rita	\N	\N	t	\N	23
480	504	\N	Sinamaica	\N	\N	t	\N	23
481	505	\N	Tamare	\N	\N	t	\N	23
482	506	\N	Tía Juana	\N	\N	t	\N	23
483	507	\N	Villa del Rosario	\N	\N	t	\N	23
484	508	\N	La Guaira	\N	\N	t	\N	21
485	509	\N	Catia La Mar	\N	\N	t	\N	21
486	510	\N	Macuto	\N	\N	t	\N	21
487	511	\N	Naiguatá	\N	\N	t	\N	21
488	512	\N	Archipiélago Los Monjes	\N	\N	t	\N	25
489	513	\N	Isla La Tortuga y Cayos adyacentes	\N	\N	t	\N	25
490	514	\N	Isla La Sola	\N	\N	t	\N	25
491	515	\N	Islas Los Testigos	\N	\N	t	\N	25
492	516	\N	Islas Los Frailes	\N	\N	t	\N	25
493	517	\N	Isla La Orchila	\N	\N	t	\N	25
494	518	\N	Archipiélago Las Aves	\N	\N	t	\N	25
495	519	\N	Isla de Aves	\N	\N	t	\N	25
496	520	\N	Isla La Blanquilla	\N	\N	t	\N	25
497	521	\N	Isla de Patos	\N	\N	t	\N	25
498	522	\N	Islas Los Hermanos	\N	\N	t	\N	25
\.


--
-- Data for Name: divisas; Type: TABLE DATA; Schema: maestros; Owner: geekhack
--

COPY maestros.divisas (id, nombre, nombreiso, codigo, simbolo, tipo, activo) FROM stdin;
3	Dólar	Dólar Americano	USD	$	fisica	t
4	bitcoin	bitcoin	BTC	BTC	virtual	t
5	Ethereum	Ethereum	ETH	ETH	virtual	t
1	Bolívar	Bolivar soberano	VES	B	fisica	t
\.


--
-- Data for Name: estados; Type: TABLE DATA; Schema: maestros; Owner: geekhack
--

COPY maestros.estados (id, codigo, nombre, estatus, idpais) FROM stdin;
1	1	Amazonas	t	1
2	2	Anzoátegui	t	1
3	3	Apure	t	1
4	4	Aragua	t	1
5	5	Barinas	t	1
6	6	Bolívar	t	1
7	7	Carabobo	t	1
8	8	Cojedes	t	1
9	9	Delta Amacuro	t	1
10	10	Falcón	t	1
11	11	Guárico	t	1
12	12	Lara	t	1
13	13	Mérida	t	1
14	14	Miranda	t	1
15	15	Monagas	t	1
16	16	Nueva Esparta	t	1
17	17	Portuguesa	t	1
18	18	Sucre	t	1
19	19	Táchira	t	1
20	20	Trujillo	t	1
21	21	Vargas	t	1
22	22	Yaracuy	t	1
23	23	Zulia	t	1
24	24	Distrito Capital	t	1
25	25	Dependencias Federales	t	1
\.


--
-- Data for Name: funciones; Type: TABLE DATA; Schema: maestros; Owner: postgres
--

COPY maestros.funciones (_id, nombre) FROM stdin;
1	all
2	registrar
3	editar
4	eliminar
5	bloquear
6	desbloquera
7	activar
8	desactivar
9	reenviar clave
\.


--
-- Data for Name: identificar_banco; Type: TABLE DATA; Schema: maestros; Owner: geekhack
--

COPY maestros.identificar_banco (id, descripcion, id_banco, activo) FROM stdin;
3	0191	3	t
1	OFXH	1	t
4	Cons	4	t
2	Cód	2	t
5	prueba	6	t
6	prueba	8	t
\.


--
-- Data for Name: modulos; Type: TABLE DATA; Schema: maestros; Owner: postgres
--

COPY maestros.modulos (_id, nombre) FROM stdin;
1	all
2	usuarios
3	maestros
4	roles
5	seguridad
6	autoregistrado
\.


--
-- Data for Name: paises; Type: TABLE DATA; Schema: maestros; Owner: geekhack
--

COPY maestros.paises (id, codigo, referencia, nombre, descripcion, estatus, activo) FROM stdin;
1	1		venezuela		1	t
\.


--
-- Data for Name: productos; Type: TABLE DATA; Schema: maestros; Owner: geekhack
--

COPY maestros.productos (id, nombre, activo) FROM stdin;
1	cuenta	t
2	tarjeta de credito	t
3	cryptomoneda	t
4	credito	t
\.


--
-- Data for Name: status; Type: TABLE DATA; Schema: maestros; Owner: postgres
--

COPY maestros.status (_id, nombre) FROM stdin;
2	inactivo
1	activo
\.


--
-- Data for Name: configuracion; Type: TABLE DATA; Schema: seguridad; Owner: postgres
--

COPY seguridad.configuracion (_id, nombre, nombre_corto, rif, telefono, telefono_movil, email, direccion, logo) FROM stdin;
\.


--
-- Data for Name: log; Type: TABLE DATA; Schema: seguridad; Owner: geekhack
--

COPY seguridad.log (id, codigo, referencia, fecha_creacion, operacion, tabla, query) FROM stdin;
\.


--
-- Data for Name: perfil; Type: TABLE DATA; Schema: seguridad; Owner: postgres
--

COPY seguridad.perfil (_id, idrol, idmodulo, idfuncion) FROM stdin;
1	1	1	1
\.


--
-- Data for Name: redes; Type: TABLE DATA; Schema: seguridad; Owner: postgres
--

COPY seguridad.redes (_id, facebook, linkedin, idusuario) FROM stdin;
1	11111		2
\.


--
-- Data for Name: roles; Type: TABLE DATA; Schema: seguridad; Owner: postgres
--

COPY seguridad.roles (_id, nombre, idstatu) FROM stdin;
1	administrador	1
\.


--
-- Data for Name: usuarios; Type: TABLE DATA; Schema: seguridad; Owner: postgres
--

COPY seguridad.usuarios (id, codigo, referencia, nombre, apellido, estatus, activo, passwd, email, telefono, ciudad, pais, zona_postal, fecha_creacion, empresa) FROM stdin;
4	01010	pb	patricia	bermudez	1	t	5aa1c2f33f106c1966af371fc7a31d69	pb@geekhack.net.ve		1	1	1221	2019-04-25 11:10:02.016263-04	4
3	COD-123	jesus	jorge	niño	1	t	110d46fcd978c24f306cd7fa23464d73	jn@geekhack.net.ve	Jorge	5	5	\N	2019-04-09 14:02:16.530542-04	3
7	cb	cb	Carlos	Becerra	1	t	10200959c014fb58ee6f93d21a863757	clb@wek.io	\N	134	1	\N	2019-04-25 12:09:21.843945-04	7
9	testi	testi	testi	testi	1	t	6b67853e42898de8e7f7953331e938cc			1	1		2019-06-10 13:18:57.392569-04	9
5	3232	bb	geekHACK	CA	1	t	bc6ebbbd740bbed398fb88d64824554d	bb@geekhack.net.ve		1	1	11	2019-04-25 11:10:35.182584-04	5
6	am	am	Agnostica	AM	1	t	bcbdd9611d9287e0a1b5c256905bb8f0	am@wek.io	\N	134	1	\N	2019-04-25 12:08:23.26733-04	6
1	admin	admin	Admin	\N	\N	t	21232f297a57a5a743894a0e4a801fc3	ji@geekhack.net.ve	\N	\N	\N	\N	2019-03-23 10:45:47.805014-04	1
10	gm	gm	gemima	morena	1	t	e4171a749858480e63c4099e5d1ee24e	gm@wek.io		1	1	111	2019-09-13 15:21:52.981021-04	10
8	354235	jorge	jorge	nino	1	t	202cb962ac59075b964b07152d234b70	jn@geekhack.net.ve		1	1		2019-04-26 15:32:41.250398-04	8
11	\N	ADMIN	\N	\N	\N	f	73acd9a5972130b75066c82595a1fae3	ADMIN@ONLYONE.CON	\N	\N	\N	\N	2019-10-01 10:42:05.652459-04	11
12	\N	ADMIN	\N	\N	\N	t	73acd9a5972130b75066c82595a1fae3	ADMIN@ONLYONE.CON	\N	\N	\N	\N	2019-10-01 10:43:05.181868-04	12
\.


--
-- Name: bancos_id_seq; Type: SEQUENCE SET; Schema: bancos; Owner: geekhack
--

SELECT pg_catalog.setval('bancos.bancos_id_seq', 11, true);


--
-- Name: categorias_id_seq; Type: SEQUENCE SET; Schema: bancos; Owner: geekhack
--

SELECT pg_catalog.setval('bancos.categorias_id_seq', 29, true);


--
-- Name: cuentas_id_seq; Type: SEQUENCE SET; Schema: bancos; Owner: geekhack
--

SELECT pg_catalog.setval('bancos.cuentas_id_seq', 342, true);


--
-- Name: movimientos_id_seq; Type: SEQUENCE SET; Schema: bancos; Owner: geekhack
--

SELECT pg_catalog.setval('bancos.movimientos_id_seq', 84957, true);


--
-- Name: tipos_id_seq; Type: SEQUENCE SET; Schema: bancos; Owner: geekhack
--

SELECT pg_catalog.setval('bancos.tipos_id_seq', 1, false);


--
-- Name: titulares_id_seq; Type: SEQUENCE SET; Schema: bancos; Owner: geekhack
--

SELECT pg_catalog.setval('bancos.titulares_id_seq', 1, false);


--
-- Name: titulares_tipo_seq; Type: SEQUENCE SET; Schema: bancos; Owner: geekhack
--

SELECT pg_catalog.setval('bancos.titulares_tipo_seq', 1, false);


--
-- Name: conciliacion_reportePago_id_reporte_seq; Type: SEQUENCE SET; Schema: conciliacion; Owner: geekhack
--

SELECT pg_catalog.setval('conciliacion."conciliacion_reportePago_id_reporte_seq"', 1, false);


--
-- Name: conciliacion_reportePago_id_seq; Type: SEQUENCE SET; Schema: conciliacion; Owner: geekhack
--

SELECT pg_catalog.setval('conciliacion."conciliacion_reportePago_id_seq"', 205, true);


--
-- Name: conciliacion_reporte_total_nc_seq; Type: SEQUENCE SET; Schema: conciliacion; Owner: geekhack
--

SELECT pg_catalog.setval('conciliacion.conciliacion_reporte_total_nc_seq', 1, false);


--
-- Name: conciliacion_reportepago_id_pago_seq; Type: SEQUENCE SET; Schema: conciliacion; Owner: geekhack
--

SELECT pg_catalog.setval('conciliacion.conciliacion_reportepago_id_pago_seq', 1, false);


--
-- Name: reporte_conciliacion_id_seq; Type: SEQUENCE SET; Schema: conciliacion; Owner: geekhack
--

SELECT pg_catalog.setval('conciliacion.reporte_conciliacion_id_seq', 50, true);


--
-- Name: ciudades_id_seq; Type: SEQUENCE SET; Schema: maestros; Owner: geekhack
--

SELECT pg_catalog.setval('maestros.ciudades_id_seq', 498, true);


--
-- Name: divisas_id_seq; Type: SEQUENCE SET; Schema: maestros; Owner: geekhack
--

SELECT pg_catalog.setval('maestros.divisas_id_seq', 5, true);


--
-- Name: estados_id_seq; Type: SEQUENCE SET; Schema: maestros; Owner: geekhack
--

SELECT pg_catalog.setval('maestros.estados_id_seq', 25, true);


--
-- Name: funciones_id_seq; Type: SEQUENCE SET; Schema: maestros; Owner: postgres
--

SELECT pg_catalog.setval('maestros.funciones_id_seq', 9, true);


--
-- Name: identificar_banco_id_seq; Type: SEQUENCE SET; Schema: maestros; Owner: geekhack
--

SELECT pg_catalog.setval('maestros.identificar_banco_id_seq', 6, true);


--
-- Name: modulos_id_seq; Type: SEQUENCE SET; Schema: maestros; Owner: postgres
--

SELECT pg_catalog.setval('maestros.modulos_id_seq', 6, true);


--
-- Name: productos_id_seq; Type: SEQUENCE SET; Schema: maestros; Owner: geekhack
--

SELECT pg_catalog.setval('maestros.productos_id_seq', 4, true);


--
-- Name: status_id_seq; Type: SEQUENCE SET; Schema: maestros; Owner: postgres
--

SELECT pg_catalog.setval('maestros.status_id_seq', 2, true);


--
-- Name: configuracion__id_seq; Type: SEQUENCE SET; Schema: seguridad; Owner: postgres
--

SELECT pg_catalog.setval('seguridad.configuracion__id_seq', 1, false);


--
-- Name: log_id_seq; Type: SEQUENCE SET; Schema: seguridad; Owner: geekhack
--

SELECT pg_catalog.setval('seguridad.log_id_seq', 1, false);


--
-- Name: perfil_id_seq; Type: SEQUENCE SET; Schema: seguridad; Owner: postgres
--

SELECT pg_catalog.setval('seguridad.perfil_id_seq', 1, true);


--
-- Name: redes__id_seq; Type: SEQUENCE SET; Schema: seguridad; Owner: postgres
--

SELECT pg_catalog.setval('seguridad.redes__id_seq', 1, true);


--
-- Name: roles__id_seq; Type: SEQUENCE SET; Schema: seguridad; Owner: postgres
--

SELECT pg_catalog.setval('seguridad.roles__id_seq', 1, true);


--
-- Name: usuarios_id_seq; Type: SEQUENCE SET; Schema: seguridad; Owner: postgres
--

SELECT pg_catalog.setval('seguridad.usuarios_id_seq', 12, true);


--
-- Name: bancos bancos_pkey; Type: CONSTRAINT; Schema: bancos; Owner: geekhack
--

ALTER TABLE ONLY bancos.bancos
    ADD CONSTRAINT bancos_pkey PRIMARY KEY (id);


--
-- Name: bancos bancos_rif_key; Type: CONSTRAINT; Schema: bancos; Owner: geekhack
--

ALTER TABLE ONLY bancos.bancos
    ADD CONSTRAINT bancos_rif_key UNIQUE (rif);


--
-- Name: categorias categorias_codigo_key; Type: CONSTRAINT; Schema: bancos; Owner: geekhack
--

ALTER TABLE ONLY bancos.categorias
    ADD CONSTRAINT categorias_codigo_key UNIQUE (codigo);


--
-- Name: categorias categorias_pkey; Type: CONSTRAINT; Schema: bancos; Owner: geekhack
--

ALTER TABLE ONLY bancos.categorias
    ADD CONSTRAINT categorias_pkey PRIMARY KEY (id);


--
-- Name: categorias categorias_referencia_key; Type: CONSTRAINT; Schema: bancos; Owner: geekhack
--

ALTER TABLE ONLY bancos.categorias
    ADD CONSTRAINT categorias_referencia_key UNIQUE (referencia);


--
-- Name: cuentas cuentas_pkey; Type: CONSTRAINT; Schema: bancos; Owner: geekhack
--

ALTER TABLE ONLY bancos.cuentas
    ADD CONSTRAINT cuentas_pkey PRIMARY KEY (id);


--
-- Name: movimientos movimientos_pkey; Type: CONSTRAINT; Schema: bancos; Owner: geekhack
--

ALTER TABLE ONLY bancos.movimientos
    ADD CONSTRAINT movimientos_pkey PRIMARY KEY (id);


--
-- Name: movimientos movimientos_referencia_fecha_monto_cuenta_usuario_key; Type: CONSTRAINT; Schema: bancos; Owner: geekhack
--

ALTER TABLE ONLY bancos.movimientos
    ADD CONSTRAINT movimientos_referencia_fecha_monto_cuenta_usuario_key UNIQUE (referencia, fecha, monto, cuenta, usuario);


--
-- Name: subcategorias subcategorias_codigo_key; Type: CONSTRAINT; Schema: bancos; Owner: geekhack
--

ALTER TABLE ONLY bancos.subcategorias
    ADD CONSTRAINT subcategorias_codigo_key UNIQUE (codigo);


--
-- Name: subcategorias subcategorias_pkey; Type: CONSTRAINT; Schema: bancos; Owner: geekhack
--

ALTER TABLE ONLY bancos.subcategorias
    ADD CONSTRAINT subcategorias_pkey PRIMARY KEY (id);


--
-- Name: subcategorias subcategorias_referencia_key; Type: CONSTRAINT; Schema: bancos; Owner: geekhack
--

ALTER TABLE ONLY bancos.subcategorias
    ADD CONSTRAINT subcategorias_referencia_key UNIQUE (referencia);


--
-- Name: tipos tipos_codigo_key; Type: CONSTRAINT; Schema: bancos; Owner: geekhack
--

ALTER TABLE ONLY bancos.tipos
    ADD CONSTRAINT tipos_codigo_key UNIQUE (codigo);


--
-- Name: tipos tipos_pkey; Type: CONSTRAINT; Schema: bancos; Owner: geekhack
--

ALTER TABLE ONLY bancos.tipos
    ADD CONSTRAINT tipos_pkey PRIMARY KEY (id);


--
-- Name: tipos tipos_referencia_key; Type: CONSTRAINT; Schema: bancos; Owner: geekhack
--

ALTER TABLE ONLY bancos.tipos
    ADD CONSTRAINT tipos_referencia_key UNIQUE (referencia);


--
-- Name: titulares titulares_pkey; Type: CONSTRAINT; Schema: bancos; Owner: geekhack
--

ALTER TABLE ONLY bancos.titulares
    ADD CONSTRAINT titulares_pkey PRIMARY KEY (id);


--
-- Name: conciliacion_reportepago conciliacion_reportePago_pkey; Type: CONSTRAINT; Schema: conciliacion; Owner: geekhack
--

ALTER TABLE ONLY conciliacion.conciliacion_reportepago
    ADD CONSTRAINT "conciliacion_reportePago_pkey" PRIMARY KEY (id);


--
-- Name: conciliacion_reporte reporte_conciliacion_pkey; Type: CONSTRAINT; Schema: conciliacion; Owner: geekhack
--

ALTER TABLE ONLY conciliacion.conciliacion_reporte
    ADD CONSTRAINT reporte_conciliacion_pkey PRIMARY KEY (id);


--
-- Name: ciudades ciudades_pkey; Type: CONSTRAINT; Schema: maestros; Owner: geekhack
--

ALTER TABLE ONLY maestros.ciudades
    ADD CONSTRAINT ciudades_pkey PRIMARY KEY (id);


--
-- Name: divisas divisas_pkey; Type: CONSTRAINT; Schema: maestros; Owner: geekhack
--

ALTER TABLE ONLY maestros.divisas
    ADD CONSTRAINT divisas_pkey PRIMARY KEY (id);


--
-- Name: estados estados_id_key; Type: CONSTRAINT; Schema: maestros; Owner: geekhack
--

ALTER TABLE ONLY maestros.estados
    ADD CONSTRAINT estados_id_key UNIQUE (id);


--
-- Name: estados estados_pkey; Type: CONSTRAINT; Schema: maestros; Owner: geekhack
--

ALTER TABLE ONLY maestros.estados
    ADD CONSTRAINT estados_pkey PRIMARY KEY (id);


--
-- Name: funciones funciones_pkey; Type: CONSTRAINT; Schema: maestros; Owner: postgres
--

ALTER TABLE ONLY maestros.funciones
    ADD CONSTRAINT funciones_pkey PRIMARY KEY (_id);


--
-- Name: identificar_banco identificar_banco_pkey; Type: CONSTRAINT; Schema: maestros; Owner: geekhack
--

ALTER TABLE ONLY maestros.identificar_banco
    ADD CONSTRAINT identificar_banco_pkey PRIMARY KEY (id);


--
-- Name: modulos modulos_pkey; Type: CONSTRAINT; Schema: maestros; Owner: postgres
--

ALTER TABLE ONLY maestros.modulos
    ADD CONSTRAINT modulos_pkey PRIMARY KEY (_id);


--
-- Name: paises paises_id_key; Type: CONSTRAINT; Schema: maestros; Owner: geekhack
--

ALTER TABLE ONLY maestros.paises
    ADD CONSTRAINT paises_id_key UNIQUE (id);


--
-- Name: productos productos_pkey; Type: CONSTRAINT; Schema: maestros; Owner: geekhack
--

ALTER TABLE ONLY maestros.productos
    ADD CONSTRAINT productos_pkey PRIMARY KEY (id);


--
-- Name: status status_pkey; Type: CONSTRAINT; Schema: maestros; Owner: postgres
--

ALTER TABLE ONLY maestros.status
    ADD CONSTRAINT status_pkey PRIMARY KEY (_id);


--
-- Name: configuracion configuracion_pkey; Type: CONSTRAINT; Schema: seguridad; Owner: postgres
--

ALTER TABLE ONLY seguridad.configuracion
    ADD CONSTRAINT configuracion_pkey PRIMARY KEY (_id);


--
-- Name: perfil perfil_pkey; Type: CONSTRAINT; Schema: seguridad; Owner: postgres
--

ALTER TABLE ONLY seguridad.perfil
    ADD CONSTRAINT perfil_pkey PRIMARY KEY (_id);


--
-- Name: redes redes_pkey; Type: CONSTRAINT; Schema: seguridad; Owner: postgres
--

ALTER TABLE ONLY seguridad.redes
    ADD CONSTRAINT redes_pkey PRIMARY KEY (_id);


--
-- Name: roles roles_pkey; Type: CONSTRAINT; Schema: seguridad; Owner: postgres
--

ALTER TABLE ONLY seguridad.roles
    ADD CONSTRAINT roles_pkey PRIMARY KEY (_id);


--
-- Name: usuarios usuarios_id_key; Type: CONSTRAINT; Schema: seguridad; Owner: postgres
--

ALTER TABLE ONLY seguridad.usuarios
    ADD CONSTRAINT usuarios_id_key UNIQUE (id);


--
-- Name: bancos bancos_idPais_fkey; Type: FK CONSTRAINT; Schema: bancos; Owner: geekhack
--

ALTER TABLE ONLY bancos.bancos
    ADD CONSTRAINT "bancos_idPais_fkey" FOREIGN KEY ("idPais") REFERENCES maestros.paises(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: cuentas cuentas_divisa_fkey; Type: FK CONSTRAINT; Schema: bancos; Owner: geekhack
--

ALTER TABLE ONLY bancos.cuentas
    ADD CONSTRAINT cuentas_divisa_fkey FOREIGN KEY (divisa) REFERENCES maestros.divisas(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: cuentas cuentas_usuario_fkey; Type: FK CONSTRAINT; Schema: bancos; Owner: geekhack
--

ALTER TABLE ONLY bancos.cuentas
    ADD CONSTRAINT cuentas_usuario_fkey FOREIGN KEY (usuario) REFERENCES seguridad.usuarios(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: cuentas fk_cuenta_banco; Type: FK CONSTRAINT; Schema: bancos; Owner: geekhack
--

ALTER TABLE ONLY bancos.cuentas
    ADD CONSTRAINT fk_cuenta_banco FOREIGN KEY (banco) REFERENCES bancos.bancos(id);


--
-- Name: movimientos_info fk_movimientos_info_categoria; Type: FK CONSTRAINT; Schema: bancos; Owner: geekhack
--

ALTER TABLE ONLY bancos.movimientos_info
    ADD CONSTRAINT fk_movimientos_info_categoria FOREIGN KEY (categoria) REFERENCES bancos.categorias(id);


--
-- Name: movimientos_info fk_movimientos_info_subcategoria; Type: FK CONSTRAINT; Schema: bancos; Owner: geekhack
--

ALTER TABLE ONLY bancos.movimientos_info
    ADD CONSTRAINT fk_movimientos_info_subcategoria FOREIGN KEY (subcategoria) REFERENCES bancos.subcategorias(id);


--
-- Name: subcategorias fk_subcategoria_categoria; Type: FK CONSTRAINT; Schema: bancos; Owner: geekhack
--

ALTER TABLE ONLY bancos.subcategorias
    ADD CONSTRAINT fk_subcategoria_categoria FOREIGN KEY (categoria) REFERENCES bancos.categorias(id);


--
-- Name: ciudades ciudades_estado_fkey; Type: FK CONSTRAINT; Schema: maestros; Owner: geekhack
--

ALTER TABLE ONLY maestros.ciudades
    ADD CONSTRAINT ciudades_estado_fkey FOREIGN KEY (estado) REFERENCES maestros.estados(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: estados estados_idpais_fkey; Type: FK CONSTRAINT; Schema: maestros; Owner: geekhack
--

ALTER TABLE ONLY maestros.estados
    ADD CONSTRAINT estados_idpais_fkey FOREIGN KEY (idpais) REFERENCES maestros.paises(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- PostgreSQL database dump complete
--

