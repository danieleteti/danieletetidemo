<?php
class Logger
{
  protected $file = null;
  private function __construct()
  {
    $this->file = &Log::factory('file', dirname(__FILE__).'/../log/out.log', 'RSF');
  }
  
  private function log($message)
  {
    $this->file->log($message);
  }
  
  private static $instance = null;
  
  static function write($message)
  {
    if (!self::$instance)
      self::$instance = new Logger();
    self::$instance->Log($message);
  }
}

?>