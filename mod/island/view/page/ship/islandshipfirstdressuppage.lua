local var0_0 = class("IslandShipFirstDressupPage", import(".IslandBaseDressupPage"))

function var0_0.getUIName(arg0_1)
	return "IslandCommanderMainUI"
end

function var0_0.OnLoaded(arg0_2)
	arg0_2.leftPlane = arg0_2:findTF("adapt/left_panel")
	arg0_2.backBtn = arg0_2:findTF("adapt/left_panel/back")
	arg0_2.homeBtn = arg0_2:findTF("adapt/home")

	setText(arg0_2:findTF("adapt/left_panel/title/Text"), i18n("island_dressup_titile"))
	setActive(arg0_2.leftPlane, false)
	setActive(arg0_2.homeBtn, false)
end

function var0_0.AddListeners(arg0_3)
	arg0_3:AddListener(GAME.ISLAND_CHANGE_COMMANDER_DRESS_DONE, arg0_3.OnDressUpDone)
end

function var0_0.RemoveListeners(arg0_4)
	arg0_4:RemoveListener(GAME.ISLAND_CHANGE_COMMANDER_DRESS_DONE, arg0_4.OnDressUpDone)
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

function var0_0.Show(arg0_10, arg1_10)
	arg0_10.callback = arg1_10

	var0_0.super.Show(arg0_10)
	arg0_10:Flush()

	arg0_10.shipDressHelper = IslandShipDressHelperNew.New()

	arg0_10.shipDressHelper:SetShipId(0)

	arg0_10.currentChildPage = arg0_10:OpenPage(IslandShipDressUpPageNew, 0, true, arg0_10.shipDressHelper)

	local var0_10 = pg.island_unit_character[0]

	arg0_10:LoadCharacter({
		model = var0_10.model,
		animator = var0_10.animator
	})
end

function var0_0.Flush(arg0_11)
	return
end

function var0_0.GetSmoothRotateObject(arg0_12)
	return arg0_12:findTF("adapt/char")
end

function var0_0.OnCharLoaded(arg0_13)
	arg0_13.shipDressHelper:OnRoleLoaded(arg0_13.role.transform)
end

function var0_0.Hide(arg0_14)
	arg0_14.currentChildPage:Destroy()
	arg0_14.shipDressHelper:Destroy()
	var0_0.super.Hide(arg0_14)
end

function var0_0.OnDressUpDone(arg0_15)
	arg0_15:Hide()
	arg0_15:ClearCharacterScene(arg0_15.callback)
end

function var0_0.CheckDressIsDirty(arg0_16)
	return arg0_16.currentChildPage:CheckDressIsDirty()
end

function var0_0.OnDestroy(arg0_17)
	return
end

return var0_0
