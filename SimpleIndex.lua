--[[
  ______   __                          __                  ______                  __                     
 /      \ |  \                        |  \                |      \                |  \                    
|  $$$$$$\ \$$ ______ ____    ______  | $$  ______         \$$$$$$ _______    ____| $$  ______   __    __ 
| $$___\$$|  \|      \    \  /      \ | $$ /      \         | $$  |       \  /      $$ /      \ |  \  /  \
 \$$    \ | $$| $$$$$$\$$$$\|  $$$$$$\| $$|  $$$$$$\        | $$  | $$$$$$$\|  $$$$$$$|  $$$$$$\ \$$\/  $$
 _\$$$$$$\| $$| $$ | $$ | $$| $$  | $$| $$| $$    $$        | $$  | $$  | $$| $$  | $$| $$    $$  >$$  $$ 
|  \__| $$| $$| $$ | $$ | $$| $$__/ $$| $$| $$$$$$$$       _| $$_ | $$  | $$| $$__| $$| $$$$$$$$ /  $$$$\ 
 \$$    $$| $$| $$ | $$ | $$| $$    $$| $$ \$$     \      |   $$ \| $$  | $$ \$$    $$ \$$     \|  $$ \$$\
  \$$$$$$  \$$ \$$  \$$  \$$| $$$$$$$  \$$  \$$$$$$$       \$$$$$$ \$$   \$$  \$$$$$$$  \$$$$$$$ \$$   \$$
                            | $$                                                                          
                            | $$                                                                          
                             \$$                                                                          
--]]

local UIS = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local PlayerGui = game.Players.LocalPlayer:WaitForChild("PlayerGui")

--// === GUI CREATION ===
local MainCommandBar = Instance.new("ScreenGui")
MainCommandBar.Name = "MainCommandBar"
MainCommandBar.Parent = PlayerGui
MainCommandBar.ZIndexBehavior = Enum.ZIndexBehavior.Global
MainCommandBar.ResetOnSpawn = false

-- Base Frame
local Main = Instance.new("Frame")
Main.Name = "Main"
Main.Parent = MainCommandBar
Main.AnchorPoint = Vector2.new(0.5, 0)
Main.Position = UDim2.new(0.5, 0, 0.06, 0)
Main.Size = UDim2.new(0.5, 0, 0.1, 0) -- fixed size
Main.BackgroundColor3 = Color3.fromRGB(37, 39, 49)
Main.BorderSizePixel = 0
Main.ZIndex = 4

-- Rounded + gradient border
local UICorner = Instance.new("UICorner", Main)
UICorner.CornerRadius = UDim.new(0, 8)

local UIStroke = Instance.new("UIStroke", Main)
UIStroke.Thickness = 4
UIStroke.Transparency = 0
UIStroke.Color = Color3.new(1, 1, 1)

local UIGradient = Instance.new("UIGradient", UIStroke)
UIGradient.Color = ColorSequence.new({
	ColorSequenceKeypoint.new(0, Color3.fromRGB(206, 104, 150)),
	ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 164, 164))
})

-- Modular shadows (no scaling)
local function makeShadow(name, posY, sizeOffset, transparency, zindex)
	local img = Instance.new("ImageLabel")
	img.Name = name
	img.Parent = MainCommandBar -- keep separate from Main
	img.AnchorPoint = Vector2.new(0.5, 0.5)
	img.BackgroundTransparency = 1
	img.Position = UDim2.new(0.5, 0, 0.1, posY)
	img.Size = UDim2.new(0.51, 0, 0.12, 0)
	img.ZIndex = zindex
	img.Image = "rbxassetid://1316045217"
	img.ImageColor3 = Color3.fromRGB(0, 0, 0)
	img.ImageTransparency = transparency
	img.ScaleType = Enum.ScaleType.Slice
	img.SliceCenter = Rect.new(10, 10, 118, 118)
	return img
end

local UmbraShadow = makeShadow("UmbraShadow", 6, 10, 0.86, 1)
local PenumbraShadow = makeShadow("PenumbraShadow", 1, 18, 0.88, 2)
local AmbientShadow = makeShadow("AmbientShadow", 3, 5, 0.8, 3)

-- TextBox
local TextBox = Instance.new("TextBox", Main)
TextBox.AnchorPoint = Vector2.new(0.5, 0)
TextBox.BackgroundTransparency = 1
TextBox.Position = UDim2.new(0.5, 0, 0, 0)
TextBox.Size = UDim2.new(0.96, 0, 1, 0)
TextBox.Font = Enum.Font.GothamMedium
TextBox.PlaceholderColor3 = Color3.fromRGB(173, 167, 197)
TextBox.PlaceholderText = "Type Command"
TextBox.Text = ""
TextBox.TextColor3 = Color3.fromRGB(230, 197, 241)
TextBox.TextScaled = true
TextBox.TextXAlignment = Enum.TextXAlignment.Left
TextBox.ZIndex = 5


-- Initial state
Main.Visible = false
Main.BackgroundTransparency = 1
TextBox.TextTransparency = 1
UIStroke.Thickness = 0
UmbraShadow.ImageTransparency = 1
PenumbraShadow.ImageTransparency = 1
AmbientShadow.ImageTransparency = 1

-- Animation
local isOpen = false
local tweenInfo = TweenInfo.new(1, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)
local floatOffset = -0.04
local finalY = 0.05

local isAnimating = false
local closeTween -- store reference so we can cancel

local function openBar()
	if isAnimating then return end
	isOpen = true
	Main.Visible = true
	Main.Position = UDim2.new(0.5, 0, finalY + floatOffset, 0)

	-- If a close tween was running, cancel it
	if closeTween then
		closeTween:Cancel()
		closeTween = nil
	end

	local tweens = {
		TweenService:Create(Main, tweenInfo, {
			Position = UDim2.new(0.5, 0, finalY, 0),
			BackgroundTransparency = 0
		}),
		TweenService:Create(TextBox, tweenInfo, { TextTransparency = 0 }),
		TweenService:Create(UIStroke, tweenInfo, { Thickness = 4, Transparency = 0 }),
		TweenService:Create(UmbraShadow, tweenInfo, { ImageTransparency = 0.86 }),
		TweenService:Create(PenumbraShadow, tweenInfo, { ImageTransparency = 0.88 }),
		TweenService:Create(AmbientShadow, tweenInfo, { ImageTransparency = 0.8 }),
	}

	isAnimating = true
	for _, t in ipairs(tweens) do t:Play() end
	task.delay(tweenInfo.Time, function()
		isAnimating = false
	end)

	TextBox.Text = ""
	TextBox:CaptureFocus()
end


local function closeBar()
	if isAnimating then return end
	isOpen = false
	TextBox.Text = ""

	local tweens = {
		TweenService:Create(Main, tweenInfo, {
			Position = UDim2.new(0.5, 0, finalY + floatOffset, 0),
			BackgroundTransparency = 1
		}),
		TweenService:Create(TextBox, tweenInfo, { TextTransparency = 1 }),
		TweenService:Create(UIStroke, tweenInfo, { Thickness = 0, Transparency = 1 }),
		TweenService:Create(UmbraShadow, tweenInfo, { ImageTransparency = 1 }),
		TweenService:Create(PenumbraShadow, tweenInfo, { ImageTransparency = 1 }),
		TweenService:Create(AmbientShadow, tweenInfo, { ImageTransparency = 1 }),
	}

	isAnimating = true
	for _, t in ipairs(tweens) do t:Play() end

	closeTween = task.delay(tweenInfo.Time, function()
		if not isOpen then
			Main.Visible = false
		end
		isAnimating = false
		closeTween = nil
	end)
end


-- Toggle
UIS.InputBegan:Connect(function(input, gpe)
	if gpe then return end
	if input.KeyCode == Enum.KeyCode.Minus then
		if isOpen then closeBar() else openBar() end
	end
end)


-- ALERT SETUP -----------------------------------------------------
local notificationQueue = {}
local isShowingNotification = false

local function Notify(alertText, messageText, displayTime)
	displayTime = displayTime or 3

	-- Add this notification to the queue
	table.insert(notificationQueue, {alertText, messageText, displayTime})

	-- If a notification is already showing, just return
	if isShowingNotification then return end

	-- Process the queue
	task.spawn(function()
		while #notificationQueue > 0 do
			isShowingNotification = true
			local current = table.remove(notificationQueue, 1)
			local alertText, messageText, displayTime = unpack(current)

			-- Create ScreenGui
			local Alert = Instance.new("ScreenGui")
			Alert.Name = "Alert"
			Alert.Parent = PlayerGui
			Alert.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

			-- Shadow Frame
			local Shadow = Instance.new("Frame")
			Shadow.Name = "Shadow"
			Shadow.Parent = Alert
			Shadow.AnchorPoint = Vector2.new(0.5, 0.899)
			Shadow.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			Shadow.BackgroundTransparency = 1
			Shadow.BorderSizePixel = 0
			Shadow.Position = UDim2.new(0.5, 0, 1, 0)
			Shadow.Size = UDim2.new(0.325, 0, 0.2, 0)
			Shadow.ZIndex = 0
			local UICorner = Instance.new("UICorner", Shadow)
			UICorner.CornerRadius = UDim.new(0, 10)

			local UmbraShadow = Instance.new("ImageLabel")
			UmbraShadow.Name = "UmbraShadow"
			UmbraShadow.Parent = Shadow
			UmbraShadow.AnchorPoint = Vector2.new(0.5, 0.5)
			UmbraShadow.BackgroundTransparency = 1
			UmbraShadow.Position = UDim2.new(0.5, 0, 0.5, 6)
			UmbraShadow.Size = UDim2.new(1, 10, 1, 10)
			UmbraShadow.ZIndex = 0
			UmbraShadow.Image = "rbxassetid://1316045217"
			UmbraShadow.ImageColor3 = Color3.fromRGB(0,0,0)
			UmbraShadow.ImageTransparency = 0.86
			UmbraShadow.ScaleType = Enum.ScaleType.Slice
			UmbraShadow.SliceCenter = Rect.new(10,10,118,118)

			local PenumbraShadow = UmbraShadow:Clone()
			PenumbraShadow.Name = "PenumbraShadow"
			PenumbraShadow.Position = UDim2.new(0.5, 0, 0.5, 1)
			PenumbraShadow.Size = UDim2.new(1,18,1,18)
			PenumbraShadow.ImageTransparency = 0.88
			PenumbraShadow.Parent = Shadow

			local AmbientShadow = UmbraShadow:Clone()
			AmbientShadow.Name = "AmbientShadow"
			AmbientShadow.Position = UDim2.new(0.5, 0, 0.5, 3)
			AmbientShadow.Size = UDim2.new(1,5,1,5)
			AmbientShadow.ImageTransparency = 0.8
			AmbientShadow.Parent = Shadow

			-- Main frame
			local Main = Instance.new("Frame")
			Main.Name = "Main"
			Main.Parent = Alert
			Main.AnchorPoint = Vector2.new(0.5, 0.899)
			Main.BackgroundColor3 = Color3.fromRGB(37,39,49)
			Main.BorderSizePixel = 0
			Main.Position = UDim2.new(0.5, 0, 1, 0)
			Main.Size = UDim2.new(0.325, 0, 0.2, 0)
			Main.ZIndex = 3
			local UICorner2 = Instance.new("UICorner", Main)
			UICorner2.CornerRadius = UDim.new(0,6)

			-- Alert Text
			local AlertMessage = Instance.new("TextLabel")
			AlertMessage.Name = "AlertMessage"
			AlertMessage.Parent = Main
			AlertMessage.BackgroundTransparency = 1
			AlertMessage.Size = UDim2.new(1,0,0.4,0)
			AlertMessage.Font = Enum.Font.SourceSans
			AlertMessage.Text = alertText or "Error"
			AlertMessage.TextColor3 = Color3.fromRGB(241,191,198)
			AlertMessage.TextScaled = true
			AlertMessage.TextWrapped = true

			-- Message Text
			local Message = Instance.new("TextLabel")
			Message.Name = "Message"
			Message.Parent = Main
			Message.AnchorPoint = Vector2.new(0.5, 1)
			Message.BackgroundTransparency = 1
			Message.Position = UDim2.new(0.5,0,1,0)
			Message.Size = UDim2.new(0.98,0,0.6,0)
			Message.Font = Enum.Font.SourceSans
			Message.Text = messageText or "Something went wrong."
			Message.TextColor3 = Color3.fromRGB(230,197,241)
			Message.TextScaled = true
			Message.TextWrapped = true
			Message.TextXAlignment = Enum.TextXAlignment.Center
			Message.TextYAlignment = Enum.TextYAlignment.Top

			-- Stroke + gradient
			local UIStroke = Instance.new("UIStroke", Main)
			UIStroke.Thickness = 4
			UIStroke.Transparency = 1
			UIStroke.Color = Color3.new(1,1,1)
			local UIGradient = Instance.new("UIGradient", UIStroke)
			UIGradient.Color = ColorSequence.new({
				ColorSequenceKeypoint.new(0, Color3.fromRGB(206,104,150)),
				ColorSequenceKeypoint.new(1, Color3.fromRGB(255,164,164))
			})

			-- Tween animation
			local startY, finalY = 1, 0.9
			Main.Position = UDim2.new(0.5,0,startY,0)
			Shadow.Position = UDim2.new(0.5,0,startY,0)
			Main.BackgroundTransparency = 1
			Shadow.BackgroundTransparency = 1
			UmbraShadow.ImageTransparency = 1
			PenumbraShadow.ImageTransparency = 1
			AmbientShadow.ImageTransparency = 1
			UIStroke.Transparency = 1
			AlertMessage.TextTransparency = 1
			Message.TextTransparency = 1

			local tweenInfo = TweenInfo.new(2, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)
			local tweens = {
				TweenService:Create(Main, tweenInfo, { Position = UDim2.new(0.5,0,finalY,0), BackgroundTransparency = 0 }),
				TweenService:Create(Shadow, tweenInfo, { Position = UDim2.new(0.5,0,finalY,0), BackgroundTransparency = 0 }),
				TweenService:Create(UmbraShadow, tweenInfo, { ImageTransparency = 0.86 }),
				TweenService:Create(PenumbraShadow, tweenInfo, { ImageTransparency = 0.88 }),
				TweenService:Create(AmbientShadow, tweenInfo, { ImageTransparency = 0.8 }),
				TweenService:Create(UIStroke, tweenInfo, { Transparency = 0 }),
				TweenService:Create(AlertMessage, tweenInfo, { TextTransparency = 0 }),
				TweenService:Create(Message, tweenInfo, { TextTransparency = 0 })
			}
			for _, t in ipairs(tweens) do t:Play() end

			-- Wait for display time before hiding
			task.wait(displayTime)

			local hideTweens = {
				TweenService:Create(Main, tweenInfo, { BackgroundTransparency = 1, Position = UDim2.new(0.5,0,startY,0) }),
				TweenService:Create(Shadow, tweenInfo, { BackgroundTransparency = 1, Position = UDim2.new(0.5,0,startY,0) }),
				TweenService:Create(UmbraShadow, tweenInfo, { ImageTransparency = 1 }),
				TweenService:Create(PenumbraShadow, tweenInfo, { ImageTransparency = 1 }),
				TweenService:Create(AmbientShadow, tweenInfo, { ImageTransparency = 1 }),
				TweenService:Create(UIStroke, tweenInfo, { Transparency = 1 }),
				TweenService:Create(AlertMessage, tweenInfo, { TextTransparency = 1 }),
				TweenService:Create(Message, tweenInfo, { TextTransparency = 1 })
			}
			for _, t in ipairs(hideTweens) do t:Play() end

			task.wait(1)
			Alert:Destroy()
		end
		isShowingNotification = false
	end)
end



-----------------------------------------------------------
-- MAIN STUFF ---------------------------------------------
-----------------------------------------------------------

-- SERVICES
local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")

-- PREFIX
local PREFIX = "-"

-- COMMAND SYSTEM
local Commands = {}

-- CENTRAL AUTOCOMPLETE TYPES
local AutocompleteTypes = {}

-- Player autocomplete

-- COMMAND REGISTRATION
local function command(name, func, description, autocomplete)
	Commands[name:lower()] = {
		func = func,
		description = description or "No description provided",
		autocomplete = autocomplete or {}
	}
end

-- HELPER: Find players (for commands like kick)
local function getTargetPlayers(arg)
	if not arg or arg == "" then
		Notify("Error", "No player listed.", 3) return {}
	end

	arg = arg:lower()
	local localPlayer = Players.LocalPlayer
	local targets = {}

	if arg == "me" then
		table.insert(targets, localPlayer)
	elseif arg == "others" then
		for _, plr in ipairs(Players:GetPlayers()) do
			if plr ~= localPlayer then
				table.insert(targets, plr)
			end
		end
	elseif arg == "all" then
		targets = Players:GetPlayers()
	elseif arg == "random" then
		local all = Players:GetPlayers()
		if #all > 0 then
			targets = { all[math.random(1, #all)] }
		end
	else
		-- match partial player names
		for _, plr in ipairs(Players:GetPlayers()) do
			if plr.Name:sub(1, #arg):lower() == arg then
				table.insert(targets, plr)
			end
		end
	end

	return targets -- always returns a table
end



-- AUTOCOMPLETE HELPER
local function getArgumentMatches(cmdName, argIndex, argText, prevArgs)
	if argText == "" then return {} end
	local cmd = Commands[cmdName]
	if not cmd then return {} end
	local autocompleteType = cmd.autocomplete[argIndex]
	if not autocompleteType then return {} end
	local func = AutocompleteTypes[autocompleteType]
	if not func then return {} end
	return func(argText, prevArgs or {})
end




--// === SUGGESTION UI ===
local SuggestionFrame = Instance.new("Frame", Main)
SuggestionFrame.BackgroundTransparency = 1
SuggestionFrame.AutomaticSize = Enum.AutomaticSize.Y
SuggestionFrame.Size = UDim2.new(1, 0, 0, 0) -- initial height 0
SuggestionFrame.BackgroundTransparency = 1
SuggestionFrame.AnchorPoint = Vector2.new(0.5, 0)
SuggestionFrame.Position = UDim2.new(0.5, 0, 1.2, 0)
SuggestionFrame.Visible = false


local UIListLayout = Instance.new("UIListLayout", SuggestionFrame)
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
UIListLayout.Padding = UDim.new(0, 2)



-- SUGGESTION MANAGEMENT
local currentMatches = {}

local function clearSuggestions()
	for _, child in ipairs(SuggestionFrame:GetChildren()) do
		if child:IsA("TextLabel") then
			child:Destroy()
		end
	end
end

local function showSuggestions(matches)
	clearSuggestions()
	if #matches == 0 then
		SuggestionFrame.Visible = false
		return
	end

	SuggestionFrame.Visible = true

	for _, name in ipairs(matches) do
		local label = Instance.new("TextLabel")
		label.BackgroundTransparency = 0.4
		-- Use scale in both X and Y
		label.Size = UDim2.new(1, -8, 0.5, 20) -- Height 0 for now, will auto-size
		label.BackgroundColor3 = Color3.fromRGB(30, 31, 40)
		label.Font = Enum.Font.Gotham
		label.TextScaled = true
		label.TextColor3 = Color3.fromRGB(255, 130, 114)
		label.TextXAlignment = Enum.TextXAlignment.Left
		label.Text = name
		label.ZIndex = 6

		local corner = Instance.new("UICorner", label)
		corner.CornerRadius = UDim.new(0, 5)
		label.Parent = SuggestionFrame
	end
end


-- MATCH COMMAND NAMES
local function getMatches(text)
	if text == "" then return {} end -- don't show anything if empty
	local matches = {}
	for name in pairs(Commands) do
		if name:sub(1, #text):lower() == text:lower() then
			table.insert(matches, name)
		end
	end
	table.sort(matches)
	return matches
end


-- TEXTBOX AUTOCOMPLETE
TextBox:GetPropertyChangedSignal("Text"):Connect(function()
	local text = TextBox.Text
	if text == "" or text:sub(1, #PREFIX) ~= PREFIX then
		SuggestionFrame.Visible = false
		currentMatches = {}
		return
	end

	local content = text:sub(#PREFIX + 1)
	local parts = string.split(content, " ")
	local cmdName = parts[1]:lower()
	local cmd = Commands[cmdName]

	-- No command typed yet → suggest commands
	if #parts == 1 and content:sub(-1) ~= " " then
		currentMatches = getMatches(cmdName)
		showSuggestions(currentMatches)
		return
	end

	if not cmd then
		showSuggestions({})
		currentMatches = {}
		return
	end

	-- Determine current argument index and text
	local trailingSpace = content:sub(-1) == " "
	local argIndex = trailingSpace and (#parts + 1) or #parts
	local argText = trailingSpace and "" or parts[#parts]

	-- Stop suggesting if past defined autocomplete arguments
	if argIndex - 1 > #cmd.autocomplete then
		showSuggestions({})
		currentMatches = {}
		return
	end

	-- Build a table of previous arguments of the same autocomplete type
	local prevArgs = {}
	for i = 2, argIndex - 1 do
		if cmd.autocomplete[i] == cmd.autocomplete[argIndex - 1] then
			table.insert(prevArgs, parts[i])
		end
	end

	-- Get matches for the current argument
	local autoType = cmd.autocomplete[argIndex - 1]
	local func = AutocompleteTypes[autoType]
	if func then
		currentMatches = func(argText, prevArgs)

		-- If current argument exactly matches one of the suggestions, stop suggesting
		for _, match in ipairs(currentMatches) do
			if match:lower() == argText:lower() then
				currentMatches = {}
				break
			end
		end

		showSuggestions(currentMatches)
	else
		-- No autocomplete for this command → clear matches
		currentMatches = {}
		showSuggestions({})
	end
end)



-- SPACE AUTOFILL
UIS.InputBegan:Connect(function(input, gpe)
	if not isOpen then return end
	if input.KeyCode == Enum.KeyCode.Space then
		-- Only autocomplete if there are matches
		if currentMatches and #currentMatches > 0 then
			local text = TextBox.Text
			local hasPrefix = text:sub(1, #PREFIX) == PREFIX
			local content = hasPrefix and text:sub(#PREFIX + 1) or text
			local parts = string.split(content, " ")

			local trailingSpace = content:sub(-1) == " "
			local argIndex = trailingSpace and (#parts + 1) or #parts

			-- Only replace current argument if a match exists
			if currentMatches[1] then
				parts[argIndex] = currentMatches[1]
				TextBox.Text = (hasPrefix and PREFIX or "") .. table.concat(parts, " ")
				TextBox.CursorPosition = #TextBox.Text + 1
				showSuggestions({})
			end
		end
	end
end)


-- EXECUTE COMMAND
TextBox.FocusLost:Connect(function(enterPressed)
	-- Prevent random close from Roblox auto-blur
	if not isOpen then return end

	local inputText = TextBox.Text

	if not enterPressed then
		-- Don’t close if player clicked away or focus bug triggered
		TextBox:CaptureFocus()
		return
	end

	if inputText:sub(1, #PREFIX) ~= PREFIX then
		closeBar()
		return
	end

	inputText = inputText:sub(#PREFIX + 1)
	inputText = inputText:lower():gsub("^%s*(.-)%s*$", "%1")

	if inputText == "" then
		closeBar()
		return
	end

	local parts = string.split(inputText, " ")
	local cmdName = table.remove(parts, 1)
	local cmd = Commands[cmdName or ""]

	if cmd then
		task.spawn(cmd.func, parts)
	else
		Notify("Error", string.format("Unknown Command: -%s", cmdName))
	end

	closeBar()
end)

-- CENTRAL AUTOCOMPLETE TYPES HELPER
-- users only provide a function that returns matches table
function AutocompleteTypes.simple(func)
	return function(input, prevArgs)
		if input == "" then return {} end
		local used = {}
		for _, arg in ipairs(prevArgs or {}) do
			used[arg:lower()] = true
		end

		local matches = func(input, used) or {}
		table.sort(matches)
		return matches
	end
end

print("SimpleIndex Loaded - Version 1.13")

command("cmds", function(args)
	print("===== Available Commands =====")
	for name, data in pairs(Commands) do
		print("- " .. name .. ": " .. data.description)
	end
	print("==============================")
end, "Lists all commands.")

return {
    command = command,
    Commands = Commands,
    AutocompleteTypes = AutocompleteTypes,
    Notify = Notify,
    getTargetPlayers = getTargetPlayers
}
