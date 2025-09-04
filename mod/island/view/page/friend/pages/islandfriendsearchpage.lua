local var0_0 = class("IslandFriendSearchPage", import(".IslandFriendListPage"))
local var1_0 = 10

function var0_0.getUIName(arg0_1)
	return "IslandFriendSearchUI"
end

function var0_0.OnLoaded(arg0_2)
	var0_0.super.OnLoaded(arg0_2)

	arg0_2.idTxt = arg0_2:findTF("top/id/Text"):GetComponent(typeof(Text))
	arg0_2.copyBtn = arg0_2:findTF("top/id/copy")
	arg0_2.saerchBtn = arg0_2:findTF("top/search/copy")
	arg0_2.searchBar = arg0_2:findTF("top/search/input")
	arg0_2.displays = {}

	setText(arg0_2:findTF("top/id/copy/Text"), i18n("island_btn_label_copy"))
	setText(arg0_2:findTF("top/search/copy/Text"), i18n("island_search"))
	setText(arg0_2:findTF("top/search/input/Text"), i18n("island_input_my_id"))
	setText(arg0_2:findTF("top/id/label"), i18n("island_my_id"))
end

function var0_0.OnSearch(arg0_3, arg1_3)
	arg0_3.displays = arg1_3.list

	arg0_3:InitList()
end

function var0_0.CreateCard(arg0_4, arg1_4)
	return IslandFriendSearchCard.New(arg1_4)
end

function var0_0.OnInitItem(arg0_5, arg1_5)
	var0_0.super.OnInitItem(arg0_5, arg1_5)

	local var0_5 = arg0_5.cards[arg1_5]

	onButton(arg0_5, var0_5.addBtn, function()
		arg0_5:emit(IslandMediator.ADD_FRIEND, var0_5.player.id, "")
	end, SFX_PANEL)
end

function var0_0.InitMoreBtns(arg0_7, arg1_7)
	onButton(arg0_7, arg0_7.whiteBtn, function()
		arg0_7:emit(IslandMediator.ADD_WHITE_LIST, arg1_7.id)
	end, SFX_PANEL)
	onButton(arg0_7, arg0_7.blackBtn, function()
		arg0_7:emit(IslandMediator.ADD_BLACK_LIST, arg1_7.id)
	end, SFX_PANEL)
end

function var0_0.GetData(arg0_10, arg1_10)
	arg1_10(arg0_10.displays)
end

function var0_0.OnInit(arg0_11)
	var0_0.super.OnInit(arg0_11)

	arg0_11.player = getProxy(PlayerProxy):getRawData()
	arg0_11.idTxt.text = arg0_11.player.id

	onButton(arg0_11, arg0_11.copyBtn, function()
		UniPasteBoard.SetClipBoardString(arg0_11.player.id)
		pg.TipsMgr.GetInstance():ShowTips(i18n("friend_id_copy_ok"))
	end, SFX_PANEL)
	onButton(arg0_11, arg0_11.saerchBtn, function()
		local var0_13 = pg.TimeMgr.GetInstance():GetServerTime()

		if arg0_11.waitTimer and arg0_11.waitTimer - var0_13 > 0 then
			pg.TipsMgr.GetInstance():ShowTips(i18n("friend_searchFriend_wait_time", arg0_11.waitTimer - var0_13))

			return
		end

		arg0_11.waitTimer = var0_13 + var1_0

		local var1_13 = getInputText(arg0_11.searchBar)

		if not var1_13 or var1_13 == "" then
			pg.TipsMgr.GetInstance():ShowTips(i18n("friend_inpout_key_tip"))

			return
		end

		arg0_11:emit(IslandMediator.SEARCH_FRIEND, 3, var1_13)
	end, SFX_PANEL)
end

return var0_0
