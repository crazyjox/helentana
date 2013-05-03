{% extends "news.tpl" %}
{% block pagetitle %}Главная страница{% endblock %}

{% block leftpane %}
    {% include "_user_panel.tpl" %}
{% endblock %}

{% block content %}
{% loremipsum %}
{% endblock %}

{% block rightpane %}
{% loremipsum %}
{% endblock %}



