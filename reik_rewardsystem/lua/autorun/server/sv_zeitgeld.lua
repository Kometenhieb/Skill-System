util.AddNetworkString("Reik.GiveCreditsperhoure")


-- Geldgeber    
net.Receive("Reik.GiveCreditsperhoure", function (len, ply)

    ply:addMoney(50)
end)