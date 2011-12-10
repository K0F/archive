Unit Obrazky;
Interface
uses graph;

procedure DejNusi (ox,oy,b : word);
procedure DejTruhlu(ox,oy,b : word);
procedure DejUzlik (ox,oy,b : word);
procedure VymysliAltan (b : byte);
procedure VymysliBabu (var ul : PointType; var a0,a1 : pointer);
procedure VymysliDedu (var ul : PointType; var a0,a1 : pointer);
procedure VymysliJesle;
procedure VymysliJosefa;
procedure VymysliKmen;
procedure VymysliKrale (var ul : PointType; var a0,a1 : pointer);
procedure VymysliMarii;
procedure VymysliOvecku (var ul : PointType; var a0,a1 : pointer);
procedure VymysliStrom;

Implementation
uses crt,typy,typyvl,pomucky,provse;
var t : array [1..50] of pointtype; m : byte; size : word; ul,lr : POintType;
{---------------------------------------------------------------------------}
procedure VymysliAltan (b : byte);
var i : byte;
begin
t[1].x :=  300; t[1].y :=  174;
t[2].x :=  210; t[2].y :=  330;
t[3].x :=  210; t[3].y :=  zem;
t[4].x :=  390; t[4].y :=  zem;
t[5].x :=  390; t[5].y :=  330;
t[6].x :=  300; t[6].y :=  174;
setcolor (b); setfillstyle (1,b); Fillpoly (6,t);
setcolor (yellow); setfillstyle (1,yellow);
for i := 1 to 2 do bar (15*i+220,330,15*i+230,340);
for i := 1 to 2 do bar (15*i+330,330,15*i+340,340);
for i := 1 to 2 do bar (15*i+220,345,15*i+230,355);
for i := 1 to 2 do bar (15*i+330,345,15*i+340,355);
end;
{------------------------------------------------------------------------------}
procedure VymysliStrom;
var t : array [1..30] of pointtype;
begin
t[1].x :=  100; t[1].y :=  130;
t[2].x :=  110; t[2].y :=  155;
t[3].x :=  130; t[3].y :=  170;
t[4].x :=  110; t[4].y :=  170;
t[5].x :=  125; t[5].y :=  200;
t[6].x :=  150; t[6].y :=  230;
t[7].x :=  110; t[7].y :=  230;
t[8].x :=  115; t[8].y :=  240;
t[9].x :=  135; t[9].y :=  270;
t[10].x :=  160; t[10].y :=  290;
t[11].x :=  120; t[11].y :=  290;
t[12].x :=  140; t[12].y :=  320;
t[13].x :=  170; t[13].y :=  340;
t[14].x :=  110; t[14].y :=  325;
t[15].x :=  100; t[15].y :=  320;
t[16].x :=   90; t[16].y :=  325;
t[17].x :=   30; t[17].y :=  340;
t[18].x :=   60; t[18].y :=  320;
t[19].x :=   80; t[19].y :=  290;
t[20].x :=   40; t[20].y :=  290;
t[21].x :=   65; t[21].y :=  270;
t[22].x :=   85; t[22].y :=  240;
t[23].x :=   90; t[23].y :=  230;
t[24].x :=   50; t[24].y :=  230;
t[25].x :=   75; t[25].y :=  200;
t[26].x :=   90; t[26].y :=  170;
t[27].x :=   70; t[27].y :=  170;
t[28].x :=   90; t[28].y :=  155;
t[29].x :=  100; t[29].y :=  130;
setcolor (2); setfillstyle (1,2); Fillpoly (29,t);
end;
{---------------------------------------------------------------------------}
procedure Vymyslikmen;
var t : array [1..6] of pointtype;
begin
t[1].x :=  100; t[1].y :=  320;
t[2].x :=   90; t[2].y :=  325;
t[3].x :=   85; t[3].y :=  zem;
t[4].x :=  115; t[4].y :=  zem;
t[5].x :=  110; t[5].y :=  325;
t[6].x :=  100; t[6].y :=  320;
setcolor (6); setfillstyle (1,6); Fillpoly (6,t);
end;
{---------------------------------------------------------------------------}
procedure VymysliJesle;
var t : array [1..5] of pointtype;
begin
t[1].x :=  275; t[1].y :=  335;
t[2].x :=  270; t[2].y :=  335;
t[3].x :=  320; t[3].y :=  zem;
t[4].x :=  315; t[4].y :=  zem;
t[5].x :=  275; t[5].y :=  335;
setcolor (6); setfillstyle (1,6); Fillpoly (5,t);
t[1].x :=  325; t[1].y :=  335;
t[2].x :=  330; t[2].y :=  335;
t[3].x :=  280; t[3].y :=  zem;
t[4].x :=  285; t[4].y :=  zem;
t[5].x :=  325; t[5].y :=  335; Fillpoly (5,t);
t[1].x :=  275; t[1].y :=  338;
t[2].x :=  322; t[2].y :=  338;
t[3].x :=  318; t[3].y :=  341;
t[4].x :=  277; t[4].y :=  341;
t[5].x :=  275; t[5].y :=  338; Fillpoly (5,t);
setcolor (12); ellipse (300,335,330,210,8,5);
fillellipse (296,333,1,1); fillellipse (304,333,1,1);
fillellipse (300,336,1,1); arc (300,327,270,0,3); arc (296,327,270,0,3);
end;
{---------------------------------------------------------------------------}
procedure VymysliMarii;
var t : array [1..14] of pointtype;
begin
t[1].x :=  342; t[1].y :=  317;
t[2].x :=  340; t[2].y :=  319;
t[3].x :=  336; t[3].y :=  330;
t[4].x :=  333; t[4].y :=  zem;
t[5].x :=  356; t[5].y :=  zem;
t[6].x :=  351; t[6].y :=  348;
t[7].x :=  347; t[7].y :=  320;
t[8].x :=  342; t[8].y :=  317;
setcolor (9); setfillstyle (1,9); Fillpoly (8,t);
t[1].x :=  332; t[1].y :=  301;
t[2].x :=  334; t[2].y :=  300;
t[3].x :=  335; t[3].y :=  299;
t[4].x :=  341; t[4].y :=  299;
t[5].x :=  343; t[5].y :=  301;
t[6].x :=  347; t[6].y :=  307;
t[7].x :=  349; t[7].y :=  315;
t[8].x :=  350; t[8].y :=  331;
t[9].x :=  348; t[9].y :=  331;
t[10].x :=  347; t[10].y :=  321;
t[11].x :=  341; t[11].y :=  317;
t[12].x :=  337; t[12].y :=  310;
t[13].x :=  331; t[13].y :=  306;
t[14].x :=  332; t[14].y :=  301;
setcolor (8); setfillstyle (1,8); ellipse (337,308,0,360,4,7); Fillpoly (14,t);
end;
{---------------------------------------------------------------------------}
procedure VymysliJosefa;
var t : array [1..15] of pointtype;
begin
t[1].x :=  262; t[1].y :=  315;
t[2].x :=  250; t[2].y :=  313;
t[3].x :=  251; t[3].y :=  336;
t[4].x :=  246; t[4].y :=  zem;
t[5].x :=  268; t[5].y :=  375;
t[6].x :=  264; t[6].y :=  333;
t[7].x :=  262; t[7].y :=  315;
setcolor (9); setfillstyle (1,9); Fillpoly (7,t);
t[1].x :=  267; t[1].y :=  317;
t[2].x :=  266; t[2].y :=  308;
t[3].x :=  262; t[3].y :=  311;
t[4].x :=  261; t[4].y :=  311;
t[5].x :=  257; t[5].y :=  307;
t[6].x :=  257; t[6].y :=  299;
t[7].x :=  264; t[7].y :=  299;
t[8].x :=  261; t[8].y :=  297;
t[9].x :=  253; t[9].y :=  296;
t[10].x :=  251; t[10].y := 297;
t[11].x :=  250; t[11].y :=  311;
t[12].x :=  258; t[12].y :=  314;
t[13].x :=  264; t[13].y :=  314;
t[14].x :=  264; t[14].y :=  313;
t[15].x :=  267; t[15].y :=  317;
setcolor (8); setfillstyle (1,8); Fillpoly (15,t); fillellipse (262,303,1,1);
moveto (t[8].x,t[8].y); linerel (7,10); linerel (-2,0);
end;
{---------------------------------------------------------------------------}
procedure Rohy (m: byte; var ul,lr : PointType);
  var i : byte;
  begin
  for i := 1 to m do
   begin
   ul.x := mini (ul.x,t[i].x-1); ul.y := mini (ul.y,t[i].y-1);
   lr.x := maxi (lr.x,t[i].x+1); lr.y := maxi (lr.y,t[i].y+1);
   end; {dec (ul.x); dec (ul.y);}
  end;
{-----------------------------------------------------------------------------}
procedure Figurka (m,d : word; var ul,lr : PointType; var a0 : pointer);
 var size : word;
  begin
  lr := t[1]; ul := t[1]; Rohy (m,ul,lr);
  for i := 1 to m do inc (t[i].x,maxx-lr.x); inc(ul.x,maxx-lr.x); lr.x := maxx;
  dec (ul.x,d); Size := ImageSize(ul.x, ul.y, lr.x, lr.y);
  setcolor (0); setfillstyle (1,0); Fillpoly (m,t);
  GetMem (a0,Size); GetImage(ul.x,ul.y,lr.x,lr.y,a0^);
  end;
{-----------------------------------------------------------------------------}
procedure Naklad (m : byte; ul,lr : pointtype; var a1 : pointer);
 var size : word;
  begin
  Rohy (m,ul,lr); Size := ImageSize(ul.x, ul.y, lr.x, lr.y);
  GetMem (a1,Size); GetImage(ul.x,ul.y,lr.x,lr.y,a1^);
  end;
{-----------------------------------------------------------------------------}
procedure VymysliUzlik (var m : byte);
begin
t[1].x :=  599; t[1].y :=  434;
t[2].x :=  597; t[2].y :=  427;
t[3].x :=  593; t[3].y :=  426;
t[4].x :=  594; t[4].y :=  432;
t[5].x :=  599; t[5].y :=  436;
t[6].x :=  590; t[6].y :=  432;
t[7].x :=  587; t[7].y :=  434;
t[8].x :=  591; t[8].y :=  437;
t[9].x :=  601; t[9].y :=  437;
t[10].x :=  589; t[10].y :=  445;
t[11].x :=  589; t[11].y :=  451;
t[12].x :=  593; t[12].y :=  455;
t[13].x :=  601; t[13].y :=  455;
t[14].x :=  608; t[14].y :=  452;
t[15].x :=  599; t[15].y :=  434;
setcolor (0); setfillstyle (1,0); Fillpoly (15,t); m := 15;
end;
{---------------------------------------------------------------------------}
procedure VymysliNusi (var m : byte);
begin
t[1].x :=  625; t[1].y :=  436;
t[2].x :=  638; t[2].y :=  436;
t[3].x :=  636; t[3].y :=  454;
t[4].x :=  626; t[4].y :=  454;
t[5].x :=  621; t[5].y :=  436;
t[6].x :=  617; t[6].y :=  443;
t[7].x :=  621; t[7].y :=  451;
t[8].x :=  624; t[8].y :=  451;
t[9].x :=  625; t[9].y :=  436;
setcolor (0); setfillstyle (1,0); Fillpoly (9,t); m := 9;
end;
{---------------------------------------------------------------------------}
procedure VymysliTruhlu (var m : byte);
begin
t[1].x :=  577; t[1].y :=  409;
t[2].x :=  577; t[2].y :=  423;
t[3].x :=  603; t[3].y :=  423;
t[4].x :=  603; t[4].y :=  409;
t[5].x :=  600; t[5].y :=  406;
t[6].x :=  581; t[6].y :=  406;
t[7].x :=  577; t[7].y :=  409;
setcolor (0); setfillstyle (1,0); Fillpoly (7,t); m := 7;
end;
{---------------------------------------------------------------------------}
procedure VymysliOvecku (var ul : PointType; var a0,a1 : pointer);
 var lr : PointType;
begin
t[1].x :=  500; t[1].y :=  453;
t[2].x :=  502; t[2].y :=  448;
t[3].x :=  507; t[3].y :=  447;
t[4].x :=  510; t[4].y :=  449;
t[5].x :=  513; t[5].y :=  447;
t[6].x :=  515; t[6].y :=  447;
t[7].x :=  518; t[7].y :=  447;
t[8].x :=  520; t[8].y :=  448;
t[9].x :=  522; t[9].y :=  446;
t[10].x :=  525; t[10].y :=  446;
t[11].x :=  530; t[11].y :=  447;
t[12].x :=  534; t[12].y :=  446;
t[13].x :=  541; t[13].y :=  448;
t[14].x :=  548; t[14].y :=  458;
t[15].x :=  547; t[15].y :=  461;
t[16].x :=  545; t[16].y :=  462;
t[17].x :=  543; t[17].y :=  457;
t[18].x :=  545; t[18].y :=  472;
t[19].x :=  543; t[19].y :=  472;
t[20].x :=  541; t[20].y :=  465;
t[21].x :=  539; t[21].y :=  473;
t[22].x :=  537; t[22].y :=  473;
t[23].x :=  537; t[23].y :=  465;
t[24].x :=  532; t[24].y :=  467;
t[25].x :=  528; t[25].y :=  466;
t[26].x :=  524; t[26].y :=  467;
t[27].x :=  519; t[27].y :=  464;
t[28].x :=  521; t[28].y :=  473;
t[29].x :=  519; t[29].y :=  473;
t[30].x :=  516; t[30].y :=  464;
t[31].x :=  511; t[31].y :=  473;
t[32].x :=  509; t[32].y :=  473;
t[33].x :=  512; t[33].y :=  463;
t[34].x :=  509; t[34].y :=  462;
t[35].x :=  508; t[35].y :=  457;
t[36].x :=  506; t[36].y :=  457;
t[37].x :=  503; t[37].y :=  461;
t[38].x :=  500; t[38].y :=  459;
t[39].x :=  500; t[39].y :=  455; Figurka (39,0,ul,lr,a1); a0 := a1;
end;
{---------------------------------------------------------------------------}
procedure VymysliDedu (var ul : PointType; var a0,a1 : pointer);
 var lr : PointType;
begin
t[1].x :=  500; t[1].y :=  416;
t[2].x :=  495; t[2].y :=  412;
t[3].x :=  495; t[3].y :=  415;
t[4].x :=  499; t[4].y :=  418;
t[5].x :=  496; t[5].y :=  421;
t[6].x :=  498; t[6].y :=  421;
t[7].x :=  498; t[7].y :=  424;
t[8].x :=  498; t[8].y :=  425;
t[9].x :=  501; t[9].y :=  425;
t[10].x :=  500; t[10].y :=  429;
t[11].x :=  498; t[11].y :=  435;
t[12].x :=  499; t[12].y :=  441;
t[13].x :=  493; t[13].y :=  436;
t[14].x :=  488; t[14].y :=  434;
t[15].x :=  488; t[15].y :=  416;
t[16].x :=  486; t[16].y :=  416;
t[17].x :=  486; t[17].y :=  478;
t[18].x :=  487; t[18].y :=  478;
t[19].x :=  488; t[19].y :=  478;
t[20].x :=  488; t[20].y :=  438;
t[21].x :=  496; t[21].y :=  446;
t[22].x :=  503; t[22].y :=  448;
t[23].x :=  506; t[23].y :=  455;
t[24].x :=  503; t[24].y :=  466;
t[25].x :=  507; t[25].y :=  474;
t[26].x :=  502; t[26].y :=  476;
t[27].x :=  501; t[27].y :=  478;
t[28].x :=  513; t[28].y :=  478;
t[29].x :=  513; t[29].y :=  474;
t[30].x :=  511; t[30].y :=  466;
t[31].x :=  515; t[31].y :=  473;
t[32].x :=  514; t[32].y :=  478;
t[33].x :=  524; t[33].y :=  478;
t[34].x :=  515; t[34].y :=  461;
t[35].x :=  521; t[35].y :=  451;
t[36].x :=  508; t[36].y :=  426;
t[37].x :=  506; t[37].y :=  425;
t[38].x :=  509; t[38].y :=  421;
t[39].x :=  512; t[39].y :=  415;
t[40].x :=  507; t[40].y :=  411;
t[41].x :=  503; t[41].y :=  412;
Figurka (41,9,ul,lr,a0); VymysliUzlik (m); Naklad (m,ul,lr,a1);
end;
{---------------------------------------------------------------------------}
procedure VymysliBabu (var ul : PointType; var a0,a1 : pointer);
 var lr : PointType;
begin
t[1].x :=  606; t[1].y :=  415;
t[2].x :=  604; t[2].y :=  417;
t[3].x :=  604; t[3].y :=  419;
t[4].x :=  602; t[4].y :=  421;
t[5].x :=  604; t[5].y :=  423;
t[6].x :=  604; t[6].y :=  427;
t[7].x :=  608; t[7].y :=  426;
t[8].x :=  602; t[8].y :=  432;
t[9].x :=  601; t[9].y :=  435;
t[10].x :=  592; t[10].y :=  432;
t[11].x :=  589; t[11].y :=  435;
t[12].x :=  593; t[12].y :=  438;
t[13].x :=  605; t[13].y :=  445;
t[14].x :=  596; t[14].y :=  474;
t[15].x :=  601; t[15].y :=  474;
t[16].x :=  601; t[16].y :=  478;
t[17].x :=  611; t[17].y :=  478;
t[18].x :=  611; t[18].y :=  475;
t[19].x :=  617; t[19].y :=  475;
t[20].x :=  617; t[20].y :=  478;
t[21].x :=  627; t[21].y :=  478;
t[22].x :=  627; t[22].y :=  475;
t[23].x :=  631; t[23].y :=  475;
t[24].x :=  620; t[24].y :=  450;
t[25].x :=  616; t[25].y :=  448;
t[26].x :=  617; t[26].y :=  437;
t[27].x :=  617; t[27].y :=  431;
t[28].x :=  623; t[28].y :=  435;
t[29].x :=  619; t[29].y :=  423;
t[30].x :=  615; t[30].y :=  416;
t[31].x :=  611; t[31].y :=  415;
t[32].x :=  609; t[32].y :=  415;
Figurka (32,0,ul,lr,a0); VymysliNusi (m); Naklad (m,ul,lr,a1);
end;
{---------------------------------------------------------------------------}
procedure VymysliKrale (var ul : PointType; var a0,a1 : pointer);
begin
t[1].x :=  500; t[1].y :=  382;
t[2].x :=  500; t[2].y :=  386;
t[3].x :=  496; t[3].y :=  391;
t[4].x :=  500; t[4].y :=  391;
t[5].x :=  495; t[5].y :=  400;
t[6].x :=  502; t[6].y :=  396;
t[7].x :=  500; t[7].y :=  400;
for i := 8 to 10 do t[i] := t[i-1];
t[11].x :=  495; t[11].y :=  422;
t[12].x :=  495; t[12].y :=  430;
t[13].x :=  498; t[13].y :=  455;
t[14].x :=  520; t[14].y :=  455;
t[15].x :=  530; t[15].y :=  455;
t[16].x :=  516; t[16].y :=  423;
t[17].x :=  510; t[17].y :=  402;
t[18].x :=  508; t[18].y :=  397;
t[19].x :=  514; t[19].y :=  397;
t[20].x :=  512; t[20].y :=  390;
t[21].x :=  510; t[21].y :=  385;
t[22].x :=  510; t[22].y :=  381;
t[23].x :=  507; t[23].y :=  384;
t[24].x :=  505; t[24].y :=  381;
t[25].x :=  503; t[25].y :=  384;
Figurka (25,26,ul,lr,a0); VymysliTruhlu(m); Naklad (m,ul,lr,a1);
end;
{--------------------------------------------------------------------------}
procedure DejUzlik (ox,oy,b : word);
  var d : pointtype;
begin
t[1].x :=  599; t[1].y :=  437;
t[2].x :=  607; t[2].y :=  430;
t[3].x :=  603; t[3].y :=  429;
t[4].x :=  598; t[4].y :=  432;
t[5].x :=  599; t[5].y :=  436;
t[6].x :=  590; t[6].y :=  432;
t[7].x :=  587; t[7].y :=  434;
t[8].x :=  591; t[8].y :=  437;
t[9].x :=  601; t[9].y :=  437;
t[10].x :=  589; t[10].y :=  445;
t[11].x :=  589; t[11].y :=  451;
t[12].x :=  593; t[12].y :=  455;
t[13].x :=  601; t[13].y :=  455;
t[14].x :=  606; t[14].y :=  450; d.x := t[1].x - ox; d.y := t[1].y - oy;
for i := 1 to 15 do begin dec (t[i].x,d.x); dec (t[i].y,d.y); end;
setcolor (b); setfillstyle (1,b); Fillpoly (14,t);
end;
{---------------------------------------------------------------------------}
procedure DejNusi (ox,oy,b : word);
  var d : pointtype;
begin
t[1].x :=  624; t[1].y :=  436;
t[2].x :=  638; t[2].y :=  436;
t[3].x :=  636; t[3].y :=  454;
t[4].x :=  626; t[4].y :=  454;
t[5].x :=  620; t[5].y :=  444;
t[6].x :=  619; t[6].y :=  438;
t[7].x :=  624; t[7].y :=  436;
t[8].x :=  620; t[8].y :=  439;
t[9].x :=  626; t[9].y :=  454; d.x := t[1].x - ox; d.y := t[1].y - oy;
for i := 1 to 9 do begin dec (t[i].x,d.x); dec (t[i].y,d.y); end;
setcolor (b); setfillstyle (1,b); Fillpoly (9,t);
end;
{---------------------------------------------------------------------------}
procedure DejTruhlu(ox,oy,b : word);
  var d : pointtype;
begin
t[1].x :=  577; t[1].y :=  409;
t[2].x :=  577; t[2].y :=  423;
t[3].x :=  603; t[3].y :=  423;
t[4].x :=  603; t[4].y :=  409;
t[5].x :=  600; t[5].y :=  406;
t[6].x :=  581; t[6].y :=  406;
t[7].x :=  577; t[7].y :=  409;
d.x := t[1].x - ox; d.y := t[1].y - oy;
for i := 1 to 7 do begin dec (t[i].x,d.x); dec (t[i].y,d.y); end;
setcolor (b-8); setlinestyle (0,0,3); setfillstyle (1,b); Fillpoly (7,t);
setlinestyle (0,0,1);
end;
{---------------------------------------------------------------------------}
end.