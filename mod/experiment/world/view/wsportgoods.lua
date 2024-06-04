local var0 = class("WSPortGoods", import("...BaseEntity"))

var0.Fields = {
	transform = "userdata",
	rtMask = "userdata",
	goods = "table",
	txName = "userdata",
	rtResIcon = "userdata",
	rtItem = "userdata",
	txCount = "userdata",
	rtResCount = "userdata"
}
var0.Listeners = {
	onUpdate = "Update"
}

function var0.Build(arg0, arg1)
	arg0.transform = arg1
end

function var0.Setup(arg0, arg1)
	arg0.goods = arg1

	arg0.goods:AddListener(WorldGoods.EventUpdateCount, arg0.onUpdate)
	arg0:Init()
end

function var0.Dispose(arg0)
	arg0.goods:RemoveListener(WorldGoods.EventUpdateCount, arg0.onUpdate)
	arg0:Clear()
end

function var0.Init(arg0)
	local var0 = arg0.transform

	arg0.rtMask = var0:Find("mask")
	arg0.rtItem = var0:Find("IconTpl")
	arg0.txCount = var0:Find("count_contain/count")
	arg0.txName = var0:Find("name_mask/name")
	arg0.rtResIcon = var0:Find("consume/contain/icon")
	arg0.rtResCount = var0:Find("consume/contain/Text")

	setText(var0:Find("mask/tag/sellout_tag"), i18n("word_sell_out"))
	setText(var0:Find("count_contain/label"), i18n("activity_shop_exchange_count"))

	local var1 = arg0.goods.item

	updateDrop(arg0.rtItem, var1)
	setText(arg0.txName, shortenString(var1:getConfig("name"), 6))

	local var2 = arg0.goods.moneyItem

	GetImageSpriteFromAtlasAsync(var2:getIcon(), "", arg0.rtResIcon, false)
	setText(arg0.rtResCount, var2.count)
	arg0:Update()
end

function var0.Update(arg0, arg1)
	if arg1 == nil or arg1 == WorldGoods.EventUpdateCount then
		setText(arg0.txCount, arg0.goods.count .. "/" .. arg0.goods.config.frequency)
		setActive(arg0.rtMask, arg0.goods.count == 0)
	end
end

return var0
