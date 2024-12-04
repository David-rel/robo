% brick = ConnectBrick('ANT');
% speed may be the issue
done = 0;
oldDist = 0;
pauseTime = 1.0;
turnSpeedPercentage = 50;
moveSpeedPercentage = 50;
set = 0;
largeDistance = 105;
smallDistance = 60;
angle = 250;
gotPerson = 1; % Initialize variable

% Function to move straight
function moveStraight(brick, speed)
    brick.MoveMotor('B', speed-7);
    brick.MoveMotor('C', speed);
end

% Function to move forward for a duration
function moveForward(brick, speed, duration)
    brick.MoveMotor('B', speed-7);
    brick.MoveMotor('C', speed);    pause(duration);
    brick.StopAllMotors('Brake');
end

function backUp(brick, speed, duration)
    brick.MoveMotor('B', -speed);
    brick.MoveMotor('C', -speed);    
    pause(duration);
    brick.StopAllMotors('Brake');
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
        case 5 % red
            stopMotors(brick, 'Brake');
            moveForward(brick, moveSpeedPercentage, 0.5);
            pause(pauseTime);

        case 4 % green
            if gotPerson == 0
                beepMultiple(brick, 1);
                pause(pauseTime);
                run('keyboard'); % Replace with actual required behavior
            end

        case 2 % Blue
            stopMotors(brick, 'Brake');
            beepMultiple(brick, 2);
            pause(pauseTime);
            gotPerson = 1;
            run('keyboard'); % Replace with actual required behavior

        case 3 % yellow
             beepMultiple(brick, 3);
            pause(pauseTime);
            run('keyboard'); % Replace with actual required behavior
    end

    if newDist > smallDistance
        %moveForward(brick, moveSpeedPercentage, 1);
        if newDist < largeDistance %&& set < 2  
            disp('Turning left due to decently big distance...');
            stopMotors(brick, 'Brake');
                    brick.MoveMotorAngleRel('C', turnSpeedPercentage, -angle, 'Brake');
    brick.MoveMotorAngleRel('B', turnSpeedPercentage, angle, 'Brake');
        brick.WaitForMotor('BC')
            oldDist = brick.UltrasonicDist(4);
            moveForward(brick, moveSpeedPercentage, 2);
            set = set + 1; % Increment set
        elseif newDist > largeDistance
            disp('Turning left due to big distance...');
            stopMotors(brick, 'Brake');
         brick.MoveMotorAngleRel('C', turnSpeedPercentage, -angle, 'Brake');
    brick.MoveMotorAngleRel('B', turnSpeedPercentage, angle, 'Brake');
        brick.WaitForMotor('BC')
            moveForward(brick, moveSpeedPercentage, 2);
        end
    end

    if brick.TouchPressed(3) > 0
        newDist = brick.UltrasonicDist(4);
        disp("Backing up...");
        stopMotors(brick, 'Brake');

        pause(pauseTime);
        backUp(brick, moveSpeedPercentage, 1);

        if newDist < 60
            disp('Turning right...');
            brick.StopAllMotors();
    brick.MoveMotorAngleRel('B', turnSpeedPercentage, -angle, 'Brake');
    brick.MoveMotorAngleRel('C', turnSpeedPercentage, angle, 'Brake');
        brick.WaitForMotor('BC')

        else
            disp('Turning left...');
            brick.StopAllMotors();
                brick.MoveMotorAngleRel('C', turnSpeedPercentage, -angle, 'Brake');
    brick.MoveMotorAngleRel('B', turnSpeedPercentage, angle, 'Brake');
        brick.WaitForMotor('BC')
        end

        pause(pauseTime);
        stopMotors(brick, 'Brake');
        moveForward(brick, moveSpeedPercentage, 1);
    else
        moveStraight(brick, moveSpeedPercentage);
    end

    newDist = brick.UltrasonicDist(4); % Update distance
end
