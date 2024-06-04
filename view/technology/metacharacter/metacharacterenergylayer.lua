local var0 = class("MetaCharacterEnergyLayer", import("...base.BaseUI"))
local var1 = pg.ship_meta_breakout

function var0.getUIName(arg0)
	return "MetaCharacterEnergyUI"
end

function var0.init(arg0)
	arg0:initUITipText()
	arg0:initData()
	arg0:initUI()
	arg0:addListener()
end

function var0.didEnter(arg0)
	arg0:updateShipImg()
	arg0:updateNamePanel()
	arg0:updateChar()
	arg0:updateAttrPanel()
	arg0:updateMaterialPanel()
	arg0:initPreviewPanel()
	arg0:enablePartialBlur()

	if arg0.contextData.isMainOpen then
		arg0.contextData.isMainOpen = nil

		arg0:moveShipImg(true)
	end

	arg0:moveRightPanel()
	arg0:TryPlayGuide()
end

function var0.willExit(arg0)
	arg0:moveShipImg(false)
	arg0:recycleChar()

	if arg0.previewer then
		arg0.previewer:clear()

		arg0.previewer = nil
	end

	arg0:disablePartialBlur()
end

function var0.onBackPressed(arg0)
	if isActive(arg0.previewTF) then
		arg0:closePreviewPanel()

		return
	else
		arg0:emit(var0.ON_BACK_PRESSED)
	end
end

function var0.initUITipText(arg0)
	local var0 = arg0:findTF("Preview/FinalAttrPanel/TitleText")
	local var1 = arg0:findTF("Preview/FinalAttrPanel/TipText")
	local var2 = arg0:findTF("RightPanel/MaterialPanel/StarMax/Text")
	local var3 = arg0:findTF("RightPanel/MaterialPanel/TipText")

	setText(var0, i18n("meta_energy_preview_title"))
	setText(var1, i18n("meta_energy_preview_tip"))
	setText(var2, i18n("word_level_upperLimit"))
	setText(var3, i18n("meta_break"))
end

function var0.initData(arg0)
	arg0.shipPrefab = nil
	arg0.shipModel = nil
	arg0.metaCharacterProxy = getProxy(MetaCharacterProxy)
	arg0.bayProxy = getProxy(BayProxy)
	arg0.curMetaShipID = arg0.contextData.shipID
	arg0.curShipVO = nil
	arg0.curMetaCharacterVO = nil

	arg0:updateData()
end

function var0.initUI(arg0)
	arg0.shipImg = arg0:findTF("ShipImg")
	arg0.nameTF = arg0:findTF("NamePanel")
	arg0.nameScrollText = arg0:findTF("NameMask/NameText", arg0.nameTF)
	arg0.shipTypeImg = arg0:findTF("TypeImg", arg0.nameTF)
	arg0.enNameText = arg0:findTF("NameENText", arg0.nameTF)

	local var0 = arg0:findTF("StarTpl", arg0.nameTF)
	local var1 = arg0:findTF("StarContainer", arg0.nameTF)

	arg0.nameTFStarUIList = UIItemList.New(var1, var0)
	arg0.previewBtn = arg0:findTF("PreviewBtn")
	arg0.rightPanel = arg0:findTF("RightPanel")
	arg0.qCharContain = arg0:findTF("DetailPanel/QChar", arg0.rightPanel)
	arg0.starTpl = arg0:findTF("DetailPanel/RarePanel/StarTpl", arg0.rightPanel)

	setActive(arg0.starTpl, false)

	arg0.starsFrom = arg0:findTF("DetailPanel/RarePanel/StarsFrom", arg0.rightPanel)
	arg0.starsTo = arg0:findTF("DetailPanel/RarePanel/StarsTo", arg0.rightPanel)
	arg0.starOpera = arg0:findTF("DetailPanel/RarePanel/OpImg", arg0.rightPanel)
	arg0.starFromList = UIItemList.New(arg0.starsFrom, arg0.starTpl)
	arg0.starToList = UIItemList.New(arg0.starsTo, arg0.starTpl)
	arg0.attrTpl = arg0:findTF("DetailPanel/AttrTpl", arg0.rightPanel)

	setActive(arg0.attrTpl, false)

	arg0.attrsContainer = arg0:findTF("DetailPanel/AttrsContainer", arg0.rightPanel)
	arg0.attrsList = UIItemList.New(arg0.attrsContainer, arg0.attrTpl)
	arg0.materialPanel = arg0:findTF("MaterialPanel", arg0.rightPanel)
	arg0.levelNumText = arg0:findTF("Info/LevelTipText", arg0.materialPanel)
	arg0.infoTF = arg0:findTF("Info", arg0.materialPanel)
	arg0.repairRateText = arg0:findTF("Info/ProgressTipText", arg0.materialPanel)
	arg0.materialTF = arg0:findTF("Info/Material", arg0.materialPanel)
	arg0.breakOutTipImg = arg0:findTF("TipText", arg0.materialPanel)
	arg0.goldTF = arg0:findTF("Gold", arg0.materialPanel)
	arg0.goldNumText = arg0:findTF("NumText", arg0.goldTF)
	arg0.starMaxTF = arg0:findTF("StarMax", arg0.materialPanel)
	arg0.activeBtn = arg0:findTF("ActiveBtn", arg0.materialPanel)
	arg0.activeBtnDisable = arg0:findTF("ActiveBtnDisable", arg0.materialPanel)
	arg0.previewTF = arg0:findTF("Preview")
	arg0.previewBG = arg0:findTF("BG", arg0.previewTF)
	arg0.previewPanel = arg0:findTF("PreviewPanel", arg0.previewTF)
	arg0.stages = arg0:findTF("StageScrollRect/Stages", arg0.previewPanel)
	arg0.stagesSnap = arg0:findTF("StageScrollRect", arg0.previewPanel):GetComponent("HorizontalScrollSnap")
	arg0.breakView = arg0:findTF("Content/Text", arg0.previewPanel)
	arg0.sea = arg0:findTF("Sea", arg0.previewPanel)
	arg0.rawImage = arg0.sea:GetComponent("RawImage")

	setActive(arg0.rawImage, false)

	arg0.healTF = arg0:findTF("Resources/Heal")
	arg0.healTF.transform.localPosition = Vector3(-360, 50, 40)

	setActive(arg0.healTF, false)

	arg0.seaLoading = arg0:findTF("BG/Loading", arg0.previewPanel)
	arg0.previewAttrTpl = arg0:findTF("FinalAttrPanel/AttrTpl", arg0.previewTF)
	arg0.previewAttrContainer = arg0:findTF("FinalAttrPanel/AttrsContainer", arg0.previewTF)
	arg0.previewAttrUIItemList = UIItemList.New(arg0.previewAttrContainer, arg0.previewAttrTpl)
end

function var0.addListener(arg0)
	onButton(arg0, arg0.previewBtn, function()
		arg0:openPreviewPanel()
	end, SFX_PANEL)
	onButton(arg0, arg0.previewBG, function()
		arg0:closePreviewPanel()
	end, SFX_CANCEL)
	onButton(arg0, arg0.activeBtn, function()
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			content = i18n("meta_energy_active_box_tip"),
			onYes = function()
				pg.m02:sendNotification(GAME.ENERGY_META_ACTIVATION, {
					shipId = arg0.curMetaShipID
				})
			end,
			weight = LayerWeightConst.TOP_LAYER
		})
	end, SFX_PANEL)
end

function var0.updateData(arg0)
	arg0.curShipVO = arg0.bayProxy:getShipById(arg0.curMetaShipID)
	arg0.curMetaCharacterVO = arg0.curShipVO:getMetaCharacter()
end

function var0.TryPlayGuide(arg0)
	pg.SystemGuideMgr.GetInstance():PlayByGuideId("NG0026")
end

function var0.updateShipImg(arg0)
	local var0, var1 = MetaCharacterConst.GetMetaCharacterPaintPath(arg0.curMetaCharacterVO.id, true)

	setImageSprite(arg0.shipImg, LoadSprite(var0, var1), true)

	local var2 = arg0.curMetaCharacterVO.id
	local var3 = MetaCharacterConst.UIConfig[var2]

	setLocalPosition(arg0.shipImg, {
		x = var3[5],
		y = var3[6]
	})
	setLocalScale(arg0.shipImg, {
		x = var3[3],
		y = var3[4]
	})
end

function var0.updateNamePanel(arg0)
	local var0 = arg0.curShipVO
	local var1 = arg0.curMetaCharacterVO
	local var2 = var0:getName()

	setScrollText(arg0.nameScrollText, var2)

	local var3 = var0:getShipType()

	setImageSprite(arg0.shipTypeImg, LoadSprite("shiptype", var3))

	local var4 = var0:getConfig("english_name")

	setText(arg0.enNameText, var4)

	local var5 = var0:getMaxStar()
	local var6 = var0:getStar()

	arg0.nameTFStarUIList:make(function(arg0, arg1, arg2)
		if arg0 == UIItemList.EventUpdate then
			local var0 = arg0:findTF("empty", arg2)
			local var1 = arg0:findTF("on", arg2)

			arg1 = arg1 + 1

			setActive(var1, arg1 <= var6)
		end
	end)
	arg0.nameTFStarUIList:align(var5)
end

function var0.updateChar(arg0)
	return
end

function var0.recycleChar(arg0)
	if arg0.shipPrefab and arg0.shipModel then
		PoolMgr.GetInstance():ReturnSpineChar(arg0.shipPrefab, arg0.shipModel)

		arg0.shipPrefab = nil
		arg0.shipModel = nil
	end
end

function var0.updateAttrPanel(arg0)
	local var0 = arg0.curShipVO
	local var1 = arg0.curMetaCharacterVO:getBreakOutInfo()

	local function var2(arg0, arg1)
		local var0 = var1:getNextInfo()
		local var1 = Clone(var0)

		var1.configId = var0.id

		local var2 = MetaCharacterConst.ENERGY_ATTRS[arg0 + 1]
		local var3 = 0
		local var4 = 0

		if AttributeType.Expend ~= var2 then
			local var5 = var0:getShipProperties()
			local var6 = var1:getShipProperties()

			var3 = math.floor(var5[var2])
			var4 = math.floor(var6[var2])
		else
			var3 = math.floor(var0:getBattleTotalExpend())
			var4 = math.floor(var1:getBattleTotalExpend())
		end

		setText(arg1:Find("NameText"), AttributeType.Type2Name(var2))
		setText(arg1:Find("CurValueText"), var3)
		setActive(arg1:Find("AddValueText"), true)
		setText(arg1:Find("AddValueText"), "+" .. var4 - var3)
		setText(arg1:Find("NextValueText"), var4)
		arg0.starFromList:align(var0:getStar())
		arg0.starToList:align(var1:getStar())
	end

	local function var3(arg0, arg1)
		local var0 = var0:getShipProperties()
		local var1 = MetaCharacterConst.ENERGY_ATTRS[arg0 + 1]
		local var2 = 0

		if AttributeType.Expend ~= var1 then
			local var3 = var0:getShipProperties()

			var2 = math.floor(var3[var1])
		else
			var2 = math.floor(var0:getBattleTotalExpend())
		end

		setText(arg1:Find("NameText"), AttributeType.Type2Name(var1))
		setText(arg1:Find("CurValueText"), var2)
		setText(arg1:Find("NextValueText"), setColorStr(var2, COLOR_GREEN))
		setText(arg1:Find("AddValueText"), "+0")
		setActive(arg1:Find("AddValueText"), false)
		arg0.starFromList:align(var0:getStar())
		arg0.starToList:align(0)
	end

	arg0.attrsList:make(function(arg0, arg1, arg2)
		if arg0 == UIItemList.EventUpdate then
			if var1:hasNextInfo() then
				var2(arg1, arg2)
				setActive(arg0.starOpera, true)
			else
				var3(arg1, arg2)
				setActive(arg0.starOpera, false)
			end
		end
	end)
	arg0.attrsList:align(#MetaCharacterConst.ENERGY_ATTRS)
end

function var0.updateMaterialPanel(arg0, arg1)
	local var0 = arg0.curShipVO
	local var1 = arg0.curMetaCharacterVO
	local var2 = var1:getBreakOutInfo()
	local var3 = getProxy(BagProxy)

	if not var2:hasNextInfo() then
		setActive(arg0.infoTF, false)
		setActive(arg0.breakOutTipImg, false)
		setActive(arg0.goldTF, false)
		setActive(arg0.starMaxTF, true)
		setActive(arg0.activeBtn, false)
		setActive(arg0.activeBtnDisable, true)

		return
	else
		setActive(arg0.infoTF, true)
		setActive(arg0.breakOutTipImg, true)
		setActive(arg0.goldTF, true)
		setActive(arg0.starMaxTF, false)
		setActive(arg0.activeBtn, true)
		setActive(arg0.activeBtnDisable, false)
	end

	local var4 = true
	local var5
	local var6
	local var7, var8 = var2:getConsume()
	local var9
	local var10
	local var11
	local var12 = var8[1].itemId
	local var13 = var8[1].count
	local var14 = var3:getItemCountById(var12)
	local var15 = arg0:findTF("Item", arg0.materialTF)
	local var16 = arg0:findTF("icon_bg/count", var15)
	local var17 = {
		type = DROP_TYPE_ITEM,
		id = var12,
		count = var14
	}

	updateDrop(var15, var17, {
		hideName = true
	})
	onButton(arg0, var15, function()
		arg0:emit(BaseUI.ON_DROP, var17)
	end, SFX_PANEL)
	setText(var16, setColorStr(var14, var14 < var13 and COLOR_RED or COLOR_GREEN) .. "/" .. var13)

	if var14 < var13 then
		var4 = false
	end

	local var18 = getProxy(PlayerProxy):getData().gold

	setText(arg0.goldNumText, var18 < var7 and setColorStr(var7, COLOR_RED) or var7)

	if var18 < var7 then
		var4 = false

		onButton(arg0, arg0.activeBtnDisable, function()
			local var0 = Item.getConfigData(59001).name
			local var1 = i18n("switch_to_shop_tip_2", i18n("word_gold"))
			local var2 = i18n("text_noRes_info_tip", var0, var7 - var18)
			local var3 = var1 .. "\n" .. i18n("text_noRes_tip", var2)

			pg.MsgboxMgr.GetInstance():ShowMsgBox({
				content = var3,
				weight = LayerWeightConst.SECOND_LAYER,
				onYes = function()
					local var0 = getProxy(ContextProxy):getCurrentContext():getContextByMediator(MetaCharacterMediator)

					if var0 then
						var0.data.autoOpenShipConfigID = arg0.curShipVO.configId
						var0.data.autoOpenEnergy = true
					end

					arg0:closeView()
					gotoChargeScene(ChargeScene.TYPE_ITEM)
				end
			})
		end, SFX_PANEL)
	end

	local var19 = arg0.levelNumText
	local var20 = arg0.repairRateText
	local var21
	local var22
	local var23, var24 = var2:getLimited()
	local var25 = var0.level

	var25 = var23 > var0.level and setColorStr(var25, COLOR_RED) or setColorStr(var25, COLOR_GREEN)

	setText(var19, i18n("meta_energy_ship_level_need", var25, var23))

	local var26 = var1:getRepairRate() * 100 .. "%%"

	var26 = var1:getRepairRate() < var24 / 100 and setColorStr(var26, COLOR_RED) or setColorStr(var26, COLOR_GREEN)

	setText(var20, i18n("meta_energy_ship_repairrate_need", var26, var24 .. "%%"))

	if var23 > var0.level then
		var4 = false
	end

	if var1:getRepairRate() < var24 / 100 then
		var4 = false
	end

	setActive(arg0.activeBtn, var4)
	setActive(arg0.activeBtnDisable, not var4)
end

function var0.moveShipImg(arg0, arg1)
	local var0 = arg0.curMetaCharacterVO.id
	local var1 = MetaCharacterConst.UIConfig[var0]
	local var2 = arg1 and -2000 or var1[5]
	local var3 = arg1 and var1[5] or -2000

	arg0:managedTween(LeanTween.moveX, nil, rtf(arg0.shipImg), var3, 0.2):setFrom(var2)
end

function var0.moveRightPanel(arg0)
	local var0 = 2000
	local var1 = 577.64

	arg0:managedTween(LeanTween.moveX, nil, rtf(arg0.rightPanel), var1, 0.2):setFrom(var0)
end

function var0.updatePreviewAttrListPanel(arg0)
	local var0 = arg0.curShipVO
	local var1 = arg0.curMetaCharacterVO
	local var2 = {
		AttributeType.Durability,
		AttributeType.Cannon,
		AttributeType.Torpedo,
		AttributeType.AntiAircraft,
		AttributeType.Air,
		AttributeType.Reload,
		AttributeType.ArmorType,
		AttributeType.Dodge
	}
	local var3 = Clone(var0)

	var3.level = 125

	local var4 = var3:getMetaCharacter()
	local var5 = intProperties(var4:getFinalAddition(var3))

	arg0.previewAttrUIItemList:make(function(arg0, arg1, arg2)
		if arg0 == UIItemList.EventUpdate then
			local var0 = arg0:findTF("AttrIcon", arg2)
			local var1 = arg0:findTF("NameText", arg2)
			local var2 = arg0:findTF("AddValueText", arg2)
			local var3 = var2[arg1 + 1]

			setImageSprite(var0, LoadSprite("attricon", var3))
			setText(var1, AttributeType.Type2Name(var3))

			if var3 == AttributeType.ArmorType then
				setText(var2, var3:getShipArmorName())
			else
				setText(var2, var5[var3] or 0)
			end
		end
	end)
	arg0.previewAttrUIItemList:align(#var2)
end

function var0.initPreviewPanel(arg0, arg1)
	local var0 = arg0.curShipVO
	local var1 = arg0.curMetaCharacterVO

	arg0.breakIds = arg0:getAllBreakIDs(var1.id)

	for iter0 = 1, 3 do
		local var2 = arg0.breakIds[iter0]
		local var3 = var1[var2]
		local var4 = arg0:findTF("Stage" .. iter0, arg0.stages)

		onToggle(arg0, var4, function(arg0)
			if arg0 then
				local var0 = var3.breakout_view
				local var1 = checkExist(pg.ship_data_template[var3.breakout_id], {
					"specific_type"
				}) or {}

				for iter0, iter1 in ipairs(var1) do
					var0 = var0 .. "/" .. i18n(ShipType.SpecificTableTips[iter1])
				end

				changeToScrollText(arg0.breakView, var0)
				arg0:switchStage(var2)
			end
		end, SFX_PANEL)

		if iter0 == 1 then
			triggerToggle(var4, true)
		end
	end

	onButton(arg0, arg0.seaLoading, function()
		if not arg0.previewer then
			arg0:showBarrage()
		end
	end)
	arg0:updatePreviewAttrListPanel()
end

function var0.closePreviewPanel(arg0)
	if arg0.previewer then
		arg0.previewer:clear()

		arg0.previewer = nil
	end

	setActive(arg0.previewTF, false)
	setActive(arg0.rawImage, false)
	pg.UIMgr.GetInstance():UnblurPanel(arg0.previewTF, arg0._tf)
end

function var0.openPreviewPanel(arg0)
	setActive(arg0.previewTF, true)
	pg.UIMgr.GetInstance():BlurPanel(arg0.previewTF, false, {
		weight = LayerWeightConst.TOP_LAYER
	})
	arg0:playLoadingAni()
end

function var0.playLoadingAni(arg0)
	setActive(arg0.seaLoading, true)
end

function var0.stopLoadingAni(arg0)
	setActive(arg0.seaLoading, false)
end

function var0.getAllBreakIDs(arg0, arg1)
	local var0 = {}

	for iter0, iter1 in ipairs(var1.all) do
		if math.floor(iter1 / 10) == arg1 then
			table.insert(var0, iter1)
		end
	end

	return var0
end

function var0.getWaponIdsById(arg0, arg1)
	return var1[arg1].weapon_ids
end

function var0.getAllWeaponIds(arg0)
	local var0 = {}

	for iter0, iter1 in ipairs(arg0.breakIds) do
		local var1 = Clone(var1[iter1].weapon_ids)
		local var2 = {
			__add = function(arg0, arg1)
				for iter0, iter1 in ipairs(arg0) do
					if not table.contains(arg1, iter1) then
						table.insert(arg1, iter1)
					end
				end

				return arg1
			end
		}

		setmetatable(var0, var2)

		var0 = var0 + var1
	end

	return var0
end

function var0.showBarrage(arg0)
	local var0 = arg0.bayProxy:getShipById(arg0.curMetaShipID)
	local var1 = var0:getMetaCharacter()

	arg0.previewer = WeaponPreviewer.New(arg0.rawImage)

	arg0.previewer:configUI(arg0.healTF)
	arg0.previewer:setDisplayWeapon(arg0:getWaponIdsById(arg0.breakOutId))
	arg0.previewer:load(40000, var0, arg0:getAllWeaponIds(), function()
		arg0:stopLoadingAni()
	end)
end

function var0.switchStage(arg0, arg1)
	if arg0.breakOutId == arg1 then
		return
	end

	arg0.breakOutId = arg1

	if arg0.previewer then
		arg0.previewer:setDisplayWeapon(arg0:getWaponIdsById(arg0.breakOutId))
	end
end

function var0.enablePartialBlur(arg0)
	if arg0._tf then
		local var0 = {}

		table.insert(var0, arg0.previewBtn)
		table.insert(var0, arg0.rightPanel)
		pg.UIMgr.GetInstance():OverlayPanelPB(arg0._tf, {
			pbList = var0,
			groupName = LayerWeightConst.GROUP_META,
			weight = LayerWeightConst.BASE_LAYER - 1
		})
	end
end

function var0.disablePartialBlur(arg0)
	if arg0._tf then
		pg.UIMgr.GetInstance():UnOverlayPanel(arg0._tf)
	end
end

return var0
