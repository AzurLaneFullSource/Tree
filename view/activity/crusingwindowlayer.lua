local var0_0 = class("CrusingWindowLayer", import("view.base.BaseUI"))

function var0_0.getUIName(arg0_1)
	return "CrusingWindowUI"
end

function var0_0.preload(arg0_2, arg1_2)
	local var0_2 = getProxy(ActivityProxy):getAliveActivityByType(ActivityConst.ACTIVITY_TYPE_PT_CRUSING)

	GetSpriteFromAtlasAsync("crusingwindow/map_20" .. pg.battlepass_event_pt[var0_2.id].map_name, "", function(arg0_3)
		arg0_2.windowSprite = arg0_3

		arg1_2()
	end)
end

function var0_0.getResource(arg0_4)
	local var0_4 = var0_0.super.getResource(arg0_4)
	local var1_4 = {
		"crusingwindow"
	}

	for iter0_4, iter1_4 in ipairs(var1_4 or {}) do
		if not table.contains(var0_4, iter1_4) then
			table.insert(var0_4, iter1_4)
		end
	end

	return var0_4
end

function var0_0.init(arg0_5)
	setImageSprite(arg0_5._tf:Find("panel"), arg0_5.windowSprite, true)

	arg0_5.rtBg = arg0_5._tf:Find("bg")
	arg0_5.btnBack = arg0_5._tf:Find("panel/btn_back")
	arg0_5.btnGo = arg0_5._tf:Find("panel/btn_go")
	arg0_5.itemContent = arg0_5._tf:Find("panel/content")

	local var0_5 = getProxy(ActivityProxy):getAliveActivityByType(ActivityConst.ACTIVITY_TYPE_PT_CRUSING)
	local var1_5 = pg.battlepass_event_pt[var0_5.id].equip_skin or {}

	arg0_5.itemList = UIItemList.New(arg0_5.itemContent, arg0_5.itemContent:GetChild(0))

	arg0_5.itemList:make(function(arg0_6, arg1_6, arg2_6)
		arg1_6 = arg1_6 + 1

		if arg0_6 == UIItemList.EventUpdate then
			local var0_6 = {}

			var0_6.type, var0_6.id, var0_6.count = unpack(var1_5[arg1_6])

			updateDrop(arg2_6, var0_6)
			onButton(arg0_5, arg2_6, function()
				arg0_5:emit(var0_0.ON_DROP, var0_6)
			end, SFX_PANEL)
		end
	end)
	arg0_5.itemList:align(#var1_5)
end

function var0_0.didEnter(arg0_8)
	pg.UIMgr.GetInstance():BlurPanel(arg0_8._tf)
	onButton(arg0_8, arg0_8.rtBg, function()
		arg0_8:closeView()
	end, SFX_CANCEL)
	onButton(arg0_8, arg0_8.btnBack, function()
		arg0_8:closeView()
	end, SFX_CANCEL)
	onButton(arg0_8, arg0_8.btnGo, function()
		arg0_8:emit(CrusingWindowMediator.GO_CRUSING)
	end, SFX_CONFIRM)
end

function var0_0.willExit(arg0_12)
	pg.UIMgr.GetInstance():UnOverlayPanel(arg0_12._tf)
end

return var0_0
