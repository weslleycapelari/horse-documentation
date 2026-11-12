unit Horse.Documentation.OpenApi.SecurityRequirement;

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
  ///   Implementação do objeto Security Requirement da especificação OpenAPI (<c>ISecurityRequirement&lt;T&gt;</c>),
  ///   associando um esquema de segurança declarado em <c>components.securitySchemes</c> aos escopos exigidos.
  /// </summary>
  TSecurityRequirement<T> = class(TOpenApiAncestor, ISecurityRequirement<T>)
  private
    FParent: T;
    FSchemeName: string;
    FScopes: TOpenApiList<string, ISecurityRequirement<T>>;

    constructor Create(AParent: T);
  public
    /// <summary>Cria uma nova instância de <c>ISecurityRequirement&lt;T&gt;</c> vinculada ao objeto pai <c>AParent</c>.</summary>
    class function New(AParent: T): ISecurityRequirement<T>; static;
    /// <summary>Serializa o requisito de segurança para <c>TJSONObject</c>.</summary>
    function ToJson: TJSONObject; override;

    /// <summary>Obtém o nome do esquema de segurança referenciado.</summary>
    function SchemeName: string; overload;
    /// <summary>Define o nome do esquema de segurança referenciado.</summary>
    function SchemeName(const AValue: string): ISecurityRequirement<T>; overload;
    /// <summary>Retorna a lista de escopos necessários para o esquema (vazia para esquemas não-OAuth2/OIDC).</summary>
    function Scopes: TOpenApiList<string, ISecurityRequirement<T>>;
    /// <summary>Retorna ao objeto pai (<c>T</c>).</summary>
    function &End: T;
  end;

implementation

{ TSecurityRequirement<T> }

constructor TSecurityRequirement<T>.Create(AParent: T);
begin
  inherited Create;
  FParent := AParent;
  FScopes := TOpenApiList<string, ISecurityRequirement<T>>.Create(Self);
end;

function TSecurityRequirement<T>.&End: T;
begin
  Result := FParent;
end;

class function TSecurityRequirement<T>.New(AParent: T): ISecurityRequirement<T>;
begin
  Result := TSecurityRequirement<T>.Create(AParent);
end;

function TSecurityRequirement<T>.SchemeName: string;
begin
  Result := FSchemeName;
end;

function TSecurityRequirement<T>.SchemeName(const AValue: string): ISecurityRequirement<T>;
begin
  Result := Self;
  FSchemeName := AValue;
end;

function TSecurityRequirement<T>.Scopes: TOpenApiList<string, ISecurityRequirement<T>>;
begin
  Result := FScopes;
end;

function TSecurityRequirement<T>.ToJson: TJSONObject;
begin
  Result := inherited ToJson;

  if (not FSchemeName.IsEmpty) then
    Result.AddPair(FSchemeName, FScopes.ToJson);
end;

end.

