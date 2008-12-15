<?php
require_once 'lib/server_info.php';
require_once 'lib/http_controller.php';
require_once 'lib/http_return_codes.php';
require_once 'lib/viewer.php';
require_once 'lib/PEAR/Log.php';
require_once 'lib/logger.php';
require_once 'lib/commons.php';
require_once 'config/mappings.php';
require_once 'config/bootstrap.php';

$server = new ServerInfo($_SERVER);
$fname = dirname(__FILE__).'/resources/'.$server->resource().'.php';
if (file_exists($fname))
{
  Logger::write("Resource $fname required with method {$server->requestMethod()}");
  require_once $fname;
}
else
{
  Logger::write("Resource not found $fname");
  header("HTTP/1.0 404 controller not found: {$server->resource()}");
  header("X-REST: Controller not found");
  exit;     
}

$resName = $server->resource();
$resObject = new $resName;
switch ($server->requestMethod())
{
  case 'GET':
  {
    $code = $resObject->doGET($server); break;
  }
  
  case 'POST':
  {    
    $code = $resObject->doPOST($server); break;
  }
  
  case 'PUT':
  {
    $code = $resObject->doPUT($server); break;
  }
  
  case 'DELETE':
  {
    $code = $resObject->doDELETE($server); break;
  }  
}

header('HTTP/1.0 '.$code[0].' '.$code[1]);
if ($resObject->contentType) //Se il controller ha ridefinito il content type
  header('Content-Type: '.$resObject->contentType);
else //Altrimenti quello richiesto dall'estensione o da accept
  header('Content-Type: '.$server->acceptContentType());

$viewer = new Viewer($server, $resObject);
$viewer->display();
?>