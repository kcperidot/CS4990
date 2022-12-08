class Wall
{
   PVector start;
   PVector end;
   PVector normal;
   PVector direction;
   float len;
   
   Wall(PVector start, PVector end)
   {
      this.start = start;
      this.end = end;
      direction = PVector.sub(this.end, this.start);
      len = direction.mag();
      direction.normalize();
      normal = new PVector(-direction.y, direction.x);
   }
   
   // Return the mid-point of this wall
   PVector center()
   {
      return PVector.mult(PVector.add(start, end), 0.5);
   }
   
   void draw()
   {
       strokeWeight(3);
       line(start.x, start.y, end.x, end.y);
       if (SHOW_WALL_DIRECTION)
       {
          PVector marker = PVector.add(PVector.mult(start, 0.2), PVector.mult(end, 0.8));
          circle(marker.x, marker.y, 5);
       }
   }
}


class Map
{
   ArrayList<Wall> walls;
   ArrayList<ArrayList<MazeCell>> mazecells; // ArrayList of ArrayLists to easier sort MazeCells
   
   Map()
   {
      walls = new ArrayList<Wall>();
   }
  
   
   
   //void generate(int which)
   void generate(int size)
   {
      walls.clear();
      mazecells = new ArrayList<ArrayList<MazeCell>>();
      
      for(int i = 0; i < 800/size; i++) { // width
      ArrayList<MazeCell> mazecellrow = new ArrayList<MazeCell>();
        for(int j = 0; j < 600/size; j++) { // height
          mazecellrow.add(new MazeCell());
          
          // POINT1------POINT2
          //   |           |
          // POINT3------POINT4
            // POINT1 = nw, nh
            // POINT2 = n(w+1), nh
            // POINT3 = nw, n(h+1)
            // POINT4 = n(w+1), n(h+1)
          
          //    * WALL1 *
          // WALL4     WALL2
          //    * WALL3 *
          walls.add(new Wall(new PVector(size*i, size*j),         new PVector(size*(i+1), size*j)));     // WALL1
          walls.add(new Wall(new PVector(size*(i+1), size*j),     new PVector(size*(i+1), size*(j+1)))); // WALL2
          walls.add(new Wall(new PVector(size*(i+1), size*(j+1)), new PVector(size*i, size*(j+1))));     // WALL3
          walls.add(new Wall(new PVector(size*i, size*(j+1)),     new PVector(size*i, size*j)));         // WALL4
        }
        mazecells.add(mazecellrow);
      }
      
   }
   
   void update(float dt)
   {
      draw();
   }
   
   void draw()
   {
      stroke(255);
      strokeWeight(3);
      for (Wall w : walls)
      {
         w.draw();
      }
   }
}

class MazeCell
{
  boolean visited = false;
  ArrayList<MazeCell> neighbors = new ArrayList<MazeCell>();
}
