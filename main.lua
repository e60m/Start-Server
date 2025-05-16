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
            Wait(1000)
        end

        print("\nAll commands have been executed.")
    end
end)
