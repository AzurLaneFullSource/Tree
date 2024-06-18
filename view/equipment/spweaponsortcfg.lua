local var0_0 = {
	sort = {
		{
			type = 1,
			spr = "sort_rarity",
			tag = i18n("word_equipment_rarity"),
			values = {
				"rarity",
				"id",
				"level"
			}
		},
		{
			type = 2,
			spr = "sort_intensify",
			tag = i18n("word_equipment_intensify"),
			values = {
				"level",
				"rarity",
				"id"
			}
		}
	},
	getWeight = function(arg0_1, arg1_1)
		return SpWeapon.bindConfigTable()[arg0_1:GetConfigID()][arg1_1]
	end
}

function var0_0.sortFunc(arg0_2, arg1_2)
	local var0_2 = {}

	for iter0_2, iter1_2 in ipairs(arg0_2.values) do
		table.insert(var0_2, function(arg0_3)
			return (arg1_2 and -1 or 1) * -var0_0.getWeight(arg0_3, iter1_2)
		end)
	end

	return var0_2
end

return var0_0
