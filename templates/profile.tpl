{% extends "news.tpl" %}

{% block pagetitle %}Профиль аккаунта{% endblock %}

{% block leftpane %}
{% endblock %}

{% block content %}
    <ul class="nav nav-tabs">
        <li class="active">
            <a href="#character-list" data-toggle="tab">Персонажи</a>
        </li>
        <li>
            <a href="#messages-list" data-toggle="tab">Сообщения</a>
        </li>
        <li>
            <a href="#settings-list" data-toggle="tab">Настройки</a>
        </li>
    </ul>
    <div id="tab-content" class="tab-content">
        <div class="tab-pane fade active in" id="character-list">
            Список персонажей
        </div>
        <div class="tab-pane fade in" id="messages-list">
            Личные сообщения
        </div>
        <div class="tab-pane fade in" id="settings-list">
            {% include "profile/_settings.tpl" %}
        </div>
    </div>
{% endblock %}	

{% block rightpane %}
{% endblock %}	


