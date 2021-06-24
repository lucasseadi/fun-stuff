/* Hockey.cpp
*  por Lucas Seadi e Tobias Petry
*  Junho 2007
*
*  Baseado em:
*
*  Camera.cpp
*  abril, 2002 - Luciana Nedel
*  adaptado por Carla Freitas
*
*  Exemplo para manipulação de câmera em OpenGL
*/

#include <gl/glut.h>
#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include <iostream.h>
#include "bitmap.h"


#define PI 3.1415926535898
//#define GL_AMBIENT (1,1,1,0.5)
//#define GL_SPECULAR (1,1,1,0)



// parte de código extraído de "texture.c" por Michael Sweet (OpenGL SuperBible)
int j;                       /* Looping var */
BITMAPINFO	*info;           /* Bitmap information */
GLubyte	    *bits;           /* Bitmap RGB pixels */
GLubyte     *ptr;            /* Pointer into bit buffer */
GLubyte	    *rgba;           /* RGBA pixel buffer */
GLubyte	    *rgbaptr;        /* Pointer into RGBA buffer */
GLubyte     temp;            /* Swapping variable */
GLenum      type;            /* Texture type */
GLuint      texture;         /* Texture object */

bool inicializaTextura(void)
{ 
    // Load a texture object (256x256 true color) 
    bits = LoadDIBitmap("textura.bmp", &info);
    if (bits == (GLubyte *)0)
        return (false);
   
    // Figure out the type of texture
    if (info->bmiHeader.biHeight == 1)
      type = GL_TEXTURE_1D;
    else
      type = GL_TEXTURE_2D;

    // Create and bind a texture object 
    glGenTextures(1, &texture);
	glBindTexture(type, texture);

    // Set texture parameters 
    glTexParameteri(type, GL_TEXTURE_MAG_FILTER, GL_NEAREST);
    glTexParameteri(type, GL_TEXTURE_MIN_FILTER, GL_LINEAR);
    glTexParameteri(type, GL_TEXTURE_WRAP_S, GL_CLAMP);
    glTexParameteri(type, GL_TEXTURE_WRAP_T, GL_CLAMP);    
     
    // Create an RGBA image
    rgba = (GLubyte *)malloc(info->bmiHeader.biWidth * info->bmiHeader.biHeight * 4);
    
    j = info->bmiHeader.biWidth * info->bmiHeader.biHeight;
    for( rgbaptr = rgba, ptr = bits;  j > 0; j--, rgbaptr += 4, ptr += 3)
    {
            rgbaptr[0] = ptr[2];     // windows BMP = BGR 
            rgbaptr[1] = ptr[1];
            rgbaptr[2] = ptr[0];
            rgbaptr[3] = (ptr[0] + ptr[1] + ptr[2]) / 3;            
    }

    glTexImage2D(type, 0, 4, info->bmiHeader.biWidth, info->bmiHeader.biHeight, 
                  0, GL_RGBA, GL_UNSIGNED_BYTE, rgba );   
 
    return (true);
}  


GLfloat borda[]= { 1.0, 0.0, 0.0, 1.0 };
GLfloat campo[]= { 0.0, 0.0, 1.0, 1.0 };


int Janela1,Janela2,Janela3,Janela4;

double MovX = 0,MovY = -15.0;
double MovXAnterior = 0,MovYAnterior = -15.0;
double AdvX = 0,AdvY = 15.0;
double AdvXAnterior = 0,AdvYAnterior = 15.0;

int GolsJogador = 0;
int GolsComputador = 0;

double xDisco,zDisco = 0.0;
double velocidade = 0.0, direcaoX = 0.0, direcaoZ = 0.0;

// Estrutura que define os parâmetros da câmera

typedef struct camera {
        GLdouble atx;
        GLdouble aty;
        GLdouble atz;
        GLdouble tox;
        GLdouble toy;
        GLdouble toz;
} Observador;

Observador Camera1,Camera2, Camera3;

// Parametros de projeção
GLfloat fAspect;
GLfloat angle = 60;    // angulo de abertura para proj. perspectiva

// limites do volume ortográfico
GLdouble minX=-100.00;
GLdouble maxX=100.00;
GLdouble minY=-100.00;
GLdouble maxY=100.00;
GLint incremento=0;

// planos near e far para recorte em profundidade
GLdouble near_plane= 2.0;
GLdouble far_plane=240.0;
 
GLfloat mat_specular[] = {1.0, 1.0, 1.0, 1.0 };
GLfloat mat_shininess[] = { 200.0 };
GLfloat light_position[] = { 0.0, 16.0, 0.0, 1.0 };
GLfloat light_position2[] = { 0.0, 50.0, 30.0, 1.0 };
GLfloat light_position3[] = { 0.0, 50.0, -110.0, 1.0 };

GLfloat direcao[] = { 0.0, -1.0, 0.0 };
GLfloat luzDifusa[4]={0.1,0.1,0.1,1.0};		 // "cor" 
GLfloat luzAmbiente[4]={1.0,1.0,1.0,1.0}; 

void init(void)
{

/*    glShadeModel(GL_SMOOTH);
 	glMaterialfv(GL_FRONT, GL_SPECULAR, mat_specular);
	glMaterialfv(GL_FRONT, GL_AMBIENT, mat_shininess);
	
        
    glLightfv(GL_LIGHT0, GL_POSITION, light_position );
	glLightfv(GL_LIGHT0, GL_DIFFUSE, luzDifusa );
	glLightfv(GL_LIGHT0, GL_SPECULAR, mat_specular );
	glLightfv(GL_LIGHT0, GL_SPOT_DIRECTION, direcao );
	glEnable(GL_LIGHT0);
	
    glLightfv(GL_LIGHT1, GL_POSITION, light_position2 );
	glLightfv(GL_LIGHT1, GL_DIFFUSE, luzDifusa );
	glLightfv(GL_LIGHT1, GL_SPECULAR, mat_specular );
	glLightfv(GL_LIGHT1, GL_SPOT_DIRECTION, direcao );
	glEnable(GL_LIGHT1);
    
    glLightfv(GL_LIGHT2, GL_POSITION, light_position3 );
	glLightfv(GL_LIGHT2, GL_DIFFUSE, luzDifusa );
	glLightfv(GL_LIGHT2, GL_SPECULAR, mat_specular );
	glLightfv(GL_LIGHT2, GL_SPOT_DIRECTION, direcao );
	glEnable(GL_LIGHT2);

	glMateriali(GL_FRONT,GL_SHININESS,128);


    glEnable(GL_COLOR_MATERIAL);
    glColorMaterial(GL_FRONT, GL_AMBIENT_AND_DIFFUSE);


	glLightf(GL_LIGHT0, GL_CONSTANT_ATTENUATION, 1.0);
 	glEnable(GL_LIGHTING);
	glEnable(GL_DEPTH_TEST); */
	
	
	    if (!inicializaTextura()) {
       printf ("Problemas na abertura da textura!");
       cin >> texture;
       exit(0);
    }
	
}

// Inicialização
void SetupRC(void)
{
 
    // Especifica a cor de fundo da janela
	glClearColor(0.5f, 0.5f, 0.5f, 1.0f);
    // Limpa a janela e habilita o teste para eliminar faces posteriores
	glClear(GL_COLOR_BUFFER_BIT |GL_DEPTH_BUFFER_BIT);
    glEnable(GL_DEPTH_TEST);
	// habilita o uso de uma cor por face
    //glShadeModel (GL_FLAT); 
    
    // inicializa câmera    
    Camera1.atx=0.0;
    Camera1.aty=35.0;
    Camera1.atz=-50.0;
    Camera1.tox=0.0;
    Camera1.toy=20.0;
    Camera1.toz=0.0;

    Camera2.atx=0.0;
    Camera2.aty=45.0;
    Camera2.atz=-1.0;
    Camera2.tox=0.0;
    Camera2.toy=20.0;
    Camera2.toz=0.0;

    Camera3.atx=xDisco;
    Camera3.aty=16.0;
    Camera3.atz=zDisco - 1.5;
    Camera3.tox=xDisco;
    Camera3.toy=15.0;
    Camera3.toz=25.0;
    
}


/* Função usada para especificar o volume de visualização
*  no caso de projeção perspectiva
*/  
void PerspectiveViewing(void)
{
	// Especifica manipulacao da matriz de projeção
	glMatrixMode(GL_PROJECTION);
	// Inicializa matriz com a identidade
	glLoadIdentity();
 
    // Especifica a projeção perspectiva
     gluPerspective(angle,fAspect,0.1,500);
     
        
     
   //  gluPerspective(angle,fAspect,near_plane,far_plane);
     
    // Especifica sistema de coordenadas do modelo
	glMatrixMode(GL_MODELVIEW);
	// Inicializa matriz modelview com a identidade
	glLoadIdentity();
	// Especifica posição do observador e do alvo
	gluLookAt (Camera1.atx,Camera1.aty,Camera1.atz,Camera1.tox,Camera1.toy,Camera1.toz, 0,1,0);

}

void BolaViewing(void)
{
	// Especifica manipulacao da matriz de projeção
	glMatrixMode(GL_PROJECTION);
	// Inicializa matriz com a identidade
	glLoadIdentity();
 
    // Especifica a projeção perspectiva
     gluPerspective(angle,fAspect,0.1,500);
     
        
     
   //  gluPerspective(angle,fAspect,near_plane,far_plane);
     
    // Especifica sistema de coordenadas do modelo
	glMatrixMode(GL_MODELVIEW);
	// Inicializa matriz modelview com a identidade
	glLoadIdentity();
	// Especifica posição do observador e do alvo
	gluLookAt (xDisco,Camera3.aty,zDisco - 1.5,xDisco,Camera3.toy,Camera3.toz, 0,1,0);

}


/* Função usada para especificar o volume de visualização
*  no caso de projeção perspectiva
*/  
void OrthoViewing(void)
{
	 // Especifica sistema de coordenadas do modelo
	glMatrixMode(GL_MODELVIEW);
	// Inicializa matriz modelview com a identidade
	glLoadIdentity();
	// Especifica posição do observador e do alvo
	gluLookAt (Camera2.atx,Camera2.aty,Camera2.atz,Camera2.tox,Camera2.toy,Camera2.toz, 0,1,0);
 
    // Especifica manipulacao da matriz de projeção
	glMatrixMode(GL_PROJECTION);
	// Inicializa matriz com a identidade
	glLoadIdentity();
 
    // Especifica a projeção ortográfica
    
    glOrtho(-45,
            45,
            -30,
            30,
            0,40);
        
    glMatrixMode(GL_MODELVIEW);
}
// Chamada pela GLUT quando a janela é redimensionada
void ChangeSize(GLsizei w, GLsizei h)
{
	// Para prevenir uma divisão por zero
	if ( h == 0 )
		h = 1;

	// Especifica o tamanho da viewport
	glViewport(0, 0, w, h);
            
	// Calcula a correção de aspecto
	fAspect = (GLfloat)w/(GLfloat)h;

        PerspectiveViewing();
}


void ChangeSize2(GLsizei w, GLsizei h)
{
	// Para prevenir uma divisão por zero
	if ( h == 0 )
		h = 1;
	// Especifica o tamanho da viewport
	glViewport(0, 0, w, h);
	// Calcula a correção de aspecto
	fAspect = (GLfloat)w/(GLfloat)h;
        OrthoViewing();
}

void ChangeSize3(GLsizei w, GLsizei h)
{
	// Para prevenir uma divisão por zero
	if ( h == 0 )
		h = 1;
	// Especifica o tamanho da viewport
	glViewport(0, 0, w, h);
	// Calcula a correção de aspecto
	fAspect = (GLfloat)w/(GLfloat)h;
        BolaViewing();
}

// Minha função de desenho
void RenderScene(void)
{
    glutSetCursor(GLUT_CURSOR_NONE);
	// Limpa a janela
	glClear(GL_COLOR_BUFFER_BIT |GL_DEPTH_BUFFER_BIT);

    double Xpos,Zpos;
    int i;

      glEnable (type);
      glTexEnvi(type, GL_TEXTURE_ENV_MODE, GL_BLEND);             
    // face da mesa - ciano
    glBegin(GL_QUADS);
       glColor3f(0.8f, 0.8f, 1.0f);
glTexCoord2f(1.0f, 0.0f);
       glVertex3i(-20,15,-25);
glTexCoord2f(0.0f, 0.0f);
       glVertex3i(20,15,-25);
glTexCoord2f(0.0f, 1.0f);       
       glVertex3i(20,15,25);
glTexCoord2f(1.0f, 1.0f);
       glVertex3i(-20,15,25);
    glEnd();

    // borda externa da mesa
    glBegin(GL_QUADS);
       glColor3f(0.5f, 0.2f, 0.0f);
       glVertex3i(-22,15,-27);
       glVertex3i(22,15,-27);
       glVertex3i(20,17,-25);
       glVertex3i(-20,17,-25);
    glEnd();
    glBegin(GL_QUADS);
       glColor3f(0.5f, 0.2f, 0.0f);
       glVertex3i(22,15,-27);
       glVertex3i(22,15,27);
       glVertex3i(20,17,25);
       glVertex3i(20,17,-25);
    glEnd();
    glBegin(GL_QUADS);
       glColor3f(0.5f, 0.2f, 0.0f);
       glVertex3i(22,15,27);
       glVertex3i(-22,15,27);
       glVertex3i(-20,17,25);
       glVertex3i(20,17,25);
    glEnd();
    glBegin(GL_QUADS);
       glColor3f(0.5f, 0.2f, 0.0f);
       glVertex3i(-22,15,27);
       glVertex3i(-22,15,-27);
       glVertex3i(-20,17,-25);
       glVertex3i(-20,17,25);
    glEnd();
    // borda interna da mesa
    glBegin(GL_QUADS);
       glColor3f(1.0f, 0.0f, 0.0f);
       glVertex3i(-20,15,-25);
       glVertex3i(-7,15,-25);
       glVertex3i(-7,17,-25);
       glVertex3i(-20,17,-25);
    glEnd();
    glBegin(GL_QUADS); // travessão jogador
       glColor3f(1.0f, 0.0f, 0.0f);
       glVertex3i(-7,16,-25);
       glVertex3i(7,16,-25);
       glVertex3i(7,17,-25);
       glVertex3i(-7,17,-25);
    glEnd();    
    glBegin(GL_QUADS); // goleira jogador
       glColor3f(0.0f, 0.0f, 0.0f);
       glVertex3i(-7,15,-25);
       glVertex3i(7,15,-25);
       glVertex3i(7,16,-25);
       glVertex3i(-7,16,-25);
    glEnd();    
    glBegin(GL_QUADS);
       glColor3f(1.0f, 0.0f, 0.0f);
       glVertex3i(7,15,-25);
       glVertex3i(20,15,-25);
       glVertex3i(20,17,-25);
       glVertex3i(7,17,-25);
    glEnd();    
    glBegin(GL_QUADS);
       glColor3f(1.0f, 0.0f, 0.0f);
       glVertex3i(20,15,-25);
       glVertex3i(20,15,25);
       glVertex3i(20,17,25);
       glVertex3i(20,17,-25);
    glEnd();
    glBegin(GL_QUADS);
       glColor3f(1.0f, 0.0f, 0.0f);
       glVertex3i(20,15,25);
       glVertex3i(7,15,25);
       glVertex3i(7,17,25);
       glVertex3i(20,17,25);
    glEnd();
    glBegin(GL_QUADS); // travessão computador
       glColor3f(1.0f, 0.0f, 0.0f);
       glVertex3i(7,16,25);
       glVertex3i(-7,16,25);
       glVertex3i(-7,17,25);
       glVertex3i(7,17,25);
    glEnd();
    glBegin(GL_QUADS); // goleira computador
       glColor3f(0.0f, 0.0f, 0.0f);
       glVertex3i(7,15,25);
       glVertex3i(-7,15,25);
       glVertex3i(-7,16,25);
       glVertex3i(7,16,25);
    glEnd();
    glBegin(GL_QUADS);
       glColor3f(1.0f, 0.0f, 0.0f);
       glVertex3i(-7,15,25);
       glVertex3i(-20,15,25);
       glVertex3i(-20,17,25);
       glVertex3i(-7,17,25);
    glEnd();
    glBegin(GL_QUADS);
       glColor3f(1.0f, 0.0f, 0.0f);
       glVertex3i(-20,15,25);
       glVertex3i(-20,15,-25);
       glVertex3i(-20,17,-25);
       glVertex3i(-20,17,25);
    glEnd();
    // base da mesa
    glBegin(GL_QUADS);
       glColor3f(0.8f, 0.8f, 0.8f);
       glVertex3i(-21,0,-26);
       glVertex3i(21,0,-26);
       glVertex3i(21,15,-26);
       glVertex3i(-21,15,-26);
    glEnd();
    glBegin(GL_QUADS);
       glColor3f(0.8f, 0.8f, 0.8f);
       glVertex3i(21,0,-26);
       glVertex3i(21,0,26);
       glVertex3i(21,15,26);
       glVertex3i(21,15,-26);
    glEnd();
    glBegin(GL_QUADS);
       glColor3f(0.8f, 0.8f, 0.8f);
       glVertex3i(21,0,26);
       glVertex3i(-21,0,26);
       glVertex3i(-21,15,26);
       glVertex3i(21,15,26);
    glEnd();
    glBegin(GL_QUADS);
       glColor3f(0.8f, 0.8f, 0.8f);
       glVertex3i(-21,0,26);
       glVertex3i(-21,0,-26);
       glVertex3i(-21,15,-26);
       glVertex3i(-21,15,26);
    glEnd();

    // disco
    glBegin(GL_TRIANGLE_FAN);
       glColor3f(0.0f,0.0f,0.0f);
       glVertex3f(xDisco,15.5f,zDisco);
       for (i = 0; i < 11; i++)
       {Xpos = (1.5 * sin((2 * PI * i) / 10));
        Zpos = (1.5 * cos((2 * PI * i) / 10));
        glVertex3f(Xpos + xDisco,15.5f,Zpos + zDisco);
       }
    glEnd();
    glBegin(GL_QUAD_STRIP);
       glColor3f(1.0f,0.5f,0.0f);
       for (i = 0; i < 11; i++)
       {Xpos = (1.5 * sin((2 * PI * i) / 10));
        Zpos = (1.5 * cos((2 * PI * i) / 10));
        glVertex3f(Xpos + xDisco,15.5f,Zpos + zDisco);
        glVertex3f(Xpos + xDisco,15.0f,Zpos + zDisco);
       }
    glEnd();

    // batedor adversario
    glBegin(GL_QUAD_STRIP);
       glColor3f(0.0f,0.5f,0.0f);
       for (i = 0; i < 13; i++)
       {Xpos = (2.5 * sin((2 * PI * i) / 12));
        Zpos = (2.5 * cos((2 * PI * i) / 12));
        glVertex3f(AdvX + Xpos,16.0f,AdvY + Zpos);
        glVertex3f(AdvX + Xpos,15.0f,AdvY + Zpos);
       }
    glEnd();
    glBegin(GL_TRIANGLE_FAN);
       glColor3f(0.0f,0.5f,0.0f);
       glVertex3f(AdvX,16.0f,AdvY);
       for (i = 0; i < 13; i++)
       {Xpos = (2.5 * sin((2 * PI * i) / 12));
        Zpos = (2.5 * cos((2 * PI * i) / 12));
        glVertex3f(AdvX + Xpos,15.5f,AdvY + Zpos);
       }
    glEnd();
    glBegin(GL_QUAD_STRIP);
       glColor3f(0.0f,0.5f,0.0f);
       for (i = 0; i < 13; i++)
       {Xpos = (1 * sin((2 * PI * i) / 12));
        Zpos = (1 * cos((2 * PI * i) / 12));
        glVertex3f(AdvX + Xpos,18.0f,AdvY + Zpos);
        glVertex3f(AdvX + Xpos,16.0f,AdvY + Zpos);
       }
    glEnd();
 
    // batedor jogador
    glBegin(GL_QUAD_STRIP);
       glColor3f(0.0f,0.0f,1.0f);
       for (i = 0; i < 13; i++)
       {Xpos = (2.5 * sin((2 * PI * i) / 12));
        Zpos = (2.5 * cos((2 * PI * i) / 12));
        glVertex3f(MovX + Xpos,16.0f,MovY + Zpos);
        glVertex3f(MovX + Xpos,15.0f,MovY + Zpos);
       }
    glEnd();
    glBegin(GL_TRIANGLE_FAN);
       glColor3f(0.0f,0.0f,0.5f);
       glVertex3f(MovX,16.0f,MovY);
       for (i = 0; i < 13; i++)
       {Xpos = (2.5 * sin((2 * PI * i) / 12));
        Zpos = (2.5 * cos((2 * PI * i) / 12));
        glVertex3f(MovX + Xpos,15.5f,MovY + Zpos);
       }
    glEnd();
    glBegin(GL_QUAD_STRIP);
       glColor3f(0.0f,0.0f,1.0f);
       for (i = 0; i < 13; i++)
       {Xpos = (1 * sin((2 * PI * i) / 12));
        Zpos = (1 * cos((2 * PI * i) / 12));
        glVertex3f(MovX + Xpos,18.0f,MovY + Zpos);
        glVertex3f(MovX + Xpos,16.0f,MovY + Zpos);
       }
    glEnd();
    
    glutSwapBuffers();    

}

void RenderScene2(void)
{
glClear(GL_COLOR_BUFFER_BIT |GL_DEPTH_BUFFER_BIT);// | GL_MODELVIEW);

//glColor3f(1.0f,0.0f,0.0f);
//glutBitmapCharacter(GLUT_BITMAP_TIMES_ROMAN_24,49);
//GolsJogador GolsComputador

//glTranslatef(-27.0f,0.0f,0.0f);

//glutStrokeCharacter(GLUT_STROKE_ROMAN,GolsJogador + 48);
//glutPostRedisplay();
if((GolsJogador==9)|(GolsComputador==9)) {
   glutBitmapCharacter(GLUT_BITMAP_TIMES_ROMAN_24,70);//F
   glutBitmapCharacter(GLUT_BITMAP_TIMES_ROMAN_24,73);//I
   glutBitmapCharacter(GLUT_BITMAP_TIMES_ROMAN_24,77);//M
   glutBitmapCharacter(GLUT_BITMAP_TIMES_ROMAN_24,32);
   glutBitmapCharacter(GLUT_BITMAP_TIMES_ROMAN_24,68);//D
   glutBitmapCharacter(GLUT_BITMAP_TIMES_ROMAN_24,69);//E
   glutBitmapCharacter(GLUT_BITMAP_TIMES_ROMAN_24,32);
   glutBitmapCharacter(GLUT_BITMAP_TIMES_ROMAN_24,74);//J
   glutBitmapCharacter(GLUT_BITMAP_TIMES_ROMAN_24,79);//O
   glutBitmapCharacter(GLUT_BITMAP_TIMES_ROMAN_24,71);//G
   glutBitmapCharacter(GLUT_BITMAP_TIMES_ROMAN_24,79);//O
   glutBitmapCharacter(GLUT_BITMAP_TIMES_ROMAN_24,33);//!
   glutBitmapCharacter(GLUT_BITMAP_TIMES_ROMAN_24,40);//(
   glutBitmapCharacter(GLUT_BITMAP_TIMES_ROMAN_24,GolsJogador + 48);
   glutBitmapCharacter(GLUT_BITMAP_TIMES_ROMAN_24,120);//x
   glutBitmapCharacter(GLUT_BITMAP_TIMES_ROMAN_24,GolsComputador + 48);
   glutBitmapCharacter(GLUT_BITMAP_TIMES_ROMAN_24,41);//)
  
}
else {
     glutBitmapCharacter(GLUT_BITMAP_TIMES_ROMAN_24,GolsJogador + 48);
     glutBitmapCharacter(GLUT_BITMAP_TIMES_ROMAN_24,120);
     glutBitmapCharacter(GLUT_BITMAP_TIMES_ROMAN_24,GolsComputador + 48);
     }

glutSwapBuffers();
     
}


/* Minha Callback para gerenciar eventos do mouse
 * Devolve o botão pressionado, o estado do botão e
 * posição do cursor, relativa à janela.
*/
// A especificação da GLUT traz os demais detalhes desse tratamento
 
void BatedorJogador(int x, int y)
{
    MovXAnterior = MovX;
    MovYAnterior = MovY;
    MovX = -(x/5) + 40;
    MovY = -(y/6) + 25;
    if (MovX < -17.5)
    {MovX = -17.5;}
    if (MovX > 17.5)
    {MovX = 17.5;}
    if (MovY < -22.5)
    {MovY = -22.5;}
    if (MovY > -2.5)
    {MovY = -2.5;}
}

// Especifica callback comum de teclado     
void KeyboardFunc ( unsigned char key, int x, int y )
{
     if((key == 'H')|(key=='h')){
       printf("\n");
       printf("      AIR HOCKEY\n");
       printf("Mova o mouse em qualquer uma das janelas para movimentar o batedor.\n");
       printf("Pressione h ou H para mostrar o Help ;).\n");
       printf("End para sair.\n");
       //printf("O placar e exibido neste console.\n");
       }
}
void specialkeys( int key, int x, int y )
{
if(key == GLUT_KEY_END)
exit(0);
}



void idle()
{
static double tempoanterior = 0.0;
double tempo;
double tempopassado,incrementoVelocidade;
    
    //tempo dado em milisegundos, convertido para segundos
    tempo = glutGet(GLUT_ELAPSED_TIME) / 1000.0;
    
    tempopassado = tempo - tempoanterior;   
    
    if ( tempopassado > 0.01)
    {
    if (velocidade > 0)
       velocidade-=velocidade/100.0;
    else velocidade=0;
       xDisco+=direcaoX*velocidade;    
       zDisco+=direcaoZ*velocidade;    
       tempoanterior = tempo;  //reseta contador de tempo
       }

// comportamento do batedor adversário
AdvXAnterior = AdvX;
AdvYAnterior = AdvY;

if (zDisco < 0)
     {if (AdvY > 23)
           AdvY -= 0.4;
      if (AdvY < 23)
           AdvY += 0.4;
      if (AdvX < -7)
           AdvX += 0.4;
      else {if (AdvX > 7)
                 AdvX -= 0.4;
            else {if (AdvX < xDisco)
                       AdvX += 0.4;
                  if (AdvX > xDisco)
                       AdvX -= 0.4;
                  }
            }
      }
else {if (AdvX < xDisco)
           AdvX += 0.4;
      if (AdvX > xDisco)
           AdvX -= 0.4;
      if (AdvY > (zDisco + 4))
           {if (velocidade < 2.5)
                AdvY -= 0.2;}
      else {if (AdvY < zDisco)
                 {AdvY += 0.4;}
            else {AdvY += 0.2;}
            }
      }
if (AdvX < -17.5)
     {AdvX = -17.5;}
if (AdvX > 17.5)
     {AdvX = 17.5;}
if (AdvY < 2.5)
     {AdvY = 2.5;}
if (AdvY > 22.5)
     {AdvY = 22.5;}

// colisão com bordas
if (xDisco < -18.5){
           xDisco=-18.5;
           if (direcaoX < 0)
                direcaoX=0 - direcaoX;
           }
if (xDisco > 18.5){
           xDisco=18.5;
           if (direcaoX > 0)
                direcaoX=0 - direcaoX;
           }
if (zDisco < -23.5){
           zDisco=-23.5;
           if (direcaoZ < 0)
                direcaoZ=0 - direcaoZ;
           if ((xDisco > -7) && (xDisco < 7)) // Gol do Computador
                {GolsComputador += 1;
                 //printf ("Jogador = %2d",GolsJogador);
                 //printf ("  Computador = %2d\n",GolsComputador);
                
                glutDestroyWindow(Janela3);
                glutInitWindowSize(550,30);
                Janela3 = glutCreateWindow("Placar?");
	            glutDisplayFunc(RenderScene2);
                glutKeyboardFunc(KeyboardFunc);
                glutSpecialFunc( specialkeys );
                glutIdleFunc(idle);	

                
                //glutSetWindow(Janela3);
                //glutPostRedisplay(); 

                
                
                 velocidade = 0;
                 xDisco = 0;
                 zDisco = 0;
                 AdvXAnterior = 0;
                 AdvYAnterior = 15.0;
                 AdvX = 0;
                 AdvY = 15.0;
                 }           
           }
if (zDisco > 23.5){
           zDisco=23.5;
           if (direcaoZ > 0)
                direcaoZ=0 - direcaoZ;
           if ((xDisco > -7) && (xDisco < 7)) // Gol do Jogador
                {GolsJogador += 1;
                 //printf ("Jogador = %2d",GolsJogador);
                 //printf ("  Computador = %2d\n",GolsComputador);
                 
                 
                glutDestroyWindow(Janela3);
                glutInitWindowSize(550,30);
                Janela3 = glutCreateWindow("Placar?");
	            glutDisplayFunc(RenderScene2);
                glutKeyboardFunc(KeyboardFunc);
                glutSpecialFunc( specialkeys );
                glutIdleFunc(idle);	



                 //glutSetWindow(Janela3);
                 //glutPostRedisplay(); 

                 
                 velocidade = 0;
                 xDisco = 0;
                 zDisco = 0;
                 AdvXAnterior = 0;
                 AdvYAnterior = 15.0;
                 AdvX = 0;
                 AdvY = 15.0;
                 }           
           }

// colisão com batedor do jogador
if ((pow(xDisco - MovX,2) + pow(zDisco - MovY,2)) <= 16) {
       velocidade += (sqrt((pow(MovX - MovXAnterior,2)) + (pow(MovY - MovYAnterior,2))) / 2);
       if ((xDisco - MovX) > 0)           
            if ((xDisco - MovX) > 1.53)    
                 if ((zDisco - MovY) > 0) 
                      if ((zDisco - MovY) > 1.53) {
                           direcaoX=0.7071;
                           direcaoZ=0.7071;}                         
                      else {direcaoX=0.9486; direcaoZ=0.3162;}                        
                 else if ((zDisco - MovY) > -1.53) {
                           direcaoX=0.9486;
                           direcaoZ=0.3162;}                
                      else {direcaoX=0.7071; direcaoZ=-0.7071;}           
            else if ((zDisco - MovY) > 0) 
                      if ((zDisco - MovY) > 1.53)          
                           {direcaoX=0.1; direcaoZ=0.9949;}                         
                      else {direcaoX=0.7071; direcaoZ=0.7071;} //central                                
                 else if ((zDisco - MovY) > -1.53)       
                           {direcaoX=0.7071; direcaoZ=-0.7071;} //central                       
                      else {direcaoX=0.1; direcaoZ=-0.9949;}                  
       else if ((xDisco - MovX) > -1.53)
                 if ((zDisco - MovY) > 0)
                      if ((zDisco - MovY) > 1.53) 
                           {direcaoX=0; direcaoZ=1;}                         
                      else {direcaoX=-0.7071; direcaoZ=0.7071;} //central
                 else if ((zDisco - MovY) > -1.53)
                           {direcaoX=-0.7071; direcaoZ=-0.7071;} //central
                      else {direcaoX=0; direcaoZ=-1;}
            else if ((zDisco - MovY) > 0)
                      if ((zDisco - MovY) > 1.53)
                           {direcaoX=-0.7071; direcaoZ=0.7071;}                         
                      else {direcaoX=-0.9486; direcaoZ=0.3162;}
                 else if ((zDisco - MovY) > -1.53)
                           {direcaoX=-0.9486; direcaoZ=0.3162;}
                      else {direcaoX=-0.7071; direcaoZ=-0.7071;}
    }
    
// colisão com batedor adversário
if ((pow(xDisco - AdvX,2) + pow(zDisco - AdvY,2)) <= 16) {
       velocidade += (sqrt((pow(AdvX - AdvXAnterior,2)) + (pow(AdvY - AdvYAnterior,2))) / 2);
       if ((xDisco - AdvX) > 0)           
            if ((xDisco - AdvX) > 1.53)    
                 if ((zDisco - AdvY) > 0) 
                      if ((zDisco - AdvY) > 1.53) {
                           direcaoX=0.7071;
                           direcaoZ=0.7071;}                         
                      else {direcaoX=0.9486; direcaoZ=-0.3162;}                        
                 else if ((zDisco - AdvY) > -1.53) {
                           direcaoX=0.9486;
                           direcaoZ=-0.3162;}                
                      else {direcaoX=0.7071; direcaoZ=-0.7071;}           
            else if ((zDisco - AdvY) > 0) 
                      if ((zDisco - AdvY) > 1.53)          
                           {direcaoX=0.1; direcaoZ=0.9949;}                         
                      else {direcaoX=0.7071; direcaoZ=0.7071;} //central                                
                 else if ((zDisco - AdvY) > -1.53)       
                           {direcaoX=0.7071; direcaoZ=-0.7071;} //central                       
                      else {direcaoX=0.1; direcaoZ=-0.9949;}                  
       else if ((xDisco - AdvX) > -1.53)
                 if ((zDisco - AdvY) > 0)
                      if ((zDisco - AdvY) > 1.53) 
                           {direcaoX=0; direcaoZ=1;}                         
                      else {direcaoX=-0.7071; direcaoZ=0.7071;} //central
                 else if ((zDisco - AdvY) > -1.53)
                           {direcaoX=-0.7071; direcaoZ=-0.7071;} //central
                      else {direcaoX=0; direcaoZ=-1;}
            else if ((zDisco - AdvY) > 0)
                      if ((zDisco - AdvY) > 1.53)
                           {direcaoX=-0.7071; direcaoZ=0.7071;}                         
                      else {direcaoX=-0.9486; direcaoZ=-0.3162;}
                 else if ((zDisco - AdvY) > -1.53)
                           {direcaoX=-0.9486; direcaoZ=-0.3162;}
                      else {direcaoX=-0.7071; direcaoZ=-0.7071;}
    }
   

if((GolsJogador==9)|(GolsComputador==9)) {
   velocidade = 0;
   xDisco = 0;
   zDisco = 0;
   AdvXAnterior = 0;
   AdvYAnterior = 15.0;
   AdvX = 0;
   AdvY = 15.0;
}
else {
     glutSetWindow(Janela1);
     glutPostRedisplay();
     glutSetWindow(Janela2);
     glutPostRedisplay();
     }
  glutSetWindow(Janela4);
  BolaViewing();
  glutPostRedisplay();
glFlush();    

}


// Programa Principal
int main(void)
{

	glutInitDisplayMode(GLUT_DOUBLE | GLUT_RGB | GLUT_DEPTH);
	
	glutInitWindowPosition(0,0);
    glutInitWindowSize(400,350);
	Janela1 = glutCreateWindow("Visão Perspectiva");
	init();
	glutDisplayFunc(RenderScene);
	glutReshapeFunc(ChangeSize);
    glutPassiveMotionFunc(BatedorJogador);
    glutKeyboardFunc(KeyboardFunc);
    glutSpecialFunc( specialkeys );
	SetupRC();
    PerspectiveViewing();

	glutInitWindowPosition(450,0);
	Janela2 = glutCreateWindow("Visão Aérea");
    init();
	glutDisplayFunc(RenderScene);
	glutReshapeFunc(ChangeSize2);
    glutPassiveMotionFunc(BatedorJogador);
    glutKeyboardFunc(KeyboardFunc);
    glutSpecialFunc( specialkeys );
	SetupRC();
	OrthoViewing();
    glutIdleFunc(idle);	

    glutInitWindowSize(550,30);
	Janela3 = glutCreateWindow("Placar?");
	glutDisplayFunc(RenderScene2);
    glutKeyboardFunc(KeyboardFunc);
    glutSpecialFunc( specialkeys );
    glutIdleFunc(idle);	

	glutInitWindowPosition(400,400);
    glutInitWindowSize(400,350);
	Janela4 = glutCreateWindow("Visão da Bola");
	init();
	glutDisplayFunc(RenderScene);
	glutReshapeFunc(ChangeSize3);
    glutKeyboardFunc(KeyboardFunc);
    glutSpecialFunc( specialkeys );
	SetupRC();
    BolaViewing();
    glutIdleFunc(idle);	

	glutMainLoop();
      return (0); 
}
