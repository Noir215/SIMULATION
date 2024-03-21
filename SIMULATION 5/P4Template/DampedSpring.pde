// Damped spring between two particles:
//
// Fp1 = Fe - Fd
// Fp2 = -Fe + Fd = -(Fe - Fd) = -Fp1
//
//    Fe = Ke·(l - l0)·eN
//    Fd = -Kd·eN·v
//
//    e = s2 - s1  : current elongation vector between the particles
//    l = |e|      : current length
//    eN = |e|/l   : current normalized elongation vector
//    v = dl/dt    : rate of change of length

public class DampedSpring
{
    Particle _p1;   // First particle attached to the spring
    Particle _p2;   // Second particle attached to the spring
    
    float _Ke;      // Elastic constant (N/m)
    float _Kd;      // Damping coefficient (kg/m)
    
    float _l0;      // Rest length (m)
    float _l;       // Current length (m)
    float _v;       // Current rate of change of length (m/s)
    
    PVector _e;     // Current elongation vector (m)
    PVector _eN;    // Current normalized elongation vector (no units)
    PVector _F;     // Force applied by the spring on particle 1 (the force on particle 2 is -_F) (N)
    PVector _airForce;
    
    
    // TODO: Revisar el constructor
    DampedSpring(Particle p1, Particle p2, float Ke, float Kd, PVector airForce) {
        _p1 = p1;
        _p2 = p2;     
        _Ke = Ke;
        _Kd = Kd;

        _e = PVector.sub(_p2.getPosition() , _p1.getPosition());
        _eN = _e.copy().normalize();

        _l = _e.mag();
        _l0 = _l;

        _v = 0;
        _airForce = airForce;
        _F = new PVector(0,0,0);
    }
    
    Particle getParticle1() {
        return _p1;
    }
    
    Particle getParticle2() {
        return _p2;
    }
    
    void update(float simStep)  {
        float lnow = _l;
        float dis = _l - _l0;
        //float dis = _l - _ball.getRadius();
        _e = PVector.sub(_p2.getPosition() , _p1.getPosition());
        //PVector eN = _e.normalize();
        PVector eN = _e.copy().normalize();
        _l = _e.mag();
        _v = (_l - lnow) / simStep;
        PVector _vl = PVector.mult(eN, _v); 
        PVector _Fe = PVector.mult(eN, _Ke * dis);
        PVector _Fd = PVector.mult(_vl, _Kd);
        //_F = PVector.add(_Fe, _Fd);
        //_F.add(_airForce);

        PVector F_aux = PVector.add(_Fe, _Fd);

        _F = PVector.add(F_aux, PVector.mult(_airForce, -1.0));
    }
    
    void applyForces()
    {
        
        _p1.addExternalForce(_F);
        _p2.addExternalForce(PVector.mult(_F, -1.0));
    }
    
}
