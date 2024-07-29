unit Uutiles;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, MaskEdit, Dialogs, StdCtrls;

// Déclarations des fonctions
function FormaterNombre(Nombre: double): string;
procedure FormaterEtAfficher(Nombre: double; var AfficherLabel: TLabel);
function RecupererJour(MaskEdit: TMaskEdit): integer;
function RecupererMois(MaskEdit: TMaskEdit): integer;
function RecupererAnnee(MaskEdit: TMaskEdit): integer;
function VerifierDate(MaskEdit: TMaskEdit): boolean;
function EstBissextile(MaskEdit: TMaskEdit): boolean;

implementation

// création fonction : retourne un texte formaté (1 600 000.00 MGA par ex) au lieu d'un nombre
function FormaterNombre(Nombre: double): string;
begin
  // Formater le nombre avec des espaces comme séparateurs de milliers
  Result := FormatFloat('# ### ##0.00', Nombre) + ' MGA';
end;

// procédure pour formater nombre l'affecter dans un Label
procedure FormaterEtAfficher(Nombre: double; var AfficherLabel: TLabel);
var
  FormatteNombre: string;
begin
  // Formater le nombre avec des espaces comme séparateurs de milliers
  FormatteNombre := FormatFloat('# ### ##0.00', Nombre);

  // Afficher le nombre formaté dans le label
  AfficherLabel.Caption := FormatteNombre + ' MGA';
end;

// fonction pour récupérer le jour d'un TMaskEdit
function RecupererJour(MaskEdit: TMaskEdit): integer;
var
  JourStr: string;
  Jour: integer;
begin
  JourStr := Trim(Copy(MaskEdit.Text, 1, 2));
  if JourStr = '' then
  begin
    ShowMessage('Jour invalide.');
    Exit(0);
  end;

  try
    Jour := StrToInt(JourStr);
    if (Jour < 1) or (Jour > 31) then
    begin
      ShowMessage('Le jour doit être compris entre 1 et 31.');
      Exit(0);
    end;
    Result := Jour;
  except
    on E: EConvertError do
    begin
      ShowMessage('Jour invalide.');
      Exit(0);
    end;
  end;
end;

// fonction pour récupérer le mois d'un TMaskEdit
function RecupererMois(MaskEdit: TMaskEdit): integer;
var
  MoisStr: string;
  Mois: integer;
begin
  MoisStr := Trim(Copy(MaskEdit.Text, 4, 2));
  if MoisStr = '' then
  begin
    ShowMessage('Mois invalide.');
    Exit(0);
  end;
  try
    Mois := StrToInt(MoisStr);
    if (Mois < 1) or (Mois > 12) then
    begin
      ShowMessage('Le mois doit être compris entre 1 et 12.');
      Exit(0);
    end;
    Result := Mois;
  except
    on E: EConvertError do
    begin
      ShowMessage('Mois invalide.');
      Exit(0);
    end;
  end;
end;

// fonction pour récupérer l'année d'un TMaskEdit
function RecupererAnnee(MaskEdit: TMaskEdit): integer;
var
  AnneeStr: string;
  Annee: integer;
begin
  AnneeStr := Trim(Copy(MaskEdit.Text, 7, 4));
  if AnneeStr = '' then
  begin
    ShowMessage('Année invalide.');
    Exit(0);
  end;
  try
    Annee := StrToInt(AnneeStr);
    if (Annee < 0) then
    begin
      ShowMessage('L''année doit être positive.');
      Exit(0);
    end;
    Result := Annee;
  except
    on E: EConvertError do
    begin
      ShowMessage('Année invalide.');
      Exit(0);
    end;
  end;
end;

// fonction pour vérifier la validité de la date
function VerifierDate(MaskEdit: TMaskEdit): boolean;
var
  jour, mois, annee: integer;
  joursDansMois: array[1..12] of integer;
begin
  jour := RecupererJour(MaskEdit);
  mois := RecupererMois(MaskEdit);
  annee := RecupererAnnee(MaskEdit);

  // Initialiser le nombre de jours pour chaque mois
  joursDansMois[1] := 31;  // Janvier
  joursDansMois[2] := 28;  // Février (sera ajusté si bissextile)
  joursDansMois[3] := 31;  // Mars
  joursDansMois[4] := 30;  // Avril
  joursDansMois[5] := 31;  // Mai
  joursDansMois[6] := 30;  // Juin
  joursDansMois[7] := 31;  // Juillet
  joursDansMois[8] := 31;  // Août
  joursDansMois[9] := 30;  // Septembre
  joursDansMois[10] := 31; // Octobre
  joursDansMois[11] := 30; // Novembre
  joursDansMois[12] := 31; // Décembre

  // Ajuster février pour les années bissextiles
  if EstBissextile(MaskEdit) then
    joursDansMois[2] := 29;

  Result := (Length(MaskEdit.Text) = 10) and
            (jour <> 0) and (mois <> 0) and (annee <> 0) and
            (jour <= joursDansMois[mois]);

  if not Result then
  begin
    if jour > joursDansMois[mois] then
      ShowMessage(Format('Le mois %d n''a que %d jours.', [mois, joursDansMois[mois]]))
    else
      ShowMessage('Insérer une date valide (jj/mm/aaaa).');
  end;
end;

// vérifier année bissextile
function EstBissextile(MaskEdit: TMaskEdit): boolean;
var
  annee: integer;
begin
  annee := RecupererAnnee(MaskEdit);
  Result := (annee mod 4 = 0) and ((annee mod 100 <> 0) or (annee mod 400 = 0));
end;

end.
