#!/bin/sh
# Shell script to print to PDF files
# Parameters $1 = spool file (smbprn . . . )
# $2 = user name
# $3 = user home directory
# $4 = print job name
OUTDIR =/srv/samba/pdf
  echo Converting $1 to “$4” for user $2 in $3 >> pdfprint.log
  ps2pdf $1 “$OUTDIR/$4.pdf”
rm $1
