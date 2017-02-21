$fn=24;
difference() {
  cube([120,120,1]);
  translate([2,2,-1]) cube([116,116,4]);
}
translate([3,3,0]) cylinder(r=1.5,h=1);