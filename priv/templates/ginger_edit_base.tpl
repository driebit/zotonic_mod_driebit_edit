<!DOCTYPE html>
<html lang="en" class="ginger-edit-html">
    <head>
        <meta charset="utf-8" />
		<meta name="viewport" content="width=device-width, initial-scale=1.0" />
		<meta name="author" content="Driebit" />
        <title>{% block title %}{% endblock%}</title>
		<link rel="icon" href="/lib/images/favicon.ico" type="image/x-icon" />
		<link rel="shortcut icon" href="/lib/images/favicon.ico" type="image/x-icon" />

        {% lib
            "bootstrap/css/bootstrap.min.css"
        %}
		{% lib
            "css/ginger-edit.css"
            "css/jquery-ui.datepicker.css"
            "css/jquery.timepicker.css"
            "css/zp-menuedit.css"
            "css/zotonic-admin.css"
            "css/z.icons.css"
            "css/z.modal.css"
            "css/jquery.loadmask.css"
            "css/zotonic-admin.css"
            "css/screen.css"
            "css/image-edit.css"
        %}

        {% all include "_html_head.tpl" %}
        {% all include "_ginger_html_head_admin.tpl" %}

        {% include "_js_include_jquery.tpl" %}
        {% block head_extra %}{% endblock %}
    </head>
	<body class="{% block page_class %}{% endblock %}">

    {% block container %}
	<div class="{% block container_class %}container{% endblock %}">
        {% block header %}{% endblock %}

        {% block content %}{% endblock %}

        {% block footer %}{% endblock %}
	</div>
    {% endblock %}

    {% include "_ginger_edit_js_include.tpl" %}

    {% optional include "_ginger_edit_js_extra.tpl" %}

    {% script %}

    </body>
</html>
