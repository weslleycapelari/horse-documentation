unit Horse.Documentation.OpenApi.Contact;

interface

uses
  System.JSON,
  System.Classes,
  System.SysUtils,
  Horse.Documentation.OpenApi.Ancestor,
  Horse.Documentation.OpenApi.Interfaces;

type
  /// <summary>
  ///   Implementação do objeto Contact da especificação OpenAPI (<c>IContact</c>),
  ///   representando informações de contato da pessoa ou organização responsável pela API.
  /// </summary>
  TContact = class(TOpenApiAncestor, IContact)
  private
    [Weak]
    FParent: IInfo;
    FName: string;
    FUrl: string;
    FEmail: string;

    constructor Create(AParent: IInfo);
  public
    /// <summary>Cria uma nova instância de <c>IContact</c> vinculada ao objeto <c>IInfo</c>.</summary>
    class function New(AParent: IInfo): IContact; static;
    /// <summary>Serializa os dados de contato para <c>TJSONObject</c>.</summary>
    function ToJson: TJSONObject;

    /// <summary>Obtém o nome da pessoa ou organização de contato.</summary>
    function Name: string; overload;
    /// <summary>Define o nome da pessoa ou organização de contato.</summary>
    function Name(const AValue: string): IContact; overload;
    /// <summary>Obtém a URL de contato.</summary>
    function Url: string; overload;
    /// <summary>Define a URL de contato.</summary>
    function Url(const AValue: string): IContact; overload;
    /// <summary>Obtém o endereço de e-mail de contato.</summary>
    function Email: string; overload;
    /// <summary>Define o endereço de e-mail de contato.</summary>
    function Email(const AValue: string): IContact; overload;
    /// <summary>Retorna ao objeto pai (<c>IInfo</c>).</summary>
    function &End: IInfo;
  end;

implementation

{ TContact }

function TContact.Email: string;
begin
  Result := FEmail;
end;

function TContact.Email(const AValue: string): IContact;
begin
  Result := Self;
  FEmail := AValue;
end;

function TContact.&End: IInfo;
begin
  Result := FParent;
end;

constructor TContact.Create(AParent: IInfo);
begin
  inherited Create;
  FParent := AParent;
end;

function TContact.Name(const AValue: string): IContact;
begin
  Result := Self;
  FName := AValue;
end;

function TContact.Name: string;
begin
  Result := FName;
end;

class function TContact.New(AParent: IInfo): IContact;
begin
  Result := TContact.Create(AParent);
end;

function TContact.ToJson: TJSONObject;
begin
  Result := inherited ToJson;

  if not FName.IsEmpty then
    Result.AddPair('name', FName);

  if not FUrl.IsEmpty then
    Result.AddPair('url', FUrl);

  if not FEmail.IsEmpty then
    Result.AddPair('email', FEmail);
end;

function TContact.Url: string;
begin
  Result := FUrl;
end;

function TContact.Url(const AValue: string): IContact;
begin
  Result := Self;
  FUrl := AValue;
end;

end.

