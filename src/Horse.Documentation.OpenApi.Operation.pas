unit Horse.Documentation.OpenApi.Operation;

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
  TOperation<T> = class(TOpenApiAncestor, IOperation<T>)
  private
    FParent: T;
    FTags: TOpenApiList<string, IOperation<T>>;
    FSummary: string;
    FDescription: string;
    FExternalDocs: IExternalDocumentation<IOperation<T>>;
    FOperationId: string;
    FParameters: TOpenApiList<IParameter<IOperation<T>>, IOperation<T>>;
    FRequestBody: IRequestBody<IOperation<T>>;
    FResponses: IResponses<IOperation<T>>;
    FDeprecated: Boolean;
    FSecurity: TOpenApiList<ISecurityRequirement<IOperation<T>>, IOperation<T>>;
    FServers: TOpenApiList<IServer<IOperation<T>>, IOperation<T>>;
    FCodeSamples: TOpenApiList<ICodeSample<IOperation<T>>, IOperation<T>>;

    constructor Create(AParent: T);
  public
    class function New(AParent: T): IOperation<T>; static;
    function ToJson: TJSONObject;

    function Tags: TOpenApiList<string, IOperation<T>>;
    function Summary: string; overload;
    function Summary(const AValue: string): IOperation<T>; overload;
    function Description: string; overload;
    function Description(const AValue: string): IOperation<T>; overload;
    function ExternalDocs: IExternalDocumentation<IOperation<T>>;
    function OperationId: string; overload;
    function OperationId(const AValue: string): IOperation<T>; overload;
    function Parameters: TOpenApiList<IParameter<IOperation<T>>, IOperation<T>>;
    function RequestBody: IRequestBody<IOperation<T>>;
    function Responses: IResponses<IOperation<T>>;
    function Deprecated: Boolean; overload;
    function Deprecated(const AValue: Boolean): IOperation<T>; overload;
    function Security: TOpenApiList<ISecurityRequirement<IOperation<T>>, IOperation<T>>;
    function Servers: TOpenApiList<IServer<IOperation<T>>, IOperation<T>>;
    function CodeSamples: TOpenApiList<ICodeSample<IOperation<T>>, IOperation<T>>;
    function &End: T;
  end;

implementation

uses
  Horse.Documentation.OpenApi.Server,
  Horse.Documentation.OpenApi.Parameter,
  Horse.Documentation.OpenApi.Responses,
  Horse.Documentation.OpenApi.RequestBody,
  Horse.Documentation.OpenApi.SecurityRequirement,
  Horse.Documentation.OpenApi.ExternalDocumentation,
  Horse.Documentation.OpenApi.CodeSample;

{ TOperation<T> }

constructor TOperation<T>.Create(AParent: T);
begin
  inherited Create;
  FParent := AParent;
end;

function TOperation<T>.Description: string;
begin
  Result := FDescription;
end;

function TOperation<T>.Deprecated(const AValue: Boolean): IOperation<T>;
begin
  Result := Self;
  FDeprecated := AValue;
end;

function TOperation<T>.Deprecated: Boolean;
begin
  Result := FDeprecated;
end;

function TOperation<T>.Description(const AValue: string): IOperation<T>;
begin
  Result := Self;
  FDescription := AValue;
end;

function TOperation<T>.&End: T;
begin
  Result := FParent;
end;

function TOperation<T>.ExternalDocs: IExternalDocumentation<IOperation<T>>;
begin
  if FExternalDocs = nil then
    FExternalDocs := TExternalDocumentation<IOperation<T>>.New(Self);
  Result := FExternalDocs;
end;

class function TOperation<T>.New(AParent: T): IOperation<T>;
begin
  Result := TOperation<T>.Create(AParent);
end;

function TOperation<T>.OperationId(const AValue: string): IOperation<T>;
begin
  Result := Self;
  FOperationId := AValue;
end;

function TOperation<T>.OperationId: string;
begin
  Result := FOperationId;
end;

function TOperation<T>.Parameters: TOpenApiList<IParameter<IOperation<T>>, IOperation<T>>;
begin
  if FParameters = nil then
    FParameters := TOpenApiList<IParameter<IOperation<T>>, IOperation<T>>.Create(Self, TParameter<IOperation<T>>);
  Result := FParameters;
end;

function TOperation<T>.RequestBody: IRequestBody<IOperation<T>>;
begin
  if FRequestBody = nil then
    FRequestBody := TRequestBody<IOperation<T>>.New(Self);
  Result := FRequestBody;
end;

function TOperation<T>.Responses: IResponses<IOperation<T>>;
begin
  if FResponses = nil then
    FResponses := TResponses<IOperation<T>>.New(Self);
  Result := FResponses;
end;

function TOperation<T>.Security: TOpenApiList<ISecurityRequirement<IOperation<T>>, IOperation<T>>;
begin
  if FSecurity = nil then
    FSecurity := TOpenApiList<ISecurityRequirement<IOperation<T>>, IOperation<T>>.Create(Self, TSecurityRequirement<IOperation<T>>);
  Result := FSecurity;
end;

function TOperation<T>.Servers: TOpenApiList<IServer<IOperation<T>>, IOperation<T>>;
begin
  if FServers = nil then
    FServers := TOpenApiList<IServer<IOperation<T>>, IOperation<T>>.Create(Self, TServer<IOperation<T>>);
  Result := FServers;
end;

function TOperation<T>.CodeSamples: TOpenApiList<ICodeSample<IOperation<T>>, IOperation<T>>;
begin
  if FCodeSamples = nil then
    FCodeSamples := TOpenApiList<ICodeSample<IOperation<T>>, IOperation<T>>.Create(Self, TCodeSample<IOperation<T>>);
  Result := FCodeSamples;
end;

function TOperation<T>.Summary(const AValue: string): IOperation<T>;
begin
  Result := Self;
  FSummary := AValue;
end;

function TOperation<T>.Summary: string;
begin
  Result := FSummary;
end;

function TOperation<T>.Tags: TOpenApiList<string, IOperation<T>>;
begin
  if FTags = nil then
    FTags := TOpenApiList<string, IOperation<T>>.Create(Self);
  Result := FTags;
end;

function TOperation<T>.ToJson: TJSONObject;
begin
  Result := inherited ToJson;

  if not FSummary.IsEmpty then
    Result.AddPair('summary', FSummary);

  if not FDescription.IsEmpty then
    Result.AddPair('description', FDescription);

  if not FOperationId.IsEmpty then
    Result.AddPair('operationId', FOperationId);

  if (FTags <> nil) and (FTags.Count > 0) then
    Result.AddPair('tags', FTags.ToJson);

  if FExternalDocs <> nil then
    Result.AddPair('externalDocs', FExternalDocs.ToJson);

  if (FParameters <> nil) and (FParameters.Count > 0) then
    Result.AddPair('parameters', FParameters.ToJson);

  if FRequestBody <> nil then
    Result.AddPair('requestBody', FRequestBody.ToJson);

  if FResponses <> nil then
    Result.AddPair('responses', FResponses.ToJson);

//  if (FCallbacks <> nil) and (FCallbacks.Count > 0) then
//    Result.AddPair('callbacks', FCallbacks.ToJson);

  if FDeprecated then
    Result.AddPair('deprecated', FDeprecated);

  if (FSecurity <> nil) and (FSecurity.Count > 0) then
    Result.AddPair('security', FSecurity.ToJson);

  if (FServers <> nil) and (FServers.Count > 0) then
    Result.AddPair('servers', FServers.ToJson);

  if (FCodeSamples <> nil) and (FCodeSamples.Count > 0) then
    Result.AddPair('x-code-samples', FCodeSamples.ToJson);
end;

end.
