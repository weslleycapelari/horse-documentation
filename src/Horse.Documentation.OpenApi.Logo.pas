unit Horse.Documentation.OpenApi.Logo;

interface

uses
  System.JSON,
  System.Classes,
  System.SysUtils,
  Horse.Documentation.OpenApi.Ancestor,
  Horse.Documentation.OpenApi.Interfaces;

type
  TLogo = class(TOpenApiAncestor, ILogo)
  private
    [Weak]
    FParent: IInfo;
    FUrl: string;
    FBackgroundColor: string;
    FAltText: string;
    FHref: string;

    constructor Create(AParent: IInfo);
  public
    class function New(AParent: IInfo): ILogo; static;
    function ToJson: TJSONObject;

    function Url: string; overload;
    function Url(const AValue: string): ILogo; overload;
    function BackgroundColor: string; overload;
    function BackgroundColor(const AValue: string): ILogo; overload;
    function AltText: string; overload;
    function AltText(const AValue: string): ILogo; overload;
    function Href: string; overload;
    function Href(const AValue: string): ILogo; overload;
    function &End: IInfo;
  end;

implementation

{ TLogo }

constructor TLogo.Create(AParent: IInfo);
begin
  inherited Create;
  FParent := AParent;
end;

function TLogo.&End: IInfo;
begin
  Result := FParent;
end;

class function TLogo.New(AParent: IInfo): ILogo;
begin
  Result := TLogo.Create(AParent);
end;

function TLogo.Url(const AValue: string): ILogo;
begin
  Result := Self;
  FUrl := AValue;
end;

function TLogo.Url: string;
begin
  Result := FUrl;
end;

function TLogo.BackgroundColor(const AValue: string): ILogo;
begin
  Result := Self;
  FBackgroundColor := AValue;
end;

function TLogo.BackgroundColor: string;
begin
  Result := FBackgroundColor;
end;

function TLogo.AltText(const AValue: string): ILogo;
begin
  Result := Self;
  FAltText := AValue;
end;

function TLogo.AltText: string;
begin
  Result := FAltText;
end;

function TLogo.Href(const AValue: string): ILogo;
begin
  Result := Self;
  FHref := AValue;
end;

function TLogo.Href: string;
begin
  Result := FHref;
end;

function TLogo.ToJson: TJSONObject;
begin
  Result := inherited ToJson;

  if not FUrl.IsEmpty then
    Result.AddPair('url', FUrl);

  if not FBackgroundColor.IsEmpty then
    Result.AddPair('backgroundColor', FBackgroundColor);

  if not FAltText.IsEmpty then
    Result.AddPair('altText', FAltText);

  if not FHref.IsEmpty then
    Result.AddPair('href', FHref);
end;

end.
