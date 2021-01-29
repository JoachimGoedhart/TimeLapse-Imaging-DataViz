// Macro to add a column with the time in the 'Results' window
// The time is calculated from the Frame interval defined by the user
// In this macro the timer interval is defined by the variable 'interval'
// Created by Joachim Goedhart with essential input from Jerome Mutterer (@jmutterer)

//Set the interval (alternatively it can be set from the menu: 'Image > Properties')
interval=2
Stack.setFrameInterval(interval)

//Calculate the time for each frame and add to the results window
code="Time=Slice*"+Stack.getFrameInterval();
Table.applyMacro(code);
