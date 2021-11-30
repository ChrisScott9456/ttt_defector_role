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
SWEP.ViewModelFlip = false
SWEP.ViewModelFOV = 54
SWEP.ViewModel             = Model("models/weapons/zaratusa/jihad_bomb/v_jb.mdl")
SWEP.WorldModel            = Model("models/weapons/zaratusa/jihad_bomb/w_jb.mdl")

if SERVER then
   -- Determines behavior when the Defector Jihad is picked up
   hook.Add('WeaponEquip', 'DefectorJihadPickup', function(weapon, owner)
      local class = weapon:GetClass()

      -- Only do check if the picked up weapon is the Defector Jihad
      if class == 'weapon_ttt_defector_jihad' then

         -- If the player picking up the Defector Jihad is NOT the owner of the Jihad
         -- If the player picking up the Defector Jihad is ROLE_INNOCENT
         if owner:GetRole() == ROLE_INNOCENT then

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
   end)
end

function SWEP:PrimaryAttack()
   self.Owner:PrintMessage(HUD_PRINTTALK, 'You must drop the Defector Jihad for an Innocent player!')
end

function SWEP:SecondaryAttack()
end

