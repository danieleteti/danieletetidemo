<?php
  class ARBase extends ADOdb_Active_Record {
    function OnBeforeSave() { return true; }
    function OnAfterSave()  { return true; }
    function OnBeforeLoad() { return true; }
    function OnAfterLoad()  { return true; }
    function OnBeforeDelete() { return true; }
    function OnAfterDelete()  { return true; }

    function OnSaveError() { return true; }
    function OnNewObject() { return true; }

    var $_errors = array();


    static function NewObject($classname)
    {
      $r = new $classname;
      return $r;
    }

    function ErrorsCount() { return count($this->_errors); }

    function Load($where,$bindarr=false)
    {
      if (!$this->OnBeforeLoad()) return false;
      $res = parent::Load($where,$bindarr);
      $this->OnAfterLoad();
      return $res;
    }

    function Delete()
    {
      if (!$this->OnBeforeDelete()) return false;
      $res = parent::Delete();
      $this->OnAfterDelete();
      return $res;
    }

    function Save()
    {
      $this->_errors = array();
      $this->OnBeforeSave();
      if (count($this->_errors)) return false;
      $res = parent::save();
      if (!$res)
      {
        $this->_errors[] = $this->ErrorMsg();
        $this->OnSaveError();
      }
      else
        $this->OnAfterSave();
      return $res;
    }

    function ARBase()
    {
      parent::__construct();
      $this->OnNewObject();
    }

    function HtmlErrors($Caption = "There are errors")
    {
      $r = "<fieldset id=\"arbase_errors\"><legend>$Caption</legend><ul>";
      foreach($this->_errors as $error)
        $r.= "<li>$error</li>";
      var_dump($this->_errors);
      $r.= "</ul></fieldset>";
      return $r;
    }

    function EntitiesName()
    {
      return get_class($this);
    }    
  }

?>
