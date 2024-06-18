local var0_0 = class("EquipmentRarity")

var0_0.Gray = 2
var0_0.Blue = 3
var0_0.Purple = 4
var0_0.Gold = 5
var0_0.SSR = 6

function var0_0.Rarity2Print(arg0_1)
	return ItemRarity.Rarity2Print(arg0_1 - 1)
end

var0_0.correctedLevel = {
	{
		0
	},
	{
		0
	},
	{
		0,
		7
	},
	{
		0,
		11
	},
	{
		0,
		11,
		12,
		13
	},
	{
		0,
		11,
		12,
		13
	}
}

function var0_0.Rarity2CorrectedLevel(arg0_2, arg1_2)
	local var0_2 = var0_0.correctedLevel[arg0_2]
	local var1_2

	for iter0_2, iter1_2 in ipairs(var0_2) do
		if iter1_2 > arg1_2 - 1 then
			break
		else
			var1_2 = iter0_2 - 1
		end
	end

	return i18n("equip_info_extralevel_" .. var1_2)
end

return var0_0
