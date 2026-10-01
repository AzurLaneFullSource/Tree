local var0_0 = class("SpWeaponDesignLayer", import("view.base.BaseUI"))

function var0_0.getUIName(arg0_1)
	return "SpWeaponDesignUI"
end

function var0_0.getResource(arg0_2, arg1_2)
	local var0_2 = {
		"ui/SpWeaponDesignUI",
		"bg/equipment_bg_1",
		"bg/equipment_bg_2",
		"bg/equipment_bg_3",
		"bg/equipment_bg_4",
		"bg/equipment_bg_5",
		"bg/equipment_bg_6",
		"ui/equipmentdesignui_atlas",
		"ui/share/index_atlas",
		"weaponframes"
	}
	local var1_2 = {}

	_.each(pg.spweapon_data_statistics.all, function(arg0_3)
		local var0_3 = SpWeapon.New({
			id = arg0_3
		})

		if var0_3:IsCraftable() then
			local var1_3 = var0_3:GetIconPath()

			table.insert(var1_2, var1_3)
		end
	end)

	return ResPathSupport.MergeLuaArr(var0_0.super.getResource(arg0_2, arg1_2), var0_2, var1_2)
end

function var0_0.SetCraftList(arg0_4, arg1_4)
	arg0_4.craftList = arg1_4
end

function var0_0.SetSpWeapons(arg0_5, arg1_5)
	assert(arg0_5.craftList)

	if arg0_5.craftList then
		_.each(arg0_5.craftList, function(arg0_6)
			arg0_6.owned = arg0_6:IsUnique() and table.Find(arg1_5, function(arg0_7, arg1_7)
				return arg1_7:GetOriginID() == arg0_6:GetConfigID()
			end) and true or false
		end)
	end
end

function var0_0.setItems(arg0_8, arg1_8)
	arg0_8.itemVOs = arg1_8
end

function var0_0.setPlayer(arg0_9, arg1_9)
	arg0_9.player = arg1_9
end

function var0_0.init(arg0_10)
	arg0_10.designScrollView = arg0_10._tf:Find("equipment_scrollview")
	arg0_10.equipmentTpl = arg0_10._tf:Find("Template")

	setActive(arg0_10.equipmentTpl, false)

	arg0_10.equipmentContainer = arg0_10.designScrollView:Find("equipment_grid")

	local var0_10

	if NotchAdapt.CheckNotchRatio == 2 or not getProxy(SettingsProxy):CheckLargeScreen() then
		var0_10 = arg0_10.designScrollView.rect.width > 2000
	else
		var0_10 = NotchAdapt.CheckNotchRatio >= 2
	end

	arg0_10.equipmentContainer:GetComponent(typeof(GridLayoutGroup)).constraintCount = var0_10 and 8 or 7
	arg0_10.top = arg0_10._tf:Find("top")
	arg0_10.toggleOwned = arg0_10._tf:Find("toggle_owned")
	arg0_10.sortBtn = arg0_10.top:Find("sort_button")
	arg0_10.indexBtn = arg0_10.top:Find("index_button")
	arg0_10.decBtn = arg0_10.sortBtn:Find("dec_btn")
	arg0_10.sortImgAsc = arg0_10.decBtn:Find("desc")
	arg0_10.sortImgDec = arg0_10.decBtn:Find("asc")
	arg0_10.indexPanel = arg0_10._tf:Find("index")
	arg0_10.tagContainer = arg0_10.indexPanel:Find("adapt/mask/panel")
	arg0_10.tagTpl = arg0_10.tagContainer:Find("tpl")
	arg0_10.listEmptyTF = arg0_10._tf:Find("empty")

	setActive(arg0_10.listEmptyTF, false)

	arg0_10.listEmptyTxt = arg0_10.listEmptyTF:Find("Text")

	setText(arg0_10.listEmptyTxt, i18n("list_empty_tip_equipmentdesignui"))
	arg0_10:OverlayPanel(arg0_10.indexPanel)
end

function var0_0.SetParentTF(arg0_11, arg1_11)
	arg0_11.parentTF = arg1_11
	arg0_11.equipmentView = arg0_11.parentTF:Find("adapt/equipment_scrollview")

	setActive(arg0_11.equipmentView, false)
end

function var0_0.SetTopContainer(arg0_12, arg1_12)
	arg0_12.topPanel = arg1_12
end

function var0_0.SetTopItems(arg0_13, arg1_13)
	arg0_13.topItems = arg1_13
end

local var1_0 = {
	"sort_rarity"
}

function var0_0.didEnter(arg0_14)
	setParent(arg0_14._tf, arg0_14.parentTF)

	local var0_14 = arg0_14.equipmentView:GetSiblingIndex()

	arg0_14._tf:SetSiblingIndex(var0_14)

	arg0_14.contextData.indexDatas = arg0_14.contextData.indexDatas or {}
	arg0_14.contextData.index = arg0_14.contextData.index or 1

	setParent(arg0_14.top, arg0_14.topPanel)
	setParent(arg0_14.toggleOwned, arg0_14.topItems:Find("adapt/bottom_back"))
	arg0_14:initDesigns()
	onToggle(arg0_14, arg0_14.sortBtn, function(arg0_15)
		setActive(arg0_14.indexPanel, arg0_15)
	end, SFX_PANEL)
	onButton(arg0_14, arg0_14.indexPanel, function()
		triggerToggle(arg0_14.sortBtn, false)
	end, SFX_PANEL)
	onButton(arg0_14, arg0_14.indexBtn, function()
		local var0_17 = {
			indexDatas = Clone(arg0_14.contextData.indexDatas),
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
			callback = function(arg0_18)
				if not isActive(arg0_14._tf) then
					return
				end

				arg0_14.contextData.indexDatas.typeIndex = arg0_18.typeIndex
				arg0_14.contextData.indexDatas.rarityIndex = arg0_18.rarityIndex

				arg0_14:filter()
			end
		}

		arg0_14:emit(SpWeaponDesignMediator.OPEN_EQUIPMENTDESIGN_INDEX, var0_17)
	end, SFX_PANEL)

	arg0_14.contextData.showOwned = defaultValue(arg0_14.contextData.showOwned, false)

	triggerToggle(arg0_14.toggleOwned, arg0_14.contextData.showOwned)
	onToggle(arg0_14, arg0_14.toggleOwned, function(arg0_19)
		arg0_14.contextData.showOwned = arg0_19

		arg0_14:filter()
	end)
	arg0_14:initTags()
end

function var0_0.isDefaultStatus(arg0_20)
	return (not arg0_20.contextData.indexDatas.typeIndex or arg0_20.contextData.indexDatas.typeIndex == IndexConst.SpWeaponTypeAll) and (not arg0_20.contextData.indexDatas.rarityIndex or arg0_20.contextData.indexDatas.rarityIndex == IndexConst.SpWeaponRarityAll)
end

function var0_0.initTags(arg0_21)
	onButton(arg0_21, arg0_21.decBtn, function()
		arg0_21.contextData.asc = not arg0_21.contextData.asc

		arg0_21:filter()
	end)

	arg0_21.tagTFs = {}

	eachChild(arg0_21.tagContainer, function(arg0_23)
		setActive(arg0_23, false)
	end)

	for iter0_21, iter1_21 in ipairs(var1_0) do
		local var0_21 = iter0_21 <= arg0_21.tagContainer.childCount and arg0_21.tagContainer:GetChild(iter0_21 - 1) or cloneTplTo(arg0_21.tagTpl, arg0_21.tagContainer)

		setActive(var0_21, true)
		setImageSprite(findTF(var0_21, "Image"), GetSpriteFromAtlas("ui/equipmentdesignui_atlas", iter1_21))
		onToggle(arg0_21, var0_21, function(arg0_24)
			if arg0_24 then
				arg0_21.contextData.index = iter0_21

				arg0_21:filter()
			end

			triggerButton(arg0_21.indexPanel)
		end, SFX_PANEL)
		table.insert(arg0_21.tagTFs, var0_21)
	end

	triggerToggle(arg0_21.tagTFs[arg0_21.contextData.index], true)
end

function var0_0.initDesigns(arg0_25)
	arg0_25.scollRect = arg0_25.designScrollView:GetComponent("LScrollRect")
	arg0_25.scollRect.decelerationRate = 0.07

	function arg0_25.scollRect.onInitItem(arg0_26)
		arg0_25:initDesign(arg0_26)
	end

	function arg0_25.scollRect.onUpdateItem(arg0_27, arg1_27)
		arg0_25:updateDesign(arg0_27, arg1_27)
	end

	function arg0_25.scollRect.onReturnItem(arg0_28, arg1_28)
		arg0_25:returnDesign(arg0_28, arg1_28)
	end

	arg0_25.desgins = {}
end

function var0_0.initDesign(arg0_29, arg1_29)
	local var0_29 = SpWeaponItemView.New(arg1_29)

	onButton(arg0_29, var0_29.go, function()
		arg0_29:emit(SpWeaponDesignMediator.ON_COMPOSITE, var0_29.spWeaponVO:GetConfigID())
	end)

	arg0_29.desgins[arg1_29] = var0_29
end

function var0_0.updateDesign(arg0_31, arg1_31, arg2_31)
	local var0_31 = arg0_31.desgins[arg2_31]

	if not var0_31 then
		arg0_31:initDesign(arg2_31)

		var0_31 = arg0_31.desgins[arg2_31]
	end

	local var1_31 = arg0_31.filterCraftList[arg1_31 + 1]

	var0_31:update(var1_31)
end

function var0_0.returnDesign(arg0_32, arg1_32, arg2_32)
	if arg0_32.exited then
		return
	end

	local var0_32 = arg0_32.desgins[arg2_32]

	if var0_32 then
		var0_32:clear()
	end
end

function var0_0.getDesignVO(arg0_33, arg1_33)
	return arg1_33
end

local var2_0 = require("view.equipment.SpWeaponSortCfg")

function var0_0.filter(arg0_34)
	local var0_34 = arg0_34:isDefaultStatus() and "shaixuan_off" or "shaixuan_on"

	GetSpriteFromAtlasAsync("ui/share/index_atlas", var0_34, function(arg0_35)
		setImageSprite(arg0_34.indexBtn, arg0_35, true)
	end)

	local var1_34 = {}

	for iter0_34, iter1_34 in pairs(arg0_34.craftList) do
		if IndexConst.filterSpWeaponByType(iter1_34, arg0_34.contextData.indexDatas.typeIndex) and IndexConst.filterSpWeaponByRarity(iter1_34, arg0_34.contextData.indexDatas.rarityIndex) and (arg0_34.contextData.showOwned or not iter1_34.owned) then
			table.insert(var1_34, iter1_34)
		end
	end

	local var2_34 = arg0_34.contextData.asc
	local var3_34 = arg0_34.contextData.index or 1

	table.sort(var1_34, CompareFuncs(var2_0.sortFunc(var2_0.sort[1], var2_34)))

	arg0_34.filterCraftList = var1_34

	arg0_34:UpdateCraftList()

	local var4_34 = GetSpriteFromAtlas("ui/equipmentdesignui_atlas", var1_0[var3_34])

	setImageSprite(arg0_34.sortBtn:Find("Image"), var4_34)
	setActive(arg0_34.sortImgAsc, arg0_34.contextData.asc)
	setActive(arg0_34.sortImgDec, not arg0_34.contextData.asc)
end

function var0_0.UpdateCraftList(arg0_36)
	arg0_36.scollRect:SetTotalCount(#arg0_36.filterCraftList)
	setActive(arg0_36.listEmptyTF, #arg0_36.filterCraftList <= 0)
	Canvas.ForceUpdateCanvases()
end

function var0_0.onBackPressed(arg0_37)
	if isActive(arg0_37.indexPanel) then
		triggerButton(arg0_37.indexPanel)

		return
	end

	pg.CriMgr.GetInstance():PlaySoundEffect_V3(SFX_CANCEL)
	arg0_37:emit(var0_0.ON_BACK)
end

function var0_0.willExit(arg0_38)
	arg0_38:UnOverlayPanel(arg0_38.indexPanel, arg0_38._tf)
	setParent(arg0_38.toggleOwned, arg0_38._tf)
	setParent(arg0_38.top, arg0_38._tf)
end

return var0_0
