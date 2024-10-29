object DM: TDM
  OldCreateOrder = False
  Height = 428
  Width = 569
  object FDConnection: TFDConnection
    Params.Strings = (
      'Database=F:\TesteCEP\DATABASE.FDB'
      'User_Name=sysdba'
      'Password=masterkey'
      'DriverID=FB')
    Connected = True
    LoginPrompt = False
    Left = 64
    Top = 48
  end
  object FDQueryPessoas: TFDQuery
    Active = True
    Connection = FDConnection
    UpdateOptions.AssignedValues = [uvFetchGeneratorsPoint, uvGeneratorName]
    UpdateOptions.FetchGeneratorsPoint = gpImmediate
    UpdateOptions.GeneratorName = 'gen_pessoa_is'
    UpdateOptions.AutoIncFields = 'idpessoa'
    SQL.Strings = (
      'select * from pessoa')
    Left = 40
    Top = 160
  end
  object DataSource1: TDataSource
    DataSet = FDQueryPessoas
    Left = 80
    Top = 168
  end
  object DataSource2: TDataSource
    DataSet = FDQueryEnderecos
    Left = 80
    Top = 216
  end
  object FDQueryEnderecos: TFDQuery
    Active = True
    Connection = FDConnection
    UpdateOptions.AssignedValues = [uvFetchGeneratorsPoint, uvGeneratorName]
    UpdateOptions.FetchGeneratorsPoint = gpImmediate
    UpdateOptions.GeneratorName = 'gen_endereco_id'
    UpdateOptions.AutoIncFields = 'idendereco'
    SQL.Strings = (
      'select * from endereco')
    Left = 40
    Top = 208
  end
  object DataSource3: TDataSource
    DataSet = FDQueryEnderecoIntegracao
    Left = 72
    Top = 264
  end
  object FDQueryEnderecoIntegracao: TFDQuery
    Active = True
    Connection = FDConnection
    UpdateOptions.AssignedValues = [uvFetchGeneratorsPoint, uvGeneratorName]
    UpdateOptions.FetchGeneratorsPoint = gpImmediate
    UpdateOptions.GeneratorName = 'gen_endereco_integracao_id'
    UpdateOptions.AutoIncFields = 'idendereco'
    SQL.Strings = (
      'select * from endereco_integracao')
    Left = 32
    Top = 256
  end
end
