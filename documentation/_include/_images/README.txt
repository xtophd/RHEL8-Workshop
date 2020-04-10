## Put images for documentation here

## 2019
# I used imagemagick to crop the screenshots

    magick convert test.png -crop 1024x768+448+143 new.png   

# The WINDOWS/CMD/DOS cmdline version in a "for loop"
# This will put a cropped image of the same filename in a directory ".\crops"

    FOR %a in (*.png) DO magick convert "%a" -crop 1024x768+448+143 ".\crops\%a"
  
## 2020 - Display size 1920x1200

    magick convert test.png -crop  1920x1160+0+72 new.png
    
    FOR %a in (*.png) DO magick convert "%a" -crop 1920x1160+0+72  ".\crops\%a"

    Then used PowerPoint to annotate the images and export to PNG

