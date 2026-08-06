local var0_0 = class("IslandTechnologyPage", import("...base.IslandBasePage"))

function var0_0.getUIName(arg0_1)
	return "IslandTechnologyUI"
end

function var0_0.OnLoaded(arg0_2)
	arg0_2.rtTop = arg0_2._tf:Find("top")

	setText(arg0_2.rtTop:Find("title/Text"), i18n("island_technology_title"))

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
		onSelecteShip = function(arg0_5)
			local var0_5 = pg.island_formula[arg0_5].attribute
			local var1_5 = pg.island_formula[arg0_5].stamina_cost

			arg0_2:OpenPage(IslandShipSelectPage, {
				needWorkSpeed = true,
				showType = IslandSelectShipCard.SHOW_TYPE.PlACE,
				attrType = var0_5,
				confirmFunc = function(arg0_6)
					arg0_2.detailPanel:ExecuteAction("OnShipSelected", arg0_6[1])
				end,
				placeId = IslandProductConst.TechnologyPlaceId,
				energyCost = var1_5
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
		end,
		ShowMsgBox = function(arg0_11, arg1_11)
			arg0_2:ShowMsgBox(arg1_11)
		end
	}, {
		__index = arg0_2.contextData
	}))

	arg0_2.detailPanel:RegisterView(arg0_2.viewComponent)
end

function var0_0.OnInit(arg0_12)
	onButton(arg0_12, arg0_12.rtTop:Find("title/help"), function()
		arg0_12:ShowMsgBox({
			type = IslandMsgBox.TYPE_WHITOUT_BTN,
			content = i18n("island_helpbtn_technology")
		})
	end, SFX_PANEL)
	onButton(arg0_12, arg0_12.rtTop:Find("back"), function()
		arg0_12:Hide()
	end, SFX_PANEL)
	onButton(arg0_12, arg0_12.rtTop:Find("home"), function()
		arg0_12:emit(BaseUI.ON_HOME)
	end, SFX_PANEL)
	onToggle(arg0_12, arg0_12.centreToggleTF, function(arg0_16)
		if arg0_16 and arg0_12.curPage ~= IslandTechBelong.CENTRE then
			arg0_12.curPage = IslandTechBelong.CENTRE

			arg0_12:SwitchPage()
		end
	end, SFX_PANEL)

	arg0_12.commonTypes = IslandTechBelong.COMMON_SHOW_TYPES

	arg0_12.typeUIList:make(function(arg0_17, arg1_17, arg2_17)
		if arg0_17 == UIItemList.EventInit then
			arg0_12:InitTypeItem(arg1_17, arg2_17)
		elseif arg0_17 == UIItemList.EventUpdate then
			arg0_12:UpdateTypeItem(arg1_17, arg2_17)
		end
	end)
end

function var0_0.AddListeners(arg0_18)
	arg0_18:AddListener(GAME.ISLAND_UNLOCK_TECH_DONE, arg0_18.Flush)
	arg0_18:AddListener(GAME.ISLAND_START_DELEGATION_DONE, arg0_18.Flush)
	arg0_18:AddListener(GAME.ISLAND_FINISH_TECH_IMMD_DONE, arg0_18.CheckAutoUnlock)
	arg0_18:AddListener(GAME.ISLAND_FINISH_DELEGATION_DONE, arg0_18.Flush)
	arg0_18:AddListener(GAME.ISLAND_GET_DELEGATION_AWARD_DONE, arg0_18.CheckAutoUnlock)
end

function var0_0.RemoveListeners(arg0_19)
	arg0_19:RemoveListener(GAME.ISLAND_UNLOCK_TECH_DONE, arg0_19.Flush)
	arg0_19:RemoveListener(GAME.ISLAND_START_DELEGATION_DONE, arg0_19.Flush)
	arg0_19:RemoveListener(GAME.ISLAND_FINISH_TECH_IMMD_DONE, arg0_19.CheckAutoUnlock)
	arg0_19:RemoveListener(GAME.ISLAND_FINISH_DELEGATION_DONE, arg0_19.Flush)
	arg0_19:RemoveListener(GAME.ISLAND_GET_DELEGATION_AWARD_DONE, arg0_19.CheckAutoUnlock)
end

function var0_0.InitTypeItem(arg0_20, arg1_20, arg2_20)
	local var0_20 = arg0_20.commonTypes[arg1_20 + 1]

	arg2_20.name = var0_20

	local var1_20 = IslandTechBelong.Names[var0_20]

	setText(arg2_20:Find("unsel"), var1_20)
	setText(arg2_20:Find("sel/content/Text"), var1_20)
	LoadImageSpriteAsync("island/islandtechnology/tech_type_" .. IslandTechBelong.Fields[var0_20], arg2_20:Find("sel/content/Image"), true)
	onToggle(arg0_20, arg2_20, function(arg0_21)
		if arg0_21 and arg0_20.curPage ~= var0_20 then
			arg0_20.curPage = var0_20

			arg0_20:SwitchPage()
		end
	end, SFX_PANEL)
end

function var0_0.UpdateTypeItem(arg0_22, arg1_22, arg2_22)
	local var0_22 = arg0_22.commonTypes[arg1_22 + 1]

	setActive(arg2_22:Find("unsel/tip"), arg0_22:IsReceiveByType(var0_22))
	setActive(arg2_22:Find("sel/tip"), arg0_22:IsReceiveByType(var0_22))
end

function var0_0.IsReceiveByType(arg0_23, arg1_23)
	for iter0_23, iter1_23 in pairs(arg0_23.techAgency:GetTechnologys()) do
		if iter1_23:getConfig("tech_belong") == arg1_23 and iter1_23:GetStatus() == IslandTechnology.STATUS.RECEIVE then
			return true
		end
	end

	return false
end

function var0_0.FlushCentreTip(arg0_24)
	setActive(arg0_24.centreTipTF, arg0_24:IsReceiveByType(IslandTechBelong.CENTRE))
end

function var0_0.SwitchPage(arg0_25)
	for iter0_25, iter1_25 in pairs(arg0_25.pages) do
		if iter0_25 == arg0_25.curPage then
			iter1_25:ExecuteAction("Show")
		else
			iter1_25:ExecuteAction("Hide")
		end
	end
end

function var0_0.OnShow(arg0_26)
	triggerToggle(arg0_26.centreToggleTF, true)
	arg0_26.quickPanel:ExecuteAction("Show")
	arg0_26:CheckAutoUnlock()
end

function var0_0.CheckAutoUnlock(arg0_27)
	getProxy(IslandProxy):GetIsland():GetTechnologyAgency():TryAutoUnlock(function()
		arg0_27:Flush()
	end)
end

function var0_0.Flush(arg0_29)
	arg0_29.techAgency = getProxy(IslandProxy):GetIsland():GetTechnologyAgency()

	arg0_29.typeUIList:align(#arg0_29.commonTypes)
	arg0_29:FlushCentreTip()
	arg0_29.pages[arg0_29.curPage]:ExecuteAction("Flush")
	arg0_29.quickPanel:ExecuteAction("Flush")

	if arg0_29.detailPanel:isShowing() then
		arg0_29.detailPanel:ExecuteAction("Flush")
	end
end

function var0_0.OnHide(arg0_30)
	arg0_30.quickPanel:ExecuteAction("Hide")
	arg0_30.detailPanel:ExecuteAction("Hide")
end

function var0_0.OnDisable(arg0_31)
	arg0_31:OnHide()
end

function var0_0.OnDestroy(arg0_32)
	if arg0_32.quickPanel then
		arg0_32.quickPanel:Destroy()

		arg0_32.quickPanel = nil
	end

	if arg0_32.detailPanel then
		arg0_32.detailPanel:Destroy()

		arg0_32.detailPanel = nil
	end

	for iter0_32, iter1_32 in pairs(arg0_32.pages) do
		if iter1_32 then
			iter1_32:Destroy()

			iter1_32 = nil
		end
	end
end

return var0_0
