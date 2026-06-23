{% set congigs = [
    {
        "table": "AIRBNB_RAW.SILVER.SILVER_BOOKINGS",
        "columns": "SILVER_bookings.booking_id,SILVER_bookings.listing_id ,SILVER_bookings.booking_date,SILVER_bookings.total_amount,         SILVER_bookings.cleaning_fee,SILVER_bookings.service_fee,SILVER_bookings.booking_status, SILVER_bookings.created_at",
        "alias": "SILVER_bookings",
    },
    {
        "table": "AIRBNB_RAW.SILVER.SILVER_LISTINGS",
        "columns": "SILVER_listings.host_id,SILVER_listings.listing_id as listing_ids,SILVER_listings.property_type,         SILVER_listings.room_type,SILVER_listings.city,SILVER_listings.country,         SILVER_listings.bedrooms, SILVER_listings.bathrooms, SILVER_listings.accommodates,         SILVER_listings.price_per_night, SILVER_listings.amount_tag,SILVER_listings.created_at as listing_created_at",
        "alias": "SILVER_listings",
        "join_condition": "SILVER_bookings.listing_id = SILVER_listings.listing_id",
    },
    {
        "table": "AIRBNB_RAW.SILVER.SILVER_HOSTS",
        "columns": "SILVER_HOSTS.host_id as host_ids, SILVER_HOSTS.host_name,         SILVER_HOSTS.host_since, SILVER_HOSTS.is_superhost,SILVER_HOSTS.RESPONSE_TAG,         SILVER_HOSTS.response_rate,          SILVER_HOSTS.created_at as host_created_at",
        "alias": "SILVER_HOSTS",
        "join_condition": "SILVER_listings.host_id = SILVER_HOSTS.host_id",
    },
] %}


{# select
    {% for config in congigs %}
        {{ config.columns }} {% if not loop.last %},{% endif %}
    {% endfor %}
from {{ congigs[0].table }} as {{ congigs[0].alias }}
{% for config in congigs[1:] %}
    left join
        {{ config["table"] }} as {{ config["alias"] }} on {{ config["join_condition"] }}
{% endfor %} #}
select
    {% for config in congigs %}
        {{ config["columns"] }} {% if not loop.last %},{% endif %}
    {% endfor %}
from
{% for config in congigs %}
        {% if loop.first %} {{ config["table"] }} as {{ config["alias"] }}
    {% else %}
        left join
            {{ config["table"] }} as {{ config["alias"] }}
            on {{ config["join_condition"] }}
    {% endif %}
{% endfor %}
