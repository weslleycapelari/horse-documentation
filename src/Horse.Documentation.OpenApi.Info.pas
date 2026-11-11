unit Horse.Documentation.OpenApi.Info;

interface

uses
  System.JSON,
  System.Classes,
  System.SysUtils,
  Horse.Documentation.OpenApi.Ancestor,
  Horse.Documentation.OpenApi.Interfaces;

type
  /// <summary>
  ///   Implementação do objeto Info da especificação OpenAPI (<c>IInfo</c>),
  ///   contendo metadados gerais da API como título, versão, descrição, contato, licença e logo.
  /// </summary>
  TInfo = class(TOpenApiAncestor, IInfo)
  private
    [Weak]
    FParent: IOpenApi;
    FTitle: string;
    FSummary: string;
    FDescription: string;
    FTermsOfService: string;
    FContact: IContact;
    FLicense: ILicense;
    FLogo: ILogo;
    FVersion: string;

    constructor Create(AParent: IOpenApi);
  public
    /// <summary>Cria uma nova instância de <c>IInfo</c> vinculada ao objeto raiz <c>IOpenApi</c>.</summary>
    class function New(AParent: IOpenApi): IInfo; static;
    /// <summary>Serializa os metadados da API para <c>TJSONObject</c>.</summary>
    function ToJson: TJSONObject;

    /// <summary>Obtém o título da API.</summary>
    function Title: string; overload;
    /// <summary>Define o título da API.</summary>
    function Title(const AValue: string): IInfo; overload;
    /// <summary>Obtém o resumo curto da API.</summary>
    function Summary: string; overload;
    /// <summary>Define o resumo curto da API.</summary>
    function Summary(const AValue: string): IInfo; overload;
    /// <summary>Obtém a descrição detalhada da API (suporta CommonMark/Markdown).</summary>
    function Description: string; overload;
    /// <summary>Define a descrição detalhada da API (suporta CommonMark/Markdown).</summary>
    function Description(const AValue: string): IInfo; overload;
    /// <summary>Obtém a URI dos Termos de Serviço da API.</summary>
    function TermsOfService: string; overload;
    /// <summary>Define a URI dos Termos de Serviço da API.</summary>
    function TermsOfService(const AValue: string): IInfo; overload;
    /// <summary>Retorna o objeto de informações de contato (<c>IContact</c>).</summary>
    function Contact: IContact;
    /// <summary>Retorna o objeto de informações de licença (<c>ILicense</c>).</summary>
    function License: ILicense;
    /// <summary>Retorna o objeto de configuração de logotipo (<c>ILogo</c>, extensão <c>x-logo</c>).</summary>
    function Logo: ILogo;
    /// <summary>Obtém a versão do documento da API.</summary>
    function Version: string; overload;
    /// <summary>Define a versão do documento da API.</summary>
    function Version(const AValue: string): IInfo; overload;
    /// <summary>Retorna ao objeto pai (<c>IOpenApi</c>).</summary>
    function &End: IOpenApi;
  end;

implementation

uses
  Horse.Documentation.OpenApi.Contact,
  Horse.Documentation.OpenApi.License,
  Horse.Documentation.OpenApi.Logo;

{ TInfo }

function TInfo.Contact: IContact;
begin
  if FContact = nil then
    FContact := TContact.New(Self);
  Result := FContact;
end;

function TInfo.&End: IOpenApi;
begin
  Result := FParent;
end;

constructor TInfo.Create(AParent: IOpenApi);
begin
  inherited Create;
  FParent := AParent;
  FTitle := 'Horse Documentation';
  FVersion := '1.0.0';
end;

function TInfo.Description(const AValue: string): IInfo;
begin
  Result := Self;
  FDescription := AValue;
end;

function TInfo.Description: string;
begin
  Result := FDescription;
end;

function TInfo.License: ILicense;
begin
  if FLicense = nil then
    FLicense := TLicense.New(Self);
  Result := FLicense;
end;

function TInfo.Logo: ILogo;
begin
  if FLogo = nil then
    FLogo := TLogo.New(Self);
  Result := FLogo;
end;

class function TInfo.New(AParent: IOpenApi): IInfo;
begin
  Result := TInfo.Create(AParent);
end;

function TInfo.Summary(const AValue: string): IInfo;
begin
  Result := Self;
  FSummary := AValue;
end;

function TInfo.Summary: string;
begin
  Result := FSummary;
end;

function TInfo.TermsOfService: string;
begin
  Result := FTermsOfService;
end;

function TInfo.TermsOfService(const AValue: string): IInfo;
begin
  Result := Self;
  FTermsOfService := AValue;
end;

function TInfo.Title(const AValue: string): IInfo;
begin
  Result := Self;
  FTitle := AValue;
end;

function TInfo.Title: string;
begin
  Result := FTitle;
end;

function TInfo.ToJson: TJSONObject;
begin
  Result := inherited ToJson;

  Result.AddPair('title', FTitle);
  Result.AddPair('version', FVersion);

  if not FSummary.IsEmpty then
    Result.AddPair('summary', FSummary);

  if not FDescription.IsEmpty then
    Result.AddPair('description', FDescription);

  if not FTermsOfService.IsEmpty then
    Result.AddPair('termsOfService', FTermsOfService);

  if FContact <> nil then
    Result.AddPair('contact', FContact.ToJson);

  if FLicense <> nil then
    Result.AddPair('license', FLicense.ToJson);

  if FLogo <> nil then
    Result.AddPair('x-logo', FLogo.ToJson);
end;

function TInfo.Version(const AValue: string): IInfo;
begin
  Result := Self;
  FVersion := AValue;
end;

function TInfo.Version: string;
begin
  Result := FVersion;
end;

end.

