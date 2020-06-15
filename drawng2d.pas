unit Drawng2D;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, DBObjPas, Graphics, Controls;

type

  TDrawing2D = class;

  TElementClass = class of TElement;

  { TElement }

  TElement = class(TDataTable)
  private
    FDragging: Boolean;
    function Contains(X, Y: Integer): Boolean; virtual;
    function GetDrawing: TDrawing2D; virtual;
    function GetPixelsCenter: TPoint; virtual; abstract;
    function GetWidth: Integer;
    procedure SetDragging(AValue: Boolean);
    procedure SetPixelsCenter(AValue: TPoint); virtual; abstract;
    procedure SetWidth(AValue: Integer);
    function GetHeight: Integer;
    procedure SetHeight(AValue: Integer);
    procedure ReadPixelsCenter(Reader: TReader);
    procedure WritePixelsCenter(Writer: TWriter);
    procedure Shift(S: TPoint); virtual;
  protected
    procedure DefineProperties(Filer: TFiler); override;
    function GetLeft: Integer; virtual; abstract;
    function GetTop: Integer; virtual; abstract;
    function GetRight: Integer; virtual; abstract;
    function GetBottom: Integer; virtual; abstract;
    procedure SetLeft(AValue: Integer); virtual; abstract;
    procedure SetTop(AValue: Integer); virtual; abstract;
    procedure SetRight(AValue: Integer); virtual; abstract;
    procedure SetBottom(AValue: Integer); virtual; abstract;
    property Left: Integer read GetLeft write SetLeft;
    property Top: Integer read GetTop write SetTop;
    property Right: Integer read GetRight write SetRight;
    property Bottom: Integer read GetBottom write SetBottom;
    property Width: Integer read GetWidth write SetWidth;
    property Height: Integer read GetHeight write SetHeight;
  public
    procedure Draw; virtual; abstract;
    property PixelsCenter: TPoint read GetPixelsCenter write SetPixelsCenter;
    property Dragging: Boolean read FDragging write SetDragging;
    property Drawing: TDrawing2D read GetDrawing;
  end;

  { TElementGroup }

  TElementGroup = class(TElement)
  private
    function GetDrawing: TDrawing2D; override;
    function GetElements(I: Integer): TElement;
    function Contains(X, Y: Integer): Boolean; overload;
    procedure Shift(S: TPoint); override;
  public
    function GetElementAt(X, Y: Integer): TElement;
    function NewElement(AClass: TElementClass): TElement; overload;
    procedure Draw; override;
    property Elements[I: Integer]: TElement read GetElements;
  end;

  { TConstrPoint }

  TConstrPoint = class(TElement)
  private
    FColor: TColor;
    FPixelsWidth: Integer;
    FPixelsCenter: TPoint;
    function GetPixelsCenter: TPoint; override;
    procedure SetPixelsCenter(AValue: TPoint); override;
    procedure SetColor(AValue: TColor);
  public
    constructor Create(AnOwner: TComponent); override;
    function Contains(X, Y: Integer): Boolean; override;
  published
    property Color: TColor read FColor write SetColor;
    property PixelsWidth: Integer read FPixelsWidth write FPixelsWidth;
  end;

  { TConstrSquare }

  TConstrSquare = class(TConstrPoint)
  public
    constructor Create(AnOwner: TComponent); override;
    procedure Draw; override;
  end;

  { TConstrCircle }

  TConstrCircle = class(TConstrPoint)
  public
    procedure Draw; override;
  end;

  { TConstrRect }

  TConstrRect = class(TElement)
  private
    FRect: TRect;
    function GetPixelsCenter: TPoint; override;
    procedure SetPixelsCenter(AValue: TPoint); override;
    function GetA: TPoint;
    function GetB: TPoint;
    function GetC: TPoint;
    function GetD: TPoint;
    procedure SetA(AValue: TPoint);
    procedure SetB(AValue: TPoint);
    procedure SetC(AValue: TPoint);
    procedure SetD(AValue: TPoint);
  public
    constructor Create(AnOwner: TComponent); override;
    procedure Draw; override;
  public
    property A: TPoint read GetA write SetA;
    property B: TPoint read GetB write SetB;
    property C: TPoint read GetC write SetC;
    property D: TPoint read GetD write SetD;
    property Rect: TRect read FRect write FRect;
  end;

  { TConstrLine }

  TConstrLine = class(TElement)
  private
    FA: TPoint;
    FB: TPoint;
  public
    procedure Draw; override;
    property A: TPoint read FA write FA;
    property B: TPoint read FB write FB;
  end;

  { TConstrFrame }

  TConstrFrame = class(TElementGroup)
  private
    function GetA: TConstrSquare;
    function GetB: TConstrSquare;
    function GetC: TConstrSquare;
    function GetD: TConstrSquare;
    function GetE: TConstrSquare;
    function GetF: TConstrSquare;
    function GetFrameCrank: TConstrLine;
    function GetFrameRect: TConstrRect;
    function GetG: TConstrSquare;
    function GetH: TConstrSquare;
    function GetM: TConstrCircle;
    function GetN: TConstrCircle;
    function GetPixelsCenter: TPoint; override;
    procedure SetPixelsCenter(AValue: TPoint); override;
  public
    constructor Create(AComponent: TComponent); override;
    property A: TConstrSquare read GetA;                                     {2}
    property B: TConstrSquare read GetB;                                     {3}
    property C: TConstrSquare read GetC;                                     {4}
    property D: TConstrSquare read GetD;                                     {5}
    property E: TConstrSquare read GetE;                                     {6}
    property F: TConstrSquare read GetF;                                     {7}
    property G: TConstrSquare read GetG;                                     {8}
    property H: TConstrSquare read GetH;                                     {9}
    property M: TConstrCircle read GetM;                                    {10}
    property N: TConstrCircle read GetN;                                    {11}
    property FrameRect: TConstrRect read GetFrameRect;                       {0}
    property FrameCrank: TConstrLine read GetFrameCrank;                     {1}
  end;

type
  
  { TDrawing2D }

  TDrawing2D = class(TElementGroup)
  private
    FCanvas: TCanvas;
    FControl: TGraphicControl;
    FPixelsPerMeter: Integer;
    FRealHeight, FRealWidth: Extended;
    procedure SetControl(AValue: TGraphicControl);
  protected
    function GetLeft: Integer; override;
    function GetRight: Integer; override;
    function GetTop: Integer; override;
    function GetBottom: Integer; override;
  public
    constructor Create(AnOwner: TComponent); override;
    procedure Draw; override;
    procedure LoadFromFile(FileName: string);
    procedure SaveToFile(FileName: string);
  published
    property Canvas: TCanvas read FCanvas write FCanvas;
    property Control: TGraphicControl read FControl write SetControl;
    property PixelsPerMeter: Integer read FPixelsPerMeter write FPixelsPerMeter;
    property RealWidth: Extended read FRealWidth write FRealWidth;
    property RealHeight: Extended read FRealHeight write FRealHeight;
  end;

procedure Register;

implementation

uses Streaming2;

operator +(a, b: TPoint): TPoint; overload;
begin
  Result.x := a.x + b.x;
  Result.y := a.y + b.y
end;

operator =(a, b: TPoint): Boolean; overload;
begin
  Result := (a.x = b.x) and (a.y = b.y)
end;

function GetDrawing(Group: TComponent): TDrawing2D;
begin
  TComponent(Result) := Group;
  while Result <> nil do
    if Result is TDrawing2D then Break
    else TComponent(Result) := Result.Owner
end;

procedure Register;
begin
  RegisterComponents('Misc',[TDrawing2D]);
end;

{ TConstrLine }

procedure TConstrLine.Draw;
begin
  Drawing.Canvas.Line(A, B);
end;

{ TConstrFrame }

function TConstrFrame.GetA: TConstrSquare;
begin
  TElement(Result) := Elements[2]
end;

function TConstrFrame.GetB: TConstrSquare;
begin
  TElement(Result) := Elements[3]
end;

function TConstrFrame.GetC: TConstrSquare;
begin
  TElement(Result) := Elements[4]
end;

function TConstrFrame.GetD: TConstrSquare;
begin
  TElement(Result) := Elements[5]
end;

function TConstrFrame.GetE: TConstrSquare;
begin
  TElement(Result) := Elements[6]
end;

function TConstrFrame.GetF: TConstrSquare;
begin
  TElement(Result) := Elements[7]
end;

function TConstrFrame.GetFrameCrank: TConstrLine;
begin
  TElement(Result) := Elements[1]
end;

function TConstrFrame.GetFrameRect: TConstrRect;
begin
  TElement(Result) := Elements[0]
end;

function TConstrFrame.GetG: TConstrSquare;
begin
  TElement(Result) := Elements[8]
end;

function TConstrFrame.GetH: TConstrSquare;
begin
  TElement(Result) := Elements[9]
end;

function TConstrFrame.GetM: TConstrCircle;
begin
  TElement(Result) := Elements[10]
end;

function TConstrFrame.GetN: TConstrCircle;
begin
  TElement(Result) := Elements[11]
end;

function TConstrFrame.GetPixelsCenter: TPoint;
begin
  Result := FrameRect.PixelsCenter;
end;

procedure TConstrFrame.SetPixelsCenter(AValue: TPoint);
var
  PC: TPoint;
begin
  if PixelsCenter = AValue then Exit;
  FrameRect.PixelsCenter := AValue;
  A.PixelsCenter := FrameRect.A;
  B.PixelsCenter := FrameRect.B;
  C.PixelsCenter := FrameRect.C;
  D.PixelsCenter := FrameRect.D;
  E.PixelsCenter := Point(FrameRect.PixelsCenter.X, FrameRect.A.Y); {6}
  F.PixelsCenter := Point(FrameRect.B.X, FrameRect.PixelsCenter.Y); {7}
  G.PixelsCenter := Point(FrameRect.PixelsCenter.X, FrameRect.D.Y); {8}
  H.PixelsCenter := Point(FrameRect.A.x, FrameRect.PixelsCenter.Y); {9}
  FrameCrank.A := FrameRect.PixelsCenter;
  FrameCrank.B := Point(FrameCrank.A.X + FrameRect.B.X - FrameRect.A.X, FrameCrank.A.Y);
  M.PixelsCenter := FrameRect.PixelsCenter;
  N.PixelsCenter := FrameCrank.B
end;

constructor TConstrFrame.Create(AComponent: TComponent);
var
  CR: TConstrRect;
  CS: TConstrSquare;
  CL: TConstrLine;
  CC: TConstrCircle;
begin
  inherited Create(AComponent);
  TElement(CR) := NewElement(TConstrRect); {0}
  CR.Rect := Rect(0, 0, 200, 100);
  TElement(CL) := NewElement(TConstrLine); {1}
  with CL do begin
    A := CR.PixelsCenter;
    B := Point(A.X + CR.Rect.Right - CR.Rect.Left, A.Y)
  end;
  (NewElement(TConstrSquare) as TConstrSquare).PixelsCenter := CR.A; {2}
  (NewElement(TConstrSquare) as TConstrSquare).PixelsCenter := CR.B; {3}
  (NewElement(TConstrSquare) as TConstrSquare).PixelsCenter := CR.C; {4}
  (NewElement(TConstrSquare) as TConstrSquare).PixelsCenter := CR.D; {5}
  (NewElement(TConstrSquare) as TConstrSquare).PixelsCenter := Point(CR.PixelsCenter.X, CR.A.Y); {6}
  (NewElement(TConstrSquare) as TConstrSquare).PixelsCenter := Point(CR.B.X, CR.PixelsCenter.Y); {7}
  (NewElement(TConstrSquare) as TConstrSquare).PixelsCenter := Point(CR.PixelsCenter.X, CR.D.Y); {8}
  (NewElement(TConstrSquare) as TConstrSquare).PixelsCenter := Point(CR.A.x, CR.PixelsCenter.Y); {9}
  with NewElement(TConstrCircle) as TConstrCircle do begin
    PixelsCenter := CL.A; {10}
    Color := clYellow;
  end;
  with NewElement(TConstrCircle) as TConstrCircle do begin
    PixelsCenter := CL.B; {11}
    Color := clLime
  end;
end;

{ TConstrRect }

function TConstrRect.GetPixelsCenter: TPoint;
begin
  Result := Point((Rect.Left + Rect.Right) div 2, (Rect.Top + Rect.Bottom) div 2)
end;

procedure TConstrRect.SetPixelsCenter(AValue: TPoint);
var
  RX, RY: Integer;
begin
  RX := (Rect.Right - Rect.Left) div 2;
  RY := (Rect.Bottom - Rect.Top) div 2;
  Rect := Classes.Rect(AValue.X - RX, AValue.Y - RY, AValue.X + RX, AValue.y + RY);
end;

function TConstrRect.GetA: TPoint;
begin
  Result := Point(Rect.Left, Rect.Bottom)
end;

function TConstrRect.GetB: TPoint;
begin
  Result := Rect.BottomRight;
end;

function TConstrRect.GetC: TPoint;
begin
  Result := Point(Rect.Right, Rect.Top)
end;

function TConstrRect.GetD: TPoint;
begin
  Result := Rect.TopLeft;
end;

procedure TConstrRect.SetA(AValue: TPoint);
begin
  FRect.Left := AValue.X;
  FRect.Bottom := AValue.Y
end;

procedure TConstrRect.SetB(AValue: TPoint);
begin
  FRect.BottomRight := AValue;
end;

procedure TConstrRect.SetC(AValue: TPoint);
begin
  FRect.Right := AValue.X;
  FRect.Top := AValue.Y
end;

procedure TConstrRect.SetD(AValue: TPoint);
begin
  FRect.TopLeft := AValue;
end;

constructor TConstrRect.Create(AnOwner: TComponent);
begin
  inherited Create(AnOwner);
  Rect := Classes.Rect(0, 0, 200, 100);
end;

procedure TConstrRect.Draw;
begin
  if Drawing <> nil then
    if Drawing.Canvas <> nil then
      with Drawing.Canvas do begin
        MoveTo(A);
        LineTo(B);
        LineTo(C);
        LineTo(D);
        LineTo(A)
      end;
end;

{ TConstrPoint }

function TConstrPoint.GetPixelsCenter: TPoint;
begin
  Result := FPixelsCenter
end;

procedure TConstrPoint.SetPixelsCenter(AValue: TPoint);
begin
  FPixelsCenter := AValue
end;

procedure TConstrPoint.SetColor(AValue: TColor);
begin
  if FColor=AValue then Exit;
  FColor:=AValue;
  Draw
end;

constructor TConstrPoint.Create(AnOwner: TComponent);
begin
  inherited Create(AnOwner);
  PixelsWidth := 10
end;

function TConstrPoint.Contains(X, Y: Integer): Boolean;
var
  r: Integer;
begin
  r := PixelsWidth div 2;

  Result := (X > PixelsCenter.X - r) and (X < PixelsCenter.X + r) and
    (Y > PixelsCenter.Y - r) and (Y < PixelsCenter.Y + r)
end;

{ TConstrCircle }

procedure TConstrCircle.Draw;
var
  r: Integer;
begin
  if Drawing <> nil then if Drawing.Canvas <> nil then begin
    Drawing.Canvas.Brush.Color := Color;
    r := PixelsWidth div 2;
    Drawing.Canvas.Ellipse(PixelsCenter.X - r, PixelsCenter.y - r, PixelsCenter.x + r, PixelsCenter.y + r);
  end;
end;

{ TElement }

function TElement.GetWidth: Integer;
begin
  Result := Right - Left
end;

procedure TElement.SetDragging(AValue: Boolean);
begin
  if FDragging = AValue then Exit;
  FDragging := AValue;
end;

function TElement.Contains(X, Y: Integer): Boolean;
begin
  Result := False
end;

function TElement.GetDrawing: TDrawing2D;
begin
  Result := Drawng2D.GetDrawing(Owner);
end;

procedure TElement.SetWidth(AValue: Integer);
begin
  Right := Left + AValue
end;

function TElement.GetHeight: Integer;
begin
  Result := Bottom - Top
end;

procedure TElement.SetHeight(AValue: Integer);
begin
  Bottom := Top + AValue
end;

procedure TElement.ReadPixelsCenter(Reader: TReader);
var
  Buffer: TPoint;
begin
  Reader.Read(Buffer, SizeOf(Buffer));
  SetPixelsCenter(Buffer);
end;

procedure TElement.WritePixelsCenter(Writer: TWriter);
var
  Buffer: TPoint;
begin
  Buffer := GetPixelsCenter;
  Writer.Write(Buffer, SizeOf(Buffer));
end;

procedure TElement.Shift(S: TPoint);
begin
  PixelsCenter := PixelsCenter + S
end;

procedure TElement.DefineProperties(Filer: TFiler);
begin
  inherited DefineProperties(Filer);
  Filer.DefineProperty('PixelsCenter', @ReadPixelsCenter, @WritePixelsCenter, True);
end;

{ TConstrSquare }

constructor TConstrSquare.Create(AnOwner: TComponent);
begin
  inherited Create(AnOwner);
  Color := clAqua
end;

procedure TConstrSquare.Draw;
var
  R: Integer;
begin
  if Drawing <> nil then
    if Drawing.Canvas <> nil then begin
      Drawing.Canvas.Brush.Color := clBlue;
      Drawing.Canvas.Pen.Color := clBlack;
      r := PixelsWidth div 2;
      Drawing.Canvas.FillRect(PixelsCenter.X - r, PixelsCenter.Y - r, PixelsCenter.x + r, PixelsCenter.y + r)
    end;
end;

{ TDrawing2D }

procedure TDrawing2D.SetControl(AValue: TGraphicControl);
begin
  if FControl = AValue then Exit;
  if FControl <> nil then RemoveFreeNotification(FControl);
  FControl := AValue;
  FreeNotification(FControl);
  Canvas := FControl.Canvas
end;

function TDrawing2D.GetLeft: Integer;
begin
  if Control <> nil then Result := Control.ClientRect.Left
  else Result := 0;
end;

function TDrawing2D.GetRight: Integer;
begin
  if Control <> nil then Result := Control.ClientRect.Right
  else Result := 0;
end;

function TDrawing2D.GetTop: Integer;
begin
  if Control <> nil then Result := Control.ClientRect.Top
  else Result := 0
end;

function TDrawing2D.GetBottom: Integer;
begin
  if Control <> nil then Result := Control.ClientRect.Bottom
  else Result := 0;
end;

constructor TDrawing2D.Create(AnOwner: TComponent);
begin
  inherited Create(AnOwner);
  PixelsPerMeter := 1000
end;

procedure TDrawing2D.Draw;
begin
  if Canvas <> nil then begin
    Canvas.Brush.Color := clWhite;
    Canvas.FillRect(Left, Top, Right, Bottom);
    inherited Draw
  end;
end;

procedure TDrawing2D.LoadFromFile(FileName: string);
begin
  ReadBinaryFromFile(FileName, TComponent(Self))
end;

procedure TDrawing2D.SaveToFile(FileName: string);
begin
  WriteBinaryToFile(FileName, Self)
end;

{ TElementGroup }

function TElementGroup.GetDrawing: TDrawing2D;
begin
  Result := Drawng2D.GetDrawing(Self)
end;

function TElementGroup.GetElements(I: Integer): TElement;
begin
  TDataRecord(Result) := Items[I]
end;

function TElementGroup.Contains(X, Y: Integer): Boolean;
var
  I: Integer;
begin
  Result := False;
  for i := ItemCount - 1 downto 0 do
    if Elements[i].Contains(X, Y) then begin
      Result := True;
      Break
    end;
end;

procedure TElementGroup.Shift(S: TPoint);
var
  i: Integer;
  Element: TElement;
begin
  for i := 0 to ItemCount - 1 do begin
    Element := Elements[i];
    Element.Shift(S)
  end;
end;

function TElementGroup.GetElementAt(X, Y: Integer): TElement;
var
  i: Integer;
begin
  for i := ItemCount - 1 downto 0 do
    if Elements[i].Contains(X, Y) then begin
      Result := Elements[i];
      Exit
    end;
  Result := nil
end;

function TElementGroup.NewElement(AClass: TElementClass
  ): TElement;
begin
  TDataRecord(Result) := NewItem(AClass);
end;

procedure TElementGroup.Draw;
var
  i: Integer;
begin
  for i := 0 to ItemCount - 1 do Elements[i].Draw;
end;

initialization

RegisterForStreaming(TConstrSquare);
RegisterForStreaming(TConstrCircle);

end.
