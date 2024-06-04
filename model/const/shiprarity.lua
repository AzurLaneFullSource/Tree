local var0 = class("ShipRarity")

var0.Gray = 2
var0.Blue = 3
var0.Purple = 4
var0.Gold = 5
var0.SSR = 6

function var0.Rarity2Print(arg0)
	return ItemRarity.Rarity2Print(arg0 - 1)
end

function var0.SSRGradient(arg0)
	return "<material=outline c=#00000040 x=1 y=1><material=gradient from=#FF0000 to=#00FF00 x=1 y=1>" .. arg0 .. "</material></material>"
end

function shipRarity2bgPrint(arg0, arg1, arg2)
	local var0 = {}

	table.insert(var0, var0.Rarity2Print(arg0))

	if arg1 then
		table.insert(var0, "0")
	end

	if arg2 then
		table.insert(var0, "1")
	end

	return table.concat(var0, "_")
end

return var0
