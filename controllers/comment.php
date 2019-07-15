<?php

class Comment extends Core
{
    
    private static $post_id;
    private static $title;
    private static $identity;
    private static $forum;
    private static $user_id;
    private static $time_stamp;
    private static $visibility;
    private static $type_of = 'comment';

    static private function validate()
    {
        $_POST = filter_input_array(INPUT_POST, 
        [
            "post_id" => FILTER_VALIDATE_INT,
            "title" => FILTER_SANITIZE_STRING,
            "identity" => FILTER_SANITIZE_STRING,
            "forum" => FILTER_SANITIZE_STRING
        ]);
        
        self::$post_id = $_POST['post_id'];
        self::$title = trim($_POST['title']);
        self::$identity = trim($_POST['identity']);
        self::$forum = trim($_POST['forum']);
        self::$user_id = $_SESSION['display_name'];
        
        $post = R::load('posts', self::$post_id);
        
        $valid_post_id = $post->id !== 0;
        $valid_title = self::$title !== '' && strlen(self::$title) >= 20;
        $valid_identity = self::$identity !== '';
        $valid_forum = in_array(self::$forum, array('p2p','p2m','m2m'));
        
        if (!$valid_post_id || !$valid_title || !$valid_identity || !$valid_forum)
        {
            return FALSE;
        }
        else
        {
            date_default_timezone_set('America/Edmonton');
            self::$time_stamp = date('Y-m-d H:i:s');

            $post = R::load('posts', self::$post_id);
            self::$visibility = $post->visibility;
            return TRUE;
        }
    }

	// JavaScript: commentCreate() (/cardea/static/js/common.js)
    // Route: /cardea/comment_create (index.php)
    // Method: POST
    static function create()
    {
        if (!self::validate())
        {
            return;
        }

        $comment = R::dispense('posts');
        $comment->type_of = self::$type_of;
        $comment->forum = self::$forum;
        $comment->time_stamp = self::$time_stamp;
        $comment->parent_id = self::$post_id;
        $comment->user_id = self::$user_id;
        $comment->visibility = self::$visibility;
        $comment->identity = self::$identity;
        $comment->title = self::$title;
        $id = R::store($comment);

        if (self::$identity == 'pseudo')
        {
            $pseudo = 'registered';
            R::exec("INSERT INTO ironmask (id,pseudonym) VALUES ($id,'$pseudo')");
        }

        $votes = R::findAll('votes', "type_of IN ('positive','negative')");
        $medfact = R::findAll('medfact');
        $ironmask = R::findAll('ironmask');
        $users = R::findAll('users');

        parent::$engine->assign('post', $comment);
        parent::$engine->assign('votes', $votes);
        parent::$engine->assign('medfact', $medfact);
        parent::$engine->assign('ironmask', $ironmask);
        parent::$engine->assign('users', $users);
        parent::$engine->assign('vocab', 'comments');
        parent::$engine->display('views/widgets/post.tpl');
    }
}