<?php
class HTTPCodes
{
  //http://www.askapache.com/htaccess/apache-status-code-headers-errordocument.html
  
  const HTTP_CONTINUE = 100; //'Continue'
  const HTTP_SWITCHING_PROTOCOLS = 101; //Switching Protocols
  const HTTP_PROCESSING = 102; //Processing

  const HTTP_OK = 200; //OK
  const HTTP_CREATED = 201;
  const HTTP_ACCEPTED = 202;
  const HTTP_NON_AUTHORITATIVE = 203;
  const HTTP_NO_CONTENT = 204;
  const HTTP_RESET_CONTENT = 205;
  const HTTP_PARTIAL_CONTENT = 206;
  const HTTP_MULTI_STATUS = 207;

  const HTTP_MULTIPLE_CHOICES = 300;
  const HTTP_MOVED_PERMANENTLY = 301;
  const HTTP_MOVED_TEMPORARILY = 302;
  const HTTP_SEE_OTHER = 303;
  const HTTP_NOT_MODIFIED = 304;
  const HTTP_USE_PROXY = 305;
  const HTTP_TEMPORARY_REDIRECT = 307;

  const HTTP_BAD_REQUEST = 400;
  const HTTP_UNAUTHORIZED = 401;
  const HTTP_PAYMENT_REQUIRED = 402;
  const HTTP_FORBIDDEN = 403;
  const HTTP_NOT_FOUND = 404;
  const HTTP_METHOD_NOT_ALLOWED = 405;
  const HTTP_NOT_ACCEPTABLE = 406;
  const HTTP_PROXY_AUTHENTICATION_REQUIRED = 407;
  const HTTP_REQUEST_TIME_OUT = 408;
  const HTTP_CONFLICT = 409;
  const HTTP_GONE = 410;
  const HTTP_LENGTH_REQUIRED = 411;
  const HTTP_PRECONDITION_FAILED = 412;
  const HTTP_REQUEST_ENTITY_TOO_LARGE = 413;
  const HTTP_REQUEST_URI_TOO_LARGE = 414;
  const HTTP_UNSUPPORTED_MEDIA_TYPE = 415;
  const HTTP_RANGE_NOT_SATISFIABLE = 416;
  const HTTP_EXPECTATION_FAILED = 417;
  const HTTP_UNPROCESSABLE_ENTITY = 422;
  const HTTP_LOCKED = 423;
  const HTTP_FAILED_DEPENDENCY = 424;
  const HTTP_NO_CODE = 425;
  const HTTP_UPGRADE_REQUIRED = 426;

  const HTTP_INTERNAL_SERVER_ERROR = 500;
  const HTTP_NOT_IMPLEMENTED = 501;
  const HTTP_BAD_GATEWAY = 502;
  const HTTP_SERVICE_UNAVAILABLE = 503;
  const HTTP_GATEWAY_TIME_OUT = 504;
  const HTTP_VERSION_NOT_SUPPORTED = 505;
  const HTTP_VARIANT_ALSO_VARIES = 506;
  const HTTP_INSUFFICIENT_STORAGE = 507;
  const HTTP_NOT_EXTENDED = 510;
  
  static function not_found($message)
  {
    header("HTTP/1.0 404 $message");
    header("X-REST: Controller not found");
    exit;   
  }  
}        
