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
    class function New: IOpenApi; static;
    function ToJson: TJSONObject;

    function Openapi: string; overload;
    function Openapi(const AValue: string): IOpenApi; overload;
    function Info: IInfo;
    function JsonSchemaDialect: string; overload;
    function JsonSchemaDialect(const AValue: string): IOpenApi; overload;
    function Servers: TOpenApiList<IServer<IOpenApi>, IOpenApi>;
    function Paths: TOpenApiMap<IPathItem<IOpenApi>, IOpenApi>;
    function Webhooks: TOpenApiMap<IPathItem<IOpenApi>, IOpenApi>;
    function Components: IComponents;
    function Security: TOpenApiList<ISecurityRequirement<IOpenApi>, IOpenApi>;
    function Tags: TOpenApiList<ITag, IOpenApi>;
    function TagGroups: TOpenApiList<ITagGroup, IOpenApi>;
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
