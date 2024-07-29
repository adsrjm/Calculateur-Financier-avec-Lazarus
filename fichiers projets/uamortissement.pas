unit UAmortissement;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, ComCtrls,
  Grids, MaskEdit, Math, Uutiles;

type

  { TFAmortissement }

  TFAmortissement = class(TForm)
    btnConst: TButton;
    btnLineaire: TButton;
    edtAnnee: TEdit;
    edtCapital: TEdit;
    edtTauxinteret: TEdit;
    gpbDonnee: TGroupBox;
    lblAnnee: TLabel;
    lblAnnee1: TLabel;
    lblEmprunt: TLabel;
    lblTaux: TLabel;
    mskDateLineaire: TMaskEdit;
    ctlAmortissement: TPageControl;
    StGResultConst: TStringGrid;
    StGResultLineaire: TStringGrid;
    tabConstant: TTabSheet;
    tabLineaire: TTabSheet;
    procedure btnConstClick(Sender: TObject);
    procedure btnLineaireClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);

  private
    // variables communes pour les composants
    capital, tauxInt: double;
    duree: integer;
    function InitChampConst: boolean;
    function InitChampLineaire: boolean;
  public
    procedure ResetAmortissementFields;
  end;

var
  FAmortissement: TFAmortissement;

implementation

{$R *.lfm}

{ TFAmortissement }
procedure TFAmortissement.ResetAmortissementFields;
begin
  // Réinitialiser les champs stringGrid
  StGResultConst.Visible := False;
  StGResultLineaire.Visible := False;
  // Réinitialiser les autres champs si nécessaire
  edtCapital.Text := '';
  edtTauxinteret.Text := '';
  mskDateLineaire.Text := '';
  edtAnnee.Text := '';
end;

// vérification des saisies ds champs Amortissement Constant
function TFAmortissement.InitChampConst: boolean;
begin
  if not InitChampLineaire then      // champs commun
    Exit(False);    // Retourne False en cas d'erreur

  try
    tauxInt := StrToFloat(edtTauxinteret.Text) / 100;
  except
    on E: EConvertError do
    begin
      ShowMessage('Entrer un taux valide (en %).');
      Result := False;
      Exit;
    end;
  end;
  Result := True;
end;

// vérification des saisies ds champs Amortissement Linéaire
function TFAmortissement.InitChampLineaire: boolean;
begin
  Result := True; // Initialiser à True, changera en cas d'erreur

  try
    capital := StrToFloat(edtCapital.Text);
  except
    on E: EConvertError do
    begin
      ShowMessage('Entrer un emprunt valide.');
      Result := False;
      Exit;
    end;
  end;

  try
    duree := StrToInt(edtAnnee.Text);
    if duree = 0 then
    begin
      ShowMessage('La durée doit être différente de 0.');
      Result := False;
      Exit;
    end;
  except
    on E: EConvertError do
    begin
      ShowMessage('Entrer une durée valide (en année).');
      Result := False;
      Exit;
    end;
  end;
end;

//******************************************************************************

procedure TFAmortissement.FormCreate(Sender: TObject);
begin
  // positionner la fenetre au centre
  FAmortissement.Position := poScreenCenter;

  // formater le champ TMaskEdit pour recevoir 'jj/mm/aaaa'
  mskDateLineaire.EditMask := '!99/99/0000;1;_';

  // masquer le tableau StringGrid (FAmortissement) avant le clic
  StGResultConst.Visible := False;
end;

// calcul et affichage de l'amortissement constant
procedure TFAmortissement.btnConstClick(Sender: TObject);
var
  interetConstant, amorConstant, annuiteConstant: double;
  i: integer;
begin
  // initialiser les variables et capturer les erreurs de saisie
  if not InitChampConst then exit;

  // Réinitialiser le StringGrid
  StGResultConst.RowCount := 1; // Seulement la ligne des titres
  StGResultConst.ColCount := 5;
  // mise en place des titres de l'affichage
  StGResultConst.Cells[0, 0] := 'ANNEE';
  StGResultConst.Cells[1, 0] := 'CAPITAL RESTANT Dû';
  StGResultConst.Cells[2, 0] := 'INTERET';
  StGResultConst.Cells[3, 0] := 'AMORTISSEMENT';
  StGResultConst.Cells[4, 0] := 'ANNUITE';

  // calcul
  amorConstant := capital / duree;
  annuiteConstant := 0; // initialisation
  StGResultConst.RowCount := duree + 1; // +1 pour la ligne de titre

  for i := 1 to duree do
  begin
    capital := capital - annuiteConstant;
    interetConstant := capital * tauxInt;
    annuiteConstant := interetConstant + amorConstant;

    StGResultConst.Cells[0, i] := IntToStr(i);
    StGResultConst.Cells[1, i] := Uutiles.FormaterNombre(capital);
    StGResultConst.Cells[2, i] := Uutiles.FormaterNombre(interetConstant);
    StGResultConst.Cells[3, i] := Uutiles.FormaterNombre(amorConstant);
    StGResultConst.Cells[4, i] := Uutiles.FormaterNombre(annuiteConstant);
  end;

  // Afficher le StringGrid
  StGResultConst.Visible := True;
end;


// calcul et affichage de l'amortissement linéaire
procedure TFAmortissement.btnLineaireClick(Sender: TObject);
var
  jour, mois, an, jourUtilisationMoisCourant, moisRestantUtilisation,
  jourUtilisable, moisDernierAnnee, jourDernierAnnee, i, j: integer;
  baseAmortissable, tauxAmort, annuiteComplete, annuiteProrata,
  annuiteDerniereAnnee, vnc, cumulAnnuite: double;
begin
  // effacer les résultats précédents
  StGResultLineaire.RowCount := 1;   // Seulement la ligne des titres
  StGResultLineaire.ColCount := 3;
  // réinitialiser le nombre de lignes à 1 pour effacer les résultats précédents
  StGResultLineaire.Cells[0, 0] := 'ANNEE';
  StGResultLineaire.Cells[1, 0] := 'ANNUITE';
  StGResultLineaire.Cells[2, 0] := 'VALEUR NETTE COMPTABLE (VNC)';

  // initialiser les variables et capturer les erreurs de saisie
  if not InitChampLineaire then exit;

  // vérifier la validité de la date
  if not Uutiles.VerifierDate(mskDateLineaire) then exit;

  jour := Uutiles.RecupererJour(mskDateLineaire);
  mois := Uutiles.RecupererMois(mskDateLineaire);
  an := Uutiles.RecupererAnnee(mskDateLineaire);

  // formules de bases de l'amortissement
  baseAmortissable := capital;
  tauxAmort := 1 / duree;
  annuiteComplete := baseAmortissable * tauxAmort;

  // première année: annuité prorata temporis
  moisRestantUtilisation := 12 - mois;
  jourUtilisationMoisCourant := (30 - jour) + 1; // inclure la date début
  jourUtilisable := jourUtilisationMoisCourant + (moisRestantUtilisation * 30);
  annuiteProrata := annuiteComplete * jourUtilisable / 360;

  // annuité de la dernière année
  moisDernierAnnee := mois - 1;
  jourDernierAnnee := (moisDernierAnnee * 30) + (jour - 1); // exclure la date debut
  annuiteDerniereAnnee := annuiteComplete * jourDernierAnnee / 360;

  if (jour = 1) and (mois = 1) then
  begin
    vnc := baseAmortissable - annuiteComplete;
    // cas exceptionnel si acquisition au 01 janvier de l'année, alors annuité constante
    for i := 1 to duree do
    begin
      // tableau d'amortissement
      StGResultLineaire.RowCount := StGResultLineaire.RowCount + 1;
      StGResultLineaire.Cells[0, i] := IntToStr(i);
      StGResultLineaire.Cells[1, i] := Uutiles.FormaterNombre(annuiteComplete);
      StGResultLineaire.Cells[2, i] := Uutiles.FormaterNombre(vnc);
      vnc := vnc - annuiteComplete;
    end;
  end
  else
  begin
    // si autre jour et autre mois différent de 01 janvier année N
    // affichage année 1 (par défaut)
    vnc := baseAmortissable - annuiteProrata;
    i := 1;
    StGResultLineaire.RowCount := StGResultLineaire.RowCount + 1;
    StGResultLineaire.Cells[0, i] := IntToStr(i);
    StGResultLineaire.Cells[1, i] := Uutiles.FormaterNombre(annuiteProrata);
    StGResultLineaire.Cells[2, i] := Uutiles.FormaterNombre(vnc);

    cumulAnnuite := annuiteProrata + annuiteComplete;  // mise à jour
    vnc := baseAmortissable - cumulAnnuite;  // mise à jour

    // affichage période N+1 à N avec N >= 1
    for j := i + 1 to duree do
    begin
      // affichage du tableau d'amortissement linéaire
      StGResultLineaire.RowCount := StGResultLineaire.RowCount + 1;
      StGResultLineaire.Cells[0, j] := IntToStr(j);
      StGResultLineaire.Cells[1, j] := Uutiles.FormaterNombre(annuiteComplete);
      StGResultLineaire.Cells[2, j] := Uutiles.FormaterNombre(vnc);

      cumulAnnuite := cumulAnnuite + annuiteComplete;   // mise à jour
      vnc := baseAmortissable - cumulAnnuite;    // mise à jour
    end;

    // affichage derniere annuite
    cumulAnnuite := cumulAnnuite + annuiteDerniereAnnee - annuiteComplete;
    // mise à jour
    vnc := abs(baseAmortissable - cumulAnnuite);
    // en absolu pour éviter le -0.00 (erreur de virgule)

    StGResultLineaire.RowCount := StGResultLineaire.RowCount + 1;
    StGResultLineaire.Cells[0, duree + 1] := IntToStr(duree + 1);
    StGResultLineaire.Cells[1, duree + 1] :=
      Uutiles.FormaterNombre(annuiteDerniereAnnee);
    StGResultLineaire.Cells[2, duree + 1] := Uutiles.FormaterNombre(vnc);
  end;

  // Afficher le StringGrid
  StGResultLineaire.Visible := True;
end;



end.
