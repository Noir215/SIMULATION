// Problem description: //<>// //<>// //<>// //<>// //<>//
//
//
//

// Simulation and time control:

float _timeStep;        // Simulation time-step (s)
float _simTime = 0.0;   // Simulated time (s)

// Output control:

boolean _writeToFile = true;
PrintWriter _output;
boolean _computeParticleCollisions = true;
boolean _computePlaneCollisions = true;
boolean show_cells = false;

// System variables:

ParticleSystem _ps;
ArrayList<PlaneSection> _planes;

// Performance measures:
float _Tint = 0.0;    // Integration time (s)
float _Tdata = 0.0;   // Data-update time (s)
float _Tcol1 = 0.0;   // Collision time particle-plane (s)
float _Tcol2 = 0.0;   // Collision time particle-particle (s)
float _Tsim = 0.0;    // Total simulation time (s) Tsim = Tint + Tdata + Tcol1 + Tcol2
float _Tdraw = 0.0;   // Rendering time (s)

// Main code:

void settings()
{
   size(DISPLAY_SIZE_X, DISPLAY_SIZE_Y);
}

void setup()
{
   frameRate(DRAW_FREQ);
   background(BACKGROUND_COLOR[0], BACKGROUND_COLOR[1], BACKGROUND_COLOR[2]);

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
   else if (key == 'c' || key == 'C')
      _computeParticleCollisions = !_computeParticleCollisions;
   else if (key == 'p' || key == 'P')
      _computePlaneCollisions = !_computePlaneCollisions;
   else if (key == 'n' || key == 'N')
      _ps.setCollisionDataType(CollisionDataType.NONE);
   else if (key == 'g' || key == 'G')
      _ps.setCollisionDataType(CollisionDataType.GRID);
   else if (key == 'h' || key == 'H')
      _ps.setCollisionDataType(CollisionDataType.HASH);
   else if (key == '+')
      _timeStep *= 1.1;
   else if (key == '-')
      _timeStep /= 1.1;
   else if (key == 's' || key == 'S')
      show_cells = !show_cells;
}

void mousePressed()
{
   PVector pos = new PVector(mouseX, mouseY);
   _ps.addStockParticles(pos);
}

void initSimulation()
{
   if (_writeToFile)
   {
      _output = createWriter(FILE_NAME);
      writeToFile("t, n, sim, A");
   }

   _simTime = 0.0;
   _timeStep = TS;

   initPlanes();
   initParticleSystem();
}

void initPlanes()
{
   _planes = new ArrayList<PlaneSection>();
   _planes.add(new PlaneSection((int)(250 * DISPLAY_SIZE_X / 1000), (int)(900 * DISPLAY_SIZE_Y / 1000), (int)(750 * DISPLAY_SIZE_X / 1000), (int)(900 * DISPLAY_SIZE_Y / 1000), false));
   _planes.add(new PlaneSection((int)(150 * DISPLAY_SIZE_X / 1000), (int)(800 * DISPLAY_SIZE_Y / 1000), (int)(250 * DISPLAY_SIZE_X / 1000), (int)(900 * DISPLAY_SIZE_Y / 1000), false ));
   _planes.add(new PlaneSection((int)(150 * DISPLAY_SIZE_X / 1000), (int)(200 * DISPLAY_SIZE_Y / 1000), (int)(150 * DISPLAY_SIZE_X / 1000), (int)(800 * DISPLAY_SIZE_Y / 1000), false));
   _planes.add(new PlaneSection((int)(150 * DISPLAY_SIZE_X / 1000), (int)(200 * DISPLAY_SIZE_Y / 1000), (int)(250 * DISPLAY_SIZE_X / 1000), (int)(200 * DISPLAY_SIZE_Y / 1000), true));
   _planes.add(new PlaneSection((int)(250 * DISPLAY_SIZE_X / 1000), (int)(200 * DISPLAY_SIZE_Y / 1000), (int)(250 * DISPLAY_SIZE_X / 1000), (int)(750 * DISPLAY_SIZE_Y / 1000), true));
   _planes.add(new PlaneSection((int)(250 * DISPLAY_SIZE_X / 1000), (int)(750 * DISPLAY_SIZE_Y / 1000), (int)(300 * DISPLAY_SIZE_X / 1000), (int)(800 * DISPLAY_SIZE_Y / 1000), true));
   _planes.add(new PlaneSection((int)(300 * DISPLAY_SIZE_X / 1000), (int)(800 * DISPLAY_SIZE_Y / 1000), (int)(700 * DISPLAY_SIZE_X / 1000), (int)(800 * DISPLAY_SIZE_Y / 1000), true));
   _planes.add(new PlaneSection((int)(700 * DISPLAY_SIZE_X / 1000), (int)(800 * DISPLAY_SIZE_Y / 1000), (int)(750 * DISPLAY_SIZE_X / 1000), (int)(750 * DISPLAY_SIZE_Y / 1000), true));
   _planes.add(new PlaneSection((int)(750 * DISPLAY_SIZE_X / 1000), (int)(200 * DISPLAY_SIZE_Y / 1000), (int)(750 * DISPLAY_SIZE_X / 1000), (int)(750 * DISPLAY_SIZE_Y / 1000), false));
   _planes.add(new PlaneSection((int)(850 * DISPLAY_SIZE_X / 1000), (int)(200 * DISPLAY_SIZE_Y / 1000), (int)(850 * DISPLAY_SIZE_X / 1000), (int)(800 * DISPLAY_SIZE_Y / 1000), true));
   _planes.add(new PlaneSection((int)(750 * DISPLAY_SIZE_X / 1000), (int)(900 * DISPLAY_SIZE_Y / 1000), (int)(850 * DISPLAY_SIZE_X / 1000), (int)(800 * DISPLAY_SIZE_Y / 1000), false));




   /*
   _planes.add(new PlaneSection(250, 900, 750, 900, false));    
   _planes.add(new PlaneSection(150, 800, 250, 900, false));//diagonales   
   _planes.add(new PlaneSection(150, 200, 150, 800, false));
   _planes.add(new PlaneSection(150, 200, 250, 200, true)); //tapa
   _planes.add(new PlaneSection(250, 200, 250, 750, true));
   _planes.add(new PlaneSection(250, 750, 300, 800, true)); //diagonales
   _planes.add(new PlaneSection(300, 800, 700, 800, true));//centroarriba
   _planes.add(new PlaneSection(700, 800, 750, 750, true));
   _planes.add(new PlaneSection(750, 200, 750, 750, false));   
   //_planes.add(new PlaneSection(750, 200, 850, 200, false)); //tapa
   _planes.add(new PlaneSection(850, 200, 850, 800, true));
   _planes.add(new PlaneSection(750, 900, 850, 800, false)); //diagonales
   */
   
}

void initParticleSystem()
{
   _ps = new ParticleSystem(new PVector(0, 0));   
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
   float time = millis();
   drawStaticEnvironment();
   drawMovingElements();
   _Tdraw = millis() - time;

   time = millis();
   updateSimulation();
   _Tsim = millis() - time;

   displayInfo();

   if (_writeToFile)
      writeToFile(_simTime + ", " + _ps.getNumParticles() + ", " + _Tsim + ", " + _Tdraw);
}

void drawStaticEnvironment()
{
   background(BACKGROUND_COLOR[0], BACKGROUND_COLOR[1], BACKGROUND_COLOR[2]);

   for (int i = 0; i < _planes.size(); i++){
      _planes.get(i).render();
   }
   if(show_cells  && _ps._collisionDataType == CollisionDataType.GRID)
      _ps._grid.render();
   if(show_cells  && _ps._collisionDataType == CollisionDataType.HASH)
      _ps._hashTable.render();
}

void drawMovingElements()
{
   _ps.render();
}

void updateSimulation()
{
   float time = millis();
   if (_computePlaneCollisions)
      _ps.computePlanesCollisions(_planes);
   _Tcol1 = millis() - time;

   time = millis();
   if (_computeParticleCollisions)
      _ps.updateCollisionData();
   _Tdata = millis() - time;

   time = millis();
   if (_computeParticleCollisions)
      _ps.computeParticleCollisions(_timeStep);
   _Tcol2 = millis() - time;

   time = millis();
   _ps.update(_timeStep);
   _simTime += _timeStep;
   _Tint = millis() - time;
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
   text("Time integrating equations: " + _Tint + " ms", width*0.3, height*0.025);
   text("Time updating collision data: " + _Tdata + " ms", width*0.3, height*0.050);
   text("Time computing collisions (planes): " + _Tcol1 + " ms", width*0.3, height*0.075);
   text("Time computing collisions (particles): " + _Tcol2 + " ms", width*0.3, height*0.100);
   text("Total simulation time: " + _Tsim + " ms", width*0.3, height*0.125);
   text("Time drawing: " + _Tdraw + " ms", width*0.3, height*0.150);
   text("Total step time: " + (_Tsim + _Tdraw) + " ms", width*0.3, height*0.175);
   text("Fps: " + frameRate + "fps", width*0.3, height*0.200);
   text("Simulation time step = " + _timeStep + " s", width*0.3, height*0.225);
   text("Simulated time = " + _simTime + " s", width*0.3, height*0.250);
   text("Number of particles: " + _ps.getNumParticles(), width*0.3, height*0.275);
   text("Type: " + _ps._collisionDataType, width*0.3, height*0.300);
   //text("Hash table size: " + _ps._hashTable._numCells, width*0.3, height*0.350);
}
