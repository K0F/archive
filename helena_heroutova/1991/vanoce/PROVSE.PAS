Unit ProVse;
Interface
uses typy;

function CI (str : string) : Longint;
procedure CistiTv (var tv : PoleVoleb);
function Coje : char;
function CP (str : string) : real;
function DbW(txt : string) : string;
function DoL(txt : string) : string;
function DoW(txt : string) : string;
function Format (x : real) : polozka;
procedure Hraj (pisen : string);
function KolikVoleb (Menu : PoleVoleb) : byte;
procedure Kurzor (NewCursor : Integer);
function log (x : real) : real;
function maxi (x,y : longint) : longint;
function maxr (x,y : real) : real;
function mini (x,y : longint) : longint;
function minr (x,y : real) : real;
function moc (x : real; na : integer) : real;
function Mohutnost (m : mnozina) : byte;
procedure NastavTony;
procedure Pockej;
function podtrh (delka : byte; cim : char) : string;
function PosledniV (m : mnozina) : byte;
function PrvniV (m : mnozina) : byte;
procedure Spust (prog,param : string);
procedure Teplomer (radek,pocet : word; var dil : real);
procedure Teplota (radek,cast : word; dil : real);
function UlozKurz : Integer;

Implementation
uses dos,crt,Rozmery,win;
var ton : array[1..69] of word;
{-----------------------------------------------------------------------------}
function log (x : real) : real; begin log := ln(x)/ln(10) end;
{-----------------------------------------------------------------------------}
function moc (x : real; na : integer) : real;
  begin
  case na of
    0           : moc := 1;
    1..maxint   : moc := x * moc(x,na-1);
    -maxint..-1 : moc := moc(x,na+1)/x;
    end;
  end;
{-----------------------------------------------------------------------------}
function maxi (x,y : longint) : longint;
   begin if x<y then maxi := y else maxi := x end;
{-----------------------------------------------------------------------------}
function mini (x,y : longint) : longint;
  begin if x>y then mini := y else mini := x end;
{-----------------------------------------------------------------------------}
function maxr (x,y : real) : real;
  begin if x<y then maxr := y else maxr := x end;
{-----------------------------------------------------------------------------}
function minr (x,y : real) : real;
  begin if x>y then minr := y else minr := x end;
{-----------------------------------------------------------------------------}
function CP (str : string) : real;
 var u : real; i : integer;
  begin
  i := pos(',',str); if i>0 then str[i] := '.';
  val (str,u,i); if i<>0 then CP := 0 else CP := u
  end;
{-----------------------------------------------------------------------------}
function CI (str : string) : Longint;
 var u : Longint; i : integer;
  begin
  while str[1]=' ' do delete(str,1,1);
  val (str,u,i); if i<>0 then CI := 0 else CI := u
  end;
{-----------------------------------------------------------------------------}
function Mohutnost (m : mnozina) : byte;
 var i,v : byte;
  begin
  v := 0; for i := 0 to 255 do if i in m then inc(v); Mohutnost := v;
  end;
{-----------------------------------------------------------------------------}
function PrvniV (m : mnozina) : byte;
 var v : byte;
  begin v := 0; while not (v in m) do inc(v); PrvniV := v; end;
{-----------------------------------------------------------------------------}
function PosledniV (m : mnozina) : byte;
 var v : byte;
  begin v := 255; while not (v in m) do dec(v); PosledniV := v; end;
{-----------------------------------------------------------------------------}
function Format (x : real) : polozka;
  var znaky : string; zapor : boolean; i,c,w,t : integer;
  begin
  zapor := x<0; str (x,znaky); if zapor then delete (znaky,1,1);
  while znaky[1]=' ' do  delete (znaky,1,1);
  w := pos('E',znaky); t := pos('.',znaky);
  val (copy(znaky,w+1,3),c,i); delete (znaky,w,4);
  val (znaky,x,i); str (x:11:9,znaky);
  if c>0 then begin delete (znaky,t,1); inc (t,c); insert ('.',znaky,t) end
  else if c<0 then
    begin
    delete (znaky,t,1); for i := 1 to abs(c)-1 do insert ('0',znaky,1);
    insert ('0.',znaky,1)
    end;
  repeat dec(znaky[0]) until znaky[length(znaky)]<>'0';
  if znaky[length(znaky)]='.' then dec(znaky[0]);
  if zapor then Format := '-'+znaky else Format := znaky;
  end;
{-----------------------------------------------------------------------------}
function podtrh (delka : byte; cim : char) : string;
   var cara : string; i : byte;
   begin
   cara := ''; for i := 1 to delka do cara := cara + cim; podtrh := cara
   end;
{----------------------------------------------------------------------------}
function Coje : char;
 var z : char;
  begin
  z := readkey; if z=ridici then z := readkey; OK := z in [Esc,Enter];
  CoJe := z;
  end;
{-----------------------------------------------------------------------------}
procedure Pockej;
 var z : char;
  begin z := readkey; if z=ridici then z := readkey; OK := z=Esc; end;
{-----------------------------------------------------------------------------}
procedure CistiTv (var tv : PoleVoleb);
 var i : byte; begin for i := 1 to 20 do tv[i] := ''; end;
{-----------------------------------------------------------------------------}
function KolikVoleb (Menu : PoleVoleb) : byte;
 var i : byte;
  begin
  i := 0; repeat inc(i) until (i=20) or (Menu[i+1]=''); KolikVoleb := i;
  end;
{-----------------------------------------------------------------------------}
procedure Teplomer (radek,pocet : word; var dil : real);
  begin
  if pocet=0 then Exit;
  dil := 50/pocet; writechar (15,radek,round(pocet*dil),cara1[2],11)
  end;
{-----------------------------------------------------------------------------}
procedure Teplota (radek,cast : word; dil : real);
  begin writechar (15,radek,round(cast*dil),cara2[2],12);  end;
{-----------------------------------------------------------------------------}
procedure Kurzor (NewCursor : Integer);
 var Reg : Registers;
 begin with Reg do
  begin AH := 1; BH := 0; CX := NewCursor; Intr($10, Reg);  end;
 end;
{----------------------------------------------------------------------------}
function UlozKurz : Integer;
 var Reg : Registers;
 begin with Reg do
  begin AH := 3; BH := 0; Intr($10, Reg); UlozKurz := CX; end;
 end;
{----------------------------------------------------------------------------}
function DoW(txt : string) : string;
 const  abc = ' ‚¡¢£–˜‘¨‡©ƒŸ¤ˆ‹•—¦’›€ž…†¥‰„”';
        tbc : string = #225#233#237#243#250#249#253#158#154#232#248#239#157+
        #242#236#193#201#205#211#218#249#221#142#138#200#216#207#141#210#204+
        #251#228#246;
 var i : byte;
  begin
  for i := 1 to length(txt) do if pos(txt[i],abc)>0 then
    txt[i] := tbc[pos(txt[i],abc)]; Dow := txt;
  end;
{-----------------------------------------------------------------------------}
function DbW(txt : string) : string;
 const  abc = ' ‚¡¢£–˜‘¨‡©ƒŸ¤ˆ‹•—¦’›€ž…†¥‰';
        tbc : string = #160#130#161#162#163#133#236#167#231#159#253#212#156+
        #229#216#181#144#214#224#233#222#237#166#230#172#252#210#155#213#183;
 var i : byte;
  begin
  for i := 1 to length(txt) do if pos(txt[i],abc)>0 then
    txt[i] := tbc[pos(txt[i],abc)]; Dbw := txt;
  end;
{-----------------------------------------------------------------------------}
function DoL(txt : string) : string;
 const  abc = ' ‚¡¢£˜–ˆ‹•—¦‰¨‡©‘ƒŸ¤›€ž’…†¥';
        tbc : string = #160#130#161#162#163#236#133#216#181#144#214#224#233+
        #237#222#183#231#159#253#167#212#156#229#230#172#252#166#210#155#213;
 var i : byte;
  begin
  for i := 1 to length(txt) do if pos(txt[i],abc)>0 then
    txt[i] := tbc[pos(txt[i],abc)]; Dol := txt;
  end;
{-----------------------------------------------------------------------------}
procedure Spust (prog,param : string);
  var c : string[2];
  const chyby : polevoleb = ('','Soubor nenalezen','Cesta nenalezena','',
    'P©¡stup nemo‘n˜','Neplatn˜ handl (TurboVision)','','Nesta‡¡ pamˆŸ','',
    'Neplatn˜ © dek v Command.com','Neplatn˜ form t','','','','','','',
    'Nejsou dal¨¡ soubory','','');
  begin
  SwapVectors; Exec(prog,param); SwapVectors;
  if DosError<>0 then
   begin
   clrscr; str (DosError,c);
   stred (11,'Dos error #'+c+' - '+chyby[DosError]+'.','');
   stred (13,'Zapi¨te hl ¨en¡ a ohla¨te.',''); pockej; clrscr;
   end;
  end;
{----------------------------------------------------------------------------}
procedure NastavTony;
  var i : byte;
  begin
  ton[1] := 64; for i := 1 to 68 do ton[i+1] := round(1.05946309436*ton[i]);
  end;
{-----------------------------------------------------------------------------}
procedure Hraj (pisen : string);
  var k : integer; dli,okt : byte;

   procedure Klimp (k : byte);
    begin
    sound(ton[k]); delete (pisen,1,1); delay (5120 div dli);
    nosound; delay (40);
    end;

  begin
  repeat
   case pisen[1] of
     'C'   : Klimp (13+12*okt);
     'c'   : Klimp (14+12*okt);
     'D'   : Klimp (15+12*okt);
     'd'   : Klimp (16+12*okt);
     'E'   : Klimp (17+12*okt);
     'F'   : Klimp (18+12*okt);
     'f'   : Klimp (19+12*okt);
     'G'   : Klimp (20+12*okt);
     'g'   : Klimp (21+12*okt);
     'A'   : Klimp (22+12*okt);
     'B'   : Klimp (23+12*okt);
     'H'   : Klimp (24+12*okt);
     'L'   : begin val (copy(pisen,2,2),dli,k); delete (pisen,1,3); end;
     'O'   : begin val (copy(pisen,2,1),okt,k); delete (pisen,1,2); end;
     ' '   : delete (pisen,1,1);
    end;
   until pisen='';
  end;
{-----------------------------------------------------------------------------}
end.
