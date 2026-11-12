unit Horse.Documentation.OpenApi.Response;

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
  ///   Implementação do objeto Response da especificação OpenAPI (<c>IResponse&lt;T&gt;</c>),
  ///   descrevendo uma única resposta HTTP (descrição, headers, conteúdo por media type e links).
  /// </summary>
  TResponse<T> = class(TOpenApiAncestor, IResponse<T>)
  private
    FParent: T;
    FDescription: string;
    FHeaders: TOpenApiMap<IHeader<IResponse<T>>, IResponse<T>>;
    FContent: TOpenApiMap<IMediaType<IResponse<T>>, IResponse<T>>;
    FLinks: TOpenApiMap<ILink<IResponse<T>>, IResponse<T>>;

    constructor Create(AParent: T);
  public
    /// <summary>Cria uma nova instância de <c>IResponse&lt;T&gt;</c> vinculada ao objeto pai <c>AParent</c>.</summary>
    class function New(AParent: T): IResponse<T>; static;
    /// <summary>Serializa a definição de resposta para <c>TJSONObject</c>.</summary>
    function ToJson: TJSONObject; override;

    /// <summary>Obtém a descrição obrigatória da resposta (suporta CommonMark/Markdown).</summary>
    function Description: string; overload;
    /// <summary>Define a descrição obrigatória da resposta (suporta CommonMark/Markdown).</summary>
    function Description(const AValue: string): IResponse<T>; overload;
    /// <summary>Retorna o mapa de cabeçalhos HTTP (<c>IHeader</c>) retornados com a resposta.</summary>
    function Headers: TOpenApiMap<IHeader<IResponse<T>>, IResponse<T>>;
    /// <summary>Retorna o mapa de payloads (<c>IMediaType</c>) retornados pela resposta.</summary>
    function Content: TOpenApiMap<IMediaType<IResponse<T>>, IResponse<T>>;
    /// <summary>Retorna o mapa de links de design-time (<c>ILink</c>) associados à resposta.</summary>
    function Links: TOpenApiMap<ILink<IResponse<T>>, IResponse<T>>;
    /// <summary>Retorna ao objeto pai (<c>T</c>).</summary>
    function &End: T;
  end;

implementation

uses
  Horse.Documentation.OpenApi.Link,
  Horse.Documentation.OpenApi.Header,
  Horse.Documentation.OpenApi.MediaType;

{ TResponse<T> }

function TResponse<T>.&End: T;
begin
  Result := FParent;
end;

function TResponse<T>.Content: TOpenApiMap<IMediaType<IResponse<T>>, IResponse<T>>;
begin
  if FContent = nil then
    FContent := TOpenApiMap<IMediaType<IResponse<T>>, IResponse<T>>.Create(Self, TMediaType<IResponse<T>>);
  Result := FContent;
end;

function TResponse<T>.Headers: TOpenApiMap<IHeader<IResponse<T>>, IResponse<T>>;
begin
  if FHeaders = nil then
    FHeaders := TOpenApiMap<IHeader<IResponse<T>>, IResponse<T>>.Create(Self, THeader<IResponse<T>>);
  Result := FHeaders;
end;

function TResponse<T>.Links: TOpenApiMap<ILink<IResponse<T>>, IResponse<T>>;
begin
  if FLinks = nil then
    FLinks := TOpenApiMap<ILink<IResponse<T>>, IResponse<T>>.Create(Self, TLink<IResponse<T>>);
  Result := FLinks;
end;

constructor TResponse<T>.Create(AParent: T);
begin
  inherited Create;
  FParent := AParent;
end;

function TResponse<T>.Description(const AValue: string): IResponse<T>;
begin
  Result := Self;
  FDescription := AValue;
end;

function TResponse<T>.Description: string;
begin
  Result := FDescription;
end;

class function TResponse<T>.New(AParent: T): IResponse<T>;
begin
  Result := TResponse<T>.Create(AParent);
end;

function TResponse<T>.ToJson: TJSONObject;
begin
  Result := inherited ToJson;

  Result.AddPair('description', FDescription);

  if (FHeaders <> nil) and (FHeaders.Count > 0) then
    Result.AddPair('headers', FHeaders.ToJson);

  if (FContent <> nil) and (FContent.Count > 0) then
    Result.AddPair('content', FContent.ToJson);

  if (FLinks <> nil) and (FLinks.Count > 0) then
    Result.AddPair('links', FLinks.ToJson);
end;

end.

