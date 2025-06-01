local player = game:GetService("Players").LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Constants
local buttonHeight = 28
local buttonSpacing = 35
local SWIM_ANIMATION_ID = "rbxassetid://5319927054" -- Default Roblox swim animation

-- Create main GUI
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "BoostMenuGui"
screenGui.ResetOnSpawn = false
screenGui.Parent = playerGui

-- Detect mobile platform
local isMobile = game:GetService("UserInputService").TouchEnabled

-- Adjust sizes for mobile
if isMobile then
	buttonHeight = 38
	buttonSpacing = 45
end

-- Circular Toggle Button (larger on mobile)
local toggleBtn = Instance.new("ImageButton")
toggleBtn.Name = "CircleToggle"
toggleBtn.Image = "rbxassetid://16022860575"
toggleBtn.ImageColor3 = Color3.fromRGB(70, 70, 70)
toggleBtn.ScaleType = Enum.ScaleType.Slice
toggleBtn.SliceCenter = Rect.new(100, 100, 100, 100)
toggleBtn.Size = isMobile and UDim2.new(0, 30, 0, 30) or UDim2.new(0, 30, 0, 30)
toggleBtn.Position = UDim2.new(0, 20, 0.5, -35)
toggleBtn.AnchorPoint = Vector2.new(0, 0.5)
toggleBtn.Parent = screenGui

local toggleIcon = Instance.new("ImageLabel")
toggleIcon.Image = "rbxassetid://16022860575"
toggleIcon.ImageRectOffset = Vector2.new(324, 364)
toggleIcon.ImageRectSize = Vector2.new(30, 30)
toggleIcon.Size = isMobile and UDim2.new(0, 30, 0, 30) or UDim2.new(0, 30, 0, 30)
toggleIcon.Position = UDim2.new(0.2, 0, 0.2, 0)
toggleIcon.BackgroundTransparency = 1
toggleIcon.Parent = toggleBtn

-- Make toggle button draggable
local toggleDragInput, toggleDragStart, toggleStartPos

toggleBtn.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
		toggleDragStart = input.Position
		toggleStartPos = toggleBtn.Position
		toggleBtn.ImageColor3 = Color3.fromRGB(100, 100, 100)

		input.Changed:Connect(function()
			if input.UserInputState == Enum.UserInputState.End then
				toggleDragStart = nil
				toggleBtn.ImageColor3 = Color3.fromRGB(70, 70, 70)
			end
		end)
	end
end)

toggleBtn.InputChanged:Connect(function(input)
	if (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) and toggleDragStart then
		local delta = input.Position - toggleDragStart
		toggleBtn.Position = UDim2.new(
			0,
			toggleStartPos.X.Offset + delta.X,
			0.5,
			toggleStartPos.Y.Offset + delta.Y
		)
	end
end)


-- Menu Frame (larger on mobile)
local menuFrame = Instance.new("Frame")
menuFrame.Size = isMobile and UDim2.new(0, 350, 0, 230) or UDim2.new(0, 320, 0, 230)
menuFrame.Position = UDim2.new(0.5, 250, 0.5, -10)
menuFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
menuFrame.Visible = false
menuFrame.Parent = screenGui
menuFrame.AnchorPoint = Vector2.new(0.5, 0.5)
menuFrame.BorderSizePixel = 0
menuFrame.ClipsDescendants = true
menuFrame.BackgroundTransparency = 0.15

-- Add rounded corners to menu
local menuCorner = Instance.new("UICorner")
menuCorner.CornerRadius = UDim.new(0, 8)
menuCorner.Parent = menuFrame

-- Add Close Button (X) in top-right corner
local closeButton = Instance.new("TextButton")
closeButton.Name = "CloseButton"
closeButton.Text = "X"
closeButton.Size = isMobile and UDim2.new(0, 40, 0, 40) or UDim2.new(0, 30, 0, 30)
closeButton.Position = UDim2.new(1, -10, 0, 10)
closeButton.AnchorPoint = Vector2.new(1, 0)
closeButton.BackgroundColor3 = Color3.fromRGB(200, 60, 60) -- Red color
closeButton.TextColor3 = Color3.new(1, 1, 1)
closeButton.Font = Enum.Font.GothamBold
closeButton.TextSize = isMobile and 20 or 18
closeButton.ZIndex = 2
closeButton.Parent = menuFrame

-- Rounded corners for close button
local closeCorner = Instance.new("UICorner")
closeCorner.CornerRadius = UDim.new(1, 0) -- Fully round
closeCorner.Parent = closeButton

-- Hover effects for close button
if not isMobile then
	closeButton.MouseEnter:Connect(function()
		game:GetService("TweenService"):Create(closeButton, TweenInfo.new(0.2), {
			BackgroundColor3 = Color3.fromRGB(220, 80, 80),
			Size = isMobile and UDim2.new(0, 42, 0, 42) or UDim2.new(0, 32, 0, 32)
		}):Play()
	end)

	closeButton.MouseLeave:Connect(function()
		game:GetService("TweenService"):Create(closeButton, TweenInfo.new(0.2), {
			BackgroundColor3 = Color3.fromRGB(200, 60, 60),
			Size = isMobile and UDim2.new(0, 40, 0, 40) or UDim2.new(0, 30, 0, 30)
		}):Play()
	end)
end

-- Close functionality: Destroys the script
closeButton.MouseButton1Click:Connect(function()
	if screenGui then
		screenGui:Destroy()
	end
end)


-- Title with drag functionality (adjusted to not overlap with close button)
local title = Instance.new("TextLabel")
title.Size = UDim2.new(0.85, 0, 0, isMobile and 50 or 40) -- Reduced width
title.Position = UDim2.new(0.075, 0, 0, 0) -- Centered with offset
title.BackgroundTransparency = 1
title.Text = "Boost Menu ◈ Made By B3RT1337"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.Font = Enum.Font.GothamBold
title.TextSize = isMobile and 15 or 15
title.TextXAlignment = Enum.TextXAlignment.Center
title.Parent = menuFrame

-- Make menu draggable
local menuDragInput, menuDragStart, menuStartPos

title.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
		menuDragStart = input.Position
		menuStartPos = menuFrame.Position
		menuFrame.BackgroundTransparency = 0.3

		input.Changed:Connect(function()
			if input.UserInputState == Enum.UserInputState.End then
				menuDragStart = nil
				menuFrame.BackgroundTransparency = 0.15
			end
		end)
	end
end)

title.InputChanged:Connect(function(input)
	if (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) and menuDragStart then
		local delta = input.Position - menuDragStart
		menuFrame.Position = UDim2.new(
			menuStartPos.X.Scale, 
			menuStartPos.X.Offset + delta.X, 
			menuStartPos.Y.Scale, 
			menuStartPos.Y.Offset + delta.Y
		)
	end
end)

-- Toggle menu visibility with animation
toggleBtn.MouseButton1Click:Connect(function()
	menuFrame.Visible = not menuFrame.Visible

	-- Pulse animation
	local tweenService = game:GetService("TweenService")
	tweenService:Create(toggleBtn, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
		Size = isMobile and UDim2.new(0, 65, 0, 65) or UDim2.new(0, 45, 0, 45)
	}):Play()

	task.wait(0.1)

	tweenService:Create(toggleBtn, TweenInfo.new(0.2, Enum.EasingStyle.Elastic, Enum.EasingDirection.Out), {
		Size = isMobile and UDim2.new(0, 70, 0, 70) or UDim2.new(0, 50, 0, 50)
	}):Play()
end)

-- Enhanced Slider creation function (percentage only)
local function createSlider(parent, yPos, labelText, minVal, maxVal, defaultVal, onValueChanged)
	local container = Instance.new("Frame")
	container.Size = UDim2.new(1, -20, 0, isMobile and 70 or 60)
	container.Position = UDim2.new(0, 10, 0, yPos)
	container.BackgroundTransparency = 1
	container.Parent = parent

	-- Label with improved styling (larger on mobile)
	local label = Instance.new("TextLabel")
	label.Size = UDim2.new(0.35, 0, 0.5, 0)
	label.Position = UDim2.new(0, 0, 0.1, 0)
	label.BackgroundTransparency = 1
	label.Text = labelText
	label.TextColor3 = Color3.fromRGB(240, 240, 240)
	label.Font = Enum.Font.GothamSemibold
	label.TextSize = isMobile and 20 or 18
	label.TextXAlignment = Enum.TextXAlignment.Left
	label.Parent = container

	-- Slider bar container for better styling
	local sliderContainer = Instance.new("Frame")
	sliderContainer.Size = UDim2.new(0.6, 0, 0.25, 0)
	sliderContainer.Position = UDim2.new(0.35, 0, 0.5, 0)
	sliderContainer.AnchorPoint = Vector2.new(0, 0.5)
	sliderContainer.BackgroundTransparency = 1
	sliderContainer.Parent = container

	-- Background track with rounded ends
	local sliderTrack = Instance.new("Frame")
	sliderTrack.Size = UDim2.new(1, 0, isMobile and 0.5 or 0.35, 0)
	sliderTrack.Position = UDim2.new(0, 0, 0.5, 0)
	sliderTrack.AnchorPoint = Vector2.new(0, 0.5)
	sliderTrack.BackgroundColor3 = Color3.fromRGB(60, 60, 70)
	sliderTrack.BorderSizePixel = 0
	sliderTrack.Parent = sliderContainer

	-- Round the ends using UICorner
	local trackCorner = Instance.new("UICorner")
	trackCorner.CornerRadius = UDim.new(1, 0)
	trackCorner.Parent = sliderTrack

	-- Fill bar with gradient
	local sliderFill = Instance.new("Frame")
	sliderFill.Size = UDim2.new((defaultVal - minVal) / (maxVal - minVal), 0, 1, 0)
	sliderFill.BackgroundColor3 = Color3.fromRGB(100, 180, 255)
	sliderFill.BorderSizePixel = 0
	sliderFill.Parent = sliderTrack

	-- Round fill corners
	local fillCorner = Instance.new("UICorner")
	fillCorner.CornerRadius = UDim.new(1, 0)
	fillCorner.Parent = sliderFill

	-- Add gradient to fill
	local gradient = Instance.new("UIGradient")
	gradient.Color = ColorSequence.new({
		ColorSequenceKeypoint.new(0, Color3.fromRGB(80, 160, 255)),
		ColorSequenceKeypoint.new(1, Color3.fromRGB(120, 200, 255))
	})
	gradient.Rotation = 0
	gradient.Parent = sliderFill

	-- Handle with modern design (larger on mobile)
	local sliderHandle = Instance.new("Frame")
	sliderHandle.Size = isMobile and UDim2.new(0.025, 0, 1.8, 0) or UDim2.new(0.015, 0, 1.8, 0)
	sliderHandle.Position = UDim2.new(sliderFill.Size.X.Scale, 0, 0.5, 0)
	sliderHandle.AnchorPoint = Vector2.new(0.5, 0.5)
	sliderHandle.BackgroundColor3 = Color3.fromRGB(240, 240, 240)
	sliderHandle.BorderSizePixel = 0
	sliderHandle.Parent = sliderTrack

	-- Round handle corners
	local handleCorner = Instance.new("UICorner")
	handleCorner.CornerRadius = UDim.new(1, 0)
	handleCorner.Parent = sliderHandle

	-- Add glow effect to handle
	local handleGlow = Instance.new("UIStroke")
	handleGlow.Color = Color3.fromRGB(200, 230, 255)
	handleGlow.Thickness = 2
	handleGlow.Transparency = 0.5
	handleGlow.Parent = sliderHandle

	-- Percentage label only (larger on mobile)
	local percentLabel = Instance.new("TextLabel")
	percentLabel.Size = UDim2.new(0.25, 0, 0.8, 0)
	percentLabel.Position = UDim2.new(0.75, 0, 0.1, 0)
	percentLabel.BackgroundTransparency = 1
	percentLabel.TextColor3 = Color3.fromRGB(240, 240, 240)
	percentLabel.Font = Enum.Font.GothamBold
	percentLabel.TextSize = isMobile and 18 or 16
	percentLabel.Text = math.floor(((defaultVal - minVal) / (maxVal - minVal)) * 100) .. "%"
	percentLabel.Parent = sliderContainer

	local function getValue()
		return minVal + (sliderFill.Size.X.Scale * (maxVal - minVal))
	end

	local dragging = false
	sliderTrack.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			dragging = true
			-- Immediate response on click
			local relativeX = math.clamp(input.Position.X - sliderTrack.AbsolutePosition.X, 0, sliderTrack.AbsoluteSize.X)
			local ratio = relativeX / sliderTrack.AbsoluteSize.X
			updateSlider(ratio)
		end
	end)

	game:GetService("UserInputService").InputEnded:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			dragging = false
		end
	end)

	local function updateSlider(ratio)
		ratio = math.clamp(ratio, 0, 1)
		sliderFill.Size = UDim2.new(ratio, 0, 1, 0)
		sliderHandle.Position = UDim2.new(ratio, 0, 0.5, 0)

		local val = minVal + ratio * (maxVal - minVal)
		local percent = math.floor(ratio * 100)
		percentLabel.Text = percent .. "%"

		if onValueChanged then
			onValueChanged(val)
		end
	end

	sliderTrack.InputChanged:Connect(function(input)
		if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
			local relativeX = math.clamp(input.Position.X - sliderTrack.AbsolutePosition.X, 0, sliderTrack.AbsoluteSize.X)
			local ratio = relativeX / sliderTrack.AbsoluteSize.X
			updateSlider(ratio)
		end
	end)

	-- Set initial values
	local initialRatio = (defaultVal - minVal) / (maxVal - minVal)
	updateSlider(initialRatio)

	return container, getValue, function(val)
		local ratio = (val - minVal) / (maxVal - minVal)
		updateSlider(ratio)
	end
end

-- Character functions
local function getHumanoid()
	return player.Character and player.Character:FindFirstChildOfClass("Humanoid")
end

local function getHumanoidRootPart()
	return player.Character and player.Character:FindFirstChild("HumanoidRootPart")
end

-- Create sliders with 100% boost by default (percentage only)
local jumpSlider, getJumpPower, setJumpPowerSlider = createSlider(menuFrame, 50, "Jump Power", 50, 200, 200, function(val)
	local humanoid = getHumanoid()
	if humanoid then
		humanoid.UseJumpPower = true
		humanoid.JumpPower = val
	end
end)

local speedSlider, getWalkSpeed, setWalkSpeedSlider = createSlider(menuFrame, 80, "Walk Speed", 16, 60, 60, function(val)
	local humanoid = getHumanoid()
	if humanoid then
		humanoid.WalkSpeed = val
	end
end)

-- Combined Flying and Noclip system
local flying = false
local flightSpeed = 50
local flyingConnection, bodyVelocity, bodyGyro
local swimAnimationTrack

-- Fly/Noclip button (larger on mobile)
local flyButton = Instance.new("TextButton")
flyButton.Size = UDim2.new(0.9, 0, 0, isMobile and 38 or buttonHeight)
flyButton.Position = UDim2.new(0.05, 0, 0, 130 + buttonSpacing)
flyButton.AnchorPoint = Vector2.new(0, 1)
flyButton.Text = "Fly/Noclip: OFF (Press F)"
flyButton.BackgroundColor3 = Color3.fromRGB(70, 180, 70)
flyButton.TextColor3 = Color3.new(1, 1, 1)
flyButton.Font = Enum.Font.GothamBold
flyButton.TextSize = isMobile and 20 or 18
flyButton.Parent = menuFrame

local function loadSwimAnimation()
	local humanoid = getHumanoid()
	if humanoid then
		local anim = Instance.new("Animation")
		anim.AnimationId = SWIM_ANIMATION_ID
		local track = humanoid:LoadAnimation(anim)
		track.Priority = Enum.AnimationPriority.Action
		return track
	end
	return nil
end

local function updateCollision()
	if player.Character then
		for _, part in pairs(player.Character:GetDescendants()) do
			if part:IsA("BasePart") then
				part.CanCollide = not flying
			end
		end
	end
end

-- Combined Flying/Noclip System
local function startFlying()
	local hrp = getHumanoidRootPart()
	if not hrp then return end

	local bodyVelocity = Instance.new("BodyVelocity")
	bodyVelocity.Name = "FlyVelocity"
	bodyVelocity.MaxForce = Vector3.new(1e5, 1e5, 1e5)
	bodyVelocity.Velocity = Vector3.new(0, 0, 0)
	bodyVelocity.Parent = hrp

	local bodyGyro = Instance.new("BodyGyro")
	bodyGyro.Name = "FlyGyro"
	bodyGyro.MaxTorque = Vector3.new(1e5, 1e5, 1e5)
	bodyGyro.CFrame = hrp.CFrame
	bodyGyro.Parent = hrp

	-- Start swimming animation
	swimAnimationTrack = loadSwimAnimation()
	if swimAnimationTrack then
		swimAnimationTrack:Play()
		swimAnimationTrack.Looped = true
	end

	local flyingConnection
	local velocity = Vector3.new(0, 0, 0)

	flyingConnection = game:GetService("RunService").Heartbeat:Connect(function()
		local moveDirection = Vector3.new()
		local inputService = game:GetService("UserInputService")

		if inputService:IsKeyDown(Enum.KeyCode.W) or (isMobile and inputService:IsKeyDown(Enum.KeyCode.ButtonY)) then
			moveDirection = moveDirection + workspace.CurrentCamera.CFrame.LookVector
		end
		if inputService:IsKeyDown(Enum.KeyCode.S) or (isMobile and inputService:IsKeyDown(Enum.KeyCode.ButtonA)) then
			moveDirection = moveDirection - workspace.CurrentCamera.CFrame.LookVector
		end
		if inputService:IsKeyDown(Enum.KeyCode.A) or (isMobile and inputService:IsKeyDown(Enum.KeyCode.ButtonX)) then
			moveDirection = moveDirection - workspace.CurrentCamera.CFrame.RightVector
		end
		if inputService:IsKeyDown(Enum.KeyCode.D) or (isMobile and inputService:IsKeyDown(Enum.KeyCode.ButtonB)) then
			moveDirection = moveDirection + workspace.CurrentCamera.CFrame.RightVector
		end
		if inputService:IsKeyDown(Enum.KeyCode.Space) or (isMobile and inputService:IsKeyDown(Enum.KeyCode.ButtonR2)) then
			moveDirection = moveDirection + Vector3.new(0, 1, 0)
		end
		if inputService:IsKeyDown(Enum.KeyCode.LeftShift) or (isMobile and inputService:IsKeyDown(Enum.KeyCode.ButtonL2)) then
			moveDirection = moveDirection - Vector3.new(0, 1, 0)
		end

		velocity = moveDirection.Unit * flightSpeed
		if moveDirection.Magnitude == 0 then
			velocity = Vector3.new(0, 0, 0)
		end

		bodyVelocity.Velocity = velocity
		bodyGyro.CFrame = workspace.CurrentCamera.CFrame
	end)

	return flyingConnection, bodyVelocity, bodyGyro
end

local function toggleFlying()
	flying = not flying
	local humanoid = getHumanoid()

	if flying then
		flyButton.Text = "Fly/Noclip: ON (Press F)"
		if humanoid then
			humanoid.PlatformStand = true
			humanoid.AutoRotate = false
		end
		flyingConnection, bodyVelocity, bodyGyro = startFlying()
	else
		flyButton.Text = "Fly/Noclip: OFF (Press F)"
		if humanoid then
			humanoid.PlatformStand = false
			humanoid.AutoRotate = true
		end

		-- Stop swimming animation
		if swimAnimationTrack then
			swimAnimationTrack:Stop()
			swimAnimationTrack:Destroy()
			swimAnimationTrack = nil
		end

		if flyingConnection then
			flyingConnection:Disconnect()
			flyingConnection = nil
		end
		if bodyVelocity then
			bodyVelocity:Destroy()
			bodyVelocity = nil
		end
		if bodyGyro then
			bodyGyro:Destroy()
			bodyGyro = nil
		end
	end

	updateCollision()
end

-- Connect controls
flyButton.MouseButton1Click:Connect(toggleFlying)

-- Keybind (works with touch on mobile)
game:GetService("UserInputService").InputBegan:Connect(function(input, processed)
	if not processed then
		if input.KeyCode == Enum.KeyCode.F or (isMobile and input.KeyCode == Enum.KeyCode.ButtonStart) then
			toggleFlying()
		elseif input.KeyCode == Enum.KeyCode.F5 then
			menuFrame.Visible = not menuFrame.Visible
		end
	end
end)

-- Handle character respawns
player.CharacterAdded:Connect(function(character)
	if flying then
		local humanoid = character:WaitForChild("Humanoid")
		task.wait(0.5)
		toggleFlying() -- Turn off first
		toggleFlying() -- Then turn back on
	end

	-- Reapply slider values on respawn
	task.wait(0.1) -- Small delay to ensure humanoid is ready
	local humanoid = character:FindFirstChildOfClass("Humanoid")
	if humanoid then
		humanoid.UseJumpPower = true
		humanoid.JumpPower = getJumpPower()
		humanoid.WalkSpeed = getWalkSpeed()
	end
end)

-- Run collision update continuously
game:GetService("RunService").Stepped:Connect(updateCollision)

-- Reset buttons (larger on mobile)
local resetJumpBtn = Instance.new("TextButton")
resetJumpBtn.Size = UDim2.new(0.45, 0, 0, isMobile and 38 or buttonHeight)
resetJumpBtn.Position = UDim2.new(0.05, 0, 0, 130 + buttonSpacing*2)
resetJumpBtn.AnchorPoint = Vector2.new(0, 1)
resetJumpBtn.Text = "Reset Jump"
resetJumpBtn.BackgroundColor3 = Color3.fromRGB(180, 70, 70)
resetJumpBtn.TextColor3 = Color3.new(1, 1, 1)
resetJumpBtn.Font = Enum.Font.GothamBold
resetJumpBtn.TextSize = isMobile and 18 or 16
resetJumpBtn.Parent = menuFrame

local resetSpeedBtn = Instance.new("TextButton")
resetSpeedBtn.Size = UDim2.new(0.45, 0, 0, isMobile and 38 or buttonHeight)
resetSpeedBtn.Position = UDim2.new(0.5, 0, 0, 130 + buttonSpacing*2)
resetSpeedBtn.AnchorPoint = Vector2.new(0, 1)
resetSpeedBtn.Text = "Reset Walk"
resetSpeedBtn.BackgroundColor3 = Color3.fromRGB(180, 70, 70)
resetSpeedBtn.TextColor3 = Color3.new(1, 1, 1)
resetSpeedBtn.Font = Enum.Font.GothamBold
resetSpeedBtn.TextSize = isMobile and 18 or 16
resetSpeedBtn.Parent = menuFrame

resetJumpBtn.MouseButton1Click:Connect(function()
	setJumpPowerSlider(50)
end)

resetSpeedBtn.MouseButton1Click:Connect(function()
	setWalkSpeedSlider(16)
end)

-- Hover effects for toggle button (only on desktop)
if not isMobile then
	toggleBtn.MouseEnter:Connect(function()
		game:GetService("TweenService"):Create(toggleBtn, TweenInfo.new(0.2), {
			ImageColor3 = Color3.fromRGB(90, 90, 90)
		}):Play()
	end)

	toggleBtn.MouseLeave:Connect(function()
		game:GetService("TweenService"):Create(toggleBtn, TweenInfo.new(0.2), {
			ImageColor3 = Color3.fromRGB(70, 70, 70)
		}):Play()
	end)
end

-- Save positions between sessions
local menuPositionKey = player.UserId.."_BoostMenuPosition"
local togglePositionKey = player.UserId.."_TogglePosition"

-- Load saved positions
local savedMenuPos = player:GetAttribute(menuPositionKey)
if savedMenuPos then
	menuFrame.Position = UDim2.new(
		savedMenuPos.X.Scale,
		savedMenuPos.X.Offset,
		savedMenuPos.Y.Scale,
		savedMenuPos.Y.Offset
	)
end

local savedTogglePos = player:GetAttribute(togglePositionKey)
if savedTogglePos then
	toggleBtn.Position = UDim2.new(
		0,
		savedTogglePos.X.Offset,
		0.5,
		savedTogglePos.Y.Offset
	)
end

-- Save positions when moved
menuFrame:GetPropertyChangedSignal("Position"):Connect(function()
	player:SetAttribute(menuPositionKey, {
		X = {Scale = menuFrame.Position.X.Scale, Offset = menuFrame.Position.X.Offset},
		Y = {Scale = menuFrame.Position.Y.Scale, Offset = menuFrame.Position.Y.Offset}
	})
end)

toggleBtn:GetPropertyChangedSignal("Position"):Connect(function()
	player:SetAttribute(togglePositionKey, {
		X = {Offset = toggleBtn.Position.X.Offset},
		Y = {Offset = toggleBtn.Position.Y.Offset}
	})
end)
