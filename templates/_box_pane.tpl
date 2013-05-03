{% if title %}<h4>{{ title }}</h4>{% endif %}
{% block box_pane %}

    <div class="well">
       <div style="text-align:center;">
    		Приветствую тебя, <br/>
	    	<strong>{{ m.account.name }}</strong> <br/><br/>
            {% button text="Войти в мир Элентаны" postback={open_world} delegate="helentana" class="btn" %}
            <a href="{% url profile %}" title="Перейти к профилю">Профиль</a> | 
    		<a href="{% url logoff %}" title="Выйти">Выйти</a>
        </div>
    </div>
{% else %}
    <div class="well">
        <div style="text-align:center;">
            {% wire id="quick-login-form" type="submit" postback={login_account} delegate="helentana" %}
            {% validate id="email" type={presence} failure_message="Введите имя аккаунта!" %}
            {% validate id="password" type={presence} failure_message="Похоже, вы забыли ввести пароль" %}
            <form id="quick-login-form" method="post" action="postback">
                <label for="email">Email:</label>
                <input type="text" class="input-medium" id="email" name="email" placeholder="Введите e-mail..." autocomlete="off"/>
                <label for="password">Пароль:</label>
                <input type="password" class="input-medium" id="password" name="password" placeholder="Введите пароль..." autocomlete="off"/>
                <input type="submit" class="btn" value="Войти"/> <br/>
                <a href="{% url register_account %}">Регистрация</a><br/>
                <a href="{% url restore_account %}">Восстановление</a>
            </form>
        </div>
    </div>
{% endif %}

{% end block %}
