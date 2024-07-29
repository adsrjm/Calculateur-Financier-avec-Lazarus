unit UMainForm;
//
{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, Menus, StdCtrls,
  ExtCtrls, MaskEdit, Grids;

type

  { TFMain }

  TFMain = class(TForm)
    lblOperationEnCours: TLabel;
    MainMenu1: TMainMenu;
    MenuItem1: TMenuItem;
    TMInteretCompose: TMenuItem;
    TMOperations: TMenuItem;
    TMInteretSimple: TMenuItem;
    TMAmortissement: TMenuItem;
    TMAide: TMenuItem;
    TMFormuleIS: TMenuItem;
    TMFormuleIC: TMenuItem;
    TMFormuleAmortissement: TMenuItem;
    procedure FormCreate(Sender: TObject);
    procedure TMAmortissementClick(Sender: TObject);
    procedure TMFormuleAmortissementClick(Sender: TObject);
    procedure TMFormuleICClick(Sender: TObject);
    procedure TMFormuleISClick(Sender: TObject);
    procedure TMInteretComposeClick(Sender: TObject);
    procedure TMInteretSimpleClick(Sender: TObject);

  private

  public

  end;

var
  FMain: TFMain;
  LabelOperationParDefaut: string;

implementation

{$R *.lfm}

{ TFMain }
uses UInteretSimple, UInteretCompose, UAmortissement, FAideInteretSimple,
  FAideInteretCompose, FAideAmortissement;

procedure TFMain.FormCreate(Sender: TObject);
begin
  // initialisation du label Operation
  LabelOperationParDefaut := FMain.lblOperationEnCours.Caption;

  // positionner la fenetre principale
  FMain.Left := 350;
  FMain.Top := 100;
end;

// ouverture "intérêt simple"
procedure TFMain.TMInteretSimpleClick(Sender: TObject);
begin
  // réinitialiser les champs
  FInteretSimple.ResetInteretSimpleFields;

  FMain.lblOperationEnCours.Caption :=
    'Calculateur d''intérêt simple sélectionné...';
  FInteretSimple.ShowModal;
  FMain.lblOperationEnCours.Caption := LabelOperationParDefaut;
  //à la sortie de la fenêtre modale
end;

// ouverture "intérêt composé"
procedure TFMain.TMInteretComposeClick(Sender: TObject);
begin
  // réinitialiser les champs
  FInteretCompose.ResetInteretComposeFields;

  FMain.lblOperationEnCours.Caption :=
    'Calculateur d''intérêt composé sélectionné...';
  FInteretCompose.ShowModal;
  FMain.lblOperationEnCours.Caption := LabelOperationParDefaut;
  //à la sortie de la fenêtre modale
end;

// ouverture "amortissement"
procedure TFMain.TMAmortissementClick(Sender: TObject);
begin
  // masquer le tableau StringGrid et vider le TMémo avant chque ouverture
  FAmortissement.ResetAmortissementFields;

  FMain.lblOperationEnCours.Caption := 'Calculateur d''amortissement sélectionné...';
  FAmortissement.ShowModal;
  FMain.lblOperationEnCours.Caption := LabelOperationParDefaut;
  //à la sortie de la fenêtre modale
end;

procedure TFMain.TMFormuleAmortissementClick(Sender: TObject);
begin
  FAideAmort.ShowModal;
end;

procedure TFMain.TMFormuleICClick(Sender: TObject);
begin
  FAideIntComp.ShowModal;
end;

procedure TFMain.TMFormuleISClick(Sender: TObject);
begin
  FAideIntSimple.ShowModal;
end;

end.
