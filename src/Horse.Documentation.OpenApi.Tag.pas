unit Horse.Documentation.OpenApi.Tag;

interface

uses
  System.JSON,
  System.Classes,
  System.SysUtils,
  Horse.Documentation.OpenApi.Ancestor,
  Horse.Documentation.OpenApi.Interfaces;

type
  TTag = class(TOpenApiAncestor, ITag)
  private
    [Weak]
    FParent: IOpenApi;
    FName: string;
    FDescription: string;
    FDisplayName: string;
    FExternalDocs: IExternalDocumentation<ITag>;

    constructor Create(AParent: IOpenApi);
  public
    class function New(AParent: IOpenApi): ITag; static;
    function ToJson: TJSONObject;

    function Name: string; overload;
    function Name(const AValue: string): ITag; overload;
    function Description: string; overload;
    function Description(const AValue: string): ITag; overload;
    function DisplayName: string; overload;
    function DisplayName(const AValue: string): ITag; overload;
    function ExternalDocs: IExternalDocumentation<ITag>;
    function &End: IOpenApi;
  end;

implementation

uses
  Horse.Documentation.OpenApi.ExternalDocumentation;

{ TTag }

constructor TTag.Create(AParent: IOpenApi);
begin
  inherited Create;
  FParent := AParent;
end;

function TTag.Description(const AValue: string): ITag;
begin
  Result := Self;
  FDescription := AValue;
end;

function TTag.Description: string;
begin
  Result := FDescription;
end;

function TTag.DisplayName(const AValue: string): ITag;
begin
  Result := Self;
  FDisplayName := AValue;
end;

function TTag.DisplayName: string;
begin
  Result := FDisplayName;
end;

function TTag.&End: IOpenApi;
begin
  Result := FParent;
end;

function TTag.ExternalDocs: IExternalDocumentation<ITag>;
begin
  if FExternalDocs = nil then
    FExternalDocs := TExternalDocumentation<ITag>.New(Self);
  Result := FExternalDocs;
end;

function TTag.Name(const AValue: string): ITag;
begin
  Result := Self;
  FName := AValue;
end;

function TTag.Name: string;
begin
  Result := FName;
end;

class function TTag.New(AParent: IOpenApi): ITag;
begin
  Result := TTag.Create(AParent);
end;

function TTag.ToJson: TJSONObject;
begin
  Result := inherited ToJson;

  Result.AddPair('name', FName);

  if not FDescription.IsEmpty then
    Result.AddPair('description', FDescription);

  if not FDisplayName.IsEmpty then
    Result.AddPair('x-displayName', FDisplayName);

  if FExternalDocs <> nil then
    Result.AddPair('externalDocs', FExternalDocs.ToJson);
end;

end.

