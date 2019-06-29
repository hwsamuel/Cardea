<b>Suggested Keywords</b><br />
{foreach from=$results item=result}
	<a href="#" onclick="addKeyword('{$result.keyword}')">{$result.keyword}</a><br />
{foreachelse}
	<span class="text-muted">No search matches</span>
{/foreach}