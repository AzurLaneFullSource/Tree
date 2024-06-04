local var0 = class("FriendListPage", import("...base.BaseSubView"))

function var0.getUIName(arg0)
	return "FriendListUI"
end

function var0.OnLoaded(arg0)
	arg0.friendPanel = arg0:findTF("friend_panel")
	arg0.friendTopTF = arg0:findTF("friend_view_top")
	arg0.friendCountTF = arg0:findTF("friend_count/Text", arg0.friendTopTF)
	arg0.friendIndexBtn = arg0:findTF("index_button", arg0.friendTopTF)
	arg0.friendSortBtn = arg0:findTF("sort_button", arg0.friendTopTF)
	arg0.sortImgAsc = arg0:findTF("asc", arg0.friendSortBtn)
	arg0.sortImgDec = arg0:findTF("desc", arg0.friendSortBtn)
	arg0.sortPanel = arg0:findTF("friend_sort_panel")
end

function var0.OnInit(arg0)
	arg0.dec = false
	arg0.sortdata = {}

	onButton(arg0, arg0.friendSortBtn, function()
		arg0.dec = not arg0.dec
		arg0.contextData.sortData = {
			data = arg0.sortdata,
			dec = arg0.dec
		}

		arg0:sortFriends()
	end, SFX_PANEL)
	onButton(arg0, arg0.friendIndexBtn, function()
		arg0:openFriendsSortPanel()
	end, SFX_PANEL)
end

function var0.UpdateData(arg0, arg1)
	arg0.friendVOs = arg1.friendVOs or {}

	if not arg0.isInit then
		arg0.isInit = true

		arg0:initFriendsPage()
		arg0:initFriendsSortPanel()
	else
		arg0:sortFriends()
	end

	arg0:updateFriendCount()
end

function var0.initFriendsPage(arg0)
	arg0.friendItems = {}
	arg0.friendRect = arg0.friendPanel:Find("mask/view"):GetComponent("LScrollRect")

	function arg0.friendRect.onInitItem(arg0)
		arg0:onInitItem(arg0)
	end

	function arg0.friendRect.onUpdateItem(arg0, arg1)
		arg0:onUpdateItem(arg0, arg1)
	end
end

function var0.onInitItem(arg0, arg1)
	local var0 = FriendListCard.New(arg1)

	onButton(arg0, var0.occuptBtn, function()
		arg0:emit(FriendMediator.OPEN_CHATROOM, var0.friendVO)
	end, SFX_PANEL)
	onButton(arg0, var0.deleteBtn, function()
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			content = i18n("remove_friend_tip"),
			onYes = function()
				arg0:emit(FriendMediator.DELETE_FRIEND, var0.friendVO.id)
			end
		})
	end, SFX_PANEL)
	onButton(arg0, var0.resumeBtn, function()
		arg0:emit(FriendMediator.OPEN_RESUME, var0.friendVO.id)
	end, SFX_PANEL)
	onButton(arg0, var0.backYardBtn, function()
		arg0:emit(FriendMediator.VISIT_BACKYARD, var0.friendVO.id)
	end, SFX_PANEL)

	arg0.friendItems[arg1] = var0
end

function var0.onUpdateItem(arg0, arg1, arg2)
	local var0 = arg0.friendItems[arg2]

	if not var0 then
		arg0:onInitItem(arg2)

		var0 = arg0.friendItems[arg2]
	end

	local var1 = arg0.friendVOs[arg1 + 1]

	var0:update(var1)
end

function var0.sortFriends(arg0)
	if arg0.contextData.sortData then
		arg0.contextData.sortData.data.func(arg0.friendVOs, arg0.dec)
		setImageSprite(arg0:findTF("icon", arg0.friendIndexBtn), GetSpriteFromAtlas("ui/friendsui_atlas", arg0.contextData.sortData.data.spr), true)
		setActive(arg0.sortImgAsc, arg0.dec)
		setActive(arg0.sortImgDec, not arg0.dec)
	end

	arg0.friendRect:SetTotalCount(#arg0.friendVOs, -1)
end

function var0.updateFriendCount(arg0)
	setText(arg0.friendCountTF, #arg0.friendVOs .. "/" .. MAX_FRIEND_COUNT)
end

function var0.initFriendsSortPanel(arg0)
	local var0 = arg0:findTF("mask/content", arg0.sortPanel)
	local var1 = arg0:getTpl("tpl", var0)

	arg0.friendSortCfg = require("view.friend.FriendSortCfg")

	for iter0, iter1 in ipairs(arg0.friendSortCfg.SORT_TAG) do
		local var2 = cloneTplTo(var1, var0)
		local var3 = var2:Find("arr")

		setImageSprite(var2:Find("Image"), GetSpriteFromAtlas("ui/friendsui_atlas", iter1.spr), true)
		onToggle(arg0, var2, function(arg0)
			if arg0 then
				arg0.sortdata = iter1
				arg0.contextData.sortData = {
					data = arg0.sortdata,
					dec = arg0.dec
				}

				arg0:sortFriends()
				triggerButton(arg0.sortPanel)
			end
		end, SFX_PANEL)

		if iter0 == 1 then
			triggerToggle(var2, true)
		end
	end

	onButton(arg0, arg0.sortPanel, function()
		arg0:closeFriendsSortPanel()
	end, SFX_PANEL)
end

function var0.openFriendsSortPanel(arg0)
	if arg0.contextData.sortData then
		setImageSprite(arg0:findTF("index_button/icon", arg0.sortPanel), GetSpriteFromAtlas("ui/friendsui_atlas", arg0.contextData.sortData.data.spr), true)
	end

	setActive(arg0.sortPanel, true)
end

function var0.closeFriendsSortPanel(arg0)
	setActive(arg0.sortPanel, false)
end

function var0.OnDestroy(arg0)
	for iter0, iter1 in pairs(arg0.friendItems or {}) do
		iter1:dispose()
	end
end

return var0
