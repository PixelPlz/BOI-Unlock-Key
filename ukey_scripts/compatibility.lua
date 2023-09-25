local mod = UnlockKey



local descriptionEN = {
	"Opens the door to Boss Rush and the Hush floor regardless of the timer",
	"Allows the run to be continued past Mother, the same way as Mom's Heart / It Lives",
	"Increases the health of every enemy and boss by 20%",
}

local descriptionDE = {
	"Öffnet die Tür zu dem speziellen Raum Boss Rush und zum ??? Stockwerk unabhängig von dem Timer",
	"Ermöglicht es den Lauf fortzusetzen um den Boss Mutter herum, der selbe Weg wie bei Es lebt",
	"Erhöht die Leben der Gegner und der Bosse um 20%",
}

local descriptionUK = {
	"Відкриває двері до Боса Раша та ??? поверху незалежно від таймера",
	"Дозволяє продовжити пробіжку повз Мами , так само, як Це Живе / Мамине Серце",
	"Збільшує здоров’я кожного ворога та боса на 20%",
}

local descriptionRU = {
	"Открывает дверь в Комнату Вызова и этажа ??? вне зависимости от таймера",
	"Позволяет забегу продолжится после Матери, так же, как с Оно Живое / Сердце Мамы",
	"Увеличивает здоровье каждому врагу и боссу на 20%",
}



-- EID
if EID then
	-- English
	local EN = descriptionEN[1] .. "#" .. descriptionEN[2] .. "#" .. descriptionEN[3]
    EID:addCollectible(mod.Item, EN, "Unlock Key", "en_us")

	-- German
	local DE = descriptionDE[1] .. "#" .. descriptionDE[2] .. "#" .. descriptionDE[3]
    EID:addCollectible(mod.Item, DE, "Schlüssel Entsperren", "de")

	-- Ukranian
	local UK = descriptionUK[1] .. "#" .. descriptionUK[2] .. "#" .. descriptionUK[3]
	EID:addCollectible(mod.Item, UK, "Ключ Розблокування", "uk_ua")

	-- Russian
	local RU = descriptionRU[1] .. "#" .. descriptionRU[2] .. "#" .. descriptionRU[3]
    EID:addCollectible(mod.Item, RU, "Ключ Разблокировки", "ru")
end



-- Encyclopedia
if Encyclopedia then
	local UnlockKeyEncyclopedia = {
		{ -- Effect
			{str = "Effect", fsize = 3, clr = 3, halign = 0},
			{str = descriptionEN[1]},
			{str = descriptionEN[2]},
			{str = descriptionEN[3]},
		},
	}

	Encyclopedia.AddItem({
		ID = mod.Item,
		WikiDesc = UnlockKeyEncyclopedia,
	})
end