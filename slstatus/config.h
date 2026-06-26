
const unsigned int interval = 200;

static const char unknown_str[] = "n/a";

#define MAXLEN 2048

static const struct arg args[] = {
	{ run_command, "%s", "printf '                                󰤨 '; iwgetid -r" },
	{ run_command, " | %s", "pamixer --get-mute | grep -q true && printf \"󰸈 %3d%%\" $(pamixer --get-volume) || printf \"󰕾 %3d%%\" $(pamixer --get-volume)" },
	{ battery_perc, " | 󰁹 %3s%%", "BAT0" },
	{ battery_state, " %s", "BAT0" },
	{ datetime, " |  %s", "%a %d/%m" },
	{ datetime, " | 󰥔 %s", "%H:%M " },
};
