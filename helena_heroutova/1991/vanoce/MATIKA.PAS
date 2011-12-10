Unit Matika;
Interface
uses rozmery,typy,graph;

type VekRad    =  array [1..MaxPocet] of real;
     matice    =  array [1..MaxPocet,1..MaxPocet] of real;
     mat       =  file of real;
     RealBod   =  record x,y : real end;
var  id,roh  : PointType;
     min,max,d : RealBod;
     titl : array [1..2] of VJmen;
     fr  : mat;

{procedure CtiDbfRady (f : dbchar; co : mnozina);
}
procedure CtiRady (prip : jmeno);
function Determinant (var a : matice; n : byte) : real;
procedure Eigen (cor : matice; var l : VekRad; var y : matice);
procedure Invmat (var c : matice; m : byte);
procedure KorelacniMatice (var kor: matice; var pr,sm : VekRad);
procedure KovariancniMatice (var kov: matice; var pr,sm : VekRad);
procedure MinMax (vek : byte; var min,max : real);
procedure Osy (n:word; var min,max,dy:real; var idy:integer);
procedure Osy2 (nx,ny : word);
procedure PrumerSmerOdch (y : byte; var pr,so : real);
function Rx (var fr : mat; i,j : word) : real;
procedure Wx (var fr : mat; i,j : word; x : real);
procedure VyberVystup;
function Zaokr (p : real) : real;

Implementation
uses dos,crt,typyvl,win,provse,pomucky;
  var prx,sx,pry,sy  : real;
const PopisVystupu : popis = (hr1:'Kter  veli‡ina bude v˜stupn¡?'; hr2:'';
    dr1:''; dr2:BeznaRada; barva:cyan);
{-----------------------------------------------------------------------------}
{procedure CtiDbfRady (f : dbchar; co : mnozina);
  var x : real;
  begin
  reset (f.f); assign (fr,'data.'); rewrite (fr);
  for i := 1 to f.n do
  for j := 1 to f.m do if j in co then
    begin
    Nastav (f,i,j);
    x := CP(Slovo(f,j));
    write (fr,x)
    end;
  close (f.f); close (fr);
  end;
}
{----------------------------------------------------------------------------}
procedure CtiRady (prip : jmeno);
  var radek : string; x : real;

  procedure ZalozSirku;
   var prga : boolean;
    begin
    readln (f,radek); m := 0;
    while (radek[length(radek)]=' ') and (radek<>'') do
      delete (radek,length(radek),1);
    while (radek[1]=' ') and (radek<>'') do delete (radek,1,1); prga := true;
    for i := 1 to length (radek) do if (radek[i]=' ')=prga then
      begin if prga then inc (m); prga := not prga end; inc (m);
    end;

  procedure CtiRadek (k : byte);
    begin
    for i := 1 to m do
      begin
      titl[k,i] := '';
      while (radek[1]=' ') and (radek<>'') do delete (radek,1,1);
      while (radek[1]>' ') and (radek<>'') do
       begin titl[k,i] := titl[k,i] + radek[1]; delete (radek,1,1); end;
      end;
   end;

  begin
  if nazev='' then Otevreni ('',prip);
  assign (f,nazev+'.'+prip); reset (f); assign (fr,'data.'); rewrite (fr);
  ZalozSirku; CtiRadek (1); readln (f,radek); CtiRadek (2); n := 0;
  while not eof(f) do
    begin
    for j := 1 to m do
      begin
      read (f,x);
      if ioresult=0 then write (fr,x) else
      begin clrscr; writeln ('Na © dku',n:5,'   je chyba!!!'); pockej; end;
      end; readln (f); inc(n);
    end; close (f); close (fr)
  end;
{----------------------------------------------------------------------------}
procedure VyberVystup;
 var p : real; vi : byte; pom : jmeno;
  begin
  Obrazovka (PopisVystupu);
  tv[m+1] := ''; for i := 1 to m do tv[i] := titl[1,i];
  Menumaker (tv,0,KamMenu(tv),vi); if vi=1 then Exit;
  reset (fr);
  for i := 1 to n do
    begin p := Rx(fr,i,1); Wx(fr,i,1,Rx(fr,i,vi)); Wx(fr,i,vi,p) end;
  close (fr);
  for i := 1 to 2 do
    begin pom := titl[i,1]; titl[i,1] := titl[i,vi]; titl[i,vi] := pom end;
  end;
{----------------------------------------------------------------------------}
function IJ (i,j : word) : word; begin IJ := m*(i-1) + j - 1 end;
{----------------------------------------------------------------------------}
function Rx (var fr : mat; i,j : word) : real;
 var x : real; begin seek (fr,IJ(i,j)); read (fr,x);
 Rx := x end;
{----------------------------------------------------------------------------}
procedure Wx (var fr : mat; i,j : word; x : real);
  begin seek (fr,IJ(i,j)); write (fr,x); end;
{----------------------------------------------------------------------------}
procedure minmax (vek : byte; var min,max : real);
  var i : integer; x : real;
  begin
  reset (fr); seek (fr,IJ(1,vek)); read(fr,x); min := x; max := min;
  for i := 2 to n do
    begin
    seek (fr,IJ(i,vek)); read(fr,x); min := minr (x,min); max := maxr (x,max)
    end; close (fr);
  end;
{-----------------------------------------------------------------------------}
function Determinant (var a : matice; n : byte) : real;
  var p,q,det : real; i,j,k : byte;
  begin
  det := 1;
  for k := n downto 2 do if det<>0 then
    begin
    p := a[k,k];
    if abs(p)<1E-8 then
      begin
      repeat inc(i) until (a[i,k]<>0) or (i=k);
      for j := 1 to k do a[k,j] := a[k,j] + a[i,j];
      end;
    det := det*p;
    if abs(det)>1E-8 then for i := 1 to k-1 do
      begin
      q := a[i,k]/p;
      for j := 1 to k-1 do a[i,j] := a[i,j] - q*a[j,k];
      end;
    end;
  if abs(a[1,1])>1E-8 then Determinant := det*a[1,1] else Determinant := 0;
  end;
{-----------------------------------------------------------------------------}
procedure Invmat (var c : matice; m : byte);
  var x,p,q : real; i,j,k  : byte;
  begin
  for i := 1 to m do c[i,i] := c[i,i] + 1; j := 1;
  repeat
    p := c[j,j] - 1;
    if p <> 0 then
      begin
      for k := 1 to m do c[j,k] := c[j,k]/p;
      for i := 1 to m do if i <> j then
        begin
        q := c[i,j];
        for k := 1 to m do c[i,k] := c[i,k] - q*c[j,k];
        end;
      end; inc(j);
  until (p=0) or (j>m);
  if p=0 then
  begin RadaOkno (10,0,15,'M ¨ singul rn¡ matici !!!'); OK := false; Exit end
  else for i := 1 to m do c[i,i] := c[i,i] - 1; OK := true;
  end;
{-----------------------------------------------------------------------------}
procedure PrumerSmerOdch (y : byte; var pr,so : real);
  var i : integer; x : real;
  begin
  pr := 0; so := 0; reset (fr);
  for i := 1 to n do begin x := Rx(fr,i,y); pr := pr + x; so := so + x*x end;
  pr := pr/n; so := sqrt (so/n - pr*pr); close (fr);
  writechar (y,20,1,'x',y mod 16);
  end;
{-----------------------------------------------------------------------------}
procedure Kovariance (v1,v2 : byte; var cov : real);
  var i : integer;
  begin
  reset (fr); cov := 0;
  for i := 1 to n do cov := cov + Rx(fr,i,v1)*Rx(fr,i,v2);
  cov := cov/n - prx*pry; close (fr);
  end;
{---------------------------------------------------------------------------}
procedure Korelace (x,y : byte; var cor : real);
  var cov : real;  begin kovariance (x,y,cov); cor := cov/(sx*sy) end;
{-----------------------------------------------------------------------------}
procedure KorelacniMatice (var kor: matice; var pr,sm : VekRad);
  var k :  integer;
  begin
  clrscr;
  for j := 1 to m do begin kor[j,j] := 1; PrumerSmerOdch (j,pr[j],sm[j]) end;
  for j := 1 to m-1 do
  for k := j+1 to m do
    begin
    prx:= pr[j]; pry := pr[k]; sx:= sm[j]; sy := sm[k];
    korelace (j,k,kor[j,k]); kor[k,j] := kor[j,k];
    writechar (j,1+2*k div 5,1,'x',(j+k) mod 128);
    writechar (k,1+2*j div 5,1,'x',(j+k) mod 128);
    end;
  end;
{---------------------------------------------------------------------------}
procedure KovariancniMatice (var kov: matice; var pr,sm : VekRad);
  var k :  integer;
  begin
  for j := 1 to m do
    begin PrumerSmerOdch (j,pr[j],sm[j]); kov[j,j] := sm[j]*sm[j]  end;
  for j := 1 to m-1 do
  for k := j+1 to m do
    begin
    prx:= pr[j]; pry := pr[k]; sx:= sm[j]; sy := sm[k];
    kovariance (j,k,kov[j,k]); kov[k,j] := kov[j,k];
    end;
  end;
{---------------------------------------------------------------------------}
procedure Eigen (cor : matice; var l : VekRad; var y : matice);
  var x,z,cos,sin,KoncovaNorma,norma : real; ok : boolean; i,j,k,b : byte;

  procedure vymena (var x,y : real);
   var p : real; begin p := x; x := y; y := p end;

  begin
  for i := 1 to m do
  for j := 1 to m do if i=j then y[i,j] := 1 else y[i,j] := 0;
  norma := 0; b := 11;
  for i := 1 to m-1 do
  for j := i+1 to m do norma := norma + cor[i,j]*cor[i,j];
  norma := sqrt (2*norma); KoncovaNorma := norma/m*1E-6;
  while norma>KoncovaNorma do
    begin
    norma := norma/m; clrscr; gotoxy (40,21); write (Norma/KoncovaNorma);
    repeat
      ok := true;
      for k := 1 to m-1 do
      for j := k+1 to m do if abs(cor[j,k])>=norma then
        begin
        b := 24-b; writechar (k,1+2*j div 5,1,'x',b);
        ok := false; x := (cor[k,k] - cor[j,j]) * 0.5;
        z := -cor[k,j]/sqrt(sqr(cor[k,j]) + sqr(x));
        if x<0 then z := -z;
        sin := z/sqrt (2*(1 + sqrt(1 - z*z))); cos := sqrt (1 - sin*sin);
        for i := 1 to m do
          begin
          if (i<>j) and (i<>k) then
            begin
            x := cor[i,k]*cos - cor[i,j]*sin;
            cor[i,j] := cor[i,k]*sin + cor[i,j]*cos;
            cor[i,k] := x; cor[j,i] := cor[i,j]; cor[k,i] := cor[i,k];
            end;
          x := y[i,k]*cos - y[i,j]*sin; y[i,j] := y[i,k]*sin + y[i,j]*cos;
          y[i,k] := x;
          end;
        x := cor[k,k]*cos*cos + cor[j,j]*sin*sin - 2*cor[k,j]*sin*cos ;
        z := cor[k,k]*sin*sin + cor[j,j]*cos*cos + 2*cor[k,j]*sin*cos ;
        cor[k,j] := 0; cor[k,k] := x; cor[j,j] := z; cor[j,k] := 0;
        end;
      until ok;
    end;
  for i := 1 to m do l[i] := cor[i,i];
  for i := 1 to m-1 do for j := i+1 to m do if l[i]<l[j] then
    begin
    vymena (l[i],l[j]);
    for k := 1 to m do vymena (y[i,k],y[j,k]); {y[i,*] je i-t˜ vlastn¡ v.}
    end;
  end;
{---------------------------------------------------------------------------}
function Zaokr (p : real) : real;
  const dif : array[1..4] of real = (1,2.5,5,10);
    var i,koef : integer; des,z : real;
  begin
  if p=0 then begin zaokr := 0; Exit end;
  z := int(log(abs(p))); koef := round(z); if abs(p) < 1 then dec(koef);
  des := moc (10,koef);
  i := 1; repeat z := des * dif[i]; inc(i); until round(abs(p)/z) = 1;
  if p>0 then zaokr := z else zaokr := -z;
  end;
{-----------------------------------------------------------------------------}
procedure Osy (n:word; var min,max,dy:real; var idy:integer);
 var p : real;
  begin
  if min=max then begin idy := n; dy := 1; Exit end;
  p := max - min; dy := zaokr (p)/5;
  p := round (max/dy) * dy; if max > p then max := p + dy else max := p;
  p := round (min/dy) * dy; if min < p then min := p - dy else min := p;
  idy := trunc(n*dy/(max-min));
  end;
{-----------------------------------------------------------------------------}
procedure Osy2 (nx,ny : word);
 var malex : boolean;
 procedure Konce (var min,max : real);
  var p : real;
   begin with d do begin
   p := round (max/x) * x; if max>p then max := p + x else max := p;
   p := round (min/x) * x; if min<p then min := p - x else min := p;
   end; end;
  begin
  d.x := zaokr (max.x - min.x)/5; d.y := zaokr (max.y - min.y)/5;
  malex := d.x<=d.y; if malex then d.x := d.y else d.y := d.x;
  Konce (min.x,max.x); Konce (min.y,max.y);
  if malex then id.x := round(ny*d.y/(max.y-min.y))
           else id.x := round(nx*d.x/(max.x-min.x)); id.y := id.x;
  end;
{-----------------------------------------------------------------------------}
end.
