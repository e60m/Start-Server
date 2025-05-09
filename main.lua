local commands = {
    "ensure spawnmanager",
    "ensure hardcap",
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
