local var0_0 = class("ChargeItemBoxLayer", import("...base.BaseUI"))

function var0_0.getUIName(arg0_1)
	return "ChargeItemBoxUI"
end

function var0_0.init(arg0_2)
	arg0_2:initData()
	arg0_2:findUI()
	arg0_2:addListener()
	arg0_2:initUIText()
end

function var0_0.didEnter(arg0_3)
	arg0_3:updatePanel()
	pg.UIMgr.GetInstance():BlurPanel(arg0_3._tf)
end

function var0_0.willExit(arg0_4)
	pg.UIMgr.GetInstance():UnblurPanel(arg0_4._tf)
end

function var0_0.initData(arg0_5)
	arg0_5.panelConfig = arg0_5.contextData.panelConfig
end

function var0_0.initUIText(arg0_6)
	local var0_6 = arg0_6:findTF("window/button_container/button_cancel/Image")
	local var1_6 = arg0_6:findTF("window/button_container/button_ok/Image")

	setText(var0_6, i18n("text_cancel"))
	setText(var1_6, i18n("text_buy"))
end

function var0_0.findUI(arg0_7)
	arg0_7.bg = arg0_7:findTF("back_sign")
	arg0_7.detailWindow = arg0_7:findTF("window")
	arg0_7.cancelBtn = arg0_7:findTF("button_container/button_cancel", arg0_7.detailWindow)
	arg0_7.confirmBtn = arg0_7:findTF("button_container/button_ok", arg0_7.detailWindow)
	arg0_7.detailName = arg0_7:findTF("goods/name", arg0_7.detailWindow)
	arg0_7.detailIcon = arg0_7:findTF("goods/icon", arg0_7.detailWindow)
	arg0_7.detailRmb = arg0_7:findTF("prince_bg/contain/icon_rmb", arg0_7.detailWindow)
	arg0_7.detailGem = arg0_7:findTF("prince_bg/contain/icon_gem", arg0_7.detailWindow)
	arg0_7.detailPrice = arg0_7:findTF("prince_bg/contain/Text", arg0_7.detailWindow)
	arg0_7.detailTag = arg0_7:findTF("goods/tag", arg0_7.detailWindow)
	arg0_7.detailTags = {}

	table.insert(arg0_7.detailTags, arg0_7:findTF("hot", arg0_7.detailTag))
	table.insert(arg0_7.detailTags, arg0_7:findTF("new", arg0_7.detailTag))
	table.insert(arg0_7.detailTags, arg0_7:findTF("advice", arg0_7.detailTag))
	table.insert(arg0_7.detailTags, arg0_7:findTF("double", arg0_7.detailTag))
	table.insert(arg0_7.detailTags, arg0_7:findTF("discount", arg0_7.detailTag))

	arg0_7.detailTagAdviceTF = arg0_7.detailTags[3]
	arg0_7.detailTagDoubleTF = arg0_7.detailTags[4]
	arg0_7.detailNormalTip = arg0_7:findTF("NormalTips", arg0_7.detailWindow)
end

function var0_0.addListener(arg0_8)
	onButton(arg0_8, arg0_8.bg, function()
		arg0_8:closeView()
	end, SFX_PANEL)
	onButton(arg0_8, arg0_8.cancelBtn, function()
		arg0_8:closeView()
	end, SFX_PANEL)
	onButton(arg0_8, arg0_8.confirmBtn, function()
		if arg0_8.panelConfig.onYes then
			arg0_8.panelConfig.onYes()
			arg0_8:closeView()
		end
	end, SFX_PANEL)
end

function var0_0.updatePanel(arg0_12)
	local var0_12 = arg0_12.panelConfig.icon
	local var1_12 = arg0_12.panelConfig.name and arg0_12.panelConfig.name or ""

	if not arg0_12.panelConfig.tipBonus then
		local var2_12 = ""
	end

	local var3_12 = arg0_12.panelConfig.bonusItem

	if not arg0_12.panelConfig.tipExtra or not arg0_12.panelConfig.tipExtra then
		local var4_12 = ""
	end

	if not arg0_12.panelConfig.extraItems or not arg0_12.panelConfig.extraItems then
		local var5_12 = {}
	end

	local var6_12 = arg0_12.panelConfig.price and arg0_12.panelConfig.price or 0
	local var7_12 = arg0_12.panelConfig.isChargeType
	local var8_12 = arg0_12.panelConfig.isLocalPrice
	local var9_12 = arg0_12.panelConfig.isMonthCard
	local var10_12 = arg0_12.panelConfig.tagType
	local var11_12 = arg0_12.panelConfig.normalTip
	local var12_12 = arg0_12.panelConfig.extraDrop

	if arg0_12.detailNormalTip then
		setActive(arg0_12.detailNormalTip, var11_12)
	end

	if var11_12 then
		if arg0_12.detailNormalTip:GetComponent("Text") then
			setText(arg0_12.detailNormalTip, var11_12)
		else
			setButtonText(arg0_12.detailNormalTip, var11_12)
		end
	end

	setActive(arg0_12.detailTag, var10_12 > 0)

	if var10_12 > 0 then
		for iter0_12, iter1_12 in ipairs(arg0_12.detailTags) do
			setActive(iter1_12, iter0_12 == var10_12)
		end
	end

	GetImageSpriteFromAtlasAsync(var0_12, "", arg0_12.detailIcon, false)
	setText(arg0_12.detailName, var1_12)

	if PLATFORM_CODE == PLATFORM_CHT then
		setActive(arg0_12.detailRmb, var7_12 and not var8_12)
	else
		setActive(arg0_12.detailRmb, var7_12)
	end

	setActive(arg0_12.detailGem, not var7_12)
	setText(arg0_12.detailPrice, var6_12)
end

return var0_0
