local var0_0 = class("PlayRoomMainFilterView", import("view.base.BasePanel"))

function var0_0.Ctor(arg0_1, arg1_1, arg2_1, arg3_1)
	arg0_1._go = arg1_1.gameObject

	var0_0.super.Ctor(arg0_1, arg0_1._go)

	arg0_1._parentClass = arg2_1

	arg0_1:attach(arg2_1)

	arg0_1.contextData = arg3_1

	arg0_1:InitData()
	arg0_1:Init()
end

function var0_0.InitData(arg0_2)
	arg0_2.filterData = {
		{
			type = PlayRoomConst.ROOM_FILTER_TYPE.SORT,
			titleText = i18n("match_ui_room_filtertitle1"),
			btnList = {
				{
					text = PlayRoomConst.SORT_TEXT[PlayRoomConst.ROOM_SORT_TYPE.ROOM_PLAYER_SUM],
					clickBtn = function()
						arg0_2.contextData.selectedRoomSortType = PlayRoomConst.ROOM_SORT_TYPE.ROOM_PLAYER_SUM

						arg0_2:emit(PlayRoomMainScene.ON_CLICK_ITEM_BTN)
					end,
					selected = function()
						return arg0_2.contextData.selectedRoomSortType == PlayRoomConst.ROOM_SORT_TYPE.ROOM_PLAYER_SUM
					end
				},
				{
					text = PlayRoomConst.SORT_TEXT[PlayRoomConst.ROOM_SORT_TYPE.ROOM_CREATE_TIME],
					clickBtn = function()
						arg0_2.contextData.selectedRoomSortType = PlayRoomConst.ROOM_SORT_TYPE.ROOM_CREATE_TIME

						arg0_2:emit(PlayRoomMainScene.ON_CLICK_ITEM_BTN)
					end,
					selected = function()
						return arg0_2.contextData.selectedRoomSortType == PlayRoomConst.ROOM_SORT_TYPE.ROOM_CREATE_TIME
					end
				}
			}
		},
		{
			type = PlayRoomConst.ROOM_FILTER_TYPE.ROOM,
			titleText = i18n("match_ui_room_filtertitle2"),
			btnList = {
				{
					text = i18n("match_ui_room_filter4"),
					clickBtn = function()
						arg0_2.contextData.selectedRoomType = PlayRoomConst.PLAY_ROOM_TYPE.ALL

						arg0_2:emit(PlayRoomMainScene.ON_CLICK_ITEM_BTN)
					end,
					selected = function()
						return arg0_2.contextData.selectedRoomType == PlayRoomConst.PLAY_ROOM_TYPE.ALL
					end
				},
				{
					text = i18n("match_ui_room_filter5"),
					clickBtn = function()
						arg0_2.contextData.selectedRoomType = PlayRoomConst.PLAY_ROOM_TYPE.COMMON

						arg0_2:emit(PlayRoomMainScene.ON_CLICK_ITEM_BTN)
					end,
					selected = function()
						return arg0_2.contextData.selectedRoomType == PlayRoomConst.PLAY_ROOM_TYPE.COMMON
					end
				},
				{
					text = i18n("match_ui_room_filter6"),
					clickBtn = function()
						arg0_2.contextData.selectedRoomType = PlayRoomConst.PLAY_ROOM_TYPE.PERSON

						arg0_2:emit(PlayRoomMainScene.ON_CLICK_ITEM_BTN)
					end,
					selected = function()
						return arg0_2.contextData.selectedRoomType == PlayRoomConst.PLAY_ROOM_TYPE.PERSON
					end
				}
			}
		},
		{
			type = PlayRoomConst.ROOM_FILTER_TYPE.STATE,
			titleText = i18n("match_ui_room_filtertitle3"),
			btnList = {
				{
					text = i18n("match_ui_room_filter7"),
					clickBtn = function()
						arg0_2.contextData.selectedRoomState = PlayRoomConst.PLAY_ROOM_STATE.ALL

						arg0_2:emit(PlayRoomMainScene.ON_CLICK_ITEM_BTN)
					end,
					selected = function()
						return arg0_2.contextData.selectedRoomState == PlayRoomConst.PLAY_ROOM_STATE.ALL
					end
				},
				{
					text = i18n("match_ui_room_filter8"),
					clickBtn = function()
						arg0_2.contextData.selectedRoomState = PlayRoomConst.PLAY_ROOM_STATE.WAIT

						arg0_2:emit(PlayRoomMainScene.ON_CLICK_ITEM_BTN)
					end,
					selected = function()
						return arg0_2.contextData.selectedRoomState == PlayRoomConst.PLAY_ROOM_STATE.WAIT
					end
				},
				{
					text = i18n("match_ui_room_filter9"),
					clickBtn = function()
						arg0_2.contextData.selectedRoomState = PlayRoomConst.PLAY_ROOM_STATE.PLAYING

						arg0_2:emit(PlayRoomMainScene.ON_CLICK_ITEM_BTN)
					end,
					selected = function()
						return arg0_2.contextData.selectedRoomState == PlayRoomConst.PLAY_ROOM_STATE.PLAYING
					end
				}
			}
		}
	}
end

function var0_0.Init(arg0_19)
	arg0_19.panelList = {}

	for iter0_19, iter1_19 in pairs(arg0_19.filterData) do
		arg0_19.panelList[iter0_19] = PlayRoomMainFilterPanel.New(Object.Instantiate(arg0_19.uiSortPanel, arg0_19.uiMainPanel), arg0_19)

		arg0_19.panelList[iter0_19]:didEnter(iter1_19, arg0_19.contextData)
	end

	onButton(arg0_19, arg0_19.uiCloseBtn, function()
		arg0_19:Show(false)
	end)
	setActive(arg0_19._go, false)
end

function var0_0.willExit(arg0_21)
	for iter0_21, iter1_21 in ipairs(arg0_21.panelList) do
		iter1_21:willExit()
	end

	arg0_21.panelList = nil

	arg0_21:detach()
end

function var0_0.Show(arg0_22, arg1_22)
	if arg1_22 then
		arg0_22:RefreshUI()
	end

	setActive(arg0_22._go, arg1_22)
end

function var0_0.RefreshUI(arg0_23)
	for iter0_23, iter1_23 in ipairs(arg0_23.panelList) do
		iter1_23:RefreshUI()
	end
end

return var0_0
