// References: /cardea/views/widgets/posts.tpl
function commentCreate(post_id,vocab,forum) 
{
    $.post('/cardea/comment_create', // Reference: /cardea/controllers/comment.php
    {
        post_id: post_id,
        title: $('#new-'+vocab+'-comment-'+post_id).val(),
        identity: $('#new-'+vocab+'-identity-'+post_id).val(),
        forum: forum
    },
    function(data, status)
    {
        var container = '#'+vocab+'-comments-'+post_id;
        if (status != 'success')
        {
            alert(data);
        }
        else if (data == '')
        {
            var msg = "<div class='small alert alert-danger' role='alert'>Invalid text or selection, please try again <a href='#' class='close pull-right' data-dismiss='alert' aria-label='close'>&times;</a></div>"
            $(container).html($(container).html()+msg);
        }
        else
        {
            $(container).html(data+$(container).html());
            var resp_contain = '#'+post_id+'-responses-count';
            var cnt = Number($(resp_contain).html());
            $(resp_contain).html(cnt+1);
        }
    });
}

// References: /cardea/views/widgets/post.tpl
function voteProcess(post_id,type_of,forum)
{
    var lblval = '';
    var presentlbl = '';
    var pastlbl = '';

    if (type_of == 'positive')
    {
        lblval = $('#like-label-'+post_id).html().toLowerCase();
        presentlbl = 'like';
        pastlbl = 'liked';
    }
    else if (type_of == 'negative')
    {
        lblval = $('#dislike-label-'+post_id).html().toLowerCase();
        presentlbl = 'dislike';
        pastlbl = 'disliked';
    }

    if (lblval == presentlbl)
    {
        voteCreate(post_id,type_of,forum); 
    }
    else if (lblval == pastlbl)
    { 
        voteDelete(post_id,type_of);
    }
}

function voteCreate(post_id,type_of) 
{
    $.post('/cardea/vote_create', // Reference: /cardea/controllers/vote.php
    {
        post_id: post_id,
        type_of: type_of
    },
    function(data, status)
    {
        if (status != 'success' || data != '')
        {
            alert(data);
        }
    });

    var negcounter = '#dislike-counter-'+post_id;
    var neglabel = '#dislike-label-'+post_id;
    var negcount = Number($(negcounter).html());
    
    var poscounter = '#like-counter-'+post_id;
    var poslabel = '#like-label-'+post_id;
    var poscount = Number($(poscounter).html());
    
    if (type_of == 'positive')
    {
        $(poscounter).html(poscount+1);
        $(poslabel).html('Liked');

        var neglabelval = $(neglabel).html();
        if (neglabelval == 'Disliked')
        {
            $(neglabel).html('Dislike');
            $(negcounter).html(negcount-1);
        }
    }
    else if (type_of == 'negative')
    {
        $(negcounter).html(negcount+1);
        $(neglabel).html('Disliked');

        var poslabelval = $(poslabel).html();
        if (poslabelval == 'Liked')
        {
            $(poslabel).html('Like');
            $(poscounter).html(poscount-1);
        }
    }
}

function voteDelete(post_id,type_of) 
{
    $.post('/cardea/vote_delete', // Reference: /cardea/controllers/vote.php
    {
        post_id: post_id,
        type_of: type_of
    },
    function(data, status)
    {
        if (status != 'success' || data != '')
        {
            alert(data);
        }
    });

    var negcounter = '#dislike-counter-'+post_id;
    var neglabel = '#dislike-label-'+post_id;
    var negcount = Number($(negcounter).html());
    
    var poscounter = '#like-counter-'+post_id;
    var poslabel = '#like-label-'+post_id;
    var poscount = Number($(poscounter).html());

    if (type_of == 'positive')
    {
        $(poscounter).html(poscount-1);
        $(poslabel).html('Like');
    }
    else if (type_of == 'negative')
    {
        $(negcounter).html(negcount-1);
        $(neglabel).html('Dislike');    
    }
}