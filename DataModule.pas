unit DataModule;

interface

uses
  System.SysUtils, System.Classes, FireDAC.Comp.Client, FireDAC.Stan.Def,
  FireDAC.Stan.Async, FireDAC.Phys, FireDAC.Phys.FB, FireDAC.VCLUI.Wait,
  System.Net.HttpClient, System.Net.HttpClientComponent, System.JSON,
  FireDAC.Stan.Param, FireDAC.DatS, Data.DB, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf,
  FireDAC.Stan.Pool, FireDAC.Phys.FBDef, FireDAC.DApt.Intf, FireDAC.DApt,
  System.Net.URLClient, FireDAC.Comp.DataSet;

type
  TEnderecoIntegracaoRecord = record
    idendereco: Int64;
    dsuf: string;
    nmcidade: string;
    nmbairro: string;
    nmlogradouro: string;
    dscomplemento: string;
  end;

  TDM = class(TDataModule)
    FDConnection: TFDConnection;
    FDQueryPessoas: TFDQuery;
    DataSource1: TDataSource;
    DataSource2: TDataSource;
    FDQueryEnderecos: TFDQuery;
    DataSource3: TDataSource;
    FDQueryEnderecoIntegracao: TFDQuery;
  private
    procedure UpdateEnderecoIntegracao(const Endereco: TEnderecoIntegracaoRecord);
  public
    constructor Create(AOwner: TComponent); override;

    procedure InsertPessoa(const dsdocumento, nmprimeiro, nmsegundo: string);
    procedure UpdatePessoa(idpessoa: Integer; const dsdocumento, nmprimeiro, nmsegundo: string);
    procedure DeletePessoa(idpessoa: Integer);
    procedure InsertEndereco(idpessoa: Integer; const dscep: string);
    procedure UpdateEndereco(idendereco: Integer; const dscep: string);
    procedure DeleteEndereco(idendereco: Integer);
    procedure InsertPessoasEmMassa(const ListaPessoas: TStringList);
    procedure AtualizarEnderecos; // Para atualizar os endereços no banco
  var
    vidEndereco : string;
  end;

var
  DM: TDM;

implementation

{%CLASSGROUP 'Vcl.Controls.TControl'}

uses AtualizaEnderecoThread, InclusaoMassaThread;

{$R *.dfm}

constructor TDM.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
end;

procedure TDM.UpdateEnderecoIntegracao(const Endereco: TEnderecoIntegracaoRecord);
begin
  FDQueryEnderecoIntegracao.SQL.Text :=
    'INSERT INTO endereco_integracao (idendereco, dsuf, nmcidade, nmbairro, nmlogradouro, dscomplemento) ' +
    'VALUES (:idendereco, :dsuf, :nmcidade, :nmbairro, :nmlogradouro, :dscomplemento)';

  FDQueryEnderecoIntegracao.Params.ParamByName('idendereco').AsLargeInt := StrToInt64(vidEndereco);
  FDQueryEnderecoIntegracao.Params.ParamByName('dsuf').AsString := Endereco.dsuf;
  FDQueryEnderecoIntegracao.Params.ParamByName('nmcidade').AsString := Endereco.nmcidade;
  FDQueryEnderecoIntegracao.Params.ParamByName('nmbairro').AsString := Endereco.nmbairro;
  FDQueryEnderecoIntegracao.Params.ParamByName('nmlogradouro').AsString := Endereco.nmlogradouro;
  FDQueryEnderecoIntegracao.Params.ParamByName('dscomplemento').AsString := Endereco.dscomplemento;

  FDQueryEnderecoIntegracao.ExecSQL;
end;

procedure TDM.AtualizarEnderecos;
var
  Endereco: TEnderecoIntegracaoRecord;
  AtualizaThread: TAtualizaEnderecoThread;
begin
  FDQueryEnderecos.Open;
  while not FDQueryEnderecos.Eof do
  begin
    try
      Endereco.idendereco := FDQueryEnderecos.FieldByName('idendereco').AsLargeInt;
      AtualizaThread := TAtualizaEnderecoThread.Create(FDQueryEnderecos.FieldByName('dscep').AsString,1{Atualizar}, FDConnection); // Insira o CEP desejado
      AtualizaThread.Start; // Inicia a execução da thread
    except
      on E: Exception do
    end;
    FDQueryEnderecos.Next;
  end;
end;

procedure TDM.InsertPessoa(const dsdocumento, nmprimeiro, nmsegundo: string);
begin
  FDQueryPessoas.SQL.Text := 'INSERT INTO pessoa (dsdocumento,flnatureza, nmprimeiro, nmsegundo, dtregistro) VALUES (:dsdocumento, :flnatureza,:nmprimeiro, :nmsegundo, :dtregistro)';
  FDQueryPessoas.Params.ParamByName('dsdocumento').AsString := dsdocumento;
  FDQueryPessoas.Params.ParamByName('flnatureza').AsInteger := 1;
  FDQueryPessoas.Params.ParamByName('nmprimeiro').AsString := nmprimeiro;
  FDQueryPessoas.Params.ParamByName('nmsegundo').AsString := nmsegundo;
  FDQueryPessoas.Params.ParamByName('dtregistro').AsDate := Date;
  FDQueryPessoas.ExecSQL;
end;

procedure TDM.UpdatePessoa(idpessoa: Integer; const dsdocumento, nmprimeiro, nmsegundo: string);
begin
  FDQueryPessoas.SQL.Text := 'UPDATE pessoa SET dsdocumento = :dsdocumento, nmprimeiro = :nmprimeiro, nmsegundo = :nmsegundo WHERE idpessoa = :idpessoa';
  FDQueryPessoas.Params.ParamByName('dsdocumento').AsString := dsdocumento;
  FDQueryPessoas.Params.ParamByName('nmprimeiro').AsString := nmprimeiro;
  FDQueryPessoas.Params.ParamByName('nmsegundo').AsString := nmsegundo;
  FDQueryPessoas.Params.ParamByName('idpessoa').AsInteger := idpessoa;
  FDQueryPessoas.ExecSQL;
end;

procedure TDM.DeletePessoa(idpessoa: Integer);
begin
  FDQueryPessoas.SQL.Text := 'DELETE FROM pessoa WHERE idpessoa = :idpessoa';
  FDQueryPessoas.Params.ParamByName('idpessoa').AsInteger := idpessoa;
  FDQueryPessoas.ExecSQL;
end;

procedure TDM.InsertEndereco(idpessoa: Integer; const dscep: string);
var
  AtualizaThread: TAtualizaEnderecoThread;
begin
  vidEndereco := '';
  FDQueryEnderecos.SQL.Text := 'INSERT INTO endereco (idpessoa, dscep) VALUES (:idpessoa, :dscep)';
  FDQueryEnderecos.Params.ParamByName('idpessoa').AsInteger := idpessoa;
  FDQueryEnderecos.Params.ParamByName('dscep').AsString := dscep;
  FDQueryEnderecos.ExecSQL;

  FDQueryEnderecos.SQL.Text := 'SELECT idendereco FROM endereco WHERE idpessoa = :idpessoa';
  FDQueryEnderecos.Params.ParamByName('idpessoa').AsInteger := idpessoa;
  FDQueryEnderecos.Open; // Abre a query para obter o id

  try
    if not FDQueryEnderecos.IsEmpty then
    begin
      vidEndereco := FDQueryEnderecos.FieldByName('idendereco').AsString; // Captura o id gerado
    end
    else
      raise Exception.Create('Nenhum endereço encontrado após a inserção.');
  finally
    FDQueryEnderecos.Close; // Fecha a consulta após obter o resultado
  end;
  AtualizaThread := TAtualizaEnderecoThread.Create(dscep, 2{inclusão}, FDConnection); // Insira o CEP desejado
  AtualizaThread.Start; // Inicia a execução da thread
end;

procedure TDM.UpdateEndereco(idendereco: Integer; const dscep: string);
var
  AtualizaThread: TAtualizaEnderecoThread;
begin
  FDQueryEnderecos.SQL.Text := 'UPDATE endereco SET dscep = :dscep WHERE idendereco = :idendereco';
  FDQueryEnderecos.Params.ParamByName('dscep').AsString := dscep;
  FDQueryEnderecos.Params.ParamByName('idendereco').AsInteger := idendereco;
  FDQueryEnderecos.ExecSQL;
  AtualizaThread := TAtualizaEnderecoThread.Create(dscep,1{alteração}, FDConnection); // Insira o CEP desejado
  AtualizaThread.Start; // Inicia a execução da thread
end;

procedure TDM.DeleteEndereco(idendereco: Integer);
begin
  FDQueryEnderecos.SQL.Text := 'DELETE FROM endereco WHERE idendereco = :idendereco';
  FDQueryEnderecos.Params.ParamByName('idendereco').AsInteger := idendereco;
  FDQueryEnderecos.ExecSQL;
end;

procedure TDM.InsertPessoasEmMassa(const ListaPessoas: TStringList);
var
  Pessoas: TArray<TPessoaEnderecoRecord>;
  InclusaoThread: TInclusaoMassaThread;
begin
  SetLength(Pessoas, 2);

  Pessoas[0].flnatureza := 1;
  Pessoas[0].dsdocumento := '12345678900';
  Pessoas[0].nmprimeiro := 'João';
  Pessoas[0].nmsegundo := 'Silva';
  Pessoas[0].dscep := '12345678';
  Pessoas[0].dsuf := 'SC';
  Pessoas[0].nmcidade := 'Concórdia';
  Pessoas[0].nmbairro := 'Centro';
  Pessoas[0].nmlogradouro := 'Rua A';
  Pessoas[0].dscomplemento := 'Apto 101';

  Pessoas[1].flnatureza := 1;
  Pessoas[1].dsdocumento := '98765432100';
  Pessoas[1].nmprimeiro := 'Maria';
  Pessoas[1].nmsegundo := 'Souza';
  Pessoas[1].dscep := '87654321';
  Pessoas[1].dsuf := 'SP';
  Pessoas[1].nmcidade := 'São Paulo';
  Pessoas[1].nmbairro := 'Centro';
  Pessoas[1].nmlogradouro := 'Avenida B';
  Pessoas[1].dscomplemento := 'Casa';
  // Cria e inicia a thread
  InclusaoThread := TInclusaoMassaThread.Create(Pessoas);
  InclusaoThread.Start;
end;

end.

