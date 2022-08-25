local lplr = game.Players.LocalPlayer
local camera = game:GetService("Workspace").CurrentCamera
local CurrentCamera = workspace.CurrentCamera
local worldToViewportPoint = CurrentCamera.worldToViewportPoint
local HeadOff = Vector3.new(0, 0.5, 0)
local LegOff = Vector3.new(0,3,0)

if not getgenv().OptionsBoxESP then
    getgenv().OptionsBoxESP = {
        OutlineColor = Color3.new(0,0,0),
        AccentColor = Color3.new(255, 255, 255),
        TextColor = Color3.new(255, 255, 255),
        Distance = 100,
        Enabled = true,
        BoxNHealth = true,
        LookLine = true,
        Name = true,
        Dist = true,
        Tool = true,
        TeamCheck = false;
    }
end

local function ValidChar(v)
    if v.Character ~= nil and v.Character:FindFirstChild("Humanoid") ~= nil and v.Character:FindFirstChild("HumanoidRootPart") ~= nil and v ~= lplr and v.Character.Humanoid.Health > 0 and lplr.Character ~= nil and lplr.Character.Humanoid.Health > 0 and v.Character.Head ~= nil and v.Character.HumanoidRootPart ~= nil then
        return true
    else
        return false
    end
end

getgenv().BoxESP = function(v)
    local BoxOutline = Drawing.new("Square")
    BoxOutline.Visible = false
    BoxOutline.Color = getgenv().OptionsBoxESP["OutlineColor"]
    BoxOutline.Thickness = 3
    BoxOutline.Transparency = 1
    BoxOutline.Filled = false

    local Box = Drawing.new("Square")
    Box.Visible = false
    Box.Color = getgenv().OptionsBoxESP["AccentColor"]
    Box.Thickness = 1
    Box.Transparency = 1
    Box.Filled = false

    local HealthBarOutline = Drawing.new("Square")
    HealthBarOutline.Thickness = 3
    HealthBarOutline.Filled = false
    HealthBarOutline.Color = getgenv().OptionsBoxESP["OutlineColor"]
    HealthBarOutline.Transparency = 1
    HealthBarOutline.Visible = false

    local HealthBar = Drawing.new("Square")
    HealthBar.Thickness = 1
    HealthBar.Filled = false
    HealthBar.Transparency = 1
    HealthBar.Visible = false

    local Name = Drawing.new("Text")
    Name.Color = getgenv().OptionsBoxESP["TextColor"]
    Name.Outline = true
    Name.Center = true
    Name.Size = 13
    Name.Font = 2

    local Misc = Drawing.new("Text")
    Misc.Color = getgenv().OptionsBoxESP["TextColor"]
    Misc.Outline = true
    Misc.Center = true
    Misc.Size = 13
    Misc.Font = 2
    
    local Misc2 = Drawing.new("Text")
    Misc2.Color = getgenv().OptionsBoxESP["TextColor"]
    Misc2.Outline = true
    Misc2.Center = true
    Misc2.Size = 13
    Misc2.Font = 2

    local LookLine = Drawing.new("Line")
    LookLine.Visible = true
    LookLine.Color = getgenv().OptionsBoxESP["AccentColor"]
    LookLine.Thickness = 2
    LookLine.Transparency = 1    

    local function boxesp()
        game:GetService("RunService").RenderStepped:Connect(function()
            if ValidChar(v) then
                local Vector, onScreen = camera:worldToViewportPoint(v.Character.HumanoidRootPart.Position)
                local Character = v.Character
                local RootPart = v.Character.HumanoidRootPart
                local Head = v.Character.Head
                local hum = v.Character.Humanoid
                local LineOff = Head.CFrame * Vector3.new(0,0,-3)
                local HeadFlat = Head.CFrame * Vector3.new(0,0.5,0)
                local RootFlat = RootPart.CFrame * Vector3.new(0,3,0)
                local HeadPosition2 = worldToViewportPoint(CurrentCamera, LineOff)
                local HeadPosition3 = worldToViewportPoint(CurrentCamera, Head.Position)
                local RootPosition, RootVis = worldToViewportPoint(CurrentCamera, RootPart.Position)
                local HeadPosition = worldToViewportPoint(CurrentCamera, HeadFlat)
                local LegPosition = worldToViewportPoint(CurrentCamera, RootPart.Position - LegOff)

                local Size = (camera:WorldToViewportPoint(RootPart.Position - Vector3.new(0, 3, 0)).Y - camera:WorldToViewportPoint(RootPart.Position + Vector3.new(0, 2.6, 0)).Y) / 2
                local BoxSize = Vector2.new(math.floor(Size * 1.5), math.floor(Size * 1.9))
                local BoxPos = Vector2.new(math.floor(Vector.X - Size * 1.5 / 2), math.floor(Vector.Y - Size * 1.6 / 2))
                local BottomOffset = BoxSize.Y + BoxPos.Y + 10
                
                Misc.Color = getgenv().OptionsBoxESP["TextColor"]
                Misc2.Color = getgenv().OptionsBoxESP["TextColor"]
                Name.Color = getgenv().OptionsBoxESP["TextColor"]
                HealthBarOutline.Color = getgenv().OptionsBoxESP["OutlineColor"]
                Box.Color = getgenv().OptionsBoxESP["AccentColor"]
                BoxOutline.Color = getgenv().OptionsBoxESP["OutlineColor"]


                if onScreen and (RootPart.Position - lplr.Character.HumanoidRootPart.Position).Magnitude < getgenv().OptionsBoxESP["Distance"] then
                    BoxOutline.Size = Vector2.new(1000 / RootPosition.Z, HeadPosition.Y - LegPosition.Y)
                    BoxOutline.Position = Vector2.new(RootPosition.X - BoxOutline.Size.X / 2, RootPosition.Y - BoxOutline.Size.Y / 2)


                    Box.Size = Vector2.new(1000 / RootPosition.Z, HeadPosition.Y - LegPosition.Y)
                    Box.Position = Vector2.new(RootPosition.X - Box.Size.X / 2, RootPosition.Y - Box.Size.Y / 2)


                    HealthBarOutline.Size = Vector2.new(2, HeadPosition.Y - LegPosition.Y)
                    HealthBarOutline.Position = BoxOutline.Position - Vector2.new(6,0)


                    HealthBar.Size = Vector2.new(2, (HeadPosition.Y - LegPosition.Y) / (hum["MaxHealth"] / math.clamp(hum["Health"], 0, hum["MaxHealth"])))
                    HealthBar.Position = Vector2.new(Box.Position.X - 6, Box.Position.Y + (1 / HealthBar.Size.Y))
                    HealthBar.Color = Color3.fromRGB(255 - 255 / (hum["MaxHealth"] / hum["Health"]), 255 / (hum["MaxHealth"] / hum["Health"]), 0)


                    Name.Position = Vector2.new(BoxSize.X / 2 + BoxPos.X, BoxPos.Y - 40)

                    LookLine.From = Vector2.new(HeadPosition3.X,HeadPosition3.Y)
                    LookLine.To = Vector2.new(HeadPosition2.X,HeadPosition2.Y)


                    if v.name == v.DisplayName then
                        Name.Text = tostring(v.name)
                    else
                        Name.Text = tostring(v.DisplayName) .. " (@" .. tostring(v.name) .. ")"
                    end


                    Misc.Position = Vector2.new(BoxSize.X / 2 + BoxPos.X, BottomOffset)
                    Misc.Text = math.floor((RootPart.Position - lplr.Character.HumanoidRootPart.Position).Magnitude) .. "m away"


                    Misc2.Position = Vector2.new(BoxSize.X / 2 + BoxPos.X, BottomOffset + 16)
                    if Character:FindFirstChildOfClass("Tool") then
                        Misc2.Text = tostring(Character:FindFirstChildOfClass("Tool").Name)
                    else
                        Misc2.Text = "None"
                    end

                    BoxOutline.Visible = getgenv().OptionsBoxESP["BoxNHealth"]
                    Box.Visible = getgenv().OptionsBoxESP["BoxNHealth"]
                    HealthBarOutline.Visible = getgenv().OptionsBoxESP["BoxNHealth"]
                    HealthBar.Visible = getgenv().OptionsBoxESP["BoxNHealth"]

                    Name.Visible = getgenv().OptionsBoxESP["Name"]
                    LookLine.Visible = getgenv().OptionsBoxESP["LookLine"]
                    Misc.Visible = getgenv().OptionsBoxESP["Dist"]
                    Misc2.Visible = getgenv().OptionsBoxESP["Tool"]


                    if v.TeamColor == lplr.TeamColor and getgenv().OptionsBoxESP["TeamCheck"]  then
                        BoxOutline.Visible = false
                        Box.Visible = false
                        HealthBarOutline.Visible = false
                        HealthBar.Visible = false
                        Name.Visible = false
                        Misc.Visible = false
                        LookLine.Visible = false
                    elseif v.TeamColor ~= lplr.TeamColor and getgenv().OptionsBoxESP["TeamCheck"] then
                        BoxOutline.Visible = getgenv().OptionsBoxESP["BoxNHealth"]
                        Box.Visible = getgenv().OptionsBoxESP["BoxNHealth"]
                        HealthBarOutline.Visible = getgenv().OptionsBoxESP["BoxNHealth"]
                        HealthBar.Visible = getgenv().OptionsBoxESP["BoxNHealth"]
    
                        Name.Visible = getgenv().OptionsBoxESP["Name"]
                        LookLine.Visible = getgenv().OptionsBoxESP["LookLine"]
                        Misc.Visible = getgenv().OptionsBoxESP["Dist"]
                        Misc2.Visible = getgenv().OptionsBoxESP["Tool"]
                    end

                    if not getgenv().OptionsBoxESP["Enabled"] then
                        BoxOutline.Visible = false
                        Box.Visible = false
                        HealthBarOutline.Visible = false
                        HealthBar.Visible = false
                        Name.Visible = false
                        Misc.Visible = false
                        Misc2.Visible = false
                        LookLine.Visible = false
                    end
                else
                    BoxOutline.Visible = false
                    Box.Visible = false
                    HealthBarOutline.Visible = false
                    HealthBar.Visible = false
                    Name.Visible = false
                    Misc.Visible = false
                    Misc2.Visible = false
                    LookLine.Visible = false
                end
            else
                BoxOutline.Visible = false
                Box.Visible = false
                HealthBarOutline.Visible = false
                HealthBar.Visible = false
                Name.Visible = false
                Misc.Visible = false
                Misc2.Visible = false
                LookLine.Visible = false
            end
        end)
    end
    coroutine.wrap(boxesp)()
end
