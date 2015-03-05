<?
/**
 * Product Filter
 *
 * This page is for users to access the Windx system 
 *
 */
include("../include/session.php");
$PHPSESSID = session_id();
$USERNAME = $session->username;

$job = $_GET['job'];

$ourFileName = "windxreq/".$job.$session->userid.$session->username;

$ourFileHandle = fopen($ourFileName, 'w') or die("can't open file");
fclose($ourFileHandle);
$url ="wc_product_filter.php";
header("Refresh: 0; $url", false);

?>
