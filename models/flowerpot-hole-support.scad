// Flowerpot support for a 3 7/8 inch hole.
// Units: millimeters. Print flat with the broad U shape on the bed.

$fn = 64;

inch = 25.4;
hole_width = 3.875 * inch;

// Body slips into the hole; wings sit on the top edge so the support cannot fall through.
fit_clearance = 1.2;
body_outer_width = hole_width - fit_clearance;
rail_width = 10;
plate_thickness = 3.6;
u_depth = 78;

wing_overhang = 18;
wing_depth = 18;
corner_radius = 3;
mount_edge_radius = 1.2;
roundover_steps = 6;

assert(body_outer_width < hole_width, "Body must be narrower than the hole.");
assert(body_outer_width + (2 * wing_overhang) > hole_width, "Wings must overhang the hole.");
assert(rail_width > (2 * corner_radius), "Rail width must fit the corner radius.");
assert(wing_depth > (2 * corner_radius), "Wing depth must fit the corner radius.");
assert(plate_thickness > mount_edge_radius, "Plate thickness must fit the mounting-edge roundover.");
assert(rail_width > (2 * mount_edge_radius), "Rail width must fit the mounting-edge roundover.");

module rounded_rect(size, radius) {
    x = size[0];
    y = size[1];

    hull() {
        translate([-(x / 2) + radius, -(y / 2) + radius]) circle(r = radius);
        translate([(x / 2) - radius, -(y / 2) + radius]) circle(r = radius);
        translate([-(x / 2) + radius, (y / 2) - radius]) circle(r = radius);
        translate([(x / 2) - radius, (y / 2) - radius]) circle(r = radius);
    }
}

module rail(center, size) {
    translate(center) rounded_rect(size, corner_radius);
}

module u_support_2d() {
    side_rail_x = (body_outer_width - rail_width) / 2;
    side_rail_center_y = -u_depth / 2;
    bottom_rail_center_y = -u_depth + (rail_width / 2);
    wing_center_x = (body_outer_width / 2) - (rail_width / 2) + (wing_overhang / 2);

    union() {
        // Left and right legs.
        rail([-side_rail_x, side_rail_center_y], [rail_width, u_depth]);
        rail([side_rail_x, side_rail_center_y], [rail_width, u_depth]);

        // Bottom bridge that catches the flowerpot base.
        rail([0, bottom_rail_center_y], [body_outer_width, rail_width]);

        // Top wings rest on the rim around the hole.
        rail([-wing_center_x, 0], [rail_width + wing_overhang, wing_depth]);
        rail([wing_center_x, 0], [rail_width + wing_overhang, wing_depth]);
    }
}

module rounded_mount_plate() {
    roundover_layer_height = mount_edge_radius / roundover_steps;

    for (step = [0 : roundover_steps - 1]) {
        progress = (step + 1) / roundover_steps;
        inset = mount_edge_radius * (1 - sin(progress * 90));

        translate([0, 0, step * roundover_layer_height])
            linear_extrude(height = roundover_layer_height, convexity = 10)
                offset(delta = -inset)
                    u_support_2d();
    }

    translate([0, 0, mount_edge_radius])
        linear_extrude(height = plate_thickness - mount_edge_radius, convexity = 10)
            u_support_2d();
}

rounded_mount_plate();
