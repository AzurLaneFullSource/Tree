local var0_0 = class("IslandItemRarity")

var0_0.GREY = 1
var0_0.BLUE = 2
var0_0.PURPLE = 3
var0_0.ORANGE = 4

function var0_0.Rarity2FrameName(arg0_1)
	if not var0_0.RARITY2FRAME then
		var0_0.RARITY2FRAME = {
			"rarity_grey",
			"rarity_blue",
			"rarity_purple",
			"rarity_orange"
		}
	end

	return var0_0.RARITY2FRAME[arg0_1]
end

return var0_0
