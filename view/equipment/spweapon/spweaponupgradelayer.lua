local var0_0 = class("SpWeaponUpgradeLayer", import("view.base.BaseUI"))
local var1_0 = 1
local var2_0 = 2
local var3_0 = 1
local var4_0 = 2
local var5_0 = 3
local var6_0 = {
	15015,
	15016,
	15017
}
local var7_0 = {
	typeIndex = IndexConst.SpWeaponTypeAll,
	rarityIndex = IndexConst.SpWeaponRarityAll
}

function var0_0.getUIName(arg0_1)
	return "SpWeaponUpgradeUI"
end

function var0_0.init(arg0_2)
	arg0_2:InitUI()

	arg0_2.consumeItems, arg0_2.consumeSpweapons = {}, {}
	arg0_2.loader = AutoLoader.New()
end

function var0_0.InitUI(arg0_3)
	arg0_3.rightPanel = arg0_3:findTF("Right")
	arg0_3.leftPanel = arg0_3:findTF("Left")
	arg0_3.equipmentPanel = arg0_3:findTF("EquipmentPanel", arg0_3.rightPanel)
	arg0_3.equipmentPanelTitleStrengthen = arg0_3:findTF("Title/Strengthen", arg0_3.equipmentPanel)
	arg0_3.equipmentPanelTitleUpgrade = arg0_3:findTF("Title/Upgrade", arg0_3.equipmentPanel)
	arg0_3.equipmentPanelTitleComposite = arg0_3:findTF("Title/Composite", arg0_3.equipmentPanel)
	arg0_3.equipmentPanelIcon1 = arg0_3:findTF("Container/Equiptpl", arg0_3.equipmentPanel)
	arg0_3.equipmentPanelIcon2 = arg0_3:findTF("Container/Equiptpl2", arg0_3.equipmentPanel)
	arg0_3.equipmentPanelArrow = arg0_3:findTF("Container/Slot", arg0_3.equipmentPanel)
	arg0_3.craftTargetCount = arg0_3:findTF("TotalCount", arg0_3.equipmentPanel)
	arg0_3.materialPanel = arg0_3:findTF("MaterialPanel", arg0_3.rightPanel)
	arg0_3.materialPanelAttrList = arg0_3:findTF("ScrollView/List", arg0_3.materialPanel)
	arg0_3.materialPanelExpLv = arg0_3:findTF("ExpLv", arg0_3.materialPanel)
	arg0_3.materialPanelExpLvText = arg0_3:findTF("ExpLv/Number", arg0_3.materialPanel)

	setActive(arg0_3.materialPanelExpLvText, false)

	arg0_3.materialPanelExpFullText = arg0_3:findTF("ExpFull", arg0_3.materialPanel)
	arg0_3.materialPanelExpBar = arg0_3:findTF("ExpBar", arg0_3.materialPanel)
	arg0_3.materialPanelExpBarFill = arg0_3:findTF("ExpBar/Fill", arg0_3.materialPanel)
	arg0_3.materialPanelExpBarFull = arg0_3:findTF("ExpBar/Full", arg0_3.materialPanel)

	setText(arg0_3:findTF("ExpFull", arg0_3.materialPanel), i18n("spweapon_ui_levelmax"))

	arg0_3.materialPanelExpTotalText = arg0_3:findTF("ExpTotal", arg0_3.materialPanel)
	arg0_3.materialPanelExpCurrentText = arg0_3:findTF("ExpTotal/ExpCurrent", arg0_3.materialPanel)
	arg0_3.materialPanelMaterialList = arg0_3:findTF("Materials/List", arg0_3.materialPanel)
	arg0_3.materialPanelMaterialListLimit = arg0_3:findTF("Materials/Limit", arg0_3.materialPanel)
	arg0_3.materialPanelMaterialItems = CustomIndexLayer.Clone2Full(arg0_3.materialPanelMaterialList, 3)

	setText(arg0_3:findTF("Materials/Title", arg0_3.materialPanel), i18n("spweapon_ui_need_resource"))
	setText(arg0_3:findTF("Materials/Limit/text", arg0_3.materialPanel), i18n("spweapon_ui_levelmax2"))

	arg0_3.materialPanelCostText = arg0_3:findTF("Cost/Consume", arg0_3.materialPanel)
	arg0_3.materialPanelButton = arg0_3:findTF("Button", arg0_3.materialPanel)
	arg0_3.materialPanelButtonUpgrade = arg0_3:findTF("Button/Upgrade", arg0_3.materialPanel)
	arg0_3.materialPanelButtonStrengthen = arg0_3:findTF("Button/Strengthen", arg0_3.materialPanel)
	arg0_3.materialPanelButtonCreate = arg0_3:findTF("Button/Create", arg0_3.materialPanel)

	setText(arg0_3.materialPanelButtonUpgrade, i18n("msgbox_text_breakthrough"))
	setText(arg0_3.materialPanelButtonStrengthen, i18n("msgbox_text_noPos_intensify"))
	setText(arg0_3.materialPanelButtonCreate, i18n("spweapon_ui_create_button"))

	arg0_3.leftPanelAutoSelectButton = arg0_3:findTF("Title/AutoSelect", arg0_3.leftPanel)
	arg0_3.leftPanelClearSelectButton = arg0_3:findTF("Title/ClearSelect", arg0_3.leftPanel)
	arg0_3.leftPanelItem = arg0_3:findTF("Items", arg0_3.leftPanel)

	local var0_3 = arg0_3:findTF("Items/Content", arg0_3.leftPanel)
	local var1_3 = arg0_3:findTF("Items/EquipItem", arg0_3.leftPanel)

	arg0_3.leftPanelItemRect = UIItemList.New(var0_3, var1_3)

	setText(arg0_3:findTF("Items/Top/TextName", arg0_3.leftPanel), i18n("spweapon_ui_ptitem"))
	setText(arg0_3:findTF("On/Text", arg0_3.leftPanelAutoSelectButton), i18n("spweapon_ui_autoselect"))
	setText(arg0_3:findTF("Off/Text", arg0_3.leftPanelAutoSelectButton), i18n("spweapon_ui_autoselect"))
	setText(arg0_3:findTF("On/Text", arg0_3.leftPanelClearSelectButton), i18n("spweapon_ui_cancelselect"))
	setText(arg0_3:findTF("Off/Text", arg0_3.leftPanelClearSelectButton), i18n("spweapon_ui_cancelselect"))

	arg0_3.LeftPanelEquip = arg0_3:findTF("Equips", arg0_3.leftPanel)
	arg0_3.leftPanelEquipScrollComp = GetComponent(arg0_3:findTF("Equips/Scroll View", arg0_3.leftPanel), "LScrollRect")

	setText(arg0_3:findTF("Equips/Top/TextName", arg0_3.leftPanel), i18n("spweapon_ui_spweapon"))

	arg0_3.leftPanelFilterButton = arg0_3:findTF("Equips/Top/Filter", arg0_3.leftPanel)

	setText(arg0_3:findTF("TipText", arg0_3.leftPanel), i18n("spweapon_ui_helptext"))
	setText(arg0_3:findTF("Ship/Detail", arg0_3.equipmentPanel), i18n("spweapon_tip_view"))
	setText(arg0_3:findTF("Ship/Title", arg0_3.equipmentPanel), i18n("spweapon_tip_ship"))
	setText(arg0_3:findTF("ShipType/Title", arg0_3.equipmentPanel), i18n("spweapon_tip_type"))
	setText(arg0_3.craftTargetCount:Find("Tip"), i18n("spweapon_tip_owned", ""))
	Canvas.ForceUpdateCanvases()
end

function var0_0.setItems(arg0_4, arg1_4)
	arg0_4.itemVOs = arg1_4
end

function var0_0.updateRes(arg0_5, arg1_5)
	arg0_5.playerVO = arg1_5
end

function var0_0.SetSpWeapon(arg0_6, arg1_6)
	arg0_6.spWeaponVO = arg1_6
end

function var0_0.SetSpWeaponList(arg0_7, arg1_7)
	arg0_7.spWeaponList = arg1_7
end

function var0_0.didEnter(arg0_8)
	onButton(arg0_8, arg0_8._tf:Find("BG"), function()
		arg0_8:emit(var0_0.ON_CLOSE)
	end, SFX_CANCEL)
	onButton(arg0_8, arg0_8.leftPanelFilterButton, function()
		local var0_10 = {
			indexDatas = Clone(arg0_8.contextData.indexDatas),
			customPanels = {
				typeIndex = {
					mode = CustomIndexLayer.Mode.OR,
					options = IndexConst.SpWeaponTypeIndexs,
					names = IndexConst.SpWeaponTypeNames
				},
				rarityIndex = {
					mode = CustomIndexLayer.Mode.AND,
					options = IndexConst.SpWeaponRarityIndexs,
					names = IndexConst.SpWeaponRarityNames
				}
			},
			groupList = {
				{
					dropdown = false,
					titleTxt = "indexsort_type",
					titleENTxt = "indexsort_typeeng",
					tags = {
						"typeIndex"
					}
				},
				{
					dropdown = false,
					titleTxt = "indexsort_rarity",
					titleENTxt = "indexsort_rarityeng",
					tags = {
						"rarityIndex"
					}
				}
			},
			callback = function(arg0_11)
				arg0_8.contextData.indexDatas.typeIndex = arg0_11.typeIndex
				arg0_8.contextData.indexDatas.rarityIndex = arg0_11.rarityIndex

				arg0_8:UpdateAll()
			end
		}

		arg0_8:emit(SpWeaponUpgradeMediator.OPEN_EQUIPMENT_INDEX, var0_10)
	end, SFX_PANEL)
	onButton(arg0_8, arg0_8.leftPanelAutoSelectButton, function()
		arg0_8:AutoSelectMaterials()
	end)
	onButton(arg0_8, arg0_8.leftPanelClearSelectButton, function()
		table.clear(arg0_8.consumeItems)
		arg0_8:UpdateAll(true)
	end, SFX_CANCEL)

	function arg0_8.leftPanelEquipScrollComp.onInitItem(arg0_14)
		ClearTweenItemAlphaAndWhite(arg0_14.gameObject)
	end

	function arg0_8.leftPanelEquipScrollComp.onUpdateItem(arg0_15, arg1_15)
		arg0_8:UpdateEquipItemByIndex(arg0_15, arg1_15)
	end

	function arg0_8.leftPanelEquipScrollComp.onReturnItem(arg0_16, arg1_16)
		ClearTweenItemAlphaAndWhite(go(arg1_16))
	end

	arg0_8.leftPanelItemRect:make(function(arg0_17, arg1_17, arg2_17)
		arg1_17 = arg1_17 + 1

		if arg0_17 == UIItemList.EventInit then
			pressPersistTrigger(arg2_17:Find("IconTpl"), 0.5, function(arg0_18)
				local var0_18 = arg0_8.candicateMaterials[arg1_17].id
				local var1_18 = arg0_8:GetSelectMaterial(var0_18)
				local var2_18 = var1_18 and var1_18.count or 0
				local var3_18 = arg0_8.itemVOs[var0_18] and arg0_8.itemVOs[var0_18].count or 0

				if arg0_8.ptMax then
					pg.TipsMgr.GetInstance():ShowTips(i18n("spweapon_tip_upgrade"))
					arg0_18()
				elseif var2_18 == var3_18 then
					arg0_18()
				else
					if not var1_18 then
						var1_18 = Item.New({
							count = 0,
							id = var0_18
						})

						table.insert(arg0_8.consumeItems, var1_18)
					end

					var1_18.count = var1_18.count + 1

					arg0_8:UpdateAll(true)
				end
			end, nil, true, true, 0.15, SFX_PANEL)
			pressPersistTrigger(arg2_17:Find("IconTpl/Reduce"), 0.5, function(arg0_19)
				local var0_19 = arg0_8.candicateMaterials[arg1_17].id
				local var1_19 = arg0_8:GetSelectMaterial(var0_19)

				if (var1_19 and var1_19.count or 0) == 0 then
					arg0_19()

					return
				end

				var1_19.count = var1_19.count - 1

				if var1_19.count <= 0 then
					table.removebyvalue(arg0_8.consumeItems, var1_19)
				end

				arg0_8:UpdateAll(true)
			end, nil, true, true, 0.15, SFX_PANEL)
		elseif arg0_17 == UIItemList.EventUpdate then
			local var0_17 = arg0_8.candicateMaterials[arg1_17]

			updateDrop(arg2_17:Find("IconTpl"), Drop.New({
				type = DROP_TYPE_ITEM,
				id = var0_17.id,
				count = var0_17.count
			}))
			setScrollText(arg2_17:Find("Mask/NameText"), var0_17:getConfig("name"))

			local var1_17 = arg2_17:Find("IconTpl/icon_bg/count")

			setText(var1_17, var0_17.count)
			setActive(arg2_17:Find("IconTpl/mask"), var0_17.count == 0)

			local var2_17 = arg0_8:GetSelectMaterial(var0_17.id)

			setActive(arg2_17:Find("IconTpl/Reduce"), var2_17 and var2_17.count > 0)

			if var2_17 then
				setText(arg2_17:Find("IconTpl/Reduce/Text"), var2_17.count)
			end
		end
	end)
	pg.UIMgr.GetInstance():BlurPanel(arg0_8._tf, false, {})

	arg0_8.contextData.indexDatas = arg0_8.contextData.indexDatas or Clone(var7_0)

	arg0_8:UpdateAll()
end

function var0_0.UpdateEquipItemByIndex(arg0_20, arg1_20, arg2_20)
	arg1_20 = arg1_20 + 1

	TweenItemAlphaAndWhite(arg2_20)

	local var0_20 = arg0_20.candicateSpweapons[arg1_20]

	arg0_20:UpdateEquipItem(var0_20, arg2_20)
end

function var0_0.UpdateEquipItem(arg0_21, arg1_21, arg2_21)
	local var0_21 = tf(arg2_21)

	onButton(arg0_21, var0_21, function()
		if arg0_21:GetSelectSpWeapon(arg1_21) then
			return
		end

		if arg0_21.ptMax then
			pg.TipsMgr.GetInstance():ShowTips(i18n("spweapon_tip_upgrade"))

			return
		end

		seriesAsync({
			function(arg0_23)
				if not arg1_21:IsImportant() then
					return arg0_23()
				end

				pg.MsgboxMgr.GetInstance():ShowMsgBox({
					modal = true,
					type = MSGBOX_TYPE_CONFIRM_DELETE,
					title = pg.MsgboxMgr.TITLE_INFORMATION,
					weight = LayerWeightConst.TOP_LAYER,
					onYes = arg0_23,
					data = {
						name = arg1_21:GetName()
					}
				})
			end,
			function()
				table.insert(arg0_21.consumeSpweapons, arg1_21)
				arg0_21:UpdateAll(true)
				arg0_21:UpdateEquipItem(arg1_21, arg2_21)
			end
		})
	end)
	onButton(arg0_21, var0_21:Find("IconTpl/Reduce"), function()
		local var0_25 = arg0_21:GetSelectSpWeapon(arg1_21)

		if not var0_25 then
			return
		end

		table.removebyvalue(arg0_21.consumeSpweapons, var0_25)
		arg0_21:UpdateEquipItem(arg1_21, arg2_21)
		arg0_21:UpdateAll(true)
	end)
	updateSpWeapon(var0_21:Find("IconTpl"), arg1_21)
	setScrollText(var0_21:Find("Mask/NameText"), arg1_21:GetName())

	local var1_21 = arg1_21:GetShipId()

	setActive(var0_21:Find("EquipShip"), var1_21)

	if var1_21 and var1_21 > 0 then
		local var2_21 = getProxy(BayProxy):getShipById(var1_21)

		setImageSprite(var0_21:Find("EquipShip/Image"), LoadSprite("qicon/" .. var2_21:getPainting()))
	end

	local var3_21 = arg0_21:GetSelectSpWeapon(arg1_21)

	setActive(var0_21:Find("IconTpl/Reduce"), var3_21)

	if var3_21 then
		setText(var0_21:Find("IconTpl/Reduce/Text"), 1)
	end
end

function var0_0.UpdateSelectPt(arg0_26)
	arg0_26.nextSpWeaponVO = nil
	arg0_26.upgradeType = nil
	arg0_26.upgradeMaxLevel = false
	arg0_26.ptMax = false

	local var0_26 = arg0_26.spWeaponVO:GetPt() + SpWeapon.CalculateHistoryPt(arg0_26.consumeItems, arg0_26.consumeSpweapons)
	local var1_26 = arg0_26.spWeaponVO:GetConfigID()
	local var2_26 = 0
	local var3_26 = 0
	local var4_26 = 0
	local var5_26 = 0
	local var6_26 = {}

	local function var7_26(arg0_27)
		for iter0_27, iter1_27 in ipairs(arg0_27) do
			local var0_27 = iter1_27[1]
			local var1_27 = underscore.detect(var6_26, function(arg0_28)
				return arg0_28.id == var0_27
			end)

			if not var1_27 then
				var1_27 = Item.New({
					id = var0_27
				})
				var1_27.count = 0

				table.insert(var6_26, var1_27)
			end

			var1_27.count = var1_27.count + iter1_27[2]
		end
	end

	if arg0_26.craftMode == var1_0 then
		local var8_26 = SpWeapon.New({
			id = var1_26
		}):GetUpgradeConfig()

		var3_26 = var3_26 + var8_26.create_use_pt

		var7_26(var8_26.create_use_item)

		var5_26 = var5_26 + var8_26.create_use_gold
		arg0_26.upgradeType = var3_0
	end

	if var3_26 <= var0_26 then
		arg0_26.upgradeType = var4_0

		repeat
			local var9_26 = SpWeapon.New({
				id = var1_26
			})
			local var10_26 = var9_26:GetNextUpgradeID()

			if var10_26 == 0 then
				break
			end

			local var11_26 = var9_26:GetUpgradeConfig()

			var2_26 = var3_26
			var3_26 = var3_26 + var11_26.upgrade_use_pt

			local var12_26 = SpWeapon.New({
				id = var10_26
			})

			if var4_26 > 0 and var12_26:GetRarity() > var9_26:GetRarity() then
				break
			end

			if var12_26:GetRarity() > var9_26:GetRarity() then
				arg0_26.upgradeType = var5_0
			end

			if var0_26 < var3_26 then
				break
			end

			var7_26(var11_26.upgrade_use_item)

			var5_26 = var5_26 + var11_26.upgrade_use_gold
			var4_26 = var4_26 + 1
			var1_26 = var10_26
		until var12_26:GetRarity() > var9_26:GetRarity()
	end

	arg0_26.ptMax = var3_26 <= var0_26

	local var13_26 = math.min(var0_26, var3_26)

	arg0_26.upgradeLevel = var4_26
	arg0_26.upgradePtOrigin = var2_26
	arg0_26.upgradePtTotal = var13_26
	arg0_26.upgradePtMax = var3_26
	arg0_26.upgradNeedMaterials = var6_26
	arg0_26.upgradNeedGold = var5_26
	arg0_26.nextSpWeaponVO = arg0_26.spWeaponVO:MigrateTo(var1_26)

	if arg0_26.craftMode == var2_0 then
		arg0_26.upgradeMaxLevel = arg0_26.spWeaponVO:GetNextUpgradeID() == 0
	end
end

function var0_0.AutoSelectMaterials(arg0_29)
	local var0_29 = arg0_29.spWeaponVO:GetPt() + SpWeapon.CalculateHistoryPt(arg0_29.consumeItems, arg0_29.consumeSpweapons)
	local var1_29 = arg0_29.spWeaponVO:GetConfigID()
	local var2_29 = 0

	if arg0_29.craftMode == var1_0 then
		var2_29 = SpWeapon.New({
			id = var1_29
		}):GetUpgradeConfig().create_use_pt
	end

	while true do
		local var3_29 = SpWeapon.New({
			id = var1_29
		})
		local var4_29 = var3_29:GetNextUpgradeID()

		if var4_29 == 0 then
			break
		end

		var2_29 = var2_29 + var3_29:GetUpgradeConfig().upgrade_use_pt

		if SpWeapon.New({
			id = var4_29
		}):GetRarity() > arg0_29.spWeaponVO:GetRarity() then
			break
		end

		var1_29 = var4_29
	end

	if var2_29 <= var0_29 then
		return
	end

	local var5_29 = _.values(_.map(arg0_29.candicateMaterials, function(arg0_30)
		local var0_30 = arg0_29:GetSelectMaterial(arg0_30.id)
		local var1_30 = arg0_30.count - (var0_30 and var0_30.count or 0)

		return var1_30 > 0 and Item.New({
			id = arg0_30.id,
			count = var1_30
		}) or nil
	end))

	local function var6_29(arg0_31)
		return Item.getConfigData(arg0_31.id).usage_arg[1]
	end

	table.sort(var5_29, function(arg0_32, arg1_32)
		return var6_29(arg0_32) > var6_29(arg1_32)
	end)

	local var7_29 = var2_29 - var0_29
	local var8_29

	local function var9_29(arg0_33, arg1_33, arg2_33)
		local var0_33 = var5_29[arg0_33]

		if not var0_33 then
			return false
		end

		local var1_33 = var6_29(var0_33)
		local var2_33 = math.min(math.ceil(arg1_33 / var1_33), var0_33.count)
		local var3_33 = arg1_33 - var1_33 * var2_33

		arg2_33 = Clone(arg2_33)

		if var3_33 == 0 then
			table.insert(arg2_33, {
				id = var0_33.id,
				count = var2_33
			})

			return true, arg2_33
		elseif var3_33 > 0 then
			local var4_33, var5_33 = var9_29(arg0_33 + 1, var3_33, {})

			if var4_33 then
				table.insert(arg2_33, {
					id = var0_33.id,
					count = var2_33
				})
				table.insertto(arg2_33, var5_33)

				return true, arg2_33
			else
				return false
			end
		elseif var3_33 < 0 then
			local var6_33 = var3_33 + var1_33
			local var7_33, var8_33 = var9_29(arg0_33 + 1, var6_33, {})

			if var7_33 then
				table.insert(arg2_33, {
					id = var0_33.id,
					count = math.max(var2_33 - 1, 0)
				})
				table.insertto(arg2_33, var8_33)

				return true, arg2_33
			else
				table.insert(arg2_33, {
					id = var0_33.id,
					count = math.max(var2_33, 0)
				})

				return true, arg2_33
			end
		end
	end

	local var10_29, var11_29 = var9_29(1, var7_29, {})

	var11_29 = var10_29 and var11_29 or var5_29

	_.each(var11_29, function(arg0_34)
		arg0_29:UpdateSelectMaterial(arg0_34.id, arg0_34.count)
		arg0_29:UpdateAll(true)
	end)
end

function var0_0.UpdateAll(arg0_35, arg1_35)
	arg0_35.craftMode = not arg0_35.spWeaponVO:IsReal() and var1_0 or var2_0

	arg0_35:UpdateSelectPt()

	local var0_35 = arg0_35.craftMode == var2_0 and arg0_35.nextSpWeaponVO:GetConfigID() ~= arg0_35.spWeaponVO:GetConfigID()

	setActive(arg0_35.equipmentPanelIcon2, var0_35)
	setActive(arg0_35.equipmentPanelArrow, var0_35)

	if var0_35 then
		updateSpWeapon(arg0_35.equipmentPanelIcon1, arg0_35.spWeaponVO)
		updateSpWeapon(arg0_35.equipmentPanelIcon2, arg0_35.nextSpWeaponVO)
		arg0_35:UpdateAttrs(arg0_35.materialPanelAttrList, arg0_35.spWeaponVO, arg0_35.nextSpWeaponVO)
	else
		updateSpWeapon(arg0_35.equipmentPanelIcon1, arg0_35.nextSpWeaponVO)
		arg0_35:UpdateAttrs(arg0_35.materialPanelAttrList, arg0_35.nextSpWeaponVO)
	end

	setText(arg0_35.equipmentPanel:Find("Name"), arg0_35.nextSpWeaponVO:GetName())

	local var1_35 = arg0_35.nextSpWeaponVO:IsUnique()

	setActive(arg0_35.equipmentPanel:Find("ShipType"), not var1_35)
	setActive(arg0_35.equipmentPanel:Find("Ship"), var1_35)

	if var1_35 then
		local var2_35 = ShipGroup.getDefaultShipConfig(arg0_35.nextSpWeaponVO:GetUniqueGroup())
		local var3_35 = var2_35 and var2_35.id or nil

		assert(var3_35 and var3_35 > 0)

		if var3_35 and var3_35 > 0 then
			local var4_35 = Ship.New({
				configId = var3_35
			})

			arg0_35.loader:GetSprite("qicon/" .. var4_35:getPainting(), nil, arg0_35.equipmentPanel:Find("Ship/Icon/Image"))

			local function var5_35()
				arg0_35:emit(BaseUI.ON_DROP, {
					type = DROP_TYPE_SHIP,
					id = var3_35
				})
			end

			arg0_35.equipmentPanel:Find("Ship/Detail"):GetComponent("RichText"):AddListener(var5_35)
			onButton(arg0_35, arg0_35.equipmentPanel:Find("Ship/Icon"), var5_35)
		end
	else
		local var6_35 = arg0_35.nextSpWeaponVO:GetWearableShipTypes()
		local var7_35 = _.filter(var6_35, function(arg0_37)
			return table.contains(ShipType.AllShipType, arg0_37)
		end)
		local var8_35 = ShipType.FilterOverQuZhuType(var7_35)

		CustomIndexLayer.Clone2Full(arg0_35.equipmentPanel:Find("ShipType/List"), #var8_35)

		for iter0_35, iter1_35 in ipairs(var8_35) do
			local var9_35 = arg0_35.equipmentPanel:Find("ShipType/List"):GetChild(iter0_35 - 1)

			arg0_35.loader:GetSprite("shiptype", ShipType.Type2CNLabel(iter1_35), var9_35)
		end
	end

	arg0_35:UpdateExpBar()
	arg0_35:UpdateMaterials()
	arg0_35:UpdatePtMaterials(arg1_35)
	arg0_35:UpdateCraftTargetCount()
end

function var0_0.UpdateCraftTargetCount(arg0_38)
	setActive(arg0_38.craftTargetCount, arg0_38.craftMode == var1_0)

	if not arg0_38.craftMode == var1_0 then
		return
	end

	local var0_38 = _.reduce(arg0_38.spWeaponList, 0, function(arg0_39, arg1_39)
		if arg0_38.nextSpWeaponVO:GetOriginID() == arg1_39:GetOriginID() then
			arg0_39 = arg0_39 + 1
		end

		return arg0_39
	end)

	setText(arg0_38.craftTargetCount:Find("Text"), var0_38)
end

function var0_0.UpdateAttrs(arg0_40, arg1_40, arg2_40, arg3_40)
	local var0_40
	local var1_40

	if arg0_40.craftMode == var1_0 then
		var0_40 = SpWeaponHelper.TransformCompositeInfo(arg2_40)
		var1_40 = arg2_40:GetSkillGroup()
		arg3_40 = arg2_40
	elseif arg0_40.craftMode == var2_0 then
		arg3_40 = arg3_40 or arg2_40
		var0_40 = SpWeaponHelper.TransformUpgradeInfo(arg2_40, arg3_40)
		var1_40 = arg3_40:GetSkillGroup()
	end

	arg0_40:UpdateSpWeaponUpgradeInfo(arg1_40, var0_40, var1_40, arg3_40)
end

function var0_0.UpdateSpWeaponUpgradeInfo(arg0_41, arg1_41, arg2_41, arg3_41, arg4_41)
	local var0_41 = arg1_41:Find("attr_tpl")

	removeAllChildren(arg1_41:Find("attrs"))

	local function var1_41(arg0_42, arg1_42)
		local var0_42 = arg0_42:Find("base")
		local var1_42 = arg1_42.name
		local var2_42 = arg1_42.value

		setText(var0_42:Find("name"), var1_42)
		setActive(var0_42:Find("value"), true)
		setText(var0_42:Find("value"), var2_42)
		setActive(var0_42:Find("effect"), false)
		setActive(var0_42:Find("value/up"), arg1_42.compare and arg1_42.compare > 0)
		setActive(var0_42:Find("value/down"), arg1_42.compare and arg1_42.compare < 0)
		triggerToggle(var0_42, arg1_42.lock_open)

		if not arg1_42.lock_open and arg1_42.sub and #arg1_42.sub > 0 then
			GetComponent(var0_42, typeof(Toggle)).enabled = true
		else
			setActive(var0_42:Find("name/close"), false)
			setActive(var0_42:Find("name/open"), false)

			GetComponent(var0_42, typeof(Toggle)).enabled = false
		end
	end

	;(function(arg0_43, arg1_43, arg2_43)
		for iter0_43, iter1_43 in ipairs(arg2_43) do
			local var0_43 = cloneTplTo(arg1_43, arg0_43)

			var1_41(var0_43, iter1_43)
		end
	end)(arg1_41:Find("attrs"), var0_41, arg2_41)

	local var2_41 = {}

	if arg3_41[1].skillId > 0 then
		table.insert(var2_41, {
			name = i18n("spweapon_attr_effect"),
			effect = arg3_41[1]
		})
	end

	if arg3_41[2].skillId > 0 then
		table.insert(var2_41, {
			isSkill = true,
			name = i18n("spweapon_attr_skillupgrade"),
			effect = arg3_41[2]
		})
	end

	local function var3_41(arg0_44, arg1_44)
		local var0_44 = arg0_44:Find("base")
		local var1_44 = arg1_44.name
		local var2_44 = arg1_44.effect

		setText(var0_44:Find("name"), var1_44)
		setActive(var0_44:Find("value"), false)
		setActive(var0_44:Find("effect"), true)

		local var3_44 = getSkillName(var2_44.skillId)

		if not var2_44.unlock then
			var3_44 = setColorStr(var3_44, "#a2a2a2")

			setTextColor(var0_44:Find("effect"), SummerFeastScene.TransformColor("a2a2a2"))
		else
			setTextColor(var0_44:Find("effect"), SummerFeastScene.TransformColor("FFDE00"))
		end

		local var4_44 = "<material=underline event=displaySkill>" .. var3_44 .. "</material>"

		var0_44:Find("effect"):GetComponent("RichText"):AddListener(function(arg0_45, arg1_45)
			if arg0_45 == "displaySkill" then
				local var0_45 = getSkillDesc(var2_44.skillId, var2_44.lv)

				if not var2_44.unlock then
					var0_45 = setColorStr(i18n("spweapon_tip_skill_locked") .. var0_45, "#a2a2a2")
				end

				if not arg1_44.isSkill then
					pg.MsgboxMgr.GetInstance():ShowMsgBox({
						type = MSGBOX_TYPE_SINGLE_ITEM,
						drop = {
							type = DROP_TYPE_SPWEAPON,
							id = arg4_41:GetConfigID()
						},
						name = var3_44,
						content = var0_45
					})
				else
					arg0_41:emit(SpWeaponUpgradeMediator.ON_SKILLINFO, var2_44.skillId, var2_44.unlock, 10)
				end
			end
		end)
		setText(var0_44:Find("effect"), var4_44)
		setActive(var0_44:Find("value/up"), false)
		setActive(var0_44:Find("value/down"), false)
		triggerToggle(var0_44, false)
		setActive(var0_44:Find("name/close"), false)
		setActive(var0_44:Find("name/open"), false)

		GetComponent(var0_44, typeof(Toggle)).enabled = false
	end

	;(function(arg0_46, arg1_46, arg2_46)
		for iter0_46, iter1_46 in ipairs(arg2_46) do
			local var0_46 = cloneTplTo(arg1_46, arg0_46)

			var3_41(var0_46, iter1_46)
		end
	end)(arg1_41:Find("attrs"), var0_41, var2_41)
end

function var0_0.UpdateExpBar(arg0_47)
	local var0_47 = arg0_47.upgradeMaxLevel

	setActive(arg0_47.materialPanelExpLv, not var0_47)
	setActive(arg0_47.materialPanelExpFullText, var0_47)
	setActive(arg0_47.materialPanelExpBarFull, var0_47)

	if not var0_47 then
		setSlider(arg0_47.materialPanelExpBar, 0, 1, (arg0_47.upgradePtTotal - arg0_47.upgradePtOrigin) / (arg0_47.upgradePtMax - arg0_47.upgradePtOrigin))

		if arg0_47.upgradeType == var3_0 then
			setText(arg0_47.materialPanelExpLv, i18n("spweapon_ui_create_exp"))
		elseif arg0_47.upgradeType == var4_0 then
			setText(arg0_47.materialPanelExpLv, i18n("spweapon_ui_upgrade_exp"))
		elseif arg0_47.upgradeType == var5_0 then
			setText(arg0_47.materialPanelExpLv, i18n("spweapon_ui_breakout_exp"))
		end

		setText(arg0_47.materialPanelExpCurrentText, arg0_47.upgradePtTotal - arg0_47.upgradePtOrigin)
		setText(arg0_47.materialPanelExpTotalText, arg0_47.upgradePtMax - arg0_47.upgradePtOrigin)
	else
		setText(arg0_47.materialPanelExpCurrentText, 0)
		setText(arg0_47.materialPanelExpTotalText, 0)
	end
end

function var0_0.UpdateMaterials(arg0_48)
	local var0_48 = arg0_48.upgradNeedMaterials
	local var1_48 = arg0_48.upgradNeedGold
	local var2_48 = arg0_48.spWeaponVO:GetNextUpgradeID() == 0

	setActive(arg0_48.materialPanelMaterialList, not var2_48)
	setActive(arg0_48.materialPanelMaterialListLimit, var2_48)

	local var3_48
	local var4_48 = true

	for iter0_48 = 1, #arg0_48.materialPanelMaterialItems do
		local var5_48 = arg0_48.materialPanelMaterialItems[iter0_48]

		setActive(findTF(var5_48, "off"), not var0_48[iter0_48])
		setActive(findTF(var5_48, "Icon"), var0_48[iter0_48])

		if var0_48[iter0_48] then
			local var6_48 = var0_48[iter0_48]
			local var7_48 = var6_48.id
			local var8_48 = findTF(var5_48, "Icon")
			local var9_48 = {
				type = DROP_TYPE_ITEM,
				id = var6_48.id,
				count = var6_48.count
			}

			updateDrop(var8_48, var9_48)
			onButton(arg0_48, var8_48, function()
				arg0_48:emit(BaseUI.ON_DROP, var9_48)
			end)

			local var10_48 = defaultValue(arg0_48.itemVOs[var7_48], {
				count = 0
			})
			local var11_48 = var6_48.count .. "/" .. var10_48.count

			if var10_48.count < var6_48.count then
				var11_48 = setColorStr(var10_48.count, COLOR_RED) .. "/" .. var6_48.count
				var4_48 = false
				var3_48 = var6_48.id
			end

			local var12_48 = findTF(var8_48, "icon_bg/count")

			setActive(var12_48, true)
			setText(var12_48, var11_48)

			local var13_48 = var8_48:Find("Click")

			setActive(var13_48, not arg0_48.confirmUpgrade and arg0_48.upgradeType == var5_0)
			onButton(arg0_48, var13_48, function()
				arg0_48.confirmUpgrade = true

				setActive(var13_48, not arg0_48.confirmUpgrade)
			end)
		end
	end

	setText(arg0_48.materialPanelCostText, var1_48)
	setActive(arg0_48.materialPanelButtonCreate, arg0_48.craftMode == var1_0)
	setActive(arg0_48.materialPanelButtonUpgrade, arg0_48.craftMode == var2_0 and arg0_48.upgradeType == var5_0)
	setActive(arg0_48.materialPanelButtonStrengthen, arg0_48.craftMode == var2_0 and arg0_48.upgradeType == var4_0)
	setActive(arg0_48.equipmentPanelTitleComposite, arg0_48.craftMode == var1_0)
	setActive(arg0_48.equipmentPanelTitleUpgrade, arg0_48.craftMode == var2_0 and arg0_48.upgradeType == var5_0)
	setActive(arg0_48.equipmentPanelTitleStrengthen, arg0_48.craftMode == var2_0 and arg0_48.upgradeType == var4_0)
	onButton(arg0_48, arg0_48.materialPanelButton, function()
		if not var4_48 then
			if not ItemTipPanel.ShowItemTipbyID(var3_48) then
				pg.TipsMgr.GetInstance():ShowTips(i18n("spweapon_tip_materal_no_enough"))
			end

			return
		end

		if arg0_48.playerVO.gold < var1_48 then
			GoShoppingMsgBox(i18n("switch_to_shop_tip_2", i18n("word_gold")), ChargeScene.TYPE_ITEM, {
				{
					59001,
					var1_48 - arg0_48.playerVO.gold,
					var1_48
				}
			})

			return
		end

		if not arg0_48.confirmUpgrade and arg0_48.upgradeType == var5_0 and #arg0_48.upgradNeedMaterials > 0 then
			pg.TipsMgr.GetInstance():ShowTips(i18n("spweapon_tip_breakout_materal_check"))

			return
		end

		if arg0_48.craftMode == var1_0 then
			arg0_48:emit(SpWeaponUpgradeMediator.EQUIPMENT_COMPOSITE, arg0_48.spWeaponVO:GetConfigID(), arg0_48.consumeItems, arg0_48.consumeSpweapons)
		elseif arg0_48.craftMode == var2_0 then
			arg0_48:emit(SpWeaponUpgradeMediator.EQUIPMENT_UPGRADE, arg0_48.spWeaponVO:GetUID(), arg0_48.consumeItems, arg0_48.consumeSpweapons)
		end
	end, SFX_UI_DOCKYARD_REINFORCE)
	setGray(arg0_48.materialPanelButton, arg0_48.upgradeMaxLevel)
	setButtonEnabled(arg0_48.materialPanelButton, not arg0_48.upgradeMaxLevel)
end

function var0_0.UpdatePtMaterials(arg0_52, arg1_52)
	arg0_52.candicateMaterials = _.map(var6_0, function(arg0_53)
		return arg0_52.itemVOs[arg0_53] or Item.New({
			count = 0,
			id = arg0_53
		})
	end)

	table.sort(arg0_52.candicateMaterials, function(arg0_54, arg1_54)
		return arg0_54.id < arg1_54.id
	end)

	local var0_52 = table.equal(arg0_52.contextData.indexDatas, var7_0)

	setActive(arg0_52.leftPanelFilterButton:Find("Off"), var0_52)
	setActive(arg0_52.leftPanelFilterButton:Find("On"), not var0_52)

	arg0_52.candicateSpweapons = {}

	for iter0_52, iter1_52 in pairs(arg0_52.spWeaponList) do
		if iter1_52:GetUID() ~= arg0_52.spWeaponVO:GetUID() and not iter1_52:IsUnCraftable() and not iter1_52:GetShipId() and IndexConst.filterSpWeaponByType(iter1_52, arg0_52.contextData.indexDatas.typeIndex) and IndexConst.filterSpWeaponByRarity(iter1_52, arg0_52.contextData.indexDatas.rarityIndex) then
			table.insert(arg0_52.candicateSpweapons, iter1_52)
		end
	end

	local var1_52 = SpWeaponSortCfg
	local var2_52 = true

	table.sort(arg0_52.candicateSpweapons, CompareFuncs(var1_52.sortFunc(var1_52.sort[1], var2_52)))
	arg0_52.leftPanelItemRect:align(#arg0_52.candicateMaterials)

	if not arg1_52 then
		arg0_52.leftPanelEquipScrollComp:SetTotalCount(#arg0_52.candicateSpweapons)
	end

	setActive(arg0_52.leftPanelAutoSelectButton:Find("On"), not arg0_52.ptMax)
	setActive(arg0_52.leftPanelAutoSelectButton:Find("Off"), arg0_52.ptMax)
	setButtonEnabled(arg0_52.leftPanelAutoSelectButton, not arg0_52.ptMax)

	local var3_52 = #arg0_52.consumeItems > 0

	setActive(arg0_52.leftPanelClearSelectButton:Find("On"), var3_52)
	setActive(arg0_52.leftPanelClearSelectButton:Find("Off"), not var3_52)
	setButtonEnabled(arg0_52.leftPanelClearSelectButton, var3_52)
end

function var0_0.UpdateSelectMaterial(arg0_55, arg1_55, arg2_55)
	local var0_55 = arg0_55:GetSelectMaterial(arg1_55)
	local var1_55 = var0_55 and var0_55.count or 0
	local var2_55 = arg0_55.itemVOs[arg1_55] and arg0_55.itemVOs[arg1_55].count or 0

	if arg2_55 > 0 then
		if arg0_55.ptMax then
			pg.TipsMgr.GetInstance():ShowTips(i18n("spweapon_tip_upgrade"))

			return true
		end

		local var3_55 = math.max(var2_55 - var1_55, 0)

		arg2_55 = math.min(arg2_55, var3_55)

		if arg2_55 > 0 then
			if not var0_55 then
				var0_55 = Item.New({
					count = 0,
					id = arg1_55
				})

				table.insert(arg0_55.consumeItems, var0_55)
			end

			var0_55.count = var0_55.count + arg2_55
		end

		if var2_55 <= var1_55 + arg2_55 then
			return true
		end
	elseif arg2_55 < 0 then
		local var4_55 = -var1_55

		arg2_55 = math.max(arg2_55, var4_55)

		if arg2_55 < 0 and var0_55 then
			var0_55.count = var0_55.count + arg2_55

			if var0_55.count <= 0 then
				table.removebyvalue(arg0_55.consumeItems, var0_55)
			end
		end

		if var1_55 + arg2_55 <= 0 then
			return true
		end
	end
end

function var0_0.GetSelectMaterial(arg0_56, arg1_56)
	return _.detect(arg0_56.consumeItems, function(arg0_57)
		return arg0_57.id == arg1_56
	end)
end

function var0_0.GetSelectSpWeapon(arg0_58, arg1_58)
	if table.contains(arg0_58.consumeSpweapons, arg1_58) then
		return arg1_58
	end
end

function var0_0.ClearSelectMaterials(arg0_59)
	table.clear(arg0_59.consumeItems)
	table.clear(arg0_59.consumeSpweapons)
end

function var0_0.willExit(arg0_60)
	pg.UIMgr.GetInstance():UnblurPanel(arg0_60._tf)
	arg0_60.loader:Clear()
end

return var0_0
