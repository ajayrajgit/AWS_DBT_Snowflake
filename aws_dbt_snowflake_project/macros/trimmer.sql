{% macro trimmer(column_name, node) %}
    -- This macro is used to trim the column name and convert it to uppercase
    upper(trim({{ column_name }}))

{% endmacro %}
