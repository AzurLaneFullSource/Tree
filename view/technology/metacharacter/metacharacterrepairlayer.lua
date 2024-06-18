local var0_0 = class("MetaCharacterRepairLayer", import("...base.BaseUI"))

function var0_0.getUIName(arg0_1)
	return "MetaCharacterRepairUI"
end

function var0_0.init(arg0_2)
	arg0_2:initTipText()
	arg0_2:initData()
	arg0_2:findUI()
	arg0_2:addListener()

	for iter0_2, iter1_2 in ipairs(MetaCharacterConst.REPAIR_ATTRS) do
		if not arg0_2.curMetaCharacterVO:getAttrVO(iter1_2):isLock() then
			triggerToggle(arg0_2.attrTFList[iter1_2], true)

			break
		end
	end
end

function var0_0.didEnter(arg0_3)
	arg0_3:doRepairProgressPanelAni()
	arg0_3:updateAttrListPanel()
	arg0_3:updateRepairBtn(true)
	arg0_3:updateDetailPanel()
	arg0_3:TryPlayGuide()
end

function var0_0.willExit(arg0_4)
	return
end

function var0_0.onBackPressed(arg0_5)
	if isActive(arg0_5.repairEffectBoxPanel) then
		arg0_5:closeRepairEffectBoxPanel()

		return
	elseif isActive(arg0_5.detailPanel) then
		arg0_5:closeDetailPanel()

		return
	else
		arg0_5:emit(var0_0.ON_BACK_PRESSED)
	end
end

function var0_0.initTipText(arg0_6)
	local var0_6 = arg0_6:findTF("Repair/AttrListPanel/AttrItemContainer/AttrItemCannon/SelectedPanel/AttrRepairTipText")
	local var1_6 = arg0_6:findTF("Repair/AttrListPanel/AttrItemContainer/AttrItemTorpedo/SelectedPanel/AttrRepairTipText")
	local var2_6 = arg0_6:findTF("Repair/AttrListPanel/AttrItemContainer/AttrItemAir/SelectedPanel/AttrRepairTipText")
	local var3_6 = arg0_6:findTF("Repair/AttrListPanel/AttrItemContainer/AttrItemReload/SelectedPanel/AttrRepairTipText")

	setText(var0_6, i18n("meta_repair"))
	setText(var1_6, i18n("meta_repair"))
	setText(var2_6, i18n("meta_repair"))
	setText(var3_6, i18n("meta_repair"))
end

function var0_0.initData(arg0_7)
	arg0_7.metaCharacterProxy = getProxy(MetaCharacterProxy)
	arg0_7.bayProxy = getProxy(BayProxy)
	arg0_7.attrTFList = {}
	arg0_7.curAttrName = nil
	arg0_7.curMetaShipID = arg0_7.contextData.shipID
	arg0_7.curShipVO = nil
	arg0_7.curMetaCharacterVO = nil

	arg0_7:updateData()
end

function var0_0.findUI(arg0_8)
	arg0_8.repairPanel = arg0_8:findTF("Repair")
	arg0_8.attrListPanel = arg0_8:findTF("AttrListPanel", arg0_8.repairPanel)
	arg0_8.attrItemContainer = arg0_8:findTF("AttrItemContainer", arg0_8.attrListPanel)
	arg0_8.attrCannonTF = arg0_8:findTF("AttrItemCannon", arg0_8.attrItemContainer)
	arg0_8.attrTorpedoTF = arg0_8:findTF("AttrItemTorpedo", arg0_8.attrItemContainer)
	arg0_8.attrAirTF = arg0_8:findTF("AttrItemAir", arg0_8.attrItemContainer)
	arg0_8.attrReloadTF = arg0_8:findTF("AttrItemReload", arg0_8.attrItemContainer)
	arg0_8.attrTFList.cannon = arg0_8.attrCannonTF
	arg0_8.attrTFList.torpedo = arg0_8.attrTorpedoTF
	arg0_8.attrTFList.air = arg0_8.attrAirTF
	arg0_8.attrTFList.reload = arg0_8.attrReloadTF
	arg0_8.repairPercentText = arg0_8:findTF("SynProgressPanel/SynRate/NumTextText", arg0_8.repairPanel)
	arg0_8.repairSliderTF = arg0_8:findTF("SynProgressPanel/Slider", arg0_8.repairPanel)
	arg0_8.repairBtn = arg0_8:findTF("RepairBtn", arg0_8.repairPanel)
	arg0_8.repairBtnDisable = arg0_8:findTF("RepairBtnDisable", arg0_8.repairPanel)
	arg0_8.showDetailLine = arg0_8:findTF("ShowDetailLine")
	arg0_8.showDetailBtn = arg0_8:findTF("ShowDetailBtn", arg0_8.showDetailLine)
	arg0_8.detailPanel = arg0_8:findTF("Detail")
	arg0_8.detailBG = arg0_8:findTF("BG", arg0_8.detailPanel)
	arg0_8.detailTF = arg0_8:findTF("Panel", arg0_8.detailPanel)
	arg0_8.detailCloseBtn = arg0_8:findTF("CloseBtn", arg0_8.detailTF)
	arg0_8.detailLineTpl = arg0_8:findTF("DetailLineTpl", arg0_8.detailTF)
	arg0_8.detailItemTpl = arg0_8:findTF("DetailItemTpl", arg0_8.detailTF)
	arg0_8.detailItemContainer = arg0_8:findTF("ScrollView/Viewport/Content", arg0_8.detailTF)
	arg0_8.repairEffectBoxPanel = arg0_8:findTF("RepairEffectBox")
end

function var0_0.addListener(arg0_9)
	for iter0_9, iter1_9 in pairs(arg0_9.attrTFList) do
		onToggle(arg0_9, iter1_9, function(arg0_10)
			if arg0_10 == true then
				arg0_9.curAttrName = iter0_9

				arg0_9:updateRepairBtn()
			else
				arg0_9.curAttrName = nil

				arg0_9:updateRepairBtn(true)
			end
		end, SFX_PANEL)
	end

	onButton(arg0_9, arg0_9.repairBtn, function()
		pg.m02:sendNotification(GAME.REPAIR_META_CHARACTER, {
			shipID = arg0_9.curMetaShipID,
			attr = arg0_9.curAttrName
		})
	end, SFX_PANEL)
	onButton(arg0_9, arg0_9.showDetailBtn, function()
		if not isActive(arg0_9.detailPanel) then
			arg0_9:openDetailPanel()
		end
	end, SFX_PANEL)
	onButton(arg0_9, arg0_9.showDetailLine, function()
		if not isActive(arg0_9.detailPanel) then
			arg0_9:openDetailPanel()
		end
	end, SFX_PANEL)
	onButton(arg0_9, arg0_9.detailCloseBtn, function()
		arg0_9:closeDetailPanel()
	end, SFX_CANCEL)
	onButton(arg0_9, arg0_9.detailBG, function()
		arg0_9:closeDetailPanel()
	end, SFX_CANCEL)
end

function var0_0.TryPlayGuide(arg0_16)
	pg.SystemGuideMgr.GetInstance():PlayByGuideId("NG0027")
end

function var0_0.doRepairProgressPanelAni(arg0_17)
	local var0_17 = arg0_17.curMetaCharacterVO:getRepairRate()
	local var1_17 = GetComponent(arg0_17.repairSliderTF, typeof(Slider))

	var1_17.minValue = 0
	var1_17.maxValue = 1

	local var2_17 = var1_17.value

	if var0_17 > 0 then
		local var3_17 = 0.5

		arg0_17:managedTween(LeanTween.value, nil, go(arg0_17.repairSliderTF), var2_17, var0_17, var3_17):setOnUpdate(System.Action_float(function(arg0_18)
			arg0_17:updateRepairProgressPanel(arg0_18)
		end)):setOnComplete(System.Action(function()
			arg0_17:updateRepairProgressPanel(var0_17)
		end))
	else
		arg0_17:updateRepairProgressPanel(var0_17)
	end
end

function var0_0.updateRepairProgressPanel(arg0_20, arg1_20)
	local var0_20 = arg1_20 or arg0_20.curMetaCharacterVO:getRepairRate()

	setSlider(arg0_20.repairSliderTF, 0, 1, var0_20)
	setText(arg0_20.repairPercentText, string.format("%d", var0_20 * 100))
end

function var0_0.updateAttrListPanel(arg0_21)
	for iter0_21, iter1_21 in ipairs(MetaCharacterConst.REPAIR_ATTRS) do
		arg0_21:updateAttrItem(arg0_21.attrTFList[iter1_21], iter1_21)
	end
end

function var0_0.updateAttrItem(arg0_22, arg1_22, arg2_22)
	local var0_22 = arg0_22:findTF("LockPanel", arg1_22)
	local var1_22 = arg0_22:findTF("UnSelectPanel", arg1_22)
	local var2_22 = arg0_22:findTF("SelectedPanel", arg1_22)
	local var3_22 = arg0_22:findTF("TitleImg", var2_22)

	GetComponent(var3_22, "Image"):SetNativeSize()

	local var4_22 = arg0_22.curMetaCharacterVO:getAttrVO(arg2_22)

	if var4_22:isLock() then
		setActive(var1_22, false)
		setActive(var2_22, false)
		setActive(var0_22, true)

		arg1_22:GetComponent("Toggle").interactable = false
	else
		local var5_22 = arg1_22:GetComponent("Toggle")

		setActive(var1_22, not var5_22.isOn)
		setActive(var2_22, var5_22.isOn)
		setActive(var0_22, false)

		var5_22.interactable = true

		local var6_22 = arg0_22:findTF("ValueText", var1_22)
		local var7_22 = arg0_22:findTF("ValueText", var2_22)
		local var8_22 = arg0_22:findTF("AttrRepairValue/CurValueText", var2_22)
		local var9_22 = arg0_22:findTF("AttrRepairValue/Image", var2_22)
		local var10_22 = arg0_22:findTF("AttrRepairValue/NextValueText", var2_22)
		local var11_22 = arg0_22:findTF("IconTpl", var2_22)
		local var12_22 = arg0_22:findTF("ItemCount", var2_22)
		local var13_22 = arg0_22:findTF("NumText", var12_22)
		local var14_22 = var4_22:getAddition()

		setText(var6_22, "+" .. var14_22)
		setText(var7_22, "+" .. var14_22)
		setText(var8_22, "+" .. var14_22)

		local var15_22 = var4_22:getLevel()
		local var16_22 = var4_22:isMaxLevel()
		local var17_22

		if not var16_22 then
			var17_22 = var4_22:getItem()
		else
			var17_22 = var4_22:getItemByLevel(var15_22 - 1)
		end

		local var18_22 = var17_22:getItemId()
		local var19_22 = var17_22:getTotalCnt()
		local var20_22 = getProxy(BagProxy):getItemCountById(var18_22)

		if var20_22 < var19_22 then
			var20_22 = setColorStr(var20_22, COLOR_RED)
		end

		setText(var13_22, var20_22 .. "/" .. var19_22)

		local var21_22 = {
			type = DROP_TYPE_ITEM,
			id = var18_22,
			count = var19_22
		}

		updateDrop(var11_22, var21_22, {
			hideName = true
		})
		onButton(arg0_22, var11_22, function()
			arg0_22:emit(BaseUI.ON_DROP, var21_22)
		end, SFX_PANEL)
		setActive(var9_22, not var16_22)
		setActive(var10_22, not var16_22)

		if var16_22 then
			setText(var10_22, var14_22)
		else
			local var22_22 = var17_22:getAdditionValue()

			setText(var10_22, "+" .. var14_22 + var22_22)
		end

		if var16_22 then
			setActive(var11_22, false)
			setActive(var12_22, false)
		else
			setActive(var11_22, true)
			setActive(var12_22, true)
		end
	end
end

function var0_0.updateRepairBtn(arg0_24, arg1_24)
	if arg1_24 == true then
		setActive(arg0_24.repairBtn, false)
		setActive(arg0_24.repairBtnDisable, false)

		return
	end

	local var0_24 = arg0_24.curMetaCharacterVO:getAttrVO(arg0_24.curAttrName)
	local var1_24 = var0_24:getLevel()
	local var2_24 = var0_24:isMaxLevel()
	local var3_24

	if not var2_24 then
		var3_24 = var0_24:getItem()
	else
		var3_24 = var0_24:getItemByLevel(var1_24 - 1)
	end

	local var4_24 = var3_24:getItemId()
	local var5_24 = var3_24:getTotalCnt() <= getProxy(BagProxy):getItemCountById(var4_24)

	if var2_24 then
		setActive(arg0_24.repairBtn, false)
		setActive(arg0_24.repairBtnDisable, false)
	elseif not var5_24 then
		setActive(arg0_24.repairBtn, false)
		setActive(arg0_24.repairBtnDisable, true)
	else
		setActive(arg0_24.repairBtn, true)
		setActive(arg0_24.repairBtnDisable, false)
	end
end

function var0_0.updateDetailItem(arg0_25, arg1_25, arg2_25)
	local var0_25 = arg0_25:findTF("LineContainer", arg1_25)
	local var1_25 = arg0_25:findTF("LockPanel", arg1_25)
	local var2_25 = arg0_25:findTF("TipText", var1_25)
	local var3_25 = arg2_25.progress

	setText(var2_25, i18n("meta_repair_effect_unlock", var3_25))

	local var4_25 = arg0_25.curMetaCharacterVO:getRepairRate()

	setActive(var1_25, not (var3_25 <= var4_25 * 100))

	local var5_25 = arg2_25:getAttrAdditionList()
	local var6_25 = #var5_25
	local var7_25 = arg2_25:getDescs()
	local var8_25 = var6_25 + #var7_25 + 1
	local var9_25 = UIItemList.New(var0_25, arg0_25.detailLineTpl)

	var9_25:make(function(arg0_26, arg1_26, arg2_26)
		local var0_26 = arg0_25:findTF("AttrLine", arg2_26)
		local var1_26 = arg0_25:findTF("UnlockTipLine", arg2_26)
		local var2_26 = arg0_25:findTF("Text", arg2_26)

		if arg0_26 == UIItemList.EventUpdate then
			arg1_26 = arg1_26 + 1

			if arg1_26 == 1 then
				setActive(var0_26, false)
				setActive(var1_26, false)
				setActive(var2_26, true)
				setText(var2_26, i18n("meta_repair_effect_unlock", var3_25))

				return
			end

			if arg1_26 <= var6_25 + 1 then
				setActive(var0_26, true)
				setActive(var1_26, false)

				local var3_26 = arg0_25:findTF("AttrIcon", var0_26)
				local var4_26 = arg0_25:findTF("AttrNameText", var0_26)
				local var5_26 = arg0_25:findTF("NumText", var0_26)
				local var6_26 = var5_25[arg1_26 - 1]
				local var7_26 = var6_26[1]
				local var8_26 = var6_26[2]

				setImageSprite(var3_26, LoadSprite("attricon", var7_26))
				setText(var4_26, AttributeType.Type2Name(var7_26))
				setText(var5_26, "+" .. var8_26)
			else
				setActive(var0_26, false)
				setActive(var1_26, true)

				local var9_26 = arg0_25:findTF("Text", var1_26)
				local var10_26 = var7_25[arg1_26 - 1 - var6_25]

				setScrollText(var9_26, var10_26)
			end
		end
	end)
	var9_25:align(var8_25)
end

function var0_0.updateDetailPanel(arg0_27)
	setActive(arg0_27.detailPanel, false)

	local var0_27 = arg0_27.curMetaCharacterVO:getEffects()

	arg0_27.detailList = UIItemList.New(arg0_27.detailItemContainer, arg0_27.detailItemTpl)

	arg0_27.detailList:make(function(arg0_28, arg1_28, arg2_28)
		if arg0_28 == UIItemList.EventUpdate then
			local var0_28 = var0_27[arg1_28 + 1]

			arg0_27:updateDetailItem(arg2_28, var0_28)
		end
	end)
	arg0_27.detailList:align(#var0_27)
end

function var0_0.updateData(arg0_29)
	arg0_29.curShipVO = arg0_29.bayProxy:getShipById(arg0_29.curMetaShipID)
	arg0_29.curMetaCharacterVO = arg0_29.curShipVO:getMetaCharacter()
end

function var0_0.checkSpecialEffect(arg0_30)
	local var0_30 = arg0_30.bayProxy:getShipById(arg0_30.curMetaShipID):getMetaCharacter()
	local var1_30 = var0_30:getRepairRate() * 100
	local var2_30 = arg0_30.curMetaCharacterVO:getRepairRate() * 100
	local var3_30 = var0_30:getEffects()

	for iter0_30, iter1_30 in ipairs(var3_30) do
		local var4_30 = iter1_30.progress

		if var2_30 < var4_30 and var4_30 <= var1_30 then
			arg0_30:openRepairEffectBoxPanel(iter1_30)

			break
		end
	end
end

function var0_0.openRepairEffectBoxPanel(arg0_31, arg1_31)
	local var0_31 = arg1_31:getAttrAdditionList()
	local var1_31 = #var0_31
	local var2_31 = arg1_31:getDescs()
	local var3_31 = #var2_31
	local var4_31 = 1 + var1_31 + var3_31
	local var5_31 = arg1_31.progress
	local var6_31 = arg0_31:findTF("BG", arg0_31.repairEffectBoxPanel)
	local var7_31 = arg0_31:findTF("Box/BtnContainer/ConfirmBtn", arg0_31.repairEffectBoxPanel)

	onButton(arg0_31, var7_31, function()
		arg0_31:closeRepairEffectBoxPanel()
	end, SFX_CANCEL)

	local var8_31 = arg0_31:findTF("Box/Panel/TypeRepairEffect", arg0_31.repairEffectBoxPanel)
	local var9_31 = arg0_31:findTF("DetailLineTpl", var8_31)
	local var10_31 = UIItemList.New(var8_31, var9_31)

	var10_31:make(function(arg0_33, arg1_33, arg2_33)
		local var0_33 = arg0_31:findTF("AttrLine", arg2_33)
		local var1_33 = arg0_31:findTF("UnlockTipLine", arg2_33)

		if arg0_33 == UIItemList.EventUpdate then
			arg1_33 = arg1_33 + 1

			if arg1_33 == 1 then
				setActive(var0_33, false)
				setActive(var1_33, true)

				local var2_33 = arg0_31:findTF("Text", var1_33)

				setScrollText(var2_33, i18n("meta_repair_effect_special", var5_31))
			elseif arg1_33 > 1 and arg1_33 <= 1 + var1_31 then
				setActive(var0_33, true)
				setActive(var1_33, false)

				local var3_33 = arg0_31:findTF("AttrIcon", var0_33)
				local var4_33 = arg0_31:findTF("AttrNameText", var0_33)
				local var5_33 = arg0_31:findTF("NumText", var0_33)
				local var6_33 = var0_31[arg1_33 - 1]
				local var7_33 = var6_33[1]
				local var8_33 = var6_33[2]

				setImageSprite(var3_33, LoadSprite("attricon", var7_33))
				setText(var4_33, AttributeType.Type2Name(var7_33))
				setText(var5_33, "+" .. var8_33)
			elseif arg1_33 > 1 + var1_31 and arg1_33 <= var4_31 then
				setActive(var0_33, false)
				setActive(var1_33, true)

				local var9_33 = arg0_31:findTF("Text", var1_33)
				local var10_33 = var2_31[arg1_33 - (1 + var1_31)]

				setScrollText(var9_33, var10_33)
			end
		end
	end)
	var10_31:align(var4_31)
	setActive(arg0_31.repairEffectBoxPanel, true)
	pg.UIMgr.GetInstance():BlurPanel(arg0_31.repairEffectBoxPanel, false, {
		weight = LayerWeightConst.TOP_LAYER
	})
end

function var0_0.closeRepairEffectBoxPanel(arg0_34)
	pg.UIMgr.GetInstance():UnblurPanel(arg0_34.repairEffectBoxPanel)
	setActive(arg0_34.repairEffectBoxPanel, false)
end

function var0_0.openDetailPanel(arg0_35)
	setActive(arg0_35.detailPanel, true)
	pg.UIMgr.GetInstance():BlurPanel(arg0_35.detailPanel, false, {
		weight = LayerWeightConst.TOP_LAYER
	})

	arg0_35.isOpening = true

	arg0_35:managedTween(LeanTween.value, nil, go(arg0_35.detailTF), arg0_35.detailTF.rect.width, 0, 0.3):setOnUpdate(System.Action_float(function(arg0_36)
		setAnchoredPosition(arg0_35.detailTF, {
			x = arg0_36
		})
	end)):setOnComplete(System.Action(function()
		arg0_35.isOpening = nil
	end))
end

function var0_0.closeDetailPanel(arg0_38)
	if arg0_38.isClosing or arg0_38.isOpening then
		return
	end

	arg0_38.isClosing = true

	arg0_38:managedTween(LeanTween.value, nil, go(arg0_38.detailTF), 0, arg0_38.detailTF.rect.width, 0.3):setOnUpdate(System.Action_float(function(arg0_39)
		setAnchoredPosition(arg0_38.detailTF, {
			x = arg0_39
		})
	end)):setOnComplete(System.Action(function()
		arg0_38.isClosing = nil

		setActive(arg0_38.detailPanel, false)
		pg.UIMgr.GetInstance():UnblurPanel(arg0_38.detailPanel)
	end))
end

return var0_0
