program Console;

{$APPTYPE CONSOLE}

{$R *.res}

uses
  Horse,
  System.JSON,
  System.SysUtils,
  Horse.Documentation.Controller in '..\src\Horse.Documentation.Controller.pas',
  Horse.Documentation.OpenApi.Ancestor in '..\src\Horse.Documentation.OpenApi.Ancestor.pas',
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
      .Description(
'''
# Informações Gerais

Aqui no summary é um local onde você pode colocar desde uma breve descrição do que é esta documentação da sua API,
até mesmo uma introdução completa documentando as especificações técnicas de como consumir seu projeto.

Perceba que podemos utilizar uma escrita com **markdown**, e o texto será convertido para um html.

# Nível 1

Dentro do markdown ele tem várias formatações práticas, e neste projeto nao seria diferente, perceça que conseguimos
colocar vários blocos de documentação e também subníveis, e tudo será interpretado e colocado no menu lateral.

## Nível 2

Aqui é o segundo nivel de documentação do markdown
'''     )
      .&End
    .Paths
      .Add('/ping')
      .Description(
'''
Graças a função ``THorseDocumentationController.AutoMapHorse``, todas as rotas presente no servidor Horse são mapeadas
para a nossa documentação, mas apenas para ela dizer um ``estou aqui``, mas com a nossa biblioteca você também pode
documentar rota por rota também, adicionando informações importantes para cada uma delas.
'''   )
      .Get
        .Description('Aqui por exemplo estou mapeando a rota ``/ping`` com o tipo ``GET``')
        .Tags.Add('Ping')
        .Responses
          .StatusCodes
            .Add('200')
            .Content
              .Add('text/html')
              .Schema(TJSONObject.Create
                .AddPair('description', 'Aqui por exemplo estou documentando um tipo de resposta desta requisição')
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
      .Description('Também podemos adicionar tags personalizadas para realizar um agrupamento de requisições')
      .&End
    .Extensions
      .AddValue('x-tagGroups', TJSONArray.Create
        .Add(TJSONObject.Create
          .AddPair('name', 'Grupo de rotas')
          .AddPair('tags', TJSONArray.Create
            .Add('Ping'))));

  THorse.Get('/ping',
    procedure(Req: THorseRequest; Res: THorseResponse)
    begin
      Res.Send('pong');
    end);

  THorse.Listen(9000,
    procedure
    begin
      THorseDocumentationController.AutoMapHorse;
      Writeln(Format('Server is runing on %s:%d', [THorse.Host, THorse.Port]));
      Writeln(Format('For see Documentation open %s:%d/horse/doc/html', [THorse.Host, THorse.Port]));
      Readln;
    end);
end.
