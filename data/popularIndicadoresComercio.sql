INSERT INTO indicadorescomercio
SELECT
    (SELECT coddata FROM data d WHERE ct.mes = d.mes and ct.ano = d.ano),
    codestado,
    volume_de_vendas
FROM comercio_temp ct;