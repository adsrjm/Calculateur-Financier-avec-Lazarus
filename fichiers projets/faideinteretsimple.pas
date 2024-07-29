unit FAideInteretSimple;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ExtCtrls;

type
  { TFAideIntSimple }
  TFAideIntSimple = class(TForm)
    Image1: TImage;
    PROCEDURE FormCreate(Sender: TObject);
  private
  public
  end;

var
  FAideIntSimple: TFAideIntSimple;

implementation

{$R *.lfm}

{ TFAideIntSimple }



PROCEDURE TFAideIntSimple.FormCreate(Sender: TObject);
BEGIN
  Position:=poScreenCenter;
end;

end.
