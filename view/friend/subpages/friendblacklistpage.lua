local var0 = class("FriendBlackListPage", import("...base.BaseSubView"))

function var0.getUIName(arg0)
	return "FriendBlackListUI"
end

function var0.OnLoaded(arg0)
	arg0.blackListPanel = arg0:findTF("blacklist_panel")
	arg0.blacklistTopTF = arg0:findTF("blacklist_view_top")
end

function var0.OnInit(arg0)
	return
end

function var0.UpdateData(arg0, arg1)
	arg0.blackVOs = arg1.blackVOs

	if not arg0.isInit then
		arg0.isInit = true

		arg0:initBlackList()

		if not arg0.blackVOs then
			arg0:emit(FriendMediator.GET_BLACK_LIST)
		else
			arg0:sortBlackList()
		end
	else
		arg0.blackVOs = arg0.blackVOs or {}

		arg0:sortBlackList()
	end
end

function var0.initBlackList(arg0)
	arg0.blackItems = {}
	arg0.blackRect = arg0.blackListPanel:Find("mask/view"):GetComponent("LScrollRect")

	function arg0.blackRect.onInitItem(arg0)
		arg0:onInitItem(arg0)
	end

	function arg0.blackRect.onUpdateItem(arg0, arg1)
		arg0:onUpdateItem(arg0, arg1)
	end
end

function var0.onInitItem(arg0, arg1)
	local var0 = FriendBlackListCard.New(arg1)

	onButton(arg0, var0.btn, function()
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			content = i18n("firend_relieve_blacklist_tip", var0.friendVO.name),
			onYes = function()
				arg0:emit(FriendMediator.RELIEVE_BLACKLIST, var0.friendVO.id)
			end
		})
	end)

	arg0.blackItems[arg1] = var0
end

function var0.onUpdateItem(arg0, arg1, arg2)
	local var0 = arg0.blackItems[arg2]

	if not var0 then
		arg0:onInitItem(arg2)

		var0 = arg0.blackItems[arg2]
	end

	local var1 = arg0.blackVOs[arg1 + 1]

	var0:update(var1)
end

function var0.sortBlackList(arg0)
	table.sort(arg0.blackVOs, function(arg0, arg1)
		return arg0.id < arg1.id
	end)
	arg0.blackRect:SetTotalCount(#arg0.blackVOs, -1)
end

function var0.OnDestroy(arg0)
	for iter0, iter1 in pairs(arg0.blackItems or {}) do
		iter1:dispose()
	end
end

return var0
