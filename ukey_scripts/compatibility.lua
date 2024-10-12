local mod = UnlockKey



-- Create EID entry
function mod:CreateEID(id, description, name, language)
	if EID then
		local combinedDescription

		-- Create the description
		for i, line in pairs(description) do
			if i == 1 then
				combinedDescription = line
			else
				combinedDescription = combinedDescription .. "#" .. line
			end
		end

		EID:addCollectible(id, combinedDescription, name, language)
	end
end



-- English
local descriptionEN = {
	"Opens the door to Boss Rush and the Hush floor regardless of the timer",
	"Allows the run to be continued past Mother, the same way as Mom's Heart / It Lives",
	"Increases the health of every enemy and boss by 20%",
}
mod:CreateEID(mod.Item, descriptionEN, "Unlock Key", "en_us")

-- German
local descriptionDE = {
	"Öffnet die Tür zu dem speziellen Raum Boss Rush und zum ??? Stockwerk unabhängig von dem Timer",
	"Ermöglicht es den Lauf fortzusetzen um den Boss Mutter herum, der selbe Weg wie bei Es lebt",
	"Erhöht die Leben der Gegner und der Bosse um 20%",
}
mod:CreateEID(mod.Item, descriptionDE, "Schlüssel Entsperren", "de")

-- Spanish
local descriptionSPA = {
	"Abre la Boss Rush y la pelea contra Hush indepentientemente del tiempo",
	"Permite que la partida siga después de Mother, igual que It Lives",
	"Aumenta la vida de todos los enemigos y jefes en un 20%",
}
mod:CreateEID(mod.Item, descriptionSPA, "Llave del Tiempo", "spa")

-- Ukranian
local descriptionUK = {
	"Відкриває двері до Боса Раша та ??? поверху незалежно від таймера",
	"Дозволяє продовжити пробіжку повз Мами , так само, як Це Живе / Мамине Серце",
	"Збільшує здоров’я кожного ворога та боса на 20%",
}
mod:CreateEID(mod.Item, descriptionUK, "Ключ Розблокування", "uk_ua")

-- Russian
local descriptionRU = {
	"Открывает дверь в Комнату Вызова и этажа ??? вне зависимости от таймера",
	"Позволяет забегу продолжится после Матери, так же, как с Оно Живое / Сердце Мамы",
	"Увеличивает здоровье каждому врагу и боссу на 20%",
}
mod:CreateEID(mod.Item, descriptionRU, "Ключ Разблокировки", "ru")



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