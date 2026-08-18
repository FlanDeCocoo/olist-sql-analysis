-- ================================================
-- ANÁLISIS EXPLORATORIO DE DATOS - OLIST E-COMMERCE
-- Dataset: Brazilian E-Commerce Public Dataset by Olist
-- Fuente: Kaggle (https://www.kaggle.com/olistbr)
-- Herramienta: MySQL 8.0
-- Autor: [Tu nombre]
-- ================================================

USE olist;

-- ================================================
-- EXPLORACIÓN INICIAL
-- ¿Con cuántos datos estamos trabajando?
-- ================================================

SELECT COUNT(*) AS total_clientes     FROM olist_customers_dataset;
SELECT COUNT(*) AS total_vendedores   FROM olist_sellers_dataset;
SELECT COUNT(*) AS total_productos    FROM olist_products_dataset;
SELECT COUNT(*) AS total_pedidos      FROM olist_orders_dataset;
SELECT COUNT(*) AS total_items        FROM olist_order_items_dataset;
SELECT COUNT(*) AS total_pagos        FROM olist_order_payments_dataset;
SELECT COUNT(*) AS total_categorias   FROM product_category_name_translation;

-- Resultado:
-- 99.441 clientes | 3.095 vendedores | 32.340 productos
-- 99.441 pedidos  | 112.650 items    | 103.886 pagos
-- Nota: cada cliente realizó exactamente 1 pedido en el período analizado,
-- lo que sugiere una baja tasa de retención de clientes.

-- ================================================
-- PREGUNTA 1
-- ¿Cuáles son los posibles estados de un pedido
-- y cuántos pedidos hay en cada estado?
-- ================================================

SELECT * FROM (
    SELECT 
        order_status AS Estado, 
        COUNT(order_status) AS Pedidos
    FROM olist_orders_dataset
    GROUP BY order_status
) AS resultado
ORDER BY Pedidos DESC;

-- Resultado:
-- delivered    96.478 → 97% de los pedidos entregados exitosamente
-- shipped       1.107 → en camino al cliente
-- canceled        625 → cancelados (solo 0.6% del total)
-- unavailable     609 → producto no disponible
-- invoiced        314 → facturado pero no enviado
-- processing      301 → en proceso
-- created           5 → recién creados
-- approved          2 → aprobados sin procesar
--
-- Insight: la tasa de entrega exitosa del 97% indica
-- una operación logística muy eficiente.

-- ================================================
-- PREGUNTA 2
-- ¿Cuántos pedidos se realizaron por mes y año?
-- ================================================

SELECT * FROM (
    SELECT 
        YEAR(order_purchase_timestamp)  AS Año,
        MONTH(order_purchase_timestamp) AS Mes,
        COUNT(order_purchase_timestamp) AS 'Cantidad de Pedidos'
    FROM olist_orders_dataset
    GROUP BY 
        YEAR(order_purchase_timestamp),
        MONTH(order_purchase_timestamp)
) AS resultado
ORDER BY Año, Mes;

-- Resultado:
-- 2016: apenas 329 pedidos (dataset comienza en octubre 2016)
-- 2017: crecimiento gradual, pico en noviembre con 7.544 pedidos
--       (probablemente por Black Friday)
-- 2018: todos los meses superan 6.000 pedidos
--
-- Insight: el negocio creció aproximadamente 9 veces
-- entre enero 2017 (800 pedidos) y enero 2018 (7.269 pedidos).

-- ================================================
-- PREGUNTA 3
-- ¿Cuáles son las 10 categorías de productos más vendidas?
-- ================================================

SELECT * FROM (
    SELECT 
        product_category_name_english AS Categoria, 
        COUNT(product_category_name_english) AS Cantidad
    FROM product_category_name_translation 
    JOIN olist_products_dataset
        ON product_category_name_translation.product_category_name = olist_products_dataset.product_category_name
    JOIN olist_order_items_dataset
        ON olist_products_dataset.product_id = olist_order_items_dataset.product_id
    GROUP BY product_category_name_english
) AS resultado
ORDER BY Cantidad DESC 
LIMIT 10;

-- Resultado:
-- 1. bed_bath_table       11.115
-- 2. health_beauty         9.670
-- 3. sports_leisure        8.641
-- 4. furniture_decor       8.334
-- 5. computers_accessories 7.827
-- 6. housewares            6.964
-- 7. watches_gifts         5.991
-- 8. telephony             4.545
-- 9. garden_tools          4.347
-- 10. auto                 4.235
--
-- Insight: las categorías de hogar (bed_bath_table, furniture_decor,
-- housewares) representan aproximadamente el 30% del total de
-- items vendidos, seguidas por salud y belleza.

-- ================================================
-- PREGUNTA 4
-- ¿Cuál es el ingreso total y el ticket promedio
-- por tipo de pago?
-- ================================================

SELECT * FROM (
    SELECT 
        payment_type AS 'Tipo De Pago', 
        ROUND(SUM(payment_value), 2)  AS 'Ingreso Total', 
        ROUND(AVG(payment_value), 2)  AS 'Ticket Promedio'
    FROM olist_order_payments_dataset
    GROUP BY payment_type
) AS resultado
ORDER BY 'Ingreso Total' DESC;

-- Resultado:
-- credit_card  $12.542.084  ticket promedio $163
-- boleto        $2.869.361  ticket promedio $145
-- voucher         $379.436  ticket promedio  $65
-- debit_card      $217.989  ticket promedio $142
-- not_defined           $0  ticket promedio   $0
--
-- Insight: la tarjeta de crédito genera el 78% de los ingresos totales.
-- El boleto bancário (método de pago brasileño) es el segundo más usado.
-- Los vouchers tienen el ticket más bajo ($65) ya que se usan
-- principalmente como descuento complementario.

-- ================================================
-- PREGUNTA 5
-- ¿Cuáles son los 10 vendedores que más ingresos generaron?
-- ================================================

SELECT * FROM (
    SELECT 
        olist_order_items_dataset.seller_id AS 'Top 10 Vendedores', 
        ROUND(SUM(price), 2) AS Ingresos_Totales
    FROM olist_order_items_dataset 
    JOIN olist_sellers_dataset
        ON olist_order_items_dataset.seller_id = olist_sellers_dataset.seller_id
    GROUP BY olist_order_items_dataset.seller_id
) AS resultado
ORDER BY Ingresos_Totales DESC 
LIMIT 10;

-- Resultado:
-- 1°  4869f7a5...  $229.472
-- 2°  53243585...  $222.776
-- 3°  4a3ca931...  $200.472
-- 4°  fa1c13f2...  $194.042
-- 5°  7c67e144...  $187.923
-- 6°  7e93a43e...  $176.431
-- 7°  da8622b1...  $160.236
-- 8°  7a67c85e...  $141.745
-- 9°  1025f0e2...  $138.968
-- 10° 955fee92...  $135.171
--
-- Insight: el vendedor top generó $229.472 reales en ventas,
-- casi el doble que el décimo lugar con $135.171,
-- lo que indica una concentración significativa de ingresos
-- en los vendedores principales.
