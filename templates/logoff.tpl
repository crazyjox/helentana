{% extends "base.tpl" %}

{% block container %}
Вы действительно хотите выйти?
<br/>
{% button text="Выйти" postback={logoff_account} delegate="helentana_account" class="btn" %}
{% button text="Отмена" action={redirect back} class="btn" %}
{% endblock %}

