classdef Course < Event
    % Course is a subclass of Event with an additional property for the course name.

    properties (Access = private)
        courseName = ''; % Name of the course
    end
    
    methods
        function obj = Course(openTime, closeTime, duration, importance, id, name)
            % Constructor for the Course class.
            % Constructs an object by first calling the constructor of the superclass Event.
            % If all parameters are provided, it sets the course name.
            
            % Default values if not all arguments except 'name' are provided
            if nargin < 5
                openTime = 0;
                closeTime = 0;
                duration = 0;
                importance = 0;
                id = -1;
            end
            
            % Call to superclass (Event) constructor
            obj = obj@Event(openTime, closeTime, duration, importance, id);
            
            % Set course name if provided
            if nargin == 6
                obj.courseName = name;
            end
        end
        
        function courseName = getCourseName(obj)
            % Returns the course name.
            courseName = obj.courseName;
        end

        function draw(obj)
            % Custom draw method for Course objects.
            % Calls the draw method from Event, then draws the course name if the event is scheduled.
            
            % Call superclass draw method
            draw@Event(obj);
            
            % Draw course name if the course is scheduled
            if obj.scheduledTime ~= -1
                middle = (obj.scheduledTime + obj.scheduledTime + obj.duration) / 2;
                text(middle, obj.getId, obj.courseName, 'HorizontalAlignment', 'center');
            end
        end
    end
end
