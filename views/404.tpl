{extends file="template.tpl"}

{block name=title}404 Error{/block}

{block name=content}
<p>
<div class="col-xs-12">
	<center>
	<form class="form-inline" method="post" action="">
		<h3>404 Error</h3>
		<p class="text-muted">The page you are looking for is not here</p><br />
		<p><img src="/cardea/static/img/404.png"></p><br />
		<p><a href="/cardea" class="btn btn-warning">Take Me Back</a></p>
	</form>
	</center>
</div>
</p>
{/block}
