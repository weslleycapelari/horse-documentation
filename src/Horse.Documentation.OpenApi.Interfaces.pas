unit Horse.Documentation.OpenApi.Interfaces;

interface

uses
  System.JSON,
  System.Rtti,
  Horse.Documentation.OpenApi.Types;

type
  IInfo = interface;
  IContact = interface;
  ILicense = interface;
  ILogo = interface;
  IServer<T> = interface;
  IServerVariable<T> = interface;
  IPathItem<T> = interface;
  IOperation<T> = interface;
  IResponses<T> = interface;
  IComponents = interface;
  ISchema = TJSONValue;
  IDiscriminator = interface;
  IXML = interface;
  IMediaType<T> = interface;
  IEncoding<T> = interface;
  IResponse<T> = interface;
  IParameter<T> = interface;
  IExample<T> = interface;
  IRequestBody<T> = interface;
  ISecurityRequirement<T> = interface;
  IHeader<T> = interface;
  ISecurityScheme = interface;
  IOAuthFlows = interface;
  ILink<T> = interface;
  ITag = interface;
  ITagGroup = interface;
  ICodeSample<T> = interface;
  IExternalDocumentation<T> = interface;

  /// <summary>
  ///   Interface base para todas as interfaces do modelo OpenAPI.
  ///   Implementa a funcionalidade comum de "Specification Extensions" (campos x-...).
  /// </summary>
  IOpenApiAncestor = interface(IInterface)
    ['{7BB3A54B-97E3-4556-917E-6A1AACA2D43F}']
    /// <summary>
    ///   Um mapa de nomes de extensão para seus valores.
    ///   Permite que dados customizados sejam adicionados à especificação.
    /// </summary>
    function Extensions: TOpenApiMap<TJSONValue, IOpenApiAncestor>;

    /// <summary>Realiza a exportação do objeto para uma string do valor json</summary>
    function ToJson: TJSONObject;
  end;

  /// <summary>Este é a interface raiz de uma Descrição OpenAPI.</summary>
  IOpenApi = interface(IOpenApiAncestor)
    ['{923B615D-D6FA-44F0-9DE7-B0B519C5F278}']
    /// <summary>
    ///   REQUIRED. Esta string DEVE ser o número da versão da Especificação
    ///   OpenAPI que o Documento OpenAPI utiliza. O campo `openapi` DEVE ser
    ///   usado por ferramentas para interpretar o Documento OpenAPI.
    ///   Isso não está relacionado à string `info.version` da API.
    /// </summary>
    function Openapi: string; overload;
    function Openapi(const AValue: string): IOpenApi; overload;

    /// <summary>
    ///   REQUIRED. Fornece metadados sobre a API. Os metadados PODEM ser
    ///   usados por ferramentas conforme necessário.
    /// </summary>
    function Info: IInfo;

    /// <summary>
    ///   O valor padrão para a palavra-chave `$schema` dentro de
    ///   Schema Objects contidos neste documento OAS.
    ///   Isto DEVE estar no formato de uma URI.
    /// </summary>
    function JsonSchemaDialect: string; overload;
    function JsonSchemaDialect(const AValue: string): IOpenApi; overload;

    /// <summary>
    ///   Um array de Server Objects, que fornecem informações de conectividade
    ///   para um servidor alvo. Se o campo `servers` não for fornecido, ou for
    ///   um array vazio, o valor padrão seria um Server Object com um valor de `url` de `/`.
    /// </summary>
    function Servers: TOpenApiList<IServer<IOpenApi>, IOpenApi>;

    /// <summary>Os caminhos e operações disponíveis para a API.</summary>
    function Paths: TOpenApiMap<IPathItem<IOpenApi>, IOpenApi>;

    /// <summary>
    ///   Os webhooks de entrada que PODEM ser recebidos como parte desta API e
    ///   que o consumidor da API PODE escolher implementar. O nome da chave é uma
    ///   string única para se referir a cada webhook.
    /// </summary>
    function Webhooks: TOpenApiMap<IPathItem<IOpenApi>, IOpenApi>;

    /// <summary>Um elemento para conter vários Objetos para a Descrição OpenAPI.</summary>
    function Components: IComponents;

    /// <summary>
    ///   Uma declaração de quais mecanismos de segurança podem ser usados em
    ///   toda a API. A lista de valores inclui Security Requirement Objects
    ///   alternativos que podem ser usados.
    /// </summary>
    function Security: TOpenApiList<ISecurityRequirement<IOpenApi>, IOpenApi>;

    /// <summary>
    ///   Uma lista de tags usadas pela Descrição OpenAPI com metadados adicionais.
    ///   A ordem das tags pode ser usada para refletir sua ordem pelas ferramentas
    ///   de parsing. Cada nome de tag na lista DEVE ser único.
    /// </summary>
    function Tags: TOpenApiList<ITag, IOpenApi>;

    /// <summary>
    ///   Grupos de tags do Redoc. Permite agrupar tags para melhor organização
    ///   da documentação (extensão x-tagGroups do Redoc).
    /// </summary>
    function TagGroups: TOpenApiList<ITagGroup, IOpenApi>;

    /// <summary>Documentação externa adicional.</summary>
    function ExternalDocs: IExternalDocumentation<IOpenApi>;
  end;

  /// <summary>
  ///   O objeto fornece metadados sobre a API. Os metadados PODEM ser usados
  ///   pelos clientes se necessário, e PODEM ser apresentados em ferramentas de
  ///   edição ou geração de documentação por conveniência.
  /// </summary>
  IInfo = interface(IOpenApiAncestor)
    ['{97248BEA-0621-489A-9F05-371EFFFD1BE2}']
    /// <summary>REQUIRED. O título da API.</summary>
    function Title: string; overload;
    function Title(const AValue: string): IInfo; overload;

    /// <summary>Um breve resumo da API.</summary>
    function Summary: string; overload;
    function Summary(const AValue: string): IInfo; overload;

    /// <summary>
    ///   Uma descrição da API. A sintaxe CommonMark PODE ser usada
    ///   para representação de texto rico.
    /// </summary>
    function Description: string; overload;
    function Description(const AValue: string): IInfo; overload;

    /// <summary>
    ///   Uma URI para os Termos de Serviço da API.
    ///   Isto DEVE estar no formato de uma URI.
    /// </summary>
    function TermsOfService: string; overload;
    function TermsOfService(const AValue: string): IInfo; overload;

    /// <summary>As informações de contato para a API exposta.</summary>
    function Contact: IContact;

    /// <summary>As informações de licença para a API exposta.</summary>
    function License: ILicense;

    /// <summary>Logo da API (extensão x-logo do Redoc).</summary>
    function Logo: ILogo;

    /// <summary>
    ///   REQUIRED. A versão do Documento OpenAPI (que é distinta da versão
    ///   da Especificação OpenAPI ou da versão da API sendo descrita).
    /// </summary>
    function Version: string; overload;
    function Version(const AValue: string): IInfo; overload;

    /// <summary>Retorna para o objeto anterior.</summary>
    function &End: IOpenApi;
  end;

  /// <summary>Informações de contato para a API exposta.</summary>
  IContact = interface(IOpenApiAncestor)
    ['{944F4590-19E1-456D-8E2E-AE1DFB46BC4D}']
    /// <summary>O nome de identificação da pessoa/organização de contato.</summary>
    function Name: string; overload;
    function Name(const AValue: string): IContact; overload;

    /// <summary>
    ///   A URI para as informações de contato.
    ///   Isto DEVE estar no formato de uma URI.
    /// </summary>
    function Url: string; overload;
    function Url(const AValue: string): IContact; overload;

    /// <summary>
    ///   O endereço de e-mail da pessoa/organização de contato.
    ///   Isto DEVE estar no formato de um endereço de e-mail.
    /// </summary>
    function Email: string; overload;
    function Email(const AValue: string): IContact; overload;

    /// <summary>Retorna para o objeto anterior.</summary>
    function &End: IInfo;
  end;

  /// <summary>Informações de licença para a API exposta.</summary>
  ILicense = interface(IOpenApiAncestor)
    ['{27C15FFB-8150-43A5-B982-7916EF0DB591}']
    /// <summary>REQUIRED. O nome da licença usada para a API</summary>
    function Name: string; overload;
    function Name(const AValue: string): ILicense; overload;

    /// <summary>
    ///   Uma expressão de licença SPDX para a API. O campo `identifier`
    ///   é mutuamente exclusivo do campo `url`.
    /// </summary>
    function Identifier: string; overload;
    function Identifier(const AValue: string): ILicense; overload;

    /// <summary>
    ///   Uma URI para a licença usada para a API. Isto DEVE estar no formato
    ///   de uma URI. O campo `url` é mutuamente exclusivo do campo `identifier`.
    /// </summary>
    function Url: string; overload;
    function Url(const AValue: string): ILicense; overload;

    /// <summary>Retorna para o objeto anterior.</summary>
    function &End: IInfo;
  end;

  /// <summary>Um objeto representando um Servidor.</summary>
  IServer<T> = interface(IOpenApiAncestor)
    ['{06E202C2-E3EA-467E-81D8-4192EE2953F7}']
    /// <summary>
    ///   REQUIRED. Uma URL para o host de destino. Esta URL suporta Variáveis de
    ///   Servidor e PODE ser relativa, para indicar que a localização do host é
    ///   relativa à localização onde o documento que contém o Server Object está
    ///   sendo servido. Substituições de variáveis serão feitas quando uma
    ///   variável for nomeada entre {chaves}.
    /// </summary>
    function Url: string; overload;
    function Url(const AValue: string): IServer<T>; overload;

    /// <summary>
    ///   Uma string opcional descrevendo o host designado pela URL.
    ///   A sintaxe CommonMark PODE ser usada para representação de texto rico.
    /// </summary>
    function Description: string; overload;
    function Description(const AValue: string): IServer<T>; overload;

    /// <summary>
    ///   Um mapa entre um nome de variável e seu valor. O valor é usado para
    ///   substituição no template de URL do servidor.
    /// </summary>
    function Variables: TOpenApiMap<IServerVariable<T>, IServer<T>>;

    /// <summary>Retorna para o objeto anterior.</summary>
    function &End: T;
  end;

  /// <summary>
  ///   Um objeto representando uma Variável de Servidor para substituição
  ///   no template de URL do servidor.
  /// </summary>
  IServerVariable<T> = interface(IOpenApiAncestor)
    ['{07910CC7-8542-4647-AE59-9ED2C9537C44}']
    /// <summary>
    ///   Uma enumeração de valores de string a serem usados se as opções de
    ///   substituição forem de um conjunto limitado. O array NÃO DEVE estar vazio.
    /// </summary>
    function &Enum: TOpenApiList<string, IServerVariable<T>>;

    /// <summary>
    ///   REQUIRED. O valor padrão a ser usado para substituição, que DEVE ser
    ///   enviado se um valor alternativo não for fornecido. Se o `enum` for
    ///   definido, o valor DEVE existir nos valores do enum.
    /// </summary>
    function &Default: string; overload;
    function &Default(const AValue: string): IServerVariable<T>; overload;

    /// <summary>
    ///   Uma descrição opcional para a variável do servidor. A sintaxe CommonMark
    ///   PODE ser usada para representação de texto rico.
    /// </summary>
    function Description: string; overload;
    function Description(const AValue: string): IServerVariable<T>; overload;

    /// <summary>Retorna para o objeto anterior.</summary>
    function &End: IServer<T>;
  end;

  /// <summary>
  ///   Contém um conjunto de objetos reutilizáveis para diferentes aspectos do OAS.
  ///   Todos os objetos definidos aqui não têm efeito na API a menos que sejam
  ///   explicitamente referenciados de fora do Components Object.
  /// </summary>
  IComponents = interface(IOpenApiAncestor)
    ['{D7383B27-1D05-43ED-9BF7-BCEC70D502DE}']
    /// <summary>Um objeto para conter Schema Objects reutilizáveis.</summary>
    function Schemas: TOpenApiMap<ISchema, IComponents>;

    /// <summary>Um objeto para conter Response Objects reutilizáveis.</summary>
    function Responses: TOpenApiMap<IResponse<IComponents>, IComponents>;

    /// <summary>Um objeto para conter Parameter Objects reutilizáveis.</summary>
    function Parameters: TOpenApiMap<IParameter<IComponents>, IComponents>;

    /// <summary>Um objeto para conter Example Objects reutilizáveis.</summary>
    function Examples: TOpenApiMap<IExample<IComponents>, IComponents>;

    /// <summary>Um objeto para conter Request Body Objects reutilizáveis.</summary>
    function RequestBodies: TOpenApiMap<IRequestBody<IComponents>, IComponents>;

    /// <summary>Um objeto para conter Header Objects reutilizáveis.</summary>
    function Headers: TOpenApiMap<IHeader<IComponents>, IComponents>;

    /// <summary>Um objeto para conter Security Scheme Objects reutilizáveis.</summary>
    function SecuritySchemes: TOpenApiMap<ISecurityScheme, IComponents>;

    /// <summary>Um objeto para conter Link Objects reutilizávei</summary>
    function Links: TOpenApiMap<ILink<IComponents>, IComponents>;

    /// <summary>Um objeto para conter Callback Objects reutilizáveis.</summary>
    function Callbacks: TOpenApiMap<IPathItem<IComponents>, IComponents>;

    /// <summary>Um objeto para conter Path Item Objects reutilizáveis.</summary>
    function PathItems: TOpenApiMap<IPathItem<IComponents>, IComponents>;

    /// <summary>Retorna para o objeto anterior.</summary>
    function &End: IOpenApi;
  end;

  /// <summary>
  ///   Descreve as operações disponíveis em um único caminho.
  ///   Um Path Item PODE estar vazio, devido a restrições de ACL. O caminho
  ///   em si ainda é exposto, mas os visualizadores de documentação não saberão
  ///   quais operações e parâmetros estão disponíveis.
  /// </summary>
  IPathItem<T> = interface(IOpenApiAncestor)
    ['{CC112B05-5ADD-4C24-A0E7-D652D6158065}']
    /// <summary>
    ///   (Mapeia para o campo '$ref') Permite uma definição referenciada
    ///   deste item de caminho. O valor DEVE estar no formato de uma URI, e a
    ///   estrutura referenciada DEVE ser na forma de um Path Item Object.
    /// </summary>
    function Ref: string; overload;
    function Ref(const AValue: string): IPathItem<T>; overload;

    /// <summary>
    ///   Um resumo opcional em string, destinado a se aplicar a todas as
    ///   operações neste caminho.
    /// </summary>
    function Summary: string; overload;
    function Summary(const AValue: string): IPathItem<T>; overload;

    /// <summary>
    ///   Uma descrição opcional em string, destinada a se aplicar a todas as
    ///   operações neste caminho. A sintaxe CommonMark PODE ser usada.
    /// </summary>
    function Description: string; overload;
    function Description(const AValue: string): IPathItem<T>; overload;

    /// <summary>Uma definição de uma operação GET neste caminho.</summary>
    function Get: IOperation<IPathItem<T>>;

    /// <summary>Uma definição de uma operação PUT neste caminho.</summary>
    function Put: IOperation<IPathItem<T>>;

    /// <summary>Uma definição de uma operação POST neste caminho.</summary>
    function Post: IOperation<IPathItem<T>>;

    /// <summary>Uma definição de uma operação DELETE neste caminho.</summary>
    function &Delete: IOperation<IPathItem<T>>;

    /// <summary>Uma definição de uma operação OPTIONS neste caminho.</summary>
    function Options: IOperation<IPathItem<T>>;

    /// <summary>Uma definição de uma operação HEAD neste caminho.</summary>
    function Head: IOperation<IPathItem<T>>;

    /// <summary>Uma definição de uma operação PATCH neste caminho.</summary>
    function Patch: IOperation<IPathItem<T>>;

    /// <summary>Uma definição de uma operação TRACE neste caminho.</summary>
    function Trace: IOperation<IPathItem<T>>;

    /// <summary>
    ///   Um array `servers` alternativo para servir todas as operações neste
    ///   caminho. Se um array `servers` for especificado no nível do OpenAPI
    ///   Object, ele será sobrescrito por este valor.
    /// </summary>
    function Servers: TOpenApiList<IServer<IPathItem<T>>, IPathItem<T>>;

    /// <summary>
    ///   Uma lista de parâmetros que são aplicáveis a todas as operações
    ///   descritas sob este caminho. Estes parâmetros podem ser sobrescritos
    ///   no nível da operação, mas não podem ser removidos lá. A lista PODE
    ///   usar o Reference Object para vincular a parâmetros definidos nos
    ///   `components`.
    /// </summary>
    function Parameters: TOpenApiList<IParameter<IPathItem<T>>, IPathItem<T>>;

    /// <summary>Retorna para o objeto anterior.</summary>
    function &End: T;
  end;

  /// <summary>Descreve uma única operação de API em um caminho.</summary>
  IOperation<T> = interface(IOpenApiAncestor)
    ['{929B89FA-01F8-4BA8-B5A3-67334281DCF4}']
    /// <summary>
    ///   Uma lista de tags para controle da documentação da API. As tags podem
    ///   ser usadas para agrupamento lógico de operações por recursos ou
    ///   qualquer outro qualificador.
    /// </summary>
    function Tags: TOpenApiList<string, IOperation<T>>;

    /// <summary>Um breve resumo do que a operação faz.</summary>
    function Summary: string; overload;
    function Summary(const AValue: string): IOperation<T>; overload;

    /// <summary>
    ///   Uma explicação detalhada do comportamento da operação. A sintaxe
    ///   CommonMark PODE ser usada para representação de texto rico.
    /// </summary>
    function Description: string; overload;
    function Description(const AValue: string): IOperation<T>; overload;

    /// <summary>Documentação externa adicional para esta operação.</summary>
    function ExternalDocs: IExternalDocumentation<IOperation<T>>;

    /// <summary>
    ///   String única usada para identificar a operação. O id DEVE ser único
    ///   entre todas as operações descritas na API. O valor de operationId é
    ///   case-sensitive.
    /// </summary>
    function OperationId: string; overload;
    function OperationId(const AValue: string): IOperation<T>; overload;

    /// <summary>
    ///   Uma lista de parâmetros aplicáveis a esta operação. Se um parâmetro
    ///   já estiver definido no Path Item, a nova definição o sobrescreverá.
    /// </summary>
    function Parameters: TOpenApiList<IParameter<IOperation<T>>, IOperation<T>>;

    /// <summary>O corpo da requisição aplicável a esta operação.</summary>
    function RequestBody: IRequestBody<IOperation<T>>;

    /// <summary>
    ///   A lista de respostas possíveis conforme são retornadas da execução
    ///   desta operação.
    /// </summary>
    function Responses: IResponses<IOperation<T>>;

    /// <summary>
    ///   Um mapa de possíveis callbacks "out-of-band" relacionados à operação
    ///   pai. A chave é um identificador único para o Callback Object.
    /// </summary>
//    function Callbacks: TOpenApiMap<IPathItem<IOperation<T>>, IOperation<T>>;

    /// <summary>
    ///   Declara esta operação como obsoleta. Consumidores DEVEM evitar o uso
    ///   da operação declarada. O valor padrão é `false`.
    /// </summary>
    function Deprecated: Boolean; overload;
    function Deprecated(const AValue: Boolean): IOperation<T>; overload;

    /// <summary>
    ///   Uma declaração de quais mecanismos de segurança podem ser usados para
    ///   esta operação. Esta definição sobrescreve qualquer `security`
    ///   declarado no nível superior.
    /// </summary>
    function Security: TOpenApiList<ISecurityRequirement<IOperation<T>>, IOperation<T>>;

    /// <summary>
    ///   Um array `servers` alternativo para servir esta operação. Se um array
    ///   `servers` for especificado no Path Item Object ou no OpenAPI Object,
    ///   ele será sobrescrito por este valor.
    /// </summary>
    function Servers: TOpenApiList<IServer<IOperation<T>>, IOperation<T>>;
    
    /// <summary>Exemplos de código para esta operação (extensão x-code-samples do Redoc).</summary>
    function CodeSamples: TOpenApiList<ICodeSample<IOperation<T>>, IOperation<T>>;

    /// <summary>Retorna para o objeto anterior.</summary>
    function &End: T;
  end;

  /// <summary>Permite referenciar um recurso externo para documentação estendida.</summary>
  IExternalDocumentation<T> = interface(IOpenApiAncestor)
    ['{20AB5D24-5935-445C-956A-1A7180601631}']
    /// <summary>
    ///   Uma descrição da documentação de destino. A sintaxe CommonMark PODE
    ///   ser usada para representação de texto rico.
    /// </summary>
    function Description: string; overload;
    function Description(const AValue: string): IExternalDocumentation<T>; overload;

    /// <summary>
    ///   REQUIRED. A URI para a documentação de destino.
    ///   Isto DEVE estar no formato de uma URI.
    /// </summary>
    function Url: string; overload;
    function Url(const AValue: string): IExternalDocumentation<T>; overload;

    /// <summary>Retorna para o objeto anterior.</summary>
    function &End: T;
  end;

  /// <summary>
  ///   Descreve um único parâmetro de operação.
  ///   Um parâmetro único é definido por uma combinação de nome e localização (`in`).
  /// </summary>
  IParameter<T> = interface(IOpenApiAncestor)
    ['{16C19AC0-94A5-49E5-9E39-DCD45D6BF125}']
    /// <summary>
    ///   REQUIRED. O nome do parâmetro. Nomes de parâmetros são case-sensitive.
    ///   - Se `in` for "path", `name` DEVE corresponder a uma expressão de template no caminho.
    ///   - Se `in` for "header" e `name` for "Accept", "Content-Type" ou "Authorization",
    ///     a definição do parâmetro DEVE ser ignorada.
    /// </summary>
    function Name: string; overload;
    function Name(const AValue: string): IParameter<T>; overload;

    /// <summary>
    ///   REQUIRED. A localização do parâmetro.
    ///   Valores possíveis são "query", "header", "path" ou "cookie".
    /// </summary>
    function &In: TParameterLocation; overload;
    function &In(const AValue: TParameterLocation): IParameter<T>; overload;

    /// <summary>
    ///   Uma breve descrição do parâmetro. Pode conter exemplos de uso.
    ///   A sintaxe CommonMark PODE ser usada.
    /// </summary>
    function Description: string; overload;
    function Description(const AValue: string): IParameter<T>; overload;

    /// <summary>
    ///   Determina se este parâmetro é obrigatório. Se a localização for "path",
    ///   este campo é REQUIRED e seu valor DEVE ser `true`. Caso contrário, o
    ///   valor padrão é `false`.
    /// </summary>
    function Required: Boolean; overload;
    function Required(const AValue: Boolean): IParameter<T>; overload;

    /// <summary>
    ///   Especifica que um parâmetro é obsoleto e DEVE ser descontinuado.
    ///   O valor padrão é `false`.
    /// </summary>
    function Deprecated: Boolean; overload;
    function Deprecated(const AValue: Boolean): IParameter<T>; overload;

    /// <summary>
    ///   Se `true`, clientes PODEM passar um valor de string de comprimento zero.
    ///   Válido apenas para parâmetros `query`. O valor padrão é `false`.
    ///   O uso deste campo NÃO é RECOMENDADO.
    /// </summary>
    function AllowEmptyValue: Boolean; overload;
    function AllowEmptyValue(const AValue: Boolean): IParameter<T>; overload;

    /// <summary>
    ///   Descreve como o valor do parâmetro será serializado.
    ///   Padrões (baseado em `in`): "query" -> "form"; "path" -> "simple";
    ///   "header" -> "simple"; "cookie" -> "form".
    /// </summary>
    function Style: TParameterStyle; overload;
    function Style(const AValue: TParameterStyle): IParameter<T>; overload;

    /// <summary>
    ///   Quando `true`, valores de `array` ou `object` geram parâmetros separados.
    ///   Padrão é `true` para `style`="form", e `false` para os outros.
    /// </summary>
    function Explode: Boolean; overload;
    function Explode(const AValue: Boolean): IParameter<T>; overload;

    /// <summary>
    ///   Permite que caracteres reservados definidos por RFC6570 passem sem codificação.
    ///   Aplica-se apenas a parâmetros `query`. O valor padrão é `false`.
    /// </summary>
    function AllowReserved: Boolean; overload;
    function AllowReserved(const AValue: Boolean): IParameter<T>; overload;

    /// <summary>
    ///   O schema que define o tipo usado para o parâmetro.
    ///   Mutuamente exclusivo com o campo `content`.
    /// </summary>
    function Schema: ISchema; overload;
    function Schema(const AValue: ISchema): IParameter<T>; overload;

    /// <summary>Exemplo do valor potencial do parâmetro. Mutuamente exclusivo com `examples`.</summary>
    function Example: TJSONValue; overload;
    function Example(const AValue: TJSONValue): IParameter<T>; overload;

    /// <summary>Exemplos do valor potencial do parâmetro. Mutuamente exclusivo com `example`.</summary>
    function Examples: TOpenApiMap<IExample<IParameter<T>>, IParameter<T>>;

    /// <summary>
    ///   Um mapa contendo as representações para o parâmetro. A chave é o
    ///   media type. O mapa DEVE conter apenas uma entrada.
    ///   Mutuamente exclusivo com o campo `schema`.
    /// </summary>
    function Content: TOpenApiMap<IMediaType<IParameter<T>>, IParameter<T>>;

    /// <summary>Retorna para o objeto anterior.</summary>
    function &End: T;
  end;

  /// <summary>Descreve um único corpo de requisição.</summary>
  IRequestBody<T> = interface(IOpenApiAncestor)
    ['{08CD08D9-EE62-4AD6-BFEC-1A2A63CA44EF}']
    /// <summary>
    ///   Uma breve descrição do corpo da requisição. Pode conter exemplos de uso.
    ///   A sintaxe CommonMark PODE ser usada.
    /// </summary>
    function Description: string; overload;
    function Description(const AValue: string): IRequestBody<T>; overload;

    /// <summary>
    ///   REQUIRED. O conteúdo do corpo da requisição. A chave é um media type ou
    ///   uma faixa de media types e o valor o descreve. Para requisições que
    ///   correspondem a múltiplas chaves, apenas a chave mais específica é aplicável.
    /// </summary>
    function Content: TOpenApiMap<IMediaType<IRequestBody<T>>, IRequestBody<T>>;

    /// <summary>Determina se o corpo da requisição é obrigatório na requisição. O padrão é `false`.</summary>
    function Required: Boolean; overload;
    function Required(const AValue: Boolean): IRequestBody<T>; overload;

    /// <summary>Retorna para o objeto anterior.</summary>
    function &End: T;
  end;

  /// <summary>Cada Media Type Object fornece schema e exemplos para o media type identificado por sua chave.</summary>
  IMediaType<T> = interface(IOpenApiAncestor)
    ['{25508D82-EE7A-4EF2-88F0-41EE5C0C31FD}']
    /// <summary>O schema que define o conteúdo da requisição, resposta, parâmetro ou header.</summary>
    function Schema: ISchema; overload;
    function Schema(const AValue: ISchema): IMediaType<T>; overload;

    /// <summary>
    ///   Exemplo do media type. Mutuamente exclusivo com `examples`.
    ///   Se presente, SOBRESCREVE qualquer `example` no schema.
    /// </summary>
    function Example: TJSONValue; overload;
    function Example(const AValue: TJSONValue): IMediaType<T>; overload;

    /// <summary>
    ///   Exemplos do media type. Mutuamente exclusivo com `example`.
    ///   Se presente, SOBRESCREVE qualquer `example` no schema.
    /// </summary>
    function Examples: TOpenApiMap<IExample<IMediaType<T>>, IMediaType<T>>;

    /// <summary>
    ///   Um mapa entre um nome de propriedade e sua informação de codificação.
    ///   A chave DEVE existir no schema como uma propriedade. O campo `encoding`
    ///   DEVE ser aplicado apenas a Request Body Objects quando o media type for
    ///   `multipart` ou `application/x-www-form-urlencoded`.
    /// </summary>
    function Encoding: TOpenApiMap<IEncoding<IMediaType<T>>, IMediaType<T>>;

    /// <summary>Retorna para o objeto anterior.</summary>
    function &End: T;
  end;

  /// <summary>Uma única definição de codificação aplicada a uma única propriedade de schema.</summary>
  IEncoding<T> = interface(IOpenApiAncestor)
    ['{2DECD134-8FFE-4621-A2CB-5E81A5CE2140}']
    /// <summary>
    ///   O Content-Type para codificar uma propriedade específica. O valor é uma
    ///   lista separada por vírgulas de media types específicos ou curingas.
    ///   O valor padrão depende do tipo da propriedade.
    /// </summary>
    function ContentType: string; overload;
    function ContentType(const AValue: string): IEncoding<T>; overload;

    /// <summary>
    ///   Um mapa que permite que informações adicionais sejam fornecidas como
    ///   headers. Este campo DEVE ser ignorado se o media type do corpo da
    ///   requisição não for `multipart`.
    /// </summary>
//    function Headers: TOpenApiMap<IHeader<T>, IEncoding<T>>;

    /// <summary>
    ///   Descreve como um valor de propriedade específico será serializado.
    ///   Segue os mesmos valores que os parâmetros `query`. DEVE ser ignorado
    ///   se o media type não for `application/x-www-form-urlencoded`.
    /// </summary>
    function Style: TParameterStyle; overload;
    function Style(const AValue: TParameterStyle): IEncoding<T>; overload;

    /// <summary>
    ///   Quando `true`, valores de `array` ou `object` geram parâmetros
    ///   separados. O padrão é `true` para `style`="form", e `false` para os outros.
    ///   DEVE ser ignorado se o media type não for `application/x-www-form-urlencoded`.
    /// </summary>
    function Explode: Boolean; overload;
    function Explode(const AValue: Boolean): IEncoding<T>; overload;

    /// <summary>
    ///   Quando `true`, os valores dos parâmetros são serializados usando
    ///   expansão reservada (RFC6570). O padrão é `false`. DEVE ser ignorado
    ///   se o media type não for `application/x-www-form-urlencoded`.
    /// </summary>
    function AllowReserved: Boolean; overload;
    function AllowReserved(const AValue: Boolean): IEncoding<T>; overload;

    /// <summary>Retorna para o objeto anterior.</summary>
    function &End: T;
  end;

  /// <summary>Descreve uma única resposta de uma operação de API.</summary>
  IResponse<T> = interface(IOpenApiAncestor)
    ['{F008308F-9B49-4EA4-BF63-44CE5AC56613}']
    /// <summary>
    ///   REQUIRED. Uma descrição da resposta. A sintaxe CommonMark
    ///   PODE ser usada.
    /// </summary>
    function Description: string; overload;
    function Description(const AValue: string): IResponse<T>; overload;

    /// <summary>
    ///   Mapeia um nome de header para sua definição. Nomes de header são
    ///   case-insensitive. Se um header de resposta for definido com o nome
    ///   "Content-Type", ele DEVE ser ignorado.
    /// </summary>
    function Headers: TOpenApiMap<IHeader<IResponse<T>>, IResponse<T>>;

    /// <summary>Um mapa contendo descrições dos possíveis payloads de resposta. A chave é um media type.</summary>
    function Content: TOpenApiMap<IMediaType<IResponse<T>>, IResponse<T>>;

    /// <summary>
    ///   Um mapa de links de operações que podem ser seguidos a partir da resposta.
    ///   A chave do mapa é um nome curto para o link.
    /// </summary>
    function Links: TOpenApiMap<ILink<IResponse<T>>, IResponse<T>>;

    /// <summary>Retorna para o objeto anterior.</summary>
    function &End: T;
  end;

  /// <summary>
  ///   Um contêiner para as respostas esperadas de uma operação.
  ///   O contêiner mapeia um código de resposta HTTP para a resposta esperada.
  /// </summary>
  IResponses<T> = interface(IOpenApiAncestor)
    ['{664D48C4-6A68-405E-9EB1-EC26002C268D}']
    /// <summary>
    ///   A documentação de respostas que não sejam as declaradas para códigos
    ///   de resposta HTTP específicos. Use este campo para cobrir respostas
    ///   não declaradas.
    /// </summary>
    function &Default: IResponse<IResponses<T>>;

    /// <summary>
    ///   Mapeia um código de status HTTP (ou um intervalo como '2XX') para a
    ///   sua definição de resposta.
    /// </summary>
    function StatusCodes: TOpenApiMap<IResponse<IResponses<T>>, IResponses<T>>;

    /// <summary>Retorna para o objeto anterior.</summary>
    function &End: T;
  end;

  /// <summary>Agrupa um valor de exemplo interno ou externo com metadados básicos de resumo e descrição.</summary>
  IExample<T> = interface(IOpenApiAncestor)
    ['{25EF470D-559B-4D93-BCB1-7712E04A2A40}']
    /// <summary>Breve descrição para o exemplo.</summary>
    function Summary: string; overload;
    function Summary(const AValue: string): IExample<T>; overload;

    /// <summary>Longa descrição para o exemplo. A sintaxe CommonMark PODE ser usada.</summary>
    function Description: string; overload;
    function Description(const AValue: string): IExample<T>; overload;

    /// <summary>Exemplo literal embutido. O campo `value` e o campo `externalValue` são mutuamente exclusivos.</summary>
    function Value: TJSONValue; overload;
    function Value(const AValue: TJSONValue): IExample<T>; overload;

    /// <summary>
    ///   Uma URI que identifica o exemplo literal. O campo `value` e o campo
    ///   `externalValue` são mutuamente exclusivos.
    /// </summary>
    function ExternalValue: string; overload;
    function ExternalValue(const AValue: string): IExample<T>; overload;

    /// <summary>Retorna para o objeto anterior.</summary>
    function &End: T;
  end;

  /// <summary>
  ///   O Link Object representa um possível link em tempo de design para uma
  ///   resposta. A presença de um link não garante a capacidade do chamador de
  ///   invocá-lo com sucesso, mas fornece uma relação conhecida e um mecanismo
  ///   de travessia entre respostas e outras operações.
  /// </summary>
  ILink<T> = interface(IOpenApiAncestor)
    ['{CA398A79-6F4C-42BD-A961-78A08DDED763}']
    /// <summary>
    ///   Uma referência URI a uma operação OAS. Este campo é mutuamente exclusivo
    ///   do campo `operationId`, e DEVE apontar para um Operation Object.
    /// </summary>
    function OperationRef: string; overload;
    function OperationRef(const AValue: string): ILink<T>; overload;

    /// <summary>
    ///   O nome de uma operação OAS existente e resolúvel, conforme definido
    ///   com um `operationId` único. Este campo é mutuamente exclusivo do
    ///   campo `operationRef`.
    /// </summary>
    function OperationId: string; overload;
    function OperationId(const AValue: string): ILink<T>; overload;

    /// <summary>
    ///   Um mapa que representa parâmetros a serem passados para uma operação.
    ///   A chave é o nome do parâmetro, enquanto o valor pode ser uma constante
    ///   ou uma expressão a ser avaliada e passada para a operação vinculada.
    /// </summary>
    function Parameters: TOpenApiMap<string, ILink<T>>;

    /// <summary>
    ///   Um valor literal ou uma expressão para usar como corpo da requisição
    ///   ao chamar a operação de destino.
    /// </summary>
    function RequestBody: TJSONValue; overload;
    function RequestBody(const AValue: TJSONValue): ILink<T>; overload;

    /// <summary>Uma descrição do link. A sintaxe CommonMark PODE ser usada.</summary>
    function Description: string; overload;
    function Description(const AValue: string): ILink<T>; overload;

    /// <summary>Um objeto de servidor a ser usado pela operação de destino.</summary>
    function Server: IServer<ILink<T>>;

    /// <summary>Retorna para o objeto anterior.</summary>
    function &End: T;
  end;

  /// <summary>
  ///   Lista os esquemas de segurança necessários para executar uma operação.
  ///   Cada instância representa um objeto no array de segurança principal.
  /// </summary>
  ISecurityRequirement<T> = interface(IOpenApiAncestor)
    ['{E5F8C8A0-7B3A-4E1B-9A0B-9B4B1C5D7D3F}']
    /// <summary>
    ///   Define o nome do esquema de segurança para este requisito.
    /// </summary>
    /// <remarks>
    ///   O nome fornecido DEVE corresponder a um esquema de segurança
    ///   previamente declarado na seção `components/securitySchemes`.
    ///   Este nome se tornará a chave no objeto JSON gerado.
    ///   Exemplo: 'apiKey', 'petstore_auth'.
    /// </remarks>
    function SchemeName: string; overload;
    function SchemeName(const AValue: string): ISecurityRequirement<T>; overload;

    /// <summary>
    ///   Retorna uma lista para adicionar os escopos (scopes) necessários
    ///   para este esquema de segurança.
    /// </summary>
    /// <remarks>
    ///   - Para esquemas do tipo `oauth2` ou `openIdConnect`, esta é a lista de
    ///     nomes de escopos necessários (ex: 'read:pets', 'write:pets').
    ///   - Para outros tipos de esquema (como 'apiKey' ou 'http'), a
    ///     especificação determina que a lista deve existir, mas seu conteúdo não
    ///     é definido. Nesses casos, a lista geralmente fica vazia.
    /// </remarks>
    function Scopes: TOpenApiList<string, ISecurityRequirement<T>>;

    /// <summary>Retorna para o objeto anterior (a lista de requisitos).</summary>
    function &End: T;
  end;

  /// <summary>Descreve um único header para respostas HTTP e para partes individuais em representações `multipart`.</summary>
  IHeader<T> = interface(IOpenApiAncestor)
    ['{27292B69-44B4-4872-A0E3-3B945C8B637B}']
    /// <summary>
    ///   Uma breve descrição do header. Pode conter exemplos de uso.
    ///   A sintaxe CommonMark PODE ser usada.
    /// </summary>
    function Description: string; overload;
    function Description(const AValue: string): IHeader<T>; overload;

    /// <summary>Determina se este header é obrigatório. O valor padrão é `false`.</summary>
    function Required: Boolean; overload;
    function Required(const AValue: Boolean): IHeader<T>; overload;

    /// <summary>Especifica que o header é obsoleto e DEVE ser descontinuado. O valor padrão é `false`.</summary>
    function Deprecated: Boolean; overload;
    function Deprecated(const AValue: Boolean): IHeader<T>; overload;

    /// <summary>
    ///   Descreve como o valor do header será serializado. O valor padrão
    ///   (e único valor legal para headers) é "simple".
    /// </summary>
    function Style: TParameterStyle; overload;
    function Style(const AValue: TParameterStyle): IHeader<T>; overload;

    /// <summary>
    ///   Quando `true`, valores de `array` ou `object` geram um único header
    ///   com uma lista de valores separados por vírgula. O valor padrão é `false`.
    /// </summary>
    function Explode: Boolean; overload;
    function Explode(const AValue: Boolean): IHeader<T>; overload;

    /// <summary>
    ///   O schema que define o tipo usado para o header.
    ///   Mutuamente exclusivo com o campo `content`.
    /// </summary>
    function Schema: ISchema;

    /// <summary>Exemplo do valor potencial do header. Mutuamente exclusivo com `examples`.</summary>
    function Example: TJSONValue; overload;
    function Example(const AValue: TJSONValue): IHeader<T>; overload;

    /// <summary>Exemplos do valor potencial do header. Mutuamente exclusivo com `example`.</summary>
    function Examples: TOpenApiMap<IExample<IHeader<T>>, IHeader<T>>;

    /// <summary>
    ///   Um mapa contendo as representações para o header. A chave é o
    ///   media type. O mapa DEVE conter apenas uma entrada.
    ///   Mutuamente exclusivo com o campo `schema`.
    /// </summary>
    function Content: TOpenApiMap<IMediaType<IHeader<T>>, IHeader<T>>;

    /// <summary>Retorna para o objeto anterior.</summary>
    function &End: T;
  end;

  /// <summary>
  ///   Adiciona metadados a uma única tag que é usada pelo Operation Object.
  ///   Não é obrigatório ter um Tag Object por tag definida nas instâncias
  ///   do Operation Object.
  /// </summary>
  ITag = interface(IOpenApiAncestor)
    ['{B58BFAF7-C0FC-48D6-9687-27383C6F346E}']
    /// <summary>REQUIRED. O nome da tag.</summary>
    function Name: string; overload;
    function Name(const AValue: string): ITag; overload;

    /// <summary>
    ///   Uma descrição para a tag. A sintaxe CommonMark PODE ser usada
    ///   para representação de texto rico.
    /// </summary>
    function Description: string; overload;
    function Description(const AValue: string): ITag; overload;

    /// <summary>Nome de exibição alternativo para a tag (extensão x-displayName do Redoc).</summary>
    function DisplayName: string; overload;
    function DisplayName(const AValue: string): ITag; overload;

    /// <summary>Documentação externa adicional para esta tag.</summary>
    function ExternalDocs: IExternalDocumentation<ITag>;

    /// <summary>Retorna para o objeto anterior.</summary>
    function &End: IOpenApi;
  end;

  /// <summary>
  ///   Quando corpos de requisição ou payloads de resposta podem ser um de
  ///   vários schemas diferentes, um Discriminator Object dá uma dica sobre o
  ///   schema esperado do documento.
  /// </summary>
  IDiscriminator = interface(IOpenApiAncestor)
    /// <summary>
    ///   REQUIRED. O nome da propriedade no payload que conterá o valor
    ///   discriminador. Esta propriedade DEVE ser obrigatória no schema do
    ///   payload, pois o comportamento quando a propriedade está ausente é
    ///   indefinido.
    /// </summary>
    function PropertyName: string; overload;
    function PropertyName(const AValue: string): IDiscriminator; overload;

    /// <summary>Um objeto para manter mapeamentos entre valores de payload e nomes de schema ou referências URI.</summary>
    function Mapping: TOpenApiMap<string, IDiscriminator>;

    /// <summary>Retorna para o objeto anterior.</summary>
    function &End: ISchema;
  end;

  /// <summary>Um objeto de metadados que permite definições de modelo XML mais refinadas.</summary>
  IXML = interface(IOpenApiAncestor)
    ['{01351F7C-D1BA-45E4-864A-73DDB8622511}']
    /// <summary>
    ///   Substitui o nome do elemento/atributo usado para a propriedade de
    ///   schema descrita.
    /// </summary>
    function Name: string; overload;
    function Name(const AValue: string): IXML; overload;

    /// <summary>
    ///   A URI da definição de namespace. O valor DEVE estar no formato de uma
    ///   URI não-relativa.
    /// </summary>
    function Namespace: string; overload;
    function Namespace(const AValue: string): IXML; overload;

    /// <summary>O prefixo a ser usado para o `name`.</summary>
    function Prefix: string; overload;
    function Prefix(const AValue: string): IXML; overload;

    /// <summary>
    ///   Declara se a definição da propriedade se traduz em um atributo em
    ///   vez de um elemento. O valor padrão é `false`.
    /// </summary>
    function Attribute: Boolean; overload;
    function Attribute(const AValue: Boolean): IXML; overload;

    /// <summary>
    ///   PODE ser usado apenas para uma definição de array. Significa se o
    ///   array é encapsulado (wrapped) ou não. O valor padrão é `false`.
    /// </summary>
    function Wrapped: Boolean; overload;
    function Wrapped(const AValue: Boolean): IXML; overload;

    /// <summary>Retorna para o objeto anterior.</summary>
    function &End: ISchema;
  end;

  /// <summary>Define um esquema de segurança que pode ser usado pelas operações.</summary>
  ISecurityScheme = interface(IOpenApiAncestor)
    ['{FC662617-B7E8-4221-AC7F-9CE34D0769F9}']
    /// <summary>
    ///   REQUIRED. O tipo do esquema de segurança. Valores válidos são:
    ///   "apiKey", "http", "mutualTLS", "oauth2", "openIdConnect".
    /// </summary>
    function &Type: TSecuritySchemeType; overload;
    function &Type(const AValue: TSecuritySchemeType): ISecurityScheme; overload;

    /// <summary>Uma descrição para o esquema de segurança. A sintaxe CommonMark PODE ser usada.</summary>
    function Description: string; overload;
    function Description(const AValue: string): ISecurityScheme; overload;

    /// <summary>(apiKey) REQUIRED. O nome do header, query ou parâmetro de cookie a ser usado.</summary>
    function Name: string; overload;
    function Name(const AValue: string): ISecurityScheme; overload;

    /// <summary>
    ///   (apiKey) REQUIRED. A localização da chave de API. Valores válidos são:
    ///   "query", "header" ou "cookie".
    /// </summary>
    function &In: TApiKeyLocation; overload;
    function &In(const AValue: TApiKeyLocation): ISecurityScheme; overload;

    /// <summary>
    ///   (http) REQUIRED. O nome do esquema de Autenticação HTTP a ser usado
    ///   no header Authorization. O valor é case-insensitive.
    /// </summary>
    function Scheme: string; overload;
    function Scheme(const AValue: string): ISecurityScheme; overload;

    /// <summary>
    ///   (http "bearer") Uma dica para o cliente sobre como o token bearer é
    ///   formatado. Primariamente para fins de documentação.
    /// </summary>
    function BearerFormat: string; overload;
    function BearerFormat(const AValue: string): ISecurityScheme; overload;

    /// <summary>
    ///   (oauth2) REQUIRED. Um objeto contendo informações de configuração para
    ///   os tipos de fluxo suportados.
    /// </summary>
    function Flows: IOAuthFlows;

    /// <summary>
    /// (openIdConnect) REQUIRED. URL "Well-known" para descobrir os metadados
    /// do provedor OpenID Connect.
    /// </summary>
    function OpenIdConnectUrl: string; overload;
    function OpenIdConnectUrl(const AValue: string): ISecurityScheme; overload;

    /// <summary>Retorna para o objeto anterior.</summary>
    function &End: IComponents;
  end;

  /// <summary>Detalhes de configuração para um fluxo OAuth suportado.</summary>
  IOAuthFlow = interface(IOpenApiAncestor)
    ['{3F6E2653-4077-48F7-9C15-DD62ACF6B1DD}']
    /// <summary>
    ///   REQUIRED (`implicit`, `authorizationCode`). A URL de autorização a ser
    ///   usada para este fluxo.
    /// </summary>
    function AuthorizationUrl: string; overload;
    function AuthorizationUrl(const AValue: string): IOAuthFlow; overload;

    /// <summary>
    ///   REQUIRED (`password`, `clientCredentials`, `authorizationCode`). A URL
    ///   do token a ser usada para este fluxo.
    /// </summary>
    function TokenUrl: string; overload;
    function TokenUrl(const AValue: string): IOAuthFlow; overload;

    /// <summary>A URL a ser usada para obter tokens de atualização (refresh tokens).</summary>
    function RefreshUrl: string; overload;
    function RefreshUrl(const AValue: string): IOAuthFlow; overload;

    /// <summary>
    ///   REQUIRED. Os escopos disponíveis para o esquema de segurança OAuth2.
    ///   Um mapa entre o nome do escopo e uma breve descrição.
    /// </summary>
    function Scopes: TOpenApiMap<string, IOAuthFlow>;

    /// <summary>Retorna para o objeto anterior.</summary>
    function &End: IOAuthFlows;
  end;

  /// <summary>Permite a configuração dos fluxos OAuth suportados.</summary>
  IOAuthFlows = interface(IOpenApiAncestor)
    ['{2768F687-9BCC-4D9D-84D9-CDAD33C12405}']
    /// <summary>Configuração para o fluxo OAuth Implicit.</summary>
    function Implicit: IOAuthFlow;

    /// <summary>Configuração para o fluxo OAuth Resource Owner Password.</summary>
    function Password: IOAuthFlow;

    /// <summary>Configuração para o fluxo OAuth Client Credentials.</summary>
    function ClientCredentials: IOAuthFlow;

    /// <summary>Configuração para o fluxo OAuth Authorization Code.</summary>
    function AuthorizationCode: IOAuthFlow;

    /// <summary>Retorna para o objeto anterior.</summary>
    function &End: ISecurityScheme;
  end;

  /// <summary>
  ///   Objeto representando um logo para a API (extensão x-logo do Redoc).
  /// </summary>
  ILogo = interface(IOpenApiAncestor)
    ['{A1B2C3D4-E5F6-7890-ABCD-EF1234567890}']
    /// <summary>URL do logo (SVG, PNG, etc).</summary>
    function Url: string; overload;
    function Url(const AValue: string): ILogo; overload;

    /// <summary>Cor de fundo do logo (formato hexadecimal, ex: #FFFFFF).</summary>
    function BackgroundColor: string; overload;
    function BackgroundColor(const AValue: string): ILogo; overload;

    /// <summary>Texto alternativo para o logo.</summary>
    function AltText: string; overload;
    function AltText(const AValue: string): ILogo; overload;

    /// <summary>URL de destino ao clicar no logo.</summary>
    function Href: string; overload;
    function Href(const AValue: string): ILogo; overload;

    /// <summary>Retorna para o objeto anterior.</summary>
    function &End: IInfo;
  end;

  /// <summary>
  ///   Objeto representando um grupo de tags (extensão x-tagGroups do Redoc).
  /// </summary>
  ITagGroup = interface(IOpenApiAncestor)
    ['{B2C3D4E5-F678-90AB-CDEF-1234567890AB}']
    /// <summary>Nome do grupo de tags.</summary>
    function Name: string; overload;
    function Name(const AValue: string): ITagGroup; overload;

    /// <summary>Lista de nomes de tags pertencentes a este grupo.</summary>
    function Tags: TOpenApiList<string, ITagGroup>;

    /// <summary>Retorna para o objeto anterior.</summary>
    function &End: IOpenApi;
  end;

  /// <summary>
  ///   Objeto representando um exemplo de código (extensão x-code-samples do Redoc).
  /// </summary>
  ICodeSample<T> = interface(IOpenApiAncestor)
    ['{C3D4E5F6-7890-ABCD-EF12-34567890ABCD}']
    /// <summary>Linguagem do código (ex: 'javascript', 'python', 'curl').</summary>
    function Lang: string; overload;
    function Lang(const AValue: string): ICodeSample<T>; overload;

    /// <summary>Label descritivo para o exemplo.</summary>
    function &Label: string; overload;
    function &Label(const AValue: string): ICodeSample<T>; overload;

    /// <summary>Código fonte do exemplo.</summary>
    function Source: string; overload;
    function Source(const AValue: string): ICodeSample<T>; overload;

    /// <summary>Retorna para o objeto anterior.</summary>
    function &End: T;
  end;

implementation

end.
