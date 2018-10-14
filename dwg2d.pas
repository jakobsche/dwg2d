{ This file was automatically created by Lazarus. Do not edit!
  This source is only used to compile and install the package.
 }

unit dwg2d;

interface

uses
  Drawng2D, LazarusPackageIntf;

implementation

procedure Register;
begin
  RegisterUnit('Drawng2D', @Drawng2D.Register);
end;

initialization
  RegisterPackage('dwg2d', @Register);
end.
