if SERVER then
	AddCSLuaFile()
	resource.AddFile("materials/vgui/ttt/dynamic/roles/icon_defector.vmt")
end

function ROLE:PreInitialize()
	self.color = Color(184, 148, 114, 255)

	self.abbr = "defec"
	self.surviveBonus = 0.5 -- bonus multiplier for every survive while another player was killed
  	self.scoreKillsMultiplier = 5 -- multiplier for kill of player of another team
  	self.scoreTeamKillsMultiplier = -16 -- multiplier for teamkill

	self.notSelectable = true
	self.preventFindCredits = true
	self.preventKillCredits = true
	self.preventTraitorAloneCredits = true

	self.defaultTeam = TEAM_TRAITOR

	self.conVarData = {
		credits = 0, -- the starting credits of a specific role
		traitorButton = 0, -- can use traitor buttons
		shopFallback = SHOP_FALLBACK_TRAITOR
	  }
end

function ROLE:Initialize()
	roles.SetBaseRole(self, ROLE_TRAITOR)
end

if SERVER then
	function ConvertDefector(target)
		target:SetRole(ROLE_DEFECTOR)

		SendFullStateUpdate()
	end

    local function ShouldDefectorDealNoDamage(ply, attacker)
        if not IsValid(ply) 
		or not IsValid(attacker) 
		or not attacker:IsPlayer() 
		or attacker:GetSubRole() ~= ROLE_DEFECTOR 
		or attacker:GetTeam() == TEAM_NONE then return end
		
        if SpecDM and (ply.IsGhost and ply:IsGhost() or (attacker.IsGhost and attacker:IsGhost())) then return end
    
        return true -- true to block damage event
    end
    
    -- Defector deals no damage to other players
    hook.Add("PlayerTakeDamage", "DefectorNoDamage", function(ply, inflictor, killer, amount, dmginfo)
        if not ShouldDefectorDealNoDamage(ply, killer) then return end
    
		-- Do not negate explosive damage to allow jihad to work
		if dmginfo:GetDamageType() != DMG_BLAST then
			dmginfo:ScaleDamage(0)
			dmginfo:SetDamage(0)
		end
    end)
    
    -- Defector deals no damage to ankhs
    hook.Add("TTT2PharaohPreventDamageToAnkh", "TTT2PharaohPreventDamageToAnkhDefector", function(attacker)
        if attacker:GetSubRole() == ROLE_DEFECTOR then
            return true
        end
    end)
end
