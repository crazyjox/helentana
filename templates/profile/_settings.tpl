{% wire id="profile-settings-form" type="submit" postback={login_account} delegate="helentana" %}
<form id="profile-settings-form" method="post" action="postback" class="form-horizontal">
    <label class="control-label" for="name">Ваше имя и фамилия:</label>
    <div class="control-group">
        <input type="text" class="input-medium" id="name" name="name" placeholder="Введите ваше имя и фамилию" autocomlete="off"/>
    </div>
    <div class="form-actions">
        <button class="btn btn-primary">Сохранить</button>
    </div>
</form>


