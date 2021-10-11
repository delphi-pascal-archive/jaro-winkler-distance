unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Math;

type
  TForm1 = class(TForm)
    Button1: TButton;
    Memo1: TMemo;
    Label1: TLabel;
    Label2: TLabel;
    Memo2: TMemo;
    Label3: TLabel;
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

function JaroWinkler(prmT1, prmT2: String;p:Double=0.1): Double;
Var
ecartMax,l1,l2,compteMatching,compteTransposition,longueurPrefix,i,j:integer;
c1,c2,t1Matche,t2Matche:string;
b1,b2:array of Boolean;
distanceJaro:Double;
label endfor,exitfor2;
  function  TrouverMatches(prmTextInitial:string;b1:array of Boolean):string;
  var
  i:integer;
  res:string;
  begin
  // Calcule le nombre de caracteres qui match
    for i := 1 to Length(prmTextInitial) do
    begin
      if b1[i] then//prmTextMatche[i]='_' then
      begin
        res:=res+prmTextInitial[i];
      end;
    end;
  TrouverMatches:=res;
  end;
begin
 ecartMax:=round(Max(Length(prmT1), Length(prmT2))/2)-1;
 if ((prmT1='') or (prmT2='')) then
 begin
  JaroWinkler:=0;
  exit;
 end;
 compteMatching:=0;
 compteTransposition:=0;
 l1:=Length(prmT1);
 l2:=Length(prmT2);
 Setlength(b1,l1+1);
 Setlength(b2,l2+1);
 for i := 0 to l1 do
 begin
  b1[i]:=false;
 end;
 for i := 0 to l2 do
 begin
  b2[i]:=false;
 end;

 for i := 1 to l1 do
 begin
  c1:=prmT1[i];
  if (i<=l2) then
    c2:=prmT2[i]
  else
    c2:='';
  for j := Max(i-ecartMax,1) to Min(i+ecartMax,l2) do
  begin
    c2:=prmT2[j];
    if c1=c2 then //compteMatching avec transposition
    begin
     b1[i]:=true;
     b2[j]:=true;
     //Le caractere a ete matche, il n'est plus disponible
     Inc(compteMatching);
     break;
    end;
  end;
 end;
 if (compteMatching=0) then
 begin
  JaroWinkler:=0;
  exit;
 end;
 //Dans les caracteres matches, compte ceux qui ne matchent pas exactement
 t1Matche:=TrouverMatches(prmT1,b1);
 t2Matche:=TrouverMatches(prmT2,b2);
 if t1Matche<>t2Matche then
 begin
  for i := 1 to length(t1Matche) do
  begin
    if t1Matche[i]<>t2Matche[i] then
      Inc(compteTransposition)
  end;
 end else begin
   compteTransposition:=0;
 end;

 distanceJaro:=1/3*((compteMatching/l1)+(compteMatching/l2)+((compteMatching-Int(compteTransposition/2))/compteMatching));

 //Calcule la distance Winkler
 //Calcule le prefix sur les 4 premiers car aux max
 longueurPrefix:=0;
 for i := 1 to min(4,min(l1,l2)) do
 begin
  c1:=prmT1[i];
  c2:=prmT2[i];
  if c1=c2 then
    inc(longueurPrefix)
  else
  break;
 end;
 //Valeur constante definie par l'algo
 JaroWinkler:=distanceJaro+(longueurPrefix*p*(1-distanceJaro));
end;

procedure TForm1.Button1Click(Sender: TObject);
begin
 Label3.Caption:='Distance: '+FormatFloat('0.0%',JaroWinkler(Memo1.Text, Memo2.Text,0.1)*100);
end;

end.
