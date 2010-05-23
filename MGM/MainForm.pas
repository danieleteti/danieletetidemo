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
  PersonU,
  MGM,
  MGM.EditMediator,
  StdCtrls,
  MGM.LabelMediator,
  Generics.Collections,
  MGM.ListMediator,
  ComCtrls, Grids;

type
  TForm1 = class(TForm)
    Button1: TButton;
    Edit1: TEdit;
    Button2: TButton;
    Label1: TLabel;
    Label2: TLabel;
    Edit2: TEdit;
    ListBox1: TListBox;
    Button3: TButton;
    Button4: TButton;
    Button5: TButton;
    ListBox2: TListBox;
    ListView1: TListView;
    Edit3: TEdit;
    ComboBox1: TComboBox;
    ListView2: TListView;
    StringGrid1: TStringGrid;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure ListBox1Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure ComboBox1CloseUp(Sender: TObject);
  private
    Persone: TPersone;
  strict protected
    lbMed: TListBoxMediator<TPersona>;
    cboTelefoni: TComboBoxMediator<TTelefono>;
    { Private declarations }
  public
    ds: TSubjectDataSource;
    dsList: TSubjectListDataSource<TPersona>;
    dsListTel: TSubjectListDataSource<TTelefono>;
    Persona1, Persona2: TPersona;
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

procedure TForm1.Button1Click(Sender: TObject);
begin
  Persona1.Nome := StringOfChar('X', Random(10));
end;

procedure TForm1.Button2Click(Sender: TObject);
begin
  if ds.CurrentSubject <> Persona1 then
  begin
    ds.CurrentSubject := Persona1;
    dsListTel.CurrentListSubject := Persona1.Telefoni;
  end
  else
  begin
    ds.CurrentSubject := Persona2;
    dsListTel.CurrentListSubject := Persona2.Telefoni;
  end;
end;

procedure TForm1.Button3Click(Sender: TObject);
begin
  Persone.Add(TPersona.CreateNew);
end;

procedure TForm1.Button4Click(Sender: TObject);
begin
  Persone.Clear;
end;

procedure TForm1.Button5Click(Sender: TObject);
begin
  Persone.Delete(ListBox1.ItemIndex);
end;

procedure TForm1.ComboBox1CloseUp(Sender: TObject);
begin
  Caption := cboTelefoni.Selected.Numero;
end;

procedure TForm1.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Persona1.Free;
  Persona2.Free;
  ds.Free;
  dsList.Free;
  dsListTel.Free;
  Persone.Free;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  Persona1 := TPersona.CreateNew;

  Persona2 := TPersona.CreateNew;

  ds := TSubjectDataSource.Create;
  ds.CurrentSubject := Persona1;
  ds.AddObserver(TEditMediator.Create(Edit1, 'Nome'));
  ds.AddObserver(TLabelMediator.Create(Label1, 'Cognome'));
  ds.AddObserver(TLabelIntegerMediator.Create(Label2, 'Eta'));
  ds.AddObserver(TEditIntegerMediator.Create(Edit2, 'Eta'));
  ds.AddObserver(TEditCurrencyMediator.Create(Edit3, 'Salario', ceOnExit));
  ds.NotifyObservers;

  dsListTel := TSubjectListDataSource<TTelefono>.Create;
  dsListTel.CurrentListSubject := Persona1.Telefoni;
  cboTelefoni := TComboBoxMediator<TTelefono>.Create(ComboBox1, 'Numero');
  dsListTel.AddObserver(cboTelefoni);
  dsListTel.AddObserver(TListBoxMediator<TTelefono>.Create(ListBox2, 'Numero'));
  dsListTel.AddObserver(TListViewMediator<TTelefono>.Create(ListView1,
    procedure(li: TListItem; telefono: TTelefono)
    begin
      li.Caption := telefono.Tipo; li.SubItems.Add(telefono.Numero);
    end));

  dsListTel.NotifyObservers;

  Persone := TPersone.Create;
  dsList := TSubjectListDataSource<TPersona>.Create;
  dsList.CurrentListSubject := Persone;
  lbMed := TListBoxMediator<TPersona>.Create(ListBox1, 'Nome');
  dsList.AddObserver(lbMed);


  dsList.AddObserver(TListViewMediator<TPersona>.Create(ListView2,
    procedure(li: TListItem; persona: TPersona)
    begin
      li.Caption := Persona.Nome;
      li.SubItems.Add(Persona.Cognome);
      li.SubItems.Add(CurrToStr(Persona.Salario));
      li.SubItems.Add(IntToStr(Persona.Eta));
    end));


  dsList.NotifyObservers;
  Persone.Add(TPersona.CreateNew);
  Persone.Add(TPersona.CreateNew);
  Persone.Add(TPersona.CreateNew);
  Persone.Add(TPersona.CreateNew);

end;

procedure TForm1.ListBox1Click(Sender: TObject);
begin
  // Caption := Persone[ListBox1.ItemIndex].Nome;
  Caption := lbMed.Selected.Cognome;
end;

end.
procedure TForm1.ListView2CustomDraw(Sender: TCustomListView;
  const ARect: TRect; var DefaultDraw: Boolean);
begin

end;


