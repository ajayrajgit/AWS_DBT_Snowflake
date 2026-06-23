{% set flag = 2 %}

SELECT * FROM {{ ref('bronze_bookings') }}
{% if flag == 1 %}
    WHERE listing_id = 379
{% else %}
    WHERE listing_id = 111
{% endif %}