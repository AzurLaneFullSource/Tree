local var0_0 = class("CombatSkinInfoLayer", import("view.base.BaseUI"))

function var0_0.getUIName(arg0_1)
	return "CombatSkinInfoUI"
end

function var0_0.init(arg0_2)
	pg.UIMgr.GetInstance():BlurPanel(arg0_2._tf)

	arg0_2.closeBtn = arg0_2:findTF("display/top/btnBack")
	arg0_2.confirm = arg0_2:findTF("display/actions/confirm")
	arg0_2.skinViewTF = arg0_2:findTF("display")
	arg0_2.toggleList = UIItemList.New(arg0_2:findTF("display/info/display_panel/combat_skin/elementList"), arg0_2:findTF("display/info/display_panel/combat_skin/elementList/main"))
end

function var0_0.didEnter(arg0_3)
	onButton(arg0_3, arg0_3._tf, function()
		arg0_3:emit(var0_0.ON_CLOSE)
	end, SOUND_BACK)
	onButton(arg0_3, arg0_3.closeBtn, function()
		arg0_3:emit(var0_0.ON_CLOSE)
	end, SFX_CANCEL)
	onButton(arg0_3, arg0_3.confirm, function()
		arg0_3:emit(var0_0.ON_CLOSE)
	end, SFX_PANEL)
	arg0_3:InitPanel()
end

function var0_0.InitPanel(arg0_7)
	local var0_7 = arg0_7.contextData.skinID
	local var1_7 = pg.item_data_battleui[var0_7]
	local var2_7 = arg0_7:findTF("info/display_panel/name_container/name", arg0_7.skinViewTF)
	local var3_7 = arg0_7:findTF("info/display_panel/desc/Text", arg0_7.skinViewTF)

	setText(var2_7, var1_7.name)
	setText(var3_7, var1_7.desc)

	local var4_7 = var1_7.rare_display

	arg0_7.toggleList:make(function(arg0_8, arg1_8, arg2_8)
		if arg0_8 == UIItemList.EventUpdate then
			local var0_8 = var4_7[arg1_8 + 1]

			GetImageSpriteFromAtlasAsync("ui/combatskinrare", CombatSkinConst.TYPE_ICON_NAME[var0_8], arg2_8:Find("icon"), true)
			setScrollText(arg2_8:Find("TextMask/Text"), i18n("battleui_display" .. var0_8))
		end
	end)
	arg0_7.toggleList:align(#var4_7)

	local var5_7 = arg0_7:findTF("info/play_btn", arg0_7.skinViewTF)

	onButton(arg0_7, var5_7, function()
		arg0_7.combatPreview = CombatPreviewLayer.New(pg.UIMgr.GetInstance().OverlayMain)

		arg0_7.combatPreview:ExecuteAction("Show", var0_7, function()
			arg0_7.combatPreview:Destroy()

			arg0_7.combatPreview = nil
		end)
	end, SPX_PANEL)
	updateDrop(arg0_7:findTF("info/equip", arg0_7.skinViewTF), Drop.New({
		count = 1,
		type = DROP_TYPE_COMBAT_UI_STYLE,
		id = var0_7
	}))
end

function var0_0.willExit(arg0_11)
	pg.UIMgr.GetInstance():UnOverlayPanel(arg0_11._tf)
end

function var0_0.onBackPressed(arg0_12)
	if arg0_12.combatPreview then
		arg0_12.combatPreview:Destroy()

		arg0_12.combatPreview = nil
	else
		var0_0.super.onBackPressed(arg0_12)
	end
end

return var0_0
