local var0 = class("MetaCharacterRepairLayer", import("...base.BaseUI"))

function var0.getUIName(arg0)
	return "MetaCharacterRepairUI"
end

function var0.init(arg0)
	arg0:initTipText()
	arg0:initData()
	arg0:findUI()
	arg0:addListener()

	for iter0, iter1 in ipairs(MetaCharacterConst.REPAIR_ATTRS) do
		if not arg0.curMetaCharacterVO:getAttrVO(iter1):isLock() then
			triggerToggle(arg0.attrTFList[iter1], true)

			break
		end
	end
end

function var0.didEnter(arg0)
	arg0:doRepairProgressPanelAni()
	arg0:updateAttrListPanel()
	arg0:updateRepairBtn(true)
	arg0:updateDetailPanel()
	arg0:TryPlayGuide()
end

function var0.willExit(arg0)
	return
end

function var0.onBackPressed(arg0)
	if isActive(arg0.repairEffectBoxPanel) then
		arg0:closeRepairEffectBoxPanel()

		return
	elseif isActive(arg0.detailPanel) then
		arg0:closeDetailPanel()

		return
	else
		arg0:emit(var0.ON_BACK_PRESSED)
	end
end

function var0.initTipText(arg0)
	local var0 = arg0:findTF("Repair/AttrListPanel/AttrItemContainer/AttrItemCannon/SelectedPanel/AttrRepairTipText")
	local var1 = arg0:findTF("Repair/AttrListPanel/AttrItemContainer/AttrItemTorpedo/SelectedPanel/AttrRepairTipText")
	local var2 = arg0:findTF("Repair/AttrListPanel/AttrItemContainer/AttrItemAir/SelectedPanel/AttrRepairTipText")
	local var3 = arg0:findTF("Repair/AttrListPanel/AttrItemContainer/AttrItemReload/SelectedPanel/AttrRepairTipText")

	setText(var0, i18n("meta_repair"))
	setText(var1, i18n("meta_repair"))
	setText(var2, i18n("meta_repair"))
	setText(var3, i18n("meta_repair"))
end

function var0.initData(arg0)
	arg0.metaCharacterProxy = getProxy(MetaCharacterProxy)
	arg0.bayProxy = getProxy(BayProxy)
	arg0.attrTFList = {}
	arg0.curAttrName = nil
	arg0.curMetaShipID = arg0.contextData.shipID
	arg0.curShipVO = nil
	arg0.curMetaCharacterVO = nil

	arg0:updateData()
end

function var0.findUI(arg0)
	arg0.repairPanel = arg0:findTF("Repair")
	arg0.attrListPanel = arg0:findTF("AttrListPanel", arg0.repairPanel)
	arg0.attrItemContainer = arg0:findTF("AttrItemContainer", arg0.attrListPanel)
	arg0.attrCannonTF = arg0:findTF("AttrItemCannon", arg0.attrItemContainer)
	arg0.attrTorpedoTF = arg0:findTF("AttrItemTorpedo", arg0.attrItemContainer)
	arg0.attrAirTF = arg0:findTF("AttrItemAir", arg0.attrItemContainer)
	arg0.attrReloadTF = arg0:findTF("AttrItemReload", arg0.attrItemContainer)
	arg0.attrTFList.cannon = arg0.attrCannonTF
	arg0.attrTFList.torpedo = arg0.attrTorpedoTF
	arg0.attrTFList.air = arg0.attrAirTF
	arg0.attrTFList.reload = arg0.attrReloadTF
	arg0.repairPercentText = arg0:findTF("SynProgressPanel/SynRate/NumTextText", arg0.repairPanel)
	arg0.repairSliderTF = arg0:findTF("SynProgressPanel/Slider", arg0.repairPanel)
	arg0.repairBtn = arg0:findTF("RepairBtn", arg0.repairPanel)
	arg0.repairBtnDisable = arg0:findTF("RepairBtnDisable", arg0.repairPanel)
	arg0.showDetailLine = arg0:findTF("ShowDetailLine")
	arg0.showDetailBtn = arg0:findTF("ShowDetailBtn", arg0.showDetailLine)
	arg0.detailPanel = arg0:findTF("Detail")
	arg0.detailBG = arg0:findTF("BG", arg0.detailPanel)
	arg0.detailTF = arg0:findTF("Panel", arg0.detailPanel)
	arg0.detailCloseBtn = arg0:findTF("CloseBtn", arg0.detailTF)
	arg0.detailLineTpl = arg0:findTF("DetailLineTpl", arg0.detailTF)
	arg0.detailItemTpl = arg0:findTF("DetailItemTpl", arg0.detailTF)
	arg0.detailItemContainer = arg0:findTF("ScrollView/Viewport/Content", arg0.detailTF)
	arg0.repairEffectBoxPanel = arg0:findTF("RepairEffectBox")
end

function var0.addListener(arg0)
	for iter0, iter1 in pairs(arg0.attrTFList) do
		onToggle(arg0, iter1, function(arg0)
			if arg0 == true then
				arg0.curAttrName = iter0

				arg0:updateRepairBtn()
			else
				arg0.curAttrName = nil

				arg0:updateRepairBtn(true)
			end
		end, SFX_PANEL)
	end

	onButton(arg0, arg0.repairBtn, function()
		pg.m02:sendNotification(GAME.REPAIR_META_CHARACTER, {
			shipID = arg0.curMetaShipID,
			attr = arg0.curAttrName
		})
	end, SFX_PANEL)
	onButton(arg0, arg0.showDetailBtn, function()
		if not isActive(arg0.detailPanel) then
			arg0:openDetailPanel()
		end
	end, SFX_PANEL)
	onButton(arg0, arg0.showDetailLine, function()
		if not isActive(arg0.detailPanel) then
			arg0:openDetailPanel()
		end
	end, SFX_PANEL)
	onButton(arg0, arg0.detailCloseBtn, function()
		arg0:closeDetailPanel()
	end, SFX_CANCEL)
	onButton(arg0, arg0.detailBG, function()
		arg0:closeDetailPanel()
	end, SFX_CANCEL)
end

function var0.TryPlayGuide(arg0)
	pg.SystemGuideMgr.GetInstance():PlayByGuideId("NG0027")
end

function var0.doRepairProgressPanelAni(arg0)
	local var0 = arg0.curMetaCharacterVO:getRepairRate()
	local var1 = GetComponent(arg0.repairSliderTF, typeof(Slider))

	var1.minValue = 0
	var1.maxValue = 1

	local var2 = var1.value

	if var0 > 0 then
		local var3 = 0.5

		arg0:managedTween(LeanTween.value, nil, go(arg0.repairSliderTF), var2, var0, var3):setOnUpdate(System.Action_float(function(arg0)
			arg0:updateRepairProgressPanel(arg0)
		end)):setOnComplete(System.Action(function()
			arg0:updateRepairProgressPanel(var0)
		end))
	else
		arg0:updateRepairProgressPanel(var0)
	end
end

function var0.updateRepairProgressPanel(arg0, arg1)
	local var0 = arg1 or arg0.curMetaCharacterVO:getRepairRate()

	setSlider(arg0.repairSliderTF, 0, 1, var0)
	setText(arg0.repairPercentText, string.format("%d", var0 * 100))
end

function var0.updateAttrListPanel(arg0)
	for iter0, iter1 in ipairs(MetaCharacterConst.REPAIR_ATTRS) do
		arg0:updateAttrItem(arg0.attrTFList[iter1], iter1)
	end
end

function var0.updateAttrItem(arg0, arg1, arg2)
	local var0 = arg0:findTF("LockPanel", arg1)
	local var1 = arg0:findTF("UnSelectPanel", arg1)
	local var2 = arg0:findTF("SelectedPanel", arg1)
	local var3 = arg0:findTF("TitleImg", var2)

	GetComponent(var3, "Image"):SetNativeSize()

	local var4 = arg0.curMetaCharacterVO:getAttrVO(arg2)

	if var4:isLock() then
		setActive(var1, false)
		setActive(var2, false)
		setActive(var0, true)

		arg1:GetComponent("Toggle").interactable = false
	else
		local var5 = arg1:GetComponent("Toggle")

		setActive(var1, not var5.isOn)
		setActive(var2, var5.isOn)
		setActive(var0, false)

		var5.interactable = true

		local var6 = arg0:findTF("ValueText", var1)
		local var7 = arg0:findTF("ValueText", var2)
		local var8 = arg0:findTF("AttrRepairValue/CurValueText", var2)
		local var9 = arg0:findTF("AttrRepairValue/Image", var2)
		local var10 = arg0:findTF("AttrRepairValue/NextValueText", var2)
		local var11 = arg0:findTF("IconTpl", var2)
		local var12 = arg0:findTF("ItemCount", var2)
		local var13 = arg0:findTF("NumText", var12)
		local var14 = var4:getAddition()

		setText(var6, "+" .. var14)
		setText(var7, "+" .. var14)
		setText(var8, "+" .. var14)

		local var15 = var4:getLevel()
		local var16 = var4:isMaxLevel()
		local var17

		if not var16 then
			var17 = var4:getItem()
		else
			var17 = var4:getItemByLevel(var15 - 1)
		end

		local var18 = var17:getItemId()
		local var19 = var17:getTotalCnt()
		local var20 = getProxy(BagProxy):getItemCountById(var18)

		if var20 < var19 then
			var20 = setColorStr(var20, COLOR_RED)
		end

		setText(var13, var20 .. "/" .. var19)

		local var21 = {
			type = DROP_TYPE_ITEM,
			id = var18,
			count = var19
		}

		updateDrop(var11, var21, {
			hideName = true
		})
		onButton(arg0, var11, function()
			arg0:emit(BaseUI.ON_DROP, var21)
		end, SFX_PANEL)
		setActive(var9, not var16)
		setActive(var10, not var16)

		if var16 then
			setText(var10, var14)
		else
			local var22 = var17:getAdditionValue()

			setText(var10, "+" .. var14 + var22)
		end

		if var16 then
			setActive(var11, false)
			setActive(var12, false)
		else
			setActive(var11, true)
			setActive(var12, true)
		end
	end
end

function var0.updateRepairBtn(arg0, arg1)
	if arg1 == true then
		setActive(arg0.repairBtn, false)
		setActive(arg0.repairBtnDisable, false)

		return
	end

	local var0 = arg0.curMetaCharacterVO:getAttrVO(arg0.curAttrName)
	local var1 = var0:getLevel()
	local var2 = var0:isMaxLevel()
	local var3

	if not var2 then
		var3 = var0:getItem()
	else
		var3 = var0:getItemByLevel(var1 - 1)
	end

	local var4 = var3:getItemId()
	local var5 = var3:getTotalCnt() <= getProxy(BagProxy):getItemCountById(var4)

	if var2 then
		setActive(arg0.repairBtn, false)
		setActive(arg0.repairBtnDisable, false)
	elseif not var5 then
		setActive(arg0.repairBtn, false)
		setActive(arg0.repairBtnDisable, true)
	else
		setActive(arg0.repairBtn, true)
		setActive(arg0.repairBtnDisable, false)
	end
end

function var0.updateDetailItem(arg0, arg1, arg2)
	local var0 = arg0:findTF("LineContainer", arg1)
	local var1 = arg0:findTF("LockPanel", arg1)
	local var2 = arg0:findTF("TipText", var1)
	local var3 = arg2.progress

	setText(var2, i18n("meta_repair_effect_unlock", var3))

	local var4 = arg0.curMetaCharacterVO:getRepairRate()

	setActive(var1, not (var3 <= var4 * 100))

	local var5 = arg2:getAttrAdditionList()
	local var6 = #var5
	local var7 = arg2:getDescs()
	local var8 = var6 + #var7 + 1
	local var9 = UIItemList.New(var0, arg0.detailLineTpl)

	var9:make(function(arg0, arg1, arg2)
		local var0 = arg0:findTF("AttrLine", arg2)
		local var1 = arg0:findTF("UnlockTipLine", arg2)
		local var2 = arg0:findTF("Text", arg2)

		if arg0 == UIItemList.EventUpdate then
			arg1 = arg1 + 1

			if arg1 == 1 then
				setActive(var0, false)
				setActive(var1, false)
				setActive(var2, true)
				setText(var2, i18n("meta_repair_effect_unlock", var3))

				return
			end

			if arg1 <= var6 + 1 then
				setActive(var0, true)
				setActive(var1, false)

				local var3 = arg0:findTF("AttrIcon", var0)
				local var4 = arg0:findTF("AttrNameText", var0)
				local var5 = arg0:findTF("NumText", var0)
				local var6 = var5[arg1 - 1]
				local var7 = var6[1]
				local var8 = var6[2]

				setImageSprite(var3, LoadSprite("attricon", var7))
				setText(var4, AttributeType.Type2Name(var7))
				setText(var5, "+" .. var8)
			else
				setActive(var0, false)
				setActive(var1, true)

				local var9 = arg0:findTF("Text", var1)
				local var10 = var7[arg1 - 1 - var6]

				setScrollText(var9, var10)
			end
		end
	end)
	var9:align(var8)
end

function var0.updateDetailPanel(arg0)
	setActive(arg0.detailPanel, false)

	local var0 = arg0.curMetaCharacterVO:getEffects()

	arg0.detailList = UIItemList.New(arg0.detailItemContainer, arg0.detailItemTpl)

	arg0.detailList:make(function(arg0, arg1, arg2)
		if arg0 == UIItemList.EventUpdate then
			local var0 = var0[arg1 + 1]

			arg0:updateDetailItem(arg2, var0)
		end
	end)
	arg0.detailList:align(#var0)
end

function var0.updateData(arg0)
	arg0.curShipVO = arg0.bayProxy:getShipById(arg0.curMetaShipID)
	arg0.curMetaCharacterVO = arg0.curShipVO:getMetaCharacter()
end

function var0.checkSpecialEffect(arg0)
	local var0 = arg0.bayProxy:getShipById(arg0.curMetaShipID):getMetaCharacter()
	local var1 = var0:getRepairRate() * 100
	local var2 = arg0.curMetaCharacterVO:getRepairRate() * 100
	local var3 = var0:getEffects()

	for iter0, iter1 in ipairs(var3) do
		local var4 = iter1.progress

		if var2 < var4 and var4 <= var1 then
			arg0:openRepairEffectBoxPanel(iter1)

			break
		end
	end
end

function var0.openRepairEffectBoxPanel(arg0, arg1)
	local var0 = arg1:getAttrAdditionList()
	local var1 = #var0
	local var2 = arg1:getDescs()
	local var3 = #var2
	local var4 = 1 + var1 + var3
	local var5 = arg1.progress
	local var6 = arg0:findTF("BG", arg0.repairEffectBoxPanel)
	local var7 = arg0:findTF("Box/BtnContainer/ConfirmBtn", arg0.repairEffectBoxPanel)

	onButton(arg0, var7, function()
		arg0:closeRepairEffectBoxPanel()
	end, SFX_CANCEL)

	local var8 = arg0:findTF("Box/Panel/TypeRepairEffect", arg0.repairEffectBoxPanel)
	local var9 = arg0:findTF("DetailLineTpl", var8)
	local var10 = UIItemList.New(var8, var9)

	var10:make(function(arg0, arg1, arg2)
		local var0 = arg0:findTF("AttrLine", arg2)
		local var1 = arg0:findTF("UnlockTipLine", arg2)

		if arg0 == UIItemList.EventUpdate then
			arg1 = arg1 + 1

			if arg1 == 1 then
				setActive(var0, false)
				setActive(var1, true)

				local var2 = arg0:findTF("Text", var1)

				setScrollText(var2, i18n("meta_repair_effect_special", var5))
			elseif arg1 > 1 and arg1 <= 1 + var1 then
				setActive(var0, true)
				setActive(var1, false)

				local var3 = arg0:findTF("AttrIcon", var0)
				local var4 = arg0:findTF("AttrNameText", var0)
				local var5 = arg0:findTF("NumText", var0)
				local var6 = var0[arg1 - 1]
				local var7 = var6[1]
				local var8 = var6[2]

				setImageSprite(var3, LoadSprite("attricon", var7))
				setText(var4, AttributeType.Type2Name(var7))
				setText(var5, "+" .. var8)
			elseif arg1 > 1 + var1 and arg1 <= var4 then
				setActive(var0, false)
				setActive(var1, true)

				local var9 = arg0:findTF("Text", var1)
				local var10 = var2[arg1 - (1 + var1)]

				setScrollText(var9, var10)
			end
		end
	end)
	var10:align(var4)
	setActive(arg0.repairEffectBoxPanel, true)
	pg.UIMgr.GetInstance():BlurPanel(arg0.repairEffectBoxPanel, false, {
		weight = LayerWeightConst.TOP_LAYER
	})
end

function var0.closeRepairEffectBoxPanel(arg0)
	pg.UIMgr.GetInstance():UnblurPanel(arg0.repairEffectBoxPanel)
	setActive(arg0.repairEffectBoxPanel, false)
end

function var0.openDetailPanel(arg0)
	setActive(arg0.detailPanel, true)
	pg.UIMgr.GetInstance():BlurPanel(arg0.detailPanel, false, {
		weight = LayerWeightConst.TOP_LAYER
	})

	arg0.isOpening = true

	arg0:managedTween(LeanTween.value, nil, go(arg0.detailTF), arg0.detailTF.rect.width, 0, 0.3):setOnUpdate(System.Action_float(function(arg0)
		setAnchoredPosition(arg0.detailTF, {
			x = arg0
		})
	end)):setOnComplete(System.Action(function()
		arg0.isOpening = nil
	end))
end

function var0.closeDetailPanel(arg0)
	if arg0.isClosing or arg0.isOpening then
		return
	end

	arg0.isClosing = true

	arg0:managedTween(LeanTween.value, nil, go(arg0.detailTF), 0, arg0.detailTF.rect.width, 0.3):setOnUpdate(System.Action_float(function(arg0)
		setAnchoredPosition(arg0.detailTF, {
			x = arg0
		})
	end)):setOnComplete(System.Action(function()
		arg0.isClosing = nil

		setActive(arg0.detailPanel, false)
		pg.UIMgr.GetInstance():UnblurPanel(arg0.detailPanel)
	end))
end

return var0
