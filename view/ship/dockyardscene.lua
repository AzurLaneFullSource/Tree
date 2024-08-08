local var0_0 = class("DockyardScene", import("..base.BaseUI"))
local var1_0 = 2
local var2_0 = 0.2
local var3_0 = 1

var0_0.MODE_OVERVIEW = "overview"
var0_0.MODE_DESTROY = "destroy"
var0_0.MODE_SELECT = "select"
var0_0.MODE_MOD = "modify"
var0_0.MODE_WORLD = "world"
var0_0.MODE_REMOULD = "remould"
var0_0.MODE_UPGRADE = "upgrade"
var0_0.MODE_GUILD_BOSS = "guildboss"
var0_0.TITLE_CN_OVERVIEW = i18n("word_dockyard")
var0_0.TITLE_CN_UPGRADE = i18n("word_dockyardUpgrade")
var0_0.TITLE_CN_DESTROY = i18n("word_dockyardDestroy")
var0_0.TITLE_EN_OVERVIEW = "dockyard"
var0_0.TITLE_EN_UPGRADE = "modernization"
var0_0.TITLE_EN_DESTROY = "retirement"
var0_0.PRIOR_MODE_EQUIP_UP = 1
var0_0.PRIOR_MODE_SHIP_UP = 2

function var0_0.getUIName(arg0_1)
	return "DockyardUI"
end

function var0_0.init(arg0_2)
	arg0_2._tf:SetAsLastSibling()

	local var0_2 = arg0_2.contextData

	var0_2.mode = defaultValue(var0_2.mode, var0_0.MODE_SELECT)
	var0_2.otherSelectedIds = defaultValue(var0_2.otherSelectedIds, {})
	arg0_2.teamTypeFilter = var0_2.teamFilter
	arg0_2.selectedMin = var0_2.selectedMin or 1
	arg0_2.leastLimitMsg = var0_2.leastLimitMsg
	arg0_2.selectedMax = var0_2.selectedMax or 0
	var0_2.selectedIds = var0_2.selectedIds or {}

	if var0_2.infoShipId then
		table.insert(var0_2.selectedIds, var0_2.infoShipId)

		var0_2.infoShipId = nil
	end

	arg0_2.selectedIds = underscore(var0_2.selectedIds):chain():select(function(arg0_3)
		return getProxy(BayProxy):RawGetShipById(arg0_3) ~= nil
	end):first(arg0_2.selectedMax):value()
	var0_2.selectedIds = nil
	arg0_2.checkShip = var0_2.onShip or function(arg0_4, arg1_4, arg2_4)
		return true
	end
	arg0_2.onCancelShip = var0_2.onCancelShip or function(arg0_5, arg1_5, arg2_5)
		return true
	end
	arg0_2.onClick = var0_2.onClick or function(arg0_6, arg1_6, arg2_6)
		arg0_2:emit(DockyardMediator.ON_SHIP_DETAIL, arg0_6, arg1_6, arg2_6)
	end
	arg0_2.confirmSelect = var0_2.confirmSelect
	arg0_2.callbackQuit = var0_2.callbackQuit
	arg0_2.onSelected = var0_2.onSelected or function(arg0_7, arg1_7)
		warning("not implemented.")
	end
	arg0_2.blurPanel = arg0_2:findTF("blur_panel")
	arg0_2.settingBtn = arg0_2.blurPanel:Find("adapt/left_length/frame/setting")
	arg0_2.settingPanel = DockyardQuickSelectSettingPage.New(arg0_2._tf, arg0_2.event)

	arg0_2.settingPanel:OnSettingChanged(function()
		arg0_2:unselecteAllShips()
	end)

	arg0_2.topPanel = arg0_2.blurPanel:Find("adapt/top")
	arg0_2.sortBtn = arg0_2.topPanel:Find("sort_button")
	arg0_2.sortImgAsc = arg0_2.sortBtn:Find("asc")
	arg0_2.sortImgDesc = arg0_2.sortBtn:Find("desc")
	arg0_2.leftTipsText = arg0_2.topPanel:Find("capacity")

	onButton(arg0_2, arg0_2.leftTipsText:Find("switch"), function()
		arg0_2.isCapacityMeta = not arg0_2.isCapacityMeta

		arg0_2:updateCapacityDisplay()
	end, SFX_PANEL)
	onButton(arg0_2, arg0_2.leftTipsText:Find("plus"), function()
		gotoChargeScene()
	end, SFX_PANEL)
	onButton(arg0_2, arg0_2.leftTipsText:Find("tip"), function()
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			hideNo = true,
			content = i18n("specialshipyard_tip")
		})
	end, SFX_PANEL)
	setActive(arg0_2.leftTipsText, false)

	arg0_2.indexBtn = arg0_2.topPanel:Find("index_button")
	arg0_2.switchPanel = arg0_2.topPanel:Find("switch")

	triggerToggle(arg0_2.switchPanel:Find("Image"), true)

	arg0_2.preferenceBtn = arg0_2.switchPanel:Find("toggles/preference_toggle")
	arg0_2.attrBtn = arg0_2.switchPanel:Find("toggles/attr_toggle")
	arg0_2.nameSearchInput = arg0_2.switchPanel:Find("search")

	setText(arg0_2.nameSearchInput:Find("holder"), i18n("dockyard_search_holder"))
	setInputText(arg0_2.nameSearchInput, "")
	onInputChanged(arg0_2, arg0_2.nameSearchInput, function()
		arg0_2:filter()
	end)

	arg0_2.modLockFilter = arg0_2:findTF("mod_flter_lock", arg0_2.topPanel)
	arg0_2.modLeveFilter = arg0_2:findTF("mod_flter_level", arg0_2.topPanel)
	arg0_2.energyDescTF = arg0_2:findTF("energy_desc")
	arg0_2.energyDescTextTF = arg0_2.energyDescTF:Find("Text")
	arg0_2.selectPanel = arg0_2.blurPanel:Find("select_panel")
	arg0_2.bottomTipsText = arg0_2.selectPanel:Find("tip")
	arg0_2.bottomTipsWithFrame = arg0_2.selectPanel:Find("tipwithframe")

	setText(arg0_2.selectPanel:Find("bottom_info/bg_input/selected"), i18n("disassemble_selected") .. ":")

	arg0_2.awardTF = arg0_2.selectPanel:Find("bottom_info/bg_award")

	setText(arg0_2.awardTF:Find("label"), i18n("disassemble_available") .. ":")

	arg0_2.modAttrsTF = arg0_2.selectPanel:Find("bottom_info/bg_mod")
	arg0_2.viewEquipmentBtn = arg0_2.selectPanel:Find("view_equipments")
	arg0_2.tipPanel = arg0_2.blurPanel:Find("TipPanel")

	setActive(arg0_2.tipPanel, false)

	arg0_2.worldPanel = arg0_2.blurPanel:Find("world_port_panel")

	setActive(arg0_2.worldPanel, arg0_2.contextData.mode == var0_0.MODE_WORLD)

	arg0_2.assultBtn = arg0_2.blurPanel:Find("adapt/top/assult_btn")
	arg0_2.stampBtn = arg0_2.topPanel:Find("stamp")
	arg0_2.isRemouldOrUpgradeMode = arg0_2.contextData.mode == var0_0.MODE_REMOULD or arg0_2.contextData.mode == var0_0.MODE_UPGRADE

	setActive(arg0_2.switchPanel, not arg0_2.isRemouldOrUpgradeMode)
	setActive(arg0_2.indexBtn, not arg0_2.isRemouldOrUpgradeMode)
	setActive(arg0_2.sortBtn, not arg0_2.isRemouldOrUpgradeMode)
	setActive(arg0_2.modLeveFilter, arg0_2.isRemouldOrUpgradeMode)
	setActive(arg0_2.modLockFilter, arg0_2.isRemouldOrUpgradeMode)
	setActive(arg0_2.assultBtn, arg0_2.contextData.mode == var0_0.MODE_GUILD_BOSS)
	switch(arg0_2.contextData.mode, {
		[var0_0.MODE_OVERVIEW] = function()
			arg0_2.selecteEnabled = false
		end,
		[var0_0.MODE_DESTROY] = function()
			arg0_2.selecteEnabled = true
			arg0_2.blacklist = {}
			arg0_2.destroyResList = UIItemList.New(arg0_2.awardTF:Find("res_list"), arg0_2.awardTF:Find("res_list/res"))
		end,
		[var0_0.MODE_MOD] = function()
			arg0_2.selecteEnabled = true

			setText(arg0_2.modAttrsTF:Find("title/Text"), i18n("word_mod_value"))

			arg0_2.modAttrContainer = arg0_2.modAttrsTF:Find("attrs")
		end
	}, function()
		arg0_2.selecteEnabled = true
	end)
	setActive(arg0_2.selectPanel, arg0_2.selecteEnabled and arg0_2.contextData.mode ~= var0_0.MODE_WORLD)
	setActive(arg0_2.worldPanel, arg0_2.contextData.mode == var0_0.MODE_WORLD)

	local var1_2 = arg0_2.contextData.mode == var0_0.MODE_DESTROY

	setActive(arg0_2.settingBtn, var1_2)
	setActive(arg0_2.selectPanel:Find("quick_select"), var1_2)

	if arg0_2.contextData.priorEquipUpShipIDList and arg0_2.contextData.priorMode then
		setActive(arg0_2.tipPanel, true)

		local var2_2 = arg0_2:findTF("EquipUP", arg0_2.tipPanel)
		local var3_2 = arg0_2:findTF("ShipUP", arg0_2.tipPanel)

		setText(var2_2, i18n("fightfail_choiceequip"))
		setText(var3_2, i18n("fightfail_choicestrengthen"))
		setActive(var2_2, arg0_2.contextData.priorMode == var0_0.PRIOR_MODE_EQUIP_UP)
		setActive(var3_2, arg0_2.contextData.priorMode == var0_0.PRIOR_MODE_SHIP_UP)
	end

	if arg0_2.contextData.selectFriend then
		arg0_2.shipContainer = arg0_2:findTF("main/friend_container/ships"):GetComponent("LScrollRect")
	else
		arg0_2.shipContainer = arg0_2:findTF("main/ship_container/ships"):GetComponent("LScrollRect")
	end

	arg0_2.shipContainer.enabled = true
	arg0_2.shipContainer.decelerationRate = 0.07

	setActive(arg0_2:findTF("main/ship_container"), not arg0_2.contextData.selectFriend)

	function arg0_2.shipContainer.onInitItem(arg0_17)
		arg0_2:onInitItem(arg0_17)
	end

	function arg0_2.shipContainer.onUpdateItem(arg0_18, arg1_18)
		arg0_2:onUpdateItem(arg0_18, arg1_18)
	end

	function arg0_2.shipContainer.onReturnItem(arg0_19, arg1_19)
		arg0_2:onReturnItem(arg0_19, arg1_19)
	end

	function arg0_2.shipContainer.onStart()
		arg0_2:updateSelected()
	end

	arg0_2.shipLayout = arg0_2:findTF("main/ship_container/ships")
	arg0_2.scrollItems = {}

	local var4_2 = _G[arg0_2.contextData.preView]

	if var4_2 then
		arg0_2.sortIndex = var4_2.sortIndex or ShipIndexConst.SortLevel
		arg0_2.selectAsc = var4_2.selectAsc or false
		arg0_2.typeIndex = var4_2.typeIndex or ShipIndexConst.TypeAll
		arg0_2.campIndex = var4_2.campIndex or ShipIndexConst.CampAll
		arg0_2.rarityIndex = var4_2.rarityIndex or ShipIndexConst.RarityAll
		arg0_2.extraIndex = var4_2.extraIndex or ShipIndexConst.ExtraAll
		arg0_2.commonTag = var4_2.commonTag or Ship.PREFERENCE_TAG_NONE
	elseif arg0_2.contextData.sortData then
		local var5_2 = arg0_2.contextData.sortData

		arg0_2.sortIndex = var5_2.sort or ShipIndexConst.SortLevel
		arg0_2.selectAsc = var5_2.Asc or false
		arg0_2.typeIndex = var5_2.typeIndex or ShipIndexConst.TypeAll
		arg0_2.campIndex = var5_2.campIndex or ShipIndexConst.CampAll
		arg0_2.rarityIndex = var5_2.rarityIndex or ShipIndexConst.RarityAll
		arg0_2.extraIndex = var5_2.extraIndex or ShipIndexConst.ExtraAll
		arg0_2.commonTag = var5_2.commonTag or Ship.PREFERENCE_TAG_NONE
	else
		arg0_2.selectAsc = DockyardScene.selectAsc or false
		arg0_2.sortIndex = DockyardScene.sortIndex or ShipIndexConst.SortLevel
		arg0_2.typeIndex = DockyardScene.typeIndex or ShipIndexConst.TypeAll
		arg0_2.campIndex = DockyardScene.campIndex or ShipIndexConst.CampAll
		arg0_2.rarityIndex = DockyardScene.rarityIndex or ShipIndexConst.RarityAll
		arg0_2.extraIndex = DockyardScene.extraIndex or ShipIndexConst.ExtraAll
		arg0_2.commonTag = DockyardScene.commonTag or Ship.PREFERENCE_TAG_NONE
	end

	arg0_2:updateIndexDatas()
	triggerToggle(arg0_2.preferenceBtn, arg0_2.commonTag == Ship.PREFERENCE_TAG_COMMON)
	arg0_2:initIndexPanel()

	arg0_2.itemDetailType = -1
	arg0_2.listEmptyTF = arg0_2:findTF("empty")

	setActive(arg0_2.listEmptyTF, false)

	arg0_2.listEmptyTxt = arg0_2:findTF("Text", arg0_2.listEmptyTF)

	setText(arg0_2.listEmptyTxt, i18n("list_empty_tip_dockyardui"))

	if arg0_2.contextData.mode == var0_0.MODE_DESTROY then
		arg0_2.blacklist = {}
		arg0_2.selectPanel:GetComponent("HorizontalLayoutGroup").padding.right = 50

		setActive(arg0_2.selectPanel:Find("quick_select"), true)
		setActive(arg0_2.settingBtn, true)
	else
		arg0_2.selectPanel:GetComponent("HorizontalLayoutGroup").padding.right = 90

		setActive(arg0_2.selectPanel:Find("quick_select"), false)
		setActive(arg0_2.settingBtn, false)
	end

	arg0_2.destroyPage = ShipDestroyPage.New(arg0_2._tf, arg0_2.event)

	arg0_2.destroyPage:SetCardClickCallBack(function(arg0_21)
		arg0_2.blacklist[arg0_21.shipVO:getGroupId()] = true

		local var0_21 = table.indexof(arg0_2.selectedIds, arg0_21.shipVO.id)

		if var0_21 and var0_21 > 0 then
			table.remove(arg0_2.selectedIds, var0_21)
		end

		arg0_2:updateDestroyRes()
		arg0_2:updateSelected()
	end)
	arg0_2.destroyPage:SetConfirmCallBack(function()
		local var0_22 = {}
		local var1_22, var2_22 = arg0_2:checkDestroyGold()

		if not var2_22 then
			table.insert(var0_22, function(arg0_23)
				pg.MsgboxMgr.GetInstance():ShowMsgBox({
					content = i18n("oil_max_tip_title") .. i18n("resource_max_tip_retire_1"),
					onYes = arg0_23
				})
			end)
		end

		local var3_22 = underscore.map(arg0_2.selectedIds, function(arg0_24)
			return arg0_2.shipVOsById[arg0_24]
		end)

		table.insert(var0_22, function(arg0_25)
			arg0_2:checkDestroyShips(var3_22, arg0_25)
		end)
		seriesAsync(var0_22, function()
			arg0_2:emit(DockyardMediator.ON_DESTROY_SHIPS, arg0_2.selectedIds)
		end)
	end)

	arg0_2.destroyConfirmWindow = ShipDestoryConfirmWindow.New(arg0_2._tf, arg0_2.event)
end

function var0_0.isDefaultStatus(arg0_27)
	return arg0_27.sortIndex == ShipIndexConst.SortLevel and (not arg0_27.typeIndex or arg0_27.typeIndex == ShipIndexConst.TypeAll) and (not arg0_27.campIndex or arg0_27.campIndex == ShipIndexConst.CampAll) and (not arg0_27.rarityIndex or arg0_27.rarityIndex == ShipIndexConst.RarityAll) and (not arg0_27.extraIndex or arg0_27.extraIndex == ShipIndexConst.ExtraAll)
end

function var0_0.setShipsCount(arg0_28, arg1_28, arg2_28)
	arg0_28.shipsCount = arg1_28
	arg0_28.specialShipCount = arg2_28
end

function var0_0.GetCard(arg0_29, arg1_29)
	local var0_29

	if arg0_29.contextData.selectFriend then
		var0_29 = DockyardFriend.New(arg1_29)
	else
		var0_29 = DockyardShipItem.New(arg1_29, arg0_29.contextData.hideTagFlags, arg0_29.contextData.blockTagFlags)
	end

	return var0_29
end

function var0_0.OnClickCard(arg0_30, arg1_30)
	if arg1_30.shipVO then
		if not arg0_30.selecteEnabled then
			pg.CriMgr.GetInstance():PlaySoundEffect_V3(SFX_UI_CLICK)

			DockyardScene.value = arg0_30.shipContainer.value

			arg0_30.onClick(arg1_30.shipVO, arg0_30.shipVOs)
		else
			pg.CriMgr.GetInstance():PlaySoundEffect_V3(table.contains(arg0_30.selectedIds, arg1_30.shipVO.id) and SFX_UI_CANCEL or SFX_UI_FORMATION_SELECT)
			arg0_30:selectShip(arg1_30.shipVO)
		end
	else
		pg.CriMgr.GetInstance():PlaySoundEffect_V3(SFX_UI_CLICK)

		if arg0_30.callbackQuit then
			arg0_30.onSelected({}, function()
				arg0_30:back()
			end)
		elseif not arg1_30.isLoading then
			arg0_30.onSelected({})
			arg0_30:back()
		end
	end
end

function var0_0.onInitItem(arg0_32, arg1_32)
	local var0_32 = arg0_32:GetCard(arg1_32)

	var0_32:updateDetail(arg0_32.itemDetailType)

	var0_32.isLoading = true

	onButton(arg0_32, var0_32.go, function()
		arg0_32:OnClickCard(var0_32)
	end)

	local var1_32 = GetOrAddComponent(var0_32.go, "UILongPressTrigger").onLongPressed

	if arg0_32.contextData.preView == NewBackYardShipInfoLayer.__cname then
		var1_32:RemoveAllListeners()
		var1_32:AddListener(function()
			if var0_32.shipVO then
				arg0_32.contextData.selectedIds = arg0_32.selectedIds

				arg0_32.onClick(var0_32.shipVO, underscore.select(arg0_32.shipVOs, function(arg0_35)
					return arg0_35
				end), arg0_32.contextData)
			end
		end)
	else
		var1_32:RemoveAllListeners()
	end

	arg0_32.scrollItems[arg1_32] = var0_32

	return var0_32
end

function var0_0.showEnergyDesc(arg0_36, arg1_36, arg2_36)
	if LeanTween.isTweening(go(arg0_36.energyDescTF)) then
		LeanTween.cancel(go(arg0_36.energyDescTF))

		arg0_36.energyDescTF.localScale = Vector3.one
	end

	setText(arg0_36.energyDescTextTF, i18n(arg2_36))

	arg0_36.energyDescTF.position = arg1_36

	setActive(arg0_36.energyDescTF, true)
	LeanTween.scale(arg0_36.energyDescTF, Vector3.zero, 0.2):setDelay(1):setFrom(Vector3.one):setOnComplete(System.Action(function()
		arg0_36.energyDescTF.localScale = Vector3.one

		setActive(arg0_36.energyDescTF, false)
	end))
end

function var0_0.onUpdateItem(arg0_38, arg1_38, arg2_38)
	local var0_38 = arg0_38.scrollItems[arg2_38] or arg0_38:onInitItem(arg2_38)
	local var1_38 = arg0_38.shipVOs[arg1_38 + 1]

	if arg0_38.contextData.selectFriend then
		var0_38:update(var1_38, arg0_38.friends)
	else
		var0_38:update(var1_38)
	end

	if arg0_38.contextData.mode == DockyardScene.MODE_WORLD then
		var0_38:updateWorld()
	end

	local var2_38 = false

	if var0_38.shipVO then
		for iter0_38, iter1_38 in ipairs(arg0_38.selectedIds) do
			if var0_38.shipVO.id == iter1_38 then
				var2_38 = true

				break
			end
		end
	end

	var0_38:updateSelected(var2_38)
	arg0_38:updateItemBlackBlock(var0_38)

	var0_38.isLoading = false

	var0_38:updateIntimacyEnergy(arg0_38.contextData.energyDisplay or arg0_38.sortIndex == ShipIndexConst.SortEnergy)

	local var3_38 = (arg0_38.sortIndex == ShipIndexConst.SortIntimacy or arg0_38.extraIndex == ShipIndexConst.ExtraMarry) and arg0_38.contextData.mode ~= DockyardScene.MODE_UPGRADE

	var0_38:updateIntimacy(var3_38)
end

function var0_0.onReturnItem(arg0_39, arg1_39, arg2_39)
	if arg0_39.exited then
		return
	end

	local var0_39 = arg0_39.scrollItems[arg2_39]

	if var0_39 then
		var0_39:clear()
	end
end

function var0_0.updateIndexDatas(arg0_40)
	arg0_40.contextData.indexDatas = arg0_40.contextData.indexDatas or {}
	arg0_40.contextData.indexDatas.sortIndex = arg0_40.sortIndex
	arg0_40.contextData.indexDatas.typeIndex = arg0_40.typeIndex
	arg0_40.contextData.indexDatas.campIndex = arg0_40.campIndex
	arg0_40.contextData.indexDatas.rarityIndex = arg0_40.rarityIndex
	arg0_40.contextData.indexDatas.extraIndex = arg0_40.extraIndex
end

function var0_0.initIndexPanel(arg0_41)
	onButton(arg0_41, arg0_41.indexBtn, function()
		local var0_42 = {
			indexDatas = Clone(arg0_41.contextData.indexDatas),
			customPanels = {
				minHeight = 650,
				sortIndex = {
					isSort = true,
					mode = CustomIndexLayer.Mode.OR,
					options = ShipIndexConst.SortIndexs,
					names = ShipIndexConst.SortNames
				},
				sortPropertyIndex = {
					blueSeleted = true,
					mode = CustomIndexLayer.Mode.OR,
					options = ShipIndexConst.SortPropertyIndexs,
					names = ShipIndexConst.SortPropertyNames
				},
				typeIndex = {
					blueSeleted = true,
					mode = CustomIndexLayer.Mode.AND,
					options = ShipIndexConst.TypeIndexs,
					names = ShipIndexConst.TypeNames
				},
				campIndex = {
					blueSeleted = true,
					mode = CustomIndexLayer.Mode.AND,
					options = ShipIndexConst.CampIndexs,
					names = ShipIndexConst.CampNames
				},
				rarityIndex = {
					blueSeleted = true,
					mode = CustomIndexLayer.Mode.AND,
					options = ShipIndexConst.RarityIndexs,
					names = ShipIndexConst.RarityNames
				},
				extraIndex = {
					blueSeleted = true,
					mode = CustomIndexLayer.Mode.OR,
					options = ShipIndexConst.ExtraIndexs,
					names = ShipIndexConst.ExtraNames
				},
				layoutPos = Vector2(0, -25)
			},
			groupList = {
				{
					dropdown = false,
					titleTxt = "indexsort_sort",
					titleENTxt = "indexsort_sorteng",
					tags = {
						"sortIndex"
					},
					simpleDropdown = {
						"sortPropertyIndex"
					}
				},
				{
					dropdown = false,
					titleTxt = "indexsort_index",
					titleENTxt = "indexsort_indexeng",
					tags = {
						"typeIndex"
					}
				},
				{
					dropdown = false,
					titleTxt = "indexsort_camp",
					titleENTxt = "indexsort_campeng",
					tags = {
						"campIndex"
					}
				},
				{
					dropdown = false,
					titleTxt = "indexsort_rarity",
					titleENTxt = "indexsort_rarityeng",
					tags = {
						"rarityIndex"
					}
				},
				{
					dropdown = false,
					titleTxt = "indexsort_extraindex",
					titleENTxt = "indexsort_indexeng",
					tags = {
						"extraIndex"
					}
				}
			},
			callback = function(arg0_43)
				arg0_41.sortIndex = arg0_43.sortIndex
				arg0_41.typeIndex = arg0_43.typeIndex
				arg0_41.campIndex = arg0_43.campIndex
				arg0_41.rarityIndex = arg0_43.rarityIndex
				arg0_41.extraIndex = arg0_43.extraIndex

				arg0_41:updateIndexDatas()
				arg0_41:filter()
			end
		}

		arg0_41:emit(DockyardMediator.OPEN_DOCKYARD_INDEX, var0_42)
	end, SFX_PANEL)
	onToggle(arg0_41, arg0_41.preferenceBtn, function(arg0_44)
		if arg0_44 then
			arg0_41.commonTag = Ship.PREFERENCE_TAG_COMMON
		else
			arg0_41.commonTag = Ship.PREFERENCE_TAG_NONE
		end

		arg0_41:filter()
	end)
end

function var0_0.setShips(arg0_45, arg1_45)
	arg0_45.shipVOsById = arg1_45
end

function var0_0.setPlayer(arg0_46, arg1_46)
	arg0_46.player = arg1_46

	arg0_46:updateBarInfo()
end

function var0_0.setFriends(arg0_47, arg1_47)
	arg0_47.friends = {}

	for iter0_47, iter1_47 in pairs(arg1_47) do
		arg0_47.friends[iter1_47.id] = iter1_47
	end
end

function var0_0.updateBarInfo(arg0_48)
	setActive(arg0_48.bottomTipsText, arg0_48.contextData.leftTopInfo)
	setText(arg0_48.bottomTipsText, arg0_48.contextData.leftTopInfo and i18n("dock_yard_left_tips", arg0_48.contextData.leftTopInfo) or "")
	setActive(arg0_48.bottomTipsWithFrame, arg0_48.contextData.leftTopWithFrameInfo)
	setText(arg0_48.bottomTipsWithFrame:Find("Text"), arg0_48.contextData.leftTopWithFrameInfo or "")

	if arg0_48.contextData.mode == var0_0.MODE_WORLD or arg0_48.contextData.mode == var0_0.MODE_GUILD_BOSS or arg0_48.contextData.mode == var0_0.MODE_REMOULD then
		setActive(arg0_48.leftTipsText, false)
	else
		setActive(arg0_48.leftTipsText, true)
		arg0_48:updateCapacityDisplay()
	end
end

function var0_0.updateCapacityDisplay(arg0_49)
	setActive(arg0_49.leftTipsText:Find("plus"), not arg0_49.isCapacityMeta)
	setActive(arg0_49.leftTipsText:Find("tip"), arg0_49.isCapacityMeta)
	setActive(arg0_49.leftTipsText:Find("switch/off"), not arg0_49.isCapacityMeta)
	setActive(arg0_49.leftTipsText:Find("switch/on"), arg0_49.isCapacityMeta)

	if arg0_49.isCapacityMeta then
		setText(arg0_49.leftTipsText:Find("label"), i18n("specialshipyard_name"))
		setText(arg0_49.leftTipsText:Find("Text"), arg0_49.specialShipCount)
	else
		setText(arg0_49.leftTipsText:Find("label"), i18n("ship_dockyardScene_capacity"))
		setText(arg0_49.leftTipsText:Find("Text"), arg0_49.shipsCount .. "/" .. arg0_49.player:getMaxShipBag())
	end
end

function var0_0.initWorldPanel(arg0_50)
	onButton(arg0_50, arg0_50.worldPanel:Find("btn_repair"), function()
		if #arg0_50.selectedIds > 0 then
			arg0_50:repairWorldShip(arg0_50.shipVOsById[arg0_50.selectedIds[1]])
		end
	end, SFX_PANEL)
	onButton(arg0_50, arg0_50.worldPanel:Find("btn_repair_all"), function()
		local var0_52 = {}
		local var1_52 = 0

		for iter0_52, iter1_52 in pairs(arg0_50.shipVOsById) do
			local var2_52 = WorldConst.FetchWorldShip(iter1_52.id)

			if var2_52:IsBroken() or not var2_52:IsHpFull() then
				table.insert(var0_52, var2_52.id)

				var1_52 = var1_52 + nowWorld():CalcRepairCost(var2_52)
			end
		end

		if #var0_52 == 0 then
			pg.TipsMgr.GetInstance():ShowTips(i18n("world_ship_repair_no_need"))
		else
			pg.MsgboxMgr.GetInstance():ShowMsgBox({
				content = i18n("world_ship_repair_all", var1_52),
				onYes = function()
					arg0_50:emit(DockyardMediator.ON_SHIP_REPAIR, var0_52, var1_52)
				end
			})
		end
	end, SFX_PANEL)
end

function var0_0.repairWorldShip(arg0_54, arg1_54)
	local var0_54 = WorldConst.FetchWorldShip(arg1_54.id)
	local var1_54 = nowWorld():CalcRepairCost(var0_54)

	if var0_54:IsBroken() then
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			content = i18n("world_ship_repair_2", arg1_54:getName(), var1_54),
			onYes = function()
				arg0_54:emit(DockyardMediator.ON_SHIP_REPAIR, {
					var0_54.id
				}, var1_54)
			end
		})
	elseif not var0_54:IsHpFull() then
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			content = i18n("world_ship_repair_1", arg1_54:getName(), var1_54),
			onYes = function()
				arg0_54:emit(DockyardMediator.ON_SHIP_REPAIR, {
					var0_54.id
				}, var1_54)
			end
		})
	else
		pg.TipsMgr.GetInstance():ShowTips(i18n("world_ship_repair_no_need"))
	end
end

function var0_0.filter(arg0_57)
	local var0_57 = arg0_57:isDefaultStatus() and "shaixuan_off" or "shaixuan_on"

	LoadImageSpriteAtlasAsync("ui/dockyardui_atlas", var0_57, arg0_57.indexBtn, true)

	if arg0_57.isRemouldOrUpgradeMode then
		arg0_57:filterForRemouldAndUpgrade()
	else
		arg0_57:filterCommon()
	end

	local var1_57 = 0

	if arg0_57.contextData.quitTeam then
		var1_57 = var1_57 + 1

		table.insert(arg0_57.shipVOs, var1_57, false)
	end

	if arg0_57.contextData.priorEquipUpShipIDList then
		local var2_57 = {}

		for iter0_57, iter1_57 in ipairs(arg0_57.contextData.priorEquipUpShipIDList) do
			var2_57[iter1_57] = true
		end

		for iter2_57 = #arg0_57.shipVOs, 1, -1 do
			local var3_57 = type(arg0_57.shipVOs[iter2_57]) == "table" and arg0_57.shipVOs[iter2_57].id

			if var2_57[var3_57] then
				var2_57[var3_57] = table.remove(arg0_57.shipVOs, iter2_57)
			end
		end

		for iter3_57, iter4_57 in ipairs(arg0_57.contextData.priorEquipUpShipIDList) do
			local var4_57 = var2_57[iter4_57]

			if type(var4_57) == "table" then
				var1_57 = var1_57 + 1

				table.insert(arg0_57.shipVOs, var1_57, var4_57)
			end
		end
	end

	if var0_0.MODE_OVERVIEW == arg0_57.contextData.mode and DockyardScene.value then
		arg0_57:updateShipCount(DockyardScene.value or 0)

		DockyardScene.value = nil
	else
		arg0_57:updateShipCount(0)
	end
end

function var0_0.filterForRemouldAndUpgrade(arg0_58)
	arg0_58.shipVOs = {}

	local var0_58 = arg0_58.isFilterLockForMod
	local var1_58 = arg0_58.isFilterLevelForMod

	local function var2_58(arg0_59)
		local var0_59 = true

		if not var0_58 and arg0_59.lockState == Ship.LOCK_STATE_LOCK then
			var0_59 = false
		end

		if not var1_58 and arg0_59.level > 1 then
			var0_59 = false
		end

		return var0_59
	end

	for iter0_58, iter1_58 in pairs(arg0_58.shipVOsById) do
		if var2_58(iter1_58) then
			table.insert(arg0_58.shipVOs, iter1_58)
		end
	end

	table.sort(arg0_58.shipVOs, CompareFuncs({
		function(arg0_60)
			return arg0_60.level
		end,
		function(arg0_61)
			return arg0_61:isTestShip() and 1 or 0
		end
	}))
end

function var0_0.filterCommon(arg0_62)
	arg0_62.shipVOs = {}

	local var0_62 = arg0_62.sortIndex

	local function var1_62(arg0_63)
		if arg0_62.contextData.mode ~= var0_0.MODE_GUILD_BOSS then
			return true
		end

		if arg0_62.isShowAssultShips then
			return true
		end

		if not arg0_63.user then
			return true
		end

		if arg0_63.user.id == arg0_62.player.id then
			return true
		end

		return false
	end

	for iter0_62, iter1_62 in pairs(arg0_62.shipVOsById) do
		if arg0_62.contextData.blockLock and iter1_62:GetLockState() == Ship.LOCK_STATE_LOCK then
			-- block empty
		elseif arg0_62.teamTypeFilter and iter1_62:getTeamType() ~= arg0_62.teamTypeFilter then
			-- block empty
		elseif ShipIndexConst.filterByType(iter1_62, arg0_62.typeIndex) and ShipIndexConst.filterByCamp(iter1_62, arg0_62.campIndex) and ShipIndexConst.filterByRarity(iter1_62, arg0_62.rarityIndex) and ShipIndexConst.filterByExtra(iter1_62, arg0_62.extraIndex) and (arg0_62.commonTag == Ship.PREFERENCE_TAG_NONE or arg0_62.commonTag == iter1_62:GetPreferenceTag()) and var1_62(iter1_62) then
			table.insert(arg0_62.shipVOs, iter1_62)
		end
	end

	local var2_62 = getInputText(arg0_62.nameSearchInput)

	if var2_62 and var2_62 ~= "" then
		arg0_62.shipVOs = underscore.filter(arg0_62.shipVOs, function(arg0_64)
			return arg0_64:IsMatchKey(var2_62)
		end)
	end

	local var3_62, var4_62 = ShipIndexConst.getSortFuncAndName(var0_62, arg0_62.selectAsc)

	if (var0_62 ~= ShipIndexConst.SortIntimacy and true or false) and not defaultValue((arg0_62.contextData.hideTagFlags or {}).inFleet, ShipStatus.TAG_HIDE_BASE.inFleet) then
		table.insert(var3_62, 1, function(arg0_65)
			return arg0_65:getFlag("inFleet") and 0 or 1
		end)
	end

	if var3_62 then
		arg0_62:SortShips(var3_62)
	end

	arg0_62:updateSelected()
	setActive(arg0_62.sortImgAsc, arg0_62.selectAsc)
	setActive(arg0_62.sortImgDesc, not arg0_62.selectAsc)
	setText(arg0_62:findTF("Image", arg0_62.sortBtn), i18n(var4_62))
end

function var0_0.SortShips(arg0_66, arg1_66)
	if pg.NewGuideMgr.GetInstance():IsBusy() then
		local var0_66 = {
			101171,
			201211,
			401231,
			301051
		}

		arg1_66 = {
			function(arg0_67)
				return table.contains(var0_66, arg0_67.configId) and 0 or 1
			end
		}
	elseif arg0_66.isFormTactics then
		table.insert(arg1_66, 1, function(arg0_68)
			return arg0_68:getNation() == Nation.META and 1 or 0
		end)
		table.insert(arg1_66, 1, function(arg0_69)
			return arg0_69:isFullSkillLevel() and 1 or 0
		end)
	elseif arg0_66.contextData.mode == var0_0.MODE_OVERVIEW or arg0_66.contextData.mode == var0_0.MODE_SELECT then
		table.insert(arg1_66, 1, function(arg0_70)
			return -arg0_70.activityNpc
		end)
	elseif arg0_66.contextData.mode == var0_0.MODE_GUILD_BOSS then
		table.insert(arg1_66, 1, function(arg0_71)
			return arg0_71.guildRecommand and 0 or 1
		end)
	end

	table.sort(arg0_66.shipVOs, CompareFuncs(arg1_66))
end

function var0_0.UpdateGuildViewEquipmentsBtn(arg0_72)
	setActive(arg0_72.viewEquipmentBtn, arg0_72.contextData.mode == var0_0.MODE_GUILD_BOSS and #arg0_72.selectedIds > 0)
end

function var0_0.didEnter(arg0_73)
	pg.UIMgr.GetInstance():OverlayPanel(arg0_73.blurPanel)
	setActive(arg0_73.stampBtn, getProxy(TaskProxy):mingshiTouchFlagEnabled() and arg0_73.contextData.mode ~= var0_0.MODE_GUILD_BOSS)
	arg0_73:UpdateGuildViewEquipmentsBtn()
	onButton(arg0_73, arg0_73.stampBtn, function()
		getProxy(TaskProxy):dealMingshiTouchFlag(1)
	end, SFX_CONFIRM)
	onButton(arg0_73, arg0_73:findTF("back", arg0_73.topPanel), function()
		arg0_73:back()
	end, SFX_CANCEL)
	onButton(arg0_73, arg0_73.sortBtn, function()
		arg0_73.selectAsc = not arg0_73.selectAsc

		arg0_73:filter()
	end, SFX_UI_CLICK)

	if arg0_73.contextData.mode == var0_0.MODE_GUILD_BOSS then
		arg0_73.isShowAssultShips = false

		onToggle(arg0_73, arg0_73.assultBtn, function(arg0_77)
			arg0_73.isShowAssultShips = arg0_77

			arg0_73:filter()
		end, SFX_PANEL)
		triggerToggle(arg0_73.assultBtn, true)

		arg0_73.guildShipEquipmentsPage = GuildShipEquipmentsPage.New(arg0_73._tf, arg0_73.event)

		arg0_73.guildShipEquipmentsPage:SetCallBack(function()
			arg0_73:TriggerCard(-1)
		end, function()
			arg0_73:TriggerCard(1)
		end)
		onButton(arg0_73, arg0_73.viewEquipmentBtn, function()
			local var0_80 = arg0_73.selectedIds[#arg0_73.selectedIds]

			if not var0_80 then
				return
			end

			local var1_80 = arg0_73.shipVOsById[var0_80]
			local var2_80 = var1_80.user

			arg0_73.guildShipEquipmentsPage:ExecuteAction("Show", var1_80, var2_80)
		end, SFX_PANEL)
	end

	local var0_73 = arg0_73.attrBtn:GetComponent("Button")

	eachChild(var0_73, function(arg0_81)
		setActive(arg0_81, false)
	end)

	arg0_73.isFormTactics = arg0_73.contextData.prevPage == "NewNavalTacticsMediator"

	local var1_73 = arg0_73:findTF("off", var0_73):GetComponent("Image")
	local var2_73 = arg0_73:findTF("on", var0_73):GetComponent("Image")

	if arg0_73.isFormTactics then
		GetImageSpriteFromAtlasAsync("ui/dockyardui_atlas", "skill_off", var1_73)
		GetImageSpriteFromAtlasAsync("ui/dockyardui_atlas", "skill_on", var2_73)
	else
		GetImageSpriteFromAtlasAsync("ui/dockyardui_atlas", "attr_off", var1_73)
		GetImageSpriteFromAtlasAsync("ui/dockyardui_atlas", "attr_on", var2_73)
	end

	if arg0_73.isRemouldOrUpgradeMode then
		local var3_73 = getProxy(SettingsProxy)

		arg0_73.isFilterLevelForMod = var3_73:GetDockYardLevelBtnFlag()

		arg0_73:OnSwitch(arg0_73.modLeveFilter, arg0_73.isFilterLevelForMod, function(arg0_82)
			arg0_73.isFilterLevelForMod = arg0_82

			arg0_73:filter()
		end)

		arg0_73.isFilterLockForMod = var3_73:GetDockYardLockBtnFlag()

		arg0_73:OnSwitch(arg0_73.modLockFilter, arg0_73.isFilterLockForMod, function(arg0_83)
			arg0_73.isFilterLockForMod = arg0_83

			arg0_73:filter()
		end)
	end

	onButton(arg0_73, var0_73, function()
		if not arg0_73.isFormTactics then
			arg0_73.itemDetailType = (arg0_73.itemDetailType + 1) % 4
		else
			arg0_73.itemDetailType = arg0_73.itemDetailType == DockyardShipItem.DetailType0 and DockyardShipItem.DetailType3 or DockyardShipItem.DetailType0
		end

		setActive(var2_73, arg0_73.itemDetailType ~= DockyardShipItem.DetailType0)
		setActive(var1_73, arg0_73.itemDetailType == DockyardShipItem.DetailType0)

		var0_73.targetGraphic = arg0_73.itemDetailType == DockyardShipItem.DetailType0 and var1_73 or var2_73

		arg0_73:updateItemDetailType()
	end, SFX_PANEL)
	triggerButton(var0_73)
	onButton(arg0_73, arg0_73.selectPanel:Find("cancel_button"), function()
		if arg0_73.animating then
			return
		end

		if arg0_73.contextData.mode == var0_0.MODE_DESTROY then
			if #arg0_73.selectedIds > 0 then
				arg0_73:unselecteAllShips()
				arg0_73:back()
			else
				arg0_73:back()
			end
		else
			arg0_73:back()

			return
		end
	end, SFX_CANCEL)
	onButton(arg0_73, arg0_73.selectPanel:Find("confirm_button"), function()
		if arg0_73.animating then
			return
		end

		if arg0_73.contextData.mode == var0_0.MODE_DESTROY then
			local var0_86, var1_86 = arg0_73:checkDestroyGold()

			if not var0_86 or not var1_86 then
				if not var0_86 then
					pg.TipsMgr.GetInstance():ShowTips(i18n("gold_max_tip_title") .. i18n("resource_max_tip_retire"))
				elseif not var0_86 then
					pg.TipsMgr.GetInstance():ShowTips(i18n("oil_max_tip_title") .. i18n("resource_max_tip_retire"))
				end

				return
			end
		end

		if #arg0_73.selectedIds < arg0_73.selectedMin then
			if arg0_73.leastLimitMsg then
				pg.TipsMgr.GetInstance():ShowTips(arg0_73.leastLimitMsg)
			else
				pg.TipsMgr.GetInstance():ShowTips(i18n("ship_dockyardScene_error_choiseRoleMore", arg0_73.selectedMin))
			end

			return
		end

		if arg0_73.contextData.mode == var0_0.MODE_DESTROY then
			arg0_73:displayDestroyPanel()
		else
			local var2_86 = {}

			if arg0_73.contextData.destroyCheck then
				local var3_86 = underscore.map(arg0_73.selectedIds, function(arg0_87)
					return arg0_73.shipVOsById[arg0_87]
				end)

				table.insert(var2_86, function(arg0_88)
					arg0_73:checkDestroyShips(var3_86, arg0_88)
				end)
			end

			seriesAsync(var2_86, function()
				if arg0_73.confirmSelect then
					arg0_73.confirmSelect(arg0_73.selectedIds, function()
						arg0_73.onSelected(arg0_73.selectedIds)
						arg0_73:back()
					end, function()
						arg0_73:back()
					end)
				elseif arg0_73.callbackQuit then
					arg0_73.onSelected(arg0_73.selectedIds, function()
						arg0_73:back()
					end)
				else
					arg0_73.onSelected(arg0_73.selectedIds)
					arg0_73:back()
				end
			end)
		end
	end, SFX_CONFIRM)
	onButton(arg0_73, arg0_73.selectPanel:Find("quick_select"), function()
		if arg0_73.animating then
			return
		end

		local var0_93 = {
			PlayerPrefs.GetInt("QuickSelectRarity1", 3),
			PlayerPrefs.GetInt("QuickSelectRarity2", 4),
			PlayerPrefs.GetInt("QuickSelectRarity3", 2)
		}
		local var1_93 = 3
		local var2_93 = {}

		for iter0_93, iter1_93 in pairs(var0_93) do
			if iter1_93 ~= 0 then
				var2_93[iter1_93] = var2_93[iter1_93] or var1_93
				var1_93 = var1_93 - 1
			end
		end

		local var3_93 = getProxy(BayProxy):getShips()
		local var4_93 = {}
		local var5_93 = {}

		for iter2_93, iter3_93 in pairs(var3_93) do
			if iter3_93:isMaxStar() then
				var4_93[iter3_93:getGroupId()] = true
			else
				local var6_93 = iter3_93:getMaxStar() - iter3_93:getStar() + 1

				if iter3_93:GetLockState() == Ship.LOCK_STATE_UNLOCK then
					var6_93 = var6_93 + 1
				end

				local var7_93 = var5_93[iter3_93:getGroupId()]

				var5_93[iter3_93:getGroupId()] = var7_93 and var7_93 < var6_93 and var7_93 or var6_93
			end
		end

		local var8_93 = _.select(arg0_73.shipVOs, function(arg0_94)
			return arg0_94.configId ~= 100001 and arg0_94.configId ~= 100011 and arg0_94:GetLockState() == Ship.LOCK_STATE_UNLOCK and table.contains(var0_93, arg0_94:getRarity()) and arg0_94.level == 1 and not arg0_73.blacklist[arg0_94:getGroupId()] and not table.contains(arg0_73.selectedIds, arg0_94.id) and not arg0_94:hasAnyFlag({
				"inFleet",
				"inChapter",
				"inWorld",
				"inEvent",
				"inBackyard",
				"inClass",
				"inTactics",
				"inExercise",
				"inAdmiral",
				"inElite",
				"inActivity",
				"inGuildEvent",
				"inGuildBossEvent"
			})
		end)

		if not _.all(var8_93, function(arg0_95)
			return arg0_73.blacklist[arg0_95:getGroupId()]
		end) then
			var8_93 = _.select(var8_93, function(arg0_96)
				return not arg0_73.blacklist[arg0_96:getGroupId()]
			end)
		elseif #arg0_73.selectedIds > 0 then
			var8_93 = {}
		end

		table.sort(var8_93, function(arg0_97, arg1_97)
			local var0_97 = var2_93[arg0_97:getRarity()] or 0
			local var1_97 = var2_93[arg1_97:getRarity()] or 0

			if var0_97 == var1_97 then
				if arg0_97:getGroupId() == arg1_97:getGroupId() then
					return arg0_97.createTime > arg1_97.createTime
				end

				return arg0_97.configId > arg1_97.configId
			else
				return var1_97 < var0_97
			end
		end)

		local var9_93 = PlayerPrefs.GetString("QuickSelectWhenHasAtLeastOneMaxstar", "KeepNone")
		local var10_93 = PlayerPrefs.GetString("QuickSelectWithoutMaxstar", "KeepAll")
		local var11_93 = {}
		local var12_93 = _.select(var8_93, function(arg0_98)
			if var4_93[arg0_98:getGroupId()] then
				if var9_93 == "KeepNone" then
					return true
				elseif var9_93 == "KeepOne" then
					if not var11_93[arg0_98:getGroupId()] then
						var11_93[arg0_98:getGroupId()] = true

						return false
					end

					return true
				elseif var9_93 == "KeepAll" then
					return false
				end
			elseif var10_93 == "KeepNone" then
				return true
			elseif var10_93 == "KeepNeeded" then
				if var5_93[arg0_98:getGroupId()] > 0 then
					var5_93[arg0_98:getGroupId()] = var5_93[arg0_98:getGroupId()] - 1

					return false
				end

				return true
			elseif var10_93 == "KeepAll" then
				return false
			end
		end)
		local var13_93 = 0
		local var14_93 = false
		local var15_93 = false
		local var16_93 = 0
		local var17_93 = 0

		for iter4_93, iter5_93 in ipairs(arg0_73.selectedIds) do
			local var18_93, var19_93 = arg0_73.shipVOsById[iter5_93]:calReturnRes()

			var16_93 = var16_93 + var18_93
			var17_93 = var17_93 + var19_93
		end

		for iter6_93, iter7_93 in ipairs(var12_93) do
			if arg0_73.selectedMax > 0 and arg0_73.selectedMax <= #arg0_73.selectedIds then
				break
			end

			local var20_93, var21_93 = iter7_93:calReturnRes()

			var16_93 = var16_93 + var20_93
			var17_93 = var17_93 + var21_93
			var14_93 = arg0_73.player:OilMax(var17_93)
			var15_93 = arg0_73.player:GoldMax(var16_93)

			if var15_93 then
				break
			end

			var13_93 = var13_93 + 1

			arg0_73:selectShip(iter7_93, true)
		end

		if var13_93 == 0 then
			if var15_93 then
				if #arg0_73.selectedIds == 0 then
					pg.TipsMgr.GetInstance():ShowTips(i18n("gold_max_tip_title") .. i18n("resource_max_tip_retire"))
				else
					pg.TipsMgr.GetInstance():ShowTips(i18n("gold_max_tip_title"))
				end
			elseif #arg0_73.selectedIds > 0 then
				arg0_73:displayDestroyPanel()
			else
				pg.TipsMgr.GetInstance():ShowTips(i18n("retire_selectzero"))
			end
		elseif var14_93 then
			pg.MsgboxMgr.GetInstance():ShowMsgBox({
				content = i18n("oil_max_tip_title") .. i18n("resource_max_tip_retire_1"),
				onYes = function()
					arg0_73:displayDestroyPanel()
				end
			})
		else
			arg0_73:displayDestroyPanel()
		end
	end, SFX_CONFIRM)

	if not arg0_73.contextData.selectFriend then
		arg0_73.shipContainer:GetComponentInChildren(typeof(GridLayoutGroup)).constraintCount = 7
	end

	arg0_73:filter()
	arg0_73:updateBarInfo()

	if arg0_73.contextData.mode == var0_0.MODE_WORLD then
		arg0_73:initWorldPanel()
	elseif arg0_73.contextData.mode == var0_0.MODE_DESTROY and not LOCK_DESTROY_GUIDE then
		pg.SystemGuideMgr.GetInstance():Play(arg0_73)
	end

	setAnchoredPosition(arg0_73.topPanel, {
		y = arg0_73.topPanel.rect.height
	})
	setAnchoredPosition(arg0_73.selectPanel, {
		y = -1 * arg0_73.selectPanel.rect.height
	})
	onNextTick(function()
		if arg0_73.exited then
			return
		end

		arg0_73:uiStartAnimating()
	end)

	if arg0_73.contextData.selectShipId then
		arg0_73.selectedIds = {}

		table.insert(arg0_73.selectedIds, arg0_73.contextData.selectShipId)
		arg0_73:updateSelected()
	end

	arg0_73.bulinTip = AprilFoolBulinSubView.ShowAprilFoolBulin(arg0_73)

	onButton(arg0_73, arg0_73.settingBtn, function()
		arg0_73.settingPanel:Load()
		arg0_73.settingPanel:ActionInvoke("Show")
	end)
	pg.SystemGuideMgr.GetInstance():Play(arg0_73)
end

function var0_0.TriggerCard(arg0_102, arg1_102)
	local var0_102 = arg0_102.selectedIds[1]

	if not var0_102 then
		return
	end

	local var1_102

	for iter0_102, iter1_102 in ipairs(arg0_102.shipVOs) do
		if iter1_102 and iter1_102.id == var0_102 then
			var1_102 = iter0_102

			break
		end
	end

	if not var1_102 then
		return
	end

	local var2_102 = var1_102
	local var3_102

	local function var4_102()
		var2_102 = var2_102 + arg1_102

		local var0_103 = arg0_102.shipVOs[var2_102]

		if not var0_103 or arg0_102.checkShip(var0_103) then
			return var0_103
		else
			return var4_102()
		end
	end

	local var5_102 = var4_102()

	if not var5_102 then
		return
	end

	local function var6_102()
		local var0_104

		for iter0_104, iter1_104 in pairs(arg0_102.scrollItems) do
			if iter1_104.shipVO and iter1_104.go.name ~= "-1" and iter1_104.shipVO.id == var5_102.id then
				var0_104 = iter1_104

				break
			end
		end

		return var0_104
	end

	local var7_102 = var6_102()

	if var7_102 then
		local var8_102 = getBounds(arg0_102:findTF("main/ship_container"))
		local var9_102 = getBounds(var7_102.tr)

		if not var8_102:Intersects(var9_102) then
			local var10_102 = arg1_102 * (arg0_102.shipContainer:HeadIndexToValue(7) - arg0_102.shipContainer:HeadIndexToValue(1))
			local var11_102 = arg0_102.shipContainer.value + var10_102

			arg0_102.shipContainer:SetNormalizedPosition(var11_102, 1)
		end
	end

	if not var7_102 then
		local var12_102 = (math.ceil(var2_102 / 7) - math.ceil(var1_102 / 7)) * (arg0_102.shipContainer:HeadIndexToValue(21) - arg0_102.shipContainer:HeadIndexToValue(1))
		local var13_102 = arg0_102.shipContainer.value + var12_102

		arg0_102.shipContainer:SetNormalizedPosition(var13_102, 1)

		var7_102 = var6_102()
	end

	if var7_102 then
		triggerButton(var7_102.tr)

		local var14_102 = arg0_102.shipVOsById[var7_102.shipVO.id]

		arg0_102.guildShipEquipmentsPage:Refresh(var14_102, var14_102.user)
	end
end

function var0_0.OnSwitch(arg0_105, arg1_105, arg2_105, arg3_105)
	local function var0_105()
		setActive(arg1_105:Find("off"), not arg2_105)
		setActive(arg1_105:Find("on"), arg2_105)
	end

	onButton(arg0_105, arg1_105, function()
		arg2_105 = not arg2_105

		if arg3_105 then
			arg3_105(arg2_105)
		end

		var0_105()
	end, SFX_PANEL)
	var0_105()
end

function var0_0.onBackPressed(arg0_108)
	if arg0_108.destroyConfirmWindow:isShowing() then
		arg0_108.destroyConfirmWindow:Hide()

		return
	end

	if arg0_108.destroyPage:isShowing() then
		arg0_108.destroyPage:Hide()

		return
	end

	if arg0_108.settingPanel:isShowing() then
		arg0_108.settingPanel:Hide()

		return
	end

	pg.CriMgr.GetInstance():PlaySoundEffect_V3(SFX_CANCEL)
	arg0_108:back()
end

function var0_0.updateShipStatusById(arg0_109, arg1_109)
	for iter0_109, iter1_109 in pairs(arg0_109.scrollItems) do
		if iter1_109.shipVO and iter1_109.shipVO.id == arg1_109 then
			iter1_109:flush(arg0_109.selectedIds)

			if arg0_109.contextData.mode == DockyardScene.MODE_WORLD then
				iter1_109:updateWorld()
			end
		end
	end
end

function var0_0.checkDestroyGold(arg0_110, arg1_110)
	local var0_110 = 0
	local var1_110 = 0

	for iter0_110, iter1_110 in ipairs(arg0_110.selectedIds) do
		local var2_110, var3_110 = arg0_110.shipVOsById[iter1_110]:calReturnRes()

		var0_110 = var0_110 + var2_110
		var1_110 = var1_110 + var3_110
	end

	if arg1_110 then
		local var4_110, var5_110 = arg1_110:calReturnRes()

		var0_110 = var0_110 + var4_110
		var1_110 = var1_110 + var5_110
	end

	local var6_110 = arg0_110.player:OilMax(var1_110)

	if arg0_110.player:GoldMax(var0_110) then
		return false, not var6_110
	end

	return true, not var6_110
end

function var0_0.selectShip(arg0_111, arg1_111, arg2_111)
	local var0_111 = false
	local var1_111

	for iter0_111, iter1_111 in ipairs(arg0_111.selectedIds) do
		if iter1_111 == arg1_111.id then
			var0_111 = true
			var1_111 = iter0_111

			break
		end
	end

	if not var0_111 then
		local var2_111, var3_111 = arg0_111.checkShip(arg1_111, function()
			if not arg0_111.exited then
				arg0_111:selectShip(arg1_111)
			end
		end, arg0_111.selectedMax == 1 and {} or arg0_111.selectedIds)

		if not var2_111 then
			if var3_111 then
				pg.TipsMgr.GetInstance():ShowTips(var3_111)
			end

			return
		end

		if arg0_111.selectedMax == 1 then
			local var4_111 = arg0_111.selectedIds[1]

			arg0_111.selectedIds[1] = arg1_111.id
		elseif arg0_111.selectedMax == 0 or #arg0_111.selectedIds < arg0_111.selectedMax then
			table.insert(arg0_111.selectedIds, arg1_111.id)
			arg0_111:updateBlackBlocks(arg1_111)
		else
			pg.TipsMgr.GetInstance():ShowTips(i18n("ship_dockyardScene_error_choiseRoleLess", arg0_111.selectedMax))

			return
		end
	else
		local var5_111, var6_111 = arg0_111.onCancelShip(arg1_111, function()
			if not arg0_111.exited then
				arg0_111:selectShip(arg1_111)
			end
		end, arg0_111.selectedIds)

		if not var5_111 then
			if var6_111 then
				pg.TipsMgr.GetInstance():ShowTips(var6_111)
			end

			return
		end

		table.remove(arg0_111.selectedIds, var1_111)

		if arg0_111.selectedMax ~= 1 then
			arg0_111:updateBlackBlocks(arg1_111)
		end
	end

	arg0_111:updateSelected()

	if arg0_111.contextData.mode == var0_0.MODE_DESTROY then
		arg0_111:updateDestroyRes()
	elseif arg0_111.contextData.mode == var0_0.MODE_MOD then
		arg0_111:updateModAttr()
	end

	arg0_111:UpdateGuildViewEquipmentsBtn()
end

function var0_0.updateBlackBlocks(arg0_114, arg1_114)
	if not arg0_114.contextData.useBlackBlock or not arg1_114 then
		return
	end

	for iter0_114, iter1_114 in pairs(arg0_114.scrollItems) do
		arg0_114:updateItemBlackBlock(iter1_114)
	end
end

function var0_0.updateItemBlackBlock(arg0_115, arg1_115)
	if arg0_115.contextData.useBlackBlock then
		if arg0_115.selectedMax == 1 then
			arg1_115:updateBlackBlock(arg0_115.contextData.otherSelectedIds)
		else
			arg1_115:updateBlackBlock(arg0_115.selectedIds)
		end
	else
		arg1_115:updateBlackBlock()
	end
end

function var0_0.unselecteAllShips(arg0_116)
	arg0_116.selectedIds = {}

	arg0_116:updateSelected()
	arg0_116:updateDestroyRes()
end

function var0_0.updateSelected(arg0_117)
	for iter0_117, iter1_117 in pairs(arg0_117.scrollItems) do
		if iter1_117.shipVO then
			local var0_117 = false

			for iter2_117, iter3_117 in ipairs(arg0_117.selectedIds) do
				if iter1_117.shipVO.id == iter3_117 then
					var0_117 = true

					break
				end
			end

			iter1_117:updateSelected(var0_117)
		end
	end

	if arg0_117.selectedMax == 0 then
		setText(arg0_117.selectPanel:Find("bottom_info/bg_input/count"), #arg0_117.selectedIds)
	else
		local var1_117 = #arg0_117.selectedIds

		if arg0_117.contextData.mode ~= var0_0.MODE_DESTROY or #arg0_117.selectedIds == 0 then
			var1_117 = setColorStr(#arg0_117.selectedIds, COLOR_WHITE)
		elseif arg0_117.contextData.mode == var0_0.MODE_DESTROY then
			var1_117 = #arg0_117.selectedIds == 10 and setColorStr(#arg0_117.selectedIds, COLOR_RED) or setColorStr(#arg0_117.selectedIds, COLOR_GREEN)
		end

		setText(arg0_117.selectPanel:Find("bottom_info/bg_input/count"), var1_117 .. "/" .. arg0_117.selectedMax)
	end

	if #arg0_117.selectedIds < arg0_117.selectedMin then
		setActive(arg0_117.selectPanel:Find("confirm_button/mask"), true)
	else
		setActive(arg0_117.selectPanel:Find("confirm_button/mask"), false)
	end

	if arg0_117.contextData.mode == var0_0.MODE_MOD then
		arg0_117:updateModAttr()
	end
end

function var0_0.updateItemDetailType(arg0_118)
	for iter0_118, iter1_118 in pairs(arg0_118.scrollItems) do
		iter1_118:updateDetail(arg0_118.itemDetailType)
	end

	arg0_118.shipLayout.anchoredPosition = arg0_118.shipLayout.anchoredPosition + Vector3(0, 0.001, 0)
end

function var0_0.closeDestroyMode(arg0_119)
	setActive(arg0_119.awardTF, false)
	setActive(arg0_119.bottomTipsText, true)
end

function var0_0.updateDestroyRes(arg0_120)
	if table.getCount(arg0_120.selectedIds) == 0 then
		arg0_120:closeDestroyMode()
	else
		setActive(arg0_120.awardTF, true)
		setActive(arg0_120.bottomTipsText, false)
	end

	local var0_120 = _.map(arg0_120.selectedIds, function(arg0_121)
		return arg0_120.shipVOsById[arg0_121]
	end)
	local var1_120, var2_120, var3_120 = ShipCalcHelper.CalcDestoryRes(var0_120)
	local var4_120 = var2_120 == 0

	if arg0_120.destroyResList then
		local var5_120 = (var4_120 and 1 or 2) + #var3_120

		arg0_120.destroyResList:make(function(arg0_122, arg1_122, arg2_122)
			if arg0_122 == UIItemList.EventUpdate then
				local var0_122 = ""
				local var1_122 = 0

				if arg1_122 == 0 then
					var0_122, var1_122 = "Props/gold", var1_120
				elseif arg1_122 == 1 then
					if not var4_120 then
						var0_122, var1_122 = "Props/oil", var2_120
					else
						local var2_122 = var3_120[1]

						var0_122, var1_122 = Item.getConfigData(var2_122.id).icon, var2_122.count
					end
				elseif arg1_122 > 1 then
					local var3_122 = var4_120 and var3_120[arg1_122] or var3_120[arg1_122 - 1]

					var0_122, var1_122 = Item.getConfigData(var3_122.id).icon, var3_122.count
				end

				GetImageSpriteFromAtlasAsync(var0_122, "", arg2_122:Find("icon"))
				setText(arg2_122:Find("Text"), "X" .. var1_122)
			end
		end)
		arg0_120.destroyResList:align(var5_120)
	end

	if arg0_120.destroyPage and arg0_120.destroyPage:GetLoaded() and arg0_120.destroyPage:isShowing() then
		arg0_120.destroyPage:RefreshRes()
	end
end

function var0_0.setModShip(arg0_123, arg1_123)
	arg0_123.modShip = arg1_123
end

function var0_0.updateModAttr(arg0_124)
	if table.getCount(arg0_124.selectedIds) == 0 then
		arg0_124:closeModAttr()
	else
		setActive(arg0_124.modAttrsTF, true)
		setActive(arg0_124.bottomTipsText, false)
	end

	local var0_124 = arg0_124.contextData.ignoredIds[1]
	local var1_124 = {}

	for iter0_124, iter1_124 in ipairs(arg0_124.selectedIds) do
		table.insert(var1_124, arg0_124.shipVOsById[iter1_124])
	end

	local var2_124 = ShipModLayer.getModExpAdditions(arg0_124.modShip, var1_124)

	for iter2_124, iter3_124 in pairs(ShipModAttr.ID_TO_ATTR) do
		if iter2_124 ~= ShipModLayer.IGNORE_ID then
			local var3_124 = arg0_124.modAttrContainer:Find("attr_" .. iter2_124)

			setText(var3_124:Find("value"), var2_124[iter3_124])
			setText(var3_124:Find("name"), ShipModAttr.id2Name(iter2_124))
		end
	end
end

function var0_0.closeModAttr(arg0_125)
	setActive(arg0_125.modAttrsTF, false)
	setActive(arg0_125.bottomTipsText, true)
end

function var0_0.removeShip(arg0_126, arg1_126)
	for iter0_126, iter1_126 in ipairs(arg0_126.selectedIds) do
		if iter1_126 == arg1_126 then
			table.remove(arg0_126.selectedIds, iter0_126)

			break
		end
	end

	for iter2_126 = #arg0_126.shipVOs, 1, -1 do
		if arg0_126.shipVOs[iter2_126].id == arg1_126 then
			table.remove(arg0_126.shipVOs, iter2_126)

			break
		end
	end

	arg0_126.shipVOsById[arg1_126] = nil
end

function var0_0.updateShipCount(arg0_127, arg1_127)
	arg0_127.shipContainer:SetTotalCount(#arg0_127.shipVOs, defaultValue(arg1_127, -1))
	setActive(arg0_127.listEmptyTF, #arg0_127.shipVOs <= 0)
end

function var0_0.ClearShipsBlackBlock(arg0_128)
	if not arg0_128.shipVOsById then
		return
	end

	for iter0_128, iter1_128 in pairs(arg0_128.shipVOsById) do
		iter1_128.blackBlock = false
	end
end

function var0_0.willExit(arg0_129)
	arg0_129:closeDestroyMode()
	arg0_129:closeModAttr()
	arg0_129:ClearShipsBlackBlock()

	if arg0_129.guildShipEquipmentsPage then
		arg0_129.guildShipEquipmentsPage:Destroy()
	end

	if arg0_129.settingPanel then
		arg0_129.settingPanel:Destroy()
	end

	if arg0_129.destroyPage then
		arg0_129.destroyPage:Destroy()
	end

	if arg0_129.destroyConfirmWindow then
		arg0_129.destroyConfirmWindow:Destroy()
	end

	if arg0_129.contextData.mode == var0_0.MODE_MOD then
		-- block empty
	elseif not arg0_129.contextData.sortData then
		if _G[arg0_129.contextData.preView] then
			_G[arg0_129.contextData.preView].sortIndex = arg0_129.sortIndex
			_G[arg0_129.contextData.preView].selectAsc = arg0_129.selectAsc
			_G[arg0_129.contextData.preView].typeIndex = arg0_129.typeIndex
			_G[arg0_129.contextData.preView].campIndex = arg0_129.campIndex
			_G[arg0_129.contextData.preView].rarityIndex = arg0_129.rarityIndex
			_G[arg0_129.contextData.preView].extraIndex = arg0_129.extraIndex
			_G[arg0_129.contextData.preView].commonTag = arg0_129.commonTag
		else
			DockyardScene.sortIndex = arg0_129.sortIndex
			DockyardScene.selectAsc = arg0_129.selectAsc
			DockyardScene.typeIndex = arg0_129.typeIndex
			DockyardScene.campIndex = arg0_129.campIndex
			DockyardScene.rarityIndex = arg0_129.rarityIndex
			DockyardScene.extraIndex = arg0_129.extraIndex
			DockyardScene.commonTag = arg0_129.commonTag
		end
	end

	arg0_129.shipContainer.enabled = false

	for iter0_129, iter1_129 in pairs(arg0_129.scrollItems) do
		iter1_129:clear()
		GetOrAddComponent(iter1_129.go, "UILongPressTrigger").onLongPressed:RemoveAllListeners()
	end

	if LeanTween.isTweening(go(arg0_129.energyDescTF)) then
		setActive(arg0_129.energyDescTF, false)
		LeanTween.cancel(go(arg0_129.energyDescTF))
	end

	arg0_129:cancelAnimating()

	if arg0_129.isRemouldOrUpgradeMode then
		local var0_129 = getProxy(SettingsProxy)

		var0_129:SetDockYardLockBtnFlag(arg0_129.isFilterLockForMod)
		var0_129:SetDockYardLevelBtnFlag(arg0_129.isFilterLevelForMod)
	end

	if arg0_129.bulinTip then
		arg0_129.bulinTip:Destroy()

		arg0_129.bulinTip = nil
	end

	pg.UIMgr.GetInstance():UnOverlayPanel(arg0_129.blurPanel, arg0_129._tf)
end

function var0_0.uiStartAnimating(arg0_130)
	local var0_130 = arg0_130:findTF("back", arg0_130.topPanel)
	local var1_130 = 0
	local var2_130 = 0.3

	if isActive(arg0_130.selectPanel) then
		shiftPanel(arg0_130.selectPanel, nil, 0, var2_130, var1_130, true, true)
	end
end

function var0_0.uiExitAnimating(arg0_131)
	if arg0_131.contextData.mode == var0_0.MODE_OVERVIEW then
		-- block empty
	else
		local var0_131 = 0
		local var1_131 = 0.3

		shiftPanel(arg0_131.selectPanel, nil, -1 * arg0_131.selectPanel.rect.height, var1_131, var0_131, true, true)
	end
end

function var0_0.back(arg0_132)
	if arg0_132.exited then
		return
	end

	arg0_132:closeView()
end

function var0_0.cancelAnimating(arg0_133)
	if LeanTween.isTweening(go(arg0_133.topPanel)) then
		LeanTween.cancel(go(arg0_133.topPanel))
	end

	if LeanTween.isTweening(go(arg0_133.selectPanel)) then
		LeanTween.cancel(go(arg0_133.selectPanel))
	end

	if arg0_133.tweens then
		cancelTweens(arg0_133.tweens)
	end
end

function var0_0.quickExitFunc(arg0_134)
	seriesAsync({
		function(arg0_135)
			if arg0_134.contextData.onQuickHome then
				arg0_134.contextData.onQuickHome(arg0_135)
			else
				arg0_135()
			end
		end,
		function(arg0_136)
			arg0_134:emit(var0_0.ON_HOME)
		end
	})
end

function var0_0.displayDestroyPanel(arg0_137)
	arg0_137.destroyPage:ExecuteAction("Show")
	arg0_137.destroyPage:ActionInvoke("Refresh", arg0_137.selectedIds, arg0_137.shipVOsById)
end

function var0_0.closeDestroyPanel(arg0_138)
	if arg0_138.destroyPage:isShowing() then
		arg0_138.destroyPage:Hide()
	end
end

function var0_0.checkDestroyShips(arg0_139, arg1_139, arg2_139)
	local var0_139 = {}

	if PlayerPrefs.GetInt("RetireProtect", 1) == 0 then
		local var1_139 = {}

		for iter0_139, iter1_139 in pairs(arg1_139) do
			local var2_139 = 0

			for iter2_139, iter3_139 in pairs(arg1_139) do
				if iter3_139:getGroupId() == iter1_139:getGroupId() then
					var2_139 = var2_139 + 1
				end
			end

			if #getProxy(BayProxy):findShipsByGroup(iter1_139:getGroupId()) == var2_139 then
				local var3_139 = false

				for iter4_139, iter5_139 in pairs(var1_139) do
					if iter5_139:getGroupId() == iter1_139:getGroupId() then
						var3_139 = true

						break
					end
				end

				if not var3_139 then
					table.insert(var1_139, iter1_139)
				end
			end
		end

		if #var1_139 > 0 then
			table.insert(var0_139, function(arg0_140)
				arg0_139.destroyConfirmWindow:ExecuteAction("ShowOneShipProtect", var1_139, arg0_140)
			end)
		end
	end

	local var4_139, var5_139 = ShipCalcHelper.GetEliteAndHightLevelShips(arg1_139)

	if #var4_139 > 0 or #var5_139 > 0 then
		table.insert(var0_139, function(arg0_141)
			local var0_141 = false

			if arg0_139.contextData.mode == var0_0.MODE_DESTROY then
				var0_141 = ({
					ShipCalcHelper.CalcDestoryRes(arg1_139)
				})[4]
			end

			arg0_139.destroyConfirmWindow:ExecuteAction("Show", var4_139, var5_139, var0_141, arg0_141)
		end)
	end

	local var6_139 = underscore.filter(arg1_139, function(arg0_142)
		return arg0_142:getFlag("inElite")
	end)

	if #var6_139 > 0 then
		table.insert(var0_139, function(arg0_143)
			arg0_139.destroyConfirmWindow:ExecuteAction("ShowEliteTag", var6_139, arg0_143)
		end)
	end

	seriesAsync(var0_139, arg2_139)
end

return var0_0
