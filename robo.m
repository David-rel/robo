%brick = ConnectBrick('ANT');
done = 0;
% brick.setColorMode(2,1); % port 2, ambient light mode
% Color sensor must be connected t port 2, ultrasonic to D, 
% touch sensor to A, 
% Motors are B and C.
while done == 0
    newDist = 0;
    oldDist = 0;
    
    while brick.TouchPressed(3) == 0
        color = brick.ColorCode(1);
        distance = brick.UltrasonicDist(4);
        disp("distance: " + distance);
        disp("color: " + color)
        if distance > 102                                              
            brick.MoveMotor('B', 30);
            brick.MoveMotor('C', -30);
            
            pause(1);
            brick.MoveMotor('B', 40);
            brick.MoveMotor('C', 40);
            %could need if
            
            pause(3);
        end
        brick.MoveMotor('B', 40);
        brick.MoveMotor('C', 40);
        if color == 5 % red
            brick.StopAllMotors('Brake');
            pause(1);
            brick.MoveMotor('B', 40);
            brick.MoveMotor('C', 40);
            pause(2);
        end 
        if color == 3 % green
            brick.beep();
            pause(0.5);
            brick.beep();
            pause(0.5);
            brick.beep();
            pause(0.5);
            brick.StopAllMotors('Brake');
            pause(1);
            brick.MoveMotor('B',-50);
            brick.MoveMotor('C', -50);
            pause(2); 
            brick.MoveMotor('B', -25);
            brick.MoveMotor('C', 25);
            disp("turning right due to: " + color);
            pause(1);
        end
        if color == 2 % blue
            brick.beep();
            pause(0.5);
            brick.beep();
            pause(0.5);x
            brick.StopAllMotors('Brake');
            pause(1);
            brick.MoveMotor('B',-50);
            brick.MoveMotor('C', -50);
            pause(2); 
            brick.MoveMotor('B', -25);
            brick.MoveMotor('C', 25);
            disp("turning right due to: " + color);
            pause(1);
        end
        if color == 4 % yellow
            brick.StopAllMotors('Brake');
            pause(1);
        end
    end
    if brick.TouchPressed(3) == 1
        brick.StopAllMotors('Brake');
        pause(2);
        brick.MoveMotor('B', -30);
        brick.MoveMotor('C', -30);
        pause(1);
        % turn right
        if distance < 65                                                  
            brick.MoveMotor('B', -25);
            brick.MoveMotor('C', 25);
            disp("turning right due to: " + distance);
            pause(1);
        % turn left
        else 
            brick.MoveMotor('B', 25);
            brick.MoveMotor('C', -25);
            disp("turning left due to: " + +distance);
            pause(1);
        end
    end
        
end 