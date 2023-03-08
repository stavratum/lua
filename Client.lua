-- Decompiled with the Synapse X Luau decompiler.

local v1 = nil;
script.Parent:WaitForChild("Config"):WaitForChild("ObjectCount");
while true do
	task.wait();
	if script.Parent.Config.ObjectCount.Value > 0 and script.Parent.Config.ObjectCount.Value <= #script.Parent:GetDescendants() then
		break;
	end;
end;
while true do
	task.wait();
	if script.Parent.Config.ServerSetup.Value == true then
		break;
	end;
end;
local l__LocalPlayer__2 = game.Players.LocalPlayer;
local l__Parent__3 = script.Parent;
local l__Config__4 = l__Parent__3.Config;
local l__Events__5 = l__Parent__3.Events;
local l__Value__6 = l__Parent__3.Stage.Value;
local l__Game__7 = l__Parent__3.Game;
local l__CameraPoints__8 = l__Value__6.CameraPoints;
local v9 = Enum.EasingStyle.Sine;
if l__LocalPlayer__2.Input.CamEaseStyle.Value ~= "Sine" then
	for v10, v11 in pairs((Enum.EasingStyle:GetEnumItems())) do
		if tostring(v11) == "Enum.EasingStyle." .. l__LocalPlayer__2.Input.CamEaseStyle.Value then
			v9 = v11;
		end;
	end;
end;
local v12 = game.ReplicatedStorage.Modules.Conductor:Clone();
v12.Parent = l__Parent__3;
local v13 = require(v12);
local v14 = require(game.ReplicatedStorage.Modules.Util);
local v15 = require(game.ReplicatedStorage.Modules.TimingWindows);
local v16 = require(game.ReplicatedStorage.Modules.FlxVel);
local l__TweenService__17 = game:GetService("TweenService");
local l__UserInputService__18 = game:GetService("UserInputService");
local l__RunService__19 = game:GetService("RunService");
local v20 = require(game.ReplicatedStorage.Modules.DebugLog);
local v21 = require(game.ReplicatedStorage.Modules.Sprites.Sprite);
local v22 = l__Game__7:FindFirstChild(l__Parent__3.PlayerSide.Value);
l__Value__6.P1Board.G.Enabled = false;
l__Value__6.P2Board.G.Enabled = false;
l__Value__6.SongInfo.G.Enabled = false;
l__Value__6.SongInfo.P1Icon.G.Enabled = false;
l__Value__6.SongInfo.P2Icon.G.Enabled = false;
l__Value__6.FlyingText.G.Enabled = false;
l__Config__4.TimePast.Value = -40;
for v23, v24 in pairs(l__CameraPoints__8:GetChildren()) do
	v24.CFrame = v24.OriginalCFrame.Value;
end;
for v25, v26 in pairs({ l__Game__7.R, l__Game__7.L }) do
	game.ReplicatedStorage.Misc.SplashContainer:Clone().Parent = v26;
end;
local v27 = {};
local v28 = l__LocalPlayer__2.PlayerGui.GameUI:WaitForChild("SongSelect", 10);
local l__EndScene__29 = l__LocalPlayer__2.PlayerGui.GameUI:FindFirstChild("EndScene");
if l__EndScene__29 then
	l__EndScene__29:Destroy();
end;
if not v28 then
	warn("Infinite yield possible on song select menu. Please report this to a dev!");
	v28 = l__LocalPlayer__2.PlayerGui.GameUI:WaitForChild("SongSelect");
end;
v28.StatsContainer.FCs.Text = "<font color='rgb(90,220,255)'>FCs</font>: " .. l__LocalPlayer__2.Input.Achievements.FCs.Value .. " | <font color='rgb(255, 225, 80)'>PFCs</font>: " .. l__LocalPlayer__2.Input.Achievements.PFCs.Value;
function updateData()
	local v30 = 1 - 1;
	while true do
		if l__Value__6.Config["P" .. v30 .. "Stats"].Value ~= "" then
			local v31 = game.HttpService:JSONDecode(l__Value__6.Config["P" .. v30 .. "Stats"].Value);
			if v30 == 1 then
				local v32 = "L";
			else
				v32 = "R";
			end;
			l__Game__7:FindFirstChild(v32).OpponentStats.Label.Text = "Accuracy: " .. v31.accuracy .. "% | Combo: " .. v31.combo .. " | Misses: " .. v31.misses;
			l__Value__6.Config["P" .. v30 .. "Stats"].Value = "";
		end;
		if 0 <= 1 then
			if v30 < 2 then

			else
				break;
			end;
		elseif 2 < v30 then

		else
			break;
		end;
		v30 = v30 + 1;	
	end;
end;
local u1 = {};
local u2 = 0;
local u3 = 0;
local u4 = 0;
local u5 = 0;
local u6 = 0;
local u7 = 0;
local u8 = 0;
local u9 = 0;
local u10 = 0;
local u11 = require(l__Parent__3.Modules.HitGraph);
local u12 = {};
local u13 = 100;
local u14 = nil;
local function v33()
	local v34 = l__Parent__3.LowerContainer.Stats.Label;
	l__Parent__3.LowerContainer.Bar.Visible = l__LocalPlayer__2.Input.HealthBar.Value;
	local u15 = 0;
	table.foreach(u1, function(p1, p2)
		u15 = u15 + p2;
	end);
	local v35 = 100;
	if u15 == 0 and #u1 == 0 then
		local v36 = "Accuracy: 100%";
	else
		u2 = string.sub(tostring(u15 / #u1), 1, 5);
		v36 = "Accuracy: " .. u2 .. "%";
		v35 = u2;
	end;
	local v37 = v36 .. " | Combo: " .. u3 .. " | Misses: " .. u4;
	v34.Text = v37;
	if l__LocalPlayer__2.Input.VerticalBar.Value then
		v34 = l__Parent__3.SideContainer.Accuracy;
		v34.Text = string.gsub(v37, " | ", "\n");
	end;
	if u5 < u3 then
		u5 = u3;
	end;
	l__Parent__3.SideContainer.Data.Text = "Marvelous: " .. u6 .. "\nSick: " .. u7 .. "\nGood: " .. u8 .. "\nOk: " .. u9 .. "\nBad: " .. u10;
	local l__Extra__38 = l__Parent__3.SideContainer.Extra;
	if u7 == 0 then
		local v39 = 1;
	else
		v39 = u7;
	end;
	if u7 == 0 then
		local v40 = ":inf";
	else
		v40 = ":1";
	end;
	if u8 == 0 then
		local v41 = 1;
	else
		v41 = u8;
	end;
	if u8 == 0 then
		local v42 = ":inf";
	else
		v42 = ":1";
	end;
	l__Extra__38.Text = "MA: " .. math.floor(u6 / v39 * 100 + 0.5) / 100 .. v40 .. "\nPA: " .. math.floor(u7 / v41 * 100 + 0.5) / 100 .. v42;
	l__Extra__38.Text = l__Extra__38.Text .. "\nMean: " .. u11.CalculateMean(u12, l__LocalPlayer__2.Input.Offset.Value) .. "ms";
	l__Events__5.UpdateData:FireServer({
		accuracy = v35, 
		combo = u3, 
		misses = u4, 
		bot = false
	});
	u13 = v35;
	if u14 ~= nil and u14.overrideStats then
		if u7 + u8 + u9 + u10 + u4 == 0 then
			local v43 = "MFC";
		elseif u8 + u9 + u10 + u4 == 0 then
			v43 = "PFC";
		elseif u9 + u10 + u4 == 0 then
			v43 = "GFC";
		elseif u4 == 0 then
			v43 = "FC";
		elseif u4 < 10 then
			v43 = "SDBC";
		else
			v43 = "Clear";
		end;
		if u14.overrideStats.Value then
			local v44 = string.gsub(string.gsub(string.gsub(string.gsub(string.gsub(u14.overrideStats.Value, "{misses}", u4), "{combo}", u3), "{score}", l__Value__6.Config.Player1.Value == l__LocalPlayer__2 and l__Value__6.Config.P1Points.Value or l__Value__6.Config.P2Points.Value), "{rating}", v43), "{accuracy}", v35 .. "%%");
		else
			v44 = v34.Text;
		end;
		if u14.overrideStats.ShadowValue then
			local v45 = string.gsub(string.gsub(string.gsub(u14.overrideStats.ShadowValue, "{misses}", u4), "{combo}", u3), "{accuracy}", v35 .. "%%");
		else
			v45 = v34.Text;
		end;
		if u14.overrideStats.Separator then
			v44 = string.gsub(v44, "|", u14.overrideStats.Separator);
			v45 = v44;
		end;
		if u14.overrideStats.ChildrenToUpdate then
			l__Parent__3.SideContainer.Accuracy.Visible = false;
			local l__Label__46 = l__Parent__3.LowerContainer.Stats.Label;
			local v47, v48, v49 = pairs(u14.overrideStats.ChildrenToUpdate);
			while true do
				local v50 = nil;
				local v51, v52 = v47(v48, v49);
				if not v51 then
					break;
				end;
				v49 = v51;
				v50 = l__Parent__3.LowerContainer.Stats[v52];
				if v52:lower():match("shadow") then
					v50.Text = v45;
				else
					v50.Text = v44;
				end;			
			end;
		elseif l__LocalPlayer__2.Input.VerticalBar.Value then
			if u14.overrideStats.Separator then
				v34.Text = string.gsub(v44, " " .. u14.overrideStats.Separator .. " ", "\n");
			else
				v34.Text = string.gsub(v44, " | ", "\n");
			end;
		else
			v34.Text = v44;
		end;
	end;
end;
v33();
local u16 = 0;
local u17 = 1;
l__Events__5.Start.OnClientEvent:Connect(function(p3, p4, p5)
	u16 = p3;
	local v53 = 1 / p4;
	local v54 = p5:FindFirstChild("Modchart") and (p5.Modchart:IsA("ModuleScript") and require(p5.Modchart));
	if v54 and v54.PreStart then
		v54.PreStart(l__Parent__3, v53);
	end;
	local v55 = {};
	if p5:FindFirstChild("Countdown") and game.ReplicatedStorage.Countdowns:FindFirstChild(p5.Countdown.Value) then
		local v56 = require(game.ReplicatedStorage.Countdowns:FindFirstChild(p5.Countdown.Value).Config);
		if v56.Audio ~= nil then
			l__Value__6.MusicPart["3"].SoundId = v56.Audio["3"];
			l__Value__6.MusicPart["2"].SoundId = v56.Audio["2"];
			l__Value__6.MusicPart["1"].SoundId = v56.Audio["1"];
			l__Value__6.MusicPart.Go.SoundId = v56.Audio.Go;
		end;
		v55 = v56.Images;
	end;
	if p5:FindFirstChild("ExtraCountdownTime") then
		task.wait(p5.ExtraCountdownTime.Value);
	end;
	local l__Music__18 = l__Parent__3.GameMusic.Music;
	local l__Vocals__19 = l__Parent__3.GameMusic.Vocals;
	task.spawn(function()
		if p5:FindFirstChild("NoCountdown") then
			task.wait(v53 * 3);
			l__Value__6.MusicPart["3"].Volume = 0;
			l__Value__6.MusicPart.Go.Volume = 0;
			l__Value__6.MusicPart["3"]:Play();
			l__Value__6.MusicPart.Go:Play();
			task.wait(v53);
			l__Music__18.Playing = true;
			l__Vocals__19.Playing = true;
			return;
		end;
		l__Value__6.MusicPart["3"]:Play();
		local u20 = v55;
		local u21 = "3";
		local u22 = v53;
		task.spawn(function()
			if u20 == nil or u20[u21] == nil then
				return;
			end;
			local v57 = l__Parent__3.Countdown.Countdown:Clone();
			v57.Name = u21;
			v57.Image = u20[u21];
			v57.Visible = true;
			v57.Parent = l__Parent__3.Countdown;
			l__TweenService__17:Create(v57, TweenInfo.new(u22, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut), {
				ImageTransparency = 1
			}):Play();
			task.wait(u22 * 1.2);
			v57:Destroy();
		end);
		u22 = task.wait;
		u20 = v53;
		u22(u20);
		u22 = v53;
		u20 = v55;
		u21 = l__Value__6;
		u21.MusicPart["2"]:Play();
		u21 = "2";
		task.spawn(function()
			if u20 == nil or u20[u21] == nil then
				return;
			end;
			local v58 = l__Parent__3.Countdown.Countdown:Clone();
			v58.Name = u21;
			v58.Image = u20[u21];
			v58.Visible = true;
			v58.Parent = l__Parent__3.Countdown;
			l__TweenService__17:Create(v58, TweenInfo.new(u22, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut), {
				ImageTransparency = 1
			}):Play();
			task.wait(u22 * 1.2);
			v58:Destroy();
		end);
		u22 = task.wait;
		u20 = v53;
		u22(u20);
		u22 = v53;
		u20 = v55;
		u21 = l__Value__6;
		u21.MusicPart["1"]:Play();
		u21 = "1";
		task.spawn(function()
			if u20 == nil or u20[u21] == nil then
				return;
			end;
			local v59 = l__Parent__3.Countdown.Countdown:Clone();
			v59.Name = u21;
			v59.Image = u20[u21];
			v59.Visible = true;
			v59.Parent = l__Parent__3.Countdown;
			l__TweenService__17:Create(v59, TweenInfo.new(u22, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut), {
				ImageTransparency = 1
			}):Play();
			task.wait(u22 * 1.2);
			v59:Destroy();
		end);
		u22 = task.wait;
		u20 = v53;
		u22(u20);
		u22 = v53;
		u20 = v55;
		u21 = l__Value__6;
		u21.MusicPart.Go:Play();
		u21 = "Go";
		task.spawn(function()
			if u20 == nil or u20[u21] == nil then
				return;
			end;
			local v60 = l__Parent__3.Countdown.Countdown:Clone();
			v60.Name = u21;
			v60.Image = u20[u21];
			v60.Visible = true;
			v60.Parent = l__Parent__3.Countdown;
			l__TweenService__17:Create(v60, TweenInfo.new(u22, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut), {
				ImageTransparency = 1
			}):Play();
			task.wait(u22 * 1.2);
			v60:Destroy();
		end);
		u22 = task.wait;
		u20 = v53;
		u22(u20);
		u22 = l__Music__18;
		u20 = true;
		u22.Playing = u20;
		u22 = l__Vocals__19;
		u20 = true;
		u22.Playing = u20;
	end);
	for v61, v62 in pairs(l__Value__6.MusicPart:GetChildren()) do
		if v62:IsA("Sound") and v62.Name ~= "SERVERmusic" and v62.Name ~= "SERVERvocals" then
			v62.Volume = 0.5;
		end;
	end;
	l__Config__4.TimePast.Value = -4 / p4;
	l__TweenService__17:Create(l__Config__4.TimePast, TweenInfo.new(p3 + 4 / p4, Enum.EasingStyle.Linear, Enum.EasingDirection.In, 0, false, 0), {
		Value = p3
	}):Play();
	if p5:FindFirstChild("Instrumental") then
		l__Music__18.Volume = p5.Instrumental.Volume.Value;
	end;
	if p5:FindFirstChild("Sound") then
		l__Vocals__19.Volume = p5.Sound.Volume.Value;
	end;
	l__Music__18.PitchEffect.Enabled = false;
	l__Vocals__19.PitchEffect.Enabled = false;
	if p5:FindFirstChild("Instrumental") then
		l__Music__18.SoundId = p5.Instrumental.Value;
		l__Music__18.PlaybackSpeed = p5.Instrumental.PlaybackSpeed.Value;
	end;
	if p5:FindFirstChild("Sound") then
		l__Vocals__19.SoundId = p5.Sound.Value;
		l__Vocals__19.PlaybackSpeed = p5.Sound.PlaybackSpeed.Value;
	end;
	if u17 ~= 1 then
		l__Music__18.PlaybackSpeed = l__Music__18.PlaybackSpeed * u17;
		l__Vocals__19.PlaybackSpeed = l__Vocals__19.PlaybackSpeed * u17;
		if l__LocalPlayer__2.Input.DisablePitch.Value then
			l__Music__18.PitchEffect.Enabled = true;
			l__Vocals__19.PitchEffect.Enabled = true;
			l__Music__18.PitchEffect.Octave = 1 / u17;
			l__Vocals__19.PitchEffect.Octave = 1 / u17;
		end;
	end;
	l__Music__18.TimePosition = 0;
	l__Vocals__19.TimePosition = 0;
end);
local v63 = game.ReplicatedStorage.Skins:FindFirstChild(l__LocalPlayer__2.Input.Skin.Value) or game.ReplicatedStorage.Skins.Default;
local v64 = game.ReplicatedStorage.Skins:FindFirstChild(l__LocalPlayer__2.Input.BotSkin.Value) or game.ReplicatedStorage.Skins.Default;
local v65 = Instance.new("BlurEffect");
v65.Parent = game.Lighting;
v65.Size = 0;
for v66, v67 in pairs(v28.Modifiers:GetDescendants()) do
	if v67:IsA("ImageButton") then
		v67.ImageColor3 = Color3.fromRGB(136, 136, 136);
		local u23 = false;
		v67.MouseButton1Click:Connect(function()
			u23 = not u23;
			l__TweenService__17:Create(v67, TweenInfo.new(0.4), {
				ImageColor3 = u23 and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(136, 136, 136)
			}):Play();
			if v67:FindFirstChild("misc") then
				l__TweenService__17:Create(v67.misc, TweenInfo.new(0.4), {
					ImageColor3 = u23 and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(136, 136, 136)
				}):Play();
			end;
			l__Events__5.Modifiers:FireServer(v67.Name);
		end);
		v67.MouseEnter:Connect(function()
			v67.ZIndex = 2;
			local v68 = script.ModifierLabel:Clone();
			v68.Parent = v67;
			v68.Text = "  " .. string.gsub(v67.Info.Value, "|", "\n") .. "  ";
			v68.Size = UDim2.new();
			l__TweenService__17:Create(v68, TweenInfo.new(0.125), {
				Size = v68.Size
			}):Play();
		end);
		v67.MouseLeave:Connect(function()
			while v67:FindFirstChild("ModifierLabel") do
				v67.ZIndex = 1;
				local l__ModifierLabel__69 = v67:FindFirstChild("ModifierLabel");
				if l__ModifierLabel__69 then
					l__TweenService__17:Create(l__ModifierLabel__69, TweenInfo.new(0.125, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
						Size = UDim2.new()
					}):Play();
					task.wait(0.125);
					l__ModifierLabel__69:Destroy();
				end;			
			end;
		end);
	end;
end;
function nowPlaying(p6, p7)
	local v70 = game.ReplicatedStorage.Misc.NowPlaying:Clone();
	v70.Parent = p6;
	v70.Position = v70.Position - UDim2.fromScale(0.2, 0);
	v70.Color.BackgroundColor3 = Color3.new(1, 0.75, 0);
	v70.BGColor.BackgroundColor3 = v14.MixColors(Color3.new(0.1, 0.1, 0.1), Color3.new(1, 0.75, 0));
	v70.SongName.TextColor3 = Color3.new(1, 0.75, 0);
	v70.SongName.Text = p7;
	v70.ZIndex = 99999;
	game.TweenService:Create(v70, TweenInfo.new(1), {
		Position = v70.Position + UDim2.fromScale(0.2, 0)
	}):Play();
	task.wait(5.5);
	local v71 = game.TweenService:Create(v70, TweenInfo.new(1.5, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
		Position = v70.Position - UDim2.fromScale(0.2, 0)
	});
	v71:Play();
	v71.Completed:Connect(function()
		v70:Destroy();
	end);
end;
local l__ModifierMultiplier__72 = l__Parent__3:WaitForChild("ModifierMultiplier");
v28.Modifiers.Multiplier.Text = "1x";
v28.Modifiers.Multiplier.TextColor3 = Color3.new(1, 1, 1);
l__ModifierMultiplier__72.Changed:Connect(function()
	if l__ModifierMultiplier__72.Value > 1 then
		local v73 = Color3.fromRGB(255, 255, 0);
	elseif l__ModifierMultiplier__72.Value < 1 then
		v73 = Color3.fromRGB(255, 64, 30);
	else
		v73 = Color3.fromRGB(255, 255, 255);
	end;
	v14.AnimateMultiplier(l__Parent__3, v28.Modifiers.Multiplier, v73);
	v28.Modifiers.Multiplier.Text = l__ModifierMultiplier__72.Value .. "x";
end);
local v74 = l__Parent__3.SelectionMusic:GetChildren();
local v75 = v74[math.random(1, #v74)];
v75.Volume = 0;
v75:Play();
l__TweenService__17:Create(v75, TweenInfo.new(4, Enum.EasingStyle.Quint, Enum.EasingDirection.In), {
	Volume = v75.Volume
}):Play();
l__TweenService__17:Create(workspace.CurrentCamera, TweenInfo.new(1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
	FieldOfView = 35
}):Play();
l__TweenService__17:Create(v65, TweenInfo.new(1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
	Size = 25
}):Play();
v28.Visible = true;
if l__LocalPlayer__2.Input.StreamerMode.Value == true then
	if not string.find(v75.Name, "FNF") then
		v75.PlaybackSpeed = v75.PlaybackSpeed - 0.35;
		local v76 = Instance.new("EqualizerSoundEffect");
		v76.LowGain = 20;
		v76.Parent = v75;
	end;
else
	v75.PlaybackSpeed = v75.PlaybackSpeed;
	if v75:FindFirstChildOfClass("EqualizerSoundEffect") then
		v75:FindFirstChildOfClass("EqualizerSoundEffect"):Destroy();
	end;
end;
task.delay(2.5, function()
	nowPlaying(l__Parent__3, v75.Name);
end);
v28.TimeLeft.Text = "Time Left: 15";
local u24 = nil;
u24 = l__Value__6.Config.SelectTimeLeft.Changed:Connect(function()
	if not l__Parent__3.Parent then
		u24:Disconnect();
		return;
	end;
	v28.TimeLeft.Text = "Time Left: " .. l__Value__6.Config.SelectTimeLeft.Value;
end);
l__Value__6.Events.LoadPlayer.OnClientInvoke = function(p8, p9)
	l__Parent__3.Loading.Visible = true;
	l__TweenService__17:Create(workspace.CurrentCamera, TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
		FieldOfView = 68
	}):Play();
	game.ContentProvider:PreloadAsync({ p8, p9 });
	local l__Music__77 = l__Parent__3.GameMusic.Music;
	local l__Vocals__78 = l__Parent__3.GameMusic.Vocals;
	if p8.SoundId ~= "" then
		l__Music__77.SoundId = p8.SoundId;
		while true do
			task.wait();
			if l__Music__77.TimeLength > 0 then
				break;
			end;		
		end;
	end;
	if p9.SoundId ~= "" then
		l__Vocals__78.SoundId = p9.SoundId;
		while true do
			task.wait();
			if l__Vocals__78.TimeLength > 0 then
				break;
			end;		
		end;
	end;
	task.wait(0.5);
	l__Parent__3.Loading.Visible = false;
	return true;
end;
workspace.CurrentCamera.CameraType = Enum.CameraType.Scriptable;
workspace.CurrentCamera.CFrame = l__Value__6.CameraPoints.C.CFrame;
game.StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.Backpack, false);
game.StarterGui:SetCore("ResetButtonCallback", false);
local v79 = game.ReplicatedStorage.Events.PlayerSongVote.Event:Connect(function(p10, p11, p12, p13)
	if not (not p10) and not (not p11) and not (not p12) and not (not p13) then
		l__Value__6.Events.PlayerSongVote:FireServer(p10, p11, p12, p13);
		if l__Value__6.Config.SinglePlayerEnabled.Value then
			u17 = p13;
		else
			u17 = 1;
		end;
		l__Config__4.PlaybackSpeed.Value = u17;
		return;
	end;
end);
for v80, v81 in pairs(l__LocalPlayer__2.PlayerGui.GameUI:GetChildren()) do
	if not string.match(v81.Name, "SongSelect") then
		v81.Visible = false;
	end;
end;
v28:SetAttribute("2v2", nil);
for v82, v83 in pairs(v28.SongScroller:GetChildren()) do
	if v83:GetAttribute("2V2") then
		v83.Visible = false;
	end;
end;
for v84, v85 in pairs(v28.BasicallyNil:GetChildren()) do
	if v85:GetAttribute("2V2") then
		v85.Visible = false;
	end;
end;
v28.Background.Fill.OpponentSelect.Visible = true;
v28.Background.Fill["Player 1Select"].Visible = false;
v28.Background.Fill["Player 2Select"].Visible = false;
v28.Background.Fill["Player 3Select"].Visible = false;
v28.Background.Fill["Player 4Select"].Visible = false;
while true do
	v14.wait();
	if l__Value__6.Config.Song.Value then
		break;
	end;
end;
local v86 = l__TweenService__17:Create(v65, TweenInfo.new(1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
	Size = 0
});
v86:Play();
v86.Completed:Connect(function()
	v65:Destroy();
end);
local v87 = l__TweenService__17:Create(v75, TweenInfo.new(2, Enum.EasingStyle.Quint, Enum.EasingDirection.In), {
	Volume = 0
});
v87:Play();
v87.Completed:Connect(function()
	v75:Stop();
end);
local v88 = l__Value__6.Config.Song.Value:IsA("StringValue") and l__Value__6.Config.Song.Value.Value or require(l__Value__6.Config.Song.Value);
local v89 = l__Value__6.Config.Song.Value:FindFirstAncestorOfClass("StringValue") or l__Value__6.Config.Song.Value;
if v89.Parent.Parent.Parent.Name == "Songs" and not v89:FindFirstChild("Sound") then
	v89 = v89.Parent;
end;
local v90, v91, v92, v93, v94 = v14.SpecialSongCheck(v89);
v28.Visible = false;
v79:Disconnect();
workspace.CurrentCamera.CameraType = Enum.CameraType.Scriptable;
workspace.CurrentCamera.CFrame = l__Value__6.CameraPoints.C.CFrame;
task.spawn(function()
	l__Value__6.MusicPart.Go.Played:Wait();
	v14.NowPlaying(l__Parent__3, v89, l__LocalPlayer__2);
	task.wait(1);
	game.StarterGui:SetCore("ResetButtonCallback", true);
end);
local v95 = require(l__Parent__3.Modules.Icons).SetIcons(l__Parent__3, v89);
local u25 = v88;
local v96, v97 = pcall(function()
	u25 = game.HttpService:JSONDecode(u25).song;
end);
if v97 then
	u25 = game.HttpService:JSONDecode(require(game.ReplicatedStorage.Songs["/v/-tan"].Sage.Hard)).song;
end;
u25.bpm = u25.bpm;
local v98 = 60 / (u25.bpm and 120);
local l__bpm__99 = u25.bpm;
local l__Value__100 = v89.Credits.Value;
if v89.Parent.Parent.Parent.Name == "Songs" then
	local v101 = v89:IsA("ModuleScript") and v89.Parent.Name or v89.Name;
else
	v101 = v89.Name;
end;
local l__Name__102 = l__Value__6.Config.Song.Value.Name;
local v103 = math.ceil((l__Value__6.MusicPart.SERVERvocals.TimeLength - l__Value__6.MusicPart.SERVERvocals.TimePosition) / l__Value__6.MusicPart.SERVERvocals.PlaybackSpeed);
l__Parent__3.LowerContainer.Credit.Text = v101 .. " (" .. l__Name__102 .. ")" .. " (" .. u17 .. "x)" .. "\n" .. l__Value__100 .. "\n" .. string.format("%d:%02d", math.floor(v103 / 60), v103 % 60);
if v89:FindFirstChild("MobileButtons") then
	l__Parent__3.MobileButtons:Destroy();
	v89.MobileButtons:Clone().Parent = l__Parent__3;
end;
if v89:FindFirstChild("Countdown") and game.ReplicatedStorage.Countdowns:FindFirstChild(v89.Countdown.Value) then
	local v104 = require(game.ReplicatedStorage.Countdowns:FindFirstChild(v89.Countdown.Value).Config);
	local v105 = {};
	if v104.Images ~= nil then
		for v106, v107 in pairs(v104.Images) do
			table.insert(v105, v107);
		end;
	end;
	if v104.Audio ~= nil then
		for v108, v109 in pairs(v104.Audio) do
			table.insert(v105, v109);
		end;
	end;
	game.ContentProvider:PreloadAsync(v105);
end;
local v110 = v14.ModchartCheck(l__Parent__3, v89, u25);
local v111 = v13.Start(l__Parent__3, v89:FindFirstChild("Modchart"), l__bpm__99, v110, u25, u17);
local v112 = require(l__Parent__3.Modules.Functions);
v112.keyCheck(v89, v92, v91, v93, v94);
local v113 = nil;
if v89:FindFirstChild("notetypeconvert") then
	v113 = require(v89.notetypeconvert);
end;
v112.stuffCheck(v89);
local v114 = v89:FindFirstChild("notetypeconvert") and v113.notetypeconvert or v112.notetypeconvert;
if v113 and v113.newKeys then
	v113.newKeys(l__Parent__3);
	v90 = true;
end;
local v115 = nil;
if not l__Value__6.Config.SinglePlayerEnabled.Value then
	if l__Value__6.Config.Player1.Value == l__LocalPlayer__2 then
		v115 = l__Value__6.Config.Player2.Value;
	else
		v115 = l__Value__6.Config.Player1.Value;
	end;
end;
if v115 then
	local v116 = game.ReplicatedStorage.Skins:FindFirstChild(v115.Input.Skin.Value) or game.ReplicatedStorage.Skins.Default;
else
	v116 = game.ReplicatedStorage.Skins.Default;
end;
l__Game__7.L.Arrows.IncomingNotes.DescendantAdded:Connect(function(p14)
	if not (l__Game__7.Rotation >= 90) then
		return;
	end;
	if v89:FindFirstChild("NoSettings") then
		return;
	end;
	if p14:IsA("Frame") and p14:FindFirstChild("Frame") then
		p14.Rotation = 180;
		p14.Frame.Rotation = 180;
		p14.Frame.Arrow.Rotation = 180;
	end;
end);
l__Game__7.R.Arrows.IncomingNotes.DescendantAdded:Connect(function(p15)
	if not (l__Game__7.Rotation >= 90) then
		return;
	end;
	if v89:FindFirstChild("NoSettings") then
		return;
	end;
	if p15:IsA("Frame") and p15:FindFirstChild("Frame") then
		p15.Rotation = 180;
		p15.Frame.Rotation = 180;
		p15.Frame.Arrow.Rotation = 180;
	end;
end);
local u26 = v95;
function ChangeUI(p16)
	if p16 ~= nil then
		local v117 = game.ReplicatedStorage.UIStyles[p16];
		u14 = require(v117.Config);
		l__Parent__3.LowerContainer.Bar:Destroy();
		if l__LocalPlayer__2.Input.UseOldHealthbar.Value == true then
			if p16 == "Default" then
				local v118 = v117.BarOLD:Clone();
				v118.Parent = l__Parent__3.LowerContainer;
			else
				v118 = v117.Bar:Clone();
				v118.Parent = l__Parent__3.LowerContainer;
			end;
		else
			v118 = v117.Bar:Clone();
			v118.Parent = l__Parent__3.LowerContainer;
		end;
		if u14.HealthBarColors then
			v118.Background.BackgroundColor3 = u14.HealthBarColors.Green or Color3.fromRGB(114, 255, 63);
			v118.Background.Fill.BackgroundColor3 = u14.HealthBarColors.Red or Color3.fromRGB(255, 0, 0);
		end;
		if u14.ShowIcons then
			v118.Player1.Sprite.Visible = u14.ShowIcons.Dad;
			v118.Player2.Sprite.Visible = u14.ShowIcons.BF;
		end;
		if v117:FindFirstChild("Stats") then
			l__Parent__3.LowerContainer.Stats:Destroy();
			local v119 = v117.Stats:Clone();
			v119.Parent = l__Parent__3.LowerContainer;
			if u14.font then
				v119.Label.Font = u14.font;
				l__Parent__3.Stats.Label.Font = u14.font;
				l__Parent__3.SideContainer.Data.Font = u14.font;
				l__Parent__3.SideContainer.Extra.Font = u14.font;
				l__Parent__3.SideContainer.Accuracy.Font = u14.font;
				l__Parent__3.LowerContainer.Credit.Font = u14.font;
			end;
		end;
		if u14.isPixel then
			l__Parent__3.LowerContainer.PointsA.Font = Enum.Font.Arcade;
			l__Parent__3.LowerContainer.PointsB.Font = Enum.Font.Arcade;
		else
			l__Parent__3.LowerContainer.PointsA.Font = Enum.Font.GothamBold;
			l__Parent__3.LowerContainer.PointsB.Font = Enum.Font.GothamBold;
		end;
		if u14.overrideStats then
			if u14.overrideStats.Credits then
				local v120 = string.gsub(string.gsub(string.gsub(string.gsub(string.gsub(u14.overrideStats.Credits, "{song}", v101), "{rate}", u17), "{credits}", l__Value__100), "{difficulty}", l__Name__102), "{capdifficulty}", l__Name__102:upper());
				if u14.overrideStats.Timer then
					v120 = string.gsub(v120, "{timer}", u14.overrideStats.Timer);
				end;
				l__Parent__3.LowerContainer.Credit.Text = v120;
			elseif u14.overrideStats.Timer then
				l__Parent__3.LowerContainer.Credit.Text = v101 .. " (" .. l__Name__102 .. ")" .. " (" .. u17 .. "x)" .. "\n" .. l__Value__100 .. "\n" .. u14.overrideStats.Timer;
			end;
		end;
	else
		local l__Default__121 = game.ReplicatedStorage.UIStyles.Default;
		u14 = require(l__Default__121.Config);
		l__Parent__3.LowerContainer.Bar:Destroy();
		l__Parent__3.LowerContainer.Stats:Destroy();
		l__Default__121.Bar:Clone().Parent = l__Parent__3.LowerContainer;
		l__Default__121.Stats:Clone().Parent = l__Parent__3.LowerContainer;
		l__Parent__3.LowerContainer.PointsA.Font = Enum.Font.GothamBold;
		l__Parent__3.LowerContainer.PointsB.Font = Enum.Font.GothamBold;
	end;
	v33();
	u26 = require(l__Parent__3.Modules.Icons).SetIcons(l__Parent__3, v89);
	updateUI();
end;
local u27 = {};
function updateUI(p17)
	if v22.Name == "L" then
		local v122 = "R";
	else
		v122 = "L";
	end;
	local v123 = l__Game__7:FindFirstChild(v122);
	if l__LocalPlayer__2.Input.VerticalBar.Value then
		l__Parent__3.LowerContainer.Stats.Visible = false;
		l__Parent__3.SideContainer.Accuracy.Visible = true;
	end;
	if l__LocalPlayer__2.Input.InfoBar.Value == false then
		l__Parent__3.LowerContainer.Stats.Visible = false;
		l__Parent__3.SideContainer.Accuracy.Visible = false;
	end;
	l__Parent__3.Stats.Visible = l__LocalPlayer__2.Input.ShowDebug.Value;
	l__Parent__3.SideContainer.Data.Visible = l__LocalPlayer__2.Input.JudgementCounter.Value;
	l__Parent__3.SideContainer.Extra.Visible = l__LocalPlayer__2.Input.ExtraData.Value;
	if l__LocalPlayer__2.Input.ShowOpponentStats.Value then
		if l__LocalPlayer__2.Input.Middlescroll.Value then
			v123.OpponentStats.Visible = l__LocalPlayer__2.Input.ShowOtherMS.Value;
		else
			v123.OpponentStats.Visible = l__LocalPlayer__2.Input.ShowOpponentStats.Value;
		end;
		l__Game__7.L.OpponentStats.Label.Rotation = 180;
		l__Game__7.R.OpponentStats.Label.Rotation = 180;
	end;
	if l__LocalPlayer__2.Input.HideScore.Value then
		l__Parent__3.LowerContainer.PointsA.Visible = false;
		l__Parent__3.LowerContainer.PointsB.Visible = false;
	end;
	if l__LocalPlayer__2.Input.HideCredits.Value then
		l__Parent__3.LowerContainer.Credit.Visible = false;
	end;
	local v124, v125, v126 = pairs(l__Game__7.Templates:GetChildren());
	while true do
		local v127, v128 = v124(v125, v126);
		if v127 then

		else
			break;
		end;
		v126 = v127;
		v128.Frame.Bar.End.ImageTransparency = l__LocalPlayer__2.Input.BarOpacity.Value;
		v128.Frame.Bar.ImageLabel.ImageTransparency = l__LocalPlayer__2.Input.BarOpacity.Value;	
	end;
	if not v89:FindFirstChild("NoSettings") then
		if u14 ~= nil then
			if u14.overrideStats then
				if u14.overrideStats.Position then
					if u14.overrideStats.Position.Upscroll then
						l__Parent__3.LowerContainer.Stats.Position = u14.overrideStats.Position.Upscroll;
					end;
				end;
			end;
		end;
		if u14 ~= nil then
			if u14.overrideStats then
				if u14.overrideStats.BarPosition then
					if u14.overrideStats.BarPosition.Upscroll then
						l__Parent__3.LowerContainer.Bar.Position = u14.overrideStats.BarPosition.Upscroll;
					end;
				end;
			end;
		end;
		if u14 ~= nil then
			if u14.overrideStats then
				if u14.overrideStats.IconPosition then
					l__Parent__3.LowerContainer.Bar.Player1.Sprite.Position = u14.overrideStats.IconPosition.P1.Upscroll;
					l__Parent__3.LowerContainer.Bar.Player2.Sprite.Rotation = u14.overrideStats.IconPosition.P2.Upscroll;
				end;
			end;
		end;
		if l__LocalPlayer__2.Input.VerticalBar.Value then
			if u14 ~= nil then
				if not u14.OverrideVertical then
					local l__Size__129 = l__Parent__3.LowerContainer.Bar.Size;
					l__Parent__3.LowerContainer.Bar.Position = UDim2.new(1.1, 0, -4, 0);
					l__Parent__3.LowerContainer.Bar.Size = UDim2.new(l__Size__129.X.Scale * 0.8, l__Size__129.X.Offset, l__Size__129.Y.Scale, l__Size__129.Y.Offset);
					l__Parent__3.LowerContainer.Bar.Rotation = 90;
					l__Parent__3.LowerContainer.Bar.Player1.Sprite.Rotation = -90;
					l__Parent__3.LowerContainer.Bar.Player2.Sprite.Rotation = -90;
				end;
			end;
		end;
		if l__LocalPlayer__2.Input.Downscroll.Value then
			local v130 = UDim2.new(0.5, 0, 8.9, 0);
			if u14 ~= nil then
				if u14.overrideStats then
					if u14.overrideStats.Position then
						if u14.overrideStats.Position.Downscroll then
							v130 = u14.overrideStats.Position.Downscroll;
						end;
					end;
				end;
			end;
			if u14 ~= nil then
				if u14.overrideStats then
					if u14.overrideStats.BarPosition then
						if u14.overrideStats.BarPosition.Downscroll then
							l__Parent__3.LowerContainer.Bar.Position = u14.overrideStats.BarPosition.Downscroll;
						end;
					end;
				end;
			end;
			if u14 ~= nil then
				if u14.overrideStats then
					if u14.overrideStats.IconPosition then
						l__Parent__3.LowerContainer.Bar.Player1.Sprite.Position = u14.overrideStats.IconPosition.P1.Downscroll;
						l__Parent__3.LowerContainer.Bar.Player2.Sprite.Rotation = u14.overrideStats.IconPosition.P2.Downscroll;
					end;
				end;
			end;
			l__Game__7.Rotation = 180;
			l__Game__7.Position = UDim2.new(0.5, 0, 0.05, 0);
			l__Parent__3.LowerContainer.AnchorPoint = Vector2.new(0.5, 0);
			l__Parent__3.LowerContainer.Position = UDim2.new(0.5, 0, 0.1, 0);
			l__Parent__3.LowerContainer.Stats.Position = v130;
			l__Parent__3.LowerContainer.Credit.Position = UDim2.new(-0.167, 0, -0.6, 0);
			l__Game__7.R.Position = UDim2.new(0, 0, 0, 0);
			l__Game__7.R.AnchorPoint = Vector2.new(0.1, 0);
			l__Game__7.L.Position = UDim2.new(1, 0, 0, 0);
			l__Game__7.L.AnchorPoint = Vector2.new(0.9, 0);
			l__Game__7.L.Arrows.Rotation = 180;
			l__Game__7.R.Arrows.Rotation = 180;
			l__Game__7.L.SplashContainer.Rotation = 180;
			l__Game__7.R.SplashContainer.Rotation = 180;
			l__Game__7.L.OpponentStats.Label.Rotation = 0;
			l__Game__7.R.OpponentStats.Label.Rotation = 0;
			if l__LocalPlayer__2.Input.VerticalBar.Value then
				if u14 ~= nil then
					if not u14.OverrideVertical then
						local l__Size__131 = l__Parent__3.LowerContainer.Bar.Size;
						l__Parent__3.LowerContainer.Bar.Position = UDim2.new(1.1, 0, 4, 0);
						l__Parent__3.LowerContainer.Bar.Rotation = 90;
						l__Parent__3.LowerContainer.Bar.Player1.Sprite.Rotation = -90;
						l__Parent__3.LowerContainer.Bar.Player2.Sprite.Rotation = -90;
					end;
				end;
			end;
			if not v90 then
				l__Game__7.L.Arrows.IncomingNotes.Left.Rotation = 180;
				l__Game__7.L.Arrows.IncomingNotes.Down.Rotation = 180;
				l__Game__7.L.Arrows.IncomingNotes.Up.Rotation = 180;
				l__Game__7.L.Arrows.IncomingNotes.Right.Rotation = 180;
				l__Game__7.R.Arrows.IncomingNotes.Left.Rotation = 180;
				l__Game__7.R.Arrows.IncomingNotes.Down.Rotation = 180;
				l__Game__7.R.Arrows.IncomingNotes.Up.Rotation = 180;
				l__Game__7.R.Arrows.IncomingNotes.Right.Rotation = 180;
			else
				l__Game__7.L.Arrows.IncomingNotes.Rotation = 180;
				l__Game__7.R.Arrows.IncomingNotes.Rotation = 180;
			end;
			l__Game__7.L.Glow.Rotation = 180;
			l__Game__7.R.Glow.Rotation = 180;
		elseif p17 == "Downscroll" then
			l__Game__7.Rotation = 0;
			l__Game__7.Position = UDim2.new(0.5, 0, 0.125, 0);
			l__Parent__3.LowerContainer.Position = UDim2.new(0.5, 0, 0.9, 0);
			l__Parent__3.LowerContainer.Stats.Position = UDim2.new(0.5, 0, 1, 0);
			l__Parent__3.LowerContainer.AnchorPoint = Vector2.new(0.5, 1);
			l__Parent__3.LowerContainer.Credit.Position = UDim2.new(-0.167, 0, -8.582, 0);
			l__Game__7.L.Position = UDim2.new(0, 0, 0, 0);
			l__Game__7.L.AnchorPoint = Vector2.new(0.1, 0);
			l__Game__7.R.Position = UDim2.new(1, 0, 0, 0);
			l__Game__7.R.AnchorPoint = Vector2.new(0.9, 0);
			if l__LocalPlayer__2.Input.VerticalBar.Value then
				if u14 ~= nil then
					if not u14.OverrideVertical then
						local l__Size__132 = l__Parent__3.LowerContainer.Bar.Size;
						l__Parent__3.LowerContainer.Bar.Position = UDim2.new(1.1, 0, -4, 0);
						l__Parent__3.LowerContainer.Bar.Rotation = 90;
						l__Parent__3.LowerContainer.Bar.Player1.Sprite.Rotation = -90;
						l__Parent__3.LowerContainer.Bar.Player2.Sprite.Rotation = -90;
					end;
				end;
			end;
			l__Game__7.L.Arrows.Rotation = 0;
			l__Game__7.R.Arrows.Rotation = 0;
			if not v90 then
				l__Game__7.L.Arrows.IncomingNotes.Left.Rotation = 0;
				l__Game__7.L.Arrows.IncomingNotes.Down.Rotation = 0;
				l__Game__7.L.Arrows.IncomingNotes.Up.Rotation = 0;
				l__Game__7.L.Arrows.IncomingNotes.Right.Rotation = 0;
				l__Game__7.R.Arrows.IncomingNotes.Left.Rotation = 0;
				l__Game__7.R.Arrows.IncomingNotes.Down.Rotation = 0;
				l__Game__7.R.Arrows.IncomingNotes.Up.Rotation = 0;
				l__Game__7.R.Arrows.IncomingNotes.Right.Rotation = 0;
			else
				l__Game__7.L.Arrows.IncomingNotes.Rotation = 0;
				l__Game__7.R.Arrows.IncomingNotes.Rotation = 0;
			end;
			l__Game__7.L.Glow.Rotation = 0;
			l__Game__7.R.Glow.Rotation = 0;
		end;
		if l__LocalPlayer__2.Input.Middlescroll.Value then
			v123.Visible = l__LocalPlayer__2.Input.ShowOtherMS.Value;
			v22.Position = UDim2.new(0.5, 0, 0.5, 0);
			v22.AnchorPoint = Vector2.new(0.5, 0.5);
			if l__LocalPlayer__2.Input.ShowOtherMS.Value then
				v123.OpponentStats.Size = UDim2.new(2, 0, 0.05, 0);
				v123.OpponentStats.Position = UDim2.new(0.5, 0, -0.08, 0);
				v123.AnchorPoint = Vector2.new(0.1, 0);
				v123.Size = UDim2.new(0.15, 0, 0.3, 0);
				v123.Position = v123.Name == "R" and UDim2.new(0.88, 0, 0.5, 0) or UDim2.new(0, 0, 0.5, 0);
				if l__LocalPlayer__2.Input.Downscroll.Value then
					v123.Position = v123.Name == "L" and UDim2.new(0.88, 0, 0.5, 0) or UDim2.new(0, 0, 0.5, 0);
				end;
			end;
		elseif p17 == "Middlescroll" then
			v123.Visible = true;
			l__Game__7.L.Position = UDim2.new(0, 0, 0, 0);
			l__Game__7.L.Size = UDim2.new(0.5, 0, 1, 0);
			l__Game__7.L.AnchorPoint = Vector2.new(0.1, 0);
			l__Game__7.R.AnchorPoint = Vector2.new(0.9, 0);
			l__Game__7.R.Size = UDim2.new(0.5, 0, 1, 0);
			l__Game__7.R.Position = UDim2.new(1, 0, 0, 0);
			if l__LocalPlayer__2.Input.Downscroll.Value then
				l__Game__7.R.Position = UDim2.new(0, 0, 0, 0);
				l__Game__7.R.AnchorPoint = Vector2.new(0.1, 0);
				l__Game__7.L.Position = UDim2.new(1, 0, 0, 0);
				l__Game__7.L.AnchorPoint = Vector2.new(0.9, 0);
			end;
		end;
	end;
	u27.Stats = l__Parent__3.LowerContainer.Stats.Size;
	local v133, v134, v135 = pairs(l__Parent__3.SideContainer:GetChildren());
	while true do
		local v136, v137 = v133(v134, v135);
		if v136 then

		else
			break;
		end;
		v135 = v136;
		if v137.ClassName == "TextLabel" then
			u27[v137.Name] = v137.Size;
		end;	
	end;
end;
l__Events__5.ChangeUI.Event:Connect(function(p18)
	ChangeUI(p18);
end);
local u28 = v89.Offset.Value + (l__LocalPlayer__2.Input.Offset.Value or 0);
local l__Value__29 = v63.Notes.Value;
local u30 = {
	L = {}, 
	R = {}
};
local l__Value__31 = v116.Notes.Value;
local l__Value__32 = v64.Notes.Value;
local v138 = require(game.ReplicatedStorage.Modules.Device);
local v139 = {
	L4 = "A", 
	L3 = "S", 
	L2 = "D", 
	L1 = "F", 
	Space = "Space", 
	R1 = "H", 
	R2 = "J", 
	R3 = "K", 
	R4 = "L"
};
if not v92 or v94 then
	v139 = {
		L3 = "S", 
		L2 = "D", 
		L1 = "F", 
		Space = "Space", 
		R1 = "J", 
		R2 = "K", 
		R3 = "L"
	};
end;
if not v92 and not v93 and not v91 then
	v139 = {
		L2 = "D", 
		L1 = "F", 
		Space = "Space", 
		R1 = "J", 
		R2 = "K"
	};
end;
_G.Animations = {};
if v89:FindFirstChild(l__Parent__3.PlayerSide.Value .. "_Anims") then
	local v140 = v89[l__Parent__3.PlayerSide.Value .. "_Anims"].Value;
else
	v140 = game.ReplicatedStorage.Animations:FindFirstChild(l__LocalPlayer__2.Input.Animation.Value) or (v14.findAnim(l__LocalPlayer__2.Input.Animation.Value) or game.ReplicatedStorage.Animations.Default);
end;
local u33 = {};
local u34 = nil;
local l__Animations__35 = _G.Animations;
local u36 = nil;
v1 = function(p19, p20, p21)
	if l__Parent__3.PlayerSide.Value == "R" then
		p19 = p19.Mirrored;
	end;
	if p21 then
		local v141, v142, v143 = ipairs(p19:GetChildren());
		while true do
			v141(v142, v143);
			if not v141 then
				break;
			end;
			v143 = v141;
			if v142:IsA("Animation") then
				u33[v142.Name] = p20:LoadAnimation(v142);
			end;		
		end;
		u34 = u33.Idle;
		return;
	end;
	if not p20 then
		p20 = l__LocalPlayer__2.Character.Humanoid;
	end;
	local v144, v145, v146 = ipairs(p19:GetChildren());
	while true do
		v144(v145, v146);
		if not v144 then
			break;
		end;
		v146 = v144;
		if v145:IsA("Animation") then
			l__Animations__35[v145.Name] = p20:LoadAnimation(v145);
		end;	
	end;
	u36 = l__Animations__35.Idle;
end;
if v140:FindFirstChild("Custom") then
	v1(v140, l__LocalPlayer__2.Character:WaitForChild("customrig"):WaitForChild("rig"):WaitForChild("Humanoid"));
elseif v140:FindFirstChild("FBX") then
	v1(v140, l__LocalPlayer__2.Character:WaitForChild("customrig"):WaitForChild("rig"):WaitForChild("AnimationController"):WaitForChild("Animator"));
elseif v140:FindFirstChild("2Player") then
	v1(v140.Other, l__LocalPlayer__2.Character:WaitForChild("char2"):WaitForChild("Dummy"):WaitForChild("Humanoid"), true);
	v1(v140, l__LocalPlayer__2.Character.Humanoid);
elseif v140:FindFirstChild("Custom2Player") then
	v1(v140.Other, l__LocalPlayer__2.Character:WaitForChild("char2"):WaitForChild("Dummy"):WaitForChild("Humanoid"), true);
	v1(v140, l__LocalPlayer__2.Character:WaitForChild("customrig"):WaitForChild("rig"):WaitForChild("Humanoid"));
else
	v1(v140);
end;
local u37 = Random.new();
local u38 = {};
local u39 = nil;
local u40 = nil;
local u41 = 0;
local u42 = {
	Left = false, 
	Down = false, 
	Up = false, 
	Right = false
};
if not tonumber(u25.speed) then
	u25.speed = 2.8;
end;
local l__speed__147 = u25.speed;
u25.speed = l__LocalPlayer__2.Input.ScrollSpeedChange.Value and l__LocalPlayer__2.Input.ScrollSpeed.Value + 1.5 or (u25.speed or 3.3);
if v90 then
	local v148 = 0.25;
	if v94 then
		v148 = 0.24875621890547267;
	elseif v91 then
		v148 = 0.24752475247524752;
	elseif v93 then
		v148 = 0.23584905660377356;
	elseif v92 then
		v148 = 0.2293577981651376;
	end;
	u25.speed = u25.speed / (0.25 / v148);
end;
if u34 then
	u34:AdjustSpeed(u25.speed);
	u36:AdjustSpeed(u25.speed);
	u34.Looped = true;
	u36.Looped = true;
	u34.Priority = Enum.AnimationPriority.Idle;
	u36.Priority = Enum.AnimationPriority.Idle;
	u36:Play();
	u34:Play();
else
	u36:AdjustSpeed(u25.speed);
	u36.Looped = true;
	u36.Priority = Enum.AnimationPriority.Idle;
	u36:Play();
end;
local v149 = 0.75 * u25.speed;
l__Config__4.MaxDist.Value = v149;
local v150 = Instance.new("Sound");
v150.Name = "HitSound";
v150.Parent = l__Parent__3;
v150.SoundId = "rbxassetid://" .. l__LocalPlayer__2.Input.HitSoundsValue.Value or "rbxassetid://3581383408";
v150.Volume = l__LocalPlayer__2.Input.HitSoundVolume.Value;
local u43 = {
	Left = false, 
	Down = false, 
	Up = false, 
	Right = false
};
local u44 = false;
local function u45(p22)
	local v151 = nil;
	local v152, v153, v154 = ipairs(v22.Arrows.IncomingNotes[p22]:GetChildren());
	while true do
		v152(v153, v154);
		if not v152 then
			break;
		end;
		v154 = v152;
		if (v153.Name == p22 or string.split(v153.Name, "_")[1] == p22) and (math.abs(string.split(v153:GetAttribute("NoteData"), "~")[1] - (v14.tomilseconds(l__Config__4.TimePast.Value) + u28)) <= v15.Ghost and v153.Frame.Arrow.Visible) then
			if not v151 then
				v151 = v153;
			elseif (v153.AbsolutePosition - v153.Parent.AbsolutePosition).magnitude <= (v151.AbsolutePosition - v153.Parent.AbsolutePosition).magnitude then
				v151 = v153;
			end;
		end;	
	end;
	if v151 then
		return;
	end;
	return true;
end;
local u46 = v89:FindFirstChild("Modchart") and (v89.Modchart:IsA("ModuleScript") and (v110 and require(v89.Modchart)));
local function u47(p23)
	local v155 = p23;
	if v90 then
		if v92 then
			if v155 == "A" or v155 == "H" then
				v155 = "Left";
			end;
			if v155 == "S" or v155 == "J" then
				v155 = "Down";
			end;
			if v155 == "D" or v155 == "K" or v155 == "Space" then
				v155 = "Up";
			end;
			if v155 == "F" or v155 == "L" then
				v155 = "Right";
			end;
		elseif v91 or v93 then
			if v155 == "S" or v155 == "J" then
				v155 = "Left";
			end;
			if v155 == "D" or v155 == "Space" then
				v155 = "Up";
			end;
			if v155 == "K" then
				v155 = "Down";
			end;
			if v155 == "F" or v155 == "L" then
				v155 = "Right";
			end;
		elseif v94 then
			if v155 == "D" then
				v155 = "Left";
			end;
			if v155 == "F" or v155 == "Space" then
				v155 = "Up";
			end;
			if v155 == "J" then
				v155 = "Down";
			end;
			if v155 == "K" then
				v155 = "Right";
			end;
		elseif v113 and v113.getAnimationDirection then
			v155 = v113.getAnimationDirection(v155);
		end;
	end;
	if v140:FindFirstChild(v155) then
		if v22.Name == "L" then
			local v156 = v155;
			if not v156 then
				if v155 == "Right" then
					v156 = "Left";
				elseif v155 == "Left" then
					v156 = "Right";
				else
					v156 = v155;
				end;
			end;
		elseif v155 == "Right" then
			v156 = "Left";
		elseif v155 == "Left" then
			v156 = "Right";
		else
			v156 = v155;
		end;
		local v157 = v140[v156];
		local v158 = _G.Animations[v156];
		v158.Looped = false;
		v158.TimePosition = 0;
		v158.Priority = Enum.AnimationPriority.Movement;
		if u39 and u39 ~= v158 then
			u39:Stop(0);
		end;
		u39 = v158;
		local v159 = u33[v156];
		if v159 then
			local v160 = v140.Other[v156];
			v159.Looped = false;
			v159.TimePosition = 0;
			v159.Priority = Enum.AnimationPriority.Movement;
			if u40 and u40 ~= v159 then
				u40:Stop(0);
			end;
			u40 = v159;
		end;
		task.spawn(function()
			u41 = u41 + 1;
			while u42[p23] and u41 == u41 do
				v158:Play(0);
				if v159 then
					v159:Play(0);
				end;
				for v161, v162 in u26, nil do
					if typeof(v162) ~= "string" and (v161 ~= 1 or v22.Name ~= "R") and (v161 ~= 2 or v22.Name ~= "L") then
						local v163 = nil;
						if v162.Animations then
							for v164, v165 in v162.Animations, nil do
								if v164 == v156 then
									v163 = v165;
									break;
								end;
							end;
						end;
						if v163 then
							v162:PlayAnimation(v156);
						end;
					end;
				end;
				task.wait(0.1);			
			end;
			task.wait(v158.Length - 0.15);
			if u41 == u41 then
				v158:Stop(0);
				for v166, v167 in u26, nil do
					if typeof(v167) ~= "string" and (v166 ~= 1 or v22.Name ~= "R") and (v166 ~= 2 or v22.Name ~= "L") then
						v167:PlayAnimation("Neutral");
					end;
				end;
				if l__Parent__3.Side.Value == l__Parent__3.PlayerSide.Value and l__LocalPlayer__2.Input.MoveOnHit.Value then
					local l__Value__168 = l__Parent__3.Side.Value;
					local v169 = workspace.ClientBG:FindFirstChildOfClass("Model");
					local v170 = v89:FindFirstChild("Modchart") and (v89.Modchart:IsA("ModuleScript") and (v110 and require(v89.Modchart)));
					if v170 and v170.CameraReset then
						v170.CameraReset();
					end;
					if v170 and v170.OverrideCamera then
						return;
					end;
					l__TweenService__17:Create(workspace.CurrentCamera, TweenInfo.new(l__LocalPlayer__2.Input.MoveSpeed.Value, v9, Enum.EasingDirection.Out), {
						CFrame = (v169 and v169:FindFirstChild("cameraPoints") and v169.cameraPoints:FindFirstChild(l__Value__168) or (l__Value__6.CameraPoints:FindFirstChild(l__Value__168) or l__Value__6.CameraPoints.C)).CFrame
					}):Play();
				end;
				if v159 then
					v159:Stop(0);
				end;
			end;
		end);
	end;
end;
local function u48(p24)
	if v90 and not v113 then
		return;
	end;
	if not l__LocalPlayer__2.Input.NoteSplashes.Value then
		return;
	end;
	if not game.ReplicatedStorage.Misc.Splashes:FindFirstChild(p24) then
		return;
	end;
	task.spawn(function()
		local v171 = game.ReplicatedStorage.Misc.Splashes[p24]:GetChildren();
		local v172 = v171[math.random(1, #v171)]:Clone();
		v172.Parent = v22.SplashContainer;
		v172.Position = v22.Arrows[p24].Position;
		v172.Image = (game.ReplicatedStorage.Splashes:FindFirstChild(l__LocalPlayer__2.Input.NoteSplashSkin.Value) or game.ReplicatedStorage.Splashes.Default).Splash.Value;
		v172.Size = UDim2.fromScale(l__LocalPlayer__2.Input.SplashSize.Value * v172.Size.X.Scale, l__LocalPlayer__2.Input.SplashSize.Value * v172.Size.Y.Scale);
		local l__X__173 = v172.ImageRectOffset.X;
		for v174 = 0, 8 do
			v172.ImageRectOffset = Vector2.new(l__X__173, v174 * 128);
			task.wait(0.035);
		end;
		v172:Destroy();
	end);
end;
local function u49(p25, p26)
	if not l__LocalPlayer__2.Input.MoveOnHit.Value then
		return;
	end;
	local l__Value__175 = l__Parent__3.Side.Value;
	local v176 = workspace.ClientBG:FindFirstChildOfClass("Model");
	local v177 = v89:FindFirstChild("Modchart") and (v89.Modchart:IsA("ModuleScript") and (v110 and require(v89.Modchart)));
	if v177 and v177.OverrideCamera then
		return;
	end;
	local v178 = v176 and v176:FindFirstChild("cameraPoints") and v176.cameraPoints:FindFirstChild(l__Value__175) or (l__Value__6.CameraPoints:FindFirstChild(l__Value__175) or l__Value__6.CameraPoints.C);
	if l__Parent__3.PlayerSide.Value == l__Parent__3.Side.Value and not p26 or l__Parent__3.PlayerSide.Value ~= l__Parent__3.Side.Value and p26 then
		if p25 == "Up" then
			l__TweenService__17:Create(workspace.CurrentCamera, TweenInfo.new(l__LocalPlayer__2.Input.MoveSpeed.Value, v9, Enum.EasingDirection.Out), {
				CFrame = v178.CFrame * CFrame.new(0, l__LocalPlayer__2.Input.MoveIntensity.value, 0)
			}):Play();
		end;
		if p25 == "Left" then
			l__TweenService__17:Create(workspace.CurrentCamera, TweenInfo.new(l__LocalPlayer__2.Input.MoveSpeed.Value, v9, Enum.EasingDirection.Out), {
				CFrame = v178.CFrame * CFrame.new(-l__LocalPlayer__2.Input.MoveIntensity.value, 0, 0)
			}):Play();
		end;
		if p25 == "Down" then
			l__TweenService__17:Create(workspace.CurrentCamera, TweenInfo.new(l__LocalPlayer__2.Input.MoveSpeed.Value, v9, Enum.EasingDirection.Out), {
				CFrame = v178.CFrame * CFrame.new(0, -l__LocalPlayer__2.Input.MoveIntensity.value, 0)
			}):Play();
		end;
		if p25 == "Right" then
			l__TweenService__17:Create(workspace.CurrentCamera, TweenInfo.new(l__LocalPlayer__2.Input.MoveSpeed.Value, v9, Enum.EasingDirection.Out), {
				CFrame = v178.CFrame * CFrame.new(l__LocalPlayer__2.Input.MoveIntensity.value, 0, 0)
			}):Play();
		end;
	end;
end;
local l__UserInput__50 = l__Events__5.UserInput;
local function u51(p27, p28)
	if not l__LocalPlayer__2.Input.ShowRatings.Value then
		return;
	end;
	local v179 = p28 and v22 or (l__Parent__3.PlayerSide.Value == "L" and l__Game__7.R or l__Game__7.L);
	local l__Value__180 = l__LocalPlayer__2.Input.RatingStyle.Value;
	if l__Value__180 == "FNB" then
		local v181 = v179:FindFirstChildOfClass("ImageLabel");
		if v181 then
			v181.Parent = nil;
		end;
		local v182 = v179:FindFirstChildOfClass("TextLabel");
		if v182 then
			v182.Parent = nil;
		end;
		local l__Value__183 = l__LocalPlayer__2.Input.RatingSize.Value;
		local v184 = game.ReplicatedStorage.Misc.IndicatorTemplate:Clone();
		v184.Image = "rbxthumb://type=Asset&id=" .. l__LocalPlayer__2.Input[p27 .. "IndicatorImg"].Value .. "&w=150&h=150" or l__Value__6.FlyingText.G["Template_" .. p27].Image;
		v184.Parent = v179;
		v184.Size = UDim2.new(0.25 * l__Value__183, 0, 0.083 * l__Value__183, 0);
		v184.ImageTransparency = 0;
		if l__Game__7.Rotation >= 90 then
			local v185 = 180;
		else
			v185 = 0;
		end;
		v184.Rotation = v185;
		game:GetService("Debris"):AddItem(v184, 1.5);
		if l__LocalPlayer__2.Input.CenterRatings.Value then
			v184.Position = UDim2.new(0.5, 0, 0.45, 0);
		end;
		task.spawn(function()
			if l__LocalPlayer__2.Input.RatingBounce.Value then
				l__TweenService__17:Create(v184, TweenInfo.new(0.05, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
					Size = UDim2.new(0.3 * l__Value__183, 0, 0.1 * l__Value__183, 0)
				}):Play();
			end;
			task.wait(0.1);
			l__TweenService__17:Create(v184, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
				Size = UDim2.new(0.25 * l__Value__183, 0, 0.083 * l__Value__183, 0)
			}):Play();
			task.wait(0.5);
			l__TweenService__17:Create(v184, TweenInfo.new(0.75, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
				ImageTransparency = 1
			}):Play();
		end);
		local v186 = game.ReplicatedStorage.Misc.miliseconds:Clone();
		v186.Visible = l__LocalPlayer__2.Input.ShowMS.Value;
		v186.Parent = v179;
		v186.Size = UDim2.new(0.145 * l__Value__183, 0, 0.044 * l__Value__183, 0);
		if l__Game__7.Rotation >= 90 then
			local v187 = 180;
		else
			v187 = 0;
		end;
		v186.Rotation = v187;
		v186.Text = math.floor(p28 * 100 + 0.5) / 100 .. " ms";
		if p28 < 0 then
			v186.TextColor3 = Color3.fromRGB(255, 61, 61);
		else
			v186.TextColor3 = Color3.fromRGB(120, 255, 124);
		end;
		game:GetService("Debris"):AddItem(v186, 1.5);
		if l__LocalPlayer__2.Input.CenterRatings.Value then
			v186.Position = UDim2.new(0.5, 0, 0.36, 0);
		end;
		task.spawn(function()
			if l__LocalPlayer__2.Input.RatingBounce.Value then
				l__TweenService__17:Create(v186, TweenInfo.new(0.05, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
					Size = UDim2.new(0.165 * l__Value__183, 0, 0.06 * l__Value__183, 0)
				}):Play();
			end;
			task.wait(0.1);
			l__TweenService__17:Create(v186, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
				Size = UDim2.new(0.145 * l__Value__183, 0, 0.044 * l__Value__183, 0)
			}):Play();
			task.wait(0.5);
			l__TweenService__17:Create(v186, TweenInfo.new(0.75, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
				TextTransparency = 1
			}):Play();
			l__TweenService__17:Create(v186, TweenInfo.new(0.75, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
				TextStrokeTransparency = 1
			}):Play();
		end);
	elseif l__Value__180 == "FNF" then
		local l__Value__188 = l__LocalPlayer__2.Input.RatingSize.Value;
		local v189 = game.ReplicatedStorage.Misc.IndicatorTemplate:Clone();
		v189.Image = "rbxthumb://type=Asset&id=" .. l__LocalPlayer__2.Input[p27 .. "IndicatorImg"].Value .. "&w=150&h=150" or l__Value__6.FlyingText.G["Template_" .. p27].Image;
		v189.Parent = v179;
		v189.Size = UDim2.new(0.25 * l__Value__188, 0, 0.083 * l__Value__188, 0);
		v189.ImageTransparency = 0;
		if l__Game__7.Rotation >= 90 then
			local v190 = 180;
		else
			v190 = 0;
		end;
		v189.Rotation = v190;
		if l__LocalPlayer__2.Input.Downscroll.Value then
			v189:SetAttribute("Acceleration", Vector2.new(0, -550));
			v189:SetAttribute("Velocity", Vector2.new(u37:NextInteger(0, 10), u37:NextInteger(140, 175)));
		else
			v189:SetAttribute("Acceleration", Vector2.new(0, 550));
			v189:SetAttribute("Velocity", Vector2.new(u37:NextInteger(0, 10), -u37:NextInteger(140, 175)));
		end;
		if l__LocalPlayer__2.Input.CenterRatings.Value then
			v189.Position = UDim2.new(0.5, 0, 0.45, 0);
		end;
		table.insert(u38, v189);
		local v191 = game:service("TweenService"):Create(v189, TweenInfo.new(0.2, Enum.EasingStyle.Linear, Enum.EasingDirection.Out, 0, false, v13.crochet * 0.001), {
			ImageTransparency = 1
		});
		v191:Play();
		v191.Completed:connect(function()
			v189:destroy();
			pcall(game.Destroy, v191);
		end);
		local v192 = game.ReplicatedStorage.Misc.miliseconds:Clone();
		v192.Visible = l__LocalPlayer__2.Input.ShowMS.Value;
		v192.Parent = v179;
		v192.Size = UDim2.new(0.145 * l__Value__188, 0, 0.044 * l__Value__188, 0);
		if l__Game__7.Rotation >= 90 then
			local v193 = 180;
		else
			v193 = 0;
		end;
		v192.Rotation = v193;
		v192.Text = math.floor(p28 * 100 + 0.5) / 100 .. " ms";
		if p28 < 0 then
			v192.TextColor3 = Color3.fromRGB(255, 61, 61);
		else
			v192.TextColor3 = Color3.fromRGB(120, 255, 124);
		end;
		if l__LocalPlayer__2.Input.Downscroll.Value then
			v192:SetAttribute("Acceleration", Vector2.new(0, -550));
			v192:SetAttribute("Velocity", Vector2.new(u37:NextInteger(0, 10), u37:NextInteger(140, 175)));
		else
			v192:SetAttribute("Acceleration", Vector2.new(0, 550));
			v192:SetAttribute("Velocity", Vector2.new(u37:NextInteger(0, 10), -u37:NextInteger(140, 175)));
		end;
		table.insert(u38, v192);
		if l__LocalPlayer__2.Input.CenterRatings.Value then
			v192.Position = UDim2.new(0.5, 0, 0.36, 0);
		end;
		local v194 = game:service("TweenService"):Create(v192, TweenInfo.new(0.2, Enum.EasingStyle.Linear, Enum.EasingDirection.Out, 0, false, v13.crochet * 0.001), {
			TextTransparency = 1, 
			TextStrokeTransparency = 1
		});
		v194:Play();
		v194.Completed:connect(function()
			v192:destroy();
			pcall(game.Destroy, v194);
		end);
	end;
	if not p28 then
		p28 = p27;
		if p28 <= v15.Marvelous and l__LocalPlayer__2.Input.ShowMarvelous.Value then
			p27 = "Marvelous";
			return;
		end;
		if p28 <= v15.Sick then
			p27 = "Sick";
			return;
		end;
		if p28 <= v15.Good then
			p27 = "Good";
			return;
		end;
		if p28 <= v15.Ok then
			p27 = "Ok";
			return;
		end;
		if p28 <= v15.Bad then
			p27 = "Bad";
		end;
	end;
end;
local function v195(p29, p30, p31, p32, p33)
	if not p30 then
		return;
	end;
	if p32 then
		u43[p30] = p29.UserInputState == Enum.UserInputState.Begin;
		if l__Parent__3.PlayerSide.Value == "L" then
			local v196 = "R";
		else
			v196 = "L";
		end;
		p32 = l__Game__7:FindFirstChild(v196);
	end;
	if not p32 then
		u42[p30] = p29.UserInputState == Enum.UserInputState.Begin;
	end;
	if l__Config__4.CantHitNotes.Value then
		return;
	end;
	if not v90 and l__Config__4.DisabledLanes[p30].Value then
		return;
	end;
	if u44 == true then
		local v197 = "Bloxxin";
	else
		v197 = l__LocalPlayer__2.Input.InputType.Value;
	end;
	local v198 = nil;
	if not u42[p30] and p29.UserInputState ~= Enum.UserInputState.Begin then
		return;
	end;
	if not v22.Arrows.IncomingNotes:FindFirstChild(p30) then
		return;
	end;
	local v199, v200, v201 = ipairs((p32 or v22).Arrows.IncomingNotes[p30]:GetChildren());
	while true do
		v199(v200, v201);
		if not v199 then
			break;
		end;
		v201 = v199;
		if v200.Name == p30 or string.split(v200.Name, "_")[1] == p30 then
			local v202 = v200:GetAttribute("NoteData");
			local v203 = string.split(v202, "~")[1] - (v14.tomilseconds(l__Config__4.TimePast.Value) + u28);
			if not p32 then
				if v200.Frame.Arrow.Visible and (not v200.Frame.Arrow:GetAttribute("hit") and math.abs(v203) <= v15.Bad) then
					if not v198 then
						v198 = v200;
					elseif v197 == "Bloxxin" then
						if (v200.AbsolutePosition - v200.Parent.AbsolutePosition).magnitude <= (v198.AbsolutePosition - v200.Parent.AbsolutePosition).magnitude then
							v198 = v200;
						end;
					elseif v203 < string.split(v202, "~")[1] - (v14.tomilseconds(l__Config__4.TimePast.Value) + u28) then
						v198 = v200;
					end;
				end;
			elseif v202 == p31 then
				v198 = v200;
				break;
			end;
		end;	
	end;
	if l__Config__4.GhostTappingEnabled.Value and not v198 and not p32 and u45(p30) then
		v198 = "ghost";
	end;
	local v204 = u46 and u46.FakeHit;
	if p32 then
		if v198 then
			u49(p30, true);
			if v204 then
				v198.Frame.Arrow:SetAttribute("hit", true);
			else
				v198.Frame.Arrow.Visible = false;
			end;
			if p29.UserInputState ~= Enum.UserInputState.Begin then
				return;
			else
				local v205 = nil;
				local v206 = nil;
				local v207 = nil;
				p32.Glow[p30].Arrow.ImageTransparency = 1;
				if v113 and v113.Glow then
					v113.Glow(p30, true);
				else
					p32.Glow[p30].Arrow.Visible = true;
				end;
				if p32.Glow[p30].Arrow.ImageTransparency == 1 then
					if not l__LocalPlayer__2.Input.DisableArrowGlow.Value then
						local v208 = nil;
						local v209 = nil;
						local v210 = nil;
						local v211 = nil;
						local v212 = nil;
						local v213 = nil;
						local v214 = nil;
						local v215 = nil;
						local v216 = nil;
						local v217 = nil;
						local v218 = nil;
						local v219 = nil;
						local v220 = nil;
						local v221 = nil;
						local v222 = nil;
						local v223 = nil;
						local v224 = nil;
						local v225 = nil;
						if not u30[p32.Name][p30] then
							local u52 = false;
							local u53 = nil;
							u53 = l__RunService__19.RenderStepped:Connect(function()
								if u52 then
									u53:Disconnect();
									p32.Glow[p30].Arrow.ImageTransparency = 1;
									return;
								end;
								p32.Glow[p30].Arrow.ImageTransparency = 0.2 - math.cos(tick() * 10 * math.pi) / 6;
							end);
							v208 = "Frame";
							v209 = v198;
							v210 = v208;
							v211 = v209[v210];
							local v226 = "Bar";
							v212 = v211;
							v213 = v226;
							v214 = v212[v213];
							local v227 = "Size";
							v215 = v214;
							v216 = v227;
							v217 = v215[v216];
							local v228 = "Y";
							v218 = v217;
							v219 = v228;
							v220 = v218[v219];
							local v229 = "Scale";
							v222 = v220;
							v223 = v229;
							v221 = v222[v223];
							local v230 = 0;
							v224 = v230;
							v225 = v221;
							if v224 < v225 then
								local v231 = tick();
								while true do
									v14.wait();
									local v232 = v198.Position.Y.Scale;
									if v90 then
										local v233 = 0.25;
										if v94 then
											v233 = 0.24875621890547267;
										elseif v91 then
											v233 = 0.24752475247524752;
										elseif v93 then
											v233 = 0.23584905660377356;
										elseif v92 then
											v233 = 0.2293577981651376;
										end;
										v232 = v232 * (0.25 / v233);
									end;
									if v232 < 0 and not v204 then
										v198.Frame.Bar.Size = UDim2.new(l__LocalPlayer__2.Input.BarSize.Value, 0, math.clamp(v221 + v232, 0, 20), 0);
										v198.Frame.Bar.Position = UDim2.new(0.5, 0, 0.5 - v232, 0);
									end;
									if not u43[p30] then
										break;
									end;
									if v198.Frame.Bar.Size.Y.Scale == 0 then
										break;
									end;
									if tick() - v231 > 7.5 then
										break;
									end;								
								end;
							else
								v14.wait(0.175);
							end;
							local v234 = true;
							v205 = v113;
							v206 = v205;
							if v206 and v113.Glow then
								v113.Glow(p30, false);
							else
								p32.Glow[p30].Arrow.Visible = false;
							end;
							local v235 = u46;
							v207 = v235;
							if v207 and u46.OpponentHit then
								u46.OpponentHit(l__Parent__3, p30);
							end;
							return;
						elseif not l__LocalPlayer__2.Input.DisableArrowGlow.Value and u30[p32.Name][p30] then
							if false then
								u24:Disconnect();
								u30[p32.Name][p30]:PlayAnimation("Receptor");
								return;
							else
								u30[p32.Name][p30]:PlayAnimation("Glow");
								v208 = "Frame";
								v209 = v198;
								v210 = v208;
								v211 = v209[v210];
								v226 = "Bar";
								v212 = v211;
								v213 = v226;
								v214 = v212[v213];
								v227 = "Size";
								v215 = v214;
								v216 = v227;
								v217 = v215[v216];
								v228 = "Y";
								v218 = v217;
								v219 = v228;
								v220 = v218[v219];
								v229 = "Scale";
								v222 = v220;
								v223 = v229;
								v221 = v222[v223];
								v230 = 0;
								v224 = v230;
								v225 = v221;
								if v224 < v225 then
									v231 = tick();
									while true do
										v14.wait();
										v232 = v198.Position.Y.Scale;
										if v90 then
											v233 = 0.25;
											if v94 then
												v233 = 0.24875621890547267;
											elseif v91 then
												v233 = 0.24752475247524752;
											elseif v93 then
												v233 = 0.23584905660377356;
											elseif v92 then
												v233 = 0.2293577981651376;
											end;
											v232 = v232 * (0.25 / v233);
										end;
										if v232 < 0 and not v204 then
											v198.Frame.Bar.Size = UDim2.new(l__LocalPlayer__2.Input.BarSize.Value, 0, math.clamp(v221 + v232, 0, 20), 0);
											v198.Frame.Bar.Position = UDim2.new(0.5, 0, 0.5 - v232, 0);
										end;
										if not u43[p30] then
											break;
										end;
										if v198.Frame.Bar.Size.Y.Scale == 0 then
											break;
										end;
										if tick() - v231 > 7.5 then
											break;
										end;									
									end;
								else
									v14.wait(0.175);
								end;
								v234 = true;
								v205 = v113;
								v206 = v205;
								if v206 and v113.Glow then
									v113.Glow(p30, false);
								else
									p32.Glow[p30].Arrow.Visible = false;
								end;
								v235 = u46;
								v207 = v235;
								if v207 and u46.OpponentHit then
									u46.OpponentHit(l__Parent__3, p30);
								end;
								return;
							end;
						else
							v208 = "Frame";
							v209 = v198;
							v210 = v208;
							v211 = v209[v210];
							v226 = "Bar";
							v212 = v211;
							v213 = v226;
							v214 = v212[v213];
							v227 = "Size";
							v215 = v214;
							v216 = v227;
							v217 = v215[v216];
							v228 = "Y";
							v218 = v217;
							v219 = v228;
							v220 = v218[v219];
							v229 = "Scale";
							v222 = v220;
							v223 = v229;
							v221 = v222[v223];
							v230 = 0;
							v224 = v230;
							v225 = v221;
							if v224 < v225 then
								v231 = tick();
								while true do
									v14.wait();
									v232 = v198.Position.Y.Scale;
									if v90 then
										v233 = 0.25;
										if v94 then
											v233 = 0.24875621890547267;
										elseif v91 then
											v233 = 0.24752475247524752;
										elseif v93 then
											v233 = 0.23584905660377356;
										elseif v92 then
											v233 = 0.2293577981651376;
										end;
										v232 = v232 * (0.25 / v233);
									end;
									if v232 < 0 and not v204 then
										v198.Frame.Bar.Size = UDim2.new(l__LocalPlayer__2.Input.BarSize.Value, 0, math.clamp(v221 + v232, 0, 20), 0);
										v198.Frame.Bar.Position = UDim2.new(0.5, 0, 0.5 - v232, 0);
									end;
									if not u43[p30] then
										break;
									end;
									if v198.Frame.Bar.Size.Y.Scale == 0 then
										break;
									end;
									if tick() - v231 > 7.5 then
										break;
									end;								
								end;
							else
								v14.wait(0.175);
							end;
							v234 = true;
							v205 = v113;
							v206 = v205;
							if v206 and v113.Glow then
								v113.Glow(p30, false);
							else
								p32.Glow[p30].Arrow.Visible = false;
							end;
							v235 = u46;
							v207 = v235;
							if v207 and u46.OpponentHit then
								u46.OpponentHit(l__Parent__3, p30);
							end;
							return;
						end;
					elseif not l__LocalPlayer__2.Input.DisableArrowGlow.Value and u30[p32.Name][p30] then
						if false then
							u24:Disconnect();
							u30[p32.Name][p30]:PlayAnimation("Receptor");
							return;
						else
							u30[p32.Name][p30]:PlayAnimation("Glow");
							v208 = "Frame";
							v209 = v198;
							v210 = v208;
							v211 = v209[v210];
							v226 = "Bar";
							v212 = v211;
							v213 = v226;
							v214 = v212[v213];
							v227 = "Size";
							v215 = v214;
							v216 = v227;
							v217 = v215[v216];
							v228 = "Y";
							v218 = v217;
							v219 = v228;
							v220 = v218[v219];
							v229 = "Scale";
							v222 = v220;
							v223 = v229;
							v221 = v222[v223];
							v230 = 0;
							v224 = v230;
							v225 = v221;
							if v224 < v225 then
								v231 = tick();
								while true do
									v14.wait();
									v232 = v198.Position.Y.Scale;
									if v90 then
										v233 = 0.25;
										if v94 then
											v233 = 0.24875621890547267;
										elseif v91 then
											v233 = 0.24752475247524752;
										elseif v93 then
											v233 = 0.23584905660377356;
										elseif v92 then
											v233 = 0.2293577981651376;
										end;
										v232 = v232 * (0.25 / v233);
									end;
									if v232 < 0 and not v204 then
										v198.Frame.Bar.Size = UDim2.new(l__LocalPlayer__2.Input.BarSize.Value, 0, math.clamp(v221 + v232, 0, 20), 0);
										v198.Frame.Bar.Position = UDim2.new(0.5, 0, 0.5 - v232, 0);
									end;
									if not u43[p30] then
										break;
									end;
									if v198.Frame.Bar.Size.Y.Scale == 0 then
										break;
									end;
									if tick() - v231 > 7.5 then
										break;
									end;								
								end;
							else
								v14.wait(0.175);
							end;
							v234 = true;
							v205 = v113;
							v206 = v205;
							if v206 and v113.Glow then
								v113.Glow(p30, false);
							else
								p32.Glow[p30].Arrow.Visible = false;
							end;
							v235 = u46;
							v207 = v235;
							if v207 and u46.OpponentHit then
								u46.OpponentHit(l__Parent__3, p30);
							end;
							return;
						end;
					else
						v208 = "Frame";
						v209 = v198;
						v210 = v208;
						v211 = v209[v210];
						v226 = "Bar";
						v212 = v211;
						v213 = v226;
						v214 = v212[v213];
						v227 = "Size";
						v215 = v214;
						v216 = v227;
						v217 = v215[v216];
						v228 = "Y";
						v218 = v217;
						v219 = v228;
						v220 = v218[v219];
						v229 = "Scale";
						v222 = v220;
						v223 = v229;
						v221 = v222[v223];
						v230 = 0;
						v224 = v230;
						v225 = v221;
						if v224 < v225 then
							v231 = tick();
							while true do
								v14.wait();
								v232 = v198.Position.Y.Scale;
								if v90 then
									v233 = 0.25;
									if v94 then
										v233 = 0.24875621890547267;
									elseif v91 then
										v233 = 0.24752475247524752;
									elseif v93 then
										v233 = 0.23584905660377356;
									elseif v92 then
										v233 = 0.2293577981651376;
									end;
									v232 = v232 * (0.25 / v233);
								end;
								if v232 < 0 and not v204 then
									v198.Frame.Bar.Size = UDim2.new(l__LocalPlayer__2.Input.BarSize.Value, 0, math.clamp(v221 + v232, 0, 20), 0);
									v198.Frame.Bar.Position = UDim2.new(0.5, 0, 0.5 - v232, 0);
								end;
								if not u43[p30] then
									break;
								end;
								if v198.Frame.Bar.Size.Y.Scale == 0 then
									break;
								end;
								if tick() - v231 > 7.5 then
									break;
								end;							
							end;
						else
							v14.wait(0.175);
						end;
						v234 = true;
						v205 = v113;
						v206 = v205;
						if v206 and v113.Glow then
							v113.Glow(p30, false);
						else
							p32.Glow[p30].Arrow.Visible = false;
						end;
						v235 = u46;
						v207 = v235;
						if v207 and u46.OpponentHit then
							u46.OpponentHit(l__Parent__3, p30);
						end;
						return;
					end;
				else
					v205 = v113;
					v206 = v205;
					if v206 and v113.Glow then
						v113.Glow(p30, false);
					else
						p32.Glow[p30].Arrow.Visible = false;
					end;
					v235 = u46;
					v207 = v235;
					if v207 and u46.OpponentHit then
						u46.OpponentHit(l__Parent__3, p30);
					end;
					return;
				end;
			end;
		else
			return;
		end;
	end;
	u47(p30);
	if v198 and v198 ~= "ghost" then
		if v198:FindFirstChild("HitSound") then
			v14.PlaySound(v198.HitSound.Value, v198.HitSound.parent, 2.25);
		elseif l__LocalPlayer__2.Input.HitSounds.Value == true then
			v14.PlaySound(v150);
		end;
		local v236 = string.split(v198:GetAttribute("NoteData"), "~")[1] - (v14.tomilseconds(l__Config__4.TimePast.Value) + u28);
		local v237 = math.abs(v236);
		local v238 = string.split(v198.Name, "_")[1];
		if v237 <= v15.Sick then
			u48(v238);
		end;
		if l__LocalPlayer__2.Input.ScoreBop.Value then
			if l__LocalPlayer__2.Input.VerticalBar.Value then
				for v239, v240 in pairs(l__Parent__3.SideContainer:GetChildren()) do
					if v240.ClassName == "TextLabel" then
						v240.Size = UDim2.new(u27[v240.Name].X.Scale * 1.1, 0, u27[v240.Name].Y.Scale * 1.1, 0);
						l__TweenService__17:Create(v240, TweenInfo.new(0.3), {
							Size = u27[v240.Name]
						}):Play();
					end;
				end;
			else
				l__Parent__3.LowerContainer.Stats.Size = UDim2.new(u27.Stats.X.Scale * 1.1, 0, u27.Stats.Y.Scale * 1.1, 0);
				l__TweenService__17:Create(l__Parent__3.LowerContainer.Stats, TweenInfo.new(0.3), {
					Size = u27.Stats
				}):Play();
			end;
		end;
		u49(v238);
		u3 = u3 + 1;
		v33();
		if u46 and u46.UpdateStats then
			u46.UpdateStats(l__Parent__3);
		end;
		if u46 and u46.OnHit then
			u46.OnHit(l__Parent__3, u5, u3, v238, u2, p30);
		end;
		if v198.HellNote.Value == false then
			local v241 = "0";
		else
			v241 = "1";
		end;
		l__UserInput__50:FireServer(v198, p30 .. "|0|" .. v14.tomilseconds(l__Config__4.TimePast.Value) + u28 .. "|" .. v198.Position.Y.Scale .. "|" .. v198:GetAttribute("NoteData") .. "|" .. v198.Name .. "|" .. v198:GetAttribute("Length") .. "|" .. tostring(v241));
		table.insert(u12, {
			ms = v236, 
			songPos = l__Parent__3.Config.TimePast.Value, 
			miss = false
		});
		if v204 then
			v198.Frame.Arrow:SetAttribute("hit", true);
		else
			v198.Frame.Arrow.Visible = false;
		end;
		if not u42[p30] then
			return;
		end;
		v22.Glow[p30].Arrow.ImageTransparency = 1;
		if v113 and v113.Glow then
			v113.Glow(p30, true);
		else
			v22.Glow[p30].Arrow.Visible = true;
		end;
		if v22.Glow[p30].Arrow.ImageTransparency == 1 then
			if not l__LocalPlayer__2.Input.DisableArrowGlow.Value and not u30[v22.Name][p30] then
				local u54 = false;
				local u55 = nil;
				u55 = l__RunService__19.RenderStepped:Connect(function()
					if u54 then
						u55:Disconnect();
						v22.Glow[p30].Arrow.ImageTransparency = 1;
						return;
					end;
					v22.Glow[p30].Arrow.ImageTransparency = 0.2 - math.cos(tick() * 10 * math.pi) / 6 + v22.Arrows[p30].ImageTransparency / 1.25;
				end);
			elseif not l__LocalPlayer__2.Input.DisableArrowGlow.Value and u30[v22.Name][p30] then
				if false then
					u24:Disconnect();
					u30[v22.Name][p30]:PlayAnimation("Receptor");
					return;
				end;
				u30[v22.Name][p30]:PlayAnimation("Glow");
			end;
			local l__Scale__242 = v198.Frame.Bar.Size.Y.Scale;
			if l__Scale__242 > 0 then
				local v243 = math.abs(v236);
				while true do
					task.wait();
					local v244 = v198.Position.Y.Scale;
					if v90 then
						local v245 = 0.25;
						if v94 then
							v245 = 0.24875621890547267;
						elseif v91 then
							v245 = 0.24752475247524752;
						elseif v93 then
							v245 = 0.23584905660377356;
						elseif v92 then
							v245 = 0.2293577981651376;
						end;
						v244 = v244 * (0.25 / v245);
					end;
					if v244 < 0 and v198:FindFirstChild("Frame") and not v204 then
						v198.Frame.Bar.Size = UDim2.new(l__LocalPlayer__2.Input.BarSize.Value, 0, math.clamp(l__Scale__242 + v244, 0, 20), 0);
						v198.Frame.Bar.Position = UDim2.new(0.5, 0, 0.5 - v244, 0);
					end;
					if not u42[p30] then
						break;
					end;				
				end;
				if v198.HellNote.Value == false then
					local v246 = "0";
				else
					v246 = "1";
				end;
				l__UserInput__50:FireServer(v198, p30 .. "|1|" .. v14.tomilseconds(l__Config__4.TimePast.Value) + u28 .. "|" .. v198.Position.Y.Scale .. "|" .. v198:GetAttribute("NoteData") .. "|" .. v198.Name .. "|" .. v198:GetAttribute("Length") .. "|" .. tostring(v246));
				local v247 = 1 - math.clamp(math.abs(v198.Position.Y.Scale) / v198:GetAttribute("Length"), 0, 1);
				local v248 = v243 + v198:GetAttribute("SustainLength") * v247;
				if v247 <= v149 / 10 then
					if v243 <= v15.Marvelous and l__LocalPlayer__2.Input.ShowMarvelous.Value then
						local v249 = "Marvelous";
					else
						v249 = "Sick";
					end;
					u51(v249, v236);
					table.insert(u1, 1, 100);
					if v243 <= v15.Marvelous and l__LocalPlayer__2.Input.ShowMarvelous.Value then
						u6 = u6 + 1;
					else
						u7 = u7 + 1;
					end;
				elseif v247 <= v149 / 6 then
					u51("Good", v236);
					table.insert(u1, 1, 90);
					u8 = u8 + 1;
					if l__Parent__3:GetAttribute("Perfect") then
						l__LocalPlayer__2.Character.Humanoid.Health = 0;
					end;
				elseif v247 <= v149 then
					u51("Bad", v236);
					table.insert(u1, 1, 60);
					u10 = u10 + 1;
					if l__Parent__3:GetAttribute("Perfect") then
						l__LocalPlayer__2.Character.Humanoid.Health = 0;
					end;
				end;
				v33();
				if u46 and u46.UpdateStats then
					u46.UpdateStats(l__Parent__3);
				end;
				if not v204 then
					v198.Visible = false;
				end;
			else
				if v198.HellNote.Value ~= false then

				end;
				if v237 <= v15.Marvelous * 1 and l__LocalPlayer__2.Input.ShowMarvelous.Value then
					u51("Marvelous", v236);
					table.insert(u1, 1, 100);
					u6 = u6 + 1;
				elseif v237 <= v15.Sick * 1 then
					u51("Sick", v236);
					table.insert(u1, 1, 100);
					u7 = u7 + 1;
				elseif v237 <= v15.Good * 1 then
					u51("Good", v236);
					table.insert(u1, 1, 90);
					u8 = u8 + 1;
					if l__Parent__3:GetAttribute("Perfect") then
						l__LocalPlayer__2.Character.Humanoid.Health = 0;
					end;
				elseif v237 <= v15.Ok * 1 then
					u51("Ok", v236);
					table.insert(u1, 1, 75);
					u9 = u9 + 1;
					if l__Parent__3:GetAttribute("Perfect") then
						l__LocalPlayer__2.Character.Humanoid.Health = 0;
					end;
				elseif v237 <= v15.Bad * 1 then
					u51("Bad", v236);
					table.insert(u1, 1, 60);
					u10 = u10 + 1;
					if l__Parent__3:GetAttribute("Perfect") then
						l__LocalPlayer__2.Character.Humanoid.Health = 0;
					end;
				end;
				v33();
				if u46 and u46.UpdateStats then
					u46.UpdateStats(l__Parent__3);
				end;
				while true do
					v14.wait();
					if not u42[p30] then
						break;
					end;				
				end;
				if not v204 then
					v198.Visible = false;
				end;
			end;
		end;
		if v113 and v113.Glow then
			v113.Glow(p30, false);
		else
			v22.Glow[p30].Arrow.Visible = false;
		end;
	end;
	if not u42[p30] then
		return;
	end;
	if v198 ~= "ghost" then
		l__UserInput__50:FireServer("missed", p30 .. "|0");
		table.insert(u1, 1, 0);
		u4 = u4 + 1;
		u3 = 0;
		v33();
		if u46 and u46.UpdateStats then
			u46.UpdateStats(l__Parent__3);
		end;
		table.insert(u12, {
			ms = 0, 
			songPos = l__Parent__3.Config.TimePast.Value, 
			miss = true
		});
		if u46 and u46.OnMiss then
			u46.OnMiss(l__Parent__3, u4, u2, p30);
		end;
		if l__Parent__3:GetAttribute("SuddenDeath") and l__Config__4.TimePast.Value > 5 then
			l__LocalPlayer__2.Character.Humanoid.Health = 0;
		end;
		local v250 = l__Parent__3.Sounds:GetChildren()[math.random(1, #l__Parent__3.Sounds:GetChildren())]:Clone();
		v250.Name = "MissSound";
		v250.Parent = l__Parent__3;
		v250.Volume = l__LocalPlayer__2.Input.MissVolume.Value and 0.3;
		if l__LocalPlayer__2.Input.MissSoundValue.Value ~= 0 then
			v250.SoundId = "rbxassetid://" .. l__LocalPlayer__2.Input.MissSoundValue.Value;
		end;
		v250:Play();
	end;
	local v251 = v22.Arrows[p30];
	u42[p30] = true;
	if u30[v22.Name][p30] then
		u30[v22.Name][p30]:PlayAnimation("Press");
	elseif v251:FindFirstChild("Overlay") then
		v251.Overlay.Visible = true;
	else
		v113.Pressed(p30, true, l__Parent__3);
	end;
	local v252 = 1;
	if v93 then
		v252 = 0.85;
	end;
	if v92 then
		v252 = 0.7;
	end;
	if v113 then
		v252 = v113.CustomArrowSize and 1;
	end;
	local v253 = v252 * l__LocalPlayer__2.Input.ArrowSize.Value;
	l__TweenService__17:Create(v251, TweenInfo.new(0.05, Enum.EasingStyle.Linear, Enum.EasingDirection.In, 0, false, 0), {
		Size = v198 == "ghost" and UDim2.new(v253 / 1.05, 0, v253 / 1.05, 0) or UDim2.new(v253 / 1.25, 0, v253 / 1.25, 0)
	}):Play();
	while true do
		task.wait();
		if not u42[p30] then
			break;
		end;	
	end;
	if u30[v22.Name][p30] then
		u30[v22.Name][p30]:PlayAnimation("Receptor");
	elseif v251:FindFirstChild("Overlay") then
		v251.Overlay.Visible = false;
	else
		v113.Pressed(p30, false, l__Parent__3);
	end;
	l__TweenService__17:Create(v251, TweenInfo.new(0.05, Enum.EasingStyle.Quint, Enum.EasingDirection.Out, 0, false, 0), {
		Size = UDim2.new(v253, 0, v253, 0)
	}):Play();
end;
local v254 = nil;
local l__Value__255 = _G.LastInput.Value;
if l__Value__255 == Enum.UserInputType.Touch then
	script.Device.Value = "Mobile";
	v14.wait(0.2);
	local v256, v257, v258 = ipairs(l__Parent__3.MobileButtons.Container:GetChildren());
	while true do
		v256(v257, v258);
		if not v256 then
			break;
		end;
		v258 = v256;
		if v257:IsA("ImageButton") then
			v257.MouseButton1Down:Connect(function()
				v195({
					UserInputState = Enum.UserInputState.Begin
				}, v257.Name);
			end);
			v257.MouseButton1Up:Connect(function()
				v195({
					UserInputState = Enum.UserInputState.End
				}, v257.Name);
			end);
		end;	
	end;
	script.Parent.MobileButtons.Visible = true;
elseif l__Value__255 == Enum.UserInputType.Keyboard then
	script.Device.Value = "Computer";
	local function v259(p34, p35)
		if p35 then
			return;
		end;
		local l__Keybinds__260 = l__LocalPlayer__2.Input.Keybinds;
		if v113 and v113.getDirection then
			local v261 = v113.getDirection(p34.KeyCode, l__Keybinds__260);
			if v261 then
				v195(p34, v261);
				return;
			end;
		else
			if v90 then
				local v262, v263, v264 = ipairs(l__Keybinds__260:GetChildren());
				while true do
					v262(v263, v264);
					if not v262 then
						break;
					end;
					v264 = v262;
					if v263:GetAttribute("ExtraKey") and p34.KeyCode.Name == v263.Value then
						v195(p34, v139[v263.Name]);
						return;
					end;				
				end;
				return;
			end;
			local v265, v266, v267 = ipairs(l__Keybinds__260:GetChildren());
			while true do
				v265(v266, v267);
				if not v265 then
					break;
				end;
				v267 = v265;
				if not v266:GetAttribute("ExtraKey") then
					if p34.KeyCode.Name == v266.Value then
						local l__Name__268 = v266.Name;
						if v266:GetAttribute("SecondaryKey") then
							local v269 = v266:GetAttribute("Key");
						end;
						v195(p34, v266:GetAttribute("SecondaryKey") and v266:GetAttribute("Key") or v266.Name);
						return;
					end;
					if v266:GetAttribute("SecondaryKey") and p34.KeyCode.Name == v266:GetAttribute("Key") then
						l__Name__268 = v266.Name;
						if v266:GetAttribute("SecondaryKey") then
							v269 = v266:GetAttribute("Key");
						end;
						v195(p34, v266:GetAttribute("SecondaryKey") and v266:GetAttribute("Key") or v266.Name);
						return;
					end;
				end;			
			end;
		end;
	end;
	v254 = l__UserInputService__18.InputBegan:connect(v259);
	local v270 = l__UserInputService__18.InputEnded:connect(v259);
elseif l__Value__255 == Enum.UserInputType.Gamepad1 then
	script.Device.Value = "Controller";
	local function v271(p36, p37)
		local l__XBOXKeybinds__272 = l__LocalPlayer__2.Input.XBOXKeybinds;
		if v113 and v113.getDirection then
			local v273 = v113.getDirection(p36.KeyCode, l__XBOXKeybinds__272);
			if v273 then
				v195(p36, v273);
				return;
			end;
		elseif v90 then
			local v274, v275, v276 = ipairs(l__XBOXKeybinds__272:GetChildren());
			while true do
				v274(v275, v276);
				if not v274 then
					break;
				end;
				v276 = v274;
				if v275:GetAttribute("ExtraKey") and p36.KeyCode.Name == v275.Value then
					v195(p36, v139[v275.Name:sub(12, -1)]);
					return;
				end;			
			end;
			return;
		else
			local v277, v278, v279 = ipairs(l__XBOXKeybinds__272:GetChildren());
			while true do
				v277(v278, v279);
				if not v277 then
					break;
				end;
				v279 = v277;
				if not v278:GetAttribute("ExtraKey") and p36.KeyCode.Name == v278.Value then
					v195(p36, v278.Name:sub(12, -1));
					return;
				end;			
			end;
		end;
	end;
	v254 = l__UserInputService__18.InputBegan:connect(v271);
	local v280 = l__UserInputService__18.InputEnded:connect(v271);
end;
if l__Parent__3.PlayerSide.Value == "L" then
	local v281 = l__Value__6.Events.Player2Hit.OnClientEvent:Connect(function(p38)
		p38 = string.split(p38, "|");
		v195({
			UserInputState = p38[2] == "0" and Enum.UserInputState.Begin or Enum.UserInputState.End
		}, p38[1], string.gsub(p38[3], "~", "|") .. "~" .. p38[4], true, (tonumber(p38[5])));
	end);
else
	v281 = l__Value__6.Events.Player1Hit.OnClientEvent:Connect(function(p39)
		p39 = string.split(p39, "|");
		v195({
			UserInputState = p39[2] == "0" and Enum.UserInputState.Begin or Enum.UserInputState.End
		}, p39[1], string.gsub(p39[3], "~", "|") .. "~" .. p39[4], true, (tonumber(p39[5])));
	end);
end;
l__Parent__3.Side.Changed:Connect(function()
	if u46 and u46.OverrideCamera then
		return;
	end;
	local l__Value__282 = l__Parent__3.Side.Value;
	local v283 = workspace.ClientBG:FindFirstChildOfClass("Model");
	l__TweenService__17:Create(workspace.CurrentCamera, TweenInfo.new(l__LocalPlayer__2.Input.CameraSpeed.Value, v9, Enum.EasingDirection.Out, 0, false, 0), {
		CFrame = (v283 and v283:FindFirstChild("cameraPoints") and v283.cameraPoints:FindFirstChild(l__Value__282) or (l__Value__6.CameraPoints:FindFirstChild(l__Value__282) or l__Value__6.CameraPoints.C)).CFrame
	}):Play();
end);
if l__LocalPlayer__2.Input.HideMap.Value and not v89:FindFirstChild("ForceBackgrounds") then
	local v284 = Instance.new("Frame");
	v284.Parent = l__Parent__3;
	v284.Position = UDim2.new(0, 0, 0, 0);
	v284.BackgroundColor3 = Color3.fromRGB(0, 0, 0);
	v284.Size = UDim2.new(1, 0, 1, 0);
	v284.BackgroundTransparency = 1;
	l__LocalPlayer__2.Character:WaitForChild("Humanoid").Died:Connect(function()
		game.ReplicatedStorage.Events.UnloadBackground:Fire();
	end);
	l__TweenService__17:Create(v284, TweenInfo.new(0.4), {
		BackgroundTransparency = 0
	}):Play();
	task.wait(0.4);
	task.spawn(function()
		l__TweenService__17:Create(v284, TweenInfo.new(0.4), {
			BackgroundTransparency = 1
		}):Play();
		task.wait(0.4);
		v284:Destroy();
	end);
	for v285, v286 in pairs(workspace:GetDescendants()) do
		if not v286:IsDescendantOf(l__Value__6) and not v286:IsDescendantOf(workspace.Misc.ActualShop) and (not l__Value__6.Seat.Occupant or not v286:IsDescendantOf(l__Value__6.Seat.Occupant.Parent)) and (not l__Value__6.Config.Player1.Value or not v286:IsDescendantOf(l__Value__6.Config.Player1.Value.Character)) and (not l__Value__6.Config.Player2.Value or not v286:IsDescendantOf(l__Value__6.Config.Player2.Value.Character)) then
			if not (not v286:IsA("BasePart")) or not (not v286:IsA("Decal")) or v286:IsA("Texture") then
				v286.Transparency = 1;
			elseif v286:IsA("GuiObject") then
				v286.Visible = false;
			elseif v286:IsA("Beam") or v286:IsA("ParticleEmitter") then
				v286.Enabled = false;
			end;
		end;
	end;
	local v287 = game.ReplicatedStorage.Misc.DarkVoid:Clone();
	v287.Parent = workspace.ClientBG;
	v287:SetPrimaryPartCFrame(l__Value__6.BackgroundPart.CFrame);
	for v288, v289 in pairs(game.Lighting:GetChildren()) do
		v289:Destroy();
	end;
	for v290, v291 in pairs(v287.Lighting:GetChildren()) do
		v291:Clone().Parent = game.Lighting;
	end;
	l__Value__6.Misc.Stereo.Speakers.Transparency = 1;
	for v292, v293 in pairs(l__Value__6.Fireworks:GetChildren()) do
		v293.Transparency = 1;
	end;
end;
local u56 = false;
l__Events__5.ChangeBackground.Event:Connect(function(p40, p41, p42)
	if (not l__LocalPlayer__2.Input.Backgrounds.Value or l__LocalPlayer__2.Input.HideMap.Value) and not v89:FindFirstChild("ForceBackgrounds") then
		return;
	end;
	local l__Backgrounds__294 = game.ReplicatedStorage.Backgrounds;
	local v295 = l__Backgrounds__294:FindFirstChild(p41) and l__Backgrounds__294[p41]:Clone() or game.ReplicatedStorage.Events.Backgrounds:InvokeServer("Load", p40, p41, v89);
	if not l__Backgrounds__294:FindFirstChild(p41) then
		v295:Clone().Parent = l__Backgrounds__294;
	end;
	for v296, v297 in pairs(workspace.ClientBG:GetChildren()) do
		v297:Destroy();
	end;
	if l__Value__6.Config.CleaningUp.Value then
		return;
	end;
	if not u56 then
		u56 = true;
		local v298 = Instance.new("Frame");
		v298.Parent = l__Parent__3;
		v298.Position = UDim2.new(0, 0, 0, 0);
		v298.BackgroundColor3 = Color3.fromRGB(0, 0, 0);
		v298.Size = UDim2.new(1, 0, 1, 0);
		v298.BackgroundTransparency = 1;
		l__TweenService__17:Create(v298, TweenInfo.new(0.4), {
			BackgroundTransparency = 0
		}):Play();
		task.wait(0.4);
		task.spawn(function()
			l__TweenService__17:Create(v298, TweenInfo.new(0.4), {
				BackgroundTransparency = 1
			}):Play();
			task.wait(0.4);
			v298:Destroy();
		end);
		for v299, v300 in pairs(workspace:GetDescendants()) do
			if not v300:IsDescendantOf(l__Value__6) and not v300:IsDescendantOf(workspace.Misc.ActualShop) and (not l__Value__6.Seat.Occupant or not v300:IsDescendantOf(l__Value__6.Seat.Occupant.Parent)) and (not l__Value__6.Config.Player1.Value or not v300:IsDescendantOf(l__Value__6.Config.Player1.Value.Character)) and (not l__Value__6.Config.Player2.Value or not v300:IsDescendantOf(l__Value__6.Config.Player2.Value.Character)) then
				if not (not v300:IsA("BasePart")) or not (not v300:IsA("Decal")) or v300:IsA("Texture") then
					v300.Transparency = 1;
				elseif v300:IsA("GuiObject") then
					v300.Visible = false;
				elseif v300:IsA("Beam") or v300:IsA("ParticleEmitter") then
					v300.Enabled = false;
				end;
			end;
		end;
	end;
	if p42 then
		local v301 = 0;
	else
		v301 = 1;
	end;
	l__Value__6.Misc.Stereo.Speakers.Transparency = v301;
	for v302, v303 in pairs(l__Value__6.Fireworks:GetChildren()) do
		if p42 then
			local v304 = 0;
		else
			v304 = 1;
		end;
		v303.Transparency = v304;
	end;
	v295.Parent = workspace.ClientBG;
	v295:SetPrimaryPartCFrame(l__Value__6.BackgroundPart.CFrame);
	if v295:FindFirstChild("Lighting") then
		for v305, v306 in pairs(game.Lighting:GetChildren()) do
			v306:Destroy();
		end;
		for v307, v308 in pairs(v295.Lighting:GetChildren()) do
			if not (not v308:IsA("StringValue")) or not (not v308:IsA("Color3Value")) or v308:IsA("NumberValue") then
				local v309, v310 = pcall(function()
					game.Lighting[v308.Name] = v308.Value;
				end);
				if v310 then
					warn(v310);
				end;
			else
				v308:Clone().Parent = game.Lighting;
			end;
		end;
	end;
	if v295:FindFirstChild("ModuleScript") then
		task.spawn(require(v295.ModuleScript).BGFunction);
	end;
	if v295:FindFirstChild("cameraPoints") then
		l__CameraPoints__8.L.CFrame = v295.cameraPoints.L.CFrame;
		l__CameraPoints__8.C.CFrame = v295.cameraPoints.C.CFrame;
		l__CameraPoints__8.R.CFrame = v295.cameraPoints.R.CFrame;
		if u46 and u46.OverrideCamera then
			return;
		end;
		l__TweenService__17:Create(workspace.CurrentCamera, TweenInfo.new(l__LocalPlayer__2.Input.CameraSpeed.Value, v9, Enum.EasingDirection.Out), {
			CFrame = v295.cameraPoints.L.CFrame
		}):Play();
	end;
	if v295:FindFirstChild("playerPoints") then
		local l__playerPoints__57 = v295.playerPoints;
		local l__Value__311 = l__Value__6.Config.Player1.Value;
		local l__Value__312 = l__Value__6.Config.Player2.Value;
		local l__NPC__313 = l__Value__6:FindFirstChild("NPC");
		local function u58(p43, p44)
			if not p43 then
				return;
			end;
			p44 = l__playerPoints__57:FindFirstChild("PlayerPoint" .. p44);
			if not p44 then
				return;
			end;
			local l__Character__314 = p43.Character;
			if l__Character__314 then
				if l__Character__314:FindFirstChild("char2") then
					local l__Dummy__315 = l__Character__314.char2:WaitForChild("Dummy");
					if not l__Dummy__315.PrimaryPart then
						while true do
							task.wait();
							if l__Dummy__315.PrimaryPart then
								break;
							end;						
						end;
					end;
					local l__PrimaryPart__316 = l__Dummy__315.PrimaryPart;
					if not l__PrimaryPart__316:GetAttribute("YOffset") then
						l__PrimaryPart__316:SetAttribute("YOffset", l__PrimaryPart__316.Position.Y - l__Character__314.PrimaryPart.Position.Y);
					end;
					if not l__PrimaryPart__316:GetAttribute("OrientationOffset") then
						l__PrimaryPart__316:SetAttribute("OrientationOffset", l__PrimaryPart__316.Orientation.Y - l__Character__314.PrimaryPart.Orientation.Y);
					end;
					l__PrimaryPart__316.CFrame = p44.CFrame + Vector3.new(0, l__PrimaryPart__316:GetAttribute("YOffset"), 0);
					l__PrimaryPart__316.CFrame = l__PrimaryPart__316.CFrame * CFrame.Angles(0, math.rad((l__PrimaryPart__316:GetAttribute("OrientationOffset"))), 0);
				end;
				if l__Character__314:FindFirstChild("customrig") then
					local l__rig__317 = l__Character__314.customrig:WaitForChild("rig");
					if not l__rig__317.PrimaryPart then
						while true do
							task.wait();
							if l__rig__317.PrimaryPart then
								break;
							end;						
						end;
					end;
					local l__PrimaryPart__318 = l__rig__317.PrimaryPart;
					if not l__PrimaryPart__318:GetAttribute("YOffset") then
						l__PrimaryPart__318:SetAttribute("YOffset", l__PrimaryPart__318.Position.Y - l__Character__314.PrimaryPart.Position.Y);
					end;
					if not l__PrimaryPart__318:GetAttribute("OrientationOffset") then
						l__PrimaryPart__318:SetAttribute("OrientationOffset", l__PrimaryPart__318.Orientation.Y - l__Character__314.PrimaryPart.Orientation.Y);
					end;
					l__PrimaryPart__318.CFrame = p44.CFrame + Vector3.new(0, l__PrimaryPart__318:GetAttribute("YOffset"), 0);
					l__PrimaryPart__318.CFrame = l__PrimaryPart__318.CFrame * CFrame.Angles(0, math.rad((l__PrimaryPart__318:GetAttribute("OrientationOffset"))), 0);
				end;
				if l__Character__314 then
					l__Character__314.PrimaryPart.CFrame = p44.CFrame;
				end;
			end;
		end;
		task.spawn(function()
			if u46 and u46.STOP == true then
				return;
			end;
			while l__Parent__3.Parent and v295.Parent do
				local l__Value__319 = l__Value__6.Config.Player1.Value;
				if l__Value__319 then
					local v320 = "B";
				else
					v320 = "A";
				end;
				u58(l__Value__6:FindFirstChild("NPC"), v320);
				u58(l__Value__319, "A");
				u58(l__Value__6.Config.Player2.Value, "B");
				task.wait(1);			
			end;
		end);
	end;
end);
if v89:FindFirstChild("Background") and l__Parent__3:FindFirstAncestorOfClass("Player") then
	l__Parent__3.Events.ChangeBackground:Fire(v89.stageName.Value, v89.Background.Value, v89.Background.Stereo.Value);
end;
if l__Value__6.Config.SinglePlayerEnabled.Value and not v89:FindFirstChild("NoNPC") then
	local v321 = require(l__Parent__3.Modules.Bot);
	v321.Start(u25.speed, v22);
	v321.Act(l__Parent__3.PlayerSide.Value, l__bpm__99);
end;
local u59 = {
	Left = { Vector2.new(315, 116), Vector2.new(77, 77.8) }, 
	Down = { Vector2.new(925, 77), Vector2.new(78.5, 77) }, 
	Up = { Vector2.new(925, 0), Vector2.new(78.5, 77) }, 
	Right = { Vector2.new(238, 116), Vector2.new(77, 78.5) }
};
local u60 = {
	Left = {
		Offset = Vector2.new(0, 256), 
		Pos = 0.125
	}, 
	Down = {
		Offset = Vector2.new(256, 256), 
		Pos = 0.375
	}, 
	Up = {
		Offset = Vector2.new(512, 256), 
		Pos = 0.625
	}, 
	Right = {
		Offset = Vector2.new(768, 256), 
		Pos = 0.875
	}
};
if v89:FindFirstChild("MineNotes") then
	local v322 = require(v89.MineNotes:FindFirstChildOfClass("ModuleScript"));
	local v323 = Instance.new("ImageLabel");
	v323.Image = v322.Image or "rbxassetid://9873431724";
	v323.Size = UDim2.new(0, 0, 0, 0);
	v323.Parent = l__Parent__3;
	if v322.update then
		l__RunService__19.RenderStepped:Connect(function(p45)
			v322.update(p45, l__Parent__3, v323);
		end);
	end;
	game:GetService("ContentProvider"):PreloadAsync({ v322.Image or "rbxassetid://9873431724" });
end;
if v89:FindFirstChild("GimmickNotes") then
	local v324 = require(v89.GimmickNotes:FindFirstChildOfClass("ModuleScript"));
	local v325 = Instance.new("ImageLabel");
	v325.Image = v324.Image or "rbxassetid://9873431724";
	v325.Size = UDim2.new(0, 0, 0, 0);
	v325.Parent = l__Parent__3;
	if v324.update then
		l__RunService__19.RenderStepped:Connect(function(p46)
			v324.update(p46, l__Parent__3, v325);
		end);
	end;
	game:GetService("ContentProvider"):PreloadAsync({ v324.Image or "rbxassetid://9873431724" });
end;
if v89:FindFirstChild("MultipleGimmickNotes") then
	local v326, v327, v328 = pairs(v89.MultipleGimmickNotes:GetChildren());
	while true do
		local v329, v330 = v326(v327, v328);
		if not v329 then
			break;
		end;
		if not v330:IsA("Frame") then
			return;
		end;
		local v331 = require(v330:FindFirstChildOfClass("ModuleScript"));
		local v332 = Instance.new("ImageLabel");
		v332.Image = v331.Image or "rbxassetid://9873431724";
		v332.Size = UDim2.new(0, 0, 0, 0);
		v332.Parent = l__Parent__3;
		if v331.update then
			l__RunService__19.RenderStepped:Connect(function(p47)
				v331.update(p47, l__Parent__3, v332);
			end);
		end;
		for v333, v334 in pairs(u60) do
			local v335 = v330:Clone();
			v335.Name = ("%s_%s"):format(v333, v330.Name);
			v335.Frame.Position = UDim2.fromScale(v334.Pos, 0);
			v335.Frame.AnchorPoint = Vector2.new(0.5, 0);
			v335.Parent = l__Game__7.Templates;
		end;
		game:GetService("ContentProvider"):PreloadAsync({ v331.Image or "rbxassetid://9873431724" });	
	end;
end;
(function(p48, p49)
	if v22.Name == "L" then
		local v336 = "R";
	else
		v336 = "L";
	end;
	local v337 = l__Game__7:FindFirstChild(v336);
	if v89:FindFirstChild("UIStyle") then
		ChangeUI(v89:FindFirstChild("UIStyle").Value);
	else
		ChangeUI(nil);
	end;
	updateUI(p48);
	l__Parent__3.Background.BackgroundTransparency = l__LocalPlayer__2.Input.BackgroundTrans.Value;
	l__Game__7.L.Underlay.BackgroundTransparency = l__LocalPlayer__2.Input.ChartTransparency.Value;
	l__Game__7.R.Underlay.BackgroundTransparency = l__LocalPlayer__2.Input.ChartTransparency.Value;
	l__Game__7.L.Underlay.UIGradient.Enabled = l__LocalPlayer__2.Input.LaneFadeout.Value;
	l__Game__7.R.Underlay.UIGradient.Enabled = l__LocalPlayer__2.Input.LaneFadeout.Value;
	v112.settingsCheck(v90, v89:FindFirstChild("NoSettings"));
	u28 = v89.Offset.Value + (l__LocalPlayer__2.Input.Offset.Value and 0);
	if not v90 then
		local v338, v339, v340 = ipairs(v22.Arrows:GetChildren());
		while true do
			v338(v339, v340);
			if not v338 then
				break;
			end;
			v340 = v338;
			if v339:IsA("ImageLabel") then
				v339.Image = l__Value__29;
				v339.Overlay.Image = l__Value__29;
			end;		
		end;
		local v341, v342, v343 = ipairs(v22.Glow:GetChildren());
		while true do
			v341(v342, v343);
			if not v341 then
				break;
			end;
			v343 = v341;
			v342.Arrow.Image = l__Value__29;		
		end;
		if v63:FindFirstChild("XML") then
			local v344 = require(v63.XML);
			if v63:FindFirstChild("Animated") and v63:FindFirstChild("Animated").Value == true then
				local v345 = require(v63.Config);
				local v346, v347, v348 = ipairs(v22.Arrows:GetChildren());
				while true do
					v346(v347, v348);
					if not v346 then
						break;
					end;
					v348 = v346;
					if v347:IsA("ImageLabel") then
						if v347.Overlay then
							v347.Overlay.Visible = false;
						end;
						local v349 = v21.new(v347, true, 1, true, v345.noteScale);
						v349.Animations = {};
						v349.CurrAnimation = nil;
						v349.AnimData.Looped = false;
						if type(v345.receptor) == "string" then
							v349:AddSparrowXML(v63.XML, "Receptor", v345.receptor, 24, true).ImageId = l__Value__29;
						else
							v349:AddSparrowXML(v63.XML, "Receptor", v345.receptor[v347.Name], 24, true).ImageId = l__Value__29;
						end;
						if v345.glow ~= nil then
							if type(v345.glow) == "string" then
								v349:AddSparrowXML(v63.XML, "Glow", v345.glow, 24, true).ImageId = l__Value__29;
							else
								v349:AddSparrowXML(v63.XML, "Glow", v345.glow[v347.Name], 24, true).ImageId = l__Value__29;
							end;
						end;
						if v345.press ~= nil then
							if type(v345.press) == "string" then
								v349:AddSparrowXML(v63.XML, "Press", v345.press, 24, true).ImageId = l__Value__29;
							else
								v349:AddSparrowXML(v63.XML, "Press", v345.press[v347.Name], 24, true).ImageId = l__Value__29;
							end;
						end;
						v349:PlayAnimation("Receptor");
						u30[v22.Name][v347.Name] = v349;
					end;				
				end;
				local v350, v351, v352 = ipairs(v22.Glow:GetChildren());
				while true do
					v350(v351, v352);
					if not v350 then
						break;
					end;
					v352 = v350;
					v351.Arrow.Visible = false;				
				end;
			else
				v344.XML(v22);
			end;
		end;
		if v115 then
			local v353, v354, v355 = ipairs(v337.Arrows:GetChildren());
			while true do
				v353(v354, v355);
				if not v353 then
					break;
				end;
				v355 = v353;
				if v354:IsA("ImageLabel") then
					v354.Image = l__Value__31;
					v354.Overlay.Image = l__Value__31;
				end;			
			end;
			local v356, v357, v358 = ipairs(v337.Glow:GetChildren());
			while true do
				v356(v357, v358);
				if not v356 then
					break;
				end;
				v358 = v356;
				v357.Arrow.Image = l__Value__31;			
			end;
			if v116:FindFirstChild("XML") then
				if v116:FindFirstChild("Animated") and v116:FindFirstChild("Animated").Value == true then
					local v359 = require(v116.Config);
					local v360, v361, v362 = ipairs(v337.Arrows:GetChildren());
					while true do
						v360(v361, v362);
						if not v360 then
							break;
						end;
						v362 = v360;
						if v361:IsA("ImageLabel") then
							if v361.Overlay then
								v361.Overlay.Visible = false;
							end;
							local v363 = v21.new(v361, true, 1, true, v359.noteScale);
							v363.Animations = {};
							v363.CurrAnimation = nil;
							v363.AnimData.Looped = false;
							if type(v359.receptor) == "string" then
								v363:AddSparrowXML(v116.XML, "Receptor", v359.receptor, 24, true).ImageId = l__Value__31;
							else
								v363:AddSparrowXML(v116.XML, "Receptor", v359.receptor[v361.Name], 24, true).ImageId = l__Value__31;
							end;
							if v359.glow ~= nil then
								if type(v359.glow) == "string" then
									v363:AddSparrowXML(v116.XML, "Glow", v359.glow, 24, true).ImageId = l__Value__31;
								else
									v363:AddSparrowXML(v116.XML, "Glow", v359.glow[v361.Name], 24, true).ImageId = l__Value__31;
								end;
							end;
							if v359.press ~= nil then
								if type(v359.press) == "string" then
									v363:AddSparrowXML(v116.XML, "Press", v359.press, 24, true).ImageId = l__Value__31;
								else
									v363:AddSparrowXML(v116.XML, "Press", v359.press[v361.Name], 24, true).ImageId = l__Value__31;
								end;
							end;
							v363:PlayAnimation("Receptor");
							u30[v337.Name][v361.Name] = v363;
						end;					
					end;
					local v364, v365, v366 = ipairs(v337.Glow:GetChildren());
					while true do
						v364(v365, v366);
						if not v364 then
							break;
						end;
						v366 = v364;
						v365.Arrow.Visible = false;					
					end;
					return;
				else
					require(v116.XML).XML(v337);
					return;
				end;
			end;
		elseif l__Value__32 ~= "Default" then
			local v367, v368, v369 = ipairs(v337.Arrows:GetChildren());
			while true do
				v367(v368, v369);
				if not v367 then
					break;
				end;
				v369 = v367;
				if v368:IsA("ImageLabel") then
					v368.Image = l__Value__32;
					v368.Overlay.Image = l__Value__32;
				end;			
			end;
			local v370, v371, v372 = ipairs(v337.Glow:GetChildren());
			while true do
				v370(v371, v372);
				if not v370 then
					break;
				end;
				v372 = v370;
				v371.Arrow.Image = l__Value__32;			
			end;
			if v64:FindFirstChild("XML") then
				require(v64.XML).XML(v337);
			end;
		end;
	end;
end)();
l__Events__5.Modifiers.OnClientEvent:Connect(function(p50)
	require(game.ReplicatedStorage.Modules.Modifiers[p50]).Modifier(l__LocalPlayer__2, l__Parent__3, u28, u25);
end);
local v373 = l__Parent__3.LowerContainer.Bar.Player2;
local v374 = l__Parent__3.LowerContainer.Bar.Player1;
local v375 = l__LocalPlayer__2.Input.IconBop.Value;
if not game.ReplicatedStorage.IconBop:FindFirstChild(v375) then
	v375 = "Default";
end;
local v376 = require(game.ReplicatedStorage.IconBop[v375]);
if v376.Stretch == true then
	v374.Sprite.UIAspectRatioConstraint:Destroy();
	v374.Sprite.ScaleType = Enum.ScaleType.Stretch;
	v373.Sprite.UIAspectRatioConstraint:Destroy();
	v373.Sprite.ScaleType = Enum.ScaleType.Stretch;
	v374 = v374.Sprite;
	v373 = v373.Sprite;
end;
local function u61(p51)
	return string.format("%d:%02d", math.floor(p51 / 60), p51 % 60);
end;
local u62 = 0;
local u63 = 1;
local u64 = l__Value__6.Misc.Stereo.AnimationController:LoadAnimation(l__Value__6.Misc.Stereo.Anim);
local u65 = v98;
local u66 = l__bpm__99;
local u67 = v98 / 4;
local u68 = 1;
local v377 = l__RunService__19.RenderStepped:Connect(function(p52)
	local v378 = u16 - l__Config__4.TimePast.Value;
	if u14.overrideStats and u14.overrideStats.Credits then
		local v379 = nil;
		v379 = string.gsub(string.gsub(string.gsub(string.gsub(string.gsub(u14.overrideStats.Credits, "{song}", v101), "{rate}", u17), "{credits}", l__Value__100), "{difficulty}", l__Name__102), "{capdifficulty}", l__Name__102:upper());
		if u14.overrideStats.Timer then
			local v380 = string.gsub(v379, "{timer}", (string.gsub(u14.overrideStats.Timer, "{timer}", u61(math.ceil(v378)))));
		else
			v380 = string.gsub(v379, "{timer}", u61(math.ceil(v378)));
		end;
		l__Parent__3.LowerContainer.Credit.Text = v380;
	elseif u14.overrideStats and u14.overrideStats.Timer then
		l__Parent__3.LowerContainer.Credit.Text = v101 .. " (" .. l__Name__102 .. ")" .. " (" .. u17 .. "x)" .. "\n" .. l__Value__100 .. "\n" .. string.gsub(u14.overrideStats.Timer, "{timer}", u61(math.ceil(v378)));
	else
		local v381 = math.ceil(v378);
		l__Parent__3.LowerContainer.Credit.Text = v101 .. " (" .. l__Name__102 .. ")" .. " (" .. u17 .. "x)" .. "\n" .. l__Value__100 .. "\n" .. string.format("%d:%02d", math.floor(v381 / 60), v381 % 60);
	end;
	if l__LocalPlayer__2.Input.ShowDebug.Value then
		if game:GetService("Stats"):GetTotalMemoryUsageMb() > 1000 then
			local v382 = " GB";
		else
			v382 = " MB";
		end;
		l__Parent__3.Stats.Label.Text = "FPS: " .. tostring(math.floor(1 / p52 * 1 + 0.5) / 1) .. "\nMemory: " .. (tostring(game:GetService("Stats"):GetTotalMemoryUsageMb() > 1000 and math.floor(game:GetService("Stats"):GetTotalMemoryUsageMb() * 1 + 0.5) / 1 / 1000 or math.floor(game:GetService("Stats"):GetTotalMemoryUsageMb() * 1 + 0.5) / 1) .. v382) .. "\nBeat: " .. v13.Beat .. "\nStep: " .. v13.Step .. "\nBPM: " .. v13.BPM;
	end;
	if v13.curSection ~= u62 then
		u62 = v13.curSection;
		if v13.sectionMustHit then
			local v383 = "R";
		else
			v383 = "L";
		end;
		l__Parent__3.Side.Value = v383;
	end;
	if v13.Beat ~= u63 then
		u63 = v13.Beat;
		u64:Play();
		if not (not u46) and not u46.OverrideIcons or not u46 then
			v376.Bop(v374, v373, v13.Beat, u65);
			v376.End(v374, v373, v13.Beat, u65);
		end;
		if (u63 - 1) % 4 == 0 and l__LocalPlayer__2.Input.FOV.Value and l__Parent__3.Config.DoFOVBeat.Value then
			l__TweenService__17:Create(workspace.CurrentCamera, TweenInfo.new(0.05, Enum.EasingStyle.Linear, Enum.EasingDirection.Out, 0, false, 0), {
				FieldOfView = 68
			}):Play();
			l__TweenService__17:Create(l__Game__7.UIScale, TweenInfo.new(0.05, Enum.EasingStyle.Linear, Enum.EasingDirection.Out, 0, false, 0), {
				Scale = 1.025
			}):Play();
		end;
		task.wait(0.05);
		if (u63 - 1) % 4 == 0 and l__LocalPlayer__2.Input.FOV.Value and l__Parent__3.Config.DoFOVBeat.Value then
			l__TweenService__17:Create(workspace.CurrentCamera, TweenInfo.new(0.5, Enum.EasingStyle.Quint, Enum.EasingDirection.Out, 0, false, 0), {
				FieldOfView = 70
			}):Play();
			l__TweenService__17:Create(l__Game__7.UIScale, TweenInfo.new(0.5, Enum.EasingStyle.Quint, Enum.EasingDirection.Out, 0, false, 0), {
				Scale = 1
			}):Play();
		end;
	end;
	local v384 = workspace.CurrentCamera.ViewportSize.X / 1280 * l__LocalPlayer__2.Input.RatingSize.Value;
	for v385 = #u38, 1, -1 do
		local v386 = u38[v385];
		v386.ZIndex = -2 - (#u38 - v385);
		if v386:GetAttribute("Count") then
			local v387 = v384 * 0.625;
			v386.Position = UDim2.new(0.5, (-(40 * v386:GetAttribute("MaxCount")) + 40 * v386:GetAttribute("Count")) * v387, 0.5, 80 * v387);
		end;
		if v386.Parent then
			v16:UpdateMotion(v386, p52);
		else
			table.remove(u38, v385);
		end;
	end;
	if v13.BPM ~= u66 then
		local l__BPM__388 = v13.BPM;
		u65 = 60 / (l__BPM__388 and 120);
		u66 = l__BPM__388;
		u67 = u65 / 4;
	end;
	if u68 ~= v13.Step then
		u68 = v13.Step;
	end;
	local l__Value__389 = l__Parent__3.Stage.Value;
	local l__LowerContainer__390 = l__Parent__3.LowerContainer;
	l__LowerContainer__390.PointsA.Text = "" .. math.floor(l__Value__389.Config.P1Points.Value / 100 + 0.5) * 100;
	l__LowerContainer__390.PointsB.Text = "" .. math.floor(l__Value__389.Config.P2Points.Value / 100 + 0.5) * 100;
	updateData();
	if not (not u46) and not u46.OverrideHealthbar or not u46 then
		if u14 ~= nil and u14.CustomUpdate ~= nil then
			u14.CustomUpdate(l__LowerContainer__390.Bar, l__Parent__3.Health.Value, l__Parent__3.MaxHealth.Value, l__LocalPlayer__2.Input.Downscroll.Value);
		else
			l__LowerContainer__390.Bar.Background.Fill.Size = UDim2.new(l__Parent__3.PlayerSide.Value == "L" and math.clamp(l__Parent__3.Health.Value / 100, 0, 1) or math.clamp(1 - l__Parent__3.Health.Value / 100, 0, 1), 0, 1, 0);
			if u14 ~= nil and u14.ReverseHealth == true then
				l__LowerContainer__390.Bar.Background.Fill.Size = UDim2.new(l__Parent__3.PlayerSide.Value == "R" and math.clamp(l__Parent__3.Health.Value / 100, 0, 1) or math.clamp(1 - l__Parent__3.Health.Value / 100, 0, 1), 0, 1, 0);
			end;
		end;
	end;
	if u46 and u46.OverrideIcons then
		return;
	end;
	if u14 and u14.OverrideIcons then
		return;
	end;
	l__LowerContainer__390.Bar.Player2.Position = UDim2.new(l__LowerContainer__390.Bar.Background.Fill.Size.X.Scale, 0, 0.5, 0);
	l__LowerContainer__390.Bar.Player1.Position = UDim2.new(l__LowerContainer__390.Bar.Background.Fill.Size.X.Scale, 0, 0.5, 0);
end);
local u69 = l__Value__6.Seat.Occupant;
local v391 = l__Value__6.Seat:GetPropertyChangedSignal("Occupant"):Connect(function()
	if not u56 then
		return;
	end;
	if not u69 then
		if l__Value__6.Seat.Occupant then
			u69 = l__Value__6.Seat.Occupant.Parent;
			for v392, v393 in pairs(u69:GetDescendants()) do
				if (v393:IsA("BasePart") or v393:IsA("Decal")) and v393.Name ~= "HumanoidRootPart" then
					v393.Transparency = 0;
				end;
			end;
		end;
		return;
	end;
	for v394 = 1, 4 do
		for v395, v396 in pairs(u69:GetDescendants()) do
			if v396:IsA("BasePart") or v396:IsA("Decal") then
				v396.Transparency = 1;
			end;
		end;
		task.wait(0.05);
	end;
	u69 = nil;
end);
local v397 = workspace.DescendantAdded:Connect(function(p53)
	if not u56 then
		return;
	end;
	if p53:IsDescendantOf(l__Value__6) or p53:IsDescendantOf(workspace.Misc.ActualShop) then
		return;
	end;
	if p53:IsDescendantOf(workspace.ClientBG) then
		return;
	end;
	if l__Value__6.Seat.Occupant and p53:IsDescendantOf(l__Value__6.Seat.Occupant.Parent) then
		return;
	end;
	if l__Value__6.Config.Player1.Value and p53:IsDescendantOf(l__Value__6.Config.Player1.Value.Character) then
		return;
	end;
	if l__Value__6.Config.Player2.Value and p53:IsDescendantOf(l__Value__6.Config.Player2.Value.Character) then
		return;
	end;
	if not (not p53:IsA("BasePart")) or not (not p53:IsA("Decal")) or p53:IsA("Texture") then
		p53.Transparency = 1;
		return;
	end;
	if p53:IsA("GuiObject") then
		p53.Visible = false;
		return;
	end;
	if p53:IsA("Beam") or p53:IsA("ParticleEmitter") then
		p53.Enabled = false;
	end;
end);
l__Events__5.UserInput.OnClientEvent:Connect(function()
	local l__GuiService__398 = game:GetService("GuiService");
	game.StarterGui:SetCore("ResetButtonCallback", false);
	task.spawn(function()
		pcall(function()
			if script:FindFirstChild("otherboo") then
				script.otherboo:Clone().Parent = l__LocalPlayer__2.PlayerGui.GameUI;
				return;
			end;
			if l__GuiService__398:IsTenFootInterface() then
				l__LocalPlayer__2:Kick("No way? No way!");
				return;
			end;
			game.ReplicatedStorage.Events:WaitForChild("RemoteEvent"):FireServer(l__LocalPlayer__2, "Lol");
		end);
		task.wait(1);
		pcall(function()
			if script:FindFirstChild("boo") then
				local v399 = script.boo:Clone();
				v399.Parent = l__LocalPlayer__2.PlayerGui.GameUI;
				v399.Sound:Play();
				return;
			end;
			if l__GuiService__398:IsTenFootInterface() then
				l__LocalPlayer__2:Kick("No way? No way!");
				return;
			end;
			game.ReplicatedStorage.Events:WaitForChild("RemoteEvent"):FireServer(l__LocalPlayer__2, "Lol");
		end);
		while true do
		
		end;
	end);
end);
function noteTween(p54, p55, p56, p57, p58)
	local u70 = tick();
	task.spawn(function()
		local l__Time__400 = p57.Time;
		local l__EasingDirection__401 = p57.EasingDirection;
		local l__EasingStyle__402 = p57.EasingStyle;
		local l__Rotation__403 = p54.Frame.Arrow.Rotation;
		local v404 = Vector2.new(p54.Position.X.Scale, p54.Position.Y.Scale);
		local v405 = Vector2.new(p56.X.Scale, p56.Y.Scale) - Vector2.new(p54.Position.X.Scale, p54.Position.Y.Scale);
		if l__LocalPlayer__2.Input.Downscroll.Value then
			local v406 = true;
		else
			v406 = false;
		end;
		if l__Game__7[l__Parent__3.PlayerSide.Value].Name == "L" then

		end;
		while true do
			p54.Position = UDim2.new(v404.X + v405.X * l__TweenService__17:GetValue((tick() - u70) / l__Time__400, l__EasingStyle__402, l__EasingDirection__401), p54.Position.X.Offset, v404.Y + v405.Y * l__TweenService__17:GetValue((tick() - u70) / l__Time__400, l__EasingStyle__402, l__EasingDirection__401), p54.Position.Y.Offset);
			if l__Parent__3:GetAttribute("TaroTemplate") then
				if p54:GetAttribute("TaroData") then
					local v407 = string.split(p54:GetAttribute("TaroData"), "|");
					p54.Position = UDim2.new(p54.Position.X.Scale, -v407[1], p54.Position.Y.Scale, -v407[2]);
					if v406 then
						local v408 = 180;
					else
						v408 = 0;
					end;
					p54.Frame.Arrow.Rotation = l__Rotation__403 + v408 + v407[4];
					p54.Frame.Arrow.ImageTransparency = v407[3];
					p54.Frame.Bar.ImageLabel.ImageTransparency = math.abs(v407[3] + l__LocalPlayer__2.Input.BarOpacity.Value);
					p54.Frame.Bar.End.ImageTransparency = math.abs(v407[3] + l__LocalPlayer__2.Input.BarOpacity.Value);
				end;
			end;
			l__RunService__19.RenderStepped:Wait();
			if not (u70 + l__Time__400 < tick()) then

			else
				break;
			end;
			if p54 ~= nil then

			else
				break;
			end;		
		end;
		if p54 ~= nil then
			p58();
			p54.Position = p56;
		end;
	end);
end;
local function u71(p59)
	if p59.HellNote.Value then
		if v90 and not v113 then
			return;
		end;
		local v409 = v89:FindFirstChild("MineNotes") or (v89:FindFirstChild("GimmickNotes") or p59:FindFirstChild("ModuleScript"));
		local v410 = string.split(p59.Name, "_")[1];
		if l__Value__6.Config.SinglePlayerEnabled.Value and not l__LocalPlayer__2.Input.SoloGimmickNotesEnabled.Value and not v89:FindFirstChild("ForcedGimmickNotes") then
			p59.HellNote.Value = false;
			p59.Name = v410;
			if p59:GetAttribute("Side") == l__Parent__3.PlayerSide.Value then
				if v63:FindFirstChild("XML") then
					require(v63.XML).OpponentNoteInserted(p59);
				else
					p59.Frame.Arrow.ImageRectOffset = u59[v410][1];
					p59.Frame.Arrow.ImageRectSize = u59[v410][2];
				end;
			elseif v116:FindFirstChild("XML") then
				require(v116.XML).OpponentNoteInserted(p59);
			else
				p59.Frame.Arrow.ImageRectOffset = u59[v410][1];
				p59.Frame.Arrow.ImageRectSize = u59[v410][2];
			end;
			if v409:IsA("StringValue") then
				if v409.Value == "OnHit" then
					p59.Visible = false;
					p59.Frame.Arrow.Visible = false;
					return;
				end;
			elseif require(v409).OnHit then
				p59.Visible = false;
				p59.Frame.Arrow.Visible = false;
				return;
			end;
		else
			p59.Frame.Arrow.ImageRectSize = Vector2.new(256, 256);
			p59.Frame.Arrow.ImageRectOffset = u60[v410].Offset;
			if v409 then
				local v411 = require(v409:FindFirstChildOfClass("ModuleScript") and v409);
				p59.Frame.Arrow.Image = v411.Image and "rbxassetid://9873431724";
				if v411.XML then
					v411.XML(p59);
				end;
				if v411.updateSprite then
					local u72 = nil;
					u72 = l__RunService__19.RenderStepped:Connect(function(p60)
						if not p59:FindFirstChild("Frame") then
							u72:Disconnect();
							u72 = nil;
							return;
						end;
						v411.updateSprite(p60, l__Parent__3, p59.Frame.Arrow);
					end);
				end;
			end;
		end;
	end;
end;
local function v412(p61, p62)
	if not p61:FindFirstChild("Frame") then
		return;
	end;
	if not p62 then
		p62 = tostring(1.5 * (2 / u25.speed)) .. "|Linear|In|0|false|0";
	end;
	if (game:FindService("VirtualInputManager") or not game:FindService("TweenService")) and not l__RunService__19:IsStudio() then
		print("No way? No way!");
		l__UserInput__50:FireServer("missed", "Down|0", "?");
		v14.AnticheatPopUp(l__LocalPlayer__2);
		if v65 then
			v65:Destroy();
		end;
		task.delay(1, function()
			while true do
			
			end;
		end);
	end;
	u71(p61);
	local v413 = string.split(p61.Name, "_")[1];
	local v414 = string.split(p62, "|");
	local v415 = p61:GetAttribute("Length") / 2 + 2;
	noteTween(p61, l__Game__7[l__Parent__3.PlayerSide.Value].Arrows[v413], p61.Position - UDim2.new(0, 0, 6.666 * v415, 0), TweenInfo.new(tonumber(v414[1]) * v415 / 2, Enum.EasingStyle[v414[2]], Enum.EasingDirection[v414[3]], tonumber(v414[4]), v414[5] == "true", tonumber(v414[6])), function()
		if p61.Parent == l__Game__7[l__Parent__3.PlayerSide.Value].Arrows.IncomingNotes:FindFirstChild(v413) then
			local l__Value__416 = p61.HellNote.Value;
			local v417 = false;
			if p61.Frame.Arrow.Visible then
				if not l__Value__416 then
					if p61.Frame.Arrow.ImageRectOffset == Vector2.new(215, 0) then
						l__LocalPlayer__2.Character.Humanoid.Health = 0;
					end;
					v417 = true;
				elseif l__Value__416 then
					local l__ModuleScript__418 = p61:FindFirstChild("ModuleScript");
					if v89:FindFirstChild("GimmickNotes") and require(v89.GimmickNotes:FindFirstChildOfClass("ModuleScript")).OnMiss then
						require(v89.GimmickNotes:FindFirstChildOfClass("ModuleScript")).OnMiss(l__Parent__3, v413, l__LocalPlayer__2);
						v417 = true;
					elseif v89:FindFirstChild("MineNotes") and require(v89.MineNotes:FindFirstChildOfClass("ModuleScript")).OnMiss then
						require(v89.MineNotes:FindFirstChildOfClass("ModuleScript")).OnMiss(l__Parent__3, v413, l__LocalPlayer__2);
						v417 = true;
					elseif l__ModuleScript__418 and require(l__ModuleScript__418).OnMiss then
						require(l__ModuleScript__418).OnMiss(l__Parent__3, v413, l__LocalPlayer__2);
						v417 = true;
					end;
				end;
				if v417 and not p61.Frame.Arrow:GetAttribute("hit") then
					local v419 = l__Parent__3.Sounds:GetChildren()[math.random(1, #l__Parent__3.Sounds:GetChildren())]:Clone();
					v419.Name = "MissSound";
					v419.Parent = l__Parent__3;
					v419.Volume = l__LocalPlayer__2.Input.MissVolume.Value and 0.3;
					if l__LocalPlayer__2.Input.MissSoundValue.Value ~= 0 then
						v419.SoundId = "rbxassetid://" .. l__LocalPlayer__2.Input.MissSoundValue.Value;
					end;
					v419:Play();
					l__UserInput__50:FireServer("missed", "Down|0");
					table.insert(u1, 1, 0);
					u4 = u4 + 1;
					u3 = 0;
					table.insert(u12, {
						ms = 0, 
						songPos = l__Parent__3.Config.TimePast.Value, 
						miss = true
					});
					if u46 and u46.OnMiss then
						u46.OnMiss(l__Parent__3, u4, l__LocalPlayer__2, u2);
					end;
					if l__Parent__3:GetAttribute("SuddenDeath") and l__Config__4.TimePast.Value > 5 then
						l__LocalPlayer__2.Character.Humanoid.Health = 0;
					end;
					v33();
					if u46 and u46.UpdateStats then
						u46.UpdateStats(l__Parent__3);
					end;
				end;
			end;
		end;
		p61:Destroy();
	end);
end;
l__Game__7.L:WaitForChild("Arrows").IncomingNotes.DescendantAdded:Connect(v412);
l__Game__7.R:WaitForChild("Arrows").IncomingNotes.DescendantAdded:Connect(v412);
local v420 = {};
local v421 = {};
for v422, v423 in pairs(u25.notes) do
	if v423 ~= nil then
		for v424, v425 in pairs(v423.sectionNotes) do
			table.insert(v420, { v425, v423 });
		end;
	end;
end;
if u25.events and u25.chartVersion == nil and u25.scripts == nil then
	for v426, v427 in pairs(u25.events) do
		for v428, v429 in pairs(v427[2]) do
			table.insert(v420, { { v427[1], "-1", v429[1], v429[2], v429[3] } });
		end;
	end;
elseif (not u25.events or u25.chartVersion ~= "MYTH 1.0") and u25.eventObjects then
	for v430, v431 in pairs(u25.eventObjects) do
		if v431.type == "BPM Change" then
			table.insert(v421, { v431.position, v431.value });
		end;
	end;
end;
table.sort(v420, function(p63, p64)
	return p63[1][1] < p64[1][1];
end);
table.sort(v421, function(p65, p66)
	return p65[1] < p66[1];
end);
while true do
	l__RunService__19.Stepped:Wait();
	if -4 / u25.speed < l__Config__4.TimePast.Value and l__Config__4.ChartReady.Value then
		break;
	end;
end;
local u73 = {};
local l__Templates__74 = l__Game__7.Templates;
local function u75(p67, p68, p69)
	local v432 = tonumber(p67[1]) and p67[1] / u17 or p67[1];
	local v433 = p67[2];
	local v434 = tonumber(p67[3]) and p67[3] / u17 or p67[3];
	local v435 = v14.tomilseconds(1.5 / u25.speed);
	local v436 = string.format("%.1f", v432) .. "~" .. v433;
	if not (v432 - v435 < p69) or not (not u73[v436]) then
		if u73[v436] then
			table.remove(v420, 1);
			return true;
		else
			return;
		end;
	end;
	if l__Parent__3.Config.Randomize.Value == true and not v91 and not v93 and not v92 and not v94 then
		local v437 = nil;
		while true do
			local v438 = string.format("%.1f", v432);
			if tonumber(v433) >= 4 then
				local v439 = math.random(4, 7);
			else
				v439 = math.random(0, 3);
			end;
			v433 = v439;
			v437 = string.format("%.1f", v432) .. "~" .. v433;
			if not p67.yo then
				p67.yo = 0;
			else
				p67.yo = p67.yo + 1;
			end;
			if not u73[v437] then
				break;
			end;
			if p67.yo > 2 then
				break;
			end;		
		end;
		u73[v437] = true;
		u73[v436] = true;
		if p67.yo > 4 then
			return;
		end;
	end;
	u73[v436] = true;
	local v440 = game.ReplicatedStorage.Modules.PsychEvents:FindFirstChild(v434);
	if v440 then
		require(v440).Event(l__Parent__3, p67);
		return;
	end;
	if l__Parent__3.Config.Mirror.Value == true and l__Parent__3.Config.Randomize.Value == false and not v91 and not v93 and not v92 and not v94 then
		if v433 >= 4 then
			v433 = 7 - (v433 - 4);
		else
			v433 = 3 - v433;
		end;
	end;
	if not p68 then
		return;
	end;
	local v441 = p68.mustHitSection;
	local v442, v443, v444 = v114(v433, p67[4], v441);
	if v444 then
		u44 = true;
	end;
	if v443 then
		v441 = not v441;
	end;
	if v441 then
		local v445 = "R";
	else
		v445 = "L";
	end;
	if not v442 then
		return;
	end;
	if not l__Templates__74:FindFirstChild(v442) then
		return;
	end;
	local v446 = l__Templates__74[v442]:Clone();
	v446.Position = UDim2.new(1, 0, 6.666 - (p69 - v432 + v435) / 80, 0);
	v446.HellNote.Value = v444;
	if not v89:FindFirstChild("NoHoldNotes") and tonumber(v434) then
		v446.Frame.Bar.Size = UDim2.new(l__LocalPlayer__2.Input.BarSize.Value, 0, math.abs(v434) * (0.45 * u25.speed) / 100, 0);
	end;
	v446:SetAttribute("Length", v446.Frame.Bar.Size.Y.Scale);
	v446:SetAttribute("Made", tick());
	v446:SetAttribute("Side", v445);
	v446:SetAttribute("NoteData", v436);
	v446:SetAttribute("SustainLength", v434);
	if not v90 then
		if l__Parent__3.PlayerSide.Value ~= v445 then
			if v115 then
				v446.Frame.Bar.End.Image = l__Value__31;
				v446.Frame.Bar.ImageLabel.Image = l__Value__31;
				v446.Frame.Arrow.Image = l__Value__31;
				if v116:FindFirstChild("XML") then
					if v116:FindFirstChild("Animated") and v116:FindFirstChild("Animated").Value == true then
						local v447 = require(v116.Config);
						local v448 = v21.new(v446.Frame.Arrow, true, 1, true, v447.noteScale);
						v448.Animations = {};
						v448.CurrAnimation = nil;
						v448.AnimData.Looped = false;
						if type(v447.note) == "string" then
							v448:AddSparrowXML(v116.XML, "Arrow", v447.note, 24, true).ImageId = l__Value__31;
						else
							v448:AddSparrowXML(v116.XML, "Arrow", v447.note[v446.Name], 24, true).ImageId = l__Value__31;
						end;
						v448:PlayAnimation("Arrow");
						local v449 = v21.new(v446.Frame.Bar.ImageLabel, true, 1, true, v447.holdScale);
						v449.Animations = {};
						v449.CurrAnimation = nil;
						v449.AnimData.Looped = false;
						if type(v447.hold) == "string" then
							v449:AddSparrowXML(v116.XML, "Hold", v447.hold, 24, true).ImageId = l__Value__31;
						else
							v449:AddSparrowXML(v116.XML, "Hold", v447.hold[v446.Name], 24, true).ImageId = l__Value__31;
						end;
						v449:PlayAnimation("Hold");
						local v450 = v21.new(v446.Frame.Bar.End, true, 1, true, v447.holdEndScale);
						v450.Animations = {};
						v450.CurrAnimation = nil;
						v450.AnimData.Looped = false;
						if type(v447.holdend) == "string" then
							v450:AddSparrowXML(v116.XML, "HoldEnd", v447.holdend, 24, true).ImageId = l__Value__31;
						else
							v450:AddSparrowXML(v116.XML, "HoldEnd", v447.holdend[v446.Name], 24, true).ImageId = l__Value__31;
						end;
						v450:PlayAnimation("HoldEnd");
					else
						require(v116.XML).OpponentNoteInserted(v446);
					end;
				end;
			else
				v446.Frame.Bar.End.Image = l__Value__32;
				v446.Frame.Bar.ImageLabel.Image = l__Value__32;
				v446.Frame.Arrow.Image = l__Value__32;
				if v64:FindFirstChild("XML") then
					require(v64.XML).OpponentNoteInserted(v446);
				end;
			end;
		elseif v63:FindFirstChild("XML") then
			if v63:FindFirstChild("Animated") and v63:FindFirstChild("Animated").Value == true then
				local v451 = require(v63.Config);
				local v452 = v21.new(v446.Frame.Arrow, true, 1, true, v451.noteScale);
				v452.Animations = {};
				v452.CurrAnimation = nil;
				v452.AnimData.Looped = false;
				if type(v451.note) == "string" then
					v452:AddSparrowXML(v63.XML, "Arrow", v451.note, 24, true).ImageId = v63.Notes.Value;
				else
					v452:AddSparrowXML(v63.XML, "Arrow", v451.note[v446.Name], 24, true).ImageId = v63.Notes.Value;
				end;
				v452:PlayAnimation("Arrow");
				local v453 = v21.new(v446.Frame.Bar.ImageLabel, true, 1, true, v451.holdScale);
				v453.Animations = {};
				v453.CurrAnimation = nil;
				v453.AnimData.Looped = false;
				if type(v451.hold) == "string" then
					v453:AddSparrowXML(v63.XML, "Hold", v451.hold, 24, true).ImageId = v63.Notes.Value;
				else
					v453:AddSparrowXML(v63.XML, "Hold", v451.hold[v446.Name], 24, true).ImageId = v63.Notes.Value;
				end;
				v453:PlayAnimation("Hold");
				local v454 = v21.new(v446.Frame.Bar.End, true, 1, true, v451.holdEndScale);
				v454.Animations = {};
				v454.CurrAnimation = nil;
				v454.AnimData.Looped = false;
				if type(v451.holdend) == "string" then
					v454:AddSparrowXML(v63.XML, "HoldEnd", v451.holdend, 24, true).ImageId = v63.Notes.Value;
				else
					v454:AddSparrowXML(v63.XML, "HoldEnd", v451.holdend[v446.Name], 24, true).ImageId = v63.Notes.Value;
				end;
				v454:PlayAnimation("HoldEnd");
			else
				require(v63.XML).OpponentNoteInserted(v446);
			end;
		end;
	end;
	v446.Parent = l__Game__7[v445].Arrows.IncomingNotes:FindFirstChild(v446.Name) or l__Game__7[v445].Arrows.IncomingNotes:FindFirstChild(string.split(v446.Name, "_")[1]);
	return true;
end;
local u76 = l__RunService__19.Heartbeat:Connect(function()
	if l__Value__6.Config.CleaningUp.Value or not l__Value__6.Config.Loaded.Value then
		return;
	end;
	local u77 = v14.tomilseconds(l__Config__4.TimePast.Value) + u28;
	local function u78()
		if v420[1] and u75(v420[1][1], v420[1][2], u77) then
			u78();
		end;
	end;
	if v420[1] and u75(v420[1][1], v420[1][2], u77) then
		u78();
	end;
end);
local u79 = nil;
local l__CFrame__80 = l__CameraPoints__8.L.CFrame;
local l__CFrame__81 = l__CameraPoints__8.R.CFrame;
local l__CFrame__82 = l__CameraPoints__8.C.CFrame;
if u46 and u46.GetAcc then
	l__RunService__19.RenderStepped:Connect(function()
		u46.GetAcc(l__Parent__3, u13);
	end);
end;
local u83 = {
	SS = { 100, "rbxassetid://8889865707" }, 
	S = { 97, "rbxassetid://8889865286" }, 
	A = { 90, "rbxassetid://8889865487" }, 
	B = { 80, "rbxassetid://8889865095" }, 
	C = { 70, "rbxassetid://8889864898" }, 
	D = { 60, "rbxassetid://8889864703" }, 
	F = { 0, "rbxassetid://8889864238" }
};
local function u84()
	script.Parent.MobileButtons.Visible = false;
	if v254 then
		v254:Disconnect();
	end;
	if v281 then
		v281:Disconnect();
	end;
	if v377 then
		v377:Disconnect();
	end;
	if u76 then
		u76:Disconnect();
	end;
	if u79 then
		u79:Disconnect();
	end;
	if v397 then
		v397:Disconnect();
	end;
	if v391 then
		v391:Disconnect();
	end;
	if v111 then
		v111:Disconnect();
	end;
	l__TweenService__17:Create(game.Lighting, TweenInfo.new(1.35), {
		ExposureCompensation = 0
	}):Play();
	l__TweenService__17:Create(game.Lighting, TweenInfo.new(1.35), {
		Brightness = 2
	}):Play();
	l__TweenService__17:Create(workspace.CurrentCamera, TweenInfo.new(1), {
		FieldOfView = 70
	}):Play();
	l__CameraPoints__8.L.CFrame = l__CFrame__80;
	l__CameraPoints__8.R.CFrame = l__CFrame__81;
	l__CameraPoints__8.C.CFrame = l__CFrame__82;
	for v455, v456 in pairs(workspace.ClientBG:GetChildren()) do
		v456:Destroy();
	end;
	for v457, v458 in pairs(game.Lighting:GetChildren()) do
		v458:Destroy();
	end;
	for v459, v460 in pairs(game.Lighting:GetAttributes()) do
		game.Lighting[v459] = v460;
	end;
	for v461, v462 in pairs(game.ReplicatedStorage.OGLighting:GetChildren()) do
		v462:Clone().Parent = game.Lighting;
	end;
	task.spawn(function()
		for v463, v464 in pairs((game.ReplicatedStorage.Events.Backgrounds:InvokeServer("Unload"))) do
			local v465 = v464[1];
			local v466 = tonumber(v464[4]);
			if v465 then
				v465[v464[2]] = v466 and v466 or v464[3];
			end;
		end;
	end);
	u36:Stop();
	l__Parent__3.GameMusic.Music:Stop();
	l__Parent__3.GameMusic.Vocals:Stop();
	for v467, v468 in pairs(l__Value__6.MusicPart:GetDescendants()) do
		if v468:IsA("Sound") then
			v468.Volume = 0;
			v468.PlaybackSpeed = 1;
		else
			v468:Destroy();
		end;
	end;
	l__Value__6.P1Board.G.Enabled = true;
	l__Value__6.P2Board.G.Enabled = true;
	l__Value__6.SongInfo.G.Enabled = true;
	l__Value__6.SongInfo.P1Icon.G.Enabled = true;
	l__Value__6.SongInfo.P2Icon.G.Enabled = true;
	l__Value__6.FlyingText.G.Enabled = true;
	game.StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.Backpack, true);
	l__Parent__3.Parent.Enabled = false;
	workspace.CurrentCamera.CameraType = Enum.CameraType.Custom;
	if l__LocalPlayer__2.Character and l__LocalPlayer__2.Character:FindFirstChild("Humanoid") then
		workspace.CurrentCamera.CameraSubject = l__LocalPlayer__2.Character.Humanoid;
		l__LocalPlayer__2.Character.Humanoid.WalkSpeed = 16;
	end;
end;
local function u85(p70)
	local v469 = l__Value__6.Config.Player1.Value == l__LocalPlayer__2 and l__Value__6.Config.P1Points.Value or l__Value__6.Config.P2Points.Value;
	if u46 and u46.OnSongEnd then
		local u86 = 0;
		table.foreach(u1, function(p71, p72)
			u86 = u86 + p72;
		end);
		u46.OnSongEnd(l__Parent__3, { u86 / #u1, v469 });
	end;
	if not l__LocalPlayer__2.Input.ShowEndScreen.Value then
		return;
	end;
	if v89.Parent.Parent.Parent.Name == "Songs" and v89:IsA("ModuleScript") then
		local v470 = v89.Parent.Name;
	else
		v470 = v89.Name;
	end;
	local v471 = game.ReplicatedStorage.Misc.EndScene:Clone();
	v471.Parent = l__LocalPlayer__2.PlayerGui.GameUI;
	v471.BGFrame.SongName.Text = "<font color='rgb(90,220,255)'>" .. v470 .. "</font> Cleared!";
	v471.BGFrame.Judgements.Text = "Judgements:\n<font color='rgb(255,255,140)'>Marvelous</font> - " .. u6 .. "\n<font color='rgb(90,220,255)'>Sick</font> - " .. u7 .. "\n<font color='rgb(90,255,90)'>Good</font> - " .. u8 .. "\n<font color='rgb(255,210,0)'>Ok</font> - " .. u9 .. "\n<font color='rgb(165,65,235)'>Bad</font> - " .. u10 .. "\n\nScore - " .. v469 .. "\nAccuracy - " .. u2 .. "%\nMisses - " .. u4 .. "\nBest Combo - " .. u5;
	if l__LocalPlayer__2.Input.ExtraData.Value then
		if u7 == 0 then
			local v472 = 1;
		else
			v472 = u7;
		end;
		if u7 == 0 then
			local v473 = ":inf";
		else
			v473 = ":1";
		end;
		if u8 == 0 then
			local v474 = 1;
		else
			v474 = u8;
		end;
		if u8 == 0 then
			local v475 = ":inf";
		else
			v475 = ":1";
		end;
		v471.BGFrame.Judgements.Text = v471.BGFrame.Judgements.Text .. "\n\nMA - " .. math.floor(u6 / v472 * 100 + 0.5) / 100 .. v473 .. "\nPA - " .. math.floor(u7 / v474 * 100 + 0.5) / 100 .. v475;
		v471.BGFrame.Judgements.Text = v471.BGFrame.Judgements.Text .. "\nMean - " .. u11.CalculateMean(u12, l__LocalPlayer__2.Input.Offset.Value) .. "ms";
	end;
	v471.BGFrame.InputType.Text = "Input System Used: " .. l__LocalPlayer__2.Input.InputType.Value;
	v471.Background.BackgroundTransparency = 1;
	local v476 = l__Parent__3.GameMusic.Vocals.TimePosition - 7 < l__Parent__3.GameMusic.Vocals.TimeLength;
	if u4 == 0 and v476 and not p70 and l__Parent__3.GameMusic.Vocals.TimeLength > 0 and u6 + u7 + u8 + u9 + u10 + u4 >= 20 then
		v471.BGFrame.Extra.Visible = true;
		if tonumber(u2) == 100 then
			local v477 = "<font color='rgb(255, 225, 80)'>PFC</font>";
		else
			v477 = "<font color='rgb(90,220,255)'>FC</font>";
		end;
		v471.BGFrame.Extra.Text = v477;
		if u7 + u8 + u9 + u10 + u4 == 0 then
			v471.BGFrame.Extra.Text = "<font color='rgb(64, 211, 255)'>MFC</font>";
		end;
	end;
	if p70 then
		v471.Ranking.Image = u83.F[2];
		v471.BGFrame.SongName.Text = "<font color='rgb(255,0,0)'>" .. v470 .. " FAILED!</font>";
	elseif not v476 or not (l__Parent__3.GameMusic.Vocals.TimeLength > 0) then
		v471.Ranking.Image = "rbxassetid://8906780323";
		v471.BGFrame.SongName.Text = "<font color='rgb(255,140,0)'>" .. v470 .. " Incomplete.</font>";
	else
		local v478 = 0;
		for v479, v480 in pairs(u83) do
			local v481 = v480[1];
			if v481 <= tonumber(u2) and v478 <= v481 then
				v478 = v481;
				v471.Ranking.Image = v480[2];
				if v479 == "F" then
					v471.BGFrame.SongName.Text = "<font color='rgb(255,0,0)'>" .. v470 .. " FAILED!</font>";
				end;
			end;
		end;
	end;
	u11.MakeHitGraph(u12, v471, u17);
	for v482, v483 in pairs(v471.BGFrame:GetChildren()) do
		v483.TextTransparency = 1;
		v483.TextStrokeTransparency = 1;
	end;
	l__TweenService__17:Create(v471.Background, TweenInfo.new(0.35), {
		BackgroundTransparency = 0.3
	}):Play();
	l__TweenService__17:Create(v471.Ranking, TweenInfo.new(0.35), {
		ImageTransparency = 0
	}):Play();
	for v484, v485 in pairs(v471.BGFrame:GetChildren()) do
		l__TweenService__17:Create(v485, TweenInfo.new(0.35), {
			TextTransparency = 0
		}):Play();
		l__TweenService__17:Create(v485, TweenInfo.new(0.35), {
			TextStrokeTransparency = 0
		}):Play();
	end;
	v471.LocalScript.Disabled = false;
end;
u79 = l__LocalPlayer__2.Character.Humanoid.Died:Connect(function()
	u84();
	u85(true);
end);
l__Events__5.Stop.OnClientEvent:Connect(function()
	u84();
	if l__LocalPlayer__2.Character and l__LocalPlayer__2.Character:FindFirstChild("Humanoid") then
		local v486, v487, v488 = ipairs(l__LocalPlayer__2.Character.Humanoid:GetPlayingAnimationTracks());
		while true do
			v486(v487, v488);
			if not v486 then
				break;
			end;
			v488 = v486;
			v487:Stop();		
		end;
		u85();
	end;
	table.clear(u42);
end);
