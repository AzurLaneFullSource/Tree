local var0 = {
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
	getWeight = function(arg0, arg1)
		return SpWeapon.bindConfigTable()[arg0:GetConfigID()][arg1]
	end
}

function var0.sortFunc(arg0, arg1)
	local var0 = {}

	for iter0, iter1 in ipairs(arg0.values) do
		table.insert(var0, function(arg0)
			return (arg1 and -1 or 1) * -var0.getWeight(arg0, iter1)
		end)
	end

	return var0
end

return var0
