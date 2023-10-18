#!/bin/bash

# Name:    MelissaMatchUpObjectGlobalLinuxJava
# Purpose: Use the MelissaUpdater to make the MelissaMatchUpObjectGlobalLinuxJava code usable

######################### Constants ##########################

RED='\033[0;31m' #RED
NC='\033[0m' # No Color

######################### Parameters ##########################

file=""
origin=""
license=""
quiet="false"

while [ $# -gt 0 ] ; do
  case $1 in
    -g | --global) 
        global="$2"

        if [ "$global" == "-u" ] || [ "$global" == "--us" ] || [ "$global" == "-l" ] || [ "$global" == "--license" ] || [ "$global" == "-q" ] || [ "$global" == "--quiet" ] || [ -z "$global" ];
        then
            printf "${RED}Error: Missing an argument for parameter \'global\'.${NC}\n"  
            exit 1
        fi  
        ;;
	-u | --us) 
        us="$2"

        if [ "$us" == "-g" ] || [ "$us" == "--global" ] || [ "$us" == "-l" ] || [ "$us" == "--license" ] || [ "$us" == "-q" ] || [ "$us" == "--quiet" ] || [ -z "$us" ];
        then
            printf "${RED}Error: Missing an argument for parameter \'global\'.${NC}\n"  
            exit 1
        fi  
        ;;	
    -l | --license) 
        license="$2"

        if [ "$license" == "-o" ] || [ "$license" == "--origin" ] || [ "$license" == "-f" ] || [ "$license" == "--file" ] || [ "$license" == "-q" ] || [ "$license" == "--quiet" ] || [ -z "$license" ];
        then
            printf "${RED}Error: Missing an argument for parameter \'license\'.${NC}\n"  
            exit 1
        fi    
        ;;
    -q | --quiet) 
        quiet="true" 
        ;;
  esac
  shift
done



######################### Config ###########################


RELEASE_VERSION='2023.Q3'
ProductName="GLOBAL_MU_DATA"

# Uses the location of the .sh file 
# Modify this if you want to use 
CurrentPath=$(pwd)
ProjectPath="$CurrentPath/MelissaMatchupObjectGlobalLinuxJava"
BuildPath="$ProjectPath"
DataPath="$ProjectPath/Data"

if [ ! -d $DataPath ];
then
    mkdir $DataPath
fi

if [ ! -d $BuildPath ];
then
    mkdir $BuildPath
fi

# Config variables for download file(s)
Config1_FileName="libmdMatchup.so"
Config1_ReleaseVersion=$RELEASE_VERSION
Config1_OS="LINUX"
Config1_Compiler="GCC48"
Config1_Architecture="64BIT"
Config1_Type="BINARY"

Config2_FileName="libmdGlobalParse.so"
Config2_ReleaseVersion=$RELEASE_VERSION
Config2_OS="LINUX"
Config2_Compiler="GCC48"
Config2_Architecture="64BIT"
Config2_Type="BINARY"

Wrapper_FileName="libmdMatchupJavaWrapper.so"
Wrapper_ReleaseVersion=$RELEASE_VERSION
Wrapper_OS="LINUX"
Wrapper_Compiler="JAVA"
Wrapper_Architecture="64BIT"
Wrapper_Type="INTERFACE"

Com_FileName="mdMatchup_JavaCode.zip"
Com_ReleaseVersion=$RELEASE_VERSION
Com_OS="ANY"
Com_Compiler="ANY"
Com_Architecture="ANY"
Com_Type="DATA"



# ######################## Functions #########################

DownloadDataFiles()
{
    printf "==================================== MELISSA UPDATER ====================================\n"
    printf "MELISSA UPDATER IS DOWNLOADING DATA FILE(S)...\n"

    MelissaUpdater/MelissaUpdater manifest -p $ProductName -r $RELEASE_VERSION -l $1 -t $DataPath 

    if [ $? -ne 0 ];
    then
        printf "\nCannot run Melissa Updater. Please check your license string!\n"
        exit 1
    fi     
    
    printf "Melissa Updater finished downloading data file(s)!\n"
}


DownloadSO() 
{
    printf "\nMELISSA UPDATER IS DOWNLOADING SO(s)...\n"
    
    # Check for quiet mode
    if [ $quiet == "true" ];
    then
        MelissaUpdater/MelissaUpdater file --filename $Config1_FileName --release_version $Config1_ReleaseVersion --license $1 --os $Config1_OS --compiler $Config1_Compiler --architecture $Config1_Architecture --type $Config1_Type --target_directory $BuildPath &> /dev/null
        if [ $? -ne 0 ];
        then
            printf "\nCannot run Melissa Updater. Please check your license string!\n"
            exit 1
        fi

        MelissaUpdater/MelissaUpdater file --filename $Config2_FileName --release_version $Config2_ReleaseVersion --license $1 --os $Config2_OS --compiler $Config2_Compiler --architecture $Config2_Architecture --type $Config2_Type --target_directory $BuildPath &> /dev/null
        if [ $? -ne 0 ];
        then
            printf "\nCannot run Melissa Updater. Please check your license string!\n"
            exit 1
        fi
    else
        MelissaUpdater/MelissaUpdater file --filename $Config1_FileName --release_version $Config1_ReleaseVersion --license $1 --os $Config1_OS --compiler $Config1_Compiler --architecture $Config1_Architecture --type $Config1_Type --target_directory $BuildPath 
        if [ $? -ne 0 ];
        then
            printf "\nCannot run Melissa Updater. Please check your license string!\n"
            exit 1
        fi
   
        MelissaUpdater/MelissaUpdater file --filename $Config2_FileName --release_version $Config2_ReleaseVersion --license $1 --os $Config2_OS --compiler $Config2_Compiler --architecture $Config2_Architecture --type $Config2_Type --target_directory $BuildPath 
        if [ $? -ne 0 ];
        then
            printf "\nCannot run Melissa Updater. Please check your license string!\n"
            exit 1
        fi
    fi
    
    printf "Melissa Updater finished downloading $Config_FileName!\n"
}

DownloadWrapper() 
{    
    # Check for quiet mode
    if [ $quiet == "true" ];
    then
        # Download the wrapper
        MelissaUpdater/MelissaUpdater file --filename $Wrapper_FileName --release_version $Wrapper_ReleaseVersion --license $1 --os $Wrapper_OS --compiler $Wrapper_Compiler --architecture $Wrapper_Architecture --type $Wrapper_Type --target_directory $ProjectPath &> /dev/null
        if [ $? -ne 0 ];
        then
            printf "\nCannot run Melissa Updater. Please check your license string!\n"
            exit 1
        fi

        # Download the com zip
        MelissaUpdater/MelissaUpdater file --filename $Com_FileName --release_version $Com_ReleaseVersion --license $1 --os $Com_OS --compiler $Com_Compiler --architecture $Com_Architecture --type $Com_Type --target_directory $ProjectPath &> /dev/null
        if [ $? -ne 0 ];
        then
            printf "\nCannot run Melissa Updater. Please check your license string!\n"
            exit 1
        fi
    else
        #Download the wrapper
        MelissaUpdater/MelissaUpdater file --filename $Wrapper_FileName --release_version $Wrapper_ReleaseVersion --license $1 --os $Wrapper_OS --compiler $Wrapper_Compiler --architecture $Wrapper_Architecture --type $Wrapper_Type --target_directory $ProjectPath 
        if [ $? -ne 0 ];
        then
            printf "\nCannot run Melissa Updater. Please check your license string!\n"
            exit 1
        fi

        # Download the com zip
        MelissaUpdater/MelissaUpdater file --filename $Com_FileName --release_version $Com_ReleaseVersion --license $1 --os $Com_OS --compiler $Com_Compiler --architecture $Com_Architecture --type $Com_Type --target_directory $ProjectPath 
        if [ $? -ne 0 ];
        then
            printf "\nCannot run Melissa Updater. Please check your license string!\n"
            exit 1
        fi
    fi
    
    printf "Melissa Updater finished downloading $Wrapper_FileName!\n"

    printf "Melissa Updater finished downloading $Com_FileName!\n"

   
    # Check for the zip folder and extract from the zip folder if it was downloaded
    if [ ! -f "$ProjectPath/mdMatchUp_JavaCode.zip" ];
    then
        printf "mdMatchUp_JavaCode.zip not found.\n"
        printf "Aborting program, see above.\n"

        exit 1
    else
        if [ ! -d "$ProjectPath/com" ];
        then
            printf "here\n"
            unzip "$ProjectPath/mdMatchUp_JavaCode.zip" -d "$ProjectPath"
        else
            rm -r "$ProjectPath/com"

            unzip "$ProjectPath/mdMatchUp_JavaCode.zip" -d "$ProjectPath"
        fi
    fi
}

CheckSOs() 
{
    if [ ! -f $BuildPath/$Config1_FileName ];
    then
        echo "false"
    elif [ ! -f $BuildPath/$Config2_FileName ];
    then    
        echo "false"
    else
        echo "true"
    fi
}


########################## Main ############################
printf "\n============================ Melissa MatchUp Object Global ==============================\n                               [ Java | Linux | 64BIT ]\n"

# Get license (either from parameters or user input)
if [ -z "$license" ];
then
  printf "Please enter your license string: "
  read license
fi

# Check for License from Environment Variables 
if [ -z "$license" ];
then
  license=`echo $MD_LICENSE` 
fi

if [ -z "$license" ];
then
  printf "\nLicense String is invalid!\n"
  exit 1
fi

# Use Melissa Updater to download data file(s) 
# Download data file(s) 
DownloadDataFiles $license      # comment out this line if using Release

# # Set data file(s) path
# #DataPath=""      # uncomment this line and change to your Release data file(s) directory 

# #if [ ! -d $DataPath ]; # uncomment this section of code if you are using your own Release data file(s) directory
# #then
#     #printf "\nData path is invalid!\n"
#     #exit 1
# #fi

# # Download SO(s)
DownloadSO $license 

# # Download wrapper(s)
DownloadWrapper $license

# # Check if all SO(s) have been downloaded. Exit script if missing
printf "\nDouble checking SO file(s) were downloaded...\n"

SOsAreDownloaded=$(CheckSOs)

if [ "$SOsAreDownloaded" == "false" ];
then
    printf "\n$Config_FileName not found"
    printf "\nMissing the above data file(s).  Please check that your license string and directory are correct.\n"

    printf "\nAborting program, see above.\n"
    exit 1
fi

printf "\nAll file(s) have been downloaded/updated!\n"

# # Start program

cd $ProjectPath
printf "\n===================================== BUILD PROJECT =====================================\n"
javac -cp .:com/melissadata/*.java MelissaMatchupObjectGlobalLinuxJava.java
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/.
jar cvfm MelissaMatchupObjectGlobalLinuxJava.jar manifest.txt com/melissadata/*.class *.class *.so


# Run Project
if [ -z "$global" ] && [ -z "$us" ];
then
    java -jar MelissaMatchupObjectGlobalLinuxJava.jar --license "$license"  --dataPath "$DataPath"
else
    java -jar MelissaMatchupObjectGlobalLinuxJava.jar --license "$license"  --dataPath "$DataPath" --global "$global" --us "$us"
fi
