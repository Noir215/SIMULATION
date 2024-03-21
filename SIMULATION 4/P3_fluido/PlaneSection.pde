// Class for a plane section in 2D
class PlaneSection
{
   boolean _inverted;
   PVector _pos1;
   PVector _pos2;
   PVector _normal;
   float[] _coefs = new float[4];

   // Constructor to make a plane from two points (assuming Z = 0)
   // The two points define the edges of the finite plane section
   PlaneSection(float x1, float y1, float x2, float y2, boolean invert)
   {
      _pos1 = new PVector(x1, y1);
      _pos2 = new PVector(x2, y2);

      setCoefficients();
      _inverted = invert;
      calculateNormal();
   }

   PVector getPoint1()
   {
      return _pos1;
   }

   PVector getPoint2()
   {
      return _pos2;
   }

   void setCoefficients()
   {
      PVector v = new PVector(_pos2.x - _pos1.x, _pos2.y - _pos1.y, 0.0);
      PVector z = new PVector(_pos2.x - _pos1.x, _pos2.y - _pos1.y, 1.0);

      _coefs[0] = v.y*z.z - z.y*v.z;
      _coefs[1] = -(v.x*z.z - z.x*v.z);
      _coefs[2] = v.x*z.y - z.x*v.y;
      _coefs[3] = -_coefs[0]*_pos1.x - _coefs[1]*_pos1.y - _coefs[2]*_pos1.z;
   }

   void calculateNormal()
   {
      _normal = new PVector(_coefs[0], _coefs[1], _coefs[2]);
      _normal.normalize();

      if (_inverted)
         _normal.mult(-1);
   }

   float getDistance(PVector p)
   {
      float d = (_coefs[0]*p.x + _coefs[1]*p.y + _coefs[2]*p.z + _coefs[3]) / (sqrt(_coefs[0]*_coefs[0] + _coefs[1]*_coefs[1] + _coefs[2]*_coefs[2]));
      return abs(d);
   }

   boolean checkSide(PVector p)
   {
      float d = (_coefs[0]*p.x + _coefs[1]*p.y + _coefs[2]*p.z + _coefs[3]) / (sqrt(_coefs[0]*_coefs[0] + _coefs[1]*_coefs[1] + _coefs[2]*_coefs[2]));
      println( "check side: " + d);
      if (_inverted)
         return (d < 0.0);
      else
         return (d > 0.0);
   }

   boolean checkLimits(PVector p)
   {
      PVector s1 = PVector.sub(_pos1, p).normalize();
      PVector s2 = PVector.sub(_pos2, p).normalize();
      PVector s3 = PVector.sub(_pos2, _pos1).normalize();

      float dot12 = PVector.dot(s1, s3);
      float dot13 = PVector.dot(s1, s2);

      println( "check limits: " + abs(dot12) + " 13:  " + abs(dot13));
      println( "wt : " + sqrt(2)*0.5);
      if ((abs(dot12) >= sqrt(2)*0.5) || (abs(dot13) >= sqrt(2)*0.5))
         return false;
      else
         return true;
   }
   
   PVector getNormal()
   {
      return _normal;
   }

   void render()
   {
      stroke(0, 0, 0);
      strokeWeight(4);
      line(_pos1.x, _pos1.y, _pos2.x, _pos2.y);

      float cx = _pos1.x*0.5 + _pos2.x*0.5;
      float cy = _pos1.y*0.5 + _pos2.y*0.5;

      line(cx, cy, cx + 5.0*_normal.x, cy + 5.0*_normal.y);
   }

   // Check if a point is inside the plane section
   /*
   boolean isInside(PVector p, float r)
   {

      if (checkSide(p) && checkLimits(p))
      {
         if (getDistance(p) <= r)
            return true;
         else
            return false;
      }
      else
         return false;
   }
   */
   Boolean inside(PVector p){
    
    Boolean colision = false;
    
    if(_pos1.x < _pos2.x){//Caso de izquierda a derecha
      if(_pos1.y > _pos2.y){//Caso de abajo a arriba
         if( (p.x >= _pos1.x && p.x <= _pos2.x) && (p.y >= _pos2.y && p.y <= _pos1.y))
            colision = true;
      }else if(_pos1.y < _pos2.y){//Caso de arriba a abajo
        if( (p.x >= _pos1.x && p.x <= _pos2.x) && (p.y >= _pos1.y && p.y <= _pos2.y))
            colision = true;
      }else if(_pos1.y == _pos2.y){//Caso horizontal
        if( (p.x >= _pos1.x && p.x <= _pos2.x) && (p.y >= _pos1.y || p.y <= _pos2.y))
            colision = true;
      }
    } else if(_pos1.x == _pos2.x){ //Laterales verticales
      if( (p.x >= _pos1.x || p.x <= _pos2.x) && (p.y >= _pos1.y && p.y <= _pos2.y))
            colision = true;
    }
    return colision;
  }

}
