$fn = 64;

//translate([0,0,-6]) color("green") import("Robot_Tank_Tracks/costerWheel.stl");

//pitch = 3.14 * 40 / 9; // Prototype's values
//diameter = pitch * teeth / 3.14;
function rimDiameterForTeeth(teeth) = (40 / 9) * teeth;

module cog(teeth=9, cogWidth=7, rimThickness=5) {
  color("red") {
    rimDiameter = rimDiameterForTeeth(teeth);
    
    // Draw the rim
    difference() {
      cylinder(h=cogWidth, d=rimDiameter);
      translate([0,0,-.1]) cylinder(h=cogWidth+.2,d=rimDiameter-rimThickness);
    }
  
    // Add the teeth
    for (i = [0:teeth-1]) {
      theta = i * 360 / teeth;
      x = (rimDiameter-0.1)/2 * cos(theta);
      y = (rimDiameter-0.1)/2 * sin(theta);
      translate([x, y, 0]) rotate([0, 0, theta]) tooth(width=cogWidth);  
    }
    
    // Spoke and hub
    hubAndSpokes(diameter=rimDiameter-rimThickness/2, width=cogWidth);
  }
}

module tooth(height=4.3,width=6,base=4,top=2.5) {
 // difference() {
 //   union() {
      points=[
        [0,-base/2],
        [height,-top/2],
        [height,top/2],
        [0,base/2]
      ];
      linear_extrude(height=width) polygon(points=points);
      translate([height-.5,0,0]) cylinder(d=top+.15,h=width);
 //   }
 //   h = height+1;
 //   b = base+1;
//    color("green") rotate([0, -5, 0]) translate([0+h/2, -b/2, -2]) cube([h+1, b, 2]);
//    color("green") rotate([0, 5, 0]) translate([-.5+h/2, -b/2, width]) cube([h+1, b, 2]);
  //}
}

module hubAndSpokes(diameter=40, width=6) {
  difference() {
    union() {
      cylinder(h=width, d=11);
      spokeThickness = 3;
      for (i = [0:1]) {
        rotate([0, 0, 90*i]) {
            difference() {
              translate([-spokeThickness/2, -diameter/2, 0]) cube([spokeThickness, diameter, width]);
              //for (j = [0:3]) {
              //  translate([0,7.5+3*j,-1]) cylinder(d=1.5,h=width+2);
              //  translate([0,-7.5-3*j,-1]) cylinder(d=1.5,h=width+2);
              //}
            }
          }
        }
    }
    translate([0, 0, -.1]) cylinder(d=6,h=width+.2);
  }
}

module coaster(teeth=9) {
  cog(teeth);
}

coaster();