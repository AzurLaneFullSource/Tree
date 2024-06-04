local var0 = class("FriendScene", import("..base.BaseUI"))

var0.FRIEND_PAGE = 1
var0.SEARCH_PAGE = 2
var0.REQUEST_PAGE = 3
var0.BLACKLIST_PAGE = 4

function var0.getUIName(arg0)
	return "FriendUI"
end

function var0.setFriendVOs(arg0, arg1)
	arg0.friendVOs = arg1
end

function var0.setPlayer(arg0, arg1)
	arg0.playerVO = arg1
end

function var0.setRequests(arg0, arg1)
	arg0.requestVOs = arg1
end

function var0.setSearchResult(arg0, arg1)
	arg0.searchResultVOs = arg1
end

function var0.removeSearchResult(arg0, arg1)
	local var0 = _.select(arg0.searchResultVOs, function(arg0)
		return arg0.id ~= arg1
	end)

	arg0:setSearchResult(var0)
end

function var0.setBlackList(arg0, arg1)
	if arg1 then
		arg0.blackVOs = {}

		for iter0, iter1 in pairs(arg1 or {}) do
			table.insert(arg0.blackVOs, iter1)
		end
	end
end

function var0.init(arg0)
	arg0.pages = arg0:findTF("pages")
	arg0.togglesTF = arg0:findTF("blur_panel/adapt/left_length/frame/tagRoot")
	arg0.pages = {
		FriendListPage.New(arg0.pages, arg0.event, arg0.contextData),
		FriendSearchPage.New(arg0.pages, arg0.event),
		FriendRequestPage.New(arg0.pages, arg0.event),
		FriendBlackListPage.New(arg0.pages, arg0.event)
	}
	arg0.toggles = {}

	for iter0 = 1, arg0.togglesTF.childCount do
		arg0.toggles[iter0] = arg0.togglesTF:GetChild(iter0 - 1)

		onToggle(arg0, arg0.toggles[iter0], function(arg0)
			if arg0 then
				arg0:switchPage(iter0)
			end
		end, SFX_PANEL)
	end

	arg0.chatTipContainer = arg0.toggles[1]:Find("count")
	arg0.chatTip = arg0.toggles[1]:Find("count/Text"):GetComponent(typeof(Text))
	arg0.listEmptyTF = arg0:findTF("empty")

	setActive(arg0.listEmptyTF, false)

	arg0.listEmptyTxt = arg0:findTF("Text", arg0.listEmptyTF)
end

function var0.didEnter(arg0)
	onButton(arg0, arg0:findTF("blur_panel/adapt/top/back_btn"), function()
		arg0:emit(var0.ON_BACK)
	end, SOUND_BACK)

	local var0 = arg0.contextData.initPage or 1

	triggerToggle(arg0.toggles[var0], true)
	arg0:updateRequestTip()
end

function var0.wrapData(arg0)
	return {
		friendVOs = arg0.friendVOs,
		requestVOs = arg0.requestVOs,
		searchResults = arg0.searchResultVOs,
		blackVOs = arg0.blackVOs,
		playerVO = arg0.playerVO
	}
end

function var0.updateEmpty(arg0, arg1, arg2)
	local var0 = {}
	local var1 = ""

	if arg1 == var0.FRIEND_PAGE then
		var0 = arg2.friendVOs
		var1 = i18n("list_empty_tip_friendui")
	elseif arg1 == var0.SEARCH_PAGE then
		var0 = arg2.searchResults
		var1 = i18n("list_empty_tip_friendui_search")
	elseif arg1 == var0.REQUEST_PAGE then
		var0 = arg2.requestVOs
		var1 = i18n("list_empty_tip_friendui_request")
	elseif arg1 == var0.BLACKLIST_PAGE then
		var0 = arg2.blackVOs
		var1 = i18n("list_empty_tip_friendui_black")
	end

	setActive(arg0.listEmptyTF, not var0 or #var0 <= 0)
	setText(arg0.listEmptyTxt, var1)
end

function var0.switchPage(arg0, arg1)
	if arg0.page then
		arg0.page:ExecuteAction("Hide")
	end

	local var0 = arg0.pages[arg1]
	local var1 = arg0:wrapData()

	var0:ExecuteAction("Show")
	var0:ExecuteAction("UpdateData", var1)

	arg0.page = var0

	arg0:updateEmpty(arg1, var1)
end

function var0.updatePage(arg0, arg1)
	local var0 = arg0.pages[arg1]

	if arg0.page and var0 == arg0.page then
		local var1 = arg0:wrapData()

		arg0.page:ExecuteAction("UpdateData", var1)
		arg0:updateEmpty(arg1, var1)
	end
end

function var0.updateChatNotification(arg0, arg1)
	setActive(arg0.chatTipContainer, arg1 > 0)

	arg0.chatTip.text = arg1
end

function var0.updateRequestTip(arg0)
	setActive(arg0.toggles[3]:Find("tip"), #arg0.requestVOs > 0)
end

function var0.willExit(arg0)
	for iter0, iter1 in ipairs(arg0.pages) do
		iter1:Destroy()
	end
end

return var0
