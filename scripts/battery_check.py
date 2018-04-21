#!/usr/bin/env python
# coding=UTF-8

import math, subprocess, os

p = subprocess.Popen(["ioreg", "-rc", "AppleSmartBattery"], stdout=subprocess.PIPE)
output = p.communicate()[0]

o_max = [l for l in output.splitlines() if 'MaxCapacity' in l][0]
o_cur = [l for l in output.splitlines() if 'CurrentCapacity' in l][0]
o_time_remaining = [l for l in output.splitlines() if 'TimeRemaining' in l][0]
o_is_charging = [l for l in output.splitlines() if 'IsCharging' in l][0]

b_max = float(o_max.rpartition('=')[-1].strip())
b_cur = float(o_cur.rpartition('=')[-1].strip())
b_time_remaining = float(o_time_remaining.rpartition('=')[-1].strip())
b_is_charging = o_is_charging.rpartition('=')[-1].strip() != 'No'

charge_percent = math.floor(b_cur / b_max * 100)

battery_path = os.path.expanduser('~/.battery')

if os.path.isdir(battery_path) == False:
    os.mkdir(battery_path)

charging_file_path = battery_path + '/charging'

if b_is_charging:
    os.utime(open(charging_file))
elif os.path.isfile(charging_file_path):
    os.remove(charging_file_path)

# Output
f = open(battery_path + '/percent', 'w')
f.write(str(charge_percent))
