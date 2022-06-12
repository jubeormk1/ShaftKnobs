/* [About the shaft] */
// How much of the shaft you want to pick
shaftHeight = 9; // [5:20]

// The shaft diameter
shaftDiameter = 6.3; // [3:0.1:8]

// A thickness for the shaft column
shaftColumnThickness=3; // [1:0.2:20]

// A thickness for the bottom of the shaft column
shaftColumnBottomThickness=3; // [1:0.1:20]

/* [About the knob itself] */
// This is the knob height
shieldHeight = 18; // [0:0.1:50]

// This is the knob diameter in the outher side of it
shieldRadiousFace = 40/2; // [8:0.2:50]

// This is the knobs base diameter
shieldRadiousBase=45/2; // [8:0.2:50]

// The thickness for the frontal side of the knob
faceThickness = 2; // [0:0.1:10]

reinforcement = true;
reinforcementHeight = 10; // [0:0.1:50]

dialAngle = 45; // [0:1:360]


$fn=80;

module knob(
    shaftHeight=9,
    shaftDiameter=6.3,
    shaftColumnThickness=3,
    shaftColumnBottomThickness=3,
    shieldHeight = 18,
    shieldRadiousFace = 40/2,
    shieldRadiousBase=45/2,
    faceThickness = 2,
    reinforcementHeight = 10,
    dialAngle = 45)
{
    module knotch(
    Height=9,
    Diameter=6.3,
    facetDiameter = 4.2)
    {
        $var1= 0;
        translate([Diameter/2+(Diameter-facetDiameter),0,0]) 
        {cube([Diameter,Height,Height*2.01], center = true);}
    }
    module shaft(
        Height=9,
        Diameter=6.3)
    {   
        difference(){
            cylinder(h = Height*1.02, r =Diameter/2);
            knotch(Height=Height*1.02, Diameter=Diameter, facetDiameter = 4.2);
        }

    }
    module shaftColumn(
        shaftHeight=9,
        shaftDiameter=6.3,
        wallThickness=3,
        bottomThickness=3)
    {

        difference(){
            cylinder(   h = (shaftHeight + bottomThickness),
                        r =(shaftDiameter+wallThickness*2)/2
            );
            translate([0,0,bottomThickness]){
            shaft(Height = shaftHeight, Diameter = shaftDiameter);
            }
        }    
    }

    // I am passing the parameters to internal modules implicitly with local variables
    // Depends on the shaft diameter to extract it from the reinforcement
    module knobShield(
        height = 18,
        radiousFace = 40/2,
        radiousBase=45/2,
        faceThickness = 2,
        reinforcementHeight =1
        )
    {
        module externalSurface(){
                translate([0,0, height/2-faceThickness]){
            cylinder(
                    h = height, 
                    r1 = radiousFace, 
                    r2 = radiousBase, 
                    center =true);
        }}
        module internalSurface(){
            translate([0,0, height/2]){
            cylinder(
                    h = height, 
                    r1 = radiousFace-faceThickness, 
                    r2 = radiousBase-faceThickness, 
                    center =true);
    }}
        module reinforcement(
            height = reinforcementHeight,
            radiousFace = 40/2,
            radiousBase=45/2,
            faceThickness = 2 )
        {
            translate([0,0, height/2-faceThickness]){
            
                difference(){
                    cylinder(
                    h = reinforcementHeight, 
                    r1 = radiousFace-faceThickness, 
                    r2 = radiousBase-faceThickness, 
                    center =true);                    
                    shaft(Height = 50, Diameter = shaftDiameter);
                }

            }
        }
    
        module dial(angle = 0)
        {
            rotate(a= [0,atan((shieldRadiousBase-shieldRadiousFace)/shieldHeight),angle])
            {
                translate([shieldRadiousFace, 0, - faceThickness])
                {
                    cylinder(h =100,r=faceThickness/3);
                    }
                }
        }
        union(){
            difference()
            {
                externalSurface();
                internalSurface();
                dial(angle = dialAngle);
            }
            reinforcement();
                
        }
        
        reinforcement();
    }

    union(){
    
        shaftColumn(
            shaftHeight=shaftHeight,
            shaftDiameter=shaftDiameter,
            wallThickness=shaftColumnThickness,
            bottomThickness=shaftColumnBottomThickness
            );
        knobShield(
            height = shieldHeight,
            radiousFace = shieldRadiousFace,
            radiousBase= shieldRadiousBase,
            faceThickness = faceThickness,
            reinforcementHeight = reinforcementHeight
            );
    }
     
}

// The whole thing
knob(
    shaftHeight = shaftHeight,
    shaftDiameter = shaftDiameter,
    shaftColumnThickness = shaftColumnThickness,
    shaftColumnBottomThickness = shaftColumnBottomThickness,
    shieldHeight = shieldHeight ,
    shieldRadiousFace = shieldRadiousFace,
    shieldRadiousBase = shieldRadiousBase,
    faceThickness = faceThickness,
    reinforcementHeight = reinforcementHeight,
    dialAngle = dialAngle
    );


 
 
 