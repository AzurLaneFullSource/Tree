local var0_0 = class("PlayRoomInfoInviteScene", import("view.base.BaseUI"))

var0_0.PAGE = {
	FRIEND = 1,
	GUILD = 2
}

function var0_0.getUIName(arg0_1)
	return "IslandPlayRoomInfoInviteUI"
end

function var0_0.init(arg0_2)
	arg0_2:OverlayPanel(arg0_2._tf, {
		pbList = {
			arg0_2._tf:Find("bg")
		}
	})
	onButton(arg0_2, arg0_2.uiBgBtn, function()
		arg0_2:closeView()
	end, SFX_PANEL)
	onButton(arg0_2, arg0_2.uiCloseBtn, function()
		arg0_2:closeView()
	end, SFX_PANEL)
	setText(arg0_2.uiFriendText, i18n("island_friend"))
	setText(arg0_2.uiGuildText, i18n("island_guild"))
	onToggle(arg0_2, arg0_2.uiFriendToggle, function(arg0_5)
		if arg0_5 then
			arg0_2.selectedPage = var0_0.PAGE.FRIEND

			arg0_2:RefreshUI()
		end

		arg0_2.uiFriendText.color = arg0_5 and Color.NewHex("FEFEFE") or Color.NewHex("6B6E75")
	end, SFX_PANEL)
	onToggle(arg0_2, arg0_2.uiGuildToggle, function(arg0_6)
		if arg0_6 then
			arg0_2.selectedPage = var0_0.PAGE.GUILD

			arg0_2:RefreshUI()
		end

		arg0_2.uiGuildText.color = arg0_6 and Color.NewHex("FEFEFE") or Color.NewHex("6B6E75")
	end, SFX_PANEL)

	arg0_2.uiFriendText.color = Color.NewHex("FEFEFE")
	arg0_2.uiGuildText.color = Color.NewHex("6B6E75")
	arg0_2.uiScrollView = LuaList.New(arg0_2, handler(arg0_2, arg0_2.IndexItem), arg0_2.uiList, PlayRoomInfoInviteItem)
end

function var0_0.didEnter(arg0_7)
	arg0_7.selectedPage = var0_0.PAGE.FRIEND

	triggerToggle(arg0_7.uiFriendToggle, true)
end

function var0_0.willExit(arg0_8)
	arg0_8:UnOverlayPanel(arg0_8._tf)
	arg0_8.uiScrollView:Dispose()

	arg0_8.uiScrollView = nil
end

function var0_0.RefreshUI(arg0_9)
	arg0_9.displayData = arg0_9:GetDisplayData()

	arg0_9.uiScrollView:StartScroll(#arg0_9.displayData)
	setActive(arg0_9.uiEmptyGo, #arg0_9.displayData <= 0)
end

function var0_0.IndexItem(arg0_10, arg1_10, arg2_10)
	arg2_10:didEnter(arg0_10.displayData[arg1_10])
end

function var0_0.RefreshItem(arg0_11)
	arg0_11.uiScrollView:Refresh()
end

function var0_0.GetDisplayData(arg0_12)
	local var0_12 = {}

	if arg0_12.selectedPage == var0_0.PAGE.FRIEND then
		var0_12 = getProxy(FriendProxy):getAllFriends()
	elseif arg0_12.selectedPage == var0_0.PAGE.GUILD then
		local var1_12 = getProxy(GuildProxy):getRawData()

		var0_12 = var1_12 and var1_12:getSortMemberWithoutSelf() or {}
	end

	table.sort(var0_12, function(arg0_13, arg1_13)
		local var0_13 = arg0_13:isOnline()

		if var0_13 ~= arg1_13:isOnline() then
			return var0_13 == true
		end

		return arg0_13.preOnLineTime >= arg1_13.preOnLineTime
	end)

	return var0_12
end

return var0_0
