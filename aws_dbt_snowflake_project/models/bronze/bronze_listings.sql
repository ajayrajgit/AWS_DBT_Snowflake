{# {% set incremental_flag = 1 %}
{% set incremental_col = 'CREATED_AT' %} #}


{{
  config(
    materialized = 'incremental',
    )
}}

SELECT * FROM {{ source('staging', 'listings') }}

{% if is_incremental() %}
    WHERE created_at > (SELECT COALESCE(MAX(created_at), '1999-01-01') FROM {{ this }})
{% endif %}