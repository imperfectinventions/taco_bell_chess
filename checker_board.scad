include <BOSL2/std.scad>
include <BOSL2/gears.scad>

$fn=80;

//sq_len, wall_border (len will be sq_len+wall_border), turn_rad_sm, turn_rad_lg, back_wall_thick
checker_data = [50, 5, 3, 6, 4];

check_tol = [0.4, 0.8];

module check_piece() {
  base_xlen = checker_data[0]+checker_data[1];
  diff("check_piece_main_cuts") {
   cuboid([base_xlen, (checker_data[0]+checker_data[3]*2), checker_data[3]], rounding=check_tol[0]);
   // the top tzoid
   xmove(checker_data[0]/2+checker_data[4]) zrot(-90) linear_extrude(checker_data[3], center=true) trapezoid(checker_data[4], checker_data[0]/2, checker_data[0]/2+checker_data[4]*2);
   
   for (i=[-1, 1]) {
     //the circ turn grab
     ymove(i*(checker_data[0]/2+checker_data[2]+checker_data[3]/2)) zmove(checker_data[3]/2) xmove(i*base_xlen/4) xcyl(r=checker_data[3], h=base_xlen/2);
     tag("check_piece_main_cuts") {
       //the inner cut for the circ wedges
       ymove(i*(checker_data[0]/2+checker_data[2]+checker_data[3]/2)) zmove(checker_data[3]/2)  xcyl(r=checker_data[2]+(i==-1 ? check_tol[0]/2 : check_tol[1]/2), h=base_xlen+0.2);
       //the big cut so that the turn piece can be slotted in
       ymove(-i*(checker_data[0]/2+checker_data[2]+checker_data[3]/2)) zmove(checker_data[3]/2) xmove(i*(base_xlen/4+0.05)) xcyl(r=checker_data[3]+check_tol[1]*2, h=base_xlen/2+0.1+0.1);
       //the wall cut at the butt
       if (i == -1) {
         ymove(-i*(checker_data[0]/2+checker_data[2]+checker_data[3]/2)) zmove(checker_data[3]/2) xmove((base_xlen/2-checker_data[4]/2-check_tol[1]/2+0.05)) xcyl(r=checker_data[3]+check_tol[1], h=checker_data[4]+0.1+check_tol[1]);
       }
     }
   }
   tag("check_piece_main_cuts") {
     zmove(checker_data[3]-check_tol[0]*4) cuboid([checker_data[0], checker_data[0], checker_data[3]], rounding=check_tol[0]*4);
     //the middle cut for cost savings
     cuboid([base_xlen-checker_data[1]*3, (checker_data[0])-checker_data[1]*2, checker_data[3]*2]);
     // the bot tzoid
     xmove(-(checker_data[0]/2+check_tol[0]*3)) zrot(-90) linear_extrude(checker_data[3]+check_tol[0], center=true) trapezoid(checker_data[4]+check_tol[0], checker_data[0]/2+check_tol[0], checker_data[0]/2+checker_data[4]*2+check_tol[0]);
   }
  }
  //inner pattern
  difference() {
  //the x in the middle
    for (i=[-45, 45]) {
     zrot(i) zmove(-check_tol[0]*2) cuboid([(base_xlen-checker_data[3]*2)*sqrt(2), checker_data[1], checker_data[3]-check_tol[0]*4]);
    }
    cyl(r=base_xlen/4, h=checker_data[3]*2);
  }
  difference() {
    zmove(-check_tol[0]*2) cyl(r=base_xlen/4, h=checker_data[3]-check_tol[0]*4);
    cyl(r=base_xlen/4-checker_data[1]/2, h=checker_data[3]*2);
  }
}

module top_grabber() {
  base_xlen = checker_data[0]+checker_data[1];
  diff("top_grab_main_cuts") {
     xmove(base_xlen/2+checker_data[4]+check_tol[0]) cuboid([checker_data[4]*2, base_xlen-checker_data[4]*2, checker_data[3]], rounding=check_tol[0]);
     tag("top_grab_main_cuts") {
       // the top tzoid
       xmove(checker_data[0]/2+checker_data[4]) zrot(-90) linear_extrude(checker_data[3]+check_tol[0], center=true) trapezoid(checker_data[4]+check_tol[0], checker_data[0]/2+check_tol[0], checker_data[0]/2+checker_data[4]*2+check_tol[0]);
     }
  }
}

module bot_grabber() {
  base_xlen = checker_data[0]+checker_data[1];
  diff("bot_grab_main_cuts") {
     xmove(-(base_xlen/2+checker_data[4]+check_tol[0]*3/4)) cuboid([checker_data[4]*2, base_xlen-checker_data[4]*2, checker_data[3]], rounding=check_tol[0]);
     // the bot tzoid
     xmove(-(checker_data[0]/2+check_tol[0]*3)) zrot(-90) linear_extrude(checker_data[3], center=true) trapezoid(checker_data[4], checker_data[0]/2, checker_data[0]/2+checker_data[4]*2);
  }
}

module l_grabber() {
  base_xlen = checker_data[0]+checker_data[1];
  diff("l_grabber_main_cuts") {
     
     ymove((checker_data[0]/2+checker_data[2]+checker_data[3]/2)) {
       zmove(checker_data[3]/2) xmove() xcyl(r=checker_data[3], h=base_xlen/4-checker_data[4]);
       xmove(-check_tol[0]) ymove(checker_data[4]*2-check_tol[0]*2) zmove(-(checker_data[3]-check_tol[0]*5)/4+check_tol[0]/2) cuboid([base_xlen-checker_data[4]*2-check_tol[0]*2, checker_data[4]*2+checker_data[3], checker_data[3]-check_tol[0]*4], rounding=check_tol[0]);
     }
     tag("l_grabber_main_cuts") {
       //the inner cut for the circ wedges
       ymove((checker_data[0]/2+checker_data[2]+checker_data[3]/2)) zmove(checker_data[3]/2)  xcyl(r=checker_data[2]+(check_tol[1]), h=base_xlen+0.2);
       //the big cut so that the turn piece can be slotted in
       ymove((checker_data[0]/2+checker_data[2]+checker_data[3]/2)) zmove(checker_data[3]/2) xmove((base_xlen/4+0.05)) xcyl(r=checker_data[3]+check_tol[1]*2, h=base_xlen/2+0.1+0.1);
       ymove((checker_data[0]/2+checker_data[2]+checker_data[3]/2)) zmove(checker_data[3]/2) xmove(-(base_xlen/4+checker_data[4]+check_tol[1])) xcyl(r=checker_data[3]+check_tol[1]*2, h=base_xlen/2+0.1+0.1);
     }
   }
}

module r_grabber() {
  base_xlen = checker_data[0]+checker_data[1];
  diff("r_grabber_main_cuts") {
     
     ymove(-(checker_data[0]/2+checker_data[2]+checker_data[3]/2)) {
       zmove(checker_data[3]/2) xmove(base_xlen/4-checker_data[4]*2) xcyl(r=checker_data[3], h=base_xlen/2-checker_data[4]*3);
       xmove(-check_tol[0]) ymove(-(checker_data[4]*2-check_tol[0]*2)) zmove(-(checker_data[3]-check_tol[0]*5)/4+check_tol[0]/2) cuboid([base_xlen-checker_data[4]*2-check_tol[0]*2, checker_data[4]*2+checker_data[3], checker_data[3]-check_tol[0]*4], rounding=check_tol[0]);
     }
     tag("r_grabber_main_cuts") {
       //the inner cut for the circ wedges
       ymove(-(checker_data[0]/2+checker_data[2]+checker_data[3]/2)) zmove(checker_data[3]/2)  xcyl(r=checker_data[2]+(check_tol[1]/2), h=base_xlen+0.2);
       //the big cut so that the turn piece can be slotted in
       ymove(-(checker_data[0]/2+checker_data[2]+checker_data[3]/2)) zmove(checker_data[3]/2) xmove(-(base_xlen/4+0.05)) xcyl(r=checker_data[3]+check_tol[1]*2, h=base_xlen/2+0.1+0.1);
       ymove(-(checker_data[0]/2+checker_data[2]+checker_data[3]/2)) zmove(checker_data[3]/2) xmove((base_xlen/4+checker_data[4]*3+0.05)) xcyl(r=checker_data[3]+check_tol[1]*2, h=base_xlen/2+0.1+0.1);
     }
   }
}

module r_grabber_join_wedge(side="l", piece_side="l") {
  base_xlen = checker_data[0]+checker_data[1];
  xrot((side=="l" ? 0 : 180)) yrot(90) {
    pie_slice(r=checker_data[2], ang=180, h=base_xlen/2-checker_data[4]);
    zmove((base_xlen/2-checker_data[4]*2)) pie_slice(r=checker_data[3]-check_tol[0]/2, ang=180, h=checker_data[4]);
  }
}

module join_wedge(side="l", piece_side="l") {
  xrot((side=="l" ? 0 : 180)) yrot(90) {
    pie_slice(r=checker_data[2], ang=180, h=(checker_data[0]+checker_data[1]-checker_data[4]*4-check_tol[0]*2));
    zmove((checker_data[0]+checker_data[1]-checker_data[4]*4-check_tol[0]*2)) pie_slice(r=checker_data[3]-check_tol[0]/2, ang=180, h=checker_data[4]);
  }
}

module join_wedge_two_side(side="l", piece_side="l") {
  xrot((side=="l" ? 0 : 180)) yrot(90) {
    pie_slice(r=checker_data[2], ang=180, h=(checker_data[0]+checker_data[1]-checker_data[4]*4-check_tol[0]*2));
    zmove((checker_data[0]+checker_data[1]-checker_data[4]*4-check_tol[0]*2)) {
       pie_slice(r=checker_data[3]-check_tol[0]/2, ang=180, h=checker_data[4]);
       zmove(checker_data[4]) pie_slice(r=checker_data[2], ang=180, h=checker_data[0]/4);
    }
  }
}

module join_wedge_grabber(side="l", grab_side="r") {
  xrot((side=="l" ? 0 : 180)) yrot(90) {
    pie_slice(r=checker_data[2]+(grab_side=="r" ? 0 : check_tol[0]/2), ang=180, h=(checker_data[0]+checker_data[1]-checker_data[4]*4-check_tol[0]*2)/2);
    zmove((checker_data[0]+checker_data[1]-checker_data[4]*4-check_tol[0]*2)/2) pie_slice(r=checker_data[3]-check_tol[0]/2, ang=180, h=checker_data[4]);
  }
}

module fully_joined_piece() {
for (i=[1, -1]) {
  ymove(i*(checker_data[0]/2+checker_data[2]+checker_data[3]/2)) xmove(-checker_data[0]/4-checker_data[4]/2) zmove(checker_data[3]/2) {
      join_wedge(piece_side=(i==1 ? "l" : "r"));
      join_wedge(side="r", piece_side=(i==1 ? "l" : "r"));
    }
  }
}

//check_piece();
//ymove(-(checker_data[0]+checker_data[2]+checker_data[3]*3/2)) check_piece();
//ymove(-(checker_data[0]+checker_data[2]+checker_data[3]*3/2)) xmove(-(checker_data[0]+checker_data[2]+checker_data[3]/4+check_tol[0]*3/2)) check_piece();
//xmove(-(checker_data[0]+checker_data[2]+checker_data[3]/4+check_tol[0]*3/2)) check_piece();
//fully_joined_piece();
//ymove(-(checker_data[0]+checker_data[2])/2) r_grabber_join_wedge();
//r_grabber();
//l_grabber();

//bot_grabber();
//top_grabber();

ymove(-(checker_data[0]/2+checker_data[2]+checker_data[3]/2)) join_wedge_grabber(grab_side="r");

//ymove((checker_data[0]/2+checker_data[2]+checker_data[3]/2)) xmove((checker_data[0]+checker_data[1])/4) yrot(180) zmove(-checker_data[3]/2) join_wedge_grabber(grab_side="l");

//ymove(-(checker_data[0]/2+checker_data[2]+checker_data[3]/2)) xmove((-checker_data[0]/4-checker_data[4]*2)-checker_data[0]) zmove(checker_data[3]/2) { 
//      join_wedge_two_side();
//      join_wedge_two_side(side="r");
//   }
//join_wedge();
//join_wedge_two_side();

