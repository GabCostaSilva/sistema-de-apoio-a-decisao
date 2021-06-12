-- COPY estado FROM '/data/estado.csv' WITH (FORMAT csv);
-- COPY data FROM '/data/data.csv' WITH (FORMAT csv);
-- COPY municipio FROM '/data/municipio.csv' WITH (FORMAT csv);

INSERT INTO indicadorescomercio
SELECT
    (SELECT coddata FROM data d WHERE ct.mes = d.mes and ct.ano = d.ano),
    codestado,
    volume_de_vendas
FROM comercio_temp ct;