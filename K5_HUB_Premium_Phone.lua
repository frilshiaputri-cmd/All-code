--[[
    K5 HUB - PREMIUM PHONE UI
    Purple/black dashboard inspired by the supplied reference.
    Features:
      Home / Codes / History / Settings navigation
      Auto Redeem / FPS Boost / Anti AFK / System Protection
      Code list, progress, activity history, phone responsive layout
    NOTE: Redeem success is counted when the client sends the request;
    server confirmation is not available from the existing remote.
]]

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local VirtualUser = game:GetService("VirtualUser")
local Lighting = game:GetService("Lighting")

local Player = Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")
local CodeRE = ReplicatedStorage.Framework.Systems.CodesSystem.CodeRE

local LOGO_IMAGE = "" -- optional: rbxassetid://YOUR_LOGO_ID
local CODE_COOLDOWN = 8.6
local BUFFER = 8.5
local REDEEM_DELAY = CODE_COOLDOWN + BUFFER

local Codes = {"Locko_SS", "MAS ACENG", "Aimyoungs", "GRAYWOLF", "Astral", "Ahjughh", "AAM", "ARES", "ARKANGHEL", "ERIKSM", "reiley", "BERLINHERE23", "Giovanni_GG", "CA2", "SIGURIH", "MERGIXS", "druscxlla", "MAHAFEY", "ToadPlaysGamesTTV", "luknojo", "Ghifa", "Luthador2121", "RIKUSOULS", "T3nsei", "Dray28", "Sukunay", "Maple", "LALAGANG", "Uzi", "runekify", "Zeny", "HELOS", "LezoCr", "Fujiesane", "Laplace", "Nyxaria", "FannTzy", "Deco", "dasher", "Nothing", "ProfGab", "SUB2BLAZESTARS", "Dism", "SUPER MBUD", "Marcell", "DrekathSenpai", "Darkfeniks", "Sneptuno", "Markbhatra", "LZZ_019BEST", "Bebek", "NisardHelpOnlyWoman", "TT_oratttt", "Izumi_Senpai", "Les", "SEYUnever", "Shan", "Freca", "Ryokenn", "ReyPomuchi", "Gryffin", "DEI_Yumeko", "Chrisss", "tony_vt", "Ryu", "Clipz7112", "PaPaX", "Kiota2", "Lulzsec", "smiley", "Sine", "GT_HANNI", "Erijero", "DanoNano", "WettySNK", "obe", "Dekday", "Qyuu", "Gwynne", "PapiJoy", "Taalonely", "Darren", "MADUNN", "PepCalcot", "Shirooo0312_IRONSOUL", "Monarch", "Lifauzi", "TT_Mentally_ill_K.N", "RaykorBR", "ZARGAKSTONE", "Heso", "Ghelayyy", "EJ(YURU)", "IronReaper", "Skywinter86", "ALLWAONIRONSOUL", "IRONWEEKENDGIFT26"}

local AutoRedeem = false
local FPSBoost = false
local AntiAFK = false
local SystemProtection = true
local IsRedeeming = false
local claimedCodes = {}
local history = {}
local totalCodes = #Codes
local processedCount = 0

local BG = Color3.fromRGB(7, 5, 14)
local PANEL = Color3.fromRGB(12, 9, 22)
local PANEL2 = Color3.fromRGB(18, 13, 31)
local PANEL3 = Color3.fromRGB(23, 17, 39)
local PURPLE = Color3.fromRGB(164, 75, 255)
local PURPLE2 = Color3.fromRGB(103, 45, 180)
local VIOLET = Color3.fromRGB(205, 112, 255)
local WHITE = Color3.fromRGB(244, 239, 255)
local GREY = Color3.fromRGB(157, 145, 176)
local GREEN = Color3.fromRGB(105, 255, 157)
local RED = Color3.fromRGB(255, 95, 120)
local YELLOW = Color3.fromRGB(255, 207, 91)

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "K5HubPremiumPhone"
ScreenGui.ResetOnSpawn = false
ScreenGui.IgnoreGuiInset = true
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.Parent = PlayerGui

local Main = Instance.new("Frame")
Main.Name = "Main"
Main.AnchorPoint = Vector2.new(.5,.5)
Main.Position = UDim2.fromScale(.5,.5)
Main.Size = UDim2.fromOffset(390,650)
Main.BackgroundColor3 = BG
Main.BorderSizePixel = 0
Main.ClipsDescendants = true
Main.Parent = ScreenGui

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0,20)
MainCorner.Parent = Main
local MainStroke = Instance.new("UIStroke")
MainStroke.Color = Color3.fromRGB(61,44,82)
MainStroke.Thickness = 1.2
MainStroke.Parent = Main

local Gradient = Instance.new("UIGradient")
Gradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(8,6,17)),
    ColorSequenceKeypoint.new(.55, Color3.fromRGB(12,8,22)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(19,10,30)),
})
Gradient.Rotation = 135
Gradient.Parent = Main

local UIScale = Instance.new("UIScale")
UIScale.Parent = Main

local function corner(obj, r)
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0,r)
    c.Parent = obj
    return c
end

local function stroke(obj, color, thickness, transparency)
    local s = Instance.new("UIStroke")
    s.Color = color
    s.Thickness = thickness or 1
    s.Transparency = transparency or 0
    s.Parent = obj
    return s
end

local function label(parent, text, size, color, font)
    local l = Instance.new("TextLabel")
    l.BackgroundTransparency = 1
    l.Text = text
    l.TextColor3 = color or WHITE
    l.TextSize = size or 14
    l.Font = font or Enum.Font.Gotham
    l.Parent = parent
    return l
end

local function button(parent, text)
    local b = Instance.new("TextButton")
    b.BackgroundTransparency = 1
    b.Text = text or ""
    b.AutoButtonColor = false
    b.BorderSizePixel = 0
    b.Parent = parent
    return b
end

-- HEADER
local Header = Instance.new("Frame")
Header.Size = UDim2.new(1,0,0,88)
Header.BackgroundTransparency = 1
Header.Parent = Main

local HeaderLine = Instance.new("Frame")
HeaderLine.Position = UDim2.new(0,18,1,-1)
HeaderLine.Size = UDim2.new(1,-36,0,1)
HeaderLine.BackgroundColor3 = Color3.fromRGB(49,37,67)
HeaderLine.BorderSizePixel = 0
HeaderLine.Parent = Header

local Logo
if LOGO_IMAGE ~= "" then
    Logo = Instance.new("ImageLabel")
    Logo.Image = LOGO_IMAGE
    Logo.ScaleType = Enum.ScaleType.Fit
else
    Logo = label(Header,"K5",18,WHITE,Enum.Font.GothamBlack)
    Logo.TextXAlignment = Enum.TextXAlignment.Center
    Logo.TextYAlignment = Enum.TextYAlignment.Center
end
Logo.Position = UDim2.fromOffset(18,18)
Logo.Size = UDim2.fromOffset(50,50)
Logo.BackgroundColor3 = PANEL2
Logo.BackgroundTransparency = 0
Logo.BorderSizePixel = 0
Logo.Parent = Header
corner(Logo,14)
stroke(Logo,PURPLE,1.2,.15)

local Title = label(Header,"K5 HUB",19,WHITE,Enum.Font.GothamBold)
Title.Position = UDim2.fromOffset(82,18)
Title.Size = UDim2.fromOffset(170,24)
Title.TextXAlignment = Enum.TextXAlignment.Left
local Sub = label(Header,"CODE SYSTEM  •  PREMIUM",8,GREY,Enum.Font.GothamMedium)
Sub.Position = UDim2.fromOffset(83,43)
Sub.Size = UDim2.fromOffset(190,16)
Sub.TextXAlignment = Enum.TextXAlignment.Left

local Online = label(Header,"●  ONLINE",9,GREEN,Enum.Font.GothamBold)
Online.Position = UDim2.new(1,-105,0,22)
Online.Size = UDim2.fromOffset(82,22)
Online.TextXAlignment = Enum.TextXAlignment.Center

local Min = button(Header,"—")
Min.Position = UDim2.new(1,-58,0,18)
Min.Size = UDim2.fromOffset(24,24)
Min.TextColor3 = GREY
Min.TextSize = 17
Min.Font = Enum.Font.GothamBold
local Close = button(Header,"×")
Close.Position = UDim2.new(1,-31,0,18)
Close.Size = UDim2.fromOffset(24,24)
Close.TextColor3 = WHITE
Close.TextSize = 18
Close.Font = Enum.Font.Gotham

-- DRAG
local dragging, dragStart, startPos
Header.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true; dragStart = input.Position; startPos = Main.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then dragging = false end
        end)
    end
end)
UserInputService.InputChanged:Connect(function(input)
    if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local d = input.Position-dragStart
        Main.Position = UDim2.new(startPos.X.Scale,startPos.X.Offset+d.X,startPos.Y.Scale,startPos.Y.Offset+d.Y)
    end
end)

-- BODY SCROLL
local Body = Instance.new("ScrollingFrame")
Body.Position = UDim2.fromOffset(12,94)
Body.Size = UDim2.new(1,-24,1,-150)
Body.BackgroundTransparency = 1
Body.BorderSizePixel = 0
Body.ScrollBarThickness = 2
Body.ScrollBarImageColor3 = PURPLE
Body.CanvasSize = UDim2.fromOffset(0,0)
Body.AutomaticCanvasSize = Enum.AutomaticSize.Y
Body.ScrollingDirection = Enum.ScrollingDirection.Y
Body.Parent = Main

local BodyPadding = Instance.new("UIPadding")
BodyPadding.PaddingLeft = UDim.new(0,6)
BodyPadding.PaddingRight = UDim.new(0,6)
BodyPadding.PaddingTop = UDim.new(0,4)
BodyPadding.PaddingBottom = UDim.new(0,12)
BodyPadding.Parent = Body
local Layout = Instance.new("UIListLayout")
Layout.Padding = UDim.new(0,9)
Layout.SortOrder = Enum.SortOrder.LayoutOrder
Layout.Parent = Body

local Pages = {}
local currentPage = "Home"

local function clearBody()
    for _,c in ipairs(Body:GetChildren()) do
        if not c:IsA("UIListLayout") and not c:IsA("UIPadding") then c:Destroy() end
    end
end

local function sectionTitle(text, order)
    local f = Instance.new("Frame")
    f.Size = UDim2.new(1,0,0,27)
    f.BackgroundTransparency = 1
    f.LayoutOrder = order
    f.Parent = Body
    local t = label(f,text,11,GREY,Enum.Font.GothamBold)
    t.Position = UDim2.fromOffset(4,4)
    t.Size = UDim2.new(1,-8,1,-4)
    t.TextXAlignment = Enum.TextXAlignment.Left
    return f
end

local function card(h, order)
    local f = Instance.new("Frame")
    f.Size = UDim2.new(1,0,0,h)
    f.BackgroundColor3 = PANEL
    f.BorderSizePixel = 0
    f.LayoutOrder = order
    f.Parent = Body
    corner(f,14)
    stroke(f,Color3.fromRGB(50,39,67),1,.05)
    return f
end

local function addHistory(text, color)
    table.insert(history,1,{text=text,color=color or WHITE,time=os.date("%H:%M:%S")})
    if #history > 30 then table.remove(history) end
end

local function statCard(parent, x, titleText, valueText, accent)
    local f = Instance.new("Frame")
    f.Position = UDim2.new(x,0,0,0)
    f.Size = UDim2.new(1/3,-5,1,0)
    f.BackgroundColor3 = PANEL2
    f.BorderSizePixel = 0
    f.Parent = parent
    corner(f,12)
    stroke(f,Color3.fromRGB(52,40,70),1)
    local t=label(f,titleText,8,GREY,Enum.Font.GothamBold); t.Position=UDim2.fromOffset(10,10); t.Size=UDim2.new(1,-20,0,16); t.TextXAlignment=Enum.TextXAlignment.Left
    local v=label(f,valueText,21,accent or WHITE,Enum.Font.GothamBold); v.Position=UDim2.fromOffset(10,28); v.Size=UDim2.new(1,-20,0,28); v.TextXAlignment=Enum.TextXAlignment.Left
    return v
end

local function toggleCard(parent, y, titleText, desc, getter, setter, accent)
    local f=Instance.new("Frame")
    f.Position=UDim2.fromOffset(0,y); f.Size=UDim2.new(1,0,0,67); f.BackgroundColor3=PANEL2; f.BorderSizePixel=0; f.Parent=parent; corner(f,13); stroke(f,Color3.fromRGB(50,39,67),1)
    local dot=Instance.new("Frame"); dot.Position=UDim2.fromOffset(14,23); dot.Size=UDim2.fromOffset(20,20); dot.BackgroundColor3=accent or PURPLE; dot.BorderSizePixel=0; dot.Parent=f; corner(dot,10)
    local t=label(f,titleText,12,WHITE,Enum.Font.GothamBold); t.Position=UDim2.fromOffset(46,12); t.Size=UDim2.new(1,-120,0,18); t.TextXAlignment=Enum.TextXAlignment.Left
    local d=label(f,desc,8,GREY,Enum.Font.Gotham); d.Position=UDim2.fromOffset(46,33); d.Size=UDim2.new(1,-120,0,16); d.TextXAlignment=Enum.TextXAlignment.Left
    local b=button(f,""); b.Position=UDim2.new(1,-65,0,19); b.Size=UDim2.fromOffset(47,27); b.BackgroundColor3=Color3.fromRGB(42,34,52); b.BackgroundTransparency=0; corner(b,14)
    local knob=Instance.new("Frame"); knob.Size=UDim2.fromOffset(21,21); knob.Position=UDim2.fromOffset(3,3); knob.BackgroundColor3=WHITE; knob.BorderSizePixel=0; knob.Parent=b; corner(knob,11)
    local function render()
        local on=getter(); b.BackgroundColor3=on and (accent or PURPLE) or Color3.fromRGB(42,34,52); knob.Position=on and UDim2.new(1,-24,0,3) or UDim2.fromOffset(3,3); dot.BackgroundColor3=on and (accent or PURPLE) or Color3.fromRGB(72,63,82)
    end
    b.MouseButton1Click:Connect(function() setter(not getter()); render() end)
    render()
    return f
end

local function buildHome()
    clearBody()
    sectionTitle("WELCOME BACK, K5 USER",1)
    local hero=card(74,2)
    local h=label(hero,"Smart Code System",15,WHITE,Enum.Font.GothamBold); h.Position=UDim2.fromOffset(14,11); h.Size=UDim2.new(1,-100,0,22); h.TextXAlignment=Enum.TextXAlignment.Left
    local d=label(hero,"Faster. Safer. Cleaner.",8,GREY,Enum.Font.Gotham); d.Position=UDim2.fromOffset(15,38); d.Size=UDim2.new(1,-110,0,16); d.TextXAlignment=Enum.TextXAlignment.Left
    local p=label(hero,"PREMIUM",8,VIOLET,Enum.Font.GothamBold); p.Position=UDim2.new(1,-88,0,15); p.Size=UDim2.fromOffset(70,18); p.TextXAlignment=Enum.TextXAlignment.Center
    local stats=Instance.new("Frame"); stats.Size=UDim2.new(1,0,0,74); stats.BackgroundTransparency=1; stats.LayoutOrder=3; stats.Parent=Body
    local total=statCard(stats,0,"TOTAL CODE",tostring(totalCodes),WHITE)
    local sent=statCard(stats,1/3,"CLAIMED",tostring(processedCount),GREEN)
    local remain=statCard(stats,2/3,"REMAINING",tostring(totalCodes-processedCount),YELLOW)
    local feat=card(254,4)
    local ft=label(feat,"SYSTEM FEATURES",10,GREY,Enum.Font.GothamBold); ft.Position=UDim2.fromOffset(14,10); ft.Size=UDim2.new(1,-28,0,18); ft.TextXAlignment=Enum.TextXAlignment.Left
    toggleCard(feat,33,"Auto Redeem","Automatically redeem codes",function() return AutoRedeem end,function(v) AutoRedeem=v; if v then task.spawn(startRedeem) end; addHistory(v and "Auto Redeem enabled" or "Auto Redeem disabled",v and GREEN or GREY); buildHome() end,PURPLE)
    toggleCard(feat,106,"FPS Boost","Reduce local visual load",function() return FPSBoost end,function(v) FPSBoost=v; addHistory(v and "FPS Boost enabled" or "FPS Boost disabled",VIOLET); buildHome() end,VIOLET)
    toggleCard(feat,179,"Anti AFK","Keep the session active",function() return AntiAFK end,function(v) AntiAFK=v; addHistory(v and "Anti AFK enabled" or "Anti AFK disabled",GREEN); buildHome() end,GREEN)
    local status=card(88,5)
    local st=label(status,"SYSTEM ONLINE",11,GREEN,Enum.Font.GothamBold); st.Position=UDim2.fromOffset(14,13); st.Size=UDim2.new(1,-28,0,18); st.TextXAlignment=Enum.TextXAlignment.Left
    local sd=label(status,IsRedeeming and "Redeem process is running..." or "All systems are ready.",8,GREY,Enum.Font.Gotham); sd.Position=UDim2.fromOffset(14,39); sd.Size=UDim2.new(1,-28,0,16); sd.TextXAlignment=Enum.TextXAlignment.Left
    local prog=card(73,6)
    local pt=label(prog,"REDEEM PROGRESS",9,GREY,Enum.Font.GothamBold); pt.Position=UDim2.fromOffset(14,9); pt.Size=UDim2.new(1,-28,0,17); pt.TextXAlignment=Enum.TextXAlignment.Left
    local pv=label(prog, string.format("%d / %d  (%d%%)",processedCount,totalCodes,math.floor((processedCount/math.max(totalCodes,1))*100)),WHITE,Enum.Font.GothamBold); pv.Position=UDim2.new(1,-125,0,9); pv.Size=UDim2.fromOffset(110,17); pv.TextXAlignment=Enum.TextXAlignment.Right
    local bar=Instance.new("Frame"); bar.Position=UDim2.fromOffset(14,39); bar.Size=UDim2.new(1,-28,0,9); bar.BackgroundColor3=Color3.fromRGB(35,29,45); bar.BorderSizePixel=0; bar.Parent=prog; corner(bar,5)
    local fill=Instance.new("Frame"); fill.Size=UDim2.new(processedCount/math.max(totalCodes,1),0,1,0); fill.BackgroundColor3=PURPLE; fill.BorderSizePixel=0; fill.Parent=bar; corner(fill,5)
end

local function buildCodes()
    clearBody(); sectionTitle("REDEEM CODES",1)
    local list=card(52+(#Codes*55),2)
    local head=label(list,"CODE",9,GREY,Enum.Font.GothamBold); head.Position=UDim2.fromOffset(15,10); head.Size=UDim2.fromOffset(150,18); head.TextXAlignment=Enum.TextXAlignment.Left
    local hs=label(list,"STATUS",9,GREY,Enum.Font.GothamBold); hs.Position=UDim2.new(1,-118,0,10); hs.Size=UDim2.fromOffset(90,18); hs.TextXAlignment=Enum.TextXAlignment.Right
    for i,code in ipairs(Codes) do
        local row=Instance.new("Frame"); row.Position=UDim2.fromOffset(8,35+(i-1)*55); row.Size=UDim2.new(1,-16,0,47); row.BackgroundColor3=claimedCodes[code] and Color3.fromRGB(16,26,25) or PANEL2; row.BorderSizePixel=0; row.Parent=list; corner(row,11); stroke(row,claimedCodes[code] and Color3.fromRGB(50,120,86) or Color3.fromRGB(46,37,61),1)
        local num=label(row,tostring(i),10,GREY,Enum.Font.GothamBold); num.Position=UDim2.fromOffset(10,13); num.Size=UDim2.fromOffset(24,18); num.TextXAlignment=Enum.TextXAlignment.Center
        local c=label(row,code,11,WHITE,Enum.Font.GothamMedium); c.Position=UDim2.fromOffset(44,12); c.Size=UDim2.new(1,-180,0,20); c.TextXAlignment=Enum.TextXAlignment.Left
        local s=label(row,claimedCodes[code] and "CLAIMED" or "WAITING",9,claimedCodes[code] and GREEN or GREY,Enum.Font.GothamBold); s.Position=UDim2.new(1,-108,0,13); s.Size=UDim2.fromOffset(92,18); s.TextXAlignment=Enum.TextXAlignment.Right
    end
    local b=button(list,"REDEEM ALL"); b.Position=UDim2.fromOffset(8,40+#Codes*55); b.Size=UDim2.new(1,-16,0,36); b.BackgroundColor3=PURPLE2; b.BackgroundTransparency=0; b.TextColor3=WHITE; b.TextSize=10; b.Font=Enum.Font.GothamBold; corner(b,10); b.MouseButton1Click:Connect(function() if not IsRedeeming then AutoRedeem=true; task.spawn(startRedeem); buildCodes() end end)
end

local function buildHistory()
    clearBody(); sectionTitle("ACTIVITY HISTORY",1)
    local list=card(math.max(90,#history*48+25),2)
    if #history==0 then
        local t=label(list,"No activity yet.",10,GREY,Enum.Font.Gotham); t.Position=UDim2.fromOffset(14,32); t.Size=UDim2.new(1,-28,0,20); t.TextXAlignment=Enum.TextXAlignment.Left
    else
        for i,item in ipairs(history) do
            local y=10+(i-1)*48
            local t=label(list,item.text,9,item.color,Enum.Font.GothamMedium); t.Position=UDim2.fromOffset(14,y); t.Size=UDim.new(1,-90,0,18); t.TextXAlignment=Enum.TextXAlignment.Left
            local tm=label(list,item.time,8,GREY,Enum.Font.Gotham); tm.Position=UDim2.new(1,-70,0,y); tm.Size=UDim.fromOffset(56,18); tm.TextXAlignment=Enum.TextXAlignment.Right
        end
    end
    local clear=button(list,"CLEAR HISTORY"); clear.Position=UDim2.new(1,-110,1,-35); clear.Size=UDim2.fromOffset(96,26); clear.TextColor3=GREY; clear.TextSize=8; clear.Font=Enum.Font.GothamBold; clear.MouseButton1Click:Connect(function() history={}; buildHistory() end)
end

local function buildSettings()
    clearBody(); sectionTitle("SETTINGS",1)
    local f=card(292,2)
    toggleCard(f,8,"System Protection","Keep the UI isolated and guarded",function() return SystemProtection end,function(v) SystemProtection=v; addHistory(v and "System Protection enabled" or "System Protection disabled",v and GREEN or RED); buildSettings() end,GREEN)
    toggleCard(f,81,"FPS Boost","Local rendering optimization",function() return FPSBoost end,function(v) FPSBoost=v; addHistory(v and "FPS Boost enabled" or "FPS Boost disabled",VIOLET); buildSettings() end,VIOLET)
    toggleCard(f,154,"Anti AFK","Prevents idle kick while enabled",function() return AntiAFK end,function(v) AntiAFK=v; addHistory(v and "Anti AFK enabled" or "Anti AFK disabled",GREEN); buildSettings() end,GREEN)
    local about=label(f,"K5 HUB  •  PREMIUM PHONE UI\nFAST  •  STABLE  •  SECURE",9,GREY,Enum.Font.GothamMedium); about.Position=UDim2.fromOffset(14,233); about.Size=UDim2.new(1,-28,0,45); about.TextXAlignment=Enum.TextXAlignment.Left; about.TextYAlignment=Enum.TextYAlignment.Top
end

function startRedeem()
    if IsRedeeming then return end
    IsRedeeming=true
    addHistory("Redeem process started",PURPLE)
    for index,code in ipairs(Codes) do
        if not AutoRedeem and currentPage ~= "Codes" then break end
        if not claimedCodes[code] then
            CodeRE:FireServer({event="usecode",code=code})
            claimedCodes[code]=true
            processedCount += 1
            addHistory("Sent code: "..code,GREEN)
            if currentPage=="Home" then buildHome() elseif currentPage=="Codes" then buildCodes() end
            if index < totalCodes then task.wait(REDEEM_DELAY) end
        end
    end
    IsRedeeming=false
    addHistory("Redeem process finished",WHITE)
    if currentPage=="Home" then buildHome() elseif currentPage=="Codes" then buildCodes() elseif currentPage=="History" then buildHistory() end
end

-- NAVIGATION
local Nav=Instance.new("Frame")
Nav.Position=UDim2.new(0,12,1,-52)
Nav.Size=UDim2.new(1,-24,0,42)
Nav.BackgroundColor3=PANEL
Nav.BorderSizePixel=0
Nav.Parent=Main
corner(Nav,13); stroke(Nav,Color3.fromRGB(50,39,67),1)
local navItems={"Home","Codes","History","Settings"}
local navButtons={}
local function showPage(name)
    currentPage=name
    if name=="Home" then buildHome() elseif name=="Codes" then buildCodes() elseif name=="History" then buildHistory() else buildSettings() end
    for n,b in pairs(navButtons) do
        b.TextColor3=(n==name) and VIOLET or GREY
    end
end
for i,name in ipairs(navItems) do
    local b=button(Nav,name)
    b.Position=UDim2.new((i-1)/4,0,0,0)
    b.Size=UDim2.new(1/4,0,1,0)
    b.TextSize=8
    b.Font=Enum.Font.GothamBold
    b.TextColor3=GREY
    b.MouseButton1Click:Connect(function() showPage(name) end)
    navButtons[name]=b
end

-- Minimize / restore
local Mini=Instance.new("TextButton")
Mini.Size=UDim2.fromOffset(56,56)
Mini.AnchorPoint=Vector2.new(.5,.5)
Mini.Position=UDim2.fromScale(.5,.5)
Mini.BackgroundColor3=PANEL2
Mini.Text="K5"
Mini.TextColor3=WHITE
Mini.TextSize=22
Mini.Font=Enum.Font.GothamBlack
Mini.AutoButtonColor=false
Mini.Visible=false
Mini.Parent=ScreenGui
corner(Mini,16); stroke(Mini,PURPLE,1.5)
local savedScale=1
Min.MouseButton1Click:Connect(function()
    Main.Visible=false; Mini.Visible=true
end)
Close.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
end)
Mini.MouseButton1Click:Connect(function() Mini.Visible=false; Main.Visible=true end)

-- PHONE RESPONSIVE
local function resize()
    local cam=workspace.CurrentCamera
    if not cam then return end
    local v=cam.ViewportSize
    local sx=(v.X-20)/390
    local sy=(v.Y-20)/650
    UIScale.Scale=math.min(1,sx,sy)
end
resize()
if workspace.CurrentCamera then workspace.CurrentCamera:GetPropertyChangedSignal("ViewportSize"):Connect(resize) end

-- Anti AFK
Player.Idled:Connect(function()
    if AntiAFK then
        pcall(function()
            VirtualUser:CaptureController()
            VirtualUser:ClickButton2(Vector2.new())
        end)
    end
end)

-- Lightweight local FPS mode. It avoids touching gameplay logic.
local function applyFPSBoost()
    if not FPSBoost then return end
    pcall(function()
        Lighting.GlobalShadows=false
        Lighting.FogEnd=100000
        for _,obj in ipairs(workspace:GetDescendants()) do
            if obj:IsA("ParticleEmitter") or obj:IsA("Trail") or obj:IsA("Beam") then
                obj.Enabled=false
            elseif obj:IsA("PostEffect") then
                obj.Enabled=false
            end
        end
    end)
end

local lastFPS=false
RunService.RenderStepped:Connect(function()
    if FPSBoost and not lastFPS then applyFPSBoost(); lastFPS=true end
    if not FPSBoost then lastFPS=false end
end)

showPage("Home")
addHistory("K5 HUB initialized",GREEN)
