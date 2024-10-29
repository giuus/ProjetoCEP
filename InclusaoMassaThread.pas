unit InclusaoMassaThread;

interface

uses
  System.Classes, System.SysUtils, FireDAC.Comp.Client, DataModule; // Assumindo que TDM est� em DataModuleUnit

type
  TPessoaEnderecoRecord = record
    flnatureza: SmallInt;
    dsdocumento: string;
    nmprimeiro: string;
    nmsegundo: string;
    dscep: string;
    dsuf: string;
    nmcidade: string;
    nmbairro: string;
    nmlogradouro: string;
    dscomplemento: string;
  end;

  TInclusaoMassaThread = class(TThread)
  private
    FPessoas: TArray<TPessoaEnderecoRecord>;
    procedure InserirRegistrosEmMassa;
  protected
    procedure Execute; override;
  public
    constructor Create(const APessoas: TArray<TPessoaEnderecoRecord>);
  end;

implementation

{ TInclusaoMassaThread }

constructor TInclusaoMassaThread.Create(const APessoas: TArray<TPessoaEnderecoRecord>);
begin
  inherited Create(True); // Cria a thread em estado suspenso
  FreeOnTerminate := True; // Libera a thread automaticamente ap�s a execu��o
  FPessoas := APessoas;
end;

procedure TInclusaoMassaThread.Execute;
begin
  InserirRegistrosEmMassa;
end;

procedure TInclusaoMassaThread.InserirRegistrosEmMassa;
var
  PessoaQuery, EnderecoQuery: TFDQuery;
  i: Integer;
  PessoaID: Int64;
begin
  DM.FDConnection.StartTransaction;
  try
    PessoaQuery := TFDQuery.Create(nil);
    EnderecoQuery := TFDQuery.Create(nil);
    try
      PessoaQuery.Connection := DM.FDConnection;
      EnderecoQuery.Connection := DM.FDConnection;

      // Query para inserir uma pessoa e retornar o ID
      PessoaQuery.SQL.Text := 'INSERT INTO pessoa (flnatureza, dsdocumento, nmprimeiro, nmsegundo, dtregistro) ' +
                              'VALUES (:flnatureza, :dsdocumento, :nmprimeiro, :nmsegundo, CURRENT_DATE) ' +
                              'RETURNING idpessoa';

      // Query para inserir um endere�o vinculado � pessoa
      EnderecoQuery.SQL.Text := 'INSERT INTO endereco (idpessoa, dscep) VALUES (:idpessoa, :dscep)';

      // Executa a inser��o para cada registro
      for i := 0 to High(FPessoas) do
      begin
        // Inser��o de Pessoa
        PessoaQuery.ParamByName('flnatureza').AsSmallInt := FPessoas[i].flnatureza;
        PessoaQuery.ParamByName('dsdocumento').AsString := FPessoas[i].dsdocumento;
        PessoaQuery.ParamByName('nmprimeiro').AsString := FPessoas[i].nmprimeiro;
        PessoaQuery.ParamByName('nmsegundo').AsString := FPessoas[i].nmsegundo;
        PessoaQuery.Open;
        PessoaID := PessoaQuery.Fields[0].AsLargeInt; // Obt�m o ID gerado para a pessoa
        PessoaQuery.Close;

        // Inser��o de Endere�o vinculado � Pessoa
        EnderecoQuery.ParamByName('idpessoa').AsLargeInt := PessoaID;
        EnderecoQuery.ParamByName('dscep').AsString := FPessoas[i].dscep;
        EnderecoQuery.ExecSQL;
      end;

      DM.FDConnection.Commit; // Comita a transa��o ap�s o lote
    finally
      PessoaQuery.Free;
      EnderecoQuery.Free;
    end;
  except
    on E: Exception do
    begin
      DM.FDConnection.Rollback; // Rollback em caso de erro
      raise Exception.Create('Erro ao inserir registros em massa: ' + E.Message);
    end;
  end;
end;

end.

