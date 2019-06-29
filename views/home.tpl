{extends file="layout.general.tpl"}

{block name=extra_scripts}{/block}

{block name=content}
<br />
<div class="row">
    <div class="col-xs-1"></div>
    <div class="col-xs-10">
    <div class="well">
	<h3><b>Start a healthy conversation!</b></h3>
	<p class="text-justify">Cardea is a new <b>security-focused</b>, <b>privacy-aware</b>, and <b>trust-centric</b> Canadian health social network for patients and medics.</p>
    
    {include file='widgets/status.tpl' forum=''}
    
    <div class="row" style="margin-top:-20px;">
        <div class="col-md-4">
            <h4>Patient to Patient</h4>
            <p class="text-justify">Share experiences with other patients while keeping track of privacy and credibility.</p>
            <p><a class="btn btn-black btn-warning" href="/cardea/p2p" role="button">Go to P2P Forum</a></p>
        </div>
        <div class="col-md-4">
            <h4>Patient to Medic</h4>
            <p class="text-justify">Post questions to medical professionals while maintaining confidentiality.</p>
            <p><a class="btn btn-black btn-warning" href="/cardea/p2m" role="button">Go to P2M Forum</a></p>
        </div>
        <div class="col-md-4">
            <h4>Medic to Medic</h4>
            <p class="text-justify">Medical professionals can share knowledge across geographical boundaries.</p>
            <p><a class="btn btn-black btn-warning" href="/cardea/m2m" role="button">Go to M2M Forum</a></p>
        </div>
    </div>
    </div>
    </div>
    <div class="col-xs-1"></div>
</div>
{/block}
