/// In this file, you will have to implement seek and waypoint-following
/// The relevant locations are marked with "TODO"

class Crumb
{
  PVector position;
  Crumb(PVector position)
  {
     this.position = position;
  }
  void draw()
  {
     fill(255);
     noStroke(); 
     circle(this.position.x, this.position.y, CRUMB_SIZE);
  }
}

class Boid
{
   Crumb[] crumbs = {};
   int last_crumb;
   float acceleration;
   float rotational_acceleration;
   KinematicMovement kinematic;
   PVector target;
   
   float v = 0;
   float radius = 100; // waypoint tolerance
   
   Boid(PVector position, float heading, float max_speed, float max_rotational_speed, float acceleration, float rotational_acceleration)
   {
     this.kinematic = new KinematicMovement(position, heading, max_speed, max_rotational_speed);
     this.last_crumb = millis();
     this.acceleration = acceleration;
     this.rotational_acceleration = rotational_acceleration;
   }

   void update(float dt)
   {
     if (target != null)
     {  
        // TODO: Implement seek here      
        // Rotational velocity
        float rv = kinematic.max_speed;
        float tr = atan2(target.y - kinematic.position.y, target.x - kinematic.position.x);
        float dr = normalize_angle_left_right(tr - kinematic.getHeading());
        if (dr < 0) rv = -kinematic.max_speed;
        if (abs(dr) < 0) 
           rv = 0;
        // Linear velocity
        if (v < kinematic.max_speed)
           //v += acceleration*dt; // TODO: accelerate FASTER bro
           v += 20*dt; // note: dt makes it CRAWL when it starts; 4 is ok but it doesn't ACCELERATE
        if (PVector.sub(kinematic.position, target).mag() < radius) {
          println("within range " + v);
          if ( v > 4) {
             //v = 0;
             //v -= acceleration*dt;
             v -= acceleration*dt * 40;
             //println(v);
          } else {
            v = 0; // set to 0
            kinematic.setSpeed(0,0);
          }            
        }
        kinematic.increaseSpeed(v, rv);
     }
     
     // place crumbs, do not change     
     if (LEAVE_CRUMBS && (millis() - this.last_crumb > CRUMB_INTERVAL))
     {
        this.last_crumb = millis();
        this.crumbs = (Crumb[])append(this.crumbs, new Crumb(this.kinematic.position));
        if (this.crumbs.length > MAX_CRUMBS)
           this.crumbs = (Crumb[])subset(this.crumbs, 1);
     }
     
     // do not change
     this.kinematic.update(dt);
     
     draw();
   }
   
   void draw()
   {
     for (Crumb c : this.crumbs)
     {
       c.draw();
     }
     
     // Radius for clicks
     if(target != null) {
       fill(0, 255, 0, 80);
       circle(target.x, target.y, radius); 
     }
     
     fill(255);
     noStroke(); 
     float x = kinematic.position.x;
     float y = kinematic.position.y;
     float r = kinematic.heading;
     circle(x, y, BOID_SIZE);
     // front
     float xp = x + BOID_SIZE*cos(r);
     float yp = y + BOID_SIZE*sin(r);
     
     // left
     float x1p = x - (BOID_SIZE/2)*sin(r);
     float y1p = y + (BOID_SIZE/2)*cos(r);
     
     // right
     float x2p = x + (BOID_SIZE/2)*sin(r);
     float y2p = y - (BOID_SIZE/2)*cos(r);
     triangle(xp, yp, x1p, y1p, x2p, y2p);
     
   } 
   
   void seek(PVector target)
   {
      this.target = target;   
   }
   
   void follow(ArrayList<PVector> waypoints)
   {
      // TODO: change to follow *all* waypoints
      this.target = waypoints.get(0);
      
   }
   
}
