Program PascalPaint;

uses crt, graph, PPFuncoes;

var Gdriver,Gmode:smallint;
    MaxX,MaxY:integer;

begin
DetectGraph(Gdriver,Gmode);
writeln('Gdriver: ',Gdriver,'. Pressione Enter para iniciar.');
readln;

writeln('Testando modo ',Gmode,', e carregando grafico...');
InitGraph(Gdriver,Gmode,'');
writeln('Pronto.');
MaxX:=GetMaxX;
MaxY:=GetMaxY;

Teclas(MaxX,MaxY);

CloseGraph;
end.
