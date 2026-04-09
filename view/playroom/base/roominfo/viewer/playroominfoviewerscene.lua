local var0_0 = class("PlayRoomInfoViewerScene", import("view.base.BaseUI"))

function var0_0.getUIName(arg0_1)
	return "IslandPlayRoomInfoViewerUI"
end

function var0_0.init(arg0_2)
	arg0_2:OverlayPanel(arg0_2._tf, {
		pbList = {
			arg0_2._tf:Find("bg")
		}
	})
	onButton(arg0_2, arg0_2.uiCloseBtn, function()
		arg0_2:closeView()
	end, SFX_PANEL)
	onButton(arg0_2, arg0_2.uiSwitchBtn, function()
		local var0_4 = PlayRoomTools.GetUnfullTeamIndex()

		if var0_4 == nil then
			return
		end

		arg0_2:emit(PlayRoomInfoViewerMediator.ON_CLICK_SWITCH, {
			teamIndex = var0_4
		})
	end, SFX_PANEL)

	arg0_2.uiScrollView = LuaList.New(arg0_2, handler(arg0_2, arg0_2.IndexItem), arg0_2.uiList, PlayRoomInfoViewerItem)
end

function var0_0.didEnter(arg0_5)
	arg0_5.playRoomProxy = getProxy(PlayRoomProxy)
	arg0_5.roomData = arg0_5.playRoomProxy:GetRoomData()

	arg0_5:RefreshUI()
end

function var0_0.willExit(arg0_6)
	arg0_6:UnOverlayPanel(arg0_6._tf)
	arg0_6.uiScrollView:Dispose()

	arg0_6.uiScrollView = nil
end

function var0_0.RefreshUI(arg0_7)
	arg0_7:RefreshBtn()
	arg0_7:RefreshPlayerList()
end

function var0_0.RefreshPlayerList(arg0_8)
	arg0_8.viewerList = Clone(arg0_8.roomData.viewerList)

	local var0_8 = getProxy(PlayerProxy):getPlayerId()

	table.sort(arg0_8.viewerList, function(arg0_9, arg1_9)
		return arg0_9 == var0_8
	end)
	arg0_8.uiScrollView:StartScroll(#arg0_8.viewerList)
end

function var0_0.RefreshBtn(arg0_10)
	if PlayRoomTools.IsViewer() then
		setText(arg0_10.uiBtnText, i18n("play_room_switch_viewer"))
		setButtonEnabled(arg0_10.uiSwitchBtn, not PlayRoomTools.IsPlayerFull())
	else
		setText(arg0_10.uiBtnText, i18n("play_room_switch_player"))
		setButtonEnabled(arg0_10.uiSwitchBtn, not PlayRoomTools.IsViewerFull())
	end
end

function var0_0.IndexItem(arg0_11, arg1_11, arg2_11)
	local var0_11 = PlayRoomTools.GetHostID() == getProxy(PlayerProxy):getPlayerId()
	local var1_11 = arg0_11.viewerList[arg1_11]

	arg2_11:didEnter(arg0_11.roomData.playerDataList[var1_11], var0_11)
end

return var0_0
