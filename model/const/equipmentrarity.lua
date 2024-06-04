local var0 = class("EquipmentRarity")

var0.Gray = 2
var0.Blue = 3
var0.Purple = 4
var0.Gold = 5
var0.SSR = 6

function var0.Rarity2Print(arg0)
	return ItemRarity.Rarity2Print(arg0 - 1)
end

var0.correctedLevel = {
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

function var0.Rarity2CorrectedLevel(arg0, arg1)
	local var0 = var0.correctedLevel[arg0]
	local var1

	for iter0, iter1 in ipairs(var0) do
		if iter1 > arg1 - 1 then
			break
		else
			var1 = iter0 - 1
		end
	end

	return i18n("equip_info_extralevel_" .. var1)
end

return var0
