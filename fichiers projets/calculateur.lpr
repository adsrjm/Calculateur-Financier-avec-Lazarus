program calculateur;

{$mode objfpc}{$H+}

uses
  {$IFDEF UNIX}{$IFDEF UseCThreads}
  cthreads,
  {$ENDIF}{$ENDIF}
  Interfaces, // this includes the LCL widgetset
  Forms, UMainForm, UInteretSimple, UInteretCompose, UAmortissement, Uutiles,
  FAideInteretSimple, FAideInteretCompose, FAideAmortissement
  { you can add units after this };

{$R *.res}

begin
  RequireDerivedFormResource:=True;
  Application.Scaled:=True;
  Application.Initialize;
  Application.CreateForm(TFMain, FMain);
  Application.CreateForm(TFInteretSimple, FInteretSimple);
  Application.CreateForm(TFInteretCompose, FInteretCompose);
  Application.CreateForm(TFAmortissement, FAmortissement);
  Application.CreateForm(TFAideIntSimple, FAideIntSimple);
  Application.CreateForm(TFAideIntComp, FAideIntComp);
  Application.CreateForm(TFAideAmort, FAideAmort);
  Application.Run;
end.

