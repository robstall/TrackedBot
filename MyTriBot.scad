use <../MyTriTrack/Wheels.scad>;
use <../SCADLib/servoS9001.scad>;
use <../SCADLib/rpi_bplus_v2.scad>;
use <../SCADLib/batteries.scad>;

$fn = 64;

mm = 25.4; // mm per inch
dim = [140, 75, 30]; // dim of frame
thk = 3; // wall thickness
wb = 98; // wheelbase
axelSocketLen = 17.5; // Axel socket lenght
servoShaftX = 21;
servoShaftZ = servoS9001Size()[1]/2;
screwDiam = 2.2;
screwLocations = [
  [thk+screwDiam/2, thk+screwDiam/2, dim[2]-10],
  [dim[0]-thk-screwDiam/2, thk+screwDiam/2, dim[2]-10],
  [dim[0]/2-screwDiam/2, thk+screwDiam/2, dim[2]-10]
];

halfModel = false;

drawDrive = false;
drawBatteries = false;
drawRpi = false;
drawSideRail = true;
drawBottom = true;
drawTop = false;
drawEnd = true;
drawAxelSocket = true;
drawWheelbase = false;
drawFrontCoaster = true;
drawScrewPosts = true;
drawFrontAxel = false;
drawDriveWheel = true;

drawHalfBot();
if (halfModel == false) {
  mirror([0,1,0]) drawHalfBot();
}

module drive() {
  translate([servoShaftX, 0, servoShaftZ]) 
    rotate([90, 180,0]) {
      servoS9001(horn="coupler");
      //translate([0, 0, 29]) rotate([0, 180, 0]) driveWheel(axelLength=mm*.6);
    }
}

module drive_wheel() {
  translate([servoShaftX, 0, servoShaftZ]) 
    rotate([90, 180,0]) {
      //servoS9001(horn="coupler");
      translate([0, 0, 29]) rotate([0, 180, 0]) driveWheel(axelLength=mm*.6);
    }
}

module driveCutout() {
  translate([servoShaftX, 0, servoShaftZ]) {
    rotate([90, 180, 0]) {
      translate([0, 0, -.2]) servoS9001(screws=true, oversize=1);
    }
  }
  d = servoS9001Size();
  translate([10.1, d[1]+8, -1]) cube([d[0]+1, 3, thk+2]);
}

module screwPost() {
  od = screwDiam+2.4;
  id = screwDiam;
  difference() {
    cylinder(d=od, h=10);
    cylinder(d=id, h=10);
    translate([-od/5, -od/2, 0]) rotate([0, 45, 0]) cube([od, od, od]);
  }
}

module sideRail() {
    co = [dim[0]/3, thk*2, dim[2]-4*thk];
    difference() {
      cube([dim[0], thk, dim[2]]);
      translate([0, thk, 0]) driveCutout(cutout=false);
      translate([0,thk,0]) rotate([90,0,0]) holePattern(xcnt=5, ycnt=2, xoff=dim[0]/2-10, yoff=6);
      // adjustment slot
      //translate([dim[0]-65, -1, servoShaftZ- 3/2]) cube([60, 5, 3]);
    }
    if (drawScrewPosts) {
      translate(screwLocations[0]) rotate([0,0,45]) screwPost();
      translate(screwLocations[1]) rotate([0,0,135]) screwPost();
      translate(screwLocations[2]) rotate([0,0,90]) screwPost();
    }
}  

module end() {
  translate([0, -dim[1]/2, 0]) difference() {
    cube([thk, dim[1]/2, dim[2]]);
    rotate([0, 90, 0]) holePattern(xcnt=3, ycnt=3, xoff=-dim[2]-6, yoff=7.5);
  }
}

module bottom() {
  difference() {
    translate([0, -dim[1]/2, 0]) {
      difference() {
        cube([dim[0], dim[1]/2, thk]);
        holePattern(xcnt=7, ycnt=3, xoff=dim[0]/2-10, yoff=7.5);
      }
    }
    translate([0, -34.2, -.1]) driveCutout();
    translate([3, -32, -1]) cube([8,5,5]);
    translate([51, -32, -1]) cube([8,5,5]); 
  }
  translate([0, -1.5, 0]) cube([dim[0]/2*.9, 1.5, thk*2]);
}

module holePattern(xcnt, ycnt, xoff, yoff) {
  // 3mm mount holes on 1cm centers
    for (x = [1:xcnt]) {
      for (y = [0:ycnt]) {
        translate([x*10+xoff, y*10+yoff, -1]) cylinder(d=3, h=thk+2); 
      }
    }
    // holes to cut the amount of filament
    for (x = [1:xcnt-1]) {
      for (y = [0:ycnt-1]) {
        translate([x*10+xoff+5, y*10+yoff+5, -1]) cylinder(d=7, h=thk+3); 
      }
    }
}

module top() {
  difference() {
    cube([dim[0], dim[1]/2, thk]);
    holePattern(xcnt=13, ycnt=3, xoff=0, yoff=7.5);
  }
  
  for ( i = [0:2] ) {
    s = screwLocations[i];
    h = thk * 2;
    x = s[0]; y = s[1]; z = -thk;
    translate([x, y, z]) cylinder(d=screwDiam, h=h);
  }
  
}

module axelSocket() {
  rotate([90,0,0]) {
    difference() { 
      cylinder(d=mm/2, h=axelSocketLen); 
      cylinder(d=mm/4, h=axelSocketLen+.1); 
    }
  }
}

module frontCoaster() {
  rotate([90,00,0]) coaster();
}

module frontAxel() {
  cylinder(d=mm/2, h=1); 
  cylinder(d=mm/4, h=mm);
}

module wheelbase() {
  cube([wb,2,2]);
}

module drawHalfBot() {
    
  if (drawSideRail) {
    translate([0, -dim[1]/2, 0]) color("gray") sideRail();
  }
  
  if (drawBottom) {
    color("gray") bottom();
  }
  
  if (drawTop) {
    color("purple") 
      translate([0, -dim[1]/2, dim[2]])
        top();
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
  
   if (drawDriveWheel) {
   color("green") {
      translate([0, -34.2, -.1]) drive_wheel();
    }
  } 
  
  if (drawAxelSocket) {
    color("green") {
      translate([servoShaftX+wb, -dim[1]/2, servoShaftZ]) 
        axelSocket();
    }
  }
  
  if (drawWheelbase) {
    color("red") 
      translate([servoShaftX, -dim[1]/2-20, servoShaftZ-1]) 
        wheelbase();
  }
  
  if (drawFrontCoaster) {
    color("green") {
      translate([servoShaftX+wb, -dim[1]/2-axelSocketLen-1, servoShaftZ]) 
        frontCoaster();
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

if (drawFrontAxel) {
  frontAxel();
}
