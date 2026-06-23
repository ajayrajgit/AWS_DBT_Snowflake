select
    booking_id,
    listing_id,
    host_id,
    total_amount,
    cleaning_fee,
    service_fee,
    bedrooms,
    bathrooms,
    accommodates,
    price_per_night,
    response_rate
from {{ ref("obt") }}
