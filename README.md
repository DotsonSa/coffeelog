# A Simple Coffee Script Timer

## Not for timing coffee, but it's consumption

  Two methods for listing time since last coffee entry/drinking, with the other just being coffee drank/entered as the time stamp. 
  It marks down the time when the drank command is entered as a unix time stamp, and reads it out. Currently only supports one time stamp.

### Changes to implement

1. longer history
  * Keep 10 time stamps the tmp file
  * Also, add various options for showing time stamps

2. track coffee consumed in a day
  * Compare time stamps and add up the amount consumed in a 24 hour period
