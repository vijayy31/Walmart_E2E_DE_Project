{{
  config(
        unique_key = 'order_item_id'
    )
}}

with bronze_order_items as (
    SELECT

        CAST(order_item_id AS BIGINT) AS order_item_id,
        CAST(order_id AS BIGINT) AS order_id,
        CAST(product_id AS BIGINT) AS product_id,
        CAST(quantity AS INT) AS quantity,
        CAST(unit_price AS DECIMAL(10,2)) AS unit_price,
        CAST(line_amount AS DECIMAL(10,2)) AS line_amount,
        TO_TIMESTAMP(created_timestamp, 'M/d/yyyy H:mm') AS created_timestamp,
        TO_TIMESTAMP(updated_timestamp, 'M/d/yyyy H:mm') AS updated_timestamp,
        CAST(is_active AS STRING) AS is_active,
        CAST(_ingestion_timestamp AS TIMESTAMP) AS _ingestion_timestamp,
        CAST(source_file_name AS STRING) AS source_file_name

        FROM {{ source('bronze', 'bronze_order_items') }}
)

{# --------------------------------------------------- #}


SELECT 
    *,
    CURRENT_TIMESTAMP() AS silver_loaded_at

FROM

    bronze_order_items

WHERE order_item_id IS NOT NULL

{% if is_incremental() %}
    AND _ingestion_timestamp > ( SELECT COALESCE( MAX(_ingestion_timestamp), CAST('1900-01-01' AS TIMESTAMP) ) FROM {{ this }} )
{% endif %}