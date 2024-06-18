local var0_0 = class("BuildShipRemindLayer", import("...base.BaseUI"))

function var0_0.getUIName(arg0_1)
	return "BuildShipRemindUI"
end

function var0_0.setShips(arg0_2, arg1_2)
	arg0_2.ships = arg1_2
end

function var0_0.init(arg0_3)
	local var0_3 = arg0_3._tf:Find("window")

	setText(var0_3:Find("top/bg/infomation/title"), i18n("title_info"))

	arg0_3.btnBack = var0_3:Find("top/btnBack")
	arg0_3.btnConfirm = var0_3:Find("button_container/confirm")

	setText(arg0_3.btnConfirm:Find("pic"), i18n("text_confirm"))

	local var1_3 = var0_3:Find("item_panel")

	setText(var1_3:Find("word/Text"), i18n("last_building_not_shown"))

	arg0_3.toggleLock = var1_3:Find("lock_toggle")

	local var2_3 = var1_3:Find("scrollview")

	arg0_3.shipItemList = UIItemList.New(var2_3, var2_3:Find("item_tpl"))

	arg0_3.shipItemList:make(function(arg0_4, arg1_4, arg2_4)
		arg1_4 = arg1_4 + 1

		if arg0_4 == UIItemList.EventUpdate then
			local var0_4 = arg0_3.ships[arg1_4]
			local var1_4 = {
				count = 1,
				type = DROP_TYPE_SHIP,
				id = var0_4.configId,
				virgin = var0_4.virgin
			}

			updateDrop(arg2_4:Find("IconTpl"), var1_4)
			onButton(arg0_3, arg2_4, function()
				arg0_3:emit(var0_0.ON_DROP, var1_4)
			end, SFX_PANEL)
			onLongPressTrigger(arg0_3, arg2_4, function()
				arg0_3:emit(BuildShipRemindMediator.SHOW_NEW_SHIP, var0_4)
			end, SFX_PANEL)
		end
	end)
end

function var0_0.didEnter(arg0_7)
	pg.UIMgr.GetInstance():BlurPanel(arg0_7._tf, false, {
		weight = LayerWeightConst.BASE_LAYER + 1
	})
	onButton(arg0_7, arg0_7.btnBack, function()
		arg0_7:exitCheck()
	end, SFX_CANCEL)
	onButton(arg0_7, arg0_7.btnConfirm, function()
		arg0_7:exitCheck()
	end, SFX_CONFIRM)
	onToggle(arg0_7, arg0_7.toggleLock, function(arg0_10)
		arg0_7.isLockNew = arg0_10
	end, SFX_PANEL)
	triggerToggle(arg0_7.toggleLock, false)
	arg0_7.shipItemList:align(#arg0_7.ships)
end

function var0_0.exitCheck(arg0_11)
	local var0_11 = {}

	if arg0_11.isLockNew then
		local var1_11 = underscore(arg0_11.ships):chain():filter(function(arg0_12)
			return arg0_12.virgin
		end):map(function(arg0_13)
			return arg0_13.id
		end):value()

		if #var1_11 > 0 then
			table.insert(var0_11, function(arg0_14)
				arg0_11:emit(BuildShipRemindMediator.ON_LOCK, var1_11, Ship.LOCK_STATE_LOCK, arg0_14)
			end)
		end
	end

	seriesAsync(var0_11, function()
		arg0_11:closeView()
	end)
end

function var0_0.onBackPressed(arg0_16)
	return
end

function var0_0.willExit(arg0_17)
	pg.UIMgr.GetInstance():UnblurPanel(arg0_17._tf)
end

return var0_0
