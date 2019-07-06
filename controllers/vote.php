<?php

class Vote extends Forum
{
	private static $post_id;
    private static $type_of;
    private static $user_id;

    static private function validate()
    {
        $_POST = filter_input_array(INPUT_POST,
        [
            "post_id" => FILTER_VALIDATE_INT,
            "type_of" => FILTER_SANITIZE_STRING
        ]);
        self::$post_id = $_POST['post_id'];
        self::$type_of = trim($_POST['type_of']);
        self::$user_id = $_SESSION['display_name'];
        
        $post = R::load('posts', self::$post_id);
        
        $valid_post_id = $post->id !== 0;
        $valid_type_of = in_array(self::$type_of, array('positive','negative','spam','offensive','compromising'));
        
        if (!$valid_post_id || !$valid_type_of) 
        {
            return FALSE;
        }
        else
        {
            return TRUE;            
        }
    }

    // JavaScript: voteCreate() (/cardea/static/js/common.js)
    // Route: /cardea/vote_create (index.php)
    // Method: POST
    static function create()
    {
        $data = self::delete();
        
        $vote = R::dispense('votes');
        $vote->type_of = self::$type_of;
        $vote->post_id = self::$post_id;
        $vote->user_id = self::$user_id;
        R::store($vote);
    }

    // JavaScript: voteDelete() (/cardea/static/js/common.js)
    // Route: /cardea/vote_delete (index.php)
    // Method: POST
    static function delete()
    {
        if (!self::validate())
        {
            echo 'Invalid values detected, please try again';
            return;
        }

        $exists = R::getCell("SELECT id FROM votes WHERE post_id = " . self::$post_id . " AND user_id = " . self::$user_id);
        if ($exists != NULL)
        {
            R::exec("DELETE FROM votes WHERE id = $exists");
        }
    }
}