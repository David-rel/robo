global key;
InitKeyboard();

FORWARD_SPEED = 40;
BACKWARD_SPEED = -40;

% Main loop
while 1
    pause(0.1);
    disp('Autonomous Mode: Running...');
    
    % Check for obstacle
    if brick.TouchPressed(1) ~= 0
        disp('Obstacle detected in front');
        brick.MoveMotor('B', 36);
        brick.MoveMotor('C', 33);
        pause(0.75);
        brick.StopAllMotors();
        
        if isRightBlocked()
            turnLeft();
        else
            turnRight();
        end
    else
        % Adjust speed based on ultrasonic sensor
        rightDist = brick.UltrasonicDist(4);
        leftSpeed = -38;
        rightSpeed = -40;
        
        if rightDist > 30
            rightSpeed = rightSpeed + 2;
            leftSpeed = leftSpeed - 2;
        elseif rightDist < 20
            rightSpeed = rightSpeed - 2;
            leftSpeed = leftSpeed + 2;
        end
        
        brick.MoveMotor('D', rightSpeed);
        brick.MoveMotor('A', leftSpeed);
    end
    
    % Check for 'q' key to exit loop
    switch key
        case 'q'
            break;
    end
end

CloseKeyboard();

% Functions

function isBlocked = isRightBlocked()
    global brick;
    distance = brick.UltrasonicDist(4);
    isBlocked = distance < 30;
end

function turnLeft()
    global brick;
    disp('Turning left...');
    brick.MoveMotor('C', -36);
    brick.MoveMotor('B', 32);
    pause(1);
    brick.StopAllMotors();
end

function turnRight()
    global brick;
    disp('Turning right...');
    brick.MoveMotor('C', 36);
    brick.MoveMotor('B', -32);
    pause(1);
    brick.StopAllMotors();
end
