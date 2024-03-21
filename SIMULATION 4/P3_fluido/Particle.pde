// Class for a simple particle with no rotational motion
public class Particle
{
   ParticleSystem _ps;  // Reference to the parent ParticleSystem
   int _id;             // Id. of the particle

   float _m;            // Mass of the particle (kg)
   PVector _s;          // Position of the particle (m)
   PVector _v;          // Velocity of the particle (m/s)
   PVector _a;          // Acceleration of the particle (m/(s·s))
   PVector _F;          // Force applied on the particle (N)

   float _radius;       // Radius of the particle (m)
   color _color;        // Color of the particle (RGBA)
   
   ArrayList<Integer> g_cell;        // Columna Celda actual
   int _cell;          // fila Celda actual

   ArrayList <Particle> vecis; // List of neighbors
      
   Particle(ParticleSystem ps, int id, float m, PVector s, PVector v, float radius, color c)
   {
      _ps = ps;
      _id = id;

      _m = m;
      _s = s;
      _v = v;
      _a = new PVector(0.0, 0.0, 0.0);
      _F = new PVector(0.0, 0.0, 0.0);

      _radius = radius;
      _color = c;
      
      _cell = _ps._hashTable.getCell(_s);
      g_cell = _ps._grid.getCell(_s);

      vecis = new ArrayList<Particle>();
   }

   void setPos(PVector s)
   {
      _s = s;
   }

   void setVel(PVector v)
   {
      _v = v;
   }

   PVector getForce()
   {
      return _F;
   }

   float getRadius()
   {
      return _radius;
   }

   float getColor()
   {
      return _color;
   }

   void update(float timeStep)
   {
      updateForce();
      _a = PVector.div(_F, _m);
      _v = PVector.add(_v, PVector.mult(_a, timeStep));
      _s = PVector.add(_s, PVector.mult(_v, timeStep));
      //println("POS: " + _s);
   }

   void updateForce()
   {
      PVector Peso = PVector.mult(G, _m);
      PVector Froz = PVector.mult(_v, -Kd);
      _F = PVector.add(Peso, Froz);
   }

   void planeCollision(ArrayList<PlaneSection> planes) {
      for (PlaneSection plane : planes) {
         float distance = plane.getDistance(_s);
         if (distance <= _radius && plane.inside(_s)) {
               PVector n = plane.getNormal();
               _s.sub(PVector.mult(n, distance - _radius)); // corrección de posición
               float vn = PVector.dot(_v, n); // componente normal
               if (vn < 0) //Si la velocidad es positiva o nula no hay colisión, se esta alejando del plano
               { 
                  PVector vnVector = PVector.mult(n, vn);
                  PVector vtVector = PVector.sub(_v, vnVector); // componente tangencial
                  _v.set(vtVector);
                  _v.sub(PVector.mult(vnVector, Cr)); // coeficiente de restitución
               }
         }
      }
   }

   
   void particleCollision(float timeStep)
   {
      switch(_ps._collisionDataType){
         case NONE:
            //particleCollisionBruteForce(timeStep);
            ArrayList <Particle> Lista = _ps.getParticleArray();
            for(Particle p : Lista){
               if (_id != p._id)
               {
                  PVector n = PVector.sub(p._s, _s);
                  float dist = n.mag();
                  float minDist = _radius + p._radius;
                  if (dist < minDist)
                  {
                     float angle = atan2(n.y, n.x);
                     PVector target = new PVector(0, 0, 0);
                     target.x = _s.x + cos(angle) * minDist;
                     target.y = _s.y + sin(angle) * minDist;
                     PVector acceleration = PVector.mult(PVector.sub(target, p._s), spring);
                     acceleration.add(PVector.mult(_v,Cr));
                     _v.sub(PVector.mult(acceleration, timeStep));
                     p._v.add(PVector.mult(acceleration, timeStep));
                  }
               }
            }
            break;
         case GRID:
            updateNeighborsGrid(_ps._grid);
            for(Particle p : vecis){
               if (_id != p._id)
               {
                  PVector n = PVector.sub(p._s, _s);
                  float dist = n.mag();
                  float minDist = _radius + p._radius;
                  if (dist < minDist)
                  {
                     float angle = atan2(n.y, n.x);
                     PVector target = new PVector(0, 0, 0);
                     target.x = _s.x + cos(angle) * minDist;
                     target.y = _s.y + sin(angle) * minDist;
                     PVector acceleration = PVector.mult(PVector.sub(target, p._s), spring);
                     acceleration.add(PVector.mult(_v,Cr));
                     _v.sub(PVector.mult(acceleration, timeStep));
                     p._v.add(PVector.mult(acceleration, timeStep));
                  }
               }
            }
            break;
         case HASH:
            updateNeighborsHash(_ps._hashTable);
            for(Particle p : vecis){
               if (_id != p._id)
               {
                  PVector n = PVector.sub(p._s, _s);
                  float dist = n.mag();
                  float minDist = _radius + p._radius;
                  if (dist < minDist)
                  {
                     float angle = atan2(n.y, n.x);
                     PVector target = new PVector(0, 0, 0);
                     target.x = _s.x + cos(angle) * minDist;
                     target.y = _s.y + sin(angle) * minDist;
                     PVector acceleration = PVector.mult(PVector.sub(target, p._s),  10);
                     acceleration.add(PVector.mult(_v,Cr));
                     _v.sub(PVector.mult(acceleration, timeStep));
                     p._v.add(PVector.mult(acceleration, timeStep));
                  }
               }
            }
            break;
      }
     
   }  

   void updateNeighborsGrid(Grid grid) {
      ArrayList<Integer> up, down, left, right;
      vecis.clear();

      right = grid.getCell(new PVector(_s.x + _radius, _s.y));
      left = grid.getCell(new PVector(_s.x - _radius, _s.y));
      up = grid.getCell(new PVector(_s.x, _s.y + _radius));
      down = grid.getCell(new PVector(_s.x, _s.y - _radius));      

      if(right != null) {    
         ParticleList rightCell = grid._cells[right.get(0)][right.get(1)];
         for(int i = 0; i < rightCell._vector.size(); i++){
               Particle p = rightCell._vector.get(i);
               vecis.add(p);
         }
      }
      if(left != null && !left.equals(right)) {
         ParticleList leftCell = grid._cells[left.get(0)][left.get(1)];
         for(int i = 0; i < leftCell._vector.size(); i++){
               Particle p = leftCell._vector.get(i);
               vecis.add(p);
         }
      }
      if(up != null && !up.equals(right) && !up.equals(left)) {
         ParticleList upCell = grid._cells[up.get(0)][up.get(1)];
         for(int i = 0; i < upCell._vector.size(); i++){
               Particle p = upCell._vector.get(i);
               vecis.add(p);
         }
      }
      if(down != null && !down.equals(right) && !down.equals(left) && !down.equals(up)) {
         ParticleList downCell = grid._cells[down.get(0)][down.get(1)];
         for(int i = 0; i < downCell._vector.size(); i++){
               Particle p = downCell._vector.get(i);
               vecis.add(p);
         }
      }
   }

   void updateNeighborsHash(HashTable hash) {
      // Se calculan los vecinos de la partícula this
      int right = hash.getCell(new PVector(_s.x + _radius, _s.y));
      int left = hash.getCell(new PVector(_s.x - _radius, _s.y));
      int up = hash.getCell(new PVector(_s.x, _s.y + _radius));
      int down = hash.getCell(new PVector(_s.x, _s.y - _radius));
      vecis.clear();

      // Se agregan los vecinos a vecis
      if (right >= 0) {
         for (int i = 0; i < hash._table.get(right).size(); i++) {
               Particle p = hash._table.get(right).get(i);
               vecis.add(p);
         }
      }
      if (left >= 0 && left != right) {
         for (int i = 0; i < hash._table.get(left).size(); i++) {
               Particle p = hash._table.get(left).get(i);
               vecis.add(p);
         }
      }
      if (up >= 0 && up != right && up != left) {
         for (int i = 0; i < hash._table.get(up).size(); i++) {
               Particle p = hash._table.get(up).get(i);
               vecis.add(p);
         }
      }
      if (down >= 0 && down != right && down != left && down != up) {
         for (int i = 0; i < hash._table.get(down).size(); i++) {
               Particle p = hash._table.get(down).get(i);
               vecis.add(p);
         }
      }
   }

   void render(color c)
   {
      fill(c);
      noStroke();
      circle(_s.x, _s.y, _radius);
   }
}
