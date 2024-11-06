% Connect and configure brick
brick = ConnectBrick('ANT');
done = 0;

% Function to move motors forward
function moveForward(brick, speed, duration)
    brick.MoveMotor('B', speed);
    brick.MoveMotor('C', speed);
    pause(duration);
end

% Function to stop all motors
function stopMotors(brick, mode)
    brick.StopAllMotors(mode);
end

% Function to turn right
function turnRight(brick, speed, duration)
    brick.MoveMotor('B', -speed);
    brick.MoveMotor('C', speed);
    pause(duration);
end

% Function to turn left
function turnLeft(brick, speed, duration)
    brick.MoveMotor('B', speed);
    brick.MoveMotor('C', -speed);
    pause(duration);
end

% Function to beep a specified number of times
function beepMultiple(brick, times)
    for i = 1:times
        brick.beep();
        pause(0.5);
    end
end

function fixMovement(brick, oldDist, newDist, distanceThreshold, cooldownTime, consecutiveThreshold)
    persistent consecutiveCloser consecutiveFarther lastAdjustmentTime
    
    % Initialize counters if they are empty
    if isempty(consecutiveCloser)
        consecutiveCloser = 0;
    end
    if isempty(consecutiveFarther)
        consecutiveFarther = 0;
    end
    if isempty(lastAdjustmentTime)
        lastAdjustmentTime = tic; % Start the timer
    end

    distanceDiff = abs(newDist - oldDist);
    
    % Only proceed if the distance difference is significant enough
    if distanceDiff < distanceThreshold
        return; % Skip minor fluctuations
    end

    % Cooldown check to prevent continuous adjustments
    if toc(lastAdjustmentTime) < cooldownTime
        return;
    end

    % Detect closer or farther trends with consecutive checks
    if newDist < oldDist
        consecutiveCloser = consecutiveCloser + 1;
        consecutiveFarther = 0;
    elseif newDist > oldDist
        consecutiveFarther = consecutiveFarther + 1;
        consecutiveCloser = 0;
    end

    % Adjust only if the trend is consistent for the required checks
    if consecutiveCloser >= consecutiveThreshold
        disp("Adjusting: Consistently getting closer to wall, turning right");
        turnRight(brick, 20, 0.5);
        consecutiveCloser = 0; % Reset counter after adjustment
        lastAdjustmentTime = tic; % Reset cooldown timer
    elseif consecutiveFarther >= consecutiveThreshold
        disp("Adjusting: Consistently moving away from wall, turning left");
        turnLeft(brick, 20, 0.5);
        consecutiveFarther = 0; % Reset counter after adjustment
        lastAdjustmentTime = tic; % Reset cooldown timer
    end
end


% Main loop
oldDist = brick.UltrasonicDist(4); 

while done == 0
    color = brick.ColorCode(1);
    newDist = brick.UltrasonicDist(4);
    disp("New distance: " + newDist);
    disp("Color: " + color);

    fixMovement(brick, oldDist, newDist, 10, 0.5, 3);
    oldDist = newDist;

    switch color
        case 5 % red
            stopMotors(brick, 'Brake');
            pause(1);
            moveForward(brick, 40, 2);
            
        case 3 % green
            stopMotors(brick, 'Brake');
            beepMultiple(brick, 3);
            pause(1);
            moveForward(brick, -50, 2);
            turnRight(brick, 25, 1);

        case 2 % blue
            stopMotors(brick, 'Brake');
            beepMultiple(brick, 2);
            pause(1);
            moveForward(brick, -50, 2);
            turnRight(brick, 25, 1);

        case 4 % yellow
            stopMotors(brick, 'Brake');
            pause(1);
    end

    if brick.TouchPressed(3) == 1
        stopMotors(brick, 'Brake');
        pause(2);
        moveForward(brick, -30, 1);
        
        if newDist < 65
            turnRight(brick, 25, 1);
            disp("Turning right due to: " + newDist);
        else
            turnLeft(brick, 25, 1);
            disp("Turning left due to: " + newDist);
        end
    end
end
