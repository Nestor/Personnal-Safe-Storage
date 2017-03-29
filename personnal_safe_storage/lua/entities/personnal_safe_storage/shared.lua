--[[-----------------------------
	Addon By SlownLS
--------]]-------------------------

ENT.Base = "base_ai" 
ENT.Type = "ai"
ENT.PrintName		= "Safe Storage"
ENT.Category		= "♦ SlownLS ♦"
ENT.Author = "SlownLS"
ENT.Instructions	= "Appuyer sur E (Touche 'USE')"
ENT.Spawnable		= true
ENT.AdminSpawnable		= true 
ENT.AutomaticFrameAdvance = true

function ENT:SetAutomaticFrameAdvance(bUsingAnim) 
	self.AutomaticFrameAdvance = bUsingAnim 
end
