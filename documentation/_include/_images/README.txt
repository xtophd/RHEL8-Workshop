## Put images for documentation here

# I used imagemagick to crop the screenshots

    magick convert test.png -crop 1024x768+448+143 new.png   

# The WINDOWS/CMD/DOS cmdline version in a "for loop"
# This will put a cropped image of the same filename in a directory ".\crops"

    FOR %a in (*.png) DO magick convert %a -crop 1024x768+448+143 .\crops\%a
  
  
  
