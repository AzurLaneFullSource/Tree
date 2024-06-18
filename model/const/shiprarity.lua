local var0_0 = class("ShipRarity")

var0_0.Gray = 2
var0_0.Blue = 3
var0_0.Purple = 4
var0_0.Gold = 5
var0_0.SSR = 6

function var0_0.Rarity2Print(arg0_1)
	return ItemRarity.Rarity2Print(arg0_1 - 1)
end

function var0_0.SSRGradient(arg0_2)
	return "<material=outline c=#00000040 x=1 y=1><material=gradient from=#FF0000 to=#00FF00 x=1 y=1>" .. arg0_2 .. "</material></material>"
end

function shipRarity2bgPrint(arg0_3, arg1_3, arg2_3)
	local var0_3 = {}

	table.insert(var0_3, var0_0.Rarity2Print(arg0_3))

	if arg1_3 then
		table.insert(var0_3, "0")
	end

	if arg2_3 then
		table.insert(var0_3, "1")
	end

	return table.concat(var0_3, "_")
end

return var0_0
