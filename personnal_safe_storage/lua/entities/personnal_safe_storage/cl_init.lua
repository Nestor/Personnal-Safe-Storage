--[[-----------------------------
	Addon By SlownLS
--------]]-------------------------

include('shared.lua')

surface.CreateFont("CoffreFont", {
	font = "Arial",
	size = 30,
	weight = 800,
	blursize = 0,
	scanlines = 0,
	antialias = true,
});

function ENT:Initialize()

end;

function ENT:Draw()
    local pos = self:GetPos()
	local ang = self:GetAngles()

	self:DrawModel()

	ang:RotateAroundAxis(ang:Up(), 360);
	ang:RotateAroundAxis(ang:Forward(), 90);	

	cam.Start3D2D(pos+ang:Up()*0.2, ang, 0.17)
		draw.RoundedBox( 0, -100, -121, 200, 47, Color(230, 92, 78) )
	    draw.RoundedBox( 0, -99, -120, 198, 45, Color(44, 47, 52, 255) ) 
		draw.SimpleTextOutlined(self:GetNWString("PlayerStorage"), "CoffreFont", -2, -100, Color(255,255,255,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color(230, 92, 78));
		draw.SimpleTextOutlined("Money: "..self:GetNWInt("MoneyStorage").."$", "CoffreFont", -2, -50, Color(255,255,255,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color(230, 92, 78));
	cam.End3D2D();
end;

net.Receive("OpenChoiceMenu",function(len, ply)
    local BaseChoice = vgui.Create("DFrame")
    BaseChoice:SetSize(550, 300)
    BaseChoice:SetPos(ScrW() / 2 - 400, ScrH() / 2 - 225)
    BaseChoice:SetTitle("")
    BaseChoice:ShowCloseButton(false)
    BaseChoice:SetVisible(true)
    BaseChoice:MakePopup()
    BaseChoice:Center()
    BaseChoice.Paint = function(self,w,h)
        draw.RoundedBox(6, 0, 0, w, h - 5, Color(54, 57, 62, 255))
    end

    local Close = vgui.Create("DButton", BaseChoice)
    Close:SetSize(40, 15)
    Close:SetPos(500, 5)
    Close:SetText("X")
    Close:SetTooltip("Fermer")
    Close:SetTextColor(Color(0,0,0,255))
    Close.Paint = function(self,w,h)
        draw.RoundedBox(3, 0, 0, w, h, Color(230, 92, 78) )
    end
    Close.DoClick = function()
        BaseChoice:Close()
    end

    Fond = vgui.Create("DPanel", BaseChoice)
    Fond:SetSize(530, BaseChoice:GetTall()-43)
    Fond:SetPos(10, 25)
   	Fond.Paint = function(self,w,h)
        draw.RoundedBox(0, 0, 0, w, h, Color(44, 47, 52, 255))
    end

    local ChoixCombo = vgui.Create( "DComboBox", Fond )
	ChoixCombo:SetPos( 50, 25 )
	ChoixCombo:SetSize( 430, 30)
	ChoixCombo:SetValue( "Choose a player" )
	for k, v in pairs( player.GetAll() ) do
		ChoixCombo:AddChoice( v:Nick() )
	end

    local TextEntry = vgui.Create( "DTextEntry", Fond ) 
    TextEntry:SetPos( 50, 75 )
    TextEntry:SetSize( 430, 30 )
    TextEntry:SetNumeric( true )

    local Valid = vgui.Create("DButton", Fond)
    Valid:SetSize(430, 45)
    Valid:SetPos(50, 125)
    Valid:SetText("")
    Valid.OnCursorEntered = function(self)
        surface.PlaySound("UI/buttonrollover.wav")
        self.hover = true
    end
    Valid.OnCursorExited = function(self)
        self.hover = false
    end
    Valid.Paint = function(self, w,h)
        local TextColor = Color(100, 100, 100, 255)
 
        draw.RoundedBox(6, 0, 0, w, h, Color(26, 29, 34, 255))
 
        if self.hover then
          TextColor = Color(230, 92, 78)
          draw.RoundedBox(6, 0, 0, w, h, Color(36, 39, 44, 255))
        else
         draw.RoundedBox(6, 0, 0, w, h, Color(26, 29, 34, 255))
        end
 
        draw.DrawText("Validate", "CoffreFont", w / 2 + 0, h / 2 - 15, TextColor, TEXT_ALIGN_CENTER)
    end
    Valid.DoClick = function()

    	if ChoixCombo:GetValue() != "Choose a player" then
	        net.Start("SetPlayerStorage")
	        net.WriteString(ChoixCombo:GetValue())
	        net.SendToServer()
    	end

    	if TextEntry:GetValue() != "" then
	        net.Start("SetMoneyStorage")
	        net.WriteString(TextEntry:GetValue())
	        net.SendToServer()
    	end

        BaseChoice:Remove()
    end

    local Retire = vgui.Create("DButton", Fond)
    Retire:SetSize(430, 45)
    Retire:SetPos(50, 175)
    Retire:SetText("")
    Retire.OnCursorEntered = function(self)
        surface.PlaySound("UI/buttonrollover.wav")
        self.hover = true
    end
    Retire.OnCursorExited = function(self)
        self.hover = false
    end
    Retire.Paint = function(self, w,h)
        local TextColor = Color(100, 100, 100, 255)
       
        draw.RoundedBox(6, 0, 0, w, h, Color(26, 29, 34, 255))
 
        if self.hover then
          TextColor = Color(230, 92, 78)
          draw.RoundedBox(6, 0, 0, w, h, Color(36, 39, 44, 255))
        else
         draw.RoundedBox(6, 0, 0, w, h, Color(26, 29, 34, 255))
        end
 
        draw.DrawText("Take Money", "CoffreFont", w / 2 + 0, h / 2 - 15, TextColor, TEXT_ALIGN_CENTER)
    end
    Retire.DoClick = function()

    	if TextEntry:GetValue() != "" then
		    net.Start("RetireMoneyStorage")
	        net.WriteString(TextEntry:GetValue())
	        net.SendToServer()
	    end

        BaseChoice:Remove()
    end
end)