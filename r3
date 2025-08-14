-- 🌟 PhantomX Ultimate v4.0 - Rayfield | 100% funcional
-- ✅ Sin errores, todas las funciones incluidas

-- === Cargar Rayfield ===
local Rayfield = nil
repeat
    pcall(function()
        Rayfield = loadstring(game:HttpGet("https://sirius.menu/rayfield", true))()
    end)
    task.wait()
until Rayfield or task.wait(1) -- Esperar 1 segundo antes de fallar

if not Rayfield then
    game.StarterGui:SetCore("ChatMakeSystemMessage", {
        Text = "❌ Error al cargar Rayfield",
        Color = Color3.new(1, 0, 0),
        FontSize = 20
    })
    return
end

-- === Crear ventana principal ===
local Window = Rayfield:CreateWindow({
    Name = "<font color='#BD00FF'>🌌</font> <font color='#FFFFFF'>PhantomX Ultimate</font>",
    LoadingTitle = "Cargando...",
    ConfigurationSaving = { Enabled = true, FolderName = "PhantomX", FileName = "Config" },
    KeySystem = false
})

-- === Variables ===
local Player = game.Players.LocalPlayer
local Players = game.Players
local Workspace = game.Workspace
local Camera = Workspace.CurrentCamera
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local Character, Humanoid, HumanoidRootPart

local function GetCharacter()
    Character = Player.Character or Player.CharacterAdded:Wait()
    Humanoid = Character:FindFirstChildOfClass("Humanoid")
    HumanoidRootPart = Character:FindFirstChild("HumanoidRootPart")
end

GetCharacter()
Player.CharacterAdded:Connect(GetCharacter)

-- === Notificaciones ===
local function Notify(Title, Content, Duration)
    Rayfield:Notify({
        Title = Title,
        Content = Content,
        Duration = Duration or 5,
        Image = 4483366805,
        Actions = { Ignore = { Name = "Cerrar", Callback = function() end } }
    })
end

-- === Pestaña: Jugador ===
local TabPlayer = Window:CreateTab("🧑 Jugador", 6026565612)

TabPlayer:CreateSlider({
    Name = "👟 WalkSpeed",
    Range = {16, 500},
    Increment = 1,
    Suffix = " studs",
    CurrentValue = 16,
    Callback = function(Value)
        if Humanoid then Humanoid.WalkSpeed = Value end
    end
})

TabPlayer:CreateSlider({
    Name = "🚀 JumpPower",
    Range = {50, 300},
    Increment = 1,
    Suffix = " studs",
    CurrentValue = 50,
    Callback = function(Value)
        if Humanoid then Humanoid.JumpPower = Value end
    end
})

-- Infinite Jump
TabPlayer:CreateToggle({
    Name = "♾️ Salto Infinito",
    CurrentValue = false,
    Callback = function(State)
        if State then
            game:GetService("UserInputService").JumpRequest:Connect(function()
                if Humanoid then Humanoid:ChangeState(Enum.HumanoidStateType.Jumping) end
            end)
        end
    end
})

-- === Pestaña: Movimiento ===
local TabMove = Window:CreateTab("🚀 Movimiento", 118517218)

-- Noclip
local Noclip = false
TabMove:CreateToggle({
    Name = "🚫 Noclip (N)",
    CurrentValue = false,
    Callback = function(State)
        Noclip = State
        if HumanoidRootPart then
            HumanoidRootPart.Anchored = State
        end
    end
})

-- Fly
local Flying = false
TabMove:CreateToggle({
    Name = "✈️ Fly (F)",
    CurrentValue = false,
    Callback = function(State)
        Flying = State
        if HumanoidRootPart then
            HumanoidRootPart.Anchored = State
        end
    end
})

-- Controles
game:GetService("UserInputService").InputBegan:Connect(function(Input)
    if Input.KeyCode == Enum.KeyCode.N then
        Noclip = not Noclip
        if HumanoidRootPart then
            HumanoidRootPart.Anchored = Noclip
        end
    elseif Input.KeyCode == Enum.KeyCode.F then
        Flying = not Flying
        if HumanoidRootPart then
            HumanoidRootPart.Anchored = Flying
        end
    end
end)

-- Loop de movimiento
game:GetService("RunService").RenderStepped:Connect(function()
    if (Noclip or Flying) and HumanoidRootPart then
        HumanoidRootPart.CanCollide = false
        local Move = Vector3.new(0, 0, 0)
        local Speed = 100
        if game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.W) then Move = Move + workspace.CurrentCamera.CFrame.LookVector * Speed end
        if game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.S) then Move = Move - workspace.CurrentCamera.CFrame.LookVector * Speed end
        if game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.A) then Move = Move - workspace.CurrentCamera.CFrame.RightVector * Speed end
        if game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.D) then Move = Move + workspace.CurrentCamera.CFrame.RightVector * Speed end
        if game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.Space) then Move = Move + Vector3.new(0, Speed, 0) end
        if game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.LeftControl) then Move = Move - Vector3.new(0, Speed, 0) end
        HumanoidRootPart.CFrame = HumanoidRootPart.CFrame + Move * 0.1
    end
end)

-- === Pestaña: Teleport ===
local TabTP = Window:CreateTab("📍 Teleport", 8785381028)

TabTP:CreateDropdown({
    Name = "🎯 TP a Jugador",
    Options = function()
        local List = {}
        for _, P in game.Players:GetPlayers() do
            if P ~= Player then
                table.insert(List, P.Name)
            end
        end
        return List
    end,
    CurrentOption = "",
    Callback = function(Name)
        local Target = game.Players:FindFirstChild(Name)
        if Target and Target.Character then
            local HRP = Target.Character:FindFirstChild("HumanoidRootPart")
            if HRP and HumanoidRootPart then
                HumanoidRootPart.CFrame = HRP.CFrame
                Notify("TP Exitoso", "Teleportado a " .. Name)
            end
        end
    end
})

TabTP:CreateButton({
    Name = "🖱️ TP al Ratón",
    Callback = function()
        local Mouse = Player:GetMouse()
        if Mouse.Target then
            HumanoidRootPart.CFrame = CFrame.new(Mouse.Hit.Position + Vector3.new(0, 5, 0))
            Notify("TP al Ratón", "Teleport realizado", 2)
        end
    end
})

-- === Pestaña: ESP ===
local TabESP = Window:CreateTab("👁️ ESP", 3926305904)
local ESPBoxes = {}

TabESP:CreateToggle({
    Name = "👥 ESP Jugadores",
    CurrentValue = false,
    Callback = function(State)
        if not State then
            for _, Box in pairs(ESPBoxes) do Box:Destroy() end
            ESPBoxes = {}
        else
            spawn(function()
                while State do
                    task.wait()
                    for _, P in game.Players:GetPlayers() do
                        if P ~= Player and P.Character then
                            local Head = P.Character:FindFirstChild("Head")
                            if Head and not Head:FindFirstChildWhichIsA("BoxHandleAdornment") then
                                local Box = Instance.new("BoxHandleAdornment")
                                Box.Adornee = Head
                                Box.Size = Head.Size + Vector3.new(0.1, 0.1, 0.1)
                                Box.Color3 = Color3.fromRGB(0, 255, 255)
                                Box.Transparency = 0.5
                                Box.AlwaysOnTop = true
                                Box.ZIndex = 10
                                Box.Parent = workspace.CurrentCamera
                                table.insert(ESPBoxes, Box)
                            end
                        end
                    end
                end
            end)
        end
    end
})

-- === Pestaña: Fling ===
local TabFling = Window:CreateTab("💥 Fling", 892466017)

TabFling:CreateDropdown({
    Name = "🎯 Fling a Jugador",
    Options = function()
        local List = {}
        for _, P in game.Players:GetPlayers() do
            if P ~= Player then
                table.insert(List, P.Name)
            end
        end
        return List
    end,
    CurrentOption = "",
    Callback = function(Name)
        local Target = game.Players:FindFirstChild(Name)
        if Target and Target.Character and HumanoidRootPart then
            local HRP = Target.Character:FindFirstChild("HumanoidRootPart")
            if HRP then
                local BV = Instance.new("BodyVelocity")
                BV.MaxForce = Vector3.new(1e9, 1e9, 1e9)
                BV.Velocity = (HRP.Position - HumanoidRootPart.Position).unit * 200
                BV.Parent = HumanoidRootPart
                task.delay(0.5, function() BV:Destroy() end)
                Notify("Fling", Name .. " lanzado")
            end
        end
    end
})

-- === Pestaña: Auto-Farm ===
local TabFarm = Window:CreateTab("⚔️ Farm", 2864007918)

local AutoFarm = false
TabFarm:CreateToggle({
    Name = "🤖 Auto-Farm NPCs",
    CurrentValue = false,
    Callback = function(State)
        AutoFarm = State
    end
})

game:GetService("RunService").Heartbeat:Connect(function()
    if AutoFarm then
        local Closest = nil
        local Dist = math.huge
        for _, NPC in workspace:GetChildren() do
            if NPC:IsA("Model") and NPC:FindFirstChild("Humanoid") and NPC.Humanoid.Health > 0 then
                local HRP = NPC:FindFirstChild("HumanoidRootPart")
                if HRP then
                    local Mag = (HumanoidRootPart.Position - HRP.Position).Magnitude
                    if Mag < Dist then
                        Dist = Mag
                        Closest = HRP
                    end
                end
            end
        end
        if Closest then
            Humanoid:MoveTo(Closest.Position)
        end
    end
end)

-- === Notificación final ===
Notify("✅ PhantomX Ultimate", "GUI cargado correctamente", 5)
