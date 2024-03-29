Unit Pomucky;
Interface
uses typy;

procedure Dotazovka (CoTam : popis; v0 : byte; var v : byte);
function  KamMenu (Menu : PoleVoleb) : byte;
procedure MenuMaker (tv : PoleVoleb; x,y : byte; var volba : byte);
procedure MysiMenu (a,z : ukaz; var q : ukaz);
procedure Obrazovka (CoTam : popis);
procedure ObrazovkaW (CoTam : popis);
procedure Otevreni (cesta : string; prip : jmeno);
function Prava (CoTam : popis) : byte;
procedure RychlaKopie (odkud,kam : string; videt : boolean);
procedure Vizitka (w : boolean);
procedure VyberZRoku (o,d : word; var r : word);
procedure Zahl (r : byte; T : string);
procedure Znelka1 (prgjm,prgkom : string);
procedure Znelka2 (nazev : string);

Implementation
uses dos,crt,Rozmery,provse,win,drivers;
{-----------------------------------------------------------------------------}
procedure Zahl (r : byte; T : string);
 var b,l,y : byte;
  begin
  b := (textattr - white) div 16;
  repeat
    y := ord(t[2]); delete (t,1,2); l := pos(';',t);
    if l>0 then Vpis (y,r,b,15,copy(t,1,l-1)) else Vpis (y,r,b,15,t);
    delete (t,1,l-1);
  until l=0;
  end;
{-----------------------------------------------------------------------------}
procedure Obrazovka (CoTam : popis);
  begin
  window (1,1,80,25); with CoTam do
    begin
    textattr := white + 16*barva; clrscr;
    if hr1[1]=';' then Zahl(1,hr1) else centr (1,hr1,textattr);
    if hr2[1]=';' then Zahl(2,hr2) else centr (2,hr2,textattr);
    centr (24,dr1,textattr); centr (25,dr2,textattr);
    end;
  textattr := white; window (1,3,80,23); clrscr;
  end;
{-----------------------------------------------------------------------------}
procedure ObrazovkaW (CoTam : popis);
  begin
  window (1,1,80,25); with CoTam do
    begin
    textattr := white + 16*barva; clrscr;
    if hr1[1]=';' then Zahl(1,DbW(hr1)) else centr (1,DbW(hr1),textattr);
    if hr2[1]=';' then Zahl(2,DbW(hr2)) else centr (2,DbW(hr2),textattr);
    centr (24,DbW(dr1),textattr); centr (25,DbW(dr2),textattr);
    end;
  textattr := white; window (1,3,80,23); clrscr;
  end;
{-----------------------------------------------------------------------------}
function Prava (CoTam : popis) : byte;
 var k : byte;
  begin
  k := 0; while pos('|',CoTam.dr2)>0 do
    begin
    inc(k); delete (CoTam.dr2,pos('|',CoTam.dr2),1);
    end; Prava := k;
  end;
{-----------------------------------------------------------------------------}
procedure Dotazovka (CoTam : popis; v0 : byte; var v : byte);
 var k,i,kde,t : byte; kus : array [1..10] of jmeno;

 procedure PisKus (i,b : byte);
   begin
   writestr ((80*i-40) div k-length(kus[i]) div 2,2,kus[i],16*CoTam.barva+b)
   end;

  begin with CoTam do begin
  Vpis (1,24,barva,0,''); Vpis (1,25,barva,0,''); window (1,24,80,25);
  centr (1,dr1,16*barva+yellow);
  if barva in [0,1,4..6] then t := 7 else t := black;
  k := 0; while dr2<>'' do
    begin
    inc(k); kde := pos('|',dr2);
    kus[k] := copy (dr2,1,kde-1); delete (dr2,1,kde);
    end;
  for i := 1 to k do PisKus (i,t); if v0 in [1..k] then v := v0 else v := k;
  repeat
    PisKus (v,white); ch := readkey; PisKus (v,t);
    case ch of
     vlevo :  begin if v>1 then dec(v); if (kus[v]='') and (v>1) then dec(v) end;
     vpravo : begin if v<k then inc(v); if (kus[v]='') and (v<k) then inc(v) end;
     Home  :  v := 1;
     Esc   :  if copy (Cotam.dr2,length(Cotam.dr2)-4,4)='|OK|' then v := k;
     Ende  :  v := k;
     'a'..'z','0'..'9' :
       begin
       v := 1; while not (kus[v,1] in [ch,UpCase(ch)]) and (v<k) do inc(v);
       ch := Enter;
       end;
    end;
  until ch in [Enter,Esc];
  window (1,3,80,23); Vpis (1,24,barva,0,''); Vpis (1,25,barva,0,'');
  end; end;
{-----------------------------------------------------------------------------}
function KamMenu (Menu : PoleVoleb) : byte;
  begin
  KamMenu := (maxi(1,hi(WindMax)-hi(WindMin)+1-KolikVoleb(Menu)) div 2)
  end;
{---------------------------------------------------------------------------}
procedure Kontrast;
  var c,b : byte;
  begin
  c := textattr mod 16; b := (textattr - c) div 16;
  textattr := (c - 8) * 16 + b + 8;
  end;
{-----------------------------------------------------------------------------}
procedure MenuMaker (tv : PoleVoleb; x,y : byte; var volba : byte);
  var i,j,n,maxdelka : byte;
  begin
  OK := false; n := KolikVoleb (tv); maxdelka := 0;
  volba := mini (n,volba); volba := maxi (1,volba);
  for i := 1 to n do maxdelka := maxi (maxdelka,length (tv[i]));
  for i := 1 to n do
    begin
    for j := length(tv[i])+1 to MaxDelka do tv[i] := tv[i] + ' ';
    tv[i] := cara2[4] + ' ' + tv[i] + ' ' + cara2[4];
    end;
  if x=0 then x := (lo(windmax)-lo(windmin)-MaxDelka-1) div 2
         else x := mini (x,lo(WindMax) - 3 - MaxDelka);
  Box (x,y,x+MaxDelka+3,y+n+1,textattr,cara2);
  for i := 1 to n do writestr (x,y+i,tv[i],textattr);
  repeat
    kontrast; writestr (x,y+volba,tv[volba],textattr); ch := readkey;
    kontrast; writestr (x,y+volba,tv[volba],textattr);
    case ch of
     nahoru : if volba>1 then dec(volba);
     dolu   : if volba<n then inc(volba);
     PageUp : volba := 1;
     PageDn : volba := n;
     '0'..'9','a'..'z' :
        begin
        volba := 1;
        while not (tv[volba][3] in [ch,UpCase(ch)]) and (volba<n) do inc(volba);
        end;
     Esc    : begin OK := true; volba := 0; Exit end;
     end;
  until ch in [F1,Enter,Esc];
  tv[volba] := copy (tv[volba],3,length(tv[volba])-3);
  while tv[volba][length(tv[volba])]=' ' do dec(tv[volba][0]);
  end;
{-----------------------------------------------------------------------------}
procedure MysiMenu (a,z : ukaz; var q : ukaz);
 var i,o,r : integer; ev : TEvent; s : mnozina;
  begin
  OK := false; InitEvents; r := Hi(WindMax); s := [lo(WindMin)..lo(WindMax)];
  q := a; o := 1; i := 1; while q<>z do with q^ do
    begin
    if i-o>=0 then
    if i-o+3=ev.where.y then
      begin kontrast; writestr (1,i-o+1,q^.txt,textattr); kontrast end
      else writestr (1,i-o+1,txt,textattr);
    q := dal; inc(i);
    end;
  repeat
    GetMouseEvent (ev); OK := false;
    if (ev.where.y=r) and (o<i-r+2) then inc(o);
    if (ev.where.y=2) and (o>1) then dec(o);
  until (ev.what=EvMouseUp); Ok := ev.where.y>22;
  if OK then begin q := NIL; Exit; end;
  q := a; for i := 1 to ev.where.y-4+o do q := q^.dal; DoneEvents;
  end;
{-----------------------------------------------------------------------------}
procedure Vizitka (w : boolean);
 const rec : array[1..3] of string =
   ('S P�IPOM�NKAMI A DOTAZY SE OBRACEJTE NA ADRESU:',
    '  Ing. B. Mikuleck�,CSc., Ing. H. Heroutov� ',
    '  Software-salon ALT�N  ');
  begin
  if w then for i := 1 to 3 do rec[i] := dbw(rec[i]);
  box (5,3,75,23,lightgreen,cara2); box(7,4,73,22,lightgreen,cara2);
  box (29,20,79,25,lightcyan,cara2); writeStr (31,21,rec[1],11);
  writestr (32,22,rec[2],11); writestr (42,23,rec[3],11);
  writestr (31,24,'V�clavkova 2, 160 00 Praha 6, tel. 02/311 13 25',11);
  Pockej; textattr := 7; clrscr;
  end;
{-----------------------------------------------------------------------------}
procedure Znelka1 (prgjm,prgkom : string);
 var w : boolean;
 const rec : array[1..3] of string =('DOBR� DEN!','V�T� V�S',
   'A T��� SE NA SPOLUPR�CI S V�MI.');
  begin
  HorniOkno := NIL; krz := UlozKurz; Kurzor (zmiz); nazev := '';
  textattr := 7; clrscr; if prgjm+prgkom='0' then Exit; w := false;
  if prgjm='W' then
    begin for i := 1 to 3 do rec[i] := dbw(rec[i]); prgjm := ''; w := true end;
  for i := 1 to length (prgjm) do insert (' ',prgjm,2*i);
  centr (8,rec[1],lightmagenta); centr (11,rec[2]+prgjm,lightmagenta);
  if prgjm<>'' then WriteStr (wherex+2,wherey,prgjm,Lightcyan);
  centr (13,prgkom,lightcyan);
  if demo then centr (14,'D E M O - verze',lightmagenta);
  centr (17,rec[3],lightmagenta); Vizitka (w);
  end;
{-----------------------------------------------------------------------------}
procedure Znelka2 (nazev : string);
 var w : boolean;
  begin
  window (1,1,80,25); textbackground (black); clrscr;
  if nazev<>'0' then
    begin
    w := nazev='W'; if (nazev='') or w then nazev := 'NASHLEDANOU!';
    centr (9,nazev,lightcyan);
    if w then centr (18,dbw('NEMO�N� NEEXISTUJE, Z�ZRAKY DO DRUH�HO DNE.'),lightcyan)
         else centr (18,'NEMO�N� NEEXISTUJE, Z�ZRAKY DO DRUH�HO DNE.',lightcyan);
{    if nazev<>'' then
      begin
      centr (12,'V�PISY JSOU ULO�ENY V SOUBORECH',lightcyan);
      centr (14,nazev+'.',lightmagenta);
      end; }Vizitka(w);
     end; Kurzor (krz); textattr := 7; clrscr;
  end;
{-----------------------------------------------------------------------------}
procedure Otevreni (cesta : string; prip : jmeno);
  var soubor : searchrec;
  begin
  findfirst (cesta+'*.'+prip,archive,soubor); i := 0;
  while (doserror=0) and (i<20) do
    begin
    inc(i); tv[i] := copy (soubor.name,1,pos('.',soubor.name)-1);
    findnext(soubor);
    end;
  if i=0 then
    if zalozit then nazev := '' else
     begin
     window (1,1,80,25); clrscr;
     centr(10,'V tomto adres��i nen� ��dn� datov� soubor s p��ponou ',13);
     centr (12,'*.'+prip,13); centr (17,'Program smutn� kon��.',13);
     Vizitka(false); halt
     end
  else
    begin
    Obrazovka(MenuSouboru); if i<20 then tv[i+1] := '';
    MenuMaker(tv,0,Kammenu(tv),volba);
    if OK then nazev := '' else nazev := tv[volba]
    end;
  end;
{----------------------------------------------------------------------------}
procedure VyberZRoku (o,d : word; var r : word);
 var tv : PoleVoleb; i,j : word; v : byte;
  begin
  CistiTv(tv); for i := o to d do begin j := i-o+1; str(i,tv[j]); end;
  MenuMaker (tv,20,KamMenu(tv),v); r := CI(tv[v]);
  end;
{----------------------------------------------------------------------------}
procedure RychlaKopie (odkud,kam : string; videt : boolean);
 var FromF,ToF : file; NumRead,NumWritten : Word; buf: array[1..2048] of Char;
  begin
  Assign(FromF,odkud); Reset (FromF,1); Assign(ToF,kam); Rewrite(ToF,1);
  if videt then Writeln (' ':10,'Kop�rujeme soubor ',odkud,'...');
  repeat
    BlockRead(FromF,buf,SizeOf(buf),NumRead);
    BlockWrite(ToF,buf,NumRead,NumWritten);
  until (NumRead = 0) or (NumWritten <> NumRead); Close(FromF); Close(ToF);
  end;
{----------------------------------------------------------------------------}
end.
