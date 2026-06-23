{{ config(materialized="incremental", unique_key="LISTING_ID") }}

select
    listing_id,
    host_id,
    {{ trimmer("property_type") }} as property_type,
    room_type,
    city,
    country,
    bedrooms,
    bathrooms,
    accommodates,
    price_per_night,
    {# {{ tag("price_per_night", var("booking_amount_tiers")) }} as amount_tag, #}
    {{ tag("price_per_night", 100, 200) }} as amount_tag,
    created_at
from
    {{ ref("bronze_listings") }}
    {# {% if is_incremental() -%}
    where created_at > (select coalesce(max(created_at), '1999-01-01') from {{ this }})
{%- endif -%} #}
