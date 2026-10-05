-- SCANNER SCRIPT - FIXED VERSION
-- Version: 1.2

local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local StarterPlayerScripts = game:GetService("StarterPlayerScripts")
local ServerScriptService = game:GetService("ServerScriptService")

local ExportData = {}
local function AddLine(text)
    table.insert(ExportData, text)
    print(text)
end

print("==================================")
print("STARTING SCAN...")
print("==================================")

AddLine("==================================")
AddLine("SCAN REPORT")
AddLine("GENERATED: " .. os.date("%Y-%m-%d %H:%M:%S"))
AddLine("==================================")

-- [1] OBJECTS IN WORKSPACE
AddLine("\n[1] OBJECTS & ITEMS")
AddLine("----------------------------------")
local itemList = {}
for _, obj in pairs(Workspace:GetDescendants()) do
    if obj:IsA("BasePart") or obj:IsA("Model") then
        local pos = "N/A"
        if obj:IsA("BasePart") then pos = tostring(obj.Position) end
        local entry = string.format("NAME: %-35s | CLASS: %-20s | POS: %s", obj.Name, obj.ClassName, pos)
        table.insert(itemList, entry)
        AddLine(entry)
    end
end
AddLine("----------------------------------")
AddLine("TOTAL OBJECTS: " .. #itemList)

-- [2] REMOTES & EVENTS
AddLine("\n[2] REMOTES & EVENTS")
AddLine("----------------------------------")
local remoteList = {}
local function ScanRemotes(parent)
    if not parent then return end
    for _, child in pairs(parent:GetChildren()) do
        if child:IsA("RemoteEvent") or child:IsA("RemoteFunction") or child:IsA("BindableEvent") then
            local entry = string.format("NAME: %-40s | TYPE: %-20s | PATH: %s", child.Name, child.ClassName, child:GetFullName())
            table.insert(remoteList, entry)
            AddLine(entry)
        end
        task.spawn(ScanRemotes, child)
    end
end
ScanRemotes(ReplicatedStorage)
ScanRemotes(ServerScriptService)
AddLine("----------------------------------")
AddLine("TOTAL REMOTES: " .. #remoteList)

-- [3] SCRIPTS - WITH SAFETY CHECK ✅
AddLine("\n[3] SCRIPTS FOUND")
AddLine("----------------------------------")
local scriptList = {}
local function ScanScripts(parent)
    if not parent then return end -- ป้องกันข้อผิดพลาดตรงนี้ครับ
    for _, child in pairs(parent:GetChildren()) do
        if child:IsA("LuaSourceContainer") then
            local entry = string.format("NAME: %-40s | PATH: %s", child.Name, child:GetFullName())
            table.insert(scriptList, entry)
            AddLine(entry)
        end
        task.spawn(ScanScripts, child)
    end
end
ScanScripts(StarterPlayerScripts)
ScanScripts(ReplicatedStorage)
ScanScripts(Workspace)
AddLine("----------------------------------")
AddLine("TOTAL SCRIPTS: " .. #scriptList)

-- [4] PLAYER INFO
AddLine("\n[4] PLAYER INFO")
AddLine("----------------------------------")
local Me = Players.LocalPlayer
AddLine("Name: " .. Me.Name)
AddLine("UserID: " .. Me.UserId)
if Me.Character then
    AddLine("Character: LOADED")
    local Root = Me.Character:FindFirstChild("HumanoidRootPart")
    if Root then AddLine("Position: " .. tostring(Root.Position)) end
else
    AddLine("Character: NOT LOADED")
end

-- EXPORT BLOCK
AddLine("\n==================================")
AddLine("=== COPY EVERYTHING BELOW ===")
AddLine("==================================")
local FullExport = table.concat(ExportData, "\n")
AddLine(FullExport)
AddLine("==================================")
AddLine("SCAN COMPLETE! SAVE & SHARE")
AddLine("==================================")
print("\n💡 Copy all text → Save to notepad → Send here")
