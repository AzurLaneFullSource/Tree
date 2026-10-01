local var0_0 = class("EquipmentDesignLayer", import("..base.BaseUI"))

function var0_0.getUIName(arg0_1)
	return "EquipmentDesignUI"
end

function var0_0.getResource(arg0_2, arg1_2)
	local var0_2 = {
		"ui/equipmentdesignui",
		"ui/equipmentdesignui_atlas",
		"ui/equipmenttransformui_atlas",
		"equiptype",
		"bg/equipment_bg_1",
		"bg/equipment_bg_2",
		"bg/equipment_bg_3",
		"bg/equipment_bg_4",
		"bg/equipment_bg_5",
		"bg/equipment_bg_6"
	}

	table.insertto(var0_2, var0_0.super.getResource(arg0_2))

	return var0_2
end

function var0_0.setItems(arg0_3, arg1_3)
	arg0_3.itemVOs = arg1_3
end

function var0_0.setPlayer(arg0_4, arg1_4)
	arg0_4.player = arg1_4
end

function var0_0.setCapacity(arg0_5, arg1_5)
	arg0_5.capacity = arg1_5
end

function var0_0.init(arg0_6)
	arg0_6.designScrollView = arg0_6._tf:Find("equipment_scrollview")
	arg0_6.equipmentTpl = arg0_6._tf:Find("equipment_tpl")
	arg0_6.equipmentContainer = arg0_6.designScrollView:Find("equipment_grid")
	arg0_6.msgBoxTF = arg0_6._tf:Find("msg_panel")

	setActive(arg0_6.msgBoxTF, false)

	arg0_6.top = arg0_6._tf:Find("top")
	arg0_6.sortBtn = arg0_6.top:Find("sort_button")
	arg0_6.indexBtn = arg0_6.top:Find("index_button")
	arg0_6.decBtn = arg0_6.sortBtn:Find("dec_btn")
	arg0_6.sortImgAsc = arg0_6.decBtn:Find("asc")
	arg0_6.sortImgDec = arg0_6.decBtn:Find("desc")
	arg0_6.indexPanel = arg0_6._tf:Find("index")
	arg0_6.tagContainer = arg0_6.indexPanel:Find("adapt/mask/panel")
	arg0_6.tagTpl = arg0_6.tagContainer:Find("tpl")
	arg0_6.listEmptyTF = arg0_6._tf:Find("empty")

	setActive(arg0_6.listEmptyTF, false)

	arg0_6.listEmptyTxt = arg0_6.listEmptyTF:Find("Text")

	setText(arg0_6.listEmptyTxt, i18n("list_empty_tip_equipmentdesignui"))
	arg0_6:OverlayPanel(arg0_6.indexPanel)

	arg0_6.obtainWayPage = EquipmentDesignObtainWayPage.New(arg0_6._tf, arg0_6.event)

	arg0_6.obtainWayPage:RegisterView(arg0_6)
end

function var0_0.SetParentTF(arg0_7, arg1_7)
	arg0_7.parentTF = arg1_7
	arg0_7.equipmentView = arg0_7.parentTF:Find("adapt/equipment_scrollview")

	setActive(arg0_7.equipmentView, false)
end

function var0_0.SetTopContainer(arg0_8, arg1_8)
	arg0_8.topPanel = arg1_8
end

local var1_0 = {
	"sort_default",
	"sort_rarity",
	"sort_count"
}

function var0_0.didEnter(arg0_9)
	setParent(arg0_9._tf, arg0_9.parentTF)

	local var0_9 = arg0_9.equipmentView:GetSiblingIndex()

	arg0_9._tf:SetSiblingIndex(var0_9)

	arg0_9.contextData.indexDatas = arg0_9.contextData.indexDatas or {}

	setParent(arg0_9.top, arg0_9.topPanel)
	arg0_9:initDesigns()
	onToggle(arg0_9, arg0_9.sortBtn, function(arg0_10)
		if arg0_10 then
			setActive(arg0_9.indexPanel, true)
		else
			setActive(arg0_9.indexPanel, false)
		end
	end, SFX_PANEL)
	onButton(arg0_9, arg0_9.indexPanel, function()
		triggerToggle(arg0_9.sortBtn, false)
	end, SFX_PANEL)
	onButton(arg0_9, arg0_9.indexBtn, function()
		local var0_12 = {
			indexDatas = Clone(arg0_9.contextData.indexDatas),
			customPanels = {
				minHeight = 650,
				typeIndex = {
					mode = CustomIndexLayer.Mode.OR,
					options = IndexConst.EquipmentTypeIndexs,
					names = IndexConst.EquipmentTypeNames
				},
				equipPropertyIndex = {
					mode = CustomIndexLayer.Mode.OR,
					options = IndexConst.EquipPropertyIndexs,
					names = IndexConst.EquipPropertyNames
				},
				equipPropertyIndex2 = {
					mode = CustomIndexLayer.Mode.OR,
					options = IndexConst.EquipPropertyIndexs,
					names = IndexConst.EquipPropertyNames
				},
				equipAmmoIndex1 = {
					mode = CustomIndexLayer.Mode.OR,
					options = IndexConst.EquipAmmoIndexs_1,
					names = IndexConst.EquipAmmoIndexs_1_Names
				},
				equipAmmoIndex2 = {
					mode = CustomIndexLayer.Mode.OR,
					options = IndexConst.EquipAmmoIndexs_2,
					names = IndexConst.EquipAmmoIndexs_2_Names
				},
				equipCampIndex = {
					mode = CustomIndexLayer.Mode.AND,
					options = IndexConst.EquipCampIndexs,
					names = IndexConst.EquipCampNames
				},
				rarityIndex = {
					mode = CustomIndexLayer.Mode.AND,
					options = IndexConst.EquipmentRarityIndexs,
					names = IndexConst.RarityNames
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
					dropdown = true,
					titleTxt = "indexsort_index",
					titleENTxt = "indexsort_indexeng",
					tags = {
						"equipPropertyIndex",
						"equipPropertyIndex2",
						"equipAmmoIndex1",
						"equipAmmoIndex2"
					}
				},
				{
					dropdown = false,
					titleTxt = "indexsort_camp",
					titleENTxt = "indexsort_campeng",
					tags = {
						"equipCampIndex"
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
			dropdownLimit = {
				equipPropertyIndex = {
					include = {
						typeIndex = IndexConst.EquipmentTypeAll
					},
					exclude = {}
				},
				equipPropertyIndex2 = {
					include = {
						typeIndex = IndexConst.EquipmentTypeEquip
					},
					exclude = {
						typeIndex = IndexConst.EquipmentTypeAll
					}
				},
				equipAmmoIndex1 = {
					include = {
						typeIndex = IndexConst.BitAll({
							IndexConst.EquipmentTypeSmallCannon,
							IndexConst.EquipmentTypeMediumCannon,
							IndexConst.EquipmentTypeBigCannon
						})
					},
					exclude = {
						typeIndex = IndexConst.EquipmentTypeAll
					}
				},
				equipAmmoIndex2 = {
					include = {
						typeIndex = IndexConst.BitAll({
							IndexConst.EquipmentTypeWarshipTorpedo,
							IndexConst.EquipmentTypeSubmaraineTorpedo
						})
					},
					exclude = {
						typeIndex = IndexConst.EquipmentTypeAll
					}
				}
			},
			callback = function(arg0_13)
				if not isActive(arg0_9._tf) then
					return
				end

				arg0_9.contextData.indexDatas.typeIndex = arg0_13.typeIndex
				arg0_9.contextData.indexDatas.equipPropertyIndex = arg0_13.equipPropertyIndex
				arg0_9.contextData.indexDatas.equipPropertyIndex2 = arg0_13.equipPropertyIndex2
				arg0_9.contextData.indexDatas.equipAmmoIndex1 = arg0_13.equipAmmoIndex1
				arg0_9.contextData.indexDatas.equipAmmoIndex2 = arg0_13.equipAmmoIndex2
				arg0_9.contextData.indexDatas.equipCampIndex = arg0_13.equipCampIndex
				arg0_9.contextData.indexDatas.rarityIndex = arg0_13.rarityIndex

				arg0_9:filter(arg0_9.contextData.index or 1)
			end
		}

		arg0_9:emit(EquipmentDesignMediator.OPEN_EQUIPMENTDESIGN_INDEX, var0_12)
	end, SFX_PANEL)
	arg0_9:initTags()
end

function var0_0.isDefaultStatus(arg0_14)
	return (not arg0_14.contextData.indexDatas.typeIndex or arg0_14.contextData.indexDatas.typeIndex == IndexConst.EquipmentTypeAll) and (not arg0_14.contextData.indexDatas.equipPropertyIndex or arg0_14.contextData.indexDatas.equipPropertyIndex == IndexConst.EquipPropertyAll) and (not arg0_14.contextData.indexDatas.equipPropertyIndex2 or arg0_14.contextData.indexDatas.equipPropertyIndex2 == IndexConst.EquipPropertyAll) and (not arg0_14.contextData.indexDatas.equipAmmoIndex1 or arg0_14.contextData.indexDatas.equipAmmoIndex1 == IndexConst.EquipAmmoAll_1) and (not arg0_14.contextData.indexDatas.equipAmmoIndex2 or arg0_14.contextData.indexDatas.equipAmmoIndex2 == IndexConst.EquipAmmoAll_2) and (not arg0_14.contextData.indexDatas.equipCampIndex or arg0_14.contextData.indexDatas.equipCampIndex == IndexConst.EquipCampAll) and (not arg0_14.contextData.indexDatas.rarityIndex or arg0_14.contextData.indexDatas.rarityIndex == IndexConst.EquipmentRarityAll)
end

function var0_0.initTags(arg0_15)
	onButton(arg0_15, arg0_15.decBtn, function()
		arg0_15.asc = not arg0_15.asc
		arg0_15.contextData.asc = arg0_15.asc

		arg0_15:filter(arg0_15.contextData.index or 1)
	end)

	arg0_15.tagTFs = {}

	eachChild(arg0_15.tagContainer, function(arg0_17)
		setActive(arg0_17, false)
	end)

	for iter0_15, iter1_15 in ipairs(var1_0) do
		local var0_15 = iter0_15 <= arg0_15.tagContainer.childCount and arg0_15.tagContainer:GetChild(iter0_15 - 1) or cloneTplTo(arg0_15.tagTpl, arg0_15.tagContainer)

		setActive(var0_15, true)
		setImageSprite(findTF(var0_15, "Image"), GetSpriteFromAtlas("ui/equipmentdesignui_atlas", iter1_15))
		onToggle(arg0_15, var0_15, function(arg0_18)
			if arg0_18 then
				arg0_15:filter(iter0_15)
				triggerButton(arg0_15.indexPanel)

				arg0_15.contextData.index = iter0_15
			else
				triggerButton(arg0_15.indexPanel)
			end
		end, SFX_PANEL)
		table.insert(arg0_15.tagTFs, var0_15)

		if not arg0_15.contextData.index then
			arg0_15.contextData.index = iter0_15
		end
	end

	triggerToggle(arg0_15.tagTFs[arg0_15.contextData.index], true)
end

function var0_0.initDesigns(arg0_19)
	arg0_19.scollRect = arg0_19.designScrollView:GetComponent("LScrollRect")
	arg0_19.scollRect.decelerationRate = 0.07

	function arg0_19.scollRect.onInitItem(arg0_20)
		arg0_19:initDesign(arg0_20)
	end

	function arg0_19.scollRect.onUpdateItem(arg0_21, arg1_21)
		arg0_19:updateDesign(arg0_21, arg1_21)
	end

	function arg0_19.scollRect.onReturnItem(arg0_22, arg1_22)
		arg0_19:returnDesign(arg0_22, arg1_22)
	end

	arg0_19.desgins = {}
end

local function var2_0(arg0_23, arg1_23)
	local var0_23 = findTF(arg0_23, "attrs")

	setImageSprite(findTF(arg0_23, "name_bg/tag"), GetSpriteFromAtlas("equiptype", EquipType.type2Tag(arg1_23:getConfig("type"))))
	eachChild(var0_23, function(arg0_24)
		setActive(arg0_24, false)
	end)

	local var1_23 = arg1_23:GetPropertiesInfo().attrs
	local var2_23 = underscore.filter(var1_23, function(arg0_25)
		return not arg0_25.type or arg0_25.type ~= AttributeType.AntiSiren
	end)
	local var3_23 = arg1_23:getConfig("skill_id")
	local var4_23 = var3_23[1] and var3_23[1][1]
	local var5_23 = var4_23 and arg1_23:isDevice() and {
		1,
		2,
		5
	} or {
		1,
		4,
		2,
		3
	}

	for iter0_23, iter1_23 in ipairs(var5_23) do
		local var6_23 = var0_23:Find("attr_" .. iter1_23)

		setActive(var6_23, true)

		if iter1_23 == 5 then
			setText(var6_23:Find("value"), getSkillName(var4_23))
		else
			local var7_23 = ""
			local var8_23 = ""

			if #var2_23 > 0 then
				local var9_23 = table.remove(var2_23, 1)

				var7_23, var8_23 = Equipment.GetInfoTrans(var9_23)
			end

			setText(var6_23:Find("tag"), var7_23)
			setText(var6_23:Find("value"), var8_23)
		end
	end
end

function var0_0.createDesign(arg0_26, arg1_26)
	arg1_26 = tf(arg1_26)

	local var0_26 = findTF(arg1_26, "info/count")
	local var1_26 = findTF(arg1_26, "mask")
	local var2_26 = arg1_26:Find("name_bg/mask/name")
	local var3_26 = {
		go = arg1_26,
		nameTxt = var2_26
	}

	ClearTweenItemAlphaAndWhite(var3_26.go)

	function var3_26.getItemById(arg0_27, arg1_27)
		return arg0_27.itemVOs[arg1_27] or Item.New({
			count = 0,
			id = arg1_27
		})
	end

	function var3_26.update(arg0_28, arg1_28, arg2_28)
		arg0_28.designId = arg1_28
		arg0_28.itemVOs = arg2_28

		local var0_28 = pg.compose_data_template[arg1_28]

		assert(var0_28, "必须存在配置" .. arg1_28)

		local var1_28 = var0_28.equip_id

		TweenItemAlphaAndWhite(arg0_28.go)

		local var2_28 = Equipment.getConfigData(var1_28)

		assert(var2_28, "必须存在装备" .. var1_28)
		setText(arg0_28.nameTxt, shortenString(var2_28.name, 6))

		local var3_28 = Equipment.New({
			id = var1_28
		})
		local var4_28 = findTF(arg1_26, "equipment/bg")

		updateEquipment(var4_28, var3_28)

		local function var5_28()
			local var0_29 = arg0_28.itemVOs[var0_28.material_id] or Item.New({
				count = 0,
				id = var0_28.material_id
			})
			local var1_29 = var0_29.count .. "/" .. var0_28.material_num

			var1_29 = var0_29.count >= var0_28.material_num and setColorStr(var1_29, COLOR_WHITE) or setColorStr(var1_29, COLOR_RED)

			setText(var0_26, var1_29)
			setActive(var1_26, var0_29.count < var0_28.material_num)
		end

		var2_0(arg1_26, var3_28)
		var5_28()
	end

	function var3_26.clear(arg0_30)
		ClearTweenItemAlphaAndWhite(arg0_30.go)
	end

	return var3_26
end

function var0_0.initDesign(arg0_31, arg1_31)
	local var0_31 = arg0_31:createDesign(arg1_31)

	onButton(arg0_31, tf(var0_31.go):Find("info/make_btn"), function()
		arg0_31:showDesignDesc(var0_31.designId)
	end, SFX_PANEL)
	onButton(arg0_31, tf(var0_31.go):Find("look"), function()
		arg0_31.obtainWayPage:ExecuteAction("Show", var0_31.designId)
	end, SFX_PANEL)

	arg0_31.desgins[arg1_31] = var0_31
end

function var0_0.updateDesign(arg0_34, arg1_34, arg2_34)
	local var0_34 = arg0_34.desgins[arg2_34]

	if not var0_34 then
		arg0_34:initDesign(arg2_34)

		var0_34 = arg0_34.desgins[arg2_34]
	end

	local var1_34 = arg0_34.desginIds[arg1_34 + 1]

	var0_34:update(var1_34, arg0_34.itemVOs)
end

function var0_0.returnDesign(arg0_35, arg1_35, arg2_35)
	if arg0_35.exited then
		return
	end

	local var0_35 = arg0_35.desgins[arg2_35]

	if var0_35 then
		var0_35:clear()
	end
end

function var0_0.getDesignVO(arg0_36, arg1_36)
	local var0_36 = {}
	local var1_36 = pg.compose_data_template

	var0_36.equipmentCfg = Equipment.getConfigData(var1_36[arg1_36].equip_id)
	var0_36.designCfg = var1_36[arg1_36]
	var0_36.id = arg1_36

	local var2_36 = arg0_36:getItemById(var1_36[arg1_36].material_id).count

	var0_36.itemCount = var2_36
	var0_36.canMakeCount = math.floor(var2_36 / var1_36[arg1_36].material_num)
	var0_36.canMake = math.min(var0_36.canMakeCount, 1)

	local var3_36 = var1_36[arg1_36].equip_id
	local var4_36 = Equipment.getConfigData(var3_36)

	assert(var4_36, "equip config not exist: " .. var3_36)

	var0_36.config = var4_36

	function var0_36.getNation(arg0_37)
		return var4_36.nationality
	end

	function var0_36.getConfig(arg0_38, arg1_38)
		return var4_36[arg1_38]
	end

	return var0_36
end

function var0_0.filter(arg0_39, arg1_39, arg2_39)
	local var0_39 = arg0_39:isDefaultStatus() and "shaixuan_off" or "shaixuan_on"

	GetSpriteFromAtlasAsync("ui/share/index_atlas", var0_39, function(arg0_40)
		setImageSprite(arg0_39.indexBtn, arg0_40, true)
	end)

	local var1_39 = pg.compose_data_template
	local var2_39 = {}
	local var3_39 = arg0_39.asc
	local var4_39 = getProxy(EquipmentProxy)

	for iter0_39, iter1_39 in ipairs(var1_39.all) do
		local var5_39 = pg.compose_data_template[iter1_39]

		if arg0_39:getItemById(var5_39.material_id).count > 0 or arg0_39.contextData.isShowAllDesign and var4_39:ShouldShowEquipmentDesignObtainWay(iter1_39) then
			table.insert(var2_39, iter1_39)
		end
	end

	local var6_39 = {}
	local var7_39 = table.mergeArray({}, {
		arg0_39.contextData.indexDatas.equipPropertyIndex,
		arg0_39.contextData.indexDatas.equipPropertyIndex2
	}, true)

	for iter2_39, iter3_39 in pairs(var2_39) do
		local var8_39 = arg0_39:getDesignVO(iter3_39)

		if IndexConst.filterEquipByType(var8_39, arg0_39.contextData.indexDatas.typeIndex) and IndexConst.filterEquipByProperty(var8_39, var7_39) and IndexConst.filterEquipAmmo1(var8_39, arg0_39.contextData.indexDatas.equipAmmoIndex1) and IndexConst.filterEquipAmmo2(var8_39, arg0_39.contextData.indexDatas.equipAmmoIndex2) and IndexConst.filterEquipByCamp(var8_39, arg0_39.contextData.indexDatas.equipCampIndex) and IndexConst.filterEquipByRarity(var8_39, arg0_39.contextData.indexDatas.rarityIndex) then
			table.insert(var6_39, iter3_39)
		end
	end

	if arg1_39 == 1 then
		if var3_39 then
			table.sort(var6_39, function(arg0_41, arg1_41)
				local var0_41 = arg0_39:getDesignVO(arg0_41)
				local var1_41 = arg0_39:getDesignVO(arg1_41)

				if var0_41.canMake == var1_41.canMake then
					if var0_41.equipmentCfg.rarity == var1_41.equipmentCfg.rarity then
						return var0_41.equipmentCfg.id < var1_41.equipmentCfg.id
					else
						return var0_41.equipmentCfg.rarity > var1_41.equipmentCfg.rarity
					end
				else
					return var0_41.canMake < var1_41.canMake
				end
			end)
		else
			table.sort(var6_39, function(arg0_42, arg1_42)
				local var0_42 = arg0_39:getDesignVO(arg0_42)
				local var1_42 = arg0_39:getDesignVO(arg1_42)

				if var0_42.canMake == var1_42.canMake then
					if var0_42.equipmentCfg.rarity == var1_42.equipmentCfg.rarity then
						return var0_42.equipmentCfg.id < var1_42.equipmentCfg.id
					else
						return var0_42.equipmentCfg.rarity > var1_42.equipmentCfg.rarity
					end
				else
					return var0_42.canMake > var1_42.canMake
				end
			end)
		end
	elseif arg1_39 == 2 then
		if arg0_39.asc then
			table.sort(var6_39, function(arg0_43, arg1_43)
				local var0_43 = arg0_39:getDesignVO(arg0_43)
				local var1_43 = arg0_39:getDesignVO(arg1_43)

				if var0_43.equipmentCfg.rarity == var1_43.equipmentCfg.rarity then
					return var0_43.equipmentCfg.id < var0_43.equipmentCfg.id
				end

				return var0_43.equipmentCfg.rarity < var1_43.equipmentCfg.rarity
			end)
		else
			table.sort(var6_39, function(arg0_44, arg1_44)
				local var0_44 = arg0_39:getDesignVO(arg0_44)
				local var1_44 = arg0_39:getDesignVO(arg1_44)

				if var0_44.equipmentCfg.rarity == var1_44.equipmentCfg.rarity then
					return var0_44.equipmentCfg.id < var0_44.equipmentCfg.id
				end

				return var0_44.equipmentCfg.rarity > var1_44.equipmentCfg.rarity
			end)
		end
	elseif arg1_39 == 3 then
		if arg0_39.asc then
			table.sort(var6_39, function(arg0_45, arg1_45)
				local var0_45 = arg0_39:getDesignVO(arg0_45)
				local var1_45 = arg0_39:getDesignVO(arg1_45)

				if var0_45.itemCount == var1_45.itemCount then
					return var0_45.equipmentCfg.id < var1_45.equipmentCfg.id
				end

				return var0_45.itemCount < var1_45.itemCount
			end)
		else
			table.sort(var6_39, function(arg0_46, arg1_46)
				local var0_46 = arg0_39:getDesignVO(arg0_46)
				local var1_46 = arg0_39:getDesignVO(arg1_46)

				if var0_46.itemCount == var1_46.itemCount then
					return var0_46.equipmentCfg.id < var1_46.equipmentCfg.id
				end

				return var0_46.itemCount > var1_46.itemCount
			end)
		end
	end

	arg0_39.desginIds = var6_39

	arg0_39.scollRect:SetTotalCount(#var6_39, arg2_39 and -1 or 0)
	setActive(arg0_39.listEmptyTF, #var6_39 <= 0)
	Canvas.ForceUpdateCanvases()

	local var9_39 = GetSpriteFromAtlas("ui/equipmentdesignui_atlas", var1_0[arg1_39])

	setImageSprite(arg0_39.sortBtn:Find("Image"), var9_39)
	setActive(arg0_39.sortImgAsc, arg0_39.asc)
	setActive(arg0_39.sortImgDec, not arg0_39.asc)
end

function var0_0.getItemById(arg0_47, arg1_47)
	return arg0_47.itemVOs[arg1_47] or Item.New({
		count = 0,
		id = arg1_47
	})
end

function var0_0.showDesignDesc(arg0_48, arg1_48)
	arg0_48.isShowDesc = true

	if IsNil(arg0_48.msgBoxTF) then
		return
	end

	pg.UIMgr.GetInstance():BlurPanel(arg0_48.msgBoxTF)
	setActive(arg0_48.msgBoxTF, true)

	local var0_48 = arg0_48.msgBoxTF
	local var1_48 = pg.compose_data_template[arg1_48]
	local var2_48 = var1_48.equip_id
	local var3_48 = Equipment.New({
		id = var2_48
	})

	updateEquipInfo(var0_48:Find("bg/attrs/content"), var3_48:GetPropertiesInfo(), var3_48:GetSkill())

	local var4_48 = var0_48:Find("bg/frame/icon")

	GetImageSpriteFromAtlasAsync("equips/" .. var3_48:getConfig("icon"), "", var4_48)
	changeToScrollText(var0_48:Find("bg/name"), var3_48:getConfig("name"))
	UIItemList.New(var0_48:Find("bg/frame/stars"), var0_48:Find("bg/frame/stars/sarttpl")):align(var3_48:getConfig("rarity"))
	setImageSprite(findTF(var0_48, "bg/frame/type"), GetSpriteFromAtlas("equiptype", EquipType.type2Tag(var3_48:getConfig("type"))))
	setText(var0_48:Find("bg/frame/speciality/Text"), var3_48:getConfig("speciality") ~= "无" and var3_48:getConfig("speciality") or i18n1("—"))

	local var5_48 = LoadSprite("bg/equipment_bg_" .. var3_48:getConfig("rarity"))

	var0_48:Find("bg/frame"):GetComponent(typeof(Image)).sprite = var5_48

	local var6_48 = findTF(var0_48, "bg/frame/numbers")
	local var7_48 = var3_48:getConfig("tech") or 1

	for iter0_48 = 0, var6_48.childCount - 1 do
		local var8_48 = var6_48:GetChild(iter0_48)

		setActive(var8_48, iter0_48 == var7_48)
	end

	local var9_48 = arg0_48:getItemById(var1_48.material_id)
	local var10_48 = math.floor(var9_48.count / var1_48.material_num)
	local var11_48 = 1
	local var12_48 = var0_48:Find("bg/calc/values/Text")
	local var13_48 = var1_48.gold_num
	local var14_48 = var0_48:Find("bg/calc/gold/Text")

	local function var15_48(arg0_49)
		setText(var12_48, arg0_49)
		setText(var14_48, arg0_49 * var13_48)
	end

	var15_48(var11_48)
	pressPersistTrigger(findTF(var0_48, "bg/calc/minus"), 0.5, function(arg0_50)
		if var11_48 <= 1 then
			arg0_50()

			return
		end

		var11_48 = var11_48 - 1

		var15_48(var11_48)
	end, nil, true, true, 0.1, SFX_PANEL)
	pressPersistTrigger(findTF(var0_48, "bg/calc/add"), 0.5, function(arg0_51)
		if var11_48 == var10_48 then
			arg0_51()

			return
		end

		var11_48 = var11_48 + 1

		var15_48(var11_48)
	end, nil, true, true, 0.1, SFX_PANEL)
	onButton(arg0_48, findTF(var0_48, "bg/calc/max"), function()
		if var11_48 == var10_48 then
			return
		end

		local var0_52 = arg0_48.player:getMaxEquipmentBag() - arg0_48.capacity

		var11_48 = math.max(math.min(var10_48, var0_52), 1)

		var15_48(var11_48)
	end, SFX_PANEL)
	onButton(arg0_48, findTF(var0_48, "bg/cancel_btn"), function()
		arg0_48:hideMsgBox()
	end, SFX_CANCEL)
	onButton(arg0_48, findTF(var0_48, "bg/confirm_btn"), function()
		arg0_48:emit(EquipmentDesignMediator.MAKE_EQUIPMENT, arg1_48, var11_48)
		arg0_48:hideMsgBox()
	end, SFX_CONFIRM)
	onButton(arg0_48, var0_48, function()
		arg0_48:hideMsgBox()
	end, SFX_CANCEL)
end

function var0_0.hideMsgBox(arg0_56)
	if not IsNil(arg0_56.msgBoxTF) then
		arg0_56.isShowDesc = nil

		pg.UIMgr.GetInstance():UnOverlayPanel(arg0_56.msgBoxTF, arg0_56._tf)
		setActive(arg0_56.msgBoxTF, false)
	end
end

function var0_0.onBackPressed(arg0_57)
	if isActive(arg0_57.indexPanel) then
		triggerButton(arg0_57.indexPanel)

		return
	end

	if arg0_57.isShowDesc then
		arg0_57:hideMsgBox()
	else
		pg.CriMgr.GetInstance():PlaySoundEffect_V3(SFX_CANCEL)
		arg0_57:emit(var0_0.ON_BACK)
	end
end

function var0_0.willExit(arg0_58)
	arg0_58:UnOverlayPanel(arg0_58.indexPanel, arg0_58._tf)

	if arg0_58.leftEventTrigger then
		ClearEventTrigger(arg0_58.leftEventTrigger)
	end

	if arg0_58.rightEventTrigger then
		ClearEventTrigger(arg0_58.rightEventTrigger)
	end

	setParent(arg0_58.sortBtn.parent, arg0_58._tf)

	if arg0_58.obtainWayPage then
		arg0_58.obtainWayPage:Destroy()
	end

	arg0_58.obtainWayPage = nil
end

return var0_0
