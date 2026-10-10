{{
  config(
        unique_key = 'product_id'
    )
}}


with bronze_products as (
    SELECT

        CAST(product_id AS BIGINT) AS product_id,
        CAST(product_name AS STRING) AS product_name,
        CAST(category AS STRING) AS category,
        CAST(brand AS STRING) AS brand,
        CAST(price AS DECIMAL(10,2)) AS price,
        TO_TIMESTAMP(created_timestamp, 'M/d/yyyy H:mm') AS created_timestamp,
        TO_TIMESTAMP(updated_timestamp, 'M/d/yyyy H:mm') AS updated_timestamp,
        CAST(is_active AS STRING) AS is_active,
        CAST(_ingestion_timestamp AS TIMESTAMP) AS _ingestion_timestamp,
        CAST(source_file_name AS STRING) AS source_file_name

        FROM {{ source('bronze', 'bronze_products') }}
)

{# --------------------------------------------------- #}


SELECT 
    *,
    CURRENT_TIMESTAMP() AS silver_loaded_at

FROM

    bronze_products

WHERE product_id IS NOT NULL

{% if is_incremental() %}
    AND _ingestion_timestamp > ( SELECT COALESCE( MAX(_ingestion_timestamp), CAST('1900-01-01' AS TIMESTAMP) ) FROM {{ this }} )
{% endif %}