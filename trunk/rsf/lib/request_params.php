<?php

class RequestParams
{
  function __get($varname)
  {
    if (empty($this->data[$varname]))
      return null;
    return $this->data[$varname];
  }

  function getParams($key)
  {
    return $this->__get($key);
  }

  function getQueryStringParams($key)
  {
    if (empty($this->queryString[$key]))
      return null;
    return $this->queryString[$key];
  }

  public $data = array();

  public $queryString = array();

  protected $httpMethod = null;

  function __construct($HttpMethod, $queryString)
  {
    $this->httpMethod = strtoupper($HttpMethod);

    $this->queryString = $this->paramsFromString($queryString);

    switch($this->httpMethod)
    {
      case 'GET':
      {
        $this->data = $_GET;
        break;
      }

      case 'POST':
      {
        $this->data = $_POST;
        break;
      }

      case 'DELETE':
      {
        $this->data = $this->paramsFromString(file_get_contents('php://input'));
        break;
      }

      case 'PUT':
      {
        $this->data = $this->paramsFromString(file_get_contents('php://input'));
        break;
      }
    }
  } //construct


  protected function paramsFromString($urlencoded)
  {
    $fields = explode('&',$urlencoded);
    $data = array();
    foreach($fields as $value)
    {
      $field = explode('=',$value);
      $data[$field[0]] = urldecode($field[1]);
    }
    return $data;
  }

  function getMethod() { return $this->httpMethod; }

}


?>