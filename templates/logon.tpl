{% extends "base.tpl" %}

{% block container %}
<div class="container">
    {% include "_nav_bar.tpl" %}
	<div class="row">
		<div class="span12">
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
		</div>
    </div>
    <div class="navbar navbar-fixed-bottom">
        <div class="navbar-inner">
            &copy; GROME 2013
        </div>
    </div>
</div>
{% endblock %}

