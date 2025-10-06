--Query 1
SELECT column_name, data_type 
FROM information_schema.columns 
WHERE table_name = 'vendas' 
AND table_schema = 'public'
ORDER BY ordinal_position;

SELECT * FROM vendas LIMIT 5;

SELECT table_name 
FROM information_schema.tables 
WHERE table_schema = 'public' 
AND table_name LIKE '%produto%';

SELECT column_name, data_type 
FROM information_schema.columns 
WHERE table_name = 'produtos'  
AND table_schema = 'public';

SELECT DISTINCT cod_produto, COUNT(*) as total
FROM vendas 
GROUP BY cod_produto 
ORDER BY total DESC 
LIMIT 20;


SELECT DISTINCT u.cod_usuario, u.estado as nome, u.cidade as estado
FROM usuarios u
WHERE u.cod_usuario IN (
    SELECT v.cod_usuario
    FROM vendas v
    WHERE v.valor_compra > 2000  
);


--Query 2
WITH media_compras_usuario AS (
    SELECT 
        v.cod_usuario,
        AVG(v.valor_compra) AS media_valor_compra
    FROM vendas v
    GROUP BY v.cod_usuario
    HAVING AVG(v.valor_compra) > 500
)
SELECT 
    m.cod_usuario,
    u.estado as nome_usuario,
    u.cidade as estado,
    m.media_valor_compra
FROM media_compras_usuario m
INNER JOIN usuarios u ON m.cod_usuario = u.cod_usuario
ORDER BY m.media_valor_compra DESC;

--Query 3
SELECT 
    p.cod_produto,
    p.total_vendas
FROM (
    SELECT 
        cod_produto,
        COUNT(*) as total_vendas
    FROM vendas
    GROUP BY cod_produto
) p
WHERE p.total_vendas > 50
ORDER BY p.total_vendas DESC;

--Query 4
WITH vendas_por_estado AS (
    SELECT 
        u.cidade as estado,  -- Coluna CIDADE = Estados
        COUNT(*) as total_vendas,
        SUM(v.valor_compra) as valor_total_vendas
    FROM vendas v
    INNER JOIN usuarios u ON v.cod_usuario = u.cod_usuario
    GROUP BY u.cidade
)
SELECT 
    estado,
    total_vendas,
    valor_total_vendas
FROM vendas_por_estado
ORDER BY total_vendas DESC, valor_total_vendas DESC;
