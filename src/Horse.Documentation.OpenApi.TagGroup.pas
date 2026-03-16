unit Horse.Documentation.OpenApi.TagGroup;

interface

uses
  System.JSON,
  System.Classes,
  System.SysUtils,
  Horse.Documentation.OpenApi.Types,
  Horse.Documentation.OpenApi.Ancestor,
  Horse.Documentation.OpenApi.Interfaces;

type
  TTagGroup = class(TOpenApiAncestor, ITagGroup)
  private
    [Weak]
    FParent: IOpenApi;
    FName: string;
    FTags: TOpenApiList<string, ITagGroup>;

    constructor Create(AParent: IOpenApi);
  public
    destructor Destroy; override;
    class function New(AParent: IOpenApi): ITagGroup; static;
    function ToJson: TJSONObject;

    function Name: string; overload;
    function Name(const AValue: string): ITagGroup; overload;
    function Tags: TOpenApiList<string, ITagGroup>;
    function &End: IOpenApi;
  end;

implementation

{ TTagGroup }

constructor TTagGroup.Create(AParent: IOpenApi);
begin
  inherited Create;
  FParent := AParent;
end;

destructor TTagGroup.Destroy;
begin
  if FTags <> nil then
    FTags.Free;
  inherited;
end;

function TTagGroup.&End: IOpenApi;
begin
  Result := FParent;
end;

class function TTagGroup.New(AParent: IOpenApi): ITagGroup;
begin
  Result := TTagGroup.Create(AParent);
end;

function TTagGroup.Name(const AValue: string): ITagGroup;
begin
  Result := Self;
  FName := AValue;
end;

function TTagGroup.Name: string;
begin
  Result := FName;
end;

function TTagGroup.Tags: TOpenApiList<string, ITagGroup>;
begin
  if FTags = nil then
    FTags := TOpenApiList<string, ITagGroup>.Create(Self);
  Result := FTags;
end;

function TTagGroup.ToJson: TJSONObject;
begin
  Result := inherited ToJson;

  if not FName.IsEmpty then
    Result.AddPair('name', FName);

  if (FTags <> nil) and (FTags.Count > 0) then
    Result.AddPair('tags', FTags.ToJson);
end;

end.
