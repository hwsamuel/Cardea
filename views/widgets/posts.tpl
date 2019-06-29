<table class="table table-striped">
<tbody>
{foreach from=$posts item=apost}
    <tr><td>
    {include file='widgets/post.tpl' post=$apost vocab=$vocab}
    <p id="{$vocab}-bookmark-{$apost.id}"></p>
    <div id="{$vocab}-comments-{$apost.id}" {if $vocab !== 'post' && (!isset($selcomment) || $selcomment != $apost.id)}class="collapse"{/if} style="padding-left: 35px;">
    {foreach from=$comments item=comment}
        {if $comment.parent_id == $apost.id}
            {include file='widgets/post.tpl' post=$comment vocab='comments'}
        {/if}
    {/foreach}
    {if isset($signed_in)}
    <p class="text-muted">
        <form method="POST" id="form-{$vocab}-comments-{$apost.id}">
            <textarea required maxlength="140" style="margin-bottom: 5px;" class="form-control input-sm" rows="1" name="new-{$vocab}-comment-{$apost.id}" id="new-{$vocab}-comment-{$apost.id}" placeholder="Add your comment"></textarea>
            <select required name="identity" name="new-{$vocab}-identity-{$apost.id}" id="new-{$vocab}-identity-{$apost.id}" class="form-inline input-sm" title="Post As">
                <option value="" disabled selected>Post As</option>
                <option value="self">Myself</option>
                <option value="pseudo">Pseudonym</option>
                <option value="anon">Anonymous</option>
            </select>
            <button type="button" onclick="return commentCreate({$apost.id},'{$vocab}','{$active}');" name="submit-{$vocab}-{$apost.id}" class="btn btn-sm btn-primary">Post</button>
        </form>
    </p>
    {/if}
    </div>
    </td></tr>
{foreachelse}
    <tr><td class="text-muted" style="margin-top: 10px;">No {$vocab} started yet</td></tr>
{/foreach}
</tbody>
</table>