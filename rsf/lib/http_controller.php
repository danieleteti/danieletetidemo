<?php

class HTTPController
{
  var $autoRender = true;
  var $contentType = null;
  function doGET(ServerInfo $info) { return HTTPController::http(HTTPCodes::HTTP_NOT_IMPLEMENTED, 'Not implemented');}
  function doPOST(ServerInfo $info) { return HTTPController::http(HTTPCodes::HTTP_NOT_IMPLEMENTED, 'Not implemented');}
  function doPUT(ServerInfo $info) { return HTTPController::http(HTTPCodes::HTTP_NOT_IMPLEMENTED, 'Not implemented');}
  function doDELETE(ServerInfo $info) { return HTTPController::http(HTTPCodes::HTTP_NOT_IMPLEMENTED, 'Not implemented');}
  
  static function http($code, $text)
  {
    return array($code, $text);
  }
  
  private $_viewData = array();
  
  protected function assign($key, $value)
  {
    $this->_viewData[$key] = $value;
  }     
  
  function viewData()
  {
    return $this->_viewData;
  }  
}

?>