local var0_0 = class("ShipEvaluationLayer", import("..base.BaseUI"))

var0_0.EVENT_LIKE = "event like"
var0_0.EVENT_EVA = "event eva"
var0_0.EVENT_ZAN = "event zan"
var0_0.EVENT_IMPEACH = "event impeach"

function var0_0.getUIName(arg0_1)
	return "EvaluationUI"
end

function var0_0.init(arg0_2)
	arg0_2.mainPanel = arg0_2:findTF("mainPanel")
	arg0_2.head = arg0_2:findTF("bg/left_panel/ship_tpl", arg0_2.mainPanel)
	arg0_2.labelHeart = arg0_2:findTF("bg/left_panel/evaluation_count/heart", arg0_2.mainPanel)
	arg0_2.labelEva = arg0_2:findTF("bg/left_panel/evaluation_count/count", arg0_2.mainPanel)
	arg0_2.btnLike = arg0_2:findTF("bg/left_panel/btnLike", arg0_2.mainPanel)
	arg0_2.btnEva = arg0_2:findTF("bg/bottom_panel/send_btn", arg0_2.mainPanel)
	arg0_2.input = arg0_2:findTF("bg/bottom_panel/Input", arg0_2.mainPanel)
	arg0_2.inputText = arg0_2:findTF("Text", arg0_2.input)
	arg0_2.list = arg0_2:findTF("bg/right_panel/list", arg0_2.mainPanel)
	arg0_2.hotContent = arg0_2:findTF("content/hots", arg0_2.list)
	arg0_2.commonContent = arg0_2:findTF("content/commons", arg0_2.list)
	arg0_2.hotTpl = arg0_2:findTF("content/hot_tpl", arg0_2.list)
	arg0_2.commonTpl = arg0_2:findTF("content/commom_tpl", arg0_2.list)
	arg0_2.iconType = findTF(arg0_2.head, "content/main_bg/type_mask/type_icon"):GetComponent(typeof(Image))
	arg0_2.imageBg = findTF(arg0_2.head, "content/icon_bg"):GetComponent(typeof(Image))
	arg0_2.imageFrame = findTF(arg0_2.head, "content/main_bg/frame")
	arg0_2.iconShip = findTF(arg0_2.head, "content/icon"):GetComponent(typeof(Image))
	arg0_2.labelName = findTF(arg0_2.head, "content/main_bg/name_mask/name"):GetComponent(typeof(Text))
	arg0_2.scrollText = findTF(arg0_2.head, "content/main_bg/name_mask/name"):GetComponent(typeof(ScrollText))
	arg0_2.stars = findTF(arg0_2.head, "content/main_bg/stars")
	arg0_2.star = findTF(arg0_2.stars, "tpl")
	arg0_2.bg = arg0_2:findTF("BG")
	arg0_2.btnHelp = arg0_2._tf:Find("mainPanel/bg/top_panel/title/help")

	setActive(arg0_2.btnHelp, getProxy(PlayerProxy):getRawData():IsOpenShipEvaluationImpeach())
	arg0_2:initImpeachPanel()
	setActive(arg0_2.mainPanel, true)
	setActive(arg0_2.impackPanel, false)
	pg.UIMgr.GetInstance():BlurPanel(arg0_2._tf, false, {
		groupName = arg0_2:getGroupNameFromData(),
		weight = arg0_2:getWeightFromData()
	})
end

function var0_0.onBackPressed(arg0_3)
	if isActive(arg0_3.impackPanel) then
		setActive(arg0_3.mainPanel, true)
		setActive(arg0_3.impackPanel, false)
	else
		arg0_3:closeView()
	end
end

function var0_0.didEnter(arg0_4)
	onButton(arg0_4, arg0_4.bg, function()
		arg0_4:onBackPressed()
	end, SFX_CANCEL)
	onButton(arg0_4, arg0_4:findTF("mainPanel/bg/top_panel/btnBack"), function()
		arg0_4:onBackPressed()
	end, SFX_CANCEL)
	onButton(arg0_4, arg0_4.btnHelp, function()
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_HELP,
			helps = i18n("report_sent_help"),
			weight = arg0_4:getWeightFromData()
		})
	end, SFX_PANEL)
	onButton(arg0_4, arg0_4.btnLike, function()
		arg0_4:emit(var0_0.EVENT_LIKE)
	end, SFX_PANEL)
	onButton(arg0_4, arg0_4.btnEva, function()
		local var0_9 = getInputText(arg0_4.input)

		if string.len(var0_9) > 0 then
			setInputText(arg0_4.input, "")
			arg0_4:emit(var0_0.EVENT_EVA, var0_9)
		else
			pg.TipsMgr.GetInstance():ShowTips(i18n("eva_comment_send_null"))
		end
	end, SFX_PANEL)
	onInputChanged(arg0_4, arg0_4.input, function()
		local var0_10 = getInputText(arg0_4.input)
		local var1_10
		local var2_10

		if string.len(var0_10) > 0 then
			if arg0_4.shipGroup.evaluation.ievaCount >= CollectionProxy.MAX_DAILY_EVA_COUNT then
				var1_10 = true
				var2_10 = i18n("eva_count_limit")
			elseif wordVer(var0_10) > 0 then
				var1_10 = true
				var2_10 = i18n("invalidate_evaluation")
			end
		end

		if var1_10 then
			setTextColor(arg0_4.inputText, Color.red)
			setButtonEnabled(arg0_4.btnEva, false)
			pg.TipsMgr.GetInstance():ShowTips(var2_10)
		else
			setTextColor(arg0_4.inputText, Color.white)
			setButtonEnabled(arg0_4.btnEva, true)
		end
	end)
end

function var0_0.setShipGroup(arg0_11, arg1_11)
	arg0_11.shipGroup = arg1_11
end

function var0_0.setShowTrans(arg0_12, arg1_12)
	arg0_12.showTrans = arg1_12
end

function var0_0.flushAll(arg0_13)
	arg0_13:flushShip()
	arg0_13:flushHeart()
	arg0_13:flushEva()
end

function var0_0.flushShip(arg0_14)
	local var0_14 = arg0_14.shipGroup.shipConfig
	local var1_14 = arg0_14.shipGroup:getPainting(arg0_14.showTrans)
	local var2_14 = arg0_14.shipGroup:rarity2bgPrint(arg0_14.showTrans)

	setShipCardFrame(arg0_14.imageFrame, var2_14, nil)
	GetImageSpriteFromAtlasAsync("bg/star_level_card_" .. var2_14, "", arg0_14.imageBg)

	arg0_14.iconShip.sprite = GetSpriteFromAtlas("shipYardIcon/unknown", "")

	LoadImageSpriteAsync("shipYardIcon/" .. var1_14, arg0_14.iconShip)

	arg0_14.labelName.text = arg0_14.shipGroup:getName(arg0_14.showTrans)

	if arg0_14.scrollText then
		arg0_14.scrollText:SetText(arg0_14.shipGroup:getName(arg0_14.showTrans))
	end

	local var3_14 = GetSpriteFromAtlas("shiptype", shipType2print(arg0_14.shipGroup:getShipType(arg0_14.showTrans)))

	if not var3_14 then
		warning("找不到船形, shipConfigId: " .. var0_14.id)
	end

	arg0_14.iconType.sprite = var3_14

	local var4_14 = pg.ship_data_template[var0_14.id].star_max

	for iter0_14 = arg0_14.stars.childCount, var4_14 - 1 do
		local var5_14 = cloneTplTo(arg0_14.star, arg0_14.stars)
	end
end

function var0_0.flushHeart(arg0_15)
	setButtonEnabled(arg0_15.btnLike, not arg0_15.shipGroup.iheart)
	setText(arg0_15.labelHeart, arg0_15.shipGroup.evaluation.hearts)
end

function var0_0.flushEva(arg0_16)
	local var0_16 = arg0_16.shipGroup.evaluation

	setText(arg0_16.labelEva, var0_16.evaCount)

	local var1_16 = var0_16.evas

	for iter0_16 = 1, arg0_16.hotContent.childCount do
		local var2_16 = go(arg0_16.hotContent:GetChild(iter0_16 - 1))

		if var2_16.name ~= "tag" then
			Destroy(var2_16)
		end
	end

	for iter1_16 = 1, arg0_16.commonContent.childCount do
		local var3_16 = go(arg0_16.commonContent:GetChild(iter1_16 - 1))

		if var3_16.name ~= "tag" then
			Destroy(var3_16)
		end
	end

	local var4_16 = getProxy(PlayerProxy):getRawData():IsOpenShipEvaluationImpeach()

	for iter2_16 = 1, #var1_16 do
		local var5_16
		local var6_16 = var1_16[iter2_16]

		if var6_16.hot then
			var5_16 = cloneTplTo(arg0_16.hotTpl, arg0_16.hotContent)
		else
			var5_16 = cloneTplTo(arg0_16.commonTpl, arg0_16.commonContent)
		end

		local var7_16 = arg0_16:findTF("bg/evaluation", var5_16):GetComponent(typeof(Text))
		local var8_16 = arg0_16:findTF("bg/name", var5_16)
		local var9_16 = arg0_16:findTF("bg/zan_bg/Text", var5_16)

		setText(var8_16, var6_16.nick_name .. ":")
		setText(var9_16, var6_16.good_count - var6_16.bad_count)

		var7_16.supportRichText = false
		var7_16.text = var6_16.context

		local function var10_16(arg0_17)
			if not var6_16.izan then
				arg0_16:emit(var0_0.EVENT_ZAN, var6_16.id, arg0_17)
			else
				pg.TipsMgr.GetInstance():ShowTips(i18n("zan_ship_eva_error_7"))
			end
		end

		onButton(arg0_16, var5_16:Find("bg/zan_bg/up"), function()
			var10_16(0)
		end, SFX_PANEL)
		onButton(arg0_16, var5_16:Find("bg/zan_bg/down"), function()
			var10_16(1)
		end, SFX_PANEL)
		onButton(arg0_16, var5_16:Find("bg/zan_bg/impeach"), function()
			arg0_16:openImpeachPanel(var6_16.id)
		end, SFX_PANEL)
		SetActive(var5_16:Find("bg/zan_bg/down"), not defaultValue(LOCK_DOWNVOTE, true))
		setActive(var5_16:Find("bg/zan_bg/impeach"), var4_16)
	end

	local var11_16 = 1

	for iter3_16 = 1, arg0_16.hotContent.childCount do
		local var12_16 = arg0_16.hotContent:GetChild(iter3_16 - 1)

		if go(var12_16).name ~= "tag" then
			setActive(var12_16:Find("print1"), var11_16 % 2 ~= 0)
			setActive(var12_16:Find("print2"), var11_16 % 2 == 0)

			var11_16 = var11_16 + 1
		end
	end

	setActive(arg0_16.hotContent:Find("tag"), arg0_16.hotContent.childCount > 1)
	setActive(arg0_16.commonContent:Find("tag"), arg0_16.commonContent.childCount > 1)
	arg0_16.hotContent:Find("tag"):SetAsLastSibling()
	arg0_16.commonContent:Find("tag"):SetAsLastSibling()
end

local var1_0 = 3

function var0_0.initImpeachPanel(arg0_21)
	arg0_21.impackPanel = arg0_21._tf:Find("impeachPanel")

	setText(arg0_21.impackPanel:Find("window/top/bg/impeach/title"), i18n("report_sent_title"))
	onButton(arg0_21, arg0_21.impackPanel:Find("window/top/btnBack"), function()
		arg0_21:onBackPressed()
	end, SFX_CANCEL)

	local var0_21 = arg0_21.impackPanel:Find("window/msg_panel/content")

	setText(var0_21:Find("title"), i18n("report_sent_desc"))

	local var1_21 = UIItemList.New(var0_21:Find("options"), var0_21:Find("options/tpl"))

	var1_21:make(function(arg0_23, arg1_23, arg2_23)
		arg1_23 = arg1_23 + 1

		if arg0_23 == UIItemList.EventUpdate then
			setText(arg2_23:Find("Text"), i18n("report_type_" .. arg1_23))
			setText(arg2_23:Find("Text_2"), i18n("report_type_" .. arg1_23 .. "_1"))
			onToggle(arg0_21, arg2_23, function(arg0_24)
				arg0_21.impeachOption = arg1_23
			end)
		end
	end)
	var1_21:align(var1_0)
	setText(var0_21:Find("other/field/Text"), i18n("report_type_other"))
	setText(var0_21:Find("other/field/input/Placeholder"), i18n("report_type_other_1"))
	onToggle(arg0_21, var0_21:Find("other"), function(arg0_25)
		arg0_21.impeachOption = "other"

		setActive(var0_21:Find("other/field/input"), arg0_25)
	end)

	local var2_21 = var0_21:Find("other/field/input")

	onInputChanged(arg0_21, var2_21, function()
		Canvas.ForceUpdateCanvases()
	end)
	onButton(arg0_21, arg0_21.impackPanel:Find("window/button_container/button"), function()
		if arg0_21.impeachOption == "other" then
			local var0_27 = getInputText(var2_21)

			if string.len(var0_27) > 0 then
				arg0_21:emit(var0_0.EVENT_IMPEACH, arg0_21.targetEvaId, i18n("report_type_other") .. ":" .. var0_27)
			else
				pg.TipsMgr.GetInstance():ShowTips(i18n("report_type_other_2"))

				return
			end
		else
			arg0_21:emit(var0_0.EVENT_IMPEACH, arg0_21.targetEvaId, i18n("report_type_" .. arg0_21.impeachOption))
		end

		arg0_21:onBackPressed()
	end, SFX_CONFIRM)
end

function var0_0.openImpeachPanel(arg0_28, arg1_28)
	arg0_28.targetEvaId = arg1_28

	setActive(arg0_28.mainPanel, false)
	setActive(arg0_28.impackPanel, true)
	triggerToggle(arg0_28.impackPanel:Find("window/msg_panel/content/other"), true)
	triggerToggle(arg0_28.impackPanel:Find("window/msg_panel/content/options/tpl"), true)
end

function var0_0.willExit(arg0_29)
	pg.UIMgr.GetInstance():UnblurPanel(arg0_29._tf)
end

return var0_0
