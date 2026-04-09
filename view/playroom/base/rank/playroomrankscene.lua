local var0_0 = class("PlayRoomRankScene", import("view.base.BaseUI"))

var0_0.PAGE = {
	ALL = 0,
	FRIEND = 1,
	GUILD = 2
}

function var0_0.getUIName(arg0_1)
	return "IslandPlayRoomRankUI"
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
	setText(arg0_2.uiFriendText1, i18n("island_friend"))
	setText(arg0_2.uiFriendText2, i18n("island_friend"))
	setText(arg0_2.uiGuildText1, i18n("island_guild"))
	setText(arg0_2.uiGuildText2, i18n("island_guild"))
	setText(arg0_2.uiAllText1, i18n("channel_name_1"))
	setText(arg0_2.uiAllText2, i18n("channel_name_1"))
	triggerToggle(arg0_2.uiFriendToggle, true)
	onToggle(arg0_2, arg0_2.uiFriendToggle, function(arg0_5)
		if arg0_5 then
			arg0_2.selectedPage = var0_0.PAGE.FRIEND

			arg0_2:RefreshUI()
		end
	end, SFX_PANEL)
	onToggle(arg0_2, arg0_2.uiGuildToggle, function(arg0_6)
		if arg0_6 then
			arg0_2.selectedPage = var0_0.PAGE.GUILD

			arg0_2:RefreshUI()
		end
	end, SFX_PANEL)
	onToggle(arg0_2, arg0_2.uiAllToggle, function(arg0_7)
		if arg0_7 then
			arg0_2.selectedPage = var0_0.PAGE.ALL

			arg0_2:RefreshUI()
		end
	end, SFX_PANEL)

	arg0_2.uiScrollView = LuaList.New(arg0_2, handler(arg0_2, arg0_2.IndexItem), arg0_2.uiList, PlayRoomRankItem)
	arg0_2.rankItemView = PlayRoomRankItem.New(arg0_2.uiItem, arg0_2)
end

function var0_0.didEnter(arg0_8)
	arg0_8.selectedPage = var0_0.PAGE.FRIEND
end

function var0_0.willExit(arg0_9)
	arg0_9:UnOverlayPanel(arg0_9._tf)
	arg0_9.uiScrollView:Dispose()

	arg0_9.uiScrollView = nil

	arg0_9.rankItemView:willExit()

	arg0_9.rankItemView = nil
end

function var0_0.RefreshUI(arg0_10)
	arg0_10.displayData = arg0_10:GetDisplayData()

	arg0_10.uiScrollView:StartScroll(#arg0_10.displayData)
	arg0_10.rankItemView:didEnter(getProxy(PlayRoomProxy):GetSelfRankData(arg0_10.contextData.gameType))
end

function var0_0.IndexItem(arg0_11, arg1_11, arg2_11)
	arg2_11:didEnter(arg0_11.displayData[arg1_11])
end

function var0_0.GetDisplayData(arg0_12)
	local var0_12 = {}
	local var1_12 = {}
	local var2_12 = getProxy(PlayRoomProxy):GetRankData(arg0_12.contextData.gameType)

	if arg0_12.selectedPage == var0_0.PAGE.FRIEND then
		var1_12 = getProxy(FriendProxy):getAllFriends()
	elseif arg0_12.selectedPage == var0_0.PAGE.GUILD then
		local var3_12 = getProxy(GuildProxy):getRawData()

		var1_12 = var3_12 and var3_12:getSortMemberWithoutSelf() or {}
	else
		return var2_12
	end

	local var4_12 = {}

	for iter0_12, iter1_12 in ipairs(var1_12) do
		table.insert(var4_12, iter1_12.id)
	end

	for iter2_12, iter3_12 in ipairs(var2_12) do
		if table.keyof(var4_12, iter3_12.playerData.id) then
			table.insert(var0_12, iter3_12)
		end
	end

	return var0_12
end

return var0_0
