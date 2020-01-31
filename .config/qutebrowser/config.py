from sys import platform

# Require a confirmation before closing windows while things are happening
c.confirm_quit = ['multiple-tabs', 'downloads']

# Always restore open sites when qutebrowser is reopened.
c.auto_save.session = True

c.content.autoplay = False

# Google doesn't need to know my location
config.set('content.geolocation', False, 'https://www.google.com')

# Use pdf.js to view PDF files in the browser.
c.content.pdfjs = True

# Shrink the completion to be smaller than the configured size if there
# are no scrollbars.
c.completion.shrink = True

c.tabs.background = True

c.tabs.last_close = 'close'

c.url.default_page = 'about:blank'

c.url.searchengines = {
    **c.url.searchengines,
    'cpp': 'https://en.cppreference.com/mwiki/index.php?search={}',
    'ddg': 'https://duckduckgo.com/?q={}',
    'g': 'https://google.com/search?q={}',
    'u': 'https://youtube.com/results?search_query={}',
    'w': 'https://en.wikipedia.org/w/index.php?search={}',
    'wg21': 'https://wg21.link/{}'
}

# Make pinned tabs the same color as unpinned tabs
c.colors.tabs.pinned.even.bg = c.colors.tabs.even.bg
c.colors.tabs.pinned.even.fg = c.colors.tabs.even.fg
c.colors.tabs.pinned.odd.bg = c.colors.tabs.odd.bg
c.colors.tabs.pinned.odd.fg = c.colors.tabs.odd.fg

c.fonts.web.size.minimum = 6

if platform == "linux":
    clipboard = "{selection}"
else:
    clipboard = "{clipboard}"

# Bindings for normal mode
config.bind('<Alt+Left>', 'back')
config.bind('<Alt+Right>', 'forward')
config.unbind('<Ctrl+Return>')
config.bind('<Ctrl+Shift+Tab>', 'tab-prev')
config.bind('<Ctrl+Tab>', 'tab-focus')
config.bind('P', f'open -t -- {clipboard}')
config.unbind('PP')
config.unbind('Pp')
config.bind('p', f'open -- {clipboard}')
config.unbind('pP')
config.unbind('pp')

# Bindings for command mode
config.bind('<Ctrl+Return>', 'set-cmd-text --append .com ;; command-accept', mode='command')

if platform == 'win32':
    # Bindings for insert mode
    config.bind('<Shift+Ins>', f'insert-text {clipboard}', mode='insert')

if platform == "linux" and "Terminus" not in c.fonts.monospace:
    c.fonts.monospace = "xos4 Terminus, Terminus, " + c.fonts.monospace

# Allow machine-specific settings to override these settings
config.load_autoconfig()
