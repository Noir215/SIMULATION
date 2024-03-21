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


final float h = 0.1;       // Height of the container (m)


// Parameters of the problem:

final float TS = 0.05;     // Initial simulation time step (s)
final float M = 10;       // Particles' mass (kg)
final float R = 5;      // Particles' radius (m)
final PVector G = new PVector (0.0, 9.81);      // Gravity (m/s^2)
final float Kd = 0.1;       // Friction constant (Kg/m)
final float Ke = 10;      // Elastic constant (N/m)
final float Cr = 0.9;      // Coefficient of restitution
final float DMIN = 2*R;
final float L0= DMIN;      // Initial length of the spring (m)
//final float dm = 0.1;      // Distance dumpling (m)
final int Num_Particles = 1000;      // Number of particles
final int spring = 40;      //

// Constants of the problem:

final color PARTICLES_COLOR = color(120, 160, 220);
final int SC_GRID = 500;             // Cell size (grid) (m)
final int SC_HASH = 100;             // Cell size (hash) (m)
final int NC_HASH = 1000;           // Number of cells (hash)
//final int NC_HASH = Num_Particles * 2;           // Number of cells (hash)

//
