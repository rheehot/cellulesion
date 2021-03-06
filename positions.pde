class Positions {
  /* The Positions class does the following:
  *  1) Creates a set of initial positions for all the elements in a population in one of a range of different patterns (random, cartesian etc.)
  *  2) Stores the positions as an array of PVectors independently of the colony object so they can be reused in successive colonies
  *  3) The PVectors are pulled out of the array sequentially as the Colony is populated in the constructor
  */
  
  // TO DO: Consider using noise() for a less random random
  
  // VARIABLES
  PVector[] seedpos;  // 'seedpos' is an array of vectors used for storing the initial positions of all the elements in colony.population
  
  // Constructor (makes a Positions object)
  Positions() {
    seedpos = new PVector[elements];  // Array size matches the size of the population
    randomPos(); // Default mode if no other alternative is selected
    if (verboseMode) {println("Positions has created a seedpos array");}
  }
  
  // Populates the seedpos array in a cartesian grid layout
  void centerPos() {
    for(int element = 0; element<elements; element++) {
      float xpos = width*0.5;
      float ypos = height*0.5;
      seedpos[element] = new PVector(xpos, ypos);
    }
  }
  
  // Populates the seedpos array in a cartesian grid layout
  void gridPos() {
    for(int row = 0; row<rows; row++) {
      for(int col = 0; col<cols; col++) {
        int element = (cols*row) + col;
        float xpos = map (col, 0, cols, -colWidth, width+colWidth) + colWidth; // xpos is in 'canvas space'
        float ypos = map (row, 0, rows, -rowHeight, height+rowHeight) + rowHeight;   // ypos is in 'canvas space'
        //println("Writing to seedpos[" + element + "]  with values xpos=" + xpos + " & ypos=" + ypos);
        seedpos[element] = new PVector(xpos, ypos);
      }
    }
  }
  
  // Populates the seedpos array in a cartesian grid layout
  void scaledGridPos() {
    float widthScale = 1.0; // 1.0 = use 100% of canvas
    float heightScale = widthScale;
    float gridWidth = width * widthScale;
    float gridHeight = height * heightScale;
    float xOffset = (width-gridWidth)*0.5;
    float yOffset = (height-gridHeight)*0.5;
    int element = 0;
    colWidth = gridWidth/cols;
    rowHeight = gridHeight/rows;
    for(int row = 1; row<=rows; row++) {
      for(int col = 1; col<=cols; col++) {
        float xpos = ((col*2)-1)*colWidth*0.5 + xOffset;    // xpos is in 'canvas space'
        float ypos = ((row*2)-1)*rowHeight*0.5  + yOffset;  // ypos is in 'canvas space'
        //println("Writing to seedpos[" + element + "]  with values xpos=" + xpos + " & ypos=" + ypos);
        seedpos[element] = new PVector(xpos, ypos);
        element++;
      }
    }
  }
  
  // Populates the seedpos array in a cartesian grid layout
  void isoGridPos() {
    float widthScale = 1.0; // 1.0 = use 100% of canvas
    float heightScale = widthScale * sqrt(3) * 0.5;
    float gridWidth = width * widthScale;
    float gridHeight = height * heightScale;
    float xOffset = (width-gridWidth)*0.5;
    float yOffset = (height-gridHeight)*0.5;
    int element = 0;
    colWidth = gridWidth/cols;
    rowHeight = gridHeight/rows;
    for(int row = 1; row<=rows; row++) {
      for(int col = 1; col<=cols; col++) {
        float xpos = ((col*2)-1)*colWidth*0.5 + xOffset;    // xpos is in 'canvas space'
        if (isOdd(row)) {xpos += colWidth*0.5;}
        float ypos = ((row*2)-1)*rowHeight*0.5  + yOffset;  // ypos is in 'canvas space'
        //println("Writing to seedpos[" + element + "]  with values xpos=" + xpos + " & ypos=" + ypos);
        seedpos[element] = new PVector(xpos, ypos);
        element++;
      }
    }
  }
  
  // Populates the seedpos array in a cartesian grid layout
  void offsetGridPos() {
    float rowOffIso = colWidth * (sqrt(3))/2;
    for(int row = 0; row<rows; row++) {
      for(int col = 0; col<cols; col++) {
        int element = (cols*row) + col;
        float xpos = map (col, 0, cols, -colWidth, width+colWidth) + colWidth; // xpos is in 'canvas space'
        if (isOdd(row)) {xpos += colWidth;}
        float ypos = map (row, 0, rows, -rowOffIso, height+rowOffIso) + rowOffIso;   // ypos is in 'canvas space'
        //println("Writing to seedpos[" + element + "]  with values xpos=" + xpos + " & ypos=" + ypos);
        seedpos[element] = new PVector(xpos, ypos);
      }
    }
  }
  
  // Populates the seedpos array with random values
  void randomPos() {
    for(int element = 0; element<elements; element++) {
      float xpos = random(width);
      float ypos = random(height);
      //println("Writing to seedpos[" + element + "]  with values xpos=" + xpos + " & ypos=" + ypos);
      seedpos[element] = new PVector(xpos, ypos);
    }
  }
  
  // Populates the seedpos array in a phyllotaxic spiral
  void phyllotaxicPos() {
    float c = w * 0.011;
    for (int element = 0; element<elements; element++) {    
      // Simple Phyllotaxis formula:
      float angle = element * radians(137.5);
      float radius = c * sqrt(element);   
      float xpos = radius * cos(angle) + width * 0.5;
      float ypos = radius * sin(angle) + height * 0.5;
      seedpos[element] = new PVector(xpos, ypos);
      c *= 1.004;
      //c += width * 0.0002;
    }
  }
  
  // Populates the seedpos array in a phyllotaxic spiral
  void phyllotaxicPos2() {
    float c = w * 0.1;
    for (int element = 0; element<elements; element++) {    
      // Simple Phyllotaxis formula:
      float angle = element * radians(137.5);
      float radius = c * sqrt(element);   
      float xpos = radius * cos(angle) + width * 0.5;
      float ypos = radius * sin(angle) + height * 0.5;
      seedpos[element] = new PVector(xpos, ypos);
      c *= 0.99;
      //c -= width * 0.0005;
    }
  }
  
  // Populates the seedpos array with positions randomly selected from the nodepositions array (cell starts at a node)
  void posFromRandomNode() {
    for (int element = 0; element<elements; element++) {
      int randomNodeID = int(random(nodecount));
      float xpos = nodepositions.nodeseedpos[randomNodeID].x;
      float ypos = nodepositions.nodeseedpos[randomNodeID].y;
      seedpos[element] = new PVector(xpos, ypos);
      println("Cell " + element + " is located at node " + randomNodeID);
    }
  }
  
  // Populates the seedpos array with positions randomly selected from the nodepositions array (cell starts at a node)
  void posFromSameRandomNode() {
    int randomNodeID = int(random(nodecount));
    for (int element = 0; element<elements; element++) {
      float xpos = nodepositions.nodeseedpos[randomNodeID].x;
      float ypos = nodepositions.nodeseedpos[randomNodeID].y;
      seedpos[element] = new PVector(xpos, ypos);
    }
  }
  
  // Populates the seedpos array with positions randomly selected from the nodepositions array (cell starts at a node)
  void posFromMiddleNode() {
    int middleNodeID = int(nodecount * 0.6);
    for (int element = 0; element<elements; element++) {
      float xpos = nodepositions.nodeseedpos[middleNodeID].x;
      float ypos = nodepositions.nodeseedpos[middleNodeID].y;
      seedpos[element] = new PVector(xpos, ypos);
    }
  }
  
  //Test if a number is even:
  boolean isEven(int n){
    return n % 2 == 0;
  }
  
  //Test if a number is odd:
  boolean isOdd(int n){
    return n % 2 != 0;
  }

}
