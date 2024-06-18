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

	arg0_6.rtMailEmpty = var1_6:Find("empty")
	arg0_6.rtStore = var1_6:Find("store")
	arg0_6.mailMgrSubView = MailMgrWindow.New(arg0_6._tf, arg0_6.event, arg0_6.contextData)
	arg0_6.storeUpgradeSubView = StoreUpgradeWindow.New(arg0_6._tf, arg0_6.event, arg0_6.contextData)
	arg0_6.mailConfirmationSubView = MailConfirmationWindow.New(arg0_6._tf, arg0_6.event, arg0_6.contextData)
	arg0_6.mailOverflowWindowSubView = MailOverflowWindow.New(arg0_6._tf, arg0_6.event, arg0_6.contextData)

	setText(arg0_6.rtBtnLeftDeleteAll:Find("Text"), i18n("mail_deleteread_button"))
	setText(arg0_6.rtBtnLeftManager:Find("Text"), i18n("mail_manage_button"))
	setText(arg0_6.rtBtnLeftMoveAll:Find("Text"), i18n("mail_move_button"))
	setText(arg0_6.rtBtnLeftGetAll:Find("Text"), i18n("mail_get_oneclick"))
	setText(arg0_6.rtBtnLeftDeleteCollection:Find("Text"), i18n("mail_delet_button"))
	setText(arg0_6.rtBtnRightMove:Find("Text"), i18n("mail_moveone_button"))
	setText(arg0_6.rtBtnRightGet:Find("Text"), i18n("mail_getone_button"))
	setText(arg0_6.rtMailRight:Find("main/title/matter/on/Text"), i18n("mail_toggle_on"))
	setText(arg0_6.rtMailRight:Find("main/title/matter/off/Text"), i18n("mail_toggle_off"))
	arg0_6:InitResBar()
end

function var0_0.SetPage(arg0_40, arg1_40)
	if arg0_40.page == arg1_40 then
		return
	end

	arg0_40.page = arg1_40

	setActive(arg0_40.rightSelect, arg1_40 == "mail")
	setActive(arg0_40.rtSearch, arg1_40 == "collection")
	setActive(arg0_40.rtStore, arg1_40 == "store")

	if arg1_40 == "store" then
		setActive(arg0_40.rtMailEmpty, false)
		setActive(arg0_40.rtMailLeft, false)
		setActive(arg0_40.rtMailRight, false)

		arg0_40.mailToggle = nil

		arg0_40:UpdateStore()
		setText(arg0_40.rtTip, i18n("mail_storeroom_tips"))
	elseif arg1_40 == "mail" then
		triggerToggle(arg0_40.rtToggles:Find("btn_all"), true)
		setText(arg0_40.rtTip, i18n("warning_mail_max_5"))
	elseif arg1_40 == "collection" then
		local var0_40 = {}

		if not arg0_40.proxy.collectionIds then
			table.insert(var0_40, function(arg0_41)
				arg0_40:emit(MailMediator.ON_REQUIRE, "collection", arg0_41)
			end)
		end

		seriesAsync(var0_40, function()
			arg0_40.selectMailId = nil

			arg0_40:UpdateMailList("collection", 0)
		end)
		setText(arg0_40.rtTip, i18n("mail_markroom_tip"))
	end
end

function var0_0.didEnter(arg0_43)
	onNextTick(function()
		arg0_43.lsrMailList.enabled = true

		triggerToggle(arg0_43.rtLabels:Find("mail"), true)
	end)
end

function var0_0.RequrereNextToIndex(arg0_45, arg1_45)
	if arg0_45.mailToggle == "all" and not arg0_45.inRequire and #arg0_45.proxy.ids < arg0_45.proxy.totalExist and arg1_45 > #arg0_45.proxy.ids then
		arg0_45.inRequire = true

		pg.UIMgr.GetInstance():LoadingOn()
		arg0_45:emit(MailMediator.ON_REQUIRE, arg1_45, function()
			arg0_45.inRequire = nil

			if arg0_45.mailToggle == "all" then
				arg0_45:UpdateMailList(arg0_45.mailToggle)
			end

			pg.UIMgr.GetInstance():LoadingOff()
		end)
	end
end

function var0_0.UpdateMailList(arg0_47, arg1_47, arg2_47)
	arg0_47.mailToggle = arg1_47

	local var0_47, var1_47 = switch(arg1_47, {
		all = function()
			return arg0_47.proxy.ids, string.format("<color=%s>%d</color>/<color=%s>%d</color>", arg0_47.proxy.totalExist > MAIL_COUNT_LIMIT and COLOR_RED or COLOR_WHITE, arg0_47.proxy.totalExist, "#181E32", MAIL_COUNT_LIMIT)
		end,
		important = function()
			return arg0_47.proxy.importantIds, string.format("<color=#FFFFFF>%d</color>", #arg0_47.proxy.importantIds)
		end,
		rare = function()
			return arg0_47.proxy.rareIds, string.format("<color=#FFFFFF>%d</color>", #arg0_47.proxy.rareIds)
		end,
		collection = function()
			return arg0_47.proxy.collectionIds, string.format("<color=#FFFFFF>%d</color>/%d", #arg0_47.proxy.collectionIds, getProxy(PlayerProxy):getRawData():getConfig("max_markmail"))
		end
	})

	if arg1_47 == "collection" then
		arg0_47.filterMails = arg0_47.proxy:GetCollectionMails(var0_47)

		if arg0_47.collectionFilterStr then
			arg0_47.filterMails = underscore.filter(arg0_47.filterMails, function(arg0_52)
				return arg0_52:IsMatchKey(arg0_47.collectionFilterStr)
			end)
		end

		table.sort(arg0_47.filterMails, CompareFuncs({
			function(arg0_53)
				return (arg0_47.collectionSortToggle and 1 or -1) * arg0_53.id
			end
		}))
	elseif arg1_47 == "all" then
		arg0_47.filterMails = arg0_47.proxy:GetMails(var0_47)

		table.sort(arg0_47.filterMails, CompareFuncs({
			function(arg0_54)
				return -arg0_54.id
			end
		}))

		for iter0_47 = #var0_47 + 1, arg0_47.proxy.totalExist do
			table.insert(arg0_47.filterMails, {
				id = 0
			})
		end
	else
		arg0_47.filterMails = arg0_47.proxy:GetMails(var0_47)

		table.sort(arg0_47.filterMails, CompareFuncs({
			function(arg0_55)
				return -arg0_55.id
			end
		}))
	end

	if arg0_47.mailToggle == "all" and #arg0_47.proxy.ids < arg0_47.proxy.totalExist and #arg0_47.proxy.ids < SINGLE_MAIL_REQUIRE_SIZE then
		arg0_47.inRequire = true

		arg0_47:emit(MailMediator.ON_REQUIRE, "next", function()
			if arg0_47.mailToggle == "all" then
				arg0_47:UpdateMailList(arg0_47.mailToggle)
			end

			arg0_47.inRequire = nil
		end)
	elseif #arg0_47.filterMails == 0 then
		setActive(arg0_47.rtMailLeft, false)
		setActive(arg0_47.rtMailRight, false)
		setActive(arg0_47.rtMailEmpty, true)

		if arg0_47.mailToggle == "collection" then
			setText(arg0_47.rtMailEmpty:Find("Text"), i18n("emptymarkroom_tip_mailboxui"))
			setText(arg0_47.rtMailEmpty:Find("Text_en"), i18n("emptymarkroom_tip_mailboxui_en"))
		else
			setText(arg0_47.rtMailEmpty:Find("Text"), i18n("empty_tip_mailboxui"))
			setText(arg0_47.rtMailEmpty:Find("Text_en"), i18n("empty_tip_mailboxui_en"))
		end
	else
		setActive(arg0_47.rtMailLeft, true)
		setActive(arg0_47.rtMailRight, true)
		setActive(arg0_47.rtMailEmpty, false)

		if not arg0_47.selectMailId then
			arg0_47:UpdateMailContent(arg0_47.filterMails[1])
		end

		arg0_47.lsrMailList:SetTotalCount(#arg0_47.filterMails, arg2_47 or -1)
		setText(arg0_47.rtMailCount, var1_47)
		setActive(arg0_47.rtBtnLeftManager, arg0_47.mailToggle == "all")
		setActive(arg0_47.rtBtnLeftMoveAll, arg0_47.mailToggle == "important")
		setActive(arg0_47.rtBtnLeftDeleteCollection, arg0_47.mailToggle == "collection")
		setActive(arg0_47.rtBtnLeftDeleteAll, arg0_47.mailToggle == "all" or arg0_47.mailToggle == "rare")
		setActive(arg0_47.rtBtnLeftGetAll, arg0_47.mailToggle == "important" or arg0_47.mailToggle == "rare")
	end
end

function var0_0.UpdateMailTpl(arg0_57, arg1_57)
	local var0_57 = arg0_57.mailTplDic[arg1_57.id]

	if not var0_57 then
		return
	end

	local var1_57 = var0_57:Find("content")

	setActive(var1_57:Find("icon/no_attachment"), #arg1_57.attachments == 0)
	setActive(var1_57:Find("icon/IconTpl"), #arg1_57.attachments > 0)

	if #arg1_57.attachments > 0 then
		updateDrop(var1_57:Find("icon/IconTpl"), arg1_57.attachments[1])
	end

	setText(var1_57:Find("info/title/Text"), shortenString(arg1_57.title, 10))
	setActive(var1_57:Find("info/title/mark"), arg1_57.importantFlag and arg0_57.mailToggle ~= "collection")
	setText(var1_57:Find("info/time/Text"), os.date("%Y-%m-%d", arg1_57.date))
	setActive(var1_57:Find("info/time/out_time"), false)

	local var2_57 = #arg1_57.attachments > 0 and arg1_57.attachFlag

	setActive(var0_57:Find("got_mark"), arg0_57.mailToggle ~= "collection" and var2_57)
	setText(var0_57:Find("got_mark/got_text"), i18n("mail_reward_got"))
	triggerToggle(var0_57, arg0_57.selectMailId == arg1_57.id)

	local var3_57 = arg1_57.readFlag or arg0_57.mailToggle == "collection"

	setActive(var0_57:Find("hasread_bg"), var3_57)
	setActive(var0_57:Find("noread_bg"), not var3_57)

	local var4_57 = SummerFeastScene.TransformColor(var3_57 and "FFFFFF" or "181E32")

	setTextColor(var1_57:Find("info/title/Text"), var4_57)
	setTextColor(var1_57:Find("info/time/Text"), var4_57)
end

function var0_0.UpdateMailContent(arg0_58, arg1_58)
	eachChild(arg0_58.rtMailRight, function(arg0_59)
		setActive(arg0_59, tobool(arg1_58))
	end)

	if not arg1_58 then
		arg0_58.selectMailId = nil

		return
	end

	arg0_58.selectMailId = arg1_58.id

	changeToScrollText(arg0_58.rtMailRight:Find("main/title/info/Text"), i18n2(arg1_58.title))
	setText(arg0_58.rtMailRight:Find("main/from/Text"), arg1_58.sender)
	setText(arg0_58.rtMailRight:Find("main/time/Text"), os.date("%Y-%m-%d", arg1_58.date))
	setText(arg0_58.rtMailRight:Find("main/view/content/text/Text"), arg1_58.content)

	local var0_58 = arg0_58.rtMailRight:Find("main/title/matter")

	setActive(var0_58, arg0_58.mailToggle ~= "collection")

	if arg0_58.mailToggle ~= "collection" then
		onToggle(arg0_58, arg0_58.rtMailRight:Find("main/title/matter"), function(arg0_60)
			if arg0_60 ~= arg1_58.importantFlag then
				arg0_58:emit(MailMediator.ON_OPERATION, {
					cmd = arg0_60 and "important" or "unimportant",
					filter = {
						type = "ids",
						list = {
							arg1_58.id
						}
					}
				})
			end
		end, SFX_CONFIRM)
		triggerToggle(arg0_58.rtMailRight:Find("main/title/matter"), arg1_58.importantFlag)
	end

	local var1_58 = arg0_58.rtMailRight:Find("main/view/content/attachment")

	setText(var1_58:Find("got/Text"), i18n("main_mailLayer_attachTaken"))
	setActive(var1_58, #arg1_58.attachments > 0)

	if #arg1_58.attachments > 0 then
		local var2_58 = var1_58:Find("content")

		UIItemList.StaticAlign(var2_58, var2_58:Find("IconTpl"), #arg1_58.attachments, function(arg0_61, arg1_61, arg2_61)
			arg1_61 = arg1_61 + 1

			if arg0_61 == UIItemList.EventUpdate then
				local var0_61 = arg1_58.attachments[arg1_61]

				updateDrop(arg2_61, var0_61)
				onButton(arg0_58, arg2_61, function()
					arg0_58:emit(var0_0.ON_DROP, var0_61)
				end, SFX_PANEL)
			end
		end)

		local var3_58 = arg0_58.mailToggle == "collection" or arg1_58.attachFlag

		setCanvasGroupAlpha(var2_58, var3_58 and 0.5 or 1)
		setActive(var1_58:Find("got"), var3_58)
	end

	setActive(arg0_58.rtBtnRightMove, arg0_58.mailToggle ~= "collection")
	setActive(arg0_58.rtBtnRightGet, arg0_58.mailToggle ~= "collection" and not arg1_58.attachFlag)

	if arg0_58.mailToggle ~= "collection" and not arg1_58.readFlag then
		arg0_58:emit(MailMediator.ON_OPERATION, {
			cmd = "read",
			ignoreTips = true,
			filter = {
				type = "ids",
				list = {
					arg1_58.id
				}
			}
		})
	end
end

function var0_0.UpdateOperationDeal(arg0_63, arg1_63, arg2_63, arg3_63)
	if #arg2_63 == 0 then
		pg.TipsMgr.GetInstance():ShowTips(i18n("mail_manage_3"))
	elseif not arg3_63 then
		local var0_63 = switch(arg1_63, {
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

		if var0_63 then
			pg.TipsMgr.GetInstance():ShowTips(var0_63)
		end
	end

	local var1_63 = {}

	for iter0_63, iter1_63 in ipairs(arg2_63) do
		var1_63[iter1_63] = true
	end

	arg0_63:UpdateMailList(arg0_63.mailToggle)

	if var1_63[arg0_63.selectMailId] then
		arg0_63:UpdateMailContent(underscore.detect(arg0_63.filterMails, function(arg0_68)
			return arg0_68.id == arg0_63.selectMailId
		end))
	end
end

function var0_0.UpdateCollectionDelete(arg0_69, arg1_69)
	arg0_69:UpdateMailList(arg0_69.mailToggle)

	if arg0_69.selectMailId == arg1_69 then
		arg0_69:UpdateMailContent(nil)
	end
end

function var0_0.UpdateStore(arg0_70)
	arg0_70.withdrawal = {
		gold = 0,
		oil = 0
	}

	local var0_70 = getProxy(PlayerProxy):getRawData()
	local var1_70 = pg.mail_storeroom[var0_70.mailStoreLevel]

	setText(arg0_70.rtStore:Find("gold/Text/count"), string.format("%d/%d", var0_70:getResource(PlayerConst.ResStoreGold), var1_70.gold_store))

	local var2_70 = var0_70:IsStoreLevelMax()
	local var3_70 = arg0_70.rtStore:Find("bottom/btn_extend")

	SetActive(var3_70, not var2_70)
	onButton(arg0_70, var3_70, function()
		if var2_70 then
			pg.TipsMgr.GetInstance():ShowTips(i18n("mail_storeroom_noextend"))
		else
			arg0_70.storeUpgradeSubView:ExecuteAction("Show")
		end
	end, SFX_PANEL)

	local var4_70 = arg0_70.rtStore:Find("bottom/btn_get")

	onButton(arg0_70, var4_70, function()
		arg0_70:emit(MailMediator.ON_WITHDRAWAL, arg0_70.withdrawal)
	end, SFX_CONFIRM)

	local function var5_70()
		local var0_73 = arg0_70.withdrawal.oil ~= 0 or arg0_70.withdrawal.gold ~= 0

		setButtonEnabled(var4_70, var0_73)
		setGray(var4_70, not var0_73)
	end

	var5_70()

	for iter0_70, iter1_70 in pairs({
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
		local var6_70, var7_70, var8_70, var9_70, var10_70 = unpack(iter1_70)
		local var11_70 = pg.gameset[var10_70].key_value - var0_70:getResource(var7_70)
		local var12_70 = math.max(var11_70, 0)
		local var13_70 = var0_70:getResource(var8_70)

		setText(arg0_70.rtStore:Find(var6_70 .. "/tips"), i18n("mail_reward_tips"))
		setText(arg0_70.rtStore:Find(var6_70 .. "/Text/count"), string.format("<color=%s>%d</color>/%d", var9_70, var13_70, var1_70[var6_70 .. "_store"]))

		local var14_70 = arg0_70.rtStore:Find(var6_70 .. "/calc")
		local var15_70 = var14_70:Find("count/count")

		setText(var15_70:Find("tip"), i18n("mail_storeroom_resourcetaken"))
		setInputText(var15_70, arg0_70.withdrawal[var6_70])
		onInputEndEdit(arg0_70, var15_70, function()
			local var0_74 = getInputText(var15_70)

			if var0_74 == "" or var0_74 == nil then
				var0_74 = 0
			end

			local var1_74 = math.clamp(tonumber(var0_74), 0, var13_70)

			if var1_74 >= var12_70 then
				var1_74 = var12_70

				pg.TipsMgr.GetInstance():ShowTips(i18n("resource_max_tip_storeroom"))
			end

			if arg0_70.withdrawal[var6_70] ~= var1_74 then
				arg0_70.withdrawal[var6_70] = var1_74

				var5_70()
			end

			setInputText(var15_70, arg0_70.withdrawal[var6_70])
		end)
		pressPersistTrigger(var14_70:Find("count/left"), 0.5, function(arg0_75)
			if arg0_70.withdrawal[var6_70] == 0 then
				arg0_75()

				return
			end

			arg0_70.withdrawal[var6_70] = math.max(arg0_70.withdrawal[var6_70] - 100, 0)

			setInputText(var15_70, arg0_70.withdrawal[var6_70])

			if arg0_70.withdrawal[var6_70] == 0 then
				var5_70()
			end
		end, nil, true, true, 0.15, SFX_PANEL)
		pressPersistTrigger(var14_70:Find("count/right"), 0.5, function(arg0_76)
			if arg0_70.withdrawal[var6_70] >= var12_70 then
				pg.TipsMgr.GetInstance():ShowTips(i18n("resource_max_tip_storeroom"))
				arg0_76()

				return
			end

			if arg0_70.withdrawal[var6_70] == var13_70 then
				return
			end

			local var0_76 = arg0_70.withdrawal[var6_70]

			arg0_70.withdrawal[var6_70] = math.min(arg0_70.withdrawal[var6_70] + 100, var13_70)

			if arg0_70.withdrawal[var6_70] >= var12_70 then
				arg0_70.withdrawal[var6_70] = var12_70

				pg.TipsMgr.GetInstance():ShowTips(i18n("resource_max_tip_storeroom"))
			end

			setInputText(var15_70, arg0_70.withdrawal[var6_70])

			if var0_76 == 0 then
				var5_70()
			end
		end, nil, true, true, 0.15, SFX_PANEL)
		onButton(arg0_70, var14_70:Find("max"), function()
			arg0_70.withdrawal[var6_70] = getProxy(PlayerProxy):getRawData():ResLack(var6_70, var13_70)

			if arg0_70.withdrawal[var6_70] >= var12_70 then
				arg0_70.withdrawal[var6_70] = var12_70

				pg.TipsMgr.GetInstance():ShowTips(i18n("resource_max_tip_storeroom"))
			end

			setInputText(var15_70, arg0_70.withdrawal[var6_70])
			var5_70()
		end, SFX_PANEL)
	end
end

function var0_0.onBackPressed(arg0_78)
	if arg0_78.mailMgrSubView:isShowing() then
		arg0_78.mailMgrSubView:Hide()
	elseif arg0_78.storeUpgradeSubView:isShowing() then
		arg0_78.storeUpgradeSubView:Hide()
	elseif arg0_78.mailConfirmationSubView:isShowing() then
		arg0_78.mailConfirmationSubView:Hide()
	elseif arg0_78.mailOverflowWindowSubView:isShowing() then
		arg0_78.mailOverflowWindowSubView:Hide()
	else
		triggerButton(arg0_78.rtAdapt:Find("top/back_btn"))
	end
end

function var0_0.willExit(arg0_79)
	arg0_79.mailMgrSubView:Destroy()
	arg0_79.storeUpgradeSubView:Destroy()
	arg0_79.mailConfirmationSubView:Destroy()
	arg0_79.mailOverflowWindowSubView:Destroy()
end

function var0_0.ShowDoubleConfiremationMsgBox(arg0_80, arg1_80)
	if arg1_80.type == MailProxy.MailMessageBoxType.OverflowConfirm then
		arg0_80.mailOverflowWindowSubView:ExecuteAction("Show", arg1_80)
	else
		arg0_80.mailConfirmationSubView:ExecuteAction("Show", arg1_80)
	end
end

function var0_0.InitResBar(arg0_81)
	arg0_81.resBar = arg0_81._tf:Find("adapt/top/res")
	arg0_81.goldMax = arg0_81.resBar:Find("gold/max"):GetComponent(typeof(Text))
	arg0_81.goldValue = arg0_81.resBar:Find("gold/Text"):GetComponent(typeof(Text))
	arg0_81.oilMax = arg0_81.resBar:Find("oil/max"):GetComponent(typeof(Text))
	arg0_81.oilValue = arg0_81.resBar:Find("oil/Text"):GetComponent(typeof(Text))
	arg0_81.gemValue = arg0_81.resBar:Find("gem/Text"):GetComponent(typeof(Text))

	onButton(arg0_81, arg0_81.resBar:Find("gold"), function()
		pg.playerResUI:ClickGold()
	end, SFX_PANEL)
	onButton(arg0_81, arg0_81.resBar:Find("oil"), function()
		pg.playerResUI:ClickOil()
	end, SFX_PANEL)
	onButton(arg0_81, arg0_81.resBar:Find("gem"), function()
		pg.playerResUI:ClickGem()
	end, SFX_PANEL)
	arg0_81:UpdateRes()
end

function var0_0.UpdateRes(arg0_85)
	local var0_85 = getProxy(PlayerProxy):getRawData()

	PlayerResUI.StaticFlush(var0_85, arg0_85.goldMax, arg0_85.goldValue, arg0_85.oilMax, arg0_85.oilValue, arg0_85.gemValue)
end

return var0_0
