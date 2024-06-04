local var0 = class("OtherWorldTempleAward")
local var1 = "other_world_temple_award_last"
local var2 = "other_world_temple_award_title_1"
local var3 = "other_world_temple_award_title_2"
local var4 = "other_world_temple_award_title_3"
local var5 = {
	var2,
	var3,
	var4
}

function var0.Ctor(arg0, arg1, arg2)
	arg0._tf = arg1
	arg0._event = arg2

	onButton(arg0._event, findTF(arg0._tf, "ad/btnClose"), function()
		arg0:setActive(false)
	end, SFX_CANCEL)
	onButton(arg0._event, findTF(arg0._tf, "ad/clickClose"), function()
		arg0:setActive(false)
	end, SFX_CANCEL)

	arg0._awardTpl = findTF(arg0._tf, "ad/awards/content/awardTpl")

	setActive(arg0._awardTpl, false)

	arg0._awardItems = {}
	arg0._awardContent = findTF(arg0._tf, "ad/awards/content")
end

function var0.setData(arg0, arg1, arg2)
	arg0.templeIds = arg1
	arg0.shopDatasList = arg2
end

function var0.updateActivityPool(arg0, arg1)
	arg0.activityPools = arg1
end

function var0.updateSelect(arg0, arg1)
	local var0 = arg0.shopDatasList[arg1]

	arg0:updateItemsCount(#var0)

	arg0.selectPool = arg0.activityPools[arg0.templeIds[arg1]]

	for iter0 = 1, #arg0._awardItems do
		local var1 = arg0._awardItems[iter0]

		setActive(var1, false)

		if iter0 <= #var0 then
			setActive(var1, true)
			arg0:setItemData(var1, var0[iter0])
		end
	end

	setText(findTF(arg0._tf, "ad/title/text"), i18n(var5[arg1]))
end

function var0.setItemData(arg0, arg1, arg2)
	local var0 = arg2.id
	local var1 = arg2.count
	local var2 = var1 - (arg0.selectPool.awards[var0] or 0)
	local var3 = pg.activity_random_award_item[var0]
	local var4 = Drop.New({
		type = var3.resource_category,
		id = var3.commodity_id,
		count = var3.num
	})

	updateDrop(findTF(arg1, "ad/icon/IconTpl"), var4)
	onButton(arg0._event, arg1, function()
		arg0._event:emit(BaseUI.ON_DROP, var4)
	end, SFX_PANEL)
	setScrollText(findTF(arg1, "ad/name/text"), var4:getName())
	setText(findTF(arg1, "ad/amount/text"), i18n(var1, var2, var1))
	setActive(findTF(arg1, "ad/soldOut"), var2 == 0)
end

function var0.updateItemsCount(arg0, arg1)
	local var0 = 0

	if arg1 > #arg0._awardItems then
		var0 = arg1 - #arg0._awardItems
	end

	for iter0 = 1, var0 do
		local var1 = tf(instantiate(arg0._awardTpl))

		SetParent(var1, arg0._awardContent)
		table.insert(arg0._awardItems, var1)
	end
end

function var0.setActive(arg0, arg1)
	setActive(arg0._tf, arg1)
end

return var0
