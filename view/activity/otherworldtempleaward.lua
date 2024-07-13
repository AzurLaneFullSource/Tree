local var0_0 = class("OtherWorldTempleAward")
local var1_0 = "other_world_temple_award_last"
local var2_0 = "other_world_temple_award_title_1"
local var3_0 = "other_world_temple_award_title_2"
local var4_0 = "other_world_temple_award_title_3"
local var5_0 = {
	var2_0,
	var3_0,
	var4_0
}

function var0_0.Ctor(arg0_1, arg1_1, arg2_1)
	arg0_1._tf = arg1_1
	arg0_1._event = arg2_1

	onButton(arg0_1._event, findTF(arg0_1._tf, "ad/btnClose"), function()
		arg0_1:setActive(false)
	end, SFX_CANCEL)
	onButton(arg0_1._event, findTF(arg0_1._tf, "ad/clickClose"), function()
		arg0_1:setActive(false)
	end, SFX_CANCEL)

	arg0_1._awardTpl = findTF(arg0_1._tf, "ad/awards/content/awardTpl")

	setActive(arg0_1._awardTpl, false)

	arg0_1._awardItems = {}
	arg0_1._awardContent = findTF(arg0_1._tf, "ad/awards/content")
end

function var0_0.setData(arg0_4, arg1_4, arg2_4)
	arg0_4.templeIds = arg1_4
	arg0_4.shopDatasList = arg2_4
end

function var0_0.updateActivityPool(arg0_5, arg1_5)
	arg0_5.activityPools = arg1_5
end

function var0_0.updateSelect(arg0_6, arg1_6)
	local var0_6 = arg0_6.shopDatasList[arg1_6]

	arg0_6:updateItemsCount(#var0_6)

	arg0_6.selectPool = arg0_6.activityPools[arg0_6.templeIds[arg1_6]]

	for iter0_6 = 1, #arg0_6._awardItems do
		local var1_6 = arg0_6._awardItems[iter0_6]

		setActive(var1_6, false)

		if iter0_6 <= #var0_6 then
			setActive(var1_6, true)
			arg0_6:setItemData(var1_6, var0_6[iter0_6])
		end
	end

	setText(findTF(arg0_6._tf, "ad/title/text"), i18n(var5_0[arg1_6]))
end

function var0_0.setItemData(arg0_7, arg1_7, arg2_7)
	local var0_7 = arg2_7.id
	local var1_7 = arg2_7.count
	local var2_7 = var1_7 - (arg0_7.selectPool.awards[var0_7] or 0)
	local var3_7 = pg.activity_random_award_item[var0_7]
	local var4_7 = Drop.New({
		type = var3_7.resource_category,
		id = var3_7.commodity_id,
		count = var3_7.num
	})

	updateDrop(findTF(arg1_7, "ad/icon/IconTpl"), var4_7)
	onButton(arg0_7._event, arg1_7, function()
		arg0_7._event:emit(BaseUI.ON_DROP, var4_7)
	end, SFX_PANEL)
	setScrollText(findTF(arg1_7, "ad/name/text"), var4_7:getName())
	setText(findTF(arg1_7, "ad/amount/text"), i18n(var1_0, var2_7, var1_7))
	setActive(findTF(arg1_7, "ad/soldOut"), var2_7 == 0)
end

function var0_0.updateItemsCount(arg0_9, arg1_9)
	local var0_9 = 0

	if arg1_9 > #arg0_9._awardItems then
		var0_9 = arg1_9 - #arg0_9._awardItems
	end

	for iter0_9 = 1, var0_9 do
		local var1_9 = tf(instantiate(arg0_9._awardTpl))

		SetParent(var1_9, arg0_9._awardContent)
		table.insert(arg0_9._awardItems, var1_9)
	end
end

function var0_0.setActive(arg0_10, arg1_10)
	setActive(arg0_10._tf, arg1_10)
end

return var0_0
