% brick = ConnectBrick('ANT');
done = 0;

function moveStraight(brick, speed)
    brick.MoveMotor('B', speed);
    brick.MoveMotor('C', speed);
end

function moveForward(brick, speed, duration)
    brick.MoveMotor('B', speed);
    brick.MoveMotor('C', speed);
    pause(duration);
end

function stopMotors(brick, mode)
    brick.StopAllMotors(mode);
end



function beepMultiple(brick, times)
    for i = 1:times
        brick.beep();
        pause(0.5);
    end
end

while done == 0
    color = brick.ColorCode(1);
    newDist = brick.UltrasonicDist(4);
    disp("New distance: " + newDist);
    disp("Color: " + color);

    if newDist > 50
        disp('Turning right...');
        brick.MoveMotor('C', 36);
        brick.MoveMotor('B', -32);
        pause(1);
        brick.StopAllMotors();
        moveForward(brick, 40, 3);
    end

    switch color
        case 5
            stopMotors(brick, 'Brake');
            pause(1);
            moveForward(brick, 40, 2);
            
        case 3
            stopMotors(brick, 'Brake');
            beepMultiple(brick, 3);
            pause(1);
            moveForward(brick, -50, 2);
            disp('Turning right...');
            brick.MoveMotor('C', 36);
            brick.MoveMotor('B', -32);
            pause(1);
            brick.StopAllMotors();

        case 2
            stopMotors(brick, 'Brake');
            beepMultiple(brick, 2);
            pause(1);
            moveForward(brick, -50, 2);
            disp('Turning right...');
            brick.MoveMotor('C', 36);
            brick.MoveMotor('B', -32);
            pause(1);
            brick.StopAllMotors();

        case 4
            stopMotors(brick, 'Brake');
            pause(1);
    end

    if brick.TouchPressed(3) == 1
        stopMotors(brick, 'Brake');
        pause(1);
        moveForward(brick, -15, 1);
        
        if newDist < 50
            disp('Turning right...');
            brick.MoveMotor('C', 36);
            brick.MoveMotor('B', -32);
            pause(1);
            brick.StopAllMotors();
        else
            disp('Turning left...');
            brick.MoveMotor('C', -36);
            brick.MoveMotor('B', 32);
            pause(1);
            brick.StopAllMotors();
        end
    else
        moveStraight(brick, 40);
    end
end
