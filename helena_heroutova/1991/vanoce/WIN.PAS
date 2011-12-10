unit Win;
{$D+,S-}
interface
uses Crt,typy;

type
  StavOkna = record
              MinOkna, MaxOkna: Word; KdeX, KdeY, textattr : Byte;
             end;
  NazevStrPtr = ^polozka;
  WinRecPtr = ^WinRec;
  WinRec = record
            dal: WinRecPtr; State: StavOkna; Nazev: NazevStrPtr;
            NazevBarvy, RamBarvy: Byte; Buffer: Pointer;
           end;

var HorniOkno: WinRecPtr;

procedure AktivniOkno (Aktivni: Boolean);
procedure Box (x1,y1,x2,y2,barva : byte; cara : cary);
procedure Centr (radek : byte; txt : polozka; b : byte);
function CI (str : string) : longint;
function CP (str : string) : real;
procedure FillWin (Ch: Char; Barvy: Byte);
procedure InfoOkno (radek,b0,b1 : byte; CoTam : polozka);
procedure MenuOkno (tv : PoleVoleb; X,Y,b : byte; var volba : byte);
procedure MenuVOkno (a,z : ukaz; X,b : byte; var q : ukaz);
procedure Odramuj;
procedure RadaOkno (radek,b0,b1 : byte; CoTam : polozka);
procedure Ramuj (Nazev:polozka; var Ram:cary; NazevBarvy,RamBarvy: Byte);
procedure ReadWin (var Buf);
procedure RestoreWin (var W : StavOkna);
procedure SaveWin (var W: StavOkna);
procedure Stred (radek : byte; prvni,dalsi : polozka);
procedure Vpis (x,y,b0,b1 : byte; CoTam : polozka);
procedure VpisCislo (x,y,b0,b1 : byte; CoTam : integer);
procedure VytvorOkno (X,Y,W,H : Integer; S : polozka; barva : Byte);
function  WinSize: Word;
procedure WriteChar (X,Y,Count : Byte; Ch : Char; Barvy : Byte);
procedure WriteStr (X,Y : Byte ; S : String; Barvy : Byte);
procedure WriteCes (X,Y : Byte ; S : String; Barvy : Byte);
procedure WriteWin (var Buf);
procedure ZavriOkno;
procedure ZavriVsechnyOkna;

implementation
 uses provse,pomucky;
{$L WIN}
{---------------------------------------------------------------------------}
procedure WriteStr (X, Y: Byte; S: String; Barvy: Byte);  external;
procedure WriteChar (X, Y, Count: Byte; Ch: Char; Barvy: Byte); external;
procedure FillWin (Ch: Char; Barvy: Byte); external;
procedure WriteWin (var Buf); external;
procedure ReadWin (var Buf); external;
function WinSize: Word; external;
{---------------------------------------------------------------------------}
procedure SaveWin (var W: StavOkna);
  begin
  W.MinOkna := WindMin; W.MaxOkna := WindMax;
  W.KdeX := whereX;  W.KdeY := whereY;  W.textattr := textattr;
  end;
{---------------------------------------------------------------------------}
procedure RestoreWin (var W : StavOkna);
  begin
  WindMin := W.MinOkna; WindMax := W.MaxOkna;
  GotoXY (W.KdeX, W.KdeY); textattr := W.textattr;
  end;
{---------------------------------------------------------------------------}
procedure Ramuj (Nazev:polozka; var Ram:cary; NazevBarvy,RamBarvy: Byte);
 var W, H, Y: Word;
  begin
  W := Lo(WindMax) - Lo(WindMin) + 1; H := Hi(WindMax) - Hi(WindMin) + 1;
  WriteChar (1,1,1,Ram[1],RamBarvy); WriteChar(2,1,W-2,Ram[2],RamBarvy);
  WriteChar (W,1,1,Ram[3],RamBarvy);
  if Length(Nazev) > W - 2 then Nazev[0] := Chr(W - 2);
  WriteStr((W - Length(Nazev)) shr 1 + 1, 1, Nazev, NazevBarvy);
  for Y := 2 to H - 1 do
    begin
    WriteChar(1,Y,1,Ram[4],RamBarvy); WriteChar(W,Y,1,Ram[5],RamBarvy);
    end;
  WriteChar(1,H,1,Ram[6],RamBarvy); WriteChar(2,H,W-2,Ram[7],RamBarvy);
  WriteChar(W,H,1,Ram[8],RamBarvy);
  Inc (WindMin,$0101); Dec (WindMax,$0101);
  end;
{---------------------------------------------------------------------------}
procedure Odramuj;  begin  Dec (WindMin,$0101); Inc (WindMax,$0101); end;
{---------------------------------------------------------------------------}
procedure AktivniOkno (Aktivni: Boolean);
  begin
  if HorniOkno=nil then Exit;
  Odramuj;
  with HorniOkno^ do if Aktivni
    then Ramuj (Nazev^,cara2, NazevBarvy, RamBarvy)
    else Ramuj (Nazev^,cara1, RamBarvy, RamBarvy);
  end;
{---------------------------------------------------------------------------}
procedure OtevriOkno (X1,Y1,X2,Y2 : Byte; T : polozka; TBarvy,FBarvy : Byte);
 var W : WinRecPtr;
  begin
  AktivniOkno (False); OK := true;
  if maxavail>=sizeof(w^) then New(W) else begin OK := false; Exit end;
  with W^ do
    begin
    dal := HorniOkno; SaveWin (State); GetMem (Nazev,Length(T)+1);
    Nazev^ := T; NazevBarvy := TBarvy; RamBarvy := FBarvy;
    Window (X1, Y1, X2, Y2); GetMem(Buffer, WinSize);
    ReadWin (Buffer^); Ramuj (T, cara2, TBarvy, FBarvy);
    end;
  HorniOkno := W;
  end;
{---------------------------------------------------------------------------}
procedure VytvorOkno (X,Y,W,H : Integer; S : polozka; barva : Byte);
 var b : byte;
  begin
  if barva=blue then b := LightGray*16 + barva else b := barva*16 + white;
  OtevriOkno (X,Y,X+W-1,Y+H-1,S,b,white + barva*16);
  textattr := barva*16 + white; ClrScr;
  end;
{---------------------------------------------------------------------------}
procedure RadaOkno (radek,b0,b1 : byte; CoTam : polozka);
  begin
  VytvorOkno (1,radek-1,80,3,'',b0);
  writestr ((80-length(CoTam)) div 2,1,CoTam,b1+16*b0); ch := CoJe; ZavriOkno;
  end;
{---------------------------------------------------------------------------}
procedure InfoOkno (radek,b0,b1 : byte; CoTam : polozka);
  begin
  VytvorOkno (1,radek-1,80,3,'',b0);
  writestr ((80-length(CoTam)) div 2,1,CoTam,b1+16*b0); pockej; ZavriOkno;
  end;
{---------------------------------------------------------------------------}
procedure MenuOkno (tv : PoleVoleb; X,Y,b : byte; var volba : byte);
 var i,w,h : byte;
  begin
  h := KolikVoleb (tv); w := 0; 
  for i := 1 to h do w := maxi (w,length (tv[i]));
  if x=0 then x := (80-w+1) div 2; VytvorOkno (x,y,w+4,h+2,'',b);
  Odramuj; MenuMaker (tv,1,1,volba);
  Inc (WindMin,$0101); Dec (WindMax,$0101); ZavriOkno;
  end;
{-----------------------------------------------------------------------------}
procedure MenuVOkno (a,z : ukaz; X,b : byte; var q : ukaz);
 var h,w : byte;
  begin
  w := 0; h := 0; q := a;
  while q<>z do begin inc(h); w := maxi (w,length (q^.txt)); q := q^.dal end;
  if x=0 then x := (80-w+1) div 2; h := mini(19,h);
  VytvorOkno (x,3,w+2,h+2,'',b); MysiMenu (a,z,q);
  Inc (WindMin,$0101); Dec (WindMax,$0101); ZavriOkno;
  end;
{-----------------------------------------------------------------------------}
procedure ZavriOkno;
 var W : WinRecPtr;
  begin
  if HorniOkno <> nil then
    begin
    W := HorniOkno;
    with W^ do
      begin
      Odramuj; WriteWin (Buffer^); FreeMem (Buffer, WinSize);
      FreeMem (Nazev, Length(Nazev^) + 1); RestoreWin (State);
      HorniOkno := dal;
      end;
    Dispose (W); AktivniOkno (True);
    end;
  end;
{---------------------------------------------------------------------------}
procedure ZavriVsechnyOkna;
  begin while HorniOkno<>nil do ZavriOkno;  end;
{---------------------------------------------------------------------------}
procedure Box (x1,y1,x2,y2,barva : byte; cara : cary);
  var  j : byte;
  begin
  writeStr (x1,y1,cara[1] + podtrh(x2-x1-1,cara[2]) + cara[3],barva);
  writeStr (x1,y2,cara[6] + podtrh(x2-x1-1,cara[7]) + cara[8],barva);
  for j := y1+1 to y2-1 do
    begin
    writechar (x1,j,1,cara[4],barva);  writechar (x2,j,1,cara[5],barva);
    end;
  end;
{-----------------------------------------------------------------------------}
procedure Stred (radek : byte; prvni,dalsi : polozka);
  begin
  writestr (1+(lo(windmax)-lo(windmin)-length(prvni+dalsi)+1) div 2,radek,prvni,
    textattr);
  gotoxy (1+(lo(windmax)-lo(windmin)-length(dalsi)+length(prvni)+1) div 2,radek);
  end;
{-----------------------------------------------------------------------------}
procedure Centr (radek : byte; txt : polozka; b : byte);
  begin
  writestr (1+(lo(windmax)-lo(windmin)-length(txt)+1) div 2,radek,txt,b);
  end;
{-----------------------------------------------------------------------------}
procedure Vpis (x,y,b0,b1 : byte; CoTam : polozka);
 var x1,y1,x2,y2 : byte;
  begin
  x1 := lo(windmin); y1 := hi(windmin); x2 := lo(windmax); y2 := hi(windmax);
  window (1,y,80,y);
  if CoTam='' then writechar (1,1,80,' ',b0*16) else
  if x=0 then centr (1,CoTam,b0*16+b1) else writestr (x,1,CoTam,b0*16+b1);
  window (x1+1,y1+1,x2+1,y2+1);
  end;
{-----------------------------------------------------------------------------}
procedure VpisCislo (x,y,b0,b1 : byte; CoTam : integer);
 var slovy : polozka;
  begin str (CoTam,slovy); Vpis (x,y,b0,b1,slovy); end;
{-----------------------------------------------------------------------------}
function CP (str : string) : real;
 var u : real; i : integer;
  begin val (str,u,i); if i<>0 then CP := 0 else CP := u end;
{-----------------------------------------------------------------------------}
function CI (str : string) : longint;
 var u : longint; i : integer;
  begin val (str,u,i); if i=0 then CI := u else CI := 0 end;
{-----------------------------------------------------------------------------}
procedure WriteCes (X,Y : Byte ; S : String; Barvy : Byte);
  begin Writestr (X,Y,dbw(S),Barvy) end;
{-----------------------------------------------------------------------------}
end.
