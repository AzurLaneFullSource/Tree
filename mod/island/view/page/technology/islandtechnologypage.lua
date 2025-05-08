local var0_0 = class("IslandTechnologyPage", import("...base.IslandBasePage"))

function var0_0.getUIName(arg0_1)
	return "IslandTechnologyUI"
end

function var0_0.OnLoaded(arg0_2)
	arg0_2.inviteBtn = arg0_2._tf:Find("top/invite")
	arg0_2.centreInfoTF = arg0_2._tf:Find("left")

	local var0_2 = arg0_2._tf:Find("content")

	arg0_2.typeUIList = UIItemList.New(var0_2, var0_2:GetChild(0))
	arg0_2.quickPanel = IslandTechQuickPanel.New(arg0_2._tf, arg0_2.event, arg0_2.contextData)
	arg0_2.overviewPanel = IslandTechOverviewPanel.New(arg0_2._tf, arg0_2.event, arg0_2.contextData)
end

function var0_0.OnInit(arg0_3)
	onButton(arg0_3, arg0_3._tf:Find("top/back"), function()
		arg0_3:Hide()
	end, SFX_PANEL)
	onButton(arg0_3, arg0_3._tf:Find("top/home"), function()
		arg0_3:emit(BaseUI.ON_HOME)
	end, SFX_PANEL)
	onButton(arg0_3, arg0_3.inviteBtn, function()
		arg0_3:OpenPage(IslandInvitePage)
		arg0_3:FoldSubViewPanelPanel()
	end, SFX_PANEL)
	onButton(arg0_3, arg0_3.centreInfoTF:Find("centre"), function()
		arg0_3:OpenPage(IslandTechCentrePage)
		arg0_3:FoldSubViewPanelPanel()
	end, SFX_PANEL)

	arg0_3.types = IslandTechBelong.COMMON_SHOW_TYPES

	arg0_3.typeUIList:make(function(arg0_8, arg1_8, arg2_8)
		if arg0_8 == UIItemList.EventInit then
			arg0_3:InitTypeItem(arg1_8, arg2_8)
		elseif arg0_8 == UIItemList.EventUpdate then
			arg0_3:UpdateTypeItem(arg1_8, arg2_8)
		end
	end)
end

function var0_0.AddListeners(arg0_9)
	arg0_9:AddListener(GAME.ISLAND_START_DELEGATION_DONE, arg0_9.Flush)
	arg0_9:AddListener(GAME.ISLAND_FINISH_TECH_IMMD_DONE, arg0_9.Flush)
	arg0_9:AddListener(GAME.ISLAND_FINISH_DELEGATION_DONE, arg0_9.Flush)
	arg0_9:AddListener(GAME.ISLAND_GET_DELEGATION_AWARD_DONE, arg0_9.Flush)
end

function var0_0.RemoveListeners(arg0_10)
	arg0_10:RemoveListener(GAME.ISLAND_START_DELEGATION_DONE, arg0_10.Flush)
	arg0_10:RemoveListener(GAME.ISLAND_FINISH_TECH_IMMD_DONE, arg0_10.Flush)
	arg0_10:RemoveListener(GAME.ISLAND_FINISH_DELEGATION_DONE, arg0_10.Flush)
	arg0_10:RemoveListener(GAME.ISLAND_GET_DELEGATION_AWARD_DONE, arg0_10.Flush)
end

function var0_0.OnShow(arg0_11)
	arg0_11:Flush()
	arg0_11:CheckAutoFinish()
	arg0_11:ShowSubViewPanel()
end

function var0_0.Flush(arg0_12)
	arg0_12.techAgency = getProxy(IslandProxy):GetIsland():GetTechnologyAgency()

	arg0_12.typeUIList:align(#arg0_12.types)
	arg0_12:FlushCentre()
	arg0_12.quickPanel:ExecuteAction("Flush")
	arg0_12.overviewPanel:ExecuteAction("Flush")
end

function var0_0.CheckAutoFinish(arg0_13)
	local var0_13 = {}
	local var1_13 = arg0_13.techAgency:GetAutoFinishList()

	for iter0_13, iter1_13 in ipairs(var1_13) do
		table.insert(var0_13, function(arg0_14)
			arg0_13:emit(IslandMediator.ON_FINISH_TECH_IMMD, iter1_13, arg0_14)
		end)
	end

	seriesAsync(var0_13, function()
		warning("auto finish end, cnt:", #var1_13)
	end)
end

function var0_0.InitTypeItem(arg0_16, arg1_16, arg2_16)
	local var0_16 = arg0_16.types[arg1_16 + 1]

	setText(arg2_16:Find("info/name"), IslandTechBelong.Names[var0_16])
	LoadImageSpriteAsync("islandtechnology/type_" .. IslandTechBelong.Fields[var0_16], arg2_16:Find("info/icon"))
	onButton(arg0_16, arg2_16, function()
		arg0_16:OpenPage(IslandTechTreePage, var0_16)
		arg0_16:FoldSubViewPanelPanel()
	end, SFX_PANEL)
end

function var0_0.UpdateTypeItem(arg0_18, arg1_18, arg2_18)
	local var0_18 = arg0_18.types[arg1_18 + 1]
	local var1_18 = arg0_18.techAgency:GetPctByType(var0_18)

	setText(arg2_18:Find("info/Text"), var1_18)
	arg0_18:UpdateProgress(arg2_18:Find("info/progress"), var1_18)
	setActive(arg2_18:Find("line"), var1_18 == 100)
end

function var0_0.UpdateProgress(arg0_19, arg1_19, arg2_19)
	setFillAmount(arg1_19, arg2_19 / 100)

	local var0_19 = arg2_19 == 0 or arg2_19 == 100

	setActive(arg1_19:Find("pointer"), not var0_19)

	if not var0_19 then
		local var1_19 = arg2_19 / 100 * 360

		setLocalEulerAngles(arg1_19:Find("pointer"), {
			z = var1_19
		})
		setLocalEulerAngles(arg1_19:Find("pointer/mask/ring"), {
			z = 360 - var1_19
		})
	end
end

function var0_0.FlushCentre(arg0_20)
	setText(arg0_20.centreInfoTF:Find("level"), getProxy(IslandProxy):GetIsland():GetLevel())

	local var0_20 = arg0_20.techAgency:GetPctByType(IslandTechBelong.CENTRE)

	arg0_20:UpdateProgress(arg0_20.centreInfoTF:Find("progress"), var0_20)
end

function var0_0.ShowSubViewPanel(arg0_21)
	arg0_21.quickPanel:ExecuteAction("Show")
	arg0_21.overviewPanel:ExecuteAction("Show")
end

function var0_0.FoldSubViewPanelPanel(arg0_22)
	arg0_22.quickPanel:ExecuteAction("OffToggle")
	arg0_22.overviewPanel:ExecuteAction("OffToggle")
end

function var0_0.HideSubViewPanel(arg0_23)
	arg0_23:FoldSubViewPanelPanel()
	arg0_23.quickPanel:ExecuteAction("Hide")
	arg0_23.overviewPanel:ExecuteAction("Hide")
end

function var0_0.OnHide(arg0_24)
	arg0_24:HideSubViewPanel()
end

function var0_0.OnDestroy(arg0_25)
	if arg0_25.quickPanel then
		arg0_25.quickPanel:Destroy()

		arg0_25.quickPanel = nil
	end

	if arg0_25.overviewPanel then
		arg0_25.overviewPanel:Destroy()

		arg0_25.overviewPanel = nil
	end
end

return var0_0
