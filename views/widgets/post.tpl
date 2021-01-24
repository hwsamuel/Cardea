{assign "mask" "Unknown"}
{assign "profile_url" ""}
{if $post.identity == 'self'}
    {$mask = $users[$post.user_id]['display_name']}
    {$profile_url = "href='{$base_url}/users/{$post.user_id}'"}
{/if}
{if $post.identity == 'pseudo'}
    {$mask = $ironmask[$post.id]['pseudonym']}
    {if $mask == 'registered'}
        {$mask = 'Anonymous Registered User'}
    {elseif $mask == 'patient'}
        {$mask = 'Anonymous Patient'}
    {elseif $mask == 'medic'}
        {$mask = 'Anonymous Medic'}
    {elseif $mask == 'connection' && isset($smarty.session.cardea)}
        {$mask = 'Your Anonymous Connection'}
    {else}
        {$mask = 'Anonymous'}
    {/if}
{/if}
{if $post.identity == 'anon'}
    {$mask = 'Anonymous'}
{/if}

{assign "veracity" ""}
{assign "label" "primary"}
{if isset($medfact[$post.id])}
    {$veracity = $medfact[$post.id]['veracity']}
    {$confidence = $medfact[$post.id]['confidence']}
    {if $veracity <= 0.3 && $confidence >= 0.5}
        {$label = 'danger'}
    {elseif $veracity > 0.6 && $confidence >= 0.5}
        {$label = 'success'}
    {else}
        {$label = 'warning'}
    {/if}
    {$veracity = ($veracity*100)|ceil|string_format:"%d%%"}
{/if}

<table width="100%">
<tr>
    <td style="text-align: justify; padding-top: 10px;" {if $vocab == 'comments'}class="small"{/if}>
        <a style="margin-right: 10px; float: left;" class="small" {$profile_url}>
            <img alt="{$mask}" src="{$base_url}/static/identicon/index.php?text={$mask|md5}" />
        </a>
        {if $post.type_of == 'discussion' || $post.type_of == 'comment' || $post.type_of == 'answer'}
            <a href="{$base_url}/post/{$post.id}/{$active}">{$post.content|truncate:200:"..."}</a>
        {else if $vocab !== 'post' && $vocab !== 'comments'}
            <a href="{$base_url}/post/{$post.id}/{$active}"><b>{$post.title}</b></a>
        {else}
            <b>{$post.title}</b>
        {/if}
        {if $post.previewer != NULL}
            <br /><a href="{$post.previewer}" class="preview-thumb" target="_blank"><img src="//image.thum.io/get/width/450/crop/400/{$post.previewer}" /></a>
        {/if}
        {if $vocab == 'post'}<br /><span id="{$vocab}-content-{$post.id}">{$post.content}</span>{/if}
    </td>
</tr>
<tr>
    <td class="small" style="padding-top: 5px;">
    <span class="text-bold">
        {assign "pos" 0}
        {assign "neg" 0}
        {assign "poslabel" "like"}
        {assign "neglabel" "dislike"}
        {foreach from=$votes item=vote}
            {if ($vote.post_id == $post.id)}
                {if isset($smarty.session.cardea) && $vote.user_id == $smarty.session.cardea}
                    {if ($vote.type_of == 'positive')}
                        {$poslabel = "liked"}
                    {elseif ($vote.type_of == 'negative')}
                        {$neglabel = "disliked"}
                    {/if}
                {/if}
                {if ($vote.type_of == 'positive')}
                    {$pos = $pos+1}
                {/if}
                {if ($vote.type_of == 'negative')}
                    {$neg = $neg+1}
                {/if}
            {/if}
        {/foreach}
        
        {assign "responsecount" 0}
        {if $vocab != 'comments'}
        {foreach from=$comments item=comment}
            {if ($comment.parent_id == $post.id)}
                {$responsecount = $responsecount+1}
            {/if}
        {/foreach}
        {/if}
        
        <a class="votes" {if isset($smarty.session.cardea)}style="cursor: pointer;" onclick="voteProcess('{$post.id}','positive');"{/if}><span class="glyphicon glyphicon-thumbs-up"></span> <span id="like-label-{$post.id}">{$poslabel|capitalize}</span></a> <span id="like-counter-{$post.id}" class="badge alert-info">{$pos}</span><span class="space-right"></span>
        
        <a class="votes text-danger" {if isset($smarty.session.cardea)}style="cursor: pointer;" onclick="voteProcess('{$post.id}','negative');"{/if}><span class="glyphicon glyphicon-thumbs-down text-danger"></span> <span id="dislike-label-{$post.id}">{$neglabel|capitalize}</span></a> <span id="dislike-counter-{$post.id}" class="badge alert-danger">{$neg}</span><span class="space-right"></span>
    </span>
    {if $vocab != 'comments'}
    <span>
        <a style="text-decoration:none; font-weight: bold;" href="#{$vocab}-comments-{$post.id}" data-toggle="collapse">Replies <span class="badge label-primary" id="{$post.id}-responses-count">{$responsecount}</span></a><span class="space-right"></span>
    </span>
    {/if}
    {if $veracity !== ''}<a href="#"><b>Trust Score</b> <span class="badge progress-bar-{$label}">{$veracity}</span></a>{/if}
    <br />
    <span class="text-muted">
        Posted by <a {$profile_url}>{$mask}</a> {if $vocab != 'comments'}in the <a href="{$base_url}/group/{$post.forum}/{$post.parent_id}">{$groups[$post.parent_id]['title']}</a> support group {/if}on {$post.time_stamp|date_format:"%b %e, %Y at %I:%M %p"}
    </span>
    </td>
</tr>
</table>