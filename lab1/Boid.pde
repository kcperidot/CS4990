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
   float radius = 10; // waypoint tolerance
   float slowdown = radius * 10; // *7;
   ArrayList<PVector> waypoints;   
   
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
        
        // v is preserved between calls!!!!!
        
        // Rotational velocity
        float rv = kinematic.max_speed;
        float tr = atan2(target.y - kinematic.position.y, target.x - kinematic.position.x);
        float dr = normalize_angle_left_right(tr - kinematic.getHeading());
        if (dr < 0) rv = -kinematic.max_speed;
        
        // Linear velocity
        int operation = 0;
                        // 0 = no change
                        // 1 = add
                        // 2 = subtract
        float v_factor = 7*dt*radius;
        float old_v = v;
        if (kinematic.getSpeed() < kinematic.max_speed) { // increase speed
           v = v_factor;
           //operation = 1;
        }//*/
        if (PVector.sub(kinematic.position, target).mag() < slowdown) { // if within slowdown range
        
          // if within target range, stop
            // if waypoints etc
          // else slow
          if (PVector.sub(kinematic.position, target).mag() < radius) { // if within radius tolerance
            //print("x");
            if(waypoints != null && waypoints.size() > 1) { // if there are waypoints, go to next one
              waypoints.remove(0);
              seek(waypoints.get(0));
              //v += 4*dt;  
              v = 0;
              //println("TARGET HIT");
            } else if(waypoints == null || waypoints.size() == 1) { // no more waypoints
              v = 0;
              rv = 0;
              kinematic.increaseSpeed(kinematic.getSpeed() * -1, kinematic.getRotationalVelocity() * -1); // stop
            }
          //} else if(kinematic.getSpeed() > v_factor) { // else is in the circle          
          } else if(kinematic.getSpeed() > 20) { // else is in the circle
            //print("a");
            v = -v_factor;
          }
        }
        
        //println(kinematic.getSpeed(), v);
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
     
     // Radius for slowdown
     if(target != null) {
       // slowdown tolerance
       fill(0, 255, 0, 80);
       circle(target.x, target.y, slowdown); 
       
       // target
       fill(50, 255, 50);
       circle(target.x, target.y, radius); 
     }
     if(waypoints != null) {
       for(int i = 1; i < waypoints.size(); i++) {
         fill(0, 255, 0, 50);
         circle(waypoints.get(i).x, waypoints.get(i).y, slowdown); 
       }
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
      this.waypoints = waypoints;
      
   }
   
}
