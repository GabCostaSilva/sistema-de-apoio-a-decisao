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
	volumeVendas REAL NOT NULL,
	PRIMARY KEY(codData, codEstado)
);

CREATE TABLE pagamentosAuxilioEmergencial (
	codData INTEGER REFERENCES data,
	codMunicipio INTEGER REFERENCES municipio,
	quantBeneficiarios INTEGER NOT NULL,
	valorTotal REAL NOT NULL,
	PRIMARY KEY(codData, codMunicipio)
);