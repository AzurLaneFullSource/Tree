local var0_0 = class("IslandTechnologyPage", import("...base.IslandBasePage"))

function var0_0.getUIName(arg0_1)
	return "IslandTechnologyUI"
end

function var0_0.OnLoaded(arg0_2)
	arg0_2.centreToggleTF = arg0_2._tf:Find("types/1")
	arg0_2.centreTipTF = arg0_2.centreToggleTF:Find("tip")

	local var0_2 = arg0_2._tf:Find("types/content")

	arg0_2.typeUIList = UIItemList.New(var0_2, var0_2:Find("tpl"))

	local var1_2 = arg0_2._tf:Find("pages")

	arg0_2.pages = {}

	local var2_2 = setmetatable({
		onItemClick = function(arg0_3, arg1_3)
			arg0_2.detailPanel:ExecuteAction("Show", arg0_3, arg1_3)
		end
	}, {
		__index = arg0_2.contextData
	})

	arg0_2.pages[IslandTechBelong.CENTRE] = IslandTechCentrePanel.New(var1_2, arg0_2.event, var2_2)

	for iter0_2, iter1_2 in ipairs(IslandTechBelong.COMMON_SHOW_TYPES) do
		arg0_2.pages[iter1_2] = IslandTechTreePanel.New(var1_2, arg0_2.event, setmetatable({
			type = iter1_2
		}, {
			__index = var2_2
		}))
	end

	arg0_2.quickPanel = IslandTechQuickPanel.New(arg0_2._tf, arg0_2.event, setmetatable({
		onGetAwardDone = function()
			arg0_2:OpenPage(IslandTechAwardPage)
		end
	}, {
		__index = arg0_2.contextData
	}))
	arg0_2.detailPanel = IslandTechDetailPanel.New(arg0_2._tf, arg0_2.event, setmetatable({
		onSelecteShip = function()
			arg0_2:OpenPage(IslandShipSelectPage, 1, {}, nil, function(arg0_6)
				arg0_2.detailPanel:ExecuteAction("OnShipSelected", arg0_6[1])
			end)
		end,
		onFinishImmd = function(arg0_7)
			arg0_2:emit(IslandMediator.ON_FINISH_TECH_IMMD, arg0_7, function()
				arg0_2:OpenPage(IslandTechAwardPage, arg0_7)
			end)
		end,
		onGetAwardDone = function(arg0_9)
			arg0_2:OpenPage(IslandTechAwardPage, arg0_9)
		end
	}, {
		__index = arg0_2.contextData
	}))
end

function var0_0.OnInit(arg0_10)
	onButton(arg0_10, arg0_10._tf:Find("top/back"), function()
		arg0_10:Hide()
	end, SFX_PANEL)
	onButton(arg0_10, arg0_10._tf:Find("top/home"), function()
		arg0_10:emit(BaseUI.ON_HOME)
	end, SFX_PANEL)
	onToggle(arg0_10, arg0_10.centreToggleTF, function(arg0_13)
		if arg0_13 then
			arg0_10.curPage = IslandTechBelong.CENTRE

			arg0_10:SwitchPage()
		end
	end, SFX_PANEL)

	arg0_10.commonTypes = IslandTechBelong.COMMON_SHOW_TYPES

	arg0_10.typeUIList:make(function(arg0_14, arg1_14, arg2_14)
		if arg0_14 == UIItemList.EventInit then
			arg0_10:InitTypeItem(arg1_14, arg2_14)
		elseif arg0_14 == UIItemList.EventUpdate then
			arg0_10:UpdateTypeItem(arg1_14, arg2_14)
		end
	end)
end

function var0_0.AddListeners(arg0_15)
	arg0_15:AddListener(GAME.ISLAND_UNLOCK_TECH_DONE, arg0_15.Flush)
	arg0_15:AddListener(GAME.ISLAND_START_DELEGATION_DONE, arg0_15.Flush)
	arg0_15:AddListener(GAME.ISLAND_FINISH_TECH_IMMD_DONE, arg0_15.CheckAutoUnlock)
	arg0_15:AddListener(GAME.ISLAND_FINISH_DELEGATION_DONE, arg0_15.Flush)
	arg0_15:AddListener(GAME.ISLAND_GET_DELEGATION_AWARD_DONE, arg0_15.CheckAutoUnlock)
end

function var0_0.RemoveListeners(arg0_16)
	arg0_16:RemoveListener(GAME.ISLAND_UNLOCK_TECH_DONE, arg0_16.Flush)
	arg0_16:RemoveListener(GAME.ISLAND_START_DELEGATION_DONE, arg0_16.Flush)
	arg0_16:RemoveListener(GAME.ISLAND_FINISH_TECH_IMMD_DONE, arg0_16.CheckAutoUnlock)
	arg0_16:RemoveListener(GAME.ISLAND_FINISH_DELEGATION_DONE, arg0_16.Flush)
	arg0_16:RemoveListener(GAME.ISLAND_GET_DELEGATION_AWARD_DONE, arg0_16.CheckAutoUnlock)
end

function var0_0.InitTypeItem(arg0_17, arg1_17, arg2_17)
	local var0_17 = arg0_17.commonTypes[arg1_17 + 1]

	arg2_17.name = var0_17

	local var1_17 = IslandTechBelong.Names[var0_17]

	setText(arg2_17:Find("unsel"), var1_17)
	setText(arg2_17:Find("sel/content/Text"), var1_17)
	LoadImageSpriteAsync("island/islandtechnology/tech_type_" .. IslandTechBelong.Fields[var0_17], arg2_17:Find("sel/content/Image"), true)
	onToggle(arg0_17, arg2_17, function(arg0_18)
		if arg0_18 then
			arg0_17.curPage = var0_17

			arg0_17:SwitchPage()
		end
	end, SFX_PANEL)
end

function var0_0.UpdateTypeItem(arg0_19, arg1_19, arg2_19)
	local var0_19 = arg0_19.commonTypes[arg1_19 + 1]

	setActive(arg2_19:Find("unsel/tip"), arg0_19:IsReceiveByType(var0_19))
	setActive(arg2_19:Find("sel/tip"), arg0_19:IsReceiveByType(var0_19))
end

function var0_0.IsReceiveByType(arg0_20, arg1_20)
	for iter0_20, iter1_20 in pairs(arg0_20.techAgency:GetTechnologys()) do
		if iter1_20:getConfig("tech_belong") == arg1_20 and iter1_20:GetStatus() == IslandTechnology.STATUS.RECEIVE then
			return true
		end
	end

	return false
end

function var0_0.FlushCentreTip(arg0_21)
	setActive(arg0_21.centreTipTF, arg0_21:IsReceiveByType(IslandTechBelong.CENTRE))
end

function var0_0.SwitchPage(arg0_22)
	for iter0_22, iter1_22 in pairs(arg0_22.pages) do
		if iter0_22 == arg0_22.curPage then
			iter1_22:ExecuteAction("Show")
		else
			iter1_22:ExecuteAction("Hide")
		end
	end
end

function var0_0.OnShow(arg0_23)
	triggerToggle(arg0_23.centreToggleTF, true)
	arg0_23.quickPanel:ExecuteAction("Show")
	arg0_23:CheckAutoUnlock()
end

function var0_0.CheckAutoUnlock(arg0_24)
	getProxy(IslandProxy):GetIsland():GetTechnologyAgency():TryAutoUnlock(function()
		arg0_24:Flush()
	end)
end

function var0_0.Flush(arg0_26)
	arg0_26.techAgency = getProxy(IslandProxy):GetIsland():GetTechnologyAgency()

	arg0_26.typeUIList:align(#arg0_26.commonTypes)
	arg0_26:FlushCentreTip()
	arg0_26.pages[arg0_26.curPage]:ExecuteAction("Flush")
	arg0_26.quickPanel:ExecuteAction("Flush")

	if arg0_26.detailPanel:isShowing() then
		arg0_26.detailPanel:ExecuteAction("Flush")
	end
end

function var0_0.OnHide(arg0_27)
	arg0_27.quickPanel:ExecuteAction("Hide")
	arg0_27.detailPanel:ExecuteAction("Hide")
end

function var0_0.OnDisable(arg0_28)
	arg0_28:OnHide()
end

function var0_0.OnDestroy(arg0_29)
	if arg0_29.quickPanel then
		arg0_29.quickPanel:Destroy()

		arg0_29.quickPanel = nil
	end

	if arg0_29.detailPanel then
		arg0_29.detailPanel:Destroy()

		arg0_29.detailPanel = nil
	end

	for iter0_29, iter1_29 in pairs(arg0_29.pages) do
		if iter1_29 then
			iter1_29:Destroy()

			iter1_29 = nil
		end
	end
end

return var0_0
