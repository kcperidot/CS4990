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
   ArrayList<MazeCell> frontier;
   
   Map()
   {
      walls = new ArrayList<Wall>();
   }
  
   
   
   //void generate(int which)
   void generate(int size)
   {
      walls.clear();
      mazecells = new ArrayList<ArrayList<MazeCell>>();
      int rows = 800/size;
      int cols = 600/size;
      
      
      // CREATE MAZE CELLS
      for(int i = 0; i < rows; i++) { // width
      ArrayList<MazeCell> mazecellrow = new ArrayList<MazeCell>();
      
        for(int j = 0; j < cols; j++) { // height
          mazecellrow.add(new MazeCell(i, j, new PVector(size*(i+0.5), size*(j+0.5)) ) );
          
          // it was art and it was beautiful
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
      
      
      // GENERATE GRAPH
      frontier = new ArrayList<MazeCell>();
      
      // add random cell to frontier
      MazeCell curCel = mazecells.get(int(random(rows))).get(int(random(cols)));
      curCel.visited = true;
      frontier.add(curCel);
      
      int r = curCel.row;
      int c = curCel.col;
      if(r-1 >= 0) // add top neighbor (if exists + unvisited)
      {
        MazeCell newCel = mazecells.get(r-1).get(c);
        if(!newCel.visited) {
          frontier.add(newCel);
        }
      }      
      if(c-1 >= 0) // add left neighbot (if exists + unvisited)
      {
        MazeCell newCel = mazecells.get(r).get(c-1);
        if(!newCel.visited) {
          frontier.add(newCel);
        }
      }
      if(c+1 < cols) // add right neighbot (if exists + unvisited)
      {
        MazeCell newCel = mazecells.get(r).get(c+1);
        if(!newCel.visited) {
          frontier.add(newCel);
        }
      }
      if(r+1 < rows) // add bottom neighbor (if exists + unvisited)
      {
        MazeCell newCel = mazecells.get(r+1).get(c);
        if(!newCel.visited) {
          frontier.add(newCel);
        }
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
      
      /*for(ArrayList<MazeCell> r : mazecells) {
        for(MazeCell c : r) {
          c.draw();
        }
      }*/
      
      for(MazeCell m : frontier) {
        m.draw();
      }
   }
}

class MazeCell
{
  boolean visited = false;
  ArrayList<MazeCell> neighbors = new ArrayList<MazeCell>();
  int row;
  int col;
  PVector center;
  
  MazeCell() {   
  }
  
  MazeCell(int row, int col, PVector center) {
    this.row = row;
    this.col = col;
    this.center = center;
  }
  
  // idk
  void draw() {
    stroke(23, 255, 23);
    circle(center.x, center.y, 5);
  }
}
