# Horse Documentation

Middleware para geração automática e fluente de documentação **OpenAPI 3.1.1** com interface interativa **Scalar API Reference** embarcada para o framework [Horse](https://github.com/HashLoad/horse) em Delphi.

---

## Sumário

- [Visão Geral](#visão-geral)
- [Principais Recursos](#principais-recursos)
- [Instalação](#instalação)
  - [Via Boss](#via-boss)
  - [Instalação Manual](#instalação-manual)
- [Início Rápido (Quick Start)](#início-rápido-quick-start)
  - [Rotas Customizadas](#rotas-customizadas)
- [Mapeamento Automático de Rotas](#mapeamento-automático-de-rotas)
- [Guia Completo da API Fluente (Builder)](#guia-completo-da-api-fluente-builder)
  - [1. Metadados da API (`Info`, `Contact`, `License`, `Logo`)](#1-metadados-da-api-info-contact-license-logo)
  - [2. Servidores e Variáveis de Servidor (`Servers`)](#2-servidores-e-variáveis-de-servidor-servers)
  - [3. Caminhos, Operações e Parâmetros (`Paths`, `Parameters`)](#3-caminhos-operações-e-parâmetros-paths-parameters)
  - [4. Corpo da Requisição e Respostas (`RequestBody`, `Responses`)](#4-corpo-da-requisição-e-respostas-requestbody-responses)
  - [5. Componentes Reutilizáveis (`Components`)](#5-componentes-reutilizáveis-components)
  - [6. Segurança e Autenticação (`SecuritySchemes`, `Security`)](#6-segurança-e-autenticação-securityschemes-security)
  - [7. Organização por Tags e Grupos (`Tags`, `TagGroups`)](#7-organização-por-tags-e-grupos-tags-taggroups)
  - [8. Exemplos de Código por Operação (`CodeSamples`)](#8-exemplos-de-código-por-operação-codesamples)
  - [9. Webhooks, Documentação Externa e Extensões (`x-*`)](#9-webhooks-documentação-externa-e-extensões-x-)
- [Documentação Técnica Detalhada](#documentação-técnica-detalhada)
- [Projeto de Exemplo](#projeto-de-exemplo)
- [Licença](#licença)

---

## Visão Geral

O **Horse Documentation** permite documentar APIs construídas com o framework **Horse** combinando duas abordagens complementares:

1. **Descoberta Automática via RTTI (`AutoMapHorse`)**: inspeciona automaticamente a árvore interna de rotas do Horse (`THorseRouterTree`), converte parâmetros de rota do formato `:id` para o formato OpenAPI `{id}` e expõe todos os endpoints registrados sem exigir configuração manual.
2. **API Fluente Completa (Padrão Builder)**: disponibiliza a instância global `HorseDoc: IOpenApi`, permitindo enriquecer qualquer rota ou componente da especificação **OpenAPI 3.1.1** com encadeamento fortemente tipado e navegação hierárquica via `.&End`.

Toda a interface gráfica do **Scalar API Reference** (incluindo temas claro/escuro, cliente HTTP interativo *"Test Request"*, persistência de autenticação e suporte completo a Markdown) está **embarcada diretamente no recurso compilado** (`Horse.Documentation.res`), eliminando dependências de arquivos estáticos externos ou CDNs em ambientes offline/restritos.

---

## Principais Recursos

| Recurso | Descrição |
| :--- | :--- |
| **OpenAPI 3.1.1** | Modelagem fiel à especificação oficial OpenAPI 3.1.1 (`openapi: "3.1.1"`). |
| **Scalar UI Embarcada** | Interface moderna com temas Light/Dark, busca rápida, cliente HTTP integrado e zero arquivos externos (`SCALAR_JS` e `HORSE_ICON` em `.res`). |
| **Auto-Descoberta de Rotas** | Mapeia automaticamente todas as rotas (`GET`, `POST`, `PUT`, `DELETE`, `PATCH`, `HEAD`) registradas no Horse. |
| **Fluent Builder Tipado** | Coleções genéricas (`TOpenApiList<T, O>` e `TOpenApiMap<T, O>`) com instanciação automática e retorno ao nó pai via `.&End`. |
| **Segurança Completa** | Suporte a JWT Bearer, HTTP Basic, API Key (Header/Query/Cookie), OAuth 2.0 (`implicit`, `password`, `clientCredentials`, `authorizationCode`), OpenID Connect e Mutual TLS, com `persistAuth: true` no Scalar. |
| **Extensões Scalar / Redoc** | Suporte nativo tipado para `x-logo` (`Info.Logo`), `x-tagGroups` (`HorseDoc.TagGroups`), `x-displayName` (`Tag.DisplayName`) e `x-code-samples` (`Operation.CodeSamples`). |
| **Suporte a CommonMark** | Descrições ricas em Markdown (com títulos `#`, `##` que geram seções navegáveis automaticamente no menu lateral). |

---

## Instalação

### Via Boss

Utilizando o gerenciador de dependências [Boss](https://github.com/HashLoad/boss):

```bash
boss install github.com/weslleycapelari/horse-documentation
```

### Instalação Manual

1. Clone ou baixe este repositório.
2. Adicione o diretório `src/` ao **Search Path** (`DCC_UnitSearchPath`) do seu projeto no Delphi.
3. Certifique-se de que o arquivo de recursos `src/Horse.Documentation.res` permaneça junto às units em `src/`.
4. Adicione a unit `Horse.Documentation` na cláusula `uses` da sua aplicação.

---

## Início Rápido (Quick Start)

Basta registrar o middleware `HorseDocumentation` com `THorse.Use`:

```pascal
program ApiServer;

{$APPTYPE CONSOLE}

uses
  Horse,
  Horse.Documentation,
  System.SysUtils;

begin
  // Registra as rotas padrão:
  // HTML (Scalar UI): /horse/doc/html
  // JSON (OpenAPI):   /horse/doc/json
  THorse.Use(HorseDocumentation);

  THorse.Get('/ping',
    procedure(Req: THorseRequest; Res: THorseResponse)
    begin
      Res.Send('pong');
    end);

  THorse.Listen(9000,
    procedure
    begin
      THorseDocumentationController.AutoMapHorse;
      Writeln('Servidor rodando na porta 9000');
      Writeln('Documentacao: http://localhost:9000/horse/doc/html');
    end);
end.
```

### Rotas Customizadas

Você pode personalizar os caminhos onde a interface HTML e o documento JSON serão expostos:

```pascal
// Expõe o HTML em /docs e mantém o JSON no caminho padrão (/horse/doc/json)
THorse.Use(HorseDocumentation('/docs'));

// Ou personaliza ambos os caminhos:
THorse.Use(HorseDocumentation('/api/docs', '/api/openapi.json'));
```

---

## Mapeamento Automático de Rotas

O método `THorseDocumentationController.AutoMapHorse` percorre a árvore de rotas da instância do Horse e registra automaticamente todas as rotas encontradas em `HorseDoc.Paths`:

- Rotas internas da documentação (`/horse/doc/*`) são ignoradas automaticamente.
- Parâmetros de caminho do Horse (ex: `/usuarios/:id`) são convertidos automaticamente para a sintaxe OpenAPI (`/usuarios/{id}`).
- Caso uma rota já tenha sido documentada manualmente em `HorseDoc.Paths.Add('/usuarios/{id}')`, o `AutoMapHorse` **preserva** toda a documentação manual e apenas adiciona a tag `'untagged'` às operações que não possuírem nenhuma tag definida.

> **Importante sobre `THorse.Listen`**: por padrão, `THorseDocumentationController.Registry` atribui `THorse.OnListen := AutoMapHorse`. Se você passar um callback anônimo para `THorse.Listen(9000, procedure begin ... end)`, o Horse sobrescreve `THorse.OnListen`. Nesse caso, chame explicitamente `THorseDocumentationController.AutoMapHorse;` dentro do callback do `Listen`.

---

## Guia Completo da API Fluente (Builder)

A variável global `HorseDoc: IOpenApi` (declarada na unit `Horse.Documentation`) é o ponto de entrada para toda a especificação.

### 1. Metadados da API (`Info`, `Contact`, `License`, `Logo`)

```pascal
HorseDoc
  .Info
    .Title('API de Gestão Financeira')
    .Version('2.0.0')
    .Summary('Serviços REST para integração financeira e contábil')
    .TermsOfService('https://minhaempresa.com.br/termos')
    .Description(
'''
# Introdução

Bem-vindo à documentação oficial da **API de Gestão Financeira**.
Todos os textos em `Description` aceitam **CommonMark (Markdown)**.

## Ambientes Disponíveis
- **Homologação**: `https://sandbox.api.minhaempresa.com.br`
- **Produção**: `https://api.minhaempresa.com.br`
''' )
    .Contact
      .Name('Equipe de Arquitetura')
      .Email('arquitetura@minhaempresa.com.br')
      .Url('https://minhaempresa.com.br/suporte')
      .&End
    .License
      .Name('MIT')
      .Identifier('MIT')
      .&End
    .Logo
      .Url('https://minhaempresa.com.br/assets/logo.svg')
      .BackgroundColor('#FFFFFF')
      .AltText('Logo Minha Empresa')
      .Href('https://minhaempresa.com.br')
      .&End
    .&End;
```

### 2. Servidores e Variáveis de Servidor (`Servers`)

```pascal
HorseDoc
  .Servers
    .Add
      .Url('https://{ambiente}.minhaempresa.com.br:{porta}/{versao}')
      .Description('Servidor parametrizado por ambiente')
      .Variables
        .Add('ambiente')
          .&Default('api')
          .Description('Subdomínio do ambiente')
          .&Enum
            .Add('api')
            .Add('sandbox')
            .Add('staging')
          .&End
      .Variables
        .Add('porta')
          .&Default('443')
          .&End
      .Variables
        .Add('versao')
          .&Default('v1')
          .&End
      .&End;
```

### 3. Caminhos, Operações e Parâmetros (`Paths`, `Parameters`)

Para usar `TParameterLocation`, `TParameterStyle`, `TSecuritySchemeType` e `TApiKeyLocation`, basta ter `Horse.Documentation` (ou `Horse.Documentation.OpenApi.Types`) no `uses`:

```pascal
uses
  System.JSON,
  Horse.Documentation;

begin
  HorseDoc
    .Paths
      .Add('/clientes/{id}')
        .Summary('Operações de um cliente específico')
        .Get
          .Summary('Consultar cliente por ID')
          .Description('Retorna os dados cadastrais completos de um cliente.')
          .OperationId('getClienteById')
          .Tags.Add('Clientes')
          .Parameters
            .Add
              .Name('id')
              .&In(TParameterLocation.plPath)
              .Required(True)
              .Description('Identificador único do cliente')
              .Schema(TJSONObject.Create.AddPair('type', 'integer'))
              .Example(TJSONNumber.Create(42))
              .&End
          .Parameters
            .Add
              .Name('incluir_inativos')
              .&In(TParameterLocation.plQuery)
              .Required(False)
              .Description('Indica se registros inativos devem ser considerados')
              .Schema(TJSONObject.Create.AddPair('type', 'boolean'))
              .&End
          .&End
        .&End;
end;
```

### 4. Corpo da Requisição e Respostas (`RequestBody`, `Responses`)

```pascal
HorseDoc
  .Paths
    .Add('/clientes')
      .Post
        .Summary('Cadastrar novo cliente')
        .OperationId('createCliente')
        .Tags.Add('Clientes')
        .RequestBody
          .Description('Dados para criação do cliente')
          .Required(True)
          .Content
            .Add('application/json')
              .Schema(TJSONObject.Create
                .AddPair('$ref', '#/components/schemas/NovoClienteInput'))
              .Example(TJSONObject.Create
                .AddPair('nome', 'Maria Oliveira')
                .AddPair('documento', '12345678901'))
              .&End
          .&End
        .Responses
          .StatusCodes
            .Add('201')
              .Description('Cliente criado com sucesso')
              .Headers
                .Add('X-Request-Id')
                  .Description('Identificador de rastreamento da requisição')
                  .Schema(TJSONObject.Create.AddPair('type', 'string'))
                  .&End
              .Content
                .Add('application/json')
                  .Schema(TJSONObject.Create
                    .AddPair('$ref', '#/components/schemas/ClienteOutput'))
                  .&End
              .&End
          .StatusCodes
            .Add('400')
              .Description('Erro de validação nos dados enviados')
              .&End
          .&End
        .&End
      .&End;
```

### 5. Componentes Reutilizáveis (`Components`)

Registre JSON Schemas, parâmetros, respostas e exemplos em `HorseDoc.Components` para referenciá-los via `$ref`:

```pascal
HorseDoc
  .Components
    .Schemas
      .AddValue('NovoClienteInput', TJSONObject.Create
        .AddPair('type', 'object')
        .AddPair('required', TJSONArray.Create.Add('nome').Add('documento'))
        .AddPair('properties', TJSONObject.Create
          .AddPair('nome', TJSONObject.Create.AddPair('type', 'string'))
          .AddPair('documento', TJSONObject.Create.AddPair('type', 'string'))))
      .AddValue('ClienteOutput', TJSONObject.Create
        .AddPair('type', 'object')
        .AddPair('properties', TJSONObject.Create
          .AddPair('id', TJSONObject.Create.AddPair('type', 'integer'))
          .AddPair('nome', TJSONObject.Create.AddPair('type', 'string'))
          .AddPair('documento', TJSONObject.Create.AddPair('type', 'string'))))
    .&End;
```

### 6. Segurança e Autenticação (`SecuritySchemes`, `Security`)

Declare os esquemas em `Components.SecuritySchemes` e aplique-os globalmente (`HorseDoc.Security`) ou por operação (`Operation.Security`):

```pascal
HorseDoc
  .Components
    .SecuritySchemes
      // 1. Autenticação HTTP Bearer (JWT)
      .Add('bearerAuth')
        .&Type(TSecuritySchemeType.sstHttp)
        .Scheme('bearer')
        .BearerFormat('JWT')
        .Description('Informe o token JWT no formato Bearer.')
        .&End
      // 2. Autenticação via API Key em Header
      .Add('apiKeyHeader')
        .&Type(TSecuritySchemeType.sstApiKey)
        .Name('X-API-Key')
        .&In(TApiKeyLocation.aklHeader)
        .Description('Chave de integração por aplicação.')
        .&End
    .&End
  // Requisito de segurança global da API:
  .Security
    .Add
      .SchemeName('bearerAuth')
      .&End;
```

### 7. Organização por Tags e Grupos (`Tags`, `TagGroups`)

Use `Tags` com `DisplayName` (`x-displayName`) e agrupe-as em seções no menu lateral usando `TagGroups` (`x-tagGroups`):

```pascal
HorseDoc
  .Tags
    .Add
      .Name('Autenticacao')
      .DisplayName('Autenticação e Sessão')
      .Description('Endpoints de login, renovação de token e logout.')
      .&End
  .Tags
    .Add
      .Name('Clientes')
      .DisplayName('Gestão de Clientes')
      .Description('Operações cadastrais de clientes.')
      .&End
  .TagGroups
    .Add
      .Name('Segurança')
      .Tags
        .Add('Autenticacao')
      .&End
  .TagGroups
    .Add
      .Name('Cadastros Base')
      .Tags
        .Add('Clientes')
      .&End;
```

### 8. Exemplos de Código por Operação (`CodeSamples`)

Adicione trechos de código prontos em qualquer linguagem (`x-code-samples`) para exibição no painel lateral da operação:

```pascal
HorseDoc
  .Paths
    .Add('/clientes/{id}')
      .Get
        .CodeSamples
          .Add
            .Lang('Delphi')
            .&Label('RESTRequest4Delphi')
            .Source(
'''
var
  LRes: IResponse;
begin
  LRes := TRequest.New
    .BaseURL('http://localhost:9000')
    .Resource('/clientes/42')
    .TokenBearer(LToken)
    .Get;
end;
'''         )
            .&End
        .CodeSamples
          .Add
            .Lang('javascript')
            .&Label('Fetch API')
            .Source('fetch("http://localhost:9000/clientes/42").then(r => r.json());')
            .&End
        .&End
      .&End;
```

### 9. Webhooks, Documentação Externa e Extensões (`x-*`)

Todos os objetos do modelo herdam de `TOpenApiAncestor` (`IOpenApiAncestor`) e possuem suporte a extensões customizadas via `.Extensions.AddValue`:

```pascal
HorseDoc
  .ExternalDocs
    .Description('Portal do Desenvolvedor')
    .Url('https://devs.minhaempresa.com.br')
    .&End
  .Extensions
    .AddValue('x-internal-version', TJSONString.Create('build-2026.11'));
```

---

## Documentação Técnica Detalhada

Para informações aprofundadas sobre a arquitetura interna e referência completa de todas as interfaces e classes, consulte o diretório [`docs/`](docs/README.md):

- [**Índice da Documentação (`docs/README.md`)**](docs/README.md) — Mapa completo das 34 units e visão geral do projeto.
- [**Arquitetura Interna (`docs/architecture.md`)**](docs/architecture.md) — Funcionamento do middleware, introspecção RTTI da árvore de rotas do Horse, recursos embarcados (`SCALAR_JS`, `HORSE_ICON`) e coleções genéricas fluentes.
- [**Referência de Modelos OpenAPI 3.1.1 (`docs/openapi-models.md`)**](docs/openapi-models.md) — Catálogo detalhado de todas as interfaces, tipos enumerados, métodos e estrutura JSON gerada.
- [**Segurança e Autenticação (`docs/security-and-auth.md`)**](docs/security-and-auth.md) — Guia prático de configuração para Bearer JWT, Basic Auth, API Key, OAuth 2.0 Flows e OpenID Connect.
- [**Extensões e Customização Visual (`docs/extensions-and-customization.md`)**](docs/extensions-and-customization.md) — Como usar `x-logo`, `x-tagGroups`, `x-displayName`, `x-code-samples`, Markdown avançado e extensões customizadas `x-*`.

---

## Projeto de Exemplo

O diretório [`samples/`](samples/) contém um projeto console completo ([`samples/Console.dpr`](samples/Console.dpr)) demonstrando:

- Registro do middleware `HorseDocumentation`;
- Configuração de `Info`, `Contact`, `License` e `Logo`;
- Esquemas de segurança (`SecuritySchemes`);
- Documentação de rotas com `CodeSamples`, `Responses` e `Schema`;
- Agrupamento com `Tags` (`DisplayName`) e `TagGroups`;
- Mapeamento automático de rotas com `THorseDocumentationController.AutoMapHorse`.

Para executar o exemplo:
1. Abra `samples/Console.dproj` no Delphi;
2. Compile e execute o projeto;
3. Acesse `http://localhost:9000/horse/doc/html` no navegador.

---

## Licença

Este projeto é distribuído sob a licença **MIT**. Consulte as informações de licença do repositório para mais detalhes.
