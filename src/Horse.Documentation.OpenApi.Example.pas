unit Horse.Documentation.OpenApi.Example;

interface

uses
  System.JSON,
  System.Rtti,
  System.Classes,
  System.TypInfo,
  System.SysUtils,
  System.Generics.Collections,
  Horse.Documentation.OpenApi.Utils,
  Horse.Documentation.OpenApi.Types,
  Horse.Documentation.OpenApi.Ancestor,
  Horse.Documentation.OpenApi.Interfaces;

type
  /// <summary>
  ///   Implementação do objeto Example da especificação OpenAPI (<c>IExample&lt;T&gt;</c>),
  ///   agrupando um valor de exemplo literal ou externo com resumo e descrição.
  /// </summary>
  TExample<T> = class(TOpenApiAncestor, IExample<T>)
  private
    FParent: T;
    FSummary: string;
    FDescription: string;
    FValue: TJSONValue;
    FExternalValue: string;

    constructor Create(AParent: T);
  public
    /// <summary>Cria uma nova instância de <c>IExample&lt;T&gt;</c> vinculada ao objeto pai <c>AParent</c>.</summary>
    class function New(AParent: T): IExample<T>; static;
    /// <summary>Serializa o exemplo para <c>TJSONObject</c>.</summary>
    function ToJson: TJSONObject;

    /// <summary>Obtém a breve descrição do exemplo.</summary>
    function Summary: string; overload;
    /// <summary>Define a breve descrição do exemplo.</summary>
    function Summary(const AValue: string): IExample<T>; overload;
    /// <summary>Obtém a descrição detalhada do exemplo (suporta CommonMark/Markdown).</summary>
    function Description: string; overload;
    /// <summary>Define a descrição detalhada do exemplo (suporta CommonMark/Markdown).</summary>
    function Description(const AValue: string): IExample<T>; overload;
    /// <summary>Obtém o valor JSON embutido do exemplo (mutuamente exclusivo com <c>ExternalValue</c>).</summary>
    function Value: TJSONValue; overload;
    /// <summary>Define o valor JSON embutido do exemplo (mutuamente exclusivo com <c>ExternalValue</c>).</summary>
    function Value(const AValue: TJSONValue): IExample<T>; overload;
    /// <summary>Obtém a URI que aponta para o exemplo externo (mutuamente exclusivo com <c>Value</c>).</summary>
    function ExternalValue: string; overload;
    /// <summary>Define a URI que aponta para o exemplo externo (mutuamente exclusivo com <c>Value</c>).</summary>
    function ExternalValue(const AValue: string): IExample<T>; overload;
    /// <summary>Retorna ao objeto pai (<c>T</c>).</summary>
    function &End: T;
  end;

implementation

{ TExample<T> }

constructor TExample<T>.Create(AParent: T);
begin
  inherited Create;
  FParent := AParent;
end;

function TExample<T>.Description: string;
begin
  Result := FDescription;
end;

function TExample<T>.Description(const AValue: string): IExample<T>;
begin
  Result := Self;
  FDescription := AValue;
end;

function TExample<T>.&End: T;
begin
  Result := FParent;
end;

function TExample<T>.ExternalValue: string;
begin
  Result := FExternalValue;
end;

function TExample<T>.ExternalValue(const AValue: string): IExample<T>;
begin
  Result := Self;
  FExternalValue := AValue;
end;

class function TExample<T>.New(AParent: T): IExample<T>;
begin
  Result := TExample<T>.Create(AParent);
end;

function TExample<T>.Summary: string;
begin
  Result := FSummary;
end;

function TExample<T>.Summary(const AValue: string): IExample<T>;
begin
  Result := Self;
  FSummary := AValue;
end;

function TExample<T>.ToJson: TJSONObject;
begin
  Result := inherited ToJson;

  if not FDescription.IsEmpty then
    Result.AddPair('description', FDescription);

  if not FSummary.IsEmpty then
    Result.AddPair('summary', FSummary);

  if not FExternalValue.IsEmpty then
    Result.AddPair('externalValue', FExternalValue);

  if FValue <> nil then
    Result.AddPair('value', FValue);
end;

function TExample<T>.Value: TJSONValue;
begin
  Result := FValue;
end;

function TExample<T>.Value(const AValue: TJSONValue): IExample<T>;
begin
  Result := Self;
  FValue := AValue;
end;

end.
