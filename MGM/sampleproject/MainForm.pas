unit MainForm;

interface

uses
  Windows,
  Messages,
  SysUtils,
  Variants,
  Classes,
  Graphics,
  Controls,
  Forms,
  Dialogs,
  ComCtrls,
  ExtCtrls,
  bo,
  MGM,
  MGM.ListMediator,
  ActnList,
  StdCtrls,
  PersonaEditForm;

type
  TForm2 = class(TForm)
    ListView1: TListView;
    Panel1: TPanel;
    Button1: TButton;
    ActionList1: TActionList;
    Action1: TAction;
    Action2: TAction;
    Action3: TAction;
    Action4: TAction;
    Button2: TButton;
    Button3: TButton;
    ListBox1: TListBox;
    procedure FormCreate(Sender: TObject);
    procedure Action1Execute(Sender: TObject);
    procedure Action2Execute(Sender: TObject);
    procedure Action3Execute(Sender: TObject);
    procedure Action3Update(Sender: TObject);
  private
    lvMed: TListViewMediator<TPersona>;
    dsPersone: TSubjectListDataSource<TPersona>;
  public
    { Public declarations }
  end;

var
  Form2: TForm2;

implementation

{$R *.dfm}

procedure TForm2.Action1Execute(Sender: TObject);
var
  p: TPersona;
  frmPersonaEdit: TfrmPersoneEdit;
  OK: boolean;
begin
  p := TPersona.Create;
  try
    frmPersonaEdit := TfrmPersoneEdit.Create(Self, p);
    try
      OK := frmPersonaEdit.ShowModal = mrOk; // too much complicated...
    finally
      frmPersonaEdit.Free;
    end;
    if OK then
      TData.GetInstance.Add(p);
  finally
    if not OK then
      p.Free;
  end;
end;

procedure TForm2.Action2Execute(Sender: TObject);
var
  frmPersonaEdit: TfrmPersoneEdit;
begin
  frmPersonaEdit := TfrmPersoneEdit.Create(Self, lvMed.Selected);
  try
    frmPersonaEdit.ShowModal; // user cannot "Cancel" the changes :-(
  finally
    frmPersonaEdit.Free;
  end;
  dsPersone.NotifyObservers;
end;

procedure TForm2.Action3Execute(Sender: TObject);
begin
  TData.GetInstance.Remove(lvMed.Selected);
end;

procedure TForm2.Action3Update(Sender: TObject);
begin
  (Sender as TAction).Enabled := lvMed.Selected <> nil;
end;

procedure TForm2.FormCreate(Sender: TObject);
begin
  dsPersone := TSubjectListDataSource<TPersona>.Create;
  dsPersone.CurrentListSubject := TData.GetInstance;
  TData.GetInstance.BeginUpdate;
  try
    lvMed := TListViewMediator<TPersona>.Create(ListView1,
      procedure(li: TListItem; Persona: TPersona)
      begin
        li.Caption := Persona.Nome;
        li.SubItems.Add(Persona.Indirizzo);
        li.SubItems.Add(Persona.Tipo);
      end);
    dsPersone.AddObserver(lvMed);
    dsPersone.AddObserver(TListBoxMediator<TPersona>.Create(ListBox1, 'Nome'));
  finally
    TData.GetInstance.EndUpdate;
  end;
  dsPersone.NotifyObservers;
end;

end.
