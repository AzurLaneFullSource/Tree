local var0_0 = class("IslandFriendBlackListPage", import(".IslandFriendWhiteListPage"))

function var0_0.getUIName(arg0_1)
	return "IslandFriendListUI4BlackList"
end

function var0_0.InitTitle(arg0_2)
	arg0_2.titleTxt.text = i18n("island_black_list_tip")
end

function var0_0.GetData(arg0_3, arg1_3)
	local var0_3 = getProxy(IslandProxy):GetIsland():GetAccessAgency():GetBlackList()

	if #var0_3 <= 0 then
		arg1_3(var0_3)

		return
	end

	arg0_3:emit(IslandMediator.BATCH_GET_FRIEND, var0_3, arg1_3)
end

function var0_0.OnInitItem(arg0_4, arg1_4)
	local var0_4 = IslandBlackWhitListCard.New(arg1_4)

	onButton(arg0_4, var0_4.removeBtn, function()
		arg0_4:emit(IslandMediator.REMOVE_BLACK_LIST, var0_4.player.id)
	end, SFX_PANEL)

	arg0_4.cards[arg1_4] = var0_4
end

return var0_0
