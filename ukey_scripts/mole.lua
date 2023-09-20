local mod = UnlockKey

local States = {
    Idle     = 0,
    PayOut   = 1,
    Teleport = 2,
}



function mod:MoleInit(slot)
    slot:GetData().State = States.Idle
    slot.TargetPosition = slot.Position
end

function mod:MoleUpdate(slot)
    local sprite = slot:GetSprite()
    local data = slot:GetData()


    -- Stay in place
    slot.Position = slot.TargetPosition
    slot.Velocity = Vector.Zero


    if slot.GridCollisionClass == EntityGridCollisionClass.GRIDCOLL_GROUND -- Bombed
    or Game().TimeCounter > mod.TimeLimit then -- Time limit is passed
        data.State = States.Teleport
		sprite:Play("Leave")

        -- Remove drops if bombed
        if slot.GridCollisionClass == EntityGridCollisionClass.GRIDCOLL_GROUND then
            for i, pickup in pairs(Isaac.FindByType(EntityType.ENTITY_PICKUP, -1, -1, false, false)) do
                if pickup.FrameCount <= 1 and pickup.Position:Distance(slot.Position) <= pickup.Size + slot.Size then
                    pickup:Remove()
                end
            end
        end
	end


    -- Idle
    if data.State == States.Idle then
        if not sprite:IsPlaying("Idle") then
            sprite:Play("Idle", true)
        end


    -- Pay out
    elseif data.State == States.PayOut then
        -- Spawn the key
        if sprite:IsEventTriggered("Spawn") then
            local pos = Game():GetRoom():FindFreePickupSpawnPosition(slot.Position, 0, true, false)
            Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE, mod.Item, pos, Vector.Zero, slot)
            SFXManager():Play(SoundEffect.SOUND_LITTLE_SPIT, 1.1)
        end

        if sprite:IsFinished() then
            data.State = States.Teleport
            sprite:Play("Leave", true)
        end


    -- Teleport away
    elseif data.State == States.Teleport then
        if sprite:IsFinished() then
            slot:Remove()
            SFXManager():Play(SoundEffect.SOUND_CHEST_DROP, 0.75, 0, false, 0.9)
        end
    end
end

function mod:MoleCollision(slot, player)
    local data = slot:GetData()

    if data.State == States.Idle and player:GetNumCoins() > 0 then
        data.State = States.PayOut
        slot:GetSprite():Play("Pay")
        SFXManager():Play(SoundEffect.SOUND_SCAMPER)

        player:AddCoins(-1)
    end
end

-- Run the custom callbacks
function mod:CustomSlotCallbacks()
    for i, slot in pairs(Isaac.FindByType(EntityType.ENTITY_SLOT, mod.MoleVariant, -1, false, false)) do
		local data = slot:GetData()

        -- Init
        if not data.MoleInit then
            data.MoleInit = true
            mod:MoleInit(slot)

        else
            -- Update
            mod:MoleUpdate(slot)

            -- Collision
            for i = 0, Game():GetNumPlayers() - 1 do
                local player = Game():GetPlayer(i)

                if player:Exists() and not player:IsDead()
                and player.Position:Distance(slot.Position) <= player.Size + slot.Size then
                    mod:MoleCollision(slot, player)
                end
            end
        end
	end
end
mod:AddCallback(ModCallbacks.MC_POST_UPDATE, mod.CustomSlotCallbacks)



-- Try to spawn the Beggar
function mod:TrySpawnMole()
    local level = Game():GetLevel()
    local room = Game():GetRoom()

    if room:IsFirstVisit() -- Only check when first entering
    and level:GetAbsoluteStage() == LevelStage.STAGE1_1 -- Currently on the first floor
    and room:GetType() == RoomType.ROOM_SHOP -- In the shop
    and Game().TimeCounter <= mod.TimeLimit then -- Under the time limit
        local pos = room:FindFreePickupSpawnPosition(room:GetGridPosition(26), 0, true, false)
        Isaac.Spawn(EntityType.ENTITY_SLOT, mod.MoleVariant, 0, pos, Vector.Zero, nil)
    end
end
mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, mod.TrySpawnMole)