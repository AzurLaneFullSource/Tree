local var0 = class("FriendSearchPage", import("...base.BaseSubView"))
local var1 = 10

function var0.getUIName(arg0)
	return "FriendSearchUI"
end

function var0.OnLoaded(arg0)
	arg0.addPanel = arg0:findTF("add_panel")
	arg0.searchPanel = arg0:findTF("search_panel", arg0.addPanel)
	arg0.searchBar = arg0:findTF("InputField", arg0.searchPanel)
end

function var0.OnInit(arg0)
	onButton(arg0, findTF(arg0.searchPanel, "copy_btn"), function()
		UniPasteBoard.SetClipBoardString(arg0.playerVO.id)
		pg.TipsMgr.GetInstance():ShowTips(i18n("friend_id_copy_ok"))
	end)
	onButton(arg0, findTF(arg0.searchPanel, "search_btn"), function()
		local var0 = pg.TimeMgr.GetInstance():GetServerTime()

		if arg0.waitTimer and arg0.waitTimer - var0 > 0 then
			pg.TipsMgr.GetInstance():ShowTips(i18n("friend_searchFriend_wait_time", arg0.waitTimer - var0))

			return
		end

		arg0.waitTimer = var0 + var1

		local var1 = getInputText(arg0.searchBar)

		if not var1 or var1 == "" then
			pg.TipsMgr.GetInstance():ShowTips(i18n("friend_inpout_key_tip"))

			return
		end

		arg0.keyWord = var1

		arg0:emit(FriendMediator.SEARCH_FRIEND, 3, var1)
	end)
	onButton(arg0, findTF(arg0.searchPanel, "refresh_btn"), function()
		local var0 = pg.TimeMgr.GetInstance():GetServerTime()

		if arg0.waitTimer1 and arg0.waitTimer1 - var0 > 0 then
			pg.TipsMgr.GetInstance():ShowTips(i18n("friend_searchFriend_wait_time", arg0.waitTimer1 - var0))

			return
		end

		arg0.waitTimer1 = var0 + var1

		local var1 = arg0.keyWord

		arg0:emit(FriendMediator.SEARCH_FRIEND, 1, var1)
	end)
end

function var0.UpdateData(arg0, arg1)
	arg0.searchFriendVOs = arg1.searchResults or {}
	arg0.playerVO = arg1.playerVO

	if not arg0.isInit then
		arg0.isInit = true

		arg0:initAddPage()
		arg0:emit(FriendMediator.SEARCH_FRIEND, 1)
	else
		arg0:sortSearchResult()
	end
end

function var0.sortSearchResult(arg0)
	arg0.addRect:SetTotalCount(#arg0.searchFriendVOs, -1)
end

function var0.initAddPage(arg0)
	arg0.searchItems = {}

	setText(arg0:findTF("self_id_bg/Text", arg0.searchPanel), arg0.playerVO.id)

	arg0.addRect = arg0.addPanel:Find("mask/view"):GetComponent("LScrollRect")

	function arg0.addRect.onInitItem(arg0)
		arg0:onInitItem(arg0)
	end

	function arg0.addRect.onUpdateItem(arg0, arg1)
		arg0:onUpdateItem(arg0, arg1)
	end
end

function var0.onInitItem(arg0, arg1)
	local var0 = FriendSearchCard.New(arg1)

	onButton(arg0, var0.addBtn, function()
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			hideNo = true,
			yesText = "text_apply",
			type = MSGBOX_TYPE_INPUT,
			placeholder = i18n("friend_request_msg_placeholder"),
			title = i18n("friend_request_msg_title"),
			onYes = function(arg0)
				arg0:emit(FriendMediator.ADD_FRIEND, var0.friendVO.id, arg0)
			end
		})
	end, SFX_PANEL)
	onButton(arg0, var0.resumeBtn, function()
		arg0:emit(FriendMediator.OPEN_RESUME, var0.friendVO.id)
	end, SFX_PANEL)

	arg0.searchItems[arg1] = var0
end

function var0.onUpdateItem(arg0, arg1, arg2)
	local var0 = arg0.searchItems[arg2]

	if not var0 then
		arg0:onInitItem(arg2)

		var0 = arg0.searchItems[arg2]
	end

	local var1 = arg0.searchFriendVOs[arg1 + 1]

	var0:update(var1)
end

function var0.OnDestroy(arg0)
	for iter0, iter1 in pairs(arg0.searchItems or {}) do
		iter1:dispose()
	end
end

return var0
