// Definitions:

enum CollisionDataType
{
   NONE,
   GRID,
   HASH
}

// Display and output parameters:

final int DRAW_FREQ = 100;                            // Draw frequency (Hz or Frame-per-second)
final int DISPLAY_SIZE_X = 1000;                      // Display width (pixels)
final int DISPLAY_SIZE_Y = 1000;                      // Display height (pixels)
final int [] BACKGROUND_COLOR = {220, 200, 210};      // Background color (RGB)
final int [] TEXT_COLOR = {0, 0, 0};                  // Text color (RGB)
final String FILE_NAME = "data.csv";                  // File to write the simulation variables


// Parameters of the problem:

final float TS = 0.1;     // Initial simulation time step (s)
float M = random(1,5);       // Particles' mass (kg)
float Q = random(1, 10);        // Particles' charge (C)
final float M_min = 0;       // Particles' mass (kg)
final float M_max = 2;       // Particles' mass (kg)
final float Q_min = 0;        // Particles' charge (C)
final float Q_max = 3;        // Particles' charge (C)
final float R = 10;      // Particles' radius (m)
final int GEN = 25;        // Particles generated
//final float Kq = (8.99)* pow(10,9);       // Coulomb Proportionality constant (N*m/C^2)
final float Ka = 1;       // Coulomb Proportionality constant (N*m/C^2)
final float Kd = 0.5;       // Friction coefficient (kg/s)

final float V = 10;      // Particles' initial velocity (m/s)


// Constants of the problem:

final color PARTICLES_COLOR = color(120, 160, 220);
final int SC_GRID = 50;             // Cell size (grid) (m)
final int SC_HASH = 50;             // Cell size (hash) (m)
final int NC_HASH = 1000;           // Number of cells (hash)
//
//
//
