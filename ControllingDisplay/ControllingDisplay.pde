import controlP5.*;
import processing.serial.*;
import static javax.swing.JOptionPane.*;


ControlP5 cp5;
CheckBox checkbox;
int myColorBackground;

int delay = 500;
int i =  0;
int time;



    final boolean debug = true;
Serial myPort;  // Create object from Serial class
Serial myRadioButtonPort;  // Create object from Serial class

int val;      // Data received from the serial port
RadioButton r1;
void setup() {
  mySerialSetup();
  delay(100);

  size(700,700, P3D);
  frameRate(30);
    surface.setTitle("DISPLAY CONTROL");
  surface.setResizable(true);

  noStroke();
  cp5 = new ControlP5(this);
  cp5.addSlider("DELAY")
     .setPosition(100,height/1.5)
     .setSize(int(width/1.4),20)
     .setRange(300,10000)
     .setValue(500)
     .setFont(createFont("Verdana",30))
      .setCaptionLabel("ANIMATION DELAY* (ms):")
      .getCaptionLabel().align(ControlP5.LEFT, ControlP5.TOP_OUTSIDE).setPaddingX(0);

  
  // reposition the Label for controller 'slider'
  cp5.getController("DELAY").getValueLabel().align(ControlP5.LEFT, ControlP5.BOTTOM_OUTSIDE).setPaddingX(0);
  
checkbox = cp5.addCheckBox("checkBox")
                .setPosition(100, 200)
                .setSize(40, 40)
                .setItemsPerRow(3)
                     .setFont(createFont("Verdana",30))

                .setSpacingColumn(100)
                .setSpacingRow(20)

                ;
                


   time = millis();
   

}
void draw() {
  background(0);
  fill(255);

  rect(0,20,width,height/10);
  textSize(50);
  fill(0);
  text("CONTROL BOARD", width/8, height/10); 
  fill(255);
  textSize(12);
  text("*To disable animation close this program", width/8, height-100);
  
   if(millis() > time + delay) {

   //       6
 //       _
 //    1 |_| 5
 //       0
 //    2 |_| 4
 //       3
 
   
  myPort.write(0x80);
  myPort.write(0x83);
  myPort.write(0x00);
  for (int z=0; z<=7; z++){
    myPort.write(byte(random(z)+i+z));

  }
  myPort.write(78);
  myPort.write(126);
  myPort.write(61);
  myPort.write(79);
  myPort.write(91);
    for (int z=13; z<28; z++){
    myPort.write(byte(random(z)+i+z));

  }
  myPort.write(0x8F);
i = i +1;
if (i>125){
  i = 0;
}
   time = millis();
  }

}

void DELAY(float theColor) {
  delay = (int)cp5.getController("DELAY").getValue();
}
// VIA USER JAVZ https://forum.processing.org/two/discussion/7140/how-to-let-the-user-select-com-serial-port-within-a-sketch.html

void mySerialSetup(){
        String COMx, COMlist = "";
    /*
      Other setup code goes here - I put this at
      the end because of the try/catch structure.
    */
      try {
        if(debug) printArray(Serial.list());
        int i = Serial.list().length;
        if (i != 0) {
          if (i >= 2) {
            // need to check which port the inst uses -
            // for now we'll just let the user decide
            for (int j = 0; j < i;) {
              COMlist += char(j+'a') + " = " + Serial.list()[j];
              if (++j < i) COMlist += ",  ";
            }
            COMx = showInputDialog("Which COM port is correct? (a,b,..):\n"+COMlist);
            if (COMx == null) exit();
            if (COMx.isEmpty()) exit();
            i = int(COMx.toLowerCase().charAt(0) - 'a') + 1;
          }
          String portName = Serial.list()[i-1];
          if(debug) println(portName);
          myPort = new Serial(this, portName, 57600); // change baud rate to your liking
          myPort.bufferUntil('\n'); // buffer until CR/LF appears, but not required..
        }
        else {
          exit();
        }
      }
      catch (Exception e)
      { //Print the type of error
        println("Error:", e);
        exit();
      }
    }
