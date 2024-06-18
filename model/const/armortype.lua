local var0_0 = class("ArmorType")

var0_0.Light = 1
var0_0.Medium = 2
var0_0.Heavy = 3

function var0_0.Type2Name(arg0_1)
	if not var0_0.names then
		var0_0.names = {
			i18n("word_lightArmor"),
			i18n("word_mediumArmor"),
			i18n("word_heavyarmor")
		}
	end

	return var0_0.names[arg0_1]
end

return var0_0
