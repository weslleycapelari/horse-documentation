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
  /// <summary>
  ///   Implementação da extensão <c>x-tagGroups</c> (<c>ITagGroup</c>),
  ///   permitindo agrupar tags em categorias hierárquicas na barra lateral (Scalar / Redoc).
  /// </summary>
  TTagGroup = class(TOpenApiAncestor, ITagGroup)
  private
    [Weak]
    FParent: IOpenApi;
    FName: string;
    FTags: TOpenApiList<string, ITagGroup>;

    constructor Create(AParent: IOpenApi);
  public
    destructor Destroy; override;
    /// <summary>Cria uma nova instância de <c>ITagGroup</c> vinculada ao objeto raiz <c>IOpenApi</c>.</summary>
    class function New(AParent: IOpenApi): ITagGroup; static;
    /// <summary>Serializa o grupo de tags para <c>TJSONObject</c>.</summary>
    function ToJson: TJSONObject; override;

    /// <summary>Obtém o nome de exibição do grupo de tags.</summary>
    function Name: string; overload;
    /// <summary>Define o nome de exibição do grupo de tags.</summary>
    function Name(const AValue: string): ITagGroup; overload;
    /// <summary>Retorna a lista de nomes de tags pertencentes a este grupo.</summary>
    function Tags: TOpenApiList<string, ITagGroup>;
    /// <summary>Retorna ao objeto pai (<c>IOpenApi</c>).</summary>
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
