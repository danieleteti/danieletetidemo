<?php

require_once 'request_params.php';

class ServerInfo
{
  function __construct($ServerArray)
  {
    $acpt = explode(',',$_SERVER["HTTP_ACCEPT"]); 
    $this->HTTP_ACCEPT = $acpt[0];
    $this->REMOTE_ADDR = $_SERVER['REMOTE_ADDR'];
    $this->REDIRECT_URL = $_SERVER['REDIRECT_URL'];
    $this->REQUEST_METHOD = $_SERVER['REQUEST_METHOD'];
    $this->QUERY_STRING = $_SERVER['QUERY_STRING'];
    $this->GetResource($ServerArray, $this->_resource, $this->_resourceParams);
    $this->_requestParams = new RequestParams($this->REQUEST_METHOD, $this->QUERY_STRING);
  }  
  
  function resourceParams($index = null)
  {
    if ($index !== null)
      return $this->_resourceParams[$index];
    else      
      return $this->_resourceParams;
  }
    
  function requestParams()
  {
    return $this->_requestParams;
  }

  protected function strBefore($separator, $string)
  {
    $x = explode($separator, $string, 2);
    return $x[0];
  } 
  
  protected function GetResource($ServerArray, &$resource, &$params)
  {
    $params = array();        
    
    $s1 = explode('/',$this->strBefore('?',$_SERVER['REQUEST_URI']));
    $s2 = explode('/',$this->strBefore('?',$_SERVER['SCRIPT_NAME']));
    $x = 0;
    while ($s1[$x] == $s2[$x]) $x++;
    $resource = $s1[$x];
    $part = explode('.',$resource);
    if (count($part) > 1)
    {
      $resource = $part[0];
      $this->HTTP_ACCEPT = Load::contentTypeFromExtension($part[1]);
    }         
        
    $x++;
    while ($x < count($s1))
    {
      $params[] = urldecode($s1[$x]);
      $x++;
    }
  }

  function remoteAddress() {return $this->REMOTE_ADDR;}
  function requestedURL() {return $this->REDIRECT_URL;}
  function requestMethod() {return $this->REQUEST_METHOD;}
  function resource() {return $this->_resource;}
  function acceptContentType() {return $this->HTTP_ACCEPT;}
}
?>
