local mod = UnlockKey



-- Check if any players have the Unlock Key
function mod:DoesAnyoneHaveUnlockKey()
	for i = 0, Game():GetNumPlayers() - 1 do
		if Isaac.GetPlayer(i):GetCollectibleNum(mod.Item, true) > 0 then
			return true
		end
	end
	return false
end



-- Check if the current room is any of the required boss rooms
function mod:IsMommyRoom(type, room)
	if room:GetType() == RoomType.ROOM_BOSS and Game():GetLevel():GetAbsoluteStage() ~= LevelStage.STAGE7 then
		local bossID = room:GetBossID()

		if (type == "Mom" 	 and bossID == 6)
		or (type == "Heart"  and (bossID == 8 or bossID == 25))
		or (type == "Mother" and bossID == 88) then
			return true
		end
	end
	return false
end



-- Spawn timed doors / exits after Mother
function mod:TrySpawnUnlockKeyExits()
	if mod:DoesAnyoneHaveUnlockKey() == true then
		local room = Game():GetRoom()

		-- Boss Rush door from Mom
		if mod:IsMommyRoom("Mom", room) == true then
			room:TrySpawnBossRushDoor(true)


		-- Blue Womb door from Mom's Heart / It Lives
		elseif mod:IsMommyRoom("Heart", room) then
			room:TrySpawnBlueWombDoor(false, true)


		-- Blue Womb door, Sheol trapdoor and Cathedral light beam from Mother
		elseif mod:IsMommyRoom("Mother", room) then
			local gridPos = room:GetGridEntity(66)

			-- Sheol trapdoor and Cathedral light beam (Only if they're not spawned already)
			if gridPos == nil or gridPos:GetType() ~= GridEntityType.GRID_TRAPDOOR then
				-- Trapdoor
				local trapdoorPos = room:GetGridPosition(66)
				Isaac.GridSpawn(GridEntityType.GRID_TRAPDOOR, 0, trapdoorPos, true)

				-- Light beam
				local lightPos = room:GetGridPosition(68)
				Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.HEAVEN_LIGHT_DOOR, 0, lightPos, Vector.Zero, nil)
			end


			-- Blue Womb door
			room:TrySpawnBlueWombDoor(false, true, true)

			-- Load custom skin
			for doorSlot = 0, DoorSlot.NUM_DOOR_SLOTS - 1 do
				local door = room:GetDoor(doorSlot)

				if door ~= nil and door.TargetRoomIndex == GridRooms.ROOM_BLUE_WOOM_IDX then
					local sprite = door:GetSprite()
					local floorSuffix = "corpse"

					-- Last Judgement compatibility (probably gonna have to do a Fall from Grace one too...)
					if LastJudgement and LastJudgement.STAGE.Mortis:IsStage() then
						floorSuffix = "mortis"
					end

					for i = 0, sprite:GetLayerCount() - 1 do
						sprite:ReplaceSpritesheet(i, "gfx/grid/door_29_doortobluewomb_" .. floorSuffix .. ".png")
					end
					sprite:LoadGraphics()

					break
				end
			end
		end
	end
end



-- Try to spawn after the room is cleared
function mod:OnClear(rng, position)
	mod:TrySpawnUnlockKeyExits()
end
mod:AddCallback(ModCallbacks.MC_PRE_SPAWN_CLEAN_AWARD, mod.OnClear)

-- Try to spawn after re-entering the cleared room
function mod:NewRoom()
	local room  = Game():GetRoom()
	local level = Game():GetLevel()

	if room:IsClear() then
		mod:TrySpawnUnlockKeyExits()
	end


	-- Blue Womb entrance stuff
	if level:GetCurrentRoomIndex() == GridRooms.ROOM_BLUE_WOOM_IDX then
		local inCorpse = (level:GetAbsoluteStage() == LevelStage.STAGE4_1 or level:GetAbsoluteStage() == LevelStage.STAGE4_2) and level:GetStageType() >= StageType.STAGETYPE_REPENTANCE
		local inCustomCorpse = LastJudgement and LastJudgement.STAGE.Mortis:IsStage()

		if inCorpse or inCustomCorpse then
			for grindex = 0, room:GetGridSize() - 1 do
				local grid = room:GetGridEntity(grindex)

				if grid then
					-- Make the door lead to the Mother arena instead of the entrance to it
					if grid:ToDoor() then
						grid:ToDoor().TargetRoomIndex = GridRooms.ROOM_SECRET_EXIT_IDX

					-- The game replaces the Blue Womb trapdoor with a cobweb in Corpse (FUN!!!) so I have to undo it
					elseif inCorpse and grid:GetType() == GridEntityType.GRID_SPIDERWEB then
						room:RemoveGridEntity(grindex, 0, false)
						room:Update()

						local trapdoorPos = room:GetGridPosition(grindex)
						Isaac.GridSpawn(GridEntityType.GRID_TRAPDOOR, 0, trapdoorPos, true)
					end
				end
			end
		end
	end


	-- Reset key tracker
	if mod.KeyGridIndex then
		mod.KeyGridIndex = nil
	end
end
mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, mod.NewRoom)



-- Fix Mother exits taking the player to the wrong stage
function mod:PlayerUpdate(player)
	if mod:IsMommyRoom("Mother", Game():GetRoom()) then
		local sprite = player:GetSprite()
		local level = Game():GetLevel()

		-- Sheol trapdoor
		local gridHere = Game():GetRoom():GetGridEntityFromPos(player.Position)

		if sprite:IsPlaying("Trapdoor") and sprite:GetFrame() >= 15
		and gridHere ~= nil and gridHere:GetType() == GridEntityType.GRID_TRAPDOOR then -- Make sure it's not a Ventricle Razor hole
			level:SetStage(LevelStage.STAGE4_2, StageType.STAGETYPE_ORIGINAL)
			Game():SetStateFlag(GameStateFlag.STATE_HEAVEN_PATH, false)


		-- Cathedral light beam
		elseif sprite:IsPlaying("LightTravel") and sprite:GetFrame() >= 35
		and player.ControlsEnabled == false then -- Make sure the animation isn't from the Emote mod
			level:SetStage(LevelStage.STAGE4_2, StageType.STAGETYPE_ORIGINAL)
			Game():SetStateFlag(GameStateFlag.STATE_HEAVEN_PATH, true)
		end
	end
end
mod:AddCallback(ModCallbacks.MC_POST_PLAYER_RENDER, mod.PlayerUpdate)



-- Increase the HP of every enemy
function mod:EnemyInit(entity)
	if mod:DoesAnyoneHaveUnlockKey() == true and entity:IsActiveEnemy(false) == true then
		local onePercent = entity.MaxHitPoints / 100
		local increase = onePercent * mod.EnemyHPIncrease

		-- Prevent Gideon from softlocking
		if entity.Type == EntityType.ENTITY_GIDEON then
			increase = math.floor(increase)
		end

		entity.MaxHitPoints = entity.MaxHitPoints + increase
		entity.HitPoints = entity.MaxHitPoints
	end
end
mod:AddPriorityCallback(ModCallbacks.MC_POST_NPC_INIT, CallbackPriority.LATE, mod.EnemyInit)



-- Prevent the key from being rerolled (hopefully you can't somehow force it to spawn in other places with this)
function mod:KeyPedestalUpdate(pickup)
	if not mod:DoesAnyoneHaveUnlockKey() and pickup.SubType > 0 then
		local room = Game():GetRoom()

		-- Get the key pedestal's position
		if pickup.SubType == mod.Item then
			mod.KeyGridIndex = room:GetGridIndex(pickup.Position)

		-- Turn the item back into the key
		elseif room:GetGridIndex(pickup.Position) == mod.KeyGridIndex then
			pickup:Morph(pickup.Type, pickup.Variant, mod.Item, true, true, true) -- This removes the item it was gonna roll into from its pool... too bad!
		end
	end
end
mod:AddCallback(ModCallbacks.MC_POST_PICKUP_UPDATE, mod.KeyPedestalUpdate, PickupVariant.PICKUP_COLLECTIBLE)