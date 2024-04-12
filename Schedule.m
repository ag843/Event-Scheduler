classdef Schedule < handle
% A schedule has an Interval window in which events can be scheduled and 
% a cell array of Events.
    
    properties (SetAccess = private)
        sname= 'Test Schedule';                % The name of the schedule
        window= Interval.empty(); % The Interval in which events can be 
                                  %   scheduled
        eventArray= {};           % The cell array of events
    end
    
    methods
        function s = Schedule(startTime, endTime, scheduleName)
        % Construct schedule s.  s.window goes from startTime to endTime.
        % s.sname is the string name that is shown on the schedule.
        % s.eventArray starts as an empty cell array.
            %%%% Write your code below %%%%
            if nargin==2
                s.window=Interval(statTime, endTime); 
            end 
            if nargin==3
                s.sname=scheduleName;
            end 
            %Schedule starts off empty
            s.eventArray={};
        end
        
        function addEvent(self, ev)
        % Adds Event ev to the end of self.eventArray
            %%%% Write your code below %%%%
            self.eventArray{length(self.eventArray)+1}=ev;
            %self.eventArray{size(self.eventArray)+1}=ev;
        end
        
        function extras = scheduleEvents(self)
        % Schedule events from self.eventArray in self.window.  First
        % unschedules all events.  Then use a heuristic to schedule events
        % as follows:
        % 1. Define a "remaining window," which is the window available for
        %    scheduling events.  Initialize the remaining window to be the 
        %    same as window (same left and reight ends).
        % 2. Find the earliest unscheduled event that can be scheduled in
        %    the remaining window.
        % 3. If multiple events have the same earliest time, choose the
        %    event with the highest ratio of importance to duration.
        % 4. If the event is scheduled, update the remaining window.
        % 5. Repeat steps 2 to 4 until no events can be scheduled.
        % extras is a cell array of the Events (and Courses) that did not
        % get scheduled.  The length of extras is the number of events that
        % did not get scheduled.  If all events got scheduled then extras
        % is the empty cell array {}.
            
            %%%% Write your code below %%%%

            %Unschedules everything 
            for i=1:1:length(self.eventArray)
                unschedule(self.eventArray{i})
            end 
            %initialize remianing window --> 
            remainingWindow=Interval(self.window.left, self.window.right);
            canSchedule=true;
            while canSchedule==true
                %Find the earliest unscheduled event or the event with highest
                %ratio of importance to duration 
                %Question: how do you compare it to the previous earliest
                %class?
                canSchedule=false;
                prevRatio=0;
                earliestTime=inf;
                for k=1:1:length(self.eventArray)
                   eventIndex=0;
                   startTime=self.eventArray{k}.earliestTime(remainingWindow);
                    if self.eventArray{k}.scheduledTime==-1 && startTime~=inf
                        if startTime>earliestTime || (startTime==earliestTime ...
                          && self.eventArray{k}.importance/self.eventArray{k}.duration ...
                          > prevRatio)
                            %store earliesttime and the ratio of that event
                            earliestTime=earliestTime(self.eventArray{k}, reaminingWindow);
                            eventIndex=k;
                            prevRatio=self.eventArray{k}.importance/self.eventArray{k}.duration; 
                        end
                    end 
                end 

                if eventIndex~=0
                %Update remaingWindow and schedule event 
                    setScheduledTime(self.eventArray{eventIndex}, earliestTime)
                    canSchedule=true; 
                    remainingWindow.left= earliestTime + self.eventArray{eventIndex}.duration;%the earliestTime + the event duration 
                    eventIndex=eventIndex+1;
                end 
            end 

            %Find extras 
            extras={};
            extrasIndex=1;
            %check each event to see if it was unscheduled 
            for j=1:1:length(self.eventArray)
                if self.eventArray{j}.scheduledTime==-1
                    extras{extrasIndex}=self.eventArray{j};
                    extrasIndex=extrasIndex+1;
                end 
            end 
        end
        
        function draw(self)
        % Draws the scedule and all the events.  This method sets up the 
        % figure window, shows the title (self.sname), labels the axes, and 
        % draws each event.  Figure window should be made full screen, 
        % ticks on the y-axis should only be drawn at integer (id) values 
        % and the axes should enclose only the scheduling window in the 
        % x-direction and only the range of event ids in the y-direction.
           minId=1;
           maxId=10;
           xmin=0;
           xmax=10;
            figure('units','normalized','outerposition',[0 .05 1 .95], 'name', 'Schedule')
            hold on
            set(gca, 'ytick', minId:maxId)
            title(self.sname);
            xlabel('the time(s)');
            ylabel('ID');
            axis([xmin xmax minId-1 maxId+1])
            hold off
            %%%% Write your code below %%%%
            %maxId=0;
            %drawss the event
            if length(self.eventArray)~=0
            for i=1:length(self.eventArray)
                self.eventArray{i}.draw
            end
            end

        end
    end %methods
    
end

