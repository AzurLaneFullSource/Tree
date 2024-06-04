local var0 = class("ShipEvaluationLayer", import("..base.BaseUI"))

var0.EVENT_LIKE = "event like"
var0.EVENT_EVA = "event eva"
var0.EVENT_ZAN = "event zan"
var0.EVENT_IMPEACH = "event impeach"

function var0.getUIName(arg0)
	return "EvaluationUI"
end

function var0.init(arg0)
	arg0.mainPanel = arg0:findTF("mainPanel")
	arg0.head = arg0:findTF("bg/left_panel/ship_tpl", arg0.mainPanel)
	arg0.labelHeart = arg0:findTF("bg/left_panel/evaluation_count/heart", arg0.mainPanel)
	arg0.labelEva = arg0:findTF("bg/left_panel/evaluation_count/count", arg0.mainPanel)
	arg0.btnLike = arg0:findTF("bg/left_panel/btnLike", arg0.mainPanel)
	arg0.btnEva = arg0:findTF("bg/bottom_panel/send_btn", arg0.mainPanel)
	arg0.input = arg0:findTF("bg/bottom_panel/Input", arg0.mainPanel)
	arg0.inputText = arg0:findTF("Text", arg0.input)
	arg0.list = arg0:findTF("bg/right_panel/list", arg0.mainPanel)
	arg0.hotContent = arg0:findTF("content/hots", arg0.list)
	arg0.commonContent = arg0:findTF("content/commons", arg0.list)
	arg0.hotTpl = arg0:findTF("content/hot_tpl", arg0.list)
	arg0.commonTpl = arg0:findTF("content/commom_tpl", arg0.list)
	arg0.iconType = findTF(arg0.head, "content/main_bg/type_mask/type_icon"):GetComponent(typeof(Image))
	arg0.imageBg = findTF(arg0.head, "content/icon_bg"):GetComponent(typeof(Image))
	arg0.imageFrame = findTF(arg0.head, "content/main_bg/frame")
	arg0.iconShip = findTF(arg0.head, "content/icon"):GetComponent(typeof(Image))
	arg0.labelName = findTF(arg0.head, "content/main_bg/name_mask/name"):GetComponent(typeof(Text))
	arg0.scrollText = findTF(arg0.head, "content/main_bg/name_mask/name"):GetComponent(typeof(ScrollText))
	arg0.stars = findTF(arg0.head, "content/main_bg/stars")
	arg0.star = findTF(arg0.stars, "tpl")
	arg0.bg = arg0:findTF("BG")
	arg0.btnHelp = arg0._tf:Find("mainPanel/bg/top_panel/title/help")

	setActive(arg0.btnHelp, getProxy(PlayerProxy):getRawData():IsOpenShipEvaluationImpeach())
	arg0:initImpeachPanel()
	setActive(arg0.mainPanel, true)
	setActive(arg0.impackPanel, false)
	pg.UIMgr.GetInstance():BlurPanel(arg0._tf, false, {
		groupName = arg0:getGroupNameFromData(),
		weight = arg0:getWeightFromData()
	})
end

function var0.onBackPressed(arg0)
	if isActive(arg0.impackPanel) then
		setActive(arg0.mainPanel, true)
		setActive(arg0.impackPanel, false)
	else
		arg0:closeView()
	end
end

function var0.didEnter(arg0)
	onButton(arg0, arg0.bg, function()
		arg0:onBackPressed()
	end, SFX_CANCEL)
	onButton(arg0, arg0:findTF("mainPanel/bg/top_panel/btnBack"), function()
		arg0:onBackPressed()
	end, SFX_CANCEL)
	onButton(arg0, arg0.btnHelp, function()
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_HELP,
			helps = i18n("report_sent_help"),
			weight = arg0:getWeightFromData()
		})
	end, SFX_PANEL)
	onButton(arg0, arg0.btnLike, function()
		arg0:emit(var0.EVENT_LIKE)
	end, SFX_PANEL)
	onButton(arg0, arg0.btnEva, function()
		local var0 = getInputText(arg0.input)

		if string.len(var0) > 0 then
			setInputText(arg0.input, "")
			arg0:emit(var0.EVENT_EVA, var0)
		else
			pg.TipsMgr.GetInstance():ShowTips(i18n("eva_comment_send_null"))
		end
	end, SFX_PANEL)
	onInputChanged(arg0, arg0.input, function()
		local var0 = getInputText(arg0.input)
		local var1
		local var2

		if string.len(var0) > 0 then
			if arg0.shipGroup.evaluation.ievaCount >= CollectionProxy.MAX_DAILY_EVA_COUNT then
				var1 = true
				var2 = i18n("eva_count_limit")
			elseif wordVer(var0) > 0 then
				var1 = true
				var2 = i18n("invalidate_evaluation")
			end
		end

		if var1 then
			setTextColor(arg0.inputText, Color.red)
			setButtonEnabled(arg0.btnEva, false)
			pg.TipsMgr.GetInstance():ShowTips(var2)
		else
			setTextColor(arg0.inputText, Color.white)
			setButtonEnabled(arg0.btnEva, true)
		end
	end)
end

function var0.setShipGroup(arg0, arg1)
	arg0.shipGroup = arg1
end

function var0.setShowTrans(arg0, arg1)
	arg0.showTrans = arg1
end

function var0.flushAll(arg0)
	arg0:flushShip()
	arg0:flushHeart()
	arg0:flushEva()
end

function var0.flushShip(arg0)
	local var0 = arg0.shipGroup.shipConfig
	local var1 = arg0.shipGroup:getPainting(arg0.showTrans)
	local var2 = arg0.shipGroup:rarity2bgPrint(arg0.showTrans)

	setShipCardFrame(arg0.imageFrame, var2, nil)
	GetImageSpriteFromAtlasAsync("bg/star_level_card_" .. var2, "", arg0.imageBg)

	arg0.iconShip.sprite = GetSpriteFromAtlas("shipYardIcon/unknown", "")

	LoadImageSpriteAsync("shipYardIcon/" .. var1, arg0.iconShip)

	arg0.labelName.text = arg0.shipGroup:getName(arg0.showTrans)

	if arg0.scrollText then
		arg0.scrollText:SetText(arg0.shipGroup:getName(arg0.showTrans))
	end

	local var3 = GetSpriteFromAtlas("shiptype", shipType2print(arg0.shipGroup:getShipType(arg0.showTrans)))

	if not var3 then
		warning("找不到船形, shipConfigId: " .. var0.id)
	end

	arg0.iconType.sprite = var3

	local var4 = pg.ship_data_template[var0.id].star_max

	for iter0 = arg0.stars.childCount, var4 - 1 do
		local var5 = cloneTplTo(arg0.star, arg0.stars)
	end
end

function var0.flushHeart(arg0)
	setButtonEnabled(arg0.btnLike, not arg0.shipGroup.iheart)
	setText(arg0.labelHeart, arg0.shipGroup.evaluation.hearts)
end

function var0.flushEva(arg0)
	local var0 = arg0.shipGroup.evaluation

	setText(arg0.labelEva, var0.evaCount)

	local var1 = var0.evas

	for iter0 = 1, arg0.hotContent.childCount do
		local var2 = go(arg0.hotContent:GetChild(iter0 - 1))

		if var2.name ~= "tag" then
			Destroy(var2)
		end
	end

	for iter1 = 1, arg0.commonContent.childCount do
		local var3 = go(arg0.commonContent:GetChild(iter1 - 1))

		if var3.name ~= "tag" then
			Destroy(var3)
		end
	end

	local var4 = getProxy(PlayerProxy):getRawData():IsOpenShipEvaluationImpeach()

	for iter2 = 1, #var1 do
		local var5
		local var6 = var1[iter2]

		if var6.hot then
			var5 = cloneTplTo(arg0.hotTpl, arg0.hotContent)
		else
			var5 = cloneTplTo(arg0.commonTpl, arg0.commonContent)
		end

		local var7 = arg0:findTF("bg/evaluation", var5):GetComponent(typeof(Text))
		local var8 = arg0:findTF("bg/name", var5)
		local var9 = arg0:findTF("bg/zan_bg/Text", var5)

		setText(var8, var6.nick_name .. ":")
		setText(var9, var6.good_count - var6.bad_count)

		var7.supportRichText = false
		var7.text = var6.context

		local function var10(arg0)
			if not var6.izan then
				arg0:emit(var0.EVENT_ZAN, var6.id, arg0)
			else
				pg.TipsMgr.GetInstance():ShowTips(i18n("zan_ship_eva_error_7"))
			end
		end

		onButton(arg0, var5:Find("bg/zan_bg/up"), function()
			var10(0)
		end, SFX_PANEL)
		onButton(arg0, var5:Find("bg/zan_bg/down"), function()
			var10(1)
		end, SFX_PANEL)
		onButton(arg0, var5:Find("bg/zan_bg/impeach"), function()
			arg0:openImpeachPanel(var6.id)
		end, SFX_PANEL)
		SetActive(var5:Find("bg/zan_bg/down"), not defaultValue(LOCK_DOWNVOTE, true))
		setActive(var5:Find("bg/zan_bg/impeach"), var4)
	end

	local var11 = 1

	for iter3 = 1, arg0.hotContent.childCount do
		local var12 = arg0.hotContent:GetChild(iter3 - 1)

		if go(var12).name ~= "tag" then
			setActive(var12:Find("print1"), var11 % 2 ~= 0)
			setActive(var12:Find("print2"), var11 % 2 == 0)

			var11 = var11 + 1
		end
	end

	setActive(arg0.hotContent:Find("tag"), arg0.hotContent.childCount > 1)
	setActive(arg0.commonContent:Find("tag"), arg0.commonContent.childCount > 1)
	arg0.hotContent:Find("tag"):SetAsLastSibling()
	arg0.commonContent:Find("tag"):SetAsLastSibling()
end

local var1 = 3

function var0.initImpeachPanel(arg0)
	arg0.impackPanel = arg0._tf:Find("impeachPanel")

	setText(arg0.impackPanel:Find("window/top/bg/impeach/title"), i18n("report_sent_title"))
	onButton(arg0, arg0.impackPanel:Find("window/top/btnBack"), function()
		arg0:onBackPressed()
	end, SFX_CANCEL)

	local var0 = arg0.impackPanel:Find("window/msg_panel/content")

	setText(var0:Find("title"), i18n("report_sent_desc"))

	local var1 = UIItemList.New(var0:Find("options"), var0:Find("options/tpl"))

	var1:make(function(arg0, arg1, arg2)
		arg1 = arg1 + 1

		if arg0 == UIItemList.EventUpdate then
			setText(arg2:Find("Text"), i18n("report_type_" .. arg1))
			setText(arg2:Find("Text_2"), i18n("report_type_" .. arg1 .. "_1"))
			onToggle(arg0, arg2, function(arg0)
				arg0.impeachOption = arg1
			end)
		end
	end)
	var1:align(var1)
	setText(var0:Find("other/field/Text"), i18n("report_type_other"))
	setText(var0:Find("other/field/input/Placeholder"), i18n("report_type_other_1"))
	onToggle(arg0, var0:Find("other"), function(arg0)
		arg0.impeachOption = "other"

		setActive(var0:Find("other/field/input"), arg0)
	end)

	local var2 = var0:Find("other/field/input")

	onInputChanged(arg0, var2, function()
		Canvas.ForceUpdateCanvases()
	end)
	onButton(arg0, arg0.impackPanel:Find("window/button_container/button"), function()
		if arg0.impeachOption == "other" then
			local var0 = getInputText(var2)

			if string.len(var0) > 0 then
				arg0:emit(var0.EVENT_IMPEACH, arg0.targetEvaId, i18n("report_type_other") .. ":" .. var0)
			else
				pg.TipsMgr.GetInstance():ShowTips(i18n("report_type_other_2"))

				return
			end
		else
			arg0:emit(var0.EVENT_IMPEACH, arg0.targetEvaId, i18n("report_type_" .. arg0.impeachOption))
		end

		arg0:onBackPressed()
	end, SFX_CONFIRM)
end

function var0.openImpeachPanel(arg0, arg1)
	arg0.targetEvaId = arg1

	setActive(arg0.mainPanel, false)
	setActive(arg0.impackPanel, true)
	triggerToggle(arg0.impackPanel:Find("window/msg_panel/content/other"), true)
	triggerToggle(arg0.impackPanel:Find("window/msg_panel/content/options/tpl"), true)
end

function var0.willExit(arg0)
	pg.UIMgr.GetInstance():UnblurPanel(arg0._tf)
end

return var0
