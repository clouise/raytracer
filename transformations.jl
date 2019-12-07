#Define translation matrices for moving objects in 3d space
function translation(x, y, z)
    i = SA_F64[1 0 0 x; 0 1 0 y; 0 0 1 z; 0 0 0 1]
    return(i)
end

function scaling(x, y, z)
    i = SA_F64[x 0 0 0; 0 y 0 0; 0 0 z 0; 0 0 0 1]
    return(i)
end

function rotationX(r)
    i = SA_F64[1 0 0 0; 0 cos(r) -sin(r) 0; 0 sin(r) cos(r) 0; 0 0 0 1]
    return(i)
end

function rotationY(r)
    i = SA_F64[cos(r) 0 sin(r) 0; 0 1 0 0; -sin(r) 0 cos(r) 0; 0 0 0 1]
    return(i)
end

function rotationZ(r)
    i = SA_F64[cos(r) -sin(r) 0 0; sin(r) cos(r) 0 0; 0 0 1 0; 0 0 0 1]
    return(i)
end

function shearing(xy, xz, yx, yz, zx, zy)
    i = SA_F64[1 xy xz 0; yx 1  yz 0; zx zy 1 0; 0 0 0 1]
    return(i)
end

