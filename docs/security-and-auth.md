# Guia de Segurança e Autenticação

A especificação OpenAPI 3.1.1 modela autenticação e autorização em duas etapas:

1. **Declaração dos Esquemas (`Components.SecuritySchemes`)**: define os mecanismos suportados pela API (`ISecurityScheme`).
2. **Aplicação dos Requisitos (`Security`)**: vincula os esquemas declarados de forma global (`HorseDoc.Security`) ou específica por operação (`Operation.Security`).

> **Persistência no Scalar UI**: O `THorseDocumentationController` inicializa o Scalar com `persistAuth: true`. Assim, o token ou chave preenchido pelo desenvolvedor na interface web fica salvo no `localStorage` do navegador entre recarregamentos da página.

---

## 1. HTTP Bearer (JWT)

Ideal para APIs protegidas por middlewares como `horse-jwt`:

```pascal
HorseDoc
  .Components
    .SecuritySchemes
      .Add('bearerAuth')
        .&Type(TSecuritySchemeType.sstHttp)
        .Scheme('bearer')
        .BearerFormat('JWT')
        .Description('Insira o token JWT obtido no endpoint `/auth/login`.')
        .&End
    .&End
  .Security
    .Add
      .SchemeName('bearerAuth')
      .&End;
```

---

## 2. HTTP Basic Auth

Para endpoints protegidos por autenticação básica (`Authorization: Basic <base64>`):

```pascal
HorseDoc
  .Components
    .SecuritySchemes
      .Add('basicAuth')
        .&Type(TSecuritySchemeType.sstHttp)
        .Scheme('basic')
        .Description('Credenciais HTTP Basic (usuário e senha).')
        .&End
    .&End;
```

---

## 3. API Key (Header, Query ou Cookie)

Quando a API exige uma chave de aplicação enviada no cabeçalho, na URL ou em cookie (`TApiKeyLocation`):

```pascal
HorseDoc
  .Components
    .SecuritySchemes
      .Add('tenantKey')
        .&Type(TSecuritySchemeType.sstApiKey)
        .Name('X-Tenant-Key')
        .&In(TApiKeyLocation.aklHeader)
        .Description('Identificador de chave do tenant.')
        .&End
    .&End;
```

Valores possíveis para `&In`:
- `TApiKeyLocation.aklHeader` (`header`)
- `TApiKeyLocation.aklQuery` (`query`)
- `TApiKeyLocation.aklCookie` (`cookie`)

---

## 4. OAuth 2.0 e Fluxos (`Flows`)

Quando `&Type(TSecuritySchemeType.sstOAuth2)` é utilizado, o objeto `.Flows` (`IOAuthFlows`) permite configurar os quatro fluxos padronizados (`Implicit`, `Password`, `ClientCredentials`, `AuthorizationCode`) e seus respectivos escopos (`Scopes`):

```pascal
HorseDoc
  .Components
    .SecuritySchemes
      .Add('oauth2Scheme')
        .&Type(TSecuritySchemeType.sstOAuth2)
        .Description('Autenticação OAuth 2.0 corporativa')
        .Flows
          .AuthorizationCode
            .AuthorizationUrl('https://auth.minhaempresa.com.br/oauth/authorize')
            .TokenUrl('https://auth.minhaempresa.com.br/oauth/token')
            .RefreshUrl('https://auth.minhaempresa.com.br/oauth/refresh')
            .Scopes
              .AddValue('financeiro:leitura', 'Permite consultar lançamentos financeiros')
              .AddValue('financeiro:escrita', 'Permite criar e alterar lançamentos financeiros')
            .&End
          .ClientCredentials
            .TokenUrl('https://auth.minhaempresa.com.br/oauth/token')
            .Scopes
              .AddValue('integracao:lote', 'Processamento em lote máquina-a-máquina')
            .&End
          .&End
        .&End
    .&End;
```

---

## 5. OpenID Connect (OIDC)

Para provedores compatíveis com OpenID Connect Discovery (Keycloak, Auth0, Azure AD / Entra ID, Google):

```pascal
HorseDoc
  .Components
    .SecuritySchemes
      .Add('oidcAuth')
        .&Type(TSecuritySchemeType.sstOpenIdConnect)
        .OpenIdConnectUrl('https://sso.minhaempresa.com.br/realms/master/.well-known/openid-configuration')
        .Description('Single Sign-On via OpenID Connect')
        .&End
    .&End;
```

---

## 6. Aplicando Segurança por Operação e Escopos

Você pode exigir um esquema de segurança específico (e escopos específicos no caso de OAuth2/OIDC) em uma única operação:

```pascal
HorseDoc
  .Paths
    .Add('/lancamentos')
      .Post
        .Summary('Criar lançamento financeiro')
        .Tags.Add('Financeiro')
        .Security
          .Add
            .SchemeName('oauth2Scheme')
            .Scopes
              .Add('financeiro:escrita')
            .&End
        .&End
      .&End;
```
