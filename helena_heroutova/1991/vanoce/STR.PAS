unit Str;   {some extra string functions}

interface

const
    Copyright: string = 'Str unit Copyright (C) 9-3-97 James M. Clark';

{ Compute a hash function of string S: }
{ Optionally, use AND or MOD to reduce hash size }
function HashStr(S: string): word;

{
  Re-arrange author format:
  Handles these formats:
    FN LN               -> FN LN                    1 author
    LN, FN              -> FN LN                    1 author
    LN1, FN1 & LN2, FN2 -> FN1 LN1 and FN2 LN2      2 authors
    FN1 LN1 & LN2, FN2  -> FN1 LN1 and FN2 LN2      2 authors
    LN, FN1 & FN2       -> FN1 and FN2 LN           husband & wife
    LN1, LN2, & LN3     -> LN1, LN2, & LN3          > 2 authors
  with '&' changed to 'and', and
  with 'and' recognized as '&', and
  with ', Jr.' and ', Sr.' moved to end,
  and (N) moved to end (N = a digit)
}
procedure FixAuthor(var A: string);

{ Break string S into words, listing words in word list WL: }
{ Words are separated by chars in Sep; # of words found is Len. }
{ Words are truncated to MaxWord chars, list to MaxWords words. }
const
    MaxWord = 32;
    MaxWords = 64;
type
    PWordList = ^TWordList;
    TWordList = array[1..MaxWords] of string[MaxWord];
procedure ParseStr(S, Sep: string; var WL: TWordList; var Len: integer);

{ expand word S to additional words in WL: }
{ assumes WL and Len are already initialized }
procedure ExpandWord(S: string; var WL: TWordList; var Len: integer);

{ Find last space before position P in string S: }
function LastSpace(const S: string; P: integer): integer;

{ Remove leading and trailing spaces: }
procedure TrimSpace(var S: string);

{ Shift all chars of S to upper case: }
procedure UpCaseStr(var S: string);

{ Remove all control & extended chars from S: }
{ except each tab changed to a space }
procedure CleanStr(var S: string);

{ Wrap text from S into string array DD, at position P of L lines: }
{ Parameter DD may actually be array[1..LL] of string, for any }
{ LL >= L, but is limited as for array[1..L] of string[M]. }
type
    TTextList = array[1..99] of string;
procedure WrapText(S: string; var DD; var P: integer; L, M: integer);

implementation

{*******************************************************}

(*******
procedure MakeRandTbl;
var
    I, J, K: integer;
    R: array[0..127] of word;

begin
    for I:= 0 to 127 do begin
        R[I]:= I;
    end;

    for I:= 0 to 125 do begin
        J:= IRand(127-I);
        K:= R[I+J+1];
        R[I+J+1]:= R[I];
        R[I]:= K;
    end;

    for I:= 0 to 127 do begin
        write(R[I]:4, ',');
        if (I and 7) = 7 then writeln;
    end;
end; {MakeRandTbl}
*******)

type
    TRandTable = array[0..127] of word;
const
    RTbl: TRandTable = (
          7,  41,  70,  20, 119, 126,  89,  49,
         77,  71,  63,   6,  67,  31,  79,  93,
         76,  44, 111,  45, 118,  24, 124,  17,
         74, 116,  54,   9,  59, 110,  36, 108,
          8, 106,  18,  72, 107, 123,  37,  55,
         57,  62,  13, 113,  15,  56, 125,  97,
         85, 109,  64,  32,  94,  21,  30,  11,
          1,  48,  43, 100,   2,  81,  99, 102,
         25, 105,  34,  80, 117,  33,   5,  40,
         83, 127,  19,  78,  35,  98,  39,  61,
          3,  58,  53,  68,   0, 103,  10,   4,
         22,  12, 121,  14,  88,  92,  91,  42,
        101,  23,  50,  86,  95,  87, 112,  65,
         27, 120, 122,  96,  69,  82,  75,  90,
        115,  47,  28,  51, 104,  84,  26,  52,
         46,  73,  38,  16, 114,  66,  60,  29
    );

{ Compute a hash function of string S: }
{ Optionally, use AND or MOD to reduce hash size }
function HashStr(S: string): word;
var
    A, N, R: word;
begin
    A:= 0;
    for N:= 1 to Length(S) do begin
        R:= RTbl[(Ord(S[N]) + RTbl[N and 127]) and 127];
        inc(A, R shl ((3*N) and 7));
    end;
    HashStr:= A + (A shr 7);
end; {HashStr}

{*******************************************************}

{
  Re-arrange author format:
  Handles these formats:
    FN LN               -> FN LN                    1 author
    LN, FN              -> FN LN                    1 author
    LN1, FN1 & LN2, FN2 -> FN1 LN1 and FN2 LN2      2 authors
    FN1 LN1 & LN2, FN2  -> FN1 LN1 and FN2 LN2      2 authors
    LN, FN1 & FN2       -> FN1 and FN2 LN           husband & wife
    LN1, LN2, & LN3     -> LN1, LN2, & LN3          > 2 authors
  with '&' changed to 'and', and
  with 'and' recognized as '&', and
  with ', Jr.' and ', Sr.' moved to end,
  and (N) moved to end (N = a digit)
}
procedure FixAuthor(var A: string);
var
    S1, S2, T1, T2: string;
    P1, P2, P1x, P2x: integer;

    { Switch first and last names: }
    { change LN, FN  ->  FN LN }
    procedure SwitchNames(var A: string);
    var
        P1: integer;
        S2: string;
    begin
        P1:= Pos(',', A);
        if P1 > 0 then begin
            if (A[P1+1] = ' ') then Delete(A, P1+1, 1);
            S2:= Copy(A, P1+1, 255);
            {if (S2 = 'Jr.') or (S2 ='M. A.') then begin
                A:= Copy(A, 1, P1) + ' ' + S2;
            end else} begin
                A:= S2 + ' ' + Copy(A, 1, P1-1);
            end;
        end;
    end; {SwitchNames}

    { Extract special string out of S and into D: }
    { Special strings are ', Jr.', ', Sr.', and ' (digit)'. }
    { ',' and ' ' are inserted if missing. }
    procedure GetSpecial(var S, D: string);
    var
        P: integer;

        procedure FixComma;
        begin
            Delete(S, P, 3);
            if S[P-1] = ' ' then begin
                Delete(S, P-1, 1);
                if S[P-2] = ',' then begin
                    Delete(S, P-2, 1);
                end;
        exit;
            end;

            if S[P-1] = ',' then begin
                Delete(S, P-1, 1);
            end;
        end; {FixComma}

    begin {GetSpecial}
        P:= Pos('Jr.', S);
        if P > 2 then begin
            D:= ', Jr.';
            FixComma;
    exit;
        end;

        P:= Pos('Sr.', S);
        if P > 2 then begin
            D:= ', Sr.';
            FixComma;
    exit;
        end;

        P:= Pos(' II', S);
        if (P > 2) and ((P+3 > Length(S)) or (S[P+3] = ' '))
        then begin
            D:= ' II';
            Delete(S, P, 3);
    exit;
        end;

        P:= Pos(' I', S);
        if (P > 2) and ((P+2 > Length(S)) or (S[P+2] = ' '))
        then begin
            D:= ' I';
            Delete(S, P, 2);
    exit;
        end;

        P:= Pos(')', S);
        if (P > 3) and (S[P-2] = '(') and
            (S[P-1] >= '0') and (S[P-1] <= '9')
        then begin
            D:= ' ( )';  D[3]:= S[P-1];
            Delete(S, P-2, 3);
            if S[P-3] = ' '
            then Delete(S, P-3, 1);
    exit;
        end;

        D:= '';
    end; {GetSpecial}

begin {FixAuthor}
    { check if <author> <and> <author> form: }
    P1:= Pos('&', A);
    if P1 > 2 then begin
        P2:= P1;
        if (A[P1-1] = ' ') then dec(P1);
        if (A[P1-1] = ',') then exit   {multiple authors}
        else
        if (A[P2+1] = ' ') then inc(P2);
    end else begin
        P1:= Pos(' and ', A);
        P2:= P1 + 4;
    end;

    if P1 > 2 then begin    { two authors}
        S1:= Copy(A, 1, P1-1);
        S2:= Copy(A, P2+1, 255);
        GetSpecial(S1, T1); {extract special strings}
        GetSpecial(S2, T2);
        {
            special case:
            last, first1 and first2
            -->
            first1 and first2 last
            not:
            first1 last and first2
        }
        P1x:= Pos(',', S1);
        P2x:= Pos(',', S2);
        if (P1x > 0) and (P2x = 0) then begin
            A:= S1 + ' and ' + S2;
            SwitchNames(A);
            A:= A + T1;
        end else begin
            SwitchNames(S1);
            SwitchNames(S2);
            A:= S1 + T1 + ' and ' + S2 + T2;
        end;
    end else begin          { one author}
        GetSpecial(A, T1);
        SwitchNames(A);
        A:= A + T1;
    end;
end; {FixAuthor}

{*******************************************************}

{ Find last space before position P in string S: }
function LastSpace(const S: string; P: integer): integer;
begin
    if P > 1 then begin
        repeat dec(P);
        until (P = 0) or (S[P] = ' ');
        LastSpace:= P;
    end else begin
        LastSpace:= 0;
    end;
end; {LastSpace}

{*******************************************************}

{ Break string S into words, listing words in word list WL: }
{ Words are separated by chars in Sep; # of words found is Len. }
{ Words are truncated to MaxWord chars, list to MaxWords words. }
procedure ParseStr(S, Sep: string; var WL: TWordList; var Len: integer);
var
    P, PP: integer;
begin
    for P:= 1 to Length(S) do begin
        if Pos(S[P], Sep) > 0 then S[P]:= #1;
    end;

    Len:= 0;
    P:= Pos(#1, S);
    while P > 0 do begin
        if P > 1 then begin
            inc(Len);
            if P > MaxWord+1 then PP:= MaxWord else PP:= P-1;
            WL[Len]:= Copy(S, 1, PP);
            if Len >= MaxWords then
exit;
        end;
        Delete(S, 1, P);
        P:= Pos(#1, S);
    end;

    if Length(S) > 0 then begin
        inc(Len);
        WL[Len]:= S;
    end;
end; {ParseStr}

{ expand word S to additional words in WL: }
{ assumes WL and Len are already initialized }
procedure ExpandWord(S: string; var WL: TWordList; var Len: integer);
var
    P, PP: integer;
    PenUlt, Last: char;
    Dbl: boolean;

    procedure Add(S2: string);
    begin
        if Len >= MaxWords then
exit;
        inc(Len);
        WL[Len]:= S + S2;
    end; {Add}

    procedure AddE(S2: string);
    var
        S1: string;
    begin
        if Len >= MaxWords then
exit;
        S1:= S;
        dec(S1[0]);
        inc(Len);
        WL[Len]:= S1 + S2;
    end; {Add}

begin {ExpandWord}
    if Length(S) = 0 then
exit;

    Last:= S[Length(S)];
    if Length(S) > 1 then PenUlt:= S[Length(S)-1] else PenUlt:= ' ';
    Dbl:= (Last = S[Length(S)-1]);

    case Last of
        'J', 'O', 'S', 'U', 'V', 'X', 'Z': Add('ES');
        'F':
            if PenUlt = 'L'
            then AddE('VES')
            else Add('S');
        'Y':
            begin
               Add('S');
               AddE('IES');
               AddE('IER');
               AddE('IERS');
               AddE('IED');
               AddE('IABLE');
               AddE('ILY');
            end;
        else Add('S');
    end; {case}

    case Last of
        'E':
            begin
                Add('R');
                Add('RS');
                Add('D');
                Add('RED');
                AddE('ING');
                AddE('INGS');
                AddE('ABLE');
            end;

        'B', 'D', 'F', 'G', 'M', 'N', 'P', 'T':
            begin
                Add('ER');
                Add('ERS');
                Add('ED');
                Add('ERED');
                Add('ING');
                Add('INGS');
                Add('ABLE');
                Add('IBLE');
                Add('LY');

                Add(Last+'ER');
                Add(Last+'ERS');
                Add(Last+'ED');
                Add(Last+'ERED');
                Add(Last+'ING');
                Add(Last+'INGS');
                Add(Last+'ABLE');
                Add(Last+'IBLE');
            end;
        'K', 'L', 'R', 'S', 'W', 'X', 'Y':
            begin
                Add('ER');
                Add('ERS');
                Add('ED');
                Add('ERED');
                Add('ING');
                Add('INGS');
                Add('ABLE');
                Add('IBLE');
                Add('LY');
            end;
    end; {case}
end; {ExpandWord}

{*******************************************************}

{ Remove leading and trailing spaces: }
procedure TrimSpace(var S: string);
begin
    while (S <> '') and (S[Length(S)] = ' ')
    do Delete(S, Length(S), 1);
    while (S <> '') and (S[1] = ' ')
    do Delete(S, 1, 1);
end; {TrimSpace}

{*******************************************************}

{ Shift all chars of S to upper case: }
procedure UpCaseStr(var S: string);
var
    P: integer;
begin
    for P:= 1 to Length(S) do begin
        S[P]:= UpCase(S[P]);
    end;
end; {UpCaseStr}

{*******************************************************}

{ Remove all control & extended chars from S: }
{ except each tab changed to a space }
procedure CleanStr(var S: string);
var
    P: integer;
begin
    for P:= Length(S) downto 1 do begin
        if (S[P] < #32) or (S[P] > #126) then begin
            if S[P] = #9 {tab}
            then S[P]:= ' '
            else Delete(S, P, 1);
        end;
    end;
end; {CleanStr}

{*******************************************************}

{ Wrap text from S into string array DD, at position P of L lines: }
{ Parameter DD may actually be array[1..LL] of string, for any }
{ LL >= L, but is limited as for array[1..L] of string[M]. }
procedure WrapText(S: string; var DD; var P: integer; L, M: integer);
var
    R: integer;
    D: TTextList absolute DD;
begin
    { while source and destination line remaining }
    while (Length(S) > 0) and (P <= L) do begin
        { compute room in D[P] }
        if Length(D[P]) = 0
        then R:= M
        else R:= M - Length(D[P]) - 1;
        if Length(S) <= R then begin
            { entire S fits; move it }
            if Length(D[P]) = 0
            then D[P]:= S
            else D[P]:= D[P] + ' ' + S;
            S:= '';
        end else begin
            { find wrap position }
            R:= LastSpace(S, R);
            if R > 0 then begin
                { move a piece of S to D[P] }
                if Length(D[P]) > 0
                then D[P]:= D[P] + ' ';
                D[P]:= D[P] + Copy(S, 1, R-1);
                Delete(S, 1, R);
            end else begin
                { can't wrap; try next destination line }
                inc(P);
            end;
        end;
    end;
end; {WrapText}

{*******************************************************}

end.
