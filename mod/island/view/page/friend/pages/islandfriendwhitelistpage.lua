local var0_0 = class("IslandFriendWhiteListPage", import(".IslandFriendListPage"))

function var0_0.getUIName(arg0_1)
	return "IslandFriendListUI4WhitList"
end

function var0_0.OnLoaded(arg0_2)
	var0_0.super.OnLoaded(arg0_2)

	arg0_2.titleTxt = arg0_2._tf:Find("tip/Text"):GetComponent(typeof(Text))

	arg0_2:InitTitle()
end

function var0_0.InitTitle(arg0_3)
	arg0_3.titleTxt.text = i18n("island_white_list_tip")
end

function var0_0.GetData(arg0_4, arg1_4)
	local var0_4 = getProxy(IslandProxy):GetIsland():GetAccessAgency():GetWhiteList()

	if #var0_4 <= 0 then
		arg1_4(var0_4)

		return
	end

	arg0_4:emit(IslandMediator.BATCH_GET_FRIEND, var0_4, arg1_4)
end

function var0_0.OnInitItem(arg0_5, arg1_5)
	local var0_5 = IslandBlackWhitListCard.New(arg1_5)

	onButton(arg0_5, var0_5.removeBtn, function()
		arg0_5:emit(IslandMediator.REMOVE_WHITE_LIST, var0_5.player.id)
	end, SFX_PANEL)

	arg0_5.cards[arg1_5] = var0_5
end

return var0_0
