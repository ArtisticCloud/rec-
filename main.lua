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

--create gui
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
listlayout.Padding = UDim.new(0.04,0);
listlayout.SortOrder = Enum.SortOrder.LayoutOrder;
listlayout.Parent = mainframe;

local onballtext = title:Clone();
onballtext.Text = '<i>On-Ball</i>';
onballtext.LayoutOrder = -20;

onballtext.Parent = mainframe;

local offballtext = onballtext:Clone();
offballtext.Text = '<i>Off-Ball</i>';
offballtext.LayoutOrder = -5;

offballtext.Parent = mainframe;

function add_button(Type,text)
    local button = Instance.new('TextButton');
    button.BackgroundColor3 = Color3.fromRGB(0,0,0)    
    button.RichText = true;
    button.Text = '<i>'..text..'</i>';
    button.TextColor3 = Color3.fromRGB(255,255,255);
    button.Font = Enum.Font.GothamBold;
    button.TextXAlignment = Enum.TextXAlignment.Left;
    button.Position = UDim2.fromScale(0,0);
    button.Size = UDim2.fromScale(1,0.13);
    button.TextScaled = true;

    button.LayoutOrder = (Type == 'OffBall' and 0) or (-10);
    button.Parent = mainframe;
    uicorner(0.2,button);

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
        humanoid:Move(position);
        local distance = (humrp.Position - position).Magnitude;
        reached = distance < 0.5;
    end;
end;


--actions
_G.OnBallActions = {
    Values = {
        PassTo = nil;
    }
    ['Auto Shoot'] = function()
        shoot(true);
        shooting = true;
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
        
        humanoid:MoveTo( Vector3.new(humrp.Position.X+5.5 , humrp.Position.Y , humrp.Position.Z) );
        task.wait(0.1)
        shoot(true)
        shooting = true;

    end;

    ['Auto Pass'] = function()
        rs.GameEvents.ClientAction('Pass',_G.OnBallActions.Values.PassTo);
    end;
}

_G.OffBallActions = {
    ['Rebounding'] = function()
        
    end;
}



-- _G.OnBall.Changed:Connect(function(value)
--     print('new Value:' , value);
--     if mainframe:FindFirstChild(value,true) then
--         print(mainframe:FindFirstChild(value,true));
--     end;
-- end)



function handle_buttons(button,Type)
    print(button,Type);
    local action = _G[Type..'Action'][button.Name];
    _G[Type].Value = (action == _G[Type])

    for _,button in pairs(mainframe:GetDescendants()) do
        if button.Name[_G[Type..'Action'] ] then
            button.BackgroundColor3 = Color3.fromRGB(0,0,0);
        end;
    end;

    if _G[Type].Value ~= '' then
        button.BackgroundColor3 = Color3.fromRGB(0,255,0);
    end;
end;

for name,action in pairs(_G.OnBallActions) do
  local button = add_button('OnBall',name);
  button.MouseButton1Down:Connect(function()
    print('button has been pressed');
    handle_buttons(button,'OnBall');
  end);
end;

for name,action in pairs(_G.OffBallActions) do
    local button = add_button('OffBall',name);
    button.MouseButton1Down:Connect(function()
        handle_buttons(button,'OffBall');
    end);
end;