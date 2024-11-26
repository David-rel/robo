% brick = ConnectBrick('ANT');
done = 0;
oldDist = 0;
pauseTime = 1.7;
speedPercentage = 50;
set = 0
largeDistance = 150
smallDistance = 70


% Function to move straight
function moveStraight(brick, speed)
    brick.MoveMotor('B', speed);
    brick.MoveMotor('C', speed);
end

% Function to move forward for a duration
function moveForward(brick, speed, duration)
    brick.MoveMotor('B', speed);
    brick.MoveMotor('C', speed);
    pause(duration);
end

% Function to stop motors
function stopMotors(brick, mode)
    brick.StopAllMotors(mode);
end

% Function to beep multiple times
function beepMultiple(brick, times)
    for i = 1:times
        brick.beep();
        pause(0.5);
    end
end

% Main loop
while done == 0
    color = brick.ColorCode(1);
    newDist = brick.UltrasonicDist(4);
    disp("New distance: " + newDist);
    disp("Color: " + color);

    switch color
        case 5 % Green
            stopMotors(brick, 'Brake');
            pause(pauseTime);
            moveForward(brick, 40, 2);

        case 3 % Yellow
            if gotPerson == 1
                % Do nothing, person already handled
            else
                beepMultiple(brick, 3);
                pause(pauseTime);
                run('keyboard'); % Replace with actual required behavior
            end

        case 2 % Blue
            if gotPerson == 1
                % Do nothing, person already handled
            else
                stopMotors(brick, 'Brake');
                beepMultiple(brick, 2);
                pause(pauseTime);
                gotPerson = 1;
                run('keyboard'); % Replace with actual required behavior
            end

        case 4 % Red
            if gotPerson == 1
                % Do nothing, person already handled
            else
                beepMultiple(brick, 1);
                pause(pauseTime);
                run('keyboard'); % Replace with actual required behavior
            end
    end

    if newDist > smallDistance
        if newDist < largeDistance && set = 0
            disp('Turning left due to decently big distance...');
            stopMotors(brick, 'Brake');
            brick.MoveMotor('B', speedPercentage);
            pause(pauseTime);
            stopMotors(brick, 'Brake');
            oldDist = brick.UltrasonicDist(4);
            moveForward(brick, speedPercentage, 2);
            set = 1;
        end
        else
            disp('Turning left due to big distance...');
            stopMotors(brick, 'Brake');
            brick.MoveMotor('B', speedPercentage);
            pause(pauseTime);
            stopMotors(brick, 'Brake');
            oldDist = brick.UltrasonicDist(4);
            moveForward(brick, speedPercentage, 2);
        end


        
    end

    if brick.TouchPressed(3) > 0
        disp("Backing up...");
        stopMotors(brick, 'Brake');
        pause(pauseTime);
        moveForward(brick, -30, 1);
        disp('Turning right...');
        brick.MoveMotor('C', 0);
        brick.MoveMotor('B', -speedPercentage);
        pause(pauseTime);
        stopMotors(brick, 'Brake');
       
    else
        moveStraight(brick, speedPercentage);
    end

    newDist = brick.UltrasonicDist(4); % Update distance
end
