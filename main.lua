local commands = {
    "ensure spawnmanager",
    "ensure hardcap",
    "ensure bob74_ipl",
    "ensure an_progBar",
    "ensure wm-serversirens",
    "start [sounds]",
    "start [effects]",
    "start [Notify]",
    "start [Chat]",
    "start [Cars]",
    "start [CarScripts]",
    "ensure [core]",
    "start [TargetBT]",
    "start [Framework]",
    "start [RageMenus]",
    "ensure [standalone]",
    "ensure [esx_addons]",
    "start [EUP]",
    "start [screenshots]",
    "start [TalkToNpc]",
    "start [CreateCaracther]",
    "start [HUDS]",
    "start [GUNS]",
    "start [INV]",
    "start [Houseing]",
    "start [Overhualmap]",
    "start [Skills]",
    "start [discord]",
    "start [CharctersAnims]",
    "start [ServerBuyed]",
    "start [LSPD]",
    "start [Bank]",
    "ensure screenshot-basic",
    "start [Phone]",
    "start [towingmissions]",
    "ensure AfKAPI",
    "ensure thug-nametags-v2",
    "ensure dailygift",
    "ensure Ayham",
    "ensure [Voice]",
    "ensure runcode",
    "ensure chat",
    "ensure [API]",
    "ensure [CarScripts]",
    "ensure [CharctersAnims]",
    "ensure [CreateCaracther]",
    "ensure [CreateCaracther]",
    "ensure [towingmissions]",
    "ensure [New24.12.2024]",
    "ensure [New5.2.25]",
    "ensure [admin]"
}

AddEventHandler('onResourceStart', function(resource)
    if resource == GetCurrentResourceName() then
        print("\n===================================")
        print("   VorteX RP Server Auto Starter")
        print("   Executing start/ensure commands...")
        print("===================================\n")

        for _, cmd in ipairs(commands) do
            Wait(6000)
            print(_)
            ExecuteCommand(cmd)
            print("[Executed] " .. cmd)
            if _ == 10 then
                Wait(40000)
            elseif _ == 19 then
                Wait(40000)
                elseif _ == 24 then
                Wait(40000)
            elseif _ == 27 then
                Wait(40000)
            end
        end

        print("\nAll commands have been executed.")
    end
end)
