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
  /// <summary>
  ///   Implementação do objeto Operation da especificação OpenAPI (<c>IOperation&lt;T&gt;</c>),
  ///   descrevendo uma única operação de API em um caminho (tags, parâmetros, corpo de requisição, respostas, segurança e exemplos de código).
  /// </summary>
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
    /// <summary>Cria uma nova instância de <c>IOperation&lt;T&gt;</c> vinculada ao objeto pai <c>AParent</c>.</summary>
    class function New(AParent: T): IOperation<T>; static;
    /// <summary>Serializa os metadados da operação para <c>TJSONObject</c>.</summary>
    function ToJson: TJSONObject;

    /// <summary>Retorna a lista de tags associadas a esta operação para agrupamento na documentação.</summary>
    function Tags: TOpenApiList<string, IOperation<T>>;
    /// <summary>Obtém o resumo curto do propósito da operação.</summary>
    function Summary: string; overload;
    /// <summary>Define o resumo curto do propósito da operação.</summary>
    function Summary(const AValue: string): IOperation<T>; overload;
    /// <summary>Obtém a explicação detalhada do comportamento da operação (suporta CommonMark/Markdown).</summary>
    function Description: string; overload;
    /// <summary>Define a explicação detalhada do comportamento da operação (suporta CommonMark/Markdown).</summary>
    function Description(const AValue: string): IOperation<T>; overload;
    /// <summary>Retorna a documentação externa adicional para esta operação.</summary>
    function ExternalDocs: IExternalDocumentation<IOperation<T>>;
    /// <summary>Obtém o identificador único (<c>operationId</c>) da operação.</summary>
    function OperationId: string; overload;
    /// <summary>Define o identificador único (<c>operationId</c>) da operação.</summary>
    function OperationId(const AValue: string): IOperation<T>; overload;
    /// <summary>Retorna a lista de parâmetros (<c>IParameter</c>) aplicáveis a esta operação.</summary>
    function Parameters: TOpenApiList<IParameter<IOperation<T>>, IOperation<T>>;
    /// <summary>Retorna a definição do corpo da requisição (<c>IRequestBody</c>) desta operação.</summary>
    function RequestBody: IRequestBody<IOperation<T>>;
    /// <summary>Retorna o contêiner de respostas (<c>IResponses</c>) esperadas para esta operação.</summary>
    function Responses: IResponses<IOperation<T>>;
    /// <summary>Obtém se a operação está marcada como obsoleta (<c>deprecated</c>).</summary>
    function Deprecated: Boolean; overload;
    /// <summary>Define se a operação está marcada como obsoleta (<c>deprecated</c>).</summary>
    function Deprecated(const AValue: Boolean): IOperation<T>; overload;
    /// <summary>Retorna a lista de requisitos de segurança específicos desta operação.</summary>
    function Security: TOpenApiList<ISecurityRequirement<IOperation<T>>, IOperation<T>>;
    /// <summary>Retorna a lista de servidores alternativos para atender a esta operação.</summary>
    function Servers: TOpenApiList<IServer<IOperation<T>>, IOperation<T>>;
    /// <summary>Retorna a lista de exemplos de código (<c>ICodeSample</c>, extensão <c>x-code-samples</c>).</summary>
    function CodeSamples: TOpenApiList<ICodeSample<IOperation<T>>, IOperation<T>>;
    /// <summary>Retorna ao objeto pai (<c>T</c>).</summary>
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
