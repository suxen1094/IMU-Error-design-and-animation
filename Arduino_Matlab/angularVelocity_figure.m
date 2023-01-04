clear lsmObj a acceleration
a = arduino;
lsmObj = lsm9ds1(a,"Bus",1);

axis([1 10 -20 20]);
a_x = animatedline('Color', 'r');
a_y = animatedline('Color', 'g');
a_z = animatedline('Color', 'b');
x = linspace(1, 10, 200);
i = 1;
while 1
    for k = 1:length(x)
        % acceleration = readAcceleration(lsmObj);
        angularVelocity = readAngularVelocity(lsmObj);
        % magneticField = readMagneticField(lsmObj);
    
        x_value = angularVelocity(1);
        y_value = angularVelocity(2);
        z_value = angularVelocity(3);
        addpoints(a_x, x(k), x_value)
        addpoints(a_y, x(k), y_value)
        addpoints(a_z, x(k), z_value)
    end
    clearpoints(a_x)
    clearpoints(a_y)
    clearpoints(a_z)
end