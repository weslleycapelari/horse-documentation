unit Horse.Documentation.OpenApi.ExternalDocumentation;

interface

uses
  System.JSON,
  System.Classes,
  System.SysUtils,
  System.Generics.Collections,
  Horse.Documentation.OpenApi.Types,
  Horse.Documentation.OpenApi.Ancestor,
  Horse.Documentation.OpenApi.Interfaces;

type
  /// <summary>
  ///   Implementação do objeto External Documentation da especificação OpenAPI (<c>IExternalDocumentation&lt;T&gt;</c>),
  ///   permitindo referenciar recursos externos para documentação estendida.
  /// </summary>
  TExternalDocumentation<T> = class(TOpenApiAncestor, IExternalDocumentation<T>)
  private
    FParent: T;
    FDescription: string;
    FUrl: string;

    constructor Create(AParent: T);
  public
    /// <summary>Cria uma nova instância de <c>IExternalDocumentation&lt;T&gt;</c> vinculada ao objeto pai <c>AParent</c>.</summary>
    class function New(AParent: T): IExternalDocumentation<T>; static;
    /// <summary>Serializa a referência de documentação externa para <c>TJSONObject</c>.</summary>
    function ToJson: TJSONObject;

    /// <summary>Obtém a descrição da documentação externa (suporta CommonMark/Markdown).</summary>
    function Description: string; overload;
    /// <summary>Define a descrição da documentação externa (suporta CommonMark/Markdown).</summary>
    function Description(const AValue: string): IExternalDocumentation<T>; overload;
    /// <summary>Obtém a URL obrigatória para a documentação externa.</summary>
    function Url: string; overload;
    /// <summary>Define a URL obrigatória para a documentação externa.</summary>
    function Url(const AValue: string): IExternalDocumentation<T>; overload;
    /// <summary>Retorna ao objeto pai (<c>T</c>).</summary>
    function &End: T;
  end;

implementation

{ TExternalDocumentation<T> }

constructor TExternalDocumentation<T>.Create(AParent: T);
begin
  inherited Create;
  FParent := AParent;
end;

function TExternalDocumentation<T>.Description: string;
begin
  Result := FDescription;
end;

function TExternalDocumentation<T>.Description(const AValue: string): IExternalDocumentation<T>;
begin
  Result := Self;
  FDescription := AValue;
end;

function TExternalDocumentation<T>.&End: T;
begin
  Result := FParent;
end;

class function TExternalDocumentation<T>.New(AParent: T): IExternalDocumentation<T>;
begin
  Result := TExternalDocumentation<T>.Create(AParent);
end;

function TExternalDocumentation<T>.ToJson: TJSONObject;
begin
  Result := inherited ToJson;

  Result.AddPair('url', FUrl);

  if not FDescription.IsEmpty then
    Result.AddPair('description', FDescription);
end;

function TExternalDocumentation<T>.Url: string;
begin
  Result := FUrl;
end;

function TExternalDocumentation<T>.Url(const AValue: string): IExternalDocumentation<T>;
begin
  Result := Self;
  FUrl := AValue;
end;

end.
