{{
  config(
        unique_key = 'store_id'
    )
}}

with bronze_stores as (
    SELECT

        CAST(store_id AS BIGINT) AS store_id,
        CAST(store_name AS STRING) AS store_name,
        CAST(city AS STRING) AS city,
        CAST(province AS STRING) AS province,
        CAST(country AS STRING) AS country,
        TO_TIMESTAMP(created_timestamp, 'M/d/yyyy H:mm') AS created_timestamp,
        TO_TIMESTAMP(updated_timestamp, 'M/d/yyyy H:mm') AS updated_timestamp,
        CAST(is_active AS STRING) AS is_active,
        CAST(_ingestion_timestamp AS TIMESTAMP) AS _ingestion_timestamp,
        CAST(source_file_name AS STRING) AS source_file_name

        FROM {{ source('bronze', 'bronze_stores') }}
)


{# --------------------------------------------------- #}


SELECT 
    *,
    CURRENT_TIMESTAMP() AS silver_loaded_at

FROM

    bronze_stores

WHERE store_id IS NOT NULL

{% if is_incremental() %}
    AND _ingestion_timestamp > ( SELECT COALESCE( MAX(_ingestion_timestamp), CAST('1900-01-01' AS TIMESTAMP) ) FROM {{ this }} )
{% endif %}