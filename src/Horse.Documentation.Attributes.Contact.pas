unit Horse.Documentation.Attributes.Contact;

interface

uses
  Horse.Documentation.OpenApi.Interfaces,
  Horse.Documentation.OpenApi.Contact;

type
  /// <summary>
  ///   Atributo RTTI para definição de informações de contato da API na documentação OpenAPI.
  /// </summary>
  THorseDocContactAttribute = class(TCustomAttribute)
  private
    FContact: IContact;
  public
    /// <summary>
    ///   Cria o atributo de contato da documentação com nome, URL e e-mail opcionais.
    /// </summary>
    /// <param name="AName">Nome de identificação da pessoa ou organização de contato.</param>
    /// <param name="AUrl">URL para as informações de contato (formato URI).</param>
    /// <param name="AEmail">Endereço de e-mail da pessoa ou organização de contato.</param>
    constructor Create(const AName: string; const AUrl: string = ''; const AEmail: string = '');

    /// <summary>Retorna a instância <c>IContact</c> configurada pelo atributo.</summary>
    property Contact: IContact read FContact;
  end;

implementation

{ THorseDocContactAttribute }

constructor THorseDocContactAttribute.Create(const AName, AUrl, AEmail: string);
begin
  FContact := TContact.New(nil);
  FContact
    .Name(AName)
    .Url(AUrl)
    .Email(AEmail);
end;

end.
