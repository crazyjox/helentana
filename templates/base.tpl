<!DOCTYPE html>
<html lang="{{ z_language|default:"ru"|escape }}">
<head>
    <meta charset="utf-8" />
{% block headmeta %}
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
	<meta name="author" content="GROME" />
{% endblock %}	
    <title>{% block pagetitle %}Онлайн-игра ВОЗРОЖДЕНИЕ ЭЛЕНТАНЫ{% endblock %}</title>
{% block libcss %}
	{% lib "bootstrap/css/bootstrap.css" %}
	{% lib "css/z.growl.css" %}
{% endblock %}	
</head>

<body>
{% block container %} 
{% endblock %}

{% block libscripts %}
{% include "_js_include_jquery.tpl" %}
{% lib
    "bootstrap/js/bootstrap.min.js"
    "js/apps/zotonic-1.0.js"
    "js/apps/z.widgetmanager.js"
    "js/modules/livevalidation-1.3.js"
    "js/modules/z.inputoverlay.js"
    "js/modules/z.dialog.js"
    "js/modules/jquery.loadmask.js"
    "js/modules/z.notice.js"
%}

<script type="text/javascript">
$(function() {
    $.widgetManager();
});
</script>
{% stream %}
{% script %}

{% endblock %}
</body>
</html>

