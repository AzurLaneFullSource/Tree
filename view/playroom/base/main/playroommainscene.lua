local var0_0 = class("PlayRoomMainScene", import("view.base.BaseUI"))

var0_0.ON_CLICK_ITEM_BTN = "PlayRoomMainScene:ON_CLICK_ITEM_BTN"

function var0_0.getUIName(arg0_1)
	return "IslandPlayRoomMainUI"
end

function var0_0.init(arg0_2)
	arg0_2:OverlayPanel(arg0_2._tf, {
		pbList = {
			arg0_2._tf:Find("bg"),
			arg0_2.uiCreatePanel
		}
	})
	setText(arg0_2.uiTitleText, i18n("play_room_season"))
	setText(arg0_2.uiTitleEnText, i18n("play_room_season_en"))
	setText(arg0_2.uiCreateRoomText, i18n("match_ui_room_create"))
	setText(arg0_2.uiSearchText, i18n("match_ui_room_search"))

	arg0_2.uiLScrollView = LuaList.New(arg0_2, handler(arg0_2, arg0_2.IndexItem), arg0_2.uiScrollViewTf, PlayRoomMainItem)

	onButton(arg0_2, arg0_2.uiCloseBtn, function()
		arg0_2:closeView()
	end, SFX_PANEL)
	onButton(arg0_2, arg0_2.uiCreateRoomBtn, function()
		setActive(arg0_2.uiCreatePanel, true)
	end, SFX_PANEL)
	onButton(arg0_2, arg0_2.uiQuickRoomBtn, function()
		arg0_2:emit(PlayRoomMainMediator.JOIN_ROOM, {
			id = 0
		})
	end, SFX_PANEL)
	setText(arg0_2.uiQuickRoomBtn:Find("Text"), i18n("island_bar_quick_game"))
	onButton(arg0_2, arg0_2.uiRefreshRoomBtn, function()
		arg0_2:emit(PlayRoomMainMediator.REFRESH_ROOM_LIST)
	end, SFX_PANEL)
	onButton(arg0_2, arg0_2.uiSearchBtn, function()
		if arg0_2.uiInputField.text == "" then
			return
		end

		arg0_2.searchList = PlayRoomTools.SearchRoomList(arg0_2.uiInputField.text)

		arg0_2:RefreshRoomList()
	end, SFX_PANEL)
	onInputChanged(arg0_2, arg0_2.uiInputField, function()
		if arg0_2.uiInputField.text == "" and arg0_2.searchList then
			arg0_2.searchList = nil

			arg0_2:RefreshRoomList()
		end
	end)
	onButton(arg0_2, arg0_2.uiSortBtn, function()
		arg0_2.selectedAscend = not arg0_2.selectedAscend

		arg0_2:RefreshUI()
	end, SFX_PANEL)
	onButton(arg0_2, arg0_2.uiFilterBtn, function()
		arg0_2.filterPanelView:Show(true)
	end, SFX_PANEL)
	onButton(arg0_2, arg0_2.uiCommonBtn, function()
		arg0_2:emit(PlayRoomMainMediator.CREATE_ROOM, {
			type = PlayRoomConst.PLAY_ROOM_TYPE.COMMON,
			gameType = arg0_2:GetGameType()
		})
	end, SFX_PANEL)
	onButton(arg0_2, arg0_2.uiPersonBtn, function()
		arg0_2:emit(PlayRoomMainMediator.CREATE_ROOM, {
			type = PlayRoomConst.PLAY_ROOM_TYPE.PERSON,
			gameType = arg0_2:GetGameType()
		})
	end, SFX_PANEL)
	onButton(arg0_2, arg0_2.uiCloseCreateBtn, function()
		setActive(arg0_2.uiCreatePanel, false)
	end)
end

function var0_0.didEnter(arg0_14)
	arg0_14:RefreshInputField()

	arg0_14.contextData.selectedRoomSortType = PlayRoomConst.ROOM_SORT_TYPE.ROOM_PLAYER_SUM
	arg0_14.contextData.selectedRoomType = PlayRoomConst.PLAY_ROOM_TYPE.ALL
	arg0_14.contextData.selectedRoomState = PlayRoomConst.PLAY_ROOM_STATE.ALL
	arg0_14.selectedAscend = true
	arg0_14.filterPanelView = PlayRoomMainFilterView.New(arg0_14.uiFilterPanel, arg0_14, arg0_14.contextData)
	arg0_14.eventList = {
		arg0_14:bind(var0_0.ON_CLICK_ITEM_BTN, handler(arg0_14, arg0_14.OnRefreshSortBtn))
	}

	arg0_14:emit(PlayRoomMainMediator.REFRESH_ROOM_LIST)
end

function var0_0.willExit(arg0_15)
	arg0_15:UnOverlayPanel(arg0_15._tf)

	for iter0_15, iter1_15 in ipairs(arg0_15.eventList) do
		arg0_15:disconnect(iter1_15)
	end

	arg0_15.filterPanelView:willExit()

	arg0_15.filterPanelView = nil

	arg0_15.uiLScrollView:Dispose()

	arg0_15.uiLScrollView = nil
end

function var0_0.GetGameType(arg0_16)
	return arg0_16.contextData.gameType
end

function var0_0.FilterRoomList(arg0_17, arg1_17)
	arg1_17 = PlayRoomTools.FilterRoomType(arg1_17, arg0_17.contextData.selectedRoomType)
	arg1_17 = PlayRoomTools.FilterRoomState(arg1_17, arg0_17.contextData.selectedRoomState)
	arg1_17 = PlayRoomTools.SortRoomList(arg1_17, arg0_17.contextData.selectedRoomSortType, arg0_17.selectedAscend)

	return arg1_17
end

function var0_0.RefreshUI(arg0_18)
	arg0_18:RefreshSortText()
	arg0_18:RefreshSortAscend()
	arg0_18:RefreshRoomList()

	arg0_18.uiSortArrTf.localScale = arg0_18.selectedAscend and Vector2(1, -1, 1) or Vector2(1, 1, 1)
end

function var0_0.RefreshRoomList(arg0_19)
	local var0_19

	if arg0_19.searchList then
		var0_19 = arg0_19.searchList
	else
		var0_19 = getProxy(PlayRoomProxy):GetPlayRoomList()
	end

	local var1_19 = arg0_19:FilterRoomList(var0_19)

	arg0_19.sortList = var1_19

	arg0_19.uiLScrollView:StartScroll(#var1_19)
	setActive(arg0_19.uiEmptyGo, #var1_19 <= 0)
end

function var0_0.RefreshInputField(arg0_20)
	arg0_20.uiInputField.text = ""
end

function var0_0.IndexItem(arg0_21, arg1_21, arg2_21)
	arg2_21:didEnter(arg0_21.sortList[arg1_21])
end

function var0_0.ShowFilterPanel(arg0_22, arg1_22)
	arg0_22.filterPanelView:Show(arg1_22)
end

function var0_0.OnRefreshSortBtn(arg0_23)
	arg0_23.filterPanelView:RefreshUI()
	arg0_23:RefreshUI()
end

function var0_0.RefreshSortText(arg0_24)
	setText(arg0_24.uiSortText, PlayRoomConst.SORT_TEXT[arg0_24.contextData.selectedRoomSortType])
end

function var0_0.RefreshSortAscend(arg0_25)
	return
end

function var0_0.OnCreateRoomOver(arg0_26)
	setActive(arg0_26.uiCreatePanel, false)
	arg0_26:RefreshUI()
end

function var0_0.OnQuickRoomFail(arg0_27)
	pg.MsgboxMgr.GetInstance():ShowMsgBox({
		content = i18n("island_bar_quick_tip"),
		onYes = function()
			triggerButton(arg0_27.uiCreateRoomBtn)
		end
	})
end

return var0_0
