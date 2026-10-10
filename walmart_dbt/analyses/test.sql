SELECT * EXCEPT(_ingestion_timestamp, source_file_name, _silver_loaded_at)

FROM {{ ref('stg_orders') }}