local Rayfield = loadstring(game:HttpGet(
'https://raw.githubusercontent.com/shlexware/Rayfield/main/source'
))()

local Players = game:GetService("Players")
local Lighting = game:GetService("Lighting")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local LocalPlayer = Players.LocalPlayer

-- SETTINGS

local Settings = {

	-- VISUAL
	ESP = true,
	ShowNames = true,
	ShowHealth = true,
	ShowDistance = true,
	Tracers = true,
	Chams = true,

	-- CAMERA
	SmoothCamera = true,
	FOVEnabled = true,
	FOV = 120,

	-- MISC
	InfiniteJump = true,
	FullBright = true
}

-- WINDOW

local Window = Rayfield:CreateWindow({
	Name = "DEV HUB",
	LoadingTitle = "Development Hub",
	LoadingSubtitle = "Roblox Studio",
	ConfigurationSaving = {
		Enabled = false
	},
	KeySystem = false
})

-- TABS

local CameraTab = Window:CreateTab("Camera",4483362458)
local VisualTab = Window:CreateTab("Visual",4483362458)
local MiscTab = Window:CreateTab("Misc",4483362458)

-- CAMERA

CameraTab:CreateToggle({
	Name = "Smooth Camera",
	CurrentValue = true,
	Callback = function(Value)
		Settings.SmoothCamera = Value
	end,
})

CameraTab:CreateSlider({
	Name = "FOV Radius",
	Range = {50,300},
	Increment = 5,
	CurrentValue = 120,
	Callback = function(Value)
		Settings.FOV = Value
	end,
})

-- VISUAL

VisualTab:CreateToggle({
	Name = "Enable ESP",
	CurrentValue = true,
	Callback = function(Value)
		Settings.ESP = Value
	end,
})

VisualTab:CreateToggle({
	Name = "Show Names",
	CurrentValue = true,
	Callback = function(Value)
		Settings.ShowNames = Value
	end,
})

VisualTab:CreateToggle({
	Name = "Show Health",
	CurrentValue = true,
	Callback = function(Value)
		Settings.ShowHealth = Value
	end,
})

VisualTab:CreateToggle({
	Name = "Show Distance",
	CurrentValue = true,
	Callback = function(Value)
		Settings.ShowDistance = Value
	end,
})

VisualTab:CreateToggle({
	Name = "Tracers",
	CurrentValue = true,
	Callback = function(Value)
		Settings.Tracers = Value
	end,
})

VisualTab:CreateToggle({
	Name = "Chams",
	CurrentValue = true,
	Callback = function(Value)
		Settings.Chams = Value
	end,
})

-- MISC

MiscTab:CreateToggle({
	Name = "Infinite Jump",
	CurrentValue = true,
	Callback = function(Value)
		Settings.InfiniteJump = Value
	end,
})

MiscTab:CreateToggle({
	Name = "FullBright",
	CurrentValue = true,
	Callback = function(Value)

		Settings.FullBright = Value

		if Value then
			Lighting.Brightness = 5
			Lighting.ClockTime = 14
			Lighting.FogEnd = 100000
		else
			Lighting.Brightness = 2
		end
	end,
})

-- FULLBRIGHT INIT

Lighting.Brightness = 5
Lighting.ClockTime = 14
Lighting.FogEnd = 100000

-- INFINITE JUMP

UIS.JumpRequest:Connect(function()

	if Settings.InfiniteJump then

		local Character = LocalPlayer.Character

		if Character then

			local Humanoid =
				Character:FindFirstChildOfClass("Humanoid")

			if Humanoid then
				Humanoid:ChangeState("Jumping")
			end
		end
	end
end)

-- ESP SYSTEM

local ESPCache = {}

local function CreateESP(Player)

	if ESPCache[Player] then
		return
	end

	local Character = Player.Character
	if not Character then
		return
	end

	local HRP = Character:FindFirstChild("HumanoidRootPart")
	local Humanoid = Character:FindFirstChildOfClass("Humanoid")

	if not HRP then
		return
	end

	-- HIGHLIGHT

	local Highlight = Instance.new("Highlight")
	Highlight.FillColor = Color3.fromRGB(255,0,0)
	Highlight.OutlineColor = Color3.new(1,1,1)
	Highlight.FillTransparency = 0.4
	Highlight.Parent = Character

	-- BILLBOARD

	local Billboard = Instance.new("BillboardGui")
	Billboard.Size = UDim2.new(0,200,0,50)
	Billboard.AlwaysOnTop = true
	Billboard.StudsOffset = Vector3.new(0,3,0)
	Billboard.Parent = HRP

	local Text = Instance.new("TextLabel")
	Text.Size = UDim2.new(1,0,1,0)
	Text.BackgroundTransparency = 1
	Text.TextColor3 = Color3.new(1,1,1)
	Text.TextStrokeTransparency = 0
	Text.TextScaled = true
	Text.Parent = Billboard

	ESPCache[Player] = {
		Highlight = Highlight,
		Text = Text,
		Humanoid = Humanoid
	}
end

RunService.RenderStepped:Connect(function()

	if Settings.ESP then

		for _,Player in pairs(Players:GetPlayers()) do

			if Player ~= LocalPlayer and Player.Character then

				CreateESP(Player)

				local HRP =
					Player.Character:FindFirstChild(
						"HumanoidRootPart"
					)

				local Data = ESPCache[Player]

				if HRP and Data then

					local Distance = math.floor(
						(HRP.Position -
						LocalPlayer.Character.HumanoidRootPart.Position
						).Magnitude
					)

					local String = ""

					if Settings.ShowNames then
						String = Player.Name
					end

					if Settings.ShowHealth and Data.Humanoid then
						String = String ..
						"\nHP: " ..
						math.floor(Data.Humanoid.Health)
					end

					if Settings.ShowDistance then
						String = String ..
						"\n["..Distance.."m]"
					end

					Data.Text.Text = String

					if Settings.Chams then
						Data.Highlight.FillTransparency = 0.4
					else
						Data.Highlight.FillTransparency = 1
					end
				end
			end
		end
	else

		for _,Data in pairs(ESPCache) do

			if Data.Highlight then
				Data.Highlight:Destroy()
			end

			if Data.Text then
				Data.Text.Parent:Destroy()
			end
		end

		table.clear(ESPCache)
	end
end)

Rayfield:Notify({
	Title = "DEV HUB",
	Content = "Sistema carregado.",
	Duration = 5,
	Image = 4483362458,
})
