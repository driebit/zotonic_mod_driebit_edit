{% extends "admin_edit_widget_std.tpl" %}

{# Show the edit fields to edit the name of a person #}

{% block widget_title %}{_ Email _} {% if id.category_id.feature_show_address %} &amp; {_ Address _}{% endif %}{% endblock %}
{% block widget_show_minimized %}true{% endblock %}
{% block widget_id %}content-address{% endblock %}
{% block widget_class %} edit-address {% endblock %}

{% block widget_content %}
    <div class="row">
        <div class="col-lg-12 col-md-12">
            {% catinclude "_admin_edit_content_address_email.tpl" id %}
        </div>
    </div>
    {% if id.category_id.feature_show_address %}
        <div class="row">
            <div class="col-lg-6 col-md-6">
                <div class="form-group address_telephone">
                    <label class="control-label" for="phone">{_ Telephone _}</label>
                    <input class="form-control" id="phone" type="text" name="phone" value="{{ id.phone }}">
                </div>
            </div>
            <div class="col-lg-6 col-md-6">
                <div class="form-group address_mobile">
                    <label class="control-label" for="phone">{_ Mobile _}</label>
                    <input class="form-control" id="phone_mobile" type="text" name="phone_mobile" value="{{ id.phone_mobile }}">
                </div>
            </div>
        </div>
        <div class="row">
            <div class="form-group visit_address_country col-xs-12">
                <label class="control-label" for="address_country">{_ Country _}</label>
                <span class="admin-text-header"></span>
                {% if m.modules.active.mod_l10n %}
                    <select class="form-control" id="address_country" name="address_country">
                        <option value=""></option>
                        {% optional include "_l10n_country_options.tpl" country=r.address_country %}
                    </select>
                {% else %}
                    <input class="form-control" id="address_country" type="text" name="address_country" value="{{ id.address_country }}">
                {% endif %}
            </div>

            <div id="visit_address" class="visit-address">
                <div class="form-group address_street col-lg-6 col-md-6">
                    <label class="control-label" for="address_street_1">{_ Street Line 1 _}</label>
                    <input class="form-control" id="address_street_1" type="text" name="address_street_1" value="{{ id.address_street_1 }}">
                </div>

                <div class="form-group address_city col-lg-6 col-md-6">
                    <label class="control-label" for="address_city">{_ City _}</label>
                    <input class="form-control" id="address_city" type="text" name="address_city" value="{{ id.address_city }}">
                </div>

                <div class="form-group address_zipcode col-lg-6 col-md-6">
                    <label class="control-label" for="address_postcode">{_ Postcode _}</label>
                    <input class="form-control" id="address_postcode" type="text" name="address_postcode" value="{{ id.address_postcode }}">
                </div>
                <div class="form-group address_state col-lg-6 col-md-6">
                    <label class="control-label" for="address_state">{_ State _}</label>
                    <input class="form-control" id="address_state" type="text" name="address_state" value="{{ id.address_state }}">
                </div>
            </div>
        </div>
    {% endif %}
{% endblock %}
