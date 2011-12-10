unit DBF;
{&Use32-}

{*******************************************************}
{                                                       }
{                       DBF.pas                         }
{                                                       }
{   a database engine for interfacing to *.DBF files    }
{                                                       }
{           Copyright (C) 1997 James M. Clark           }
{                                                       }
{*******************************************************}

interface
uses Objects, Dos;

const
    Copyright: string = 'DBF unit Copyright (C) 3-7-97 James M. Clark';

(*******************************************************-

Outline of usage -

    To open an existing dbf file -
        var DbfFile1: PDbfFile;
            FName1: PathStr;
        DbfFile1:= New(PDbfFile, OpenOld(FName1));

    To check file errors, look at -
        if DbfFile1^.FileError <> 0 then Halt;

    When done with a dbf file -
        DbfFile1^.Free;     {also frees associated record buffer}

    To open a new dbf file, copying structure from another file -
        var DbfFile2: PDbfFile;
            FName2: PathStr;
        DbfFile2:= New(PDbfFile, OpenCopy(FName2, DbfFile1));

    To get field positions of a 'known' file, good practice is -
        var fAuthor, fTitle: word;          {etc}
        with DbfFile1^ do begin
            fTitle:= GetFieldPos('Title');  {case is ignored}
            fCost:=  GetFieldPos('Cost');   {etc}
        end;        {returns 0 if name not found}

    To get field attributes, use, for example -
        var Name: TFieldName;
            Type: char;
            Width, DecPos: byte;
        with DbfFile1^ do begin
            Name:=   GetName(fCost);
            Type:=   GetType(fCost);
            Width:=  GetWidth(fCost);   {byte for N, word for C,D types}
            DecPos:= GetDecPos(fCost);  {for N type fields only}
        end;

    To define a record structure, first create a record buffer -
        var RecBuf3: PRecBuf;
        RecBuf3:= New(PRecBuf, Init);

    - then add field definitions (not checked) -
        with RecBuf3^ do begin
            AppendField('AUTHOR', 'C', 30, 0);
            AppendField('COST',   'N',  8, 2);  {etc}
        end;

    (TDbfFile is a descendant of TRecBuf.)

    To create a new dbf file with this record structure -
        var DbfFile3: PDbfFile;
            FName3: PathStr;
        DbfFile3:= New(PDbfFile, OpenCopy(FName3, RecBuf3));
        RecBuf3^.Free;  {don't need it any more}

    Before reading or writing a record, move to the desired record -
        var N: longint;
        DbfFile1.SeekRec(N);    {ready to read/write record N}

    To read a record -
        var IdNum: integer;
            Author: string[30];
            Cost: TReal;
        with DbfFile1^ do begin
            ReadRec;    {moves to next record (or EOF)}
            IdNum:=  GetFieldInt(fIdNum);   {'N' type field}
            Author:= GetFieldStr(fAuthor);  {'C' type field}
            Cost:=   GetFieldReal(fCost);   {'N' type field}
                {etc}
        end;

    Note that GetFieldInt is appropriate when there is no fractional
    part (it returns an integer); else use GetFieldReal, which returns
    a TReal (normally configured as single).  GetFieldStr trims
    trailing spaces.

    To write a record -
        with DbfFile1^ do begin
            ClearRec;   {sets all spaces in record buffer}
            PutFieldInt(fIdNum, IdNum);
            PutFieldStr(fAuthor, Author);
            PutFieldReal(fCost, Cost);
            WriteRec;   {moves to next record (or EOF)}
        end;

    The 'put' routines pad the fields with spaces as needed, so that
    ClearRec is needed only if data is not put into all fields.

    To copy from another record:
        DbfFile1^.CopyRec(RecBuf);

    ClearRec, CopyRec, and the Put.. procedures set RecModified,
    and WriteRec, ReadRec clear RecModified.

    To rewrite current record if RecModified:
        Updated:= DbfFile1^.UpdateRec;

    To safeguard data integrity, frequently call -
        DbfFile1^.Commit;

    -------------------------------------------------
    New features to add --

    Eof function -- CurRec > LastRec, or cannot read or write

    Pack, Sort & PutAllXxx procedures for entire file

    (IdxDbf should override some of these.)

-*******************************************************)

type
    TFieldName = string[10];
    TReal = single;
    PCharArr = ^TCharArr;
    TCharArr = array[1..9999] of char;

    { Date field has length = 8 and format YYYYMMDD. }
    { Logical field is either 'T' or 'F' (True or False). }
    { ('Y' also accepted for Yes or True) }
    { Delete field is '*' for deletion, ' ' otherwise. }
    { Memo fields are not supported. }

    { for field specification: }
    TFieldSpec = record
        Name: TFieldName;
        Offset: word;
        case FType: char of
        'C', 'D', 'L': (
            FWidth: word;
        );
        'N': (
            Width, DecPos: byte;
        );
    end;
    PFieldList = ^TFieldList;
    TFieldList = array[1..999] of TFieldSpec;

    { generic record buffer: }
    PRecBuf = ^TRecBuf;
    TRecBuf = object(TObject)
        RecLen: word;
        RecImage: PCharArr;     {RecLen char's}
        NumFields: word;
        FieldList: PFieldList;  {NumFields TFieldSpec's}
        { current record state: }
        Deleted: boolean;
        RecModified: boolean;
        { define record: }
        constructor Init;       {also need AppendField}
        procedure AppendField(AName: TFieldName; AType: char;
                            AWidth: word;   { for C, N types  }
                            ADecPos: byte   { for N type only }
                            ); virtual;
        constructor CopyStruc(RecBuf: PRecBuf);
        destructor Done; virtual;
        { get structure info: }
        function GetFieldPos(AName: TFieldName): word; virtual;
        function GetName(APos: word): TFieldName;
        function GetType(APos: word): char;
        function GetWidth(APos: word): word;    { for C, N types  }
        function GetDecPos(APos: word): byte;   { for N type only }
        { get data: }
        function GetFieldStr(APos: word): string; virtual;
        function GetFieldInt(APos: word): longint; virtual;
        function GetFieldReal(APos: word): TReal; virtual;
        function GetFieldBool(APos: word): boolean; virtual;
        { put data: }
        procedure PutFieldStr(APos: word; S: string); virtual;
        procedure PutFieldInt(APos: word; I: longint); virtual;
        procedure PutFieldReal(APos: word; R: TReal); virtual;
        procedure PutFieldBool(APos: word; B: boolean); virtual;
        procedure ClearRec; virtual;
        procedure CopyRec(RecBuf: PRecBuf); virtual;
        { use longint get, put for fast date comparison }
    end;

    {   DOS routines that can also help:
            GetFAttr, SetFAttr; (assigned, not open; use Attr: word)
            GetFTime, SetFTime; (assigned and open; use Time: longint)
            UnpackTime, PackTime; (use Time: longint)
    }

    { generic DBF file: }
    PDbfFile = ^TDbfFile;
    TDbfFile = object(TRecBuf)  {it includes a record buffer}
        FileName: PathStr;
        DataFile: file;
        { file header data: }
        DbfId: byte;
        RevYr, RevMo, RevDa: word;
        LastRec: longint;
        DataOffset: integer;    {= HdrLen-RecLen}
        { current file state: }
        CurRec: longint;    {current record number; file position}
        FileError: word;
        FileOpen: boolean;

        { open new file, copying structure from Buf: }
        { Buf can also be a PDbfFile }
        { adds '.dbf' to Name if missing }
        constructor OpenCopy(Name: PathStr; Buf: PRecBuf);

        { open an existing file: }
        { adds '.dbf' to Name if missing }
        constructor OpenOld(Name: PathStr);

        destructor Done; virtual;

        { write dbf file header; opens file if needed: }
        procedure WriteHeader; virtual;

        { use, with RecBuf methods, to get and put data: }

        { seek to given record number (opens file if needed): }
        { seek to 1 (or less) moves to beginning of file }
        { seek to LastRec+1 (or more) moves to end of file }
        procedure SeekRec(RecNum: longint); virtual;

        { read record at current position, return success: }
        { makes record data available in record buffer, advances position }
        { assumes SeekRec has been called }
        { check Deleted after each read }
        function ReadRec: boolean; virtual; {return success}

        { write record at current position, return success: }
        { assumes record data is ready in record buffer, advances position }
        { assumes SeekRec has been called }
        { to delete/undelete record, assign Deleted, then write }
        function WriteRec: boolean; virtual; {return success}

        { rewrite current record if RecModified: }
        function UpdateRec: boolean; virtual; {return done}

        { update disk image of data file: }
        procedure Commit; virtual;

    private
        HdrNeedsUpdate: boolean;
        NewDate: boolean;
    end;

implementation
uses Strings;

{*******************************************************}
{                                           TRecBuf     }
{*******************************************************}

{ START of initialization; use AppendField to finish: }
constructor TRecBuf.Init;
begin
    inherited Init;
    RecLen:= 1;
    RecImage:= PCharArr(@Copyright);
    RecImage:= nil;
    {NumFields:= 0;}
    {FieldList:= nil;}
    {Deleted:= false;}
    {RecModified:= false;}
end; {TRecBuf.Init}

{*******************************************************}

procedure TRecBuf.AppendField(AName: TFieldName; AType: char;
                    AWidth: word; ADecPos: byte);
var
    NewList: PFieldList;

begin
    if AWidth < 1 then
exit;

    inc(NumFields);
    GetMem(NewList, NumFields*SizeOf(TFieldSpec));
    if NewList = nil then RunError(250);
    if FieldList <> nil then begin
        Move(FieldList^, NewList^, (NumFields-1)*SizeOf(TFieldSpec));
        FreeMem(FieldList, (NumFields-1)*SizeOf(TFieldSpec));
    end;
    FieldList:= NewList;
    if RecImage <> nil then FreeMem(RecImage, RecLen);

    with FieldList^[NumFields] do begin
        Name:= AName;
        Offset:= RecLen+1;
        FType:= AType;
        case AType of
         'N': begin
            Width:= AWidth and $FF;
            inc(RecLen, Width);
            DecPos:= ADecPos;
         end;
         'C': begin
            FWidth:= AWidth;
            inc(RecLen, AWidth);
         end;
         'D': begin
            FWidth:= 8;
            inc(RecLen, AWidth);
         end;
         'L': begin
            FWidth:= 1;
            inc(RecLen, AWidth);
         end;
        end; {case}
    end;

    GetMem(RecImage, RecLen);
    if RecImage = nil then RunError(250);
end; {TRecBuf.AppendField}

{*******************************************************}

constructor TRecBuf.CopyStruc(RecBuf: PRecBuf);
begin
    inherited Init;
    if RecBuf = nil then
exit;
    if RecBuf^.RecImage = nil then RunError(250);
    if RecBuf^.FieldList = nil then RunError(250);
    {Deleted:= false;}
    {RecModified:= false;}

    RecLen:= RecBuf^.RecLen;
    NumFields:= RecBuf^.NumFields;

    GetMem(RecImage, RecLen);
    if RecImage = nil then RunError(250);
    Move(RecBuf^.RecImage^, RecImage^, RecLen);

    GetMem(FieldList, NumFields*SizeOf(TFieldSpec));
    if FieldList = nil then RunError(250);
    Move(RecBuf^.FieldList^, FieldList^, NumFields*SizeOf(TFieldSpec));
end; {TRecBuf.CopyStruc}

{*******************************************************}

destructor TRecBuf.Done;
begin
    if RecImage <> nil
    then FreeMem(RecImage, RecLen);

    if FieldList <> nil
    then FreeMem(FieldList, NumFields*SizeOf(TFieldSpec));

    inherited Done;
end; {TRecBuf.Done}

{*******************************************************}

function TRecBuf.GetFieldPos(AName: TFieldName): word;

    { string compare, ignoring case: }
    function CaseEqual(var S1, S2: string): boolean;
    var
        I: integer;
    begin
        CaseEqual:= false;
        if Length(S1) = Length(S2) then begin
            for I:= 1 to Length(S1) do begin
                if UpCase(S1[I]) <> UpCase(S2[I]) then
    exit;
            end;
            CaseEqual:= true;
        end;
    end; {CaseEqual}

var
    FPos: word;
    S: string;

begin { find field name in list: }
    for FPos:= 1 to NumFields do begin
        if CaseEqual(AName, FieldList^[FPos].Name) then begin
            GetFieldPos:= FPos;
exit;
        end;
    end;
    GetFieldPos:= 0;    {error}
    Deleted:= true;
end; {TRecBuf.GetFieldPos}

{*******************************************************}

function TRecBuf.GetName(APos: word): TFieldName;
begin
    if (APos < 1) or (APos > NumFields) then begin
        GetName:= '';
    end else with FieldList^[APos] do begin
        GetName:= Name;
    end;
end; {TRecBuf.GetName}

{*******************************************************}

function TRecBuf.GetType(APos: word): char;
begin
    if (APos < 1) or (APos > NumFields) then begin
        GetType:= ' ';
    end else with FieldList^[APos] do begin
        GetType:= FType;
    end;
end; {TRecBuf.GetType}

{*******************************************************}

function TRecBuf.GetWidth(APos: word): word;
begin
    if (APos < 1) or (APos > NumFields) then begin
        GetWidth:= 0;
    end else with FieldList^[APos] do begin
        if FType = 'N' then begin
            GetWidth:= Width;
        end else begin
            GetWidth:= FWidth;
        end;
    end;
end; {TRecBuf.GetWidth}

{*******************************************************}

function TRecBuf.GetDecPos(APos: word): byte;
begin
    if (APos < 1) or (APos > NumFields) then begin
        GetDecPos:= 0;
    end else with FieldList^[APos] do begin
        if FType = 'N' then begin
            GetDecPos:= DecPos;
        end else begin
            GetDecPos:= 0;
        end;
    end;
end; {TRecBuf.GetDecPos}

{*******************************************************}

{ trims trailing spaces }
function TRecBuf.GetFieldStr(APos: word): string;
var
    S: string;
    P: integer;
begin
    if (APos < 1) or (APos > NumFields)
    then GetFieldStr:= ''
    else with FieldList^[APos] do begin
        P:= GetWidth(APos);
        while (P > 0) and (RecImage^[Offset+P-1] = ' ') do dec(P);
        Move(RecImage^[Offset], S[1], P);
        S[0]:= Chr(P);
        GetFieldStr:= S;
    end;
end; {TRecBuf.GetFieldStr}

{*******************************************************}

{ can use this for D or N fields }
function TRecBuf.GetFieldInt(APos: word): longint;
var
    S: string;
    I: longint;
    E: longint;
begin
    S:= GetFieldStr(APos);
    Val(S, I, E);
    GetFieldInt:= I;
end; {TRecBuf.GetFieldInt}

{*******************************************************}

{ can use this for N fields, even if no decimal point }
function TRecBuf.GetFieldReal(APos: word): TReal;
var
    S: string;
    R: TReal;
    E: longint;
begin
    S:= GetFieldStr(APos);
    Val(S, R, E);
    GetFieldReal:= R;
end; {TRecBuf.GetFieldReal}

{*******************************************************}

function TRecBuf.GetFieldBool(APos: word): boolean;
var
    S: string;
    Ch: char;
begin
    if (APos > 0) and (APos <= NumFields)
    then with FieldList^[APos] do begin
        Ch:= UpCase(RecImage^[Offset]);
        GetFieldBool:= (Ch = 'Y') or (Ch = 'T');    {Yes or True}
    end else begin
        GetFieldBool:= false;
    end;
end; {TRecBuf.GetFieldBool}

{*******************************************************}

procedure TRecBuf.PutFieldStr(APos: word; S: string);
var
    L: integer;
begin
    if (APos > 0) and (APos <= NumFields)
    then with FieldList^[APos] do begin
        L:= Length(S);
        if L > FWidth then L:= FWidth;
        Move(S[1], RecImage^[Offset], L);
        if L < FWidth
        then FillChar(RecImage^[Offset+L], FWidth-L, ' ');
        RecModified:= true;
    end;
end; {TRecBuf.PutFieldStr}

{*******************************************************}

{ can use this for D or N fields }
procedure TRecBuf.PutFieldInt(APos: word; I: longint);
var
    S: string;
begin
    if (APos > 0) and (APos <= NumFields)
    then with FieldList^[APos] do begin
        Str(I:Width, S);
        Move(S[1], RecImage^[Offset], Width);
        RecModified:= true;
    end;
end; {TRecBuf.PutFieldInt}

{*******************************************************}

{ can use this for N fields; half-rounds last digit }
procedure TRecBuf.PutFieldReal(APos: word; R: TReal);
var
    S: string;
begin
    if (APos > 0) and (APos <= NumFields)
    then with FieldList^[APos] do begin
        Str(R:Width:DecPos, S);
        Move(S[1], RecImage^[Offset], Width);
        RecModified:= true;
    end;
end; {TRecBuf.PutFieldReal}

{*******************************************************}

procedure TRecBuf.PutFieldBool(APos: word; B: boolean);
var
    S: string;
begin
    if (APos > 0) and (APos <= NumFields)
    then with FieldList^[APos] do begin
        if B then RecImage^[Offset]:= 'Y'
        else      RecImage^[Offset]:= 'N';
        RecModified:= true;
    end;
end; {TRecBuf.PutFieldBool}

{*******************************************************}

procedure TRecBuf.ClearRec;
begin
    FillChar(RecImage^[1], RecLen, ' ');
    Deleted:= false;
    RecModified:= true;
end; {TRecBuf.ClearRec}

{*******************************************************}

procedure TRecBuf.CopyRec(RecBuf: PRecBuf);
begin
    if RecLen <> RecBuf^.RecLen then RunError(250);
    Move(RecBuf^.RecImage^, RecImage^, RecLen);
    Deleted:= false;
    RecModified:= true;
end; {TRecBuf.CopyRec}

{*******************************************************}
{                                           TDbfFile    }
{*******************************************************}

type
    { header formats: }
    TDbfHdr = record    {32 bytes}
        DDbfId, DRevYr, DRevMo, DRevDa: byte;
        DLastRec: longint;
        DHdrLen, DRecLen: word;
        DFill: array[1..10] of word;
    end;

    TFldHdr = record    {32 bytes}
        HName: array[1..11] of char;
        case HType: char of
        'C', 'D', 'L': (
            CFill1: array[1..4] of byte;
            CWidth: word;
            CFill2: array[1..14] of byte;
        );
        'N': (
            NFill1: array[1..4] of byte;
            NWidth, NDecPos: byte;
            NFill2: array[1..14] of byte;
        );
    end;

    TPaddedHdr = record {33 bytes}
        Overlap: byte;
        PFill: array[1..31] of byte;
        LookAhead: byte;
    end;

{*******************************************************}

{ open new file, copying structure from Buf: }
{ Buf can also be a PDbfFile }
constructor TDbfFile.OpenCopy(Name: PathStr; Buf: PRecBuf);
var
    N: longint;
    B: byte;

begin
    if Buf = nil then
exit;

    CopyStruc(Buf); {an inherited constructor}
        {Deleted:= false;}
        {RecModified:= false;}

    {RevYr:= 0;}
    {RevMo:= 0;}
    {RevDa:= 0;}
    {LastRec:= 0;}
    {FileOpen:= false;}
    {HdrNeedsUpdate:= false;}
    {CurRec:= 0;}
    DbfId:= 3;      {no memo fields}
    DataOffset:= integer(Numfields+1)*32+2-RecLen;

    if Pos('.', Name) = 0
    then FileName:= FExpand(Name + '.dbf')
    else FileName:= FExpand(Name);
    {$I-}
    Assign(DataFile, FileName);
    Rewrite(DataFile, 1);
    {$I+}
    FileError:= IOResult;
    if FileError = 0 then begin
        FileOpen:= true;
        WriteHeader;    {sets NewDate:= true}
        B:= $00;
        BlockWrite(DataFile, B, 1, N);
        SeekRec(1);
    end else begin
        Close(DataFile);
    end;
end; {TDbfFile.OpenCopy}

{*******************************************************}

{ open an existing file: }
{ DbfId should = 3, else memo fields are ignored }
constructor TDbfFile.OpenOld(Name: PathStr);
var
    XDbfHdr: TPaddedHdr;
    DbfHdr: TDbfHdr absolute XDbfHdr;
    XFldHdr: TPaddedHdr;
    FldHdr: TFldHdr absolute XFldHdr;
    LA: byte;
    N: longint;

begin
    inherited Init;
        {RecLen:= 1;}
        {RecImage:= nil;}
        {NumFields:= 0;}
        {FieldList:= nil;}
        {Deleted:= false;}
        {RecModified:= false;}

    {FileOpen:= false;}
    {HdrNeedsUpdate:= false;}
    {CurRec:= 0;}
    {NewDate:= false;}
    if Pos('.', Name) = 0
    then FileName:= FExpand(Name + '.dbf')
    else FileName:= FExpand(Name);
    {$I-}
    Assign(DataFile, FileName);
    Reset(DataFile, 1);
    {$I+}
    FileError:= IOResult;

    if FileError = 0 then begin
        FileOpen:= true;
        BlockRead(DataFile, XDbfHdr, SizeOf(XDbfHdr), N);
        with DbfHdr do begin
            DbfId:= DDbfId;
            if DRevYr < 70
            then RevYr:= 2000 + DRevYr
            else RevYr:= 1900 + DRevYr;
            RevMo:= DRevMo;
            RevDa:= DRevDa;
            LastRec:= DLastRec;
            DataOffset:= DHdrLen - DRecLen;
        end;
        LA:= XDbfHdr.LookAhead;

        while (N >= SizeOf(FldHdr)) and (LA > $0D) do begin
            BlockRead(DataFile, XFldHdr.PFill, SizeOf(FldHdr), N);
            XFldHdr.Overlap:= LA;
            with FldHdr do if HType = 'N'
            then AppendField(
                    StrPas(PChar(@HName)), HType, NWidth, NDecPos )
            else AppendField(
                    StrPas(PChar(@HName)), HType, CWidth, 0 );
            LA:= XFldHdr.LookAhead;
        end;
        if RecLen <> DbfHdr.DRecLen then FileError:= 255;
        SeekRec(1);

    end else begin
        {Close(DataFile);}
    end;
end; {TDbfFile.OpenOld}

{*******************************************************}

destructor TDbfFile.Done;
begin
    Commit;
    inherited Done;
end; {TDbfFile.Done}

{*******************************************************}

{ write dbf file header; opens file if needed: }
procedure TDbfFile.WriteHeader;
var
    DbfHdr: TDbfHdr;
    FldHdr: TFldHdr;
    FTime: longint;
    DOW: word;
    I, N: longint;
    T: byte;
    Yr, Mo, Da, DW: longint;

begin
    if not FileOpen then begin
        Assign(DataFile, FileName);
        Reset(DataFile, 1);
        FileOpen:= true;
    end;

    Seek(DataFile, 0);
    with DbfHdr do begin
        DDbfId:= DbfId;
        GetDate(Yr, Mo, Da, DW);
        RevYr:= Yr;  RevMo:= Mo;  RevDa:= Da;  DOW:= DW;
        DRevYr:= RevYr mod 100;
        DRevMo:= RevMo;
        DRevDa:= RevDa;
        DLastRec:= LastRec;
        DRecLen:= RecLen;
        DHdrLen:= DataOffset + DRecLen;
        FillChar(DFill, SizeOf(DFill), 0);
    end;
    BlockWrite(DataFile, DbfHdr, SizeOf(DbfHdr), N);

    with FldHdr
    do for I:= 1 to NumFields do begin
        FillChar(FldHdr, SizeOf(FldHdr), 0);
        with FieldList^[I] do begin
            Move(Name[1], HName[1], Length(Name));
            HType:= FType;
            CWidth:= FWidth;  {also includes:}
            {NWidth:= Width;  NDecPos:= DecPos;}
        end;
        BlockWrite(DataFile, FldHdr, SizeOf(FldHdr), N);
    end;

    T:= $0D;
    BlockWrite(DataFile, T, 1, N);
    CurRec:= 0;
    HdrNeedsUpdate:= false;
    NewDate:= true;
end; {TDbfFile.WriteHeader}

{*******************************************************}

{ seek to given record number (opens file if needed): }
{ seek to 1 (or less) moves to beginning of file }
{ seek to LastRec+1 (or more) moves to end of file }
procedure TDbfFile.SeekRec(RecNum: longint);
var
    N: longint;
begin
    if not FileOpen then begin
        Assign(DataFile, FileName);
        Reset(DataFile, 1);
        FileOpen:= true;
    end;

    if RecNum > LastRec then RecNum:= LastRec+1
    else if RecNum <= 0 then RecNum:= 1;
    Seek(DataFile, longint(RecLen)*RecNum + DataOffset);
    CurRec:= RecNum;
end; {TDbfFile.SeekRec}

{*******************************************************}

{ read record at current position, return success: }
{ makes record data available in record buffer, advances position }
{ assumes SeekRec has been called }
function TDbfFile.ReadRec: boolean;
var
    N: longint;
begin
    if FileOpen then begin
        ReadRec:= true;
        if CurRec = 0 then SeekRec(1);
    end else begin
        ReadRec:= false;
exit;
    end;

    BlockRead(DataFile, RecImage^, RecLen, N);
    if N = RecLen then inc(CurRec) else ReadRec:= false;
    Deleted:= (RecImage^[1] = '*');
    RecModified:= false;
end; {TDbfFile.ReadRec}

{*******************************************************}

{ write record at current position, return success: }
{ assumes record data is ready in record buffer, advances position }
{ assumes SeekRec has been called }
function TDbfFile.WriteRec: boolean;
var
    N: longint;
begin
    if FileOpen then begin
        WriteRec:= true;
        if CurRec = 0 then SeekRec(1);
    end else begin
        WriteRec:= false;
exit;
    end;

    if Deleted then begin
        RecImage^[1]:= '*';
    end else begin
        RecImage^[1]:= ' ';
    end;

    BlockWrite(DataFile, RecImage^, RecLen, N);
    if not NewDate then HdrNeedsUpdate:= true;

    if N = RecLen then begin
        inc(CurRec);
        if CurRec > LastRec+1 then begin
            LastRec:= CurRec-1;
            HdrNeedsUpdate:= true;
        end;
    end else WriteRec:= false;
    RecModified:= false;
end; {TDbfFile.WriteRec}

{*******************************************************}

{ rewrite current record if RecModified: }
function TDbfFile.UpdateRec: boolean;
begin
    if RecModified then begin
        SeekRec(CurRec-1);
        UpdateRec:= WriteRec;  {RecModified:= false;}
    end else begin
        UpdateRec:= false;
    end;
end; {TDbfFile.UpdateRec}

{*******************************************************}

{ update disk image of data file: }
procedure TDbfFile.Commit;
begin
    if HdrNeedsUpdate then WriteHeader;
    if FileOpen then Close(DataFile);
    FileOpen:= false;
end; {TDbfFile.Commit}

{*******************************************************}

end.
