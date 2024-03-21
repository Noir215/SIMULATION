// Class for a particle system controller
class ParticleSystem
{
   PVector _location;
   ArrayList<Particle> _particles;
   int _nextId;

   CollisionDataType _collisionDataType;

   ParticleSystem(PVector location)
   {
      _location = location;
      _particles = new ArrayList<Particle>();
      _nextId = 0;

      _collisionDataType = CollisionDataType.NONE;
   }

   void addParticle(float mass, float charge, PVector initPos, PVector initVel, float radius, color c)
   {
      PVector s = PVector.add(_location, initPos);
      _particles.add(new Particle(this, _nextId, mass, charge, s, initVel, radius, c));
      _nextId++;
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
      //
      //
      //  
   }

   void updateGrid()
   {
      //
      //
      //  
   }

   void updateHashTable()
   {
      //
      //
      // 
   }


   void computeParticleCollisions(float timeStep)
   {
      //
      //
      // 
   }

   void update(float timeStep)
   {
      int n = _particles.size();
      for (int i = n - 1; i >= 0; i--)
      {
         Particle p = _particles.get(i);
         ArrayList<Particle> _particles = this.getParticleArray();
         p.update(timeStep, _particles);
      }
   }

   void render()
   {
      int n = _particles.size();
      for (int i = n - 1; i >= 0; i--) 
      {
        Particle p = _particles.get(i);      
        p.render();
        //println("Pos" + p._s);
      } 
   }
}
