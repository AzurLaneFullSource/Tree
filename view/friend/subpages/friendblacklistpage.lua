local var0_0 = class("FriendBlackListPage", import("...base.BaseSubView"))

function var0_0.getUIName(arg0_1)
	return "FriendBlackListUI"
end

function var0_0.OnLoaded(arg0_2)
	arg0_2.blackListPanel = arg0_2:findTF("blacklist_panel")
	arg0_2.blacklistTopTF = arg0_2:findTF("blacklist_view_top")
end

function var0_0.OnInit(arg0_3)
	return
end

function var0_0.UpdateData(arg0_4, arg1_4)
	arg0_4.blackVOs = arg1_4.blackVOs

	if not arg0_4.isInit then
		arg0_4.isInit = true

		arg0_4:initBlackList()

		if not arg0_4.blackVOs then
			arg0_4:emit(FriendMediator.GET_BLACK_LIST)
		else
			arg0_4:sortBlackList()
		end
	else
		arg0_4.blackVOs = arg0_4.blackVOs or {}

		arg0_4:sortBlackList()
	end
end

function var0_0.initBlackList(arg0_5)
	arg0_5.blackItems = {}
	arg0_5.blackRect = arg0_5.blackListPanel:Find("mask/view"):GetComponent("LScrollRect")

	function arg0_5.blackRect.onInitItem(arg0_6)
		arg0_5:onInitItem(arg0_6)
	end

	function arg0_5.blackRect.onUpdateItem(arg0_7, arg1_7)
		arg0_5:onUpdateItem(arg0_7, arg1_7)
	end
end

function var0_0.onInitItem(arg0_8, arg1_8)
	local var0_8 = FriendBlackListCard.New(arg1_8)

	onButton(arg0_8, var0_8.btn, function()
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			content = i18n("firend_relieve_blacklist_tip", var0_8.friendVO.name),
			onYes = function()
				arg0_8:emit(FriendMediator.RELIEVE_BLACKLIST, var0_8.friendVO.id)
			end
		})
	end)

	arg0_8.blackItems[arg1_8] = var0_8
end

function var0_0.onUpdateItem(arg0_11, arg1_11, arg2_11)
	local var0_11 = arg0_11.blackItems[arg2_11]

	if not var0_11 then
		arg0_11:onInitItem(arg2_11)

		var0_11 = arg0_11.blackItems[arg2_11]
	end

	local var1_11 = arg0_11.blackVOs[arg1_11 + 1]

	var0_11:update(var1_11)
end

function var0_0.sortBlackList(arg0_12)
	table.sort(arg0_12.blackVOs, function(arg0_13, arg1_13)
		return arg0_13.id < arg1_13.id
	end)
	arg0_12.blackRect:SetTotalCount(#arg0_12.blackVOs, -1)
end

function var0_0.OnDestroy(arg0_14)
	for iter0_14, iter1_14 in pairs(arg0_14.blackItems or {}) do
		iter1_14:dispose()
	end
end

return var0_0
