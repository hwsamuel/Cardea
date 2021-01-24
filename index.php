<?php
require_once 'config.php';
require_once 'routes.php';

require_once 'static/altorouter/AltoRouter.php';
require_once 'static/smarty/Smarty.class.php';
require_once 'static/redbeanphp/rb-mysql.php';
require_once 'static/phpseclib/rsa.php';

require_once 'controllers/core.php';
require_once 'controllers/forum.php';
require_once 'controllers/comment.php';
require_once 'controllers/vote.php';
require_once 'controllers/auth.php';
require_once 'controllers/process.php';

date_default_timezone_set($TIME_ZONE);

R::setup("mysql:host=$DB_HOST;dbname=$DB_NAME", $DB_USER, $DB_PWD);
R::freeze(TRUE);

$smarty = new Smarty;
$smarty->setTemplateDir('views');
$smarty->setCompileDir('cache');
$smarty->caching = 0;
$smarty->auto_literal = TRUE;
$smarty->left_delimiter = "{"; 
$smarty->right_delimiter = "}";

Core::$engine = $smarty;
Core::$base_url = $BASE_URL;
Core::$base_route = $BASE_ROUTE;
Core::$engine->assign('base_url', $BASE_URL);

Core::$engine->assign('groups', R::findAll('posts', "type_of = 'group'"));

Auth::$rsa = new RSA($PUB_KEY, $PRIV_KEY);
Auth::$public_key = $PUB_KEY;
Auth::$public_parity = $PUB_PARITY;
Auth::$admin_email = $ADMIN_EMAIL;

// Uncomment to re-generate RSA key pairs and manually update them in config.php
// print_r(Auth::$rsa->generate_keys());

Forum::$engine->assign('healthnews', Process::get_newsfeed());
Forum::$engine->assign('healthvideo', Process::get_video());

$router = new AltoRouter();
foreach ($ROUTES as $route)
{
	$router->map($route[1], $BASE_ROUTE.$route[0], $route[2]);
}

$match = $router->match();

if($match && is_callable($match['target']))
{
    call_user_func_array($match['target'], $match['params']); 
} 
else 
{
   $smarty->display('views/404.tpl');
}