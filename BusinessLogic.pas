unit BusinessLogic;

interface

uses
  DataModule, System.Generics.Collections, Classes;

type
  TPessoaRecord = record
    idpessoa: Integer;
    dsdocumento: string;
    nmprimeiro: string;
    nmsegundo: string;
  end;

  TEnderecoRecord = record
    idendereco: Integer;
    idpessoa: Integer;
    dscep: string;
  end;

  TEnderecoIntegracaoRecord = record
    idintegracao: Integer;
    idendereco: Int64; // Mudando para Int64 para BIGINT
    dsuf: string;
    nmcidade: string;
    nmbairro: string;
    nmlogradouro: string;
    dscomplemento: string;
  end;

  TBusinessLogic = class
  public
    procedure CadastrarPessoa(const dsdocumento, nmprimeiro, nmsegundo: string);
    procedure AtualizarPessoa(idpessoa: Integer; const dsdocumento, nmprimeiro, nmsegundo: string);
    procedure DeletarPessoa(idpessoa: Integer);
    procedure CadastrarEndereco(idpessoa: Integer; const dscep: string);
    procedure AtualizarEndereco(idendereco: Integer; const dscep: string);
    procedure DeletarEndereco(idendereco: Integer);
    procedure CadastrarPessoasEmMassa(const ListaPessoas: TStringList);
    procedure AtualizarEnderecos;
    function ListarPessoas: TList<TPessoaRecord>;
    function ListarEnderecos: TList<TEnderecoRecord>;
    function ListarEnderecosIntegracao: TList<TEnderecoIntegracaoRecord>;
  end;

implementation

{ TBusinessLogic }

procedure TBusinessLogic.CadastrarPessoa(const dsdocumento, nmprimeiro, nmsegundo: string);
begin
  DM.InsertPessoa(dsdocumento, nmprimeiro, nmsegundo);
end;

procedure TBusinessLogic.AtualizarPessoa(idpessoa: Integer; const dsdocumento, nmprimeiro, nmsegundo: string);
begin
  DM.UpdatePessoa(idpessoa, dsdocumento, nmprimeiro, nmsegundo);
end;

procedure TBusinessLogic.DeletarPessoa(idpessoa: Integer);
begin
  DM.DeletePessoa(idpessoa);
end;

procedure TBusinessLogic.CadastrarEndereco(idpessoa: Integer; const dscep: string);
begin
  DM.InsertEndereco(idpessoa, dscep);
end;

procedure TBusinessLogic.AtualizarEndereco(idendereco: Integer; const dscep: string);
begin
  DM.UpdateEndereco(idendereco, dscep);
end;

procedure TBusinessLogic.DeletarEndereco(idendereco: Integer);
begin
  DM.DeleteEndereco(idendereco);
end;

procedure TBusinessLogic.CadastrarPessoasEmMassa(const ListaPessoas: TStringList);
begin
  DM.InsertPessoasEmMassa(ListaPessoas);
end;

procedure TBusinessLogic.AtualizarEnderecos;
begin
  DM.AtualizarEnderecos;
end;

function TBusinessLogic.ListarPessoas: TList<TPessoaRecord>;
var
  ListaPessoas: TList<TPessoaRecord>;
begin
  ListaPessoas := TList<TPessoaRecord>.Create;
  try
    DM.FDQueryPessoas.Close;
    DM.FDQueryPessoas.SQL.Text := 'SELECT idpessoa, dsdocumento, nmprimeiro, nmsegundo FROM Pessoas';
    DM.FDQueryPessoas.Open;

    while not DM.FDQueryPessoas.Eof do
    begin
      var Pessoa: TPessoaRecord;
      Pessoa.idpessoa := DM.FDQueryPessoas.FieldByName('idpessoa').AsInteger;
      Pessoa.dsdocumento := DM.FDQueryPessoas.FieldByName('dsdocumento').AsString;
      Pessoa.nmprimeiro := DM.FDQueryPessoas.FieldByName('nmprimeiro').AsString;
      Pessoa.nmsegundo := DM.FDQueryPessoas.FieldByName('nmsegundo').AsString;

      ListaPessoas.Add(Pessoa);
      DM.FDQueryPessoas.Next;
    end;

    Result := ListaPessoas;
  except
    ListaPessoas.Free;
    raise;
  end;
end;

function TBusinessLogic.ListarEnderecos: TList<TEnderecoRecord>;
var
  ListaEnderecos: TList<TEnderecoRecord>;
begin
  ListaEnderecos := TList<TEnderecoRecord>.Create;
  try
    DM.FDQueryEnderecos.Close;
    DM.FDQueryEnderecos.SQL.Text := 'SELECT idendereco, idpessoa, dscep FROM Enderecos';
    DM.FDQueryEnderecos.Open;

    while not DM.FDQueryEnderecos.Eof do
    begin
      var Endereco: TEnderecoRecord;
      Endereco.idendereco := DM.FDQueryEnderecos.FieldByName('idendereco').AsInteger;
      Endereco.idpessoa := DM.FDQueryEnderecos.FieldByName('idpessoa').AsInteger;
      Endereco.dscep := DM.FDQueryEnderecos.FieldByName('dscep').AsString;

      ListaEnderecos.Add(Endereco);
      DM.FDQueryEnderecos.Next;
    end;

    Result := ListaEnderecos;
  except
    ListaEnderecos.Free;
    raise;
  end;
end;

function TBusinessLogic.ListarEnderecosIntegracao: TList<TEnderecoIntegracaoRecord>;
var
  ListaIntegracao: TList<TEnderecoIntegracaoRecord>;
begin
  ListaIntegracao := TList<TEnderecoIntegracaoRecord>.Create;
  try
    DM.FDQueryEnderecoIntegracao.Close;
    DM.FDQueryEnderecoIntegracao.SQL.Text := 'SELECT idintegracao, idendereco, dsuf, nmcidade, nmbairro, nmlogradouro, dscomplemento FROM endereco_integracao';
    DM.FDQueryEnderecoIntegracao.Open;

    while not DM.FDQueryEnderecoIntegracao.Eof do
    begin
      var Integracao: TEnderecoIntegracaoRecord;
      Integracao.idintegracao := DM.FDQueryEnderecoIntegracao.FieldByName('idintegracao').AsInteger;
      Integracao.idendereco := DM.FDQueryEnderecoIntegracao.FieldByName('idendereco').AsInteger; // BIGINT
      Integracao.dsuf := DM.FDQueryEnderecoIntegracao.FieldByName('dsuf').AsString;
      Integracao.nmcidade := DM.FDQueryEnderecoIntegracao.FieldByName('nmcidade').AsString;
      Integracao.nmbairro := DM.FDQueryEnderecoIntegracao.FieldByName('nmbairro').AsString;
      Integracao.nmlogradouro := DM.FDQueryEnderecoIntegracao.FieldByName('nmlogradouro').AsString;
      Integracao.dscomplemento := DM.FDQueryEnderecoIntegracao.FieldByName('dscomplemento').AsString;

      ListaIntegracao.Add(Integracao);
      DM.FDQueryEnderecoIntegracao.Next;
    end;

    Result := ListaIntegracao;
  except
    ListaIntegracao.Free;
    raise;
  end;
end;
end.

