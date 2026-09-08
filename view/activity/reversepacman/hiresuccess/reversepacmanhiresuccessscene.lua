local var0_0 = class("ReversePacmanHireSuccessScene", import("view.base.BaseUI"))

function var0_0.getUIName(arg0_1)
	return "ReversePacmanHireSuccessUI"
end

function var0_0.init(arg0_2)
	onButton(arg0_2, arg0_2.uiCloseBtn, function()
		arg0_2:closeView()
	end, SOUND_BACK)

	arg0_2.nameView = ReversePacmanInterviewRoleName.New(arg0_2.uiNamePanel, arg0_2)
end

function var0_0.didEnter(arg0_4)
	arg0_4:BlurPanel(arg0_4._tf)

	local var0_4 = arg0_4.contextData.roleID

	arg0_4.nameView:RefreshUI(var0_4)

	local var1_4 = pg.activity_chasing_character[var0_4]
	local var2_4 = var1_4.skin_id
	local var3_4 = ShipGroup.getDefaultShipConfig(pg.ship_skin_template[var1_4.skin_id].ship_group).id

	setText(arg0_4.uiDescText, pg.ship_skin_words[var3_4] and pg.ship_skin_words[var3_4].unlock or "")

	local var4_4 = Ship.New({
		id = var3_4,
		configId = var3_4,
		skin_id = var1_4.skin_id
	}):getPrefab()

	pg.UIMgr.GetInstance():LoadingOn()

	local var5_4 = SpineAnimChar.New()

	var5_4:SetPaint(var4_4)
	var5_4:Load(true, function(arg0_5)
		pg.UIMgr.GetInstance():LoadingOff()

		arg0_4.shipPrefab = var4_4
		arg0_4.shipModel = arg0_5

		arg0_5:SetLocalScale(Vector3(1, 1, 1))
		arg0_5:SetParent(arg0_4.uiCharaParent)
		arg0_5:SetAction("victory", 0)
	end)
end

function var0_0.recycleSpineChar(arg0_6)
	if arg0_6.shipPrefab and arg0_6.shipModel then
		arg0_6.shipModel:Dispose()

		arg0_6.shipPrefab = nil
		arg0_6.shipModel = nil
	end
end

function var0_0.willExit(arg0_7)
	arg0_7:recycleSpineChar()
	arg0_7.nameView:willExit()

	arg0_7.nameView = nil

	arg0_7:UnOverlayPanel(arg0_7._tf)
end

return var0_0
