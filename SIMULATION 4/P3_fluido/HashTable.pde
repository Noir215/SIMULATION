class HashTable
{
   ArrayList<ArrayList<Particle>> _table;

   int _numCells;
   float _cellSize;
   color[] _colors;

   HashTable(float cellSize, int numCells)
   {
      _table = new ArrayList<ArrayList<Particle>>();
      _cellSize = cellSize;
      _numCells = numCells;

      _colors = new color[_numCells];

      for (int i = 0; i < _numCells; i++)
      {
         ArrayList<Particle> cell = new ArrayList<Particle>();
         _table.add(cell);
         _colors[i] = color(int(random(0, 256)), int(random(0, 256)), int(random(0, 256)), 150);
      }
   }

   void clear()
   {
      for (int i = 0; i < _numCells; i++)
      {
         _table.get(i).clear();
      }
   }

   void insert(Particle p, int cellIndex)
   {
      _table.get(cellIndex).add(p);
   }

   int getCellMIO(PVector p) {

      int rows = int(height / _cellSize);
      int cols = int(width / _cellSize);
    
      int row = int(p.y / _cellSize);
      if (row >= rows) {
        row = rows - 1;
      }
    
      int col = int(p.x / _cellSize);
      if (col >= cols) {
        col = cols - 1;
      }
    
      int index = row * cols + col;
  
      return index;
      
   }
   
   int getCell(PVector p)   
   {
      long xd = int(floor(p.x / _cellSize));
      long yd = int(floor(p.y / _cellSize));
      long zd = int(floor(p.z / _cellSize));
      long suma = 73856093*xd + 19349663*yd + 83492791*zd;
      int index = int(suma % _numCells);
      return index;
   }
   
   

   void render()
   {
      strokeWeight(1);
      stroke(255);
      for (int i = 0; i < _numCells; i++)
      {
         line(0, i * _cellSize, width, i * _cellSize);
         line(i * _cellSize, 0, i * _cellSize, height);
      }
   }
}
