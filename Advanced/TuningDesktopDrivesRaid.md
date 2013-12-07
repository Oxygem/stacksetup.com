$title=Tuning Desktop Drives for RAID

Warning: desktop drives are not designed for use in RAID arrays. By default they will error-correct for a minute+, whereas in a RAID setup you want the drive to give up after a short (few seconds) period because the data can be recovered from another drive.

Often the difference (that I can find) between desktop/consumer and server/enterprise drives is the error-correction time. Fortunately certain manufacturers allow us to modify their error-correction time on desktop grade drives via SMART. This will not work with all drives!


To show the current error time:

    smartctl -l scterc /dev/sda

And to set the error time (to 7 seconds):

    smartctl -l scterc,70,70 /dev/sda