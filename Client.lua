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
local v27 = l__LocalPlayer__2.PlayerGui.GameUI:WaitForChild("SongSelect", 10);
local l__EndScene__28 = l__LocalPlayer__2.PlayerGui.GameUI:FindFirstChild("EndScene");
if l__EndScene__28 then
	l__EndScene__28:Destroy();
end;
if not v27 then
	warn("Infinite yield possible on song select menu. Please report this to a dev!");
	v27 = l__LocalPlayer__2.PlayerGui.GameUI:WaitForChild("SongSelect");
end;
v27.StatsContainer.FCs.Text = "<font color='rgb(90,220,255)'>FCs</font>: " .. l__LocalPlayer__2.Input.Achievements.FCs.Value .. " | <font color='rgb(255, 225, 80)'>PFCs</font>: " .. l__LocalPlayer__2.Input.Achievements.PFCs.Value;
function updateData()
	local v29 = 1 - 1;
	while true do
		if l__Value__6.Config["P" .. v29 .. "Stats"].Value ~= "" then
			local v30 = game.HttpService:JSONDecode(l__Value__6.Config["P" .. v29 .. "Stats"].Value);
			if v29 == 1 then
				local v31 = "L";
			else
				v31 = "R";
			end;
			l__Game__7:FindFirstChild(v31).OpponentStats.Label.Text = "Accuracy: " .. v30.accuracy .. "% | Combo: " .. v30.combo .. " | Misses: " .. v30.misses;
			l__Value__6.Config["P" .. v29 .. "Stats"].Value = "";
		end;
		if 0 <= 1 then
			if v29 < 2 then

			else
				break;
			end;
		elseif 2 < v29 then

		else
			break;
		end;
		v29 = v29 + 1;	
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
local function v32()
	local v33 = l__Parent__3.LowerContainer.Stats.Label;
	l__Parent__3.LowerContainer.Bar.Visible = l__LocalPlayer__2.Input.HealthBar.Value;
	local u15 = 0;
	table.foreach(u1, function(p1, p2)
		u15 = u15 + p2;
	end);
	local v34 = 100;
	if u15 == 0 and #u1 == 0 then
		local v35 = "Accuracy: 100%";
	else
		u2 = string.sub(tostring(u15 / #u1), 1, 5);
		v35 = "Accuracy: " .. u2 .. "%";
		v34 = u2;
	end;
	local v36 = v35 .. " | Combo: " .. u3 .. " | Misses: " .. u4;
	v33.Text = v36;
	if l__LocalPlayer__2.Input.VerticalBar.Value then
		v33 = l__Parent__3.SideContainer.Accuracy;
		v33.Text = string.gsub(v36, " | ", "\n");
	end;
	if u5 < u3 then
		u5 = u3;
	end;
	l__Parent__3.SideContainer.Data.Text = "Marvelous: " .. u6 .. "\nSick: " .. u7 .. "\nGood: " .. u8 .. "\nOk: " .. u9 .. "\nBad: " .. u10;
	local l__Extra__37 = l__Parent__3.SideContainer.Extra;
	if u7 == 0 then
		local v38 = 1;
	else
		v38 = u7;
	end;
	if u7 == 0 then
		local v39 = ":inf";
	else
		v39 = ":1";
	end;
	if u8 == 0 then
		local v40 = 1;
	else
		v40 = u8;
	end;
	if u8 == 0 then
		local v41 = ":inf";
	else
		v41 = ":1";
	end;
	l__Extra__37.Text = "MA: " .. math.floor(u6 / v38 * 100 + 0.5) / 100 .. v39 .. "\nPA: " .. math.floor(u7 / v40 * 100 + 0.5) / 100 .. v41;
	l__Extra__37.Text = l__Extra__37.Text .. "\nMean: " .. u11.CalculateMean(u12) .. "ms";
	l__Events__5.UpdateData:FireServer({
		accuracy = v34, 
		combo = u3, 
		misses = u4, 
		bot = false
	});
	u13 = v34;
	if u14 ~= nil and u14.overrideStats then
		if u7 + u8 + u9 + u10 + u4 == 0 then
			local v42 = "MFC";
		elseif u8 + u9 + u10 + u4 == 0 then
			v42 = "PFC";
		elseif u9 + u10 + u4 == 0 then
			v42 = "GFC";
		elseif u4 == 0 then
			v42 = "FC";
		elseif u4 < 10 then
			v42 = "SDBC";
		else
			v42 = "Clear";
		end;
		if u14.overrideStats.Value then
			local v43 = string.gsub(string.gsub(string.gsub(string.gsub(string.gsub(u14.overrideStats.Value, "{misses}", u4), "{combo}", u3), "{score}", l__Value__6.Config.Player1.Value == l__LocalPlayer__2 and l__Value__6.Config.P1Points.Value or l__Value__6.Config.P2Points.Value), "{rating}", v42), "{accuracy}", v34 .. "%%");
		else
			v43 = v33.Text;
		end;
		if u14.overrideStats.ShadowValue then
			local v44 = string.gsub(string.gsub(string.gsub(u14.overrideStats.ShadowValue, "{misses}", u4), "{combo}", u3), "{accuracy}", v34 .. "%%");
		else
			v44 = v33.Text;
		end;
		if u14.overrideStats.Separator then
			v43 = string.gsub(v43, "|", u14.overrideStats.Separator);
			v44 = v43;
		end;
		if u14.overrideStats.ChildrenToUpdate then
			l__Parent__3.SideContainer.Accuracy.Visible = false;
			local l__Label__45 = l__Parent__3.LowerContainer.Stats.Label;
			local v46, v47, v48 = pairs(u14.overrideStats.ChildrenToUpdate);
			while true do
				local v49 = nil;
				local v50, v51 = v46(v47, v48);
				if not v50 then
					break;
				end;
				v48 = v50;
				v49 = l__Parent__3.LowerContainer.Stats[v51];
				if v51:lower():match("shadow") then
					v49.Text = v44;
				else
					v49.Text = v43;
				end;			
			end;
		elseif l__LocalPlayer__2.Input.VerticalBar.Value then
			if u14.overrideStats.Separator then
				v33.Text = string.gsub(v43, " " .. u14.overrideStats.Separator .. " ", "\n");
			else
				v33.Text = string.gsub(v43, " | ", "\n");
			end;
		else
			v33.Text = v43;
		end;
	end;
end;
v32();
local u16 = 0;
local u17 = 1;
l__Events__5.Start.OnClientEvent:Connect(function(p3, p4, p5)
	u16 = p3;
	local v52 = 1 / p4;
	local v53 = p5:FindFirstChild("Modchart") and (p5.Modchart:IsA("ModuleScript") and require(p5.Modchart));
	if v53 and v53.PreStart then
		v53.PreStart(l__Parent__3, v52);
	end;
	local v54 = {};
	if p5:FindFirstChild("Countdown") and game.ReplicatedStorage.Countdowns:FindFirstChild(p5.Countdown.Value) then
		local v55 = require(game.ReplicatedStorage.Countdowns:FindFirstChild(p5.Countdown.Value).Config);
		if v55.Audio ~= nil then
			l__Value__6.MusicPart["3"].SoundId = v55.Audio["3"];
			l__Value__6.MusicPart["2"].SoundId = v55.Audio["2"];
			l__Value__6.MusicPart["1"].SoundId = v55.Audio["1"];
			l__Value__6.MusicPart.Go.SoundId = v55.Audio.Go;
		end;
		v54 = v55.Images;
	end;
	if p5:FindFirstChild("ExtraCountdownTime") then
		task.wait(p5.ExtraCountdownTime.Value);
	end;
	local l__Music__18 = l__Parent__3.GameMusic.Music;
	local l__Vocals__19 = l__Parent__3.GameMusic.Vocals;
	task.spawn(function()
		if p5:FindFirstChild("NoCountdown") then
			task.wait(v52 * 3);
			l__Value__6.MusicPart["3"].Volume = 0;
			l__Value__6.MusicPart.Go.Volume = 0;
			l__Value__6.MusicPart["3"]:Play();
			l__Value__6.MusicPart.Go:Play();
			task.wait(v52);
			l__Music__18.Playing = true;
			l__Vocals__19.Playing = true;
			return;
		end;
		l__Value__6.MusicPart["3"]:Play();
		local u20 = v54;
		local u21 = "3";
		local u22 = v52;
		task.spawn(function()
			if u20 == nil or u20[u21] == nil then
				return;
			end;
			local v56 = l__Parent__3.Countdown.Countdown:Clone();
			v56.Name = u21;
			v56.Image = u20[u21];
			v56.Visible = true;
			v56.Parent = l__Parent__3.Countdown;
			l__TweenService__17:Create(v56, TweenInfo.new(u22, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut), {
				ImageTransparency = 1
			}):Play();
			task.wait(u22 * 1.2);
			v56:Destroy();
		end);
		u22 = task.wait;
		u20 = v52;
		u22(u20);
		u22 = v52;
		u20 = v54;
		u21 = l__Value__6;
		u21.MusicPart["2"]:Play();
		u21 = "2";
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
		u20 = v52;
		u22(u20);
		u22 = v52;
		u20 = v54;
		u21 = l__Value__6;
		u21.MusicPart["1"]:Play();
		u21 = "1";
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
		u20 = v52;
		u22(u20);
		u22 = v52;
		u20 = v54;
		u21 = l__Value__6;
		u21.MusicPart.Go:Play();
		u21 = "Go";
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
		u20 = v52;
		u22(u20);
		u22 = l__Music__18;
		u20 = true;
		u22.Playing = u20;
		u22 = l__Vocals__19;
		u20 = true;
		u22.Playing = u20;
	end);
	for v60, v61 in pairs(l__Value__6.MusicPart:GetChildren()) do
		if v61:IsA("Sound") and v61.Name ~= "SERVERmusic" and v61.Name ~= "SERVERvocals" then
			v61.Volume = 0.5;
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
local v62 = game.ReplicatedStorage.Skins:FindFirstChild(l__LocalPlayer__2.Input.Skin.Value) or game.ReplicatedStorage.Skins.Default;
local v63 = game.ReplicatedStorage.Skins:FindFirstChild(l__LocalPlayer__2.Input.BotSkin.Value) or game.ReplicatedStorage.Skins.Default;
local v64 = Instance.new("BlurEffect");
v64.Parent = game.Lighting;
v64.Size = 0;
for v65, v66 in pairs(v27.Modifiers:GetDescendants()) do
	if v66:IsA("ImageButton") then
		v66.ImageColor3 = Color3.fromRGB(136, 136, 136);
		local u23 = false;
		v66.MouseButton1Click:Connect(function()
			u23 = not u23;
			l__TweenService__17:Create(v66, TweenInfo.new(0.4), {
				ImageColor3 = u23 and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(136, 136, 136)
			}):Play();
			if v66:FindFirstChild("misc") then
				l__TweenService__17:Create(v66.misc, TweenInfo.new(0.4), {
					ImageColor3 = u23 and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(136, 136, 136)
				}):Play();
			end;
			l__Events__5.Modifiers:FireServer(v66.Name);
		end);
		v66.MouseEnter:Connect(function()
			v66.ZIndex = 2;
			local v67 = script.ModifierLabel:Clone();
			v67.Parent = v66;
			v67.Text = "  " .. string.gsub(v66.Info.Value, "|", "\n") .. "  ";
			v67.Size = UDim2.new();
			l__TweenService__17:Create(v67, TweenInfo.new(0.125), {
				Size = v67.Size
			}):Play();
		end);
		v66.MouseLeave:Connect(function()
			while v66:FindFirstChild("ModifierLabel") do
				v66.ZIndex = 1;
				local l__ModifierLabel__68 = v66:FindFirstChild("ModifierLabel");
				if l__ModifierLabel__68 then
					l__TweenService__17:Create(l__ModifierLabel__68, TweenInfo.new(0.125, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
						Size = UDim2.new()
					}):Play();
					task.wait(0.125);
					l__ModifierLabel__68:Destroy();
				end;			
			end;
		end);
	end;
end;
function nowPlaying(p6, p7)
	local v69 = game.ReplicatedStorage.Misc.NowPlaying:Clone();
	v69.Parent = p6;
	v69.Position = v69.Position - UDim2.fromScale(0.2, 0);
	v69.Color.BackgroundColor3 = Color3.new(1, 0.75, 0);
	v69.SongName.TextColor3 = Color3.new(1, 0.75, 0);
	v69.SongName.Text = p7;
	v69.ZIndex = 99999;
	game.TweenService:Create(v69, TweenInfo.new(1), {
		Position = v69.Position + UDim2.fromScale(0.2, 0)
	}):Play();
	task.wait(5.5);
	local v70 = game.TweenService:Create(v69, TweenInfo.new(1.5, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
		Position = v69.Position - UDim2.fromScale(0.2, 0)
	});
	v70:Play();
	v70.Completed:Connect(function()
		v69:Destroy();
	end);
end;
local l__ModifierMultiplier__71 = l__Parent__3:WaitForChild("ModifierMultiplier");
v27.Modifiers.Multiplier.Text = "1x";
v27.Modifiers.Multiplier.TextColor3 = Color3.new(1, 1, 1);
l__ModifierMultiplier__71.Changed:Connect(function()
	if l__ModifierMultiplier__71.Value > 1 then
		local v72 = Color3.fromRGB(255, 255, 0);
	elseif l__ModifierMultiplier__71.Value < 1 then
		v72 = Color3.fromRGB(255, 64, 30);
	else
		v72 = Color3.fromRGB(255, 255, 255);
	end;
	v14.AnimateMultiplier(l__Parent__3, v27.Modifiers.Multiplier, v72);
	v27.Modifiers.Multiplier.Text = l__ModifierMultiplier__71.Value .. "x";
end);
local v73 = l__Parent__3.SelectionMusic:GetChildren();
local v74 = v73[math.random(1, #v73)];
if game.Players.LocalPlayer.Name == "CRYBlT" then
	v74 = l__Parent__3.SelectionMusic["Mareux - The Perfect Girl (The Motion Retrowave Remix)"];
end;
v74.Volume = 0;
v74:Play();
l__TweenService__17:Create(v74, TweenInfo.new(4, Enum.EasingStyle.Quint, Enum.EasingDirection.In), {
	Volume = v74.Volume
}):Play();
l__TweenService__17:Create(workspace.CurrentCamera, TweenInfo.new(1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
	FieldOfView = 35
}):Play();
l__TweenService__17:Create(v64, TweenInfo.new(1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
	Size = 25
}):Play();
v27.Visible = true;
if l__LocalPlayer__2.Input.StreamerMode.Value == true then
	if not string.find(v74.Name, "FNF") then
		v74.PlaybackSpeed = v74.PlaybackSpeed - 0.35;
		local v75 = Instance.new("EqualizerSoundEffect");
		v75.LowGain = 20;
		v75.Parent = v74;
	end;
else
	v74.PlaybackSpeed = v74.PlaybackSpeed;
	if v74:FindFirstChildOfClass("EqualizerSoundEffect") then
		v74:FindFirstChildOfClass("EqualizerSoundEffect"):Destroy();
	end;
end;
task.delay(2.5, function()
	nowPlaying(l__Parent__3, v74.Name);
end);
v27.TimeLeft.Text = "Time Left: 15";
local u24 = nil;
u24 = l__Value__6.Config.SelectTimeLeft.Changed:Connect(function()
	if not l__Parent__3.Parent then
		u24:Disconnect();
		return;
	end;
	v27.TimeLeft.Text = "Time Left: " .. l__Value__6.Config.SelectTimeLeft.Value;
end);
l__Value__6.Events.LoadPlayer.OnClientInvoke = function(p8, p9)
	l__Parent__3.Loading.Visible = true;
	l__TweenService__17:Create(workspace.CurrentCamera, TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
		FieldOfView = 68
	}):Play();
	game.ContentProvider:PreloadAsync({ p8, p9 });
	local l__Music__76 = l__Parent__3.GameMusic.Music;
	local l__Vocals__77 = l__Parent__3.GameMusic.Vocals;
	if p8.SoundId ~= "" then
		l__Music__76.SoundId = p8.SoundId;
		while true do
			task.wait();
			if l__Music__76.TimeLength > 0 then
				break;
			end;		
		end;
	end;
	if p9.SoundId ~= "" then
		l__Vocals__77.SoundId = p9.SoundId;
		while true do
			task.wait();
			if l__Vocals__77.TimeLength > 0 then
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
local v78 = game.ReplicatedStorage.Events.PlayerSongVote.Event:Connect(function(p10, p11, p12, p13)
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
for v79, v80 in pairs(l__LocalPlayer__2.PlayerGui.GameUI:GetChildren()) do
	if not string.match(v80.Name, "SongSelect") then
		v80.Visible = false;
	end;
end;
v27:SetAttribute("2v2", nil);
for v81, v82 in pairs(v27.SongScroller:GetChildren()) do
	if v82:GetAttribute("2V2") then
		v82.Visible = false;
	end;
end;
for v83, v84 in pairs(v27.BasicallyNil:GetChildren()) do
	if v84:GetAttribute("2V2") then
		v84.Visible = false;
	end;
end;
v27.Background.Fill.OpponentSelect.Visible = true;
v27.Background.Fill["Player 1Select"].Visible = false;
v27.Background.Fill["Player 2Select"].Visible = false;
v27.Background.Fill["Player 3Select"].Visible = false;
v27.Background.Fill["Player 4Select"].Visible = false;
while true do
	v14.wait();
	if l__Value__6.Config.Song.Value then
		break;
	end;
end;
local v85 = l__TweenService__17:Create(v64, TweenInfo.new(1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
	Size = 0
});
v85:Play();
v85.Completed:Connect(function()
	v64:Destroy();
end);
local v86 = l__TweenService__17:Create(v74, TweenInfo.new(2, Enum.EasingStyle.Quint, Enum.EasingDirection.In), {
	Volume = 0
});
v86:Play();
v86.Completed:Connect(function()
	v74:Stop();
end);
local v87 = l__Value__6.Config.Song.Value:IsA("StringValue") and l__Value__6.Config.Song.Value.Value or require(l__Value__6.Config.Song.Value);
local v88 = l__Value__6.Config.Song.Value:FindFirstAncestorOfClass("StringValue") or l__Value__6.Config.Song.Value;
if v88.Parent.Parent.Parent.Name == "Songs" and not v88:FindFirstChild("Sound") then
	v88 = v88.Parent;
end;
local v89, v90, v91, v92 = v14.SpecialSongCheck(v88);
v27.Visible = false;
v78:Disconnect();
workspace.CurrentCamera.CameraType = Enum.CameraType.Scriptable;
workspace.CurrentCamera.CFrame = l__Value__6.CameraPoints.C.CFrame;
task.spawn(function()
	l__Value__6.MusicPart.Go.Played:Wait();
	v14.NowPlaying(l__Parent__3, v88, l__LocalPlayer__2);
	task.wait(1);
	game.StarterGui:SetCore("ResetButtonCallback", true);
end);
require(l__Parent__3.Modules.Icons).SetIcons(l__Parent__3, v88);
local u25 = v87;
local v93, v94 = pcall(function()
	u25 = game.HttpService:JSONDecode(u25).song;
end);
if v94 then
	u25 = game.HttpService:JSONDecode(require(game.ReplicatedStorage.Songs["/v/-tan"].Sage.Hard)).song;
end;
u25.bpm = u25.bpm * u17;
local v95 = 60 / (u25.bpm or 120 * u17);
local l__bpm__96 = u25.bpm;
local v97 = v95 / 4;
local l__Value__98 = v88.Credits.Value;
if v88.Parent.Parent.Parent.Name == "Songs" then
	local v99 = v88:IsA("ModuleScript") and v88.Parent.Name or v88.Name;
else
	v99 = v88.Name;
end;
local l__Name__100 = l__Value__6.Config.Song.Value.Name;
local v101 = math.ceil((l__Value__6.MusicPart.SERVERvocals.TimeLength - l__Value__6.MusicPart.SERVERvocals.TimePosition) / l__Value__6.MusicPart.SERVERvocals.PlaybackSpeed);
l__Parent__3.LowerContainer.Credit.Text = v99 .. " (" .. l__Name__100 .. ")" .. " (" .. u17 .. "x)" .. "\n" .. l__Value__98 .. "\n" .. string.format("%d:%02d", math.floor(v101 / 60), v101 % 60);
if v88:FindFirstChild("MobileButtons") then
	l__Parent__3.MobileButtons:Destroy();
	v88.MobileButtons:Clone().Parent = l__Parent__3;
end;
if v88:FindFirstChild("Countdown") and game.ReplicatedStorage.Countdowns:FindFirstChild(v88.Countdown.Value) then
	local v102 = require(game.ReplicatedStorage.Countdowns:FindFirstChild(v88.Countdown.Value).Config);
	local v103 = {};
	if v102.Images ~= nil then
		for v104, v105 in pairs(v102.Images) do
			table.insert(v103, v105);
		end;
	end;
	if v102.Audio ~= nil then
		for v106, v107 in pairs(v102.Audio) do
			table.insert(v103, v107);
		end;
	end;
	game.ContentProvider:PreloadAsync(v103);
end;
local v108 = v14.ModchartCheck(l__Parent__3, v88, u25);
local v109 = v13.Start(l__Parent__3, v88:FindFirstChild("Modchart"), l__bpm__96, v108);
local v110 = require(l__Parent__3.Modules.Functions);
v110.keyCheck(v88, v91, v90, v92);
local v111 = nil;
if v88:FindFirstChild("notetypeconvert") then
	v111 = require(v88.notetypeconvert);
end;
v110.stuffCheck(v88);
local v112 = v88:FindFirstChild("notetypeconvert") and v111.notetypeconvert or v110.notetypeconvert;
if v111 and v111.newKeys then
	v111.newKeys(l__Parent__3);
	v89 = true;
end;
local v113 = nil;
if not l__Value__6.Config.SinglePlayerEnabled.Value then
	if l__Value__6.Config.Player1.Value == l__LocalPlayer__2 then
		v113 = l__Value__6.Config.Player2.Value;
	else
		v113 = l__Value__6.Config.Player1.Value;
	end;
end;
if v113 then
	local v114 = game.ReplicatedStorage.Skins:FindFirstChild(v113.Input.Skin.Value) or game.ReplicatedStorage.Skins.Default;
else
	v114 = game.ReplicatedStorage.Skins.Default;
end;
l__Game__7.L.Arrows.IncomingNotes.DescendantAdded:Connect(function(p14)
	if not (l__Game__7.Rotation >= 90) then
		return;
	end;
	if v88:FindFirstChild("NoSettings") then
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
	if v88:FindFirstChild("NoSettings") then
		return;
	end;
	if p15:IsA("Frame") and p15:FindFirstChild("Frame") then
		p15.Rotation = 180;
		p15.Frame.Rotation = 180;
		p15.Frame.Arrow.Rotation = 180;
	end;
end);
function ChangeUI(p16)
	if p16 ~= nil then
		local v115 = game.ReplicatedStorage.UIStyles[p16];
		u14 = require(v115.Config);
		l__Parent__3.LowerContainer.Bar:Destroy();
		local v116 = v115.Bar:Clone();
		v116.Parent = l__Parent__3.LowerContainer;
		if u14.HealthBarColors then
			v116.Background.BackgroundColor3 = u14.HealthBarColors.Green or Color3.fromRGB(114, 255, 63);
			v116.Background.Fill.BackgroundColor3 = u14.HealthBarColors.Red or Color3.fromRGB(255, 0, 0);
		end;
		if u14.ShowIcons then
			v116.Player1.Sprite.Visible = u14.ShowIcons.Dad;
			v116.Player2.Sprite.Visible = u14.ShowIcons.BF;
		end;
		if v115:FindFirstChild("Stats") then
			l__Parent__3.LowerContainer.Stats:Destroy();
			local v117 = v115.Stats:Clone();
			v117.Parent = l__Parent__3.LowerContainer;
			if u14.font then
				v117.Label.Font = u14.font;
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
				local v118 = string.gsub(string.gsub(string.gsub(string.gsub(string.gsub(u14.overrideStats.Credits, "{song}", v99), "{rate}", u17), "{credits}", l__Value__98), "{difficulty}", l__Name__100), "{capdifficulty}", l__Name__100:upper());
				if u14.overrideStats.Timer then
					v118 = string.gsub(v118, "{timer}", u14.overrideStats.Timer);
				end;
				l__Parent__3.LowerContainer.Credit.Text = v118;
			elseif u14.overrideStats.Timer then
				l__Parent__3.LowerContainer.Credit.Text = v99 .. " (" .. l__Name__100 .. ")" .. " (" .. u17 .. "x)" .. "\n" .. l__Value__98 .. "\n" .. u14.overrideStats.Timer;
			end;
		end;
	else
		local l__Default__119 = game.ReplicatedStorage.UIStyles.Default;
		u14 = require(l__Default__119.Config);
		l__Parent__3.LowerContainer.Bar:Destroy();
		l__Parent__3.LowerContainer.Stats:Destroy();
		l__Default__119.Bar:Clone().Parent = l__Parent__3.LowerContainer;
		l__Default__119.Stats:Clone().Parent = l__Parent__3.LowerContainer;
		l__Parent__3.LowerContainer.PointsA.Font = Enum.Font.GothamBold;
		l__Parent__3.LowerContainer.PointsB.Font = Enum.Font.GothamBold;
	end;
	v32();
	require(l__Parent__3.Modules.Icons).SetIcons(l__Parent__3, v88);
	updateUI();
end;
local u26 = {};
function updateUI(p17)
	if v22.Name == "L" then
		local v120 = "R";
	else
		v120 = "L";
	end;
	local v121 = l__Game__7:FindFirstChild(v120);
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
			v121.OpponentStats.Visible = l__LocalPlayer__2.Input.ShowOtherMS.Value;
		else
			v121.OpponentStats.Visible = l__LocalPlayer__2.Input.ShowOpponentStats.Value;
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
	local v122, v123, v124 = pairs(l__Game__7.Templates:GetChildren());
	while true do
		local v125, v126 = v122(v123, v124);
		if v125 then

		else
			break;
		end;
		v124 = v125;
		v126.Frame.Bar.End.ImageTransparency = l__LocalPlayer__2.Input.BarOpacity.Value;
		v126.Frame.Bar.ImageLabel.ImageTransparency = l__LocalPlayer__2.Input.BarOpacity.Value;	
	end;
	if not v88:FindFirstChild("NoSettings") then
		if u14 ~= nil then
			if u14.overrideStats then
				if u14.overrideStats.Position then
					if u14.overrideStats.Position.Upscroll then
						l__Parent__3.LowerContainer.Stats.Position = u14.overrideStats.Position.Upscroll;
					end;
				end;
			end;
		end;
		if l__LocalPlayer__2.Input.VerticalBar.Value then
			local l__Size__127 = l__Parent__3.LowerContainer.Bar.Size;
			l__Parent__3.LowerContainer.Bar.Position = UDim2.new(1.1, 0, -4, 0);
			l__Parent__3.LowerContainer.Bar.Size = UDim2.new(l__Size__127.X.Scale * 0.8, l__Size__127.X.Offset, l__Size__127.Y.Scale, l__Size__127.Y.Offset);
			l__Parent__3.LowerContainer.Bar.Rotation = 90;
			l__Parent__3.LowerContainer.Bar.Player1.Sprite.Rotation = -90;
			l__Parent__3.LowerContainer.Bar.Player2.Sprite.Rotation = -90;
		end;
		if l__LocalPlayer__2.Input.Downscroll.Value then
			local v128 = UDim2.new(0.5, 0, 8.9, 0);
			if u14 ~= nil then
				if u14.overrideStats then
					if u14.overrideStats.Position then
						if u14.overrideStats.Position.Downscroll then
							v128 = u14.overrideStats.Position.Downscroll;
						end;
					end;
				end;
			end;
			l__Game__7.Rotation = 180;
			l__Game__7.Position = UDim2.new(0.5, 0, 0.05, 0);
			l__Parent__3.LowerContainer.AnchorPoint = Vector2.new(0.5, 0);
			l__Parent__3.LowerContainer.Position = UDim2.new(0.5, 0, 0.1, 0);
			l__Parent__3.LowerContainer.Stats.Position = v128;
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
				local l__Size__129 = l__Parent__3.LowerContainer.Bar.Size;
				l__Parent__3.LowerContainer.Bar.Position = UDim2.new(1.1, 0, 4, 0);
				l__Parent__3.LowerContainer.Bar.Rotation = 90;
				l__Parent__3.LowerContainer.Bar.Player1.Sprite.Rotation = -90;
				l__Parent__3.LowerContainer.Bar.Player2.Sprite.Rotation = -90;
			end;
			if not v89 then
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
				local l__Size__130 = l__Parent__3.LowerContainer.Bar.Size;
				l__Parent__3.LowerContainer.Bar.Position = UDim2.new(1.1, 0, -4, 0);
				l__Parent__3.LowerContainer.Bar.Rotation = 90;
				l__Parent__3.LowerContainer.Bar.Player1.Sprite.Rotation = -90;
				l__Parent__3.LowerContainer.Bar.Player2.Sprite.Rotation = -90;
			end;
			l__Game__7.L.Arrows.Rotation = 0;
			l__Game__7.R.Arrows.Rotation = 0;
			if not v89 then
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
			v121.Visible = l__LocalPlayer__2.Input.ShowOtherMS.Value;
			v22.Position = UDim2.new(0.5, 0, 0.5, 0);
			v22.AnchorPoint = Vector2.new(0.5, 0.5);
			if l__LocalPlayer__2.Input.ShowOtherMS.Value then
				v121.OpponentStats.Size = UDim2.new(2, 0, 0.05, 0);
				v121.OpponentStats.Position = UDim2.new(0.5, 0, -0.08, 0);
				v121.AnchorPoint = Vector2.new(0.1, 0);
				v121.Size = UDim2.new(0.15, 0, 0.3, 0);
				v121.Position = v121.Name == "R" and UDim2.new(0.88, 0, 0.5, 0) or UDim2.new(0, 0, 0.5, 0);
				if l__LocalPlayer__2.Input.Downscroll.Value then
					v121.Position = v121.Name == "L" and UDim2.new(0.88, 0, 0.5, 0) or UDim2.new(0, 0, 0.5, 0);
				end;
			end;
		elseif p17 == "Middlescroll" then
			v121.Visible = true;
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
	u26.Stats = l__Parent__3.LowerContainer.Stats.Size;
	local v131, v132, v133 = pairs(l__Parent__3.SideContainer:GetChildren());
	while true do
		local v134, v135 = v131(v132, v133);
		if v134 then

		else
			break;
		end;
		v133 = v134;
		if v135.ClassName == "TextLabel" then
			u26[v135.Name] = v135.Size;
		end;	
	end;
end;
l__Events__5.ChangeUI.Event:Connect(function(p18)
	ChangeUI(p18);
end);
local u27 = v88.Offset.Value + (l__LocalPlayer__2.Input.Offset.Value and 0);
local l__Value__28 = v62.Notes.Value;
local u29 = {
	L = {}, 
	R = {}
};
local l__Value__30 = v114.Notes.Value;
local l__Value__31 = v63.Notes.Value;
local v136 = require(game.ReplicatedStorage.Modules.Device);
local v137 = {
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
if not v91 then
	v137 = {
		L3 = "S", 
		L2 = "D", 
		L1 = "F", 
		Space = "Space", 
		R1 = "J", 
		R2 = "K", 
		R3 = "L"
	};
end;
_G.Animations = {};
if v88:FindFirstChild(l__Parent__3.PlayerSide.Value .. "_Anims") then
	local v138 = v88[l__Parent__3.PlayerSide.Value .. "_Anims"].Value;
else
	v138 = game.ReplicatedStorage.Animations:FindFirstChild(l__LocalPlayer__2.Input.Animation.Value) or (v14.findAnim(l__LocalPlayer__2.Input.Animation.Value) or game.ReplicatedStorage.Animations.Default);
end;
local u32 = {};
local u33 = nil;
local l__Animations__34 = _G.Animations;
local u35 = nil;
v1 = function(p19, p20, p21)
	if l__Parent__3.PlayerSide.Value == "R" then
		p19 = p19.Mirrored;
	end;
	if p21 then
		local v139, v140, v141 = ipairs(p19:GetChildren());
		while true do
			v139(v140, v141);
			if not v139 then
				break;
			end;
			v141 = v139;
			if v140:IsA("Animation") then
				u32[v140.Name] = p20:LoadAnimation(v140);
			end;		
		end;
		u33 = u32.Idle;
		return;
	end;
	if not p20 then
		p20 = l__LocalPlayer__2.Character.Humanoid;
	end;
	local v142, v143, v144 = ipairs(p19:GetChildren());
	while true do
		v142(v143, v144);
		if not v142 then
			break;
		end;
		v144 = v142;
		if v143:IsA("Animation") then
			l__Animations__34[v143.Name] = p20:LoadAnimation(v143);
		end;	
	end;
	u35 = l__Animations__34.Idle;
end;
if v138:FindFirstChild("Custom") then
	v1(v138, l__LocalPlayer__2.Character:WaitForChild("customrig"):WaitForChild("rig"):WaitForChild("Humanoid"));
elseif v138:FindFirstChild("FBX") then
	v1(v138, l__LocalPlayer__2.Character:WaitForChild("customrig"):WaitForChild("rig"):WaitForChild("AnimationController"):WaitForChild("Animator"));
elseif v138:FindFirstChild("2Player") then
	v1(v138.Other, l__LocalPlayer__2.Character:WaitForChild("char2"):WaitForChild("Dummy"):WaitForChild("Humanoid"), true);
	v1(v138, l__LocalPlayer__2.Character.Humanoid);
elseif v138:FindFirstChild("Custom2Player") then
	v1(v138.Other, l__LocalPlayer__2.Character:WaitForChild("char2"):WaitForChild("Dummy"):WaitForChild("Humanoid"), true);
	v1(v138, l__LocalPlayer__2.Character:WaitForChild("customrig"):WaitForChild("rig"):WaitForChild("Humanoid"));
else
	v1(v138);
end;
local u36 = Random.new();
local u37 = {};
if not tonumber(u25.speed) then
	u25.speed = 2.8;
end;
if u33 then
	u33:AdjustSpeed(u25.speed);
	u35:AdjustSpeed(u25.speed);
	u33.Looped = true;
	u35.Looped = true;
	u33.Priority = Enum.AnimationPriority.Idle;
	u35.Priority = Enum.AnimationPriority.Idle;
	u35:Play();
	u33:Play();
else
	u35:AdjustSpeed(u25.speed);
	u35.Looped = true;
	u35.Priority = Enum.AnimationPriority.Idle;
	u35:Play();
end;
local u38 = nil;
local u39 = nil;
local u40 = 0;
local u41 = {
	Left = false, 
	Down = false, 
	Up = false, 
	Right = false
};
local l__speed__145 = u25.speed;
u25.speed = l__LocalPlayer__2.Input.ScrollSpeedChange.Value and l__LocalPlayer__2.Input.ScrollSpeed.Value + 1.5 or (u25.speed or 3.3);
local v146 = 0.75 * u25.speed;
l__Config__4.MaxDist.Value = v146;
local v147 = Instance.new("Sound");
v147.Name = "HitSound";
v147.Parent = l__Parent__3;
v147.SoundId = "rbxassetid://" .. l__LocalPlayer__2.Input.HitSoundsValue.Value or "rbxassetid://3581383408";
v147.Volume = l__LocalPlayer__2.Input.HitSoundVolume.Value;
local u42 = {
	Left = false, 
	Down = false, 
	Up = false, 
	Right = false
};
local function u43(p22)
	local v148 = nil;
	local v149, v150, v151 = ipairs(v22.Arrows.IncomingNotes[p22]:GetChildren());
	while true do
		v149(v150, v151);
		if not v149 then
			break;
		end;
		v151 = v149;
		if (v150.Name == p22 or string.split(v150.Name, "_")[1] == p22) and (math.abs(string.split(v150:GetAttribute("NoteData"), "~")[1] - (v14.tomilseconds(l__Config__4.TimePast.Value) + u27)) <= v15.Ghost and v150.Frame.Arrow.Visible) then
			if not v148 then
				v148 = v150;
			elseif (v150.AbsolutePosition - v150.Parent.AbsolutePosition).magnitude <= (v148.AbsolutePosition - v150.Parent.AbsolutePosition).magnitude then
				v148 = v150;
			end;
		end;	
	end;
	if v148 then
		return;
	end;
	return true;
end;
local u44 = v88:FindFirstChild("Modchart") and (v88.Modchart:IsA("ModuleScript") and (v108 and require(v88.Modchart)));
local function u45(p23)
	local v152 = p23;
	if v89 then
		if v91 then
			if v152 == "A" or v152 == "H" then
				v152 = "Left";
			end;
			if v152 == "S" or v152 == "J" then
				v152 = "Down";
			end;
			if v152 == "D" or v152 == "K" then
				v152 = "Up";
			end;
			if v152 == "F" or v152 == "L" then
				v152 = "Right";
			end;
		elseif v90 or v92 then
			if v152 == "S" or v152 == "J" then
				v152 = "Left";
			end;
			if v152 == "D" then
				v152 = "Up";
			end;
			if v152 == "K" or v152 == "Space" then
				v152 = "Down";
			end;
			if v152 == "F" or v152 == "L" then
				v152 = "Right";
			end;
		elseif v111 and v111.getAnimationDirection then
			v152 = v111.getAnimationDirection(v152);
		end;
	end;
	if v138:FindFirstChild(v152) then
		if v22.Name == "L" then
			local v153 = v152;
			if not v153 then
				if v152 == "Right" then
					v153 = "Left";
				elseif v152 == "Left" then
					v153 = "Right";
				else
					v153 = v152;
				end;
			end;
		elseif v152 == "Right" then
			v153 = "Left";
		elseif v152 == "Left" then
			v153 = "Right";
		else
			v153 = v152;
		end;
		local v154 = v138[v153];
		local v155 = _G.Animations[v153];
		v155.Looped = false;
		v155.TimePosition = 0;
		v155.Priority = Enum.AnimationPriority.Movement;
		if u38 and u38 ~= v155 then
			u38:Stop(0);
		end;
		u38 = v155;
		local v156 = u32[v153];
		if v156 then
			local v157 = v138.Other[v153];
			v156.Looped = false;
			v156.TimePosition = 0;
			v156.Priority = Enum.AnimationPriority.Movement;
			if u39 and u39 ~= v156 then
				u39:Stop(0);
			end;
			u39 = v156;
		end;
		task.spawn(function()
			u40 = u40 + 1;
			while u41[p23] and u40 == u40 do
				v155:Play(0);
				if v156 then
					v156:Play(0);
				end;
				task.wait(0.1);			
			end;
			task.wait(v155.Length - 0.15);
			if u40 == u40 then
				v155:Stop(0);
				if l__Parent__3.Side.Value == l__Parent__3.PlayerSide.Value and l__LocalPlayer__2.Input.MoveOnHit.Value then
					local l__Value__158 = l__Parent__3.Side.Value;
					local v159 = workspace.ClientBG:FindFirstChildOfClass("Model");
					local v160 = v88:FindFirstChild("Modchart") and (v88.Modchart:IsA("ModuleScript") and (v108 and require(v88.Modchart)));
					if v160 and v160.CameraReset then
						v160.CameraReset();
					end;
					if v160 and v160.OverrideCamera then
						return;
					end;
					l__TweenService__17:Create(workspace.CurrentCamera, TweenInfo.new(l__LocalPlayer__2.Input.MoveSpeed.Value, v9, Enum.EasingDirection.Out), {
						CFrame = (v159 and v159:FindFirstChild("cameraPoints") and v159.cameraPoints:FindFirstChild(l__Value__158) or (l__Value__6.CameraPoints:FindFirstChild(l__Value__158) or l__Value__6.CameraPoints.C)).CFrame
					}):Play();
				end;
				if v156 then
					v156:Stop(0);
				end;
			end;
		end);
	end;
end;
local function u46(p24)
	if v89 and not v111 then
		return;
	end;
	if not l__LocalPlayer__2.Input.NoteSplashes.Value then
		return;
	end;
	if not game.ReplicatedStorage.Misc.Splashes:FindFirstChild(p24) then
		return;
	end;
	task.spawn(function()
		local v161 = game.ReplicatedStorage.Misc.Splashes[p24]:GetChildren();
		local v162 = v161[math.random(1, #v161)]:Clone();
		v162.Parent = v22.SplashContainer;
		v162.Position = v22.Arrows[p24].Position;
		v162.Image = (game.ReplicatedStorage.Splashes:FindFirstChild(l__LocalPlayer__2.Input.NoteSplashSkin.Value) or game.ReplicatedStorage.Splashes.Default).Splash.Value;
		v162.Size = UDim2.fromScale(l__LocalPlayer__2.Input.SplashSize.Value * v162.Size.X.Scale, l__LocalPlayer__2.Input.SplashSize.Value * v162.Size.Y.Scale);
		local l__X__163 = v162.ImageRectOffset.X;
		for v164 = 0, 8 do
			v162.ImageRectOffset = Vector2.new(l__X__163, v164 * 128);
			task.wait(0.035);
		end;
		v162:Destroy();
	end);
end;
local function u47(p25, p26)
	if not l__LocalPlayer__2.Input.MoveOnHit.Value then
		return;
	end;
	local l__Value__165 = l__Parent__3.Side.Value;
	local v166 = workspace.ClientBG:FindFirstChildOfClass("Model");
	local v167 = v88:FindFirstChild("Modchart") and (v88.Modchart:IsA("ModuleScript") and (v108 and require(v88.Modchart)));
	if v167 and v167.OverrideCamera then
		return;
	end;
	local v168 = v166 and v166:FindFirstChild("cameraPoints") and v166.cameraPoints:FindFirstChild(l__Value__165) or (l__Value__6.CameraPoints:FindFirstChild(l__Value__165) or l__Value__6.CameraPoints.C);
	if l__Parent__3.PlayerSide.Value == l__Parent__3.Side.Value and not p26 or l__Parent__3.PlayerSide.Value ~= l__Parent__3.Side.Value and p26 then
		if p25 == "Up" then
			l__TweenService__17:Create(workspace.CurrentCamera, TweenInfo.new(l__LocalPlayer__2.Input.MoveSpeed.Value, v9, Enum.EasingDirection.Out), {
				CFrame = v168.CFrame * CFrame.new(0, l__LocalPlayer__2.Input.MoveIntensity.value, 0)
			}):Play();
		end;
		if p25 == "Left" then
			l__TweenService__17:Create(workspace.CurrentCamera, TweenInfo.new(l__LocalPlayer__2.Input.MoveSpeed.Value, v9, Enum.EasingDirection.Out), {
				CFrame = v168.CFrame * CFrame.new(-l__LocalPlayer__2.Input.MoveIntensity.value, 0, 0)
			}):Play();
		end;
		if p25 == "Down" then
			l__TweenService__17:Create(workspace.CurrentCamera, TweenInfo.new(l__LocalPlayer__2.Input.MoveSpeed.Value, v9, Enum.EasingDirection.Out), {
				CFrame = v168.CFrame * CFrame.new(0, -l__LocalPlayer__2.Input.MoveIntensity.value, 0)
			}):Play();
		end;
		if p25 == "Right" then
			l__TweenService__17:Create(workspace.CurrentCamera, TweenInfo.new(l__LocalPlayer__2.Input.MoveSpeed.Value, v9, Enum.EasingDirection.Out), {
				CFrame = v168.CFrame * CFrame.new(l__LocalPlayer__2.Input.MoveIntensity.value, 0, 0)
			}):Play();
		end;
	end;
end;
local l__UserInput__48 = l__Events__5.UserInput;
local function u49(p27, p28)
	if not l__LocalPlayer__2.Input.ShowRatings.Value then
		return;
	end;
	local v169 = p28 and v22 or (l__Parent__3.PlayerSide.Value == "L" and l__Game__7.R or l__Game__7.L);
	local l__Value__170 = l__LocalPlayer__2.Input.RatingStyle.Value;
	if l__Value__170 == "FNB" then
		local v171 = v169:FindFirstChildOfClass("ImageLabel");
		if v171 then
			v171.Parent = nil;
		end;
		local v172 = v169:FindFirstChildOfClass("TextLabel");
		if v172 then
			v172.Parent = nil;
		end;
		local l__Value__173 = l__LocalPlayer__2.Input.RatingSize.Value;
		local v174 = game.ReplicatedStorage.Misc.IndicatorTemplate:Clone();
		v174.Image = "rbxthumb://type=Asset&id=" .. l__LocalPlayer__2.Input[p27 .. "IndicatorImg"].Value .. "&w=150&h=150" or l__Value__6.FlyingText.G["Template_" .. p27].Image;
		v174.Parent = v169;
		v174.Size = UDim2.new(0.25 * l__Value__173, 0, 0.083 * l__Value__173, 0);
		v174.ImageTransparency = 0;
		if l__Game__7.Rotation >= 90 then
			local v175 = 180;
		else
			v175 = 0;
		end;
		v174.Rotation = v175;
		game:GetService("Debris"):AddItem(v174, 1.5);
		if l__LocalPlayer__2.Input.CenterRatings.Value then
			v174.Position = UDim2.new(0.5, 0, 0.45, 0);
		end;
		task.spawn(function()
			if l__LocalPlayer__2.Input.RatingBounce.Value then
				l__TweenService__17:Create(v174, TweenInfo.new(0.05, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
					Size = UDim2.new(0.3 * l__Value__173, 0, 0.1 * l__Value__173, 0)
				}):Play();
			end;
			task.wait(0.1);
			l__TweenService__17:Create(v174, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
				Size = UDim2.new(0.25 * l__Value__173, 0, 0.083 * l__Value__173, 0)
			}):Play();
			task.wait(0.5);
			l__TweenService__17:Create(v174, TweenInfo.new(0.75, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
				ImageTransparency = 1
			}):Play();
		end);
		local v176 = game.ReplicatedStorage.Misc.miliseconds:Clone();
		v176.Visible = l__LocalPlayer__2.Input.ShowMS.Value;
		v176.Parent = v169;
		v176.Size = UDim2.new(0.145 * l__Value__173, 0, 0.044 * l__Value__173, 0);
		if l__Game__7.Rotation >= 90 then
			local v177 = 180;
		else
			v177 = 0;
		end;
		v176.Rotation = v177;
		v176.Text = math.floor(p28 * 100 + 0.5) / 100 .. " ms";
		if p28 < 0 then
			v176.TextColor3 = Color3.fromRGB(255, 61, 61);
		else
			v176.TextColor3 = Color3.fromRGB(120, 255, 124);
		end;
		game:GetService("Debris"):AddItem(v176, 1.5);
		if l__LocalPlayer__2.Input.CenterRatings.Value then
			v176.Position = UDim2.new(0.5, 0, 0.36, 0);
		end;
		task.spawn(function()
			if l__LocalPlayer__2.Input.RatingBounce.Value then
				l__TweenService__17:Create(v176, TweenInfo.new(0.05, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
					Size = UDim2.new(0.165 * l__Value__173, 0, 0.06 * l__Value__173, 0)
				}):Play();
			end;
			task.wait(0.1);
			l__TweenService__17:Create(v176, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
				Size = UDim2.new(0.145 * l__Value__173, 0, 0.044 * l__Value__173, 0)
			}):Play();
			task.wait(0.5);
			l__TweenService__17:Create(v176, TweenInfo.new(0.75, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
				TextTransparency = 1
			}):Play();
			l__TweenService__17:Create(v176, TweenInfo.new(0.75, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
				TextStrokeTransparency = 1
			}):Play();
		end);
	elseif l__Value__170 == "FNF" then
		local l__Value__178 = l__LocalPlayer__2.Input.RatingSize.Value;
		local v179 = game.ReplicatedStorage.Misc.IndicatorTemplate:Clone();
		v179.Image = "rbxthumb://type=Asset&id=" .. l__LocalPlayer__2.Input[p27 .. "IndicatorImg"].Value .. "&w=150&h=150" or l__Value__6.FlyingText.G["Template_" .. p27].Image;
		v179.Parent = v169;
		v179.Size = UDim2.new(0.25 * l__Value__178, 0, 0.083 * l__Value__178, 0);
		v179.ImageTransparency = 0;
		if l__Game__7.Rotation >= 90 then
			local v180 = 180;
		else
			v180 = 0;
		end;
		v179.Rotation = v180;
		if l__LocalPlayer__2.Input.Downscroll.Value then
			v179:SetAttribute("Acceleration", Vector2.new(0, -550));
			v179:SetAttribute("Velocity", Vector2.new(u36:NextInteger(0, 10), u36:NextInteger(140, 175)));
		else
			v179:SetAttribute("Acceleration", Vector2.new(0, 550));
			v179:SetAttribute("Velocity", Vector2.new(u36:NextInteger(0, 10), -u36:NextInteger(140, 175)));
		end;
		if l__LocalPlayer__2.Input.CenterRatings.Value then
			v179.Position = UDim2.new(0.5, 0, 0.45, 0);
		end;
		table.insert(u37, v179);
		local v181 = game:service("TweenService"):Create(v179, TweenInfo.new(0.2, Enum.EasingStyle.Linear, Enum.EasingDirection.Out, 0, false, v13.crochet * 0.001), {
			ImageTransparency = 1
		});
		v181:Play();
		v181.Completed:connect(function()
			v179:destroy();
			pcall(game.Destroy, v181);
		end);
		local v182 = game.ReplicatedStorage.Misc.miliseconds:Clone();
		v182.Visible = l__LocalPlayer__2.Input.ShowMS.Value;
		v182.Parent = v169;
		v182.Size = UDim2.new(0.145 * l__Value__178, 0, 0.044 * l__Value__178, 0);
		if l__Game__7.Rotation >= 90 then
			local v183 = 180;
		else
			v183 = 0;
		end;
		v182.Rotation = v183;
		v182.Text = math.floor(p28 * 100 + 0.5) / 100 .. " ms";
		if p28 < 0 then
			v182.TextColor3 = Color3.fromRGB(255, 61, 61);
		else
			v182.TextColor3 = Color3.fromRGB(120, 255, 124);
		end;
		if l__LocalPlayer__2.Input.Downscroll.Value then
			v182:SetAttribute("Acceleration", Vector2.new(0, -550));
			v182:SetAttribute("Velocity", Vector2.new(u36:NextInteger(0, 10), u36:NextInteger(140, 175)));
		else
			v182:SetAttribute("Acceleration", Vector2.new(0, 550));
			v182:SetAttribute("Velocity", Vector2.new(u36:NextInteger(0, 10), -u36:NextInteger(140, 175)));
		end;
		table.insert(u37, v182);
		if l__LocalPlayer__2.Input.CenterRatings.Value then
			v182.Position = UDim2.new(0.5, 0, 0.36, 0);
		end;
		local v184 = game:service("TweenService"):Create(v182, TweenInfo.new(0.2, Enum.EasingStyle.Linear, Enum.EasingDirection.Out, 0, false, v13.crochet * 0.001), {
			TextTransparency = 1, 
			TextStrokeTransparency = 1
		});
		v184:Play();
		v184.Completed:connect(function()
			v182:destroy();
			pcall(game.Destroy, v184);
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
local function v185(p29, p30, p31, p32, p33)
	if not p30 then
		return;
	end;
	if p32 then
		u42[p30] = p29.UserInputState == Enum.UserInputState.Begin;
		if l__Parent__3.PlayerSide.Value == "L" then
			local v186 = "R";
		else
			v186 = "L";
		end;
		p32 = l__Game__7:FindFirstChild(v186);
	end;
	if not p32 then
		u41[p30] = p29.UserInputState == Enum.UserInputState.Begin;
	end;
	if l__Config__4.CantHitNotes.Value then
		return;
	end;
	if not v89 and l__Config__4.DisabledLanes[p30].Value then
		return;
	end;
	local l__Value__187 = l__LocalPlayer__2.Input.InputType.Value;
	local v188 = nil;
	if not v22.Arrows.IncomingNotes:FindFirstChild(p30) then
		return;
	end;
	local v189, v190, v191 = ipairs((p32 or v22).Arrows.IncomingNotes[p30]:GetChildren());
	while true do
		v189(v190, v191);
		if not v189 then
			break;
		end;
		v191 = v189;
		if v190.Name == p30 or string.split(v190.Name, "_")[1] == p30 then
			local v192 = v190:GetAttribute("NoteData");
			local v193 = string.split(v192, "~")[1] - (v14.tomilseconds(l__Config__4.TimePast.Value) + u27);
			if not p32 then
				if v190.Frame.Arrow.Visible and (not v190.Frame.Arrow:GetAttribute("hit") and math.abs(v193) <= v15.Bad) then
					if not v188 then
						v188 = v190;
					elseif l__Value__187 == "Bloxxin" then
						if (v190.AbsolutePosition - v190.Parent.AbsolutePosition).magnitude <= (v188.AbsolutePosition - v190.Parent.AbsolutePosition).magnitude then
							v188 = v190;
						end;
					elseif v193 < string.split(v192, "~")[1] - (v14.tomilseconds(l__Config__4.TimePast.Value) + u27) then
						v188 = v190;
					end;
				end;
			elseif v192 == p31 then
				v188 = v190;
				break;
			end;
		end;	
	end;
	if l__Config__4.GhostTappingEnabled.Value and not v188 and not p32 and u43(p30) then
		v188 = "ghost";
	end;
	if not u41[p30] and p29.UserInputState ~= Enum.UserInputState.Begin then
		return;
	end;
	local v194 = u44 and u44.FakeHit;
	if p32 then
		if v188 then
			u47(p30, true);
			if v194 then
				v188.Frame.Arrow:SetAttribute("hit", true);
			else
				v188.Frame.Arrow.Visible = false;
			end;
			if p29.UserInputState ~= Enum.UserInputState.Begin then
				return;
			else
				local v195 = nil;
				local v196 = nil;
				local v197 = nil;
				p32.Glow[p30].Arrow.ImageTransparency = 1;
				if v111 and v111.Glow then
					v111.Glow(p30, true);
				else
					p32.Glow[p30].Arrow.Visible = true;
				end;
				if p32.Glow[p30].Arrow.ImageTransparency == 1 then
					if not l__LocalPlayer__2.Input.DisableArrowGlow.Value then
						local v198 = nil;
						local v199 = nil;
						local v200 = nil;
						local v201 = nil;
						local v202 = nil;
						local v203 = nil;
						local v204 = nil;
						local v205 = nil;
						local v206 = nil;
						local v207 = nil;
						local v208 = nil;
						local v209 = nil;
						local v210 = nil;
						local v211 = nil;
						local v212 = nil;
						local v213 = nil;
						local v214 = nil;
						local v215 = nil;
						if not u29[p32.Name][p30] then
							local u50 = false;
							local u51 = nil;
							u51 = l__RunService__19.RenderStepped:Connect(function()
								if u50 then
									u51:Disconnect();
									p32.Glow[p30].Arrow.ImageTransparency = 1;
									return;
								end;
								p32.Glow[p30].Arrow.ImageTransparency = 0.2 - math.cos(tick() * 10 * math.pi) / 6;
							end);
							v198 = "Frame";
							v199 = v188;
							v200 = v198;
							v201 = v199[v200];
							local v216 = "Bar";
							v202 = v201;
							v203 = v216;
							v204 = v202[v203];
							local v217 = "Size";
							v205 = v204;
							v206 = v217;
							v207 = v205[v206];
							local v218 = "Y";
							v208 = v207;
							v209 = v218;
							v210 = v208[v209];
							local v219 = "Scale";
							v212 = v210;
							v213 = v219;
							v211 = v212[v213];
							local v220 = 0;
							v214 = v220;
							v215 = v211;
							if v214 < v215 then
								local v221 = tick();
								while true do
									v14.wait();
									local l__Scale__222 = v188.Position.Y.Scale;
									if l__Scale__222 < 0 and not v194 then
										v188.Frame.Bar.Size = UDim2.new(l__LocalPlayer__2.Input.BarSize.Value, 0, math.clamp(v211 + l__Scale__222, 0, 20), 0);
										v188.Frame.Bar.Position = UDim2.new(0.5, 0, 0.5 - l__Scale__222, 0);
									end;
									if not u42[p30] then
										break;
									end;
									if v188.Frame.Bar.Size.Y.Scale == 0 then
										break;
									end;
									if tick() - v221 > 7.5 then
										break;
									end;								
								end;
							else
								v14.wait(0.175);
							end;
							local v223 = true;
							v195 = v111;
							v196 = v195;
							if v196 and v111.Glow then
								v111.Glow(p30, false);
							else
								p32.Glow[p30].Arrow.Visible = false;
							end;
							local v224 = u44;
							v197 = v224;
							if v197 and u44.OpponentHit then
								u44.OpponentHit(l__Parent__3, p30);
							end;
							return;
						elseif not l__LocalPlayer__2.Input.DisableArrowGlow.Value and u29[p32.Name][p30] then
							if false then
								u24:Disconnect();
								u29[p32.Name][p30]:PlayAnimation("Receptor");
								return;
							else
								u29[p32.Name][p30]:PlayAnimation("Glow");
								v198 = "Frame";
								v199 = v188;
								v200 = v198;
								v201 = v199[v200];
								v216 = "Bar";
								v202 = v201;
								v203 = v216;
								v204 = v202[v203];
								v217 = "Size";
								v205 = v204;
								v206 = v217;
								v207 = v205[v206];
								v218 = "Y";
								v208 = v207;
								v209 = v218;
								v210 = v208[v209];
								v219 = "Scale";
								v212 = v210;
								v213 = v219;
								v211 = v212[v213];
								v220 = 0;
								v214 = v220;
								v215 = v211;
								if v214 < v215 then
									v221 = tick();
									while true do
										v14.wait();
										l__Scale__222 = v188.Position.Y.Scale;
										if l__Scale__222 < 0 and not v194 then
											v188.Frame.Bar.Size = UDim2.new(l__LocalPlayer__2.Input.BarSize.Value, 0, math.clamp(v211 + l__Scale__222, 0, 20), 0);
											v188.Frame.Bar.Position = UDim2.new(0.5, 0, 0.5 - l__Scale__222, 0);
										end;
										if not u42[p30] then
											break;
										end;
										if v188.Frame.Bar.Size.Y.Scale == 0 then
											break;
										end;
										if tick() - v221 > 7.5 then
											break;
										end;									
									end;
								else
									v14.wait(0.175);
								end;
								v223 = true;
								v195 = v111;
								v196 = v195;
								if v196 and v111.Glow then
									v111.Glow(p30, false);
								else
									p32.Glow[p30].Arrow.Visible = false;
								end;
								v224 = u44;
								v197 = v224;
								if v197 and u44.OpponentHit then
									u44.OpponentHit(l__Parent__3, p30);
								end;
								return;
							end;
						else
							v198 = "Frame";
							v199 = v188;
							v200 = v198;
							v201 = v199[v200];
							v216 = "Bar";
							v202 = v201;
							v203 = v216;
							v204 = v202[v203];
							v217 = "Size";
							v205 = v204;
							v206 = v217;
							v207 = v205[v206];
							v218 = "Y";
							v208 = v207;
							v209 = v218;
							v210 = v208[v209];
							v219 = "Scale";
							v212 = v210;
							v213 = v219;
							v211 = v212[v213];
							v220 = 0;
							v214 = v220;
							v215 = v211;
							if v214 < v215 then
								v221 = tick();
								while true do
									v14.wait();
									l__Scale__222 = v188.Position.Y.Scale;
									if l__Scale__222 < 0 and not v194 then
										v188.Frame.Bar.Size = UDim2.new(l__LocalPlayer__2.Input.BarSize.Value, 0, math.clamp(v211 + l__Scale__222, 0, 20), 0);
										v188.Frame.Bar.Position = UDim2.new(0.5, 0, 0.5 - l__Scale__222, 0);
									end;
									if not u42[p30] then
										break;
									end;
									if v188.Frame.Bar.Size.Y.Scale == 0 then
										break;
									end;
									if tick() - v221 > 7.5 then
										break;
									end;								
								end;
							else
								v14.wait(0.175);
							end;
							v223 = true;
							v195 = v111;
							v196 = v195;
							if v196 and v111.Glow then
								v111.Glow(p30, false);
							else
								p32.Glow[p30].Arrow.Visible = false;
							end;
							v224 = u44;
							v197 = v224;
							if v197 and u44.OpponentHit then
								u44.OpponentHit(l__Parent__3, p30);
							end;
							return;
						end;
					elseif not l__LocalPlayer__2.Input.DisableArrowGlow.Value and u29[p32.Name][p30] then
						if false then
							u24:Disconnect();
							u29[p32.Name][p30]:PlayAnimation("Receptor");
							return;
						else
							u29[p32.Name][p30]:PlayAnimation("Glow");
							v198 = "Frame";
							v199 = v188;
							v200 = v198;
							v201 = v199[v200];
							v216 = "Bar";
							v202 = v201;
							v203 = v216;
							v204 = v202[v203];
							v217 = "Size";
							v205 = v204;
							v206 = v217;
							v207 = v205[v206];
							v218 = "Y";
							v208 = v207;
							v209 = v218;
							v210 = v208[v209];
							v219 = "Scale";
							v212 = v210;
							v213 = v219;
							v211 = v212[v213];
							v220 = 0;
							v214 = v220;
							v215 = v211;
							if v214 < v215 then
								v221 = tick();
								while true do
									v14.wait();
									l__Scale__222 = v188.Position.Y.Scale;
									if l__Scale__222 < 0 and not v194 then
										v188.Frame.Bar.Size = UDim2.new(l__LocalPlayer__2.Input.BarSize.Value, 0, math.clamp(v211 + l__Scale__222, 0, 20), 0);
										v188.Frame.Bar.Position = UDim2.new(0.5, 0, 0.5 - l__Scale__222, 0);
									end;
									if not u42[p30] then
										break;
									end;
									if v188.Frame.Bar.Size.Y.Scale == 0 then
										break;
									end;
									if tick() - v221 > 7.5 then
										break;
									end;								
								end;
							else
								v14.wait(0.175);
							end;
							v223 = true;
							v195 = v111;
							v196 = v195;
							if v196 and v111.Glow then
								v111.Glow(p30, false);
							else
								p32.Glow[p30].Arrow.Visible = false;
							end;
							v224 = u44;
							v197 = v224;
							if v197 and u44.OpponentHit then
								u44.OpponentHit(l__Parent__3, p30);
							end;
							return;
						end;
					else
						v198 = "Frame";
						v199 = v188;
						v200 = v198;
						v201 = v199[v200];
						v216 = "Bar";
						v202 = v201;
						v203 = v216;
						v204 = v202[v203];
						v217 = "Size";
						v205 = v204;
						v206 = v217;
						v207 = v205[v206];
						v218 = "Y";
						v208 = v207;
						v209 = v218;
						v210 = v208[v209];
						v219 = "Scale";
						v212 = v210;
						v213 = v219;
						v211 = v212[v213];
						v220 = 0;
						v214 = v220;
						v215 = v211;
						if v214 < v215 then
							v221 = tick();
							while true do
								v14.wait();
								l__Scale__222 = v188.Position.Y.Scale;
								if l__Scale__222 < 0 and not v194 then
									v188.Frame.Bar.Size = UDim2.new(l__LocalPlayer__2.Input.BarSize.Value, 0, math.clamp(v211 + l__Scale__222, 0, 20), 0);
									v188.Frame.Bar.Position = UDim2.new(0.5, 0, 0.5 - l__Scale__222, 0);
								end;
								if not u42[p30] then
									break;
								end;
								if v188.Frame.Bar.Size.Y.Scale == 0 then
									break;
								end;
								if tick() - v221 > 7.5 then
									break;
								end;							
							end;
						else
							v14.wait(0.175);
						end;
						v223 = true;
						v195 = v111;
						v196 = v195;
						if v196 and v111.Glow then
							v111.Glow(p30, false);
						else
							p32.Glow[p30].Arrow.Visible = false;
						end;
						v224 = u44;
						v197 = v224;
						if v197 and u44.OpponentHit then
							u44.OpponentHit(l__Parent__3, p30);
						end;
						return;
					end;
				else
					v195 = v111;
					v196 = v195;
					if v196 and v111.Glow then
						v111.Glow(p30, false);
					else
						p32.Glow[p30].Arrow.Visible = false;
					end;
					v224 = u44;
					v197 = v224;
					if v197 and u44.OpponentHit then
						u44.OpponentHit(l__Parent__3, p30);
					end;
					return;
				end;
			end;
		else
			return;
		end;
	end;
	u45(p30);
	if v188 and v188 ~= "ghost" then
		if v188:FindFirstChild("HitSound") then
			v14.PlaySound(v188.HitSound.Value, v188.HitSound.parent, 2.25);
		elseif l__LocalPlayer__2.Input.HitSounds.Value == true then
			v14.PlaySound(v147);
		end;
		local v225 = string.split(v188:GetAttribute("NoteData"), "~")[1] - (v14.tomilseconds(l__Config__4.TimePast.Value) + u27);
		local v226 = math.abs(v225);
		local v227 = string.split(v188.Name, "_")[1];
		if v226 <= v15.Sick then
			u46(v227);
		end;
		if l__LocalPlayer__2.Input.ScoreBop.Value then
			if l__LocalPlayer__2.Input.VerticalBar.Value then
				for v228, v229 in pairs(l__Parent__3.SideContainer:GetChildren()) do
					if v229.ClassName == "TextLabel" then
						v229.Size = UDim2.new(u26[v229.Name].X.Scale * 1.1, 0, u26[v229.Name].Y.Scale * 1.1, 0);
						l__TweenService__17:Create(v229, TweenInfo.new(0.3), {
							Size = u26[v229.Name]
						}):Play();
					end;
				end;
			else
				l__Parent__3.LowerContainer.Stats.Size = UDim2.new(u26.Stats.X.Scale * 1.1, 0, u26.Stats.Y.Scale * 1.1, 0);
				l__TweenService__17:Create(l__Parent__3.LowerContainer.Stats, TweenInfo.new(0.3), {
					Size = u26.Stats
				}):Play();
			end;
		end;
		u47(v227);
		u3 = u3 + 1;
		v32();
		if u44 and u44.UpdateStats then
			u44.UpdateStats(l__Parent__3);
		end;
		if u44 and u44.OnHit then
			u44.OnHit(l__Parent__3, u5, u3, v227, u2, p30);
		end;
		if v188.HellNote.Value == false then
			local v230 = "0";
		else
			v230 = "1";
		end;
		l__UserInput__48:FireServer(v188, p30 .. "|0|" .. v14.tomilseconds(l__Config__4.TimePast.Value) + u27 .. "|" .. v188.Position.Y.Scale .. "|" .. v188:GetAttribute("NoteData") .. "|" .. v188.Name .. "|" .. v188:GetAttribute("Length") .. "|" .. tostring(v230));
		table.insert(u12, {
			ms = v225, 
			songPos = l__Parent__3.Config.TimePast.Value, 
			miss = false
		});
		if v194 then
			v188.Frame.Arrow:SetAttribute("hit", true);
		else
			v188.Frame.Arrow.Visible = false;
		end;
		if not u41[p30] then
			return;
		end;
		v22.Glow[p30].Arrow.ImageTransparency = 1;
		if v111 and v111.Glow then
			v111.Glow(p30, true);
		else
			v22.Glow[p30].Arrow.Visible = true;
		end;
		if v22.Glow[p30].Arrow.ImageTransparency == 1 then
			if not l__LocalPlayer__2.Input.DisableArrowGlow.Value and not u29[v22.Name][p30] then
				local u52 = false;
				local u53 = nil;
				u53 = l__RunService__19.RenderStepped:Connect(function()
					if u52 then
						u53:Disconnect();
						v22.Glow[p30].Arrow.ImageTransparency = 1;
						return;
					end;
					v22.Glow[p30].Arrow.ImageTransparency = 0.2 - math.cos(tick() * 10 * math.pi) / 6 + v22.Arrows[p30].ImageTransparency / 1.25;
				end);
			elseif not l__LocalPlayer__2.Input.DisableArrowGlow.Value and u29[v22.Name][p30] then
				if false then
					u24:Disconnect();
					u29[v22.Name][p30]:PlayAnimation("Receptor");
					return;
				end;
				u29[v22.Name][p30]:PlayAnimation("Glow");
			end;
			local l__Scale__231 = v188.Frame.Bar.Size.Y.Scale;
			if l__Scale__231 > 0 then
				local v232 = math.abs(v225);
				while true do
					task.wait();
					local l__Scale__233 = v188.Position.Y.Scale;
					if l__Scale__233 < 0 and v188:FindFirstChild("Frame") and not v194 then
						v188.Frame.Bar.Size = UDim2.new(l__LocalPlayer__2.Input.BarSize.Value, 0, math.clamp(l__Scale__231 + l__Scale__233, 0, 20), 0);
						v188.Frame.Bar.Position = UDim2.new(0.5, 0, 0.5 - l__Scale__233, 0);
					end;
					if not u41[p30] then
						break;
					end;				
				end;
				if v188.HellNote.Value == false then
					local v234 = "0";
				else
					v234 = "1";
				end;
				l__UserInput__48:FireServer(v188, p30 .. "|1|" .. v14.tomilseconds(l__Config__4.TimePast.Value) + u27 .. "|" .. v188.Position.Y.Scale .. "|" .. v188:GetAttribute("NoteData") .. "|" .. v188.Name .. "|" .. v188:GetAttribute("Length") .. "|" .. tostring(v234));
				local v235 = 1 - math.clamp(math.abs(v188.Position.Y.Scale) / v188:GetAttribute("Length"), 0, 1);
				local v236 = v232 + v188:GetAttribute("SustainLength") * v235;
				if v235 <= v146 / 10 then
					if v232 <= v15.Marvelous and l__LocalPlayer__2.Input.ShowMarvelous.Value then
						local v237 = "Marvelous";
					else
						v237 = "Sick";
					end;
					u49(v237, v225);
					table.insert(u1, 1, 100);
					if v232 <= v15.Marvelous and l__LocalPlayer__2.Input.ShowMarvelous.Value then
						u6 = u6 + 1;
					else
						u7 = u7 + 1;
					end;
				elseif v235 <= v146 / 6 then
					u49("Good", v225);
					table.insert(u1, 1, 90);
					u8 = u8 + 1;
					if l__Parent__3:GetAttribute("Perfect") then
						l__LocalPlayer__2.Character.Humanoid.Health = 0;
					end;
				elseif v235 <= v146 then
					u49("Bad", v225);
					table.insert(u1, 1, 60);
					u10 = u10 + 1;
					if l__Parent__3:GetAttribute("Perfect") then
						l__LocalPlayer__2.Character.Humanoid.Health = 0;
					end;
				end;
				v32();
				if u44 and u44.UpdateStats then
					u44.UpdateStats(l__Parent__3);
				end;
				if not v194 then
					v188.Visible = false;
				end;
			else
				if v188.HellNote.Value ~= false then

				end;
				if v226 <= v15.Marvelous * 1 and l__LocalPlayer__2.Input.ShowMarvelous.Value then
					u49("Marvelous", v225);
					table.insert(u1, 1, 100);
					u6 = u6 + 1;
				elseif v226 <= v15.Sick * 1 then
					u49("Sick", v225);
					table.insert(u1, 1, 100);
					u7 = u7 + 1;
				elseif v226 <= v15.Good * 1 then
					u49("Good", v225);
					table.insert(u1, 1, 90);
					u8 = u8 + 1;
					if l__Parent__3:GetAttribute("Perfect") then
						l__LocalPlayer__2.Character.Humanoid.Health = 0;
					end;
				elseif v226 <= v15.Ok * 1 then
					u49("Ok", v225);
					table.insert(u1, 1, 75);
					u9 = u9 + 1;
					if l__Parent__3:GetAttribute("Perfect") then
						l__LocalPlayer__2.Character.Humanoid.Health = 0;
					end;
				elseif v226 <= v15.Bad * 1 then
					u49("Bad", v225);
					table.insert(u1, 1, 60);
					u10 = u10 + 1;
					if l__Parent__3:GetAttribute("Perfect") then
						l__LocalPlayer__2.Character.Humanoid.Health = 0;
					end;
				end;
				v32();
				if u44 and u44.UpdateStats then
					u44.UpdateStats(l__Parent__3);
				end;
				while true do
					v14.wait();
					if not u41[p30] then
						break;
					end;				
				end;
				if not v194 then
					v188.Visible = false;
				end;
			end;
		end;
		if v111 and v111.Glow then
			v111.Glow(p30, false);
		else
			v22.Glow[p30].Arrow.Visible = false;
		end;
	end;
	if not u41[p30] then
		return;
	end;
	if v188 ~= "ghost" then
		l__UserInput__48:FireServer("missed", p30 .. "|0");
		table.insert(u1, 1, 0);
		u4 = u4 + 1;
		u3 = 0;
		v32();
		if u44 and u44.UpdateStats then
			u44.UpdateStats(l__Parent__3);
		end;
		table.insert(u12, {
			ms = 0, 
			songPos = l__Parent__3.Config.TimePast.Value, 
			miss = true
		});
		if u44 and u44.OnMiss then
			u44.OnMiss(l__Parent__3, u4, u2, p30);
		end;
		if l__Parent__3:GetAttribute("SuddenDeath") and l__Config__4.TimePast.Value > 5 then
			l__LocalPlayer__2.Character.Humanoid.Health = 0;
		end;
		local v238 = l__Parent__3.Sounds:GetChildren()[math.random(1, #l__Parent__3.Sounds:GetChildren())];
		v238.Volume = l__LocalPlayer__2.Input.MissVolume.Value and 0.3;
		v238:Play();
	end;
	local v239 = v22.Arrows[p30];
	u41[p30] = true;
	if u29[v22.Name][p30] then
		u29[v22.Name][p30]:PlayAnimation("Press");
	elseif v239:FindFirstChild("Overlay") then
		v239.Overlay.Visible = true;
	else
		v111.Pressed(p30, true, l__Parent__3);
	end;
	local v240 = 1 * l__LocalPlayer__2.Input.ArrowSize.Value;
	if v90 then
		v240 = 1;
	end;
	if v92 then
		v240 = 0.85;
	end;
	if v91 then
		v240 = 0.7;
	end;
	if v111 then
		v240 = v111.CustomArrowSize and 1;
	end;
	l__TweenService__17:Create(v239, TweenInfo.new(0.05, Enum.EasingStyle.Linear, Enum.EasingDirection.In, 0, false, 0), {
		Size = v188 == "ghost" and UDim2.new(v240 / 1.05, 0, v240 / 1.05, 0) or UDim2.new(v240 / 1.25, 0, v240 / 1.25, 0)
	}):Play();
	while true do
		task.wait();
		if not u41[p30] then
			break;
		end;	
	end;
	if u29[v22.Name][p30] then
		u29[v22.Name][p30]:PlayAnimation("Receptor");
	elseif v239:FindFirstChild("Overlay") then
		v239.Overlay.Visible = false;
	else
		v111.Pressed(p30, false, l__Parent__3);
	end;
	l__TweenService__17:Create(v239, TweenInfo.new(0.05, Enum.EasingStyle.Quint, Enum.EasingDirection.Out, 0, false, 0), {
		Size = UDim2.new(v240, 0, v240, 0)
	}):Play();
end;
local v241 = nil;
local l__Value__242 = _G.LastInput.Value;
if l__Value__242 == Enum.UserInputType.Touch then
	script.Device.Value = "Mobile";
	v14.wait(0.2);
	local v243, v244, v245 = ipairs(l__Parent__3.MobileButtons.Container:GetChildren());
	while true do
		v243(v244, v245);
		if not v243 then
			break;
		end;
		v245 = v243;
		if v244:IsA("ImageButton") then
			v244.MouseButton1Down:Connect(function()
				v185({
					UserInputState = Enum.UserInputState.Begin
				}, v244.Name);
			end);
			v244.MouseButton1Up:Connect(function()
				v185({
					UserInputState = Enum.UserInputState.End
				}, v244.Name);
			end);
		end;	
	end;
	script.Parent.MobileButtons.Visible = true;
elseif l__Value__242 == Enum.UserInputType.Keyboard then
	script.Device.Value = "Computer";
	local function v246(p34, p35)
		if p35 then
			return;
		end;
		local l__Keybinds__247 = l__LocalPlayer__2.Input.Keybinds;
		if v111 and v111.getDirection then
			local v248 = v111.getDirection(p34.KeyCode, l__Keybinds__247);
			if v248 then
				v185(p34, v248);
				return;
			end;
		else
			if v89 then
				local v249, v250, v251 = ipairs(l__Keybinds__247:GetChildren());
				while true do
					v249(v250, v251);
					if not v249 then
						break;
					end;
					v251 = v249;
					if v250:GetAttribute("ExtraKey") and p34.KeyCode.Name == v250.Value then
						v185(p34, v137[v250.Name]);
						return;
					end;				
				end;
				return;
			end;
			local v252, v253, v254 = ipairs(l__Keybinds__247:GetChildren());
			while true do
				v252(v253, v254);
				if not v252 then
					break;
				end;
				v254 = v252;
				if not v253:GetAttribute("ExtraKey") then
					if p34.KeyCode.Name == v253.Value then
						local l__Name__255 = v253.Name;
						if v253:GetAttribute("SecondaryKey") then
							local v256 = v253:GetAttribute("Key");
						end;
						v185(p34, v253:GetAttribute("SecondaryKey") and v253:GetAttribute("Key") or v253.Name);
						return;
					end;
					if v253:GetAttribute("SecondaryKey") and p34.KeyCode.Name == v253:GetAttribute("Key") then
						l__Name__255 = v253.Name;
						if v253:GetAttribute("SecondaryKey") then
							v256 = v253:GetAttribute("Key");
						end;
						v185(p34, v253:GetAttribute("SecondaryKey") and v253:GetAttribute("Key") or v253.Name);
						return;
					end;
				end;			
			end;
		end;
	end;
	v241 = l__UserInputService__18.InputBegan:connect(v246);
	local v257 = l__UserInputService__18.InputEnded:connect(v246);
elseif l__Value__242 == Enum.UserInputType.Gamepad1 then
	script.Device.Value = "Controller";
	local function v258(p36, p37)
		local l__XBOXKeybinds__259 = l__LocalPlayer__2.Input.XBOXKeybinds;
		if v111 and v111.getDirection then
			local v260 = v111.getDirection(p36.KeyCode, l__XBOXKeybinds__259);
			if v260 then
				v185(p36, v260);
				return;
			end;
		elseif v89 then
			local v261, v262, v263 = ipairs(l__XBOXKeybinds__259:GetChildren());
			while true do
				v261(v262, v263);
				if not v261 then
					break;
				end;
				v263 = v261;
				if v262:GetAttribute("ExtraKey") and p36.KeyCode.Name == v262.Value then
					v185(p36, v137[v262.Name:sub(12, -1)]);
					return;
				end;			
			end;
			return;
		else
			local v264, v265, v266 = ipairs(l__XBOXKeybinds__259:GetChildren());
			while true do
				v264(v265, v266);
				if not v264 then
					break;
				end;
				v266 = v264;
				if not v265:GetAttribute("ExtraKey") and p36.KeyCode.Name == v265.Value then
					v185(p36, v265.Name:sub(12, -1));
					return;
				end;			
			end;
		end;
	end;
	v241 = l__UserInputService__18.InputBegan:connect(v258);
	local v267 = l__UserInputService__18.InputEnded:connect(v258);
end;
if l__Parent__3.PlayerSide.Value == "L" then
	local v268 = l__Value__6.Events.Player2Hit.OnClientEvent:Connect(function(p38)
		p38 = string.split(p38, "|");
		v185({
			UserInputState = p38[2] == "0" and Enum.UserInputState.Begin or Enum.UserInputState.End
		}, p38[1], string.gsub(p38[3], "~", "|") .. "~" .. p38[4], true, (tonumber(p38[5])));
	end);
else
	v268 = l__Value__6.Events.Player1Hit.OnClientEvent:Connect(function(p39)
		p39 = string.split(p39, "|");
		v185({
			UserInputState = p39[2] == "0" and Enum.UserInputState.Begin or Enum.UserInputState.End
		}, p39[1], string.gsub(p39[3], "~", "|") .. "~" .. p39[4], true, (tonumber(p39[5])));
	end);
end;
l__Parent__3.Side.Changed:Connect(function()
	if u44 and u44.OverrideCamera then
		return;
	end;
	local l__Value__269 = l__Parent__3.Side.Value;
	local v270 = workspace.ClientBG:FindFirstChildOfClass("Model");
	l__TweenService__17:Create(workspace.CurrentCamera, TweenInfo.new(l__LocalPlayer__2.Input.CameraSpeed.Value, v9, Enum.EasingDirection.Out, 0, false, 0), {
		CFrame = (v270 and v270:FindFirstChild("cameraPoints") and v270.cameraPoints:FindFirstChild(l__Value__269) or (l__Value__6.CameraPoints:FindFirstChild(l__Value__269) or l__Value__6.CameraPoints.C)).CFrame
	}):Play();
end);
if l__LocalPlayer__2.Input.HideMap.Value and not v88:FindFirstChild("ForceBackgrounds") then
	local v271 = Instance.new("Frame");
	v271.Parent = l__Parent__3;
	v271.Position = UDim2.new(0, 0, 0, 0);
	v271.BackgroundColor3 = Color3.fromRGB(0, 0, 0);
	v271.Size = UDim2.new(1, 0, 1, 0);
	v271.BackgroundTransparency = 1;
	l__LocalPlayer__2.Character:WaitForChild("Humanoid").Died:Connect(function()
		game.ReplicatedStorage.Events.UnloadBackground:Fire();
	end);
	l__TweenService__17:Create(v271, TweenInfo.new(0.4), {
		BackgroundTransparency = 0
	}):Play();
	task.wait(0.4);
	task.spawn(function()
		l__TweenService__17:Create(v271, TweenInfo.new(0.4), {
			BackgroundTransparency = 1
		}):Play();
		task.wait(0.4);
		v271:Destroy();
	end);
	for v272, v273 in pairs(workspace:GetDescendants()) do
		if not v273:IsDescendantOf(l__Value__6) and not v273:IsDescendantOf(workspace.Misc.ActualShop) and (not l__Value__6.Seat.Occupant or not v273:IsDescendantOf(l__Value__6.Seat.Occupant.Parent)) and (not l__Value__6.Config.Player1.Value or not v273:IsDescendantOf(l__Value__6.Config.Player1.Value.Character)) and (not l__Value__6.Config.Player2.Value or not v273:IsDescendantOf(l__Value__6.Config.Player2.Value.Character)) then
			if not (not v273:IsA("BasePart")) or not (not v273:IsA("Decal")) or v273:IsA("Texture") then
				v273.Transparency = 1;
			elseif v273:IsA("GuiObject") then
				v273.Visible = false;
			elseif v273:IsA("Beam") or v273:IsA("ParticleEmitter") then
				v273.Enabled = false;
			end;
		end;
	end;
	local v274 = game.ReplicatedStorage.Misc.DarkVoid:Clone();
	v274.Parent = workspace.ClientBG;
	v274:SetPrimaryPartCFrame(l__Value__6.BackgroundPart.CFrame);
	for v275, v276 in pairs(game.Lighting:GetChildren()) do
		v276:Destroy();
	end;
	for v277, v278 in pairs(v274.Lighting:GetChildren()) do
		v278:Clone().Parent = game.Lighting;
	end;
	l__Value__6.Misc.Stereo.Speakers.Transparency = 1;
	for v279, v280 in pairs(l__Value__6.Fireworks:GetChildren()) do
		v280.Transparency = 1;
	end;
end;
local u54 = false;
l__Events__5.ChangeBackground.Event:Connect(function(p40, p41, p42)
	if (not l__LocalPlayer__2.Input.Backgrounds.Value or l__LocalPlayer__2.Input.HideMap.Value) and not v88:FindFirstChild("ForceBackgrounds") then
		return;
	end;
	local l__Backgrounds__281 = game.ReplicatedStorage.Backgrounds;
	local v282 = l__Backgrounds__281:FindFirstChild(p41) and l__Backgrounds__281[p41]:Clone() or game.ReplicatedStorage.Events.Backgrounds:InvokeServer("Load", p40, p41, v88);
	if not l__Backgrounds__281:FindFirstChild(p41) then
		v282:Clone().Parent = l__Backgrounds__281;
	end;
	for v283, v284 in pairs(workspace.ClientBG:GetChildren()) do
		v284:Destroy();
	end;
	if l__Value__6.Config.CleaningUp.Value then
		return;
	end;
	if not u54 then
		u54 = true;
		local v285 = Instance.new("Frame");
		v285.Parent = l__Parent__3;
		v285.Position = UDim2.new(0, 0, 0, 0);
		v285.BackgroundColor3 = Color3.fromRGB(0, 0, 0);
		v285.Size = UDim2.new(1, 0, 1, 0);
		v285.BackgroundTransparency = 1;
		l__TweenService__17:Create(v285, TweenInfo.new(0.4), {
			BackgroundTransparency = 0
		}):Play();
		task.wait(0.4);
		task.spawn(function()
			l__TweenService__17:Create(v285, TweenInfo.new(0.4), {
				BackgroundTransparency = 1
			}):Play();
			task.wait(0.4);
			v285:Destroy();
		end);
		for v286, v287 in pairs(workspace:GetDescendants()) do
			if not v287:IsDescendantOf(l__Value__6) and not v287:IsDescendantOf(workspace.Misc.ActualShop) and (not l__Value__6.Seat.Occupant or not v287:IsDescendantOf(l__Value__6.Seat.Occupant.Parent)) and (not l__Value__6.Config.Player1.Value or not v287:IsDescendantOf(l__Value__6.Config.Player1.Value.Character)) and (not l__Value__6.Config.Player2.Value or not v287:IsDescendantOf(l__Value__6.Config.Player2.Value.Character)) then
				if not (not v287:IsA("BasePart")) or not (not v287:IsA("Decal")) or v287:IsA("Texture") then
					v287.Transparency = 1;
				elseif v287:IsA("GuiObject") then
					v287.Visible = false;
				elseif v287:IsA("Beam") or v287:IsA("ParticleEmitter") then
					v287.Enabled = false;
				end;
			end;
		end;
	end;
	if p42 then
		local v288 = 0;
	else
		v288 = 1;
	end;
	l__Value__6.Misc.Stereo.Speakers.Transparency = v288;
	for v289, v290 in pairs(l__Value__6.Fireworks:GetChildren()) do
		if p42 then
			local v291 = 0;
		else
			v291 = 1;
		end;
		v290.Transparency = v291;
	end;
	v282.Parent = workspace.ClientBG;
	v282:SetPrimaryPartCFrame(l__Value__6.BackgroundPart.CFrame);
	if v282:FindFirstChild("Lighting") then
		for v292, v293 in pairs(game.Lighting:GetChildren()) do
			v293:Destroy();
		end;
		for v294, v295 in pairs(v282.Lighting:GetChildren()) do
			if not (not v295:IsA("StringValue")) or not (not v295:IsA("Color3Value")) or v295:IsA("NumberValue") then
				local v296, v297 = pcall(function()
					game.Lighting[v295.Name] = v295.Value;
				end);
				if v297 then
					warn(v297);
				end;
			else
				v295:Clone().Parent = game.Lighting;
			end;
		end;
	end;
	if v282:FindFirstChild("ModuleScript") then
		task.spawn(require(v282.ModuleScript).BGFunction);
	end;
	if v282:FindFirstChild("cameraPoints") then
		l__CameraPoints__8.L.CFrame = v282.cameraPoints.L.CFrame;
		l__CameraPoints__8.C.CFrame = v282.cameraPoints.C.CFrame;
		l__CameraPoints__8.R.CFrame = v282.cameraPoints.R.CFrame;
		if u44 and u44.OverrideCamera then
			return;
		end;
		l__TweenService__17:Create(workspace.CurrentCamera, TweenInfo.new(l__LocalPlayer__2.Input.CameraSpeed.Value, v9, Enum.EasingDirection.Out), {
			CFrame = v282.cameraPoints.L.CFrame
		}):Play();
	end;
	if v282:FindFirstChild("playerPoints") then
		local l__playerPoints__55 = v282.playerPoints;
		local l__Value__298 = l__Value__6.Config.Player1.Value;
		local l__Value__299 = l__Value__6.Config.Player2.Value;
		local l__NPC__300 = l__Value__6:FindFirstChild("NPC");
		local function u56(p43, p44)
			if not p43 then
				return;
			end;
			p44 = l__playerPoints__55:FindFirstChild("PlayerPoint" .. p44);
			if not p44 then
				return;
			end;
			local l__Character__301 = p43.Character;
			if l__Character__301 then
				if l__Character__301:FindFirstChild("char2") then
					local l__Dummy__302 = l__Character__301.char2:WaitForChild("Dummy");
					if not l__Dummy__302.PrimaryPart then
						while true do
							task.wait();
							if l__Dummy__302.PrimaryPart then
								break;
							end;						
						end;
					end;
					local l__PrimaryPart__303 = l__Dummy__302.PrimaryPart;
					if not l__PrimaryPart__303:GetAttribute("YOffset") then
						l__PrimaryPart__303:SetAttribute("YOffset", l__PrimaryPart__303.Position.Y - l__Character__301.PrimaryPart.Position.Y);
					end;
					if not l__PrimaryPart__303:GetAttribute("OrientationOffset") then
						l__PrimaryPart__303:SetAttribute("OrientationOffset", l__PrimaryPart__303.Orientation.Y - l__Character__301.PrimaryPart.Orientation.Y);
					end;
					l__PrimaryPart__303.CFrame = p44.CFrame + Vector3.new(0, l__PrimaryPart__303:GetAttribute("YOffset"), 0);
					l__PrimaryPart__303.CFrame = l__PrimaryPart__303.CFrame * CFrame.Angles(0, math.rad((l__PrimaryPart__303:GetAttribute("OrientationOffset"))), 0);
				end;
				if l__Character__301:FindFirstChild("customrig") then
					local l__rig__304 = l__Character__301.customrig:WaitForChild("rig");
					if not l__rig__304.PrimaryPart then
						while true do
							task.wait();
							if l__rig__304.PrimaryPart then
								break;
							end;						
						end;
					end;
					local l__PrimaryPart__305 = l__rig__304.PrimaryPart;
					if not l__PrimaryPart__305:GetAttribute("YOffset") then
						l__PrimaryPart__305:SetAttribute("YOffset", l__PrimaryPart__305.Position.Y - l__Character__301.PrimaryPart.Position.Y);
					end;
					if not l__PrimaryPart__305:GetAttribute("OrientationOffset") then
						l__PrimaryPart__305:SetAttribute("OrientationOffset", l__PrimaryPart__305.Orientation.Y - l__Character__301.PrimaryPart.Orientation.Y);
					end;
					l__PrimaryPart__305.CFrame = p44.CFrame + Vector3.new(0, l__PrimaryPart__305:GetAttribute("YOffset"), 0);
					l__PrimaryPart__305.CFrame = l__PrimaryPart__305.CFrame * CFrame.Angles(0, math.rad((l__PrimaryPart__305:GetAttribute("OrientationOffset"))), 0);
				end;
				if l__Character__301 then
					l__Character__301.PrimaryPart.CFrame = p44.CFrame;
				end;
			end;
		end;
		task.spawn(function()
			if u44 and u44.STOP == true then
				return;
			end;
			while l__Parent__3.Parent and v282.Parent do
				local l__Value__306 = l__Value__6.Config.Player1.Value;
				if l__Value__306 then
					local v307 = "B";
				else
					v307 = "A";
				end;
				u56(l__Value__6:FindFirstChild("NPC"), v307);
				u56(l__Value__306, "A");
				u56(l__Value__6.Config.Player2.Value, "B");
				task.wait(1);			
			end;
		end);
	end;
end);
if v88:FindFirstChild("Background") and l__Parent__3:FindFirstAncestorOfClass("Player") then
	l__Parent__3.Events.ChangeBackground:Fire(v88.stageName.Value, v88.Background.Value, v88.Background.Stereo.Value);
end;
if l__Value__6.Config.SinglePlayerEnabled.Value and not v88:FindFirstChild("NoNPC") then
	local v308 = require(l__Parent__3.Modules.Bot);
	v308.Start(u25.speed, v22);
	v308.Act(l__Parent__3.PlayerSide.Value, l__bpm__96);
end;
local u57 = {
	Left = { Vector2.new(315, 116), Vector2.new(77, 77.8) }, 
	Down = { Vector2.new(925, 77), Vector2.new(78.5, 77) }, 
	Up = { Vector2.new(925, 0), Vector2.new(78.5, 77) }, 
	Right = { Vector2.new(238, 116), Vector2.new(77, 78.5) }
};
local u58 = {
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
if v88:FindFirstChild("MineNotes") then
	local v309 = require(v88.MineNotes:FindFirstChildOfClass("ModuleScript"));
	local v310 = Instance.new("ImageLabel");
	v310.Image = v309.Image or "rbxassetid://9873431724";
	v310.Size = UDim2.new(0, 0, 0, 0);
	v310.Parent = l__Parent__3;
	if v309.update then
		l__RunService__19.RenderStepped:Connect(function(p45)
			v309.update(p45, l__Parent__3, v310);
		end);
	end;
	game:GetService("ContentProvider"):PreloadAsync({ v309.Image or "rbxassetid://9873431724" });
end;
if v88:FindFirstChild("GimmickNotes") then
	local v311 = require(v88.GimmickNotes:FindFirstChildOfClass("ModuleScript"));
	local v312 = Instance.new("ImageLabel");
	v312.Image = v311.Image or "rbxassetid://9873431724";
	v312.Size = UDim2.new(0, 0, 0, 0);
	v312.Parent = l__Parent__3;
	if v311.update then
		l__RunService__19.RenderStepped:Connect(function(p46)
			v311.update(p46, l__Parent__3, v312);
		end);
	end;
	game:GetService("ContentProvider"):PreloadAsync({ v311.Image or "rbxassetid://9873431724" });
end;
if v88:FindFirstChild("MultipleGimmickNotes") then
	local v313, v314, v315 = pairs(v88.MultipleGimmickNotes:GetChildren());
	while true do
		local v316, v317 = v313(v314, v315);
		if not v316 then
			break;
		end;
		if not v317:IsA("Frame") then
			return;
		end;
		local v318 = require(v317:FindFirstChildOfClass("ModuleScript"));
		local v319 = Instance.new("ImageLabel");
		v319.Image = v318.Image or "rbxassetid://9873431724";
		v319.Size = UDim2.new(0, 0, 0, 0);
		v319.Parent = l__Parent__3;
		if v318.update then
			l__RunService__19.RenderStepped:Connect(function(p47)
				v318.update(p47, l__Parent__3, v319);
			end);
		end;
		for v320, v321 in pairs(u58) do
			local v322 = v317:Clone();
			v322.Name = ("%s_%s"):format(v320, v317.Name);
			v322.Frame.Position = UDim2.fromScale(v321.Pos, 0);
			v322.Frame.AnchorPoint = Vector2.new(0.5, 0);
			v322.Parent = l__Game__7.Templates;
		end;
		game:GetService("ContentProvider"):PreloadAsync({ v318.Image or "rbxassetid://9873431724" });	
	end;
end;
(function(p48, p49)
	if v22.Name == "L" then
		local v323 = "R";
	else
		v323 = "L";
	end;
	local v324 = l__Game__7:FindFirstChild(v323);
	if v88:FindFirstChild("UIStyle") then
		ChangeUI(v88:FindFirstChild("UIStyle").Value);
	else
		ChangeUI(nil);
	end;
	updateUI(p48);
	l__Parent__3.Background.BackgroundTransparency = l__LocalPlayer__2.Input.BackgroundTrans.Value;
	l__Game__7.L.Underlay.BackgroundTransparency = l__LocalPlayer__2.Input.ChartTransparency.Value;
	l__Game__7.R.Underlay.BackgroundTransparency = l__LocalPlayer__2.Input.ChartTransparency.Value;
	v110.settingsCheck(v89, v88:FindFirstChild("NoSettings"));
	u27 = v88.Offset.Value + (l__LocalPlayer__2.Input.Offset.Value and 0);
	if not v89 then
		local v325, v326, v327 = ipairs(v22.Arrows:GetChildren());
		while true do
			v325(v326, v327);
			if not v325 then
				break;
			end;
			v327 = v325;
			if v326:IsA("ImageLabel") then
				v326.Image = l__Value__28;
				v326.Overlay.Image = l__Value__28;
			end;		
		end;
		local v328, v329, v330 = ipairs(v22.Glow:GetChildren());
		while true do
			v328(v329, v330);
			if not v328 then
				break;
			end;
			v330 = v328;
			v329.Arrow.Image = l__Value__28;		
		end;
		if v62:FindFirstChild("XML") then
			local v331 = require(v62.XML);
			if v62:FindFirstChild("Animated") and v62:FindFirstChild("Animated").Value == true then
				local v332 = require(v62.Config);
				local v333, v334, v335 = ipairs(v22.Arrows:GetChildren());
				while true do
					v333(v334, v335);
					if not v333 then
						break;
					end;
					v335 = v333;
					if v334:IsA("ImageLabel") then
						if v334.Overlay then
							v334.Overlay.Visible = false;
						end;
						local v336 = v21.new(v334, true, 1, true, v332.noteScale);
						v336.Animations = {};
						v336.CurrAnimation = nil;
						v336.AnimData.Looped = false;
						if type(v332.receptor) == "string" then
							v336:AddSparrowXML(v62.XML, "Receptor", v332.receptor, 24, true).ImageId = l__Value__28;
						else
							v336:AddSparrowXML(v62.XML, "Receptor", v332.receptor[v334.Name], 24, true).ImageId = l__Value__28;
						end;
						if v332.glow ~= nil then
							if type(v332.glow) == "string" then
								v336:AddSparrowXML(v62.XML, "Glow", v332.glow, 24, true).ImageId = l__Value__28;
							else
								v336:AddSparrowXML(v62.XML, "Glow", v332.glow[v334.Name], 24, true).ImageId = l__Value__28;
							end;
						end;
						if v332.press ~= nil then
							if type(v332.press) == "string" then
								v336:AddSparrowXML(v62.XML, "Press", v332.press, 24, true).ImageId = l__Value__28;
							else
								v336:AddSparrowXML(v62.XML, "Press", v332.press[v334.Name], 24, true).ImageId = l__Value__28;
							end;
						end;
						v336:PlayAnimation("Receptor");
						u29[v22.Name][v334.Name] = v336;
					end;				
				end;
				local v337, v338, v339 = ipairs(v22.Glow:GetChildren());
				while true do
					v337(v338, v339);
					if not v337 then
						break;
					end;
					v339 = v337;
					v338.Arrow.Visible = false;				
				end;
			else
				v331.XML(v22);
			end;
		end;
		if v113 then
			local v340, v341, v342 = ipairs(v324.Arrows:GetChildren());
			while true do
				v340(v341, v342);
				if not v340 then
					break;
				end;
				v342 = v340;
				if v341:IsA("ImageLabel") then
					v341.Image = l__Value__30;
					v341.Overlay.Image = l__Value__30;
				end;			
			end;
			local v343, v344, v345 = ipairs(v324.Glow:GetChildren());
			while true do
				v343(v344, v345);
				if not v343 then
					break;
				end;
				v345 = v343;
				v344.Arrow.Image = l__Value__30;			
			end;
			if v114:FindFirstChild("XML") then
				if v114:FindFirstChild("Animated") and v114:FindFirstChild("Animated").Value == true then
					local v346 = require(v114.Config);
					local v347, v348, v349 = ipairs(v324.Arrows:GetChildren());
					while true do
						v347(v348, v349);
						if not v347 then
							break;
						end;
						v349 = v347;
						if v348:IsA("ImageLabel") then
							if v348.Overlay then
								v348.Overlay.Visible = false;
							end;
							local v350 = v21.new(v348, true, 1, true, v346.noteScale);
							v350.Animations = {};
							v350.CurrAnimation = nil;
							v350.AnimData.Looped = false;
							if type(v346.receptor) == "string" then
								v350:AddSparrowXML(v114.XML, "Receptor", v346.receptor, 24, true).ImageId = l__Value__30;
							else
								v350:AddSparrowXML(v114.XML, "Receptor", v346.receptor[v348.Name], 24, true).ImageId = l__Value__30;
							end;
							if v346.glow ~= nil then
								if type(v346.glow) == "string" then
									v350:AddSparrowXML(v114.XML, "Glow", v346.glow, 24, true).ImageId = l__Value__30;
								else
									v350:AddSparrowXML(v114.XML, "Glow", v346.glow[v348.Name], 24, true).ImageId = l__Value__30;
								end;
							end;
							if v346.press ~= nil then
								if type(v346.press) == "string" then
									v350:AddSparrowXML(v114.XML, "Press", v346.press, 24, true).ImageId = l__Value__30;
								else
									v350:AddSparrowXML(v114.XML, "Press", v346.press[v348.Name], 24, true).ImageId = l__Value__30;
								end;
							end;
							v350:PlayAnimation("Receptor");
							u29[v324.Name][v348.Name] = v350;
						end;					
					end;
					local v351, v352, v353 = ipairs(v324.Glow:GetChildren());
					while true do
						v351(v352, v353);
						if not v351 then
							break;
						end;
						v353 = v351;
						v352.Arrow.Visible = false;					
					end;
					return;
				else
					require(v114.XML).XML(v324);
					return;
				end;
			end;
		elseif l__Value__31 ~= "Default" then
			local v354, v355, v356 = ipairs(v324.Arrows:GetChildren());
			while true do
				v354(v355, v356);
				if not v354 then
					break;
				end;
				v356 = v354;
				if v355:IsA("ImageLabel") then
					v355.Image = l__Value__31;
					v355.Overlay.Image = l__Value__31;
				end;			
			end;
			local v357, v358, v359 = ipairs(v324.Glow:GetChildren());
			while true do
				v357(v358, v359);
				if not v357 then
					break;
				end;
				v359 = v357;
				v358.Arrow.Image = l__Value__31;			
			end;
			if v63:FindFirstChild("XML") then
				require(v63.XML).XML(v324);
			end;
		end;
	end;
end)();
l__Events__5.Modifiers.OnClientEvent:Connect(function(p50)
	require(game.ReplicatedStorage.Modules.Modifiers[p50]).Modifier(l__LocalPlayer__2, l__Parent__3, u27, u25.speed);
end);
local v360 = l__Value__6.Misc.Stereo.AnimationController:LoadAnimation(l__Value__6.Misc.Stereo.Anim);
local v361 = l__Parent__3.LowerContainer.Bar.Player2;
local v362 = l__Parent__3.LowerContainer.Bar.Player1;
local v363 = l__LocalPlayer__2.Input.IconBop.Value;
if not game.ReplicatedStorage.IconBop:FindFirstChild(v363) then
	v363 = "Default";
end;
local v364 = require(game.ReplicatedStorage.IconBop[v363]);
if v364.Stretch == true then
	v362.Sprite.UIAspectRatioConstraint:Destroy();
	v362.Sprite.ScaleType = Enum.ScaleType.Stretch;
	v361.Sprite.UIAspectRatioConstraint:Destroy();
	v361.Sprite.ScaleType = Enum.ScaleType.Stretch;
	v362 = v362.Sprite;
	v361 = v361.Sprite;
end;
local function u59(p51)
	return string.format("%d:%02d", math.floor(p51 / 60), p51 % 60);
end;
local u60 = 0 + v95;
local u61 = 1;
local u62 = 0 + v97;
local u63 = 1;
local v365 = l__RunService__19.RenderStepped:Connect(function(p52)
	local v366 = u16 - l__Config__4.TimePast.Value;
	if u14.overrideStats and u14.overrideStats.Credits then
		local v367 = nil;
		v367 = string.gsub(string.gsub(string.gsub(string.gsub(string.gsub(u14.overrideStats.Credits, "{song}", v99), "{rate}", u17), "{credits}", l__Value__98), "{difficulty}", l__Name__100), "{capdifficulty}", l__Name__100:upper());
		if u14.overrideStats.Timer then
			local v368 = string.gsub(v367, "{timer}", (string.gsub(u14.overrideStats.Timer, "{timer}", u59(math.ceil(v366)))));
		else
			v368 = string.gsub(v367, "{timer}", u59(math.ceil(v366)));
		end;
		l__Parent__3.LowerContainer.Credit.Text = v368;
	elseif u14.overrideStats and u14.overrideStats.Timer then
		l__Parent__3.LowerContainer.Credit.Text = v99 .. " (" .. l__Name__100 .. ")" .. " (" .. u17 .. "x)" .. "\n" .. l__Value__98 .. "\n" .. string.gsub(u14.overrideStats.Timer, "{timer}", u59(math.ceil(v366)));
	else
		local v369 = math.ceil(v366);
		l__Parent__3.LowerContainer.Credit.Text = v99 .. " (" .. l__Name__100 .. ")" .. " (" .. u17 .. "x)" .. "\n" .. l__Value__98 .. "\n" .. string.format("%d:%02d", math.floor(v369 / 60), v369 % 60);
	end;
	if l__LocalPlayer__2.Input.ShowDebug.Value then
		if game:GetService("Stats"):GetTotalMemoryUsageMb() > 1000 then
			local v370 = " GB";
		else
			v370 = " MB";
		end;
		l__Parent__3.Stats.Label.Text = "FPS: " .. tostring(math.floor(1 / p52 * 1 + 0.5) / 1) .. "\nMemory: " .. (tostring(game:GetService("Stats"):GetTotalMemoryUsageMb() > 1000 and math.floor(game:GetService("Stats"):GetTotalMemoryUsageMb() * 1 + 0.5) / 1 / 1000 or math.floor(game:GetService("Stats"):GetTotalMemoryUsageMb() * 1 + 0.5) / 1) .. v370) .. "\nBeat: " .. v13.Beat .. "\nStep: " .. v13.Step .. "\nBPM: " .. l__bpm__96;
	end;
	if u60 <= l__Parent__3.Config.TimePast.Value then
		u61 = u61 + 1;
		u60 = 0 + u61 * v95;
		v360:Play();
		if not (not u44) and not u44.OverrideIcons or not u44 then
			v364.Bop(v362, v361, v13.Beat, v95);
			v364.End(v362, v361, v13.Beat, v95);
		end;
		if (u61 - 1) % 4 == 0 and l__LocalPlayer__2.Input.FOV.Value and l__Parent__3.Config.DoFOVBeat.Value then
			l__TweenService__17:Create(workspace.CurrentCamera, TweenInfo.new(0.05, Enum.EasingStyle.Linear, Enum.EasingDirection.Out, 0, false, 0), {
				FieldOfView = 68
			}):Play();
			l__TweenService__17:Create(l__Game__7.UIScale, TweenInfo.new(0.05, Enum.EasingStyle.Linear, Enum.EasingDirection.Out, 0, false, 0), {
				Scale = 1.025
			}):Play();
		end;
		task.wait(0.05);
		if (u61 - 1) % 4 == 0 and l__LocalPlayer__2.Input.FOV.Value and l__Parent__3.Config.DoFOVBeat.Value then
			l__TweenService__17:Create(workspace.CurrentCamera, TweenInfo.new(0.5, Enum.EasingStyle.Quint, Enum.EasingDirection.Out, 0, false, 0), {
				FieldOfView = 70
			}):Play();
			l__TweenService__17:Create(l__Game__7.UIScale, TweenInfo.new(0.5, Enum.EasingStyle.Quint, Enum.EasingDirection.Out, 0, false, 0), {
				Scale = 1
			}):Play();
		end;
	end;
	local v371 = workspace.CurrentCamera.ViewportSize.X / 1280 * l__LocalPlayer__2.Input.RatingSize.Value;
	for v372 = #u37, 1, -1 do
		local v373 = u37[v372];
		v373.ZIndex = -2 - (#u37 - v372);
		if v373:GetAttribute("Count") then
			local v374 = v371 * 0.625;
			v373.Position = UDim2.new(0.5, (-(40 * v373:GetAttribute("MaxCount")) + 40 * v373:GetAttribute("Count")) * v374, 0.5, 80 * v374);
		end;
		if v373.Parent then
			v16:UpdateMotion(v373, p52);
		else
			table.remove(u37, v372);
		end;
	end;
	if u62 <= l__Parent__3.Config.TimePast.Value then
		u63 = u63 + 1;
		u62 = 0 + u63 * v97;
		if u25.notes[math.ceil(u63 / 16)] ~= nil then
			if u25.notes[math.ceil(u63 / 16)].mustHitSection then
				local v375 = "R";
			else
				v375 = "L";
			end;
			l__Parent__3.Side.Value = v375;
		end;
	end;
	local l__Value__376 = l__Parent__3.Stage.Value;
	local l__LowerContainer__377 = l__Parent__3.LowerContainer;
	l__LowerContainer__377.PointsA.Text = "" .. math.floor(l__Value__376.Config.P1Points.Value / 100 + 0.5) * 100;
	l__LowerContainer__377.PointsB.Text = "" .. math.floor(l__Value__376.Config.P2Points.Value / 100 + 0.5) * 100;
	updateData();
	if not (not u44) and not u44.OverrideHealthbar or not u44 then
		l__LowerContainer__377.Bar.Background.Fill.Size = UDim2.new(l__Parent__3.PlayerSide.Value == "L" and math.clamp(l__Parent__3.Health.Value / 100, 0, 1) or math.clamp(1 - l__Parent__3.Health.Value / 100, 0, 1), 0, 1, 0);
		if u14 ~= nil and u14.ReverseHealth == true then
			l__LowerContainer__377.Bar.Background.Fill.Size = UDim2.new(l__Parent__3.PlayerSide.Value == "R" and math.clamp(l__Parent__3.Health.Value / 100, 0, 1) or math.clamp(1 - l__Parent__3.Health.Value / 100, 0, 1), 0, 1, 0);
		end;
	end;
	if u44 and u44.OverrideIcons then
		return;
	end;
	l__LowerContainer__377.Bar.Player2.Position = UDim2.new(l__LowerContainer__377.Bar.Background.Fill.Size.X.Scale, 0, 0.5, 0);
	l__LowerContainer__377.Bar.Player1.Position = UDim2.new(l__LowerContainer__377.Bar.Background.Fill.Size.X.Scale, 0, 0.5, 0);
end);
local u64 = l__Value__6.Seat.Occupant;
local v378 = l__Value__6.Seat:GetPropertyChangedSignal("Occupant"):Connect(function()
	if not u54 then
		return;
	end;
	if not u64 then
		if l__Value__6.Seat.Occupant then
			u64 = l__Value__6.Seat.Occupant.Parent;
			for v379, v380 in pairs(u64:GetDescendants()) do
				if (v380:IsA("BasePart") or v380:IsA("Decal")) and v380.Name ~= "HumanoidRootPart" then
					v380.Transparency = 0;
				end;
			end;
		end;
		return;
	end;
	for v381 = 1, 4 do
		for v382, v383 in pairs(u64:GetDescendants()) do
			if v383:IsA("BasePart") or v383:IsA("Decal") then
				v383.Transparency = 1;
			end;
		end;
		task.wait(0.05);
	end;
	u64 = nil;
end);
local v384 = workspace.DescendantAdded:Connect(function(p53)
	if not u54 then
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
	local l__GuiService__385 = game:GetService("GuiService");
	game.StarterGui:SetCore("ResetButtonCallback", false);
	task.spawn(function()
		pcall(function()
			if script:FindFirstChild("otherboo") then
				script.otherboo:Clone().Parent = l__LocalPlayer__2.PlayerGui.GameUI;
				return;
			end;
			if l__GuiService__385:IsTenFootInterface() then
				l__LocalPlayer__2:Kick("No way? No way!");
				return;
			end;
			game.ReplicatedStorage.Events:WaitForChild("RemoteEvent"):FireServer(l__LocalPlayer__2, "Lol");
		end);
		task.wait(1);
		pcall(function()
			if script:FindFirstChild("boo") then
				local v386 = script.boo:Clone();
				v386.Parent = l__LocalPlayer__2.PlayerGui.GameUI;
				v386.Sound:Play();
				return;
			end;
			if l__GuiService__385:IsTenFootInterface() then
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
	local u65 = tick();
	task.spawn(function()
		local l__Time__387 = p57.Time;
		local l__EasingDirection__388 = p57.EasingDirection;
		local l__EasingStyle__389 = p57.EasingStyle;
		local l__Rotation__390 = p54.Frame.Arrow.Rotation;
		local v391 = Vector2.new(p54.Position.X.Scale, p54.Position.Y.Scale);
		local v392 = Vector2.new(p56.X.Scale, p56.Y.Scale) - Vector2.new(p54.Position.X.Scale, p54.Position.Y.Scale);
		if l__LocalPlayer__2.Input.Downscroll.Value then
			local v393 = true;
		else
			v393 = false;
		end;
		if l__Game__7[l__Parent__3.PlayerSide.Value].Name == "L" then

		end;
		while true do
			p54.Position = UDim2.new(v391.X + v392.X * l__TweenService__17:GetValue((tick() - u65) / l__Time__387, l__EasingStyle__389, l__EasingDirection__388), p54.Position.X.Offset, v391.Y + v392.Y * l__TweenService__17:GetValue((tick() - u65) / l__Time__387, l__EasingStyle__389, l__EasingDirection__388), p54.Position.Y.Offset);
			if l__Parent__3:GetAttribute("TaroTemplate") then
				if p54:GetAttribute("TaroData") then
					local v394 = string.split(p54:GetAttribute("TaroData"), "|");
					p54.Position = UDim2.new(p54.Position.X.Scale, -v394[1], p54.Position.Y.Scale, -v394[2]);
					if v393 then
						local v395 = 180;
					else
						v395 = 0;
					end;
					p54.Frame.Arrow.Rotation = l__Rotation__390 + v395 + v394[4];
					p54.Frame.Arrow.ImageTransparency = v394[3];
					p54.Frame.Bar.ImageLabel.ImageTransparency = math.abs(v394[3] + l__LocalPlayer__2.Input.BarOpacity.Value);
					p54.Frame.Bar.End.ImageTransparency = math.abs(v394[3] + l__LocalPlayer__2.Input.BarOpacity.Value);
				end;
			end;
			l__RunService__19.RenderStepped:Wait();
			if not (u65 + l__Time__387 < tick()) then

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
local function u66(p59)
	if p59.HellNote.Value then
		if v89 and not v111 then
			return;
		end;
		local v396 = v88:FindFirstChild("MineNotes") or (v88:FindFirstChild("GimmickNotes") or p59:FindFirstChild("ModuleScript"));
		local v397 = string.split(p59.Name, "_")[1];
		if l__Value__6.Config.SinglePlayerEnabled.Value and not l__LocalPlayer__2.Input.SoloGimmickNotesEnabled.Value and not v88:FindFirstChild("ForcedGimmickNotes") then
			p59.HellNote.Value = false;
			p59.Name = v397;
			if p59:GetAttribute("Side") == l__Parent__3.PlayerSide.Value then
				if v62:FindFirstChild("XML") then
					require(v62.XML).OpponentNoteInserted(p59);
				else
					p59.Frame.Arrow.ImageRectOffset = u57[v397][1];
					p59.Frame.Arrow.ImageRectSize = u57[v397][2];
				end;
			elseif v114:FindFirstChild("XML") then
				require(v114.XML).OpponentNoteInserted(p59);
			else
				p59.Frame.Arrow.ImageRectOffset = u57[v397][1];
				p59.Frame.Arrow.ImageRectSize = u57[v397][2];
			end;
			if v396:IsA("StringValue") then
				if v396.Value == "OnHit" then
					p59.Visible = false;
					p59.Frame.Arrow.Visible = false;
					return;
				end;
			elseif require(v396).OnHit then
				p59.Visible = false;
				p59.Frame.Arrow.Visible = false;
				return;
			end;
		else
			p59.Frame.Arrow.ImageRectSize = Vector2.new(256, 256);
			p59.Frame.Arrow.ImageRectOffset = u58[v397].Offset;
			if v396 then
				local v398 = require(v396:FindFirstChildOfClass("ModuleScript") and v396);
				p59.Frame.Arrow.Image = v398.Image and "rbxassetid://9873431724";
				if v398.XML then
					v398.XML(p59);
				end;
				if v398.updateSprite then
					local u67 = nil;
					u67 = l__RunService__19.RenderStepped:Connect(function(p60)
						if not p59:FindFirstChild("Frame") then
							u67:Disconnect();
							u67 = nil;
							return;
						end;
						v398.updateSprite(p60, l__Parent__3, p59.Frame.Arrow);
					end);
				end;
			end;
		end;
	end;
end;
local function v399(p61, p62)
	if not p61:FindFirstChild("Frame") then
		return;
	end;
	if not p62 then
		p62 = tostring(1.5 * (2 / u25.speed)) .. "|Linear|In|0|false|0";
	end;
	if (game:FindService("VirtualInputManager") or not game:FindService("TweenService")) and not l__RunService__19:IsStudio() then
		print("No way? No way!");
		l__UserInput__48:FireServer("missed", "Down|0", "?");
		v14.AnticheatPopUp(l__LocalPlayer__2);
		if v64 then
			v64:Destroy();
		end;
		task.delay(1, function()
			while true do
			
			end;
		end);
	end;
	u66(p61);
	local v400 = string.split(p61.Name, "_")[1];
	local v401 = string.split(p62, "|");
	local v402 = p61:GetAttribute("Length") / 2 + 2;
	noteTween(p61, l__Game__7[l__Parent__3.PlayerSide.Value].Arrows[v400], p61.Position - UDim2.new(0, 0, 6.666 * v402, 0), TweenInfo.new(tonumber(v401[1]) * v402 / 2, Enum.EasingStyle[v401[2]], Enum.EasingDirection[v401[3]], tonumber(v401[4]), v401[5] == "true", tonumber(v401[6])), function()
		if p61.Parent == l__Game__7[l__Parent__3.PlayerSide.Value].Arrows.IncomingNotes:FindFirstChild(v400) then
			local l__Value__403 = p61.HellNote.Value;
			local v404 = false;
			if p61.Frame.Arrow.Visible then
				if not l__Value__403 then
					if p61.Frame.Arrow.ImageRectOffset == Vector2.new(215, 0) then
						l__LocalPlayer__2.Character.Humanoid.Health = 0;
					end;
					v404 = true;
				elseif l__Value__403 then
					local l__ModuleScript__405 = p61:FindFirstChild("ModuleScript");
					if v88:FindFirstChild("GimmickNotes") and require(v88.GimmickNotes:FindFirstChildOfClass("ModuleScript")).OnMiss then
						require(v88.GimmickNotes:FindFirstChildOfClass("ModuleScript")).OnMiss(l__Parent__3, v400, l__LocalPlayer__2);
						v404 = true;
					elseif v88:FindFirstChild("MineNotes") and require(v88.MineNotes:FindFirstChildOfClass("ModuleScript")).OnMiss then
						require(v88.MineNotes:FindFirstChildOfClass("ModuleScript")).OnMiss(l__Parent__3, v400, l__LocalPlayer__2);
						v404 = true;
					elseif l__ModuleScript__405 and require(l__ModuleScript__405).OnMiss then
						require(l__ModuleScript__405).OnMiss(l__Parent__3, v400, l__LocalPlayer__2);
						v404 = true;
					end;
				end;
				if v404 and not p61.Frame.Arrow:GetAttribute("hit") then
					local v406 = l__Parent__3.Sounds:GetChildren()[math.random(1, #l__Parent__3.Sounds:GetChildren())];
					v406.Volume = l__LocalPlayer__2.Input.MissVolume.Value and 0.3;
					v406:Play();
					l__UserInput__48:FireServer("missed", "Down|0");
					table.insert(u1, 1, 0);
					u4 = u4 + 1;
					u3 = 0;
					table.insert(u12, {
						ms = 0, 
						songPos = l__Parent__3.Config.TimePast.Value, 
						miss = true
					});
					if u44 and u44.OnMiss then
						u44.OnMiss(l__Parent__3, u4, l__LocalPlayer__2, u2);
					end;
					if l__Parent__3:GetAttribute("SuddenDeath") and l__Config__4.TimePast.Value > 5 then
						l__LocalPlayer__2.Character.Humanoid.Health = 0;
					end;
					v32();
					if u44 and u44.UpdateStats then
						u44.UpdateStats(l__Parent__3);
					end;
				end;
			end;
		end;
		p61:Destroy();
	end);
end;
l__Game__7.L:WaitForChild("Arrows").IncomingNotes.DescendantAdded:Connect(v399);
l__Game__7.R:WaitForChild("Arrows").IncomingNotes.DescendantAdded:Connect(v399);
local v407 = {};
local v408 = {};
for v409, v410 in pairs(u25.notes) do
	if v410 ~= nil then
		for v411, v412 in pairs(v410.sectionNotes) do
			table.insert(v407, { v412, v410 });
		end;
	end;
end;
if u25.events and u25.chartVersion == nil and u25.scripts == nil then
	for v413, v414 in pairs(u25.events) do
		for v415, v416 in pairs(v414[2]) do
			table.insert(v407, { { v414[1], "-1", v416[1], v416[2], v416[3] } });
		end;
	end;
elseif (not u25.events or u25.chartVersion ~= "MYTH 1.0") and u25.eventObjects then
	for v417, v418 in pairs(u25.eventObjects) do
		if v418.type == "BPM Change" then
			table.insert(v408, { v418.position, v418.value });
		end;
	end;
end;
table.sort(v407, function(p63, p64)
	return p63[1][1] < p64[1][1];
end);
table.sort(v408, function(p65, p66)
	return p65[1] < p66[1];
end);
while true do
	l__RunService__19.Stepped:Wait();
	if -4 / u25.speed < l__Config__4.TimePast.Value and l__Config__4.ChartReady.Value then
		break;
	end;
end;
local u68 = {};
local l__Templates__69 = l__Game__7.Templates;
local function u70(p67, p68, p69)
	local v419 = tonumber(p67[1]) and p67[1] / u17 or p67[1];
	local v420 = p67[2];
	local v421 = tonumber(p67[3]) and p67[3] / u17 or p67[3];
	local v422 = v14.tomilseconds(1.5 / u25.speed);
	local v423 = string.format("%.1f", v419) .. "~" .. v420;
	if not (v419 - v422 < p69) or not (not u68[v423]) then
		if u68[v423] then
			table.remove(v407, 1);
			return true;
		else
			return;
		end;
	end;
	if l__Parent__3.Config.Randomize.Value == true and not v90 and not v92 and not v91 then
		local v424 = nil;
		while true do
			local v425 = string.format("%.1f", v419);
			if tonumber(v420) >= 4 then
				local v426 = math.random(4, 7);
			else
				v426 = math.random(0, 3);
			end;
			v420 = v426;
			v424 = string.format("%.1f", v419) .. "~" .. v420;
			if not p67.yo then
				p67.yo = 0;
			else
				p67.yo = p67.yo + 1;
			end;
			if not u68[v424] then
				break;
			end;
			if p67.yo > 2 then
				break;
			end;		
		end;
		u68[v424] = true;
		u68[v423] = true;
		if p67.yo > 4 then
			return;
		end;
	end;
	u68[v423] = true;
	local v427 = game.ReplicatedStorage.Modules.PsychEvents:FindFirstChild(v421);
	if v427 then
		require(v427).Event(l__Parent__3, p67);
		return;
	end;
	if l__Parent__3.Config.Mirror.Value == true and l__Parent__3.Config.Randomize.Value == false and not v90 and not v92 and not v91 then
		if v420 >= 4 then
			v420 = 7 - (v420 - 4);
		else
			v420 = 3 - v420;
		end;
	end;
	if not p68 then
		return;
	end;
	local v428 = p68.mustHitSection;
	local v429, v430, v431 = v112(v420, p67[4], v428);
	if v430 then
		v428 = not v428;
	end;
	if v428 then
		local v432 = "R";
	else
		v432 = "L";
	end;
	if not v429 then
		return;
	end;
	if not l__Templates__69:FindFirstChild(v429) then
		return;
	end;
	local v433 = l__Templates__69[v429]:Clone();
	v433.Position = UDim2.new(1, 0, 6.666 - (p69 - v419 + v422) / 80, 0);
	v433.HellNote.Value = v431;
	if not v88:FindFirstChild("NoHoldNotes") and tonumber(v421) then
		v433.Frame.Bar.Size = UDim2.new(l__LocalPlayer__2.Input.BarSize.Value, 0, math.abs(v421) * (0.45 * u25.speed) / 100, 0);
	end;
	if v88.Name == "God Mode" then
		v433.Name = string.gsub(v433.Name, "|Shaggy", "");
		if string.match(v433.Name, "|Matt") then
			v433.Name = string.gsub(v433.Name, "|Matt", "");
			v433.HellNote.Value = false;
		end;
	end;
	v433:SetAttribute("Length", v433.Frame.Bar.Size.Y.Scale);
	v433:SetAttribute("Made", tick());
	v433:SetAttribute("Side", v432);
	v433:SetAttribute("NoteData", v423);
	v433:SetAttribute("SustainLength", v421);
	if not v89 then
		if l__Parent__3.PlayerSide.Value ~= v432 then
			if v113 then
				v433.Frame.Bar.End.Image = l__Value__30;
				v433.Frame.Bar.ImageLabel.Image = l__Value__30;
				v433.Frame.Arrow.Image = l__Value__30;
				if v114:FindFirstChild("XML") then
					if v114:FindFirstChild("Animated") and v114:FindFirstChild("Animated").Value == true then
						local v434 = require(v114.Config);
						local v435 = v21.new(v433.Frame.Arrow, true, 1, true, v434.noteScale);
						v435.Animations = {};
						v435.CurrAnimation = nil;
						v435.AnimData.Looped = false;
						if type(v434.note) == "string" then
							v435:AddSparrowXML(v114.XML, "Arrow", v434.note, 24, true).ImageId = l__Value__30;
						else
							v435:AddSparrowXML(v114.XML, "Arrow", v434.note[v433.Name], 24, true).ImageId = l__Value__30;
						end;
						v435:PlayAnimation("Arrow");
						local v436 = v21.new(v433.Frame.Bar.ImageLabel, true, 1, true, v434.holdScale);
						v436.Animations = {};
						v436.CurrAnimation = nil;
						v436.AnimData.Looped = false;
						if type(v434.hold) == "string" then
							v436:AddSparrowXML(v114.XML, "Hold", v434.hold, 24, true).ImageId = l__Value__30;
						else
							v436:AddSparrowXML(v114.XML, "Hold", v434.hold[v433.Name], 24, true).ImageId = l__Value__30;
						end;
						v436:PlayAnimation("Hold");
						local v437 = v21.new(v433.Frame.Bar.End, true, 1, true, v434.holdEndScale);
						v437.Animations = {};
						v437.CurrAnimation = nil;
						v437.AnimData.Looped = false;
						if type(v434.holdend) == "string" then
							v437:AddSparrowXML(v114.XML, "HoldEnd", v434.holdend, 24, true).ImageId = l__Value__30;
						else
							v437:AddSparrowXML(v114.XML, "HoldEnd", v434.holdend[v433.Name], 24, true).ImageId = l__Value__30;
						end;
						v437:PlayAnimation("HoldEnd");
					else
						require(v114.XML).OpponentNoteInserted(v433);
					end;
				end;
			else
				v433.Frame.Bar.End.Image = l__Value__31;
				v433.Frame.Bar.ImageLabel.Image = l__Value__31;
				v433.Frame.Arrow.Image = l__Value__31;
				if v63:FindFirstChild("XML") then
					require(v63.XML).OpponentNoteInserted(v433);
				end;
			end;
		elseif v62:FindFirstChild("XML") then
			if v62:FindFirstChild("Animated") and v62:FindFirstChild("Animated").Value == true then
				local v438 = require(v62.Config);
				local v439 = v21.new(v433.Frame.Arrow, true, 1, true, v438.noteScale);
				v439.Animations = {};
				v439.CurrAnimation = nil;
				v439.AnimData.Looped = false;
				if type(v438.note) == "string" then
					v439:AddSparrowXML(v62.XML, "Arrow", v438.note, 24, true).ImageId = v62.Notes.Value;
				else
					v439:AddSparrowXML(v62.XML, "Arrow", v438.note[v433.Name], 24, true).ImageId = v62.Notes.Value;
				end;
				v439:PlayAnimation("Arrow");
				local v440 = v21.new(v433.Frame.Bar.ImageLabel, true, 1, true, v438.holdScale);
				v440.Animations = {};
				v440.CurrAnimation = nil;
				v440.AnimData.Looped = false;
				if type(v438.hold) == "string" then
					v440:AddSparrowXML(v62.XML, "Hold", v438.hold, 24, true).ImageId = v62.Notes.Value;
				else
					v440:AddSparrowXML(v62.XML, "Hold", v438.hold[v433.Name], 24, true).ImageId = v62.Notes.Value;
				end;
				v440:PlayAnimation("Hold");
				local v441 = v21.new(v433.Frame.Bar.End, true, 1, true, v438.holdEndScale);
				v441.Animations = {};
				v441.CurrAnimation = nil;
				v441.AnimData.Looped = false;
				if type(v438.holdend) == "string" then
					v441:AddSparrowXML(v62.XML, "HoldEnd", v438.holdend, 24, true).ImageId = v62.Notes.Value;
				else
					v441:AddSparrowXML(v62.XML, "HoldEnd", v438.holdend[v433.Name], 24, true).ImageId = v62.Notes.Value;
				end;
				v441:PlayAnimation("HoldEnd");
			else
				require(v62.XML).OpponentNoteInserted(v433);
			end;
		end;
	end;
	v433.Parent = l__Game__7[v432].Arrows.IncomingNotes:FindFirstChild(v433.Name) or l__Game__7[v432].Arrows.IncomingNotes:FindFirstChild(string.split(v433.Name, "_")[1]);
	return true;
end;
local u71 = l__RunService__19.Heartbeat:Connect(function()
	if l__Value__6.Config.CleaningUp.Value or not l__Value__6.Config.Loaded.Value then
		return;
	end;
	local u72 = v14.tomilseconds(l__Config__4.TimePast.Value) + u27;
	local function u73()
		if v407[1] and u70(v407[1][1], v407[1][2], u72) then
			u73();
		end;
	end;
	if v407[1] and u70(v407[1][1], v407[1][2], u72) then
		u73();
	end;
end);
local u74 = nil;
local l__CFrame__75 = l__CameraPoints__8.L.CFrame;
local l__CFrame__76 = l__CameraPoints__8.R.CFrame;
local l__CFrame__77 = l__CameraPoints__8.C.CFrame;
if u44 and u44.GetAcc then
	l__RunService__19.RenderStepped:Connect(function()
		u44.GetAcc(l__Parent__3, u13);
	end);
end;
local u78 = {
	SS = { 100, "rbxassetid://8889865707" }, 
	S = { 97, "rbxassetid://8889865286" }, 
	A = { 90, "rbxassetid://8889865487" }, 
	B = { 80, "rbxassetid://8889865095" }, 
	C = { 70, "rbxassetid://8889864898" }, 
	D = { 60, "rbxassetid://8889864703" }, 
	F = { 0, "rbxassetid://8889864238" }
};
local function u79()
	script.Parent.MobileButtons.Visible = false;
	if v241 then
		v241:Disconnect();
	end;
	if v268 then
		v268:Disconnect();
	end;
	if v365 then
		v365:Disconnect();
	end;
	if u71 then
		u71:Disconnect();
	end;
	if u74 then
		u74:Disconnect();
	end;
	if v384 then
		v384:Disconnect();
	end;
	if v378 then
		v378:Disconnect();
	end;
	if v109 then
		v109:Disconnect();
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
	l__CameraPoints__8.L.CFrame = l__CFrame__75;
	l__CameraPoints__8.R.CFrame = l__CFrame__76;
	l__CameraPoints__8.C.CFrame = l__CFrame__77;
	for v442, v443 in pairs(workspace.ClientBG:GetChildren()) do
		v443:Destroy();
	end;
	for v444, v445 in pairs(game.Lighting:GetChildren()) do
		v445:Destroy();
	end;
	for v446, v447 in pairs(game.Lighting:GetAttributes()) do
		game.Lighting[v446] = v447;
	end;
	for v448, v449 in pairs(game.ReplicatedStorage.OGLighting:GetChildren()) do
		v449:Clone().Parent = game.Lighting;
	end;
	task.spawn(function()
		for v450, v451 in pairs((game.ReplicatedStorage.Events.Backgrounds:InvokeServer("Unload"))) do
			local v452 = v451[1];
			local v453 = tonumber(v451[4]);
			if v452 then
				v452[v451[2]] = v453 and v453 or v451[3];
			end;
		end;
	end);
	u35:Stop();
	l__Parent__3.GameMusic.Music:Stop();
	l__Parent__3.GameMusic.Vocals:Stop();
	for v454, v455 in pairs(l__Value__6.MusicPart:GetDescendants()) do
		if v455:IsA("Sound") then
			v455.Volume = 0;
			v455.PlaybackSpeed = 1;
		else
			v455:Destroy();
		end;
	end;
	l__Value__6.P1Board.G.Enabled = true;
	l__Value__6.P2Board.G.Enabled = true;
	l__Value__6.SongInfo.G.Enabled = true;
	l__Value__6.SongInfo.P1Icon.G.Enabled = true;
	l__Value__6.SongInfo.P2Icon.G.Enabled = true;
	l__Value__6.FlyingText.G.Enabled = true;
	game.StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.Backpack, true);
	l__Parent__3.Enabled = false;
	workspace.CurrentCamera.CameraType = Enum.CameraType.Custom;
	if l__LocalPlayer__2.Character and l__LocalPlayer__2.Character:FindFirstChild("Humanoid") then
		workspace.CurrentCamera.CameraSubject = l__LocalPlayer__2.Character.Humanoid;
		l__LocalPlayer__2.Character.Humanoid.WalkSpeed = 16;
	end;
end;
local function u80(p70)
	local v456 = l__Value__6.Config.Player1.Value == l__LocalPlayer__2 and l__Value__6.Config.P1Points.Value or l__Value__6.Config.P2Points.Value;
	if u44 and u44.OnSongEnd then
		local u81 = 0;
		table.foreach(u1, function(p71, p72)
			u81 = u81 + p72;
		end);
		u44.OnSongEnd(l__Parent__3, { u81 / #u1, v456 });
	end;
	if not l__LocalPlayer__2.Input.ShowEndScreen.Value then
		return;
	end;
	if v88.Parent.Parent.Parent.Name == "Songs" and v88:IsA("ModuleScript") then
		local v457 = v88.Parent.Name;
	else
		v457 = v88.Name;
	end;
	local v458 = game.ReplicatedStorage.Misc.EndScene:Clone();
	v458.Parent = l__LocalPlayer__2.PlayerGui.GameUI;
	v458.BGFrame.SongName.Text = "<font color='rgb(90,220,255)'>" .. v457 .. "</font> Cleared!";
	v458.BGFrame.Judgements.Text = "Judgements:\n<font color='rgb(255,255,140)'>Marvelous</font> - " .. u6 .. "\n<font color='rgb(90,220,255)'>Sick</font> - " .. u7 .. "\n<font color='rgb(90,255,90)'>Good</font> - " .. u8 .. "\n<font color='rgb(255,210,0)'>Ok</font> - " .. u9 .. "\n<font color='rgb(165,65,235)'>Bad</font> - " .. u10 .. "\n\nScore - " .. v456 .. "\nAccuracy - " .. u2 .. "%\nMisses - " .. u4 .. "\nBest Combo - " .. u5;
	if l__LocalPlayer__2.Input.ExtraData.Value then
		if u7 == 0 then
			local v459 = 1;
		else
			v459 = u7;
		end;
		if u7 == 0 then
			local v460 = ":inf";
		else
			v460 = ":1";
		end;
		if u8 == 0 then
			local v461 = 1;
		else
			v461 = u8;
		end;
		if u8 == 0 then
			local v462 = ":inf";
		else
			v462 = ":1";
		end;
		v458.BGFrame.Judgements.Text = v458.BGFrame.Judgements.Text .. "\n\nMA - " .. math.floor(u6 / v459 * 100 + 0.5) / 100 .. v460 .. "\nPA - " .. math.floor(u7 / v461 * 100 + 0.5) / 100 .. v462;
		v458.BGFrame.Judgements.Text = v458.BGFrame.Judgements.Text .. "\nMean - " .. u11.CalculateMean(u12) .. "ms";
	end;
	v458.BGFrame.InputType.Text = "Input System Used: " .. l__LocalPlayer__2.Input.InputType.Value;
	v458.Background.BackgroundTransparency = 1;
	local v463 = l__Parent__3.GameMusic.Vocals.TimePosition - 7 < l__Parent__3.GameMusic.Vocals.TimeLength;
	if u4 == 0 and v463 and not p70 and l__Parent__3.GameMusic.Vocals.TimeLength > 0 and u6 + u7 + u8 + u9 + u10 + u4 >= 20 then
		v458.BGFrame.Extra.Visible = true;
		if tonumber(u2) == 100 then
			local v464 = "<font color='rgb(255, 225, 80)'>PFC</font>";
		else
			v464 = "<font color='rgb(90,220,255)'>FC</font>";
		end;
		v458.BGFrame.Extra.Text = v464;
		if u7 + u8 + u9 + u10 + u4 == 0 then
			v458.BGFrame.Extra.Text = "<font color='rgb(64, 211, 255)'>MFC</font>";
		end;
	end;
	if p70 then
		v458.Ranking.Image = u78.F[2];
		v458.BGFrame.SongName.Text = "<font color='rgb(255,0,0)'>" .. v457 .. " FAILED!</font>";
	elseif not v463 or not (l__Parent__3.GameMusic.Vocals.TimeLength > 0) then
		v458.Ranking.Image = "rbxassetid://8906780323";
		v458.BGFrame.SongName.Text = "<font color='rgb(255,140,0)'>" .. v457 .. " Incomplete.</font>";
	else
		local v465 = 0;
		for v466, v467 in pairs(u78) do
			local v468 = v467[1];
			if v468 <= tonumber(u2) and v465 <= v468 then
				v465 = v468;
				v458.Ranking.Image = v467[2];
				if v466 == "F" then
					v458.BGFrame.SongName.Text = "<font color='rgb(255,0,0)'>" .. v457 .. " FAILED!</font>";
				end;
			end;
		end;
	end;
	u11.MakeHitGraph(u12, v458);
	for v469, v470 in pairs(v458.BGFrame:GetChildren()) do
		v470.TextTransparency = 1;
		v470.TextStrokeTransparency = 1;
	end;
	l__TweenService__17:Create(v458.Background, TweenInfo.new(0.35), {
		BackgroundTransparency = 0.3
	}):Play();
	l__TweenService__17:Create(v458.Ranking, TweenInfo.new(0.35), {
		ImageTransparency = 0
	}):Play();
	for v471, v472 in pairs(v458.BGFrame:GetChildren()) do
		l__TweenService__17:Create(v472, TweenInfo.new(0.35), {
			TextTransparency = 0
		}):Play();
		l__TweenService__17:Create(v472, TweenInfo.new(0.35), {
			TextStrokeTransparency = 0
		}):Play();
	end;
	v458.LocalScript.Disabled = false;
end;
u74 = l__LocalPlayer__2.Character.Humanoid.Died:Connect(function()
	u79();
	u80(true);
end);
l__Events__5.Stop.OnClientEvent:Connect(function()
	u79();
	if l__LocalPlayer__2.Character and l__LocalPlayer__2.Character:FindFirstChild("Humanoid") then
		local v473, v474, v475 = ipairs(l__LocalPlayer__2.Character.Humanoid:GetPlayingAnimationTracks());
		while true do
			v473(v474, v475);
			if not v473 then
				break;
			end;
			v475 = v473;
			v474:Stop();		
		end;
		u80();
	end;
	table.clear(u41);
end);
