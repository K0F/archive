Unit Kresleni;
Interface
uses crt,graph,typy,pomucky,matika;

procedure KresliDal;

Implementation
  var size : word; n,b : byte; o : array[1..100] of PointType; jm : polozka;
      a : pointer; konec : boolean;
{---------------------------------------------------------------------------}
procedure Sipka (x,y,bar : word);
    begin setcolor (bar); settextjustify (1,1); outtextxy (x,y,SipkaDolu) end;
{---------------------------------------------------------------------------}
procedure BarevnyPruh;
  begin
  for b := 0 to 15 do begin setfillstyle (1,b); bar (10*b,20,10*(b+1),40) end;
  size := ImageSize(0, 0, 160, 40); GetMem(a, Size); GetImage(0,0,160,40,a);
  end;
{---------------------------------------------------------------------------}
procedure VyberBarvu;
  begin
  repeat
    sipka (10*b+5,10,white); ch := readkey; sipka(10*b+5,10,black);
    case ch of
        vpravo : if b<15 then inc(b);
        vlevo  : if b>0 then dec(b);
        Enter,Esc    : OK := true;
        Ende : konec := true;
      end;
  until konec or OK;
  if not konec then
    begin putimage (0,0,a,xorput); setcolor (b); setlinestyle (0,0,1) end;
  end;
{---------------------------------------------------------------------------}
procedure Zaznam;
  begin
  str (n,jm); assign (f,'obr'+jm+'.pas'); rewrite (f);
  writeln (f,'procedure Vymysli',jm,';');
  writeln (f,'var t : array [1..',i,'] of pointtype; ');
  writeln (f,'begin');
  for j := 1 to i do
   writeln (f,'t[',j,'].x := ',o[j].x:4,'; t[',j,'].y := ',o[j].y:4,';');
  writeln (f,'setcolor (',b,'); setfillstyle (1,',b,'); Fillpoly (',i,',t);');
  writeln (f,'end;');
  write (f,'{'); for j := 1 to 75 do write (f,'-'); writeln (f,'}');
  close(f);
  end;
{---------------------------------------------------------------------------}
procedure KresliDal;
  begin
  BarevnyPruh;
  n := 1; with o[1] do begin x := 500; y := 400; end; konec := false;
  repeat
   putimage (0,0,a,normalput); b := 0; OK := false; VyberBarvu;
   i := 1; OK := konec;
   repeat with o[i] do begin
    j := getpixel (x,y); putpixel (x,y,white-8*ord(j>8));
    if not konec then ch := readkey; putpixel (x,y,j);
    case ch of
        dolu   : if y<GetMaxY then inc(y);
        nahoru : if y>1 then dec(y);
        Vpravo : if x<GetMaxX then inc(x);
        Vlevo  : if x>1 then dec(x);
        Enter  :
         begin
         setcolor (b);
         if i>1 then line (o[i-1].x,o[i-1].y,x,y); o[i+1] := o[i]; inc(i);
         end;
        Esc    : OK := true;
        Ende   : konec := true;
      end;
   end; until konec or OK; ok := false;
   o[i] := o[1]; setfillstyle (1,b); fillpoly (i,o);
   if not konec then Zaznam; inc(n);
  until konec;
  end;
{---------------------------------------------------------------------------}
end.