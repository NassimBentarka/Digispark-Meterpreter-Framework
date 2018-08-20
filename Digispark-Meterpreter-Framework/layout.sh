#!/bin/sh
#!/bin/bash

#az_qw_convert.sh - Enhanced by NBN - (Case sensitive input)
txt=$1
#read txt
echo "$txt" | sed 'y/aAqQwWzZ,?;.:mM/qQaAzZwWmM,<.;:/' | sed "y/!\//\/>/" | sed 'y/&é"(-è_çà)°1234567890^¨$£µ%§/123567890-_!@#$%^&*()[{]}¦"?/' | sed "y/ù'/'4/"
