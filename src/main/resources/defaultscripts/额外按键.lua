function run_clear_worlds()
    if not jingle.isInstanceActive() then
        return
    end
    jingle.clearWorlds(false)
end

last_enter_world = 0

function save_enter_world_time()
    last_enter_world = jingle.getCurrentTime()
end

function get_reset_key()
    return jingle.getInstanceKeyOption("key_Create New World") or
        jingle.getInstanceKeyOption("key_Create New World§r")
end

function can_run_reset()
    if not jingle.isInstanceActive() then
        return false
    end

    state = jingle.getInstanceState()

    if state == 'INWORLD' then
        state = jingle.getInstanceInWorldState()
        if state == 'UNPAUSED' then
            return jingle.getCustomizable('iwu', 'true') == 'true'
        end
        if state == 'PAUSED' then
            return jingle.getCustomizable('iwp', 'true') == 'true'
        end
        if state == 'GAMESCREENOPEN' then
            return jingle.getCustomizable('iwgso', 'false') == 'true'
        end
    end

    if state == 'TITLE' then
        return jingle.getCustomizable('t', 'false') == 'true'
    end

    if state == 'PREVIEWING' then
        return jingle.getCustomizable('p', 'false') == 'true'
    end

    return false
end

function run_safe_reset()
    if can_run_reset() then
        local key = get_reset_key()
        if key == nil then
            jingle.log("Can't run Safe Reset! A create new world key is not set.")
            return
        end
        jingle.sendKeyToInstance(key)
    end
end

function run_reset_before_20s()
    if not can_run_reset() then
        return
    end
    if math.abs(jingle.getCurrentTime() - last_enter_world) > 20000 then
        return
    end
    local key = get_reset_key()
    if key == nil then
        jingle.log("Can't run Reset Before 20s! A create new world key is not set.")
        return
    end
    jingle.sendKeyToInstance(key)
end

function run_start_coping()
    if (not jingle.isInstanceActive()) or (jingle.getInstanceState() ~= "INWORLD") or (jingle.getInstanceInWorldState() ~= "UNPAUSED") then
        return
    end
    jingle.openToLan(false, true)
    jingle.sendChatMessage("/gamemode spectator")
end

function run_minimize()
    if (jingle.isInstanceActive()) then
        jingle.minimizeInstance()
    end
end

function customize()
    jingle.addCustomizationMenuText("允许“安全重置”和“20秒内重置”按键的游戏场景：")  --汉化
    jingle.addCustomizationMenuCheckBox("iwu", true, "存档中未暂停游戏")  --汉化
    jingle.addCustomizationMenuCheckBox("iwp", true, "存档中暂停游戏")  --汉化
    jingle.addCustomizationMenuCheckBox("iwgso", false, "存档中打开背包/聊天栏")  --汉化
    jingle.addCustomizationMenuCheckBox("t", false, "标题界面")  --汉化
    jingle.addCustomizationMenuCheckBox("p", false, "预览世界")  --汉化
    jingle.showCustomizationMenu()
end

jingle.addHotkey("清理存档", run_clear_worlds)  --汉化
jingle.listen("ENTER_WORLD", save_enter_world_time)
jingle.addHotkey("安全重置", run_safe_reset)  --汉化
jingle.addHotkey("20秒内重置", run_reset_before_20s)  --汉化
jingle.addHotkey("开启旁观", run_start_coping)  --汉化
jingle.addHotkey("最小化实例", run_minimize)  --汉化
jingle.setCustomization(customize)
