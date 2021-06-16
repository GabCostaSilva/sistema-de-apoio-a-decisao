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