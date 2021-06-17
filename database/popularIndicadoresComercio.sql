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