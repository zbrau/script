local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "Victor Mendivil Obby Script🔥",
   LoadingTitle = "Cargando Script",
   LoadingSubtitle = "por zbrau",
   ConfigurationSaving = {
      Enabled = true,
      FolderName = nil,
      FileName = "Victor Mendivil Obby Script🔥"
   },
   Discord = {
      Enabled = false,
      Invite = "noinvitelink",
      RememberJoins = true
   },
   KeySystem = false,
})

-- Tab Principal de Checkpoints
local CheckpointTab = Window:CreateTab("Checkpoints", 4483362458)

CheckpointTab:CreateSection("Teletransporte Individual")

-- Variable para controlar el auto-farm
local autoFarmRunning = false
local delayTime = 1

-- Función para teletransportar al jugador
local function teleportToCheckpoint(checkpointName)
    local player = game.Players.LocalPlayer
    local character = player.Character
    
    if not character then return false end
    
    local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
    if not humanoidRootPart then return false end
    
    local checkpoint = workspace.Checkpoints:FindFirstChild(tostring(checkpointName))
    if checkpoint then
        humanoidRootPart.CFrame = checkpoint.CFrame + Vector3.new(0, 3, 0)
        return true
    end
    return false
end

-- Función para activar el ProximityPrompt final
local function activateFinalPrompt()
    local success = pcall(function()
        local player = game.Players.LocalPlayer
        local character = player.Character
        
        if not character then return false end
        
        local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
        if not humanoidRootPart then return false end
        
        -- Buscar el CRONOVISOR y su ProximityPrompt
        local cronovisor = workspace:FindFirstChild("Final")
        if cronovisor then
            cronovisor = cronovisor:FindFirstChild("CRONOVISOR")
            if cronovisor then
                local part = cronovisor:FindFirstChild("Part")
                if part then
                    -- Teletransportar cerca del CRONOVISOR
                    humanoidRootPart.CFrame = part.CFrame + Vector3.new(0, 3, 0)
                    task.wait(0.3) -- Esperar un poco para asegurar que llegó
                    
                    -- Activar el ProximityPrompt
                    local proximityPrompt = part:FindFirstChild("ProximityPrompt")
                    if proximityPrompt then
                        fireproximityprompt(proximityPrompt)
                        return true
                    end
                end
            end
        end
    end)
    return success
end

-- Variable para guardar el checkpoint seleccionado
local selectedCheckpoint = "0"

-- Dropdown para seleccionar checkpoint individual
CheckpointTab:CreateDropdown({
    Name = "Seleccionar Checkpoint",
    Options = {"0", "1", "2", "3", "4", "5", "6", "7", "8", "9",
               "10", "11", "12", "13", "14", "15", "16", "17", "18", "19",
               "20", "21", "22", "23", "24", "25", "26", "27", "28", "29",
               "30", "31", "32", "33", "34", "35", "36", "37", "38", "39", "40"},
    CurrentOption = {"0"},
    MultipleOptions = false,
    Flag = "CheckpointDropdown",
    Callback = function(value)
        if type(value) == "table" then
            selectedCheckpoint = value[1] or value
        else
            selectedCheckpoint = tostring(value)
        end
    end,
})

CheckpointTab:CreateButton({
    Name = "Ir al Checkpoint Seleccionado",
    Callback = function()
        local cpName = selectedCheckpoint
        if type(cpName) == "table" then
            cpName = cpName[1]
        end
        
        if teleportToCheckpoint(cpName) then
            Rayfield:Notify({
                Title = "Teletransportado",
                Content = "Checkpoint: " .. tostring(cpName),
                Duration = 2,
                Image = 4483362458,
            })
        else
            Rayfield:Notify({
                Title = "Error",
                Content = "No se pudo teletransportar",
                Duration = 3,
                Image = 4483362458,
            })
        end
    end,
})

CheckpointTab:CreateSection("Automatización")

-- Toggle para teletransportarse a todos los checkpoints en orden
CheckpointTab:CreateToggle({
    Name = "Auto Farm Checkpoints",
    CurrentValue = false,
    Flag = "AutoFarmCheckpoints",
    Callback = function(Value)
        autoFarmRunning = Value
        
        if Value then
            Rayfield:Notify({
                Title = "Auto Farm Activado",
                Content = "Teletransportando del 0 al 40...",
                Duration = 3,
                Image = 4483362458,
            })
            
            task.spawn(function()
                while autoFarmRunning do
                    local player = game.Players.LocalPlayer
                    local character = player.Character
                    
                    if character and character:FindFirstChild("HumanoidRootPart") then
                        -- Recorrer todos los checkpoints
                        for i = 0, 40 do
                            if not autoFarmRunning then break end
                            
                            if teleportToCheckpoint(tostring(i)) then
                                task.wait(delayTime)
                            end
                        end
                        
                        -- Al llegar al checkpoint 40, activar el ProximityPrompt
                        if autoFarmRunning then
                            Rayfield:Notify({
                                Title = "Finalizando Vuelta",
                                Content = "Activando CRONOVISOR...",
                                Duration = 2,
                                Image = 4483362458,
                            })
                            
                            task.wait(0.5) -- Pequeño delay
                            
                            if activateFinalPrompt() then
                                Rayfield:Notify({
                                    Title = "Vuelta Completada",
                                    Content = "CRONOVISOR activado!",
                                    Duration = 2,
                                    Image = 4483362458,
                                })
                            else
                                Rayfield:Notify({
                                    Title = "Advertencia",
                                    Content = "Error al activar CRONOVISOR",
                                    Duration = 2,
                                    Image = 4483362458,
                                })
                            end
                            
                            task.wait(3) -- Esperar 3 segundos antes de reiniciar
                            
                            if autoFarmRunning then
                                Rayfield:Notify({
                                    Title = "Nueva Vuelta",
                                    Content = "Reiniciando del checkpoint 0...",
                                    Duration = 2,
                                    Image = 4483362458,
                                })
                            end
                        end
                    else
                        task.wait(1)
                    end
                end
            end)
        else
            Rayfield:Notify({
                Title = "Auto Farm Desactivado",
                Content = "Detenido",
                Duration = 2,
                Image = 4483362458,
            })
        end
    end,
})

-- Botón para teletransportarse a todos UNA VEZ
CheckpointTab:CreateButton({
    Name = "Recorrer Todos (Una Vez)",
    Callback = function()
        Rayfield:Notify({
            Title = "Iniciando Recorrido",
            Content = "Del checkpoint 0 al 40",
            Duration = 3,
            Image = 4483362458,
        })
        
        task.spawn(function()
            for i = 0, 40 do
                if teleportToCheckpoint(tostring(i)) then
                    task.wait(delayTime)
                end
            end
            
            -- Activar el ProximityPrompt al finalizar
            task.wait(0.5)
            if activateFinalPrompt() then
                Rayfield:Notify({
                    Title = "Completado",
                    Content = "Vuelta finalizada!",
                    Duration = 3,
                    Image = 4483362458,
                })
            else
                Rayfield:Notify({
                    Title = "Completado",
                    Content = "Checkpoints visitados (Error en CRONOVISOR)",
                    Duration = 3,
                    Image = 4483362458,
                })
            end
        end)
    end,
})

CheckpointTab:CreateSection("Manual")

-- Botón para activar el ProximityPrompt manualmente
CheckpointTab:CreateButton({
    Name = "Ir y Activar CRONOVISOR",
    Callback = function()
        if activateFinalPrompt() then
            Rayfield:Notify({
                Title = "Éxito",
                Content = "CRONOVISOR activado!",
                Duration = 2,
                Image = 4483362458,
            })
        else
            Rayfield:Notify({
                Title = "Error",
                Content = "No se pudo activar el CRONOVISOR",
                Duration = 3,
                Image = 4483362458,
            })
        end
    end,
})

CheckpointTab:CreateSection("Configuración")

-- Slider para ajustar el delay
CheckpointTab:CreateSlider({
    Name = "Delay entre Checkpoints",
    Range = {0.1, 5},
    Increment = 0.1,
    CurrentValue = 1,
    Flag = "DelaySlider",
    Callback = function(Value)
        delayTime = Value
    end,
})

-- Tab de Información
local InfoTab = Window:CreateTab("Info", 4483362458)

InfoTab:CreateSection("Información del Script")

InfoTab:CreateParagraph({
    Title = "Cómo usar",
    Content = "Auto Farm recorre del 0 al 40, luego se teletransporta al CRONOVISOR, lo activa y reinicia automaticamente la vuelta."
})

InfoTab:CreateParagraph({
    Title = "Características",
    Content = "• Auto Farm infinito con reinicio automatico\n• Activacion automatica del CRONOVISOR\n• Boton manual para CRONOVISOR\n• Delay ajustable"
})

InfoTab:CreateButton({
    Name = "Cerrar UI",
    Callback = function()
        Rayfield:Destroy()
    end,
})

-- Notificación de carga exitosa
Rayfield:Notify({
    Title = "Script Cargado",
    Content = "Listo para usar",
    Duration = 5,
    Image = 4483362458,
})
