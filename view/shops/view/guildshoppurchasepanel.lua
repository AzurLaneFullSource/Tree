local var0_0 = class("GuildShopPurchasePanel", import("...base.BaseSubView"))

function var0_0.getUIName(arg0_1)
	return "GuildShopPurchaseMsgUI"
end

function var0_0.OnLoaded(arg0_2)
	arg0_2.list = UIItemList.New(arg0_2:findTF("got/bottom/scroll/list"), arg0_2:findTF("got/bottom/scroll/list/tpl"))
	arg0_2.confirmBtn = arg0_2:findTF("confirm")
	arg0_2.descTxt = arg0_2:findTF("got/top/desc"):GetComponent(typeof(Text))
	arg0_2.exchagneCnt = arg0_2:findTF("got/top/exchange/Text"):GetComponent(typeof(Text))
	arg0_2.consumeCnt = arg0_2:findTF("confirm/consume/Text"):GetComponent(typeof(Text))
	arg0_2.title = arg0_2:findTF("got/top/title")

	setText(arg0_2:findTF("got/top/exchange/label"), i18n("guild_shop_label_2"))
	setText(arg0_2:findTF("confirm/Text"), i18n("guild_shop_label_3"))
	setText(arg0_2:findTF("confirm/consume/label"), i18n("guild_shop_label_4"))

	arg0_2.resIcon = arg0_2:findTF("confirm/consume/icon")
end

function var0_0.OnInit(arg0_3)
	onButton(arg0_3, arg0_3.confirmBtn, function()
		if #arg0_3.selectedList == 0 then
			pg.TipsMgr.GetInstance():ShowTips(i18n("guild_shop_must_select_goods"))

			return
		end

		arg0_3:OnConfirm()
		arg0_3:Hide()
	end, SFX_PANEL)
	onButton(arg0_3, arg0_3._tf, function()
		arg0_3:Hide()
	end, SFX_PANEL)
end

function var0_0.OnConfirm(arg0_6)
	arg0_6:emit(NewShopsMediator.ON_GUILD_SHOPPING, arg0_6.data.id, arg0_6.selectedList)
end

function var0_0.Show(arg0_7, arg1_7)
	var0_0.super.Show(arg0_7)
	pg.UIMgr.GetInstance():BlurPanel(arg0_7._tf)

	arg0_7.data = arg1_7
	arg0_7.maxCnt = arg1_7.count
	arg0_7.selectedList = {}

	arg0_7:InitList()
	arg0_7:UpdateValue()

	if arg1_7.type == 4 then
		setText(arg0_7.title, i18n("guild_shop_label_5"))
	else
		setText(arg0_7.title, i18n("guild_shop_label_1"))
	end

	arg0_7.descTxt.text = ""
end

function var0_0.UpdateValue(arg0_8)
	local var0_8 = arg0_8.maxCnt - #arg0_8.selectedList
	local var1_8 = var0_8 > 0 and "<color=#92FC63FF>" .. var0_8 .. "</color>/" or "<color=#FF5C5CFF>" .. var0_8 .. "</color>/"

	arg0_8.exchagneCnt.text = var1_8 .. arg0_8.maxCnt
	arg0_8.consumeCnt.text = arg0_8.data.price * #arg0_8.selectedList
end

function var0_0.InitList(arg0_9)
	local var0_9 = arg0_9.data

	arg0_9.displays = var0_9.displays

	arg0_9.list:make(function(arg0_10, arg1_10, arg2_10)
		if arg0_10 == UIItemList.EventUpdate then
			local var0_10 = arg0_9.displays[arg1_10 + 1]

			arg0_9:UpdateItem(var0_9, var0_10, arg2_10)
		end
	end)
	arg0_9.list:align(#arg0_9.displays)
end

function var0_0.UpdateItem(arg0_11, arg1_11, arg2_11, arg3_11)
	local var0_11 = arg1_11.type

	updateDrop(arg3_11:Find("item/bg"), {
		type = var0_11,
		id = arg2_11,
		count = arg1_11.num
	})

	local var1_11 = Drop.New({
		type = var0_11,
		id = arg2_11
	})
	local var2_11 = arg3_11:Find("name_bg/Text"):GetComponent("ScrollText")
	local var3_11 = var1_11:getConfig("name")

	var2_11:SetText(var3_11)

	local var4_11 = arg3_11:Find("cnt/Text"):GetComponent(typeof(Text))

	local function var5_11()
		local var0_12 = 0

		for iter0_12, iter1_12 in ipairs(arg0_11.selectedList) do
			if iter1_12 == arg2_11 then
				var0_12 = var0_12 + 1
			end
		end

		var4_11.text = var0_12
	end

	onButton(arg0_11, arg3_11, function()
		arg0_11:ClickItem(arg3_11, arg2_11)
	end, SFX_PANEL)
	pressPersistTrigger(arg3_11:Find("cnt/minus"), 0.5, function()
		arg0_11:PressMinusBtn(arg3_11, arg2_11)
		var5_11()
	end, nil, true, true, 0.1, SFX_PANEL)
	pressPersistTrigger(arg3_11:Find("cnt/add"), 0.5, function()
		arg0_11:PressAddBtn(arg3_11, arg2_11)
		var5_11()
	end, nil, true, true, 0.1, SFX_PANEL)

	local var6_11 = arg3_11:Find("mask")

	setActive(var6_11, false)
	var5_11()
end

function var0_0.ClearZeroItem(arg0_16, arg1_16)
	arg0_16.list:each(function(arg0_17, arg1_17)
		local var0_17 = arg0_16.displays[arg0_17 + 1]

		if arg1_16 ~= arg1_17 and not table.contains(arg0_16.selectedList, var0_17) then
			setActive(arg1_17:Find("cnt"), false)
			setActive(arg1_17:Find("selected"), false)
		end
	end)
end

function var0_0.ClickItem(arg0_18, arg1_18, arg2_18)
	arg0_18:ClearZeroItem(arg1_18)
	setActive(arg1_18:Find("cnt"), true)
	setActive(arg1_18:Find("selected"), true)
end

function var0_0.PressMinusBtn(arg0_19, arg1_19, arg2_19)
	if #arg0_19.selectedList == 0 then
		return
	end

	for iter0_19, iter1_19 in ipairs(arg0_19.selectedList) do
		if iter1_19 == arg2_19 then
			table.remove(arg0_19.selectedList, iter0_19)

			break
		end
	end

	arg0_19:UpdateValue()
end

function var0_0.PressAddBtn(arg0_20, arg1_20, arg2_20)
	if #arg0_20.selectedList == arg0_20.maxCnt then
		return
	end

	table.insert(arg0_20.selectedList, arg2_20)
	arg0_20:UpdateValue()
end

function var0_0.Hide(arg0_21)
	if arg0_21:isShowing() then
		pg.UIMgr.GetInstance():UnblurPanel(arg0_21._tf, arg0_21._parentTf)
	end

	arg0_21.list:each(function(arg0_22, arg1_22)
		setActive(arg1_22:Find("cnt"), false)
		setActive(arg1_22:Find("selected"), false)
	end)
	var0_0.super.Hide(arg0_21)
end

function var0_0.OnDestroy(arg0_23)
	arg0_23:Hide()
end

return var0_0
