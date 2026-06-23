{% set cols = ['NIGHTS_BOOKED','BOOKING_ID','LISTING_ID'] %}

SELECT 
{% for col in cols %}
    {{ col }}
    {% if not loop.last %},
    {% endif %}
{% endfor %}
FROM {{ ref('bronze_bookings') }}
{# WHERE BOOKING_ID = 111 #}