<?php

class Viewer
{
  private $_viewName = '';
  private $_layoutName = '';
  private $_resObject = null;
  private $_server = null;
  
  function __construct($server, $resObject)
  {    
    $this->contentTypeToRender = null;
    if ($resObject->contentType)
      $this->contentTypeToRender = $resObject->contentType;
    else  
      $this->contentTypeToRender = $server->acceptContentType();    
    
    $this->_server = $server;
    $this->_resObject = $resObject;    
    $this->_viewName = dirname(__FILE__).'/../views/'.$this->_server->resource().'/'.
      Load::layoutByContentType($this->contentTypeToRender).'/'.
      $this->_server->requestMethod().'.php';
      
            
    $this->_layoutName = dirname(__FILE__).'/../views/layout/'.Load::layoutByContentType($this->contentTypeToRender).'.php';                
  }
  
  function display()
  {
    if (file_exists($this->_viewName))
    {
      Logger::write("Rendering view {$this->_viewName}"); 
      ob_start();
      extract($this->_resObject->viewData());
      require_once $this->_viewName;
      $content_for_layout = ob_get_contents();
      ob_clean();
      
      if (file_exists($this->_layoutName))
      {
        Logger::write("Rendering layout {$this->_layoutName}");
        require_once $this->_layoutName;  
      }
      else
      {
        echo "Error: Layout '{$this->_layoutName}' not found";
      }
    }
    else
    {
      header("HTTP/1.0 404 view not found: {$this->_viewName}");
      header("X-REST: Controller not found");
      exit;     
    }
  
  }
}
?>