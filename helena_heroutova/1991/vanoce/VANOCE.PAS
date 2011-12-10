program Vanoce;
uses dos,crt,graph,typy,typyvl,pomucky,matika,grafika,zpevy,obrazky,kresleni;
const n = 300;
var snih : array [0..n] of PointType;
{---------------------------------------------------------------------------}
procedure PlochaSnehu (b,v : integer);
 var l : shortint;
  begin
  for l := -5 to 5 do fillellipse (b + random(21)*l,zem + random(103),v,v);
  end;
{-----------------------------------------------------------------------------}
procedure Snezi (p : boolean);
  begin
  setcolor (white); setfillstyle (1,white); konec := false;
  for i := 1 to n do with snih[i] do
    begin
    x := Random(maxx); y := round(zem*i/n);
    if not p and (getpixel(x,y)=green) then
     begin
     j := 9+random(6); setcolor (j); setfillstyle (1,j); fillellipse (x,y,3,3);
     j := 9+random(6); setcolor (j); setfillstyle (1,j); fillellipse (x,y+10,3,3);
     y := 0; setcolor (white); setfillstyle (1,white); 
     end
    else if p and (getpixel(x,y) in [green,brown,yellow]) then
     begin fillellipse (x,y,2,2); y := 0; x := Random(maxx) end
    else begin putpixel (x,y,white); delay (200) end;
    end;
  k := 1;
  repeat
   for i := 1 to n do with snih[i] do
     begin
     j := getpixel(x,y+1);
     if j in [1..7,15] then
      begin
      if (getpixel(x,y+1)=15) and (getpixel(x+2,y+1)<8) then
        begin inc(x); inc(y) end
      else if (getpixel(x,y+1)=15) and (getpixel(x-2,y+1)<8) then
        begin dec(x); inc(y) end
      else
        begin
        if p then PlochaSnehu (x,k div n);
        fillellipse (x,y,2,2); y := 0; x := Random(maxx)
        end;
      end;
     if j in [9..15] then j := 0;
     putpixel (x,y,j); inc(y); putpixel (x,y,white); delay (3)
     end;
   if p then
     begin
     if k=3*n then Spust;
     if k>3*n then Silent (Doba/pausa[7]);
     end
   else
    begin
    if k=5 then Spust;
    if k>5 then Narodil (Doba/pausa[7]);
    if konec and not keypressed then begin konec := false; k := 0 end;
    end; inc(k);
  until keypressed or konec; Odmlka;
  end;
{---------------------------------------------------------------------------}
procedure Prani;
  begin
  bar (0,zem,maxx,maxy); setbkcolor (yellow); settextstyle (3,0,7);
  setcolor (red); Outtextxy(getmaxx div 2,60,'Vesel‚ v noce');
  NesemVamNoviny;
  setcolor (black); Outtextxy(getmaxx div 2,60,'Vesel‚ v noce');
  setbkcolor (black); settextstyle (0,0,1);
  end;
{---------------------------------------------------------------------------}
function Kx(r:byte) : word; begin Kx := round (300 - r*cos (Pi*i/36)) end;
function Ky(r:byte) : word; begin Ky := round (320 - r*sin (Pi*i/36)) end;
{---------------------------------------------------------------------------}
procedure Paprsek (b,i : byte);
  begin
  setcolor (b); r1 := 90 + random (10); r2 := 90 + random (100);
  line (Kx(r1),Ky(r1),Kx(r2),Ky(r2));
  end;
{---------------------------------------------------------------------------}
function Px (j,k : word) : integer; begin Px := u[j].x+stt[j]-k end;
function Po (j,k : word) : boolean;
  begin Po := (k>stt[j]) and (k-stt[j]<u[j].x-cu[j].x)  end;
function Pc (j,k : word) : boolean; begin Pc := k-stt[j]=u[j].x-cu[j].x end;
function Pk (j : byte) : boolean; begin Pk := k>stt[j]+u[j].x-cu[j].x end;
function Py (j,k : word) : word;
  begin
  Py := cu[j].y +
        round((u[j].y-cu[j].y)*sqrt((Px(j,k)-cu[j].x)/(u[j].x-cu[j].x)))
  end;
{---------------------------------------------------------------------------}
procedure Zare;
  begin
  i := random (37); Paprsek (black,i); Paprsek (yellow,i);
  putpixel (Kx(200)+random(50)-25,Ky(200)+random(50)-25,9+random(6));
  end;
{---------------------------------------------------------------------------}
procedure Betlem;
 var z,l : word;
  begin
  Odmlka; z := zem - 22; Spust;
  repeat Zare; ChticAbySpal (Doba/pausa[6]) until konec;
  VymysliDedu (u[1],pa0[1],pa1[1]);
  pa1[6] := pa1[1]; pa0[6] := pa0[1]; u[6] := u[1];
  k := 0;
  repeat
    inc (k); Zare;
    if k>stt[2] then PasliOvce (Doba/pausa[7]);
    for j := 1 to 6 do
     if Po(j,k) then putimage (Px(j,k),Py(j,k),pa1[j]^,normalput)
     else if Pc(j,k) and (j in [1,6]) then
       begin
       putimage (cu[j].x+3,cu[j].y,pa0[j]^,normalput);
       DejUzlik (220+10*j,z,j);
       end;
    if k=stt[2] then
     begin
     VymysliOvecku (u[2],pa0[2],pa1[2]);
     for l := 3 to 5 do
       begin pa1[l] := pa1[2]; pa0[l] := pa0[2]; u[l] := u[2] end;
     dec (u[3].y,10); dec (u[5].y,10); Spust;
     end; if konec and not Pk(6) then begin konec := false; Spust end;
  until konec and Pk(6);   
  Odmlka; VymysliBabu (u[7],pa0[7],pa1[7]); k := stt[7]; Spust;
  repeat
    Zare; PujdemSpolu (Doba/pausa[7]);
    if Po(7,k) then putimage (Px(7,k),Py(7,k),pa1[7]^,normalput)
    else if px(7,k)<cu[7].x then
     begin
     putimage (cu[7].x,cu[7].y,pa0[7]^,normalput); DejNusi (240,z+3,6)
     end; inc(k);
  until konec;                               
  Odmlka; VymysliKrale (u[8],pa0[8],pa1[8]);
  for l := 9 to 10 do
    begin pa1[l] := pa1[8]; pa0[l] := pa0[8]; u[l] := u[8] end;
  inc (u[9].y,10);
  k := stt[8]; Spust;
  repeat
    Zare; MyTriKralove (Doba/pausa[7]);
    for j := 8 to 10 do
     if Po(j,k) then putimage (Px(j,k),Py(j,k),pa1[j]^,normalput)
     else if Pc(j,k) then
       begin
       putimage (cu[j].x,cu[j].y,pa0[j]^,normalput);
       DejTruhlu (210+15*j,z+7-18*ord(j=9),2+j)
       end; inc(k);
    if konec and not Pk(10) then begin konec := false; Spust end;
  until konec and Pk(10); Odmlka; Spust;
  repeat Zare; JakJsiKrasne (Doba/pausa[7]) until konec; Odmlka;
  end;
{-------------------------------------------------------------------------------}
procedure Rozchod;
  const por : array[1..10] of byte = (3,4,5,1,2,6,7,8,9,10);
  begin
  for j := 1 to 10 do u[j] := cu[j];
  Spust; j := 1;
  repeat with u[por[j]] do begin
    Zare; DejBuhStesti (Doba/pausa[7]);
    if x>0 then dec(x); inc(y);
    if (j<10) and (y>maxy) then inc(j);
    if y<=maxy then putimage (x,y,pa0[por[j]]^,normalput);
  end; until konec and (j=10);
  Odmlka; Vymyslialtan (brown); outtextxy(310,300,'ALTN'); Vymyslikmen;
  for j := 1 to 3 do
    begin
    if j<3 then DejUzlik (50+20*j,zem,j) else DejNusi (45,zem,6);
    DejTruhlu (80+16*j,zem+7-18*ord(j=2),9+j)
    end; Spust;
  for k := 1 to n do
    begin
    with snih[k] do putpixel (x,y,black); StedrejVecer (Doba/pausa[7]);
    end;
  repeat
    i := random(37); Paprsek (0,i); StedrejVecer (Doba/pausa[7])
  until konec;
  Vymyslialtan (brown); OutTextXY (310,300,'ALTN');
  end;
{-------------------------------------------------------------------------------}
begin
nosound; randomize; NastavTony; konec := false;
OtevriGraf; settextjustify (1,1);
maxx := getmaxx; maxy := getmaxy; zem := round(0.8*maxy);
Vymyslialtan (brown); OutTextXY (300,300,'ALTN'); Vymyslikmen; VymysliStrom;
setfillstyle (1,green); bar (0,zem,maxx,maxy); delay (4000);
Snezi (true); Prani;
Vymyslialtan (yellow); VymysliJesle; VymysliMarii; VymysliJosefa; Betlem;
Rozchod; Snezi (false); ch := readkey; nosound; ZavriGraf;
Vizitka(true);
end.