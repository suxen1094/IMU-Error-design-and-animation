clear lsmObj a acceleration
a = arduino;
lsmObj = lsm9ds1(a,"Bus",1);

% choose the data you want
% acceleration = 1
% Angle = 2
% magneticField = 3
measurement = 1;

% calibration = 1: enable  calibration
% calibration = 0: disable calibration
calibration = 1;

accelOffset = [0.006245, -0.016577, -0.005882];
accelSlope  = [1.000514, 1.001754, 1.004684];
gyroOffset  = [0.0106323, -0.0292786, 0.0346252];
gyroSlope   = [1.0217233, 1.0247035, 1.0188662];

a_x = animatedline('Color', 'r');
a_y = animatedline('Color', 'g');
a_z = animatedline('Color', 'b');
x = linspace(1, 10, 200);
i = 1;
if measurement == 1
    axis([1 10 -20 20]);
    yticks([-1 -0.1 -0.05 0 0.05 0.1 1])
    title('Acceleration Measurement');
    xlabel('timeline');
    ylabel('m/s^2');
    legend({'acceleration of x axis', ...
        'acceleration of y axis', 'acceleration of z axis'}, ...
        "Location", "southwest");
elseif measurement == 2
    axis([1 10 -0.2, 0.2]);
    % yticks([-0.4 -0.1 -0.05 0 0.05 0.1 0.4])
    title('angularVelocity Measurement');
    xlabel('timeline');
    ylabel('degree/second');
    legend({'angularVelocity of x axis', ...
        'angularVelocity of y axis', 'angularVelocity of z axis'}, ...
        "Location", "southwest");
else
    axis([1 10 -10 10]);
    title('Magnetic Field Measurement');
    xlabel('timeline');
    ylabel('μT(micro tesla)');
    legend({'Magnetic Field of x axis', ...
        'Magnetic Field of y axis', 'Magnetic Field of z axis'}, ...
        "Location", "southwest");
end

while 1
    for k = 1:length(x)
        if measurement == 1
            acceleration = readAcceleration(lsmObj);
            x_value = acceleration(1);
            y_value = acceleration(2);
            z_value = acceleration(3);

            if(calibration)
                x_value = accelSlope(1) * (x_value - accelOffset(1));
                y_value = accelSlope(2) * (y_value - accelOffset(2));
                z_value = accelSlope(3) * (z_value - accelOffset(3));
            end
        elseif measurement == 2
            angularVelocity = readAngularVelocity(lsmObj);
            x_value = angularVelocity(1);
            y_value = angularVelocity(2);
            z_value = angularVelocity(3);

            if(calibration)
                x_value = gyroSlope(1) * (x_value - gyroOffset(1));
                y_value = gyroSlope(2) * (y_value - gyroOffset(2));
                z_value = gyroSlope(3) * (z_value - gyroOffset(3));
            end
        else
            magneticField = readMagneticField(lsmObj);
            x_value = magneticField(1);
            y_value = magneticField(2);
            z_value = magneticField(3);
        end
        
        addpoints(a_x, x(k), x_value)
        addpoints(a_y, x(k), y_value)
        addpoints(a_z, x(k), z_value)
    end
    clearpoints(a_x)
    clearpoints(a_y)
    clearpoints(a_z)
end