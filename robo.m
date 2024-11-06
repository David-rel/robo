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

function turnRight(brick, speed, duration)
    brick.MoveMotor('B', -speed);
    brick.MoveMotor('C', speed);
    pause(duration);
end

function turnLeft(brick, speed, duration)
    brick.MoveMotor('B', speed);
    brick.MoveMotor('C', -speed);
    pause(duration);
end

function beepMultiple(brick, times)
    for i = 1:times
        brick.beep();
        pause(0.5);
    end
end

function fixMovement(brick, oldDist, newDist, distanceThreshold, cooldownTime, consecutiveThreshold)
    persistent consecutiveCloser consecutiveFarther lastAdjustmentTime
    
    if isempty(consecutiveCloser)
        consecutiveCloser = 0;
    end
    if isempty(consecutiveFarther)
        consecutiveFarther = 0;
    end
    if isempty(lastAdjustmentTime)
        lastAdjustmentTime = tic;
    end

    distanceDiff = abs(newDist - oldDist);
    
    if distanceDiff < distanceThreshold
        return;
    end

    if toc(lastAdjustmentTime) < cooldownTime
        return;
    end

    if newDist < oldDist
        consecutiveCloser = consecutiveCloser + 1;
        consecutiveFarther = 0;
    elseif newDist > oldDist
        consecutiveFarther = consecutiveFarther + 1;
        consecutiveCloser = 0;
    end

    if consecutiveCloser >= consecutiveThreshold
        disp("Adjusting: Consistently getting closer to wall, turning right");
        turnRight(brick, 20, 0.5);
        consecutiveCloser = 0;
        lastAdjustmentTime = tic;
    elseif consecutiveFarther >= consecutiveThreshold
        disp("Adjusting: Consistently moving away from wall, turning left");
        turnLeft(brick, 20, 0.5);
        consecutiveFarther = 0;
        lastAdjustmentTime = tic;
    end
end

oldDist = brick.UltrasonicDist(4);

while done == 0
    color = brick.ColorCode(1);
    newDist = brick.UltrasonicDist(4);
    disp("New distance: " + newDist);
    disp("Color: " + color);

    fixMovement(brick, oldDist, newDist, 10, 0.5, 3);
    oldDist = newDist;

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
            turnRight(brick, 25, 1);

        case 2
            stopMotors(brick, 'Brake');
            beepMultiple(brick, 2);
            pause(1);
            moveForward(brick, -50, 2);
            turnRight(brick, 25, 1);

        case 4
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
    else
        moveStraight(brick, 40); % Keep moving straight if no conditions are triggered
    end
end

