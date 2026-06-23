{% macro tag(col_name, low_threshold, high_threshold) %}
    case
        when {{ col_name }} < {{ low_threshold }}
        then 'low'
        when
            {{ col_name }} >= {{ low_threshold }}
            and {{ col_name }} < {{ high_threshold }}
        then 'medium'
        else 'high'
    end
{% endmacro %}
