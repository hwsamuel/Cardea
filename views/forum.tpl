{extends file="template.tpl"}

{block name=content}
<div class="row">
    <div role="tabpanel" class="col-xs-3">
        <br />
        <form>
            <input type="text" class="input-sm col-xs-9" placeholder="Search..." autofocus />
            <button class="btn btn-sm btn-warning">Go</button><br />
            <a href="" class="small"><span class="glyphicon glyphicon-search"></span> Advanced Options</a>
        </form>
        <br />
        <span class="text-muted">Filter by Support Group</span>
        <div class="scrollholder">
            <a href=""><b>All</b></a><br>
            <a href="">General</a><br>
            <a href="">Cancer</a><br>
            <a href="">Diabetes</a><br>
            <a href="">Injury</a><br>
            <a href="">Obesity</a><br>
            <a href="">Mental Health</a><br />
            <a href="">Sexual Health</a><br />
        </div>
        <small><a href=""><span class="glyphicon glyphicon-plus"></span> Suggest Support Group</a></small>
        <br /><br />
        <span class="text-muted">Filter by Popular Keywords</span>
        <div style="border: 1px solid #CCC; padding: 5px;">
            <img src="/cardea/static/img/cloud.png" height="170px" />
        </div>
    </div>

    <div role="tabpanel" class="col-xs-6">
        <br />
        {include file='widgets/status.tpl' forum=$active}
  
        <!-- Nav tabs -->
        <ul class="nav nav-pills small" role="tablist">
            <li role="presentation" class="active"><a href="#questions" aria-controls="questions" role="tab" data-toggle="tab">Questions</a></li>
            <li role="presentation"><a href="#discussions" aria-controls="discussions" role="tab" data-toggle="tab">Discussions</a></li>
            {if $active!='p2m'}
                <li role="presentation"><a href="#blogs" aria-controls="blogs" role="tab" data-toggle="tab">{if $active=='p2p'}Patient{elseif $active=='m2m'}Medic{/if} Blogs</a></li>
            {/if}
            {if $active=='p2m'}
            <li class="pull-right" role="presentation"><a href="#chat" class="btn btn-warning btn-xs" aria-controls="chat" role="tab" data-toggle="tab"><span class="badge">P2M</span> Live Chat</a></li>
            {/if}
        </ul>

        <!-- Tab panes -->
        <div class="tab-content">
            <div role="tabpanel" class="tab-pane active" id="questions">
                <table class="table table-hover">
                    <tbody>
                        <tr>
                            <td>
                                <p>
                                    I seem to have lost my appetite a lot lately.  I have started taking VyVanse and I understand that can affect that.  I am losing a lot of weight.  What can I do to help this?  I can't see my doctor until the 23rd of this month as I'm home on spring break.  I am not really hungry at all hardly.
                                </p>
                                <p>
                                    <span class="text-bold">
                                        <a href=""><span class="glyphicon glyphicon-thumbs-up"></span> Like</a> <span class="badge">3</span><span class="space-right"></span>
                                        <a href=""><span class="glyphicon glyphicon-thumbs-down"></span> Dislike</a> <span class="badge">1</span><span class="space-right"></span>
                                    </span>
                                    <span class="pull-right">
                                        <a href=""><span class="glyphicon glyphicon-share-alt"></span> Answer</a><span class="space-right"></span>
                                        <a href=""><span class="glyphicon glyphicon-comment"></span> Comment</a><span class="space-right"></span>
                                        
                                    </span>
								</p>
                                <p class="small text-muted">
                                    Posted in the <a href="">Mental Health Support Group</a> by <a href="">Bhupinder</a> on Nov 11 2017 6:55pm
                                </p>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <p>
                                    Just wondering what the long term health effects are with a binge/restrict cycle???
                                </p>
                                <p>
                                    <span class="text-bold">
                                        <a href=""><span class="glyphicon glyphicon-thumbs-up"></span> Like</a> <span class="badge">0</span><span class="space-right"></span>
                                        <a href=""><span class="glyphicon glyphicon-thumbs-down"></span> Dislike</a> <span class="badge">0</span><span class="space-right"></span>
                                    </span>
                                    <span class="pull-right">
                                        <a href=""><span class="glyphicon glyphicon-share-alt"></span> Answer</a><span class="space-right"></span>
                                        <a href=""><span class="glyphicon glyphicon-comment"></span> Comment</a><span class="space-right"></span>
                                        
                                    </span>
								</p>
                                <p class="small text-muted">
                                    Posted in the <a href="">Obesity Support Group</a> by your <a href="">Connection</a> on Nov 11 2017 6:55pm
                                </p>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <p>
                                    Hi..Am a young women aged 22. Am a virgin. I hav missed my period due a week and I kind of feel a pain in my breast near the aerosol....though I hav quite ful boobs...Am confused by the pain. ..Wat kind of pain can it be?? Is it any symptom of breast cancer or sumthin??
                                </p>
                                <p>
                                    <span class="text-bold">
                                        <a href=""><span class="glyphicon glyphicon-thumbs-up"></span> Like</a> <span class="badge">1</span><span class="space-right"></span>
                                        <a href=""><span class="glyphicon glyphicon-thumbs-down"></span> Dislike</a> <span class="badge">0</span><span class="space-right"></span>
                                    </span>
                                    <span class="pull-right">
                                        <a href=""><span class="glyphicon glyphicon-share-alt"></span> Answer</a><span class="space-right"></span>
                                        <a href=""><span class="glyphicon glyphicon-comment"></span> Comment</a><span class="space-right"></span>
                                        
                                    </span>
								</p>
                                <p class="small text-muted">
                                    Posted in the <a href="">Cancer Support Group</a> by <a href="">Anonymous</a> on Nov 11 2017 6:55pm
                                </p>
                            </td>
                        </tr>
                    </tbody>
                </table>
            </div>
    
            <div role="tabpanel" class="tab-pane" id="blogs">
                <table class="table table-hover">
                    <tbody>
                        <tr>
                            <td>
                                <p>
                                    <b>Australian GPs Recognise Obesity As A Disease</b><br/ >
                                    Last week, the Royal Australian College of General Practice (RACGP) President, Dr Seidel recognised obesity as a disease. The RACGP is the first medical college in Australia to do so.
                                    This was exciting news given that we have just observed World Obesity Day a few days ago.
                                    According to the Australian Bureau of Statistics1, over 60% of Australian adults are classified as having overweight or obesity, and more than 25% of these have obesity [defined as a Body Mass Index (BMI) ≥30] (ABS2012). Similarly in 2007, around 25% of children aged 2–16 were identified as having overweight or obesity, with 6% classified as having obesity (DoHA 2008). These are alarming statistics.
                                </p>
                                <p>
                                    <span class="text-bold">
                                        <a href=""><span class="glyphicon glyphicon-thumbs-up"></span> Like</a> <span class="badge">2</span><span class="space-right"></span>
                                        <a href=""><span class="glyphicon glyphicon-thumbs-down"></span> Dislike</a> <span class="badge">1</span><span class="space-right"></span>
                                    </span>
                                    <span class="pull-right">
                                        <a href=""><span class="glyphicon glyphicon-comment"></span> Comment</a><span class="space-right"></span>
                                    </span>
								</p>
                                <p class="small text-muted">
                                    Posted by <a href="">Dr. Arya Sharma</a> in the <a href="">General Support Group</a> on Nov 11 2017 6:55pm
                                </p>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <p>
                                    <b>Vote of Thanks From The Obesity Chair</b><br/ >
                                    10 years ago, I was enticed to take up an endowed “Chair” in obesity research and management at the University of Alberta with the task to develop and lead the fledgling bariatric program at the Royal Alexandra Hospital.<br />
                                    The decision to move to the University of Alberta from a prestigious Tier 1 Canada Research Chair in obesity at McMaster University, where my research enterprise was moving along just fine, was largely prompted by the Ontario Government’s bumbling indecision (despite all of my considerable and enthusiastic advocacy efforts on behalf of my patients) about promoting much needed bariatric services in Ontario (as a side note, only six weeks after I had signed on with the University of Alberta, the Ontario government, after much to-and-froing, finally did announce substantial funding for a province-wide bariatric program, which continues to this date as the Ontario Bariatric Network).
                                </p>
                                <p>
                                    <span class="text-bold">
                                        <a href=""><span class="glyphicon glyphicon-thumbs-up"></span> Like</a> <span class="badge">1</span><span class="space-right"></span>
                                        <a href=""><span class="glyphicon glyphicon-thumbs-down"></span> Dislike</a> <span class="badge">2</span><span class="space-right"></span>
                                    </span>
                                    <span class="pull-right">
                                        <a href=""><span class="glyphicon glyphicon-comment"></span> Comment</a><span class="space-right"></span>
                                    </span>
								</p>
                                <p class="small text-muted">
                                    Posted by <a href="">Dr. Arya Sharma</a> in the <a href="">General Support Group</a> on Nov 11 2017 6:55pm
                                </p>
                            </td>
                        </tr>
                    </tbody>
                </table>
            </div>
    
            <div role="tabpanel" class="tab-pane" id="chat">
                <span class="text-danger">No medics are currently online, please check back later</span>
            </div>
            
            <div role="tabpanel" class="tab-pane" id="discussions">
                <table class="table table-hover">
                    <tbody>
                        <tr>
                            <td>
                                <p>
                                    <b>Study Shows How Memories Ripple Through the Brain</b><br/ >
                                    Using an innovative “NeuroGrid” technology, scientists showed that sleep boosts communication between two brain regions whose connection is critical for the formation of memories. The work, published in Science, was partially funded by the Brain Research through Advancing Innovative Neurotechnologies (BRAIN) Initiative, a project of the National Institutes of Health devoted to accelerating the development of new approaches to probing the workings of the brain.
                                </p>
                                <p>
                                    <span class="text-bold">
                                        <a href=""><span class="glyphicon glyphicon-thumbs-up"></span> Like</a> <span class="badge">7</span><span class="space-right"></span>
                                        <a href=""><span class="glyphicon glyphicon-thumbs-down"></span> Dislike</a> <span class="badge">0</span><span class="space-right"></span>
                                    </span>
                                    <span class="pull-right">
                                        <a href=""><span class="glyphicon glyphicon-comment"></span> Comment</a><span class="space-right"></span>
                                    </span>
								</p>
                                <p class="small text-muted">
                                    Posted by <a href="">Dr. Merosola</a> in the <a href="">General Support Group</a> on Nov 11 2017 6:55pm
                                </p>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <p>
                                    I started using DeeDee's essential oil prostate blend in August last year. I was getting up to go to the bathroom about 4 or 5 times per night. Now  I only get up about 1 or 2 times per night. I am 73 years old. I believe that the essential oils made the difference.
                                </p>
                                <p>
                                    <span class="text-bold">
                                        <a href=""><span class="glyphicon glyphicon-thumbs-up"></span> Like</a> <span class="badge">1</span><span class="space-right"></span>
                                        <a href=""><span class="glyphicon glyphicon-thumbs-down"></span> Dislike</a> <span class="badge">1</span><span class="space-right"></span>
                                    </span>
                                    <span class="pull-right">
                                        <a href=""><span class="glyphicon glyphicon-comment"></span> Comment</a><span class="space-right"></span>
                                    </span>
								</p>
                                <p class="small text-muted">
                                    Posted by <a href="">Anne Hathaway</a> in the <a href="">Injury Support Group</a> on Nov 11 2017 6:55pm
                                </p>
                            </td>
                        </tr>
                    </tbody>
                </table>
            </div>
        </div>
    </div>

    <div class="col-xs-3">
        <br />
        <p><span class="text-muted"><b>Health in the News</b></span></p>

        <span class="text-muted">MedlinePlus</span>
        <div class="feed">
            <p><a href="">Are Some Heartburn Meds Tied to Stomach Cancer?</a><br /><a class="label label-default">Discuss</a></p>

            <p><a href="">Speed Up the 'Cancer Moonshot,' Doctors Urge</a><br /><a class="label label-default">Discuss</a></p>

            <p><a href="">Taking Four or More Prescription Meds? Consider Scaling Back</a><br /><a class="label label-default">Discuss</a></p>

            <p><a href="">Study Shows How Memories Ripple Through the Brain</a><br /><a class="label label-default">Discuss</a></p>

            <p><a href="">Calquence Approved for Mantle Cell Lymphoma</a><br /><a class="label label-default">Discuss</a></p>
        </div>
        <small><a href=""><span class="glyphicon glyphicon-plus"></span> Suggest Health RSS Feed</a></small>
        <br /><br />
        
        <span class="text-muted">Health Canada</span>
        <iframe width="260" src="https://www.youtube-nocookie.com/embed/SZ4MPzG7ZyE?rel=0&amp;controls=0" frameborder="0" allowfullscreen></iframe>
        <br /><a class="label label-default">Discuss</a>
</div>
{/block}
