use <../MyTriTrack/Wheels.scad>;
use <../SCADLib/servoS9001.scad>;
use <../SCADLib/rpi_bplus_v2.scad>;
use <../SCADLib/batteries.scad>;

mm = 25.4;
dim = [140, 75, 30];
thk = 3;

drawDrive = true;
drawBatteries = false;
drawRpi = false;
drawSideRail = true;
drawBottom = true;
drawTop = true;
drawEnd = true;

drawHalfBot();
mirror([0,1,0]) drawHalfBot();

module drive() {
  d = servoS9001Size();
  translate([25, 0, d[1]/2]) 
    rotate([90, 180,0]) {
      servoS9001(horn="coupler");
      translate([0, 0, 25]) coaster();
    }
}

module driveCutout() {
  d = servoS9001Size();
  translate([25, 0, d[1]/2]) 
    rotate([90, 180,0]) {
      translate([0, 0, -.2]) servoS9001(screws=true, oversize=1);
    }
}

module screwPost() {
  difference() {
    cylinder(r=thk, h=dim[2]-thk);
    cylinder(r=.75, h=dim[2]-thk+1);
  }
}

module sideRail() {
    difference() {
      cube([dim[0], thk, dim[2]]);
      translate([0, thk, 0]) driveCutout(cutout=false);
    }
    translate([thk+.75, thk+.75, thk]) screwPost();
    translate([dim[0]-thk-.75, thk+.75, thk]) screwPost();
    translate([dim[0]/2-thk/2, thk+.75, thk]) screwPost();
}  

module end() {
  translate([0, -dim[1]/2, 0]) cube([thk, dim[1]/2, dim[2]]);
}

module bottom() {
  difference() {
    translate([0, -dim[1]/2, 0]) cube([dim[0], dim[1]/2, thk]);
    translate([0, -34.2, -.1]) driveCutout();
    translate([7, -32, -1]) cube([8,5,5]);
    translate([55, -32, -1]) cube([8,5,5]); 
  }
}

module top() {
  spc = 25.4 / 4;
  cntX = floor(dim[0] / spc) - 2;
  cntY = floor(dim[1]/2 / spc) - 1;
  translate([0, -dim[1]/2, dim[2]]) {
    difference() {
      cube([dim[0], dim[1]/2, thk]);
      for (x = [0:cntX]) {
        for (y = [0:cntY]) {
          translate([x*spc+spc, y*spc+2*spc-.75, -1]) cylinder(d=1.5, h=thk+2);
        }
      }
      translate([thk+.75, thk+.75, -thk]) cylinder(d=2,h=thk+5);
      translate([dim[0]-thk-.75, thk+.75, -thk]) cylinder(d=2,h=thk+5);
      translate([dim[0]/2-thk/2, thk+.75, -thk]) cylinder(d=2,h=thk+5);
    }
  }
}

module drawHalfBot() {
    
  if (drawSideRail) {
    translate([0, -dim[1]/2, 0]) color("gray") sideRail();
  }
  
  if (drawBottom) {
    color("gray") bottom();
  }
  
  if (drawTop) {
    color("purple") top();
  }
  
  if (drawEnd) {
    color("gray") {
      end();
      translate([dim[0]-thk, 0, 0]) end();
    }
  }
  
  if (drawDrive) {
   color("green") {
      translate([0, -34.2, -.1]) drive();
    }
  } 
}

if (drawRpi) {
    color("blue") {
      translate([0, 0, dim[2] + 20]) rpi_bplus(center=true);
    }
  }

  if (drawBatteries) {
    color("red") {
      translate([dim[0]-35, 0, 3]) rotate([0, 0, 0]) aa4BatteryHolder(center=true);
      translate([75, 0, 20]) pb2sBattery(usbplug = false, center=true);
    }
  } 
