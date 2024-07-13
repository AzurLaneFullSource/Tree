local var0_0 = class("SpWeaponDesignLayer", import("view.base.BaseUI"))

function var0_0.getUIName(arg0_1)
	return "SpWeaponDesignUI"
end

function var0_0.SetCraftList(arg0_2, arg1_2)
	arg0_2.craftList = arg1_2
end

function var0_0.SetSpWeapons(arg0_3, arg1_3)
	assert(arg0_3.craftList)

	if arg0_3.craftList then
		_.each(arg0_3.craftList, function(arg0_4)
			arg0_4.owned = arg0_4:IsUnique() and table.Find(arg1_3, function(arg0_5, arg1_5)
				return arg1_5:GetOriginID() == arg0_4:GetConfigID()
			end) and true or false
		end)
	end
end

function var0_0.setItems(arg0_6, arg1_6)
	arg0_6.itemVOs = arg1_6
end

function var0_0.setPlayer(arg0_7, arg1_7)
	arg0_7.player = arg1_7
end

function var0_0.init(arg0_8)
	arg0_8.designScrollView = arg0_8:findTF("equipment_scrollview")
	arg0_8.equipmentTpl = arg0_8:findTF("Template")

	setActive(arg0_8.equipmentTpl, false)

	arg0_8.equipmentContainer = arg0_8:findTF("equipment_grid", arg0_8.designScrollView)

	local var0_8

	if NotchAdapt.CheckNotchRatio == 2 or not getProxy(SettingsProxy):CheckLargeScreen() then
		var0_8 = arg0_8.designScrollView.rect.width > 2000
	else
		var0_8 = NotchAdapt.CheckNotchRatio >= 2
	end

	arg0_8.equipmentContainer:GetComponent(typeof(GridLayoutGroup)).constraintCount = var0_8 and 8 or 7
	arg0_8.top = arg0_8:findTF("top")
	arg0_8.toggleOwned = arg0_8:findTF("toggle_owned")
	arg0_8.sortBtn = arg0_8:findTF("sort_button", arg0_8.top)
	arg0_8.indexBtn = arg0_8:findTF("index_button", arg0_8.top)
	arg0_8.decBtn = arg0_8:findTF("dec_btn", arg0_8.sortBtn)
	arg0_8.sortImgAsc = arg0_8:findTF("desc", arg0_8.decBtn)
	arg0_8.sortImgDec = arg0_8:findTF("asc", arg0_8.decBtn)
	arg0_8.indexPanel = arg0_8:findTF("index")
	arg0_8.tagContainer = arg0_8:findTF("adapt/mask/panel", arg0_8.indexPanel)
	arg0_8.tagTpl = arg0_8:findTF("tpl", arg0_8.tagContainer)
	arg0_8.listEmptyTF = arg0_8:findTF("empty")

	setActive(arg0_8.listEmptyTF, false)

	arg0_8.listEmptyTxt = arg0_8:findTF("Text", arg0_8.listEmptyTF)

	setText(arg0_8.listEmptyTxt, i18n("list_empty_tip_equipmentdesignui"))
	pg.UIMgr.GetInstance():OverlayPanel(arg0_8.indexPanel, {
		groupName = LayerWeightConst.GROUP_EQUIPMENTSCENE
	})
end

function var0_0.SetParentTF(arg0_9, arg1_9)
	arg0_9.parentTF = arg1_9
	arg0_9.equipmentView = arg0_9:findTF("equipment_scrollview", arg0_9.parentTF)

	setActive(arg0_9.equipmentView, false)
end

function var0_0.SetTopContainer(arg0_10, arg1_10)
	arg0_10.topPanel = arg1_10
end

function var0_0.SetTopItems(arg0_11, arg1_11)
	arg0_11.topItems = arg1_11
end

local var1_0 = {
	"sort_rarity"
}

function var0_0.didEnter(arg0_12)
	setParent(arg0_12._tf, arg0_12.parentTF)

	local var0_12 = arg0_12.equipmentView:GetSiblingIndex()

	arg0_12._tf:SetSiblingIndex(var0_12)

	arg0_12.contextData.indexDatas = arg0_12.contextData.indexDatas or {}
	arg0_12.contextData.index = arg0_12.contextData.index or 1

	setParent(arg0_12.top, arg0_12.topPanel)
	setParent(arg0_12.toggleOwned, arg0_12.topItems:Find("adapt/bottom_back"))
	arg0_12:initDesigns()
	onToggle(arg0_12, arg0_12.sortBtn, function(arg0_13)
		setActive(arg0_12.indexPanel, arg0_13)
	end, SFX_PANEL)
	onButton(arg0_12, arg0_12.indexPanel, function()
		triggerToggle(arg0_12.sortBtn, false)
	end, SFX_PANEL)
	onButton(arg0_12, arg0_12.indexBtn, function()
		local var0_15 = {
			indexDatas = Clone(arg0_12.contextData.indexDatas),
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
			callback = function(arg0_16)
				if not isActive(arg0_12._tf) then
					return
				end

				arg0_12.contextData.indexDatas.typeIndex = arg0_16.typeIndex
				arg0_12.contextData.indexDatas.rarityIndex = arg0_16.rarityIndex

				arg0_12:filter()
			end
		}

		arg0_12:emit(SpWeaponDesignMediator.OPEN_EQUIPMENTDESIGN_INDEX, var0_15)
	end, SFX_PANEL)

	arg0_12.contextData.showOwned = defaultValue(arg0_12.contextData.showOwned, false)

	triggerToggle(arg0_12.toggleOwned, arg0_12.contextData.showOwned)
	onToggle(arg0_12, arg0_12.toggleOwned, function(arg0_17)
		arg0_12.contextData.showOwned = arg0_17

		arg0_12:filter()
	end)
	arg0_12:initTags()
end

function var0_0.isDefaultStatus(arg0_18)
	return (not arg0_18.contextData.indexDatas.typeIndex or arg0_18.contextData.indexDatas.typeIndex == IndexConst.SpWeaponTypeAll) and (not arg0_18.contextData.indexDatas.rarityIndex or arg0_18.contextData.indexDatas.rarityIndex == IndexConst.SpWeaponRarityAll)
end

function var0_0.initTags(arg0_19)
	onButton(arg0_19, arg0_19.decBtn, function()
		arg0_19.contextData.asc = not arg0_19.contextData.asc

		arg0_19:filter()
	end)

	arg0_19.tagTFs = {}

	eachChild(arg0_19.tagContainer, function(arg0_21)
		setActive(arg0_21, false)
	end)

	for iter0_19, iter1_19 in ipairs(var1_0) do
		local var0_19 = iter0_19 <= arg0_19.tagContainer.childCount and arg0_19.tagContainer:GetChild(iter0_19 - 1) or cloneTplTo(arg0_19.tagTpl, arg0_19.tagContainer)

		setActive(var0_19, true)
		setImageSprite(findTF(var0_19, "Image"), GetSpriteFromAtlas("ui/equipmentdesignui_atlas", iter1_19))
		onToggle(arg0_19, var0_19, function(arg0_22)
			if arg0_22 then
				arg0_19.contextData.index = iter0_19

				arg0_19:filter()
			end

			triggerButton(arg0_19.indexPanel)
		end, SFX_PANEL)
		table.insert(arg0_19.tagTFs, var0_19)
	end

	triggerToggle(arg0_19.tagTFs[arg0_19.contextData.index], true)
end

function var0_0.initDesigns(arg0_23)
	arg0_23.scollRect = arg0_23.designScrollView:GetComponent("LScrollRect")
	arg0_23.scollRect.decelerationRate = 0.07

	function arg0_23.scollRect.onInitItem(arg0_24)
		arg0_23:initDesign(arg0_24)
	end

	function arg0_23.scollRect.onUpdateItem(arg0_25, arg1_25)
		arg0_23:updateDesign(arg0_25, arg1_25)
	end

	function arg0_23.scollRect.onReturnItem(arg0_26, arg1_26)
		arg0_23:returnDesign(arg0_26, arg1_26)
	end

	arg0_23.desgins = {}
end

function var0_0.initDesign(arg0_27, arg1_27)
	local var0_27 = SpWeaponItemView.New(arg1_27)

	onButton(arg0_27, var0_27.go, function()
		arg0_27:emit(SpWeaponDesignMediator.ON_COMPOSITE, var0_27.spWeaponVO:GetConfigID())
	end)

	arg0_27.desgins[arg1_27] = var0_27
end

function var0_0.updateDesign(arg0_29, arg1_29, arg2_29)
	local var0_29 = arg0_29.desgins[arg2_29]

	if not var0_29 then
		arg0_29:initDesign(arg2_29)

		var0_29 = arg0_29.desgins[arg2_29]
	end

	local var1_29 = arg0_29.filterCraftList[arg1_29 + 1]

	var0_29:update(var1_29)
end

function var0_0.returnDesign(arg0_30, arg1_30, arg2_30)
	if arg0_30.exited then
		return
	end

	local var0_30 = arg0_30.desgins[arg2_30]

	if var0_30 then
		var0_30:clear()
	end
end

function var0_0.getDesignVO(arg0_31, arg1_31)
	return arg1_31
end

local var2_0 = require("view.equipment.SpWeaponSortCfg")

function var0_0.filter(arg0_32)
	local var0_32 = arg0_32:isDefaultStatus() and "shaixuan_off" or "shaixuan_on"

	GetSpriteFromAtlasAsync("ui/share/index_atlas", var0_32, function(arg0_33)
		setImageSprite(arg0_32.indexBtn, arg0_33, true)
	end)

	local var1_32 = {}

	for iter0_32, iter1_32 in pairs(arg0_32.craftList) do
		if IndexConst.filterSpWeaponByType(iter1_32, arg0_32.contextData.indexDatas.typeIndex) and IndexConst.filterSpWeaponByRarity(iter1_32, arg0_32.contextData.indexDatas.rarityIndex) and (arg0_32.contextData.showOwned or not iter1_32.owned) then
			table.insert(var1_32, iter1_32)
		end
	end

	local var2_32 = arg0_32.contextData.asc
	local var3_32 = arg0_32.contextData.index or 1

	table.sort(var1_32, CompareFuncs(var2_0.sortFunc(var2_0.sort[1], var2_32)))

	arg0_32.filterCraftList = var1_32

	arg0_32:UpdateCraftList()

	local var4_32 = GetSpriteFromAtlas("ui/equipmentdesignui_atlas", var1_0[var3_32])

	setImageSprite(arg0_32:findTF("Image", arg0_32.sortBtn), var4_32)
	setActive(arg0_32.sortImgAsc, arg0_32.contextData.asc)
	setActive(arg0_32.sortImgDec, not arg0_32.contextData.asc)
end

function var0_0.UpdateCraftList(arg0_34)
	arg0_34.scollRect:SetTotalCount(#arg0_34.filterCraftList)
	setActive(arg0_34.listEmptyTF, #arg0_34.filterCraftList <= 0)
	Canvas.ForceUpdateCanvases()
end

function var0_0.onBackPressed(arg0_35)
	if isActive(arg0_35.indexPanel) then
		triggerButton(arg0_35.indexPanel)

		return
	end

	pg.CriMgr.GetInstance():PlaySoundEffect_V3(SFX_CANCEL)
	arg0_35:emit(var0_0.ON_BACK)
end

function var0_0.willExit(arg0_36)
	pg.UIMgr.GetInstance():UnOverlayPanel(arg0_36.indexPanel, arg0_36._tf)
	setParent(arg0_36.toggleOwned, arg0_36._tf)
	setParent(arg0_36.top, arg0_36._tf)
end

return var0_0
