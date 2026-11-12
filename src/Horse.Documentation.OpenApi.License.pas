unit Horse.Documentation.OpenApi.License;

interface

uses
  System.JSON,
  System.Classes,
  System.SysUtils,
  Horse.Documentation.OpenApi.Ancestor,
  Horse.Documentation.OpenApi.Interfaces;

type
  /// <summary>
  ///   Implementação do objeto License da especificação OpenAPI (<c>ILicense</c>),
  ///   descrevendo a licença aplicável à API exposta.
  /// </summary>
  TLicense = class(TOpenApiAncestor, ILicense)
  private
    [Weak]
    FParent: IInfo;
    FName: string;
    FIdentifier: string;
    FUrl: string;

    constructor Create(AParent: IInfo);
  public
    /// <summary>Cria uma nova instância de <c>ILicense</c> vinculada ao objeto <c>IInfo</c>.</summary>
    class function New(AParent: IInfo): ILicense; static;
    /// <summary>Serializa os dados de licença para <c>TJSONObject</c>.</summary>
    function ToJson: TJSONObject;

    /// <summary>Obtém o nome da licença.</summary>
    function Name: string; overload;
    /// <summary>Define o nome da licença.</summary>
    function Name(const AValue: string): ILicense; overload;
    /// <summary>Obtém o identificador SPDX da licença (mutuamente exclusivo com <c>Url</c>).</summary>
    function Identifier: string; overload;
    /// <summary>Define o identificador SPDX da licença (mutuamente exclusivo com <c>Url</c>).</summary>
    function Identifier(const AValue: string): ILicense; overload;
    /// <summary>Obtém a URI para o texto da licença (mutuamente exclusivo com <c>Identifier</c>).</summary>
    function Url: string; overload;
    /// <summary>Define a URI para o texto da licença (mutuamente exclusivo com <c>Identifier</c>).</summary>
    function Url(const AValue: string): ILicense; overload;
    /// <summary>Retorna ao objeto pai (<c>IInfo</c>).</summary>
    function &End: IInfo;
  end;

implementation

{ TLicense }

function TLicense.&End: IInfo;
begin
  Result := FParent;
end;

function TLicense.Identifier: string;
begin
  Result := FIdentifier;
end;

function TLicense.Identifier(const AValue: string): ILicense;
begin
  Result := Self;
  FIdentifier := AValue;
end;

constructor TLicense.Create(AParent: IInfo);
begin
  inherited Create;
  FParent := AParent;
end;

function TLicense.Name(const AValue: string): ILicense;
begin
  Result := Self;
  FName := AValue;
end;

function TLicense.Name: string;
begin
  Result := FName;
end;

class function TLicense.New(AParent: IInfo): ILicense;
begin
  Result := TLicense.Create(AParent);
end;

function TLicense.ToJson: TJSONObject;
begin
  Result := inherited ToJson;

  if not FName.IsEmpty then
    Result.AddPair('name', FName);

  if not FIdentifier.IsEmpty then
    Result.AddPair('identifier', FIdentifier);

  if not FUrl.IsEmpty then
    Result.AddPair('url', FUrl);
end;

function TLicense.Url: string;
begin
  Result := FUrl;
end;

function TLicense.Url(const AValue: string): ILicense;
begin
  Result := Self;
  FUrl := AValue;
end;

end.

