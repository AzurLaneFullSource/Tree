local var0 = class("BackYardDecorationPutCard")
local var1 = {
	"word_furniture",
	"word_decorate",
	"word_wallpaper",
	"word_floorpaper",
	"word_wall",
	"word_collection",
	"word_shipskin"
}

local function var2(arg0)
	return i18n(var1[arg0])
end

function var0.Ctor(arg0, arg1)
	arg0._go = arg1
	arg0._tf = tf(arg1)
	arg0.nameTxt = findTF(arg0._tf, "name"):GetComponent(typeof(Text))
	arg0.tagTxt = findTF(arg0._tf, "tag"):GetComponent(typeof(Text))
	arg0.icon = findTF(arg0._tf, "icon"):GetComponent(typeof(Image))
	arg0.mark = findTF(arg0._tf, "mark")
end

function var0.MarkOrUnMark(arg0, arg1)
	setActive(arg0.mark, arg0.furniture.id == arg1)
end

function var0.Update(arg0, arg1, arg2)
	arg0.furniture = arg1
	arg0.nameTxt.text = arg1:getConfig("name")
	arg0.tagTxt.text = var2(arg1:getConfig("tag"))
	arg0.icon.sprite = LoadSprite("furnitureicon/" .. arg1:getConfig("icon"))

	arg0:MarkOrUnMark(arg2)
end

function var0.Clear(arg0)
	arg0:MarkOrUnMark(false)
end

return var0
