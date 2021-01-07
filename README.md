<!-- Vincent Zoechling 11913652 -->
# Einfuehrung In Die Digitale Bildverarbeitung - Car Brand Recognition

**Version 1.0.0**

#### Description
This project is aimed towards creating a MATLAB application which can 
determine the brand of a car when driving into a parking spot.

## Table of content
- [**Getting Started**](#getting-started)
- [Built With](#built-with)
- [Contributors](#contributors)
- [License](#license)
- [Get Help](#get-help)
- [Motivation](#motivation)
- [Links and Resources](#links-and-resources)

## Getting started
You need to have [MATLAB](https://de.mathworks.com/products/matlab.html "MathWorks Website") installed on your computer.
Then follow the following steps 

### Install
* Clone this repository or download the files 
* Setup MATLAB with the files in your working directory 
    * Make sure that you have the folders **VideoFiles** and **logos**
    * For this to work you also need to setup an additional folder called **Frames**
        * *NOTE:* the F must be a captial F and not a small f

### Informations for Usage
* There is a file called [Video2Frames.m](https://github.com/FOENIXFIRE/EinfuehrungInDieDigitaleBildverarbeitung/blob/main/Video2Frames.m)
  This function saves the frames of a given video in the *Frames* folder under the condition that the file is a **".mov"** file.
  If you want to use this function with another video data format, you have to change *line 14* in the code and adjust the file type.
* The reason for you needing to make the *Frames* folder yourself is that the frames need to be stored somewhere but get deleted
  in the end to prevent bugs and storage issues. In GitHub it is not possible to commit empty folders, therefor the notice to create the folder yourself.

### MATLAB - Application

####Starting the matlab app without optical-flow
To start our program, download the brandDetector.zip folder and unzip it. Start the file brandDetector.mlapp and press „Run“.
Now select a predefined image in the drop down menu and click on the „Get Brand“ button in the middle.
After a few seconds you will see the result in the textfield below and next to it an image with the brand.
You can also see the status of the program with the lamp, if it glows red, the program is not finished yet.

####optical Flow
For our program to work the intended way, you first need to call a series of functions
* **[image, bbox] = carDetection_opticalFlow('skodamp4')** (skodamp4 is a sample File)
This function needs an input-parameter, which must be a file name of an existing video file in den *VideoFiles* folder
* **croppedImage = carCropping(image, bbox)** 
This function takes the parameters and returns a cropped image, which can be used in the brandDetector-application


## Built with
This project was realised using a software called 'MATLAB'. Beware that 
this software is not free to use and is only freely available for a testing
trial. We were all using a student license which we obtained via the 
university we are currently attending. For further informations concerning
MATLAB please visit the [official website](https://de.mathworks.com/products/matlab.html "MathWorks Website")



## Contributors
- Vincent Zoechling <e11913652@student.tuwien.ac.at>
- Lucio Delen <e11713066@student.tuwien.ac.at>
- Kevin Baur <e11827180@student.tuwien.ac.at>
- Manuel Lautschacher <e11822449@student.tuwien.ac.at>
- Jan Koenig <01007167@student.tuwien.ac.at>

#### Issues
In the case of a bug report, bugfix or a suggestions, please feel very free to open an issue.

## Get Help
- Contact either of us using the email adresses above.
- If appropriate, [open an issue](https://github.com/FOENIXFIRE/EinfuehrungInDieDigitaleBildverarbeitung/issues)


## License 
This project is licensed under the [MIT License](License). 

## Motivation
This project is a group project. It is part of an lecture at the 
[TUWIEN Univeristy](https://www.tuwien.at/ "TUWIEN Website"). We wanted to
create an interesting image processing project involving cars which we share an
interest in. The recognition of license plates was implemented by a group of
last years students for which reason we were not allowed to choose this as 
the topic of our project. Therefor we chose brand recognition which is not only 
a new topic but also more complex.  

## Links and Resources
Resources for the README:
[Tutorial and Help - README by Simon Hoiberg](https://github.com/SimonHoiberg/Hue-Debugger-UI)

Resources for the project:
[See all resources](Resources.md)
