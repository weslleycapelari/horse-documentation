unit Horse.Documentation.OpenApi.RequestBody;

interface

uses
  System.JSON,
  System.Rtti,
  System.Classes,
  System.TypInfo,
  System.SysUtils,
  System.Generics.Collections,
  Horse.Documentation.OpenApi.Utils,
  Horse.Documentation.OpenApi.Types,
  Horse.Documentation.OpenApi.Ancestor,
  Horse.Documentation.OpenApi.Interfaces;

type
  /// <summary>
  ///   Implementação do objeto Request Body da especificação OpenAPI (<c>IRequestBody&lt;T&gt;</c>),
  ///   descrevendo o payload de entrada de uma operação por media type.
  /// </summary>
  TRequestBody<T> = class(TOpenApiAncestor, IRequestBody<T>)
  private
    FParent: T;
    FDescription: string;
    FContent: TOpenApiMap<IMediaType<IRequestBody<T>>, IRequestBody<T>>;
    FRequired: Boolean;

    constructor Create(AParent: T);
  public
    /// <summary>Cria uma nova instância de <c>IRequestBody&lt;T&gt;</c> vinculada ao objeto pai <c>AParent</c>.</summary>
    class function New(AParent: T): IRequestBody<T>; static;
    /// <summary>Serializa o corpo de requisição para <c>TJSONObject</c>.</summary>
    function ToJson: TJSONObject;

    /// <summary>Obtém a descrição do corpo da requisição (suporta CommonMark/Markdown).</summary>
    function Description: string; overload;
    /// <summary>Define a descrição do corpo da requisição (suporta CommonMark/Markdown).</summary>
    function Description(const AValue: string): IRequestBody<T>; overload;
    /// <summary>Retorna o mapa de media types (<c>IMediaType</c>, ex: <c>application/json</c>) aceitos no corpo.</summary>
    function Content: TOpenApiMap<IMediaType<IRequestBody<T>>, IRequestBody<T>>;
    /// <summary>Obtém se o corpo da requisição é obrigatório.</summary>
    function Required: Boolean; overload;
    /// <summary>Define se o corpo da requisição é obrigatório.</summary>
    function Required(const AValue: Boolean): IRequestBody<T>; overload;
    /// <summary>Retorna ao objeto pai (<c>T</c>).</summary>
    function &End: T;
  end;

implementation

uses
  Horse.Documentation.OpenApi.MediaType;

{ TRequestBody<T> }

function TRequestBody<T>.Content: TOpenApiMap<IMediaType<IRequestBody<T>>, IRequestBody<T>>;
begin
  if FContent = nil then
    FContent := TOpenApiMap<IMediaType<IRequestBody<T>>, IRequestBody<T>>.Create(Self, TMediaType<IRequestBody<T>>);
  Result := FContent;
end;

constructor TRequestBody<T>.Create(AParent: T);
begin
  inherited Create;
  FParent := AParent;
end;

function TRequestBody<T>.Description: string;
begin
  Result := FDescription;
end;

function TRequestBody<T>.Description(const AValue: string): IRequestBody<T>;
begin
  Result := Self;
  FDescription := AValue;
end;

function TRequestBody<T>.&End: T;
begin
  Result := FParent;
end;

class function TRequestBody<T>.New(AParent: T): IRequestBody<T>;
begin
  Result := TRequestBody<T>.Create(AParent);
end;

function TRequestBody<T>.Required(const AValue: Boolean): IRequestBody<T>;
begin
  Result := Self;
  FRequired := AValue;
end;

function TRequestBody<T>.Required: Boolean;
begin
  Result := FRequired;
end;

function TRequestBody<T>.ToJson: TJSONObject;
begin
  Result := inherited ToJson;

  if not FDescription.IsEmpty then
    Result.AddPair('description', FDescription);

  if FRequired then
    Result.AddPair('required', FRequired);

  if (FContent <> nil) and (FContent.Count > 0) then
    Result.AddPair('content', FContent.ToJson);
end;

end.
