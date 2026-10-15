local var0_0 = class("FormationSuggestionScene", import("view.base.BaseUI"))

var0_0.OPEN_SHIP_INFO = "FormationSuggestionScene::OPEN_SHIP_INFO"
var0_0.SUGGESTION_TYPE = {
	PRO = 2,
	SUBMARINE = 3,
	NORMAL = 1
}

function var0_0.getUIName(arg0_1)
	return "FormationSuggestionUI"
end

function var0_0.init(arg0_2)
	onButton(arg0_2, arg0_2.uiBackBtn, function()
		if not isActive(arg0_2.uiTeamGo) then
			arg0_2:emit(FormationSuggestionMediator.ON_CLOSE_SHIP_INFO)
		else
			arg0_2:closeView()
		end
	end, SOUND_BACK)
	onButton(arg0_2, arg0_2.uiPrevBtn, function()
		if arg0_2.selectedIndex > 1 then
			arg0_2.uiList:SwitchToPage(arg0_2.selectedIndex - 1)

			for iter0_4, iter1_4 in pairs(arg0_2.uiList:GetItemList()) do
				iter1_4:OnPlayAnimation()
			end
		end
	end, SFX_PANEL)
	onButton(arg0_2, arg0_2.uiNextBtn, function()
		if arg0_2.selectedIndex < #arg0_2.mapIDList then
			arg0_2.uiList:SwitchToPage(arg0_2.selectedIndex + 1)

			for iter0_5, iter1_5 in pairs(arg0_2.uiList:GetItemList()) do
				iter1_5:OnPlayAnimation()
			end
		end
	end, SFX_PANEL)
	onToggle(arg0_2, arg0_2.uiToggle1, function(arg0_6)
		if arg0_6 and arg0_2.isInitOver then
			arg0_2:OnSwitchToggle(var0_0.SUGGESTION_TYPE.NORMAL)
			arg0_2:emit(FormationSuggestionMediator.ON_CLOSE_SHIP_INFO)
		end
	end, SFX_PANEL)
	onToggle(arg0_2, arg0_2.uiToggle2, function(arg0_7)
		if arg0_7 and arg0_2.isInitOver then
			arg0_2:OnSwitchToggle(var0_0.SUGGESTION_TYPE.PRO)
			arg0_2:emit(FormationSuggestionMediator.ON_CLOSE_SHIP_INFO)
		end
	end, SFX_PANEL)
	onToggle(arg0_2, arg0_2.uiToggle3, function(arg0_8)
		if arg0_8 and arg0_2.isInitOver then
			arg0_2:OnSwitchToggle(var0_0.SUGGESTION_TYPE.SUBMARINE)
			arg0_2:emit(FormationSuggestionMediator.ON_CLOSE_SHIP_INFO)
		end
	end, SFX_PANEL)
	onToggle(arg0_2, arg0_2.uiNormalToggle, function(arg0_9)
		if arg0_9 then
			arg0_2:OnSwitchHardMod(not arg0_9)
		end
	end)
	onToggle(arg0_2, arg0_2.uiHardToggle, function(arg0_10)
		if arg0_10 then
			arg0_2:OnSwitchHardMod(arg0_10)
		end
	end)

	arg0_2.uiList = LuaList.New(arg0_2, handler(arg0_2, arg0_2.IndexItem), arg0_2.uiListTf, FormationSuggestionTeamItem)

	arg0_2.uiList:SetPageChangeHandler(handler(arg0_2, arg0_2.OnPageChanged))
	arg0_2.uiList:SetItemRecycleHandler(handler(arg0_2, arg0_2.OnScrollHideItem))
	setText(arg0_2.uiTipsText, i18n("formation_suggestion_tip"))
	setText(arg0_2.uiFleetTitleText, i18n("formation_suggestion_tip_title"))
	setText(arg0_2.uiNormalText1, i18n("word_normal_junhe"))
	setText(arg0_2.uiNormalText2, i18n("word_normal_junhe"))
	setText(arg0_2.uiHardText1, i18n("word_hard"))
	setText(arg0_2.uiHardText1, i18n("word_hard"))
	setText(arg0_2.uiPrevText, i18n("formation_suggestion_prev_chapter"))
	setText(arg0_2.uiNextText, i18n("formation_suggestion_next_chapter"))
end

function var0_0.didEnter(arg0_11)
	arg0_11:OverlayPanel(tf(arg0_11.uiTeamGo), {
		pbList = {
			arg0_11.uiBlurTf
		}
	})

	arg0_11.selectedType = arg0_11.contextData.selectedType or var0_0.SUGGESTION_TYPE.NORMAL

	local var0_11 = arg0_11.contextData.mapID or LevelTools.GetMaxFormationSuggestionID()

	arg0_11.mapIDList = LevelTools.GetSuggestionMapIDList(var0_11)
	arg0_11.selectedIndex = arg0_11:GetMapIndex(arg0_11.mapIDList, var0_11)
	arg0_11.contextData.mapID = arg0_11.mapIDList[arg0_11.selectedIndex]

	if arg0_11.selectedType == var0_0.SUGGESTION_TYPE.NORMAL then
		triggerToggle(arg0_11.uiToggle1, true)
	elseif arg0_11.selectedType == var0_0.SUGGESTION_TYPE.PRO then
		triggerToggle(arg0_11.uiToggle2, true)
	elseif arg0_11.selectedType == var0_0.SUGGESTION_TYPE.SUBMARINE then
		triggerToggle(arg0_11.uiToggle3, true)
	end

	arg0_11.eventIDList = {
		arg0_11:bind(var0_0.OPEN_SHIP_INFO, handler(arg0_11, arg0_11.OnClickShipCard))
	}

	setActive(arg0_11.uiDifficultyGo, LevelTools.HasUnlockSuggestionHardMap())

	local var1_11 = pg.expedition_data_by_map[arg0_11.contextData.mapID]

	arg0_11.contextData.mapID = var1_11.bind_map

	if var1_11.type == 1 then
		triggerToggle(arg0_11.uiNormalToggle, true)
	else
		triggerToggle(arg0_11.uiHardToggle, true)
	end

	arg0_11.isInitOver = true
end

function var0_0.RefreshText(arg0_12)
	local var0_12 = pg.chapter_suggestion_formation[pg.chapter_suggestion_formation.get_id_list_by_chapter[arg0_12.mapIDList[arg0_12.selectedIndex]][arg0_12.selectedType]]

	setText(arg0_12.uiTitleText, var0_12.page_title)
	setScrollText(arg0_12.uiFleetTipsText, var0_12.describe)
	setGray(arg0_12.uiPrevBtn, arg0_12.selectedIndex == 1)
	setGray(arg0_12.uiNextBtn, arg0_12.selectedIndex == #arg0_12.mapIDList)
	arg0_12:emit(FormationSuggestionTeamItem.ON_REFRESH_CARD_ITEM, var0_12.id)
end

function var0_0.OnSwitchToggle(arg0_13, arg1_13)
	arg0_13.selectedType = arg1_13
	arg0_13.contextData.selectedType = arg1_13

	arg0_13:RefreshUI()
end

function var0_0.OnSwitchHardMod(arg0_14, arg1_14)
	if arg0_14.selectedHard == arg1_14 then
		return
	end

	arg0_14.selectedHard = arg1_14

	local var0_14 = arg0_14.contextData.mapID
	local var1_14 = pg.expedition_data_by_map[var0_14].bind_map

	arg0_14.mapIDList = LevelTools.GetSuggestionMapIDList(var1_14)
	arg0_14.selectedIndex = arg0_14:GetMapIndex(arg0_14.mapIDList, var1_14)
	arg0_14.contextData.mapID = var1_14

	arg0_14:RefreshText()
	arg0_14.uiList:StartScroll(#arg0_14.mapIDList, arg0_14.selectedIndex, true)
	arg0_14.uiList:Refresh()
end

function var0_0.RefreshUI(arg0_15)
	arg0_15:RefreshText()
	arg0_15.uiList:Refresh()
end

function var0_0.GetMapIndex(arg0_16, arg1_16, arg2_16)
	local var0_16 = 1

	for iter0_16 = 2, #arg1_16 do
		if arg2_16 < arg1_16[iter0_16] then
			return var0_16
		else
			var0_16 = iter0_16
		end
	end

	return var0_16
end

function var0_0.IndexItem(arg0_17, arg1_17, arg2_17)
	local var0_17 = arg0_17.mapIDList[arg1_17]
	local var1_17 = pg.chapter_suggestion_formation.get_id_list_by_chapter[var0_17][arg0_17.selectedType]

	arg2_17:SetID(var1_17)
end

function var0_0.OnPageChanged(arg0_18, arg1_18)
	arg0_18.selectedIndex = arg1_18
	arg0_18.contextData.mapID = arg0_18.mapIDList[arg0_18.selectedIndex]

	arg0_18:RefreshText()
end

function var0_0.OnScrollHideItem(arg0_19, arg1_19, arg2_19)
	arg0_19:emit(FormationSuggestionTeamItem.ON_HIDE_CARD_ITEM, arg2_19)
end

function var0_0.OnClickShipCard(arg0_20, arg1_20, arg2_20)
	arg0_20:emit(BaseUI.ON_ADD_SUBLAYER, Context.New({
		viewComponent = FormationSuggestionShipInfoScene,
		mediator = FormationSuggestionShipInfoMediator,
		data = {
			id = arg2_20
		}
	}))
end

function var0_0.OnOpenShipInfo(arg0_21)
	setActive(arg0_21.uiTeamGo, false)
	setActive(arg0_21.uiDifficultyGo, false)
end

function var0_0.OnCloseShipInfo(arg0_22)
	setActive(arg0_22.uiTeamGo, true)
	arg0_22.uiList:StartScroll(#arg0_22.mapIDList, arg0_22.selectedIndex, true)
	setActive(arg0_22.uiDifficultyGo, (LevelTools.HasUnlockSuggestionHardMap()))
end

function var0_0.willExit(arg0_23)
	arg0_23:UnOverlayPanel(tf(arg0_23.uiTeamGo), arg0_23._tf)

	for iter0_23, iter1_23 in ipairs(arg0_23.eventIDList) do
		arg0_23:disconnect(iter1_23)
	end

	arg0_23.eventIDList = nil

	arg0_23.uiList:Dispose()

	arg0_23.uiList = nil
end

return var0_0
