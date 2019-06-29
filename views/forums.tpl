{extends file="layout.forum.tpl"}

{block name=forum_content}
<script>
    function reSort(val)
    {
        var selpostab = $('.nav-pills .active').text();
        alert(selpostab);
        $('#questions').html(val);
    }
</script>
<br />
{if isset($smarty.session.display_name)}
    {include file='widgets/status.tpl' forum=$active}
{/if}

<!-- Nav tabs -->
<ul class="nav nav-pills small" role="tablist">
    <li role="presentation" {if !isset($smarty.post.seltab) || (isset($smarty.post.seltab) && $smarty.post.seltab == 'question')}class="active"{/if}><a href="#questions" aria-controls="questions" role="tab" data-toggle="tab">Questions</a></li>
    <li role="presentation" {if isset($smarty.post.seltab) && $smarty.post.seltab == 'discussion'}class="active"{/if}><a href="#discussions" aria-controls="discussions" role="tab" data-toggle="tab">Discussions</a></li>
    {if $active!='p2m'}
        <li role="presentation" {if isset($smarty.post.seltab) && $smarty.post.seltab == 'blog'}class="active"{/if}><a href="#blogs" aria-controls="blogs" role="tab" data-toggle="tab">{if $active=='p2p'}Patient{elseif $active=='m2m'}Medic{/if} Blogs</a></li>
    {/if}
    {if $active=='p2m'}
        <li {if isset($smarty.post.seltab) && $smarty.post.seltab == 'chat'}class="active"{/if} role="presentation"><a href="#chats" aria-controls="chats" role="tab" data-toggle="tab">Patient-Medic Chats</a></li>
    {/if}
    <li class="pull-right">
         <select required name="identity" onchange="reSort(this.value)" class="form-control" title="Sort Posts">
            <option value="" disabled selected>Sort Posts</option>
            <option value="recent">Recent</option>
            <option value="votes">Votes</option>
            <option value="trust">Trust</option>
        </select>
    </li>
</ul>

<!-- Tab panes -->
<div class="tab-content">
    <div role="tabpanel" class="tab-pane {if !isset($smarty.post.seltab) || $smarty.post.seltab == 'question'}active{/if}" id="questions">
        {include file='widgets/posts.tpl' posts=$questions vocab='questions'}
    </div>

    <div role="tabpanel" class="tab-pane {if isset($smarty.post.seltab) && $smarty.post.seltab == 'discussion'}active{/if}" id="discussions">
        {include file='widgets/posts.tpl' posts=$discussions vocab='discussions'}
    </div>

    <div role="tabpanel" class="tab-pane {if isset($smarty.post.seltab) && $smarty.post.seltab == 'chat'}active{/if}" id="chats">
        {include file='widgets/posts.tpl' posts=$chats vocab='chats'}
    </div>
    
    <div role="tabpanel" class="tab-pane {if isset($smarty.post.seltab) && $smarty.post.seltab == 'blog'}active{/if}" id="blogs">
        {include file='widgets/posts.tpl' posts=$blogs vocab='blogs'}
    </div>
</div>
{/block}