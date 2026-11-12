unit Horse.Documentation.OpenApi.Server;

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
  ///   Implementação do objeto Server da especificação OpenAPI (<c>IServer&lt;T&gt;</c>),
  ///   representando informações de conectividade para um servidor de destino.
  /// </summary>
  TServer<T> = class(TOpenApiAncestor, IServer<T>)
  private
    FParent: T;
    FUrl: string;
    FDescription: string;
    FVariables: TOpenApiMap<IServerVariable<T>, IServer<T>>;

    constructor Create(AParent: T);
  public
    /// <summary>Cria uma nova instância de <c>IServer&lt;T&gt;</c> vinculada ao objeto pai <c>AParent</c>.</summary>
    class function New(AParent: T): IServer<T>; static;
    /// <summary>Serializa os dados do servidor e suas variáveis para <c>TJSONObject</c>.</summary>
    function ToJson: TJSONObject; override;

    /// <summary>Obtém a URL do servidor de destino.</summary>
    function Url: string; overload;
    /// <summary>Define a URL do servidor de destino (suporta variáveis entre chaves <c>{var}</c>).</summary>
    function Url(const AValue: string): IServer<T>; overload;
    /// <summary>Obtém a descrição do servidor.</summary>
    function Description: string; overload;
    /// <summary>Define a descrição do servidor.</summary>
    function Description(const AValue: string): IServer<T>; overload;
    /// <summary>Retorna o mapa de variáveis de substituição da URL do servidor (<c>IServerVariable&lt;T&gt;</c>).</summary>
    function Variables: TOpenApiMap<IServerVariable<T>, IServer<T>>;
    /// <summary>Retorna ao objeto pai (<c>T</c>).</summary>
    function &End: T;
  end;

implementation

uses
  Horse.Documentation.OpenApi.ServerVariable;

{ TServer<T> }

constructor TServer<T>.Create(AParent: T);
begin
  inherited Create;
  FParent := AParent;
end;

function TServer<T>.Description: string;
begin
  Result := FDescription;
end;

function TServer<T>.Description(const AValue: string): IServer<T>;
begin
  Result := Self;
  FDescription := AValue;
end;

function TServer<T>.&End: T;
begin
  Result := FParent;
end;

class function TServer<T>.New(AParent: T): IServer<T>;
begin
  Result := TServer<T>.Create(AParent);
end;

function TServer<T>.ToJson: TJSONObject;
var
  LPair: TPair<string, IServerVariable<T>>;
  LObject: TJSONObject;
begin
  Result := inherited ToJson;

  Result.AddPair('url', FUrl);

  if not FDescription.IsEmpty then
    Result.AddPair('description', FDescription);

  if FVariables <> nil then
  begin
    LObject := TJSONObject.Create;
    for LPair in FVariables do
      LObject.AddPair(LPair.Key, LPair.Value.ToJson);
    Result.AddPair('variables', LObject);
  end;
end;

function TServer<T>.Url: string;
begin
  Result := FUrl;
end;

function TServer<T>.Url(const AValue: string): IServer<T>;
begin
  Result := Self;
  FUrl := AValue;
end;

function TServer<T>.Variables: TOpenApiMap<IServerVariable<T>, IServer<T>>;
begin
  if FVariables = nil then
    FVariables := TOpenApiMap<IServerVariable<T>, IServer<T>>.Create(Self, TServerVariable<T>);
  Result := FVariables;
end;

end.
