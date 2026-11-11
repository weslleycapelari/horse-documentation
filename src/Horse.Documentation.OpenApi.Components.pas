unit Horse.Documentation.OpenApi.Components;

interface

uses
  System.JSON,
  System.Classes,
  System.TypInfo,
  System.SysUtils,
  System.Generics.Collections,
  Horse.Documentation.OpenApi.Types,
  Horse.Documentation.OpenApi.Ancestor,
  Horse.Documentation.OpenApi.Interfaces;

type
  /// <summary>
  ///   Implementação do contêiner Components da especificação OpenAPI (<c>IComponents</c>),
  ///   armazenando objetos reutilizáveis (schemas, respostas, parâmetros, exemplos, corpos de requisição,
  ///   cabeçalhos, esquemas de segurança, links, callbacks e itens de caminho).
  /// </summary>
  TComponents = class(TOpenApiAncestor, IComponents)
  private
    [Weak]
    FParent: IOpenApi;
    FSchemas: TOpenApiMap<ISchema, IComponents>;
    FResponses: TOpenApiMap<IResponse<IComponents>, IComponents>;
    FParameters: TOpenApiMap<IParameter<IComponents>, IComponents>;
    FExamples: TOpenApiMap<IExample<IComponents>, IComponents>;
    FRequestBodies: TOpenApiMap<IRequestBody<IComponents>, IComponents>;
    FHeaders: TOpenApiMap<IHeader<IComponents>, IComponents>;
    FSecuritySchemes: TOpenApiMap<ISecurityScheme, IComponents>;
    FLinks: TOpenApiMap<ILink<IComponents>, IComponents>;
    FCallbacks: TOpenApiMap<IPathItem<IComponents>, IComponents>;
    FPathItems: TOpenApiMap<IPathItem<IComponents>, IComponents>;

    constructor Create(AParent: IOpenApi);
  public
    /// <summary>Cria uma nova instância de <c>IComponents</c> vinculada ao objeto raiz <c>IOpenApi</c>.</summary>
    class function New(AParent: IOpenApi): IComponents; static;
    /// <summary>Serializa todos os componentes reutilizáveis registrados para <c>TJSONObject</c>.</summary>
    function ToJson: TJSONObject;

    /// <summary>Retorna o mapa de JSON Schemas reutilizáveis (<c>#/components/schemas/...</c>).</summary>
    function Schemas: TOpenApiMap<ISchema, IComponents>;
    /// <summary>Retorna o mapa de objetos Response reutilizáveis (<c>#/components/responses/...</c>).</summary>
    function Responses: TOpenApiMap<IResponse<IComponents>, IComponents>;
    /// <summary>Retorna o mapa de objetos Parameter reutilizáveis (<c>#/components/parameters/...</c>).</summary>
    function Parameters: TOpenApiMap<IParameter<IComponents>, IComponents>;
    /// <summary>Retorna o mapa de objetos Example reutilizáveis (<c>#/components/examples/...</c>).</summary>
    function Examples: TOpenApiMap<IExample<IComponents>, IComponents>;
    /// <summary>Retorna o mapa de objetos RequestBody reutilizáveis (<c>#/components/requestBodies/...</c>).</summary>
    function RequestBodies: TOpenApiMap<IRequestBody<IComponents>, IComponents>;
    /// <summary>Retorna o mapa de objetos Header reutilizáveis (<c>#/components/headers/...</c>).</summary>
    function Headers: TOpenApiMap<IHeader<IComponents>, IComponents>;
    /// <summary>Retorna o mapa de esquemas de segurança reutilizáveis (<c>#/components/securitySchemes/...</c>).</summary>
    function SecuritySchemes: TOpenApiMap<ISecurityScheme, IComponents>;
    /// <summary>Retorna o mapa de objetos Link reutilizáveis (<c>#/components/links/...</c>).</summary>
    function Links: TOpenApiMap<ILink<IComponents>, IComponents>;
    /// <summary>Retorna o mapa de objetos Callback reutilizáveis (<c>#/components/callbacks/...</c>).</summary>
    function Callbacks: TOpenApiMap<IPathItem<IComponents>, IComponents>;
    /// <summary>Retorna o mapa de objetos PathItem reutilizáveis (<c>#/components/pathItems/...</c>).</summary>
    function PathItems: TOpenApiMap<IPathItem<IComponents>, IComponents>;
    /// <summary>Retorna ao objeto pai (<c>IOpenApi</c>).</summary>
    function &End: IOpenApi;
  end;

implementation

uses
  Horse.Documentation.OpenApi.Response,
  Horse.Documentation.OpenApi.Parameter,
  Horse.Documentation.OpenApi.Example,
  Horse.Documentation.OpenApi.RequestBody,
  Horse.Documentation.OpenApi.Header,
  Horse.Documentation.OpenApi.SecurityScheme,
  Horse.Documentation.OpenApi.Link,
  Horse.Documentation.OpenApi.PathItem;

{ TComponents }

function TComponents.Callbacks: TOpenApiMap<IPathItem<IComponents>, IComponents>;
begin
  if FCallbacks = nil then
    FCallbacks := TOpenApiMap<IPathItem<IComponents>, IComponents>.Create(Self, TPathItem<IComponents>);
  Result := FCallbacks;
end;

constructor TComponents.Create(AParent: IOpenApi);
begin
  inherited Create;
  FParent := AParent;
end;

function TComponents.&End: IOpenApi;
begin
  Result := FParent;
end;

function TComponents.Examples: TOpenApiMap<IExample<IComponents>, IComponents>;
begin
  if FExamples = nil then
    FExamples := TOpenApiMap<IExample<IComponents>, IComponents>.Create(Self, TExample<IComponents>);
  Result := FExamples;
end;

function TComponents.Headers: TOpenApiMap<IHeader<IComponents>, IComponents>;
begin
  if FHeaders = nil then
    FHeaders := TOpenApiMap<IHeader<IComponents>, IComponents>.Create(Self, THeader<IComponents>);
  Result := FHeaders;
end;

function TComponents.Links: TOpenApiMap<ILink<IComponents>, IComponents>;
begin
  if FLinks = nil then
    FLinks := TOpenApiMap<ILink<IComponents>, IComponents>.Create(Self, TLink<IComponents>);
  Result := FLinks;
end;

class function TComponents.New(AParent: IOpenApi): IComponents;
begin
  Result := TComponents.Create(AParent);
end;

function TComponents.Parameters: TOpenApiMap<IParameter<IComponents>, IComponents>;
begin
  if FParameters = nil then
    FParameters := TOpenApiMap<IParameter<IComponents>, IComponents>.Create(Self, TParameter<IComponents>);
  Result := FParameters;
end;

function TComponents.PathItems: TOpenApiMap<IPathItem<IComponents>, IComponents>;
begin
  if FPathItems = nil then
    FPathItems := TOpenApiMap<IPathItem<IComponents>, IComponents>.Create(Self, TPathItem<IComponents>);
  Result := FPathItems;
end;

function TComponents.RequestBodies: TOpenApiMap<IRequestBody<IComponents>, IComponents>;
begin
  if FRequestBodies = nil then
    FRequestBodies := TOpenApiMap<IRequestBody<IComponents>, IComponents>.Create(Self, TRequestBody<IComponents>);
  Result := FRequestBodies;
end;

function TComponents.Responses: TOpenApiMap<IResponse<IComponents>, IComponents>;
begin
  if FResponses = nil then
    FResponses := TOpenApiMap<IResponse<IComponents>, IComponents>.Create(Self, TResponse<IComponents>);
  Result := FResponses;
end;

function TComponents.Schemas: TOpenApiMap<ISchema, IComponents>;
begin
  if FSchemas = nil then
    FSchemas := TOpenApiMap<ISchema, IComponents>.Create(Self);
  Result := FSchemas;
end;

function TComponents.SecuritySchemes: TOpenApiMap<ISecurityScheme, IComponents>;
begin
  if FSecuritySchemes = nil then
    FSecuritySchemes := TOpenApiMap<ISecurityScheme, IComponents>.Create(Self, TSecurityScheme);
  Result := FSecuritySchemes;
end;

function TComponents.ToJson: TJSONObject;
begin
  Result := inherited ToJson;

  if (FSchemas <> nil) and (FSchemas.Count > 0) then
    Result.AddPair('schemas', FSchemas.ToJson);

  if (FResponses <> nil) and (FResponses.Count > 0) then
    Result.AddPair('responses', FResponses.ToJson);

  if (FParameters <> nil) and (FParameters.Count > 0) then
    Result.AddPair('parameters', FParameters.ToJson);

  if (FExamples <> nil) and (FExamples.Count > 0) then
    Result.AddPair('examples', FExamples.ToJson);

  if (FRequestBodies <> nil) and (FRequestBodies.Count > 0) then
    Result.AddPair('requestBodies', FRequestBodies.ToJson);

  if (FHeaders <> nil) and (FHeaders.Count > 0) then
    Result.AddPair('headers', FHeaders.ToJson);

  if (FSecuritySchemes <> nil) and (FSecuritySchemes.Count > 0) then
    Result.AddPair('securitySchemes', FSecuritySchemes.ToJson);

  if (FLinks <> nil) and (FLinks.Count > 0) then
    Result.AddPair('links', FLinks.ToJson);

  if (FCallbacks <> nil) and (FCallbacks.Count > 0) then
    Result.AddPair('callbacks', FCallbacks.ToJson);

  if (FPathItems <> nil) and (FPathItems.Count > 0) then
    Result.AddPair('pathItems', FPathItems.ToJson);
end;

end.
