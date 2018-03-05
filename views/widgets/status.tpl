<form>
    <ul class="nav nav-tabs">
        <li class="active"><a data-toggle="tab" href="#question">Question</a></li>
        <li><a data-toggle="tab" href="#discussion">Blurb</a></li>
        {if $forum!='p2m'}<li><a data-toggle="tab" href="#blog">Journal</a></li>{/if}
        <li class="pull-right"><a href="#" class="small" data-toggle="modal" data-target="#postHelp"><span class="glyphicon glyphicon-question-sign"></span> Help</a></li>
    </ul>

    <div class="tab-content">
        <div class="tab-pane active" id="question">
            <textarea class="form-control input-lg" rows="1" placeholder="Have a question?"></textarea>
        </div>
        <div class="tab-pane" id="discussion">
            <textarea class="form-control input-lg" rows="1" placeholder="Share your thoughts"></textarea>
        </div>
        <div class="tab-pane" id="blog">
            <input type="text" placeholder="Short summary here" class="form-control input-md" />
            <textarea class="form-control input-md" rows="3" placeholder="Details about your experiences here"></textarea>

        </div>
    </div>

    <div class="well well-sm text-right">
        {if isset($forum) && $forum==''}
        <select required="true" class="selectpicker show-tick box-sm" title="Forum">
            <option value="1" data-subtext="Patient to Patient">P2P</option>
            <option value="2" data-subtext="Patient to Medic">P2M</option>
            <option value="3" data-subtext="Medic to Medic">M2M</option>
        </select>
        {/if}

        <select required="true" class="selectpicker show-tick box-sm" title="Post As">
            <option value="1" data-subtext="e.g. Posted by {if isset($display_name)}{$display_name}{else}John Smith{/if}">Myself</option>
            <option value="2" data-subtext="e.g. Posted by a Medic">Pseudonym</option>
            <option value="3" data-subtext="e.g. Posted by Anonymous">Anonymous</option>
        </select>

        <select required="true" class="selectpicker show-tick box-sm" title="Privacy">
            <option value="1">Public</option>
            <option value="2">Registered</option>
            {if isset($forum)}
                {if $forum=='m2m'}
                    <option value="2">Medics</option>
                {elseif $forum=='p2p'}
                    <option value="2">Patients</option>
                {/if}
            {/if}
            <option value="3">Connections</option>
        </select>

        <select required="true" class="selectpicker show-tick box-md" data-live-search="true" title="Support Group" data-selected-text-format="count" data-size="5" id="topic">
            <option value="1">General</option>
            <option value="2">Cancer</option>
            <option value="3">Diabetes</option>
            <option value="4">Injury</option>
            <option value="5">Obesity</option>
            <option value="6">Mental Health</option>
            <option value="6">Sexual Health</option>
        </select>

        <input type="submit" name="submit" value="Post" class="btn btn-sm btn-primary">
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
            {if isset($forum)}
                {if $forum=='p2p'}
                    <span class="btn btn-default btn-xs">Patients</span> Only other registered patients can see the post<br />
                {elseif $forum=='m2m'}
                    <span class="btn btn-default btn-xs">Medics</span> Only other registered medics can see the post<br />
                {/if}
            {/if}
            <span class="btn btn-default btn-xs">Connections</span> Only users you approved as connections<br />

            <br />
            <p><b>Support Group</b> &nbsp;
            Tag a topic for grouping conversations

            <br />
            <p><b>Conversation Flavors</b> &nbsp;
            Communicate the way you need
            </p>
            <span class="btn btn-default btn-xs">Ask</span> Post questions, get replies and choose an answer<br />
            <span class="btn btn-default btn-xs">Discuss</span> Share your thoughts and opinions with others<br />
            {if isset($forum) && $forum=='p2m'}
                <span class="btn btn-default btn-xs">Chat</span> Join a live chat room and talk real-time with others<br />
            {else}
                <span class="btn btn-default btn-xs">Blog</span> Write an online journal about your experiences<br />
            {/if}
        </div>
        <div class="modal-footer">
            <button type="button" class="btn btn-primary btn-sm" data-dismiss="modal">Close</button>
        </div>
    </div>
    </div>
</div>
