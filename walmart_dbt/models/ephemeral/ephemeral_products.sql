SELECT * EXCEPT(source_file_name, silver_loaded_at, _ingestion_timestamp)

FROM {{ ref('stg_products') }}