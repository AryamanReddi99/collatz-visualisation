//Global
int i = 0; // animation iteration
ArrayList<IntList> sequences = new ArrayList<IntList>();
ArrayList<Integer> sequence_colours = new ArrayList<Integer>();

//Aesthetics
int window_width = 1080;
int window_height = 1080;
float origin_x = 0.2;
float origin_y = 0.5;
int scaling = 1; // scale down animations in case your monitor is too small
float line_len = 10/scaling; // length between numbers on a branch
int line_alpha = 50;
float angle = 0.15; // angle between numbers on a branch
int num_sequences = 1000;

void settings() {
    size(1080/scaling, 1920/scaling);
}

void setup() {
  background(10);
  strokeWeight(1);
  for (int seed=1; seed<num_sequences+1; seed++) {
    IntList sequence = collatz_thread(seed);
    sequence.reverse();
    sequences.add(sequence);
    
    // Custom colours
    int final_val = sequence.get(sequence.size()-1);
    int sequence_colour;
    if (final_val%2==1) {
      sequence_colour = #FF0D00; // red
    } else {
      sequence_colour = #08FF05; // green
    }
    sequence_colours.add(sequence_colour);
  }
  println("Animating", sequences.size(), "sequences");
}

void draw() {
  // each time draw() is called, one entire collatz thread is animated 
  // from a seed number
  resetMatrix();
  translate(origin_x*width, origin_y*height); // move start of each thread to the same location
  rotate(PI/2); // start angle rotation
  
  IntList sequence = sequences.get(i);
  stroke(sequence_colours.get(i), line_alpha);

  for (int j=0; j<sequence.size(); j++) {
    int val = sequence.get(j);
    if (val%2==0) {
      rotate(angle);
    } else {
      rotate(-angle);
    }
    line(0, 0, 0, -line_len);
    translate(0, -line_len);
  }
  
  // Video (Uncomment to save frames)
  //println("Frame", i, "saved");
  //saveFrame("frames/####.png");

  i++;
  if (i>=num_sequences) {
    noLoop();
    println("finished");
  }
}

int dec_to_colour(int r, int g, int b){
  return color(r,g,b);
}

int collatz(int n) {
  if (n%2 == 0) { // even
    return n/2;
  } else { // odd
    return (n*3+1)/2;
  }
}

IntList collatz_thread(int n) { 
  // return collatz sequence spawned by n until 1 is reached
  IntList sequence = new IntList();
  sequence.append(n);
  while (n!=1) {
    n = collatz(n);
    sequence.append(n);
  }
  return sequence;
}
