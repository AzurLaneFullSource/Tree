local var0 = class("CrusingWindowLayer", import("view.base.BaseUI"))

function var0.getUIName(arg0)
	return "CrusingWindowUI"
end

function var0.preload(arg0, arg1)
	local var0 = getProxy(ActivityProxy):getAliveActivityByType(ActivityConst.ACTIVITY_TYPE_PT_CRUSING)

	GetSpriteFromAtlasAsync("crusingwindow/" .. var0:getConfig("config_client").map_name, "", function(arg0)
		arg0.windowSprite = arg0

		arg1()
	end)
end

function var0.init(arg0)
	setImageSprite(arg0._tf:Find("panel"), arg0.windowSprite, true)

	arg0.rtBg = arg0._tf:Find("bg")
	arg0.btnBack = arg0._tf:Find("panel/btn_back")
	arg0.btnGo = arg0._tf:Find("panel/btn_go")
	arg0.itemContent = arg0._tf:Find("panel/content")

	local var0 = getProxy(ActivityProxy):getAliveActivityByType(ActivityConst.ACTIVITY_TYPE_PT_CRUSING):getConfig("config_client").equip_skin or {}

	arg0.itemList = UIItemList.New(arg0.itemContent, arg0.itemContent:GetChild(0))

	arg0.itemList:make(function(arg0, arg1, arg2)
		arg1 = arg1 + 1

		if arg0 == UIItemList.EventUpdate then
			local var0 = {}

			var0.type, var0.id, var0.count = unpack(var0[arg1])

			updateDrop(arg2, var0)
			onButton(arg0, arg2, function()
				arg0:emit(var0.ON_DROP, var0)
			end, SFX_PANEL)
		end
	end)
	arg0.itemList:align(#var0)
end

function var0.didEnter(arg0)
	pg.UIMgr.GetInstance():BlurPanel(arg0._tf, false, {
		weight = LayerWeightConst.TOP_LAYER
	})
	onButton(arg0, arg0.rtBg, function()
		arg0:closeView()
	end, SFX_CANCEL)
	onButton(arg0, arg0.btnBack, function()
		arg0:closeView()
	end, SFX_CANCEL)
	onButton(arg0, arg0.btnGo, function()
		arg0:emit(CrusingWindowMediator.GO_CRUSING)
	end, SFX_CONFIRM)
end

function var0.willExit(arg0)
	pg.UIMgr.GetInstance():UnblurPanel(arg0._tf)
end

return var0
