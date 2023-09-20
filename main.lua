UnlockKey = RegisterMod("Unlock Key", 1)
local mod = UnlockKey



--[[ Constants ]]--
mod.TimeLimit = 1.5 * 60 * 30
mod.MoleVariant = Isaac.GetEntityVariantByName("Mr. Unlocki")
mod.Item = Isaac.GetItemIdByName("Unlock Key")
mod.EnemyHPIncrease = 20 -- In percent

mod.KeyRoomIndex = nil
mod.KeyGridIndex = nil



--[[ Load scripts ]]--
local folder = "ukey_scripts."
include(folder .. "key")
include(folder .. "mole")
include(folder .. "compatibility")