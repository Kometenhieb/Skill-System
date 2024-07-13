perkmenuopen = false
timerstartet = false

hook.Add("PlayerButtonDown", "ButtonPDownHook", function(ply, button)
    if button == KEY_P and perkmenuopen == false then
        perkmenuopen = true
        Perkmenu()
    end
end)

local function DoSomethingEveryHour()
    net.Start("Reiks.NewLeveldata")
    net.SendToServer()
end

local function ScheduleHourlyTask()
    if timerstartet == false then 
        Reikstimerimposible()
    end
end

function Reikstimerimposible()
    local delay = 3600
    timer.Create("HourlyTaskTimer", delay, 0, DoSomethingEveryHour)
    timerstartet = true
end
-------------------- Level Bereich

net.Receive("Reiks.Leveltoplayer", function ()
    local level = net.ReadString()
    VoidLib.Notify("LEVELUP!", "Du bist nun Level " .. level, Color(17, 255, 0), 5)
    surface.PlaySound("vfs/rewardsystemlevelup.wav")
end)



-- Zeit zu credits

local function Makingsomonehappywithcredits()
    local delayforcredits = 1800
    timer.Create("Reikstimerspaß", delayforcredits, 0, creditsfornoel)
end

net.Receive("Reik.Skillpointshelpmepls",function ()
    ScheduleHourlyTask()
end)

Skillpoints = 0

net.Receive("Reiks.Skillpoints", function ()
    local Skillpointss = net.ReadUInt(6)
    Skillpoints = Skillpointss
end)

local fontsize = {
    51,
    41,
    27,
    30,
}

for i = 1, #fontsize do
    local size = fontsize[i]
    surface.CreateFont( "VFSFont_" .. size, {
        font = "BF4 Numbers",
        extended = false,
        size = size,
        weight = 500,
    } )
end

healtpoints = 1
Bewegungspoints = 1

net.Receive("Reiks.Newquerydata", function ()
    healtpoints = net.ReadUInt(4)
    Bewegungspoints = net.ReadUInt(4)
    Skillpoints = net.ReadUInt(6)
end)

net.Receive("Reiks.Newquerydatahpundbew", function ()
    healtpoints = net.ReadUInt(4)
    Bewegungspoints = net.ReadUInt(4)
    Skillpoints = net.ReadUInt(6)
    perkmenuhauptframe:Close()
    Perkmenu()
end)

function Reikhelhtpointsabfrage()
    net.Start("Reik.Plyerabfragehealth")
    net.SendToServer()
end

net.Receive("Reiks.Healthpointshilfe", function ()
    healtpoints = net.ReadUInt(6)
    Bewegungspoints = net.ReadUInt(6)
    LocalPlayer():SetHealth(105)
    LocalPlayer():SetRunSpeed(240)
    Reikhelhtpointsabfrage()
end)

local ply = LocalPlayer()
function Perkmenu()
    net.Start("Reiks.Pointsabfrage")
    net.SendToServer()

    perkmenuhauptframe = vgui.Create("DFrame")
    perkmenuhauptframe:SetSize(1920, 1080)
    perkmenuhauptframe:Center()
    perkmenuhauptframe:SetTitle(" ")
    perkmenuhauptframe:MakePopup()
    perkmenuhauptframe:SetDraggable(false)
    perkmenuhauptframe:ShowCloseButton(false)
    perkmenuhauptframe.Paint = function ()
        draw.RoundedBox(5, 195, 225, 510, 710, Color(117, 115, 115))
        draw.RoundedBox(5, 200, 230, 500, 700, Color(22, 22, 22))
        draw.RoundedBox(5, 1195, 225, 510, 710, Color(117, 115, 115))
        draw.RoundedBox(5, 1200, 230, 500, 700, Color(22, 22, 22))
        draw.RoundedBox(5, 655, 105, 600, 80, Color(117, 115, 115))
        draw.RoundedBox(5, 660, 110, 590, 70, Color(22, 22, 22))
        draw.SimpleText("Skillpoints " .. Skillpoints, "VFSFont_51", 810, 115, color_whitem, TEXT_ALIGN_LEFT, TEXT_ALIGN_LEFT)
        if healtpoints >= 1 or healtpoints == 1 then 
            draw.SimpleText("Deine HP werden um 5% erhöht", "VFSFont_30",310, 267, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_LEFT)
        end
        if healtpoints >= 2 or healtpoints == 2 then 
            draw.SimpleText("Deine HP werden um 10% erhöht", "VFSFont_30",310, 367, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_LEFT)
        end
        if healtpoints >= 3 or healtpoints == 3 then 
            draw.SimpleText("Deine HP werden um 15% erhöht", "VFSFont_30",310, 467, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_LEFT)
        end
        if healtpoints >= 4 or healtpoints == 4 then 
            draw.SimpleText("Deine HP werden um 20% erhöht", "VFSFont_30",310, 567, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_LEFT)
        end
        if healtpoints >= 5 or healtpoints == 5 then 
            draw.SimpleText("Deine HP werden um 25% erhöht", "VFSFont_30",310, 667, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_LEFT)
        end
        if Bewegungspoints >= 1 or Bewegungspoints == 1 then 
            draw.SimpleText("Dein Speed wird um 5% erhöht", "VFSFont_30",1310, 267, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_LEFT)
        end
        if Bewegungspoints >= 2 or Bewegungspoints == 2 then 
            draw.SimpleText("Dein Speed wird um 10% erhöht", "VFSFont_30",1310, 367, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_LEFT)
        end
        if Bewegungspoints >= 3 or Bewegungspoints == 3 then 
            draw.SimpleText("Dein Speed wird um 15% erhöht", "VFSFont_30",1310, 467, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_LEFT)
        end
        if Bewegungspoints >= 4 or Bewegungspoints == 4 then 
            draw.SimpleText("Dein Speed wird um 20% erhöht", "VFSFont_30",1310, 567, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_LEFT)
        end
        if Bewegungspoints >= 5 or Bewegungspoints == 5 then 
            draw.SimpleText("Dein Speed wird um 25% erhöht", "VFSFont_30",1310, 667, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_LEFT)
        end
    end

    local PerkCloseImageButton = perkmenuhauptframe:Add("DImageButton")
    PerkCloseImageButton:SetPos( 1280, 110 )
    PerkCloseImageButton:SetSize( 70, 70 )
    PerkCloseImageButton:SetImage("materials/closesymbol.png")
    PerkCloseImageButton.DoClick = function()
        perkmenuhauptframe:Close()
        perkmenuopen = false
        perkmenuclosednot = true
    end

    if healtpoints >= 1 or healtpoints == 1 then
        local PerkHealth1ImageButton = perkmenuhauptframe:Add("DImageButton")
        PerkHealth1ImageButton:SetPos( 210, 240 )
        PerkHealth1ImageButton:SetSize( 90, 90 )
        if healtpoints >= 2 or healtpoints == 2 then
            PerkHealth1ImageButton:SetImage("materials/healthsymbol.png")
        else
            PerkHealth1ImageButton:SetImage("materials/fragezeichenkeineahnung.png")
        end        
        PerkHealth1ImageButton.DoClick = function()
            net.Start("Reiks.Skillsystemhp")
            net.SendToServer()
            perkmenuhauptframe:Close()
            Perkmenu()
        end
    end

    if healtpoints >= 2 or healtpoints == 2 then
        local PerkHealth2ImageButton = perkmenuhauptframe:Add("DImageButton")
        PerkHealth2ImageButton:SetPos( 210, 340 )
        PerkHealth2ImageButton:SetSize( 90, 90 )
        if healtpoints >= 3 or healtpoints == 3 then
            PerkHealth2ImageButton:SetImage("materials/healthsymbol.png")
        else
            PerkHealth2ImageButton:SetImage("materials/fragezeichenkeineahnung.png")
        end
        PerkHealth2ImageButton.DoClick = function()
            net.Start("Reiks.Skillsystemhp")
            net.SendToServer()
            perkmenuhauptframe:Close()
            Perkmenu()
        end
    end

    
    if healtpoints >= 3 or healtpoints == 3 then
        local PerkHealth3ImageButton = perkmenuhauptframe:Add("DImageButton")
        PerkHealth3ImageButton:SetPos( 210, 440 )
        PerkHealth3ImageButton:SetSize( 90, 90 )
        if healtpoints >= 4 or healtpoints == 4 then
            PerkHealth3ImageButton:SetImage("materials/healthsymbol.png")
        else
            PerkHealth3ImageButton:SetImage("materials/fragezeichenkeineahnung.png")
        end
        PerkHealth3ImageButton.DoClick = function()
            net.Start("Reiks.Skillsystemhp")
            net.SendToServer()
            perkmenuhauptframe:Close()
            Perkmenu()
        end
    end



    
    if healtpoints >= 4 or healtpoints == 4 then
        local PerkHealth4ImageButton = perkmenuhauptframe:Add("DImageButton")
        PerkHealth4ImageButton:SetPos( 210, 540 )
        PerkHealth4ImageButton:SetSize( 90, 90 )
        if healtpoints >= 5 or healtpoints == 5 then
            PerkHealth4ImageButton:SetImage("materials/healthsymbol.png")
        else
            PerkHealth4ImageButton:SetImage("materials/fragezeichenkeineahnung.png")
        end
        PerkHealth4ImageButton.DoClick = function()
            net.Start("Reiks.Skillsystemhp")
            net.SendToServer()
            perkmenuhauptframe:Close()
            Perkmenu()
        end
    end


    
    if healtpoints >= 5 or healtpoints == 5 then
        local PerkHealth5ImageButton = perkmenuhauptframe:Add("DImageButton")
        PerkHealth5ImageButton:SetPos( 210, 640 )
        PerkHealth5ImageButton:SetSize( 90, 90 )
        if healtpoints >= 6 or healtpoints == 6 then
            PerkHealth5ImageButton:SetImage("materials/healthsymbol.png")
        else
            PerkHealth5ImageButton:SetImage("materials/fragezeichenkeineahnung.png")
        end
        PerkHealth5ImageButton.DoClick = function()
            net.Start("Reiks.Skillsystemhp")
            net.SendToServer()
            perkmenuhauptframe:Close()
            Perkmenu()
        end
    end

    -- Bewegungspoints

    if Bewegungspoints >= 1 or Bewegungspoints == 1 then
        local PerkBewegung1ImageButton = perkmenuhauptframe:Add("DImageButton")
        PerkBewegung1ImageButton:SetPos( 1210, 240 )
        PerkBewegung1ImageButton:SetSize( 90, 90 )
        PerkBewegung1ImageButton:SetColor(Color(255, 255, 255))
        if Bewegungspoints >= 2 or Bewegungspoints == 2 then
            PerkBewegung1ImageButton:SetImage("materials/speediconreward.png")
        else
            PerkBewegung1ImageButton:SetImage("materials/fragezeichenkeineahnung.png")
        end
        PerkBewegung1ImageButton.DoClick = function()
            net.Start("Reiks.Skillsystembewegung")
            net.SendToServer()
            perkmenuhauptframe:Close()
            Perkmenu()
        end
    end


    if Bewegungspoints >= 2 or Bewegungspoints == 2 then
        local PerkBewegung2ImageButton = perkmenuhauptframe:Add("DImageButton")
        PerkBewegung2ImageButton:SetPos( 1210, 340 )
        PerkBewegung2ImageButton:SetSize( 90, 90 )
        PerkBewegung2ImageButton:SetColor(Color(255, 255, 255))
        if Bewegungspoints >= 3 or Bewegungspoints == 3 then
            PerkBewegung2ImageButton:SetImage("materials/speediconreward.png")
        else
            PerkBewegung2ImageButton:SetImage("materials/fragezeichenkeineahnung.png")
        end
        PerkBewegung2ImageButton.DoClick = function()
            net.Start("Reiks.Skillsystembewegung")
            net.SendToServer()
            perkmenuhauptframe:Close()
            Perkmenu()
        end
    end

    if Bewegungspoints >= 3 or Bewegungspoints == 3 then
        local PerkBewegung3ImageButton = perkmenuhauptframe:Add("DImageButton")
        PerkBewegung3ImageButton:SetPos( 1210, 440 )
        PerkBewegung3ImageButton:SetSize( 90, 90 )
        PerkBewegung3ImageButton:SetColor(Color(255, 255, 255))
        if Bewegungspoints >= 4 or Bewegungspoints == 4 then
            PerkBewegung3ImageButton:SetImage("materials/speediconreward.png")
        else
            PerkBewegung3ImageButton:SetImage("materials/fragezeichenkeineahnung.png")
        end
        PerkBewegung3ImageButton.DoClick = function()
            net.Start("Reiks.Skillsystembewegung")
            net.SendToServer()
            perkmenuhauptframe:Close()
            Perkmenu()
        end
    end

    if Bewegungspoints >= 4 or Bewegungspoints == 4 then
        local PerkBewegung4ImageButton = perkmenuhauptframe:Add("DImageButton")
        PerkBewegung4ImageButton:SetPos( 1210, 540 )
        PerkBewegung4ImageButton:SetSize( 90, 90 )
        PerkBewegung4ImageButton:SetColor(Color(255, 255, 255))
        if Bewegungspoints >= 5 or Bewegungspoints == 5 then
            PerkBewegung4ImageButton:SetImage("materials/speediconreward.png")
        else
            PerkBewegung4ImageButton:SetImage("materials/fragezeichenkeineahnung.png")
        end
        PerkBewegung4ImageButton.DoClick = function()
            net.Start("Reiks.Skillsystembewegung")
            net.SendToServer()
            perkmenuhauptframe:Close()
            Perkmenu()
        end
    end

    if Bewegungspoints >= 5 or Bewegungspoints == 5 then
        local PerkBewegung5ImageButton = perkmenuhauptframe:Add("DImageButton")
        PerkBewegung5ImageButton:SetPos( 1210, 640 )
        PerkBewegung5ImageButton:SetSize( 90, 90 )
        PerkBewegung5ImageButton:SetColor(Color(255, 255, 255))
        if Bewegungspoints >= 6 or Bewegungspoints == 6 then
            PerkBewegung5ImageButton:SetImage("materials/speediconreward.png")
        else
            PerkBewegung5ImageButton:SetImage("materials/fragezeichenkeineahnung.png")
        end
        PerkBewegung5ImageButton.DoClick = function()
            net.Start("Reiks.Skillsystembewegung")
            net.SendToServer()
            perkmenuhauptframe:Close()
            Perkmenu()
        end
    end
end




net.Receive("Reiks.HPNotify", function ()
    VoidLib.Notify("ERROR", "Du dich bereits in diesen Skill ausgeskillt!", Color(170, 66, 66), 5)
end)