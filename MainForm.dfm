object FrmPrincipal: TFrmPrincipal
  Left = 0
  Top = 0
  Caption = 'Gerenciamento de Pessoas e Endere'#195#167'os'
  ClientHeight = 545
  ClientWidth = 733
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = True
  PixelsPerInch = 96
  TextHeight = 13
  object lblDocumento: TLabel
    Left = 160
    Top = 0
    Width = 58
    Height = 13
    Caption = 'Documento:'
  end
  object lblNome: TLabel
    Left = 160
    Top = 40
    Width = 31
    Height = 13
    Caption = 'Nome:'
  end
  object lblSobrenome: TLabel
    Left = 160
    Top = 80
    Width = 58
    Height = 13
    Caption = 'Sobrenome:'
  end
  object lblCep: TLabel
    Left = 160
    Top = 120
    Width = 23
    Height = 13
    Caption = 'CEP:'
  end
  object Label1: TLabel
    Left = 405
    Top = 17
    Width = 39
    Height = 13
    Caption = 'Pessoas'
  end
  object Label2: TLabel
    Left = 405
    Top = 277
    Width = 50
    Height = 13
    Caption = 'Endere'#231'os'
  end
  object btnCadastrarPessoa: TButton
    Left = 16
    Top = 20
    Width = 120
    Height = 30
    Caption = 'Cadastrar Pessoa'
    TabOrder = 0
    OnClick = btnCadastrarPessoaClick
  end
  object btnAtualizarPessoa: TButton
    Left = 16
    Top = 56
    Width = 120
    Height = 30
    Caption = 'Atualizar Pessoa'
    TabOrder = 1
    OnClick = btnAtualizarPessoaClick
  end
  object btnDeletarPessoa: TButton
    Left = 16
    Top = 96
    Width = 120
    Height = 30
    Caption = 'Deletar Pessoa'
    TabOrder = 2
    OnClick = btnDeletarPessoaClick
  end
  object btnCadastrarEndereco: TButton
    Left = 16
    Top = 136
    Width = 120
    Height = 30
    Caption = 'Cadastrar Endere'#231'o'
    TabOrder = 3
    OnClick = btnCadastrarEnderecoClick
  end
  object btnCadastrarEmMassa: TButton
    Left = 16
    Top = 212
    Width = 120
    Height = 30
    Caption = 'Cadastrar em Massa'
    TabOrder = 4
    OnClick = btnCadastrarEmMassaClick
  end
  object edtDocumento: TEdit
    Left = 160
    Top = 16
    Width = 200
    Height = 21
    TabOrder = 5
    Text = '12'
  end
  object edtNome: TEdit
    Left = 160
    Top = 56
    Width = 200
    Height = 21
    CharCase = ecUpperCase
    TabOrder = 6
    Text = 'GIOVANI LUIZ'
  end
  object edtSobrenome: TEdit
    Left = 160
    Top = 96
    Width = 200
    Height = 21
    CharCase = ecUpperCase
    TabOrder = 7
    Text = 'DE SANTI'
  end
  object edtCep: TEdit
    Left = 160
    Top = 136
    Width = 200
    Height = 21
    TabOrder = 8
    Text = '89710016'
  end
  object DBGrid1: TDBGrid
    Left = 405
    Top = 36
    Width = 320
    Height = 230
    DataSource = DM.DataSource1
    TabOrder = 9
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -11
    TitleFont.Name = 'Tahoma'
    TitleFont.Style = []
    Columns = <
      item
        Expanded = False
        FieldName = 'NMPRIMEIRO'
        Title.Caption = 'Nome'
        Width = 126
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'NMSEGUNDO'
        Title.Caption = 'Sobrenome'
        Width = 100
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'DTREGISTRO'
        Title.Caption = 'Data'
        Visible = True
      end>
  end
  object DBGrid2: TDBGrid
    Left = 405
    Top = 296
    Width = 320
    Height = 230
    DataSource = DM.DataSource3
    TabOrder = 10
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -11
    TitleFont.Name = 'Tahoma'
    TitleFont.Style = []
    Columns = <
      item
        Expanded = False
        FieldName = 'DSUF'
        Title.Caption = 'UF'
        Width = 50
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'NMCIDADE'
        Title.Caption = 'Cidade'
        Width = 100
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'NMBAIRRO'
        Title.Caption = 'Bairro'
        Width = 100
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'NMLOGRADOURO'
        Title.Caption = 'Logradouro'
        Width = 100
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'DSCOMPLEMENTO'
        Title.Caption = 'Complemento'
        Visible = True
      end>
  end
  object btnAtualizarEndereco: TButton
    Left = 16
    Top = 176
    Width = 120
    Height = 30
    Caption = 'Atualizar Endere'#231'o'
    TabOrder = 11
    OnClick = btnAtualizarEnderecoClick
  end
end
