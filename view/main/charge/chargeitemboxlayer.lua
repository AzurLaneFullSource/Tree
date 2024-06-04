local var0 = class("ChargeItemBoxLayer", import("...base.BaseUI"))

function var0.getUIName(arg0)
	return "ChargeItemBoxUI"
end

function var0.init(arg0)
	arg0:initData()
	arg0:findUI()
	arg0:addListener()
	arg0:initUIText()
end

function var0.didEnter(arg0)
	arg0:updatePanel()
	pg.UIMgr.GetInstance():BlurPanel(arg0._tf)
end

function var0.willExit(arg0)
	pg.UIMgr.GetInstance():UnblurPanel(arg0._tf)
end

function var0.initData(arg0)
	arg0.panelConfig = arg0.contextData.panelConfig
end

function var0.initUIText(arg0)
	local var0 = arg0:findTF("window/button_container/button_cancel/Image")
	local var1 = arg0:findTF("window/button_container/button_ok/Image")

	setText(var0, i18n("text_cancel"))
	setText(var1, i18n("text_buy"))
end

function var0.findUI(arg0)
	arg0.bg = arg0:findTF("back_sign")
	arg0.detailWindow = arg0:findTF("window")
	arg0.cancelBtn = arg0:findTF("button_container/button_cancel", arg0.detailWindow)
	arg0.confirmBtn = arg0:findTF("button_container/button_ok", arg0.detailWindow)
	arg0.detailName = arg0:findTF("goods/name", arg0.detailWindow)
	arg0.detailIcon = arg0:findTF("goods/icon", arg0.detailWindow)
	arg0.detailRmb = arg0:findTF("prince_bg/contain/icon_rmb", arg0.detailWindow)
	arg0.detailGem = arg0:findTF("prince_bg/contain/icon_gem", arg0.detailWindow)
	arg0.detailPrice = arg0:findTF("prince_bg/contain/Text", arg0.detailWindow)
	arg0.detailTag = arg0:findTF("goods/tag", arg0.detailWindow)
	arg0.detailTags = {}

	table.insert(arg0.detailTags, arg0:findTF("hot", arg0.detailTag))
	table.insert(arg0.detailTags, arg0:findTF("new", arg0.detailTag))
	table.insert(arg0.detailTags, arg0:findTF("advice", arg0.detailTag))
	table.insert(arg0.detailTags, arg0:findTF("double", arg0.detailTag))
	table.insert(arg0.detailTags, arg0:findTF("discount", arg0.detailTag))

	arg0.detailTagAdviceTF = arg0.detailTags[3]
	arg0.detailTagDoubleTF = arg0.detailTags[4]
	arg0.detailNormalTip = arg0:findTF("NormalTips", arg0.detailWindow)
end

function var0.addListener(arg0)
	onButton(arg0, arg0.bg, function()
		arg0:closeView()
	end, SFX_PANEL)
	onButton(arg0, arg0.cancelBtn, function()
		arg0:closeView()
	end, SFX_PANEL)
	onButton(arg0, arg0.confirmBtn, function()
		if arg0.panelConfig.onYes then
			arg0.panelConfig.onYes()
			arg0:closeView()
		end
	end, SFX_PANEL)
end

function var0.updatePanel(arg0)
	local var0 = arg0.panelConfig.icon
	local var1 = arg0.panelConfig.name and arg0.panelConfig.name or ""

	if not arg0.panelConfig.tipBonus then
		local var2 = ""
	end

	local var3 = arg0.panelConfig.bonusItem

	if not arg0.panelConfig.tipExtra or not arg0.panelConfig.tipExtra then
		local var4 = ""
	end

	if not arg0.panelConfig.extraItems or not arg0.panelConfig.extraItems then
		local var5 = {}
	end

	local var6 = arg0.panelConfig.price and arg0.panelConfig.price or 0
	local var7 = arg0.panelConfig.isChargeType
	local var8 = arg0.panelConfig.isLocalPrice
	local var9 = arg0.panelConfig.isMonthCard
	local var10 = arg0.panelConfig.tagType
	local var11 = arg0.panelConfig.normalTip
	local var12 = arg0.panelConfig.extraDrop

	if arg0.detailNormalTip then
		setActive(arg0.detailNormalTip, var11)
	end

	if var11 then
		if arg0.detailNormalTip:GetComponent("Text") then
			setText(arg0.detailNormalTip, var11)
		else
			setButtonText(arg0.detailNormalTip, var11)
		end
	end

	setActive(arg0.detailTag, var10 > 0)

	if var10 > 0 then
		for iter0, iter1 in ipairs(arg0.detailTags) do
			setActive(iter1, iter0 == var10)
		end
	end

	GetImageSpriteFromAtlasAsync(var0, "", arg0.detailIcon, false)
	setText(arg0.detailName, var1)

	if PLATFORM_CODE == PLATFORM_CHT then
		setActive(arg0.detailRmb, var7 and not var8)
	else
		setActive(arg0.detailRmb, var7)
	end

	setActive(arg0.detailGem, not var7)
	setText(arg0.detailPrice, var6)
end

return var0
