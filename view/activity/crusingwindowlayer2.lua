local var0_0 = class("CrusingWindowLayer2", import("view.activity.CrusingWindowLayer"))

function var0_0.getUIName(arg0_1)
	return "CrusingWindowUI2"
end

function var0_0.init(arg0_2)
	setImageSprite(arg0_2._tf:Find("panel"), arg0_2.windowSprite, true)

	arg0_2.rtBg = arg0_2._tf:Find("bg")
	arg0_2.btnGo = arg0_2._tf:Find("panel/btn_go")

	setText(arg0_2.btnGo:Find("Text"), i18n("cruise_tip_skin"))

	arg0_2.itemContent = arg0_2._tf:Find("panel/content")

	local var0_2 = getProxy(ActivityProxy):getAliveActivityByType(ActivityConst.ACTIVITY_TYPE_PT_CRUSING)
	local var1_2 = pg.battlepass_event_pt[var0_2.id].equip_skin or {}

	arg0_2.itemList = UIItemList.New(arg0_2.itemContent, arg0_2.itemContent:GetChild(0))

	arg0_2.itemList:make(function(arg0_3, arg1_3, arg2_3)
		arg1_3 = arg1_3 + 1

		if arg0_3 == UIItemList.EventUpdate then
			local var0_3 = Drop.Create(var1_2[arg1_3])

			updateDrop(arg2_3:Find("IconTpl"), var0_3)
			onButton(arg0_2, arg2_3, function()
				arg0_2:emit(var0_0.ON_DROP, var0_3)
			end, SFX_PANEL)
		end
	end)
	arg0_2.itemList:align(#var1_2)
end

function var0_0.didEnter(arg0_5)
	pg.UIMgr.GetInstance():BlurPanel(arg0_5._tf, false, {
		weight = LayerWeightConst.TOP_LAYER
	})
	onButton(arg0_5, arg0_5.rtBg, function()
		arg0_5:closeView()
	end, SFX_CANCEL)
	onButton(arg0_5, arg0_5.btnGo, function()
		arg0_5:emit(CrusingWindowMediator.GO_CRUSING)
	end, SFX_CONFIRM)
end

return var0_0
