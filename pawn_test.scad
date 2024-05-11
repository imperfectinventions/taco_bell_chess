include <BOSL2/std.scad>
include <BOSL2/gears.scad>

$fn=80;

//height, width, no_sauce_thick, sauce_thick, base2note, top2lip
base_packet_data = [75.9, 39.8, 0.3, 12, 6.4];

packet_tol = [0.4, 0.6];

//wall thick
pawn_data = [4, base_packet_data[1]/4];

//bfast packet height
king_data = [97];

//height, width, no_sauce_thick, sauce_thick, base2sauce, top2cutoff 
queen_data = [98.7, 50, 0.3, 8, 6, 14];

function quadratic(a, b, c) = [(-b+sqrt(b*b-4*a*c))/(2*a), (-b-sqrt(b*b-4*a*c))/(2*a)];

function cap_rad_cal(chord_len, curve_height) = ((chord_len*chord_len/4)+curve_height*curve_height)/(2*curve_height);

function cap_chord_cal(rad, curve_height) = sqrt(4*(2*curve_height*rad-curve_height*curve_height));

module curve_cap(chord_len, curve_height) {
  zmove(-cap_rad_cal(chord_len, curve_height)/2-(cap_rad_cal(chord_len, curve_height)/2-curve_height)) difference() {
    sphere(r=cap_rad_cal(chord_len, curve_height));
    zmove(-curve_height) cyl(r=cap_rad_cal(chord_len, curve_height), h=cap_rad_cal(chord_len, curve_height)*2);
  }
}

module mini_curve_of_cap(chord_len, lg_curve_height, sm_curve_height) {
  rad_calc = cap_rad_cal(chord_len, lg_curve_height);
  chord_calc = cap_chord_cal(rad_calc, sm_curve_height);
  
 zmove(-rad_calc/2-(rad_calc/2-sm_curve_height)) difference() {
    sphere(r=rad_calc);
    zmove(-sm_curve_height) cyl(r=rad_calc, h=rad_calc*2);
  }
}

module base_sauce_box(y_ext_long=false, cut=false, thick_multiplier=1) {
  cuboid([(base_packet_data[2]+(cut ? packet_tol[0] : 0))*thick_multiplier, base_packet_data[1]+(y_ext_long ? 1000: 0), base_packet_data[0]]);
}

module base_sauce_adj() {
  zmove(base_packet_data[0]/2) children();
}

module back_hook(cut=false, hook_side="l") {
  diff("back_hook_main_cuts") {
     xmove(-packet_tol[0]-pawn_data[0]+(cut ? packet_tol[1]/4 : 0)) ymove((hook_side=="l" ? 1 : -1 )*( base_packet_data[1]/2-pawn_data[1]/2-pawn_data[0])) {
       zrot(90) pie_slice(r=(pawn_data[1]+(cut ? packet_tol[1] : 0))/2, ang=180, h=base_packet_data[0]+pawn_data[0]);
       if (!cut) {
         tag("back_hook_main_cuts") {
           for (j=[0, 1]) {
             for (i=[-1, 1]) {
               zmove((base_packet_data[0]+pawn_data[0])*j) ymove(i*pawn_data[1]*7/4) xrot(45*i) cuboid([pawn_data[1]*2, pawn_data[1]*2, pawn_data[1]*2]);
             }
           }
         }
       }
     }
  }
}

module back_hook_king(cut=false, hook_side="l") {
  diff("back_hook_king_main_cuts") {
     xmove(-packet_tol[0]-pawn_data[0]+(cut ? packet_tol[1]/4 : 0)) ymove((hook_side=="l" ? 1 : -1 )*( base_packet_data[1]/2-pawn_data[1]/2-pawn_data[0])) {
       zrot(90) pie_slice(r=(pawn_data[1]+(cut ? packet_tol[1] : 0))/2, ang=180, h=king_data[0]+pawn_data[0]);
       if (!cut) {
         tag("back_hook_king_main_cuts") {
           for (j=[0, 1]) {
             for (i=[-1, 1]) {
               zmove((king_data[0]+pawn_data[0])*j) ymove(i*pawn_data[1]*7/4) xrot(45*i) cuboid([pawn_data[1]*2, pawn_data[1]*2, pawn_data[1]*2]);
             }
           }
         }
       }
     }
  }
}

module back_hook_queen(cut=false, hook_side="l") {
  diff("back_hook_queen_main_cuts") {
     xmove(-packet_tol[0]-pawn_data[0]+(cut ? packet_tol[1]/4 : 0)) ymove((hook_side=="l" ? 1 : -1 )*( base_packet_data[1]/2-pawn_data[1]/2-pawn_data[0])) {
       zrot(90) pie_slice(r=(pawn_data[1]+(cut ? packet_tol[1] : 0))/2, ang=180, h=queen_data[0]+pawn_data[0]);
       if (!cut) {
         tag("back_hook_queen_main_cuts") {
           for (j=[0, 1]) {
             for (i=[-1, 1]) {
               zmove((queen_data[0]+pawn_data[0])*j) ymove(i*pawn_data[1]*7/4) xrot(45*i) cuboid([pawn_data[1]*2, pawn_data[1]*2, pawn_data[1]*2]);
             }
           }
         }
       }
     }
  }
}

module back_hook_adj(cut=false) {
}

module pawn_base() {
  diff("pawn_base_main_cuts") {
    //the round base
    zmove(base_packet_data[3]/2) zcyl(l=base_packet_data[3], d1=base_packet_data[1]+pawn_data[0]*2, d2=base_packet_data[1]);
    zmove(-pawn_data[0]/2) zcyl(d=base_packet_data[1]+pawn_data[0]*2, h=pawn_data[0]);
    tag("pawn_base_main_cuts") {
      //the sauce packet cut
      base_sauce_adj() base_sauce_box(y_ext_long=true, cut=true);
      //the back hooks
      back_hook(cut=true, hook_side="l");
      back_hook(cut=true, hook_side="r");
    }
  }
}

module queen_base() {
  diff("queen_base_main_cuts") {
    //the round base
    zmove(queen_data[4]/2) zcyl(l=base_packet_data[4], d1=base_packet_data[1]+pawn_data[0]*2, d2=base_packet_data[1]);
    zmove(-pawn_data[0]/2) zcyl(d=base_packet_data[1]+pawn_data[0]*2, h=pawn_data[0]);
    tag("queen_base_main_cuts") {
      //the sauce packet cut
      base_sauce_adj() base_sauce_box(y_ext_long=true, cut=true);
      //the back hooks
      back_hook(cut=true, hook_side="l");
      back_hook(cut=true, hook_side="r");
    }
  }
}

module pawn_top() {
  diff("pawn_top_main_cuts") {
    zmove(base_packet_data[0]+base_packet_data[1]/4-base_packet_data[4]) sphere(d=base_packet_data[1]);
    tag("pawn_top_main_cuts") {
      //the chop off the bot sphere
      zmove(base_packet_data[0]+base_packet_data[1]/4-base_packet_data[4]) {
        zmove(-base_packet_data[1]/4-base_packet_data[1]/8) cuboid([base_packet_data[1], base_packet_data[1], base_packet_data[1]/4]);
        xmove(-base_packet_data[2]*2) zmove(-base_packet_data[4]*3/2) zrot(90) wedge([base_packet_data[1]*2, base_packet_data[2]*3, base_packet_data[4]], center=true);
      }
      //the back hooks
      back_hook(cut=true, hook_side="l");
      back_hook(cut=true, hook_side="r");
      //the sauce packet cut
      base_sauce_adj() base_sauce_box(y_ext_long=true, cut=true);
    }
  }
}

module horse_itself() {
//the right
  difference() {
    ymove(base_packet_data[1]/2-packet_tol[0]-pawn_data[0]) xmove(-base_packet_data[1]/2-pawn_data[0]*2) xrot(90) linear_extrude(height=pawn_data[0]*2, center=true) import("horse_svg.svg");
    ymove(0) {
      base_sauce_adj() base_sauce_box(y_ext_long=true, cut=true);
      //the back hooks
      //back_hook(cut=true, hook_side="l");
      //back_hook(cut=true, hook_side="r");
    }
  }
  difference() {
    ymove(-base_packet_data[1]/2+packet_tol[0]+pawn_data[0]) xmove(-base_packet_data[1]/2-pawn_data[0]*2) xrot(90) linear_extrude(height=pawn_data[0]*2, center=true) import("horse_svg.svg");
    ymove(0) {
      base_sauce_adj() base_sauce_box(y_ext_long=true, cut=true);
      //the back hooks
      //back_hook(cut=true, hook_side="l");
      //back_hook(cut=true, hook_side="r");
    }
  }
}

module horse_bot() {
  diff("horse_base_main_cuts") {
    //the round base
    zmove(base_packet_data[3]/2) zcyl(l=base_packet_data[3], d1=base_packet_data[1]+pawn_data[0]*2, d2=base_packet_data[1]);
    zmove(-pawn_data[0]/2) zcyl(d=base_packet_data[1]+pawn_data[0]*2, h=pawn_data[0]);
    tag("horse_base_main_cuts") {
      //the sauce packet cut
      base_sauce_adj() base_sauce_box(y_ext_long=true, cut=true, thick_multiplier=3);
      //the back hooks
      //back_hook(cut=true, hook_side="l");
      //back_hook(cut=true, hook_side="r");
    }
  }
  horse_itself();
}

module bishop_top() {
  diff("bishop_top_main_cuts") {
    zmove(base_packet_data[0]+base_packet_data[1]/4-base_packet_data[4]) {
      onion(r=base_packet_data[1]/2, ang=45);
    }
    tag("bishop_top_main_cuts") {
      //the chop off the bot sphere
      zmove(base_packet_data[0]+base_packet_data[1]/4-base_packet_data[4]) zmove(-base_packet_data[1]/4-base_packet_data[1]/8) cuboid([base_packet_data[1], base_packet_data[1], base_packet_data[1]/4]);
      //the back hooks
      back_hook(cut=true, hook_side="l");
      back_hook(cut=true, hook_side="r");
      //the sauce packet cut
      base_sauce_adj() base_sauce_box(y_ext_long=true, cut=true);
      zmove(base_packet_data[0]+base_packet_data[1]/4-base_packet_data[4]) ymove(-base_packet_data[1]/4) {
        zmove(base_packet_data[1]/2) xrot(30) cuboid([base_packet_data[1]*2, base_packet_data[1]/8, base_packet_data[1]], rounding=pawn_data[0]/4);
        xmove(-base_packet_data[2]*2) zmove(-base_packet_data[4]*3/2) zrot(90) wedge([base_packet_data[1]*2, base_packet_data[2]*3, base_packet_data[4]], center=true);
      }
    }
  }
}

module rook_top() {
  diff("rook_top_main_cuts") {
    zmove(base_packet_data[0]+base_packet_data[1]/4-base_packet_data[4]) {
      difference() {
        cyl(r=base_packet_data[1]/2, h=base_packet_data[1]/2);
        for (i=[0, 120, 240]) {
          zrot(i) zmove(base_packet_data[1]*5/16) {
            cuboid([base_packet_data[1]*2, base_packet_data[1]/8, base_packet_data[1]/2]);
            cyl(r=(base_packet_data[1]*5/8)/2, h=base_packet_data[1]/2);
          }
        }
      }
    }
    tag("rook_top_main_cuts") {
      //the chop off the bot sphere
      zmove(base_packet_data[0]+base_packet_data[1]/4-base_packet_data[4]) {
        zmove(-base_packet_data[1]/4-base_packet_data[1]/8) cuboid([base_packet_data[1], base_packet_data[1], base_packet_data[1]/4]);
        xmove(-base_packet_data[2]*2) zmove(-base_packet_data[4]*3/2) zrot(90) wedge([base_packet_data[1]*2, base_packet_data[2]*3, base_packet_data[4]], center=true);
      }
      //the back hooks
      back_hook(cut=true, hook_side="l");
      back_hook(cut=true, hook_side="r");
      //the sauce packet cut
      base_sauce_adj() base_sauce_box(y_ext_long=true, cut=true);
    }
  }
}

module queen_top() {
  diff("queen_top_main_cuts") {
    //the dome in the center
    zmove(base_packet_data[0]+base_packet_data[1]/4-base_packet_data[4]) {
      zmove((base_packet_data[1]/8)) curve_cap((base_packet_data[1]-base_packet_data[1]/16), base_packet_data[1]*3/16);
    //the sphere at the top
    zmove((base_packet_data[1]/8+base_packet_data[1]*3/16)) sphere(r=base_packet_data[1]/8);
    difference() {
        ymove() {
          cyl(r=base_packet_data[1]*3/4, h=base_packet_data[1]/2);
        }
        {
          //outside cut
          zmove(-base_packet_data[1]*5/4-base_packet_data[1]*3/16) rotate_extrude(angle=360) zrot(90) xmove(base_packet_data[1]) ymove(base_packet_data[1]*3/4) {
            ellipse(r=[base_packet_data[1]*9/16, base_packet_data[1]/4]);
            zrot(42) xmove(base_packet_data[1]/2) ymove(-base_packet_data[1]*3/16) ellipse(r=[base_packet_data[1]*9/16, base_packet_data[1]/4]);
         }
          //inner cut
          zmove(base_packet_data[1]*3/16+0.1) rotate_extrude(angle=360) difference() {
  trapezoid(h=base_packet_data[1]/8, w2=base_packet_data[1], w1=base_packet_data[1]-base_packet_data[1]/16);
  rect([base_packet_data[1], base_packet_data[1]/2], anchor=RIGHT);
          }
        }
        //the top teardrops
        rad4cut = base_packet_data[1]/2;
        rad4cut_scaler = 4;
        ang2add = ceil(2*PI*rad4cut_scaler);
        zmove(-base_packet_data[1]/16) xrot(-90) for (i=[0:ang2add:180]) {
          yrot(i) ymove(-(rad4cut+rad4cut/(rad4cut_scaler/2))/2) cyl(r=rad4cut/rad4cut_scaler, h=rad4cut*4);
        }
      }
    }
    tag("queen_top_main_cuts") {
      //the chop off the bot sphere
      zmove(base_packet_data[0]+base_packet_data[1]/4-base_packet_data[4]) zmove(-base_packet_data[1]/4-base_packet_data[1]/8) cuboid([base_packet_data[1], base_packet_data[1], base_packet_data[1]/4]);
      //the back hooks
      back_hook(cut=true, hook_side="l");
      back_hook(cut=true, hook_side="r");
      //the sauce packet cut
      zmove(base_packet_data[1]/4+base_packet_data[4]-queen_data[5]) base_sauce_adj() base_sauce_box(y_ext_long=true, cut=true);
    }
  }
}

function king_top_crown_shift() = base_packet_data[0]+base_packet_data[1]/4-base_packet_data[4]+base_packet_data[1]/2;

module king_top() {
  diff("king_top_main_cuts") {
    zmove(base_packet_data[0]+base_packet_data[1]/4-base_packet_data[4]) {
      difference() {
        ymove() {
          cyl(r=base_packet_data[1]*3/4, h=base_packet_data[1]/2);

          zmove(base_packet_data[1]/4) difference() {
             curve_cap(base_packet_data[1]*3/2, base_packet_data[1]/4);
             {
              zmove((base_packet_data[1]/4-base_packet_data[1]/16)-0.001) cuboid([base_packet_data[1]/4+packet_tol[0], base_packet_data[1]*2, base_packet_data[1]/8]);
              cuboid([base_packet_data[1]/4+packet_tol[0], base_packet_data[1]/4, base_packet_data[1]/4]);
            }
          }
        }
        {
          zmove(-base_packet_data[1]*5/4-base_packet_data[1]*3/16) rotate_extrude(angle=360) zrot(90) xmove(base_packet_data[1]) ymove(base_packet_data[1]*3/4) {
            ellipse(r=[base_packet_data[1]*9/16, base_packet_data[1]/4]);
            zrot(42) xmove(base_packet_data[1]/2) ymove(-base_packet_data[1]*3/16) ellipse(r=[base_packet_data[1]*9/16, base_packet_data[1]/4]);
          }
        }
      }
    }
    tag("king_top_main_cuts") {
      //the chop off the bot sphere
      zmove(base_packet_data[0]+base_packet_data[1]/4-base_packet_data[4]) zmove(-base_packet_data[1]/4-base_packet_data[1]/8) cuboid([base_packet_data[1], base_packet_data[1], base_packet_data[1]/4]);
      //the back hooks
      back_hook(cut=true, hook_side="l");
      back_hook(cut=true, hook_side="r");
      //the sauce packet cut
      base_sauce_adj() base_sauce_box(y_ext_long=true, cut=true);
    }
  }
}

module king_bell_crown() {
  zmove(king_top_crown_shift()) {
    //the circular cut piece
    zmove(-base_packet_data[1]/8) difference() {
      mini_curve_of_cap(base_packet_data[1]*3/2, base_packet_data[1]/4, base_packet_data[1]/8);
      for (i=[1, -1]) {
        xmove(i*(base_packet_data[1]/4+base_packet_data[1]/8)) cuboid([base_packet_data[1]/2, base_packet_data[1]*2, base_packet_data[1]/4]);
      }
    }
    //the cuboid to link to
    zmove(-base_packet_data[1]/4+base_packet_data[1]/16) cuboid([base_packet_data[1]/4, base_packet_data[1]/4-packet_tol[0], base_packet_data[1]/8]);
    //the connection to icon
    zmove(base_packet_data[1]/16-packet_tol[0]*2) cuboid([base_packet_data[1]/4, base_packet_data[1]/4, base_packet_data[1]/8+packet_tol[0]*4]);
    //the taco bell logo
    ymove(-base_packet_data[1]/4-base_packet_data[1]/8) xrot(90) yrot(90) linear_extrude(height=base_packet_data[1]/4, center=true) import("taco_bell_icon_svg.svg");
  }
}

//horse_bot();

//horse_itself();

//color("black") base_sauce_adj() base_sauce_box();

//pawn_base();
//queen_top();

//queen_base();
//king_top();
//teardrop2d(r=30, ang=10);

//back_hook_king(cut=false, hook_side="l");
//back_hook_queen(cut=false, hook_side="l");

//king_bell_crown();

//linear_extrude(height=pawn_data[0]*2, center=true) import("taco_bell_icon_svg.svg");

//egg(base_packet_data[1],25,12, 60);

//mini_curve_of_cap(10, 7, 4);

//color("blue") back_hook(hook_side="l");
//back_hook(hook_side="l");
//bishop_top();
pawn_top();
//rook_top();