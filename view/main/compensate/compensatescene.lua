local var0_0 = class("CompensateScene", import("view.base.BaseUI"))

function var0_0.getUIName(arg0_1)
	return "CompensateUI"
end

function var0_0.ResUISettings(arg0_2)
	return false
end

var0_0.optionsPath = {
	"adapt/top/option"
}

function var0_0.quickExitFunc(arg0_3)
	arg0_3:emit(var0_0.ON_HOME)
end

function var0_0.init(arg0_4)
	arg0_4.proxy = getProxy(CompensateProxy)
	arg0_4.rtAdapt = arg0_4._tf:Find("adapt")

	setText(arg0_4.rtAdapt:Find("top/title"), i18n("compensate_ui_title1"))
	setText(arg0_4.rtAdapt:Find("top/title/Text"), i18n("compensate_ui_title2"))
	onButton(arg0_4, arg0_4.rtAdapt:Find("top/back_btn"), function()
		arg0_4:closeView()
	end, SFX_CANCEL)

	arg0_4.rtLabels = arg0_4.rtAdapt:Find("left_length/frame/tagRoot")

	eachChild(arg0_4.rtLabels, function(arg0_6)
		local var0_6

		if arg0_6.name == "mail" then
			toggleName = i18n("compensate_ui_title1")
		end

		setText(arg0_6:Find("unSelect/Text"), toggleName)
		setText(arg0_6:Find("selected/Text"), toggleName)
		onToggle(arg0_4, arg0_6, function(arg0_7)
			if arg0_7 then
				arg0_4:SetPage()
			end
		end, SFX_PANEL)
	end)

	local var0_4 = arg0_4.rtAdapt:Find("main/content")

	arg0_4.rtMailLeft = var0_4:Find("left/left_content")
	arg0_4.lsrMailList = arg0_4.rtMailLeft:Find("middle/container"):GetComponent("LScrollRect")

	function arg0_4.lsrMailList.onUpdateItem(arg0_8, arg1_8)
		arg0_8 = arg0_8 + 1

		local var0_8 = tf(arg1_8)
		local var1_8 = arg0_4.filterMails[arg0_8]

		onToggle(arg0_4, var0_8, function(arg0_9)
			if arg0_9 then
				if arg0_4.selectMailId ~= var1_8.id then
					arg0_4:UpdateMailContent(var1_8)
				end
			elseif var1_8.id == arg0_4.selectMailId then
				arg0_4:UpdateMailContent(nil)
			end
		end, SFX_PANEL)
		arg0_4:UpdateMailTpl(var0_8, var1_8)
	end

	arg0_4.rtMailRight = var0_4:Find("right")
	arg0_4.rtBtnRightGet = arg0_4.rtMailRight:Find("bottom/btn_get")

	onButton(arg0_4, arg0_4.rtBtnRightGet, function()
		assert(arg0_4.selectMailId)
		arg0_4:emit(CompensateMediator.ON_GET_REWARD, {
			reward_id = arg0_4.selectMailId
		})
	end, SFX_PANEL)

	arg0_4.rtMailEmpty = var0_4:Find("empty")

	setText(arg0_4.rtBtnRightGet:Find("Text"), i18n("mail_getone_button"))
	arg0_4:InitResBar()
end

function var0_0.SetPage(arg0_11)
	arg0_11:UpdateMailList()
end

function var0_0.didEnter(arg0_12)
	onNextTick(function()
		arg0_12.lsrMailList.enabled = true

		triggerToggle(arg0_12.rtLabels:Find("mail"), true)
	end)
end

function var0_0.UpdateMailList(arg0_14)
	arg0_14.filterMails = arg0_14.proxy:GetAllRewardList()

	table.sort(arg0_14.filterMails, CompareFuncs({
		function(arg0_15)
			return -arg0_15.date
		end,
		function(arg0_16)
			return -arg0_16.id
		end
	}))

	if #arg0_14.filterMails == 0 then
		setActive(arg0_14.rtMailLeft, false)
		setActive(arg0_14.rtMailRight, false)
		setActive(arg0_14.rtMailEmpty, true)
		setText(arg0_14.rtMailEmpty:Find("Text"), i18n("compensate_ui_nothing1"))
		setText(arg0_14.rtMailEmpty:Find("Text_en"), i18n("compensate_ui_nothing2"))
	else
		setActive(arg0_14.rtMailLeft, true)
		setActive(arg0_14.rtMailRight, true)
		setActive(arg0_14.rtMailEmpty, false)

		if not arg0_14.selectMailId then
			arg0_14:UpdateMailContent(arg0_14.filterMails[1])
		end

		arg0_14.lsrMailList:SetTotalCount(#arg0_14.filterMails, delta or -1)
	end
end

function var0_0.UpdateMailTpl(arg0_17, arg1_17, arg2_17)
	local var0_17 = arg1_17:Find("content")

	setActive(var0_17:Find("icon/no_attachment"), #arg2_17.attachments == 0)
	setActive(var0_17:Find("icon/IconTpl"), #arg2_17.attachments > 0)

	if #arg2_17.attachments > 0 then
		updateDrop(var0_17:Find("icon/IconTpl"), arg2_17.attachments[1])
	end

	setText(var0_17:Find("info/title/Text"), shortenString(arg2_17.title, 10))
	setText(var0_17:Find("info/time/Text"), os.date("%Y-%m-%d", arg2_17.date))

	local var1_17 = arg2_17.timestamp - pg.TimeMgr.GetInstance():GetServerTime()

	if math.floor(var1_17 / 86400) >= 1 then
		setText(var0_17:Find("info/time/out_time/Text"), i18n("compensate_ui_expiration_day", math.floor(var1_17 / 86400)))
	else
		setText(var0_17:Find("info/time/out_time/Text"), i18n("compensate_ui_expiration_hour", math.floor(var1_17 / 3600)))
	end

	local var2_17 = arg2_17.attachFlag

	setActive(arg1_17:Find("got_mark"), var2_17)
	setText(arg1_17:Find("got_mark/got_text"), i18n("mail_reward_got"))
	setActive(arg1_17:Find("hasread_bg"), true)
	setActive(arg1_17:Find("noread_bg"), false)

	local var3_17 = SummerFeastScene.TransformColor("FFFFFF")

	setTextColor(var0_17:Find("info/title/Text"), var3_17)
	setTextColor(var0_17:Find("info/time/Text"), var3_17)
	triggerToggle(arg1_17, arg0_17.selectMailId == arg2_17.id)
end

function var0_0.UpdateMailContent(arg0_18, arg1_18)
	eachChild(arg0_18.rtMailRight, function(arg0_19)
		setActive(arg0_19, tobool(arg1_18))
	end)

	if not arg1_18 then
		arg0_18.selectMailId = nil

		return
	end

	arg0_18.selectMailId = arg1_18.id

	changeToScrollText(arg0_18.rtMailRight:Find("main/title/info/Text"), i18n2(arg1_18.title))
	setText(arg0_18.rtMailRight:Find("main/from/Text"), arg1_18.sender)
	setText(arg0_18.rtMailRight:Find("main/time/Text"), os.date("%Y-%m-%d", arg1_18.date))
	setText(arg0_18.rtMailRight:Find("main/view/content/text/Text"), arg1_18.text)

	local var0_18 = arg0_18.rtMailRight:Find("main/view/content/attachment")

	setText(var0_18:Find("got/Text"), i18n("main_mailLayer_attachTaken"))
	setActive(arg0_18.rtBtnRightGet, not arg1_18.attachFlag)
	setActive(var0_18, #arg1_18.attachments > 0)

	if #arg1_18.attachments > 0 then
		local var1_18 = var0_18:Find("content")

		UIItemList.StaticAlign(var1_18, var1_18:Find("IconTpl"), #arg1_18.attachments, function(arg0_20, arg1_20, arg2_20)
			arg1_20 = arg1_20 + 1

			if arg0_20 == UIItemList.EventUpdate then
				local var0_20 = arg1_18.attachments[arg1_20]

				updateDrop(arg2_20, var0_20)
				onButton(arg0_18, arg2_20, function()
					arg0_18:emit(var0_0.ON_DROP, var0_20)
				end, SFX_PANEL)
			end
		end)

		local var2_18 = arg1_18.attachFlag

		setCanvasGroupAlpha(var1_18, var2_18 and 0.5 or 1)
		setActive(var0_18:Find("got"), var2_18)
	end
end

function var0_0.onBackPressed(arg0_22)
	triggerButton(arg0_22.rtAdapt:Find("top/back_btn"))
end

function var0_0.willExit(arg0_23)
	return
end

function var0_0.UpdateOperationDeal(arg0_24)
	arg0_24:UpdateMailList()

	if arg0_24.selectMailId then
		arg0_24:UpdateMailContent(underscore.detect(arg0_24.filterMails, function(arg0_25)
			return arg0_25.id == arg0_24.selectMailId
		end))
	end
end

function var0_0.InitResBar(arg0_26)
	arg0_26.resBar = arg0_26._tf:Find("adapt/top/res")
	arg0_26.goldMax = arg0_26.resBar:Find("gold/max"):GetComponent(typeof(Text))
	arg0_26.goldValue = arg0_26.resBar:Find("gold/Text"):GetComponent(typeof(Text))
	arg0_26.oilMax = arg0_26.resBar:Find("oil/max"):GetComponent(typeof(Text))
	arg0_26.oilValue = arg0_26.resBar:Find("oil/Text"):GetComponent(typeof(Text))
	arg0_26.gemValue = arg0_26.resBar:Find("gem/Text"):GetComponent(typeof(Text))

	onButton(arg0_26, arg0_26.resBar:Find("gold"), function()
		pg.playerResUI:ClickGold()
	end, SFX_PANEL)
	onButton(arg0_26, arg0_26.resBar:Find("oil"), function()
		pg.playerResUI:ClickOil()
	end, SFX_PANEL)
	onButton(arg0_26, arg0_26.resBar:Find("gem"), function()
		pg.playerResUI:ClickGem()
	end, SFX_PANEL)
	arg0_26:UpdateRes()
end

function var0_0.UpdateRes(arg0_30)
	local var0_30 = getProxy(PlayerProxy):getRawData()

	PlayerResUI.StaticFlush(var0_30, arg0_30.goldMax, arg0_30.goldValue, arg0_30.oilMax, arg0_30.oilValue, arg0_30.gemValue)
end

return var0_0
