import XMonad
import XMonad.Actions.CopyWindow
import XMonad.Actions.CycleWS
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.EwmhDesktops
import XMonad.Hooks.ICCCMFocus
import XMonad.Hooks.ManageDocks
import XMonad.Hooks.ManageHelpers
import XMonad.Hooks.UrgencyHook
import XMonad.Layout.LayoutHints
import XMonad.Layout.NoBorders
import XMonad.ManageHook
import XMonad.Util.EZConfig
import XMonad.Util.Run

import qualified XMonad.StackSet as W

getScreenWidth = do
	d <- openDisplay ""
	let s = defaultScreenOfDisplay d
	let w = widthOfScreen s
	closeDisplay d
	return w

-- Have a convenient way to sink windows in my manage hook
doSink = (ask >>= doF . W.sink)

-- Put all my IMs on desktop 8 and prevent xmonad recompilation errors from
-- resizing my windows, plus tile/float my games
myManageHook = composeAll [
	isDialog --> doCenterFloat,
	className =? "Xmessage" --> doFloat,
	className =? "Pidgin" --> doShift "8",
	title =? "Jamestown" --> doFloat,
	title =? "osu!" --> doSink,
	manageDocks]

-- The default plus an option to center the current window instead of
-- stretching it.  Then don't draw borders if there's only 1 window on the
-- screen and try not to overlap my statusbar
myLayoutHook = avoidStruts (smartBorders tall ||| smartBorders (Mirror tall) ||| smartBorders Full ||| (layoutHintsToCenter $ smartBorders Full))
	where tall = Tall 1 (3/100) (1/2)

-- Leave space for trayer and the other dzen
getDzenCommand = do
	width <- getScreenWidth
	-- Strictly evaluate width before returning
	seq width $ return $ "dzen2 -e 'button2=;' -x 250 -h 16 -w " ++ show (width - 500)

-- Make dzen have nice colors
myPP h = defaultPP {
	-- Selected workspace
	ppCurrent = wrap "^fg(#77d7d7)" "^fg()",
	-- Deselected workspaces
	ppVisible = wrap "^fg(#777777)" "^fg()",
	ppHidden = wrap "^fg(#777777)" "^fg()",
	-- Something requires my attention
	ppUrgent = wrap "^fg(#f0b77f)" "^fg()",
	-- Current window title
	ppTitle = wrap "^fg(white)" "^fg()",
	ppSep = " - ",
	ppWsSep = " ",
	ppOutput = hPutStrLn h
}

dzenLogHook = dynamicLogWithPP . myPP

-- Adds the keys in y to x's config, but let y depend on x
addKeys x y = additionalKeys x (y x)

myKeys conf =
	-- Lock the screen
	[((mod4Mask .|. shiftMask, xK_z), unsafeSpawn "xscreensaver-command -lock && xset s activate"),
	-- Start firefox
	((mod4Mask, xK_f), safeSpawn "firefox" ["--no-remote"]),
	-- Take a screenshot
	((mod4Mask, xK_s), safeSpawn "scrot" ["%Y.%m.%d-%T.png", "-e", "mv -f $f ~"]),
	-- Take a screenshot of a window
	((mod4Mask .|. shiftMask, xK_s), safeSpawn "scrot" ["%Y.%m.%d-%T.png", "-s", "-e", "mv -f $f ~"]),
	-- If there are multiple instances of a window only kill the focused one
	((mod4Mask .|. shiftMask, xK_c), kill1),
	-- Make windows overlap dzen and the system tray
	((mod4Mask, xK_b), sendMessage ToggleStruts),
	-- Cycle through workspaces
	((mod4Mask, xK_Right), nextWS),
	((mod4Mask, xK_Left), prevWS),
	-- Cycle through workspaces and bring the current window with me
	((mod4Mask .|. shiftMask, xK_Right), shiftToNext >> nextWS),
	((mod4Mask .|. shiftMask, xK_Left), shiftToPrev >> prevWS)]
	++
	-- Copy the current window to another desktop
	[(((mod4Mask .|. shiftMask .|. controlMask), k), windows $ copy i)
		| (i, k) <- zip (workspaces conf) [xK_1 ..]]

-- Highlight urgent windows and enable Extended Hints
myConfig dzen = withUrgencyHook NoUrgencyHook $ ewmh defaultConfig {
	terminal = "urxvt",
	modMask = mod4Mask,
	logHook = dzenLogHook dzen >> takeTopFocus,
	layoutHook = myLayoutHook,
	manageHook = myManageHook
	}
	`addKeys`
	myKeys

main = do
	dzenCommand <- getDzenCommand
	dzen <- spawnPipe dzenCommand
	xmonad $ myConfig dzen
