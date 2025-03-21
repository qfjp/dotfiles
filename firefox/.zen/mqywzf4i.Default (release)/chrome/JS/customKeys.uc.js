// ==UserScript==
// @name        customKeys
// @include     main
// @author      qfjp
// @description Custom keybindings (simulates some of tridactyl in restricted pages).
// @onlyonce

function hotkeyModFactory() {
    var keyToFuncMap = {};
    var keyIds = [];
    function activateKey(id, mods, key, cmd) {
        var keyName = mods + " " + key;
        if (keyIds.includes(id)) {
            console.log("Key ID '#" + id + "' already exists!");
            return;
        }
        if (Object.keys(keyToFuncMap).includes(keyName)) {
            oldVal = keyToFuncMap[keyName];
            if (oldVal !== cmd) {
                console.log("ERROR: Attempting to remap '" + keyName + "': '" + oldVal + "'->'" + cmd + "'");
            }
            return;
        }
        keyToFuncMap[keyName] = cmd;
        keyIds.push(id)
        console.log("    activating key '" + keyName + "' -> '" + cmd + "'");
        var keyObj = {id: id, modifiers: mods, key: key, command: cmd};
        UC_API.Hotkeys.define(keyObj).autoAttach({suppressOriginalKey: true});
    }
    return activateKey;
}
activateKey = hotkeyModFactory();

console.log("activating custom hotkeys");
activateKey('customKey_nextTab',              'ctrl',       'J', 'Browser:NextTab');
activateKey('customKey_prevTab',              'ctrl',       'K', 'Browser:PrevTab');
activateKey('customKey_nextWorkspace',        'ctrl shift', 'J', 'ZenWorkspaces.changeWorkspaceShortcut()');
activateKey('customKey_prevWorkspace',        'ctrl shift', 'K', 'ZenWorkspaces.changeWorkspaceShortcut(-1)');
activateKey('customKey_unsplitView',          'alt',        'U', 'gZenViewSplitter.toggleShortcut("unsplit")');
activateKey('customKey_hsepView',             'alt',        'S', 'gZenViewSplitter.toggleShortcut("hsep")');
activateKey('customKey_vsepView',             'alt',        'V', 'gZenViewSplitter.toggleShortcut("vsep")');
activateKey('customKey_gridView',             'alt',        'G', 'gZenViewSplitter.toggleShortcut("grid")');
activateKey('customKey_tabNew',               'ctrl',       'T', 'cmd_newNavigatorTabNoEvent');
activateKey('customKey_tabClose',             'shift ctrl', 'C', 'cmd_close');
activateKey('customKey_restoreLastClosedTab', 'shift ctrl', 'U', 'History:RestoreLastClosedTabOrWindowOrSession');
activateKey('customKey_goBack2',              'ctrl',       'H', 'Browser:Back');
activateKey('customKey_goForward2',           'ctrl',       'L', 'Browser:Forward');
activateKey('customKey_goBack',               'alt',        'H', 'Browser:Back');
activateKey('customKey_goForward',            'alt',        'L', 'Browser:Forward');
activateKey('customKey_reload',               'alt',        'R', 'Browser:Reload');
activateKey('customKey_reloadSkipCache',      'alt shift',  'R', 'Browser:ReloadSkipCache');
activateKey('customKey_privatebrowsing',      'alt ctrl',   'P', 'Tools:PrivateBrowsing');
activateKey('customKey_showAllHistory',       'alt shift',  'H', 'Browser:ShowAllHistory');
activateKey('customKey_focusSearch',          'alt',        'VK_SLASH', 'focus-search');
activateKey('customKey_findAgain',            'alt',        'N', 'cmd_findAgain');
activateKey('customKey_findPrevious',         'alt shift',  'N', 'cmd_findPrevious');
activateKey('customKey_savePage',             'alt ctrl',   'S', 'Browser:SavePage');
activateKey('customKey_print',                'alt',        'P', 'cmd_print');
activateKey('customKey_openDownloads',        'alt',        'D', 'Tools:Downloads');
activateKey('customKey_openAddons',           'alt',        'A', 'Tools:Addons');
activateKey('customKey_openFile',             'alt',        'O', 'Browser:OpenFile');
activateKey('customKey_stopLoading',          'ctrl',       'S', 'Browser:Stop');
activateKey('customKey_viewGenaiChatSidebar', 'alt ctrl',   'A', 'Browser:Stop');
activateKey('customKey_pinnedTabReset',       'alt ctrl',   'C', 'gZenPinnedTabManager.resetPinnedTab(gBrowser.selectedTab)');
activateKey('customKey_copyUrlMarkdown',      'alt ctrl',   'Y', 'gZenCommonActions.copyCurrentURLAsMarkdownToClipBoard()');
activateKey('customKey_copyUrl',              'alt',        'Y', 'gZenCommonActions.copyCurrentURLToClipBoard()');
activateKey('customKey_toggleSidebarWidth',   'alt',        'B', 'gZenVerticalTabsManager.toggleExpand()');

// Maybe if we hijack the #id, this will work? There is no command...
activateKey('customkey_toggleResponsiveDesignMode',   'shift ctrl',        'R', 'gZenVerticalTabsManager.toggleExpand()');

activateKey('customKey_toggleMute',           'ctrl',       'M', 'cmd_toggleMute');
//activateKey('customKey_zoomOut',              'ctrl',       'VK_MINUS', 'cmd_fullZoomReduce');
//activateKey('customKey_zoomIn',               'ctrl',       'VK_PLUS', 'cmd_fullZoomEnlarge');
//activateKey('customKey_zoomReset',            'ctrl',       'VK_EQUALS', 'cmd_fullZoomReset');
activateKey('customKey_zoomResetAlt',         'ctrl',       '0', 'cmd_fullZoomReset');
activateKey('customKey_selectTab8', 'alt', '8', 'zen-key-select-tab-8')
activateKey('customKey_selectTab7', 'alt', '7', 'zen-key-select-tab-7')
activateKey('customKey_selectTab6', 'alt', '6', 'zen-key-select-tab-6')
activateKey('customKey_selectTab5', 'alt', '5', 'zen-key-select-tab-5')
activateKey('customKey_selectTab4', 'alt', '4', 'zen-key-select-tab-4')
activateKey('customKey_selectTab3', 'alt', '3', 'zen-key-select-tab-3')
activateKey('customKey_selectTab2', 'alt', '2', 'zen-key-select-tab-2')
activateKey('customKey_selectTab1', 'alt', '1', 'zen-key-select-tab-1')


function remove_keys(document, window) {
    UC_API.Windows.waitWindowLoading(window).then(win => {
        // The window under `win.document.title' has finished loading
        key_ids = [
            "key_search", // <C-k>
            "key_search2" // <C-j>
        ]
        key_ids.forEach(key_id => {
            the_key = win.document.querySelector("key#" + key_id);
            the_key.remove();
        })
    })
}

UC_API.Windows.forEach(remove_keys, false)
