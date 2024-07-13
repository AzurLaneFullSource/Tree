local var0_0 = class("FriendListPage", import("...base.BaseSubView"))

function var0_0.getUIName(arg0_1)
	return "FriendListUI"
end

function var0_0.OnLoaded(arg0_2)
	arg0_2.friendPanel = arg0_2:findTF("friend_panel")
	arg0_2.friendTopTF = arg0_2:findTF("friend_view_top")
	arg0_2.friendCountTF = arg0_2:findTF("friend_count/Text", arg0_2.friendTopTF)
	arg0_2.friendIndexBtn = arg0_2:findTF("index_button", arg0_2.friendTopTF)
	arg0_2.friendSortBtn = arg0_2:findTF("sort_button", arg0_2.friendTopTF)
	arg0_2.sortImgAsc = arg0_2:findTF("asc", arg0_2.friendSortBtn)
	arg0_2.sortImgDec = arg0_2:findTF("desc", arg0_2.friendSortBtn)
	arg0_2.sortPanel = arg0_2:findTF("friend_sort_panel")
end

function var0_0.OnInit(arg0_3)
	arg0_3.dec = false
	arg0_3.sortdata = {}

	onButton(arg0_3, arg0_3.friendSortBtn, function()
		arg0_3.dec = not arg0_3.dec
		arg0_3.contextData.sortData = {
			data = arg0_3.sortdata,
			dec = arg0_3.dec
		}

		arg0_3:sortFriends()
	end, SFX_PANEL)
	onButton(arg0_3, arg0_3.friendIndexBtn, function()
		arg0_3:openFriendsSortPanel()
	end, SFX_PANEL)
end

function var0_0.UpdateData(arg0_6, arg1_6)
	arg0_6.friendVOs = arg1_6.friendVOs or {}

	if not arg0_6.isInit then
		arg0_6.isInit = true

		arg0_6:initFriendsPage()
		arg0_6:initFriendsSortPanel()
	else
		arg0_6:sortFriends()
	end

	arg0_6:updateFriendCount()
end

function var0_0.initFriendsPage(arg0_7)
	arg0_7.friendItems = {}
	arg0_7.friendRect = arg0_7.friendPanel:Find("mask/view"):GetComponent("LScrollRect")

	function arg0_7.friendRect.onInitItem(arg0_8)
		arg0_7:onInitItem(arg0_8)
	end

	function arg0_7.friendRect.onUpdateItem(arg0_9, arg1_9)
		arg0_7:onUpdateItem(arg0_9, arg1_9)
	end
end

function var0_0.onInitItem(arg0_10, arg1_10)
	local var0_10 = FriendListCard.New(arg1_10)

	onButton(arg0_10, var0_10.occuptBtn, function()
		arg0_10:emit(FriendMediator.OPEN_CHATROOM, var0_10.friendVO)
	end, SFX_PANEL)
	onButton(arg0_10, var0_10.deleteBtn, function()
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			content = i18n("remove_friend_tip"),
			onYes = function()
				arg0_10:emit(FriendMediator.DELETE_FRIEND, var0_10.friendVO.id)
			end
		})
	end, SFX_PANEL)
	onButton(arg0_10, var0_10.resumeBtn, function()
		arg0_10:emit(FriendMediator.OPEN_RESUME, var0_10.friendVO.id)
	end, SFX_PANEL)
	onButton(arg0_10, var0_10.backYardBtn, function()
		arg0_10:emit(FriendMediator.VISIT_BACKYARD, var0_10.friendVO.id)
	end, SFX_PANEL)

	arg0_10.friendItems[arg1_10] = var0_10
end

function var0_0.onUpdateItem(arg0_16, arg1_16, arg2_16)
	local var0_16 = arg0_16.friendItems[arg2_16]

	if not var0_16 then
		arg0_16:onInitItem(arg2_16)

		var0_16 = arg0_16.friendItems[arg2_16]
	end

	local var1_16 = arg0_16.friendVOs[arg1_16 + 1]

	var0_16:update(var1_16)
end

function var0_0.sortFriends(arg0_17)
	if arg0_17.contextData.sortData then
		arg0_17.contextData.sortData.data.func(arg0_17.friendVOs, arg0_17.dec)
		setImageSprite(arg0_17:findTF("icon", arg0_17.friendIndexBtn), GetSpriteFromAtlas("ui/friendsui_atlas", arg0_17.contextData.sortData.data.spr), true)
		setActive(arg0_17.sortImgAsc, arg0_17.dec)
		setActive(arg0_17.sortImgDec, not arg0_17.dec)
	end

	arg0_17.friendRect:SetTotalCount(#arg0_17.friendVOs, -1)
end

function var0_0.updateFriendCount(arg0_18)
	setText(arg0_18.friendCountTF, #arg0_18.friendVOs .. "/" .. MAX_FRIEND_COUNT)
end

function var0_0.initFriendsSortPanel(arg0_19)
	local var0_19 = arg0_19:findTF("mask/content", arg0_19.sortPanel)
	local var1_19 = arg0_19:getTpl("tpl", var0_19)

	arg0_19.friendSortCfg = require("view.friend.FriendSortCfg")

	for iter0_19, iter1_19 in ipairs(arg0_19.friendSortCfg.SORT_TAG) do
		local var2_19 = cloneTplTo(var1_19, var0_19)
		local var3_19 = var2_19:Find("arr")

		setImageSprite(var2_19:Find("Image"), GetSpriteFromAtlas("ui/friendsui_atlas", iter1_19.spr), true)
		onToggle(arg0_19, var2_19, function(arg0_20)
			if arg0_20 then
				arg0_19.sortdata = iter1_19
				arg0_19.contextData.sortData = {
					data = arg0_19.sortdata,
					dec = arg0_19.dec
				}

				arg0_19:sortFriends()
				triggerButton(arg0_19.sortPanel)
			end
		end, SFX_PANEL)

		if iter0_19 == 1 then
			triggerToggle(var2_19, true)
		end
	end

	onButton(arg0_19, arg0_19.sortPanel, function()
		arg0_19:closeFriendsSortPanel()
	end, SFX_PANEL)
end

function var0_0.openFriendsSortPanel(arg0_22)
	if arg0_22.contextData.sortData then
		setImageSprite(arg0_22:findTF("index_button/icon", arg0_22.sortPanel), GetSpriteFromAtlas("ui/friendsui_atlas", arg0_22.contextData.sortData.data.spr), true)
	end

	setActive(arg0_22.sortPanel, true)
end

function var0_0.closeFriendsSortPanel(arg0_23)
	setActive(arg0_23.sortPanel, false)
end

function var0_0.OnDestroy(arg0_24)
	for iter0_24, iter1_24 in pairs(arg0_24.friendItems or {}) do
		iter1_24:dispose()
	end
end

return var0_0
