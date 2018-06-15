object Form1: TForm1
  Left = 0
  Top = 0
  Caption = 'AWS - S3  Sincronizador'
  ClientHeight = 600
  ClientWidth = 524
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object lbl1: TLabel
    Left = 8
    Top = 8
    Width = 16
    Height = 13
    Caption = 'lbl1'
  end
  object lbl2: TLabel
    Left = 8
    Top = 27
    Width = 16
    Height = 13
    Caption = 'lbl2'
  end
  object btnLoad: TSpeedButton
    Left = 390
    Top = 90
    Width = 121
    Height = 32
    Caption = 'Upload'
    OnClick = btnLoadClick
  end
  object btndownload: TSpeedButton
    Left = 390
    Top = 128
    Width = 121
    Height = 32
    Caption = 'Download'
    OnClick = btndownloadClick
  end
  object btnexcluir: TSpeedButton
    Left = 390
    Top = 166
    Width = 121
    Height = 32
    Caption = 'Excluir'
    OnClick = btnexcluirClick
  end
  object btnbuckets: TSpeedButton
    Left = 8
    Top = 90
    Width = 185
    Height = 32
    Caption = 'Listar Buckets'
    OnClick = btnbucketsClick
  end
  object btnArquivos: TSpeedButton
    Left = 199
    Top = 90
    Width = 185
    Height = 32
    Caption = 'Listar Arquivos'
    OnClick = btnArquivosClick
  end
  object btnBucket: TSpeedButton
    Left = 390
    Top = 48
    Width = 121
    Height = 32
    Caption = 'Criar Bucket'
    OnClick = btnBucketClick
  end
  object stat1: TStatusBar
    Left = 0
    Top = 581
    Width = 524
    Height = 19
    Panels = <
      item
        Width = 100
      end
      item
        Width = 100
      end
      item
        Width = 50
      end>
  end
  object lstlistabuckts: TListBox
    Left = 8
    Top = 128
    Width = 185
    Height = 447
    ItemHeight = 13
    TabOrder = 1
  end
  object lstListaArquivos: TListBox
    Left = 199
    Top = 128
    Width = 185
    Height = 447
    ItemHeight = 13
    TabOrder = 2
  end
  object edtBucket: TEdit
    Left = 8
    Top = 56
    Width = 376
    Height = 21
    TabOrder = 3
  end
  object amcAmazon: TAmazonConnectionInfo
    TableEndpoint = 'sdb.amazonaws.com'
    QueueEndpoint = 'queue.amazonaws.com'
    StorageEndpoint = 's3.amazonaws.com'
    Left = 408
    Top = 272
  end
  object dlgOpen1: TOpenDialog
    Left = 256
    Top = 304
  end
  object AmazonConnectionInfo1: TAmazonConnectionInfo
    TableEndpoint = 'sdb.amazonaws.com'
    QueueEndpoint = 'queue.amazonaws.com'
    StorageEndpoint = 's3.amazonaws.com'
    Left = 432
    Top = 288
  end
end
