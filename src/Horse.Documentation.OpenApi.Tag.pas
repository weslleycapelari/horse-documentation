unit Horse.Documentation.OpenApi.Tag;

interface

uses
  System.JSON,
  System.Classes,
  System.SysUtils,
  Horse.Documentation.OpenApi.Ancestor,
  Horse.Documentation.OpenApi.Interfaces;

type
  /// <summary>
  ///   Implementação do objeto Tag da especificação OpenAPI (<c>ITag</c>),
  ///   adicionando metadados (descrição, nome de exibição <c>x-displayName</c> e documentação externa) a uma tag.
  /// </summary>
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
    /// <summary>Cria uma nova instância de <c>ITag</c> vinculada ao objeto raiz <c>IOpenApi</c>.</summary>
    class function New(AParent: IOpenApi): ITag; static;
    /// <summary>Serializa os metadados da tag para <c>TJSONObject</c>.</summary>
    function ToJson: TJSONObject;

    /// <summary>Obtém o nome identificador da tag.</summary>
    function Name: string; overload;
    /// <summary>Define o nome identificador da tag.</summary>
    function Name(const AValue: string): ITag; overload;
    /// <summary>Obtém a descrição da tag (suporta CommonMark/Markdown).</summary>
    function Description: string; overload;
    /// <summary>Define a descrição da tag (suporta CommonMark/Markdown).</summary>
    function Description(const AValue: string): ITag; overload;
    /// <summary>Obtém o nome de exibição amigável da tag (extensão <c>x-displayName</c>).</summary>
    function DisplayName: string; overload;
    /// <summary>Define o nome de exibição amigável da tag (extensão <c>x-displayName</c>).</summary>
    function DisplayName(const AValue: string): ITag; overload;
    /// <summary>Retorna a referência de documentação externa para esta tag.</summary>
    function ExternalDocs: IExternalDocumentation<ITag>;
    /// <summary>Retorna ao objeto pai (<c>IOpenApi</c>).</summary>
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

