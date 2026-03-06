<aside>

    {% if id.is_editable %}
        {% include "aside-connection/aside-add-connection.tpl" id=id cat="keyword" predicate="subject" %}
        {% include "aside-connection/aside-add-connection.tpl" id=id cat="person" predicate="author" title=_'Author' %}
    {% endif %}

    {% if m.search::%{
            anyof: [
                %{
                    term: 'hasobject',
                    value: %{
                        id: id,
                        predicate: 'depiction'
                    }
                },
                %{
                    term: 'hasobject',
                    value: %{
                        id: id,
                        predicate: 'hasdocument'
                    }
                },
                %{
                    term: 'hasobject',
                    value: %{
                        id: id,
                        predicate: 'refers'
                    }
                }
            ],
            pagelen: 10
        } as result
    %}
        <div class="ginger-edit__aside--refers">
            <h3 class="section-title">{_ On page _}</h3>
            {% optional include "list/list.tpl" class="list-about" items=result hide_edit_button hide_showmore_button hide_showall_button %}
        </div>
    {% endif %}

{#
    {% include "aside-connection/aside-show-connection.tpl"
               id=id
               predicate="depiction"
               direction="out"
               title=_"On page"
    %}
#}

</aside>