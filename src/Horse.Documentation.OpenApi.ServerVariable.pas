unit Horse.Documentation.OpenApi.ServerVariable;

interface

uses
  System.JSON,
  System.Classes,
  System.SysUtils,
  System.Generics.Collections,
  Horse.Documentation.OpenApi.Types,
  Horse.Documentation.OpenApi.Ancestor,
  Horse.Documentation.OpenApi.Interfaces;

type
  /// <summary>
  ///   Implementação do objeto Server Variable da especificação OpenAPI (<c>IServerVariable&lt;T&gt;</c>),
  ///   usado para substituição de parâmetros em templates de URL de servidores.
  /// </summary>
  TServerVariable<T> = class(TOpenApiAncestor, IServerVariable<T>)
  private
    [Weak]
    FParent: IServer<T>;
    FEnum: TOpenApiList<string, IServerVariable<T>>;
    FDefault: string;
    FDescription: string;

    constructor Create(AParent: IServer<T>);
  public
    destructor Destroy; override;
    /// <summary>Cria uma nova instância de <c>IServerVariable&lt;T&gt;</c> vinculada ao servidor pai.</summary>
    class function New(AParent: IServer<T>): IServerVariable<T>; static;
    /// <summary>Serializa a variável de servidor para <c>TJSONObject</c>.</summary>
    function ToJson: TJSONObject;

    /// <summary>Retorna a lista de valores permitidos (<c>enum</c>) para esta variável.</summary>
    function &Enum: TOpenApiList<string, IServerVariable<T>>;
    /// <summary>Obtém o valor padrão obrigatório para substituição.</summary>
    function &Default: string; overload;
    /// <summary>Define o valor padrão obrigatório para substituição.</summary>
    function &Default(const AValue: string): IServerVariable<T>; overload;
    /// <summary>Obtém a descrição da variável de servidor.</summary>
    function Description: string; overload;
    /// <summary>Define a descrição da variável de servidor.</summary>
    function Description(const AValue: string): IServerVariable<T>; overload;
    /// <summary>Retorna ao servidor pai (<c>IServer&lt;T&gt;</c>).</summary>
    function &End: IServer<T>;
  end;

implementation

uses
  Horse.Documentation.OpenApi.Utils;

{ TServerVariable<T> }

constructor TServerVariable<T>.Create(AParent: IServer<T>);
begin
  inherited Create;
  FParent := AParent;
end;

function TServerVariable<T>.Default(const AValue: string): IServerVariable<T>;
begin
  Result := Self;
  FDefault := AValue;
end;

function TServerVariable<T>.Default: string;
begin
  Result := FDefault;
end;

function TServerVariable<T>.Description: string;
begin
  Result := FDescription;
end;

function TServerVariable<T>.Description(const AValue: string): IServerVariable<T>;
begin
  Result := Self;
  FDescription := AValue;
end;

destructor TServerVariable<T>.Destroy;
begin
  if FEnum <> nil then
    FEnum.Free;
  inherited;
end;

function TServerVariable<T>.&End: IServer<T>;
begin
  Result := FParent;
end;

function TServerVariable<T>.Enum: TOpenApiList<string, IServerVariable<T>>;
begin
  if FEnum = nil then
    FEnum := TOpenApiList<string, IServerVariable<T>>.Create(Self);
  Result := FEnum;
end;

class function TServerVariable<T>.New(AParent: IServer<T>): IServerVariable<T>;
begin
  Result := TServerVariable<T>.Create(AParent);
end;

function TServerVariable<T>.ToJson: TJSONObject;
var
  LEnum: string;
  LArray: TJSONArray;
begin
  Result := inherited;

  Result.AddPair('default', FDefault);

  if not FDescription.IsEmpty then
    Result.AddPair('description', FDescription);

  if (FEnum <> nil) and (FEnum.Count > 0) then
  begin
    LArray := TJSONArray.Create;
    for LEnum in Fenum do
      LArray.AddElement(TUtils.ValueToJson(LEnum));
    Result.AddPair('enum', LArray);
  end;
end;

end.
