// Class for a particle system controller
class ParticleSystem
{
   PVector _location;
   ArrayList<Particle> _particles;
   int _nextId;
  
   Grid _grid;
   HashTable _hashTable;
   //int _Nc_Hash = NC_HASH;
   CollisionDataType _collisionDataType;
   color c;

   ParticleSystem(PVector location)
   {
      _location = location;
      _particles = new ArrayList<Particle>();
      int columnas = 20;
      int filas = Num_Particles/columnas;
      float _espacio = R ;
      _nextId = 0;

      _grid = new Grid(SC_GRID);
      _hashTable = new HashTable(SC_HASH, NC_HASH);
      _collisionDataType = CollisionDataType.GRID;
      for (int i = 0; i < filas; i++){      
         for(int j = 0; j < columnas ; j++){   
         PVector initVel = new PVector(0, 0);//Velocidad
         PVector posaux = new PVector((R+_espacio)*j+(160* DISPLAY_SIZE_X / 1000), (R+_espacio)*i+220);//Posición
         addParticle(M, posaux, initVel, R, c);//añadir
         }
    }
   }

   void addParticle(float mass, PVector initPos, PVector initVel, float radius, color c)
   {
      PVector s = PVector.add(_location, initPos);
      _particles.add(new Particle(this, _nextId, mass, s, initVel, radius, c));
      _nextId++;
   }

   void removeParticle(int id)
   {
      for (int i = _particles.size() - 1; i >= 0; i--)
      {
         Particle p = _particles.get(i);
         if (p._id == id)
         {
            _particles.remove(i);
            break;
         }
      }
   }

   void killParticles()
   {
      for (int i = _particles.size() - 1; i >= 0; i--)
      {
         Particle p = _particles.get(i);
         if (p._s.y > height)
         {
            _particles.remove(i);
         }
      }
   }

   void addStockParticles(PVector initPos)
   {
      int n = 250;
      int col = 40;
      int fil = n/col;
      for (int i = 0; i < fil; i++)
      {
         for (int j = 0; j < col; j++)
         {
            PVector s = PVector.add(_location, initPos);
            s.x += j * 2 * R;
            s.y += i * 2 * R;
            PVector v = new PVector(0, 0);
            addParticle(M, s, v, R, c);
         }
      }
   }

   void restart()
   {
      _particles.clear();
   }

   void setCollisionDataType(CollisionDataType collisionDataType)
   {
      _collisionDataType = collisionDataType;
   }

   int getNumParticles()
   {
      return _particles.size();
   }

   ArrayList<Particle> getParticleArray()
   {
      return _particles;
   }

   void updateCollisionData()
   {
      switch(_collisionDataType)
      {
         case GRID:
            updateGrid();
            break;
         case HASH:
            updateHashTable();
            break;
         case NONE:
            break;
      }
   }

   void updateGrid()
   {
      _grid.clear();
      for(int i = 0; i < _particles.size(); i++)
      {
         Particle p = _particles.get(i);
         ArrayList<Integer> aux_cell = _grid.getCell(p._s);
         //int fila = newCell[0], columna = newCell[1];
         if(aux_cell.get(0) >= 0 &&  aux_cell.get(0) < _grid._cells.length && aux_cell.get(1) >= 0 && aux_cell.get(1) < _grid._cells.length)
         {
            p.g_cell = aux_cell;
         }
         _grid.addParticle(p, p.g_cell.get(0), p.g_cell.get(1));
      }
   }

   void updateHashTable()
   {
      _hashTable.clear();
      for(int i = 0; i < _particles.size(); i++)
      {
         Particle p = _particles.get(i);
         p._cell = _hashTable.getCell(p._s);
         _hashTable.insert(p, p._cell);
      }
   }

   void computePlanesCollisions(ArrayList<PlaneSection> planes)
   {
      for (int i = 0; i < _particles.size(); i++) {
         _particles.get(i).planeCollision(planes);
      }
   }

   void computeParticleCollisions(float timeStep)
   {
      for (int i = 0; i < _particles.size(); i++) {
         _particles.get(i).particleCollision(timeStep);
      }
   }

   void update(float timeStep)
   {
      int n = _particles.size();
      for (int i = n - 1; i >= 0; i--)
      {
         Particle p = _particles.get(i);
         p.update(timeStep);
         killParticles();
      }
   }

   void render()
   {
     for (int i= _particles.size() - 1; i >= 0; i--)
     {
         Particle p = _particles.get(i);
         c = color(100, 50, 200);
         int cellda, fil, col;
         ArrayList<Integer> aux_cellda;
         switch(_collisionDataType)
         {
            case GRID:
               aux_cellda = _grid.getCell(p._s);
               fil = aux_cellda.get(0);
               col = aux_cellda.get(1);               
               c = _grid._colors[fil][col];
               break;
            case HASH:
               cellda = _hashTable.getCell(p._s);
               c = _hashTable._colors[cellda];
               break;
            case NONE:
               c = color(100, 50, 200);
               break;
         }
         p.render(c);
     }
   }
}
