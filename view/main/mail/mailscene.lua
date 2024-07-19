local var0_0 = class("MailScene", import("view.base.BaseUI"))
local var1_0 = 592
local var2_0 = 125
local var3_0 = 9

function var0_0.getUIName(arg0_1)
	return "MailUI"
end

function var0_0.ResUISettings(arg0_2)
	return false
end

var0_0.optionsPath = {
	"adapt/top/option"
}

function var0_0.quickExitFunc(arg0_3)
	local var0_3 = {}

	if arg0_3.proxy.totalExist > MAIL_COUNT_LIMIT then
		table.insert(var0_3, function(arg0_4)
			arg0_3:ShowDoubleConfiremationMsgBox({
				type = MailProxy.MailMessageBoxType.ShowTips,
				content = i18n("warning_mail_max_4", arg0_3.proxy.totalExist),
				onYes = arg0_4
			})
		end)
	end

	seriesAsync(var0_3, function()
		arg0_3:emit(var0_0.ON_HOME)
	end)
end

function var0_0.init(arg0_6)
	arg0_6.proxy = getProxy(MailProxy)
	arg0_6.rtAdapt = arg0_6._tf:Find("adapt")

	setText(arg0_6.rtAdapt:Find("top/title"), i18n("mail_title_new"))
	setText(arg0_6.rtAdapt:Find("top/title/Text"), i18n("mail_title_English"))
	onButton(arg0_6, arg0_6.rtAdapt:Find("top/back_btn"), function()
		local var0_7 = {}

		if arg0_6.proxy.totalExist > MAIL_COUNT_LIMIT then
			table.insert(var0_7, function(arg0_8)
				arg0_6:ShowDoubleConfiremationMsgBox({
					type = MailProxy.MailMessageBoxType.ShowTips,
					content = i18n("warning_mail_max_4", arg0_6.proxy.totalExist),
					onYes = arg0_8
				})
			end)
		end

		seriesAsync(var0_7, function()
			arg0_6:closeView()
		end)
	end, SFX_CANCEL)

	arg0_6.rtLabels = arg0_6.rtAdapt:Find("left_length/frame/tagRoot")

	eachChild(arg0_6.rtLabels, function(arg0_10)
		local var0_10

		if arg0_10.name == "mail" then
			toggleName = "mail_mail_page"
		elseif arg0_10.name == "store" then
			toggleName = "mail_storeroom_page"
		elseif arg0_10.name == "collection" then
			toggleName = "mail_boxroom_page"
		end

		setText(arg0_10:Find("unSelect/Text"), i18n(toggleName))
		setText(arg0_10:Find("selected/Text"), i18n(toggleName))
		onToggle(arg0_6, arg0_10, function(arg0_11)
			if arg0_11 then
				arg0_6:SetPage(arg0_10.name)
			end
		end, SFX_PANEL)
	end)

	local var0_6 = arg0_6.rtAdapt:Find("main/content/left/head")

	arg0_6.rightSelect = var0_6:Find("rightSelect")
	arg0_6.rtToggles = arg0_6.rightSelect:Find("toggle")

	eachChild(arg0_6.rtToggles, function(arg0_12)
		local var0_12

		if arg0_12.name == "btn_all" then
			toggleName = "mail_all_page"
		elseif arg0_12.name == "btn_important" then
			toggleName = "mail_important_page"
		elseif arg0_12.name == "btn_rare" then
			toggleName = "mail_rare_page"
		end

		setText(arg0_12:Find("unselect/Text"), i18n(toggleName))
		setText(arg0_12:Find("select/Text"), i18n(toggleName))
	end)
	onToggle(arg0_6, arg0_6.rtToggles:Find("btn_all"), function(arg0_13)
		if arg0_13 then
			if arg0_6.mailToggle == "all" then
				return
			end

			arg0_6.selectMailId = nil

			arg0_6:UpdateMailList("all", 0)
		end
	end, SFX_PANEL)
	onToggle(arg0_6, arg0_6.rtToggles:Find("btn_important"), function(arg0_14)
		if arg0_14 then
			local var0_14 = {}

			if not arg0_6.proxy.importantIds then
				table.insert(var0_14, function(arg0_15)
					arg0_6:emit(MailMediator.ON_REQUIRE, "important", arg0_15)
				end)
			end

			seriesAsync(var0_14, function()
				if arg0_6.mailToggle == "important" then
					return
				end

				arg0_6.selectMailId = nil

				arg0_6:UpdateMailList("important", 0)
			end)
		end
	end, SFX_PANEL)
	onToggle(arg0_6, arg0_6.rtToggles:Find("btn_rare"), function(arg0_17)
		if arg0_17 then
			local var0_17 = {}

			if not arg0_6.proxy.rareIds then
				table.insert(var0_17, function(arg0_18)
					arg0_6:emit(MailMediator.ON_REQUIRE, "rare", arg0_18)
				end)
			end

			seriesAsync(var0_17, function()
				if arg0_6.mailToggle == "rare" then
					return
				end

				arg0_6.selectMailId = nil

				arg0_6:UpdateMailList("rare", 0)
			end)
		end
	end, SFX_PANEL)
	onButton(arg0_6, arg0_6.rtAdapt:Find("top/help"), function()
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_HELP,
			helps = i18n("mail_tip")
		})
	end, SFX_PANEL)

	arg0_6.rtSearch = var0_6:Find("search")
	arg0_6.rtCollectionInput = arg0_6.rtSearch:Find("input/InputField")

	setText(arg0_6.rtCollectionInput:Find("Placeholder"), i18n("mail_search_new"))
	onInputEndEdit(arg0_6, arg0_6.rtCollectionInput, function()
		arg0_6.collectionFilterStr = getInputText(arg0_6.rtCollectionInput)

		if arg0_6.mailToggle == "collection" then
			arg0_6:UpdateMailList(arg0_6.mailToggle, 0)
		end
	end)

	arg0_6.collectionFilterStr = ""
	arg0_6.rtToggleCollectionSort = arg0_6.rtSearch:Find("sort")

	setText(arg0_6.rtToggleCollectionSort:Find("Text"), i18n("mail_receive_time"))
	onToggle(arg0_6, arg0_6.rtToggleCollectionSort, function(arg0_22)
		arg0_6.collectionSortToggle = arg0_22

		if arg0_6.mailToggle == "collection" then
			arg0_6:UpdateMailList(arg0_6.mailToggle, 0)
		end
	end, SFX_PANEL)
	triggerToggle(arg0_6.rtToggleCollectionSort, false)

	local var1_6 = arg0_6.rtAdapt:Find("main/content")

	arg0_6.rtMailLeft = var1_6:Find("left/left_content")
	arg0_6.rtTip = arg0_6.rtMailLeft:Find("top/tip")
	arg0_6.rtMailCount = arg0_6.rtMailLeft:Find("top/count")
	arg0_6.Scrollbar = arg0_6.rtMailLeft:Find("middle/Scrollbar"):GetComponent("Scrollbar")
	arg0_6.lsrMailList = arg0_6.rtMailLeft:Find("middle/container"):GetComponent("LScrollRect")

	function arg0_6.lsrMailList.onUpdateItem(arg0_23, arg1_23)
		arg0_23 = arg0_23 + 1

		local var0_23 = tf(arg1_23)
		local var1_23 = arg0_6.filterMails[arg0_23]

		if var1_23.id == 0 then
			GetOrAddComponent(arg1_23, typeof(CanvasGroup)).alpha = 0
			GetOrAddComponent(arg1_23, typeof(CanvasGroup)).blocksRaycasts = false

			arg0_6:RequrereNextToIndex(arg0_23)

			return
		end

		if arg0_6.tplMailDic[var0_23] then
			arg0_6.mailTplDic[arg0_6.tplMailDic[var0_23]] = nil
		end

		arg0_6.mailTplDic[var1_23.id] = var0_23
		arg0_6.tplMailDic[var0_23] = var1_23.id

		onToggle(arg0_6, var0_23, function(arg0_24)
			if arg0_24 then
				if arg0_6.selectMailId ~= var1_23.id then
					arg0_6:UpdateMailContent(var1_23)
				end
			elseif var1_23.id == arg0_6.selectMailId then
				arg0_6:UpdateMailContent(nil)
			end
		end, SFX_PANEL)

		GetOrAddComponent(arg1_23, typeof(CanvasGroup)).alpha = 1
		GetOrAddComponent(arg1_23, typeof(CanvasGroup)).blocksRaycasts = true

		arg0_6:UpdateMailTpl(var1_23)
	end

	arg0_6.mailTplDic = {}
	arg0_6.tplMailDic = {}
	arg0_6.rtBtnLeftManager = arg0_6.rtMailLeft:Find("bottom/btn_managerMail")

	onButton(arg0_6, arg0_6.rtBtnLeftManager, function()
		arg0_6.mailMgrSubView:ExecuteAction("Show")
	end, SFX_PANEL)

	arg0_6.rtBtnLeftDeleteAll = arg0_6.rtMailLeft:Find("bottom/btn_deleteMail")

	onButton(arg0_6, arg0_6.rtBtnLeftDeleteAll, function()
		seriesAsync({
			function(arg0_27)
				arg0_6:ShowDoubleConfiremationMsgBox({
					type = MailProxy.MailMessageBoxType.ShowTips,
					content = i18n("main_mailLayer_quest_clear"),
					onYes = arg0_27
				})
			end
		}, function()
			arg0_6:emit(MailMediator.ON_OPERATION, {
				cmd = "delete",
				filter = {
					type = "all"
				}
			})
		end)
	end, SFX_CANCEL)

	arg0_6.rtBtnLeftMoveAll = arg0_6.rtMailLeft:Find("bottom/btn_moveAll")

	onButton(arg0_6, arg0_6.rtBtnLeftMoveAll, function()
		seriesAsync({
			function(arg0_30)
				arg0_6:ShowDoubleConfiremationMsgBox({
					type = MailProxy.MailMessageBoxType.ShowTips,
					content = i18n("mail_moveto_markroom_2"),
					onYes = arg0_30
				})
			end
		}, function()
			arg0_6:emit(MailMediator.ON_OPERATION, {
				cmd = "move",
				filter = {
					type = "ids",
					list = underscore.rest(arg0_6.proxy.importantIds, 1)
				}
			})
		end)
	end, SFX_CANCEL)

	arg0_6.rtBtnLeftGetAll = arg0_6.rtMailLeft:Find("bottom/btn_getAll")

	onButton(arg0_6, arg0_6.rtBtnLeftGetAll, function()
		local var0_32 = {}

		if arg0_6.mailToggle == "important" then
			var0_32 = underscore.rest(arg0_6.proxy.importantIds, 1)
		elseif arg0_6.mailToggle == "rare" then
			var0_32 = underscore.rest(arg0_6.proxy.rareIds, 1)
		else
			assert(false)
		end

		arg0_6:emit(MailMediator.ON_OPERATION, {
			cmd = "attachment",
			filter = {
				type = "ids",
				list = var0_32
			}
		})
	end, SFX_CANCEL)

	arg0_6.rtBtnLeftDeleteCollection = arg0_6.rtMailLeft:Find("bottom/btn_deleteCollection")

	onButton(arg0_6, arg0_6.rtBtnLeftDeleteCollection, function()
		if not arg0_6.selectMailId then
			return
		end

		assert(arg0_6.selectMailId)

		local var0_33 = arg0_6.proxy:getCollecitonMail(arg0_6.selectMailId)

		seriesAsync({
			function(arg0_34)
				arg0_6:ShowDoubleConfiremationMsgBox({
					type = MailProxy.MailMessageBoxType.ShowTips,
					content = i18n("mail_markroom_delete", var0_33.title),
					onYes = arg0_34
				})
			end
		}, function()
			arg0_6:emit(MailMediator.ON_DELETE_COLLECTION, arg0_6.selectMailId)
		end)
	end, SFX_CANCEL)

	arg0_6.rtMailRight = var1_6:Find("right")
	arg0_6.rtBtnRightMove = arg0_6.rtMailRight:Find("bottom/btn_move")

	onButton(arg0_6, arg0_6.rtBtnRightMove, function()
		assert(arg0_6.selectMailId)
		seriesAsync({
			function(arg0_37)
				arg0_6:ShowDoubleConfiremationMsgBox({
					type = MailProxy.MailMessageBoxType.ShowTips,
					content = i18n("mail_moveto_markroom_1"),
					onYes = arg0_37
				})
			end
		}, function()
			arg0_6:emit(MailMediator.ON_OPERATION, {
				noAttachTip = true,
				cmd = "move",
				filter = {
					type = "ids",
					list = {
						arg0_6.selectMailId
					}
				}
			})
		end)
	end, SFX_PANEL)

	arg0_6.rtBtnRightGet = arg0_6.rtMailRight:Find("bottom/btn_get")

	onButton(arg0_6, arg0_6.rtBtnRightGet, function()
		assert(arg0_6.selectMailId)
		arg0_6:emit(MailMediator.ON_OPERATION, {
			noAttachTip = true,
			cmd = "attachment",
			filter = {
				type = "ids",
				list = {
					arg0_6.selectMailId
				}
			}
		})
	end, SFX_PANEL)

	arg0_6.rtBtnRightDelte = arg0_6.rtMailRight:Find("bottom/btn_delete")

	onButton(arg0_6, arg0_6.rtBtnRightDelte, function()
		assert(arg0_6.selectMailId)

		local var0_40 = arg0_6.proxy:getMail(arg0_6.selectMailId)

		if var0_40.importantFlag == true then
			pg.TipsMgr.GetInstance():ShowTips(i18n("mail_confirm_delete_important_flag"))

			return
		end

		seriesAsync({
			function(arg0_41)
				arg0_6:ShowDoubleConfiremationMsgBox({
					type = MailProxy.MailMessageBoxType.ShowTips,
					content = i18n("mail_markroom_delete", var0_40.title),
					onYes = arg0_41
				})
			end
		}, function()
			arg0_6:emit(MailMediator.ON_OPERATION, {
				noAttachTip = true,
				cmd = "delete",
				filter = {
					type = "ids",
					list = {
						arg0_6.selectMailId
					}
				}
			})
		end)
	end, SFX_PANEL)

	arg0_6.rtMailEmpty = var1_6:Find("empty")
	arg0_6.rtStore = var1_6:Find("store")
	arg0_6.mailMgrSubView = MailMgrWindow.New(arg0_6._tf, arg0_6.event, arg0_6.contextData)
	arg0_6.storeUpgradeSubView = StoreUpgradeWindow.New(arg0_6._tf, arg0_6.event, arg0_6.contextData)
	arg0_6.mailConfirmationSubView = MailConfirmationWindow.New(arg0_6._tf, arg0_6.event, arg0_6.contextData)
	arg0_6.mailOverflowWindowSubView = MailOverflowWindow.New(arg0_6._tf, arg0_6.event, arg0_6.contextData)
	arg0_6.mailStoreroomRewardSubView = MailRewardWindow.New(arg0_6._tf, arg0_6.event, arg0_6.contextData)

	setText(arg0_6.rtBtnLeftDeleteAll:Find("Text"), i18n("mail_deleteread_button"))
	setText(arg0_6.rtBtnLeftManager:Find("Text"), i18n("mail_manage_button"))
	setText(arg0_6.rtBtnLeftMoveAll:Find("Text"), i18n("mail_move_button"))
	setText(arg0_6.rtBtnLeftGetAll:Find("Text"), i18n("mail_get_oneclick"))
	setText(arg0_6.rtBtnLeftDeleteCollection:Find("Text"), i18n("mail_delet_button"))
	setText(arg0_6.rtBtnRightMove:Find("Text"), i18n("mail_moveone_button"))
	setText(arg0_6.rtBtnRightGet:Find("Text"), i18n("mail_getone_button"))
	setText(arg0_6.rtBtnRightDelte:Find("Text"), i18n("mail_delet_button_1"))
	setText(arg0_6.rtMailRight:Find("main/title/matter/on/Text"), i18n("mail_toggle_on"))
	setText(arg0_6.rtMailRight:Find("main/title/matter/off/Text"), i18n("mail_toggle_off"))
	arg0_6:InitResBar()
end

function var0_0.SetPage(arg0_43, arg1_43)
	if arg0_43.page == arg1_43 then
		return
	end

	arg0_43.page = arg1_43

	setActive(arg0_43.rightSelect, arg1_43 == "mail")
	setActive(arg0_43.rtSearch, arg1_43 == "collection")
	setActive(arg0_43.rtStore, arg1_43 == "store")

	if arg1_43 == "store" then
		setActive(arg0_43.rtMailEmpty, false)
		setActive(arg0_43.rtMailLeft, false)
		setActive(arg0_43.rtMailRight, false)

		arg0_43.mailToggle = nil

		arg0_43:UpdateStore()
		setText(arg0_43.rtTip, i18n("mail_storeroom_tips"))
	elseif arg1_43 == "mail" then
		triggerToggle(arg0_43.rtToggles:Find("btn_all"), true)
		setText(arg0_43.rtTip, i18n("warning_mail_max_5"))
	elseif arg1_43 == "collection" then
		local var0_43 = {}

		if not arg0_43.proxy.collectionIds then
			table.insert(var0_43, function(arg0_44)
				arg0_43:emit(MailMediator.ON_REQUIRE, "collection", arg0_44)
			end)
		end

		seriesAsync(var0_43, function()
			arg0_43.selectMailId = nil

			arg0_43:UpdateMailList("collection", 0)
		end)
		setText(arg0_43.rtTip, i18n("mail_markroom_tip"))
	end
end

function var0_0.didEnter(arg0_46)
	onNextTick(function()
		arg0_46.lsrMailList.enabled = true

		triggerToggle(arg0_46.rtLabels:Find("mail"), true)
	end)
end

function var0_0.RequrereNextToIndex(arg0_48, arg1_48)
	if arg0_48.mailToggle == "all" and not arg0_48.inRequire and #arg0_48.proxy.ids < arg0_48.proxy.totalExist and arg1_48 > #arg0_48.proxy.ids then
		arg0_48.inRequire = true

		pg.UIMgr.GetInstance():LoadingOn()
		arg0_48:emit(MailMediator.ON_REQUIRE, arg1_48, function()
			arg0_48.inRequire = nil

			if arg0_48.mailToggle == "all" then
				arg0_48:UpdateMailList(arg0_48.mailToggle)
			end

			pg.UIMgr.GetInstance():LoadingOff()
		end)
	end
end

function var0_0.UpdateMailList(arg0_50, arg1_50, arg2_50)
	arg0_50.mailToggle = arg1_50

	local var0_50, var1_50 = switch(arg1_50, {
		all = function()
			return arg0_50.proxy.ids, string.format("<color=%s>%d</color>/<color=%s>%d</color>", arg0_50.proxy.totalExist > MAIL_COUNT_LIMIT and COLOR_RED or COLOR_WHITE, arg0_50.proxy.totalExist, "#181E32", MAIL_COUNT_LIMIT)
		end,
		important = function()
			return arg0_50.proxy.importantIds, string.format("<color=#FFFFFF>%d</color>", #arg0_50.proxy.importantIds)
		end,
		rare = function()
			return arg0_50.proxy.rareIds, string.format("<color=#FFFFFF>%d</color>", #arg0_50.proxy.rareIds)
		end,
		collection = function()
			return arg0_50.proxy.collectionIds, string.format("<color=#FFFFFF>%d</color>/%d", #arg0_50.proxy.collectionIds, getProxy(PlayerProxy):getRawData():getConfig("max_markmail"))
		end
	})

	if arg1_50 == "collection" then
		arg0_50.filterMails = arg0_50.proxy:GetCollectionMails(var0_50)

		if arg0_50.collectionFilterStr then
			arg0_50.filterMails = underscore.filter(arg0_50.filterMails, function(arg0_55)
				return arg0_55:IsMatchKey(arg0_50.collectionFilterStr)
			end)
		end

		table.sort(arg0_50.filterMails, CompareFuncs({
			function(arg0_56)
				return (arg0_50.collectionSortToggle and 1 or -1) * arg0_56.date
			end,
			function(arg0_57)
				return (arg0_50.collectionSortToggle and 1 or -1) * arg0_57.id
			end
		}))
	elseif arg1_50 == "all" then
		arg0_50.filterMails = arg0_50.proxy:GetMails(var0_50)

		table.sort(arg0_50.filterMails, CompareFuncs({
			function(arg0_58)
				return -arg0_58.id
			end
		}))

		for iter0_50 = #var0_50 + 1, arg0_50.proxy.totalExist do
			table.insert(arg0_50.filterMails, {
				id = 0
			})
		end
	else
		arg0_50.filterMails = arg0_50.proxy:GetMails(var0_50)

		table.sort(arg0_50.filterMails, CompareFuncs({
			function(arg0_59)
				return -arg0_59.id
			end
		}))
	end

	if arg0_50.mailToggle == "all" and #arg0_50.proxy.ids < arg0_50.proxy.totalExist and #arg0_50.proxy.ids < SINGLE_MAIL_REQUIRE_SIZE then
		arg0_50.inRequire = true

		arg0_50:emit(MailMediator.ON_REQUIRE, "next", function()
			if arg0_50.mailToggle == "all" then
				arg0_50:UpdateMailList(arg0_50.mailToggle)
			end

			arg0_50.inRequire = nil
		end)
	elseif #arg0_50.filterMails == 0 then
		setActive(arg0_50.rtMailLeft, false)
		setActive(arg0_50.rtMailRight, false)
		setActive(arg0_50.rtMailEmpty, true)

		if arg0_50.mailToggle == "collection" then
			setText(arg0_50.rtMailEmpty:Find("Text"), i18n("emptymarkroom_tip_mailboxui"))
			setText(arg0_50.rtMailEmpty:Find("Text_en"), i18n("emptymarkroom_tip_mailboxui_en"))
		else
			setText(arg0_50.rtMailEmpty:Find("Text"), i18n("empty_tip_mailboxui"))
			setText(arg0_50.rtMailEmpty:Find("Text_en"), i18n("empty_tip_mailboxui_en"))
		end
	else
		setActive(arg0_50.rtMailLeft, true)
		setActive(arg0_50.rtMailRight, true)
		setActive(arg0_50.rtMailEmpty, false)

		if not arg0_50.selectMailId then
			arg0_50:UpdateMailContent(arg0_50.filterMails[1])
		end

		arg0_50.lsrMailList:SetTotalCount(#arg0_50.filterMails, arg2_50 or -1)
		setText(arg0_50.rtMailCount, var1_50)
		setActive(arg0_50.rtBtnLeftManager, arg0_50.mailToggle == "all")
		setActive(arg0_50.rtBtnLeftMoveAll, arg0_50.mailToggle == "important")
		setActive(arg0_50.rtBtnLeftDeleteCollection, arg0_50.mailToggle == "collection")
		setActive(arg0_50.rtBtnLeftDeleteAll, arg0_50.mailToggle == "all" or arg0_50.mailToggle == "rare")
		setActive(arg0_50.rtBtnLeftGetAll, arg0_50.mailToggle == "important" or arg0_50.mailToggle == "rare")
	end
end

function var0_0.UpdateMailTpl(arg0_61, arg1_61)
	local var0_61 = arg0_61.mailTplDic[arg1_61.id]

	if not var0_61 then
		return
	end

	local var1_61 = var0_61:Find("content")

	setActive(var1_61:Find("icon/no_attachment"), #arg1_61.attachments == 0)
	setActive(var1_61:Find("icon/IconTpl"), #arg1_61.attachments > 0)

	if #arg1_61.attachments > 0 then
		updateDrop(var1_61:Find("icon/IconTpl"), arg1_61.attachments[1])
	end

	setText(var1_61:Find("info/title/Text"), shortenString(arg1_61.title, 10))
	setActive(var1_61:Find("info/title/mark"), arg1_61.importantFlag and arg0_61.mailToggle ~= "collection")
	setText(var1_61:Find("info/time/Text"), os.date("%Y-%m-%d", arg1_61.date))
	setActive(var1_61:Find("info/time/out_time"), false)

	local var2_61 = #arg1_61.attachments > 0 and arg1_61.attachFlag

	setActive(var0_61:Find("got_mark"), arg0_61.mailToggle ~= "collection" and var2_61)
	setText(var0_61:Find("got_mark/got_text"), i18n("mail_reward_got"))
	triggerToggle(var0_61, arg0_61.selectMailId == arg1_61.id)

	local var3_61 = arg1_61.readFlag or arg0_61.mailToggle == "collection"

	setActive(var0_61:Find("hasread_bg"), var3_61)
	setActive(var0_61:Find("noread_bg"), not var3_61)

	local var4_61 = SummerFeastScene.TransformColor(var3_61 and "FFFFFF" or "181E32")

	setTextColor(var1_61:Find("info/title/Text"), var4_61)
	setTextColor(var1_61:Find("info/time/Text"), var4_61)
end

function var0_0.UpdateMailContent(arg0_62, arg1_62)
	eachChild(arg0_62.rtMailRight, function(arg0_63)
		setActive(arg0_63, tobool(arg1_62))
	end)

	if not arg1_62 then
		arg0_62.selectMailId = nil

		return
	end

	arg0_62.selectMailId = arg1_62.id

	changeToScrollText(arg0_62.rtMailRight:Find("main/title/info/Text"), i18n2(arg1_62.title))
	setText(arg0_62.rtMailRight:Find("main/from/Text"), arg1_62.sender)
	setText(arg0_62.rtMailRight:Find("main/time/Text"), os.date("%Y-%m-%d", arg1_62.date))
	setText(arg0_62.rtMailRight:Find("main/view/content/text/Text"), arg1_62.content)

	local var0_62 = arg0_62.rtMailRight:Find("main/title/matter")

	setActive(var0_62, arg0_62.mailToggle ~= "collection")

	if arg0_62.mailToggle ~= "collection" then
		onToggle(arg0_62, arg0_62.rtMailRight:Find("main/title/matter"), function(arg0_64)
			if arg0_64 ~= arg1_62.importantFlag then
				arg0_62:emit(MailMediator.ON_OPERATION, {
					cmd = arg0_64 and "important" or "unimportant",
					filter = {
						type = "ids",
						list = {
							arg1_62.id
						}
					}
				})
			end
		end, SFX_CONFIRM)
		triggerToggle(arg0_62.rtMailRight:Find("main/title/matter"), arg1_62.importantFlag)
	end

	local var1_62 = arg0_62.rtMailRight:Find("main/view/content/attachment")

	setText(var1_62:Find("got/Text"), i18n("main_mailLayer_attachTaken"))
	setActive(var1_62, #arg1_62.attachments > 0)

	if #arg1_62.attachments > 0 then
		local var2_62 = var1_62:Find("content")

		UIItemList.StaticAlign(var2_62, var2_62:Find("IconTpl"), #arg1_62.attachments, function(arg0_65, arg1_65, arg2_65)
			arg1_65 = arg1_65 + 1

			if arg0_65 == UIItemList.EventUpdate then
				local var0_65 = arg1_62.attachments[arg1_65]

				updateDrop(arg2_65, var0_65)
				onButton(arg0_62, arg2_65, function()
					arg0_62:emit(var0_0.ON_DROP, var0_65)
				end, SFX_PANEL)
			end
		end)

		local var3_62 = arg0_62.mailToggle == "collection" or arg1_62.attachFlag

		setCanvasGroupAlpha(var2_62, var3_62 and 0.5 or 1)
		setActive(var1_62:Find("got"), var3_62)
	end

	setActive(arg0_62.rtBtnRightMove, arg0_62.mailToggle ~= "collection")
	setActive(arg0_62.rtBtnRightGet, arg0_62.mailToggle ~= "collection" and not arg1_62.attachFlag)
	setActive(arg0_62.rtBtnRightDelte, arg0_62.mailToggle ~= "collection" and arg1_62.attachFlag)

	if arg0_62.mailToggle ~= "collection" and not arg1_62.readFlag then
		arg0_62:emit(MailMediator.ON_OPERATION, {
			cmd = "read",
			ignoreTips = true,
			filter = {
				type = "ids",
				list = {
					arg1_62.id
				}
			}
		})
	end
end

function var0_0.UpdateOperationDeal(arg0_67, arg1_67, arg2_67, arg3_67)
	if #arg2_67 == 0 then
		pg.TipsMgr.GetInstance():ShowTips(i18n("mail_manage_3"))
	elseif not arg3_67 then
		local var0_67 = switch(arg1_67, {
			delete = function()
				return i18n("main_mailMediator_mailDelete")
			end,
			attachment = function()
				return i18n("main_mailMediator_attachTaken")
			end,
			read = function()
				return i18n("main_mailMediator_mailread")
			end,
			move = function()
				return i18n("main_mailMediator_mailmove")
			end
		})

		if var0_67 then
			pg.TipsMgr.GetInstance():ShowTips(var0_67)
		end
	end

	local var1_67 = {}

	for iter0_67, iter1_67 in ipairs(arg2_67) do
		var1_67[iter1_67] = true
	end

	arg0_67:UpdateMailList(arg0_67.mailToggle)

	if var1_67[arg0_67.selectMailId] then
		arg0_67:UpdateMailContent(underscore.detect(arg0_67.filterMails, function(arg0_72)
			return arg0_72.id == arg0_67.selectMailId
		end))
	end
end

function var0_0.UpdateCollectionDelete(arg0_73, arg1_73)
	arg0_73:UpdateMailList(arg0_73.mailToggle)

	if arg0_73.selectMailId == arg1_73 then
		arg0_73:UpdateMailContent(nil)
	end
end

function var0_0.UpdateStore(arg0_74)
	arg0_74.withdrawal = {
		gold = 0,
		oil = 0
	}

	local var0_74 = getProxy(PlayerProxy):getRawData()
	local var1_74 = pg.mail_storeroom[var0_74.mailStoreLevel]

	setText(arg0_74.rtStore:Find("gold/Text/count"), string.format("%d/%d", var0_74:getResource(PlayerConst.ResStoreGold), var1_74.gold_store))

	local var2_74 = var0_74:IsStoreLevelMax()
	local var3_74 = arg0_74.rtStore:Find("bottom/btn_extend")

	SetActive(var3_74, not var2_74)
	onButton(arg0_74, var3_74, function()
		if var2_74 then
			pg.TipsMgr.GetInstance():ShowTips(i18n("mail_storeroom_noextend"))
		else
			arg0_74.storeUpgradeSubView:ExecuteAction("Show")
		end
	end, SFX_PANEL)

	local var4_74 = arg0_74.rtStore:Find("bottom/btn_get")

	onButton(arg0_74, var4_74, function()
		seriesAsync({
			function(arg0_77)
				arg0_74:ShowDoubleConfiremationMsgBox({
					type = MailProxy.MailMessageBoxType.RewardStoreroom,
					content = arg0_74.withdrawal,
					onYes = arg0_77
				})
			end
		}, function()
			arg0_74:emit(MailMediator.ON_WITHDRAWAL, arg0_74.withdrawal)
		end)
	end, SFX_CONFIRM)

	local function var5_74()
		local var0_79 = arg0_74.withdrawal.oil ~= 0 or arg0_74.withdrawal.gold ~= 0

		setButtonEnabled(var4_74, var0_79)
		setGray(var4_74, not var0_79)
	end

	var5_74()

	for iter0_74, iter1_74 in pairs({
		{
			"oil",
			PlayerConst.ResOil,
			PlayerConst.ResStoreOil,
			"#0173FF",
			"max_oil"
		},
		{
			"gold",
			PlayerConst.ResGold,
			PlayerConst.ResStoreGold,
			"#FF9C01",
			"max_gold"
		}
	}) do
		local var6_74, var7_74, var8_74, var9_74, var10_74 = unpack(iter1_74)
		local var11_74 = pg.gameset[var10_74].key_value - var0_74:getResource(var7_74)
		local var12_74 = math.max(var11_74, 0)
		local var13_74 = var0_74:getResource(var8_74)

		setText(arg0_74.rtStore:Find(var6_74 .. "/tips"), i18n("mail_reward_tips"))
		setText(arg0_74.rtStore:Find(var6_74 .. "/Text/count"), string.format("<color=%s>%d</color>/%d", var9_74, var13_74, var1_74[var6_74 .. "_store"]))

		local var14_74 = arg0_74.rtStore:Find(var6_74 .. "/calc")
		local var15_74 = var14_74:Find("count/count")

		setText(var15_74:Find("tip"), i18n("mail_storeroom_resourcetaken"))
		setInputText(var15_74, arg0_74.withdrawal[var6_74])
		onInputEndEdit(arg0_74, var15_74, function()
			local var0_80 = getInputText(var15_74)

			if var0_80 == "" or var0_80 == nil then
				var0_80 = 0
			end

			local var1_80 = math.clamp(tonumber(var0_80), 0, var13_74)

			if var1_80 >= var12_74 then
				var1_80 = var12_74

				pg.TipsMgr.GetInstance():ShowTips(i18n("resource_max_tip_storeroom"))
			end

			if arg0_74.withdrawal[var6_74] ~= var1_80 then
				arg0_74.withdrawal[var6_74] = var1_80

				var5_74()
			end

			setInputText(var15_74, arg0_74.withdrawal[var6_74])
		end)
		pressPersistTrigger(var14_74:Find("count/left"), 0.5, function(arg0_81)
			if arg0_74.withdrawal[var6_74] == 0 then
				arg0_81()

				return
			end

			arg0_74.withdrawal[var6_74] = math.max(arg0_74.withdrawal[var6_74] - 100, 0)

			setInputText(var15_74, arg0_74.withdrawal[var6_74])

			if arg0_74.withdrawal[var6_74] == 0 then
				var5_74()
			end
		end, nil, true, true, 0.15, SFX_PANEL)
		pressPersistTrigger(var14_74:Find("count/right"), 0.5, function(arg0_82)
			if arg0_74.withdrawal[var6_74] >= var12_74 then
				pg.TipsMgr.GetInstance():ShowTips(i18n("resource_max_tip_storeroom"))
				arg0_82()

				return
			end

			if arg0_74.withdrawal[var6_74] == var13_74 then
				return
			end

			local var0_82 = arg0_74.withdrawal[var6_74]

			arg0_74.withdrawal[var6_74] = math.min(arg0_74.withdrawal[var6_74] + 100, var13_74)

			if arg0_74.withdrawal[var6_74] >= var12_74 then
				arg0_74.withdrawal[var6_74] = var12_74

				pg.TipsMgr.GetInstance():ShowTips(i18n("resource_max_tip_storeroom"))
			end

			setInputText(var15_74, arg0_74.withdrawal[var6_74])

			if var0_82 == 0 then
				var5_74()
			end
		end, nil, true, true, 0.15, SFX_PANEL)
		onButton(arg0_74, var14_74:Find("max"), function()
			arg0_74.withdrawal[var6_74] = getProxy(PlayerProxy):getRawData():ResLack(var6_74, var13_74)

			if arg0_74.withdrawal[var6_74] >= var12_74 then
				arg0_74.withdrawal[var6_74] = var12_74

				pg.TipsMgr.GetInstance():ShowTips(i18n("resource_max_tip_storeroom"))
			end

			setInputText(var15_74, arg0_74.withdrawal[var6_74])
			var5_74()
		end, SFX_PANEL)
	end
end

function var0_0.onBackPressed(arg0_84)
	if arg0_84.mailMgrSubView:isShowing() then
		arg0_84.mailMgrSubView:Hide()
	elseif arg0_84.storeUpgradeSubView:isShowing() then
		arg0_84.storeUpgradeSubView:Hide()
	elseif arg0_84.mailConfirmationSubView:isShowing() then
		arg0_84.mailConfirmationSubView:Hide()
	elseif arg0_84.mailOverflowWindowSubView:isShowing() then
		arg0_84.mailOverflowWindowSubView:Hide()
	elseif arg0_84.mailStoreroomRewardSubView:isShowing() then
		arg0_84.mailStoreroomRewardSubView:Hide()
	else
		triggerButton(arg0_84.rtAdapt:Find("top/back_btn"))
	end
end

function var0_0.willExit(arg0_85)
	arg0_85.mailMgrSubView:Destroy()
	arg0_85.storeUpgradeSubView:Destroy()
	arg0_85.mailConfirmationSubView:Destroy()
	arg0_85.mailOverflowWindowSubView:Destroy()
	arg0_85.mailStoreroomRewardSubView:Destroy()
end

function var0_0.ShowDoubleConfiremationMsgBox(arg0_86, arg1_86)
	if arg1_86.type == MailProxy.MailMessageBoxType.OverflowConfirm then
		arg0_86.mailOverflowWindowSubView:ExecuteAction("Show", arg1_86)
	elseif arg1_86.type == MailProxy.MailMessageBoxType.RewardStoreroom then
		arg0_86.mailStoreroomRewardSubView:ExecuteAction("Show", arg1_86)
	else
		arg0_86.mailConfirmationSubView:ExecuteAction("Show", arg1_86)
	end
end

function var0_0.InitResBar(arg0_87)
	arg0_87.resBar = arg0_87._tf:Find("adapt/top/res")
	arg0_87.goldMax = arg0_87.resBar:Find("gold/max"):GetComponent(typeof(Text))
	arg0_87.goldValue = arg0_87.resBar:Find("gold/Text"):GetComponent(typeof(Text))
	arg0_87.oilMax = arg0_87.resBar:Find("oil/max"):GetComponent(typeof(Text))
	arg0_87.oilValue = arg0_87.resBar:Find("oil/Text"):GetComponent(typeof(Text))
	arg0_87.gemValue = arg0_87.resBar:Find("gem/Text"):GetComponent(typeof(Text))

	onButton(arg0_87, arg0_87.resBar:Find("gold"), function()
		pg.playerResUI:ClickGold()
	end, SFX_PANEL)
	onButton(arg0_87, arg0_87.resBar:Find("oil"), function()
		pg.playerResUI:ClickOil()
	end, SFX_PANEL)
	onButton(arg0_87, arg0_87.resBar:Find("gem"), function()
		pg.playerResUI:ClickGem()
	end, SFX_PANEL)
	arg0_87:UpdateRes()
end

function var0_0.UpdateRes(arg0_91)
	local var0_91 = getProxy(PlayerProxy):getRawData()

	PlayerResUI.StaticFlush(var0_91, arg0_91.goldMax, arg0_91.goldValue, arg0_91.oilMax, arg0_91.oilValue, arg0_91.gemValue)
end

return var0_0
