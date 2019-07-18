{extends file="layout.general.tpl"}

{block name=title}404 Error{/block}

{block name=content}
<p>
<form class="form-inline" method="post" action="">
    <h3>404 Error <a href="{$base_url}" class="btn btn-success">Go Back</a></h3>
    <img src="{$base_url}/static/img/404.png">
</form>
</p>
{/block}