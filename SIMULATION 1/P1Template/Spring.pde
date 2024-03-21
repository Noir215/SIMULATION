// Class for a simple spring with no damping
public class Spring
{
   PVector _pos1;   // First end of the spring (m)
   PVector _pos2;   // Second end of the spring (m)
   float _Ke;       // Elastic constant (N/m)
   float _l0;       // Rest length (m)

   PVector _F;      // Force applied by the spring towards pos1 (the force towards pos2 is -_F) (N)
   float _energy;   // Energy (J)
   //

   Spring(PVector pos1, PVector pos2, float Ke, float l0)
   {
      _pos1 = pos1;
      _pos2 = pos2;
      _Ke = Ke;
      _l0 = l0;

      _F = new PVector(0.0, 0.0);
      _energy = 0.0;
      //
   }

   void setPos1(PVector pos1)
   {
      _pos1 = pos1;
   }

   void setPos2(PVector pos2)
   {
      _pos2 = pos2;
   }

   void setKe(float Ke)
   {
      _Ke = Ke;
   }

   void setRestLength(float l0)
   {
      _l0 = l0;
   }

   void update()
   {
      /* Este método debe actualizar todas las variables de la clase 
         que cambien según avanza la simulación, siguiendo las ecuaciones 
         de un muelle sin amortiguamiento.
      */   
      PVector d = PVector.sub(_pos2, _pos1);
      float _la = d.mag();
      d.normalize();
      _F = PVector.mult(d,((_la - _l0) * -_Ke));
      updateEnergy();
   }

   void updateEnergy()
   {
     PVector d = PVector.sub(_pos2, _pos1);
     float _la = d.mag();
     _energy = 0.5 * _Ke* pow(_la - _l0, 2);
   }

   PVector getForce()
   {
      return _F;
   }

   float getEnergy()
   {
      return _energy;
   }
}
