local var0_0 = class("IslandMsgBoxSingleItemWindow", import(".IslandCommonMsgboxWindow"))

function var0_0.getUIName(arg0_1)
	return "IslandCommonMsgBoxWithSingleItem"
end

function var0_0.OnLoaded(arg0_2)
	var0_0.super.OnLoaded(arg0_2)

	arg0_2.itemTr = arg0_2._tf:Find("IslandItemTpl")
	arg0_2.nameTxt = arg0_2._tf:Find("name"):GetComponent(typeof(Text))
	arg0_2.ownTxt = arg0_2._tf:Find("own"):GetComponent(typeof(Text))
	arg0_2.uiItemList = UIItemList.New(arg0_2._tf:Find("way/Viewport/list"), arg0_2._tf:Find("way/Viewport/list/tpl"))
	arg0_2.contentTF = arg0_2._tf:Find("way/Viewport/list")

	setText(arg0_2._tf:Find("label/Text"), i18n("island_get_way"))
end

function var0_0.OnShow(arg0_3)
	var0_0.super.OnShow(arg0_3)

	local var0_3 = arg0_3.settings.itemId

	arg0_3:FlushMain(var0_3)
	arg0_3:FlushAcquiringWay(var0_3)
end

function var0_0.FlushMain(arg0_4, arg1_4)
	local var0_4 = pg.island_item_data_template[arg1_4]

	arg0_4.nameTxt.text = var0_4.name
	arg0_4.contentTxt.text = var0_4.desc

	local var1_4 = getProxy(IslandProxy):GetIsland():GetInventoryAgency():GetOwnCount(arg1_4)

	arg0_4.ownTxt.text = i18n("island_own_cnt") .. setColorStr(var1_4, "#39beff")

	local var2_4 = Drop.New({
		count = 0,
		type = DROP_TYPE_ISLAND_ITEM,
		id = arg1_4
	})

	updateCustomDrop(arg0_4.itemTr, var2_4)
end

function var0_0.FlushAcquiringWay(arg0_5, arg1_5)
	local var0_5 = IslandItem.New({
		num = 0,
		id = arg1_5
	}):GetAcquiringWay()
	local var1_5 = #var0_5 > 0

	setActive(arg0_5._tf:Find("line"), var1_5)
	setActive(arg0_5._tf:Find("label"), var1_5)
	setActive(arg0_5._tf:Find("way"), var1_5)
	arg0_5.uiItemList:make(function(arg0_6, arg1_6, arg2_6)
		if arg0_6 == UIItemList.EventUpdate then
			local var0_6 = var0_5[arg1_6 + 1]

			setText(arg2_6:Find("Text"), var0_6[1])
			setText(arg2_6:Find("go/Text"), i18n("island_word_go"))
			onButton(arg0_5, arg2_6:Find("go"), function()
				local var0_7 = Clone(var0_6[2])
				local var1_7 = var0_7[1]

				table.remove(var0_7, 1)
				arg0_5:GetMsgBoxMgr():emit(IslandMediator.OPEN_PAGE, var1_7, var0_7)
				arg0_5:Hide()
			end, SFX_PANEL)
			setActive(arg2_6:Find("go"), var0_6[2] and #var0_6[2] > 0)
		end
	end)
	arg0_5.uiItemList:align(#var0_5)

	if not IsNil(arg0_5.contentTF) then
		setAnchoredPosition(arg0_5.contentTF, {
			x = 0,
			y = 0
		})
	end
end

function var0_0.FlushBtn(arg0_8, arg1_8)
	setActive(arg0_8.cancelBtn, false)
end

return var0_0
