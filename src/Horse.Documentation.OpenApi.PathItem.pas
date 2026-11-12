unit Horse.Documentation.OpenApi.PathItem;

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
  ///   Implementação do objeto Path Item da especificação OpenAPI (<c>IPathItem&lt;T&gt;</c>),
  ///   descrevendo as operações HTTP (GET, POST, PUT, DELETE, etc.) e parâmetros disponíveis em um caminho.
  /// </summary>
  TPathItem<T> = class(TOpenApiAncestor, IPathItem<T>)
  private
    FParent: T;
    FRef: string;
    FSummary: string;
    FDescription: string;
    FGet: IOperation<IPathItem<T>>;
    FPut: IOperation<IPathItem<T>>;
    FPost: IOperation<IPathItem<T>>;
    FDelete: IOperation<IPathItem<T>>;
    FOptions: IOperation<IPathItem<T>>;
    FHead: IOperation<IPathItem<T>>;
    FPatch: IOperation<IPathItem<T>>;
    FTrace: IOperation<IPathItem<T>>;
    FServers: TOpenApiList<IServer<IPathItem<T>>, IPathItem<T>>;
    FParameters: TOpenApiList<IParameter<IPathItem<T>>, IPathItem<T>>;

    constructor Create(AParent: T);
  public
    /// <summary>Cria uma nova instância de <c>IPathItem&lt;T&gt;</c> vinculada ao objeto pai <c>AParent</c>.</summary>
    class function New(AParent: T): IPathItem<T>; static;
    /// <summary>Serializa o Path Item e suas operações HTTP para <c>TJSONObject</c>.</summary>
    function ToJson: TJSONObject;

    /// <summary>Obtém a referência externa (<c>$ref</c>) do Path Item.</summary>
    function Ref: string; overload;
    /// <summary>Define a referência externa (<c>$ref</c>) do Path Item.</summary>
    function Ref(const AValue: string): IPathItem<T>; overload;
    /// <summary>Obtém o resumo aplicável a todas as operações deste caminho.</summary>
    function Summary: string; overload;
    /// <summary>Define o resumo aplicável a todas as operações deste caminho.</summary>
    function Summary(const AValue: string): IPathItem<T>; overload;
    /// <summary>Obtém a descrição aplicável a todas as operações deste caminho.</summary>
    function Description: string; overload;
    /// <summary>Define a descrição aplicável a todas as operações deste caminho.</summary>
    function Description(const AValue: string): IPathItem<T>; overload;
    /// <summary>Retorna a definição da operação HTTP <c>GET</c> para este caminho.</summary>
    function Get: IOperation<IPathItem<T>>;
    /// <summary>Retorna a definição da operação HTTP <c>PUT</c> para este caminho.</summary>
    function Put: IOperation<IPathItem<T>>;
    /// <summary>Retorna a definição da operação HTTP <c>POST</c> para este caminho.</summary>
    function Post: IOperation<IPathItem<T>>;
    /// <summary>Retorna a definição da operação HTTP <c>DELETE</c> para este caminho.</summary>
    function &Delete: IOperation<IPathItem<T>>;
    /// <summary>Retorna a definição da operação HTTP <c>OPTIONS</c> para este caminho.</summary>
    function Options: IOperation<IPathItem<T>>;
    /// <summary>Retorna a definição da operação HTTP <c>HEAD</c> para este caminho.</summary>
    function Head: IOperation<IPathItem<T>>;
    /// <summary>Retorna a definição da operação HTTP <c>PATCH</c> para este caminho.</summary>
    function Patch: IOperation<IPathItem<T>>;
    /// <summary>Retorna a definição da operação HTTP <c>TRACE</c> para este caminho.</summary>
    function Trace: IOperation<IPathItem<T>>;
    /// <summary>Retorna a lista de servidores alternativos para atender a este caminho.</summary>
    function Servers: TOpenApiList<IServer<IPathItem<T>>, IPathItem<T>>;
    /// <summary>Retorna a lista de parâmetros compartilhados por todas as operações deste caminho.</summary>
    function Parameters: TOpenApiList<IParameter<IPathItem<T>>, IPathItem<T>>;
    /// <summary>Retorna ao objeto pai (<c>T</c>).</summary>
    function &End: T;
  end;

implementation

uses
  Horse.Documentation.OpenApi.Server,
  Horse.Documentation.OpenApi.Parameter,
  Horse.Documentation.OpenApi.Operation;

{ TPathItem<T> }

constructor TPathItem<T>.Create(AParent: T);
begin
  inherited Create;
  FParent := AParent;
end;

function TPathItem<T>.Description: string;
begin
  Result := FDescription;
end;

function TPathItem<T>.Delete: IOperation<IPathItem<T>>;
begin
  if FDelete = nil then
    FDelete := TOperation<IPathItem<T>>.New(Self);
  Result := FDelete;
end;

function TPathItem<T>.Description(const AValue: string): IPathItem<T>;
begin
  Result := Self;
  FDescription := AValue;
end;

function TPathItem<T>.&End: T;
begin
  Result := FParent;
end;

function TPathItem<T>.Get: IOperation<IPathItem<T>>;
begin
  if FGet = nil then
    FGet := TOperation<IPathItem<T>>.New(Self);
  Result := FGet;
end;

function TPathItem<T>.Head: IOperation<IPathItem<T>>;
begin
  if FHead = nil then
    FHead := TOperation<IPathItem<T>>.New(Self);
  Result := FHead;
end;

class function TPathItem<T>.New(AParent: T): IPathItem<T>;
begin
  Result := TPathItem<T>.Create(AParent);
end;

function TPathItem<T>.Options: IOperation<IPathItem<T>>;
begin
  if FOptions = nil then
    FOptions := TOperation<IPathItem<T>>.New(Self);
  Result := FOptions;
end;

function TPathItem<T>.Parameters: TOpenApiList<IParameter<IPathItem<T>>, IPathItem<T>>;
begin
  if FParameters = nil then
    FParameters := TOpenApiList<IParameter<IPathItem<T>>, IPathItem<T>>.Create(Self, TParameter<IPathItem<T>>);
  Result := FParameters;
end;

function TPathItem<T>.Patch: IOperation<IPathItem<T>>;
begin
  if FPatch = nil then
    FPatch := TOperation<IPathItem<T>>.New(Self);
  Result := FPatch;
end;

function TPathItem<T>.Post: IOperation<IPathItem<T>>;
begin
  if FPost = nil then
    FPost := TOperation<IPathItem<T>>.New(Self);
  Result := FPost;
end;

function TPathItem<T>.Put: IOperation<IPathItem<T>>;
begin
  if FPut = nil then
    FPut := TOperation<IPathItem<T>>.New(Self);
  Result := FPut;
end;

function TPathItem<T>.Ref(const AValue: string): IPathItem<T>;
begin
  Result := Self;
  FRef := AValue;
end;

function TPathItem<T>.Ref: string;
begin
  Result := FRef;
end;

function TPathItem<T>.Servers: TOpenApiList<IServer<IPathItem<T>>, IPathItem<T>>;
begin
  if FServers = nil then
    FServers := TOpenApiList<IServer<IPathItem<T>>, IPathItem<T>>.Create(Self, TServer<IPathItem<T>>);
  Result := FServers;
end;

function TPathItem<T>.Summary(const AValue: string): IPathItem<T>;
begin
  Result := Self;
  FSummary := AValue;
end;

function TPathItem<T>.Summary: string;
begin
  Result := FSummary;
end;

function TPathItem<T>.ToJson: TJSONObject;
begin
  Result := inherited ToJson;

  if not FRef.IsEmpty then
    Result.AddPair('$ref', FRef);

  if not FSummary.IsEmpty then
    Result.AddPair('summary', FSummary);

  if not FDescription.IsEmpty then
    Result.AddPair('description', FDescription);

  if FGet <> nil then
    Result.AddPair('get', FGet.ToJson);

  if FPut <> nil then
    Result.AddPair('put', FPut.ToJson);

  if FPost <> nil then
    Result.AddPair('post', FPost.ToJson);

  if FDelete <> nil then
    Result.AddPair('delete', FDelete.ToJson);

  if FOptions <> nil then
    Result.AddPair('options', FOptions.ToJson);

  if FHead <> nil then
    Result.AddPair('head', FHead.ToJson);

  if FPatch <> nil then
    Result.AddPair('patch', FPatch.ToJson);

  if FTrace <> nil then
    Result.AddPair('trace', FTrace.ToJson);

  if (FServers <> nil) and (FServers.Count > 0) then
    Result.AddPair('servers', FServers.ToJson);

  if (FParameters <> nil) and (FParameters.Count > 0) then
    Result.AddPair('parameters', FParameters.ToJson);
end;

function TPathItem<T>.Trace: IOperation<IPathItem<T>>;
begin
  if FTrace = nil then
    FTrace := TOperation<IPathItem<T>>.New(Self);
  Result := FTrace;
end;

end.
