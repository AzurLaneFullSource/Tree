local var0_0 = class("MetaCharacterEnergyLayer", import("...base.BaseUI"))
local var1_0 = pg.ship_meta_breakout

function var0_0.getUIName(arg0_1)
	return "MetaCharacterEnergyUI"
end

function var0_0.init(arg0_2)
	arg0_2:initUITipText()
	arg0_2:initData()
	arg0_2:initUI()
	arg0_2:addListener()
end

function var0_0.didEnter(arg0_3)
	arg0_3:updateShipImg()
	arg0_3:updateNamePanel()
	arg0_3:updateChar()
	arg0_3:updateAttrPanel()
	arg0_3:updateMaterialPanel()
	arg0_3:initPreviewPanel()
	arg0_3:enablePartialBlur()

	if arg0_3.contextData.isMainOpen then
		arg0_3.contextData.isMainOpen = nil

		arg0_3:moveShipImg(true)
	end

	arg0_3:moveRightPanel()
	arg0_3:TryPlayGuide()
end

function var0_0.willExit(arg0_4)
	arg0_4:moveShipImg(false)
	arg0_4:recycleChar()

	if arg0_4.previewer then
		arg0_4.previewer:clear()

		arg0_4.previewer = nil
	end

	arg0_4:disablePartialBlur()
end

function var0_0.onBackPressed(arg0_5)
	if isActive(arg0_5.previewTF) then
		arg0_5:closePreviewPanel()

		return
	else
		arg0_5:emit(var0_0.ON_BACK_PRESSED)
	end
end

function var0_0.initUITipText(arg0_6)
	local var0_6 = arg0_6:findTF("Preview/FinalAttrPanel/TitleText")
	local var1_6 = arg0_6:findTF("Preview/FinalAttrPanel/TipText")
	local var2_6 = arg0_6:findTF("RightPanel/MaterialPanel/StarMax/Text")
	local var3_6 = arg0_6:findTF("RightPanel/MaterialPanel/TipText")

	setText(var0_6, i18n("meta_energy_preview_title"))
	setText(var1_6, i18n("meta_energy_preview_tip"))
	setText(var2_6, i18n("word_level_upperLimit"))
	setText(var3_6, i18n("meta_break"))
end

function var0_0.initData(arg0_7)
	arg0_7.shipPrefab = nil
	arg0_7.shipModel = nil
	arg0_7.metaCharacterProxy = getProxy(MetaCharacterProxy)
	arg0_7.bayProxy = getProxy(BayProxy)
	arg0_7.curMetaShipID = arg0_7.contextData.shipID
	arg0_7.curShipVO = nil
	arg0_7.curMetaCharacterVO = nil

	arg0_7:updateData()
end

function var0_0.initUI(arg0_8)
	arg0_8.shipImg = arg0_8:findTF("ShipImg")
	arg0_8.nameTF = arg0_8:findTF("NamePanel")
	arg0_8.nameScrollText = arg0_8:findTF("NameMask/NameText", arg0_8.nameTF)
	arg0_8.shipTypeImg = arg0_8:findTF("TypeImg", arg0_8.nameTF)
	arg0_8.enNameText = arg0_8:findTF("NameENText", arg0_8.nameTF)

	local var0_8 = arg0_8:findTF("StarTpl", arg0_8.nameTF)
	local var1_8 = arg0_8:findTF("StarContainer", arg0_8.nameTF)

	arg0_8.nameTFStarUIList = UIItemList.New(var1_8, var0_8)
	arg0_8.previewBtn = arg0_8:findTF("PreviewBtn")
	arg0_8.rightPanel = arg0_8:findTF("RightPanel")
	arg0_8.qCharContain = arg0_8:findTF("DetailPanel/QChar", arg0_8.rightPanel)
	arg0_8.starTpl = arg0_8:findTF("DetailPanel/RarePanel/StarTpl", arg0_8.rightPanel)

	setActive(arg0_8.starTpl, false)

	arg0_8.starsFrom = arg0_8:findTF("DetailPanel/RarePanel/StarsFrom", arg0_8.rightPanel)
	arg0_8.starsTo = arg0_8:findTF("DetailPanel/RarePanel/StarsTo", arg0_8.rightPanel)
	arg0_8.starOpera = arg0_8:findTF("DetailPanel/RarePanel/OpImg", arg0_8.rightPanel)
	arg0_8.starFromList = UIItemList.New(arg0_8.starsFrom, arg0_8.starTpl)
	arg0_8.starToList = UIItemList.New(arg0_8.starsTo, arg0_8.starTpl)
	arg0_8.attrTpl = arg0_8:findTF("DetailPanel/AttrTpl", arg0_8.rightPanel)

	setActive(arg0_8.attrTpl, false)

	arg0_8.attrsContainer = arg0_8:findTF("DetailPanel/AttrsContainer", arg0_8.rightPanel)
	arg0_8.attrsList = UIItemList.New(arg0_8.attrsContainer, arg0_8.attrTpl)
	arg0_8.materialPanel = arg0_8:findTF("MaterialPanel", arg0_8.rightPanel)
	arg0_8.levelNumText = arg0_8:findTF("Info/LevelTipText", arg0_8.materialPanel)
	arg0_8.infoTF = arg0_8:findTF("Info", arg0_8.materialPanel)
	arg0_8.repairRateText = arg0_8:findTF("Info/ProgressTipText", arg0_8.materialPanel)
	arg0_8.materialTF = arg0_8:findTF("Info/Material", arg0_8.materialPanel)
	arg0_8.breakOutTipImg = arg0_8:findTF("TipText", arg0_8.materialPanel)
	arg0_8.goldTF = arg0_8:findTF("Gold", arg0_8.materialPanel)
	arg0_8.goldNumText = arg0_8:findTF("NumText", arg0_8.goldTF)
	arg0_8.starMaxTF = arg0_8:findTF("StarMax", arg0_8.materialPanel)
	arg0_8.activeBtn = arg0_8:findTF("ActiveBtn", arg0_8.materialPanel)
	arg0_8.activeBtnDisable = arg0_8:findTF("ActiveBtnDisable", arg0_8.materialPanel)
	arg0_8.previewTF = arg0_8:findTF("Preview")
	arg0_8.previewBG = arg0_8:findTF("BG", arg0_8.previewTF)
	arg0_8.previewPanel = arg0_8:findTF("PreviewPanel", arg0_8.previewTF)
	arg0_8.stages = arg0_8:findTF("StageScrollRect/Stages", arg0_8.previewPanel)
	arg0_8.stagesSnap = arg0_8:findTF("StageScrollRect", arg0_8.previewPanel):GetComponent("HorizontalScrollSnap")
	arg0_8.breakView = arg0_8:findTF("Content/Text", arg0_8.previewPanel)
	arg0_8.sea = arg0_8:findTF("Sea", arg0_8.previewPanel)
	arg0_8.rawImage = arg0_8.sea:GetComponent("RawImage")

	setActive(arg0_8.rawImage, false)

	arg0_8.healTF = arg0_8:findTF("Resources/Heal")
	arg0_8.healTF.transform.localPosition = Vector3(-360, 50, 40)

	setActive(arg0_8.healTF, false)

	arg0_8.seaLoading = arg0_8:findTF("BG/Loading", arg0_8.previewPanel)
	arg0_8.previewAttrTpl = arg0_8:findTF("FinalAttrPanel/AttrTpl", arg0_8.previewTF)
	arg0_8.previewAttrContainer = arg0_8:findTF("FinalAttrPanel/AttrsContainer", arg0_8.previewTF)
	arg0_8.previewAttrUIItemList = UIItemList.New(arg0_8.previewAttrContainer, arg0_8.previewAttrTpl)
end

function var0_0.addListener(arg0_9)
	onButton(arg0_9, arg0_9.previewBtn, function()
		arg0_9:openPreviewPanel()
	end, SFX_PANEL)
	onButton(arg0_9, arg0_9.previewBG, function()
		arg0_9:closePreviewPanel()
	end, SFX_CANCEL)
	onButton(arg0_9, arg0_9.activeBtn, function()
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			content = i18n("meta_energy_active_box_tip"),
			onYes = function()
				pg.m02:sendNotification(GAME.ENERGY_META_ACTIVATION, {
					shipId = arg0_9.curMetaShipID
				})
			end,
			weight = LayerWeightConst.TOP_LAYER
		})
	end, SFX_PANEL)
end

function var0_0.updateData(arg0_14)
	arg0_14.curShipVO = arg0_14.bayProxy:getShipById(arg0_14.curMetaShipID)
	arg0_14.curMetaCharacterVO = arg0_14.curShipVO:getMetaCharacter()
end

function var0_0.TryPlayGuide(arg0_15)
	pg.SystemGuideMgr.GetInstance():PlayByGuideId("NG0026")
end

function var0_0.updateShipImg(arg0_16)
	local var0_16, var1_16 = MetaCharacterConst.GetMetaCharacterPaintPath(arg0_16.curMetaCharacterVO.id, true)

	setImageSprite(arg0_16.shipImg, LoadSprite(var0_16, var1_16), true)

	local var2_16 = arg0_16.curMetaCharacterVO.id
	local var3_16 = MetaCharacterConst.UIConfig[var2_16]

	setLocalPosition(arg0_16.shipImg, {
		x = var3_16[5],
		y = var3_16[6]
	})
	setLocalScale(arg0_16.shipImg, {
		x = var3_16[3],
		y = var3_16[4]
	})
end

function var0_0.updateNamePanel(arg0_17)
	local var0_17 = arg0_17.curShipVO
	local var1_17 = arg0_17.curMetaCharacterVO
	local var2_17 = var0_17:getName()

	setScrollText(arg0_17.nameScrollText, var2_17)

	local var3_17 = var0_17:getShipType()

	setImageSprite(arg0_17.shipTypeImg, LoadSprite("shiptype", var3_17))

	local var4_17 = var0_17:getConfig("english_name")

	setText(arg0_17.enNameText, var4_17)

	local var5_17 = var0_17:getMaxStar()
	local var6_17 = var0_17:getStar()

	arg0_17.nameTFStarUIList:make(function(arg0_18, arg1_18, arg2_18)
		if arg0_18 == UIItemList.EventUpdate then
			local var0_18 = arg0_17:findTF("empty", arg2_18)
			local var1_18 = arg0_17:findTF("on", arg2_18)

			arg1_18 = arg1_18 + 1

			setActive(var1_18, arg1_18 <= var6_17)
		end
	end)
	arg0_17.nameTFStarUIList:align(var5_17)
end

function var0_0.updateChar(arg0_19)
	return
end

function var0_0.recycleChar(arg0_20)
	if arg0_20.shipPrefab and arg0_20.shipModel then
		PoolMgr.GetInstance():ReturnSpineChar(arg0_20.shipPrefab, arg0_20.shipModel)

		arg0_20.shipPrefab = nil
		arg0_20.shipModel = nil
	end
end

function var0_0.updateAttrPanel(arg0_21)
	local var0_21 = arg0_21.curShipVO
	local var1_21 = arg0_21.curMetaCharacterVO:getBreakOutInfo()

	local function var2_21(arg0_22, arg1_22)
		local var0_22 = var1_21:getNextInfo()
		local var1_22 = Clone(var0_21)

		var1_22.configId = var0_22.id

		local var2_22 = MetaCharacterConst.ENERGY_ATTRS[arg0_22 + 1]
		local var3_22 = 0
		local var4_22 = 0

		if AttributeType.Expend ~= var2_22 then
			local var5_22 = var0_21:getShipProperties()
			local var6_22 = var1_22:getShipProperties()

			var3_22 = math.floor(var5_22[var2_22])
			var4_22 = math.floor(var6_22[var2_22])
		else
			var3_22 = math.floor(var0_21:getBattleTotalExpend())
			var4_22 = math.floor(var1_22:getBattleTotalExpend())
		end

		setText(arg1_22:Find("NameText"), AttributeType.Type2Name(var2_22))
		setText(arg1_22:Find("CurValueText"), var3_22)
		setActive(arg1_22:Find("AddValueText"), true)
		setText(arg1_22:Find("AddValueText"), "+" .. var4_22 - var3_22)
		setText(arg1_22:Find("NextValueText"), var4_22)
		arg0_21.starFromList:align(var0_21:getStar())
		arg0_21.starToList:align(var1_22:getStar())
	end

	local function var3_21(arg0_23, arg1_23)
		local var0_23 = var0_21:getShipProperties()
		local var1_23 = MetaCharacterConst.ENERGY_ATTRS[arg0_23 + 1]
		local var2_23 = 0

		if AttributeType.Expend ~= var1_23 then
			local var3_23 = var0_21:getShipProperties()

			var2_23 = math.floor(var3_23[var1_23])
		else
			var2_23 = math.floor(var0_21:getBattleTotalExpend())
		end

		setText(arg1_23:Find("NameText"), AttributeType.Type2Name(var1_23))
		setText(arg1_23:Find("CurValueText"), var2_23)
		setText(arg1_23:Find("NextValueText"), setColorStr(var2_23, COLOR_GREEN))
		setText(arg1_23:Find("AddValueText"), "+0")
		setActive(arg1_23:Find("AddValueText"), false)
		arg0_21.starFromList:align(var0_21:getStar())
		arg0_21.starToList:align(0)
	end

	arg0_21.attrsList:make(function(arg0_24, arg1_24, arg2_24)
		if arg0_24 == UIItemList.EventUpdate then
			if var1_21:hasNextInfo() then
				var2_21(arg1_24, arg2_24)
				setActive(arg0_21.starOpera, true)
			else
				var3_21(arg1_24, arg2_24)
				setActive(arg0_21.starOpera, false)
			end
		end
	end)
	arg0_21.attrsList:align(#MetaCharacterConst.ENERGY_ATTRS)
end

function var0_0.updateMaterialPanel(arg0_25, arg1_25)
	local var0_25 = arg0_25.curShipVO
	local var1_25 = arg0_25.curMetaCharacterVO
	local var2_25 = var1_25:getBreakOutInfo()
	local var3_25 = getProxy(BagProxy)

	if not var2_25:hasNextInfo() then
		setActive(arg0_25.infoTF, false)
		setActive(arg0_25.breakOutTipImg, false)
		setActive(arg0_25.goldTF, false)
		setActive(arg0_25.starMaxTF, true)
		setActive(arg0_25.activeBtn, false)
		setActive(arg0_25.activeBtnDisable, true)

		return
	else
		setActive(arg0_25.infoTF, true)
		setActive(arg0_25.breakOutTipImg, true)
		setActive(arg0_25.goldTF, true)
		setActive(arg0_25.starMaxTF, false)
		setActive(arg0_25.activeBtn, true)
		setActive(arg0_25.activeBtnDisable, false)
	end

	local var4_25 = true
	local var5_25
	local var6_25
	local var7_25, var8_25 = var2_25:getConsume()
	local var9_25
	local var10_25
	local var11_25
	local var12_25 = var8_25[1].itemId
	local var13_25 = var8_25[1].count
	local var14_25 = var3_25:getItemCountById(var12_25)
	local var15_25 = arg0_25:findTF("Item", arg0_25.materialTF)
	local var16_25 = arg0_25:findTF("icon_bg/count", var15_25)
	local var17_25 = {
		type = DROP_TYPE_ITEM,
		id = var12_25,
		count = var14_25
	}

	updateDrop(var15_25, var17_25, {
		hideName = true
	})
	onButton(arg0_25, var15_25, function()
		arg0_25:emit(BaseUI.ON_DROP, var17_25)
	end, SFX_PANEL)
	setText(var16_25, setColorStr(var14_25, var14_25 < var13_25 and COLOR_RED or COLOR_GREEN) .. "/" .. var13_25)

	if var14_25 < var13_25 then
		var4_25 = false
	end

	local var18_25 = getProxy(PlayerProxy):getData().gold

	setText(arg0_25.goldNumText, var18_25 < var7_25 and setColorStr(var7_25, COLOR_RED) or var7_25)

	if var18_25 < var7_25 then
		var4_25 = false

		onButton(arg0_25, arg0_25.activeBtnDisable, function()
			local var0_27 = Item.getConfigData(59001).name
			local var1_27 = i18n("switch_to_shop_tip_2", i18n("word_gold"))
			local var2_27 = i18n("text_noRes_info_tip", var0_27, var7_25 - var18_25)
			local var3_27 = var1_27 .. "\n" .. i18n("text_noRes_tip", var2_27)

			pg.MsgboxMgr.GetInstance():ShowMsgBox({
				content = var3_27,
				weight = LayerWeightConst.SECOND_LAYER,
				onYes = function()
					local var0_28 = getProxy(ContextProxy):getCurrentContext():getContextByMediator(MetaCharacterMediator)

					if var0_28 then
						var0_28.data.autoOpenShipConfigID = arg0_25.curShipVO.configId
						var0_28.data.autoOpenEnergy = true
					end

					arg0_25:closeView()
					gotoChargeScene(ChargeScene.TYPE_ITEM)
				end
			})
		end, SFX_PANEL)
	end

	local var19_25 = arg0_25.levelNumText
	local var20_25 = arg0_25.repairRateText
	local var21_25
	local var22_25
	local var23_25, var24_25 = var2_25:getLimited()
	local var25_25 = var0_25.level

	var25_25 = var23_25 > var0_25.level and setColorStr(var25_25, COLOR_RED) or setColorStr(var25_25, COLOR_GREEN)

	setText(var19_25, i18n("meta_energy_ship_level_need", var25_25, var23_25))

	local var26_25 = var1_25:getRepairRate() * 100 .. "%%"

	var26_25 = var1_25:getRepairRate() < var24_25 / 100 and setColorStr(var26_25, COLOR_RED) or setColorStr(var26_25, COLOR_GREEN)

	setText(var20_25, i18n("meta_energy_ship_repairrate_need", var26_25, var24_25 .. "%%"))

	if var23_25 > var0_25.level then
		var4_25 = false
	end

	if var1_25:getRepairRate() < var24_25 / 100 then
		var4_25 = false
	end

	setActive(arg0_25.activeBtn, var4_25)
	setActive(arg0_25.activeBtnDisable, not var4_25)
end

function var0_0.moveShipImg(arg0_29, arg1_29)
	local var0_29 = arg0_29.curMetaCharacterVO.id
	local var1_29 = MetaCharacterConst.UIConfig[var0_29]
	local var2_29 = arg1_29 and -2000 or var1_29[5]
	local var3_29 = arg1_29 and var1_29[5] or -2000

	arg0_29:managedTween(LeanTween.moveX, nil, rtf(arg0_29.shipImg), var3_29, 0.2):setFrom(var2_29)
end

function var0_0.moveRightPanel(arg0_30)
	local var0_30 = 2000
	local var1_30 = 577.64

	arg0_30:managedTween(LeanTween.moveX, nil, rtf(arg0_30.rightPanel), var1_30, 0.2):setFrom(var0_30)
end

function var0_0.updatePreviewAttrListPanel(arg0_31)
	local var0_31 = arg0_31.curShipVO
	local var1_31 = arg0_31.curMetaCharacterVO
	local var2_31 = {
		AttributeType.Durability,
		AttributeType.Cannon,
		AttributeType.Torpedo,
		AttributeType.AntiAircraft,
		AttributeType.Air,
		AttributeType.Reload,
		AttributeType.ArmorType,
		AttributeType.Dodge
	}
	local var3_31 = Clone(var0_31)

	var3_31.level = 125

	local var4_31 = var3_31:getMetaCharacter()
	local var5_31 = intProperties(var4_31:getFinalAddition(var3_31))

	arg0_31.previewAttrUIItemList:make(function(arg0_32, arg1_32, arg2_32)
		if arg0_32 == UIItemList.EventUpdate then
			local var0_32 = arg0_31:findTF("AttrIcon", arg2_32)
			local var1_32 = arg0_31:findTF("NameText", arg2_32)
			local var2_32 = arg0_31:findTF("AddValueText", arg2_32)
			local var3_32 = var2_31[arg1_32 + 1]

			setImageSprite(var0_32, LoadSprite("attricon", var3_32))
			setText(var1_32, AttributeType.Type2Name(var3_32))

			if var3_32 == AttributeType.ArmorType then
				setText(var2_32, var3_31:getShipArmorName())
			else
				setText(var2_32, var5_31[var3_32] or 0)
			end
		end
	end)
	arg0_31.previewAttrUIItemList:align(#var2_31)
end

function var0_0.initPreviewPanel(arg0_33, arg1_33)
	local var0_33 = arg0_33.curShipVO
	local var1_33 = arg0_33.curMetaCharacterVO

	arg0_33.breakIds = arg0_33:getAllBreakIDs(var1_33.id)

	for iter0_33 = 1, 3 do
		local var2_33 = arg0_33.breakIds[iter0_33]
		local var3_33 = var1_0[var2_33]
		local var4_33 = arg0_33:findTF("Stage" .. iter0_33, arg0_33.stages)

		onToggle(arg0_33, var4_33, function(arg0_34)
			if arg0_34 then
				local var0_34 = var3_33.breakout_view
				local var1_34 = checkExist(pg.ship_data_template[var3_33.breakout_id], {
					"specific_type"
				}) or {}

				for iter0_34, iter1_34 in ipairs(var1_34) do
					var0_34 = var0_34 .. "/" .. i18n(ShipType.SpecificTableTips[iter1_34])
				end

				changeToScrollText(arg0_33.breakView, var0_34)
				arg0_33:switchStage(var2_33)
			end
		end, SFX_PANEL)

		if iter0_33 == 1 then
			triggerToggle(var4_33, true)
		end
	end

	onButton(arg0_33, arg0_33.seaLoading, function()
		if not arg0_33.previewer then
			arg0_33:showBarrage()
		end
	end)
	arg0_33:updatePreviewAttrListPanel()
end

function var0_0.closePreviewPanel(arg0_36)
	if arg0_36.previewer then
		arg0_36.previewer:clear()

		arg0_36.previewer = nil
	end

	setActive(arg0_36.previewTF, false)
	setActive(arg0_36.rawImage, false)
	pg.UIMgr.GetInstance():UnblurPanel(arg0_36.previewTF, arg0_36._tf)
end

function var0_0.openPreviewPanel(arg0_37)
	setActive(arg0_37.previewTF, true)
	pg.UIMgr.GetInstance():BlurPanel(arg0_37.previewTF, false, {
		weight = LayerWeightConst.TOP_LAYER
	})
	arg0_37:playLoadingAni()
end

function var0_0.playLoadingAni(arg0_38)
	setActive(arg0_38.seaLoading, true)
end

function var0_0.stopLoadingAni(arg0_39)
	setActive(arg0_39.seaLoading, false)
end

function var0_0.getAllBreakIDs(arg0_40, arg1_40)
	local var0_40 = {}

	for iter0_40, iter1_40 in ipairs(var1_0.all) do
		if math.floor(iter1_40 / 10) == arg1_40 then
			table.insert(var0_40, iter1_40)
		end
	end

	return var0_40
end

function var0_0.getWaponIdsById(arg0_41, arg1_41)
	return var1_0[arg1_41].weapon_ids
end

function var0_0.getAllWeaponIds(arg0_42)
	local var0_42 = {}

	for iter0_42, iter1_42 in ipairs(arg0_42.breakIds) do
		local var1_42 = Clone(var1_0[iter1_42].weapon_ids)
		local var2_42 = {
			__add = function(arg0_43, arg1_43)
				for iter0_43, iter1_43 in ipairs(arg0_43) do
					if not table.contains(arg1_43, iter1_43) then
						table.insert(arg1_43, iter1_43)
					end
				end

				return arg1_43
			end
		}

		setmetatable(var0_42, var2_42)

		var0_42 = var0_42 + var1_42
	end

	return var0_42
end

function var0_0.showBarrage(arg0_44)
	local var0_44 = arg0_44.bayProxy:getShipById(arg0_44.curMetaShipID)
	local var1_44 = var0_44:getMetaCharacter()

	arg0_44.previewer = WeaponPreviewer.New(arg0_44.rawImage)

	arg0_44.previewer:configUI(arg0_44.healTF)
	arg0_44.previewer:setDisplayWeapon(arg0_44:getWaponIdsById(arg0_44.breakOutId))
	arg0_44.previewer:load(40000, var0_44, arg0_44:getAllWeaponIds(), function()
		arg0_44:stopLoadingAni()
	end)
end

function var0_0.switchStage(arg0_46, arg1_46)
	if arg0_46.breakOutId == arg1_46 then
		return
	end

	arg0_46.breakOutId = arg1_46

	if arg0_46.previewer then
		arg0_46.previewer:setDisplayWeapon(arg0_46:getWaponIdsById(arg0_46.breakOutId))
	end
end

function var0_0.enablePartialBlur(arg0_47)
	if arg0_47._tf then
		local var0_47 = {}

		table.insert(var0_47, arg0_47.previewBtn)
		table.insert(var0_47, arg0_47.rightPanel)
		pg.UIMgr.GetInstance():OverlayPanelPB(arg0_47._tf, {
			pbList = var0_47,
			groupName = LayerWeightConst.GROUP_META,
			weight = LayerWeightConst.BASE_LAYER - 1
		})
	end
end

function var0_0.disablePartialBlur(arg0_48)
	if arg0_48._tf then
		pg.UIMgr.GetInstance():UnOverlayPanel(arg0_48._tf)
	end
end

return var0_0
