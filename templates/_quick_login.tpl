{% wire id="quick-login-form" type="submit" postback={login_account} delegate="helentana" %}
{% validate id="email" type={presence} failure_message="Введите имя аккаунта!" %}
{% validate id="password" type={presence} failure_message="Похоже, вы забыли ввести пароль" %}
<form id="quick-login-form" method="post" action="postback">
    <label for="email">Email:</label>
    <input type="text" class="input-medium" id="email" name="email" placeholder="Введите e-mail..." autocomlete="off"/>
    <label for="password">Пароль:</label>
    <input type="password" class="input-medium" id="password" name="password" placeholder="Введите пароль..." autocomlete="off"/>
    <input type="submit" class="btn" value="Войти"/>
    <ul class="unstyled">
        <li><a href="{% url register_account %}">Зарегистрироваться</a></li>
        <li><a href="{% url restore_account %}">Восстановление аккаунта</a></li>
    </ul>
</form>


