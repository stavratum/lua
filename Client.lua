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
local l__TweenService__16 = game:GetService("TweenService");
local l__UserInputService__17 = game:GetService("UserInputService");
local l__RunService__18 = game:GetService("RunService");
local v19 = require(game.ReplicatedStorage.Modules.DebugLog);
local v20 = require(game.ReplicatedStorage.Modules.Sprites.Sprite);
local v21 = l__Game__7:FindFirstChild(l__Parent__3.PlayerSide.Value);
l__Value__6.P1Board.G.Enabled = false;
l__Value__6.P2Board.G.Enabled = false;
l__Value__6.SongInfo.G.Enabled = false;
l__Value__6.SongInfo.P1Icon.G.Enabled = false;
l__Value__6.SongInfo.P2Icon.G.Enabled = false;
l__Value__6.FlyingText.G.Enabled = false;
l__Config__4.TimePast.Value = -40;
for v22, v23 in pairs(l__CameraPoints__8:GetChildren()) do
	v23.CFrame = v23.OriginalCFrame.Value;
end;
for v24, v25 in pairs({ l__Game__7.R, l__Game__7.L }) do
	game.ReplicatedStorage.Misc.SplashContainer:Clone().Parent = v25;
end;
local v26 = l__LocalPlayer__2.PlayerGui.GameUI:WaitForChild("SongSelect", 10);
local l__EndScene__27 = l__LocalPlayer__2.PlayerGui.GameUI:FindFirstChild("EndScene");
if l__EndScene__27 then
	l__EndScene__27:Destroy();
end;
if not v26 then
	warn("Infinite yield possible on song select menu. Please report this to a dev!");
	v26 = l__LocalPlayer__2.PlayerGui.GameUI:WaitForChild("SongSelect");
end;
v26.StatsContainer.FCs.Text = "<font color='rgb(90,220,255)'>FCs</font>: " .. l__LocalPlayer__2.Input.Achievements.FCs.Value .. " | <font color='rgb(255, 225, 80)'>PFCs</font>: " .. l__LocalPlayer__2.Input.Achievements.PFCs.Value;
function updateData()
	local v28 = 1 - 1;
	while true do
		if l__Value__6.Config["P" .. v28 .. "Stats"].Value ~= "" then
			local v29 = game.HttpService:JSONDecode(l__Value__6.Config["P" .. v28 .. "Stats"].Value);
			if v28 == 1 then
				local v30 = "L";
			else
				v30 = "R";
			end;
			l__Game__7:FindFirstChild(v30).OpponentStats.Label.Text = "Accuracy: " .. v29.accuracy .. "% | Combo: " .. v29.combo .. " | Misses: " .. v29.misses;
			l__Value__6.Config["P" .. v28 .. "Stats"].Value = "";
		end;
		if 0 <= 1 then
			if v28 < 2 then

			else
				break;
			end;
		elseif 2 < v28 then

		else
			break;
		end;
		v28 = v28 + 1;	
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
local u13 = nil;
local function v31()
	local v32 = l__Parent__3.LowerContainer.Stats.Label;
	l__Parent__3.LowerContainer.Bar.Visible = l__LocalPlayer__2.Input.HealthBar.Value;
	local u14 = 0;
	table.foreach(u1, function(p1, p2)
		u14 = u14 + p2;
	end);
	local v33 = 100;
	if u14 == 0 and #u1 == 0 then
		local v34 = "Accuracy: 100%";
	else
		u2 = string.sub(tostring(u14 / #u1), 1, 5);
		v34 = "Accuracy: " .. u2 .. "%";
		v33 = u2;
	end;
	local v35 = v34 .. " | Combo: " .. u3 .. " | Misses: " .. u4;
	v32.Text = v35;
	if l__LocalPlayer__2.Input.VerticalBar.Value then
		v32 = l__Parent__3.SideContainer.Accuracy;
		v32.Text = string.gsub(v35, " | ", "\n");
	end;
	if u5 < u3 then
		u5 = u3;
	end;
	l__Parent__3.SideContainer.Data.Text = "Marvelous: " .. u6 .. "\nSick: " .. u7 .. "\nGood: " .. u8 .. "\nOk: " .. u9 .. "\nBad: " .. u10;
	local l__Extra__36 = l__Parent__3.SideContainer.Extra;
	if u7 == 0 then
		local v37 = 1;
	else
		v37 = u7;
	end;
	if u7 == 0 then
		local v38 = ":inf";
	else
		v38 = ":1";
	end;
	if u8 == 0 then
		local v39 = 1;
	else
		v39 = u8;
	end;
	if u8 == 0 then
		local v40 = ":inf";
	else
		v40 = ":1";
	end;
	l__Extra__36.Text = "MA: " .. math.floor(u6 / v37 * 100 + 0.5) / 100 .. v38 .. "\nPA: " .. math.floor(u7 / v39 * 100 + 0.5) / 100 .. v40;
	l__Extra__36.Text = l__Extra__36.Text .. "\nMean: " .. u11.CalculateMean(u12) .. "ms";
	l__Events__5.UpdateData:FireServer({
		accuracy = v33, 
		combo = u3, 
		misses = u4, 
		bot = false
	});
	if u13 ~= nil and u13.overrideStats then
		if u13.overrideStats.Value then
			local v41 = string.gsub(string.gsub(string.gsub(u13.overrideStats.Value, "{misses}", u4), "{combo}", u3), "{accuracy}", v33 .. "%%");
		else
			v41 = v32.Text;
		end;
		if u13.overrideStats.ShadowValue then
			local v42 = string.gsub(string.gsub(string.gsub(u13.overrideStats.ShadowValue, "{misses}", u4), "{combo}", u3), "{accuracy}", v33 .. "%%");
		else
			v42 = v32.Text;
		end;
		if u13.overrideStats.ChildrenToUpdate then
			l__Parent__3.SideContainer.Accuracy.Visible = false;
			local l__Label__43 = l__Parent__3.LowerContainer.Stats.Label;
			local v44, v45, v46 = pairs(u13.overrideStats.ChildrenToUpdate);
			while true do
				local v47 = nil;
				local v48, v49 = v44(v45, v46);
				if not v48 then
					break;
				end;
				v46 = v48;
				v47 = l__Parent__3.LowerContainer.Stats[v49];
				if v49:lower():match("shadow") then
					v47.Text = v42;
				else
					v47.Text = v41;
				end;			
			end;
		elseif l__LocalPlayer__2.Input.VerticalBar.Value then
			v32.Text = string.gsub(v41, " | ", "\n");
		else
			v32.Text = v41;
		end;
	end;
end;
v31();
local l__Value__15 = l__Config__4.PlaybackSpeed.Value;
l__Events__5.Start.OnClientEvent:Connect(function(p3, p4, p5)
	local v50 = 1 / p4;
	local v51 = p5:FindFirstChild("Modchart") and (p5.Modchart:IsA("ModuleScript") and require(p5.Modchart));
	if v51 and v51.PreStart then
		v51.PreStart(l__Parent__3, v50);
	end;
	local v52 = {};
	if p5:FindFirstChild("Countdown") and game.ReplicatedStorage.Countdowns:FindFirstChild(p5.Countdown.Value) then
		local v53 = require(game.ReplicatedStorage.Countdowns:FindFirstChild(p5.Countdown.Value).Config);
		if v53.Audio ~= nil then
			l__Value__6.MusicPart["3"].SoundId = v53.Audio["3"];
			l__Value__6.MusicPart["2"].SoundId = v53.Audio["2"];
			l__Value__6.MusicPart["1"].SoundId = v53.Audio["1"];
			l__Value__6.MusicPart.Go.SoundId = v53.Audio.Go;
		end;
		v52 = v53.Images;
	end;
	if p5:FindFirstChild("ExtraCountdownTime") then
		task.wait(p5.ExtraCountdownTime.Value);
	end;
	local l__Music__16 = l__Parent__3.GameMusic.Music;
	local l__Vocals__17 = l__Parent__3.GameMusic.Vocals;
	task.spawn(function()
		if p5:FindFirstChild("NoCountdown") then
			task.wait(v50 * 3);
			l__Value__6.MusicPart["3"].Volume = 0;
			l__Value__6.MusicPart.Go.Volume = 0;
			l__Value__6.MusicPart["3"]:Play();
			l__Value__6.MusicPart.Go:Play();
			task.wait(v50);
			l__Music__16.Playing = true;
			l__Vocals__17.Playing = true;
			return;
		end;
		l__Value__6.MusicPart["3"]:Play();
		local u18 = v52;
		local u19 = "3";
		local u20 = v50;
		task.spawn(function()
			if u18 == nil or u18[u19] == nil then
				return;
			end;
			local v54 = l__Parent__3.Countdown.Countdown:Clone();
			v54.Name = u19;
			v54.Image = u18[u19];
			v54.Visible = true;
			v54.Parent = l__Parent__3.Countdown;
			l__TweenService__16:Create(v54, TweenInfo.new(u20, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut), {
				ImageTransparency = 1
			}):Play();
			task.wait(u20 * 1.2);
			v54:Destroy();
		end);
		u20 = task.wait;
		u18 = v50;
		u20(u18);
		u20 = v50;
		u18 = v52;
		u19 = l__Value__6;
		u19.MusicPart["2"]:Play();
		u19 = "2";
		task.spawn(function()
			if u18 == nil or u18[u19] == nil then
				return;
			end;
			local v55 = l__Parent__3.Countdown.Countdown:Clone();
			v55.Name = u19;
			v55.Image = u18[u19];
			v55.Visible = true;
			v55.Parent = l__Parent__3.Countdown;
			l__TweenService__16:Create(v55, TweenInfo.new(u20, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut), {
				ImageTransparency = 1
			}):Play();
			task.wait(u20 * 1.2);
			v55:Destroy();
		end);
		u20 = task.wait;
		u18 = v50;
		u20(u18);
		u20 = v50;
		u18 = v52;
		u19 = l__Value__6;
		u19.MusicPart["1"]:Play();
		u19 = "1";
		task.spawn(function()
			if u18 == nil or u18[u19] == nil then
				return;
			end;
			local v56 = l__Parent__3.Countdown.Countdown:Clone();
			v56.Name = u19;
			v56.Image = u18[u19];
			v56.Visible = true;
			v56.Parent = l__Parent__3.Countdown;
			l__TweenService__16:Create(v56, TweenInfo.new(u20, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut), {
				ImageTransparency = 1
			}):Play();
			task.wait(u20 * 1.2);
			v56:Destroy();
		end);
		u20 = task.wait;
		u18 = v50;
		u20(u18);
		u20 = v50;
		u18 = v52;
		u19 = l__Value__6;
		u19.MusicPart.Go:Play();
		u19 = "Go";
		task.spawn(function()
			if u18 == nil or u18[u19] == nil then
				return;
			end;
			local v57 = l__Parent__3.Countdown.Countdown:Clone();
			v57.Name = u19;
			v57.Image = u18[u19];
			v57.Visible = true;
			v57.Parent = l__Parent__3.Countdown;
			l__TweenService__16:Create(v57, TweenInfo.new(u20, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut), {
				ImageTransparency = 1
			}):Play();
			task.wait(u20 * 1.2);
			v57:Destroy();
		end);
		u20 = task.wait;
		u18 = v50;
		u20(u18);
		u20 = l__Music__16;
		u18 = true;
		u20.Playing = u18;
		u20 = l__Vocals__17;
		u18 = true;
		u20.Playing = u18;
	end);
	for v58, v59 in pairs(l__Value__6.MusicPart:GetChildren()) do
		if v59:IsA("Sound") and v59.Name ~= "SERVERmusic" and v59.Name ~= "SERVERvocals" then
			v59.Volume = 0.5;
		end;
	end;
	l__Config__4.TimePast.Value = -4 / p4;
	l__TweenService__16:Create(l__Config__4.TimePast, TweenInfo.new(p3 + 4 / p4, Enum.EasingStyle.Linear, Enum.EasingDirection.In, 0, false, 0), {
		Value = p3
	}):Play();
	if p5:FindFirstChild("Instrumental") then
		l__Music__16.Volume = p5.Instrumental.Volume.Value;
	end;
	if p5:FindFirstChild("Sound") then
		l__Vocals__17.Volume = p5.Sound.Volume.Value;
	end;
	l__Music__16.PitchEffect.Enabled = false;
	l__Vocals__17.PitchEffect.Enabled = false;
	if p5:FindFirstChild("Instrumental") then
		l__Music__16.SoundId = p5.Instrumental.Value;
		l__Music__16.PlaybackSpeed = p5.Instrumental.PlaybackSpeed.Value;
	end;
	if p5:FindFirstChild("Sound") then
		l__Vocals__17.SoundId = p5.Sound.Value;
		l__Vocals__17.PlaybackSpeed = p5.Sound.PlaybackSpeed.Value;
	end;
	if l__Value__15 ~= 1 then
		l__Music__16.PlaybackSpeed = l__Music__16.PlaybackSpeed * l__Value__15;
		l__Vocals__17.PlaybackSpeed = l__Vocals__17.PlaybackSpeed * l__Value__15;
		if l__LocalPlayer__2.Input.DisablePitch.Value then
			l__Music__16.PitchEffect.Enabled = true;
			l__Vocals__17.PitchEffect.Enabled = true;
			l__Music__16.PitchEffect.Octave = 1 / l__Value__15;
			l__Vocals__17.PitchEffect.Octave = 1 / l__Value__15;
		end;
	end;
	l__Music__16.TimePosition = 0;
	l__Vocals__17.TimePosition = 0;
end);
local v60 = game.ReplicatedStorage.Skins:FindFirstChild(l__LocalPlayer__2.Input.Skin.Value) or game.ReplicatedStorage.Skins.Default;
local v61 = Instance.new("BlurEffect");
v61.Parent = game.Lighting;
v61.Size = 0;
for v62, v63 in pairs(v26.Modifiers:GetDescendants()) do
	if v63:IsA("ImageButton") then
		v63.ImageColor3 = Color3.fromRGB(136, 136, 136);
		local u21 = false;
		v63.MouseButton1Click:Connect(function()
			u21 = not u21;
			l__TweenService__16:Create(v63, TweenInfo.new(0.4), {
				ImageColor3 = u21 and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(136, 136, 136)
			}):Play();
			if v63:FindFirstChild("misc") then
				l__TweenService__16:Create(v63.misc, TweenInfo.new(0.4), {
					ImageColor3 = u21 and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(136, 136, 136)
				}):Play();
			end;
			l__Events__5.Modifiers:FireServer(v63.Name);
		end);
		v63.MouseEnter:Connect(function()
			v63.ZIndex = 2;
			local v64 = script.ModifierLabel:Clone();
			v64.Parent = v63;
			v64.Text = "  " .. string.gsub(v63.Info.Value, "|", "\n") .. "  ";
			v64.Size = UDim2.new();
			l__TweenService__16:Create(v64, TweenInfo.new(0.125), {
				Size = v64.Size
			}):Play();
		end);
		v63.MouseLeave:Connect(function()
			while v63:FindFirstChild("ModifierLabel") do
				v63.ZIndex = 1;
				local l__ModifierLabel__65 = v63:FindFirstChild("ModifierLabel");
				if l__ModifierLabel__65 then
					l__TweenService__16:Create(l__ModifierLabel__65, TweenInfo.new(0.125, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
						Size = UDim2.new()
					}):Play();
					task.wait(0.125);
					l__ModifierLabel__65:Destroy();
				end;			
			end;
		end);
	end;
end;
function nowPlaying(p6, p7)
	local v66 = game.ReplicatedStorage.Misc.NowPlaying:Clone();
	v66.Parent = p6;
	v66.Position = v66.Position - UDim2.fromScale(0.2, 0);
	v66.Color.BackgroundColor3 = Color3.new(1, 0.75, 0);
	v66.SongName.TextColor3 = Color3.new(1, 0.75, 0);
	v66.SongName.Text = p7;
	v66.ZIndex = 99999;
	game.TweenService:Create(v66, TweenInfo.new(1), {
		Position = v66.Position + UDim2.fromScale(0.2, 0)
	}):Play();
	task.wait(5.5);
	local v67 = game.TweenService:Create(v66, TweenInfo.new(1.5, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
		Position = v66.Position - UDim2.fromScale(0.2, 0)
	});
	v67:Play();
	v67.Completed:Connect(function()
		v66:Destroy();
	end);
end;
local l__ModifierMultiplier__68 = l__Parent__3:WaitForChild("ModifierMultiplier");
v26.Modifiers.Multiplier.Text = "1x";
v26.Modifiers.Multiplier.TextColor3 = Color3.new(1, 1, 1);
l__ModifierMultiplier__68.Changed:Connect(function()
	if l__ModifierMultiplier__68.Value > 1 then
		local v69 = Color3.fromRGB(255, 255, 0);
	elseif l__ModifierMultiplier__68.Value < 1 then
		v69 = Color3.fromRGB(255, 64, 30);
	else
		v69 = Color3.fromRGB(255, 255, 255);
	end;
	v14.AnimateMultiplier(l__Parent__3, v26.Modifiers.Multiplier, v69);
	v26.Modifiers.Multiplier.Text = l__ModifierMultiplier__68.Value .. "x";
end);
local v70 = l__Parent__3.SelectionMusic:GetChildren();
local v71 = v70[math.random(1, #v70)];
v71.Volume = 0;
v71:Play();
l__TweenService__16:Create(v71, TweenInfo.new(4, Enum.EasingStyle.Quint, Enum.EasingDirection.In), {
	Volume = v71.Volume
}):Play();
l__TweenService__16:Create(workspace.CurrentCamera, TweenInfo.new(1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
	FieldOfView = 35
}):Play();
l__TweenService__16:Create(v61, TweenInfo.new(1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
	Size = 25
}):Play();
v26.Visible = true;
if l__LocalPlayer__2.Input.StreamerMode.Value == true then
	if not string.find(v71.Name, "FNF") then
		v71.PlaybackSpeed = v71.PlaybackSpeed - 0.35;
		local v72 = Instance.new("EqualizerSoundEffect");
		v72.LowGain = 20;
		v72.Parent = v71;
	end;
else
	v71.PlaybackSpeed = v71.PlaybackSpeed;
	if v71:FindFirstChildOfClass("EqualizerSoundEffect") then
		v71:FindFirstChildOfClass("EqualizerSoundEffect"):Destroy();
	end;
end;
task.delay(2.5, function()
	nowPlaying(l__Parent__3, v71.Name);
end);
v26.TimeLeft.Text = "Time Left: 15";
local u22 = nil;
u22 = l__Value__6.Config.SelectTimeLeft.Changed:Connect(function()
	if not l__Parent__3.Parent then
		u22:Disconnect();
		return;
	end;
	v26.TimeLeft.Text = "Time Left: " .. l__Value__6.Config.SelectTimeLeft.Value;
end);
l__Value__6.Events.LoadPlayer.OnClientInvoke = function(p8, p9)
	l__Parent__3.Loading.Visible = true;
	l__TweenService__16:Create(workspace.CurrentCamera, TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
		FieldOfView = 68
	}):Play();
	game.ContentProvider:PreloadAsync({ p8, p9 });
	local l__Music__73 = l__Parent__3.GameMusic.Music;
	local l__Vocals__74 = l__Parent__3.GameMusic.Vocals;
	if p8.SoundId ~= "" then
		l__Music__73.SoundId = p8.SoundId;
		while true do
			task.wait();
			if l__Music__73.TimeLength > 0 then
				break;
			end;		
		end;
	end;
	if p9.SoundId ~= "" then
		l__Vocals__74.SoundId = p9.SoundId;
		while true do
			task.wait();
			if l__Vocals__74.TimeLength > 0 then
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
local v75 = game.ReplicatedStorage.Events.PlayerSongVote.Event:Connect(function(p10, p11, p12)
	if not p10 or not p11 or not p12 then
		return;
	end;
	l__Value__6.Events.PlayerSongVote:FireServer(p10, p11, p12);
end);
for v76, v77 in pairs(l__LocalPlayer__2.PlayerGui.GameUI:GetChildren()) do
	if not string.match(v77.Name, "SongSelect") then
		v77.Visible = false;
	end;
end;
v26:SetAttribute("2v2", nil);
for v78, v79 in pairs(v26.SongScroller:GetChildren()) do
	if v79:GetAttribute("2V2") then
		v79.Visible = false;
	end;
end;
for v80, v81 in pairs(v26.BasicallyNil:GetChildren()) do
	if v81:GetAttribute("2V2") then
		v81.Visible = false;
	end;
end;
v26.Background.Fill.OpponentSelect.Visible = true;
v26.Background.Fill["Player 1Select"].Visible = false;
v26.Background.Fill["Player 2Select"].Visible = false;
v26.Background.Fill["Player 3Select"].Visible = false;
v26.Background.Fill["Player 4Select"].Visible = false;
while true do
	v14.wait();
	if l__Value__6.Config.Song.Value then
		break;
	end;
end;
local v82 = l__TweenService__16:Create(v61, TweenInfo.new(1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
	Size = 0
});
v82:Play();
v82.Completed:Connect(function()
	v61:Destroy();
end);
local v83 = l__TweenService__16:Create(v71, TweenInfo.new(2, Enum.EasingStyle.Quint, Enum.EasingDirection.In), {
	Volume = 0
});
v83:Play();
v83.Completed:Connect(function()
	v71:Stop();
end);
local v84 = l__Value__6.Config.Song.Value:IsA("StringValue") and l__Value__6.Config.Song.Value.Value or require(l__Value__6.Config.Song.Value);
local v85 = l__Value__6.Config.Song.Value:FindFirstAncestorOfClass("StringValue") or l__Value__6.Config.Song.Value;
if v85.Parent.Parent.Parent.Name == "Songs" and not v85:FindFirstChild("Sound") then
	v85 = v85.Parent;
end;
local v86, v87, v88, v89 = v14.SpecialSongCheck(v85);
v26.Visible = false;
v75:Disconnect();
workspace.CurrentCamera.CameraType = Enum.CameraType.Scriptable;
workspace.CurrentCamera.CFrame = l__Value__6.CameraPoints.C.CFrame;
task.spawn(function()
	l__Value__6.MusicPart.Go.Played:Wait();
	v14.NowPlaying(l__Parent__3, v85, l__LocalPlayer__2);
	task.wait(1);
	game.StarterGui:SetCore("ResetButtonCallback", true);
end);
require(l__Parent__3.Modules.Icons).SetIcons(l__Parent__3, v85);
local u23 = v84;
local v90, v91 = pcall(function()
	u23 = game.HttpService:JSONDecode(u23).song;
end);
if v91 then
	u23 = game.HttpService:JSONDecode(require(game.ReplicatedStorage.Songs["/v/-tan"].Sage.Hard)).song;
end;
u23.bpm = u23.bpm * l__Value__15;
local v92 = 60 / (u23.bpm or 120 * l__Value__15);
local l__bpm__93 = u23.bpm;
local v94 = v92 / 4;
local l__Value__95 = v85.Credits.Value;
if v85.Parent.Parent.Parent.Name == "Songs" then
	local v96 = v85:IsA("ModuleScript") and v85.Parent.Name or v85.Name;
else
	v96 = v85.Name;
end;
local l__Name__97 = l__Value__6.Config.Song.Value.Name;
local v98 = math.ceil((l__Value__6.MusicPart.SERVERvocals.TimeLength - l__Value__6.MusicPart.SERVERvocals.TimePosition) / l__Value__6.MusicPart.SERVERvocals.PlaybackSpeed);
l__Parent__3.LowerContainer.Credit.Text = v96 .. " (" .. l__Name__97 .. ")" .. " (" .. l__Value__15 .. "x)" .. "\n" .. l__Value__95 .. "\n" .. string.format("%d:%02d", math.floor(v98 / 60), v98 % 60);
if v85:FindFirstChild("MobileButtons") then
	l__Parent__3.MobileButtons:Destroy();
	v85.MobileButtons:Clone().Parent = l__Parent__3;
end;
if v85:FindFirstChild("Countdown") and game.ReplicatedStorage.Countdowns:FindFirstChild(v85.Countdown.Value) then
	local v99 = require(game.ReplicatedStorage.Countdowns:FindFirstChild(v85.Countdown.Value).Config);
	local v100 = {};
	if v99.Images ~= nil then
		for v101, v102 in pairs(v99.Images) do
			table.insert(v100, v102);
		end;
	end;
	if v99.Audio ~= nil then
		for v103, v104 in pairs(v99.Audio) do
			table.insert(v100, v104);
		end;
	end;
	game.ContentProvider:PreloadAsync(v100);
end;
local v105 = v14.ModchartCheck(l__Parent__3, v85, u23);
local v106 = v13.Start(l__Parent__3, v85:FindFirstChild("Modchart"), l__bpm__93, v105);
local v107 = require(l__Parent__3.Modules.Functions);
v107.keyCheck(v85, v88, v87, v89);
local v108 = nil;
if v85:FindFirstChild("notetypeconvert") then
	v108 = require(v85.notetypeconvert);
end;
v107.stuffCheck(v85);
local v109 = v85:FindFirstChild("notetypeconvert") and v108.notetypeconvert or v107.notetypeconvert;
if v108 and v108.newKeys then
	v108.newKeys(l__Parent__3);
	v86 = true;
end;
local v110 = nil;
if not l__Value__6.Config.SinglePlayerEnabled.Value then
	if l__Value__6.Config.Player1.Value == l__LocalPlayer__2 then
		v110 = l__Value__6.Config.Player2.Value;
	else
		v110 = l__Value__6.Config.Player1.Value;
	end;
end;
if v110 then
	local v111 = game.ReplicatedStorage.Skins:FindFirstChild(v110.Input.Skin.Value) or game.ReplicatedStorage.Skins.Default;
else
	v111 = game.ReplicatedStorage.Skins.Default;
end;
l__Game__7.L.Arrows.IncomingNotes.DescendantAdded:Connect(function(p13)
	if not (l__Game__7.Rotation >= 90) then
		return;
	end;
	if v85:FindFirstChild("NoSettings") then
		return;
	end;
	if p13:IsA("Frame") and p13:FindFirstChild("Frame") then
		p13.Rotation = 180;
		p13.Frame.Rotation = 180;
		p13.Frame.Arrow.Rotation = 180;
	end;
end);
l__Game__7.R.Arrows.IncomingNotes.DescendantAdded:Connect(function(p14)
	if not (l__Game__7.Rotation >= 90) then
		return;
	end;
	if v85:FindFirstChild("NoSettings") then
		return;
	end;
	if p14:IsA("Frame") and p14:FindFirstChild("Frame") then
		p14.Rotation = 180;
		p14.Frame.Rotation = 180;
		p14.Frame.Arrow.Rotation = 180;
	end;
end);
function ChangeUI(p15)
	if p15 ~= nil then
		local v112 = game.ReplicatedStorage.UIStyles[p15];
		u13 = require(v112.Config);
		l__Parent__3.LowerContainer.Bar:Destroy();
		local v113 = v112.Bar:Clone();
		v113.Parent = l__Parent__3.LowerContainer;
		if u13.HealthBarColors then
			v113.Background.BackgroundColor3 = u13.HealthBarColors.Green or Color3.fromRGB(114, 255, 63);
			v113.Background.Fill.BackgroundColor3 = u13.HealthBarColors.Red or Color3.fromRGB(255, 0, 0);
		end;
		if u13.ShowIcons then
			v113.Player1.Sprite.Visible = u13.ShowIcons.Dad;
			v113.Player2.Sprite.Visible = u13.ShowIcons.BF;
		end;
		if v112:FindFirstChild("Stats") then
			l__Parent__3.LowerContainer.Stats:Destroy();
			v112.Stats:Clone().Parent = l__Parent__3.LowerContainer;
		end;
		if u13.isPixel then
			l__Parent__3.LowerContainer.PointsA.Font = Enum.Font.Arcade;
			l__Parent__3.LowerContainer.PointsB.Font = Enum.Font.Arcade;
		else
			l__Parent__3.LowerContainer.PointsA.Font = Enum.Font.GothamBold;
			l__Parent__3.LowerContainer.PointsB.Font = Enum.Font.GothamBold;
		end;
		if u13.overrideStats then
			if u13.overrideStats.Timer then
				l__Parent__3.LowerContainer.Credit.Text = v96 .. " (" .. l__Name__97 .. ")" .. " (" .. l__Value__15 .. "x)" .. "\n" .. l__Value__95 .. "\n" .. u13.overrideStats.Timer;
			end;
		end;
	else
		local l__Default__114 = game.ReplicatedStorage.UIStyles.Default;
		u13 = require(l__Default__114.Config);
		l__Parent__3.LowerContainer.Bar:Destroy();
		l__Parent__3.LowerContainer.Stats:Destroy();
		l__Default__114.Bar:Clone().Parent = l__Parent__3.LowerContainer;
		l__Default__114.Stats:Clone().Parent = l__Parent__3.LowerContainer;
		l__Parent__3.LowerContainer.PointsA.Font = Enum.Font.GothamBold;
		l__Parent__3.LowerContainer.PointsB.Font = Enum.Font.GothamBold;
	end;
	v31();
	require(l__Parent__3.Modules.Icons).SetIcons(l__Parent__3, v85);
	updateUI();
end;
local u24 = {};
function updateUI(p16)
	if v21.Name == "L" then
		local v115 = "R";
	else
		v115 = "L";
	end;
	local v116 = l__Game__7:FindFirstChild(v115);
	if l__LocalPlayer__2.Input.VerticalBar.Value then
		l__Parent__3.LowerContainer.Stats.Visible = false;
		l__Parent__3.SideContainer.Accuracy.Visible = true;
	end;
	l__Parent__3.Stats.Visible = l__LocalPlayer__2.Input.ShowDebug.Value;
	l__Parent__3.SideContainer.Data.Visible = l__LocalPlayer__2.Input.JudgementCounter.Value;
	l__Parent__3.SideContainer.Extra.Visible = l__LocalPlayer__2.Input.ExtraData.Value;
	if l__LocalPlayer__2.Input.ShowOpponentStats.Value then
		if l__LocalPlayer__2.Input.Middlescroll.Value then
			v116.OpponentStats.Visible = l__LocalPlayer__2.Input.ShowOtherMS.Value;
		else
			v116.OpponentStats.Visible = l__LocalPlayer__2.Input.ShowOpponentStats.Value;
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
	local v117, v118, v119 = pairs(l__Game__7.Templates:GetChildren());
	while true do
		local v120, v121 = v117(v118, v119);
		if v120 then

		else
			break;
		end;
		v119 = v120;
		v121.Frame.Bar.End.ImageTransparency = l__LocalPlayer__2.Input.BarOpacity.Value;
		v121.Frame.Bar.ImageLabel.ImageTransparency = l__LocalPlayer__2.Input.BarOpacity.Value;	
	end;
	if not v85:FindFirstChild("NoSettings") then
		if u13 ~= nil then
			if u13.overrideStats then
				if u13.overrideStats.Position then
					if u13.overrideStats.Position.Upscroll then
						l__Parent__3.LowerContainer.Stats.Position = u13.overrideStats.Position.Upscroll;
					end;
				end;
			end;
		end;
		if l__LocalPlayer__2.Input.VerticalBar.Value then
			local l__Size__122 = l__Parent__3.LowerContainer.Bar.Size;
			l__Parent__3.LowerContainer.Bar.Position = UDim2.new(1.1, 0, -4, 0);
			l__Parent__3.LowerContainer.Bar.Size = UDim2.new(l__Size__122.X.Scale * 0.8, l__Size__122.X.Offset, l__Size__122.Y.Scale, l__Size__122.Y.Offset);
			l__Parent__3.LowerContainer.Bar.Rotation = 90;
			l__Parent__3.LowerContainer.Bar.Player1.Sprite.Rotation = -90;
			l__Parent__3.LowerContainer.Bar.Player2.Sprite.Rotation = -90;
		end;
		if l__LocalPlayer__2.Input.Downscroll.Value then
			local v123 = UDim2.new(0.5, 0, 8.9, 0);
			if u13 ~= nil then
				if u13.overrideStats then
					if u13.overrideStats.Position then
						if u13.overrideStats.Position.Downscroll then
							v123 = u13.overrideStats.Position.Downscroll;
						end;
					end;
				end;
			end;
			l__Game__7.Rotation = 180;
			l__Game__7.Position = UDim2.new(0.5, 0, 0.05, 0);
			l__Parent__3.LowerContainer.AnchorPoint = Vector2.new(0.5, 0);
			l__Parent__3.LowerContainer.Position = UDim2.new(0.5, 0, 0.1, 0);
			l__Parent__3.LowerContainer.Stats.Position = v123;
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
				local l__Size__124 = l__Parent__3.LowerContainer.Bar.Size;
				l__Parent__3.LowerContainer.Bar.Position = UDim2.new(1.1, 0, 4, 0);
				l__Parent__3.LowerContainer.Bar.Rotation = 90;
				l__Parent__3.LowerContainer.Bar.Player1.Sprite.Rotation = -90;
				l__Parent__3.LowerContainer.Bar.Player2.Sprite.Rotation = -90;
			end;
			if not v86 then
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
		elseif p16 == "Downscroll" then
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
				local l__Size__125 = l__Parent__3.LowerContainer.Bar.Size;
				l__Parent__3.LowerContainer.Bar.Position = UDim2.new(1.1, 0, -4, 0);
				l__Parent__3.LowerContainer.Bar.Rotation = 90;
				l__Parent__3.LowerContainer.Bar.Player1.Sprite.Rotation = -90;
				l__Parent__3.LowerContainer.Bar.Player2.Sprite.Rotation = -90;
			end;
			l__Game__7.L.Arrows.Rotation = 0;
			l__Game__7.R.Arrows.Rotation = 0;
			if not v86 then
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
			v116.Visible = l__LocalPlayer__2.Input.ShowOtherMS.Value;
			v21.Position = UDim2.new(0.5, 0, 0.5, 0);
			v21.AnchorPoint = Vector2.new(0.5, 0.5);
			if l__LocalPlayer__2.Input.ShowOtherMS.Value then
				v116.OpponentStats.Size = UDim2.new(2, 0, 0.05, 0);
				v116.OpponentStats.Position = UDim2.new(0.5, 0, -0.08, 0);
				v116.AnchorPoint = Vector2.new(0.1, 0);
				v116.Size = UDim2.new(0.15, 0, 0.3, 0);
				v116.Position = v116.Name == "R" and UDim2.new(0.88, 0, 0.5, 0) or UDim2.new(0, 0, 0.5, 0);
				if l__LocalPlayer__2.Input.Downscroll.Value then
					v116.Position = v116.Name == "L" and UDim2.new(0.88, 0, 0.5, 0) or UDim2.new(0, 0, 0.5, 0);
				end;
			end;
		elseif p16 == "Middlescroll" then
			v116.Visible = true;
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
	u24.Stats = l__Parent__3.LowerContainer.Stats.Size;
	local v126, v127, v128 = pairs(l__Parent__3.SideContainer:GetChildren());
	while true do
		local v129, v130 = v126(v127, v128);
		if v129 then

		else
			break;
		end;
		v128 = v129;
		if v130.ClassName == "TextLabel" then
			u24[v130.Name] = v130.Size;
		end;	
	end;
end;
l__Events__5.ChangeUI.Event:Connect(function(p17)
	ChangeUI(p17);
end);
local u25 = v85.Offset.Value + (l__LocalPlayer__2.Input.Offset.Value and 0);
local l__Value__26 = v60.Notes.Value;
local u27 = {
	L = {}, 
	R = {}
};
local l__Value__28 = v111.Notes.Value;
local v131 = require(game.ReplicatedStorage.Modules.Device);
local v132 = {
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
if not v88 then
	v132 = {
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
if v85:FindFirstChild(l__Parent__3.PlayerSide.Value .. "_Anims") then
	local v133 = v85[l__Parent__3.PlayerSide.Value .. "_Anims"].Value;
else
	v133 = game.ReplicatedStorage.Animations:FindFirstChild(l__LocalPlayer__2.Input.Animation.Value) or (v14.findAnim(l__LocalPlayer__2.Input.Animation.Value) or game.ReplicatedStorage.Animations.Default);
end;
local u29 = {};
local u30 = nil;
local l__Animations__31 = _G.Animations;
local u32 = nil;
v1 = function(p18, p19, p20)
	if l__Parent__3.PlayerSide.Value == "R" then
		p18 = p18.Mirrored;
	end;
	if p20 then
		local v134, v135, v136 = ipairs(p18:GetChildren());
		while true do
			v134(v135, v136);
			if not v134 then
				break;
			end;
			v136 = v134;
			if v135:IsA("Animation") then
				u29[v135.Name] = p19:LoadAnimation(v135);
			end;		
		end;
		u30 = u29.Idle;
		return;
	end;
	if not p19 then
		p19 = l__LocalPlayer__2.Character.Humanoid;
	end;
	local v137, v138, v139 = ipairs(p18:GetChildren());
	while true do
		v137(v138, v139);
		if not v137 then
			break;
		end;
		v139 = v137;
		if v138:IsA("Animation") then
			l__Animations__31[v138.Name] = p19:LoadAnimation(v138);
		end;	
	end;
	u32 = l__Animations__31.Idle;
end;
if v133:FindFirstChild("Custom") then
	v1(v133, l__LocalPlayer__2.Character:WaitForChild("customrig"):WaitForChild("rig"):WaitForChild("Humanoid"));
elseif v133:FindFirstChild("FBX") then
	v1(v133, l__LocalPlayer__2.Character:WaitForChild("customrig"):WaitForChild("rig"):WaitForChild("AnimationController"):WaitForChild("Animator"));
elseif v133:FindFirstChild("2Player") then
	v1(v133.Other, l__LocalPlayer__2.Character:WaitForChild("char2"):WaitForChild("Dummy"):WaitForChild("Humanoid"), true);
	v1(v133, l__LocalPlayer__2.Character.Humanoid);
elseif v133:FindFirstChild("Custom2Player") then
	v1(v133.Other, l__LocalPlayer__2.Character:WaitForChild("char2"):WaitForChild("Dummy"):WaitForChild("Humanoid"), true);
	v1(v133, l__LocalPlayer__2.Character:WaitForChild("customrig"):WaitForChild("rig"):WaitForChild("Humanoid"));
else
	v1(v133);
end;
if not tonumber(u23.speed) then
	u23.speed = 2.8;
end;
if u30 then
	u30:AdjustSpeed(u23.speed);
	u32:AdjustSpeed(u23.speed);
	u30.Looped = true;
	u32.Looped = true;
	u30.Priority = Enum.AnimationPriority.Idle;
	u32.Priority = Enum.AnimationPriority.Idle;
	u32:Play();
	u30:Play();
else
	u32:AdjustSpeed(u23.speed);
	u32.Looped = true;
	u32.Priority = Enum.AnimationPriority.Idle;
	u32:Play();
end;
local u33 = nil;
local u34 = nil;
local u35 = 0;
local u36 = {
	Left = false, 
	Down = false, 
	Up = false, 
	Right = false
};
local l__speed__140 = u23.speed;
u23.speed = l__LocalPlayer__2.Input.ScrollSpeedChange.Value and l__LocalPlayer__2.Input.ScrollSpeed.Value + 1.5 or (u23.speed or 3.3);
local v141 = 0.75 * u23.speed;
l__Config__4.MaxDist.Value = v141;
local v142 = Instance.new("Sound");
v142.Name = "HitSound";
v142.Parent = l__Parent__3;
v142.SoundId = "rbxassetid://" .. l__LocalPlayer__2.Input.HitSoundsValue.Value or "rbxassetid://3581383408";
v142.Volume = l__LocalPlayer__2.Input.HitSoundVolume.Value;
local u37 = {
	Left = false, 
	Down = false, 
	Up = false, 
	Right = false
};
local function u38(p21)
	local v143 = nil;
	local v144, v145, v146 = ipairs(v21.Arrows.IncomingNotes[p21]:GetChildren());
	while true do
		v144(v145, v146);
		if not v144 then
			break;
		end;
		v146 = v144;
		if (v145.Name == p21 or string.split(v145.Name, "_")[1] == p21) and (math.abs(string.split(v145:GetAttribute("NoteData"), "~")[1] - (v14.tomilseconds(l__Config__4.TimePast.Value) + u25)) <= v15.Ghost and v145.Frame.Arrow.Visible) then
			if not v143 then
				v143 = v145;
			elseif (v145.AbsolutePosition - v145.Parent.AbsolutePosition).magnitude <= (v143.AbsolutePosition - v145.Parent.AbsolutePosition).magnitude then
				v143 = v145;
			end;
		end;	
	end;
	if v143 then
		return;
	end;
	return true;
end;
local function u39(p22)
	local v147 = p22;
	if v86 then
		if v88 then
			if v147 == "A" or v147 == "H" then
				v147 = "Left";
			end;
			if v147 == "S" or v147 == "J" then
				v147 = "Down";
			end;
			if v147 == "D" or v147 == "K" then
				v147 = "Up";
			end;
			if v147 == "F" or v147 == "L" then
				v147 = "Right";
			end;
		elseif v87 or v89 then
			if v147 == "S" or v147 == "J" then
				v147 = "Left";
			end;
			if v147 == "D" then
				v147 = "Up";
			end;
			if v147 == "K" or v147 == "Space" then
				v147 = "Down";
			end;
			if v147 == "F" or v147 == "L" then
				v147 = "Right";
			end;
		elseif v108 and v108.getAnimationDirection then
			v147 = v108.getAnimationDirection(v147);
		end;
	end;
	if v133:FindFirstChild(v147) then
		if v21.Name == "L" then
			local v148 = v147;
			if not v148 then
				if v147 == "Right" then
					v148 = "Left";
				elseif v147 == "Left" then
					v148 = "Right";
				else
					v148 = v147;
				end;
			end;
		elseif v147 == "Right" then
			v148 = "Left";
		elseif v147 == "Left" then
			v148 = "Right";
		else
			v148 = v147;
		end;
		local v149 = v133[v148];
		local v150 = _G.Animations[v148];
		v150.Looped = false;
		v150.TimePosition = 0;
		v150.Priority = Enum.AnimationPriority.Movement;
		if u33 and u33 ~= v150 then
			u33:Stop(0);
		end;
		u33 = v150;
		local v151 = u29[v148];
		if v151 then
			local v152 = v133.Other[v148];
			v151.Looped = false;
			v151.TimePosition = 0;
			v151.Priority = Enum.AnimationPriority.Movement;
			if u34 and u34 ~= v151 then
				u34:Stop(0);
			end;
			u34 = v151;
		end;
		task.spawn(function()
			u35 = u35 + 1;
			while u36[p22] and u35 == u35 do
				v150:Play(0);
				if v151 then
					v151:Play(0);
				end;
				task.wait(0.1);			
			end;
			task.wait(v150.Length - 0.15);
			if u35 == u35 then
				v150:Stop(0);
				if l__Parent__3.Side.Value == l__Parent__3.PlayerSide.Value and l__LocalPlayer__2.Input.MoveOnHit.Value then
					local l__Value__153 = l__Parent__3.Side.Value;
					local v154 = workspace.ClientBG:FindFirstChildOfClass("Model");
					local v155 = v85:FindFirstChild("Modchart") and (v85.Modchart:IsA("ModuleScript") and (v105 and require(v85.Modchart)));
					if v155 and v155.CameraReset then
						v155.CameraReset();
					end;
					if v155 and v155.OverrideCamera then
						return;
					end;
					l__TweenService__16:Create(workspace.CurrentCamera, TweenInfo.new(l__LocalPlayer__2.Input.MoveSpeed.Value, v9, Enum.EasingDirection.Out), {
						CFrame = (v154 and v154:FindFirstChild("cameraPoints") and v154.cameraPoints:FindFirstChild(l__Value__153) or (l__Value__6.CameraPoints:FindFirstChild(l__Value__153) or l__Value__6.CameraPoints.C)).CFrame
					}):Play();
				end;
				if v151 then
					v151:Stop(0);
				end;
			end;
		end);
	end;
end;
local function u40(p23)
	if v86 and not v108 then
		return;
	end;
	if not l__LocalPlayer__2.Input.NoteSplashes.Value then
		return;
	end;
	if not game.ReplicatedStorage.Misc.Splashes:FindFirstChild(p23) then
		return;
	end;
	task.spawn(function()
		local v156 = game.ReplicatedStorage.Misc.Splashes[p23]:GetChildren();
		local v157 = v156[math.random(1, #v156)]:Clone();
		v157.Parent = v21.SplashContainer;
		v157.Position = v21.Arrows[p23].Position;
		v157.Image = (game.ReplicatedStorage.Splashes:FindFirstChild(l__LocalPlayer__2.Input.NoteSplashSkin.Value) or game.ReplicatedStorage.Splashes.Default).Splash.Value;
		v157.Size = UDim2.fromScale(l__LocalPlayer__2.Input.SplashSize.Value * v157.Size.X.Scale, l__LocalPlayer__2.Input.SplashSize.Value * v157.Size.Y.Scale);
		local l__X__158 = v157.ImageRectOffset.X;
		for v159 = 0, 8 do
			v157.ImageRectOffset = Vector2.new(l__X__158, v159 * 128);
			task.wait(0.035);
		end;
		v157:Destroy();
	end);
end;
local function u41(p24, p25)
	if not l__LocalPlayer__2.Input.MoveOnHit.Value then
		return;
	end;
	local l__Value__160 = l__Parent__3.Side.Value;
	local v161 = workspace.ClientBG:FindFirstChildOfClass("Model");
	local v162 = v85:FindFirstChild("Modchart") and (v85.Modchart:IsA("ModuleScript") and (v105 and require(v85.Modchart)));
	if v162 and v162.OverrideCamera then
		return;
	end;
	local v163 = v161 and v161:FindFirstChild("cameraPoints") and v161.cameraPoints:FindFirstChild(l__Value__160) or (l__Value__6.CameraPoints:FindFirstChild(l__Value__160) or l__Value__6.CameraPoints.C);
	if l__Parent__3.PlayerSide.Value == l__Parent__3.Side.Value and not p25 or l__Parent__3.PlayerSide.Value ~= l__Parent__3.Side.Value and p25 then
		if p24 == "Up" then
			l__TweenService__16:Create(workspace.CurrentCamera, TweenInfo.new(l__LocalPlayer__2.Input.MoveSpeed.Value, v9, Enum.EasingDirection.Out), {
				CFrame = v163.CFrame * CFrame.new(0, l__LocalPlayer__2.Input.MoveIntensity.value, 0)
			}):Play();
		end;
		if p24 == "Left" then
			l__TweenService__16:Create(workspace.CurrentCamera, TweenInfo.new(l__LocalPlayer__2.Input.MoveSpeed.Value, v9, Enum.EasingDirection.Out), {
				CFrame = v163.CFrame * CFrame.new(-l__LocalPlayer__2.Input.MoveIntensity.value, 0, 0)
			}):Play();
		end;
		if p24 == "Down" then
			l__TweenService__16:Create(workspace.CurrentCamera, TweenInfo.new(l__LocalPlayer__2.Input.MoveSpeed.Value, v9, Enum.EasingDirection.Out), {
				CFrame = v163.CFrame * CFrame.new(0, -l__LocalPlayer__2.Input.MoveIntensity.value, 0)
			}):Play();
		end;
		if p24 == "Right" then
			l__TweenService__16:Create(workspace.CurrentCamera, TweenInfo.new(l__LocalPlayer__2.Input.MoveSpeed.Value, v9, Enum.EasingDirection.Out), {
				CFrame = v163.CFrame * CFrame.new(l__LocalPlayer__2.Input.MoveIntensity.value, 0, 0)
			}):Play();
		end;
	end;
end;
local u42 = v85:FindFirstChild("Modchart") and (v85.Modchart:IsA("ModuleScript") and (v105 and require(v85.Modchart)));
local l__UserInput__43 = l__Events__5.UserInput;
local function u44(p26, p27)
	if not l__LocalPlayer__2.Input.ShowRatings.Value then
		return;
	end;
	local v164 = p27 and v21 or (l__Parent__3.PlayerSide.Value == "L" and l__Game__7.R or l__Game__7.L);
	if not p27 then
		p27 = p26;
		if p27 <= v15.Marvelous and l__LocalPlayer__2.Input.ShowMarvelous.Value then
			p26 = "Marvelous";
		elseif p27 <= v15.Sick then
			p26 = "Sick";
		elseif p27 <= v15.Good then
			p26 = "Good";
		elseif p27 <= v15.Ok then
			p26 = "Ok";
		elseif p27 <= v15.Bad then
			p26 = "Bad";
		end;
	end;
	local v165 = v164:FindFirstChildOfClass("ImageLabel");
	if v165 then
		v165.Parent = nil;
	end;
	local v166 = v164:FindFirstChildOfClass("TextLabel");
	if v166 then
		v166.Parent = nil;
	end;
	local l__Value__167 = l__LocalPlayer__2.Input.RatingSize.Value;
	local v168 = game.ReplicatedStorage.Misc.IndicatorTemplate:Clone();
	v168.Image = "rbxthumb://type=Asset&id=" .. l__LocalPlayer__2.Input[p26 .. "IndicatorImg"].Value .. "&w=150&h=150" or l__Value__6.FlyingText.G["Template_" .. p26].Image;
	v168.Parent = v164;
	v168.Size = UDim2.new(0.25 * l__Value__167, 0, 0.083 * l__Value__167, 0);
	v168.ImageTransparency = 0;
	if l__Game__7.Rotation >= 90 then
		local v169 = 180;
	else
		v169 = 0;
	end;
	v168.Rotation = v169;
	game:GetService("Debris"):AddItem(v168, 1.5);
	if l__LocalPlayer__2.Input.CenterRatings.Value then
		v168.Position = UDim2.new(0.5, 0, 0.45, 0);
	end;
	task.spawn(function()
		if l__LocalPlayer__2.Input.RatingBounce.Value then
			l__TweenService__16:Create(v168, TweenInfo.new(0.05, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
				Size = UDim2.new(0.3 * l__Value__167, 0, 0.1 * l__Value__167, 0)
			}):Play();
		end;
		task.wait(0.1);
		l__TweenService__16:Create(v168, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
			Size = UDim2.new(0.25 * l__Value__167, 0, 0.083 * l__Value__167, 0)
		}):Play();
		task.wait(0.5);
		l__TweenService__16:Create(v168, TweenInfo.new(0.75, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
			ImageTransparency = 1
		}):Play();
	end);
	local v170 = game.ReplicatedStorage.Misc.miliseconds:Clone();
	v170.Visible = l__LocalPlayer__2.Input.ShowMS.Value;
	v170.Parent = v164;
	v170.Size = UDim2.new(0.145 * l__Value__167, 0, 0.044 * l__Value__167, 0);
	if l__Game__7.Rotation >= 90 then
		local v171 = 180;
	else
		v171 = 0;
	end;
	v170.Rotation = v171;
	v170.Text = math.floor(p27 * 100 + 0.5) / 100 .. " ms";
	if p27 < 0 then
		v170.TextColor3 = Color3.fromRGB(255, 61, 61);
	else
		v170.TextColor3 = Color3.fromRGB(120, 255, 124);
	end;
	game:GetService("Debris"):AddItem(v170, 1.5);
	if l__LocalPlayer__2.Input.CenterRatings.Value then
		v170.Position = UDim2.new(0.5, 0, 0.36, 0);
	end;
	task.spawn(function()
		if l__LocalPlayer__2.Input.RatingBounce.Value then
			l__TweenService__16:Create(v170, TweenInfo.new(0.05, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
				Size = UDim2.new(0.165 * l__Value__167, 0, 0.06 * l__Value__167, 0)
			}):Play();
		end;
		task.wait(0.1);
		l__TweenService__16:Create(v170, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
			Size = UDim2.new(0.145 * l__Value__167, 0, 0.044 * l__Value__167, 0)
		}):Play();
		task.wait(0.5);
		l__TweenService__16:Create(v170, TweenInfo.new(0.75, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
			TextTransparency = 1
		}):Play();
		l__TweenService__16:Create(v170, TweenInfo.new(0.75, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
			TextStrokeTransparency = 1
		}):Play();
	end);
end;
local function v172(p28, p29, p30, p31, p32)
	if not p29 then
		return;
	end;
	if p31 then
		u37[p29] = p28.UserInputState == Enum.UserInputState.Begin;
		if l__Parent__3.PlayerSide.Value == "L" then
			local v173 = "R";
		else
			v173 = "L";
		end;
		p31 = l__Game__7:FindFirstChild(v173);
	end;
	if not p31 then
		u36[p29] = p28.UserInputState == Enum.UserInputState.Begin;
	end;
	if l__Config__4.CantHitNotes.Value then
		return;
	end;
	local l__Value__174 = l__LocalPlayer__2.Input.InputType.Value;
	local v175 = nil;
	if not v21.Arrows.IncomingNotes:FindFirstChild(p29) then
		return;
	end;
	local v176, v177, v178 = ipairs((p31 or v21).Arrows.IncomingNotes[p29]:GetChildren());
	while true do
		v176(v177, v178);
		if not v176 then
			break;
		end;
		v178 = v176;
		if v177.Name == p29 or string.split(v177.Name, "_")[1] == p29 then
			local v179 = v177:GetAttribute("NoteData");
			local v180 = string.split(v179, "~")[1] - (v14.tomilseconds(l__Config__4.TimePast.Value) + u25);
			if not p31 then
				if v177.Frame.Arrow.Visible and math.abs(v180) <= v15.Bad then
					if not v175 then
						v175 = v177;
					elseif l__Value__174 == "Bloxxin" then
						if (v177.AbsolutePosition - v177.Parent.AbsolutePosition).magnitude <= (v175.AbsolutePosition - v177.Parent.AbsolutePosition).magnitude then
							v175 = v177;
						end;
					elseif v180 < string.split(v179, "~")[1] - (v14.tomilseconds(l__Config__4.TimePast.Value) + u25) then
						v175 = v177;
					end;
				end;
			elseif v179 == p30 then
				v175 = v177;
				break;
			end;
		end;	
	end;
	if l__Config__4.GhostTappingEnabled.Value and not v175 and not p31 and u38(p29) then
		v175 = "ghost";
	end;
	if not u36[p29] and p28.UserInputState ~= Enum.UserInputState.Begin then
		return;
	end;
	if p31 then
		if v175 then
			u41(p29, true);
			v175.Frame.Arrow.Visible = false;
			p31.Glow[p29].Arrow.ImageTransparency = 1;
			if p28.UserInputState ~= Enum.UserInputState.Begin then
				return;
			else
				local v181 = nil;
				local v182 = nil;
				local v183 = nil;
				local v184 = nil;
				local v185 = nil;
				local v186 = nil;
				p31.Glow[p29].Arrow.Visible = true;
				if p31.Glow[p29].Arrow.ImageTransparency == 1 then
					if not l__LocalPlayer__2.Input.DisableArrowGlow.Value then
						local v187 = nil;
						local v188 = nil;
						local v189 = nil;
						local v190 = nil;
						local v191 = nil;
						local v192 = nil;
						local v193 = nil;
						local v194 = nil;
						local v195 = nil;
						local v196 = nil;
						local v197 = nil;
						local v198 = nil;
						local v199 = nil;
						local v200 = nil;
						local v201 = nil;
						local v202 = nil;
						local v203 = nil;
						local v204 = nil;
						if not u27[p31.Name][p29] then
							local u45 = false;
							local u46 = nil;
							u46 = l__RunService__18.RenderStepped:Connect(function()
								if u45 then
									u46:Disconnect();
									p31.Glow[p29].Arrow.ImageTransparency = 1;
									return;
								end;
								p31.Glow[p29].Arrow.ImageTransparency = 0.2 - math.cos(tick() * 10 * math.pi) / 6;
							end);
							v187 = "Frame";
							v188 = v175;
							v189 = v187;
							v190 = v188[v189];
							local v205 = "Bar";
							v191 = v190;
							v192 = v205;
							v193 = v191[v192];
							local v206 = "Size";
							v194 = v193;
							v195 = v206;
							v196 = v194[v195];
							local v207 = "Y";
							v197 = v196;
							v198 = v207;
							v199 = v197[v198];
							local v208 = "Scale";
							v201 = v199;
							v202 = v208;
							v200 = v201[v202];
							local v209 = 0;
							v203 = v209;
							v204 = v200;
							if v203 < v204 then
								local v210 = tick();
								while true do
									v14.wait();
									local l__Scale__211 = v175.Position.Y.Scale;
									if l__Scale__211 < 0 then
										v175.Frame.Bar.Size = UDim2.new(l__LocalPlayer__2.Input.BarSize.Value, 0, math.clamp(v200 + l__Scale__211, 0, 20), 0);
										v175.Frame.Bar.Position = UDim2.new(0.5, 0, 0.5 - l__Scale__211, 0);
									end;
									if not u37[p29] then
										break;
									end;
									if v175.Frame.Bar.Size.Y.Scale == 0 then
										break;
									end;
									if tick() - v210 > 7.5 then
										break;
									end;								
								end;
							else
								v14.wait(0.175);
							end;
							local v212 = true;
							v181 = u42;
							v182 = v181;
							if v182 and u42.OpponentHit then
								u42.OpponentHit(l__Parent__3, p29);
							end;
							local v213 = u44;
							v183 = p32;
							v184 = v183;
							v185 = v213;
							v186 = v184;
							v185(v186);
							return;
						elseif not l__LocalPlayer__2.Input.DisableArrowGlow.Value and u27[p31.Name][p29] then
							if false then
								u22:Disconnect();
								u27[p31.Name][p29]:PlayAnimation("Receptor");
								return;
							else
								u27[p31.Name][p29]:PlayAnimation("Glow");
								v187 = "Frame";
								v188 = v175;
								v189 = v187;
								v190 = v188[v189];
								v205 = "Bar";
								v191 = v190;
								v192 = v205;
								v193 = v191[v192];
								v206 = "Size";
								v194 = v193;
								v195 = v206;
								v196 = v194[v195];
								v207 = "Y";
								v197 = v196;
								v198 = v207;
								v199 = v197[v198];
								v208 = "Scale";
								v201 = v199;
								v202 = v208;
								v200 = v201[v202];
								v209 = 0;
								v203 = v209;
								v204 = v200;
								if v203 < v204 then
									v210 = tick();
									while true do
										v14.wait();
										l__Scale__211 = v175.Position.Y.Scale;
										if l__Scale__211 < 0 then
											v175.Frame.Bar.Size = UDim2.new(l__LocalPlayer__2.Input.BarSize.Value, 0, math.clamp(v200 + l__Scale__211, 0, 20), 0);
											v175.Frame.Bar.Position = UDim2.new(0.5, 0, 0.5 - l__Scale__211, 0);
										end;
										if not u37[p29] then
											break;
										end;
										if v175.Frame.Bar.Size.Y.Scale == 0 then
											break;
										end;
										if tick() - v210 > 7.5 then
											break;
										end;									
									end;
								else
									v14.wait(0.175);
								end;
								v212 = true;
								v181 = u42;
								v182 = v181;
								if v182 and u42.OpponentHit then
									u42.OpponentHit(l__Parent__3, p29);
								end;
								v213 = u44;
								v183 = p32;
								v184 = v183;
								v185 = v213;
								v186 = v184;
								v185(v186);
								return;
							end;
						else
							v187 = "Frame";
							v188 = v175;
							v189 = v187;
							v190 = v188[v189];
							v205 = "Bar";
							v191 = v190;
							v192 = v205;
							v193 = v191[v192];
							v206 = "Size";
							v194 = v193;
							v195 = v206;
							v196 = v194[v195];
							v207 = "Y";
							v197 = v196;
							v198 = v207;
							v199 = v197[v198];
							v208 = "Scale";
							v201 = v199;
							v202 = v208;
							v200 = v201[v202];
							v209 = 0;
							v203 = v209;
							v204 = v200;
							if v203 < v204 then
								v210 = tick();
								while true do
									v14.wait();
									l__Scale__211 = v175.Position.Y.Scale;
									if l__Scale__211 < 0 then
										v175.Frame.Bar.Size = UDim2.new(l__LocalPlayer__2.Input.BarSize.Value, 0, math.clamp(v200 + l__Scale__211, 0, 20), 0);
										v175.Frame.Bar.Position = UDim2.new(0.5, 0, 0.5 - l__Scale__211, 0);
									end;
									if not u37[p29] then
										break;
									end;
									if v175.Frame.Bar.Size.Y.Scale == 0 then
										break;
									end;
									if tick() - v210 > 7.5 then
										break;
									end;								
								end;
							else
								v14.wait(0.175);
							end;
							v212 = true;
							v181 = u42;
							v182 = v181;
							if v182 and u42.OpponentHit then
								u42.OpponentHit(l__Parent__3, p29);
							end;
							v213 = u44;
							v183 = p32;
							v184 = v183;
							v185 = v213;
							v186 = v184;
							v185(v186);
							return;
						end;
					elseif not l__LocalPlayer__2.Input.DisableArrowGlow.Value and u27[p31.Name][p29] then
						if false then
							u22:Disconnect();
							u27[p31.Name][p29]:PlayAnimation("Receptor");
							return;
						else
							u27[p31.Name][p29]:PlayAnimation("Glow");
							v187 = "Frame";
							v188 = v175;
							v189 = v187;
							v190 = v188[v189];
							v205 = "Bar";
							v191 = v190;
							v192 = v205;
							v193 = v191[v192];
							v206 = "Size";
							v194 = v193;
							v195 = v206;
							v196 = v194[v195];
							v207 = "Y";
							v197 = v196;
							v198 = v207;
							v199 = v197[v198];
							v208 = "Scale";
							v201 = v199;
							v202 = v208;
							v200 = v201[v202];
							v209 = 0;
							v203 = v209;
							v204 = v200;
							if v203 < v204 then
								v210 = tick();
								while true do
									v14.wait();
									l__Scale__211 = v175.Position.Y.Scale;
									if l__Scale__211 < 0 then
										v175.Frame.Bar.Size = UDim2.new(l__LocalPlayer__2.Input.BarSize.Value, 0, math.clamp(v200 + l__Scale__211, 0, 20), 0);
										v175.Frame.Bar.Position = UDim2.new(0.5, 0, 0.5 - l__Scale__211, 0);
									end;
									if not u37[p29] then
										break;
									end;
									if v175.Frame.Bar.Size.Y.Scale == 0 then
										break;
									end;
									if tick() - v210 > 7.5 then
										break;
									end;								
								end;
							else
								v14.wait(0.175);
							end;
							v212 = true;
							v181 = u42;
							v182 = v181;
							if v182 and u42.OpponentHit then
								u42.OpponentHit(l__Parent__3, p29);
							end;
							v213 = u44;
							v183 = p32;
							v184 = v183;
							v185 = v213;
							v186 = v184;
							v185(v186);
							return;
						end;
					else
						v187 = "Frame";
						v188 = v175;
						v189 = v187;
						v190 = v188[v189];
						v205 = "Bar";
						v191 = v190;
						v192 = v205;
						v193 = v191[v192];
						v206 = "Size";
						v194 = v193;
						v195 = v206;
						v196 = v194[v195];
						v207 = "Y";
						v197 = v196;
						v198 = v207;
						v199 = v197[v198];
						v208 = "Scale";
						v201 = v199;
						v202 = v208;
						v200 = v201[v202];
						v209 = 0;
						v203 = v209;
						v204 = v200;
						if v203 < v204 then
							v210 = tick();
							while true do
								v14.wait();
								l__Scale__211 = v175.Position.Y.Scale;
								if l__Scale__211 < 0 then
									v175.Frame.Bar.Size = UDim2.new(l__LocalPlayer__2.Input.BarSize.Value, 0, math.clamp(v200 + l__Scale__211, 0, 20), 0);
									v175.Frame.Bar.Position = UDim2.new(0.5, 0, 0.5 - l__Scale__211, 0);
								end;
								if not u37[p29] then
									break;
								end;
								if v175.Frame.Bar.Size.Y.Scale == 0 then
									break;
								end;
								if tick() - v210 > 7.5 then
									break;
								end;							
							end;
						else
							v14.wait(0.175);
						end;
						v212 = true;
						v181 = u42;
						v182 = v181;
						if v182 and u42.OpponentHit then
							u42.OpponentHit(l__Parent__3, p29);
						end;
						v213 = u44;
						v183 = p32;
						v184 = v183;
						v185 = v213;
						v186 = v184;
						v185(v186);
						return;
					end;
				else
					v181 = u42;
					v182 = v181;
					if v182 and u42.OpponentHit then
						u42.OpponentHit(l__Parent__3, p29);
					end;
					v213 = u44;
					v183 = p32;
					v184 = v183;
					v185 = v213;
					v186 = v184;
					v185(v186);
					return;
				end;
			end;
		else
			return;
		end;
	end;
	u39(p29);
	if v175 and v175 ~= "ghost" then
		if v175:FindFirstChild("HitSound") then
			v14.PlaySound(v175.HitSound.Value, v175.HitSound.parent, 2.25);
		elseif l__LocalPlayer__2.Input.HitSounds.Value == true then
			v14.PlaySound(v142);
		end;
		local v214 = string.split(v175:GetAttribute("NoteData"), "~")[1] - (v14.tomilseconds(l__Config__4.TimePast.Value) + u25);
		local v215 = math.abs(v214);
		local v216 = string.split(v175.Name, "_")[1];
		if v215 <= v15.Sick then
			u40(v216);
		end;
		if l__LocalPlayer__2.Input.ScoreBop.Value then
			if l__LocalPlayer__2.Input.VerticalBar.Value then
				for v217, v218 in pairs(l__Parent__3.SideContainer:GetChildren()) do
					if v218.ClassName == "TextLabel" then
						v218.Size = UDim2.new(u24[v218.Name].X.Scale * 1.1, 0, u24[v218.Name].Y.Scale * 1.1, 0);
						l__TweenService__16:Create(v218, TweenInfo.new(0.3), {
							Size = u24[v218.Name]
						}):Play();
					end;
				end;
			else
				l__Parent__3.LowerContainer.Stats.Size = UDim2.new(u24.Stats.X.Scale * 1.1, 0, u24.Stats.Y.Scale * 1.1, 0);
				l__TweenService__16:Create(l__Parent__3.LowerContainer.Stats, TweenInfo.new(0.3), {
					Size = u24.Stats
				}):Play();
			end;
		end;
		u41(v216);
		u3 = u3 + 1;
		if u42 and u42.OnHit then
			u42.OnHit(l__Parent__3, u5, u3, v216, u2);
		end;
		v31();
		if v175.HellNote.Value == false then
			local v219 = "0";
		else
			v219 = "1";
		end;
		l__UserInput__43:FireServer(v175, p29 .. "|0|" .. v14.tomilseconds(l__Config__4.TimePast.Value) + u25 .. "|" .. v175.Position.Y.Scale .. "|" .. v175:GetAttribute("NoteData") .. "|" .. v175.Name .. "|" .. v175:GetAttribute("Length") .. "|" .. tostring(v219));
		table.insert(u12, {
			ms = v214, 
			songPos = l__Parent__3.Config.TimePast.Value, 
			miss = false
		});
		v175.Frame.Arrow.Visible = false;
		if not u36[p29] then
			return;
		end;
		v21.Glow[p29].Arrow.ImageTransparency = 1;
		v21.Glow[p29].Arrow.Visible = true;
		if v21.Glow[p29].Arrow.ImageTransparency == 1 then
			if not l__LocalPlayer__2.Input.DisableArrowGlow.Value and not u27[v21.Name][p29] then
				local u47 = false;
				local u48 = nil;
				u48 = l__RunService__18.RenderStepped:Connect(function()
					if u47 then
						u48:Disconnect();
						v21.Glow[p29].Arrow.ImageTransparency = 1;
						return;
					end;
					v21.Glow[p29].Arrow.ImageTransparency = 0.2 - math.cos(tick() * 10 * math.pi) / 6 + v21.Arrows[p29].ImageTransparency / 1.25;
				end);
			elseif not l__LocalPlayer__2.Input.DisableArrowGlow.Value and u27[v21.Name][p29] then
				if false then
					u22:Disconnect();
					u27[v21.Name][p29]:PlayAnimation("Receptor");
					return;
				end;
				u27[v21.Name][p29]:PlayAnimation("Glow");
			end;
			local l__Scale__220 = v175.Frame.Bar.Size.Y.Scale;
			if l__Scale__220 > 0 then
				local v221 = math.abs(v214);
				while true do
					task.wait();
					local l__Scale__222 = v175.Position.Y.Scale;
					if l__Scale__222 < 0 and v175:FindFirstChild("Frame") then
						v175.Frame.Bar.Size = UDim2.new(l__LocalPlayer__2.Input.BarSize.Value, 0, math.clamp(l__Scale__220 + l__Scale__222, 0, 20), 0);
						v175.Frame.Bar.Position = UDim2.new(0.5, 0, 0.5 - l__Scale__222, 0);
					end;
					if not u36[p29] then
						break;
					end;				
				end;
				if v175.HellNote.Value == false then
					local v223 = "0";
				else
					v223 = "1";
				end;
				l__UserInput__43:FireServer(v175, p29 .. "|1|" .. v14.tomilseconds(l__Config__4.TimePast.Value) + u25 .. "|" .. v175.Position.Y.Scale .. "|" .. v175:GetAttribute("NoteData") .. "|" .. v175.Name .. "|" .. v175:GetAttribute("Length") .. "|" .. tostring(v223));
				local v224 = 1 - math.clamp(math.abs(v175.Position.Y.Scale) / v175:GetAttribute("Length"), 0, 1);
				if v224 <= v141 / 10 then
					if v221 <= v15.Marvelous and l__LocalPlayer__2.Input.ShowMarvelous.Value then
						local v225 = "Marvelous";
					else
						v225 = "Sick";
					end;
					u44(v225, v214);
					table.insert(u1, 1, 100);
					if v221 <= v15.Marvelous and l__LocalPlayer__2.Input.ShowMarvelous.Value then
						u6 = u6 + 1;
					else
						u7 = u7 + 1;
					end;
				elseif v224 <= v141 / 6 then
					u44("Good", v214);
					table.insert(u1, 1, 90);
					u8 = u8 + 1;
					if l__Parent__3:GetAttribute("Perfect") then
						l__LocalPlayer__2.Character.Humanoid.Health = 0;
					end;
				elseif v224 <= v141 then
					u44("Bad", v214);
					table.insert(u1, 1, 60);
					u10 = u10 + 1;
					if l__Parent__3:GetAttribute("Perfect") then
						l__LocalPlayer__2.Character.Humanoid.Health = 0;
					end;
				end;
				v31();
				v175.Visible = false;
			else
				if v175.HellNote.Value ~= false then

				end;
				if v215 <= v15.Marvelous * 1 and l__LocalPlayer__2.Input.ShowMarvelous.Value then
					u44("Marvelous", v214);
					table.insert(u1, 1, 100);
					u6 = u6 + 1;
				elseif v215 <= v15.Sick * 1 then
					u44("Sick", v214);
					table.insert(u1, 1, 100);
					u7 = u7 + 1;
				elseif v215 <= v15.Good * 1 then
					u44("Good", v214);
					table.insert(u1, 1, 90);
					u8 = u8 + 1;
					if l__Parent__3:GetAttribute("Perfect") then
						l__LocalPlayer__2.Character.Humanoid.Health = 0;
					end;
				elseif v215 <= v15.Ok * 1 then
					u44("Ok", v214);
					table.insert(u1, 1, 75);
					u9 = u9 + 1;
					if l__Parent__3:GetAttribute("Perfect") then
						l__LocalPlayer__2.Character.Humanoid.Health = 0;
					end;
				elseif v215 <= v15.Bad * 1 then
					u44("Bad", v214);
					table.insert(u1, 1, 60);
					u10 = u10 + 1;
					if l__Parent__3:GetAttribute("Perfect") then
						l__LocalPlayer__2.Character.Humanoid.Health = 0;
					end;
				end;
				v31();
				while true do
					v14.wait();
					if not u36[p29] then
						break;
					end;				
				end;
				v175.Visible = false;
			end;
		end;
	end;
	if not u36[p29] then
		return;
	end;
	if v175 ~= "ghost" then
		l__UserInput__43:FireServer("missed", p29 .. "|0");
		table.insert(u1, 1, 0);
		u4 = u4 + 1;
		u3 = 0;
		v31();
		table.insert(u12, {
			ms = 0, 
			songPos = l__Parent__3.Config.TimePast.Value, 
			miss = true
		});
		if u42 and u42.OnMiss then
			u42.OnMiss(l__Parent__3, u4, u2);
		end;
		if l__Parent__3:GetAttribute("SuddenDeath") and l__Config__4.TimePast.Value > 5 then
			l__LocalPlayer__2.Character.Humanoid.Health = 0;
		end;
		local v226 = l__Parent__3.Sounds:GetChildren()[math.random(1, #l__Parent__3.Sounds:GetChildren())];
		v226.Volume = l__LocalPlayer__2.Input.MissVolume.Value and 0.3;
		v226:Play();
	end;
	local v227 = v21.Arrows[p29];
	u36[p29] = true;
	if u27[v21.Name][p29] then
		u27[v21.Name][p29]:PlayAnimation("Press");
	else
		v227.Overlay.Visible = true;
	end;
	local v228 = 1 * l__LocalPlayer__2.Input.ArrowSize.Value;
	if v87 then
		v228 = 1;
	end;
	if v89 then
		v228 = 0.85;
	end;
	if v88 then
		v228 = 0.7;
	end;
	if v108 then
		v228 = v108.CustomArrowSize and 1;
	end;
	l__TweenService__16:Create(v227, TweenInfo.new(0.05, Enum.EasingStyle.Linear, Enum.EasingDirection.In, 0, false, 0), {
		Size = v175 == "ghost" and UDim2.new(v228 / 1.05, 0, v228 / 1.05, 0) or UDim2.new(v228 / 1.25, 0, v228 / 1.25, 0)
	}):Play();
	while true do
		task.wait();
		if not u36[p29] then
			break;
		end;	
	end;
	if u27[v21.Name][p29] then
		u27[v21.Name][p29]:PlayAnimation("Receptor");
	else
		v227.Overlay.Visible = false;
	end;
	l__TweenService__16:Create(v227, TweenInfo.new(0.05, Enum.EasingStyle.Quint, Enum.EasingDirection.Out, 0, false, 0), {
		Size = UDim2.new(v228, 0, v228, 0)
	}):Play();
end;
local v229 = nil;
local l__Value__230 = _G.LastInput.Value;
if l__Value__230 == Enum.UserInputType.Touch then
	script.Device.Value = "Mobile";
	v14.wait(0.2);
	local v231, v232, v233 = ipairs(l__Parent__3.MobileButtons.Container:GetChildren());
	while true do
		v231(v232, v233);
		if not v231 then
			break;
		end;
		v233 = v231;
		if v232:IsA("ImageButton") then
			v232.MouseButton1Down:Connect(function()
				v172({
					UserInputState = Enum.UserInputState.Begin
				}, v232.Name);
			end);
			v232.MouseButton1Up:Connect(function()
				v172({
					UserInputState = Enum.UserInputState.End
				}, v232.Name);
			end);
		end;	
	end;
	script.Parent.MobileButtons.Visible = true;
elseif l__Value__230 == Enum.UserInputType.Keyboard then
	script.Device.Value = "Computer";
	local function v234(p33, p34)
		if p34 then
			return;
		end;
		local l__Keybinds__235 = l__LocalPlayer__2.Input.Keybinds;
		if v108 and v108.getDirection then
			local v236 = v108.getDirection(p33.KeyCode, l__Keybinds__235);
			if v236 then
				v172(p33, v236);
				return;
			end;
		else
			if v86 then
				local v237, v238, v239 = ipairs(l__Keybinds__235:GetChildren());
				while true do
					v237(v238, v239);
					if not v237 then
						break;
					end;
					v239 = v237;
					if v238:GetAttribute("ExtraKey") and p33.KeyCode.Name == v238.Value then
						v172(p33, v132[v238.Name]);
						return;
					end;				
				end;
				return;
			end;
			local v240, v241, v242 = ipairs(l__Keybinds__235:GetChildren());
			while true do
				v240(v241, v242);
				if not v240 then
					break;
				end;
				v242 = v240;
				if not v241:GetAttribute("ExtraKey") then
					if p33.KeyCode.Name == v241.Value then
						local l__Name__243 = v241.Name;
						if v241:GetAttribute("SecondaryKey") then
							local v244 = v241:GetAttribute("Key");
						end;
						v172(p33, v241:GetAttribute("SecondaryKey") and v241:GetAttribute("Key") or v241.Name);
						return;
					end;
					if v241:GetAttribute("SecondaryKey") and p33.KeyCode.Name == v241:GetAttribute("Key") then
						l__Name__243 = v241.Name;
						if v241:GetAttribute("SecondaryKey") then
							v244 = v241:GetAttribute("Key");
						end;
						v172(p33, v241:GetAttribute("SecondaryKey") and v241:GetAttribute("Key") or v241.Name);
						return;
					end;
				end;			
			end;
		end;
	end;
	v229 = l__UserInputService__17.InputBegan:connect(v234);
	local v245 = l__UserInputService__17.InputEnded:connect(v234);
elseif l__Value__230 == Enum.UserInputType.Gamepad1 then
	script.Device.Value = "Controller";
	local function v246(p35, p36)
		local l__XBOXKeybinds__247 = l__LocalPlayer__2.Input.XBOXKeybinds;
		if v108 and v108.getDirection then
			local v248 = v108.getDirection(p35.KeyCode, l__XBOXKeybinds__247);
			if v248 then
				v172(p35, v248);
				return;
			end;
		elseif v86 then
			local v249, v250, v251 = ipairs(l__XBOXKeybinds__247:GetChildren());
			while true do
				v249(v250, v251);
				if not v249 then
					break;
				end;
				v251 = v249;
				if v250:GetAttribute("ExtraKey") and p35.KeyCode.Name == v250.Value then
					v172(p35, v132[v250.Name:sub(12, -1)]);
					return;
				end;			
			end;
			return;
		else
			local v252, v253, v254 = ipairs(l__XBOXKeybinds__247:GetChildren());
			while true do
				v252(v253, v254);
				if not v252 then
					break;
				end;
				v254 = v252;
				if not v253:GetAttribute("ExtraKey") and p35.KeyCode.Name == v253.Value then
					v172(p35, v253.Name:sub(12, -1));
					return;
				end;			
			end;
		end;
	end;
	v229 = l__UserInputService__17.InputBegan:connect(v246);
	local v255 = l__UserInputService__17.InputEnded:connect(v246);
end;
if l__Parent__3.PlayerSide.Value == "L" then
	local v256 = l__Value__6.Events.Player2Hit.OnClientEvent:Connect(function(p37)
		p37 = string.split(p37, "|");
		v172({
			UserInputState = p37[2] == "0" and Enum.UserInputState.Begin or Enum.UserInputState.End
		}, p37[1], string.gsub(p37[3], "~", "|") .. "~" .. p37[4], true, (tonumber(p37[5])));
	end);
else
	v256 = l__Value__6.Events.Player1Hit.OnClientEvent:Connect(function(p38)
		p38 = string.split(p38, "|");
		v172({
			UserInputState = p38[2] == "0" and Enum.UserInputState.Begin or Enum.UserInputState.End
		}, p38[1], string.gsub(p38[3], "~", "|") .. "~" .. p38[4], true, (tonumber(p38[5])));
	end);
end;
l__Parent__3.Side.Changed:Connect(function()
	if u42 and u42.OverrideCamera then
		return;
	end;
	local l__Value__257 = l__Parent__3.Side.Value;
	local v258 = workspace.ClientBG:FindFirstChildOfClass("Model");
	l__TweenService__16:Create(workspace.CurrentCamera, TweenInfo.new(l__LocalPlayer__2.Input.CameraSpeed.Value, v9, Enum.EasingDirection.Out, 0, false, 0), {
		CFrame = (v258 and v258:FindFirstChild("cameraPoints") and v258.cameraPoints:FindFirstChild(l__Value__257) or (l__Value__6.CameraPoints:FindFirstChild(l__Value__257) or l__Value__6.CameraPoints.C)).CFrame
	}):Play();
end);
if l__LocalPlayer__2.Input.HideMap.Value and not v85:FindFirstChild("ForceBackgrounds") then
	local v259 = Instance.new("Frame");
	v259.Parent = l__Parent__3;
	v259.Position = UDim2.new(0, 0, 0, 0);
	v259.BackgroundColor3 = Color3.fromRGB(0, 0, 0);
	v259.Size = UDim2.new(1, 0, 1, 0);
	v259.BackgroundTransparency = 1;
	l__LocalPlayer__2.Character:WaitForChild("Humanoid").Died:Connect(function()
		game.ReplicatedStorage.Events.UnloadBackground:Fire();
	end);
	l__TweenService__16:Create(v259, TweenInfo.new(0.4), {
		BackgroundTransparency = 0
	}):Play();
	task.wait(0.4);
	task.spawn(function()
		l__TweenService__16:Create(v259, TweenInfo.new(0.4), {
			BackgroundTransparency = 1
		}):Play();
		task.wait(0.4);
		v259:Destroy();
	end);
	for v260, v261 in pairs(workspace:GetDescendants()) do
		if not v261:IsDescendantOf(l__Value__6) and not v261:IsDescendantOf(workspace.Misc.ActualShop) and (not l__Value__6.Seat.Occupant or not v261:IsDescendantOf(l__Value__6.Seat.Occupant.Parent)) and (not l__Value__6.Config.Player1.Value or not v261:IsDescendantOf(l__Value__6.Config.Player1.Value.Character)) and (not l__Value__6.Config.Player2.Value or not v261:IsDescendantOf(l__Value__6.Config.Player2.Value.Character)) then
			if not (not v261:IsA("BasePart")) or not (not v261:IsA("Decal")) or v261:IsA("Texture") then
				v261.Transparency = 1;
			elseif v261:IsA("GuiObject") then
				v261.Visible = false;
			elseif v261:IsA("Beam") or v261:IsA("ParticleEmitter") then
				v261.Enabled = false;
			end;
		end;
	end;
	local v262 = game.ReplicatedStorage.Misc.DarkVoid:Clone();
	v262.Parent = workspace.ClientBG;
	v262:SetPrimaryPartCFrame(l__Value__6.BackgroundPart.CFrame);
	for v263, v264 in pairs(game.Lighting:GetChildren()) do
		v264:Destroy();
	end;
	for v265, v266 in pairs(v262.Lighting:GetChildren()) do
		v266:Clone().Parent = game.Lighting;
	end;
	l__Value__6.Misc.Stereo.Speakers.Transparency = 1;
	for v267, v268 in pairs(l__Value__6.Fireworks:GetChildren()) do
		v268.Transparency = 1;
	end;
end;
local u49 = false;
l__Events__5.ChangeBackground.Event:Connect(function(p39, p40, p41)
	if (not l__LocalPlayer__2.Input.Backgrounds.Value or l__LocalPlayer__2.Input.HideMap.Value) and not v85:FindFirstChild("ForceBackgrounds") then
		return;
	end;
	local l__Backgrounds__269 = game.ReplicatedStorage.Backgrounds;
	local v270 = l__Backgrounds__269:FindFirstChild(p40) and l__Backgrounds__269[p40]:Clone() or game.ReplicatedStorage.Events.Backgrounds:InvokeServer("Load", p39, p40, v85);
	if not l__Backgrounds__269:FindFirstChild(p40) then
		v270:Clone().Parent = l__Backgrounds__269;
	end;
	for v271, v272 in pairs(workspace.ClientBG:GetChildren()) do
		v272:Destroy();
	end;
	if l__Value__6.Config.CleaningUp.Value then
		return;
	end;
	if not u49 then
		u49 = true;
		local v273 = Instance.new("Frame");
		v273.Parent = l__Parent__3;
		v273.Position = UDim2.new(0, 0, 0, 0);
		v273.BackgroundColor3 = Color3.fromRGB(0, 0, 0);
		v273.Size = UDim2.new(1, 0, 1, 0);
		v273.BackgroundTransparency = 1;
		l__TweenService__16:Create(v273, TweenInfo.new(0.4), {
			BackgroundTransparency = 0
		}):Play();
		task.wait(0.4);
		task.spawn(function()
			l__TweenService__16:Create(v273, TweenInfo.new(0.4), {
				BackgroundTransparency = 1
			}):Play();
			task.wait(0.4);
			v273:Destroy();
		end);
		for v274, v275 in pairs(workspace:GetDescendants()) do
			if not v275:IsDescendantOf(l__Value__6) and not v275:IsDescendantOf(workspace.Misc.ActualShop) and (not l__Value__6.Seat.Occupant or not v275:IsDescendantOf(l__Value__6.Seat.Occupant.Parent)) and (not l__Value__6.Config.Player1.Value or not v275:IsDescendantOf(l__Value__6.Config.Player1.Value.Character)) and (not l__Value__6.Config.Player2.Value or not v275:IsDescendantOf(l__Value__6.Config.Player2.Value.Character)) then
				if not (not v275:IsA("BasePart")) or not (not v275:IsA("Decal")) or v275:IsA("Texture") then
					v275.Transparency = 1;
				elseif v275:IsA("GuiObject") then
					v275.Visible = false;
				elseif v275:IsA("Beam") or v275:IsA("ParticleEmitter") then
					v275.Enabled = false;
				end;
			end;
		end;
	end;
	if p41 then
		local v276 = 0;
	else
		v276 = 1;
	end;
	l__Value__6.Misc.Stereo.Speakers.Transparency = v276;
	for v277, v278 in pairs(l__Value__6.Fireworks:GetChildren()) do
		if p41 then
			local v279 = 0;
		else
			v279 = 1;
		end;
		v278.Transparency = v279;
	end;
	v270.Parent = workspace.ClientBG;
	v270:SetPrimaryPartCFrame(l__Value__6.BackgroundPart.CFrame);
	if v270:FindFirstChild("Lighting") then
		for v280, v281 in pairs(game.Lighting:GetChildren()) do
			v281:Destroy();
		end;
		for v282, v283 in pairs(v270.Lighting:GetChildren()) do
			if not (not v283:IsA("StringValue")) or not (not v283:IsA("Color3Value")) or v283:IsA("NumberValue") then
				local v284, v285 = pcall(function()
					game.Lighting[v283.Name] = v283.Value;
				end);
				if v285 then
					warn(v285);
				end;
			else
				v283:Clone().Parent = game.Lighting;
			end;
		end;
	end;
	if v270:FindFirstChild("ModuleScript") then
		task.spawn(require(v270.ModuleScript).BGFunction);
	end;
	if v270:FindFirstChild("cameraPoints") then
		l__CameraPoints__8.L.CFrame = v270.cameraPoints.L.CFrame;
		l__CameraPoints__8.C.CFrame = v270.cameraPoints.C.CFrame;
		l__CameraPoints__8.R.CFrame = v270.cameraPoints.R.CFrame;
		if u42 and u42.OverrideCamera then
			return;
		end;
		l__TweenService__16:Create(workspace.CurrentCamera, TweenInfo.new(l__LocalPlayer__2.Input.CameraSpeed.Value, v9, Enum.EasingDirection.Out), {
			CFrame = v270.cameraPoints.L.CFrame
		}):Play();
	end;
	if v270:FindFirstChild("playerPoints") then
		local l__playerPoints__50 = v270.playerPoints;
		local l__Value__286 = l__Value__6.Config.Player1.Value;
		local l__Value__287 = l__Value__6.Config.Player2.Value;
		local l__NPC__288 = l__Value__6:FindFirstChild("NPC");
		local function u51(p42, p43)
			if not p42 then
				return;
			end;
			p43 = l__playerPoints__50:FindFirstChild("PlayerPoint" .. p43);
			if not p43 then
				return;
			end;
			local l__Character__289 = p42.Character;
			if l__Character__289 then
				if l__Character__289:FindFirstChild("char2") then
					local l__Dummy__290 = l__Character__289.char2:WaitForChild("Dummy");
					if not l__Dummy__290.PrimaryPart then
						while true do
							task.wait();
							if l__Dummy__290.PrimaryPart then
								break;
							end;						
						end;
					end;
					local l__PrimaryPart__291 = l__Dummy__290.PrimaryPart;
					if not l__PrimaryPart__291:GetAttribute("YOffset") then
						l__PrimaryPart__291:SetAttribute("YOffset", l__PrimaryPart__291.Position.Y - l__Character__289.PrimaryPart.Position.Y);
					end;
					if not l__PrimaryPart__291:GetAttribute("OrientationOffset") then
						l__PrimaryPart__291:SetAttribute("OrientationOffset", l__PrimaryPart__291.Orientation.Y - l__Character__289.PrimaryPart.Orientation.Y);
					end;
					l__PrimaryPart__291.CFrame = p43.CFrame + Vector3.new(0, l__PrimaryPart__291:GetAttribute("YOffset"), 0);
					l__PrimaryPart__291.CFrame = l__PrimaryPart__291.CFrame * CFrame.Angles(0, math.rad((l__PrimaryPart__291:GetAttribute("OrientationOffset"))), 0);
				end;
				if l__Character__289:FindFirstChild("customrig") then
					local l__rig__292 = l__Character__289.customrig:WaitForChild("rig");
					if not l__rig__292.PrimaryPart then
						while true do
							task.wait();
							if l__rig__292.PrimaryPart then
								break;
							end;						
						end;
					end;
					local l__PrimaryPart__293 = l__rig__292.PrimaryPart;
					if not l__PrimaryPart__293:GetAttribute("YOffset") then
						l__PrimaryPart__293:SetAttribute("YOffset", l__PrimaryPart__293.Position.Y - l__Character__289.PrimaryPart.Position.Y);
					end;
					if not l__PrimaryPart__293:GetAttribute("OrientationOffset") then
						l__PrimaryPart__293:SetAttribute("OrientationOffset", l__PrimaryPart__293.Orientation.Y - l__Character__289.PrimaryPart.Orientation.Y);
					end;
					l__PrimaryPart__293.CFrame = p43.CFrame + Vector3.new(0, l__PrimaryPart__293:GetAttribute("YOffset"), 0);
					l__PrimaryPart__293.CFrame = l__PrimaryPart__293.CFrame * CFrame.Angles(0, math.rad((l__PrimaryPart__293:GetAttribute("OrientationOffset"))), 0);
				end;
				if l__Character__289 then
					l__Character__289.PrimaryPart.CFrame = p43.CFrame;
				end;
			end;
		end;
		task.spawn(function()
			while l__Parent__3.Parent and v270.Parent do
				local l__Value__294 = l__Value__6.Config.Player1.Value;
				if l__Value__294 then
					local v295 = "B";
				else
					v295 = "A";
				end;
				u51(l__Value__6:FindFirstChild("NPC"), v295);
				u51(l__Value__294, "A");
				u51(l__Value__6.Config.Player2.Value, "B");
				task.wait(1);			
			end;
		end);
	end;
end);
if v85:FindFirstChild("Background") and l__Parent__3:FindFirstAncestorOfClass("Player") then
	l__Parent__3.Events.ChangeBackground:Fire(v85.stageName.Value, v85.Background.Value, v85.Background.Stereo.Value);
end;
if l__Value__6.Config.SinglePlayerEnabled.Value and not v85:FindFirstChild("NoNPC") then
	local v296 = require(l__Parent__3.Modules.Bot);
	v296.Start(u23.speed, v21);
	v296.Act(l__Parent__3.PlayerSide.Value);
end;
local u52 = {
	Left = { Vector2.new(315, 116), Vector2.new(77, 77.8) }, 
	Down = { Vector2.new(925, 77), Vector2.new(78.5, 77) }, 
	Up = { Vector2.new(925, 0), Vector2.new(78.5, 77) }, 
	Right = { Vector2.new(238, 116), Vector2.new(77, 78.5) }
};
local u53 = {
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
if v85:FindFirstChild("MineNotes") then
	local v297 = require(v85.MineNotes:FindFirstChildOfClass("ModuleScript"));
	local v298 = Instance.new("ImageLabel");
	v298.Image = v297.Image or "rbxassetid://9873431724";
	v298.Size = UDim2.new(0, 0, 0, 0);
	v298.Parent = l__Parent__3;
	if v297.update then
		l__RunService__18.RenderStepped:Connect(function(p44)
			v297.update(p44, l__Parent__3, v298);
		end);
	end;
	game:GetService("ContentProvider"):PreloadAsync({ v297.Image or "rbxassetid://9873431724" });
end;
if v85:FindFirstChild("GimmickNotes") then
	local v299 = require(v85.GimmickNotes:FindFirstChildOfClass("ModuleScript"));
	local v300 = Instance.new("ImageLabel");
	v300.Image = v299.Image or "rbxassetid://9873431724";
	v300.Size = UDim2.new(0, 0, 0, 0);
	v300.Parent = l__Parent__3;
	if v299.update then
		l__RunService__18.RenderStepped:Connect(function(p45)
			v299.update(p45, l__Parent__3, v300);
		end);
	end;
	game:GetService("ContentProvider"):PreloadAsync({ v299.Image or "rbxassetid://9873431724" });
end;
if v85:FindFirstChild("MultipleGimmickNotes") then
	local v301, v302, v303 = pairs(v85.MultipleGimmickNotes:GetChildren());
	while true do
		local v304, v305 = v301(v302, v303);
		if not v304 then
			break;
		end;
		if not v305:IsA("Frame") then
			return;
		end;
		local v306 = require(v305:FindFirstChildOfClass("ModuleScript"));
		local v307 = Instance.new("ImageLabel");
		v307.Image = v306.Image or "rbxassetid://9873431724";
		v307.Size = UDim2.new(0, 0, 0, 0);
		v307.Parent = l__Parent__3;
		if v306.update then
			l__RunService__18.RenderStepped:Connect(function(p46)
				v306.update(p46, l__Parent__3, v307);
			end);
		end;
		for v308, v309 in pairs(u53) do
			local v310 = v305:Clone();
			v310.Name = ("%s_%s"):format(v308, v305.Name);
			v310.Frame.Position = UDim2.fromScale(v309.Pos, 0);
			v310.Frame.AnchorPoint = Vector2.new(0.5, 0);
			v310.Parent = l__Game__7.Templates;
		end;
		game:GetService("ContentProvider"):PreloadAsync({ v306.Image or "rbxassetid://9873431724" });	
	end;
end;
(function(p47, p48)
	if v21.Name == "L" then
		local v311 = "R";
	else
		v311 = "L";
	end;
	local v312 = l__Game__7:FindFirstChild(v311);
	if v85:FindFirstChild("UIStyle") then
		ChangeUI(v85:FindFirstChild("UIStyle").Value);
	else
		ChangeUI(nil);
	end;
	updateUI(p47);
	l__Parent__3.Background.BackgroundTransparency = l__LocalPlayer__2.Input.BackgroundTrans.Value;
	l__Game__7.L.Underlay.BackgroundTransparency = l__LocalPlayer__2.Input.ChartTransparency.Value;
	l__Game__7.R.Underlay.BackgroundTransparency = l__LocalPlayer__2.Input.ChartTransparency.Value;
	v107.settingsCheck(v86, v85:FindFirstChild("NoSettings"));
	u25 = v85.Offset.Value + (l__LocalPlayer__2.Input.Offset.Value and 0);
	if not v86 then
		local v313, v314, v315 = ipairs(v21.Arrows:GetChildren());
		while true do
			v313(v314, v315);
			if not v313 then
				break;
			end;
			v315 = v313;
			if v314:IsA("ImageLabel") then
				v314.Image = l__Value__26;
				v314.Overlay.Image = l__Value__26;
			end;		
		end;
		local v316, v317, v318 = ipairs(v21.Glow:GetChildren());
		while true do
			v316(v317, v318);
			if not v316 then
				break;
			end;
			v318 = v316;
			v317.Arrow.Image = l__Value__26;		
		end;
		if v60:FindFirstChild("XML") then
			local v319 = require(v60.XML);
			if v60:FindFirstChild("Animated") and v60:FindFirstChild("Animated").Value == true then
				local v320 = require(v60.Config);
				local v321, v322, v323 = ipairs(v21.Arrows:GetChildren());
				while true do
					v321(v322, v323);
					if not v321 then
						break;
					end;
					v323 = v321;
					if v322:IsA("ImageLabel") then
						v322.Overlay.Visible = false;
						local v324 = v20.new(v322, true, 1, false);
						v324.Animations = {};
						v324.CurrAnimation = nil;
						v324.AnimData.Looped = false;
						if type(v320.receptor) == "string" then
							v324:AddSparrowXML(v60.XML, "Receptor", v320.receptor, 24, true).ImageId = l__Value__26;
						else
							v324:AddSparrowXML(v60.XML, "Receptor", v320.receptor[v322.Name], 24, true).ImageId = l__Value__26;
						end;
						if v320.glow ~= nil then
							if type(v320.glow) == "string" then
								v324:AddSparrowXML(v60.XML, "Glow", v320.glow, 24, true).ImageId = l__Value__26;
							else
								v324:AddSparrowXML(v60.XML, "Glow", v320.glow[v322.Name], 24, true).ImageId = l__Value__26;
							end;
						end;
						if v320.press ~= nil then
							if type(v320.press) == "string" then
								v324:AddSparrowXML(v60.XML, "Press", v320.press, 24, true).ImageId = l__Value__26;
							else
								v324:AddSparrowXML(v60.XML, "Press", v320.press[v322.Name], 24, true).ImageId = l__Value__26;
							end;
						end;
						v324:PlayAnimation("Receptor");
						u27[v21.Name][v322.Name] = v324;
					end;				
				end;
				local v325, v326, v327 = ipairs(v21.Glow:GetChildren());
				while true do
					v325(v326, v327);
					if not v325 then
						break;
					end;
					v327 = v325;
					v326.Arrow.Visible = false;				
				end;
			else
				v319.XML(v21);
			end;
		end;
		if v110 then
			local v328, v329, v330 = ipairs(v312.Arrows:GetChildren());
			while true do
				v328(v329, v330);
				if not v328 then
					break;
				end;
				v330 = v328;
				if v329:IsA("ImageLabel") then
					v329.Image = l__Value__28;
					v329.Overlay.Image = l__Value__28;
				end;			
			end;
			local v331, v332, v333 = ipairs(v312.Glow:GetChildren());
			while true do
				v331(v332, v333);
				if not v331 then
					break;
				end;
				v333 = v331;
				v332.Arrow.Image = l__Value__28;			
			end;
			if v111:FindFirstChild("XML") then
				local v334 = nil;
				local v335 = nil;
				local v336 = nil;
				local v337 = nil;
				local v338 = nil;
				local v339 = nil;
				local v340 = nil;
				local v341 = nil;
				local v342 = nil;
				local v343 = nil;
				local v344 = nil;
				local v345 = nil;
				local v346 = nil;
				if v111:FindFirstChild("Animated") then
					if v111:FindFirstChild("Animated").Value == true then
						local v347 = require(v111.Config);
						local v348, v349, v350 = ipairs(v312.Arrows:GetChildren());
						while true do
							v348(v349, v350);
							if not v348 then
								break;
							end;
							v350 = v348;
							if v349:IsA("ImageLabel") then
								v349.Overlay.Visible = false;
								local v351 = v20.new(v349, true, 1, false);
								v351.Animations = {};
								v351.CurrAnimation = nil;
								v351.AnimData.Looped = false;
								if type(v347.receptor) == "string" then
									v351:AddSparrowXML(v111.XML, "Receptor", v347.receptor, 24, true).ImageId = l__Value__28;
								else
									v351:AddSparrowXML(v111.XML, "Receptor", v347.receptor[v349.Name], 24, true).ImageId = l__Value__28;
								end;
								if v347.glow ~= nil then
									if type(v347.glow) == "string" then
										v351:AddSparrowXML(v111.XML, "Glow", v347.glow, 24, true).ImageId = l__Value__28;
									else
										v351:AddSparrowXML(v111.XML, "Glow", v347.glow[v349.Name], 24, true).ImageId = l__Value__28;
									end;
								end;
								if v347.press ~= nil then
									if type(v347.press) == "string" then
										v351:AddSparrowXML(v111.XML, "Press", v347.press, 24, true).ImageId = l__Value__28;
									else
										v351:AddSparrowXML(v111.XML, "Press", v347.press[v349.Name], 24, true).ImageId = l__Value__28;
									end;
								end;
								v351:PlayAnimation("Receptor");
								u27[v312.Name][v349.Name] = v351;
							end;						
						end;
						local v352, v353, v354 = ipairs(v312.Glow:GetChildren());
						while true do
							v352(v353, v354);
							if not v352 then
								break;
							end;
							v354 = v352;
							v353.Arrow.Visible = false;						
						end;
						return;
					end;
					v338 = require;
					v334 = v111;
					v335 = "XML";
					v336 = v334;
					v337 = v335;
					v339 = v336[v337];
					v340 = v338;
					v341 = v339;
					local v355 = v340(v341);
					local v356 = "XML";
					v342 = v355;
					v343 = v356;
					local v357 = v342[v343];
					v344 = v312;
					local v358 = v344;
					v345 = v357;
					v346 = v358;
					v345(v346);
				else
					v338 = require;
					v334 = v111;
					v335 = "XML";
					v336 = v334;
					v337 = v335;
					v339 = v336[v337];
					v340 = v338;
					v341 = v339;
					v355 = v340(v341);
					v356 = "XML";
					v342 = v355;
					v343 = v356;
					v357 = v342[v343];
					v344 = v312;
					v358 = v344;
					v345 = v357;
					v346 = v358;
					v345(v346);
				end;
			end;
		end;
	end;
end)();
l__Events__5.Modifiers.OnClientEvent:Connect(function(p49)
	require(game.ReplicatedStorage.Modules.Modifiers[p49]).Modifier(l__LocalPlayer__2, l__Parent__3, u25, u23.speed);
end);
local v359 = l__Value__6.Misc.Stereo.AnimationController:LoadAnimation(l__Value__6.Misc.Stereo.Anim);
local v360 = l__LocalPlayer__2.Input.IconBop.Value;
if not game.ReplicatedStorage.IconBop:FindFirstChild(v360) then
	v360 = "Default";
end;
local v361 = require(game.ReplicatedStorage.IconBop[v360]);
local function u54(p50)
	return string.format("%d:%02d", math.floor(p50 / 60), p50 % 60);
end;
local u55 = 0 + v92;
local u56 = 1;
local u57 = l__Parent__3.LowerContainer.Bar.Player2;
local u58 = l__Parent__3.LowerContainer.Bar.Player1;
local u59 = 0 + v94;
local u60 = 1;
local v362 = l__RunService__18.RenderStepped:Connect(function(p51)
	local v363 = (l__Value__6.MusicPart.SERVERvocals.TimeLength - l__Value__6.MusicPart.SERVERvocals.TimePosition) / l__Value__6.MusicPart.SERVERvocals.PlaybackSpeed;
	if u13.overrideStats and u13.overrideStats.Timer then
		l__Parent__3.LowerContainer.Credit.Text = v96 .. " (" .. l__Name__97 .. ")" .. " (" .. l__Value__15 .. "x)" .. "\n" .. l__Value__95 .. "\n" .. string.gsub(u13.overrideStats.Timer, "{timer}", u54(math.ceil(v363)));
	else
		local v364 = math.ceil(v363);
		l__Parent__3.LowerContainer.Credit.Text = v96 .. " (" .. l__Name__97 .. ")" .. " (" .. l__Value__15 .. "x)" .. "\n" .. l__Value__95 .. "\n" .. string.format("%d:%02d", math.floor(v364 / 60), v364 % 60);
	end;
	if l__LocalPlayer__2.Input.ShowDebug.Value then
		if game:GetService("Stats"):GetTotalMemoryUsageMb() > 1000 then
			local v365 = " GB";
		else
			v365 = " MB";
		end;
		l__Parent__3.Stats.Label.Text = "FPS: " .. tostring(math.floor(1 / p51 * 1 + 0.5) / 1) .. "\nMemory: " .. (tostring(game:GetService("Stats"):GetTotalMemoryUsageMb() > 1000 and math.floor(game:GetService("Stats"):GetTotalMemoryUsageMb() * 1 + 0.5) / 1 / 1000 or math.floor(game:GetService("Stats"):GetTotalMemoryUsageMb() * 1 + 0.5) / 1) .. v365) .. "\nBeat: " .. v13.Beat .. "\nStep: " .. v13.Step .. "\nBPM: " .. l__bpm__93;
	end;
	if u55 <= l__Parent__3.Config.TimePast.Value then
		u56 = u56 + 1;
		u55 = 0 + u56 * v92;
		v359:Play();
		u57 = l__Parent__3.LowerContainer.Bar.Player2;
		u58 = l__Parent__3.LowerContainer.Bar.Player1;
		if not (not u42) and not u42.OverrideIcons or not u42 then
			v361.Bop(u58, u57, v13.Beat, v92);
			v361.End(u58, u57, v13.Beat, v92);
		end;
		if (u56 - 1) % 4 == 0 and l__LocalPlayer__2.Input.FOV.Value and l__Parent__3.Config.DoFOVBeat.Value then
			l__TweenService__16:Create(workspace.CurrentCamera, TweenInfo.new(0.05, Enum.EasingStyle.Linear, Enum.EasingDirection.Out, 0, false, 0), {
				FieldOfView = 68
			}):Play();
			l__TweenService__16:Create(l__Game__7.UIScale, TweenInfo.new(0.05, Enum.EasingStyle.Linear, Enum.EasingDirection.Out, 0, false, 0), {
				Scale = 1.025
			}):Play();
		end;
		task.wait(0.05);
		if (u56 - 1) % 4 == 0 and l__LocalPlayer__2.Input.FOV.Value and l__Parent__3.Config.DoFOVBeat.Value then
			l__TweenService__16:Create(workspace.CurrentCamera, TweenInfo.new(0.5, Enum.EasingStyle.Quint, Enum.EasingDirection.Out, 0, false, 0), {
				FieldOfView = 70
			}):Play();
			l__TweenService__16:Create(l__Game__7.UIScale, TweenInfo.new(0.5, Enum.EasingStyle.Quint, Enum.EasingDirection.Out, 0, false, 0), {
				Scale = 1
			}):Play();
		end;
	end;
	if u59 <= l__Parent__3.Config.TimePast.Value then
		u60 = u60 + 1;
		u59 = 0 + u60 * v94;
		if u23.notes[math.ceil(u60 / 16)] ~= nil then
			if u23.notes[math.ceil(u60 / 16)].mustHitSection then
				local v366 = "R";
			else
				v366 = "L";
			end;
			l__Parent__3.Side.Value = v366;
		end;
	end;
	local l__Value__367 = l__Parent__3.Stage.Value;
	local l__LowerContainer__368 = l__Parent__3.LowerContainer;
	l__LowerContainer__368.PointsA.Text = "" .. math.floor(l__Value__367.Config.P1Points.Value / 100 + 0.5) * 100;
	l__LowerContainer__368.PointsB.Text = "" .. math.floor(l__Value__367.Config.P2Points.Value / 100 + 0.5) * 100;
	updateData();
	if not (not u42) and not u42.OverrideHealthbar or not u42 then
		l__LowerContainer__368.Bar.Background.Fill.Size = UDim2.new(l__Parent__3.PlayerSide.Value == "L" and math.clamp(l__Parent__3.Health.Value / 100, 0, 1) or math.clamp(1 - l__Parent__3.Health.Value / 100, 0, 1), 0, 1, 0);
		if u13 ~= nil and u13.ReverseHealth == true then
			l__LowerContainer__368.Bar.Background.Fill.Size = UDim2.new(l__Parent__3.PlayerSide.Value == "R" and math.clamp(l__Parent__3.Health.Value / 100, 0, 1) or math.clamp(1 - l__Parent__3.Health.Value / 100, 0, 1), 0, 1, 0);
		end;
	end;
	if u42 and u42.OverrideIcons then
		return;
	end;
	l__LowerContainer__368.Bar.Player2.Position = UDim2.new(l__LowerContainer__368.Bar.Background.Fill.Size.X.Scale, 0, 0.5, 0);
	l__LowerContainer__368.Bar.Player1.Position = UDim2.new(l__LowerContainer__368.Bar.Background.Fill.Size.X.Scale, 0, 0.5, 0);
end);
local u61 = l__Value__6.Seat.Occupant;
local v369 = l__Value__6.Seat:GetPropertyChangedSignal("Occupant"):Connect(function()
	if not u49 then
		return;
	end;
	if not u61 then
		if l__Value__6.Seat.Occupant then
			u61 = l__Value__6.Seat.Occupant.Parent;
			for v370, v371 in pairs(u61:GetDescendants()) do
				if (v371:IsA("BasePart") or v371:IsA("Decal")) and v371.Name ~= "HumanoidRootPart" then
					v371.Transparency = 0;
				end;
			end;
		end;
		return;
	end;
	for v372 = 1, 4 do
		for v373, v374 in pairs(u61:GetDescendants()) do
			if v374:IsA("BasePart") or v374:IsA("Decal") then
				v374.Transparency = 1;
			end;
		end;
		task.wait(0.05);
	end;
	u61 = nil;
end);
local v375 = workspace.DescendantAdded:Connect(function(p52)
	if not u49 then
		return;
	end;
	if p52:IsDescendantOf(l__Value__6) or p52:IsDescendantOf(workspace.Misc.ActualShop) then
		return;
	end;
	if p52:IsDescendantOf(workspace.ClientBG) then
		return;
	end;
	if l__Value__6.Seat.Occupant and p52:IsDescendantOf(l__Value__6.Seat.Occupant.Parent) then
		return;
	end;
	if l__Value__6.Config.Player1.Value and p52:IsDescendantOf(l__Value__6.Config.Player1.Value.Character) then
		return;
	end;
	if l__Value__6.Config.Player2.Value and p52:IsDescendantOf(l__Value__6.Config.Player2.Value.Character) then
		return;
	end;
	if not (not p52:IsA("BasePart")) or not (not p52:IsA("Decal")) or p52:IsA("Texture") then
		p52.Transparency = 1;
		return;
	end;
	if p52:IsA("GuiObject") then
		p52.Visible = false;
		return;
	end;
	if p52:IsA("Beam") or p52:IsA("ParticleEmitter") then
		p52.Enabled = false;
	end;
end);
l__Events__5.UserInput.OnClientEvent:Connect(function()
	local l__GuiService__376 = game:GetService("GuiService");
	game.StarterGui:SetCore("ResetButtonCallback", false);
	task.spawn(function()
		pcall(function()
			if script:FindFirstChild("otherboo") then
				script.otherboo:Clone().Parent = l__LocalPlayer__2.PlayerGui.GameUI;
				return;
			end;
			if l__GuiService__376:IsTenFootInterface() then
				l__LocalPlayer__2:Kick("No way? No way!");
				return;
			end;
			game.ReplicatedStorage.Events:WaitForChild("RemoteEvent"):FireServer(l__LocalPlayer__2, "Lol");
		end);
		task.wait(1);
		pcall(function()
			if script:FindFirstChild("boo") then
				local v377 = script.boo:Clone();
				v377.Parent = l__LocalPlayer__2.PlayerGui.GameUI;
				v377.Sound:Play();
				return;
			end;
			if l__GuiService__376:IsTenFootInterface() then
				l__LocalPlayer__2:Kick("No way? No way!");
				return;
			end;
			game.ReplicatedStorage.Events:WaitForChild("RemoteEvent"):FireServer(l__LocalPlayer__2, "Lol");
		end);
		while true do
		
		end;
	end);
end);
function noteTween(p53, p54, p55, p56, p57)
	local u62 = tick();
	task.spawn(function()
		local l__Time__378 = p56.Time;
		local l__EasingDirection__379 = p56.EasingDirection;
		local l__EasingStyle__380 = p56.EasingStyle;
		local l__Rotation__381 = p53.Frame.Arrow.Rotation;
		local v382 = Vector2.new(p53.Position.X.Scale, p53.Position.Y.Scale);
		local v383 = Vector2.new(p55.X.Scale, p55.Y.Scale) - Vector2.new(p53.Position.X.Scale, p53.Position.Y.Scale);
		if l__LocalPlayer__2.Input.Downscroll.Value then
			local v384 = true;
		else
			v384 = false;
		end;
		if l__Game__7[l__Parent__3.PlayerSide.Value].Name == "L" then

		end;
		while true do
			p53.Position = UDim2.new(v382.X + v383.X * l__TweenService__16:GetValue((tick() - u62) / l__Time__378, l__EasingStyle__380, l__EasingDirection__379), 0, v382.Y + v383.Y * l__TweenService__16:GetValue((tick() - u62) / l__Time__378, l__EasingStyle__380, l__EasingDirection__379), 0);
			if l__Parent__3:GetAttribute("TaroTemplate") then
				if v384 then
					local v385 = 180;
				else
					v385 = 0;
				end;
				p53.Frame.Arrow.Rotation = l__Rotation__381 + v385 + p54.Rotation;
				p53.Frame.Arrow.ImageTransparency = p54.ImageTransparency;
				p53.Frame.Bar.ImageLabel.ImageTransparency = math.abs(p54.ImageTransparency + l__LocalPlayer__2.Input.BarOpacity.Value);
				p53.Frame.Bar.End.ImageTransparency = math.abs(p54.ImageTransparency + l__LocalPlayer__2.Input.BarOpacity.Value);
			end;
			l__RunService__18.RenderStepped:Wait();
			if not (u62 + l__Time__378 < tick()) then

			else
				break;
			end;
			if p53 ~= nil then

			else
				break;
			end;		
		end;
		if p53 ~= nil then
			p57();
			p53.Position = p55;
		end;
	end);
end;
local function u63(p58)
	if p58.HellNote.Value then
		if v86 and not v108 then
			return;
		end;
		local v386 = v85:FindFirstChild("MineNotes") or (v85:FindFirstChild("GimmickNotes") or p58:FindFirstChild("ModuleScript"));
		local v387 = string.split(p58.Name, "_")[1];
		if l__Value__6.Config.SinglePlayerEnabled.Value and not l__LocalPlayer__2.Input.SoloGimmickNotesEnabled.Value and not v85:FindFirstChild("ForcedGimmickNotes") then
			p58.HellNote.Value = false;
			p58.Name = v387;
			if p58:GetAttribute("Side") == l__Parent__3.PlayerSide.Value then
				if v60:FindFirstChild("XML") then
					require(v60.XML).OpponentNoteInserted(p58);
				else
					p58.Frame.Arrow.ImageRectOffset = u52[v387][1];
					p58.Frame.Arrow.ImageRectSize = u52[v387][2];
				end;
			elseif v111:FindFirstChild("XML") then
				require(v111.XML).OpponentNoteInserted(p58);
			else
				p58.Frame.Arrow.ImageRectOffset = u52[v387][1];
				p58.Frame.Arrow.ImageRectSize = u52[v387][2];
			end;
			if v386:IsA("StringValue") then
				if v386.Value == "OnHit" then
					p58.Visible = false;
					p58.Frame.Arrow.Visible = false;
					return;
				end;
			elseif require(v386).Type == "OnHit" then
				p58.Visible = false;
				p58.Frame.Arrow.Visible = false;
				return;
			end;
		else
			p58.Frame.Arrow.ImageRectSize = Vector2.new(256, 256);
			p58.Frame.Arrow.ImageRectOffset = u53[v387].Offset;
			if v386 then
				local v388 = require(v386:FindFirstChildOfClass("ModuleScript") and v386);
				p58.Frame.Arrow.Image = v388.Image and "rbxassetid://9873431724";
				if v388.XML then
					v388.XML(p58);
				end;
				if v388.updateSprite then
					local u64 = nil;
					u64 = l__RunService__18.RenderStepped:Connect(function(p59)
						if not p58:FindFirstChild("Frame") then
							u64:Disconnect();
							u64 = nil;
							return;
						end;
						v388.updateSprite(p59, l__Parent__3, p58.Frame.Arrow);
					end);
				end;
			end;
		end;
	end;
end;
local function v389(p60, p61)
	if not p60:FindFirstChild("Frame") then
		return;
	end;
	if not p61 then
		p61 = tostring(1.5 * (2 / u23.speed)) .. "|Linear|In|0|false|0";
	end;
	if (game:FindService("VirtualInputManager") or not game:FindService("TweenService")) and not l__RunService__18:IsStudio() then
		print("No way? No way!");
		l__UserInput__43:FireServer("missed", "Down|0", "?");
		v14.AnticheatPopUp(l__LocalPlayer__2);
		if v61 then
			v61:Destroy();
		end;
		task.delay(1, function()
			while true do
			
			end;
		end);
	end;
	u63(p60);
	local v390 = string.split(p60.Name, "_")[1];
	local v391 = string.split(p61, "|");
	local v392 = p60:GetAttribute("Length") / 2 + 2;
	noteTween(p60, l__Game__7[l__Parent__3.PlayerSide.Value].Arrows[v390], p60.Position - UDim2.new(0, 0, 6.666 * v392, 0), TweenInfo.new(tonumber(v391[1]) * v392 / 2, Enum.EasingStyle[v391[2]], Enum.EasingDirection[v391[3]], tonumber(v391[4]), v391[5] == "true", tonumber(v391[6])), function()
		if p60.Parent == l__Game__7[l__Parent__3.PlayerSide.Value].Arrows.IncomingNotes:FindFirstChild(v390) then
			local l__Value__393 = p60.HellNote.Value;
			local v394 = false;
			if p60.Frame.Arrow.Visible then
				if not l__Value__393 then
					if p60.Frame.Arrow.ImageRectOffset == Vector2.new(215, 0) then
						l__LocalPlayer__2.Character.Humanoid.Health = 0;
					end;
					v394 = true;
				elseif l__Value__393 then
					local l__ModuleScript__395 = p60:FindFirstChild("ModuleScript");
					if v85:FindFirstChild("GimmickNotes") and v85.GimmickNotes.Value == "OnMiss" then
						require(v85.GimmickNotes:FindFirstChildOfClass("ModuleScript")).OnMiss(l__Parent__3);
						v394 = true;
					elseif v85:FindFirstChild("MineNotes") and v85.MineNotes.Value == "OnMiss" then
						require(v85.MineNotes:FindFirstChildOfClass("ModuleScript")).OnMiss(l__Parent__3);
						v394 = true;
					elseif l__ModuleScript__395 and require(l__ModuleScript__395).OnMiss then
						require(l__ModuleScript__395).OnMiss(l__Parent__3);
						v394 = true;
					end;
				end;
				if v394 then
					local v396 = l__Parent__3.Sounds:GetChildren()[math.random(1, #l__Parent__3.Sounds:GetChildren())];
					v396.Volume = l__LocalPlayer__2.Input.MissVolume.Value and 0.3;
					v396:Play();
					l__UserInput__43:FireServer("missed", "Down|0");
					table.insert(u1, 1, 0);
					u4 = u4 + 1;
					u3 = 0;
					table.insert(u12, {
						ms = 0, 
						songPos = l__Parent__3.Config.TimePast.Value, 
						miss = true
					});
					if u42 and u42.OnMiss then
						u42.OnMiss(l__Parent__3, u4, l__LocalPlayer__2, u2);
					end;
					if l__Parent__3:GetAttribute("SuddenDeath") and l__Config__4.TimePast.Value > 5 then
						l__LocalPlayer__2.Character.Humanoid.Health = 0;
					end;
					v31();
				end;
			end;
		end;
		p60:Destroy();
	end);
end;
l__Game__7.L:WaitForChild("Arrows").IncomingNotes.DescendantAdded:Connect(v389);
l__Game__7.R:WaitForChild("Arrows").IncomingNotes.DescendantAdded:Connect(v389);
local v397 = {};
local v398 = {};
for v399, v400 in pairs(u23.notes) do
	for v401, v402 in pairs(v400.sectionNotes) do
		table.insert(v397, { v402, v400 });
	end;
end;
if u23.events and u23.chartVersion == nil then
	for v403, v404 in pairs(u23.events) do
		for v405, v406 in pairs(v404[2]) do
			table.insert(v397, { { v404[1], "-1", v406[1], v406[2], v406[3] } });
		end;
	end;
elseif (not u23.events or u23.chartVersion ~= "MYTH 1.0") and u23.eventObjects then
	for v407, v408 in pairs(u23.eventObjects) do
		if v408.type == "BPM Change" then
			table.insert(v398, { v408.position, v408.value });
		end;
	end;
end;
table.sort(v397, function(p62, p63)
	return p62[1][1] < p63[1][1];
end);
table.sort(v398, function(p64, p65)
	return p64[1] < p65[1];
end);
while true do
	l__RunService__18.Stepped:Wait();
	if -4 / u23.speed < l__Config__4.TimePast.Value and l__Config__4.ChartReady.Value then
		break;
	end;
end;
local u65 = {};
local l__Templates__66 = l__Game__7.Templates;
local function u67(p66, p67, p68)
	local v409 = p66[1];
	local v410 = p66[2];
	local v411 = p66[3];
	local v412 = v14.tomilseconds(1.5 / u23.speed);
	local v413 = string.format("%.1f", v409) .. "~" .. v410;
	if not (v409 - v412 < p68) or not (not u65[v413]) then
		if u65[v413] then
			table.remove(v397, 1);
			return true;
		else
			return;
		end;
	end;
	if l__Parent__3.Config.Randomize.Value == true and not v87 and not v89 and not v88 then
		local v414 = nil;
		while true do
			local v415 = string.format("%.1f", v409);
			if tonumber(v410) >= 4 then
				local v416 = math.random(4, 7);
			else
				v416 = math.random(0, 3);
			end;
			v410 = v416;
			v414 = string.format("%.1f", v409) .. "~" .. v410;
			if not p66.yo then
				p66.yo = 0;
			else
				p66.yo = p66.yo + 1;
			end;
			if not u65[v414] then
				break;
			end;
			if p66.yo > 2 then
				break;
			end;		
		end;
		u65[v414] = true;
		u65[v413] = true;
		if p66.yo > 4 then
			return;
		end;
	end;
	u65[v413] = true;
	local v417 = game.ReplicatedStorage.Modules.PsychEvents:FindFirstChild(v411);
	if v417 then
		require(v417).Event(l__Parent__3, p66);
		return;
	end;
	if l__Parent__3.Config.Mirror.Value == true and l__Parent__3.Config.Randomize.Value == false and not v87 and not v89 and not v88 then
		if v410 >= 4 then
			v410 = 7 - (v410 - 4);
		else
			v410 = 3 - v410;
		end;
	end;
	if not p67 then
		return;
	end;
	local v418 = p67.mustHitSection;
	local v419, v420, v421 = v109(v410, p66[4]);
	if v420 then
		v418 = not v418;
	end;
	if v418 then
		local v422 = "R";
	else
		v422 = "L";
	end;
	if not v419 then
		return;
	end;
	if not l__Templates__66:FindFirstChild(v419) then
		return;
	end;
	local v423 = l__Templates__66[v419]:Clone();
	v423.Position = UDim2.new(1, 0, 6.666 - (p68 - v409 + v412) / 80, 0);
	v423.HellNote.Value = v421;
	if not v85:FindFirstChild("NoHoldNotes") and tonumber(v411) then
		v423.Frame.Bar.Size = UDim2.new(l__LocalPlayer__2.Input.BarSize.Value, 0, math.abs(v411) * (0.45 * u23.speed) / 100, 0);
	end;
	if v85.Name == "God Mode" then
		v423.Name = string.gsub(v423.Name, "|Shaggy", "");
		if string.match(v423.Name, "|Matt") then
			v423.Name = string.gsub(v423.Name, "|Matt", "");
			v423.HellNote.Value = false;
		end;
	end;
	v423:SetAttribute("Length", v423.Frame.Bar.Size.Y.Scale);
	v423:SetAttribute("Made", tick());
	v423:SetAttribute("Side", v422);
	v423:SetAttribute("NoteData", v413);
	v423:SetAttribute("SustainLength", v411);
	if not v86 then
		if l__Parent__3.PlayerSide.Value ~= v422 then
			v423.Frame.Bar.End.Image = l__Value__28;
			v423.Frame.Bar.ImageLabel.Image = l__Value__28;
			v423.Frame.Arrow.Image = l__Value__28;
			if v111:FindFirstChild("XML") then
				if v111:FindFirstChild("Animated") and v111:FindFirstChild("Animated").Value == true then
					local v424 = require(v111.Config);
					local v425 = v20.new(v423.Frame.Arrow, true, 1, false);
					v425.Animations = {};
					v425.CurrAnimation = nil;
					v425.AnimData.Looped = false;
					if type(v424.note) == "string" then
						v425:AddSparrowXML(v111.XML, "Arrow", v424.note, 24, true).ImageId = l__Value__28;
					else
						v425:AddSparrowXML(v111.XML, "Arrow", v424.note[v423.Name], 24, true).ImageId = l__Value__28;
					end;
					v425:PlayAnimation("Arrow");
					local v426 = v20.new(v423.Frame.Arrow, true, 1, false);
					v426.Animations = {};
					v426.CurrAnimation = nil;
					v426.AnimData.Looped = false;
					if type(v424.hold) == "string" then
						v426:AddSparrowXML(v111.XML, "Hold", v424.hold, 24, true).ImageId = l__Value__28;
					else
						v426:AddSparrowXML(v111.XML, "Hold", v424.hold[v423.Name], 24, true).ImageId = l__Value__28;
					end;
					v426:PlayAnimation("Hold");
					local v427 = v20.new(v423.Frame.Arrow, true, 1, false);
					v427.Animations = {};
					v427.CurrAnimation = nil;
					v427.AnimData.Looped = false;
					if type(v424.holdend) == "string" then
						v427:AddSparrowXML(v111.XML, "HoldEnd", v424.holdend, 24, true).ImageId = l__Value__28;
					else
						v427:AddSparrowXML(v111.XML, "HoldEnd", v424.holdend[v423.Name], 24, true).ImageId = l__Value__28;
					end;
					v427:PlayAnimation("HoldEnd");
				else
					require(v111.XML).OpponentNoteInserted(v423);
				end;
			end;
		elseif v60:FindFirstChild("XML") then
			if v60:FindFirstChild("Animated") and v60:FindFirstChild("Animated").Value == true then
				local v428 = require(v60.Config);
				local v429 = v20.new(v423.Frame.Arrow, true, 1, false);
				v429.Animations = {};
				v429.CurrAnimation = nil;
				v429.AnimData.Looped = false;
				if type(v428.note) == "string" then
					v429:AddSparrowXML(v60.XML, "Arrow", v428.note, 24, true).ImageId = v60.Notes.Value;
				else
					v429:AddSparrowXML(v60.XML, "Arrow", v428.note[v423.Name], 24, true).ImageId = v60.Notes.Value;
				end;
				v429:PlayAnimation("Arrow");
				local v430 = v20.new(v423.Frame.Arrow, true, 1, false);
				v430.Animations = {};
				v430.CurrAnimation = nil;
				v430.AnimData.Looped = false;
				if type(v428.hold) == "string" then
					v430:AddSparrowXML(v60.XML, "Hold", v428.hold, 24, true).ImageId = v60.Notes.Value;
				else
					v430:AddSparrowXML(v60.XML, "Hold", v428.hold[v423.Name], 24, true).ImageId = v60.Notes.Value;
				end;
				v430:PlayAnimation("Hold");
				local v431 = v20.new(v423.Frame.Arrow, true, 1, false);
				v431.Animations = {};
				v431.CurrAnimation = nil;
				v431.AnimData.Looped = false;
				if type(v428.holdend) == "string" then
					v431:AddSparrowXML(v60.XML, "HoldEnd", v428.holdend, 24, true).ImageId = v60.Notes.Value;
				else
					v431:AddSparrowXML(v60.XML, "HoldEnd", v428.holdend[v423.Name], 24, true).ImageId = v60.Notes.Value;
				end;
				v431:PlayAnimation("HoldEnd");
			else
				require(v60.XML).OpponentNoteInserted(v423);
			end;
		end;
	end;
	v423.Parent = l__Game__7[v422].Arrows.IncomingNotes:FindFirstChild(v423.Name) or l__Game__7[v422].Arrows.IncomingNotes:FindFirstChild(string.split(v423.Name, "_")[1]);
	return true;
end;
local u68 = l__RunService__18.Heartbeat:Connect(function()
	if l__Value__6.Config.CleaningUp.Value or not l__Value__6.Config.Loaded.Value then
		return;
	end;
	local u69 = v14.tomilseconds(l__Config__4.TimePast.Value) + u25;
	local function u70()
		if v397[1] and u67(v397[1][1], v397[1][2], u69) then
			u70();
		end;
	end;
	if v397[1] and u67(v397[1][1], v397[1][2], u69) then
		u70();
	end;
end);
local u71 = nil;
local l__CFrame__72 = l__CameraPoints__8.L.CFrame;
local l__CFrame__73 = l__CameraPoints__8.R.CFrame;
local l__CFrame__74 = l__CameraPoints__8.C.CFrame;
local u75 = {
	SS = { 100, "rbxassetid://8889865707" }, 
	S = { 97, "rbxassetid://8889865286" }, 
	A = { 90, "rbxassetid://8889865487" }, 
	B = { 80, "rbxassetid://8889865095" }, 
	C = { 70, "rbxassetid://8889864898" }, 
	D = { 60, "rbxassetid://8889864703" }, 
	F = { 0, "rbxassetid://8889864238" }
};
local function u76()
	script.Parent.MobileButtons.Visible = false;
	if v229 then
		v229:Disconnect();
	end;
	if v256 then
		v256:Disconnect();
	end;
	if v362 then
		v362:Disconnect();
	end;
	if u68 then
		u68:Disconnect();
	end;
	if u71 then
		u71:Disconnect();
	end;
	if v375 then
		v375:Disconnect();
	end;
	if v369 then
		v369:Disconnect();
	end;
	if v106 then
		v106:Disconnect();
	end;
	l__TweenService__16:Create(game.Lighting, TweenInfo.new(1.35), {
		ExposureCompensation = 0
	}):Play();
	l__TweenService__16:Create(game.Lighting, TweenInfo.new(1.35), {
		Brightness = 2
	}):Play();
	l__TweenService__16:Create(workspace.CurrentCamera, TweenInfo.new(1), {
		FieldOfView = 70
	}):Play();
	l__CameraPoints__8.L.CFrame = l__CFrame__72;
	l__CameraPoints__8.R.CFrame = l__CFrame__73;
	l__CameraPoints__8.C.CFrame = l__CFrame__74;
	for v432, v433 in pairs(workspace.ClientBG:GetChildren()) do
		v433:Destroy();
	end;
	for v434, v435 in pairs(game.Lighting:GetChildren()) do
		v435:Destroy();
	end;
	for v436, v437 in pairs(game.Lighting:GetAttributes()) do
		game.Lighting[v436] = v437;
	end;
	for v438, v439 in pairs(game.ReplicatedStorage.OGLighting:GetChildren()) do
		v439:Clone().Parent = game.Lighting;
	end;
	task.spawn(function()
		for v440, v441 in pairs((game.ReplicatedStorage.Events.Backgrounds:InvokeServer("Unload"))) do
			local v442 = v441[1];
			local v443 = tonumber(v441[4]);
			if v442 then
				v442[v441[2]] = v443 and v443 or v441[3];
			end;
		end;
	end);
	u32:Stop();
	l__Parent__3.GameMusic.Music:Stop();
	l__Parent__3.GameMusic.Vocals:Stop();
	for v444, v445 in pairs(l__Value__6.MusicPart:GetDescendants()) do
		if v445:IsA("Sound") then
			v445.Volume = 0;
			v445.PlaybackSpeed = 1;
		else
			v445:Destroy();
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
local function u77(p69)
	local v446 = l__Value__6.Config.Player1.Value == l__LocalPlayer__2 and l__Value__6.Config.P1Points.Value or l__Value__6.Config.P2Points.Value;
	if u42 and u42.OnSongEnd then
		local u78 = 0;
		table.foreach(u1, function(p70, p71)
			u78 = u78 + p71;
		end);
		u42.OnSongEnd(l__Parent__3, { u78 / #u1, v446 });
	end;
	if not l__LocalPlayer__2.Input.ShowEndScreen.Value then
		return;
	end;
	if v85.Parent.Parent.Parent.Name == "Songs" and v85:IsA("ModuleScript") then
		local v447 = v85.Parent.Name;
	else
		v447 = v85.Name;
	end;
	local v448 = game.ReplicatedStorage.Misc.EndScene:Clone();
	v448.Parent = l__LocalPlayer__2.PlayerGui.GameUI;
	v448.BGFrame.SongName.Text = "<font color='rgb(90,220,255)'>" .. v447 .. "</font> Cleared!";
	v448.BGFrame.Judgements.Text = "Judgements:\n<font color='rgb(255,255,140)'>Marvelous</font> - " .. u6 .. "\n<font color='rgb(90,220,255)'>Sick</font> - " .. u7 .. "\n<font color='rgb(90,255,90)'>Good</font> - " .. u8 .. "\n<font color='rgb(255,210,0)'>Ok</font> - " .. u9 .. "\n<font color='rgb(165,65,235)'>Bad</font> - " .. u10 .. "\n\nScore - " .. v446 .. "\nAccuracy - " .. u2 .. "%\nMisses - " .. u4 .. "\nBest Combo - " .. u5;
	if l__LocalPlayer__2.Input.ExtraData.Value then
		if u7 == 0 then
			local v449 = 1;
		else
			v449 = u7;
		end;
		if u7 == 0 then
			local v450 = ":inf";
		else
			v450 = ":1";
		end;
		if u8 == 0 then
			local v451 = 1;
		else
			v451 = u8;
		end;
		if u8 == 0 then
			local v452 = ":inf";
		else
			v452 = ":1";
		end;
		v448.BGFrame.Judgements.Text = v448.BGFrame.Judgements.Text .. "\n\nMA - " .. math.floor(u6 / v449 * 100 + 0.5) / 100 .. v450 .. "\nPA - " .. math.floor(u7 / v451 * 100 + 0.5) / 100 .. v452;
		v448.BGFrame.Judgements.Text = v448.BGFrame.Judgements.Text .. "\nMean - " .. u11.CalculateMean(u12) .. "ms";
	end;
	v448.BGFrame.InputType.Text = "Input System Used: " .. l__LocalPlayer__2.Input.InputType.Value;
	v448.Background.BackgroundTransparency = 1;
	local v453 = l__Parent__3.GameMusic.Vocals.TimePosition - 7 < l__Parent__3.GameMusic.Vocals.TimeLength;
	if u4 == 0 and v453 and not p69 and l__Parent__3.GameMusic.Vocals.TimeLength > 0 and u6 + u7 + u8 + u9 + u10 + u4 >= 20 then
		v448.BGFrame.Extra.Visible = true;
		if tonumber(u2) == 100 then
			local v454 = "<font color='rgb(255, 225, 80)'>PFC</font>";
		else
			v454 = "<font color='rgb(90,220,255)'>FC</font>";
		end;
		v448.BGFrame.Extra.Text = v454;
		if u7 + u8 + u9 + u10 + u4 == 0 then
			v448.BGFrame.Extra.Text = "<font color='rgb(64, 211, 255)'>MFC</font>";
		end;
	end;
	if p69 then
		v448.Ranking.Image = u75.F[2];
		v448.BGFrame.SongName.Text = "<font color='rgb(255,0,0)'>" .. v447 .. " FAILED!</font>";
	elseif not v453 or not (l__Parent__3.GameMusic.Vocals.TimeLength > 0) then
		v448.Ranking.Image = "rbxassetid://8906780323";
		v448.BGFrame.SongName.Text = "<font color='rgb(255,140,0)'>" .. v447 .. " Incomplete.</font>";
	else
		local v455 = 0;
		for v456, v457 in pairs(u75) do
			local v458 = v457[1];
			if v458 <= tonumber(u2) and v455 <= v458 then
				v455 = v458;
				v448.Ranking.Image = v457[2];
				if v456 == "F" then
					v448.BGFrame.SongName.Text = "<font color='rgb(255,0,0)'>" .. v447 .. " FAILED!</font>";
				end;
			end;
		end;
	end;
	u11.MakeHitGraph(u12, v448);
	for v459, v460 in pairs(v448.BGFrame:GetChildren()) do
		v460.TextTransparency = 1;
		v460.TextStrokeTransparency = 1;
	end;
	l__TweenService__16:Create(v448.Background, TweenInfo.new(0.35), {
		BackgroundTransparency = 0.3
	}):Play();
	l__TweenService__16:Create(v448.Ranking, TweenInfo.new(0.35), {
		ImageTransparency = 0
	}):Play();
	for v461, v462 in pairs(v448.BGFrame:GetChildren()) do
		l__TweenService__16:Create(v462, TweenInfo.new(0.35), {
			TextTransparency = 0
		}):Play();
		l__TweenService__16:Create(v462, TweenInfo.new(0.35), {
			TextStrokeTransparency = 0
		}):Play();
	end;
	v448.LocalScript.Disabled = false;
end;
u71 = l__LocalPlayer__2.Character.Humanoid.Died:Connect(function()
	u76();
	u77(true);
end);
l__Events__5.Stop.OnClientEvent:Connect(function()
	u76();
	if l__LocalPlayer__2.Character and l__LocalPlayer__2.Character:FindFirstChild("Humanoid") then
		local v463, v464, v465 = ipairs(l__LocalPlayer__2.Character.Humanoid:GetPlayingAnimationTracks());
		while true do
			v463(v464, v465);
			if not v463 then
				break;
			end;
			v465 = v463;
			v464:Stop();		
		end;
		u77();
	end;
	table.clear(u36);
end);
