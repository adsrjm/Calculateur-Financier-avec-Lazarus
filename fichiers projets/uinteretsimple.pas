unit UInteretSimple;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, ExtCtrls;

type

  { TFInteretSimple }

  TFInteretSimple = class(TForm)
    btnCalculInteretsimple: TButton;
    edtCapitalInteretSimple: TEdit;
    edtTauxInteretSimple: TEdit;
    edtAnneeInteretSimple: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    lblTotalInteretSimple: TLabel;
    MResultatInteretSimple: TMemo;  //TMemo pour avoir plusieurs lignes de résultats
    procedure btnCalculInteretsimpleClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private

  public
    procedure ResetInteretSimpleFields;
  end;

var
  FInteretSimple: TFInteretSimple;

implementation

uses Uutiles;

  {$R *.lfm}

{ TFInteretSimple }
// initialiser les champs
procedure TFInteretSimple.ResetInteretSimpleFields;
begin
  // Réinitialiser le champ résultat TMemo
  MResultatInteretSimple.Clear;

  // Réinitialiser les autres champs si nécessaire
  edtCapitalInteretSimple.Text := '';
  edtTauxInteretSimple.Text := '';
  edtAnneeInteretSimple.Text := '';
end;

// Afficher les intérêts simples sur la période donnée
procedure TFInteretSimple.btnCalculInteretsimpleClick(Sender: TObject);
var
  IntS, capitalSimple, tauxSimple, totalIntSimple: double;
  dureeSimple, i: integer;
begin
  // capturer les valeurs des champs avec les exceptions
  try
    capitalSimple := StrToFloat(FInteretSimple.edtCapitalInteretSimple.Text);
  except
    on E: EConvertError do
    begin
      ShowMessage('Veuillez entrer un montant valide pour le capital.');
      Exit;
    end;
  end;

  try
    tauxSimple := StrToFloat(FInteretSimple.edtTauxInteretSimple.Text);
  except
    on E: EConvertError do
    begin
      ShowMessage('Veuillez entrer un taux valide.');
      Exit;
    end;
  end;

  try
    dureeSimple := StrToInt(FInteretSimple.edtAnneeInteretSimple.Text);
  except
    on E: EConvertError do
    begin
      ShowMessage('Veuillez entrer un nombre d''année valide.');
      Exit;
    end;
  end;

  // effacer les résultats précédents
  MResultatInteretSimple.Clear;

  // calcul des intérêtauxSimple simples
  for i := 1 to dureeSimple do
  begin
    IntS := capitalSimple * (tauxSimple / 100);
    MResultatInteretSimple.Lines.Add('Année ' + IntToStr(i) + ' = ' +
      Uutiles.FormaterNombre(IntS));   // appel de la fonction formatage
  end;

  // Calcul indépendant pour le total des intérêtauxSimple simples en fin de période
  totalIntSimple := capitalSimple * (tauxSimple / 100) * dureeSimple;
  Uutiles.FormaterEtAfficher(totalIntSimple, lblTotalInteretSimple);
  // appel de la procédure de formatage
end;

//******************************************************************************

procedure TFInteretSimple.FormCreate(Sender: TObject);
begin
  // positionner la fenetre au cente de l'écran
  FInteretSimple.Position := poScreenCenter;
end;

end.
