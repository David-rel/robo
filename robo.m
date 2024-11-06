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

% Function to adjust movement based on distance
function fixMovement(brick, oldDist, newDist)
    if newDist < oldDist
        % Moving closer to the wall, so turn slightly right
        disp("Adjusting: Getting closer to wall, turning right");
        turnRight(brick, 20, 0.5);
    elseif newDist > oldDist
        % Moving away from the wall, so turn slightly left
        disp("Adjusting: Moving away from wall, turning left");
        turnLeft(brick, 20, 0.5);
    elseif abs(newDist - oldDist) > 50
        % Significant distance increase, indicating an opening
        disp("Opening detected, adjusting to move forward");
        moveForward(brick, 40, 1);
    end
end

% Main loop
while done == 0
    oldDist = brick.UltrasonicDist(4); % Initial distance check
    
    while brick.TouchPressed(3) == 0
        color = brick.ColorCode(1);
        newDist = brick.UltrasonicDist(4);
        disp("New distance: " + newDist);
        disp("Color: " + color);

        % Fix movement based on distance change
        fixMovement(brick, oldDist, newDist);
        
        % Update oldDist for the next loop
        oldDist = newDist;

        % Check color and respond accordingly
        switch color
            case 5 % red
                stopMotors(brick, 'Brake');
                pause(1);
                moveForward(brick, 40, 2);
                
            case 3 % green
                stopMotors(brick, 'Brake');
                beepMultiple(brick, 3); % Beep three times
                pause(1);
                moveForward(brick, -50, 2);
                turnRight(brick, 25, 1);

            case 2 % blue
                stopMotors(brick, 'Brake');
                beepMultiple(brick, 2); % Beep two times
                pause(1);
                moveForward(brick, -50, 2);
                turnRight(brick, 25, 1);

            case 4 % yellow
                stopMotors(brick, 'Brake');
                pause(1);
        end
    end

    % Action on touch press
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
