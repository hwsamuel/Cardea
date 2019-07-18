{extends file="layout.general.tpl"}

{block name=scripts}
<!-- JavaScript RSA encryption library -->
<script type="text/javascript" src="{$base_url}/static/jsbn/jsbn.js"></script>
<script type="text/javascript" src="{$base_url}/static/jsbn/prng4.js"></script>
<script type="text/javascript" src="{$base_url}/static/jsbn/rng.js"></script>
<script type="text/javascript" src="{$base_url}/static/jsbn/rsa.js"></script>

<script>
function encrypt() 
{
	var rsa = new RSAKey();
    rsa.setPublic('{$public_key}', '{$public_parity}');
    var encr = rsa.encrypt($('#emailplain').val());
    $('#email').val(encr);
}
</script>
{/block}

{block name=content}
<p>
<form class="form-inline" method="POST" action="{$base_url}/signin">
    <p><b>Passwordless Sign In</b></p>
    
    {if isset($error)}
    <div class="alert alert-danger" role="alert">
        {$error}
        <a href="#" class="close pull-right" data-dismiss="alert" aria-label="close">&times;</a>
    </div>
    {/if}
	{if isset($info)}
    <div class="alert alert-info" role="alert">
        {$info}
        <a href="#" class="close pull-right" data-dismiss="alert" aria-label="close">&times;</a>
    </div>
    {/if}

    <div class="form-group">
        <input autocomplete="off" required="true" type="text" class="form-control" id="emailplain" placeholder="You Email" />
        <input required type="hidden" name="email" id="email" />
    </div>
    <button type="submit" onclick="encrypt();" class="btn btn-default">Sign In</button>
    <a class="btn btn-warning" href="{$base_url}/register">Register</a>
</form>
</p>

{/block}
