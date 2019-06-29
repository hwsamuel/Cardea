{extends file="layout.forum.tpl"}

{block name=forum_content}
<br />
{foreach from=$groups item=group}
    <p>
    	<a href="/cardea/group/{$group.id}"><b>{$group.title}</b></a><br />
    	<small>{$group.content}</small>
    </p>
{/foreach}
{/block}
