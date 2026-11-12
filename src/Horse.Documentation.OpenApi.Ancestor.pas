unit Horse.Documentation.OpenApi.Ancestor;

interface

uses
  System.JSON,
  System.Rtti,
  System.Classes,
  System.Generics.Collections,
  Horse.Documentation.OpenApi.Types,
  Horse.Documentation.OpenApi.Utils,
  Horse.Documentation.OpenApi.Interfaces;

type
  /// <summary>
  ///   Classe ancestral abstrata para todos os objetos do modelo OpenAPI.
  ///   Fornece suporte a Specification Extensions (propriedades customizadas <c>x-*</c>)
  ///   e serialização base para JSON.
  /// </summary>
  TOpenApiAncestor = class abstract (TInterfacedPersistent, IOpenApiAncestor)
  private
    FExtensions: TOpenApiMap<TJSONValue, IOpenApiAncestor>;
  public
    /// <summary>
    ///   Retorna o mapa de extensões da especificação (<c>x-*</c>) associadas a este objeto.
    /// </summary>
    function Extensions: TOpenApiMap<TJSONValue, IOpenApiAncestor>;

    /// <summary>
    ///   Serializa o objeto base e suas extensões para uma nova instância de <c>TJSONObject</c>.
    /// </summary>
    function ToJson: TJSONObject;
  end;

implementation

{ TOpenApiAncestor }

function TOpenApiAncestor.Extensions: TOpenApiMap<TJSONValue, IOpenApiAncestor>;
begin
  if FExtensions = nil then
    FExtensions := TOpenApiMap<TJSONValue, IOpenApiAncestor>.Create(Self);
  Result := FExtensions;
end;

function TOpenApiAncestor.ToJson: TJSONObject;
var
  LPair: TPair<string, TJSONValue>;
begin
  Result := TJSONObject.Create;

  if (FExtensions = nil) or (FExtensions.Count = 0) then
    Exit;

  for LPair in Self.Extensions do
    TJSONObject(Result).AddPair(LPair.Key, LPair.Value);
end;

end.
