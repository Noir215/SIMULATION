// Problem description: //<>//
// Fuente de agua con 4 chorros de agua que se unen en un punto. //<>//
// La fuente se encuentra en el centro de la pantalla. //<>//
// Las partículas se crean en los chorros de agua. //<>//
// Las partículas se crean a una velocidad inicial aleatoria. //<>//
// Las partículas se crean a una altura aleatoria. //<>//


// Simulation and time control:

float _timeStep;        // Simulation time-step (s)
float _simTime = 0.0;   // Simulated time (s)
float _NT;


// Output control:

boolean _writeToFile = true;
boolean _useTexture = true;
PrintWriter _output;


// Variables to be monitored:

float _energy = 0;                // Total energy of the system (J)
int _numParticles;            // Total number of particles
float _ttl = 0; //tiempo total de simulación

ParticleSystem _ps, _ps2;
Particle p;
float _lastTimeDraw = 0;          // Last time the simulation was drawn (s)
float _tiempoSimulacion = 0;      // Tiempo que cuesta simular una iteración (s)

// Main code:

void settings()
{
   size(DISPLAY_SIZE_X, DISPLAY_SIZE_Y);
}

void setup()
{
   frameRate(DRAW_FREQ);
   img = loadImage(TEXTURE_FILE);
   background(BACKGROUND_COLOR[0], BACKGROUND_COLOR[1], BACKGROUND_COLOR[2]);

   _lastTimeDraw = millis(); // Last time the simulation was drawn (s)


   initSimulation();
}

void stop()
{
   endSimulation();
}

void keyPressed()
{
   if (key == 'r' || key == 'R')
      restartSimulation();
   else if (key == 't' || key == 'T')
      _useTexture = !_useTexture;
   else if (key == '+')
      _timeStep *= 1.1;
   else if (key == '-')
      _timeStep /= 1.1;
   else if (key == 'w' || key == 'W')
       _NT += 50;
   else if (key == 's' || key == 'S')
       _NT -= 50;
   else if (key == 'l' || key == 'L')
       _ttl += 1;
   else if (key == 'd' || key == 'D')
       _ttl -= 1;
}

void initSimulation()
{
   if (_writeToFile)
   {
      _output = createWriter(FILE_NAME);
      writeToFile("t, E, n, simTime");
   }

   _simTime = 0.0;
   _timeStep = TS;
   _NT = NT;
   _ttl = L;

   _ps = new ParticleSystem (new PVector(DISPLAY_SIZE_X / 2, DISPLAY_SIZE_Y / 2));
   _ps2 = new ParticleSystem (new PVector(DISPLAY_SIZE_X / 2, DISPLAY_SIZE_Y / 2));
}

void restartSimulation()
{
   frameCount = -1;
}

void endSimulation()
{
   if (_writeToFile)
   {
      _output.flush();
      _output.close();
   }
}

void draw()
{
   drawStaticEnvironment();
   drawMovingElements();

   updateSimulation();
   displayInfo();

   if (_writeToFile)
      writeToFile(_simTime + ", " + _energy + ", " + _numParticles + ", " + _tiempoSimulacion/1000.0);
}

void drawStaticEnvironment()
{
   background(BACKGROUND_COLOR[0], BACKGROUND_COLOR[1], BACKGROUND_COLOR[2]);
}

void drawMovingElements()
{   
   _ps.render(_useTexture);
   _ps2.render(_useTexture);
}

void updateSimulation()
{
      float delta = millis() - _lastTimeDraw; //comprueba si ha pasado suficiente tiempo para crear una nueva partícula.
      if(delta > 1000/NT) //(1000/NT) es el tiempo en milisegundos que debe transcurrir entre la creación de cada partícula.
      {
         _lastTimeDraw = millis(); //actualizamos el tiempo de la última partícula creada
         _ps.addParticle(m, new PVector(0, 0), new PVector(random(-60, -30), random(-60, -30)), r, color(255, 0, 0), _ttl);
         _ps.addParticle(m, new PVector(0, 0), new PVector(random(-30, 0), random(-60, -30)), r, color(255, 0, 0), _ttl);
         //_ps.addParticle(1, new PVector(0, 0), new PVector(random(20, 60), random(-60, -30)), r, color(255, 0, 0), L);
         _ps2.addParticle(m, new PVector(0, 0), new PVector(random(0, 30), random(-60, -30)), r, color(255, 0, 0), _ttl);
         _ps2.addParticle(m, new PVector(0, 0), new PVector(random(30, 60), random(-60, -30)), r, color(255, 0, 0), _ttl);
      }

      _tiempoSimulacion += delta;

      //println("Tiempo de simulacion: " + _tiempoSimulacion/1000.0 + " s");
      _ps.update(_timeStep);
      _ps2.update(_timeStep);     

      _simTime += _timeStep;
      _numParticles = _ps.getNumParticles() + _ps2.getNumParticles();
      _energy = _ps.getTotalEnergy();

}

void writeToFile(String data)
{
   _output.println(data);
}

void displayInfo()
{
   stroke(TEXT_COLOR[0], TEXT_COLOR[1], TEXT_COLOR[2]);
   fill(TEXT_COLOR[0], TEXT_COLOR[1], TEXT_COLOR[2]);
   textSize(20);
   text("Draw: " + frameRate + "fps", width*0.025, height*0.05);
   text("Simulation time step = " + _timeStep + " s", width*0.025, height*0.075);
   text("Simulated time = " + _simTime + " s", width*0.025, height*0.1); 
   text("Number of particles: " + _numParticles, width*0.025, height*0.125);
   text("Total energy: " + _energy/1000.0 + " kJ", width*0.025, height*0.15);
}
