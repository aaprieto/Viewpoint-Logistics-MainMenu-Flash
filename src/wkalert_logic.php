<?php
error_reporting(E_ALL);

/* Allow the script to hang around waiting for connections. */
set_time_limit(0);

/* Turn on implicit output flushing so we see what we're getting
 * as it comes in. */
ob_implicit_flush();
	
$address = '127.0.0.1';

//date_default_timezone_set('UTC');

$current_time = date('l dS \of F Y h:i:s A');
$http_passin_param = $_GET['http_passin_param']; 

//alter header for XML output
header("Content-Type: text/xml");

// begin XML root tag
echo("<root>");

if (($sock = socket_create(AF_INET, SOCK_STREAM, SOL_TCP)) === false) {
    echo "socket_create() failed: reason: " . socket_strerror(socket_last_error()) . "\n";
}

if (socket_bind($sock, $address) === false) {
    echo "socket_bind() failed: reason: " . socket_strerror(socket_last_error($sock)) . "\n";
}

if (socket_getsockname($sock, $host, $port) === false) {
	echo "socket_getsockname() failed: reason: ".socket_strerror(socket_last_error($sock))."\n";
}
	
if (socket_listen($sock, 5) === false) {
    echo "socket_listen() failed: reason: " . socket_strerror(socket_last_error($sock)) . "\n";
}

/* This format does not work for MYSQL and only works for PVX files
   due to a bug in accessing MYSQL without login */

        $system_param = 'aim -zP run_pgm DFLT pw_wkalert '.$port.' web wkalert_logic '.'maves'.' '.$http_passin_param;
																		/* Replace 'maves' with $user_name after connected */

  
if (false === ($rst = system($system_param, $retval))) {
	echo "Fail to excute aim test".$retval;
}
do {
    if (($msgsock = socket_accept($sock)) === false) {
        echo "socket_accept() failed: reason: " . socket_strerror(socket_last_error($sock)) . "\n";
        break;
    }

    do {
        if (false === ($buf = socket_read($msgsock, 2048, PHP_NORMAL_READ))) {
            echo "socket_read() failed: reason: " . socket_strerror(socket_last_error($msgsock)) . "\n";
            break 2;
        }
        if (!$buf = trim($buf)) {
            continue;
        }
        if ($buf == 'quit') {
            break;
        }
        if ($buf == 'shutdown') {
            socket_close($msgsock);
            break 2;
        }
        
        echo "$buf\r\n";
       
    } while (true);
    socket_close($msgsock);
} while (true);

socket_close($sock);

$current_time = date('l dS \of F Y h:i:s A');

// close root tag of XML
echo ("</root>");
?>
