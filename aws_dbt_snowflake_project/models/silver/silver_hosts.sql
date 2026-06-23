{{ config(materialized="incremental", unique_key="host_id") }}

select
    host_id,
    {{ trimmer("host_name") }} as host_name,
    host_since,
    is_superhost,
    response_rate,
    created_at,
    {{ tag("response_rate", 50, 80) }} as response_tag
from {{ ref("bronze_hosts") }}
