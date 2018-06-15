unit uPrincipal;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Data.Cloud.CloudAPI,
  Data.Cloud.AmazonAPI, Vcl.ComCtrls, Vcl.StdCtrls, Vcl.Buttons, Vcl.FileCtrl;

type
  TForm1 = class(TForm)
    amcAmazon: TAmazonConnectionInfo;
    stat1: TStatusBar;
    lbl1: TLabel;
    lbl2: TLabel;
    btnLoad: TSpeedButton;
    btndownload: TSpeedButton;
    btnexcluir: TSpeedButton;
    btnbuckets: TSpeedButton;
    btnArquivos: TSpeedButton;
    lstlistabuckts: TListBox;
    lstListaArquivos: TListBox;
    edtBucket: TEdit;
    btnBucket: TSpeedButton;
    dlgOpen1: TOpenDialog;
    AmazonConnectionInfo1: TAmazonConnectionInfo;
    procedure FormCreate(Sender: TObject);
    procedure btnbucketsClick(Sender: TObject);
    procedure btnArquivosClick(Sender: TObject);
    procedure btnLoadClick(Sender: TObject);
    procedure btndownloadClick(Sender: TObject);
    procedure btnexcluirClick(Sender: TObject);
    procedure btnBucketClick(Sender: TObject);

  private
    { Private declarations }
    s3: TAmazonStorageService;
    s3Regiao: TAmazonRegion;
    sRegiao: String;

  public
    { Public declarations }
  end;

  const
    Acceskey = 'SUA CHAVE AQUI';
    Secretkey = 'SUA SENHA AQUI';

var
  Form1: TForm1;

implementation

{$R *.dfm}


procedure TForm1.btnBucketClick(Sender: TObject);
begin
  s3.CreateBucket(edtBucket.Text, TAmazonACLType.amzbaPrivate, TAmazonRegion.amzrUSWest1, nil);
end;

procedure TForm1.btnArquivosClick(Sender: TObject);
var
  strBuckt: String;
  bucktInfo: TAmazonBucketResult;
  ObjInfo : TAmazonObjectResult;

begin
  strBuckt := lstlistabuckts.Items[lstlistabuckts.ItemIndex];
  bucktInfo := s3.GetBucket(strBuckt, nil);
  lstListaArquivos.Items.Clear;
  for ObjInfo in bucktInfo.Objects do
    begin
      lstListaArquivos.Items.Add(ObjInfo.Name);
    end;

end;

procedure TForm1.btnbucketsClick(Sender: TObject);
var
  respInfo: TCloudResponseInfo;
  list: TStrings;
  i: integer;
begin
  respInfo := TCloudResponseInfo.Create;

  try
    list := s3.ListBuckets(respInfo);
    lstlistabuckts.Items.Clear;

    if Assigned(list) then
      for i := 0 to Pred( list.Count ) do
        begin
          lstlistabuckts.Items.Add(list.Names[i]);
        end;

  finally
    respInfo.Free;
    list.Free;
  end;
end;

procedure TForm1.btndownloadClick(Sender: TObject);
var
  fStream: TStream;
  sDir, sFile: String;
begin
   fStream := TMemoryStream.Create;
   try
     sFile := lstListaArquivos.Items[lstListaArquivos.ItemIndex];
     Screen.Cursor := crHourGlass;
     s3.GetObject(lstlistabuckts.Items[lstlistabuckts.ItemIndex], sFile, fStream);
     fStream.Position := 0;

     sDir := ExtractFilePath(ParamStr(0));

     if selectDirectory('Selecione a pasta', 'C:\', sDir) then
       begin
         TMemoryStream(fStream).SaveToFile(sDir+PathDelim+sFile);
         MessageDlg('Arquivo salvo com sucesso.', mtInformation, [mbOK],0);
       end;

   finally
     fStream.Free;
     Screen.Cursor := crDefault;
   end;
end;

procedure TForm1.btnexcluirClick(Sender: TObject);
var
  sfile: String;
begin
  sfile := lstListaArquivos.Items[lstListaArquivos.ItemIndex];

  if MessageDlg('Deseja realmente excluir este arquivo?', mtConfirmation, [mbYes, mbNo],0) = mrYes then
    begin
       try

         try
           Screen.Cursor := crHourGlass;
           s3.DeleteObject(lstlistabuckts.Items[lstlistabuckts.ItemIndex], sfile);

         finally
           Screen.Cursor := crDefault;
         end;
       except
         MessageDlg('Erro ao excluir o arquivo.', mtError, [mbOK], 0);
       end;
    end;

end;

procedure TForm1.btnLoadClick(Sender: TObject);
var
  sFile     : String;
  fContents : TBytes;
  fReader   : TBinaryReader;
  sMeta     : TStringList;
begin
  if dlgOpen1.Execute then
    begin
      sFile := ExtractFileName(dlgOpen1.FileName);
      fReader := TBinaryReader.Create(dlgOpen1.FileName);
      try
        fContents := fReader.ReadBytes(fReader.BaseStream.Size);
      finally
        fReader.Free;
      end;
      try
        try
          sMeta := TStringList.Create;
          sMeta.Add('Content-type=*.jpg');
          Screen.Cursor := crHourGlass;
          try
            s3.UploadObject(lstlistabuckts.Items[lstlistabuckts.ItemIndex], sFile, fContents, False, sMeta);
            MessageDlg('Operação executada com sucesso.', mtInformation, [mbOK], 0);
          except
          on e: Exception do
            begin
              ShowMessage(e.Message);
            end;
          end;
        finally
          Screen.Cursor := crDefault;
          sMeta.Free;
        end;
      except
        on e: exception do
          begin
            Screen.Cursor := crDefault;
            MessageDlg('Erro ao executar o upload.', mtError, [mbOK], 0);
          end;
      end;
    end;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  amcAmazon.AccountName :=  Acceskey;
  amcAmazon.AccountKey := Secretkey;

  s3      := TAmazonStorageService.Create(amcAmazon);
  sRegiao := TAmazonStorageService.GetRegionString(s3Regiao);

  lbl1.Caption := amcAmazon.StorageEndpoint;
  lbl2.Caption := sRegiao;

end;

end.


