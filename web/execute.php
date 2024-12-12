<?php
session_start();
$command = isset($_SESSION['command']) ? $_SESSION['command'] : '';
session_write_close();

if (!$command) {
    die('Aucune commande n\'a été fournie.');
}

header('Content-Type: text/event-stream');
header('Cache-Control: no-cache');

$process = proc_open(
    $command,
    [
        1 => ['pipe', 'w'], // stdout
        2 => ['pipe', 'w'], // stderr
    ],
    $pipes
);

if (is_resource($process)) {
    while (($line = fgets($pipes[1])) !== false) {
        echo "data: " . json_encode($line) . "\n\n";
        ob_flush();
        flush();
    }

    while (($line = fgets($pipes[2])) !== false) {
        echo "data: " . json_encode('[Erreur] ' . $line) . "\n\n";
        ob_flush();
        flush();
    }

    fclose($pipes[1]);
    fclose($pipes[2]);
    proc_close($process);

    echo "data: \"--- Fin de la commande ---\"\n\n";
    ob_flush();
    flush();
}
?>

