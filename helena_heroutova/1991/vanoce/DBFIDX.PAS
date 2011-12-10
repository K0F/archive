unit DbfIdx;    { Fast word searching using hash indexing for DBF files }

{*******************************************************-

    New features to add --

    fix GetIndex and MakeIndex to be repeatable

    UpdateIndex (re-make index if FileModified)

-*******************************************************}

interface
uses Objects, Dbf, Str;

const
    IdxVers: word = $0100;
    QkListMax = 256;
    Copyright: string = 'DbfIdx unit Copyright (C) 8-13-04 James M. Clark';

type
    PIndexList = ^TIndexList;
    TIndexList = record
        case word of
        0: (Str: string[MaxWords]);
        1: (Lst: array[0..MaxWords] of byte);
    end;

    PWordArray = ^TWordArray;
    TWordArray = array[0..$3fff] of word;

    TListRec = record
        Data, Next: word;
    end;
    PRecList = ^TRecList;
    TRecList = array[1..$2ff0] of TListRec;

    TQkList = array[1..QkListMax] of word;      { make variable size ? }

    PDbfIdxFile = ^TDbfIdxFile;
    TDbfIdxFile = object(TDbfFile)
        IndexList: PIndexList;  {positions of fields to index}
        HashListSz: word;
        HashList: PWordArray;   {converts hash values to RecList indexes}
        RecListLen: word;
        RecListSz: word;
        RecList: PRecList;      {lists records for each hash hit}

        WordListLen: integer;
        WordList: TWordList;    {list words for current search}
        QkListLen: word;
        QkList: TQkList;    {lists records for current search}
        QkLimC: word;       {recommended word-match limit for search}
        FileModified: boolean;

        destructor Done; virtual;

        { Read memory lists from index file: }
        { (IndexList, HashList, and RecList) }
        function  GetIndex: boolean; virtual;

        { Make (or re-make) index file, including memory lists }
        { IndexList, HashList, and RecList: }
        procedure MakeIndex(AIndexList: TIndexList;
                    HashSz, RecSz: word); virtual;

        { Make WordList and QkList from words in S: }
        { TryFor argument is implicitly = 8. }
        procedure MakeQuickList(S: string);

        { Make WordList and QkList from words in S: }
        { Try to get at least TryFor items in the list, }
        { settling for less matches if necessary. }
        procedure MakeQuickList2(S: string;
                    TryFor: integer); virtual;

        { Read and compare quick-list record QL with WordList: }
        { Return true if MM or more matching words. }
        function  Compare(QL, MM: word): boolean; virtual;

        { true if S is one char or is found in ShortList: }
        function  ShortWord(S: string): boolean; virtual;

        {also sets FileModified:}
        function  WriteRec: boolean; virtual; {return success}
    end;

{*******************************************************}

implementation

const
    ShortListLen = 35;
    WrdsPerRec = SizeOf(TListRec) div SizeOf(word);

type
    TShortList = array[1..ShortListLen] of string[3];

const
    Separator = ' ,.:-;:''#"!&()/?0123456789';

    ShortList: TShortList = (
        'AN',  'AND', 'ANY', 'ARE', 'BE',  'BUT', 'BY',  'CAN',
        'FOR', 'GO',  'HE',  'HIS', 'HOW', 'II',  'III', 'IN',
        'IS',  'IV',  'MY',  'NOT', 'NOW', 'OF',  'ON',  'OR',
        'OUR', 'OUT', 'RE',  'THE', 'TO',  'TWO', 'UP',  'WE',
        'WHO', 'WHY', 'YOU'
    );

{*******************************************************}

destructor TDbfIdxFile.Done;
var
    I: word;
begin
    if RecList <> nil
    then FreeMem(RecList, RecListSz*SizeOf(TListRec));

    if HashList <> nil
    then FreeMem(HashList, HashListSz*SizeOf(word));

    if IndexList <> nil then begin
        I:= (IndexList^.Lst[0]+2) div 2;
        FreeMem(IndexList, I*SizeOf(word));
    end;

    inherited Done;
end; {TDbfIdxFile.Done}

{*******************************************************}

{ Read memory lists from index file: }
{ (IndexList, HashList, and RecList) }
function TDbfIdxFile.GetIndex: boolean;
var
    H, I: integer;
    S: string;
    IndexFile: file;
    xRevYr, xRevMo, xRevDa: word;

begin
    GetIndex:= false;
    S:= FileName;
    Delete(S, Length(FileName)-2, 3);
    {$I-}
    Assign(IndexFile, S+'hsh');
    Reset(IndexFile, SizeOf(word));
    {$I+}
    if IoResult <> 0 then
exit;

    { read file header: }
    BlockRead(IndexFile, H, 1, I);
    if H >= $0100 then begin
        IdxVers:= H;
        BlockRead(IndexFile, xRevYr, 1, I);
        BlockRead(IndexFile, xRevMo, 1, I);
        BlockRead(IndexFile, xRevDa, 1, I);
        if  (xRevDa <> RevDa) or
            (xRevMo <> RevMo) or
            (xRevYr <> RevYr)
        then begin
            Close(IndexFile);
exit;
        end;
        BlockRead(IndexFile, H, 1, I);
    end;

    { read index list: }
    if IndexList <> nil then begin
        I:= (IndexList^.Lst[0]+2) div 2;
        FreeMem(IndexList, I*SizeOf(word));
    end;
    GetMem(IndexList, H*SizeOf(word));
    BlockRead(IndexFile, IndexList^, H, I);
    if I <> H then begin
        Close(IndexFile);
exit;
    end;

    { read hash list: }
    if HashList <> nil
    then FreeMem(HashList, HashListSz*SizeOf(word));
    BlockRead(IndexFile, HashListSz, 1, I);
    GetMem(HashList, HashListSz*SizeOf(word));
    BlockRead(IndexFile, HashList^, HashListSz, I);
    if I <> HashListSz then begin
        Close(IndexFile);
exit;
    end;

    { read record list: }
    if RecList <> nil
    then FreeMem(RecList, RecListSz*SizeOf(TListRec));
    BlockRead(IndexFile, RecListLen, 1, I);
    RecListSz:= RecListLen;
    GetMem(RecList, RecListSz*SizeOf(TListRec));
    BlockRead(IndexFile, RecList^, WrdsPerRec*RecListLen, I);
    if I <> WrdsPerRec*RecListLen then begin
        Close(IndexFile);
exit;
    end;

    Close(IndexFile);
    GetIndex:= true;
end; {TDbfIdxFile.GetIndex}

{*******************************************************}

{ Make (or re-make) index file, including memory lists }
{ IndexList, HashList, and RecList: }
procedure TDbfIdxFile.MakeIndex(AIndexList: TIndexList;
                    HashSz, RecSz: word);
var
    H, I: word;
    R: longint;
    S: string;
    IndexFile: file;

begin
    { (re)allocate and copy IndexList: }
    if IndexList <> nil then begin
        I:= (IndexList^.Lst[0]+2) div 2;
        FreeMem(IndexList, I*SizeOf(word));
    end;
    H:= (AIndexList.Lst[0]+2) div 2;
    GetMem(IndexList, H*SizeOf(word));
    IndexList^.Str:= AIndexList.Str;
    {IndexList:= PIndexList(NewStr(AIndexList.Str));}

    { (re)allocate and clear HashList: }
    if HashListSz > 0 then begin
        FreeMem(HashList, HashListSz*SizeOf(word));
    end;
    HashListSz:= 1;
    repeat HashListSz:= HashListSz shl 1
    until HashListSz >= HashSz;
    GetMem(HashList, HashListSz*SizeOf(word));
    FillChar(HashList^, HashListSz*SizeOf(word), 0);

    { (re)allocate and clear RecList: }
    if RecListSz > 0 then begin
        FreeMem(RecList, RecListSz*SizeOf(TListRec));
    end;
    RecListLen:= 0;
    RecListSz:= RecSz;
    GetMem(RecList, RecListSz*SizeOf(TListRec));
    FillChar(RecList^, RecListSz*SizeOf(TListRec), 0);

    for R:= LastRec downto 1 do begin
        if RecListLen >= RecListSz-16 then                  {+}
    break;
        SeekRec(R); {opens file if needed}
        ReadRec;
        if not Deleted then begin
            S:= '';
            for I:= 1 to IndexList^.Lst[0] do begin
                S:= S + GetFieldStr(IndexList^.Lst[I]) + ' ';
            end;
            UpCaseStr(S);
            ParseStr(S, Separator, WordList, WordListLen);

            for I:= 1 to WordListLen do begin
                if RecListLen >= RecListSz-16 then          {+}
            break;
                if not ShortWord(WordList[I]) then begin
                    H:= HashStr(WordList[I]) and (HashListSz-1);
                    inc(RecListLen);
                    RecList^[RecListLen].Data:= R;
                    RecList^[RecListLen].Next:= HashList^[H];
                    HashList^[H]:= RecListLen;
                end;
            end;
        end;
    end;

    S:= FileName;
    Delete(S, Length(FileName)-2, 3);
    Assign(IndexFile, S+'hsh');
    Rewrite(IndexFile, SizeOf(word));

    BlockWrite(IndexFile, IdxVers,  1, I);
    BlockWrite(IndexFile, RevYr, 1, I);
    BlockWrite(IndexFile, RevMo, 1, I);
    BlockWrite(IndexFile, RevDa, 1, I);

    H:= (IndexList^.Lst[0]+2) div 2;  {2 bytes = 1 word}
    BlockWrite(IndexFile, H, 1, I);
    BlockWrite(IndexFile, IndexList^, H, I);

    BlockWrite(IndexFile, HashListSz, 1, I);        {++ check errors ++}
    BlockWrite(IndexFile, HashList^, HashListSz, I);

    BlockWrite(IndexFile, RecListLen, 1, I);
    BlockWrite(IndexFile, RecList^, WrdsPerRec*RecListLen, I);

    Close(IndexFile);
end; {TDbfIdxFile.MakeIndex}

{*******************************************************}

{ Make WordList and QkList from words in S: }
procedure TDbfIdxFile.MakeQuickList(S: string);
begin
    TDbfIdxFile.MakeQuickList2(S, 9);
end; {TDbfIdxFile.MakeQuickList}

{*******************************************************}

{ Make WordList and QkList from words in S: }
{ Try to get at least TryFor items in the list, }
{ settling for less matches if necessary. }
procedure TDbfIdxFile.MakeQuickList2(S: string; TryFor: integer);
var
    H, WL, QL, RL, R: word;
    Dup: boolean;
    QkLCnt: TQkList;    {counts word-matches for each record}
    QkMaxC: word;       {maximum word-match count}
    QkHist: TQkList;    {histogram of QkLCnt}

begin
    if HashList = nil then
exit;

    UpCaseStr(S);
    ParseStr(S, Separator, WordList, WordListLen);
    QkLimC:= 0;
    QL:= WordListLen;
    for WL:= 1 to QL do begin
        if not ShortWord(WordList[WL]) then begin
            ExpandWord(WordList[WL], WordList, WordListLen);
            inc(QkLimC);
        end;
    end;
    QkListLen:= 0;
    QkMaxC:= 1;

    for WL:= 1 to WordListLen do begin
        if not ShortWord(WordList[WL]) then begin
            H:= HashStr(WordList[WL]) and (HashListSz-1);
            RL:= HashList^[H];
            while RL > 0 do begin
                R:= RecList^[RL].Data;

                                    { change to insertion sort ? }
                QL:= 1;
                Dup:= false;
                while (QL <= QkListLen) and not Dup do begin
                    if QkList[QL] = R then begin
                        Dup:= true;
                        inc(QkLCnt[QL]);
                        if QkMaxC < QkLCnt[QL]
                        then QkMaxC:= QkLCnt[QL];
                    end;
                    inc(QL);
                end;

                if not Dup and (QkListLen < QkListMax) then begin
                    inc(QkListLen);
                    QkList[QkListLen]:= R;
                    QkLCnt[QkListLen]:= 1;
                end;
                RL:= RecList^[RL].Next;
            end;
        end;
    end;

    if QkListLen > 0 then begin
        for QL:= 1 to QkMaxC do begin
            QkHist[QL]:= 0;
        end;
        for QL:= 1 to QkListLen do begin
            inc(QkHist[ QkLCnt[QL] ]);
        end;
        WL:= 0;
        if QkMaxC < QkLimC then QkLimC:= QkMaxC;
        for QL:= QkMaxC downto 1 do begin
            inc(WL, QkHist[QL]);
            if WL >= TryFor then exit;
            if QL < QkLimC then QkLimC:= QL;
        end;
    end;
end; {TDbfIdxFile.MakeQuickList2}

{*******************************************************}

{ Read and compare quick-list record QL with WordList: }
{ Return true if MM or more matching words. }
function TDbfIdxFile.Compare(QL, MM: word): boolean;
var
    Matches, IL, WL: word;
    S: string;
begin
    SeekRec(QkList[QL]);
    ReadRec;
    Matches:= 0;
    Compare:= true;

    { for each search word.. }
    for WL:= 1 to WordListLen do begin
        if not ShortWord(WordList[WL]) then begin
            { for each index field.. }
            for IL:= 1 to IndexList^.Lst[0] do begin
                S:= GetFieldStr(IndexList^.Lst[IL]);
                UpCaseStr(S);
                if Pos(WordList[WL], S) > 0 then
            break;
            end;
            if Pos(WordList[WL], S) > 0 then begin
                inc(Matches);
                if Matches >= MM then
exit;
            end;
        end;
    end;
    Compare:= false;
end; {TDbfIdxFile.Compare}

{*******************************************************}

{ true if S is one char or is found in ShortList: }
function TDbfIdxFile.ShortWord(S: string): boolean;
var
    I: integer;
begin
    if Length(S) = 1 then begin
        ShortWord:= true;
        exit;
    end;

    if Length(S) > 3 then begin
        ShortWord:= false;
        exit;
    end;

    for I:= 1 to ShortListLen do begin
        if S = ShortList[I] then begin
            ShortWord:= true;
            exit;
        end;
    end;
    ShortWord:= false;
end; {TDbfIdxFile.ShortWord}

{*******************************************************}

function TDbfIdxFile.WriteRec: boolean;
begin
    WriteRec:= inherited WriteRec;
    FileModified:= true;
end; {TDbfIdxFile.WriteRec}

{*******************************************************}

end.
