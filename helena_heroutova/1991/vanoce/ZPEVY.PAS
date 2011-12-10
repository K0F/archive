Unit Zpevy;
Interface
uses dos,crt,typy,typyvl;

procedure ChticAbySpal (t : real);
procedure DejBuhStesti (t : real);
function Doba : word;
procedure JakJsiKrasne (t : real);
procedure MyTriKralove (t : real);
procedure Narodil (t : real);
procedure NastavTony;
procedure NesemVamNoviny;
procedure Odmlka;
procedure PasliOvce (t : real);
procedure PujdemSpolu (t : real);
procedure Silent (t : real);
procedure Spust;
procedure StedrejVecer (t : real);

Implementation
  var ton : array [1..69] of word; i : word;
{-----------------------------------------------------------------------------}
procedure NastavTony;
  var i : byte;
  begin
  ton[1] := 64; for i := 1 to 68 do ton[i+1] := round(1.05946309436*ton[i]);
  end;
{-----------------------------------------------------------------------------}
procedure TyzTon (t,k : byte);
  begin
  if not (t in uzbyl) then
    begin nosound; delay (10); dec(t2.s); sound(ton[k]);  end;
  uzbyl := uzbyl + [t];
  end;
{-----------------------------------------------------------------------------}
procedure Spust;
  begin with t1 do gettime (h,m,v,s); konec := false; uzbyl := [] end;
{-----------------------------------------------------------------------------}
function Doba : word;
  begin
  with t2 do gettime (h,m,v,s);
  Doba := 100*(60*(t2.m - t1.m) + t2.v-t1.v) + t2.s - t1.s;
  end;
{-----------------------------------------------------------------------------}
procedure Odmlka; begin nosound; delay (800); end;
{-----------------------------------------------------------------------------}
procedure Silent (t : real);
  begin
  case round(t) of
{c}   133                               : sound(ton[25]);
{d}   131                               : sound(ton[27]);
{e}   7,19,67,91,125                    : sound(ton[29]);
{f}   129                               : sound(ton[30]);
{g}   1,5,13,17,43,61,65,85,89,123,127  : sound(ton[32]);
{a}   4,16,49,59,64,73,83,88            : sound(ton[34]);
{ a}   53,77                            : Tyzton(round(t),34);
{h}   31,34,57,81,107                   : sound(ton[36]);
{c}   37,55,79,109,121                  : sound(ton[37]);
{ c}   41                               : Tyzton(round(t),37);
{d}   25,97,106                         : sound(ton[39]);
{ d}   29,99,101                        : TyzTon (round(t),39);
{e}   115                               : sound(ton[41]);
{f}   103                               : sound(ton[42]);
      140                               : begin nosound; konec:=true end;
  end;
  end;
{-----------------------------------------------------------------------------}
procedure NesemVamNoviny;
  begin
  for j := 1 to 2 do
    begin
    for i := 1 to 2 do
      begin
      sound(ton[37]); delay (pausa[2]); nosound; delay (pausa[7]);
      sound(ton[37]); delay (pausa[3]); sound(ton[34]); delay (pausa[3]);
      sound(ton[39]); delay (pausa[3]); sound(ton[35]); delay (pausa[3]);
      end;
    sound(ton[37]); delay (pausa[2]); sound(ton[34]); delay (pausa[3]);
    sound(ton[37]); delay (pausa[3]); sound(ton[32]); delay (pausa[3]);
    sound(ton[34]); delay (pausa[3]); sound(ton[30]); delay (pausa[1]);
    nosound; delay (pausa[1]);
    end;
  for i := 1 to 2 do
    begin
    sound(ton[30]); delay (pausa[2]); sound(ton[34]); delay (pausa[3]);
    sound(ton[30]); delay (pausa[3]); sound(ton[34]); delay (pausa[3]);
    sound(ton[37]); delay (pausa[3]);
    sound(ton[30]); delay (pausa[2]); sound(ton[34]); delay (pausa[3]);
    sound(ton[30]); delay (pausa[3]); sound(ton[32]); delay (pausa[3]);
    sound(ton[25]); delay (pausa[3]);
    end;
  sound(ton[37]); delay (pausa[2]); sound(ton[34]); delay (pausa[3]);
  sound(ton[37]); delay (pausa[3]); sound(ton[32]); delay (pausa[3]);
  sound(ton[34]); delay (pausa[3]); sound(ton[30]); delay (pausa[1]);
  nosound; delay (pausa[1]); nosound;
  end;
{-----------------------------------------------------------------------------}
procedure ChticAbySpal (t : real);
  begin
  case round(t) of
{c}   1,21,56 : sound(ton[25]);
{d}   2,22,55 : sound(ton[27]);
{e}   3,23,54 : sound(ton[29]);
{f}   4,18,24,48,53 : sound(ton[30]);
{ f}   6,26,38,66,74 : Tyzton(round(t),30);
{g}   7,15,27,35,43,46,50,61,64,68,73 : sound(ton[32]);
{ g}   9,29 : Tyzton(round(t),32);
{a}   10,14,30,34,41,45,47,59,62,65,72 : sound(ton[34]);
{ a}   42,60 : Tyzton(round(t),34);
{b}   13,33,71 : sound(ton[35]);
{ }   76..Maxint : begin nosound; konec:=true end;
  end;
  end;
{-------------------------------------------------------------------------}
procedure PasliOvce (t : real);
  begin
  case round(t) of
{c}   15,25,31 : sound(ton[25]);
{ c}  17 : TyzTon(round(t),25);
{d}   14,22,30 : sound(ton[27]);
{e}   5,13,18,21,23,26,29 : sound(ton[29]);
{ e}  19,27 : TyzTon(round(t),29);
{f}   4,6,12,20,28 : sound(ton[30]);
{g}   2,7,10 : sound(ton[32]);
{ g}  3,11 : TyzTon(round(t),32);
{c}   1,9 : sound(ton[37]);
{ }   33 : begin nosound; konec:=true end;
  end;
  end;
{-------------------------------------------------------------------------}
procedure PujdemSpolu (t : real);
  begin
  case round(t) of
{c}   5,56,88 : sound(ton[25]);
{ c}  7 : Tyzton(round(t),25);
{d}   55,87 : sound(ton[27]);
{e}   54,86 : sound(ton[29]);
{f}   1,13,45,53,57,61,77,85,89,93 : sound(ton[30]);
{ f}  3,15: Tyzton(round(t),30);
{g}   37,49,69,81 : sound(ton[32]);
{ g}  51,83 : Tyzton(round(t),32);
{a}   9,41,59,63,73,91 : sound(ton[34]);
{ a}  11,43,75 : Tyzton(round(t),34);
{b}   33,65 : sound(ton[35]);
{ b}  35,67: Tyzton(round(t),35);
{h}   17,21,25,28 : sound(ton[36]);
{c}   18,20,22,24,26,29,44,76 : sound(ton[37]);
{d}   19,23,27,36,68 : sound(ton[39]);
{ }   96 : begin nosound; konec:=true end;
  end;
  end;
{-------------------------------------------------------------------------}
procedure MyTriKralove (t : real);
  begin
  case round(t) of
{d}   1,20 : sound(ton[27]);
{e}   16,21 : sound(ton[29]);
{fis} 15,22 : sound(ton[31]);
{g}   2,14,23 : sound(ton[32]);
{ g}  4,5 : Tyzton(round(t),32);
{a}   8,17 : sound(ton[34]);
{ a}  10,19 : Tyzton(round(t),34);
{h}   7,11 : sound(ton[36]);
{ }   26 : begin nosound; konec:=true end;
  end;
  end;
{-------------------------------------------------------------------------}
procedure JakJsiKrasne (t : real);
  begin
  case round(t) of
{c}   61 : sound(ton[25]);
{d}   25,59 : sound(ton[27]);
{ d}  27 : Tyzton(round(t),27);
{e}   1,17,29,39,55,60 : sound(ton[29]);
{ e}  3,19,31 : Tyzton(round(t),29);
{f}   9,28,41,57 : sound(ton[30]);
{ f}  11,43 : Tyzton(round(t),30);
{g}   5,13,21,37,53 : sound(ton[32]);
{ g}  7,15,23,45 : Tyzton(round(t),32);
{a}   12,44 : sound(ton[34]);
{c}   33,49 : sound(ton[37]);
{ }   64 : begin nosound; konec:=true end;
  end;
  end;
{-----------------------------------------------------------------------------}
procedure DejBuhStesti (t : real);
  begin
  case round(t) of
{f}   15,31,39,47,63 : sound(ton[30]);
{g}   13,29,34,42,61 : sound(ton[32]);
{a}   7,11,23,27,33,35,41,43,55,60 : sound(ton[34]);
{b}   36,44,59 : sound(ton[35]);
{c}   1,5,9,17,21,25,37,45,49,53,57 : sound(ton[37]);
{d}   3,19,51: sound(ton[39]);
{ }   65 : begin nosound; konec:=true end;
  end;
  end;
{-------------------------------------------------------------------------}
procedure StedrejVecer (t : real);
  begin
  case round(t) of
{f}   1,9,28,36 : sound(ton[30]);
{g}   7,21,34 : sound(ton[32]);
{a}   3,6,13,25,30,33 : sound(ton[34]);
{ a}  26 : Tyzton(round(t),34);
{b}   5,18,23,32 : sound(ton[35]);
{ b}  19,24 : Tyzton(round(t),35);
{c}   15,27 : sound(ton[37]);
{ c}  17 : Tyzton(round(t),37);
{d}   20 : sound(ton[39]);
{ }   40 : begin nosound; konec:=true end;
  end;
  end;
{-------------------------------------------------------------------------}
procedure Narodil (t : real);
  begin
  case round(t) of
{f}   1,57,77,93,113: sound(ton[30]);
{ f}   3,97: Tyzton(round(t),30);
{g}   4,45,55,67,83,111: sound(ton[32]);
{a}   5,41,49,53,65,69,81,85,109: sound(ton[34]);
{ a}   43: Tyzton(round(t),34);
{b}   37,51,71,87,93,107: sound(ton[35]);
{ b}   39: Tyzton(round(t),35);
{h}   7,17: sound(ton[36]);
{c}   9,19,25,33,73,89,105: sound(ton[37]);
{ c}   11,13,35: Tyzton(round(t),37);
{d}   21,101: sound(ton[39]);
{ }    29,61,117 : nosound;
121: begin nosound; konec:=true end;
  end;
  end;
{-------------------------------------------------------------------------}
end.