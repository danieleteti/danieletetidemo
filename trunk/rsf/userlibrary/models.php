<?php
$username = 'root';
$password = 'root';
$servername = 'localhost';
$dbname = 'sac_dev';

  
  $db = NewADOConnection("mysqli://$username:$password@$servername/$dbname");

  function getdb()
  {
    global $db;
    return $db;
  }

  if (!$db) throw new Exception("Cannot connect to database server");
  //  $db->debug = true;
  ADOdb_Active_Record::SetDatabaseAdapter($db);
  $db->debug = 0;

  $ADODB_ACTIVE_CACHESECS = 60; //In produzione impostare qualche ora
  global $ADODB_FETCH_MODE;
  global $ADODB_ASSOC_CASE;
  $ADODB_FETCH_MODE = 2;
  $ADODB_ASSOC_CASE = 0; //Fields in lowercase

  /*
  Per ogni tabella che vuoi astrarre in oggetto, è necessario che
  derivi una classe da ADOdb_Active_Record. A run time l'oggetto potrà essere
  utilizzato secondo il pattern ActiveRecord (http://martinfowler.com/eaaCatalog/activeRecord.html)
  Il manuale di ActiveRecord è (http://phplens.com/lens/adodb/docs-active-record.htm)
  es.
  class Person extends ADOdb_Active_Record
  {
    var $_table = 'People'; //Tabella che sarà "mappata"
  }
  $person = new Person();

  //Per ogni problema (anche esistenziale)... chiedere a Luca
  */

  class Ente extends ARBase {var $_table = 'ENTI';}
  class Docente extends ARBase {var $_table = 'DOCENTI';}
?>