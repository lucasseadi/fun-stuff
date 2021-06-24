Program cursor;

uses crt, graph;

var Gdriver,Gmode:smallint;
    MaxX,MaxY,MaxColor:integer;
    PixelColor,blueword,greenword,redword,fileword:word;
    Arquivo,Arquivo2:file of byte;
    filebyte,filebytebuffer,red,green,blue:byte;
    imagesize,filesize,offset,counter1,counter2,nullbytes:longint;
    Largura,Altura,Varlargura,Varaltura:longint;
    paleta:PaletteType;

    x,y,xnovo,ynovo,i,j:integer;
    pixel,pixelDesenho:word;
    tecla:char;
    press,loop:boolean;


begin
{$I-}
//tecla:=readkey;
{$I+}
//if IOresult=1
  // then writeln('nada pressionado');




DetectGraph(Gdriver,Gmode);
writeln('Gdriver: ',Gdriver);
writeln;
writeln('- 1 -  640x400x256');
writeln('- 2 -  640x480x256');
writeln('- 3 -  800x600x256');
write('Escolha o tamanho da tela de desenho (1,2,3): ');
readln(Gmode);

writeln('Testando modo ',Gmode,', e carregando grafico...');
InitGraph(Gdriver,Gmode,'');
MaxX:=GetMaxX;
MaxY:=GetMaxY;
MaxColor:=GetMaxColor;
GetDefaultPalette(paleta);

writeln('abriu a tela');

x:=9;
y:=9;

pixel:=GetPixel(x,y)+8;
pixelDesenho:=5;
{for i:=x to (x+10) do
    begin
    for j:=y to (y+10) do
        begin
        PutPixel(i,j,pixel);      //desenha o cursor
        end;
    end;}


for i:=(x-1) to (x+1)do
    begin
    for j:=(y-8) to (y+8)do
        begin
        PutPixel(i,j,pixel);
        end;
    end;
for i:=(x-8) to (x+8)do
    begin
    for j:=(y-1) to (y+1)do
        begin
        PutPixel(i,j,pixel);
        end;
    end;
for i:=(x-1) to (x+1)do
    begin
    for j:=(y-1) to (y+1)do
        begin
        PutPixel(i,j,pixelDesenho);
        end;
    end;

press:=false;

loop:=false;
while(loop=false)do

//while(press=false)do
     begin
     //delay(250);
     delay(100);
     pixel:=GetPixel(x-2,y)-8;   //pegando cor de um pixel da cruz
     for i:=(x-1) to (x+1)do    //
         begin                    //
         for j:=(y-8) to (y+8)do    //
             begin                    //
             PutPixel(i,j,pixel);   //
             end;                   //
         end;                       //        apaga
     for i:=(x-8) to (x+8)do        //
         begin                      //
         for j:=(y-1) to (y+1)do    //
             begin                    //
             PutPixel(i,j,pixel);       //
             end;                   //
         end;                       //
     for i:=(x-1) to (x+1)do        //
         begin                      //
         for j:=(y-1) to (y+1)do    //
             begin                  //
             PutPixel(i,j,pixel);   //
             end;                   //
         end;                       //







     press:=keypressed;
     if press
        then begin
             tecla:=readkey;
             xnovo:=x;
             ynovo:=y;
             if((tecla<>'w')and(tecla<>'a')and(tecla<>'s')and(tecla<>'d')and(tecla<>'W')and(tecla<>'A')and(tecla<>'S')and(tecla<>'D')and(tecla<>#72)and(tecla<>#75)and(tecla<>#77)and(tecla<>#80)and(tecla<>#0))
               then begin
                    writeln('Este nao e um botao de movimento valido. Tente novamente.');
                    press:=false;
                    end;
             case tecla of
                  'w','W': begin
                           if(ynovo>=10)
                             then ynovo:=ynovo-10;
                           end;
                  's','S': begin
                           if(ynovo<=(MaxY-11))
                             then ynovo:=ynovo+10;         //teclas de movimento "tab"
                           end;
                  'a','A': begin
                           if(xnovo>=10)
                             then xnovo:=xnovo-10;         //caracteres correspondentes às setas
                           end;
                  'd','D': begin
                           if(xnovo<=(MaxX-11))
                             then xnovo:=xnovo+10;
                           end;
                  #0: begin
                      tecla:=readkey;
                      case tecla of
                           #72: begin
                                    if(ynovo>=10)
                                      then ynovo:=ynovo-1;
                                    end;
                           #80: begin
                                    if(ynovo<=(MaxY-11))
                                      then ynovo:=ynovo+1;         //teclas de movimento de precisão de 1 pixel
                                    end;
                           #75: begin
                                    if(xnovo>=10)
                                      then xnovo:=xnovo-1;         //caracteres correspondentes às setas
                                    end;
                           #77: begin
                                    if(xnovo<=(MaxX-11))
                                      then xnovo:=xnovo+1;
                                    end;
                           end;
                  end;
                  end;
             pixel:=GetPixel(x,y)-8;
             x:=xnovo;
             y:=ynovo;
             end;
     delay(250);
     pixel:=GetPixel(x-2,y)+8;




     for i:=(x-1) to (x+1)do               //
         begin                             //
         for j:=(y-8) to (y+8)do           //
             begin                         //
             PutPixel(i,j,pixel);          //
             end;                          //
         end;                              //
     for i:=(x-8) to (x+8)do               //
         begin                             //
         for j:=(y-1) to (y+1)do           //
             begin                         //
             PutPixel(i,j,pixel);          //  acende
             end;                          //
         end;                              //
     for i:=(x-1) to (x+1)do               //
         begin                             //
         for j:=(y-1) to (y+1)do           //
             begin                         //
             PutPixel(i,j,pixelDesenho);   //
             end;                          //
         end;                              //





     end;
writeln('acaboooououooooo');
readln;

end.



