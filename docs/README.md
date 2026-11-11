# Documentação Técnica — Horse Documentation

Bem-vindo à documentação técnica completa do **Horse Documentation**. Este diretório reúne a especificação arquitetural, o catálogo de interfaces OpenAPI 3.1.1 e os guias avançados de uso da biblioteca.

---

## Guias Disponíveis

1. [**Arquitetura e Funcionamento Interno (`architecture.md`)**](architecture.md)
   - Fluxo de inicialização e registro do middleware;
   - Descoberta automática de rotas via RTTI (`TraverseRouterTree` e `AutoMapHorse`);
   - Gerenciamento de recursos embarcados (`Horse.Documentation.res`: `SCALAR_JS` e `HORSE_ICON`);
   - Coleções fluentes genéricas (`TOpenApiList<T, O>` e `TOpenApiMap<T, O>`) com fábrica estática `New`;
   - Pipeline de serialização JSON (`TOpenApiAncestor` e `TUtils.ValueToJson`).

2. [**Referência dos Modelos OpenAPI 3.1.1 (`openapi-models.md`)**](openapi-models.md)
   - Hierarquia completa de interfaces (`IOpenApiAncestor` até `IOpenApi`);
   - Tabelas de métodos, parâmetros, tipos de retorno e campos JSON gerados para cada objeto da especificação;
   - Tipos enumerados (`TParameterLocation`, `TParameterStyle`, `TSecuritySchemeType`, `TApiKeyLocation`) e seus *record helpers*.

3. [**Segurança e Autenticação (`security-and-auth.md`)**](security-and-auth.md)
   - Configuração detalhada de esquemas HTTP (`bearer` JWT e `basic`), `apiKey`, `oauth2` (todos os 4 fluxos), `openIdConnect` e `mutualTLS`;
   - Aplicação de requisitos de segurança globais (`HorseDoc.Security`) e por operação (`Operation.Security`);
   - Persistência de credenciais na interface Scalar (`persistAuth: true`).

4. [**Extensões e Customização Visual (`extensions-and-customization.md`)**](extensions-and-customization.md)
   - Uso das extensões nativas suportadas pelo Scalar e Redoc (`x-logo`, `x-tagGroups`, `x-displayName`, `x-code-samples`);
   - Adição de Specification Extensions arbitrárias (`x-*`) via `IOpenApiAncestor.Extensions`;
   - Estruturação de descrições ricas em CommonMark/Markdown com criação automática de seções no menu lateral.

---

## Mapa de Units (`src/`)

O projeto é composto por **34 units** organizadas de forma modular:

| Unit | Responsabilidade Principal |
| :--- | :--- |
| `Horse.Documentation.pas` | Unit de fachada (facade): expõe o middleware `HorseDocumentation`, a instância global `HorseDoc: IOpenApi`, constantes de rota (`PATH_HTML`, `PATH_JSON`) e aliases de tipos. |
| `Horse.Documentation.Controller.pas` | Controlador HTTP (`THorseDocumentationController`) que registra os endpoints da documentação, serve os recursos embarcados e executa o `AutoMapHorse` via RTTI. |
| `Horse.Documentation.Attributes.Contact.pas` | Atributo RTTI `THorseDocContactAttribute` para metadados de contato. |
| `Horse.Documentation.OpenApi.Interfaces.pas` | Declaração de todas as interfaces fluentes do modelo OpenAPI 3.1.1 (`IOpenApi`, `IInfo`, `IPathItem<T>`, `IOperation<T>`, etc.). |
| `Horse.Documentation.OpenApi.Types.pas` | Tipos enumerados da OpenAPI, *record helpers* de conversão e coleções genéricas fluentes `TOpenApiList<T, O>` e `TOpenApiMap<T, O>`. |
| `Horse.Documentation.OpenApi.Ancestor.pas` | Classe base `TOpenApiAncestor` com suporte a `Extensions` (`x-*`) e método base `ToJson`. |
| `Horse.Documentation.OpenApi.Utils.pas` | Utilitário `TUtils.ValueToJson` para conversão de `TValue` (primitivos, arrays, listas e dicionários) em `TJSONValue`. |
| `Horse.Documentation.OpenApi.Root.pas` | Implementação da raiz `TOpenApi` (`IOpenApi`). |
| `Horse.Documentation.OpenApi.Info.pas` | Implementação de `TInfo` (`IInfo`). |
| `Horse.Documentation.OpenApi.Contact.pas` | Implementação de `TContact` (`IContact`). |
| `Horse.Documentation.OpenApi.License.pas` | Implementação de `TLicense` (`ILicense`). |
| `Horse.Documentation.OpenApi.Logo.pas` | Implementação de `TLogo` (`ILogo` -> `x-logo`). |
| `Horse.Documentation.OpenApi.Server.pas` | Implementação de `TServer<T>` (`IServer<T>`). |
| `Horse.Documentation.OpenApi.ServerVariable.pas` | Implementação de `TServerVariable<T>` (`IServerVariable<T>`). |
| `Horse.Documentation.OpenApi.PathItem.pas` | Implementação de `TPathItem<T>` (`IPathItem<T>`). |
| `Horse.Documentation.OpenApi.Operation.pas` | Implementação de `TOperation<T>` (`IOperation<T>`). |
| `Horse.Documentation.OpenApi.Parameter.pas` | Implementação de `TParameter<T>` (`IParameter<T>`). |
| `Horse.Documentation.OpenApi.RequestBody.pas` | Implementação de `TRequestBody<T>` (`IRequestBody<T>`). |
| `Horse.Documentation.OpenApi.MediaType.pas` | Implementação de `TMediaType<T>` (`IMediaType<T>`). |
| `Horse.Documentation.OpenApi.Encoding.pas` | Implementação de `TEncoding<T>` (`IEncoding<T>`). |
| `Horse.Documentation.OpenApi.Responses.pas` | Implementação de `TResponses<T>` (`IResponses<T>`). |
| `Horse.Documentation.OpenApi.Response.pas` | Implementação de `TResponse<T>` (`IResponse<T>`). |
| `Horse.Documentation.OpenApi.Header.pas` | Implementação de `THeader<T>` (`IHeader<T>`). |
| `Horse.Documentation.OpenApi.Example.pas` | Implementação de `TExample<T>` (`IExample<T>`). |
| `Horse.Documentation.OpenApi.Link.pas` | Implementação de `TLink<T>` (`ILink<T>`). |
| `Horse.Documentation.OpenApi.Components.pas` | Implementação de `TComponents` (`IComponents`). |
| `Horse.Documentation.OpenApi.SecurityScheme.pas` | Implementação de `TSecurityScheme` (`ISecurityScheme`). |
| `Horse.Documentation.OpenApi.SecurityRequirement.pas` | Implementação de `TSecurityRequirement<T>` (`ISecurityRequirement<T>`). |
| `Horse.Documentation.OpenApi.OAuthFlows.pas` | Implementação de `TOAuthFlows` (`IOAuthFlows`). |
| `Horse.Documentation.OpenApi.OAuthFlow.pas` | Implementação de `TOAuthFlow` (`IOAuthFlow`). |
| `Horse.Documentation.OpenApi.Tag.pas` | Implementação de `TTag` (`ITag`). |
| `Horse.Documentation.OpenApi.TagGroup.pas` | Implementação de `TTagGroup` (`ITagGroup` -> `x-tagGroups`). |
| `Horse.Documentation.OpenApi.CodeSample.pas` | Implementação de `TCodeSample<T>` (`ICodeSample<T>` -> `x-code-samples`). |
| `Horse.Documentation.OpenApi.ExternalDocumentation.pas` | Implementação de `TExternalDocumentation<T>` (`IExternalDocumentation<T>`). |
