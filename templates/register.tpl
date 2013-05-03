{% extends "news.tpl" %}
{% block pagetitle %}Регистрация{% endblock %}

{% block leftpane %}
{% endblock %}

{% block content %}
    {% wire id="register-form" type="submit" postback={register_account} delegate="helentana" %}
    {% validate id="email" type={presence} failure_message="Что за хуйня!" %}
    {% validate id="password" type={presence} failure_message="Введите пароль" %}
    {% validate id="password2" type={confirmation match="password"} failure_message="Подтвердите пароль" %}
    <form id="register-form" method="post" action="postback" class="form-horizontal">
        <div class="control-group">
            <label class="control-label" for="email">Email:</label>
            <div class="controls">
                <input type="text" class="input-large" id="email" name="email" placeholder="Введите e-mail..." autocomlete="off"/>
            </div>
        </div>
        <div class="control-group">
            <label class="control-label" for="password">Пароль:</label>
            <div class="controls">
                <input type="password" class="input-large" id="password" name="password" placeholder="Введите пароль..." autocomlete="off"/>
            </div>
        </div>
        <div class="control-group">
            <label class="control-label" for="password2">Пароль еще раз:</label>
            <div class="controls">
                <input type="password" class="input-large" id="password2" name="password2" placeholder="Подтвердите пароль..." autocomlete="off"/>
            </div>
        </div>
        <div class="form-actions">
            <input type="submit" class="btn btn-primary" value="Регистрация"/>
        </div>
        <div class="controls">
        <ul class="unstyled">
            <li><a href="#">Восстановить пароль к аккаунту</a>
        </ul>
    </form>
{% endblock %}

{% block rightpane %}
{% endblock %}



