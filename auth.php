<?php
session_start();
session_regenerate_id();

require 'static/pgbrowser/pgbrowser.php';
require 'static/phpseclib/rsa.php';

$rsa_private_key = '-----BEGIN RSA PRIVATE KEY-----
MIIBOQIBAAJBAI2syVtfIdgNeItqYUCV33ROxKu5nKSt3qlpjEbQsZuq4m5cpvtc
woH811nbI6SnSXz3JabL8jeAkmzUQz+54PECAwEAAQJAKHXisZYbJ8U9Gm/Ao33J
6cD/GN3y9vLy5qYOmkDKoF6A56UBfGCj6kirs3/b8HKSDIn7luCuTfJVjZIB3Y+1
wwIhANqrGgkEqt7+FDpl2uVyiF48nSyeWNkp8Gl+u8ck+u5HAiEApdywPFqU+Ey3
uNw8KMWu6yd1HVQxgq2F04qByLL1OwcCIGKPCk4UR3v4418q943BoMtw4JryyDMh
nxW9pJ9vAJcTAiBCx9eBhWsjiigS20GxnN5vueRSmbqRhfIzGTpmJ3/LcwIgUM1v
nIDCU0aTAp4y/lC5IFZHWMcQN5BL7/rouD5zJ1Q=
-----END RSA PRIVATE KEY-----';

$rsa_public_key = '8dacc95b5f21d80d788b6a614095df744ec4abb99ca4addea9698c46d0b19baae26e5ca6fb5cc281fcd759db23a4a7497cf725a6cbf23780926cd4433fb9e0f1';

$rsa_public_key_parity = '010001';

$pgb = new PGBrowser();
$pgb->useCache = false;

$rsa = new RSA($rsa_public_key, $rsa_private_key);

class SIGWLogin
{
    static function validate()
    {
        return isset($_SESSION['logged_in']) ? TRUE : header('Location: /membersarea/login');
    }

    static function _get_member_id($str)
    {
        $st_str= "<b>Member Number:</b>";
        $ed_str = "<a href=";
        $start = strpos($str, $st_str) + strlen($st_str);
        $len = strpos($str, $ed_str, $start) - $start;
        return trim(substr($str, $start, $len));
    }
    
    static function index()
    {
        global $smarty, $rsa_public_key, $rsa_public_key_parity;
        if (isset($_SESSION['logged_in']))
        {
            header('Location: /membersarea/blogs');
        }
        else
        {
            $smarty->assign('rsa_public_key', $rsa_public_key);
            $smarty->assign('rsa_public_key_parity', $rsa_public_key_parity);
            $smarty->display('views/login.html');
        }
    }
    
    static function sso_login()
    {
        global $smarty, $rsa, $pgb, $rsa_public_key, $rsa_public_key_parity;
        $username = trim($_POST['username_plain']);
        $password = trim($_POST['password_plain']);
        if ($username === "" || $password === "")
        {
            $msg = "Username or password cannot be blank";
        }
        else
        {
	    $username = $rsa->decryptor($_POST['username']);
            $password = $rsa->decryptor($_POST['password']);
            $page = $pgb->get('https://myacm.acm.org/dashboard.cfm?svc=curr');
            $form = $page->forms(1);
            $form->set('username', $username);
            $form->set('password', $password);
            $page = $form->submit();
            $name = $page->at('//span[@id="breadcrumbs-you-are-here"]')->nodeValue;
            $name = trim(str_replace("Logout", "", $name));
            $content = $page->html;
            $is_member = preg_match("~\bSIGWEB Membership\b~",$content);
            if ($is_member == 1)
            {
                $mem_id = self::_get_member_id($content);
                $_SESSION['logged_in'] = array($name, $mem_id);
                header('Location: /membersarea/blogs/my');
            }
            else
            {
                $msg = "Invalid credentials or not SIGWEB member";
            }
        }
        $smarty->assign('rsa_public_key', $rsa_public_key);
        $smarty->assign('rsa_public_key_parity', $rsa_public_key_parity);
        $smarty->assign('msg', $msg);
        $smarty->display('views/login.html');
    }
    
    static function logout()
    {
        session_unset();
        session_destroy();
        header('Location: /membersarea/blogs');
    }
}
