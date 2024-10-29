program ProjectCEP;

uses
  Vcl.Forms,
  MainForm in 'MainForm.pas' {frmPrincipal},
  BusinessLogic in 'BusinessLogic.pas',
  DataModule in 'DataModule.pas' {DM: TDataModule},
  AtualizaEnderecoThread in 'AtualizaEnderecoThread.pas',
  InclusaoMassaThread in 'InclusaoMassaThread.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TfrmPrincipal, frmPrincipal);
  Application.CreateForm(TDM, DM);
  Application.Run;
end.
