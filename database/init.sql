CREATE TABLE data (
	codData SERIAL PRIMARY KEY,
	mes INTEGER NOT NULL,
	ano INTEGER NOT NULL
);

CREATE TABLE estado (
	codEstado INTEGER PRIMARY KEY,
	nomeEstado VARCHAR(255) NOT NULL,
	sigla VARCHAR(2) NOT NULL
);

CREATE TABLE municipio (
	codMunicipio INTEGER PRIMARY KEY,
	codEstado INTEGER REFERENCES estado,
	nomeMunicipio VARCHAR(255) NOT NULL
);

CREATE TABLE indicadoresComercio (
	codData INTEGER REFERENCES data,
	codEstado integer REFERENCES estado,
	volumeVendas VARCHAR(255) NOT NULL,
	PRIMARY KEY(codData, codEstado)
);

CREATE TABLE pagamentosAuxilioEmergencial (
	codData INTEGER REFERENCES data,
	codMunicipio INTEGER REFERENCES municipio,
	quantBeneficiarios INTEGER NOT NULL,
	valorTotal REAL NOT NULL,
	PRIMARY KEY(codData, codMunicipio)
);

COPY estado FROM '/data/estado.csv' WITH (FORMAT csv);
COPY data FROM '/data/data.csv' WITH (FORMAT csv);
COPY municipio FROM '/data/municipio.csv' WITH (FORMAT csv);

DROP TABLE IF EXISTS comercio_temp;

create table comercio_temp
(
    codestado        integer      not null,
    volume_de_vendas varchar(255) not null,
    ano              integer      not null,
    mes              integer      not null
);

COPY comercio_temp FROM '/data/comercio.csv' WITH (FORMAT CSV);

INSERT INTO indicadorescomercio
SELECT
    (SELECT coddata FROM data d WHERE ct.mes = d.mes and ct.ano = d.ano),
    codestado,
    volume_de_vendas
FROM comercio_temp ct;

DROP TABLE comercio_temp;

DROP TABLE IF EXISTS pagamento_por_municipio;

CREATE TABLE pagamento_por_municipio
(
    codmunicipio  INTEGER,
    valor         REAL,
    beneficiarios INTEGER,
    ano           INTEGER,
    mes           INTEGER
);

COPY pagamento_por_municipio FROM '/data/pagamento_por_municipio.csv' WITH (FORMAT csv);

INSERT INTO pagamentosauxilioemergencial
SELECT (SELECT coddata FROM data WHERE ano = p.ano AND mes = p.mes), codmunicipio, SUM(beneficiarios), SUM(valor)
FROM pagamento_por_municipio p
GROUP BY codmunicipio, (SELECT coddata FROM data WHERE ano = p.ano AND mes = p.mes);

DROP TABLE pagamento_por_municipio;