local var0_0 = class("IslandBuildingTestPage", import("...base.IslandBasePage"))

function var0_0.getUIName(arg0_1)
	return "IslandBuildingTestUI"
end

function var0_0.OnLoaded(arg0_2)
	arg0_2.backBtn = arg0_2:findTF("back")
	arg0_2.entrancesTF = arg0_2:findTF("entrances")
	arg0_2.entraceUIList = UIItemList.New(arg0_2.entrancesTF, arg0_2:findTF("tpl", arg0_2.entrancesTF))
	arg0_2.optionsTF = arg0_2:findTF("options")
	arg0_2.optionsTitle = arg0_2:findTF("title", arg0_2.optionsTF)
	arg0_2.unlockBtn = arg0_2:findTF("unlock", arg0_2.optionsTF)
	arg0_2.upgradeBtn = arg0_2:findTF("upgrade", arg0_2.optionsTF)
	arg0_2.productionBtn = arg0_2:findTF("production", arg0_2.optionsTF)
	arg0_2.makeBtn = arg0_2:findTF("make", arg0_2.optionsTF)
	arg0_2.returnBtn = arg0_2:findTF("return", arg0_2.optionsTF)
end

function var0_0.OnInit(arg0_3)
	onButton(arg0_3, arg0_3.backBtn, function()
		if isActive(arg0_3.optionsTF) then
			setActive(arg0_3.entrancesTF, true)
			setActive(arg0_3.optionsTF, false)
		else
			arg0_3:Hide()
		end
	end, SFX_PANEL)
	onButton(arg0_3, arg0_3.returnBtn, function()
		setActive(arg0_3.entrancesTF, true)
		setActive(arg0_3.optionsTF, false)
	end, SFX_PANEL)
	arg0_3.entraceUIList:make(function(arg0_6, arg1_6, arg2_6)
		if arg0_6 == UIItemList.EventInit then
			local var0_6 = arg0_3.buildings[arg1_6 + 1]

			arg2_6.name = tostring(var0_6.id)

			setText(arg0_3:findTF("Text", arg2_6), var0_6:GetName())
			onButton(arg0_3, arg2_6, function()
				arg0_3:ShowOptions(var0_6)
			end, SFX_PANEL)
		end
	end)
end

function var0_0.ShowOptions(arg0_8, arg1_8)
	arg0_8.selectedBuilding = arg1_8

	setActive(arg0_8.entrancesTF, false)
	setActive(arg0_8.optionsTF, true)
	arg0_8:FlushOptions()
end

function var0_0.Show(arg0_9)
	var0_0.super.Show(arg0_9)
	arg0_9:Flush()
end

function var0_0.Flush(arg0_10)
	arg0_10.buildings = getProxy(IslandProxy):GetIsland():GetBuildingAgency():GetBuildingList()

	arg0_10.entraceUIList:align(#arg0_10.buildings)
	setActive(arg0_10.entrancesTF, true)
	setActive(arg0_10.optionsTF, false)
end

function var0_0.FlushOptions(arg0_11)
	setText(arg0_11.optionsTitle, arg0_11.selectedBuilding:GetName())

	local var0_11 = arg0_11.selectedBuilding:IsUnlock()

	setActive(arg0_11.unlockBtn, not var0_11)
	onButton(arg0_11, arg0_11.unlockBtn, function()
		if arg0_11.selectedBuilding:CanUnlock() then
			arg0_11:emit(IslandMediator.ON_UNLOCK_BUILDING, arg0_11.selectedBuilding.id)
		else
			pg.TipsMgr.GetInstance():ShowTips(i18n("island_level_to_unlock", arg0_11.selectedBuilding:GetUnlockLv()))
		end
	end, SFX_PANEL)

	local var1_11 = arg0_11.selectedBuilding:CanUpgrade()

	setActive(arg0_11.upgradeBtn, var0_11 and var1_11)

	if var0_11 and var1_11 then
		onButton(arg0_11, arg0_11.upgradeBtn, function()
			arg0_11:emit(IslandMediator.ON_UPGRADE_BUILDING, arg0_11.selectedBuilding.id)
		end, SFX_PANEL)
	end

	setActive(arg0_11.makeBtn, var0_11)
	onButton(arg0_11, arg0_11.makeBtn, function()
		arg0_11:OpenPage(IslandMakePage, arg0_11.selectedBuilding)
	end, SFX_PANEL)
	setActive(arg0_11.productionBtn, false)
	onButton(arg0_11, arg0_11.productionBtn, function()
		arg0_11:OpenPage(IslandProductionPage, arg0_11.selectedBuilding)
	end, SFX_PANEL)
end

function var0_0.OnDestroy(arg0_16)
	return
end

return var0_0
