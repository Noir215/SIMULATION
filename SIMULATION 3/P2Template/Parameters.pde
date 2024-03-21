// Display and output parameters:

final int DRAW_FREQ = 100;                            // Draw frequency (Hz or Frame-per-second)
final int DISPLAY_SIZE_X = 1000;                      // Display width (pixels)
final int DISPLAY_SIZE_Y = 1000;                      // Display height (pixels)
final int [] BACKGROUND_COLOR = {20, 30, 40};         // Background color (RGB)
final int [] TEXT_COLOR = {255, 255, 0};              // Text color (RGB)
final String FILE_NAME = "data.csv";                  // File to write the simulation variables 


// Parameters of the problem:

final float TS = 0.01;     // Initial simulation time step (s)
final float NT = 100.0;   // Rate at which the particles are generated (number of particles per second) (1/s)           
final float L = 5.0;       // Particles' lifespan (s) 
final float K = 0.001;        // Fuerza de rozamiento del sistema
final float g = 9.8;        //Fuerza de la grvedad del sistema
final float r = 0.5;        //Radio de la partícula
final float m = 0.01;        //Masa de la partícula
final PVector G = new PVector(0.0, g);

final float _deltaTime = 0.0; // Time between two simulation draws (s)

// Constants of the problem:

final String TEXTURE_FILE = "imagen.png";
PImage img;

//
//
