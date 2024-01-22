//
int i = 0; // animation iteration
int max_len = 0; // longest sequence length
ArrayList<IntList> sequences = new ArrayList<IntList>();
ArrayList<Integer> sequence_colours = new ArrayList<Integer>();

//Aesthetics
int window_width = 1080;
int window_height = 1080;
float origin_x = 0.2; // 
float origin_y = 0.5;
int scaling = 1; // scale down animations in case your monitor is too small
float line_len = 10/scaling; // length between numbers on a branch
int line_alpha = 50;
float angle = 0.15; // angle between numbers on a branch
int num_sequences = 20000;


void settings() {
  size(window_width/scaling, window_height/scaling);
}

void setup() {
  background(10);
  strokeWeight(2);
  for (int seed=1; seed<num_sequences+1; seed++) {
    IntList sequence = collatz_thread(seed); // generate collatz sequence
    sequence.reverse();
    sequences.add(sequence);
    if (sequence.size() > max_len) {
      max_len = sequence.size();
    }
    
    // Custom colours
    int final_val = sequence.get(sequence.size()-1);
    int sequence_colour;
    if (final_val%2==1) {
      sequence_colour = #FF0D00; //red
    } else {
      sequence_colour = #08FF05; //green
    }
    
    // Random colours
    //int r = int(random(0,255));
    //int g = int(random(0,255));
    //int b = int(random(0,255));
    //int sequence_colour = dec_to_colour(r, g, b);
    
    sequence_colours.add(sequence_colour);
    
  }
  println("Animating", sequences.size(), "sequences");
}

void draw() { 
  // each time draw() is called, one iteration of the sequence is animated, i.e.
  // each collatz thread is extended by one step
  for (int sequence_idx=0; sequence_idx<sequences.size()-1; sequence_idx++) {
    resetMatrix(); // returns drawing tool to origin
    translate(origin_x*width, origin_y*height); // move start of each thread to the same location
    rotate(PI/2); // start angle rotation
    
    IntList sequence = sequences.get(sequence_idx);
    if (sequence.size() > i) { // reach end position of sequence drawn so far
      noStroke();
      for (int j=0; j<i; j++) {
        int val = sequence.get(j);
        val_rotation(val);
        translate(0, -line_len);
      }
      int final_val = sequence.get(i);
      val_rotation(final_val);
      stroke(sequence_colours.get(sequence_idx), line_alpha);
      line(0, 0, 0, -line_len); // draw 'vertical' line
    }
  }
  // Video (Uncomment to save frames)
  //println("Frame", i, "saved");
  //saveFrame("frames/####.png");
  
  i++;
  if (i>=max_len) {
    noLoop();
    println("Finished");
  }
}


void val_rotation(int val) {
  // rotate on mod 2
  if (val%2==0) {
    rotate(angle);
  } else {
    rotate(-angle);
  }
  
  // rotate on mod 3 (useful for angle=PI/2)
  //if (val%3==1) {
  //  rotate(angle);
  //} else if (val%3==2){
  //  rotate(-angle);
  //}
  
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
