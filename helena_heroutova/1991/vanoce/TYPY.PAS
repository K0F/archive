Unit Typy;
Interface
uses crt,Dos,Graph,rozmery;
const PageUp = #73; PageDn = #81; F1 = #59; F2 = #60;
      Vlevo = #75; Vpravo = #77; Nahoru = #72; Dolu = #80; Esc = #27;
      Ridici = #0; Home = #71; Ende = #79; Ins = #82; Del = #83;
      Zpet = #8; Enter = #13; SipkaNahoru = #24; SipkaDolu = #25;
      SipkaVlevo = #27; SipkaVpravo = #26; Tbltr = #9; Zmiz = $2000;

type
    jmeno     = string [DelkaJmena];
    VJmen     = array[1..MaxPocet] of jmeno;
    polozka   = string[80];
    PoleVoleb = array[1..20] of polozka;
    SireVoleb =  array[1..20] of byte;
    cary      = array[1..8] of char;
    datum = record r,m,d,t : word end;
    mnozina   = set of byte;
    ukaz   = ^elent;
    elent  = record dal : ukaz; txt : polozka; end;
    popis     = record hr1,hr2,dr1,dr2 : polozka; barva : byte end;
    dvaradky  =  array [1..2] of polevoleb;
    predpis = record
                pocet,rozmer : byte; sirka : sirevoleb; m : mnozina;
                Zahlavi : dvaradky;
              end;

const
  BeznaRada = 'Pomoc¡  '+SipkaDolu+SipkaNahoru+
    '  si vyberte.   Enter = potvrzen¡ v˜bˆru.   Esc = n vrat.';
  libo = 'Stiskneme cokoli.';
  RadaDoMenu = 'Pomoc¡  '+SipkaDolu+SipkaNahoru+
    '  si vyberte.   Enter = potvrzen¡ v˜bˆru.';
  MenuSouboru : popis =
    (hr1:'Zvolte soubor, se kter˜m chcete pracovat :'; hr2:'';
    dr1:'Pomoc¡  '+SipkaDolu+SipkaNahoru+'  soubor vyberte.';
    dr2:'Enter = potvrzen¡ volby, Esc = zad n¡ nov‚ho souboru.'; barva : blue);
  PopisHlMenu : popis =
    (hr1:'M–‘eme V m nab¡dnout tyto slu‘by :'; hr2:''; dr1:'';
    dr2:BeznaRada; barva:cyan);

  cara1 : cary = 'ÚÄ¿³³ÀÄÙ';
  cara2 : cary = 'ÉÍ»ººÈÍ¼';

var
    volba                : byte;
    ch                   : char;
    i,j,karta,krz        : integer;
    OK,pribyl            : boolean;
    tv                   : PoleVoleb;
    nazev                : jmeno;
    f                    : text;

Implementation
end.