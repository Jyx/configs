#!/bin/bash


case "$1" in
        start)
        	vncserver -geometry 1600x1200 -name telldusvnc 
            ;;
         
        stop)
                vncserver -kill :1
            ;;

	*)
            echo $"Usage: $0 {start|stop}"
            exit 1
esac
