local var0 = class("ArmorType")

var0.Light = 1
var0.Medium = 2
var0.Heavy = 3

function var0.Type2Name(arg0)
	if not var0.names then
		var0.names = {
			i18n("word_lightArmor"),
			i18n("word_mediumArmor"),
			i18n("word_heavyarmor")
		}
	end

	return var0.names[arg0]
end

return var0
