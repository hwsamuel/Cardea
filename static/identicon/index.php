<?php
include 'autoload.php';

$identicon = new \Identicon\Identicon();
$text = $_GET['text'];
$identicon->displayImage($text, 32);
?>
