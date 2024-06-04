local var0 = class("SpWeaponUpgradeLayer", import("view.base.BaseUI"))
local var1 = 1
local var2 = 2
local var3 = 1
local var4 = 2
local var5 = 3
local var6 = {
	15015,
	15016,
	15017
}
local var7 = {
	typeIndex = IndexConst.SpWeaponTypeAll,
	rarityIndex = IndexConst.SpWeaponRarityAll
}

function var0.getUIName(arg0)
	return "SpWeaponUpgradeUI"
end

function var0.init(arg0)
	arg0:InitUI()

	arg0.consumeItems, arg0.consumeSpweapons = {}, {}
	arg0.loader = AutoLoader.New()
end

function var0.InitUI(arg0)
	arg0.rightPanel = arg0:findTF("Right")
	arg0.leftPanel = arg0:findTF("Left")
	arg0.equipmentPanel = arg0:findTF("EquipmentPanel", arg0.rightPanel)
	arg0.equipmentPanelTitleStrengthen = arg0:findTF("Title/Strengthen", arg0.equipmentPanel)
	arg0.equipmentPanelTitleUpgrade = arg0:findTF("Title/Upgrade", arg0.equipmentPanel)
	arg0.equipmentPanelTitleComposite = arg0:findTF("Title/Composite", arg0.equipmentPanel)
	arg0.equipmentPanelIcon1 = arg0:findTF("Container/Equiptpl", arg0.equipmentPanel)
	arg0.equipmentPanelIcon2 = arg0:findTF("Container/Equiptpl2", arg0.equipmentPanel)
	arg0.equipmentPanelArrow = arg0:findTF("Container/Slot", arg0.equipmentPanel)
	arg0.craftTargetCount = arg0:findTF("TotalCount", arg0.equipmentPanel)
	arg0.materialPanel = arg0:findTF("MaterialPanel", arg0.rightPanel)
	arg0.materialPanelAttrList = arg0:findTF("ScrollView/List", arg0.materialPanel)
	arg0.materialPanelExpLv = arg0:findTF("ExpLv", arg0.materialPanel)
	arg0.materialPanelExpLvText = arg0:findTF("ExpLv/Number", arg0.materialPanel)

	setActive(arg0.materialPanelExpLvText, false)

	arg0.materialPanelExpFullText = arg0:findTF("ExpFull", arg0.materialPanel)
	arg0.materialPanelExpBar = arg0:findTF("ExpBar", arg0.materialPanel)
	arg0.materialPanelExpBarFill = arg0:findTF("ExpBar/Fill", arg0.materialPanel)
	arg0.materialPanelExpBarFull = arg0:findTF("ExpBar/Full", arg0.materialPanel)

	setText(arg0:findTF("ExpFull", arg0.materialPanel), i18n("spweapon_ui_levelmax"))

	arg0.materialPanelExpTotalText = arg0:findTF("ExpTotal", arg0.materialPanel)
	arg0.materialPanelExpCurrentText = arg0:findTF("ExpTotal/ExpCurrent", arg0.materialPanel)
	arg0.materialPanelMaterialList = arg0:findTF("Materials/List", arg0.materialPanel)
	arg0.materialPanelMaterialListLimit = arg0:findTF("Materials/Limit", arg0.materialPanel)
	arg0.materialPanelMaterialItems = CustomIndexLayer.Clone2Full(arg0.materialPanelMaterialList, 3)

	setText(arg0:findTF("Materials/Title", arg0.materialPanel), i18n("spweapon_ui_need_resource"))
	setText(arg0:findTF("Materials/Limit/text", arg0.materialPanel), i18n("spweapon_ui_levelmax2"))

	arg0.materialPanelCostText = arg0:findTF("Cost/Consume", arg0.materialPanel)
	arg0.materialPanelButton = arg0:findTF("Button", arg0.materialPanel)
	arg0.materialPanelButtonUpgrade = arg0:findTF("Button/Upgrade", arg0.materialPanel)
	arg0.materialPanelButtonStrengthen = arg0:findTF("Button/Strengthen", arg0.materialPanel)
	arg0.materialPanelButtonCreate = arg0:findTF("Button/Create", arg0.materialPanel)

	setText(arg0.materialPanelButtonUpgrade, i18n("msgbox_text_breakthrough"))
	setText(arg0.materialPanelButtonStrengthen, i18n("msgbox_text_noPos_intensify"))
	setText(arg0.materialPanelButtonCreate, i18n("spweapon_ui_create_button"))

	arg0.leftPanelAutoSelectButton = arg0:findTF("Title/AutoSelect", arg0.leftPanel)
	arg0.leftPanelClearSelectButton = arg0:findTF("Title/ClearSelect", arg0.leftPanel)
	arg0.leftPanelItem = arg0:findTF("Items", arg0.leftPanel)

	local var0 = arg0:findTF("Items/Content", arg0.leftPanel)
	local var1 = arg0:findTF("Items/EquipItem", arg0.leftPanel)

	arg0.leftPanelItemRect = UIItemList.New(var0, var1)

	setText(arg0:findTF("Items/Top/TextName", arg0.leftPanel), i18n("spweapon_ui_ptitem"))
	setText(arg0:findTF("On/Text", arg0.leftPanelAutoSelectButton), i18n("spweapon_ui_autoselect"))
	setText(arg0:findTF("Off/Text", arg0.leftPanelAutoSelectButton), i18n("spweapon_ui_autoselect"))
	setText(arg0:findTF("On/Text", arg0.leftPanelClearSelectButton), i18n("spweapon_ui_cancelselect"))
	setText(arg0:findTF("Off/Text", arg0.leftPanelClearSelectButton), i18n("spweapon_ui_cancelselect"))

	arg0.LeftPanelEquip = arg0:findTF("Equips", arg0.leftPanel)
	arg0.leftPanelEquipScrollComp = GetComponent(arg0:findTF("Equips/Scroll View", arg0.leftPanel), "LScrollRect")

	setText(arg0:findTF("Equips/Top/TextName", arg0.leftPanel), i18n("spweapon_ui_spweapon"))

	arg0.leftPanelFilterButton = arg0:findTF("Equips/Top/Filter", arg0.leftPanel)

	setText(arg0:findTF("TipText", arg0.leftPanel), i18n("spweapon_ui_helptext"))
	setText(arg0:findTF("Ship/Detail", arg0.equipmentPanel), i18n("spweapon_tip_view"))
	setText(arg0:findTF("Ship/Title", arg0.equipmentPanel), i18n("spweapon_tip_ship"))
	setText(arg0:findTF("ShipType/Title", arg0.equipmentPanel), i18n("spweapon_tip_type"))
	setText(arg0.craftTargetCount:Find("Tip"), i18n("spweapon_tip_owned", ""))
	Canvas.ForceUpdateCanvases()
end

function var0.setItems(arg0, arg1)
	arg0.itemVOs = arg1
end

function var0.updateRes(arg0, arg1)
	arg0.playerVO = arg1
end

function var0.SetSpWeapon(arg0, arg1)
	arg0.spWeaponVO = arg1
end

function var0.SetSpWeaponList(arg0, arg1)
	arg0.spWeaponList = arg1
end

function var0.didEnter(arg0)
	onButton(arg0, arg0._tf:Find("BG"), function()
		arg0:emit(var0.ON_CLOSE)
	end, SFX_CANCEL)
	onButton(arg0, arg0.leftPanelFilterButton, function()
		local var0 = {
			indexDatas = Clone(arg0.contextData.indexDatas),
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
			callback = function(arg0)
				arg0.contextData.indexDatas.typeIndex = arg0.typeIndex
				arg0.contextData.indexDatas.rarityIndex = arg0.rarityIndex

				arg0:UpdateAll()
			end
		}

		arg0:emit(SpWeaponUpgradeMediator.OPEN_EQUIPMENT_INDEX, var0)
	end, SFX_PANEL)
	onButton(arg0, arg0.leftPanelAutoSelectButton, function()
		arg0:AutoSelectMaterials()
	end)
	onButton(arg0, arg0.leftPanelClearSelectButton, function()
		table.clear(arg0.consumeItems)
		arg0:UpdateAll(true)
	end, SFX_CANCEL)

	function arg0.leftPanelEquipScrollComp.onInitItem(arg0)
		ClearTweenItemAlphaAndWhite(arg0.gameObject)
	end

	function arg0.leftPanelEquipScrollComp.onUpdateItem(arg0, arg1)
		arg0:UpdateEquipItemByIndex(arg0, arg1)
	end

	function arg0.leftPanelEquipScrollComp.onReturnItem(arg0, arg1)
		ClearTweenItemAlphaAndWhite(go(arg1))
	end

	arg0.leftPanelItemRect:make(function(arg0, arg1, arg2)
		arg1 = arg1 + 1

		if arg0 == UIItemList.EventInit then
			pressPersistTrigger(arg2:Find("IconTpl"), 0.5, function(arg0)
				local var0 = arg0.candicateMaterials[arg1].id
				local var1 = arg0:GetSelectMaterial(var0)
				local var2 = var1 and var1.count or 0
				local var3 = arg0.itemVOs[var0] and arg0.itemVOs[var0].count or 0

				if arg0.ptMax then
					pg.TipsMgr.GetInstance():ShowTips(i18n("spweapon_tip_upgrade"))
					arg0()
				elseif var2 == var3 then
					arg0()
				else
					if not var1 then
						var1 = Item.New({
							count = 0,
							id = var0
						})

						table.insert(arg0.consumeItems, var1)
					end

					var1.count = var1.count + 1

					arg0:UpdateAll(true)
				end
			end, nil, true, true, 0.15, SFX_PANEL)
			pressPersistTrigger(arg2:Find("IconTpl/Reduce"), 0.5, function(arg0)
				local var0 = arg0.candicateMaterials[arg1].id
				local var1 = arg0:GetSelectMaterial(var0)

				if (var1 and var1.count or 0) == 0 then
					arg0()

					return
				end

				var1.count = var1.count - 1

				if var1.count <= 0 then
					table.removebyvalue(arg0.consumeItems, var1)
				end

				arg0:UpdateAll(true)
			end, nil, true, true, 0.15, SFX_PANEL)
		elseif arg0 == UIItemList.EventUpdate then
			local var0 = arg0.candicateMaterials[arg1]

			updateDrop(arg2:Find("IconTpl"), Drop.New({
				type = DROP_TYPE_ITEM,
				id = var0.id,
				count = var0.count
			}))
			setScrollText(arg2:Find("Mask/NameText"), var0:getConfig("name"))

			local var1 = arg2:Find("IconTpl/icon_bg/count")

			setText(var1, var0.count)
			setActive(arg2:Find("IconTpl/mask"), var0.count == 0)

			local var2 = arg0:GetSelectMaterial(var0.id)

			setActive(arg2:Find("IconTpl/Reduce"), var2 and var2.count > 0)

			if var2 then
				setText(arg2:Find("IconTpl/Reduce/Text"), var2.count)
			end
		end
	end)
	pg.UIMgr.GetInstance():BlurPanel(arg0._tf, false, {})

	arg0.contextData.indexDatas = arg0.contextData.indexDatas or Clone(var7)

	arg0:UpdateAll()
end

function var0.UpdateEquipItemByIndex(arg0, arg1, arg2)
	arg1 = arg1 + 1

	TweenItemAlphaAndWhite(arg2)

	local var0 = arg0.candicateSpweapons[arg1]

	arg0:UpdateEquipItem(var0, arg2)
end

function var0.UpdateEquipItem(arg0, arg1, arg2)
	local var0 = tf(arg2)

	onButton(arg0, var0, function()
		if arg0:GetSelectSpWeapon(arg1) then
			return
		end

		if arg0.ptMax then
			pg.TipsMgr.GetInstance():ShowTips(i18n("spweapon_tip_upgrade"))

			return
		end

		seriesAsync({
			function(arg0)
				if not arg1:IsImportant() then
					return arg0()
				end

				pg.MsgboxMgr.GetInstance():ShowMsgBox({
					modal = true,
					type = MSGBOX_TYPE_CONFIRM_DELETE,
					title = pg.MsgboxMgr.TITLE_INFORMATION,
					weight = LayerWeightConst.TOP_LAYER,
					onYes = arg0,
					data = {
						name = arg1:GetName()
					}
				})
			end,
			function()
				table.insert(arg0.consumeSpweapons, arg1)
				arg0:UpdateAll(true)
				arg0:UpdateEquipItem(arg1, arg2)
			end
		})
	end)
	onButton(arg0, var0:Find("IconTpl/Reduce"), function()
		local var0 = arg0:GetSelectSpWeapon(arg1)

		if not var0 then
			return
		end

		table.removebyvalue(arg0.consumeSpweapons, var0)
		arg0:UpdateEquipItem(arg1, arg2)
		arg0:UpdateAll(true)
	end)
	updateSpWeapon(var0:Find("IconTpl"), arg1)
	setScrollText(var0:Find("Mask/NameText"), arg1:GetName())

	local var1 = arg1:GetShipId()

	setActive(var0:Find("EquipShip"), var1)

	if var1 and var1 > 0 then
		local var2 = getProxy(BayProxy):getShipById(var1)

		setImageSprite(var0:Find("EquipShip/Image"), LoadSprite("qicon/" .. var2:getPainting()))
	end

	local var3 = arg0:GetSelectSpWeapon(arg1)

	setActive(var0:Find("IconTpl/Reduce"), var3)

	if var3 then
		setText(var0:Find("IconTpl/Reduce/Text"), 1)
	end
end

function var0.UpdateSelectPt(arg0)
	arg0.nextSpWeaponVO = nil
	arg0.upgradeType = nil
	arg0.upgradeMaxLevel = false
	arg0.ptMax = false

	local var0 = arg0.spWeaponVO:GetPt() + SpWeapon.CalculateHistoryPt(arg0.consumeItems, arg0.consumeSpweapons)
	local var1 = arg0.spWeaponVO:GetConfigID()
	local var2 = 0
	local var3 = 0
	local var4 = 0
	local var5 = 0
	local var6 = {}

	local function var7(arg0)
		for iter0, iter1 in ipairs(arg0) do
			local var0 = iter1[1]
			local var1 = underscore.detect(var6, function(arg0)
				return arg0.id == var0
			end)

			if not var1 then
				var1 = Item.New({
					id = var0
				})
				var1.count = 0

				table.insert(var6, var1)
			end

			var1.count = var1.count + iter1[2]
		end
	end

	if arg0.craftMode == var1 then
		local var8 = SpWeapon.New({
			id = var1
		}):GetUpgradeConfig()

		var3 = var3 + var8.create_use_pt

		var7(var8.create_use_item)

		var5 = var5 + var8.create_use_gold
		arg0.upgradeType = var3
	end

	if var3 <= var0 then
		arg0.upgradeType = var4

		repeat
			local var9 = SpWeapon.New({
				id = var1
			})
			local var10 = var9:GetNextUpgradeID()

			if var10 == 0 then
				break
			end

			local var11 = var9:GetUpgradeConfig()

			var2 = var3
			var3 = var3 + var11.upgrade_use_pt

			local var12 = SpWeapon.New({
				id = var10
			})

			if var4 > 0 and var12:GetRarity() > var9:GetRarity() then
				break
			end

			if var12:GetRarity() > var9:GetRarity() then
				arg0.upgradeType = var5
			end

			if var0 < var3 then
				break
			end

			var7(var11.upgrade_use_item)

			var5 = var5 + var11.upgrade_use_gold
			var4 = var4 + 1
			var1 = var10
		until var12:GetRarity() > var9:GetRarity()
	end

	arg0.ptMax = var3 <= var0

	local var13 = math.min(var0, var3)

	arg0.upgradeLevel = var4
	arg0.upgradePtOrigin = var2
	arg0.upgradePtTotal = var13
	arg0.upgradePtMax = var3
	arg0.upgradNeedMaterials = var6
	arg0.upgradNeedGold = var5
	arg0.nextSpWeaponVO = arg0.spWeaponVO:MigrateTo(var1)

	if arg0.craftMode == var2 then
		arg0.upgradeMaxLevel = arg0.spWeaponVO:GetNextUpgradeID() == 0
	end
end

function var0.AutoSelectMaterials(arg0)
	local var0 = arg0.spWeaponVO:GetPt() + SpWeapon.CalculateHistoryPt(arg0.consumeItems, arg0.consumeSpweapons)
	local var1 = arg0.spWeaponVO:GetConfigID()
	local var2 = 0

	if arg0.craftMode == var1 then
		var2 = SpWeapon.New({
			id = var1
		}):GetUpgradeConfig().create_use_pt
	end

	while true do
		local var3 = SpWeapon.New({
			id = var1
		})
		local var4 = var3:GetNextUpgradeID()

		if var4 == 0 then
			break
		end

		var2 = var2 + var3:GetUpgradeConfig().upgrade_use_pt

		if SpWeapon.New({
			id = var4
		}):GetRarity() > arg0.spWeaponVO:GetRarity() then
			break
		end

		var1 = var4
	end

	if var2 <= var0 then
		return
	end

	local var5 = _.values(_.map(arg0.candicateMaterials, function(arg0)
		local var0 = arg0:GetSelectMaterial(arg0.id)
		local var1 = arg0.count - (var0 and var0.count or 0)

		return var1 > 0 and Item.New({
			id = arg0.id,
			count = var1
		}) or nil
	end))

	local function var6(arg0)
		return Item.getConfigData(arg0.id).usage_arg[1]
	end

	table.sort(var5, function(arg0, arg1)
		return var6(arg0) > var6(arg1)
	end)

	local var7 = var2 - var0
	local var8

	local function var9(arg0, arg1, arg2)
		local var0 = var5[arg0]

		if not var0 then
			return false
		end

		local var1 = var6(var0)
		local var2 = math.min(math.ceil(arg1 / var1), var0.count)
		local var3 = arg1 - var1 * var2

		arg2 = Clone(arg2)

		if var3 == 0 then
			table.insert(arg2, {
				id = var0.id,
				count = var2
			})

			return true, arg2
		elseif var3 > 0 then
			local var4, var5 = var9(arg0 + 1, var3, {})

			if var4 then
				table.insert(arg2, {
					id = var0.id,
					count = var2
				})
				table.insertto(arg2, var5)

				return true, arg2
			else
				return false
			end
		elseif var3 < 0 then
			local var6 = var3 + var1
			local var7, var8 = var9(arg0 + 1, var6, {})

			if var7 then
				table.insert(arg2, {
					id = var0.id,
					count = math.max(var2 - 1, 0)
				})
				table.insertto(arg2, var8)

				return true, arg2
			else
				table.insert(arg2, {
					id = var0.id,
					count = math.max(var2, 0)
				})

				return true, arg2
			end
		end
	end

	local var10, var11 = var9(1, var7, {})

	var11 = var10 and var11 or var5

	_.each(var11, function(arg0)
		arg0:UpdateSelectMaterial(arg0.id, arg0.count)
		arg0:UpdateAll(true)
	end)
end

function var0.UpdateAll(arg0, arg1)
	arg0.craftMode = not arg0.spWeaponVO:IsReal() and var1 or var2

	arg0:UpdateSelectPt()

	local var0 = arg0.craftMode == var2 and arg0.nextSpWeaponVO:GetConfigID() ~= arg0.spWeaponVO:GetConfigID()

	setActive(arg0.equipmentPanelIcon2, var0)
	setActive(arg0.equipmentPanelArrow, var0)

	if var0 then
		updateSpWeapon(arg0.equipmentPanelIcon1, arg0.spWeaponVO)
		updateSpWeapon(arg0.equipmentPanelIcon2, arg0.nextSpWeaponVO)
		arg0:UpdateAttrs(arg0.materialPanelAttrList, arg0.spWeaponVO, arg0.nextSpWeaponVO)
	else
		updateSpWeapon(arg0.equipmentPanelIcon1, arg0.nextSpWeaponVO)
		arg0:UpdateAttrs(arg0.materialPanelAttrList, arg0.nextSpWeaponVO)
	end

	setText(arg0.equipmentPanel:Find("Name"), arg0.nextSpWeaponVO:GetName())

	local var1 = arg0.nextSpWeaponVO:IsUnique()

	setActive(arg0.equipmentPanel:Find("ShipType"), not var1)
	setActive(arg0.equipmentPanel:Find("Ship"), var1)

	if var1 then
		local var2 = ShipGroup.getDefaultShipConfig(arg0.nextSpWeaponVO:GetUniqueGroup())
		local var3 = var2 and var2.id or nil

		assert(var3 and var3 > 0)

		if var3 and var3 > 0 then
			local var4 = Ship.New({
				configId = var3
			})

			arg0.loader:GetSprite("qicon/" .. var4:getPainting(), nil, arg0.equipmentPanel:Find("Ship/Icon/Image"))

			local function var5()
				arg0:emit(BaseUI.ON_DROP, {
					type = DROP_TYPE_SHIP,
					id = var3
				})
			end

			arg0.equipmentPanel:Find("Ship/Detail"):GetComponent("RichText"):AddListener(var5)
			onButton(arg0, arg0.equipmentPanel:Find("Ship/Icon"), var5)
		end
	else
		local var6 = arg0.nextSpWeaponVO:GetWearableShipTypes()
		local var7 = _.filter(var6, function(arg0)
			return table.contains(ShipType.AllShipType, arg0)
		end)
		local var8 = ShipType.FilterOverQuZhuType(var7)

		CustomIndexLayer.Clone2Full(arg0.equipmentPanel:Find("ShipType/List"), #var8)

		for iter0, iter1 in ipairs(var8) do
			local var9 = arg0.equipmentPanel:Find("ShipType/List"):GetChild(iter0 - 1)

			arg0.loader:GetSprite("shiptype", ShipType.Type2CNLabel(iter1), var9)
		end
	end

	arg0:UpdateExpBar()
	arg0:UpdateMaterials()
	arg0:UpdatePtMaterials(arg1)
	arg0:UpdateCraftTargetCount()
end

function var0.UpdateCraftTargetCount(arg0)
	setActive(arg0.craftTargetCount, arg0.craftMode == var1)

	if not arg0.craftMode == var1 then
		return
	end

	local var0 = _.reduce(arg0.spWeaponList, 0, function(arg0, arg1)
		if arg0.nextSpWeaponVO:GetOriginID() == arg1:GetOriginID() then
			arg0 = arg0 + 1
		end

		return arg0
	end)

	setText(arg0.craftTargetCount:Find("Text"), var0)
end

function var0.UpdateAttrs(arg0, arg1, arg2, arg3)
	local var0
	local var1

	if arg0.craftMode == var1 then
		var0 = SpWeaponHelper.TransformCompositeInfo(arg2)
		var1 = arg2:GetSkillGroup()
		arg3 = arg2
	elseif arg0.craftMode == var2 then
		arg3 = arg3 or arg2
		var0 = SpWeaponHelper.TransformUpgradeInfo(arg2, arg3)
		var1 = arg3:GetSkillGroup()
	end

	arg0:UpdateSpWeaponUpgradeInfo(arg1, var0, var1, arg3)
end

function var0.UpdateSpWeaponUpgradeInfo(arg0, arg1, arg2, arg3, arg4)
	local var0 = arg1:Find("attr_tpl")

	removeAllChildren(arg1:Find("attrs"))

	local function var1(arg0, arg1)
		local var0 = arg0:Find("base")
		local var1 = arg1.name
		local var2 = arg1.value

		setText(var0:Find("name"), var1)
		setActive(var0:Find("value"), true)
		setText(var0:Find("value"), var2)
		setActive(var0:Find("effect"), false)
		setActive(var0:Find("value/up"), arg1.compare and arg1.compare > 0)
		setActive(var0:Find("value/down"), arg1.compare and arg1.compare < 0)
		triggerToggle(var0, arg1.lock_open)

		if not arg1.lock_open and arg1.sub and #arg1.sub > 0 then
			GetComponent(var0, typeof(Toggle)).enabled = true
		else
			setActive(var0:Find("name/close"), false)
			setActive(var0:Find("name/open"), false)

			GetComponent(var0, typeof(Toggle)).enabled = false
		end
	end

	;(function(arg0, arg1, arg2)
		for iter0, iter1 in ipairs(arg2) do
			local var0 = cloneTplTo(arg1, arg0)

			var1(var0, iter1)
		end
	end)(arg1:Find("attrs"), var0, arg2)

	local var2 = {}

	if arg3[1].skillId > 0 then
		table.insert(var2, {
			name = i18n("spweapon_attr_effect"),
			effect = arg3[1]
		})
	end

	if arg3[2].skillId > 0 then
		table.insert(var2, {
			isSkill = true,
			name = i18n("spweapon_attr_skillupgrade"),
			effect = arg3[2]
		})
	end

	local function var3(arg0, arg1)
		local var0 = arg0:Find("base")
		local var1 = arg1.name
		local var2 = arg1.effect

		setText(var0:Find("name"), var1)
		setActive(var0:Find("value"), false)
		setActive(var0:Find("effect"), true)

		local var3 = getSkillName(var2.skillId)

		if not var2.unlock then
			var3 = setColorStr(var3, "#a2a2a2")

			setTextColor(var0:Find("effect"), SummerFeastScene.TransformColor("a2a2a2"))
		else
			setTextColor(var0:Find("effect"), SummerFeastScene.TransformColor("FFDE00"))
		end

		local var4 = "<material=underline event=displaySkill>" .. var3 .. "</material>"

		var0:Find("effect"):GetComponent("RichText"):AddListener(function(arg0, arg1)
			if arg0 == "displaySkill" then
				local var0 = getSkillDesc(var2.skillId, var2.lv)

				if not var2.unlock then
					var0 = setColorStr(i18n("spweapon_tip_skill_locked") .. var0, "#a2a2a2")
				end

				if not arg1.isSkill then
					pg.MsgboxMgr.GetInstance():ShowMsgBox({
						type = MSGBOX_TYPE_SINGLE_ITEM,
						drop = {
							type = DROP_TYPE_SPWEAPON,
							id = arg4:GetConfigID()
						},
						name = var3,
						content = var0
					})
				else
					arg0:emit(SpWeaponUpgradeMediator.ON_SKILLINFO, var2.skillId, var2.unlock, 10)
				end
			end
		end)
		setText(var0:Find("effect"), var4)
		setActive(var0:Find("value/up"), false)
		setActive(var0:Find("value/down"), false)
		triggerToggle(var0, false)
		setActive(var0:Find("name/close"), false)
		setActive(var0:Find("name/open"), false)

		GetComponent(var0, typeof(Toggle)).enabled = false
	end

	;(function(arg0, arg1, arg2)
		for iter0, iter1 in ipairs(arg2) do
			local var0 = cloneTplTo(arg1, arg0)

			var3(var0, iter1)
		end
	end)(arg1:Find("attrs"), var0, var2)
end

function var0.UpdateExpBar(arg0)
	local var0 = arg0.upgradeMaxLevel

	setActive(arg0.materialPanelExpLv, not var0)
	setActive(arg0.materialPanelExpFullText, var0)
	setActive(arg0.materialPanelExpBarFull, var0)

	if not var0 then
		setSlider(arg0.materialPanelExpBar, 0, 1, (arg0.upgradePtTotal - arg0.upgradePtOrigin) / (arg0.upgradePtMax - arg0.upgradePtOrigin))

		if arg0.upgradeType == var3 then
			setText(arg0.materialPanelExpLv, i18n("spweapon_ui_create_exp"))
		elseif arg0.upgradeType == var4 then
			setText(arg0.materialPanelExpLv, i18n("spweapon_ui_upgrade_exp"))
		elseif arg0.upgradeType == var5 then
			setText(arg0.materialPanelExpLv, i18n("spweapon_ui_breakout_exp"))
		end

		setText(arg0.materialPanelExpCurrentText, arg0.upgradePtTotal - arg0.upgradePtOrigin)
		setText(arg0.materialPanelExpTotalText, arg0.upgradePtMax - arg0.upgradePtOrigin)
	else
		setText(arg0.materialPanelExpCurrentText, 0)
		setText(arg0.materialPanelExpTotalText, 0)
	end
end

function var0.UpdateMaterials(arg0)
	local var0 = arg0.upgradNeedMaterials
	local var1 = arg0.upgradNeedGold
	local var2 = arg0.spWeaponVO:GetNextUpgradeID() == 0

	setActive(arg0.materialPanelMaterialList, not var2)
	setActive(arg0.materialPanelMaterialListLimit, var2)

	local var3
	local var4 = true

	for iter0 = 1, #arg0.materialPanelMaterialItems do
		local var5 = arg0.materialPanelMaterialItems[iter0]

		setActive(findTF(var5, "off"), not var0[iter0])
		setActive(findTF(var5, "Icon"), var0[iter0])

		if var0[iter0] then
			local var6 = var0[iter0]
			local var7 = var6.id
			local var8 = findTF(var5, "Icon")
			local var9 = {
				type = DROP_TYPE_ITEM,
				id = var6.id,
				count = var6.count
			}

			updateDrop(var8, var9)
			onButton(arg0, var8, function()
				arg0:emit(BaseUI.ON_DROP, var9)
			end)

			local var10 = defaultValue(arg0.itemVOs[var7], {
				count = 0
			})
			local var11 = var6.count .. "/" .. var10.count

			if var10.count < var6.count then
				var11 = setColorStr(var10.count, COLOR_RED) .. "/" .. var6.count
				var4 = false
				var3 = var6.id
			end

			local var12 = findTF(var8, "icon_bg/count")

			setActive(var12, true)
			setText(var12, var11)

			local var13 = var8:Find("Click")

			setActive(var13, not arg0.confirmUpgrade and arg0.upgradeType == var5)
			onButton(arg0, var13, function()
				arg0.confirmUpgrade = true

				setActive(var13, not arg0.confirmUpgrade)
			end)
		end
	end

	setText(arg0.materialPanelCostText, var1)
	setActive(arg0.materialPanelButtonCreate, arg0.craftMode == var1)
	setActive(arg0.materialPanelButtonUpgrade, arg0.craftMode == var2 and arg0.upgradeType == var5)
	setActive(arg0.materialPanelButtonStrengthen, arg0.craftMode == var2 and arg0.upgradeType == var4)
	setActive(arg0.equipmentPanelTitleComposite, arg0.craftMode == var1)
	setActive(arg0.equipmentPanelTitleUpgrade, arg0.craftMode == var2 and arg0.upgradeType == var5)
	setActive(arg0.equipmentPanelTitleStrengthen, arg0.craftMode == var2 and arg0.upgradeType == var4)
	onButton(arg0, arg0.materialPanelButton, function()
		if not var4 then
			if not ItemTipPanel.ShowItemTipbyID(var3) then
				pg.TipsMgr.GetInstance():ShowTips(i18n("spweapon_tip_materal_no_enough"))
			end

			return
		end

		if arg0.playerVO.gold < var1 then
			GoShoppingMsgBox(i18n("switch_to_shop_tip_2", i18n("word_gold")), ChargeScene.TYPE_ITEM, {
				{
					59001,
					var1 - arg0.playerVO.gold,
					var1
				}
			})

			return
		end

		if not arg0.confirmUpgrade and arg0.upgradeType == var5 and #arg0.upgradNeedMaterials > 0 then
			pg.TipsMgr.GetInstance():ShowTips(i18n("spweapon_tip_breakout_materal_check"))

			return
		end

		if arg0.craftMode == var1 then
			arg0:emit(SpWeaponUpgradeMediator.EQUIPMENT_COMPOSITE, arg0.spWeaponVO:GetConfigID(), arg0.consumeItems, arg0.consumeSpweapons)
		elseif arg0.craftMode == var2 then
			arg0:emit(SpWeaponUpgradeMediator.EQUIPMENT_UPGRADE, arg0.spWeaponVO:GetUID(), arg0.consumeItems, arg0.consumeSpweapons)
		end
	end, SFX_UI_DOCKYARD_REINFORCE)
	setGray(arg0.materialPanelButton, arg0.upgradeMaxLevel)
	setButtonEnabled(arg0.materialPanelButton, not arg0.upgradeMaxLevel)
end

function var0.UpdatePtMaterials(arg0, arg1)
	arg0.candicateMaterials = _.map(var6, function(arg0)
		return arg0.itemVOs[arg0] or Item.New({
			count = 0,
			id = arg0
		})
	end)

	table.sort(arg0.candicateMaterials, function(arg0, arg1)
		return arg0.id < arg1.id
	end)

	local var0 = table.equal(arg0.contextData.indexDatas, var7)

	setActive(arg0.leftPanelFilterButton:Find("Off"), var0)
	setActive(arg0.leftPanelFilterButton:Find("On"), not var0)

	arg0.candicateSpweapons = {}

	for iter0, iter1 in pairs(arg0.spWeaponList) do
		if iter1:GetUID() ~= arg0.spWeaponVO:GetUID() and not iter1:IsUnCraftable() and not iter1:GetShipId() and IndexConst.filterSpWeaponByType(iter1, arg0.contextData.indexDatas.typeIndex) and IndexConst.filterSpWeaponByRarity(iter1, arg0.contextData.indexDatas.rarityIndex) then
			table.insert(arg0.candicateSpweapons, iter1)
		end
	end

	local var1 = SpWeaponSortCfg
	local var2 = true

	table.sort(arg0.candicateSpweapons, CompareFuncs(var1.sortFunc(var1.sort[1], var2)))
	arg0.leftPanelItemRect:align(#arg0.candicateMaterials)

	if not arg1 then
		arg0.leftPanelEquipScrollComp:SetTotalCount(#arg0.candicateSpweapons)
	end

	setActive(arg0.leftPanelAutoSelectButton:Find("On"), not arg0.ptMax)
	setActive(arg0.leftPanelAutoSelectButton:Find("Off"), arg0.ptMax)
	setButtonEnabled(arg0.leftPanelAutoSelectButton, not arg0.ptMax)

	local var3 = #arg0.consumeItems > 0

	setActive(arg0.leftPanelClearSelectButton:Find("On"), var3)
	setActive(arg0.leftPanelClearSelectButton:Find("Off"), not var3)
	setButtonEnabled(arg0.leftPanelClearSelectButton, var3)
end

function var0.UpdateSelectMaterial(arg0, arg1, arg2)
	local var0 = arg0:GetSelectMaterial(arg1)
	local var1 = var0 and var0.count or 0
	local var2 = arg0.itemVOs[arg1] and arg0.itemVOs[arg1].count or 0

	if arg2 > 0 then
		if arg0.ptMax then
			pg.TipsMgr.GetInstance():ShowTips(i18n("spweapon_tip_upgrade"))

			return true
		end

		local var3 = math.max(var2 - var1, 0)

		arg2 = math.min(arg2, var3)

		if arg2 > 0 then
			if not var0 then
				var0 = Item.New({
					count = 0,
					id = arg1
				})

				table.insert(arg0.consumeItems, var0)
			end

			var0.count = var0.count + arg2
		end

		if var2 <= var1 + arg2 then
			return true
		end
	elseif arg2 < 0 then
		local var4 = -var1

		arg2 = math.max(arg2, var4)

		if arg2 < 0 and var0 then
			var0.count = var0.count + arg2

			if var0.count <= 0 then
				table.removebyvalue(arg0.consumeItems, var0)
			end
		end

		if var1 + arg2 <= 0 then
			return true
		end
	end
end

function var0.GetSelectMaterial(arg0, arg1)
	return _.detect(arg0.consumeItems, function(arg0)
		return arg0.id == arg1
	end)
end

function var0.GetSelectSpWeapon(arg0, arg1)
	if table.contains(arg0.consumeSpweapons, arg1) then
		return arg1
	end
end

function var0.ClearSelectMaterials(arg0)
	table.clear(arg0.consumeItems)
	table.clear(arg0.consumeSpweapons)
end

function var0.willExit(arg0)
	pg.UIMgr.GetInstance():UnblurPanel(arg0._tf)
	arg0.loader:Clear()
end

return var0
