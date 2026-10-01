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

function var0_0.getResource(arg0_2, arg1_2)
	local var0_2 = {
		"weaponframes",
		"shiptype",
		"ui/iconcolorful",
		"ui/CustomIndexUI",
		"ui/SkillInfoUI",
		"ui/MsgBox"
	}

	table.insertto(var0_2, var0_0.super.getResource(arg0_2, arg1_2))

	return var0_2
end

function var0_0.init(arg0_3)
	arg0_3:InitUI()

	arg0_3.consumeItems, arg0_3.consumeSpweapons = {}, {}
	arg0_3.loader = AutoLoader.New()
end

function var0_0.InitUI(arg0_4)
	arg0_4.rightPanel = arg0_4._tf:Find("Right")
	arg0_4.leftPanel = arg0_4._tf:Find("Left")
	arg0_4.equipmentPanel = arg0_4.rightPanel:Find("EquipmentPanel")
	arg0_4.equipmentPanelTitleStrengthen = arg0_4.equipmentPanel:Find("Title/Strengthen")
	arg0_4.equipmentPanelTitleUpgrade = arg0_4.equipmentPanel:Find("Title/Upgrade")
	arg0_4.equipmentPanelTitleComposite = arg0_4.equipmentPanel:Find("Title/Composite")
	arg0_4.equipmentPanelIcon1 = arg0_4.equipmentPanel:Find("Container/Equiptpl")
	arg0_4.equipmentPanelIcon2 = arg0_4.equipmentPanel:Find("Container/Equiptpl2")
	arg0_4.equipmentPanelArrow = arg0_4.equipmentPanel:Find("Container/Slot")
	arg0_4.craftTargetCount = arg0_4.equipmentPanel:Find("TotalCount")
	arg0_4.materialPanel = arg0_4.rightPanel:Find("MaterialPanel")
	arg0_4.materialPanelAttrList = arg0_4.materialPanel:Find("ScrollView/List")
	arg0_4.materialPanelExpLv = arg0_4.materialPanel:Find("ExpLv")
	arg0_4.materialPanelExpLvText = arg0_4.materialPanel:Find("ExpLv/Number")

	setActive(arg0_4.materialPanelExpLvText, false)

	arg0_4.materialPanelExpFullText = arg0_4.materialPanel:Find("ExpFull")
	arg0_4.materialPanelExpBar = arg0_4.materialPanel:Find("ExpBar")
	arg0_4.materialPanelExpBarFill = arg0_4.materialPanel:Find("ExpBar/Fill")
	arg0_4.materialPanelExpBarFull = arg0_4.materialPanel:Find("ExpBar/Full")

	setText(arg0_4.materialPanel:Find("ExpFull"), i18n("spweapon_ui_levelmax"))

	arg0_4.materialPanelExpTotalText = arg0_4.materialPanel:Find("ExpTotal")
	arg0_4.materialPanelExpCurrentText = arg0_4.materialPanel:Find("ExpTotal/ExpCurrent")
	arg0_4.materialPanelMaterialList = arg0_4.materialPanel:Find("Materials/List")
	arg0_4.materialPanelMaterialListLimit = arg0_4.materialPanel:Find("Materials/Limit")
	arg0_4.materialPanelMaterialItems = CustomIndexLayer.Clone2Full(arg0_4.materialPanelMaterialList, 3)

	setText(arg0_4.materialPanel:Find("Materials/Title"), i18n("spweapon_ui_need_resource"))
	setText(arg0_4.materialPanel:Find("Materials/Limit/text"), i18n("spweapon_ui_levelmax2"))

	arg0_4.materialPanelCostText = arg0_4.materialPanel:Find("Cost/Consume")
	arg0_4.materialPanelButton = arg0_4.materialPanel:Find("Button")
	arg0_4.materialPanelButtonUpgrade = arg0_4.materialPanel:Find("Button/Upgrade")
	arg0_4.materialPanelButtonStrengthen = arg0_4.materialPanel:Find("Button/Strengthen")
	arg0_4.materialPanelButtonCreate = arg0_4.materialPanel:Find("Button/Create")

	setText(arg0_4.materialPanelButtonUpgrade, i18n("msgbox_text_breakthrough"))
	setText(arg0_4.materialPanelButtonStrengthen, i18n("msgbox_text_noPos_intensify"))
	setText(arg0_4.materialPanelButtonCreate, i18n("spweapon_ui_create_button"))

	arg0_4.leftPanelAutoSelectButton = arg0_4.leftPanel:Find("Title/AutoSelect")
	arg0_4.leftPanelClearSelectButton = arg0_4.leftPanel:Find("Title/ClearSelect")
	arg0_4.leftPanelItem = arg0_4.leftPanel:Find("Items")

	local var0_4 = arg0_4.leftPanel:Find("Items/Content")
	local var1_4 = arg0_4.leftPanel:Find("Items/EquipItem")

	arg0_4.leftPanelItemRect = UIItemList.New(var0_4, var1_4)

	setText(arg0_4.leftPanel:Find("Items/Top/TextName"), i18n("spweapon_ui_ptitem"))
	setText(arg0_4.leftPanelAutoSelectButton:Find("On/Text"), i18n("spweapon_ui_autoselect"))
	setText(arg0_4.leftPanelAutoSelectButton:Find("Off/Text"), i18n("spweapon_ui_autoselect"))
	setText(arg0_4.leftPanelClearSelectButton:Find("On/Text"), i18n("spweapon_ui_cancelselect"))
	setText(arg0_4.leftPanelClearSelectButton:Find("Off/Text"), i18n("spweapon_ui_cancelselect"))

	arg0_4.LeftPanelEquip = arg0_4.leftPanel:Find("Equips")
	arg0_4.leftPanelEquipScrollComp = GetComponent(arg0_4.leftPanel:Find("Equips/Scroll View"), "LScrollRect")

	setText(arg0_4.leftPanel:Find("Equips/Top/TextName"), i18n("spweapon_ui_spweapon"))

	arg0_4.leftPanelFilterButton = arg0_4.leftPanel:Find("Equips/Top/Filter")

	setText(arg0_4.leftPanel:Find("TipText"), i18n("spweapon_ui_helptext"))
	setText(arg0_4.equipmentPanel:Find("Ship/Detail"), i18n("spweapon_tip_view"))
	setText(arg0_4.equipmentPanel:Find("Ship/Title"), i18n("spweapon_tip_ship"))
	setText(arg0_4.equipmentPanel:Find("ShipType/Title"), i18n("spweapon_tip_type"))
	setText(arg0_4.craftTargetCount:Find("Tip"), i18n("spweapon_tip_owned", ""))
	Canvas.ForceUpdateCanvases()
end

function var0_0.setItems(arg0_5, arg1_5)
	arg0_5.itemVOs = arg1_5
end

function var0_0.updateRes(arg0_6, arg1_6)
	arg0_6.playerVO = arg1_6
end

function var0_0.SetSpWeapon(arg0_7, arg1_7)
	arg0_7.spWeaponVO = arg1_7
end

function var0_0.SetSpWeaponList(arg0_8, arg1_8)
	arg0_8.spWeaponList = arg1_8
end

function var0_0.didEnter(arg0_9)
	onButton(arg0_9, arg0_9._tf:Find("BG"), function()
		arg0_9:emit(var0_0.ON_CLOSE)
	end, SFX_CANCEL)
	onButton(arg0_9, arg0_9.leftPanelFilterButton, function()
		local var0_11 = {
			indexDatas = Clone(arg0_9.contextData.indexDatas),
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
			callback = function(arg0_12)
				arg0_9.contextData.indexDatas.typeIndex = arg0_12.typeIndex
				arg0_9.contextData.indexDatas.rarityIndex = arg0_12.rarityIndex

				arg0_9:UpdateAll()
			end
		}

		arg0_9:emit(SpWeaponUpgradeMediator.OPEN_EQUIPMENT_INDEX, var0_11)
	end, SFX_PANEL)
	onButton(arg0_9, arg0_9.leftPanelAutoSelectButton, function()
		arg0_9:AutoSelectMaterials()
	end)
	onButton(arg0_9, arg0_9.leftPanelClearSelectButton, function()
		table.clear(arg0_9.consumeItems)
		arg0_9:UpdateAll(true)
	end, SFX_CANCEL)

	function arg0_9.leftPanelEquipScrollComp.onInitItem(arg0_15)
		ClearTweenItemAlphaAndWhite(arg0_15.gameObject)
	end

	function arg0_9.leftPanelEquipScrollComp.onUpdateItem(arg0_16, arg1_16)
		arg0_9:UpdateEquipItemByIndex(arg0_16, arg1_16)
	end

	function arg0_9.leftPanelEquipScrollComp.onReturnItem(arg0_17, arg1_17)
		ClearTweenItemAlphaAndWhite(go(arg1_17))
	end

	arg0_9.leftPanelItemRect:make(function(arg0_18, arg1_18, arg2_18)
		arg1_18 = arg1_18 + 1

		if arg0_18 == UIItemList.EventInit then
			pressPersistTrigger(arg2_18:Find("IconTpl"), 0.5, function(arg0_19)
				local var0_19 = arg0_9.candicateMaterials[arg1_18].id
				local var1_19 = arg0_9:GetSelectMaterial(var0_19)
				local var2_19 = var1_19 and var1_19.count or 0
				local var3_19 = arg0_9.itemVOs[var0_19] and arg0_9.itemVOs[var0_19].count or 0

				if arg0_9.ptMax then
					pg.TipsMgr.GetInstance():ShowTips(i18n("spweapon_tip_upgrade"))
					arg0_19()
				elseif var2_19 == var3_19 then
					arg0_19()
				else
					if not var1_19 then
						var1_19 = Item.New({
							count = 0,
							id = var0_19
						})

						table.insert(arg0_9.consumeItems, var1_19)
					end

					var1_19.count = var1_19.count + 1

					arg0_9:UpdateAll(true)
				end
			end, nil, true, true, 0.15, SFX_PANEL)
			pressPersistTrigger(arg2_18:Find("IconTpl/Reduce"), 0.5, function(arg0_20)
				local var0_20 = arg0_9.candicateMaterials[arg1_18].id
				local var1_20 = arg0_9:GetSelectMaterial(var0_20)

				if (var1_20 and var1_20.count or 0) == 0 then
					arg0_20()

					return
				end

				var1_20.count = var1_20.count - 1

				if var1_20.count <= 0 then
					table.removebyvalue(arg0_9.consumeItems, var1_20)
				end

				arg0_9:UpdateAll(true)
			end, nil, true, true, 0.15, SFX_PANEL)
		elseif arg0_18 == UIItemList.EventUpdate then
			local var0_18 = arg0_9.candicateMaterials[arg1_18]

			updateDrop(arg2_18:Find("IconTpl"), Drop.New({
				type = DROP_TYPE_ITEM,
				id = var0_18.id,
				count = var0_18.count
			}))
			setScrollText(arg2_18:Find("Mask/NameText"), var0_18:getConfig("name"))

			local var1_18 = arg2_18:Find("IconTpl/icon_bg/count")

			setText(var1_18, var0_18.count)
			setActive(arg2_18:Find("IconTpl/mask"), var0_18.count == 0)

			local var2_18 = arg0_9:GetSelectMaterial(var0_18.id)

			setActive(arg2_18:Find("IconTpl/Reduce"), var2_18 and var2_18.count > 0)

			if var2_18 then
				setText(arg2_18:Find("IconTpl/Reduce/Text"), var2_18.count)
			end
		end
	end)
	pg.UIMgr.GetInstance():BlurPanel(arg0_9._tf)

	arg0_9.contextData.indexDatas = arg0_9.contextData.indexDatas or Clone(var7_0)

	arg0_9:UpdateAll()
end

function var0_0.UpdateEquipItemByIndex(arg0_21, arg1_21, arg2_21)
	arg1_21 = arg1_21 + 1

	TweenItemAlphaAndWhite(arg2_21)

	local var0_21 = arg0_21.candicateSpweapons[arg1_21]

	arg0_21:UpdateEquipItem(var0_21, arg2_21)
end

function var0_0.UpdateEquipItem(arg0_22, arg1_22, arg2_22)
	local var0_22 = tf(arg2_22)

	onButton(arg0_22, var0_22, function()
		if arg0_22:GetSelectSpWeapon(arg1_22) then
			return
		end

		if arg0_22.ptMax then
			pg.TipsMgr.GetInstance():ShowTips(i18n("spweapon_tip_upgrade"))

			return
		end

		seriesAsync({
			function(arg0_24)
				if not arg1_22:IsImportant() then
					return arg0_24()
				end

				pg.MsgboxMgr.GetInstance():ShowMsgBox({
					modal = true,
					type = MSGBOX_TYPE_CONFIRM_DELETE,
					title = pg.MsgboxMgr.TITLE_INFORMATION,
					onYes = arg0_24,
					data = {
						name = arg1_22:GetName()
					}
				})
			end,
			function()
				table.insert(arg0_22.consumeSpweapons, arg1_22)
				arg0_22:UpdateAll(true)
				arg0_22:UpdateEquipItem(arg1_22, arg2_22)
			end
		})
	end)
	onButton(arg0_22, var0_22:Find("IconTpl/Reduce"), function()
		local var0_26 = arg0_22:GetSelectSpWeapon(arg1_22)

		if not var0_26 then
			return
		end

		table.removebyvalue(arg0_22.consumeSpweapons, var0_26)
		arg0_22:UpdateEquipItem(arg1_22, arg2_22)
		arg0_22:UpdateAll(true)
	end)
	updateSpWeapon(var0_22:Find("IconTpl"), arg1_22)
	setScrollText(var0_22:Find("Mask/NameText"), arg1_22:GetName())

	local var1_22 = arg1_22:GetShipId()

	setActive(var0_22:Find("EquipShip"), var1_22)

	if var1_22 and var1_22 > 0 then
		local var2_22 = getProxy(BayProxy):getShipById(var1_22)

		setImageSprite(var0_22:Find("EquipShip/Image"), LoadSprite("qicon/" .. var2_22:getPainting()))
	end

	local var3_22 = arg0_22:GetSelectSpWeapon(arg1_22)

	setActive(var0_22:Find("IconTpl/Reduce"), var3_22)

	if var3_22 then
		setText(var0_22:Find("IconTpl/Reduce/Text"), 1)
	end
end

function var0_0.UpdateSelectPt(arg0_27)
	arg0_27.nextSpWeaponVO = nil
	arg0_27.upgradeType = nil
	arg0_27.upgradeMaxLevel = false
	arg0_27.ptMax = false

	local var0_27 = arg0_27.spWeaponVO:GetPt() + SpWeapon.CalculateHistoryPt(arg0_27.consumeItems, arg0_27.consumeSpweapons)
	local var1_27 = arg0_27.spWeaponVO:GetConfigID()
	local var2_27 = 0
	local var3_27 = 0
	local var4_27 = 0
	local var5_27 = 0
	local var6_27 = {}

	local function var7_27(arg0_28)
		for iter0_28, iter1_28 in ipairs(arg0_28) do
			local var0_28 = iter1_28[1]
			local var1_28 = underscore.detect(var6_27, function(arg0_29)
				return arg0_29.id == var0_28
			end)

			if not var1_28 then
				var1_28 = Item.New({
					id = var0_28
				})
				var1_28.count = 0

				table.insert(var6_27, var1_28)
			end

			var1_28.count = var1_28.count + iter1_28[2]
		end
	end

	if arg0_27.craftMode == var1_0 then
		local var8_27 = SpWeapon.New({
			id = var1_27
		}):GetUpgradeConfig()

		var3_27 = var3_27 + var8_27.create_use_pt

		var7_27(var8_27.create_use_item)

		var5_27 = var5_27 + var8_27.create_use_gold
		arg0_27.upgradeType = var3_0
	end

	if var3_27 <= var0_27 then
		arg0_27.upgradeType = var4_0

		repeat
			local var9_27 = SpWeapon.New({
				id = var1_27
			})
			local var10_27 = var9_27:GetNextUpgradeID()

			if var10_27 == 0 then
				break
			end

			local var11_27 = var9_27:GetUpgradeConfig()

			var2_27 = var3_27
			var3_27 = var3_27 + var11_27.upgrade_use_pt

			local var12_27 = SpWeapon.New({
				id = var10_27
			})

			if var4_27 > 0 and var12_27:GetRarity() > var9_27:GetRarity() then
				break
			end

			if var12_27:GetRarity() > var9_27:GetRarity() then
				arg0_27.upgradeType = var5_0
			end

			if var0_27 < var3_27 then
				break
			end

			var7_27(var11_27.upgrade_use_item)

			var5_27 = var5_27 + var11_27.upgrade_use_gold
			var4_27 = var4_27 + 1
			var1_27 = var10_27
		until var12_27:GetRarity() > var9_27:GetRarity()
	end

	arg0_27.ptMax = var3_27 <= var0_27

	local var13_27 = math.min(var0_27, var3_27)

	arg0_27.upgradeLevel = var4_27
	arg0_27.upgradePtOrigin = var2_27
	arg0_27.upgradePtTotal = var13_27
	arg0_27.upgradePtMax = var3_27
	arg0_27.upgradNeedMaterials = var6_27
	arg0_27.upgradNeedGold = var5_27
	arg0_27.nextSpWeaponVO = arg0_27.spWeaponVO:MigrateTo(var1_27)

	if arg0_27.craftMode == var2_0 then
		arg0_27.upgradeMaxLevel = arg0_27.spWeaponVO:GetNextUpgradeID() == 0
	end
end

function var0_0.AutoSelectMaterials(arg0_30)
	local var0_30 = arg0_30.spWeaponVO:GetPt() + SpWeapon.CalculateHistoryPt(arg0_30.consumeItems, arg0_30.consumeSpweapons)
	local var1_30 = arg0_30.spWeaponVO:GetConfigID()
	local var2_30 = 0

	if arg0_30.craftMode == var1_0 then
		var2_30 = SpWeapon.New({
			id = var1_30
		}):GetUpgradeConfig().create_use_pt
	end

	while true do
		local var3_30 = SpWeapon.New({
			id = var1_30
		})
		local var4_30 = var3_30:GetNextUpgradeID()

		if var4_30 == 0 then
			break
		end

		var2_30 = var2_30 + var3_30:GetUpgradeConfig().upgrade_use_pt

		if SpWeapon.New({
			id = var4_30
		}):GetRarity() > arg0_30.spWeaponVO:GetRarity() then
			break
		end

		var1_30 = var4_30
	end

	if var2_30 <= var0_30 then
		return
	end

	local var5_30 = _.values(_.map(arg0_30.candicateMaterials, function(arg0_31)
		local var0_31 = arg0_30:GetSelectMaterial(arg0_31.id)
		local var1_31 = arg0_31.count - (var0_31 and var0_31.count or 0)

		return var1_31 > 0 and Item.New({
			id = arg0_31.id,
			count = var1_31
		}) or nil
	end))

	local function var6_30(arg0_32)
		return Item.getConfigData(arg0_32.id).usage_arg[1]
	end

	table.sort(var5_30, function(arg0_33, arg1_33)
		return var6_30(arg0_33) > var6_30(arg1_33)
	end)

	local var7_30 = var2_30 - var0_30
	local var8_30

	local function var9_30(arg0_34, arg1_34, arg2_34)
		local var0_34 = var5_30[arg0_34]

		if not var0_34 then
			return false
		end

		local var1_34 = var6_30(var0_34)
		local var2_34 = math.min(math.ceil(arg1_34 / var1_34), var0_34.count)
		local var3_34 = arg1_34 - var1_34 * var2_34

		arg2_34 = Clone(arg2_34)

		if var3_34 == 0 then
			table.insert(arg2_34, {
				id = var0_34.id,
				count = var2_34
			})

			return true, arg2_34
		elseif var3_34 > 0 then
			local var4_34, var5_34 = var9_30(arg0_34 + 1, var3_34, {})

			if var4_34 then
				table.insert(arg2_34, {
					id = var0_34.id,
					count = var2_34
				})
				table.insertto(arg2_34, var5_34)

				return true, arg2_34
			else
				return false
			end
		elseif var3_34 < 0 then
			local var6_34 = var3_34 + var1_34
			local var7_34, var8_34 = var9_30(arg0_34 + 1, var6_34, {})

			if var7_34 then
				table.insert(arg2_34, {
					id = var0_34.id,
					count = math.max(var2_34 - 1, 0)
				})
				table.insertto(arg2_34, var8_34)

				return true, arg2_34
			else
				table.insert(arg2_34, {
					id = var0_34.id,
					count = math.max(var2_34, 0)
				})

				return true, arg2_34
			end
		end
	end

	local var10_30, var11_30 = var9_30(1, var7_30, {})

	var11_30 = var10_30 and var11_30 or var5_30

	_.each(var11_30, function(arg0_35)
		arg0_30:UpdateSelectMaterial(arg0_35.id, arg0_35.count)
		arg0_30:UpdateAll(true)
	end)
end

function var0_0.UpdateAll(arg0_36, arg1_36)
	arg0_36.craftMode = not arg0_36.spWeaponVO:IsReal() and var1_0 or var2_0

	arg0_36:UpdateSelectPt()

	local var0_36 = arg0_36.craftMode == var2_0 and arg0_36.nextSpWeaponVO:GetConfigID() ~= arg0_36.spWeaponVO:GetConfigID()

	setActive(arg0_36.equipmentPanelIcon2, var0_36)
	setActive(arg0_36.equipmentPanelArrow, var0_36)

	if var0_36 then
		updateSpWeapon(arg0_36.equipmentPanelIcon1, arg0_36.spWeaponVO)
		updateSpWeapon(arg0_36.equipmentPanelIcon2, arg0_36.nextSpWeaponVO)
		arg0_36:UpdateAttrs(arg0_36.materialPanelAttrList, arg0_36.spWeaponVO, arg0_36.nextSpWeaponVO)
	else
		updateSpWeapon(arg0_36.equipmentPanelIcon1, arg0_36.nextSpWeaponVO)
		arg0_36:UpdateAttrs(arg0_36.materialPanelAttrList, arg0_36.nextSpWeaponVO)
	end

	setText(arg0_36.equipmentPanel:Find("Name"), arg0_36.nextSpWeaponVO:GetName())

	local var1_36 = arg0_36.nextSpWeaponVO:IsUnique()

	setActive(arg0_36.equipmentPanel:Find("ShipType"), not var1_36)
	setActive(arg0_36.equipmentPanel:Find("Ship"), var1_36)

	if var1_36 then
		local var2_36 = ShipGroup.getDefaultShipConfig(arg0_36.nextSpWeaponVO:GetUniqueGroup())
		local var3_36 = var2_36 and var2_36.id or nil

		assert(var3_36 and var3_36 > 0)

		if var3_36 and var3_36 > 0 then
			local var4_36 = Ship.New({
				configId = var3_36
			})

			arg0_36.loader:GetSprite("qicon/" .. var4_36:getPainting(), nil, arg0_36.equipmentPanel:Find("Ship/Icon/Image"))

			local function var5_36()
				arg0_36:emit(BaseUI.ON_DROP, {
					type = DROP_TYPE_SHIP,
					id = var3_36
				})
			end

			arg0_36.equipmentPanel:Find("Ship/Detail"):GetComponent("RichText"):AddListener(var5_36)
			onButton(arg0_36, arg0_36.equipmentPanel:Find("Ship/Icon"), var5_36)
		end
	else
		local var6_36 = arg0_36.nextSpWeaponVO:GetWearableShipTypes()
		local var7_36 = _.filter(var6_36, function(arg0_38)
			return table.contains(ShipType.AllShipType, arg0_38)
		end)
		local var8_36 = ShipType.FilterOverQuZhuType(var7_36)

		CustomIndexLayer.Clone2Full(arg0_36.equipmentPanel:Find("ShipType/List"), #var8_36)

		for iter0_36, iter1_36 in ipairs(var8_36) do
			local var9_36 = arg0_36.equipmentPanel:Find("ShipType/List"):GetChild(iter0_36 - 1)

			arg0_36.loader:GetSprite("shiptype", ShipType.Type2CNLabel(iter1_36), var9_36)
		end
	end

	arg0_36:UpdateExpBar()
	arg0_36:UpdateMaterials()
	arg0_36:UpdatePtMaterials(arg1_36)
	arg0_36:UpdateCraftTargetCount()
end

function var0_0.UpdateCraftTargetCount(arg0_39)
	setActive(arg0_39.craftTargetCount, arg0_39.craftMode == var1_0)

	if not arg0_39.craftMode == var1_0 then
		return
	end

	local var0_39 = _.reduce(arg0_39.spWeaponList, 0, function(arg0_40, arg1_40)
		if arg0_39.nextSpWeaponVO:GetOriginID() == arg1_40:GetOriginID() then
			arg0_40 = arg0_40 + 1
		end

		return arg0_40
	end)

	setText(arg0_39.craftTargetCount:Find("Text"), var0_39)
end

function var0_0.UpdateAttrs(arg0_41, arg1_41, arg2_41, arg3_41)
	local var0_41
	local var1_41

	if arg0_41.craftMode == var1_0 then
		var0_41 = SpWeaponHelper.TransformCompositeInfo(arg2_41)
		var1_41 = arg2_41:GetSkillGroup()
		arg3_41 = arg2_41
	elseif arg0_41.craftMode == var2_0 then
		arg3_41 = arg3_41 or arg2_41
		var0_41 = SpWeaponHelper.TransformUpgradeInfo(arg2_41, arg3_41)
		var1_41 = arg3_41:GetSkillGroup()
	end

	arg0_41:UpdateSpWeaponUpgradeInfo(arg1_41, var0_41, var1_41, arg3_41)
end

function var0_0.UpdateSpWeaponUpgradeInfo(arg0_42, arg1_42, arg2_42, arg3_42, arg4_42)
	local var0_42 = arg1_42:Find("attr_tpl")

	removeAllChildren(arg1_42:Find("attrs"))

	local function var1_42(arg0_43, arg1_43)
		local var0_43 = arg0_43:Find("base")
		local var1_43 = arg1_43.name
		local var2_43 = arg1_43.value

		setText(var0_43:Find("name"), var1_43)
		setActive(var0_43:Find("value"), true)
		setText(var0_43:Find("value"), var2_43)
		setActive(var0_43:Find("effect"), false)
		setActive(var0_43:Find("value/up"), arg1_43.compare and arg1_43.compare > 0)
		setActive(var0_43:Find("value/down"), arg1_43.compare and arg1_43.compare < 0)
		triggerToggle(var0_43, arg1_43.lock_open)

		if not arg1_43.lock_open and arg1_43.sub and #arg1_43.sub > 0 then
			GetComponent(var0_43, typeof(Toggle)).enabled = true
		else
			setActive(var0_43:Find("name/close"), false)
			setActive(var0_43:Find("name/open"), false)

			GetComponent(var0_43, typeof(Toggle)).enabled = false
		end
	end

	;(function(arg0_44, arg1_44, arg2_44)
		for iter0_44, iter1_44 in ipairs(arg2_44) do
			local var0_44 = cloneTplTo(arg1_44, arg0_44)

			var1_42(var0_44, iter1_44)
		end
	end)(arg1_42:Find("attrs"), var0_42, arg2_42)

	local var2_42 = {}

	if arg3_42[1].skillId > 0 then
		table.insert(var2_42, {
			name = i18n("spweapon_attr_effect"),
			effect = arg3_42[1]
		})
	end

	for iter0_42, iter1_42 in ipairs(arg3_42[2]) do
		table.insert(var2_42, {
			isSkill = true,
			name = i18n("spweapon_attr_skillupgrade"),
			effect = iter1_42
		})
	end

	local function var3_42(arg0_45, arg1_45)
		local var0_45 = arg0_45:Find("base")
		local var1_45 = arg1_45.name
		local var2_45 = arg1_45.effect

		setText(var0_45:Find("name"), var1_45)
		setActive(var0_45:Find("value"), false)
		setActive(var0_45:Find("effect"), true)

		local var3_45 = getSkillName(var2_45.skillId)

		if not var2_45.unlock then
			var3_45 = setColorStr(var3_45, "#a2a2a2")

			setTextColor(var0_45:Find("effect"), SummerFeastScene.TransformColor("a2a2a2"))
		else
			setTextColor(var0_45:Find("effect"), SummerFeastScene.TransformColor("FFDE00"))
		end

		local var4_45 = "<material=underline event=displaySkill>" .. var3_45 .. "</material>"

		var0_45:Find("effect"):GetComponent("RichText"):AddListener(function(arg0_46, arg1_46)
			if arg0_46 == "displaySkill" then
				local var0_46 = getSkillDesc(var2_45.skillId, var2_45.lv)

				if not var2_45.unlock then
					var0_46 = setColorStr(i18n("spweapon_tip_skill_locked") .. var0_46, "#a2a2a2")
				end

				if not arg1_45.isSkill then
					pg.MsgboxMgr.GetInstance():ShowMsgBox({
						type = MSGBOX_TYPE_SINGLE_ITEM,
						drop = {
							type = DROP_TYPE_SPWEAPON,
							id = arg4_42:GetConfigID()
						},
						name = var3_45,
						content = var0_46
					})
				else
					arg0_42:emit(SpWeaponUpgradeMediator.ON_SKILLINFO, var2_45.skillId, var2_45.unlock, 10)
				end
			end
		end)
		setText(var0_45:Find("effect"), var4_45)
		setActive(var0_45:Find("value/up"), false)
		setActive(var0_45:Find("value/down"), false)
		triggerToggle(var0_45, false)
		setActive(var0_45:Find("name/close"), false)
		setActive(var0_45:Find("name/open"), false)

		GetComponent(var0_45, typeof(Toggle)).enabled = false
	end

	;(function(arg0_47, arg1_47, arg2_47)
		for iter0_47, iter1_47 in ipairs(arg2_47) do
			local var0_47 = cloneTplTo(arg1_47, arg0_47)

			var3_42(var0_47, iter1_47)
		end
	end)(arg1_42:Find("attrs"), var0_42, var2_42)
end

function var0_0.UpdateExpBar(arg0_48)
	local var0_48 = arg0_48.upgradeMaxLevel

	setActive(arg0_48.materialPanelExpLv, not var0_48)
	setActive(arg0_48.materialPanelExpFullText, var0_48)
	setActive(arg0_48.materialPanelExpBarFull, var0_48)

	if not var0_48 then
		setSlider(arg0_48.materialPanelExpBar, 0, 1, (arg0_48.upgradePtTotal - arg0_48.upgradePtOrigin) / (arg0_48.upgradePtMax - arg0_48.upgradePtOrigin))

		if arg0_48.upgradeType == var3_0 then
			setText(arg0_48.materialPanelExpLv, i18n("spweapon_ui_create_exp"))
		elseif arg0_48.upgradeType == var4_0 then
			setText(arg0_48.materialPanelExpLv, i18n("spweapon_ui_upgrade_exp"))
		elseif arg0_48.upgradeType == var5_0 then
			setText(arg0_48.materialPanelExpLv, i18n("spweapon_ui_breakout_exp"))
		end

		setText(arg0_48.materialPanelExpCurrentText, arg0_48.upgradePtTotal - arg0_48.upgradePtOrigin)
		setText(arg0_48.materialPanelExpTotalText, arg0_48.upgradePtMax - arg0_48.upgradePtOrigin)
	else
		setText(arg0_48.materialPanelExpCurrentText, 0)
		setText(arg0_48.materialPanelExpTotalText, 0)
	end
end

function var0_0.UpdateMaterials(arg0_49)
	local var0_49 = arg0_49.upgradNeedMaterials
	local var1_49 = arg0_49.upgradNeedGold
	local var2_49 = arg0_49.spWeaponVO:GetNextUpgradeID() == 0

	setActive(arg0_49.materialPanelMaterialList, not var2_49)
	setActive(arg0_49.materialPanelMaterialListLimit, var2_49)

	local var3_49
	local var4_49 = true

	for iter0_49 = 1, #arg0_49.materialPanelMaterialItems do
		local var5_49 = arg0_49.materialPanelMaterialItems[iter0_49]

		setActive(findTF(var5_49, "off"), not var0_49[iter0_49])
		setActive(findTF(var5_49, "Icon"), var0_49[iter0_49])

		if var0_49[iter0_49] then
			local var6_49 = var0_49[iter0_49]
			local var7_49 = var6_49.id
			local var8_49 = findTF(var5_49, "Icon")
			local var9_49 = {
				type = DROP_TYPE_ITEM,
				id = var6_49.id,
				count = var6_49.count
			}

			updateDrop(var8_49, var9_49)
			onButton(arg0_49, var8_49, function()
				arg0_49:emit(BaseUI.ON_DROP, var9_49)
			end)

			local var10_49 = defaultValue(arg0_49.itemVOs[var7_49], {
				count = 0
			})
			local var11_49 = var6_49.count .. "/" .. var10_49.count

			if var10_49.count < var6_49.count then
				var11_49 = setColorStr(var10_49.count, COLOR_RED) .. "/" .. var6_49.count
				var4_49 = false
				var3_49 = var6_49.id
			end

			local var12_49 = findTF(var8_49, "icon_bg/count")

			setActive(var12_49, true)
			setText(var12_49, var11_49)

			local var13_49 = var8_49:Find("Click")

			setActive(var13_49, not arg0_49.confirmUpgrade and arg0_49.upgradeType == var5_0)
			onButton(arg0_49, var13_49, function()
				arg0_49.confirmUpgrade = true

				setActive(var13_49, not arg0_49.confirmUpgrade)
			end)
		end
	end

	setText(arg0_49.materialPanelCostText, var1_49)
	setActive(arg0_49.materialPanelButtonCreate, arg0_49.craftMode == var1_0)
	setActive(arg0_49.materialPanelButtonUpgrade, arg0_49.craftMode == var2_0 and arg0_49.upgradeType == var5_0)
	setActive(arg0_49.materialPanelButtonStrengthen, arg0_49.craftMode == var2_0 and arg0_49.upgradeType == var4_0)
	setActive(arg0_49.equipmentPanelTitleComposite, arg0_49.craftMode == var1_0)
	setActive(arg0_49.equipmentPanelTitleUpgrade, arg0_49.craftMode == var2_0 and arg0_49.upgradeType == var5_0)
	setActive(arg0_49.equipmentPanelTitleStrengthen, arg0_49.craftMode == var2_0 and arg0_49.upgradeType == var4_0)
	onButton(arg0_49, arg0_49.materialPanelButton, function()
		if not var4_49 then
			if not ItemTipPanel.ShowItemTipbyID(var3_49) then
				pg.TipsMgr.GetInstance():ShowTips(i18n("spweapon_tip_materal_no_enough"))
			end

			return
		end

		if arg0_49.playerVO.gold < var1_49 then
			GoShoppingMsgBox(i18n("switch_to_shop_tip_2", i18n("word_gold")), ChargeScene.TYPE_ITEM, {
				{
					59001,
					var1_49 - arg0_49.playerVO.gold,
					var1_49
				}
			})

			return
		end

		if not arg0_49.confirmUpgrade and arg0_49.upgradeType == var5_0 and #arg0_49.upgradNeedMaterials > 0 then
			pg.TipsMgr.GetInstance():ShowTips(i18n("spweapon_tip_breakout_materal_check"))

			return
		end

		if arg0_49.craftMode == var1_0 then
			arg0_49:emit(SpWeaponUpgradeMediator.EQUIPMENT_COMPOSITE, arg0_49.spWeaponVO:GetConfigID(), arg0_49.consumeItems, arg0_49.consumeSpweapons)
		elseif arg0_49.craftMode == var2_0 then
			arg0_49:emit(SpWeaponUpgradeMediator.EQUIPMENT_UPGRADE, arg0_49.spWeaponVO:GetUID(), arg0_49.consumeItems, arg0_49.consumeSpweapons)
		end
	end, SFX_UI_DOCKYARD_REINFORCE)
	setGray(arg0_49.materialPanelButton, arg0_49.upgradeMaxLevel)
	setButtonEnabled(arg0_49.materialPanelButton, not arg0_49.upgradeMaxLevel)
end

function var0_0.UpdatePtMaterials(arg0_53, arg1_53)
	arg0_53.candicateMaterials = _.map(var6_0, function(arg0_54)
		return arg0_53.itemVOs[arg0_54] or Item.New({
			count = 0,
			id = arg0_54
		})
	end)

	table.sort(arg0_53.candicateMaterials, function(arg0_55, arg1_55)
		return arg0_55.id < arg1_55.id
	end)

	local var0_53 = table.equal(arg0_53.contextData.indexDatas, var7_0)

	setActive(arg0_53.leftPanelFilterButton:Find("Off"), var0_53)
	setActive(arg0_53.leftPanelFilterButton:Find("On"), not var0_53)

	arg0_53.candicateSpweapons = {}

	for iter0_53, iter1_53 in pairs(arg0_53.spWeaponList) do
		if iter1_53:GetUID() ~= arg0_53.spWeaponVO:GetUID() and not iter1_53:IsUnCraftable() and not iter1_53:GetShipId() and IndexConst.filterSpWeaponByType(iter1_53, arg0_53.contextData.indexDatas.typeIndex) and IndexConst.filterSpWeaponByRarity(iter1_53, arg0_53.contextData.indexDatas.rarityIndex) then
			table.insert(arg0_53.candicateSpweapons, iter1_53)
		end
	end

	local var1_53 = SpWeaponSortCfg
	local var2_53 = true

	table.sort(arg0_53.candicateSpweapons, CompareFuncs(var1_53.sortFunc(var1_53.sort[1], var2_53)))
	arg0_53.leftPanelItemRect:align(#arg0_53.candicateMaterials)

	if not arg1_53 then
		arg0_53.leftPanelEquipScrollComp:SetTotalCount(#arg0_53.candicateSpweapons)
	end

	setActive(arg0_53.leftPanelAutoSelectButton:Find("On"), not arg0_53.ptMax)
	setActive(arg0_53.leftPanelAutoSelectButton:Find("Off"), arg0_53.ptMax)
	setButtonEnabled(arg0_53.leftPanelAutoSelectButton, not arg0_53.ptMax)

	local var3_53 = #arg0_53.consumeItems > 0

	setActive(arg0_53.leftPanelClearSelectButton:Find("On"), var3_53)
	setActive(arg0_53.leftPanelClearSelectButton:Find("Off"), not var3_53)
	setButtonEnabled(arg0_53.leftPanelClearSelectButton, var3_53)
end

function var0_0.UpdateSelectMaterial(arg0_56, arg1_56, arg2_56)
	local var0_56 = arg0_56:GetSelectMaterial(arg1_56)
	local var1_56 = var0_56 and var0_56.count or 0
	local var2_56 = arg0_56.itemVOs[arg1_56] and arg0_56.itemVOs[arg1_56].count or 0

	if arg2_56 > 0 then
		if arg0_56.ptMax then
			pg.TipsMgr.GetInstance():ShowTips(i18n("spweapon_tip_upgrade"))

			return true
		end

		local var3_56 = math.max(var2_56 - var1_56, 0)

		arg2_56 = math.min(arg2_56, var3_56)

		if arg2_56 > 0 then
			if not var0_56 then
				var0_56 = Item.New({
					count = 0,
					id = arg1_56
				})

				table.insert(arg0_56.consumeItems, var0_56)
			end

			var0_56.count = var0_56.count + arg2_56
		end

		if var2_56 <= var1_56 + arg2_56 then
			return true
		end
	elseif arg2_56 < 0 then
		local var4_56 = -var1_56

		arg2_56 = math.max(arg2_56, var4_56)

		if arg2_56 < 0 and var0_56 then
			var0_56.count = var0_56.count + arg2_56

			if var0_56.count <= 0 then
				table.removebyvalue(arg0_56.consumeItems, var0_56)
			end
		end

		if var1_56 + arg2_56 <= 0 then
			return true
		end
	end
end

function var0_0.GetSelectMaterial(arg0_57, arg1_57)
	return _.detect(arg0_57.consumeItems, function(arg0_58)
		return arg0_58.id == arg1_57
	end)
end

function var0_0.GetSelectSpWeapon(arg0_59, arg1_59)
	if table.contains(arg0_59.consumeSpweapons, arg1_59) then
		return arg1_59
	end
end

function var0_0.ClearSelectMaterials(arg0_60)
	table.clear(arg0_60.consumeItems)
	table.clear(arg0_60.consumeSpweapons)
end

function var0_0.willExit(arg0_61)
	pg.UIMgr.GetInstance():UnOverlayPanel(arg0_61._tf)
	ClearLScrollrect(arg0_61.leftPanelEquipScrollComp)
	arg0_61.loader:Clear()
end

return var0_0
