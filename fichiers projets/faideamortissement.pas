unit FAideAmortissement;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ExtCtrls, ComCtrls;

type

  { TFAideAmort }

  TFAideAmort = class(TForm)
    Image1: TImage;
    Image2: TImage;
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    PROCEDURE FormCreate(Sender: TObject);

  private

  public

  end;

var
  FAideAmort: TFAideAmort;

implementation

{$R *.lfm}

{ TFAideAmort }

PROCEDURE TFAideAmort.FormCreate(Sender: TObject);
BEGIN
  Position:=poScreenCenter;
end;

end.
