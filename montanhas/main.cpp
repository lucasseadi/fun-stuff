#include <GL/glut.h>
#include <stdlib.h>
#include <math.h>
#include <stdio.h>

float limite_inferior = -1.00f;
float limite_superior = 1.00f;

float triangulos1[16384][6];
float triangulos2[16384][6];
double interacoes = 0.0;
int qual_array = 1;

// Estrutura que define os parâmetros da câmera

typedef struct camera {
        GLdouble atx;
        GLdouble aty;
        GLdouble atz;
        GLdouble tox;
        GLdouble toy;
        GLdouble toz;
} Observador;

Observador Camera1;

// Parametros de projeção
GLfloat fAspect;
GLfloat angle = 60;    // angulo de abertura para proj. perspectiva

// limites do volume ortográfico
GLdouble minX=-100.00;
GLdouble maxX=100.00;
GLdouble minY=-100.00;
GLdouble maxY=100.00;
GLdouble incremento=0;

// planos near e far para recorte em profundidade
GLdouble near_plane= 2.0;
GLdouble far_plane=40.0;


void inicializacao() {
     triangulos1[0][0] = 0.0f;
     triangulos1[0][1] = 0.5f;
     triangulos1[0][2] = -1.0f;
     triangulos1[0][3] = -0.5f;
     triangulos1[0][4] = 1.0f;
     triangulos1[0][5] = -0.5f;

    // Especifica que a cor de fundo da janela será branca
	glClearColor(1.0f, 1.0f, 1.0f, 1.0f);
    // Limpa a janela e habilita o teste para eliminar faces posteriores
	glClear(GL_COLOR_BUFFER_BIT |GL_DEPTH_BUFFER_BIT);
    glEnable(GL_DEPTH_TEST);
	// habilita o uso de uma cor por face
    glShadeModel (GL_FLAT); 

    // inicializa câmera    
    Camera1.atx=0.0;
    Camera1.aty=1.0;
    Camera1.atz=-1.5;
    Camera1.tox=0.0;
    Camera1.toy=0.0;
    Camera1.toz=0.0;

}

void monta_triangulos() {
     limite_superior *= 0.5;
     limite_inferior *= 0.5;
     double quantidade_triangulos;
     if(interacoes == 0) {
                  quantidade_triangulos = 1;
     } else {
            quantidade_triangulos = pow(4.0,interacoes);

     }
     float p1x=0.0f, p1y=0.0f, p2x=0.0f, p2y=0.0f, p3x=0.0f, p3y=0.0f, pm1x=0.0f, pm1y=0.0f, pm2x=0.0f, pm2y=0.0f, pm3x=0.0f, pm3y=0.0f;
     int ponteiro_array = 0;
     for(int i=0; i < quantidade_triangulos; i++) {
             if(qual_array == 1) {
                          p1x = triangulos1[i][0];
                          p1y = triangulos1[i][1];
                          p2x = triangulos1[i][2];
                          p2y = triangulos1[i][3];
                          p3x = triangulos1[i][4];
                          p3y = triangulos1[i][5];
             } else {
                          p1x = triangulos2[i][0];
                          p1y = triangulos2[i][1];
                          p2x = triangulos2[i][2];
                          p2y = triangulos2[i][3];
                          p3x = triangulos2[i][4];
                          p3y = triangulos2[i][5];
             }
             pm1x = (p1x + p2x) / 2.0f;
             pm1y = (p1y + p2y) / 2.0f;
             pm1y += ((limite_superior-limite_inferior)*((float)rand()/RAND_MAX))+limite_inferior;
             pm2x = (p1x + p3x) / 2.0f;
             pm2y = (p1y + p3y) / 2.0f;
             pm2y += ((limite_superior-limite_inferior)*((float)rand()/RAND_MAX))+limite_inferior;
             pm3x = (p2x + p3x) / 2.0f;
             pm3y = (p2y + p3y) / 2.0f;
             pm1y += ((limite_superior-limite_inferior)*((float)rand()/RAND_MAX))+limite_inferior;

             if(qual_array == 1) {
             
                          triangulos2[ponteiro_array][0] = p1x;
                          triangulos2[ponteiro_array][1] = p1y;
                          triangulos2[ponteiro_array][2] = pm1x;
                          triangulos2[ponteiro_array][3] = pm1y;
                          triangulos2[ponteiro_array][4] = pm2x;
                          triangulos2[ponteiro_array][5] = pm2y;
                          ponteiro_array++;

                          triangulos2[ponteiro_array][0] = p2x;
                          triangulos2[ponteiro_array][1] = p2y;
                          triangulos2[ponteiro_array][2] = pm1x;
                          triangulos2[ponteiro_array][3] = pm1y;
                          triangulos2[ponteiro_array][4] = pm3x;
                          triangulos2[ponteiro_array][5] = pm3y;
                          ponteiro_array++;

                          triangulos2[ponteiro_array][0] = p3x;
                          triangulos2[ponteiro_array][1] = p3y;
                          triangulos2[ponteiro_array][2] = pm2x;
                          triangulos2[ponteiro_array][3] = pm2y;
                          triangulos2[ponteiro_array][4] = pm3x;
                          triangulos2[ponteiro_array][5] = pm3y;
                          ponteiro_array++;

                          triangulos2[ponteiro_array][0] = pm1x;
                          triangulos2[ponteiro_array][1] = pm1y;
                          triangulos2[ponteiro_array][2] = pm2x;
                          triangulos2[ponteiro_array][3] = pm2y;
                          triangulos2[ponteiro_array][4] = pm3x;
                          triangulos2[ponteiro_array][5] = pm3y;
                          ponteiro_array++;
                          
             } else {
                          triangulos1[ponteiro_array][0] = p1x;
                          triangulos1[ponteiro_array][1] = p1y;
                          triangulos1[ponteiro_array][2] = pm1x;
                          triangulos1[ponteiro_array][3] = pm1y;
                          triangulos1[ponteiro_array][4] = pm2x;
                          triangulos1[ponteiro_array][5] = pm2y;
                          ponteiro_array++;

                          triangulos1[ponteiro_array][0] = p2x;
                          triangulos1[ponteiro_array][1] = p2y;
                          triangulos1[ponteiro_array][2] = pm1x;
                          triangulos1[ponteiro_array][3] = pm1y;
                          triangulos1[ponteiro_array][4] = pm3x;
                          triangulos1[ponteiro_array][5] = pm3y;
                          ponteiro_array++;

                          triangulos1[ponteiro_array][0] = p3x;
                          triangulos1[ponteiro_array][1] = p3y;
                          triangulos1[ponteiro_array][2] = pm2x;
                          triangulos1[ponteiro_array][3] = pm2y;
                          triangulos1[ponteiro_array][4] = pm3x;
                          triangulos1[ponteiro_array][5] = pm3y;
                          ponteiro_array++;

                          triangulos1[ponteiro_array][0] = pm1x;
                          triangulos1[ponteiro_array][1] = pm1y;
                          triangulos1[ponteiro_array][2] = pm2x;
                          triangulos1[ponteiro_array][3] = pm2y;
                          triangulos1[ponteiro_array][4] = pm3x;
                          triangulos1[ponteiro_array][5] = pm3y;
                          ponteiro_array++;
             }
     }
}

void PerspectiveViewing(void)
{
	// Especifica manipulacao da matriz de projeção
	glMatrixMode(GL_PROJECTION);
	// Inicializa matriz com a identidade
	glLoadIdentity();
 
    // Especifica a projeção perspectiva
     gluPerspective(angle,fAspect,0.1,500);
     
    // Especifica sistema de coordenadas do modelo
	glMatrixMode(GL_MODELVIEW);
	// Inicializa matriz modelview com a identidade
	glLoadIdentity();
	// Especifica posição do observador e do alvo
	gluLookAt (Camera1.atx,Camera1.aty,Camera1.atz,Camera1.tox,Camera1.toy,Camera1.toz, 0,1,0);
}


/* GLUT callback Handlers */

void resize(GLsizei w, GLsizei h)
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


static void display(void) {

    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);

       double triangulos = 0;
       if(qual_array == 1) {
              triangulos = pow(4.0,interacoes);
              for(int i=0; i < triangulos; i++) {
                      glBegin (GL_LINES);
                      glLineWidth(2.0);
                      glColor3f(0.0f,0.0f,0.0f);
                      glVertex3f (triangulos1[i][0], triangulos1[i][1], -0.1*interacoes);
	                  glVertex3f (triangulos1[i][2], triangulos1[i][3], -0.1*(interacoes - 1));
	                  glVertex3f (triangulos1[i][4], triangulos1[i][5], -0.1*(interacoes - 1));
	                  glVertex3f (triangulos1[i][0], triangulos1[i][1], -0.1*interacoes);
	                  glEnd();
              }
       } else {
              triangulos = pow(4.0,interacoes);
              for(int i=0; i < triangulos; i++) {
                      glBegin (GL_LINES);
                      glLineWidth(2.0);
                      glColor3f(0.0f,0.0f,0.0f);
                      glVertex3f (triangulos2[i][0], triangulos2[i][1], -0.1*interacoes);
	                  glVertex3f (triangulos2[i][2], triangulos2[i][3], -0.1*(interacoes - 1));
	                  glVertex3f (triangulos2[i][4], triangulos2[i][5], -0.1*(interacoes - 1));
                      glVertex3f (triangulos2[i][0], triangulos2[i][1], -0.1*interacoes);
	                  glEnd();
              }  
       }

    glutSwapBuffers();
}

void KeyboardFunc ( unsigned char key, int x, int y )
{
     if((key == 'H')|(key=='h')){

     if(interacoes < 6) {
       monta_triangulos();
       interacoes++;
       
       if(qual_array == 1) {
                     qual_array = 2;
       } else {
              qual_array = 1;
       }
       }

       }
     if((key == 'Q')|(key=='q')){
    Camera1.atx=0.0;
    Camera1.aty=1.0;
    Camera1.atz=-1.5;
        PerspectiveViewing();
       }

     if((key == 'W')|(key=='w')){
     if(Camera1.atz > 5.0) {
        Camera1.atz = -5.0;
        } else if(Camera1.atz < -5.0) {
        Camera1.atz = 5.0;
        }
     if(Camera1.aty > 5.0) {
        Camera1.aty = -5.0;
        } else if(Camera1.aty < -5.0) {
        Camera1.aty = 5.0;
        }
     Camera1.atz+=0.1;
     Camera1.aty-=0.1;
        PerspectiveViewing();
       }

     if((key == 'S')|(key=='s')){
     if(Camera1.atz > 5.0) {
        Camera1.atz = -5.0;
        } else if(Camera1.atz < -5.0) {
        Camera1.atz = 5.0;
        }
     if(Camera1.aty > 5.0) {
        Camera1.aty = -5.0;
        } else if(Camera1.aty < -5.0) {
        Camera1.aty = 5.0;
        }
     Camera1.atz+=-0.1;
     Camera1.aty+=0.1;
        PerspectiveViewing();
       }
	if((key == 'A')|(key=='a')) {
     if(Camera1.atz > 5.0) {
        Camera1.atz = -5.0;
        } else if(Camera1.atz < -5.0) {
        Camera1.atz = 5.0;
        }
     if(Camera1.atx > 5.0) {
        Camera1.atx = -5.0;
        } else if(Camera1.atx < -5.0) {
        Camera1.atx = 5.0;
        }
     Camera1.atx+=0.1;
     Camera1.atz-=0.1;
        PerspectiveViewing();
       }
	if((key == 'D')|(key=='d')) {
     if(Camera1.atz > 5.0) {
        Camera1.atz = -5.0;
        } else if(Camera1.atz < -5.0) {
        Camera1.atz = 5.0;
        }
     if(Camera1.atx > 5.0) {
        Camera1.atx = -5.0;
        } else if(Camera1.atx < -5.0) {
        Camera1.atx = 5.0;
        }
     Camera1.atx+=-0.1;
     Camera1.atz+=0.1;
        PerspectiveViewing();
       }
    glutPostRedisplay();
}

/* Program entry point */

int main(int argc, char *argv[])
{
    glutInitWindowSize(640,480);
    glutInitWindowPosition(10,10);
    glutInitDisplayMode(GLUT_RGB | GLUT_DOUBLE | GLUT_DEPTH);
    glEnable(GL_DEPTH_TEST);

    glutCreateWindow("Montanha Fractal");
    inicializacao();

    glutReshapeFunc(resize);
    glutDisplayFunc(display);
    glutKeyboardFunc(KeyboardFunc);

    glutMainLoop();

    return (0);
}

