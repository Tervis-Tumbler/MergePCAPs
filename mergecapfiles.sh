#!/bin/bash

#Takes multiple 150 MB PCAP files and merges them into 1 GB
#PCAP files, then zips the merged files with a time stamp to
#the home directory. Must be ran as sudo!

#Set pcap_no variable
pcap_no=0

#For the progress tracker
Progress=0
ii=0

#Prompt user for Pcap directory
printf "\nEnter directory of PCap files and press [Enter]"
printf "\nPcap directory: "
read PcapDir

#Make Processed directory
ProcessedDir=Processed_$(date "+%Y%m%d_%H%M%S")
mkdir ~/$ProcessedDir

#Switch to pcap log directory
cd $PcapDir

#Get number of files
filenumber=$(ls | wc -l)

#Make tmp directory
mkdir tmp

printf "\nTotal files: ${filenumber}\n"

for (( i = 0; i < $filenumber; i = i + 5 )); do

        #Grab first five files
        filelist=$(ls -p | grep -v / | head -5)

        #Add one to Pcap file number
        ((pcap_no=pcap_no+1))

        #Run the mergecap
        mergecap -w ~/${ProcessedDir}/pcap${pcap_no}.pcap $filelist

        #Move to tmp directory
        mv $filelist tmp/

        #Progress
        ((Progress = 100 * ii / $filenumber))
        printf "\nCreating PCap${pcap_no}... Total Progress: ${Progress}%%"
        ((ii = ii + 5))
done

#Move files back from tmp directory and clean up
mv tmp/* .
rm -r tmp

#Zip the Processed directory
printf "\n100%%\n\nZipping PCap files...\n"
cd ~
zip -r PCap_$(date "+%Y%m%d_%H%M%S").zip $ProcessedDir

#Remove the Processed directory
printf "\nCleaning up..."
rm -r ${ProcessedDir}

#End of script
printf "\n\nDone!\n\n"
