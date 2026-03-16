unit Horse.Documentation.Attributes.Contact;

interface

uses
  Horse.Documentation.OpenApi.Contact;

type
  THorseDocContactAttribute = class(TCustomAttribute)
  private
    FContact: TContact;
  public
    constructor Create(const AName: string; const AUrl: string = ''; const AEmail: string = '');
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
