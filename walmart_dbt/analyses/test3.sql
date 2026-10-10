{% set configs = [
     
     {
        "table_name":"walmart_data.silver.stg_orders",
        "alias": "O",
        "column_name": ['* EXCEPT(_ingestion_timestamp, source_file_name, _silver_loaded_at)']
     },
     {
        "table_name": "walmart_data.silver.stg_stores",
        "alias": "S",
        "column_name": ["STORE_NAME"],
        "join_condition": "O.STORE_ID = S.STORE_ID"
     },
     {
        "table_name": "walmart_data.silver.stg_customers",
        "alias": "C",
        "column_name": ["EMAIL"],
        "join_condition": "O.CUSTOMER_ID = C.CUSTOMER_ID"
     }

]-%}

SELECT
    {% for config in configs %}

        {{config.alias~'.'~ (config.column_name | join(', '~config.alias~'.')) }}
        {% if not loop.last -%},{% endif -%}

    {% endfor -%}

FROM 

{% for config in configs -%}

    {% if loop.first -%}
        {{config.table_name}} AS {{config.alias}}
    
    {% else %}
        LEFT JOIN {{config.table_name}} AS {{config.alias}}
        ON {{config.join_condition}}

    {% endif -%}
{% endfor -%}