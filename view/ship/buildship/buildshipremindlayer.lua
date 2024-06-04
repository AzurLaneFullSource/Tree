local var0 = class("BuildShipRemindLayer", import("...base.BaseUI"))

function var0.getUIName(arg0)
	return "BuildShipRemindUI"
end

function var0.setShips(arg0, arg1)
	arg0.ships = arg1
end

function var0.init(arg0)
	local var0 = arg0._tf:Find("window")

	setText(var0:Find("top/bg/infomation/title"), i18n("title_info"))

	arg0.btnBack = var0:Find("top/btnBack")
	arg0.btnConfirm = var0:Find("button_container/confirm")

	setText(arg0.btnConfirm:Find("pic"), i18n("text_confirm"))

	local var1 = var0:Find("item_panel")

	setText(var1:Find("word/Text"), i18n("last_building_not_shown"))

	arg0.toggleLock = var1:Find("lock_toggle")

	local var2 = var1:Find("scrollview")

	arg0.shipItemList = UIItemList.New(var2, var2:Find("item_tpl"))

	arg0.shipItemList:make(function(arg0, arg1, arg2)
		arg1 = arg1 + 1

		if arg0 == UIItemList.EventUpdate then
			local var0 = arg0.ships[arg1]
			local var1 = {
				count = 1,
				type = DROP_TYPE_SHIP,
				id = var0.configId,
				virgin = var0.virgin
			}

			updateDrop(arg2:Find("IconTpl"), var1)
			onButton(arg0, arg2, function()
				arg0:emit(var0.ON_DROP, var1)
			end, SFX_PANEL)
			onLongPressTrigger(arg0, arg2, function()
				arg0:emit(BuildShipRemindMediator.SHOW_NEW_SHIP, var0)
			end, SFX_PANEL)
		end
	end)
end

function var0.didEnter(arg0)
	pg.UIMgr.GetInstance():BlurPanel(arg0._tf, false, {
		weight = LayerWeightConst.BASE_LAYER + 1
	})
	onButton(arg0, arg0.btnBack, function()
		arg0:exitCheck()
	end, SFX_CANCEL)
	onButton(arg0, arg0.btnConfirm, function()
		arg0:exitCheck()
	end, SFX_CONFIRM)
	onToggle(arg0, arg0.toggleLock, function(arg0)
		arg0.isLockNew = arg0
	end, SFX_PANEL)
	triggerToggle(arg0.toggleLock, false)
	arg0.shipItemList:align(#arg0.ships)
end

function var0.exitCheck(arg0)
	local var0 = {}

	if arg0.isLockNew then
		local var1 = underscore(arg0.ships):chain():filter(function(arg0)
			return arg0.virgin
		end):map(function(arg0)
			return arg0.id
		end):value()

		if #var1 > 0 then
			table.insert(var0, function(arg0)
				arg0:emit(BuildShipRemindMediator.ON_LOCK, var1, Ship.LOCK_STATE_LOCK, arg0)
			end)
		end
	end

	seriesAsync(var0, function()
		arg0:closeView()
	end)
end

function var0.onBackPressed(arg0)
	return
end

function var0.willExit(arg0)
	pg.UIMgr.GetInstance():UnblurPanel(arg0._tf)
end

return var0
