--// FNF Client

script.Parent:WaitForChild("Config"):WaitForChild("ObjectCount")
repeat task.wait() until script.Parent.Config.ObjectCount.Value > 0 and #script.Parent:GetDescendants() >= script.Parent.Config.ObjectCount.Value
repeat task.wait() until script.Parent.Config.ServerSetup.Value == true

--// Variables

local player = game.Players.LocalPlayer
local ui = script.Parent
local config = ui.Config
local events = ui.Events
local stage = ui.Stage.Value
local userinput = events.UserInput
local side = ui.PlayerSide.Value
local main = ui.Game
local cameraPoints = stage.CameraPoints
local easeStyle = Enum.EasingStyle.Sine
if (player.Input.CamEaseStyle.Value ~= "Sine") then 
	local array = Enum.EasingStyle:GetEnumItems()

	for i, v in pairs(array) do
		if tostring(v) == ("Enum.EasingStyle."..player.Input.CamEaseStyle.Value) then
			easeStyle = v
		end
	end
end

local fakeConductor = game.ReplicatedStorage.Modules.Conductor:Clone(); fakeConductor.Parent = ui
local Conductor = require(fakeConductor)
local Util = require(game.ReplicatedStorage.Modules.Util)
local TimingWindowStuff = require(game.ReplicatedStorage.Modules.TimingWindows)
local FlxVel = require(game.ReplicatedStorage.Modules.FlxVel)

local TS = game:GetService("TweenService")
local UIS = game:GetService("UserInputService")
local RUNS = game:GetService('RunService')

local LOG = require(game.ReplicatedStorage.Modules.DebugLog)
local Sprite = require(game.ReplicatedStorage.Modules.Sprites.Sprite)

local Taiko = nil
local ratingLabels = {}

side = main:FindFirstChild(side)

--// Startup

local hitGraph = {}
stage.P1Board.G.Enabled = false
stage.P2Board.G.Enabled = false
stage.SongInfo.G.Enabled = false
stage.SongInfo.P1Icon.G.Enabled = false
stage.SongInfo.P2Icon.G.Enabled = false
stage.FlyingText.G.Enabled = false
config.TimePast.Value = -40

for _, cam in pairs(cameraPoints:GetChildren()) do cam.CFrame = cam.OriginalCFrame.Value end
local lCameraCF, rCameraCF, cCameraCF = cameraPoints.L.CFrame, cameraPoints.R.CFrame, cameraPoints.C.CFrame

for _, side in pairs({main.R, main.L}) do
	local splashes = game.ReplicatedStorage.Misc.SplashContainer:Clone()
	splashes.Parent = side
end

--// Post-Game Stuff

local _acc_ = 100
local iconData = {}

local songSelect = player.PlayerGui.GameUI:WaitForChild("SongSelect", 10)
local endscene = player.PlayerGui.GameUI:FindFirstChild("EndScene")
if endscene then endscene:Destroy() end
if not songSelect then warn("Infinite yield possible on song select menu. Please report this to a dev!"); songSelect = player.PlayerGui.GameUI:WaitForChild("SongSelect"); end

--// fc shit
songSelect.StatsContainer.FCs.Text = "<font color='rgb(90,220,255)'>FCs</font>: "..player.Input.Achievements.FCs.Value.." | <font color='rgb(255, 225, 80)'>PFCs</font>: "..player.Input.Achievements.PFCs.Value

local accuracy, misses, combo, highcombo = {}, 0, 0, 0 --// set stats 
local actualAccuracy, marv, sick, good, ok, bad = 0,0,0,0,0,0

local function round(num, numDecimalPlaces)
	local mult = 10^(numDecimalPlaces or 0)
	return math.floor(num * mult + 0.5) / mult
end

local hitGraphModule = require(ui.Modules.HitGraph)
local healthbarConfig = nil

local playbackRate = 1
local hasGimmickNotes = false

local nps = 0
local peakNps = 0
local npsData = {}

function updateData()
	--print(data)
	for i = 1, 2 do
		if (stage.Config["P" .. i .. "Stats"].Value == "") then continue end

		local data = game.HttpService:JSONDecode(stage.Config["P" .. i .. "Stats"].Value)
		local label = main:FindFirstChild(i == 1 and "L" or "R").OpponentStats.Label
		label.Text = "Accuracy: " .. data.accuracy .. "% | Combo: " .. data.combo .. " | Misses: " .. data.misses
		stage.Config["P" .. i .. "Stats"].Value = ""
	end
end

local function updateStats()
	local info = ui.LowerContainer.Stats.Label

	ui.LowerContainer.Bar.Visible = player.Input.HealthBar.Value
	--if not player.Input.InfoBar.Value then return end

	local d = 0
	local data = ""

	table.foreach(accuracy, function(_, v)
		d += v
	end)

	local newAcc = 100

	if d == 0 and #accuracy == 0 then
		data = "Accuracy: 100%"
	else
		actualAccuracy = string.sub(tostring((d / #accuracy)), 1, 5)
		data = "Accuracy: " .. actualAccuracy .. "%"
		newAcc = actualAccuracy
	end

	data = data .. " | Combo: " ..combo .. " | Misses: " .. misses

	info.Text = data

	if player.Input.VerticalBar.Value then
		info = ui.SideContainer.Accuracy
		info.Text = string.gsub(data, " | ", "\n")
	end

	if combo > highcombo then highcombo = combo end

	-- judgement counter !!!
	local judgement = ui.SideContainer.Data
	judgement.Text = "Marvelous: " .. marv .. "\nSick: " .. sick .. "\nGood: " .. good .. "\nOk: " .. ok .. "\nBad: " .. bad

	-- extra data !!!
	local extra = ui.SideContainer.Extra
	extra.Text = "MA: "..round(marv / (sick == 0 and 1 or sick), 2) .. (sick == 0 and ":inf" or ":1").."\nPA: "..round(sick / (good == 0 and 1 or good), 2) .. (good == 0 and ":inf" or ":1")
	extra.Text = extra.Text .. "\nMean: "..hitGraphModule.CalculateMean(hitGraph,player.Input.Offset.Value) .. "ms"

	local npsDisplay = ui.SideContainer.NPS
	npsDisplay.Text = "NPS: " .. nps .. "\nMax NPS: " .. peakNps

	events.UpdateData:FireServer({
		accuracy = newAcc,
		combo = combo,
		misses = misses,
		bot = false
	})
	
	_acc_ = newAcc

	if (healthbarConfig ~= nil and healthbarConfig.overrideStats) then		
		local shadowVal
		local val
		
		local p1, p2 = stage.Config.P1Points.Value, stage.Config.P2Points.Value
		local score = stage.Config.Player1.Value == player and p1 or p2
		
		local rating = "?"
		if sick+good+ok+bad+misses == 0 then
			rating = "MFC"
		elseif good+ok+bad+misses == 0 then
			rating = "PFC"
		elseif ok+bad+misses == 0 then
			rating = "GFC"
		elseif misses == 0 then
			rating = "FC"
		elseif misses < 10 then
			rating = "SDCB"
		else
			rating = "Clear"
		end

		if healthbarConfig.overrideStats.Value then
			val = healthbarConfig.overrideStats.Value
			val = string.gsub(val, "{misses}", misses)
			val = string.gsub(val, "{combo}", combo)
			val = string.gsub(val, "{score}", score)
			val = string.gsub(val, "{rating}", rating)
			val = string.gsub(val, "{accuracy}", newAcc .. "%%")
		else
			val = info.Text
		end

		if healthbarConfig.overrideStats.ShadowValue then
			shadowVal = healthbarConfig.overrideStats.ShadowValue
			shadowVal = string.gsub(shadowVal, "{misses}", misses)
			shadowVal = string.gsub(shadowVal, "{combo}", combo)
			shadowVal = string.gsub(shadowVal, "{accuracy}", newAcc .. "%%")
		else
			shadowVal = info.Text
		end
		
		if healthbarConfig.overrideStats.Separator then
			val = string.gsub(val, "|", healthbarConfig.overrideStats.Separator)
			shadowVal = val
		end

		if (healthbarConfig.overrideStats.ChildrenToUpdate) then
			ui.SideContainer.Accuracy.Visible = false
			info = ui.LowerContainer.Stats.Label
			for i,v in pairs(healthbarConfig.overrideStats.ChildrenToUpdate) do
				info = ui.LowerContainer.Stats[v]
				if v:lower():match("shadow") then
					info.Text = shadowVal
				else
					info.Text = val
				end
			end
		else
			if player.Input.VerticalBar.Value then 
				if healthbarConfig.overrideStats.Separator then
					info.Text = string.gsub(val, " " ..healthbarConfig.overrideStats.Separator.." ", "\n")
				else
					info.Text = string.gsub(val, " | ", "\n")
				end
			else
				info.Text = val
			end
		end
	end
end

updateStats()

local function countdownPopup(waittime,number,config)
	stage.MusicPart[number]:Play()
	task.spawn(function()	
		if config == nil or config[number] == nil then return end

		local img = ui.Countdown.Countdown:Clone()
		img.Name = number
		img.Image = config[number]
		img.Visible = true
		img.Parent = ui.Countdown

		TS:Create(img,TweenInfo.new(waittime,Enum.EasingStyle.Linear,Enum.EasingDirection.InOut),{ImageTransparency = 1}):Play()

		task.wait(waittime*1.2)
		img:Destroy()
	end)
end

local songLength = 0

local function tweeen(length,speed,songholder) 
	songLength = length
	
	--print("CLIENT TIME: " .. songLength)
	local waittime = 1 / speed
	local modchartfile = (songholder:FindFirstChild("Modchart") and songholder.Modchart:IsA("ModuleScript")) and require(songholder.Modchart)
	local music,vocals = ui.GameMusic.Music, ui.GameMusic.Vocals

	if modchartfile and modchartfile.PreStart then
		modchartfile.PreStart(ui,waittime)
	end

	local images = {}

	if songholder:FindFirstChild("Countdown") and game.ReplicatedStorage.Countdowns:FindFirstChild(songholder.Countdown.Value) then
		local conf = require(game.ReplicatedStorage.Countdowns:FindFirstChild(songholder.Countdown.Value).Config)

		if conf.Audio ~= nil then
			stage.MusicPart["3"].SoundId = conf.Audio["3"]
			stage.MusicPart["2"].SoundId = conf.Audio["2"]
			stage.MusicPart["1"].SoundId = conf.Audio["1"]
			stage.MusicPart["Go"].SoundId = conf.Audio["Go"]
		end

		images = conf.Images
	end

	if songholder:FindFirstChild('ExtraCountdownTime') then task.wait(songholder.ExtraCountdownTime.Value) end
	task.spawn(function()
		if songholder:FindFirstChild("NoCountdown") then
			task.wait(waittime*3)
			stage.MusicPart["3"].Volume = 0
			stage.MusicPart["Go"].Volume = 0
			stage.MusicPart["3"]:Play()
			stage.MusicPart["Go"]:Play()
			task.wait(waittime)
			music.Playing = true
			vocals.Playing = true
		else
			countdownPopup(waittime,"3",images)
			task.wait(waittime)

			countdownPopup(waittime,"2",images)
			task.wait(waittime)

			countdownPopup(waittime,"1",images)
			task.wait(waittime)

			countdownPopup(waittime,"Go",images)
			task.wait(waittime)

			music.Playing = true
			vocals.Playing = true
		end
	end)

	for _, thing in pairs(stage.MusicPart:GetChildren()) do
		if thing:IsA("Sound") and thing.Name ~= "SERVERmusic" and thing.Name ~= "SERVERvocals" then
			thing.Volume = 0.5
		end
	end

	config.TimePast.Value = -4 / speed
	local lengthtween = TS:Create(config.TimePast,TweenInfo.new((length+(4/speed)), Enum.EasingStyle.Linear,Enum.EasingDirection.In,0,false,0),
		{Value=length})
	lengthtween:Play()
	
	--[[lengthtween.Completed:Connect(function() 
		print("CLIENT FINISHED: " .. config.TimePast.Value .. ", " .. tick())
	end)]]

	if songholder:FindFirstChild("Instrumental") then music.Volume = songholder.Instrumental.Volume.Value; end
	if songholder:FindFirstChild("Sound") then vocals.Volume = songholder.Sound.Volume.Value; end

	music.PitchEffect.Enabled = false
	vocals.PitchEffect.Enabled = false

	if songholder:FindFirstChild("Instrumental") then
		music.SoundId = songholder.Instrumental.Value
		music.PlaybackSpeed = songholder.Instrumental.PlaybackSpeed.Value
	end
	if songholder:FindFirstChild("Sound") then
		vocals.SoundId = songholder.Sound.Value
		vocals.PlaybackSpeed = songholder.Sound.PlaybackSpeed.Value
	end

	if playbackRate ~= 1 then
		music.PlaybackSpeed = music.PlaybackSpeed * playbackRate
		vocals.PlaybackSpeed = vocals.PlaybackSpeed * playbackRate

		if (player.Input.DisablePitch.Value) then
			music.PitchEffect.Enabled = true
			vocals.PitchEffect.Enabled = true

			music.PitchEffect.Octave = 1/playbackRate
			vocals.PitchEffect.Octave = 1/playbackRate
		end
	end

	music.TimePosition = 0
	vocals.TimePosition = 0
end

events.Start.OnClientEvent:Connect(tweeen)

local skinType = game.ReplicatedStorage.Skins:FindFirstChild(player.Input.Skin.Value) or game.ReplicatedStorage.Skins.Default
local botSkinType = game.ReplicatedStorage.Skins:FindFirstChild(player.Input.BotSkin.Value) or game.ReplicatedStorage.Skins.Default

local skin = skinType.Notes.Value
local botSkin = botSkinType.Notes.Value

local blur = Instance.new("BlurEffect")
blur.Parent = game.Lighting
blur.Size = 0

--TS:Create(blur, TweenInfo.new(1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = 0}):Play()

--// modifier stuff

for _, modifierButton in pairs(songSelect.Modifiers:GetDescendants()) do
	if modifierButton:IsA("ImageButton") then
		modifierButton.ImageColor3 = Color3.fromRGB(136, 136, 136);local enabled=false
		modifierButton.MouseButton1Click:Connect(function()
			enabled=not enabled
			TS:Create(modifierButton, TweenInfo.new(0.4), {ImageColor3 = enabled and Color3.fromRGB(255,255,255) or Color3.fromRGB(136, 136, 136)}):Play()
			if modifierButton:FindFirstChild("misc") then
				TS:Create(modifierButton.misc, TweenInfo.new(0.4), {ImageColor3 = enabled and Color3.fromRGB(255,255,255) or Color3.fromRGB(136, 136, 136)}):Play()
			end
			events.Modifiers:FireServer(modifierButton.Name)
		end)
		modifierButton.MouseEnter:Connect(function()
			modifierButton.ZIndex = 2
			local modifierLabel = script.ModifierLabel:Clone()
			modifierLabel.Parent = modifierButton
			modifierLabel.Text = "  "..string.gsub(modifierButton.Info.Value, "|", "\n").."  "
			local ogSize = modifierLabel.Size
			modifierLabel.Size = UDim2.new()
			TS:Create(modifierLabel, TweenInfo.new(0.125), {Size = ogSize}):Play()
		end)
		modifierButton.MouseLeave:Connect(function()
			while modifierButton:FindFirstChild("ModifierLabel") do
				modifierButton.ZIndex = 1
				local modifierLabel = modifierButton:FindFirstChild("ModifierLabel")
				if modifierLabel then
					TS:Create(modifierLabel, TweenInfo.new(0.125, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {Size = UDim2.new()}):Play()
					task.wait(0.125)
					modifierLabel:Destroy()
				end
			end
		end)
	end
end

function nowPlaying(ui,name)
	local nowPlaying = game.ReplicatedStorage.Misc.NowPlaying:Clone()
	
	nowPlaying.Parent = ui
	nowPlaying.Position -= UDim2.fromScale(0.2,0)
	nowPlaying.Color.BackgroundColor3 = Color3.new(1,0.75,0)
	nowPlaying.BGColor.BackgroundColor3 = Util.MixColors(Color3.new(0.1,0.1,0.1),Color3.new(1,0.75,0))
	nowPlaying.SongName.TextColor3 = Color3.new(1,0.75,0)
	nowPlaying.SongName.Text = name
	nowPlaying.ZIndex = 99999 -- just because highest lol...

	game.TweenService:Create(nowPlaying, TweenInfo.new(1), {Position = nowPlaying.Position + UDim2.fromScale(0.2,0)}):Play()
	task.wait(5.5)

	local tween = game.TweenService:Create(nowPlaying, TweenInfo.new(1.5, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {Position = nowPlaying.Position - UDim2.fromScale(0.2,0)});
	tween:Play()
	tween.Completed:Connect(function()
		nowPlaying:Destroy()
	end)
end

local multiplier = ui:WaitForChild("ModifierMultiplier")
songSelect.Modifiers.Multiplier.Text = "1x"; songSelect.Modifiers.Multiplier.TextColor3 = Color3.new(1,1,1)

multiplier.Changed:Connect(function()
	local color;if multiplier.Value > 1 then color = Color3.fromRGB(255, 255, 0);elseif multiplier.Value < 1 then color = Color3.fromRGB(255, 64, 30);else color = Color3.fromRGB(255, 255, 255) end
	Util.AnimateMultiplier(ui,songSelect.Modifiers.Multiplier,color)
	songSelect.Modifiers.Multiplier.Text = multiplier.Value.."x"
end)

local lobbyMusic = ui.SelectionMusic:GetChildren()
local songselectionsong = lobbyMusic[math.random(1,#lobbyMusic)]
local songselectionsongVolume = songselectionsong.Volume
local songselectionsongSpeed = songselectionsong.PlaybackSpeed -- some songs have a different speed

songselectionsong.Volume = 0
songselectionsong:Play()

TS:Create(songselectionsong,TweenInfo.new(4,Enum.EasingStyle.Quint,Enum.EasingDirection.In),{Volume = songselectionsongVolume}):Play()
TS:Create(workspace.CurrentCamera, TweenInfo.new(1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {FieldOfView = 35}):Play()
TS:Create(blur, TweenInfo.new(1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = 25}):Play()
songSelect.Visible = true

if player.Input.StreamerMode.Value == true then
	if not string.find(songselectionsong.Name,"FNF") then
		songselectionsong.PlaybackSpeed -= 0.35
		local a = Instance.new("EqualizerSoundEffect")
		a.LowGain = 20
		a.Parent = songselectionsong
	end
else
	songselectionsong.PlaybackSpeed = songselectionsongSpeed
	if songselectionsong:FindFirstChildOfClass("EqualizerSoundEffect") then
		songselectionsong:FindFirstChildOfClass("EqualizerSoundEffect"):Destroy()
	end
end

task.delay(2.5,function()
	nowPlaying(ui,songselectionsong.Name)
end)

songSelect.TimeLeft.Text = "Time Left: 15"
local c c = stage.Config.SelectTimeLeft.Changed:Connect(function()
	if not ui.Parent then c:Disconnect() return end
	songSelect.TimeLeft.Text = "Time Left: " .. stage.Config.SelectTimeLeft.Value
end)

--// load songs on client

stage.Events.LoadPlayer.OnClientInvoke = function(serverMusic, serverVocals)
	--// basic preloading
	ui.Loading.Visible = true
	TS:Create(workspace.CurrentCamera, TweenInfo.new(.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {FieldOfView = 68}):Play()
	game.ContentProvider:PreloadAsync({serverMusic, serverVocals})

	--// reassurance check
	local music,vocals = ui.GameMusic.Music, ui.GameMusic.Vocals
	if serverMusic.SoundId ~= "" then
		music.SoundId = serverMusic.SoundId
		repeat task.wait() until music.TimeLength > 0
	end
	if serverVocals.SoundId ~= "" then
		vocals.SoundId = serverVocals.SoundId
		repeat task.wait() until vocals.TimeLength > 0
	end

	--// finish preloading
	task.wait(.5)
	ui.Loading.Visible = false
	return true
end

--// Disable Stuffs

workspace.CurrentCamera.CameraType = Enum.CameraType.Scriptable
workspace.CurrentCamera.CFrame = stage.CameraPoints.C.CFrame
game.StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.Backpack, false)
game.StarterGui:SetCore("ResetButtonCallback", false)

local voteConnection; voteConnection = game.ReplicatedStorage.Events.PlayerSongVote.Event:Connect(function(name, difficulty, folder, rate)
	if (not name) or (not difficulty) or (not folder) or (not rate) then return end
	stage.Events.PlayerSongVote:FireServer(name, difficulty, folder, rate)
	if stage.Config.SinglePlayerEnabled.Value then
		playbackRate = rate
	else
		playbackRate = 1
	end
	
	config.PlaybackSpeed.Value = playbackRate
end)

for _, thing in pairs(player.PlayerGui.GameUI:GetChildren()) do
	if not string.match(thing.Name, "SongSelect") then
		thing.Visible = false
	end
end

--// hide 2v2 song

songSelect:SetAttribute("2v2", nil)

for _, thing in pairs(songSelect.SongScroller:GetChildren()) do
	if thing:GetAttribute("2V2") then thing.Visible = false end
end

for _, thing in pairs(songSelect.BasicallyNil:GetChildren()) do
	if thing:GetAttribute("2V2") then thing.Visible = false end
end

songSelect.Background.Fill.OpponentSelect.Visible = true
songSelect.Background.Fill["Player 1Select"].Visible = false
songSelect.Background.Fill["Player 2Select"].Visible = false
songSelect.Background.Fill["Player 3Select"].Visible = false
songSelect.Background.Fill["Player 4Select"].Visible = false

--// Stuffs

repeat Util.wait() until stage.Config.Song.Value
local tttt = TS:Create(blur, TweenInfo.new(1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = 0}); tttt:Play(); tttt.Completed:Connect(function() blur:Destroy() end)
local tWeen = TS:Create(songselectionsong,TweenInfo.new(2,Enum.EasingStyle.Quint,Enum.EasingDirection.In),{Volume = 0}) tWeen:Play() tWeen.Completed:Connect(function() songselectionsong:Stop() end)
local song = stage.Config.Song.Value:IsA("StringValue") and stage.Config.Song.Value.Value or require(stage.Config.Song.Value)
local songholder = stage.Config.Song.Value:FindFirstAncestorOfClass("StringValue") or stage.Config.Song.Value
if songholder.Parent.Parent.Parent.Name == "Songs" and not songholder:FindFirstChild("Sound") then songholder = songholder.Parent end
local specialSong,sixKey,nineKey,sevenKey,fiveKey = Util.SpecialSongCheck(songholder)
songSelect.Visible = false; voteConnection:Disconnect()
workspace.CurrentCamera.CameraType = Enum.CameraType.Scriptable
workspace.CurrentCamera.CFrame = stage.CameraPoints.C.CFrame

task.spawn(function()
	stage.MusicPart["Go"].Played:Wait();
	Util.NowPlaying(ui, songholder, player)
	task.wait(1);
	game.StarterGui:SetCore("ResetButtonCallback", true);
end)

--// Icons
local iconStuff = require(ui.Modules.Icons)
iconData = iconStuff.SetIcons(ui, songholder)

local succ, err = pcall(function() --// debugging
	song = game.HttpService:JSONDecode(song).song
end)

if err then
	song = game.HttpService:JSONDecode(require(game.ReplicatedStorage.Songs["/v/-tan"].Sage.Hard)).song
end

song.bpm = song.bpm

local bps, bpm = 60 / (song.bpm or 120), song.bpm
local sps = bps / 4

local function digital_format(n)
	return string.format("%d:%02d", math.floor(n/60), n%60)
end

local credit = songholder.Credits.Value
local songName = (songholder.Parent.Parent.Parent.Name == "Songs" and songholder:IsA("ModuleScript")) and songholder.Parent.Name or songholder.Name
local difficulty = stage.Config.Song.Value.Name

local TimePosition = (stage.MusicPart.SERVERvocals.TimeLength - stage.MusicPart.SERVERvocals.TimePosition) / stage.MusicPart.SERVERvocals.PlaybackSpeed
ui.LowerContainer.Credit.Text = songName.." (" .. difficulty .. ")" .. " (" .. playbackRate .. "x)" .. "\n"..credit.."\n"..digital_format(math.ceil(TimePosition))

--// unique mobile buttons

if songholder:FindFirstChild("MobileButtons") then
	ui.MobileButtons:Destroy()
	songholder.MobileButtons:Clone().Parent = ui
end

--// Preload countdown
if songholder:FindFirstChild("Countdown") and game.ReplicatedStorage.Countdowns:FindFirstChild(songholder.Countdown.Value) then
	local conf = require(game.ReplicatedStorage.Countdowns:FindFirstChild(songholder.Countdown.Value).Config)
	local data = {}

	if conf.Images ~= nil then
		for i,v in pairs(conf.Images) do
			table.insert(data,v)
		end
	end

	if conf.Audio ~= nil then
		for i,v in pairs(conf.Audio) do
			table.insert(data,v)
		end
	end

	game.ContentProvider:PreloadAsync(data)
end

--// modcharts and conductor

local modchartsEnabled = Util.ModchartCheck(ui, songholder, song)
local conductor = Conductor.Start(ui, songholder:FindFirstChild("Modchart"), bpm, modchartsEnabled, song, playbackRate)

--// Quick offsetting
local Functions = require(ui.Modules.Functions)

Functions.keyCheck(songholder, nineKey, sixKey, sevenKey, fiveKey)
local offset = songholder.Offset.Value + (player.Input.Offset.Value or 0)

local SongNoteConvert; if songholder:FindFirstChild("notetypeconvert") then SongNoteConvert = require(songholder.notetypeconvert); end

Functions.stuffCheck(songholder)
local convert = songholder:FindFirstChild("notetypeconvert") and SongNoteConvert.notetypeconvert or Functions.notetypeconvert

if SongNoteConvert and SongNoteConvert.newKeys then SongNoteConvert.newKeys(ui); specialSong = true end

--// check to see if a players settings have changed

local otherPlayer
if not stage.Config.SinglePlayerEnabled.Value then
	if stage.Config.Player1.Value == player then
		otherPlayer = stage.Config.Player2.Value
	else
		otherPlayer = stage.Config.Player1.Value
	end
end

local otherSkinType = otherPlayer and game.ReplicatedStorage.Skins:FindFirstChild(otherPlayer.Input.Skin.Value) or game.ReplicatedStorage.Skins.Default
local otherSkin = otherSkinType.Notes.Value

main.L.Arrows.IncomingNotes.DescendantAdded:Connect(function(arrow)
	if not (main.Rotation >= 90) then return end
	if songholder:FindFirstChild("NoSettings") then return end
	if arrow:IsA("Frame") and arrow:FindFirstChild("Frame") then
		arrow.Rotation = 180
		arrow.Frame.Rotation = 180
		arrow.Frame.Arrow.Rotation = 180
	end
end)

main.R.Arrows.IncomingNotes.DescendantAdded:Connect(function(arrow)
	if not (main.Rotation >= 90) then return end
	if songholder:FindFirstChild("NoSettings") then return end
	if arrow:IsA("Frame") and arrow:FindFirstChild("Frame") then
		arrow.Rotation = 180
		arrow.Frame.Rotation = 180
		arrow.Frame.Arrow.Rotation = 180
	end
end)

local AnimatedReceptors = {
	L = {},
	R = {}
}

function ChangeUI(style)
	if style ~= nil then
		--print("UI Style change to " .. style)
		local UI = game.ReplicatedStorage.UIStyles[style]
		healthbarConfig = require(UI.Config)
		local newStats
		local newBar

		-- remove old UI
		ui.LowerContainer.Bar:Destroy()

		-- replace new UI
		if player.Input.UseOldHealthbar.Value == true and style == "Default" then
			newBar = UI.BarOLD:Clone()
			newBar.Parent = ui.LowerContainer
		else
			newBar = UI.Bar:Clone()
			newBar.Parent = ui.LowerContainer
		end

		-- set custom colors
		if healthbarConfig.HealthBarColors then
			newBar.Background.BackgroundColor3 = healthbarConfig.HealthBarColors.Green or Color3.fromRGB(114, 255, 63)
			newBar.Background.Fill.BackgroundColor3 = healthbarConfig.HealthBarColors.Red or Color3.fromRGB(255, 0, 0)
		end

		-- toggle icons
		if healthbarConfig.ShowIcons then
			newBar.Player1.Sprite.Visible = healthbarConfig.ShowIcons.Dad
			newBar.Player2.Sprite.Visible = healthbarConfig.ShowIcons.BF
		end

		if UI:FindFirstChild("Stats") then
			ui.LowerContainer.Stats:Destroy()

			-- replace new stats
			newStats = UI.Stats:Clone()
			newStats.Parent = ui.LowerContainer
			
			if healthbarConfig.font then
				newStats.Label.Font = healthbarConfig.font
				ui.Stats.Label.Font = healthbarConfig.font
				
				ui.SideContainer.NPS.Font = healthbarConfig.font
				ui.SideContainer.Data.Font = healthbarConfig.font
				ui.SideContainer.Extra.Font = healthbarConfig.font
				ui.SideContainer.Accuracy.Font = healthbarConfig.font
				
				ui.LowerContainer.Credit.Font = healthbarConfig.font
			end
		end

		if healthbarConfig.isPixel then
			ui.LowerContainer.PointsA.Font = Enum.Font.Arcade
			ui.LowerContainer.PointsB.Font = Enum.Font.Arcade
		else
			ui.LowerContainer.PointsA.Font = Enum.Font.GothamBold
			ui.LowerContainer.PointsB.Font = Enum.Font.GothamBold
		end

		if healthbarConfig.overrideStats then
			if healthbarConfig.overrideStats.Credits then
				local val = healthbarConfig.overrideStats.Credits
				val = string.gsub(val, "{song}", songName)
				val = string.gsub(val, "{rate}", playbackRate)
				val = string.gsub(val, "{credits}", credit)
				val = string.gsub(val, "{difficulty}", difficulty)
				val = string.gsub(val, "{capdifficulty}", difficulty:upper())
				if healthbarConfig.overrideStats.Timer then
					val = string.gsub(val, "{timer}", healthbarConfig.overrideStats.Timer)
				end
				ui.LowerContainer.Credit.Text = val
			elseif healthbarConfig.overrideStats.Timer then
				ui.LowerContainer.Credit.Text = songName.." (" .. difficulty .. ")" .. " (" .. playbackRate .. "x)" .. "\n"..credit.."\n"..healthbarConfig.overrideStats.Timer
			end
		end
	else
		--print("UI Style change to Default")
		local UI = game.ReplicatedStorage.UIStyles["Default"]
		healthbarConfig = require(UI.Config)

		-- remove old UI
		ui.LowerContainer.Bar:Destroy()
		ui.LowerContainer.Stats:Destroy()

		-- replace new UI
		local newBar = UI.Bar:Clone()
		newBar.Parent = ui.LowerContainer

		local newStats = UI.Stats:Clone()
		newStats.Parent = ui.LowerContainer

		ui.LowerContainer.PointsA.Font = Enum.Font.GothamBold
		ui.LowerContainer.PointsB.Font = Enum.Font.GothamBold
	end

	updateStats()

	local iconStuff = require(ui.Modules.Icons)
	iconData = iconStuff.SetIcons(ui, songholder)

	updateUI()
end

local originalTextSize = {}

function updateUI(variable)
	local oppositeside = main:FindFirstChild(side.Name == "L" and "R" or "L")

	if player.Input.VerticalBar.Value then 
		ui.LowerContainer.Stats.Visible = false
		ui.SideContainer.Accuracy.Visible = true
	end
	
	if player.Input.InfoBar.Value == false then
		ui.LowerContainer.Stats.Visible = false
		ui.SideContainer.Accuracy.Visible = false
	end

	ui.Stats.Visible = player.Input.ShowDebug.Value

	ui.SideContainer.Data.Visible = player.Input.JudgementCounter.Value
	ui.SideContainer.Extra.Visible = player.Input.ExtraData.Value
	ui.SideContainer.NPS.Visible = player.Input.NPSData.Value

	if player.Input.ShowOpponentStats.Value then
		if player.Input.Middlescroll.Value then
			oppositeside.OpponentStats.Visible = player.Input.ShowOtherMS.Value 
		else
			oppositeside.OpponentStats.Visible = player.Input.ShowOpponentStats.Value
		end

		main.L.OpponentStats.Label.Rotation = 180
		main.R.OpponentStats.Label.Rotation = 180
	end

	if player.Input.HideScore.Value then
		ui.LowerContainer.PointsA.Visible = false
		ui.LowerContainer.PointsB.Visible = false
	end

	if player.Input.HideCredits.Value then
		ui.LowerContainer.Credit.Visible = false
	end

	for _, note in pairs(main.Templates:GetChildren()) do
		note.Frame.Bar.End.ImageTransparency = player.Input.BarOpacity.Value
		note.Frame.Bar.ImageLabel.ImageTransparency = player.Input.BarOpacity.Value
	end
	
	--[[if songholder:FindFirstChild("Taiko") then
		Taiko = require(game.ReplicatedStorage.Modules.Taiko)
		Taiko.Init(ui)]]
	if not songholder:FindFirstChild("NoSettings") then

		if healthbarConfig ~= nil and healthbarConfig.overrideStats and healthbarConfig.overrideStats.Position and healthbarConfig.overrideStats.Position.Upscroll then
			ui.LowerContainer.Stats.Position = healthbarConfig.overrideStats.Position.Upscroll
		end
		
		if healthbarConfig ~= nil and healthbarConfig.overrideStats and healthbarConfig.overrideStats.BarPosition and healthbarConfig.overrideStats.BarPosition.Upscroll then
			ui.LowerContainer.Bar.Position = healthbarConfig.overrideStats.BarPosition.Upscroll
		end
		
		if healthbarConfig ~= nil and healthbarConfig.overrideStats and healthbarConfig.overrideStats.IconPosition then
			ui.LowerContainer.Bar.Player1.Sprite.Position = healthbarConfig.overrideStats.IconPosition.P1.Upscroll
			ui.LowerContainer.Bar.Player2.Sprite.Rotation = healthbarConfig.overrideStats.IconPosition.P2.Upscroll
		end

		if player.Input.VerticalBar.Value then
			if healthbarConfig ~= nil and not healthbarConfig.OverrideVertical then
				local size = ui.LowerContainer.Bar.Size

				ui.LowerContainer.Bar.Position = UDim2.new(1.1, 0,-4, 0)
				ui.LowerContainer.Bar.Size = UDim2.new(size.X.Scale * 0.8, size.X.Offset, size.Y.Scale, size.Y.Offset)

				ui.LowerContainer.Bar.Rotation = 90
				ui.LowerContainer.Bar.Player1.Sprite.Rotation = -90
				ui.LowerContainer.Bar.Player2.Sprite.Rotation = -90
			end
		end

		if player.Input.Downscroll.Value then
			local statsPos = UDim2.new(0.5, 0,8.9, 0)

			if healthbarConfig ~= nil and healthbarConfig.overrideStats and healthbarConfig.overrideStats.Position and healthbarConfig.overrideStats.Position.Downscroll then
				statsPos = healthbarConfig.overrideStats.Position.Downscroll
			end
			
			if healthbarConfig ~= nil and healthbarConfig.overrideStats and healthbarConfig.overrideStats.BarPosition and healthbarConfig.overrideStats.BarPosition.Downscroll then
				ui.LowerContainer.Bar.Position = healthbarConfig.overrideStats.BarPosition.Downscroll
			end
			
			if healthbarConfig ~= nil and healthbarConfig.overrideStats and healthbarConfig.overrideStats.IconPosition then
				ui.LowerContainer.Bar.Player1.Sprite.Position = healthbarConfig.overrideStats.IconPosition.P1.Downscroll
				ui.LowerContainer.Bar.Player2.Sprite.Rotation = healthbarConfig.overrideStats.IconPosition.P2.Downscroll
			end

			main.Rotation = 180
			main.Position = UDim2.new(0.5,0,0.05,0)

			ui.LowerContainer.AnchorPoint = Vector2.new(0.5,0)
			ui.LowerContainer.Position = UDim2.new(0.5,0,0.1,0)
			ui.LowerContainer.Stats.Position = statsPos
			ui.LowerContainer.Credit.Position = UDim2.new(-0.167, 0,-0.6, 0)

			main.R.Position = UDim2.new(0,0,0,0)
			main.R.AnchorPoint = Vector2.new(0.1,0)
			main.L.Position = UDim2.new(1,0,0,0)
			main.L.AnchorPoint = Vector2.new(0.9,0)

			main.L.Arrows.Rotation = 180
			main.R.Arrows.Rotation = 180

			main.L.SplashContainer.Rotation = 180
			main.R.SplashContainer.Rotation = 180

			main.L.OpponentStats.Label.Rotation = 0
			main.R.OpponentStats.Label.Rotation = 0

			if player.Input.VerticalBar.Value then
				if healthbarConfig ~= nil and not healthbarConfig.OverrideVertical then
					local size = ui.LowerContainer.Bar.Size

					ui.LowerContainer.Bar.Position = UDim2.new(1.1, 0,4, 0)

					ui.LowerContainer.Bar.Rotation = 90
					ui.LowerContainer.Bar.Player1.Sprite.Rotation = -90
					ui.LowerContainer.Bar.Player2.Sprite.Rotation = -90
				end
			end

			if not specialSong then
				main.L.Arrows.IncomingNotes.Left.Rotation = 180
				main.L.Arrows.IncomingNotes.Down.Rotation = 180
				main.L.Arrows.IncomingNotes.Up.Rotation = 180
				main.L.Arrows.IncomingNotes.Right.Rotation = 180
				
				main.R.Arrows.IncomingNotes.Left.Rotation = 180
				main.R.Arrows.IncomingNotes.Down.Rotation = 180
				main.R.Arrows.IncomingNotes.Up.Rotation = 180
				main.R.Arrows.IncomingNotes.Right.Rotation = 180
			else
				main.L.Arrows.IncomingNotes.Rotation = 180
				main.R.Arrows.IncomingNotes.Rotation = 180
			end

			main.L.Glow.Rotation = 180
			main.R.Glow.Rotation = 180

		elseif variable == "Downscroll" then
			main.Rotation = 0
			main.Position = UDim2.new(0.5,0,0.125,0)
			ui.LowerContainer.Position = UDim2.new(0.5,0,0.9,0)
			ui.LowerContainer.Stats.Position = UDim2.new(0.5, 0,1, 0)
			ui.LowerContainer.AnchorPoint = Vector2.new(0.5,1)
			ui.LowerContainer.Credit.Position = UDim2.new(-0.167, 0,-8.582, 0)

			main.L.Position = UDim2.new(0,0,0,0)
			main.L.AnchorPoint = Vector2.new(0.1,0)
			main.R.Position = UDim2.new(1,0,0,0)
			main.R.AnchorPoint = Vector2.new(0.9,0)

			if player.Input.VerticalBar.Value then
				if healthbarConfig ~= nil and not healthbarConfig.OverrideVertical then
					local size = ui.LowerContainer.Bar.Size

					ui.LowerContainer.Bar.Position = UDim2.new(1.1, 0,-4, 0)

					ui.LowerContainer.Bar.Rotation = 90
					ui.LowerContainer.Bar.Player1.Sprite.Rotation = -90
					ui.LowerContainer.Bar.Player2.Sprite.Rotation = -90
				end
			end

			main.L.Arrows.Rotation = 0
			main.R.Arrows.Rotation = 0

			if not specialSong then 
				main.L.Arrows.IncomingNotes.Left.Rotation = 0
				main.L.Arrows.IncomingNotes.Down.Rotation = 0
				main.L.Arrows.IncomingNotes.Up.Rotation = 0
				main.L.Arrows.IncomingNotes.Right.Rotation = 0
				main.R.Arrows.IncomingNotes.Left.Rotation = 0
				main.R.Arrows.IncomingNotes.Down.Rotation = 0
				main.R.Arrows.IncomingNotes.Up.Rotation = 0
				main.R.Arrows.IncomingNotes.Right.Rotation = 0
			else
				main.L.Arrows.IncomingNotes.Rotation = 0
				main.R.Arrows.IncomingNotes.Rotation = 0
			end

			main.L.Glow.Rotation = 0
			main.R.Glow.Rotation = 0
		end

		if player.Input.Middlescroll.Value then
			oppositeside.Visible = player.Input.ShowOtherMS.Value
			side.Position = UDim2.new(0.5,0,0.5,0)
			side.AnchorPoint = Vector2.new(0.5,0.5)
			if player.Input.ShowOtherMS.Value then
				oppositeside.OpponentStats.Size = UDim2.new(2,0,0.05,0)
				oppositeside.OpponentStats.Position = UDim2.new(0.5,0,-0.08,0)
				oppositeside.AnchorPoint = Vector2.new(0.1, 0)
				oppositeside.Size = UDim2.new(0.15,0, 0.3,0)
				oppositeside.Position = oppositeside.Name == "R" and UDim2.new(0.88,0, 0.5,0) or UDim2.new(0,0, 0.5,0)
				if player.Input.Downscroll.Value then oppositeside.Position = oppositeside.Name == "L" and UDim2.new(0.88,0, 0.5,0) or UDim2.new(0,0, 0.5,0) end
			end
		elseif variable == "Middlescroll" then
			oppositeside.Visible = true
			main.L.Position = UDim2.new(0,0, 0,0)
			main.L.Size = UDim2.new(0.5,0, 1,0)
			main.L.AnchorPoint = Vector2.new(0.1, 0)
			main.R.AnchorPoint = Vector2.new(0.9, 0)
			main.R.Size = UDim2.new(0.5,0, 1,0)
			main.R.Position = UDim2.new(1,0, 0,0)
			if player.Input.Downscroll.Value then
				main.R.Position = UDim2.new(0,0,0,0)
				main.R.AnchorPoint = Vector2.new(0.1,0)
				main.L.Position = UDim2.new(1,0,0,0)
				main.L.AnchorPoint = Vector2.new(0.9,0)
			end
		end 		
	end

	originalTextSize["Stats"] = ui.LowerContainer.Stats.Size
	for i,v in pairs(ui.SideContainer:GetChildren()) do
		if v.ClassName ~= "TextLabel" then continue end
		originalTextSize[v.Name] = v.Size
	end
end

events.ChangeUI.Event:Connect(function(style)
	ChangeUI(style)
end)

local function Check(variable,style)
	local oppositeside = main:FindFirstChild(side.Name == "L" and "R" or "L")

	-- generate new UI
	if songholder:FindFirstChild("UIStyle") then
		ChangeUI(songholder:FindFirstChild("UIStyle").Value)
	else
		ChangeUI(nil)
	end

	updateUI(variable)

	ui.Background.BackgroundTransparency = player.Input.BackgroundTrans.Value

	main.L.Underlay.BackgroundTransparency = player.Input.ChartTransparency.Value
	main.R.Underlay.BackgroundTransparency = player.Input.ChartTransparency.Value
	
	main.L.Underlay.UIGradient.Enabled = player.Input.LaneFadeout.Value
	main.R.Underlay.UIGradient.Enabled = player.Input.LaneFadeout.Value

	Functions.settingsCheck(specialSong, songholder:FindFirstChild("NoSettings"))
	offset = songholder.Offset.Value + (player.Input.Offset.Value or 0)

	if not specialSong then 
		for _, arrow in ipairs(side.Arrows:GetChildren()) do
			if arrow:IsA("ImageLabel") then
				arrow.Image = skin
				arrow.Overlay.Image = skin
			end
		end
		
		for _, arrow in ipairs(side.Glow:GetChildren()) do
			arrow.Arrow.Image = skin
		end

		if skinType:FindFirstChild("XML") then
			local XML = require(skinType.XML)
			if skinType:FindFirstChild("Animated") and skinType:FindFirstChild("Animated").Value == true then
				local config = require(skinType.Config)

				for _, arrow in ipairs(side.Arrows:GetChildren()) do
					if arrow:IsA("ImageLabel") then
						--arrow.Image = skin
						if arrow.Overlay then
							arrow.Overlay.Visible = false
						end

						local sprite = Sprite.new(arrow,true,1,true,config["noteScale"])
						sprite.Animations = {}
						sprite.CurrAnimation = nil
						sprite.AnimData.Looped = false
						
						
						if type(config["receptor"]) == "string" then
							sprite:AddSparrowXML(skinType.XML,"Receptor",config["receptor"], 24, true).ImageId = skin
						else
							sprite:AddSparrowXML(skinType.XML,"Receptor",config["receptor"][arrow.Name], 24, true).ImageId = skin
						end

						if config["glow"] ~= nil then
							if type(config["glow"]) == "string" then
								sprite:AddSparrowXML(skinType.XML,"Glow",config["glow"], 24, true).ImageId = skin
							else
								sprite:AddSparrowXML(skinType.XML,"Glow",config["glow"][arrow.Name], 24, true).ImageId = skin
							end
						end

						if config["press"] ~= nil then
							if type(config["press"]) == "string" then
								sprite:AddSparrowXML(skinType.XML,"Press",config["press"], 24, true).ImageId = skin
							else
								sprite:AddSparrowXML(skinType.XML,"Press",config["press"][arrow.Name], 24, true).ImageId = skin
							end
						end

						sprite:PlayAnimation("Receptor")
						AnimatedReceptors[side.Name][arrow.Name] = sprite
					end
				end

				for _, arrow in ipairs(side.Glow:GetChildren()) do
					arrow.Arrow.Visible = false
				end
			else
				XML.XML(side)
			end
		end

		if otherPlayer then
			for _, arrow in ipairs(oppositeside.Arrows:GetChildren()) do
				if arrow:IsA("ImageLabel") then
					arrow.Image = otherSkin
					arrow.Overlay.Image = otherSkin
				end
			end
			for _, arrow in ipairs(oppositeside.Glow:GetChildren()) do
				arrow.Arrow.Image = otherSkin
			end
			if otherSkinType:FindFirstChild("XML") then
				if otherSkinType:FindFirstChild("Animated") and otherSkinType:FindFirstChild("Animated").Value == true then
					local config = require(otherSkinType.Config)

					for _, arrow in ipairs(oppositeside.Arrows:GetChildren()) do
						if arrow:IsA("ImageLabel") then
							--arrow.Image = otherSkin
							if arrow.Overlay then
								arrow.Overlay.Visible = false
							end

							local sprite = Sprite.new(arrow,true,1,true,config["noteScale"])
							sprite.Animations = {}
							sprite.CurrAnimation = nil
							sprite.AnimData.Looped = false

							if type(config["receptor"]) == "string" then
								sprite:AddSparrowXML(otherSkinType.XML,"Receptor",config["receptor"], 24, true).ImageId = otherSkin
							else
								sprite:AddSparrowXML(otherSkinType.XML,"Receptor",config["receptor"][arrow.Name], 24, true).ImageId = otherSkin
							end

							if config["glow"] ~= nil then
								if type(config["glow"]) == "string" then
									sprite:AddSparrowXML(otherSkinType.XML,"Glow",config["glow"], 24, true).ImageId = otherSkin
								else
									sprite:AddSparrowXML(otherSkinType.XML,"Glow",config["glow"][arrow.Name], 24, true).ImageId = otherSkin
								end
							end

							if config["press"] ~= nil then
								if type(config["press"]) == "string" then
									sprite:AddSparrowXML(otherSkinType.XML,"Press",config["press"], 24, true).ImageId = otherSkin
								else
									sprite:AddSparrowXML(otherSkinType.XML,"Press",config["press"][arrow.Name], 24, true).ImageId = otherSkin
								end
							end

							sprite:PlayAnimation("Receptor")
							AnimatedReceptors[oppositeside.Name][arrow.Name] = sprite
						end
					end

					for _, arrow in ipairs(oppositeside.Glow:GetChildren()) do
						arrow.Arrow.Visible = false
					end
				else
					local XML = require(otherSkinType.XML)
					XML.XML(oppositeside)
				end
			end
		elseif botSkin ~= "Default" then
			for _, arrow in ipairs(oppositeside.Arrows:GetChildren()) do
				if arrow:IsA("ImageLabel") then
					arrow.Image = botSkin
					arrow.Overlay.Image = botSkin
				end
			end
			for _, arrow in ipairs(oppositeside.Glow:GetChildren()) do
				arrow.Arrow.Image = botSkin
			end
			if botSkinType:FindFirstChild("XML") then
				local XML = require(botSkinType.XML)
				XML.XML(oppositeside)
			end
		end
	end
end

--// Game

local Device = require(game.ReplicatedStorage.Modules.Device)

local otherplayerKeyDown = {
	["Left"] = false,
	["Down"] = false,
	["Up"]   = false,
	["Right"]= false,
}

local myKeysDown = {
	["Left"] = false,
	["Down"] = false,
	["Up"]   = false,
	["Right"]= false,
}

-- Used for animate and seeing which note was hit
local RLToKey = {
	L4 = 'A',
	L3 = 'S',
	L2 = 'D', 
	L1 = 'F',
	Space = 'Space',
	R1 = 'H',
	R2 = 'J',
	R3 = 'K',
	R4 = 'L'
}

if not nineKey or fiveKey then
	RLToKey = {
		L3 = 'S',
		L2 = 'D', 
		L1 = 'F',
		Space = 'Space',
		R1 = 'J',
		R2 = 'K',
		R3 = 'L'
	}
end


if not nineKey and not sevenKey and not sixKey then
	RLToKey = {
		L2 = 'D', 
		L1 = 'F',
		Space = 'Space',
		R1 = 'J',
		R2 = 'K',
	}
end

--// Create Animations
_G.Animations = {}

--local animswitching = songholder:FindFirstChild("AnimSwitching")
local animations = _G.Animations --animswitching and _G.Animations or {}
local p2animations = {}
local anifold = if songholder:FindFirstChild(ui.PlayerSide.Value.."_Anims") then songholder[ui.PlayerSide.Value.."_Anims"].Value else game.ReplicatedStorage.Animations:FindFirstChild(player.Input.Animation.Value) or Util.findAnim(player.Input.Animation.Value) or game.ReplicatedStorage.Animations.Default
local idletrack
local p2idletrack

local function loadAnimsFrom(folder, humanoid, P2)
	if ui.PlayerSide.Value == "R" then folder = folder.Mirrored end

	if P2 then
		-- second playa
		for _, obj in ipairs(folder:GetChildren()) do
			if obj:IsA("Animation") then
				p2animations[obj.Name] = humanoid:LoadAnimation(obj)
			end
		end
		p2idletrack = p2animations["Idle"]
	else
		if not humanoid then humanoid = player.Character.Humanoid end

		-- make folder if it doesn't exist
		for _, obj in ipairs(folder:GetChildren()) do
			if obj:IsA("Animation") then
				animations[obj.Name] = humanoid:LoadAnimation(obj)
			end
		end
		idletrack = animations["Idle"]
	end
end

-- load the animations
if anifold:FindFirstChild("Custom") then
	loadAnimsFrom(anifold, player.Character:WaitForChild("customrig"):WaitForChild("rig"):WaitForChild("Humanoid"))
	--
elseif anifold:FindFirstChild("FBX") then
	loadAnimsFrom(anifold, player.Character:WaitForChild("customrig"):WaitForChild("rig"):WaitForChild("AnimationController"):WaitForChild("Animator"))
	--
elseif anifold:FindFirstChild("2Player") then
	loadAnimsFrom(anifold.Other, player.Character:WaitForChild("char2"):WaitForChild("Dummy"):WaitForChild("Humanoid"), true)
	loadAnimsFrom(anifold, player.Character.Humanoid)
	--
elseif anifold:FindFirstChild("Custom2Player") then
	loadAnimsFrom(anifold.Other, player.Character:WaitForChild("char2"):WaitForChild("Dummy"):WaitForChild("Humanoid"), true)
	loadAnimsFrom(anifold, player.Character:WaitForChild("customrig"):WaitForChild("rig"):WaitForChild("Humanoid"))
	--
else
	loadAnimsFrom(anifold)
	--
end

local function moveCamera(note, oppositeSide)
	if not player.Input.MoveOnHit.Value then return end
	local side = ui.Side.Value
	local bg = workspace.ClientBG:FindFirstChildOfClass("Model")
	local modchartfile = (songholder:FindFirstChild("Modchart") and songholder.Modchart:IsA("ModuleScript")) and modchartsEnabled and require(songholder.Modchart)
	if (modchartfile and modchartfile.OverrideCamera) then return end

	local cpoint = (bg and bg:FindFirstChild("cameraPoints")) and bg.cameraPoints:FindFirstChild(side) or stage.CameraPoints:FindFirstChild(side) or stage.CameraPoints.C
	if (ui.PlayerSide.Value == ui.Side.Value and not oppositeSide) or (ui.PlayerSide.Value ~= ui.Side.Value) and oppositeSide then
		if note == "Up" then TS:Create(workspace.CurrentCamera, TweenInfo.new(player.Input.MoveSpeed.Value, easeStyle, Enum.EasingDirection.Out), {CFrame = cpoint.CFrame * CFrame.new(0, player.Input.MoveIntensity.value, 0)}):Play() end
		if note == "Left" then TS:Create(workspace.CurrentCamera, TweenInfo.new(player.Input.MoveSpeed.Value, easeStyle, Enum.EasingDirection.Out), {CFrame = cpoint.CFrame  * CFrame.new(-player.Input.MoveIntensity.value, 0, 0)}):Play() end
		if note == "Down" then TS:Create(workspace.CurrentCamera, TweenInfo.new(player.Input.MoveSpeed.Value, easeStyle, Enum.EasingDirection.Out), {CFrame = cpoint.CFrame  * CFrame.new(0, -player.Input.MoveIntensity.value, 0)}):Play() end
		if note == "Right" then TS:Create(workspace.CurrentCamera, TweenInfo.new(player.Input.MoveSpeed.Value, easeStyle, Enum.EasingDirection.Out), {CFrame = cpoint.CFrame  * CFrame.new(player.Input.MoveIntensity.value, 0, 0)}):Play() end
	end
end

--// note splash function
local function noteSplash(note)
	if specialSong and not SongNoteConvert then return end
	if not player.Input.NoteSplashes.Value then return end
	if not game.ReplicatedStorage.Misc.Splashes:FindFirstChild(note) then return end

	task.spawn(function()
		local plrSplashFolder = game.ReplicatedStorage.Splashes:FindFirstChild(player.Input.NoteSplashSkin.Value) or game.ReplicatedStorage.Splashes.Default
		local splashes = game.ReplicatedStorage.Misc.Splashes[note]:GetChildren()
		local splash = splashes[math.random(1,#splashes)]:Clone()
		local notePos = side.Arrows[note].Position
		splash.Parent = side.SplashContainer
		splash.Position = notePos--UDim2.new(notePos.X.Scale, notePos.X.Offset, 0.075, notePos.Y.Offset)
		splash.Image = plrSplashFolder.Splash.Value
		splash.Size = UDim2.fromScale(player.Input.SplashSize.Value*splash.Size.X.Scale, player.Input.SplashSize.Value*splash.Size.Y.Scale)

		local splashX = splash.ImageRectOffset.X
		for i = 0,8 do splash.ImageRectOffset = Vector2.new(splashX,i*128); task.wait(0.035); end
		splash:Destroy()
	end)
end

local RNG = Random.new()

--// hit indicator function
local function hitIndicator(variant, ms)
	if not player.Input.ShowRatings.Value then return end
	local sideToGoIn = ms and side or (ui.PlayerSide.Value == "L" and main.R or main.L)
	
	local style = player.Input.RatingStyle.Value
	
	if style == "FNB" then
		local deletethis = sideToGoIn:FindFirstChildOfClass("ImageLabel")
		if deletethis then deletethis.Parent = nil end

		local deletethistoo = sideToGoIn:FindFirstChildOfClass("TextLabel")
		if deletethistoo then deletethistoo.Parent = nil end

		local mult = player.Input.RatingSize.Value

		local thing = game.ReplicatedStorage.Misc.IndicatorTemplate:Clone()
		thing.Image = "rbxthumb://type=Asset&id="..player.Input[variant.."IndicatorImg"].Value.."&w=150&h=150" or stage.FlyingText.G["Template_"..variant].Image
		thing.Parent = sideToGoIn
		thing.Size = UDim2.new(0.25*mult,0,0.083*mult,0)
		thing.ImageTransparency = 0
		thing.Rotation = (main.Rotation >= 90) and 180 or 0
		game:GetService("Debris"):AddItem(thing, 1.5)

		if player.Input.CenterRatings.Value then
			thing.Position = UDim2.new(0.5, 0,0.45, 0)
		end

		task.spawn(function()
			if player.Input.RatingBounce.Value then
				TS:Create(thing,TweenInfo.new(0.05, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {Size = UDim2.new(0.3*mult,0,0.1*mult,0)}):Play()
			end	
			task.wait(0.1)
			TS:Create(thing,TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = UDim2.new(0.25*mult,0,0.083*mult,0)}):Play()
			task.wait(0.5)
			TS:Create(thing,TweenInfo.new(0.75, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {ImageTransparency = 1}):Play()
		end)

		local miliseconds = game.ReplicatedStorage.Misc.miliseconds:Clone()
		miliseconds.Visible = player.Input.ShowMS.Value
		miliseconds.Parent = sideToGoIn
		miliseconds.Size = UDim2.new(0.145*mult,0, 0.044*mult,0)
		miliseconds.Rotation = (main.Rotation >= 90) and 180 or 0
		miliseconds.Text = round(ms,2).." ms"
		if ms < 0 then miliseconds.TextColor3 = Color3.fromRGB(255, 61, 61) else miliseconds.TextColor3 = Color3.fromRGB(120, 255, 124) end
		game:GetService("Debris"):AddItem(miliseconds, 1.5)

		if player.Input.CenterRatings.Value then
			miliseconds.Position = UDim2.new(0.5, 0,0.36, 0)
		end

		task.spawn(function()
			if player.Input.RatingBounce.Value then
				TS:Create(miliseconds,TweenInfo.new(0.05, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {Size = UDim2.new(0.165*mult,0,0.06*mult,0)}):Play()
			end
			task.wait(0.1)
			TS:Create(miliseconds,TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = UDim2.new(0.145*mult,0,0.044*mult,0)}):Play()
			task.wait(0.5)
			TS:Create(miliseconds,TweenInfo.new(0.75, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {TextTransparency = 1}):Play()
			TS:Create(miliseconds,TweenInfo.new(0.75, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {TextStrokeTransparency = 1}):Play()
		end)
	elseif style == "FNF" then
		local mult = player.Input.RatingSize.Value

		local thing = game.ReplicatedStorage.Misc.IndicatorTemplate:Clone()
		thing.Image = "rbxthumb://type=Asset&id="..player.Input[variant.."IndicatorImg"].Value.."&w=150&h=150" or stage.FlyingText.G["Template_"..variant].Image
		thing.Parent = sideToGoIn
		thing.Size = UDim2.new(0.25*mult,0,0.083*mult,0)
		thing.ImageTransparency = 0
		thing.Rotation = (main.Rotation >= 90) and 180 or 0
		
		if (player.Input.Downscroll.Value) then
			thing:SetAttribute("Acceleration",Vector2.new(0,-550))
			thing:SetAttribute("Velocity",Vector2.new(RNG:NextInteger(0,10),RNG:NextInteger(140,175)))
		else
			thing:SetAttribute("Acceleration",Vector2.new(0,550))
			thing:SetAttribute("Velocity",Vector2.new(RNG:NextInteger(0,10),-RNG:NextInteger(140,175)))
		end
		
		if player.Input.CenterRatings.Value then
			thing.Position = UDim2.new(0.5, 0,0.45, 0)
		end
		
		table.insert(ratingLabels,thing)
	
		local tw = game:service'TweenService':Create(thing,TweenInfo.new(.2,Enum.EasingStyle.Linear,Enum.EasingDirection.Out,0,false,Conductor.crochet*0.001),{ImageTransparency = 1})
		tw:Play()
		tw.Completed:connect(function()
			thing:destroy()
			pcall(game.Destroy,tw)
		end)
		
		local miliseconds = game.ReplicatedStorage.Misc.miliseconds:Clone()
		miliseconds.Visible = player.Input.ShowMS.Value
		miliseconds.Parent = sideToGoIn
		miliseconds.Size = UDim2.new(0.145*mult,0, 0.044*mult,0)
		miliseconds.Rotation = (main.Rotation >= 90) and 180 or 0
		miliseconds.Text = round(ms,2).." ms"
		
		if ms < 0 then miliseconds.TextColor3 = Color3.fromRGB(255, 61, 61) else miliseconds.TextColor3 = Color3.fromRGB(120, 255, 124) end
		
		if (player.Input.Downscroll.Value) then
			miliseconds:SetAttribute("Acceleration",Vector2.new(0,-550))
			miliseconds:SetAttribute("Velocity",Vector2.new(RNG:NextInteger(0,10),RNG:NextInteger(140,175)))
		else
			miliseconds:SetAttribute("Acceleration",Vector2.new(0,550))
			miliseconds:SetAttribute("Velocity",Vector2.new(RNG:NextInteger(0,10),-RNG:NextInteger(140,175)))
		end
		
		table.insert(ratingLabels,miliseconds)

		if player.Input.CenterRatings.Value then
			miliseconds.Position = UDim2.new(0.5, 0,0.36, 0)
		end
		
		local tw2 = game:service'TweenService':Create(miliseconds,TweenInfo.new(.2,Enum.EasingStyle.Linear,Enum.EasingDirection.Out,0,false,Conductor.crochet*0.001),{TextTransparency = 1, TextStrokeTransparency = 1})
		tw2:Play()
		tw2.Completed:connect(function()
			miliseconds:destroy()
			pcall(game.Destroy,tw2)
		end)
	end

	if not ms then
		ms = variant
		if ms <= TimingWindowStuff["Marvelous"] and player.Input.ShowMarvelous.Value then 
			variant = "Marvelous"
		elseif ms <= TimingWindowStuff["Sick"] then 
			variant = "Sick"
		elseif ms <= TimingWindowStuff["Good"] then
			variant = "Good"
		elseif ms <= TimingWindowStuff["Ok"] then
			variant = "Ok"
		elseif ms <= TimingWindowStuff["Bad"] then
			variant = "Bad"
		end
	end
end

--// Animations

local oldtrack
local p2oldtrack
local currentAnimationNumber = 0

local function animate(key)
	local direction = key
	if specialSong then
		if nineKey then
			if direction == "A" or direction == "H" then direction = "Left" end
			if direction == "S" or direction == "J" then direction = "Down" end
			if direction == "D" or direction == "K" or direction == "Space" then direction = "Up" end
			if direction == "F" or direction == "L" then direction = "Right" end
		elseif sixKey or sevenKey then
			if direction == "S" or direction == "J" then direction = "Left" end
			if direction == "D" or direction == "Space" then direction = "Up" end
			if direction == "K" then direction = "Down" end
			if direction == "F" or direction == "L" then direction = "Right" end
		elseif fiveKey then
			if direction == "D" then direction = "Left" end
			if direction == "F" or direction == "Space" then direction = "Up" end
			if direction == "J" then direction = "Down" end
			if direction == "K" then direction = "Right" end
		elseif SongNoteConvert and SongNoteConvert.getAnimationDirection then
			direction = SongNoteConvert.getAnimationDirection(direction)
		end
	end

	if anifold:FindFirstChild(direction) then
		local correctedDirection = (side.Name == 'L' and direction or (if direction == 'Right' then 'Left' else if direction == 'Left' then 'Right' else direction))

		local literalanimation = anifold[correctedDirection]
		local track = _G.Animations[correctedDirection] --animswitching and _G.Animations[correctedDirection] or animations[correctedDirection]
		track.Looped = false
		track.TimePosition = 0
		track.Priority = Enum.AnimationPriority.Movement --// set to Action if things break

		if oldtrack and oldtrack ~= track then 
			oldtrack:Stop(0) 
		end
		oldtrack = track

		local p2track = p2animations[correctedDirection]

		if p2track then
			local p2literalanimation = anifold.Other[correctedDirection]
			p2track.Looped = false
			p2track.TimePosition = 0
			p2track.Priority = Enum.AnimationPriority.Movement --// set to Action if things break

			if p2oldtrack and p2oldtrack ~= p2track then 
				p2oldtrack:Stop(0) 
			end
			p2oldtrack = p2track
		end

		task.spawn(function()
			local length = (track.Length) - 0.15
			currentAnimationNumber += 1
			local num = currentAnimationNumber
			while myKeysDown[key] and (currentAnimationNumber == num) do
				track:Play(0)

				if p2track then
					p2track:Play(0)
				end
				
				for i, icon in iconData do
					if typeof(icon) == "string" then continue end
					if (i == 1 and side.Name == 'R') then continue end
					if (i == 2 and side.Name == 'L') then continue end
					
					local a = nil
					if icon.Animations then
						for key, anim in icon.Animations do
							if key == correctedDirection then
								a = anim
								break
							end
						end
					end
					
					if a then
						icon:PlayAnimation(correctedDirection)
					end
				end

				task.wait(0.1)
			end

			task.wait(length)
			if num == currentAnimationNumber then 
				track:Stop(0) 
				
				for i, icon in iconData do
					if typeof(icon) == "string" then continue end
					if (i == 1 and side.Name == 'R') then continue end
					if (i == 2 and side.Name == 'L') then continue end

					icon:PlayAnimation("Neutral")
				end
				
				--track:AdjustWeight(0)
				if (ui.Side.Value == ui.PlayerSide.Value) and (player.Input.MoveOnHit.Value) then
					local side = ui.Side.Value
					local bg = workspace.ClientBG:FindFirstChildOfClass("Model")
					local cpoint = (bg and bg:FindFirstChild("cameraPoints")) and bg.cameraPoints:FindFirstChild(side) or stage.CameraPoints:FindFirstChild(side) or stage.CameraPoints.C
					local modchartfile = (songholder:FindFirstChild("Modchart") and songholder.Modchart:IsA("ModuleScript")) and modchartsEnabled and require(songholder.Modchart)
					if modchartfile and modchartfile.CameraReset then 
						modchartfile.CameraReset()	
					end

					if modchartfile and modchartfile.OverrideCamera then return end

					TS:Create(workspace.CurrentCamera, TweenInfo.new(player.Input.MoveSpeed.Value, easeStyle, Enum.EasingDirection.Out), {CFrame = cpoint.CFrame}):Play()
				end

				if p2track then
					p2track:Stop(0)
				end
			end

		end)
	end
end

--// set song speed
if not tonumber(song.speed) then song.speed = 2.8 end
local origSongSpeed = song.speed
song.speed = (player.Input.ScrollSpeedChange.Value) and (player.Input.ScrollSpeed.Value+1.5) or (song.speed or 3.3)

if specialSong then
	local mult = 1/4
	if fiveKey then
		mult = 1/4.02
	elseif sixKey then
		mult = 1/4.04
	elseif sevenKey then
		mult = 1/4.24
	elseif nineKey then
		mult = 1/4.36
	end
	song.speed = song.speed / (0.25/mult)
end

if p2idletrack then
	p2idletrack:AdjustSpeed(song.speed)
	idletrack:AdjustSpeed(song.speed)
	p2idletrack.Looped = true
	idletrack.Looped = true
	p2idletrack.Priority = Enum.AnimationPriority.Idle
	idletrack.Priority = Enum.AnimationPriority.Idle
	idletrack:Play()
	p2idletrack:Play()
else
	idletrack:AdjustSpeed(song.speed)
	idletrack.Looped = true
	idletrack.Priority = Enum.AnimationPriority.Idle
	idletrack:Play()
end

local maxdist = 0.75 * song.speed
config.MaxDist.Value = maxdist

local modchartfile = (songholder:FindFirstChild("Modchart") and songholder.Modchart:IsA("ModuleScript")) and modchartsEnabled and require(songholder.Modchart)

--// hit sound

local hitSound = Instance.new("Sound")
hitSound.Name = "HitSound"
hitSound.Parent = ui
hitSound.SoundId = "rbxassetid://"..player.Input.HitSoundsValue.Value or "rbxassetid://3581383408"
hitSound.Volume = player.Input.HitSoundVolume.Value

local function ghostcheck(direction)
	local hit = nil
	for _, arrow in ipairs(side.Arrows.IncomingNotes[direction]:GetChildren()) do
		if arrow.Name == direction or string.split(arrow.Name, "_")[1] == direction then
			local dist = math.abs(string.split(arrow:GetAttribute("NoteData"), "~")[1] - (Util.tomilseconds(config.TimePast.Value) + offset))
			if dist <= TimingWindowStuff["Ghost"] and arrow.Frame.Arrow.Visible then
				if not hit then
					hit = arrow
				else
					if (arrow.AbsolutePosition - arrow.Parent.AbsolutePosition).magnitude <= (hit.AbsolutePosition - arrow.Parent.AbsolutePosition).magnitude then
						hit = arrow
					end
				end
			end
		end
	end
	if not hit then return true end
end

local function onclosesthit(input, direction, opponentData, oppositeSide, oppositeSideMiliseconds)
	if not direction then
		return
	end

	--task.spawn(function()
	--	repeat wait() until input.UserInputState == Enum.UserInputState.End
	--	print('End!')
	--end)

	-- wrapper
	--if typeof(input) == 'EnumItem' then
	--	input = {UserInputState = input}
	--end

	if oppositeSide then
		otherplayerKeyDown[direction] = input.UserInputState == Enum.UserInputState.Begin and true or false
		oppositeSide = main:FindFirstChild(ui.PlayerSide.Value == "L" and "R" or "L")
	end

	if not oppositeSide then
		myKeysDown[direction] = (input.UserInputState == Enum.UserInputState.Begin) and true or false
	end

	if config.CantHitNotes.Value then return end
	if not specialSong and config.DisabledLanes[direction].Value then return end

	local InputType = hasGimmickNotes == true and "Bloxxin" or player.Input.InputType.Value
	local hit = nil

	--// Find Hit
	if (not myKeysDown[direction]) and (input.UserInputState ~= Enum.UserInputState.Begin) then return end
	if not side.Arrows.IncomingNotes:FindFirstChild(direction) then return end

	for _, arrow in ipairs((oppositeSide or side).Arrows.IncomingNotes[direction]:GetChildren()) do
		if arrow.Name == direction or string.split(arrow.Name, "_")[1] == direction then
			local noteData = arrow:GetAttribute("NoteData")
			local dist = string.split(noteData, "~")[1] - (Util.tomilseconds(config.TimePast.Value) + offset)

			if not oppositeSide then
				if arrow.Frame.Arrow.Visible and not arrow.Frame.Arrow:GetAttribute("hit") and math.abs(dist) <= TimingWindowStuff["Bad"] then
					if not hit then
						hit = arrow
					else
						if InputType == "Bloxxin" then
							if (arrow.AbsolutePosition - arrow.Parent.AbsolutePosition).magnitude <= (hit.AbsolutePosition - arrow.Parent.AbsolutePosition).magnitude then
								hit = arrow
							end
						else
							local hitDist = string.split(noteData, "~")[1] - (Util.tomilseconds(config.TimePast.Value) + offset)
							if dist < hitDist then
								hit = arrow
							end
						end
					end
				end
			else
				if noteData == opponentData then
					hit = arrow
					break
				end
			end
		end
	end

	--print('Checked for arrows')

	if config.GhostTappingEnabled.Value and not hit and not oppositeSide then
		if ghostcheck(direction) then
			hit = "ghost"
		end
	end

	--print(input.UserInputState)

	--print('Hi')

	--// Animate

	local glowtime = 0.175
	local fakehit = modchartfile and modchartfile.FakeHit
	
	if not oppositeSide then

		---------------------------------------- Overlay and animation

		animate(direction)

		---------------------------------------- Handle hits
		if hit and hit ~= 'ghost' then
			--// ghost tapping smh

			--if hit == "ghost" then

			--	----// lots of notes are in 6k & 9k songs, so we need to have a custom value set.. >_<
			--	--local size = 1*player.Input.ArrowSize.Value+0.3

			--	--if sixKey then size = 1 end
			--	--if sevenKey or nineKey then size = 0.5 end
			--	--if SongNoteConvert and SongNoteConvert.newKeys then size = 1 end

			--	--local tween = TS:Create(arrow,TweenInfo.new(0.05,Enum.EasingStyle.Linear,Enum.EasingDirection.In,0,false,0),
			--	--	{Size=UDim2.new(size/1.1,0,size/1.1,0)})
			--	--tween:Play()
			--	--repeat 
			--	--	Util.wait()
			--	--	if input.UserInputState == Enum.UserInputState.End then 
			--	--		myKeysDown[direction] = false
			--	--	end
			--	--until not myKeysDown[direction]
			--	--TS:Create(arrow,TweenInfo.new(0.05,Enum.EasingStyle.Quint,Enum.EasingDirection.Out,0,false,0),
			--	--	{Size=UDim2.new(size,0,size,0)}):Play()

			--	--arrow.Overlay.Visible = false
			--	--return
			--else
			if hit:FindFirstChild("HitSound") then
				Util.PlaySound(hit.HitSound.Value,hit.HitSound.parent,2.25)
			elseif player.Input.HitSounds.Value == true then
				Util.PlaySound(hitSound)
			end

			local miliseconds = string.split(hit:GetAttribute("NoteData"), "~")[1] - (Util.tomilseconds(config.TimePast.Value) + offset)
			local DIST = math.abs(miliseconds)
			local hitName = string.split(hit.Name, "_")[1]

			if DIST <= TimingWindowStuff["Sick"] then
				noteSplash(hitName)
			end

			if player.Input.ScoreBop.Value then
				if player.Input.VerticalBar.Value then
					for i,v in pairs(ui.SideContainer:GetChildren()) do
						if v.ClassName ~= "TextLabel" then continue end
						v.Size = UDim2.new(originalTextSize[v.Name].X.Scale * 1.1, 0,originalTextSize[v.Name].Y.Scale * 1.1, 0)
						TS:Create(v, TweenInfo.new(0.3), {Size = originalTextSize[v.Name]}):Play()
					end
				else
					ui.LowerContainer.Stats.Size = UDim2.new(originalTextSize["Stats"].X.Scale * 1.1, 0,originalTextSize["Stats"].Y.Scale * 1.1, 0)
					TS:Create(ui.LowerContainer.Stats, TweenInfo.new(0.3), {Size = originalTextSize["Stats"]}):Play()
				end
			end

			moveCamera(hitName)

			--table.insert(accuracy, 1, (1.2 - math.abs(hit.Position.Y.Scale)) / 1.2 * 100)
			combo += 1
			updateStats()
			if modchartfile and modchartfile.UpdateStats then
				modchartfile.UpdateStats(ui)
			end
			
			if modchartfile and modchartfile.OnHit then
				modchartfile.OnHit(ui, highcombo, combo, hitName, actualAccuracy, direction)
			end

			userinput:FireServer(
				hit, direction .. "|0|" .. Util.tomilseconds(config.TimePast.Value) + offset .. "|" .. hit.Position.Y.Scale .. "|" .. hit:GetAttribute("NoteData") .. "|" .. hit.Name  .. "|" .. hit:GetAttribute("Length") ..  "|" .. tostring(hit.HellNote.Value == false and "0" or "1"))

			table.insert(hitGraph,{
				["ms"] = miliseconds,
				["songPos"] = ui.Config.TimePast.Value,
				["miss"] = false
			})

			table.insert(npsData,{
				["time"] = tonumber(string.split(hit:GetAttribute("NoteData"), "~")[1])
			})
			
			if (fakehit)  then
				hit.Frame.Arrow:SetAttribute("hit",true)
			else
				hit.Frame.Arrow.Visible = false
			end
			
			if not myKeysDown[direction] then return end

			side.Glow[direction].Arrow.ImageTransparency = 1
			if SongNoteConvert and SongNoteConvert.Glow then
				SongNoteConvert.Glow(direction,true)
			else
				side.Glow[direction].Arrow.Visible = true
			end

			if side.Glow[direction].Arrow.ImageTransparency == 1 then
				local done = false

				if not player.Input.DisableArrowGlow.Value and not AnimatedReceptors[side.Name][direction] then
					local c c = RUNS.RenderStepped:Connect(function()
						if done then 
							c:Disconnect()
							side.Glow[direction].Arrow.ImageTransparency = 1
							return
						end
						side.Glow[direction].Arrow.ImageTransparency = (0.2 - math.cos(tick() * 10 * math.pi) / 6) + (side.Arrows[direction].ImageTransparency / 1.25)
					end)
				elseif not player.Input.DisableArrowGlow.Value and AnimatedReceptors[side.Name][direction] then
					if done then 
						c:Disconnect()
						AnimatedReceptors[side.Name][direction]:PlayAnimation("Receptor")
						return
					end
					AnimatedReceptors[side.Name][direction]:PlayAnimation("Glow")
				end

				local bary = hit.Frame.Bar.Size.Y.Scale

				if bary > 0 then --// check for a hold note
					local hellnote = hit.HellNote.Value
					--miliseconds = (string.split(hit:GetAttribute("NoteData"), "~")[1] + hit:GetAttribute("SustainLength")) - (Util.tomilseconds(config.TimePast.Value) + offset)
					DIST = math.abs(miliseconds)
					
					
					repeat 
						task.wait()
						local y = hit.Position.Y.Scale
						if specialSong then
							local mult = 1/4
							if fiveKey then
								mult = 1/4.02
							elseif sixKey then
								mult = 1/4.04
							elseif sevenKey then
								mult = 1/4.24
							elseif nineKey then
								mult = 1/4.36
							end
							y = y * (0.25/mult)
						end
						if y < 0 and hit:FindFirstChild("Frame") then
							if (fakehit)  then
								-- nothing
							else
								hit.Frame.Bar.Size = UDim2.new(player.Input.BarSize.Value, 0, math.clamp(bary + y, 0, 20), 0)
								hit.Frame.Bar.Position = UDim2.new(0.5,0,0.5 - y,0)
							end
						end
						--if input.UserInputState == Enum.UserInputState.End then 
						--	myKeysDown[direction] = false
						--end
					until not myKeysDown[direction]
					userinput:FireServer(
						hit, direction .. "|1|" .. Util.tomilseconds(config.TimePast.Value) + offset .. "|" .. hit.Position.Y.Scale .. "|" .. hit:GetAttribute("NoteData") .. "|" .. hit.Name  .. "|" .. hit:GetAttribute("Length") ..  "|" .. tostring(hellnote == false and "0" or "1"))

					local percentwithin = math.clamp(math.abs(hit.Position.Y.Scale) / hit:GetAttribute("Length"), 0, 1)
					local dist = 1 - percentwithin
					local realDist = DIST + (hit:GetAttribute("SustainLength")*dist)

					if dist <= maxdist/10 then
						hitIndicator((DIST <= TimingWindowStuff["Marvelous"] and player.Input.ShowMarvelous.Value) and "Marvelous" or "Sick", miliseconds)
						table.insert(accuracy, 1, 100)
						if (DIST <= TimingWindowStuff["Marvelous"] and player.Input.ShowMarvelous.Value) then
							marv += 1
						else	
							sick += 1
						end
					elseif dist <= maxdist/6 then
						hitIndicator("Good", miliseconds)
						table.insert(accuracy, 1, 90)
						good += 1
						if ui:GetAttribute("Perfect") then player.Character.Humanoid.Health = 0 end
					elseif dist <= maxdist then
						hitIndicator("Bad", miliseconds)
						table.insert(accuracy, 1, 60)
						bad += 1
						if ui:GetAttribute("Perfect") then player.Character.Humanoid.Health = 0 end
					end; 
					updateStats()
					if modchartfile and modchartfile.UpdateStats then
						modchartfile.UpdateStats(ui)
					end
					
					if (fakehit) then
						--nothing
					else
						hit.Visible = false
					end
				else
					local scale = 1

					-- hitboxes smaller for hell notes, all of em
					if hit.HellNote.Value ~= false then
						--scale = 0.5
					end

					if DIST <= TimingWindowStuff["Marvelous"] * scale and player.Input.ShowMarvelous.Value then
						hitIndicator("Marvelous", miliseconds)
						table.insert(accuracy, 1, 100)
						marv += 1
					elseif DIST <= TimingWindowStuff["Sick"] * scale then
						hitIndicator("Sick", miliseconds)
						table.insert(accuracy, 1, 100)
						sick += 1
					elseif DIST <= TimingWindowStuff["Good"] * scale then
						hitIndicator("Good", miliseconds)
						table.insert(accuracy, 1, 90)
						good += 1
						if ui:GetAttribute("Perfect") then player.Character.Humanoid.Health = 0 end
					elseif DIST <= TimingWindowStuff["Ok"] * scale then
						hitIndicator("Ok", miliseconds)
						table.insert(accuracy, 1, 75)
						ok += 1
						if ui:GetAttribute("Perfect") then player.Character.Humanoid.Health = 0 end
					elseif DIST <= TimingWindowStuff["Bad"] * scale then
						hitIndicator("Bad", miliseconds)
						table.insert(accuracy, 1, 60)
						bad += 1
						if ui:GetAttribute("Perfect") then player.Character.Humanoid.Health = 0 end
					end; 
					updateStats()
					if modchartfile and modchartfile.UpdateStats then
						modchartfile.UpdateStats(ui)
					end

					repeat 
						Util.wait()
						--if input.UserInputState == Enum.UserInputState.End then 
						--	myKeysDown[direction] = false
						--end
					until not myKeysDown[direction]
					if (fakehit) then
						-- nothing
					else
						hit.Visible = false
					end
				end

				done = true
			end
			
			if SongNoteConvert and SongNoteConvert.Glow then
				SongNoteConvert.Glow(direction,false)
			else
				side.Glow[direction].Arrow.Visible = false
			end
		end

		---------- Wrap up

		if not myKeysDown[direction] then return end


		--print(hit)
		--pcall(function()
		--	print(hit:GetFullName())
		--end)

		if hit ~= 'ghost' then
			--print('What')
			--print(hit)
			userinput:FireServer(
				"missed", direction .. "|" .. "0")

			table.insert(accuracy, 1, 0)
			misses += 1
			combo = 0
			updateStats()
			if modchartfile and modchartfile.UpdateStats then
				modchartfile.UpdateStats(ui)
			end

			table.insert(hitGraph,{
				["ms"] = 0,
				["songPos"] = ui.Config.TimePast.Value,
				["miss"] = true
			})

			--// modchart stuff
			if modchartfile and modchartfile.OnMiss then
				modchartfile.OnMiss(ui, misses, actualAccuracy, direction)
			end

			--// sudden death modifier
			if ui:GetAttribute("SuddenDeath") and config.TimePast.Value > 5
			then player.Character.Humanoid.Health = 0 end

			--// Deprecated Note Miss Sound

			local miss = ui.Sounds:GetChildren()[math.random(1,#ui.Sounds:GetChildren())]:Clone()
			miss.Name = "MissSound"
			miss.Parent = ui
			miss.Volume = player.Input.MissVolume.Value or 0.3
			
			if player.Input.MissSoundValue.Value ~= 0 then
				miss.SoundId = "rbxassetid://"..player.Input.MissSoundValue.Value
			end
			miss:Play()
			
			--// Custom Miss Sound

			--[[local miss = Instance.new("Sound")
			miss.Name = "MissSound"
			miss.Parent = ui.Temp
			miss.SoundId = player.Input.MissSoundValue.Value > 0 and "rbxassetid://"..player.Input.MissSoundValue.Value or ui.Sounds:GetChildren()[math.random(1,#ui.Sounds:GetChildren())].SoundId
			miss.Volume = player.Input.MissVolume.Value or 0.3
			miss:Play()]]
		end

		--// Overlay
		local arrow = side.Arrows[direction]
		myKeysDown[direction] = true
		if AnimatedReceptors[side.Name][direction] then
			AnimatedReceptors[side.Name][direction]:PlayAnimation("Press")
		else
			if arrow:FindFirstChild("Overlay") then
				arrow.Overlay.Visible = true
			else
				SongNoteConvert.Pressed(direction,true,ui)
			end
		end

		local size = 1
		
		if sevenKey then size = 0.85 end
		if nineKey then size = 0.7 end
		if SongNoteConvert then size = SongNoteConvert.CustomArrowSize or 1 end
		
		size = size * player.Input.ArrowSize.Value

		TS:Create(arrow,TweenInfo.new(0.05,Enum.EasingStyle.Linear,Enum.EasingDirection.In,0,false,0),
			{Size = hit=='ghost' and UDim2.new(size/1.05,0,size/1.05,0) or UDim2.new(size/1.25,0,size/1.25,0)}):Play()
		--tween:Play()

		repeat 
			task.wait()
		until not myKeysDown[direction]

		if AnimatedReceptors[side.Name][direction] then
			AnimatedReceptors[side.Name][direction]:PlayAnimation("Receptor")
		else
			if arrow:FindFirstChild("Overlay") then
				arrow.Overlay.Visible = false
			else
				SongNoteConvert.Pressed(direction,false,ui)
			end
		end

		TS:Create(arrow,TweenInfo.new(0.05,Enum.EasingStyle.Quint,Enum.EasingDirection.Out,0,false,0),
			{Size=UDim2.new(size,0,size,0)}):Play()

		----------------------------------- Opposite side hit
	elseif hit then	
		moveCamera(direction, true)

		local side = oppositeSide
		
		if (fakehit)  then
			hit.Frame.Arrow:SetAttribute("hit",true)
		else
			hit.Frame.Arrow.Visible = false
		end
		if input.UserInputState ~= Enum.UserInputState.Begin then return end

		side.Glow[direction].Arrow.ImageTransparency = 1
		if SongNoteConvert and SongNoteConvert.Glow then
			SongNoteConvert.Glow(direction,true)
		else
			side.Glow[direction].Arrow.Visible = true
		end
		
		if side.Glow[direction].Arrow.ImageTransparency == 1 then
			local done = false

			if not player.Input.DisableArrowGlow.Value and not AnimatedReceptors[side.Name][direction] then
				local c c = RUNS.RenderStepped:Connect(function()
					if done then 
						c:Disconnect()
						side.Glow[direction].Arrow.ImageTransparency = 1
						return
					end
					side.Glow[direction].Arrow.ImageTransparency = 0.2 - math.cos(tick() * 10 * math.pi) / 6
				end)
			elseif not player.Input.DisableArrowGlow.Value and AnimatedReceptors[side.Name][direction] then
				if done then 
					c:Disconnect()
					AnimatedReceptors[side.Name][direction]:PlayAnimation("Receptor")
					return
				end
				AnimatedReceptors[side.Name][direction]:PlayAnimation("Glow")
			end
			
			local bary = hit.Frame.Bar.Size.Y.Scale
			if bary > 0 then
				--// Check Arrow Y Under 0
				local start = tick()
				repeat
					Util.wait()
					local y = hit.Position.Y.Scale
					if specialSong then
						local mult = 1/4
						if fiveKey then
							mult = 1/4.02
						elseif sixKey then
							mult = 1/4.04
						elseif sevenKey then
							mult = 1/4.24
						elseif nineKey then
							mult = 1/4.36
						end
						y = y * (0.25/mult)
					end
					if y < 0 then
						if (fakehit) then
							-- nah
						else
							hit.Frame.Bar.Size = UDim2.new(player.Input.BarSize.Value, 0, math.clamp(bary + y, 0, 20), 0)
							hit.Frame.Bar.Position = UDim2.new(0.5,0,0.5 - y,0)
						end
					end
				until not otherplayerKeyDown[direction] or hit.Frame.Bar.Size.Y.Scale == 0 or tick() - start > 7.5 -- if more than 7.5 seconds, turn off glowing arrow. this is just incase something goes wrong.
			else
				Util.wait(glowtime)
			end

			done = true
		end
		
		if SongNoteConvert and SongNoteConvert.Glow then
			SongNoteConvert.Glow(direction,false)
		else
			side.Glow[direction].Arrow.Visible = false
		end

		if modchartfile and modchartfile.OpponentHit then
			modchartfile.OpponentHit(ui, direction)
		end
		--// hitIndicator(oppositeSideMiliseconds)
	end
end

local inputconnection, inputconnection2, oplrhitconnection --// hi

local lastInputType = _G.LastInput.Value

if lastInputType == Enum.UserInputType.Touch then
	script.Device.Value = "Mobile"
	Util.wait(.2)

	-- handle mobile input
	--local MobileKeysHeld = {}

	--for _, button in ipairs(ui.MobileButtons.Container:GetChildren()) do
	--	if button:IsA("ImageButton") then

	--	end
	--end

	for _, button in ipairs(ui.MobileButtons.Container:GetChildren()) do
		if button:IsA("ImageButton") then
			button.MouseButton1Down:Connect(function()
				--print('Button down', button.Name)
				onclosesthit({UserInputState = Enum.UserInputState.Begin}, button.Name)
			end)
			button.MouseButton1Up:Connect(function()
				--print('Button up', button.Name)
				onclosesthit({UserInputState = Enum.UserInputState.End}, button.Name)
			end)
		end
	end
	script.Parent.MobileButtons.Visible = true
elseif lastInputType == Enum.UserInputType.Keyboard then
	script.Device.Value = "Computer"

	local function inputFunction(input, typing)
		if typing then return end
		local SetKeybinds = player.Input.Keybinds
		if SongNoteConvert and SongNoteConvert.getDirection then
			-- if special song bind
			local direction = SongNoteConvert.getDirection(input.KeyCode, SetKeybinds)
			if direction then 
				onclosesthit(input, direction)
			end
		elseif specialSong then
			-- 6k+ binds
			for _, setting: StringValue in ipairs(SetKeybinds:GetChildren()) do
				if (setting:GetAttribute('ExtraKey')) and (input.KeyCode.Name == setting.Value) then
					onclosesthit(input, RLToKey[setting.Name])
					break
				end
			end
		else
			-- normal key binds
			for _, setting: StringValue in ipairs(SetKeybinds:GetChildren()) do
				if (not setting:GetAttribute('ExtraKey')) and (input.KeyCode.Name == setting.Value or (setting:GetAttribute("SecondaryKey") and input.KeyCode.Name == setting:GetAttribute("Key"))) then
					local direction = setting.Name
					if (setting:GetAttribute("SecondaryKey")) then direction = setting:GetAttribute("Key") end
					--print("Hey angus "..tostring(direction)..", and this is a secondary: "..tostring(setting:GetAttribute("SecondaryKey") and "true" or "false"))
					onclosesthit(input, setting:GetAttribute("SecondaryKey") and setting:GetAttribute("Key") or setting.Name)
					break
				end
			end
		end
	end

	inputconnection = UIS.InputBegan:connect(inputFunction)
	inputconnection2 = UIS.InputEnded:connect(inputFunction)
elseif lastInputType == Enum.UserInputType.Gamepad1 then
	script.Device.Value = "Controller"

	local function inputFunction(input, typing)

		--print('Hit', input.KeyCode)

		local SetKeybinds = player.Input.XBOXKeybinds

		-- if special song bind
		if SongNoteConvert and SongNoteConvert.getDirection then
			local direction = SongNoteConvert.getDirection(input.KeyCode, SetKeybinds)
			if direction then 
				onclosesthit(input, direction)
			end
		elseif specialSong then

			-- 6k+ binds
			for _, setting: StringValue in ipairs(SetKeybinds:GetChildren()) do
				if (setting:GetAttribute('ExtraKey')) and (input.KeyCode.Name == setting.Value) then
					onclosesthit(input, RLToKey[setting.Name:sub(12, -1)])
					break
				end
			end
		else
			-- normal key binds
			for _, setting: StringValue in ipairs(SetKeybinds:GetChildren()) do
				if (not setting:GetAttribute('ExtraKey')) and (input.KeyCode.Name == setting.Value) then
					onclosesthit(input, setting.Name:sub(12, -1))
					--print('Hit', setting.Name:sub(6, -1))
					break
				end
			end
		end
	end

	inputconnection = UIS.InputBegan:connect(inputFunction)
	inputconnection2 = UIS.InputEnded:connect(inputFunction)
end

if ui.PlayerSide.Value == "L" then
	oplrhitconnection = stage.Events.Player2Hit.OnClientEvent:Connect(function(data)
		data = string.split(data, "|")
		local direction, state, notea, noteb, ms = data[1], data[2], string.gsub(data[3], "~", "|"), data[4], tonumber(data[5])
		onclosesthit({UserInputState = state == "0" and Enum.UserInputState.Begin or Enum.UserInputState.End}, direction, notea.."~"..noteb, true, ms)
	end)
else
	oplrhitconnection = stage.Events.Player1Hit.OnClientEvent:Connect(function(data)
		data = string.split(data, "|")
		local direction, state, notea, noteb, ms = data[1], data[2], string.gsub(data[3], "~", "|"), data[4], tonumber(data[5])
		onclosesthit({UserInputState = state == "0" and Enum.UserInputState.Begin or Enum.UserInputState.End}, direction, notea.."~"..noteb, true, ms)
	end)
end

ui.Side.Changed:Connect(function()
	if modchartfile and modchartfile.OverrideCamera then return end
	local side = ui.Side.Value
	local bg = workspace.ClientBG:FindFirstChildOfClass("Model")
	local cpoint = (bg and bg:FindFirstChild("cameraPoints")) and bg.cameraPoints:FindFirstChild(side) or stage.CameraPoints:FindFirstChild(side) or stage.CameraPoints.C
	TS:Create(workspace.CurrentCamera,TweenInfo.new(player.Input.CameraSpeed.Value,easeStyle,Enum.EasingDirection.Out,0,false,0),
		{CFrame=cpoint.CFrame}):Play()
end)

--// backgrounds

local bg = false

if (player.Input.HideMap.Value) and (not songholder:FindFirstChild("ForceBackgrounds")) then
	local flash = Instance.new("Frame")
	flash.Parent = ui
	flash.Position = UDim2.new(0,0, 0,0)
	flash.BackgroundColor3 = Color3.fromRGB(0,0,0)
	flash.Size = UDim2.new(1,0, 1,0)
	flash.BackgroundTransparency = 1
	
	bg = true
	player.Character:WaitForChild("Humanoid").Died:Connect(function()
		game.ReplicatedStorage.Events.UnloadBackground:Fire()
	end)

	TS:Create(flash, TweenInfo.new(0.4), {BackgroundTransparency = 0}):Play()
	task.wait(0.4)

	task.spawn(function()
		TS:Create(flash, TweenInfo.new(0.4), {BackgroundTransparency = 1}):Play()
		task.wait(0.4)
		flash:Destroy()
	end)

	for _, part in pairs(workspace:GetDescendants()) do
		if part:IsDescendantOf(stage) or part:IsDescendantOf(workspace.Misc.ActualShop) then continue end
		if stage.Seat.Occupant and part:IsDescendantOf(stage.Seat.Occupant.Parent) then continue end
		if stage.Config.Player1.Value and part:IsDescendantOf(stage.Config.Player1.Value.Character) then continue end
		if stage.Config.Player2.Value and part:IsDescendantOf(stage.Config.Player2.Value.Character) then continue end

		if part:IsA("BasePart") or part:IsA("Decal") or part:IsA("Texture") then
			part.Transparency = 1
		elseif part:IsA("GuiObject") then
			part.Visible = false
		elseif part:IsA("Beam") or part:IsA("ParticleEmitter") then
			part.Enabled = false
		end
	end

	local background = game.ReplicatedStorage.Misc.DarkVoid:Clone()
	background.Parent = workspace.ClientBG
	background:SetPrimaryPartCFrame(stage.BackgroundPart.CFrame)

	for _, thing in pairs(game.Lighting:GetChildren()) do
		thing:Destroy()
	end

	for _, thing in pairs(background.Lighting:GetChildren()) do
		thing = thing:Clone()
		thing.Parent = game.Lighting
	end

	stage.Misc.Stereo.Speakers.Transparency = 1
	for _, thing in pairs(stage.Fireworks:GetChildren()) do
		thing.Transparency = 1
	end
end

events.ChangeBackground.Event:Connect(function(Stage, Background, stereo)
	if ((not player.Input.Backgrounds.Value) or (player.Input.HideMap.Value)) and (not songholder:FindFirstChild("ForceBackgrounds")) then return end

	--// cache backgrounds
	local backgrounds = game.ReplicatedStorage.Backgrounds
	local background = backgrounds:FindFirstChild(Background) and backgrounds[Background]:Clone() or game.ReplicatedStorage.Events.Backgrounds:InvokeServer("Load", Stage, Background, songholder)
	if not backgrounds:FindFirstChild(Background) then background:Clone().Parent = backgrounds end

	--// get rid of pre-existing backgrounds
	for _, thing in pairs(workspace.ClientBG:GetChildren()) do thing:Destroy() end

	if stage.Config.CleaningUp.Value then return end
	if not bg then
		--// fade to black upon starting a match
		bg = true
		local flash = Instance.new("Frame")

		flash.Parent = ui
		flash.Position = UDim2.new(0,0, 0,0)
		flash.BackgroundColor3 = Color3.fromRGB(0,0,0)
		flash.Size = UDim2.new(1,0, 1,0)
		flash.BackgroundTransparency = 1

		TS:Create(flash, TweenInfo.new(0.4), {BackgroundTransparency = 0}):Play()
		task.wait(0.4)

		task.spawn(function()
			TS:Create(flash, TweenInfo.new(0.4), {BackgroundTransparency = 1}):Play()
			task.wait(0.4)
			flash:Destroy()
		end)

		--// make all the parts in workspace invisible
		for _, part in pairs(workspace:GetDescendants()) do
			if part:IsDescendantOf(stage) or part:IsDescendantOf(workspace.Misc.ActualShop) then continue end
			if stage.Seat.Occupant and part:IsDescendantOf(stage.Seat.Occupant.Parent) then continue end
			if stage.Config.Player1.Value and part:IsDescendantOf(stage.Config.Player1.Value.Character) then continue end
			if stage.Config.Player2.Value and part:IsDescendantOf(stage.Config.Player2.Value.Character) then continue end

			if part:IsA("BasePart") or part:IsA("Decal") or part:IsA("Texture") then
				part.Transparency = 1
			elseif part:IsA("GuiObject") then
				part.Visible = false
			elseif part:IsA("Beam") or part:IsA("ParticleEmitter") then
				part.Enabled = false
			end
		end
	end

	--// set speaker transparency
	stage.Misc.Stereo.Speakers.Transparency = stereo and 0 or 1
	for _, thing in pairs(stage.Fireworks:GetChildren()) do
		thing.Transparency = stereo and 0 or 1
	end

	--// put background in workspace
	background.Parent = workspace.ClientBG
	background:SetPrimaryPartCFrame(stage.BackgroundPart.CFrame)

	--// change lighting if there r changes needed
	if background:FindFirstChild("Lighting") then
		for _, thing in pairs(game.Lighting:GetChildren()) do
			thing:Destroy()
		end
		for _, thing in pairs(background.Lighting:GetChildren()) do
			if thing:IsA("StringValue") or thing:IsA("Color3Value") or thing:IsA("NumberValue") then
				local s,e = pcall(function()
					game.Lighting[thing.Name] = thing.Value
				end)
				if e then warn(e) end
			else
				thing = thing:Clone()
				thing.Parent = game.Lighting
			end
		end
	end

	--// run BG functions
	if background:FindFirstChild("ModuleScript") then
		local module = require(background.ModuleScript)
		task.spawn(module.BGFunction)
	end

	--// set camera points
	if background:FindFirstChild("cameraPoints") then
		cameraPoints.L.CFrame = background.cameraPoints.L.CFrame;
		cameraPoints.C.CFrame = background.cameraPoints.C.CFrame;
		cameraPoints.R.CFrame = background.cameraPoints.R.CFrame;
		if modchartfile and modchartfile.OverrideCamera then return end
		TS:Create(workspace.CurrentCamera, TweenInfo.new(player.Input.CameraSpeed.Value, easeStyle, Enum.EasingDirection.Out), {CFrame = background.cameraPoints.L.CFrame}):Play()
	end

	--// set player points
	if background:FindFirstChild("playerPoints") then
		local playerPoints = background.playerPoints

		local function setCframe(plr, point)
			if not plr then return end
			point = playerPoints:FindFirstChild("PlayerPoint"..point)
			if not point then return end

			local char = plr.Character
			if char then
				if char:FindFirstChild("char2") then
					local rig = char.char2:WaitForChild("Dummy")
					if not rig.PrimaryPart then repeat task.wait() until rig.PrimaryPart end
					local rigRoot = rig.PrimaryPart

					if not rigRoot:GetAttribute("YOffset") then rigRoot:SetAttribute("YOffset", rigRoot.Position.Y - char.PrimaryPart.Position.Y) end
					if not rigRoot:GetAttribute("OrientationOffset") then rigRoot:SetAttribute("OrientationOffset", rigRoot.Orientation.Y - char.PrimaryPart.Orientation.Y) end
					local yOffset = rigRoot:GetAttribute("YOffset")
					local orientationOffset = rigRoot:GetAttribute("OrientationOffset")

					rigRoot.CFrame = (point.CFrame + Vector3.new(0,yOffset,0))
					rigRoot.CFrame *= CFrame.Angles(0, math.rad(orientationOffset), 0)
				end

				if char:FindFirstChild("customrig") then
					local rig = char.customrig:WaitForChild("rig")
					if not rig.PrimaryPart then repeat task.wait() until rig.PrimaryPart end
					local rigRoot = rig.PrimaryPart

					if not rigRoot:GetAttribute("YOffset") then rigRoot:SetAttribute("YOffset", rigRoot.Position.Y - char.PrimaryPart.Position.Y) end
					if not rigRoot:GetAttribute("OrientationOffset") then rigRoot:SetAttribute("OrientationOffset", rigRoot.Orientation.Y - char.PrimaryPart.Orientation.Y) end
					local yOffset = rigRoot:GetAttribute("YOffset")
					local orientationOffset = rigRoot:GetAttribute("OrientationOffset")

					rigRoot.CFrame = (point.CFrame + Vector3.new(0,yOffset,0))
					rigRoot.CFrame *= CFrame.Angles(0, math.rad(orientationOffset), 0)
				end 

				if char then
					char.PrimaryPart.CFrame = point.CFrame --(point.CFrame + Vector3.new(0,y,0))
				end
				--char.DescendantAdded:Connect(function(d) if (not d:IsA("Model")) then return end setCframe(plr, point) end)
			end
		end

		local plr1 = stage.Config.Player1.Value
		local plr2 = stage.Config.Player2.Value
		local bot = stage:FindFirstChild("NPC")

		--// setCframe(bot, plr1 and playerPoints.PlayerPointB or playerPoints.PlayerPointA)
		--// setCframe(plr1, playerPoints.PlayerPointA)
		--// setCframe(plr2, playerPoints.PlayerPointB)

		-- no to the lines below !!!
		--// jjst kiddgin i kind of like the lines below
		-- me when tweens break

		task.spawn(function() 
			if modchartfile and modchartfile.STOP == true then return end -- STOP
			while (ui.Parent) and (background.Parent) do
				local plr1 = stage.Config.Player1.Value
				local plr2 = stage.Config.Player2.Value
				local bot = stage:FindFirstChild("NPC")

				setCframe(bot, plr1 and "B" or "A")
				setCframe(plr1, "A")
				setCframe(plr2, "B")
				task.wait(1)
			end
		end)

	end

end)

--// change backgrounds upon song select

if songholder:FindFirstChild("Background") then
	local player = ui:FindFirstAncestorOfClass("Player")
	if player then
		ui.Events.ChangeBackground:Fire(songholder.stageName.Value, songholder.Background.Value, songholder.Background.Stereo.Value)
	end
end

--// animate dummy if singleplayer

if stage.Config.SinglePlayerEnabled.Value and not songholder:FindFirstChild("NoNPC") then
	local opponentBot = require(ui.Modules.Bot) --// opponent bot for singleplayer
	opponentBot.Start(song.speed, side)
	opponentBot.Act(ui.PlayerSide.Value, bpm)
end

--// actually move the notes

local time = 1.5 --// client time variable

local noteDirections = {
	Left = {
		Offset = Vector2.new(0,256),
		Pos = .125,
	},

	Down = {
		Offset = Vector2.new(256,256),
		Pos = .375
	},

	Up = {
		Offset = Vector2.new(512,256),
		Pos = .625,
	},

	Right = {
		Offset = Vector2.new(768,256),
		Pos = .875
	},
}

local regularNoteStuffs = {
	Left = {Vector2.new(315,116), Vector2.new(77,77.8)};
	Down = {Vector2.new(925, 77), Vector2.new(78.5,77)};
	Up = {Vector2.new(925, 0), Vector2.new(78.5,77)};
	Right = {Vector2.new(238, 116), Vector2.new(77,78.5)}
}

local function check(note)
	if note.HellNote.Value then
		if specialSong and not SongNoteConvert then return end

		local Type = songholder:FindFirstChild("MineNotes") or songholder:FindFirstChild("GimmickNotes") or note:FindFirstChild("ModuleScript")
		local noteName = string.split(note.Name, "_")[1]

		if stage.Config.SinglePlayerEnabled.Value and (not player.Input.SoloGimmickNotesEnabled.Value) and (not songholder:FindFirstChild("ForcedGimmickNotes")) then
			note.HellNote.Value = false
			note.Name = noteName

			if note:GetAttribute("Side") == ui.PlayerSide.Value then
				if skinType:FindFirstChild("XML") then
					local XML = require(skinType.XML)
					XML.OpponentNoteInserted(note)
				else
					note.Frame.Arrow.ImageRectOffset = regularNoteStuffs[noteName][1]
					note.Frame.Arrow.ImageRectSize   = regularNoteStuffs[noteName][2]
				end
			else
				if otherSkinType:FindFirstChild("XML") then
					local XML = require(otherSkinType.XML)
					XML.OpponentNoteInserted(note)
				else
					note.Frame.Arrow.ImageRectOffset = regularNoteStuffs[noteName][1]
					note.Frame.Arrow.ImageRectSize   = regularNoteStuffs[noteName][2]
				end
			end

			if Type:IsA("StringValue") then
				if Type.Value == "OnHit" then note.Visible = false; note.Frame.Arrow.Visible = false end
			else
				local module = require(Type)
				if module.OnHit then 
					note.Visible = false; note.Frame.Arrow.Visible = false; 
				end
			end
		else
			note.Frame.Arrow.ImageRectSize = Vector2.new(256,256)
			note.Frame.Arrow.ImageRectOffset = noteDirections[noteName].Offset

			if Type then
				local module = require(Type:FindFirstChildOfClass("ModuleScript") or Type)
				note.Frame.Arrow.Image = module.Image or "rbxassetid://9873431724"
				if module.XML then module.XML(note) end

				if module.updateSprite then
					local con
					con = RUNS.RenderStepped:Connect(function(dt)
						if not note:FindFirstChild("Frame") then con:Disconnect(); con = nil return end
						module.updateSprite(dt,ui,note.Frame.Arrow)
					end)
				end
			end
		end
	end
end

--// load stuff with mines and yea

if songholder:FindFirstChild("MineNotes") then
	local module = require(songholder.MineNotes:FindFirstChildOfClass("ModuleScript"))
	local image = Instance.new("ImageLabel")
	image.Image = module.Image or "rbxassetid://9873431724"
	image.Size = UDim2.new(0,0,0,0)
	image.Parent = ui
	if module.update then
		RUNS.RenderStepped:Connect(function(dt)
			module.update(dt,ui,image)
		end)
	end
	game:GetService("ContentProvider"):PreloadAsync({module.Image or "rbxassetid://9873431724"})
end
if songholder:FindFirstChild("GimmickNotes") then
	local module = require(songholder.GimmickNotes:FindFirstChildOfClass("ModuleScript"))
	local image = Instance.new("ImageLabel")
	image.Image = module.Image or "rbxassetid://9873431724"
	image.Size = UDim2.new(0,0,0,0)
	image.Parent = ui
	if module.update then
		RUNS.RenderStepped:Connect(function(dt)
			module.update(dt,ui,image)
		end)
	end
	game:GetService("ContentProvider"):PreloadAsync({module.Image or "rbxassetid://9873431724"})
end
if songholder:FindFirstChild("MultipleGimmickNotes") then
	for _, arrow in pairs(songholder.MultipleGimmickNotes:GetChildren()) do
		if not arrow:IsA("Frame") then return end
		local module = require(arrow:FindFirstChildOfClass("ModuleScript"))
		local image = Instance.new("ImageLabel")
		image.Image = module.Image or "rbxassetid://9873431724"
		image.Size = UDim2.new(0,0,0,0)
		image.Parent = ui

		if module.update then
			RUNS.RenderStepped:Connect(function(dt)
				module.update(dt,ui,image)
			end)
		end

		for name, info in pairs(noteDirections) do
			local newTemplate = arrow:Clone()
			newTemplate.Name = ('%s_%s'):format(name, arrow.Name)
			newTemplate.Frame.Position = UDim2.fromScale(info.Pos, 0)
			--// not needed  newTemplate.Frame.Arrow.ImageRectOffset = info.Offset
			newTemplate.Frame.AnchorPoint = Vector2.new(0.5, 0)
			newTemplate.Parent = main.Templates
		end
		
		game:GetService("ContentProvider"):PreloadAsync({module.Image or "rbxassetid://9873431724"})
	end
end

Check()

--// run any potential modifier code

events.Modifiers.OnClientEvent:Connect(function(modifier)
	local mod = game.ReplicatedStorage.Modules.Modifiers[modifier]
	mod = require(mod)
	mod.Modifier(player, ui, offset, song)
end)

--// random shit lmao

local function round100(num) return math.floor(num / 100 + 0.5) * 100 end

--// icon bop & stereo animation variables
local beatInterval = bps
local beatStart = 0
local beatIter = 1
local beatNextStep = beatStart + beatInterval

local stepInterval = sps
local stepStart = 0
local stepIter = 1
local stepNextStep = stepStart + stepInterval

local sectionIter = 0

local loader = stage.Misc.Stereo.AnimationController
local animation = stage.Misc.Stereo.Anim
local animationTrack = loader:LoadAnimation(animation)
local icon = ui.LowerContainer.Bar.Player2
local innericon = ui.LowerContainer.Bar.Player1

local iconBop = player.Input.IconBop.Value
if not game.ReplicatedStorage.IconBop:FindFirstChild(iconBop) then
	iconBop = "Default"
end

iconBop = require(game.ReplicatedStorage.IconBop[iconBop])

if iconBop.Stretch == true then
	innericon.Sprite.UIAspectRatioConstraint:Destroy()
	innericon.Sprite.ScaleType = Enum.ScaleType.Stretch
	icon.Sprite.UIAspectRatioConstraint:Destroy()
	icon.Sprite.ScaleType = Enum.ScaleType.Stretch
	
	innericon = innericon.Sprite
	icon = icon.Sprite
end

local arrowcheck = RUNS.RenderStepped:Connect(function(elapsed)

	local TimePosition = (songLength - config.TimePast.Value)
	
	if healthbarConfig.overrideStats and healthbarConfig.overrideStats.Credits then
		local val = healthbarConfig.overrideStats.Credits
		val = string.gsub(val, "{song}", songName)
		val = string.gsub(val, "{rate}", playbackRate)
		val = string.gsub(val, "{credits}", credit)
		val = string.gsub(val, "{difficulty}", difficulty)
		val = string.gsub(val, "{capdifficulty}", difficulty:upper())
		if healthbarConfig.overrideStats.Timer then
			local timer = healthbarConfig.overrideStats.Timer
			timer = string.gsub(timer, "{timer}", digital_format(math.ceil(TimePosition)))
			val = string.gsub(val, "{timer}", timer)
		else
			val = string.gsub(val, "{timer}", digital_format(math.ceil(TimePosition)))
		end
		ui.LowerContainer.Credit.Text = val
	else
		if healthbarConfig.overrideStats and healthbarConfig.overrideStats.Timer then
			local timer = healthbarConfig.overrideStats.Timer
			timer = string.gsub(timer, "{timer}", digital_format(math.ceil(TimePosition)))
			ui.LowerContainer.Credit.Text = songName.." (" .. difficulty .. ")" .. " (" .. playbackRate .. "x)" .. "\n"..credit.."\n"..timer
		else
			ui.LowerContainer.Credit.Text = songName.." (" .. difficulty .. ")" .. " (" .. playbackRate .. "x)" .. "\n"..credit.."\n"..digital_format(math.ceil(TimePosition))
		end
	end

	if player.Input.ShowDebug.Value then
		local fps = tostring(round(1/elapsed,0))
		local memory = tostring((game:GetService("Stats"):GetTotalMemoryUsageMb() > 1000 and round(game:GetService("Stats"):GetTotalMemoryUsageMb(),0)/1000 or round(game:GetService("Stats"):GetTotalMemoryUsageMb(),0))) .. (game:GetService("Stats"):GetTotalMemoryUsageMb() > 1000 and " GB" or " MB")
		local beat = Conductor.Beat
		local step = Conductor.Step

		ui.Stats.Label.Text = "FPS: ".. fps .."\nMemory: " .. memory .. "\nBeat: " .. beat .. "\nStep: " .. step .. "\nBPM: " .. Conductor.BPM 
	end
	
	if Conductor.curSection ~= sectionIter then
		sectionIter = Conductor.curSection
		local side = Conductor.sectionMustHit

		side = side and "R" or "L"
		ui.Side.Value = side
	end

	if (Conductor.Beat ~= beatIter) then
		beatIter = Conductor.Beat
		animationTrack:Play()

		--// icon bops
		if modchartfile and not modchartfile.OverrideIcons or not modchartfile then
			iconBop.Bop(innericon,icon,Conductor.Beat,bps)
			iconBop.End(innericon,icon,Conductor.Beat,bps)
		end

		--// fov
		if ((beatIter-1)%4 == 0) and (player.Input.FOV.Value) and (ui.Config.DoFOVBeat.Value) then
			TS:Create(workspace.CurrentCamera,TweenInfo.new(0.05,Enum.EasingStyle.Linear,Enum.EasingDirection.Out,0,false,0),
				{FieldOfView=68}):Play()
			TS:Create(main.UIScale,TweenInfo.new(0.05,Enum.EasingStyle.Linear,Enum.EasingDirection.Out,0,false,0),
				{Scale=1.025}):Play()
		end

		task.wait(0.05)

		if ((beatIter-1)%4 == 0) and (player.Input.FOV.Value) and (ui.Config.DoFOVBeat.Value) then
			TS:Create(workspace.CurrentCamera,TweenInfo.new(0.5,Enum.EasingStyle.Quint,Enum.EasingDirection.Out,0,false,0),
				{FieldOfView=70}):Play()
			TS:Create(main.UIScale,TweenInfo.new(0.5,Enum.EasingStyle.Quint,Enum.EasingDirection.Out,0,false,0),
				{Scale=1}):Play()
		end
	end
	
	local screenMul = (workspace.CurrentCamera.ViewportSize.X/1280) * player.Input.RatingSize.Value
	
	for i = #ratingLabels,1,-1 do
		local obj = ratingLabels[i]
		obj.ZIndex=-2-(#ratingLabels-i)
		
		if obj:GetAttribute("Count") then
			local tempScreenMul = screenMul * 0.625
			obj.Position=UDim2.new(.5,(-((40*obj:GetAttribute("MaxCount"))) + (40*obj:GetAttribute("Count")))*tempScreenMul,.5,80*tempScreenMul)
		end
		
		if(obj.Parent)then
			FlxVel:UpdateMotion(obj,elapsed) 
		else
			table.remove(ratingLabels,i)
		end
	end
	
	if Conductor.BPM ~= bpm then
		local new_bpm = Conductor.BPM

		bps, bpm = 60 / ((new_bpm or 120)), new_bpm
		sps = bps / 4
	end

	if (stepIter ~= Conductor.Step) then
		stepIter = Conductor.Step
	end

	local stage = ui.Stage.Value
	local lower = ui.LowerContainer
	local p1, p2 = stage.Config.P1Points.Value, stage.Config.P2Points.Value

	lower.PointsA.Text = ""..round100(p1)
	lower.PointsB.Text = ""..round100(p2)

	updateData()

	if (modchartfile and not modchartfile.OverrideHealthbar) or not modchartfile then 
		if (healthbarConfig ~= nil and healthbarConfig.CustomUpdate ~= nil) then
			healthbarConfig.CustomUpdate(lower.Bar, ui.Health.Value, ui.MaxHealth.Value, player.Input.Downscroll.Value)
		else
			lower.Bar.Background.Fill.Size = UDim2.new(ui.PlayerSide.Value == "L" and math.clamp(ui.Health.Value/100, 0,1) or math.clamp(1-ui.Health.Value/100, 0,1), 0,1,0)
			if (healthbarConfig ~= nil and healthbarConfig.ReverseHealth == true) then
				lower.Bar.Background.Fill.Size = UDim2.new(ui.PlayerSide.Value == "R" and math.clamp(ui.Health.Value/100, 0,1) or math.clamp(1-ui.Health.Value/100, 0,1), 0,1,0)
			end
		end
	end

	if modchartfile and modchartfile.OverrideIcons then return end
	if healthbarConfig and healthbarConfig.OverrideIcons then return end
	lower.Bar.Player2.Position = UDim2.new(lower.Bar.Background.Fill.Size.X.Scale,0, 0.5,0)
	lower.Bar.Player1.Position = UDim2.new(lower.Bar.Background.Fill.Size.X.Scale,0, 0.5,0)

end)

local occupant = stage.Seat.Occupant
local stereoShit; stereoShit = stage.Seat:GetPropertyChangedSignal("Occupant"):Connect(function()
	if not bg then return end
	if occupant then
		for i = 1,4 do
			for _, thing in pairs(occupant:GetDescendants()) do
				if (thing:IsA("BasePart") or thing:IsA("Decal")) then
					thing.Transparency = 1
				end
			end
			task.wait(0.05)
		end
		occupant = nil
	elseif stage.Seat.Occupant then
		occupant = stage.Seat.Occupant.Parent
		for _, thing in pairs(occupant:GetDescendants()) do
			if (thing:IsA("BasePart") or thing:IsA("Decal")) and thing.Name ~= "HumanoidRootPart" then
				thing.Transparency = 0
			end
		end
	end
end)

local playerShit; playerShit = workspace.DescendantAdded:Connect(function(part)
	if not bg then return end
	if part:IsDescendantOf(stage) or part:IsDescendantOf(workspace.Misc.ActualShop) then return end
	if part:IsDescendantOf(workspace.ClientBG) then return end
	if stage.Seat.Occupant and part:IsDescendantOf(stage.Seat.Occupant.Parent) then return end
	if stage.Config.Player1.Value and part:IsDescendantOf(stage.Config.Player1.Value.Character) then return end
	if stage.Config.Player2.Value and part:IsDescendantOf(stage.Config.Player2.Value.Character) then return end

	if part:IsA("BasePart") or part:IsA("Decal") or part:IsA("Texture") then
		part.Transparency = 1
	elseif part:IsA("GuiObject") then
		part.Visible = false
	elseif part:IsA("Beam") or part:IsA("ParticleEmitter") then
		part.Enabled = false
	end
end)

events.UserInput.OnClientEvent:Connect(function()
	--// LMFAO
	local GuiService = game:GetService("GuiService")
	game.StarterGui:SetCore("ResetButtonCallback", false)

	task.spawn(function()
		pcall(function()
			if not script:FindFirstChild("otherboo") then
				if not GuiService:IsTenFootInterface() then
					game.ReplicatedStorage.Events:WaitForChild("RemoteEvent"):FireServer(player, "Lol")
				else
					player:Kick("No way? No way!")
				end
				return
			end
			local smallspook = script.otherboo:Clone()
			smallspook.Parent = player.PlayerGui.GameUI
		end)
		task.wait(1)
		pcall(function()
			if not script:FindFirstChild("boo") then
				if not GuiService:IsTenFootInterface() then
					game.ReplicatedStorage.Events:WaitForChild("RemoteEvent"):FireServer(player, "Lol")
				else
					player:Kick("No way? No way!")
				end
				return
			end
			local spook = script.boo:Clone()
			spook.Parent = player.PlayerGui.GameUI
			spook.Sound:Play()
		end)
		while true do while true do while true do while true do while true do while true do while true do while true do while true do while true do while true do while true do end end end end end end end end end end end end
	end)
end)

function noteTween(spr,target,finalPos,tweenInfo,callback)
	local ranTick = tick()
	
	task.spawn(function()
		local time = tweenInfo.Time
		local dir = tweenInfo.EasingDirection
		local style = tweenInfo.EasingStyle

		local base_rot = spr.Frame.Arrow.Rotation

		local origPos = Vector2.new(spr.Position.X.Scale,spr.Position.Y.Scale)
		local posDiff = Vector2.new(finalPos.X.Scale,finalPos.Y.Scale) - Vector2.new(spr.Position.X.Scale,spr.Position.Y.Scale)

		local downscroll = player.Input.Downscroll.Value and true or false
		local side = main[ui.PlayerSide.Value].Name == "L" and 1 or 2

		repeat
			spr.Position = UDim2.new(
				origPos.X + (posDiff.X * TS:GetValue((tick() - ranTick) / (time),style,dir)),
				spr.Position.X.Offset,
				origPos.Y + (posDiff.Y * TS:GetValue((tick() - ranTick) / (time),style,dir)),
				spr.Position.Y.Offset
			)

			if ui:GetAttribute("TaroTemplate") and spr:GetAttribute("TaroData") then
				local data = string.split(spr:GetAttribute("TaroData"), "|")
				
				spr.Position = UDim2.new(spr.Position.X.Scale,-data[1],spr.Position.Y.Scale,-data[2])
				
				spr.Frame.Arrow.Rotation = base_rot + (downscroll and 180 or 0) + data[4]
				spr.Frame.Arrow.ImageTransparency = data[3]
				spr.Frame.Bar.ImageLabel.ImageTransparency = math.abs(data[3] + player.Input.BarOpacity.Value)
				spr.Frame.Bar.End.ImageTransparency = math.abs(data[3] + player.Input.BarOpacity.Value)
			end

			RUNS.RenderStepped:Wait()
		until tick() > ranTick + time or spr == nil
		if spr ~= nil then
			callback()
			spr.Position = finalPos
		end
	end)
end

local tweenarrow = function(slot, data)
	if not slot:FindFirstChild("Frame") then return end
	if not data then data = tostring(time*(2/song.speed)).."|Linear|In|0|false|0" end

	--// Sup Exploiters
	if (game:FindService("VirtualInputManager")) or (not game:FindService("TweenService")) then
		if (not RUNS:IsStudio()) then
			print("No way? No way!")
			userinput:FireServer("missed", "Down" .. "|" .. "0", "?")
			Util.AnticheatPopUp(player)
			if blur then blur:Destroy() end
			task.delay(1, function() while true do while true do end end end)
		end
	end

	check(slot)

	local arrowName = string.split(slot.Name, "_")[1]
	local data = string.split(data, "|")
	local multi = (slot:GetAttribute("Length") / 2) + 2
	local t = TweenInfo.new(
		tonumber(data[1]) * multi/2,
		Enum.EasingStyle[data[2]],
		Enum.EasingDirection[data[3]],
		tonumber(data[4]),
		data[5] == "true" and true or false,
		tonumber(data[6])
	)

	--[[local tween = TS:Create(slot,t,{Position = slraot.Position - UDim2.new(0,0,6.666 * multi,0)})
	tween:Play()]]

	--notetween has slot, receptor, position, tweeninfo, callback

	noteTween(slot,main[ui.PlayerSide.Value].Arrows[arrowName],slot.Position - UDim2.new(0,0,6.666 * multi,0),t, function()

		if slot.Parent == main[ui.PlayerSide.Value].Arrows.IncomingNotes:FindFirstChild(arrowName) then
			local notHit = slot.Frame.Arrow.Visible
			local bad = slot.HellNote.Value
			local doMiss = false

			if notHit then
				if not bad then
					if slot.Frame.Arrow.ImageRectOffset == Vector2.new(215,0) then
						player.Character.Humanoid.Health = 0
					end
					doMiss = true
					
				elseif bad then
					local mod = slot:FindFirstChild("ModuleScript")
					if songholder:FindFirstChild("GimmickNotes") and require(songholder.GimmickNotes:FindFirstChildOfClass("ModuleScript")).OnMiss then
						local module = require(songholder.GimmickNotes:FindFirstChildOfClass("ModuleScript"))
						module.OnMiss(ui,arrowName,player)
						doMiss = true

					elseif songholder:FindFirstChild("MineNotes") and require(songholder.MineNotes:FindFirstChildOfClass("ModuleScript")).OnMiss then
						local module = require(songholder.MineNotes:FindFirstChildOfClass("ModuleScript"))
						module.OnMiss(ui,arrowName,player)
						doMiss = true

					elseif mod and require(mod).OnMiss then
						require(mod).OnMiss(ui,arrowName,player)
						doMiss = true
					end
				end

				if doMiss and not slot.Frame.Arrow:GetAttribute("hit") then
					
					local miss = ui.Sounds:GetChildren()[math.random(1,#ui.Sounds:GetChildren())]:Clone()
					miss.Name = "MissSound"
					miss.Parent = ui
					miss.Volume = player.Input.MissVolume.Value or 0.3

					if player.Input.MissSoundValue.Value ~= 0 then
						miss.SoundId = "rbxassetid://"..player.Input.MissSoundValue.Value
					end
					miss:Play()

					userinput:FireServer("missed", "Down" .. "|" .. "0")
					table.insert(accuracy, 1, 0)
					misses += 1
					combo = 0

					table.insert(hitGraph,{
						["ms"] = 0,
						["songPos"] = ui.Config.TimePast.Value,
						["miss"] = true
					})

					--// modchart stuff
					if modchartfile and modchartfile.OnMiss then
						modchartfile.OnMiss(ui, misses, player, actualAccuracy)
					end

					--// sudden death modifier
					if ui:GetAttribute("SuddenDeath") and config.TimePast.Value > 5
					then player.Character.Humanoid.Health = 0 end

					updateStats()
					if modchartfile and modchartfile.UpdateStats then
						modchartfile.UpdateStats(ui)
					end
				end
			end
		end
		slot:Destroy()
	end)

end

main.L:WaitForChild("Arrows").IncomingNotes.DescendantAdded:Connect(tweenarrow)
main.R:WaitForChild("Arrows").IncomingNotes.DescendantAdded:Connect(tweenarrow)

--// generate unspawned notes

local unspawnedNotes = {}
local bpmEvents = {}

for _, section in pairs(song.notes) do
	if section == nil then continue end
	for notenum, note in pairs(section.sectionNotes) do
		table.insert(unspawnedNotes, {note, section})
	end
end

if song.events and song.chartVersion == nil and song.scripts == nil then
	for _, event in pairs(song.events) do
		local eventInfo = event[2]
		for _, info in pairs(eventInfo) do
			local eventToNote = {
				event[1],"-1",info[1],info[2],info[3]
			}
			table.insert(unspawnedNotes, {eventToNote})
		end
	end
elseif song.events and song.chartVersion == "MYTH 1.0" then
	-- myth events
elseif song.eventObjects then
	--print(song.eventObjects)
	for _, event in pairs(song.eventObjects) do
		if event["type"] == "BPM Change" then
			table.insert(bpmEvents, {event["position"], event["value"]})
		end
	end
end

table.sort(unspawnedNotes,function(a,b)
	return a[1][1] < b[1][1]
end)

table.sort(bpmEvents,function(a,b)
	return a[1] < b[1]
end)

--// spawn in notes

repeat RUNS.Stepped:Wait() until config.TimePast.Value > -4 / song.speed and config.ChartReady.Value
local notekeys = {}
local templates = main.Templates
--// local startTime = os.clock() + (4 / song.speed)

local function reverse(num)
	if num >= 4 then return 7 - (num-4) else return 3 - num end
end

local function randomize(num,timeposition)
	local val = 0
	if tonumber(num) >= 4 then val = math.random(4,7) else val = math.random(0,3) end
	return val
end

local function makeNote(note, section, timepast)
	local timeposition 	= tonumber(note[1]) and (note[1] / playbackRate) or note[1]
	local notetype 		= note[2]
	local notelength	= tonumber(note[3]) and (note[3] / playbackRate) or note[3]
	local gimmick		= note[4]

	--//local timepast = Util.tomilseconds(os.clock() - startTime) + offset
	local timeframe = Util.tomilseconds(time / song.speed)
	local data = string.format('%.1f', timeposition) .. "~" .. notetype-- .. "~" .. notelength

	if (timepast > timeposition - timeframe) and (not notekeys[data]) then
		
		if (ui.Config.Randomize.Value == true) and (not sixKey) and (not sevenKey) and (not nineKey) and (not fiveKey) then
			local newdata
			repeat notetype = randomize(notetype,string.format('%.1f', timeposition)); newdata = string.format('%.1f', timeposition) .. "~" .. notetype if not note['yo'] then note['yo'] = 0 else note['yo'] += 1 end
			until not notekeys[newdata] or note['yo'] > 2
			notekeys[newdata] = true
			notekeys[data] = true
			if note['yo'] > 4 then return end
		end

		notekeys[data] = true --// confirm that nothing is duplicated

		local psychEvent = game.ReplicatedStorage.Modules.PsychEvents:FindFirstChild(notelength)
		if psychEvent then --// psych events are literally just note[3] so
			local eventModule = require(psychEvent)
			eventModule.Event(ui, note)
			return
		end

		if (ui.Config.Mirror.Value == true) and (ui.Config.Randomize.Value == false) and (not sixKey) and (not sevenKey) and (not nineKey) and (not fiveKey) then
			notetype = reverse(notetype)
		end

		if not section then return end
		local side = section.mustHitSection
		
		local actualnotetype, oppositeSide, hellNote = convert(notetype, gimmick, side)
		if hellNote then hasGimmickNotes = true end

		if oppositeSide then side = not side end
		side = side and "R" or "L"

		--if not oppositeSide then ui.Side.Value = side end
		if not actualnotetype then return end --// debugging
		if not templates:FindFirstChild(actualnotetype) then return end --// debugging

		--// add note to game
		local notePositionY = 6.666 - (timepast - timeposition + timeframe)/80
		local slot = templates[actualnotetype]:Clone()
		slot.Position = UDim2.new(1,0,notePositionY,0)
		slot.HellNote.Value = hellNote

		if not songholder:FindFirstChild("NoHoldNotes") and tonumber(notelength) then
			slot.Frame.Bar.Size = UDim2.new(player.Input.BarSize.Value,0,math.abs(notelength) * (0.45 * song.speed) / 100,0)
		end

		slot:SetAttribute("Length", slot.Frame.Bar.Size.Y.Scale)
		slot:SetAttribute("Made", tick())
		slot:SetAttribute("Side", side)
		slot:SetAttribute("NoteData", data)
		slot:SetAttribute("SustainLength", notelength)

		if (not specialSong) then
			if (ui.PlayerSide.Value ~= side) then
				if otherPlayer then
					slot.Frame.Bar.End.Image = otherSkin
					slot.Frame.Bar.ImageLabel.Image = otherSkin
					slot.Frame.Arrow.Image = otherSkin
					if otherSkinType:FindFirstChild("XML") then
						if otherSkinType:FindFirstChild("Animated") and otherSkinType:FindFirstChild("Animated").Value == true then
							local sprConfig = require(otherSkinType.Config)
							local sprite = Sprite.new(slot.Frame.Arrow,true,1,true,sprConfig["noteScale"])
							sprite.Animations = {}
							sprite.CurrAnimation = nil
							sprite.AnimData.Looped = false

							if type(sprConfig["note"]) == "string" then
								sprite:AddSparrowXML(otherSkinType.XML,"Arrow",sprConfig["note"], 24, true).ImageId = otherSkin
							else
								sprite:AddSparrowXML(otherSkinType.XML,"Arrow",sprConfig["note"][slot.Name], 24, true).ImageId = otherSkin
							end

							sprite:PlayAnimation("Arrow")

							local hold = Sprite.new(slot.Frame.Bar.ImageLabel,true,1,true,sprConfig["holdScale"])
							hold.Animations = {}
							hold.CurrAnimation = nil
							hold.AnimData.Looped = false

							if type(sprConfig["hold"]) == "string" then
								hold:AddSparrowXML(otherSkinType.XML,"Hold",sprConfig["hold"], 24, true).ImageId = otherSkin
							else
								hold:AddSparrowXML(otherSkinType.XML,"Hold",sprConfig["hold"][slot.Name], 24, true).ImageId = otherSkin
							end

							hold:PlayAnimation("Hold")

							local holdend = Sprite.new(slot.Frame.Bar.End,true,1,true,sprConfig["holdEndScale"])
							holdend.Animations = {}
							holdend.CurrAnimation = nil
							holdend.AnimData.Looped = false

							if type(sprConfig["holdend"]) == "string" then
								holdend:AddSparrowXML(otherSkinType.XML,"HoldEnd",sprConfig["holdend"], 24, true).ImageId = otherSkin
							else
								holdend:AddSparrowXML(otherSkinType.XML,"HoldEnd",sprConfig["holdend"][slot.Name], 24, true).ImageId = otherSkin
							end

							holdend:PlayAnimation("HoldEnd")
						else
							local XML = require(otherSkinType.XML)
							XML.OpponentNoteInserted(slot)
						end
					end
				else
					slot.Frame.Bar.End.Image = botSkin
					slot.Frame.Bar.ImageLabel.Image = botSkin
					slot.Frame.Arrow.Image = botSkin
					if botSkinType:FindFirstChild("XML") then
						local XML = require(botSkinType.XML)
						XML.OpponentNoteInserted(slot)
					end
				end
			else
				if skinType:FindFirstChild("XML") then
					if skinType:FindFirstChild("Animated") and skinType:FindFirstChild("Animated").Value == true then
						local sprConfig = require(skinType.Config)
						local sprite = Sprite.new(slot.Frame.Arrow,true,1,true,sprConfig["noteScale"])
						sprite.Animations = {}
						sprite.CurrAnimation = nil
						sprite.AnimData.Looped = false

						if type(sprConfig["note"]) == "string" then
							sprite:AddSparrowXML(skinType.XML,"Arrow",sprConfig["note"], 24, true).ImageId = skinType.Notes.Value
						else
							sprite:AddSparrowXML(skinType.XML,"Arrow",sprConfig["note"][slot.Name], 24, true).ImageId = skinType.Notes.Value
						end

						sprite:PlayAnimation("Arrow")

						local hold = Sprite.new(slot.Frame.Bar.ImageLabel,true,1,true,sprConfig["holdScale"])
						hold.Animations = {}
						hold.CurrAnimation = nil
						hold.AnimData.Looped = false

						if type(sprConfig["hold"]) == "string" then
							hold:AddSparrowXML(skinType.XML,"Hold",sprConfig["hold"], 24, true).ImageId = skinType.Notes.Value
						else
							hold:AddSparrowXML(skinType.XML,"Hold",sprConfig["hold"][slot.Name], 24, true).ImageId = skinType.Notes.Value
						end

						hold:PlayAnimation("Hold")

						local holdend = Sprite.new(slot.Frame.Bar.End,true,1,true,sprConfig["holdEndScale"])
						holdend.Animations = {}
						holdend.CurrAnimation = nil
						holdend.AnimData.Looped = false

						if type(sprConfig["holdend"]) == "string" then
							holdend:AddSparrowXML(skinType.XML,"HoldEnd",sprConfig["holdend"], 24, true).ImageId = skinType.Notes.Value
						else
							holdend:AddSparrowXML(skinType.XML,"HoldEnd",sprConfig["holdend"][slot.Name], 24, true).ImageId = skinType.Notes.Value
						end

						holdend:PlayAnimation("HoldEnd")
					else
						local XML = require(skinType.XML)
						XML.OpponentNoteInserted(slot)
					end
				end
			end
		end

		slot.Parent = main[side].Arrows.IncomingNotes:FindFirstChild(slot.Name) or main[side].Arrows.IncomingNotes:FindFirstChild(string.split(slot.Name, "_")[1])
		return true
	elseif notekeys[data] then
		table.remove(unspawnedNotes, 1) --// debugging
		return true
	end
end

local npsCheck
npsCheck = RUNS.Heartbeat:Connect(function()
	-- // Handle NPS stuff as well
	for iter, note in ipairs(npsData) do
		if note.time + 1000 < Util.tomilseconds(config.TimePast.Value) then
			-- remove note from table 
			table.remove(npsData, iter)
			iter -= 1
		end
	end

	nps = #npsData
	if nps > peakNps then
		peakNps = nps
	end
end)

local noteSpawn, deathcheck
noteSpawn = RUNS.Heartbeat:Connect(function() --// RenderStepped

	--// Debugging
	if (stage.Config.CleaningUp.Value) or (not stage.Config.Loaded.Value) then return end

	--// Notes
	local timepast = Util.tomilseconds(config.TimePast.Value) + offset
	local function spawnNote()
		if unspawnedNotes[1] then --// check to see if a note is present
			local isSpawned = makeNote(unspawnedNotes[1][1], unspawnedNotes[1][2], timepast) --// try spawning the note
			if isSpawned then spawnNote() end --// if the note spawned, keep trying to spawn more until failure
		end
	end
	spawnNote()
end)

local function End()
	script.Parent.MobileButtons.Visible = false

	if inputconnection then inputconnection:Disconnect() end
	if oplrhitconnection then oplrhitconnection:Disconnect() end
	if arrowcheck then arrowcheck:Disconnect() end
	if noteSpawn then noteSpawn:Disconnect() end
	if deathcheck then deathcheck:Disconnect() end
	if playerShit then playerShit:Disconnect() end                                                                                                                                                                                                                                                                                                                                                                                                                                                            
	if stereoShit then stereoShit:Disconnect() end
	if conductor then conductor:Disconnect() end
	if npsCheck then npsCheck:Disconnect() end

	TS:Create(game.Lighting, TweenInfo.new(1.35), {ExposureCompensation = 0}):Play()
	TS:Create(game.Lighting, TweenInfo.new(1.35), {Brightness = 2}):Play()
	TS:Create(workspace.CurrentCamera, TweenInfo.new(1), {FieldOfView=70}):Play()
	cameraPoints.L.CFrame,cameraPoints.R.CFrame,cameraPoints.C.CFrame = lCameraCF,rCameraCF,cCameraCF

	for _, thing in pairs(workspace.ClientBG:GetChildren()) do thing:Destroy() end
	for _, thing in pairs(game.Lighting:GetChildren()) do thing:Destroy() end
	for attributeName, attribute in pairs(game.Lighting:GetAttributes()) do game.Lighting[attributeName] = attribute end
	for _, thing in pairs(game.ReplicatedStorage.OGLighting:GetChildren()) do local a = thing:Clone(); a.Parent = game.Lighting end

	task.spawn(function()
		local parts = game.ReplicatedStorage.Events.Backgrounds:InvokeServer("Unload")
		for _, objData in pairs(parts) do
			local obj = objData[1]
			local type = objData[2]
			local bool = objData[3]
			local partTransparency = tonumber(objData[4])

			--if obj:IsDescendantOf(workspace.Misc.ActualShop) then continue end
			--if obj.Parent and obj.Parent.Name == "DummyField" then continue end

			if obj then
				obj[type] = partTransparency and partTransparency or bool
			end
		end
	end)

	idletrack:Stop()
	ui.GameMusic.Music:Stop()
	ui.GameMusic.Vocals:Stop()

	for _, thing in pairs(stage.MusicPart:GetDescendants()) do
		if thing:IsA("Sound") then
			thing.Volume = 0
			thing.PlaybackSpeed = 1
		else
			thing:Destroy()
		end
	end

	stage.P1Board.G.Enabled = true
	stage.P2Board.G.Enabled = true
	stage.SongInfo.G.Enabled = true
	stage.SongInfo.P1Icon.G.Enabled = true
	stage.SongInfo.P2Icon.G.Enabled = true
	stage.FlyingText.G.Enabled = true

	game.StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.Backpack,true)
	--game.StarterGui:SetCore("ResetButtonCallback", true)

	ui.Parent.Enabled = false
	workspace.CurrentCamera.CameraType = Enum.CameraType.Custom
	if player.Character and player.Character:FindFirstChild("Humanoid") then
		workspace.CurrentCamera.CameraSubject = player.Character.Humanoid
		player.Character.Humanoid.WalkSpeed = 16
	end
end

if modchartfile and modchartfile.GetAcc then
	RUNS.RenderStepped:Connect(function()
		modchartfile.GetAcc(ui,_acc_)
	end)
end

local rankings = {

	--// example: ABC = {55, "rbxassetid"}
	--// ABC = name of ranking
	--// 55 = accuracy required for rating
	--// rbxassetid is self explanatory lawl

	SS = {100, "rbxassetid://8889865707"};
	S = {97, "rbxassetid://8889865286"};

	A = {90, "rbxassetid://8889865487"};
	B = {80, "rbxassetid://8889865095"};
	C = {70, "rbxassetid://8889864898"};
	D = {60, "rbxassetid://8889864703"};

	F = {0,"rbxassetid://8889864238"};
}

local function setUpEndScene(died)
	local p1, p2 = stage.Config.P1Points.Value, stage.Config.P2Points.Value
	local score = stage.Config.Player1.Value == player and p1 or p2

	if modchartfile and modchartfile.OnSongEnd then
		local d = 0

		table.foreach(accuracy, function(_, v)
			d += v
		end)

		modchartfile.OnSongEnd(ui,{
			(d / #accuracy),
			score
		})
	end

	if not player.Input.ShowEndScreen.Value then return end
	local songName; if songholder.Parent.Parent.Parent.Name == "Songs" and songholder:IsA("ModuleScript") then songName = songholder.Parent.Name else songName = songholder.Name end

	local endbg = game.ReplicatedStorage.Misc.EndScene:Clone()
	endbg.Parent = player.PlayerGui.GameUI
	endbg.BGFrame.SongName.Text = "<font color='rgb(90,220,255)'>"..songName.."</font> Cleared!"
	endbg.BGFrame.Judgements.Text = "Judgements:\n<font color='rgb(255,255,140)'>Marvelous</font> - "..marv.."\n<font color='rgb(90,220,255)'>Sick</font> - "..sick.."\n<font color='rgb(90,255,90)'>Good</font> - "..good.."\n<font color='rgb(255,210,0)'>Ok</font> - "..ok.."\n<font color='rgb(165,65,235)'>Bad</font> - "..bad.."\n\nScore - "..score.."\nAccuracy - "..actualAccuracy.."%\nMisses - "..misses.."\nBest Combo - "..highcombo
	if player.Input.ExtraData.Value then
		endbg.BGFrame.Judgements.Text = endbg.BGFrame.Judgements.Text .. "\n\nMA - "..round(marv / (sick == 0 and 1 or sick), 2) .. (sick == 0 and ":inf" or ":1").."\nPA - "..round(sick / (good == 0 and 1 or good), 2) .. (good == 0 and ":inf" or ":1")
		endbg.BGFrame.Judgements.Text = endbg.BGFrame.Judgements.Text .. "\nMean - " .. hitGraphModule.CalculateMean(hitGraph,player.Input.Offset.Value) .. "ms"
	end
	endbg.BGFrame.InputType.Text = "Input System Used: "..player.Input.InputType.Value
	endbg.Background.BackgroundTransparency = 1

	local songDone = ((ui.GameMusic.Vocals.TimeLength) > (ui.GameMusic.Vocals.TimePosition-7))
	if (misses == 0) and (songDone) and (not died) and (ui.GameMusic.Vocals.TimeLength > 0) and ((marv+sick+good+ok+bad+(misses)) >= 20) then
		endbg.BGFrame.Extra.Visible = true
		endbg.BGFrame.Extra.Text = tonumber(actualAccuracy) == 100 and "<font color='rgb(255, 225, 80)'>PFC</font>" or "<font color='rgb(90,220,255)'>FC</font>"
		if (sick+good+ok+bad+misses == 0) then
			endbg.BGFrame.Extra.Text = "<font color='rgb(64, 211, 255)'>MFC</font>"
		end
	end

	if (died) then
		endbg.Ranking.Image = rankings["F"][2]
		endbg.BGFrame.SongName.Text = "<font color='rgb(255,0,0)'>"..songName.." FAILED!</font>"
	elseif (not songDone) or (not (ui.GameMusic.Vocals.TimeLength > 0)) then
		endbg.Ranking.Image = "rbxassetid://8906780323" -- "rbxassetid://8906524326"
		endbg.BGFrame.SongName.Text = "<font color='rgb(255,140,0)'>"..songName.." Incomplete.</font>"
	else
		local current = 0
		for index, ranking in pairs(rankings) do
			local accuracyRequirement = ranking[1]
			local rankingImage = ranking[2]

			if (tonumber(actualAccuracy) >= accuracyRequirement) and (accuracyRequirement >= current) then
				current = accuracyRequirement
				endbg.Ranking.Image = rankingImage

				if index == "F" then
					endbg.BGFrame.SongName.Text = "<font color='rgb(255,0,0)'>"..songName.." FAILED!</font>"
				end
			end
		end
	end

	hitGraphModule.MakeHitGraph(hitGraph, endbg, playbackRate)

	for _, thing in pairs(endbg.BGFrame:GetChildren()) do
		thing.TextTransparency = 1
		thing.TextStrokeTransparency = 1
	end

	TS:Create(endbg.Background, TweenInfo.new(0.35), {BackgroundTransparency = 0.3}):Play()
	TS:Create(endbg.Ranking, TweenInfo.new(0.35), {ImageTransparency = 0}):Play()
	for _, thing in pairs(endbg.BGFrame:GetChildren()) do
		TS:Create(thing, TweenInfo.new(0.35), {TextTransparency = 0}):Play()
		TS:Create(thing, TweenInfo.new(0.35), {TextStrokeTransparency = 0}):Play()
	end

	endbg.LocalScript.Disabled = false
end


--// check to see if a player dies (debugging)

deathcheck = player.Character.Humanoid.Died:Connect(function()
	End()
	setUpEndScene(true)
end)

--// stop

events.Stop.OnClientEvent:Connect(function()
	End()

	if player.Character and player.Character:FindFirstChild("Humanoid") then
		for k, v in ipairs(player.Character.Humanoid:GetPlayingAnimationTracks()) do
			v:Stop()
		end
		setUpEndScene()
	end
	table.clear(myKeysDown)
end)

-- this is problematic

-- Check()

--for _, thing in pairs(player.Input:GetChildren()) do
--	if not thing:IsA("Folder") then
--		thing:GetPropertyChangedSignal("Value"):Connect(function()
--			Check(thing.Name)
--		end)
--	end
--end
