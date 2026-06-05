local var0_0 = class("EquipmentDesignLayer", import("..base.BaseUI"))

function var0_0.getUIName(arg0_1)
	return "EquipmentDesignUI"
end

function var0_0.setItems(arg0_2, arg1_2)
	arg0_2.itemVOs = arg1_2
end

function var0_0.setPlayer(arg0_3, arg1_3)
	arg0_3.player = arg1_3
end

function var0_0.setCapacity(arg0_4, arg1_4)
	arg0_4.capacity = arg1_4
end

function var0_0.init(arg0_5)
	arg0_5.designScrollView = arg0_5._tf:Find("equipment_scrollview")
	arg0_5.equipmentTpl = arg0_5._tf:Find("equipment_tpl")
	arg0_5.equipmentContainer = arg0_5.designScrollView:Find("equipment_grid")
	arg0_5.msgBoxTF = arg0_5._tf:Find("msg_panel")

	setActive(arg0_5.msgBoxTF, false)

	arg0_5.top = arg0_5._tf:Find("top")
	arg0_5.sortBtn = arg0_5.top:Find("sort_button")
	arg0_5.indexBtn = arg0_5.top:Find("index_button")
	arg0_5.decBtn = arg0_5.sortBtn:Find("dec_btn")
	arg0_5.sortImgAsc = arg0_5.decBtn:Find("asc")
	arg0_5.sortImgDec = arg0_5.decBtn:Find("desc")
	arg0_5.indexPanel = arg0_5._tf:Find("index")
	arg0_5.tagContainer = arg0_5.indexPanel:Find("adapt/mask/panel")
	arg0_5.tagTpl = arg0_5.tagContainer:Find("tpl")
	arg0_5.listEmptyTF = arg0_5._tf:Find("empty")

	setActive(arg0_5.listEmptyTF, false)

	arg0_5.listEmptyTxt = arg0_5.listEmptyTF:Find("Text")

	setText(arg0_5.listEmptyTxt, i18n("list_empty_tip_equipmentdesignui"))
	arg0_5:OverlayPanel(arg0_5.indexPanel)

	arg0_5.obtainWayPage = EquipmentDesignObtainWayPage.New(arg0_5._tf, arg0_5.event)

	arg0_5.obtainWayPage:RegisterView(arg0_5)
end

function var0_0.SetParentTF(arg0_6, arg1_6)
	arg0_6.parentTF = arg1_6
	arg0_6.equipmentView = arg0_6.parentTF:Find("adapt/equipment_scrollview")

	setActive(arg0_6.equipmentView, false)
end

function var0_0.SetTopContainer(arg0_7, arg1_7)
	arg0_7.topPanel = arg1_7
end

local var1_0 = {
	"sort_default",
	"sort_rarity",
	"sort_count"
}

function var0_0.didEnter(arg0_8)
	setParent(arg0_8._tf, arg0_8.parentTF)

	local var0_8 = arg0_8.equipmentView:GetSiblingIndex()

	arg0_8._tf:SetSiblingIndex(var0_8)

	arg0_8.contextData.indexDatas = arg0_8.contextData.indexDatas or {}

	setParent(arg0_8.top, arg0_8.topPanel)
	arg0_8:initDesigns()
	onToggle(arg0_8, arg0_8.sortBtn, function(arg0_9)
		if arg0_9 then
			setActive(arg0_8.indexPanel, true)
		else
			setActive(arg0_8.indexPanel, false)
		end
	end, SFX_PANEL)
	onButton(arg0_8, arg0_8.indexPanel, function()
		triggerToggle(arg0_8.sortBtn, false)
	end, SFX_PANEL)
	onButton(arg0_8, arg0_8.indexBtn, function()
		local var0_11 = {
			indexDatas = Clone(arg0_8.contextData.indexDatas),
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
			callback = function(arg0_12)
				if not isActive(arg0_8._tf) then
					return
				end

				arg0_8.contextData.indexDatas.typeIndex = arg0_12.typeIndex
				arg0_8.contextData.indexDatas.equipPropertyIndex = arg0_12.equipPropertyIndex
				arg0_8.contextData.indexDatas.equipPropertyIndex2 = arg0_12.equipPropertyIndex2
				arg0_8.contextData.indexDatas.equipAmmoIndex1 = arg0_12.equipAmmoIndex1
				arg0_8.contextData.indexDatas.equipAmmoIndex2 = arg0_12.equipAmmoIndex2
				arg0_8.contextData.indexDatas.equipCampIndex = arg0_12.equipCampIndex
				arg0_8.contextData.indexDatas.rarityIndex = arg0_12.rarityIndex

				arg0_8:filter(arg0_8.contextData.index or 1)
			end
		}

		arg0_8:emit(EquipmentDesignMediator.OPEN_EQUIPMENTDESIGN_INDEX, var0_11)
	end, SFX_PANEL)
	arg0_8:initTags()
end

function var0_0.isDefaultStatus(arg0_13)
	return (not arg0_13.contextData.indexDatas.typeIndex or arg0_13.contextData.indexDatas.typeIndex == IndexConst.EquipmentTypeAll) and (not arg0_13.contextData.indexDatas.equipPropertyIndex or arg0_13.contextData.indexDatas.equipPropertyIndex == IndexConst.EquipPropertyAll) and (not arg0_13.contextData.indexDatas.equipPropertyIndex2 or arg0_13.contextData.indexDatas.equipPropertyIndex2 == IndexConst.EquipPropertyAll) and (not arg0_13.contextData.indexDatas.equipAmmoIndex1 or arg0_13.contextData.indexDatas.equipAmmoIndex1 == IndexConst.EquipAmmoAll_1) and (not arg0_13.contextData.indexDatas.equipAmmoIndex2 or arg0_13.contextData.indexDatas.equipAmmoIndex2 == IndexConst.EquipAmmoAll_2) and (not arg0_13.contextData.indexDatas.equipCampIndex or arg0_13.contextData.indexDatas.equipCampIndex == IndexConst.EquipCampAll) and (not arg0_13.contextData.indexDatas.rarityIndex or arg0_13.contextData.indexDatas.rarityIndex == IndexConst.EquipmentRarityAll)
end

function var0_0.initTags(arg0_14)
	onButton(arg0_14, arg0_14.decBtn, function()
		arg0_14.asc = not arg0_14.asc
		arg0_14.contextData.asc = arg0_14.asc

		arg0_14:filter(arg0_14.contextData.index or 1)
	end)

	arg0_14.tagTFs = {}

	eachChild(arg0_14.tagContainer, function(arg0_16)
		setActive(arg0_16, false)
	end)

	for iter0_14, iter1_14 in ipairs(var1_0) do
		local var0_14 = iter0_14 <= arg0_14.tagContainer.childCount and arg0_14.tagContainer:GetChild(iter0_14 - 1) or cloneTplTo(arg0_14.tagTpl, arg0_14.tagContainer)

		setActive(var0_14, true)
		setImageSprite(findTF(var0_14, "Image"), GetSpriteFromAtlas("ui/equipmentdesignui_atlas", iter1_14))
		onToggle(arg0_14, var0_14, function(arg0_17)
			if arg0_17 then
				arg0_14:filter(iter0_14)
				triggerButton(arg0_14.indexPanel)

				arg0_14.contextData.index = iter0_14
			else
				triggerButton(arg0_14.indexPanel)
			end
		end, SFX_PANEL)
		table.insert(arg0_14.tagTFs, var0_14)

		if not arg0_14.contextData.index then
			arg0_14.contextData.index = iter0_14
		end
	end

	triggerToggle(arg0_14.tagTFs[arg0_14.contextData.index], true)
end

function var0_0.initDesigns(arg0_18)
	arg0_18.scollRect = arg0_18.designScrollView:GetComponent("LScrollRect")
	arg0_18.scollRect.decelerationRate = 0.07

	function arg0_18.scollRect.onInitItem(arg0_19)
		arg0_18:initDesign(arg0_19)
	end

	function arg0_18.scollRect.onUpdateItem(arg0_20, arg1_20)
		arg0_18:updateDesign(arg0_20, arg1_20)
	end

	function arg0_18.scollRect.onReturnItem(arg0_21, arg1_21)
		arg0_18:returnDesign(arg0_21, arg1_21)
	end

	arg0_18.desgins = {}
end

local function var2_0(arg0_22, arg1_22)
	local var0_22 = findTF(arg0_22, "attrs")

	setImageSprite(findTF(arg0_22, "name_bg/tag"), GetSpriteFromAtlas("equiptype", EquipType.type2Tag(arg1_22:getConfig("type"))))
	eachChild(var0_22, function(arg0_23)
		setActive(arg0_23, false)
	end)

	local var1_22 = arg1_22:GetPropertiesInfo().attrs
	local var2_22 = underscore.filter(var1_22, function(arg0_24)
		return not arg0_24.type or arg0_24.type ~= AttributeType.AntiSiren
	end)
	local var3_22 = arg1_22:getConfig("skill_id")
	local var4_22 = var3_22[1] and var3_22[1][1]
	local var5_22 = var4_22 and arg1_22:isDevice() and {
		1,
		2,
		5
	} or {
		1,
		4,
		2,
		3
	}

	for iter0_22, iter1_22 in ipairs(var5_22) do
		local var6_22 = var0_22:Find("attr_" .. iter1_22)

		setActive(var6_22, true)

		if iter1_22 == 5 then
			setText(var6_22:Find("value"), getSkillName(var4_22))
		else
			local var7_22 = ""
			local var8_22 = ""

			if #var2_22 > 0 then
				local var9_22 = table.remove(var2_22, 1)

				var7_22, var8_22 = Equipment.GetInfoTrans(var9_22)
			end

			setText(var6_22:Find("tag"), var7_22)
			setText(var6_22:Find("value"), var8_22)
		end
	end
end

function var0_0.createDesign(arg0_25, arg1_25)
	arg1_25 = tf(arg1_25)

	local var0_25 = findTF(arg1_25, "info/count")
	local var1_25 = findTF(arg1_25, "mask")
	local var2_25 = arg1_25:Find("name_bg/mask/name")
	local var3_25 = {
		go = arg1_25,
		nameTxt = var2_25
	}

	ClearTweenItemAlphaAndWhite(var3_25.go)

	function var3_25.getItemById(arg0_26, arg1_26)
		return arg0_26.itemVOs[arg1_26] or Item.New({
			count = 0,
			id = arg1_26
		})
	end

	function var3_25.update(arg0_27, arg1_27, arg2_27)
		arg0_27.designId = arg1_27
		arg0_27.itemVOs = arg2_27

		local var0_27 = pg.compose_data_template[arg1_27]

		assert(var0_27, "必须存在配置" .. arg1_27)

		local var1_27 = var0_27.equip_id

		TweenItemAlphaAndWhite(arg0_27.go)

		local var2_27 = Equipment.getConfigData(var1_27)

		assert(var2_27, "必须存在装备" .. var1_27)
		setText(arg0_27.nameTxt, shortenString(var2_27.name, 6))

		local var3_27 = Equipment.New({
			id = var1_27
		})
		local var4_27 = findTF(arg1_25, "equipment/bg")

		updateEquipment(var4_27, var3_27)

		local function var5_27()
			local var0_28 = arg0_27.itemVOs[var0_27.material_id] or Item.New({
				count = 0,
				id = var0_27.material_id
			})
			local var1_28 = var0_28.count .. "/" .. var0_27.material_num

			var1_28 = var0_28.count >= var0_27.material_num and setColorStr(var1_28, COLOR_WHITE) or setColorStr(var1_28, COLOR_RED)

			setText(var0_25, var1_28)
			setActive(var1_25, var0_28.count < var0_27.material_num)
		end

		var2_0(arg1_25, var3_27)
		var5_27()
	end

	function var3_25.clear(arg0_29)
		ClearTweenItemAlphaAndWhite(arg0_29.go)
	end

	return var3_25
end

function var0_0.initDesign(arg0_30, arg1_30)
	local var0_30 = arg0_30:createDesign(arg1_30)

	onButton(arg0_30, tf(var0_30.go):Find("info/make_btn"), function()
		arg0_30:showDesignDesc(var0_30.designId)
	end, SFX_PANEL)
	onButton(arg0_30, tf(var0_30.go):Find("look"), function()
		arg0_30.obtainWayPage:ExecuteAction("Show", var0_30.designId)
	end, SFX_PANEL)

	arg0_30.desgins[arg1_30] = var0_30
end

function var0_0.updateDesign(arg0_33, arg1_33, arg2_33)
	local var0_33 = arg0_33.desgins[arg2_33]

	if not var0_33 then
		arg0_33:initDesign(arg2_33)

		var0_33 = arg0_33.desgins[arg2_33]
	end

	local var1_33 = arg0_33.desginIds[arg1_33 + 1]

	var0_33:update(var1_33, arg0_33.itemVOs)
end

function var0_0.returnDesign(arg0_34, arg1_34, arg2_34)
	if arg0_34.exited then
		return
	end

	local var0_34 = arg0_34.desgins[arg2_34]

	if var0_34 then
		var0_34:clear()
	end
end

function var0_0.getDesignVO(arg0_35, arg1_35)
	local var0_35 = {}
	local var1_35 = pg.compose_data_template

	var0_35.equipmentCfg = Equipment.getConfigData(var1_35[arg1_35].equip_id)
	var0_35.designCfg = var1_35[arg1_35]
	var0_35.id = arg1_35

	local var2_35 = arg0_35:getItemById(var1_35[arg1_35].material_id).count

	var0_35.itemCount = var2_35
	var0_35.canMakeCount = math.floor(var2_35 / var1_35[arg1_35].material_num)
	var0_35.canMake = math.min(var0_35.canMakeCount, 1)

	local var3_35 = var1_35[arg1_35].equip_id
	local var4_35 = Equipment.getConfigData(var3_35)

	assert(var4_35, "equip config not exist: " .. var3_35)

	var0_35.config = var4_35

	function var0_35.getNation(arg0_36)
		return var4_35.nationality
	end

	function var0_35.getConfig(arg0_37, arg1_37)
		return var4_35[arg1_37]
	end

	return var0_35
end

function var0_0.filter(arg0_38, arg1_38, arg2_38)
	local var0_38 = arg0_38:isDefaultStatus() and "shaixuan_off" or "shaixuan_on"

	GetSpriteFromAtlasAsync("ui/share/index_atlas", var0_38, function(arg0_39)
		setImageSprite(arg0_38.indexBtn, arg0_39, true)
	end)

	local var1_38 = pg.compose_data_template
	local var2_38 = {}
	local var3_38 = arg0_38.asc
	local var4_38 = getProxy(EquipmentProxy)

	for iter0_38, iter1_38 in ipairs(var1_38.all) do
		local var5_38 = pg.compose_data_template[iter1_38]

		if arg0_38:getItemById(var5_38.material_id).count > 0 or arg0_38.contextData.isShowAllDesign and var4_38:ShouldShowEquipmentDesignObtainWay(iter1_38) then
			table.insert(var2_38, iter1_38)
		end
	end

	local var6_38 = {}
	local var7_38 = table.mergeArray({}, {
		arg0_38.contextData.indexDatas.equipPropertyIndex,
		arg0_38.contextData.indexDatas.equipPropertyIndex2
	}, true)

	for iter2_38, iter3_38 in pairs(var2_38) do
		local var8_38 = arg0_38:getDesignVO(iter3_38)

		if IndexConst.filterEquipByType(var8_38, arg0_38.contextData.indexDatas.typeIndex) and IndexConst.filterEquipByProperty(var8_38, var7_38) and IndexConst.filterEquipAmmo1(var8_38, arg0_38.contextData.indexDatas.equipAmmoIndex1) and IndexConst.filterEquipAmmo2(var8_38, arg0_38.contextData.indexDatas.equipAmmoIndex2) and IndexConst.filterEquipByCamp(var8_38, arg0_38.contextData.indexDatas.equipCampIndex) and IndexConst.filterEquipByRarity(var8_38, arg0_38.contextData.indexDatas.rarityIndex) then
			table.insert(var6_38, iter3_38)
		end
	end

	if arg1_38 == 1 then
		if var3_38 then
			table.sort(var6_38, function(arg0_40, arg1_40)
				local var0_40 = arg0_38:getDesignVO(arg0_40)
				local var1_40 = arg0_38:getDesignVO(arg1_40)

				if var0_40.canMake == var1_40.canMake then
					if var0_40.equipmentCfg.rarity == var1_40.equipmentCfg.rarity then
						return var0_40.equipmentCfg.id < var1_40.equipmentCfg.id
					else
						return var0_40.equipmentCfg.rarity > var1_40.equipmentCfg.rarity
					end
				else
					return var0_40.canMake < var1_40.canMake
				end
			end)
		else
			table.sort(var6_38, function(arg0_41, arg1_41)
				local var0_41 = arg0_38:getDesignVO(arg0_41)
				local var1_41 = arg0_38:getDesignVO(arg1_41)

				if var0_41.canMake == var1_41.canMake then
					if var0_41.equipmentCfg.rarity == var1_41.equipmentCfg.rarity then
						return var0_41.equipmentCfg.id < var1_41.equipmentCfg.id
					else
						return var0_41.equipmentCfg.rarity > var1_41.equipmentCfg.rarity
					end
				else
					return var0_41.canMake > var1_41.canMake
				end
			end)
		end
	elseif arg1_38 == 2 then
		if arg0_38.asc then
			table.sort(var6_38, function(arg0_42, arg1_42)
				local var0_42 = arg0_38:getDesignVO(arg0_42)
				local var1_42 = arg0_38:getDesignVO(arg1_42)

				if var0_42.equipmentCfg.rarity == var1_42.equipmentCfg.rarity then
					return var0_42.equipmentCfg.id < var0_42.equipmentCfg.id
				end

				return var0_42.equipmentCfg.rarity < var1_42.equipmentCfg.rarity
			end)
		else
			table.sort(var6_38, function(arg0_43, arg1_43)
				local var0_43 = arg0_38:getDesignVO(arg0_43)
				local var1_43 = arg0_38:getDesignVO(arg1_43)

				if var0_43.equipmentCfg.rarity == var1_43.equipmentCfg.rarity then
					return var0_43.equipmentCfg.id < var0_43.equipmentCfg.id
				end

				return var0_43.equipmentCfg.rarity > var1_43.equipmentCfg.rarity
			end)
		end
	elseif arg1_38 == 3 then
		if arg0_38.asc then
			table.sort(var6_38, function(arg0_44, arg1_44)
				local var0_44 = arg0_38:getDesignVO(arg0_44)
				local var1_44 = arg0_38:getDesignVO(arg1_44)

				if var0_44.itemCount == var1_44.itemCount then
					return var0_44.equipmentCfg.id < var1_44.equipmentCfg.id
				end

				return var0_44.itemCount < var1_44.itemCount
			end)
		else
			table.sort(var6_38, function(arg0_45, arg1_45)
				local var0_45 = arg0_38:getDesignVO(arg0_45)
				local var1_45 = arg0_38:getDesignVO(arg1_45)

				if var0_45.itemCount == var1_45.itemCount then
					return var0_45.equipmentCfg.id < var1_45.equipmentCfg.id
				end

				return var0_45.itemCount > var1_45.itemCount
			end)
		end
	end

	arg0_38.desginIds = var6_38

	arg0_38.scollRect:SetTotalCount(#var6_38, arg2_38 and -1 or 0)
	setActive(arg0_38.listEmptyTF, #var6_38 <= 0)
	Canvas.ForceUpdateCanvases()

	local var9_38 = GetSpriteFromAtlas("ui/equipmentdesignui_atlas", var1_0[arg1_38])

	setImageSprite(arg0_38.sortBtn:Find("Image"), var9_38)
	setActive(arg0_38.sortImgAsc, arg0_38.asc)
	setActive(arg0_38.sortImgDec, not arg0_38.asc)
end

function var0_0.getItemById(arg0_46, arg1_46)
	return arg0_46.itemVOs[arg1_46] or Item.New({
		count = 0,
		id = arg1_46
	})
end

function var0_0.showDesignDesc(arg0_47, arg1_47)
	arg0_47.isShowDesc = true

	if IsNil(arg0_47.msgBoxTF) then
		return
	end

	pg.UIMgr.GetInstance():BlurPanel(arg0_47.msgBoxTF)
	setActive(arg0_47.msgBoxTF, true)

	local var0_47 = arg0_47.msgBoxTF
	local var1_47 = pg.compose_data_template[arg1_47]
	local var2_47 = var1_47.equip_id
	local var3_47 = Equipment.New({
		id = var2_47
	})

	updateEquipInfo(var0_47:Find("bg/attrs/content"), var3_47:GetPropertiesInfo(), var3_47:GetSkill())

	local var4_47 = var0_47:Find("bg/frame/icon")

	GetImageSpriteFromAtlasAsync("equips/" .. var3_47:getConfig("icon"), "", var4_47)
	changeToScrollText(var0_47:Find("bg/name"), var3_47:getConfig("name"))
	UIItemList.New(var0_47:Find("bg/frame/stars"), var0_47:Find("bg/frame/stars/sarttpl")):align(var3_47:getConfig("rarity"))
	setImageSprite(findTF(var0_47, "bg/frame/type"), GetSpriteFromAtlas("equiptype", EquipType.type2Tag(var3_47:getConfig("type"))))
	setText(var0_47:Find("bg/frame/speciality/Text"), var3_47:getConfig("speciality") ~= "无" and var3_47:getConfig("speciality") or i18n1("—"))

	local var5_47 = LoadSprite("bg/equipment_bg_" .. var3_47:getConfig("rarity"))

	var0_47:Find("bg/frame"):GetComponent(typeof(Image)).sprite = var5_47

	local var6_47 = findTF(var0_47, "bg/frame/numbers")
	local var7_47 = var3_47:getConfig("tech") or 1

	for iter0_47 = 0, var6_47.childCount - 1 do
		local var8_47 = var6_47:GetChild(iter0_47)

		setActive(var8_47, iter0_47 == var7_47)
	end

	local var9_47 = arg0_47:getItemById(var1_47.material_id)
	local var10_47 = math.floor(var9_47.count / var1_47.material_num)
	local var11_47 = 1
	local var12_47 = var0_47:Find("bg/calc/values/Text")
	local var13_47 = var1_47.gold_num
	local var14_47 = var0_47:Find("bg/calc/gold/Text")

	local function var15_47(arg0_48)
		setText(var12_47, arg0_48)
		setText(var14_47, arg0_48 * var13_47)
	end

	var15_47(var11_47)
	pressPersistTrigger(findTF(var0_47, "bg/calc/minus"), 0.5, function(arg0_49)
		if var11_47 <= 1 then
			arg0_49()

			return
		end

		var11_47 = var11_47 - 1

		var15_47(var11_47)
	end, nil, true, true, 0.1, SFX_PANEL)
	pressPersistTrigger(findTF(var0_47, "bg/calc/add"), 0.5, function(arg0_50)
		if var11_47 == var10_47 then
			arg0_50()

			return
		end

		var11_47 = var11_47 + 1

		var15_47(var11_47)
	end, nil, true, true, 0.1, SFX_PANEL)
	onButton(arg0_47, findTF(var0_47, "bg/calc/max"), function()
		if var11_47 == var10_47 then
			return
		end

		local var0_51 = arg0_47.player:getMaxEquipmentBag() - arg0_47.capacity

		var11_47 = math.max(math.min(var10_47, var0_51), 1)

		var15_47(var11_47)
	end, SFX_PANEL)
	onButton(arg0_47, findTF(var0_47, "bg/cancel_btn"), function()
		arg0_47:hideMsgBox()
	end, SFX_CANCEL)
	onButton(arg0_47, findTF(var0_47, "bg/confirm_btn"), function()
		arg0_47:emit(EquipmentDesignMediator.MAKE_EQUIPMENT, arg1_47, var11_47)
		arg0_47:hideMsgBox()
	end, SFX_CONFIRM)
	onButton(arg0_47, var0_47, function()
		arg0_47:hideMsgBox()
	end, SFX_CANCEL)
end

function var0_0.hideMsgBox(arg0_55)
	if not IsNil(arg0_55.msgBoxTF) then
		arg0_55.isShowDesc = nil

		pg.UIMgr.GetInstance():UnOverlayPanel(arg0_55.msgBoxTF, arg0_55._tf)
		setActive(arg0_55.msgBoxTF, false)
	end
end

function var0_0.onBackPressed(arg0_56)
	if isActive(arg0_56.indexPanel) then
		triggerButton(arg0_56.indexPanel)

		return
	end

	if arg0_56.isShowDesc then
		arg0_56:hideMsgBox()
	else
		pg.CriMgr.GetInstance():PlaySoundEffect_V3(SFX_CANCEL)
		arg0_56:emit(var0_0.ON_BACK)
	end
end

function var0_0.willExit(arg0_57)
	arg0_57:UnOverlayPanel(arg0_57.indexPanel, arg0_57._tf)

	if arg0_57.leftEventTrigger then
		ClearEventTrigger(arg0_57.leftEventTrigger)
	end

	if arg0_57.rightEventTrigger then
		ClearEventTrigger(arg0_57.rightEventTrigger)
	end

	setParent(arg0_57.sortBtn.parent, arg0_57._tf)

	if arg0_57.obtainWayPage then
		arg0_57.obtainWayPage:Destroy()
	end

	arg0_57.obtainWayPage = nil
end

return var0_0
