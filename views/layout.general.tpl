<!DOCTYPE html>
<html lang="en">
<head>
	<meta charset="utf-8" />
    <meta http-equiv="X-UA-Compatible" content="IE=edge" />
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <meta name="author" content="" />
    <link rel="icon" href="/cardea/static/img/logo.png" type="image/x-icon">

    <title>cardea &bull; Health Social Network</title>

    <!-- Bootstrap core CSS -->
    <link href="/cardea/static/css/bootstrap.min.css" rel="stylesheet" />

    <!-- Custom styles for this template -->
    <link href="/cardea/static/css/jumbotron.css" rel="stylesheet" />

    <!-- IE10 viewport hack for Surface/desktop Windows 8 bug -->
    <script src="/cardea/static/js/ie10-viewport-bug-workaround.js"></script>

    <!-- Bootstrap core JavaScript -->
    <script src="/cardea/static/js/jquery-2.1.1.min.js"></script>
    <script src="/cardea/static/js/bootstrap.min.js"></script>

    <!-- Bootstrap Select plugin -->
    <link rel="stylesheet" href="/cardea/static/css/bootstrap-select.min.css" type="text/css"/>
    <script src="/cardea/static/js/bootstrap-select.min.js"></script>
    
    <!-- JavaScript RSA encryption library -->
    <script src="/cardea/static/jsbn/jsbn.js"></script>
    <script src="/cardea/static/jsbn/prng4.js"></script>
    <script src="/cardea/static/jsbn/rng.js"></script>
    <script src="/cardea/static/jsbn/rsa.js"></script>
    
    <!-- HTML5 shim and Respond.js IE8 support of HTML5 elements and media queries -->
    <!--[if lt IE 9]>
		<script src="/cardea/static/js/html5shiv.min.js"></script>
		<script src="/cardea/static/js/respond.min.js"></script>
    <![endif]-->
    
    <!-- App CSS -->
    <link href="/cardea/static/css/common.css" rel="stylesheet" />
    
    <!-- App JavaScript -->
    <script src="/cardea/static/js/common.js"></script>

    {block name=styles}{/block}
	{block name=scripts}{/block}
</head>

<body>
    <div class="navbar navbar-inverse navbar-fixed-top" role="navigation">
		<div class="container">
	        <div class="navbar-header">
	       		<button type="button" class="navbar-toggle" data-toggle="collapse" data-target=".navbar-collapse">
		        	<span class="sr-only">Toggle navigation</span>
		            <span class="icon-bar"></span>
		            <span class="icon-bar"></span>
		            <span class="icon-bar"></span>
	          	</button>
	          	<a class="navbar-brand" id="logo" href="/cardea/">
                    <span class="orange-text">ca</span><span class="white-text">rdea</span>
                    <img alt="Cardea" src="/cardea/static/img/logo.png" style="height: 30px;" />
                </a> 
                <span class="navbar-brand" style="font-size: 12pt;">Canadian Health Social Network</span>
			</div>
	        <div class="navbar-collapse collapse navbar-right">
				<ul id="menu" class="nav navbar-nav">
	        		<li {if isset($active) && $active == "p2p"}class="active"{/if}><a href="/cardea/p2p">Patient to Patient <span class="badge">P2P</span></a></li>
	        		<li {if isset($active) && $active == "p2m"}class="active"{/if}><a href="/cardea/p2m">Patient to Medic <span class="badge">P2M</span></a></li>
	        		<li {if isset($active) && $active == "m2m"}class="active"{/if}><a href="/cardea/m2m">Medic to Medic <span class="badge">M2M</span></a></li>
                    <li {if isset($active) && $active == "groups"}class="active"{/if}><a href="/cardea/groups">Support Groups</a></li>
				
                {if !isset($signed_in)}
                    <li>
                    <div class="navbar-form navbar-right">
				    <a href="/cardea/signin" class="btn btn-danger">Sign In</a>
                    </div>
                    </li>
            	{/if}
                </ul>
            </div>
		</div>
        
        {if isset($signed_in)}
        <div id="extra_bar">
            <div class="container">
                <div class="row">
                    <div class="col-md-4">
                        <b><span class="glyphicon glyphicon-bookmark"></span> <a href="/cardea/profile">{$signed_in}</a></b><span class="space">&nbsp;</span>
                        <span class="text-muted small">View your profile</span>
                    </div>
                    <div class="col-md-8 text-right">
                        <a href=""><span class="glyphicon glyphicon-flash"></span> Notifications</a> <span class="label label-danger">3</span>
                        <a href=""><span class="glyphicon glyphicon-inbox"></span> Inbox</a> <span class="label label-white">0</span>
                        <a href=""><span class="glyphicon glyphicon-cog"></span> Settings</a> <span class="space">&nbsp;</span>
                        <a href="/cardea/signout"><span class="glyphicon glyphicon-off"></span> Sign Out</a> <span class="space">&nbsp;</span>
                    </div>
                </div>
            </div>
        </div>
        {/if}
    </div>
    
    <div class="container" {if isset($signed_in)}style="margin-top: 25px"{/if}>
    	<noscript>
  	    <div class="alert alert-danger" role="alert">
  	        This website will <b>not</b> function without JavaScript. Please enable JavaScript to continue.
  	    </div>
  	    </noscript>
  	    
  	    <div class="row" id="main-content">
  	        <div class="col-xs-12">
				{block name=content}{/block}
			</div>
  	    </div>
		<div class="row">
  	        <div class="col-xs-12 text-muted small" style="border-top: 1px solid #EEE; margin-top: 10px;">
                <br />
                <table style="width:100%;">
                <tr>
                <td>
                    &copy; 2019 All Rights Reserved. This project is supported by the <b><a target="_blank" href="http://amii.ca">Alberta Machine Intelligence Institute (Amii)</a></b>
                </td>
                <td>
                    <a target="_blank" href="http://amii.ca"><img alt="Amii" style="float: right; height: 45px; margin-top:-10px; margin-left: 15px;" src="/cardea/static/img/amii.png" /></a>

                    <a target="_blank" href="https://www.priv.gc.ca/en/privacy-topics/privacy-laws-in-canada/the-personal-information-protection-and-electronic-documents-act-pipeda/pipeda-compliance-help/pipeda-compliance-and-training-tools/pipeda_sa_tool_200807/"><img src="/cardea/static/img/pipeda.png" alt="PIPEDA Ready" style="height: 20px; margin-right: 10%;" /></a>
                    
                    <a target="_blank" href="https://validator.w3.org/check?uri=referer"><img src="http://www.w3.org/Icons/valid-html401-blue" alt="W3C Valid HTML 4.01" /></a>
                </td>
                </tr>
                </table>
            </div>
      	</div>
	</div>
</body>
</html>