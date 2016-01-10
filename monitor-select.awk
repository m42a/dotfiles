# Gets the primary monitor from xrandr 1.4.3
# If there is no primary monitor, gets the topmost leftmost monitor

# Skip all checks if we found the primary monitor already
got_primary == 1 { next; }

# Skip any unconnected monitors or non-monitor lines
$2 != "connected" { next; }

# Choose the primary monitor above all other monitors
$3 == "primary" { mode = $4; got_primary = 1; next; }

# This is the first monitor; take it
mode == "" { mode = $3; next; }

# This monitor is a candidate; compare it to the current monitor
function afterplus(mode)
{
	return substr(mode, index(mode, "+")+1)
}

{
	cur_offset = afterplus(mode);
	new_offset = afterplus($3);

	cur_x = cur_offset+0;
	cur_y = afterplus(cur_offset)+0;

	new_x = new_offset+0;
	new_y = afterplus(new_offset)+0;

	if (new_x < cur_x || (new_x == cur_x && new_y < cur_y))
		mode = $3;
}

# Print the best monitor in a manner parsable by read(1)
END { gsub(/[x+]/, " ", mode); print mode; }
