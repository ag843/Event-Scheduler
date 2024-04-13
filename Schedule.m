classdef Schedule < handle
    % Schedule manages a set of events within a specified time window.

    properties (SetAccess = private)
        sname = 'Test Schedule'; % The name of the schedule
        window = Interval.empty(); % The Interval in which events can be scheduled
        eventArray = {}; % The cell array of events
    end

    methods
        function obj = Schedule(startTime, endTime, scheduleName)
            % Constructor for Schedule class.
            if nargin >= 2
                obj.window = Interval(startTime, endTime); % Create scheduling window
                if nargin == 3
                    obj.sname = scheduleName; % Set schedule name if provided
                end
            else
                error('Insufficient input arguments');
            end
            obj.eventArray = {}; % Initialize with an empty event array
        end

        function addEvent(obj, ev)
            % Adds an Event to the end of the event array.
            obj.eventArray{end+1} = ev;
        end

        function extras = scheduleEvents(obj)
            % Attempts to schedule all events within the window, following specific heuristics.
            % Unschedules all events first
            arrayfun(@(e) e.unschedule(), obj.eventArray);

            % Initialize the remaining window to be the same as the main window
            remainingWindow = obj.window;
            scheduledSomething = true;
            extras = {};

            while scheduledSomething
                scheduledSomething = false;
                earliestTime = inf;
                bestEventIndex = 0;
                bestRatio = 0;

                for i = 1:length(obj.eventArray)
                    event = obj.eventArray{i};
                    if event.scheduledTime == -1  % Check only unscheduled events
                        startTime = event.earliestTime(remainingWindow);
                        ratio = event.importance / event.duration;
                        if (startTime < earliestTime) || (startTime == earliestTime && ratio > bestRatio)
                            earliestTime = startTime;
                            bestEventIndex = i;
                            bestRatio = ratio;
                            scheduledSomething = true;
                        end
                    end
                end

                if scheduledSomething && bestEventIndex ~= 0
                    event = obj.eventArray{bestEventIndex};
                    event.setScheduledTime(earliestTime);
                    remainingWindow.left = earliestTime + event.duration; % Update the remaining window
                end
            end

            % Gather unscheduled events
            extras = obj.eventArray([obj.eventArray.scheduledTime] == -1);
        end

        function draw(obj)
            % Sets up the figure window and draws the schedule and all events.
            figure('units', 'normalized', 'outerposition', [0 0.05 1 0.95]);
            hold on;
            title(obj.sname);
            xlabel('Time');
            ylabel('Event ID');

            % Calculate the min and max ID for axis scaling
            if ~isempty(obj.eventArray)
                ids = arrayfun(@(e) e.getId(), obj.eventArray);
                minId = min(ids);
                maxId = max(ids);
            else
                minId = 0;
                maxId = 1;
            end

            axis([obj.window.left obj.window.right minId-1 maxId+1]);
            set(gca, 'ytick', minId:maxId);

            % Draw each event
            cellfun(@(e) e.draw(), obj.eventArray);
            hold off;
        end
    end
end
