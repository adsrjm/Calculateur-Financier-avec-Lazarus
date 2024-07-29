unit UInteretCompose;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, Math;

type

  { TFInteretCompose }

  TFInteretCompose = class(TForm)
    Button1: TButton;
    edtAnneeInteretComp: TEdit;
    edtCapitalInteretComp: TEdit;
    edtTauxInteretComp: TEdit;
    gpbDonnees: TGroupBox;
    gpbResultatIntComp: TGroupBox;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    lblTotalInteretComp: TLabel;
    MResultatInteretComp: TMemo;
    procedure Button1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private

  public
    procedure ResetInteretComposeFields;
  end;

var
  FInteretCompose: TFInteretCompose;

implementation

uses Uutiles;

  {$R *.lfm}

{ TFInteretCompose }
// initialiser les champs
procedure TFInteretCompose.ResetInteretComposeFields;
begin
  // Réinitialiser le champ résultat TMemo
  FInteretCompose.MResultatInteretComp.Clear;

  // Réinitialiser les autres champs si nécessaire
  FInteretCompose.edtCapitalInteretComp.Text := '';
  FInteretCompose.edtTauxInteretComp.Text := '';
  FInteretCompose.edtAnneeInteretComp.Text := '';
end;

procedure TFInteretCompose.FormCreate(Sender: TObject);
begin
  //positionner au centre de l'écran
  FInteretCompose.Position := poScreenCenter;
end;

//******************************************************************************

procedure TFInteretCompose.Button1Click(Sender: TObject);
var
  capitalCompose, tauxCompose, interetCompose, interetComposeTotal: double;
  dureeCompose, i, exposant: integer;
begin
  // capturer les valeurs des champs avec les exceptions
  try
    capitalCompose := StrToFloat(Self.edtCapitalInteretComp.Text);
  except
    on E: EConvertError do
    begin
      ShowMessage('Veuillez entrer un montant valide pour le capital.');
      Exit;
    end;
  end;

  try
    tauxCompose := StrToFloat(Self.edtTauxInteretComp.Text);
  except
    on E: EConvertError do
    begin
      ShowMessage('Veuillez entrer un taux valide.');
      Exit;
    end;
  end;

  try
    dureeCompose := StrToInt(Self.edtAnneeInteretComp.Text);
  except
    on E: EConvertError do
    begin
      ShowMessage('Veuillez entrer une période valide.');
      Exit;
    end;
  end;

  // effacer les résultats précédents
  MResultatInteretComp.Clear;

  // calcul des intérêts composés
  for i := 1 to dureeCompose do
  begin
    exposant := i - 1;
    interetCompose := capitalCompose * Power((1 + tauxCompose / 100), exposant) * tauxCompose / 100;
    MResultatInteretComp.Lines.Add('Annee ' + IntToStr(i) + ' = ' +
      Uutiles.FormaterNombre(interetCompose));
  end;

  // total des intérêts composés et affichage séparé
  interetComposeTotal := capitalCompose * (Power((1 + tauxCompose / 100), dureeCompose) - 1);
  Uutiles.FormaterEtAfficher(interetComposeTotal, lblTotalInteretComp); // appel de procédure
end;

end.
