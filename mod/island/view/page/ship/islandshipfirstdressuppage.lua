local var0_0 = class("IslandShipFirstDressupPage", import(".IslandBaseDressupPage"))

function var0_0.getUIName(arg0_1)
	return "IslandCommanderMainUI"
end

function var0_0.CanEsc(arg0_2)
	return false
end

function var0_0.OnLoaded(arg0_3)
	arg0_3.leftPlane = arg0_3._tf:Find("adapt/left_panel")
	arg0_3.backBtn = arg0_3._tf:Find("adapt/left_panel/back")
	arg0_3.homeBtn = arg0_3._tf:Find("adapt/home")

	setText(arg0_3._tf:Find("adapt/left_panel/title/Text"), i18n("island_dressup_titile"))
	setActive(arg0_3.leftPlane, false)
	setActive(arg0_3.homeBtn, false)
end

function var0_0.AddListeners(arg0_4)
	arg0_4:AddListener(GAME.ISLAND_CHANGE_COMMANDER_DRESS_DONE, arg0_4.OnDressUpDone)
end

function var0_0.RemoveListeners(arg0_5)
	arg0_5:RemoveListener(GAME.ISLAND_CHANGE_COMMANDER_DRESS_DONE, arg0_5.OnDressUpDone)
end

function var0_0.OnInit(arg0_6)
	onButton(arg0_6, arg0_6.homeBtn, function()
		arg0_6:emit(BaseUI.ON_HOME)
	end, SFX_PANEL)
	onButton(arg0_6, arg0_6.backBtn, function()
		if arg0_6:CheckDressIsDirty() then
			arg0_6:ShowMsgBox({
				type = IslandMsgBox.TYPE_COMMON,
				content = i18n("island_dressup_tip_1"),
				onYes = function()
					arg0_6.currentChildPage:SaveDressUpData()
					arg0_6:Hide()
				end,
				onNo = function()
					arg0_6:Hide()
				end
			})
		else
			arg0_6:Hide()
		end
	end, SFX_PANEL)
end

function var0_0.Show(arg0_11, arg1_11)
	arg0_11.callback = arg1_11

	var0_0.super.Show(arg0_11)
	arg0_11:Flush()

	arg0_11.shipDressHelper = IslandShipDressHelperNew.New()

	arg0_11.shipDressHelper:SetShipId(0)

	arg0_11.currentChildPage = arg0_11:OpenPage(IslandShipDressUpPageNew, 0, true, arg0_11.shipDressHelper)

	local var0_11 = pg.island_unit_character[0]

	arg0_11:LoadCharacter({
		model = var0_11.model,
		animator = var0_11.animator
	})
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
end

function var0_0.OnDressUpDone(arg0_16)
	arg0_16:Hide()
	arg0_16:ClearCharacterScene(arg0_16.callback)
end

function var0_0.CheckDressIsDirty(arg0_17)
	return arg0_17.currentChildPage:CheckDressIsDirty()
end

function var0_0.OnDestroy(arg0_18)
	return
end

return var0_0
