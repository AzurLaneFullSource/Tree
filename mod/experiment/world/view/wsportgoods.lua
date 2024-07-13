local var0_0 = class("WSPortGoods", import("...BaseEntity"))

var0_0.Fields = {
	transform = "userdata",
	rtMask = "userdata",
	goods = "table",
	txName = "userdata",
	rtResIcon = "userdata",
	rtItem = "userdata",
	txCount = "userdata",
	rtResCount = "userdata"
}
var0_0.Listeners = {
	onUpdate = "Update"
}

function var0_0.Build(arg0_1, arg1_1)
	arg0_1.transform = arg1_1
end

function var0_0.Setup(arg0_2, arg1_2)
	arg0_2.goods = arg1_2

	arg0_2.goods:AddListener(WorldGoods.EventUpdateCount, arg0_2.onUpdate)
	arg0_2:Init()
end

function var0_0.Dispose(arg0_3)
	arg0_3.goods:RemoveListener(WorldGoods.EventUpdateCount, arg0_3.onUpdate)
	arg0_3:Clear()
end

function var0_0.Init(arg0_4)
	local var0_4 = arg0_4.transform

	arg0_4.rtMask = var0_4:Find("mask")
	arg0_4.rtItem = var0_4:Find("IconTpl")
	arg0_4.txCount = var0_4:Find("count_contain/count")
	arg0_4.txName = var0_4:Find("name_mask/name")
	arg0_4.rtResIcon = var0_4:Find("consume/contain/icon")
	arg0_4.rtResCount = var0_4:Find("consume/contain/Text")

	setText(var0_4:Find("mask/tag/sellout_tag"), i18n("word_sell_out"))
	setText(var0_4:Find("count_contain/label"), i18n("activity_shop_exchange_count"))

	local var1_4 = arg0_4.goods.item

	updateDrop(arg0_4.rtItem, var1_4)
	setText(arg0_4.txName, shortenString(var1_4:getConfig("name"), 6))

	local var2_4 = arg0_4.goods.moneyItem

	GetImageSpriteFromAtlasAsync(var2_4:getIcon(), "", arg0_4.rtResIcon, false)
	setText(arg0_4.rtResCount, var2_4.count)
	arg0_4:Update()
end

function var0_0.Update(arg0_5, arg1_5)
	if arg1_5 == nil or arg1_5 == WorldGoods.EventUpdateCount then
		setText(arg0_5.txCount, arg0_5.goods.count .. "/" .. arg0_5.goods.config.frequency)
		setActive(arg0_5.rtMask, arg0_5.goods.count == 0)
	end
end

return var0_0
