local var0_0 = class("IslandTechnologyPage", import("...base.IslandBasePage"))

function var0_0.getUIName(arg0_1)
	return "IslandTechnologyUI"
end

function var0_0.OnLoaded(arg0_2)
	setText(arg0_2._tf:Find("top/title/Text"), i18n("island_technology_title"))

	arg0_2.centreToggleTF = arg0_2._tf:Find("adapt/types/1")
	arg0_2.centreTipTF = arg0_2.centreToggleTF:Find("tip")

	local var0_2 = arg0_2._tf:Find("adapt/types/content")

	arg0_2.typeUIList = UIItemList.New(var0_2, var0_2:Find("tpl"))

	local var1_2 = arg0_2._tf:Find("adapt/pages")

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
		onGetAwardDone = function(arg0_4)
			arg0_2:OpenPage(IslandTechAwardPage, arg0_4)
		end
	}, {
		__index = arg0_2.contextData
	}))

	arg0_2.quickPanel:RegisterView(arg0_2.viewComponent)

	arg0_2.detailPanel = IslandTechDetailPanel.New(arg0_2._tf, arg0_2.event, setmetatable({
		onSelecteShip = function()
			arg0_2:OpenPage(IslandShipSelectPage, {
				confirmFunc = function(arg0_6)
					arg0_2.detailPanel:ExecuteAction("OnShipSelected", arg0_6[1])
				end
			})
		end,
		onFinishImmd = function(arg0_7)
			arg0_2:emit(IslandMediator.ON_FINISH_TECH_IMMD, arg0_7, function()
				arg0_2:OpenPage(IslandTechAwardPage, arg0_7)
			end)
		end,
		onGetAwardDone = function(arg0_9)
			arg0_2:OpenPage(IslandTechAwardPage, arg0_9)
		end,
		openTicketPage = function(arg0_10)
			arg0_2:OpenPage(IslandTicketUsePage, IslandUseTicketCommand.TYPES.APPOINT, arg0_10)
		end
	}, {
		__index = arg0_2.contextData
	}))

	arg0_2.detailPanel:RegisterView(arg0_2.viewComponent)
end

function var0_0.OnInit(arg0_11)
	onButton(arg0_11, arg0_11._tf:Find("top/back"), function()
		arg0_11:Hide()
	end, SFX_PANEL)
	onButton(arg0_11, arg0_11._tf:Find("top/home"), function()
		arg0_11:emit(BaseUI.ON_HOME)
	end, SFX_PANEL)
	onToggle(arg0_11, arg0_11.centreToggleTF, function(arg0_14)
		if arg0_14 and arg0_11.curPage ~= IslandTechBelong.CENTRE then
			arg0_11.curPage = IslandTechBelong.CENTRE

			arg0_11:SwitchPage()
		end
	end, SFX_PANEL)

	arg0_11.commonTypes = IslandTechBelong.COMMON_SHOW_TYPES

	arg0_11.typeUIList:make(function(arg0_15, arg1_15, arg2_15)
		if arg0_15 == UIItemList.EventInit then
			arg0_11:InitTypeItem(arg1_15, arg2_15)
		elseif arg0_15 == UIItemList.EventUpdate then
			arg0_11:UpdateTypeItem(arg1_15, arg2_15)
		end
	end)
end

function var0_0.AddListeners(arg0_16)
	arg0_16:AddListener(GAME.ISLAND_UNLOCK_TECH_DONE, arg0_16.Flush)
	arg0_16:AddListener(GAME.ISLAND_START_DELEGATION_DONE, arg0_16.Flush)
	arg0_16:AddListener(GAME.ISLAND_FINISH_TECH_IMMD_DONE, arg0_16.CheckAutoUnlock)
	arg0_16:AddListener(GAME.ISLAND_FINISH_DELEGATION_DONE, arg0_16.Flush)
	arg0_16:AddListener(GAME.ISLAND_GET_DELEGATION_AWARD_DONE, arg0_16.CheckAutoUnlock)
end

function var0_0.RemoveListeners(arg0_17)
	arg0_17:RemoveListener(GAME.ISLAND_UNLOCK_TECH_DONE, arg0_17.Flush)
	arg0_17:RemoveListener(GAME.ISLAND_START_DELEGATION_DONE, arg0_17.Flush)
	arg0_17:RemoveListener(GAME.ISLAND_FINISH_TECH_IMMD_DONE, arg0_17.CheckAutoUnlock)
	arg0_17:RemoveListener(GAME.ISLAND_FINISH_DELEGATION_DONE, arg0_17.Flush)
	arg0_17:RemoveListener(GAME.ISLAND_GET_DELEGATION_AWARD_DONE, arg0_17.CheckAutoUnlock)
end

function var0_0.InitTypeItem(arg0_18, arg1_18, arg2_18)
	local var0_18 = arg0_18.commonTypes[arg1_18 + 1]

	arg2_18.name = var0_18

	local var1_18 = IslandTechBelong.Names[var0_18]

	setText(arg2_18:Find("unsel"), var1_18)
	setText(arg2_18:Find("sel/content/Text"), var1_18)
	LoadImageSpriteAsync("island/islandtechnology/tech_type_" .. IslandTechBelong.Fields[var0_18], arg2_18:Find("sel/content/Image"), true)
	onToggle(arg0_18, arg2_18, function(arg0_19)
		if arg0_19 and arg0_18.curPage ~= var0_18 then
			arg0_18.curPage = var0_18

			arg0_18:SwitchPage()
		end
	end, SFX_PANEL)
end

function var0_0.UpdateTypeItem(arg0_20, arg1_20, arg2_20)
	local var0_20 = arg0_20.commonTypes[arg1_20 + 1]

	setActive(arg2_20:Find("unsel/tip"), arg0_20:IsReceiveByType(var0_20))
	setActive(arg2_20:Find("sel/tip"), arg0_20:IsReceiveByType(var0_20))
end

function var0_0.IsReceiveByType(arg0_21, arg1_21)
	for iter0_21, iter1_21 in pairs(arg0_21.techAgency:GetTechnologys()) do
		if iter1_21:getConfig("tech_belong") == arg1_21 and iter1_21:GetStatus() == IslandTechnology.STATUS.RECEIVE then
			return true
		end
	end

	return false
end

function var0_0.FlushCentreTip(arg0_22)
	setActive(arg0_22.centreTipTF, arg0_22:IsReceiveByType(IslandTechBelong.CENTRE))
end

function var0_0.SwitchPage(arg0_23)
	for iter0_23, iter1_23 in pairs(arg0_23.pages) do
		if iter0_23 == arg0_23.curPage then
			iter1_23:ExecuteAction("Show")
		else
			iter1_23:ExecuteAction("Hide")
		end
	end
end

function var0_0.OnShow(arg0_24)
	triggerToggle(arg0_24.centreToggleTF, true)
	arg0_24.quickPanel:ExecuteAction("Show")
	arg0_24:CheckAutoUnlock()
end

function var0_0.CheckAutoUnlock(arg0_25)
	getProxy(IslandProxy):GetIsland():GetTechnologyAgency():TryAutoUnlock(function()
		arg0_25:Flush()
	end)
end

function var0_0.Flush(arg0_27)
	arg0_27.techAgency = getProxy(IslandProxy):GetIsland():GetTechnologyAgency()

	arg0_27.typeUIList:align(#arg0_27.commonTypes)
	arg0_27:FlushCentreTip()
	arg0_27.pages[arg0_27.curPage]:ExecuteAction("Flush")
	arg0_27.quickPanel:ExecuteAction("Flush")

	if arg0_27.detailPanel:isShowing() then
		arg0_27.detailPanel:ExecuteAction("Flush")
	end
end

function var0_0.OnHide(arg0_28)
	arg0_28.quickPanel:ExecuteAction("Hide")
	arg0_28.detailPanel:ExecuteAction("Hide")
end

function var0_0.OnDisable(arg0_29)
	arg0_29:OnHide()
end

function var0_0.OnDestroy(arg0_30)
	if arg0_30.quickPanel then
		arg0_30.quickPanel:Destroy()

		arg0_30.quickPanel = nil
	end

	if arg0_30.detailPanel then
		arg0_30.detailPanel:Destroy()

		arg0_30.detailPanel = nil
	end

	for iter0_30, iter1_30 in pairs(arg0_30.pages) do
		if iter1_30 then
			iter1_30:Destroy()

			iter1_30 = nil
		end
	end
end

return var0_0
