unit MainForm;

interface

uses
  Vcl.Forms, Vcl.Controls, Vcl.StdCtrls, Vcl.Grids, Vcl.DBGrids, Data.DB,
  Vcl.Dialogs, System.Generics.Collections, BusinessLogic, System.SysUtils,
  System.Classes, DataModule;

type
  TFrmPrincipal = class(TForm)
    btnCadastrarPessoa: TButton;
    btnAtualizarPessoa: TButton;
    btnDeletarPessoa: TButton;
    btnCadastrarEndereco: TButton;
    btnCadastrarEmMassa: TButton;
    edtDocumento: TEdit;
    edtNome: TEdit;
    edtSobrenome: TEdit;
    edtCep: TEdit;
    lblDocumento: TLabel;
    lblNome: TLabel;
    lblSobrenome: TLabel;
    lblCep: TLabel;
    DBGrid1: TDBGrid;
    DBGrid2: TDBGrid;
    Label1: TLabel;
    Label2: TLabel;
    btnAtualizarEndereco: TButton;
    procedure btnCadastrarPessoaClick(Sender: TObject);
    procedure btnAtualizarPessoaClick(Sender: TObject);
    procedure btnDeletarPessoaClick(Sender: TObject);
    procedure btnCadastrarEnderecoClick(Sender: TObject);
    procedure btnAtualizarEnderecoClick(Sender: TObject);
    procedure btnDeletarEnderecoClick(Sender: TObject);
    procedure btnCadastrarEmMassaClick(Sender: TObject);
    procedure btnAtualizarEnderecosClick(Sender: TObject); // para exibir dados dos endereços
  private
    FBusinessLogic: TBusinessLogic;
    procedure CadastrarPessoa;
    procedure AtualizarPessoa;
    procedure DeletarPessoa;
    procedure CadastrarEndereco;
    procedure AtualizarEndereco;
    procedure DeletarEndereco;
    procedure CadastrarEmMassa;
    procedure AtualizarEnderecos;
    procedure Refresh;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  end;

var
  FrmPrincipal: TFrmPrincipal;

implementation

{$R *.dfm}

constructor TFrmPrincipal.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FBusinessLogic := TBusinessLogic.Create;
end;

destructor TFrmPrincipal.Destroy;
begin
  FBusinessLogic.Free;
  inherited Destroy;
end;

procedure TFrmPrincipal.Refresh;
begin
  dm.FDQueryPessoas.Open('select * from pessoa');
  dm.FDQueryPessoas.Refresh;
  dm.FDQueryEnderecoIntegracao.Open('select * from endereco_integracao');
  dm.FDQueryEnderecoIntegracao.Refresh;
end;

procedure TFrmPrincipal.CadastrarPessoa;
var
  dsdocumento, nmprimeiro, nmsegundo: string;
begin
  try
    dsdocumento := edtDocumento.Text;
    nmprimeiro := edtNome.Text;
    nmsegundo := edtSobrenome.Text;

    if (dsdocumento.IsEmpty) or (nmprimeiro.IsEmpty) or (nmsegundo.IsEmpty) then
      raise Exception.Create('Por favor, preencha todos os campos.');

    FBusinessLogic.CadastrarPessoa(dsdocumento, nmprimeiro, nmsegundo);
    ShowMessage('Pessoa cadastrada com sucesso!');
  except
    on E: Exception do
      ShowMessage('Erro ao cadastrar pessoa: ' + E.Message);
  end;
  Refresh;
end;

procedure TFrmPrincipal.AtualizarPessoa;
var
  idpessoa: Integer;
  dsdocumento, nmprimeiro, nmsegundo: string;
begin
  try
    idpessoa := StrToInt(InputBox('Atualizar Pessoa', 'Informe o ID da pessoa:', ''));
    dsdocumento := edtDocumento.Text;
    nmprimeiro := edtNome.Text;
    nmsegundo := edtSobrenome.Text;

    if (dsdocumento.IsEmpty) or (nmprimeiro.IsEmpty) or (nmsegundo.IsEmpty) then
      raise Exception.Create('Por favor, preencha todos os campos.');

    FBusinessLogic.AtualizarPessoa(idpessoa, dsdocumento, nmprimeiro, nmsegundo);
    ShowMessage('Pessoa atualizada com sucesso!');
  except
    on E: Exception do
      ShowMessage('Erro ao atualizar pessoa: ' + E.Message);
  end;
  Refresh;
end;

procedure TFrmPrincipal.btnAtualizarEnderecoClick(Sender: TObject);
begin
  AtualizarEndereco;
end;

procedure TFrmPrincipal.btnAtualizarEnderecosClick(Sender: TObject);
begin
  AtualizarEnderecos;
  Refresh;
end;

procedure TFrmPrincipal.btnAtualizarPessoaClick(Sender: TObject);
begin
  AtualizarPessoa;
  Refresh;
end;

procedure TFrmPrincipal.btnCadastrarEmMassaClick(Sender: TObject);
begin
  CadastrarEmMassa;
  Refresh;
end;

procedure TFrmPrincipal.btnCadastrarEnderecoClick(Sender: TObject);
begin
  CadastrarEndereco;
  Refresh;
end;

procedure TFrmPrincipal.btnCadastrarPessoaClick(Sender: TObject);
begin
   CadastrarPessoa;
   CadastrarEndereco;
   Refresh;
end;

procedure TFrmPrincipal.btnDeletarEnderecoClick(Sender: TObject);
begin
  DeletarEndereco;
  Refresh;
end;

procedure TFrmPrincipal.btnDeletarPessoaClick(Sender: TObject);
begin
  DeletarPessoa;
  Refresh;
end;

procedure TFrmPrincipal.DeletarPessoa;
var
  idpessoa: Integer;
begin
  try
    idpessoa := StrToInt(InputBox('Deletar Pessoa', 'Informe o ID da pessoa:', ''));
    FBusinessLogic.DeletarPessoa(idpessoa);
    ShowMessage('Pessoa deletada com sucesso!');
  except
    on E: Exception do
      ShowMessage('Erro ao deletar pessoa: ' + E.Message);
  end;
  Refresh;
end;

procedure TFrmPrincipal.CadastrarEndereco;
var
  idpessoa: Integer;
  dscep: string;
begin
  try
    idpessoa := StrToInt(InputBox('Cadastrar Endereço', 'Informe o ID da pessoa:', ''));
    dscep := edtCep.Text;

    if dscep.IsEmpty then
      raise Exception.Create('Por favor, preencha o campo de CEP.');

    FBusinessLogic.CadastrarEndereco(idpessoa, dscep);
    ShowMessage('Endereço cadastrado com sucesso!');
  except
    on E: Exception do
      ShowMessage('Erro ao cadastrar endereço: ' + E.Message);
  end;
  Refresh;
end;

procedure TFrmPrincipal.AtualizarEndereco;
var
  idendereco: Integer;
  dscep: string;
begin
  try
    idendereco := StrToInt(InputBox('Atualizar Endereço', 'Informe o ID do endereço:', ''));
    dscep := edtCep.Text;

    if dscep.IsEmpty then
      raise Exception.Create('Por favor, preencha o campo de CEP.');

    FBusinessLogic.AtualizarEndereco(idendereco, dscep);
    ShowMessage('Endereço atualizado com sucesso!');
  except
    on E: Exception do
      ShowMessage('Erro ao atualizar endereço: ' + E.Message);
  end;
  Refresh
end;

procedure TFrmPrincipal.DeletarEndereco;
var
  idendereco: Integer;
begin
  try
    idendereco := StrToInt(InputBox('Deletar Endereço', 'Informe o ID do endereço:', ''));
    FBusinessLogic.DeletarEndereco(idendereco);
    ShowMessage('Endereço deletado com sucesso!');
  except
    on E: Exception do
      ShowMessage('Erro ao deletar endereço: ' + E.Message);
  end;
  Refresh
end;

procedure TFrmPrincipal.CadastrarEmMassa;
var
  ListaPessoas: TStringList;
begin
  ListaPessoas := TStringList.Create;
  try
    // Aqui você deve capturar os dados da lista, poderia ser de um arquivo ou outro componente
    // Por exemplo: 'documento1,nome1,sobrenome1'
    ListaPessoas.Add('documento1,nome1,sobrenome1');
    ListaPessoas.Add('documento2,nome2,sobrenome2');

    FBusinessLogic.CadastrarPessoasEmMassa(ListaPessoas);
    ShowMessage('Cadastro em massa realizado com sucesso!');
  finally
    ListaPessoas.Free;
  end;
  Refresh;
end;

procedure TFrmPrincipal.AtualizarEnderecos;
begin
  try
    FBusinessLogic.AtualizarEnderecos;
    ShowMessage('Endereços atualizados com sucesso!');
  except
    on E: Exception do
      ShowMessage('Erro ao atualizar endereços: ' + E.Message);
  end;
  Refresh;
end;

end.

