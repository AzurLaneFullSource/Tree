local var0_0 = class("FriendSearchPage", import("...base.BaseSubView"))
local var1_0 = 10

function var0_0.getUIName(arg0_1)
	return "FriendSearchUI"
end

function var0_0.OnLoaded(arg0_2)
	arg0_2.addPanel = arg0_2:findTF("add_panel")
	arg0_2.searchPanel = arg0_2:findTF("search_panel", arg0_2.addPanel)
	arg0_2.searchBar = arg0_2:findTF("InputField", arg0_2.searchPanel)
end

function var0_0.OnInit(arg0_3)
	onButton(arg0_3, findTF(arg0_3.searchPanel, "copy_btn"), function()
		UniPasteBoard.SetClipBoardString(arg0_3.playerVO.id)
		pg.TipsMgr.GetInstance():ShowTips(i18n("friend_id_copy_ok"))
	end)
	onButton(arg0_3, findTF(arg0_3.searchPanel, "search_btn"), function()
		local var0_5 = pg.TimeMgr.GetInstance():GetServerTime()

		if arg0_3.waitTimer and arg0_3.waitTimer - var0_5 > 0 then
			pg.TipsMgr.GetInstance():ShowTips(i18n("friend_searchFriend_wait_time", arg0_3.waitTimer - var0_5))

			return
		end

		arg0_3.waitTimer = var0_5 + var1_0

		local var1_5 = getInputText(arg0_3.searchBar)

		if not var1_5 or var1_5 == "" then
			pg.TipsMgr.GetInstance():ShowTips(i18n("friend_inpout_key_tip"))

			return
		end

		arg0_3.keyWord = var1_5

		arg0_3:emit(FriendMediator.SEARCH_FRIEND, 3, var1_5)
	end)
	onButton(arg0_3, findTF(arg0_3.searchPanel, "refresh_btn"), function()
		local var0_6 = pg.TimeMgr.GetInstance():GetServerTime()

		if arg0_3.waitTimer1 and arg0_3.waitTimer1 - var0_6 > 0 then
			pg.TipsMgr.GetInstance():ShowTips(i18n("friend_searchFriend_wait_time", arg0_3.waitTimer1 - var0_6))

			return
		end

		arg0_3.waitTimer1 = var0_6 + var1_0

		local var1_6 = arg0_3.keyWord

		arg0_3:emit(FriendMediator.SEARCH_FRIEND, 1, var1_6)
	end)
end

function var0_0.UpdateData(arg0_7, arg1_7)
	arg0_7.searchFriendVOs = arg1_7.searchResults or {}
	arg0_7.playerVO = arg1_7.playerVO

	if not arg0_7.isInit then
		arg0_7.isInit = true

		arg0_7:initAddPage()
		arg0_7:emit(FriendMediator.SEARCH_FRIEND, 1)
	else
		arg0_7:sortSearchResult()
	end
end

function var0_0.sortSearchResult(arg0_8)
	arg0_8.addRect:SetTotalCount(#arg0_8.searchFriendVOs, -1)
end

function var0_0.initAddPage(arg0_9)
	arg0_9.searchItems = {}

	setText(arg0_9:findTF("self_id_bg/Text", arg0_9.searchPanel), arg0_9.playerVO.id)

	arg0_9.addRect = arg0_9.addPanel:Find("mask/view"):GetComponent("LScrollRect")

	function arg0_9.addRect.onInitItem(arg0_10)
		arg0_9:onInitItem(arg0_10)
	end

	function arg0_9.addRect.onUpdateItem(arg0_11, arg1_11)
		arg0_9:onUpdateItem(arg0_11, arg1_11)
	end
end

function var0_0.onInitItem(arg0_12, arg1_12)
	local var0_12 = FriendSearchCard.New(arg1_12)

	onButton(arg0_12, var0_12.addBtn, function()
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			hideNo = true,
			yesText = "text_apply",
			type = MSGBOX_TYPE_INPUT,
			placeholder = i18n("friend_request_msg_placeholder"),
			title = i18n("friend_request_msg_title"),
			onYes = function(arg0_14)
				arg0_12:emit(FriendMediator.ADD_FRIEND, var0_12.friendVO.id, arg0_14)
			end
		})
	end, SFX_PANEL)
	onButton(arg0_12, var0_12.resumeBtn, function()
		arg0_12:emit(FriendMediator.OPEN_RESUME, var0_12.friendVO.id)
	end, SFX_PANEL)

	arg0_12.searchItems[arg1_12] = var0_12
end

function var0_0.onUpdateItem(arg0_16, arg1_16, arg2_16)
	local var0_16 = arg0_16.searchItems[arg2_16]

	if not var0_16 then
		arg0_16:onInitItem(arg2_16)

		var0_16 = arg0_16.searchItems[arg2_16]
	end

	local var1_16 = arg0_16.searchFriendVOs[arg1_16 + 1]

	var0_16:update(var1_16)
end

function var0_0.OnDestroy(arg0_17)
	for iter0_17, iter1_17 in pairs(arg0_17.searchItems or {}) do
		iter1_17:dispose()
	end
end

return var0_0
