local var0_0 = class("CrusingWindowLayer", import("view.base.BaseUI"))

function var0_0.getUIName(arg0_1)
	return "CrusingWindowUI"
end

function var0_0.preload(arg0_2, arg1_2)
	local var0_2 = getProxy(ActivityProxy):getAliveActivityByType(ActivityConst.ACTIVITY_TYPE_PT_CRUSING)

	GetSpriteFromAtlasAsync("crusingwindow/" .. var0_2:getConfig("config_client").map_name, "", function(arg0_3)
		arg0_2.windowSprite = arg0_3

		arg1_2()
	end)
end

function var0_0.init(arg0_4)
	setImageSprite(arg0_4._tf:Find("panel"), arg0_4.windowSprite, true)

	arg0_4.rtBg = arg0_4._tf:Find("bg")
	arg0_4.btnBack = arg0_4._tf:Find("panel/btn_back")
	arg0_4.btnGo = arg0_4._tf:Find("panel/btn_go")
	arg0_4.itemContent = arg0_4._tf:Find("panel/content")

	local var0_4 = getProxy(ActivityProxy):getAliveActivityByType(ActivityConst.ACTIVITY_TYPE_PT_CRUSING):getConfig("config_client").equip_skin or {}

	arg0_4.itemList = UIItemList.New(arg0_4.itemContent, arg0_4.itemContent:GetChild(0))

	arg0_4.itemList:make(function(arg0_5, arg1_5, arg2_5)
		arg1_5 = arg1_5 + 1

		if arg0_5 == UIItemList.EventUpdate then
			local var0_5 = {}

			var0_5.type, var0_5.id, var0_5.count = unpack(var0_4[arg1_5])

			updateDrop(arg2_5, var0_5)
			onButton(arg0_4, arg2_5, function()
				arg0_4:emit(var0_0.ON_DROP, var0_5)
			end, SFX_PANEL)
		end
	end)
	arg0_4.itemList:align(#var0_4)
end

function var0_0.didEnter(arg0_7)
	pg.UIMgr.GetInstance():BlurPanel(arg0_7._tf, false, {
		weight = LayerWeightConst.TOP_LAYER
	})
	onButton(arg0_7, arg0_7.rtBg, function()
		arg0_7:closeView()
	end, SFX_CANCEL)
	onButton(arg0_7, arg0_7.btnBack, function()
		arg0_7:closeView()
	end, SFX_CANCEL)
	onButton(arg0_7, arg0_7.btnGo, function()
		arg0_7:emit(CrusingWindowMediator.GO_CRUSING)
	end, SFX_CONFIRM)
end

function var0_0.willExit(arg0_11)
	pg.UIMgr.GetInstance():UnblurPanel(arg0_11._tf)
end

return var0_0
