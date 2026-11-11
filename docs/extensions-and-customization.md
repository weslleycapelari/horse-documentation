# Extensões e Customização Visual

O **Horse Documentation** oferece suporte nativo às principais extensões de especificação (*vendor extensions*) utilizadas pelo **Scalar API Reference** e pelo **Redoc**, além de permitir a inclusão de qualquer extensão customizada `x-*`.

---

## 1. Logotipo Personalizado (`x-logo`)

Através de `HorseDoc.Info.Logo` (`ILogo`), você pode configurar a imagem, cor de fundo, texto alternativo e link do logotipo exibido na documentação:

```pascal
HorseDoc
  .Info
    .Logo
      .Url('https://minhaempresa.com.br/assets/logo.png')
      .BackgroundColor('#1E293B')
      .AltText('Minha Empresa API')
      .Href('https://minhaempresa.com.br')
      .&End
    .&End;
```

> **Dica**: Também é possível utilizar uma **Data URI** (`data:image/svg+xml;base64,...` ou `data:image/png;base64,...`) em `.Url(...)` para manter o logotipo 100% embarcado no binário da aplicação.

JSON gerado dentro de `info`:
```json
"x-logo": {
  "url": "https://minhaempresa.com.br/assets/logo.png",
  "backgroundColor": "#1E293B",
  "altText": "Minha Empresa API",
  "href": "https://minhaempresa.com.br"
}
```

---

## 2. Nome de Exibição de Tags (`x-displayName`)

Em grandes APIs, o identificador técnico de uma tag (ex: ` CadastrosClientes `) pode ser diferente do título amigável desejado no menu lateral. Utilize `Tag.DisplayName`:

```pascal
HorseDoc
  .Tags
    .Add
      .Name('CadastrosClientes')
      .DisplayName('Cadastro de Clientes')
      .Description('Operações de gerenciamento de clientes.')
      .&End;
```

JSON gerado no item de `tags`:
```json
{
  "name": "CadastrosClientes",
  "description": "Operações de gerenciamento de clientes.",
  "x-displayName": "Cadastro de Clientes"
}
```

---

## 3. Grupos de Tags no Menu Lateral (`x-tagGroups`)

Para organizar dezenas de tags em categorias colapsáveis na barra lateral, utilize `HorseDoc.TagGroups` (`ITagGroup`):

```pascal
HorseDoc
  .TagGroups
    .Add
      .Name('Autenticação e Controle de Acesso')
      .Tags
        .Add('Login')
        .Add('Usuarios')
        .Add('Permissoes')
      .&End
  .TagGroups
    .Add
      .Name('Módulo Financeiro')
      .Tags
        .Add('ContasPagar')
        .Add('ContasReceber')
        .Add('FluxoCaixa')
      .&End;
```

JSON gerado na raiz do documento OpenAPI:
```json
"x-tagGroups": [
  {
    "name": "Autenticação e Controle de Acesso",
    "tags": ["Login", "Usuarios", "Permissoes"]
  },
  {
    "name": "Módulo Financeiro",
    "tags": ["ContasPagar", "ContasReceber", "FluxoCaixa"]
  }
]
```

---

## 4. Exemplos de Código por Operação (`x-code-samples`)

Embora o Scalar gere exemplos automáticos de requisição HTTP, você pode fornecer exemplos customizados (por exemplo, utilizando `RESTRequest4Delphi`, `NetHTTPClient`, SDKs próprios ou scripts específicos) através de `Operation.CodeSamples` (`ICodeSample<T>`):

```pascal
HorseDoc
  .Paths
    .Add('/relatorios/exportar')
      .Post
        .Summary('Exportar relatório em PDF')
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
    .Resource('/relatorios/exportar')
    .Accept('application/pdf')
    .Post;
end;
'''         )
            .&End
        .CodeSamples
          .Add
            .Lang('python')
            .&Label('Requests')
            .Source(
'''
import requests
r = requests.post("http://localhost:9000/relatorios/exportar")
open("relatorio.pdf", "wb").write(r.content)
'''         )
            .&End
        .&End
      .&End;
```

---

## 5. Extensões Arbitrárias (`Extensions` / `x-*`)

Como todas as interfaces do **Horse Documentation** herdam de `IOpenApiAncestor`, qualquer objeto (`HorseDoc`, `Info`, `PathItem`, `Operation`, `Parameter`, `Response`, `Tag`, etc.) possui o mapa `.Extensions`, permitindo adicionar campos customizados `x-*`:

```pascal
HorseDoc
  .Paths
    .Add('/pagamentos')
      .Post
        .Summary('Processar pagamento')
        .Extensions
          .AddValue('x-rate-limit', TJSONNumber.Create(60))
          .AddValue('x-idempotent', TJSONBool.Create(True))
        .&End
      .&End;
```

---

## 6. Boas Práticas com Markdown em Descrições

Os campos `.Description(...)` em `Info`, `Tag`, `Operation`, `Parameter` e `Response` interpretam **CommonMark**:

- Em `HorseDoc.Info.Description`, títulos de nível 1 (`# Título`) e nível 2 (`## Subtítulo`) são transformados automaticamente em itens de navegação na barra lateral do Scalar UI.
- Utilize *multiline strings* (`''' ... '''` no Delphi 12+) para escrever blocos Markdown extensos, tabelas de códigos de erro e blocos de código cercados por crases sem precisar concatenar strings com `sLineBreak`.
