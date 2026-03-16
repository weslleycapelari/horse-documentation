unit Horse.Documentation.OpenApi.CodeSample;

interface

uses
  System.JSON,
  System.Classes,
  System.SysUtils,
  Horse.Documentation.OpenApi.Ancestor,
  Horse.Documentation.OpenApi.Interfaces;

type
  TCodeSample<T> = class(TOpenApiAncestor, ICodeSample<T>)
  private
    FParent: T;
    FLang: string;
    FLabel: string;
    FSource: string;

    constructor Create(AParent: T);
  public
    class function New(AParent: T): ICodeSample<T>; static;
    function ToJson: TJSONObject;

    function Lang: string; overload;
    function Lang(const AValue: string): ICodeSample<T>; overload;
    function &Label: string; overload;
    function &Label(const AValue: string): ICodeSample<T>; overload;
    function Source: string; overload;
    function Source(const AValue: string): ICodeSample<T>; overload;
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
