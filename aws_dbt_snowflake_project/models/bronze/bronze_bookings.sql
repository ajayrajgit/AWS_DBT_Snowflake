{# {% set incremental_flag = 1 %}
{% set incremental_col = 'CREATED_AT' %} #}
{{
    config(
        materialized="incremental",
    )
}}

select *
from {{ source("staging", "bookings") }}

{% if is_incremental() %}
    where created_at > (select coalesce(max(created_at), '1999-01-01') from {{ this }})
{% endif %}
