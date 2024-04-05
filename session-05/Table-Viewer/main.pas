unit main;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, DB, SQLDB, SQLDBLib, mysql80conn, mysql57conn, Forms,
  Controls, Graphics, Dialogs, DBGrids, StdCtrls, DBCtrls, ExtCtrls;

const
  MYSQL_LIBRARY = 'mysqllib' + DirectorySeparator + 'libmariadb.dll';
  CONNECTOR_TYPE = 'MySQL 5.7';

type

  { TForm1 }

  TForm1 = class(TForm)
    btnOpen: TButton;
    DataSource1: TDataSource;
    DBGrid1: TDBGrid;
    DBNavigator1: TDBNavigator;
    edtHost: TEdit;
    edtUsername: TEdit;
    edtPassword: TEdit;
    edtDatabase: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    mem: TMemo;
    DBConnector: TSQLConnector;
    DBLibraryLoader: TSQLDBLibraryLoader;
    dq: TSQLQuery;
    memSQL: TMemo;
    Panel1: TPanel;
    Panel2: TPanel;
    Panel3: TPanel;
    Splitter1: TSplitter;
    Splitter2: TSplitter;
    SQLTransaction1: TSQLTransaction;
    procedure btnOpenClick(Sender: TObject);
    procedure DBConnectorBeforeConnect(Sender: TObject);
    procedure DBConnectorLog(Sender: TSQLConnection; EventType: TDBEventType;
      const Msg: String);
    procedure DBConnectorLogin(Sender: TObject; Username, Password: string);
    procedure FormCreate(Sender: TObject);
  private
    procedure log(msg: String);
  public

  end;

var
  Form1: TForm1;

implementation

{$R *.lfm}

{ TForm1 }

procedure TForm1.btnOpenClick(Sender: TObject);
begin
  if dq.Active then dq.Close;

  DBConnector.HostName := edtHost.Text;
  DBConnector.UserName := edtUsername.Text;
  DBConnector.Password := edtPassword.Text;
  DBConnector.DatabaseName := edtDatabase.Text;
  //DBConnector.Params.Add('port=3307');

  dq.SQL.Text:= memSQL.Text;
  try
    dq.Open;
  except
    on E:Exception do
    begin
      log('ERR: ' + e.Message);
    end;
  end;
end;

procedure TForm1.DBConnectorBeforeConnect(Sender: TObject);
begin
  log('Mencoba terhubung ke database..');
end;

procedure TForm1.DBConnectorLog(Sender: TSQLConnection;
  EventType: TDBEventType; const Msg: String);
begin
  if EventType = detExecute then
    log( Msg);
end;

procedure TForm1.DBConnectorLogin(Sender: TObject; Username, Password: string
  );
begin
  log('Logged in');
end;

procedure TForm1.FormCreate(Sender: TObject);
var
  fileLibrary: string;
begin
  fileLibrary := ExtractFileDir(Application.ExeName) + DirectorySeparator + MYSQL_LIBRARY;

  DBConnector.Connected := False;
  DBLibraryLoader.Enabled := False;
  DBLibraryLoader.ConnectionType := CONNECTOR_TYPE;
  DBLibraryLoader.LibraryName := fileLibrary;
  DBLibraryLoader.Enabled := True;

  DBConnector.ConnectorType := CONNECTOR_TYPE;
end;

procedure TForm1.log(msg: String);
begin
  mem.Lines.Insert(0, FormatDateTime('HH:nn:ss', Now) + ': ' + msg);
end;

end.

