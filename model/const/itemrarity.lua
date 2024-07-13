local var0_0 = class("ItemRarity")

var0_0.Gray = 1
var0_0.Blue = 2
var0_0.Purple = 3
var0_0.Gold = 4
var0_0.SSR = 5

function var0_0.Rarity2Print(arg0_1)
	if math.clamp(arg0_1, 1, 9) == arg0_1 then
		return tostring(arg0_1)
	else
		return var0_0.Gray
	end
end

var0_0.colors = {
	"FFFFFFFF",
	"41D7FFFF",
	"CC7BFFFF",
	"FDC637FF",
	"FF5E39FF",
	"FFFFFFFF",
	"FDC637FF",
	"FFFFFFFF",
	"FDC637FF"
}

function var0_0.Rarity2HexColor(arg0_2)
	return var0_0.colors[arg0_2]
end

var0_0.frameColors = {
	"BDBDBDFF",
	"65C7FFFF",
	"BFA3FFFF",
	"FFE743FF",
	"FFFFFFFF",
	"FFFFFFFF",
	"FFE743FF",
	"FFFFFFFF",
	"FFE743FF"
}

function var0_0.Rarity2FrameHexColor(arg0_3)
	return var0_0.frameColors[arg0_3]
end

return var0_0
