local var0_0 = class("FriendScene", import("..base.BaseUI"))

var0_0.FRIEND_PAGE = 1
var0_0.SEARCH_PAGE = 2
var0_0.REQUEST_PAGE = 3
var0_0.BLACKLIST_PAGE = 4

function var0_0.getUIName(arg0_1)
	return "FriendUI"
end

function var0_0.setFriendVOs(arg0_2, arg1_2)
	arg0_2.friendVOs = arg1_2
end

function var0_0.setPlayer(arg0_3, arg1_3)
	arg0_3.playerVO = arg1_3
end

function var0_0.setRequests(arg0_4, arg1_4)
	arg0_4.requestVOs = arg1_4
end

function var0_0.setSearchResult(arg0_5, arg1_5)
	arg0_5.searchResultVOs = arg1_5
end

function var0_0.removeSearchResult(arg0_6, arg1_6)
	local var0_6 = _.select(arg0_6.searchResultVOs, function(arg0_7)
		return arg0_7.id ~= arg1_6
	end)

	arg0_6:setSearchResult(var0_6)
end

function var0_0.setBlackList(arg0_8, arg1_8)
	if arg1_8 then
		arg0_8.blackVOs = {}

		for iter0_8, iter1_8 in pairs(arg1_8 or {}) do
			table.insert(arg0_8.blackVOs, iter1_8)
		end
	end
end

function var0_0.init(arg0_9)
	arg0_9.pages = arg0_9:findTF("pages")
	arg0_9.togglesTF = arg0_9:findTF("blur_panel/adapt/left_length/frame/tagRoot")
	arg0_9.pages = {
		FriendListPage.New(arg0_9.pages, arg0_9.event, arg0_9.contextData),
		FriendSearchPage.New(arg0_9.pages, arg0_9.event),
		FriendRequestPage.New(arg0_9.pages, arg0_9.event),
		FriendBlackListPage.New(arg0_9.pages, arg0_9.event)
	}
	arg0_9.toggles = {}

	for iter0_9 = 1, arg0_9.togglesTF.childCount do
		arg0_9.toggles[iter0_9] = arg0_9.togglesTF:GetChild(iter0_9 - 1)

		onToggle(arg0_9, arg0_9.toggles[iter0_9], function(arg0_10)
			if arg0_10 then
				arg0_9:switchPage(iter0_9)
			end
		end, SFX_PANEL)
	end

	arg0_9.chatTipContainer = arg0_9.toggles[1]:Find("count")
	arg0_9.chatTip = arg0_9.toggles[1]:Find("count/Text"):GetComponent(typeof(Text))
	arg0_9.listEmptyTF = arg0_9:findTF("empty")

	setActive(arg0_9.listEmptyTF, false)

	arg0_9.listEmptyTxt = arg0_9:findTF("Text", arg0_9.listEmptyTF)
end

function var0_0.didEnter(arg0_11)
	onButton(arg0_11, arg0_11:findTF("blur_panel/adapt/top/back_btn"), function()
		arg0_11:emit(var0_0.ON_BACK)
	end, SOUND_BACK)

	local var0_11 = arg0_11.contextData.initPage or 1

	triggerToggle(arg0_11.toggles[var0_11], true)
	arg0_11:updateRequestTip()
end

function var0_0.wrapData(arg0_13)
	return {
		friendVOs = arg0_13.friendVOs,
		requestVOs = arg0_13.requestVOs,
		searchResults = arg0_13.searchResultVOs,
		blackVOs = arg0_13.blackVOs,
		playerVO = arg0_13.playerVO
	}
end

function var0_0.updateEmpty(arg0_14, arg1_14, arg2_14)
	local var0_14 = {}
	local var1_14 = ""

	if arg1_14 == var0_0.FRIEND_PAGE then
		var0_14 = arg2_14.friendVOs
		var1_14 = i18n("list_empty_tip_friendui")
	elseif arg1_14 == var0_0.SEARCH_PAGE then
		var0_14 = arg2_14.searchResults
		var1_14 = i18n("list_empty_tip_friendui_search")
	elseif arg1_14 == var0_0.REQUEST_PAGE then
		var0_14 = arg2_14.requestVOs
		var1_14 = i18n("list_empty_tip_friendui_request")
	elseif arg1_14 == var0_0.BLACKLIST_PAGE then
		var0_14 = arg2_14.blackVOs
		var1_14 = i18n("list_empty_tip_friendui_black")
	end

	setActive(arg0_14.listEmptyTF, not var0_14 or #var0_14 <= 0)
	setText(arg0_14.listEmptyTxt, var1_14)
end

function var0_0.switchPage(arg0_15, arg1_15)
	if arg0_15.page then
		arg0_15.page:ExecuteAction("Hide")
	end

	local var0_15 = arg0_15.pages[arg1_15]
	local var1_15 = arg0_15:wrapData()

	var0_15:ExecuteAction("Show")
	var0_15:ExecuteAction("UpdateData", var1_15)

	arg0_15.page = var0_15

	arg0_15:updateEmpty(arg1_15, var1_15)
end

function var0_0.updatePage(arg0_16, arg1_16)
	local var0_16 = arg0_16.pages[arg1_16]

	if arg0_16.page and var0_16 == arg0_16.page then
		local var1_16 = arg0_16:wrapData()

		arg0_16.page:ExecuteAction("UpdateData", var1_16)
		arg0_16:updateEmpty(arg1_16, var1_16)
	end
end

function var0_0.updateChatNotification(arg0_17, arg1_17)
	setActive(arg0_17.chatTipContainer, arg1_17 > 0)

	arg0_17.chatTip.text = arg1_17
end

function var0_0.updateRequestTip(arg0_18)
	setActive(arg0_18.toggles[3]:Find("tip"), #arg0_18.requestVOs > 0)
end

function var0_0.willExit(arg0_19)
	for iter0_19, iter1_19 in ipairs(arg0_19.pages) do
		iter1_19:Destroy()
	end
end

return var0_0
