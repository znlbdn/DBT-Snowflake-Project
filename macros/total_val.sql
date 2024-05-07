{% macro total_val(qty, unit_price, shipping, tax, scale=0) %}
    (({{qty}} * {{unit_price}}) + {{shipping}} + {{tax}})::decimal(16, {{ scale }})
{% endmacro %}