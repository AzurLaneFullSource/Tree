local var0_0 = class("ShipEvaluationLayer", import("..base.BaseUI"))

var0_0.EVENT_LIKE = "event like"
var0_0.EVENT_EVA = "event eva"
var0_0.EVENT_ZAN = "event zan"
var0_0.EVENT_IMPEACH = "event impeach"

function var0_0.getUIName(arg0_1)
	return "EvaluationUI"
end

function var0_0.getResource(arg0_2, arg1_2)
	local var0_2 = {
		"shipyardicon/unknown",
		"shiptype",
		"shipframe"
	}
	local var1_2 = arg1_2.groupId
	local var2_2 = arg1_2.showTrans
	local var3_2 = getProxy(CollectionProxy):getShipGroup(var1_2)
	local var4_2 = var3_2:getPainting(var2_2)
	local var5_2 = var3_2:rarity2bgPrint(var2_2)

	table.insert(var0_2, "bg/star_level_card_" .. var5_2)

	local var6_2 = ResPathSupport.GetPaintingShipYardIconListByPaintingName(var4_2)

	table.insertto(var0_2, var6_2)

	return table.insertto(var0_2, var0_0.super.getResource(arg0_2))
end

function var0_0.init(arg0_3)
	arg0_3.mainPanel = arg0_3._tf:Find("mainPanel")
	arg0_3.head = arg0_3.mainPanel:Find("bg/left_panel/ship_tpl")
	arg0_3.labelHeart = arg0_3.mainPanel:Find("bg/left_panel/evaluation_count/heart")
	arg0_3.labelEva = arg0_3.mainPanel:Find("bg/left_panel/evaluation_count/count")
	arg0_3.btnLike = arg0_3.mainPanel:Find("bg/left_panel/btnLike")
	arg0_3.btnEva = arg0_3.mainPanel:Find("bg/bottom_panel/send_btn")
	arg0_3.input = arg0_3.mainPanel:Find("bg/bottom_panel/Input")
	arg0_3.inputText = arg0_3.input:Find("Text")
	arg0_3.list = arg0_3.mainPanel:Find("bg/right_panel/list")
	arg0_3.hotContent = arg0_3.list:Find("content/hots")
	arg0_3.commonContent = arg0_3.list:Find("content/commons")
	arg0_3.hotTpl = arg0_3.list:Find("content/hot_tpl")
	arg0_3.commonTpl = arg0_3.list:Find("content/commom_tpl")
	arg0_3.iconType = findTF(arg0_3.head, "content/main_bg/type_mask/type_icon"):GetComponent(typeof(Image))
	arg0_3.imageBg = findTF(arg0_3.head, "content/icon_bg"):GetComponent(typeof(Image))
	arg0_3.imageFrame = findTF(arg0_3.head, "content/main_bg/frame")
	arg0_3.iconShip = findTF(arg0_3.head, "content/icon"):GetComponent(typeof(Image))
	arg0_3.labelName = findTF(arg0_3.head, "content/main_bg/name_mask/name"):GetComponent(typeof(Text))
	arg0_3.scrollText = findTF(arg0_3.head, "content/main_bg/name_mask/name"):GetComponent(typeof(ScrollText))
	arg0_3.stars = findTF(arg0_3.head, "content/main_bg/stars")
	arg0_3.star = findTF(arg0_3.stars, "tpl")
	arg0_3.bg = arg0_3._tf:Find("BG")
	arg0_3.btnHelp = arg0_3._tf:Find("mainPanel/bg/top_panel/title/help")

	setActive(arg0_3.btnHelp, getProxy(PlayerProxy):getRawData():IsOpenShipEvaluationImpeach())
	arg0_3:initImpeachPanel()
	setActive(arg0_3.mainPanel, true)
	setActive(arg0_3.impackPanel, false)
	pg.UIMgr.GetInstance():BlurPanel(arg0_3._tf)
end

function var0_0.onBackPressed(arg0_4)
	if isActive(arg0_4.impackPanel) then
		setActive(arg0_4.mainPanel, true)
		setActive(arg0_4.impackPanel, false)
	else
		arg0_4:closeView()
	end
end

function var0_0.didEnter(arg0_5)
	onButton(arg0_5, arg0_5.bg, function()
		arg0_5:onBackPressed()
	end, SFX_CANCEL)
	onButton(arg0_5, arg0_5._tf:Find("mainPanel/bg/top_panel/btnBack"), function()
		arg0_5:onBackPressed()
	end, SFX_CANCEL)
	onButton(arg0_5, arg0_5.btnHelp, function()
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_HELP,
			helps = i18n("report_sent_help")
		})
	end, SFX_PANEL)
	onButton(arg0_5, arg0_5.btnLike, function()
		arg0_5:emit(var0_0.EVENT_LIKE)
	end, SFX_PANEL)
	onButton(arg0_5, arg0_5.btnEva, function()
		local var0_10 = getInputText(arg0_5.input)

		if string.len(var0_10) > 0 then
			setInputText(arg0_5.input, "")
			arg0_5:emit(var0_0.EVENT_EVA, var0_10)
		else
			pg.TipsMgr.GetInstance():ShowTips(i18n("eva_comment_send_null"))
		end
	end, SFX_PANEL)
	onInputChanged(arg0_5, arg0_5.input, function()
		local var0_11 = getInputText(arg0_5.input)
		local var1_11
		local var2_11

		if string.len(var0_11) > 0 then
			if arg0_5.shipGroup.evaluation.ievaCount >= CollectionProxy.MAX_DAILY_EVA_COUNT then
				var1_11 = true
				var2_11 = i18n("eva_count_limit")
			elseif wordVer(var0_11) > 0 then
				var1_11 = true
				var2_11 = i18n("invalidate_evaluation")
			end
		end

		if var1_11 then
			setTextColor(arg0_5.inputText, Color.red)
			setButtonEnabled(arg0_5.btnEva, false)
			pg.TipsMgr.GetInstance():ShowTips(var2_11)
		else
			setTextColor(arg0_5.inputText, Color.white)
			setButtonEnabled(arg0_5.btnEva, true)
		end
	end)
end

function var0_0.setShipGroup(arg0_12, arg1_12)
	arg0_12.shipGroup = arg1_12
end

function var0_0.setShowTrans(arg0_13, arg1_13)
	arg0_13.showTrans = arg1_13
end

function var0_0.flushAll(arg0_14)
	arg0_14:flushShip()
	arg0_14:flushHeart()
	arg0_14:flushEva()
end

function var0_0.flushShip(arg0_15)
	local var0_15 = arg0_15.shipGroup.shipConfig
	local var1_15 = arg0_15.shipGroup:getPainting(arg0_15.showTrans)
	local var2_15 = arg0_15.shipGroup:rarity2bgPrint(arg0_15.showTrans)

	setShipCardFrame(arg0_15.imageFrame, var2_15, nil)
	GetImageSpriteFromAtlasAsync("bg/star_level_card_" .. var2_15, "", arg0_15.imageBg)

	arg0_15.iconShip.sprite = GetSpriteFromAtlas("shipYardIcon/unknown", "")

	LoadImageSpriteAsync("shipYardIcon/" .. var1_15, arg0_15.iconShip)

	arg0_15.labelName.text = arg0_15.shipGroup:getName(arg0_15.showTrans)

	if arg0_15.scrollText then
		arg0_15.scrollText:SetText(arg0_15.shipGroup:getName(arg0_15.showTrans))
	end

	local var3_15 = GetSpriteFromAtlas("shiptype", shipType2print(arg0_15.shipGroup:getShipType(arg0_15.showTrans)))

	if not var3_15 then
		warning("找不到船形, shipConfigId: " .. var0_15.id)
	end

	arg0_15.iconType.sprite = var3_15

	local var4_15 = pg.ship_data_template[var0_15.id].star_max

	for iter0_15 = arg0_15.stars.childCount, var4_15 - 1 do
		local var5_15 = cloneTplTo(arg0_15.star, arg0_15.stars)
	end
end

function var0_0.flushHeart(arg0_16)
	setButtonEnabled(arg0_16.btnLike, not arg0_16.shipGroup.iheart)
	setText(arg0_16.labelHeart, arg0_16.shipGroup.evaluation.hearts)
end

function var0_0.flushEva(arg0_17)
	local var0_17 = arg0_17.shipGroup.evaluation

	setText(arg0_17.labelEva, var0_17.evaCount)

	local var1_17 = var0_17.evas

	for iter0_17 = 1, arg0_17.hotContent.childCount do
		local var2_17 = go(arg0_17.hotContent:GetChild(iter0_17 - 1))

		if var2_17.name ~= "tag" then
			Destroy(var2_17)
		end
	end

	for iter1_17 = 1, arg0_17.commonContent.childCount do
		local var3_17 = go(arg0_17.commonContent:GetChild(iter1_17 - 1))

		if var3_17.name ~= "tag" then
			Destroy(var3_17)
		end
	end

	local var4_17 = getProxy(PlayerProxy):getRawData():IsOpenShipEvaluationImpeach()

	for iter2_17 = 1, #var1_17 do
		local var5_17
		local var6_17 = var1_17[iter2_17]

		if var6_17.hot then
			var5_17 = cloneTplTo(arg0_17.hotTpl, arg0_17.hotContent)
		else
			var5_17 = cloneTplTo(arg0_17.commonTpl, arg0_17.commonContent)
		end

		local var7_17 = var5_17:Find("bg/evaluation"):GetComponent(typeof(Text))
		local var8_17 = var5_17:Find("bg/name")
		local var9_17 = var5_17:Find("bg/zan_bg/Text")

		setText(var8_17, var6_17.nick_name .. ":")
		setText(var9_17, var6_17.good_count - var6_17.bad_count)

		var7_17.supportRichText = false
		var7_17.text = var6_17.context

		local function var10_17(arg0_18)
			if not var6_17.izan then
				arg0_17:emit(var0_0.EVENT_ZAN, var6_17.id, arg0_18)
			else
				pg.TipsMgr.GetInstance():ShowTips(i18n("zan_ship_eva_error_7"))
			end
		end

		onButton(arg0_17, var5_17:Find("bg/zan_bg/up"), function()
			var10_17(0)
		end, SFX_PANEL)
		onButton(arg0_17, var5_17:Find("bg/zan_bg/down"), function()
			var10_17(1)
		end, SFX_PANEL)
		onButton(arg0_17, var5_17:Find("bg/zan_bg/impeach"), function()
			arg0_17:openImpeachPanel(var6_17.id)
		end, SFX_PANEL)
		SetActive(var5_17:Find("bg/zan_bg/down"), not defaultValue(LOCK_DOWNVOTE, true))
		setActive(var5_17:Find("bg/zan_bg/impeach"), var4_17)
	end

	local var11_17 = 1

	for iter3_17 = 1, arg0_17.hotContent.childCount do
		local var12_17 = arg0_17.hotContent:GetChild(iter3_17 - 1)

		if go(var12_17).name ~= "tag" then
			setActive(var12_17:Find("print1"), var11_17 % 2 ~= 0)
			setActive(var12_17:Find("print2"), var11_17 % 2 == 0)

			var11_17 = var11_17 + 1
		end
	end

	setActive(arg0_17.hotContent:Find("tag"), arg0_17.hotContent.childCount > 1)
	setActive(arg0_17.commonContent:Find("tag"), arg0_17.commonContent.childCount > 1)
	arg0_17.hotContent:Find("tag"):SetAsLastSibling()
	arg0_17.commonContent:Find("tag"):SetAsLastSibling()
end

local var1_0 = 3

function var0_0.initImpeachPanel(arg0_22)
	arg0_22.impackPanel = arg0_22._tf:Find("impeachPanel")

	setText(arg0_22.impackPanel:Find("window/top/bg/impeach/title"), i18n("report_sent_title"))
	onButton(arg0_22, arg0_22.impackPanel:Find("window/top/btnBack"), function()
		arg0_22:onBackPressed()
	end, SFX_CANCEL)

	local var0_22 = arg0_22.impackPanel:Find("window/msg_panel/content")

	setText(var0_22:Find("title"), i18n("report_sent_desc"))

	local var1_22 = UIItemList.New(var0_22:Find("options"), var0_22:Find("options/tpl"))

	var1_22:make(function(arg0_24, arg1_24, arg2_24)
		arg1_24 = arg1_24 + 1

		if arg0_24 == UIItemList.EventUpdate then
			setText(arg2_24:Find("Text"), i18n("report_type_" .. arg1_24))
			setText(arg2_24:Find("Text_2"), i18n("report_type_" .. arg1_24 .. "_1"))
			onToggle(arg0_22, arg2_24, function(arg0_25)
				arg0_22.impeachOption = arg1_24
			end)
		end
	end)
	var1_22:align(var1_0)
	setText(var0_22:Find("other/field/Text"), i18n("report_type_other"))
	setText(var0_22:Find("other/field/input/Placeholder"), i18n("report_type_other_1"))
	onToggle(arg0_22, var0_22:Find("other"), function(arg0_26)
		arg0_22.impeachOption = "other"

		setActive(var0_22:Find("other/field/input"), arg0_26)
	end)

	local var2_22 = var0_22:Find("other/field/input")

	onInputChanged(arg0_22, var2_22, function()
		Canvas.ForceUpdateCanvases()
	end)
	onButton(arg0_22, arg0_22.impackPanel:Find("window/button_container/button"), function()
		if arg0_22.impeachOption == "other" then
			local var0_28 = getInputText(var2_22)

			if string.len(var0_28) > 0 then
				arg0_22:emit(var0_0.EVENT_IMPEACH, arg0_22.targetEvaId, i18n("report_type_other") .. ":" .. var0_28)
			else
				pg.TipsMgr.GetInstance():ShowTips(i18n("report_type_other_2"))

				return
			end
		else
			arg0_22:emit(var0_0.EVENT_IMPEACH, arg0_22.targetEvaId, i18n("report_type_" .. arg0_22.impeachOption))
		end

		arg0_22:onBackPressed()
	end, SFX_CONFIRM)
end

function var0_0.openImpeachPanel(arg0_29, arg1_29)
	arg0_29.targetEvaId = arg1_29

	setActive(arg0_29.mainPanel, false)
	setActive(arg0_29.impackPanel, true)
	triggerToggle(arg0_29.impackPanel:Find("window/msg_panel/content/other"), true)
	triggerToggle(arg0_29.impackPanel:Find("window/msg_panel/content/options/tpl"), true)
end

function var0_0.willExit(arg0_30)
	pg.UIMgr.GetInstance():UnOverlayPanel(arg0_30._tf)
end

return var0_0
