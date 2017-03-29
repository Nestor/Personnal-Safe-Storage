--[[-----------------------------
	Addon By SlownLS
--------]]-------------------------

AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )

include('shared.lua')

util.AddNetworkString("OpenChoiceMenu")
util.AddNetworkString("SetPlayerStorage")
util.AddNetworkString("SetMoneyStorage")
util.AddNetworkString("RetireMoneyStorage")

function ENT:Initialize( )
	self:SetModel( "models/s_bank/s_bank.mdl" )
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	self:SetUseType( SIMPLE_USE )
	local phys = self:GetPhysicsObject()
	phys:Wake()
	self:SetNWString("PlayerStorage", "No Owner")
	self:SetNWInt("MoneyStorage", 0)
end

function ENT:OnTakeDamage()
	return false 
end 

function ENT:SpawnFunction(ply, trace)
	local ent = ents.Create("personnal_safe_storage");
	ent:SetPos(trace.HitPos + trace.HitNormal * 8);
	ent:Spawn();
	ent:Activate();
     
	return ent;
end;

function ENT:AcceptInput( Name, Activator, Caller )	
	if Name == "Use" and Caller:IsPlayer() then
		net.Start("OpenChoiceMenu")
		net.Send(Caller)
	end

	net.Receive("SetMoneyStorage", function(length, ply)

		local Money = net.ReadString()

		if tonumber(Money) > ply:getDarkRPVar("money") then
			DarkRP.notify(ply, 1, 5, "You do not have enough money!")
		else
			if tonumber(Money) > 0 then
				self:SetNWInt("MoneyStorage", self:GetNWInt("MoneyStorage") + Money )
				ply:addMoney(-Money)
			else
				DarkRP.notify(ply, 1, 5, "Error!")
			end
		end

	end)

	net.Receive("SetPlayerStorage", function(length, ply)

		self:SetNWString("PlayerStorage", net.ReadString())

	end)

	net.Receive("RetireMoneyStorage", function(length, ply)

		local Money = net.ReadString()

		if tonumber(Money) > self:GetNWInt("MoneyStorage") then
			DarkRP.notify(ply, 1, 5, "Not enough money in the trunk!")
		else
			if tonumber(Money) > 0 then
				self:SetNWInt("MoneyStorage", self:GetNWInt("MoneyStorage") - Money )
				ply:addMoney(Money)
			else
				DarkRP.notify(ply, 1, 5, "Error!")
			end
		end

	end)

end
