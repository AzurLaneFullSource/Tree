local var0 = class("MailScene", import("view.base.BaseUI"))
local var1 = 592
local var2 = 125
local var3 = 9

function var0.getUIName(arg0)
	return "MailUI"
end

function var0.ResUISettings(arg0)
	return false
end

var0.optionsPath = {
	"adapt/top/option"
}

function var0.quickExitFunc(arg0)
	local var0 = {}

	if arg0.proxy.totalExist > MAIL_COUNT_LIMIT then
		table.insert(var0, function(arg0)
			arg0:ShowDoubleConfiremationMsgBox({
				type = MailProxy.MailMessageBoxType.ShowTips,
				content = i18n("warning_mail_max_4", arg0.proxy.totalExist),
				onYes = arg0
			})
		end)
	end

	seriesAsync(var0, function()
		arg0:emit(var0.ON_HOME)
	end)
end

function var0.init(arg0)
	arg0.proxy = getProxy(MailProxy)
	arg0.rtAdapt = arg0._tf:Find("adapt")

	setText(arg0.rtAdapt:Find("top/title"), i18n("mail_title_new"))
	setText(arg0.rtAdapt:Find("top/title/Text"), i18n("mail_title_English"))
	onButton(arg0, arg0.rtAdapt:Find("top/back_btn"), function()
		local var0 = {}

		if arg0.proxy.totalExist > MAIL_COUNT_LIMIT then
			table.insert(var0, function(arg0)
				arg0:ShowDoubleConfiremationMsgBox({
					type = MailProxy.MailMessageBoxType.ShowTips,
					content = i18n("warning_mail_max_4", arg0.proxy.totalExist),
					onYes = arg0
				})
			end)
		end

		seriesAsync(var0, function()
			arg0:closeView()
		end)
	end, SFX_CANCEL)

	arg0.rtLabels = arg0.rtAdapt:Find("left_length/frame/tagRoot")

	eachChild(arg0.rtLabels, function(arg0)
		local var0

		if arg0.name == "mail" then
			toggleName = "mail_mail_page"
		elseif arg0.name == "store" then
			toggleName = "mail_storeroom_page"
		elseif arg0.name == "collection" then
			toggleName = "mail_boxroom_page"
		end

		setText(arg0:Find("unSelect/Text"), i18n(toggleName))
		setText(arg0:Find("selected/Text"), i18n(toggleName))
		onToggle(arg0, arg0, function(arg0)
			if arg0 then
				arg0:SetPage(arg0.name)
			end
		end, SFX_PANEL)
	end)

	local var0 = arg0.rtAdapt:Find("main/content/left/head")

	arg0.rightSelect = var0:Find("rightSelect")
	arg0.rtToggles = arg0.rightSelect:Find("toggle")

	eachChild(arg0.rtToggles, function(arg0)
		local var0

		if arg0.name == "btn_all" then
			toggleName = "mail_all_page"
		elseif arg0.name == "btn_important" then
			toggleName = "mail_important_page"
		elseif arg0.name == "btn_rare" then
			toggleName = "mail_rare_page"
		end

		setText(arg0:Find("unselect/Text"), i18n(toggleName))
		setText(arg0:Find("select/Text"), i18n(toggleName))
	end)
	onToggle(arg0, arg0.rtToggles:Find("btn_all"), function(arg0)
		if arg0 then
			if arg0.mailToggle == "all" then
				return
			end

			arg0.selectMailId = nil

			arg0:UpdateMailList("all", 0)
		end
	end, SFX_PANEL)
	onToggle(arg0, arg0.rtToggles:Find("btn_important"), function(arg0)
		if arg0 then
			local var0 = {}

			if not arg0.proxy.importantIds then
				table.insert(var0, function(arg0)
					arg0:emit(MailMediator.ON_REQUIRE, "important", arg0)
				end)
			end

			seriesAsync(var0, function()
				if arg0.mailToggle == "important" then
					return
				end

				arg0.selectMailId = nil

				arg0:UpdateMailList("important", 0)
			end)
		end
	end, SFX_PANEL)
	onToggle(arg0, arg0.rtToggles:Find("btn_rare"), function(arg0)
		if arg0 then
			local var0 = {}

			if not arg0.proxy.rareIds then
				table.insert(var0, function(arg0)
					arg0:emit(MailMediator.ON_REQUIRE, "rare", arg0)
				end)
			end

			seriesAsync(var0, function()
				if arg0.mailToggle == "rare" then
					return
				end

				arg0.selectMailId = nil

				arg0:UpdateMailList("rare", 0)
			end)
		end
	end, SFX_PANEL)
	onButton(arg0, arg0.rtAdapt:Find("top/help"), function()
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_HELP,
			helps = i18n("mail_tip")
		})
	end, SFX_PANEL)

	arg0.rtSearch = var0:Find("search")
	arg0.rtCollectionInput = arg0.rtSearch:Find("input/InputField")

	setText(arg0.rtCollectionInput:Find("Placeholder"), i18n("mail_search_new"))
	onInputEndEdit(arg0, arg0.rtCollectionInput, function()
		arg0.collectionFilterStr = getInputText(arg0.rtCollectionInput)

		if arg0.mailToggle == "collection" then
			arg0:UpdateMailList(arg0.mailToggle, 0)
		end
	end)

	arg0.collectionFilterStr = ""
	arg0.rtToggleCollectionSort = arg0.rtSearch:Find("sort")

	setText(arg0.rtToggleCollectionSort:Find("Text"), i18n("mail_receive_time"))
	onToggle(arg0, arg0.rtToggleCollectionSort, function(arg0)
		arg0.collectionSortToggle = arg0

		if arg0.mailToggle == "collection" then
			arg0:UpdateMailList(arg0.mailToggle, 0)
		end
	end, SFX_PANEL)
	triggerToggle(arg0.rtToggleCollectionSort, false)

	local var1 = arg0.rtAdapt:Find("main/content")

	arg0.rtMailLeft = var1:Find("left/left_content")
	arg0.rtTip = arg0.rtMailLeft:Find("top/tip")
	arg0.rtMailCount = arg0.rtMailLeft:Find("top/count")
	arg0.Scrollbar = arg0.rtMailLeft:Find("middle/Scrollbar"):GetComponent("Scrollbar")
	arg0.lsrMailList = arg0.rtMailLeft:Find("middle/container"):GetComponent("LScrollRect")

	function arg0.lsrMailList.onUpdateItem(arg0, arg1)
		arg0 = arg0 + 1

		local var0 = tf(arg1)
		local var1 = arg0.filterMails[arg0]

		if var1.id == 0 then
			GetOrAddComponent(arg1, typeof(CanvasGroup)).alpha = 0
			GetOrAddComponent(arg1, typeof(CanvasGroup)).blocksRaycasts = false

			arg0:RequrereNextToIndex(arg0)

			return
		end

		if arg0.tplMailDic[var0] then
			arg0.mailTplDic[arg0.tplMailDic[var0]] = nil
		end

		arg0.mailTplDic[var1.id] = var0
		arg0.tplMailDic[var0] = var1.id

		onToggle(arg0, var0, function(arg0)
			if arg0 then
				if arg0.selectMailId ~= var1.id then
					arg0:UpdateMailContent(var1)
				end
			elseif var1.id == arg0.selectMailId then
				arg0:UpdateMailContent(nil)
			end
		end, SFX_PANEL)

		GetOrAddComponent(arg1, typeof(CanvasGroup)).alpha = 1
		GetOrAddComponent(arg1, typeof(CanvasGroup)).blocksRaycasts = true

		arg0:UpdateMailTpl(var1)
	end

	arg0.mailTplDic = {}
	arg0.tplMailDic = {}
	arg0.rtBtnLeftManager = arg0.rtMailLeft:Find("bottom/btn_managerMail")

	onButton(arg0, arg0.rtBtnLeftManager, function()
		arg0.mailMgrSubView:ExecuteAction("Show")
	end, SFX_PANEL)

	arg0.rtBtnLeftDeleteAll = arg0.rtMailLeft:Find("bottom/btn_deleteMail")

	onButton(arg0, arg0.rtBtnLeftDeleteAll, function()
		seriesAsync({
			function(arg0)
				arg0:ShowDoubleConfiremationMsgBox({
					type = MailProxy.MailMessageBoxType.ShowTips,
					content = i18n("main_mailLayer_quest_clear"),
					onYes = arg0
				})
			end
		}, function()
			arg0:emit(MailMediator.ON_OPERATION, {
				cmd = "delete",
				filter = {
					type = "all"
				}
			})
		end)
	end, SFX_CANCEL)

	arg0.rtBtnLeftMoveAll = arg0.rtMailLeft:Find("bottom/btn_moveAll")

	onButton(arg0, arg0.rtBtnLeftMoveAll, function()
		seriesAsync({
			function(arg0)
				arg0:ShowDoubleConfiremationMsgBox({
					type = MailProxy.MailMessageBoxType.ShowTips,
					content = i18n("mail_moveto_markroom_2"),
					onYes = arg0
				})
			end
		}, function()
			arg0:emit(MailMediator.ON_OPERATION, {
				cmd = "move",
				filter = {
					type = "ids",
					list = underscore.rest(arg0.proxy.importantIds, 1)
				}
			})
		end)
	end, SFX_CANCEL)

	arg0.rtBtnLeftGetAll = arg0.rtMailLeft:Find("bottom/btn_getAll")

	onButton(arg0, arg0.rtBtnLeftGetAll, function()
		local var0 = {}

		if arg0.mailToggle == "important" then
			var0 = underscore.rest(arg0.proxy.importantIds, 1)
		elseif arg0.mailToggle == "rare" then
			var0 = underscore.rest(arg0.proxy.rareIds, 1)
		else
			assert(false)
		end

		arg0:emit(MailMediator.ON_OPERATION, {
			cmd = "attachment",
			filter = {
				type = "ids",
				list = var0
			}
		})
	end, SFX_CANCEL)

	arg0.rtBtnLeftDeleteCollection = arg0.rtMailLeft:Find("bottom/btn_deleteCollection")

	onButton(arg0, arg0.rtBtnLeftDeleteCollection, function()
		if not arg0.selectMailId then
			return
		end

		assert(arg0.selectMailId)

		local var0 = arg0.proxy:getCollecitonMail(arg0.selectMailId)

		seriesAsync({
			function(arg0)
				arg0:ShowDoubleConfiremationMsgBox({
					type = MailProxy.MailMessageBoxType.ShowTips,
					content = i18n("mail_markroom_delete", var0.title),
					onYes = arg0
				})
			end
		}, function()
			arg0:emit(MailMediator.ON_DELETE_COLLECTION, arg0.selectMailId)
		end)
	end, SFX_CANCEL)

	arg0.rtMailRight = var1:Find("right")
	arg0.rtBtnRightMove = arg0.rtMailRight:Find("bottom/btn_move")

	onButton(arg0, arg0.rtBtnRightMove, function()
		assert(arg0.selectMailId)
		seriesAsync({
			function(arg0)
				arg0:ShowDoubleConfiremationMsgBox({
					type = MailProxy.MailMessageBoxType.ShowTips,
					content = i18n("mail_moveto_markroom_1"),
					onYes = arg0
				})
			end
		}, function()
			arg0:emit(MailMediator.ON_OPERATION, {
				noAttachTip = true,
				cmd = "move",
				filter = {
					type = "ids",
					list = {
						arg0.selectMailId
					}
				}
			})
		end)
	end, SFX_PANEL)

	arg0.rtBtnRightGet = arg0.rtMailRight:Find("bottom/btn_get")

	onButton(arg0, arg0.rtBtnRightGet, function()
		assert(arg0.selectMailId)
		arg0:emit(MailMediator.ON_OPERATION, {
			noAttachTip = true,
			cmd = "attachment",
			filter = {
				type = "ids",
				list = {
					arg0.selectMailId
				}
			}
		})
	end, SFX_PANEL)

	arg0.rtMailEmpty = var1:Find("empty")
	arg0.rtStore = var1:Find("store")
	arg0.mailMgrSubView = MailMgrWindow.New(arg0._tf, arg0.event, arg0.contextData)
	arg0.storeUpgradeSubView = StoreUpgradeWindow.New(arg0._tf, arg0.event, arg0.contextData)
	arg0.mailConfirmationSubView = MailConfirmationWindow.New(arg0._tf, arg0.event, arg0.contextData)
	arg0.mailOverflowWindowSubView = MailOverflowWindow.New(arg0._tf, arg0.event, arg0.contextData)

	setText(arg0.rtBtnLeftDeleteAll:Find("Text"), i18n("mail_deleteread_button"))
	setText(arg0.rtBtnLeftManager:Find("Text"), i18n("mail_manage_button"))
	setText(arg0.rtBtnLeftMoveAll:Find("Text"), i18n("mail_move_button"))
	setText(arg0.rtBtnLeftGetAll:Find("Text"), i18n("mail_get_oneclick"))
	setText(arg0.rtBtnLeftDeleteCollection:Find("Text"), i18n("mail_delet_button"))
	setText(arg0.rtBtnRightMove:Find("Text"), i18n("mail_moveone_button"))
	setText(arg0.rtBtnRightGet:Find("Text"), i18n("mail_getone_button"))
	setText(arg0.rtMailRight:Find("main/title/matter/on/Text"), i18n("mail_toggle_on"))
	setText(arg0.rtMailRight:Find("main/title/matter/off/Text"), i18n("mail_toggle_off"))
	arg0:InitResBar()
end

function var0.SetPage(arg0, arg1)
	if arg0.page == arg1 then
		return
	end

	arg0.page = arg1

	setActive(arg0.rightSelect, arg1 == "mail")
	setActive(arg0.rtSearch, arg1 == "collection")
	setActive(arg0.rtStore, arg1 == "store")

	if arg1 == "store" then
		setActive(arg0.rtMailEmpty, false)
		setActive(arg0.rtMailLeft, false)
		setActive(arg0.rtMailRight, false)

		arg0.mailToggle = nil

		arg0:UpdateStore()
		setText(arg0.rtTip, i18n("mail_storeroom_tips"))
	elseif arg1 == "mail" then
		triggerToggle(arg0.rtToggles:Find("btn_all"), true)
		setText(arg0.rtTip, i18n("warning_mail_max_5"))
	elseif arg1 == "collection" then
		local var0 = {}

		if not arg0.proxy.collectionIds then
			table.insert(var0, function(arg0)
				arg0:emit(MailMediator.ON_REQUIRE, "collection", arg0)
			end)
		end

		seriesAsync(var0, function()
			arg0.selectMailId = nil

			arg0:UpdateMailList("collection", 0)
		end)
		setText(arg0.rtTip, i18n("mail_markroom_tip"))
	end
end

function var0.didEnter(arg0)
	onNextTick(function()
		arg0.lsrMailList.enabled = true

		triggerToggle(arg0.rtLabels:Find("mail"), true)
	end)
end

function var0.RequrereNextToIndex(arg0, arg1)
	if arg0.mailToggle == "all" and not arg0.inRequire and #arg0.proxy.ids < arg0.proxy.totalExist and arg1 > #arg0.proxy.ids then
		arg0.inRequire = true

		pg.UIMgr.GetInstance():LoadingOn()
		arg0:emit(MailMediator.ON_REQUIRE, arg1, function()
			arg0.inRequire = nil

			if arg0.mailToggle == "all" then
				arg0:UpdateMailList(arg0.mailToggle)
			end

			pg.UIMgr.GetInstance():LoadingOff()
		end)
	end
end

function var0.UpdateMailList(arg0, arg1, arg2)
	arg0.mailToggle = arg1

	local var0, var1 = switch(arg1, {
		all = function()
			return arg0.proxy.ids, string.format("<color=%s>%d</color>/<color=%s>%d</color>", arg0.proxy.totalExist > MAIL_COUNT_LIMIT and COLOR_RED or COLOR_WHITE, arg0.proxy.totalExist, "#181E32", MAIL_COUNT_LIMIT)
		end,
		important = function()
			return arg0.proxy.importantIds, string.format("<color=#FFFFFF>%d</color>", #arg0.proxy.importantIds)
		end,
		rare = function()
			return arg0.proxy.rareIds, string.format("<color=#FFFFFF>%d</color>", #arg0.proxy.rareIds)
		end,
		collection = function()
			return arg0.proxy.collectionIds, string.format("<color=#FFFFFF>%d</color>/%d", #arg0.proxy.collectionIds, getProxy(PlayerProxy):getRawData():getConfig("max_markmail"))
		end
	})

	if arg1 == "collection" then
		arg0.filterMails = arg0.proxy:GetCollectionMails(var0)

		if arg0.collectionFilterStr then
			arg0.filterMails = underscore.filter(arg0.filterMails, function(arg0)
				return arg0:IsMatchKey(arg0.collectionFilterStr)
			end)
		end

		table.sort(arg0.filterMails, CompareFuncs({
			function(arg0)
				return (arg0.collectionSortToggle and 1 or -1) * arg0.id
			end
		}))
	elseif arg1 == "all" then
		arg0.filterMails = arg0.proxy:GetMails(var0)

		table.sort(arg0.filterMails, CompareFuncs({
			function(arg0)
				return -arg0.id
			end
		}))

		for iter0 = #var0 + 1, arg0.proxy.totalExist do
			table.insert(arg0.filterMails, {
				id = 0
			})
		end
	else
		arg0.filterMails = arg0.proxy:GetMails(var0)

		table.sort(arg0.filterMails, CompareFuncs({
			function(arg0)
				return -arg0.id
			end
		}))
	end

	if arg0.mailToggle == "all" and #arg0.proxy.ids < arg0.proxy.totalExist and #arg0.proxy.ids < SINGLE_MAIL_REQUIRE_SIZE then
		arg0.inRequire = true

		arg0:emit(MailMediator.ON_REQUIRE, "next", function()
			if arg0.mailToggle == "all" then
				arg0:UpdateMailList(arg0.mailToggle)
			end

			arg0.inRequire = nil
		end)
	elseif #arg0.filterMails == 0 then
		setActive(arg0.rtMailLeft, false)
		setActive(arg0.rtMailRight, false)
		setActive(arg0.rtMailEmpty, true)

		if arg0.mailToggle == "collection" then
			setText(arg0.rtMailEmpty:Find("Text"), i18n("emptymarkroom_tip_mailboxui"))
			setText(arg0.rtMailEmpty:Find("Text_en"), i18n("emptymarkroom_tip_mailboxui_en"))
		else
			setText(arg0.rtMailEmpty:Find("Text"), i18n("empty_tip_mailboxui"))
			setText(arg0.rtMailEmpty:Find("Text_en"), i18n("empty_tip_mailboxui_en"))
		end
	else
		setActive(arg0.rtMailLeft, true)
		setActive(arg0.rtMailRight, true)
		setActive(arg0.rtMailEmpty, false)

		if not arg0.selectMailId then
			arg0:UpdateMailContent(arg0.filterMails[1])
		end

		arg0.lsrMailList:SetTotalCount(#arg0.filterMails, arg2 or -1)
		setText(arg0.rtMailCount, var1)
		setActive(arg0.rtBtnLeftManager, arg0.mailToggle == "all")
		setActive(arg0.rtBtnLeftMoveAll, arg0.mailToggle == "important")
		setActive(arg0.rtBtnLeftDeleteCollection, arg0.mailToggle == "collection")
		setActive(arg0.rtBtnLeftDeleteAll, arg0.mailToggle == "all" or arg0.mailToggle == "rare")
		setActive(arg0.rtBtnLeftGetAll, arg0.mailToggle == "important" or arg0.mailToggle == "rare")
	end
end

function var0.UpdateMailTpl(arg0, arg1)
	local var0 = arg0.mailTplDic[arg1.id]

	if not var0 then
		return
	end

	local var1 = var0:Find("content")

	setActive(var1:Find("icon/no_attachment"), #arg1.attachments == 0)
	setActive(var1:Find("icon/IconTpl"), #arg1.attachments > 0)

	if #arg1.attachments > 0 then
		updateDrop(var1:Find("icon/IconTpl"), arg1.attachments[1])
	end

	setText(var1:Find("info/title/Text"), shortenString(arg1.title, 10))
	setActive(var1:Find("info/title/mark"), arg1.importantFlag and arg0.mailToggle ~= "collection")
	setText(var1:Find("info/time/Text"), os.date("%Y-%m-%d", arg1.date))
	setActive(var1:Find("info/time/out_time"), false)

	local var2 = #arg1.attachments > 0 and arg1.attachFlag

	setActive(var0:Find("got_mark"), arg0.mailToggle ~= "collection" and var2)
	setText(var0:Find("got_mark/got_text"), i18n("mail_reward_got"))
	triggerToggle(var0, arg0.selectMailId == arg1.id)

	local var3 = arg1.readFlag or arg0.mailToggle == "collection"

	setActive(var0:Find("hasread_bg"), var3)
	setActive(var0:Find("noread_bg"), not var3)

	local var4 = SummerFeastScene.TransformColor(var3 and "FFFFFF" or "181E32")

	setTextColor(var1:Find("info/title/Text"), var4)
	setTextColor(var1:Find("info/time/Text"), var4)
end

function var0.UpdateMailContent(arg0, arg1)
	eachChild(arg0.rtMailRight, function(arg0)
		setActive(arg0, tobool(arg1))
	end)

	if not arg1 then
		arg0.selectMailId = nil

		return
	end

	arg0.selectMailId = arg1.id

	changeToScrollText(arg0.rtMailRight:Find("main/title/info/Text"), i18n2(arg1.title))
	setText(arg0.rtMailRight:Find("main/from/Text"), arg1.sender)
	setText(arg0.rtMailRight:Find("main/time/Text"), os.date("%Y-%m-%d", arg1.date))
	setText(arg0.rtMailRight:Find("main/view/content/text/Text"), arg1.content)

	local var0 = arg0.rtMailRight:Find("main/title/matter")

	setActive(var0, arg0.mailToggle ~= "collection")

	if arg0.mailToggle ~= "collection" then
		onToggle(arg0, arg0.rtMailRight:Find("main/title/matter"), function(arg0)
			if arg0 ~= arg1.importantFlag then
				arg0:emit(MailMediator.ON_OPERATION, {
					cmd = arg0 and "important" or "unimportant",
					filter = {
						type = "ids",
						list = {
							arg1.id
						}
					}
				})
			end
		end, SFX_CONFIRM)
		triggerToggle(arg0.rtMailRight:Find("main/title/matter"), arg1.importantFlag)
	end

	local var1 = arg0.rtMailRight:Find("main/view/content/attachment")

	setText(var1:Find("got/Text"), i18n("main_mailLayer_attachTaken"))
	setActive(var1, #arg1.attachments > 0)

	if #arg1.attachments > 0 then
		local var2 = var1:Find("content")

		UIItemList.StaticAlign(var2, var2:Find("IconTpl"), #arg1.attachments, function(arg0, arg1, arg2)
			arg1 = arg1 + 1

			if arg0 == UIItemList.EventUpdate then
				local var0 = arg1.attachments[arg1]

				updateDrop(arg2, var0)
				onButton(arg0, arg2, function()
					arg0:emit(var0.ON_DROP, var0)
				end, SFX_PANEL)
			end
		end)

		local var3 = arg0.mailToggle == "collection" or arg1.attachFlag

		setCanvasGroupAlpha(var2, var3 and 0.5 or 1)
		setActive(var1:Find("got"), var3)
	end

	setActive(arg0.rtBtnRightMove, arg0.mailToggle ~= "collection")
	setActive(arg0.rtBtnRightGet, arg0.mailToggle ~= "collection" and not arg1.attachFlag)

	if arg0.mailToggle ~= "collection" and not arg1.readFlag then
		arg0:emit(MailMediator.ON_OPERATION, {
			cmd = "read",
			ignoreTips = true,
			filter = {
				type = "ids",
				list = {
					arg1.id
				}
			}
		})
	end
end

function var0.UpdateOperationDeal(arg0, arg1, arg2, arg3)
	if #arg2 == 0 then
		pg.TipsMgr.GetInstance():ShowTips(i18n("mail_manage_3"))
	elseif not arg3 then
		local var0 = switch(arg1, {
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

		if var0 then
			pg.TipsMgr.GetInstance():ShowTips(var0)
		end
	end

	local var1 = {}

	for iter0, iter1 in ipairs(arg2) do
		var1[iter1] = true
	end

	arg0:UpdateMailList(arg0.mailToggle)

	if var1[arg0.selectMailId] then
		arg0:UpdateMailContent(underscore.detect(arg0.filterMails, function(arg0)
			return arg0.id == arg0.selectMailId
		end))
	end
end

function var0.UpdateCollectionDelete(arg0, arg1)
	arg0:UpdateMailList(arg0.mailToggle)

	if arg0.selectMailId == arg1 then
		arg0:UpdateMailContent(nil)
	end
end

function var0.UpdateStore(arg0)
	arg0.withdrawal = {
		gold = 0,
		oil = 0
	}

	local var0 = getProxy(PlayerProxy):getRawData()
	local var1 = pg.mail_storeroom[var0.mailStoreLevel]

	setText(arg0.rtStore:Find("gold/Text/count"), string.format("%d/%d", var0:getResource(PlayerConst.ResStoreGold), var1.gold_store))

	local var2 = var0:IsStoreLevelMax()
	local var3 = arg0.rtStore:Find("bottom/btn_extend")

	SetActive(var3, not var2)
	onButton(arg0, var3, function()
		if var2 then
			pg.TipsMgr.GetInstance():ShowTips(i18n("mail_storeroom_noextend"))
		else
			arg0.storeUpgradeSubView:ExecuteAction("Show")
		end
	end, SFX_PANEL)

	local var4 = arg0.rtStore:Find("bottom/btn_get")

	onButton(arg0, var4, function()
		arg0:emit(MailMediator.ON_WITHDRAWAL, arg0.withdrawal)
	end, SFX_CONFIRM)

	local function var5()
		local var0 = arg0.withdrawal.oil ~= 0 or arg0.withdrawal.gold ~= 0

		setButtonEnabled(var4, var0)
		setGray(var4, not var0)
	end

	var5()

	for iter0, iter1 in pairs({
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
		local var6, var7, var8, var9, var10 = unpack(iter1)
		local var11 = pg.gameset[var10].key_value - var0:getResource(var7)
		local var12 = math.max(var11, 0)
		local var13 = var0:getResource(var8)

		setText(arg0.rtStore:Find(var6 .. "/tips"), i18n("mail_reward_tips"))
		setText(arg0.rtStore:Find(var6 .. "/Text/count"), string.format("<color=%s>%d</color>/%d", var9, var13, var1[var6 .. "_store"]))

		local var14 = arg0.rtStore:Find(var6 .. "/calc")
		local var15 = var14:Find("count/count")

		setText(var15:Find("tip"), i18n("mail_storeroom_resourcetaken"))
		setInputText(var15, arg0.withdrawal[var6])
		onInputEndEdit(arg0, var15, function()
			local var0 = getInputText(var15)

			if var0 == "" or var0 == nil then
				var0 = 0
			end

			local var1 = math.clamp(tonumber(var0), 0, var13)

			if var1 >= var12 then
				var1 = var12

				pg.TipsMgr.GetInstance():ShowTips(i18n("resource_max_tip_storeroom"))
			end

			if arg0.withdrawal[var6] ~= var1 then
				arg0.withdrawal[var6] = var1

				var5()
			end

			setInputText(var15, arg0.withdrawal[var6])
		end)
		pressPersistTrigger(var14:Find("count/left"), 0.5, function(arg0)
			if arg0.withdrawal[var6] == 0 then
				arg0()

				return
			end

			arg0.withdrawal[var6] = math.max(arg0.withdrawal[var6] - 100, 0)

			setInputText(var15, arg0.withdrawal[var6])

			if arg0.withdrawal[var6] == 0 then
				var5()
			end
		end, nil, true, true, 0.15, SFX_PANEL)
		pressPersistTrigger(var14:Find("count/right"), 0.5, function(arg0)
			if arg0.withdrawal[var6] >= var12 then
				pg.TipsMgr.GetInstance():ShowTips(i18n("resource_max_tip_storeroom"))
				arg0()

				return
			end

			if arg0.withdrawal[var6] == var13 then
				return
			end

			local var0 = arg0.withdrawal[var6]

			arg0.withdrawal[var6] = math.min(arg0.withdrawal[var6] + 100, var13)

			if arg0.withdrawal[var6] >= var12 then
				arg0.withdrawal[var6] = var12

				pg.TipsMgr.GetInstance():ShowTips(i18n("resource_max_tip_storeroom"))
			end

			setInputText(var15, arg0.withdrawal[var6])

			if var0 == 0 then
				var5()
			end
		end, nil, true, true, 0.15, SFX_PANEL)
		onButton(arg0, var14:Find("max"), function()
			arg0.withdrawal[var6] = getProxy(PlayerProxy):getRawData():ResLack(var6, var13)

			if arg0.withdrawal[var6] >= var12 then
				arg0.withdrawal[var6] = var12

				pg.TipsMgr.GetInstance():ShowTips(i18n("resource_max_tip_storeroom"))
			end

			setInputText(var15, arg0.withdrawal[var6])
			var5()
		end, SFX_PANEL)
	end
end

function var0.onBackPressed(arg0)
	if arg0.mailMgrSubView:isShowing() then
		arg0.mailMgrSubView:Hide()
	elseif arg0.storeUpgradeSubView:isShowing() then
		arg0.storeUpgradeSubView:Hide()
	elseif arg0.mailConfirmationSubView:isShowing() then
		arg0.mailConfirmationSubView:Hide()
	elseif arg0.mailOverflowWindowSubView:isShowing() then
		arg0.mailOverflowWindowSubView:Hide()
	else
		triggerButton(arg0.rtAdapt:Find("top/back_btn"))
	end
end

function var0.willExit(arg0)
	arg0.mailMgrSubView:Destroy()
	arg0.storeUpgradeSubView:Destroy()
	arg0.mailConfirmationSubView:Destroy()
	arg0.mailOverflowWindowSubView:Destroy()
end

function var0.ShowDoubleConfiremationMsgBox(arg0, arg1)
	if arg1.type == MailProxy.MailMessageBoxType.OverflowConfirm then
		arg0.mailOverflowWindowSubView:ExecuteAction("Show", arg1)
	else
		arg0.mailConfirmationSubView:ExecuteAction("Show", arg1)
	end
end

function var0.InitResBar(arg0)
	arg0.resBar = arg0._tf:Find("adapt/top/res")
	arg0.goldMax = arg0.resBar:Find("gold/max"):GetComponent(typeof(Text))
	arg0.goldValue = arg0.resBar:Find("gold/Text"):GetComponent(typeof(Text))
	arg0.oilMax = arg0.resBar:Find("oil/max"):GetComponent(typeof(Text))
	arg0.oilValue = arg0.resBar:Find("oil/Text"):GetComponent(typeof(Text))
	arg0.gemValue = arg0.resBar:Find("gem/Text"):GetComponent(typeof(Text))

	onButton(arg0, arg0.resBar:Find("gold"), function()
		pg.playerResUI:ClickGold()
	end, SFX_PANEL)
	onButton(arg0, arg0.resBar:Find("oil"), function()
		pg.playerResUI:ClickOil()
	end, SFX_PANEL)
	onButton(arg0, arg0.resBar:Find("gem"), function()
		pg.playerResUI:ClickGem()
	end, SFX_PANEL)
	arg0:UpdateRes()
end

function var0.UpdateRes(arg0)
	local var0 = getProxy(PlayerProxy):getRawData()

	PlayerResUI.StaticFlush(var0, arg0.goldMax, arg0.goldValue, arg0.oilMax, arg0.oilValue, arg0.gemValue)
end

return var0
