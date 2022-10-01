-- script full name: game:GetService"Players".LocalPlayer.PlayerGui:WaitForChild"FNFEngine".Client
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
local v9 = require(game.ReplicatedStorage.Modules.Conductor);
local v10 = require(game.ReplicatedStorage.Modules.Util);
local v11 = require(game.ReplicatedStorage.Modules.TimingWindows);
local l__TweenService__12 = game:GetService("TweenService");
local l__UserInputService__13 = game:GetService("UserInputService");
local l__RunService__14 = game:GetService("RunService");
local v15 = require(game.ReplicatedStorage.Modules.DebugLog);
local v16 = require(game.ReplicatedStorage.Modules.Sprites.Sprite);
local v17 = l__Game__7:FindFirstChild(l__Parent__3.PlayerSide.Value);
l__Value__6.P1Board.G.Enabled = false;
l__Value__6.P2Board.G.Enabled = false;
l__Value__6.SongInfo.G.Enabled = false;
l__Value__6.SongInfo.P1Icon.G.Enabled = false;
l__Value__6.SongInfo.P2Icon.G.Enabled = false;
l__Value__6.FlyingText.G.Enabled = false;
l__Config__4.TimePast.Value = -40;
for v18, v19 in pairs(l__CameraPoints__8:GetChildren()) do
	v19.CFrame = v19.OriginalCFrame.Value;
end;
for v20, v21 in pairs({ l__Game__7.R, l__Game__7.L }) do
	game.ReplicatedStorage.Misc.SplashContainer:Clone().Parent = v21;
end;
local v22 = l__LocalPlayer__2.PlayerGui.GameUI:WaitForChild("SongSelect1v1", 10);
local l__EndScene__23 = l__LocalPlayer__2.PlayerGui.GameUI:FindFirstChild("EndScene");
if l__EndScene__23 then
	l__EndScene__23:Destroy();
end;
if not v22 then
	warn("Infinite yield on song select menu. Please report this to a dev!");
	v22 = l__LocalPlayer__2.PlayerGui.GameUI:WaitForChild("SongSelect1v1");
end;
function updateData()
	local v24 = 1 - 1;
	while true do
		if l__Value__6.Config["P" .. v24 .. "Stats"].Value ~= "" then
			local v25 = game.HttpService:JSONDecode(l__Value__6.Config["P" .. v24 .. "Stats"].Value);
			if v24 == 1 then
				local v26 = "L";
			else
				v26 = "R";
			end;
			l__Game__7:FindFirstChild(v26).OpponentStats.Label.Text = "Accuracy: " .. v25.accuracy .. "% | Combo: " .. v25.combo .. " | Misses: " .. v25.misses;
		end;
		if 0 <= 1 then
			if v24 < 2 then

			else
				break;
			end;
		elseif 2 < v24 then

		else
			break;
		end;
		v24 = v24 + 1;	
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
local function v27()
	local v28 = nil;
	local v29 = l__Parent__3.LowerContainer.Stats.Label;
	l__Parent__3.LowerContainer.Bar.Visible = l__LocalPlayer__2.Input.HealthBar.Value;
	local u14 = 0;
	table.foreach(u1, function(p1, p2)
		u14 = u14 + p2;
	end);
	local v30 = 100;
	if u14 == 0 and #u1 == 0 then
		local v31 = "Accuracy: 100%";
	else
		u2 = string.sub(tostring(u14 / #u1), 1, 5);
		v31 = "Accuracy: " .. u2 .. "%";
		v30 = u2;
	end;
	v28 = v31 .. " | Combo: " .. u3 .. " | Misses: " .. u4;
	if l__LocalPlayer__2.Input.VerticalBar.Value then
		v29 = l__Parent__3.SideContainer.Accuracy;
		v29.Text = string.gsub(v28, " | ", "\n");
	else
		v29.Visible = l__LocalPlayer__2.Input.InfoBar.Value;
		v29.Text = v28;
	end;
	if u5 < u3 then
		u5 = u3;
	end;
	l__Parent__3.SideContainer.Data.Text = "Marvelous: " .. u6 .. "\nSick: " .. u7 .. "\nGood: " .. u8 .. "\nOk: " .. u9 .. "\nBad: " .. u10;
	local l__Extra__32 = l__Parent__3.SideContainer.Extra;
	if u7 == 0 then
		local v33 = 1;
	else
		v33 = u7;
	end;
	if u7 == 0 then
		local v34 = ":inf";
	else
		v34 = ":1";
	end;
	if u8 == 0 then
		local v35 = 1;
	else
		v35 = u8;
	end;
	if u8 == 0 then
		local v36 = ":inf";
	else
		v36 = ":1";
	end;
	l__Extra__32.Text = "MA: " .. math.floor(u6 / v33 * 100 + 0.5) / 100 .. v34 .. "\nPA: " .. math.floor(u7 / v35 * 100 + 0.5) / 100 .. v36;
	l__Extra__32.Text = l__Extra__32.Text .. "\nMean: " .. u11.CalculateMean(u12) .. "ms";
	l__Events__5.UpdateData:FireServer({
		accuracy = v30, 
		combo = u3, 
		misses = u4, 
		bot = false
	});
	if u13 ~= nil and u13.overrideStats then
		if u13.overrideStats.Value then
			local v37 = string.gsub(string.gsub(string.gsub(u13.overrideStats.Value, "{misses}", u4), "{combo}", u3), "{accuracy}", v30 .. "%%");
		else
			v37 = v29.Text;
		end;
		if u13.overrideStats.ShadowValue then
			local v38 = string.gsub(string.gsub(string.gsub(u13.overrideStats.ShadowValue, "{misses}", u4), "{combo}", u3), "{accuracy}", v30 .. "%%");
		else
			v38 = v29.Text;
		end;
		if u13.overrideStats.ChildrenToUpdate then
			l__Parent__3.SideContainer.Accuracy.Visible = false;
			local l__Label__39 = l__Parent__3.LowerContainer.Stats.Label;
			local v40, v41, v42 = pairs(u13.overrideStats.ChildrenToUpdate);
			while true do
				local v43 = nil;
				local v44, v45 = v40(v41, v42);
				if not v44 then
					break;
				end;
				v42 = v44;
				v43 = l__Parent__3.LowerContainer.Stats[v45];
				if v45:lower():match("shadow") then
					v43.Text = v38;
				else
					v43.Text = v37;
				end;			
			end;
		elseif l__LocalPlayer__2.Input.VerticalBar.Value then
			v29.Text = string.gsub(v37, " | ", "\n");
		else
			v29.Text = v37;
		end;
	end;
end;
v27();
local l__Value__15 = l__Config__4.PlaybackSpeed.Value;
l__Events__5.Start.OnClientEvent:Connect(function(p3, p4, p5)
	local v46 = 1 / p4;
	local v47 = p5:FindFirstChild("Modchart") and (p5.Modchart:IsA("ModuleScript") and require(p5.Modchart));
	if v47 and v47.PreStart then
		v47.PreStart(l__Parent__3, v46);
	end;
	if p5:FindFirstChild("ExtraCountdownTime") then
		task.wait(p5.ExtraCountdownTime.Value);
	end;
	local l__Music__16 = l__Parent__3.GameMusic.Music;
	local l__Vocals__17 = l__Parent__3.GameMusic.Vocals;
	task.spawn(function()
		if p5:FindFirstChild("NoCountdown") then
			task.wait(v46 * 3);
			l__Value__6.MusicPart["3"].Volume = 0;
			l__Value__6.MusicPart.Go.Volume = 0;
			l__Value__6.MusicPart["3"]:Play();
			l__Value__6.MusicPart.Go:Play();
			task.wait(v46);
			l__Music__16.Playing = true;
			l__Vocals__17.Playing = true;
			return;
		end;
		l__Value__6.MusicPart["3"]:Play();
		task.wait(v46);
		l__Value__6.MusicPart["2"]:Play();
		task.wait(v46);
		l__Value__6.MusicPart["1"]:Play();
		task.wait(v46);
		l__Value__6.MusicPart.Go:Play();
		task.wait(v46);
		l__Music__16.Playing = true;
		l__Vocals__17.Playing = true;
	end);
	for v48, v49 in pairs(l__Value__6.MusicPart:GetChildren()) do
		if v49:IsA("Sound") and v49.Name ~= "SERVERmusic" and v49.Name ~= "SERVERvocals" then
			v49.Volume = 0.5;
		end;
	end;
	l__Config__4.TimePast.Value = -4 / p4;
	l__TweenService__12:Create(l__Config__4.TimePast, TweenInfo.new(p3 + 4 / p4, Enum.EasingStyle.Linear, Enum.EasingDirection.In, 0, false, 0), {
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
local v50 = game.ReplicatedStorage.Skins:FindFirstChild(l__LocalPlayer__2.Input.Skin.Value) or game.ReplicatedStorage.Skins.Default;
local v51 = Instance.new("BlurEffect");
v51.Parent = game.Lighting;
v51.Size = 0;
local v52 = script.ModifierLabel:Clone();
v52.Parent = l__LocalPlayer__2.PlayerGui.GameUI;
local v53 = l__UserInputService__13.InputChanged:Connect(function(p6, p7)
	if p7 then
		return;
	end;
	if p6.UserInputType == Enum.UserInputType.MouseMovement then
		local v54 = l__UserInputService__13:GetMouseLocation();
		v52.Position = UDim2.new(0, v54.X, 0, v54.Y);
		local v55, v56, v57 = pairs((l__LocalPlayer__2.PlayerGui:GetGuiObjectsAtPosition(v54.X, v54.Y)));
		while true do
			local v58, v59 = v55(v56, v57);
			if not v58 then
				break;
			end;
			if v59:IsA("ImageButton") and v59:FindFirstChild("Info") then
				v52.Visible = true;
				v52.Text = "  " .. string.gsub(v59.Info.Value, "|", "\n") .. "  ";
				return;
			end;
			if v59.Name == "NoWins" and v59.Visible then
				v52.Visible = true;
				v52.Text = "  This song won't contribute towards your win & winstreak count!  ";
				return;
			end;
			v52.Visible = false;		
		end;
	end;
end);
for v60, v61 in pairs(v22.Modifiers:GetDescendants()) do
	if v61:IsA("ImageButton") then
		v61.ImageColor3 = Color3.fromRGB(136, 136, 136);
		local u18 = false;
		v61.MouseButton1Click:Connect(function()
			u18 = not u18;
			l__TweenService__12:Create(v61, TweenInfo.new(0.4), {
				ImageColor3 = u18 and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(136, 136, 136)
			}):Play();
			l__Events__5.Modifiers:FireServer(v61.Name);
		end);
	end;
end;
local l__ModifierMultiplier__62 = l__Parent__3:WaitForChild("ModifierMultiplier");
v22.Modifiers.Multiplier.Text = "1x";
v22.Modifiers.Multiplier.TextColor3 = Color3.new(1, 1, 1);
l__ModifierMultiplier__62.Changed:Connect(function()
	if l__ModifierMultiplier__62.Value > 1 then
		local v63 = Color3.fromRGB(255, 255, 0);
	elseif l__ModifierMultiplier__62.Value < 1 then
		v63 = Color3.fromRGB(255, 64, 30);
	else
		v63 = Color3.fromRGB(255, 255, 255);
	end;
	v10.AnimateMultiplier(l__Parent__3, v22.Modifiers.Multiplier, v63);
	v22.Modifiers.Multiplier.Text = l__ModifierMultiplier__62.Value .. "x";
end);
local v64 = l__Parent__3.SelectionMusic:GetChildren();
local v65 = v64[math.random(1, #v64)];
v65.Volume = 0;
v65:Play();
l__TweenService__12:Create(v65, TweenInfo.new(4, Enum.EasingStyle.Quint, Enum.EasingDirection.In), {
	Volume = v65.Volume
}):Play();
l__TweenService__12:Create(workspace.CurrentCamera, TweenInfo.new(1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
	FieldOfView = 35
}):Play();
l__TweenService__12:Create(v51, TweenInfo.new(1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
	Size = 25
}):Play();
v22.Visible = true;
v22.TimeLeft.Text = "Time Left: 15";
local u19 = nil;
u19 = l__Value__6.Config.SelectTimeLeft.Changed:Connect(function()
	if not l__Parent__3.Parent then
		u19:Disconnect();
		return;
	end;
	v22.TimeLeft.Text = "Time Left: " .. l__Value__6.Config.SelectTimeLeft.Value;
end);
l__Value__6.Events.LoadPlayer.OnClientInvoke = function(p8)
	l__Parent__3.Loading.Visible = true;
	l__TweenService__12:Create(workspace.CurrentCamera, TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
		FieldOfView = 68
	}):Play();
	game.ContentProvider:PreloadAsync(p8);
	task.wait(0.5);
	l__Parent__3.Loading.Visible = false;
	return true;
end;
workspace.CurrentCamera.CameraType = Enum.CameraType.Scriptable;
workspace.CurrentCamera.CFrame = l__Value__6.CameraPoints.C.CFrame;
game.StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.Backpack, false);
game.StarterGui:SetCore("ResetButtonCallback", false);
local v66 = game.ReplicatedStorage.Events.PlayerSongVote.Event:Connect(function(p9, p10, p11)
	if not p9 or not p10 or not p11 then
		return;
	end;
	l__Value__6.Events.PlayerSongVote:FireServer(p9, p10, p11);
end);
while true do
	v10.wait();
	if l__Value__6.Config.Song.Value then
		break;
	end;
end;
local v67 = l__TweenService__12:Create(v51, TweenInfo.new(1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
	Size = 0
});
v67:Play();
v67.Completed:Connect(function()
	v51:Destroy();
end);
local v68 = l__TweenService__12:Create(v65, TweenInfo.new(2, Enum.EasingStyle.Quint, Enum.EasingDirection.In), {
	Volume = 0
});
v68:Play();
v68.Completed:Connect(function()
	v65:Stop();
end);
local v69 = l__Value__6.Config.Song.Value:IsA("StringValue") and l__Value__6.Config.Song.Value.Value or require(l__Value__6.Config.Song.Value);
local v70 = l__Value__6.Config.Song.Value:FindFirstAncestorOfClass("StringValue") or l__Value__6.Config.Song.Value;
if v70.Parent.Parent.Parent.Name == "Songs" and not v70:FindFirstChild("Sound") then
	v70 = v70.Parent;
end;
local v71, v72, v73, v74 = v10.SpecialSongCheck(v70);
v53:Disconnect();
v52:Destroy();
v22.Visible = false;
v66:Disconnect();
workspace.CurrentCamera.CameraType = Enum.CameraType.Scriptable;
workspace.CurrentCamera.CFrame = l__Value__6.CameraPoints.C.CFrame;
task.spawn(function()
	l__Value__6.MusicPart.Go.Played:Wait();
	v10.NowPlaying(l__Parent__3, v70, l__LocalPlayer__2);
	task.wait(1);
	game.StarterGui:SetCore("ResetButtonCallback", true);
end);
require(l__Parent__3.Modules.Icons).SetIcons(l__Parent__3, v70);
local u20 = v69;
local v75, v76 = pcall(function()
	u20 = game.HttpService:JSONDecode(u20).song;
end);
if v76 then
	u20 = game.HttpService:JSONDecode(game.ReplicatedStorage.Songs.OMORI["GUILTY!"].Value).song;
end;
u20.bpm = u20.bpm * l__Value__15;
local v77 = 60 / (u20.bpm or 120 * l__Value__15);
local l__Value__78 = v70.Credits.Value;
if v70.Parent.Parent.Parent.Name == "Songs" then
	local v79 = v70:IsA("ModuleScript") and v70.Parent.Name or v70.Name;
else
	v79 = v70.Name;
end;
local l__Name__80 = l__Value__6.Config.Song.Value.Name;
local v81 = math.ceil((l__Value__6.MusicPart.SERVERvocals.TimeLength - l__Value__6.MusicPart.SERVERvocals.TimePosition) / l__Value__6.MusicPart.SERVERvocals.PlaybackSpeed);
l__Parent__3.LowerContainer.Credit.Text = v79 .. " (" .. l__Name__80 .. ")" .. " (" .. l__Value__15 .. "x)" .. "\n" .. l__Value__78 .. "\n" .. string.format("%d:%02d", math.floor(v81 / 60), v81 % 60);
if v70:FindFirstChild("MobileButtons") then
	l__Parent__3.MobileButtons:Destroy();
	v70.MobileButtons:Clone().Parent = l__Parent__3;
end;
local v82 = v10.ModchartCheck(l__Parent__3, v70, u20);
local v83 = v9.Start(l__Parent__3, v70:FindFirstChild("Modchart"), u20.bpm, v82);
local v84 = require(l__Parent__3.Modules.Functions);
v84.keyCheck(v70, v73, v72, v74);
local v85 = nil;
if v70:FindFirstChild("notetypeconvert") then
	v85 = require(v70.notetypeconvert);
end;
v84.stuffCheck(v70);
local v86 = v70:FindFirstChild("notetypeconvert") and v85.notetypeconvert or v84.notetypeconvert;
if v85 and v85.newKeys then
	v85.newKeys(l__Parent__3);
	v71 = true;
end;
local v87 = nil;
if not l__Value__6.Config.SinglePlayerEnabled.Value then
	if l__Value__6.Config.Player1.Value == l__LocalPlayer__2 then
		v87 = l__Value__6.Config.Player2.Value;
	else
		v87 = l__Value__6.Config.Player1.Value;
	end;
end;
if v87 then
	local v88 = game.ReplicatedStorage.Skins:FindFirstChild(v87.Input.Skin.Value) or game.ReplicatedStorage.Skins.Default;
else
	v88 = game.ReplicatedStorage.Skins.Default;
end;
l__Game__7.L.Arrows.IncomingNotes.DescendantAdded:Connect(function(p12)
	if not (l__Game__7.Rotation >= 90) then
		return;
	end;
	if v70:FindFirstChild("NoSettings") then
		return;
	end;
	if p12:IsA("Frame") and p12:FindFirstChild("Frame") then
		p12.Rotation = 180;
		p12.Frame.Rotation = 180;
		p12.Frame.Arrow.Rotation = 180;
	end;
end);
l__Game__7.R.Arrows.IncomingNotes.DescendantAdded:Connect(function(p13)
	if not (l__Game__7.Rotation >= 90) then
		return;
	end;
	if v70:FindFirstChild("NoSettings") then
		return;
	end;
	if p13:IsA("Frame") and p13:FindFirstChild("Frame") then
		p13.Rotation = 180;
		p13.Frame.Rotation = 180;
		p13.Frame.Arrow.Rotation = 180;
	end;
end);
function ChangeUI(p14)
	if p14 ~= nil then
		print("UI Style change to " .. p14);
		local v89 = game.ReplicatedStorage.UIStyles[p14];
		u13 = require(v89.Config);
		l__Parent__3.LowerContainer.Bar:Destroy();
		local v90 = v89.Bar:Clone();
		v90.Parent = l__Parent__3.LowerContainer;
		if u13.HealthBarColors then
			v90.Background.BackgroundColor3 = u13.HealthBarColors.Green or Color3.fromRGB(114, 255, 63);
			v90.Background.Fill.BackgroundColor3 = u13.HealthBarColors.Red or Color3.fromRGB(255, 0, 0);
		end;
		if u13.ShowIcons then
			v90.Player1.Sprite.Visible = u13.ShowIcons.Dad;
			v90.Player2.Sprite.Visible = u13.ShowIcons.BF;
		end;
		if v89:FindFirstChild("Stats") then
			l__Parent__3.LowerContainer.Stats:Destroy();
			v89.Stats:Clone().Parent = l__Parent__3.LowerContainer;
		end;
		if u13.isPixel then
			l__Parent__3.LowerContainer.PointsA.Font = Enum.Font.Arcade;
			l__Parent__3.LowerContainer.PointsB.Font = Enum.Font.Arcade;
		end;
		if u13.overrideStats then
			if u13.overrideStats.Timer then
				l__Parent__3.LowerContainer.Credit.Text = v79 .. " (" .. l__Name__80 .. ")" .. " (" .. l__Value__15 .. "x)" .. "\n" .. l__Value__78 .. "\n" .. u13.overrideStats.Timer;
			end;
		end;
	else
		print("UI Style change to Default");
		local l__Default__91 = game.ReplicatedStorage.UIStyles.Default;
		u13 = require(l__Default__91.Config);
		l__Parent__3.LowerContainer.Bar:Destroy();
		l__Parent__3.LowerContainer.Stats:Destroy();
		l__Default__91.Bar:Clone().Parent = l__Parent__3.LowerContainer;
		l__Default__91.Stats:Clone().Parent = l__Parent__3.LowerContainer;
		l__Parent__3.LowerContainer.PointsA.Font = Enum.Font.GothamBold;
		l__Parent__3.LowerContainer.PointsB.Font = Enum.Font.GothamBold;
	end;
	v27();
	require(l__Parent__3.Modules.Icons).SetIcons(l__Parent__3, v70);
	updateUI();
end;
local u21 = {};
function updateUI(p15)
	if v17.Name == "L" then
		local v92 = "R";
	else
		v92 = "L";
	end;
	local v93 = l__Game__7:FindFirstChild(v92);
	if l__LocalPlayer__2.Input.VerticalBar.Value then
		l__Parent__3.LowerContainer.Stats.Visible = false;
		l__Parent__3.SideContainer.Accuracy.Visible = true;
	end;
	l__Parent__3.Stats.Visible = l__LocalPlayer__2.Input.ShowDebug.Value;
	l__Parent__3.SideContainer.Data.Visible = l__LocalPlayer__2.Input.JudgementCounter.Value;
	l__Parent__3.SideContainer.Extra.Visible = l__LocalPlayer__2.Input.ExtraData.Value;
	if l__LocalPlayer__2.Input.ShowOpponentStats.Value then
		if l__LocalPlayer__2.Input.Middlescroll.Value then
			v93.OpponentStats.Visible = l__LocalPlayer__2.Input.ShowOtherMS.Value;
		else
			v93.OpponentStats.Visible = l__LocalPlayer__2.Input.ShowOpponentStats.Value;
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
	if not v70:FindFirstChild("NoSettings") then
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
			local l__Size__94 = l__Parent__3.LowerContainer.Bar.Size;
			l__Parent__3.LowerContainer.Bar.Position = UDim2.new(1.1, 0, -4, 0);
			l__Parent__3.LowerContainer.Bar.Size = UDim2.new(l__Size__94.X.Scale * 0.8, l__Size__94.X.Offset, l__Size__94.Y.Scale, l__Size__94.Y.Offset);
			l__Parent__3.LowerContainer.Bar.Rotation = 90;
			l__Parent__3.LowerContainer.Bar.Player1.Sprite.Rotation = -90;
			l__Parent__3.LowerContainer.Bar.Player2.Sprite.Rotation = -90;
		end;
		if l__LocalPlayer__2.Input.Downscroll.Value then
			local v95 = UDim2.new(0.5, 0, 8.9, 0);
			if u13 ~= nil then
				if u13.overrideStats then
					if u13.overrideStats.Position then
						if u13.overrideStats.Position.Downscroll then
							v95 = u13.overrideStats.Position.Downscroll;
						end;
					end;
				end;
			end;
			l__Game__7.Rotation = 180;
			l__Game__7.Position = UDim2.new(0.5, 0, 0.05, 0);
			l__Parent__3.LowerContainer.AnchorPoint = Vector2.new(0.5, 0);
			l__Parent__3.LowerContainer.Position = UDim2.new(0.5, 0, 0.1, 0);
			l__Parent__3.LowerContainer.Stats.Position = v95;
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
				local l__Size__96 = l__Parent__3.LowerContainer.Bar.Size;
				l__Parent__3.LowerContainer.Bar.Position = UDim2.new(1.1, 0, 4, 0);
				l__Parent__3.LowerContainer.Bar.Rotation = 90;
				l__Parent__3.LowerContainer.Bar.Player1.Sprite.Rotation = -90;
				l__Parent__3.LowerContainer.Bar.Player2.Sprite.Rotation = -90;
			end;
			if not v71 then
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
		elseif p15 == "Downscroll" then
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
				local l__Size__97 = l__Parent__3.LowerContainer.Bar.Size;
				l__Parent__3.LowerContainer.Bar.Position = UDim2.new(1.1, 0, -4, 0);
				l__Parent__3.LowerContainer.Bar.Rotation = 90;
				l__Parent__3.LowerContainer.Bar.Player1.Sprite.Rotation = -90;
				l__Parent__3.LowerContainer.Bar.Player2.Sprite.Rotation = -90;
			end;
			l__Game__7.L.Arrows.Rotation = 0;
			l__Game__7.R.Arrows.Rotation = 0;
			if not v71 then
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
			v93.Visible = l__LocalPlayer__2.Input.ShowOtherMS.Value;
			v17.Position = UDim2.new(0.5, 0, 0.5, 0);
			v17.AnchorPoint = Vector2.new(0.5, 0.5);
			if l__LocalPlayer__2.Input.ShowOtherMS.Value then
				v93.OpponentStats.Size = UDim2.new(2, 0, 0.05, 0);
				v93.OpponentStats.Position = UDim2.new(0.5, 0, -0.08, 0);
				v93.AnchorPoint = Vector2.new(0.1, 0);
				v93.Size = UDim2.new(0.15, 0, 0.3, 0);
				v93.Position = v93.Name == "R" and UDim2.new(0.88, 0, 0.5, 0) or UDim2.new(0, 0, 0.5, 0);
				if l__LocalPlayer__2.Input.Downscroll.Value then
					v93.Position = v93.Name == "L" and UDim2.new(0.88, 0, 0.5, 0) or UDim2.new(0, 0, 0.5, 0);
				end;
			end;
		elseif p15 == "Middlescroll" then
			v93.Visible = true;
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
	u21.Stats = l__Parent__3.LowerContainer.Stats.Size;
	local v98, v99, v100 = pairs(l__Parent__3.SideContainer:GetChildren());
	while true do
		local v101, v102 = v98(v99, v100);
		if v101 then

		else
			break;
		end;
		v100 = v101;
		if v102.ClassName == "TextLabel" then
			u21[v102.Name] = v102.Size;
		end;	
	end;
end;
l__Events__5.ChangeUI.Event:Connect(function(p16)
	ChangeUI(p16);
end);
local u22 = v70.Offset.Value + (l__LocalPlayer__2.Input.Offset.Value and 0);
local l__Value__23 = v50.Notes.Value;
local u24 = {
	L = {}, 
	R = {}
};
local l__Value__25 = v88.Notes.Value;
local v103 = require(game.ReplicatedStorage.Modules.Device);
local v104 = {
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
if not v73 then
	v104 = {
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
if v70:FindFirstChild(l__Parent__3.PlayerSide.Value .. "_Anims") then
	local v105 = v70[l__Parent__3.PlayerSide.Value .. "_Anims"].Value;
else
	v105 = game.ReplicatedStorage.Animations:FindFirstChild(l__LocalPlayer__2.Input.Animation.Value) or (v10.findAnim(l__LocalPlayer__2.Input.Animation.Value) or game.ReplicatedStorage.Animations.Default);
end;
local u26 = {};
local u27 = nil;
local l__Animations__28 = _G.Animations;
local u29 = nil;
v1 = function(p17, p18, p19)
	if l__Parent__3.PlayerSide.Value == "R" then
		p17 = p17.Mirrored;
	end;
	if p19 then
		local v106, v107, v108 = ipairs(p17:GetChildren());
		while true do
			v106(v107, v108);
			if not v106 then
				break;
			end;
			v108 = v106;
			if v107:IsA("Animation") then
				u26[v107.Name] = p18:LoadAnimation(v107);
			end;		
		end;
		u27 = u26.Idle;
		return;
	end;
	if not p18 then
		p18 = l__LocalPlayer__2.Character.Humanoid;
	end;
	local v109, v110, v111 = ipairs(p17:GetChildren());
	while true do
		v109(v110, v111);
		if not v109 then
			break;
		end;
		v111 = v109;
		if v110:IsA("Animation") then
			l__Animations__28[v110.Name] = p18:LoadAnimation(v110);
		end;	
	end;
	u29 = l__Animations__28.Idle;
end;
if v105:FindFirstChild("Custom") then
	v1(v105, l__LocalPlayer__2.Character:WaitForChild("customrig"):WaitForChild("rig"):WaitForChild("Humanoid"));
elseif v105:FindFirstChild("FBX") then
	v1(v105, l__LocalPlayer__2.Character:WaitForChild("customrig"):WaitForChild("rig"):WaitForChild("AnimationController"):WaitForChild("Animator"));
elseif v105:FindFirstChild("2Player") then
	v1(v105.Other, l__LocalPlayer__2.Character:WaitForChild("char2"):WaitForChild("Dummy"):WaitForChild("Humanoid"), true);
	v1(v105, l__LocalPlayer__2.Character.Humanoid);
elseif v105:FindFirstChild("Custom2Player") then
	v1(v105.Other, l__LocalPlayer__2.Character:WaitForChild("char2"):WaitForChild("Dummy"):WaitForChild("Humanoid"), true);
	v1(v105, l__LocalPlayer__2.Character:WaitForChild("customrig"):WaitForChild("rig"):WaitForChild("Humanoid"));
else
	v1(v105);
end;
if not tonumber(u20.speed) then
	u20.speed = 2.8;
end;
if u27 then
	u27:AdjustSpeed(u20.speed);
	u29:AdjustSpeed(u20.speed);
	u27.Looped = true;
	u29.Looped = true;
	u27.Priority = Enum.AnimationPriority.Idle;
	u29.Priority = Enum.AnimationPriority.Idle;
	u29:Play();
	u27:Play();
else
	u29:AdjustSpeed(u20.speed);
	u29.Looped = true;
	u29.Priority = Enum.AnimationPriority.Idle;
	u29:Play();
end;
local u30 = nil;
local u31 = nil;
local u32 = 0;
local u33 = {
	Left = false, 
	Down = false, 
	Up = false, 
	Right = false
};
local l__speed__112 = u20.speed;
u20.speed = l__LocalPlayer__2.Input.ScrollSpeedChange.Value and l__LocalPlayer__2.Input.ScrollSpeed.Value + 1.5 or (u20.speed or 3.3);
local v113 = 0.75 * u20.speed;
l__Config__4.MaxDist.Value = v113;
local v114 = Instance.new("Sound");
v114.Name = "HitSound";
v114.Parent = l__Parent__3;
v114.SoundId = "rbxassetid://" .. l__LocalPlayer__2.Input.HitSoundsValue.Value or "rbxassetid://3581383408";
v114.Volume = l__LocalPlayer__2.Input.HitSoundVolume.Value;
local u34 = {
	Left = false, 
	Down = false, 
	Up = false, 
	Right = false
};
local function u35(p20)
	local v115 = nil;
	local v116, v117, v118 = ipairs(v17.Arrows.IncomingNotes[p20]:GetChildren());
	while true do
		v116(v117, v118);
		if not v116 then
			break;
		end;
		v118 = v116;
		if (v117.Name == p20 or string.split(v117.Name, "_")[1] == p20) and (math.abs(string.split(v117:GetAttribute("NoteData"), "~")[1] - (v10.tomilseconds(l__Config__4.TimePast.Value) + u22)) <= v11.Ghost and v117.Frame.Arrow.Visible) then
			if not v115 then
				v115 = v117;
			elseif (v117.AbsolutePosition - v117.Parent.AbsolutePosition).magnitude <= (v115.AbsolutePosition - v117.Parent.AbsolutePosition).magnitude then
				v115 = v117;
			end;
		end;	
	end;
	if v115 then
		return;
	end;
	return true;
end;
local function u36(p21)
	local v119 = p21;
	if v71 then
		if v73 then
			if v119 == "A" or v119 == "H" then
				v119 = "Left";
			end;
			if v119 == "S" or v119 == "J" then
				v119 = "Down";
			end;
			if v119 == "D" or v119 == "K" then
				v119 = "Up";
			end;
			if v119 == "F" or v119 == "L" then
				v119 = "Right";
			end;
		elseif v72 or v74 then
			if v119 == "S" or v119 == "J" then
				v119 = "Left";
			end;
			if v119 == "D" then
				v119 = "Up";
			end;
			if v119 == "K" or v119 == "Space" then
				v119 = "Down";
			end;
			if v119 == "F" or v119 == "L" then
				v119 = "Right";
			end;
		elseif v85 and v85.getAnimationDirection then
			v119 = v85.getAnimationDirection(v119);
		end;
	end;
	if v105:FindFirstChild(v119) then
		if v17.Name == "L" then
			local v120 = v119;
			if not v120 then
				if v119 == "Right" then
					v120 = "Left";
				elseif v119 == "Left" then
					v120 = "Right";
				else
					v120 = v119;
				end;
			end;
		elseif v119 == "Right" then
			v120 = "Left";
		elseif v119 == "Left" then
			v120 = "Right";
		else
			v120 = v119;
		end;
		local v121 = v105[v120];
		local v122 = _G.Animations[v120];
		v122.Looped = false;
		v122.TimePosition = 0;
		v122.Priority = Enum.AnimationPriority.Movement;
		if u30 and u30 ~= v122 then
			u30:Stop(0);
		end;
		u30 = v122;
		local v123 = u26[v120];
		if v123 then
			local v124 = v105.Other[v120];
			v123.Looped = false;
			v123.TimePosition = 0;
			v123.Priority = Enum.AnimationPriority.Movement;
			if u31 and u31 ~= v123 then
				u31:Stop(0);
			end;
			u31 = v123;
		end;
		task.spawn(function()
			u32 = u32 + 1;
			while u33[p21] and u32 == u32 do
				v122:Play(0);
				if v123 then
					v123:Play(0);
				end;
				task.wait(0.1);			
			end;
			task.wait(v122.Length - 0.15);
			if u32 == u32 then
				v122:Stop(0);
				if l__Parent__3.Side.Value == l__Parent__3.PlayerSide.Value and l__LocalPlayer__2.Input.MoveOnHit.Value then
					local l__Value__125 = l__Parent__3.Side.Value;
					local v126 = workspace.ClientBG:FindFirstChildOfClass("Model");
					local v127 = v70:FindFirstChild("Modchart") and (v70.Modchart:IsA("ModuleScript") and (v82 and require(v70.Modchart)));
					if v127 and v127.OverrideCamera then
						return;
					end;
					l__TweenService__12:Create(workspace.CurrentCamera, TweenInfo.new(l__LocalPlayer__2.Input.MoveSpeed.value, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {
						CFrame = (v126 and v126:FindFirstChild("cameraPoints") and v126.cameraPoints:FindFirstChild(l__Value__125) or (l__Value__6.CameraPoints:FindFirstChild(l__Value__125) or l__Value__6.CameraPoints.C)).CFrame
					}):Play();
				end;
				if v123 then
					v123:Stop(0);
				end;
			end;
		end);
	end;
end;
local function u37(p22)
	if v71 and not v85 then
		return;
	end;
	if not l__LocalPlayer__2.Input.NoteSplashes.Value then
		return;
	end;
	if not game.ReplicatedStorage.Misc.Splashes:FindFirstChild(p22) then
		return;
	end;
	task.spawn(function()
		local v128 = game.ReplicatedStorage.Misc.Splashes[p22]:GetChildren();
		local v129 = v128[math.random(1, #v128)]:Clone();
		v129.Parent = v17.SplashContainer;
		v129.Position = v17.Arrows[p22].Position;
		v129.Image = (game.ReplicatedStorage.Splashes:FindFirstChild(l__LocalPlayer__2.Input.NoteSplashSkin.Value) or game.ReplicatedStorage.Splashes.Default).Splash.Value;
		v129.Size = UDim2.fromScale(l__LocalPlayer__2.Input.SplashSize.Value * v129.Size.X.Scale, l__LocalPlayer__2.Input.SplashSize.Value * v129.Size.Y.Scale);
		local l__X__130 = v129.ImageRectOffset.X;
		for v131 = 0, 8 do
			v129.ImageRectOffset = Vector2.new(l__X__130, v131 * 128);
			task.wait(0.035);
		end;
		v129:Destroy();
	end);
end;
local function u38(p23, p24)
	if not l__LocalPlayer__2.Input.MoveOnHit.Value then
		return;
	end;
	local l__Value__132 = l__Parent__3.Side.Value;
	local v133 = workspace.ClientBG:FindFirstChildOfClass("Model");
	local v134 = v70:FindFirstChild("Modchart") and (v70.Modchart:IsA("ModuleScript") and (v82 and require(v70.Modchart)));
	if v134 and v134.OverrideCamera then
		return;
	end;
	local v135 = v133 and v133:FindFirstChild("cameraPoints") and v133.cameraPoints:FindFirstChild(l__Value__132) or (l__Value__6.CameraPoints:FindFirstChild(l__Value__132) or l__Value__6.CameraPoints.C);
	if l__Parent__3.PlayerSide.Value == l__Parent__3.Side.Value and not p24 or l__Parent__3.PlayerSide.Value ~= l__Parent__3.Side.Value and p24 then
		if p23 == "Up" then
			l__TweenService__12:Create(workspace.CurrentCamera, TweenInfo.new(l__LocalPlayer__2.Input.MoveSpeed.value, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {
				CFrame = v135.CFrame * CFrame.new(0, l__LocalPlayer__2.Input.MoveIntensity.value, 0)
			}):Play();
		end;
		if p23 == "Left" then
			l__TweenService__12:Create(workspace.CurrentCamera, TweenInfo.new(l__LocalPlayer__2.Input.MoveSpeed.value, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {
				CFrame = v135.CFrame * CFrame.new(-l__LocalPlayer__2.Input.MoveIntensity.value, 0, 0)
			}):Play();
		end;
		if p23 == "Down" then
			l__TweenService__12:Create(workspace.CurrentCamera, TweenInfo.new(l__LocalPlayer__2.Input.MoveSpeed.value, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {
				CFrame = v135.CFrame * CFrame.new(0, -l__LocalPlayer__2.Input.MoveIntensity.value, 0)
			}):Play();
		end;
		if p23 == "Right" then
			l__TweenService__12:Create(workspace.CurrentCamera, TweenInfo.new(l__LocalPlayer__2.Input.MoveSpeed.value, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {
				CFrame = v135.CFrame * CFrame.new(l__LocalPlayer__2.Input.MoveIntensity.value, 0, 0)
			}):Play();
		end;
	end;
end;
local u39 = v70:FindFirstChild("Modchart") and (v70.Modchart:IsA("ModuleScript") and (v82 and require(v70.Modchart)));
local l__UserInput__40 = l__Events__5.UserInput;
local function u41(p25, p26)
	if not l__LocalPlayer__2.Input.ShowRatings.Value then
		return;
	end;
	local v136 = p26 and v17 or (l__Parent__3.PlayerSide.Value == "L" and l__Game__7.R or l__Game__7.L);
	if not p26 then
		p26 = p25;
		if p26 <= v11.Marvelous and l__LocalPlayer__2.Input.ShowMarvelous.Value then
			p25 = "Marvelous";
		elseif p26 <= v11.Sick then
			p25 = "Sick";
		elseif p26 <= v11.Good then
			p25 = "Good";
		elseif p26 <= v11.Ok then
			p25 = "Ok";
		elseif p26 <= v11.Bad then
			p25 = "Bad";
		end;
	end;
	local v137 = v136:FindFirstChildOfClass("ImageLabel");
	if v137 then
		v137.Parent = nil;
	end;
	local v138 = v136:FindFirstChildOfClass("TextLabel");
	if v138 then
		v138.Parent = nil;
	end;
	local l__Value__139 = l__LocalPlayer__2.Input.RatingSize.Value;
	local v140 = game.ReplicatedStorage.Misc.IndicatorTemplate:Clone();
	v140.Image = "rbxthumb://type=Asset&id=" .. l__LocalPlayer__2.Input[p25 .. "IndicatorImg"].Value .. "&w=150&h=150" or l__Value__6.FlyingText.G["Template_" .. p25].Image;
	v140.Parent = v136;
	v140.Size = UDim2.new(0.25 * l__Value__139, 0, 0.083 * l__Value__139, 0);
	v140.ImageTransparency = 0;
	if l__Game__7.Rotation >= 90 then
		local v141 = 180;
	else
		v141 = 0;
	end;
	v140.Rotation = v141;
	game:GetService("Debris"):AddItem(v140, 1.5);
	if l__LocalPlayer__2.Input.CenterRatings.Value then
		v140.Position = UDim2.new(0.5, 0, 0.45, 0);
	end;
	task.spawn(function()
		if l__LocalPlayer__2.Input.RatingBounce.Value then
			l__TweenService__12:Create(v140, TweenInfo.new(0.05, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
				Size = UDim2.new(0.3 * l__Value__139, 0, 0.1 * l__Value__139, 0)
			}):Play();
		end;
		task.wait(0.1);
		l__TweenService__12:Create(v140, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
			Size = UDim2.new(0.25 * l__Value__139, 0, 0.083 * l__Value__139, 0)
		}):Play();
		task.wait(0.5);
		l__TweenService__12:Create(v140, TweenInfo.new(0.75, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
			ImageTransparency = 1
		}):Play();
	end);
	local v142 = game.ReplicatedStorage.Misc.miliseconds:Clone();
	v142.Visible = l__LocalPlayer__2.Input.ShowMS.Value;
	v142.Parent = v136;
	v142.Size = UDim2.new(0.145 * l__Value__139, 0, 0.044 * l__Value__139, 0);
	if l__Game__7.Rotation >= 90 then
		local v143 = 180;
	else
		v143 = 0;
	end;
	v142.Rotation = v143;
	v142.Text = math.floor(p26 * 100 + 0.5) / 100 .. " ms";
	if p26 < 0 then
		v142.TextColor3 = Color3.fromRGB(255, 61, 61);
	else
		v142.TextColor3 = Color3.fromRGB(120, 255, 124);
	end;
	game:GetService("Debris"):AddItem(v142, 1.5);
	if l__LocalPlayer__2.Input.CenterRatings.Value then
		v142.Position = UDim2.new(0.5, 0, 0.36, 0);
	end;
	task.spawn(function()
		if l__LocalPlayer__2.Input.RatingBounce.Value then
			l__TweenService__12:Create(v142, TweenInfo.new(0.05, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
				Size = UDim2.new(0.165 * l__Value__139, 0, 0.06 * l__Value__139, 0)
			}):Play();
		end;
		task.wait(0.1);
		l__TweenService__12:Create(v142, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
			Size = UDim2.new(0.145 * l__Value__139, 0, 0.044 * l__Value__139, 0)
		}):Play();
		task.wait(0.5);
		l__TweenService__12:Create(v142, TweenInfo.new(0.75, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
			TextTransparency = 1
		}):Play();
		l__TweenService__12:Create(v142, TweenInfo.new(0.75, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
			TextStrokeTransparency = 1
		}):Play();
	end);
end;
local function v144(p27, p28, p29, p30, p31)
	if not p28 then
		return;
	end;
	if p30 then
		u34[p28] = p27.UserInputState == Enum.UserInputState.Begin;
		if l__Parent__3.PlayerSide.Value == "L" then
			local v145 = "R";
		else
			v145 = "L";
		end;
		p30 = l__Game__7:FindFirstChild(v145);
	end;
	if not p30 then
		u33[p28] = p27.UserInputState == Enum.UserInputState.Begin;
	end;
	if l__Config__4.CantHitNotes.Value then
		return;
	end;
	local l__Value__146 = l__LocalPlayer__2.Input.InputType.Value;
	local v147 = nil;
	if not v17.Arrows.IncomingNotes:FindFirstChild(p28) then
		return;
	end;
	local v148, v149, v150 = ipairs((p30 or v17).Arrows.IncomingNotes[p28]:GetChildren());
	while true do
		v148(v149, v150);
		if not v148 then
			break;
		end;
		v150 = v148;
		if v149.Name == p28 or string.split(v149.Name, "_")[1] == p28 then
			local v151 = v149:GetAttribute("NoteData");
			local v152 = string.split(v151, "~")[1] - (v10.tomilseconds(l__Config__4.TimePast.Value) + u22);
			if not p30 then
				if v149.Frame.Arrow.Visible and math.abs(v152) <= v11.Bad then
					if not v147 then
						v147 = v149;
					elseif l__Value__146 == "Bloxxin" then
						if (v149.AbsolutePosition - v149.Parent.AbsolutePosition).magnitude <= (v147.AbsolutePosition - v149.Parent.AbsolutePosition).magnitude then
							v147 = v149;
						end;
					elseif v152 < string.split(v151, "~")[1] - (v10.tomilseconds(l__Config__4.TimePast.Value) + u22) then
						v147 = v149;
					end;
				end;
			elseif v151 == p29 then
				v147 = v149;
				break;
			end;
		end;	
	end;
	if l__Config__4.GhostTappingEnabled.Value and not v147 and not p30 and u35(p28) then
		v147 = "ghost";
	end;
	if not u33[p28] and p27.UserInputState ~= Enum.UserInputState.Begin then
		return;
	end;
	if p30 then
		if v147 then
			u38(p28, true);
			v147.Frame.Arrow.Visible = false;
			p30.Glow[p28].Arrow.ImageTransparency = 1;
			if p27.UserInputState ~= Enum.UserInputState.Begin then
				return;
			else
				local v153 = nil;
				local v154 = nil;
				local v155 = nil;
				local v156 = nil;
				local v157 = nil;
				p30.Glow[p28].Arrow.Visible = true;
				if p30.Glow[p28].Arrow.ImageTransparency == 1 then
					if not l__LocalPlayer__2.Input.DisableArrowGlow.Value then
						local v158 = nil;
						local v159 = nil;
						local v160 = nil;
						local v161 = nil;
						local v162 = nil;
						local v163 = nil;
						local v164 = nil;
						local v165 = nil;
						local v166 = nil;
						local v167 = nil;
						local v168 = nil;
						local v169 = nil;
						local v170 = nil;
						local v171 = nil;
						local v172 = nil;
						local v173 = nil;
						local v174 = nil;
						local v175 = nil;
						if not u24[p30.Name][p28] then
							local u42 = false;
							local u43 = nil;
							u43 = l__RunService__14.RenderStepped:Connect(function()
								if u42 then
									u43:Disconnect();
									p30.Glow[p28].Arrow.ImageTransparency = 1;
									return;
								end;
								p30.Glow[p28].Arrow.ImageTransparency = 0.2 - math.cos(tick() * 10 * math.pi) / 6;
							end);
							v158 = "Frame";
							v159 = v147;
							v160 = v158;
							v161 = v159[v160];
							local v176 = "Bar";
							v162 = v161;
							v163 = v176;
							v164 = v162[v163];
							local v177 = "Size";
							v165 = v164;
							v166 = v177;
							v167 = v165[v166];
							local v178 = "Y";
							v168 = v167;
							v169 = v178;
							v170 = v168[v169];
							local v179 = "Scale";
							v172 = v170;
							v173 = v179;
							v171 = v172[v173];
							local v180 = 0;
							v174 = v180;
							v175 = v171;
							if v174 < v175 then
								local v181 = tick();
								while true do
									v10.wait();
									local l__Scale__182 = v147.Position.Y.Scale;
									if l__Scale__182 < 0 then
										v147.Frame.Bar.Size = UDim2.new(l__LocalPlayer__2.Input.BarSize.Value, 0, math.clamp(v171 + l__Scale__182, 0, 20), 0);
										v147.Frame.Bar.Position = UDim2.new(0.5, 0, 0.5 - l__Scale__182, 0);
									end;
									if not u34[p28] then
										break;
									end;
									if v147.Frame.Bar.Size.Y.Scale == 0 then
										break;
									end;
									if tick() - v181 > 7.5 then
										break;
									end;								
								end;
							else
								v10.wait(0.175);
							end;
							local v183 = true;
							v154 = u41;
							v153 = p31;
							v155 = v153;
							v156 = v154;
							v157 = v155;
							v156(v157);
							return;
						elseif not l__LocalPlayer__2.Input.DisableArrowGlow.Value and u24[p30.Name][p28] then
							if false then
								u19:Disconnect();
								u24[p30.Name][p28]:PlayAnimation("Receptor");
								return;
							else
								u24[p30.Name][p28]:PlayAnimation("Glow");
								v158 = "Frame";
								v159 = v147;
								v160 = v158;
								v161 = v159[v160];
								v176 = "Bar";
								v162 = v161;
								v163 = v176;
								v164 = v162[v163];
								v177 = "Size";
								v165 = v164;
								v166 = v177;
								v167 = v165[v166];
								v178 = "Y";
								v168 = v167;
								v169 = v178;
								v170 = v168[v169];
								v179 = "Scale";
								v172 = v170;
								v173 = v179;
								v171 = v172[v173];
								v180 = 0;
								v174 = v180;
								v175 = v171;
								if v174 < v175 then
									v181 = tick();
									while true do
										v10.wait();
										l__Scale__182 = v147.Position.Y.Scale;
										if l__Scale__182 < 0 then
											v147.Frame.Bar.Size = UDim2.new(l__LocalPlayer__2.Input.BarSize.Value, 0, math.clamp(v171 + l__Scale__182, 0, 20), 0);
											v147.Frame.Bar.Position = UDim2.new(0.5, 0, 0.5 - l__Scale__182, 0);
										end;
										if not u34[p28] then
											break;
										end;
										if v147.Frame.Bar.Size.Y.Scale == 0 then
											break;
										end;
										if tick() - v181 > 7.5 then
											break;
										end;									
									end;
								else
									v10.wait(0.175);
								end;
								v183 = true;
								v154 = u41;
								v153 = p31;
								v155 = v153;
								v156 = v154;
								v157 = v155;
								v156(v157);
								return;
							end;
						else
							v158 = "Frame";
							v159 = v147;
							v160 = v158;
							v161 = v159[v160];
							v176 = "Bar";
							v162 = v161;
							v163 = v176;
							v164 = v162[v163];
							v177 = "Size";
							v165 = v164;
							v166 = v177;
							v167 = v165[v166];
							v178 = "Y";
							v168 = v167;
							v169 = v178;
							v170 = v168[v169];
							v179 = "Scale";
							v172 = v170;
							v173 = v179;
							v171 = v172[v173];
							v180 = 0;
							v174 = v180;
							v175 = v171;
							if v174 < v175 then
								v181 = tick();
								while true do
									v10.wait();
									l__Scale__182 = v147.Position.Y.Scale;
									if l__Scale__182 < 0 then
										v147.Frame.Bar.Size = UDim2.new(l__LocalPlayer__2.Input.BarSize.Value, 0, math.clamp(v171 + l__Scale__182, 0, 20), 0);
										v147.Frame.Bar.Position = UDim2.new(0.5, 0, 0.5 - l__Scale__182, 0);
									end;
									if not u34[p28] then
										break;
									end;
									if v147.Frame.Bar.Size.Y.Scale == 0 then
										break;
									end;
									if tick() - v181 > 7.5 then
										break;
									end;								
								end;
							else
								v10.wait(0.175);
							end;
							v183 = true;
							v154 = u41;
							v153 = p31;
							v155 = v153;
							v156 = v154;
							v157 = v155;
							v156(v157);
							return;
						end;
					elseif not l__LocalPlayer__2.Input.DisableArrowGlow.Value and u24[p30.Name][p28] then
						if false then
							u19:Disconnect();
							u24[p30.Name][p28]:PlayAnimation("Receptor");
							return;
						else
							u24[p30.Name][p28]:PlayAnimation("Glow");
							v158 = "Frame";
							v159 = v147;
							v160 = v158;
							v161 = v159[v160];
							v176 = "Bar";
							v162 = v161;
							v163 = v176;
							v164 = v162[v163];
							v177 = "Size";
							v165 = v164;
							v166 = v177;
							v167 = v165[v166];
							v178 = "Y";
							v168 = v167;
							v169 = v178;
							v170 = v168[v169];
							v179 = "Scale";
							v172 = v170;
							v173 = v179;
							v171 = v172[v173];
							v180 = 0;
							v174 = v180;
							v175 = v171;
							if v174 < v175 then
								v181 = tick();
								while true do
									v10.wait();
									l__Scale__182 = v147.Position.Y.Scale;
									if l__Scale__182 < 0 then
										v147.Frame.Bar.Size = UDim2.new(l__LocalPlayer__2.Input.BarSize.Value, 0, math.clamp(v171 + l__Scale__182, 0, 20), 0);
										v147.Frame.Bar.Position = UDim2.new(0.5, 0, 0.5 - l__Scale__182, 0);
									end;
									if not u34[p28] then
										break;
									end;
									if v147.Frame.Bar.Size.Y.Scale == 0 then
										break;
									end;
									if tick() - v181 > 7.5 then
										break;
									end;								
								end;
							else
								v10.wait(0.175);
							end;
							v183 = true;
							v154 = u41;
							v153 = p31;
							v155 = v153;
							v156 = v154;
							v157 = v155;
							v156(v157);
							return;
						end;
					else
						v158 = "Frame";
						v159 = v147;
						v160 = v158;
						v161 = v159[v160];
						v176 = "Bar";
						v162 = v161;
						v163 = v176;
						v164 = v162[v163];
						v177 = "Size";
						v165 = v164;
						v166 = v177;
						v167 = v165[v166];
						v178 = "Y";
						v168 = v167;
						v169 = v178;
						v170 = v168[v169];
						v179 = "Scale";
						v172 = v170;
						v173 = v179;
						v171 = v172[v173];
						v180 = 0;
						v174 = v180;
						v175 = v171;
						if v174 < v175 then
							v181 = tick();
							while true do
								v10.wait();
								l__Scale__182 = v147.Position.Y.Scale;
								if l__Scale__182 < 0 then
									v147.Frame.Bar.Size = UDim2.new(l__LocalPlayer__2.Input.BarSize.Value, 0, math.clamp(v171 + l__Scale__182, 0, 20), 0);
									v147.Frame.Bar.Position = UDim2.new(0.5, 0, 0.5 - l__Scale__182, 0);
								end;
								if not u34[p28] then
									break;
								end;
								if v147.Frame.Bar.Size.Y.Scale == 0 then
									break;
								end;
								if tick() - v181 > 7.5 then
									break;
								end;							
							end;
						else
							v10.wait(0.175);
						end;
						v183 = true;
						v154 = u41;
						v153 = p31;
						v155 = v153;
						v156 = v154;
						v157 = v155;
						v156(v157);
						return;
					end;
				else
					v154 = u41;
					v153 = p31;
					v155 = v153;
					v156 = v154;
					v157 = v155;
					v156(v157);
					return;
				end;
			end;
		else
			return;
		end;
	end;
	u36(p28);
	if v147 and v147 ~= "ghost" then
		if v147:FindFirstChild("HitSound") then
			v10.PlaySound(v147.HitSound.Value);
		elseif l__LocalPlayer__2.Input.HitSounds.Value == true then
			v10.PlaySound(v114);
		end;
		local v184 = string.split(v147:GetAttribute("NoteData"), "~")[1] - (v10.tomilseconds(l__Config__4.TimePast.Value) + u22);
		local v185 = math.abs(v184);
		local v186 = string.split(v147.Name, "_")[1];
		if v185 <= v11.Sick then
			u37(v186);
		end;
		if l__LocalPlayer__2.Input.ScoreBop.Value then
			if l__LocalPlayer__2.Input.VerticalBar.Value then
				for v187, v188 in pairs(l__Parent__3.SideContainer:GetChildren()) do
					if v188.ClassName == "TextLabel" then
						v188.Size = UDim2.new(u21[v188.Name].X.Scale * 1.1, 0, u21[v188.Name].Y.Scale * 1.1, 0);
						l__TweenService__12:Create(v188, TweenInfo.new(0.3), {
							Size = u21[v188.Name]
						}):Play();
					end;
				end;
			else
				l__Parent__3.LowerContainer.Stats.Size = UDim2.new(u21.Stats.X.Scale * 1.1, 0, u21.Stats.Y.Scale * 1.1, 0);
				l__TweenService__12:Create(l__Parent__3.LowerContainer.Stats, TweenInfo.new(0.3), {
					Size = u21.Stats
				}):Play();
			end;
		end;
		u38(v186);
		u3 = u3 + 1;
		if u39 and u39.OnHit then
			u39.OnHit(l__Parent__3, u5, u3, v186);
		end;
		v27();
		if v147.HellNote.Value == false then
			local v189 = "0";
		else
			v189 = "1";
		end;
		l__UserInput__40:FireServer(v147, p28 .. "|0|" .. v10.tomilseconds(l__Config__4.TimePast.Value) + u22 .. "|" .. v147.Position.Y.Scale .. "|" .. v147:GetAttribute("NoteData") .. "|" .. v147.Name .. "|" .. v147:GetAttribute("Length") .. "|" .. tostring(v189));
		table.insert(u12, {
			ms = v184, 
			songPos = l__Parent__3.Config.TimePast.Value, 
			miss = false
		});
		v147.Frame.Arrow.Visible = false;
		if not u33[p28] then
			return;
		end;
		v17.Glow[p28].Arrow.ImageTransparency = 1;
		v17.Glow[p28].Arrow.Visible = true;
		if v17.Glow[p28].Arrow.ImageTransparency == 1 then
			if not l__LocalPlayer__2.Input.DisableArrowGlow.Value and not u24[v17.Name][p28] then
				local u44 = false;
				local u45 = nil;
				u45 = l__RunService__14.RenderStepped:Connect(function()
					if u44 then
						u45:Disconnect();
						v17.Glow[p28].Arrow.ImageTransparency = 1;
						return;
					end;
					v17.Glow[p28].Arrow.ImageTransparency = 0.2 - math.cos(tick() * 10 * math.pi) / 6 + v17.Arrows[p28].ImageTransparency / 1.25;
				end);
			elseif not l__LocalPlayer__2.Input.DisableArrowGlow.Value and u24[v17.Name][p28] then
				if false then
					u19:Disconnect();
					u24[v17.Name][p28]:PlayAnimation("Receptor");
					return;
				end;
				u24[v17.Name][p28]:PlayAnimation("Glow");
			end;
			local l__Scale__190 = v147.Frame.Bar.Size.Y.Scale;
			if l__Scale__190 > 0 then
				local v191 = math.abs(v184);
				while true do
					task.wait();
					local l__Scale__192 = v147.Position.Y.Scale;
					if l__Scale__192 < 0 and v147:FindFirstChild("Frame") then
						v147.Frame.Bar.Size = UDim2.new(l__LocalPlayer__2.Input.BarSize.Value, 0, math.clamp(l__Scale__190 + l__Scale__192, 0, 20), 0);
						v147.Frame.Bar.Position = UDim2.new(0.5, 0, 0.5 - l__Scale__192, 0);
					end;
					if not u33[p28] then
						break;
					end;				
				end;
				if v147.HellNote.Value == false then
					local v193 = "0";
				else
					v193 = "1";
				end;
				l__UserInput__40:FireServer(v147, p28 .. "|1|" .. v10.tomilseconds(l__Config__4.TimePast.Value) + u22 .. "|" .. v147.Position.Y.Scale .. "|" .. v147:GetAttribute("NoteData") .. "|" .. v147.Name .. "|" .. v147:GetAttribute("Length") .. "|" .. tostring(v193));
				local v194 = 1 - math.clamp(math.abs(v147.Position.Y.Scale) / v147:GetAttribute("Length"), 0, 1);
				if v194 <= v113 / 10 then
					if v191 <= v11.Marvelous and l__LocalPlayer__2.Input.ShowMarvelous.Value then
						local v195 = "Marvelous";
					else
						v195 = "Sick";
					end;
					u41(v195, v184);
					table.insert(u1, 1, 100);
					if v191 <= v11.Marvelous and l__LocalPlayer__2.Input.ShowMarvelous.Value then
						u6 = u6 + 1;
					else
						u7 = u7 + 1;
					end;
				elseif v194 <= v113 / 6 then
					u41("Good", v184);
					table.insert(u1, 1, 90);
					u8 = u8 + 1;
					if l__Parent__3:GetAttribute("Perfect") then
						l__LocalPlayer__2.Character.Humanoid.Health = 0;
					end;
				elseif v194 <= v113 then
					u41("Bad", v184);
					table.insert(u1, 1, 60);
					u10 = u10 + 1;
					if l__Parent__3:GetAttribute("Perfect") then
						l__LocalPlayer__2.Character.Humanoid.Health = 0;
					end;
				end;
				v27();
				v147.Visible = false;
			else
				if v147.HellNote.Value ~= false then

				end;
				if v185 <= v11.Marvelous * 1 and l__LocalPlayer__2.Input.ShowMarvelous.Value then
					u41("Marvelous", v184);
					table.insert(u1, 1, 100);
					u6 = u6 + 1;
				elseif v185 <= v11.Sick * 1 then
					u41("Sick", v184);
					table.insert(u1, 1, 100);
					u7 = u7 + 1;
				elseif v185 <= v11.Good * 1 then
					u41("Good", v184);
					table.insert(u1, 1, 90);
					u8 = u8 + 1;
					if l__Parent__3:GetAttribute("Perfect") then
						l__LocalPlayer__2.Character.Humanoid.Health = 0;
					end;
				elseif v185 <= v11.Ok * 1 then
					u41("Ok", v184);
					table.insert(u1, 1, 75);
					u9 = u9 + 1;
					if l__Parent__3:GetAttribute("Perfect") then
						l__LocalPlayer__2.Character.Humanoid.Health = 0;
					end;
				elseif v185 <= v11.Bad * 1 then
					u41("Bad", v184);
					table.insert(u1, 1, 60);
					u10 = u10 + 1;
					if l__Parent__3:GetAttribute("Perfect") then
						l__LocalPlayer__2.Character.Humanoid.Health = 0;
					end;
				end;
				v27();
				while true do
					v10.wait();
					if not u33[p28] then
						break;
					end;				
				end;
				v147.Visible = false;
			end;
		end;
	end;
	if not u33[p28] then
		return;
	end;
	if v147 ~= "ghost" then
		l__UserInput__40:FireServer("missed", p28 .. "|0");
		table.insert(u1, 1, 0);
		u4 = u4 + 1;
		u3 = 0;
		v27();
		table.insert(u12, {
			ms = 0, 
			songPos = l__Parent__3.Config.TimePast.Value, 
			miss = true
		});
		if u39 and u39.OnMiss then
			u39.OnMiss(l__Parent__3, u4);
		end;
		if l__Parent__3:GetAttribute("SuddenDeath") and l__Config__4.TimePast.Value > 0 then
			l__LocalPlayer__2.Character.Humanoid.Health = 0;
		end;
		local v196 = l__Parent__3.Sounds:GetChildren()[math.random(1, #l__Parent__3.Sounds:GetChildren())];
		v196.Volume = l__LocalPlayer__2.Input.MissVolume.Value and 0.3;
		v196:Play();
	end;
	local v197 = v17.Arrows[p28];
	u33[p28] = true;
	if u24[v17.Name][p28] then
		u24[v17.Name][p28]:PlayAnimation("Press");
	else
		v197.Overlay.Visible = true;
	end;
	local v198 = 1 * l__LocalPlayer__2.Input.ArrowSize.Value;
	if v72 then
		v198 = 1;
	end;
	if v74 then
		v198 = 0.85;
	end;
	if v73 then
		v198 = 0.7;
	end;
	if v85 then
		v198 = v85.CustomArrowSize and 1;
	end;
	l__TweenService__12:Create(v197, TweenInfo.new(0.05, Enum.EasingStyle.Linear, Enum.EasingDirection.In, 0, false, 0), {
		Size = v147 == "ghost" and UDim2.new(v198 / 1.05, 0, v198 / 1.05, 0) or UDim2.new(v198 / 1.25, 0, v198 / 1.25, 0)
	}):Play();
	while true do
		task.wait();
		if not u33[p28] then
			break;
		end;	
	end;
	if u24[v17.Name][p28] then
		u24[v17.Name][p28]:PlayAnimation("Receptor");
	else
		v197.Overlay.Visible = false;
	end;
	l__TweenService__12:Create(v197, TweenInfo.new(0.05, Enum.EasingStyle.Quint, Enum.EasingDirection.Out, 0, false, 0), {
		Size = UDim2.new(v198, 0, v198, 0)
	}):Play();
end;
local v199 = nil;
local l__Value__200 = _G.LastInput.Value;
if l__Value__200 == Enum.UserInputType.Touch then
	script.Device.Value = "Mobile";
	v10.wait(0.2);
	local v201, v202, v203 = ipairs(l__Parent__3.MobileButtons.Container:GetChildren());
	while true do
		v201(v202, v203);
		if not v201 then
			break;
		end;
		v203 = v201;
		if v202:IsA("ImageButton") then
			v202.MouseButton1Down:Connect(function()
				v144({
					UserInputState = Enum.UserInputState.Begin
				}, v202.Name);
			end);
			v202.MouseButton1Up:Connect(function()
				v144({
					UserInputState = Enum.UserInputState.End
				}, v202.Name);
			end);
		end;	
	end;
	script.Parent.MobileButtons.Visible = true;
elseif l__Value__200 == Enum.UserInputType.Keyboard then
	script.Device.Value = "Computer";
	local function v204(p32, p33)
		if p33 then
			return;
		end;
		local l__Keybinds__205 = l__LocalPlayer__2.Input.Keybinds;
		if v85 and v85.getDirection then
			local v206 = v85.getDirection(p32.KeyCode, l__Keybinds__205);
			if v206 then
				v144(p32, v206);
				return;
			end;
		else
			if v71 then
				local v207, v208, v209 = ipairs(l__Keybinds__205:GetChildren());
				while true do
					v207(v208, v209);
					if not v207 then
						break;
					end;
					v209 = v207;
					if v208:GetAttribute("ExtraKey") and p32.KeyCode.Name == v208.Value then
						v144(p32, v104[v208.Name]);
						return;
					end;				
				end;
				return;
			end;
			local v210, v211, v212 = ipairs(l__Keybinds__205:GetChildren());
			while true do
				v210(v211, v212);
				if not v210 then
					break;
				end;
				v212 = v210;
				if not v211:GetAttribute("ExtraKey") then
					if p32.KeyCode.Name == v211.Value then
						local l__Name__213 = v211.Name;
						if v211:GetAttribute("SecondaryKey") then
							local v214 = v211:GetAttribute("Key");
						end;
						v144(p32, v211:GetAttribute("SecondaryKey") and v211:GetAttribute("Key") or v211.Name);
						return;
					end;
					if v211:GetAttribute("SecondaryKey") and p32.KeyCode.Name == v211:GetAttribute("Key") then
						l__Name__213 = v211.Name;
						if v211:GetAttribute("SecondaryKey") then
							v214 = v211:GetAttribute("Key");
						end;
						v144(p32, v211:GetAttribute("SecondaryKey") and v211:GetAttribute("Key") or v211.Name);
						return;
					end;
				end;			
			end;
		end;
	end;
	v199 = l__UserInputService__13.InputBegan:connect(v204);
	local v215 = l__UserInputService__13.InputEnded:connect(v204);
elseif l__Value__200 == Enum.UserInputType.Gamepad1 then
	script.Device.Value = "Controller";
	local function v216(p34, p35)
		local l__XBOXKeybinds__217 = l__LocalPlayer__2.Input.XBOXKeybinds;
		if v85 and v85.getDirection then
			local v218 = v85.getDirection(p34.KeyCode, l__XBOXKeybinds__217);
			if v218 then
				v144(p34, v218);
				return;
			end;
		elseif v71 then
			local v219, v220, v221 = ipairs(l__XBOXKeybinds__217:GetChildren());
			while true do
				v219(v220, v221);
				if not v219 then
					break;
				end;
				v221 = v219;
				if v220:GetAttribute("ExtraKey") and p34.KeyCode.Name == v220.Value then
					v144(p34, v104[v220.Name:sub(12, -1)]);
					return;
				end;			
			end;
			return;
		else
			local v222, v223, v224 = ipairs(l__XBOXKeybinds__217:GetChildren());
			while true do
				v222(v223, v224);
				if not v222 then
					break;
				end;
				v224 = v222;
				if not v223:GetAttribute("ExtraKey") and p34.KeyCode.Name == v223.Value then
					v144(p34, v223.Name:sub(12, -1));
					return;
				end;			
			end;
		end;
	end;
	v199 = l__UserInputService__13.InputBegan:connect(v216);
	local v225 = l__UserInputService__13.InputEnded:connect(v216);
end;
if l__Parent__3.PlayerSide.Value == "L" then
	local v226 = l__Value__6.Events.Player2Hit.OnClientEvent:Connect(function(p36)
		p36 = string.split(p36, "|");
		v144({
			UserInputState = p36[2] == "0" and Enum.UserInputState.Begin or Enum.UserInputState.End
		}, p36[1], string.gsub(p36[3], "~", "|") .. "~" .. p36[4], true, (tonumber(p36[5])));
	end);
else
	v226 = l__Value__6.Events.Player1Hit.OnClientEvent:Connect(function(p37)
		p37 = string.split(p37, "|");
		v144({
			UserInputState = p37[2] == "0" and Enum.UserInputState.Begin or Enum.UserInputState.End
		}, p37[1], string.gsub(p37[3], "~", "|") .. "~" .. p37[4], true, (tonumber(p37[5])));
	end);
end;
l__Parent__3.Side.Changed:Connect(function()
	if u39 and u39.OverrideCamera then
		return;
	end;
	local l__Value__227 = l__Parent__3.Side.Value;
	local v228 = workspace.ClientBG:FindFirstChildOfClass("Model");
	l__TweenService__12:Create(workspace.CurrentCamera, TweenInfo.new(1, Enum.EasingStyle.Quint, Enum.EasingDirection.Out, 0, false, 0), {
		CFrame = (v228 and v228:FindFirstChild("cameraPoints") and v228.cameraPoints:FindFirstChild(l__Value__227) or (l__Value__6.CameraPoints:FindFirstChild(l__Value__227) or l__Value__6.CameraPoints.C)).CFrame
	}):Play();
end);
if l__LocalPlayer__2.Input.HideMap.Value then
	local v229 = Instance.new("Frame");
	v229.Parent = l__Parent__3;
	v229.Position = UDim2.new(0, 0, 0, 0);
	v229.BackgroundColor3 = Color3.fromRGB(0, 0, 0);
	v229.Size = UDim2.new(1, 0, 1, 0);
	v229.BackgroundTransparency = 1;
	l__LocalPlayer__2.Character:WaitForChild("Humanoid").Died:Connect(function()
		game.ReplicatedStorage.Events.UnloadBackground:Fire();
	end);
	l__TweenService__12:Create(v229, TweenInfo.new(0.4), {
		BackgroundTransparency = 0
	}):Play();
	task.wait(0.4);
	task.spawn(function()
		l__TweenService__12:Create(v229, TweenInfo.new(0.4), {
			BackgroundTransparency = 1
		}):Play();
		task.wait(0.4);
		v229:Destroy();
	end);
	for v230, v231 in pairs(workspace:GetDescendants()) do
		if not v231:IsDescendantOf(l__Value__6) and not v231:IsDescendantOf(workspace.Misc.ActualShop) and (not l__Value__6.Seat.Occupant or not v231:IsDescendantOf(l__Value__6.Seat.Occupant.Parent)) and (not l__Value__6.Config.Player1.Value or not v231:IsDescendantOf(l__Value__6.Config.Player1.Value.Character)) and (not l__Value__6.Config.Player2.Value or not v231:IsDescendantOf(l__Value__6.Config.Player2.Value.Character)) then
			if not (not v231:IsA("BasePart")) or not (not v231:IsA("Decal")) or v231:IsA("Texture") then
				v231.Transparency = 1;
			elseif v231:IsA("GuiObject") then
				v231.Visible = false;
			elseif v231:IsA("Beam") or v231:IsA("ParticleEmitter") then
				v231.Enabled = false;
			end;
		end;
	end;
	local v232 = game.ReplicatedStorage.Misc.DarkVoid:Clone();
	v232.Parent = workspace.ClientBG;
	v232:SetPrimaryPartCFrame(l__Value__6.BackgroundPart.CFrame);
	for v233, v234 in pairs(game.Lighting:GetChildren()) do
		v234:Destroy();
	end;
	for v235, v236 in pairs(v232.Lighting:GetChildren()) do
		v236:Clone().Parent = game.Lighting;
	end;
	l__Value__6.Misc.Stereo.Speakers.Transparency = 1;
	for v237, v238 in pairs(l__Value__6.Fireworks:GetChildren()) do
		v238.Transparency = 1;
	end;
end;
local u46 = false;
l__Events__5.ChangeBackground.Event:Connect(function(p38, p39, p40)
	if not l__LocalPlayer__2.Input.Backgrounds.Value or l__LocalPlayer__2.Input.HideMap.Value then
		return;
	end;
	local l__Backgrounds__239 = game.ReplicatedStorage.Backgrounds;
	local v240 = l__Backgrounds__239:FindFirstChild(p39) and l__Backgrounds__239[p39]:Clone() or game.ReplicatedStorage.Events.Backgrounds:InvokeServer("Load", p38, p39, v70);
	if not l__Backgrounds__239:FindFirstChild(p39) then
		v240:Clone().Parent = l__Backgrounds__239;
	end;
	for v241, v242 in pairs(workspace.ClientBG:GetChildren()) do
		v242:Destroy();
	end;
	if l__Value__6.Config.CleaningUp.Value then
		return;
	end;
	if not u46 then
		u46 = true;
		local v243 = Instance.new("Frame");
		v243.Parent = l__Parent__3;
		v243.Position = UDim2.new(0, 0, 0, 0);
		v243.BackgroundColor3 = Color3.fromRGB(0, 0, 0);
		v243.Size = UDim2.new(1, 0, 1, 0);
		v243.BackgroundTransparency = 1;
		l__TweenService__12:Create(v243, TweenInfo.new(0.4), {
			BackgroundTransparency = 0
		}):Play();
		task.wait(0.4);
		task.spawn(function()
			l__TweenService__12:Create(v243, TweenInfo.new(0.4), {
				BackgroundTransparency = 1
			}):Play();
			task.wait(0.4);
			v243:Destroy();
		end);
		for v244, v245 in pairs(workspace:GetDescendants()) do
			if not v245:IsDescendantOf(l__Value__6) and not v245:IsDescendantOf(workspace.Misc.ActualShop) and (not l__Value__6.Seat.Occupant or not v245:IsDescendantOf(l__Value__6.Seat.Occupant.Parent)) and (not l__Value__6.Config.Player1.Value or not v245:IsDescendantOf(l__Value__6.Config.Player1.Value.Character)) and (not l__Value__6.Config.Player2.Value or not v245:IsDescendantOf(l__Value__6.Config.Player2.Value.Character)) then
				if not (not v245:IsA("BasePart")) or not (not v245:IsA("Decal")) or v245:IsA("Texture") then
					v245.Transparency = 1;
				elseif v245:IsA("GuiObject") then
					v245.Visible = false;
				elseif v245:IsA("Beam") or v245:IsA("ParticleEmitter") then
					v245.Enabled = false;
				end;
			end;
		end;
	end;
	if p40 then
		local v246 = 0;
	else
		v246 = 1;
	end;
	l__Value__6.Misc.Stereo.Speakers.Transparency = v246;
	for v247, v248 in pairs(l__Value__6.Fireworks:GetChildren()) do
		if p40 then
			local v249 = 0;
		else
			v249 = 1;
		end;
		v248.Transparency = v249;
	end;
	v240.Parent = workspace.ClientBG;
	v240:SetPrimaryPartCFrame(l__Value__6.BackgroundPart.CFrame);
	if v240:FindFirstChild("Lighting") then
		for v250, v251 in pairs(game.Lighting:GetChildren()) do
			v251:Destroy();
		end;
		for v252, v253 in pairs(v240.Lighting:GetChildren()) do
			v253:Clone().Parent = game.Lighting;
		end;
	end;
	if v240:FindFirstChild("ModuleScript") then
		task.spawn(require(v240.ModuleScript).BGFunction);
	end;
	if v240:FindFirstChild("cameraPoints") then
		l__CameraPoints__8.L.CFrame = v240.cameraPoints.L.CFrame;
		l__CameraPoints__8.C.CFrame = v240.cameraPoints.C.CFrame;
		l__CameraPoints__8.R.CFrame = v240.cameraPoints.R.CFrame;
		if u39 and u39.OverrideCamera then
			return;
		end;
		l__TweenService__12:Create(workspace.CurrentCamera, TweenInfo.new(0.1), {
			CFrame = v240.cameraPoints.L.CFrame
		}):Play();
	end;
	if v240:FindFirstChild("playerPoints") then
		local function u47(p41, p42)
			if not p41 then
				return;
			end;
			local l__Character__254 = p41.Character;
			if l__Character__254 then
				if l__Character__254:FindFirstChild("char2") then
					local l__Dummy__255 = l__Character__254.char2:WaitForChild("Dummy");
					if not l__Dummy__255.PrimaryPart then
						while true do
							task.wait();
							if l__Dummy__255.PrimaryPart then
								break;
							end;						
						end;
					end;
					local l__PrimaryPart__256 = l__Dummy__255.PrimaryPart;
					if not l__PrimaryPart__256:GetAttribute("YOffset") then
						l__PrimaryPart__256:SetAttribute("YOffset", l__PrimaryPart__256.Position.Y - l__Character__254.PrimaryPart.Position.Y);
					end;
					if not l__PrimaryPart__256:GetAttribute("OrientationOffset") then
						l__PrimaryPart__256:SetAttribute("OrientationOffset", l__PrimaryPart__256.Orientation.Y - l__Character__254.PrimaryPart.Orientation.Y);
					end;
					l__PrimaryPart__256.CFrame = p42.CFrame + Vector3.new(0, l__PrimaryPart__256:GetAttribute("YOffset"), 0);
					l__PrimaryPart__256.CFrame = l__PrimaryPart__256.CFrame * CFrame.Angles(0, math.rad((l__PrimaryPart__256:GetAttribute("OrientationOffset"))), 0);
				end;
				if l__Character__254:FindFirstChild("customrig") then
					local l__rig__257 = l__Character__254.customrig:WaitForChild("rig");
					if not l__rig__257.PrimaryPart then
						while true do
							task.wait();
							if l__rig__257.PrimaryPart then
								break;
							end;						
						end;
					end;
					local l__PrimaryPart__258 = l__rig__257.PrimaryPart;
					if not l__PrimaryPart__258:GetAttribute("YOffset") then
						l__PrimaryPart__258:SetAttribute("YOffset", l__PrimaryPart__258.Position.Y - l__Character__254.PrimaryPart.Position.Y);
					end;
					if not l__PrimaryPart__258:GetAttribute("OrientationOffset") then
						l__PrimaryPart__258:SetAttribute("OrientationOffset", l__PrimaryPart__258.Orientation.Y - l__Character__254.PrimaryPart.Orientation.Y);
					end;
					l__PrimaryPart__258.CFrame = p42.CFrame + Vector3.new(0, l__PrimaryPart__258:GetAttribute("YOffset"), 0);
					l__PrimaryPart__258.CFrame = l__PrimaryPart__258.CFrame * CFrame.Angles(0, math.rad((l__PrimaryPart__258:GetAttribute("OrientationOffset"))), 0);
				end;
				if l__Character__254 then
					l__Character__254.PrimaryPart.CFrame = p42.CFrame;
				end;
			end;
		end;
		local l__playerPoints__48 = v240.playerPoints;
		task.spawn(function()
			while l__Parent__3.Parent and v240.Parent do
				local l__Value__259 = l__Value__6.Config.Player1.Value;
				u47(l__Value__6:FindFirstChild("NPC"), l__Value__259 and l__playerPoints__48.PlayerPointB or l__playerPoints__48.PlayerPointA);
				u47(l__Value__259, l__playerPoints__48.PlayerPointA);
				u47(l__Value__6.Config.Player2.Value, l__playerPoints__48.PlayerPointB);
				task.wait(1);			
			end;
		end);
	end;
end);
if v70:FindFirstChild("Background") and l__Parent__3:FindFirstAncestorOfClass("Player") then
	l__Parent__3.Events.ChangeBackground:Fire(v70.stageName.Value, v70.Background.Value, v70.Background.Stereo.Value);
end;
if l__Value__6.Config.SinglePlayerEnabled.Value and not v70:FindFirstChild("NoNPC") then
	local v260 = require(l__Parent__3.Modules.Bot);
	v260.Start(u20.speed, v17);
	v260.Act(l__Parent__3.PlayerSide.Value);
end;
local u49 = {
	Left = { Vector2.new(315, 116), Vector2.new(77, 77.8) }, 
	Down = { Vector2.new(925, 77), Vector2.new(78.5, 77) }, 
	Up = { Vector2.new(925, 0), Vector2.new(78.5, 77) }, 
	Right = { Vector2.new(238, 116), Vector2.new(77, 78.5) }
};
local u50 = {
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
if v70:FindFirstChild("MineNotes") then
	local v261 = require(v70.MineNotes:FindFirstChildOfClass("ModuleScript"));
	local v262 = Instance.new("ImageLabel");
	v262.Image = v261.Image or "rbxassetid://9873431724";
	v262.Size = UDim2.new(0, 0, 0, 0);
	v262.Parent = l__Parent__3;
	if v261.update then
		game:GetService("RunService").RenderStepped:Connect(function(p43)
			v261.update(p43, l__Parent__3);
		end);
	end;
end;
if v70:FindFirstChild("GimmickNotes") then
	local v263 = require(v70.GimmickNotes:FindFirstChildOfClass("ModuleScript"));
	local v264 = Instance.new("ImageLabel");
	v264.Image = v263.Image or "rbxassetid://9873431724";
	v264.Size = UDim2.new(0, 0, 0, 0);
	v264.Parent = l__Parent__3;
	if v263.update then
		game:GetService("RunService").RenderStepped:Connect(function(p44)
			v263.update(p44, l__Parent__3);
		end);
	end;
end;
if v70:FindFirstChild("MultipleGimmickNotes") then
	local v265, v266, v267 = pairs(v70.MultipleGimmickNotes:GetChildren());
	while true do
		local v268, v269 = v265(v266, v267);
		if not v268 then
			break;
		end;
		if not v269:IsA("Frame") then
			return;
		end;
		local v270 = require(v269:FindFirstChildOfClass("ModuleScript"));
		local v271 = Instance.new("ImageLabel");
		v271.Image = v270.Image or "rbxassetid://9873431724";
		v271.Size = UDim2.new(0, 0, 0, 0);
		v271.Parent = l__Parent__3;
		if v270.update then
			game:GetService("RunService").RenderStepped:Connect(function(p45)
				v270.update(p45, l__Parent__3);
			end);
		end;
		for v272, v273 in pairs(u50) do
			local v274 = v269:Clone();
			v274.Name = ("%s_%s"):format(v272, v269.Name);
			v274.Frame.Position = UDim2.fromScale(v273.Pos, 0);
			v274.Frame.AnchorPoint = Vector2.new(0.5, 0);
			v274.Parent = l__Game__7.Templates;
		end;	
	end;
end;
(function(p46, p47)
	if v17.Name == "L" then
		local v275 = "R";
	else
		v275 = "L";
	end;
	local v276 = l__Game__7:FindFirstChild(v275);
	if v70:FindFirstChild("UIStyle") then
		ChangeUI(v70:FindFirstChild("UIStyle").Value);
	else
		ChangeUI(nil);
	end;
	updateUI(p46);
	l__Parent__3.Background.BackgroundTransparency = l__LocalPlayer__2.Input.BackgroundTrans.Value;
	l__Game__7.L.Underlay.BackgroundTransparency = l__LocalPlayer__2.Input.ChartTransparency.Value;
	l__Game__7.R.Underlay.BackgroundTransparency = l__LocalPlayer__2.Input.ChartTransparency.Value;
	v84.settingsCheck(v71, v70:FindFirstChild("NoSettings"));
	u22 = v70.Offset.Value + (l__LocalPlayer__2.Input.Offset.Value and 0);
	if not v71 then
		local v277, v278, v279 = ipairs(v17.Arrows:GetChildren());
		while true do
			v277(v278, v279);
			if not v277 then
				break;
			end;
			v279 = v277;
			if v278:IsA("ImageLabel") then
				v278.Image = l__Value__23;
				v278.Overlay.Image = l__Value__23;
			end;		
		end;
		local v280, v281, v282 = ipairs(v17.Glow:GetChildren());
		while true do
			v280(v281, v282);
			if not v280 then
				break;
			end;
			v282 = v280;
			v281.Arrow.Image = l__Value__23;		
		end;
		if v50:FindFirstChild("XML") then
			local v283 = require(v50.XML);
			if v50:FindFirstChild("Animated") and v50:FindFirstChild("Animated").Value == true then
				local v284 = require(v50.Config);
				local v285, v286, v287 = ipairs(v17.Arrows:GetChildren());
				while true do
					v285(v286, v287);
					if not v285 then
						break;
					end;
					v287 = v285;
					if v286:IsA("ImageLabel") then
						v286.Overlay.Visible = false;
						local v288 = v16.new(v286, true, 1, false);
						v288.Animations = {};
						v288.CurrAnimation = nil;
						v288.AnimData.Looped = false;
						if type(v284.receptor) == "string" then
							v288:AddSparrowXML(v50.XML, "Receptor", v284.receptor, 24, true).ImageId = l__Value__23;
						else
							v288:AddSparrowXML(v50.XML, "Receptor", v284.receptor[v286.Name], 24, true).ImageId = l__Value__23;
						end;
						if v284.glow ~= nil then
							if type(v284.glow) == "string" then
								v288:AddSparrowXML(v50.XML, "Glow", v284.glow, 24, true).ImageId = l__Value__23;
							else
								v288:AddSparrowXML(v50.XML, "Glow", v284.glow[v286.Name], 24, true).ImageId = l__Value__23;
							end;
						end;
						if v284.press ~= nil then
							if type(v284.press) == "string" then
								v288:AddSparrowXML(v50.XML, "Press", v284.press, 24, true).ImageId = l__Value__23;
							else
								v288:AddSparrowXML(v50.XML, "Press", v284.press[v286.Name], 24, true).ImageId = l__Value__23;
							end;
						end;
						v288:PlayAnimation("Receptor");
						u24[v17.Name][v286.Name] = v288;
					end;				
				end;
				local v289, v290, v291 = ipairs(v17.Glow:GetChildren());
				while true do
					v289(v290, v291);
					if not v289 then
						break;
					end;
					v291 = v289;
					v290.Arrow.Visible = false;				
				end;
			else
				v283.XML(v17);
			end;
		end;
		if v87 then
			local v292, v293, v294 = ipairs(v276.Arrows:GetChildren());
			while true do
				v292(v293, v294);
				if not v292 then
					break;
				end;
				v294 = v292;
				if v293:IsA("ImageLabel") then
					v293.Image = l__Value__25;
					v293.Overlay.Image = l__Value__25;
				end;			
			end;
			local v295, v296, v297 = ipairs(v276.Glow:GetChildren());
			while true do
				v295(v296, v297);
				if not v295 then
					break;
				end;
				v297 = v295;
				v296.Arrow.Image = l__Value__25;			
			end;
			if v88:FindFirstChild("XML") then
				local v298 = nil;
				local v299 = nil;
				local v300 = nil;
				local v301 = nil;
				local v302 = nil;
				local v303 = nil;
				local v304 = nil;
				local v305 = nil;
				local v306 = nil;
				local v307 = nil;
				local v308 = nil;
				local v309 = nil;
				local v310 = nil;
				if v88:FindFirstChild("Animated") then
					if v88:FindFirstChild("Animated").Value == true then
						local v311 = require(v88.Config);
						local v312, v313, v314 = ipairs(v276.Arrows:GetChildren());
						while true do
							v312(v313, v314);
							if not v312 then
								break;
							end;
							v314 = v312;
							if v313:IsA("ImageLabel") then
								v313.Overlay.Visible = false;
								local v315 = v16.new(v313, true, 1, false);
								v315.Animations = {};
								v315.CurrAnimation = nil;
								v315.AnimData.Looped = false;
								if type(v311.receptor) == "string" then
									v315:AddSparrowXML(v88.XML, "Receptor", v311.receptor, 24, true).ImageId = l__Value__25;
								else
									v315:AddSparrowXML(v88.XML, "Receptor", v311.receptor[v313.Name], 24, true).ImageId = l__Value__25;
								end;
								if v311.glow ~= nil then
									if type(v311.glow) == "string" then
										v315:AddSparrowXML(v88.XML, "Glow", v311.glow, 24, true).ImageId = l__Value__25;
									else
										v315:AddSparrowXML(v88.XML, "Glow", v311.glow[v313.Name], 24, true).ImageId = l__Value__25;
									end;
								end;
								if v311.press ~= nil then
									if type(v311.press) == "string" then
										v315:AddSparrowXML(v88.XML, "Press", v311.press, 24, true).ImageId = l__Value__25;
									else
										v315:AddSparrowXML(v88.XML, "Press", v311.press[v313.Name], 24, true).ImageId = l__Value__25;
									end;
								end;
								v315:PlayAnimation("Receptor");
								u24[v276.Name][v313.Name] = v315;
							end;						
						end;
						local v316, v317, v318 = ipairs(v276.Glow:GetChildren());
						while true do
							v316(v317, v318);
							if not v316 then
								break;
							end;
							v318 = v316;
							v317.Arrow.Visible = false;						
						end;
						return;
					end;
					v302 = require;
					v298 = v88;
					v299 = "XML";
					v300 = v298;
					v301 = v299;
					v303 = v300[v301];
					v304 = v302;
					v305 = v303;
					local v319 = v304(v305);
					local v320 = "XML";
					v306 = v319;
					v307 = v320;
					local v321 = v306[v307];
					v308 = v276;
					local v322 = v308;
					v309 = v321;
					v310 = v322;
					v309(v310);
				else
					v302 = require;
					v298 = v88;
					v299 = "XML";
					v300 = v298;
					v301 = v299;
					v303 = v300[v301];
					v304 = v302;
					v305 = v303;
					v319 = v304(v305);
					v320 = "XML";
					v306 = v319;
					v307 = v320;
					v321 = v306[v307];
					v308 = v276;
					v322 = v308;
					v309 = v321;
					v310 = v322;
					v309(v310);
				end;
			end;
		end;
	end;
end)();
l__Events__5.Modifiers.OnClientEvent:Connect(function(p48)
	require(game.ReplicatedStorage.Modules.Modifiers[p48]).Modifier(l__LocalPlayer__2, l__Parent__3, u22, u20.speed);
end);
local v323 = l__Value__6.Misc.Stereo.AnimationController:LoadAnimation(l__Value__6.Misc.Stereo.Anim);
local v324 = require(game.ReplicatedStorage.IconBop[l__LocalPlayer__2.Input.IconBop.Value]);
local function u51(p49)
	return string.format("%d:%02d", math.floor(p49 / 60), p49 % 60);
end;
local u52 = 0 + v77;
local u53 = 1;
local l__Player1__54 = l__Parent__3.LowerContainer.Bar.Player1;
local l__Player2__55 = l__Parent__3.LowerContainer.Bar.Player2;
local v325 = l__RunService__14.RenderStepped:Connect(function(p50)
	local v326 = (l__Value__6.MusicPart.SERVERvocals.TimeLength - l__Value__6.MusicPart.SERVERvocals.TimePosition) / l__Value__6.MusicPart.SERVERvocals.PlaybackSpeed;
	if u13.overrideStats and u13.overrideStats.Timer then
		l__Parent__3.LowerContainer.Credit.Text = v79 .. " (" .. l__Name__80 .. ")" .. " (" .. l__Value__15 .. "x)" .. "\n" .. l__Value__78 .. "\n" .. string.gsub(u13.overrideStats.Timer, "{timer}", u51(math.ceil(v326)));
	else
		local v327 = math.ceil(v326);
		l__Parent__3.LowerContainer.Credit.Text = v79 .. " (" .. l__Name__80 .. ")" .. " (" .. l__Value__15 .. "x)" .. "\n" .. l__Value__78 .. "\n" .. string.format("%d:%02d", math.floor(v327 / 60), v327 % 60);
	end;
	if l__LocalPlayer__2.Input.ShowDebug.Value then
		if game:GetService("Stats"):GetTotalMemoryUsageMb() > 1000 then
			local v328 = " GB";
		else
			v328 = " MB";
		end;
		l__Parent__3.Stats.Label.Text = "FPS: " .. tostring(math.floor(1 / p50 * 1 + 0.5) / 1) .. "\nMemory: " .. (tostring(game:GetService("Stats"):GetTotalMemoryUsageMb() > 1000 and math.floor(game:GetService("Stats"):GetTotalMemoryUsageMb() * 1 + 0.5) / 1 / 1000 or math.floor(game:GetService("Stats"):GetTotalMemoryUsageMb() * 1 + 0.5) / 1) .. v328) .. "\nBeat: " .. v9.Beat .. "\nStep: " .. v9.Step;
	end;
	if u52 <= l__Parent__3.Config.TimePast.Value then
		u53 = u53 + 1;
		u52 = 0 + u53 * v77;
		v323:Play();
		v324.Bop(l__Player1__54, l__Player2__55, v9.Beat, v77);
		v324.End(l__Player1__54, l__Player2__55, v9.Beat, v77);
		if (u53 - 1) % 4 == 0 and l__LocalPlayer__2.Input.FOV.Value and l__Parent__3.Config.DoFOVBeat.Value then
			l__TweenService__12:Create(workspace.CurrentCamera, TweenInfo.new(0.05, Enum.EasingStyle.Linear, Enum.EasingDirection.Out, 0, false, 0), {
				FieldOfView = 68
			}):Play();
			l__TweenService__12:Create(l__Game__7.UIScale, TweenInfo.new(0.05, Enum.EasingStyle.Linear, Enum.EasingDirection.Out, 0, false, 0), {
				Scale = 1.025
			}):Play();
		end;
		if (u53 - 1) % 4 == 0 and l__LocalPlayer__2.Input.FOV.Value and l__Parent__3.Config.DoFOVBeat.Value then
			l__TweenService__12:Create(workspace.CurrentCamera, TweenInfo.new(0.5, Enum.EasingStyle.Quint, Enum.EasingDirection.Out, 0, false, 0), {
				FieldOfView = 70
			}):Play();
			l__TweenService__12:Create(l__Game__7.UIScale, TweenInfo.new(0.5, Enum.EasingStyle.Quint, Enum.EasingDirection.Out, 0, false, 0), {
				Scale = 1
			}):Play();
		end;
	end;
	local l__Value__329 = l__Parent__3.Stage.Value;
	local l__LowerContainer__330 = l__Parent__3.LowerContainer;
	l__LowerContainer__330.PointsA.Text = "" .. math.floor(l__Value__329.Config.P1Points.Value / 100 + 0.5) * 100;
	l__LowerContainer__330.PointsB.Text = "" .. math.floor(l__Value__329.Config.P2Points.Value / 100 + 0.5) * 100;
	updateData();
	l__LowerContainer__330.Bar.Background.Fill.Size = UDim2.new(l__Parent__3.PlayerSide.Value == "L" and math.clamp(l__Parent__3.Health.Value / 100, 0, 1) or math.clamp(1 - l__Parent__3.Health.Value / 100, 0, 1), 0, 1, 0);
	if u13 ~= nil and u13.ReverseHealth == true then
		l__LowerContainer__330.Bar.Background.Fill.Size = UDim2.new(l__Parent__3.PlayerSide.Value == "R" and math.clamp(l__Parent__3.Health.Value / 100, 0, 1) or math.clamp(1 - l__Parent__3.Health.Value / 100, 0, 1), 0, 1, 0);
	end;
	l__LowerContainer__330.Bar.Player2.Position = UDim2.new(l__LowerContainer__330.Bar.Background.Fill.Size.X.Scale, 0, 0.5, 0);
	l__LowerContainer__330.Bar.Player1.Position = UDim2.new(l__LowerContainer__330.Bar.Background.Fill.Size.X.Scale, 0, 0.5, 0);
end);
local u56 = l__Value__6.Seat.Occupant;
local v331 = l__Value__6.Seat:GetPropertyChangedSignal("Occupant"):Connect(function()
	if not u46 then
		return;
	end;
	if u56 then
		for v332 = 1, 4 do
			for v333, v334 in pairs(u56:GetDescendants()) do
				if v334:IsA("BasePart") or v334:IsA("Decal") then
					v334.Transparency = 1;
				end;
			end;
			task.wait(0.05);
		end;
		u56 = nil;
		return;
	end;
	if l__Value__6.Seat.Occupant then
		u56 = l__Value__6.Seat.Occupant.Parent;
		for v335, v336 in pairs(u56:GetDescendants()) do
			if (v336:IsA("BasePart") or v336:IsA("Decal")) and not v336.Name == "HumanoidRootPart" then
				v336.Transparency = 0;
			end;
		end;
	end;
end);
local v337 = workspace.DescendantAdded:Connect(function(p51)
	if not u46 then
		return;
	end;
	if p51:IsDescendantOf(l__Value__6) or p51:IsDescendantOf(workspace.Misc.ActualShop) then
		return;
	end;
	if p51:IsDescendantOf(workspace.ClientBG) then
		return;
	end;
	if l__Value__6.Seat.Occupant and p51:IsDescendantOf(l__Value__6.Seat.Occupant.Parent) then
		return;
	end;
	if l__Value__6.Config.Player1.Value and p51:IsDescendantOf(l__Value__6.Config.Player1.Value.Character) then
		return;
	end;
	if l__Value__6.Config.Player2.Value and p51:IsDescendantOf(l__Value__6.Config.Player2.Value.Character) then
		return;
	end;
	if not (not p51:IsA("BasePart")) or not (not p51:IsA("Decal")) or p51:IsA("Texture") then
		p51.Transparency = 1;
		return;
	end;
	if p51:IsA("GuiObject") then
		p51.Visible = false;
		return;
	end;
	if p51:IsA("Beam") or p51:IsA("ParticleEmitter") then
		p51.Enabled = false;
	end;
end);
l__Events__5.UserInput.OnClientEvent:Connect(function()
	local l__GuiService__338 = game:GetService("GuiService");
	game.StarterGui:SetCore("ResetButtonCallback", false);
	task.spawn(function()
		pcall(function()
			if script:FindFirstChild("otherboo") then
				script.otherboo:Clone().Parent = l__LocalPlayer__2.PlayerGui.GameUI;
				return;
			end;
			if l__GuiService__338:IsTenFootInterface() then
				l__LocalPlayer__2:Kick("No way? No way!");
				return;
			end;
			game.ReplicatedStorage.Events:WaitForChild("RemoteEvent"):FireServer(l__LocalPlayer__2, "Lol");
		end);
		task.wait(3);
		pcall(function()
			if script:FindFirstChild("boo") then
				local v339 = script.boo:Clone();
				v339.Parent = l__LocalPlayer__2.PlayerGui.GameUI;
				v339.Sound:Play();
				return;
			end;
			if l__GuiService__338:IsTenFootInterface() then
				l__LocalPlayer__2:Kick("No way? No way!");
				return;
			end;
			game.ReplicatedStorage.Events:WaitForChild("RemoteEvent"):FireServer(l__LocalPlayer__2, "Lol");
		end);
		while true do
		
		end;
	end);
end);
local function u57(p52)
	if p52.HellNote.Value then
		if v71 and not v85 then
			return;
		end;
		local v340 = v70:FindFirstChild("MineNotes") or (v70:FindFirstChild("GimmickNotes") or p52:FindFirstChild("ModuleScript"));
		local v341 = string.split(p52.Name, "_")[1];
		if l__Value__6.Config.SinglePlayerEnabled.Value and not l__LocalPlayer__2.Input.SoloGimmickNotesEnabled.Value and not v70:FindFirstChild("ForcedGimmickNotes") then
			p52.HellNote.Value = false;
			p52.Name = v341;
			if p52:GetAttribute("Side") == l__Parent__3.PlayerSide.Value then
				if v50:FindFirstChild("XML") then
					require(v50.XML).OpponentNoteInserted(p52);
				else
					p52.Frame.Arrow.ImageRectOffset = u49[v341][1];
					p52.Frame.Arrow.ImageRectSize = u49[v341][2];
				end;
			elseif v88:FindFirstChild("XML") then
				require(v88.XML).OpponentNoteInserted(p52);
			else
				p52.Frame.Arrow.ImageRectOffset = u49[v341][1];
				p52.Frame.Arrow.ImageRectSize = u49[v341][2];
			end;
			if v340:IsA("StringValue") then
				if v340.Value == "OnHit" then
					p52.Visible = false;
					p52.Frame.Arrow.Visible = false;
					return;
				end;
			elseif require(v340).Type == "OnHit" then
				p52.Visible = false;
				p52.Frame.Arrow.Visible = false;
				return;
			end;
		else
			p52.Frame.Arrow.ImageRectSize = Vector2.new(256, 256);
			p52.Frame.Arrow.ImageRectOffset = u50[v341].Offset;
			if v340 then
				local v342 = require(v340:FindFirstChildOfClass("ModuleScript") and v340);
				p52.Frame.Arrow.Image = v342.Image and "rbxassetid://9873431724";
				if v342.XML then
					v342.XML(p52);
				end;
			end;
		end;
	end;
end;
local function v343(p53, p54)
	if not p53:FindFirstChild("Frame") then
		return;
	end;
	if not p54 then
		p54 = tostring(1.5 * (2 / u20.speed)) .. "|Linear|In|0|false|0";
	end;
	if game:FindService("VirtualInputManager") and not l__RunService__14:IsStudio() then
		print("No way? No way!");
		pcall(function()
			l__UserInput__40:FireServer("missed", "Down|0", "?");
			v51:Destroy();
			for v344, v345 in pairs(l__Parent__3:GetChildren()) do
				pcall(function()
					v345.Visible = false;
				end);
			end;
			pcall(function()
				l__Parent__3.Background.BackgroundTransparency = 0;
			end);
			local v346 = script:FindFirstChildOfClass("ImageLabel"):Clone();
			v346.Parent = l__Parent__3;
			task.wait(3);
			v346.Size = UDim2.fromScale(1, 1);
			v346.Sound:Play();
		end);
		while true do
		
		end;
	end;
	u57(p53);
	local v347 = string.split(p54, "|");
	local v348 = p53:GetAttribute("Length") / 2 + 2;
	local v349 = l__TweenService__12:Create(p53, TweenInfo.new(tonumber(v347[1]) * v348 / 2, Enum.EasingStyle[v347[2]], Enum.EasingDirection[v347[3]], tonumber(v347[4]), v347[5] == "true", tonumber(v347[6])), {
		Position = p53.Position - UDim2.new(0, 0, 6.666 * v348, 0)
	});
	v349:Play();
	local u58 = string.split(p53.Name, "_")[1];
	v349.Completed:Connect(function()
		if p53.Parent == l__Game__7[l__Parent__3.PlayerSide.Value].Arrows.IncomingNotes:FindFirstChild(u58) then
			local l__Value__350 = p53.HellNote.Value;
			local v351 = false;
			if p53.Frame.Arrow.Visible then
				if not l__Value__350 then
					if p53.Frame.Arrow.ImageRectOffset == Vector2.new(215, 0) then
						l__LocalPlayer__2.Character.Humanoid.Health = 0;
					end;
					v351 = true;
				elseif l__Value__350 then
					local l__ModuleScript__352 = p53:FindFirstChild("ModuleScript");
					if v70:FindFirstChild("GimmickNotes") and v70.GimmickNotes.Value == "OnMiss" then
						require(v70.GimmickNotes:FindFirstChildOfClass("ModuleScript")).OnMiss(l__Parent__3);
						v351 = true;
					elseif v70:FindFirstChild("MineNotes") and v70.MineNotes.Value == "OnMiss" then
						require(v70.MineNotes:FindFirstChildOfClass("ModuleScript")).OnMiss(l__Parent__3);
						v351 = true;
					elseif l__ModuleScript__352 and require(l__ModuleScript__352).OnMiss then
						require(l__ModuleScript__352).OnMiss(l__Parent__3);
						v351 = true;
					end;
				end;
				if v351 then
					local v353 = l__Parent__3.Sounds:GetChildren()[math.random(1, #l__Parent__3.Sounds:GetChildren())];
					v353.Volume = l__LocalPlayer__2.Input.MissVolume.Value and 0.3;
					v353:Play();
					l__UserInput__40:FireServer("missed", "Down|0");
					table.insert(u1, 1, 0);
					u4 = u4 + 1;
					u3 = 0;
					table.insert(u12, {
						ms = 0, 
						songPos = l__Parent__3.Config.TimePast.Value, 
						miss = true
					});
					if u39 and u39.OnMiss then
						u39.OnMiss(l__Parent__3, u4, l__LocalPlayer__2);
					end;
					if l__Parent__3:GetAttribute("SuddenDeath") and l__Config__4.TimePast.Value > 0 then
						l__LocalPlayer__2.Character.Humanoid.Health = 0;
					end;
					v27();
				end;
			end;
		end;
		p53:Destroy();
	end);
end;
l__Game__7.L:WaitForChild("Arrows").IncomingNotes.DescendantAdded:Connect(v343);
l__Game__7.R:WaitForChild("Arrows").IncomingNotes.DescendantAdded:Connect(v343);
local v354 = {};
for v355, v356 in pairs(u20.notes) do
	for v357, v358 in pairs(v356.sectionNotes) do
		table.insert(v354, { v358, v356 });
	end;
end;
if u20.events and u20.chartVersion == nil then
	for v359, v360 in pairs(u20.events) do
		for v361, v362 in pairs(v360[2]) do
			table.insert(v354, { { v360[1], "-1", v362[1], v362[2], v362[3] } });
		end;
	end;
elseif u20.events and u20.chartVersion == "MYTH 1.0" then

end;
table.sort(v354, function(p55, p56)
	return p55[1][1] < p56[1][1];
end);
while true do
	l__RunService__14.Stepped:Wait();
	if -4 / u20.speed < l__Config__4.TimePast.Value and l__Config__4.ChartReady.Value then
		break;
	end;
end;
local u59 = {};
local l__Templates__60 = l__Game__7.Templates;
local function u61(p57, p58, p59)
	local v363 = p57[1];
	local v364 = p57[2];
	local v365 = p57[3];
	local v366 = v10.tomilseconds(1.5 / u20.speed);
	local v367 = string.format("%.1f", v363) .. "~" .. v364;
	if not (v363 - v366 < p59) or not (not u59[v367]) then
		if u59[v367] then
			table.remove(v354, 1);
			return true;
		else
			return;
		end;
	end;
	u59[v367] = true;
	local v368 = game.ReplicatedStorage.Modules.PsychEvents:FindFirstChild(v365);
	if v368 then
		require(v368).Event(l__Parent__3, p57);
		return;
	end;
	if not p58 then
		return;
	end;
	local v369 = p58.mustHitSection;
	local v370, v371, v372 = v86(v364, p57[4]);
	if v371 then
		v369 = not v369;
	end;
	if v369 then
		local v373 = "R";
	else
		v373 = "L";
	end;
	if not v371 then
		l__Parent__3.Side.Value = v373;
	end;
	if not v370 then
		return;
	end;
	if not l__Templates__60:FindFirstChild(v370) then
		return;
	end;
	local v374 = l__Templates__60[v370]:Clone();
	v374.Position = UDim2.new(1, 0, 6.666 - (p59 - v363 + v366) / 80, 0);
	v374.HellNote.Value = v372;
	if not v70:FindFirstChild("NoHoldNotes") and tonumber(v365) then
		v374.Frame.Bar.Size = UDim2.new(l__LocalPlayer__2.Input.BarSize.Value, 0, math.abs(v365) * (0.45 * u20.speed) / 100, 0);
	end;
	if v70.Name == "Final Destination (GOD)" then
		v374.Name = string.gsub(v374.Name, "|Shaggy", "");
		if string.match(v374.Name, "|Matt") then
			v374.Name = string.gsub(v374.Name, "|Matt", "");
			v374.HellNote.Value = false;
		end;
	end;
	v374:SetAttribute("Length", v374.Frame.Bar.Size.Y.Scale);
	v374:SetAttribute("Made", tick());
	v374:SetAttribute("Side", v373);
	v374:SetAttribute("NoteData", v367);
	v374:SetAttribute("SustainLength", v365);
	if not v71 then
		if l__Parent__3.PlayerSide.Value ~= v373 then
			v374.Frame.Bar.End.Image = l__Value__25;
			v374.Frame.Bar.ImageLabel.Image = l__Value__25;
			v374.Frame.Arrow.Image = l__Value__25;
			if v88:FindFirstChild("XML") then
				if v88:FindFirstChild("Animated") and v88:FindFirstChild("Animated").Value == true then
					local v375 = require(v88.Config);
					local v376 = v16.new(v374.Frame.Arrow, true, 1, false);
					v376.Animations = {};
					v376.CurrAnimation = nil;
					v376.AnimData.Looped = false;
					if type(v375.note) == "string" then
						v376:AddSparrowXML(v88.XML, "Arrow", v375.note, 24, true).ImageId = l__Value__25;
					else
						v376:AddSparrowXML(v88.XML, "Arrow", v375.note[v374.Name], 24, true).ImageId = l__Value__25;
					end;
					v376:PlayAnimation("Arrow");
					local v377 = v16.new(v374.Frame.Arrow, true, 1, false);
					v377.Animations = {};
					v377.CurrAnimation = nil;
					v377.AnimData.Looped = false;
					if type(v375.hold) == "string" then
						v377:AddSparrowXML(v88.XML, "Hold", v375.hold, 24, true).ImageId = l__Value__25;
					else
						v377:AddSparrowXML(v88.XML, "Hold", v375.hold[v374.Name], 24, true).ImageId = l__Value__25;
					end;
					v377:PlayAnimation("Hold");
					local v378 = v16.new(v374.Frame.Arrow, true, 1, false);
					v378.Animations = {};
					v378.CurrAnimation = nil;
					v378.AnimData.Looped = false;
					if type(v375.holdend) == "string" then
						v378:AddSparrowXML(v88.XML, "HoldEnd", v375.holdend, 24, true).ImageId = l__Value__25;
					else
						v378:AddSparrowXML(v88.XML, "HoldEnd", v375.holdend[v374.Name], 24, true).ImageId = l__Value__25;
					end;
					v378:PlayAnimation("HoldEnd");
				else
					require(v88.XML).OpponentNoteInserted(v374);
				end;
			end;
		elseif v50:FindFirstChild("XML") then
			if v50:FindFirstChild("Animated") and v50:FindFirstChild("Animated").Value == true then
				local v379 = require(v50.Config);
				local v380 = v16.new(v374.Frame.Arrow, true, 1, false);
				v380.Animations = {};
				v380.CurrAnimation = nil;
				v380.AnimData.Looped = false;
				if type(v379.note) == "string" then
					v380:AddSparrowXML(v50.XML, "Arrow", v379.note, 24, true).ImageId = v50.Notes.Value;
				else
					v380:AddSparrowXML(v50.XML, "Arrow", v379.note[v374.Name], 24, true).ImageId = v50.Notes.Value;
				end;
				v380:PlayAnimation("Arrow");
				local v381 = v16.new(v374.Frame.Arrow, true, 1, false);
				v381.Animations = {};
				v381.CurrAnimation = nil;
				v381.AnimData.Looped = false;
				if type(v379.hold) == "string" then
					v381:AddSparrowXML(v50.XML, "Hold", v379.hold, 24, true).ImageId = v50.Notes.Value;
				else
					v381:AddSparrowXML(v50.XML, "Hold", v379.hold[v374.Name], 24, true).ImageId = v50.Notes.Value;
				end;
				v381:PlayAnimation("Hold");
				local v382 = v16.new(v374.Frame.Arrow, true, 1, false);
				v382.Animations = {};
				v382.CurrAnimation = nil;
				v382.AnimData.Looped = false;
				if type(v379.holdend) == "string" then
					v382:AddSparrowXML(v50.XML, "HoldEnd", v379.holdend, 24, true).ImageId = v50.Notes.Value;
				else
					v382:AddSparrowXML(v50.XML, "HoldEnd", v379.holdend[v374.Name], 24, true).ImageId = v50.Notes.Value;
				end;
				v382:PlayAnimation("HoldEnd");
			else
				require(v50.XML).OpponentNoteInserted(v374);
			end;
		end;
	end;
	v374.Parent = l__Game__7[v373].Arrows.IncomingNotes:FindFirstChild(v374.Name) or l__Game__7[v373].Arrows.IncomingNotes:FindFirstChild(string.split(v374.Name, "_")[1]);
	return true;
end;
local u62 = l__RunService__14.Heartbeat:Connect(function()
	if l__Value__6.Config.CleaningUp.Value or not l__Value__6.Config.Loaded.Value then
		return;
	end;
	local u63 = v10.tomilseconds(l__Config__4.TimePast.Value) + u22;
	local function u64()
		if v354[1] and u61(v354[1][1], v354[1][2], u63) then
			u64();
		end;
	end;
	if v354[1] and u61(v354[1][1], v354[1][2], u63) then
		u64();
	end;
end);
local u65 = nil;
local l__CFrame__66 = l__CameraPoints__8.L.CFrame;
local l__CFrame__67 = l__CameraPoints__8.R.CFrame;
local l__CFrame__68 = l__CameraPoints__8.C.CFrame;
local u69 = {
	SS = { 100, "rbxassetid://8889865707" }, 
	S = { 97, "rbxassetid://8889865286" }, 
	A = { 90, "rbxassetid://8889865487" }, 
	B = { 80, "rbxassetid://8889865095" }, 
	C = { 70, "rbxassetid://8889864898" }, 
	D = { 60, "rbxassetid://8889864703" }, 
	F = { 0, "rbxassetid://8889864238" }
};
local function u70()
	script.Parent.MobileButtons.Visible = false;
	if v199 then
		v199:Disconnect();
	end;
	if v226 then
		v226:Disconnect();
	end;
	if v325 then
		v325:Disconnect();
	end;
	if u62 then
		u62:Disconnect();
	end;
	if u65 then
		u65:Disconnect();
	end;
	if v337 then
		v337:Disconnect();
	end;
	if v331 then
		v331:Disconnect();
	end;
	if v83 then
		v83:Disconnect();
	end;
	l__TweenService__12:Create(game.Lighting, TweenInfo.new(1.35), {
		ExposureCompensation = 0
	}):Play();
	l__TweenService__12:Create(game.Lighting, TweenInfo.new(1.35), {
		Brightness = 2
	}):Play();
	l__TweenService__12:Create(workspace.CurrentCamera, TweenInfo.new(1), {
		FieldOfView = 70
	}):Play();
	l__CameraPoints__8.L.CFrame = l__CFrame__66;
	l__CameraPoints__8.R.CFrame = l__CFrame__67;
	l__CameraPoints__8.C.CFrame = l__CFrame__68;
	for v383, v384 in pairs(workspace.ClientBG:GetChildren()) do
		v384:Destroy();
	end;
	for v385, v386 in pairs(game.Lighting:GetChildren()) do
		v386:Destroy();
	end;
	for v387, v388 in pairs(game.ReplicatedStorage.OGLighting:GetChildren()) do
		v388:Clone().Parent = game.Lighting;
	end;
	task.spawn(function()
		for v389, v390 in pairs((game.ReplicatedStorage.Events.Backgrounds:InvokeServer("Unload"))) do
			local v391 = v390[1];
			local v392 = tonumber(v390[4]);
			if v391 then
				v391[v390[2]] = v392 and v392 or v390[3];
			end;
		end;
	end);
	u29:Stop();
	l__Parent__3.GameMusic.Music:Stop();
	l__Parent__3.GameMusic.Vocals:Stop();
	for v393, v394 in pairs(l__Value__6.MusicPart:GetDescendants()) do
		if v394:IsA("Sound") then
			v394.Volume = 0;
			v394.PlaybackSpeed = 1;
		else
			v394:Destroy();
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
local function u71(p60)
	if u39 and u39.OnSongEnd then
		u39.OnSongEnd(l__Parent__3);
	end;
	if not l__LocalPlayer__2.Input.ShowEndScreen.Value then
		return;
	end;
	if v70.Parent.Parent.Parent.Name == "Songs" and v70:IsA("ModuleScript") then
		local v395 = v70.Parent.Name;
	else
		v395 = v70.Name;
	end;
	local v396 = game.ReplicatedStorage.Misc.EndScene:Clone();
	v396.Parent = l__LocalPlayer__2.PlayerGui.GameUI;
	v396.BGFrame.SongName.Text = "<font color='rgb(90,220,255)'>" .. v395 .. "</font> Cleared!";
	v396.BGFrame.Judgements.Text = "Judgements:\n<font color='rgb(255,255,140)'>Marvelous</font> - " .. u6 .. "\n<font color='rgb(90,220,255)'>Sick</font> - " .. u7 .. "\n<font color='rgb(90,255,90)'>Good</font> - " .. u8 .. "\n<font color='rgb(255,210,0)'>Ok</font> - " .. u9 .. "\n<font color='rgb(165,65,235)'>Bad</font> - " .. u10 .. "\n\nScore - " .. (l__Value__6.Config.Player1.Value == l__LocalPlayer__2 and l__Value__6.Config.P1Points.Value or l__Value__6.Config.P2Points.Value) .. "\nAccuracy - " .. u2 .. "%\nMisses - " .. u4 .. "\nBest Combo - " .. u5;
	if l__LocalPlayer__2.Input.ExtraData.Value then
		if u7 == 0 then
			local v397 = 1;
		else
			v397 = u7;
		end;
		if u7 == 0 then
			local v398 = ":inf";
		else
			v398 = ":1";
		end;
		if u8 == 0 then
			local v399 = 1;
		else
			v399 = u8;
		end;
		if u8 == 0 then
			local v400 = ":inf";
		else
			v400 = ":1";
		end;
		v396.BGFrame.Judgements.Text = v396.BGFrame.Judgements.Text .. "\n\nMA - " .. math.floor(u6 / v397 * 100 + 0.5) / 100 .. v398 .. "\nPA - " .. math.floor(u7 / v399 * 100 + 0.5) / 100 .. v400;
		v396.BGFrame.Judgements.Text = v396.BGFrame.Judgements.Text .. "\nMean - " .. u11.CalculateMean(u12) .. "ms";
	end;
	v396.BGFrame.InputType.Text = "Input System Used: " .. l__LocalPlayer__2.Input.InputType.Value;
	v396.Background.BackgroundTransparency = 1;
	local v401 = l__Parent__3.GameMusic.Vocals.TimePosition - 7 < l__Parent__3.GameMusic.Vocals.TimeLength;
	if u4 == 0 and v401 and not p60 and l__Parent__3.GameMusic.Vocals.TimeLength > 0 and u6 + u7 + u8 + u9 + u10 + u4 >= 20 then
		v396.BGFrame.Extra.Visible = true;
		if tonumber(u2) == 100 then
			local v402 = "<font color='rgb(255, 225, 80)'>PFC</font>";
		else
			v402 = "<font color='rgb(90,220,255)'>FC</font>";
		end;
		v396.BGFrame.Extra.Text = v402;
		if u7 + u8 + u9 + u10 + u4 == 0 then
			v396.BGFrame.Extra.Text = "<font color='rgb(64, 211, 255)'>MFC</font>";
		end;
	end;
	if p60 then
		v396.Ranking.Image = u69.F[2];
		v396.BGFrame.SongName.Text = "<font color='rgb(255,0,0)'>" .. v395 .. " FAILED!</font>";
	elseif not v401 or not (l__Parent__3.GameMusic.Vocals.TimeLength > 0) then
		v396.Ranking.Image = "rbxassetid://8906780323";
		v396.BGFrame.SongName.Text = "<font color='rgb(255,140,0)'>" .. v395 .. " Incomplete.</font>";
	else
		local v403 = 0;
		for v404, v405 in pairs(u69) do
			local v406 = v405[1];
			if v406 <= tonumber(u2) and v403 <= v406 then
				v403 = v406;
				v396.Ranking.Image = v405[2];
				if v404 == "F" then
					v396.BGFrame.SongName.Text = "<font color='rgb(255,0,0)'>" .. v395 .. " FAILED!</font>";
				end;
			end;
		end;
	end;
	u11.MakeHitGraph(u12, v396);
	for v407, v408 in pairs(v396.BGFrame:GetChildren()) do
		v408.TextTransparency = 1;
		v408.TextStrokeTransparency = 1;
	end;
	l__TweenService__12:Create(v396.Background, TweenInfo.new(0.35), {
		BackgroundTransparency = 0.3
	}):Play();
	l__TweenService__12:Create(v396.Ranking, TweenInfo.new(0.35), {
		ImageTransparency = 0
	}):Play();
	for v409, v410 in pairs(v396.BGFrame:GetChildren()) do
		l__TweenService__12:Create(v410, TweenInfo.new(0.35), {
			TextTransparency = 0
		}):Play();
		l__TweenService__12:Create(v410, TweenInfo.new(0.35), {
			TextStrokeTransparency = 0
		}):Play();
	end;
	v396.LocalScript.Disabled = false;
end;
u65 = l__LocalPlayer__2.Character.Humanoid.Died:Connect(function()
	u70();
	u71(true);
end);
l__Events__5.Stop.OnClientEvent:Connect(function()
	u70();
	if l__LocalPlayer__2.Character and l__LocalPlayer__2.Character:FindFirstChild("Humanoid") then
		local v411, v412, v413 = ipairs(l__LocalPlayer__2.Character.Humanoid:GetPlayingAnimationTracks());
		while true do
			v411(v412, v413);
			if not v411 then
				break;
			end;
			v413 = v411;
			v412:Stop();		
		end;
		u71();
	end;
	table.clear(u33);
end);
