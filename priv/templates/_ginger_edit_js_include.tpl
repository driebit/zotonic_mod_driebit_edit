{# Original template: admin_js_include.tpl #}
{#
Overwrite needed because in original template there is an all include
that includes _editor.tpl again. Where we only want to include
_ginger-editor.tpl.
#}

{% lib
"bootstrap/js/bootstrap.min.js"
%}

{% lib
    "js/modules/jstz.min.js"

    "cotonic/cotonic.js"
    "js/apps/zotonic-wired.js"

    "js/modules/jquery.hotkeys.js"

    "js/apps/admin-common.js"

    "js/jquery.ui.nestedSortable.js"

    "js/modules/z.adminwidget.js"

    "js/modules/z.live.js"
    "js/modules/z.notice.js"
    "js/modules/z.tooltip.js"
    "js/modules/z.dialog.js"
    "js/modules/z.feedback.js"
    "js/modules/z.formreplace.js"
    "js/modules/z.datepicker.js"
    "js/modules/z.menuedit.js"
    "js/modules/z.popupwindow.js"
    "js/modules/livevalidation-1.3.js"
    "js/modules/jquery.loadmask.js"
    "js/modules/jquery.timepicker.min.js"
    "js/apps/z.widgetmanager.js"
%}

{% if m.modules.active.mod_geo %}
    <script type="text/javascript" src="https://maps.googleapis.com/maps/api/js?key={{ m.geo.api.google_key|escape }}"></script>
    {% lib "js/admin-geo.js" %}
{% endif %}

{% if m.modules.active.mod_geomap %}
    {% include "_js_geomap.tpl" %}
{% endif %}

{% worker name="auth" src="js/zotonic.auth.worker.js" args=%{  auth: m.authentication.status  } %}

<script type="text/javascript" nonce="{{ m.req.csp_nonce }}">
$(function()
{
    $.widgetManager();
});
</script>
