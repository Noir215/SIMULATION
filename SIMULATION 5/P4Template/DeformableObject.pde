import java.util.TreeMap;

public class DeformableObject
{
    int _numNodesX;   // Number of nodes in X direction
    int _numNodesY;   // Number of nodes in Y direction
    int _numNodesZ;   // Number of nodes in Z direction
    
    float _sepX;      // Separation of the object's nodes in the X direction (m)
    float _sepY;      // Separation of the object's nodes in the Y direction (m)
    float _sepZ;      // Separation of the object's nodes in the Z direction (m)
    
    //float _lengthX;   //Length of the object n the x dierection (m)
    
    SpringLayout _springLayout;   // Physical layout of the springs that define the surface of each layer
    color _color;                 // Color (RGB)
    
    Particle[][][] _nodes;                             // Particles defining the object
    ArrayList<DampedSpring> _springs;                  // Springs joining the particles
    
    TreeMap<String, DampedSpring> _springsCollision;   // Springs for collision handling
    PVector _airForce;
    
    DeformableObject(int numNodesX, int numNodesY, int numNodesZ, float sepX, float sepY, float sepZ, SpringLayout springLayout, float n_mass, PVector airForce)
    {
        _numNodesX = numNodesX;
        _numNodesY = numNodesY;
        _numNodesZ = numNodesZ;
        
        _sepX = sepX;
        _sepY = sepY;
        _sepZ = sepZ;
        
        _airForce = airForce;
        
        _color = OBJ_COLOR;
        
        _nodes = new Particle[_numNodesX][_numNodesY][_numNodesZ];
        
        _springLayout = springLayout;
        
        _springsCollision = new TreeMap<String, DampedSpring>();
        
        _springs = new ArrayList<DampedSpring>();
        setNodes(n_mass);
        
        structureMode();
    }
    
    void structureMode () {
      switch (_springLayout) {
        case STRUCTURAL:
            createStructural();
            break;
        case SHEAR:
            createShear();
            break;
        case BEND: 
            createBend();
            break;
        case STRUCTURAL_AND_SHEAR:
            createStructuralAndShear();
            break;
        case STRUCTURAL_AND_BEND:
            createStructuralAndBend();
            break;
        case SHEAR_AND_BEND:
            createShearAndBend();
            break;  
        case STRUCTURAL_AND_SHEAR_AND_BEND:
            createStructuralAndShearAndBend();
            break;
      }
    }
    
    int getNumNodes()
        {
        return _numNodesX * _numNodesY * _numNodesZ;
    }
    
    int getNumSprings()
        {
        return _springs.size();
    }
    
    void update(float simStep)
        {
        int i, j, k;
        
        for (i = 0; i < _numNodesX; i++)
            for (j = 0; j < _numNodesY; j++)
              for (k = 0; k < _numNodesZ; k++)
                if (_nodes[i][j][k] != null)
                    _nodes[i][j][k].update(simStep);
        
        for (DampedSpring s : _springs) 
            {
            s.update(simStep);
            s.applyForces();
        }
        
        for (DampedSpring c : _springsCollision.values()) {
            c.update(simStep);
            c.applyForces();
        }
    }

    void collisionDetection(Ball ball)
    {
        for (int i = 0; i < _numNodesX; i++)
        {
            for (int j = 0; j < _numNodesY; j++)
            {
              for (int k = 0; k < _numNodesZ; k++)
              {
                Particle p = _nodes[i][j][k];      
                PVector dist = PVector.sub(ball._s, p._s);
                //Check if the ball is colliding with the node
                if(dist.mag() < ball._r)
                {
                  if(!_springsCollision.containsKey(p.getId() + "," + ball.getId())) {
                    DampedSpring col = new DampedSpring(ball, p, KE_z, KD_z, _airForce);
                    _springsCollision.put(p.getId() + "," + ball.getId(), col);
                  }
                }
                else {
                    _springsCollision.remove(p.getId() + "," + ball.getId());
                }
              }
            }  
        }
    }
    
    void setNodes(float mass)
        {
        float p_x, p_y, p_z;
        boolean fixed = false;
        for (int i = 0; i < _numNodesX; i++)
            {
            for (int j = 0; j < _numNodesY; j++)
                {
                for (int k = 0; k < _numNodesZ; k++)
                    {
                    p_x = i * (_sepX/_numNodesX) - _sepX/2;
                    p_y = j * (_sepY/_numNodesY) - _sepY/2;
                    p_z = k * (_sepZ/_numNodesZ) - _sepZ/2;
                    if(((i == 0) || (i == _numNodesX - 1)) || ((j == 0) || (j == _numNodesY - 1)) || ((k == 0)))
                        fixed = true;
                    else
                        fixed = false;
                    
                    _nodes[i][j][k] = new Particle(new PVector(p_x, p_y, p_z), new PVector(0, 0, 0), mass, false, fixed);
                }
            }
        }       
    }

    void createStructural()
        {
        Particle p1, p2, p3, p4;
        for (int i = 0; i < _numNodesX; i++)
            {
            for (int j = 0; j < _numNodesY; j++)
            {
              for (int k = 0; k < _numNodesZ; k++)
              {
                p1 = _nodes[i][j][k];
                if (i < _numNodesX - 1)
                    {
                    p2 = _nodes[i + 1][j][k];
                    _springs.add(new DampedSpring(p1, p2, KE, KD, _airForce));
                }
                if (j < _numNodesY - 1)
                    {
                    p3 = _nodes[i][j + 1][k];
                    _springs.add(new DampedSpring(p1, p3, KE, KD, _airForce));
                }
                if (k < _numNodesZ - 1)
                    {
                    p4 = _nodes[i][j][k + 1];
                    _springs.add(new DampedSpring(p1, p4, KE_z, KD_z, _airForce));
                }
              }
            }
        }
    }
    
    void createShear()
    {
        Particle p1, p2, p3, p4, p5, p6, p7, p8;
        for (int i = 0; i < _numNodesX; i++)
        {
          for (int j = 0; j < _numNodesY; j++)   
          {
            for (int k = 0; k < _numNodesZ; k++)
                {
                if((i < _numNodesX - 1) && (j < _numNodesY - 1))
                {
                  p1 = _nodes[i][j][k];
                  p2 = _nodes[i + 1][j + 1][k];
                  p3 = _nodes[i][j + 1][k];
                  p4 = _nodes[i + 1][j][k];
                  _springs.add(new DampedSpring(p1, p2, KE, KD, _airForce));
                  _springs.add(new DampedSpring(p3, p4, KE, KD, _airForce));
              
                  if ((i < _numNodesX - 1) && (j < _numNodesY - 1) && (k < _numNodesZ - 1))
                      {
                      p1 = _nodes[i][j][k];
                      p2 = _nodes[i + 1][j + 1][k];
                      p3 = _nodes[i][j + 1][k];
                      p4 = _nodes[i + 1][j][k];
                      p5 = _nodes[i][j][k + 1];
                      p6 = _nodes[i + 1][j + 1][k + 1];
                      p7 = _nodes[i][j + 1][k + 1];
                      p8 = _nodes[i + 1][j][k + 1];
                      _springs.add(new DampedSpring(p1, p2, KE, KD, _airForce));
                      _springs.add(new DampedSpring(p3, p4, KE, KD, _airForce));
                      _springs.add(new DampedSpring(p8, p1, KE, KD, _airForce));
                      _springs.add(new DampedSpring(p5, p4, KE, KD, _airForce));
                      _springs.add(new DampedSpring(p5, p3, KE, KD, _airForce));
                      _springs.add(new DampedSpring(p7, p1, KE, KD, _airForce));
                      _springs.add(new DampedSpring(p6, p4, KE, KD, _airForce));
                      _springs.add(new DampedSpring(p7, p2, KE, KD, _airForce));
                      _springs.add(new DampedSpring(p8, p2, KE, KD, _airForce));
                      _springs.add(new DampedSpring(p6, p3, KE, KD, _airForce));
                    
                  }
                }
            } 
          }
        }
    }

    void sscreateShear() {
        Particle p1, p2, p3, p4, p5, p6, p7, p8;
        for (int i = 0; i < _numNodesX; i++) {
            for (int j = 0; j < _numNodesY; j++) {
                for (int k = 0; k < _numNodesZ; k++) {
                    if ((i < _numNodesX - 1 && j < _numNodesY - 1 )) {
                        p1 = _nodes[i][j][k];
                        p2 = _nodes[i + 1][j + 1][k];
                        p3 = _nodes[i][j + 1][k];
                        p4 = _nodes[i + 1][j][k];
                        _springs.add(new DampedSpring(p1, p2, KE, KD, _airForce));
                        _springs.add(new DampedSpring(p3, p4, KE, KD, _airForce));
                    }
                    if ((i < _numNodesX - 1 && j < _numNodesY - 1 && k < _numNodesZ - 1)) {
                        p1 = _nodes[i][j][k];
                        p2 = _nodes[i + 1][j + 1][k];
                        p3 = _nodes[i][j + 1][k];
                        p4 = _nodes[i + 1][j][k];
                        p5 = _nodes[i][j][k + 1];
                        p6 = _nodes[i + 1][j + 1][k + 1];
                        p7 = _nodes[i][j + 1][k + 1];
                        p8 = _nodes[i + 1][j][k + 1];

                        _springs.add(new DampedSpring(p1, p2, KE, KD, _airForce));
                        _springs.add(new DampedSpring(p3, p4, KE, KD, _airForce));
                        _springs.add(new DampedSpring(p2, p5, KE, KD, _airForce));
                        _springs.add(new DampedSpring(p1, p6, KE, KD, _airForce));
                        _springs.add(new DampedSpring(p3, p8, KE, KD, _airForce));
                        _springs.add(new DampedSpring(p4, p7, KE, KD, _airForce));
                    }
                }
            }
        }
    }

    void createBend() {
        Particle p1, p2, p3, p4;
        
        for (int i = 0; i < _numNodesX; i++) {
            for (int j = 0; j < _numNodesY; j++) {
                for (int k = 0; k < _numNodesZ; k++) {
                    p1 = _nodes[i][j][k];
                    
                    if (i <= _numNodesX - 2) {
                        if( i == _numNodesX - 2 ){
                            p2 = _nodes[i + 1][j][k];
                        }
                        else{
                            p2 = _nodes[i + 2][j][k];
                        }
                        _springs.add(new DampedSpring(p1, p2, KE, KD, _airForce));
                    }
                    
                    if (j <= _numNodesY - 2) {
                        if( j == _numNodesY - 2 )
                            p3 = _nodes[i][j + 1][k];
                        else
                            p3 = _nodes[i][j + 2][k];
                        _springs.add(new DampedSpring(p1, p3, KE, KD, _airForce));
                    }
                    
                    if (k <= _numNodesZ - 2) {
                        if( k == _numNodesZ - 2 )
                            p4 = _nodes[i][j][k + 1];
                        else
                            p4 = _nodes[i][j][k + 2];
                        _springs.add(new DampedSpring(p1, p4, KE, KD, _airForce));
                    }
                }
            }
        }
    }

    void createStructuralAndShear()
        {
        Particle p1, p2, p3, p4, p5, p6, p7, p8;
        for (int i = 0; i < _numNodesX; i++)
            {
          for(int j = 0; j < _numNodesY; j++)
          {
            for (int k = 0; k < _numNodesZ; k++)
            {
              p1 = _nodes[i][j][k];
              if (i < _numNodesX - 1)
                  {
                  p2 = _nodes[i + 1][j][k];
                  _springs.add(new DampedSpring(p1, p2, KE, KD, _airForce));
              }
              if (j < _numNodesY - 1)
                  {
                  p3 = _nodes[i][j + 1][k];
                  _springs.add(new DampedSpring(p1, p3, KE, KD, _airForce));
              }
              if (k < _numNodesZ - 1)
                  {
                  p4 = _nodes[i][j][k + 1];
                  _springs.add(new DampedSpring(p1, p4, KE, KD, _airForce));
              }

              if ((i < _numNodesX - 1) && (j < _numNodesY - 1))
              {
                  p1 = _nodes[i][j][k];
                  p2 = _nodes[i + 1][j + 1][k];
                  p3 = _nodes[i][j + 1][k];
                  p4 = _nodes[i + 1][j][k];
        
                  _springs.add(new DampedSpring(p1, p2, KE, KD, _airForce));
                  _springs.add(new DampedSpring(p3, p4, KE, KD, _airForce));
              }
              if ((i < _numNodesX - 1) && (j < _numNodesY - 1) && (k < _numNodesZ - 1))
              {
                  p1 = _nodes[i][j][k];
                  p2 = _nodes[i + 1][j + 1][k];
                  p3 = _nodes[i][j + 1][k];
                  p4 = _nodes[i + 1][j][k];
                  p5 = _nodes[i][j][k + 1];
                  p6 = _nodes[i + 1][j + 1][k + 1];
                  p7 = _nodes[i][j + 1][k + 1];
                  p8 = _nodes[i + 1][j][k + 1];
        
                  _springs.add(new DampedSpring(p1, p2, KE, KD, _airForce));
                  _springs.add(new DampedSpring(p3, p4,KE, KD, _airForce));
                  _springs.add(new DampedSpring(p2, p5, KE, KD, _airForce));
                  _springs.add(new DampedSpring(p1, p6, KE, KD, _airForce));
                  _springs.add(new DampedSpring(p3, p8, KE, KD, _airForce));
                  _springs.add(new DampedSpring(p4, p7, KE, KD, _airForce));
              }
            }
          }
        }
    }

    void createStructuralAndBend(){
         Particle p1, p2, p3, p4, p5, p6, p7, p8;
         for (int i = 0; i < _numNodesX; i++)
            {
            for(int j = 0; j < _numNodesY; j++)
            {
                for (int k = 0; k < _numNodesZ; k++)
                    {
                    p1 = _nodes[i][j][k];
                    if (i < _numNodesX - 1)
                    {
                        p2 = _nodes[i + 1][j][k];
                        _springs.add(new DampedSpring(p1, p2, KE, KD, _airForce));
                    }
                    if (j < _numNodesY - 1)
                        {
                        p3 = _nodes[i][j + 1][k];
                        _springs.add(new DampedSpring(p1, p3,KE, KD, _airForce));
                    }
                    if (k < _numNodesZ - 1)
                        {
                        p4 = _nodes[i][j][k + 1];
                        _springs.add(new DampedSpring(p1, p4, KE, KD, _airForce));
                    }
                    if (i < _numNodesX - 2)
                        {
                        p5 = _nodes[i + 2][j][k];
                        _springs.add(new DampedSpring(p1, p5, KE, KD, _airForce));
                    }
                    if (j < _numNodesY - 2)
                        {
                        p6 = _nodes[i][j + 2][k];
                        _springs.add(new DampedSpring(p1, p6,KE, KD, _airForce));
                    }
                    if (k < _numNodesZ - 2)
                        {
                        p7 = _nodes[i][j][k + 2];
                        _springs.add(new DampedSpring(p1, p7, KE, KD, _airForce));
                    }
                }
            }
        }
    }

    void createShearAndBend(){
        Particle p1, p2, p3, p4, p5, p6, p7, p8;
        for (int i = 0; i < _numNodesX; i++) {
            for (int j = 0; j < _numNodesY; j++) {
                for (int k = 0; k < _numNodesZ; k++) {
                    p1 = _nodes[i][j][k];
                    
                    if (i <= _numNodesX - 2) {
                        if( i == _numNodesX - 2 ){
                            p2 = _nodes[i + 1][j][k];
                        }
                        else{
                            p2 = _nodes[i + 2][j][k];
                        }
                        _springs.add(new DampedSpring(p1, p2, KE, KD, _airForce));
                    }
                    
                    if (j <= _numNodesY - 2) {
                        if( j == _numNodesY - 2 )
                            p3 = _nodes[i][j + 1][k];
                        else
                            p3 = _nodes[i][j + 2][k];
                        _springs.add(new DampedSpring(p1, p3, KE, KD, _airForce));
                    }
                    
                    if (k <= _numNodesZ - 2) {
                        if( k == _numNodesZ - 2 )
                            p4 = _nodes[i][j][k + 1];
                        else
                            p4 = _nodes[i][j][k + 2];
                        _springs.add(new DampedSpring(p1, p4, KE, KD, _airForce));
                    }

                    if((i < _numNodesX - 1) && (j < _numNodesY - 1))
                    {
                        p1 = _nodes[i][j][k];
                        p2 = _nodes[i + 1][j + 1][k];
                        p3 = _nodes[i][j + 1][k];
                        p4 = _nodes[i + 1][j][k];
                        _springs.add(new DampedSpring(p1, p2, KE, KD, _airForce));
                        _springs.add(new DampedSpring(p3, p4, KE, KD, _airForce));
                
                    if ((i < _numNodesX - 1) && (j < _numNodesY - 1) && (k < _numNodesZ - 1))
                        {
                            p1 = _nodes[i][j][k];
                            p2 = _nodes[i + 1][j + 1][k];
                            p3 = _nodes[i][j + 1][k];
                            p4 = _nodes[i + 1][j][k];
                            p5 = _nodes[i][j][k + 1];
                            p6 = _nodes[i + 1][j + 1][k + 1];
                            p7 = _nodes[i][j + 1][k + 1];
                            p8 = _nodes[i + 1][j][k + 1];
                            _springs.add(new DampedSpring(p1, p2, KE, KD, _airForce));
                            _springs.add(new DampedSpring(p3, p4, KE, KD, _airForce));
                            _springs.add(new DampedSpring(p8, p1, KE, KD, _airForce));
                            _springs.add(new DampedSpring(p5, p4, KE, KD, _airForce));
                            _springs.add(new DampedSpring(p5, p3, KE, KD, _airForce));
                            _springs.add(new DampedSpring(p7, p1, KE, KD, _airForce));
                            _springs.add(new DampedSpring(p6, p4, KE, KD, _airForce));
                            _springs.add(new DampedSpring(p7, p2, KE, KD, _airForce));
                            _springs.add(new DampedSpring(p8, p2, KE, KD, _airForce));
                            _springs.add(new DampedSpring(p6, p3, KE, KD, _airForce));
                            
                        }
                    }
                }
            }
        }
    }

    void createStructuralAndShearAndBend(){
        Particle p1, p2, p3, p4, p5, p6, p7, p8, p9, p10, p11, p12, p13, p14, p15;
        for (int i = 0; i < _numNodesX; i++) {
            for (int j = 0; j < _numNodesY; j++) {
                for (int k = 0; k < _numNodesZ; k++) {
                    p1 = _nodes[i][j][k];
                    
                    if (i < _numNodesX - 1)
                    {
                        p2 = _nodes[i + 1][j][k];
                        _springs.add(new DampedSpring(p1, p2, KE, KD, _airForce));
                    }
                    if (j < _numNodesY - 1)
                        {
                        p3 = _nodes[i][j + 1][k];
                        _springs.add(new DampedSpring(p1, p3,KE, KD, _airForce));
                    }
                    if (k < _numNodesZ - 1)
                        {
                        p4 = _nodes[i][j][k + 1];
                        _springs.add(new DampedSpring(p1, p4, KE, KD, _airForce));
                    }
                    if (i < _numNodesX - 2)
                        {
                        p5 = _nodes[i + 2][j][k];
                        _springs.add(new DampedSpring(p1, p5, KE, KD, _airForce));
                    }
                    if (j < _numNodesY - 2)
                        {
                        p6 = _nodes[i][j + 2][k];
                        _springs.add(new DampedSpring(p1, p6,KE, KD, _airForce));
                    }
                    if (k < _numNodesZ - 2)
                        {
                        p7 = _nodes[i][j][k + 2];
                        _springs.add(new DampedSpring(p1, p7, KE, KD, _airForce));
                    }

                    if((i < _numNodesX - 1) && (j < _numNodesY - 1))
                    {
                        p15 = _nodes[i][j][k];
                        p8 = _nodes[i + 1][j + 1][k];
                        p9 = _nodes[i][j + 1][k];
                        p10 = _nodes[i + 1][j][k];
                        _springs.add(new DampedSpring(p15, p8, KE, KD, _airForce));
                        _springs.add(new DampedSpring(p9, p10, KE, KD, _airForce));
                
                        if ((i < _numNodesX - 1) && (j < _numNodesY - 1) && (k < _numNodesZ - 1))
                        {
                            p15 = _nodes[i][j][k];
                            p8 = _nodes[i + 1][j + 1][k]; //p2
                            p9 = _nodes[i][j + 1][k]; //p3
                            p10 = _nodes[i + 1][j][k]; //p4
                            p11 = _nodes[i][j][k + 1]; //p5
                            p12 = _nodes[i + 1][j + 1][k + 1]; //p6
                            p13 = _nodes[i][j + 1][k + 1]; //p7
                            p14 = _nodes[i + 1][j][k + 1]; //p8
                            _springs.add(new DampedSpring(p15, p8, KE, KD, _airForce));
                            _springs.add(new DampedSpring(p9, p10, KE, KD, _airForce));
                            _springs.add(new DampedSpring(p14, p15, KE, KD, _airForce));
                            _springs.add(new DampedSpring(p11, p10, KE, KD, _airForce));
                            _springs.add(new DampedSpring(p11, p9, KE, KD, _airForce));
                            _springs.add(new DampedSpring(p13, p15, KE, KD, _airForce));
                            _springs.add(new DampedSpring(p12, p10, KE, KD, _airForce));
                            _springs.add(new DampedSpring(p13, p8, KE, KD, _airForce));
                            _springs.add(new DampedSpring(p14, p8, KE, KD, _airForce));
                            _springs.add(new DampedSpring(p12, p9, KE, KD, _airForce));
                                
                        }
                    }
                }
            }
        }

    }

    void render()
        {
        if (DRAW_MODE)
            renderWithSegments();
        else
            renderWithQuads();
    }
    
    void renderWithSegments()
        {
        stroke(0);
        strokeWeight(0.5);
        
        for (DampedSpring s : _springs)
            {
            PVector pos1 = s.getParticle1().getPosition();
            PVector pos2 = s.getParticle2().getPosition();
            
            line(pos1.x, pos1.y,pos1.z, pos2.x, pos2.y, pos2.z);
        }
    }
    
    void renderWithQuads()
        {
        int i, j, k;
        
        fill(_color);
        stroke(0);
        strokeWeight(1.0);
        
        for (j = 0; j < _numNodesY - 1; j++)
            {
            beginShape(QUAD_STRIP);
            for (i = 0; i < _numNodesX; i++)
                {
                if ((_nodes[i][j][0] != null) && (_nodes[i][j + 1][0] != null))
                    {
                    PVector pos1 = _nodes[i][j][0].getPosition();
                    PVector pos2 = _nodes[i][j + 1][0].getPosition();
                    
                    vertex(pos1.x, pos1.y, pos1.z);
                    vertex(pos2.x, pos2.y, pos2.z);
                }
            }
            endShape();
        }
        
        for (j = 0; j < _numNodesY - 1; j++)
            {
            beginShape(QUAD_STRIP);
            for (i = 0; i < _numNodesX; i++)
                {
                if ((_nodes[i][j][_numNodesZ - 1] != null) && (_nodes[i][j + 1][_numNodesZ - 1] != null))
                    {
                    PVector pos1 = _nodes[i][j][_numNodesZ - 1].getPosition();
                    PVector pos2 = _nodes[i][j + 1][_numNodesZ - 1].getPosition();
                    
                    vertex(pos1.x, pos1.y, pos1.z);
                    vertex(pos2.x, pos2.y, pos2.z);
                }
            }
            endShape();
        }
        
        for (j = 0; j < _numNodesY - 1; j++)
            {
            beginShape(QUAD_STRIP);
            for (k = 0; k < _numNodesZ; k++)
                {
                if ((_nodes[0][j][k] != null) && (_nodes[0][j + 1][_numNodesZ - 1] != null))
                    {
                    PVector pos1 = _nodes[0][j][k].getPosition();
                    PVector pos2 = _nodes[0][j + 1][k].getPosition();
                    
                    vertex(pos1.x, pos1.y, pos1.z);
                    vertex(pos2.x, pos2.y, pos2.z);
                }
            }
            endShape();
        }
        
        for (j = 0; j < _numNodesY - 1; j++)
            {
            beginShape(QUAD_STRIP);
            for (k = 0; k < _numNodesZ; k++)
                {
                if ((_nodes[_numNodesX - 1][j][k] != null) && (_nodes[_numNodesX - 1][j + 1][_numNodesZ - 1] != null))
                    {
                    PVector pos1 = _nodes[_numNodesX - 1][j][k].getPosition();
                    PVector pos2 = _nodes[_numNodesX - 1][j + 1][k].getPosition();
                    
                    vertex(pos1.x, pos1.y, pos1.z);
                    vertex(pos2.x, pos2.y, pos2.z);
                }
            }
            endShape();
        }
        
        for (i = 0; i < _numNodesX - 1; i++)
            {
            beginShape(QUAD_STRIP);
            for (k = 0; k < _numNodesZ; k++)
                {
                if ((_nodes[i][0][k] != null) && (_nodes[i + 1][0][k] != null))
                    {
                    PVector pos1 = _nodes[i][0][k].getPosition();
                    PVector pos2 = _nodes[i + 1][0][k].getPosition();
                    
                    vertex(pos1.x, pos1.y, pos1.z);
                    vertex(pos2.x, pos2.y, pos2.z);
                }
            }
            endShape();
        }
        
        for (i = 0; i < _numNodesX - 1; i++)
            {
            beginShape(QUAD_STRIP);
            for (k = 0; k < _numNodesZ; k++)
                {
                if ((_nodes[i][_numNodesY - 1][k] != null) && (_nodes[i + 1][_numNodesY - 1][k] != null))
                    {
                    PVector pos1 = _nodes[i][_numNodesY - 1][k].getPosition();
                    PVector pos2 = _nodes[i + 1][_numNodesY - 1][k].getPosition();
                    
                    vertex(pos1.x, pos1.y, pos1.z);
                    vertex(pos2.x, pos2.y, pos2.z);
                }
            }
            endShape();
        }
    }
}
