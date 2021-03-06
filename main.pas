unit main;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, ClipBrd, Spin, xyyGraph ;

type
  TTopsigma = class(TForm)
    SourceBLQ: TEdit;
    Start: TButton;
    currentcurve: TLabel;
    Select: TButton;
    Even: TCheckBox;
    Odd: TCheckBox;
    MaxCurrent: TEdit;
    Label1: TLabel;
    OpenDlg: TOpenDialog;
    HystoColumn: TRadioGroup;
    PointNr: TRadioGroup;
    Number: TSpinEdit;
    CurveNumber: TLabel;
    CurrentatNr: TEdit;
    Current: TLabel;
    Topsigma: TEdit;
    Label2: TLabel;
    MakeHystoindsdV: TButton;
    CopyGraph: TButton;
    MakeHystoofMean: TButton;
    PlotEachPoint: TCheckBox;
    PlotGroup: TRadioGroup;
    HystoGraph: TxyyGraph;
    OnlyLastContact: TCheckBox;
    PositionZero: TEdit;
    NBeforezero: TLabel;
    DataBeforeZero: TEdit;
    LastContact: TButton;
    MaxILC: TEdit;
    Label3: TLabel;
    EndCountLC: TEdit;
    Label4: TLabel;
    MaxDistance: TEdit;
    Label5: TLabel;
    Memo1: TMemo;
    Label6: TLabel;
    WhereStop: TEdit;
    Label7: TLabel;
    DistShow: TEdit;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure StartClick(Sender: TObject);
    procedure NumberChange(Sender: TObject);
    procedure MakeHystoindsdVClick(Sender: TObject);
    procedure SelectClick(Sender: TObject);
    procedure CopyGraphClick(Sender: TObject);
    procedure MakeHystoofMeanClick(Sender: TObject);
    procedure LastContactClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Topsigma: TTopsigma;

implementation

{$R *.DFM}

uses blqLoader,blqDataSet, Info ;


var
  his : array [-1000..1000] of integer ;
  dsigmadV: array [0..1000] of double;
  meandV: array[0..1000] of double;
  squaredV: array[0..1000] of double;
  meandevdV: array[0..1000] of double;
  hisbox : Extended = 2E-6 ;
  his_sigma : array [0..1000,0..10000] of Double ;
  his_sigma_nr : array [0..1000] of integer ;
  his_sigma_I : array [0..1000] of integer ;
  hisbox_sigma : double = 10 ;

  b : TblqLoader ;
  DS : TblqDataSet ;
  MAXPOINT: Integer;

procedure TTopsigma.FormCreate(Sender: TObject);
begin
  b:=TblqLoader.Create(Self) ;
end;

procedure TTopsigma.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  b.Free ;
end;

procedure TTopsigma.StartClick(Sender: TObject);
var
  i,j,k,offset,DataBeforeCount : integer ;
  blqname : string ;
  index, MiStop : integer ;
  f,ff,tograph,wherezero,Countlessthan : double ;
begin //
  MiStop:=StrtoInt(WhereStop.Text);
  for i:=0 to 999 do his[i]:=0 ;
  for i:=0 to 999 do his_sigma_nr[i]:=0 ;
  for i:=0 to 999 do
        begin
        for j:=0 to 999 do his_sigma[i,j]:=0 ;
        end;
  if(PointNr.ItemIndex=4) then MAXPOINT:=1000;
  if(PointNr.ItemIndex=3) then MAXPOINT:=200;
  if(PointNr.ItemIndex=2) then MAXPOINT:=100;
  if(PointNr.ItemIndex=1) then MAXPOINT:=50;
  if(PointNr.ItemIndex=0) then MAXPOINT:=10;

  hisBox:=StrToFloat(MaxCurrent.Text)/MAXPOINT ;
  hisbox_sigma:= StrToFloat(Topsigma.Text)/MAXPOINT;

  blqname:=sourceblq.text ;

  InfoForm.Mensaje.Caption:='Loading BLQ...' ;
  InfoForm.Show ;
  InfoForm.Refresh ;
  b.SelectBlockFile(blqname) ;
  InfoForm.Close ;

      CountLessthan:=StrtoFloat(PositionZero.Text);
        DataBeforeCount:=StrtoInt(DatabeforeZero.Text);
  if (MiStop>b.Count) then     MiStop:= b.Count;

  for k:=0 to MiStop-1 do
  begin
    currentcurve.caption:=IntToStr(k) ;
    Application.ProcessMessages ;

    // PARES
    if Even.Checked and ((2*(k div 2))=k) then
    begin

      offset:=b.GetEntryOffset(k) ;
      LoadDataSetFromBlock(blqname,offset,DS) ;

      for i:=0 to DS.nrows-1 do begin
        f:=abs(DS[1].Value[i]) ;
        index:=Round(f/hisbox) ;
        if (index>=0) and (index<MAXPOINT) then
        begin
        if(OnlyLastContact.Checked=False) then
        begin
        if(HystoColumn.ItemIndex=1) then
                begin
                ff:=DS[2].Value[i];
                his_sigma_nr[index]:=his_sigma_nr[index]+1;// saco I
                his_sigma[index,his_sigma_nr[index]]:=ff;
                end
        else         his[index]:=his[index]+1 ;
        end
        else
        if(i>DataBeforeCount+1) then
                begin
                WhereZero:=abs(DS[1].Value[i-DataBeforeCount]);  // It is EVEN
                if ((f>CountLessthan) and (WhereZero<CountLessthan))
                 then his[index]:=his[index]+1 ;
                end;
        end;
      end ;

    end ;// FIN PARES

    // IMPARES
    if Odd.Checked and ((2*(k div 2))<>k) then
    begin

      offset:=b.GetEntryOffset(k) ;
      LoadDataSetFromBlock(blqname,offset,DS) ;

      for i:=0 to DS.nrows-1 do
       begin
        f:=abs(DS[1].Value[i]) ;
        index:=Round(f/hisbox) ;
        if (index>=0) and (index<MAXPOINT) then
        begin
        if(OnlyLastContact.Checked=False) then
         begin
         if(HystoColumn.ItemIndex=1) then
                begin
                ff:=DS[2].Value[i];
                his_sigma_nr[index]:=his_sigma_nr[index]+1;// saco I
                his_sigma[index,his_sigma_nr[index]]:=ff;
               end
         else his[index]:=his[index]+1 ;
         end
        else
        if(i<(DS.nrows-DataBeforeCount-1)) then
                begin
                WhereZero:=abs(DS[1].Value[i+DataBeforeCount]);  // It is ODD
                if ((f>CountLessthan) and (WhereZero<CountLessthan))
                 then his[index]:=his[index]+1 ;
                end;
        end;
       end ;
     end ; // FIN IMPARES

 end ;  // fin  for k:=0 to b.Count-1 do
 

     // todos los datos estan en memoria

  HystoGraph.Clear ;
//  HystoGraph[1].holdupdates := true;
  for i:=0 to (MAXPOINT-1) do begin
  if(HystoColumn.ItemIndex=0) then HystoGraph[1].AddPoint(i*hisbox,his[i]);
        end ;
  HystoGraph[1].PlotPoints := False;


end;


procedure TTopsigma.NumberChange(Sender: TObject);
begin
 if(Number.Value>0) then begin
 Currentatnr.Text:=FloattoStr(Number.Value*hisbox);
 if (HystoColumn.ItemIndex=1) then MakeHystoindsdVClick(nil);
 end;
end;

procedure TTopsigma.MakeHystoindsdVClick(Sender: TObject);
var
i,indexb: Integer;
g,Actualcurrent: Double;

begin
for i:=-999 to 999 do his[i]:=0 ;
indexb:=0;
for i:=0 to his_sigma_nr[Number.Value] do //  Number.value me da el valor de corriente
begin
indexb:=Round(his_sigma[Number.Value,i]/hisbox_sigma);
his[indexb]:=his[indexb]+1;
end;

if(PlotEachPoint.Checked) then begin
  HystoGraph.Clear ;
  //HystoGraph[1].holdupdates := true;
  for i:=-(Round(MAXPOINT/2)-1) to (Round(MAXPOINT/2)-1) do
        HystoGraph[1].AddPoint(i*hisbox_sigma,his[i]);
  //HystoGraph[1].holdupdates := false;
  //HystoGraph.xaxis.autosizing:=True;
  //HystoGraph.yaxis.autosizing:=True;
end;


end;

procedure TTopsigma.SelectClick(Sender: TObject);
begin
  if OpenDlg.Execute then begin
    SourceBlq.Text:=OpenDlg.FileName ;
  end ;
end;

procedure TTopsigma.CopyGraphClick(Sender: TObject);
var
  i : integer ;
  s : string ;
  x,y,r: Double;
begin

  InfoForm.Mensaje.Caption:='Copying to clipboard...' ;
  InfoForm.Show ;
  InfoForm.Refresh ;

  s:='' ;

  for i:=0 to (MAXPOINT-1) do begin
    x:=HystoGraph[1].x[i];
    y:=HystoGraph[1].y[i];
    s:=s+FloatToStrF(x,ffExponent,8,2)+#9 ;
    s:=s+FloatToStrF(y,ffExponent,8,2)+#10#13 ;
  end ;

  Clipboard.AsText:=s ;

  InfoForm.Close ;

end;
procedure TTopsigma.MakeHystoofMeanClick(Sender: TObject);
var
i,j,indexc,micount: Integer;
square,mean,x: Double;
y: Integer;
begin
for i:=0 to 999 do dsigmadV[i]:=0 ;
indexc:=0;
for i:=0 to MAXPOINT-1 do //  Number.value me da el valor de corriente
begin
Application.ProcessMessages;
Number.Value:=i;
indexc:=Number.Value; // corriente
MakeHystoindsdVClick(nil); // hace histograma
square:=0;
mean:=0;
micount:=0;
for j:=-(Round(MAXPOINT/2)-1) to (Round(MAXPOINT/2)-1) do
    begin
    //HystoGraph[1].GetPoint(j,x,y,r);
    x:=j*hisbox_sigma;
    y:=his[j];
    if(y>0) then begin
    square:=square+x*x*y;
    mean:=mean+x*y;
    micount:=micount+y;
    end;
    end;
if(micount>0) then begin
    square:=square/micount;
    mean:=mean/micount;
    end;
meandV[indexc]:=mean;
squaredV[indexc]:=square;
if(square>mean) then meandevdV[indexc]:=sqrt(square-mean);
if(PlotGroup.ItemIndex=0) then dsigmadV[indexc]:=mean;
if(PlotGroup.ItemIndex=1) then dsigmadV[indexc]:=square;
if((PlotGroup.ItemIndex=2) and (square>mean)) then
        dsigmadV[indexc]:=sqrt(square-mean);
end;

  HystoGraph.Clear ;
 // HystoGraph[1].holdupdates := true;
  for i:=0 to MAXPOINT-1 do  HystoGraph[1].AddPoint(i*hisbox,dsigmadV[i]);
  //HystoGraph[1].holdupdates := false;
  //HystoGraph.xaxis.autosizing:=True;
  //HystoGraph.yaxis.autosizing:=True;


end;

procedure TTopsigma.LastContactClick(Sender: TObject);
var
  i,j,k,offset,DataBeforeCount : integer ;
  blqname : string ;
  index, MiStop : integer ;
  f,ff,tograph,wherezero,Countlessthan : Extended ;
  XIni,XFin,DeltaX,MinSigma,MaxSigma,Showfrom: Extended;
  EstoyOccupied,testruido: integer;

begin //
  MiStop:=StrtoInt(WhereStop.Text);
  Showfrom:=Strtofloat(DistShow.Text)*1e-9;
  for i:=0 to 999 do his[i]:=0 ;
  for i:=0 to 999 do his_sigma_nr[i]:=0 ;
  for i:=0 to 999 do
        begin
        for j:=0 to 999 do his_sigma[i,j]:=0 ;
        end;
  if(PointNr.ItemIndex=4) then MAXPOINT:=1000;
  if(PointNr.ItemIndex=3) then MAXPOINT:=200;
  if(PointNr.ItemIndex=2) then MAXPOINT:=100;
  if(PointNr.ItemIndex=1) then MAXPOINT:=50;
  if(PointNr.ItemIndex=0) then MAXPOINT:=10;
  EstoyOccupied:=0;
  testruido:=0;
  XFin:=0;
  XIni:=0;
  DeltaX:=0;
  MinSigma:=StrToFloat(EndCountLC.Text);
  MaxSigma:=StrToFloat(MaxILC.Text);

  hisBox:=StrToFloat(MaxDistance.Text)*1e-9/MAXPOINT ;
  blqname:=sourceblq.text ;

  InfoForm.Mensaje.Caption:='Loading BLQ...' ;
  InfoForm.Show ;
  InfoForm.Refresh ;
  b.SelectBlockFile(blqname) ;
  InfoForm.Close ;

      CountLessthan:=StrtoFloat(PositionZero.Text);
        DataBeforeCount:=StrtoInt(DatabeforeZero.Text);

  if (MiStop>b.Count) then     MiStop:= b.Count;

  for k:=0 to MiStop-1 do
  begin
    currentcurve.caption:=IntToStr(k) ;
    Application.ProcessMessages ;

    // PARES
    if Even.Checked and ((2*(k div 2))=k) then
    begin

      offset:=b.GetEntryOffset(k) ;
      LoadDataSetFromBlock(blqname,offset,DS) ;

      for i:=0 to DS.nrows-1 do begin
        f:=abs(DS[1].Value[i]) ;
        if ((EstoyOccupied=0) and ((f<MaxSigma) and (f>MinSigma ))) then  // se entra
         begin
         testruido:=testruido+1;   // 2 puntos seguidos en los que se entra
         if (testruido>5) then
           begin
           EstoyOccupied:=1;
           XIni:=DS[0].Value[i];
           testruido:=0;
           end;
         end;
        if ((EstoyOccupied=1) and ((f>=MaxSigma) or (f<=MinSigma ))) then  // se sale
            begin
            XFin:=DS[0].Value[i];
            DeltaX:=abs(XFin-XIni);
            index:=Round(DeltaX/hisbox) ;
            if (index>=1) and (index<MAXPOINT) then
              begin
              his[index]:=his[index]+1 ;
              if (DeltaX>Showfrom) then
                Memo1.Text:=Memo1.Text+#13+#10+InttoStr(k);
              end;
            EstoyOccupied:=0;
            end;
        end;
      end;

    // IMPARES
    if Odd.Checked and ((2*(k div 2))<>k) then
    begin

      offset:=b.GetEntryOffset(k) ;
      LoadDataSetFromBlock(blqname,offset,DS) ;

      for i:=0 to DS.nrows-1 do begin
        f:=abs(DS[1].Value[i]) ;
       if ((EstoyOccupied=0) and ((f<MaxSigma) and (f>MinSigma ))) then  // se entra
         begin
         testruido:=testruido+1;   // 2 puntos seguidos en los que se entra
         if (testruido>5) then
           begin
           EstoyOccupied:=1;
           XIni:=DS[0].Value[i];
           testruido:=0;
           end;
         end;
        if ((EstoyOccupied=1) and ((f>=MaxSigma) or (f<=MinSigma ))) then  // se sale
            begin
            XFin:=DS[0].Value[i];
            DeltaX:=abs(XFin-XIni);
            index:=Round(DeltaX/hisbox) ;
            if (index>=1) and (index<MAXPOINT) then
              begin
              his[index]:=his[index]+1 ;
              if (DeltaX>Showfrom) then Memo1.Text:=Memo1.Text+#13+#10+InttoStr(k);
              end;
            EstoyOccupied:=0;
            end;
        end;
    end ; // FIN IMPARES

 end ;  // fin  for k:=0 to b.Count-1 do


     // todos los datos estan en memoria

  HystoGraph.Clear ;
//  HystoGraph[1].holdupdates := true;
  for i:=0 to (MAXPOINT-1) do begin
  if(HystoColumn.ItemIndex=0) then HystoGraph[1].AddPoint(i*hisbox,his[i]);
        end ;
  HystoGraph[1].PlotPoints := False;


end;

end.
