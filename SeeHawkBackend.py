''' Demonstrates how to subscribe to and handle data from gaze and event streams '''

import time
import math
import adhawkapi
import adhawkapi.frontend
from adhawkapi import Events, MarkerSequenceMode, PacketType

class Info:
    def __init__(self):
        self.BlinkCount = 0
        self.SaccadeCount = 0
        self.TimeStartedBool = False
        self.TimeStarted = 0
        self.TimeNow = 0
        self.VergenceCount = 0
        self.ZoneOutCount = 0
        self.prevX = 0
        self.ReadingSpeed = 0
        self.LinesCount = 0
        self.coolDown = True
        self.lastPageTurn = 0
        #self.LineSpeed = 0


class Frontend:

    ''' Frontend communicating with the backend '''

    def __init__(self):
        # Instantiate an API object
        self._api = adhawkapi.frontend.FrontendApi()

        self.info = Info()

        # Tell the api that we wish to tap into the GAZE data stream
        # with self._handle_gaze_data_stream as the handler
        self._api.register_stream_handler(PacketType.GAZE, self._handle_gaze_data_stream)

        # Tell the api that we wish to tap into the EVENTS stream
        # with self._handle_event_stream as the handler
        self._api.register_stream_handler(PacketType.EVENTS, self._handle_event_stream)

        # Start the api and set its connection callback to self._handle_connect_response. When the api detects a
        # connection to a MindLink, this function will be run.
        self._api.start(connect_cb=self._handle_connect_response)

        # Disallows console output until a Quick Start has been run
        self._allow_output = False

        # Used to limit the rate at which data is displayed in the console
        self._last_console_print = None

        # Flags the frontend as not connected yet
        self.connected = False
        print('Starting frontend...')

    def shutdown(self):
        ''' Shuts down the backend connection '''

        # Stops api camera capture
        self._api.stop_camera_capture(lambda *_args: None)

        # Stop the log session
        self._api.stop_log_session(lambda *_args: None)

        # Shuts down the api
        self._api.shutdown()

    def quickstart(self):
        ''' Runs a Quick Start using AdHawk Backend's GUI '''

        # The MindLink's camera will need to be running to detect the marker that the Quick Start procedure will
        # display. This is why we need to call self._api.start_camera_capture() once the MindLink has connected.
        self._api.quick_start_gui(mode=MarkerSequenceMode.FIXED_GAZE, marker_size_mm=35,
                                  callback=(lambda *_args: None))

        # Allows console output
        self._allow_output = True

    def _handle_gaze_data_stream(self, timestamp, x_pos, y_pos, z_pos, vergence):
        ''' Prints gaze data to the console '''

        # Only log at most once per second
        if self._last_console_print and timestamp < self._last_console_print + 1:
            return


        if self._allow_output:
            self._last_console_print = timestamp
            if (self.info.TimeStartedBool == False):
                self.info.TimeStarted = timestamp
                self.info.TimeStartedBool = True
            if (vergence > 0.35 and ((timestamp - self.info.lastPageTurn) > 5)):
                self.info.VergenceCount += 1
                self.info.lastPageTurn = timestamp
            if (self.info.prevX > x_pos + 0.015):
                self.info.LinesCount += 1
            self.info.prevX = x_pos
            if (timestamp - self.info.TimeStarted < 10):
                self.info.BlinkCount = 0
                self.info.LinesCount = 0
                self.info.SaccadeCount = 0
                self.info.VergenceCount = 0
            blinkcount_string = f'Blink Count:\t\t{self.info.BlinkCount}'
            atten_span_string = f'Attention Span Ratio:\t\t{(self.info.BlinkCount + 1)/(self.info.SaccadeCount + 1)}'
            time_passed_string = f'Time passed:\t\t{(math.floor(timestamp - self.info.TimeStarted))}'
            pages_read_string = f'Pages read:\t\t{self.info.VergenceCount}'
            lines_read_string = f'Lines read:\t\t{self.info.LinesCount}'
            reading_spead_string = f'Reading Speed:\t\t{round(self.info.LinesCount/(timestamp + 0.01  - self.info.TimeStarted), 2)}'
            print(blinkcount_string)
            print(atten_span_string)
            print(time_passed_string)
            print(pages_read_string)
            print(lines_read_string)
            print(reading_spead_string)
            print(vergence)
            print('\n')

            #open text file
            text_file = open("tracker_data.txt", "w")
            
            #write string to file
            text_file.write(f'{x_pos}' + '\n' +
            f'{y_pos}' + '\n' +
                f'{self.info.BlinkCount}' + '\n' +
                            f'{(self.info.BlinkCount + 1)/(self.info.SaccadeCount + 1)}' +'\n' +
                            f'{(math.floor(timestamp - self.info.TimeStarted))}' +'\n' +
                            f'{self.info.VergenceCount}' +'\n' +
                            f'{self.info.LinesCount}' +'\n' +
                            f'{round(self.info.LinesCount/(timestamp + 0.01  - self.info.TimeStarted), 2)}')

            # text_file.write(blinkcount_string + atten_span_string + time_passed_string + pages_read_string + lines_read_string + reading_spead_string)
            
            #close file
            text_file.close()

           # )
           ## print(f'Gaze data\n'
                 ## f'Time since connection:\t{timestamp}\n'
                 ##f'Y coordinate:\t\t{y_pos}\n'
                 ## f'Z coordinate:\t\t{z_pos}\n'
                  ##f'Vergence angle:\t\t{vergence}\n'
                  ##)

    def _handle_event_stream(self, event_type, _timestamp, *_args):
        ''' Prints event data to the console '''
        if self._allow_output:

            # We discriminate between events based on their type
            if event_type == Events.BLINK.value:
                self.info.BlinkCount += 1
            elif event_type == Events.SACCADE.value:
                self.info.SaccadeCount += 1

    def _handle_connect_response(self, error):
        ''' Handler for backend connections '''

        # Starts the camera and sets the stream rate
        if not error:
            print('Connected to AdHawk Backend Service')

            # Sets the GAZE data stream rate to 125Hz
            self._api.set_stream_control(PacketType.GAZE, 125, callback=(lambda *_args: None))

            # Tells the api which event streams we want to tap into. In this case, we wish to tap into the BLINK and
            # SACCADE data streams.
            self._api.set_event_control(adhawkapi.EventControlBit.BLINK, 1, callback=(lambda *_args: None))
            self._api.set_event_control(adhawkapi.EventControlBit.SACCADE, 1, callback=(lambda *_args: None))

            # Starts the MindLink's camera so that a Quick Start can be performed. Note that we use a camera index of 0
            # here, but your camera index may be different, depending on your setup. On windows, it should be 0.
            self._api.start_camera_capture(camera_index=0, resolution_index=adhawkapi.CameraResolution.MEDIUM,
                                           correct_distortion=False, callback=(lambda *_args: None))

            # Starts a logging session which saves eye tracking signals. This can be very useful for troubleshooting
            self._api.start_log_session(log_mode=adhawkapi.LogMode.BASIC, callback=lambda *args: None)

            # Flags the frontend as connected
            self.connected = True


def main():
    '''Main function'''

    frontend = Frontend()
    try:
        print('Plug in your MindLink and ensure AdHawk Backend is running.')
        while not frontend.connected:
            pass  # Waits for the frontend to be connected before proceeding

        input('Press Enter to run a Quick Start.')

        # Runs a Quick Start at the user's command. This tunes the scan range and frequency to best suit the user's eye
        # and face shape, resulting in better tracking data. For the best quality results in your application, you
        # should also perform a calibration before using gaze data.
        frontend.quickstart()

        while True:
            # Loops while the data streams come in
            time.sleep(1)
    except (KeyboardInterrupt, SystemExit):

        # Allows the frontend to be shut down robustly on a keyboard interrupt
        frontend.shutdown()


if __name__ == '__main__':
    main()
