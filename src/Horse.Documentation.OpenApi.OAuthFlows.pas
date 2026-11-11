unit Horse.Documentation.OpenApi.OAuthFlows;

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
  ///   Implementação do objeto OAuth Flows da especificação OpenAPI (<c>IOAuthFlows</c>),
  ///   agrupando as configurações dos fluxos OAuth 2.0 suportados (<c>implicit</c>, <c>password</c>, <c>clientCredentials</c> e <c>authorizationCode</c>).
  /// </summary>
  TOAuthFlows = class(TOpenApiAncestor, IOAuthFlows)
  private
    [Weak]
    FParent: ISecurityScheme;
    FImplicit: IOAuthFlow;
    FPassword: IOAuthFlow;
    FClientCredentials: IOAuthFlow;
    FAuthorizationCode: IOAuthFlow;

    constructor Create(AParent: ISecurityScheme);
  public
    /// <summary>Cria uma nova instância de <c>IOAuthFlows</c> vinculada ao esquema <c>ISecurityScheme</c>.</summary>
    class function New(AParent: ISecurityScheme): IOAuthFlows; static;
    /// <summary>Serializa os fluxos OAuth 2.0 configurados para <c>TJSONObject</c>.</summary>
    function ToJson: TJSONObject;

    /// <summary>Retorna a configuração para o fluxo OAuth 2.0 Implicit.</summary>
    function Implicit: IOAuthFlow;
    /// <summary>Retorna a configuração para o fluxo OAuth 2.0 Resource Owner Password Credentials.</summary>
    function Password: IOAuthFlow;
    /// <summary>Retorna a configuração para o fluxo OAuth 2.0 Client Credentials.</summary>
    function ClientCredentials: IOAuthFlow;
    /// <summary>Retorna a configuração para o fluxo OAuth 2.0 Authorization Code.</summary>
    function AuthorizationCode: IOAuthFlow;
    /// <summary>Retorna ao esquema de segurança pai (<c>ISecurityScheme</c>).</summary>
    function &End: ISecurityScheme;
  end;

implementation

uses
  Horse.Documentation.OpenApi.OAuthFlow;

{ TOAuthFlows }

function TOAuthFlows.AuthorizationCode: IOAuthFlow;
begin
  if FAuthorizationCode = nil then
    FAuthorizationCode := TOAuthFlow.New(Self);
  Result := FAuthorizationCode;
end;

function TOAuthFlows.ClientCredentials: IOAuthFlow;
begin
  if FClientCredentials = nil then
    FClientCredentials := TOAuthFlow.New(Self);
  Result := FClientCredentials;
end;

constructor TOAuthFlows.Create(AParent: ISecurityScheme);
begin
  inherited Create;
  FParent := AParent;
end;

function TOAuthFlows.&End: ISecurityScheme;
begin
  Result := FParent;
end;

function TOAuthFlows.Implicit: IOAuthFlow;
begin
  if FImplicit = nil then
    FImplicit := TOAuthFlow.New(Self);
  Result := FImplicit;
end;

class function TOAuthFlows.New(AParent: ISecurityScheme): IOAuthFlows;
begin
  Result := TOAuthFlows.Create(AParent);
end;

function TOAuthFlows.Password: IOAuthFlow;
begin
  if FPassword = nil then
    FPassword := TOAuthFlow.New(Self);
  Result := FPassword;
end;

function TOAuthFlows.ToJson: TJSONObject;
begin
  Result := inherited ToJson;

  if FImplicit <> nil then
    Result.AddPair('implicit', FImplicit.ToJson);

  if FPassword <> nil then
    Result.AddPair('password', FPassword.ToJson);

  if FClientCredentials <> nil then
    Result.AddPair('clientCredentials', FClientCredentials.ToJson);

  if FAuthorizationCode <> nil then
    Result.AddPair('authorizationCode', FAuthorizationCode.ToJson);
end;

end.
