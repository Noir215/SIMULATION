// Definitions:

// Spring Layout
enum SpringLayout
{
   STRUCTURAL,
   SHEAR,
   BEND,
   STRUCTURAL_AND_SHEAR,
   STRUCTURAL_AND_BEND,
   SHEAR_AND_BEND,
   STRUCTURAL_AND_SHEAR_AND_BEND
}

// Simulation values:

final boolean REAL_TIME = true;   // To make the simulation run in real-time or not
final float TIME_ACCEL = 1.0;     // To simulate faster (or slower) than real-time


// Display and output parameters:

boolean DRAW_MODE = false;                            // True for wireframe
final int DRAW_FREQ = 100;                            // Draw frequency (Hz or Frame-per-second)
final int DISPLAY_SIZE_X = 1000;                      // Display width (pixels)
final int DISPLAY_SIZE_Y = 1000;                      // Display height (pixels)
final float FOV = 60;                                 // Field of view (º)
final float NEAR = 0.01;                              // Camera near distance (m)
final float FAR = 10000.0;                            // Camera far distance (m)
final color OBJ_COLOR = color(250, 240, 190);         // Object color (RGB)
final color BALL_COLOR = color(225, 127, 80);         // Ball color (RGB)
final color BACKGROUND_COLOR = color(169, 178, 191); // Background color (RGB)
final int [] TEXT_COLOR = {0, 0, 0};                  // Text color (RGB)
final String FILE_NAME = "data.csv";                  // File to write the simulation variables

// Parameters of the problem:

final float TS = 0.001;     // Initial simulation time step (s)
final float G = 9.81;       // Acceleration due to gravity (m/(s·s))

final int N_X = 10;         // Number of nodes of the object in the X direction
final int N_Y = 10;         // Number of nodes of the object in the Y direction
final int N_Z = 7;          // Number of nodes of the object in the Z direction

final float D_X = 100.0;     // Separation of the object's nodes in the X direction (m)
final float D_Y = 100.0;     // Separation of the object's nodes in the Y direction (m)
final float D_Z = 70.0;     // Separation of the object's nodes in the Z direction (m)

final float KE = 500;
final float KD = 50;

final float KE_z = 500;
final float KD_z = 10;
final float NODE_MASS = 2;


// Ball parameters

final PVector pos_ball = new PVector(-10, -20, 200.0);
final PVector vel_ball = new PVector(0.0, 0.0, -100);
final float radius = 20f;
final float mass = 20;
