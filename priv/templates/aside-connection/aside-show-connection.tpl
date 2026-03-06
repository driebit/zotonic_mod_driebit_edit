{% with
    title|default:m.rsc[predicate].title,
    direction|default:'in'
as
    title,
    direction
%}

    {# TODO styling #}

    {% if direction == 'in' %}
        {% if m.search::%{
            hassubject: %{
                id: id,
                predicate: predicate
            },
            pagelen: 6
        } as result %}
            <div class="ginger-edit__aside--{{ predicate }}">
                <h3 class="section-title">{{ title }}</h3>
                {% optional include "list/list.tpl" class="ginger-edit__list" items=result hide_edit_button hide_showmore_button hide_showall_button %}
            </div>
        {% endif %}
    {% else %}
        {% if m.search::%{
            hasobject: %{
                id: id,
                predicate: predicate
            },
            pagelen: 6
        } as result %}
            <div class="ginger-edit__aside--{{ predicate }}">
                <header><h3 class="section-title">{{ title }}</h3></header>
                {% optional include "list/list.tpl" class="ginger-edit__list" items=result hide_button=1 %}
            </div>
        {% endif %}
    {% endif %}
{% endwith %}
