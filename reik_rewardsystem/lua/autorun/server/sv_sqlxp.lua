-- Networked Strings
util.AddNetworkString("Reiks.NewRewardsystemdata")
util.AddNetworkString("Reiks.NewLeveldata")
util.AddNetworkString("Reiks.Leveltoplayer")
util.AddNetworkString("Reiks.Skillpoints")
util.AddNetworkString("Reiks.Pointsabfrage")
util.AddNetworkString("Reiks.Newquerydata")
util.AddNetworkString("Reiks.Skillsystemhp")
util.AddNetworkString("Reiks.HPNotify")
util.AddNetworkString("Reik.Plyerabfragehealth")
util.AddNetworkString("Reiks.Healthpointshilfe")
util.AddNetworkString("Reiks.Skillsystembewegung")
util.AddNetworkString("Reiks.Newquerydatahpundbew")
util.AddNetworkString("Reik.Skillpointshelpmepls")

-- First Join abfrage

hook.Add("PlayerInitialSpawn", "Datenzuspielerrewardsystem", function(ply)
    local Steamidreward = tostring(ply:SteamID64())
    local result = sql.Query("SELECT steamid FROM Skill_system WHERE steamid = " .. sql.SQLStr(Steamidreward))
    if not result or not result[1] then
        sql.Query("INSERT INTO Skill_system (steamid, exp) VALUES (" .. sql.SQLStr(Steamidreward) .. ", 1)")
        sql.Query("INSERT INTO Skill_systemlevel (steamid, level) VALUES (" .. sql.SQLStr(Steamidreward) .. ", 0)")
        sql.Query("INSERT INTO Skill_systemskill (steamid, skillpoints, healthpoints, bewegungsgeschwindigkeit) VALUES (" .. sql.SQLStr(Steamidreward) .. ", 0, 1, 1)")
    end
end)


-- Server start sql erstellung
hook.Add("Initialize", "SQLReik", function (ply)
    --sql.Query("DROP TABLE Skill_system")
    --sql.Query("DROP TABLE Skill_systemlevel")
    --sql.Query("DROP TABLE Skill_systemskill")
    if not sql.Query("SELECT * FROM Skill_system") then
        sql.Query("CREATE TABLE Skill_system (steamid TEXT, exp INT)")
        sql.Query("CREATE TABLE Skill_systemlevel (steamid TEXT, level INT)")
        sql.Query("CREATE TABLE Skill_systemskill (steamid TEXT, skillpoints INT, healthpoints INT, bewegungsgeschwindigkeit INT)")
    end
    timer.Create("Reiks skillpoint vergebne", 3600, 0, xpandmoneygiver)
end)

local function xpandmoneygiver()
    for k, ply in ipairs(player.GetAll()) do
        local steamid = ply:SteamID64()
        
    end
end

-- Alles was mit Level update und XP zutun hat
net.Receive("Reiks.NewLeveldata", function (len, ply)
    local lplyer = ply
    local lplyersteam = lplyer:SteamID64()

    local oldxpquerry = sql.Query("SELECT exp FROM Skill_system WHERE steamid = " .. sql.SQLStr(lplyersteam))
    local oldlevelquerry = sql.Query("SELECT level FROM Skill_systemlevel WHERE steamid = " .. sql.SQLStr(lplyersteam))
    local oldskillquerry = sql.Query("SELECT skillpoints FROM Skill_systemskill WHERE steamid = " .. sql.SQLStr(lplyersteam))

    if oldxpquerry and oldlevelquerry then
        local oldxp = tonumber(oldxpquerry[1].exp)
        local level = tonumber(oldlevelquerry[1].level)
        local newxp = oldxp + 100

        sql.Query("UPDATE Skill_system SET exp = " .. newxp .. " WHERE steamid = " .. sql.SQLStr(lplyersteam))

        local playerLevelUpdated = false

        for benötigtexp, levelalt in pairs(Reik.Rewardsystemlevel) do
            if newxp >= tonumber(benötigtexp) and level < levelalt then
                playerLevel = levelalt
                sql.Query("UPDATE Skill_systemlevel SET level = " .. playerLevel .. " WHERE steamid = " .. sql.SQLStr(lplyersteam))
                playerLevelUpdated = true
                break
            end
        end

        if playerLevelUpdated then
            local plyskillpoints = tonumber(oldskillquerry[1].skillpoints)
            net.Start("Reiks.Leveltoplayer")
             net.WriteString(playerLevel)
            net.Send(lplyer)
            local reward = Reik.Rewardsystemlevelbelohnung[tostring(playerLevel)]
            if reward then 
                local plyskillpointsneu = plyskillpoints + Reik.Rewardsystemlevelbelohnung[tostring(playerLevel)]
                sql.Query("UPDATE Skill_systemskill SET skillpoints = " .. plyskillpointsneu .. " WHERE steamid = " .. sql.SQLStr(lplyersteam))
                net.Start("Reiks.Skillpoints")
                 net.WriteUInt(plyskillpointsneu, 6)
                net.Send(lplyer)
            end
        end
    end
end)



net.Receive("Reiks.Pointsabfrage", function (len, ply)
    local plyer = ply
    local plyersteamid = plyer:SteamID64()

    local oldhealquerry = sql.Query("SELECT healthpoints FROM Skill_systemskill WHERE steamid = " .. sql.SQLStr(plyersteamid))
    local oldbewegungsquerry = sql.Query("SELECT bewegungsgeschwindigkeit FROM Skill_systemskill WHERE steamid = " .. sql.SQLStr(plyersteamid))
    local skillquerry = sql.Query("SELECT skillpoints FROM Skill_systemskill WHERE steamid = " .. sql.SQLStr(plyersteamid))


    local hppoint = tonumber(oldhealquerry[1].healthpoints)
    local bewegung = tonumber(oldbewegungsquerry[1].bewegungsgeschwindigkeit)
    local skillpointss = tonumber(skillquerry[1].skillpoints)

    net.Start("Reiks.Newquerydata")
     net.WriteUInt(hppoint, 4)
     net.WriteUInt(bewegung, 4)
     net.WriteUInt(skillpointss, 6)
    net.Send(plyer)
end)

net.Receive("Reiks.Skillsystemhp", function (len, ply)
    local plyer = ply
    local plyersteamid = plyer:SteamID64()

    local skillquerry = sql.Query("SELECT skillpoints FROM Skill_systemskill WHERE steamid = " .. sql.SQLStr(plyersteamid))
    local hpquerry = sql.Query("SELECT healthpoints FROM Skill_systemskill WHERE steamid = " .. sql.SQLStr(plyersteamid))
    local bewegungquerry = sql.Query("SELECT bewegungsgeschwindigkeit FROM Skill_systemskill WHERE steamid = " .. sql.SQLStr(plyersteamid))
    local skillpointss = tonumber(skillquerry[1].skillpoints)
    local hppointss = tonumber(hpquerry[1].healthpoints)
    local bewegungsointss = tonumber(bewegungquerry[1].bewegungsgeschwindigkeit)

    local Healthpointsneu = hppointss + 1
    local test = tostring(Healthpointsneu)
    if test > "6" then 
        net.Start("Reiks.HPNotify")
        net.Send(plyer)
    elseif skillpointss > 0 then
        local skillpointsneu = skillpointss - 1
        sql.Query("UPDATE Skill_systemskill SET skillpoints = " .. skillpointsneu .. " WHERE steamid = " .. sql.SQLStr(plyersteamid))
        sql.Query("UPDATE Skill_systemskill SET healthpoints = " .. Healthpointsneu .. " WHERE steamid = " .. sql.SQLStr(plyersteamid))
        net.Start("Reiks.Newquerydatahpundbew")
            net.WriteUInt(Healthpointsneu, 4)
            net.WriteUInt(bewegungsointss, 4)
            net.WriteUInt(skillpointsneu, 6)
        net.Send(plyer)
    end
end)


hook.Add("PlayerSpawn", "AdjustPlayerHealth", function(ply, transition)
    timer.Simple(0.1, function ()
        if IsValid(ply) then
            Reikstestpartyysdda(ply, transition)
            net.Start("Reik.Skillpointshelpmepls")
            net.Send(ply)
        end
    end)
end)

net.Receive("Reik.Plyerabfragehealth", function (len, ply)
    local plyersteamid = ply:SteamID64()
    local hpquerry = sql.Query("SELECT healthpoints FROM Skill_systemskill WHERE steamid = " .. sql.SQLStr(plyersteamid))
    local bewegquerry = sql.Query("SELECT bewegungsgeschwindigkeit FROM Skill_systemskill WHERE steamid = " .. sql.SQLStr(plyersteamid))
    local bewegungspointss = tonumber(bewegquerry[1].bewegungsgeschwindigkeit)
    local hppointss = tonumber(hpquerry[1].healthpoints)
    local hpmax = ply:GetMaxHealth()
    local runspeedmax = ply:GetRunSpeed()

    if hppointss == 2 then
        local hpmaxx = hpmax * (5 / 100)
        local hpmeun = hpmax + hpmaxx
        ply:SetMaxHealth(hpmeun)
        ply:SetHealth(hpmeun)
    elseif hppointss == 3 then
        local hpmaxx = hpmax * (10 / 100)
        local hpmeun = hpmax + hpmaxx
        ply:SetMaxHealth(hpmeun)
        ply:SetHealth(hpmeun)
    elseif hppointss == 4 then
        local hpmaxx = hpmax * (15 / 100)
        local hpmeun = hpmax + hpmaxx
        ply:SetMaxHealth(hpmeun)
        ply:SetHealth(hpmeun)
    elseif hppointss == 5 then
        local hpmaxx = hpmax * (20 / 100)
        local hpmeun = hpmax + hpmaxx
        ply:SetMaxHealth(hpmeun)
        ply:SetHealth(hpmeun)
    elseif hppointss == 6 then
        local hpmaxx = hpmax * (25 / 100)
        local hpmeun = hpmax + hpmaxx
        ply:SetMaxHealth(hpmeun)
        ply:SetHealth(hpmeun)
    end
    
    if bewegungspointss == 2 then
        local runmaxx = runspeedmax * (5 / 100)
        local runmeun = runspeedmax + runmaxx
        ply:SetRunSpeed(runmeun)
    elseif bewegungspointss == 3 then
        local runmaxx = runspeedmax * (5 / 100)
        local runmeun = runspeedmax + runmaxx
        ply:SetRunSpeed(runmeun)
    elseif bewegungspointss == 4 then
        local runmaxx = runspeedmax * (5 / 100)
        local runmeun = runspeedmax + runmaxx
        ply:SetRunSpeed(runmeun)
    elseif bewegungspointss == 5 then
        local runmaxx = runspeedmax * (5 / 100)
        local runmeun = runspeedmax + runmaxx
        ply:SetRunSpeed(runmeun)
    elseif bewegungspointss == 6 then
        local runmaxx = runspeedmax * (5 / 100)
        local runmeun = runspeedmax + runmaxx
        ply:SetRunSpeed(runmeun)
    end
end)


function Reikstestpartyysdda(ply, transition)
    local gamer = ply
    local plyersteamid = ply:SteamID64()
    local hpquerry = sql.Query("SELECT healthpoints FROM Skill_systemskill WHERE steamid = " .. sql.SQLStr(plyersteamid))
    local hppointss = tonumber(hpquerry[1].healthpoints)
    local bewegungsquerry = sql.Query("SELECT bewegungsgeschwindigkeit FROM Skill_systemskill WHERE steamid = " .. sql.SQLStr(plyersteamid))
    local bewegungspointss = tonumber(bewegungsquerry[1].bewegungsgeschwindigkeit)
    net.Start("Reiks.Healthpointshilfe")
     net.WriteUInt(hppointss, 6)
     net.WriteUInt(bewegungspointss, 6)
    net.Send(gamer)
end

net.Receive("Reiks.Skillsystembewegung", function (len, ply)
    local plyer = ply
    local plyersteamid = plyer:SteamID64()

    local skillquerry = sql.Query("SELECT skillpoints FROM Skill_systemskill WHERE steamid = " .. sql.SQLStr(plyersteamid))
    local bewegquerry = sql.Query("SELECT bewegungsgeschwindigkeit FROM Skill_systemskill WHERE steamid = " .. sql.SQLStr(plyersteamid))
    local hpquerry = sql.Query("SELECT healthpoints FROM Skill_systemskill WHERE steamid = " .. sql.SQLStr(plyersteamid))
    local hppoints = tonumber(hpquerry[1].healthpoints)
    local skillpointss = tonumber(skillquerry[1].skillpoints)
    local bewointss = tonumber(bewegquerry[1].bewegungsgeschwindigkeit)

    local Bewpointsneu = bewointss + 1
    local test = tostring(Bewpointsneu)
    if test > "6" then 
        net.Start("Reiks.HPNotify")
        net.Send(plyer)
    elseif skillpointss > 0 then
        local skillpointsneu = skillpointss - 1
        sql.Query("UPDATE Skill_systemskill SET skillpoints = " .. skillpointsneu .. " WHERE steamid = " .. sql.SQLStr(plyersteamid))
        sql.Query("UPDATE Skill_systemskill SET bewegungsgeschwindigkeit = " .. Bewpointsneu .. " WHERE steamid = " .. sql.SQLStr(plyersteamid))
        net.Start("Reiks.Newquerydatahpundbew")
        net.WriteUInt(hppoints, 4)
        net.WriteUInt(Bewpointsneu, 4)
        net.WriteUInt(skillpointsneu, 6)
    net.Send(plyer)
    end
end)