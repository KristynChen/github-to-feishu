/*
  Premium Chocolate Gift Box - Parametric CAD Model
  Dimensions: 240mm x 180mm x 45mm
  Layout: 3x4 (12 chocolates)
*/

// --- Parameters ---
length = 240;
width = 180;
height = 45;
lid_height = 25;
wall_thick = 2;
fillet_r = 5;
tolerance = 0.5;

// Cavity Parameters (3x4)
rows = 3;
cols = 4;
cavity_l = 45;
cavity_w = 35;
cavity_h = 20;

$fn = 64;

// --- Modules ---

module rounded_box(l, w, h, r) {
    translate([r, r, 0])
    minkowski() {
        cube([l - 2*r, w - 2*r, h/2]);
        cylinder(r = r, h = h/2);
    }
}

module base() {
    difference() {
        rounded_box(length, width, height, fillet_r);
        translate([wall_thick, wall_thick, wall_thick])
            rounded_box(length - 2*wall_thick, width - 2*wall_thick, height, fillet_r - wall_thick);
    }
}

module lid() {
    translate([0, 0, height + 10]) { // Display lid above the box
        difference() {
            rounded_box(length + tolerance*2, width + tolerance*2, lid_height, fillet_r);
            translate([wall_thick, wall_thick, -0.1])
                rounded_box(length + tolerance*2 - 2*wall_thick, width + tolerance*2 - 2*wall_thick, lid_height, fillet_r - wall_thick);
        }
    }
}

module tray() {
    color("gold")
    translate([wall_thick + tolerance, wall_thick + tolerance, 5]) {
        difference() {
            cube([length - 2*wall_thick - 2*tolerance, width - 2*wall_thick - 2*tolerance, 5]);
            
            // Grid of 3x4 cavities
            spacing_x = (length - 2*wall_thick - 2*tolerance - cols * cavity_l) / (cols + 1);
            spacing_y = (width - 2*wall_thick - 2*tolerance - rows * cavity_w) / (rows + 1);
            
            for (i = [0 : cols - 1]) {
                for (j = [0 : rows - 1]) {
                    translate([spacing_x + i * (cavity_l + spacing_x), 
                               spacing_y + j * (cavity_w + spacing_y), 
                               1])
                        minkowski() {
                            cube([cavity_l-2, cavity_w-2, 10]);
                            cylinder(r=2, h=1);
                        }
                }
            }
        }
    }
}

// --- Render ---
base();
lid();
tray();
