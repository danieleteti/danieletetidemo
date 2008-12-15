<?php
class Load
{
  static function userLibrary($filename)
  {    
    $fname = dirname(__FILE__).'/../userlibrary/'.$filename;
    if (!file_exists($fname))
    {
      header("HTTP/1.0 404 userLibrary not found: $fname");
      header("X-REST: Controller not found");
      exit;     
    }
    else    
      require_once $fname;
  }
  
  static function contentTypeFromExtension($extension)
  {
    global $extensionContentType;
    if (empty($extensionContentType[$extension]))
      return $extensionContentType[$default_extensionContentType];
    else
      return $extensionContentType[$extension];      
  }
  
  static function layoutByContentType($contentType)
  {
    global $mappings;
    if (empty($mappings[$contentType]))
      return $mappings[$default_mapping];
    else
      return $mappings[$contentType];      
  }
}
?>