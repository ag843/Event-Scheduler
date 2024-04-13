# Event Scheduler

## Overview
This project provides a set of MATLAB classes designed to facilitate event scheduling within defined intervals. The core components include the classes `Interval`, `Event`, `Schedule`, and `Course`, each of which plays a role in creating a flexible and robust scheduler.

### Components

#### Interval
Represents a time interval with a start (`left`) and end (`right`) point. Offers functionality to determine overlaps with other intervals and compute interval width.

#### Event
Models an individual event with a unique ID, a scheduling interval, a duration, an importance level, and a scheduled start time. The Event class includes methods to set the scheduled time and to draw the event on a MATLAB figure to visualize its timing.

#### Schedule
Manages a collection of `Event` objects within a specified scheduling window. The `Schedule` class can add events, attempt to optimally place them within the window based on a heuristic, and visualize the scheduled events.

#### Course
A subclass of `Event` that adds a specific course name as an additional property. It is treated similarly to events but includes the course name in its visualization.

#### Running Tests
To test the functionality of each class, you can use the provided script testScript.m. This script includes specific test cases to verify the correct behavior of each component in isolation and in combination. Uncomment the sections of the script to perform the tests.
