unit Horse.Documentation.OpenApi.Responses;

interface

uses
  System.JSON,
  System.Classes,
  System.SysUtils,
  Horse.Documentation.OpenApi.Types,
  Horse.Documentation.OpenApi.Ancestor,
  Horse.Documentation.OpenApi.Interfaces;

type
  /// <summary>
  ///   Implementação do contêiner Responses da especificação OpenAPI (<c>IResponses&lt;T&gt;</c>),
  ///   agrupando as respostas esperadas de uma operação por código de status HTTP.
  /// </summary>
  TResponses<T> = class(TOpenApiAncestor, IResponses<T>)
  private
    FParent: T;
    FDefault: IResponse<IResponses<T>>;
    FStatusCodes: TOpenApiMap<IResponse<IResponses<T>>, IResponses<T>>;

    constructor Create(AParent: T);
  public
    /// <summary>Cria uma nova instância de <c>IResponses&lt;T&gt;</c> vinculada ao objeto pai <c>AParent</c>.</summary>
    class function New(AParent: T): IResponses<T>; static;
    /// <summary>Serializa o contêiner de respostas para <c>TJSONObject</c>.</summary>
    function ToJson: TJSONObject;

    /// <summary>Retorna a definição de resposta padrão (<c>default</c>) para códigos HTTP não listados explicitamente.</summary>
    function &Default: IResponse<IResponses<T>>;
    /// <summary>Retorna o mapa de respostas indexado pelo código de status HTTP (ex: <c>'200'</c>, <c>'400'</c>, <c>'2XX'</c>).</summary>
    function StatusCodes: TOpenApiMap<IResponse<IResponses<T>>, IResponses<T>>;
    /// <summary>Retorna ao objeto pai (<c>T</c>).</summary>
    function &End: T;
  end;

implementation

uses
  Horse.Documentation.OpenApi.Response;

{ TResponses<T> }

constructor TResponses<T>.Create(AParent: T);
begin
  inherited Create;
  FParent := AParent;
end;

function TResponses<T>.Default: IResponse<IResponses<T>>;
begin
  if FDefault = nil then
    FDefault := TResponse<IResponses<T>>.New(Self);
  Result := FDefault;
end;

function TResponses<T>.&End: T;
begin
  Result := FParent;
end;

class function TResponses<T>.New(AParent: T): IResponses<T>;
begin
  Result := TResponses<T>.Create(AParent);
end;

function TResponses<T>.StatusCodes: TOpenApiMap<IResponse<IResponses<T>>, IResponses<T>>;
begin
  if FStatusCodes = nil then
    FStatusCodes := TOpenApiMap<IResponse<IResponses<T>>, IResponses<T>>.Create(Self, TResponse<IResponses<T>>);
  Result := FStatusCodes;
end;

function TResponses<T>.ToJson: TJSONObject;
var
  LPair: TJSONPair;
begin
  Result := inherited ToJson;

  if FDefault <> nil then
    Result.AddPair('default', FDefault.ToJson);

  if (FStatusCodes <> nil) then
    for LPair in FStatusCodes.ToJson do
      Result.AddPair(LPair);
end;

end.

