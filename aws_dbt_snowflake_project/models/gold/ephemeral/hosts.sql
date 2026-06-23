{{
    config(
        materialized="ephemeral",
    )
}}

with
    hosts as (
        select
            host_id, host_name, host_since, is_superhost, response_tag, host_created_at
        from {{ ref("obt") }}
    )
select *
from hosts
