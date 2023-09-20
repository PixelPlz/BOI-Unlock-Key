local mod = UnlockKey



local description = {
	"Opens the door to Boss Rush and the Hush floor regardless of the timer",
	"Allows the run to be continued past Mother, the same way as It Lives",
	"Increases the health of every enemy and boss by 20%",
}



-- EID
if EID then
	local UnlockKeyEID = description[1] .. "#" .. description[2] .. "#" .. description[3]
    EID:addCollectible(mod.Item, UnlockKeyEID, "Unlock Key", "en_us")
end



-- Encyclopedia
if Encyclopedia then
	UnlockKeyEncyclopedia = {
		{ -- Effect
			{str = "Effect", fsize = 3, clr = 3, halign = 0},
			{str = description[1]},
			{str = description[2]},
			{str = description[3]},
		},
	}

	Encyclopedia.AddItem({
		ID = mod.Item,
		WikiDesc = UnlockKeyEncyclopedia,
	})
end