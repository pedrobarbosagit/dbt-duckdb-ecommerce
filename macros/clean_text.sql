{#- Empty or blank text becomes null. Every raw column arrives as text, so this runs before any cast. -#}
{% macro clean_text(column_name) -%}
    nullif(trim({{ column_name }}), '')
{%- endmacro %}
