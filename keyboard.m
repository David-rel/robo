 
global key
 InitKeyboard();
 while 1
     pause(0.1)
     switch key
         case 'uparrow'
             disp('Move forward');
             brick.MoveMotor('C', 45);
             brick.MoveMotor('B', 45);
         case 'downarrow'
             disp('Move baqckward');
             brick.MoveMotor('C', -45);
             brick.MoveMotor('B', -45);
         case 'rightarrow'
             disp('Turn right');
             brick.MoveMotor('B', -42);
             brick.MoveMotor('C', 42);
             pause(1);
         case 'leftarrow'
             disp('Turn left');
             brick.MoveMotor('B', 42);
             brick.MoveMotor('C', -42);
             pause(1);
         case 0
             disp('No key is pressed');
             brick.MoveMotor('BC', 0);
             pause(0.5);
         case 'w'
             brick.MoveMotor('A', -5);
             pause(1);
             brick.MoveMotor('A', 0);
         case 's'
             brick.MoveMotor('A', 5);
             pause(1);          
             brick.MoveMotor('A', 0);
         case 'q'
             break;
     end
 end
 CloseKeyboard();