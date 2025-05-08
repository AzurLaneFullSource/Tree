local var0_0 = class("IslandFriendSearchPage", import("view.friend.subPages.FriendSearchPage"))

function var0_0.getUIName(arg0_1)
	return "IslandFriendSearchUI"
end

function var0_0.onInitItem(arg0_2, arg1_2)
	var0_0.super.onInitItem(arg0_2, arg1_2)

	local var0_2 = arg0_2.searchItems[arg1_2]

	onButton(arg0_2, var0_2.tf:Find("frame/island_btn"), function()
		arg0_2:emit(IslandFriendMediator.ENTER_ISLAND, friendItem.friendVO.id)
	end, SFX_PANEL)
end

return var0_0
