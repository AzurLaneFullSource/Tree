local var0 = class("SpWeaponDesignLayer", import("view.base.BaseUI"))

function var0.getUIName(arg0)
	return "SpWeaponDesignUI"
end

function var0.SetCraftList(arg0, arg1)
	arg0.craftList = arg1
end

function var0.SetSpWeapons(arg0, arg1)
	assert(arg0.craftList)

	if arg0.craftList then
		_.each(arg0.craftList, function(arg0)
			arg0.owned = arg0:IsUnique() and table.Find(arg1, function(arg0, arg1)
				return arg1:GetOriginID() == arg0:GetConfigID()
			end) and true or false
		end)
	end
end

function var0.setItems(arg0, arg1)
	arg0.itemVOs = arg1
end

function var0.setPlayer(arg0, arg1)
	arg0.player = arg1
end

function var0.init(arg0)
	arg0.designScrollView = arg0:findTF("equipment_scrollview")
	arg0.equipmentTpl = arg0:findTF("Template")

	setActive(arg0.equipmentTpl, false)

	arg0.equipmentContainer = arg0:findTF("equipment_grid", arg0.designScrollView)

	local var0

	if NotchAdapt.CheckNotchRatio == 2 or not getProxy(SettingsProxy):CheckLargeScreen() then
		var0 = arg0.designScrollView.rect.width > 2000
	else
		var0 = NotchAdapt.CheckNotchRatio >= 2
	end

	arg0.equipmentContainer:GetComponent(typeof(GridLayoutGroup)).constraintCount = var0 and 8 or 7
	arg0.top = arg0:findTF("top")
	arg0.toggleOwned = arg0:findTF("toggle_owned")
	arg0.sortBtn = arg0:findTF("sort_button", arg0.top)
	arg0.indexBtn = arg0:findTF("index_button", arg0.top)
	arg0.decBtn = arg0:findTF("dec_btn", arg0.sortBtn)
	arg0.sortImgAsc = arg0:findTF("desc", arg0.decBtn)
	arg0.sortImgDec = arg0:findTF("asc", arg0.decBtn)
	arg0.indexPanel = arg0:findTF("index")
	arg0.tagContainer = arg0:findTF("adapt/mask/panel", arg0.indexPanel)
	arg0.tagTpl = arg0:findTF("tpl", arg0.tagContainer)
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

function var0.SetTopItems(arg0, arg1)
	arg0.topItems = arg1
end

local var1 = {
	"sort_rarity"
}

function var0.didEnter(arg0)
	setParent(arg0._tf, arg0.parentTF)

	local var0 = arg0.equipmentView:GetSiblingIndex()

	arg0._tf:SetSiblingIndex(var0)

	arg0.contextData.indexDatas = arg0.contextData.indexDatas or {}
	arg0.contextData.index = arg0.contextData.index or 1

	setParent(arg0.top, arg0.topPanel)
	setParent(arg0.toggleOwned, arg0.topItems:Find("adapt/bottom_back"))
	arg0:initDesigns()
	onToggle(arg0, arg0.sortBtn, function(arg0)
		setActive(arg0.indexPanel, arg0)
	end, SFX_PANEL)
	onButton(arg0, arg0.indexPanel, function()
		triggerToggle(arg0.sortBtn, false)
	end, SFX_PANEL)
	onButton(arg0, arg0.indexBtn, function()
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
				if not isActive(arg0._tf) then
					return
				end

				arg0.contextData.indexDatas.typeIndex = arg0.typeIndex
				arg0.contextData.indexDatas.rarityIndex = arg0.rarityIndex

				arg0:filter()
			end
		}

		arg0:emit(SpWeaponDesignMediator.OPEN_EQUIPMENTDESIGN_INDEX, var0)
	end, SFX_PANEL)

	arg0.contextData.showOwned = defaultValue(arg0.contextData.showOwned, false)

	triggerToggle(arg0.toggleOwned, arg0.contextData.showOwned)
	onToggle(arg0, arg0.toggleOwned, function(arg0)
		arg0.contextData.showOwned = arg0

		arg0:filter()
	end)
	arg0:initTags()
end

function var0.isDefaultStatus(arg0)
	return (not arg0.contextData.indexDatas.typeIndex or arg0.contextData.indexDatas.typeIndex == IndexConst.SpWeaponTypeAll) and (not arg0.contextData.indexDatas.rarityIndex or arg0.contextData.indexDatas.rarityIndex == IndexConst.SpWeaponRarityAll)
end

function var0.initTags(arg0)
	onButton(arg0, arg0.decBtn, function()
		arg0.contextData.asc = not arg0.contextData.asc

		arg0:filter()
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
				arg0.contextData.index = iter0

				arg0:filter()
			end

			triggerButton(arg0.indexPanel)
		end, SFX_PANEL)
		table.insert(arg0.tagTFs, var0)
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

function var0.initDesign(arg0, arg1)
	local var0 = SpWeaponItemView.New(arg1)

	onButton(arg0, var0.go, function()
		arg0:emit(SpWeaponDesignMediator.ON_COMPOSITE, var0.spWeaponVO:GetConfigID())
	end)

	arg0.desgins[arg1] = var0
end

function var0.updateDesign(arg0, arg1, arg2)
	local var0 = arg0.desgins[arg2]

	if not var0 then
		arg0:initDesign(arg2)

		var0 = arg0.desgins[arg2]
	end

	local var1 = arg0.filterCraftList[arg1 + 1]

	var0:update(var1)
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
	return arg1
end

local var2 = require("view.equipment.SpWeaponSortCfg")

function var0.filter(arg0)
	local var0 = arg0:isDefaultStatus() and "shaixuan_off" or "shaixuan_on"

	GetSpriteFromAtlasAsync("ui/share/index_atlas", var0, function(arg0)
		setImageSprite(arg0.indexBtn, arg0, true)
	end)

	local var1 = {}

	for iter0, iter1 in pairs(arg0.craftList) do
		if IndexConst.filterSpWeaponByType(iter1, arg0.contextData.indexDatas.typeIndex) and IndexConst.filterSpWeaponByRarity(iter1, arg0.contextData.indexDatas.rarityIndex) and (arg0.contextData.showOwned or not iter1.owned) then
			table.insert(var1, iter1)
		end
	end

	local var2 = arg0.contextData.asc
	local var3 = arg0.contextData.index or 1

	table.sort(var1, CompareFuncs(var2.sortFunc(var2.sort[1], var2)))

	arg0.filterCraftList = var1

	arg0:UpdateCraftList()

	local var4 = GetSpriteFromAtlas("ui/equipmentdesignui_atlas", var1[var3])

	setImageSprite(arg0:findTF("Image", arg0.sortBtn), var4)
	setActive(arg0.sortImgAsc, arg0.contextData.asc)
	setActive(arg0.sortImgDec, not arg0.contextData.asc)
end

function var0.UpdateCraftList(arg0)
	arg0.scollRect:SetTotalCount(#arg0.filterCraftList)
	setActive(arg0.listEmptyTF, #arg0.filterCraftList <= 0)
	Canvas.ForceUpdateCanvases()
end

function var0.onBackPressed(arg0)
	if isActive(arg0.indexPanel) then
		triggerButton(arg0.indexPanel)

		return
	end

	pg.CriMgr.GetInstance():PlaySoundEffect_V3(SFX_CANCEL)
	arg0:emit(var0.ON_BACK)
end

function var0.willExit(arg0)
	pg.UIMgr.GetInstance():UnOverlayPanel(arg0.indexPanel, arg0._tf)
	setParent(arg0.toggleOwned, arg0._tf)
	setParent(arg0.top, arg0._tf)
end

return var0
