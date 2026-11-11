unit Horse.Documentation;

interface

uses
  Horse,
  System.Classes,
  System.SysUtils,
  System.StrUtils,
  Horse.Documentation.Controller,
  Horse.Documentation.OpenApi.Root,
  Horse.Documentation.OpenApi.Types,
  Horse.Documentation.OpenApi.Interfaces;

const
  /// <summary>Caminho padrão para acesso à interface visual (Scalar UI) da documentação.</summary>
  PATH_HTML = '/horse/doc/html';

  /// <summary>Caminho padrão para acesso ao documento JSON da especificação OpenAPI 3.1.1.</summary>
  PATH_JSON = '/horse/doc/json';

type
  /// <summary>Controlador responsável pelo registro de rotas, descoberta automática e entrega dos recursos da documentação.</summary>
  THorseDocumentationController = Horse.Documentation.Controller.THorseDocumentationController;

  /// <summary>Define os locais possíveis para um parâmetro OpenAPI (query, header, path, cookie).</summary>
  TParameterLocation = Horse.Documentation.OpenApi.Types.TParameterLocation;

  /// <summary>Define os estilos de serialização para um parâmetro OpenAPI (matrix, label, simple, form, etc.).</summary>
  TParameterStyle = Horse.Documentation.OpenApi.Types.TParameterStyle;

  /// <summary>Define os tipos de esquemas de segurança OpenAPI (apiKey, http, mutualTLS, oauth2, openIdConnect).</summary>
  TSecuritySchemeType = Horse.Documentation.OpenApi.Types.TSecuritySchemeType;

  /// <summary>Define a localização de uma chave de API (query, header, cookie).</summary>
  TApiKeyLocation = Horse.Documentation.OpenApi.Types.TApiKeyLocation;

/// <summary>
///   Registra o middleware de documentação no Horse utilizando as rotas padrão
///   (<c>/horse/doc/html</c> e <c>/horse/doc/json</c>).
/// </summary>
/// <returns>Callback do middleware compatível com <c>THorse.Use</c>.</returns>
function HorseDocumentation: THorseCallback; overload;

/// <summary>
///   Registra o middleware de documentação no Horse utilizando rotas customizadas
///   para a interface HTML e para a especificação JSON.
/// </summary>
/// <param name="APathHtml">Caminho da rota para a interface visual HTML (Scalar UI).</param>
/// <param name="APathJSON">Caminho da rota para o documento JSON OpenAPI. Se vazio, assume <c>PATH_JSON</c>.</param>
/// <returns>Callback do middleware compatível com <c>THorse.Use</c>.</returns>
function HorseDocumentation(APathHtml: String; APathJSON: string = ''): THorseCallback; overload;

var
  /// <summary>
  ///   Instância global da especificação OpenAPI (<c>IOpenApi</c>) para construção fluente
  ///   da documentação da API.
  /// </summary>
  HorseDoc: IOpenApi;

implementation

function HorseDocumentation(APathHtml: String; APathJSON: string = ''): THorseCallback;
begin
  THorseDocumentationController.Registry(APathHtml, APathJSON);

  Result :=
    procedure(Req: THorseRequest; Res: THorseResponse; Next: TProc)
    begin
      try
        Next();
      finally
      end;
    end;
end;

function HorseDocumentation: THorseCallback;
begin
  Result := HorseDocumentation(PATH_HTML, PATH_JSON);
end;

initialization
  HorseDoc := TOpenApi.New;

end.
