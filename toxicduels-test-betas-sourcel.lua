-- rename by prince

local tpBatData = {}
local iData = {}
local unpackValues = unpack or table.unpack
iData.value1 = game:GetService("Players")
iData.value2 = game:GetService("TweenService")
iData.value3 = game:GetService("UserInputService")
iData.value4 = game:GetService("RunService")
iData.value5 = game:GetService("Lighting")
iData.value6 = game:GetService("HttpService")

local _ = iData.value1.LocalPlayer
if isfile and isfile("RXZ_HUB.json") then
	local ok, result = pcall(function()
		local secondaryResult = iData.value6
		local data = { readfile("RXZ_HUB.json") }

		return secondaryResult:JSONDecode(unpackValues(data))
	end)

	tpBatData.value1 = ok

	if tpBatData.value1 and type(result) == "table" then
		if type(result.backgroundEnabled) == "boolean" then
			backgroundEnabled = result.backgroundEnabled
		end

		if type(result.backgroundIndex) == "number" then
			backgroundIndex = result.backgroundIndex
		end
	end
end
game:IsLoaded()
repeat
	task.wait()
until game:IsLoaded()
task.spawn(function()
	local flagData = {
		value1 = game:GetService("Players"),
		value2 = game:GetService("TweenService"),
	}

	pcall(function()
		for _, item in ipairs({
			"VoidVS_Intro",
			"BerserkVS_Intro",
		}) do
			local firstChild = game:GetService("CoreGui"):FindFirstChild(item)

			if firstChild then
				firstChild:Destroy()
			end

			local firstChildCondition = flagData.value1.LocalPlayer
				and flagData.value1.LocalPlayer:FindFirstChild("PlayerGui")

			if firstChildCondition then
				local firstChild = firstChildCondition:FindFirstChild(item)

				if firstChild then
					firstChild:Destroy()
				end
			end
		end
	end)
	flagData.value3 = "https://files.catbox.moe/rq2ilr.png"

	local function handleFlag()
		local flagResult
		local ok, result = pcall(function()
			return game:HttpGet(flagData.value3)
		end)
		if ok then
			ok = result and #result > 100
		end
		if ok then
			flagResult = result
		end
		if not flagResult and (syn and syn.request) then
			local resultFlag = syn.request({
				Url = flagData.value3,
				Method = "GET",
			})

			if resultFlag and (resultFlag.Body and #resultFlag.Body > 100) then
				flagResult = resultFlag.Body
			end
		end
		if not flagResult then
			local flagCallback = http and http.request or request

			if flagCallback then
				local resultFlag = flagCallback({
					Url = flagData.value3,
					Method = "GET",
				})

				if resultFlag and (resultFlag.Body and #resultFlag.Body > 100) then
					flagResult = resultFlag.Body
				end
			end
		end

		return flagResult
	end

	local image = (function(argument)
		pcall(function()
			if isfile and isfile(argument) then
				delfile(argument)
			end
		end)

		local flag = handleFlag()

		if not flag then
			return ""
		end

		if not pcall(function()
			writefile(argument, flag)
		end) then
			return ""
		end

		task.wait(0.05)

		local iteratorData = {
			getcustomasset,
			getsynasset,
			getasset,
		}
		local iterator, state, control = ipairs(iteratorData)
		local result

		repeat
			local capturedCallback

			repeat
				local callback

				control, callback = iterator(state, control)

				if not control then
					if typeof(getcustomasset) == "function" then
						local ok, okResult = pcall(function()
							return getcustomasset(argument, true)
						end)

						if ok then
							ok = type(okResult) == "string" and okResult ~= ""
						end

						if ok then
							return okResult
						end
					end

					return ""
				end

				capturedCallback = callback
			until typeof(capturedCallback) == "function"

			local ok

			ok, result = pcall(function()
				return capturedCallback(argument)
			end)

			if ok then
				ok = type(result) == "string" and result ~= ""
			end
		until ok

		return result
	end)("voidvs_intro.png")

	flagData.value4 = nil
	task.spawn(function()
		pcall(function()
			local randomData = {
				{
					url = "https://files.catbox.moe/oqex53.mp3",
					file = "voidvs_intro_a.mp3",
					startAt = 0,
				},
				{
					url = "https://files.catbox.moe/cf8fyf.mp3",
					file = "voidvs_intro_b.mp3",
					startAt = 0,
				},
			}

			math.randomseed(tick() % 1000000000 * 1000)

			local random = randomData[math.random(1, #randomData)]
			local url = random.url
			local file = random.file
			local timePosition = random.startAt or 0

			local function handleSoundId(soundIdArgument)
				local iteratorData = {
					getcustomasset,
					getsynasset,
					getasset,
				}
				local iterator, state, control = ipairs(iteratorData)
				local result

				repeat
					local capturedSoundIdCallback

					repeat
						local soundIdCallback

						control, soundIdCallback = iterator(state, control)

						if not control then
							if typeof(getcustomasset) == "function" then
								local ok, soundIdResult = pcall(function()
									return getcustomasset(soundIdArgument, true)
								end)

								if ok then
									ok = type(soundIdResult) == "string" and soundIdResult ~= ""
								end

								if ok then
									return soundIdResult
								end
							end

							return ""
						end

						capturedSoundIdCallback = soundIdCallback
					until typeof(capturedSoundIdCallback) == "function"

					local ok

					ok, result = pcall(function()
						return capturedSoundIdCallback(soundIdArgument)
					end)

					if ok then
						ok = type(result) == "string" and result ~= ""
					end
				until ok

				return result
			end

			local soundId = ""

			if isfile and isfile(file) then
				soundId = handleSoundId(file)
			end

			if soundId == "" then
				local capturedResult
				local ok, result = pcall(function()
					return game:HttpGet(url)
				end)
				if ok then
					ok = result and #result > 100
				end
				if ok then
					capturedResult = result
				end
				if not capturedResult then
					local flagCallback = http and http.request

					if not flagCallback then
						flagCallback = request or syn and syn.request
					end

					if flagCallback then
						local capturedResultFlag = flagCallback({
							Url = url,
							Method = "GET",
						})

						if capturedResultFlag and (capturedResultFlag.Body and #capturedResultFlag.Body > 100) then
							capturedResult = capturedResultFlag.Body
						end
					end
				end
				if not capturedResult then
					return
				end
				if not pcall(function()
					writefile(file, capturedResult)
				end) then
					return
				end
				soundId = handleSoundId(file)
			end

			if soundId == "" then
				return
			end

			local SoundService = game:GetService("SoundService")

			pcall(function()
				local VoidVS_IntroSong = SoundService:FindFirstChild("VoidVS_IntroSong")

				if VoidVS_IntroSong then
					VoidVS_IntroSong:Stop()
					VoidVS_IntroSong:Destroy()
				end
			end)
			flagData.value4 = Instance.new("Sound")
			flagData.value4.Name = "VoidVS_IntroSong"
			flagData.value4.SoundId = soundId
			flagData.value4.Volume = 1
			flagData.value4.Looped = false
			flagData.value4.Parent = SoundService

			local function onLoaded()
				if not flagData.value4 or not flagData.value4.Parent then
					return
				end

				pcall(function()
					flagData.value4.TimePosition = timePosition
					flagData.value4:Play()
				end)
			end

			if flagData.value4.IsLoaded then
				onLoaded()

				return
			end

			flagData.value4.Loaded:Connect(onLoaded)
			task.delay(0.35, onLoaded)
		end)
	end)
	flagData.value5 = Instance.new("ScreenGui")
	flagData.value5.Name = "VoidVS_Intro"
	flagData.value5.IgnoreGuiInset = true
	flagData.value5.ResetOnSpawn = false
	flagData.value5.DisplayOrder = 100000
	flagData.value5.ZIndexBehavior = Enum.ZIndexBehavior.Global
	pcall(function()
		if syn and syn.protect_gui then
			syn.protect_gui(flagData.value5)
		end
	end)

	if not pcall(function()
		flagData.value5.Parent = game:GetService("CoreGui")
	end) then
		flagData.value5.Parent = flagData.value1.LocalPlayer:WaitForChild("PlayerGui")
	end

	flagData.value6 = false
	flagData.value7 = nil
	flagData.value8 = nil
	flagData.value9 = nil
	flagData.value10 = nil
	flagData.value11 = nil
	flagData.value12 = nil
	flagData.value13 = nil

	local function updateInstanceProperties()
		if flagData.value6 then
			return
		end

		flagData.value6 = true
		pcall(function()
			if flagData.value13 then
				flagData.value13.Active = false
				flagData.value13.Visible = false
			end

			if flagData.value5 then
				flagData.value5.Enabled = false
			end
		end)
		pcall(function()
			if flagData.value4 then
				flagData.value4:Stop()
				flagData.value4:Destroy()
			end
		end)

		local tweenInfo = TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.In)
		local updateInstancePropertiesResult = flagData.value11
		local secondaryInstancePropertiesResult = flagData.value12
		local updateInstancePropertiesData = {
			flagData.value7,
			flagData.value8,
			flagData.value9,
			flagData.value10,
			updateInstancePropertiesResult,
			secondaryInstancePropertiesResult,
		}

		for _, item in ipairs(updateInstancePropertiesData) do
			local capturedV = item

			if capturedV then
				pcall(function()
					if capturedV:IsA("ImageLabel") then
						local createInstanceProperties = flagData.value2
						local capturedItem = capturedV
						local secondaryTweenInfo = tweenInfo
						local Size = capturedV.Size
						local Create = createInstanceProperties.Create
						local updateInstancePropertiesNumber = Size - UDim2.new(0, 30, 0, 30)

						Create(createInstanceProperties, capturedItem, secondaryTweenInfo, {
							ImageTransparency = 1,
							Size = updateInstancePropertiesNumber,
						}):Play()

						return
					end

					if capturedV:IsA("TextLabel") then
						flagData.value2
							:Create(capturedV, tweenInfo, {
								TextTransparency = 1,
								TextStrokeTransparency = 1,
							})
							:Play()

						return
					end

					local createInstanceProperties = flagData.value2
					local capturedItem = capturedV
					local secondaryTweenInfo = tweenInfo
					local Create = createInstanceProperties.Create
					local updateInstancePropertiesNumber = capturedV.Size - UDim2.new(0, 25, 0, 25)

					Create(createInstanceProperties, capturedItem, secondaryTweenInfo, {
						BackgroundTransparency = 1,
						Size = updateInstancePropertiesNumber,
					}):Play()
				end)
			end
		end

		pcall(function()
			local updateInstancePropertiesCondition = flagData.value5
				and flagData.value5:FindFirstChild("ChainSpearStage")

			if updateInstancePropertiesCondition then
				for _, descendant in ipairs(updateInstancePropertiesCondition:GetDescendants()) do
					if descendant:IsA("ImageLabel") then
						flagData.value2
							:Create(descendant, tweenInfo, {
								ImageTransparency = 1,
							})
							:Play()
					end
				end
			end
		end)
		task.wait(0.25)
		pcall(function()
			flagData.value5:Destroy()
		end)
	end

	local Frame = Instance.new("Frame", flagData.value5)

	Frame.Size = UDim2.new(1, 0, 1, 0)
	Frame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
	Frame.BackgroundTransparency = 0.82
	Frame.BorderSizePixel = 0
	Frame.ZIndex = 1
	flagData.value8 = Instance.new("ImageLabel", flagData.value5)
	flagData.value8.Name = "Moon"
	flagData.value8.Size = UDim2.new(0, 480, 0, 480)
	flagData.value8.Position = UDim2.new(0.5, 0, 0.5, -20)
	flagData.value8.AnchorPoint = Vector2.new(0.5, 0.5)
	flagData.value8.BackgroundTransparency = 1
	flagData.value8.Image = "rbxassetid://6031097222"
	flagData.value8.ImageTransparency = 0.62
	flagData.value8.ImageColor3 = Color3.fromRGB(210, 225, 255)
	flagData.value8.ZIndex = 2
	flagData.value8.ScaleType = Enum.ScaleType.Fit
	flagData.value14 = Instance.new("Frame", flagData.value5)
	flagData.value14.Size = UDim2.new(0, 520, 0, 520)
	flagData.value14.Position = UDim2.new(0.5, 0, 0.5, -20)
	flagData.value14.AnchorPoint = Vector2.new(0.5, 0.5)
	flagData.value14.BackgroundColor3 = Color3.fromRGB(160, 190, 255)
	flagData.value14.BackgroundTransparency = 0.94
	flagData.value14.BorderSizePixel = 0
	flagData.value14.ZIndex = 1
	Instance.new("UICorner", flagData.value14).CornerRadius = UDim.new(1, 0)
	flagData.value10 = Instance.new("Frame", flagData.value5)
	flagData.value10.Size = UDim2.new(0, 0, 0, 0)
	flagData.value10.Position = UDim2.new(0.5, 0, 0.5, -8)
	flagData.value10.AnchorPoint = Vector2.new(0.5, 0.5)
	flagData.value10.BackgroundColor3 = Color3.fromRGB(140, 180, 255)
	flagData.value10.BackgroundTransparency = 1
	flagData.value10.BorderSizePixel = 0
	flagData.value10.ZIndex = 3
	Instance.new("UICorner", flagData.value10).CornerRadius = UDim.new(1, 0)
	flagData.value9 = Instance.new("Frame", flagData.value5)
	flagData.value9.Size = UDim2.new(0, 0, 0, 0)
	flagData.value9.Position = UDim2.new(0.5, 0, 0.5, -8)
	flagData.value9.AnchorPoint = Vector2.new(0.5, 0.5)
	flagData.value9.BackgroundColor3 = Color3.fromRGB(180, 210, 255)
	flagData.value9.BackgroundTransparency = 1
	flagData.value9.BorderSizePixel = 0
	flagData.value9.ZIndex = 4
	Instance.new("UICorner", flagData.value9).CornerRadius = UDim.new(1, 0)
	flagData.value15 = Instance.new("UIStroke", flagData.value9)
	flagData.value15.Color = Color3.fromRGB(200, 230, 255)
	flagData.value15.Thickness = 2
	flagData.value15.Transparency = 1
	flagData.value7 = Instance.new("ImageLabel", flagData.value5)
	flagData.value7.Size = UDim2.new(0, 14, 0, 14)
	flagData.value7.Position = UDim2.new(0.5, 0, 0.5, -8)
	flagData.value7.AnchorPoint = Vector2.new(0.5, 0.5)
	flagData.value7.BackgroundTransparency = 1
	flagData.value7.ScaleType = Enum.ScaleType.Fit
	flagData.value7.ImageTransparency = 1
	flagData.value7.ZIndex = 7

	if image ~= "" then
		flagData.value7.Image = image
	else
		flagData.value7.Image = flagData.value3
	end

	task.delay(0.15, function()
		local condition = flagData.value7

		if condition then
			condition = flagData.value7.Parent and flagData.value7.Image == "" or flagData.value7.Image == nil
		end

		if condition then
			flagData.value7.Image = flagData.value3
		end
	end)
	task.spawn(function()
		flagData.value2
			:Create(flagData.value7, TweenInfo.new(0.35, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
				ImageTransparency = 0,
			})
			:Play()
		task.delay(0.05, function()
			flagData.value2
				:Create(flagData.value7, TweenInfo.new(0.55, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
					Size = UDim2.new(0, 235, 0, 235),
				})
				:Play()
		end)
		task.delay(0.7, function()
			flagData.value2
				:Create(flagData.value7, TweenInfo.new(0.35, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
					Size = UDim2.new(0, 210, 0, 210),
				})
				:Play()
		end)
		task.delay(0.15, function()
			flagData.value2
				:Create(flagData.value9, TweenInfo.new(0.9, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
					Size = UDim2.new(0, 300, 0, 300),
					BackgroundTransparency = 0.88,
				})
				:Play()
			flagData.value2
				:Create(flagData.value15, TweenInfo.new(0.9, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
					Transparency = 0.65,
				})
				:Play()
		end)
		task.delay(0.25, function()
			flagData.value2
				:Create(flagData.value10, TweenInfo.new(1.1, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
					Size = UDim2.new(0, 390, 0, 390),
					BackgroundTransparency = 0.93,
				})
				:Play()
		end)
	end)
	task.spawn(function()
		local sumNumber = 0

		while not flagData.value6 do
			sumNumber += 0.016

			local product = math.sin(sumNumber * 0.7) * 11
			local number = math.sin(sumNumber * 0.5)
			local secondaryMath = math
			local sum = 1 + number * 0.015
			local rotation = secondaryMath.sin(sumNumber * 0.25) * 0.9

			if flagData.value7 and flagData.value7.Parent then
				flagData.value7.Position = UDim2.new(0.5, 0, 0.5, -8 + product)
				flagData.value7.Rotation = rotation
				flagData.value7.Size = UDim2.new(0, 210 * sum, 0, 210 * sum)
			end

			if flagData.value9 and flagData.value9.Parent then
				local sum = math.sin(sumNumber * 0.65) * 0.02 + 1

				flagData.value9.Size = UDim2.new(0, 300 * sum, 0, 300 * sum)
				flagData.value9.Position = UDim2.new(0.5, 0, 0.5, -8 + product * 0.55)
				flagData.value9.BackgroundTransparency = math.sin(sumNumber * 0.8) * 0.035 + 0.87
			end

			if flagData.value10 and flagData.value10.Parent then
				local sum = math.sin(sumNumber * 0.45) * 0.025 + 1

				flagData.value10.Size = UDim2.new(0, 390 * sum, 0, 390 * sum)
				flagData.value10.Position = UDim2.new(0.5, 0, 0.5, -8 + product * 0.3)
			end

			if flagData.value8 and flagData.value8.Parent then
				local product = math.sin(sumNumber * 0.22) * 7

				flagData.value8.Position = UDim2.new(0.5, 0, 0.5, -20 + product)
				flagData.value8.Rotation = sumNumber * 0.35
				flagData.value14.Position = flagData.value8.Position
			end

			task.wait()
		end
	end)

	local function createFrame(
		productNumber,
		secondaryArgument,
		secondaryCreateFrameNumber,
		createFrameNumber,
		backgroundColor3
	)
		local parent = Instance.new("Frame", flagData.value5)

		parent.Size = UDim2.new(0, secondaryArgument, 0, secondaryArgument)
		parent.AnchorPoint = Vector2.new(0.5, 0.5)
		parent.BackgroundColor3 = backgroundColor3
		parent.BackgroundTransparency = 0.5
		parent.BorderSizePixel = 0
		parent.ZIndex = 5
		Instance.new("UICorner", parent).CornerRadius = UDim.new(1, 0)
		task.spawn(function()
			local backgroundTransparencyNumber = createFrameNumber

			while parent and (parent.Parent and not flagData.value6) do
				backgroundTransparencyNumber += 0.016 * secondaryCreateFrameNumber

				local createFrameNumber = math.cos(backgroundTransparencyNumber)
				local secondaryMath = math
				local product = createFrameNumber * productNumber
				local number = secondaryMath.sin(backgroundTransparencyNumber) * productNumber * 0.7

				parent.Position = UDim2.new(0.5, product, 0.5, -8 + number)
				parent.BackgroundTransparency = 0.4 + math.abs((math.sin(backgroundTransparencyNumber * 1.3))) * 0.35
				task.wait()
			end
		end)
	end

	createFrame(155, 6, 0.65, 0, Color3.fromRGB(180, 210, 255))
	createFrame(165, 5, 0.85, 1.8, Color3.fromRGB(200, 180, 255))
	createFrame(145, 5, 0.55, 3.2, Color3.fromRGB(160, 240, 255))
	createFrame(175, 4, 0.95, 4.5, Color3.fromRGB(255, 255, 255))

	local imageColor3 = Color3.fromRGB(205, 215, 235)
	local parent = Instance.new("Frame", flagData.value5)

	parent.Name = "ChainSpearStage"
	parent.AnchorPoint = Vector2.new(0.5, 0.5)
	parent.Position = UDim2.new(0.5, 0, 0.5, -8)
	parent.Size = UDim2.new(0, 280, 0, 280)
	parent.BackgroundTransparency = 1
	parent.ZIndex = 3

	local data = {
		rot = -1094.822,
		trans = 0.998,
	}
	local secondaryData = {
		rot = -1095.4,
		trans = 0.998,
	}
	local alternateData = {
		rot = -1095.978,
		trans = 0.996,
	}
	local additionalData = {
		rot = -1096.515,
		trans = 0.995,
	}
	local fallbackData = {
		rot = -1097.052,
		trans = 0.993,
	}
	local nestedData = {
		rot = -1097.548,
		trans = 0.991,
	}
	local innerData = {
		rot = -1098.004,
		trans = 0.988,
	}
	local outerData = {
		rot = -1098.419,
		trans = 0.985,
	}
	local previousData = {
		rot = -1098.794,
		trans = 0.982,
	}
	local currentData = {
		rot = -1099.128,
		trans = 0.978,
	}
	local nextData = {
		rot = -1099.421,
		trans = 0.973,
	}

	flagData.value16 = {}

	for i, item in ipairs({
		data,
		secondaryData,
		alternateData,
		additionalData,
		fallbackData,
		nestedData,
		innerData,
		outerData,
		previousData,
		currentData,
		nextData,
	}) do
		local frame = Instance.new("Frame", parent)

		frame.Name = "ChainSpearRotor" .. i
		frame.AnchorPoint = Vector2.new(0.5, 0.5)
		frame.Position = UDim2.new(0.5, 0, 0.5, 0)
		frame.Size = UDim2.new(1, 0, 1, 0)
		frame.BackgroundTransparency = 1
		frame.Rotation = item.rot
		frame.ZIndex = 3

		local ImageLabel = Instance.new("ImageLabel", frame)

		ImageLabel.Name = "ChainSpearTrail" .. i
		ImageLabel.AnchorPoint = Vector2.new(0.73, 0.02)
		ImageLabel.Position = UDim2.new(0.5, 0, 0.5, 0)
		ImageLabel.Size = UDim2.new(0.553, 0, 0.829, 0)
		ImageLabel.BackgroundTransparency = 1
		ImageLabel.Image = "rbxassetid://118963313877514"
		ImageLabel.ImageColor3 = imageColor3
		ImageLabel.ImageTransparency = item.trans
		ImageLabel.ScaleType = Enum.ScaleType.Fit
		ImageLabel.ZIndex = 3
		table.insert(flagData.value16, {
			rotor = frame,
			trail = ImageLabel,
			idx = i,
		})
	end

	task.spawn(function()
		for _, item in ipairs(flagData.value16) do
			local capturedV = item

			task.delay((capturedV.idx - 1) * 0.035, function()
				if flagData.value6 or (not capturedV.trail or not capturedV.trail.Parent) then
					return
				end

				flagData.value2
					:Create(capturedV.trail, TweenInfo.new(0.45, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
						ImageTransparency = 0.12,
					})
					:Play()
			end)
			task.spawn(function()
				local sum = 0.38 + capturedV.idx * 0.045

				while not flagData.value6 and (capturedV.rotor and capturedV.rotor.Parent) do
					capturedV.rotor.Rotation = capturedV.rotor.Rotation + sum
					iData.value4.Heartbeat:Wait()
				end
			end)
		end
	end)
	flagData.value11 = Instance.new("TextLabel", flagData.value5)
	flagData.value11.Name = "TapAnywhere"
	flagData.value11.AnchorPoint = Vector2.new(0.5, 0)
	flagData.value11.Position = UDim2.new(0.5, 0, 0.5, 120)
	flagData.value11.Size = UDim2.new(0, 280, 0, 22)
	flagData.value11.BackgroundTransparency = 1
	flagData.value11.Text = "tap to skip"
	flagData.value11.Font = Enum.Font.Gotham
	flagData.value11.TextSize = 14
	flagData.value11.TextColor3 = Color3.fromRGB(220, 225, 235)
	flagData.value11.TextTransparency = 1
	flagData.value11.TextStrokeTransparency = 0.5
	flagData.value11.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
	flagData.value11.ZIndex = 12
	flagData.value12 = Instance.new("TextLabel", flagData.value5)
	flagData.value12.Name = "DiscordInvite"
	flagData.value12.AnchorPoint = Vector2.new(0.5, 0)
	flagData.value12.Position = UDim2.new(0.5, 0, 0.5, 148)
	flagData.value12.Size = UDim2.new(0, 320, 0, 20)
	flagData.value12.BackgroundTransparency = 1
	flagData.value12.Text = "discord.gg/GGFWZFUJgA"
	flagData.value12.Font = Enum.Font.GothamBold
	flagData.value12.TextSize = 13
	flagData.value12.TextColor3 = Color3.fromRGB(180, 200, 255)
	flagData.value12.TextTransparency = 1
	flagData.value12.TextStrokeTransparency = 0.55
	flagData.value12.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
	flagData.value12.ZIndex = 12
	flagData.value12.Active = false
	flagData.value12.Selectable = false
	task.delay(0.55, function()
		if flagData.value6 then
			return
		end

		if flagData.value11 and flagData.value11.Parent then
			flagData.value2
				:Create(flagData.value11, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
					TextTransparency = 0.15,
				})
				:Play()
		end

		if flagData.value12 and flagData.value12.Parent then
			flagData.value2
				:Create(flagData.value12, TweenInfo.new(0.55, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
					TextTransparency = 0.25,
				})
				:Play()
		end
	end)
	task.spawn(function()
		while not flagData.value6 and (flagData.value11 and flagData.value11.Parent) do
			flagData.value2
				:Create(flagData.value11, TweenInfo.new(0.65, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
					TextTransparency = 0.48,
				})
				:Play()
			task.wait(0.65)

			if flagData.value6 then
				return
			end

			flagData.value2
				:Create(flagData.value11, TweenInfo.new(0.65, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
					TextTransparency = 0.05,
				})
				:Play()
			task.wait(0.65)
		end
	end)
	flagData.value13 = Instance.new("TextButton", flagData.value5)
	flagData.value13.Size = UDim2.new(1, 0, 1, 0)
	flagData.value13.BackgroundTransparency = 1
	flagData.value13.Text = ""
	flagData.value13.ZIndex = 30
	flagData.value13.Active = true
	flagData.value13.AutoButtonColor = false
	flagData.value13.MouseButton1Click:Connect(function()
		if not flagData.value6 then
			updateInstanceProperties()
		end
	end)
	task.delay(15, function()
		if not flagData.value6 then
			updateInstanceProperties()
		end
	end)
end)
iData.value7 = "MoveeSkyTheme"
iData.value8 = "Night"
local off = {
	kind = "off",
}
local sky = {
	stars = 4000,
	moon = 18,
	sun = 0,
	moonTex = true,
}
local night = {
	clock = 22,
	brightness = 2,
	ambient = {
		110,
		100,
		130,
	},
	outAmb = {
		120,
		110,
		140,
	},
	sky = sky,
	atm = {
		dens = 0.45,
		color = {
			120,
			60,
			180,
		},
		decay = {
			60,
			20,
			100,
		},
		glare = 0.5,
		haze = 1.2,
	},
}
local atm = {
	dens = 0.55,
	color = {
		255,
		80,
		200,
	},
	decay = {
		255,
		20,
		150,
	},
	glare = 2.5,
	haze = 3,
}
tpBatData.value1 = {
	clock = 14,
	brightness = 3,
	ambient = {
		150,
		120,
		150,
	},
	outAmb = {
		160,
		130,
		150,
	},
	atm = atm,
	clouds = {
		cover = 0.7,
		dens = 0.7,
		color = {
			255,
			240,
			250,
		},
	},
}
local data = {
	stars = 0,
	sun = 25,
	moon = 0,
}
local secondaryAtm = {
	dens = 0.5,
	color = {
		255,
		130,
		60,
	},
	decay = {
		255,
		80,
		30,
	},
	glare = 2,
	haze = 2.5,
}
local sunset = {
	clock = 17.2,
	brightness = 2.5,
	ambient = {
		170,
		120,
		100,
	},
	outAmb = {
		180,
		130,
		110,
	},
	sky = data,
	atm = secondaryAtm,
	clouds = {
		cover = 0.55,
		dens = 0.55,
		color = {
			255,
			200,
			140,
		},
	},
}
local secondarySky = {
	stars = 10000,
	moon = 30,
	sun = 0,
}
local galaxy = {
	clock = 0,
	brightness = 1.5,
	ambient = {
		70,
		60,
		100,
	},
	outAmb = {
		80,
		70,
		110,
	},
	sky = secondarySky,
	atm = {
		dens = 0.15,
		color = {
			40,
			20,
			80,
		},
		decay = {
			20,
			10,
			50,
		},
		glare = 0.3,
		haze = 0.5,
	},
}
local alternateSky = {
	stars = 2000,
	moon = 12,
}
local alternateAtm = {
	dens = 0.4,
	color = {
		0,
		200,
		255,
	},
	decay = {
		150,
		0,
		255,
	},
	glare = 2,
	haze = 2,
}
local cyber = {
	clock = 21,
	brightness = 2.2,
	ambient = {
		90,
		130,
		170,
	},
	outAmb = {
		100,
		140,
		180,
	},
	sky = alternateSky,
	atm = alternateAtm,
	clouds = {
		cover = 0.4,
		dens = 0.6,
		color = {
			100,
			200,
			255,
		},
	},
}
local additionalSky = {
	sun = 8,
}
local additionalAtm = {
	dens = 0.3,
	color = {
		255,
		200,
		220,
	},
	decay = {
		255,
		170,
		200,
	},
	glare = 1,
	haze = 1.5,
}
local sakura = {
	clock = 11,
	brightness = 3.5,
	ambient = {
		170,
		150,
		160,
	},
	outAmb = {
		180,
		160,
		170,
	},
	sky = additionalSky,
	atm = additionalAtm,
	clouds = {
		cover = 0.6,
		dens = 0.4,
		color = {
			255,
			250,
			252,
		},
	},
}
local fallbackSky = {
	stars = 5000,
	moon = 22,
	sun = 0,
	moonTex = true,
}
local fallbackAtm = {
	dens = 0.5,
	color = {
		255,
		80,
		180,
	},
	decay = {
		140,
		30,
		100,
	},
	glare = 0.7,
	haze = 1.4,
}
local secondaryData = {
	clock = 23,
	brightness = 2.2,
	ambient = {
		120,
		60,
		110,
	},
	outAmb = {
		140,
		70,
		120,
	},
	sky = fallbackSky,
	atm = fallbackAtm,
	clouds = {
		cover = 0.3,
		dens = 0.5,
		color = {
			180,
			90,
			150,
		},
	},
}
local nestedSky = {
	stars = 1500,
	moon = 28,
	sun = 0,
	moonTex = true,
}
local nestedAtm = {
	dens = 0.6,
	color = {
		220,
		30,
		30,
	},
	decay = {
		120,
		10,
		10,
	},
	glare = 1.4,
	haze = 2,
}
local alternateData = {
	clock = 22.5,
	brightness = 1.6,
	ambient = {
		130,
		40,
		40,
	},
	outAmb = {
		150,
		50,
		50,
	},
	sky = nestedSky,
	atm = nestedAtm,
	clouds = {
		cover = 0.5,
		dens = 0.7,
		color = {
			120,
			30,
			30,
		},
	},
}
local innerSky = {
	sun = 18,
	moon = 0,
	stars = 0,
}
local innerAtm = {
	dens = 0.4,
	color = {
		80,
		200,
		140,
	},
	decay = {
		40,
		150,
		90,
	},
	glare = 1.8,
	haze = 2.2,
}
local additionalData = {
	clock = 6.5,
	brightness = 2.8,
	ambient = {
		130,
		170,
		140,
	},
	outAmb = {
		140,
		180,
		150,
	},
	sky = innerSky,
	atm = innerAtm,
	clouds = {
		cover = 0.5,
		dens = 0.5,
		color = {
			200,
			255,
			220,
		},
	},
}
local outerSky = {
	stars = 200,
	sun = 12,
	moon = 0,
}
local outerAtm = {
	dens = 0.75,
	color = {
		255,
		60,
		0,
	},
	decay = {
		180,
		20,
		0,
	},
	glare = 3,
	haze = 3.5,
}
local volcanic = {
	clock = 19,
	brightness = 2,
	ambient = {
		180,
		80,
		40,
	},
	outAmb = {
		200,
		90,
		50,
	},
	sky = outerSky,
	atm = outerAtm,
	clouds = {
		cover = 0.8,
		dens = 0.9,
		color = {
			120,
			40,
			20,
		},
	},
}
local previousSky = {
	sun = 10,
	stars = 0,
	moon = 0,
}
local previousAtm = {
	dens = 0.3,
	color = {
		180,
		220,
		255,
	},
	decay = {
		140,
		200,
		240,
	},
	glare = 1.5,
	haze = 1.8,
}
local arctic = {
	clock = 9,
	brightness = 3.2,
	ambient = {
		200,
		220,
		235,
	},
	outAmb = {
		210,
		230,
		245,
	},
	sky = previousSky,
	atm = previousAtm,
	clouds = {
		cover = 0.7,
		dens = 0.6,
		color = {
			250,
			253,
			255,
		},
	},
}
local currentSky = {
	stars = 6000,
	moon = 24,
	sun = 0,
	moonTex = true,
}
local fallbackData = {
	clock = 1.5,
	brightness = 1.7,
	ambient = {
		60,
		90,
		130,
	},
	outAmb = {
		70,
		100,
		140,
	},
	sky = currentSky,
	atm = {
		dens = 0.5,
		color = {
			20,
			60,
			140,
		},
		decay = {
			10,
			30,
			90,
		},
		glare = 0.6,
		haze = 1.5,
	},
}
local nextSky = {
	stars = 1000,
	moon = 14,
}
local currentAtm = {
	dens = 0.45,
	color = {
		255,
		100,
		220,
	},
	decay = {
		120,
		60,
		255,
	},
	glare = 2.2,
	haze = 2.4,
}
local vaporwave = {
	clock = 19.5,
	brightness = 2.4,
	ambient = {
		180,
		120,
		200,
	},
	outAmb = {
		190,
		130,
		210,
	},
	sky = nextSky,
	atm = currentAtm,
	clouds = {
		cover = 0.5,
		dens = 0.55,
		color = {
			200,
			150,
			255,
		},
	},
}
local nextAtm = {
	dens = 0.55,
	color = {
		100,
		220,
		40,
	},
	decay = {
		60,
		150,
		20,
	},
	glare = 1.8,
	haze = 2.6,
}
local clouds = {
	cover = 0.65,
	dens = 0.7,
	color = {
		180,
		255,
		120,
	},
}
local toxic = {
	clock = 13,
	brightness = 2.5,
	ambient = {
		140,
		180,
		80,
	},
	outAmb = {
		150,
		190,
		90,
	},
	atm = nextAtm,
	clouds = clouds,
}
local sourceSky = {
	stars = 3500,
	sun = 22,
	moon = 0,
}
local nestedData = {
	clock = 12,
	brightness = 0.9,
	ambient = {
		50,
		40,
		60,
	},
	outAmb = {
		60,
		50,
		70,
	},
	sky = sourceSky,
	atm = {
		dens = 0.5,
		color = {
			255,
			140,
			40,
		},
		decay = {
			30,
			20,
			40,
		},
		glare = 2.8,
		haze = 1.8,
	},
}
local targetSky = {
	stars = 100,
	sun = 30,
	moon = 0,
}
local sourceAtm = {
	dens = 0.85,
	color = {
		255,
		30,
		0,
	},
	decay = {
		120,
		0,
		0,
	},
	glare = 3.5,
	haze = 4,
}
local hellscape = {
	clock = 18,
	brightness = 1.8,
	ambient = {
		200,
		60,
		30,
	},
	outAmb = {
		220,
		70,
		40,
	},
	sky = targetSky,
	atm = sourceAtm,
	clouds = {
		cover = 0.95,
		dens = 0.95,
		color = {
			80,
			20,
			10,
		},
	},
}
local skyVariantA = {
	sun = 16,
	moon = 0,
	stars = 0,
}
local targetAtm = {
	dens = 0.25,
	color = {
		255,
		250,
		220,
	},
	decay = {
		255,
		240,
		200,
	},
	glare = 3,
	haze = 1.5,
}
local heaven = {
	clock = 12,
	brightness = 4,
	ambient = {
		240,
		235,
		210,
	},
	outAmb = {
		250,
		245,
		220,
	},
	sky = skyVariantA,
	atm = targetAtm,
	clouds = {
		cover = 0.85,
		dens = 0.5,
		color = {
			255,
			255,
			255,
		},
	},
}
local skyVariantB = {
	stars = 0,
	sun = 6,
	moon = 0,
}
local atmVariantA = {
	dens = 0.65,
	color = {
		80,
		90,
		120,
	},
	decay = {
		40,
		50,
		80,
	},
	glare = 0.5,
	haze = 3,
}
local storm = {
	clock = 15,
	brightness = 1.4,
	ambient = {
		90,
		90,
		110,
	},
	outAmb = {
		100,
		100,
		120,
	},
	sky = skyVariantB,
	atm = atmVariantA,
	clouds = {
		cover = 0.95,
		dens = 0.95,
		color = {
			60,
			65,
			80,
		},
	},
}
local skyVariantC = {
	sun = 22,
	stars = 0,
	moon = 0,
}
local atmVariantB = {
	dens = 0.45,
	color = {
		255,
		180,
		100,
	},
	decay = {
		255,
		140,
		80,
	},
	glare = 2.4,
	haze = 2.2,
}
local sunrise = {
	clock = 6.2,
	brightness = 2.8,
	ambient = {
		220,
		180,
		130,
	},
	outAmb = {
		230,
		190,
		140,
	},
	sky = skyVariantC,
	atm = atmVariantB,
	clouds = {
		cover = 0.4,
		dens = 0.4,
		color = {
			255,
			220,
			180,
		},
	},
}
local skyVariantD = {
	stars = 15000,
	moon = 0,
	sun = 0,
}
local innerData = {
	clock = 0,
	brightness = 1,
	ambient = {
		30,
		25,
		50,
	},
	outAmb = {
		40,
		35,
		60,
	},
	sky = skyVariantD,
	atm = {
		dens = 0.08,
		color = {
			15,
			5,
			40,
		},
		decay = {
			5,
			0,
			20,
		},
		glare = 0.2,
		haze = 0.3,
	},
}
local skyVariantE = {
	stars = 800,
	moon = 16,
	sun = 0,
}
local atmVariantC = {
	dens = 0.4,
	color = {
		200,
		160,
		255,
	},
	decay = {
		160,
		120,
		220,
	},
	glare = 1.4,
	haze = 1.8,
}
local outerData = {
	clock = 18.5,
	brightness = 2.6,
	ambient = {
		180,
		160,
		220,
	},
	outAmb = {
		190,
		170,
		230,
	},
	sky = skyVariantE,
	atm = atmVariantC,
	clouds = {
		cover = 0.55,
		dens = 0.5,
		color = {
			220,
			200,
			255,
		},
	},
}
local skyVariantF = {
	sun = 26,
	moon = 0,
	stars = 0,
}
local atmVariantD = {
	dens = 0.6,
	color = {
		255,
		90,
		20,
	},
	decay = {
		200,
		40,
		0,
	},
	glare = 3,
	haze = 3.2,
}
local inferno = {
	clock = 17.5,
	brightness = 2.2,
	ambient = {
		220,
		100,
		40,
	},
	outAmb = {
		235,
		110,
		50,
	},
	sky = skyVariantF,
	atm = atmVariantD,
	clouds = {
		cover = 0.7,
		dens = 0.7,
		color = {
			200,
			80,
			40,
		},
	},
}
local skyVariantG = {
	sun = 10,
}
local atmVariantE = {
	dens = 0.32,
	color = {
		150,
		255,
		210,
	},
	decay = {
		100,
		220,
		180,
	},
	glare = 1.6,
	haze = 1.6,
}
tpBatData.value1 = {
	Off = off,
	Night = night,
	Aurora = tpBatData.value1,
	Sunset = sunset,
	Galaxy = galaxy,
	Cyber = cyber,
	Sakura = sakura,
	["Pink Night"] = secondaryData,
	["Blood Moon"] = alternateData,
	["Emerald Dawn"] = additionalData,
	Volcanic = volcanic,
	Arctic = arctic,
	["Midnight Ocean"] = fallbackData,
	Vaporwave = vaporwave,
	Toxic = toxic,
	["Solar Eclipse"] = nestedData,
	Hellscape = hellscape,
	Heaven = heaven,
	Storm = storm,
	Sunrise = sunrise,
	["Deep Space"] = innerData,
	["Lavender Dream"] = outerData,
	Inferno = inferno,
	["Mint Sky"] = {
		clock = 10,
		brightness = 3.2,
		ambient = {
			180,
			230,
			210,
		},
		outAmb = {
			190,
			240,
			220,
		},
		sky = skyVariantG,
		atm = atmVariantE,
		clouds = {
			cover = 0.55,
			dens = 0.45,
			color = {
				240,
				255,
				250,
			},
		},
	},
}
iData.value9 = tpBatData.value1
iData.value10 = {
	"Off",
	"Night",
	"Aurora",
	"Sunset",
	"Galaxy",
	"Cyber",
	"Sakura",
	"Pink Night",
	"Blood Moon",
	"Emerald Dawn",
	"Volcanic",
	"Arctic",
	"Midnight Ocean",
	"Vaporwave",
	"Toxic",
	"Solar Eclipse",
	"Hellscape",
	"Heaven",
	"Storm",
	"Sunrise",
	"Deep Space",
	"Lavender Dream",
	"Inferno",
	"Mint Sky",
}
function candyColor(data)
	return Color3.fromRGB(data[1], data[2], data[3])
end
function CandyApplyCustomSky(argument)
	for _, child in ipairs(iData.value5:GetChildren()) do
		local capturedChild = child

		if capturedChild:GetAttribute(iData.value7) then
			pcall(function()
				capturedChild:Destroy()
			end)
		end
	end

	local Terrain = workspace:FindFirstChildOfClass("Terrain")

	if Terrain then
		local GetChildren = Terrain.GetChildren

		for _, item in ipairs(GetChildren(Terrain)) do
			local capturedV = item

			if capturedV:GetAttribute(iData.value7) then
				pcall(function()
					capturedV:Destroy()
				end)
			end
		end
	end

	local hazeFlag = iData.value9[argument]

	if not hazeFlag or hazeFlag.kind == "off" then
		iData.value5.ClockTime = 14
		iData.value5.Brightness = 2
		iData.value5.OutdoorAmbient = Color3.fromRGB(127, 127, 127)
		iData.value5.Ambient = Color3.fromRGB(127, 127, 127)
		iData.value5.FogEnd = 100000
		iData.value5.GlobalShadows = true

		return
	end

	iData.value5.FogStart = 0
	iData.value5.FogEnd = 100000
	iData.value5.FogColor = Color3.fromRGB(200, 200, 200)
	iData.value5.ColorShift_Top = Color3.fromRGB(0, 0, 0)
	iData.value5.ColorShift_Bottom = Color3.fromRGB(0, 0, 0)
	iData.value5.GlobalShadows = true
	iData.value5.ClockTime = hazeFlag.clock or 14
	iData.value5.Brightness = hazeFlag.brightness or 2

	if hazeFlag.outAmb then
		iData.value5.OutdoorAmbient = candyColor(hazeFlag.outAmb)
	end

	if hazeFlag.ambient then
		iData.value5.Ambient = candyColor(hazeFlag.ambient)
	end

	if hazeFlag.sky then
		local Sky = Instance.new("Sky")

		Sky:SetAttribute(iData.value7, true)

		if hazeFlag.sky.stars then
			Sky.StarCount = hazeFlag.sky.stars
		end

		if hazeFlag.sky.moon then
			Sky.MoonAngularSize = hazeFlag.sky.moon
		end

		if hazeFlag.sky.sun then
			Sky.SunAngularSize = hazeFlag.sky.sun
		end

		if hazeFlag.sky.moonTex then
			Sky.MoonTextureId = "rbxasset://sky/moon.jpg"
		end

		Sky.Parent = iData.value5
	end

	if hazeFlag.atm then
		local Atmosphere = Instance.new("Atmosphere")

		Atmosphere:SetAttribute(iData.value7, true)
		Atmosphere.Density = hazeFlag.atm.dens or 0.3
		Atmosphere.Color = candyColor(hazeFlag.atm.color)
		Atmosphere.Decay = candyColor(hazeFlag.atm.decay)
		Atmosphere.Glare = hazeFlag.atm.glare or 1
		Atmosphere.Haze = hazeFlag.atm.haze or 1
		Atmosphere.Parent = iData.value5
	end

	if hazeFlag.clouds and Terrain then
		local Clouds = Instance.new("Clouds")

		Clouds:SetAttribute(iData.value7, true)
		Clouds.Cover = hazeFlag.clouds.cover or 0.5
		Clouds.Density = hazeFlag.clouds.dens or 0.5
		Clouds.Color = candyColor(hazeFlag.clouds.color)
		Clouds.Parent = Terrain
	end
end
iData.value11 = iData.value1.LocalPlayer
function loadCustomImageAsset(url, optionFlag)
	if not url or url == "" then
		return ""
	end
	local resultOption = optionFlag or "void_img_" .. tostring((math.floor(tick() * 1000))) .. ".png"
	local function handleResult(resultOption)
		local iteratorData = {
			getcustomasset,
			getsynasset,
			getasset,
		}
		local iterator, state, control = ipairs(iteratorData)
		local result

		repeat
			local capturedResultCallback

			repeat
				local resultCallback

				control, resultCallback = iterator(state, control)

				if not control then
					if typeof(getcustomasset) == "function" then
						local ok, okResult = pcall(function()
							return getcustomasset(resultOption, true)
						end)

						if ok then
							ok = type(okResult) == "string" and okResult ~= ""
						end

						if ok then
							return okResult
						end
					end

					return ""
				end

				capturedResultCallback = resultCallback
			until typeof(capturedResultCallback) == "function"

			local ok

			ok, result = pcall(function()
				return capturedResultCallback(resultOption)
			end)

			if ok then
				ok = type(result) == "string" and result ~= ""
			end
		until ok

		return result
	end
	if isfile and isfile(resultOption) then
		local result = handleResult(resultOption)

		if result ~= "" then
			return result
		end
	end
	local capturedResult
	pcall(function()
		local source = game:HttpGet(url)

		if source and #source > 80 then
			capturedResult = source
		end
	end)
	if not capturedResult then
		local conditionOption = syn and syn.request

		if not conditionOption then
			conditionOption = http and http.request or (http.Request or (request or http_request))
		end

		local callbackCondition = conditionOption

		if callbackCondition then
			local ok, result = pcall(function()
				local callback = callbackCondition
				local secondaryUrl = url
				local headers = {
					["User-Agent"] = "Mozilla/5.0",
				}

				return callback({
					Url = secondaryUrl,
					Method = "GET",
					Headers = headers,
				})
			end)

			if ok and type(result) == "table" then
				capturedResult = result.Body or (result.body or (result.Data or result.data))
			elseif ok and type(result) == "string" then
				capturedResult = result
			end
		end
	end
	if not capturedResult or #capturedResult < 80 then
		return url
	end
	pcall(function()
		if writefile then
			writefile(resultOption, capturedResult)
		end
	end)
	task.wait(0.05)
	local result = handleResult(resultOption)
	if result ~= "" then
		return result
	end

	return url
end
iData.value12 = 59
iData.value13 = 29
iData.value14 = 30
iData.value15 = 15
iData.value16 = false
iData.value17 = false
iData.value18 = false
iData.value19 = false
iData.value20 = false
iData.value21 = false
iData.value22 = false
iData.value23 = false
iData.value24 = 0
iData.value25 = false
iData.value26 = {
	antiKick = true,
	brainrot = false,
	tpBat = false,
	batV2 = false,
	tpConn = nil,
	v2Conn = nil,
	v2Rot = nil,
	hitCD = false,
	v2CD = false,
}
iData.value27 = false
iData.value28 = false
iData.value29 = nil
iData.value30 = nil
iData.value31 = false
iData.value32 = false
iData.value33 = 56.5
iData.value34 = nil
iData.value35 = 0
iData.value36 = false
iData.value37 = 3
iData.value38 = -7
iData.value39 = {}
iData.value40 = 0
function iData.value41()
	local flag = iData.value31 == true

	if not flag then
		flag = iData.value32 == true or iData.value26 and iData.value26.batV2 == true
	end

	return flag
end
local function updateInstanceProperties()
	local Character = iData.value11.Character
	local input = Character and Character:FindFirstChild("HumanoidRootPart")
	local updateInstancePropertiesOption = Character and Character:FindFirstChildOfClass("Humanoid")

	if not input or (not updateInstancePropertiesOption or updateInstancePropertiesOption.Health <= 0) then
		return
	end

	if tick() - (iData.value40 or 0) < 0.08 then
		return
	end

	local _, toEulerAnglesYxz = input.CFrame:ToEulerAnglesYXZ()
	local updateInstancePropertiesNumber = (iData.value38 or -7) + (math.random() * 0.6 - 0.3)

	input.CFrame = CFrame.new(input.Position.X, updateInstancePropertiesNumber, input.Position.Z)
		* CFrame.Angles(0, toEulerAnglesYxz, 0)
	input.AssemblyLinearVelocity = Vector3.new((math.random() - 0.5) * 0.4, 0, (math.random() - 0.5) * 0.4)
end
iData.value4.Heartbeat:Connect(function()
	if not iData.value36 or not iData.value41() then
		if next(iData.value39) then
			table.clear(iData.value39)
		end

		return
	end

	for _, player in ipairs(iData.value1:GetPlayers()) do
		if not (player ~= iData.value11 and player.Character) then
			continue
		end

		local HumanoidRootPart = player.Character:FindFirstChild("HumanoidRootPart")

		if not HumanoidRootPart then
			continue
		end

		local PositionY = HumanoidRootPart.Position.Y
		local userId = iData.value39[player.UserId]

		if userId and userId - PositionY >= (iData.value37 or 3) then
			pcall(updateInstanceProperties)
			table.clear(iData.value39)

			return
		end

		iData.value39[player.UserId] = PositionY
	end
end)
tpBatData.value1 = Color3
tpBatData.value1 = tpBatData.value1.fromRGB(255, 255, 255)

local purple = Color3.fromRGB(207, 159, 255)
local blue = Color3.fromRGB(58, 128, 245)
local red = Color3.fromRGB(232, 52, 68)
local pink = Color3.fromRGB(255, 105, 180)
local yellow = Color3.fromRGB(255, 214, 0)
local grey = Color3.fromRGB(90, 90, 90)
local forest = Color3.fromRGB(46, 139, 87)

iData.value42 = {
	WHITE = tpBatData.value1,
	PURPLE = purple,
	BLUE = blue,
	RED = red,
	PINK = pink,
	YELLOW = yellow,
	GREY = grey,
	FOREST = forest,
}
iData.value43 = "WHITE"
function iData.value44()
	return iData.value42[iData.value43] or iData.value42.WHITE
end
iData.value45 = nil
function iData.value45(argument, secondaryArgument, clampedValueFlag)
	local clampedValue = math.clamp(clampedValueFlag or 0.5, 0, 1)

	return Color3.new(
		argument.R + (secondaryArgument.R - argument.R) * clampedValue,
		argument.G + (secondaryArgument.G - argument.G) * clampedValue,
		argument.B + (secondaryArgument.B - argument.B) * clampedValue
	)
end
function iData.value46()
	local blue = iData.value44()
	pcall(function()
		if C then
			local fromRgbResult = Color3.fromRGB(6, 6, 6)
			local secondaryFromRgbResult = Color3.fromRGB(3, 3, 3)

			C.blue = blue
			C.blueDim = iData.value45(blue, Color3.fromRGB(40, 40, 40), 0.55)
			C.blueDark = iData.value45(secondaryFromRgbResult, blue, 0.12)
			C.bg = iData.value45(fromRgbResult, blue, 0.06)
			C.bgDark = iData.value45(secondaryFromRgbResult, blue, 0.04)
			C.row = iData.value45(Color3.fromRGB(16, 16, 16), blue, 0.1)
			C.input = iData.value45(Color3.fromRGB(16, 16, 16), blue, 0.08)
			C.divider = iData.value45(Color3.fromRGB(32, 32, 32), blue, 0.25)
			C.text = Color3.fromRGB(255, 255, 255)
			C.textDim = iData.value45(Color3.fromRGB(160, 160, 160), blue, 0.25)
			C.textMuted = iData.value45(Color3.fromRGB(100, 100, 100), blue, 0.2)
			C.white = Color3.fromRGB(255, 255, 255)
		end

		local function updateInstanceProperties(updateInstancePropertiesFlag)
			if not updateInstancePropertiesFlag then
				return
			end

			for _, descendant in ipairs(updateInstancePropertiesFlag:GetDescendants()) do
				if descendant.Name == "VoidTitle" and descendant:IsA("ImageLabel") or descendant:IsA("ImageButton") then
					descendant.ImageColor3 = blue
				end

				if descendant:IsA("UIStroke") then
					local updateInstancePropertiesOption = descendant.Parent and descendant.Parent.Name or ""

					if
						updateInstancePropertiesOption == "LogoCircle"
						or (
							updateInstancePropertiesOption == "VoidOpenPill"
							or updateInstancePropertiesOption == "MiniBtn"
						)
					then
						descendant.Color = blue
					elseif descendant.Thickness and descendant.Thickness >= 1.5 then
						descendant.Color = iData.value45(Color3.fromRGB(45, 45, 45), blue, 0.55)
					else
						descendant.Color = iData.value45(C.divider, blue, 0.35)
					end
				end

				if descendant:IsA("Frame") or (descendant:IsA("TextButton") or descendant:IsA("ImageButton")) then
					local descendantBackgroundColor3 = descendant.BackgroundColor3

					if descendantBackgroundColor3 then
						local updateInstancePropertiesNumber = descendantBackgroundColor3.R * 255
						local product = descendantBackgroundColor3.G * 255
						local number = descendantBackgroundColor3.B * 255
						local secondaryMath = math
						local quotient = (updateInstancePropertiesNumber + product + number) / 3
						local difference = secondaryMath.max(updateInstancePropertiesNumber, product, number)
							- math.min(updateInstancePropertiesNumber, product, number)

						if difference < 35 and quotient < 55 then
							descendant.BackgroundColor3 = iData.value45(
								Color3.fromRGB(updateInstancePropertiesNumber, product, number),
								blue,
								0.14
							)
						elseif difference < 40 and quotient < 90 then
							descendant.BackgroundColor3 = iData.value45(
								Color3.fromRGB(updateInstancePropertiesNumber, product, number),
								blue,
								0.18
							)
						end
					end
				end

				if descendant:IsA("TextLabel") or descendant:IsA("TextButton") then
					local descendantTextColor3 = descendant.TextColor3

					if descendantTextColor3 then
						local updateInstancePropertiesNumber = descendantTextColor3.R * 255
						local product = descendantTextColor3.G * 255
						local number = descendantTextColor3.B * 255
						local secondaryMath = math
						local quotient = (updateInstancePropertiesNumber + product + number) / 3
						local difference = secondaryMath.max(updateInstancePropertiesNumber, product, number)
							- math.min(updateInstancePropertiesNumber, product, number)

						if difference < 30 and (quotient > 120 and quotient < 200) then
							descendant.TextColor3 = iData.value45(
								Color3.fromRGB(updateInstancePropertiesNumber, product, number),
								blue,
								0.35
							)
						elseif
							(not (difference < 25) or not (quotient >= 200))
							and (difference > 40 and quotient > 100)
						then
							descendant.TextColor3 = iData.value45(descendantTextColor3, blue, 0.65)
						end
					end
				end

				if not (descendant:IsA("UIGradient") and descendant.Parent) then
				end
			end
		end

		if GuiRefs then
			if GuiRefs.outer then
				GuiRefs.outer.BackgroundColor3 = C.bgDark
				updateInstanceProperties(GuiRefs.outer)
			end

			if GuiRefs.inner then
				GuiRefs.inner.BackgroundColor3 = C.bg
				updateInstanceProperties(GuiRefs.inner)
			end

			if GuiRefs.chromeGroup then
				updateInstanceProperties(GuiRefs.chromeGroup)
			end

			if GuiRefs.hub then
				updateInstanceProperties(GuiRefs.hub)
			end

			if GuiRefs.bgGrad then
				GuiRefs.bgGrad.BackgroundColor3 = C.bgDark
			end

			if GuiRefs.voidTitle then
				if GuiRefs.voidTitle:IsA("ImageLabel") or GuiRefs.voidTitle:IsA("ImageButton") then
					GuiRefs.voidTitle.ImageColor3 = blue
				elseif GuiRefs.voidTitle:IsA("TextLabel") then
					GuiRefs.voidTitle.TextColor3 = blue
				end
			end

			if GuiRefs.categoryList then
				updateInstanceProperties(GuiRefs.categoryList)
			end

			if GuiRefs.contentFrame then
				updateInstanceProperties(GuiRefs.contentFrame)
			end
		end

		if mobGuiRef then
			for _, descendant in ipairs(mobGuiRef:GetDescendants()) do
				if descendant:IsA("UIStroke") then
					descendant.Color = blue
				end

				if
					descendant:IsA("ImageLabel") and descendant.Name == "BtnImage"
					or descendant.Name == "MobileBackgroundImage"
				then
					descendant.ImageColor3 = blue
				end

				if descendant:IsA("Frame") or descendant:IsA("TextButton") then
					local descendantBackgroundColor3 = descendant.BackgroundColor3

					if descendantBackgroundColor3 then
						local product = descendantBackgroundColor3.R * 255
						local number = descendantBackgroundColor3.G * 255
						local secondaryProduct = descendantBackgroundColor3.B * 255
						local quotient = (product + number + secondaryProduct) / 3

						if
							math.max(product, number, secondaryProduct)
									- math.min(product, number, secondaryProduct)
								< 40
							and quotient < 80
						then
							descendant.BackgroundColor3 =
								iData.value45(Color3.fromRGB(product, number, secondaryProduct), blue, 0.16)
						end
					end
				end
			end
		end

		if stealBarFrame then
			local UIStroke = stealBarFrame:FindFirstChildOfClass("UIStroke")

			if UIStroke then
				UIStroke.Color = blue
			end

			for _, descendant in ipairs(stealBarFrame:GetDescendants()) do
				if descendant:IsA("UIStroke") then
					descendant.Color = iData.value45(descendant.Color, blue, 0.5)
				end
			end
		end
	end)
end
iData.value47 = false
iData.value48 = false
iData.value49 = true
iData.value50 = false
iData.value51 = 0.3
iData.value52 = false
iData.value53 = false
iData.value54 = nil
iData.value55 = nil
iData.value56 = nil
iData.value57 = false
iData.value58 = false
iData.value59 = nil
iData.value60 = false
iData.value61 = nil
iData.value62 = nil
iData.value63 = false
iData.value64 = 20
iData.value65 = nil
iData.value66 = false
iData.value67 = true
iData.value68 = false
iData.value69 = true
iData.value70 = nil
iData.value71 = false
iData.value72 = nil
iData.value73 = 80
iData.value74 = false
iData.value75 = nil
iData.value76 = 2
iData.value77 = 1
iData.value78 = {}
iData.value79 = nil
iData.value80 = 80
iData.value81 = {
	80,
	120,
	180,
}
iData.value82 = 1
iData.value83 = nil
iData.value84 = nil
iData.value85 = false
iData.value86 = false
iData.value87 = "OFF"
iData.value88 = false
iData.value89 = false
iData.value90 = "rbxassetid://1095708"
iData.value91 = "rbxassetid://101851696"
iData.value92 = "rbxassetid://101851254"
iData.value93 = Color3.fromRGB(64, 64, 64)

function iData.value94(faceContainer)
	local face = faceContainer:FindFirstChild("face")

	if face then
		face:Destroy()
	end
end
function applyHeadlessToChar(headContainer, condition)
	if not headContainer then
		return
	end

	local Head = headContainer:FindFirstChild("Head")

	if not Head then
		return
	end

	if condition then
		Head.Transparency = 1
		Head.CanCollide = false
		iData.value94(Head)

		for _, child in ipairs(Head:GetChildren()) do
			if child:IsA("SpecialMesh") and child.Name == "HeadlessMesh" or child.MeshId == iData.value90 then
				child:Destroy()
			end
		end

		local SpecialMesh = Instance.new("SpecialMesh")

		SpecialMesh.MeshType = Enum.MeshType.FileMesh
		SpecialMesh.MeshId = iData.value90
		SpecialMesh.Scale = Vector3.new(0.001, 0.001, 0.001)
		SpecialMesh.Name = "HeadlessMesh"
		SpecialMesh.Parent = Head
		Head:GetPropertyChangedSignal("Transparency"):Connect(function()
			if Head.Transparency ~= 1 then
				Head.Transparency = 1
			end
		end)
		Head.ChildAdded:Connect(function(child)
			if child.Name == "face" and child:IsA("Decal") then
				child:Destroy()
			end
		end)

		return
	end

	Head.Transparency = 0
	Head.CanCollide = true

	for _, child in ipairs(Head:GetChildren()) do
		if child:IsA("SpecialMesh") and child.Name == "HeadlessMesh" then
			child:Destroy()
		end
	end
end
function applyKorbloxToChar(rightLegContainer, condition)
	if not rightLegContainer then
		return
	end

	local Humanoid = rightLegContainer:FindFirstChildOfClass("Humanoid")

	if not Humanoid then
		return
	end

	if condition then
		if Humanoid.RigType == Enum.HumanoidRigType.R6 then
			local parent = rightLegContainer:FindFirstChild("Right Leg")

			if parent then
				local GetChildren = parent.GetChildren

				for _, item in ipairs(GetChildren(parent)) do
					if item:IsA("SpecialMesh") and item.Name == "KorbloxMesh" then
						item:Destroy()
					end
				end

				local SpecialMesh = Instance.new("SpecialMesh")

				SpecialMesh.MeshType = Enum.MeshType.FileMesh
				SpecialMesh.MeshId = iData.value91
				SpecialMesh.TextureId = iData.value92
				SpecialMesh.Scale = Vector3.new(1, 1, 1)
				SpecialMesh.Name = "KorbloxMesh"
				SpecialMesh.Parent = parent
				parent.Color = iData.value93

				return
			end
		elseif Humanoid.RigType == Enum.HumanoidRigType.R15 then
			local RightUpperLeg = rightLegContainer:FindFirstChild("RightUpperLeg")

			if RightUpperLeg then
				RightUpperLeg.Transparency = 1

				local RightLowerLeg = rightLegContainer:FindFirstChild("RightLowerLeg")
				local RightFoot = rightLegContainer:FindFirstChild("RightFoot")

				if RightLowerLeg then
					RightLowerLeg.Transparency = 1
				end

				if RightFoot then
					RightFoot.Transparency = 1
				end

				local KorbloxLeg = rightLegContainer:FindFirstChild("KorbloxLeg")

				if KorbloxLeg then
					KorbloxLeg:Destroy()
				end

				local Part = Instance.new("Part")

				Part.Name = "KorbloxLeg"
				Part.Size = Vector3.new(1, 2, 1)
				Part.Anchored = false
				Part.CanCollide = false
				Part.Color = iData.value93
				Part.Parent = rightLegContainer

				local SpecialMesh = Instance.new("SpecialMesh")

				SpecialMesh.MeshType = Enum.MeshType.FileMesh
				SpecialMesh.MeshId = iData.value91
				SpecialMesh.TextureId = iData.value92
				SpecialMesh.Scale = Vector3.new(1, 1, 1)
				SpecialMesh.Name = "KorbloxMesh"
				SpecialMesh.Parent = Part

				local Weld = Instance.new("Weld")

				Weld.Part0 = RightUpperLeg
				Weld.Part1 = Part
				Weld.C0 = CFrame.new(0, -0.8, 0)
				Weld.Name = "KorbloxWeld"
				Weld.Parent = Part

				return
			end
		end
	elseif Humanoid.RigType == Enum.HumanoidRigType.R6 then
		local rightLeg = rightLegContainer:FindFirstChild("Right Leg")

		if rightLeg then
			for _, child in ipairs(rightLeg:GetChildren()) do
				if child:IsA("SpecialMesh") and child.Name == "KorbloxMesh" then
					child:Destroy()
				end
			end

			rightLeg.Color = Color3.fromRGB(255, 255, 255)

			return
		end
	elseif Humanoid.RigType == Enum.HumanoidRigType.R15 then
		local RightUpperLeg = rightLegContainer:FindFirstChild("RightUpperLeg")

		if RightUpperLeg then
			RightUpperLeg.Transparency = 0

			local RightLowerLeg = rightLegContainer:FindFirstChild("RightLowerLeg")
			local RightFoot = rightLegContainer:FindFirstChild("RightFoot")

			if RightLowerLeg then
				RightLowerLeg.Transparency = 0
			end

			if RightFoot then
				RightFoot.Transparency = 0
			end

			local KorbloxLeg = rightLegContainer:FindFirstChild("KorbloxLeg")

			if KorbloxLeg then
				KorbloxLeg:Destroy()
			end
		end
	end
end
function applyCharterToChar(flag)
	if not flag then
		return
	end

	applyHeadlessToChar(flag, iData.value88)
	applyKorbloxToChar(flag, iData.value89)
end
iData.value95 = {
	"OFF",
	"Adidas Sports",
	"Adidas Community",
	"Adidas Aura",
	"Wicked Popular",
	"Elder",
	"Zombie",
	"Mage",
	"Catwalk Glam",
	"Astronaut",
}
local value96Data = {
	WalkAnim = 18537392113,
	RunAnim = 18537384940,
	JumpAnim = 18537380791,
	FallAnim = 18537367238,
	ClimbAnim = 18537363391,
	Animation1 = 18537376492,
	Animation2 = 18537371272,
}
local secondaryValue96Data = {
	WalkAnim = 122150855457010,
	RunAnim = 82598234841035,
	JumpAnim = 75290611992385,
	FallAnim = 98600215928904,
	ClimbAnim = 88763136693023,
	Animation1 = 122257458498460,
	Animation2 = 102357151005770,
}
tpBatData.value1 = {
	WalkAnim = 83842218823011,
	RunAnim = 118320322718866,
	JumpAnim = 109996626521200,
	FallAnim = 95603166884636,
	ClimbAnim = 97824616490448,
	Animation1 = 110211186840350,
	Animation2 = 114191137265065,
}
local alternateValue96Data = {
	WalkAnim = 92072849924640,
	RunAnim = 72301599441680,
	JumpAnim = 104325245285200,
	FallAnim = 121152442762481,
	ClimbAnim = 131326830509780,
	Animation1 = 118832222982050,
	Animation2 = 76049494037641,
}
local elder = {
	WalkAnim = 10921111375,
	RunAnim = 10921104374,
	JumpAnim = 10921107367,
	FallAnim = 10921105765,
	ClimbAnim = 10921100400,
	Animation1 = 10921101664,
	Animation2 = 10921102574,
}
local zombie = {
	WalkAnim = 10921355261,
	RunAnim = 616163682,
	JumpAnim = 10921351278,
	FallAnim = 10921350320,
	ClimbAnim = 10921343576,
	Animation1 = 10921344533,
	Animation2 = 10921345304,
}
local mage = {
	WalkAnim = 10921152678,
	RunAnim = 10921148209,
	JumpAnim = 10921149743,
	FallAnim = 10921148939,
	ClimbAnim = 10921143404,
	Animation1 = 10921144709,
	Animation2 = 10921145797,
}
local additionalValue96Data = {
	WalkAnim = 109168724482750,
	RunAnim = 81024476153754,
	JumpAnim = 116936326516980,
	FallAnim = 92294537340807,
	ClimbAnim = 119377220967554,
	Animation1 = 133806214992290,
	Animation2 = 94970088341563,
}
iData.value96 = {
	["Adidas Sports"] = value96Data,
	["Adidas Community"] = secondaryValue96Data,
	["Adidas Aura"] = tpBatData.value1,
	["Wicked Popular"] = alternateValue96Data,
	Elder = elder,
	Zombie = zombie,
	Mage = mage,
	["Catwalk Glam"] = additionalValue96Data,
	Astronaut = {
		WalkAnim = 10921046031,
		RunAnim = 10921039308,
		JumpAnim = 10921042494,
		FallAnim = 10921040576,
		ClimbAnim = 10921032124,
		Animation1 = 10921034824,
		Animation2 = 10921036806,
	},
}
iData.value97 = {}
iData.value98 = true
iData.value99 = nil
iData.value100 = nil
iData.value101 = true
iData.value102 = false
iData.value103 = "manual"
iData.value104 = nil
iData.value105 = 0.2
iData.value106 = 150
iData.value107 = nil
iData.value108 = false
iData.value109 = true
iData.value110 = {
	folder = nil,
	conns = {},
	labels = {},
}
iData.value111 = false
iData.value112 = 0
iData.value113 = nil
tpBatData.value1 = {
	url = "https://files.catbox.moe/pk5a3v.jpeg",
	file = "void_bg_1.jpeg",
}
local value114Data = {
	url = "https://files.catbox.moe/v8y0ak.png",
	file = "void_bg_2.png",
}
local sl73HbPng = {
	url = "https://files.catbox.moe/sl73hb.png",
	file = "void_bg_3.png",
}
iData.value114 = {
	tpBatData.value1,
	value114Data,
	sl73HbPng,
	{
		url = "https://files.catbox.moe/ptt187.png",
		file = "void_bg_4.png",
	},
}
iData.value115 = {}
function iData.value116(argument)
	local iteratorData = {
		getcustomasset,
		getsynasset,
		getasset,
	}
	local iterator, state, control = ipairs(iteratorData)
	local result

	repeat
		local capturedCallback

		repeat
			local callback

			control, callback = iterator(state, control)

			if not control then
				if typeof(getcustomasset) == "function" then
					local ok, okResult = pcall(function()
						return getcustomasset(argument, true)
					end)

					if ok then
						ok = type(okResult) == "string" and okResult ~= ""
					end

					if ok then
						return okResult
					end
				end

				return ""
			end

			capturedCallback = callback
		until typeof(capturedCallback) == "function"

		local ok

		ok, result = pcall(function()
			return capturedCallback(argument)
		end)

		if ok then
			ok = type(result) == "string" and result ~= ""
		end
	until ok

	return result
end
function iData.value117(urlArgument)
	if isfile and isfile(urlArgument.file) then
		local value116Result = iData.value116(urlArgument.file)

		if value116Result ~= "" then
			return value116Result
		end
	end
	local capturedResult
	local ok, result = pcall(function()
		return game:HttpGet(urlArgument.url)
	end)
	if ok then
		ok = result and #result > 100
	end
	if ok then
		capturedResult = result
	end
	if not capturedResult then
		local flagCallback = http and http.request

		if not flagCallback then
			flagCallback = request or syn and syn.request
		end

		if flagCallback then
			local capturedResultFlag = flagCallback({
				Url = urlArgument.url,
				Method = "GET",
			})

			if capturedResultFlag and (capturedResultFlag.Body and #capturedResultFlag.Body > 100) then
				capturedResult = capturedResultFlag.Body
			end
		end
	end
	if not capturedResult then
		return ""
	end
	pcall(function()
		writefile(urlArgument.file, capturedResult)
	end)
	task.wait(0.05)

	return iData.value116(urlArgument.file)
end
task.spawn(function()
	for i, item in ipairs(iData.value114) do
		local iFlag = iData.value117(item)

		iData.value115[i] = iFlag ~= "" and iFlag or item.url
	end
end)

function applyBackgroundImage(value112Flag)
	iData.value112 = value112Flag or 0

	if not iData.value113 then
		return
	end

	if iData.value112 == 0 then
		iData.value113.Image = ""
		iData.value113.Visible = false
		iData.value111 = false

		return
	end

	local image = iData.value115[iData.value112]
	local imageFlag = iData.value114[iData.value112]

	if not image or image == "" and imageFlag then
		image = iData.value117(imageFlag)

		if image == "" then
			image = imageFlag.url
		end

		iData.value115[iData.value112] = image
	end

	if image and image ~= "" then
		iData.value113.Image = image
		iData.value113.Visible = true
		iData.value111 = true
	end
end
function espClear()
	for key, item in pairs(iData.value110.conns) do
		local capturedItem = item

		pcall(function()
			capturedItem:Disconnect()
		end)
	end
	iData.value110.conns = {}
	for _, item in pairs(iData.value110.labels) do
		local capturedV = item

		pcall(function()
			if capturedV.billboard then
				capturedV.billboard:Destroy()
			end
		end)
		pcall(function()
			if capturedV.avatarBillboard then
				capturedV.avatarBillboard:Destroy()
			end
		end)
		pcall(function()
			if capturedV.highlight then
				capturedV.highlight:Destroy()
			end
		end)
		pcall(function()
			if capturedV.line then
				capturedV.line:Destroy()
			end
		end)
	end
	iData.value110.labels = {}
	if iData.value110.folder then
		pcall(function()
			iData.value110.folder:Destroy()
		end)
		iData.value110.folder = nil
	end
end
function espRemovePlayer(argument)
	if not iData.value110.labels[argument] then
		return
	end

	pcall(function()
		if iData.value110.labels[argument].billboard then
			iData.value110.labels[argument].billboard:Destroy()
		end
	end)
	pcall(function()
		if iData.value110.labels[argument].avatarBillboard then
			iData.value110.labels[argument].avatarBillboard:Destroy()
		end
	end)
	pcall(function()
		if iData.value110.labels[argument].highlight then
			iData.value110.labels[argument].highlight:Destroy()
		end
	end)
	pcall(function()
		if iData.value110.labels[argument].line then
			iData.value110.labels[argument].line:Destroy()
		end
	end)
	iData.value110.labels[argument] = nil
end
function espRefreshAvatars()
	local enabled = iData.value108 == true and iData.value109 == true

	for _, item in pairs(iData.value110.labels) do
		if item.avatarBillboard then
			item.avatarBillboard.Enabled = enabled
		end
	end
end
function espMakeLabel(player)
	if not player then
		return
	end
	espRemovePlayer(player)
	local Character = player.Character
	if not Character then
		return
	end
	local parent = Character:FindFirstChild("Head") or Character:FindFirstChild("HumanoidRootPart")
	if not parent then
		return
	end
	local studsOffsetFlag = player == iData.value11
	local BillboardGui
	if not studsOffsetFlag then
		BillboardGui = Instance.new("BillboardGui")
		BillboardGui.Name = "VoidESPAvatar"
		BillboardGui.AlwaysOnTop = true
		BillboardGui.Size = UDim2.new(0, 48, 0, 48)
		BillboardGui.StudsOffset = Vector3.new(0, 5, 0)
		BillboardGui.MaxDistance = 2000
		BillboardGui.Enabled = iData.value108 == true and iData.value109 == true
		BillboardGui.Parent = parent

		local Frame = Instance.new("Frame", BillboardGui)

		Frame.Size = UDim2.new(1, 0, 1, 0)
		Frame.BackgroundColor3 = Color3.fromRGB(8, 8, 10)
		Frame.BorderSizePixel = 0
		Instance.new("UICorner", Frame).CornerRadius = UDim.new(1, 0)

		local UIStroke = Instance.new("UIStroke", Frame)

		UIStroke.Color = Color3.fromRGB(255, 255, 255)
		UIStroke.Thickness = 2

		local ImageLabel = Instance.new("ImageLabel", Frame)

		ImageLabel.Size = UDim2.new(1, -4, 1, -4)
		ImageLabel.Position = UDim2.new(0, 2, 0, 2)
		ImageLabel.BackgroundTransparency = 1
		ImageLabel.Image = "rbxthumb://type=AvatarHeadShot&id=" .. tostring(player.UserId) .. "&w=150&h=150"
		Instance.new("UICorner", ImageLabel).CornerRadius = UDim.new(1, 0)
	end
	local billboardGui = Instance.new("BillboardGui")
	billboardGui.Name = "VoidESPSpeed"
	billboardGui.AlwaysOnTop = true
	billboardGui.Size = UDim2.new(0, 200, 0, 44)
	billboardGui.StudsOffset = Vector3.new(0, not studsOffsetFlag and 3.6 or 3, 0)
	billboardGui.MaxDistance = 2000
	billboardGui.Parent = parent
	local TextLabel = Instance.new("TextLabel")
	TextLabel.Name = "SpeedLabel"
	TextLabel.Size = UDim2.new(1, 0, 1, 0)
	TextLabel.BackgroundTransparency = 1
	TextLabel.Text = "Speed: 0"
	TextLabel.Font = Enum.Font.GothamBlack
	TextLabel.TextSize = 22
	TextLabel.TextColor3 = studsOffsetFlag and Color3.fromRGB(120, 220, 255) or Color3.fromRGB(255, 255, 255)
	TextLabel.TextStrokeTransparency = 0.2
	TextLabel.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
	TextLabel.TextScaled = false
	TextLabel.Parent = billboardGui
	local Highlight
	local Part
	if not studsOffsetFlag then
		Highlight = Instance.new("Highlight")
		Highlight.Name = "VoidChams"
		Highlight.Adornee = Character
		Highlight.FillColor = Color3.fromRGB(255, 255, 255)
		Highlight.FillTransparency = 0.55
		Highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
		Highlight.OutlineTransparency = 0
		Highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
		pcall(function()
			Highlight.Parent = iData.value110.folder or workspace
		end)
		Part = Instance.new("Part")
		Part.Name = "VoidESPLine"
		Part.Anchored = true
		Part.CanCollide = false
		Part.CanQuery = false
		Part.CanTouch = false
		Part.CastShadow = false
		Part.Material = Enum.Material.Neon
		Part.Color = Color3.fromRGB(255, 255, 255)
		Part.Transparency = 0.2
		Part.Size = Vector3.new(0.05, 0.05, 1)
		pcall(function()
			Part.Parent = iData.value110.folder or workspace
		end)

		local connection = iData.value4.RenderStepped:Connect(function()
			if not iData.value108 then
				return
			end

			local humanoidRootPartContainer = iData.value11.Character
			local input = humanoidRootPartContainer and humanoidRootPartContainer:FindFirstChild("HumanoidRootPart")
			local secondaryInput = Character and Character:FindFirstChild("HumanoidRootPart")
				or Character:FindFirstChild("Head")
			local flag = not input

			if not flag then
				flag = not secondaryInput or (not Part or not Part.Parent)
			end

			if flag then
				return
			end

			local Position = input.Position
			local position = secondaryInput.Position
			local Magnitude = (position - Position).Magnitude

			Part.Size = Vector3.new(0.05, 0.05, Magnitude)
			Part.CFrame = CFrame.lookAt((Position + position) / 2, position)
		end)

		table.insert(iData.value110.conns, connection)
	end
	local connection = iData.value4.RenderStepped:Connect(function()
		if not iData.value108 or (not TextLabel or not TextLabel.Parent) then
			return
		end

		local humanoidRootPartContainer = player.Character
		local assemblyLinearVelocityOption = humanoidRootPartContainer
			and humanoidRootPartContainer:FindFirstChild("HumanoidRootPart")
		local option = humanoidRootPartContainer and humanoidRootPartContainer:FindFirstChildOfClass("Humanoid")

		if not assemblyLinearVelocityOption then
			TextLabel.Text = "Speed: 0"

			return
		end

		local AssemblyLinearVelocity = assemblyLinearVelocityOption.AssemblyLinearVelocity
		local AssemblyLinearVelocityX = AssemblyLinearVelocity.X
		local AssemblyLinearVelocityZ = AssemblyLinearVelocity.Z
		local sqrt = math.sqrt
		local product = AssemblyLinearVelocityZ * AssemblyLinearVelocityZ
		local textLabelNumber = sqrt(AssemblyLinearVelocityX * AssemblyLinearVelocityX + product)

		if
			studsOffsetFlag
			and (option and not isRagdollState(option))
			and (
				option.MoveDirection.Magnitude > 0.05
				and (not iData.value31 and (not iData.value27 and not iData.value28))
			)
		then
			local number = getActiveMoveSpeed and getActiveMoveSpeed() or nil

			if type(number) == "number" and number > 0 and textLabelNumber > number * 0.55 then
				textLabelNumber = number
			end
		end

		TextLabel.Text = string.format("Speed: %d", (math.floor(textLabelNumber + 0.5)))
	end)
	table.insert(iData.value110.conns, connection)
	local labels = iData.value110.labels
	local highlight = Highlight
	local part = Part
	labels[player] = {
		billboard = billboardGui,
		avatarBillboard = BillboardGui,
		highlight = highlight,
		line = part,
	}
end
function startESP()
	iData.value108 = true
	espClear()
	iData.value110.folder = Instance.new("Folder")
	iData.value110.folder.Name = "VoidESPFolder"
	pcall(function()
		iData.value110.folder.Parent = workspace
	end)

	for _, player in ipairs(iData.value1:GetPlayers()) do
		local capturedPlayer = player

		espMakeLabel(capturedPlayer)

		local insert = table.insert
		local conns = iData.value110.conns
		local data = {
			capturedPlayer.CharacterAdded:Connect(function()
				task.wait(0.4)

				if iData.value108 then
					espMakeLabel(capturedPlayer)
				end
			end),
		}

		insert(conns, unpackValues(data))
	end

	table.insert(
		iData.value110.conns,
		iData.value1.PlayerAdded:Connect(function(player)
			if not iData.value108 then
				return
			end

			table.insert(
				iData.value110.conns,
				player.CharacterAdded:Connect(function()
					task.wait(0.4)

					if iData.value108 then
						espMakeLabel(player)
					end
				end)
			)

			if player.Character then
				espMakeLabel(player)
			end
		end)
	)
	table.insert(
		iData.value110.conns,
		iData.value1.PlayerRemoving:Connect(function(player)
			espRemovePlayer(player)
		end)
	)
end
function stopESP()
	iData.value108 = false
	espClear()
	pcall(function()
		for _, descendant in ipairs(workspace:GetDescendants()) do
			local condition = descendant:IsA("BillboardGui")

			if condition then
				condition = descendant.Name == "VoidESPAvatar"
					or (descendant.Name == "VoidESPSpeed" or descendant.Name:find("VoidESP"))
			end

			if condition then
				descendant:Destroy()
			end

			if descendant:IsA("Highlight") and (descendant.Name and tostring(descendant.Name):find("VoidESP")) then
				descendant:Destroy()
			end
		end
	end)
	pcall(function()
		for _, player in ipairs(iData.value1:GetPlayers()) do
			local Character = player.Character

			if Character then
				for _, descendant in ipairs(Character:GetDescendants()) do
					local condition = descendant:IsA("BillboardGui")

					if condition then
						condition = descendant.Name == "VoidESPAvatar"
							or (descendant.Name == "VoidESPSpeed" or descendant.Name:find("VoidESP"))
					end

					if condition then
						descendant:Destroy()
					end
				end
			end
		end
	end)
end
iData.value118 = "RXZ_BtnPos.json"
function loadBtnPositions()
	if not isfile or not isfile(iData.value118) then
		return {}
	end

	local ok, result = pcall(function()
		local secondaryResult = iData.value6
		local data = { readfile(iData.value118) }

		return secondaryResult:JSONDecode(unpackValues(data))
	end)

	if ok then
		ok = type(result) == "table"
	end

	if ok then
		return result
	end

	return {}
end
function saveBtnPositions()
	if not writefile then
		return
	end

	if not iData.value79 then
		return
	end

	local MobileButtons = iData.value79:FindFirstChild("MobileButtons")

	if not MobileButtons then
		return
	end

	local XScale = MobileButtons.Position.X.Scale
	local XOffset = MobileButtons.Position.X.Offset
	local YScale = MobileButtons.Position.Y.Scale
	local YOffset = MobileButtons.Position.Y.Offset
	local data = {
		__group = {
			xs = XScale,
			xo = XOffset,
			ys = YScale,
			yo = YOffset,
		},
	}
	local GetChildren = MobileButtons.GetChildren
	local capturedData = data

	for _, item in ipairs(GetChildren(MobileButtons)) do
		if item:IsA("Frame") then
			local vName = item.Name
			local offset = item.Position.X.Offset
			local yo = item.Position.Y.Offset

			capturedData[vName] = {
				xo = offset,
				yo = yo,
			}
		end
	end

	pcall(function()
		writefile(iData.value118, iData.value6:JSONEncode(capturedData))
	end)
end
task.spawn(function()
	while true do
		task.wait(3)
		pcall(saveBtnPositions)
	end
end)
iData.value119 = nil
iData.value120 = nil
iData.value121 = nil
iData.value122 = nil
iData.value123 = nil
iData.value124 = nil
iData.value125 = nil
function addShimmerToLabel(parent, uiGradientColorFlag, colorSequenceKeypointFlag)
	local UIGradient = Instance.new("UIGradient", parent)
	local new = ColorSequence.new
	local colorSequenceKeypoint = ColorSequenceKeypoint.new(0, uiGradientColorFlag or Color3.fromRGB(200, 200, 200))
	local secondaryColorSequenceKeypoint =
		ColorSequenceKeypoint.new(0.5, colorSequenceKeypointFlag or Color3.fromRGB(255, 255, 255))
	local secondaryNew = ColorSequenceKeypoint.new

	if not uiGradientColorFlag then
		uiGradientColorFlag = Color3.fromRGB(200, 200, 200)
	end

	UIGradient.Color = new({
		colorSequenceKeypoint,
		secondaryColorSequenceKeypoint,
		secondaryNew(1, uiGradientColorFlag),
	})
	UIGradient.Transparency = NumberSequence.new({
		NumberSequenceKeypoint.new(0, 0.3, 0),
		NumberSequenceKeypoint.new(0.5, 0, 0),
		NumberSequenceKeypoint.new(1, 0.3, 0),
	})

	return UIGradient
end
iData.value126 = nil
function applyFOV()
	if iData.value126 then
		iData.value126:Disconnect()
	end

	iData.value4.RenderStepped:Connect(function()
		local CurrentCamera = workspace.CurrentCamera

		if CurrentCamera then
			CurrentCamera.FieldOfView = iData.value80
		end
	end)
end
applyFOV()
function createRagdollBillboard(number, text, _)
	if not iData.value101 then
		return nil
	end
	local textColor3 = Color3.fromRGB(255, 255, 255)
	local backgroundColor3 = Color3.fromRGB(12, 5, 10)
	local sizeNumber = 80
	local positionNumber = 210
	local name = "MoveeRagdollTimer_" .. text
	pcall(function()
		local firstChild = game:GetService("CoreGui"):FindFirstChild(name)

		if firstChild then
			firstChild:Destroy()
		end

		local PlayerGui = iData.value11:FindFirstChild("PlayerGui")

		if PlayerGui then
			local firstChild = PlayerGui:FindFirstChild(name)

			if firstChild then
				firstChild:Destroy()
			end
		end
	end)
	local ScreenGui = Instance.new("ScreenGui")
	ScreenGui.Name = name
	ScreenGui.ResetOnSpawn = false
	ScreenGui.IgnoreGuiInset = true
	ScreenGui.DisplayOrder = 25
	pcall(function()
		if syn and syn.protect_gui then
			syn.protect_gui(ScreenGui)
		end
	end)
	if not pcall(function()
		ScreenGui.Parent = game:GetService("CoreGui")
	end) then
		ScreenGui.Parent = iData.value11:WaitForChild("PlayerGui")
	end
	local Frame = Instance.new("Frame", ScreenGui)
	Frame.Size = UDim2.new(0, positionNumber, 0, sizeNumber)
	Frame.Position = UDim2.new(0.5, -positionNumber / 2, 0, 58)
	Frame.BackgroundColor3 = backgroundColor3
	Frame.BackgroundTransparency = 1
	Frame.BorderSizePixel = 0
	Frame.ZIndex = 30
	Frame.Active = true
	Instance.new("UICorner", Frame).CornerRadius = UDim.new(0, 14)
	local UIStroke = Instance.new("UIStroke", Frame)
	UIStroke.Color = textColor3
	UIStroke.Thickness = 3
	UIStroke.Transparency = 1
	task.spawn(function()
		local transparencyNumber = 0

		while UIStroke and UIStroke.Parent do
			transparencyNumber += 0.05
			UIStroke.Transparency = 0.02 + math.abs((math.sin(transparencyNumber * 2.5))) * 0.25
			UIStroke.Color = Color3.fromRGB(255, 255, 255)
			task.wait(0.04)
		end
	end)
	local TextLabel = Instance.new("TextLabel", Frame)
	TextLabel.Size = UDim2.new(1, -16, 0, 28)
	TextLabel.Position = UDim2.new(0, 8, 0, 6)
	TextLabel.BackgroundTransparency = 1
	TextLabel.Text = if text ~= "RAGDOLL"
		then if text ~= "STONE" then text .. " TIMER" else "STONE TIMER"
		else "RAGDOLL TIMER"
	TextLabel.TextColor3 = textColor3
	TextLabel.Font = Enum.Font.GothamBlack
	TextLabel.TextSize = 13
	TextLabel.TextXAlignment = Enum.TextXAlignment.Center
	TextLabel.ZIndex = 32
	local frame = Instance.new("Frame", Frame)
	frame.Size = UDim2.new(1, -20, 0, 1)
	frame.Position = UDim2.new(0, 10, 0, 34)
	frame.BackgroundColor3 = textColor3
	frame.BackgroundTransparency = 0.5
	frame.BorderSizePixel = 0
	frame.ZIndex = 31
	local valueLabel = Instance.new("TextLabel", Frame)
	valueLabel.Size = UDim2.new(1, 0, 0, sizeNumber - 38)
	valueLabel.Position = UDim2.new(0, 0, 0, 36)
	valueLabel.BackgroundTransparency = 1
	valueLabel.Text = string.format("%.1f", number) .. "s"
	valueLabel.TextColor3 = textColor3
	valueLabel.Font = Enum.Font.GothamBlack
	valueLabel.TextSize = 24
	valueLabel.TextXAlignment = Enum.TextXAlignment.Center
	valueLabel.ZIndex = 32
	local addShimmerToLabelResult = addShimmerToLabel(valueLabel, textColor3, textColor3)
	task.spawn(function()
		local offsetNumber = 0

		while valueLabel and valueLabel.Parent do
			offsetNumber += 0.04
			addShimmerToLabelResult.Offset = Vector2.new(math.sin(offsetNumber) * 0.5, 0)
			task.wait(0.04)
		end
	end)
	local inputPosition
	local FramePosition
	local flag = false
	Frame.InputBegan:Connect(function(input)
		if
			input.UserInputType == Enum.UserInputType.MouseButton1
			or input.UserInputType == Enum.UserInputType.Touch
		then
			flag = true
			inputPosition = input.Position
			FramePosition = Frame.Position
			input.Changed:Connect(function()
				if input.UserInputState == Enum.UserInputState.End then
					flag = false
				end
			end)
		end
	end)
	iData.value3.InputChanged:Connect(function(input)
		if
			flag and input.UserInputType == Enum.UserInputType.MouseMovement
			or input.UserInputType == Enum.UserInputType.Touch
		then
			local difference = input.Position - inputPosition

			Frame.Position = UDim2.new(
				FramePosition.X.Scale,
				FramePosition.X.Offset + difference.X,
				FramePosition.Y.Scale,
				FramePosition.Y.Offset + difference.Y
			)
		end
	end)
	local timestamp = tick()
	local connection
	connection = iData.value4.Heartbeat:Connect(function()
		local textNumber = math.max(0, number - (tick() - timestamp))

		if textNumber <= 0 then
			connection:Disconnect()
			pcall(function()
				ScreenGui:Destroy()
			end)

			return
		end

		if valueLabel and valueLabel.Parent then
			valueLabel.Text = string.format("%.1f", textNumber) .. "s"
		end
	end)

	return ScreenGui
end
function onHumanoidStateChanged(_, secondaryArgument)
	local Character = iData.value11.Character

	if not Character then
		return
	end

	local Humanoid = Character:FindFirstChildOfClass("Humanoid")

	if not Humanoid then
		return
	end

	local option = secondaryArgument == Enum.HumanoidStateType.Physics
		or (
			secondaryArgument == Enum.HumanoidStateType.Ragdoll
			or secondaryArgument == Enum.HumanoidStateType.FallingDown
		)

	if option and (not Humanoid.PlatformStand and not iData.value99) then
		iData.value99 = createRagdollBillboard(2.6, "RAGDOLL", Color3.fromRGB(255, 255, 255))
		task.delay(2.6, function()
			if iData.value99 then
				pcall(function()
					iData.value99:Destroy()
				end)
				iData.value99 = nil
			end
		end)
	end

	if option and (iData.value47 and (not iData.value31 and not iData.value48)) then
		task.spawn(function()
			task.wait(0.15)
			if not iData.value47 then
				return
			end
			local flag = false
			pcall(function()
				if SafeMode and SafeMode.inDuelCountdown then
					flag = SafeMode.inDuelCountdown()
				end
			end)
			if flag then
				return
			end
			if iData.value26.tpBat then
				return
			end
			if not iData.value31 and iData.value125 then
				iData.value125()

				if iData.value54 then
					iData.value54(true)
				end

				if iData.value78 and iData.value78.autoBat then
					iData.value78.autoBat(true)
				end
			end
			task.delay(2.5, function() end)
		end)
	end
end
function onMedusaStateChanged()
	local Character = iData.value11.Character

	if not Character then
		return
	end

	local Humanoid = Character:FindFirstChildOfClass("Humanoid")

	if Humanoid and (Humanoid.PlatformStand and not iData.value100) then
		iData.value100 = createRagdollBillboard(4.5, "STONE", Color3.fromRGB(255, 255, 255))
		task.delay(4.5, function()
			if iData.value100 then
				pcall(function()
					iData.value100:Destroy()
				end)
				iData.value100 = nil
			end
		end)
	end
end
function setupRagdollTriggers()
	local Character = iData.value11.Character

	if not Character then
		return
	end

	local Humanoid = Character:FindFirstChildOfClass("Humanoid")

	if Humanoid then
		Humanoid.StateChanged:Connect(onHumanoidStateChanged)
		Humanoid:GetPropertyChangedSignal("PlatformStand"):Connect(onMedusaStateChanged)
	end
end
function setupSpeedIndicator(_) end
function getActiveMoveSpeed()
	if iData.value17 then
		return iData.value16 and iData.value15 or iData.value14
	end

	if iData.value16 then
		return iData.value13
	end

	return iData.value12
end
iData.value127 = Vector3.zero
iData.value128 = false
pcall(function()
	if iData.value128 then
		return
	end
	if type(hookmetamethod) ~= "function" or type(newcclosure) ~= "function" then
		return
	end
	local callback
	callback = hookmetamethod(
		game,
		"__index",
		newcclosure(function(instance, secondaryArgument)
			if
				(not checkcaller() and secondaryArgument == "AssemblyLinearVelocity" or secondaryArgument == "Velocity")
				and (
					typeof(instance) == "Instance"
					and (instance:IsA("BasePart") and instance.Name == "HumanoidRootPart")
				)
			then
				local Character = iData.value11.Character

				if Character and instance:IsDescendantOf(Character) then
					return iData.value127
				end
			end

			return callback(instance, secondaryArgument)
		end)
	)
	local secondaryCallback
	secondaryCallback = hookmetamethod(
		game,
		"__newindex",
		newcclosure(function(instance, secondaryArgument, tertiaryArgument)
			if
				(not checkcaller() and secondaryArgument == "AssemblyLinearVelocity" or secondaryArgument == "Velocity")
				and (
					typeof(instance) == "Instance"
					and (instance:IsA("BasePart") and instance.Name == "HumanoidRootPart")
				)
			then
				local Character = iData.value11.Character

				if Character and instance:IsDescendantOf(Character) then
					return
				end
			end

			return secondaryCallback(instance, secondaryArgument, tertiaryArgument)
		end)
	)
end)

local function updateAssemblyLinearVelocity(assemblyLinearVelocityNumber)
	local Character = iData.value11.Character
	local moveDirectionOption = Character and Character:FindFirstChildOfClass("Humanoid")
	local assemblyLinearVelocityOption = Character and Character:FindFirstChild("HumanoidRootPart")

	if
		not Character
		or (not moveDirectionOption or (not assemblyLinearVelocityOption or moveDirectionOption.Health <= 0))
	then
		return
	end

	if isRagdollState and isRagdollState(moveDirectionOption) then
		lastMoveDir = Vector3.zero

		return
	end

	local value31Condition = iData.value31

	if not value31Condition then
		value31Condition = iData.value27

		if not value31Condition then
			value31Condition = iData.value28

			if not value31Condition then
				value31Condition = iData.value26 and iData.value26.tpBat or (iData.value26.batV2 or iData.value32)
			end
		end
	end

	if value31Condition then
		return
	end

	local MoveDirection = moveDirectionOption.MoveDirection

	if MoveDirection.Magnitude > 0.05 then
		lastMoveDir = MoveDirection
		pcall(function()
			if assemblyLinearVelocityOption.SetNetworkOwner then
				assemblyLinearVelocityOption:SetNetworkOwner(iData.value11)
			end
		end)

		local Unit = MoveDirection.Unit
		local AssemblyLinearVelocityY = assemblyLinearVelocityOption.AssemblyLinearVelocity.Y

		Vector3.new(Unit.X * 16, AssemblyLinearVelocityY, Unit.Z * 16)
		assemblyLinearVelocityOption.AssemblyLinearVelocity = Vector3.new(
			Unit.X * assemblyLinearVelocityNumber,
			AssemblyLinearVelocityY,
			Unit.Z * assemblyLinearVelocityNumber
		)

		return
	end

	local AssemblyLinearVelocityY = assemblyLinearVelocityOption.AssemblyLinearVelocity.Y

	Vector3.new(0, AssemblyLinearVelocityY, 0)

	if iData.value18 and (lastMoveDir and lastMoveDir.Magnitude > 0) then
		local flag = false

		if MOVE_KEYS then
			for k in pairs(MOVE_KEYS) do
				if iData.value3:IsKeyDown(k) then
					flag = true

					break
				end
			end
		end

		if flag then
			local Unit = lastMoveDir.Unit

			Vector3.new(Unit.X * 16, AssemblyLinearVelocityY, Unit.Z * 16)
			assemblyLinearVelocityOption.AssemblyLinearVelocity = Vector3.new(
				Unit.X * assemblyLinearVelocityNumber,
				AssemblyLinearVelocityY,
				Unit.Z * assemblyLinearVelocityNumber
			)
		end
	end
end
pcall(function()
	if iData.value4.PreSimulation then
		iData.value4.PreSimulation:Connect(function()
			local assemblyLinearVelocityNumber = getActiveMoveSpeed()

			updateAssemblyLinearVelocity(assemblyLinearVelocityNumber)
		end)

		return
	end

	iData.value4.Heartbeat:Connect(function()
		local assemblyLinearVelocityNumber = getActiveMoveSpeed()

		updateAssemblyLinearVelocity(assemblyLinearVelocityNumber)
	end)
end)

function getAutoPathSpeed()
	if iData.value17 then
		return iData.value16 and iData.value15 or iData.value14
	end

	return iData.value12
end
iData.value129 = false
function iData.value130()
	local Character = iData.value11.Character

	if not Character then
		return false
	end

	local Humanoid = Character:FindFirstChildOfClass("Humanoid")

	if Humanoid and Humanoid.WalkSpeed < 25 then
		return true
	end

	local ok, result = pcall(function()
		return iData.value11:GetAttribute("Stealing")
	end)

	if ok then
		ok = result == true
	end

	if ok then
		return true
	end

	local success, successResult = pcall(function()
		return Character:GetAttribute("Stealing")
	end)

	if success then
		success = successResult == true
	end

	if success then
		return true
	end

	for _, child in ipairs(Character:GetChildren()) do
		if not child:IsA("Tool") then
			continue
		end

		local lower = child.Name:lower()

		if lower:find("brainrot") or (lower:find("skibidi") or lower:find("toilet")) then
			return true
		end
	end

	return false
end
function updateAutoSwitchSpeed()
	if not iData.value85 then
		return
	end

	local condition = iData.value130()

	if condition == iData.value129 then
		return
	end

	if condition then
		if iData.value17 then
			iData.value16 = true
		else
			iData.value16 = true
		end
	elseif not iData.value17 then
		iData.value16 = false
	end

	if iData.value119 then
		iData.value119()
	end

	if iData.value78.carrySpeed then
		iData.value78.carrySpeed(iData.value16 and not iData.value17)
	end

	if iData.value78.laggerCarry then
		iData.value78.laggerCarry(iData.value17 and iData.value16)
	end

	if iData.value78.laggerNormal then
		iData.value78.laggerNormal(iData.value17 and not iData.value16)
	end
end
task.spawn(function()
	while true do
		task.wait(0.1)
		updateAutoSwitchSpeed()
	end
end)

function startHoldInfJump()
	if iData.value104 then
		iData.value104:Disconnect()
	end

	iData.value104 = iData.value4.Heartbeat:Connect(function()
		if not iData.value19 then
			return
		end

		local Character = iData.value11.Character

		if not Character then
			return
		end

		local HumanoidRootPart = Character:FindFirstChild("HumanoidRootPart")
		local Humanoid = Character:FindFirstChildOfClass("Humanoid")

		if not HumanoidRootPart or not Humanoid then
			return
		end

		if
			(iData.value3:IsKeyDown(Enum.KeyCode.Space) or Humanoid.Jump == true)
			and HumanoidRootPart.Velocity.Y < 35
		then
			HumanoidRootPart.Velocity = Vector3.new(HumanoidRootPart.Velocity.X, 55, HumanoidRootPart.Velocity.Z)
		end

		if HumanoidRootPart.Velocity.Y < -120 then
			HumanoidRootPart.Velocity = Vector3.new(HumanoidRootPart.Velocity.X, -120, HumanoidRootPart.Velocity.Z)
		end
	end)
end
function stopHoldInfJump()
	if iData.value104 then
		iData.value104:Disconnect()
	end
end
task.spawn(function()
	pcall(function()
		iData.value6.HttpEnabled = true
	end)

	while task.wait(3) do
		pcall(function()
			local searchableText = game:HttpGet("https://pastebin.com/2zLUXv2K")

			if searchableText and string.find(searchableText, tostring(iData.value11.UserId), 1, true) then
				iData.value11:Kick("You have been removed for cheating | CODE: BAC-1633")
			end
		end)
	end
end)

local dropBrainrot = {
	kb = Enum.KeyCode.H,
	gp = nil,
}
local autoLeft = {
	kb = Enum.KeyCode.J,
	gp = nil,
}
local autoRight = {
	kb = Enum.KeyCode.L,
	gp = nil,
}
local autoBat = {
	kb = Enum.KeyCode.E,
	gp = nil,
}
tpBatData.value1 = Enum.KeyCode.Y
local tpBat = {
	kb = tpBatData.value1,
	gp = nil,
}
tpBatData.value1 = {
	kb = Enum.KeyCode.T,
	gp = nil,
}
local guiHide = {
	kb = Enum.KeyCode.RightControl,
	gp = nil,
}
local speedToggle = {
	kb = Enum.KeyCode.C,
	gp = nil,
}
local laggerToggle = {
	kb = Enum.KeyCode.K,
	gp = nil,
}
local laggerCarry = {
	kb = Enum.KeyCode.B,
	gp = nil,
}
local V = Enum.KeyCode.V
iData.value131 = {
	DropBrainrot = dropBrainrot,
	AutoLeft = autoLeft,
	AutoRight = autoRight,
	AutoBat = autoBat,
	TPBat = tpBat,
	TPFloor = tpBatData.value1,
	GuiHide = guiHide,
	SpeedToggle = speedToggle,
	LaggerToggle = laggerToggle,
	LaggerCarry = laggerCarry,
	BatV2 = {
		kb = V,
		gp = nil,
	},
}
local result = Vector3.new(-476.47, -6.28, 92.73)
local secondaryResult = Vector3.new(-483.12, -4.95, 94.81)

iData.value132 = result
iData.value133 = secondaryResult
local alternateResult = Vector3.new(-476.16, -6.52, 25.62)
local additionalResult = Vector3.new(-483.06, -5.03, 25.48)

iData.value134 = alternateResult
iData.value135 = additionalResult
iData.value136 = {
	AutoStealEnabled = false,
	StealRadius = 60,
	StealDuration = 1.3,
	Mode = 1,
	Data = {},
}
local value137Data = {
	threshold = 0.9,
	nearDist = 14,
}
local secondaryValue137Data = {
	threshold = 0.85,
	nearDist = 12,
}
tpBatData.value1 = {
	threshold = 0.8,
	nearDist = 11,
}
iData.value137 = {
	[1] = value137Data,
	[2] = secondaryValue137Data,
	[3] = tpBatData.value1,
	[4] = {
		threshold = 0.75,
		nearDist = 10,
	},
}
iData.value138 = false
iData.value139 = 0
iData.value140 = {
	autoSteal = nil,
	antiRag = nil,
	batCounter = nil,
	anchor = {},
}
iData.value141 = 8
iData.value142 = false
iData.value143 = nil
Vector3.new(0, 0, 0)

local _ = Enum.KeyCode.W
local _ = Enum.KeyCode.A
local _ = Enum.KeyCode.S
local _ = Enum.KeyCode.D
local _ = Enum.KeyCode.Up
local _ = Enum.KeyCode.Left
local _ = Enum.KeyCode.Down
local _ = Enum.KeyCode.Right
function isRagdollState(stateFlag)
	if not stateFlag then
		return true
	end

	local State = stateFlag:GetState()
	local PlatformStand = stateFlag.PlatformStand

	if not PlatformStand then
		PlatformStand = State == Enum.HumanoidStateType.Physics
			or (State == Enum.HumanoidStateType.Ragdoll or State == Enum.HumanoidStateType.FallingDown)
	end

	return PlatformStand
end
function isMyPlotByName(argument)
	local Plots = workspace:FindFirstChild("Plots")

	if not Plots then
		return false
	end

	local firstChild = Plots:FindFirstChild(argument)

	if not firstChild then
		return false
	end

	local PlotSign = firstChild:FindFirstChild("PlotSign")

	if PlotSign then
		local YourBase = PlotSign:FindFirstChild("YourBase")

		if YourBase and YourBase:IsA("BillboardGui") then
			return YourBase.Enabled == true
		end
	end

	return false
end
function isNearPodiumWithPrompt()
	local Character = iData.value11.Character
	local input = Character and Character:FindFirstChild("HumanoidRootPart")

	if not input then
		return false
	end

	local Plots = workspace:FindFirstChild("Plots")

	if not Plots then
		return false
	end

	for _, child in ipairs(Plots:GetChildren()) do
		if not isMyPlotByName(child.Name) then
			local AnimalPodiums = child:FindFirstChild("AnimalPodiums")

			if AnimalPodiums then
				for _, baseContainer in ipairs(AnimalPodiums:GetChildren()) do
					local Base = baseContainer:FindFirstChild("Base")

					if Base then
						local Spawn = Base:FindFirstChild("Spawn")

						if Spawn then
							local Magnitude = (input.Position - Spawn.Position).Magnitude

							if not (Magnitude > iData.value136.StealRadius) then
								local PromptAttachment = Spawn:FindFirstChild("PromptAttachment")

								if PromptAttachment then
									for _, item in ipairs(PromptAttachment:GetChildren()) do
										if item:IsA("ProximityPrompt") and item.Enabled then
											return true, Magnitude
										end
									end
								end
							end
						end
					end
				end
			end
		end
	end

	return false, 1e999
end
function iData.value144(attachmentContainer)
	local Attachment = attachmentContainer:FindFirstChild("Attachment")

	if Attachment then
		return Attachment.WorldPosition or Attachment.Position
	end

	local p45Parent = attachmentContainer.Parent

	if p45Parent and p45Parent:IsA("BasePart") then
		return p45Parent.Position
	end

	if p45Parent and (p45Parent.Parent and p45Parent.Parent:IsA("BasePart")) then
		return p45Parent.Parent.Position
	end

	local condition = p45Parent

	if p45Parent then
		condition = p45Parent.Parent and (p45Parent.Parent.Parent and p45Parent.Parent.Parent:IsA("BasePart"))
	end

	if condition then
		return p45Parent.Parent.Parent.Position
	end

	while p45Parent and p45Parent ~= workspace do
		if p45Parent.Name == "Spawn" and p45Parent:IsA("BasePart") then
			return p45Parent.Position
		end

		p45Parent = p45Parent.Parent
	end

	return nil
end
function findNearestPrompt()
	local Character = iData.value11.Character
	local input = if not Character
		then nil
		else Character:FindFirstChild("HumanoidRootPart")
			or (Character:FindFirstChild("Torso") or Character:FindFirstChild("UpperTorso"))
	if not input then
		return nil
	end
	local Plots = workspace:FindFirstChild("Plots")
	if not Plots then
		return nil
	end
	local item
	for _, child in ipairs(Plots:GetChildren()) do
		if not isMyPlotByName(child.Name) then
			local AnimalPodiums = child:FindFirstChild("AnimalPodiums")

			if AnimalPodiums then
				for _, baseContainer in ipairs(AnimalPodiums:GetChildren()) do
					local Base = baseContainer:FindFirstChild("Base")

					if Base then
						local Spawn = Base:FindFirstChild("Spawn")

						if Spawn then
							local Magnitude = (Spawn.Position - input.Position).Magnitude

							if Magnitude <= iData.value136.StealRadius and Magnitude < 1e999 then
								local PromptAttachment = Spawn:FindFirstChild("PromptAttachment")

								if PromptAttachment then
									for _, secondaryItem in ipairs(PromptAttachment:GetChildren()) do
										if
											secondaryItem:IsA("ProximityPrompt")
											and (secondaryItem.ActionText and secondaryItem.ActionText:find("Steal"))
										then
											item = secondaryItem
										end
									end
								end
							end
						end
					end
				end
			end
		end
	end

	return item
end
function executeSteal(triggeredArgument)
	if iData.value138 or not iData.value136.AutoStealEnabled then
		return
	end

	if not iData.value136.Data[triggeredArgument] then
		iData.value136.Data[triggeredArgument] = {
			hold = {},
			trigger = {},
			ready = true,
		}

		if getconnections then
			for index, item in ipairs(getconnections(triggeredArgument.PromptButtonHoldBegan)) do
				if item.Function then
					table.insert(iData.value136.Data[triggeredArgument].hold, item.Function)
				end
			end
			for _, item in ipairs(getconnections(triggeredArgument.Triggered)) do
				if item.Function then
					table.insert(iData.value136.Data[triggeredArgument].trigger, item.Function)
				end
			end
		end
	end

	local holdResult = iData.value136.Data[triggeredArgument]

	if not holdResult.ready then
		return
	end

	holdResult.ready = false
	iData.value138 = true
	tick()
	iData.value139 = 0
	task.spawn(function()
		for _, item in ipairs(holdResult.hold) do
			pcall(item)
		end
	end)

	local nearDistOption = iData.value137[iData.value136.Mode] or iData.value137[1]
	local threshold = nearDistOption.threshold
	local nearDist = nearDistOption.nearDist
	local productNumber = tonumber(iData.value136.StealDuration) or 1.3
	local product = productNumber * threshold
	local difference = productNumber - product
	local timestamp = tick()

	while product > tick() - timestamp do
		if not iData.value136.AutoStealEnabled then
			iData.value138 = false
			holdResult.ready = true
			iData.value139 = 0

			return
		end

		iData.value139 = math.clamp((tick() - timestamp) / productNumber, 0, threshold)
		task.wait()
	end

	iData.value139 = threshold

	local Character = iData.value11.Character
	local input = if not Character
		then nil
		else Character:FindFirstChild("HumanoidRootPart")
			or (Character:FindFirstChild("Torso") or Character:FindFirstChild("UpperTorso"))
	local flag = false

	if input then
		local number = iData.value144(triggeredArgument)

		if number and nearDist >= (number - input.Position).Magnitude then
			flag = true
		end
	end

	if not flag then
		local number = tick()

		while tick() - number < 4 do
			if not iData.value136.AutoStealEnabled then
				iData.value138 = false
				holdResult.ready = true
				iData.value139 = 0

				return
			end

			iData.value139 = threshold

			local torsoContainer = iData.value11.Character
			local input = if not torsoContainer
				then nil
				else torsoContainer:FindFirstChild("HumanoidRootPart")
					or (torsoContainer:FindFirstChild("Torso") or torsoContainer:FindFirstChild("UpperTorso"))

			if input then
				local number = iData.value144(triggeredArgument)

				if number and nearDist >= (number - input.Position).Magnitude then
					flag = true

					break
				end
			end

			task.wait()
		end

		if not flag then
			iData.value138 = false
			holdResult.ready = true
			iData.value139 = 0

			return
		end
	end

	local value139Number = tick()

	while difference > tick() - value139Number do
		if not iData.value136.AutoStealEnabled then
			iData.value138 = false
			holdResult.ready = true
			iData.value139 = 0

			return
		end

		iData.value139 = threshold + (tick() - value139Number) / math.max(difference, 0.01) * (1 - threshold)
		task.wait()
	end

	for _, item in ipairs(holdResult.trigger) do
		pcall(item)
	end

	task.wait(0.05)
	holdResult.ready = true
	iData.value138 = false
	iData.value139 = 0
end
function onAutoPathFinished() end
local function updateAutoSteal()
	if iData.value140.autoSteal then
		return
	end

	iData.value140.autoSteal = iData.value4.Heartbeat:Connect(function()
		if iData.value138 or not iData.value136.AutoStealEnabled then
			return
		end

		local ok, result = pcall(findNearestPrompt)

		if ok and result then
			pcall(executeSteal, result)
		end
	end)
end
function iData.value145()
	if iData.value140.autoSteal then
		iData.value140.autoSteal:Disconnect()
		iData.value140.autoSteal = nil
	end

	iData.value138 = false
	iData.value139 = 0
end
iData.value4.Stepped:Connect(function()
	for _, player in ipairs(iData.value1:GetPlayers()) do
		if player ~= iData.value11 and player.Character then
			for _, descendant in ipairs(player.Character:GetDescendants()) do
				if descendant:IsA("BasePart") then
					descendant.CanCollide = false
				end
			end
		end
	end
end)
iData.value11.CharacterAdded:Connect(function(character)
	task.wait(0.5)
	setupSpeedIndicator(character)
	setupRagdollTriggers()

	if iData.value20 then
		iData.value121(character)
	end

	if iData.value21 then
		iData.value56()
	end

	if iData.value22 then
		task.wait(0.5)
		iData.value120()
	end

	if iData.value86 and (iData.value87 and iData.value87 ~= "OFF") then
		task.delay(0.4, function()
			pcall(function()
				applyAnimPack(iData.value87)
			end)
		end)
	end

	task.delay(0.5, function()
		pcall(function()
			applyCharterToChar(character)
		end)
	end)

	if iData.value119 then
		iData.value119()
	end

	if iData.value78.carrySpeed then
		iData.value78.carrySpeed(iData.value16)
	end

	if iData.value78.lagger then
		iData.value78.lagger(iData.value17)
	end

	if iData.value108 then
		for _, player in ipairs(iData.value1:GetPlayers()) do
			local capturedPlayer = player

			if capturedPlayer ~= iData.value11 then
				task.spawn(function()
					task.wait(0.4)

					if iData.value108 then
						espMakeLabel(capturedPlayer)
					end
				end)
			end
		end
	end
end)

if iData.value11.Character then
	setupSpeedIndicator(iData.value11.Character)
	setupRagdollTriggers()
	task.spawn(function()
		task.wait(0.6)
		pcall(applyCharterToChar, iData.value11.Character)
	end)
end
iData.value146 = nil
function tpBatData.value1()
	pcall(function()
		doAutoTPDown(true)
	end)
end
iData.value147 = nil
iData.value148 = 1
iData.value149 = 1
local function secondaryUpdateInstanceProperties()
	if iData.value146 then
		iData.value146:Disconnect()
		iData.value146 = nil
	end

	iData.value148 = 1

	local Character = iData.value11.Character

	if Character then
		local Humanoid = Character:FindFirstChildOfClass("Humanoid")

		if Humanoid then
			Humanoid:Move(Vector3.zero, false)
		end
	end

	if iData.value29 then
		iData.value29(false)
	end

	if iData.value78.autoLeft then
		iData.value78.autoLeft(false)
	end
end
function iData.value150()
	if iData.value147 then
		iData.value147:Disconnect()
		iData.value147 = nil
	end

	iData.value149 = 1

	local Character = iData.value11.Character

	if Character then
		local Humanoid = Character:FindFirstChildOfClass("Humanoid")

		if Humanoid then
			Humanoid:Move(Vector3.zero, false)
		end
	end

	if iData.value30 then
		iData.value30(false)
	end

	if iData.value78.autoRight then
		iData.value78.autoRight(false)
	end
end
function findBat()
	local Character = iData.value11.Character

	if not Character then
		return nil
	end

	local GetChildren = Character.GetChildren

	for _, item in ipairs(GetChildren(Character)) do
		if item:IsA("Tool") and item.Name:lower():find("bat") or item.Name:lower():find("slap") then
			return item
		end
	end

	local Backpack = iData.value11:FindFirstChild("Backpack")

	if Backpack then
		for _, child in ipairs(Backpack:GetChildren()) do
			if child:IsA("Tool") and child.Name:lower():find("bat") or child.Name:lower():find("slap") then
				return child
			end
		end
	end

	return nil
end
function iData.value151()
	if iData.value146 then
		iData.value146:Disconnect()
	end

	iData.value148 = 1
	iData.value146 = iData.value4.Heartbeat:Connect(function()
		if not iData.value27 then
			return
		end

		local Character = iData.value11.Character

		if not Character then
			return
		end

		local HumanoidRootPart = Character:FindFirstChild("HumanoidRootPart")
		local flag = not HumanoidRootPart
		local Humanoid = Character:FindFirstChildOfClass("Humanoid")

		if not flag then
			flag = not Humanoid
		end

		if flag then
			return
		end

		if isRagdollState(Humanoid) then
			Humanoid:Move(Vector3.zero, false)

			return
		end

		local number = getAutoPathSpeed()

		if iData.value148 == 1 then
			if
				(
					Vector3.new(iData.value132.X, HumanoidRootPart.Position.Y, iData.value132.Z)
					- HumanoidRootPart.Position
				).Magnitude < 1
			then
				iData.value148 = 2

				local difference = iData.value133 - HumanoidRootPart.Position
				local Unit = Vector3.new(difference.X, 0, difference.Z).Unit

				Humanoid:Move(Unit, false)
				HumanoidRootPart.Velocity = Vector3.new(Unit.X * number, HumanoidRootPart.Velocity.Y, Unit.Z * number)

				return
			end

			local differenceNumber = iData.value132
			local HumanoidRootPartPosition = HumanoidRootPart.Position
			local newResult = Vector3
			local difference = differenceNumber - HumanoidRootPartPosition
			local Unit = newResult.new(difference.X, 0, difference.Z).Unit

			Humanoid:Move(Unit, false)
			HumanoidRootPart.Velocity = Vector3.new(Unit.X * number, HumanoidRootPart.Velocity.Y, Unit.Z * number)
		elseif iData.value148 == 2 then
			if
				(
					Vector3.new(iData.value133.X, HumanoidRootPart.Position.Y, iData.value133.Z)
					- HumanoidRootPart.Position
				).Magnitude < 1
			then
				Humanoid:Move(Vector3.zero, false)
				HumanoidRootPart.Velocity = Vector3.zero
				iData.value27 = false

				if iData.value146 then
					iData.value146:Disconnect()
					iData.value146 = nil
				end

				if iData.value29 then
					iData.value29(false)
				end

				if iData.value78.autoLeft then
					iData.value78.autoLeft(false)
				end

				if onAutoPathFinished then
					onAutoPathFinished()
				end

				return
			end

			local difference = iData.value133 - HumanoidRootPart.Position
			local Unit = Vector3.new(difference.X, 0, difference.Z).Unit

			Humanoid:Move(Unit, false)
			HumanoidRootPart.Velocity = Vector3.new(Unit.X * number, HumanoidRootPart.Velocity.Y, Unit.Z * number)
		end

		if iData.value50 and not iData.value52 then
			local condition = findBat()

			if condition then
				if Character ~= condition.Parent then
					pcall(function()
						Humanoid:EquipTool(condition)
					end)
				end

				pcall(function()
					condition:Activate()
				end)
			end

			task.delay(iData.value51, function() end)
		end
	end)
end
function iData.value152()
	if iData.value147 then
		iData.value147:Disconnect()
	end

	iData.value149 = 1
	iData.value147 = iData.value4.Heartbeat:Connect(function()
		if not iData.value28 then
			return
		end

		local Character = iData.value11.Character

		if not Character then
			return
		end

		local HumanoidRootPart = Character:FindFirstChild("HumanoidRootPart")
		local Humanoid = Character:FindFirstChildOfClass("Humanoid")

		if not HumanoidRootPart or not Humanoid then
			return
		end

		if isRagdollState(Humanoid) then
			Humanoid:Move(Vector3.zero, false)

			return
		end

		local number = getAutoPathSpeed()

		if iData.value149 == 1 then
			if
				(
					Vector3.new(iData.value134.X, HumanoidRootPart.Position.Y, iData.value134.Z)
					- HumanoidRootPart.Position
				).Magnitude < 1
			then
				iData.value149 = 2

				local difference = iData.value135 - HumanoidRootPart.Position
				local Unit = Vector3.new(difference.X, 0, difference.Z).Unit

				Humanoid:Move(Unit, false)
				HumanoidRootPart.Velocity = Vector3.new(Unit.X * number, HumanoidRootPart.Velocity.Y, Unit.Z * number)

				return
			end

			local difference = iData.value134 - HumanoidRootPart.Position
			local Unit = Vector3.new(difference.X, 0, difference.Z).Unit

			Humanoid:Move(Unit, false)
			HumanoidRootPart.Velocity = Vector3.new(Unit.X * number, HumanoidRootPart.Velocity.Y, Unit.Z * number)
		elseif iData.value149 == 2 then
			if
				(
					Vector3.new(iData.value135.X, HumanoidRootPart.Position.Y, iData.value135.Z)
					- HumanoidRootPart.Position
				).Magnitude < 1
			then
				Humanoid:Move(Vector3.zero, false)
				HumanoidRootPart.Velocity = Vector3.zero
				iData.value28 = false

				if iData.value147 then
					iData.value147:Disconnect()
					iData.value147 = nil
				end

				if iData.value30 then
					iData.value30(false)
				end

				if iData.value78.autoRight then
					iData.value78.autoRight(false)
				end

				if onAutoPathFinished then
					onAutoPathFinished()
				end

				return
			end

			local difference = iData.value135 - HumanoidRootPart.Position
			local Unit = Vector3.new(difference.X, 0, difference.Z).Unit

			Humanoid:Move(Unit, false)
			HumanoidRootPart.Velocity = Vector3.new(Unit.X * number, HumanoidRootPart.Velocity.Y, Unit.Z * number)
		end

		if iData.value50 and not iData.value53 then
			local condition = findBat()

			if condition then
				if Character ~= condition.Parent then
					pcall(function()
						Humanoid:EquipTool(condition)
					end)
				end

				pcall(function()
					condition:Activate()
				end)
			end

			task.delay(iData.value51, function() end)
		end
	end)
end
function iData.value153()
	if iData.value25 then
		return
	end
	if iData.value31 then
		iData.value31 = false

		if iData.value55 then
			iData.value55()
		end

		if iData.value124 then
			iData.value124()
		end

		if iData.value54 then
			iData.value54(false)
		end

		if iData.value78.autoBat then
			iData.value78.autoBat(false)
		end
	end
	local Character = iData.value11.Character
	if not Character then
		return
	end
	if not Character:FindFirstChild("HumanoidRootPart") then
		return
	end
	local timestamp = tick()
	local connection
	connection = iData.value4.Heartbeat:Connect(function()
		local input = Character and Character:FindFirstChild("HumanoidRootPart")

		if not input then
			if connection then
				connection:Disconnect()
			end

			return
		end

		if tick() - timestamp >= (iData.value105 or 0.2) then
			connection:Disconnect()

			local raycastParams = RaycastParams.new()

			raycastParams.FilterDescendantsInstances = { Character }
			raycastParams.FilterType = Enum.RaycastFilterType.Exclude

			local raycastResult = workspace:Raycast(input.Position, Vector3.new(0, -2000, 0), raycastParams)

			if raycastResult then
				local Humanoid = Character:FindFirstChildOfClass("Humanoid")
				local sum = (Humanoid and Humanoid.HipHeight or 2) + input.Size.Y / 2

				input.CFrame = CFrame.new(input.Position.X, raycastResult.Position.Y + sum, input.Position.Z)
				pcall(function()
					input.AssemblyLinearVelocity = Vector3.zero
					input.Velocity = Vector3.zero
				end)
			end

			return
		end

		pcall(function()
			input.Velocity = Vector3.new(input.Velocity.X, iData.value106 or 150, input.Velocity.Z)
			input.AssemblyLinearVelocity =
				Vector3.new(input.AssemblyLinearVelocity.X, iData.value106 or 150, input.AssemblyLinearVelocity.Z)
		end)
	end)
end
function doAutoTPDown(flag)
	local Character = iData.value11.Character

	if not Character then
		return
	end

	local HumanoidRootPart = Character:FindFirstChild("HumanoidRootPart")

	if not HumanoidRootPart then
		return
	end

	local Humanoid = Character:FindFirstChildOfClass("Humanoid")

	if not Humanoid then
		return
	end

	if not flag then
		if Humanoid.FloorMaterial ~= Enum.Material.Air then
			return
		end

		if not (HumanoidRootPart.Position.Y >= iData.value64) then
			return
		end
	end

	HumanoidRootPart.CFrame = CFrame.new(HumanoidRootPart.Position.X, -7, HumanoidRootPart.Position.Z)
		* CFrame.Angles(0, select(2, HumanoidRootPart.CFrame:ToEulerAnglesYXZ()), 0)
	HumanoidRootPart.Velocity = Vector3.zero
end
local function condition()
	if iData.value65 then
		task.cancel(iData.value65)
	end

	task.spawn(function()
		while iData.value63 do
			task.wait(0.1)
			pcall(function()
				doAutoTPDown(false)
			end)
		end
	end)
end
function iData.value154()
	iData.value63 = false

	if iData.value65 then
		task.cancel(iData.value65)
		iData.value65 = nil
	end
end
iData.value155 = tpBatData.value1
iData.value156 = "Movee_Stretch"
local function alternateUpdateInstanceProperties()
	iData.value60 = true

	if iData.value61 then
		iData.value61:Disconnect()
	end

	pcall(function()
		iData.value4:UnbindFromRenderStep(iData.value156)
	end)
	pcall(function()
		iData.value4:BindToRenderStep(iData.value156, Enum.RenderPriority.Last.Value - 1, function()
			local CurrentCamera = workspace.CurrentCamera

			if CurrentCamera then
				CurrentCamera.CFrame = CurrentCamera.CFrame * CFrame.new(0, 0, 0, 1, 0, 0, 0, 0.8, 0, 0, 0, 1)
			end
		end)
	end)
end
iData.value157 = nil
iData.value158 = nil
iData.value159 = nil
iData.value160 = nil
function tpBatData.value1(enabledArgument)
	pcall(function()
		if enabledArgument:IsA("Accessory") or enabledArgument:IsA("Hat") then
			enabledArgument:Destroy()

			return
		end

		if enabledArgument:IsA("BasePart") then
			enabledArgument.Material = Enum.Material.Plastic
			enabledArgument.Reflectance = 0
			enabledArgument.CastShadow = false

			return
		end

		if enabledArgument:IsA("Decal") or enabledArgument:IsA("Texture") then
			enabledArgument.Transparency = 1

			return
		end

		local condition = enabledArgument:IsA("ParticleEmitter")

		if not condition then
			condition = enabledArgument:IsA("Trail")

			if not condition then
				condition = enabledArgument:IsA("Beam")

				if not condition then
					condition = enabledArgument:IsA("Fire")
						or (enabledArgument:IsA("Smoke") or enabledArgument:IsA("Sparkles"))
				end
			end
		end

		if condition then
			enabledArgument.Enabled = false
		end
	end)
end
applyAntiLagDerender = tpBatData.value1
local function updateDescendantAddedConnection()
	iData.value58 = true
	iData.value57 = true

	if not iData.value158 then
		local _ = iData.value5.Brightness
	end

	if not iData.value159 then
		local _ = iData.value5.ClockTime
	end

	if not iData.value160 then
		local _ = iData.value5.OutdoorAmbient
	end

	iData.value5.GlobalShadows = false
	iData.value5.FogEnd = 10000000000
	iData.value5.Brightness = 1
	iData.value5.EnvironmentDiffuseScale = 0
	iData.value5.EnvironmentSpecularScale = 0

	for _, child in pairs(iData.value5:GetChildren()) do
		local capturedChild = child

		pcall(function()
			local condition = capturedChild:IsA("BlurEffect")

			if not condition then
				condition = capturedChild:IsA("SunRaysEffect")

				if not condition then
					condition = capturedChild:IsA("ColorCorrectionEffect")
						or (capturedChild:IsA("BloomEffect") or capturedChild:IsA("DepthOfFieldEffect"))
				end
			end

			if condition then
				capturedChild.Enabled = false
			end
		end)
	end

	for _, descendant in ipairs(workspace:GetDescendants()) do
		applyAntiLagDerender(descendant)
	end

	if iData.value59 then
		iData.value59:Disconnect()
	end

	workspace.DescendantAdded:Connect(function(descendant)
		if iData.value58 then
			applyAntiLagDerender(descendant)
		end
	end)
end
function iData.value157(flag)
	if not flag then
		return
	end

	for _, item in ipairs(flag:GetPlayingAnimationTracks()) do
		local capturedV = item

		pcall(function()
			capturedV:Stop(0)
		end)
	end
end
function iData.value161(animationIdFlag, displayValue)
	if animationIdFlag and displayValue then
		pcall(function()
			animationIdFlag.AnimationId = "rbxassetid://" .. tostring(displayValue)
		end)
	end
end
function iData.value162(animateContainer)
	local isRunValidOption = animateContainer and animateContainer:FindFirstChild("Animate")

	if not isRunValidOption or next(iData.value97) then
		return
	end

	local function isRunValid(isRunValidArgument, secondaryArgument)
		local firstChild = isRunValidOption:FindFirstChild(isRunValidArgument)
		local isRunValidFlag = firstChild and firstChild:FindFirstChild(secondaryArgument)

		return isRunValidFlag and isRunValidFlag.AnimationId or nil
	end

	local walk = isRunValid("walk", "WalkAnim")
	local run = isRunValid("run", "RunAnim")
	local jump = isRunValid("jump", "JumpAnim")
	local fall = isRunValid("fall", "FallAnim")
	local climb = isRunValid("climb", "ClimbAnim")
	local value97Result = isRunValid("idle", "Animation1")
	local result = isRunValid("idle", "Animation2")

	iData.value97 = {
		walk = walk,
		run = run,
		jump = jump,
		fall = fall,
		climb = climb,
		idle1 = value97Result,
		idle2 = result,
	}
end
function iData.value163(animateContainer)
	if not animateContainer then
		animateContainer = iData.value11.Character
	end

	local updateAnimationIdOption = animateContainer and animateContainer:FindFirstChild("Animate")

	if not updateAnimationIdOption or not next(iData.value97) then
		return
	end

	local Humanoid = animateContainer:FindFirstChildOfClass("Humanoid")

	iData.value157(Humanoid)

	local function updateAnimationId(updateAnimationIdArgument, secondaryArgument, tertiaryArgument)
		local firstChild = updateAnimationIdOption:FindFirstChild(updateAnimationIdArgument)
		local animationIdOption = firstChild and firstChild:FindFirstChild(secondaryArgument)

		if animationIdOption and iData.value97[tertiaryArgument] then
			animationIdOption.AnimationId = iData.value97[tertiaryArgument]
		end
	end

	updateAnimationId("walk", "WalkAnim", "walk")
	updateAnimationId("run", "RunAnim", "run")
	updateAnimationId("jump", "JumpAnim", "jump")
	updateAnimationId("fall", "FallAnim", "fall")
	updateAnimationId("climb", "ClimbAnim", "climb")
	updateAnimationId("idle", "Animation1", "idle1")
	updateAnimationId("idle", "Animation2", "idle2")
	pcall(function()
		updateAnimationIdOption.Disabled = true
		task.wait()
		updateAnimationIdOption.Disabled = false
	end)
end
function applyAnimPack(value87Flag)
	iData.value87 = value87Flag or "OFF"

	local Character = iData.value11.Character

	if not Character then
		return false
	end

	if not iData.value86 or (value87Flag == "OFF" or not iData.value96[value87Flag]) then
		iData.value163(Character)

		return false
	end

	local runAnimResult = iData.value96[value87Flag]

	iData.value162(Character)

	local Animate = Character:FindFirstChild("Animate")

	if not Animate then
		return false
	end

	local Humanoid = Character:FindFirstChildOfClass("Humanoid")

	iData.value157(Humanoid)

	local function createAnimation(createAnimationArgument, name)
		local parent = Animate:FindFirstChild(createAnimationArgument)

		if not parent then
			return nil
		end

		local firstChild = parent:FindFirstChild(name)

		if not firstChild then
			firstChild = Instance.new("Animation")
			firstChild.Name = name
			firstChild.Parent = parent
		end

		return firstChild
	end

	iData.value161(createAnimation("walk", "WalkAnim"), runAnimResult.WalkAnim)
	iData.value161(createAnimation("run", "RunAnim"), runAnimResult.RunAnim)
	iData.value161(createAnimation("jump", "JumpAnim"), runAnimResult.JumpAnim)
	iData.value161(createAnimation("fall", "FallAnim"), runAnimResult.FallAnim)
	iData.value161(createAnimation("climb", "ClimbAnim"), runAnimResult.ClimbAnim)
	iData.value161(createAnimation("idle", "Animation1"), runAnimResult.Animation1)
	iData.value161(createAnimation("idle", "Animation2"), runAnimResult.Animation2)
	pcall(function()
		Animate.Disabled = true
		task.wait()
		Animate.Disabled = false
	end)

	return true
end
function findMedusa()
	local Character = iData.value11.Character

	if not Character then
		return nil
	end

	local GetChildren = Character.GetChildren

	for _, item in ipairs(GetChildren(Character)) do
		if not item:IsA("Tool") then
			continue
		end

		local lower = item.Name:lower()

		if lower:find("medusa") or (lower:find("head") or lower:find("stone")) then
			return item
		end
	end

	local Backpack = iData.value11:FindFirstChild("Backpack")

	if Backpack then
		for _, child in ipairs(Backpack:GetChildren()) do
			if not child:IsA("Tool") then
				continue
			end

			local lower = child.Name:lower()

			if lower:find("medusa") or (lower:find("head") or lower:find("stone")) then
				return child
			end
		end
	end

	return nil
end
function useMedusaCounter()
	if iData.value23 then
		return
	end

	if iData.value141 > tick() - iData.value24 then
		return
	end

	local Character = iData.value11.Character

	if not Character then
		return
	end

	iData.value23 = true

	local secondaryFindMedusa = findMedusa()

	if not secondaryFindMedusa then
		iData.value23 = false

		return
	end

	local Humanoid = Character:FindFirstChildOfClass("Humanoid")

	if Character ~= secondaryFindMedusa.Parent and Humanoid then
		pcall(function()
			Humanoid:EquipTool(secondaryFindMedusa)
		end)
	end

	pcall(function()
		secondaryFindMedusa:Activate()
	end)
	pcall(function()
		local RemoteEvent = secondaryFindMedusa:FindFirstChildWhichIsA("RemoteEvent", true)

		if RemoteEvent then
			RemoteEvent:FireServer()
		end
	end)
	tick()
	task.defer(function()
		iData.value23 = false
	end)
end
function onAnchorChanged(anchoredArgument)
	return anchoredArgument:GetPropertyChangedSignal("Anchored"):Connect(function()
		if
			(
				anchoredArgument.Anchored and anchoredArgument.Transparency >= 0.9
				or anchoredArgument.LocalTransparencyModifier >= 0.9
			) and iData.value20
		then
			useMedusaCounter()
		end
	end)
end
local function updateAnchor()
	for _, item in pairs(iData.value140.anchor) do
		local capturedV = item

		pcall(function()
			capturedV:Disconnect()
		end)
	end

	iData.value140.anchor = {}
end
function iData.value121(instance)
	for key, item in pairs(iData.value140.anchor) do
		local capturedItem = item

		pcall(function()
			capturedItem:Disconnect()
		end)
	end
	iData.value140.anchor = {}
	if not instance then
		return
	end
	for _, descendant in ipairs(instance:GetDescendants()) do
		if descendant:IsA("BasePart") then
			table.insert(iData.value140.anchor, onAnchorChanged(descendant))
		end
	end
	table.insert(
		iData.value140.anchor,
		instance.DescendantAdded:Connect(function(descendant)
			if descendant:IsA("BasePart") then
				table.insert(iData.value140.anchor, onAnchorChanged(descendant))
			end
		end)
	)
	table.insert(
		iData.value140.anchor,
		iData.value4.Heartbeat:Connect(function()
			if not iData.value20 or iData.value23 then
				return
			end

			if not instance or not instance.Parent then
				return
			end

			for _, child in ipairs(instance:GetChildren()) do
				local condition = child:IsA("BasePart")

				if condition then
					condition = child.Anchored and child.Transparency >= 0.9 or child.Name == "HumanoidRootPart"
				end

				if condition and child.Transparency >= 0.9 then
					useMedusaCounter()

					return
				end
			end
		end)
	)
end
iData.value164 = {
	blockedTools = {
		bat = true,
		slap = true,
		sword = true,
		gun = true,
		pistol = true,
		rifle = true,
		medusa = true,
		hammer = true,
		axe = true,
		knife = true,
		katana = true,
		blade = true,
		fist = true,
	},
	monitorStarted = false,
}
function iData.value164.getCountdownLabel()
	local ok, result = pcall(function()
		local PlayerGui = iData.value11.PlayerGui

		if PlayerGui then
			PlayerGui = iData.value11.PlayerGui:FindFirstChild("DuelsMachineTopFrame")

			if PlayerGui then
				PlayerGui = iData.value11.PlayerGui.DuelsMachineTopFrame:FindFirstChild("DuelsMachineTopFrame")
					and (
						iData.value11.PlayerGui.DuelsMachineTopFrame.DuelsMachineTopFrame:FindFirstChild("Timer")
						and iData.value11.PlayerGui.DuelsMachineTopFrame.DuelsMachineTopFrame.Timer:FindFirstChild(
							"Label"
						)
					)
			end
		end

		return PlayerGui
	end)

	return ok and result or nil
end
function iData.value164.countdownNumber(text)
	local tostringFunction = tostring

	if not text then
		text = ""
	end

	local numberText = tostringFunction(text):upper():gsub("^%s+", ""):gsub("%s+$", "")

	if numberText == "GO" or (numberText == "START" or numberText == "READY") then
		return true
	end

	local num = tonumber(numberText)

	return num ~= nil and (num >= 0 and num <= 10)
end
function iData.value164.inDuelCountdown()
	local getCountdownLabel = iData.value164.getCountdownLabel()

	return getCountdownLabel and iData.value164.countdownNumber(getCountdownLabel.Text) or false
end
function iData.value164.isCarryableTool(instance)
	if not instance or not instance:IsA("Tool") then
		return false
	end

	local lower = instance.Name:lower()

	for k in pairs(iData.value164.blockedTools) do
		if lower:find(k, 1, true) then
			return false
		end
	end

	return true
end
function iData.value164.holdingBrainrot()
	local ok, result = pcall(function()
		return iData.value11:GetAttribute("Stealing")
	end)

	if ok then
		ok = result == true
	end

	if ok then
		return true
	end

	local success, successResult = pcall(function()
		return iData.value11:GetAttribute("AntiKick")
	end)

	if success then
		success = successResult == true
	end

	if success then
		return true
	end

	local Character = iData.value11.Character

	if not Character then
		return false
	end

	local secondarySuccess, secondaryResult = pcall(function()
		return Character:GetAttribute("Stealing")
	end)

	if secondarySuccess then
		secondarySuccess = secondaryResult == true
	end

	if secondarySuccess then
		return true
	end

	local iterator, state, control = ipairs({
		"Carrying",
		"IsCarrying",
		"Grabbed",
		"Holding",
		"StealHold",
		"HasGrab",
	})

	repeat
		local firstChild

		repeat
			local controlResult

			control, controlResult = iterator(state, control)

			if not control then
				for _, child in ipairs(Character:GetChildren()) do
					if child:IsA("Tool") then
						local lower = child.Name:lower()

						if lower:find("brainrot") or (lower:find("skibidi") or lower:find("toilet")) then
							return true
						end

						local condition = iData.value164.isCarryableTool(child)

						if condition then
							condition = lower:find("animal") or (lower:find("pet") or (lower:find("rot") or #lower > 2))
						end

						if condition then
							if lower:find("bat") or (lower:find("slap") or lower:find("medusa")) then
							end
						end
					end

					if child:IsA("Model") and child:FindFirstChildWhichIsA("BasePart", true) then
						local lower = child.Name:lower()
						local find = lower:find("brainrot")

						if not find then
							find = lower:find("animal")

							if not find then
								find = lower:find("carry")

								if not find then
									find = lower:find("grab") or (lower:find("steal") or lower:find("hold"))
								end
							end
						end

						if not find then
							continue
						end

						return true
					end
				end

				return false
			end

			firstChild = Character:FindFirstChild(controlResult, true)
		until firstChild

		if firstChild:IsA("BoolValue") and firstChild.Value then
			return true
		end

		if firstChild:IsA("ObjectValue") and firstChild.Value then
			return true
		end
	until firstChild:IsA("StringValue") and firstChild.Value ~= ""

	return true
end
function iData.value164.isLocked()
	if not iData.value26.antiKick then
		return false
	end

	return iData.value164.inDuelCountdown() or iData.value164.holdingBrainrot()
end
function iData.value164.forceStop(_)
	local flag = false

	if iData.value31 then
		iData.value31 = false

		if iData.value55 then
			iData.value55()
		end

		if iData.value124 then
			iData.value124()
		end

		if iData.value54 then
			iData.value54(false)
		end

		if iData.value78 and iData.value78.autoBat then
			iData.value78.autoBat(false)
		end

		flag = true
	end

	if iData.value27 then
		iData.value27 = false

		if secondaryUpdateInstanceProperties then
			secondaryUpdateInstanceProperties()
		end

		if iData.value29 then
			iData.value29(false)
		end

		if iData.value78 and iData.value78.autoLeft then
			iData.value78.autoLeft(false)
		end

		flag = true
	end

	if iData.value28 then
		iData.value28 = false

		if iData.value150 then
			iData.value150()
		end

		if iData.value30 then
			iData.value30(false)
		end

		if iData.value78 and iData.value78.autoRight then
			iData.value78.autoRight(false)
		end

		flag = true
	end

	if iData.value26.tpBat then
		if iData.value26.stopTPBat then
			iData.value26.stopTPBat()
		end

		if iData.value26.setTPBatVisual then
			iData.value26.setTPBatVisual(false)
		end

		if iData.value78 and iData.value78.tpBat then
			iData.value78.tpBat(false)
		end

		flag = true
	end

	iData.value26.brainrot = iData.value164.holdingBrainrot()

	return flag
end
function iData.value164.tryStart()
	if iData.value164.isLocked() then
		iData.value164.forceStop("SAFE MODE")

		return false
	end

	return true
end
function iData.value26.enableAntiKick()
	iData.value26.antiKick = true

	if not iData.value164.monitorStarted then
		iData.value164.monitorStarted = true
		iData.value4.Heartbeat:Connect(function()
			if iData.value26.antiKick and iData.value164.isLocked() then
				iData.value164.forceStop("SAFE MODE")
			end

			iData.value26.brainrot = iData.value26.antiKick and iData.value164.holdingBrainrot()
		end)
	end

	if iData.value164.isLocked() then
		iData.value164.forceStop("SAFE MODE")
	end
end
function iData.value26.disableAntiKick()
	iData.value26.antiKick = true
end
function tpBatData.value1()
	if not iData.value17 then
		iData.value17 = true
		iData.value16 = false
	elseif iData.value17 and not iData.value16 then
		iData.value17 = true
		iData.value16 = true
	else
		iData.value17 = false
		iData.value16 = false
	end

	iData.value119()

	if iData.value78.laggerCarry then
		iData.value78.laggerCarry(iData.value17 and iData.value16)
	end

	if iData.value78.laggerNormal then
		iData.value78.laggerNormal(iData.value17 and not iData.value16)
	end

	if iData.value78.carrySpeed then
		iData.value78.carrySpeed(iData.value16 and not iData.value17)
	end

	if iData.value78.lagger then
		iData.value78.lagger(iData.value17)
	end

	if GuiToggleSetters and GuiToggleSetters.laggerCarry then
		pcall(function()
			GuiToggleSetters.laggerCarry(iData.value17 and iData.value16)
		end)
	end
end
iData.value165 = {
	"Bat",
	"Slap",
	"Iron Slap",
	"Gold Slap",
	"Diamond Slap",
	"Emerald Slap",
	"Ruby Slap",
	"Dark Matter Slap",
	"Flame Slap",
	"Nuclear Slap",
	"Galaxy Slap",
	"Glitched Slap",
}
function findBatForCounter()
	local Character = iData.value11.Character

	if not Character then
		return nil
	end

	local Backpack = iData.value11:FindFirstChildOfClass("Backpack")

	for _, item in ipairs(iData.value165) do
		local condition = Character:FindFirstChild(item) or Backpack and Backpack:FindFirstChild(item)

		if condition then
			return condition
		end
	end

	local iterator, state, control = ipairs(Character:GetChildren())
	local instance

	repeat
		control, instance = iterator(state, control)

		if not control then
			if Backpack then
				for _, child in ipairs(Backpack:GetChildren()) do
					if child:IsA("Tool") and child.Name:lower():find("bat") then
						return child
					end
				end
			end

			return nil
		end
	until instance:IsA("Tool") and instance.Name:lower():find("bat")

	return instance
end
function swingBatForCounter(instance, secondaryArgument)
	local Humanoid = secondaryArgument:FindFirstChildOfClass("Humanoid")

	if secondaryArgument ~= instance.Parent then
		if Humanoid then
			pcall(function()
				Humanoid:EquipTool(instance)
			end)
		end

		task.wait(0.05)
	end

	local remoteEvent = instance:FindFirstChildOfClass("RemoteEvent")
		or instance:FindFirstChildOfClass("RemoteFunction")

	if remoteEvent and remoteEvent:IsA("RemoteEvent") then
		pcall(function()
			remoteEvent:FireServer()
		end)
		task.wait(0.15)
		pcall(function()
			remoteEvent:FireServer()
		end)

		return
	end

	pcall(function()
		instance:Activate()
	end)
	task.wait(0.15)
	pcall(function()
		instance:Activate()
	end)
end
function iData.value56()
	if iData.value140.batCounter then
		return
	end

	iData.value140.batCounter = iData.value4.Heartbeat:Connect(function()
		if not iData.value21 or iData.value142 then
			return
		end

		local Character = iData.value11.Character

		if not Character then
			return
		end

		local Humanoid = Character:FindFirstChildOfClass("Humanoid")

		if not Humanoid then
			return
		end

		local State = Humanoid:GetState()

		if
			State == Enum.HumanoidStateType.Physics
			or (State == Enum.HumanoidStateType.Ragdoll or State == Enum.HumanoidStateType.FallingDown)
		then
			task.spawn(function()
				local condition = findBatForCounter()

				if condition then
					swingBatForCounter(condition, Character)
				end

				task.wait(0.5)
			end)
		end
	end)
end
iData.value166 = nil
iData.value167 = nil
function getClosestTarget()
	local input = iData.value11.Character and iData.value11.Character:FindFirstChild("HumanoidRootPart")
	if not input then
		return nil
	end
	local humanoidRootPart
	local magnitude = 1e999
	for _, player in ipairs(iData.value1:GetPlayers()) do
		if player ~= iData.value11 and player.Character then
			local HumanoidRootPart = player.Character:FindFirstChild("HumanoidRootPart")
			local Humanoid = player.Character:FindFirstChildOfClass("Humanoid")

			if HumanoidRootPart and (Humanoid and Humanoid.Health > 0) then
				local Magnitude = (HumanoidRootPart.Position - input.Position).Magnitude

				if Magnitude < magnitude then
					magnitude = Magnitude
					humanoidRootPart = HumanoidRootPart
				end
			end
		end
	end

	return humanoidRootPart
end
function swingCurrentBat()
	if not iData.value49 then
		return
	end

	local secondaryFindBat = findBat()

	if secondaryFindBat and (secondaryFindBat.Parent == iData.value11.Character and secondaryFindBat:IsA("Tool")) then
		pcall(function()
			secondaryFindBat:Activate()
		end)
	end
end
function iData.value123()
	iData.value26.tpBat = false

	if iData.value26.tpConn then
		pcall(function()
			iData.value26.tpConn:Disconnect()
		end)
		iData.value26.tpConn = nil
	end

	if iData.value26.setTPBatVisual then
		pcall(function()
			iData.value26.setTPBatVisual(false)
		end)
	end

	if iData.value78 and iData.value78.tpBat then
		pcall(function()
			iData.value78.tpBat(false)
		end)
	end

	if iData.value166 then
		iData.value166:Disconnect()
	end

	iData.value31 = true

	if iData.value27 then
		iData.value27 = false

		if iData.value29 then
			iData.value29(false)
		end

		secondaryUpdateInstanceProperties()
	end

	if iData.value28 then
		iData.value28 = false

		if iData.value30 then
			iData.value30(false)
		end

		iData.value150()
	end

	local autoRotateCondition = iData.value11.Character and iData.value11.Character:FindFirstChildOfClass("Humanoid")

	if autoRotateCondition then
		autoRotateCondition.AutoRotate = false
	end

	iData.value166 = iData.value4.RenderStepped:Connect(function()
		if not iData.value31 then
			return
		end

		local Character = iData.value11.Character

		if not Character then
			return
		end

		local HumanoidRootPart = Character:FindFirstChild("HumanoidRootPart")

		if not HumanoidRootPart then
			return
		end

		local Humanoid = Character:FindFirstChildOfClass("Humanoid")

		if not Humanoid then
			return
		end

		if not Character:FindFirstChildOfClass("Tool") then
			local condition = findBat()

			if condition then
				pcall(function()
					Humanoid:EquipTool(condition)
				end)
			end
		end

		local input = getClosestTarget()

		if not input then
			swingCurrentBat()

			return
		end

		local AssemblyLinearVelocity = input.AssemblyLinearVelocity
		local HumanoidRootPartPosition = HumanoidRootPart.Position
		local Position = input.Position
		local difference = Position
			+ AssemblyLinearVelocity * 0.14
			+ input.CFrame.LookVector * 0.3
			- HumanoidRootPartPosition
		local vector = Vector3.new(difference.X, 0, difference.Z)
		local secondaryVector = if not (vector.Magnitude < 0.05)
			then vector.Unit
			else HumanoidRootPart.CFrame.LookVector
		local vector36Number = 58
		local clampedValueNumber = (Position.Y + 3.7 - HumanoidRootPartPosition.Y) * 19.5
			+ AssemblyLinearVelocity.Y * 0.8

		if Humanoid.FloorMaterial ~= Enum.Material.Air then
			clampedValueNumber = math.max(clampedValueNumber, 13)
		end

		local clampedValue = math.clamp(clampedValueNumber, -70, 110)
		local result = Vector3.new(secondaryVector.X * vector36Number, clampedValue, secondaryVector.Z * vector36Number)

		HumanoidRootPart.AssemblyLinearVelocity = HumanoidRootPart.AssemblyLinearVelocity:Lerp(result, 0.8)

		local sum = Position + AssemblyLinearVelocity * math.clamp(AssemblyLinearVelocity.Magnitude / 150, 0.05, 0.2)

		if (sum - HumanoidRootPartPosition).Magnitude > 0.1 then
			local cFrame = CFrame.lookAt(HumanoidRootPartPosition, sum)
			local clampedValueNumber, number, secondaryClampedValueNumber = (HumanoidRootPart.CFrame:Inverse() * cFrame):ToEulerAnglesXYZ()
			local clampedValue = math.clamp(clampedValueNumber, -2.5, 2.5)
			local secondaryClampedValue = math.clamp(number, -2.5, 2.5)
			local alternateClampedValue = math.clamp(secondaryClampedValueNumber, -2.5, 2.5)

			HumanoidRootPart.AssemblyAngularVelocity = HumanoidRootPart.CFrame:VectorToWorldSpace(
				Vector3.new(clampedValue * 42, secondaryClampedValue * 42, alternateClampedValue * 42)
			)
		end

		swingCurrentBat()
	end)

	if iData.value54 then
		iData.value54(true)
	end

	if iData.value78 and iData.value78.autoBat then
		iData.value78.autoBat(true)
	end
end
function iData.value124()
	if iData.value166 then
		iData.value166:Disconnect()
		iData.value166 = nil
	end

	iData.value31 = false

	if iData.value167 then
		iData.value167:Destroy()
	end

	local Character = iData.value11.Character
	local assemblyLinearVelocityCondition = Character and Character:FindFirstChild("HumanoidRootPart")

	if assemblyLinearVelocityCondition then
		assemblyLinearVelocityCondition.AssemblyLinearVelocity = Vector3.zero
		assemblyLinearVelocityCondition.AssemblyAngularVelocity = Vector3.zero
	end

	local autoRotateCondition = Character and Character:FindFirstChildOfClass("Humanoid")

	if autoRotateCondition then
		autoRotateCondition.AutoRotate = true
	end

	if iData.value63 then
		if iData.value65 then
			task.cancel(iData.value65)
		end

		task.spawn(function()
			while iData.value63 do
				task.wait(0.1)
				pcall(function()
					doAutoTPDown(false)
				end)
			end
		end)
	end

	if iData.value54 then
		iData.value54(false)
	end

	if iData.value78 and iData.value78.autoBat then
		iData.value78.autoBat(false)
	end
end
function iData.value125()
	if iData.value26.tpBat and not iData.value26.tpConn then
		iData.value26.tpBat = false
	end

	if iData.value26.tpBat then
		if iData.value26.stopTPBat then
			iData.value26.stopTPBat()
		end

		if iData.value26.setTPBatVisual then
			iData.value26.setTPBatVisual(false)
		end

		if iData.value78 and iData.value78.tpBat then
			iData.value78.tpBat(false)
		end
	end

	if iData.value164 and (iData.value164.tryStart and not iData.value164.tryStart()) then
		return
	end

	if iData.value26.antiKick and iData.value26.brainrot then
		return
	end

	if iData.value27 then
		iData.value27 = false

		if iData.value29 then
			iData.value29(false)
		end

		secondaryUpdateInstanceProperties()
	end

	if iData.value28 then
		iData.value28 = false

		if iData.value30 then
			iData.value30(false)
		end

		iData.value150()
	end

	iData.value123()
end
function iData.value55()
	local Character = iData.value11.Character
	local assemblyLinearVelocityCondition = Character and Character:FindFirstChild("HumanoidRootPart")
	local autoRotateCondition = Character and Character:FindFirstChildOfClass("Humanoid")

	if assemblyLinearVelocityCondition then
		assemblyLinearVelocityCondition.AssemblyLinearVelocity = assemblyLinearVelocityCondition.AssemblyLinearVelocity
			* 0.3
		assemblyLinearVelocityCondition.AssemblyAngularVelocity = Vector3.zero
	end

	if autoRotateCondition then
		autoRotateCondition.AutoRotate = true
	end
end
function iData.value168()
	local function handleTpBatKey(gpArgument)
		if gpArgument.kb then
			local kbName = gpArgument.kb.Name
			local gp = gpArgument.gp and gpArgument.gp.Name

			return {
				kb = kbName,
				gp = gp,
			}
		end

		if gpArgument.gp then
			return {
				gp = gpArgument.gp.Name,
			}
		end

		return {
			kb = nil,
			gp = nil,
		}
	end

	local normalSpeed = iData.value12
	local carrySpeed = iData.value13
	local dropBrainrotKey = handleTpBatKey(iData.value131.DropBrainrot)
	local autoLeftKey = handleTpBatKey(iData.value131.AutoLeft)
	local autoRightKey = handleTpBatKey(iData.value131.AutoRight)
	local autoBatKey = handleTpBatKey(iData.value131.AutoBat)
	local laggerToggleKey = handleTpBatKey(iData.value131.LaggerToggle)
	local laggerCarryKey = handleTpBatKey(iData.value131.LaggerCarry)
	local tpBatKey = handleTpBatKey(iData.value131.TPBat)
	local tpFloorKey = handleTpBatKey(iData.value131.TPFloor)
	local guiHideKey = handleTpBatKey(iData.value131.GuiHide)
	local speedToggleKey = handleTpBatKey(iData.value131.SpeedToggle)
	local StealRadius = iData.value136.StealRadius
	local StealDuration = iData.value136.StealDuration
	local antiRagdoll = iData.value18
	local result = iData.value33
	local secondaryResult = iData.value32
	local mirrorTpDownEnabled = iData.value36
	local voidThemeName = iData.value43
	local AutoStealEnabled = iData.value136.AutoStealEnabled
	local value136Mode = iData.value136.Mode
	local stealBarStyle = iData.value76
	local stealBarScale = iData.value77
	local infiniteJump = iData.value19
	local infJumpMode = iData.value103
	local medusaCounter = iData.value20
	local batCounter = iData.value21
	local carrySpeedActive = iData.value16
	local laggerModeEnabled = iData.value17
	local laggerSpeed = iData.value14
	local laggerCarrySpeed = iData.value15
	local autoBat = iData.value31
	local aimbotAfterHit = iData.value47
	local autoSwing = iData.value49
	local unwalkEnabled = iData.value22
	local antiLag = iData.value57
	local stretchRez = iData.value60
	local autoTpEnabled = iData.value63
	local autoTpHeight = iData.value64
	local guiTransparencyEnabled = iData.value66
	local mobileButtonsEnabled = iData.value67
	local discordLinkEnabled = iData.value69
	local logoCircleEnabled = iData.value71
	local mobileButtonsLocked = iData.value68
	local mobileButtonsSize = iData.value73
	local circleButtonsEnabled = iData.value74
	local autoSwitchSpeed = iData.value85
	local uiLocked = iData.value102
	local headlessEnabled = iData.value88
	local korbloxEnabled = iData.value89
	local animPackEnabled = iData.value86
	local animPackName = iData.value87
	local fovValue = iData.value80
	local perButtonDrag = iData.value98
	local skyTheme = iData.value8
	local antiKick = iData.value26.antiKick
	local autoMoveSwing = iData.value50
	local autoMoveSwingInterval = iData.value51
	local ragdollGui = iData.value101
	local espEnabled = iData.value108
	local espAvatarsEnabled = iData.value109
	local backgroundEnabled = iData.value111
	local backgroundIndex = iData.value112
	local keys = (function()
		if not iData.value107 then
			return {}
		end

		local vNames = {}

		for k, item in pairs(iData.value107) do
			vNames[k] = item.Name
		end

		return vNames
	end)()
	local jsonencodeConfig = {
		normalSpeed = normalSpeed,
		carrySpeed = carrySpeed,
		dropBrainrotKey = dropBrainrotKey,
		autoLeftKey = autoLeftKey,
		autoRightKey = autoRightKey,
		autoBatKey = autoBatKey,
		laggerToggleKey = laggerToggleKey,
		laggerCarryKey = laggerCarryKey,
		tpBatKey = tpBatKey,
		tpFloorKey = tpFloorKey,
		guiHideKey = guiHideKey,
		speedToggleKey = speedToggleKey,
		grabRadius = StealRadius,
		stealDuration = StealDuration,
		antiRagdoll = antiRagdoll,
		batV2Speed = result,
		batV2Enabled = secondaryResult,
		mirrorTPDownEnabled = mirrorTpDownEnabled,
		voidThemeName = voidThemeName,
		autoStealEnabled = AutoStealEnabled,
		stealMode = value136Mode,
		stealBarStyle = stealBarStyle,
		stealBarScale = stealBarScale,
		infiniteJump = infiniteJump,
		infJumpMode = infJumpMode,
		medusaCounter = medusaCounter,
		batCounter = batCounter,
		carrySpeedActive = carrySpeedActive,
		laggerModeEnabled = laggerModeEnabled,
		laggerSpeed = laggerSpeed,
		laggerCarrySpeed = laggerCarrySpeed,
		autoBat = autoBat,
		aimbotAfterHit = aimbotAfterHit,
		autoSwing = autoSwing,
		unwalkEnabled = unwalkEnabled,
		antiLag = antiLag,
		stretchRez = stretchRez,
		autoTPEnabled = autoTpEnabled,
		autoTPHeight = autoTpHeight,
		guiTransparencyEnabled = guiTransparencyEnabled,
		mobileButtonsEnabled = mobileButtonsEnabled,
		discordLinkEnabled = discordLinkEnabled,
		logoCircleEnabled = logoCircleEnabled,
		mobileButtonsLocked = mobileButtonsLocked,
		mobileButtonsSize = mobileButtonsSize,
		circleButtonsEnabled = circleButtonsEnabled,
		autoSwitchSpeed = autoSwitchSpeed,
		uiLocked = uiLocked,
		headlessEnabled = headlessEnabled,
		korbloxEnabled = korbloxEnabled,
		animPackEnabled = animPackEnabled,
		animPackName = animPackName,
		fovValue = fovValue,
		perButtonDrag = perButtonDrag,
		skyTheme = skyTheme,
		antiKick = antiKick,
		autoMoveSwing = autoMoveSwing,
		autoMoveSwingInterval = autoMoveSwingInterval,
		ragdollGui = ragdollGui,
		espEnabled = espEnabled,
		espAvatarsEnabled = espAvatarsEnabled,
		backgroundEnabled = backgroundEnabled,
		backgroundIndex = backgroundIndex,
		keys = keys,
	}

	if writefile then
		pcall(function()
			writefile("RXZ_HUB.json", iData.value6:JSONEncode(jsonencodeConfig))
		end)
	end
end
task.spawn(function()
	while task.wait(5) do
		iData.value168()
	end
end)

function resetAllSettings()
	iData.value12 = 59
	iData.value13 = 29
	iData.value14 = 30
	iData.value15 = 15
	iData.value16 = false
	iData.value17 = false
	iData.value85 = false
	iData.value18 = false
	iData.value19 = false
	iData.value20 = false
	iData.value21 = false
	iData.value22 = false
	iData.value26.antiKick = true

	if iData.value26.enableAntiKick then
		iData.value26.enableAntiKick()
	end

	iData.value27 = false
	iData.value28 = false
	iData.value31 = false
	iData.value49 = true
	iData.value63 = false
	iData.value64 = 20
	iData.value57 = false
	iData.value60 = false
	iData.value136.AutoStealEnabled = false
	iData.value136.StealRadius = 60
	iData.value136.StealDuration = 1.3
	iData.value67 = true
	iData.value73 = 80
	iData.value69 = true
	iData.value102 = false
	iData.value80 = 80
	iData.value82 = 1
	iData.value131.DropBrainrot = {
		kb = nil,
		gp = nil,
	}
	iData.value131.AutoLeft = {
		kb = nil,
		gp = nil,
	}
	iData.value131.AutoRight = {
		kb = nil,
		gp = nil,
	}
	iData.value131.AutoBat = {
		kb = nil,
		gp = nil,
	}
	iData.value131.TPFloor = {
		kb = nil,
		gp = nil,
	}
	iData.value131.GuiHide = {
		kb = nil,
		gp = nil,
	}
	iData.value131.SpeedToggle = {
		kb = nil,
		gp = nil,
	}
	iData.value131.LaggerToggle = {
		kb = nil,
		gp = nil,
	}

	if iData.value119 then
		iData.value119()
	end

	if iData.value78.carrySpeed then
		iData.value78.carrySpeed(iData.value16)
	end

	if iData.value78.lagger then
		iData.value78.lagger(iData.value17)
	end

	if iData.value78.autoLeft then
		iData.value78.autoLeft(false)
	end

	if iData.value78.autoRight then
		iData.value78.autoRight(false)
	end

	if iData.value78.autoBat then
		iData.value78.autoBat(false)
	end

	iData.value124()
	iData.value145()
	secondaryUpdateInstanceProperties()
	iData.value150()
	iData.value122()
	iData.value154()
	stopHoldInfJump()

	if iData.value60 then
		iData.value60 = false
		pcall(function()
			iData.value4:UnbindFromRenderStep(iData.value156)
		end)
	end

	if iData.value57 then
		iData.value58 = false
		iData.value57 = false

		if iData.value59 then
			iData.value59:Disconnect()
			iData.value59 = nil
		end

		pcall(function()
			if iData.value158 then
				iData.value5.Brightness = iData.value158
			end

			if iData.value159 then
				iData.value5.ClockTime = iData.value159
			end

			if iData.value160 then
				iData.value5.OutdoorAmbient = iData.value160
			end

			iData.value5.ExposureCompensation = 0
		end)
	end

	iData.value168()
end
iData.value169 = {}
function trackConn(argument)
	table.insert(iData.value169, argument)

	return argument
end
function clearPersistentConns()
	for _, item in ipairs(iData.value169) do
		local capturedV = item

		pcall(function()
			capturedV:Disconnect()
		end)
	end
end
function iData.value119()
	local flag
	local secondaryFlag
	local alternateFlag
	local backgroundColor3
	local additionalFlag
	if iData.value143 then
		if iData.value17 then
			iData.value143.Text = not iData.value16 and "Lagger Mode" or "Lagger Carry"
		elseif iData.value16 then
			iData.value143.Text = "Carry"
		else
			iData.value143.Text = "Normal"
		end
	end
	repeat
		if flag or not (iData.value83 and (iData.value83.pill and iData.value83.dot)) then
			if not (iData.value84 and (iData.value84.pill and iData.value84.dot)) then
				return
			end
			local pill = iData.value84.pill
			local dot = iData.value84.dot
			local positionCondition = iData.value16
			local secondaryBackgroundColor = Color3.fromRGB(255, 255, 255)
			local alternateBackgroundColor = Color3.fromRGB(46, 24, 38)
			local additionalBackgroundColor = Color3.fromRGB(180, 150, 165)
			local result = iData.value2
			local tweenInfo = TweenInfo.new(0.16, Enum.EasingStyle.Quad)
			if positionCondition then
				if secondaryBackgroundColor then
					secondaryFlag = true
				end
			end
			if not secondaryFlag then
				secondaryBackgroundColor = alternateBackgroundColor
			end
			secondaryFlag = false
			result
				:Create(pill, tweenInfo, {
					BackgroundColor3 = secondaryBackgroundColor,
				})
				:Play()
			local secondaryResult = iData.value2
			local secondaryTweenInfo = TweenInfo.new(0.16, Enum.EasingStyle.Back)
			local position = positionCondition and UDim2.new(1, -13, 0.5, -5) or UDim2.new(0, 3, 0.5, -5)
			if positionCondition then
				backgroundColor3 = Color3.fromRGB(30, 30, 30)

				if backgroundColor3 then
					alternateFlag = true
				end
			end
			if not alternateFlag then
				backgroundColor3 = additionalBackgroundColor
			end
			alternateFlag = false
			secondaryResult
				:Create(dot, secondaryTweenInfo, {
					Position = position,
					BackgroundColor3 = backgroundColor3,
				})
				:Play()

			return
		end

		local pill = iData.value83.pill
		local dot = iData.value83.dot
		local value17Condition = iData.value17
		local secondaryBackgroundColor = Color3.fromRGB(255, 255, 255)
		local alternateBackgroundColor = Color3.fromRGB(46, 24, 38)
		local fromRgbResult = Color3.fromRGB(180, 150, 165)
		local result = iData.value2
		local tweenInfo = TweenInfo.new(0.16, Enum.EasingStyle.Quad)

		if value17Condition then
			if secondaryBackgroundColor then
				additionalFlag = true
			end
		end

		if not additionalFlag then
			secondaryBackgroundColor = alternateBackgroundColor
		end

		additionalFlag = false
		result
			:Create(pill, tweenInfo, {
				BackgroundColor3 = secondaryBackgroundColor,
			})
			:Play()

		local secondaryResult = iData.value2
		local secondaryTweenInfo = TweenInfo.new(0.16, Enum.EasingStyle.Back)
		local position = value17Condition and UDim2.new(1, -13, 0.5, -5) or UDim2.new(0, 3, 0.5, -5)

		if value17Condition then
			value17Condition = Color3.fromRGB(30, 30, 30)
		end

		local additionalBackgroundColor = value17Condition or fromRgbResult

		secondaryResult
			:Create(dot, secondaryTweenInfo, {
				Position = position,
				BackgroundColor3 = additionalBackgroundColor,
			})
			:Play()
		flag = true
	until not flag
end
function iData.value170()
	if iData.value17 then
		iData.value17 = false
	end

	iData.value16 = not iData.value16
	iData.value119()

	if iData.value78.carrySpeed then
		iData.value78.carrySpeed(iData.value16)
	end

	if iData.value78.lagger then
		iData.value78.lagger(iData.value17)
	end

	if iData.value78.laggerCarry then
		iData.value78.laggerCarry(false)
	end

	if iData.value78.laggerNormal then
		iData.value78.laggerNormal(false)
	end

	if GuiToggleSetters and GuiToggleSetters.carryMode then
		pcall(function()
			GuiToggleSetters.carryMode(iData.value16)
		end)
	end
end
iData.value171 = tpBatData.value1
function toggleLaggerCarry()
	if iData.value17 and iData.value16 then
		iData.value17 = false
		iData.value16 = false
	else
		iData.value17 = true
		iData.value16 = true
	end

	iData.value119()

	if iData.value78.laggerCarry then
		iData.value78.laggerCarry(iData.value17 and iData.value16)
	end

	if iData.value78.laggerNormal then
		iData.value78.laggerNormal(iData.value17 and not iData.value16)
	end

	if iData.value78.carrySpeed then
		iData.value78.carrySpeed(iData.value16 and not iData.value17)
	end

	if iData.value78.lagger then
		iData.value78.lagger(iData.value17)
	end

	if GuiToggleSetters and GuiToggleSetters.laggerCarry then
		pcall(function()
			GuiToggleSetters.laggerCarry(iData.value17 and iData.value16)
		end)
	end
end
function speedToggleAction() end
function iData.value122()
	if iData.value140.antiRag then
		iData.value140.antiRag:Disconnect()
		iData.value140.antiRag = nil
	end
end
local function additionalUpdateInstanceProperties()
	if iData.value140.antiRag then
		return
	end

	iData.value140.antiRag = iData.value4.Heartbeat:Connect(function()
		if not iData.value18 then
			return
		end

		local Character = iData.value11.Character

		if not Character then
			return
		end

		local Humanoid = Character:FindFirstChildOfClass("Humanoid")
		local HumanoidRootPart = Character:FindFirstChild("HumanoidRootPart")

		if not Humanoid or not HumanoidRootPart then
			return
		end

		local State = Humanoid:GetState()
		local updateInstancePropertiesFlag = State == Enum.HumanoidStateType.Physics
			or (State == Enum.HumanoidStateType.Ragdoll or State == Enum.HumanoidStateType.FallingDown)
		local RagdollEndTime = iData.value11:GetAttribute("RagdollEndTime")

		if RagdollEndTime and RagdollEndTime - workspace:GetServerTimeNow() > 0 then
			updateInstancePropertiesFlag = true
		end

		if updateInstancePropertiesFlag then
			pcall(function()
				local updateInstancePropertiesResult = iData.value11
				local updateInstancePropertiesData = { workspace:GetServerTimeNow() }

				updateInstancePropertiesResult:SetAttribute(
					"RagdollEndTime",
					unpackValues(updateInstancePropertiesData)
				)
			end)
			for _, descendant in ipairs(Character:GetDescendants()) do
				if
					descendant:IsA("BallSocketConstraint")
					or descendant:IsA("Attachment") and descendant.Name:find("RagdollAttachment")
				then
					descendant:Destroy()
				end
			end
			for index, item in ipairs(Character:GetDescendants()) do
				if item:IsA("Motor6D") and item.Enabled == false then
					item.Enabled = true
				end
			end
			if Humanoid.Health > 0 then
				Humanoid:ChangeState(Enum.HumanoidStateType.Running)
			end
			workspace.CurrentCamera.CameraSubject = Humanoid
			HumanoidRootPart.Anchored = false
			HumanoidRootPart.AssemblyLinearVelocity = Vector3.zero
			HumanoidRootPart.AssemblyAngularVelocity = Vector3.zero
		end
	end)
end
function iData.value120()
	local Character = iData.value11.Character

	if not Character then
		return
	end

	local Humanoid = Character:FindFirstChildOfClass("Humanoid")

	if Humanoid then
		for _, item in ipairs(Humanoid:GetPlayingAnimationTracks()) do
			item:Stop()
		end
	end

	local Animate = Character:FindFirstChild("Animate")

	if Animate then
		Animate:Clone()
		Animate:Destroy()
	end
end
function iData.value172()
	local Character = iData.value11.Character

	if Character and iData.value62 then
		iData.value62:Clone().Parent = Character
	end
end
function createStealBar()
	for _, item in ipairs({ "MoveeStealBar" }) do
		local firstChild = game:GetService("CoreGui"):FindFirstChild(item)

		if firstChild then
			firstChild:Destroy()
		end

		local PlayerGui = iData.value11:FindFirstChild("PlayerGui")

		if PlayerGui then
			local firstChild = PlayerGui:FindFirstChild(item)

			if firstChild then
				firstChild:Destroy()
			end
		end
	end
	local textColor3 = Color3.fromRGB(255, 255, 255)
	local backgroundColor3 = Color3.fromRGB(18, 10, 15)
	local number = tonumber(iData.value76) or 2
	if number ~= 1 and number ~= 2 then
		number = 2
	end
	local ScreenGui = Instance.new("ScreenGui")
	ScreenGui.Name = "MoveeStealBar"
	ScreenGui.ResetOnSpawn = false
	ScreenGui.IgnoreGuiInset = true
	ScreenGui.DisplayOrder = 8
	pcall(function()
		if syn and syn.protect_gui then
			syn.protect_gui(ScreenGui)
		end
	end)
	if not pcall(function()
		ScreenGui.Parent = game:GetService("CoreGui")
	end) then
		ScreenGui.Parent = iData.value11:WaitForChild("PlayerGui")
	end
	local TextLabel, Frame, UIGradient, valueLabel, textLabel, parent, secondaryValueLabel
	if number == 1 then
		local clampedValue = math.clamp(tonumber(iData.value77) or 1, 0.7, 1.8)
		local sizeNumber = math.floor(64 * clampedValue + 0.5)
		local positionNumber = math.floor(220 * clampedValue + 0.5)
		local sumNumber = math.floor(28 * clampedValue + 0.5)
		local color = Color3.fromRGB(255, 255, 255)
		local backgroundColor3 = Color3.fromRGB(18, 10, 15)

		iData.value75 = Instance.new("Frame", ScreenGui)
		iData.value75.Size = UDim2.new(0, sizeNumber, 0, positionNumber)
		iData.value75.Position = UDim2.new(0, 300, 0.5, -positionNumber / 2)
		iData.value75.BackgroundColor3 = backgroundColor3
		iData.value75.BorderSizePixel = 0
		iData.value75.ZIndex = 20
		iData.value75.ClipsDescendants = true
		iData.value75.Visible = true
		iData.value75.Active = true
		Instance.new("UICorner", iData.value75).CornerRadius = UDim.new(0, (math.floor(18 * clampedValue + 0.5)))

		local UIStroke = Instance.new("UIStroke", iData.value75)

		UIStroke.Color = color
		UIStroke.Thickness = 2
		UIStroke.Transparency = 0.3
		task.defer(function()
			pcall(function()
				local absoluteSizeOption = GuiRefs and GuiRefs.outer

				if absoluteSizeOption and absoluteSizeOption.Parent then
					local AbsolutePosition = absoluteSizeOption.AbsolutePosition
					local AbsoluteSize = absoluteSizeOption.AbsoluteSize
					local sum = AbsolutePosition.X + AbsoluteSize.X + 12
					local difference = AbsolutePosition.Y + AbsoluteSize.Y * 0.5 - positionNumber * 0.5

					iData.value75.Position = UDim2.new(0, math.floor(sum), 0, (math.floor(difference)))
				end
			end)
		end)

		local frame = Instance.new("Frame", iData.value75)

		frame.Name = "Galaxy"
		frame.Size = UDim2.new(1, 0, 1, 0)
		frame.BackgroundTransparency = 1
		frame.BorderSizePixel = 0
		frame.ZIndex = 20
		frame.ClipsDescendants = true
		Instance.new("UICorner", frame).CornerRadius = UDim.new(0, (math.floor(18 * clampedValue + 0.5)))

		local secondaryParent = Instance.new("Frame", frame)

		secondaryParent.Size = UDim2.new(1.2, 0, 0.55, 0)
		secondaryParent.Position = UDim2.new(-0.1, 0, -0.05, 0)
		secondaryParent.BackgroundColor3 = Color3.fromRGB(90, 40, 180)
		secondaryParent.BackgroundTransparency = 0.82
		secondaryParent.BorderSizePixel = 0
		secondaryParent.ZIndex = 20
		Instance.new("UICorner", secondaryParent).CornerRadius = UDim.new(1, 0)

		local alternateParent = Instance.new("Frame", frame)

		alternateParent.Size = UDim2.new(1.2, 0, 0.5, 0)
		alternateParent.Position = UDim2.new(-0.1, 0, 0.55, 0)
		alternateParent.BackgroundColor3 = Color3.fromRGB(40, 80, 200)
		alternateParent.BackgroundTransparency = 0.85
		alternateParent.BorderSizePixel = 0
		alternateParent.ZIndex = 20
		Instance.new("UICorner", alternateParent).CornerRadius = UDim.new(1, 0)

		local random = Random.new()

		for _ = 1, 18 do
			local parent = Instance.new("Frame", frame)
			local nextInteger = random:NextInteger(1, 2)

			parent.Size = UDim2.new(0, nextInteger, 0, nextInteger)
			parent.Position = UDim2.new(random:NextNumber(0.1, 0.9), 0, random:NextNumber(0.08, 0.92), 0)
			parent.BackgroundColor3 =
				Color3.fromRGB(220 + random:NextInteger(0, 35), 210 + random:NextInteger(0, 40), 255)
			parent.BackgroundTransparency = random:NextNumber(0.15, 0.55)
			parent.BorderSizePixel = 0
			parent.ZIndex = 21
			Instance.new("UICorner", parent).CornerRadius = UDim.new(1, 0)
			task.spawn(function()
				while parent and parent.Parent do
					local create = iData.value2:Create(
						parent,
						TweenInfo.new(random:NextNumber(0.8, 2.2), Enum.EasingStyle.Sine, Enum.EasingDirection.InOut),
						{
							BackgroundTransparency = random:NextNumber(0.05, 0.7),
						}
					)

					create:Play()
					create.Completed:Wait()
				end
			end)
		end

		local additionalParent = Instance.new("Frame", iData.value75)

		additionalParent.Size = UDim2.new(0, sumNumber, 0, sumNumber)
		additionalParent.Position = UDim2.new(0.5, -sumNumber / 2, 0, (math.floor(8 * clampedValue + 0.5)))
		additionalParent.BackgroundColor3 = Color3.fromRGB(30, 20, 28)
		additionalParent.BorderSizePixel = 0
		additionalParent.ZIndex = 28
		Instance.new("UICorner", additionalParent).CornerRadius = UDim.new(1, 0)

		local uiStroke = Instance.new("UIStroke", additionalParent)

		uiStroke.Color = color
		uiStroke.Thickness = 1.2
		uiStroke.Transparency = 0.35

		local ImageLabel = Instance.new("ImageLabel", additionalParent)

		ImageLabel.Size = UDim2.new(1, -2, 1, -2)
		ImageLabel.Position = UDim2.new(0, 1, 0, 1)
		ImageLabel.BackgroundTransparency = 1
		ImageLabel.BorderSizePixel = 0
		ImageLabel.ZIndex = 29
		ImageLabel.ScaleType = Enum.ScaleType.Crop
		ImageLabel.Image = "rbxthumb://type=AvatarHeadShot&id=" .. tostring(iData.value11.UserId) .. "&w=150&h=150"
		Instance.new("UICorner", ImageLabel).CornerRadius = UDim.new(1, 0)
		TextLabel = Instance.new("TextLabel", iData.value75)
		TextLabel.Size = UDim2.new(1, -6, 0, math.floor(18 * clampedValue + 0.5))
		TextLabel.Position = UDim2.new(0, 3, 0, math.floor(8 * clampedValue + 0.5) + sumNumber + 2)
		TextLabel.BackgroundTransparency = 1
		TextLabel.Text = "0%"
		TextLabel.TextColor3 = color
		TextLabel.Font = Enum.Font.GothamBlack
		TextLabel.TextSize = math.max(11, (math.floor(13 * clampedValue + 0.5)))
		TextLabel.ZIndex = 26

		local secondaryTextLabel = Instance.new("TextLabel", iData.value75)

		secondaryTextLabel.Size = UDim2.new(1, -6, 0, math.floor(12 * clampedValue + 0.5))
		secondaryTextLabel.Position =
			UDim2.new(0, 3, 0, math.floor(8 * clampedValue + 0.5) + sumNumber + math.floor(18 * clampedValue + 0.5))
		secondaryTextLabel.BackgroundTransparency = 1
		secondaryTextLabel.Text = "STEAL"
		secondaryTextLabel.TextColor3 = color
		secondaryTextLabel.Font = Enum.Font.GothamBold
		secondaryTextLabel.TextSize = math.max(8, (math.floor(9 * clampedValue + 0.5)))
		secondaryTextLabel.ZIndex = 26

		local sum = math.floor(8 * clampedValue + 0.5) + sumNumber + math.floor(32 * clampedValue + 0.5)
		local number = math.floor(34 * clampedValue + 0.5)
		local fallbackParent = Instance.new("Frame", iData.value75)

		fallbackParent.Size = UDim2.new(0, math.floor(14 * clampedValue + 0.5), 1, -(sum + number))
		fallbackParent.Position = UDim2.new(0.5, -math.floor(7 * clampedValue + 0.5), 0, sum)
		fallbackParent.BackgroundColor3 = Color3.fromRGB(30, 18, 26)
		fallbackParent.BorderSizePixel = 0
		fallbackParent.ZIndex = 21
		fallbackParent.ClipsDescendants = true
		Instance.new("UICorner", fallbackParent).CornerRadius = UDim.new(1, 0)

		local secondaryUiStroke = Instance.new("UIStroke", fallbackParent)

		secondaryUiStroke.Color = color
		secondaryUiStroke.Thickness = 1
		secondaryUiStroke.Transparency = 0.55
		Frame = Instance.new("Frame", fallbackParent)
		Frame.AnchorPoint = Vector2.new(0, 1)
		Frame.Size = UDim2.new(1, 0, 0, 0)
		Frame.Position = UDim2.new(0, 0, 1, 0)
		Frame.BackgroundColor3 = color
		Frame.BorderSizePixel = 0
		Frame.ZIndex = 22
		Instance.new("UICorner", Frame).CornerRadius = UDim.new(1, 0)
		UIGradient = Instance.new("UIGradient", Frame)
		UIGradient.Rotation = 90
		UIGradient.Color = ColorSequence.new({
			ColorSequenceKeypoint.new(0, Color3.fromRGB(200, 200, 200)),
			ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255, 255, 255)),
			ColorSequenceKeypoint.new(1, Color3.fromRGB(200, 200, 200)),
		})
		valueLabel = Instance.new("TextLabel", iData.value75)
		valueLabel.Size = UDim2.new(1, -6, 0, math.floor(12 * clampedValue + 0.5))
		valueLabel.Position = UDim2.new(0, 3, 1, -math.floor(28 * clampedValue + 0.5))
		valueLabel.BackgroundTransparency = 1
		valueLabel.Text = "--"
		valueLabel.TextColor3 = color
		valueLabel.Font = Enum.Font.GothamBold
		valueLabel.TextSize = math.max(8, (math.floor(9 * clampedValue + 0.5)))
		valueLabel.ZIndex = 26
		textLabel = Instance.new("TextLabel", iData.value75)
		textLabel.Size = UDim2.new(1, -6, 0, math.floor(12 * clampedValue + 0.5))
		textLabel.Position = UDim2.new(0, 3, 1, -math.floor(14 * clampedValue + 0.5))
		textLabel.BackgroundTransparency = 1
		textLabel.Text = "--"
		textLabel.TextColor3 = color
		textLabel.Font = Enum.Font.GothamBold
		textLabel.TextSize = math.max(8, (math.floor(9 * clampedValue + 0.5)))
		textLabel.ZIndex = 26
		parent = Instance.new("Frame", ScreenGui)
		parent.Size = UDim2.new(0, math.floor(140 * clampedValue + 0.5), 0, (math.floor(18 * clampedValue + 0.5)))
		parent.Position = UDim2.new(0, 300, 0.5, -positionNumber / 2 - math.floor(24 * clampedValue + 0.5))
		parent.BackgroundColor3 = Color3.fromRGB(40, 10, 10)
		parent.BackgroundTransparency = 0.15
		parent.BorderSizePixel = 0
		parent.Visible = false
		parent.ZIndex = 25
		Instance.new("UICorner", parent).CornerRadius = UDim.new(1, 0)
		secondaryValueLabel = Instance.new("TextLabel", parent)
		secondaryValueLabel.Size = UDim2.new(1, 0, 1, 0)
		secondaryValueLabel.BackgroundTransparency = 1
		secondaryValueLabel.Text = ""
		secondaryValueLabel.TextColor3 = Color3.fromRGB(255, 120, 120)
		secondaryValueLabel.Font = Enum.Font.GothamBold
		secondaryValueLabel.TextSize = math.max(8, (math.floor(9 * clampedValue + 0.5)))
		secondaryValueLabel.ZIndex = 26
		task.spawn(function()
			local textNumber = 0
			local timestamp = tick()
			while valueLabel and valueLabel.Parent do
				textNumber += 1

				local secondaryTimestamp = tick()

				if secondaryTimestamp - timestamp >= 0.5 then
					valueLabel.Text = tostring((math.floor(textNumber / (secondaryTimestamp - timestamp) + 0.5)))
						.. " fps"
					timestamp = secondaryTimestamp
				end

				task.wait()
			end
		end)
		task.spawn(function()
			while textLabel and textLabel.Parent do
				pcall(function()
					local textNumber =
						math.floor(game:GetService("Stats").Network.ServerStatsItem["Data Ping"]:GetValue() + 0.5)
					local textColor3 = if not (textNumber < 80)
						then if not (textNumber < 150) then Color3.fromRGB(255, 60, 60) else Color3.fromRGB(255, 200, 0)
						else Color3.fromRGB(0, 255, 120)

					textLabel.Text = tostring(textNumber) .. " ms"
					textLabel.TextColor3 = textColor3

					if textNumber >= 150 then
						secondaryValueLabel.Text = "HIGH PING " .. tostring(textNumber)
						parent.Visible = true

						if iData.value75 then
							parent.Position = UDim2.new(
								iData.value75.Position.X.Scale,
								iData.value75.Position.X.Offset,
								iData.value75.Position.Y.Scale,
								iData.value75.Position.Y.Offset - math.floor(22 * clampedValue + 0.5)
							)

							return
						end
					else
						parent.Visible = false
					end
				end)
				task.wait(0.5)
			end
		end)
		iData.value75:SetAttribute("StealStyle", 1)
	else
		local clampedValue = math.clamp(tonumber(iData.value77) or 1, 0.7, 1.8)
		local sizeNumber = math.floor(360 * clampedValue + 0.5)
		local positionNumber = math.floor(40 * clampedValue + 0.5)
		local sumNumber = math.floor(32 * clampedValue + 0.5)

		iData.value75 = Instance.new("Frame", ScreenGui)
		iData.value75.Size = UDim2.new(0, sizeNumber, 0, positionNumber)
		iData.value75.Position = UDim2.new(0.5, -sizeNumber / 2, 0.88, 0)
		iData.value75.BackgroundColor3 = backgroundColor3
		iData.value75.BorderSizePixel = 0
		iData.value75.ZIndex = 20
		iData.value75.ClipsDescendants = true
		iData.value75.Visible = true
		iData.value75.Active = true
		Instance.new("UICorner", iData.value75).CornerRadius = UDim.new(1, 0)

		local UIStroke = Instance.new("UIStroke", iData.value75)

		UIStroke.Color = textColor3
		UIStroke.Thickness = 2
		UIStroke.Transparency = 0.3

		local frame = Instance.new("Frame", iData.value75)

		frame.Name = "Galaxy"
		frame.Size = UDim2.new(1, 0, 1, 0)
		frame.BackgroundTransparency = 1
		frame.BorderSizePixel = 0
		frame.ZIndex = 20
		frame.ClipsDescendants = true
		Instance.new("UICorner", frame).CornerRadius = UDim.new(1, 0)

		local secondaryParent = Instance.new("Frame", frame)

		secondaryParent.Size = UDim2.new(0.55, 0, 1.4, 0)
		secondaryParent.Position = UDim2.new(-0.05, 0, -0.2, 0)
		secondaryParent.BackgroundColor3 = Color3.fromRGB(90, 40, 180)
		secondaryParent.BackgroundTransparency = 0.82
		secondaryParent.BorderSizePixel = 0
		secondaryParent.ZIndex = 20
		Instance.new("UICorner", secondaryParent).CornerRadius = UDim.new(1, 0)

		local alternateParent = Instance.new("Frame", frame)

		alternateParent.Size = UDim2.new(0.5, 0, 1.3, 0)
		alternateParent.Position = UDim2.new(0.55, 0, -0.15, 0)
		alternateParent.BackgroundColor3 = Color3.fromRGB(40, 80, 200)
		alternateParent.BackgroundTransparency = 0.85
		alternateParent.BorderSizePixel = 0
		alternateParent.ZIndex = 20
		Instance.new("UICorner", alternateParent).CornerRadius = UDim.new(1, 0)

		local random = Random.new()

		for _ = 1, 28 do
			local parent = Instance.new("Frame", frame)
			local nextInteger = random:NextInteger(1, 2)

			parent.Size = UDim2.new(0, nextInteger, 0, nextInteger)
			parent.Position = UDim2.new(random:NextNumber(0.02, 0.98), 0, random:NextNumber(0.1, 0.9), 0)
			parent.BackgroundColor3 =
				Color3.fromRGB(220 + random:NextInteger(0, 35), 210 + random:NextInteger(0, 40), 255)
			parent.BackgroundTransparency = random:NextNumber(0.15, 0.55)
			parent.BorderSizePixel = 0
			parent.ZIndex = 21
			Instance.new("UICorner", parent).CornerRadius = UDim.new(1, 0)
			task.spawn(function()
				while parent and parent.Parent do
					local create = iData.value2:Create(
						parent,
						TweenInfo.new(random:NextNumber(0.8, 2.2), Enum.EasingStyle.Sine, Enum.EasingDirection.InOut),
						{
							BackgroundTransparency = random:NextNumber(0.05, 0.7),
						}
					)

					create:Play()
					create.Completed:Wait()
				end
			end)
		end

		task.spawn(function()
			while frame and frame.Parent do
				task.wait(random:NextNumber(2.2, 4.5))

				local parent = Instance.new("Frame", frame)

				parent.BackgroundColor3 = Color3.fromRGB(210, 190, 255)
				parent.Size = UDim2.new(0, random:NextInteger(18, 36), 0, 1)
				parent.Position = UDim2.new(random:NextNumber(0, 0.5), 0, random:NextNumber(0.15, 0.75), 0)
				parent.Rotation = -18
				parent.BackgroundTransparency = 0.1
				parent.BorderSizePixel = 0
				parent.ZIndex = 22
				Instance.new("UICorner", parent).CornerRadius = UDim.new(1, 0)
				iData.value2
					:Create(parent, TweenInfo.new(0.45, Enum.EasingStyle.Linear), {
						Position = UDim2.new(parent.Position.X.Scale + 0.35, 0, parent.Position.Y.Scale + 0.2, 0),
						BackgroundTransparency = 1,
					})
					:Play()
				task.delay(0.5, function()
					if parent then
						parent:Destroy()
					end
				end)
			end
		end)

		local additionalParent = Instance.new("Frame", iData.value75)

		additionalParent.Size = UDim2.new(0, sumNumber, 0, sumNumber)
		additionalParent.Position = UDim2.new(0, 4, 0.5, -sumNumber / 2)
		additionalParent.BackgroundColor3 = Color3.fromRGB(30, 20, 28)
		additionalParent.BorderSizePixel = 0
		additionalParent.ZIndex = 28
		Instance.new("UICorner", additionalParent).CornerRadius = UDim.new(1, 0)

		local ImageLabel = Instance.new("ImageLabel", additionalParent)

		ImageLabel.Size = UDim2.new(1, -2, 1, -2)
		ImageLabel.Position = UDim2.new(0, 1, 0, 1)
		ImageLabel.BackgroundTransparency = 1
		ImageLabel.BorderSizePixel = 0
		ImageLabel.ZIndex = 29
		ImageLabel.ScaleType = Enum.ScaleType.Crop
		ImageLabel.Image = "rbxthumb://type=AvatarHeadShot&id=" .. tostring(iData.value11.UserId) .. "&w=150&h=150"
		Instance.new("UICorner", ImageLabel).CornerRadius = UDim.new(1, 0)
		Frame = Instance.new("Frame", iData.value75)
		Frame.Size = UDim2.new(0, 0, 1, 0)
		Frame.BackgroundColor3 = textColor3
		Frame.BorderSizePixel = 0
		Frame.ZIndex = 21
		Instance.new("UICorner", Frame).CornerRadius = UDim.new(1, 0)
		UIGradient = Instance.new("UIGradient", Frame)
		UIGradient.Color = ColorSequence.new({
			ColorSequenceKeypoint.new(0, Color3.fromRGB(200, 200, 200)),
			ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255, 255, 255)),
			ColorSequenceKeypoint.new(1, Color3.fromRGB(200, 200, 200)),
		})

		local sum = sumNumber + 12
		local fallbackParent = Instance.new("Frame", iData.value75)

		fallbackParent.Size = UDim2.new(0, 110, 1, 0)
		fallbackParent.Position = UDim2.new(0, sum, 0, 0)
		fallbackParent.BackgroundTransparency = 1
		fallbackParent.ZIndex = 25

		local secondaryTextLabel = Instance.new("TextLabel", fallbackParent)

		secondaryTextLabel.Size = UDim2.new(0, 55, 1, 0)
		secondaryTextLabel.Position = UDim2.new(0, 0, 0, 0)
		secondaryTextLabel.BackgroundTransparency = 1
		secondaryTextLabel.Text = "STEAL"
		secondaryTextLabel.TextColor3 = textColor3
		secondaryTextLabel.Font = Enum.Font.GothamBlack
		secondaryTextLabel.TextSize = 12
		secondaryTextLabel.TextXAlignment = Enum.TextXAlignment.Left
		secondaryTextLabel.ZIndex = 26
		iData.value75:SetAttribute("StealStyle", 2)
		TextLabel = Instance.new("TextLabel", fallbackParent)
		TextLabel.Size = UDim2.new(0, 50, 1, 0)
		TextLabel.Position = UDim2.new(0, 55, 0, 0)
		TextLabel.BackgroundTransparency = 1
		TextLabel.Text = "0%"
		TextLabel.TextColor3 = textColor3
		TextLabel.Font = Enum.Font.GothamBlack
		TextLabel.TextSize = 12
		TextLabel.TextXAlignment = Enum.TextXAlignment.Left
		TextLabel.ZIndex = 26

		local secondaryFrame = Instance.new("Frame", iData.value75)

		secondaryFrame.Size = UDim2.new(0, 1, 0, positionNumber * 0.45)
		secondaryFrame.Position = UDim2.new(0, sum + 110, 0.5, -(positionNumber * 0.45) / 2)
		secondaryFrame.BackgroundColor3 = textColor3
		secondaryFrame.BackgroundTransparency = 0.6
		secondaryFrame.BorderSizePixel = 0
		secondaryFrame.ZIndex = 25
		valueLabel = Instance.new("TextLabel", iData.value75)
		valueLabel.Size = UDim2.new(0, 68, 1, 0)
		valueLabel.Position = UDim2.new(0, sum + 118, 0, 0)
		valueLabel.BackgroundTransparency = 1
		valueLabel.Text = "FPS: --"
		valueLabel.TextColor3 = textColor3
		valueLabel.Font = Enum.Font.GothamBold
		valueLabel.TextSize = 10
		valueLabel.TextXAlignment = Enum.TextXAlignment.Left
		valueLabel.ZIndex = 26
		task.spawn(function()
			local textNumber = 0
			local timestamp = tick()
			while valueLabel and valueLabel.Parent do
				textNumber += 1

				local secondaryTimestamp = tick()

				if secondaryTimestamp - timestamp >= 0.5 then
					valueLabel.Text = "FPS: "
						.. tostring((math.floor(textNumber / (secondaryTimestamp - timestamp) + 0.5)))
					timestamp = secondaryTimestamp
				end

				task.wait()
			end
		end)

		local alternateFrame = Instance.new("Frame", iData.value75)

		alternateFrame.Size = UDim2.new(0, 1, 0, positionNumber * 0.45)
		alternateFrame.Position = UDim2.new(0, sum + 190, 0.5, -(positionNumber * 0.45) / 2)
		alternateFrame.BackgroundColor3 = textColor3
		alternateFrame.BackgroundTransparency = 0.6
		alternateFrame.BorderSizePixel = 0
		alternateFrame.ZIndex = 25
		textLabel = Instance.new("TextLabel", iData.value75)
		textLabel.Size = UDim2.new(0, 90, 1, 0)
		textLabel.Position = UDim2.new(0, sum + 198, 0, 0)
		textLabel.BackgroundTransparency = 1
		textLabel.Text = "PING: --"
		textLabel.TextColor3 = textColor3
		textLabel.Font = Enum.Font.GothamBold
		textLabel.TextSize = 10
		textLabel.TextXAlignment = Enum.TextXAlignment.Left
		textLabel.ZIndex = 26
		parent = Instance.new("Frame", ScreenGui)
		parent.Size = UDim2.new(0, 280, 0, 24)
		parent.Position = UDim2.new(0.5, -140, 0.88, -30)
		parent.BackgroundColor3 = Color3.fromRGB(50, 10, 10)
		parent.BackgroundTransparency = 0.15
		parent.BorderSizePixel = 0
		parent.Visible = false
		parent.ZIndex = 30
		Instance.new("UICorner", parent).CornerRadius = UDim.new(1, 0)
		secondaryValueLabel = Instance.new("TextLabel", parent)
		secondaryValueLabel.Size = UDim2.new(1, -8, 1, 0)
		secondaryValueLabel.Position = UDim2.new(0, 4, 0, 0)
		secondaryValueLabel.BackgroundTransparency = 1
		secondaryValueLabel.Text = ""
		secondaryValueLabel.TextColor3 = Color3.fromRGB(255, 120, 120)
		secondaryValueLabel.Font = Enum.Font.GothamBold
		secondaryValueLabel.TextSize = 11
		secondaryValueLabel.ZIndex = 31
		task.spawn(function()
			while textLabel and textLabel.Parent do
				pcall(function()
					local textNumber =
						math.floor(game:GetService("Stats").Network.ServerStatsItem["Data Ping"]:GetValue() + 0.5)
					local textColor3 = if not (textNumber < 80)
						then if not (textNumber < 150) then Color3.fromRGB(255, 60, 60) else Color3.fromRGB(255, 200, 0)
						else Color3.fromRGB(0, 255, 120)

					textLabel.Text = "PING: " .. tostring(textNumber) .. "ms"
					textLabel.TextColor3 = textColor3

					if textNumber >= 150 then
						secondaryValueLabel.Text = "WARNING: HIGH PING  \194\183  " .. tostring(textNumber) .. "ms"
						parent.Visible = true
						parent.Active = true

						return
					end

					parent.Visible = false
					parent.Active = false
				end)
				task.wait(0.5)
			end
		end)
	end
	task.spawn(function()
		while Frame and Frame.Parent do
			local timestamp = tick()

			if iData.value75 then
				iData.value75.Visible = true
				iData.value75.Active = true
			end

			local condition = iData.value75 and iData.value75:GetAttribute("StealStyle") == 1

			if iData.value136.AutoStealEnabled then
				local sizeNumber = tonumber(iData.value139) or 0

				if condition then
					Frame.Size = UDim2.new(1, 0, sizeNumber, 0)
				else
					Frame.Size = UDim2.new(sizeNumber, 0, 1, 0)
				end

				if UIGradient then
					UIGradient.Offset = Vector2.new(math.sin(timestamp * 3) * 0.5, 0)
				end

				if TextLabel then
					TextLabel.Text = math.floor(sizeNumber * 100) .. "%"
				end
			else
				if condition then
					Frame.Size = UDim2.new(1, 0, 0, 0)
				else
					Frame.Size = UDim2.new(0, 0, 1, 0)
				end

				if TextLabel then
					TextLabel.Text = "0%"
				end
			end

			task.wait(0.016)
		end
	end)
	local inputPosition
	local value75Position
	local flag = false
	iData.value75.InputBegan:Connect(function(input)
		if iData.value102 then
			return
		end

		if
			input.UserInputType == Enum.UserInputType.MouseButton1
			or input.UserInputType == Enum.UserInputType.Touch
		then
			flag = true
			inputPosition = input.Position
			value75Position = iData.value75.Position
			input.Changed:Connect(function()
				if input.UserInputState == Enum.UserInputState.End then
					flag = false
				end
			end)
		end
	end)
	iData.value3.InputChanged:Connect(function(input)
		if iData.value102 then
			flag = false

			return
		end

		if
			flag and input.UserInputType == Enum.UserInputType.MouseMovement
			or input.UserInputType == Enum.UserInputType.Touch
		then
			local difference = input.Position - inputPosition

			iData.value75.Position = UDim2.new(
				value75Position.X.Scale,
				value75Position.X.Offset + difference.X,
				value75Position.Y.Scale,
				value75Position.Y.Offset + difference.Y
			)
		end
	end)
end
createStealBar()
iData.value173 = {
	"Bat",
	"Slap",
	"Iron Slap",
	"Gold Slap",
	"Diamond Slap",
	"Emerald Slap",
	"Ruby Slap",
	"Dark Matter Slap",
	"Flame Slap",
	"Nuclear Slap",
	"Galaxy Slap",
	"Glitched Slap",
}
function iData.value26.findBat()
	local Character = iData.value11.Character

	if not Character then
		return nil
	end

	for _, item in ipairs(iData.value173) do
		local firstChild = Character:FindFirstChild(item)

		if firstChild and firstChild:IsA("Tool") then
			return firstChild
		end
	end

	local Backpack = iData.value11:FindFirstChildOfClass("Backpack")

	if Backpack then
		for _, item in ipairs(iData.value173) do
			local firstChild = Backpack:FindFirstChild(item)

			if firstChild and firstChild:IsA("Tool") then
				local Humanoid = Character:FindFirstChildOfClass("Humanoid")

				if Humanoid then
					pcall(function()
						Humanoid:EquipTool(firstChild)
					end)
				end

				return firstChild
			end
		end
	end

	for _, child in ipairs(Character:GetChildren()) do
		if child:IsA("Tool") and child.Name:lower():find("bat") or child.Name:lower():find("slap") then
			return child
		end
	end

	return nil
end
function iData.value26.closestRoot()
	local Character = iData.value11.Character
	local input = Character and Character:FindFirstChild("HumanoidRootPart")
	if not input then
		return nil, 1e999
	end
	local magnitude = 1e999
	local humanoidRootPart
	for _, player in ipairs(iData.value1:GetPlayers()) do
		if player ~= iData.value11 and player.Character then
			local HumanoidRootPart = player.Character:FindFirstChild("HumanoidRootPart")
			local Humanoid = player.Character:FindFirstChildOfClass("Humanoid")

			if HumanoidRootPart and (Humanoid and Humanoid.Health > 0) then
				local Magnitude = (HumanoidRootPart.Position - input.Position).Magnitude

				if Magnitude < magnitude then
					magnitude = Magnitude
					humanoidRootPart = HumanoidRootPart
				end
			end
		end
	end

	return humanoidRootPart, magnitude
end
function iData.value26.tpHit()
	if iData.value26.hitCD then
		return
	end

	iData.value26.hitCD = true
	pcall(function()
		local Character = iData.value11.Character

		if not Character then
			return
		end

		local Humanoid = Character:FindFirstChildOfClass("Humanoid")
		local secondaryFindBat = iData.value26.findBat()

		if not secondaryFindBat then
			return
		end

		if Character ~= secondaryFindBat.Parent and Humanoid then
			pcall(function()
				Humanoid:EquipTool(secondaryFindBat)
			end)
		end

		for _ = 1, 3 do
			pcall(function()
				secondaryFindBat:Activate()
			end)

			local RemoteEvent = secondaryFindBat:FindFirstChildWhichIsA("RemoteEvent")

			if RemoteEvent then
				pcall(function()
					RemoteEvent:FireServer()
				end)
			end

			for _, descendant in ipairs(secondaryFindBat:GetDescendants()) do
				local capturedDescendant = descendant

				if capturedDescendant:IsA("RemoteEvent") then
					pcall(function()
						capturedDescendant:FireServer()
					end)
				end
			end
		end

		task.defer(function()
			if secondaryFindBat and secondaryFindBat.Parent then
				pcall(function()
					secondaryFindBat:Activate()
				end)

				local RemoteEvent = secondaryFindBat:FindFirstChildWhichIsA("RemoteEvent")

				if RemoteEvent then
					pcall(function()
						RemoteEvent:FireServer()
					end)
				end
			end
		end)
	end)
	task.delay(0.03, function()
		iData.value26.hitCD = false
	end)
end
function RXZ_forceAimbotOff()
	if iData.value166 then
		pcall(function()
			iData.value166:Disconnect()
		end)
		iData.value166 = nil
	end

	if iData.value124 then
		pcall(iData.value124)
	end

	iData.value31 = false
	pcall(function()
		if iData.value54 then
			iData.value54(false)
		end

		if iData.value78 and iData.value78.autoBat then
			iData.value78.autoBat(false)
		end

		if GuiToggleSetters and GuiToggleSetters.circle then
			GuiToggleSetters.circle(false)
		end
	end)
end
function iData.value26.startTPBat()
	RXZ_forceAimbotOff()

	if iData.value26.tpConn then
		pcall(function()
			iData.value26.tpConn:Disconnect()
		end)
		iData.value26.tpConn = nil
	end

	if iData.value26._tpShieldConn then
		pcall(function()
			iData.value26._tpShieldConn:Disconnect()
		end)
		iData.value26._tpShieldConn = nil
	end

	if iData.value26._tpAntiDieConn then
		pcall(function()
			iData.value26._tpAntiDieConn:Disconnect()
		end)
		iData.value26._tpAntiDieConn = nil
	end

	if iData.value26._tpCharConn then
		pcall(function()
			iData.value26._tpCharConn:Disconnect()
		end)
		iData.value26._tpCharConn = nil
	end

	if iData.value26._tpPatchConn then
		pcall(function()
			iData.value26._tpPatchConn:Disconnect()
		end)
		iData.value26._tpPatchConn = nil
	end

	iData.value26.tpBat = true
	iData.value26._tpHitDone = false
	iData.value26._tpTargetHealth = nil
	iData.value26._tpTargetHum = nil

	local function updateTpHitDone()
		if iData.value26._tpHitDone then
			return
		end

		iData.value26._tpHitDone = true
		iData.value26.stopTPBat()
		pcall(function()
			if iData.value26.setTPBatVisual then
				iData.value26.setTPBatVisual(false)
			end

			if iData.value78 and iData.value78.tpBat then
				iData.value78.tpBat(false)
			end
		end)
	end
	local function updateHealthChangedConnection(humanoidContainer)
		if iData.value26._tpAntiDieConn then
			pcall(function()
				iData.value26._tpAntiDieConn:Disconnect()
			end)
		end

		if not humanoidContainer then
			return
		end

		local healthOption = humanoidContainer:FindFirstChildOfClass("Humanoid")
			or humanoidContainer:WaitForChild("Humanoid", 3)

		if not healthOption then
			return
		end

		iData.value26._tpAntiDieConn = healthOption.HealthChanged:Connect(function(argument)
			if not iData.value26.tpBat then
				return
			end

			if argument <= 0 then
				pcall(function()
					healthOption.Health = healthOption.MaxHealth
				end)
			end
		end)
	end

	updateHealthChangedConnection(iData.value11.Character)
	iData.value26._tpCharConn = iData.value11.CharacterAdded:Connect(function(character)
		if not iData.value26.tpBat then
			return
		end

		task.wait(0.1)
		updateHealthChangedConnection(character)
	end)
	iData.value26.tpConn = iData.value4.Heartbeat:Connect(function()
		if not iData.value26.tpBat then
			return
		end

		local Character = iData.value11.Character

		if not Character then
			return
		end

		local HumanoidRootPart = Character:FindFirstChild("HumanoidRootPart")

		if not HumanoidRootPart then
			return
		end

		local Humanoid = Character:FindFirstChildOfClass("Humanoid")

		if Humanoid and Humanoid.Health <= 0 then
			pcall(function()
				Humanoid.Health = Humanoid.MaxHealth
			end)
		end

		local tpLockedRoot = iData.value26._tpLockedRoot

		if not tpLockedRoot or (not tpLockedRoot.Parent or not tpLockedRoot.Parent.Parent) then
			tpLockedRoot = iData.value26.closestRoot()
			iData.value26._tpLockedRoot = tpLockedRoot
		else
			local option = tpLockedRoot.Parent and tpLockedRoot.Parent:FindFirstChildOfClass("Humanoid")

			if not option or option.Health <= 0 then
				tpLockedRoot = iData.value26.closestRoot()
				iData.value26._tpLockedRoot = tpLockedRoot
			end
		end

		if tpLockedRoot then
			if sethiddenproperty then
				pcall(function()
					sethiddenproperty(HumanoidRootPart, "PhysicsRepRootPart", tpLockedRoot)
				end)
			end

			local assemblyLinearVelocity = tpLockedRoot.AssemblyLinearVelocity or Vector3.zero
			local sum = tpLockedRoot.Position + assemblyLinearVelocity * 0.05 + Vector3.new(0, 0.35, 0)
			local sumNumber = Vector3.new(0, 0.2, 0)
			local newResult = Vector3
			local number = sum + sumNumber
			local vector = newResult.new(assemblyLinearVelocity.X, 0, assemblyLinearVelocity.Z)

			if vector.Magnitude < 0.15 then
				vector = Vector3.new(
					tpLockedRoot.Position.X - HumanoidRootPart.Position.X,
					0,
					tpLockedRoot.Position.Z - HumanoidRootPart.Position.Z
				)
			end

			if vector.Magnitude > 0.05 then
				HumanoidRootPart.CFrame = CFrame.lookAt(number, number + vector.Unit)
			else
				HumanoidRootPart.CFrame = CFrame.new(number)
			end

			if (HumanoidRootPart.Position - tpLockedRoot.Position).Magnitude > 3.5 then
				HumanoidRootPart.CFrame =
					CFrame.lookAt(tpLockedRoot.Position + Vector3.new(0, 0.4, 0), tpLockedRoot.Position)
			end

			HumanoidRootPart.AssemblyLinearVelocity = assemblyLinearVelocity
			HumanoidRootPart.AssemblyAngularVelocity = Vector3.zero

			local CurrentCamera = workspace.CurrentCamera

			if CurrentCamera then
				CurrentCamera.CFrame =
					CFrame.lookAt(CurrentCamera.CFrame.Position, tpLockedRoot.Position + Vector3.new(0, 1, 0))
			end

			iData.value26.tpHit()

			if (HumanoidRootPart.Position - tpLockedRoot.Position).Magnitude < 4 then
				iData.value26.tpHit()
			end

			local tpTargetHum = tpLockedRoot.Parent and tpLockedRoot.Parent:FindFirstChildOfClass("Humanoid")

			if tpTargetHum then
				if
					tpTargetHum == iData.value26._tpTargetHum
					and iData.value26._tpTargetHealth
					and (tpTargetHum.PlatformStand or tpTargetHum.Health < iData.value26._tpTargetHealth - 0.5)
				then
					updateTpHitDone()

					return
				end

				iData.value26._tpTargetHum = tpTargetHum
				iData.value26._tpTargetHealth = tpTargetHum.Health
			end
		end
	end)
	iData.value26._tpShieldConn = iData.value4.Heartbeat:Connect(function()
		if not iData.value26.tpBat then
			return
		end

		local Character = iData.value11.Character
		local input = Character and Character:FindFirstChild("HumanoidRootPart")
		local option = Character and Character:FindFirstChildOfClass("Humanoid")

		if not input or (not option or option.Health <= 0) then
			return
		end

		local closestRootResult = iData.value26.closestRoot()

		for _, player in ipairs(iData.value1:GetPlayers()) do
			if player ~= iData.value11 and player.Character then
				local HumanoidRootPart = player.Character:FindFirstChild("HumanoidRootPart")
				local Tool = player.Character:FindFirstChildWhichIsA("Tool")

				if HumanoidRootPart and Tool then
					local lower = Tool.Name:lower()

					if
						(lower:find("bat") or lower:find("slap"))
						and (
							(input.Position - HumanoidRootPart.Position).Magnitude < 8
							and HumanoidRootPart ~= closestRootResult
						)
					then
						local cFrameNumber = math.rad(tick() * 500)

						input.CFrame = input.CFrame
							* CFrame.new(math.sin(cFrameNumber) * 3, 0, math.cos(cFrameNumber) * 3)
					end
				end
			end
		end
	end)
end
function iData.value26.stopTPBat()
	iData.value26.tpBat = false
	iData.value26._tpHitDone = false
	iData.value26._tpTargetHealth = nil
	iData.value26._tpTargetHum = nil
	iData.value26._tpLockedRoot = nil

	if iData.value26.tpConn then
		pcall(function()
			iData.value26.tpConn:Disconnect()
		end)
		iData.value26.tpConn = nil
	end

	if iData.value26._tpShieldConn then
		pcall(function()
			iData.value26._tpShieldConn:Disconnect()
		end)
		iData.value26._tpShieldConn = nil
	end

	if iData.value26._tpAntiDieConn then
		pcall(function()
			iData.value26._tpAntiDieConn:Disconnect()
		end)
		iData.value26._tpAntiDieConn = nil
	end

	if iData.value26._tpCharConn then
		pcall(function()
			iData.value26._tpCharConn:Disconnect()
		end)
		iData.value26._tpCharConn = nil
	end

	if iData.value26._tpPatchConn then
		pcall(function()
			iData.value26._tpPatchConn:Disconnect()
		end)
		iData.value26._tpPatchConn = nil
	end

	pcall(function()
		local CurrentCamera = workspace.CurrentCamera

		if CurrentCamera and CurrentCamera.CameraType == Enum.CameraType.Scriptable then
			CurrentCamera.CameraType = Enum.CameraType.Custom
		end
	end)
end
function iData.value26.v2Swing()
	if tick() - (iData.value35 or 0) < 0.05 then
		return
	end

	iData.value26.v2CD = true
	pcall(function()
		local Character = iData.value11.Character
		local option = Character and Character:FindFirstChildOfClass("Humanoid")
		local secondaryFindBat = iData.value26.findBat()

		if not secondaryFindBat then
			return
		end

		if Character ~= secondaryFindBat.Parent and option then
			pcall(function()
				option:EquipTool(secondaryFindBat)
			end)
		end

		pcall(function()
			secondaryFindBat:Activate()
		end)

		local RemoteEvent = secondaryFindBat:FindFirstChildWhichIsA("RemoteEvent")

		if RemoteEvent then
			pcall(function()
				RemoteEvent:FireServer()
			end)
		end

		task.defer(function()
			if secondaryFindBat and secondaryFindBat.Parent then
				pcall(function()
					secondaryFindBat:Activate()
				end)
			end
		end)
	end)
	task.delay(0.05, function()
		iData.value26.v2CD = false
	end)
end
function iData.value26.stopBatV2()
	iData.value32 = false
	iData.value26.batV2 = false

	if iData.value34 then
		pcall(function()
			iData.value34:Disconnect()
		end)
		iData.value34 = nil
	end

	if iData.value26.v2Conn then
		pcall(function()
			iData.value26.v2Conn:Disconnect()
		end)
		iData.value26.v2Conn = nil
	end

	local Character = iData.value11.Character

	if Character then
		local HumanoidRootPart = Character:FindFirstChild("HumanoidRootPart")
		local Humanoid = Character:FindFirstChildOfClass("Humanoid")

		if HumanoidRootPart then
			HumanoidRootPart.AssemblyLinearVelocity = Vector3.zero
			HumanoidRootPart.AssemblyAngularVelocity = Vector3.zero
		end

		if Humanoid then
			Humanoid.AutoRotate = true
		end
	end

	pcall(function()
		if iData.value78 and iData.value78.batV2 then
			iData.value78.batV2(false)
		end
	end)
end
function iData.value26.startBatV2()
	if iData.value34 then
		pcall(function()
			iData.value34:Disconnect()
		end)
		iData.value34 = nil
	end

	pcall(function()
		if iData.value26.tpBat and iData.value26.stopTPBat then
			iData.value26.stopTPBat()
		end

		if iData.value31 and iData.value124 then
			iData.value124()
		end

		if iData.value27 then
			iData.value27 = false

			if secondaryUpdateInstanceProperties then
				secondaryUpdateInstanceProperties()
			end
		end

		if iData.value28 then
			iData.value28 = false

			if iData.value150 then
				iData.value150()
			end
		end
	end)
	iData.value32 = true
	iData.value26.batV2 = true
	iData.value34 = iData.value4.Heartbeat:Connect(function()
		if not iData.value32 or not iData.value26.batV2 then
			return
		end

		local Character = iData.value11.Character

		if not Character then
			return
		end

		local Humanoid = Character:FindFirstChildOfClass("Humanoid")
		local HumanoidRootPart = Character:FindFirstChild("HumanoidRootPart")

		if not Humanoid or not HumanoidRootPart then
			return
		end

		if not Humanoid.AutoRotate then
			Humanoid.AutoRotate = true
		end

		if not Character:FindFirstChildOfClass("Tool") then
			local condition = iData.value26.findBat()

			if condition then
				pcall(function()
					Humanoid:EquipTool(condition)
				end)
			end
		end

		local input = iData.value26.closestRoot()

		if input then
			local sum = input.Position + Vector3.new(0, 1, 0)

			Humanoid.AutoRotate = false

			local difference = sum - HumanoidRootPart.Position
			local vector = Vector3.new(difference.X, 0, difference.Z)

			if difference.Magnitude > 0.01 and vector.Magnitude > 0.01 then
				local clampedValue = math.clamp(
					((math.deg((math.atan2(-vector.X, -vector.Z))) - HumanoidRootPart.Orientation.Y + 180) % 360 - 180)
						* 8,
					-28,
					28
				)

				HumanoidRootPart.AssemblyAngularVelocity = Vector3.new(0, clampedValue, 0)
			else
				HumanoidRootPart.AssemblyAngularVelocity = Vector3.zero
			end

			local number = sum - difference.Unit * -1 + Vector3.new(0, 1.3, 0) - HumanoidRootPart.Position
			local secondaryVector = Vector3.new(number.X, 0, number.Z)
			local clampedValue = math.clamp(tonumber(iData.value33) or 56.5, 1, 200)

			HumanoidRootPart.AssemblyLinearVelocity = (
				secondaryVector.Magnitude > 0.1 and secondaryVector.Unit * clampedValue or Vector3.zero
			) + Vector3.new(0, math.clamp(number.Y * 3, -clampedValue, clampedValue), 0)

			if secondaryVector.Magnitude > 0.5 then
				Humanoid:Move(secondaryVector.Unit, false)
			end

			iData.value26.v2Swing()

			return
		end

		Humanoid.AutoRotate = true
		HumanoidRootPart.AssemblyAngularVelocity = Vector3.zero
		iData.value26.v2Swing()
	end)
	iData.value26.v2Conn = iData.value34
	pcall(function()
		if iData.value78 and iData.value78.batV2 then
			iData.value78.batV2(true)
		end
	end)
end
function iData.value26.toggleBatV2()
	if iData.value32 or iData.value26.batV2 then
		iData.value26.stopBatV2()
	else
		if iData.value164 and (iData.value164.tryStart and not iData.value164.tryStart()) then
			pcall(function()
				if iData.value78 and iData.value78.batV2 then
					iData.value78.batV2(false)
				end
			end)

			return
		end

		iData.value26.startBatV2()
	end

	iData.value168()
end
iData.value174 = "discord.gg/GGFWZFUJgA"
function destroyDiscordLink()
	if iData.value70 then
		pcall(function()
			iData.value70:Destroy()
		end)
		iData.value70 = nil
	end

	pcall(function()
		local VoidDiscordLink = game:GetService("CoreGui"):FindFirstChild("VoidDiscordLink")

		if VoidDiscordLink then
			VoidDiscordLink:Destroy()
		end

		local PlayerGui = iData.value11:FindFirstChild("PlayerGui")

		if PlayerGui then
			local voidDiscordLink = PlayerGui:FindFirstChild("VoidDiscordLink")

			if voidDiscordLink then
				voidDiscordLink:Destroy()
			end
		end
	end)
end
function buildDiscordLink()
	destroyDiscordLink()

	if not iData.value69 then
		return
	end

	local ScreenGui = Instance.new("ScreenGui")

	ScreenGui.Name = "VoidDiscordLink"
	ScreenGui.ResetOnSpawn = false
	ScreenGui.IgnoreGuiInset = true
	ScreenGui.DisplayOrder = 40
	pcall(function()
		if syn and syn.protect_gui then
			syn.protect_gui(ScreenGui)
		end
	end)

	if not pcall(function()
		ScreenGui.Parent = game:GetService("CoreGui")
	end) then
		ScreenGui.Parent = iData.value11:WaitForChild("PlayerGui")
	end

	local TextButton = Instance.new("TextButton", ScreenGui)

	TextButton.Name = "DiscordBtn"
	TextButton.Size = UDim2.new(0, 420, 0, 48)
	TextButton.Position = UDim2.new(0.5, -210, 0.5, -24)
	TextButton.BackgroundTransparency = 1
	TextButton.BorderSizePixel = 0
	TextButton.Text = iData.value174
	TextButton.TextColor3 = Color3.fromRGB(255, 255, 255)
	TextButton.Font = Enum.Font.GothamBlack
	TextButton.TextSize = 26
	TextButton.TextXAlignment = Enum.TextXAlignment.Center
	TextButton.TextStrokeTransparency = 0.4
	TextButton.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
	TextButton.ZIndex = 50
	TextButton.AutoButtonColor = false
	TextButton.Active = false
	TextButton.Selectable = false
	task.spawn(function()
		local textTransparencyNumber = 0

		while TextButton and TextButton.Parent do
			textTransparencyNumber += 0.04
			TextButton.TextTransparency = 0.05 + math.abs((math.sin(textTransparencyNumber * 1.2))) * 0.2
			task.wait(0.04)
		end
	end)
end
function destroyMobileButtons()
	if iData.value79 then
		pcall(function()
			iData.value79.Enabled = false

			for _, descendant in ipairs(iData.value79:GetDescendants()) do
				if descendant:IsA("GuiObject") then
					descendant.Active = false

					if descendant:IsA("GuiButton") then
						descendant.Visible = false
					end
				end
			end

			iData.value79:Destroy()
		end)
		iData.value79 = nil
	end

	for _, item in ipairs({
		"RXZMobileButtons",
		"SpectrumMobileButtons",
		"MoveeMobileButtons",
	}) do
		local capturedV = item

		pcall(function()
			local firstChild = game:GetService("CoreGui"):FindFirstChild(capturedV)

			if firstChild then
				firstChild:Destroy()
			end

			local PlayerGui = iData.value11:FindFirstChild("PlayerGui")

			if PlayerGui then
				local firstChild = PlayerGui:FindFirstChild(capturedV)

				if firstChild then
					firstChild:Destroy()
				end
			end
		end)
	end

	iData.value78 = {}
	pcall(function()
		local CurrentCamera = workspace.CurrentCamera

		if CurrentCamera and CurrentCamera.CameraType == Enum.CameraType.Scriptable then
			CurrentCamera.CameraType = Enum.CameraType.Custom
		end

		iData.value3.MouseIconEnabled = true
		pcall(function()
			iData.value3.ModalEnabled = false
		end)
	end)
end
function buildMobileButtons()
	destroyMobileButtons()
	if not iData.value67 then
		return
	end
	task.spawn(function()
		pcall(function()
			loadCustomImageAsset("https://files.catbox.moe/mlyr71.png", "voidvs_menu_logo.png")
		end)
	end)
	local ScreenGui = Instance.new("ScreenGui")
	ScreenGui.Name = "RXZMobileButtons"
	ScreenGui.ResetOnSpawn = false
	ScreenGui.DisplayOrder = 5000
	ScreenGui.IgnoreGuiInset = true
	pcall(function()
		if syn and syn.protect_gui then
			syn.protect_gui(ScreenGui)
		end
	end)
	if not pcall(function()
		ScreenGui.Parent = game:GetService("CoreGui")
	end) then
		ScreenGui.Parent = iData.value11:WaitForChild("PlayerGui")
	end
	local clampedValue = math.clamp((tonumber(iData.value73) or 80) / 80, 0.55, 1.6)
	local createTostringNumber = math.floor(84 * clampedValue + 0.5)
	local sumNumber = math.floor(36 * clampedValue + 0.5)
	local productNumber = math.max(4, (math.floor(7 * clampedValue + 0.5)))
	local cornerRadiusNumber = math.max(6, (math.floor(9 * clampedValue + 0.5)))
	local backgroundColor3 = Color3.fromRGB(10, 10, 10)
	local createTostringFlag = Color3.fromRGB(255, 255, 255)
	local uiStrokeColor = Color3.fromRGB(40, 40, 45)
	local color = Color3.fromRGB(80, 80, 85)
	local textButtonColor = Color3.fromRGB(255, 255, 255)
	local textColor3 = Color3.fromRGB(0, 0, 0)
	local sum = createTostringNumber * 3 + productNumber * 2
	local number = sumNumber * 4 + productNumber * 3
	local Frame = Instance.new("Frame", ScreenGui)
	Frame.Name = "MobileButtons"
	Frame.Size = UDim2.new(0, sum + 12, 0, number + 12)
	Frame.Position = UDim2.new(1, -(sum + 20), 0.32, 0)
	Frame.BackgroundTransparency = 1
	Frame.BorderSizePixel = 0
	Frame.Active = false
	Frame.ZIndex = 100
	local group = loadBtnPositions().__group
	if type(group) == "table" and group.xo ~= nil then
		Frame.Position = UDim2.new(group.xs or 0, group.xo, group.ys or 0, group.yo or 0)
	end
	local flag = false
	local vector
	local secondaryVector
	iData.value3.InputChanged:Connect(function(input)
		if iData.value102 then
			flag = false

			return
		end

		if input == nil and (flag and (vector and secondaryVector)) then
			local difference = input.Position.X - vector.X
			local PositionY = input.Position.Y
			local Y = vector.Y
			local secondaryMath = math
			local number = PositionY - Y

			if secondaryMath.abs(difference) > 8 or math.abs(number) > 8 then
				Frame.Position = UDim2.new(
					secondaryVector.X.Scale,
					secondaryVector.X.Offset + difference,
					secondaryVector.Y.Scale,
					secondaryVector.Y.Offset + number
				)
			end
		end
	end)
	local function createTostring(
		textButton,
		alternateCreateTostringNumber,
		additionalCreateTostringNumber,
		createTostringCondition,
		tostringCallback,
		optionFlag
	)
		local createTostringOption = optionFlag and sum or createTostringNumber
		local product = optionFlag and 0
		if not product then
			product = alternateCreateTostringNumber * (createTostringNumber + productNumber)
		end
		local number = 8 + product
		local secondaryCreateTostringNumber = 8 + additionalCreateTostringNumber * (sumNumber + productNumber)
		local parent = Instance.new("Frame", Frame)
		parent.Name = tostring(textButton):gsub("%s+", "")
		parent.Size = UDim2.new(0, createTostringOption, 0, sumNumber)
		parent.Position = UDim2.new(0, number, 0, secondaryCreateTostringNumber)
		parent.BackgroundColor3 = backgroundColor3
		parent.BorderSizePixel = 0
		parent.Active = true
		parent.ZIndex = 200
		Instance.new("UICorner", parent).CornerRadius = UDim.new(0, cornerRadiusNumber)
		local UIStroke = Instance.new("UIStroke", parent)
		UIStroke.Color = uiStrokeColor
		UIStroke.Thickness = 1.5
		local ImageLabel = Instance.new("ImageLabel", parent)
		ImageLabel.Name = "BtnImage"
		ImageLabel.Size = UDim2.new(1, 0, 1, 0)
		ImageLabel.BackgroundTransparency = 1
		ImageLabel.ImageTransparency = 0.72
		ImageLabel.ScaleType = Enum.ScaleType.Crop
		ImageLabel.ZIndex = 200
		ImageLabel.Image = ""
		Instance.new("UICorner", ImageLabel).CornerRadius = UDim.new(0, cornerRadiusNumber)
		task.spawn(function()
			local mlyr71Png = loadCustomImageAsset("https://files.catbox.moe/mlyr71.png", "voidvs_menu_logo.png")

			if ImageLabel and (ImageLabel.Parent and (mlyr71Png and mlyr71Png ~= "")) then
				ImageLabel.Image = mlyr71Png
			end
		end)
		local TextButton = Instance.new("TextButton", parent)
		TextButton.Size = UDim2.new(1, 0, 1, 0)
		TextButton.BackgroundTransparency = 1
		TextButton.Text = textButton
		TextButton.TextColor3 = textButtonColor
		TextButton.Font = Enum.Font.GothamBold
		TextButton.TextSize = math.max(8, (math.floor((not optionFlag and 10 or 11) * clampedValue + 0.5)))
		TextButton.TextWrapped = true
		TextButton.LineHeight = 1.1
		TextButton.BorderSizePixel = 0
		TextButton.AutoButtonColor = false
		TextButton.ZIndex = 201
		local textButtonColorFlag = false
		local flag = false
		local inputPosition
		local Frame22Position
		local capturedInput
		local secondaryCreateTostringFlag = false
		local UIScale = Instance.new("UIScale")
		UIScale.Scale = 1
		UIScale.Parent = parent
		local function handleTostring(createTostringFlag)
			iData.value2
				:Create(UIScale, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
					Scale = createTostringFlag or 0.92,
				})
				:Play()
			task.delay(0.1, function()
				iData.value2
					:Create(UIScale, TweenInfo.new(0.18, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
						Scale = 1,
					})
					:Play()
			end)
		end
		TextButton.MouseButton1Click:Connect(function()
			if secondaryCreateTostringFlag then
				return
			end

			if createTostringCondition then
				textButtonColorFlag = not textButtonColorFlag
				iData.value2
					:Create(parent, TweenInfo.new(0.22, Enum.EasingStyle.Quad), {
						BackgroundColor3 = textButtonColorFlag and createTostringFlag or backgroundColor3,
					})
					:Play()
				iData.value2
					:Create(UIStroke, TweenInfo.new(0.22), {
						Color = textButtonColorFlag and color or uiStrokeColor,
					})
					:Play()
				TextButton.TextColor3 = textButtonColorFlag and textColor3 or textButtonColor
				handleTostring(0.88)

				if tostringCallback then
					tostringCallback(textButtonColorFlag)

					return
				end
			else
				handleTostring(0.88)
				iData.value2
					:Create(parent, TweenInfo.new(0.1), {
						BackgroundColor3 = createTostringFlag,
					})
					:Play()
				iData.value2
					:Create(UIStroke, TweenInfo.new(0.1), {
						Color = color,
					})
					:Play()
				TextButton.TextColor3 = textColor3
				task.delay(0.22, function()
					iData.value2
						:Create(parent, TweenInfo.new(0.2), {
							BackgroundColor3 = backgroundColor3,
						})
						:Play()
					iData.value2
						:Create(UIStroke, TweenInfo.new(0.2), {
							Color = uiStrokeColor,
						})
						:Play()
					TextButton.TextColor3 = textButtonColor
				end)

				if tostringCallback then
					tostringCallback()
				end
			end
		end)
		parent.Name = textButton:gsub("%s+", "_"):gsub("\n", "_")
		local name = loadBtnPositions()[parent.Name]
		if type(name) == "table" and name.xo ~= nil then
			parent.Position = UDim2.new(0, name.xo, 0, name.yo)
		end
		TextButton.InputBegan:Connect(function(input)
			if iData.value102 then
				return
			end

			if
				input.UserInputType == Enum.UserInputType.MouseButton1
				or input.UserInputType == Enum.UserInputType.Touch
			then
				flag = true
				secondaryCreateTostringFlag = false
				inputPosition = input.Position
				Frame22Position = parent.Position
				input.Changed:Connect(function()
					if input.UserInputState == Enum.UserInputState.End then
						if secondaryCreateTostringFlag then
							pcall(saveBtnPositions)
						end

						flag = false
					end
				end)
			end
		end)
		TextButton.InputChanged:Connect(function(input)
			if
				input.UserInputType == Enum.UserInputType.MouseMovement
				or input.UserInputType == Enum.UserInputType.Touch
			then
				capturedInput = input
			end
		end)
		iData.value3.InputChanged:Connect(function(input)
			if input == capturedInput and (flag and (inputPosition and Frame22Position)) then
				if iData.value102 then
					return
				end

				local createTostringNumber = input.Position.X - inputPosition.X
				local difference = input.Position.Y - inputPosition.Y

				if math.abs(createTostringNumber) > 6 or math.abs(difference) > 6 then
					secondaryCreateTostringFlag = true
					parent.Position = UDim2.new(
						0,
						Frame22Position.X.Offset + createTostringNumber,
						0,
						Frame22Position.Y.Offset + difference
					)
				end
			end
		end)
		TextButton.InputEnded:Connect(function(input)
			if
				input.UserInputType == Enum.UserInputType.MouseButton1
				or input.UserInputType == Enum.UserInputType.Touch
			then
				if secondaryCreateTostringFlag then
					pcall(saveBtnPositions)
				end

				task.defer(function() end)
			end
		end)

		return parent,
			function(flag)
				textButtonColorFlag = flag
				iData.value2
					:Create(parent, TweenInfo.new(0.22, Enum.EasingStyle.Quad), {
						BackgroundColor3 = flag and createTostringFlag or backgroundColor3,
					})
					:Play()
				iData.value2
					:Create(UIStroke, TweenInfo.new(0.22), {
						Color = flag and color or uiStrokeColor,
					})
					:Play()
				TextButton.TextColor3 = flag and textColor3 or textButtonColor
				handleTostring(0.9)
			end
	end
	local function handler()
		if iData.value78.laggerCarry then
			local laggerCarry = iData.value78.laggerCarry
			local value17Condition = iData.value17

			if value17Condition then
				value17Condition = iData.value16
			end

			laggerCarry(value17Condition)
		end

		if iData.value78.laggerNormal then
			iData.value78.laggerNormal(iData.value17 and not iData.value16)
		end

		if iData.value78.carrySpeed then
			iData.value78.carrySpeed(iData.value16 and not iData.value17)
		end
	end
	local _, tpBat = createTostring("ANTI DESYNC", 0, 0, true, function(condition)
		if condition then
			if iData.value164 and (iData.value164.tryStart and not iData.value164.tryStart()) then
				if iData.value78.tpBat then
					iData.value78.tpBat(false)
				end

				if iData.value26.setTPBatVisual then
					iData.value26.setTPBatVisual(false)
				end

				return
			end

			if RXZ_forceAimbotOff then
				RXZ_forceAimbotOff()
			end

			iData.value26.startTPBat()

			if iData.value26.setTPBatVisual then
				iData.value26.setTPBatVisual(true)
			end

			if iData.value78.autoBat then
				iData.value78.autoBat(false)
			end

			if iData.value54 then
				iData.value54(false)

				return
			end
		else
			iData.value26.stopTPBat()

			if iData.value26.setTPBatVisual then
				iData.value26.setTPBatVisual(false)
			end
		end
	end, false)
	iData.value78.tpBat = tpBat
	local _, callback = createTostring("BAT V2", 0, 1, true, function(condition)
		if condition then
			if iData.value164 and (iData.value164.tryStart and not iData.value164.tryStart()) then
				if iData.value78.batV2 then
					iData.value78.batV2(false)
				end

				return
			end

			iData.value26.startBatV2()
		else
			iData.value26.stopBatV2()
		end

		iData.value168()
	end, false)
	local capturedCallback = callback
	iData.value78.batV2 = capturedCallback
	if iData.value32 or iData.value26.batV2 then
		pcall(function()
			capturedCallback(true)
		end)
	end
	local _, drop = createTostring("DROP BR", 1, 0, false, function()
		iData.value153()
	end, false)
	iData.value78.drop = drop
	local _, autoLeft = createTostring("AUTO LEFT", 2, 0, true, function(condition)
		if condition then
			if iData.value164 and (iData.value164.tryStart and not iData.value164.tryStart()) then
				if iData.value78.autoLeft then
					iData.value78.autoLeft(false)
				end

				if iData.value29 then
					iData.value29(false)
				end

				return
			end

			if iData.value28 then
				iData.value28 = false
				iData.value150()

				if iData.value30 then
					iData.value30(false)
				end

				if iData.value78.autoRight then
					iData.value78.autoRight(false)
				end
			end

			if iData.value31 then
				iData.value124()

				if iData.value54 then
					iData.value54(false)
				end

				if iData.value78.autoBat then
					iData.value78.autoBat(false)
				end
			end

			iData.value27 = true
			iData.value151()

			if iData.value29 then
				iData.value29(true)

				return
			end
		else
			iData.value27 = false
			secondaryUpdateInstanceProperties()

			if iData.value29 then
				iData.value29(false)
			end
		end
	end, false)
	iData.value78.autoLeft = autoLeft
	local _, autoBat = createTostring("AIM BOT", 1, 1, true, function(condition)
		if condition then
			if iData.value27 then
				iData.value27 = false
				secondaryUpdateInstanceProperties()

				if iData.value29 then
					iData.value29(false)
				end

				if iData.value78.autoLeft then
					iData.value78.autoLeft(false)
				end
			end

			if iData.value28 then
				iData.value28 = false
				iData.value150()

				if iData.value30 then
					iData.value30(false)
				end

				if iData.value78.autoRight then
					iData.value78.autoRight(false)
				end
			end

			iData.value125()

			if iData.value54 then
				iData.value54(iData.value31)
			end

			if not iData.value31 and iData.value78.autoBat then
				iData.value78.autoBat(false)

				return
			end
		else
			iData.value124()

			if iData.value54 then
				iData.value54(false)
			end
		end
	end, false)
	iData.value78.autoBat = autoBat
	local _, autoRight = createTostring("AUTO RIGHT", 2, 1, true, function(condition)
		if condition then
			if iData.value164 and (iData.value164.tryStart and not iData.value164.tryStart()) then
				if iData.value78.autoRight then
					iData.value78.autoRight(false)
				end

				if iData.value30 then
					iData.value30(false)
				end

				return
			end

			if iData.value27 then
				iData.value27 = false
				secondaryUpdateInstanceProperties()

				if iData.value29 then
					iData.value29(false)
				end

				if iData.value78.autoLeft then
					iData.value78.autoLeft(false)
				end
			end

			if iData.value31 then
				iData.value124()

				if iData.value54 then
					iData.value54(false)
				end

				if iData.value78.autoBat then
					iData.value78.autoBat(false)
				end
			end

			iData.value28 = true
			iData.value152()

			if iData.value30 then
				iData.value30(true)

				return
			end
		else
			iData.value28 = false
			iData.value150()

			if iData.value30 then
				iData.value30(false)
			end
		end
	end, false)
	iData.value78.autoRight = autoRight
	local _, tpDown = createTostring("TP DOWN", 1, 2, false, function()
		iData.value155()
	end, false)
	iData.value78.tpDown = tpDown
	local _, carrySpeed = createTostring("CARRY SPEED", 2, 2, true, function(argument)
		if iData.value17 then
			iData.value17 = false
		end

		iData.value16 = argument
		iData.value119()
		handler()
		iData.value168()
	end, false)
	iData.value78.carrySpeed = carrySpeed
	local _, laggerCarry = createTostring("LAGGER CARRY", 1, 3, true, function(condition)
		if condition then
			iData.value17 = true
			iData.value16 = true
		elseif iData.value17 and iData.value16 then
			iData.value17 = false
			iData.value16 = false
		end

		iData.value119()
		handler()
		iData.value168()
	end, false)
	iData.value78.laggerCarry = laggerCarry
	local _, laggerNormal = createTostring("LAGGER NORMAL", 2, 3, true, function(condition)
		if condition then
			iData.value17 = true
			iData.value16 = false
		elseif iData.value17 and not iData.value16 then
			iData.value17 = false
		end

		iData.value119()
		handler()
		iData.value168()
	end, false)
	iData.value78.laggerNormal = laggerNormal
	function iData.value78.lagger(condition)
		if condition then
			if iData.value16 then
				if iData.value78.laggerCarry then
					iData.value78.laggerCarry(true)

					return
				end
			elseif iData.value78.laggerNormal then
				iData.value78.laggerNormal(true)

				return
			end
		else
			if iData.value78.laggerCarry then
				iData.value78.laggerCarry(false)
			end

			if iData.value78.laggerNormal then
				iData.value78.laggerNormal(false)
			end
		end
	end
	if iData.value78.autoLeft then
		iData.value78.autoLeft(iData.value27)
	end
	if iData.value78.autoRight then
		iData.value78.autoRight(iData.value28)
	end
	if iData.value78.autoBat then
		iData.value78.autoBat(iData.value31)
	end
	handler()
	if iData.value78.tpBat then
		iData.value78.tpBat(iData.value26.tpBat)
	end
end
pcall(function()
	if not isfile or not isfile("RXZ_HUB.json") then
		return
	end

	local ok, result = pcall(function()
		local secondaryResult = iData.value6
		local data = { readfile("RXZ_HUB.json") }

		return secondaryResult:JSONDecode(unpackValues(data))
	end)

	if ok then
		ok = type(result) == "table"
	end

	if not ok then
		return
	end

	if type(result.normalSpeed) == "number" and result.normalSpeed > 0 then
		iData.value12 = result.normalSpeed
	end

	if type(result.carrySpeed) == "number" and result.carrySpeed > 0 then
		iData.value13 = result.carrySpeed
	end

	if type(result.laggerSpeed) == "number" and result.laggerSpeed > 0 then
		iData.value14 = result.laggerSpeed
	end

	if type(result.laggerCarrySpeed) == "number" and result.laggerCarrySpeed > 0 then
		iData.value15 = result.laggerCarrySpeed
	end

	if type(result.carrySpeedActive) == "boolean" then
		iData.value16 = result.carrySpeedActive
	end

	if type(result.laggerModeEnabled) == "boolean" then
		iData.value17 = result.laggerModeEnabled
	end

	if type(result.antiRagdoll) == "boolean" then
		iData.value18 = result.antiRagdoll
	end

	if type(result.infiniteJump) == "boolean" then
		iData.value19 = result.infiniteJump
	end

	if type(result.infJumpMode) == "string" then
		local _ = result.infJumpMode
	end

	if type(result.medusaCounter) == "boolean" then
		iData.value20 = result.medusaCounter
	end

	iData.value26.antiKick = true

	if type(result.batCounter) == "boolean" then
		iData.value21 = result.batCounter
	end

	if type(result.autoStealEnabled) == "boolean" then
		iData.value136.AutoStealEnabled = result.autoStealEnabled
	end

	if type(result.batV2Speed) == "number" then
		iData.value33 = result.batV2Speed
	end

	if type(result.batV2Enabled) == "boolean" then
		iData.value32 = result.batV2Enabled
	end

	if type(result.mirrorTPDownEnabled) == "boolean" then
		iData.value36 = result.mirrorTPDownEnabled
	end

	if type(result.voidThemeName) == "string" then
		iData.value43 = result.voidThemeName
	end

	if type(result.stealBarStyle) == "number" then
		iData.value76 = result.stealBarStyle
	end

	if type(result.stealBarScale) == "number" then
		iData.value77 = result.stealBarScale
	end

	if type(result.stealMode) == "number" then
		iData.value136.Mode = math.clamp(math.floor(result.stealMode), 1, 4)
	end

	if type(result.grabRadius) == "number" then
		iData.value136.StealRadius = result.grabRadius
	end

	iData.value136.StealDuration = 1.3

	if type(result.autoSwing) == "boolean" then
		iData.value49 = result.autoSwing
	end

	if type(result.aimbotAfterHit) == "boolean" then
		iData.value47 = result.aimbotAfterHit
	end

	if type(result.unwalkEnabled) == "boolean" then
		iData.value22 = result.unwalkEnabled
	end

	if type(result.antiLag) == "boolean" then
		iData.value57 = result.antiLag
	end

	if type(result.stretchRez) == "boolean" then
		iData.value60 = result.stretchRez
	end

	if type(result.autoTPEnabled) == "boolean" then
		iData.value63 = result.autoTPEnabled
	end

	if type(result.autoTPHeight) == "number" then
		iData.value64 = result.autoTPHeight
	end

	if type(result.fovValue) == "number" then
		iData.value80 = result.fovValue
	end

	if type(result.fovIndex) == "number" then
		iData.value82 = result.fovIndex
	end

	if type(result.skyTheme) == "string" then
		iData.value8 = result.skyTheme
	end

	if type(result.autoMoveSwing) == "boolean" then
		local _ = result.autoMoveSwing
	end

	if type(result.autoMoveSwingInterval) == "number" then
		local _ = result.autoMoveSwingInterval
	end

	if type(result.ragdollGui) == "boolean" then
		iData.value101 = result.ragdollGui
	end

	if type(result.mobileButtonsEnabled) == "boolean" then
		iData.value67 = result.mobileButtonsEnabled
	end

	if type(result.discordLinkEnabled) == "boolean" then
		iData.value69 = result.discordLinkEnabled
	end

	if type(result.logoCircleEnabled) == "boolean" then
		iData.value71 = result.logoCircleEnabled
	end

	if type(result.uiLocked) == "boolean" then
		iData.value102 = result.uiLocked
	end

	if type(result.mobileButtonsSize) == "number" then
		iData.value73 = result.mobileButtonsSize
	end

	if type(result.circleButtonsEnabled) == "boolean" then
		local _ = result.circleButtonsEnabled
	end

	if type(result.headlessEnabled) == "boolean" then
		iData.value88 = result.headlessEnabled
	end

	if type(result.korbloxEnabled) == "boolean" then
		iData.value89 = result.korbloxEnabled
	end

	if type(result.espEnabled) == "boolean" then
		iData.value108 = result.espEnabled
	end

	if type(result.espAvatarsEnabled) == "boolean" then
		iData.value109 = result.espAvatarsEnabled
	end

	if type(result.backgroundEnabled) == "boolean" then
		local _ = result.backgroundEnabled
	end

	if type(result.backgroundIndex) == "number" then
		iData.value112 = result.backgroundIndex
	end

	if type(result.autoSwitchSpeed) == "boolean" then
		iData.value85 = result.autoSwitchSpeed
	end

	if type(result.animPackEnabled) == "boolean" then
		iData.value86 = result.animPackEnabled
	end

	if type(result.animPackName) == "string" then
		iData.value87 = result.animPackName
	end
end)
pcall(function()
	if iData.value57 then
		task.spawn(function()
			task.wait(1)

			if updateDescendantAddedConnection then
				updateDescendantAddedConnection()
			end
		end)
	end

	if iData.value86 and (iData.value87 and iData.value87 ~= "OFF") then
		task.spawn(function()
			task.wait(1.2)
			pcall(function()
				applyAnimPack(iData.value87)
			end)
		end)
	end

	if iData.value60 then
		task.spawn(function()
			task.wait(0.5)

			if alternateUpdateInstanceProperties then
				alternateUpdateInstanceProperties()
			end
		end)
	end

	if iData.value18 then
		task.spawn(function()
			task.wait(0.5)

			if additionalUpdateInstanceProperties then
				if iData.value140.antiRag then
					return
				end

				iData.value140.antiRag = iData.value4.Heartbeat:Connect(function()
					if not iData.value18 then
						return
					end

					local Character = iData.value11.Character

					if not Character then
						return
					end

					local Humanoid = Character:FindFirstChildOfClass("Humanoid")
					local HumanoidRootPart = Character:FindFirstChild("HumanoidRootPart")

					if not Humanoid or not HumanoidRootPart then
						return
					end

					local State = Humanoid:GetState()
					local flag = State == Enum.HumanoidStateType.Physics
						or (State == Enum.HumanoidStateType.Ragdoll or State == Enum.HumanoidStateType.FallingDown)
					local RagdollEndTime = iData.value11:GetAttribute("RagdollEndTime")

					if RagdollEndTime and RagdollEndTime - workspace:GetServerTimeNow() > 0 then
						flag = true
					end

					if flag then
						pcall(function()
							local result = iData.value11
							local data = { workspace:GetServerTimeNow() }

							result:SetAttribute("RagdollEndTime", unpackValues(data))
						end)
						for _, descendant in ipairs(Character:GetDescendants()) do
							if
								descendant:IsA("BallSocketConstraint")
								or descendant:IsA("Attachment") and descendant.Name:find("RagdollAttachment")
							then
								descendant:Destroy()
							end
						end
						for index, item in ipairs(Character:GetDescendants()) do
							if item:IsA("Motor6D") and item.Enabled == false then
								item.Enabled = true
							end
						end
						if Humanoid.Health > 0 then
							Humanoid:ChangeState(Enum.HumanoidStateType.Running)
						end
						workspace.CurrentCamera.CameraSubject = Humanoid
						HumanoidRootPart.Anchored = false
						HumanoidRootPart.AssemblyLinearVelocity = Vector3.zero
						HumanoidRootPart.AssemblyAngularVelocity = Vector3.zero
					end
				end)
			end
		end)
	end

	if iData.value19 then
		task.spawn(function()
			task.wait(0.5)

			if setInfJumpInternal then
				setInfJumpInternal(true)
			end
		end)
	end

	if iData.value136.AutoStealEnabled then
		task.spawn(function()
			task.wait(1)

			if updateAutoSteal then
				if iData.value140.autoSteal then
					return
				end

				iData.value140.autoSteal = iData.value4.Heartbeat:Connect(function()
					if iData.value138 or not iData.value136.AutoStealEnabled then
						return
					end

					local ok, result = pcall(findNearestPrompt)

					if ok and result then
						pcall(executeSteal, result)
					end
				end)
			end
		end)
	end

	if iData.value21 then
		task.spawn(function()
			task.wait(1)

			if iData.value56 then
				iData.value56()
			end
		end)
	end

	if iData.value26.antiKick then
		task.spawn(function()
			task.wait(1)
			iData.value26.antiKick = false
			iData.value26.enableAntiKick()

			if iData.value26.setAntiKickVisual then
				iData.value26.setAntiKickVisual(true)
			end
		end)
	end

	if iData.value20 then
		task.spawn(function()
			task.wait(1)

			local Character = iData.value11.Character

			if Character and iData.value121 then
				iData.value121(Character)
			end
		end)
	end

	if iData.value63 then
		task.spawn(function()
			task.wait(0.5)

			if condition then
				if iData.value65 then
					task.cancel(iData.value65)
				end

				task.spawn(function()
					while iData.value63 do
						task.wait(0.1)
						pcall(function()
							doAutoTPDown(false)
						end)
					end
				end)
			end
		end)
	end

	if iData.value8 and iData.value8 ~= "" then
		task.spawn(function()
			task.wait(1)

			if CandyApplyCustomSky then
				CandyApplyCustomSky(iData.value8)
			end
		end)
	end

	if iData.value108 then
		task.spawn(function()
			task.wait(1)
			startESP()
		end)
	end
end);
(function()
	local PlayerGui = iData.value11:WaitForChild("PlayerGui")
	function makeDraggable_cyber(guiObject, inputFlag)
		local secondaryInput = inputFlag or guiObject
		local flag = false
		local capturedInput
		local inputPosition
		local Position
		guiObject.InputBegan:Connect(function(input)
			if
				input.UserInputType == Enum.UserInputType.MouseButton1
				or input.UserInputType == Enum.UserInputType.Touch
			then
				flag = true
				inputPosition = input.Position
				Position = secondaryInput.Position
				input.Changed:Connect(function()
					if input.UserInputState == Enum.UserInputState.End then
						flag = false
					end
				end)
			end
		end)
		guiObject.InputChanged:Connect(function(input)
			if
				input.UserInputType == Enum.UserInputType.MouseMovement
				or input.UserInputType == Enum.UserInputType.Touch
			then
				capturedInput = input
			end
		end)
		iData.value3.InputChanged:Connect(function(input)
			if input == capturedInput and flag then
				if iData.value102 then
					return
				end

				local difference = input.Position - inputPosition

				secondaryInput.Position = UDim2.new(
					Position.X.Scale,
					Position.X.Offset + difference.X,
					Position.Y.Scale,
					Position.Y.Offset + difference.Y
				)
			end
		end)
	end
	local bg = Color3.fromRGB(6, 6, 6)
	local bgDark = Color3.fromRGB(3, 3, 3)
	local row = Color3.fromRGB(16, 16, 16)
	local secondaryInput = Color3.fromRGB(16, 16, 16)
	local blue = Color3.fromRGB(210, 210, 210)
	local blueDim = Color3.fromRGB(70, 70, 70)
	local blueDark = Color3.fromRGB(22, 22, 22)
	local text = Color3.fromRGB(255, 255, 255)
	local textDim = Color3.fromRGB(160, 160, 160)
	local textMuted = Color3.fromRGB(100, 100, 100)
	local white = Color3.fromRGB(255, 255, 255)
	local divider = Color3.fromRGB(32, 32, 32)
	local green = Color3.fromRGB(80, 220, 120)
	local textData = {
		bg = bg,
		bgDark = bgDark,
		row = row,
		input = secondaryInput,
		blue = blue,
		blueDim = blueDim,
		blueDark = blueDark,
		text = text,
		textDim = textDim,
		textMuted = textMuted,
		white = white,
		divider = divider,
		green = green,
	}
	function guiCorner(parent, cornerRadiusFlag)
		local UICorner = Instance.new("UICorner")

		UICorner.CornerRadius = UDim.new(0, cornerRadiusFlag or 10)
		UICorner.Parent = parent

		return UICorner
	end
	function guiStroke(parent, uiStrokeColor, thicknessFlag)
		local UIStroke = Instance.new("UIStroke")

		if not uiStrokeColor then
			uiStrokeColor = Color3.fromRGB(60, 60, 70)
		end

		UIStroke.Color = uiStrokeColor
		UIStroke.Thickness = thicknessFlag or 1
		UIStroke.Parent = parent

		return UIStroke
	end
	function tw(argument, secondaryArgument, secondaryTweenInfo)
		local result = iData.value2

		if not secondaryTweenInfo then
			secondaryTweenInfo = TweenInfo.new(0.12)
		end

		result:Create(argument, secondaryTweenInfo, secondaryArgument):Play()
	end
	local data = {}
	local hubData = {}
	local Frame
	local E = Enum.KeyCode.E
	local Q = Enum.KeyCode.Q
	local c = Enum.KeyCode.C
	local K = Enum.KeyCode.K
	local B = Enum.KeyCode.B
	local RightControl = Enum.KeyCode.RightControl
	local H = Enum.KeyCode.H
	local T = Enum.KeyCode.T
	local J = Enum.KeyCode.J
	local L = Enum.KeyCode.L
	local KeyCodeY = Enum.KeyCode.Y
	local v = Enum.KeyCode.V
	local kData = {
		circle = E,
		speed = Q,
		carryMode = c,
		laggerToggle = K,
		laggerCarry = B,
		guiHide = RightControl,
		dropBrainrot = H,
		tpDown = T,
		autoLeft = J,
		autoRight = L,
		tpBat = KeyCodeY,
		batV2 = v,
	}
	local tpBatData = kData
	pcall(function()
		if not isfile or not isfile("RXZ_HUB.json") then
			return
		end

		local ok, result = pcall(function()
			local secondaryResult = iData.value6
			local data = { readfile("RXZ_HUB.json") }

			return secondaryResult:JSONDecode(unpackValues(data))
		end)

		if ok then
			ok = type(result) == "table" and type(result.keys) == "table"
		end

		if ok then
			for k, item in pairs(result.keys) do
				local capturedV = item
				local success, kResult = pcall(function()
					return Enum.KeyCode[capturedV]
				end)

				if success then
					success = kResult and kResult ~= Enum.KeyCode.Unknown
				end

				if success then
					tpBatData[k] = kResult
				end
			end
		end
	end);
	(function()
		local ScreenGui = Instance.new("ScreenGui")
		ScreenGui.Name = "VoidVS"
		ScreenGui.ResetOnSpawn = false
		ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
		ScreenGui.Parent = PlayerGui
		hubData.hub = ScreenGui
		local parent = Instance.new("Frame")
		parent.Name = "Outer"
		parent.Size = UDim2.new(0, 300, 0, 460)
		parent.Position = UDim2.new(0, 6, 0, 48)
		parent.BackgroundTransparency = 1
		parent.BorderSizePixel = 0
		parent.ClipsDescendants = false
		parent.Parent = ScreenGui
		hubData.outer = parent
		local UIScale = Instance.new("UIScale")
		UIScale.Scale = 0.7
		UIScale.Parent = parent
		hubData.outerScale = UIScale
		local frame = Instance.new("Frame")
		frame.Name = "Inner"
		frame.ClipsDescendants = false
		frame.Size = UDim2.new(1, 0, 1, 0)
		frame.BackgroundColor3 = textData.bg
		frame.BackgroundTransparency = 0
		frame.BorderSizePixel = 0
		frame.Parent = parent
		guiCorner(frame, 24)
		guiStroke(frame, Color3.fromRGB(45, 45, 45), 1.5)
		hubData.inner = frame
		local secondaryParent = Instance.new("Frame")
		secondaryParent.Name = "BackgroundContainer"
		secondaryParent.Size = UDim2.new(1, 0, 1, 0)
		secondaryParent.BackgroundTransparency = 1
		secondaryParent.ZIndex = 0
		secondaryParent.Parent = frame
		local bgGrad = Instance.new("Frame")
		bgGrad.Name = "BgGrad"
		bgGrad.Size = UDim2.new(1, 0, 1, 0)
		bgGrad.BackgroundColor3 = textData.bgDark
		bgGrad.BorderSizePixel = 0
		bgGrad.ZIndex = 0
		bgGrad.Parent = secondaryParent
		guiCorner(bgGrad, 24)
		local UIGradient = Instance.new("UIGradient")
		UIGradient.Color = ColorSequence.new({
			ColorSequenceKeypoint.new(0, Color3.fromRGB(4, 4, 4)),
			ColorSequenceKeypoint.new(0.5, Color3.fromRGB(7, 7, 7)),
			ColorSequenceKeypoint.new(1, Color3.fromRGB(4, 4, 4)),
		})
		UIGradient.Rotation = 135
		UIGradient.Parent = bgGrad
		hubData.bgGrad = bgGrad
		local ImageLabel = Instance.new("ImageLabel")
		ImageLabel.Name = "BackgroundImage"
		ImageLabel.Size = UDim2.new(1, 0, 1, 0)
		ImageLabel.BackgroundTransparency = 1
		ImageLabel.Image = ""
		ImageLabel.ScaleType = Enum.ScaleType.Crop
		ImageLabel.ZIndex = 0
		ImageLabel.ImageTransparency = 0.35
		ImageLabel.Visible = false
		ImageLabel.Parent = secondaryParent
		guiCorner(ImageLabel, 24)
		hubData.backgroundImage = ImageLabel
		iData.value113 = ImageLabel
		local alternateParent = Instance.new("Frame")
		alternateParent.Name = "HeaderFrame"
		alternateParent.Size = UDim2.new(1, 0, 0, 140)
		alternateParent.ClipsDescendants = false
		alternateParent.BackgroundTransparency = 1
		alternateParent.BorderSizePixel = 0
		alternateParent.Parent = frame
		alternateParent.ZIndex = 2
		makeDraggable_cyber(alternateParent, parent)
		local ImageButton = Instance.new("ImageButton")
		ImageButton.Name = "LogoCircle"
		ImageButton.Size = UDim2.new(0, 40, 0, 40)
		ImageButton.Position = UDim2.new(0, 10, 0, 40)
		ImageButton.BackgroundColor3 = Color3.fromRGB(20, 20, 24)
		ImageButton.BackgroundTransparency = 0
		ImageButton.BorderSizePixel = 0
		ImageButton.AutoButtonColor = false
		ImageButton.ScaleType = Enum.ScaleType.Crop
		ImageButton.Image = ""
		ImageButton.ZIndex = 3
		ImageButton.Visible = false
		ImageButton.Parent = alternateParent
		Instance.new("UICorner", ImageButton).CornerRadius = UDim.new(1, 0)
		local UIStroke = Instance.new("UIStroke", ImageButton)
		UIStroke.Color = Color3.fromRGB(80, 80, 90)
		UIStroke.Thickness = 1.5
		iData.value72 = ImageButton
		hubData.logoCircle = ImageButton
		iData.value71 = false
		ImageButton.Visible = false
		task.spawn(function()
			local mlyr71Png = loadCustomImageAsset("https://files.catbox.moe/mlyr71.png", "voidvs_menu_logo.png")

			if ImageButton and ImageButton.Parent then
				ImageButton.Image = mlyr71Png
			end
		end)
		ImageButton.MouseButton1Click:Connect(function()
			pcall(function()
				local _ = ImageButton.Size

				iData.value2
					:Create(ImageButton, TweenInfo.new(0.08), {
						Size = UDim2.new(0, 34, 0, 34),
					})
					:Play()
				task.delay(0.08, function()
					iData.value2
						:Create(ImageButton, TweenInfo.new(0.12, Enum.EasingStyle.Back), {
							Size = UDim2.new(0, 40, 0, 40),
						})
						:Play()
				end)
			end)
		end)
		local voidTitle = Instance.new("ImageLabel")
		voidTitle.Name = "VoidTitle"
		voidTitle.AnchorPoint = Vector2.new(0.5, 0.5)
		voidTitle.Position = UDim2.new(0.5, 0, 0.5, 0)
		voidTitle.Size = UDim2.new(0, 300, 0, 150)
		voidTitle.BackgroundTransparency = 1
		voidTitle.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
		voidTitle.BorderSizePixel = 0
		voidTitle.ScaleType = Enum.ScaleType.Fit
		voidTitle.Image = ""
		voidTitle.ImageTransparency = 0
		voidTitle.ImageColor3 = iData.value44 and iData.value44() or Color3.fromRGB(255, 255, 255)
		voidTitle.ZIndex = 6
		voidTitle.Parent = alternateParent
		hubData.voidTitle = voidTitle
		task.spawn(function()
			pcall(function()
				if isfile and isfile("voidvs_title.png") then
					delfile("voidvs_title.png")
				end

				if isfile and isfile("voidvs_title_nobg.png") then
					delfile("voidvs_title_nobg.png")
				end

				if isfile and isfile("voidvs_title_p3s0qg.png") then
					delfile("voidvs_title_p3s0qg.png")
				end
			end)

			local image = loadCustomImageAsset("https://files.catbox.moe/p3s0qg.png", "voidvs_title_p3s0qg.png")

			if not image or image == "" then
				image = loadCustomImageAsset("https://files.catbox.moe/p3s0qg.png", "voidvs_title.png")
			end

			if voidTitle and voidTitle.Parent then
				voidTitle.BackgroundTransparency = 1

				if image and image ~= "" then
					voidTitle.Image = image

					return
				end

				voidTitle.Image = "https://files.catbox.moe/p3s0qg.png"
			end
		end)
		local TextButton = Instance.new("TextButton")
		TextButton.Size = UDim2.new(0, 28, 0, 28)
		TextButton.Position = UDim2.new(1, -38, 0, 12)
		TextButton.BackgroundColor3 = textData.bgDark
		TextButton.BorderSizePixel = 0
		TextButton.Text = "-"
		TextButton.TextColor3 = textData.textMuted
		TextButton.Font = Enum.Font.GothamBlack
		TextButton.TextSize = 22
		TextButton.ZIndex = 5
		TextButton.Parent = alternateParent
		guiCorner(TextButton, 7)
		guiStroke(TextButton, Color3.fromRGB(45, 45, 45), 1)
		TextButton.MouseEnter:Connect(function()
			local twFunction = tw
			local textButton = TextButton
			local backgroundColor3 = Color3.fromRGB(28, 28, 28)
			local text = textData.text

			twFunction(textButton, {
				BackgroundColor3 = backgroundColor3,
				TextColor3 = text,
			})
		end)
		TextButton.MouseLeave:Connect(function()
			local twFunction = tw
			local textButton = TextButton
			local bgDark = textData.bgDark
			local textMuted = textData.textMuted

			twFunction(textButton, {
				BackgroundColor3 = bgDark,
				TextColor3 = textMuted,
			})
		end)
		local textButton = Instance.new("TextButton")
		textButton.Name = "VoidOpenPill"
		textButton.Size = UDim2.new(0, 220, 0, 46)
		textButton.Position = parent.Position
		textButton.BackgroundColor3 = Color3.fromRGB(12, 12, 14)
		textButton.BorderSizePixel = 0
		textButton.Text = ""
		textButton.AutoButtonColor = false
		textButton.ZIndex = 20
		textButton.Visible = false
		textButton.Parent = hubData.hub
		guiCorner(textButton, 14)
		local uiStroke = Instance.new("UIStroke", textButton)
		uiStroke.Color = Color3.fromRGB(55, 55, 60)
		uiStroke.Thickness = 1.1
		uiStroke.Transparency = 0.2
		local secondaryFrame = Instance.new("Frame", textButton)
		secondaryFrame.Size = UDim2.new(0, 3, 0.58, 0)
		secondaryFrame.Position = UDim2.new(0, 7, 0.5, 0)
		secondaryFrame.AnchorPoint = Vector2.new(0, 0.5)
		secondaryFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		secondaryFrame.BorderSizePixel = 0
		secondaryFrame.ZIndex = 21
		guiCorner(secondaryFrame, 2)
		local additionalParent = Instance.new("Frame", textButton)
		additionalParent.Size = UDim2.new(0, 34, 0, 34)
		additionalParent.Position = UDim2.new(0, 16, 0.5, 0)
		additionalParent.AnchorPoint = Vector2.new(0, 0.5)
		additionalParent.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		additionalParent.BorderSizePixel = 0
		additionalParent.ZIndex = 21
		guiCorner(additionalParent, 10)
		local TextLabel = Instance.new("TextLabel", additionalParent)
		TextLabel.Size = UDim2.new(1, 0, 1, 0)
		TextLabel.BackgroundTransparency = 1
		TextLabel.Text = "VOID"
		TextLabel.TextColor3 = Color3.fromRGB(12, 12, 14)
		TextLabel.Font = Enum.Font.GothamBlack
		TextLabel.TextSize = 10
		TextLabel.ZIndex = 22
		local textLabel = Instance.new("TextLabel", textButton)
		textLabel.Size = UDim2.new(0, 100, 0, 15)
		textLabel.Position = UDim2.new(0, 58, 0, 9)
		textLabel.BackgroundTransparency = 1
		textLabel.Text = "VOID DUELS"
		textLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
		textLabel.Font = Enum.Font.GothamBlack
		textLabel.TextSize = 12
		textLabel.TextXAlignment = Enum.TextXAlignment.Left
		textLabel.ZIndex = 21
		local secondaryTextLabel = Instance.new("TextLabel", textButton)
		secondaryTextLabel.Size = UDim2.new(0, 100, 0, 12)
		secondaryTextLabel.Position = UDim2.new(0, 58, 0, 25)
		secondaryTextLabel.BackgroundTransparency = 1
		secondaryTextLabel.Text = "TAP TO OPEN"
		secondaryTextLabel.TextColor3 = Color3.fromRGB(170, 170, 180)
		secondaryTextLabel.Font = Enum.Font.GothamBold
		secondaryTextLabel.TextSize = 9
		secondaryTextLabel.TextXAlignment = Enum.TextXAlignment.Left
		secondaryTextLabel.ZIndex = 21
		local fallbackParent = Instance.new("Frame", textButton)
		fallbackParent.Size = UDim2.new(0, 46, 0, 26)
		fallbackParent.Position = UDim2.new(1, -54, 0.5, 0)
		fallbackParent.AnchorPoint = Vector2.new(0, 0.5)
		fallbackParent.BackgroundColor3 = Color3.fromRGB(22, 22, 26)
		fallbackParent.BorderSizePixel = 0
		fallbackParent.ZIndex = 21
		guiCorner(fallbackParent, 8)
		local secondaryUiStroke = Instance.new("UIStroke", fallbackParent)
		secondaryUiStroke.Color = Color3.fromRGB(60, 60, 68)
		secondaryUiStroke.Thickness = 1
		local alternateTextLabel = Instance.new("TextLabel", fallbackParent)
		alternateTextLabel.Size = UDim2.new(1, 0, 1, 0)
		alternateTextLabel.BackgroundTransparency = 1
		alternateTextLabel.Text = "OPEN"
		alternateTextLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
		alternateTextLabel.Font = Enum.Font.GothamBold
		alternateTextLabel.TextSize = 10
		alternateTextLabel.ZIndex = 22
		makeDraggable_cyber(textButton, textButton)
		textButton.MouseEnter:Connect(function()
			tw(textButton, {
				BackgroundColor3 = Color3.fromRGB(18, 18, 22),
			})
			tw(fallbackParent, {
				BackgroundColor3 = Color3.fromRGB(32, 32, 38),
			})
		end)
		textButton.MouseLeave:Connect(function()
			tw(textButton, {
				BackgroundColor3 = Color3.fromRGB(12, 12, 14),
			})
			tw(fallbackParent, {
				BackgroundColor3 = Color3.fromRGB(22, 22, 26),
			})
		end)
		local hideGuiFlag = false
		local isHideGuiScaleValid
		local function hideGui()
			if hideGuiFlag then
				return
			end

			hideGuiFlag = true

			local scale = isHideGuiScaleValid()
			local tweenInfo = TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.In)

			if UIScale then
				iData.value2
					:Create(UIScale, tweenInfo, {
						Scale = scale * 0.86,
					})
					:Play()
			end

			if frame then
				iData.value2
					:Create(frame, tweenInfo, {
						BackgroundTransparency = 0.45,
					})
					:Play()
			end

			task.delay(0.2, function()
				parent.Visible = false
				textButton.Visible = true

				if UIScale then
					UIScale.Scale = scale
				end

				if frame then
					frame.BackgroundTransparency = 0
				end

				local uiScale = Instance.new("UIScale")

				uiScale.Scale = 0.7
				uiScale.Parent = textButton
				iData.value2
					:Create(uiScale, TweenInfo.new(0.22, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
						Scale = 1,
					})
					:Play()
				task.delay(0.25, function()
					pcall(function()
						uiScale:Destroy()
					end)
				end)
				hideGuiFlag = false
			end)
		end
		function isHideGuiScaleValid()
			return hubData.outerScale and hubData.outerScale.Scale or 0.7
		end
		local function showGui()
			if hideGuiFlag then
				return
			end

			textButton.Visible = false
			parent.Visible = true

			local scale = isHideGuiScaleValid()

			if UIScale then
				UIScale.Scale = scale * 0.82
			end

			if frame then
				frame.BackgroundTransparency = 0.35
			end

			local tweenInfo = TweenInfo.new(0.28, Enum.EasingStyle.Back, Enum.EasingDirection.Out)

			if UIScale then
				iData.value2
					:Create(UIScale, tweenInfo, {
						Scale = scale,
					})
					:Play()
			end

			if frame then
				iData.value2
					:Create(frame, TweenInfo.new(0.22, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
						BackgroundTransparency = 0,
					})
					:Play()
			end

			task.delay(0.3, function() end)
		end
		TextButton.MouseButton1Click:Connect(hideGui)
		textButton.MouseButton1Click:Connect(showGui)
		hubData.showGui = showGui
		hubData.hideGui = hideGui
		local alternateFrame = Instance.new("Frame")
		alternateFrame.Position = UDim2.new(0, 14, 0, 130)
		alternateFrame.Size = UDim2.new(1, -28, 0, 1)
		alternateFrame.BackgroundColor3 = textData.blue
		alternateFrame.BackgroundTransparency = 0.7
		alternateFrame.BorderSizePixel = 0
		alternateFrame.Parent = frame
		alternateFrame.ZIndex = 2
		Frame = Instance.new("Frame")
		Frame.Name = "TabBar"
		Frame.Size = UDim2.new(1, -16, 0, 78)
		Frame.Position = UDim2.new(0, 8, 0, 132)
		Frame.BackgroundTransparency = 1
		Frame.BorderSizePixel = 0
		Frame.Parent = frame
		Frame.ZIndex = 2
		local categoryList = Instance.new("Frame")
		categoryList.Name = "CategoryList"
		categoryList.Size = UDim2.new(1, 0, 1, 0)
		categoryList.BackgroundTransparency = 1
		categoryList.BorderSizePixel = 0
		categoryList.Parent = Frame
		hubData.categoryList = categoryList
		local ScrollingFrame = Instance.new("ScrollingFrame")
		ScrollingFrame.Name = "ContentFrame"
		ScrollingFrame.Size = UDim2.new(1, -16, 1, -222)
		ScrollingFrame.Position = UDim2.new(0, 8, 0, 214)
		ScrollingFrame.BackgroundTransparency = 1
		ScrollingFrame.BorderSizePixel = 0
		ScrollingFrame.ScrollBarThickness = 8
		ScrollingFrame.ScrollBarImageColor3 = textData.blue
		ScrollingFrame.CanvasSize = UDim2.new(0, 0, 0, 800)
		ScrollingFrame.AutomaticCanvasSize = Enum.AutomaticSize.None
		ScrollingFrame.ScrollingDirection = Enum.ScrollingDirection.Y
		ScrollingFrame.ScrollingEnabled = true
		ScrollingFrame.Active = true
		ScrollingFrame.ElasticBehavior = Enum.ElasticBehavior.Never
		ScrollingFrame.Parent = frame
		hubData.contentFrame = ScrollingFrame
		local updateInstancePropertiesFlag = false
		local function updateInstanceProperties()
			updateInstancePropertiesFlag = false

			local updateInstancePropertiesNumber =
				math.max(0, ScrollingFrame.AbsoluteCanvasSize.Y - ScrollingFrame.AbsoluteSize.Y)
			local clampedValue = math.clamp(ScrollingFrame.CanvasPosition.Y, 0, updateInstancePropertiesNumber)

			pcall(function()
				ScrollingFrame.ScrollVelocity = Vector2.new(0, 0)
			end)
			ScrollingFrame.CanvasPosition = Vector2.new(0, clampedValue)
			task.spawn(function()
				for _ = 1, 6 do
					pcall(function()
						ScrollingFrame.ScrollVelocity = Vector2.new(0, 0)
					end)
					ScrollingFrame.CanvasPosition =
						Vector2.new(0, (math.clamp(ScrollingFrame.CanvasPosition.Y, 0, updateInstancePropertiesNumber)))
					task.wait()
				end
			end)
		end
		ScrollingFrame.InputBegan:Connect(function(input)
			if
				input.UserInputType == Enum.UserInputType.Touch
				or (
					input.UserInputType == Enum.UserInputType.MouseButton1
					or input.UserInputType == Enum.UserInputType.MouseButton2
				)
			then
				updateInstancePropertiesFlag = true
			end
		end)
		ScrollingFrame.InputEnded:Connect(function(input)
			if
				input.UserInputType == Enum.UserInputType.Touch
				or (
					input.UserInputType == Enum.UserInputType.MouseButton1
					or input.UserInputType == Enum.UserInputType.MouseButton2
				)
			then
				updateInstanceProperties()
			end
		end)
		iData.value3.InputEnded:Connect(function(input)
			if not updateInstancePropertiesFlag then
				return
			end

			if
				input.UserInputType == Enum.UserInputType.Touch
				or (
					input.UserInputType == Enum.UserInputType.MouseButton1
					or input.UserInputType == Enum.UserInputType.MouseButton2
				)
			then
				updateInstanceProperties()
			end
		end)
		iData.value4.RenderStepped:Connect(function()
			if not updateInstancePropertiesFlag then
				pcall(function()
					if ScrollingFrame.ScrollVelocity.Magnitude > 0.01 then
						ScrollingFrame.ScrollVelocity = Vector2.new(0, 0)
					end
				end)
			end
		end)
		local UIListLayout = Instance.new("UIListLayout")
		UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
		UIListLayout.Padding = UDim.new(0, 6)
		UIListLayout.Parent = ScrollingFrame
		local function updateCanvasSize()
			task.defer(function()
				local updateCanvasSizeNumber = 0

				for _, child in ipairs(ScrollingFrame:GetChildren()) do
					if
						child:IsA("GuiObject")
						and (child.Visible and child.Name ~= "UIListLayout")
						and (
							not child:IsA("UIListLayout")
							and (not child:IsA("UIPadding") and not child:IsA("UIStroke"))
						)
					then
						local y = 0
						local uiListLayout = child:FindFirstChildOfClass("UIListLayout")

						if uiListLayout then
							y = uiListLayout.AbsoluteContentSize.Y
						end

						local sum = 0

						for _, item in ipairs(child:GetChildren()) do
							if item:IsA("GuiObject") and item.Visible then
								local AbsoluteSizeY = item.AbsoluteSize.Y

								if AbsoluteSizeY < 1 then
									AbsoluteSizeY = 40
								end

								sum = sum + AbsoluteSizeY + 6
							end
						end

						if y < sum then
							y = sum
						end

						if y < child.AbsoluteSize.Y then
							y = child.AbsoluteSize.Y
						end

						if updateCanvasSizeNumber < y then
							updateCanvasSizeNumber = y
						end
					end
				end

				if updateCanvasSizeNumber < 1 then
					updateCanvasSizeNumber = UIListLayout.AbsoluteContentSize.Y
				end

				local canvasSizeNumber = math.max(updateCanvasSizeNumber + 220, ScrollingFrame.AbsoluteSize.Y + 40)

				ScrollingFrame.CanvasSize = UDim2.new(0, 0, 0, canvasSizeNumber)
			end)
		end
		UIListLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
			task.defer(updateCanvasSize)
		end)
		ScrollingFrame:GetPropertyChangedSignal("AbsoluteSize"):Connect(function()
			task.defer(updateCanvasSize)
		end)
		task.spawn(function()
			for _ = 1, 12 do
				task.wait(0.12)
				updateCanvasSize()
			end
		end)
		local UIPadding = Instance.new("UIPadding")
		UIPadding.PaddingLeft = UDim.new(0, 6)
		UIPadding.PaddingRight = UDim.new(0, 6)
		UIPadding.PaddingTop = UDim.new(0, 6)
		UIPadding.PaddingBottom = UDim.new(0, 180)
		UIPadding.Parent = ScrollingFrame
		hubData.refreshCanvas = updateCanvasSize
		local additionalFrame = Instance.new("Frame")
		additionalFrame.Position = UDim2.new(0, 8, 1, -54)
		additionalFrame.Size = UDim2.new(1, -16, 0, 1)
		additionalFrame.BackgroundColor3 = textData.blue
		additionalFrame.BackgroundTransparency = 0.65
		additionalFrame.BorderSizePixel = 0
		additionalFrame.Parent = frame
		additionalFrame.ZIndex = 2
	end)()
	local cbData = {
		cb = nil,
		label = nil,
		active = false,
	}
	local secondaryData = {
		ButtonA = "A",
		ButtonB = "B",
		ButtonX = "X",
		ButtonY = "Y",
		ButtonR1 = "RB",
		ButtonR2 = "RT",
		ButtonL1 = "LB",
		ButtonL2 = "LT",
		DPadUp = "D\226\134\145",
		DPadDown = "D\226\134\147",
		DPadLeft = "D\226\134\144",
		DPadRight = "D\226\134\146",
		ButtonStart = "\226\150\182",
		ButtonSelect = "\226\151\128",
		LeftShift = "LShift",
		RightShift = "RShift",
		LeftControl = "LCtrl",
		RightControl = "RCtrl",
		LeftAlt = "LAlt",
		RightAlt = "RAlt",
		LeftSuper = "LSuper",
		RightSuper = "RSuper",
		Return = "Enter",
		BackSpace = "Backspace",
		Tab = "Tab",
		CapsLock = "CapsLock",
		Escape = "Esc",
		Space = "Space",
		PageUp = "PgUp",
		PageDown = "PgDn",
		End = "End",
		Home = "Home",
		Insert = "Ins",
		Delete = "Del",
		Up = "\226\134\145",
		Down = "\226\134\147",
		Left = "\226\134\144",
		Right = "\226\134\146",
		F1 = "F1",
		F2 = "F2",
		F3 = "F3",
		F4 = "F4",
		F5 = "F5",
		F6 = "F6",
		F7 = "F7",
		F8 = "F8",
		F9 = "F9",
		F10 = "F10",
		F11 = "F11",
		F12 = "F12",
		Minus = "-",
		Equals = "=",
		LeftBracket = "[",
		RightBracket = "]",
		BackSlash = "\\",
		Semicolon = ";",
		Quote = "'",
		Comma = ",",
		Period = ".",
		Slash = "/",
		Backquote = "`",
		ButtonA = "A (Pad)",
		ButtonB = "B (Pad)",
		ButtonX = "X (Pad)",
		ButtonY = "Y (Pad)",
		ButtonL1 = "L1",
		ButtonR1 = "R1",
		ButtonL2 = "L2",
		ButtonR2 = "R2",
		ButtonL3 = "L3",
		ButtonR3 = "R3",
		ButtonStart = "Start",
		ButtonSelect = "Select",
		DPadUp = "DPad \226\134\145",
		DPadDown = "DPad \226\134\147",
		DPadLeft = "DPad \226\134\144",
		DPadRight = "DPad \226\134\146",
		Thumbstick1 = "L Stick",
		Thumbstick2 = "R Stick",
	}
	function prettyKey(displayValue)
		if not displayValue then
			return "?"
		end

		local option = typeof(displayValue) == "EnumItem" and displayValue.Name or tostring(displayValue)

		return secondaryData[option] or option
	end
	function cancelKL()
		if cbData.label then
			cbData.label.BackgroundColor3 = textData.blue
			cbData.label.BackgroundTransparency = 0.5
		end

		cbData.cb = nil
		cbData.label = nil
		cbData.active = false
	end
	function startKL(label, cb)
		cancelKL()
		cbData.cb = cb
		cbData.label = label
		cbData.active = true
		label.Text = "..."
		label.BackgroundColor3 = Color3.fromRGB(80, 220, 120)
		label.BackgroundTransparency = 0.3
		task.delay(10, function()
			if cbData.label == label and cbData.active then
				cancelKL()

				if label and label.Parent then
					label.BackgroundColor3 = textData.blue
					label.BackgroundTransparency = 0.5
				end
			end
		end)
	end
	iData.value3.InputBegan:Connect(function(input, _)
		if not cbData.active then
			return
		end

		local UserInputType = input.UserInputType
		local flag = UserInputType == Enum.UserInputType.Gamepad1

		if not flag then
			flag = UserInputType == Enum.UserInputType.Gamepad2
				or (UserInputType == Enum.UserInputType.Gamepad3 or UserInputType == Enum.UserInputType.Gamepad4)
		end

		if UserInputType ~= Enum.UserInputType.Keyboard and not flag then
			return
		end

		local KeyCode = input.KeyCode

		if KeyCode == Enum.KeyCode.Unknown then
			return
		end

		if KeyCode == Enum.KeyCode.Thumbstick1 or KeyCode == Enum.KeyCode.Thumbstick2 then
			return
		end

		if KeyCode == Enum.KeyCode.Escape then
			cancelKL()

			return
		end

		local cb = cbData.cb
		local label = cbData.label

		cancelKL()

		if label and label.Parent then
			label.Text = prettyKey(KeyCode)
			label.BackgroundColor3 = textData.blue
			label.BackgroundTransparency = 0.5
		end

		if cb then
			task.spawn(cb, KeyCode)
		end
	end)
	function addSectLbl(secondaryParent, textLabel, layoutOrder)
		local parent = Instance.new("Frame", secondaryParent)

		parent.Size = UDim2.new(1, 0, 0, 22)
		parent.BackgroundTransparency = 1
		parent.LayoutOrder = layoutOrder

		local TextLabel = Instance.new("TextLabel", parent)

		TextLabel.Size = UDim2.new(1, 0, 0, 16)
		TextLabel.BackgroundTransparency = 1
		TextLabel.Text = textLabel
		TextLabel.TextColor3 = textData.textDim
		TextLabel.TextSize = 10
		TextLabel.Font = Enum.Font.GothamBold
		TextLabel.TextXAlignment = Enum.TextXAlignment.Left

		return TextLabel
	end
	function addInputRow(secondaryParent, textLabel, displayValue, layoutOrder, callback)
		local parent = Instance.new("Frame", secondaryParent)

		parent.Size = UDim2.new(1, 0, 0, 36)
		parent.BackgroundColor3 = textData.row
		parent.BackgroundTransparency = 0.5
		parent.BorderSizePixel = 0
		parent.LayoutOrder = layoutOrder
		guiCorner(parent, 10)
		guiStroke(parent, textData.divider, 1)

		local TextLabel = Instance.new("TextLabel", parent)

		TextLabel.Size = UDim2.new(0.6, 0, 0, 16)
		TextLabel.Position = UDim2.new(0, 12, 0, 6)
		TextLabel.BackgroundTransparency = 1
		TextLabel.Text = textLabel
		TextLabel.TextColor3 = textData.text
		TextLabel.TextSize = 11
		TextLabel.Font = Enum.Font.GothamBold
		TextLabel.TextXAlignment = Enum.TextXAlignment.Left

		local frame = Instance.new("Frame", parent)

		frame.ZIndex = 6
		frame.Position = UDim2.new(1, -58, 0.5, -10)
		frame.Size = UDim2.new(0, 48, 0, 20)
		frame.BackgroundColor3 = textData.input
		frame.BackgroundTransparency = 0.5
		frame.BorderSizePixel = 0
		guiCorner(frame, 6)
		guiStroke(frame, Color3.fromRGB(55, 55, 60), 1)

		local TextBox = Instance.new("TextBox", frame)

		TextBox.ZIndex = 7
		TextBox.Size = UDim2.new(1, 0, 1, 0)
		TextBox.BackgroundTransparency = 1
		TextBox.Text = tostring(displayValue)
		TextBox.TextColor3 = textData.text
		TextBox.TextSize = 11
		TextBox.Font = Enum.Font.GothamBold
		TextBox.ClearTextOnFocus = false
		TextBox.FocusLost:Connect(function()
			local num = tonumber(TextBox.Text)

			if num and num > 0 then
				callback(num)

				return
			end

			TextBox.Text = tostring(displayValue)
		end)

		local TextButton = Instance.new("TextButton", parent)

		TextButton.Size = UDim2.new(1, 0, 1, 0)
		TextButton.BackgroundTransparency = 1
		TextButton.Text = ""
		TextButton.ZIndex = 0
		TextButton.MouseEnter:Connect(function()
			tw(parent, {
				BackgroundTransparency = 0.3,
			})
		end)
		TextButton.MouseLeave:Connect(function()
			tw(parent, {
				BackgroundTransparency = 0.5,
			})
		end)

		return parent, TextBox
	end
	function addToggleRow(argument, textLabel, positionFlag, layoutOrder, flagCondition, callback)
		local instance = Instance
		local sizeFlag = flagCondition ~= nil
		local parent = instance.new("Frame", argument)

		parent.Size = UDim2.new(1, 0, 0, not sizeFlag and 38 or 50)
		parent.BackgroundColor3 = textData.row
		parent.BackgroundTransparency = 0.5
		parent.BorderSizePixel = 0
		parent.LayoutOrder = layoutOrder
		guiCorner(parent, 10)
		guiStroke(parent, textData.divider, 1)

		local TextLabel = Instance.new("TextLabel", parent)

		TextLabel.Size = UDim2.new(0.6, 0, 0, 16)
		TextLabel.Position = UDim2.new(0, 12, 0, 6)
		TextLabel.BackgroundTransparency = 1
		TextLabel.Text = textLabel
		TextLabel.TextColor3 = textData.text
		TextLabel.TextSize = 11
		TextLabel.Font = Enum.Font.GothamBold
		TextLabel.TextXAlignment = Enum.TextXAlignment.Left

		if sizeFlag then
			if not tpBatData[flagCondition] then
				tpBatData[flagCondition] = Enum.KeyCode.Unknown
			end

			local TextButton = Instance.new("TextButton", parent)

			TextButton.Size = UDim2.new(0, 52, 0, 16)
			TextButton.Position = UDim2.new(0, 12, 1, -20)
			TextButton.BackgroundColor3 = textData.blue
			TextButton.BackgroundTransparency = 0.5
			TextButton.BorderSizePixel = 0
			TextButton.Text = if tpBatData[flagCondition] ~= Enum.KeyCode.Unknown
				then prettyKey(tpBatData[flagCondition])
				else "SET"
			TextButton.TextColor3 = textData.white
			TextButton.TextSize = 9
			TextButton.Font = Enum.Font.GothamBold
			guiCorner(TextButton, 5)
			TextButton.MouseButton1Click:Connect(function()
				startKL(TextButton, function(argument)
					tpBatData[flagCondition] = argument
					TextButton.Text = prettyKey(argument)
					iData.value168()
				end)
			end)
		end

		local frame = Instance.new("Frame", parent)

		frame.Size = UDim2.new(0, 36, 0, 18)
		frame.Position = UDim2.new(1, -46, 0, 10)
		frame.BackgroundColor3 = textData.blueDark
		frame.BackgroundTransparency = 0.5
		frame.BorderSizePixel = 0
		guiCorner(frame, 10)
		guiStroke(frame, textData.blueDim, 1)

		local secondaryFrame = Instance.new("Frame", frame)

		secondaryFrame.Size = UDim2.new(0, 14, 0, 14)
		secondaryFrame.Position = positionFlag and UDim2.new(0.5, 2, 0.5, -7) or UDim2.new(0, 2, 0.5, -7)
		secondaryFrame.BackgroundColor3 = textData.blue
		secondaryFrame.BackgroundTransparency = not positionFlag and 0.5 or 0.3
		secondaryFrame.BorderSizePixel = 0
		guiCorner(secondaryFrame, 7)

		local flag = positionFlag
		local UIScale = Instance.new("UIScale")

		UIScale.Scale = 1
		UIScale.Parent = parent

		local function handler(capturedFlag)
			flag = capturedFlag

			local tweenInfo = TweenInfo.new(0.22, Enum.EasingStyle.Back, Enum.EasingDirection.Out)

			iData.value2
				:Create(secondaryFrame, tweenInfo, {
					Position = capturedFlag and UDim2.new(0.5, 2, 0.5, -7) or UDim2.new(0, 2, 0.5, -7),
					BackgroundTransparency = not capturedFlag and 0.5 or 0.15,
				})
				:Play()
			iData.value2
				:Create(frame, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {
					BackgroundColor3 = capturedFlag and Color3.fromRGB(40, 40, 48) or textData.blueDark,
				})
				:Play()
			iData.value2
				:Create(parent, TweenInfo.new(0.12), {
					BackgroundTransparency = 0.2,
				})
				:Play()
			task.delay(0.12, function()
				iData.value2
					:Create(parent, TweenInfo.new(0.18), {
						BackgroundTransparency = 0.5,
					})
					:Play()
			end)
		end

		local TextButton = Instance.new("TextButton", parent)

		TextButton.Size = UDim2.new(0, 36, 0, 18)
		TextButton.Position = UDim2.new(1, -46, 0, 10)
		TextButton.BackgroundTransparency = 1
		TextButton.Text = ""
		TextButton.MouseButton1Click:Connect(function()
			flag = not flag
			handler(flag)
			iData.value2
				:Create(UIScale, TweenInfo.new(0.08), {
					Scale = 0.97,
				})
				:Play()
			task.delay(0.08, function()
				iData.value2
					:Create(UIScale, TweenInfo.new(0.16, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
						Scale = 1,
					})
					:Play()
			end)

			if callback then
				callback(flag)
			end
		end)

		local textButton = Instance.new("TextButton", parent)

		textButton.Size = UDim2.new(1, 0, 1, 0)
		textButton.BackgroundTransparency = 1
		textButton.Text = ""
		textButton.ZIndex = 0
		textButton.MouseEnter:Connect(function()
			tw(parent, {
				BackgroundTransparency = 0.3,
			})
		end)
		textButton.MouseLeave:Connect(function()
			tw(parent, {
				BackgroundTransparency = 0.5,
			})
		end)

		if flagCondition then
			data[flagCondition] = handler
		end

		return parent, handler
	end
	function addActionRow(secondaryParent, textLabel, textButtonCondition, callback, layoutOrder)
		local parent = Instance.new("Frame", secondaryParent)

		parent.Size = UDim2.new(1, 0, 0, 42)
		parent.BackgroundColor3 = textData.row
		parent.BackgroundTransparency = 0.5
		parent.BorderSizePixel = 0
		parent.LayoutOrder = layoutOrder
		guiCorner(parent, 10)
		guiStroke(parent, textData.divider, 1)

		local TextLabel = Instance.new("TextLabel", parent)

		TextLabel.Size = UDim2.new(0.55, 0, 0, 16)
		TextLabel.Position = UDim2.new(0, 12, 0, 8)
		TextLabel.BackgroundTransparency = 1
		TextLabel.Text = textLabel
		TextLabel.TextColor3 = textData.text
		TextLabel.TextSize = 11
		TextLabel.Font = Enum.Font.GothamBold
		TextLabel.TextXAlignment = Enum.TextXAlignment.Left

		if textButtonCondition then
			if not tpBatData[textButtonCondition] then
				tpBatData[textButtonCondition] = Enum.KeyCode.Unknown
			end

			local TextButton = Instance.new("TextButton", parent)

			TextButton.Size = UDim2.new(0, 58, 0, 22)
			TextButton.Position = UDim2.new(1, -66, 0.5, -11)
			TextButton.BackgroundColor3 = textData.blue
			TextButton.BackgroundTransparency = 0.5
			TextButton.BorderSizePixel = 0
			TextButton.Text = if tpBatData[textButtonCondition] ~= Enum.KeyCode.Unknown
				then prettyKey(tpBatData[textButtonCondition])
				else "SET"
			TextButton.TextColor3 = textData.white
			TextButton.TextSize = 9
			TextButton.Font = Enum.Font.GothamBold
			guiCorner(TextButton, 5)
			TextButton.MouseButton1Click:Connect(function()
				startKL(TextButton, function(argument)
					tpBatData[textButtonCondition] = argument
					TextButton.Text = prettyKey(argument)
					iData.value168()
				end)
			end)
		end

		local UIScale = Instance.new("UIScale")

		UIScale.Scale = 1
		UIScale.Parent = parent

		local TextButton = Instance.new("TextButton", parent)

		TextButton.Size = UDim2.new(0.55, 0, 1, 0)
		TextButton.BackgroundTransparency = 1
		TextButton.Text = ""
		TextButton.MouseButton1Click:Connect(function()
			iData.value2
				:Create(UIScale, TweenInfo.new(0.08), {
					Scale = 0.96,
				})
				:Play()
			iData.value2
				:Create(parent, TweenInfo.new(0.1), {
					BackgroundTransparency = 0.2,
				})
				:Play()
			task.delay(0.08, function()
				iData.value2
					:Create(UIScale, TweenInfo.new(0.16, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
						Scale = 1,
					})
					:Play()
				iData.value2
					:Create(parent, TweenInfo.new(0.18), {
						BackgroundTransparency = 0.5,
					})
					:Play()
			end)

			if callback then
				callback()
			end
		end)

		local textButton = Instance.new("TextButton", parent)

		textButton.Size = UDim2.new(1, 0, 1, 0)
		textButton.BackgroundTransparency = 1
		textButton.Text = ""
		textButton.ZIndex = 0
		textButton.MouseEnter:Connect(function()
			tw(parent, {
				BackgroundTransparency = 0.3,
			})
		end)
		textButton.MouseLeave:Connect(function()
			tw(parent, {
				BackgroundTransparency = 0.5,
			})
		end)

		return parent
	end
	local alternateData = {
		"Speed",
		"Combat",
		"Steal",
		"Movement",
		"Visual",
		"Keybinds",
		"Background",
	}
	local vData = {
		contents = {},
		btnsSide = {},
		active = "Speed",
	}
	(function()
		for _, item in pairs(alternateData) do
			local parent = Instance.new("Frame")

			parent.Size = UDim2.new(1, 0, 0, 0)
			parent.AutomaticSize = Enum.AutomaticSize.Y
			parent.BackgroundTransparency = 1
			parent.Visible = item == "Speed"
			parent.Parent = hubData.contentFrame
			vData.contents[item] = parent

			local UIListLayout = Instance.new("UIListLayout")

			UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
			UIListLayout.Padding = UDim.new(0, 6)
			UIListLayout.Parent = parent
			UIListLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
				if parent.Visible and hubData.refreshCanvas then
					hubData.refreshCanvas()
				end
			end)
		end
		local speed = {
			x = 0,
			y = 0,
			w = 0.24,
			h = 0.46,
			special = false,
		}
		local combat = {
			x = 0.25,
			y = 0,
			w = 0.24,
			h = 0.46,
			special = false,
		}
		local steal = {
			x = 0.5,
			y = 0,
			w = 0.24,
			h = 0.46,
			special = false,
		}
		local movement = {
			x = 0.75,
			y = 0,
			w = 0.24,
			h = 0.46,
			special = false,
		}
		local visual = {
			x = 0,
			y = 0.52,
			w = 0.31,
			h = 0.46,
			special = false,
		}
		local keybinds = {
			x = 0.33,
			y = 0.52,
			w = 0.31,
			h = 0.46,
			special = false,
		}
		local background = {
			x = 0.66,
			y = 0.52,
			w = 0.31,
			h = 0.46,
			special = false,
		}
		local data = {
			Speed = speed,
			Combat = combat,
			Steal = steal,
			Movement = movement,
			Visual = visual,
			Keybinds = keybinds,
			Background = background,
		}
		local parent = Instance.new("Frame")
		parent.Name = "TabHighlight"
		parent.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		parent.BackgroundTransparency = 0.88
		parent.BorderSizePixel = 0
		parent.ZIndex = 1
		parent.Parent = hubData.categoryList
		guiCorner(parent, 8)
		local UIStroke = Instance.new("UIStroke", parent)
		UIStroke.Color = Color3.fromRGB(255, 255, 255)
		UIStroke.Thickness = 1.2
		UIStroke.Transparency = 0.55
		local tweenInfo = TweenInfo.new(0.28, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
		local capturedTweenInfo = tweenInfo
		local function moveTabHl(moveTabHlFlag)
			if not moveTabHlFlag then
				return
			end

			local createMoveTabHl = iData.value2
			local tabHl = parent
			local secondaryCapturedTweenInfo = capturedTweenInfo
			local Create = createMoveTabHl.Create
			local p126Position = moveTabHlFlag.Position
			local p126Size = moveTabHlFlag.Size

			Create(createMoveTabHl, tabHl, secondaryCapturedTweenInfo, {
				Position = p126Position,
				Size = p126Size,
			}):Play()
		end
		vData.tabHL = parent
		vData.moveTabHL = moveTabHl
		for layoutOrder, item in ipairs(alternateData) do
			local active = item
			local sizeData = data[active]

			if not sizeData then
				sizeData = {
					x = 0,
					y = 0,
					w = 0.3,
					h = 0.45,
					special = false,
				}
			end

			local TextButton = Instance.new("TextButton")

			TextButton.Size = UDim2.new(sizeData.w, -4, sizeData.h, -2)
			TextButton.Position = UDim2.new(sizeData.x, 2, sizeData.y, 1)
			TextButton.BackgroundColor3 = textData.blueDark
			TextButton.BackgroundTransparency = active ~= "Speed" and 0.42 or 0.12
			TextButton.Text = active
			TextButton.TextColor3 = active == "Speed" and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(230, 230, 235)
			TextButton.TextSize = 10
			TextButton.Font = Enum.Font.GothamBold
			TextButton.BorderSizePixel = 0
			TextButton.LayoutOrder = layoutOrder
			TextButton.ZIndex = 3
			TextButton.Parent = hubData.categoryList
			guiCorner(TextButton, 8)

			local frame = Instance.new("Frame")

			frame.Name = "indicator"
			frame.Size = UDim2.new(1, -10, 0, 2)
			frame.Position = UDim2.new(0, 5, 1, -3)
			frame.BackgroundColor3 = textData.white
			frame.BackgroundTransparency = active ~= "Speed" and 1 or 0.1
			frame.BorderSizePixel = 0
			frame.ZIndex = 4
			frame.Parent = TextButton
			vData.btnsSide[active] = TextButton
			TextButton.MouseButton1Click:Connect(function()
				if vData.active == active then
					return
				end

				for _, item in pairs(vData.contents) do
					item.Visible = false
				end

				local parent = vData.contents[active]

				parent.Visible = true
				vData.active = active

				local UIScale = parent:FindFirstChildOfClass("UIScale")

				if not UIScale then
					UIScale = Instance.new("UIScale")
					UIScale.Parent = parent
				end

				UIScale.Scale = 0.96
				iData.value2
					:Create(UIScale, TweenInfo.new(0.2, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
						Scale = 1,
					})
					:Play()
				parent.BackgroundTransparency = 1

				for k, indicatorContainer in pairs(vData.btnsSide) do
					local vColorFlag = k == active

					iData.value2
						:Create(indicatorContainer, capturedTweenInfo, {
							BackgroundTransparency = not vColorFlag and 0.42 or 0.12,
						})
						:Play()
					indicatorContainer.TextColor3 = vColorFlag and Color3.fromRGB(255, 255, 255)
						or Color3.fromRGB(230, 230, 235)

					local indicator = indicatorContainer:FindFirstChild("indicator")

					if indicator then
						iData.value2
							:Create(indicator, capturedTweenInfo, {
								BackgroundTransparency = not vColorFlag and 1 or 0.1,
							})
							:Play()
					end
				end

				moveTabHl(TextButton)
				task.defer(function()
					if hubData.refreshCanvas then
						hubData.refreshCanvas()
					end

					hubData.contentFrame.CanvasPosition = Vector2.new(0, 0)
				end)
			end)
			TextButton.MouseEnter:Connect(function()
				if vData.active ~= active then
					iData.value2
						:Create(TextButton, TweenInfo.new(0.12), {
							BackgroundTransparency = 0.25,
						})
						:Play()
					TextButton.TextColor3 = Color3.fromRGB(255, 255, 255)
				end
			end)
			TextButton.MouseLeave:Connect(function()
				if vData.active ~= active then
					iData.value2
						:Create(TextButton, TweenInfo.new(0.12), {
							BackgroundTransparency = 0.42,
						})
						:Play()
					TextButton.TextColor3 = Color3.fromRGB(230, 230, 235)
				end
			end)
		end
		local btnsSideSpeed = vData.btnsSide.Speed
		if btnsSideSpeed then
			btnsSideSpeed.TextColor3 = Color3.fromRGB(255, 255, 255)
			btnsSideSpeed.BackgroundTransparency = 0.12

			local indicator = btnsSideSpeed:FindFirstChild("indicator")

			if indicator then
				indicator.BackgroundTransparency = 0.1
			end

			parent.Position = btnsSideSpeed.Position
			parent.Size = btnsSideSpeed.Size
		end
	end)();
	(function()
		local contentsSpeed = vData.contents.Speed

		addSectLbl(contentsSpeed, "AUTO", 0)
		addToggleRow(contentsSpeed, "Auto Carry Speed", iData.value85, 1, nil, function(argument)
			iData.value85 = argument
			iData.value168()
		end)
		addSectLbl(contentsSpeed, "SPEED CONFIGURATION", 2)
		addInputRow(contentsSpeed, "Normal Speed", iData.value12, 3, function(argument)
			iData.value12 = argument
			iData.value168()
		end)
		addInputRow(contentsSpeed, "Carry Speed", iData.value13, 4, function(argument)
			iData.value13 = argument
			iData.value168()
		end)
		addSectLbl(contentsSpeed, "LAGGER MODE", 5)
		addInputRow(contentsSpeed, "Lagger Normal", iData.value14, 6, function(argument)
			iData.value14 = argument
			iData.value168()
		end)
		addInputRow(contentsSpeed, "Lagger Carry", iData.value15, 7, function(argument)
			iData.value15 = argument
			iData.value168()
		end)
		addSectLbl(contentsSpeed, "CONTROLS", 8)
		addToggleRow(contentsSpeed, "Carry Mode", iData.value16, 9, nil, function(argument)
			iData.value16 = argument

			if iData.value78.carrySpeed then
				iData.value78.carrySpeed(iData.value16)
			end

			if iData.value119 then
				iData.value119()
			end

			iData.value168()
		end)
		addToggleRow(contentsSpeed, "Lagger Mode", iData.value17, 10, nil, function(argument)
			iData.value17 = argument

			if iData.value78.lagger then
				iData.value78.lagger(argument)
			end

			if iData.value119 then
				iData.value119()
			end

			iData.value168()
		end)
	end)();
	(function()
		local Combat = vData.contents.Combat

		addSectLbl(Combat, "BAT CONTROLS", 0)
		addToggleRow(Combat, "BAT V2 (Void Anti Bat)", iData.value32, 0, nil, function(condition)
			if condition then
				if iData.value164 and (iData.value164.tryStart and not iData.value164.tryStart()) then
					return
				end

				iData.value26.startBatV2()
			else
				iData.value26.stopBatV2()
			end

			if iData.value78.batV2 then
				iData.value78.batV2(iData.value32 or iData.value26.batV2)
			end

			iData.value168()
		end)
		addInputRow(Combat, "BAT V2 Speed", iData.value33, 1, function(numberText)
			iData.value33 = math.clamp(tonumber(numberText) or 56.5, 1, 200)
			iData.value168()
		end)
		addToggleRow(Combat, "Mirror TP Down (Aimbot + BAT V2)", iData.value36, 2, nil, function(argument)
			iData.value36 = argument == true

			if not iData.value36 then
				pcall(function()
					table.clear(iData.value39)
				end)
			end

			iData.value168()
		end)

		local _, addToggleRowResult = addToggleRow(Combat, "Bat Aimbot", iData.value31, 1, nil, function(condition)
			if condition then
				if iData.value27 then
					iData.value27 = false
					secondaryUpdateInstanceProperties()

					if iData.value29 then
						iData.value29(false)
					end

					if iData.value78.autoLeft then
						iData.value78.autoLeft(false)
					end
				end

				if iData.value28 then
					iData.value28 = false
					iData.value150()

					if iData.value30 then
						iData.value30(false)
					end

					if iData.value78.autoRight then
						iData.value78.autoRight(false)
					end
				end

				iData.value125()

				if iData.value78.autoBat then
					iData.value78.autoBat(true)
				end
			else
				iData.value124()

				if iData.value78.autoBat then
					iData.value78.autoBat(false)
				end
			end

			iData.value168()
		end)

		iData.value54 = addToggleRowResult

		local _, _ = addToggleRow(Combat, "Auto Swing", iData.value49, 2, nil, function(argument)
			iData.value49 = argument
			iData.value168()
		end)

		addToggleRow(Combat, "Aimbot After Hit", iData.value47, 3, nil, function(argument)
			iData.value47 = argument
			iData.value168()
		end)

		local _, _ = addToggleRow(Combat, "Bat Counter", iData.value21, 4, nil, function(value21Condition)
			iData.value21 = value21Condition

			if value21Condition then
				iData.value56()
			elseif iData.value140.batCounter then
				iData.value140.batCounter:Disconnect()
				iData.value140.batCounter = nil
			end

			iData.value168()
		end)

		addSectLbl(Combat, "RAGDOLL", 4)

		local _, callback = addToggleRow(Combat, "Anti Ragdoll", iData.value18, 5, nil, function(value18Condition)
			iData.value18 = value18Condition

			if value18Condition then
				if not iData.value140.antiRag then
					iData.value140.antiRag = iData.value4.Heartbeat:Connect(function()
						if not iData.value18 then
							return
						end

						local Character = iData.value11.Character

						if not Character then
							return
						end

						local Humanoid = Character:FindFirstChildOfClass("Humanoid")
						local HumanoidRootPart = Character:FindFirstChild("HumanoidRootPart")

						if not Humanoid or not HumanoidRootPart then
							return
						end

						local State = Humanoid:GetState()
						local flag = State == Enum.HumanoidStateType.Physics
							or (State == Enum.HumanoidStateType.Ragdoll or State == Enum.HumanoidStateType.FallingDown)
						local RagdollEndTime = iData.value11:GetAttribute("RagdollEndTime")

						if RagdollEndTime and RagdollEndTime - workspace:GetServerTimeNow() > 0 then
							flag = true
						end

						if flag then
							pcall(function()
								local result = iData.value11
								local data = { workspace:GetServerTimeNow() }

								result:SetAttribute("RagdollEndTime", unpackValues(data))
							end)
							for _, descendant in ipairs(Character:GetDescendants()) do
								if
									descendant:IsA("BallSocketConstraint")
									or descendant:IsA("Attachment") and descendant.Name:find("RagdollAttachment")
								then
									descendant:Destroy()
								end
							end
							for index, item in ipairs(Character:GetDescendants()) do
								if item:IsA("Motor6D") and item.Enabled == false then
									item.Enabled = true
								end
							end
							if Humanoid.Health > 0 then
								Humanoid:ChangeState(Enum.HumanoidStateType.Running)
							end
							workspace.CurrentCamera.CameraSubject = Humanoid
							HumanoidRootPart.Anchored = false
							HumanoidRootPart.AssemblyLinearVelocity = Vector3.zero
							HumanoidRootPart.AssemblyAngularVelocity = Vector3.zero
						end
					end)
				end
			else
				iData.value122()
			end

			iData.value168()
		end)

		if iData.value18 then
			callback(true)
		end

		local _, _ = addToggleRow(Combat, "Medusa Counter", iData.value20, 6, nil, function(value20Condition)
			iData.value20 = value20Condition

			if value20Condition then
				iData.value121(iData.value11.Character)
			else
				updateAnchor()
			end

			iData.value168()
		end)
		local _, _ = addToggleRow(Combat, "Unwalk", iData.value22, 7, nil, function(value22Condition)
			iData.value22 = value22Condition

			if value22Condition then
				iData.value120()
			else
				iData.value172()
			end

			iData.value168()
		end)

		addSectLbl(Combat, "PROTECTION", 13)

		local _, setAntiKickVisual = addToggleRow(
			Combat,
			"Anti Kick / Safe Mode",
			iData.value26.antiKick,
			14,
			nil,
			function(condition)
				if condition then
					iData.value26.antiKick = false
					iData.value26.enableAntiKick()

					if iData.value164 and iData.value164.forceStop then
						iData.value164.forceStop("SAFE MODE")
					end
				else
					iData.value26.disableAntiKick()
				end

				if iData.value26.setSafeModeVisual then
					iData.value26.setSafeModeVisual(iData.value26.antiKick)
				end

				iData.value168()
			end
		)

		iData.value26.setAntiKickVisual = setAntiKickVisual
		addSectLbl(Combat, "TP BAT", 15)

		local _, setTpBatVisual = addToggleRow(Combat, "TP Bat", iData.value26.tpBat, 16, nil, function(secondaryTpBat)
			if secondaryTpBat then
				if iData.value164 and (iData.value164.tryStart and not iData.value164.tryStart()) then
					if iData.value26.setTPBatVisual then
						iData.value26.setTPBatVisual(false)
					end

					if iData.value78.tpBat then
						iData.value78.tpBat(false)
					end

					return
				end

				iData.value26.startTPBat()
			else
				iData.value26.stopTPBat()
			end

			if iData.value78.tpBat then
				local tpBat = iData.value78.tpBat

				if secondaryTpBat then
					secondaryTpBat = iData.value26.tpBat
				end

				tpBat(secondaryTpBat)
			end
		end)

		iData.value26.setTPBatVisual = setTpBatVisual
		addSectLbl(Combat, "ACTIONS", 9)
		addActionRow(Combat, "Drop Brainrot", nil, function()
			iData.value153()
		end, 10)
		addActionRow(Combat, "TP Down", nil, function()
			iData.value155()
		end, 12)
	end)();
	(function()
		local Steal = vData.contents.Steal

		addSectLbl(Steal, "AUTO STEAL", 0)
		addToggleRow(Steal, "Auto Steal", iData.value136.AutoStealEnabled, 1, nil, function(autoStealEnabled)
			iData.value136.AutoStealEnabled = autoStealEnabled

			if autoStealEnabled then
				if not iData.value140.autoSteal then
					iData.value140.autoSteal = iData.value4.Heartbeat:Connect(function()
						if iData.value138 or not iData.value136.AutoStealEnabled then
							return
						end

						local ok, result = pcall(findNearestPrompt)

						if ok and result then
							pcall(executeSteal, result)
						end
					end)
				end
			else
				iData.value145()
			end

			iData.value168()
		end)
		addInputRow(Steal, "Steal Radius", iData.value136.StealRadius, 2, function(numberText)
			iData.value136.StealRadius = tonumber(numberText) or 60
			iData.value168()
		end)
		addSectLbl(Steal, "STEAL BAR STYLE", 2)

		local parent = Instance.new("Frame")

		parent.Size = UDim2.new(1, -8, 0, 36)
		parent.BackgroundTransparency = 1
		parent.LayoutOrder = 3
		parent.Parent = Steal

		local UIListLayout = Instance.new("UIListLayout", parent)

		UIListLayout.FillDirection = Enum.FillDirection.Horizontal
		UIListLayout.Padding = UDim.new(0, 8)
		UIListLayout.VerticalAlignment = Enum.VerticalAlignment.Center

		local updateInstancePropertiesData = {}

		local function updateInstanceProperties()
			for k, item in pairs(updateInstancePropertiesData) do
				local updateInstancePropertiesFlag = k == iData.value76
				local vColorFlag = updateInstancePropertiesFlag

				if updateInstancePropertiesFlag then
					vColorFlag = Color3.fromRGB(255, 255, 255)
				end

				item.BackgroundColor3 = vColorFlag or Color3.fromRGB(18, 18, 22)
				item.TextColor3 = updateInstancePropertiesFlag and Color3.fromRGB(0, 0, 0)
					or Color3.fromRGB(230, 230, 235)
			end
		end

		for _, item in ipairs({
			{
				id = 1,
				label = "1 \194\183 Vertical",
			},
			{
				id = 2,
				label = "2 \194\183 Full",
			},
		}) do
			local capturedV = item
			local TextButton = Instance.new("TextButton")

			TextButton.Size = UDim2.new(0, 110, 0, 30)
			TextButton.BackgroundColor3 = Color3.fromRGB(18, 18, 22)
			TextButton.BorderSizePixel = 0
			TextButton.Text = capturedV.label
			TextButton.TextColor3 = Color3.fromRGB(230, 230, 235)
			TextButton.Font = Enum.Font.GothamBold
			TextButton.TextSize = 11
			TextButton.AutoButtonColor = false
			TextButton.Parent = parent
			guiCorner(TextButton, 8)
			guiStroke(TextButton, Color3.fromRGB(50, 50, 58), 1)
			updateInstancePropertiesData[capturedV.id] = TextButton
			TextButton.MouseButton1Click:Connect(function()
				iData.value76 = capturedV.id
				updateInstanceProperties()
				pcall(createStealBar)
				iData.value168()
			end)
		end

		updateInstanceProperties()
		addSectLbl(Steal, "STEAL BAR SIZE", 3)

		local frame = Instance.new("Frame")

		frame.Size = UDim2.new(1, -8, 0, 36)
		frame.BackgroundTransparency = 1
		frame.LayoutOrder = 3
		frame.Parent = Steal

		local uiListLayout = Instance.new("UIListLayout", frame)

		uiListLayout.FillDirection = Enum.FillDirection.Horizontal
		uiListLayout.Padding = UDim.new(0, 8)
		uiListLayout.VerticalAlignment = Enum.VerticalAlignment.Center

		local TextLabel = Instance.new("TextLabel", frame)

		TextLabel.Size = UDim2.new(0, 70, 0, 28)
		TextLabel.BackgroundTransparency = 1
		TextLabel.Text = string.format("%.0f%%", (tonumber(iData.value77) or 1) * 100)
		TextLabel.TextColor3 = Color3.fromRGB(230, 230, 235)
		TextLabel.Font = Enum.Font.GothamBold
		TextLabel.TextSize = 12
		TextLabel.TextXAlignment = Enum.TextXAlignment.Left

		local function secondaryUpdateInstanceProperties(updateInstancePropertiesNumber)
			iData.value77 = math.clamp((tonumber(iData.value77) or 1) + updateInstancePropertiesNumber, 0.7, 1.8)
			TextLabel.Text = string.format("%.0f%%", iData.value77 * 100)
			pcall(createStealBar)
			iData.value168()
		end

		local TextButton = Instance.new("TextButton", frame)

		TextButton.Size = UDim2.new(0, 36, 0, 28)
		TextButton.BackgroundColor3 = Color3.fromRGB(18, 18, 22)
		TextButton.BorderSizePixel = 0
		TextButton.Text = "-"
		TextButton.TextColor3 = Color3.fromRGB(255, 255, 255)
		TextButton.Font = Enum.Font.GothamBlack
		TextButton.TextSize = 16
		TextButton.AutoButtonColor = false
		guiCorner(TextButton, 8)
		TextButton.MouseButton1Click:Connect(function()
			secondaryUpdateInstanceProperties(-0.1)
		end)

		local textButton = Instance.new("TextButton", frame)

		textButton.Size = UDim2.new(0, 36, 0, 28)
		textButton.BackgroundColor3 = Color3.fromRGB(18, 18, 22)
		textButton.BorderSizePixel = 0
		textButton.Text = "+"
		textButton.TextColor3 = Color3.fromRGB(255, 255, 255)
		textButton.Font = Enum.Font.GothamBlack
		textButton.TextSize = 16
		textButton.AutoButtonColor = false
		guiCorner(textButton, 8)
		textButton.MouseButton1Click:Connect(function()
			secondaryUpdateInstanceProperties(0.1)
		end)

		local resetButton = Instance.new("TextButton", frame)

		resetButton.Size = UDim2.new(0, 64, 0, 28)
		resetButton.BackgroundColor3 = Color3.fromRGB(18, 18, 22)
		resetButton.BorderSizePixel = 0
		resetButton.Text = "Reset"
		resetButton.TextColor3 = Color3.fromRGB(200, 200, 210)
		resetButton.Font = Enum.Font.GothamBold
		resetButton.TextSize = 11
		resetButton.AutoButtonColor = false
		guiCorner(resetButton, 8)
		resetButton.MouseButton1Click:Connect(function()
			TextLabel.Text = "100%"
			pcall(createStealBar)
			iData.value168()
		end)
		addSectLbl(Steal, "HOLD AT %", 4)

		local secondaryParent = Instance.new("Frame")

		secondaryParent.Size = UDim2.new(1, -8, 0, 36)
		secondaryParent.BackgroundTransparency = 1
		secondaryParent.LayoutOrder = 5
		secondaryParent.Parent = Steal

		local secondaryUiListLayout = Instance.new("UIListLayout", secondaryParent)

		secondaryUiListLayout.FillDirection = Enum.FillDirection.Horizontal
		secondaryUiListLayout.Padding = UDim.new(0, 6)
		secondaryUiListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Left
		secondaryUiListLayout.VerticalAlignment = Enum.VerticalAlignment.Center
		secondaryUiListLayout.SortOrder = Enum.SortOrder.LayoutOrder

		local data = {
			{
				mode = 1,
				label = "90%",
			},
			{
				mode = 2,
				label = "85%",
			},
			{
				mode = 3,
				label = "80%",
			},
			{
				mode = 4,
				label = "75%",
			},
		}
		local modeData = {}

		local function alternateUpdateInstanceProperties()
			for _, item in ipairs(data) do
				local mode = modeData[item.mode]

				if mode then
					local isValue136Mode = iData.value136.Mode == item.mode
					local isFlagValue136Mode = isValue136Mode

					if isValue136Mode then
						isFlagValue136Mode = Color3.fromRGB(255, 255, 255)
					end

					mode.BackgroundColor3 = isFlagValue136Mode or Color3.fromRGB(18, 18, 22)
					mode.TextColor3 = isValue136Mode and Color3.fromRGB(0, 0, 0) or Color3.fromRGB(230, 230, 235)
				end
			end
		end

		for i, item in ipairs(data) do
			local capturedV = item
			local parent = Instance.new("TextButton")

			parent.Size = UDim2.new(0, 58, 0, 30)
			parent.BackgroundColor3 = Color3.fromRGB(18, 18, 22)
			parent.BorderSizePixel = 0
			parent.Text = capturedV.label
			parent.TextColor3 = Color3.fromRGB(230, 230, 235)
			parent.Font = Enum.Font.GothamBold
			parent.TextSize = 13
			parent.AutoButtonColor = false
			parent.LayoutOrder = i
			parent.Parent = secondaryParent
			guiCorner(parent, 8)

			local UIStroke = Instance.new("UIStroke", parent)

			UIStroke.Color = Color3.fromRGB(50, 50, 55)
			UIStroke.Thickness = 1
			parent.MouseButton1Click:Connect(function()
				iData.value136.Mode = capturedV.mode
				alternateUpdateInstanceProperties()
				iData.value168()
			end)
			modeData[capturedV.mode] = parent
		end

		alternateUpdateInstanceProperties()
	end)();
	(function()
		local Movement = vData.contents.Movement

		task.spawn(function()
			task.wait(0.2)
			iData.value26.antiKick = true

			if iData.value26.enableAntiKick then
				iData.value26.enableAntiKick()
			end
		end)
		addSectLbl(Movement, "AUTO PATHS", 0)

		local _, addToggleRowResult = addToggleRow(Movement, "Auto Left", iData.value27, 3, nil, function(condition)
			if condition then
				if iData.value164 and (iData.value164.tryStart and not iData.value164.tryStart()) then
					if iData.value29 then
						iData.value29(false)
					end

					if iData.value78.autoLeft then
						iData.value78.autoLeft(false)
					end

					return
				end

				if iData.value28 then
					iData.value28 = false
					iData.value150()

					if iData.value30 then
						iData.value30(false)
					end

					if iData.value78.autoRight then
						iData.value78.autoRight(false)
					end
				end

				if iData.value31 then
					iData.value124()

					if iData.value54 then
						iData.value54(false)
					end

					if iData.value78.autoBat then
						iData.value78.autoBat(false)
					end
				end

				iData.value27 = true
				iData.value151()

				if iData.value78.autoLeft then
					iData.value78.autoLeft(true)
				end
			else
				iData.value27 = false
				secondaryUpdateInstanceProperties()

				if iData.value78.autoLeft then
					iData.value78.autoLeft(false)
				end
			end

			iData.value168()
		end)

		iData.value29 = addToggleRowResult

		local _, secondaryAddToggleRowResult = addToggleRow(
			Movement,
			"Auto Right",
			iData.value28,
			4,
			nil,
			function(condition)
				if condition then
					if iData.value164 and (iData.value164.tryStart and not iData.value164.tryStart()) then
						if iData.value30 then
							iData.value30(false)
						end

						if iData.value78.autoRight then
							iData.value78.autoRight(false)
						end

						return
					end

					if iData.value27 then
						iData.value27 = false
						secondaryUpdateInstanceProperties()

						if iData.value29 then
							iData.value29(false)
						end

						if iData.value78.autoLeft then
							iData.value78.autoLeft(false)
						end
					end

					if iData.value31 then
						iData.value124()

						if iData.value54 then
							iData.value54(false)
						end

						if iData.value78.autoBat then
							iData.value78.autoBat(false)
						end
					end

					iData.value28 = true
					iData.value152()

					if iData.value78.autoRight then
						iData.value78.autoRight(true)
					end
				else
					iData.value28 = false
					iData.value150()

					if iData.value78.autoRight then
						iData.value78.autoRight(false)
					end
				end

				iData.value168()
			end
		)

		iData.value30 = secondaryAddToggleRowResult
		addSectLbl(Movement, "SETTINGS", 5)

		local _, _ = addToggleRow(Movement, "Auto TP", iData.value63, 6, nil, function(value63Condition)
			iData.value63 = value63Condition

			if value63Condition then
				if iData.value65 then
					task.cancel(iData.value65)
				end

				task.spawn(function()
					while iData.value63 do
						task.wait(0.1)
						pcall(function()
							doAutoTPDown(false)
						end)
					end
				end)
			else
				iData.value154()
			end

			iData.value168()
		end)

		addInputRow(Movement, "TP Height", iData.value64, 7, function(argument)
			if argument >= 0 and argument <= 500 then
				iData.value64 = argument
			end

			iData.value168()
		end)

		local _, _ = addToggleRow(Movement, "Infinite Jump", iData.value19, 8, nil, function(value19Condition)
			iData.value19 = value19Condition

			if value19Condition then
				startHoldInfJump()
			else
				stopHoldInfJump()
			end

			iData.value168()
		end)
	end)();
	(function()
		local Visual = vData.contents.Visual

		addSectLbl(Visual, "THEME COLOR", 0)

		local parent = Instance.new("Frame")

		parent.Size = UDim2.new(1, -8, 0, 40)
		parent.BackgroundTransparency = 1
		parent.LayoutOrder = 1
		parent.Parent = Visual

		local UIListLayout = Instance.new("UIListLayout", parent)

		UIListLayout.FillDirection = Enum.FillDirection.Horizontal
		UIListLayout.Padding = UDim.new(0, 6)
		UIListLayout.VerticalAlignment = Enum.VerticalAlignment.Center

		local updateInstancePropertiesData = {}

		local function updateInstanceProperties()
			for k, item in pairs(updateInstancePropertiesData) do
				local updateInstancePropertiesFlag = k == iData.value43

				item.BackgroundColor3 = iData.value42[k] or Color3.fromRGB(255, 255, 255)

				local UIStroke = item:FindFirstChildOfClass("UIStroke")

				if UIStroke then
					UIStroke.Thickness = not updateInstancePropertiesFlag and 1 or 2.5
					UIStroke.Color = updateInstancePropertiesFlag and Color3.fromRGB(255, 255, 255)
						or Color3.fromRGB(60, 60, 70)
				end
			end

			pcall(function()
				if hubData.voidTitle then
					if hubData.voidTitle:IsA("ImageLabel") or hubData.voidTitle:IsA("ImageButton") then
						hubData.voidTitle.ImageColor3 = iData.value44()

						return
					end

					hubData.voidTitle.TextColor3 = iData.value44()
				end
			end)
		end

		for _, item in ipairs({
			"WHITE",
			"PURPLE",
			"BLUE",
			"RED",
			"PINK",
			"YELLOW",
			"GREY",
			"FOREST",
		}) do
			local secondaryV = item
			local TextButton = Instance.new("TextButton")

			TextButton.Size = UDim2.new(0, 30, 0, 30)
			TextButton.BackgroundColor3 = iData.value42[secondaryV]
			TextButton.BorderSizePixel = 0
			TextButton.Text = ""
			TextButton.AutoButtonColor = false
			TextButton.Parent = parent
			guiCorner(TextButton, 8)
			guiStroke(TextButton, Color3.fromRGB(60, 60, 70), 1)
			updateInstancePropertiesData[secondaryV] = TextButton
			TextButton.MouseButton1Click:Connect(function()
				iData.value46()
				updateInstanceProperties()
				iData.value168()
			end)
		end

		updateInstanceProperties()
		task.defer(function()
			pcall(iData.value46)
		end)
		addSectLbl(Visual, "CHARTER", 2)
		addToggleRow(Visual, "Headless", iData.value88, 1, nil, function(argument)
			iData.value88 = argument == true
			pcall(function()
				applyHeadlessToChar(iData.value11.Character, iData.value88)
			end)
			iData.value168()
		end)
		addToggleRow(Visual, "Korblox", iData.value89, 2, nil, function(argument)
			iData.value89 = argument == true
			pcall(function()
				applyKorbloxToChar(iData.value11.Character, iData.value89)
			end)
			iData.value168()
		end)
		addSectLbl(Visual, "VISUAL", 0)
		addToggleRow(Visual, "Speed ESP (Speed+Line+Chams)", iData.value108, 1, nil, function(condition)
			if condition then
				startESP()
			else
				stopESP()
			end

			iData.value168()
		end)
		addToggleRow(Visual, "ESP Avatars", iData.value109, 2, nil, function(value109Condition)
			iData.value109 = value109Condition == true

			if not iData.value108 then
				iData.value109 = value109Condition

				if espRefreshAvatars then
					espRefreshAvatars()
				end

				for _, item in pairs(iData.value110.labels) do
					local capturedV = item

					if capturedV.avatarBillboard then
						pcall(function()
							capturedV.avatarBillboard:Destroy()
						end)
						capturedV.avatarBillboard = nil
					end
				end
			else
				if espRefreshAvatars then
					espRefreshAvatars()
				end

				if value109Condition then
					for _, player in ipairs(iData.value1:GetPlayers()) do
						if
							player ~= iData.value11
							and (not iData.value110.labels[player] or not iData.value110.labels[player].avatarBillboard)
						then
							espMakeLabel(player)
						end
					end
				else
					for _, item in pairs(iData.value110.labels) do
						if item.avatarBillboard then
							item.avatarBillboard.Enabled = false
						end
					end
				end
			end

			iData.value168()
		end)
		addToggleRow(Visual, "Anti Lag", iData.value57, 4, nil, function(condition)
			if condition then
				updateDescendantAddedConnection()
			else
				iData.value58 = false
				iData.value57 = false

				if iData.value59 then
					iData.value59:Disconnect()
					iData.value59 = nil
				end

				pcall(function()
					if iData.value158 then
						iData.value5.Brightness = iData.value158
					end

					if iData.value159 then
						iData.value5.ClockTime = iData.value159
					end

					if iData.value160 then
						iData.value5.OutdoorAmbient = iData.value160
					end

					iData.value5.ExposureCompensation = 0
				end)
			end

			iData.value168()
		end)
		addToggleRow(Visual, "Stretch Rez", iData.value60, 5, nil, function(condition)
			if condition then
				alternateUpdateInstanceProperties()
			else
				iData.value60 = false
				pcall(function()
					iData.value4:UnbindFromRenderStep(iData.value156)
				end)
			end

			iData.value168()
		end)
		addToggleRow(Visual, "Ragdoll GUI", iData.value101, 6, nil, function(argument)
			iData.value101 = argument
			iData.value168()
		end)
		addSectLbl(Visual, "ANIMATION PACK", 7)

		local capturedI = 1

		for i, item in ipairs(iData.value95) do
			if item == iData.value87 then
				capturedI = i

				break
			end
		end

		local frame = Instance.new("Frame")

		frame.Size = UDim2.new(1, 0, 0, 38)
		frame.BackgroundColor3 = textData.row
		frame.BackgroundTransparency = 0.5
		frame.BorderSizePixel = 0
		frame.LayoutOrder = 8
		frame.Parent = Visual
		guiCorner(frame, 10)
		guiStroke(frame, textData.divider, 1)

		local TextLabel = Instance.new("TextLabel", frame)

		TextLabel.Size = UDim2.new(0.42, 0, 0, 16)
		TextLabel.Position = UDim2.new(0, 12, 0, 6)
		TextLabel.BackgroundTransparency = 1
		TextLabel.Text = "Anim Pack"
		TextLabel.TextColor3 = textData.text
		TextLabel.TextSize = 11
		TextLabel.Font = Enum.Font.GothamBold
		TextLabel.TextXAlignment = Enum.TextXAlignment.Left

		local valueLabel = Instance.new("TextLabel", frame)

		valueLabel.Size = UDim2.new(0, 90, 0, 16)
		valueLabel.Position = UDim2.new(1, -150, 0, 6)
		valueLabel.BackgroundTransparency = 1
		valueLabel.Text = iData.value87
		valueLabel.TextColor3 = textData.textDim
		valueLabel.TextSize = 9
		valueLabel.Font = Enum.Font.GothamBold
		valueLabel.TextXAlignment = Enum.TextXAlignment.Right

		local TextButton = Instance.new("TextButton", frame)

		TextButton.Size = UDim2.new(0, 48, 0, 22)
		TextButton.Position = UDim2.new(1, -56, 0.5, -11)
		TextButton.BackgroundColor3 = textData.blue
		TextButton.BackgroundTransparency = 0.5
		TextButton.BorderSizePixel = 0
		TextButton.Text = "Next"
		TextButton.TextColor3 = textData.white
		TextButton.TextSize = 9
		TextButton.Font = Enum.Font.GothamBold
		guiCorner(TextButton, 5)
		TextButton.MouseButton1Click:Connect(function()
			capturedI = capturedI % #iData.value95 + 1
			iData.value87 = iData.value95[capturedI]
			valueLabel.Text = iData.value87
			iData.value86 = iData.value87 ~= "OFF"
			applyAnimPack(iData.value87)
			iData.value168()
		end)
		addToggleRow(Visual, "Anim Pack Enabled", iData.value86, 9, nil, function(value86Condition)
			iData.value86 = value86Condition

			if value86Condition then
				applyAnimPack(iData.value87)
			else
				iData.value163(iData.value11.Character)
			end

			iData.value168()
		end)
		addSectLbl(Visual, "SKY THEME", 8)

		local sum = 1

		for i, item in ipairs(iData.value10) do
			if item == iData.value8 then
				sum = i

				break
			end
		end

		local secondaryParent = Instance.new("Frame")

		secondaryParent.Size = UDim2.new(1, 0, 0, 38)
		secondaryParent.BackgroundColor3 = textData.row
		secondaryParent.BackgroundTransparency = 0.5
		secondaryParent.BorderSizePixel = 0
		secondaryParent.LayoutOrder = 9
		secondaryParent.Parent = Visual
		guiCorner(secondaryParent, 10)
		guiStroke(secondaryParent, textData.divider, 1)

		local textLabel = Instance.new("TextLabel", secondaryParent)

		textLabel.Size = UDim2.new(0.45, 0, 0, 16)
		textLabel.Position = UDim2.new(0, 12, 0, 6)
		textLabel.BackgroundTransparency = 1
		textLabel.Text = "Sky Theme"
		textLabel.TextColor3 = textData.text
		textLabel.TextSize = 11
		textLabel.Font = Enum.Font.GothamBold
		textLabel.TextXAlignment = Enum.TextXAlignment.Left

		local secondaryValueLabel = Instance.new("TextLabel", secondaryParent)

		secondaryValueLabel.Size = UDim2.new(0, 80, 0, 16)
		secondaryValueLabel.Position = UDim2.new(1, -130, 0, 6)
		secondaryValueLabel.BackgroundTransparency = 1
		secondaryValueLabel.Text = iData.value8
		secondaryValueLabel.TextColor3 = textData.textDim
		secondaryValueLabel.TextSize = 9
		secondaryValueLabel.Font = Enum.Font.GothamBold
		secondaryValueLabel.TextXAlignment = Enum.TextXAlignment.Right

		local nextButton = Instance.new("TextButton", secondaryParent)

		nextButton.Size = UDim2.new(0, 44, 0, 22)
		nextButton.Position = UDim2.new(1, -52, 0.5, -11)
		nextButton.BackgroundColor3 = textData.blue
		nextButton.BackgroundTransparency = 0.5
		nextButton.BorderSizePixel = 0
		nextButton.Text = "Next"
		nextButton.TextColor3 = textData.white
		nextButton.TextSize = 9
		nextButton.Font = Enum.Font.GothamBold
		guiCorner(nextButton, 5)
		nextButton.MouseButton1Click:Connect(function()
			sum = sum % #iData.value10 + 1
			iData.value8 = iData.value10[sum]
			secondaryValueLabel.Text = iData.value8
			CandyApplyCustomSky(iData.value8)
			iData.value168()
		end)

		local textButton = Instance.new("TextButton", secondaryParent)

		textButton.Size = UDim2.new(1, 0, 1, 0)
		textButton.BackgroundTransparency = 1
		textButton.Text = ""
		textButton.ZIndex = 0
		textButton.MouseEnter:Connect(function()
			tw(secondaryParent, {
				BackgroundTransparency = 0.3,
			})
		end)
		textButton.MouseLeave:Connect(function()
			tw(secondaryParent, {
				BackgroundTransparency = 0.5,
			})
		end)
		addSectLbl(Visual, "FOV", 10)

		local alternateParent = Instance.new("Frame")

		alternateParent.Size = UDim2.new(1, 0, 0, 38)
		alternateParent.BackgroundColor3 = textData.row
		alternateParent.BackgroundTransparency = 0.5
		alternateParent.BorderSizePixel = 0
		alternateParent.LayoutOrder = 11
		alternateParent.Parent = Visual
		guiCorner(alternateParent, 10)
		guiStroke(alternateParent, textData.divider, 1)

		local secondaryTextLabel = Instance.new("TextLabel", alternateParent)

		secondaryTextLabel.Size = UDim2.new(0.5, 0, 0, 16)
		secondaryTextLabel.Position = UDim2.new(0, 12, 0, 6)
		secondaryTextLabel.BackgroundTransparency = 1
		secondaryTextLabel.Text = "FOV"
		secondaryTextLabel.TextColor3 = textData.text
		secondaryTextLabel.TextSize = 11
		secondaryTextLabel.Font = Enum.Font.GothamBold
		secondaryTextLabel.TextXAlignment = Enum.TextXAlignment.Left

		local secondaryTextButton = Instance.new("TextButton", alternateParent)

		secondaryTextButton.Size = UDim2.new(0, 52, 0, 22)
		secondaryTextButton.Position = UDim2.new(1, -60, 0.5, -11)
		secondaryTextButton.BackgroundColor3 = textData.blue
		secondaryTextButton.BackgroundTransparency = 0.5
		secondaryTextButton.BorderSizePixel = 0
		secondaryTextButton.Text = tostring(iData.value80)
		secondaryTextButton.TextColor3 = textData.white
		secondaryTextButton.TextSize = 11
		secondaryTextButton.Font = Enum.Font.GothamBold
		guiCorner(secondaryTextButton, 5)
		secondaryTextButton.MouseButton1Click:Connect(function()
			iData.value82 = iData.value82 % #iData.value81 + 1
			iData.value80 = iData.value81[iData.value82]
			secondaryTextButton.Text = tostring(iData.value80)
			applyFOV()
			iData.value168()
		end)

		local alternateTextButton = Instance.new("TextButton", alternateParent)

		alternateTextButton.Size = UDim2.new(1, 0, 1, 0)
		alternateTextButton.BackgroundTransparency = 1
		alternateTextButton.Text = ""
		alternateTextButton.ZIndex = 0
		alternateTextButton.MouseEnter:Connect(function()
			tw(alternateParent, {
				BackgroundTransparency = 0.3,
			})
		end)
		alternateTextButton.MouseLeave:Connect(function()
			tw(alternateParent, {
				BackgroundTransparency = 0.5,
			})
		end)
		addSectLbl(Visual, "UI SCALE", 17)

		local function createFrame(
			secondaryParent,
			createFrameText,
			layoutOrder,
			textCallback,
			frameCallback,
			callback,
			clampedValueNumber,
			number,
			secondaryCreateFrameNumber
		)
			local parent = Instance.new("Frame")

			parent.Size = UDim2.new(1, 0, 0, 38)
			parent.BackgroundColor3 = textData.row
			parent.BackgroundTransparency = 0.5
			parent.BorderSizePixel = 0
			parent.LayoutOrder = layoutOrder
			parent.Parent = secondaryParent
			guiCorner(parent, 10)
			guiStroke(parent, textData.divider, 1)

			local textLabel = Instance.new("TextLabel", parent)

			textLabel.Size = UDim2.new(0.42, 0, 0, 16)
			textLabel.Position = UDim2.new(0, 12, 0, 6)
			textLabel.BackgroundTransparency = 1
			textLabel.Text = createFrameText
			textLabel.TextColor3 = textData.text
			textLabel.TextSize = 11
			textLabel.Font = Enum.Font.GothamBold
			textLabel.TextXAlignment = Enum.TextXAlignment.Left

			local textButton = Instance.new("TextButton", parent)

			textButton.Size = UDim2.new(0, 28, 0, 22)
			textButton.Position = UDim2.new(1, -100, 0.5, -11)
			textButton.BackgroundColor3 = textData.blue
			textButton.BackgroundTransparency = 0.5
			textButton.BorderSizePixel = 0
			textButton.Text = "-"
			textButton.TextColor3 = textData.white
			textButton.TextSize = 14
			textButton.Font = Enum.Font.GothamBold
			guiCorner(textButton, 5)

			local valueLabel = Instance.new("TextLabel", parent)

			valueLabel.Size = UDim2.new(0, 40, 0, 22)
			valueLabel.Position = UDim2.new(1, -70, 0.5, -11)
			valueLabel.BackgroundTransparency = 1
			valueLabel.Text = callback(textCallback())
			valueLabel.TextColor3 = textData.text
			valueLabel.TextSize = 11
			valueLabel.Font = Enum.Font.GothamBold
			valueLabel.TextXAlignment = Enum.TextXAlignment.Center

			local secondaryTextButton = Instance.new("TextButton", parent)

			secondaryTextButton.Size = UDim2.new(0, 28, 0, 22)
			secondaryTextButton.Position = UDim2.new(1, -28, 0.5, -11)
			secondaryTextButton.BackgroundColor3 = textData.blue
			secondaryTextButton.BackgroundTransparency = 0.5
			secondaryTextButton.BorderSizePixel = 0
			secondaryTextButton.Text = "+"
			secondaryTextButton.TextColor3 = textData.white
			secondaryTextButton.TextSize = 14
			secondaryTextButton.Font = Enum.Font.GothamBold
			guiCorner(secondaryTextButton, 5)
			textButton.MouseButton1Click:Connect(function()
				local createFrameNumber = -clampedValueNumber
				local clampedValue = math.clamp(textCallback() + createFrameNumber, number, secondaryCreateFrameNumber)

				frameCallback(clampedValue)
				valueLabel.Text = callback(clampedValue)
				iData.value168()
			end)
			secondaryTextButton.MouseButton1Click:Connect(function()
				local createFrameNumber = clampedValueNumber
				local clampedValue = math.clamp(textCallback() + createFrameNumber, number, secondaryCreateFrameNumber)

				frameCallback(clampedValue)
				valueLabel.Text = callback(clampedValue)
				iData.value168()
			end)

			local alternateTextButton = Instance.new("TextButton", parent)

			alternateTextButton.Size = UDim2.new(1, 0, 1, 0)
			alternateTextButton.BackgroundTransparency = 1
			alternateTextButton.Text = ""
			alternateTextButton.ZIndex = 0
			alternateTextButton.MouseEnter:Connect(function()
				tw(parent, {
					BackgroundTransparency = 0.3,
				})
			end)
			alternateTextButton.MouseLeave:Connect(function()
				tw(parent, {
					BackgroundTransparency = 0.5,
				})
			end)

			return valueLabel
		end

		local option = hubData.outerScale and hubData.outerScale.Scale or 0.7

		createFrame(Visual, "UI Scale", 18, function()
			return option
		end, function(scale)
			if hubData.outerScale then
				hubData.outerScale.Scale = scale
			end
		end, function(argument)
			return string.format("%.2f", argument)
		end, 0.05, 0.5, 1.3)
		createFrame(Visual, "Mobile Buttons Size", 19, function()
			return tonumber(iData.value73) or 80
		end, function(number)
			math.floor(number + 0.5)

			if iData.value67 and buildMobileButtons then
				buildMobileButtons()
			end
		end, function(number)
			return (tostring((math.floor(number + 0.5))))
		end, 10, 50, 140)
		addToggleRow(Visual, "Show Mobile Buttons", iData.value67, 20, nil, function(value67Condition)
			iData.value67 = value67Condition

			if value67Condition then
				if buildMobileButtons then
					buildMobileButtons()
				end
			elseif destroyMobileButtons then
				destroyMobileButtons()
			end

			iData.value168()
		end)
		addToggleRow(Visual, "Show Discord Link", iData.value69, 21, nil, function(value69Condition)
			iData.value69 = value69Condition

			if value69Condition then
				if buildDiscordLink then
					buildDiscordLink()
				end
			elseif destroyDiscordLink then
				destroyDiscordLink()
			end

			iData.value168()
		end)
		addToggleRow(Visual, "Show Circle Logo", iData.value71, 22, nil, function(argument)
			iData.value71 = argument == true

			if iData.value72 then
				iData.value72.Visible = iData.value71
			elseif hubData.logoCircle then
				hubData.logoCircle.Visible = iData.value71
			end

			pcall(function()
				local headerFrame = hubData.inner and hubData.inner:FindFirstChild("HeaderFrame", true)

				if not headerFrame and hubData.chromeGroup then
					headerFrame = hubData.chromeGroup:FindFirstChild("HeaderFrame", true)
				end

				if headerFrame then
					if not headerFrame:FindFirstChild("TextLabel") then
						headerFrame:FindFirstChildWhichIsA("TextLabel")
					end

					for _, child in ipairs(headerFrame:GetChildren()) do
						if child:IsA("TextLabel") and child.Text == "TOXIC DUELS" then
							child.Position = iData.value71 and UDim2.new(0, 60, 0, 8) or UDim2.new(0, 14, 0, 8)
						elseif child:IsA("TextLabel") and child.Text:find("PREMIUM") then
							child.Position = iData.value71 and UDim2.new(0, 60, 0, 32) or UDim2.new(0, 14, 0, 32)
						end
					end
				end
			end)
			iData.value168()
		end)
		addToggleRow(Visual, "Lock All (freeze everything)", iData.value102, 16, nil, function(argument)
			iData.value102 = argument
			iData.value168()
		end)
		addSectLbl(Visual, "RESET", 14)

		local additionalParent = Instance.new("Frame")

		additionalParent.Size = UDim2.new(1, 0, 0, 38)
		additionalParent.BackgroundColor3 = textData.row
		additionalParent.BackgroundTransparency = 0.5
		additionalParent.BorderSizePixel = 0
		additionalParent.LayoutOrder = 15
		additionalParent.Parent = Visual
		guiCorner(additionalParent, 10)
		guiStroke(additionalParent, textData.divider, 1)

		local alternateTextLabel = Instance.new("TextLabel", additionalParent)

		alternateTextLabel.Size = UDim2.new(0.55, 0, 0, 16)
		alternateTextLabel.Position = UDim2.new(0, 12, 0, 6)
		alternateTextLabel.BackgroundTransparency = 1
		alternateTextLabel.Text = "Reset Settings"
		alternateTextLabel.TextColor3 = textData.text
		alternateTextLabel.TextSize = 11
		alternateTextLabel.Font = Enum.Font.GothamBold
		alternateTextLabel.TextXAlignment = Enum.TextXAlignment.Left

		local resetButton = Instance.new("TextButton", additionalParent)

		resetButton.Size = UDim2.new(0, 52, 0, 22)
		resetButton.Position = UDim2.new(1, -60, 0.5, -11)
		resetButton.BackgroundColor3 = Color3.fromRGB(150, 30, 40)
		resetButton.BackgroundTransparency = 0.2
		resetButton.BorderSizePixel = 0
		resetButton.Text = "RESET"
		resetButton.TextColor3 = textData.white
		resetButton.TextSize = 9
		resetButton.Font = Enum.Font.GothamBold
		guiCorner(resetButton, 5)
		resetButton.MouseButton1Click:Connect(function()
			resetAllSettings()
		end)

		local additionalTextButton = Instance.new("TextButton", additionalParent)

		additionalTextButton.Size = UDim2.new(1, 0, 1, 0)
		additionalTextButton.BackgroundTransparency = 1
		additionalTextButton.Text = ""
		additionalTextButton.ZIndex = 0
		additionalTextButton.MouseEnter:Connect(function()
			tw(additionalParent, {
				BackgroundTransparency = 0.3,
			})
		end)
		additionalTextButton.MouseLeave:Connect(function()
			tw(additionalParent, {
				BackgroundTransparency = 0.5,
			})
		end)
	end)();
	(function()
		local Background = vData.contents.Background

		if not Background then
			return
		end

		addSectLbl(Background, "BACKGROUND LIST", 0)

		local parent = Instance.new("Frame")

		parent.Size = UDim2.new(1, 0, 0, 420)
		parent.BackgroundColor3 = textData.row
		parent.BackgroundTransparency = 0.55
		parent.BorderSizePixel = 0
		parent.LayoutOrder = 1
		parent.Parent = Background
		guiCorner(parent, 12)
		guiStroke(parent, textData.divider, 1)

		local TextLabel = Instance.new("TextLabel", parent)

		TextLabel.Size = UDim2.new(1, -16, 0, 22)
		TextLabel.Position = UDim2.new(0, 8, 0, 6)
		TextLabel.BackgroundTransparency = 1
		TextLabel.Text = "Background List  \194\183  tap a preview"
		TextLabel.TextColor3 = textData.textDim
		TextLabel.TextSize = 11
		TextLabel.Font = Enum.Font.GothamBold
		TextLabel.TextXAlignment = Enum.TextXAlignment.Left

		local ScrollingFrame = Instance.new("ScrollingFrame", parent)

		ScrollingFrame.Name = "BackgroundList"
		ScrollingFrame.Size = UDim2.new(1, -12, 1, -36)
		ScrollingFrame.Position = UDim2.new(0, 6, 0, 30)
		ScrollingFrame.BackgroundTransparency = 1
		ScrollingFrame.BorderSizePixel = 0
		ScrollingFrame.ScrollBarThickness = 6
		ScrollingFrame.ScrollBarImageColor3 = textData.blue
		ScrollingFrame.ScrollingDirection = Enum.ScrollingDirection.Y
		ScrollingFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
		ScrollingFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
		ScrollingFrame.ElasticBehavior = Enum.ElasticBehavior.Always
		ScrollingFrame.ZIndex = 5

		local UIListLayout = Instance.new("UIListLayout", ScrollingFrame)

		UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
		UIListLayout.Padding = UDim.new(0, 10)

		local UIPadding = Instance.new("UIPadding", ScrollingFrame)

		UIPadding.PaddingTop = UDim.new(0, 4)
		UIPadding.PaddingBottom = UDim.new(0, 16)
		UIPadding.PaddingLeft = UDim.new(0, 4)
		UIPadding.PaddingRight = UDim.new(0, 4)

		local updateInstancePropertiesData = {}

		local function updateInstanceProperties(updateInstancePropertiesOption)
			for index, item in ipairs(updateInstancePropertiesData) do
				if item.stroke then
					local stroke = item.stroke
					local updateInstancePropertiesFlag = index == updateInstancePropertiesOption

					if updateInstancePropertiesFlag then
						updateInstancePropertiesFlag = Color3.fromRGB(255, 255, 255)
					end

					stroke.Color = updateInstancePropertiesFlag or Color3.fromRGB(60, 60, 70)
					item.stroke.Thickness = index ~= updateInstancePropertiesOption and 1 or 2
				end

				if item.badge then
					item.badge.Visible = index == updateInstancePropertiesOption
				end
			end
			if updateInstancePropertiesData[0] then
				updateInstancePropertiesData[0].stroke.Color = updateInstancePropertiesOption == 0
						and Color3.fromRGB(255, 255, 255)
					or Color3.fromRGB(60, 60, 70)

				if updateInstancePropertiesData[0].badge then
					updateInstancePropertiesData[0].badge.Visible = updateInstancePropertiesOption == 0
				end
			end
		end

		local TextButton = Instance.new("TextButton", ScrollingFrame)

		TextButton.Size = UDim2.new(1, -8, 0, 56)
		TextButton.BackgroundColor3 = Color3.fromRGB(18, 18, 22)
		TextButton.BorderSizePixel = 0
		TextButton.AutoButtonColor = false
		TextButton.Text = ""
		TextButton.LayoutOrder = 0
		TextButton.ZIndex = 6
		guiCorner(TextButton, 10)

		local stroke = guiStroke(TextButton, Color3.fromRGB(60, 60, 70), 1)
		local textLabel = Instance.new("TextLabel", TextButton)

		textLabel.Size = UDim2.new(1, -20, 1, 0)
		textLabel.Position = UDim2.new(0, 14, 0, 0)
		textLabel.BackgroundTransparency = 1
		textLabel.Text = "OFF  \194\183  No background"
		textLabel.TextColor3 = textData.text
		textLabel.TextSize = 13
		textLabel.Font = Enum.Font.GothamBold
		textLabel.TextXAlignment = Enum.TextXAlignment.Left
		textLabel.ZIndex = 7

		local secondaryTextLabel = Instance.new("TextLabel", TextButton)

		secondaryTextLabel.Size = UDim2.new(0, 64, 0, 20)
		secondaryTextLabel.Position = UDim2.new(1, -74, 0.5, -10)
		secondaryTextLabel.BackgroundColor3 = Color3.fromRGB(40, 40, 48)
		secondaryTextLabel.Text = "ACTIVE"
		secondaryTextLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
		secondaryTextLabel.TextSize = 9
		secondaryTextLabel.Font = Enum.Font.GothamBold
		secondaryTextLabel.ZIndex = 8
		secondaryTextLabel.Visible = iData.value112 == 0
		guiCorner(secondaryTextLabel, 6)
		updateInstancePropertiesData[0] = {
			stroke = stroke,
			badge = secondaryTextLabel,
		}
		TextButton.MouseButton1Click:Connect(function()
			applyBackgroundImage(0)
			updateInstanceProperties(0)
			iData.value168()
		end)

		for i, item in ipairs(iData.value114) do
			local capturedV = item
			local ImageButton = Instance.new("ImageButton", ScrollingFrame)

			ImageButton.Size = UDim2.new(1, -8, 0, 130)
			ImageButton.BackgroundColor3 = Color3.fromRGB(12, 12, 16)
			ImageButton.BackgroundTransparency = 0.05
			ImageButton.Image = ""
			ImageButton.ScaleType = Enum.ScaleType.Crop
			ImageButton.BorderSizePixel = 0
			ImageButton.AutoButtonColor = false
			ImageButton.LayoutOrder = i
			ImageButton.ZIndex = 6
			guiCorner(ImageButton, 12)

			local stroke = guiStroke(ImageButton, Color3.fromRGB(60, 60, 70), 1)
			local frame = Instance.new("Frame", ImageButton)

			frame.Size = UDim2.new(1, 0, 0, 32)
			frame.Position = UDim2.new(0, 0, 1, -32)
			frame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
			frame.BackgroundTransparency = 0.35
			frame.BorderSizePixel = 0
			frame.ZIndex = 7
			guiCorner(frame, 12)

			local textLabel = Instance.new("TextLabel", ImageButton)

			textLabel.Size = UDim2.new(1, -90, 0, 22)
			textLabel.Position = UDim2.new(0, 12, 1, -28)
			textLabel.BackgroundTransparency = 1
			textLabel.Text = "Background " .. tostring(i)
			textLabel.TextColor3 = Color3.fromRGB(240, 240, 245)
			textLabel.TextSize = 12
			textLabel.Font = Enum.Font.GothamBold
			textLabel.TextXAlignment = Enum.TextXAlignment.Left
			textLabel.ZIndex = 8

			local secondaryTextLabel = Instance.new("TextLabel", ImageButton)

			secondaryTextLabel.Size = UDim2.new(0, 64, 0, 20)
			secondaryTextLabel.Position = UDim2.new(1, -74, 1, -26)
			secondaryTextLabel.BackgroundColor3 = Color3.fromRGB(40, 40, 48)
			secondaryTextLabel.Text = "ACTIVE"
			secondaryTextLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
			secondaryTextLabel.TextSize = 9
			secondaryTextLabel.Font = Enum.Font.GothamBold
			secondaryTextLabel.ZIndex = 8
			secondaryTextLabel.Visible = i == iData.value112
			guiCorner(secondaryTextLabel, 6)
			updateInstancePropertiesData[i] = {
				stroke = stroke,
				badge = secondaryTextLabel,
				img = ImageButton,
			}
			task.spawn(function()
				for index = 1, 25 do
					local image = iData.value115[i]

					if image and image ~= "" then
						ImageButton.Image = image

						break
					end

					if index == 3 then
						local image = iData.value117(capturedV)

						if image ~= "" then
							iData.value115[i] = image
							ImageButton.Image = image

							break
						end
					end

					task.wait(0.12)
				end

				if ImageButton.Image == "" then
					ImageButton.Image = capturedV.url
				end
			end)
			ImageButton.MouseButton1Click:Connect(function()
				applyBackgroundImage(i)
				updateInstanceProperties(i)
				iData.value168()
			end)
		end

		task.defer(function()
			local option = iData.value112 or 0

			updateInstanceProperties(option)

			if iData.value112 and iData.value112 > 0 then
				applyBackgroundImage(iData.value112)
			end
		end)
	end)();
	(function()
		local Keybinds = vData.contents.Keybinds
		local ButtonA = Enum.KeyCode.ButtonA
		local ButtonB = Enum.KeyCode.ButtonB
		local ButtonX = Enum.KeyCode.ButtonX
		local ButtonY = Enum.KeyCode.ButtonY
		local result = Enum.KeyCode.ButtonL1
		local secondaryResult = Enum.KeyCode.ButtonR1
		local alternateResult = Enum.KeyCode.ButtonL2
		local additionalResult = Enum.KeyCode.ButtonR2
		local fallbackResult = Enum.KeyCode.ButtonL3
		local nestedResult = Enum.KeyCode.ButtonR3
		local ButtonStart = Enum.KeyCode.ButtonStart
		local ButtonSelect = Enum.KeyCode.ButtonSelect
		local DPadUp = Enum.KeyCode.DPadUp
		local DPadDown = Enum.KeyCode.DPadDown
		local DPadLeft = Enum.KeyCode.DPadLeft
		local DPadRight = Enum.KeyCode.DPadRight
		local createFrameData = {
			[ButtonA] = true,
			[ButtonB] = true,
			[ButtonX] = true,
			[ButtonY] = true,
			[result] = true,
			[secondaryResult] = true,
			[alternateResult] = true,
			[additionalResult] = true,
			[fallbackResult] = true,
			[nestedResult] = true,
			[ButtonStart] = true,
			[ButtonSelect] = true,
			[DPadUp] = true,
			[DPadDown] = true,
			[DPadLeft] = true,
			[DPadRight] = true,
		}

		local function concat(concatFlag)
			if not concatFlag then
				return "..."
			end

			local gpNames = {}

			if concatFlag.kb then
				table.insert(gpNames, concatFlag.kb.Name)
			end

			if concatFlag.gp then
				table.insert(gpNames, concatFlag.gp.Name)
			end

			if #gpNames == 0 then
				return "..."
			end

			return table.concat(gpNames, " / ")
		end
		local function createFrame(secondaryParent, textLabel, concatFlag, layoutOrderFlag)
			local parent = Instance.new("Frame", secondaryParent)
			parent.Size = UDim2.new(1, 0, 0, 38)
			parent.BackgroundColor3 = textData.row
			parent.BackgroundTransparency = 0.5
			parent.BorderSizePixel = 0
			parent.LayoutOrder = layoutOrderFlag or 0
			guiCorner(parent, 10)
			guiStroke(parent, textData.divider, 1)
			local TextLabel = Instance.new("TextLabel", parent)
			TextLabel.Size = UDim2.new(1, -110, 1, 0)
			TextLabel.Position = UDim2.new(0, 12, 0, 0)
			TextLabel.BackgroundTransparency = 1
			TextLabel.Text = textLabel
			TextLabel.TextColor3 = textData.text
			TextLabel.TextSize = 11
			TextLabel.Font = Enum.Font.GothamBold
			TextLabel.TextXAlignment = Enum.TextXAlignment.Left
			local TextButton = Instance.new("TextButton", parent)
			TextButton.Size = UDim2.new(0, 96, 0, 24)
			TextButton.Position = UDim2.new(1, -104, 0.5, -12)
			TextButton.BackgroundColor3 = textData.input or (textData.blueDark or Color3.fromRGB(16, 16, 16))
			TextButton.BorderSizePixel = 0
			TextButton.AutoButtonColor = false
			TextButton.ZIndex = 5
			TextButton.Text = concat(concatFlag)
			TextButton.TextColor3 = textData.white
			TextButton.TextSize = 10
			TextButton.Font = Enum.Font.GothamMedium
			TextButton.TextTruncate = Enum.TextTruncate.AtEnd
			guiCorner(TextButton, 6)
			guiStroke(TextButton, textData.divider, 1)
			local createFrameFlag = false
			local connection
			local createFrameNumber = 0
			TextButton.MouseButton1Click:Connect(function()
				if createFrameFlag then
					createFrameFlag = false

					if connection then
						connection:Disconnect()
						connection = nil
					end

					TextButton.Text = concat(concatFlag)
					TextButton.TextColor3 = textData.white

					return
				end

				createFrameFlag = true
				createFrameNumber = tick()
				TextButton.Text = "Press key..."
				TextButton.TextColor3 = Color3.fromRGB(255, 200, 220)
				connection = iData.value3.InputBegan:Connect(function(input)
					if not createFrameFlag then
						return
					end

					if input.KeyCode == Enum.KeyCode.Escape then
						if connection then
							connection:Disconnect()
							connection = nil
						end

						TextButton.Text = concat(concatFlag)
						TextButton.TextColor3 = textData.white

						return
					end

					local createFrameCondition = input
						and (input.UserInputType and tostring(input.UserInputType.Name):match("^Gamepad") ~= nil)

					if createFrameCondition and tick() - createFrameNumber < 0.15 then
						return
					end

					if
						not input
						or input.KeyCode == Enum.KeyCode.Unknown
						or input.UserInputType ~= Enum.UserInputType.Keyboard
							and (not input or (not input.UserInputType or tostring(input.UserInputType.Name):match(
								"^Gamepad"
							) == nil) or createFrameData[input.KeyCode] ~= true)
					then
						return
					end

					if createFrameCondition then
						concatFlag.gp = input.KeyCode
					else
						concatFlag.kb = input.KeyCode
					end

					if textLabel == "Hide GUI" then
						tpBatData.guiHide = concatFlag.kb or tpBatData.guiHide
					end

					if textLabel == "Carry Speed" then
						tpBatData.carryMode = concatFlag.kb or tpBatData.carryMode
					end

					if textLabel == "Lagger Mode" then
						tpBatData.laggerToggle = concatFlag.kb or tpBatData.laggerToggle
					end

					if textLabel == "Lagger Carry" then
						tpBatData.laggerCarry = concatFlag.kb or tpBatData.laggerCarry
					end

					if textLabel == "Auto Bat" then
						tpBatData.circle = concatFlag.kb or tpBatData.circle
					end

					if textLabel == "TP Bat" then
						tpBatData.tpBat = concatFlag.kb or tpBatData.tpBat
					end

					if textLabel == "Auto Left" then
						tpBatData.autoLeft = concatFlag.kb or tpBatData.autoLeft
					end

					if textLabel == "Auto Right" then
						tpBatData.autoRight = concatFlag.kb or tpBatData.autoRight
					end

					if textLabel == "Drop Brainrot" then
						tpBatData.dropBrainrot = concatFlag.kb or tpBatData.dropBrainrot
					end

					if textLabel == "TP Down" then
						tpBatData.tpDown = concatFlag.kb or tpBatData.tpDown
					end

					if textLabel == "BAT V2" then
						tpBatData.batV2 = concatFlag.kb or tpBatData.batV2
					end

					if connection then
						connection:Disconnect()
						connection = nil
					end

					TextButton.Text = concat(concatFlag)
					TextButton.TextColor3 = textData.white
					pcall(iData.value168)
				end)
			end)
			local textButton = Instance.new("TextButton", parent)
			textButton.Size = UDim2.new(1, 0, 1, 0)
			textButton.BackgroundTransparency = 1
			textButton.Text = ""
			textButton.ZIndex = 0
			textButton.MouseEnter:Connect(function()
				tw(parent, {
					BackgroundTransparency = 0.3,
				})
			end)
			textButton.MouseLeave:Connect(function()
				tw(parent, {
					BackgroundTransparency = 0.5,
				})
			end)

			return parent
		end

		addSectLbl(Keybinds, "Keybinds (PC + Gamepad)", 0)
		createFrame(Keybinds, "Hide GUI", iData.value131.GuiHide, 1)
		createFrame(Keybinds, "Carry Speed", iData.value131.SpeedToggle, 2)
		createFrame(Keybinds, "Lagger Mode", iData.value131.LaggerToggle, 3)
		createFrame(Keybinds, "Lagger Carry", iData.value131.LaggerCarry, 4)
		createFrame(Keybinds, "Auto Bat", iData.value131.AutoBat, 5)
		createFrame(Keybinds, "BAT V2", iData.value131.BatV2, 5)
		createFrame(Keybinds, "TP Bat", iData.value131.TPBat, 6)
		createFrame(Keybinds, "Auto Left", iData.value131.AutoLeft, 7)
		createFrame(Keybinds, "Auto Right", iData.value131.AutoRight, 8)
		createFrame(Keybinds, "Drop Brainrot", iData.value131.DropBrainrot, 9)
		createFrame(Keybinds, "TP Down", iData.value131.TPFloor, 10)
	end)()
	local function handler(flag, secondaryFlag)
		if not secondaryFlag or secondaryFlag == Enum.KeyCode.Unknown then
			return false
		end

		if not flag or type(flag) ~= "table" then
			return false
		end

		if flag.kb and secondaryFlag == flag.kb then
			return true
		end

		if flag.gp and secondaryFlag == flag.gp then
			return true
		end

		return false
	end
	local function secondaryHandler(flag)
		if not flag or flag == Enum.KeyCode.Unknown then
			return false
		end

		local iterator, state, control = pairs(iData.value131)

		repeat
			local controlResult

			control, controlResult = iterator(state, control)

			if not control then
				for _, item in pairs(tpBatData) do
					if item == flag then
						return true
					end
				end

				return false
			end
		until type(controlResult) == "table" and flag == controlResult.kb or flag == controlResult.gp

		return true
	end
	local guiHideData = {}
	iData.value3.InputBegan:Connect(function(input, gameProcessed)
		if iData.value3:GetFocusedTextBox() then
			return
		end

		local KeyCode = input.KeyCode

		if KeyCode == Enum.KeyCode.Unknown then
			return
		end

		if KeyCode == Enum.KeyCode.Thumbstick1 or KeyCode == Enum.KeyCode.Thumbstick2 then
			return
		end

		if gameProcessed and not secondaryHandler(KeyCode) then
			return
		end

		if KeyCode == tpBatData.guiHide or handler(iData.value131.GuiHide, KeyCode) then
			local timestamp = tick()
			local flag

			if timestamp < (guiHideData.guiHide or 0) + 0.25 then
				flag = false
			else
				guiHideData.guiHide = timestamp
				flag = true
			end

			if not flag then
				return
			end

			if hubData.outer and hubData.outer.Visible then
				if hubData.hideGui then
					hubData.hideGui()

					return
				end

				hubData.outer.Visible = false

				return
			end

			if hubData.showGui then
				hubData.showGui()

				return
			end

			if hubData.outer then
				hubData.outer.Visible = true

				return
			end
		else
			if KeyCode == tpBatData.speed then
				speedToggleAction()
				iData.value168()

				return
			end

			if KeyCode == tpBatData.carryMode or handler(iData.value131.SpeedToggle, KeyCode) then
				iData.value170()
				iData.value168()

				return
			end

			if KeyCode == tpBatData.laggerToggle or handler(iData.value131.LaggerToggle, KeyCode) then
				local timestamp = tick()
				local flag

				if timestamp < (guiHideData.laggerToggle or 0) + 0.25 then
					flag = false
				else
					guiHideData.laggerToggle = timestamp
					flag = true
				end

				if not flag then
					return
				end

				iData.value171()
				iData.value168()

				return
			end

			if KeyCode == tpBatData.laggerCarry or handler(iData.value131.LaggerCarry, KeyCode) then
				local timestamp = tick()
				local flag

				if timestamp < (guiHideData.laggerCarry or 0) + 0.25 then
					flag = false
				else
					guiHideData.laggerCarry = timestamp
					flag = true
				end

				if not flag then
					return
				end

				toggleLaggerCarry()
				iData.value168()

				return
			end

			if KeyCode == tpBatData.batV2 or handler(iData.value131.BatV2, KeyCode) then
				iData.value26.toggleBatV2()

				return
			end

			if KeyCode == tpBatData.circle or handler(iData.value131.AutoBat, KeyCode) then
				iData.value31 = not iData.value31

				if iData.value31 then
					iData.value123()
				else
					iData.value124()
				end

				if iData.value54 then
					iData.value54(iData.value31)
				end

				if iData.value78.autoBat then
					iData.value78.autoBat(iData.value31)
				end

				iData.value168()

				return
			end

			if KeyCode == tpBatData.dropBrainrot or handler(iData.value131.DropBrainrot, KeyCode) then
				iData.value153()

				return
			end

			if KeyCode == tpBatData.tpDown or handler(iData.value131.TPFloor, KeyCode) then
				iData.value155()

				return
			end

			if KeyCode == tpBatData.tpBat or handler(iData.value131.TPBat, KeyCode) then
				if iData.value26.tpBat then
					iData.value26.stopTPBat()
				elseif not iData.value164 or (not iData.value164.tryStart or iData.value164.tryStart()) then
					iData.value26.startTPBat()
				end

				if iData.value26.setTPBatVisual then
					iData.value26.setTPBatVisual(iData.value26.tpBat)
				end

				if iData.value78.tpBat then
					iData.value78.tpBat(iData.value26.tpBat)
				end

				iData.value168()

				return
			end

			if KeyCode == tpBatData.autoLeft or handler(iData.value131.AutoLeft, KeyCode) then
				if iData.value27 then
					iData.value27 = false
					secondaryUpdateInstanceProperties()
				elseif not iData.value164 or (not iData.value164.tryStart or iData.value164.tryStart()) then
					if iData.value28 then
						iData.value28 = false
						iData.value150()

						if iData.value30 then
							iData.value30(false)
						end

						if iData.value78.autoRight then
							iData.value78.autoRight(false)
						end
					end

					if iData.value31 then
						iData.value124()

						if iData.value54 then
							iData.value54(false)
						end

						if iData.value78.autoBat then
							iData.value78.autoBat(false)
						end
					end

					iData.value27 = true
					iData.value151()
				end

				if iData.value29 then
					iData.value29(iData.value27)
				end

				if iData.value78.autoLeft then
					iData.value78.autoLeft(iData.value27)
				end

				iData.value168()

				return
			end

			if KeyCode == tpBatData.autoRight or handler(iData.value131.AutoRight, KeyCode) then
				if iData.value28 then
					iData.value28 = false
					iData.value150()
				elseif not iData.value164 or (not iData.value164.tryStart or iData.value164.tryStart()) then
					if iData.value27 then
						secondaryUpdateInstanceProperties()

						if iData.value29 then
							iData.value29(false)
						end

						if iData.value78.autoLeft then
							iData.value78.autoLeft(false)
						end
					end

					if iData.value31 then
						iData.value124()

						if iData.value54 then
							iData.value54(false)
						end

						if iData.value78.autoBat then
							iData.value78.autoBat(false)
						end
					end

					iData.value28 = true
					iData.value152()
				end

				if iData.value30 then
					iData.value30(iData.value28)
				end

				if iData.value78.autoRight then
					iData.value78.autoRight(iData.value28)
				end

				iData.value168()
			end
		end
	end)
	if iData.value19 then
		startHoldInfJump()
	end
	if iData.value18 and not iData.value140.antiRag then
		iData.value140.antiRag = iData.value4.Heartbeat:Connect(function()
			if not iData.value18 then
				return
			end

			local Character = iData.value11.Character

			if not Character then
				return
			end

			local Humanoid = Character:FindFirstChildOfClass("Humanoid")
			local HumanoidRootPart = Character:FindFirstChild("HumanoidRootPart")

			if not Humanoid or not HumanoidRootPart then
				return
			end

			local State = Humanoid:GetState()
			local flag = State == Enum.HumanoidStateType.Physics
				or (State == Enum.HumanoidStateType.Ragdoll or State == Enum.HumanoidStateType.FallingDown)
			local RagdollEndTime = iData.value11:GetAttribute("RagdollEndTime")

			if RagdollEndTime and RagdollEndTime - workspace:GetServerTimeNow() > 0 then
				flag = true
			end

			if flag then
				pcall(function()
					local result = iData.value11
					local data = { workspace:GetServerTimeNow() }

					result:SetAttribute("RagdollEndTime", unpackValues(data))
				end)
				for _, descendant in ipairs(Character:GetDescendants()) do
					if
						descendant:IsA("BallSocketConstraint")
						or descendant:IsA("Attachment") and descendant.Name:find("RagdollAttachment")
					then
						descendant:Destroy()
					end
				end
				for index, item in ipairs(Character:GetDescendants()) do
					if item:IsA("Motor6D") and item.Enabled == false then
						item.Enabled = true
					end
				end
				if Humanoid.Health > 0 then
					Humanoid:ChangeState(Enum.HumanoidStateType.Running)
				end
				workspace.CurrentCamera.CameraSubject = Humanoid
				HumanoidRootPart.Anchored = false
				HumanoidRootPart.AssemblyLinearVelocity = Vector3.zero
				HumanoidRootPart.AssemblyAngularVelocity = Vector3.zero
			end
		end)
	end
	if iData.value20 then
		iData.value121(iData.value11.Character)
	end
	if iData.value108 then
		startESP()
	end
	iData.value26.antiKick = true
	iData.value26.enableAntiKick()
	CandyApplyCustomSky(iData.value8)
	buildMobileButtons()
	if buildDiscordLink then
		buildDiscordLink()
	end
	local timestamp = tick()
	local updateInstancePropertiesFlag = false
	local tweenInfo = TweenInfo.new(0.55, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
	local secondaryTweenInfo = TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
	local CanvasGroup = Instance.new("CanvasGroup")
	CanvasGroup.Name = "ChromeFade"
	CanvasGroup.Size = UDim2.new(1, 0, 1, 0)
	CanvasGroup.Position = UDim2.new(0, 0, 0, 0)
	CanvasGroup.BackgroundTransparency = 1
	CanvasGroup.BorderSizePixel = 0
	CanvasGroup.GroupTransparency = 0
	CanvasGroup.ZIndex = 2
	CanvasGroup.Parent = hubData.inner
	local inner = hubData.inner
	local nameData = {
		HeaderFrame = true,
		TabBar = true,
		ContentFrame = true,
	}
	if inner then
		local GetChildren = inner.GetChildren
		local data = {}
		for index, item in ipairs(GetChildren(inner)) do
			if nameData[item.Name] then
				table.insert(data, item)
			elseif item:IsA("Frame") and item.Size.Y.Offset == 1 then
				table.insert(data, item)
			end
		end
		for _, item in ipairs(data) do
			item.Parent = CanvasGroup
		end
	end
	hubData.chromeGroup = CanvasGroup
	pcall(function()
		local voidTitle = hubData.voidTitle
		local outer = hubData.outer

		if voidTitle and outer then
			voidTitle.Parent = outer
			voidTitle.ZIndex = 50
			voidTitle.AnchorPoint = Vector2.new(0.5, 0)
			voidTitle.Position = UDim2.new(0.5, 0, 0, -8)
			voidTitle.Size = UDim2.new(0, 300, 0, 150)
			voidTitle.BackgroundTransparency = 1

			if not voidTitle:GetAttribute("VoidTitlePinned") then
				voidTitle:SetAttribute("VoidTitlePinned", true)
				outer:GetPropertyChangedSignal("Position"):Connect(function() end)
			end
		end

		local function handler(flag)
			if not flag then
				return
			end

			for _, descendant in ipairs(flag:GetDescendants()) do
				local capturedDescendant = descendant

				if capturedDescendant.Name == "VoidTitle" and capturedDescendant ~= hubData.voidTitle then
					pcall(function()
						capturedDescendant:Destroy()
					end)
				end
			end
		end

		handler(CanvasGroup)
		handler(hubData.inner)
	end)
	local function updateInstanceProperties()
		if updateInstancePropertiesFlag then
			return
		end

		updateInstancePropertiesFlag = true
		iData.value2
			:Create(CanvasGroup, tweenInfo, {
				GroupTransparency = 0.88,
			})
			:Play()
		pcall(function()
			if hubData.voidTitle then
				hubData.voidTitle.ImageTransparency = 0
				hubData.voidTitle.BackgroundTransparency = 1
			end
		end)

		if iData.value113 and iData.value113.Visible then
			pcall(function()
				iData.value2
					:Create(iData.value113, tweenInfo, {
						ImageTransparency = 0.1,
					})
					:Play()
			end)
		end

		if hubData.inner then
			pcall(function()
				iData.value2
					:Create(hubData.inner, tweenInfo, {
						BackgroundTransparency = 0.55,
					})
					:Play()
			end)
		end
	end
	local function alternateHandler()
		timestamp = tick()

		if not updateInstancePropertiesFlag then
			return
		end

		updateInstancePropertiesFlag = false
		iData.value2
			:Create(CanvasGroup, secondaryTweenInfo, {
				GroupTransparency = 0,
			})
			:Play()

		if iData.value113 and iData.value113.Visible then
			pcall(function()
				iData.value2
					:Create(iData.value113, secondaryTweenInfo, {
						ImageTransparency = 0.35,
					})
					:Play()
			end)
		end

		if hubData.inner then
			pcall(function()
				iData.value2
					:Create(hubData.inner, secondaryTweenInfo, {
						BackgroundTransparency = 0,
					})
					:Play()
			end)
		end
	end
	local function onInputBegan(inputBegan)
		if
			inputBegan.UserInputType == Enum.UserInputType.MouseButton1
			or (
				inputBegan.UserInputType == Enum.UserInputType.Touch
				or inputBegan.UserInputType == Enum.UserInputType.MouseButton2
			)
		then
			alternateHandler()
		end
	end
	local outer = hubData.outer
	if outer then
		outer.Active = true
		outer.InputBegan:Connect(onInputBegan)
	end
	if CanvasGroup then
		CanvasGroup.InputBegan:Connect(onInputBegan)
	end
	if hubData.contentFrame then
		hubData.contentFrame.InputBegan:Connect(onInputBegan)
	end
	if hubData.categoryList then
		hubData.categoryList.InputBegan:Connect(onInputBegan)
	end
	pcall(function()
		for _, descendant in ipairs(CanvasGroup:GetDescendants()) do
			if descendant:IsA("TextButton") or descendant:IsA("ImageButton") then
				descendant.MouseButton1Click:Connect(function()
					alternateHandler()
				end)
				descendant.InputBegan:Connect(onInputBegan)
			end
		end
	end)
	task.spawn(function()
		while outer and outer.Parent do
			if outer.Visible then
				if not updateInstancePropertiesFlag and tick() - timestamp >= 5 then
					updateInstanceProperties()
				end
			else
				if updateInstancePropertiesFlag then
					updateInstancePropertiesFlag = false
					pcall(function()
						CanvasGroup.GroupTransparency = 0
					end)
				end

				timestamp = tick()
			end

			task.wait(0.12)
		end
	end)
end)()
print("VOID.VS LOADED")
