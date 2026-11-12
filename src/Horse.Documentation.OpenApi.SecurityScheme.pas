unit Horse.Documentation.OpenApi.SecurityScheme;

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
  ///   Implementação do objeto Security Scheme da especificação OpenAPI (<c>ISecurityScheme</c>),
  ///   definindo mecanismos de autenticação e autorização (<c>apiKey</c>, <c>http</c>, <c>mutualTLS</c>, <c>oauth2</c>, <c>openIdConnect</c>).
  /// </summary>
  TSecurityScheme = class(TOpenApiAncestor, ISecurityScheme)
  private
    [Weak]
    FParent: IComponents;
    FType: TSecuritySchemeType;
    FDescription: string;
    FName: string;
    FIn: TApiKeyLocation;
    FScheme: string;
    FBearerFormat: string;
    FFlows: IOAuthFlows;
    FOpenIdConnectUrl: string;

    constructor Create(AParent: IComponents);
  public
    /// <summary>Cria uma nova instância de <c>ISecurityScheme</c> vinculada ao contêiner <c>IComponents</c>.</summary>
    class function New(AParent: IComponents): ISecurityScheme; static;
    /// <summary>Serializa a definição do esquema de segurança para <c>TJSONObject</c>.</summary>
    function ToJson: TJSONObject; override;

    /// <summary>Obtém o tipo do esquema de segurança (<c>TSecuritySchemeType</c>).</summary>
    function &Type: TSecuritySchemeType; overload;
    /// <summary>Define o tipo do esquema de segurança (<c>TSecuritySchemeType</c>).</summary>
    function &Type(const AValue: TSecuritySchemeType): ISecurityScheme; overload;
    /// <summary>Obtém a descrição do esquema de segurança (suporta CommonMark/Markdown).</summary>
    function Description: string; overload;
    /// <summary>Define a descrição do esquema de segurança (suporta CommonMark/Markdown).</summary>
    function Description(const AValue: string): ISecurityScheme; overload;
    /// <summary>Obtém o nome do parâmetro de header, query ou cookie usado em <c>sstApiKey</c>.</summary>
    function Name: string; overload;
    /// <summary>Define o nome do parâmetro de header, query ou cookie usado em <c>sstApiKey</c>.</summary>
    function Name(const AValue: string): ISecurityScheme; overload;
    /// <summary>Obtém a localização da chave de API (<c>aklQuery</c>, <c>aklHeader</c>, <c>aklCookie</c>).</summary>
    function &In: TApiKeyLocation; overload;
    /// <summary>Define a localização da chave de API (<c>aklQuery</c>, <c>aklHeader</c>, <c>aklCookie</c>).</summary>
    function &In(const AValue: TApiKeyLocation): ISecurityScheme; overload;
    /// <summary>Obtém o nome do esquema HTTP Authorization (ex: <c>bearer</c>, <c>basic</c>).</summary>
    function Scheme: string; overload;
    /// <summary>Define o nome do esquema HTTP Authorization (ex: <c>bearer</c>, <c>basic</c>).</summary>
    function Scheme(const AValue: string): ISecurityScheme; overload;
    /// <summary>Obtém o formato do token Bearer (ex: <c>JWT</c>).</summary>
    function BearerFormat: string; overload;
    /// <summary>Define o formato do token Bearer (ex: <c>JWT</c>).</summary>
    function BearerFormat(const AValue: string): ISecurityScheme; overload;
    /// <summary>Retorna a configuração dos fluxos OAuth 2.0 (<c>IOAuthFlows</c>).</summary>
    function Flows: IOAuthFlows;
    /// <summary>Obtém a URL de descoberta do provedor OpenID Connect (<c>openIdConnectUrl</c>).</summary>
    function OpenIdConnectUrl: string; overload;
    /// <summary>Define a URL de descoberta do provedor OpenID Connect (<c>openIdConnectUrl</c>).</summary>
    function OpenIdConnectUrl(const AValue: string): ISecurityScheme; overload;
    /// <summary>Retorna ao contêiner pai (<c>IComponents</c>).</summary>
    function &End: IComponents;
  end;

implementation

uses
  Horse.Documentation.OpenApi.OAuthFlows;

{ TSecurityScheme }

function TSecurityScheme.BearerFormat(const AValue: string): ISecurityScheme;
begin
  Result := Self;
  FBearerFormat := AValue;
end;

function TSecurityScheme.BearerFormat: string;
begin
  Result := FBearerFormat
end;

function TSecurityScheme.&In: TApiKeyLocation;
begin
  Result := FIn;
end;

function TSecurityScheme.&In(const AValue: TApiKeyLocation): ISecurityScheme;
begin
  Result := Self;
  FIn := AValue;
end;

function TSecurityScheme.&Type: TSecuritySchemeType;
begin
  Result := FType;
end;

function TSecurityScheme.&Type(const AValue: TSecuritySchemeType): ISecurityScheme;
begin
  Result := Self;
  FType := AValue;
end;

constructor TSecurityScheme.Create(AParent: IComponents);
begin
  inherited Create;
  FParent := AParent;
end;

function TSecurityScheme.Description: string;
begin
  Result := FDescription;
end;

function TSecurityScheme.Description(const AValue: string): ISecurityScheme;
begin
  Result := Self;
  FDescription := AValue;
end;

function TSecurityScheme.&End: IComponents;
begin
  Result := FParent;
end;

function TSecurityScheme.Flows: IOAuthFlows;
begin
  if FFlows = nil then
    FFlows := TOAuthFlows.New(Self);
  Result := FFlows;
end;

function TSecurityScheme.Name(const AValue: string): ISecurityScheme;
begin
  Result := Self;
  FName := AValue;
end;

function TSecurityScheme.Name: string;
begin
  Result := FName;
end;

class function TSecurityScheme.New(AParent: IComponents): ISecurityScheme;
begin
  Result := TSecurityScheme.Create(AParent);
end;

function TSecurityScheme.OpenIdConnectUrl(const AValue: string): ISecurityScheme;
begin
  Result := Self;
  FOpenIdConnectUrl := AValue;
end;

function TSecurityScheme.OpenIdConnectUrl: string;
begin
  Result := FOpenIdConnectUrl;
end;

function TSecurityScheme.Scheme: string;
begin
  Result := FScheme;
end;

function TSecurityScheme.Scheme(const AValue: string): ISecurityScheme;
begin
   Result := Self;
   FScheme := AValue;
end;

function TSecurityScheme.ToJson: TJSONObject;
begin
  Result := inherited ToJson;

  Result.AddPair('type', FType.ToString);
  if not FDescription.IsEmpty then
    Result.AddPair('description', FDescription);

  case FType of
    sstApiKey:
      Result.AddPair('name', FName)
        .AddPair('in', FIn.ToString);
    sstHttp:
      begin
        Result.AddPair('scheme', FScheme);
        if not FBearerFormat.IsEmpty then
          Result.AddPair('bearerFormat', FBearerFormat);
      end;
    sstOAuth2:
      begin
        if FFlows <> nil then
          Result.AddPair('flows', FFlows.ToJson);
      end;
    sstOpenIdConnect:
      Result.AddPair('openIdConnectUrl', FOpenIdConnectUrl);
  end;
end;

end.
