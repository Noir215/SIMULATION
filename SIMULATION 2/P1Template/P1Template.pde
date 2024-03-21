// Problem description: //<>//
//
//
//

// Differential equations:
//
//
//
//
//

// Simulation and time control:

IntegratorType _integrator = IntegratorType.NONE;   // ODE integration method
float _timeStep;        // Simulation time-step (s)
float _simTime = 0.0;   // Simulated time (s)


// Output control:

boolean _writeToFile = true;
PrintWriter _output;


// Variables to be solved:

PVector _s = new PVector();   // Position of the particle (m)
PVector _v = new PVector();   // Velocity of the particle (m/s)
PVector _a = new PVector();   // Accleration of the particle (m/(s*s))
float _energy;                // Total energy of the particle (J)


// Springs:

Particle _p1;
Particle _p2;


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

void mouseClicked()
{
   _s.x = mouseX;
   _s.y = mouseY;
   _a.set(0.0, 0.0);
   _v = V0.copy();
}

void keyPressed()
{
   if (key == 'r' || key == 'R')
      restartSimulation();
   else if (key == ' ')
      _integrator = IntegratorType.NONE;
   else if (key == '1')
      _integrator = IntegratorType.EXPLICIT_EULER;
   else if (key == '2')
      _integrator = IntegratorType.SIMPLECTIC_EULER;
   else if (key == '3')
      _integrator = IntegratorType.RK2;
   else if (key == '4')
      _integrator = IntegratorType.RK4;
   else if (key == '5')
      _integrator = IntegratorType.HEUN;
   else if (key == '+')
      _timeStep *= 1.1;
   else if (key == '-')
      _timeStep /= 1.1;
}

void initSimulation()
{
   if (_writeToFile)
   {
      _output = createWriter(FILE_NAME);
      writeToFile("t, E, sx, sy, vx, vy, ax, ay");
   }

   _simTime = 0.0;
   _timeStep = TS;

   _s = S0.copy();
   _v = V0.copy();
   _a.set(0.0, 0.0, 0.0);
    
   _p1 = new Particle(_s, new PVector(500, 500), K, 1, 0.1, 1);
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
   calculateEnergy();
   displayInfo();

   if (_writeToFile)
      writeToFile(_simTime + ", " + _energy + ", " + _s.x + ", " + _s.y + ", " + _v.x + ", " + _v.y + "," + _a.x + ", " + _a.y);
}

void drawStaticEnvironment()
{
   background(BACKGROUND_COLOR[0], BACKGROUND_COLOR[1], BACKGROUND_COLOR[2]);
   fill(STATIC_ELEMENTS_COLOR[0], STATIC_ELEMENTS_COLOR[1], STATIC_ELEMENTS_COLOR[2]);
   circle (DISPLAY_SIZE_X/2, DISPLAY_SIZE_Y/2, 30);
}

void drawMovingElements()
{
   fill(MOVING_ELEMENTS_COLOR[0], MOVING_ELEMENTS_COLOR[1], MOVING_ELEMENTS_COLOR[2]);
   circle (_s.x, _s.y, 20);

}

void updateSimulation()
{
   switch (_integrator)
   {
      case EXPLICIT_EULER:
         updateSimulationExplicitEuler();
         break;
   
      case SIMPLECTIC_EULER:
         updateSimulationSimplecticEuler();
         break;
   
      case HEUN:
         updateSimulationHeun();
         break;
   
      case RK2:
         updateSimulationRK2();
         break;
   
      case RK4:
         updateSimulationRK4();
         break;
   
      case NONE:
      default:
   }

   _simTime += _timeStep;
}

void calculateEnergy()
{
   float Ek = 0.5 * _p1.getMass() * pow(_v.mag(), 2);
   _energy = Ek + _p1.getEnergy();
   println("Ek:::: " + Ek);
   println("Ee:::: " + _p1.getEnergy());
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
   text("Integrator: " + _integrator.toString(), width*0.025, height*0.075);
   text("Simulation time step = " + _timeStep + " s", width*0.025, height*0.1);
   text("Simulated time = " + _simTime + " s", width*0.025, height*0.125);
   text("Energy: " + _energy/1000.0 + " kJ", width*0.025, height*0.15);
   text("Speed: " + _v.mag()/1000.0 + " km/s", width*0.025, height*0.175);
   text("Acceleration: " + _a.mag()/1000.0 + " km/s2", width*0.025, height*0.2);
}

void updateSimulationExplicitEuler()
{
   _a = calculateAcceleration(_s, _v);
   _s.add(PVector.mult(_v, _timeStep));   // s(t+h) = s(t) + h*v(t)
   _v.add(PVector.mult(_a, _timeStep));   // v(t+h) = v(t) + h*a(s(t),v(t))
}

void updateSimulationSimplecticEuler()
{
   _a = calculateAcceleration(_s, _v);
   _v.add(PVector.mult(_a, _timeStep));  // v(t+h) = v(t) + h*a(s(t),v(t))
   _s.add(PVector.mult(_v, _timeStep));  // s(t+h) = s(t) + h*v(t)
}

void updateSimulationRK2()
{
  /*
   _a = calculateAcceleration(_s, _v);
  
   PVector _s2 = PVector.add(_s, PVector.mult(_v, _timeStep * 0.5));
   PVector _v2 = PVector.add(_v, PVector.mult(_a, _timeStep * 0.5));
   PVector _a2 = calculateAcceleration(_s2, _v2);
  
   _s.add(PVector.mult(_v2, _timeStep));
   _v.add(PVector.mult(_a2, _timeStep));
  */
  _a = calculateAcceleration(_s,_v);           // a = a(s(t),v(t))
  PVector K1v = PVector.mult(_a, _timeStep);    // k1v = a*h
  PVector K1s = PVector.mult(_v, _timeStep);    // k1s = v(t)*h  

  // calulamos s_mitad, v_mitad a partir de v, a (h/2)
  PVector v2 = PVector.add(_v,PVector.mult(K1v, 0.5));  //y = (v(t)+k1v/2)
  PVector s2 = PVector.add(_s,PVector.mult(K1s, 0.5));  //x = (s(t)+k1s/2)
    
  // calcular a_mitad(s_mitad, v_mitad)
  PVector a2 = calculateAcceleration(s2,v2);    //a2 = a(x, y)
  PVector K2v = PVector.mult(a2, _timeStep);    // k2v = a2*h
  PVector K2s = PVector.mult(PVector.add(_v, PVector.mult(K1v,0.5)), _timeStep); // k2s = (v(t)+k1v/2)*h

  //actualizamos a partir de la mitad de h
  _v.add(K2v);
  _s.add(K2s);
}

void updateSimulationRK4()
{
  /*
    _a = calculateAcceleration(_s, _v);
  
    PVector _s2 = PVector.add(_s, PVector.mult(_v, _timeStep * 0.5));
    PVector _v2 = PVector.add(_v, PVector.mult(_a, _timeStep * 0.5));
    PVector _a2 = calculateAcceleration(_s2, _v2);
    
    PVector _s3 = PVector.add(_s2, PVector.mult(_v2, _timeStep * 0.5));
    PVector _v3 = PVector.add(_v2, PVector.mult(_a2, _timeStep * 0.5));
    PVector _a3 = calculateAcceleration(_s3, _v3);
    
    PVector _v4 = PVector.add(_v3, PVector.mult(_a3, _timeStep));
  
    PVector _vRK = _v.add(PVector.mult(_v2, 2).add(PVector.mult(_v3,2).add(_v4)));
    _vRK.div(6);
    
    _s.add(PVector.mult(_vRK, _timeStep));
    */
    _a = calculateAcceleration(_s, _v); 
    PVector k1s = PVector.mult(_v, _timeStep);// k1s = v(t)*h
    PVector k1v = PVector.mult(_a, _timeStep);// k1v = a(s(t),v(t))*h
  
    PVector s2  = PVector.add(_s, PVector.mult(k1s, 0.5));                         
    PVector v2  = PVector.add(_v, PVector.mult(k1v, 0.5));
    
    PVector a2 = calculateAcceleration(s2, v2);
    PVector k2v = PVector.mult(a2, _timeStep);// k2v = a(s(t)+k1s/2, v(t)+k1v/2)*h
    PVector k2s = PVector.mult(v2, _timeStep); // k2s = (v(t)+k1v/2)*h
  
    PVector s3  = PVector.add(_s, PVector.mult(k2s, 0.5));                         
    PVector v3  = PVector.add(_v, PVector.mult(k2v, 0.5));
    PVector a3 = calculateAcceleration(s3, v3);
    PVector k3v = PVector.mult(a3, _timeStep); // k3v = a(s(t)+k2s/2, v(t)+k2v/2)*h
    PVector k3s = PVector.mult(v3, _timeStep); // k3s = (v(t)+k2v/2)*h
  
    PVector s4  = PVector.add(_s, k3s);                         
    PVector v4  = PVector.add(_v, k3v);
    PVector a4 = calculateAcceleration(s4, v4);
    PVector k4v = PVector.mult(a4, _timeStep); // k4v = a(s(t)+k3s, v(t)+k3v)*h
    PVector k4s = PVector.mult(v4, _timeStep); // k4s = (v(t)+k3v)*h
  
  
    // v(t+h) = v(t) + (1/6)*k1v + (1/3)*k2v + (1/3)*k3v +(1/6)*k4v  
    _v.add(PVector.mult(k1v, 1/6.0));
    _v.add(PVector.mult(k2v, 1/3.0));
    _v.add(PVector.mult(k3v, 1/3.0));
    _v.add(PVector.mult(k4v, 1/6.0));
  
    // s(t+h) = s(t) + (1/6)*k1s + (1/3)*k2s + (1/3)*k3s +(1/6)*k4s  
    _s.add(PVector.mult(k1s, 1/6.0));
    _s.add(PVector.mult(k2s, 1/3.0));
    _s.add(PVector.mult(k3s, 1/3.0));
    _s.add(PVector.mult(k4s, 1/6.0));
}

void updateSimulationHeun()
{
   _a = calculateAcceleration(_s, _v);
  PVector _s2 = PVector.add(_s, PVector.mult(_v, _timeStep));
  PVector _v2 = PVector.add(_v, PVector.mult(_a, _timeStep));
  PVector _a2 = calculateAcceleration(_s2, _v2);
  
  PVector _vHeun = PVector.mult(PVector.add(_v, _v2), 0.5);
  
  PVector _aHeun = PVector.mult(PVector.add(_a,_a2),0.5);
  _v.add(PVector.mult(_aHeun, _timeStep));
  _s.add(PVector.mult(_vHeun, _timeStep));

}

PVector calculateAcceleration(PVector s, PVector v)
{
   PVector a = new PVector();
   _p1.setPos1(s);
   _p1.update();
   
   a = PVector.div(_p1.getForce(), _p1.getMass());
   
   return a;
}
