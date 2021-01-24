<?php
// Processes that run separate of main web app

class Process
{
    // BubbleNet keywords and documents inverted indexer O(n^2)
    static function get_bubblenet()
    {
    	R::exec("DELETE FROM bubblenet");
        $posts = R::findAll('posts', "parent_id <> 'NULL'"); // Find all posts that are not placeholders
        foreach($posts as $post)
        {
            $keywords = trim(strtolower($post->title));
            preg_match_all('!https?://\S+!', $keywords, $matches); // Find hyperlinks
            
            foreach($matches as $match)
            {
                $keywords = str_replace($match, "", $keywords);
            }
            
            $keywords = preg_split('/\W+/', $keywords, -1, PREG_SPLIT_NO_EMPTY); // Word tokenization
            $post_id = $post->id;

            foreach($keywords as $keyword)
            {
            	$keyword = trim($keyword);
            	if (strlen($keyword) < 3) continue;
            	$exists = R::getCell("SELECT id FROM bubblenet WHERE keyword = '$keyword' AND post_id = $post_id");
            	if ($exists == NULL)
		        {
		            R::exec("INSERT INTO bubblenet(keyword,post_id) VALUES ('$keyword',$post_id)");
		        }
            }
        }
    }

    // Health Canada's RSS feed retriever
    // @todo Add cache
    static function get_newsfeed()
    {
        $rss = simplexml_load_file('https://www.healthycanadians.gc.ca/recall-alert-rappel-avis/rss/feed-32-eng.xml');
        $healthnews = array();
        foreach ($rss->channel->item as $item)
        {
           $healthnews[] = array('link' => $item->link, 'title' => $item->title);
        }
        shuffle($healthnews);
        return $healthnews;
    }

    // Health Canada's Healthy Canadians YouTube feed retriever
    // @todo Add cache
    static function get_video()
    {
        $rss = simplexml_load_file('https://www.youtube.com/feeds/videos.xml?user=HealthyCdns');
        $videos = array();
        foreach ($rss->entry as $item) 
        {
            $vid = str_replace("yt:video:", "", $item->id);
            $videos[] = array('title' => $item->title, 'vid' => $vid);
        }
        shuffle($videos);
        return $videos[0];
    }

    // @todo MedFact veracity evaluator for existing posts

    // @todo Iron Mask for updating privacy labels over time
}