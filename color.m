% brick.SetColorMode(2,2); % port 2, ambient light mode
while 1
    disp("runing");
    color = brick.ColorCode(1);
    disp(color);
    pause(1);
if color == 5
    disp("red");
end
if color == 3
    disp("green");
end
if color == 2
    disp("blue");
end
if color == 4
    disp("yellow");
end
end