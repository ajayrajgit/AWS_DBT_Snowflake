{{
    config(
        materialized="ephemeral",
    )
}}


select
    listing_ids, property_type, room_type, city, country, amount_tag, listing_created_at
from {{ ref("obt") }}
