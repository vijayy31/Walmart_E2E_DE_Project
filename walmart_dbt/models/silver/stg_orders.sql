{{
  config(
        unique_key = 'order_id'
    )
}}

with bronze_orders as (
    SELECT 
        CAST(order_id AS BIGINT) AS order_id,
        CAST(customer_id AS BIGINT) AS customer_id,
        CAST(store_id AS BIGINT) AS store_id,
        TO_TIMESTAMP(order_timestamp, 'M/d/yyyy H:mm') AS order_timestamp,
        CAST(order_status AS STRING) AS order_status,
        CAST(total_amount AS DECIMAL(10,2)) AS total_amount,
        CAST(payment_method AS STRING) AS payment_method,
        TO_TIMESTAMP(created_timestamp, 'M/d/yyyy H:mm') AS created_timestamp,
        TO_TIMESTAMP(updated_timestamp, 'M/d/yyyy H:mm') AS updated_timestamp,
        CAST(is_active AS STRING) AS is_active,
        CAST(_ingestion_timestamp AS TIMESTAMP) AS _ingestion_timestamp,
        CAST(source_file_name AS STRING) AS source_file_name
    
    FROM {{ source('bronze', 'bronze_orders') }}
)

{# ------------------------------------------------------------------------------ #}

SELECT 
    *, 
    current_timestamp() AS _silver_loaded_at 

FROM

    bronze_orders

WHERE ORDER_ID IS NOT NULL

{% if is_incremental() %}
    AND _ingestion_timestamp > ( SELECT COALESCE( MAX(_ingestion_timestamp), CAST('1900-01-01' AS TIMESTAMP) ) FROM {{ this }} )
{% endif %}