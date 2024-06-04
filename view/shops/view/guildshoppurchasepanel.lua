local var0 = class("GuildShopPurchasePanel", import("...base.BaseSubView"))

function var0.getUIName(arg0)
	return "GuildShopPurchaseMsgUI"
end

function var0.OnLoaded(arg0)
	arg0.list = UIItemList.New(arg0:findTF("got/bottom/scroll/list"), arg0:findTF("got/bottom/scroll/list/tpl"))
	arg0.confirmBtn = arg0:findTF("confirm")
	arg0.descTxt = arg0:findTF("got/top/desc"):GetComponent(typeof(Text))
	arg0.exchagneCnt = arg0:findTF("got/top/exchange/Text"):GetComponent(typeof(Text))
	arg0.consumeCnt = arg0:findTF("confirm/consume/Text"):GetComponent(typeof(Text))
	arg0.title = arg0:findTF("got/top/title")

	setText(arg0:findTF("got/top/exchange/label"), i18n("guild_shop_label_2"))
	setText(arg0:findTF("confirm/Text"), i18n("guild_shop_label_3"))
	setText(arg0:findTF("confirm/consume/label"), i18n("guild_shop_label_4"))

	arg0.resIcon = arg0:findTF("confirm/consume/icon")
end

function var0.OnInit(arg0)
	onButton(arg0, arg0.confirmBtn, function()
		if #arg0.selectedList == 0 then
			pg.TipsMgr.GetInstance():ShowTips(i18n("guild_shop_must_select_goods"))

			return
		end

		arg0:OnConfirm()
		arg0:Hide()
	end, SFX_PANEL)
	onButton(arg0, arg0._tf, function()
		arg0:Hide()
	end, SFX_PANEL)
end

function var0.OnConfirm(arg0)
	arg0:emit(NewShopsMediator.ON_GUILD_SHOPPING, arg0.data.id, arg0.selectedList)
end

function var0.Show(arg0, arg1)
	var0.super.Show(arg0)
	pg.UIMgr.GetInstance():BlurPanel(arg0._tf)

	arg0.data = arg1
	arg0.maxCnt = arg1.count
	arg0.selectedList = {}

	arg0:InitList()
	arg0:UpdateValue()

	if arg1.type == 4 then
		setText(arg0.title, i18n("guild_shop_label_5"))
	else
		setText(arg0.title, i18n("guild_shop_label_1"))
	end

	arg0.descTxt.text = ""
end

function var0.UpdateValue(arg0)
	local var0 = arg0.maxCnt - #arg0.selectedList
	local var1 = var0 > 0 and "<color=#92FC63FF>" .. var0 .. "</color>/" or "<color=#FF5C5CFF>" .. var0 .. "</color>/"

	arg0.exchagneCnt.text = var1 .. arg0.maxCnt
	arg0.consumeCnt.text = arg0.data.price * #arg0.selectedList
end

function var0.InitList(arg0)
	local var0 = arg0.data

	arg0.displays = var0.displays

	arg0.list:make(function(arg0, arg1, arg2)
		if arg0 == UIItemList.EventUpdate then
			local var0 = arg0.displays[arg1 + 1]

			arg0:UpdateItem(var0, var0, arg2)
		end
	end)
	arg0.list:align(#arg0.displays)
end

function var0.UpdateItem(arg0, arg1, arg2, arg3)
	local var0 = arg1.type

	updateDrop(arg3:Find("item/bg"), {
		type = var0,
		id = arg2,
		count = arg1.num
	})

	local var1 = Drop.New({
		type = var0,
		id = arg2
	})
	local var2 = arg3:Find("name_bg/Text"):GetComponent("ScrollText")
	local var3 = var1:getConfig("name")

	var2:SetText(var3)

	local var4 = arg3:Find("cnt/Text"):GetComponent(typeof(Text))

	local function var5()
		local var0 = 0

		for iter0, iter1 in ipairs(arg0.selectedList) do
			if iter1 == arg2 then
				var0 = var0 + 1
			end
		end

		var4.text = var0
	end

	onButton(arg0, arg3, function()
		arg0:ClickItem(arg3, arg2)
	end, SFX_PANEL)
	pressPersistTrigger(arg3:Find("cnt/minus"), 0.5, function()
		arg0:PressMinusBtn(arg3, arg2)
		var5()
	end, nil, true, true, 0.1, SFX_PANEL)
	pressPersistTrigger(arg3:Find("cnt/add"), 0.5, function()
		arg0:PressAddBtn(arg3, arg2)
		var5()
	end, nil, true, true, 0.1, SFX_PANEL)

	local var6 = arg3:Find("mask")

	setActive(var6, false)
	var5()
end

function var0.ClearZeroItem(arg0, arg1)
	arg0.list:each(function(arg0, arg1)
		local var0 = arg0.displays[arg0 + 1]

		if arg1 ~= arg1 and not table.contains(arg0.selectedList, var0) then
			setActive(arg1:Find("cnt"), false)
			setActive(arg1:Find("selected"), false)
		end
	end)
end

function var0.ClickItem(arg0, arg1, arg2)
	arg0:ClearZeroItem(arg1)
	setActive(arg1:Find("cnt"), true)
	setActive(arg1:Find("selected"), true)
end

function var0.PressMinusBtn(arg0, arg1, arg2)
	if #arg0.selectedList == 0 then
		return
	end

	for iter0, iter1 in ipairs(arg0.selectedList) do
		if iter1 == arg2 then
			table.remove(arg0.selectedList, iter0)

			break
		end
	end

	arg0:UpdateValue()
end

function var0.PressAddBtn(arg0, arg1, arg2)
	if #arg0.selectedList == arg0.maxCnt then
		return
	end

	table.insert(arg0.selectedList, arg2)
	arg0:UpdateValue()
end

function var0.Hide(arg0)
	if arg0:isShowing() then
		pg.UIMgr.GetInstance():UnblurPanel(arg0._tf, arg0._parentTf)
	end

	arg0.list:each(function(arg0, arg1)
		setActive(arg1:Find("cnt"), false)
		setActive(arg1:Find("selected"), false)
	end)
	var0.super.Hide(arg0)
end

function var0.OnDestroy(arg0)
	arg0:Hide()
end

return var0
