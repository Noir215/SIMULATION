// Definitions:

enum IntegratorType 
{
   NONE, 
   EXPLICIT_EULER, 
   SIMPLECTIC_EULER, 
   RK2, 
   RK4,
   HEUN 
}


// Display and output parameters:

final int DRAW_FREQ = 100;                            // Draw frequency (Hz or Frame-per-second)
final int DISPLAY_SIZE_X = 1000;                      // Display width (pixels)
final int DISPLAY_SIZE_Y = 1000;                      // Display height (pixels)
final int [] BACKGROUND_COLOR = {200, 220, 180};      // Background color (RGB)
final int [] TEXT_COLOR = {0, 0, 0};                  // Text color (RGB)
final int [] STATIC_ELEMENTS_COLOR = {0, 255, 0};     // Color of non-moving elements (RGB)
final int [] MOVING_ELEMENTS_COLOR = {255, 0, 0};     // Color of moving elements (RGB)
final float OBJECTS_SIZE = 20.0;                      // Size of the objects (m)
final String FILE_NAME = "data.csv";                  // File to write the simulation variables 


// Parameters of the problem:

final float TS = 0.001;      // Initial simulation time step (s)
final float M = 1.0;         // Particle mass (kg)
final float G = 9.801;       // Acceleration due to gravity (m/(s·s))
final float D = 200.0;       // Square's half size (m)
final float K = 8.98 * pow(10, 9);
// 
// 


// Constants of the problem:

final PVector C = new PVector(500.0, 500.0);              // Center of the spring system (m)
final PVector S0 = PVector.add(C, new PVector(0.0, -D));  // Particle's start position (m)
final PVector V0 = new PVector(2000.0, 0.0, 0.0); 
// 
// 
