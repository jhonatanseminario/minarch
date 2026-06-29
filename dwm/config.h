#include <X11/XF86keysym.h>

static const unsigned int borderpx  = 0;
static const unsigned int snap      = 0;
static const int showbar            = 1;
static const int topbar             = 0;
static const char *fonts[]          = { "monospace:size=10" };
static const char dmenufont[]       = "monospace:size=10";
static const char col_gray1[]       = "#000000";
static const char col_gray2[]       = "#000000";
static const char col_gray3[]       = "#ffffff";
static const char col_gray4[]       = "#000000";
static const char col_cyan[]        = "#000000";
static const char *colors[][3]      = {
	[SchemeNorm] = { col_gray3, col_gray1, col_gray2 },
	[SchemeSel]  = { col_gray4, col_cyan,  col_cyan  },
};

static const char *tags[] = { "" };

static const Rule rules[] = {
	{ "Firefox",  NULL,       NULL,       1 << 8,       0,           -1 },
};

static const float mfact     = 0.55;
static const int nmaster     = 1;
static const int resizehints = 1;
static const int lockfullscreen = 1;
static const int refreshrate = 120;

static const Layout layouts[] = {
	{ "",      monocle },
	{ "",      tile },
	{ "",      NULL },
};

#define MODKEY Mod4Mask
#define TAGKEYS(KEY,TAG) \
	{ MODKEY,                       KEY,      view,           {.ui = 1 << TAG} }, \
	{ MODKEY|ControlMask,           KEY,      toggleview,     {.ui = 1 << TAG} }, \
	{ MODKEY|ShiftMask,             KEY,      tag,            {.ui = 1 << TAG} }, \
	{ MODKEY|ControlMask|ShiftMask, KEY,      toggletag,      {.ui = 1 << TAG} },

#define SHCMD(cmd) { .v = (const char*[]){ "/bin/sh", "-c", cmd, NULL } }

static char dmenumon[2] = "0";
static const char *dmenucmd[] = { "dmenu_run", "-m", dmenumon, "-fn", dmenufont, "-nb", col_gray1, "-nf", col_gray3, "-sb", col_cyan, "-sf", col_gray4, NULL };
static const char *termcmd[]  = { "st", NULL };

static const Key keys[] = {
	{ MODKEY,                       XK_Return, spawn,          SHCMD("alacritty") },
	{ MODKEY,                       XK_e,      spawn,          SHCMD("nautilus") },
	{ MODKEY,                       XK_b,      spawn,          SHCMD("google-chrome-stable") },
	{ MODKEY,                       XK_c,      spawn,          SHCMD("code") },
	{ MODKEY|ShiftMask,             XK_s,      spawn,          SHCMD("flameshot gui") },
	{ MODKEY|ShiftMask,             XK_l,      spawn,          SHCMD("slock") },
	{ MODKEY|ShiftMask,             XK_x,      spawn,          SHCMD("slock & sleep 0.5 && systemctl suspend") },
	{ 0,                            XF86XK_AudioMute,          spawn, SHCMD("pamixer -t") },
	{ 0,                            XF86XK_AudioRaiseVolume,   spawn, SHCMD("pamixer -i 5") },
	{ 0,                            XF86XK_AudioLowerVolume,   spawn, SHCMD("pamixer -d 5") },
	{ 0,                            XF86XK_MonBrightnessUp,    spawn, SHCMD("brightnessctl -e set +5%") },
	{ 0,                            XF86XK_MonBrightnessDown,  spawn, SHCMD("brightnessctl -e set 5%-") },
	{ 0,                            XF86XK_AudioPlay,          spawn, SHCMD("playerctl play-pause") },
	{ 0,                            XF86XK_AudioStop,          spawn, SHCMD("playerctl stop") },
	{ 0,                            XF86XK_AudioPrev,          spawn, SHCMD("playerctl previous") },
	{ 0,                            XF86XK_AudioNext,          spawn, SHCMD("playerctl next") },
	{ MODKEY,                       XK_p,      spawn,          {.v = dmenucmd } },
	{ MODKEY|ShiftMask,             XK_Return, spawn,          {.v = termcmd } },
	{ MODKEY,                       XK_j,      focusstack,     {.i = +1 } },
	{ MODKEY,                       XK_k,      focusstack,     {.i = -1 } },
	{ MODKEY,                       XK_i,      incnmaster,     {.i = +1 } },
	{ MODKEY,                       XK_d,      incnmaster,     {.i = -1 } },
	{ MODKEY,                       XK_h,      setmfact,       {.f = -0.05} },
	{ MODKEY,                       XK_l,      setmfact,       {.f = +0.05} },
	{ MODKEY,                       XK_Tab,    view,           {0} },
	{ MODKEY|ShiftMask,             XK_c,      killclient,     {0} },
	{ MODKEY,                       XK_t,      setlayout,      {.v = &layouts[1]} },
	{ MODKEY,                       XK_f,      setlayout,      {.v = &layouts[2]} },
	{ MODKEY,                       XK_m,      setlayout,      {.v = &layouts[0]} },
	{ MODKEY,                       XK_space,  setlayout,      {0} },
	{ MODKEY|ShiftMask,             XK_space,  togglefloating, {0} },
	{ MODKEY,                       XK_0,      view,           {.ui = ~0 } },
	{ MODKEY|ShiftMask,             XK_0,      tag,            {.ui = ~0 } },
	{ MODKEY,                       XK_comma,  focusmon,       {.i = -1 } },
	{ MODKEY,                       XK_period, focusmon,       {.i = +1 } },
	{ MODKEY|ShiftMask,             XK_comma,  tagmon,         {.i = -1 } },
	{ MODKEY|ShiftMask,             XK_period, tagmon,         {.i = +1 } },
	TAGKEYS(                        XK_1,                      0)
	TAGKEYS(                        XK_2,                      1)
	TAGKEYS(                        XK_3,                      2)
	TAGKEYS(                        XK_4,                      3)
	TAGKEYS(                        XK_5,                      4)
	TAGKEYS(                        XK_6,                      5)
	TAGKEYS(                        XK_7,                      6)
	TAGKEYS(                        XK_8,                      7)
	TAGKEYS(                        XK_9,                      8)
	{ MODKEY|ShiftMask,             XK_q,      quit,           {0} },
};

static const Button buttons[] = {
	{ ClkWinTitle,          0,              Button2,        zoom,           {0} },
	{ ClkStatusText,        0,              Button2,        spawn,          {.v = termcmd } },
	{ ClkClientWin,         MODKEY,         Button1,        movemouse,      {0} },
	{ ClkClientWin,         MODKEY,         Button2,        togglefloating, {0} },
	{ ClkClientWin,         MODKEY,         Button3,        resizemouse,    {0} },
};
