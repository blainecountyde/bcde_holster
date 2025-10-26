# bcde_holster
Simple script for updating holsters when equipping / putting away handguns.

[Video](https://www.youtube.com/watch?v=E-Cww7a2ggk)

## Compatibility
This script has been tested on QBox with Illenium Appearance. Since QBox is mostly backwards compatible with QB-Core, this should also work with QB-Core.

For inventory management I've used ox_inventory, but the script doesn't depend on any inventory script and should work without.

If you're not using Illenium Appearance, you'll have to modify the `CanStart` and `GetCurrentClothing` functions in `config.lua` according to the clothing script you're using.

This should be obvious, but you need to have clothing installed that has empty and filled holster variants.

## Configuration
To configure the script, open up `config.lua` and edit the `holster` table.

Let's check out the `tazer` table for example:
```lua
tazer = {
    weapons = {
        [`WEAPON_STUNGUN`] = true,
    },
    component = 8, -- Shirt
    mappings = {
        -- [id_with_gun] = id_without_gun
        ['63'] = 64,
    }
}
```

As you can see, this holster config handles tazers. The weapons that match this config are defined in `weapons` and the `component` field specifies the clothing 'category' this holster is in. (if I wanted to specify a bracelet / accessories holster I'd have to set the component to 7)

Just specifying the component id is not enough though - we also need to specify which drawables are holsters. In the `mappings` table you'll need to map the id of a **filled holster** to the id of an **empty holster**. (e.g. `['63'] = 64`)

Take a look at the existing configs, they should be pretty helpful.

**References:**\
[Weapon Models](https://docs.fivem.net/docs/game-references/weapon-models/)\
[Clothing Components](https://wiki.rage.mp/wiki/Clothes)

## ox_inventory short animations
I wanted players with holsters to have shorter animations when pulling out weapons. This patch causes players to pull compatible weapons from the holster instead of pulling them from the pack of their pants. Here's the patch I used on my project:

File: `modules/weapon/client.lua`
```diff
diff --git a/client.lua b/client.lua
index 9f65b91..00e8636 100644
--- a/client.lua
+++ b/client.lua
@@ -10,6 +10,13 @@ anims[`GROUP_MELEE`] = { 'melee@holster', 'unholster', 200, 'melee@holster', 'ho
 anims[`GROUP_PISTOL`] = { 'reaction@intimidation@cop@unarmed', 'intro', 400, 'reaction@intimidation@cop@unarmed', 'outro', 450 }
 anims[`GROUP_STUNGUN`] = anims[`GROUP_PISTOL`]
 
+function canUseShortAnim(weapon)
+	if GetResourceState('bcde_holster'):find('start') then
+		return exports['bcde_holster']:IsWearingHolster(weapon)
+	end
+	return client.hasGroup(shared.police)
+end
+
 local function vehicleIsCycle(vehicle)
 	local class = GetVehicleClass(vehicle)
 	return class == 8 or class == 13
@@ -27,7 +34,7 @@ function Weapon.Equip(item, data, noWeaponAnim)
 
 		local anim = data.anim or anims[GetWeapontypeGroup(data.hash)]
 
-		if anim == anims[`GROUP_PISTOL`] and not client.hasGroup(shared.police) then
+		if anim == anims[`GROUP_PISTOL`] and not canUseShortAnim(data.hash) then
 			anim = nil
 		end
 
@@ -112,7 +119,7 @@ function Weapon.Disarm(currentWeapon, noAnim)
 			local coords = GetEntityCoords(cache.ped, true)
 			local anim = item.anim or anims[GetWeapontypeGroup(currentWeapon.hash)]
 
-			if anim == anims[`GROUP_PISTOL`] and not client.hasGroup(shared.police) then
+			if anim == anims[`GROUP_PISTOL`] and not canUseShortAnim(currentWeapon.hash) then
 				anim = nil
 			end
```

For the stungun I've changed the weapon metadata in `data/weapons.lua` to the following:
```lua
['WEAPON_STUNGUN'] = {
    label = 'Tazer', 
    weight = 227, 
    durability = 0.1,
    anim = { 'melee@holster', 'unholster', 200, 'melee@holster', 'holster', 600 },
},
```

If you leave this out, the stungun will be unholstered just like handguns.

## Support
Don't expect any support or updates for this script. I'm just publishing old scripts from a now defunct project I worked on.