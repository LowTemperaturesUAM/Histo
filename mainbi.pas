unit main;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, xyyGraph, ClipBrd ;

type
  TMainForm = class(TForm)
    SourceBLQ: TEdit;
    Start: TButton;
    currentcurve: TLabel;
    G: TxyyGraph;
    Copy: TButton;
    Select: TButton;
    Even: TCheckBox;
    Odd: TCheckBox;
    MaxCurrent: TEdit;
    Label1: TLabel;
    OpenDlg: TOpenDialog;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure StartClick(Sender: TObject);
    procedure CopyClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure SelectClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  MainForm: TMainForm;

implementation

{$R *.DFM}

uses blqLoader,blqDataSet, Info ;


var
  his : array [0..1000] of integer ;
  hisbox : double = 2E-6 ;

  b : TblqLoader ;
  DS : TblqDataSet ;


procedure TMainForm.FormCreate(Sender: TObject);
begin
  b:=TblqLoader.Create(Self) ;
end;

procedure TMainForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  b.Free ;
end;

procedure TMainForm.StartClick(Sender: TObject);
var
  i,j,k,offset : integer ;
  blqname : string ;
  index : integer ;
  f : double ;
begin //
  for i:=0 to 999 do his[i]:=0 ;

  hisBox:=StrToFloat(MaxCurrent.Text)/1000 ;

  blqname:=sourceblq.text ;

  InfoForm.Mensaje.Caption:='Loading BLQ...' ;
  InfoForm.Show ;
  InfoForm.Refresh ;
  b.SelectBlockFile(blqname) ;
  InfoForm.Close ;


  for k:=0 to b.Count-1 do begin
    currentcurve.caption:=IntToStr(k) ;
    Application.ProcessMessages ;

    // PARES
    if Even.Checked and ((2*(k div 2))=k) then begin

      offset:=b.GetEntryOffset(k) ;
      LoadDataSetFromBlock(blqname,offset,DS) ;

      for i:=0 to DS.nrows-1 do begin
        f:=abs(DS[1].Value[i]) ;
        index:=Round(f/hisbox) ;
        if (index>=0) and (index<1000) then his[index]:=his[index]+1 ;
      end ;

    end ;

    // IMPARES
    if Odd.Checked and ((2*(k div 2))<>k) then begin

      offset:=b.GetEntryOffset(k) ;
      LoadDataSetFromBlock(blqname,offset,DS) ;

      for i:=0 to DS.nrows-1 do begin
        f:=abs(DS[1].Value[i]) ;
        index:=Round(f/hisbox) ;
        if (index>=0) and (index<1000) then his[index]:=his[index]+1 ;
      end ;

    end ;

  end ;


  G.Clear ;
  for i:=0 to 999 do begin
    G[1].AddPoint(i*hisbox,his[i]) ;
  end ;
  G.Update ;


end;

procedure TMainForm.CopyClick(Sender: TObject);
var
  i : integer ;
  s : string ;
begin

  InfoForm.Mensaje.Caption:='Copying to clipboard...' ;
  InfoForm.Show ;
  InfoForm.Refresh ;

  s:='' ;


  for i:=0 to 999 do begin
    s:=s+FloatToStrF(G[1].x[i],ffExponent,8,2)+#9 ;
    s:=s+FloatToStrF(G[1].y[i],ffExponent,8,2)+#10#13 ;
  end ;

  Clipboard.AsText:=s ;

  InfoForm.Close ;

end;

procedure TMainForm.FormShow(Sender: TObject);
begin
  G.XAxis.Title:='Current (A)' ;
  G.YAxis.Title:='Counts' ;
end;

procedure TMainForm.SelectClick(Sender: TObject);
begin
  if OpenDlg.Execute then begin
    SourceBlq.Text:=OpenDlg.FileName ;
  end ;
end;

end.
