program hisQ;

uses
  Forms,
  main in 'main.pas' {Topsigma},
  Info in 'Info.pas' {InfoForm},
  blqDataSet in '..\bloq\blqDataSet.pas' {blqDataSetForm},
  blqLoader in '..\bloq\blqLoader.pas' {blqLoaderForm};

{$R *.RES}

begin
  Application.Initialize;
  Application.Title := 'Hystogram';
  Application.CreateForm(TTopsigma, Topsigma);
  Application.CreateForm(TInfoForm, InfoForm);
  Application.CreateForm(TblqDataSetForm, blqDataSetForm);
  Application.CreateForm(TblqLoaderForm, blqLoaderForm);
  Application.Run;
end.
