<?php

class Utenti extends HTTPController
{
  function doDELETE(ServerInfo $info)
  {
    $params1 = $info->resourceParams();
    $params2 = $info->requestParams();
    $x['resourceParams'] = $params1;
    $x['requestParams'] = $params2;
    echo json_encode($x);    
    return HTTPController::http(302, 'Found'); 
  }
  function doPUT(ServerInfo $info)
  {
    $params1 = $info->resourceParams();
    //echo json_encode($params1);
    //var_dump($params1);
    $params2 = $info->requestParams();
    //var_dump($params2);
    //echo json_encode($params2);
    $x['resourceParams'] = $params1;
    $x['requestParams'] = $params2;
    echo json_encode($x);
    
    return HTTPController::http(200, 'OK');
  }

  function doPOST(ServerInfo $info)
  {
    $params1 = $info->resourceParams();
    //echo json_encode($params);
    //var_dump($params1);
    $params2 = $info->requestParams();
    //var_dump($params2);
    echo json_encode($params2);
    return HTTPController::http(200, 'OK');
  }
    
  function doGET(ServerInfo $info)
  {
    Load::userLibrary('adodb/adodb.inc.php');
    $params1 = $info->resourceParams();
    //echo json_encode($params);
    //var_dump($params);
    $params2 = $info->requestParams();
    //var_dump($params);
    echo json_encode($params1);
    return HTTPController::http(200, 'OK');
  }
}

?>