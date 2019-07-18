<?php
session_start();
session_regenerate_id();

class Auth extends Core
{
    static $public_key;
    static $public_parity;
    static $rsa;
    static $email;
    static $admin_email;

    static function check_logged()
    {
        if (isset($_SESSION['display_name'])) header('Location: '.parent::$base_url);
    }

    static private function validate()
    {
        $_POST = filter_input_array(INPUT_POST, 
        [
            "email" => FILTER_SANITIZE_STRING
        ]);

        $error = NULL;

        $email = $_POST['email'];
        if ($email == NULL) 
        {
            $error = "Invalid email, please try again with the corrected value";
            return $error;
        }

        $email = self::$rsa->decryptor($email);

        $valid = filter_var($email, FILTER_VALIDATE_EMAIL);
        if (!$valid)
        {
            $error = "Incorrectly formatted email address, please try again with the corrected value";
            return $error;
        }
        
        $email_hash = hash('sha512', $email);

        $found = R::findOne('users', 'email = ?', [$email_hash]);

        if ($found == NULL)
        {
            $error = "Unregistered email, please try again or register a new account";
            return $error;
        }

        $now = strtotime(date("Y-m-d H:i:s"));
        $expiry = strtotime($found->login_key_expiry);
        
        if ($found->login_key != NULL && $expiry >= $now)
        {
            $error = "You have already attempted to sign in, please check your email (including junk/spam) for the passwordless sign-in link or try again in one (1) hour";
            return $error;
        }

        self::$email = $email;
        return (int)$found->id;
    }

    static function index()
    {
        self::check_logged();
        parent::$engine->assign('public_key', self::$public_key);
        parent::$engine->assign('public_parity', self::$public_parity);
        parent::$engine->display('views/signin.tpl');
    }
    
    static function send_mail($to, $subject, $message)
    {
        $from = self::$admin_email;
        $headers = "From: Cardea Health <$from>\r\nReply-To: $from\r\nX-Mailer: PHP/".phpversion();
        $headers .= 'MIME-Version: 1.0' . "\r\n";
        $headers .= 'Content-type: text/html; charset=iso-8859-1' . "\r\n";

        mail($to, $subject, $message, $headers);
    }

    static function login()
    {
        self::check_logged();
        $valid = self::validate();
        if (!is_int($valid))
        {
            parent::$engine->assign('error', $valid);
        }
        else
        {
            parent::$engine->assign('info', "Please check your email for the passwordless sign-in link");
            $user = R::load('users', $valid);

            $login_key = hash('sha256', uniqid());

            $now = strtotime(date("Y-m-d H:i:s"));
            $login_key_expiry = date("Y-m-d H:i:s", strtotime('+1 hours', $now));

            $user->login_key = $login_key;
            $user->login_key_expiry = $login_key_expiry;
            R::store($user);

            $base_url = parent::$base_url;
            $title = "Passwordless Sign In for Cardea Health";
            $msg = "Here is your passwordless sign in link to Cardea (it expires in 1 hour)<br /><br /><a href='$base_url/passwordless?key=$login_key'>Sign In</a>";
            self::send_mail(self::$email, $title, $msg);
        }
        return self::index();
    }

    static function confirm()
    {
        $data = $_GET['user'];
        $data = base64_decode($data);
        $data = explode(";", $data);
        
        if (sizeof($data) != 4) return self::register("Corrupted data, please contact the administrator");
        
        $email = $data[0];
        $email = hash('sha512', $email);
        $display_name = $data[1];
        $about_self = $data[2];
        $role = $data[3];

        $found = R::findOne('users', 'email = ?', [$email]);
        if ($found !== NULL) return self::register("Email already registered, please try signing in");
        
        if ($role == 1) $role = 'medic';
        else if ($role == 0) $role = 'patient';
        else return self::register("Invalid role selected, please contact the administrator");

        $user = R::dispense('users');
        $user->email = $email;
        $user->display_name = $display_name;
        $user->role = $role;
        $user->joined_date = date("Y-m-d H:i:s");
        $user->last_login = date("Y-m-d H:i:s");
        $user->last_ip = self::get_ip_address();
        $id = R::store($user);

        $_SESSION['display_name'] = $id;
        self::index();
    }

    static private function validate_provision()
    {
        $_POST = filter_input_array(INPUT_POST, 
        [
            "email" => FILTER_SANITIZE_STRING,
            "display_name" => FILTER_SANITIZE_STRING,
            "about_self" => FILTER_SANITIZE_STRING,
            "role" => FILTER_VALIDATE_INT
        ]);

        $email = $_POST['email'];
        $email = self::$rsa->decryptor($email);

        $valid = filter_var($email, FILTER_VALIDATE_EMAIL);
        if (!$valid)
        {
            $error = "Incorrectly formatted email address, please try again with the corrected value";
            return $error;
        }

        $email_hash = hash('sha512', $email);

        $found = R::findOne('users', 'email = ?', [$email_hash]);
        if ($found !== NULL)
        {
            $error = "This email has already been registered, please sign in instead of registering";
            return $error;
        }

        $display_name = $_POST['display_name'];

        if (strlen(trim($display_name)) < 3)
        {
            $error = "Display name cannot be blank during registration or shorter than 3 characters";
            return $error;
        }

        if (strlen(trim($display_name)) > 20)
        {
            $error = "Display name is too long, please choose a shorter and more readable value";
            return $error;
        }

        $found = R::findOne('users', 'display_name = ?', [$display_name]);
        if ($found !== NULL)
        {
            $error = "Display name has already been selected by another user, please modify your display name to be uniquely identified";
            return $error;
        }

        $about_self = $_POST['about_self'];

        if (strlen(trim($display_name)) >= 255)
        {
            $error = "Self-introduction is too long, please shorten it to less than 255 characters";
            return $error;
        }

        $role = (int)$_POST['role'];
        if ($role != 1 && $role != 0)
        {
            $error = "Role is invalid, please re-submit the form";
            return $error;
        }

        return NULL;
    }

    static function provision()
    {
        $valid = self::validate_provision();

        if ($valid !== NULL)
        {
            parent::$engine->assign('error', $valid);
            return self::register();
        }

        $email = $_POST['email'];
        $email = self::$rsa->decryptor($email);
        $display_name = $_POST['display_name'];
        $about_self = $_POST['about_self'];
        $role = $_POST['role'];

        $stateless = base64_encode("$email;$display_name;$about_self;$role");

        $base_url = parent::$base_url;
        $title = "New User Registration for Cardea Health";
        $msg = "Please click the link below to confirm your Cardea Health account (if you did not register, you can safely delete this message)<br /><br /><a href='base_url/confirm?user=$stateless'>Confirm Email</a>";
        self::send_mail($email, $title, $msg);
        parent::$engine->assign('info', "Please check your email to confirm your account before you can use it");
        self::register();
    }

    static function register($bug = NULL)
    {
        self::check_logged();

        if ($bug !== NULL) parent::$engine->assign('error', $bug);
        parent::$engine->assign('public_key', self::$public_key);
        parent::$engine->assign('public_parity', self::$public_parity);
        parent::$engine->display('views/register.tpl');
    }

    static private function check_login_key($login_key)
    {
        $found = R::findOne('users', 'login_key = ?', [$login_key]);

        if ($found == NULL)
        {
            $error = "Invalid passwordless link, please check the link or try signing in again";
            return $error;
        }

        $now = strtotime(date("Y-m-d H:i:s"));
        $expiry = strtotime($found->login_key_expiry);
        
        if ($expiry < $now)
        {
            $error = "The passwordless link has expired, please try sigining in again";
            return $error;
        }

        return (int)$found->id;
    }

    static function get_ip_address()
    {
        $options = array('http' => array('user_agent' => 'Cardea Health Academic Project <hwsamuel@ualberta.ca>'));
        $context = stream_context_create($options);
        $response = file_get_contents("http://bot.whatismyipaddress.com", FALSE, $context);

        return $response;
    }

    static function passwordless()
    {
        self::check_logged();

        $_GET = filter_input_array(INPUT_GET, 
        [
            "key" => FILTER_SANITIZE_STRING
        ]);
        
        $login_key = $_GET['key'];
        $valid_key = self::check_login_key($login_key);

        if (!is_int($valid_key))
        {
            parent::$engine->assign('error', $valid_key);
            return self::index();
        }
        
        $user = R::load('users', $valid_key);
        $user->login_key = NULL;
        $user->login_key_expiry = NULL;
        $user->last_login = date("Y-m-d H:i:s");
        $user->last_ip = self::get_ip_address();
        R::store($user);

        $_SESSION['display_name'] = $valid_key;
        header('Location: '.parent::$base_url);
    }

    static function logout()
    {
        session_unset();
        session_destroy();
        header('Location: '.parent::$base_url);
    }
}
