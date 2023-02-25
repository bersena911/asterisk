#!/usr/bin/env bash

nohup python file_watch.py &
/usr/sbin/asterisk -vvvdddf -T -W -U asterisk -p