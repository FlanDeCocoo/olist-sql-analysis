# 🛒 Análisis Exploratorio de E-Commerce — Olist Brasil

## 📋 Descripción del proyecto
Análisis exploratorio de datos sobre 100.000 pedidos reales de Olist,
el marketplace de e-commerce más grande de Brasil. El objetivo es
responder preguntas de negocio clave usando SQL y MySQL.

## 🗄️ Dataset
- **Fuente:** [Kaggle — Brazilian E-Commerce Public Dataset by Olist](https://www.kaggle.com/olistbr/brazilian-ecommerce)
- **Período:** Octubre 2016 — Octubre 2018
- **Tablas analizadas:** 7
- **Total de registros:** ~500.000 filas

## 🛠️ Herramientas
- MySQL 8.0
- MySQL Workbench

## ❓ Preguntas de negocio respondidas

| # | Pregunta | Técnicas SQL utilizadas |
|---|---|---|
| 1 | ¿Cuál es la distribución de estados de pedidos? | SELECT, GROUP BY, ORDER BY |
| 2 | ¿Cuántos pedidos se realizaron por mes y año? | YEAR(), MONTH(), GROUP BY |
| 3 | ¿Cuáles son las 10 categorías más vendidas? | JOIN múltiple, subconsulta, LIMIT |
| 4 | ¿Cuál es el ingreso total y ticket promedio por forma de pago? | SUM(), AVG(), ROUND(), subconsulta |
| 5 | ¿Cuáles son los 10 vendedores con más ingresos? | JOIN, SUM(), subconsulta, LIMIT |

## 💡 Principales insights

- El **97% de los pedidos fueron entregados exitosamente**,
  indicando una operación logística muy eficiente.
- El negocio creció **~9 veces entre enero 2017 y enero 2018**,
  con un pico en noviembre 2017 (Black Friday).
- Las categorías de **hogar y salud** representan el 30%
  del total de items vendidos.
- La **tarjeta de crédito genera el 78% de los ingresos totales**.
  El boleto bancário es el segundo método más usado en Brasil.
- El vendedor top generó **$229.472 reales**, casi el doble
  que el décimo lugar, indicando concentración de ingresos.
- Cada cliente realizó exactamente **1 pedido** en el período
  analizado, sugiriendo una baja tasa de retención.

## 📁 Estructura del repositorio

## 👤 Autor
Richard Schwratz — Ingeniero Civil Industrial  
www.linkedin.com/in/richard-schwartz-rsv10
