Unit Grafika;
Interface
uses rozmery,typy,graph,matika;
type RealBody  =  array [1..10] of RealBod;
const dil : pointtype = (x:8;y:18);

procedure Cesky (x,y : integer; t : string);
procedure Elipsa (P1,P2,P3,P4,alfa,sx,sy : real);
function KBx (x : real) : integer;
function KBy (y : real) : integer;
procedure KresliBod (x,y : real; ch : char; barva : byte);
procedure KresliOsy (sirka,x,y : byte; jm1,jm2,je1,je2 : jmeno);
procedure OtevriGraf;
procedure ZakresliStredy (p1,p2 : real; b : integer; t : byte);
procedure ZavriGraf;

Implementation
  uses dos,crt,typyvl,win,provse,pomucky;
{-----------------------------------------------------------------------------}
procedure OtevriGraf;
  var i,mode : integer;
  begin
  karta := 0; detectgraph (karta,mode);
  InitGraph (karta,mode,'c:\tp\bgi'); i := graphresult;
  if i<>grOK then
    begin
    clrscr; stred (10,grapherrormsg(i),'');
    detectgraph (karta,mode); InitGraph (karta,mode,''); i := graphresult;
    if i<>grOK then
      begin
      stred (12,grapherrormsg(i),''); readln; halt end;
    end;
  roh.x := GetMaxX div dil.x; roh.y := GetMaxY div dil.y; setbkcolor (0);
  end;
{-----------------------------------------------------------------------------}
function KBx (x : real) : integer;
  begin KBx := round ((x - min.x)*id.x/d.x + roh.x) end;
{-----------------------------------------------------------------------------}
function KBy (y : real) : integer;
  begin KBy := round ((max.y - y)*id.y/d.y + roh.y) end;
{-----------------------------------------------------------------------------}
procedure KresliOsy (sirka,x,y : byte; jm1,jm2,je1,je2 : jmeno);
 var p : real; bod : pointtype; v : byte;
 {Kdy‘ nechci osu z matice dat, zad m x resp. y = 0 a min a max vypo‡tu d©¡v.}
  begin
  if x>0 then minmax (x,min.x,max.x); if y>0 then minmax (y,min.y,max.y);
  osy (dil.y*2 div 3*roh.y,min.y,max.y,d.y,id.y);
  osy (sirka*roh.x,min.x,max.x,d.x,id.x);
  v := textHeight('M'); clearviewport; setcolor (white);
  settextjustify (lefttext,toptext);
  if je2<>'' then
    OutTextXY (roh.x-4*v,roh.y-2*v,jm2+' ['+je2+']')
  else OutTextXY (roh.x-4*v,roh.y-2*v,jm2);
  settextjustify (righttext,bottomtext);
  if je1<>'' then
    OutTextXY ((sirka+1)*roh.x,KBy(min.y)+4*v,jm1+' ['+je1+']')
  else OutTextXY ((sirka+1)*roh.x,KBy(min.y)+4*v,jm1);
  setcolor (white); rectangle (roh.x,roh.y,KBx(max.x),KBy(min.y));
  if (0>min.y) and (0<max.y) then line (roh.x,KBy(0),KBx(max.x),KBy(0));
  if (0>min.x) and (0<max.x) then line (KBx(0),roh.y,KBx(0),KBy(min.y));
  p := min.y; settextjustify (righttext,centertext);
  repeat
    Bod.x := KBx(min.x); bod.y := KBy(p);
    with bod do begin outtextxy (x-v,y,Format(p)); line (x-v div 2,y,x,y); end;
    p := p + d.y;
  until p>max.y;
  p := min.x; settextjustify (centertext,toptext);
  repeat
    Bod.x := KBx(p); bod.y := KBy(min.y);
    with bod do begin outtextxy (x,y+v,Format(p)); line (x,y+v div 2,x,y) end;
    p := p + d.x;
  until p>max.x;
  end;
{-----------------------------------------------------------------------------}
procedure KresliBod (x,y : real; ch : char; barva : byte);
 var o : TextSettingsType;
  begin
  setcolor (barva);
  if ch='.' then circle (KBx(x),KBy(y),2)
  else
   begin
   gettextsettings (o); SetTextStyle(0,o.direction,1);
   settextjustify (centertext,centertext);
   outtextxy (KBx(x),KBy(y),ch);
   SetTextStyle(o.font,o.direction,o.charsize); SetTextJustify(o.horiz,o.vert);
   end;
  end;
{-----------------------------------------------------------------------------}
procedure Elipsa (P1,P2,P3,P4,alfa,sx,sy : real);
  var uhel : word; x,y,x1,y1 : real;
  begin
  moveto(KBx(P1+sx),KBy(P3+sy));
  for uhel := 1 to 180 do
    begin
    alfa := pi/90*uhel;
    x := P1*cos(alfa)+P2*sin(alfa)+sx; y := P3*cos(alfa)+P4*sin(alfa)+sy;
    x1 := minr (x,max.x); x1 := maxr (x1,min.x);
    y1 := minr (y,max.y); y1 := maxr (y1,min.y);
    if (x1=x) and (y1=y) then lineto(KBx(x1),KBy(y1))
                         else moveto(KBx(x1),KBy(y1))
    end;
  end;
{-----------------------------------------------------------------------------}
procedure Cesky (x,y : integer; t : string);
 const carky = ' ‚¡¢£˜‹•—ˆ¨‡©‘ƒŸ¤‰›€ž’…†¥–¦';
       cs : string = 'aeiouyAEIOUYescrydtnESCRZDTNuU';
 var i,j : byte; u : string;
  begin
  u := ''; for i := 1 to length(t) do u := u + ' ';
  for i := 1 to length(t) do
    begin
    j := pos (t[i],carky); if j>0 then t[i] := cs[j];
    case j of
     1..12 : u[i] := '/'; 13..28 : u[i] := 'v'; 29,30  : u[i] := 'o'; end;
    end;
  outtextxy (x,y,t); outtextxy (x,y-4,u);
  end;
{-----------------------------------------------------------------------------}
procedure ZakresliStredy (p1,p2 : real; b : integer; t : byte);
  var bod : PointType; ch : string[2];
  begin
  str (t,ch); settextjustify (centertext,centertext);
  case karta of
     CGA : setfillstyle (b,2);
     EGA,VGA : setfillstyle (1,b);
    end;
  with bod do begin x := KBx(p1); y := KBy(p2); outtextxy (x,y,ch) end;
  end;
{-----------------------------------------------------------------------------}
procedure ZavriGraf; begin  Closegraph; Kurzor (zmiz) end;
{-----------------------------------------------------------------------------}
end.
