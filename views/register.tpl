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
<form method="POST" action="{$base_url}/register">
    <p><b>Register New Account</b></p>
    
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
        <input autocomplete="off" required="true" type="text" class="form-control" id="emailplain" placeholder="You Email (For Passwordless Sign In)" />
        <input required type="hidden" name="email" id="email" />
    </div>

    <div class="form-group">
        <input autocomplete="off" required="true" type="text" class="form-control" id="display_name" name="display_name" placeholder="You Display Name (Shown on the Site)" />
    </div>

    <div class="form-group">
        <textarea autocomplete="off" class="form-control" id="about_self" name="about_self" placeholder="Your Brief Self-Introduction (Optional)"></textarea>
    </div>

    <div class="form-group">
        Are you a medical professional or medical researcher? If yes, review our <a href="#">Verification Process</a>
        <input type="radio" name="role" value=1 /> Yes
        <input type="radio" name="role" checked="true" value=0 /> No
    </div>

    <div class="form-group">
         <span class="glyphicon glyphicon-ok"></span>&nbsp; You agree to our <strong><a href="#">Privacy Policy</a></strong>&nbsp; <a href="{$base_url}" class="btn btn-danger">Cancel If You Disagree</a>
        <button type="submit" onclick="encrypt();" class="btn btn-success">Create Account</button>
    </div>

</form>
</p>

{/block}
