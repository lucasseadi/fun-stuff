{ *********************************************************************
   GEdit
   ====================================================================
   Editor gráfico que utiliza o mouse
   Mantenha pressionado o botão direito do mouse para fazer surgir o 
   menu de opçoes e poder selecioná-las. Quando a opção desejada 
   estiver selecionada, solte o botão direito.

   Autoria:
   Originalmente implementado em linguagem C por Leandro Krug Wives
   (Jul/1995)
   
   Adaptado para TurboPascal em Out/2002

  ********************************************************************* }

Program GEdit;

Uses Graph, MOUSE, DOS, CRT;

{ *********************************************************************
   Variaveis globais
  ********************************************************************* }

Var x1, y1, x2, y2,
    XORCOLOR, cor, c,
    active_function,
    old_function  ,
    posx, posy   : Integer;                 { posicoes x e y atuais do mouse }
    resultado    : Boolean;
    tecla:char;

    BackGrounD   : Pointer;                 { armazena imagem de fundo quando o menu aparece }

    menuoptions  : Array [1..13] of String; { Opcoes do menu }
    noptions     : Integer;                 { numero de opcoes do menu }
    filename     : String;                  { nome do arquivo }
    arquivo      : File of Word;            { Cria um arquivo para armazenar a imagem da tela }
    pixel        : Word;

{ *********************************************************************
   Funcoes e procedimentos gerais
  ********************************************************************* }

{ Inicializa o modo grafico }
{ retorna true se conseguir e false se nao conseguir }

Function modoGrafico: Boolean;
Var placa, modo, erro: Integer;
Begin
   placa := DETECT;
   initgraph(placa, modo, '');

   if graphresult <> grOk then modoGrafico := false
   else                          modoGrafico := true;
End;

{ Finaliza o modo grafico e volta para o modo texto }
Procedure modoTexto;
Begin
   closegraph;
End;

{ Monta a barra de menu (quando o botao direito e' pressionado) }
Procedure menubar;
Var old, c: Integer;
    escolheuAlgum: Boolean;
Begin
   old := 0;
   escolheuAlgum := false;

   posx := posXMouse; posy := posYMouse; { descobre a posicao atual do mouse }

   if posx > 540 then posx := posx-100; { se for muito para a direita, diminui um pouco para que o menu nao apareca cortado }
   if posy > 280 then posy := posy-200; { se for muito para baixo, diminui um pouco para nao cortar o menu }

   escondeMouse;

   getimage(posx, posy, posx + 100, posy + 200, BackGrounD^); { armazena o local onde o menu vai aparecer }
   setfillstyle(SOLIDFILL, WHITE);                            { Escolhe cor branca solida para o fundo }
   setcolor(BLACK);                                           { Escolhe cor preta para letras }
   bar(posx, posy, posx+100, posy+200);                       { Pinta uma barra: o menu }
   rectangle(posx+2, posy +2, posx+98, posy + 198);           { Desenha um retangulo: bordas do menu }
   setcolor(RED);                                             { Escolhe cor vermelha }
   outtextxy(posx+15, posy+10, '__GEdit__');                  { Escreve GEDIT }
   setcolor(BLACK);                                           { Escolhe cor preta}

   mostraMouse;
   old_function := active_function;

   x1 := posXMouse+1; y1 := posYmouse;

   for c := 1 to noptions do                                 { Escreve as opcoes do menu }
      outtextxy(posx+15, posy+(10*(c+3)), menuoptions[c]);

   repeat                                                    { Espera o usuario escolher uma opcao }
      if (x1 <> posXmouse) OR (y1 <> posYmouse) then
      begin
         for c := 1 to noptions do                           { Testa se o mouse esta em cima de uma posicao valida }
         begin
             if (posYmouse > (posy+(10*(c+3)))) AND (posYmouse < (posy+(10*(c+4)))) then
             begin { se estiver em cima de alguma }
                if (old > 0) AND (old <> c) then   { se nao for da atual }
                begin
                   escondemouse;
                   setfillstyle(SOLIDFILL, WHITE);
                   bar(posx+10, posy+(10*(old+3))-2, posx+90, posy+(10*(old+3))+10);
                   outtextxy(posx+15, posy+(10*(old+3)), menuoptions[old]);
                   mostramouse;
                end;
                if (menuoptions[c] <> '') AND (old <> c) then { se for a atual }
                begin
                   escondemouse;
                   setfillstyle(SOLIDFILL, CYAN);
                   bar(posx+10, posy+(10*(c+3))-2, posx+90, posy+(10*(c+3))+10);
                   outtextxy(posx+15, posy+(10*(c+3)), menuoptions[c]);
                   active_function := c + 1;
                   old := c;
                   mostramouse;
                end
                else
                   active_function := c;
             end;
         end;
         x1 := posXmouse; y1 := posYmouse;
         setfillstyle(SOLIDFILL, WHITE);
         mostramouse;
      end;
   until botaoMouse <> 2;

   if NOT((posYmouse > posy+40) AND (posYmouse < posy+170)) then active_function := old_function;

   escondemouse;

   putimage(posx, posy, BackGrounD^, COPYPUT); { Volta a imagem anterior, antes do menu aparecer }

   mostramouse;
End;

{ *********************************************************************
   Programa principal
  ********************************************************************* }
Begin

   { Inicializacao das opcoes do menu }
   menuOptions[1] := 'Linha';
   menuOptions[2] := 'Circulo';
   menuOptions[3] := 'Retangulo';
   menuOptions[4] := 'Lapis';
   menuOptions[5] := '';
   menuOptions[6] := 'Preencher';
   menuOptions[7] := 'Borracha';
   menuOptions[8] := 'Novo';
   menuOptions[9] := '';
   menuOptions[10] := 'Salvar';
   menuOptions[11] := 'Carregar';
   menuOptions[12] := '';
   menuOptions[13] := 'Sair';
   nOptions  := 13 ;  { numero de opcoes do menu }

   active_function := 1;   { opcao selecionada do menu }
   old_function := 1;      { antiga opcao selecionada do menu }

   resultado := modoGrafico;      { tenta ativar o modo grafico }

   if resultado <> true then      { Mostra erro e sai se nao conseguir }
   begin
     writeln;
     writeln('Nao foi possivel inicializar o modo grafico');
     write('pressione qualquer tecla para retornar ao Sistema...');
     tecla := readkey;
     exit;
   end;

   { Aloca memoria para o local onde o menu ira aparecer }
   GetMem(BackGrounD, imagesize(1,1,100,200));

   resultado := inicializaMouse;   { Tenta inicializar o mouse }

   if resultado <> true then       { Mostra erro e sai se nao conseguir }
   Begin
      writeln;
      writeln('Nao foi possivel inicializar o mouse');
      write('pressione qualquer tecla para retornar ao Sistema...');
      tecla := readkey;
      exit;
   End;

   mostraMouse;

   repeat

      if botaoMouse = 2 then menubar;
      if (botaomouse = 1) OR (active_function > 5) then
      Begin
	 case active_function of
	   1: Begin
		 x1 := posXmouse; x2 := x1;
		 y1 := posYmouse; y2 := y1;

		 setwritemode(XORPUT);
		 setlinestyle(DOTTEDLN, 1, 2);
		 setcolor(WHITE);

		 Repeat
		    if (x2 <> posXmouse) OR (y2 <> posYmouse) then
		    Begin
		       escondemouse;
		       line(x1, y1, x2, y2);
		       x2 := posXmouse; y2 := posYmouse;
		       line(x1, y1, x2, y2);
		       mostramouse;
		    End;
		 Until (botaomouse <> 1);

		 setwritemode(COPYPUT);
		 setlinestyle(SOLIDLN, 1, 1);
		 escondemouse;
		 setcolor(CYAN);
		 line(x1, y1, x2, y2);
		 setcolor(WHITE);
		 mostramouse;
	      End;
	   2: Begin
		 x1 := posXMouse; x2 := x1;
		 y1 := posYMouse; y2 := y1;
		 setwritemode(XORPUT);
		 setlinestyle(DOTTEDLN, 1, 2);
		 XORCOLOR := WHITE;
		 repeat
		    if (x2 <> posXmouse) OR (y2 <> posYmouse) then
		    begin
		       escondemouse;
		       setcolor(WHITE);
		       rectangle(x1-(x2-x1), y1-(y2-y1),x1+(x2-x1), y1+(y2-y1));
		       setcolor(XORCOLOR);
		       line(x1, y1, x2, y1);
		       line(x1, y1, x1, y2);
		       x2 := posXmouse; y2 := posYmouse;
		       setcolor(WHITE);
		       rectangle(x1-(x2-x1), y1-(y2-y1),x1+(x2-x1), y1+(y2-y1));

		       if (x2-x1) = (y2-y1) then XORCOLOR := RED
		       else                      XORCOLOR := WHITE;

		       setcolor(XORCOLOR);
		       line(x1, y1, x2, y1);
		       line(x1, y1, x1, y2);
		       mostramouse;
		    end;
		 until botaomouse <> 1;
		 escondemouse;
		 setcolor(XORCOLOR);
						    line(x1, y1, x2, y1);
		 line(x1, y1, x1, y2);
		 setcolor(WHITE);
		 rectangle(x1-(x2-x1), y1-(y2-y1),x1+(x2-x1), y1+(y2-y1));
		 setlinestyle(SOLIDLN, 1, 1);
		 setwritemode(COPYPUT);
		 setcolor(CYAN);
		 ellipse(x1, y1, 0, 360, abs(x2 - x1), abs(y2 - y1));
		 setcolor(WHITE);
		 mostramouse;
	      End;
	   3: Begin
		 x1 := posXMouse; x2 := x1;
		 y1 := posYmouse; y2 := y1;

		 setwritemode(XORPUT);
		 setlinestyle(DOTTEDLN, 1, 2);
		 XORCOLOR := WHITE;
		 repeat
		    if (x2 <> posXmouse) Or (y2 <> posYmouse) then
		    begin
		       escondemouse;
		       setcolor(WHITE);
		       rectangle(x1, y1,x2, y2);
		       x2 := posXmouse; y2 := posYmouse;
		       setcolor(WHITE);
		       rectangle(x1, y1,x2,y2);
		       mostramouse;
		    end;
		 until botaomouse <> 1;

		 escondemouse;
		 setcolor(WHITE);
		 rectangle(x1, y1,x2,y2);
		 setlinestyle(SOLIDLN, 1, 1);
		 setwritemode(COPYPUT);
		 setcolor(CYAN);
		 rectangle(x1, y1, x2, y2);
		 setcolor(WHITE);
		 mostramouse;
	      End;
	   4: Begin
		 escondemouse;
		 setcolor(CYAN);
		 repeat
		    x1 := posXmouse; y1 := posYmouse;
		    delay(10);
		    line(x1, y1, posXmouse, posYmouse);
		 until botaomouse <> 1;
		 setcolor(WHITE);
		 mostramouse;
	      End;
	   5: active_function := old_function;
	   6: Begin
		 posx := posXmouse; posy := posYmouse;
		 if posx > 540 then posx := posx-100;
		 if posy > 280 then posy := posy-200;
		 escondemouse;
		 getimage(posx, posy, posx + 100, posy + 200, BackGrounD^);
		 bar(posx, posy, posx+100, posy+180);
		 setcolor(BLACK);
		 rectangle(posx+1, posy+1, posx + 99, posy + 179);
		 active_function := old_function;

		 for cor := 1 to 13 do
		 begin
		    setfillstyle(SOLIDFILL, cor);
		    bar(posx+2, posy+15*(cor-1), posx+98, posy+(15*cor));
		 end;

		 mostramouse;

		 repeat
		    for c := 1 to 13 do
		       if (posYmouse > posy+15*(c-1)) AND (posYmouse < posy+15*(c)) then cor := c;
		 until botaomouse = 1;

		 escondemouse;
		 putimage(posx, posy, BackGrounD^, COPYPUT);
		 mostramouse;

		 repeat                { Espera mouse }
		 until botaomouse <> 1;

		 repeat
		 until botaomouse = 1;

		 escondemouse;
		 setfillstyle(SOLIDFILL, cor);
		 floodfill(posXmouse, posYmouse, CYAN);
		 mostramouse;

		 repeat
		 until botaomouse <> 1;
	      End;
	   7: Begin
		 escondeMouse;
		 setwritemode(XORPUT);
		 setcolor(WHITE);
		 setlinestyle(DOTTEDLN, 1, 2);
		 x1 := posXMouse; y1 := posYMouse;
		 rectangle(x1, y1, x1 + 20, y1 + 20);
		 setfillstyle(SOLIDFILL, BLACK);
		 repeat
		    x2 := posXMouse; y2 := posYMouse;
		    if (x1 <> x2) OR (y1 <> y2) then
		    begin
		       rectangle(x1, y1, x1 + 20, y1 + 20);
		       x1 := x2; y1 := y2;
		       rectangle(x1, y1, x1+20 ,y1+20);
		    end;
		    if botaoMouse = 1 then bar(x1+1, y1+1, x1 + 19, y1 + 19);
		 until botaomouse = 2;
		 rectangle(x1, y1, x1+20 ,y1+20);
		 setwritemode(COPYPUT);
		 setlinestyle(SOLIDLN, 1, 2);
		 mostraMouse;
	      End;
	   8: Begin
		 escondeMouse;
		 cleardevice;
		 mostraMouse;
		 active_function := old_function;
	      End;

	   9: active_function := old_function;

	   10:Begin
		 escondeMouse;
		 setcolor(WHITE);
		 getimage(0, 0, 200, 25, BackGrounD^);
		 setwritemode(XORPUT);
		 line(0,24,639, 24);

		 gotoxy(1,1);

		 readln(filename);
		 line(0,24,639, 24);
		 putimage(0, 0, BackGrounD^, COPYPUT);

                 Assign(arquivo, filename);
                 Rewrite(arquivo); { Cria arquivo }

  	         for x1:=0 to 639 do
                    for y1 :=0 to 479 do
                     Begin
                       pixel := getpixel(x1,y1);
		       write(arquivo, pixel);
                     End;

	         close(arquivo);

		 mostraMouse;
		 setfillstyle(SOLIDFILL, WHITE);
		 setwritemode(COPYPUT);
                 active_function := old_function;
	      End;
	   11:Begin
		 escondeMouse;
		 setcolor(WHITE);
		 setcolor(WHITE);
		 getimage(0, 0, 200, 25, BackGrounD^);
		 setwritemode(XORPUT);
		 line(0,24,639, 24);
		 gotoxy(1,1);
		 readln(filename);
		 line(0,24,639, 24);
		 putimage(0, 0, BackGrounD^, COPYPUT);

                 Assign(arquivo, filename);
                 Reset(arquivo);

                 for x1:=0 to 639 do
                    for y1:=0 to 479 do
                    begin
                       read(arquivo, pixel);
                       putpixel(x1, y1, pixel);
                    end;
                 close(arquivo);

		 mostraMouse;
		 setwritemode(COPYPUT);
		 setfillstyle(SOLIDFILL, WHITE);

                 active_function := old_function;
              End;
	   12: active_function := old_function;
	End;
      End;
   until active_function = noptions;

   escondeMouse;
   modoTexto;     { Volta para o modo de Texto }

   FreeMem(BackGrounD, imagesize(1, 1, 100, 200)); { libera memoria alocada }
End.
