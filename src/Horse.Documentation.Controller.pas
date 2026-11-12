unit Horse.Documentation.Controller;

interface

uses
  Horse,
  Horse.Core,
  Horse.Commons,
  Horse.Core.Route,
  Horse.Core.RouterTree,
  System.Types,
  System.Classes,
  System.Generics.Collections,
  Web.HTTPApp;

type
  /// <summary>
  ///   Estrutura que representa os metadados básicos de uma rota mapeada no Horse.
  /// </summary>
  TRouteInfo = record
    /// <summary>Verbo HTTP da rota (GET, POST, PUT, DELETE, PATCH, HEAD, etc.).</summary>
    Method: TMethodType;
    /// <summary>Caminho da rota normalizado para o formato OpenAPI (ex: <c>/users/{id}</c>).</summary>
    Path: string;
    /// <summary>Cria uma nova instância de <c>TRouteInfo</c> com o método e caminho informados.</summary>
    /// <param name="AMethod">Verbo HTTP da rota.</param>
    /// <param name="APath">Caminho da rota.</param>
    /// <returns>Instância preenchida de <c>TRouteInfo</c>.</returns>
    class function Create(const AMethod: TMethodType; const APath: string): TRouteInfo; static;
  end;

  /// <summary>
  ///   Controlador estático responsável por registrar os endpoints da documentação,
  ///   mapear automaticamente a árvore de rotas do Horse via RTTI e servir a interface Scalar UI.
  /// </summary>
  THorseDocumentationController = class abstract
  private
    /// <summary>
    ///   Percorre recursivamente a árvore interna de rotas do Horse (<c>THorseRouterTree</c>)
    ///   utilizando RTTI e converte parâmetros <c>:param</c> para o padrão OpenAPI <c>{param}</c>.
    /// </summary>
    class procedure TraverseRouterTree(ARouter: THorseRouterTree; const APath: string; var ARoutes: TList<TRouteInfo>); static;
    /// <summary>Retorna a lista de todas as rotas registradas na instância atual do Horse.</summary>
    class function ListAllRoutes: TArray<TRouteInfo>; static;
    /// <summary>Obtém o handle do módulo atual onde os recursos (<c>HORSE_ICON</c>, <c>SCALAR_JS</c>) estão embarcados.</summary>
    class function GetCurrentModuleHandle: HINST; static;
  public
    /// <summary>
    ///   Registra as rotas da documentação no Horse e vincula o evento <c>THorse.OnListen</c>
    ///   ao mapeamento automático de rotas (<c>AutoMapHorse</c>).
    /// </summary>
    /// <param name="APathHtml">Rota para servir a página HTML da documentação.</param>
    /// <param name="APathJSON">Rota para servir o JSON da especificação OpenAPI.</param>
    class procedure Registry(const APathHtml, APathJSON: string); static;

    /// <summary>
    ///   Inspeciona todas as rotas registradas no Horse e adiciona automaticamente ao <c>HorseDoc</c>
    ///   aquelas que ainda não foram documentadas manualmente (atribuindo a tag <c>untagged</c> quando vazia).
    /// </summary>
    class procedure AutoMapHorse; static;

    /// <summary>Endpoint que retorna a página HTML com a interface interativa Scalar API Reference.</summary>
    class procedure GetHtml(AReq: THorseRequest; ARes: THorseResponse); static;
    /// <summary>Endpoint que retorna o JSON gerado a partir da especificação <c>HorseDoc</c>.</summary>
    class procedure GetJson(AReq: THorseRequest; ARes: THorseResponse); static;
    /// <summary>Endpoint que retorna o bundle JavaScript embarcado do Scalar (<c>SCALAR_JS</c>).</summary>
    class procedure GetJs(AReq: THorseRequest; ARes: THorseResponse); static;
    /// <summary>Endpoint que retorna o ícone embarcado do Horse (<c>HORSE_ICON</c>).</summary>
    class procedure GetIcon(AReq: THorseRequest; ARes: THorseResponse); static;
  end;

implementation

uses
  System.Rtti,
  System.JSON,
  System.SysUtils,
  System.StrUtils,
  Winapi.Windows,
  Horse.Documentation,
  Horse.Documentation.OpenApi.Interfaces;

var
  GJSONPath: string;
  GHTMLPath: string;

{$R Horse.Documentation.res}

{ THorseDocumentationController }

class procedure THorseDocumentationController.Registry(const APathHtml, APathJSON: string);
begin
  GJSONPath := IfThen(APathJSON.IsEmpty, PATH_JSON, APathJSON);
  GHTMLPath := IfThen(APathHtml.IsEmpty, PATH_HTML, APathHtml);

  THorse.Get(GHTMLPath, THorseDocumentationController.GetHtml);
  THorse.Get(GJSONPath, THorseDocumentationController.GetJson);
  THorse.Get(GHTMLPath + '/scalar.js', THorseDocumentationController.GetJs);
  THorse.Get(GHTMLPath + '/favicon.png', THorseDocumentationController.GetIcon);


  THorse.OnListen := AutoMapHorse;
end;

class procedure THorseDocumentationController.TraverseRouterTree(ARouter: THorseRouterTree; const APath: string;
  var ARoutes: TList<TRouteInfo>);
var
  LContext: TRttiContext;
  LType: TRttiType;
  LField: TRttiField;
  LCallbacks: TObjectDictionary<TMethodType, TList<THorseCallback>>;
  LRoutes: TDictionary<string, THorseRouterTree>;
  LPair: TPair<TMethodType, TList<THorseCallback>>;
  LRoutePair: TPair<string, THorseRouterTree>;
  LNewPath: string;
begin
  LContext := TRttiContext.Create;
  try
    LType := LContext.GetType(ARouter.ClassType);

    // Acessa os callbacks (rotas deste nó)
    LField := LType.GetField('FCallBack');
    if Assigned(LField) then
    begin
      LCallbacks := TObjectDictionary<TMethodType, TList<THorseCallback>>(LField.GetValue(ARouter).AsObject);
      for LPair in LCallbacks do
      begin
        ARoutes.Add(TRouteInfo.Create(LPair.Key, APath));
      end;
    end;

    // Acessa os filhos da árvore (sub-rotas)
    LField := LType.GetField('FRoute');
    if Assigned(LField) then
    begin
      LRoutes := TDictionary<string, THorseRouterTree>(LField.GetValue(ARouter).AsObject);
      for LRoutePair in LRoutes do
      begin
        LNewPath := LRoutePair.Key;
        if LNewPath.StartsWith(':') then
          LNewPath := '{' + Copy(LNewPath, 2) + '}';

        if APath = '/' then
          LNewPath := '/' + LNewPath
        else
          LNewPath := APath + '/' + LNewPath;
        TraverseRouterTree(LRoutePair.Value, LNewPath, ARoutes);
      end;
    end;
  finally
    LContext.Free;
  end;
end;

class procedure THorseDocumentationController.AutoMapHorse;
const C_UNTAGGED = 'untagged';
var
  LPath: IPathItem<IOpenApi>;
  LRoute: TRouteInfo;
  LOperation: IOperation<IPathItem<IOpenApi>>;
begin
  for LRoute in ListAllRoutes do
  begin
    if LRoute.Path.StartsWith('/horse/doc/') then
      Continue;

    LPath := HorseDoc.Paths.Add(LRoute.Path);

    case LRoute.Method of
      //mtAny:    LOperation := LPath.ANY;
      mtGet:    LOperation := LPath.Get;
      mtPut:    LOperation := LPath.Put;
      mtPost:   LOperation := LPath.Post;
      mtHead:   LOperation := LPath.Head;
      mtDelete: LOperation := LPath.Delete;
      mtPatch:  LOperation := LPath.Patch;
    end;

    if LOperation.Tags.IsEmpty then
      LOperation.Tags.Add(C_UNTAGGED);
  end;
end;

class function THorseDocumentationController.GetCurrentModuleHandle: HINST;
begin
  Result := FindResourceHInstance(HInstance);
end;

class procedure THorseDocumentationController.GetHtml(AReq: THorseRequest; ARes: THorseResponse);
  function GetRelativePath(const APath: string): string;
  var
    LCount: Integer;
    LPaths: TList<string>;
  begin
    LPaths := TList<string>.Create(APath.Split(['/']));
    try
      for LCount := 0 to LPaths.Count - 3 do
        LPaths.Delete(0);

      if LPaths.Count = 2 then
        if not LPaths[1].Contains('.') then
          LPaths.Delete(0);

      Result := string.Join('/', LPaths.ToArray);
    finally
      LPaths.Free;
    end;
  end;
var
  LIcon: string;
  LJson: string;
  LJavaScript: string;
begin
  LIcon       := GetRelativePath(GHTMLPath + '/favicon.png');
  LJson       := GetRelativePath(GJSONPath);
  LJavaScript := GetRelativePath(GHTMLPath + '/scalar.js');
  ARes.Send(
    '<html>                                                                      ' + #13 +
    '  <head>                                                                    ' + #13 +
    '    <title>Horse Documentation</title>                                      ' + #13 +
    '    <meta charset="utf-8" />                                                ' + #13 +
    '    <meta name="viewport" content="width=device-width, initial-scale=1" />  ' + #13 +
    '    <link rel="icon" type="image/png" href="' + LIcon + '">                 ' + #13 +
    '    <style>                                                                 ' + #13 +
    '      :root {                                                               ' + #13 +
    '        --scalar-header-height: 50px;                                       ' + #13 +
    '      }                                                                     ' + #13 +
    '      @media (max-width: 1000px) {                                          ' + #13 +
    '        :root {                                                             ' + #13 +
    '          --scalar-custom-header-height: 50px;                              ' + #13 +
    '        }                                                                   ' + #13 +
    '      }                                                                     ' + #13 +
    '      .light-mode {                                                         ' + #13 +
    '        --scalar-color-1: #121212;                                          ' + #13 +
    '        --scalar-color-2: rgba(0, 0, 0, 0.6);                               ' + #13 +
    '        --scalar-color-3: rgba(0, 0, 0, 0.4);                               ' + #13 +
    '        --scalar-color-accent: #ed7020;                                     ' + #13 +
    '        --scalar-background-1: #fff;                                        ' + #13 +
    '        --scalar-background-2: #f6f5f4;                                     ' + #13 +
    '        --scalar-background-3: #f1ede9;                                     ' + #13 +
    '        --scalar-background-accent: #5369d20f;                              ' + #13 +
    '        --scalar-border-color: rgba(0, 0, 0, 0.08);                         ' + #13 +
    '      }                                                                     ' + #13 +
    '      .dark-mode {                                                          ' + #13 +
    '        --scalar-color-1: rgba(255, 255, 255, 0.81);                        ' + #13 +
    '        --scalar-color-2: rgba(255, 255, 255, 0.443);                       ' + #13 +
    '        --scalar-color-3: rgba(255, 255, 255, 0.282);                       ' + #13 +
    '        --scalar-color-accent: #ed7020;                                     ' + #13 +
    '        --scalar-background-1: #202020;                                     ' + #13 +
    '        --scalar-background-2: #272727;                                     ' + #13 +
    '        --scalar-background-3: #333333;                                     ' + #13 +
    '        --scalar-background-accent: #8ab4f81f;                              ' + #13 +
    '      }                                                                     ' + #13 +
    '      .light-mode .sidebar {                                                ' + #13 +
    '        --scalar-sidebar-background-1: var(--scalar-background-1);          ' + #13 +
    '        --scalar-sidebar-item-hover-color: currentColor;                    ' + #13 +
    '        --scalar-sidebar-item-hover-background: var(--scalar-background-2); ' + #13 +
    '        --scalar-sidebar-item-active-background: var(--scalar-background-2);' + #13 +
    '        --scalar-sidebar-border-color: var(--scalar-border-color);          ' + #13 +
    '        --scalar-sidebar-color-1: var(--scalar-color-1);                    ' + #13 +
    '        --scalar-sidebar-color-2: var(--scalar-color-2);                    ' + #13 +
    '        --scalar-sidebar-color-active: var(--scalar-color-accent);          ' + #13 +
    '        --scalar-sidebar-search-background: var(--scalar-background-2);     ' + #13 +
    '        --scalar-sidebar-search-border-color: var(--scalar-border-color);   ' + #13 +
    '        --scalar-sidebar-search-color: var(--scalar-color-3);               ' + #13 +
    '      }                                                                     ' + #13 +
    '      .dark-mode .sidebar {                                                 ' + #13 +
    '        --scalar-sidebar-background-1: var(--scalar-background-1);          ' + #13 +
    '        --scalar-sidebar-item-hover-color: currentColor;                    ' + #13 +
    '        --scalar-sidebar-item-hover-background: var(--scalar-background-2); ' + #13 +
    '        --scalar-sidebar-item-active-background: var(--scalar-background-2);' + #13 +
    '        --scalar-sidebar-border-color: var(--scalar-border-color);          ' + #13 +
    '        --scalar-sidebar-color-1: var(--scalar-color-1);                    ' + #13 +
    '        --scalar-sidebar-color-2: var(--scalar-color-2);                    ' + #13 +
    '        --scalar-sidebar-color-active: var(--scalar-color-accent);          ' + #13 +
    '        --scalar-sidebar-search-background: var(--scalar-background-2);     ' + #13 +
    '        --scalar-sidebar-search-border-color: var(--scalar-border-color);   ' + #13 +
    '        --scalar-sidebar-search-color: var(--scalar-color-3);               ' + #13 +
    '      }                                                                     ' + #13 +
    '      .custom-navbar {                                                      ' + #13 +
    '        padding: 8px 16px;                                                  ' + #13 +
    '        position: fixed;                                                    ' + #13 +
    '        top: 0;                                                             ' + #13 +
    '        right: 0;                                                           ' + #13 +
    '        left: 0;                                                            ' + #13 +
    '        height: var(--scalar-custom-header-height, 50px);                   ' + #13 +
    '        z-index: 1000;                                                      ' + #13 +
    '        background: var(--scalar-background-1);                             ' + #13 +
    '        border-bottom: 1px solid var(--scalar-border-color);                ' + #13 +
    '        box-sizing: border-box;                                             ' + #13 +
    '      }                                                                     ' + #13 +
    '      .horse-logo {                                                         ' + #13 +
    '        height: 100%;                                                       ' + #13 +
    '        vertical-align: middle;                                             ' + #13 +
    '      }                                                                     ' + #13 +
    '      .horse-title {                                                        ' + #13 +
    '        margin-left: 8px;                                                   ' + #13 +
    '        vertical-align: middle;                                             ' + #13 +
    '        font-family: var(--scalar-font);                                    ' + #13 +
    '        font-weight: bold;                                                  ' + #13 +
    '        color: var(--scalar-color-accent);                                  ' + #13 +
    '      }                                                                     ' + #13 +
    '      .horse-black {                                                        ' + #13 +
    '        color: var(--scalar-color-1);                                       ' + #13 +
    '      }                                                                     ' + #13 +
    '    </style>                                                                ' + #13 +
    '  </head>                                                                   ' + #13 +
    '  <body>                                                                    ' + #13 +
    '    <div class="custom-navbar">                                             ' + #13 +
    '      <img class="horse-logo" src="' + LIcon + '">                          ' + #13 +
    '      <span class="horse-title">                                            ' + #13 +
    '        Horse <span class="horse-black">Documentation</span>                ' + #13 +
    '      </span>                                                               ' + #13 +
    '    </div>                                                                  ' + #13 +
    '    <div id="app"></div>                                                    ' + #13 +
    '    <script src="' + LJavaScript + '"></script>                             ' + #13 +
    '    <script>                                                                ' + #13 +
    '      Scalar.createApiReference(''#app'', {                                 ' + #13 +
    '        url: ''' + LJson + ''',                                             ' + #13 +
    '        persistAuth: true                                                   ' + #13 +
    '      });                                                                   ' + #13 +
    '    </script>                                                               ' + #13 +
    '  </body>                                                                   ' + #13 +
    '</html>                                                                     ');
end;

class procedure THorseDocumentationController.GetIcon(AReq: THorseRequest; ARes: THorseResponse);
var
  LStream: TResourceStream;
begin
  LStream := TResourceStream.Create(GetCurrentModuleHandle, 'HORSE_ICON', RT_RCDATA);
  ARes.SendFile(LStream, 'favicon.png', 'image/png');
end;

class procedure THorseDocumentationController.GetJson(AReq: THorseRequest; ARes: THorseResponse);
var
  LJson: TJSONObject;
begin
  LJson := HorseDoc.ToJson;
  try
    ARes.ContentType('application/json; charset=utf-8')
      .Send(LJson.ToJSON);
  finally
    LJson.Free;
  end;
end;

class function THorseDocumentationController.ListAllRoutes: TArray<TRouteInfo>;
var
  LRoutes: TList<TRouteInfo>;
begin
  LRoutes := TList<TRouteInfo>.Create;
  try
    TraverseRouterTree(THorse.GetInstance.Routes, '/', LRoutes);
    Result := LRoutes.ToArray;
  finally
    LRoutes.Free;
  end;
end;

class procedure THorseDocumentationController.GetJs(AReq: THorseRequest; ARes: THorseResponse);
var
  LStream: TResourceStream;
begin
  LStream := TResourceStream.Create(GetCurrentModuleHandle, 'SCALAR_JS', RT_RCDATA);
  ARes.SendFile(LStream, 'scalar.js', 'application/javascript; charset=utf-8');
end;

{ TRouteInfo }

class function TRouteInfo.Create(const AMethod: TMethodType; const APath: string): TRouteInfo;
begin
  with Result do
  begin
    Method := AMethod;
    Path   := APath;
  end;
end;

end.
