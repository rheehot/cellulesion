class Velocities {
  /* The Velocities class does the following:
  *  1) Creates a set of initial velocity PVectors for all the elements in a population
  *  2) Stores the values as an array of PVectors independently of the colony object so they can be reused in successive colonies
  *  3) The PVectors are pulled out of the array sequentially as the Colony is populated in the constructor
  */

  // VARIABLES
  PVector[] seedvel;  // 'vMax' is an array of floats used for storing the initial sizes of all the elements in colony.population
    
  // Constructor (makes a Sizes object)
  Velocities() {
    seedvel = new PVector[elements];  // Array size matches the size of the population
    randomVel(); // Default mode if no other alternative is selected
    if (verboseMode) {println("Velocities has created a seedvel array");}
  }

  // Populates the seedpos array with random values
  void randomVel() {
    for(int element = 0; element<elements; element++) {
      PVector v = PVector.random2D();
      seedvel[element] = v;
    }
  }  
  
  // Populates the seedpos array with all velocities identical
  void fixedVel() {
    for(int element = 0; element<elements; element++) {
      float angle = radians(0);
      PVector v = PVector.fromAngle(angle);
      seedvel[element] = v;
    }
  }
  
  void fromCenter() {
    for(int element = 0; element<elements; element++) {
      PVector center = new PVector(width*0.5, height*0.5);
      PVector pos = positions.seedpos[element]; // Get the position of the element for which we are to calculate a value
      PVector v = PVector.sub(pos, center).normalize();
      seedvel[element] = v;
    }
  }
  
  void toCenter() {
    for(int element = 0; element<elements; element++) {
      PVector center = new PVector(width*0.5, height*0.5);
      PVector pos = positions.seedpos[element]; // Get the position of the element for which we are to calculate a value
      PVector v = PVector.sub(center, pos).normalize();
      seedvel[element] = v;
    }
  }

}
