local var0_0 = class("PlayRoomMainItem", import("view.base.BasePanel"))

function var0_0.Ctor(arg0_1, arg1_1, arg2_1)
	arg0_1._go = arg1_1.gameObject
	arg0_1._tf = arg1_1
	arg0_1._parentClass = arg2_1

	bindComponent(arg0_1, arg0_1._go)
	arg0_1:attach(arg2_1)
	arg0_1:Init()
end

function var0_0.Init(arg0_2)
	setText(arg0_2.uiPersonText, i18n("match_ui_room_type4"))
	setText(arg0_2.uiFullText, i18n("match_ui_room_type3"))
	setText(arg0_2.uiPlayingText, i18n("match_ui_room_type1"))
	setText(arg0_2.uiJoinText, i18n("match_ui_room_type2"))
end

function var0_0.didEnter(arg0_3, arg1_3)
	setText(arg0_3.uiNameText, i18n("match_ui_room_name", arg1_3.name))
	setActive(arg0_3.uiViewerCntText, not PlayRoomConst.HIDE_VIEWER)
	setText(arg0_3.uiViewerCntText, i18n("play_room_viewer_tip", arg1_3.viewerCnt, PlayRoomTools.GetMaxViewerCnt(arg1_3.gameType)))
	setText(arg0_3.uiPlayerCntText, string.format("%s/%s", arg1_3.teamCnt, PlayRoomTools.GetMaxTeamCnt(arg1_3.gameType)))

	local var0_3 = arg1_3.roomState

	if var0_3 == PlayRoomConst.PLAY_ROOM_STATE.WAIT then
		setActive(arg0_3.uiJoinBtn, true)
		setActive(arg0_3.uiPersonPanel, false)
		setActive(arg0_3.uiFullPanel, false)
		setActive(arg0_3.uiPlayingPanel, false)
		onButton(arg0_3, arg0_3.uiJoinBtn, function()
			arg0_3:emit(PlayRoomMainMediator.JOIN_ROOM, {
				id = arg1_3.id,
				gameType = arg0_3.contextData.gameType
			})
		end, SFX_PANEL)
	end

	if arg1_3.roomType == PlayRoomConst.PLAY_ROOM_TYPE.PERSON then
		setActive(arg0_3.uiJoinBtn, false)
		setActive(arg0_3.uiPersonPanel, true)
		setActive(arg0_3.uiFullPanel, false)
		setActive(arg0_3.uiPlayingPanel, false)
	elseif var0_3 == PlayRoomConst.PLAY_ROOM_STATE.FULL then
		setActive(arg0_3.uiJoinBtn, false)
		setActive(arg0_3.uiPersonPanel, false)
		setActive(arg0_3.uiFullPanel, true)
		setActive(arg0_3.uiPlayingPanel, false)
	elseif var0_3 == PlayRoomConst.PLAY_ROOM_STATE.PLAYING then
		setActive(arg0_3.uiJoinBtn, false)
		setActive(arg0_3.uiPersonPanel, false)
		setActive(arg0_3.uiFullPanel, false)
		setActive(arg0_3.uiPlayingPanel, true)
	end
end

function var0_0.willExit(arg0_5)
	arg0_5:detach()
end

return var0_0
