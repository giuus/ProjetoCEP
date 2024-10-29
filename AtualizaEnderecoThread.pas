unit AtualizaEnderecoThread;

interface

uses
  System.Classes, System.SysUtils, System.Net.HttpClient, System.JSON, System.Net.HttpClientComponent, FireDAC.Comp.Client, DataModule;

type
  // Defina o registro que ir� armazenar os dados do endere�o
  TEnderecoIntegracaoRecord = record
    dsuf: string;
    nmcidade: string;
    nmbairro: string;
    nmlogradouro: string;
    dscomplemento: string;
  end;

  TAtualizaEnderecoThread = class(TThread)
  private
    FCep: string;
    FTipo: Integer;
    FEndereco: TEnderecoIntegracaoRecord;
    FConnection: TFDConnection; // Conex�o com o banco de dados FireDAC
    procedure AtualizarTabela;
    procedure IncluirDadosNaTabela;
  protected
    procedure Execute; override;
  public
    constructor Create(const ACep: string; const ATipo: integer; AConnection: TFDConnection);
  end;

implementation

{ TAtualizaEnderecoThread }

constructor TAtualizaEnderecoThread.Create(const ACep: string; const ATipo: integer; AConnection: TFDConnection);
begin
  inherited Create(True); // Cria a thread em estado suspenso
  FreeOnTerminate := True; // Libera a thread automaticamente ap�s a execu��o
  FCep := ACep;
  FTipo := ATipo;
  FConnection := AConnection; // Passa a conex�o para a thread
end;

procedure TAtualizaEnderecoThread.Execute;
var
  Response: IHTTPResponse;
  JsonObject: TJSONObject;
  HttpClient: TNetHTTPClient;
begin
  HttpClient := TNetHTTPClient.Create(nil);
  try
    Response := HttpClient.Get('https://viacep.com.br/ws/' + FCep + '/json/');
    if Response.StatusCode = 200 then
    begin
      JsonObject := TJSONObject.ParseJSONValue(Response.ContentAsString) as TJSONObject;
      try
        FEndereco.dsuf := JsonObject.GetValue<string>('uf', '');
        FEndereco.nmcidade := JsonObject.GetValue<string>('localidade', '');
        FEndereco.nmbairro := JsonObject.GetValue<string>('bairro', '');
        FEndereco.nmlogradouro := JsonObject.GetValue<string>('logradouro', '');
        FEndereco.dscomplemento := JsonObject.GetValue<string>('complemento', '');
        // Chama o m�todo para atualizar a tabela
        if FTipo = 1 then
          Synchronize(AtualizarTabela)
        else if FTipo = 2 then
          Synchronize(IncluirDadosNaTabela)
      finally
        JsonObject.Free;
      end;
    end
    else
      raise Exception.Create('Erro ao buscar CEP: ' + Response.StatusText);
  finally
    HttpClient.Free;
  end;
end;

procedure TAtualizaEnderecoThread.AtualizarTabela;
var
  Query: TFDQuery;
begin
  Query := TFDQuery.Create(nil);
  try
    Query.Connection := FConnection; // Usa a conex�o passada
    Query.SQL.Text := 'UPDATE endereco_integracao ' +
                      'SET dsuf = :dsuf, nmcidade = :nmcidade, nmbairro = :nmbairro, ' +
                      'nmlogradouro = :nmlogradouro, dscomplemento = :dscomplemento ' +
                      'WHERE idendereco = :idendereco'; // Supondo que h� uma coluna "cep" na tabela

    // Define os par�metros
    Query.ParamByName('dsuf').AsString := FEndereco.dsuf;
    Query.ParamByName('nmcidade').AsString := FEndereco.nmcidade;
    Query.ParamByName('nmbairro').AsString := FEndereco.nmbairro;
    Query.ParamByName('nmlogradouro').AsString := FEndereco.nmlogradouro;
    Query.ParamByName('dscomplemento').AsString := FEndereco.dscomplemento;
    Query.ParamByName('idendereco').AsString := dm.vidEndereco; // Use o CEP como chave para atualiza��o

    Query.ExecSQL; // Executa o comando SQL
  finally
    Query.Free;
  end;
end;

procedure TAtualizaEnderecoThread.IncluirDadosNaTabela;
var
  Query: TFDQuery;
begin
  Query := TFDQuery.Create(nil);
  try
    Query.Connection := FConnection; // Usa a conex�o passada
    Query.SQL.Text := 'INSERT INTO endereco_integracao (idendereco, dsuf, nmcidade, nmbairro, nmlogradouro, dscomplemento) ' +
    'VALUES (:idendereco, :dsuf, :nmcidade, :nmbairro, :nmlogradouro, :dscomplemento)';

    // Define os par�metros
    Query.ParamByName('idendereco').AsString := dm.vidEndereco;
    Query.ParamByName('dsuf').AsString := FEndereco.dsuf;
    Query.ParamByName('nmcidade').AsString := FEndereco.nmcidade;
    Query.ParamByName('nmbairro').AsString := FEndereco.nmbairro;
    Query.ParamByName('nmlogradouro').AsString := FEndereco.nmlogradouro;
    Query.ParamByName('dscomplemento').AsString := FEndereco.dscomplemento;

    Query.ExecSQL; // Executa o comando SQL
  finally
    Query.Free;
  end;
end;

end.

