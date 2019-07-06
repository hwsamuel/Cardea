<script>
    function selTab(tab)
    {
        $("#seltab").val(tab);
        $("#suggest-results").hide();
    }
</script>

<style>
    #suggest-results
    {
        border: 1px solid #CCC;
        border-top: 2px solid #FAA;
        background: #EEE;
        width: 555px;
        top: 175px;
        font-size: 12px;
        display: none;
        position: fixed;
        z-index:99;
        padding: 5px;
        max-height: 200px;
        min-height: 125px;
        overflow-y: auto;
    }
</style>

<form method="POST" action="/cardea/{$forum}">
    {if isset($errors)}
    <div class="alert alert-danger" role="alert">
        {$errors}
        <a href="#" class="close pull-right" data-dismiss="alert" aria-label="close">&times;</a>
    </div>
    {/if}
    <ul class="nav nav-tabs">
        <li {if !isset($smarty.post.seltab) || $smarty.post.seltab == 'question'}class="active"{/if}><a id='form-question-tab' onclick="selTab('question');" data-toggle="tab" href="#question-form">Ask</a></li>
        <li {if isset($smarty.post.seltab) && $smarty.post.seltab == 'discussion'}class="active"{/if}><a data-toggle="tab" id='form-discussion-tab' onclick="selTab('discussion');" href="#discussion-form">Discuss</a></li>
        {if $forum!='p2m'}<li {if isset($smarty.post.seltab) && $smarty.post.seltab == 'blog'}class="active"{/if}><a id='form-blog-tab' onclick="selTab('blog');" data-toggle="tab" href="#blog-form">Blog</a></li>{/if}
        {if $forum=='p2m' || $forum == ''}<li {if isset($smarty.post.seltab) && $smarty.post.seltab == 'chat'}class="active"{/if}><a onclick="selTab('chat');" id='form-chat-tab' data-toggle="tab" href="#chat-form">Chat</a></li>{/if}
        <li class="pull-right"><a href="#" class="small" data-toggle="modal" data-target="#postHelp"><span class="glyphicon glyphicon-question-sign"></span> Help</a></li>
    </ul>
  
    <div class="tab-content">
        <div class="tab-pane {if !isset($smarty.post.seltab) || $smarty.post.seltab == 'question'}active{/if}" id="question-form">
            <textarea autocomplete="off" maxlength="420" {if $forum == ''}onkeypress="return false;"{/if} class="postbox form-control input-lg" rows="3" name="questiontext" placeholder="Have a question?"></textarea>
        </div>
        <div class="tab-pane {if isset($smarty.post.seltab) && $smarty.post.seltab == 'discussion'}active{/if}" id="discussion-form">
            <textarea autocomplete="off" maxlength="420" {if $forum == ''}onkeypress="return false;"{/if} class="postbox form-control input-lg" rows="3" name="discusstext" placeholder="What's on your mind?"></textarea>
        </div>
        <div class="tab-pane {if isset($smarty.post.seltab) && $smarty.post.seltab == 'blog'}active{/if}" id="blog-form">
            <textarea autocomplete="off" maxlength="420" {if $forum == ''}onkeypress="return false;"{/if} class="postbox form-control input-xs" name="blogtitle" id="blogtitle" placeholder="Give it a title"></textarea>
            <textarea autocomplete="off" maxlength="1000" {if $forum == ''}onkeypress="return false;"{/if} class="form-control input-xs" name="blogtext" id="blogtext" placeholder="Full details here"></textarea>
        </div>
        <div class="tab-pane {if isset($smarty.post.seltab) && $smarty.post.seltab == 'chat'}active{/if}" id="chat-form">
            <textarea autocomplete="off" maxlength="420" {if $forum == ''}onkeypress="return false;"{/if} class="postbox form-control input-lg" rows="3" name="chattext" placeholder="Talk with medics"></textarea>
        </div>
        <input type="hidden" id="seltab" name="seltab" value="question" />
        <div id="suggest-results" class="text-muted">
            <a href="#" onclick="$('#suggest-results').hide();"><span class="glyphicon glyphicon-remove pull-right"></span></a>
            <span id="suggest-matches"></span>
        </div>
    </div>
      
    <div class="well well-sm text-right">
        {if ($forum == '')}
            <select required name="forum" class="selectpicker show-tick box-sm" title="Forum" onchange="updatePrivacy(this.value);">
                <option value="p2p" data-subtext="Patient to Patient">P2P</option>
                <option value="p2m" data-subtext="Patient to Medic">P2M</option>
                <option value="m2m" data-subtext="Medic to Medic">M2M</option>
            </select>
        {/if}
        
        <select required name="identity" class="selectpicker show-tick box-sm" title="Post As">
            <option value="self" data-subtext="e.g. Posted by {if isset($display_name)}{$display_name}{else}John Smith{/if}" {if isset($smarty.post.identity) && $smarty.post.identity == 'self'}selected="selected"{/if}>Myself</option>
            <option value="pseudo" data-subtext="e.g. Posted by a Medic">Pseudonym</option>
            <option value="anon" data-subtext="e.g. Posted by Anonymous">Anonymous</option>
        </select>
        
        <select required name="privacy" id="privacy" class="selectpicker show-tick box-sm" title="Privacy">
            <option value="public">Public</option>
            <option value="registered">Registered</option>
            {if $forum=='m2m' || $forum == 'p2m' || $forum==''}
                <option id='priv-med' value="medics">Medics</option>
            {/if}
            {if $forum=='p2p' || $forum==''}
                <option id='priv-pat' value="patients">Patients</option>
            {/if}
            {if $forum!='p2m'}
                <option value="connections">Connections</option>
            {/if}
        </select>

        <select required name="group" class="selectpicker show-tick box-md" data-live-search="true" title="Support Group" data-selected-text-format="count" data-size="5" id="topic">
            {foreach from=$groups item=grp}
                <option value="{$grp.id}" {if isset($selgroup) && $selgroup == $grp.id}selected{/if}>{$grp.title}</option>
            {/foreach}
        </select>
        
        {if $forum == ''}
            <a href="/cardea/p2p" class="btn btn-sm btn-info">View Posts</a>
        {else}
            <input type="submit" name="submit" value="Post" class="btn btn-sm btn-primary">
        {/if}
    </div>                             
</form>

<div id="postHelp" class="modal" role="dialog">
    <div class="modal-dialog" style="width:400px;">
    <div class="modal-content">
        <div class="modal-header">
            <button type="button" class="close" data-dismiss="modal">&times;</button>
            <b class="modal-title"><span class="glyphicon glyphicon-question-sign"></span> Help</b>
        </div>
        <div class="modal-body">
            <p><b>Post As</b> &nbsp; 
            Control how your identity is shown on the post</p>
            <span class="btn btn-default btn-xs">Myself</span> Show your registered account's display name<br />
            <span class="btn btn-default btn-xs">Pseudonym</span> System gives you a trusted pseudonym<br />
            <span class="btn btn-default btn-xs">Anonymous</span> Everything about your identity is hidden<br />
            
            <br />
            <p><b>Privacy</b> &nbsp; 
            Control who can view and reply to your post</p>
            <span class="btn btn-default btn-xs">Public</span> Anyone on the Internet who sees this website<br />
            <span class="btn btn-default btn-xs">Registered</span> Only users with a registered acccount here<br />
            {if $forum=='p2p' || $forum == ''}
                <span class="btn btn-default btn-xs">Patients</span> Only other registered patients can see the post<br />
            {/if}
            {if $forum=='m2m' || $forum == 'p2m' || $forum == ''}
                <span class="btn btn-default btn-xs">Medics</span> Only other registered medics can see the post<br />
            {/if}
            {if $forum!='p2m'}
                <span class="btn btn-default btn-xs">Connections</span> Only users you approved as connections<br />
            {/if}
            
            <br />
            <p><b>Support Group</b> &nbsp; 
            Tag a topic for grouping conversations
            
            <br />
            <p><b>Conversation Flavors</b> &nbsp; 
            Communicate the way you need
            </p>
            <span class="btn btn-default btn-xs">Ask</span> Post questions, get replies and choose an answer<br />
            <span class="btn btn-default btn-xs">Discuss</span> Share your thoughts and opinions with others<br />
            {if $forum!='p2m'}
                <span class="btn btn-default btn-xs">Blog</span> Write an online journal about your experiences<br />
            {/if}
            {if $forum=='p2m' || $forum == ''}
                <span class="btn btn-default btn-xs">Chat</span> Patients join a live chat room to talk with medics<br />
            {/if}
        </div>
        <div class="modal-footer">
            <button type="button" class="btn btn-primary btn-sm" data-dismiss="modal">Close</button>
        </div>
    </div>
    </div>
</div>

<script src="/cardea/static/ckeditor/ckeditor.js"></script>

<script>
    CKEDITOR.replace('blogtext',{
        extraPlugins: 'bbcode',
        toolbar: [
            ['Bold', 'Italic', 'Strike'],
            ['Link', 'Unlink'],
            ['NumberedList', 'BulletedList', '-', 'Blockquote']
        ]
    });
    
    $('.postbox').bind("keyup", null, function(event) {
        if (event.keyCode == 27 || event.keyCode == 8) 
        {
            document.getElementById("suggest-results").style.display = 'none';
            return;
        }
        if (this.value.trim().length < 3) return;
        if (this.value.trim().length == 0) {
            document.getElementById("suggest-matches").innerHTML = "";
            document.getElementById("suggest-results").style.display = 'none';
            return;
        }

        $.get('/cardea/posts_suggest',
        {
            keyword: this.value.trim(),
            forum: '{$active}',
            seltab: $("#seltab").val()
        },
        function(data, status)
        {
            if (status == 'success')
            {
                if (data == '') return;
                document.getElementById("suggest-results").style.display = 'block';
                document.getElementById("suggest-matches").innerHTML = data;
            }
            else
            {
                alert(data);
            }
        });
    });
</script>