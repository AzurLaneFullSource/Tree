local var0_0 = class("IslandMechaModelPreviewPage", import("Mod.Island.View.page.ship.IslandBaseShipDisplayPage"))

function var0_0.getUIName(arg0_1)
	return "IslandMechaModePreviewUI"
end

function var0_0.NeedCache(arg0_2)
	return false
end

function var0_0.GetActiveCamName(arg0_3)
	return IslandConst.MODEL_PREVIEW_CAMERA_NAME
end

function var0_0.OnLoaded(arg0_4)
	arg0_4.backBtn = arg0_4._tf:Find("adapt/left_panel/back")

	setText(arg0_4._tf:Find("adapt/left_panel/title/Text"), i18n("island_dressup_titile"))
end

function var0_0.OnInit(arg0_5)
	onButton(arg0_5, arg0_5.backBtn, function()
		arg0_5:Hide()
	end, SFX_PANEL)
end

function var0_0.Show(arg0_7)
	var0_0.super.Show(arg0_7)

	local var0_7 = pg.island_unit_character[0]

	arg0_7:LoadCharacter({
		model = var0_7.model,
		animator = var0_7.animator
	}, false)
end

function var0_0.GetSmoothRotateObject(arg0_8)
	return arg0_8._tf:Find("adapt/char")
end

function var0_0.Hide(arg0_9)
	var0_0.super.Hide(arg0_9)

	if arg0_9.timer then
		arg0_9.timer:Stop()
	end
end

function var0_0.SetObjInitRotaion(arg0_10, arg1_10)
	local var0_10 = arg0_10:GetSmoothRotateObject()
	local var1_10 = GetOrAddComponent(var0_10, typeof(SmoothRotateObject))

	var1_10.rotationSpeed = 5

	ReflectionHelp.RefSetProperty(typeof(SmoothRotateObject), "targetRotation", var1_10, arg1_10)

	if arg0_10.timer then
		arg0_10.timer:Stop()
	end

	arg0_10.timer = Timer.New(function()
		local var0_11 = pg.island_set.character_detail_camera_speed.key_value_int

		var1_10.rotationSpeed = var0_11
	end, 0.5, 1)

	arg0_10.timer:Start()
end

function var0_0.IsPreviewScene(arg0_12)
	return true
end

function var0_0.GetDressByType(arg0_13)
	return {
		[IslandShipDressHelperNew.DressType.Body] = 1060013
	}
end

return var0_0
