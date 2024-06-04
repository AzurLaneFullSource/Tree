local var0 = class("ItemRarity")

var0.Gray = 1
var0.Blue = 2
var0.Purple = 3
var0.Gold = 4
var0.SSR = 5

function var0.Rarity2Print(arg0)
	if math.clamp(arg0, 1, 9) == arg0 then
		return tostring(arg0)
	else
		return var0.Gray
	end
end

var0.colors = {
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

function var0.Rarity2HexColor(arg0)
	return var0.colors[arg0]
end

var0.frameColors = {
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

function var0.Rarity2FrameHexColor(arg0)
	return var0.frameColors[arg0]
end

return var0
