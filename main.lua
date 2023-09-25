UnlockKey = RegisterMod("Unlock Key", 1)
local mod = UnlockKey



--[[ Constants ]]--
mod.Item = Isaac.GetItemIdByName("Unlock Key")
mod.MoleVariant = Isaac.GetEntityVariantByName("Mr. Unlocki")
mod.EnemyHPIncrease = 20 -- In percent

mod.TimeLimit   = 1.5 * 60 * 30
mod.TimeLimitXL = 2.5 * 60 * 30

mod.KeyRoomIndex = nil
mod.KeyGridIndex = nil



--[[ Load scripts ]]--
local folder = "ukey_scripts."
include(folder .. "key")
include(folder .. "mole")
include(folder .. "compatibility")