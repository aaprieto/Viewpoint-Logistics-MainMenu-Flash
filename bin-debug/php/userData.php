<?php
/**
 * UserInfo.php
 *
 * This page is for users to view their account information
 * with a link added for them to edit the information.
 *
 */
include("../../include/session.php");

$req_user = trim($session->username);
$req_user_info = $database->getUserInfo($req_user);
echo ("<root>");
echo ("<usercode>".$req_user_info['username']."</usercode>");
echo ("<username>".$req_user_info['userdispname']."</username>");
echo ("</root>");
?>