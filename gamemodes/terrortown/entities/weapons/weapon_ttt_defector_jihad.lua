local convertPharaoh = CreateConVar("ttt_defector_convert_pharaoh", 1, {FCVAR_SERVER_CAN_EXECUTE, FCVAR_ARCHIVE, FCVAR_REPLICATED}, "Should Pharaohs be able to be converted to a Defector?", 0, 1)


if SERVER then
	AddCSLuaFile()
else
   SWEP.PrintName          = "Defector Jihad"
   SWEP.Slot               = 8

   SWEP.Icon               = "vgui/ttt/icon_defector_jihad"
   SWEP.EquipMenuData = {
      type = "item_weapon",
      desc = "Drop the Defector Jihad to an Innocent player to convert them to a Defector!\n\nA Defector is a Traitor role that can only do damage by using the Jihad Bomb to suicide bomb their enemies!\n\n\nNOTE: This item can ONLY be dropped for an Innocent player to pick up."
   };
end

SWEP.Base                  = "weapon_tttbase"

SWEP.Primary.Ammo          = "none"
SWEP.Primary.Delay         = 5
SWEP.Primary.ClipSize      = -1
SWEP.Primary.DefaultClip   = -1
SWEP.Primary.Automatic     = false

SWEP.Kind                  = WEAPON_EQUIP
SWEP.CanBuy                = {ROLE_TRAITOR}
SWEP.LimitedStock          = true -- only buyable once
SWEP.AllowDrop             = true
SWEP.AutoSpawnable = false

SWEP.HoldType              = "slam"

SWEP.UseHands              = true
SWEP.DrawAmmo              = false
SWEP.ViewModelFlip         = false
SWEP.ViewModelFOV          = 54
SWEP.ViewModel             = Model("models/weapons/zaratusa/jihad_bomb/v_jb.mdl")
SWEP.WorldModel            = Model("models/weapons/zaratusa/jihad_bomb/w_jb.mdl")

if SERVER then
   -- Determines behavior when the Defector Jihad is picked up
   hook.Add('WeaponEquip', 'DefectorJihadPickup', function(weapon, owner)
      local class = weapon:GetClass()

      -- Only do check if the picked up weapon is the Defector Jihad
      if class == 'weapon_ttt_defector_jihad' then

         -- If the player picking up the Defector Jihad is ROLE_INNOCENT and TEAM_INNOCENT
         -- Checking team as well since some roles can be Innocent but a different team
         if owner:GetRole() == ROLE_INNOCENT 
         and owner:GetTeam() == TEAM_INNOCENT then

            -- Check if the player is any of the disabled convertable roles
            if convertPharaoh:GetBool() and owner:GetSubRole() == ROLE_PHARAOH then 

               -- Remove the Defector Jihad from the player
               timer.Simple( 0, function()
                  owner:StripWeapon(class)
               end )
               
               -- Give the normal Jihad to the player
               owner:SafePickupWeaponClass("weapon_ttt_jihad_bomb", true)

               -- Convert the player to the Defector role
               ConvertDefector(owner)
            end
         end
      end
   end)
end

function SWEP:PrimaryAttack()
   self.Owner:PrintMessage(HUD_PRINTTALK, 'You must drop the Defector Jihad for an Innocent player!')
end

function SWEP:SecondaryAttack()
end

