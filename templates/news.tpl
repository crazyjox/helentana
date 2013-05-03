{% extends "base.tpl" %}

{% block container %}
<div class="container">
    {% include "_nav_bar.tpl" %}
	<div class="row">
		<div class="span3">
            {% block leftpane %}{% endblock %}		
		</div>
		<div class="span6">
            {% block content %}{% endblock %}		
		</div>
		<div class="span3">
            {% block rightpane %}{% endblock %}		
		</div>
    </div>
    {% include "_footer.tpl" %}
</div>
{% endblock %}

