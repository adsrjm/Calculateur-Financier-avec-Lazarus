unit FAideInteretCompose;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ExtCtrls;

type

  { TFAideIntComp }

  TFAideIntComp = class(TForm)
    Image1: TImage;
    PROCEDURE FormCreate(Sender: TObject);

  private

  public

  end;

var
  FAideIntComp: TFAideIntComp;

implementation

{$R *.lfm}

{ TFAideIntComp }

PROCEDURE TFAideIntComp.FormCreate(Sender: TObject);
BEGIN
  Position:=poScreenCenter;
end;

end.
