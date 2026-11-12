unit Horse.Documentation.OpenApi.Types;

interface

uses
  System.JSON,
  System.Rtti,
  System.TypInfo,
  System.SysUtils,
  System.Generics.Collections;

type
  /// <summary>Define os locais possíveis para um parâmetro.</summary>
  TParameterLocation = (plQuery, plHeader, plPath, plCookie);

  TParameterLocationHelper = record helper for TParameterLocation
  public
    function ToString: string;
  end;

  /// <summary>Define os estilos de serialização para um parâmetro.</summary>
  TParameterStyle = (psMatrix, psLabel, psSimple, psForm, psSpaceDelimited, psPipeDelimited, psDeepObject);

  TParameterStyleHelper = record helper for TParameterStyle
  public
    function ToString: string;
  end;

  /// <summary>Define os tipos de esquemas de segurança.</summary>
  TSecuritySchemeType = (sstApiKey, sstHttp, sstMutualTLS, sstOAuth2, sstOpenIdConnect);

  TSecuritySchemeTypeHelper = record helper for TSecuritySchemeType
  public
    function ToString: string;
  end;

  /// <summary>Define a localização de uma chave de API.</summary>
  TApiKeyLocation = (aklQuery, aklHeader, aklCookie);

  TApiKeyLocationHelper = record helper for TApiKeyLocation
  public
    function ToString: string;
  end;

  /// <summary>
  ///   Uma lista especializada para as interfaces da OpenAPI.
  ///   Permite a criação automática de instâncias de uma classe de
  ///   implementação registrada, facilitando o uso do padrão Builder.
  /// </summary>
  TOpenApiList<T, O> = class(TList<T>)
  private
    FOwner: O;
    FImplClass: TClass;
    FCreateMethod: TRttiMethod;
    FRttiContext: TRttiContext;
  public
    /// <summary>
    ///   Cria a lista e a prepara para o padrão Builder.
    /// </summary>
    /// <param name="AOwner">
    ///   A instância do objeto "pai" ao qual os novos itens pertencerão.
    ///   Usado para a navegação de volta com a função &End.
    /// </param>
    /// <param name="AImplClass">
    ///   A classe concreta que implementa a interface T.
    ///   Esta classe DEVE ter um método estático "New" que aceita o Owner como parâmetro.
    ///   Ex: class function New(AOwner: IOpenApi): IServer;
    /// </param>
    constructor Create(AOwner: O; AImplClass: TClass = nil); overload;

    /// <summary>
    ///   Cria uma lista simples, sem a capacidade de adicionar
    ///   automaticamente novas instâncias.
    /// </summary>
    constructor Create; overload;
    destructor Destroy; override;

    /// <summary>
    ///   Cria uma nova instância da classe registrada,
    ///   adiciona-a à lista e a retorna para construção fluente.
    ///   Só funciona se a lista foi criada com o construtor que recebe AImplClass.
    /// </summary>
    function Add: T; overload;

    /// <summary>
    ///   Adiciona um valor diretamente à lista e retorna a referência do objeto pai (<c>O</c>)
    ///   para continuidade do encadeamento fluente (Builder).
    /// </summary>
    /// <param name="AValue">Valor ou interface a ser adicionada à lista.</param>
    /// <returns>Instância do objeto pai (<c>FOwner</c>).</returns>
    function Add(const AValue: T): O; overload;

    /// <summary>
    ///   Alias para Add. Cria uma nova instância, adiciona e retorna.
    /// </summary>
    function Append: T;

    /// <summary>
    ///   Alias para Add. Cria uma nova instância, adiciona e retorna.
    /// </summary>
    function Push: T;

    /// <summary>
    ///   Remove o último elemento da lista e o retorna, sem liberar sua memória.
    /// </summary>
    function Pop: T;

    /// <summary>
    ///   Serializa todos os itens da lista para um <c>TJSONArray</c>.
    /// </summary>
    function ToJson: TJSONArray;
  end;

  /// <summary>Um mapa especializado para as interfaces da OpenAPI.</summary>
  TOpenApiMap<T, O> = class(TDictionary<string, T>)
  private
    FOwner: O;
    FImplClass: TClass;
    FCreateMethod: TRttiMethod;
    FRttiContext: TRttiContext;
  public
    /// <summary>
    ///   Cria o mapa e o prepara para o padrão Builder.
    /// </summary>
    /// <param name="AOwner">
    ///   A instância do objeto "pai" ao qual os novos itens pertencerão.
    /// </param>
    /// <param name="AImplClass">
    ///   A classe concreta que implementa a interface T.
    ///   Deve ter um método estático "New" que aceita o Owner como parâmetro.
    /// </param>
    constructor Create(AOwner: O; AImplClass: TClass = nil); overload;

    /// <summary>
    ///   Cria um mapa simples, sem a capacidade de adicionar
    ///   automaticamente novas instâncias.
    /// </summary>
    constructor Create; overload;
    destructor Destroy; override;

    /// <summary>
    ///   Cria uma nova instância da classe registrada, adiciona-a ao mapa com
    ///   a chave especificada e a retorna para construção fluente.
    ///   Se a chave já existir, retorna a instância existente.
    /// </summary>
    function Add(const AKey: string): T;

    /// <summary>
    ///   Adiciona um par chave/valor diretamente ao mapa e retorna o objeto pai (<c>O</c>)
    ///   para construção fluente.
    /// </summary>
    /// <param name="AKey">Chave de identificação no mapa.</param>
    /// <param name="AValue">Valor associado à chave.</param>
    /// <returns>Instância do objeto pai (<c>FOwner</c>).</returns>
    function AddValue(const AKey: string; const AValue: T): O;

    /// <summary>
    ///   Serializa todos os pares do mapa para um <c>TJSONObject</c>.
    /// </summary>
    function ToJson: TJSONObject;
  end;

implementation

uses
  Horse.Documentation.OpenApi.Utils,
  Horse.Documentation.OpenApi.Interfaces;

{ TOpenApiList<T, O> }

constructor TOpenApiList<T, O>.Create;
begin
  // AOwnsObjects = True é o padrão para TObjectList, o que garante que as
  // interfaces adicionadas serão liberadas quando a lista for destruída.
  inherited Create;
  FImplClass    := nil;
  FCreateMethod := nil;
end;

destructor TOpenApiList<T, O>.Destroy;
begin
  FRttiContext.Free;
  inherited;
end;

constructor TOpenApiList<T, O>.Create(AOwner: O; AImplClass: TClass);
var
  LRttiType: TRttiType;
  LMethod: TRttiMethod;
begin
  Create;
  FOwner := AOwner;
  FImplClass := AImplClass;

  if FImplClass = nil then
    Exit;

  FRttiContext := TRttiContext.Create;
  FRttiContext.KeepContext;
  LRttiType := FRttiContext.GetType(FImplClass);

  for LMethod in LRttiType.GetMethods('New') do
  begin
    if LMethod.IsStatic and (Length(LMethod.GetParameters) = 1) then
    begin
      FCreateMethod := LMethod;
      Exit;
    end;
  end;

  if FCreateMethod = nil then
    raise ENotSupportedException.CreateFmt(
      'A classe "%s" não possui um método de fábrica compatível (ex: class function New(AOwner: T): T).',
      [FImplClass.ClassName]);
end;

function TOpenApiList<T, O>.Add: T;
var
  LNewInstanceValue: TValue;
begin
  if FCreateMethod = nil then
    raise ENotImplemented.Create(
      'O método Add sem parâmetros só pode ser usado com o construtor ' +
      'que especifica uma classe de implementação (AImplClass).');

  LNewInstanceValue := FCreateMethod.Invoke(FImplClass, [TValue.From<O>(FOwner)]);
  Result := LNewInstanceValue.AsType<T>;
  inherited Add(Result);
end;

function TOpenApiList<T, O>.Add(const AValue: T): O;
begin
  inherited Add(AValue);
  Result := FOwner;
end;

function TOpenApiList<T, O>.Append: T;
begin
  Result := Add;
end;

function TOpenApiList<T, O>.Push: T;
begin
  Result := Add;
end;

function TOpenApiList<T, O>.ToJson: TJSONArray;
var
  LItem: T;
  LVal: TValue;
  LAncestor: IOpenApiAncestor;
begin
  Result := TJSONArray.Create;
  for LItem in Self do
  begin
    LVal := TValue.From<T>(LItem);
    if (LVal.Kind = tkInterface) and Supports(LVal.AsInterface, IOpenApiAncestor, LAncestor) then
      Result.AddElement(LAncestor.ToJson)
    else if LVal.IsObject and Supports(LVal.AsObject, IOpenApiAncestor, LAncestor) then
      Result.AddElement(LAncestor.ToJson)
    else
      Result.AddElement(TUtils.ValueToJson(LVal));
  end;
end;

function TOpenApiList<T, O>.Pop: T;
begin
  if Count = 0 then
    raise EListError.Create('A lista está vazia.');

  Result := Last;
  Delete(Count - 1);
end;

{ TOpenApiMap<T, O> }

function TOpenApiMap<T, O>.Add(const AKey: string): T;
var
  LNewInstanceValue: TValue;
begin
  // Otimizado: Usa o FCreateMethod armazenado
  if FCreateMethod = nil then
    raise ENotImplemented.Create(
      'O método Add com criação automática só pode ser usado com o construtor ' +
      'que especifica uma classe de implementação (AImplClass).');

  if ContainsKey(AKey) then
    Exit(Items[AKey]);

  LNewInstanceValue := FCreateMethod.Invoke(FImplClass, [TValue.From<O>(FOwner)]);
  Result := LNewInstanceValue.AsType<T>;
  inherited Add(AKey, Result);
end;

constructor TOpenApiMap<T, O>.Create(AOwner: O; AImplClass: TClass);
var
  LRttiType: TRttiType;
  LMethod: TRttiMethod;
begin
  Create; // Chama o construtor padrão para inicializar
  FOwner := AOwner;
  FImplClass := AImplClass;

  if FImplClass = nil then
    Exit;

  FRttiContext := TRttiContext.Create;
  FRttiContext.KeepContext;
  LRttiType := FRttiContext.GetType(FImplClass);

  for LMethod in LRttiType.GetMethods('New') do
  begin
    if LMethod.IsStatic and (Length(LMethod.GetParameters) = 1) then
    begin
      FCreateMethod := LMethod;
      Exit;
    end;
  end;

  if FCreateMethod = nil then
    raise ENotSupportedException.CreateFmt(
      'A classe "%s" não possui um método de fábrica compatível (ex: class function New(AOwner: T): T).',
      [FImplClass.ClassName]);
end;

function TOpenApiMap<T, O>.AddValue(const AKey: string; const AValue: T): O;
begin
  // Otimizado: Usa o FCreateMethod armazenado
  if FCreateMethod <> nil then
    raise ENotImplemented.Create(
      'O método Add sem criação automática só pode ser usado com o construtor ' +
      'que não especifica uma classe de implementação (AImplClass).');

  inherited Add(AKey, AValue);
  Result := FOwner;
end;

constructor TOpenApiMap<T, O>.Create;
begin
  inherited Create;
  FImplClass    := nil;
  FCreateMethod := nil;
end;

destructor TOpenApiMap<T, O>.Destroy;
begin
  FRttiContext.Free;
  inherited;
end;

function TOpenApiMap<T, O>.ToJson: TJSONObject;
var
  LPair: TPair<string, T>;
  LVal: TValue;
  LAncestor: IOpenApiAncestor;
begin
  Result := TJSONObject.Create;
  for LPair in Self do
  begin
    LVal := TValue.From<T>(LPair.Value);
    if (LVal.Kind = tkInterface) and Supports(LVal.AsInterface, IOpenApiAncestor, LAncestor) then
      Result.AddPair(LPair.Key, LAncestor.ToJson)
    else if LVal.IsObject and Supports(LVal.AsObject, IOpenApiAncestor, LAncestor) then
      Result.AddPair(LPair.Key, LAncestor.ToJson)
    else
      Result.AddPair(LPair.Key, TUtils.ValueToJson(LVal));
  end;
end;

{ TParameterLocationHelper }

function TParameterLocationHelper.ToString: string;
begin
  case Self of
    plQuery:  Result := 'query';
    plHeader: Result := 'header';
    plPath:   Result := 'path';
    plCookie: Result := 'cookie';
  end;
end;

{ TParameterStyleHelper }

function TParameterStyleHelper.ToString: string;
begin
  case Self of
    psMatrix:         Result := 'matrix';
    psLabel:          Result := 'label';
    psSimple:         Result := 'simple';
    psForm:           Result := 'form';
    psSpaceDelimited: Result := 'spaceDelimited';
    psPipeDelimited:  Result := 'pipeDelimited';
    psDeepObject:     Result := 'deepObject';
  end;
end;

{ TSecuritySchemeTypeHelper }

function TSecuritySchemeTypeHelper.ToString: string;
begin
  case Self of
    sstApiKey:        Result := 'apiKey';
    sstHttp:          Result := 'http';
    sstMutualTLS:     Result := 'mutualTLS';
    sstOAuth2:        Result := 'oauth2';
    sstOpenIdConnect: Result := 'openIdConnect';
  end;
end;

{ TApiKeyLocationHelper }

function TApiKeyLocationHelper.ToString: string;
begin
  case Self of
    aklQuery:  Result := 'query';
    aklHeader: Result := 'header';
    aklCookie: Result := 'cookie';
  end;
end;

end.
