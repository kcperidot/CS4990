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
   ArrayList <MazeCell> done;
   
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
          //walls.add(new Wall(new PVector(size*i, size*j),         new PVector(size*(i+1), size*j)));     // WALL1
          //walls.add(new Wall(new PVector(size*(i+1), size*j),     new PVector(size*(i+1), size*(j+1)))); // WALL2
          //walls.add(new Wall(new PVector(size*(i+1), size*(j+1)), new PVector(size*i, size*(j+1))));     // WALL3
          //walls.add(new Wall(new PVector(size*i, size*(j+1)),     new PVector(size*i, size*j)));         // WALL4
        }
        
        mazecells.add(mazecellrow);
      }
      
      
      // GENERATE GRAPH
      frontier = new ArrayList<MazeCell>();
      done = new ArrayList<MazeCell>();
      
      
      MazeCell curCel = mazecells.get(int(random(rows))).get(int(random(cols)));
      frontier.add(curCel);
      //walls.add(new Wall(new PVector(size*curCel.row, size*curCel.col),         new PVector(size*(curCel.row+1), size*curCel.col)));     // WALL1
      //walls.add(new Wall(new PVector(size*(curCel.row+1), size*curCel.col),     new PVector(size*(curCel.row+1), size*(curCel.col+1)))); // WALL2
      //walls.add(new Wall(new PVector(size*(curCel.row+1), size*(curCel.col+1)), new PVector(size*curCel.row, size*(curCel.col+1))));     // WALL3
      //walls.add(new Wall(new PVector(size*curCel.row, size*(curCel.col+1)),     new PVector(size*curCel.row, size*curCel.col)));         // WALL4
    
      while(curCel.visited == false){
      curCel.visited = true;
      done.add(curCel);
      frontier.remove(curCel);
      
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
      // add random cell to frontier
      MazeCell newCel = frontier.get(int(random(frontier.size())));
      for(int j = 0; j < frontier.size(); j++){
      if(newCel.visited == false){
        if(newCel.row - curCel.row == 0 && (newCel.col - curCel.col == -1 || newCel.col - curCel.col == 1)){
        curCel.neighbors.add(newCel);
        newCel.neighbors.add(curCel);        
        }
        if(newCel.col - curCel.col == 0 && (newCel.row - curCel.row == -1 || newCel.row - curCel.row == 1)){
        curCel.neighbors.add(newCel);
        newCel.neighbors.add(curCel);
        }
        
        
        //walls.add(new Wall(new PVector(size*curCel.row, size*curCel.col),         new PVector(size*(curCel.row+1), size*curCel.col)));     // WALL1
        walls.add(new Wall(new PVector(size*(r+1), size*c),     new PVector(size*(r+1), size*(c+1)))); // WALL2
        walls.add(new Wall(new PVector(size*(r+1), size*(c+1)), new PVector(size*r, size*(c+1))));     // WALL3
        //walls.add(new Wall(new PVector(size*curCel.row, size*(curCel.col+1)),     new PVector(size*curCel.row, size*curCel.col)));         // WALL4

        curCel = newCel;
        //print(walls.size());  
        break;
      }else{
        newCel = frontier.get(int(random(frontier.size())));
      }
    }
  }
      
      //choose random wall
      
      //check if node on other side has been visited
      //if not, add connection
      /*MazeCell next = frontier.get((int)random(4));
      if(!next.visited){
        curCel = next;
        next.visited = true;
        frontier.add();
      }*/
      
      //remove wall from frontier
      
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
      
      for(MazeCell m : done) {
        for(MazeCell n : m.neighbors) {
          line(m.center.x, m.center.y, n.center.x, n.center.y);
          //println("i");
        }
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
