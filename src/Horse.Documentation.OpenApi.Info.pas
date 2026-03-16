unit Horse.Documentation.OpenApi.Info;

interface

uses
  System.JSON,
  System.Classes,
  System.SysUtils,
  Horse.Documentation.OpenApi.Ancestor,
  Horse.Documentation.OpenApi.Interfaces;

type
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
    class function New(AParent: IOpenApi): IInfo; static;
    function ToJson: TJSONObject;

    function Title: string; overload;
    function Title(const AValue: string): IInfo; overload;
    function Summary: string; overload;
    function Summary(const AValue: string): IInfo; overload;
    function Description: string; overload;
    function Description(const AValue: string): IInfo; overload;
    function TermsOfService: string; overload;
    function TermsOfService(const AValue: string): IInfo; overload;
    function Contact: IContact;
    function License: ILicense;
    function Logo: ILogo;
    function Version: string; overload;
    function Version(const AValue: string): IInfo; overload;
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

