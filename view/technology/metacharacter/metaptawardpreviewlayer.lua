local var0 = class("MetaPTAwardPreviewLayer", import("...base.BaseUI"))

function var0.getUIName(arg0)
	return "MetaPTAwardPreviewUI"
end

function var0.init(arg0)
	arg0:initUITextTips()
	arg0:initData()
	arg0:findUI()
	arg0:addListener()
	arg0:initScrollList()
end

function var0.didEnter(arg0)
	pg.UIMgr.GetInstance():BlurPanel(arg0._tf, false, {
		weight = LayerWeightConst.THIRD_LAYER
	})
	arg0:updatePTInfo()
	arg0:updateScrollList()
end

function var0.willExit(arg0)
	pg.UIMgr.GetInstance():UnblurPanel(arg0._tf)
end

function var0.initUITextTips(arg0)
	local var0 = arg0:findTF("Panel/AwardTpl/PointLight/PointTipText")
	local var1 = arg0:findTF("Panel/AwardTpl/PointGray/PointTipText")
	local var2 = arg0:findTF("Panel/AwardTpl/GetText")
	local var3 = arg0:findTF("Panel/AwardTpl/GotText")

	setText(var0, i18n("meta_pt_point"))
	setText(var1, i18n("meta_pt_point"))
	setText(var2, i18n("meta_award_get"))
	setText(var3, i18n("meta_award_got"))
end

function var0.initData(arg0)
	arg0.curMetaProgressVO = arg0.contextData.metaProgressVO
	arg0.ptData = arg0.curMetaProgressVO.metaPtData
	arg0.itemNum = #arg0.ptData.dropList
end

function var0.findUI(arg0)
	arg0.bg = arg0:findTF("BG")

	local var0 = arg0:findTF("Panel")
	local var1 = arg0:findTF("PT", var0)

	arg0.ptNumText = arg0:findTF("NumText", var1)
	arg0.ptIcon = arg0:findTF("PTIcon", var1)
	arg0.scrollViewTF = arg0:findTF("ScrollView", var0)
	arg0.awardContainerTF = arg0:findTF("ScrollView/Viewport/Content", var0)
	arg0.awardTpl = arg0:findTF("AwardTpl", var0)

	local var2 = arg0:findTF("NotchAdapt")

	arg0.nextArrow = arg0:findTF("NextBtn", var2)
	arg0.preArrow = arg0:findTF("PreBtn", var2)
	arg0.sizeW = GetComponent(arg0.awardTpl, "LayoutElement").preferredWidth
	arg0.spaceW = GetComponent(arg0.awardContainerTF, "HorizontalLayoutGroup").spacing
	arg0.leftW = GetComponent(arg0.awardContainerTF, "HorizontalLayoutGroup").padding.left
end

function var0.addListener(arg0)
	onButton(arg0, arg0.bg, function()
		arg0:closeView()
	end, SFX_PANEL)
end

function var0.initScrollList(arg0)
	arg0.awardUIItemList = UIItemList.New(arg0.awardContainerTF, arg0.awardTpl)

	arg0.awardUIItemList:make(function(arg0, arg1, arg2)
		if arg0 == UIItemList.EventUpdate then
			arg0:updateAwardTpl(arg2, arg1 + 1)
		end
	end)

	arg0.scrollRectSC = arg0.scrollViewTF:GetComponent("ScrollRect")

	arg0.scrollRectSC.onValueChanged:AddListener(function(arg0)
		setActive(arg0.preArrow, arg0.x >= 0.01)
		setActive(arg0.nextArrow, arg0.x <= 0.99)
	end)
end

function var0.updateScrollList(arg0)
	local var0, var1, var2 = arg0.curMetaProgressVO.metaPtData:GetLevelProgress()

	arg0.awardUIItemList:align(var1)

	local var3 = (var0 - 1) * (arg0.sizeW + arg0.spaceW)

	setLocalPosition(arg0.awardContainerTF, {
		x = -var3
	})

	if var0 > 1 then
		setActive(arg0.preArrow, true)
	end
end

function var0.updateAwardTpl(arg0, arg1, arg2)
	local var0 = arg0:findTF("Item", arg1)
	local var1 = arg0:findTF("mask", var0)
	local var2 = arg0:findTF("Got", var1)
	local var3 = arg0:findTF("Lock", var1)
	local var4 = arg0:findTF("PointLight", arg1)
	local var5 = arg0:findTF("NumText", var4)
	local var6 = arg0:findTF("PointGray", arg1)
	local var7 = arg0:findTF("NumText", var6)
	local var8 = arg0:findTF("GetText", arg1)
	local var9 = arg0:findTF("GotText", arg1)
	local var10 = arg0:findTF("LockText", arg1)
	local var11 = arg0:findTF("LineTpl", arg1)
	local var12 = arg0:findTF("LineTpl/Light", arg1)
	local var13 = arg0:findTF("LineTpl/Dark", arg1)
	local var14 = arg0.ptData.dropList[arg2]
	local var15 = arg0.ptData.targets[arg2]
	local var16 = {
		type = var14[1],
		id = var14[2],
		count = var14[3]
	}

	updateDrop(var0, var16, {
		hideName = true
	})
	onButton(arg0, var0, function()
		arg0:emit(BaseUI.ON_DROP, var16)
	end, SFX_PANEL)
	setText(var5, var15)
	setText(var7, var15)
	setText(var10, "PHASE " .. math.floor(var15 / arg0.curMetaProgressVO.unlockPTNum * 100) .. "%")

	if arg2 < arg0.ptData.level + 1 then
		setActive(var1, true)
		setActive(var2, true)
		setActive(var3, false)
		setActive(var4, false)
		setActive(var6, true)
		setActive(var12, false)
		setActive(var13, true)
		setActive(var8, false)
		setActive(var9, true)
		setActive(var10, false)
	elseif var15 > arg0.ptData.count then
		setActive(var1, true)
		setActive(var2, false)
		setActive(var3, true)
		setActive(var4, false)
		setActive(var6, true)
		setActive(var12, false)
		setActive(var13, true)
		setActive(var8, false)
		setActive(var9, false)
		setActive(var10, true)
	else
		setActive(var1, false)
		setActive(var2, false)
		setActive(var3, false)
		setActive(var4, true)
		setActive(var6, false)
		setActive(var12, true)
		setActive(var13, false)
		setActive(var8, true)
		setActive(var9, false)
		setActive(var10, false)
	end

	if arg2 == 1 then
		setActive(var11, false)
	end
end

function var0.updatePTInfo(arg0)
	setImageSprite(arg0.ptIcon, LoadSprite(arg0.curMetaProgressVO:getPtIconPath()))
	setText(arg0.ptNumText, arg0.ptData.count)
end

return var0
