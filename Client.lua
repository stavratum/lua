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
	local l__Music__72 = l__Parent__3.GameMusic.Music;
	local l__Vocals__73 = l__Parent__3.GameMusic.Vocals;
	if p8.SoundId ~= "" then
		l__Music__72.SoundId = p8.SoundId;
		while true do
			task.wait();
			if l__Music__72.TimeLength > 0 then
				break;
			end;		
		end;
	end;
	if p9.SoundId ~= "" then
		l__Vocals__73.SoundId = p9.SoundId;
		while true do
			task.wait();
			if l__Vocals__73.TimeLength > 0 then
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
local v74 = game.ReplicatedStorage.Events.PlayerSongVote.Event:Connect(function(p10, p11, p12)
	if not p10 or not p11 or not p12 then
		return;
	end;
	l__Value__6.Events.PlayerSongVote:FireServer(p10, p11, p12);
end);
for v75, v76 in pairs(l__LocalPlayer__2.PlayerGui.GameUI:GetChildren()) do
	if not string.match(v76.Name, "SongSelect") then
		v76.Visible = false;
	end;
end;
v26:SetAttribute("2v2", nil);
for v77, v78 in pairs(v26.SongScroller:GetChildren()) do
	if v78:GetAttribute("2V2") then
		v78.Visible = false;
	end;
end;
for v79, v80 in pairs(v26.BasicallyNil:GetChildren()) do
	if v80:GetAttribute("2V2") then
		v80.Visible = false;
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
local v81 = l__TweenService__16:Create(v61, TweenInfo.new(1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
	Size = 0
});
v81:Play();
v81.Completed:Connect(function()
	v61:Destroy();
end);
local v82 = l__TweenService__16:Create(v71, TweenInfo.new(2, Enum.EasingStyle.Quint, Enum.EasingDirection.In), {
	Volume = 0
});
v82:Play();
v82.Completed:Connect(function()
	v71:Stop();
end);
local v83 = l__Value__6.Config.Song.Value:IsA("StringValue") and l__Value__6.Config.Song.Value.Value or require(l__Value__6.Config.Song.Value);
local v84 = l__Value__6.Config.Song.Value:FindFirstAncestorOfClass("StringValue") or l__Value__6.Config.Song.Value;
if v84.Parent.Parent.Parent.Name == "Songs" and not v84:FindFirstChild("Sound") then
	v84 = v84.Parent;
end;
local v85, v86, v87, v88 = v14.SpecialSongCheck(v84);
v26.Visible = false;
v74:Disconnect();
workspace.CurrentCamera.CameraType = Enum.CameraType.Scriptable;
workspace.CurrentCamera.CFrame = l__Value__6.CameraPoints.C.CFrame;
task.spawn(function()
	l__Value__6.MusicPart.Go.Played:Wait();
	v14.NowPlaying(l__Parent__3, v84, l__LocalPlayer__2);
	task.wait(1);
	game.StarterGui:SetCore("ResetButtonCallback", true);
end);
require(l__Parent__3.Modules.Icons).SetIcons(l__Parent__3, v84);
local u23 = v83;
local v89, v90 = pcall(function()
	u23 = game.HttpService:JSONDecode(u23).song;
end);
if v90 then
	u23 = game.HttpService:JSONDecode(require(game.ReplicatedStorage.Songs["/v/-tan"].Sage.Hard)).song;
end;
u23.bpm = u23.bpm * l__Value__15;
local v91 = 60 / (u23.bpm or 120 * l__Value__15);
local l__bpm__92 = u23.bpm;
local v93 = v91 / 4;
local l__Value__94 = v84.Credits.Value;
if v84.Parent.Parent.Parent.Name == "Songs" then
	local v95 = v84:IsA("ModuleScript") and v84.Parent.Name or v84.Name;
else
	v95 = v84.Name;
end;
local l__Name__96 = l__Value__6.Config.Song.Value.Name;
local v97 = math.ceil((l__Value__6.MusicPart.SERVERvocals.TimeLength - l__Value__6.MusicPart.SERVERvocals.TimePosition) / l__Value__6.MusicPart.SERVERvocals.PlaybackSpeed);
l__Parent__3.LowerContainer.Credit.Text = v95 .. " (" .. l__Name__96 .. ")" .. " (" .. l__Value__15 .. "x)" .. "\n" .. l__Value__94 .. "\n" .. string.format("%d:%02d", math.floor(v97 / 60), v97 % 60);
if v84:FindFirstChild("MobileButtons") then
	l__Parent__3.MobileButtons:Destroy();
	v84.MobileButtons:Clone().Parent = l__Parent__3;
end;
if v84:FindFirstChild("Countdown") and game.ReplicatedStorage.Countdowns:FindFirstChild(v84.Countdown.Value) then
	local v98 = require(game.ReplicatedStorage.Countdowns:FindFirstChild(v84.Countdown.Value).Config);
	local v99 = {};
	if v98.Images ~= nil then
		for v100, v101 in pairs(v98.Images) do
			table.insert(v99, v101);
		end;
	end;
	if v98.Audio ~= nil then
		for v102, v103 in pairs(v98.Audio) do
			table.insert(v99, v103);
		end;
	end;
	game.ContentProvider:PreloadAsync(v99);
end;
local v104 = v14.ModchartCheck(l__Parent__3, v84, u23);
local v105 = v13.Start(l__Parent__3, v84:FindFirstChild("Modchart"), l__bpm__92, v104);
local v106 = require(l__Parent__3.Modules.Functions);
v106.keyCheck(v84, v87, v86, v88);
local v107 = nil;
if v84:FindFirstChild("notetypeconvert") then
	v107 = require(v84.notetypeconvert);
end;
v106.stuffCheck(v84);
local v108 = v84:FindFirstChild("notetypeconvert") and v107.notetypeconvert or v106.notetypeconvert;
if v107 and v107.newKeys then
	v107.newKeys(l__Parent__3);
	v85 = true;
end;
local v109 = nil;
if not l__Value__6.Config.SinglePlayerEnabled.Value then
	if l__Value__6.Config.Player1.Value == l__LocalPlayer__2 then
		v109 = l__Value__6.Config.Player2.Value;
	else
		v109 = l__Value__6.Config.Player1.Value;
	end;
end;
if v109 then
	local v110 = game.ReplicatedStorage.Skins:FindFirstChild(v109.Input.Skin.Value) or game.ReplicatedStorage.Skins.Default;
else
	v110 = game.ReplicatedStorage.Skins.Default;
end;
l__Game__7.L.Arrows.IncomingNotes.DescendantAdded:Connect(function(p13)
	if not (l__Game__7.Rotation >= 90) then
		return;
	end;
	if v84:FindFirstChild("NoSettings") then
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
	if v84:FindFirstChild("NoSettings") then
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
		local v111 = game.ReplicatedStorage.UIStyles[p15];
		u13 = require(v111.Config);
		l__Parent__3.LowerContainer.Bar:Destroy();
		local v112 = v111.Bar:Clone();
		v112.Parent = l__Parent__3.LowerContainer;
		if u13.HealthBarColors then
			v112.Background.BackgroundColor3 = u13.HealthBarColors.Green or Color3.fromRGB(114, 255, 63);
			v112.Background.Fill.BackgroundColor3 = u13.HealthBarColors.Red or Color3.fromRGB(255, 0, 0);
		end;
		if u13.ShowIcons then
			v112.Player1.Sprite.Visible = u13.ShowIcons.Dad;
			v112.Player2.Sprite.Visible = u13.ShowIcons.BF;
		end;
		if v111:FindFirstChild("Stats") then
			l__Parent__3.LowerContainer.Stats:Destroy();
			v111.Stats:Clone().Parent = l__Parent__3.LowerContainer;
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
				l__Parent__3.LowerContainer.Credit.Text = v95 .. " (" .. l__Name__96 .. ")" .. " (" .. l__Value__15 .. "x)" .. "\n" .. l__Value__94 .. "\n" .. u13.overrideStats.Timer;
			end;
		end;
	else
		local l__Default__113 = game.ReplicatedStorage.UIStyles.Default;
		u13 = require(l__Default__113.Config);
		l__Parent__3.LowerContainer.Bar:Destroy();
		l__Parent__3.LowerContainer.Stats:Destroy();
		l__Default__113.Bar:Clone().Parent = l__Parent__3.LowerContainer;
		l__Default__113.Stats:Clone().Parent = l__Parent__3.LowerContainer;
		l__Parent__3.LowerContainer.PointsA.Font = Enum.Font.GothamBold;
		l__Parent__3.LowerContainer.PointsB.Font = Enum.Font.GothamBold;
	end;
	v31();
	require(l__Parent__3.Modules.Icons).SetIcons(l__Parent__3, v84);
	updateUI();
end;
local u24 = {};
function updateUI(p16)
	if v21.Name == "L" then
		local v114 = "R";
	else
		v114 = "L";
	end;
	local v115 = l__Game__7:FindFirstChild(v114);
	if l__LocalPlayer__2.Input.VerticalBar.Value then
		l__Parent__3.LowerContainer.Stats.Visible = false;
		l__Parent__3.SideContainer.Accuracy.Visible = true;
	end;
	l__Parent__3.Stats.Visible = l__LocalPlayer__2.Input.ShowDebug.Value;
	l__Parent__3.SideContainer.Data.Visible = l__LocalPlayer__2.Input.JudgementCounter.Value;
	l__Parent__3.SideContainer.Extra.Visible = l__LocalPlayer__2.Input.ExtraData.Value;
	if l__LocalPlayer__2.Input.ShowOpponentStats.Value then
		if l__LocalPlayer__2.Input.Middlescroll.Value then
			v115.OpponentStats.Visible = l__LocalPlayer__2.Input.ShowOtherMS.Value;
		else
			v115.OpponentStats.Visible = l__LocalPlayer__2.Input.ShowOpponentStats.Value;
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
	local v116, v117, v118 = pairs(l__Game__7.Templates:GetChildren());
	while true do
		local v119, v120 = v116(v117, v118);
		if v119 then

		else
			break;
		end;
		v118 = v119;
		v120.Frame.Bar.End.ImageTransparency = l__LocalPlayer__2.Input.BarOpacity.Value;
		v120.Frame.Bar.ImageLabel.ImageTransparency = l__LocalPlayer__2.Input.BarOpacity.Value;	
	end;
	if not v84:FindFirstChild("NoSettings") then
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
			local l__Size__121 = l__Parent__3.LowerContainer.Bar.Size;
			l__Parent__3.LowerContainer.Bar.Position = UDim2.new(1.1, 0, -4, 0);
			l__Parent__3.LowerContainer.Bar.Size = UDim2.new(l__Size__121.X.Scale * 0.8, l__Size__121.X.Offset, l__Size__121.Y.Scale, l__Size__121.Y.Offset);
			l__Parent__3.LowerContainer.Bar.Rotation = 90;
			l__Parent__3.LowerContainer.Bar.Player1.Sprite.Rotation = -90;
			l__Parent__3.LowerContainer.Bar.Player2.Sprite.Rotation = -90;
		end;
		if l__LocalPlayer__2.Input.Downscroll.Value then
			local v122 = UDim2.new(0.5, 0, 8.9, 0);
			if u13 ~= nil then
				if u13.overrideStats then
					if u13.overrideStats.Position then
						if u13.overrideStats.Position.Downscroll then
							v122 = u13.overrideStats.Position.Downscroll;
						end;
					end;
				end;
			end;
			l__Game__7.Rotation = 180;
			l__Game__7.Position = UDim2.new(0.5, 0, 0.05, 0);
			l__Parent__3.LowerContainer.AnchorPoint = Vector2.new(0.5, 0);
			l__Parent__3.LowerContainer.Position = UDim2.new(0.5, 0, 0.1, 0);
			l__Parent__3.LowerContainer.Stats.Position = v122;
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
				local l__Size__123 = l__Parent__3.LowerContainer.Bar.Size;
				l__Parent__3.LowerContainer.Bar.Position = UDim2.new(1.1, 0, 4, 0);
				l__Parent__3.LowerContainer.Bar.Rotation = 90;
				l__Parent__3.LowerContainer.Bar.Player1.Sprite.Rotation = -90;
				l__Parent__3.LowerContainer.Bar.Player2.Sprite.Rotation = -90;
			end;
			if not v85 then
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
				local l__Size__124 = l__Parent__3.LowerContainer.Bar.Size;
				l__Parent__3.LowerContainer.Bar.Position = UDim2.new(1.1, 0, -4, 0);
				l__Parent__3.LowerContainer.Bar.Rotation = 90;
				l__Parent__3.LowerContainer.Bar.Player1.Sprite.Rotation = -90;
				l__Parent__3.LowerContainer.Bar.Player2.Sprite.Rotation = -90;
			end;
			l__Game__7.L.Arrows.Rotation = 0;
			l__Game__7.R.Arrows.Rotation = 0;
			if not v85 then
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
			v115.Visible = l__LocalPlayer__2.Input.ShowOtherMS.Value;
			v21.Position = UDim2.new(0.5, 0, 0.5, 0);
			v21.AnchorPoint = Vector2.new(0.5, 0.5);
			if l__LocalPlayer__2.Input.ShowOtherMS.Value then
				v115.OpponentStats.Size = UDim2.new(2, 0, 0.05, 0);
				v115.OpponentStats.Position = UDim2.new(0.5, 0, -0.08, 0);
				v115.AnchorPoint = Vector2.new(0.1, 0);
				v115.Size = UDim2.new(0.15, 0, 0.3, 0);
				v115.Position = v115.Name == "R" and UDim2.new(0.88, 0, 0.5, 0) or UDim2.new(0, 0, 0.5, 0);
				if l__LocalPlayer__2.Input.Downscroll.Value then
					v115.Position = v115.Name == "L" and UDim2.new(0.88, 0, 0.5, 0) or UDim2.new(0, 0, 0.5, 0);
				end;
			end;
		elseif p16 == "Middlescroll" then
			v115.Visible = true;
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
	local v125, v126, v127 = pairs(l__Parent__3.SideContainer:GetChildren());
	while true do
		local v128, v129 = v125(v126, v127);
		if v128 then

		else
			break;
		end;
		v127 = v128;
		if v129.ClassName == "TextLabel" then
			u24[v129.Name] = v129.Size;
		end;	
	end;
end;
l__Events__5.ChangeUI.Event:Connect(function(p17)
	ChangeUI(p17);
end);
local u25 = v84.Offset.Value + (l__LocalPlayer__2.Input.Offset.Value and 0);
local l__Value__26 = v60.Notes.Value;
local u27 = {
	L = {}, 
	R = {}
};
local l__Value__28 = v110.Notes.Value;
local v130 = require(game.ReplicatedStorage.Modules.Device);
local v131 = {
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
if not v87 then
	v131 = {
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
if v84:FindFirstChild(l__Parent__3.PlayerSide.Value .. "_Anims") then
	local v132 = v84[l__Parent__3.PlayerSide.Value .. "_Anims"].Value;
else
	v132 = game.ReplicatedStorage.Animations:FindFirstChild(l__LocalPlayer__2.Input.Animation.Value) or (v14.findAnim(l__LocalPlayer__2.Input.Animation.Value) or game.ReplicatedStorage.Animations.Default);
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
		local v133, v134, v135 = ipairs(p18:GetChildren());
		while true do
			v133(v134, v135);
			if not v133 then
				break;
			end;
			v135 = v133;
			if v134:IsA("Animation") then
				u29[v134.Name] = p19:LoadAnimation(v134);
			end;		
		end;
		u30 = u29.Idle;
		return;
	end;
	if not p19 then
		p19 = l__LocalPlayer__2.Character.Humanoid;
	end;
	local v136, v137, v138 = ipairs(p18:GetChildren());
	while true do
		v136(v137, v138);
		if not v136 then
			break;
		end;
		v138 = v136;
		if v137:IsA("Animation") then
			l__Animations__31[v137.Name] = p19:LoadAnimation(v137);
		end;	
	end;
	u32 = l__Animations__31.Idle;
end;
if v132:FindFirstChild("Custom") then
	v1(v132, l__LocalPlayer__2.Character:WaitForChild("customrig"):WaitForChild("rig"):WaitForChild("Humanoid"));
elseif v132:FindFirstChild("FBX") then
	v1(v132, l__LocalPlayer__2.Character:WaitForChild("customrig"):WaitForChild("rig"):WaitForChild("AnimationController"):WaitForChild("Animator"));
elseif v132:FindFirstChild("2Player") then
	v1(v132.Other, l__LocalPlayer__2.Character:WaitForChild("char2"):WaitForChild("Dummy"):WaitForChild("Humanoid"), true);
	v1(v132, l__LocalPlayer__2.Character.Humanoid);
elseif v132:FindFirstChild("Custom2Player") then
	v1(v132.Other, l__LocalPlayer__2.Character:WaitForChild("char2"):WaitForChild("Dummy"):WaitForChild("Humanoid"), true);
	v1(v132, l__LocalPlayer__2.Character:WaitForChild("customrig"):WaitForChild("rig"):WaitForChild("Humanoid"));
else
	v1(v132);
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
local l__speed__139 = u23.speed;
u23.speed = l__LocalPlayer__2.Input.ScrollSpeedChange.Value and l__LocalPlayer__2.Input.ScrollSpeed.Value + 1.5 or (u23.speed or 3.3);
local v140 = 0.75 * u23.speed;
l__Config__4.MaxDist.Value = v140;
local v141 = Instance.new("Sound");
v141.Name = "HitSound";
v141.Parent = l__Parent__3;
v141.SoundId = "rbxassetid://" .. l__LocalPlayer__2.Input.HitSoundsValue.Value or "rbxassetid://3581383408";
v141.Volume = l__LocalPlayer__2.Input.HitSoundVolume.Value;
local u37 = {
	Left = false, 
	Down = false, 
	Up = false, 
	Right = false
};
local function u38(p21)
	local v142 = nil;
	local v143, v144, v145 = ipairs(v21.Arrows.IncomingNotes[p21]:GetChildren());
	while true do
		v143(v144, v145);
		if not v143 then
			break;
		end;
		v145 = v143;
		if (v144.Name == p21 or string.split(v144.Name, "_")[1] == p21) and (math.abs(string.split(v144:GetAttribute("NoteData"), "~")[1] - (v14.tomilseconds(l__Config__4.TimePast.Value) + u25)) <= v15.Ghost and v144.Frame.Arrow.Visible) then
			if not v142 then
				v142 = v144;
			elseif (v144.AbsolutePosition - v144.Parent.AbsolutePosition).magnitude <= (v142.AbsolutePosition - v144.Parent.AbsolutePosition).magnitude then
				v142 = v144;
			end;
		end;	
	end;
	if v142 then
		return;
	end;
	return true;
end;
local function u39(p22)
	local v146 = p22;
	if v85 then
		if v87 then
			if v146 == "A" or v146 == "H" then
				v146 = "Left";
			end;
			if v146 == "S" or v146 == "J" then
				v146 = "Down";
			end;
			if v146 == "D" or v146 == "K" then
				v146 = "Up";
			end;
			if v146 == "F" or v146 == "L" then
				v146 = "Right";
			end;
		elseif v86 or v88 then
			if v146 == "S" or v146 == "J" then
				v146 = "Left";
			end;
			if v146 == "D" then
				v146 = "Up";
			end;
			if v146 == "K" or v146 == "Space" then
				v146 = "Down";
			end;
			if v146 == "F" or v146 == "L" then
				v146 = "Right";
			end;
		elseif v107 and v107.getAnimationDirection then
			v146 = v107.getAnimationDirection(v146);
		end;
	end;
	if v132:FindFirstChild(v146) then
		if v21.Name == "L" then
			local v147 = v146;
			if not v147 then
				if v146 == "Right" then
					v147 = "Left";
				elseif v146 == "Left" then
					v147 = "Right";
				else
					v147 = v146;
				end;
			end;
		elseif v146 == "Right" then
			v147 = "Left";
		elseif v146 == "Left" then
			v147 = "Right";
		else
			v147 = v146;
		end;
		local v148 = v132[v147];
		local v149 = _G.Animations[v147];
		v149.Looped = false;
		v149.TimePosition = 0;
		v149.Priority = Enum.AnimationPriority.Movement;
		if u33 and u33 ~= v149 then
			u33:Stop(0);
		end;
		u33 = v149;
		local v150 = u29[v147];
		if v150 then
			local v151 = v132.Other[v147];
			v150.Looped = false;
			v150.TimePosition = 0;
			v150.Priority = Enum.AnimationPriority.Movement;
			if u34 and u34 ~= v150 then
				u34:Stop(0);
			end;
			u34 = v150;
		end;
		task.spawn(function()
			u35 = u35 + 1;
			while u36[p22] and u35 == u35 do
				v149:Play(0);
				if v150 then
					v150:Play(0);
				end;
				task.wait(0.1);			
			end;
			task.wait(v149.Length - 0.15);
			if u35 == u35 then
				v149:Stop(0);
				if l__Parent__3.Side.Value == l__Parent__3.PlayerSide.Value and l__LocalPlayer__2.Input.MoveOnHit.Value then
					local l__Value__152 = l__Parent__3.Side.Value;
					local v153 = workspace.ClientBG:FindFirstChildOfClass("Model");
					local v154 = v84:FindFirstChild("Modchart") and (v84.Modchart:IsA("ModuleScript") and (v104 and require(v84.Modchart)));
					if v154 and v154.CameraReset then
						v154.CameraReset();
					end;
					if v154 and v154.OverrideCamera then
						return;
					end;
					l__TweenService__16:Create(workspace.CurrentCamera, TweenInfo.new(l__LocalPlayer__2.Input.MoveSpeed.Value, v9, Enum.EasingDirection.Out), {
						CFrame = (v153 and v153:FindFirstChild("cameraPoints") and v153.cameraPoints:FindFirstChild(l__Value__152) or (l__Value__6.CameraPoints:FindFirstChild(l__Value__152) or l__Value__6.CameraPoints.C)).CFrame
					}):Play();
				end;
				if v150 then
					v150:Stop(0);
				end;
			end;
		end);
	end;
end;
local function u40(p23)
	if v85 and not v107 then
		return;
	end;
	if not l__LocalPlayer__2.Input.NoteSplashes.Value then
		return;
	end;
	if not game.ReplicatedStorage.Misc.Splashes:FindFirstChild(p23) then
		return;
	end;
	task.spawn(function()
		local v155 = game.ReplicatedStorage.Misc.Splashes[p23]:GetChildren();
		local v156 = v155[math.random(1, #v155)]:Clone();
		v156.Parent = v21.SplashContainer;
		v156.Position = v21.Arrows[p23].Position;
		v156.Image = (game.ReplicatedStorage.Splashes:FindFirstChild(l__LocalPlayer__2.Input.NoteSplashSkin.Value) or game.ReplicatedStorage.Splashes.Default).Splash.Value;
		v156.Size = UDim2.fromScale(l__LocalPlayer__2.Input.SplashSize.Value * v156.Size.X.Scale, l__LocalPlayer__2.Input.SplashSize.Value * v156.Size.Y.Scale);
		local l__X__157 = v156.ImageRectOffset.X;
		for v158 = 0, 8 do
			v156.ImageRectOffset = Vector2.new(l__X__157, v158 * 128);
			task.wait(0.035);
		end;
		v156:Destroy();
	end);
end;
local function u41(p24, p25)
	if not l__LocalPlayer__2.Input.MoveOnHit.Value then
		return;
	end;
	local l__Value__159 = l__Parent__3.Side.Value;
	local v160 = workspace.ClientBG:FindFirstChildOfClass("Model");
	local v161 = v84:FindFirstChild("Modchart") and (v84.Modchart:IsA("ModuleScript") and (v104 and require(v84.Modchart)));
	if v161 and v161.OverrideCamera then
		return;
	end;
	local v162 = v160 and v160:FindFirstChild("cameraPoints") and v160.cameraPoints:FindFirstChild(l__Value__159) or (l__Value__6.CameraPoints:FindFirstChild(l__Value__159) or l__Value__6.CameraPoints.C);
	if l__Parent__3.PlayerSide.Value == l__Parent__3.Side.Value and not p25 or l__Parent__3.PlayerSide.Value ~= l__Parent__3.Side.Value and p25 then
		if p24 == "Up" then
			l__TweenService__16:Create(workspace.CurrentCamera, TweenInfo.new(l__LocalPlayer__2.Input.MoveSpeed.Value, v9, Enum.EasingDirection.Out), {
				CFrame = v162.CFrame * CFrame.new(0, l__LocalPlayer__2.Input.MoveIntensity.value, 0)
			}):Play();
		end;
		if p24 == "Left" then
			l__TweenService__16:Create(workspace.CurrentCamera, TweenInfo.new(l__LocalPlayer__2.Input.MoveSpeed.Value, v9, Enum.EasingDirection.Out), {
				CFrame = v162.CFrame * CFrame.new(-l__LocalPlayer__2.Input.MoveIntensity.value, 0, 0)
			}):Play();
		end;
		if p24 == "Down" then
			l__TweenService__16:Create(workspace.CurrentCamera, TweenInfo.new(l__LocalPlayer__2.Input.MoveSpeed.Value, v9, Enum.EasingDirection.Out), {
				CFrame = v162.CFrame * CFrame.new(0, -l__LocalPlayer__2.Input.MoveIntensity.value, 0)
			}):Play();
		end;
		if p24 == "Right" then
			l__TweenService__16:Create(workspace.CurrentCamera, TweenInfo.new(l__LocalPlayer__2.Input.MoveSpeed.Value, v9, Enum.EasingDirection.Out), {
				CFrame = v162.CFrame * CFrame.new(l__LocalPlayer__2.Input.MoveIntensity.value, 0, 0)
			}):Play();
		end;
	end;
end;
local u42 = v84:FindFirstChild("Modchart") and (v84.Modchart:IsA("ModuleScript") and (v104 and require(v84.Modchart)));
local l__UserInput__43 = l__Events__5.UserInput;
local function u44(p26, p27)
	if not l__LocalPlayer__2.Input.ShowRatings.Value then
		return;
	end;
	local v163 = p27 and v21 or (l__Parent__3.PlayerSide.Value == "L" and l__Game__7.R or l__Game__7.L);
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
	local v164 = v163:FindFirstChildOfClass("ImageLabel");
	if v164 then
		v164.Parent = nil;
	end;
	local v165 = v163:FindFirstChildOfClass("TextLabel");
	if v165 then
		v165.Parent = nil;
	end;
	local l__Value__166 = l__LocalPlayer__2.Input.RatingSize.Value;
	local v167 = game.ReplicatedStorage.Misc.IndicatorTemplate:Clone();
	v167.Image = "rbxthumb://type=Asset&id=" .. l__LocalPlayer__2.Input[p26 .. "IndicatorImg"].Value .. "&w=150&h=150" or l__Value__6.FlyingText.G["Template_" .. p26].Image;
	v167.Parent = v163;
	v167.Size = UDim2.new(0.25 * l__Value__166, 0, 0.083 * l__Value__166, 0);
	v167.ImageTransparency = 0;
	if l__Game__7.Rotation >= 90 then
		local v168 = 180;
	else
		v168 = 0;
	end;
	v167.Rotation = v168;
	game:GetService("Debris"):AddItem(v167, 1.5);
	if l__LocalPlayer__2.Input.CenterRatings.Value then
		v167.Position = UDim2.new(0.5, 0, 0.45, 0);
	end;
	task.spawn(function()
		if l__LocalPlayer__2.Input.RatingBounce.Value then
			l__TweenService__16:Create(v167, TweenInfo.new(0.05, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
				Size = UDim2.new(0.3 * l__Value__166, 0, 0.1 * l__Value__166, 0)
			}):Play();
		end;
		task.wait(0.1);
		l__TweenService__16:Create(v167, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
			Size = UDim2.new(0.25 * l__Value__166, 0, 0.083 * l__Value__166, 0)
		}):Play();
		task.wait(0.5);
		l__TweenService__16:Create(v167, TweenInfo.new(0.75, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
			ImageTransparency = 1
		}):Play();
	end);
	local v169 = game.ReplicatedStorage.Misc.miliseconds:Clone();
	v169.Visible = l__LocalPlayer__2.Input.ShowMS.Value;
	v169.Parent = v163;
	v169.Size = UDim2.new(0.145 * l__Value__166, 0, 0.044 * l__Value__166, 0);
	if l__Game__7.Rotation >= 90 then
		local v170 = 180;
	else
		v170 = 0;
	end;
	v169.Rotation = v170;
	v169.Text = math.floor(p27 * 100 + 0.5) / 100 .. " ms";
	if p27 < 0 then
		v169.TextColor3 = Color3.fromRGB(255, 61, 61);
	else
		v169.TextColor3 = Color3.fromRGB(120, 255, 124);
	end;
	game:GetService("Debris"):AddItem(v169, 1.5);
	if l__LocalPlayer__2.Input.CenterRatings.Value then
		v169.Position = UDim2.new(0.5, 0, 0.36, 0);
	end;
	task.spawn(function()
		if l__LocalPlayer__2.Input.RatingBounce.Value then
			l__TweenService__16:Create(v169, TweenInfo.new(0.05, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
				Size = UDim2.new(0.165 * l__Value__166, 0, 0.06 * l__Value__166, 0)
			}):Play();
		end;
		task.wait(0.1);
		l__TweenService__16:Create(v169, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
			Size = UDim2.new(0.145 * l__Value__166, 0, 0.044 * l__Value__166, 0)
		}):Play();
		task.wait(0.5);
		l__TweenService__16:Create(v169, TweenInfo.new(0.75, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
			TextTransparency = 1
		}):Play();
		l__TweenService__16:Create(v169, TweenInfo.new(0.75, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
			TextStrokeTransparency = 1
		}):Play();
	end);
end;
local function v171(p28, p29, p30, p31, p32)
	if not p29 then
		return;
	end;
	if p31 then
		u37[p29] = p28.UserInputState == Enum.UserInputState.Begin;
		if l__Parent__3.PlayerSide.Value == "L" then
			local v172 = "R";
		else
			v172 = "L";
		end;
		p31 = l__Game__7:FindFirstChild(v172);
	end;
	if not p31 then
		u36[p29] = p28.UserInputState == Enum.UserInputState.Begin;
	end;
	if l__Config__4.CantHitNotes.Value then
		return;
	end;
	local l__Value__173 = l__LocalPlayer__2.Input.InputType.Value;
	local v174 = nil;
	if not v21.Arrows.IncomingNotes:FindFirstChild(p29) then
		return;
	end;
	local v175, v176, v177 = ipairs((p31 or v21).Arrows.IncomingNotes[p29]:GetChildren());
	while true do
		v175(v176, v177);
		if not v175 then
			break;
		end;
		v177 = v175;
		if v176.Name == p29 or string.split(v176.Name, "_")[1] == p29 then
			local v178 = v176:GetAttribute("NoteData");
			local v179 = string.split(v178, "~")[1] - (v14.tomilseconds(l__Config__4.TimePast.Value) + u25);
			if not p31 then
				if v176.Frame.Arrow.Visible and math.abs(v179) <= v15.Bad then
					if not v174 then
						v174 = v176;
					elseif l__Value__173 == "Bloxxin" then
						if (v176.AbsolutePosition - v176.Parent.AbsolutePosition).magnitude <= (v174.AbsolutePosition - v176.Parent.AbsolutePosition).magnitude then
							v174 = v176;
						end;
					elseif v179 < string.split(v178, "~")[1] - (v14.tomilseconds(l__Config__4.TimePast.Value) + u25) then
						v174 = v176;
					end;
				end;
			elseif v178 == p30 then
				v174 = v176;
				break;
			end;
		end;	
	end;
	if l__Config__4.GhostTappingEnabled.Value and not v174 and not p31 and u38(p29) then
		v174 = "ghost";
	end;
	if not u36[p29] and p28.UserInputState ~= Enum.UserInputState.Begin then
		return;
	end;
	if p31 then
		if v174 then
			u41(p29, true);
			v174.Frame.Arrow.Visible = false;
			p31.Glow[p29].Arrow.ImageTransparency = 1;
			if p28.UserInputState ~= Enum.UserInputState.Begin then
				return;
			else
				local v180 = nil;
				local v181 = nil;
				local v182 = nil;
				local v183 = nil;
				local v184 = nil;
				local v185 = nil;
				p31.Glow[p29].Arrow.Visible = true;
				if p31.Glow[p29].Arrow.ImageTransparency == 1 then
					if not l__LocalPlayer__2.Input.DisableArrowGlow.Value then
						local v186 = nil;
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
							v186 = "Frame";
							v187 = v174;
							v188 = v186;
							v189 = v187[v188];
							local v204 = "Bar";
							v190 = v189;
							v191 = v204;
							v192 = v190[v191];
							local v205 = "Size";
							v193 = v192;
							v194 = v205;
							v195 = v193[v194];
							local v206 = "Y";
							v196 = v195;
							v197 = v206;
							v198 = v196[v197];
							local v207 = "Scale";
							v200 = v198;
							v201 = v207;
							v199 = v200[v201];
							local v208 = 0;
							v202 = v208;
							v203 = v199;
							if v202 < v203 then
								local v209 = tick();
								while true do
									v14.wait();
									local l__Scale__210 = v174.Position.Y.Scale;
									if l__Scale__210 < 0 then
										v174.Frame.Bar.Size = UDim2.new(l__LocalPlayer__2.Input.BarSize.Value, 0, math.clamp(v199 + l__Scale__210, 0, 20), 0);
										v174.Frame.Bar.Position = UDim2.new(0.5, 0, 0.5 - l__Scale__210, 0);
									end;
									if not u37[p29] then
										break;
									end;
									if v174.Frame.Bar.Size.Y.Scale == 0 then
										break;
									end;
									if tick() - v209 > 7.5 then
										break;
									end;								
								end;
							else
								v14.wait(0.175);
							end;
							local v211 = true;
							v180 = u42;
							v181 = v180;
							if v181 and u42.OpponentHit then
								u42.OpponentHit(l__Parent__3, p29);
							end;
							local v212 = u44;
							v182 = p32;
							v183 = v182;
							v184 = v212;
							v185 = v183;
							v184(v185);
							return;
						elseif not l__LocalPlayer__2.Input.DisableArrowGlow.Value and u27[p31.Name][p29] then
							if false then
								u22:Disconnect();
								u27[p31.Name][p29]:PlayAnimation("Receptor");
								return;
							else
								u27[p31.Name][p29]:PlayAnimation("Glow");
								v186 = "Frame";
								v187 = v174;
								v188 = v186;
								v189 = v187[v188];
								v204 = "Bar";
								v190 = v189;
								v191 = v204;
								v192 = v190[v191];
								v205 = "Size";
								v193 = v192;
								v194 = v205;
								v195 = v193[v194];
								v206 = "Y";
								v196 = v195;
								v197 = v206;
								v198 = v196[v197];
								v207 = "Scale";
								v200 = v198;
								v201 = v207;
								v199 = v200[v201];
								v208 = 0;
								v202 = v208;
								v203 = v199;
								if v202 < v203 then
									v209 = tick();
									while true do
										v14.wait();
										l__Scale__210 = v174.Position.Y.Scale;
										if l__Scale__210 < 0 then
											v174.Frame.Bar.Size = UDim2.new(l__LocalPlayer__2.Input.BarSize.Value, 0, math.clamp(v199 + l__Scale__210, 0, 20), 0);
											v174.Frame.Bar.Position = UDim2.new(0.5, 0, 0.5 - l__Scale__210, 0);
										end;
										if not u37[p29] then
											break;
										end;
										if v174.Frame.Bar.Size.Y.Scale == 0 then
											break;
										end;
										if tick() - v209 > 7.5 then
											break;
										end;									
									end;
								else
									v14.wait(0.175);
								end;
								v211 = true;
								v180 = u42;
								v181 = v180;
								if v181 and u42.OpponentHit then
									u42.OpponentHit(l__Parent__3, p29);
								end;
								v212 = u44;
								v182 = p32;
								v183 = v182;
								v184 = v212;
								v185 = v183;
								v184(v185);
								return;
							end;
						else
							v186 = "Frame";
							v187 = v174;
							v188 = v186;
							v189 = v187[v188];
							v204 = "Bar";
							v190 = v189;
							v191 = v204;
							v192 = v190[v191];
							v205 = "Size";
							v193 = v192;
							v194 = v205;
							v195 = v193[v194];
							v206 = "Y";
							v196 = v195;
							v197 = v206;
							v198 = v196[v197];
							v207 = "Scale";
							v200 = v198;
							v201 = v207;
							v199 = v200[v201];
							v208 = 0;
							v202 = v208;
							v203 = v199;
							if v202 < v203 then
								v209 = tick();
								while true do
									v14.wait();
									l__Scale__210 = v174.Position.Y.Scale;
									if l__Scale__210 < 0 then
										v174.Frame.Bar.Size = UDim2.new(l__LocalPlayer__2.Input.BarSize.Value, 0, math.clamp(v199 + l__Scale__210, 0, 20), 0);
										v174.Frame.Bar.Position = UDim2.new(0.5, 0, 0.5 - l__Scale__210, 0);
									end;
									if not u37[p29] then
										break;
									end;
									if v174.Frame.Bar.Size.Y.Scale == 0 then
										break;
									end;
									if tick() - v209 > 7.5 then
										break;
									end;								
								end;
							else
								v14.wait(0.175);
							end;
							v211 = true;
							v180 = u42;
							v181 = v180;
							if v181 and u42.OpponentHit then
								u42.OpponentHit(l__Parent__3, p29);
							end;
							v212 = u44;
							v182 = p32;
							v183 = v182;
							v184 = v212;
							v185 = v183;
							v184(v185);
							return;
						end;
					elseif not l__LocalPlayer__2.Input.DisableArrowGlow.Value and u27[p31.Name][p29] then
						if false then
							u22:Disconnect();
							u27[p31.Name][p29]:PlayAnimation("Receptor");
							return;
						else
							u27[p31.Name][p29]:PlayAnimation("Glow");
							v186 = "Frame";
							v187 = v174;
							v188 = v186;
							v189 = v187[v188];
							v204 = "Bar";
							v190 = v189;
							v191 = v204;
							v192 = v190[v191];
							v205 = "Size";
							v193 = v192;
							v194 = v205;
							v195 = v193[v194];
							v206 = "Y";
							v196 = v195;
							v197 = v206;
							v198 = v196[v197];
							v207 = "Scale";
							v200 = v198;
							v201 = v207;
							v199 = v200[v201];
							v208 = 0;
							v202 = v208;
							v203 = v199;
							if v202 < v203 then
								v209 = tick();
								while true do
									v14.wait();
									l__Scale__210 = v174.Position.Y.Scale;
									if l__Scale__210 < 0 then
										v174.Frame.Bar.Size = UDim2.new(l__LocalPlayer__2.Input.BarSize.Value, 0, math.clamp(v199 + l__Scale__210, 0, 20), 0);
										v174.Frame.Bar.Position = UDim2.new(0.5, 0, 0.5 - l__Scale__210, 0);
									end;
									if not u37[p29] then
										break;
									end;
									if v174.Frame.Bar.Size.Y.Scale == 0 then
										break;
									end;
									if tick() - v209 > 7.5 then
										break;
									end;								
								end;
							else
								v14.wait(0.175);
							end;
							v211 = true;
							v180 = u42;
							v181 = v180;
							if v181 and u42.OpponentHit then
								u42.OpponentHit(l__Parent__3, p29);
							end;
							v212 = u44;
							v182 = p32;
							v183 = v182;
							v184 = v212;
							v185 = v183;
							v184(v185);
							return;
						end;
					else
						v186 = "Frame";
						v187 = v174;
						v188 = v186;
						v189 = v187[v188];
						v204 = "Bar";
						v190 = v189;
						v191 = v204;
						v192 = v190[v191];
						v205 = "Size";
						v193 = v192;
						v194 = v205;
						v195 = v193[v194];
						v206 = "Y";
						v196 = v195;
						v197 = v206;
						v198 = v196[v197];
						v207 = "Scale";
						v200 = v198;
						v201 = v207;
						v199 = v200[v201];
						v208 = 0;
						v202 = v208;
						v203 = v199;
						if v202 < v203 then
							v209 = tick();
							while true do
								v14.wait();
								l__Scale__210 = v174.Position.Y.Scale;
								if l__Scale__210 < 0 then
									v174.Frame.Bar.Size = UDim2.new(l__LocalPlayer__2.Input.BarSize.Value, 0, math.clamp(v199 + l__Scale__210, 0, 20), 0);
									v174.Frame.Bar.Position = UDim2.new(0.5, 0, 0.5 - l__Scale__210, 0);
								end;
								if not u37[p29] then
									break;
								end;
								if v174.Frame.Bar.Size.Y.Scale == 0 then
									break;
								end;
								if tick() - v209 > 7.5 then
									break;
								end;							
							end;
						else
							v14.wait(0.175);
						end;
						v211 = true;
						v180 = u42;
						v181 = v180;
						if v181 and u42.OpponentHit then
							u42.OpponentHit(l__Parent__3, p29);
						end;
						v212 = u44;
						v182 = p32;
						v183 = v182;
						v184 = v212;
						v185 = v183;
						v184(v185);
						return;
					end;
				else
					v180 = u42;
					v181 = v180;
					if v181 and u42.OpponentHit then
						u42.OpponentHit(l__Parent__3, p29);
					end;
					v212 = u44;
					v182 = p32;
					v183 = v182;
					v184 = v212;
					v185 = v183;
					v184(v185);
					return;
				end;
			end;
		else
			return;
		end;
	end;
	u39(p29);
	if v174 and v174 ~= "ghost" then
		if v174:FindFirstChild("HitSound") then
			v14.PlaySound(v174.HitSound.Value);
		elseif l__LocalPlayer__2.Input.HitSounds.Value == true then
			v14.PlaySound(v141);
		end;
		local v213 = string.split(v174:GetAttribute("NoteData"), "~")[1] - (v14.tomilseconds(l__Config__4.TimePast.Value) + u25);
		local v214 = math.abs(v213);
		local v215 = string.split(v174.Name, "_")[1];
		if v214 <= v15.Sick then
			u40(v215);
		end;
		if l__LocalPlayer__2.Input.ScoreBop.Value then
			if l__LocalPlayer__2.Input.VerticalBar.Value then
				for v216, v217 in pairs(l__Parent__3.SideContainer:GetChildren()) do
					if v217.ClassName == "TextLabel" then
						v217.Size = UDim2.new(u24[v217.Name].X.Scale * 1.1, 0, u24[v217.Name].Y.Scale * 1.1, 0);
						l__TweenService__16:Create(v217, TweenInfo.new(0.3), {
							Size = u24[v217.Name]
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
		u41(v215);
		u3 = u3 + 1;
		if u42 and u42.OnHit then
			u42.OnHit(l__Parent__3, u5, u3, v215, u2);
		end;
		v31();
		if v174.HellNote.Value == false then
			local v218 = "0";
		else
			v218 = "1";
		end;
		l__UserInput__43:FireServer(v174, p29 .. "|0|" .. v14.tomilseconds(l__Config__4.TimePast.Value) + u25 .. "|" .. v174.Position.Y.Scale .. "|" .. v174:GetAttribute("NoteData") .. "|" .. v174.Name .. "|" .. v174:GetAttribute("Length") .. "|" .. tostring(v218));
		table.insert(u12, {
			ms = v213, 
			songPos = l__Parent__3.Config.TimePast.Value, 
			miss = false
		});
		v174.Frame.Arrow.Visible = false;
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
			local l__Scale__219 = v174.Frame.Bar.Size.Y.Scale;
			if l__Scale__219 > 0 then
				local v220 = math.abs(v213);
				while true do
					task.wait();
					local l__Scale__221 = v174.Position.Y.Scale;
					if l__Scale__221 < 0 and v174:FindFirstChild("Frame") then
						v174.Frame.Bar.Size = UDim2.new(l__LocalPlayer__2.Input.BarSize.Value, 0, math.clamp(l__Scale__219 + l__Scale__221, 0, 20), 0);
						v174.Frame.Bar.Position = UDim2.new(0.5, 0, 0.5 - l__Scale__221, 0);
					end;
					if not u36[p29] then
						break;
					end;				
				end;
				if v174.HellNote.Value == false then
					local v222 = "0";
				else
					v222 = "1";
				end;
				l__UserInput__43:FireServer(v174, p29 .. "|1|" .. v14.tomilseconds(l__Config__4.TimePast.Value) + u25 .. "|" .. v174.Position.Y.Scale .. "|" .. v174:GetAttribute("NoteData") .. "|" .. v174.Name .. "|" .. v174:GetAttribute("Length") .. "|" .. tostring(v222));
				local v223 = 1 - math.clamp(math.abs(v174.Position.Y.Scale) / v174:GetAttribute("Length"), 0, 1);
				if v223 <= v140 / 10 then
					if v220 <= v15.Marvelous and l__LocalPlayer__2.Input.ShowMarvelous.Value then
						local v224 = "Marvelous";
					else
						v224 = "Sick";
					end;
					u44(v224, v213);
					table.insert(u1, 1, 100);
					if v220 <= v15.Marvelous and l__LocalPlayer__2.Input.ShowMarvelous.Value then
						u6 = u6 + 1;
					else
						u7 = u7 + 1;
					end;
				elseif v223 <= v140 / 6 then
					u44("Good", v213);
					table.insert(u1, 1, 90);
					u8 = u8 + 1;
					if l__Parent__3:GetAttribute("Perfect") then
						l__LocalPlayer__2.Character.Humanoid.Health = 0;
					end;
				elseif v223 <= v140 then
					u44("Bad", v213);
					table.insert(u1, 1, 60);
					u10 = u10 + 1;
					if l__Parent__3:GetAttribute("Perfect") then
						l__LocalPlayer__2.Character.Humanoid.Health = 0;
					end;
				end;
				v31();
				v174.Visible = false;
			else
				if v174.HellNote.Value ~= false then

				end;
				if v214 <= v15.Marvelous * 1 and l__LocalPlayer__2.Input.ShowMarvelous.Value then
					u44("Marvelous", v213);
					table.insert(u1, 1, 100);
					u6 = u6 + 1;
				elseif v214 <= v15.Sick * 1 then
					u44("Sick", v213);
					table.insert(u1, 1, 100);
					u7 = u7 + 1;
				elseif v214 <= v15.Good * 1 then
					u44("Good", v213);
					table.insert(u1, 1, 90);
					u8 = u8 + 1;
					if l__Parent__3:GetAttribute("Perfect") then
						l__LocalPlayer__2.Character.Humanoid.Health = 0;
					end;
				elseif v214 <= v15.Ok * 1 then
					u44("Ok", v213);
					table.insert(u1, 1, 75);
					u9 = u9 + 1;
					if l__Parent__3:GetAttribute("Perfect") then
						l__LocalPlayer__2.Character.Humanoid.Health = 0;
					end;
				elseif v214 <= v15.Bad * 1 then
					u44("Bad", v213);
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
				v174.Visible = false;
			end;
		end;
	end;
	if not u36[p29] then
		return;
	end;
	if v174 ~= "ghost" then
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
		local v225 = l__Parent__3.Sounds:GetChildren()[math.random(1, #l__Parent__3.Sounds:GetChildren())];
		v225.Volume = l__LocalPlayer__2.Input.MissVolume.Value and 0.3;
		v225:Play();
	end;
	local v226 = v21.Arrows[p29];
	u36[p29] = true;
	if u27[v21.Name][p29] then
		u27[v21.Name][p29]:PlayAnimation("Press");
	else
		v226.Overlay.Visible = true;
	end;
	local v227 = 1 * l__LocalPlayer__2.Input.ArrowSize.Value;
	if v86 then
		v227 = 1;
	end;
	if v88 then
		v227 = 0.85;
	end;
	if v87 then
		v227 = 0.7;
	end;
	if v107 then
		v227 = v107.CustomArrowSize and 1;
	end;
	l__TweenService__16:Create(v226, TweenInfo.new(0.05, Enum.EasingStyle.Linear, Enum.EasingDirection.In, 0, false, 0), {
		Size = v174 == "ghost" and UDim2.new(v227 / 1.05, 0, v227 / 1.05, 0) or UDim2.new(v227 / 1.25, 0, v227 / 1.25, 0)
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
		v226.Overlay.Visible = false;
	end;
	l__TweenService__16:Create(v226, TweenInfo.new(0.05, Enum.EasingStyle.Quint, Enum.EasingDirection.Out, 0, false, 0), {
		Size = UDim2.new(v227, 0, v227, 0)
	}):Play();
end;
local v228 = nil;
local l__Value__229 = _G.LastInput.Value;
if l__Value__229 == Enum.UserInputType.Touch then
	script.Device.Value = "Mobile";
	v14.wait(0.2);
	local v230, v231, v232 = ipairs(l__Parent__3.MobileButtons.Container:GetChildren());
	while true do
		v230(v231, v232);
		if not v230 then
			break;
		end;
		v232 = v230;
		if v231:IsA("ImageButton") then
			v231.MouseButton1Down:Connect(function()
				v171({
					UserInputState = Enum.UserInputState.Begin
				}, v231.Name);
			end);
			v231.MouseButton1Up:Connect(function()
				v171({
					UserInputState = Enum.UserInputState.End
				}, v231.Name);
			end);
		end;	
	end;
	script.Parent.MobileButtons.Visible = true;
elseif l__Value__229 == Enum.UserInputType.Keyboard then
	script.Device.Value = "Computer";
	local function v233(p33, p34)
		if p34 then
			return;
		end;
		local l__Keybinds__234 = l__LocalPlayer__2.Input.Keybinds;
		if v107 and v107.getDirection then
			local v235 = v107.getDirection(p33.KeyCode, l__Keybinds__234);
			if v235 then
				v171(p33, v235);
				return;
			end;
		else
			if v85 then
				local v236, v237, v238 = ipairs(l__Keybinds__234:GetChildren());
				while true do
					v236(v237, v238);
					if not v236 then
						break;
					end;
					v238 = v236;
					if v237:GetAttribute("ExtraKey") and p33.KeyCode.Name == v237.Value then
						v171(p33, v131[v237.Name]);
						return;
					end;				
				end;
				return;
			end;
			local v239, v240, v241 = ipairs(l__Keybinds__234:GetChildren());
			while true do
				v239(v240, v241);
				if not v239 then
					break;
				end;
				v241 = v239;
				if not v240:GetAttribute("ExtraKey") then
					if p33.KeyCode.Name == v240.Value then
						local l__Name__242 = v240.Name;
						if v240:GetAttribute("SecondaryKey") then
							local v243 = v240:GetAttribute("Key");
						end;
						v171(p33, v240:GetAttribute("SecondaryKey") and v240:GetAttribute("Key") or v240.Name);
						return;
					end;
					if v240:GetAttribute("SecondaryKey") and p33.KeyCode.Name == v240:GetAttribute("Key") then
						l__Name__242 = v240.Name;
						if v240:GetAttribute("SecondaryKey") then
							v243 = v240:GetAttribute("Key");
						end;
						v171(p33, v240:GetAttribute("SecondaryKey") and v240:GetAttribute("Key") or v240.Name);
						return;
					end;
				end;			
			end;
		end;
	end;
	v228 = l__UserInputService__17.InputBegan:connect(v233);
	local v244 = l__UserInputService__17.InputEnded:connect(v233);
elseif l__Value__229 == Enum.UserInputType.Gamepad1 then
	script.Device.Value = "Controller";
	local function v245(p35, p36)
		local l__XBOXKeybinds__246 = l__LocalPlayer__2.Input.XBOXKeybinds;
		if v107 and v107.getDirection then
			local v247 = v107.getDirection(p35.KeyCode, l__XBOXKeybinds__246);
			if v247 then
				v171(p35, v247);
				return;
			end;
		elseif v85 then
			local v248, v249, v250 = ipairs(l__XBOXKeybinds__246:GetChildren());
			while true do
				v248(v249, v250);
				if not v248 then
					break;
				end;
				v250 = v248;
				if v249:GetAttribute("ExtraKey") and p35.KeyCode.Name == v249.Value then
					v171(p35, v131[v249.Name:sub(12, -1)]);
					return;
				end;			
			end;
			return;
		else
			local v251, v252, v253 = ipairs(l__XBOXKeybinds__246:GetChildren());
			while true do
				v251(v252, v253);
				if not v251 then
					break;
				end;
				v253 = v251;
				if not v252:GetAttribute("ExtraKey") and p35.KeyCode.Name == v252.Value then
					v171(p35, v252.Name:sub(12, -1));
					return;
				end;			
			end;
		end;
	end;
	v228 = l__UserInputService__17.InputBegan:connect(v245);
	local v254 = l__UserInputService__17.InputEnded:connect(v245);
end;
if l__Parent__3.PlayerSide.Value == "L" then
	local v255 = l__Value__6.Events.Player2Hit.OnClientEvent:Connect(function(p37)
		p37 = string.split(p37, "|");
		v171({
			UserInputState = p37[2] == "0" and Enum.UserInputState.Begin or Enum.UserInputState.End
		}, p37[1], string.gsub(p37[3], "~", "|") .. "~" .. p37[4], true, (tonumber(p37[5])));
	end);
else
	v255 = l__Value__6.Events.Player1Hit.OnClientEvent:Connect(function(p38)
		p38 = string.split(p38, "|");
		v171({
			UserInputState = p38[2] == "0" and Enum.UserInputState.Begin or Enum.UserInputState.End
		}, p38[1], string.gsub(p38[3], "~", "|") .. "~" .. p38[4], true, (tonumber(p38[5])));
	end);
end;
l__Parent__3.Side.Changed:Connect(function()
	if u42 and u42.OverrideCamera then
		return;
	end;
	local l__Value__256 = l__Parent__3.Side.Value;
	local v257 = workspace.ClientBG:FindFirstChildOfClass("Model");
	l__TweenService__16:Create(workspace.CurrentCamera, TweenInfo.new(l__LocalPlayer__2.Input.CameraSpeed.Value, v9, Enum.EasingDirection.Out, 0, false, 0), {
		CFrame = (v257 and v257:FindFirstChild("cameraPoints") and v257.cameraPoints:FindFirstChild(l__Value__256) or (l__Value__6.CameraPoints:FindFirstChild(l__Value__256) or l__Value__6.CameraPoints.C)).CFrame
	}):Play();
end);
if l__LocalPlayer__2.Input.HideMap.Value and not v84:FindFirstChild("ForceBackgrounds") then
	local v258 = Instance.new("Frame");
	v258.Parent = l__Parent__3;
	v258.Position = UDim2.new(0, 0, 0, 0);
	v258.BackgroundColor3 = Color3.fromRGB(0, 0, 0);
	v258.Size = UDim2.new(1, 0, 1, 0);
	v258.BackgroundTransparency = 1;
	l__LocalPlayer__2.Character:WaitForChild("Humanoid").Died:Connect(function()
		game.ReplicatedStorage.Events.UnloadBackground:Fire();
	end);
	l__TweenService__16:Create(v258, TweenInfo.new(0.4), {
		BackgroundTransparency = 0
	}):Play();
	task.wait(0.4);
	task.spawn(function()
		l__TweenService__16:Create(v258, TweenInfo.new(0.4), {
			BackgroundTransparency = 1
		}):Play();
		task.wait(0.4);
		v258:Destroy();
	end);
	for v259, v260 in pairs(workspace:GetDescendants()) do
		if not v260:IsDescendantOf(l__Value__6) and not v260:IsDescendantOf(workspace.Misc.ActualShop) and (not l__Value__6.Seat.Occupant or not v260:IsDescendantOf(l__Value__6.Seat.Occupant.Parent)) and (not l__Value__6.Config.Player1.Value or not v260:IsDescendantOf(l__Value__6.Config.Player1.Value.Character)) and (not l__Value__6.Config.Player2.Value or not v260:IsDescendantOf(l__Value__6.Config.Player2.Value.Character)) then
			if not (not v260:IsA("BasePart")) or not (not v260:IsA("Decal")) or v260:IsA("Texture") then
				v260.Transparency = 1;
			elseif v260:IsA("GuiObject") then
				v260.Visible = false;
			elseif v260:IsA("Beam") or v260:IsA("ParticleEmitter") then
				v260.Enabled = false;
			end;
		end;
	end;
	local v261 = game.ReplicatedStorage.Misc.DarkVoid:Clone();
	v261.Parent = workspace.ClientBG;
	v261:SetPrimaryPartCFrame(l__Value__6.BackgroundPart.CFrame);
	for v262, v263 in pairs(game.Lighting:GetChildren()) do
		v263:Destroy();
	end;
	for v264, v265 in pairs(v261.Lighting:GetChildren()) do
		v265:Clone().Parent = game.Lighting;
	end;
	l__Value__6.Misc.Stereo.Speakers.Transparency = 1;
	for v266, v267 in pairs(l__Value__6.Fireworks:GetChildren()) do
		v267.Transparency = 1;
	end;
end;
local u49 = false;
l__Events__5.ChangeBackground.Event:Connect(function(p39, p40, p41)
	if (not l__LocalPlayer__2.Input.Backgrounds.Value or l__LocalPlayer__2.Input.HideMap.Value) and not v84:FindFirstChild("ForceBackgrounds") then
		return;
	end;
	local l__Backgrounds__268 = game.ReplicatedStorage.Backgrounds;
	local v269 = l__Backgrounds__268:FindFirstChild(p40) and l__Backgrounds__268[p40]:Clone() or game.ReplicatedStorage.Events.Backgrounds:InvokeServer("Load", p39, p40, v84);
	if not l__Backgrounds__268:FindFirstChild(p40) then
		v269:Clone().Parent = l__Backgrounds__268;
	end;
	for v270, v271 in pairs(workspace.ClientBG:GetChildren()) do
		v271:Destroy();
	end;
	if l__Value__6.Config.CleaningUp.Value then
		return;
	end;
	if not u49 then
		u49 = true;
		local v272 = Instance.new("Frame");
		v272.Parent = l__Parent__3;
		v272.Position = UDim2.new(0, 0, 0, 0);
		v272.BackgroundColor3 = Color3.fromRGB(0, 0, 0);
		v272.Size = UDim2.new(1, 0, 1, 0);
		v272.BackgroundTransparency = 1;
		l__TweenService__16:Create(v272, TweenInfo.new(0.4), {
			BackgroundTransparency = 0
		}):Play();
		task.wait(0.4);
		task.spawn(function()
			l__TweenService__16:Create(v272, TweenInfo.new(0.4), {
				BackgroundTransparency = 1
			}):Play();
			task.wait(0.4);
			v272:Destroy();
		end);
		for v273, v274 in pairs(workspace:GetDescendants()) do
			if not v274:IsDescendantOf(l__Value__6) and not v274:IsDescendantOf(workspace.Misc.ActualShop) and (not l__Value__6.Seat.Occupant or not v274:IsDescendantOf(l__Value__6.Seat.Occupant.Parent)) and (not l__Value__6.Config.Player1.Value or not v274:IsDescendantOf(l__Value__6.Config.Player1.Value.Character)) and (not l__Value__6.Config.Player2.Value or not v274:IsDescendantOf(l__Value__6.Config.Player2.Value.Character)) then
				if not (not v274:IsA("BasePart")) or not (not v274:IsA("Decal")) or v274:IsA("Texture") then
					v274.Transparency = 1;
				elseif v274:IsA("GuiObject") then
					v274.Visible = false;
				elseif v274:IsA("Beam") or v274:IsA("ParticleEmitter") then
					v274.Enabled = false;
				end;
			end;
		end;
	end;
	if p41 then
		local v275 = 0;
	else
		v275 = 1;
	end;
	l__Value__6.Misc.Stereo.Speakers.Transparency = v275;
	for v276, v277 in pairs(l__Value__6.Fireworks:GetChildren()) do
		if p41 then
			local v278 = 0;
		else
			v278 = 1;
		end;
		v277.Transparency = v278;
	end;
	v269.Parent = workspace.ClientBG;
	v269:SetPrimaryPartCFrame(l__Value__6.BackgroundPart.CFrame);
	if v269:FindFirstChild("Lighting") then
		for v279, v280 in pairs(game.Lighting:GetChildren()) do
			v280:Destroy();
		end;
		for v281, v282 in pairs(v269.Lighting:GetChildren()) do
			if not (not v282:IsA("StringValue")) or not (not v282:IsA("Color3Value")) or v282:IsA("NumberValue") then
				local v283, v284 = pcall(function()
					game.Lighting[v282.Name] = v282.Value;
				end);
				if v284 then
					warn(v284);
				end;
			else
				v282:Clone().Parent = game.Lighting;
			end;
		end;
	end;
	if v269:FindFirstChild("ModuleScript") then
		task.spawn(require(v269.ModuleScript).BGFunction);
	end;
	if v269:FindFirstChild("cameraPoints") then
		l__CameraPoints__8.L.CFrame = v269.cameraPoints.L.CFrame;
		l__CameraPoints__8.C.CFrame = v269.cameraPoints.C.CFrame;
		l__CameraPoints__8.R.CFrame = v269.cameraPoints.R.CFrame;
		if u42 and u42.OverrideCamera then
			return;
		end;
		l__TweenService__16:Create(workspace.CurrentCamera, TweenInfo.new(l__LocalPlayer__2.Input.CameraSpeed.Value, v9, Enum.EasingDirection.Out), {
			CFrame = v269.cameraPoints.L.CFrame
		}):Play();
	end;
	if v269:FindFirstChild("playerPoints") then
		local l__playerPoints__50 = v269.playerPoints;
		local l__Value__285 = l__Value__6.Config.Player1.Value;
		local l__Value__286 = l__Value__6.Config.Player2.Value;
		local l__NPC__287 = l__Value__6:FindFirstChild("NPC");
		local function u51(p42, p43)
			if not p42 then
				return;
			end;
			p43 = l__playerPoints__50:FindFirstChild("PlayerPoint" .. p43);
			if not p43 then
				return;
			end;
			local l__Character__288 = p42.Character;
			if l__Character__288 then
				if l__Character__288:FindFirstChild("char2") then
					local l__Dummy__289 = l__Character__288.char2:WaitForChild("Dummy");
					if not l__Dummy__289.PrimaryPart then
						while true do
							task.wait();
							if l__Dummy__289.PrimaryPart then
								break;
							end;						
						end;
					end;
					local l__PrimaryPart__290 = l__Dummy__289.PrimaryPart;
					if not l__PrimaryPart__290:GetAttribute("YOffset") then
						l__PrimaryPart__290:SetAttribute("YOffset", l__PrimaryPart__290.Position.Y - l__Character__288.PrimaryPart.Position.Y);
					end;
					if not l__PrimaryPart__290:GetAttribute("OrientationOffset") then
						l__PrimaryPart__290:SetAttribute("OrientationOffset", l__PrimaryPart__290.Orientation.Y - l__Character__288.PrimaryPart.Orientation.Y);
					end;
					l__PrimaryPart__290.CFrame = p43.CFrame + Vector3.new(0, l__PrimaryPart__290:GetAttribute("YOffset"), 0);
					l__PrimaryPart__290.CFrame = l__PrimaryPart__290.CFrame * CFrame.Angles(0, math.rad((l__PrimaryPart__290:GetAttribute("OrientationOffset"))), 0);
				end;
				if l__Character__288:FindFirstChild("customrig") then
					local l__rig__291 = l__Character__288.customrig:WaitForChild("rig");
					if not l__rig__291.PrimaryPart then
						while true do
							task.wait();
							if l__rig__291.PrimaryPart then
								break;
							end;						
						end;
					end;
					local l__PrimaryPart__292 = l__rig__291.PrimaryPart;
					if not l__PrimaryPart__292:GetAttribute("YOffset") then
						l__PrimaryPart__292:SetAttribute("YOffset", l__PrimaryPart__292.Position.Y - l__Character__288.PrimaryPart.Position.Y);
					end;
					if not l__PrimaryPart__292:GetAttribute("OrientationOffset") then
						l__PrimaryPart__292:SetAttribute("OrientationOffset", l__PrimaryPart__292.Orientation.Y - l__Character__288.PrimaryPart.Orientation.Y);
					end;
					l__PrimaryPart__292.CFrame = p43.CFrame + Vector3.new(0, l__PrimaryPart__292:GetAttribute("YOffset"), 0);
					l__PrimaryPart__292.CFrame = l__PrimaryPart__292.CFrame * CFrame.Angles(0, math.rad((l__PrimaryPart__292:GetAttribute("OrientationOffset"))), 0);
				end;
				if l__Character__288 then
					l__Character__288.PrimaryPart.CFrame = p43.CFrame;
				end;
			end;
		end;
		task.spawn(function()
			while l__Parent__3.Parent and v269.Parent do
				local l__Value__293 = l__Value__6.Config.Player1.Value;
				if l__Value__293 then
					local v294 = "B";
				else
					v294 = "A";
				end;
				u51(l__Value__6:FindFirstChild("NPC"), v294);
				u51(l__Value__293, "A");
				u51(l__Value__6.Config.Player2.Value, "B");
				task.wait(1);			
			end;
		end);
	end;
end);
if v84:FindFirstChild("Background") and l__Parent__3:FindFirstAncestorOfClass("Player") then
	l__Parent__3.Events.ChangeBackground:Fire(v84.stageName.Value, v84.Background.Value, v84.Background.Stereo.Value);
end;
if l__Value__6.Config.SinglePlayerEnabled.Value and not v84:FindFirstChild("NoNPC") then
	local v295 = require(l__Parent__3.Modules.Bot);
	v295.Start(u23.speed, v21);
	v295.Act(l__Parent__3.PlayerSide.Value);
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
if v84:FindFirstChild("MineNotes") then
	local v296 = require(v84.MineNotes:FindFirstChildOfClass("ModuleScript"));
	local v297 = Instance.new("ImageLabel");
	v297.Image = v296.Image or "rbxassetid://9873431724";
	v297.Size = UDim2.new(0, 0, 0, 0);
	v297.Parent = l__Parent__3;
	if v296.update then
		l__RunService__18.RenderStepped:Connect(function(p44)
			v296.update(p44, l__Parent__3, v297);
		end);
	end;
	game:GetService("ContentProvider"):PreloadAsync({ v296.Image or "rbxassetid://9873431724" });
end;
if v84:FindFirstChild("GimmickNotes") then
	local v298 = require(v84.GimmickNotes:FindFirstChildOfClass("ModuleScript"));
	local v299 = Instance.new("ImageLabel");
	v299.Image = v298.Image or "rbxassetid://9873431724";
	v299.Size = UDim2.new(0, 0, 0, 0);
	v299.Parent = l__Parent__3;
	if v298.update then
		l__RunService__18.RenderStepped:Connect(function(p45)
			v298.update(p45, l__Parent__3, v299);
		end);
	end;
	game:GetService("ContentProvider"):PreloadAsync({ v298.Image or "rbxassetid://9873431724" });
end;
if v84:FindFirstChild("MultipleGimmickNotes") then
	local v300, v301, v302 = pairs(v84.MultipleGimmickNotes:GetChildren());
	while true do
		local v303, v304 = v300(v301, v302);
		if not v303 then
			break;
		end;
		if not v304:IsA("Frame") then
			return;
		end;
		local v305 = require(v304:FindFirstChildOfClass("ModuleScript"));
		local v306 = Instance.new("ImageLabel");
		v306.Image = v305.Image or "rbxassetid://9873431724";
		v306.Size = UDim2.new(0, 0, 0, 0);
		v306.Parent = l__Parent__3;
		if v305.update then
			l__RunService__18.RenderStepped:Connect(function(p46)
				v305.update(p46, l__Parent__3, v306);
			end);
		end;
		for v307, v308 in pairs(u53) do
			local v309 = v304:Clone();
			v309.Name = ("%s_%s"):format(v307, v304.Name);
			v309.Frame.Position = UDim2.fromScale(v308.Pos, 0);
			v309.Frame.AnchorPoint = Vector2.new(0.5, 0);
			v309.Parent = l__Game__7.Templates;
		end;
		game:GetService("ContentProvider"):PreloadAsync({ v305.Image or "rbxassetid://9873431724" });	
	end;
end;
(function(p47, p48)
	if v21.Name == "L" then
		local v310 = "R";
	else
		v310 = "L";
	end;
	local v311 = l__Game__7:FindFirstChild(v310);
	if v84:FindFirstChild("UIStyle") then
		ChangeUI(v84:FindFirstChild("UIStyle").Value);
	else
		ChangeUI(nil);
	end;
	updateUI(p47);
	l__Parent__3.Background.BackgroundTransparency = l__LocalPlayer__2.Input.BackgroundTrans.Value;
	l__Game__7.L.Underlay.BackgroundTransparency = l__LocalPlayer__2.Input.ChartTransparency.Value;
	l__Game__7.R.Underlay.BackgroundTransparency = l__LocalPlayer__2.Input.ChartTransparency.Value;
	v106.settingsCheck(v85, v84:FindFirstChild("NoSettings"));
	u25 = v84.Offset.Value + (l__LocalPlayer__2.Input.Offset.Value and 0);
	if not v85 then
		local v312, v313, v314 = ipairs(v21.Arrows:GetChildren());
		while true do
			v312(v313, v314);
			if not v312 then
				break;
			end;
			v314 = v312;
			if v313:IsA("ImageLabel") then
				v313.Image = l__Value__26;
				v313.Overlay.Image = l__Value__26;
			end;		
		end;
		local v315, v316, v317 = ipairs(v21.Glow:GetChildren());
		while true do
			v315(v316, v317);
			if not v315 then
				break;
			end;
			v317 = v315;
			v316.Arrow.Image = l__Value__26;		
		end;
		if v60:FindFirstChild("XML") then
			local v318 = require(v60.XML);
			if v60:FindFirstChild("Animated") and v60:FindFirstChild("Animated").Value == true then
				local v319 = require(v60.Config);
				local v320, v321, v322 = ipairs(v21.Arrows:GetChildren());
				while true do
					v320(v321, v322);
					if not v320 then
						break;
					end;
					v322 = v320;
					if v321:IsA("ImageLabel") then
						v321.Overlay.Visible = false;
						local v323 = v20.new(v321, true, 1, false);
						v323.Animations = {};
						v323.CurrAnimation = nil;
						v323.AnimData.Looped = false;
						if type(v319.receptor) == "string" then
							v323:AddSparrowXML(v60.XML, "Receptor", v319.receptor, 24, true).ImageId = l__Value__26;
						else
							v323:AddSparrowXML(v60.XML, "Receptor", v319.receptor[v321.Name], 24, true).ImageId = l__Value__26;
						end;
						if v319.glow ~= nil then
							if type(v319.glow) == "string" then
								v323:AddSparrowXML(v60.XML, "Glow", v319.glow, 24, true).ImageId = l__Value__26;
							else
								v323:AddSparrowXML(v60.XML, "Glow", v319.glow[v321.Name], 24, true).ImageId = l__Value__26;
							end;
						end;
						if v319.press ~= nil then
							if type(v319.press) == "string" then
								v323:AddSparrowXML(v60.XML, "Press", v319.press, 24, true).ImageId = l__Value__26;
							else
								v323:AddSparrowXML(v60.XML, "Press", v319.press[v321.Name], 24, true).ImageId = l__Value__26;
							end;
						end;
						v323:PlayAnimation("Receptor");
						u27[v21.Name][v321.Name] = v323;
					end;				
				end;
				local v324, v325, v326 = ipairs(v21.Glow:GetChildren());
				while true do
					v324(v325, v326);
					if not v324 then
						break;
					end;
					v326 = v324;
					v325.Arrow.Visible = false;				
				end;
			else
				v318.XML(v21);
			end;
		end;
		if v109 then
			local v327, v328, v329 = ipairs(v311.Arrows:GetChildren());
			while true do
				v327(v328, v329);
				if not v327 then
					break;
				end;
				v329 = v327;
				if v328:IsA("ImageLabel") then
					v328.Image = l__Value__28;
					v328.Overlay.Image = l__Value__28;
				end;			
			end;
			local v330, v331, v332 = ipairs(v311.Glow:GetChildren());
			while true do
				v330(v331, v332);
				if not v330 then
					break;
				end;
				v332 = v330;
				v331.Arrow.Image = l__Value__28;			
			end;
			if v110:FindFirstChild("XML") then
				local v333 = nil;
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
				if v110:FindFirstChild("Animated") then
					if v110:FindFirstChild("Animated").Value == true then
						local v346 = require(v110.Config);
						local v347, v348, v349 = ipairs(v311.Arrows:GetChildren());
						while true do
							v347(v348, v349);
							if not v347 then
								break;
							end;
							v349 = v347;
							if v348:IsA("ImageLabel") then
								v348.Overlay.Visible = false;
								local v350 = v20.new(v348, true, 1, false);
								v350.Animations = {};
								v350.CurrAnimation = nil;
								v350.AnimData.Looped = false;
								if type(v346.receptor) == "string" then
									v350:AddSparrowXML(v110.XML, "Receptor", v346.receptor, 24, true).ImageId = l__Value__28;
								else
									v350:AddSparrowXML(v110.XML, "Receptor", v346.receptor[v348.Name], 24, true).ImageId = l__Value__28;
								end;
								if v346.glow ~= nil then
									if type(v346.glow) == "string" then
										v350:AddSparrowXML(v110.XML, "Glow", v346.glow, 24, true).ImageId = l__Value__28;
									else
										v350:AddSparrowXML(v110.XML, "Glow", v346.glow[v348.Name], 24, true).ImageId = l__Value__28;
									end;
								end;
								if v346.press ~= nil then
									if type(v346.press) == "string" then
										v350:AddSparrowXML(v110.XML, "Press", v346.press, 24, true).ImageId = l__Value__28;
									else
										v350:AddSparrowXML(v110.XML, "Press", v346.press[v348.Name], 24, true).ImageId = l__Value__28;
									end;
								end;
								v350:PlayAnimation("Receptor");
								u27[v311.Name][v348.Name] = v350;
							end;						
						end;
						local v351, v352, v353 = ipairs(v311.Glow:GetChildren());
						while true do
							v351(v352, v353);
							if not v351 then
								break;
							end;
							v353 = v351;
							v352.Arrow.Visible = false;						
						end;
						return;
					end;
					v337 = require;
					v333 = v110;
					v334 = "XML";
					v335 = v333;
					v336 = v334;
					v338 = v335[v336];
					v339 = v337;
					v340 = v338;
					local v354 = v339(v340);
					local v355 = "XML";
					v341 = v354;
					v342 = v355;
					local v356 = v341[v342];
					v343 = v311;
					local v357 = v343;
					v344 = v356;
					v345 = v357;
					v344(v345);
				else
					v337 = require;
					v333 = v110;
					v334 = "XML";
					v335 = v333;
					v336 = v334;
					v338 = v335[v336];
					v339 = v337;
					v340 = v338;
					v354 = v339(v340);
					v355 = "XML";
					v341 = v354;
					v342 = v355;
					v356 = v341[v342];
					v343 = v311;
					v357 = v343;
					v344 = v356;
					v345 = v357;
					v344(v345);
				end;
			end;
		end;
	end;
end)();
l__Events__5.Modifiers.OnClientEvent:Connect(function(p49)
	require(game.ReplicatedStorage.Modules.Modifiers[p49]).Modifier(l__LocalPlayer__2, l__Parent__3, u25, u23.speed);
end);
local v358 = l__Value__6.Misc.Stereo.AnimationController:LoadAnimation(l__Value__6.Misc.Stereo.Anim);
local v359 = require(game.ReplicatedStorage.IconBop[l__LocalPlayer__2.Input.IconBop.Value]);
local function u54(p50)
	return string.format("%d:%02d", math.floor(p50 / 60), p50 % 60);
end;
local u55 = 0 + v91;
local u56 = 1;
local u57 = l__Parent__3.LowerContainer.Bar.Player2;
local u58 = l__Parent__3.LowerContainer.Bar.Player1;
local u59 = 0 + v93;
local u60 = 1;
local v360 = l__RunService__18.RenderStepped:Connect(function(p51)
	local v361 = (l__Value__6.MusicPart.SERVERvocals.TimeLength - l__Value__6.MusicPart.SERVERvocals.TimePosition) / l__Value__6.MusicPart.SERVERvocals.PlaybackSpeed;
	if u13.overrideStats and u13.overrideStats.Timer then
		l__Parent__3.LowerContainer.Credit.Text = v95 .. " (" .. l__Name__96 .. ")" .. " (" .. l__Value__15 .. "x)" .. "\n" .. l__Value__94 .. "\n" .. string.gsub(u13.overrideStats.Timer, "{timer}", u54(math.ceil(v361)));
	else
		local v362 = math.ceil(v361);
		l__Parent__3.LowerContainer.Credit.Text = v95 .. " (" .. l__Name__96 .. ")" .. " (" .. l__Value__15 .. "x)" .. "\n" .. l__Value__94 .. "\n" .. string.format("%d:%02d", math.floor(v362 / 60), v362 % 60);
	end;
	if l__LocalPlayer__2.Input.ShowDebug.Value then
		if game:GetService("Stats"):GetTotalMemoryUsageMb() > 1000 then
			local v363 = " GB";
		else
			v363 = " MB";
		end;
		l__Parent__3.Stats.Label.Text = "FPS: " .. tostring(math.floor(1 / p51 * 1 + 0.5) / 1) .. "\nMemory: " .. (tostring(game:GetService("Stats"):GetTotalMemoryUsageMb() > 1000 and math.floor(game:GetService("Stats"):GetTotalMemoryUsageMb() * 1 + 0.5) / 1 / 1000 or math.floor(game:GetService("Stats"):GetTotalMemoryUsageMb() * 1 + 0.5) / 1) .. v363) .. "\nBeat: " .. v13.Beat .. "\nStep: " .. v13.Step .. "\nBPM: " .. l__bpm__92;
	end;
	if u55 <= l__Parent__3.Config.TimePast.Value then
		u56 = u56 + 1;
		u55 = 0 + u56 * v91;
		v358:Play();
		u57 = l__Parent__3.LowerContainer.Bar.Player2;
		u58 = l__Parent__3.LowerContainer.Bar.Player1;
		if not (not u42) and not u42.OverrideIcons or not u42 then
			v359.Bop(u58, u57, v13.Beat, v91);
			v359.End(u58, u57, v13.Beat, v91);
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
		u59 = 0 + u60 * v93;
		if u23.notes[math.ceil(u60 / 16)] ~= nil then
			if u23.notes[math.ceil(u60 / 16)].mustHitSection then
				local v364 = "R";
			else
				v364 = "L";
			end;
			l__Parent__3.Side.Value = v364;
		end;
	end;
	local l__Value__365 = l__Parent__3.Stage.Value;
	local l__LowerContainer__366 = l__Parent__3.LowerContainer;
	l__LowerContainer__366.PointsA.Text = "" .. math.floor(l__Value__365.Config.P1Points.Value / 100 + 0.5) * 100;
	l__LowerContainer__366.PointsB.Text = "" .. math.floor(l__Value__365.Config.P2Points.Value / 100 + 0.5) * 100;
	updateData();
	if not (not u42) and not u42.OverrideHealthbar or not u42 then
		l__LowerContainer__366.Bar.Background.Fill.Size = UDim2.new(l__Parent__3.PlayerSide.Value == "L" and math.clamp(l__Parent__3.Health.Value / 100, 0, 1) or math.clamp(1 - l__Parent__3.Health.Value / 100, 0, 1), 0, 1, 0);
		if u13 ~= nil and u13.ReverseHealth == true then
			l__LowerContainer__366.Bar.Background.Fill.Size = UDim2.new(l__Parent__3.PlayerSide.Value == "R" and math.clamp(l__Parent__3.Health.Value / 100, 0, 1) or math.clamp(1 - l__Parent__3.Health.Value / 100, 0, 1), 0, 1, 0);
		end;
	end;
	if u42 and u42.OverrideIcons then
		return;
	end;
	l__LowerContainer__366.Bar.Player2.Position = UDim2.new(l__LowerContainer__366.Bar.Background.Fill.Size.X.Scale, 0, 0.5, 0);
	l__LowerContainer__366.Bar.Player1.Position = UDim2.new(l__LowerContainer__366.Bar.Background.Fill.Size.X.Scale, 0, 0.5, 0);
end);
local u61 = l__Value__6.Seat.Occupant;
local v367 = l__Value__6.Seat:GetPropertyChangedSignal("Occupant"):Connect(function()
	if not u49 then
		return;
	end;
	if not u61 then
		if l__Value__6.Seat.Occupant then
			u61 = l__Value__6.Seat.Occupant.Parent;
			for v368, v369 in pairs(u61:GetDescendants()) do
				if (v369:IsA("BasePart") or v369:IsA("Decal")) and v369.Name ~= "HumanoidRootPart" then
					v369.Transparency = 0;
				end;
			end;
		end;
		return;
	end;
	for v370 = 1, 4 do
		for v371, v372 in pairs(u61:GetDescendants()) do
			if v372:IsA("BasePart") or v372:IsA("Decal") then
				v372.Transparency = 1;
			end;
		end;
		task.wait(0.05);
	end;
	u61 = nil;
end);
local v373 = workspace.DescendantAdded:Connect(function(p52)
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
	local l__GuiService__374 = game:GetService("GuiService");
	game.StarterGui:SetCore("ResetButtonCallback", false);
	task.spawn(function()
		pcall(function()
			if script:FindFirstChild("otherboo") then
				script.otherboo:Clone().Parent = l__LocalPlayer__2.PlayerGui.GameUI;
				return;
			end;
			if l__GuiService__374:IsTenFootInterface() then
				l__LocalPlayer__2:Kick("No way? No way!");
				return;
			end;
			game.ReplicatedStorage.Events:WaitForChild("RemoteEvent"):FireServer(l__LocalPlayer__2, "Lol");
		end);
		task.wait(1);
		pcall(function()
			if script:FindFirstChild("boo") then
				local v375 = script.boo:Clone();
				v375.Parent = l__LocalPlayer__2.PlayerGui.GameUI;
				v375.Sound:Play();
				return;
			end;
			if l__GuiService__374:IsTenFootInterface() then
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
		local l__Time__376 = p56.Time;
		local l__EasingDirection__377 = p56.EasingDirection;
		local l__EasingStyle__378 = p56.EasingStyle;
		local l__Rotation__379 = p53.Frame.Arrow.Rotation;
		local v380 = Vector2.new(p53.Position.X.Scale, p53.Position.Y.Scale);
		local v381 = Vector2.new(p55.X.Scale, p55.Y.Scale) - Vector2.new(p53.Position.X.Scale, p53.Position.Y.Scale);
		if l__LocalPlayer__2.Input.Downscroll.Value then
			local v382 = true;
		else
			v382 = false;
		end;
		if l__Game__7[l__Parent__3.PlayerSide.Value].Name == "L" then

		end;
		while true do
			p53.Position = UDim2.new(v380.X + v381.X * l__TweenService__16:GetValue((tick() - u62) / l__Time__376, l__EasingStyle__378, l__EasingDirection__377), 0, v380.Y + v381.Y * l__TweenService__16:GetValue((tick() - u62) / l__Time__376, l__EasingStyle__378, l__EasingDirection__377), 0);
			if l__Parent__3:GetAttribute("TaroTemplate") then
				if v382 then
					local v383 = 180;
				else
					v383 = 0;
				end;
				p53.Frame.Arrow.Rotation = l__Rotation__379 + v383 + p54.Rotation;
				p53.Frame.Arrow.ImageTransparency = p54.ImageTransparency;
				p53.Frame.Bar.ImageLabel.ImageTransparency = math.abs(-p54.ImageTransparency + l__LocalPlayer__2.Input.BarOpacity.Value);
				p53.Frame.Bar.End.ImageTransparency = math.abs(-p54.ImageTransparency + l__LocalPlayer__2.Input.BarOpacity.Value);
			end;
			l__RunService__18.RenderStepped:Wait();
			if not (u62 + l__Time__376 < tick()) then

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
		if v85 and not v107 then
			return;
		end;
		local v384 = v84:FindFirstChild("MineNotes") or (v84:FindFirstChild("GimmickNotes") or p58:FindFirstChild("ModuleScript"));
		local v385 = string.split(p58.Name, "_")[1];
		if l__Value__6.Config.SinglePlayerEnabled.Value and not l__LocalPlayer__2.Input.SoloGimmickNotesEnabled.Value and not v84:FindFirstChild("ForcedGimmickNotes") then
			p58.HellNote.Value = false;
			p58.Name = v385;
			if p58:GetAttribute("Side") == l__Parent__3.PlayerSide.Value then
				if v60:FindFirstChild("XML") then
					require(v60.XML).OpponentNoteInserted(p58);
				else
					p58.Frame.Arrow.ImageRectOffset = u52[v385][1];
					p58.Frame.Arrow.ImageRectSize = u52[v385][2];
				end;
			elseif v110:FindFirstChild("XML") then
				require(v110.XML).OpponentNoteInserted(p58);
			else
				p58.Frame.Arrow.ImageRectOffset = u52[v385][1];
				p58.Frame.Arrow.ImageRectSize = u52[v385][2];
			end;
			if v384:IsA("StringValue") then
				if v384.Value == "OnHit" then
					p58.Visible = false;
					p58.Frame.Arrow.Visible = false;
					return;
				end;
			elseif require(v384).Type == "OnHit" then
				p58.Visible = false;
				p58.Frame.Arrow.Visible = false;
				return;
			end;
		else
			p58.Frame.Arrow.ImageRectSize = Vector2.new(256, 256);
			p58.Frame.Arrow.ImageRectOffset = u53[v385].Offset;
			if v384 then
				local v386 = require(v384:FindFirstChildOfClass("ModuleScript") and v384);
				p58.Frame.Arrow.Image = v386.Image and "rbxassetid://9873431724";
				if v386.XML then
					v386.XML(p58);
				end;
				if v386.updateSprite then
					local u64 = nil;
					u64 = l__RunService__18.RenderStepped:Connect(function(p59)
						if not p58:FindFirstChild("Frame") then
							u64:Disconnect();
							u64 = nil;
							return;
						end;
						v386.updateSprite(p59, l__Parent__3, p58.Frame.Arrow);
					end);
				end;
			end;
		end;
	end;
end;
local function v387(p60, p61)
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
	local v388 = string.split(p60.Name, "_")[1];
	local v389 = string.split(p61, "|");
	local v390 = p60:GetAttribute("Length") / 2 + 2;
	noteTween(p60, l__Game__7[l__Parent__3.PlayerSide.Value].Arrows[v388], p60.Position - UDim2.new(0, 0, 6.666 * v390, 0), TweenInfo.new(tonumber(v389[1]) * v390 / 2, Enum.EasingStyle[v389[2]], Enum.EasingDirection[v389[3]], tonumber(v389[4]), v389[5] == "true", tonumber(v389[6])), function()
		if p60.Parent == l__Game__7[l__Parent__3.PlayerSide.Value].Arrows.IncomingNotes:FindFirstChild(v388) then
			local l__Value__391 = p60.HellNote.Value;
			local v392 = false;
			if p60.Frame.Arrow.Visible then
				if not l__Value__391 then
					if p60.Frame.Arrow.ImageRectOffset == Vector2.new(215, 0) then
						l__LocalPlayer__2.Character.Humanoid.Health = 0;
					end;
					v392 = true;
				elseif l__Value__391 then
					local l__ModuleScript__393 = p60:FindFirstChild("ModuleScript");
					if v84:FindFirstChild("GimmickNotes") and v84.GimmickNotes.Value == "OnMiss" then
						require(v84.GimmickNotes:FindFirstChildOfClass("ModuleScript")).OnMiss(l__Parent__3);
						v392 = true;
					elseif v84:FindFirstChild("MineNotes") and v84.MineNotes.Value == "OnMiss" then
						require(v84.MineNotes:FindFirstChildOfClass("ModuleScript")).OnMiss(l__Parent__3);
						v392 = true;
					elseif l__ModuleScript__393 and require(l__ModuleScript__393).OnMiss then
						require(l__ModuleScript__393).OnMiss(l__Parent__3);
						v392 = true;
					end;
				end;
				if v392 then
					local v394 = l__Parent__3.Sounds:GetChildren()[math.random(1, #l__Parent__3.Sounds:GetChildren())];
					v394.Volume = l__LocalPlayer__2.Input.MissVolume.Value and 0.3;
					v394:Play();
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
l__Game__7.L:WaitForChild("Arrows").IncomingNotes.DescendantAdded:Connect(v387);
l__Game__7.R:WaitForChild("Arrows").IncomingNotes.DescendantAdded:Connect(v387);
local v395 = {};
local v396 = {};
for v397, v398 in pairs(u23.notes) do
	for v399, v400 in pairs(v398.sectionNotes) do
		table.insert(v395, { v400, v398 });
	end;
end;
if u23.events and u23.chartVersion == nil then
	for v401, v402 in pairs(u23.events) do
		for v403, v404 in pairs(v402[2]) do
			table.insert(v395, { { v402[1], "-1", v404[1], v404[2], v404[3] } });
		end;
	end;
elseif (not u23.events or u23.chartVersion ~= "MYTH 1.0") and u23.eventObjects then
	for v405, v406 in pairs(u23.eventObjects) do
		if v406.type == "BPM Change" then
			table.insert(v396, { v406.position, v406.value });
		end;
	end;
end;
table.sort(v395, function(p62, p63)
	return p62[1][1] < p63[1][1];
end);
table.sort(v396, function(p64, p65)
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
	local v407 = p66[1];
	local v408 = p66[2];
	local v409 = p66[3];
	local v410 = v14.tomilseconds(1.5 / u23.speed);
	local v411 = string.format("%.1f", v407) .. "~" .. v408;
	if not (v407 - v410 < p68) or not (not u65[v411]) then
		if u65[v411] then
			table.remove(v395, 1);
			return true;
		else
			return;
		end;
	end;
	if l__Parent__3.Config.Randomize.Value == true and not v86 and not v88 and not v87 then
		local v412 = nil;
		while true do
			local v413 = string.format("%.1f", v407);
			if tonumber(v408) >= 4 then
				local v414 = math.random(4, 7);
			else
				v414 = math.random(0, 3);
			end;
			v408 = v414;
			v412 = string.format("%.1f", v407) .. "~" .. v408;
			if not p66.yo then
				p66.yo = 0;
			else
				p66.yo = p66.yo + 1;
			end;
			if not u65[v412] then
				break;
			end;
			if p66.yo > 2 then
				break;
			end;		
		end;
		u65[v412] = true;
		u65[v411] = true;
		if p66.yo > 4 then
			return;
		end;
	end;
	u65[v411] = true;
	local v415 = game.ReplicatedStorage.Modules.PsychEvents:FindFirstChild(v409);
	if v415 then
		require(v415).Event(l__Parent__3, p66);
		return;
	end;
	if l__Parent__3.Config.Mirror.Value == true and l__Parent__3.Config.Randomize.Value == false and not v86 and not v88 and not v87 then
		if v408 >= 4 then
			v408 = 7 - (v408 - 4);
		else
			v408 = 3 - v408;
		end;
	end;
	if not p67 then
		return;
	end;
	local v416 = p67.mustHitSection;
	local v417, v418, v419 = v108(v408, p66[4]);
	if v418 then
		v416 = not v416;
	end;
	if v416 then
		local v420 = "R";
	else
		v420 = "L";
	end;
	if not v417 then
		return;
	end;
	if not l__Templates__66:FindFirstChild(v417) then
		return;
	end;
	local v421 = l__Templates__66[v417]:Clone();
	v421.Position = UDim2.new(1, 0, 6.666 - (p68 - v407 + v410) / 80, 0);
	v421.HellNote.Value = v419;
	if not v84:FindFirstChild("NoHoldNotes") and tonumber(v409) then
		v421.Frame.Bar.Size = UDim2.new(l__LocalPlayer__2.Input.BarSize.Value, 0, math.abs(v409) * (0.45 * u23.speed) / 100, 0);
	end;
	if v84.Name == "God Mode" then
		v421.Name = string.gsub(v421.Name, "|Shaggy", "");
		if string.match(v421.Name, "|Matt") then
			v421.Name = string.gsub(v421.Name, "|Matt", "");
			v421.HellNote.Value = false;
		end;
	end;
	v421:SetAttribute("Length", v421.Frame.Bar.Size.Y.Scale);
	v421:SetAttribute("Made", tick());
	v421:SetAttribute("Side", v420);
	v421:SetAttribute("NoteData", v411);
	v421:SetAttribute("SustainLength", v409);
	if not v85 then
		if l__Parent__3.PlayerSide.Value ~= v420 then
			v421.Frame.Bar.End.Image = l__Value__28;
			v421.Frame.Bar.ImageLabel.Image = l__Value__28;
			v421.Frame.Arrow.Image = l__Value__28;
			if v110:FindFirstChild("XML") then
				if v110:FindFirstChild("Animated") and v110:FindFirstChild("Animated").Value == true then
					local v422 = require(v110.Config);
					local v423 = v20.new(v421.Frame.Arrow, true, 1, false);
					v423.Animations = {};
					v423.CurrAnimation = nil;
					v423.AnimData.Looped = false;
					if type(v422.note) == "string" then
						v423:AddSparrowXML(v110.XML, "Arrow", v422.note, 24, true).ImageId = l__Value__28;
					else
						v423:AddSparrowXML(v110.XML, "Arrow", v422.note[v421.Name], 24, true).ImageId = l__Value__28;
					end;
					v423:PlayAnimation("Arrow");
					local v424 = v20.new(v421.Frame.Arrow, true, 1, false);
					v424.Animations = {};
					v424.CurrAnimation = nil;
					v424.AnimData.Looped = false;
					if type(v422.hold) == "string" then
						v424:AddSparrowXML(v110.XML, "Hold", v422.hold, 24, true).ImageId = l__Value__28;
					else
						v424:AddSparrowXML(v110.XML, "Hold", v422.hold[v421.Name], 24, true).ImageId = l__Value__28;
					end;
					v424:PlayAnimation("Hold");
					local v425 = v20.new(v421.Frame.Arrow, true, 1, false);
					v425.Animations = {};
					v425.CurrAnimation = nil;
					v425.AnimData.Looped = false;
					if type(v422.holdend) == "string" then
						v425:AddSparrowXML(v110.XML, "HoldEnd", v422.holdend, 24, true).ImageId = l__Value__28;
					else
						v425:AddSparrowXML(v110.XML, "HoldEnd", v422.holdend[v421.Name], 24, true).ImageId = l__Value__28;
					end;
					v425:PlayAnimation("HoldEnd");
				else
					require(v110.XML).OpponentNoteInserted(v421);
				end;
			end;
		elseif v60:FindFirstChild("XML") then
			if v60:FindFirstChild("Animated") and v60:FindFirstChild("Animated").Value == true then
				local v426 = require(v60.Config);
				local v427 = v20.new(v421.Frame.Arrow, true, 1, false);
				v427.Animations = {};
				v427.CurrAnimation = nil;
				v427.AnimData.Looped = false;
				if type(v426.note) == "string" then
					v427:AddSparrowXML(v60.XML, "Arrow", v426.note, 24, true).ImageId = v60.Notes.Value;
				else
					v427:AddSparrowXML(v60.XML, "Arrow", v426.note[v421.Name], 24, true).ImageId = v60.Notes.Value;
				end;
				v427:PlayAnimation("Arrow");
				local v428 = v20.new(v421.Frame.Arrow, true, 1, false);
				v428.Animations = {};
				v428.CurrAnimation = nil;
				v428.AnimData.Looped = false;
				if type(v426.hold) == "string" then
					v428:AddSparrowXML(v60.XML, "Hold", v426.hold, 24, true).ImageId = v60.Notes.Value;
				else
					v428:AddSparrowXML(v60.XML, "Hold", v426.hold[v421.Name], 24, true).ImageId = v60.Notes.Value;
				end;
				v428:PlayAnimation("Hold");
				local v429 = v20.new(v421.Frame.Arrow, true, 1, false);
				v429.Animations = {};
				v429.CurrAnimation = nil;
				v429.AnimData.Looped = false;
				if type(v426.holdend) == "string" then
					v429:AddSparrowXML(v60.XML, "HoldEnd", v426.holdend, 24, true).ImageId = v60.Notes.Value;
				else
					v429:AddSparrowXML(v60.XML, "HoldEnd", v426.holdend[v421.Name], 24, true).ImageId = v60.Notes.Value;
				end;
				v429:PlayAnimation("HoldEnd");
			else
				require(v60.XML).OpponentNoteInserted(v421);
			end;
		end;
	end;
	v421.Parent = l__Game__7[v420].Arrows.IncomingNotes:FindFirstChild(v421.Name) or l__Game__7[v420].Arrows.IncomingNotes:FindFirstChild(string.split(v421.Name, "_")[1]);
	return true;
end;
local u68 = l__RunService__18.Heartbeat:Connect(function()
	if l__Value__6.Config.CleaningUp.Value or not l__Value__6.Config.Loaded.Value then
		return;
	end;
	local u69 = v14.tomilseconds(l__Config__4.TimePast.Value) + u25;
	local function u70()
		if v395[1] and u67(v395[1][1], v395[1][2], u69) then
			u70();
		end;
	end;
	if v395[1] and u67(v395[1][1], v395[1][2], u69) then
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
	if v228 then
		v228:Disconnect();
	end;
	if v255 then
		v255:Disconnect();
	end;
	if v360 then
		v360:Disconnect();
	end;
	if u68 then
		u68:Disconnect();
	end;
	if u71 then
		u71:Disconnect();
	end;
	if v373 then
		v373:Disconnect();
	end;
	if v367 then
		v367:Disconnect();
	end;
	if v105 then
		v105:Disconnect();
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
	for v430, v431 in pairs(workspace.ClientBG:GetChildren()) do
		v431:Destroy();
	end;
	for v432, v433 in pairs(game.Lighting:GetChildren()) do
		v433:Destroy();
	end;
	for v434, v435 in pairs(game.Lighting:GetAttributes()) do
		game.Lighting[v434] = v435;
	end;
	for v436, v437 in pairs(game.ReplicatedStorage.OGLighting:GetChildren()) do
		v437:Clone().Parent = game.Lighting;
	end;
	task.spawn(function()
		for v438, v439 in pairs((game.ReplicatedStorage.Events.Backgrounds:InvokeServer("Unload"))) do
			local v440 = v439[1];
			local v441 = tonumber(v439[4]);
			if v440 then
				v440[v439[2]] = v441 and v441 or v439[3];
			end;
		end;
	end);
	u32:Stop();
	l__Parent__3.GameMusic.Music:Stop();
	l__Parent__3.GameMusic.Vocals:Stop();
	for v442, v443 in pairs(l__Value__6.MusicPart:GetDescendants()) do
		if v443:IsA("Sound") then
			v443.Volume = 0;
			v443.PlaybackSpeed = 1;
		else
			v443:Destroy();
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
	local v444 = l__Value__6.Config.Player1.Value == l__LocalPlayer__2 and l__Value__6.Config.P1Points.Value or l__Value__6.Config.P2Points.Value;
	if u42 and u42.OnSongEnd then
		local u78 = 0;
		table.foreach(u1, function(p70, p71)
			u78 = u78 + p71;
		end);
		u42.OnSongEnd(l__Parent__3, { u78 / #u1, v444 });
	end;
	if not l__LocalPlayer__2.Input.ShowEndScreen.Value then
		return;
	end;
	if v84.Parent.Parent.Parent.Name == "Songs" and v84:IsA("ModuleScript") then
		local v445 = v84.Parent.Name;
	else
		v445 = v84.Name;
	end;
	local v446 = game.ReplicatedStorage.Misc.EndScene:Clone();
	v446.Parent = l__LocalPlayer__2.PlayerGui.GameUI;
	v446.BGFrame.SongName.Text = "<font color='rgb(90,220,255)'>" .. v445 .. "</font> Cleared!";
	v446.BGFrame.Judgements.Text = "Judgements:\n<font color='rgb(255,255,140)'>Marvelous</font> - " .. u6 .. "\n<font color='rgb(90,220,255)'>Sick</font> - " .. u7 .. "\n<font color='rgb(90,255,90)'>Good</font> - " .. u8 .. "\n<font color='rgb(255,210,0)'>Ok</font> - " .. u9 .. "\n<font color='rgb(165,65,235)'>Bad</font> - " .. u10 .. "\n\nScore - " .. v444 .. "\nAccuracy - " .. u2 .. "%\nMisses - " .. u4 .. "\nBest Combo - " .. u5;
	if l__LocalPlayer__2.Input.ExtraData.Value then
		if u7 == 0 then
			local v447 = 1;
		else
			v447 = u7;
		end;
		if u7 == 0 then
			local v448 = ":inf";
		else
			v448 = ":1";
		end;
		if u8 == 0 then
			local v449 = 1;
		else
			v449 = u8;
		end;
		if u8 == 0 then
			local v450 = ":inf";
		else
			v450 = ":1";
		end;
		v446.BGFrame.Judgements.Text = v446.BGFrame.Judgements.Text .. "\n\nMA - " .. math.floor(u6 / v447 * 100 + 0.5) / 100 .. v448 .. "\nPA - " .. math.floor(u7 / v449 * 100 + 0.5) / 100 .. v450;
		v446.BGFrame.Judgements.Text = v446.BGFrame.Judgements.Text .. "\nMean - " .. u11.CalculateMean(u12) .. "ms";
	end;
	v446.BGFrame.InputType.Text = "Input System Used: " .. l__LocalPlayer__2.Input.InputType.Value;
	v446.Background.BackgroundTransparency = 1;
	local v451 = l__Parent__3.GameMusic.Vocals.TimePosition - 7 < l__Parent__3.GameMusic.Vocals.TimeLength;
	if u4 == 0 and v451 and not p69 and l__Parent__3.GameMusic.Vocals.TimeLength > 0 and u6 + u7 + u8 + u9 + u10 + u4 >= 20 then
		v446.BGFrame.Extra.Visible = true;
		if tonumber(u2) == 100 then
			local v452 = "<font color='rgb(255, 225, 80)'>PFC</font>";
		else
			v452 = "<font color='rgb(90,220,255)'>FC</font>";
		end;
		v446.BGFrame.Extra.Text = v452;
		if u7 + u8 + u9 + u10 + u4 == 0 then
			v446.BGFrame.Extra.Text = "<font color='rgb(64, 211, 255)'>MFC</font>";
		end;
	end;
	if p69 then
		v446.Ranking.Image = u75.F[2];
		v446.BGFrame.SongName.Text = "<font color='rgb(255,0,0)'>" .. v445 .. " FAILED!</font>";
	elseif not v451 or not (l__Parent__3.GameMusic.Vocals.TimeLength > 0) then
		v446.Ranking.Image = "rbxassetid://8906780323";
		v446.BGFrame.SongName.Text = "<font color='rgb(255,140,0)'>" .. v445 .. " Incomplete.</font>";
	else
		local v453 = 0;
		for v454, v455 in pairs(u75) do
			local v456 = v455[1];
			if v456 <= tonumber(u2) and v453 <= v456 then
				v453 = v456;
				v446.Ranking.Image = v455[2];
				if v454 == "F" then
					v446.BGFrame.SongName.Text = "<font color='rgb(255,0,0)'>" .. v445 .. " FAILED!</font>";
				end;
			end;
		end;
	end;
	u11.MakeHitGraph(u12, v446);
	for v457, v458 in pairs(v446.BGFrame:GetChildren()) do
		v458.TextTransparency = 1;
		v458.TextStrokeTransparency = 1;
	end;
	l__TweenService__16:Create(v446.Background, TweenInfo.new(0.35), {
		BackgroundTransparency = 0.3
	}):Play();
	l__TweenService__16:Create(v446.Ranking, TweenInfo.new(0.35), {
		ImageTransparency = 0
	}):Play();
	for v459, v460 in pairs(v446.BGFrame:GetChildren()) do
		l__TweenService__16:Create(v460, TweenInfo.new(0.35), {
			TextTransparency = 0
		}):Play();
		l__TweenService__16:Create(v460, TweenInfo.new(0.35), {
			TextStrokeTransparency = 0
		}):Play();
	end;
	v446.LocalScript.Disabled = false;
end;
u71 = l__LocalPlayer__2.Character.Humanoid.Died:Connect(function()
	u76();
	u77(true);
end);
l__Events__5.Stop.OnClientEvent:Connect(function()
	u76();
	if l__LocalPlayer__2.Character and l__LocalPlayer__2.Character:FindFirstChild("Humanoid") then
		local v461, v462, v463 = ipairs(l__LocalPlayer__2.Character.Humanoid:GetPlayingAnimationTracks());
		while true do
			v461(v462, v463);
			if not v461 then
				break;
			end;
			v463 = v461;
			v462:Stop();		
		end;
		u77();
	end;
	table.clear(u36);
end);
