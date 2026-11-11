unit Horse.Documentation.OpenApi.Parameter;

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
  ///   Implementação do objeto Parameter da especificação OpenAPI (<c>IParameter&lt;T&gt;</c>),
  ///   descrevendo um único parâmetro de operação ou de caminho (<c>query</c>, <c>header</c>, <c>path</c> ou <c>cookie</c>).
  /// </summary>
  TParameter<T> = class(TOpenApiAncestor, IParameter<T>)
  private
    FParent: T;
    FName: string;
    FIn: TParameterLocation;
    FDescription: string;
    FRequired: Boolean;
    FDeprecated: Boolean;
    FAllowEmptyValue: Boolean;
    FStyle: TParameterStyle;
    FExplode: Boolean;
    FAllowReserved: Boolean;
    FSchema: ISchema;
    FExample: TJSONValue;
    FExamples: TOpenApiMap<IExample<IParameter<T>>, IParameter<T>>;
    FContent: TOpenApiMap<IMediaType<IParameter<T>>, IParameter<T>>;

    constructor Create(AParent: T);
  public
    /// <summary>Cria uma nova instância de <c>IParameter&lt;T&gt;</c> vinculada ao objeto pai <c>AParent</c>.</summary>
    class function New(AParent: T): IParameter<T>; static;
    /// <summary>Serializa a definição do parâmetro para <c>TJSONObject</c>.</summary>
    function ToJson: TJSONObject;

    /// <summary>Obtém o nome do parâmetro (case-sensitive).</summary>
    function Name: string; overload;
    /// <summary>Define o nome do parâmetro (case-sensitive).</summary>
    function Name(const AValue: string): IParameter<T>; overload;
    /// <summary>Obtém a localização do parâmetro (<c>plQuery</c>, <c>plHeader</c>, <c>plPath</c>, <c>plCookie</c>).</summary>
    function &In: TParameterLocation; overload;
    /// <summary>Define a localização do parâmetro (<c>plQuery</c>, <c>plHeader</c>, <c>plPath</c>, <c>plCookie</c>).</summary>
    function &In(const AValue: TParameterLocation): IParameter<T>; overload;
    /// <summary>Obtém a descrição do parâmetro (suporta CommonMark/Markdown).</summary>
    function Description: string; overload;
    /// <summary>Define a descrição do parâmetro (suporta CommonMark/Markdown).</summary>
    function Description(const AValue: string): IParameter<T>; overload;
    /// <summary>Obtém se o parâmetro é obrigatório (sempre <c>True</c> quando <c>In = plPath</c>).</summary>
    function Required: Boolean; overload;
    /// <summary>Define se o parâmetro é obrigatório.</summary>
    function Required(const AValue: Boolean): IParameter<T>; overload;
    /// <summary>Obtém se o parâmetro está marcado como obsoleto (<c>deprecated</c>).</summary>
    function Deprecated: Boolean; overload;
    /// <summary>Define se o parâmetro está marcado como obsoleto (<c>deprecated</c>).</summary>
    function Deprecated(const AValue: Boolean): IParameter<T>; overload;
    /// <summary>Obtém se o parâmetro aceita valor vazio (válido para parâmetros <c>query</c>).</summary>
    function AllowEmptyValue: Boolean; overload;
    /// <summary>Define se o parâmetro aceita valor vazio (válido para parâmetros <c>query</c>).</summary>
    function AllowEmptyValue(const AValue: Boolean): IParameter<T>; overload;
    /// <summary>Obtém o estilo de serialização do valor do parâmetro.</summary>
    function Style: TParameterStyle; overload;
    /// <summary>Define o estilo de serialização do valor do parâmetro.</summary>
    function Style(const AValue: TParameterStyle): IParameter<T>; overload;
    /// <summary>Obtém se arrays/objetos devem gerar parâmetros separados (<c>explode</c>).</summary>
    function Explode: Boolean; overload;
    /// <summary>Define se arrays/objetos devem gerar parâmetros separados (<c>explode</c>).</summary>
    function Explode(const AValue: Boolean): IParameter<T>; overload;
    /// <summary>Obtém se caracteres reservados (RFC6570) são permitidos sem codificação.</summary>
    function AllowReserved: Boolean; overload;
    /// <summary>Define se caracteres reservados (RFC6570) são permitidos sem codificação.</summary>
    function AllowReserved(const AValue: Boolean): IParameter<T>; overload;
    /// <summary>Obtém o JSON Schema que define o tipo de dado do parâmetro.</summary>
    function Schema: ISchema; overload;
    /// <summary>Define o JSON Schema que define o tipo de dado do parâmetro.</summary>
    function Schema(const AValue: ISchema): IParameter<T>; overload;
    /// <summary>Obtém o valor de exemplo único do parâmetro.</summary>
    function Example: TJSONValue; overload;
    /// <summary>Define o valor de exemplo único do parâmetro.</summary>
    function Example(const AValue: TJSONValue): IParameter<T>; overload;
    /// <summary>Retorna o mapa de exemplos nomeados (<c>IExample</c>) para este parâmetro.</summary>
    function Examples: TOpenApiMap<IExample<IParameter<T>>, IParameter<T>>;
    /// <summary>Retorna o mapa de representações por media type (<c>IMediaType</c>) para este parâmetro.</summary>
    function Content: TOpenApiMap<IMediaType<IParameter<T>>, IParameter<T>>;
    /// <summary>Retorna ao objeto pai (<c>T</c>).</summary>
    function &End: T;
  end;

implementation

uses
  Horse.Documentation.OpenApi.Example,
  Horse.Documentation.OpenApi.MediaType;

{ TParameter<T> }

function TParameter<T>.AllowEmptyValue(const AValue: Boolean): IParameter<T>;
begin
  Result := Self;
  FAllowEmptyValue := AValue;
end;

function TParameter<T>.AllowEmptyValue: Boolean;
begin
  Result := FAllowEmptyValue;
end;

function TParameter<T>.AllowReserved(const AValue: Boolean): IParameter<T>;
begin
  Result := Self;
  FAllowReserved := AValue;
end;

function TParameter<T>.AllowReserved: Boolean;
begin
  Result := FAllowReserved;
end;

function TParameter<T>.Content: TOpenApiMap<IMediaType<IParameter<T>>, IParameter<T>>;
begin
  if FContent = nil then
    FContent := TOpenApiMap<IMediaType<IParameter<T>>, IParameter<T>>.Create(Self, TMediaType<IParameter<T>>);
  Result := FContent;
end;

function TParameter<T>.&In(const AValue: TParameterLocation): IParameter<T>;
begin
  Result := Self;
  FIn := AValue;
end;

function TParameter<T>.&In: TParameterLocation;
begin
  Result := FIn;
end;

constructor TParameter<T>.Create(AParent: T);
begin
  inherited Create;
  FParent := AParent;
end;

function TParameter<T>.Description: string;
begin
  Result := FDescription;
end;

function TParameter<T>.Deprecated(const AValue: Boolean): IParameter<T>;
begin
  Result := Self;
  FDeprecated := AValue;
end;

function TParameter<T>.Deprecated: Boolean;
begin
  Result := FDeprecated;
end;

function TParameter<T>.Description(const AValue: string): IParameter<T>;
begin
  Result := Self;
  FDescription := AValue;
end;

function TParameter<T>.&End: T;
begin
  Result := FParent;
end;

function TParameter<T>.Example(const AValue: TJSONValue): IParameter<T>;
begin
  Result := Self;
  FExample := AValue;
end;

function TParameter<T>.Example: TJSONValue;
begin
  Result := FExample;
end;

function TParameter<T>.Examples: TOpenApiMap<IExample<IParameter<T>>, IParameter<T>>;
begin
  if FExamples = nil then
    FExamples := TOpenApiMap<IExample<IParameter<T>>, IParameter<T>>.Create(Self, TExample<IParameter<T>>);
  Result := FExamples;
end;

function TParameter<T>.Explode(const AValue: Boolean): IParameter<T>;
begin
  Result := Self;
  FExplode := AValue;
end;

function TParameter<T>.Explode: Boolean;
begin
  Result := FExplode;
end;

function TParameter<T>.Name: string;
begin
  Result := FName;
end;

function TParameter<T>.Name(const AValue: string): IParameter<T>;
begin
  Result := Self;
  FName := AValue;
end;

class function TParameter<T>.New(AParent: T): IParameter<T>;
begin
  Result := TParameter<T>.Create(AParent);
end;

function TParameter<T>.Required(const AValue: Boolean): IParameter<T>;
begin
  Result := Self;
  FRequired := AValue;
end;

function TParameter<T>.Required: Boolean;
begin
  Result := FRequired;
end;

function TParameter<T>.Schema: ISchema;
begin
  Result := FSchema;
end;

function TParameter<T>.Style: TParameterStyle;
begin
  Result := FStyle;
end;

function TParameter<T>.Schema(const AValue: ISchema): IParameter<T>;
begin
  Result := Self;
  FSchema := AValue;
end;

function TParameter<T>.Style(const AValue: TParameterStyle): IParameter<T>;
begin
  Result := Self;
  FStyle := AValue;
end;

function TParameter<T>.ToJson: TJSONObject;
var
  LDefaultStyle: TParameterStyle;
  LDefaultExplode: Boolean;
begin
  Result := inherited ToJson;

  Result.AddPair('name', FName);
  Result.AddPair('in', FIn.ToString);

  if not FDescription.IsEmpty then
    Result.AddPair('description', FDescription);

  if FRequired then
    Result.AddPair('required', FRequired);

  if FDeprecated then
    Result.AddPair('deprecated', FDeprecated);

  if FAllowEmptyValue then
    Result.AddPair('allowEmptyValue', FAllowEmptyValue);

  if FSchema <> nil then
  begin
    Result.AddPair('schema', FSchema);

    LDefaultStyle := TParameterStyle.psSimple;
    if FIn in [plQuery, plCookie] then
      LDefaultStyle := TParameterStyle.psForm;

    if FStyle <> LDefaultStyle then
      Result.AddPair('style', FStyle.ToString);

    LDefaultExplode := FStyle = psForm;
    if FExplode <> LDefaultExplode then
      Result.AddPair('explode', FExplode);

    if FAllowReserved then
      Result.AddPair('allowReserved', FAllowReserved);

    if FExample <> nil then
      Result.AddPair('example', FExample);

    if (FExamples <> nil) and (FExamples.Count > 0) then
      Result.AddPair('examples', FExamples.ToJson);
  end;

  if (FContent <> nil) and (FContent.Count > 0) then
    Result.AddPair('content', FContent.ToJson);
end;

end.
