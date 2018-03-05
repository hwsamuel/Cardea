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
    <script type="text/javascript" src="/cardea/static/js/bootstrap-select.min.js"></script>
    
    <!-- JavaScript RSA encryption library -->
    <script type="text/javascript" src="/cardea/static/jsbn/jsbn.js"></script>
    <script type="text/javascript" src="/cardea/static/jsbn/prng4.js"></script>
    <script type="text/javascript" src="/cardea/static/jsbn/rng.js"></script>
    <script type="text/javascript" src="/cardea/static/jsbn/rsa.js"></script>
    
    <!-- HTML5 shim and Respond.js IE8 support of HTML5 elements and media queries -->
    <!--[if lt IE 9]>
		<script src="/cardea/static/js/html5shiv.min.js"></script>
		<script src="/cardea/static/js/respond.min.js"></script>
    <![endif]-->
    
    <!-- App CSS -->
    <link href="/cardea/static/css/common.css" rel="stylesheet" />
    
    <style>
    {block name=styles}{/block}
    </style>
    
    <script>
	{block name=scripts}{/block}
    </script>
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
                    <img src="/cardea/static/img/logo.png" style="height: 30px;" />
                </a> 
                <span class="navbar-brand" style="font-size: 12pt;">Health Social Network</span>
			</div>
	        <div class="navbar-collapse collapse navbar-right">
				<ul id="menu" class="nav navbar-nav">
	        		<li {if $active == "p2p"}class="active"{/if}><a href="/cardea/p2p">Patient to Patient <span class="badge">P2P</span></a></li>
	        		<li {if $active == "p2m"}class="active"{/if}><a href="/cardea/p2m">Patient to Medic <span class="badge">P2M</span></a></li>
	        		<li {if $active == "m2m"}class="active"{/if}><a href="/cardea/m2m">Medic to Medic <span class="badge">M2M</span></a></li>
                    <li {if $active == "groups"}class="active"{/if}><a href="/cardea/groups">Support Groups</a></li>
				
                {if !isset($display_name)}
                    <li>
                    <div class="navbar-form navbar-right">
				    <a href="/cardea/signin" class="btn btn-danger">Sign In</a>
                    </div>
                    </li>
            	{/if}
                </ul>
            </div>
		</div>
        
        {if isset($display_name)}
        <div id="extra_bar">
            <div class="container">
                <div class="row">
                    <div class="col-md-4">
                        <b><span class="glyphicon glyphicon-bookmark"></span> <a href="/cardea/profile">{$display_name}</a></b><span class="space">&nbsp;</span>
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
    
    {if isset($display_name)}<br /><br />{/if}
    
    <div class="container">
    	<noscript>
  	    <div class="alert alert-danger" role="alert">
  	        This website will <b>not</b> function properly without JavaScript. Please enable JavaScript to continue.
  	    </div>
  	    </noscript>
  	    
  	    <div class="row" id="main-content">
  	        <div class="col-xs-12">
				{block name=content}{/block}
			</div>
  	    </div>
		<div class="row">
  	        <div class="col-xs-12 text-muted small" style="border-top: 1px solid #EEE; padding-top:5px; margin-top: 5px;">
                <br />
                <table width="100%">
                <tr>
  	    		<td>&copy; 2018 All Rights Reserved. This project is supported by the <b><a target="_blank" href="http://amii.ca">Alberta Machine Intelligence Institute Amii</a></b></td>
                <td><a target="_blank" href="http://amii.ca"><img style="float: right; height: 50px; margin-top:-10px; " src="/cardea/static/img/amii.png" /></a></td>
                </tr>
                </table>
            </div>
      	</div>
	</div>
</body>
</html>