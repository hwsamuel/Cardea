<?php
session_start();
session_regenerate_id();

require 'static/phpseclib/rsa.php';

// @todo Regenerate public key pair
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

$rsa = new RSA($rsa_public_key, $rsa_private_key);

class CAuth
{
    static function validate()
    {
        return isset($_SESSION['logged_in']) ? TRUE : header('Location: /membersarea/login');
    }

    static function index()
    {
        global $smarty, $rsa_public_key, $rsa_public_key_parity;
        $_SESSION['display_name'] = 3;
        
        if (isset($_SESSION['display_name'])) header('Location: /cardea');

        $smarty->assign('rsa_public_key', $rsa_public_key);
        $smarty->assign('rsa_public_key_parity', $rsa_public_key_parity);
        $smarty->display('views/signin.tpl');
    }
    
    static function logout()
    {
        session_unset();
        session_destroy();
        header('Location: /cardea');
    }
}
