<?php

class SSO extends HTTPController
{

  function doGET(ServerInfo $info) {
    $a = new Ente();    
    echo json_encode($a->find(''));                   
    return HTTPController::http(HTTPCodes::HTTP_OK, 'OK');
  }
  
}
?>