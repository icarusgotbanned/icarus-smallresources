
Citizen.CreateThread(function()
    while true do
       if IsFirstPersonAimCamActive() then
       DisplaySniperScopeThisFrame()
        end
    Citizen.Wait(0)
    end
end)