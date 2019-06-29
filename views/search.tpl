{extends file="layout.forum.tpl"}

{block name=forum_content}
<br /><span style="font-size: 16pt;">Search Results for "{$search_terms}"</span> <a class="label label-default" href="/cardea/{$active}">Previous Page</a><br /><br />
{assign "group" ""}
{foreach from=$results item=result}
	{if $group != $result.type_of}
		<b style="font-size: 12pt;">{$result.type_of|capitalize}s</b>
		{if $result.type_of == 'question'}
			<span class="glyphicon glyphicon-question-sign"></span>
		{elseif $result.type_of == 'discussion'}
			<span class="glyphicon glyphicon-comment"></span>
		{elseif $result.type_of == 'blog'}
			<span class="glyphicon glyphicon-folder-close"></span>
		{elseif $result.type_of == 'chat'}
			<span class="glyphicon glyphicon glyphicon-phone-alt"></span>
		{/if}
		<br />
		{$group = $result.type_of}
	{/if}
	<span class="glyphicon glyphicon-chevron-right"></span> <a href="/cardea/post/{$result.id}/{$active}">{$result.title}</a><br />
	<span class="small">From the <a href="/cardea/group/{$result.forum}/{$result.parent_id}">{$groups[$result.parent_id]['title']}</a> support group</span><br /><br />
{foreachelse}
	<span class="text-muted">No search results</span>
{/foreach}
{/block}