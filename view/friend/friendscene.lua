local var0_0 = class("FriendScene", import("..base.BaseUI"))

var0_0.FRIEND_PAGE = 1
var0_0.SEARCH_PAGE = 2
var0_0.REQUEST_PAGE = 3
var0_0.BLACKLIST_PAGE = 4

function var0_0.getUIName(arg0_1)
	return "FriendUI"
end

function var0_0.getResource(arg0_2, arg1_2)
	local var0_2 = {
		"ui/friendsui_atlas"
	}
	local var1_2 = {}

	local function var2_2(arg0_3)
		if not arg0_3 then
			return
		end

		local var0_3 = AttireFrame.attireFrameRes(arg0_3, arg0_3.id == getProxy(PlayerProxy):getRawData().id, AttireConst.TYPE_ICON_FRAME, arg0_3.propose)

		if var0_3 and var0_3 ~= "" then
			table.insert(var1_2, "IconFrame/" .. var0_3)
		end

		if arg0_3.score and arg0_3.rank then
			local var1_3 = SeasonInfo.getEmblem(arg0_3.score, arg0_3.rank)

			table.insert(var1_2, "emblem/" .. var1_3)
			table.insert(var1_2, "emblem/n_" .. var1_3)
		end
	end

	for iter0_2, iter1_2 in ipairs(getProxy(FriendProxy):getAllFriends() or {}) do
		var2_2(iter1_2)
	end

	for iter2_2, iter3_2 in ipairs(getProxy(NotificationProxy):getRequests() or {}) do
		var2_2(iter3_2.player)
	end

	for iter4_2, iter5_2 in pairs(getProxy(FriendProxy):getBlackList() or {}) do
		var2_2(iter5_2)
	end

	return ResPathSupport.UniqueLuaArr(ResPathSupport.MergeLuaArr(var0_0.super.getResource(arg0_2, arg1_2), var0_2, var1_2))
end

function var0_0.setFriendVOs(arg0_4, arg1_4)
	arg0_4.friendVOs = arg1_4
end

function var0_0.setPlayer(arg0_5, arg1_5)
	arg0_5.playerVO = arg1_5
end

function var0_0.setRequests(arg0_6, arg1_6)
	arg0_6.requestVOs = arg1_6
end

function var0_0.setSearchResult(arg0_7, arg1_7)
	arg0_7.searchResultVOs = arg1_7
end

function var0_0.removeSearchResult(arg0_8, arg1_8)
	local var0_8 = _.select(arg0_8.searchResultVOs, function(arg0_9)
		return arg0_9.id ~= arg1_8
	end)

	arg0_8:setSearchResult(var0_8)
end

function var0_0.setBlackList(arg0_10, arg1_10)
	if arg1_10 then
		arg0_10.blackVOs = {}

		for iter0_10, iter1_10 in pairs(arg1_10 or {}) do
			table.insert(arg0_10.blackVOs, iter1_10)
		end
	end
end

function var0_0.init(arg0_11)
	arg0_11.pages = arg0_11._tf:Find("pages")
	arg0_11.togglesTF = arg0_11._tf:Find("blur_panel/adapt/left_length/frame/tagRoot")
	arg0_11.pages = {
		FriendListPage.New(arg0_11.pages, arg0_11.event, arg0_11.contextData),
		FriendSearchPage.New(arg0_11.pages, arg0_11.event),
		FriendRequestPage.New(arg0_11.pages, arg0_11.event),
		FriendBlackListPage.New(arg0_11.pages, arg0_11.event)
	}
	arg0_11.toggles = {}

	for iter0_11 = 1, arg0_11.togglesTF.childCount do
		arg0_11.toggles[iter0_11] = arg0_11.togglesTF:GetChild(iter0_11 - 1)

		onToggle(arg0_11, arg0_11.toggles[iter0_11], function(arg0_12)
			if arg0_12 then
				arg0_11:switchPage(iter0_11)
			end
		end, SFX_PANEL)
	end

	arg0_11.chatTipContainer = arg0_11.toggles[1]:Find("count")
	arg0_11.chatTip = arg0_11.toggles[1]:Find("count/Text"):GetComponent(typeof(Text))
	arg0_11.listEmptyTF = arg0_11._tf:Find("empty")

	setActive(arg0_11.listEmptyTF, false)

	arg0_11.listEmptyTxt = arg0_11.listEmptyTF:Find("Text")
end

function var0_0.didEnter(arg0_13)
	onButton(arg0_13, arg0_13._tf:Find("blur_panel/adapt/top/back_btn"), function()
		arg0_13:emit(var0_0.ON_BACK)
	end, SOUND_BACK)

	local var0_13 = arg0_13.contextData.initPage or 1

	triggerToggle(arg0_13.toggles[var0_13], true)
	arg0_13:updateRequestTip()
end

function var0_0.wrapData(arg0_15)
	return {
		friendVOs = arg0_15.friendVOs,
		requestVOs = arg0_15.requestVOs,
		searchResults = arg0_15.searchResultVOs,
		blackVOs = arg0_15.blackVOs,
		playerVO = arg0_15.playerVO
	}
end

function var0_0.updateEmpty(arg0_16, arg1_16, arg2_16)
	local var0_16 = {}
	local var1_16 = ""

	if arg1_16 == var0_0.FRIEND_PAGE then
		var0_16 = arg2_16.friendVOs
		var1_16 = i18n("list_empty_tip_friendui")
	elseif arg1_16 == var0_0.SEARCH_PAGE then
		var0_16 = arg2_16.searchResults
		var1_16 = i18n("list_empty_tip_friendui_search")
	elseif arg1_16 == var0_0.REQUEST_PAGE then
		var0_16 = arg2_16.requestVOs
		var1_16 = i18n("list_empty_tip_friendui_request")
	elseif arg1_16 == var0_0.BLACKLIST_PAGE then
		var0_16 = arg2_16.blackVOs
		var1_16 = i18n("list_empty_tip_friendui_black")
	end

	setActive(arg0_16.listEmptyTF, not var0_16 or #var0_16 <= 0)
	setText(arg0_16.listEmptyTxt, var1_16)
end

function var0_0.switchPage(arg0_17, arg1_17)
	if arg0_17.page then
		arg0_17.page:ExecuteAction("Hide")
	end

	local var0_17 = arg0_17.pages[arg1_17]
	local var1_17 = arg0_17:wrapData()

	var0_17:ExecuteAction("Show")
	var0_17:ExecuteAction("UpdateData", var1_17)

	arg0_17.page = var0_17

	arg0_17:updateEmpty(arg1_17, var1_17)
end

function var0_0.updatePage(arg0_18, arg1_18)
	local var0_18 = arg0_18.pages[arg1_18]

	if arg0_18.page and var0_18 == arg0_18.page then
		local var1_18 = arg0_18:wrapData()

		arg0_18.page:ExecuteAction("UpdateData", var1_18)
		arg0_18:updateEmpty(arg1_18, var1_18)
	end
end

function var0_0.updateChatNotification(arg0_19, arg1_19)
	setActive(arg0_19.chatTipContainer, arg1_19 > 0)

	arg0_19.chatTip.text = arg1_19
end

function var0_0.updateRequestTip(arg0_20)
	setActive(arg0_20.toggles[3]:Find("tip"), #arg0_20.requestVOs > 0)
end

function var0_0.closeInfromPanel(arg0_21)
	if not arg0_21.pages[3] then
		return
	end

	arg0_21.pages[3]:closeInfromPanel()
end

function var0_0.willExit(arg0_22)
	for iter0_22, iter1_22 in ipairs(arg0_22.pages) do
		iter1_22:Destroy()
	end
end

return var0_0
