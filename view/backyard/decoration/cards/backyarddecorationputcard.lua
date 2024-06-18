local var0_0 = class("BackYardDecorationPutCard")
local var1_0 = {
	"word_furniture",
	"word_decorate",
	"word_wallpaper",
	"word_floorpaper",
	"word_wall",
	"word_collection",
	"word_shipskin"
}

local function var2_0(arg0_1)
	return i18n(var1_0[arg0_1])
end

function var0_0.Ctor(arg0_2, arg1_2)
	arg0_2._go = arg1_2
	arg0_2._tf = tf(arg1_2)
	arg0_2.nameTxt = findTF(arg0_2._tf, "name"):GetComponent(typeof(Text))
	arg0_2.tagTxt = findTF(arg0_2._tf, "tag"):GetComponent(typeof(Text))
	arg0_2.icon = findTF(arg0_2._tf, "icon"):GetComponent(typeof(Image))
	arg0_2.mark = findTF(arg0_2._tf, "mark")
end

function var0_0.MarkOrUnMark(arg0_3, arg1_3)
	setActive(arg0_3.mark, arg0_3.furniture.id == arg1_3)
end

function var0_0.Update(arg0_4, arg1_4, arg2_4)
	arg0_4.furniture = arg1_4
	arg0_4.nameTxt.text = arg1_4:getConfig("name")
	arg0_4.tagTxt.text = var2_0(arg1_4:getConfig("tag"))
	arg0_4.icon.sprite = LoadSprite("furnitureicon/" .. arg1_4:getConfig("icon"))

	arg0_4:MarkOrUnMark(arg2_4)
end

function var0_0.Clear(arg0_5)
	arg0_5:MarkOrUnMark(false)
end

return var0_0
