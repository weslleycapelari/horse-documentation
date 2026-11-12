unit Horse.Documentation.OpenApi.Root;

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
  ///   Implementação concreta do objeto raiz da especificação OpenAPI 3.1.1 (<c>IOpenApi</c>).
  ///   Centraliza metadados da API, servidores, caminhos, webhooks, componentes reutilizáveis,
  ///   requisitos de segurança, tags e grupos de tags.
  /// </summary>
  TOpenApi = class(TOpenApiAncestor, IOpenApi)
  private
    FOpenapi: string;
    FInfo: IInfo;
    FJsonSchemaDialect: string;
    FServers: TOpenApiList<IServer<IOpenApi>, IOpenApi>;
    FPaths: TOpenApiMap<IPathItem<IOpenApi>, IOpenApi>;
    FWebhooks: TOpenApiMap<IPathItem<IOpenApi>, IOpenApi>;
    FComponents: IComponents;
    FSecurity: TOpenApiList<ISecurityRequirement<IOpenApi>, IOpenApi>;
    FTags: TOpenApiList<ITag, IOpenApi>;
    FTagGroups: TOpenApiList<ITagGroup, IOpenApi>;
    FExternalDocs: IExternalDocumentation<IOpenApi>;

    constructor Create;
  public
    destructor Destroy; override;
    /// <summary>Cria uma nova instância de <c>IOpenApi</c> inicializada com a versão <c>3.1.1</c>.</summary>
    class function New: IOpenApi; static;
    /// <summary>Serializa toda a árvore de documentação OpenAPI para um <c>TJSONObject</c>.</summary>
    function ToJson: TJSONObject;

    /// <summary>Obtém a versão da especificação OpenAPI (padrão: <c>3.1.1</c>).</summary>
    function Openapi: string; overload;
    /// <summary>Define a versão da especificação OpenAPI.</summary>
    function Openapi(const AValue: string): IOpenApi; overload;
    /// <summary>Retorna o objeto <c>IInfo</c> com metadados da API.</summary>
    function Info: IInfo;
    /// <summary>Obtém a URI do dialeto padrão para JSON Schema.</summary>
    function JsonSchemaDialect: string; overload;
    /// <summary>Define a URI do dialeto padrão para JSON Schema.</summary>
    function JsonSchemaDialect(const AValue: string): IOpenApi; overload;
    /// <summary>Retorna a lista de servidores (<c>IServer</c>) da API.</summary>
    function Servers: TOpenApiList<IServer<IOpenApi>, IOpenApi>;
    /// <summary>Retorna o mapa de caminhos e operações (<c>IPathItem</c>) da API.</summary>
    function Paths: TOpenApiMap<IPathItem<IOpenApi>, IOpenApi>;
    /// <summary>Retorna o mapa de webhooks (<c>IPathItem</c>) da API.</summary>
    function Webhooks: TOpenApiMap<IPathItem<IOpenApi>, IOpenApi>;
    /// <summary>Retorna o contêiner de componentes reutilizáveis (<c>IComponents</c>).</summary>
    function Components: IComponents;
    /// <summary>Retorna a lista global de requisitos de segurança (<c>ISecurityRequirement</c>).</summary>
    function Security: TOpenApiList<ISecurityRequirement<IOpenApi>, IOpenApi>;
    /// <summary>Retorna a lista de tags globais (<c>ITag</c>) da documentação.</summary>
    function Tags: TOpenApiList<ITag, IOpenApi>;
    /// <summary>Retorna a lista de grupos de tags (<c>ITagGroup</c>, extensão <c>x-tagGroups</c>).</summary>
    function TagGroups: TOpenApiList<ITagGroup, IOpenApi>;
    /// <summary>Retorna a referência de documentação externa (<c>IExternalDocumentation</c>).</summary>
    function ExternalDocs: IExternalDocumentation<IOpenApi>;
  end;

implementation

uses
  Horse.Documentation.OpenApi.Tag,
  Horse.Documentation.OpenApi.TagGroup,
  Horse.Documentation.OpenApi.Info,
  Horse.Documentation.OpenApi.Server,
  Horse.Documentation.OpenApi.PathItem,
  Horse.Documentation.OpenApi.Components,
  Horse.Documentation.OpenApi.SecurityRequirement,
  Horse.Documentation.OpenApi.ExternalDocumentation;

{ TOpenApi }

function TOpenApi.Components: IComponents;
begin
  if FComponents = nil then
    FComponents := TComponents.New(Self);
  Result := FComponents
end;

constructor TOpenApi.Create;
begin
  inherited Create;
  FOpenapi := '3.1.1';
  FInfo := TInfo.New(Self);
end;

destructor TOpenApi.Destroy;
begin
  if FServers <> nil then
    FServers.Free;
  if FPaths <> nil then
    FPaths.Free;
  if FWebhooks <> nil then
    FWebhooks.Free;
  if FSecurity <> nil then
    FSecurity.Free;
  if FTags <> nil then
    FTags.Free;
  if FTagGroups <> nil then
    FTagGroups.Free;

  inherited;
end;

function TOpenApi.ExternalDocs: IExternalDocumentation<IOpenApi>;
begin
  if FExternalDocs = nil then
    FExternalDocs := TExternalDocumentation<IOpenApi>.New(Self);
  Result := FExternalDocs
end;

function TOpenApi.Info: IInfo;
begin
  if FInfo = nil then
    FInfo := TInfo.New(Self);
  Result := FInfo;
end;

function TOpenApi.JsonSchemaDialect(const AValue: string): IOpenApi;
begin
  Result := Self;
  FJsonSchemaDialect := AValue;
end;

function TOpenApi.JsonSchemaDialect: string;
begin
  Result := FJsonSchemaDialect;
end;

class function TOpenApi.New: IOpenApi;
begin
  Result := TOpenApi.Create;
end;

function TOpenApi.Openapi(const AValue: string): IOpenApi;
begin
  Result := Self;
  FOpenapi := AValue;
end;

function TOpenApi.Paths: TOpenApiMap<IPathItem<IOpenApi>, IOpenApi>;
begin
  if FPaths = nil then
    FPaths := TOpenApiMap<IPathItem<IOpenApi>, IOpenApi>.Create(Self, TPathItem<IOpenApi>);
  Result := FPaths;
end;

function TOpenApi.Security: TOpenApiList<ISecurityRequirement<IOpenApi>, IOpenApi>;
begin
  if FSecurity = nil then
    FSecurity := TOpenApiList<ISecurityRequirement<IOpenApi>, IOpenApi>.Create(Self, TSecurityRequirement<IOpenApi>);
  Result := FSecurity;
end;

function TOpenApi.Servers: TOpenApiList<IServer<IOpenApi>, IOpenApi>;
begin
  if FServers = nil then
    FServers := TOpenApiList<IServer<IOpenApi>, IOpenApi>.Create(Self, TServer<IOpenApi>);
  Result := FServers;
end;

function TOpenApi.Tags: TOpenApiList<ITag, IOpenApi>;
begin
  if FTags = nil then
    FTags := TOpenApiList<ITag, IOpenApi>.Create(Self, TTag);
  Result := FTags;
end;

function TOpenApi.TagGroups: TOpenApiList<ITagGroup, IOpenApi>;
begin
  if FTagGroups = nil then
    FTagGroups := TOpenApiList<ITagGroup, IOpenApi>.Create(Self, TTagGroup);
  Result := FTagGroups;
end;

function TOpenApi.ToJson: TJSONObject;
begin
  Result := inherited ToJson;

  // Required fields
  Result.AddPair('openapi', FOpenapi);

  if FInfo <> nil then
    Result.AddPair('info', FInfo.ToJson);

  // Optional fields
  if not FJsonSchemaDialect.IsEmpty then
    Result.AddPair('jsonSchemaDialect', FJsonSchemaDialect);

  if (FServers <> nil) and (FServers.Count > 0) then
    Result.AddPair('servers', FServers.ToJson);

  if (FPaths <> nil) and (FPaths.Count > 0) then
    Result.AddPair('paths', FPaths.ToJson);

  if (FWebhooks <> nil) and (FWebhooks.Count > 0) then
    Result.AddPair('webhooks', FWebhooks.ToJson);

  if FComponents <> nil then
    Result.AddPair('components', FComponents.ToJson);

  if (FSecurity <> nil) and (FSecurity.Count > 0) then
    Result.AddPair('security', FSecurity.ToJson);

  if (FTags <> nil) and (FTags.Count > 0) then
    Result.AddPair('tags', FTags.ToJson);

  if (FTagGroups <> nil) and (FTagGroups.Count > 0) then
    Result.AddPair('x-tagGroups', FTagGroups.ToJson);

  if FExternalDocs <> nil then
    Result.AddPair('externalDocs', FExternalDocs.ToJson);
end;

function TOpenApi.Webhooks: TOpenApiMap<IPathItem<IOpenApi>, IOpenApi>;
begin
  if FWebhooks = nil then
    FWebhooks := TOpenApiMap<IPathItem<IOpenApi>, IOpenApi>.Create(Self, TPathItem<IOpenApi>);
  Result := FWebhooks;
end;

function TOpenApi.Openapi: string;
begin
  Result := FOpenapi;
end;

end.
