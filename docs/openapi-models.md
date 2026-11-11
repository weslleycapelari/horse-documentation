# Referência dos Modelos OpenAPI 3.1.1

Este documento apresenta a referência completa de todas as interfaces, classes e tipos enumerados que compõem o modelo **OpenAPI 3.1.1** no **Horse Documentation** (`Horse.Documentation.OpenApi.Interfaces` e `Horse.Documentation.OpenApi.Types`).

---

## Convenções da API Fluente

Todas as interfaces de modelo seguem três convenções padronizadas:

1. **Getters e Setters Sobrecarregados**:
   - `function Propriedade: Tipo; overload;` — lê o valor atual;
   - `function Propriedade(const AValue: Tipo): IInterfaceAtual; overload;` — define o valor e retorna a própria interface para encadeamento fluente.
2. **Sub-objetos e Coleções com Inicialização Sob Demanda (*Lazy Initialization*)**:
   - Métodos como `.Info`, `.Contact`, `.Responses`, `.Paths`, `.Servers`, `.Parameters` instanciam o objeto ou coleção automaticamente no primeiro acesso.
3. **Navegação de Retorno (`.&End`)**:
   - Retorna a referência da interface pai na hierarquia, permitindo construir todo o documento em uma única expressão fluente.

---

## Tipos Enumerados (`Horse.Documentation.OpenApi.Types`)

### `TParameterLocation`

Define a localização (`in`) de um parâmetro de operação (`IParameter<T>`):

| Valor | Valor JSON (`ToString`) | Descrição |
| :--- | :--- | :--- |
| `plQuery` | `'query'` | Parâmetro enviado na query string da URL (`?chave=valor`). |
| `plHeader` | `'header'` | Cabeçalho HTTP customizado enviado na requisição. |
| `plPath` | `'path'` | Parâmetro que faz parte do template da URL (`/recurso/{id}`). |
| `plCookie` | `'cookie'` | Valor enviado através do cabeçalho `Cookie`. |

### `TParameterStyle`

Define como valores de parâmetros (`IParameter<T>`), cabeçalhos (`IHeader<T>`) e codificações (`IEncoding<T>`) são serializados:

| Valor | Valor JSON (`ToString`) | Uso Típico |
| :--- | :--- | :--- |
| `psMatrix` | `'matrix'` | Parâmetros de caminho estilo matriz (`;id=5`). |
| `psLabel` | `'label'` | Parâmetros de caminho prefixados por ponto (`.5`). |
| `psSimple` | `'simple'` | Valores separados por vírgula (padrão para `plPath` e `plHeader`). |
| `psForm` | `'form'` | Estilo formulário ampersand (padrão para `plQuery` e `plCookie`). |
| `psSpaceDelimited` | `'spaceDelimited'` | Arrays delimitados por espaço (`%20`). |
| `psPipeDelimited` | `'pipeDelimited'` | Arrays delimitados por pipe (`|`). |
| `psDeepObject` | `'deepObject'` | Objetos aninhados em query (`filtro[status]=ativo`). |

### `TSecuritySchemeType`

Define o tipo de esquema de segurança (`ISecurityScheme`):

| Valor | Valor JSON (`ToString`) | Descrição |
| :--- | :--- | :--- |
| `sstApiKey` | `'apiKey'` | Chave de API enviada em header, query ou cookie. |
| `sstHttp` | `'http'` | Autenticação HTTP padrão (`bearer`, `basic`, etc.). |
| `sstMutualTLS` | `'mutualTLS'` | Autenticação mútua via certificado TLS (mTLS). |
| `sstOAuth2` | `'oauth2'` | Autenticação/autorização via fluxos OAuth 2.0. |
| `sstOpenIdConnect` | `'openIdConnect'` | Descoberta automática via OpenID Connect Discovery. |

### `TApiKeyLocation`

Define onde a chave de API é enviada quando `TSecuritySchemeType = sstApiKey`:

| Valor | Valor JSON (`ToString`) |
| :--- | :--- |
| `aklQuery` | `'query'` |
| `aklHeader` | `'header'` |
| `aklCookie` | `'cookie'` |

---

## Catálogo de Interfaces

### 1. `IOpenApiAncestor` (`TOpenApiAncestor`)

Interface base herdada por todos os elementos do modelo.

| Método | Retorno | Campo JSON | Descrição |
| :--- | :--- | :--- | :--- |
| `Extensions` | `TOpenApiMap<TJSONValue, IOpenApiAncestor>` | `<chave x-*>` | Mapa de extensões customizadas da especificação. |
| `ToJson` | `TJSONObject` | — | Exporta o objeto e suas extensões para JSON. |

---

### 2. `IOpenApi` (`TOpenApi`)

Objeto raiz da especificação OpenAPI 3.1.1 (acessível globalmente via `HorseDoc`).

| Método | Tipo / Retorno | Campo JSON | Descrição |
| :--- | :--- | :--- | :--- |
| `Openapi` | `string` / `IOpenApi` | `openapi` | Versão da especificação OpenAPI (padrão `'3.1.1'`). |
| `Info` | `IInfo` | `info` | Metadados gerais da API. |
| `JsonSchemaDialect` | `string` / `IOpenApi` | `jsonSchemaDialect` | URI do dialeto padrão para objetos `ISchema`. |
| `Servers` | `TOpenApiList<IServer<IOpenApi>, IOpenApi>` | `servers` | Lista de servidores da API. |
| `Paths` | `TOpenApiMap<IPathItem<IOpenApi>, IOpenApi>` | `paths` | Mapa de rotas e operações da API. |
| `Webhooks` | `TOpenApiMap<IPathItem<IOpenApi>, IOpenApi>` | `webhooks` | Mapa de webhooks recebidos/disparados pela API. |
| `Components` | `IComponents` | `components` | Contêiner de objetos reutilizáveis. |
| `Security` | `TOpenApiList<ISecurityRequirement<IOpenApi>, IOpenApi>` | `security` | Requisitos globais de segurança. |
| `Tags` | `TOpenApiList<ITag, IOpenApi>` | `tags` | Lista de tags com metadados adicionais. |
| `TagGroups` | `TOpenApiList<ITagGroup, IOpenApi>` | `x-tagGroups` | Grupos hierárquicos de tags no menu lateral. |
| `ExternalDocs` | `IExternalDocumentation<IOpenApi>` | `externalDocs` | Documentação externa global. |

---

### 3. `IInfo` (`TInfo`), `IContact` (`TContact`), `ILicense` (`TLicense`) e `ILogo` (`TLogo`)

#### `IInfo` (pai: `IOpenApi`)
- `Title`: `string` (`title` - obrigatório, padrão `'Horse Documentation'`)
- `Summary`: `string` (`summary`)
- `Description`: `string` (`description` - suporta CommonMark)
- `TermsOfService`: `string` (`termsOfService`)
- `Contact`: `IContact` (`contact`)
- `License`: `ILicense` (`license`)
- `Logo`: `ILogo` (`x-logo`)
- `Version`: `string` (`version` - obrigatório, padrão `'1.0.0'`)
- `&End`: retorna `IOpenApi`

#### `IContact` (pai: `IInfo`)
- `Name`: `string` (`name`)
- `Url`: `string` (`url`)
- `Email`: `string` (`email`)
- `&End`: retorna `IInfo`

#### `ILicense` (pai: `IInfo`)
- `Name`: `string` (`name`)
- `Identifier`: `string` (`identifier` - expressão SPDX, ex: `'MIT'`, `'Apache-2.0'`)
- `Url`: `string` (`url`)
- `&End`: retorna `IInfo`

#### `ILogo` (pai: `IInfo`)
- `Url`: `string` (`url`)
- `BackgroundColor`: `string` (`backgroundColor`)
- `AltText`: `string` (`altText`)
- `Href`: `string` (`href`)
- `&End`: retorna `IInfo`

---

### 4. `IServer<T>` (`TServer<T>`) e `IServerVariable<T>` (`TServerVariable<T>`)

#### `IServer<T>` (pai: `T` — pode ser `IOpenApi`, `IPathItem`, `IOperation` ou `ILink`)
- `Url`: `string` (`url` - obrigatório)
- `Description`: `string` (`description`)
- `Variables`: `TOpenApiMap<IServerVariable<T>, IServer<T>>` (`variables`)
- `&End`: retorna `T`

#### `IServerVariable<T>` (pai: `IServer<T>`)
- `&Enum`: `TOpenApiList<string, IServerVariable<T>>` (`enum`)
- `&Default`: `string` (`default` - obrigatório)
- `Description`: `string` (`description`)
- `&End`: retorna `IServer<T>`

---

### 5. `IPathItem<T>` (`TPathItem<T>`) e `IOperation<T>` (`TOperation<T>`)

#### `IPathItem<T>` (pai: `T`)
- `Ref`: `string` (`$ref`)
- `Summary`: `string` (`summary`)
- `Description`: `string` (`description`)
- Operações por método HTTP (retornam `IOperation<IPathItem<T>>`):
  - `Get` (`get`), `Put` (`put`), `Post` (`post`), `&Delete` (`delete`), `Options` (`options`), `Head` (`head`), `Patch` (`patch`), `Trace` (`trace`)
- `Servers`: `TOpenApiList<IServer<IPathItem<T>>, IPathItem<T>>` (`servers`)
- `Parameters`: `TOpenApiList<IParameter<IPathItem<T>>, IPathItem<T>>` (`parameters`)
- `&End`: retorna `T`

#### `IOperation<T>` (pai: `T` — tipicamente `IPathItem`)
- `Tags`: `TOpenApiList<string, IOperation<T>>` (`tags`)
- `Summary`: `string` (`summary`)
- `Description`: `string` (`description`)
- `ExternalDocs`: `IExternalDocumentation<IOperation<T>>` (`externalDocs`)
- `OperationId`: `string` (`operationId`)
- `Parameters`: `TOpenApiList<IParameter<IOperation<T>>, IOperation<T>>` (`parameters`)
- `RequestBody`: `IRequestBody<IOperation<T>>` (`requestBody`)
- `Responses`: `IResponses<IOperation<T>>` (`responses`)
- `Deprecated`: `Boolean` (`deprecated`)
- `Security`: `TOpenApiList<ISecurityRequirement<IOperation<T>>, IOperation<T>>` (`security`)
- `Servers`: `TOpenApiList<IServer<IOperation<T>>, IOperation<T>>` (`servers`)
- `CodeSamples`: `TOpenApiList<ICodeSample<IOperation<T>>, IOperation<T>>` (`x-code-samples`)
- `&End`: retorna `T`

---

### 6. `IParameter<T>` (`TParameter<T>`) e `IHeader<T>` (`THeader<T>`)

| Método | `IParameter<T>` | `IHeader<T>` | Campo JSON |
| :--- | :---: | :---: | :--- |
| `Name` | Sim (`string`) | Não (é a chave do mapa) | `name` |
| `&In` | Sim (`TParameterLocation`) | Não | `in` |
| `Description` | Sim (`string`) | Sim (`string`) | `description` |
| `Required` | Sim (`Boolean`) | Sim (`Boolean`) | `required` |
| `Deprecated` | Sim (`Boolean`) | Sim (`Boolean`) | `deprecated` |
| `AllowEmptyValue` | Sim (`Boolean`) | Não | `allowEmptyValue` |
| `Style` | Sim (`TParameterStyle`) | Sim (`TParameterStyle`) | `style` |
| `Explode` | Sim (`Boolean`) | Sim (`Boolean`) | `explode` |
| `AllowReserved` | Sim (`Boolean`) | Não | `allowReserved` |
| `Schema` | Sim (`ISchema` / `TJSONValue`) | Sim (`ISchema` / `TJSONValue`) | `schema` |
| `Example` | Sim (`TJSONValue`) | Sim (`TJSONValue`) | `example` |
| `Examples` | Sim (`TOpenApiMap<IExample...>`) | Sim (`TOpenApiMap<IExample...>`) | `examples` |
| `Content` | Sim (`TOpenApiMap<IMediaType...>`) | Sim (`TOpenApiMap<IMediaType...>`) | `content` |

---

### 7. `IRequestBody<T>`, `IMediaType<T>` e `IEncoding<T>`

#### `IRequestBody<T>` (`TRequestBody<T>`)
- `Description`: `string` (`description`)
- `Content`: `TOpenApiMap<IMediaType<IRequestBody<T>>, IRequestBody<T>>` (`content`)
- `Required`: `Boolean` (`required`)
- `&End`: retorna `T`

#### `IMediaType<T>` (`TMediaType<T>`)
- `Schema`: `ISchema` (`schema` — onde `ISchema = TJSONValue`)
- `Example`: `TJSONValue` (`example`)
- `Examples`: `TOpenApiMap<IExample<IMediaType<T>>, IMediaType<T>>` (`examples`)
- `Encoding`: `TOpenApiMap<IEncoding<IMediaType<T>>, IMediaType<T>>` (`encoding`)
- `&End`: retorna `T`

#### `IEncoding<T>` (`TEncoding<T>`)
- `ContentType`: `string` (`contentType`)
- `Style`: `TParameterStyle` (`style`)
- `Explode`: `Boolean` (`explode`)
- `AllowReserved`: `Boolean` (`allowReserved`)
- `&End`: retorna `T`

---

### 8. `IResponses<T>`, `IResponse<T>`, `IExample<T>` e `ILink<T>`

#### `IResponses<T>` (`TResponses<T>`)
- `&Default`: `IResponse<IResponses<T>>` (`default`)
- `StatusCodes`: `TOpenApiMap<IResponse<IResponses<T>>, IResponses<T>>` (cada código HTTP é serializado diretamente como propriedade do objeto `responses`, ex: `"200": { ... }`)
- `&End`: retorna `T`

#### `IResponse<T>` (`TResponse<T>`)
- `Description`: `string` (`description` - obrigatório)
- `Headers`: `TOpenApiMap<IHeader<IResponse<T>>, IResponse<T>>` (`headers`)
- `Content`: `TOpenApiMap<IMediaType<IResponse<T>>, IResponse<T>>` (`content`)
- `Links`: `TOpenApiMap<ILink<IResponse<T>>, IResponse<T>>` (`links`)
- `&End`: retorna `T`

#### `IExample<T>` (`TExample<T>`)
- `Summary`: `string` (`summary`)
- `Description`: `string` (`description`)
- `Value`: `TJSONValue` (`value`)
- `ExternalValue`: `string` (`externalValue`)
- `&End`: retorna `T`

#### `ILink<T>` (`TLink<T>`)
- `OperationRef`: `string` (`operationRef`)
- `OperationId`: `string` (`operationId`)
- `Parameters`: `TOpenApiMap<string, ILink<T>>` (`parameters`)
- `RequestBody`: `TJSONValue` (`requestBody`)
- `Description`: `string` (`description`)
- `Server`: `IServer<ILink<T>>` (`server`)
- `&End`: retorna `T`

---

### 9. `IComponents` (`TComponents`)

Contêiner de objetos reutilizáveis sob `#/components/...`:

- `Schemas`: `TOpenApiMap<ISchema, IComponents>` (`schemas` — usar `.AddValue(Nome, SchemaJson)`)
- `Responses`: `TOpenApiMap<IResponse<IComponents>, IComponents>` (`responses` — usar `.Add(Nome)`)
- `Parameters`: `TOpenApiMap<IParameter<IComponents>, IComponents>` (`parameters` — usar `.Add(Nome)`)
- `Examples`: `TOpenApiMap<IExample<IComponents>, IComponents>` (`examples` — usar `.Add(Nome)`)
- `RequestBodies`: `TOpenApiMap<IRequestBody<IComponents>, IComponents>` (`requestBodies` — usar `.Add(Nome)`)
- `Headers`: `TOpenApiMap<IHeader<IComponents>, IComponents>` (`headers` — usar `.Add(Nome)`)
- `SecuritySchemes`: `TOpenApiMap<ISecurityScheme, IComponents>` (`securitySchemes` — usar `.Add(Nome)`)
- `Links`: `TOpenApiMap<ILink<IComponents>, IComponents>` (`links` — usar `.Add(Nome)`)
- `Callbacks`: `TOpenApiMap<IPathItem<IComponents>, IComponents>` (`callbacks` — usar `.Add(Nome)`)
- `PathItems`: `TOpenApiMap<IPathItem<IComponents>, IComponents>` (`pathItems` — usar `.Add(Nome)`)
- `&End`: retorna `IOpenApi`

---

### 10. `ITag`, `ITagGroup`, `ICodeSample<T>` e `IExternalDocumentation<T>`

- **`ITag` (`TTag`)**: `Name` (`name`), `Description` (`description`), `DisplayName` (`x-displayName`), `ExternalDocs` (`externalDocs`), `&End` (`IOpenApi`).
- **`ITagGroup` (`TTagGroup`)**: `Name` (`name`), `Tags` (`tags` - `TOpenApiList<string, ITagGroup>`), `&End` (`IOpenApi`).
- **`ICodeSample<T>` (`TCodeSample<T>`)**: `Lang` (`lang`), `&Label` (`label`), `Source` (`source`), `&End` (`T`).
- **`IExternalDocumentation<T>` (`TExternalDocumentation<T>`)**: `Description` (`description`), `Url` (`url`), `&End` (`T`).
