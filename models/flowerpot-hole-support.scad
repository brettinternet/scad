// Round flowerpot adapter plate for the playhouse front holder.
// Units: millimeters. Dimensions are kept in inches/centimeters at the top for tuning.

$fn = 180;

inch = 25.4;
cm = 10;

inner_radius = 3.7 * inch;
outer_radius = 4.5 * inch;
plate_thickness = 0.25 * cm;

assert(inner_radius > 0, "Inner radius must be positive.");
assert(outer_radius > inner_radius, "Outer radius must be larger than inner radius.");
assert(plate_thickness > 0, "Plate thickness must be positive.");

module adapter_plate() {
    difference() {
        cylinder(h = plate_thickness, r = outer_radius);
        translate([0, 0, -0.5])
            cylinder(h = plate_thickness + 1, r = inner_radius);
    }
}

adapter_plate();
