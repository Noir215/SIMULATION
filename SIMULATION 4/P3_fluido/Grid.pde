class ParticleList
{
   //En esta clase se crea una lista de particulas
   ArrayList<Particle> _vector;
   ParticleList()
   {
      _vector = new ArrayList<Particle>();
   }
}

class Grid
{
   float _cellSize;
   int _nRows;
   int _nCols;
   int _numCells;

   //Aqui se crea una matriz de ParticleList (listas de particulas)
   ParticleList [][] _cells;
   color [][] _colors;

   Grid(float cellSize)
   {
      _cellSize = cellSize;
      _nRows = int(height/_cellSize);
      _nCols = int(width/_cellSize);
      _numCells = _nRows*_nCols;

      //Se define el tamaño de la matriz de listas de particulas
      _cells  = new ParticleList[_nRows][_nCols];
      _colors = new color[_nRows][_nCols];

      for (int i = 0; i < _nRows; i++)
      {
         for (int j = 0; j < _nCols; j++)
         {
            _cells[i][j] = new ParticleList(); //en cada celda se crea una lista de particulas
            _colors[i][j] = color(int(random(0, 256)), int(random(0, 256)), int(random(0, 256)), 150);
         }
      }
   }

   void clear()
   {
      for (int i = 0; i < _nRows; i++)
      {
         for (int j = 0; j < _nCols; j++)
         {
            _cells[i][j]._vector.clear();
         }
      }
   }
    
   ArrayList<Integer> getCell(PVector p) {

      int row = (int) Math.min(p.y / _cellSize, _nRows - 1);
      int col = (int) Math.min(p.x / _cellSize, _nCols - 1);
      
      ArrayList<Integer> cell = new ArrayList<Integer>();
      cell.add(row);
      cell.add(col);
      
      return cell;
   }
    

   void addParticle(Particle p, int row, int col)
   {
      _cells[row][col]._vector.add(p);
   }

   void render()
   {      
      strokeWeight(1);
      stroke(255,0,0);
      noFill();
      for(int i = 0; i < _nRows; i++)
      {
         for(int j = 0; j < _nCols; j++)
         {
            rect(j*_cellSize, i*_cellSize, _cellSize, _cellSize);
         }
      }
   }
}
