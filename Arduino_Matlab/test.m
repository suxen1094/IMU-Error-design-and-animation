
clear lsmObj a acceleration
a = arduino;
lsmObj = lsm9ds1(a,"Bus",1);

while 1
    acceleration = readAcceleration(lsmObj);
    angularVelocity = readAngularVelocity(lsmObj);
    disp(acceleration)
end
clear lsmObj a acceleration