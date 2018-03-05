<?php

class CForum
{
    static function index()
    {
        global $smarty;
        $smarty->assign('active', NULL);
        //$smarty->assign('display_name', 'Hamman');
        $smarty->display('views/index.tpl');
    }
    
    static function p2p()
    {
        global $smarty;
        $smarty->assign('active', 'p2p');
        $smarty->assign('display_name', 'Hamman');
        $smarty->display('views/forum.tpl');
    }
    
    static function p2m()
    {
        global $smarty;
        $smarty->assign('active', 'p2m');
        //$smarty->assign('display_name', 'Hamman');
        $smarty->display('views/forum.tpl');
    }
    
    static function m2m()
    {
        global $smarty;
        $smarty->assign('active', 'm2m');
        //$smarty->assign('display_name', 'Hamman');
        $smarty->display('views/forum.tpl');
    }
}
