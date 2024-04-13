classdef Event < handle
    % Event represents an activity with an ID, duration, and importance, and can be scheduled within a defined interval.

    properties (Access = private)
        id % Unique identifier for the event
    end

    properties
        available = Interval.empty(); % Interval during which the event can be scheduled
        duration  % Duration of the event
        importance % Importance of the event, ranging from 0 to 1
        scheduledTime = -1 % Scheduled start time of the event; defaults to -1 indicating unscheduled
    end
    
    methods
        function obj = Event(availableStart, availableFinish, duration, importance, id)
            % Constructor for Event class. Initializes an event with given time bounds, duration, importance, and ID.
            if nargin == 5
                obj.available = Interval(availableStart, availableFinish);
                obj.duration = duration;
                obj.importance = importance;
                obj.id = id;
            else
                error('Event constructor requires exactly 5 arguments.');
            end
        end
        
        function t = earliestTime(obj, possibleInterval)
            % Determine the earliest possible scheduling time within the given interval.
            intersection = overlap(obj.available, possibleInterval);
            if isempty(intersection) || intersection.getWidth() < obj.duration
                t = inf; % No feasible schedule
            else
                t = intersection.getLeft(); % Feasible starting time
            end
        end

        function setScheduledTime(obj, t)
            % Set the scheduled time for the event.
            obj.scheduledTime = t;
        end
        
        function unschedule(obj)
            % Reset the scheduled time to indicate the event is not scheduled.
            obj.scheduledTime = -1;
        end
        
        function id = getId(obj)
            % Retrieve the private ID of the event.
            id = obj.id;
        end
        
        function draw(obj)
            % Draw the event representation on a graphical figure.
            % Available time is shown as a white rectangle, and the scheduled time is shown in a color gradient.
            baseColor = [1, 0, 1]; % Magenta for unimportant
            targetColor = [0, 1, 1]; % Cyan for important
            interpolatedColor = obj.importance * targetColor + (1 - obj.importance) * baseColor;

            % Draw available interval as a white rectangle
            rectangle('Position', [obj.available.left, obj.getId() - 0.4, obj.available.right - obj.available.left, 0.8], ...
                      'EdgeColor', 'k', 'FaceColor', 'w');

            % If scheduled, draw the event time
            if obj.scheduledTime ~= -1
                xCoords = [obj.scheduledTime, obj.scheduledTime + obj.duration, obj.scheduledTime + obj.duration, obj.scheduledTime];
                yCoords = [obj.getId() - 0.4, obj.getId() - 0.4, obj.getId() + 0.4, obj.getId() + 0.4];
                fill(xCoords, yCoords, interpolatedColor, 'EdgeColor', 'k');
            end
        end
    end
end
