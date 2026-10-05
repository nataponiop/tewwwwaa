-- SCANNER SCRIPT - ROBLOX DATA EXTRACTOR
-- Version: 1.0

local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local StarterPlayerScripts = game:GetService("StarterPlayerScripts")
local ServerScriptService = game:GetService("ServerScriptService")

print("==================================")
print("STARTING SCAN...")
print("==================================")

-- [1] SCAN ALL OBJECTS IN WORKSPACE
print("\n[1] ALL OBJECTS & ITEMS:")
local itemList = {}
for _, obj in pairs(Workspace:GetDescendants()) do
    if obj:IsA("BasePart") or obj:IsA("Model") then
        local pos = "N/A"
        if obj:IsA("BasePart") then pos = tostring(obj.Position) end
        local data = {
            Name = obj.Name,
            Class = obj.ClassName,
            Path = obj:GetFullName(),
            Position = pos
        }
        table.insert(itemList, data)
        print("→ " .. data.Name .. " | " .. data.Class .. " | " .. data.Path)
    end
end
print("FOUND: " .. #itemList .. " ITEMS")

-- [2] SCAN REMOTES & EVENTS
print("\n[2] REMOTES & EVENTS:")
local remoteList = {}
local function ScanRemotes(parent)
    for _, child in pairs(parent:GetChildren()) do
        if child:IsA("RemoteEvent") or child:IsA("RemoteFunction") or child:IsA("BindableEvent") then
            table.insert(remoteList, {
                Name = child.Name,
                Type = child.ClassName,
                Path = child:GetFullName()
            })
            print("→ " .. child.Name .. " | " .. child.ClassName .. " | " .. child:GetFullName())
        end
        task.spawn(ScanRemotes, child)
    end
end
ScanRemotes(ReplicatedStorage)
ScanRemotes(ServerScriptService)
print("FOUND: " .. #remoteList .. " REMOTES")

-- [3] SCAN SCRIPTS
print("\n[3] SCRIPTS FOUND:")
local scriptList = {}
local function ScanScripts(parent)
    for _, child in pairs(parent:GetChildren()) do
        if child:IsA("LuaSourceContainer") then
            table.insert(scriptList, {
                Name = child.Name,
                Path = child:GetFullName()
            })
            print("→ " .. child.Name .. " | " .. child:GetFullName())
        end
        task.spawn(ScanScripts, child)
    end
end
ScanScripts(StarterPlayerScripts)
ScanScripts(ReplicatedStorage)
ScanScripts(Workspace)
print("FOUND: " .. #scriptList .. " SCRIPTS")

-- [4] PLAYER INFO
print("\n[4] PLAYER DATA:")
local Me = Players.LocalPlayer
print("Name: " .. Me.Name)
print("UserID: " .. Me.UserId)
if Me.Character then
    print("Character: LOADED")
    local Root = Me.Character:FindFirstChild("HumanoidRootPart")
    if Root then print("Position: " .. tostring(Root.Position)) end
else
    print("Character: NOT LOADED")
end

-- FINAL SUMMARY
print("\n==================================")
print("SCAN COMPLETE")
print("TOTAL OBJECTS: " .. #itemList)
print("TOTAL REMOTES: " .. #remoteList)
print("TOTAL SCRIPTS: " .. #scriptList)
print("==================================")
