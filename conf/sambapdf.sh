#!/bin/bash

# This script converts a PS spoolfile into a PDF.
# Copyright (C) Marc Muehlfeld <samba@marc-muehlfeld.de> 2014
#
# This program is free software; you can redistribute it
# and/or modify it under the terms of the GNU General
# Public License as published by the Free Software Foundation;
# Either version 3 of the License, or (at your option) any
# later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public
# License along with this program; if not, see <http://www.gnu.org/licenses/>.

# Print usage/help
usage () {
   cat << EOF

   Usage: $0 -s SPOOLFILE -d DESTINATION [OPTIONS]

   This script converts a PS spoolfile into a PDF.

   -h			Help
   -s SPOOLFILE		Path to PS spoolfile (mandatory)
   -d DESTINATION	Destination folder for PDF (mandatory)
   -o OWNER		Owner of the created PDF file
   -g GROUP		Group of the created PDF file
   -m MODE		File mode of the created PDF file
   -p PREFIX		Default is "Samba_PDF_Printer". Prefix is always
			extended by a timestamp
   -l LOGFILE		Write output to logfile

   To use this script in Samba, add the following to your smb.conf:
   [Pdfprinter]
        comment = Samba Virtual PDF Printer
        path = /var/spool/samba
        printable = Yes
        lpq command =
        lprm command =
        print command = /usr/local/bin/Pdfprint.sh -s %f \\
                        -d /home/%U -o %U -m 600

   Use any postscript driver, like HP Laserjet 2300 PS.
EOF
   exit 1
}



# Print messages to stdout / logfile
output () {
	if [ -z "$LOG" ] ; then
		echo -e "$(date "+%b %d %H:%M:%S") $*"
	else
		echo -e "$(date "+%b %d %H:%M:%S") $*" | tee -a "$LOG"
	fi
}



# Parse shell parameters/options
while getopts "hs:d:o:g:l:m:p:" OPTION ; do

        case $OPTION in
                h) usage ;;
                s) SPOOLFILE="$OPTARG" ;;
                d) DESTDIR="$OPTARG" ;;
                o) OWNER="$OPTARG" ;;
                g) GROUP="$OPTARG" ;;
		l) LOG="$OPTARG" ;;
		m) MODE="$OPTARG" ;;
		p) PREFIX="$OPTARG" ;;
                *) usage ;;
        esac

done



# Check mandatory parameters
if [ ! -r "$SPOOLFILE" ] || [ ! -d "$DESTDIR" ] ; then
	output "Mandatory parameter missing or something is wrong with one" \
	       "of its options!\n"
	usage
	exit 1
fi



# Set default prefix if -d wasn't set
test -z "$PREFIX" && PREFIX="Samba_PDF_Printer"



FILENAME="${PREFIX}_$(date +%Y-%m-%d_%H-%M-%S).pdf"
DESTFILE="$DESTDIR/$FILENAME"



# Convert spoolfile to PDF
if ps2pdf "$SPOOLFILE" "$DESTFILE" > /dev/null 2>&1 ; then
	output "Successfully converted \"$SPOOLFILE\" to \"$DESTFILE\"."
else
	output "ps2pdf failed converting \"$SPOOLFILE\" to \"$DESTFILE\"!"
fi



rm -f "$SPOOLFILE"



# File owner
if [ ! -z "$OWNER" ] ; then
	chown "$OWNER" "$DESTFILE" > /dev/null 2>&1
	test $? -ne 0 \
	   && output "Setting owner \"$OWNER\" on \"$DESTFILE\" failed."
fi



# Group permissions
if [ ! -z "$GROUP" ] ; then
	chgrp "$GROUP" "$DESTFILE" > /dev/null 2>&1
	test $? -ne 0 \
	   && output "Setting group \"$GROUP\" on \"$DESTFILE\" failed."
fi



# File mode
if [ ! -z "$MODE" ] ; then
	chmod "$MODE" "$DESTFILE" > /dev/null 2>&1
	test $? -ne 0 \
	   && output "Setting file mode \"$MODE\" on \"$DESTFILE\" failed."
fi



exit 0
