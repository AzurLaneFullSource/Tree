local var0_0 = class("LoveLetterGiftCollectLayer", import("view.base.BaseUI"))

function var0_0.getUIName(arg0_1)
	return "LoveLetterGiftCollectUI"
end

var0_0.optionsPath = {}

function var0_0.init(arg0_2)
	setText(arg0_2.textTitle, i18n("loveactivity_ui_5"))
	setText(arg0_2.textHelp, i18n("loveactivity_ui_7"))
	setText(arg0_2.btnConfirm:Find("Text"), i18n("loveactivity_ui_8"))
	setText(arg0_2.btnSelectConfirm:Find("Text"), i18n("loveactivity_ui_8"))

	arg0_2.itemList = UIItemList.New(arg0_2.rtScrollContent, arg0_2.rtScrollTpl)

	arg0_2.itemList:make(function(arg0_3, arg1_3, arg2_3)
		arg1_3 = arg1_3 + 1

		if arg0_3 == UIItemList.EventUpdate then
			local var0_3 = arg0_2.tempList[arg1_3]

			setText(arg2_3:Find("year"), tostring(var0_3))

			local var1_3 = arg0_2.confirmDic[var0_3]

			setActive(arg2_3:Find("icon/mask/IconTpl"), var1_3)
			setActive(arg2_3:Find("icon/on"), var1_3)
			setActive(arg2_3:Find("now"), var1_3)

			if var1_3 then
				local var2_3, var3_3 = unpack(arg0_2.giftItemList[var1_3])

				updateDrop(arg2_3:Find("icon/mask/IconTpl"), Drop.New({
					count = 1,
					type = DROP_TYPE_ITEM,
					id = var2_3,
					extra = var3_3
				}))

				local var4_3 = getProxy(LoveLetterProxy):GetGroupData(arg0_2.giftGroupList[var1_3])

				setLoveLetterMedal(arg2_3:Find("now/medal"), var4_3)
			end

			setActive(arg2_3:Find("active/active_off"), not var1_3)
			setActive(arg2_3:Find("active/active_on"), var1_3)
			setText(arg2_3:Find("active/Text"), i18n("loveactivity_ui_6"))

			local var5_3 = not var1_3 and arg0_2.heap:GetLength() > 0 and var0_3 == arg0_2.heap:GetTop().element

			setActive(arg2_3:Find("icon/tip"), var5_3)
			setButtonEnabled(arg2_3:Find("icon"), var5_3)

			if var5_3 then
				onButton(arg0_2, arg2_3:Find("icon"), function()
					arg0_2:OpenSelectWindow(var0_3)
				end, SFX_PANEL)
			end
		end
	end)
	setActive(arg0_2.rtPanel, true)
	setActive(arg0_2.rtSelectWindow, false)
	arg0_2:BlurPanel(arg0_2._tf)
end

function var0_0.didEnter(arg0_5)
	onButton(arg0_5, arg0_5.rtBg, function()
		if isActive(arg0_5.rtSelectWindow) then
			arg0_5:CloseSelectWindow()
		else
			arg0_5:closeView()
		end
	end, SFX_CANCEL)
	onButton(arg0_5, arg0_5.btnClose, function()
		arg0_5:closeView()
	end, SFX_PANEL)
	onButton(arg0_5, arg0_5.btnConfirm, function()
		if arg0_5.heap:GetLength() > 0 then
			pg.TipsMgr.GetInstance():ShowTips(i18n("loveactivity_ui_19"))

			return
		end

		local var0_8 = {}

		for iter0_8, iter1_8 in pairs(arg0_5.confirmDic) do
			local var1_8, var2_8 = unpack(arg0_5.giftItemList[iter1_8])

			table.insert(var0_8, {
				year = iter0_8,
				group_id = var2_8 or arg0_5.giftGroupList[iter1_8],
				item_id = var1_8
			})
		end

		arg0_5:emit(LoveLetterGiftCollectMediator.ON_RECORD_GIFT, var0_8)
	end, SFX_PANEL)
	onButton(arg0_5, arg0_5.btnSelectClose, function()
		arg0_5:CloseSelectWindow()
	end, SFX_CANCEL)
	arg0_5:InitGift()
	arg0_5:DropHump()
	arg0_5:UpdateDisplay()
end

function var0_0.InitGift(arg0_10)
	arg0_10.giftItemList = underscore.to_array(arg0_10.contextData.items)
	arg0_10.giftGroupList = {}

	local var0_10, var1_10, var2_10 = getProxy(LoveLetterProxy):GetLoveLetterItemDic()
	local var3_10 = {}

	for iter0_10, iter1_10 in ipairs(arg0_10.giftItemList) do
		local var4_10, var5_10 = unpack(iter1_10)

		assert(tobool(var5_10) == (pg.item_data_statistics[var4_10].type == Item.LOVE_LETTER_TYPE))

		local var6_10 = var5_10 and var2_10[var5_10] or var5_10 or 0

		for iter2_10, iter3_10 in pairs(var0_10[var4_10 .. "_" .. var6_10]) do
			assert(not arg0_10.giftGroupList[iter0_10] or arg0_10.giftGroupList[iter0_10] == iter3_10)

			arg0_10.giftGroupList[iter0_10] = iter3_10
			var3_10[iter2_10] = var3_10[iter2_10] or {}

			table.insert(var3_10[iter2_10], iter0_10)
		end
	end

	arg0_10.itemDic = var0_10
	arg0_10.yearDic = var3_10
	arg0_10.confirmDic = {}
	arg0_10.heap = Heap.New(underscore.keys(var3_10), function(arg0_11)
		return #var3_10[arg0_11]
	end)
	arg0_10.tempList = underscore(arg0_10.yearDic):chain():keys():sort():value()

	assert(#arg0_10.giftItemList <= #arg0_10.tempList)
end

function var0_0.ConfirmItem(arg0_12, arg1_12, arg2_12)
	arg0_12.confirmDic[arg1_12] = arg2_12

	for iter0_12, iter1_12 in pairs(arg0_12.yearDic) do
		if table.removebyvalue(arg0_12.yearDic[iter0_12], arg2_12) > 0 then
			arg0_12.heap:UpdateValue(iter0_12)
		end
	end
end

function var0_0.DropHump(arg0_13)
	while arg0_13.heap:GetLength() > 0 and arg0_13.heap:GetTop().value == 1 do
		local var0_13, var1_13 = arg0_13.heap:POP()
		local var2_13 = arg0_13.yearDic[var0_13][1]

		arg0_13:ConfirmItem(var0_13, var2_13)
	end
end

function var0_0.UpdateDisplay(arg0_14)
	arg0_14.itemList:align(#arg0_14.tempList)
end

function var0_0.OpenSelectWindow(arg0_15, arg1_15)
	setText(arg0_15.textSelectTitile, i18n("loveactivity_ui_9", arg1_15))
	setActive(arg0_15.rtPanel, false)
	setActive(arg0_15.rtSelectWindow, true)

	local var0_15

	UIItemList.StaticAlign(arg0_15.rtSelectScrollContent, arg0_15.rtSelectScrollTpl, #arg0_15.yearDic[arg1_15], function(arg0_16, arg1_16, arg2_16)
		arg1_16 = arg1_16 + 1

		if arg0_16 == UIItemList.EventUpdate then
			local var0_16 = arg0_15.yearDic[arg1_15][arg1_16]
			local var1_16, var2_16 = unpack(arg0_15.giftItemList[var0_16])

			updateDrop(arg2_16:Find("mask/IconTpl"), Drop.New({
				count = 1,
				type = DROP_TYPE_ITEM,
				id = var1_16,
				extra = var2_16
			}))
			onToggle(arg0_15, arg2_16, function(arg0_17)
				if arg0_17 then
					var0_15 = var0_16
				end
			end, SFX_PANEL)
		end
	end)
	triggerToggle(arg0_15.rtSelectScrollContent:GetChild(0), true)
	onButton(arg0_15, arg0_15.btnSelectConfirm, function()
		arg0_15.heap:POP(arg1_15)
		arg0_15:ConfirmItem(arg1_15, var0_15)
		arg0_15:DropHump()
		arg0_15:UpdateDisplay()
		arg0_15:CloseSelectWindow()
	end, SFX_CONFIRM)
end

function var0_0.CloseSelectWindow(arg0_19)
	setActive(arg0_19.rtPanel, true)
	setActive(arg0_19.rtSelectWindow, false)
end

function var0_0.willExit(arg0_20)
	arg0_20:UnOverlayPanel(arg0_20._tf)
	arg0_20.itemList:each(function(arg0_21, arg1_21)
		arg0_21 = arg0_21 + 1

		eachChild(arg1_21:Find("now/medal"), function(arg0_22, arg1_22)
			returnLoveLetterMedal(arg0_22)
		end)
	end)
end

return var0_0
