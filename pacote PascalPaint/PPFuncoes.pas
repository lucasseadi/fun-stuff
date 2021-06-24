unit PPFuncoes;

interface

uses crt, graph; {para desenhar e capturar a imagem da tela}

type tiponomearquivo=string[255];
     tipoarquivo=file of byte;
     tipobufferHorizontal=array[-8..8,-1..1] of word;
     tipobufferVertical=array[-1..1,-8..8] of word;
     tipobufferBorracha=array[-8..8,-8..8] of word;

procedure telaInterface(tipoMsg:integer);
{Procedure telaInterface: Imprime o cabeçalho fixo e a última linha, que depende
do valor de tipoMsg.}

procedure NovaTela(var Largura,Altura:integer; MaxX,MaxY:integer);
{Procedure NovaTela: Recebe duas variáveis inteiras para as dimensões da imagem
e os limites da janela de gráfico. Limpa a tela de desenho.}

procedure Redimensiona(var Largura,Altura:integer; MaxX,MaxY:integer);
{Procedure Redimensiona: Recebe duas variáveis inteiras para as dimensões da
imagem e os limites da janela de gráfico. Muda os limites superiores (horizontal
e vertical) da área de desenho, recebendo um ponto que corresponderá a esses
limites, obtido através da Function Cursor. Se necessário, limpa a área de
diferença entre a janela previamente definida e a nova.}

function Abre(nome:tiponomearquivo; var Arquivo:tipoarquivo; var Largura,Altura:integer; MaxX,MaxY:integer):byte;
{Function Abre: Recebe um nome de arquivo, uma variável para controlá-lo, duas
variáveis inteiras onde ela escreverá as dimensões da imagem, e os limites da
janela de gráfico. Seu mecanismo interno tenta abrir o arquivo de imagem com o
nome especificado e exibi-lo na tela. A saída da função é um byte como a seguir:
0 -> Arquivo aberto e exibido
1 -> Bitmap com header não suportado (OS/2, por exemplo)
2 -> Bitmap não usa 8 bits por pixel
3 -> Offset do bitmap inválido (sobreposição de imagem e paleta)
4 -> Arquivo não é um bitmap
5 -> Arquivo com esse nome não foi encontrado
6 -> A figura tem dimensões maiores do que a resolução suportada}

function Salva(nome:tiponomearquivo; var Arquivo:tipoarquivo; Largura,Altura:integer):byte;
{Function Salva: Recebe um nome de arquivo, uma variável para controlá-lo, e
dois parâmetros com as dimensões da figura a ser salva. Seu mecanismo interno
tenta salvar um bitmap com a imagem da tela usando o nome especificado. A saída
da função é um byte, como a seguir:
0 -> Arquivo salvo com sucesso
1 -> Falha no salvamento do arquivo}

function EscolheCor(Largura,Altura:integer):byte;
{Function EscolheCor: Recebe os parâmetros correspondentes às dimensões da
figura como entrada. Exibe a paleta de cores na tela e permite que o usuário
escolha uma cor usando as setas para navegar entre elas e Enter para confirmar
a escolha. A saída é um byte (0..255), correspondente ao índice na paleta da cor
que o usuário escolheu.}

function Cursor(var XCursor:integer; var YCursor:integer; Largura,Altura:integer; cor:byte):boolean;
{Function Cursor: Recebe variáveis para o posicionamento do cursor, as dimensões
da tela e um índice de cor da paleta. Responde a interação do teclado: setas
direcionais para movimentação; W, A, S e D para precisão; e Enter para marcar
um ponto. Retorna "true" caso a função seja confirmada pelo usuário e "false"
caso ele cancele.}

procedure acendeCursor(XCentral,YCentral:integer;
                       var bufferCursorHoriz:tipobufferHorizontal;
                       var bufferCursorVert:tipobufferVertical;
                       Largura,Altura:integer;
                       cor:byte);
{Procedure acendeCursor: É chamada pela procedure Cursor. Recebe as coordenadas
da posição do cursor, duas matrizes que armazenam a parte da tela sobreposta
pelo cursor, as dimensões da tela e um índice de cor da paleta. Armazena a
parte sobreposta da tela e desenha o cursor na posição especificada.}

procedure apagaCursor(XCentral,YCentral:integer;
                      bufferCursorHoriz:tipobufferHorizontal;
                      bufferCursorVert:tipobufferVertical;
                      Largura,Altura:integer);
{Procedure apagaCursor: É chamada pela Procedure Cursor. Recebe as coordenadas
da posição do cursor, duas matrizes que armazenam a parte da tela sobreposta
pelo cursor e as dimensões da tela de desenho. Redesenha na tela a área
armazenada na matriz, "apagando" o cursor.}

procedure Teclas(MaxX,MaxY:integer);
{Procedure Teclas: Recebe como parãmetros os limites da janela gráfica. Responde
a interação do usuário através do teclado, conforme as instruções exibidas na
tela, para chamar as funções de desenho, de manipulação de arquivos e para sair
do programa.}

procedure DesenhaLinha(Largura,Altura:integer; cor:byte);
{Procedure DesenhaLinha: Recebe como parâmetros as dimensões da figura e uma cor
para desenho. Pede dois pontos através da Function Cursor e desenha uma linha
entre os dois.}

procedure DesenhaCirculo(Largura,Altura:integer; cor:byte);
{Procedure DesenhaCirculo: Recebe como parâmetros as dimensões da figura e uma
cor para desenho. Pede dois pontos através da Function Cursor e desenha um
circulo, cujo centro é o primeiro ponto escolhido e cujo raio é igual ao máximo
entre as distâncias vertical e horizontal entre o primeiro e o segundo ponto.}

procedure DesenhaRetangulo(Largura,Altura:integer; cor:byte);
{Procedure DesenhaRetangulo: Recebe como parâmetros as dimensões da figura e uma
cor para desenho. Pede dois pontos através da Function Cursor e desenha um
retangulo cuja diagonal é uma linha imaginária entre os dois pontos.}

procedure DesenhaElipse(Largura,Altura:integer; cor:byte);
{Procedure DesenhaElipse: Recebe como parâmetros as dimensões da figura e uma
cor para desenho. Pede dois pontos através da Function Cursor e desenha uma
elipse cuja moldura retangular imaginária tem por diagonal uma linha entre os
dois pontos.}

function ObtemCor(Largura,Altura:integer; cor:byte):byte;
{Function ObtemCor: Recebe como parâmetros as dimensões da figura e a cor que
está atualmente selecionada. Pede um ponto através da Function Cursor e, em caso
de confirmação, retorna a cor desse ponto. Em caso de cancelamento, retorna a
cor recebida como parâmetro.}

procedure DesenhaVariasLinhas(Largura,Altura:integer; cor:byte);
{Procedure DesenhaVariasLinhas: Recebe como parâmetros as dimensões da figura e
uma cor para desenho. Pede pontos repetidamente através da Function Cursor e
desenha linhas entre o primeiro e o segundo ponto, entre o segundo e o terceiro,
e assim por diante, até a interrupção da Function Cursor.}

procedure Preenche(Largura,Altura:integer; cor:byte);
{Procedure Preenche: Recebe como parâmetros as dimensões da figura e uma cor
para preenchimento. Pede um ponto através da Function Cursor, e caso a cor do
ponto seja diferente da cor fornecida, chama a Function Fill para preencher o
ponto e toda a área adjacente a ele que tenha a mesma cor, usando a cor que foi
recebida como parâmetro.}

procedure Fill(XLocal,YLocal:integer; Largura,Altura:integer; cor:byte; CorArea:word; QuemChamou:byte);
{Procedure Fill: Recebe as coordenadas de um ponto, as dimensões da figura, uma
cor para preenchimento, uma cor a ser preenchida e um byte "QuemChamou", que
informa de que lado está o pixel de onde foi feita a chamada recursiva a essa
Procedure Fill. Caso o ponto indicado pelas coordenadas seja da cor que deve ser
substituída, ele é pintado pela cor de preenchimento, e são feitas as chamadas
recursivas aos pontos adjacentes à esquerda, acima, à direita e abaixo, com os
mesmos parâmetros de cores e com o byte "QuemChamou" adequado, desde que os
pontos não saiam das dimensões da figura, e com exceção do ponto de onde o atual
passo da recursão foi chamado. O valor do byte "QuemChamou" tem o seguinte
significado:
0 -> Central:  Usado na primeira chamada de Fill, no ponto inicial
1 -> Esquerda: Um passo de recursão da Fill que recebe esse valor não faz
               chamada recusriva à esquerda no próximo passo, ou seja, não faz
               uma chamada que tenha como parâmetro o valor 3 (Direita), pois
               estaria voltando ao ponto de onde o passo atual foi chamado.
2 -> Acima:    Não faz chamada para cima no próximo passo, ou seja, não faz uma
               próxima chamada com parâmetro 4 (Abaixo).
3 -> Direita:  Não faz chamada à direita no próximo passo; não faz uma próxima
               chamada com parâmetro 1 (Esquerda).
4 -> Abaixo:   Não faz chamada para baixo no próximo passo; não faz uma próxima
               chamada com parâmetro 2 (Acima).}

procedure lapis(Largura,Altura:integer; cor:byte);
{Procedure lapis: Recebe como parâmetros as dimensões da figura e uma cor
para desenho. Pede pontos repetidamente através da Function Cursor e
marca os pontos até a interrupção da Function Cursor.}

function CursorBorracha(var XCursor:integer; var YCursor:integer; Largura,Altura:integer;
                        var bufferCursorBorracha:tipobufferBorracha):boolean;
{Function CursorBorracha: Recebe variáveis para o posicionamento do cursor, as dimensões
da tela e o buffer para salvar os pixels do fundo. Responde a interação do teclado: setas
direcionais para movimentação; W, A, S e D para precisão; e Enter para apagar a
área ocupada pelo cursor. Retorna "true" caso a função seja confirmada pelo usuário e "false"
caso ele cancele.}

procedure acendeCursorBorracha(XCentral,YCentral:integer;var bufferCursorBorracha:tipobufferBorracha;
                               Largura,Altura:integer);
{Procedure acendeCursorBorracha: É chamada pela procedure CursorBorracha. Recebe as coordenadas
da posição do cursor, uma matriz que armazena a parte da tela sobreposta
pelo cursor e as dimensões da tela. Armazena a
parte sobreposta da tela e desenha o cursor na posição especificada.}

procedure apagaCursorBorracha(XCentral,YCentral:integer;bufferCursorBorracha:tipobufferBorracha;
                              Largura,Altura:integer);
{Procedure apagaCursorBorracha: É chamada pela Procedure CursorBorracha. Recebe as coordenadas
da posição do cursor, uma matriz que armazena a parte da tela sobreposta
pelo cursor e as dimensões da tela de desenho. Redesenha na tela a área
armazenada na matriz, "apagando" o cursor.}

procedure borracha(Largura,Altura:integer);
{Procedure borracha: Recebe como parâmetros as dimensões da figura.
Pede um ponto através da Function CursorBorracha, gerenciando seu funcionamento.}

implementation

procedure telaInterface(tipoMsg:integer);
const InstrucoesCursor1='Setas direcionais para mover o cursor;';
      InstrucoesCursor2='W, A, S, e D para movimentacao precisa;';
      InstrucoesCursor3='Enter para selecionar o ponto;';
      InstrucoesCursor4='Qualquer outra tecla para interromper.';
begin
textbackground(7);
textcolor(0);
clrscr();
writeln('UNIVERSIDADE FEDERAL DO RIO GRANDE DO SUL');
writeln('TECNICAS DE CONSTRUCAO DE PROGRAMAS (INF 01120) - PROF. OTACILIO');
writeln();
writeln('Lucas Seadi e Tobias Petry');
writeln();
writeln('      ==========     PascalPaint    ==========');
writeln();
writeln('Comandos:');
writeln();
writeln('N-Nova tela               J-Limite(Janela desenho)');
writeln('E-Elipse                  C-Circulo');
writeln('L-Linha                   D-Linhas consecutivas     R-Retangulo');
writeln('P-Paleta                  O-Obter cor do ponto      F-Preenchimento(Fill)');
writeln('A-Abrir arquivo           S-Salvar arquivo          Esc-Sair');
writeln('I-Lapis                   B-Borracha');
writeln;
writeln;

textbackground(14);
textcolor(1);
clreol;
case tipoMsg of
     1:  writeln('Nova tela.');
     2:  write('Abrindo');
     3:  write('Salvando');
     4:  begin
         writeln('Use as quatro setas direcionais para navegar na paleta.');
         clreol;
         writeln('Pressione Enter para selecionar uma cor.');
         end;
     5:  writeln('Cor escolhida.');
     6:  writeln('Escreva o caminho completo do arquivo a ser aberto: ');
     7:  writeln('Header nao suportado. Use um bitmap Windows V3. Pressione Enter.');
     8:  writeln('Use um bitmap de 8 bits. Pressione Enter.');
     9:  writeln('Offset do arquivo esta corrmpido. Pressione Enter.');
     10: writeln('A figura é grande demais. Pressione Enter.');
     11: writeln('Escreva o caminho completo do arquivo a ser salvo: ');
     12: begin
         writeln('Circulo. Escolha o ponto central.');
         clreol;
         writeln(InstrucoesCursor1);
         clreol;
         writeln(InstrucoesCursor2);
         clreol;
         writeln(InstrucoesCursor3);
         clreol;
         writeln(InstrucoesCursor4);
         end;
     13: begin
         writeln('Elipse. Escolha dois pontos que definam a moldura retangular da elipse.');
         clreol;
         writeln(InstrucoesCursor1);
         clreol;
         writeln(InstrucoesCursor2);
         clreol;
         writeln(InstrucoesCursor3);
         clreol;
         writeln(InstrucoesCursor4);
         end;
     14: begin
         writeln('Linha. Escolha o ponto inicial.');
         clreol;
         writeln(InstrucoesCursor1);
         clreol;
         writeln(InstrucoesCursor2);
         clreol;
         writeln(InstrucoesCursor3);
         clreol;
         writeln(InstrucoesCursor4);
         end;
     15: writeln('Paleta.');
     16: begin
         writeln('Retangulo. Escolha dois pontos que definam a moldura do retangulo.');
         clreol;
         writeln(InstrucoesCursor1);
         clreol;
         writeln(InstrucoesCursor2);
         clreol;
         writeln(InstrucoesCursor3);
         clreol;
         writeln(InstrucoesCursor4);
         end;
     17: begin
         writeln('Ponto escolhido. Escolha o proximo ponto.');
         clreol;
         writeln(InstrucoesCursor1);
         clreol;
         writeln(InstrucoesCursor2);
         clreol;
         writeln(InstrucoesCursor3);
         clreol;
         writeln(InstrucoesCursor4);
         end;
     18: writeln('Acao cancelada.');
     19: begin
         writeln('Ponto central escolhido. Escolha o ponto que determina o raio.');
         clreol;
         writeln(InstrucoesCursor1);
         clreol;
         writeln(InstrucoesCursor2);
         clreol;
         writeln(InstrucoesCursor3);
         clreol;
         writeln(InstrucoesCursor4);
         end;
     20: begin
         writeln('Ponto 1 escolhido. Escolha o ponto 2.');
         clreol;
         writeln(InstrucoesCursor1);
         clreol;
         writeln(InstrucoesCursor2);
         clreol;
         writeln(InstrucoesCursor3);
         clreol;
         writeln(InstrucoesCursor4);
         end;
     21: writeln('Circulo desenhado.');
     22: writeln('Elipse desenhada.');
     23: writeln('Linha desenhada.');
     24: writeln('Retangulo desenhado.');
     25: writeln('Cor obtida.');
     26: begin
         writeln('Escolha o ponto do qual a cor sera obtida.');
         clreol;
         writeln(InstrucoesCursor1);
         clreol;
         writeln(InstrucoesCursor2);
         clreol;
         writeln(InstrucoesCursor3);
         clreol;
         writeln(InstrucoesCursor4);
         end;
     27: begin
         writeln('Linhas consecutivas. Marque o ponto inicial.');
         clreol;
         writeln(InstrucoesCursor1);
         clreol;
         writeln(InstrucoesCursor2);
         clreol;
         writeln(InstrucoesCursor3);
         clreol;
         writeln(InstrucoesCursor4);
         end;
     28: writeln('Area preenchida. Pressione Enter.');
     29: begin
         writeln('Marque a area a ser preenchida.');
         clreol;
         writeln(InstrucoesCursor1);
         clreol;
         writeln(InstrucoesCursor2);
         clreol;
         writeln(InstrucoesCursor3);
         clreol;
         writeln(InstrucoesCursor4);
         end;
     30: write('Preenchendo, aguarde... (nao pressione tecla alguma)');
     31: begin
         writeln('Marque o novo ponto de limite da area de desenho.');
         clreol;
         writeln(InstrucoesCursor1);
         clreol;
         writeln(InstrucoesCursor2);
         clreol;
         writeln(InstrucoesCursor3);
         clreol;
         writeln(InstrucoesCursor4);
         end;
     32: write('Janela redimensionada: ');
     33: write('Deseja salvar seu desenho? (S/N)');
     34: write('Pressione enter para marcar os pontos ou qualquer outra tecla para sair.');
     35: write('Pressione enter para apagar ou qualquer outra tecla para sair.');
     99: begin
         writeln();
         //writeln();
         end;
    end;
end;

procedure NovaTela(var Largura,Altura:integer; MaxX,MaxY:integer);
var paleta:PaletteType;
begin
GetDefaultPalette(paleta);                     // Inicialização da
SetAllPalette(paleta);                         // paleta e limpeza
SetBkColor(0);                                 // do fundo da tela.
ClearDevice;                                   //

Largura:=MaxX + 1;                                 // Preenchimento
Altura:=MaxY + 1;                                  // da área de
SetViewPort(0,0,(Largura - 1),(Altura - 1),True);  // desenho com
SetFillStyle(1,15);                                // a cor branca.
Bar(0,0,(Largura - 1),(Altura - 1));               //
telaInterface(1);
end;

procedure Redimensiona(var Largura,Altura:integer; MaxX,MaxY:integer);
var ifPonto1:boolean;
    XLimite,YLimite:integer;
    CorFundo:word;
begin
CorFundo:=GetPixel((Largura - 1),(Altura - 1));
XLimite:=Largura - 1;
YLimite:=Altura - 1;
SetViewPort(0,0,MaxX,MaxY,True);                                  
ifPonto1:=Cursor(XLimite,YLimite,(MaxX + 1),(MaxY + 1),240);
if ifPonto1
then begin
     SetFillStyle(1,0);
     if XLimite < MaxX
     then begin
          Bar((XLimite + 1),0,MaxX,MaxY);
          end;
     if YLimite < MaxY
     then begin
          Bar(0,(YLimite + 1),MaxX,MaxY);
          end;
     SetViewPort(0,0,XLimite,YLimite,True);
     SetFillStyle(1,CorFundo);
     if (XLimite > (Largura - 1))
     then begin
          Bar(Largura,0,XLimite,YLimite);
          end;
     if (YLimite > (Altura - 1))
     then begin
          Bar(0,Altura,XLimite,YLimite);
          end;
     Largura:=XLimite + 1;
     Altura:=YLimite + 1;
     telaInterface(32);
     writeln(Largura,'x',Altura);
     end
else begin
     SetViewPort(0,0,(Largura - 1),(Altura - 1),True);
     telaInterface(18);
     end;
end;

function Abre(nome:tiponomearquivo; var Arquivo:tipoarquivo; var Largura,Altura:integer; MaxX,MaxY:integer):byte;
var filebyte,filebytebuffer,blue,green,red:byte;
    counter1,counter2,offset,nullbytes:integer;
begin
telaInterface(2);

assign(Arquivo,nome);                             // Tenta abrir o arquivo
{$I-}                                             // e verifica o "número
reset(Arquivo);                                   // mágico" dos bitmaps,
{$I+}                                             // que corresponde às letras
if IOresult=0                                     // "BM" em ASCII.
then begin                                        // Inicializa o valor do
     read(Arquivo,filebyte);                      // offset.
     filebytebuffer:=filebyte;                    //
     read(Arquivo,filebyte);                      //
     if (filebyte = 77) and (filebytebuffer = 66) //
     then begin                                   //
          offset:=0;                              //

          for counter1:=1 to 8 do     // Ignora tamanho do arquivo e bytes
              read(Arquivo,filebyte); // reservados. Não importam agora.

          read(Arquivo,filebyte);                 // Leitura do offset, ou seja,
          offset:=offset + filebyte;              // do endereço em que começa
          read(Arquivo,filebyte);                 // a imagem propriamente dita
          offset:=offset + (filebyte * 256);      // dentro do arquivo.
          read(Arquivo,filebyte);                 //
          offset:=offset + (filebyte * 65536);    //
          read(Arquivo,filebyte);                 //
          offset:=offset + (filebyte * 16777216); //

          read(Arquivo,filebyte);        // Lê o identificador do header.
          if filebyte <> 40              // Suporta apenas o header Windows V3,
          then begin                     // que é o mais usado por questões de
               Abre:=1;                  // compatibilidade. A ele corresponde
               end                       // o valor 40. Caso o header seja
          else begin                     // outro, a função retorna o código de
               read(Arquivo,filebyte);   // erro apropriado para header não-
               read(Arquivo,filebyte);   // -suportado.
               read(Arquivo,filebyte);   //

               read(Arquivo,filebyte);                      //
               filebytebuffer:=filebyte;                    //
               read(Arquivo,filebyte);                      //
               Largura:=(filebyte * 256) + filebytebuffer;  //
               read(Arquivo,filebyte);                      // Leitura da
               read(Arquivo,filebyte);                      // largura

               read(Arquivo,filebyte);                      //
               filebytebuffer:=filebyte;                    //
               read(Arquivo,filebyte);                      //
               Altura:=(filebyte * 256) + filebytebuffer;   //
               read(Arquivo,filebyte);                      // Leitura da
               read(Arquivo,filebyte);                      // altura

               if (Largura > (MaxX + 1)) or (Altura > (MaxY + 1))
               then begin
                    Abre:=6;      // Dimensões da figura são superiores à janela.
                    end
               else begin
                    SetViewPort(0,0,(Largura - 1),(Altura - 1),True); // Dimensiona a janela

                    read(Arquivo,filebyte); //
                    read(Arquivo,filebyte); // Color Plane (ignorado por agora)

                    read(Arquivo,filebyte);      // Bits por pixel. Se o valor não
                    if filebyte <> 8             // for igual a 8, o arquivo não é
                    then begin                   // suportado e a função retorna o
                         Abre:=2;                // código de erro correspondente.
                         end                     //
                    else begin                   //
                         read(Arquivo,filebyte); //

                         read(Arquivo,filebyte); //
                         read(Arquivo,filebyte); //
                         read(Arquivo,filebyte); //
                         read(Arquivo,filebyte); // Método de Compressão (ignorado)

                         read(Arquivo,filebyte); //
                         read(Arquivo,filebyte); //
                         read(Arquivo,filebyte); //
                         read(Arquivo,filebyte); // Image Size (ignorado)

                         read(Arquivo,filebyte); //
                         read(Arquivo,filebyte); //
                         read(Arquivo,filebyte); //
                         read(Arquivo,filebyte); // Horizontal pixel/m (ignorado)

                         read(Arquivo,filebyte); //
                         read(Arquivo,filebyte); //
                         read(Arquivo,filebyte); //
                         read(Arquivo,filebyte); // Vertical pixel/m (ignorado)

                         read(Arquivo,filebyte); //
                         read(Arquivo,filebyte); //
                         read(Arquivo,filebyte); //
                         read(Arquivo,filebyte); // Cores usadas (ignorado)

                         read(Arquivo,filebyte); //
                         read(Arquivo,filebyte); //
                         read(Arquivo,filebyte); //
                         read(Arquivo,filebyte); // Cores importantes (ignorado)

                         for counter1:=0 to 255 do                   //
                             begin                                   //
                             read(Arquivo,filebyte);                 //
                             blue:=filebyte;                         //
                             read(Arquivo,filebyte);                 //
                             green:=filebyte;                        //
                             read(Arquivo,filebyte);                 //
                             red:=filebyte;                          //
                             read(Arquivo,filebyte);                 // Leitura da
                             SetRgbPalette(counter1,red,green,blue); // paleta
                             end;                                    //

                         if offset < 1078                                // Se o offset for
                         then begin                                      // menor do que o
                              Abre:=3;                                   // padrão, quer dizer
                              end                                        // que ele sobrepõe
                         else begin                                      // a paleta e o
                              if offset > 1078                           // arquivo está
                              then begin                                 // corrompido (código
                                   for counter1:=1 to (offset - 1078) do // de erro). Se for
                                       read(Arquivo,filebyte);           // maior, ajusta-se a
                                   end;                                  // posição do leitor.
                              nullbytes:=(4 - (Largura mod 4));          // Aqui, calcula quantos
                              if nullbytes=4                             // NOPS estão incluídos
                              then nullbytes:=0;                         // no final de cada linha
                                                                         // horizontal (por padrão,
                                                                         // cada linha horizontal
                                                                         // tem um número de bytes
                                                                         // divisível por 4).

                              SetBkColor(0);                             // Limpeza
                              ClearDevice;                               // da tela.

                              for counter1:=(Altura - 1) downto 0 do        // Lê os bytes do arquivo e
                                  begin                                     // preenche a tela com os dados,
                                  for counter2:=0 to (Largura - 1) do       // começando pelas linhas
                                      begin                                 // horizontais mais baixas na
                                      read(Arquivo,filebyte);               // tela, da esquerda para a
                                      PutPixel(counter2,counter1,filebyte); // direita, e pulando os NOPS
                                      end;                                  // no fim de cada uma delas
                                  if nullbytes > 0                          // quando eles existem.
                                  then begin                                // A cada 25 pixels de altura,
                                       for counter2:=1 to nullbytes do      // um "." ´exibido na tela de
                                           read(Arquivo,filebyte);          // console para explicitar que
                                       end;                                 // o processo está em andamento.
                                  if (counter1 mod 25)=0                    // No final, o código de erro
                                  then write('.');                          // "zero" (sem erros) é atribuído
                                  end;                                      // à saída da função e um "!" é
                              Abre:=0;                                      // exibido na tela de console.
                              writeln('!');                                 //
                              end;
                         end;
                    end;
               end;
          end
     else begin       // Código de erro exibido quando o
          Abre:=4;    // arquivo aberto não é um bitmap.
          end;
     close(Arquivo);  // Fechamento da leitura do arquivo.
     end
else begin            // Código de erro
     Abre:=5;         // para arquivo
     end;             // não-encontrado.
//writeln;
end;

function Salva(nome:tiponomearquivo; var Arquivo:tipoarquivo; Largura,Altura:integer):byte;
var filebyte,blue,green,red:byte;
    counter1,counter2,nullbytes,VarAltura,VarLargura:integer;
    imagesize,filesize:longint;
    blueword,greenword,redword,fileword:word;
begin
//writeln;
telaInterface(3);
assign(Arquivo,nome);
{$I-}
rewrite(Arquivo);
{$I+}
if IOresult=0
then begin
     filebyte:=66;             // Escrita do "BM" no início do arquivo.
     write(Arquivo,filebyte);  //
     filebyte:=77;             //
     write(Arquivo,filebyte);  //
     filebyte:=0;

     nullbytes:=(4 - (Largura mod 4));            //
     if nullbytes=4                               // Cáluclo de bytes nulos por linha horiziontal,
     then nullbytes:=0;                           // cálculo do tamanho do bitmap em bytes
     imagesize:=(Altura * (Largura + nullbytes)); // (sem header e paleta, incluindo nulos),
     filesize:=imagesize + 1078;                  // e cálculo do tamanho do arquivo em bytes.

     filebyte:=filesize and 255; // Fatoração do valor
     write(Arquivo,filebyte);    // entre os quatro bytes.
     filesize:=filesize div 256; //
     filebyte:=filesize and 255; //
     write(Arquivo,filebyte);    //
     filesize:=filesize div 256; //
     filebyte:=filesize and 255; //
     write(Arquivo,filebyte);    //
     filesize:=filesize div 256; //
     filebyte:=filesize and 255; // Escrita do tamanho
     write(Arquivo,filebyte);    // do arquivo (em bytes).

     filebyte:=0;                 //
     for counter1:=1 to 4 do      //
         write(Arquivo,filebyte); // Valores reservados (preenchidos com zero).

     filebyte:=54;            //
     write(Arquivo,filebyte); //
     filebyte:=4;             //
     write(Arquivo,filebyte); //
     filebyte:=0;             //
     write(Arquivo,filebyte); //
     write(Arquivo,filebyte); // Preenchendo valor do offset (sempre padrão).

     filebyte:=40;            //
     write(Arquivo,filebyte); //
     filebyte:=0;             //
     write(Arquivo,filebyte); //
     write(Arquivo,filebyte); //
     write(Arquivo,filebyte); // Header size (sempre Windows V3, valor "40").

     VarLargura:=Largura;                           // Fatoração
     filebyte:=VarLargura and 255;                  // do valor
     write(Arquivo,filebyte);                       // entre dois bytes
     VarLargura:=Varlargura div 256;                // (os outros dois nunca são
     filebyte:=VarLargura and 255;                  // usados na prática - não
     write(Arquivo,filebyte);                       // há figuras com dimensões
     filebyte:=0;                                   // maiores do que 65536).
     write(Arquivo,filebyte);                       // Escrita da
     write(Arquivo,filebyte);                       // largura.

     VarAltura:=Altura;                             // Fatoração
     filebyte:=VarAltura and 255;                   // do valor
     write(Arquivo,filebyte);                       // entre dois bytes
     VarAltura:=VarAltura div 256;                  // (os outros dois nunca são
     filebyte:=VarAltura and 255;                   // usados na prática - não
     write(Arquivo,filebyte);                       // há figuras com dimensões
     filebyte:=0;                                   // maiores do que 65536).
     write(Arquivo,filebyte);                       // Escrita da
     write(Arquivo,filebyte);                       // altura.

     filebyte:=1;              //
     write(Arquivo,filebyte);  //
     filebyte:=0;              //
     write(Arquivo,filebyte);  // Color Planes (preenchido com "1").

     filebyte:=8;              //
     write(Arquivo,filebyte);  // Bits por pixel (sempre "8").
     filebyte:=0;              //
     write(Arquivo,filebyte);  //

     write(Arquivo,filebyte); //
     write(Arquivo,filebyte); // Compressão (nenhuma: "0").
     write(Arquivo,filebyte); //
     write(Arquivo,filebyte); //

     filebyte:=imagesize and 255;                 // Fatoração do
     write(Arquivo,filebyte);                     // valor entre
     imagesize:=imagesize div 256;                // os quatro bytes.
     filebyte:=imagesize and 255;                 //
     write(Arquivo,filebyte);                     //
     imagesize:=imagesize div 256;                //
     filebyte:=imagesize and 255;                 //
     write(Arquivo,filebyte);                     //
     imagesize:=imagesize div 256;                //
     filebyte:=imagesize and 255;                 // Escrita do tamanho
     write(Arquivo,filebyte);                     // da imagem.

     filebyte:=0;             //
     write(Arquivo,filebyte); //
     write(Arquivo,filebyte); //
     write(Arquivo,filebyte); //
     write(Arquivo,filebyte); // Pixel/m horiz. (opcional, preenchido com 0).

     write(Arquivo,filebyte); //
     write(Arquivo,filebyte); //
     write(Arquivo,filebyte); //
     write(Arquivo,filebyte); // Pixel/m vert. (opcional, preenchido com 0).

     write(Arquivo,filebyte); //
     write(Arquivo,filebyte); //
     write(Arquivo,filebyte); //
     write(Arquivo,filebyte); // Cores usadas (opcional, preenchido com 0).

     write(Arquivo,filebyte); //
     write(Arquivo,filebyte); //
     write(Arquivo,filebyte); //
     write(Arquivo,filebyte); // Cores importantes (opcional, preenchido com 0).

     for counter1:=0 to 255 do                               // Escrita da
         begin                                               // paleta utilizada
         GetRgbPalette(counter1,redword,greenword,blueword); // no arquivo.
         red:=redword;                                       //
         green:=greenword;                                   //
         blue:=blueword;                                     //
         filebyte:=0;                                        //
         write(Arquivo,blue);                                //
         write(Arquivo,green);                               //
         write(Arquivo,red);                                 //
         write(Arquivo,filebyte);                            //
         end;                                                //

     for counter1:=(Altura-1) downto 0 do            // Percorre os pixels da
         begin                                       // tela começando pelas
         for counter2:=0 to (Largura - 1) do         // linhas horizontais mais
             begin                                   // baixas na tela, da
             fileword:=GetPixel(counter2,counter1);  // esquerda para a direita,
             filebyte:=fileword;                     // e escreve um byte no
             write(Arquivo,filebyte);                // arquivo para cada pixel.
             end;                                    // Caso a largura em pixels
         if nullbytes > 0                            // não seja divisível por
         then begin                                  // 4, são adicionados bytes
              filebyte:=0;                           // NOP em cada linha do
              for counter2:=1 to nullbytes do        // arquivo para "fechar a
                  begin                              // conta". A cada 25 linhas
                  write(Arquivo,filebyte);           // horizontais escritas no
                  end;                               // arquivo, um "." é
              end;                                   // impresso na tela de
         if (counter1 mod 25)=0                      // console para mostrar que
         then write('.');                            // o processo está em
         end;                                        // andamento. A escrita do
     close(Arquivo);                                 // arquivo é fechada, o
     Salva:=0;                                       // código de erro é zero e
     write('!');                                   // um "!" é escrito no console.

     end            // Caso o salvamento
     else begin     // falhe, a função
          Salva:=1; // retorna o código
          end;      // de erro.
writeln;
end;

function EscolheCor(Largura,Altura:integer):byte;
var counter1,counter2,counter3:integer;
    X1,Y1,X2,Y2:integer;
    PixelColor:word;
    PixelByte:byte;
    Tecla:char;
    Selecionada:boolean;
    BufferImagem:array[0..255,0..255] of byte;
begin
telaInterface(4);
EscolheCor:=0;
Selecionada:=false;
SetViewPort(0,0,255,255,False);   // limites da paleta

for counter1:=0 to 255 do                              // Guarda o pedaço de
    for counter2:=0 to 255 do                          // imagem que será
        begin                                          // sobreposto pela paleta
        PixelColor:=GetPixel(counter2,counter1);       // em uma matriz.
        PixelByte:=PixelColor;                         //
        BufferImagem[counter2,counter1]:=PixelByte;    //
        end;                                           //
SetBkColor(0);                                         // Limpa a área da tela
ClearViewPort;                                         // para desenhar paleta.

for counter1:=0 to 15 do                           // 16 linhas
    begin                                          // com
    for counter2:=0 to 15 do                       // 16 colunas,
        begin                                      // totalizando 256 cores;
        counter3:=((counter1 * 16) + counter2);    // Seleção da cor em relação
        SetColor(counter3);                        // à sua posição em linha e
        SetFillStyle(1,counter3);                  // coluna;
        Bar((counter2 * 16),(counter1 * 16),((counter2 * 16) + 15),((counter1 * 16) + 15)); // tamanho dos quadrados
        end;
    end;

PixelByte:=0;
repeat counter3:=PixelByte;
       X1:=((counter3 mod 16) * 16);   // Posição da cor
       Y1:=((counter3 div 16) * 16);   // atualmente selecionada,
       X2:=X1 + 15;                    // para desenhar o retângulo
       Y2:=Y1 + 15;                    // em volta.

       counter1:=(not PixelByte);      // Cor do retângulo externo:
       SetColor(counter1);             // Índice inverso da cor
       SetFillStyle(1,counter1);       // selecionada.
       Rectangle(X1,Y1,X2,Y2);         //

       counter2:=((128 and (not PixelByte)) or (127 and PixelByte)); // Cor do segundo retângulo:
       SetColor(counter2);                                          // Índice da cor selecionada
       SetFillStyle(1,counter2);                                    // somado (ou subtraído) de
       Rectangle((X1 + 1),(Y1 + 1),(X2 - 1),(Y2 - 1));              // 128.

       Tecla:=readkey;                                              // Controle das setas
       case Tecla of                                                // e do Enter.
            #0  : begin
                  Tecla:=readkey;
                  case Tecla of
                       #72 : begin {seta para cima}
                             counter3:=PixelByte;
                             if PixelByte < 16
                             then begin
                                  PixelByte:=PixelByte + 240;
                                  end
                             else begin
                                  PixelByte:=PixelByte - 16;
                                  end;
                             end;
                       #75 : begin {seta para esquerda}
                             counter3:=PixelByte;
                             if (PixelByte mod 16) = 0
                             then begin
                                  PixelByte:=PixelByte + 15;
                                  end
                             else begin
                                  PixelByte:=PixelByte - 1;
                                  end;
                             end;
                       #77 : begin {seta para direita}
                             counter3:=PixelByte;
                             if (PixelByte mod 16) = 15
                             then begin
                                  PixelByte:=PixelByte - 15;
                                  end
                             else begin
                                  PixelByte:=PixelByte + 1;
                                  end;
                             end;
                       #80 : begin {seta para baixo}
                             counter3:=PixelByte;
                             if PixelByte > 239
                             then begin
                                  PixelByte:=PixelByte - 240;
                                  end
                             else begin
                                  PixelByte:=PixelByte + 16;
                                  end;
                             end;
                       end; {case}
                  end;
            #13 : Selecionada:=true; {Enter}
            end; {case}

       SetColor(counter3);                               // Apaga os
       SetFillStyle(1,counter3);                         // retângulos de
       Rectangle(X1,Y1,X2,Y2);                           // seleção da cor
       Rectangle((X1 + 1),(Y1 + 1),(X2 - 1),(Y2 - 1));   // anterior.

until Selecionada=true;   // Termina no "Enter".
EscolheCor:=PixelByte;   // Valor de saída da função.

SetBkColor(0);                                      // Apaga a paleta e retorna
ClearViewPort;                                      // às dimensões orginiais
SetViewPort(0,0,(Largura - 1),(Altura - 1),True);   // da figura.

for counter1:=0 to 255 do                           // Redesenha a parte sobreposta
    for counter2:=0 to 255 do                       // da figura a partir do array.
        PutPixel(counter2,counter1,BufferImagem[counter2,counter1]);
telaInterface(5);
end;

function Cursor(var XCursor:integer; var YCursor:integer; Largura,Altura:integer; cor:byte):boolean;
var sair:boolean;
    bufferCursorHoriz:tipobufferHorizontal;
    bufferCursorVert:tipobufferVertical;
    Tecla:char;
    PosicaoX,PosicaoY:integer;
begin
sair:=false;
PosicaoX:=XCursor;
PosicaoY:=YCursor;
while sair=false do
      begin
      acendeCursor(PosicaoX,PosicaoY,bufferCursorHoriz,bufferCursorVert,Largura,Altura,cor);
      Tecla:=readkey;
      case Tecla of
           #0     : begin {Tecla de Função}
                    Tecla:=readkey;
                    case Tecla of           // Movimentação das setas
                         #72 : begin
                               apagaCursor(PosicaoX,PosicaoY,bufferCursorHoriz,bufferCursorVert,Largura,Altura);
                               if PosicaoY > 19
                               then PosicaoY:=PosicaoY - 20
                               else PosicaoY:=0;
                               end;
                         #75 : begin
                               apagaCursor(PosicaoX,PosicaoY,bufferCursorHoriz,bufferCursorVert,Largura,Altura);
                               if PosicaoX > 19
                               then PosicaoX:=PosicaoX - 20
                               else PosicaoX:=0;
                               end;
                         #77 : begin
                               apagaCursor(PosicaoX,PosicaoY,bufferCursorHoriz,bufferCursorVert,Largura,Altura);
                               if PosicaoX < (Largura - 20)
                               then PosicaoX:=PosicaoX + 20
                               else PosicaoX:=Largura - 1;
                               end;
                         #80 : begin
                               apagaCursor(PosicaoX,PosicaoY,bufferCursorHoriz,bufferCursorVert,Largura,Altura);
                               if PosicaoY < (Altura - 20)
                               then PosicaoY:=PosicaoY + 20
                               else PosicaoY:=Altura - 1;
                               end;
                         else begin         // Escolha cancelada
                              sair:=true;
                              Cursor:=false;
                              apagaCursor(PosicaoX,PosicaoY,bufferCursorHoriz,bufferCursorVert,Largura,Altura);
                              end;
                         end; {case interno}
                    end;
           #13    : begin                   // Enter confirma ponto selecionado
                    sair:=true;
                    Cursor:=true;
                    apagaCursor(PosicaoX,PosicaoY,bufferCursorHoriz,bufferCursorVert,Largura,Altura);
                    end;
           'w','W': begin                   // Movimentação com W, A, S, D (precisão)
                    apagaCursor(PosicaoX,PosicaoY,bufferCursorHoriz,bufferCursorVert,Largura,Altura);
                    if PosicaoY > 0
                    then PosicaoY:=PosicaoY - 1;
                    end;
           'a','A': begin
                    apagaCursor(PosicaoX,PosicaoY,bufferCursorHoriz,bufferCursorVert,Largura,Altura);
                    if PosicaoX > 0
                    then PosicaoX:=PosicaoX - 1;
                    end;
           'd','D': begin
                    apagaCursor(PosicaoX,PosicaoY,bufferCursorHoriz,bufferCursorVert,Largura,Altura);
                    if PosicaoX < (Largura - 1)
                    then PosicaoX:=PosicaoX + 1;
                    end;
           's','S': begin
                    apagaCursor(PosicaoX,PosicaoY,bufferCursorHoriz,bufferCursorVert,Largura,Altura);
                    if PosicaoY < (Altura - 1)
                    then PosicaoY:=PosicaoY + 1;
                    end;
           else begin                       // Escolha cancelada
                sair:=true;
                Cursor:=false;
                apagaCursor(PosicaoX,PosicaoY,bufferCursorHoriz,bufferCursorVert,Largura,Altura);
                end;
           end; {case externo}
      end;
XCursor:=PosicaoX;
YCursor:=PosicaoY;
end;

procedure acendeCursor(XCentral,YCentral:integer;
                       var bufferCursorHoriz:tipobufferHorizontal;
                       var bufferCursorVert:tipobufferVertical;
                       Largura,Altura:integer;
                       cor:byte);
var counterX,counterY:integer;
    XAtual,YAtual:integer;
    pixel:word;
begin

{Salva buffer horizontal de fundo do cursor}
for counterY:=-1 to 1 do
    begin
    YAtual:=YCentral + counterY;
    for counterX:=-8 to 8 do
        begin
        XAtual:=XCentral + counterX;
        if (Xatual >= 0) and
           (YAtual >= 0) and
           (XAtual < Largura) and
           (YAtual < Altura)
        then bufferCursorHoriz[counterX,counterY]:=GetPixel(XAtual,YAtual)
        else bufferCursorHoriz[counterX,counterY]:=0;
        end;
    end;

{Salva buffer vertical de fundo do cursor}
for counterY:=-8 to 8 do
    begin
    YAtual:=YCentral + counterY;
    for counterX:=-1 to 1 do
        begin
        XAtual:=XCentral + counterX;
        if (Xatual >= 0) and
           (YAtual >= 0) and
           (XAtual < Largura) and
           (YAtual < Altura)
        then bufferCursorVert[counterX,counterY]:=GetPixel(XAtual,YAtual)
        else bufferCursorVert[counterX,counterY]:=0;
        end;
    end;

{Desenha linha horiziontal do cursor}
for counterY:=-1 to 1 do
    begin
    YAtual:=YCentral + counterY;
    for counterX:=-8 to 8 do
        begin
        XAtual:=XCentral + counterX;
        if (Xatual >= 0) and
           (YAtual >= 0) and
           (XAtual < Largura) and
           (YAtual < Altura) and
           ((counterX <> 0) or (counterY <> 0))
        then begin
             pixel:=GetPixel(XAtual,YAtual);
             pixel:=255 and (not pixel);
             PutPixel(XAtual,YAtual,pixel);
             end;
        end;
    end;

{Desenha linha vertical do cursor}
for counterY:=-8 to 8 do
    begin
    YAtual:=YCentral + counterY;
    for counterX:=-1 to 1 do
        begin
        XAtual:=XCentral + counterX;
        if (Xatual >= 0) and
           (YAtual >= 0) and
           (XAtual < Largura) and
           (YAtual < Altura) and
           ((counterX <> 0) or (counterY <> 0))
        then begin
             pixel:=GetPixel(XAtual,YAtual);
             pixel:=255 and (not pixel);
             PutPixel(XAtual,YAtual,pixel);
             end;
        end;
    end;

{Desenha centro do cursor}
for counterY:=-1 to 1 do
    begin
    YAtual:=YCentral + counterY;
    for counterX:=-1 to 1 do
        begin
        XAtual:=XCentral + counterX;
        if (Xatual >= 0) and
           (YAtual >= 0) and
           (XAtual < Largura) and
           (YAtual < Altura) and
           ((counterX <> 0) or (counterY <> 0))
        then PutPixel(XAtual,YAtual,cor);
        end;
    end;

end;

procedure apagaCursor(XCentral,YCentral:integer;
                      bufferCursorHoriz:tipobufferHorizontal;
                      bufferCursorVert:tipobufferVertical;
                      Largura,Altura:integer);
var counterX,counterY:integer;
    XAtual,YAtual:integer;
begin

{Carrega buffer e apaga a linha horizontal do cursor}
for counterY:=-1 to 1 do
    begin
    YAtual:=YCentral + counterY;
    for counterX:=-8 to 8 do
        begin
        XAtual:=XCentral + counterX;
        if (Xatual >= 0) and
           (YAtual >= 0) and
           (XAtual < Largura) and
           (YAtual < Altura)
        then PutPixel(XAtual,YAtual,bufferCursorHoriz[counterX,counterY]);
        end;
    end;

{Carrega buffer e apaga a linha vertical do cursor}
for counterY:=-8 to 8 do
    begin
    YAtual:=YCentral + counterY;
    for counterX:=-1 to 1 do
        begin
        XAtual:=XCentral + counterX;
        if (Xatual >= 0) and
           (YAtual >= 0) and
           (XAtual < Largura) and
           (YAtual < Altura)
        then PutPixel(XAtual,YAtual,bufferCursorVert[counterX,counterY]);
        end;
    end;
end;

procedure Teclas(MaxX,MaxY:integer);
var sair:boolean;
    Tecla:char;
    NomeArquivo:tiponomearquivo;
    Arquivo:tipoarquivo;
    Largura,Altura:integer;
    errorcode:byte;
    cor:byte;
begin
NovaTela(Largura,Altura,MaxX,MaxY);
cor:=0;
SetColor(cor);
sair:=false;
while sair=false do
      begin
      Tecla:=readkey;
      case Tecla of
           #0      : begin          // Tecla de função não utilizada
                     Tecla:=readkey;
                     end;
           'a','A' : begin          // Abrir arquivo
                     telaInterface(6);
                     clreol;
                     repeat readln(NomeArquivo);
                     until NomeArquivo <> '';
                     errorcode:=Abre(NomeArquivo,Arquivo,Largura,Altura,MaxX,MaxY);
                     case errorcode of
                          0 : begin
                              //telaInterface(99);
                              clreol;
                              write(NomeArquivo,' exibido.');
                              end;
                          1 : begin
                              telaInterface(7);
                              readln();
                              telaInterface(99);
                              end;
                          2 : begin
                              telaInterface(8);
                              readln();
                              telaInterface(99);
                              end;
                          3 : begin
                              telaInterface(9);
                              readln();
                              telaInterface(99);
                              end;
                          4 : begin
                              //telaInterface(99);
                              clreol;
                              writeln(NomeArquivo,' nao e um bitmap. Pressione Enter.');
                              readln();
                              telaInterface(99);
                              end;
                          5 : begin
                              //telaInterface(99);
                              clreol;
                              writeln(NomeArquivo,' nao encontrado. Pressione Enter.');
                              readln();
                              telaInterface(99);
                              end;
                          6 : begin
                              telaInterface(10);
                              readln;
                              telaInterface(99);
                              end;
                          else begin
                               //telaInterface(99);
                               clreol;
                               writeln('Falha na abertura de ',NomeArquivo,'. Enter.');
                               readln();
                               telaInterface(99);
                               end;
                          end; {case}
                     end;
           'b','B' : begin          // Desenho de Círculo
                     borracha(Largura,Altura);
                     end;
           'c','C' : begin          // Desenho de Círculo
                     telaInterface(12);
                     DesenhaCirculo(Largura,Altura,cor);
                     end;
           'd','D' : begin          // Desenho de Linhas Consecutivas
                     telaInterface(27);
                     DesenhaVariasLinhas(Largura,Altura,cor);
                     end;
           'e','E' : begin          // Desenho de Elipse
                     telaInterface(13);
                     DesenhaElipse(Largura,Altura,cor);
                     end;
           'f','F' : begin          // Preenchimento (Fill)
                     telaInterface(29);
                     Preenche(Largura,Altura,cor);
                     end;
           'i','I' : begin          // lápis
                     lapis(Largura,Altura,cor);
                     end;
           'j','J' : begin          // Redimensionamento da Janela de Desenho
                     telaInterface(31);
                     Redimensiona(Largura,Altura,MaxX,MaxY);
                     end;
           'l','L' : begin          // Desenho de Linha
                     telaInterface(14);
                     DesenhaLinha(Largura,Altura,cor);
                     end;
           'n','N' : begin          // Limpar a tela
                     NovaTela(Largura,Altura,MaxX,MaxY);
                     end;
           'o','O' : begin          // Obtenção de cor
                     telaInterface(26);
                     cor:=ObtemCor(Largura,Altura,cor);
                     SetColor(cor);
                     end;
           'p','P' : begin          // Seleção na Paleta
                     telaInterface(15);
                     cor:=EscolheCor(Largura,Altura);
                     SetColor(cor);
                     end;
           'r','R' : begin          // Desenho de Retângulo
                     telaInterface(16);
                     DesenhaRetangulo(Largura,Altura,cor);
                     end;
           's','S' : begin          // Salvar arquivo
                     telaInterface(11);
                     clreol;
                     repeat readln(NomeArquivo);
                     until NomeArquivo <> '';
                     errorcode:=Salva(NomeArquivo,Arquivo,Largura,Altura);
                     if errorcode=0
                     then begin
                          //telaInterface(99);
                          clreol;
                          write(NomeArquivo,' salvo.');
                          end
                     else begin
                          //telaInterface(99);
                          clreol;
                          writeln('Falha ao salvar ',NomeArquivo,'.');
                          end;
                     end;
           #27     : begin          // Saída do programa
                     repeat telaInterface(33);
                            Tecla:=readkey;
                     until (Tecla='S') or (Tecla='s') or (Tecla='N') or (Tecla='n');
                     if(Tecla='S')or(Tecla='s')
                        then begin
                             telaInterface(11);
                             clreol;
                             repeat readln(NomeArquivo);
                             until NomeArquivo <> '';
                             errorcode:=Salva(NomeArquivo,Arquivo,Largura,Altura);
                             if errorcode=0
                                then begin
                                     clreol;
                                     write(NomeArquivo,' salvo.');
                                     readkey;
                                     end
                                else begin
                                     clreol;
                                     writeln('Falha ao salvar ',NomeArquivo,'.');
                                     readkey;
                                     end;
                             end;
                     sair:=true;
                     end;
           else      begin          // Teclas não utilizadas
                     telaInterface(99);
                     end;
           end; {case}
      end;
end;

procedure DesenhaLinha(Largura,Altura:integer; cor:byte);
var XInicial,YInicial,XFinal,YFinal:integer;
    bufferCursorponto:byte;
    ifPonto1,ifPonto2:boolean;
begin
XInicial:=0;
YInicial:=0;
ifPonto1:=Cursor(XInicial,YInicial,Largura,Altura,cor);
XFinal:=XInicial;
YFinal:=YInicial;
if ifPonto1
then begin
     bufferCursorponto:=GetPixel(XInicial,YInicial);
     PutPixel(XInicial,YInicial,cor);
     telaInterface(17);
     ifPonto2:=Cursor(XFinal,YFinal,Largura,Altura,cor);
     if ifPonto2                                                 // Com dois pontos confirmados,
     then begin                                                  // desenha a linha.
          Line(XInicial,YInicial,XFinal,YFinal);
          telaInterface(23);
          end
     else begin
          PutPixel(XInicial,YInicial,bufferCursorponto);         // No caso de cancelamento,
          telaInterface(18);                                     // apaga o primeiro ponto.
          end;
     end
else telaInterface(18);
end;

procedure DesenhaCirculo(Largura,Altura:integer; cor:byte);
var XInicial,YInicial,XFinal,YFinal,XDist,YDist:integer;
    bufferCursorponto:byte;
    ifPonto1,ifPonto2:boolean;
begin
XInicial:=0;
YInicial:=0;
ifPonto1:=Cursor(XInicial,YInicial,Largura,Altura,cor);
XFinal:=XInicial;
YFinal:=YInicial;
if ifPonto1
then begin
     bufferCursorponto:=GetPixel(XInicial,YInicial);
     PutPixel(XInicial,YInicial,cor);
     telaInterface(19);
     ifPonto2:=Cursor(XFinal,YFinal,Largura,Altura,cor);
     if ifPonto2
     then begin
          XDist:=XFinal - XInicial;                  // Cálculo das
          if XDist < 0                               // distâncias
          then XDist:=(XDist - (2 * XDist));         // vertical e
          YDist:=YFinal - YInicial;                  // horizontal
          if YDist < 0                               // entre os dois
          then YDist:=(YDist - (2 * YDist));         // pontos.

          if XDist > YDist                           // O círculo é desenhado com
          then begin                                 // raio igual ao máximo entre
               Circle(XInicial,YInicial,XDist);      // as duas distâncias.
               telaInterface(21);
               end
          else begin
               Circle(XInicial,YInicial,YDist);
               telaInterface(21);
               end;
          end
     else telaInterface(18);
     PutPixel(XInicial,YInicial,bufferCursorponto);  // O ponto 1 é apagado - não faz parte do círculo.
     end
else telaInterface(18);
end;

procedure DesenhaRetangulo(Largura,Altura:integer; cor:byte);
var XInicial,YInicial,XFinal,YFinal:integer;
    bufferCursorponto:byte;
    ifPonto1,ifPonto2:boolean;
begin
XInicial:=0;
YInicial:=0;
ifPonto1:=Cursor(XInicial,YInicial,Largura,Altura,cor);
XFinal:=XInicial;
YFinal:=YInicial;
if ifPonto1
then begin
     bufferCursorponto:=GetPixel(XInicial,YInicial);
     PutPixel(XInicial,YInicial,cor);
     telaInterface(20);
     ifPonto2:=Cursor(XFinal,YFinal,Largura,Altura,cor);
     if ifPonto2
     then begin
          if XFinal > XInicial                                            // A chamada Rectangle da Unit Graph
          then begin                                                      // só funciona corretamente quando
               if YFinal > YInicial                                       // o segundo ponto fornecido tem
               then begin                                                 // coordenadas X e Y maiores do que
                    Rectangle(XInicial,YInicial,XFinal,YFinal);           // as coordenadas do primeiro ponto.
                    telaInterface(24);                                    // Para resolver esse problema, o
                    end                                                   // encadeamento de "if" prevê os
               else begin                                                 // nove casos diferentes de relação
                    if YFinal < YInicial                                  // de coordenadas: X iniciais
                    then begin                                            // maiores, iguais ou menores que
                         Rectangle(XInicial,YFinal,XFinal,YInicial);      // os X finais, combinados com Y
                         telaInterface(24);                               // iniciais maiores, iguais ou
                         end                                              // menores que os Y finais, de
                    else begin                                            // forma que: ou a chamada seja
                         Line(XInicial,YInicial,XFinal,YFinal);           // sempre feita na ordem certa, ou
                         telaInterface(24);                               // uma linha seja desenhada, ou um
                         end;                                             // ponto apenas seja desenhado.
                    end;                                                  //
               end                                                        //
          else if XFinal < XInicial                                       //
               then begin                                                 //
                    if YFinal > YInicial                                  //
                    then begin                                            //
                         Rectangle(XFinal,YInicial,XInicial,YFinal);      //
                         telaInterface(24);                               //
                         end                                              //
                    else begin                                            //
                         if YFinal < YInicial                             //
                         then begin                                       //
                              Rectangle(XFinal,YFinal,XInicial,YInicial); //
                              telaInterface(24);                          //
                              end                                         //
                         else begin                                       //
                              Line(XInicial,YInicial,XFinal,YFinal);      //
                              telaInterface(24);                          //
                              end;                                        //
                         end;                                             //
                    end                                                   //
               else begin                                                 //
                    if YFinal <> YInicial                                 //
                    then begin                                            //
                         Line(XInicial,YInicial,XFinal,YFinal);           //
                         telaInterface(24);                               //
                         end                                              //
                    else begin                                            //
                         PutPixel(XInicial,YInicial,cor);                 //
                         telaInterface(24);                               //
                         end;                                             //
                    end;                                                  //
          end                                                             //
     else begin
          PutPixel(XInicial,YInicial,bufferCursorponto);                  // Ponto inicial apagado em
          telaInterface(18);                                              // caso de cancelamento.
          end;
     end
else telaInterface(18);
end;

procedure DesenhaElipse(Largura,Altura:integer; cor:byte);
var XInicial,YInicial,XFinal,YFinal:integer;
    XCentral,YCentral,XRaio,YRaio:integer;
    bufferCursorponto:byte;
    ifPonto1,ifPonto2:boolean;
begin
XInicial:=0;
YInicial:=0;
ifPonto1:=Cursor(XInicial,YInicial,Largura,Altura,cor);
XFinal:=XInicial;
YFinal:=YInicial;
if ifPonto1
then begin
     bufferCursorponto:=GetPixel(XInicial,YInicial);
     PutPixel(XInicial,YInicial,cor);
     telaInterface(20);
     ifPonto2:=Cursor(XFinal,YFinal,Largura,Altura,cor);
     if ifPonto2
     then begin
          XCentral:=(XInicial + XFinal) div 2;            // A chamada Ellipse da Graph
          YCentral:=(YInicial + YFinal) div 2;            // recebe um ponto central e dois
          XRaio:=XCentral - XInicial;                     // raios (horizontal e vertical).
          YRaio:=YCentral - YInicial;                     // Como a entrada do usuário
          if XRaio < 0                                    // corresponde a dois pontos
          then XRaio:=(XRaio - (2 * XRaio));              // que marcam um retângulo
          if YRaio < 0                                    // imaginário dentro do qual
          then YRaio:=(YRaio - (2 * YRaio));              // será desenhada a elipse,
          Ellipse(XCentral,YCentral,0,360,XRaio,YRaio);   // o ponto central deve ser
          telaInterface(22);                              // calculado como o ponto médio
          end                                             // entre os dois pontos dados,
                                                          // e os raios como as distâncias
                                                          // X e Y entre esse ponto central
                                                          // e um dos outros dois (nessa
                                                          // implementação, usamos o inicial).
     else begin
          telaInterface(18);
          end;
     PutPixel(XInicial,YInicial,bufferCursorponto);       // Ponto inicial apagado - não faz parte da elipse.
     end
else telaInterface(18);
end;

function ObtemCor(Largura,Altura:integer; cor:byte):byte;
var XInicial,YInicial:integer;
    ifPonto1:boolean;
begin
XInicial:=0;
YInicial:=0;
ifPonto1:=Cursor(XInicial,YInicial,Largura,Altura,0);
if ifPonto1
then begin
     ObtemCor:=GetPixel(XInicial,YInicial);
     telaInterface(25);
     end
else begin
     ObtemCor:=cor;
     telaInterface(18);
     end;
end;

procedure DesenhaVariasLinhas(Largura,Altura:integer; cor:byte);
var XInicial,YInicial,XFinal,YFinal:integer;
    bufferCursorponto:byte;
    ifPonto1,ifPonto2:boolean;
begin
XInicial:=0;
YInicial:=0;
ifPonto1:=Cursor(XInicial,YInicial,Largura,Altura,cor);
XFinal:=XInicial;
YFinal:=YInicial;
if ifPonto1
then begin
     bufferCursorponto:=GetPixel(XInicial,YInicial);
     PutPixel(XInicial,YInicial,cor);
     telaInterface(17);
     ifPonto2:=Cursor(XFinal,YFinal,Largura,Altura,cor);
     if ifPonto2
     then begin
          repeat Line(XInicial,YInicial,XFinal,YFinal);               // Segue obtendo pontos
                 telaInterface(17);                                   // e desenhando linhas
                 XInicial:=XFinal;                                    // entre os dois mais
                 YInicial:=YFinal;                                    // recentes até que o
                 ifPonto2:=Cursor(XFinal,YFinal,Largura,Altura,cor);  // usuário interrompa
          until ifPonto2=false;                                       // a Function Cursor.
          telaInterface(23);
          end
     else begin
          PutPixel(XInicial,YInicial,bufferCursorponto);
          telaInterface(18);
          end;
     end
else begin
     telaInterface(18);
     end;
end;

procedure Preenche(Largura,Altura:integer; cor:byte);
var XInicial,YInicial:integer;
    ifPonto1:boolean;
    CorArea:word;
    CorPreenchimento:word;
begin
XInicial:=0;
YInicial:=0;
CorPreenchimento:=cor;
ifPonto1:=Cursor(XInicial,YInicial,Largura,Altura,cor);
if ifPonto1
then begin
     CorArea:=GetPixel(XInicial,YInicial);
     telaInterface(30);
     if CorArea <> CorPreenchimento                              // Caso a área deva ser pintada,
     then Fill(XInicial,YInicial,Largura,Altura,cor,CorArea,0);  // chamada para a Fill.
     telaInterface(28);
     repeat                                                      // Aguarda "Enter", já que o procedimento
     until readkey = #13;                                        // é longo, para tentar inibir entradas
     telaInterface(99);                                          // indesejadas no teclado antes do final.
     end
else begin
     telaInterface(18);
     end;
end;

procedure Fill(XLocal,YLocal:integer; Largura,Altura:integer; cor:byte; CorArea:word; QuemChamou:byte);
{QuemChamou:
 0 - Central
 1 - Esquerda
 2 - Acima
 3 - Direita
 4 - Abaixo}
begin
if CorArea = GetPixel(XLocal,YLocal)
then begin
     PutPixel(XLocal,YLocal,cor);                                // Se estiver na área de preenchimento, pinta o pixel

     if ((XLocal - 1) >= 0) and (QuemChamou <> 1)                // Se não foi chamado pelo pixel à sua esquerda,
     then Fill(XLocal - 1,YLocal,Largura,Altura,cor,CorArea,3);  // chama para o pixel em relação ao qual ele está
                                                                 // à direita (ou seja, chama à sua esquerda).

     if ((YLocal - 1) >= 0) and (QuemChamou <> 2)                // Se não foi chamado pelo pixel logo acima,
     then Fill(XLocal,YLocal - 1,Largura,Altura,cor,CorArea,4);  // chama para o pixel em relação ao qual ele está
                                                                 // abaixo (ou seja, chama acima).

     if ((XLocal + 1) < Largura) and (QuemChamou <> 3)           // Se não foi chamado pelo pixel à sua direita,
     then Fill(XLocal + 1,YLocal,Largura,Altura,cor,CorArea,1);  // chama para o pixel em relação ao qual ele está
                                                                 // à esquerda (ou seja, chama à sua direita).

     if ((YLocal + 1) < Altura) and (QuemChamou <> 4)            // Se não foi chamado pelo pixel logo abaixo,
     then Fill(XLocal,YLocal + 1,Largura,Altura,cor,CorArea,2);  // chama para o pixel em relação ao qual ele está
     end;                                                        // acima (ou seja, chama abaixo).

end;

procedure lapis(Largura,Altura:integer; cor:byte);
var x,y:integer;
    ifPonto:boolean;
begin
telaInterface(34);
x:=0;
y:=0;
ifPonto:=Cursor(x,y,Largura,Altura,cor);
if ifPonto
   then repeat PutPixel(x,y,cor);                       // Segue marcando os pontos
               ifPonto:=Cursor(x,y,Largura,Altura,cor); // até que o usuário
               until ifPonto=false                      // interrompa a function
   else telaInterface(18);                              // Cursor
end;

function CursorBorracha(var XCursor:integer; var YCursor:integer; Largura,Altura:integer;
                        var bufferCursorBorracha:tipobufferBorracha):boolean;
var sair:boolean;
    Tecla:char;
    PosicaoX,PosicaoY,CounterX,CounterY:integer;
begin
sair:=false;
PosicaoX:=XCursor;
PosicaoY:=YCursor;
while sair=false do
      begin
      acendeCursorBorracha(PosicaoX,PosicaoY,bufferCursorBorracha,Largura,Altura);
      Tecla:=readkey;
      case Tecla of
           #0     : begin {Tecla de Função}
                    Tecla:=readkey;
                    case Tecla of           // Movimentação das setas
                         #72 : begin
                               apagaCursorBorracha(PosicaoX,PosicaoY,bufferCursorBorracha,Largura,Altura);
                               if PosicaoY > 19
                               then PosicaoY:=PosicaoY - 17
                               else PosicaoY:=0;
                               end;
                         #75 : begin
                               apagaCursorBorracha(PosicaoX,PosicaoY,bufferCursorBorracha,Largura,Altura);
                               if PosicaoX > 19
                               then PosicaoX:=PosicaoX - 17
                               else PosicaoX:=0;
                               end;
                         #77 : begin
                               apagaCursorBorracha(PosicaoX,PosicaoY,bufferCursorBorracha,Largura,Altura);
                               if PosicaoX < (Largura - 20)
                               then PosicaoX:=PosicaoX + 17
                               else PosicaoX:=Largura - 1;
                               end;
                         #80 : begin
                               apagaCursorBorracha(PosicaoX,PosicaoY,bufferCursorBorracha,Largura,Altura);
                               if PosicaoY < (Altura - 20)
                               then PosicaoY:=PosicaoY + 17
                               else PosicaoY:=Altura - 1;
                               end;
                         else begin         // Escolha cancelada
                              sair:=true;
                              CursorBorracha:=false;
                              apagaCursorBorracha(PosicaoX,PosicaoY,bufferCursorBorracha,Largura,Altura);
                              end;
                         end; {case interno}
                    end;
           #13    : begin                   // Enter confirma ponto selecionado
                    for CounterX:=-8 to 8 do                            //preenche o buffer com 15,
                        for CounterY:=-8 to 8 do                        //"apagando" o fundo para a
                            bufferCursorBorracha[CounterX,CounterY]:=15;//próxima chamada de acendeCursorBorracha
                    sair:=true;
                    CursorBorracha:=true;
                    apagaCursorBorracha(PosicaoX,PosicaoY,bufferCursorBorracha,Largura,Altura);
                    end;
           'w','W': begin                   // Movimentação com W, A, S, D (precisão)
                    apagaCursorBorracha(PosicaoX,PosicaoY,bufferCursorBorracha,Largura,Altura);
                    if PosicaoY > 0
                    then PosicaoY:=PosicaoY - 1;
                    end;
           'a','A': begin
                    apagaCursorBorracha(PosicaoX,PosicaoY,bufferCursorBorracha,Largura,Altura);
                    if PosicaoX > 0
                    then PosicaoX:=PosicaoX - 1;
                    end;
           'd','D': begin
                    apagaCursorBorracha(PosicaoX,PosicaoY,bufferCursorBorracha,Largura,Altura);
                    if PosicaoX < (Largura - 1)
                    then PosicaoX:=PosicaoX + 1;
                    end;
           's','S': begin
                    apagaCursorBorracha(PosicaoX,PosicaoY,bufferCursorBorracha,Largura,Altura);
                    if PosicaoY < (Altura - 1)
                    then PosicaoY:=PosicaoY + 1;
                    end;
           else begin                       // Escolha cancelada
                sair:=true;
                CursorBorracha:=false;
                apagaCursorBorracha(PosicaoX,PosicaoY,bufferCursorBorracha,Largura,Altura);
                end;
           end; {case externo}
      end;
XCursor:=PosicaoX;
YCursor:=PosicaoY;
end;

procedure acendeCursorBorracha(XCentral,YCentral:integer;var bufferCursorBorracha:tipobufferBorracha;
                               Largura,Altura:integer);
var counterX,counterY:integer;
    XAtual,YAtual:integer;
    pixel:word;
begin

{Salva buffer de fundo do cursor}
for counterY:=-8 to 8 do
    begin
    YAtual:=YCentral + counterY;
    for counterX:=-8 to 8 do
        begin
        XAtual:=XCentral + counterX;
        if (Xatual >= 0) and
           (YAtual >= 0) and
           (XAtual < Largura) and
           (YAtual < Altura)
        then bufferCursorBorracha[counterX,counterY]:=GetPixel(XAtual,YAtual)
        else bufferCursorBorracha[counterX,counterY]:=0;
        end;
    end;

{Desenha cursor}
for counterY:=-8 to 8 do
    begin
    YAtual:=YCentral + counterY;
    for counterX:=-8 to 8 do
        begin
        XAtual:=XCentral + counterX;
        if (Xatual >= 0) and
           (YAtual >= 0) and
           (XAtual < Largura) and
           (YAtual < Altura)
        then begin
             if((XAtual = XCentral - 8)or(XAtual = XCentral + 8)or(YAtual = YCentral - 8)or(YAtual = YCentral + 8))
                then pixel:=0
                else pixel:=15;
             PutPixel(XAtual,YAtual,pixel);
             end;
        end;
    end;
end;

procedure apagaCursorBorracha(XCentral,YCentral:integer;bufferCursorBorracha:tipobufferBorracha;
                              Largura,Altura:integer);
var counterX,counterY:integer;
    XAtual,YAtual:integer;
begin

{Carrega buffer e apaga cursor}
for counterY:=-8 to 8 do
    begin
    YAtual:=YCentral + counterY;
    for counterX:=-8 to 8 do
        begin
        XAtual:=XCentral + counterX;
        if (Xatual >= 0) and
           (YAtual >= 0) and
           (XAtual < Largura) and
           (YAtual < Altura)
        then PutPixel(XAtual,YAtual,bufferCursorBorracha[counterX,counterY]);
        end;
    end;
end;

procedure borracha(Largura,Altura:integer);
var x,y,CounterX,CounterY:integer;
    ifBorracha:boolean;
    bufferCursorBorracha:tipobufferBorracha;
begin
x:=10;
y:=10;
for CounterX:=-8 to 8 do
    for CounterY:=-8 to 8 do        //inicialização do buffer
        bufferCursorBorracha[CounterX,CounterY]:=getPixel(CounterX + x,CounterY + y);
telaInterface(35);
ifBorracha:=CursorBorracha(x,y,Largura,Altura,bufferCursorBorracha);
if ifBorracha
   then repeat
   for CounterX:=-8 to 8 do
                        for CounterY:=-8 to 8 do
                            bufferCursorBorracha[CounterX,CounterY]:=15;
        ifBorracha:=CursorBorracha(x,y,Largura,Altura,bufferCursorBorracha);
        until ifBorracha=false;
telaInterface(18);
end;

end.
