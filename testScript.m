% Test Script for Project 6 classes
close all

%% Test class Interval
% Uncomment below to run Interval tests
%{
i1 = Interval(3, 9); % Instantiate an Interval with endpoints 3 and 9
L = i1.left;         % Should be 3, access public property directly.
a2 = i1.overlap(Interval(5, 15)); % a2 is an Interval with endpoints 5 and 9
w = a2.getWidth();   % Should be 4, the width of the Interval referenced by a2
%}

%% Test class Event
% Uncomment below to run Event tests
%{
e1 = Event(3, 20, 10, 0.5, 4); % Event with id 4, importance 0.5, duration 10, available [3,20]
disp(e1.available.right) % Should output 20
disp(e1.available.getWidth()) % Should output 17
% disp(e1.id) % Error: id is private
e1.setScheduledTime(5) % Set event time, should not produce an error
% e1.setScheduledTime(-1) % Uncomment to test error case
figure; hold on;
e1.draw() % Should display colored box with left edge at x=5
hold off;
%}

%% Test class Schedule
% Uncomment below to run Schedule tests
%{
e2 = Event(0, 30, 8, 0.3, 1);
e3 = Event(8, 25, 6, 0, 5);
s = Schedule(0, 40, ''); % Instantiate Schedule, s.eventArray initially empty
% s.sname = 'School'; % ERROR: property sname has private set access
disp(s.sname) % Should output 'Test Schedule' since get access is public
s.addEvent(e2) % Add Event e2 to s.eventArray
s.addEvent(e3)
s.addEvent(Event(10, 38, 5, 1, 2))
disp(s) % s.eventArray should now be a length 3 cell array of Events
s.eventArray{1}.getId() % Should output 1
s.eventArray{1}.setScheduledTime(21)
figure; hold on;
s.eventArray{1}.draw() % Should display colored box with left edge at x=21
s.draw();
hold off;
%}

%% Test class Course
% Uncomment below to run Course tests
%{
c1 = Course(8, 25, 6, 0.5, 6, 'CS1000');
c2 = Course(8, 25, 7, 0.5, 8, 'CS1050');
figure; hold on;
c1.draw() % Initial draw, should see white box with x range 8 to 25
c1.setScheduledTime(9)
hold off;
figure; hold on;
c1.draw() % Second draw, should see colored box with left edge at x=9 and course name in the middle
hold off;
% s.addEvent(c1)
% disp(s.eventArray) % Should now include a Course object
%}
