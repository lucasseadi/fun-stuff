Program cursor;

uses crt, graph, PPFuncoes;

var Gdriver,Gmode:smallint;
    MaxX,MaxY,MaxColor:integer;
    PixelColor,blueword,greenword,redword,fileword:word;
    Arquivo,Arquivo2:tipoarquivo;
    filebyte,filebytebuffer,red,green,blue:byte;
    imagesize,filesize,offset,counter1,counter2,nullbytes:longint;
    Largura,Altura,Varlargura,Varaltura:longint;
    paleta:PaletteType;
    bufferCursorVerticalCima,bufferCursorVerticalBaixo:bufferVertical;
    bufferCursorHorizontalDireita,bufferCursorHorizontalEsquerda:bufferHorizontal;
    bufferCursorCentral:bufferCentral;

    x,y,i,j,a,b:integer;
    pixel,pixelDesenho:word;
    tecla:char;
    press,loop:boolean;


begin
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




errorcode:=Abre('c:\Documents and Settings\lucas\Desktop\Pascal\tcp\pele.bmp',Arquivo,Largura,Altura,MaxX,MaxY);
case errorcode of
     0 : writeln('Arquivo exibido.');
     1 : writeln('Header nao suportado. Use um bitmap Windows V3.');
     2 : writeln('Use um bitmap de 8 bits.');
     3 : writeln('Offset do arquivo esta corrmpido.');
     4 : writeln('Esse arquivo nao e um bitmap.');
     5 : writeln('Arquivo nao encontrado.');
     6 : writeln('A figura é grande demais.');
     else writeln('Falha na abertura do arquivo.')
     end; {case}








//x:=MaxX div 2;
//y:=MaxY div 2;
x:=9;
y:=9;
pixelDesenho:=14;

acendeCursor(x,y,bufferCursorHorizontalEsquerda,bufferCursorHorizontalDireita,
             bufferCursorVerticalCima,bufferCursorVerticalBaixo,bufferCursorCentral,pixelDesenho);









//teste de buffers
{x:=50;
y:=50;


b:=1;
for i:=(x-8) to (x-2)do
    begin
    a:=1;
    for j:=(y-1) to (y+1)do
        begin
        pixel:=bufferCursorHorizontalEsquerda[b,a];
        PutPixel(i,j,pixel);
        a:=a+1;
        end;
    b:=b+1;
    end;

//horizontal direita
b:=1;
for i:=(x+2) to (x+8)do
    begin
    a:=1;
    for j:=(y-1) to (y+1)do
        begin
        pixel:=bufferCursorHorizontalDireita[b,a];
        PutPixel(i,j,pixel);
        a:=a+1;
        end;
    b:=b+1;
    end;

//vertical cima
a:=1;
for i:=(x-1) to (x+1)do
    begin
    b:=1;
    for j:=(y-8) to (y-2)do
        begin
        pixel:=bufferCursorVerticalCima[a,b];
        PutPixel(i,j,pixel);
        b:=b+1;
        end;
    a:=a+1;
    end;

//vertical baixo
a:=1;
for i:=(x-1) to (x+1)do
    begin
    b:=1;
    for j:=(y+2) to (y+8)do
        begin
        pixel:=bufferCursorVerticalBaixo[a,b];
        PutPixel(i,j,pixel);
        b:=b+1;
        end;
    a:=a+1;
    end;

//central
a:=1;
for i:=(x-1) to (x+1)do
    begin
    b:=1;
    for j:=(y-1) to (y+1)do
        begin
        pixel:=bufferCursorCentral[a,b];
        PutPixel(i,j,pixel);
        b:=b+1;
        end;
    a:=a+1;
    end;}















press:=false;

loop:=false;
while(loop=false)do

//while(press=false)do
     begin
     press:=keypressed;
     if press
        then begin
             tecla:=readkey;
             if((tecla<>'w')and(tecla<>'a')and(tecla<>'s')and(tecla<>'d')and(tecla<>'W')and(tecla<>'A')and(tecla<>'S')and(tecla<>'D')and(tecla<>#72)and(tecla<>#75)and(tecla<>#77)and(tecla<>#80)and(tecla<>#0))
               then begin
                    writeln('Este nao e um botao de movimento valido. Tente novamente.');
                    press:=false;
                    end;
             case tecla of
                  'w','W': if(y>=10)
                             then begin
                                  apagaCursor(x,y,bufferCursorHorizontalEsquerda,bufferCursorHorizontalDireita,
                                              bufferCursorVerticalCima,bufferCursorVerticalBaixo,bufferCursorCentral);
                                  y:=y-1;
                                  acendeCursor(x,y,bufferCursorHorizontalEsquerda,bufferCursorHorizontalDireita,
                                               bufferCursorVerticalCima,bufferCursorVerticalBaixo,bufferCursorCentral,
                                               pixelDesenho);
                                  end;
                  's','S': if(y<=(MaxY-11))
                             then begin
                                  apagaCursor(x,y,bufferCursorHorizontalEsquerda,bufferCursorHorizontalDireita,
                                              bufferCursorVerticalCima,bufferCursorVerticalBaixo,bufferCursorCentral);
                                  y:=y+1;
                                  acendeCursor(x,y,bufferCursorHorizontalEsquerda,bufferCursorHorizontalDireita,
                                               bufferCursorVerticalCima,bufferCursorVerticalBaixo,bufferCursorCentral,
                                               pixelDesenho);
                                  end;
                  'a','A': if(x>=10)
                             then begin
                                  apagaCursor(x,y,bufferCursorHorizontalEsquerda,bufferCursorHorizontalDireita,
                                              bufferCursorVerticalCima,bufferCursorVerticalBaixo,bufferCursorCentral);
                                  x:=x-1;
                                  acendeCursor(x,y,bufferCursorHorizontalEsquerda,bufferCursorHorizontalDireita,
                                               bufferCursorVerticalCima,bufferCursorVerticalBaixo,bufferCursorCentral,
                                               pixelDesenho);
                                  end;
                  'd','D': if(x<=(MaxX-11))
                             then begin
                                  apagaCursor(x,y,bufferCursorHorizontalEsquerda,bufferCursorHorizontalDireita,
                                              bufferCursorVerticalCima,bufferCursorVerticalBaixo,bufferCursorCentral);
                                  x:=x+1;
                                  acendeCursor(x,y,bufferCursorHorizontalEsquerda,bufferCursorHorizontalDireita,
                                               bufferCursorVerticalCima,bufferCursorVerticalBaixo,bufferCursorCentral,
                                               pixelDesenho);
                                  end;
                  #0: begin
                      tecla:=readkey;
                      case tecla of
                           #72: if(y>=10)
                                  then begin
                                       apagaCursor(x,y,bufferCursorHorizontalEsquerda,bufferCursorHorizontalDireita,
                                                   bufferCursorVerticalCima,bufferCursorVerticalBaixo,
                                                   bufferCursorCentral);
                                       y:=y-20;
                                       acendeCursor(x,y,bufferCursorHorizontalEsquerda,bufferCursorHorizontalDireita,
                                                    bufferCursorVerticalCima,bufferCursorVerticalBaixo,bufferCursorCentral,
                                                    pixelDesenho);
                                       end;
                           #80: if(y<=(MaxY-11))
                                  then begin
                                       apagaCursor(x,y,bufferCursorHorizontalEsquerda,bufferCursorHorizontalDireita,
                                                   bufferCursorVerticalCima,bufferCursorVerticalBaixo,
                                                   bufferCursorCentral);
                                       y:=y+20;
                                       acendeCursor(x,y,bufferCursorHorizontalEsquerda,bufferCursorHorizontalDireita,
                                                    bufferCursorVerticalCima,bufferCursorVerticalBaixo,bufferCursorCentral,
                                                    pixelDesenho);
                                       end;
                           #75: if(x>=10)
                                  then begin
                                       apagaCursor(x,y,bufferCursorHorizontalEsquerda,bufferCursorHorizontalDireita,
                                                   bufferCursorVerticalCima,bufferCursorVerticalBaixo,
                                                   bufferCursorCentral);
                                       x:=x-20;
                                       acendeCursor(x,y,bufferCursorHorizontalEsquerda,bufferCursorHorizontalDireita,
                                                    bufferCursorVerticalCima,bufferCursorVerticalBaixo,bufferCursorCentral,
                                                    pixelDesenho);
                                       end;
                           #77: if(x<=(MaxX-11))
                                  then begin
                                       apagaCursor(x,y,bufferCursorHorizontalEsquerda,bufferCursorHorizontalDireita,
                                                   bufferCursorVerticalCima,bufferCursorVerticalBaixo,
                                                   bufferCursorCentral);
                                       x:=x+20;
                                       acendeCursor(x,y,bufferCursorHorizontalEsquerda,bufferCursorHorizontalDireita,
                                                    bufferCursorVerticalCima,bufferCursorVerticalBaixo,bufferCursorCentral,
                                                    pixelDesenho);
                                       end;
                           end;
                  end;
             end;
     end;
end;
writeln('acaboooououooooo');
readln;

end.



