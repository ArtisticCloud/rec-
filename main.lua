local player = game.Players.LocalPlayer;
local character = player.Character;
local humrp = character:WaitForChild('HumanoidRootPart');
local humanoid = character:WaitForChild('Humanoid');

local playergui = player:WaitForChild('PlayerGui');


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

function add_button(Type,text)
    local button = Instance.new('TextButton');
    button.BackgroundColor3 = Color3.fromRGB(0,0,0)    
    button.RichText = true;
    button.Text = '<i>'..text..'</i>';
    button.Font = Enum.Font.GothamBold;
    button.TextXAlignment = Enum.TextXAlignment.Left;

    button.LayoutOrder = (Type == 'OffBall' and 0) or (-10);
    button.Parent = mainframe;
    uicorner(0,button);
end;

add_button('OffBall','Auto-Guard')

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
title.Text = '<i>Rect Boosting Gui</i>'
title.Font = Enum.Font.GothamBold;
title.TextXAlignment = Enum.TextXAlignment.Left;
title.TextColor3 = Color3.fromRGB(255,255,255);
title.Position = UDim2.fromScale(0,-0.102);
title.Size = UDim2.fromScale(1,0.102);

title.Parent = backframe;

local mainframe = Instance.new('ScrollingFrame');
mainframe.BackgroundTransparency = 0.5;
mainframe.ScrollBarThickness = 0;
mainframe.AutomaticCanvasSize = Enum.AutomaticSize.Y;
mainframe.Size = UDim2.fromScale(0.929 ,0.938);
mainframe.Position = UDim2.fromScale(0.038,0.04);

mainframe.Parent = backframe;

local listlayout = Instance.new('UIListLayout');
listlayout.Padding = UDim.new(0.05,0);
listlayout.Parent = mainframe;

local onballtext = title:Clone();
onballtext.Text = '<i>On-Ball</i>';
onballtext.LayoutOrder = -20;

onballtext.Parent = mainframe;

local offballtext = onballtext:Clone();
offballtext.Text = '<i>Off-Ball</i>';
offballtext.LayoutOrder = -5;

offballtext.Parent = mainframe;

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
    rs.Action:FireServer('Shoot',value);
    shooting = true;
end;

local moving = false;
function move_humanoid(position,duration)
    local reached,timer,connection = false,tick(),nil;
    
    while (not reached) and (tick() - timer > duration) do
        humanoid:Move(position);
        
    end;
end;


--actions
_G.OnBallActions = {

    ['Auto Shoot'] = function()
        
    end;

    ['Auto Acro'] = function()
        
    end;

    ['Auto Off-Dribble'] = function()
        
    end;

    ['Auto Pass'] = function()
        
    end;
}

_G.OffBallActions = {
    ['Rebounding'] = function()
    
    end;
}