function [s, extras] = createSchedule(dataFilename, scheduleStart, scheduleFinish)
    % Creates a schedule from event data in a text file.
    %   dataFilename: String, the name of the text data file.
    %   scheduleStart, scheduleFinish: Numerical values defining the scheduling window.
    %   Events are added and scheduled using a heuristic defined in the Schedule class.

    % Open the data file
    fid = fopen(dataFilename, 'r');
    if fid == -1
        error('Failed to open file: %s', dataFilename);
    end
    
    % Create a new schedule with the given name and window
    s = Schedule(scheduleStart, scheduleFinish, 'My Schedule');

    % Read each line from the file and create corresponding events
    while ~feof(fid)
        line = fgetl(fid);
        id = str2double(line(3:6));
        startAvailable = str2double(line(8:11));
        endAvailable = str2double(line(13:16));
        duration = str2double(line(18:21));
        importance = str2double(line(23:28));
        
        if line(1) == 'e'
            % Base event
            event = Event(startAvailable, endAvailable, duration, importance, id);
        elseif line(1) == 'c' && length(line) >= 30
            % Course event
            courseName = line(30:end);
            event = Course(startAvailable, endAvailable, duration, importance, id, courseName);
        else
            error('Invalid event type or incomplete data in line: %s', line);
        end
        
        % Add event to the schedule
        s.addEvent(event);
    end

    % Close the file
    fclose(fid);

    % Attempt to schedule the events using the heuristic defined in Schedule class
    extras = s.scheduleEvents();

    % Draw the schedule
    s.draw();
end
