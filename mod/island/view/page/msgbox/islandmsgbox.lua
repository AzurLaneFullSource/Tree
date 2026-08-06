local var0_0 = class("IslandMsgBox", import("view.base.BaseSubView"))

var0_0.TYPE_COMMON = 1
var0_0.TYPE_ITEM = 2
var0_0.TYPE_SHIP_OWN_STATUS = 3
var0_0.TYPE_COMMON_ITEM = 4
var0_0.TYPE_ITEM_INFO = 5
var0_0.TYPE_MATERIAL_INFO = 6
var0_0.TYPE_REMIND = 7
var0_0.TYPE_SHIP_SKILL = 8
var0_0.TYPE_SHIP_STATUS_MSG = 9
var0_0.TYPE_AGORA_PLACED_LIST = 10
var0_0.TYPE_AGORA_UPGRADE = 11
var0_0.TYPE_WHITOUT_BTN = 12
var0_0.TYPE_SAVE_THEME = 13
var0_0.TYPE_THEME = 14
var0_0.TYPE_SEASON_TIP = 15
var0_0.TYPE_SEASON_RESET = 16
var0_0.TYPE_SYSTEM_THEME = 17
var0_0.TYPE_ORDER_TENDENCY = 18
var0_0.TYPE_SEND_DRESS = 19
var0_0.TYPE_AOGRA_SAVE_CD = 20
var0_0.TYPE_CHAT_SETTINGS = 21
var0_0.TYPE_DRAW_AWARD_COUNT = 22
var0_0.TYPE_DRAW_AWARD_LIST = 23
var0_0.TYPE_DRAW_AWARD_ALL = 24
var0_0.TYPE_TICKET_EXPIRED = 25
var0_0.TYPE_DRESS_WEAR_CONFIRE = 26
var0_0.TYPE_COMMON_DROP_DESCRIBE = 27
var0_0.TYPE_ISLAND_POST_EVENT = 28
var0_0.TYPE_TRADE_CONFRIM = 29
var0_0.TYPE_COMMON_AUTO_CONFIRM = 30

function var0_0.getUIName(arg0_1)
	return "IslandMsgboxUI"
end

function var0_0.OnLoaded(arg0_2)
	arg0_2.stack = {}
	arg0_2.cacheCnt = 3
	arg0_2.tempWindows = {}
	arg0_2.residentWindows = {}
	arg0_2.PAGES = {
		[var0_0.TYPE_COMMON] = IslandCommonMsgboxEXWindow,
		[var0_0.TYPE_ITEM] = IslandItemMsgboxWindow,
		[var0_0.TYPE_SHIP_OWN_STATUS] = IslandMsgBoxForStatusWindow,
		[var0_0.TYPE_ITEM_INFO] = IslandMsgBoxSingleItemWindow,
		[var0_0.TYPE_MATERIAL_INFO] = IslandMsgBoxSingleMaterialWindow,
		[var0_0.TYPE_REMIND] = IslandRemindMsgboxWindow,
		[var0_0.TYPE_SHIP_SKILL] = IslandShipSkillMsgboxWindow,
		[var0_0.TYPE_SHIP_STATUS_MSG] = IslandShipStatusMsgboxWindow,
		[var0_0.TYPE_AGORA_PLACED_LIST] = IslandAgoraPlacedListMsgboxWindow,
		[var0_0.TYPE_AGORA_UPGRADE] = IslandAgoraUpgradeMsgboxWindow,
		[var0_0.TYPE_WHITOUT_BTN] = IslandwithoutBtnMsgboxWindow,
		[var0_0.TYPE_SAVE_THEME] = IslandSaveThemeMsgboxWindow,
		[var0_0.TYPE_THEME] = IslandThemeMsgboxWindow,
		[var0_0.TYPE_SEASON_TIP] = IslandSeasonTipMsgBoxWindow,
		[var0_0.TYPE_SEASON_RESET] = IslandSeasonResetMsgBoxWindow,
		[var0_0.TYPE_SYSTEM_THEME] = IslandSystemThemeMsgboxWindow,
		[var0_0.TYPE_ORDER_TENDENCY] = IslandOrderTendencyPage,
		[var0_0.TYPE_SEND_DRESS] = IslandSendDressUpMsgboxWindow,
		[var0_0.TYPE_AOGRA_SAVE_CD] = IslandAgoraSaveCdMsgboxWindow,
		[var0_0.TYPE_CHAT_SETTINGS] = IslandChatSettingsMsgboxWindow,
		[var0_0.TYPE_DRAW_AWARD_COUNT] = IslandDrawAwardCountWindow,
		[var0_0.TYPE_DRAW_AWARD_LIST] = IslandDrawAwardListWindow,
		[var0_0.TYPE_DRAW_AWARD_ALL] = IslandDrawAwardAllWindow,
		[var0_0.TYPE_TICKET_EXPIRED] = IslandTicketExpiredMsgBoxWindow,
		[var0_0.TYPE_DRESS_WEAR_CONFIRE] = IslandDressWearMsgboxWindow,
		[var0_0.TYPE_COMMON_DROP_DESCRIBE] = IslandMsgBoxSingleDropWindow,
		[var0_0.TYPE_ISLAND_POST_EVENT] = IslandPostEventWindow,
		[var0_0.TYPE_TRADE_CONFRIM] = IslandTradeConfirmWindow,
		[var0_0.TYPE_COMMON_AUTO_CONFIRM] = IslandMsgBoxAutoCollectionWindow
	}
end

function var0_0.OnInit(arg0_3)
	onButton(arg0_3, arg0_3.rtBg, function()
		arg0_3:HideWindow()
	end, SFX_PANEL)
end

function var0_0.CheckType(arg0_5, arg1_5)
	local var0_5 = arg1_5.type or var0_0.TYPE_COMMON

	if var0_5 == var0_0.TYPE_COMMON_ITEM then
		var0_5 = IslandItem.New({
			id = arg1_5.itemId
		}):CanConvert() and var0_0.TYPE_MATERIAL_INFO or var0_0.TYPE_ITEM_INFO
	end

	return var0_5
end

function var0_0.Show(arg0_6, arg1_6, arg2_6)
	var0_0.super.Show(arg0_6)

	arg0_6.callback = arg2_6

	local var0_6 = arg0_6:CheckType(arg1_6)
	local var1_6 = arg0_6:CreateWindow(var0_6)

	var1_6:ExecuteAction("Show", arg1_6)
	table.insert(arg0_6.stack, var1_6)
end

function var0_0.CreateWindow(arg0_7, arg1_7)
	local var0_7 = arg1_7 == var0_0.TYPE_COMMON and arg0_7.residentWindows or arg0_7.tempWindows
	local var1_7 = arg0_7:FindOrCreateWindow(arg1_7, var0_7)

	table.insert(var0_7, 1, {
		type = arg1_7,
		window = var1_7
	})
	arg0_7:CheckPoolCnt(var0_7)

	return var1_7
end

function var0_0.FindOrCreateWindow(arg0_8, arg1_8, arg2_8)
	local var0_8 = 0

	for iter0_8, iter1_8 in ipairs(arg2_8) do
		if iter1_8.type == arg1_8 then
			var0_8 = iter0_8

			break
		end
	end

	local var1_8

	if var0_8 > 0 then
		var1_8 = table.remove(arg2_8, var0_8).window
	else
		local var2_8 = arg0_8.PAGES[arg1_8]

		assert(var2_8, arg1_8)

		var1_8 = var2_8.New(arg0_8, arg0_8.rtPages)
	end

	return var1_8
end

function var0_0.CheckPoolCnt(arg0_9, arg1_9)
	if #arg1_9 > arg0_9.cacheCnt then
		local var0_9 = table.remove(arg1_9, #arg1_9).window

		if var0_9 and var0_9:GetLoaded() then
			var0_9:Destroy()
		end
	end
end

function var0_0.HideWindow(arg0_10, arg1_10)
	local var0_10 = false

	if arg1_10 then
		var0_10 = table.indexof(arg0_10.stack, arg1_10)
	end

	var0_10 = var0_10 or #arg0_10.stack

	if var0_10 > 0 and var0_10 <= #arg0_10.stack then
		arg1_10 = table.remove(arg0_10.stack, var0_10)
	end

	if arg1_10 then
		if arg1_10.onHide then
			arg1_10.onHide()
		end

		setActive(arg1_10._tf, false)
	end

	if #arg0_10.stack == 0 then
		arg0_10:Hide()

		local var1_10 = arg0_10.callback

		arg0_10.callback = nil

		if var1_10 then
			var1_10()
		end
	end
end

function var0_0.OnDestroy(arg0_11)
	for iter0_11, iter1_11 in ipairs(arg0_11.residentWindows) do
		iter1_11.window:Destroy()
	end

	for iter2_11, iter3_11 in ipairs(arg0_11.tempWindows) do
		iter3_11.window:Destroy()
	end

	arg0_11.residentWindows = nil
	arg0_11.tempWindows = nil
end

return var0_0
