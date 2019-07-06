<?php
require_once 'static/altorouter/AltoRouter.php';
require_once 'static/smarty/Smarty.class.php';
require_once 'static/redbeanphp/rb-mysql.php';
require_once 'controllers/forum.php';
require_once 'controllers/comment.php';
require_once 'controllers/vote.php';
require_once 'auth.php';
require_once 'process.php';

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
Forum::$engine = $smarty;

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

$router->map('GET', '/cardea/signin', 'CAuth::index');
$router->map('POST', '/cardea/signin', 'CAuth::login');
$router->map('GET', '/cardea/signout', 'CAuth::logout');

$match = $router->match();

if($match && is_callable($match['target']))
{
    call_user_func_array($match['target'], $match['params']); 
} 
else 
{
   $smarty->display('views/404.tpl');
}
