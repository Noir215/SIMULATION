// Class for a simple particle with no rotational motion
public class Particle
{
   ParticleSystem _ps;  // Reference to the parent ParticleSystem
   int _id;             // Id. of the particle

   float _m;            // Mass of the particle (kg)
   float _q;            // Charge of the particle (C)
   PVector _s;          // Position of the particle (m)
   PVector _v;          // Velocity of the particle (m/s)
   PVector _a;          // Acceleration of the particle (m/(s·s))
   PVector _F;          // Force applied on the particle (N)
   
   float _radius;       // Radius of the particle (m)
   color _color;        // Color of the particle (RGBA)
  
      
   Particle(ParticleSystem ps, int id, float m, float q, PVector s, PVector v, float radius, color c)
   {
      _ps = ps;
      _id = id;
      _m = m;
      _q = q;
      _s = s;
      _v = v;
      _a = new PVector(0, 0, 0);
      _F = new PVector(0, 0, 0);
      _radius = radius;
      _color = c;
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

   void update(float timeStep, ArrayList<Particle> vecis)
   {
      for (Particle veci : vecis) {
        //updateForce(veci);   
        boolean continuar = true;           
         PVector d = PVector.sub(_s, veci._s);
         float distancia = d.mag();
         if(distancia < _radius){
            continuar = false;
         }
         if(continuar && _id != veci._id){
            //println("dis con id " + _id + "  " +distancia);
            PVector Froz = PVector.mult(_v, -Kd);
            float fuerza = Ka * (_q * veci._q) / distancia;
            PVector F = PVector.mult(d.normalize(), fuerza);
            _F = PVector.add(F, Froz); 
            //println("solo f id " + _id + "  " + _F);
         }
         _F = PVector.add(_F,this.getForce());
         //println("_f total con id " + _id + "  " + _F);
      }
      _a = PVector.div(_F, _m);
      _v = PVector.add(_v, PVector.mult(_a, timeStep));
      _s = PVector.add(_s, PVector.mult(_v, timeStep));
   }
   

   void updateForce(Particle veci)
   {
      boolean continuar;
      //Ver que no sea la mismo particula
      PVector Froz = PVector.mult(_v, -Kd);
      PVector r = PVector.sub(_s, veci._s);
      float fuerza = Ka * (_q * veci._q) / abs(r.mag());
      PVector F = PVector.mult(r.normalize(), fuerza);
      _F = PVector.add(F, Froz);
   }

   void particleCollision(float timeStep)
   {
      // 
      //
      //
   }

   void render()
   {
      noStroke();
      fill(_color);
      circle(_s.x, _s.y, _radius);
   }
}
