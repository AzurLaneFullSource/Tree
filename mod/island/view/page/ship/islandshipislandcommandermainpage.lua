local var0_0 = class("IslandShipIslandCommanderMainPage", import(".IslandBaseShipDisplayPage"))

function var0_0.getUIName(arg0_1)
	return "IslandCommanderMainUI"
end

function var0_0.OnLoaded(arg0_2)
	arg0_2.backBtn = arg0_2._tf:Find("adapt/left_panel/back")
	arg0_2.homeBtn = arg0_2._tf:Find("adapt/home")

	setText(arg0_2._tf:Find("adapt/left_panel/title/Text"), i18n("island_dressup_titile"))
	setActive(arg0_2.homeBtn, false)
end

function var0_0.AddListeners(arg0_3)
	return
end

function var0_0.RemoveListeners(arg0_4)
	return
end

function var0_0.OnInit(arg0_5)
	onButton(arg0_5, arg0_5.homeBtn, function()
		arg0_5:emit(BaseUI.ON_HOME)
	end, SFX_PANEL)
	onButton(arg0_5, arg0_5.backBtn, function()
		if arg0_5:CheckDressIsDirty() then
			arg0_5:ShowMsgBox({
				type = IslandMsgBox.TYPE_COMMON,
				content = i18n("island_dressup_tip_1"),
				onYes = function()
					arg0_5.currentChildPage:SaveDressUpData()
					arg0_5:Hide()
				end,
				onNo = function()
					arg0_5:Hide()
				end
			})
		else
			arg0_5:Hide()
		end
	end, SFX_PANEL)
end

function var0_0.Show(arg0_10)
	var0_0.super.Show(arg0_10)
	arg0_10:Flush()

	local var0_10 = pg.island_unit_character[0]

	arg0_10.shipDressHelper = IslandShipDressHelperNew.New()

	arg0_10.shipDressHelper:SetShipId(0)
	arg0_10:LoadCharacter({
		model = var0_10.model,
		animator = var0_10.animator
	}, true)

	arg0_10.currentChildPage = arg0_10:OpenPage(IslandShipDressUpPageNew, 0, false, arg0_10.shipDressHelper, function(arg0_11)
		arg0_10:SetObjInitRotaion(arg0_11)
	end)
end

function var0_0.Flush(arg0_12)
	return
end

function var0_0.GetSmoothRotateObject(arg0_13)
	return arg0_13._tf:Find("adapt/char")
end

function var0_0.OnCharLoaded(arg0_14)
	arg0_14.shipDressHelper:OnRoleLoaded(arg0_14.role.transform)
end

function var0_0.Hide(arg0_15)
	arg0_15.currentChildPage:Destroy()
	arg0_15.shipDressHelper:Destroy()
	var0_0.super.Hide(arg0_15)

	if arg0_15.timer then
		arg0_15.timer:Stop()
	end
end

function var0_0.OnDestroy(arg0_16)
	return
end

function var0_0.SetObjInitRotaion(arg0_17, arg1_17)
	local var0_17 = arg0_17:GetSmoothRotateObject()
	local var1_17 = GetOrAddComponent(var0_17, typeof(SmoothRotateObject))

	var1_17.rotationSpeed = 5

	ReflectionHelp.RefSetProperty(typeof(SmoothRotateObject), "targetRotation", var1_17, arg1_17)

	if arg0_17.timer then
		arg0_17.timer:Stop()
	end

	arg0_17.timer = Timer.New(function()
		local var0_18 = pg.island_set.character_detail_camera_speed.key_value_int

		var1_17.rotationSpeed = var0_18
	end, 0.5, 1)

	arg0_17.timer:Start()
end

function var0_0.CheckDressIsDirty(arg0_19)
	return arg0_19.currentChildPage:CheckDressIsDirty()
end

function var0_0.CanEsc(arg0_20)
	if not arg0_20:CheckDressIsDirty() then
		return true
	end

	arg0_20:ShowMsgBox({
		type = IslandMsgBox.TYPE_COMMON,
		content = i18n("island_dressup_tip_1"),
		onYes = function()
			arg0_20.currentChildPage:SaveDressUpData()
			arg0_20:Hide()
		end,
		onNo = function()
			arg0_20:Hide()
		end
	})
end

return var0_0
