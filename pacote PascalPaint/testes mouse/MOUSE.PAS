{ ////////////////////////////////////////////////////////////////////////////
  //                                                                       //
  //   Mouse's Basic Functions                                             //
  //                                                                        //
  //     int  initmouse  ()                                                 //
  //     void showmouse  ()                                                 //
  //     void hidemouse  ()                                                 //
  //     int  mousex     ()                                                 //
  //     int  mousey     ()                                                 //
  //     int  mousebutton()                                                 //
  //     void mouseat    (int x,int y)                                      //
  //                                                                        //
  //     Adaptado para Turbo Pascal por Leandro Krug Wives                  //
  //     Em 15/Out/2002
  //////////////////////////////////////////////////////////////////////////// }

Unit Mouse;

Interface

Function inicializaMouse:Boolean;
Procedure mostraMouse;
Procedure escondeMouse;
Function posXMouse: Integer;
Function posYMouse: Integer;
Function botaoMouse: Integer;
Procedure posicionaMouse(x: Integer; y: Integer);
Procedure defineRegiaoMouse(xIni: Integer; yIni: Integer; xFin: Integer; yFin:Integer);

Implementation

Uses DOS;

{ Inicializa mouse
  Retorna true se conseguiu e false se nao conseguiu }

Function inicializaMouse:Boolean;
Var registradores: registers;
Begin
   registradores.ax := $00;
   intr($33, registradores);
   if   registradores.ax = $FFFF then inicializaMouse := true
   else                               inicializaMouse := false;
End;

{ Mostra o mouse na tela }

Procedure mostraMouse;
Var registradores: registers;
Begin
  registradores.ax := $01;
  intr($33, registradores);
End;

Procedure escondeMouse;
Var registradores: registers;
Begin
  registradores.ax := $02;
  intr($33, registradores);
End;

Function posXMouse: Integer;
Var registradores: registers;
Begin
  registradores.ax := $03;
  intr($33, registradores);
  posXMouse := registradores.cx;
End;

Function posYMouse: Integer;
Var registradores: registers;
Begin
  registradores.ax := $03;
  intr($33, registradores);
  posYMouse := registradores.dx;
End;

Function botaoMouse: Integer;
Var registradores: registers;
Begin
  registradores.ax := $03;
  intr($33, registradores);
  botaoMouse := registradores.bx;
End;

Procedure posicionaMouse(x: Integer; y: Integer);
Var registradores: registers;
Begin
  registradores.ax := $04;
  registradores.cx := x;
  registradores.dx := y;
  intr($33, registradores);
End;

Procedure defineRegiaoMouse(xIni: Integer; yIni: Integer; xFin: Integer; yFin:Integer);
Var registradores: registers;
Begin
  registradores.ax := $07;
  registradores.cx := xIni;
  registradores.dx := xFin;
  intr($33, registradores);

  registradores.ax := $08;
  registradores.cx := yIni;
  registradores.dx := yFin;
  intr($33, registradores);

End;

End.
