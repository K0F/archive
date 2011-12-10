unIt Typyvl;
Interface
uses crt,graph;

const
 pausa : array [1..7] of word = (2048,1024,512,256,128,64,32);
 cu : array [1..10] of PointType = ((x:30;y:377),(x:100;y:400),(x:30;y:456),
    (x:80;y:448),(x:130;y:440),(x:230;y:390),(x:290;y:380),
    (x:340;y:400),(x:400;y:388),(x:470;y:390));
 stt : array [1..10] of word = (1,65,115,165,220,270,700,1400,1470,1540);

var
    pa0,pa1 : array [1..10] of Pointer;
    u       : array [1..10] of PointType;
    k,r1,r2,zem,maxx,maxy : word;
    n,m     : byte;
    konec : boolean;
    t1,t2 : record h,m,v,s : word end;
    uzbyl : set of Byte;

Implementation
end.