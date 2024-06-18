local var0_0 = class("MetaPTAwardPreviewLayer", import("...base.BaseUI"))

function var0_0.getUIName(arg0_1)
	return "MetaPTAwardPreviewUI"
end

function var0_0.init(arg0_2)
	arg0_2:initUITextTips()
	arg0_2:initData()
	arg0_2:findUI()
	arg0_2:addListener()
	arg0_2:initScrollList()
end

function var0_0.didEnter(arg0_3)
	pg.UIMgr.GetInstance():BlurPanel(arg0_3._tf, false, {
		weight = LayerWeightConst.THIRD_LAYER
	})
	arg0_3:updatePTInfo()
	arg0_3:updateScrollList()
end

function var0_0.willExit(arg0_4)
	pg.UIMgr.GetInstance():UnblurPanel(arg0_4._tf)
end

function var0_0.initUITextTips(arg0_5)
	local var0_5 = arg0_5:findTF("Panel/AwardTpl/PointLight/PointTipText")
	local var1_5 = arg0_5:findTF("Panel/AwardTpl/PointGray/PointTipText")
	local var2_5 = arg0_5:findTF("Panel/AwardTpl/GetText")
	local var3_5 = arg0_5:findTF("Panel/AwardTpl/GotText")

	setText(var0_5, i18n("meta_pt_point"))
	setText(var1_5, i18n("meta_pt_point"))
	setText(var2_5, i18n("meta_award_get"))
	setText(var3_5, i18n("meta_award_got"))
end

function var0_0.initData(arg0_6)
	arg0_6.curMetaProgressVO = arg0_6.contextData.metaProgressVO
	arg0_6.ptData = arg0_6.curMetaProgressVO.metaPtData
	arg0_6.itemNum = #arg0_6.ptData.dropList
end

function var0_0.findUI(arg0_7)
	arg0_7.bg = arg0_7:findTF("BG")

	local var0_7 = arg0_7:findTF("Panel")
	local var1_7 = arg0_7:findTF("PT", var0_7)

	arg0_7.ptNumText = arg0_7:findTF("NumText", var1_7)
	arg0_7.ptIcon = arg0_7:findTF("PTIcon", var1_7)
	arg0_7.scrollViewTF = arg0_7:findTF("ScrollView", var0_7)
	arg0_7.awardContainerTF = arg0_7:findTF("ScrollView/Viewport/Content", var0_7)
	arg0_7.awardTpl = arg0_7:findTF("AwardTpl", var0_7)

	local var2_7 = arg0_7:findTF("NotchAdapt")

	arg0_7.nextArrow = arg0_7:findTF("NextBtn", var2_7)
	arg0_7.preArrow = arg0_7:findTF("PreBtn", var2_7)
	arg0_7.sizeW = GetComponent(arg0_7.awardTpl, "LayoutElement").preferredWidth
	arg0_7.spaceW = GetComponent(arg0_7.awardContainerTF, "HorizontalLayoutGroup").spacing
	arg0_7.leftW = GetComponent(arg0_7.awardContainerTF, "HorizontalLayoutGroup").padding.left
end

function var0_0.addListener(arg0_8)
	onButton(arg0_8, arg0_8.bg, function()
		arg0_8:closeView()
	end, SFX_PANEL)
end

function var0_0.initScrollList(arg0_10)
	arg0_10.awardUIItemList = UIItemList.New(arg0_10.awardContainerTF, arg0_10.awardTpl)

	arg0_10.awardUIItemList:make(function(arg0_11, arg1_11, arg2_11)
		if arg0_11 == UIItemList.EventUpdate then
			arg0_10:updateAwardTpl(arg2_11, arg1_11 + 1)
		end
	end)

	arg0_10.scrollRectSC = arg0_10.scrollViewTF:GetComponent("ScrollRect")

	arg0_10.scrollRectSC.onValueChanged:AddListener(function(arg0_12)
		setActive(arg0_10.preArrow, arg0_12.x >= 0.01)
		setActive(arg0_10.nextArrow, arg0_12.x <= 0.99)
	end)
end

function var0_0.updateScrollList(arg0_13)
	local var0_13, var1_13, var2_13 = arg0_13.curMetaProgressVO.metaPtData:GetLevelProgress()

	arg0_13.awardUIItemList:align(var1_13)

	local var3_13 = (var0_13 - 1) * (arg0_13.sizeW + arg0_13.spaceW)

	setLocalPosition(arg0_13.awardContainerTF, {
		x = -var3_13
	})

	if var0_13 > 1 then
		setActive(arg0_13.preArrow, true)
	end
end

function var0_0.updateAwardTpl(arg0_14, arg1_14, arg2_14)
	local var0_14 = arg0_14:findTF("Item", arg1_14)
	local var1_14 = arg0_14:findTF("mask", var0_14)
	local var2_14 = arg0_14:findTF("Got", var1_14)
	local var3_14 = arg0_14:findTF("Lock", var1_14)
	local var4_14 = arg0_14:findTF("PointLight", arg1_14)
	local var5_14 = arg0_14:findTF("NumText", var4_14)
	local var6_14 = arg0_14:findTF("PointGray", arg1_14)
	local var7_14 = arg0_14:findTF("NumText", var6_14)
	local var8_14 = arg0_14:findTF("GetText", arg1_14)
	local var9_14 = arg0_14:findTF("GotText", arg1_14)
	local var10_14 = arg0_14:findTF("LockText", arg1_14)
	local var11_14 = arg0_14:findTF("LineTpl", arg1_14)
	local var12_14 = arg0_14:findTF("LineTpl/Light", arg1_14)
	local var13_14 = arg0_14:findTF("LineTpl/Dark", arg1_14)
	local var14_14 = arg0_14.ptData.dropList[arg2_14]
	local var15_14 = arg0_14.ptData.targets[arg2_14]
	local var16_14 = {
		type = var14_14[1],
		id = var14_14[2],
		count = var14_14[3]
	}

	updateDrop(var0_14, var16_14, {
		hideName = true
	})
	onButton(arg0_14, var0_14, function()
		arg0_14:emit(BaseUI.ON_DROP, var16_14)
	end, SFX_PANEL)
	setText(var5_14, var15_14)
	setText(var7_14, var15_14)
	setText(var10_14, "PHASE " .. math.floor(var15_14 / arg0_14.curMetaProgressVO.unlockPTNum * 100) .. "%")

	if arg2_14 < arg0_14.ptData.level + 1 then
		setActive(var1_14, true)
		setActive(var2_14, true)
		setActive(var3_14, false)
		setActive(var4_14, false)
		setActive(var6_14, true)
		setActive(var12_14, false)
		setActive(var13_14, true)
		setActive(var8_14, false)
		setActive(var9_14, true)
		setActive(var10_14, false)
	elseif var15_14 > arg0_14.ptData.count then
		setActive(var1_14, true)
		setActive(var2_14, false)
		setActive(var3_14, true)
		setActive(var4_14, false)
		setActive(var6_14, true)
		setActive(var12_14, false)
		setActive(var13_14, true)
		setActive(var8_14, false)
		setActive(var9_14, false)
		setActive(var10_14, true)
	else
		setActive(var1_14, false)
		setActive(var2_14, false)
		setActive(var3_14, false)
		setActive(var4_14, true)
		setActive(var6_14, false)
		setActive(var12_14, true)
		setActive(var13_14, false)
		setActive(var8_14, true)
		setActive(var9_14, false)
		setActive(var10_14, false)
	end

	if arg2_14 == 1 then
		setActive(var11_14, false)
	end
end

function var0_0.updatePTInfo(arg0_16)
	setImageSprite(arg0_16.ptIcon, LoadSprite(arg0_16.curMetaProgressVO:getPtIconPath()))
	setText(arg0_16.ptNumText, arg0_16.ptData.count)
end

return var0_0
