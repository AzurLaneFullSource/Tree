local var0 = class("EquipmentDesignLayer", import("..base.BaseUI"))

function var0.getUIName(arg0)
	return "EquipmentDesignUI"
end

function var0.setItems(arg0, arg1)
	arg0.itemVOs = arg1
end

function var0.setPlayer(arg0, arg1)
	arg0.player = arg1
end

function var0.setCapacity(arg0, arg1)
	arg0.capacity = arg1
end

function var0.init(arg0)
	arg0.designScrollView = arg0:findTF("equipment_scrollview")
	arg0.equipmentTpl = arg0:findTF("equipment_tpl")
	arg0.equipmentContainer = arg0:findTF("equipment_grid", arg0.designScrollView)
	arg0.msgBoxTF = arg0:findTF("msg_panel")

	setActive(arg0.msgBoxTF, false)

	arg0.top = arg0:findTF("top")
	arg0.sortBtn = arg0:findTF("sort_button", arg0.top)
	arg0.indexBtn = arg0:findTF("index_button", arg0.top)
	arg0.decBtn = arg0:findTF("dec_btn", arg0.sortBtn)
	arg0.sortImgAsc = arg0:findTF("asc", arg0.decBtn)
	arg0.sortImgDec = arg0:findTF("desc", arg0.decBtn)
	arg0.indexPanel = arg0:findTF("index")
	arg0.tagContainer = arg0:findTF("adapt/mask/panel", arg0.indexPanel)
	arg0.tagTpl = arg0:findTF("tpl", arg0.tagContainer)
	arg0.UIMgr = pg.UIMgr.GetInstance()
	arg0.listEmptyTF = arg0:findTF("empty")

	setActive(arg0.listEmptyTF, false)

	arg0.listEmptyTxt = arg0:findTF("Text", arg0.listEmptyTF)

	setText(arg0.listEmptyTxt, i18n("list_empty_tip_equipmentdesignui"))
	pg.UIMgr.GetInstance():OverlayPanel(arg0.indexPanel, {
		groupName = LayerWeightConst.GROUP_EQUIPMENTSCENE
	})
end

function var0.SetParentTF(arg0, arg1)
	arg0.parentTF = arg1
	arg0.equipmentView = arg0:findTF("equipment_scrollview", arg0.parentTF)

	setActive(arg0.equipmentView, false)
end

function var0.SetTopContainer(arg0, arg1)
	arg0.topPanel = arg1
end

local var1 = {
	"sort_default",
	"sort_rarity",
	"sort_count"
}

function var0.didEnter(arg0)
	setParent(arg0._tf, arg0.parentTF)

	local var0 = arg0.equipmentView:GetSiblingIndex()

	arg0._tf:SetSiblingIndex(var0)

	arg0.contextData.indexDatas = arg0.contextData.indexDatas or {}

	setParent(arg0.top, arg0.topPanel)
	arg0:initDesigns()
	onToggle(arg0, arg0.sortBtn, function(arg0)
		if arg0 then
			setActive(arg0.indexPanel, true)
		else
			setActive(arg0.indexPanel, false)
		end
	end, SFX_PANEL)
	onButton(arg0, arg0.indexPanel, function()
		triggerToggle(arg0.sortBtn, false)
	end, SFX_PANEL)
	onButton(arg0, arg0.indexBtn, function()
		local var0 = {
			indexDatas = Clone(arg0.contextData.indexDatas),
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
			callback = function(arg0)
				if not isActive(arg0._tf) then
					return
				end

				arg0.contextData.indexDatas.typeIndex = arg0.typeIndex
				arg0.contextData.indexDatas.equipPropertyIndex = arg0.equipPropertyIndex
				arg0.contextData.indexDatas.equipPropertyIndex2 = arg0.equipPropertyIndex2
				arg0.contextData.indexDatas.equipAmmoIndex1 = arg0.equipAmmoIndex1
				arg0.contextData.indexDatas.equipAmmoIndex2 = arg0.equipAmmoIndex2
				arg0.contextData.indexDatas.equipCampIndex = arg0.equipCampIndex
				arg0.contextData.indexDatas.rarityIndex = arg0.rarityIndex

				arg0:filter(arg0.contextData.index or 1)
			end
		}

		arg0:emit(EquipmentDesignMediator.OPEN_EQUIPMENTDESIGN_INDEX, var0)
	end, SFX_PANEL)
	arg0:initTags()
end

function var0.isDefaultStatus(arg0)
	return (not arg0.contextData.indexDatas.typeIndex or arg0.contextData.indexDatas.typeIndex == IndexConst.EquipmentTypeAll) and (not arg0.contextData.indexDatas.equipPropertyIndex or arg0.contextData.indexDatas.equipPropertyIndex == IndexConst.EquipPropertyAll) and (not arg0.contextData.indexDatas.equipPropertyIndex2 or arg0.contextData.indexDatas.equipPropertyIndex2 == IndexConst.EquipPropertyAll) and (not arg0.contextData.indexDatas.equipAmmoIndex1 or arg0.contextData.indexDatas.equipAmmoIndex1 == IndexConst.EquipAmmoAll_1) and (not arg0.contextData.indexDatas.equipAmmoIndex2 or arg0.contextData.indexDatas.equipAmmoIndex2 == IndexConst.EquipAmmoAll_2) and (not arg0.contextData.indexDatas.equipCampIndex or arg0.contextData.indexDatas.equipCampIndex == IndexConst.EquipCampAll) and (not arg0.contextData.indexDatas.rarityIndex or arg0.contextData.indexDatas.rarityIndex == IndexConst.EquipmentRarityAll)
end

function var0.initTags(arg0)
	onButton(arg0, arg0.decBtn, function()
		arg0.asc = not arg0.asc
		arg0.contextData.asc = arg0.asc

		arg0:filter(arg0.contextData.index or 1)
	end)

	arg0.tagTFs = {}

	eachChild(arg0.tagContainer, function(arg0)
		setActive(arg0, false)
	end)

	for iter0, iter1 in ipairs(var1) do
		local var0 = iter0 <= arg0.tagContainer.childCount and arg0.tagContainer:GetChild(iter0 - 1) or cloneTplTo(arg0.tagTpl, arg0.tagContainer)

		setActive(var0, true)
		setImageSprite(findTF(var0, "Image"), GetSpriteFromAtlas("ui/equipmentdesignui_atlas", iter1))
		onToggle(arg0, var0, function(arg0)
			if arg0 then
				arg0:filter(iter0)
				triggerButton(arg0.indexPanel)

				arg0.contextData.index = iter0
			else
				triggerButton(arg0.indexPanel)
			end
		end, SFX_PANEL)
		table.insert(arg0.tagTFs, var0)

		if not arg0.contextData.index then
			arg0.contextData.index = iter0
		end
	end

	triggerToggle(arg0.tagTFs[arg0.contextData.index], true)
end

function var0.initDesigns(arg0)
	arg0.scollRect = arg0.designScrollView:GetComponent("LScrollRect")
	arg0.scollRect.decelerationRate = 0.07

	function arg0.scollRect.onInitItem(arg0)
		arg0:initDesign(arg0)
	end

	function arg0.scollRect.onUpdateItem(arg0, arg1)
		arg0:updateDesign(arg0, arg1)
	end

	function arg0.scollRect.onReturnItem(arg0, arg1)
		arg0:returnDesign(arg0, arg1)
	end

	arg0.desgins = {}
end

local function var2(arg0, arg1)
	local var0 = findTF(arg0, "attrs")

	setImageSprite(findTF(arg0, "name_bg/tag"), GetSpriteFromAtlas("equiptype", EquipType.type2Tag(arg1:getConfig("type"))))
	eachChild(var0, function(arg0)
		setActive(arg0, false)
	end)

	local var1 = arg1:GetPropertiesInfo().attrs
	local var2 = underscore.filter(var1, function(arg0)
		return not arg0.type or arg0.type ~= AttributeType.AntiSiren
	end)
	local var3 = arg1:getConfig("skill_id")[1]
	local var4 = var3 and arg1:isDevice() and {
		1,
		2,
		5
	} or {
		1,
		4,
		2,
		3
	}

	for iter0, iter1 in ipairs(var4) do
		local var5 = var0:Find("attr_" .. iter1)

		setActive(var5, true)

		if iter1 == 5 then
			setText(var5:Find("value"), getSkillName(var3))
		else
			local var6 = ""
			local var7 = ""

			if #var2 > 0 then
				local var8 = table.remove(var2, 1)

				var6, var7 = Equipment.GetInfoTrans(var8)
			end

			setText(var5:Find("tag"), var6)
			setText(var5:Find("value"), var7)
		end
	end
end

function var0.createDesign(arg0, arg1)
	local var0 = findTF(arg1, "info/count")
	local var1 = findTF(arg1, "mask")
	local var2 = arg0:findTF("name_bg/mask/name", arg1)
	local var3 = {
		go = arg1,
		nameTxt = var2
	}

	ClearTweenItemAlphaAndWhite(var3.go)

	function var3.getItemById(arg0, arg1)
		return arg0.itemVOs[arg1] or Item.New({
			count = 0,
			id = arg1
		})
	end

	function var3.update(arg0, arg1, arg2)
		arg0.designId = arg1
		arg0.itemVOs = arg2

		local var0 = pg.compose_data_template[arg1]

		assert(var0, "必须存在配置" .. arg1)

		local var1 = var0.equip_id

		TweenItemAlphaAndWhite(arg0.go)

		local var2 = Equipment.getConfigData(var1)

		assert(var2, "必须存在装备" .. var1)
		setText(arg0.nameTxt, shortenString(var2.name, 6))

		local var3 = Equipment.New({
			id = var1
		})
		local var4 = findTF(arg1, "equipment/bg")

		updateEquipment(var4, var3)

		local function var5()
			local var0 = arg0.itemVOs[var0.material_id] or Item.New({
				count = 0,
				id = var0.material_id
			})
			local var1 = var0.count .. "/" .. var0.material_num

			var1 = var0.count >= var0.material_num and setColorStr(var1, COLOR_WHITE) or setColorStr(var1, COLOR_RED)

			setText(var0, var1)
			setActive(var1, var0.count < var0.material_num)
		end

		var2(arg1, var3)
		var5()
	end

	function var3.clear(arg0)
		ClearTweenItemAlphaAndWhite(arg0.go)
	end

	return var3
end

function var0.initDesign(arg0, arg1)
	local var0 = arg0:createDesign(arg1)

	onButton(arg0, tf(var0.go):Find("info/make_btn"), function()
		arg0:showDesignDesc(var0.designId)
	end)

	arg0.desgins[arg1] = var0
end

function var0.updateDesign(arg0, arg1, arg2)
	local var0 = arg0.desgins[arg2]

	if not var0 then
		arg0:initDesign(arg2)

		var0 = arg0.desgins[arg2]
	end

	local var1 = arg0.desginIds[arg1 + 1]

	var0:update(var1, arg0.itemVOs)
end

function var0.returnDesign(arg0, arg1, arg2)
	if arg0.exited then
		return
	end

	local var0 = arg0.desgins[arg2]

	if var0 then
		var0:clear()
	end
end

function var0.getDesignVO(arg0, arg1)
	local var0 = {}
	local var1 = pg.compose_data_template

	var0.equipmentCfg = Equipment.getConfigData(var1[arg1].equip_id)
	var0.designCfg = var1[arg1]
	var0.id = arg1

	local var2 = arg0:getItemById(var1[arg1].material_id).count

	var0.itemCount = var2
	var0.canMakeCount = math.floor(var2 / var1[arg1].material_num)
	var0.canMake = math.min(var0.canMakeCount, 1)

	local var3 = var1[arg1].equip_id
	local var4 = Equipment.getConfigData(var3)

	assert(var4, "equip config not exist: " .. var3)

	var0.config = var4

	function var0.getNation(arg0)
		return var4.nationality
	end

	function var0.getConfig(arg0, arg1)
		return var4[arg1]
	end

	return var0
end

function var0.filter(arg0, arg1, arg2)
	local var0 = arg0:isDefaultStatus() and "shaixuan_off" or "shaixuan_on"

	GetSpriteFromAtlasAsync("ui/share/index_atlas", var0, function(arg0)
		setImageSprite(arg0.indexBtn, arg0, true)
	end)

	local var1 = pg.compose_data_template
	local var2 = {}
	local var3 = arg0.asc

	for iter0, iter1 in ipairs(var1.all) do
		local var4 = pg.compose_data_template[iter1]

		if arg0:getItemById(var4.material_id).count > 0 then
			table.insert(var2, iter1)
		end
	end

	local var5 = {}
	local var6 = table.mergeArray({}, {
		arg0.contextData.indexDatas.equipPropertyIndex,
		arg0.contextData.indexDatas.equipPropertyIndex2
	}, true)

	for iter2, iter3 in pairs(var2) do
		local var7 = arg0:getDesignVO(iter3)

		if IndexConst.filterEquipByType(var7, arg0.contextData.indexDatas.typeIndex) and IndexConst.filterEquipByProperty(var7, var6) and IndexConst.filterEquipAmmo1(var7, arg0.contextData.indexDatas.equipAmmoIndex1) and IndexConst.filterEquipAmmo2(var7, arg0.contextData.indexDatas.equipAmmoIndex2) and IndexConst.filterEquipByCamp(var7, arg0.contextData.indexDatas.equipCampIndex) and IndexConst.filterEquipByRarity(var7, arg0.contextData.indexDatas.rarityIndex) then
			table.insert(var5, iter3)
		end
	end

	if arg1 == 1 then
		if var3 then
			table.sort(var5, function(arg0, arg1)
				local var0 = arg0:getDesignVO(arg0)
				local var1 = arg0:getDesignVO(arg1)

				if var0.canMake == var1.canMake then
					if var0.equipmentCfg.rarity == var1.equipmentCfg.rarity then
						return var0.equipmentCfg.id < var1.equipmentCfg.id
					else
						return var0.equipmentCfg.rarity > var1.equipmentCfg.rarity
					end
				else
					return var0.canMake < var1.canMake
				end
			end)
		else
			table.sort(var5, function(arg0, arg1)
				local var0 = arg0:getDesignVO(arg0)
				local var1 = arg0:getDesignVO(arg1)

				if var0.canMake == var1.canMake then
					if var0.equipmentCfg.rarity == var1.equipmentCfg.rarity then
						return var0.equipmentCfg.id < var1.equipmentCfg.id
					else
						return var0.equipmentCfg.rarity > var1.equipmentCfg.rarity
					end
				else
					return var0.canMake > var1.canMake
				end
			end)
		end
	elseif arg1 == 2 then
		if arg0.asc then
			table.sort(var5, function(arg0, arg1)
				local var0 = arg0:getDesignVO(arg0)
				local var1 = arg0:getDesignVO(arg1)

				if var0.equipmentCfg.rarity == var1.equipmentCfg.rarity then
					return var0.equipmentCfg.id < var0.equipmentCfg.id
				end

				return var0.equipmentCfg.rarity < var1.equipmentCfg.rarity
			end)
		else
			table.sort(var5, function(arg0, arg1)
				local var0 = arg0:getDesignVO(arg0)
				local var1 = arg0:getDesignVO(arg1)

				if var0.equipmentCfg.rarity == var1.equipmentCfg.rarity then
					return var0.equipmentCfg.id < var0.equipmentCfg.id
				end

				return var0.equipmentCfg.rarity > var1.equipmentCfg.rarity
			end)
		end
	elseif arg1 == 3 then
		if arg0.asc then
			table.sort(var5, function(arg0, arg1)
				local var0 = arg0:getDesignVO(arg0)
				local var1 = arg0:getDesignVO(arg1)

				if var0.itemCount == var1.itemCount then
					return var0.equipmentCfg.id < var1.equipmentCfg.id
				end

				return var0.itemCount < var1.itemCount
			end)
		else
			table.sort(var5, function(arg0, arg1)
				local var0 = arg0:getDesignVO(arg0)
				local var1 = arg0:getDesignVO(arg1)

				if var0.itemCount == var1.itemCount then
					return var0.equipmentCfg.id < var1.equipmentCfg.id
				end

				return var0.itemCount > var1.itemCount
			end)
		end
	end

	arg0.desginIds = var5

	arg0.scollRect:SetTotalCount(#var5, arg2 and -1 or 0)
	setActive(arg0.listEmptyTF, #var5 <= 0)
	Canvas.ForceUpdateCanvases()

	local var8 = GetSpriteFromAtlas("ui/equipmentdesignui_atlas", var1[arg1])

	setImageSprite(arg0:findTF("Image", arg0.sortBtn), var8)
	setActive(arg0.sortImgAsc, arg0.asc)
	setActive(arg0.sortImgDec, not arg0.asc)
end

function var0.getItemById(arg0, arg1)
	return arg0.itemVOs[arg1] or Item.New({
		count = 0,
		id = arg1
	})
end

function var0.showDesignDesc(arg0, arg1)
	arg0.isShowDesc = true

	if IsNil(arg0.msgBoxTF) then
		return
	end

	arg0.UIMgr:BlurPanel(arg0.msgBoxTF)
	setActive(arg0.msgBoxTF, true)

	local var0 = arg0.msgBoxTF
	local var1 = pg.compose_data_template[arg1]
	local var2 = var1.equip_id
	local var3 = Equipment.New({
		id = var2
	})

	updateEquipInfo(var0:Find("bg/attrs/content"), var3:GetPropertiesInfo(), var3:GetSkill())

	local var4 = var0:Find("bg/frame/icon")

	GetImageSpriteFromAtlasAsync("equips/" .. var3:getConfig("icon"), "", var4)
	changeToScrollText(var0:Find("bg/name"), var3:getConfig("name"))
	UIItemList.New(var0:Find("bg/frame/stars"), var0:Find("bg/frame/stars/sarttpl")):align(var3:getConfig("rarity"))
	setImageSprite(findTF(var0, "bg/frame/type"), GetSpriteFromAtlas("equiptype", EquipType.type2Tag(var3:getConfig("type"))))
	setText(var0:Find("bg/frame/speciality/Text"), var3:getConfig("speciality") ~= "无" and var3:getConfig("speciality") or i18n1("—"))

	local var5 = LoadSprite("bg/equipment_bg_" .. var3:getConfig("rarity"))

	var0:Find("bg/frame"):GetComponent(typeof(Image)).sprite = var5

	local var6 = findTF(var0, "bg/frame/numbers")
	local var7 = var3:getConfig("tech") or 1

	for iter0 = 0, var6.childCount - 1 do
		local var8 = var6:GetChild(iter0)

		setActive(var8, iter0 == var7)
	end

	local var9 = arg0:getItemById(var1.material_id)
	local var10 = math.floor(var9.count / var1.material_num)
	local var11 = 1
	local var12 = arg0:findTF("bg/calc/values/Text", var0)
	local var13 = var1.gold_num
	local var14 = arg0:findTF("bg/calc/gold/Text", var0)

	local function var15(arg0)
		setText(var12, arg0)
		setText(var14, arg0 * var13)
	end

	var15(var11)
	pressPersistTrigger(findTF(var0, "bg/calc/minus"), 0.5, function(arg0)
		if var11 <= 1 then
			arg0()

			return
		end

		var11 = var11 - 1

		var15(var11)
	end, nil, true, true, 0.1, SFX_PANEL)
	pressPersistTrigger(findTF(var0, "bg/calc/add"), 0.5, function(arg0)
		if var11 == var10 then
			arg0()

			return
		end

		var11 = var11 + 1

		var15(var11)
	end, nil, true, true, 0.1, SFX_PANEL)
	onButton(arg0, findTF(var0, "bg/calc/max"), function()
		if var11 == var10 then
			return
		end

		local var0 = arg0.player:getMaxEquipmentBag() - arg0.capacity

		var11 = math.max(math.min(var10, var0), 1)

		var15(var11)
	end, SFX_PANEL)
	onButton(arg0, findTF(var0, "bg/cancel_btn"), function()
		arg0:hideMsgBox()
	end, SFX_CANCEL)
	onButton(arg0, findTF(var0, "bg/confirm_btn"), function()
		arg0:emit(EquipmentDesignMediator.MAKE_EQUIPMENT, arg1, var11)
		arg0:hideMsgBox()
	end, SFX_CONFIRM)
	onButton(arg0, var0, function()
		arg0:hideMsgBox()
	end, SFX_CANCEL)
end

function var0.hideMsgBox(arg0)
	if not IsNil(arg0.msgBoxTF) then
		arg0.isShowDesc = nil

		arg0.UIMgr:UnblurPanel(arg0.msgBoxTF, arg0._tf)
		setActive(arg0.msgBoxTF, false)
	end
end

function var0.onBackPressed(arg0)
	if isActive(arg0.indexPanel) then
		triggerButton(arg0.indexPanel)

		return
	end

	if arg0.isShowDesc then
		arg0:hideMsgBox()
	else
		pg.CriMgr.GetInstance():PlaySoundEffect_V3(SFX_CANCEL)
		arg0:emit(var0.ON_BACK)
	end
end

function var0.willExit(arg0)
	pg.UIMgr.GetInstance():UnOverlayPanel(arg0.indexPanel, arg0._tf)

	if arg0.leftEventTrigger then
		ClearEventTrigger(arg0.leftEventTrigger)
	end

	if arg0.rightEventTrigger then
		ClearEventTrigger(arg0.rightEventTrigger)
	end

	setParent(arg0.sortBtn.parent, arg0._tf)
end

return var0
