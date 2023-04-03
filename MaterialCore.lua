-- Vars
local ContentProvider = game:GetService("ContentProvider")
local gui = script:WaitForChild('Core')
local activated = false
local LabeledMultiChoice = require(script.StudioWidgets.LabeledMultiChoice)
-- Setup Toolbar
local toolbar = plugin:CreateToolbar("Material Icons")

-- Setup button
local button = toolbar:CreateButton(
	"Inserter",
	"Material icons inserter",
	"http://www.roblox.com/asset/?id=3620778940"
)


local function syncGuiColors(obj)
	local function setColors()
		obj.BackgroundColor3 = settings().Studio.Theme:GetColor(Enum.StudioStyleGuideColor.MainBackground)
	end
	setColors()
	settings().Studio.ThemeChanged:Connect(setColors)
end

local function syncSearchBarColor(obj)
	local function setColors()
		obj.ImageColor3 = settings().Studio.Theme:GetColor(Enum.StudioStyleGuideColor.Tooltip)
		obj.Icon.ImageColor3 = settings().Studio.Theme:GetColor(Enum.StudioStyleGuideColor.MainText)
		obj.Search.PlaceholderColor3 = settings().Studio.Theme:GetColor(Enum.StudioStyleGuideColor.MainText)
		obj.Search.TextColor3 = settings().Studio.Theme:GetColor(Enum.StudioStyleGuideColor.MainText)
	end
	setColors()
	settings().Studio.ThemeChanged:Connect(setColors)
end

local function syncScrollingFrameColors(obj)
	local function setColors()
		obj.ScrollBarImageColor3 = settings().Studio.Theme:GetColor(Enum.StudioStyleGuideColor.MainText)
	end
	setColors()
	settings().Studio.ThemeChanged:Connect(setColors)
end

local function syncTextGuiColors(obj)
	local function setColors()
		obj.TextColor3 = settings().Studio.Theme:GetColor(Enum.StudioStyleGuideColor.MainText)
	end
	setColors()
	settings().Studio.ThemeChanged:Connect(setColors)
end

local function syncIconColors(Main)
	local function setColors()
		for i,v in pairs(Main:WaitForChild("InsertPage"):GetChildren()) do
		    if v:IsA("ImageLabel") then
				v.ImageColor3 = settings().Studio.Theme:GetColor(Enum.StudioStyleGuideColor.Tooltip)
				v.Icon.ImageColor3 = settings().Studio.Theme:GetColor(Enum.StudioStyleGuideColor.MainText)
			end
		end
	end
	setColors()
	settings().Studio.ThemeChanged:Connect(setColors)
end

--Modules
local navbarpages = require(gui:WaitForChild("Main"):WaitForChild("NavBarPages"))
local iconloader = require(gui:WaitForChild("Main"):WaitForChild("IconLoader"))
local smoothscroll = require(gui:WaitForChild("Main"):WaitForChild("SmoothScroll"))

--Insert Widget
local widgetInfo = DockWidgetPluginGuiInfo.new(
	Enum.InitialDockState.Float,  -- Widget will be initialized in floating panel
	false,   -- Widget will be initially enabled
	false,  -- Don't override the previous enabled state
	300,    -- Default width of the floating window
	262,    -- Default height of the floating window
	300,    -- Minimum width of the floating window (optional)
	262     -- Minimum height of the floating window (optional)
)

local InsertWidget = plugin:CreateDockWidgetPluginGui("Inserter", widgetInfo)
InsertWidget.Title = "Icon Inserter"

local frame = Instance.new("Frame",InsertWidget)
frame.Size = UDim2.new(5,0,5,0)

local Main = script.Core.Main
Main.Parent = InsertWidget
Main.Position = UDim2.new(0,0,0,0)

--Settings Widgets
local SettingsPage = Main:WaitForChild("SettingsPage")
local DefaultisScaleBool = Main:WaitForChild("DefaultisScaleBool")

local choices = {
	{Id = "scale", Text = "Scale"},
	{Id = "offset", Text = "Offset"}
}

local ScalingChoice = LabeledMultiChoice.new(
	"ScalingChoices",
	"Default Icon Scaling",
	choices,
	1 --Starting Choice
)

--Load Setting on Startup
DefaultisScaleBool.Value = plugin:GetSetting("DefaultisScale")
	if plugin:GetSetting("DefaultisScale") == true or plugin:GetSetting("DefaultisScale") == nil then
		ScalingChoice:SetSelectedIndex(1)
	else
		ScalingChoice:SetSelectedIndex(2)
	end


ScalingChoice:SetValueChangedFunction(function(newIndex)
	if choices[newIndex].Text == "Scale" then
		plugin:SetSetting("DefaultisScale", true)
		DefaultisScaleBool.Value = true
	else
		plugin:SetSetting("DefaultisScale", false)
		DefaultisScaleBool.Value = false
	end
	print("Default Icon Scaling set to: "..choices[newIndex].Text)
end)

ScalingChoice.Name = "A"
ScalingChoice:GetFrame().Parent = SettingsPage




--Sync Colors
syncGuiColors(frame)
syncIconColors(Main)
syncSearchBarColor(Main:WaitForChild("SearchBar"))

for i,v in pairs(Main:GetDescendants()) do
	if v:IsA("TextLabel") or v:IsA("TextButton") then
	   syncTextGuiColors(v)
	end
end

for i,v in pairs(Main:GetDescendants()) do
	if v:IsA("ScrollingFrame") then
	   syncScrollingFrameColors(v)
	end
end

--Widget Toggle
button.Click:connect(function()
	if InsertWidget.Enabled == false then
	InsertWidget.Enabled = true
	else
	InsertWidget.Enabled = false	
	end
end)


--Plugin Unloading
plugin.Unloading:Connect(function()
	InsertWidget:Destroy() --Refresh Widget
	button:Destroy()
	for i,v in pairs(script:GetDescendants()) do
	   v:Destroy()
	end
	script:Destroy()
end)