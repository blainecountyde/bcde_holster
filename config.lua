return {
    holster = {
        handgun = {
            weapons = {
                [`WEAPON_PISTOL`] = true,
                [`WEAPON_COMBATPISTOL`] = true,
                [`WEAPON_APPISTOL`] = true,
                [`WEAPON_PISTOL50`] = true,
                [`WEAPON_SNSPISTOL`] = true,
                [`WEAPON_HEAVYPISTOL`] = true,
                [`WEAPON_VINTAGEPISTOL`] = true,
                [`WEAPON_MARKSMANPISTOL`] = true,
                [`WEAPON_CERAMICPISTOL`] = true,
                [`WEAPON_GADGETPISTOL`] = true,
                [`WEAPON_SNSPISTOL_MK2`] = true,
                [`WEAPON_PISTOL_MK2`] = true,
            },
            component = 7, -- Bracelet / Accessories
            mappings = {
                -- [id_with_gun] = id_without_gun
                ['6'] = 5,
                ['4'] = 7,
                ['20'] = 21,
                ['18'] = 19,
                ['22'] = 23,
                ['24'] = 25,
                ['28'] = 29,
                ['30'] = 31,
                ['32'] = 33,
                ['36'] = 37,
                ['38'] = 39,
                ['56'] = 55,
            }
        },
        revolver = {
            weapons = {
                [`WEAPON_REVOLVER`] = true,
                [`WEAPON_DOUBLEACTION`] = true,
                [`WEAPON_NAVYREVOLVER`] = true,
                [`WEAPON_REVOLVER_MK2`] = true,
            },
            component = 7, -- Bracelet / Accessories
            mappings = {
                -- [id_with_gun] = id_without_gun
                ['26'] = 27,
            }
        },
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
    },

    -- Called when starting the script to make sure all deps are loaded
    CanStart = function()
        return GetResourceState('illenium-appearance'):find('start')
    end,

    -- Expects a table with 'drawable' and 'texture'
    -- Example: { drawable: number, texture: number }
    GetCurrentClothing = function(componentId)
        local appearance = exports['illenium-appearance']:getPedAppearance(PlayerPedId())
        if not appearance or not appearance.components[componentId] then
            return nil
        end
        return appearance.components[componentId]
    end
}