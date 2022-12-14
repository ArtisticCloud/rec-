local player = game.Players.LocalPlayer;
local character = player.Character;
local humrp = character:WaitForChild('HumanoidRootPart');
local humanoid = character:WaitForChild('Humanoid');

local playergui = player:WaitForChild('PlayerGui');

if playergui:FindFirstChild('MainGui') then
    playergui.MainGui:Destroy();
end;

--services
local rs = game:GetService('ReplicatedStorage');
local runservice = game:GetService('RunService');
local uis = game:GetService('UserInputService');
local tween = game:GetService('TweenService');

--gui vars
local toggle = Instance.new('BoolValue');

local MainGui = Instance.new('ScreenGui');
MainGui.Name = 'MainGui';
MainGui.Parent = playergui;

--useful ui functions and variables
local final_guiposition = UDim2.fromScale(0.91,0.515);

function uicorner(str,parentframe)
    local uicorner = Instance.new('UICorner');
    uicorner.CornerRadius = UDim.new(str,0)
    uicorner.Parent = parentframe;
    return uicorner;
end;

local backframe = Instance.new('Frame');
backframe.Position = final_guiposition;
backframe.Size = UDim2.fromScale(0.171,0.468);
backframe.BackgroundTransparency = 0.05;
backframe.BackgroundColor3 = Color3.fromRGB(30,30,30);
backframe.AnchorPoint = Vector2.new(0.5,0.5)
backframe.Parent = MainGui

local aspectratio = Instance.new('UIAspectRatioConstraint');
aspectratio.AspectRatio = 0.775;
aspectratio.Parent = backframe;

uicorner(0.03,backframe);

local title = Instance.new('TextLabel');
title.BackgroundTransparency = 1;
title.TextScaled = true;
title.RichText = true;
title.Text = '<i>Rec. Boosting</i>'
title.Font = Enum.Font.GothamBold;
title.TextXAlignment = Enum.TextXAlignment.Left;
title.TextColor3 = Color3.fromRGB(255,255,255);
title.Position = UDim2.fromScale(0,-0.102);
title.Size = UDim2.fromScale(1,0.102);

title.Parent = backframe;

local mainframe = Instance.new('ScrollingFrame');
mainframe.BackgroundTransparency = 1;
mainframe.ScrollBarThickness = 0;
mainframe.AutomaticCanvasSize = Enum.AutomaticSize.Y;
mainframe.Size = UDim2.fromScale(0.929 ,0.938);
mainframe.Position = UDim2.fromScale(0.038,0.04);

mainframe.Parent = backframe;

local listlayout = Instance.new('UIListLayout');
listlayout.Padding = UDim.new(0.06,0);
listlayout.SortOrder = Enum.SortOrder.LayoutOrder;
listlayout.Parent = mainframe;

local onballtext = title:Clone();
onballtext.Text = '<i>On-Ball</i>';
onballtext.Size = onballtext.Size + UDim2.new(0,0.05)
onballtext.LayoutOrder = -20;

onballtext.Parent = mainframe;

local offballtext = onballtext:Clone();
offballtext.Text = '<i>Off-Ball</i>';
offballtext.Size = offballtext.Size + UDim2.new(0,0.05)
offballtext.LayoutOrder = -5;

offballtext.Parent = mainframe;

local togglebutton = Instance.new('TextButton');
togglebutton.Position = UDim2.fromScale(0,1.02);
togglebutton.Size = UDim2.fromScale(1,0.07);

togglebutton.BackgroundColor3 = Color3.fromRGB(70,235,0);
togglebutton.TextScaled = true;
togglebutton.RichText = true;
togglebutton.Font = Enum.Font.GothamBold;
togglebutton.Text = '<i>Open Gui</i>';

togglebutton.Parent = backframe;
uicorner(0.2,togglebutton);

local uiopen = false;
togglebutton.MouseButton1Down:Connect(function()
    if not uiopen then
        
    end;
end);

function add_button(Type,text)
    local button = Instance.new('TextButton');
    button.BackgroundColor3 = backframe.BackgroundColor3;  
    button.RichText = true;
    button.Text = '<i>'..text..'</i>';
    button.Name = text;
    button.TextColor3 = Color3.fromRGB(255,255,255);
    button.Font = Enum.Font.GothamBold;
    button.TextXAlignment = Enum.TextXAlignment.Left;
    button.Position = UDim2.fromScale(0,0);
    button.Size = UDim2.fromScale(1,0.13);
    button.TextScaled = true;
    button.BorderSizePixel = 3.5;
    button.BorderColor3 = Color3.new(255,255,255)

    button.LayoutOrder = (Type == 'OffBall' and 0) or (-10);
    button.Parent = mainframe;

    return button;
end;

--values for the current option
local shooting = false;

_G.OnBall = Instance.new('StringValue');
_G.OffBall = Instance.new('StringValue');

--useful functions
function get_ball()
    local ballweld = character:FindFirstChild('ball.weld');
    return ballweld and ballweld.Part1;
end;

function shoot(value)
    rs.GameEvents.ClientAction:FireServer('Shoot',value);
end;

function sprint(value)
    rs.GameEvents.ClientAction('Sprint',value);
end;

local moving = false;
function move_humanoid(position,duration)
    local reached;
    
    while (not reached) do
        humanoid:MoveTo(position);
        local distance = (humrp.Position - position).Magnitude;
        reached = distance < 0.5;
    end;
end;

local moving = false;
function move_humanoid(destination)
    local finished = false;
    while not finished do
        humanoid:MoveTo(destination);
        local distance = (humrp.Position - destination).Magnitude;
        print(distance);
    end
end
--actions
local Pos = nil
_G.OnBallActions = {
    Values = {
        PassTo = nil;
        Position = nil;
    };
    ['Auto Shoot'] = function()
        local pos = humrp.Position;
        shoot(true);
        shooting = true;
        task.wait(1.5)
        humanoid:MoveTo(Pos);
    end;

    ['Auto Acro'] = function()
        local oldposition = humrp.Position;
        while (_G.OnBall.Value == 'Auto Acro') do
            humanoid:MoveTo( Vector3.new(humrp.Position.X+5.5 , humrp.Position.Y , humrp.Position.Z) );
            task.wait(0.1);
            shoot(true);
            sprint(true);
            
            task.delay(0.2,function()
                shoot(false);
            end);
            task.wait(0.7);
            sprint(false);
            task.wait(1)
            --start doing the acro
            shoot(true)
            shooting = true;

            sprint(true)
            task.wait(0.3)
            sprint(false)
        end;
    end;

    ['Auto Off-Dribble'] = function()
        humanoid:MoveTo( Vector3.new(humrp.Position.X+20 , humrp.Position.Y , humrp.Position.Z) );
        task.wait(0.4)
        print('shooting')
        shoot(true)
        shooting = true;
        
        task.wait(1.5);
        humanoid:MoveTo(Pos)
    end;

    ['Auto Pass'] = function()
        rs.GameEvents.ClientAction('Pass',_G.OnBallActions.Values.PassTo);
    end;

    ['Auto Floater'] = function()
        humanoid:MoveTo( Vector3.new(humrp.Position.X+5.5 , humrp.Position.Y , humrp.Position.Z) );
        task.wait(0.2)
        print('shooting')
        shoot(true)
        shooting = true;
        
        task.wait(1.5);
        humanoid:MoveTo(Pos)
    end;
}

_G.OffBallActions = {
    Values = {
        StealTarget = 'RinBigPapi';
        ReboundPosition = humrp.Position
    };
    ['Rebounding'] = function()
        while _G.OffBall.Value == 'Rebounding' do
            task.wait(0.05);
            local ball = workspace:FindFirstChild('Basketball');
            local inbbound = game.Workspace:FindFirstChild('_Inbound',true)
            print(inbound)
            if inbound and inbound:FindFirstChild('TouchInterest') then
                humanoid:MoveTo(inbbound.Position)
            end
            if ball and not get_ball() then
                local distance = (humrp.Position - ball.Position).Magnitude;
                if distance < 30 then
                    local final_destination = ball.Position + ball.Velocity/2;
                    humanoid:MoveTo(final_destination);
                else
                    humanoid:MoveTo(Values.ReboundPosition)
                end;
            end;
        end;
    end;
    ['Auto Steal'] = function()
        while _G.OffBall.Value == 'Auto Steal' do
            task.wait(0.05);
            local target = game.Players[_G.OffBallActions.Values.StealTarget];
            if target then
                target = target.Character.HumanoidRootPart
                if not get_ball() then
                    humanoid:MoveTo(target.Position + Vector3.new(0,0,3));
                end;
            end;
        end;
    end;
}




-- _G.OnBall.Changed:Connect(function(value)
--     print('new Value:' , value);
--     if mainframe:FindFirstChild(value,true) then
--         print(mainframe:FindFirstChild(value,true));
--     end;
-- end)



function handle_buttons(button,Type)
    _G[Type].Value = (_G[Type].Value ~= '' and button.Name == _G[Type].Value and '') or (button.Name);

    for _,buttons in pairs(mainframe:GetDescendants()) do
        if buttons.ClassName == 'TextButton' and _G[Type..'Actions'][buttons.Name] then
            buttons.BorderColor3 = Color3.fromRGB(255,255,255);
        end;
    end;

    if _G[Type].Value ~= '' then
        button.BorderColor3 = Color3.fromRGB(0,255,0);
    end;
end;

for name,action in pairs(_G.OnBallActions) do
  if name == 'Values' then
    continue;
  end;
  local button = add_button('OnBall',name);
  button.MouseButton1Down:Connect(function()
    handle_buttons(button,'OnBall');
    Pos = humrp.Position
    _G.OnBallActions.Values.Position = humrp.Position;
  end);
end;

for name,action in pairs(_G.OffBallActions) do
    if name == 'Values' then
        continue;
    end;
    local button = add_button('OffBall',name);
    button.MouseButton1Down:Connect(function()
        handle_buttons(button,'OffBall');
        _G.OffBallActions.Values.ReboundPosition = humrp.Position
    end);
end;

--detect when user receives the ball
character.ChildAdded:Connect(function(child)
    if child.Name == 'ball.weld' then
        onball_command = _G.OnBallActions[_G.OnBall.Value];
        if onball_command then
            onball_command();
        end;
    end;
end);

while true do
    task.wait(0.05);
    if not get_ball() then
        local offball_command = _G.OffBallActions[_G.OffBall.Value];
        if offball_command then
            offball_command()
        end;
    end;
end;
