<?php
//PROJECT SPECIFIC
Load::userLibrary('adodb/adodb.inc.php');
Load::userLibrary('adodb/adodb-exceptions.inc.php');
Load::userLibrary('adodb/adodb-active-record.inc.php');

$ADODB_ACTIVE_CACHESECS = 60; //In produzione impostare qualche ora
global $ADODB_FETCH_MODE, $ADODB_ASSOC_CASE;
$ADODB_FETCH_MODE = 1;
$ADODB_ASSOC_CASE = 0; //Fields in lowercase

Load::userLibrary('ARBase.php');
Load::userLibrary('models.php');
?>