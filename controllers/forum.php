<?php
class Forum extends Core
{
    static function bubblenet($forum = NULL)
    {
        if ($forum !== NULL)
        {
            $cond = " AND forum = '$forum'";//WHERE post_id IN (SELECT id FROM posts WHERE forum = '$forum')";
        }
        else
        {
            $cond = '';
        }
        $results = R::getAll("SELECT type_of, keyword FROM bubblenet,posts WHERE posts.id = bubblenet.post_id $cond LIMIT 10");
        return $results;
    }

    static function clean_str($keywords)
    {
        preg_match_all('!https?://\S+!', $keywords, $matches);
        foreach($matches as $match)
        {
            $keywords = str_replace($match, "", $keywords);
        }
        $keywords = preg_split('/\W+/', strtolower($keywords), -1, PREG_SPLIT_NO_EMPTY);
        return $keywords;
    }

    static function search_filter($keywords)
    {
        $keywords = self::clean_str($keywords);
        $keywords = array_unique($keywords);
        $words_list = "";
        foreach($keywords as $keyword)
        {
            $keyword = trim($keyword);
            $words_list .= " title Like '%$keyword%' OR";
        }
        $words_list = substr($words_list, 0, -3);
        return $words_list;
    }

    static function search($forum,$keywords)
    {
        if (strlen($keywords) < 3)
        {
            $results = NULL;
        }
        else
        {
            $words_list = self::search_filter($keywords);
            $results = R::findAll('posts', "($words_list) AND type_of IN ('question','discussion','blog','chat') AND forum = '$forum' ORDER BY type_of");
        }
        self::$engine->assign('results',$results);
        self::$engine->assign('active',$forum);
        self::$engine->assign('search_terms',str_replace("%20", " ", $keywords));
        self::$engine->assign('bubblewords', self::bubblenet($forum));
        self::$engine->display('views/search.tpl');
    }

    static function group($forum, $id)
    {
        self::$engine->assign('selgroup', $id);
        if ($forum == 'p2p')
        {
            self::p2p($id);
        }
        elseif ($forum == 'p2m')
        {
            self::p2m($id);
        }
        elseif ($forum == 'm2m')
        {
            self::m2m($id);
        }
        else
        {
            return;
        }
    }

    static function search_suggest()
    {
        $forum = $_GET['forum'];
        $keywords = $_GET['keyword'];
        $keywords = self::clean_str($keywords);
        $keyword = trim(array_pop($keywords));
        $results = array();
        if (strlen($keyword) < 3) return;
        
        $results = R::getAll("SELECT DISTINCT keyword FROM bubblenet WHERE post_id IN (SELECT id FROM posts WHERE forum = '$forum' AND type_of IN ('question','discussion','blog','chat')) AND keyword Like '%$keyword%'");
        
        if (count($results) == 0) return;
        self::$engine->assign('results',$results);
        self::$engine->display('views/widgets/suggest.tpl');
    }

    static function posts_suggest()
    {
        $forum = $_GET['forum'];
        $keywords = $_GET['keyword'];
        $type_of = $_GET['seltab'];

        if (strlen($keywords) < 3) return;

        $words_list = self::search_filter($keywords);
        $results = R::findAll('posts', "($words_list) AND type_of = '$type_of' AND forum = '$forum'");

        if (count($results) == 0) return;
        self::$engine->assign('results',$results);
        self::$engine->display('views/widgets/similar.tpl');
    }

    static function viewpost($id,$forum)
    {
        $post = R::load('posts', $id);
        $post = self::get_preview($post);
        
        $votes = R::findAll('votes', "type_of IN ('positive','negative')");
        $medfact = R::findAll('medfact');
        $ironmask = R::findAll('ironmask');
        $users = R::findAll('users');
        $comments = R::findAll('posts', "type_of = 'comment' AND parent_id = $id AND is_blocked = 0 ORDER BY time_stamp DESC");
        foreach($comments as $comment)
        {
            $comment = self::get_preview($comment);
        }
        
        self::$engine->assign('comments', $comments);
        self::$engine->assign('posts', array($post));
        self::$engine->assign('votes', $votes);
        self::$engine->assign('medfact', $medfact);
        self::$engine->assign('ironmask', $ironmask);
        self::$engine->assign('users', $users);
        self::$engine->assign('vocab', 'post');
        self::$engine->assign('active', $forum);
        self::$engine->assign('bubblewords', self::bubblenet($forum));
        self::$engine->display('views/post.tpl');
    }

    static function index()
    {
        if (isset($_SESSION['display_name'])) header('Location: /cardea/p2p');
        self::$engine->assign('active', NULL);
        self::$engine->display('views/home.tpl');
    }

    static function get_subset($posts, $type)
    {
        $subset = array();
        foreach ($posts as $post)
        {
            if ($post['type_of'] == $type)
            {
                $subset[] = $post;
            }
        }
        return $subset;
    }

    // Adapted from https://www.namepros.com/threads/php-simple-bbcode-parse-function.266965/
    static function parse_bbcode($body) 
    {
        $find = array(
            "@\n@",
            "/\[\*\]/",
            "/\[url\=(.+?)\](.+?)\[\/url\]/is",
            "/\[b\](.+?)\[\/b\]/is", 
            "/\[i\](.+?)\[\/i\]/is", 
            "/\[u\](.+?)\[\/u\]/is", 
            "/\[img\](.+?)\[\/img\]/is",
            "/\[list\](.+?)\[\/list\]/is"
        );

        $replace = array(
            "<br />",
            "<span style=\"padding-left: 15px; padding-right: 5px;\">&bull;</span>",
            "<a href=\"$1\" target=\"_blank\">$2</a>",
            "<strong>$1</strong>",
            "<em>$1</em>",
            "<span style=\"text-decoration:underline;\">$1</span>",
            "<img src=\"$1\" alt=\"Image\" width='200px' />",
            "$1"
        );
        $body = htmlspecialchars($body);
        $body = preg_replace($find, $replace, $body);
        return $body;
    }

    static function get_preview($post)
    {
        $keywords = $post->title.$post->content;
        $pattern = "%https?://\S+\]?\[?%"; // Accounts for BBCode formatting
        preg_match_all($pattern, $keywords, $matches); // Find hyperlinks
        $match = $matches[0];
        if (sizeof($match) <= 0) 
        {
            $previewer = NULL;
        }
        else
        {
            $previewer = $match[0];
            
            $pos = strpos($previewer, ']');
            $pos = $pos === FALSE ? strlen($previewer) : $pos;
            $previewer = substr($previewer, 0, $pos);

            $pos = strpos($previewer, '[');
            $pos = $pos === FALSE ? strlen($previewer) : $pos;
            $previewer = substr($previewer, 0, $pos);
        }
        $post->previewer = $previewer;
        $post->content = self::parse_bbcode($post->content);

        return $post;
    }

    static function get_data($forum, $group = NULL)
    {
        if ($group !== NULL)
        {
            $group_filter = "AND parent_id = $group";
        }
        else
        {
            $group_filter = "AND TRUE";
        }

        $posts = R::findAll('posts', "forum = '$forum' AND is_blocked = 0 $group_filter ORDER BY time_stamp DESC");
        
        foreach($posts as $post)
        {  
            $post = self::get_preview($post);
        }

        $questions = self::get_subset($posts, 'question'); //R::findAll('posts', "forum = '$forum' AND type_of = 'question' AND is_blocked = 0 $group_filter ORDER BY time_stamp DESC");
        $discussions = self::get_subset($posts, 'discussion'); //R::findAll('posts', "forum = '$forum' AND type_of = 'discussion' AND is_blocked = 0 $group_filter ORDER BY time_stamp DESC");
        $blogs = self::get_subset($posts, 'blog'); //R::findAll('posts', "forum = '$forum' AND type_of = 'blog' AND is_blocked = 0 $group_filter ORDER BY time_stamp DESC");
        $chats = self::get_subset($posts, 'chat'); //R::findAll('posts', "forum = 'p2m' AND type_of = 'chat' AND is_blocked = 0 $group_filter ORDER BY time_stamp DESC");
        $comments = self::get_subset($posts, 'comment'); //R::findAll('posts', "forum = '$forum' AND type_of = 'comment' AND is_blocked = 0 ORDER BY time_stamp DESC");
        
        $votes = R::findAll('votes', "type_of IN ('positive','negative')");
        $medfact = R::findAll('medfact');
        $ironmask = R::findAll('ironmask');
        $users = R::findAll('users');

        self::$engine->assign('questions', $questions);
        self::$engine->assign('discussions', $discussions);
        self::$engine->assign('blogs', $blogs);
        self::$engine->assign('chats', $chats);
        self::$engine->assign('comments', $comments);
        self::$engine->assign('votes', $votes);
        self::$engine->assign('medfact', $medfact);
        self::$engine->assign('ironmask', $ironmask);
        self::$engine->assign('users', $users);
        self::$engine->assign('active', $forum);
    }

    static function set_data($forum)
    {
        $_POST = filter_input_array(INPUT_POST, FILTER_SANITIZE_STRING);
        $type_of = $_POST['seltab'];
        $parent_id = $_POST['group'];
        $user_id = $_SESSION['display_name'];
        $visibility = $_POST['privacy'];
        $identity = $_POST['identity'];
        $content = '';

        if ($type_of == 'question')
        {
            $title = $_POST['questiontext'];
        }
        elseif ($type_of == 'discussion') 
        {
            $title = $_POST['discusstext'];
        }
        elseif ($type_of == 'blog') 
        {
            $title = $_POST['blogtitle'];
            $content = $_POST['blogtext'];
            if (trim($content) === '' || strlen($content) < 20) return -1;
        }
        elseif ($type_of == 'chat') 
        {
            $title = $_POST['chattext'];
        }
        else
        {
            return;
        }
        if (trim($title) === '') return -1;

        if (strlen($title) < 20) return -1;

        $post = R::dispense('posts');
        $post->type_of = $type_of;
        $post->forum = $forum;
        $post->parent_id = $parent_id;
        $post->user_id = $user_id;
        $post->visibility = $visibility;
        $post->identity = $identity;
        $post->content = $content;
        $post->title = $title;
        $id = R::store($post);

        if ($identity == 'pseudo')
        {
            $pseudo = 'registered';
            R::exec("INSERT INTO ironmask (id,pseudonym) VALUES ($id,'$pseudo')");
        }
    }

    static function p2p($group = NULL)
    {
        // @todo Check user type, if Medic, then can only view public posts here

        // If logged in
        // IF patient
        // Get public posts + registered posts + patient posts + connections posts
        // IF not patient
        // Get public posts + registered posts + connections posts
        // if not logged in
        // Get public posts
        
        self::get_data('p2p', $group);
        self::$engine->assign('bubblewords', self::bubblenet('p2p'));
        self::$engine->display('views/forums.tpl');
    }

    static function p2p_form()
    {
        $ret = self::set_data('p2p');
        if ($ret == -1) self::$engine->assign('errors', 'Invalid text entered, please try again');
        self::p2p();
    }
    
    static function p2m($group = NULL)
    {
        self::get_data('p2m', $group);
        self::$engine->assign('bubblewords', self::bubblenet('p2m'));
        self::$engine->display('views/forums.tpl');
    }
    
    static function p2m_form()
    {
        $ret = self::set_data('p2m');
        if ($ret == -1) self::$engine->assign('errors', 'Invalid text entered, please try again');
        self::p2m();
    }
    
    static function m2m($group = NULL)
    {
        self::get_data('m2m', $group);
        self::$engine->assign('bubblewords', self::bubblenet('m2m'));
        self::$engine->display('views/forums.tpl');
    }

    static function m2m_form()
    {
        $ret = self::set_data('m2m');
        if ($ret == -1) self::$engine->assign('errors', 'Invalid text entered, please try again');
        self::m2m();
    }
    
    static function groups()
    {
        self::$engine->assign('active', 'groups');
        self::$engine->display('views/groups.tpl');   
    }
}
