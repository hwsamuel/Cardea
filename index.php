<?php
require_once 'static/altorouter/AltoRouter.php';
require_once 'static/smarty/Smarty.class.php';
require_once 'static/redbeanphp/rb-mysql.php';
require_once 'forum.php';
require_once 'auth.php';
    
$smarty = new Smarty;
$smarty->setTemplateDir('views');
$smarty->setCompileDir('cache');
$smarty->caching = 0;
$smarty->auto_literal = TRUE;
$smarty->left_delimiter = "{"; 
$smarty->right_delimiter = "}";

R::setup('mysql:host=localhost;dbname=cardea_db', 'root', '');
R::freeze(TRUE);

R::ext('xdispense', function($type){
    return R::getRedBean()->dispense($type); 
});

$router = new AltoRouter();

$router->map('GET', '/cardea/', 'CForum::index');
$router->map('GET', '/cardea/p2p', 'CForum::p2p');
$router->map('GET', '/cardea/p2m', 'CForum::p2m');
$router->map('GET', '/cardea/m2m', 'CForum::m2m');

$router->map('GET', '/cardea/login', 'CAuth::index');
$router->map('POST', '/cardea/login', 'CAuth::login');
$router->map('GET', '/cardea/logout', 'CAuth::logout');

$match = $router->match();

if($match && is_callable($match['target']))
{
    call_user_func_array($match['target'], $match['params']); 
} 
else 
{
    $smarty->display('views/404.tpl');
}
