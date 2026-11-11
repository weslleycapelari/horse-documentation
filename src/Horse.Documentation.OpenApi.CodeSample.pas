unit Horse.Documentation.OpenApi.CodeSample;

interface

uses
  System.JSON,
  System.Classes,
  System.SysUtils,
  Horse.Documentation.OpenApi.Ancestor,
  Horse.Documentation.OpenApi.Interfaces;

type
  /// <summary>
  ///   Implementação da extensão <c>x-code-samples</c> (<c>ICodeSample&lt;T&gt;</c>),
  ///   permitindo anexar exemplos de código-fonte customizados em diferentes linguagens a uma operação.
  /// </summary>
  TCodeSample<T> = class(TOpenApiAncestor, ICodeSample<T>)
  private
    FParent: T;
    FLang: string;
    FLabel: string;
    FSource: string;

    constructor Create(AParent: T);
  public
    /// <summary>Cria uma nova instância de <c>ICodeSample&lt;T&gt;</c> vinculada ao objeto pai <c>AParent</c>.</summary>
    class function New(AParent: T): ICodeSample<T>; static;
    /// <summary>Serializa o exemplo de código para <c>TJSONObject</c>.</summary>
    function ToJson: TJSONObject;

    /// <summary>Obtém a linguagem de programação do exemplo (ex: <c>Delphi</c>, <c>javascript</c>, <c>curl</c>).</summary>
    function Lang: string; overload;
    /// <summary>Define a linguagem de programação do exemplo (ex: <c>Delphi</c>, <c>javascript</c>, <c>curl</c>).</summary>
    function Lang(const AValue: string): ICodeSample<T>; overload;
    /// <summary>Obtém o rótulo descritivo do exemplo (ex: <c>RESTRequest4Delphi</c>, <c>Fetch API</c>).</summary>
    function &Label: string; overload;
    /// <summary>Define o rótulo descritivo do exemplo (ex: <c>RESTRequest4Delphi</c>, <c>Fetch API</c>).</summary>
    function &Label(const AValue: string): ICodeSample<T>; overload;
    /// <summary>Obtém o código-fonte do exemplo.</summary>
    function Source: string; overload;
    /// <summary>Define o código-fonte do exemplo.</summary>
    function Source(const AValue: string): ICodeSample<T>; overload;
    /// <summary>Retorna ao objeto pai (<c>T</c>).</summary>
    function &End: T;
  end;

implementation

{ TCodeSample<T> }

constructor TCodeSample<T>.Create(AParent: T);
begin
  inherited Create;
  FParent := AParent;
end;

function TCodeSample<T>.&End: T;
begin
  Result := FParent;
end;

class function TCodeSample<T>.New(AParent: T): ICodeSample<T>;
begin
  Result := TCodeSample<T>.Create(AParent);
end;

function TCodeSample<T>.Lang(const AValue: string): ICodeSample<T>;
begin
  Result := Self;
  FLang := AValue;
end;

function TCodeSample<T>.Lang: string;
begin
  Result := FLang;
end;

function TCodeSample<T>.&Label(const AValue: string): ICodeSample<T>;
begin
  Result := Self;
  FLabel := AValue;
end;

function TCodeSample<T>.&Label: string;
begin
  Result := FLabel;
end;

function TCodeSample<T>.Source(const AValue: string): ICodeSample<T>;
begin
  Result := Self;
  FSource := AValue;
end;

function TCodeSample<T>.Source: string;
begin
  Result := FSource;
end;

function TCodeSample<T>.ToJson: TJSONObject;
begin
  Result := inherited ToJson;

  if not FLang.IsEmpty then
    Result.AddPair('lang', FLang);

  if not FLabel.IsEmpty then
    Result.AddPair('label', FLabel);

  if not FSource.IsEmpty then
    Result.AddPair('source', FSource);
end;

end.
