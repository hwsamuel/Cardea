{extends file="layout.forum.tpl"}

{block name=forum_content}
<br /><span class="small text-muted">Viewing {$posts[0].type_of|capitalize} Thread</span> <a class="label label-default" href="/cardea/{$active}">Previous Page</a>
{include file='widgets/posts.tpl' post=$posts vocab=$vocab}
{/block}