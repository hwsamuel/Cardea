<?php

$ROUTES = 
[
	['/', 'GET', 'Forum::index'],
	['/comment_create', 'POST', 'Comment::create'],
	['/vote_create', 'POST', 'Vote::create'],
	['/vote_delete', 'POST', 'Vote::delete'],

	['/p2p', 'GET', 'Forum::p2p'],
	['/p2p', 'POST', 'Forum::p2p_form'],
	
	['/p2m', 'GET', 'Forum::p2m'],
	['/p2m', 'POST', 'Forum::p2m_form'],
	
	['/m2m', 'GET', 'Forum::m2m'],
	['/m2m', 'POST', 'Forum::m2m_form'],
	
	['/groups', 'GET', 'Forum::groups'],
	['/group/[a:forum]/[i:id]', 'GET', 'Forum::group'],

	['/search/[a:forum]/[*:keywords]', 'GET', 'Forum::search'],
	['/search_suggest', 'GET', 'Forum::search_suggest'],
	
	['/posts_suggest', 'GET', 'Forum::posts_suggest'],
	['/post/[i:id]/[a:forum]', 'GET', 'Forum::viewpost'],
	
	['/signin', 'GET', 'Auth::index'],
	['/signin', 'POST', 'Auth::login'],

	['/register', 'GET', 'Auth::register'],
	['/register', 'POST', 'Auth::provision'],

	['/confirm', 'GET', 'Auth::confirm'],
	['/passwordless', 'GET', 'Auth::passwordless'],

	['/signout', 'GET', 'Auth::logout']
];