<?php
require_once 'static/altorouter/AltoRouter.php';
require_once 'static/smarty/Smarty.class.php';
require_once 'static/redbeanphp/rb-mysql.php';

require_once 'controllers/core.php';
require_once 'controllers/forum.php';
require_once 'controllers/comment.php';
require_once 'controllers/vote.php';
require_once 'controllers/auth.php';
require_once 'controllers/process.php';

R::setup('mysql:host=localhost;dbname=cardea_db', 'root', '');
R::freeze(TRUE);
//R::fancyDebug(TRUE);

$smarty = new Smarty;
$smarty->setTemplateDir('views');
$smarty->setCompileDir('cache');
$smarty->caching = 0;
$smarty->auto_literal = TRUE;
$smarty->left_delimiter = "{"; 
$smarty->right_delimiter = "}";

$groups = R::findAll('posts', "type_of = 'group' AND visibility = 'public'"); // @todo Add visibility filter
$smarty->assign('groups', $groups);

if (isset($_SESSION['display_name'])) $smarty->assign('signed_in', $_SESSION['display_name']); // @todo Align across all pages
Core::$engine = $smarty;

require 'static/phpseclib/rsa.php';

// @todo Regenerate public key pair
$private_key = '-----BEGIN RSA PRIVATE KEY-----
MIIBOQIBAAJBAI2syVtfIdgNeItqYUCV33ROxKu5nKSt3qlpjEbQsZuq4m5cpvtc
woH811nbI6SnSXz3JabL8jeAkmzUQz+54PECAwEAAQJAKHXisZYbJ8U9Gm/Ao33J
6cD/GN3y9vLy5qYOmkDKoF6A56UBfGCj6kirs3/b8HKSDIn7luCuTfJVjZIB3Y+1
wwIhANqrGgkEqt7+FDpl2uVyiF48nSyeWNkp8Gl+u8ck+u5HAiEApdywPFqU+Ey3
uNw8KMWu6yd1HVQxgq2F04qByLL1OwcCIGKPCk4UR3v4418q943BoMtw4JryyDMh
nxW9pJ9vAJcTAiBCx9eBhWsjiigS20GxnN5vueRSmbqRhfIzGTpmJ3/LcwIgUM1v
nIDCU0aTAp4y/lC5IFZHWMcQN5BL7/rouD5zJ1Q=
-----END RSA PRIVATE KEY-----';

$public_key = '8dacc95b5f21d80d788b6a614095df744ec4abb99ca4addea9698c46d0b19baae26e5ca6fb5cc281fcd759db23a4a7497cf725a6cbf23780926cd4433fb9e0f1';

$public_parity = '010001';

$rsa = new RSA($public_key, $private_key);

Auth::$public_key = $public_key;
Auth::$public_parity = $public_parity;
Auth::$rsa = $rsa;

//CProcess::get_bubblenet();

Forum::$engine->assign('healthnews', CProcess::get_newsfeed());
Forum::$engine->assign('healthvideo', CProcess::get_video());

$router = new AltoRouter();

$router->map('GET', '/cardea/', 'Forum::index');
$router->map('POST', '/cardea/comment_create', 'Comment::create');
$router->map('POST', '/cardea/vote_create', 'Vote::create');
$router->map('POST', '/cardea/vote_delete', 'Vote::delete');

$router->map('GET', '/cardea/p2p', 'Forum::p2p');
$router->map('POST', '/cardea/p2p', 'Forum::p2p_form');
$router->map('GET', '/cardea/p2m', 'Forum::p2m');
$router->map('POST', '/cardea/p2m', 'Forum::p2m_form');
$router->map('GET', '/cardea/m2m', 'Forum::m2m');
$router->map('POST', '/cardea/m2m', 'Forum::m2m_form');
$router->map('GET', '/cardea/groups', 'Forum::groups');
$router->map('GET', '/cardea/search_suggest', 'Forum::search_suggest');
$router->map('GET', '/cardea/posts_suggest', 'Forum::posts_suggest');
$router->map('GET', '/cardea/post/[i:id]/[a:forum]', 'Forum::viewpost');
$router->map('GET', '/cardea/search/[a:forum]/[*:keywords]', 'Forum::search');
$router->map('GET', '/cardea/group/[a:forum]/[i:id]', 'Forum::group');

$router->map('GET', '/cardea/signin', 'Auth::index');
$router->map('GET', '/cardea/register', 'Auth::register');
$router->map('POST', '/cardea/register', 'Auth::provision');
$router->map('GET', '/cardea/confirm', 'Auth::confirm');
$router->map('POST', '/cardea/signin', 'Auth::login');
$router->map('GET', '/cardea/passwordless', 'Auth::passwordless');
$router->map('GET', '/cardea/signout', 'Auth::logout');

$match = $router->match();

if($match && is_callable($match['target']))
{
    call_user_func_array($match['target'], $match['params']); 
} 
else 
{
   $smarty->display('views/404.tpl');
}
