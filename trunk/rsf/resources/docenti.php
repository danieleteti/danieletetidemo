<?php
class Docenti extends HTTPController
{
  function doDELETE(ServerInfo $info)
  {
    $params1 = $info->resourceParams();    
    $id = $params1[1];
    $d = new Docente();
    if ($d->load('id = '.$id)) $d->delete();        
    return HTTPController::http(200, 'Docente eliminato'); 
  }

  function doGET(ServerInfo $info)
  {  
    /*
    $id = $info->resourceParams(1);    
    $d = new Docente();
    if (!$d->load('id = '.$id))
      return HTTPController::http(404, 'Not found');
    */
    $this->assign('docente','Sono il docente');
    //$this->contentType = 'text/xml';                   
    return HTTPController::http(200, 'OK'); 
  }  
}
?>