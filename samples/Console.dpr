program Console;

{$APPTYPE CONSOLE}

uses
  Horse,
  System.JSON,
  System.SysUtils,
  Horse.Documentation.Attributes.Contact in '..\src\Horse.Documentation.Attributes.Contact.pas',
  Horse.Documentation.Controller in '..\src\Horse.Documentation.Controller.pas',
  Horse.Documentation.OpenApi.Ancestor in '..\src\Horse.Documentation.OpenApi.Ancestor.pas',
  Horse.Documentation.OpenApi.CodeSample in '..\src\Horse.Documentation.OpenApi.CodeSample.pas',
  Horse.Documentation.OpenApi.Components in '..\src\Horse.Documentation.OpenApi.Components.pas',
  Horse.Documentation.OpenApi.Contact in '..\src\Horse.Documentation.OpenApi.Contact.pas',
  Horse.Documentation.OpenApi.Encoding in '..\src\Horse.Documentation.OpenApi.Encoding.pas',
  Horse.Documentation.OpenApi.Example in '..\src\Horse.Documentation.OpenApi.Example.pas',
  Horse.Documentation.OpenApi.ExternalDocumentation in '..\src\Horse.Documentation.OpenApi.ExternalDocumentation.pas',
  Horse.Documentation.OpenApi.Header in '..\src\Horse.Documentation.OpenApi.Header.pas',
  Horse.Documentation.OpenApi.Info in '..\src\Horse.Documentation.OpenApi.Info.pas',
  Horse.Documentation.OpenApi.Interfaces in '..\src\Horse.Documentation.OpenApi.Interfaces.pas',
  Horse.Documentation.OpenApi.License in '..\src\Horse.Documentation.OpenApi.License.pas',
  Horse.Documentation.OpenApi.Link in '..\src\Horse.Documentation.OpenApi.Link.pas',
  Horse.Documentation.OpenApi.Logo in '..\src\Horse.Documentation.OpenApi.Logo.pas',
  Horse.Documentation.OpenApi.MediaType in '..\src\Horse.Documentation.OpenApi.MediaType.pas',
  Horse.Documentation.OpenApi.OAuthFlow in '..\src\Horse.Documentation.OpenApi.OAuthFlow.pas',
  Horse.Documentation.OpenApi.OAuthFlows in '..\src\Horse.Documentation.OpenApi.OAuthFlows.pas',
  Horse.Documentation.OpenApi.Operation in '..\src\Horse.Documentation.OpenApi.Operation.pas',
  Horse.Documentation.OpenApi.Parameter in '..\src\Horse.Documentation.OpenApi.Parameter.pas',
  Horse.Documentation.OpenApi.PathItem in '..\src\Horse.Documentation.OpenApi.PathItem.pas',
  Horse.Documentation.OpenApi.RequestBody in '..\src\Horse.Documentation.OpenApi.RequestBody.pas',
  Horse.Documentation.OpenApi.Response in '..\src\Horse.Documentation.OpenApi.Response.pas',
  Horse.Documentation.OpenApi.Responses in '..\src\Horse.Documentation.OpenApi.Responses.pas',
  Horse.Documentation.OpenApi.Root in '..\src\Horse.Documentation.OpenApi.Root.pas',
  Horse.Documentation.OpenApi.SecurityRequirement in '..\src\Horse.Documentation.OpenApi.SecurityRequirement.pas',
  Horse.Documentation.OpenApi.SecurityScheme in '..\src\Horse.Documentation.OpenApi.SecurityScheme.pas',
  Horse.Documentation.OpenApi.Server in '..\src\Horse.Documentation.OpenApi.Server.pas',
  Horse.Documentation.OpenApi.ServerVariable in '..\src\Horse.Documentation.OpenApi.ServerVariable.pas',
  Horse.Documentation.OpenApi.Tag in '..\src\Horse.Documentation.OpenApi.Tag.pas',
  Horse.Documentation.OpenApi.TagGroup in '..\src\Horse.Documentation.OpenApi.TagGroup.pas',
  Horse.Documentation.OpenApi.Types in '..\src\Horse.Documentation.OpenApi.Types.pas',
  Horse.Documentation.OpenApi.Utils in '..\src\Horse.Documentation.OpenApi.Utils.pas',
  Horse.Documentation in '..\src\Horse.Documentation.pas';

begin
  {$IFDEF MSWINDOWS}
  IsConsole := False;
  ReportMemoryLeaksOnShutdown := True;
  {$ENDIF}

  THorse.Use(HorseDocumentation);

  HorseDoc
    .Info
      .Title('Horse Documentation - Exemplo Completo')
      .Version('1.1.0')
      .Summary('API de demonstração dos recursos do Horse Documentation (OpenAPI 3.1.1 + Scalar UI)')
      .Description(
'''
# Informações Gerais

Aqui em `Info.Description` você pode colocar desde uma breve descrição do que é a documentação da sua API,
até mesmo uma introdução completa documentando as especificações técnicas de como consumir seu projeto.

Perceba que podemos utilizar escrita com **Markdown**, e o texto será convertido para HTML rico.

# Nível 1

Dentro do Markdown temos várias formatações práticas, e neste projeto não seria diferente: conseguimos
colocar vários blocos de documentação e também subníveis, e tudo será interpretado e organizado no menu lateral.

## Nível 2

Aqui é o segundo nível de documentação do Markdown.
'''     )
      .Contact
        .Name('Weslley Capelari')
        .Url('https://github.com/weslleycapelari/horse-documentation')
        .&End
      .License
        .Name('MIT')
        .Identifier('MIT')
        .&End
      .Logo
        .Url('/horse/doc/html/favicon.png')
        .AltText('Horse Documentation Logo')
        .&End
      .&End
    .Servers
      .Add
        .Url('http://localhost:9000')
        .Description('Servidor de Desenvolvimento Local')
        .&End
    .Components
      .SecuritySchemes
        .Add('bearerAuth')
          .&Type(TSecuritySchemeType.sstHttp)
          .Scheme('bearer')
          .BearerFormat('JWT')
          .Description('Autenticação via token JWT Bearer')
          .&End
      .&End
    .Paths
      .Add('/ping')
        .Description(
'''
Graças à função `THorseDocumentationController.AutoMapHorse`, todas as rotas presentes no servidor Horse são mapeadas
automaticamente para a documentação. Além disso, você pode documentar rota por rota de forma fluente, adicionando
informações detalhadas, parâmetros, exemplos de código e respostas para cada operação.
'''     )
        .Get
          .Summary('Healthcheck do servidor')
          .Description('Verifica a disponibilidade do servidor retornando `pong`.')
          .OperationId('getPing')
          .Tags.Add('Ping')
          .CodeSamples
            .Add
              .Lang('Delphi')
              .&Label('RESTRequest4Delphi')
              .Source(
'''
var
  LResponse: IResponse;
begin
  LResponse := TRequest.New
    .BaseURL('http://localhost:9000')
    .Resource('/ping')
    .Get;
  Writeln(LResponse.Content);
end;
'''           )
              .&End
          .CodeSamples
            .Add
              .Lang('bash')
              .&Label('cURL')
              .Source('curl -X GET "http://localhost:9000/ping"')
              .&End
          .Responses
            .StatusCodes
              .Add('200')
                .Description('Servidor online e respondendo normalmente.')
                .Content
                  .Add('text/plain')
                    .Schema(TJSONObject.Create
                      .AddPair('description', 'Resposta textual de healthcheck')
                      .AddPair('type', 'string')
                      .AddPair('example', 'pong'))
                    .&End
                .&End
            .&End
          .&End
        .&End
    .Tags
      .Add
        .Name('Ping')
        .DisplayName('Diagnóstico (Ping)')
        .Description('Operações de verificação de saúde e conectividade da API.')
        .&End
    .TagGroups
      .Add
        .Name('Grupo de Rotas')
        .Tags
          .Add('Ping')
        .&End;

  THorse.Get('/ping',
    procedure(Req: THorseRequest; Res: THorseResponse)
    begin
      Res.Send('pong');
    end);

  THorse.Listen(9000,
    procedure
    begin
      THorseDocumentationController.AutoMapHorse;
      Writeln(Format('Server is running on %s:%d', [THorse.Host, THorse.Port]));
      Writeln(Format('To see Documentation open http://localhost:%d/horse/doc/html', [THorse.Port]));
      Readln;
    end);
end.
