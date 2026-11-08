-- ==========================================
-- SCRIPT: ZOPTYMALIZOWANY I UKRYTY (UNDETECTED BASE)
-- Klawisz otwierania/zamykania: RightShift
-- ==========================================

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Lighting = game:GetService("Lighting")
local CoreGui = game:GetService("CoreGui")
local Camera = workspace.CurrentCamera

local player = Players.LocalPlayer

-- Bezpieczne pobranie ukrytego kontenera GUI (wspierane przez nowoczesne executory)
local guiParent = nil
local success, err = pcall(function()
	if gethui then
		guiParent = gethui()
	elseif CoreGui then
		guiParent = CoreGui
	else
		guiParent = player:WaitForChild("PlayerGui")
	end
end)
if not success or not guiParent then
	guiParent = player:WaitForChild("PlayerGui")
end

-- Usunięcie poprzedniej instancji, jeśli istnieje
local existingGui = guiParent:FindFirstChild("PanelAdmina_Secure")
if existingGui then
	existingGui:Destroy()
end

-- ====== KOLORY ======
local BG = Color3.fromRGB(18, 18, 22)
local SIDEBAR = Color3.fromRGB(23, 23, 28)
local CARD = Color3.fromRGB(28, 28, 34)
local ACCENT = Color3.fromRGB(59, 110, 246)
local TEXT = Color3.fromRGB(235, 235, 240)
local MUTED = Color3.fromRGB(135, 135, 148)
local OFF = Color3.fromRGB(58, 58, 68)

local state = { god = false, walk = 1, infJump = false, noclip = false }

local function new(class, props, parent)
	local o = Instance.new(class)
	for k, v in pairs(props) do
		o[k] = v
	end
	o.Parent = parent
	return o
end

local function corner(o, r)
	new("UICorner", { CornerRadius = UDim.new(0, r) }, o)
end

local function humanoid()
	local c = player.Character
	return c and c:FindFirstChildOfClass("Humanoid")
end

local gui = new("ScreenGui", { Name = "PanelAdmina_Secure", ResetOnSpawn = false, DisplayOrder = 999999 }, guiParent)

local window = new("Frame", {
	Size = UDim2.fromOffset(720, 440),
	Position = UDim2.fromScale(0.5, 0.5),
	AnchorPoint = Vector2.new(0.5, 0.5),
	BackgroundColor3 = BG,
	BorderSizePixel = 0,
}, gui)
corner(window, 10)

local sidebar = new("Frame", {
	Size = UDim2.new(0, 160, 1, 0),
	BackgroundColor3 = SIDEBAR,
	BorderSizePixel = 0,
}, window)
corner(sidebar, 10)

new("TextLabel", {
	Size = UDim2.new(1, 0, 0, 56),
	BackgroundTransparency = 1,
	Text = "MÓJ PANEL",
	Font = Enum.Font.GothamBlack,
	TextSize = 18,
	TextColor3 = TEXT,
}, sidebar)

local tabList = new("Frame", {
	Size = UDim2.new(1, -16, 1, -70),
	Position = UDim2.fromOffset(8, 62),
	BackgroundTransparency = 1,
}, sidebar)
new("UIListLayout", { Padding = UDim.new(0, 4) }, tabList)

local dragBar = new("Frame", {
	Size = UDim2.new(1, -160, 0, 28),
	Position = UDim2.fromOffset(160, 0),
	BackgroundTransparency = 1,
}, window)

new("TextLabel", {
	Size = UDim2.new(1, -12, 1, 0),
	BackgroundTransparency = 1,
	Text = "RightShift - pokaż / ukryj",
	Font = Enum.Font.Gotham,
	TextSize = 11,
	TextColor3 = MUTED,
	TextXAlignment = Enum.TextXAlignment.Right,
}, dragBar)

do
	local dragging, startMouse, startPos
	dragBar.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			dragging = true
			startMouse = input.Position
			startPos = window.Position
		end
	end)
	UIS.InputChanged:Connect(function(input)
		if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
			local d = input.Position - startMouse
			window.Position = UDim2.new(
				startPos.X.Scale, startPos.X.Offset + d.X,
				startPos.Y.Scale, startPos.Y.Offset + d.Y
			)
		end
	end)
	UIS.InputEnded:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			dragging = false
		end
	end)
end

local pages, tabs = {}, {}

local function selectTab(name)
	for n, page in pairs(pages) do
		page.Visible = (n == name)
	end
	for n, btn in pairs(tabs) do
		local active = (n == name)
		btn.BackgroundTransparency = active and 0 or 1
		btn.TextColor3 = active and TEXT or MUTED
	end
end

local function addPage(name)
	local page = new("ScrollingFrame", {
		Size = UDim2.new(1, -176, 1, -40),
		Position = UDim2.fromOffset(168, 32),
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		ScrollBarThickness = 3,
		ScrollBarImageColor3 = OFF,
		CanvasSize = UDim2.new(),
		AutomaticCanvasSize = Enum.AutomaticSize.Y,
		Visible = false,
	}, window)
	new("UIListLayout", { Padding = UDim.new(0, 6) }, page)

	local btn = new("TextButton", {
		Size = UDim2.new(1, 0, 0, 32),
		BackgroundColor3 = CARD,
		BackgroundTransparency = 1,
		Text = "    " .. name,
		Font = Enum.Font.GothamMedium,
		TextSize = 14,
		TextColor3 = MUTED,
		TextXAlignment = Enum.TextXAlignment.Left,
		AutoButtonColor = false,
	}, tabList)
	corner(btn, 6)
	btn.MouseButton1Click:Connect(function()
		selectTab(name)
	end)

	pages[name] = page
	tabs[name] = btn
	return page
end

local function addSection(page, title)
	new("TextLabel", {
		Size = UDim2.new(1, -8, 0, 22),
		BackgroundTransparency = 1,
		Text = string.upper(title),
		Font = Enum.Font.GothamBold,
		TextSize = 11,
		TextColor3 = MUTED,
		TextXAlignment = Enum.TextXAlignment.Left,
	}, page)

	local card = new("Frame", {
		Size = UDim2.new(1, -8, 0, 0),
		AutomaticSize = Enum.AutomaticSize.Y,
		BackgroundColor3 = CARD,
		BorderSizePixel = 0,
	}, page)
	corner(card, 8)
	new("UIListLayout", { Padding = UDim.new(0, 2) }, card)
	new("UIPadding", {
		PaddingLeft = UDim.new(0, 12), PaddingRight = UDim.new(0, 12),
		PaddingTop = UDim.new(0, 6), PaddingBottom = UDim.new(0, 6),
	}, card)
	return card
end

local function addToggle(card, title, desc, default, callback)
	local row = new("Frame", {
		Size = UDim2.new(1, 0, 0, desc and 44 or 34),
		BackgroundTransparency = 1,
	}, card)

	new("TextLabel", {
		Size = UDim2.new(1, -60, 0, desc and 22 or 34),
		Position = UDim2.fromOffset(0, desc and 2 or 0),
		BackgroundTransparency = 1,
		Text = title,
		Font = Enum.Font.GothamMedium,
		TextSize = 14,
		TextColor3 = TEXT,
		TextXAlignment = Enum.TextXAlignment.Left,
	}, row)

	if desc then
		new("TextLabel", {
			Size = UDim2.new(1, -60, 0, 16),
			Position = UDim2.fromOffset(0, 22),
			BackgroundTransparency = 1,
			Text = desc,
			Font = Enum.Font.Gotham,
			TextSize = 12,
			TextColor3 = MUTED,
			TextXAlignment = Enum.TextXAlignment.Left,
		}, row)
	end

	local sw = new("TextButton", {
		Size = UDim2.fromOffset(40, 20),
		Position = UDim2.new(1, -40, 0.5, -10),
		BackgroundColor3 = OFF,
		Text = "",
		AutoButtonColor = false,
	}, row)
	corner(sw, 10)

	local knob = new("Frame", {
		Size = UDim2.fromOffset(16, 16),
		Position = UDim2.fromOffset(2, 2),
		BackgroundColor3 = Color3.new(1, 1, 1),
	}, sw)
	corner(knob, 8)

	local on = default
	local function render()
		TweenService:Create(sw, TweenInfo.new(0.15), { BackgroundColor3 = on and ACCENT or OFF }):Play()
		TweenService:Create(knob, TweenInfo.new(0.15), {
			Position = on and UDim2.fromOffset(22, 2) or UDim2.fromOffset(2, 2),
		}):Play()
	end
	render()
	callback(on)

	sw.MouseButton1Click:Connect(function()
		on = not on
		render()
		callback(on)
	end)
end

local function addSlider(card, title, min, max, default, prefix, callback)
	local row = new("Frame", { Size = UDim2.new(1, 0, 0, 46), BackgroundTransparency = 1 }, card)

	new("TextLabel", {
		Size = UDim2.new(1, -60, 0, 24),
		BackgroundTransparency = 1,
		Text = title,
		Font = Enum.Font.GothamMedium,
		TextSize = 14,
		TextColor3 = TEXT,
		TextXAlignment = Enum.TextXAlignment.Left,
	}, row)

	local valueLabel = new("TextLabel", {
		Size = UDim2.fromOffset(60, 24),
		Position = UDim2.new(1, -60, 0, 0),
		BackgroundTransparency = 1,
		Font = Enum.Font.GothamBold,
		TextSize = 13,
		TextColor3 = TEXT,
		TextXAlignment = Enum.TextXAlignment.Right,
	}, row)

	local hit = new("TextButton", {
		Size = UDim2.new(1, 0, 0, 20),
		Position = UDim2.fromOffset(0, 26),
		BackgroundTransparency = 1,
		Text = "",
	}, row)

	local track = new("Frame", {
		Size = UDim2.new(1, 0, 0, 4),
		Position = UDim2.new(0, 0, 0.5, -2),
		BackgroundColor3 = OFF,
		BorderSizePixel = 0,
	}, hit)
	corner(track, 2)

	local fill = new("Frame", { BackgroundColor3 = ACCENT, BorderSizePixel = 0 }, track)
	corner(fill, 2)

	local knob = new("Frame", {
		Size = UDim2.fromOffset(14, 14),
		AnchorPoint = Vector2.new(0.5, 0.5),
		BackgroundColor3 = Color3.new(1, 1, 1),
	}, track)
	corner(knob, 7)

	local function setAlpha(alpha)
		alpha = math.clamp(alpha, 0, 1)
		local value = math.floor((min + (max - min) * alpha) * 10 + 0.5) / 10
		fill.Size = UDim2.fromScale(alpha, 1)
		knob.Position = UDim2.fromScale(alpha, 0.5)
		valueLabel.Text = prefix .. tostring(value)
		callback(value)
	end

	local function fromX(x)
		setAlpha((x - track.AbsolutePosition.X) / track.AbsoluteSize.X)
	end

	setAlpha((default - min) / (max - min))

	local dragging = false
	hit.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			dragging = true
			fromX(input.Position.X)
		end
	end)
	UIS.InputChanged:Connect(function(input)
		if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
			fromX(input.Position.X)
		end
	end)
	UIS.InputEnded:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			dragging = false
		end
	end)
end

local function addButtons(card, list)
	local row = new("Frame", { Size = UDim2.new(1, 0, 0, 38), BackgroundTransparency = 1 }, card)
	new("UIListLayout", {
		FillDirection = Enum.FillDirection.Horizontal,
		Padding = UDim.new(0, 8),
		VerticalAlignment = Enum.VerticalAlignment.Center,
	}, row)

	for _, item in ipairs(list) do
		local btn = new("TextButton", {
			Size = UDim2.fromOffset(120, 28),
			BackgroundColor3 = Color3.fromRGB(38, 38, 48),
			Text = item[1],
			Font = Enum.Font.GothamMedium,
			TextSize = 12,
			TextColor3 = TEXT,
			AutoButtonColor = false,
		}, row)
		corner(btn, 6)
		btn.MouseEnter:Connect(function()
			TweenService:Create(btn, TweenInfo.new(0.12), { BackgroundColor3 = ACCENT }):Play()
		end)
		btn.MouseLeave:Connect(function()
			TweenService:Create(btn, TweenInfo.new(0.12), { BackgroundColor3 = Color3.fromRGB(38, 38, 48) }):Play()
		end)
		btn.MouseButton1Click:Connect(item[2])
	end
end

-- ====== STRONA: COMBAT (Płynny Aim z interpolacją) ======
local combat = addPage("Combat")
local combatSec = addSection(combat, "Aim Assist & FOV")

local aimEnabled = false
local fovRadius = 120
local smoothness = 5 -- Im wyżej, tym płynniejszy ruch

local fovCircle = new("Frame", {
	AnchorPoint = Vector2.new(0.5, 0.5),
	BackgroundColor3 = Color3.fromRGB(255, 255, 255),
	BackgroundTransparency = 1,
	BorderSizePixel = 0,
	Visible = false,
}, gui)

new("UIStroke", {
	Color = ACCENT,
	Thickness = 1.5,
	Transparency = 0.3,
}, fovCircle)
corner(fovCircle, 1000)

addToggle(combatSec, "Płynny Aim Assist", "Delikatnie koryguje cel wewnątrz FOV", false, function(on)
	aimEnabled = on
	fovCircle.Visible = on
end)

addSlider(combatSec, "Rozmiar FOV", 50, 300, 120, "px ", function(v)
	fovRadius = v
	fovCircle.Size = UDim2.fromOffset(v * 2, v * 2)
end)

RunService.RenderStepped:Connect(function(dt)
	local mousePos = UIS:GetMouseLocation()
	fovCircle.Position = UDim2.fromOffset(mousePos.X, mousePos.Y)

	if aimEnabled then
		local closestPart = nil
		local shortestDistance = fovRadius

		for _, plr in ipairs(Players:GetPlayers()) do
			if plr ~= player and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
				local hum = plr.Character:FindFirstChildOfClass("Humanoid")
				if hum and hum.Health > 0 then
					local targetPart = plr.Character:FindFirstChild("Head") or plr.Character.HumanoidRootPart
					local screenPoint, onScreen = Camera:WorldToViewportPoint(targetPart.Position)

					if onScreen then
						local screenPos = Vector2.new(screenPoint.X, screenPoint.Y)
						local distance = (screenPos - mousePos).Magnitude

						if distance < shortestDistance then
							shortestDistance = distance
							closestPart = targetPart
						end
					end
				end
			end
		end

		if closestPart then
			-- Płynne przejście kamery (Slerp) zmniejsza szansę na wykrycie przez anty-cheat ruchowy
			local targetCFrame = CFrame.new(Camera.CFrame.Position, closestPart.Position)
			Camera.CFrame = Camera.CFrame:Lerp(targetCFrame, math.clamp(dt * smoothness, 0.05, 1))
		end
	end
end)

-- ====== STRONA: STATYSTYKI ======
local stats = addPage("Statystyki")

local zdrowie = addSection(stats, "Zdrowie")
addToggle(zdrowie, "Nieśmiertelność", nil, false, function(on)
	state.god = on
end)

local ruch = addSection(stats, "Ruch")
addToggle(ruch, "Nieskończona stamina", nil, false, function(on)
	player:SetAttribute("InfiniteStamina", on)
end)
addSlider(ruch, "Szybkość chodzenia", 1, 5, 1, "x", function(v)
	state.walk = v
	local hum = humanoid()
	if hum then
		hum.WalkSpeed = 16 * v
	end
end)
addToggle(ruch, "Nieskończone skoki", "Skacz w powietrzu", false, function(on)
	state.infJump = on
end)

local noclipOryginaly = {}
addToggle(ruch, "Noclip", "Przenikanie przez ściany", false, function(on)
	state.noclip = on
	if not on then
		for part, wartosc in pairs(noclipOryginaly) do
			if part and part.Parent then
				part.CanCollide = wartosc
			end
		end
		table.clear(noclipOryginaly)
	end
end)

local akcje = addSection(stats, "Szybkie akcje")
addButtons(akcje, {
	{ "Ulecz się", function()
		local hum = humanoid()
		if hum then hum.Health = hum.MaxHealth end
	end },
	{ "Zresetuj postać", function()
		local hum = humanoid()
		if hum then hum.Health = 0 end
	end },
})

-- ====== STRONA: WIZJA (ESP) ======
local wizja = addPage("Wizja")
local swiatlo = addSection(wizja, "Oświetlenie")
local oryginalnaJasnosc = Lighting.Brightness
addToggle(swiatlo, "Pełna jasność", "Rozjaśnia całą mapę", false, function(on)
	Lighting.Brightness = on and 3 or oryginalnaJasnosc
end)

local esp = addSection(wizja, "ESP")
local espWlaczone = false
local espObiekty = {}

local function usunEsp(plr)
	if espObiekty[plr] then
		if espObiekty[plr].highlight then espObiekty[plr].highlight:Destroy() end
		espObiekty[plr] = nil
	end
end

local function odswiezEsp()
	for _, plr in ipairs(Players:GetPlayers()) do
		if plr ~= player then
			local char = plr.Character
			if char then
				local o = espObiekty[plr] or {}
				espObiekty[plr] = o
				if not o.highlight or o.highlight.Parent ~= char then
					if o.highlight then o.highlight:Destroy() end
					o.highlight = new("Highlight", {
						DepthMode = Enum.HighlightDepthMode.AlwaysOnTop,
						FillTransparency = 0.8,
						OutlineTransparency = 0.2,
						FillColor = ACCENT,
						OutlineColor = ACCENT,
					}, char)
				end
			else
				usunEsp(plr)
			end
		end
	end
end

addToggle(esp, "Podświetl graczy", "Subtelne ESP", false, function(on)
	espWlaczone = on
	if not on then
		for plr in pairs(espObiekty) do usunEsp(plr) end
	end
end)

task.spawn(function()
	while gui.Parent do
		if espWlaczone then
			odswiezEsp()
		end
		task.wait(0.5)
	end
end)

-- ====== Pętla logiki w tle ======
RunService.Heartbeat:Connect(function()
	if state.god then
		local hum = humanoid()
		if hum and hum.Health < hum.MaxHealth then
			hum.Health = hum.MaxHealth
		end
	end
end)

RunService.Stepped:Connect(function()
	if state.noclip then
		local char = player.Character
		if char then
			for _, part in ipairs(char:GetDescendants()) do
				if part:IsA("BasePart") then
					if noclipOryginaly[part] == nil then
						noclipOryginaly[part] = part.CanCollide
					end
					part.CanCollide = false
				end
			end
		end
	end
end)

UIS.JumpRequest:Connect(function()
	if state.infJump then
		local hum = humanoid()
		if hum then hum:ChangeState(Enum.HumanoidStateType.Jumping) end
	end
end)

UIS.InputBegan:Connect(function(input, gp)
	if not gp and input.KeyCode == Enum.KeyCode.RightShift then
		gui.Enabled = not gui.Enabled
	end
end)

selectTab("Combat")
