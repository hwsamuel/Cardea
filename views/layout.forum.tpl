{extends file="layout.general.tpl"}

{block name=content}
<style>
    .link 
    {
        fill: none;
        stroke: #CCC;
        stroke-width: 2px;
    }
    .node circle
    {
        fill: #F00;
        stroke: #FFF;
        stroke-width: 2px;
    }
    text
    {
        font: 14px sans-serif;
    }
    #results
    {
        border: 1px solid #CCC;
        background: #EEE;
        width: 255px;
        top: {if isset($signed_in)}125px{else}100px{/if};
        font-size: 12px;
        display: none;
        position: fixed;
        z-index:99;
        padding: 5px;
        max-height: 200px;
        overflow-y: auto;
    }
    #container
    {
        position: relative;
        width: 260px;
        margin-top: 10px;
    }
    #main_image
    {
        width: 100%;
        height: 100%;
    }
    #overlay_image
    {
        position: absolute;
        top: 50px;
        left: 75px;
        width: 100px;
    }
</style>
        
<script src="{$base_url}/static/d3/d3.v3.min.js"></script>

<div class="row">
    <div role="tabpanel" class="col-xs-3">
        <br />
        <input type="text" class="input-sm col-xs-10" autocomplete="off" id="searchbox" name="searchbox" placeholder="Search..." />
        <button class="btn btn-sm btn-warning" onclick="searchForum();">Go</button>
        <div id="results" class="text-muted">
            <a href="#" onclick="$('#results').hide();"><span class="glyphicon glyphicon-remove pull-right"></span></a>
            <span id="search-matches"></span>
        </div>
        <br /><br />
        <span class="text-muted">Support Group Filter</span>
        <div class="scrollholder">
            <a href="{$base_url}/{$active}" {if !isset($selgroup)}style="background: #AAA; color: #000; display: inline-block; width: 255px; margin-left: -5px; padding-left: 5px;"{/if}>All Groups</a><br />
            {foreach from=$groups item=grp}
                <a href="{$base_url}/group/{$active}/{$grp.id}" {if isset($selgroup) && $selgroup == $grp.id}style="background: #AAA; color: #000; display: inline-block; width: 255px; margin-left: -5px; padding-left: 5px;"{/if}> {$grp.title}</a><br />
            {/foreach}
        </div>
        <br />
        <span class="text-muted">Keywords Filter (Double-Click Bubble)</span>
        <div style="border: 1px solid #AAA; padding: 5px;">
            <svg width="250" height="250"></svg>
        </div>

    </div>

    <div role="tabpanel" class="col-xs-6">
        {block name=forum_content}{/block}
    </div>

    <div class="col-xs-3">
        <br />
        <a target="_blank" href="https://www.canada.ca/en/health-canada.html"><b>Health Canada News</b> <img src="{$base_url}/static/img/canada.png" style="height: 10px" /></a>
        <div class="feed">
            {foreach from=$healthnews item=news}
                <p>
                    <a href="{$news.link}" target="_blank">{$news.title} <span class="glyphicon glyphicon-new-window"></span></a><br />
                    {if isset($signed_in) && !isset($vocab) && !isset($search_terms)}<a class="label label-default" onclick="startDiscuss('{$news.title}','{$news.link}')">Discuss</a>{/if}
                </p>
            {foreachelse}
                No RSS feeds available
            {/foreach}
        </div>
        <br />
        <a href="https://www.youtube.com/user/HealthyCdns/" target="_blank"><b>Healthy Canadians</b></a><br />
        <span class="small">{$healthvideo.title}</span>
        {if isset($signed_in) && !isset($vocab) && !isset($search_terms)}<a class="label label-default" onclick="startDiscuss('{$healthvideo.title}','https://www.youtube.com/watch?v={$healthvideo.vid}');">Discuss</a>{/if}

        <div id="container">
            <div id="main_image"><img src="https://i4.ytimg.com/vi/{$healthvideo.vid}/hqdefault.jpg" alt="{$healthvideo.title}" style="width: 260px; border: 1px solid #CCC; padding: 2px;" /></div>
            <div id="overlay_image"><a href="#play-yt-video" data-toggle="modal"><img src="{$base_url}/static/img/yt.png" style="width: 100px;" alt="Play" /></a></div>
        </div>
        
        <div id="play-yt-video" class="modal fade">
            <div class="modal-dialog">
                <div class="modal-content">
                    <div class="modal-header">
                        <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
                        <h4 class="modal-title">{$healthvideo.title}</h4>
                    </div>

                    <div class="modal-body">
                        <iframe id="healthvideo-container" width="565" height="400" src="https://www.youtube-nocookie.com/embed/{$healthvideo.vid}?autoplay=1&rel=0&controls=0&showinfo=0" style="border: 2px solid #CCC;"></iframe>
                        {if isset($signed_in) && !isset($vocab) && !isset($search_terms)}<a data-dismiss="modal" class="label label-default" onclick="startDiscuss('{$healthvideo.title}','https://www.youtube.com/watch?v={$healthvideo.vid}');">Discuss</a>{/if}
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<script>
var svg = d3.select("svg"),
    width = +svg.attr("width"),
    height = +svg.attr("height");

var nodes = [
    {assign "par" ''}
    { name: "questions", group: 1 },
    { name: "discussions", group: 1 },
    { name: "blogs", group: 1 },
    { name: "chats", group: 1 },
    {foreach from=$bubblewords item=pair}
        {if $pair.type_of == 'question'}
            {$par = $par|cat:'1,'}
        {/if}
        {if $pair.type_of == 'discussion'}
            {$par = $par|cat:'2,'}
        {/if}
        {if $pair.type_of == 'blog'}
            {$par = $par|cat:'3,'}
        {/if}
        {if $pair.type_of == 'chat'}
            {$par = $par|cat:'4,'}
        {/if}
        { name: "{$pair.keyword}", group: 2, parent: [{$par}] },
    {/foreach}
];

var links = [];

for (var i = 0; i < nodes.length; i++)
{
    if (nodes[i].parent == undefined) continue;
    for ( var x = 0; x < nodes[i].parent.length; x++ ) 
        links.push({
            source: nodes[i],
            target: nodes[nodes[i].parent[x]]  
        });
};

var force = d3.layout.force()
    .nodes(d3.values(nodes))
    .links(links)
    .size([width, height])
    .linkDistance(50)
    .charge(-250)
    .on("tick", tick)
    .start();

var link = svg.selectAll(".link")
    .data(force.links())
    .enter().append("line")
    .attr("class", "link");

var node = svg.selectAll(".node")
    .data(force.nodes())
    .enter().append("g")
    .attr("class", "node")
    .on("mouseover", mouseover)
    .on("mouseout", mouseout)
    .call(force.drag);

var color = d3.scale.category10();

node.append("circle")
    .attr("r", 8)
    .style("fill", function(d,i) { return color(d.group); });

node.append("text")
    .attr("x", 12)
    .attr("dy", ".35em")
    .text(function(d) { return d.name; });

node.on("dblclick", function(d)
{
    window.open("{$base_url}/search/{$active}/"+d.name,"_self");
});

function tick()
{
    link
      .attr("x1", function(d) { return d.source.x; })
      .attr("y1", function(d) { return d.source.y; })
      .attr("x2", function(d) { return d.target.x; })
      .attr("y2", function(d) { return d.target.y; });

    node
      .attr("transform", function(d) { return "translate(" + d.x + "," + d.y + ")"; });
}

function mouseover()
{
    d3.select(this).select("circle").transition()
      .duration(750)
      .attr("r", 15);
}

function mouseout()
{
    d3.select(this).select("circle").transition()
      .duration(750)
      .attr("r", 8);
}

$('#searchbox').bind("keyup", null, function(event) {
    if (event.keyCode == 27 || event.keyCode == 8) 
    {
        document.getElementById("results").style.display = 'none';
        return;
    }
    if (this.value.trim().length < 3) return;
    if (this.value.trim().length == 0) {
        document.getElementById("search-matches").innerHTML = "";
        document.getElementById("results").style.display = 'none';
        return;
    }

    $.get('/search_suggest',
    {
        keyword: this.value.trim(),
        forum: '{$active}'
    },
    function(data, status)
    {
        if (status == 'success')
        {
            if (data == '') return;
            document.getElementById("results").style.display = 'block';
            document.getElementById("search-matches").innerHTML = data;
        }
        else
        {
            alert(data);
        }
    });
});

function addKeyword(wrd)
{
    var txt = $('#searchbox').val();
    var lastIndex = txt.lastIndexOf(" ");
    if (lastIndex == -1)
    {
        txt = '';
    }
    else
    {
        txt = txt.substring(0, lastIndex);
    }
    $('#searchbox').val(txt + " " + wrd + " ");
    $('#searchbox').focus();
    document.getElementById("results").style.display = 'none';
}

function searchForum()
{
    var kws = $('#searchbox').val().trim();
    if (kws.length < 3) return;
    var url = '/search/{$active}/'+kws;
    window.open(url, '_self');
}

function startDiscuss(title, link)
{
    $('.postbox').val(title + ' ' + link);
}
</script>

<script>
$(document).ready(function()
{
    var url = $("#healthvideo-container").attr('src');
    $("#healthvideo-container").attr('src', '');

    $("#play-yt-video").on('shown.bs.modal', function()
    {
        $("#healthvideo-container").attr('src', url);
    });

    $("#play-yt-video").on('hide.bs.modal', function()
    {
        $("#healthvideo-container").attr('src', '');
    });
});
</script>
{/block}
