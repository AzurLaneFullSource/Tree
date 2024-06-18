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

	GetSpriteFromAtlasAsync("ui/dockyardui_atlas", var0_57, function(arg0_58)
		setImageSprite(arg0_57.indexBtn, arg0_58, true)
	end)

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

function var0_0.filterForRemouldAndUpgrade(arg0_59)
	arg0_59.shipVOs = {}

	local var0_59 = arg0_59.isFilterLockForMod
	local var1_59 = arg0_59.isFilterLevelForMod

	local function var2_59(arg0_60)
		local var0_60 = true

		if not var0_59 and arg0_60.lockState == Ship.LOCK_STATE_LOCK then
			var0_60 = false
		end

		if not var1_59 and arg0_60.level > 1 then
			var0_60 = false
		end

		return var0_60
	end

	for iter0_59, iter1_59 in pairs(arg0_59.shipVOsById) do
		if var2_59(iter1_59) then
			table.insert(arg0_59.shipVOs, iter1_59)
		end
	end

	table.sort(arg0_59.shipVOs, CompareFuncs({
		function(arg0_61)
			return arg0_61.level
		end,
		function(arg0_62)
			return arg0_62:isTestShip() and 1 or 0
		end
	}))
end

function var0_0.filterCommon(arg0_63)
	arg0_63.shipVOs = {}

	local var0_63 = arg0_63.sortIndex

	local function var1_63(arg0_64)
		if arg0_63.contextData.mode ~= var0_0.MODE_GUILD_BOSS then
			return true
		end

		if arg0_63.isShowAssultShips then
			return true
		end

		if not arg0_64.user then
			return true
		end

		if arg0_64.user.id == arg0_63.player.id then
			return true
		end

		return false
	end

	for iter0_63, iter1_63 in pairs(arg0_63.shipVOsById) do
		if arg0_63.contextData.blockLock and iter1_63:GetLockState() == Ship.LOCK_STATE_LOCK then
			-- block empty
		elseif arg0_63.teamTypeFilter and iter1_63:getTeamType() ~= arg0_63.teamTypeFilter then
			-- block empty
		elseif ShipIndexConst.filterByType(iter1_63, arg0_63.typeIndex) and ShipIndexConst.filterByCamp(iter1_63, arg0_63.campIndex) and ShipIndexConst.filterByRarity(iter1_63, arg0_63.rarityIndex) and ShipIndexConst.filterByExtra(iter1_63, arg0_63.extraIndex) and (arg0_63.commonTag == Ship.PREFERENCE_TAG_NONE or arg0_63.commonTag == iter1_63:GetPreferenceTag()) and var1_63(iter1_63) then
			table.insert(arg0_63.shipVOs, iter1_63)
		end
	end

	local var2_63 = getInputText(arg0_63.nameSearchInput)

	if var2_63 and var2_63 ~= "" then
		arg0_63.shipVOs = underscore.filter(arg0_63.shipVOs, function(arg0_65)
			return arg0_65:IsMatchKey(var2_63)
		end)
	end

	local var3_63, var4_63 = ShipIndexConst.getSortFuncAndName(var0_63, arg0_63.selectAsc)

	if (var0_63 ~= ShipIndexConst.SortIntimacy and true or false) and not defaultValue((arg0_63.contextData.hideTagFlags or {}).inFleet, ShipStatus.TAG_HIDE_BASE.inFleet) then
		table.insert(var3_63, 1, function(arg0_66)
			return arg0_66:getFlag("inFleet") and 0 or 1
		end)
	end

	if var3_63 then
		arg0_63:SortShips(var3_63)
	end

	arg0_63:updateSelected()
	setActive(arg0_63.sortImgAsc, arg0_63.selectAsc)
	setActive(arg0_63.sortImgDesc, not arg0_63.selectAsc)
	setText(arg0_63:findTF("Image", arg0_63.sortBtn), i18n(var4_63))
end

function var0_0.SortShips(arg0_67, arg1_67)
	if pg.NewGuideMgr.GetInstance():IsBusy() then
		local var0_67 = {
			101171,
			201211,
			401231,
			301051
		}

		arg1_67 = {
			function(arg0_68)
				return table.contains(var0_67, arg0_68.configId) and 0 or 1
			end
		}
	elseif arg0_67.isFormTactics then
		table.insert(arg1_67, 1, function(arg0_69)
			return arg0_69:getNation() == Nation.META and 1 or 0
		end)
		table.insert(arg1_67, 1, function(arg0_70)
			return arg0_70:isFullSkillLevel() and 1 or 0
		end)
	elseif arg0_67.contextData.mode == var0_0.MODE_OVERVIEW or arg0_67.contextData.mode == var0_0.MODE_SELECT then
		table.insert(arg1_67, 1, function(arg0_71)
			return -arg0_71.activityNpc
		end)
	elseif arg0_67.contextData.mode == var0_0.MODE_GUILD_BOSS then
		table.insert(arg1_67, 1, function(arg0_72)
			return arg0_72.guildRecommand and 0 or 1
		end)
	end

	table.sort(arg0_67.shipVOs, CompareFuncs(arg1_67))
end

function var0_0.UpdateGuildViewEquipmentsBtn(arg0_73)
	setActive(arg0_73.viewEquipmentBtn, arg0_73.contextData.mode == var0_0.MODE_GUILD_BOSS and #arg0_73.selectedIds > 0)
end

function var0_0.didEnter(arg0_74)
	pg.UIMgr.GetInstance():OverlayPanel(arg0_74.blurPanel)
	setActive(arg0_74.stampBtn, getProxy(TaskProxy):mingshiTouchFlagEnabled() and arg0_74.contextData.mode ~= var0_0.MODE_GUILD_BOSS)
	arg0_74:UpdateGuildViewEquipmentsBtn()
	onButton(arg0_74, arg0_74.stampBtn, function()
		getProxy(TaskProxy):dealMingshiTouchFlag(1)
	end, SFX_CONFIRM)
	onButton(arg0_74, arg0_74:findTF("back", arg0_74.topPanel), function()
		arg0_74:back()
	end, SFX_CANCEL)
	onButton(arg0_74, arg0_74.sortBtn, function()
		arg0_74.selectAsc = not arg0_74.selectAsc

		arg0_74:filter()
	end, SFX_UI_CLICK)

	if arg0_74.contextData.mode == var0_0.MODE_GUILD_BOSS then
		arg0_74.isShowAssultShips = false

		onToggle(arg0_74, arg0_74.assultBtn, function(arg0_78)
			arg0_74.isShowAssultShips = arg0_78

			arg0_74:filter()
		end, SFX_PANEL)
		triggerToggle(arg0_74.assultBtn, true)

		arg0_74.guildShipEquipmentsPage = GuildShipEquipmentsPage.New(arg0_74._tf, arg0_74.event)

		arg0_74.guildShipEquipmentsPage:SetCallBack(function()
			arg0_74:TriggerCard(-1)
		end, function()
			arg0_74:TriggerCard(1)
		end)
		onButton(arg0_74, arg0_74.viewEquipmentBtn, function()
			local var0_81 = arg0_74.selectedIds[#arg0_74.selectedIds]

			if not var0_81 then
				return
			end

			local var1_81 = arg0_74.shipVOsById[var0_81]
			local var2_81 = var1_81.user

			arg0_74.guildShipEquipmentsPage:ExecuteAction("Show", var1_81, var2_81)
		end, SFX_PANEL)
	end

	local var0_74 = arg0_74.attrBtn:GetComponent("Button")

	eachChild(var0_74, function(arg0_82)
		setActive(arg0_82, false)
	end)

	arg0_74.isFormTactics = arg0_74.contextData.prevPage == "NewNavalTacticsMediator"

	local var1_74 = arg0_74:findTF("off", var0_74):GetComponent("Image")
	local var2_74 = arg0_74:findTF("on", var0_74):GetComponent("Image")

	if arg0_74.isFormTactics then
		GetImageSpriteFromAtlasAsync("ui/dockyardui_atlas", "skill_off", var1_74)
		GetImageSpriteFromAtlasAsync("ui/dockyardui_atlas", "skill_on", var2_74)
	else
		GetImageSpriteFromAtlasAsync("ui/dockyardui_atlas", "attr_off", var1_74)
		GetImageSpriteFromAtlasAsync("ui/dockyardui_atlas", "attr_on", var2_74)
	end

	if arg0_74.isRemouldOrUpgradeMode then
		local var3_74 = getProxy(SettingsProxy)

		arg0_74.isFilterLevelForMod = var3_74:GetDockYardLevelBtnFlag()

		arg0_74:OnSwitch(arg0_74.modLeveFilter, arg0_74.isFilterLevelForMod, function(arg0_83)
			arg0_74.isFilterLevelForMod = arg0_83

			arg0_74:filter()
		end)

		arg0_74.isFilterLockForMod = var3_74:GetDockYardLockBtnFlag()

		arg0_74:OnSwitch(arg0_74.modLockFilter, arg0_74.isFilterLockForMod, function(arg0_84)
			arg0_74.isFilterLockForMod = arg0_84

			arg0_74:filter()
		end)
	end

	onButton(arg0_74, var0_74, function()
		if not arg0_74.isFormTactics then
			arg0_74.itemDetailType = (arg0_74.itemDetailType + 1) % 4
		else
			arg0_74.itemDetailType = arg0_74.itemDetailType == DockyardShipItem.DetailType0 and DockyardShipItem.DetailType3 or DockyardShipItem.DetailType0
		end

		setActive(var2_74, arg0_74.itemDetailType ~= DockyardShipItem.DetailType0)
		setActive(var1_74, arg0_74.itemDetailType == DockyardShipItem.DetailType0)

		var0_74.targetGraphic = arg0_74.itemDetailType == DockyardShipItem.DetailType0 and var1_74 or var2_74

		arg0_74:updateItemDetailType()
	end, SFX_PANEL)
	triggerButton(var0_74)
	onButton(arg0_74, arg0_74.selectPanel:Find("cancel_button"), function()
		if arg0_74.animating then
			return
		end

		if arg0_74.contextData.mode == var0_0.MODE_DESTROY then
			if #arg0_74.selectedIds > 0 then
				arg0_74:unselecteAllShips()
				arg0_74:back()
			else
				arg0_74:back()
			end
		else
			arg0_74:back()

			return
		end
	end, SFX_CANCEL)
	onButton(arg0_74, arg0_74.selectPanel:Find("confirm_button"), function()
		if arg0_74.animating then
			return
		end

		if arg0_74.contextData.mode == var0_0.MODE_DESTROY then
			local var0_87, var1_87 = arg0_74:checkDestroyGold()

			if not var0_87 or not var1_87 then
				if not var0_87 then
					pg.TipsMgr.GetInstance():ShowTips(i18n("gold_max_tip_title") .. i18n("resource_max_tip_retire"))
				elseif not var0_87 then
					pg.TipsMgr.GetInstance():ShowTips(i18n("oil_max_tip_title") .. i18n("resource_max_tip_retire"))
				end

				return
			end
		end

		if #arg0_74.selectedIds < arg0_74.selectedMin then
			if arg0_74.leastLimitMsg then
				pg.TipsMgr.GetInstance():ShowTips(arg0_74.leastLimitMsg)
			else
				pg.TipsMgr.GetInstance():ShowTips(i18n("ship_dockyardScene_error_choiseRoleMore", arg0_74.selectedMin))
			end

			return
		end

		if arg0_74.contextData.mode == var0_0.MODE_DESTROY then
			arg0_74:displayDestroyPanel()
		else
			local var2_87 = {}

			if arg0_74.contextData.destroyCheck then
				local var3_87 = underscore.map(arg0_74.selectedIds, function(arg0_88)
					return arg0_74.shipVOsById[arg0_88]
				end)

				table.insert(var2_87, function(arg0_89)
					arg0_74:checkDestroyShips(var3_87, arg0_89)
				end)
			end

			seriesAsync(var2_87, function()
				if arg0_74.confirmSelect then
					arg0_74.confirmSelect(arg0_74.selectedIds, function()
						arg0_74.onSelected(arg0_74.selectedIds)
						arg0_74:back()
					end, function()
						arg0_74:back()
					end)
				elseif arg0_74.callbackQuit then
					arg0_74.onSelected(arg0_74.selectedIds, function()
						arg0_74:back()
					end)
				else
					arg0_74.onSelected(arg0_74.selectedIds)
					arg0_74:back()
				end
			end)
		end
	end, SFX_CONFIRM)
	onButton(arg0_74, arg0_74.selectPanel:Find("quick_select"), function()
		if arg0_74.animating then
			return
		end

		local var0_94 = {
			PlayerPrefs.GetInt("QuickSelectRarity1", 3),
			PlayerPrefs.GetInt("QuickSelectRarity2", 4),
			PlayerPrefs.GetInt("QuickSelectRarity3", 2)
		}
		local var1_94 = 3
		local var2_94 = {}

		for iter0_94, iter1_94 in pairs(var0_94) do
			if iter1_94 ~= 0 then
				var2_94[iter1_94] = var2_94[iter1_94] or var1_94
				var1_94 = var1_94 - 1
			end
		end

		local var3_94 = getProxy(BayProxy):getShips()
		local var4_94 = {}
		local var5_94 = {}

		for iter2_94, iter3_94 in pairs(var3_94) do
			if iter3_94:isMaxStar() then
				var4_94[iter3_94:getGroupId()] = true
			else
				local var6_94 = iter3_94:getMaxStar() - iter3_94:getStar() + 1

				if iter3_94:GetLockState() == Ship.LOCK_STATE_UNLOCK then
					var6_94 = var6_94 + 1
				end

				local var7_94 = var5_94[iter3_94:getGroupId()]

				var5_94[iter3_94:getGroupId()] = var7_94 and var7_94 < var6_94 and var7_94 or var6_94
			end
		end

		local var8_94 = _.select(arg0_74.shipVOs, function(arg0_95)
			return arg0_95.configId ~= 100001 and arg0_95.configId ~= 100011 and arg0_95:GetLockState() == Ship.LOCK_STATE_UNLOCK and table.contains(var0_94, arg0_95:getRarity()) and arg0_95.level == 1 and not arg0_74.blacklist[arg0_95:getGroupId()] and not table.contains(arg0_74.selectedIds, arg0_95.id) and not arg0_95:hasAnyFlag({
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

		if not _.all(var8_94, function(arg0_96)
			return arg0_74.blacklist[arg0_96:getGroupId()]
		end) then
			var8_94 = _.select(var8_94, function(arg0_97)
				return not arg0_74.blacklist[arg0_97:getGroupId()]
			end)
		elseif #arg0_74.selectedIds > 0 then
			var8_94 = {}
		end

		table.sort(var8_94, function(arg0_98, arg1_98)
			local var0_98 = var2_94[arg0_98:getRarity()] or 0
			local var1_98 = var2_94[arg1_98:getRarity()] or 0

			if var0_98 == var1_98 then
				if arg0_98:getGroupId() == arg1_98:getGroupId() then
					return arg0_98.createTime > arg1_98.createTime
				end

				return arg0_98.configId > arg1_98.configId
			else
				return var1_98 < var0_98
			end
		end)

		local var9_94 = PlayerPrefs.GetString("QuickSelectWhenHasAtLeastOneMaxstar", "KeepNone")
		local var10_94 = PlayerPrefs.GetString("QuickSelectWithoutMaxstar", "KeepAll")
		local var11_94 = {}
		local var12_94 = _.select(var8_94, function(arg0_99)
			if var4_94[arg0_99:getGroupId()] then
				if var9_94 == "KeepNone" then
					return true
				elseif var9_94 == "KeepOne" then
					if not var11_94[arg0_99:getGroupId()] then
						var11_94[arg0_99:getGroupId()] = true

						return false
					end

					return true
				elseif var9_94 == "KeepAll" then
					return false
				end
			elseif var10_94 == "KeepNone" then
				return true
			elseif var10_94 == "KeepNeeded" then
				if var5_94[arg0_99:getGroupId()] > 0 then
					var5_94[arg0_99:getGroupId()] = var5_94[arg0_99:getGroupId()] - 1

					return false
				end

				return true
			elseif var10_94 == "KeepAll" then
				return false
			end
		end)
		local var13_94 = 0
		local var14_94 = false
		local var15_94 = false
		local var16_94 = 0
		local var17_94 = 0

		for iter4_94, iter5_94 in ipairs(arg0_74.selectedIds) do
			local var18_94, var19_94 = arg0_74.shipVOsById[iter5_94]:calReturnRes()

			var16_94 = var16_94 + var18_94
			var17_94 = var17_94 + var19_94
		end

		for iter6_94, iter7_94 in ipairs(var12_94) do
			if arg0_74.selectedMax > 0 and arg0_74.selectedMax <= #arg0_74.selectedIds then
				break
			end

			local var20_94, var21_94 = iter7_94:calReturnRes()

			var16_94 = var16_94 + var20_94
			var17_94 = var17_94 + var21_94
			var14_94 = arg0_74.player:OilMax(var17_94)
			var15_94 = arg0_74.player:GoldMax(var16_94)

			if var15_94 then
				break
			end

			var13_94 = var13_94 + 1

			arg0_74:selectShip(iter7_94, true)
		end

		if var13_94 == 0 then
			if var15_94 then
				if #arg0_74.selectedIds == 0 then
					pg.TipsMgr.GetInstance():ShowTips(i18n("gold_max_tip_title") .. i18n("resource_max_tip_retire"))
				else
					pg.TipsMgr.GetInstance():ShowTips(i18n("gold_max_tip_title"))
				end
			elseif #arg0_74.selectedIds > 0 then
				arg0_74:displayDestroyPanel()
			else
				pg.TipsMgr.GetInstance():ShowTips(i18n("retire_selectzero"))
			end
		elseif var14_94 then
			pg.MsgboxMgr.GetInstance():ShowMsgBox({
				content = i18n("oil_max_tip_title") .. i18n("resource_max_tip_retire_1"),
				onYes = function()
					arg0_74:displayDestroyPanel()
				end
			})
		else
			arg0_74:displayDestroyPanel()
		end
	end, SFX_CONFIRM)

	if not arg0_74.contextData.selectFriend then
		arg0_74.shipContainer:GetComponentInChildren(typeof(GridLayoutGroup)).constraintCount = 7
	end

	arg0_74:filter()
	arg0_74:updateBarInfo()

	if arg0_74.contextData.mode == var0_0.MODE_WORLD then
		arg0_74:initWorldPanel()
	elseif arg0_74.contextData.mode == var0_0.MODE_DESTROY and not LOCK_DESTROY_GUIDE then
		pg.SystemGuideMgr.GetInstance():Play(arg0_74)
	end

	setAnchoredPosition(arg0_74.topPanel, {
		y = arg0_74.topPanel.rect.height
	})
	setAnchoredPosition(arg0_74.selectPanel, {
		y = -1 * arg0_74.selectPanel.rect.height
	})
	onNextTick(function()
		if arg0_74.exited then
			return
		end

		arg0_74:uiStartAnimating()
	end)

	if arg0_74.contextData.selectShipId then
		arg0_74.selectedIds = {}

		table.insert(arg0_74.selectedIds, arg0_74.contextData.selectShipId)
		arg0_74:updateSelected()
	end

	arg0_74.bulinTip = AprilFoolBulinSubView.ShowAprilFoolBulin(arg0_74)

	onButton(arg0_74, arg0_74.settingBtn, function()
		arg0_74.settingPanel:Load()
		arg0_74.settingPanel:ActionInvoke("Show")
	end)
	pg.SystemGuideMgr.GetInstance():Play(arg0_74)
end

function var0_0.TriggerCard(arg0_103, arg1_103)
	local var0_103 = arg0_103.selectedIds[1]

	if not var0_103 then
		return
	end

	local var1_103

	for iter0_103, iter1_103 in ipairs(arg0_103.shipVOs) do
		if iter1_103 and iter1_103.id == var0_103 then
			var1_103 = iter0_103

			break
		end
	end

	if not var1_103 then
		return
	end

	local var2_103 = var1_103
	local var3_103

	local function var4_103()
		var2_103 = var2_103 + arg1_103

		local var0_104 = arg0_103.shipVOs[var2_103]

		if not var0_104 or arg0_103.checkShip(var0_104) then
			return var0_104
		else
			return var4_103()
		end
	end

	local var5_103 = var4_103()

	if not var5_103 then
		return
	end

	local function var6_103()
		local var0_105

		for iter0_105, iter1_105 in pairs(arg0_103.scrollItems) do
			if iter1_105.shipVO and iter1_105.go.name ~= "-1" and iter1_105.shipVO.id == var5_103.id then
				var0_105 = iter1_105

				break
			end
		end

		return var0_105
	end

	local var7_103 = var6_103()

	if var7_103 then
		local var8_103 = getBounds(arg0_103:findTF("main/ship_container"))
		local var9_103 = getBounds(var7_103.tr)

		if not var8_103:Intersects(var9_103) then
			local var10_103 = arg1_103 * (arg0_103.shipContainer:HeadIndexToValue(7) - arg0_103.shipContainer:HeadIndexToValue(1))
			local var11_103 = arg0_103.shipContainer.value + var10_103

			arg0_103.shipContainer:SetNormalizedPosition(var11_103, 1)
		end
	end

	if not var7_103 then
		local var12_103 = (math.ceil(var2_103 / 7) - math.ceil(var1_103 / 7)) * (arg0_103.shipContainer:HeadIndexToValue(21) - arg0_103.shipContainer:HeadIndexToValue(1))
		local var13_103 = arg0_103.shipContainer.value + var12_103

		arg0_103.shipContainer:SetNormalizedPosition(var13_103, 1)

		var7_103 = var6_103()
	end

	if var7_103 then
		triggerButton(var7_103.tr)

		local var14_103 = arg0_103.shipVOsById[var7_103.shipVO.id]

		arg0_103.guildShipEquipmentsPage:Refresh(var14_103, var14_103.user)
	end
end

function var0_0.OnSwitch(arg0_106, arg1_106, arg2_106, arg3_106)
	local function var0_106()
		setActive(arg1_106:Find("off"), not arg2_106)
		setActive(arg1_106:Find("on"), arg2_106)
	end

	onButton(arg0_106, arg1_106, function()
		arg2_106 = not arg2_106

		if arg3_106 then
			arg3_106(arg2_106)
		end

		var0_106()
	end, SFX_PANEL)
	var0_106()
end

function var0_0.onBackPressed(arg0_109)
	if arg0_109.destroyConfirmWindow:isShowing() then
		arg0_109.destroyConfirmWindow:Hide()

		return
	end

	if arg0_109.destroyPage:isShowing() then
		arg0_109.destroyPage:Hide()

		return
	end

	if arg0_109.settingPanel:isShowing() then
		arg0_109.settingPanel:Hide()

		return
	end

	pg.CriMgr.GetInstance():PlaySoundEffect_V3(SFX_CANCEL)
	arg0_109:back()
end

function var0_0.updateShipStatusById(arg0_110, arg1_110)
	for iter0_110, iter1_110 in pairs(arg0_110.scrollItems) do
		if iter1_110.shipVO and iter1_110.shipVO.id == arg1_110 then
			iter1_110:flush(arg0_110.selectedIds)

			if arg0_110.contextData.mode == DockyardScene.MODE_WORLD then
				iter1_110:updateWorld()
			end
		end
	end
end

function var0_0.checkDestroyGold(arg0_111, arg1_111)
	local var0_111 = 0
	local var1_111 = 0

	for iter0_111, iter1_111 in ipairs(arg0_111.selectedIds) do
		local var2_111, var3_111 = arg0_111.shipVOsById[iter1_111]:calReturnRes()

		var0_111 = var0_111 + var2_111
		var1_111 = var1_111 + var3_111
	end

	if arg1_111 then
		local var4_111, var5_111 = arg1_111:calReturnRes()

		var0_111 = var0_111 + var4_111
		var1_111 = var1_111 + var5_111
	end

	local var6_111 = arg0_111.player:OilMax(var1_111)

	if arg0_111.player:GoldMax(var0_111) then
		return false, not var6_111
	end

	return true, not var6_111
end

function var0_0.selectShip(arg0_112, arg1_112, arg2_112)
	local var0_112 = false
	local var1_112

	for iter0_112, iter1_112 in ipairs(arg0_112.selectedIds) do
		if iter1_112 == arg1_112.id then
			var0_112 = true
			var1_112 = iter0_112

			break
		end
	end

	if not var0_112 then
		local var2_112, var3_112 = arg0_112.checkShip(arg1_112, function()
			if not arg0_112.exited then
				arg0_112:selectShip(arg1_112)
			end
		end, arg0_112.selectedMax == 1 and {} or arg0_112.selectedIds)

		if not var2_112 then
			if var3_112 then
				pg.TipsMgr.GetInstance():ShowTips(var3_112)
			end

			return
		end

		if arg0_112.selectedMax == 1 then
			local var4_112 = arg0_112.selectedIds[1]

			arg0_112.selectedIds[1] = arg1_112.id
		elseif arg0_112.selectedMax == 0 or #arg0_112.selectedIds < arg0_112.selectedMax then
			table.insert(arg0_112.selectedIds, arg1_112.id)
			arg0_112:updateBlackBlocks(arg1_112)
		else
			pg.TipsMgr.GetInstance():ShowTips(i18n("ship_dockyardScene_error_choiseRoleLess", arg0_112.selectedMax))

			return
		end
	else
		local var5_112, var6_112 = arg0_112.onCancelShip(arg1_112, function()
			if not arg0_112.exited then
				arg0_112:selectShip(arg1_112)
			end
		end, arg0_112.selectedIds)

		if not var5_112 then
			if var6_112 then
				pg.TipsMgr.GetInstance():ShowTips(var6_112)
			end

			return
		end

		table.remove(arg0_112.selectedIds, var1_112)

		if arg0_112.selectedMax ~= 1 then
			arg0_112:updateBlackBlocks(arg1_112)
		end
	end

	arg0_112:updateSelected()

	if arg0_112.contextData.mode == var0_0.MODE_DESTROY then
		arg0_112:updateDestroyRes()
	elseif arg0_112.contextData.mode == var0_0.MODE_MOD then
		arg0_112:updateModAttr()
	end

	arg0_112:UpdateGuildViewEquipmentsBtn()
end

function var0_0.updateBlackBlocks(arg0_115, arg1_115)
	if not arg0_115.contextData.useBlackBlock or not arg1_115 then
		return
	end

	for iter0_115, iter1_115 in pairs(arg0_115.scrollItems) do
		arg0_115:updateItemBlackBlock(iter1_115)
	end
end

function var0_0.updateItemBlackBlock(arg0_116, arg1_116)
	if arg0_116.contextData.useBlackBlock then
		if arg0_116.selectedMax == 1 then
			arg1_116:updateBlackBlock(arg0_116.contextData.otherSelectedIds)
		else
			arg1_116:updateBlackBlock(arg0_116.selectedIds)
		end
	else
		arg1_116:updateBlackBlock()
	end
end

function var0_0.unselecteAllShips(arg0_117)
	arg0_117.selectedIds = {}

	arg0_117:updateSelected()
	arg0_117:updateDestroyRes()
end

function var0_0.updateSelected(arg0_118)
	for iter0_118, iter1_118 in pairs(arg0_118.scrollItems) do
		if iter1_118.shipVO then
			local var0_118 = false

			for iter2_118, iter3_118 in ipairs(arg0_118.selectedIds) do
				if iter1_118.shipVO.id == iter3_118 then
					var0_118 = true

					break
				end
			end

			iter1_118:updateSelected(var0_118)
		end
	end

	if arg0_118.selectedMax == 0 then
		setText(arg0_118.selectPanel:Find("bottom_info/bg_input/count"), #arg0_118.selectedIds)
	else
		local var1_118 = #arg0_118.selectedIds

		if arg0_118.contextData.mode ~= var0_0.MODE_DESTROY or #arg0_118.selectedIds == 0 then
			var1_118 = setColorStr(#arg0_118.selectedIds, COLOR_WHITE)
		elseif arg0_118.contextData.mode == var0_0.MODE_DESTROY then
			var1_118 = #arg0_118.selectedIds == 10 and setColorStr(#arg0_118.selectedIds, COLOR_RED) or setColorStr(#arg0_118.selectedIds, COLOR_GREEN)
		end

		setText(arg0_118.selectPanel:Find("bottom_info/bg_input/count"), var1_118 .. "/" .. arg0_118.selectedMax)
	end

	if #arg0_118.selectedIds < arg0_118.selectedMin then
		setActive(arg0_118.selectPanel:Find("confirm_button/mask"), true)
	else
		setActive(arg0_118.selectPanel:Find("confirm_button/mask"), false)
	end

	if arg0_118.contextData.mode == var0_0.MODE_MOD then
		arg0_118:updateModAttr()
	end
end

function var0_0.updateItemDetailType(arg0_119)
	for iter0_119, iter1_119 in pairs(arg0_119.scrollItems) do
		iter1_119:updateDetail(arg0_119.itemDetailType)
	end

	arg0_119.shipLayout.anchoredPosition = arg0_119.shipLayout.anchoredPosition + Vector3(0, 0.001, 0)
end

function var0_0.closeDestroyMode(arg0_120)
	setActive(arg0_120.awardTF, false)
	setActive(arg0_120.bottomTipsText, true)
end

function var0_0.updateDestroyRes(arg0_121)
	if table.getCount(arg0_121.selectedIds) == 0 then
		arg0_121:closeDestroyMode()
	else
		setActive(arg0_121.awardTF, true)
		setActive(arg0_121.bottomTipsText, false)
	end

	local var0_121 = _.map(arg0_121.selectedIds, function(arg0_122)
		return arg0_121.shipVOsById[arg0_122]
	end)
	local var1_121, var2_121, var3_121 = ShipCalcHelper.CalcDestoryRes(var0_121)
	local var4_121 = var2_121 == 0

	if arg0_121.destroyResList then
		local var5_121 = (var4_121 and 1 or 2) + #var3_121

		arg0_121.destroyResList:make(function(arg0_123, arg1_123, arg2_123)
			if arg0_123 == UIItemList.EventUpdate then
				local var0_123 = ""
				local var1_123 = 0

				if arg1_123 == 0 then
					var0_123, var1_123 = "Props/gold", var1_121
				elseif arg1_123 == 1 then
					if not var4_121 then
						var0_123, var1_123 = "Props/oil", var2_121
					else
						local var2_123 = var3_121[1]

						var0_123, var1_123 = Item.getConfigData(var2_123.id).icon, var2_123.count
					end
				elseif arg1_123 > 1 then
					local var3_123 = var4_121 and var3_121[arg1_123] or var3_121[arg1_123 - 1]

					var0_123, var1_123 = Item.getConfigData(var3_123.id).icon, var3_123.count
				end

				GetImageSpriteFromAtlasAsync(var0_123, "", arg2_123:Find("icon"))
				setText(arg2_123:Find("Text"), "X" .. var1_123)
			end
		end)
		arg0_121.destroyResList:align(var5_121)
	end

	if arg0_121.destroyPage and arg0_121.destroyPage:GetLoaded() and arg0_121.destroyPage:isShowing() then
		arg0_121.destroyPage:RefreshRes()
	end
end

function var0_0.setModShip(arg0_124, arg1_124)
	arg0_124.modShip = arg1_124
end

function var0_0.updateModAttr(arg0_125)
	if table.getCount(arg0_125.selectedIds) == 0 then
		arg0_125:closeModAttr()
	else
		setActive(arg0_125.modAttrsTF, true)
		setActive(arg0_125.bottomTipsText, false)
	end

	local var0_125 = arg0_125.contextData.ignoredIds[1]
	local var1_125 = {}

	for iter0_125, iter1_125 in ipairs(arg0_125.selectedIds) do
		table.insert(var1_125, arg0_125.shipVOsById[iter1_125])
	end

	local var2_125 = ShipModLayer.getModExpAdditions(arg0_125.modShip, var1_125)

	for iter2_125, iter3_125 in pairs(ShipModAttr.ID_TO_ATTR) do
		if iter2_125 ~= ShipModLayer.IGNORE_ID then
			local var3_125 = arg0_125.modAttrContainer:Find("attr_" .. iter2_125)

			setText(var3_125:Find("value"), var2_125[iter3_125])
			setText(var3_125:Find("name"), ShipModAttr.id2Name(iter2_125))
		end
	end
end

function var0_0.closeModAttr(arg0_126)
	setActive(arg0_126.modAttrsTF, false)
	setActive(arg0_126.bottomTipsText, true)
end

function var0_0.removeShip(arg0_127, arg1_127)
	for iter0_127, iter1_127 in ipairs(arg0_127.selectedIds) do
		if iter1_127 == arg1_127 then
			table.remove(arg0_127.selectedIds, iter0_127)

			break
		end
	end

	for iter2_127 = #arg0_127.shipVOs, 1, -1 do
		if arg0_127.shipVOs[iter2_127].id == arg1_127 then
			table.remove(arg0_127.shipVOs, iter2_127)

			break
		end
	end

	arg0_127.shipVOsById[arg1_127] = nil
end

function var0_0.updateShipCount(arg0_128, arg1_128)
	arg0_128.shipContainer:SetTotalCount(#arg0_128.shipVOs, defaultValue(arg1_128, -1))
	setActive(arg0_128.listEmptyTF, #arg0_128.shipVOs <= 0)
end

function var0_0.ClearShipsBlackBlock(arg0_129)
	if not arg0_129.shipVOsById then
		return
	end

	for iter0_129, iter1_129 in pairs(arg0_129.shipVOsById) do
		iter1_129.blackBlock = false
	end
end

function var0_0.willExit(arg0_130)
	arg0_130:closeDestroyMode()
	arg0_130:closeModAttr()
	arg0_130:ClearShipsBlackBlock()

	if arg0_130.guildShipEquipmentsPage then
		arg0_130.guildShipEquipmentsPage:Destroy()
	end

	if arg0_130.settingPanel then
		arg0_130.settingPanel:Destroy()
	end

	if arg0_130.destroyPage then
		arg0_130.destroyPage:Destroy()
	end

	if arg0_130.destroyConfirmWindow then
		arg0_130.destroyConfirmWindow:Destroy()
	end

	if arg0_130.contextData.mode == var0_0.MODE_MOD then
		-- block empty
	elseif not arg0_130.contextData.sortData then
		if _G[arg0_130.contextData.preView] then
			_G[arg0_130.contextData.preView].sortIndex = arg0_130.sortIndex
			_G[arg0_130.contextData.preView].selectAsc = arg0_130.selectAsc
			_G[arg0_130.contextData.preView].typeIndex = arg0_130.typeIndex
			_G[arg0_130.contextData.preView].campIndex = arg0_130.campIndex
			_G[arg0_130.contextData.preView].rarityIndex = arg0_130.rarityIndex
			_G[arg0_130.contextData.preView].extraIndex = arg0_130.extraIndex
			_G[arg0_130.contextData.preView].commonTag = arg0_130.commonTag
		else
			DockyardScene.sortIndex = arg0_130.sortIndex
			DockyardScene.selectAsc = arg0_130.selectAsc
			DockyardScene.typeIndex = arg0_130.typeIndex
			DockyardScene.campIndex = arg0_130.campIndex
			DockyardScene.rarityIndex = arg0_130.rarityIndex
			DockyardScene.extraIndex = arg0_130.extraIndex
			DockyardScene.commonTag = arg0_130.commonTag
		end
	end

	arg0_130.shipContainer.enabled = false

	for iter0_130, iter1_130 in pairs(arg0_130.scrollItems) do
		iter1_130:clear()
		GetOrAddComponent(iter1_130.go, "UILongPressTrigger").onLongPressed:RemoveAllListeners()
	end

	if LeanTween.isTweening(go(arg0_130.energyDescTF)) then
		setActive(arg0_130.energyDescTF, false)
		LeanTween.cancel(go(arg0_130.energyDescTF))
	end

	arg0_130:cancelAnimating()

	if arg0_130.isRemouldOrUpgradeMode then
		local var0_130 = getProxy(SettingsProxy)

		var0_130:SetDockYardLockBtnFlag(arg0_130.isFilterLockForMod)
		var0_130:SetDockYardLevelBtnFlag(arg0_130.isFilterLevelForMod)
	end

	if arg0_130.bulinTip then
		arg0_130.bulinTip:Destroy()

		arg0_130.bulinTip = nil
	end

	pg.UIMgr.GetInstance():UnOverlayPanel(arg0_130.blurPanel, arg0_130._tf)
end

function var0_0.uiStartAnimating(arg0_131)
	local var0_131 = arg0_131:findTF("back", arg0_131.topPanel)
	local var1_131 = 0
	local var2_131 = 0.3

	if isActive(arg0_131.selectPanel) then
		shiftPanel(arg0_131.selectPanel, nil, 0, var2_131, var1_131, true, true)
	end
end

function var0_0.uiExitAnimating(arg0_132)
	if arg0_132.contextData.mode == var0_0.MODE_OVERVIEW then
		-- block empty
	else
		local var0_132 = 0
		local var1_132 = 0.3

		shiftPanel(arg0_132.selectPanel, nil, -1 * arg0_132.selectPanel.rect.height, var1_132, var0_132, true, true)
	end
end

function var0_0.back(arg0_133)
	if arg0_133.exited then
		return
	end

	arg0_133:closeView()
end

function var0_0.cancelAnimating(arg0_134)
	if LeanTween.isTweening(go(arg0_134.topPanel)) then
		LeanTween.cancel(go(arg0_134.topPanel))
	end

	if LeanTween.isTweening(go(arg0_134.selectPanel)) then
		LeanTween.cancel(go(arg0_134.selectPanel))
	end

	if arg0_134.tweens then
		cancelTweens(arg0_134.tweens)
	end
end

function var0_0.quickExitFunc(arg0_135)
	seriesAsync({
		function(arg0_136)
			if arg0_135.contextData.onQuickHome then
				arg0_135.contextData.onQuickHome(arg0_136)
			else
				arg0_136()
			end
		end,
		function(arg0_137)
			arg0_135:emit(var0_0.ON_HOME)
		end
	})
end

function var0_0.displayDestroyPanel(arg0_138)
	arg0_138.destroyPage:ExecuteAction("Show")
	arg0_138.destroyPage:ActionInvoke("Refresh", arg0_138.selectedIds, arg0_138.shipVOsById)
end

function var0_0.closeDestroyPanel(arg0_139)
	if arg0_139.destroyPage:isShowing() then
		arg0_139.destroyPage:Hide()
	end
end

function var0_0.checkDestroyShips(arg0_140, arg1_140, arg2_140)
	local var0_140 = {}

	if PlayerPrefs.GetInt("RetireProtect", 1) == 0 then
		local var1_140 = {}

		for iter0_140, iter1_140 in pairs(arg1_140) do
			local var2_140 = 0

			for iter2_140, iter3_140 in pairs(arg1_140) do
				if iter3_140:getGroupId() == iter1_140:getGroupId() then
					var2_140 = var2_140 + 1
				end
			end

			if #getProxy(BayProxy):findShipsByGroup(iter1_140:getGroupId()) == var2_140 then
				local var3_140 = false

				for iter4_140, iter5_140 in pairs(var1_140) do
					if iter5_140:getGroupId() == iter1_140:getGroupId() then
						var3_140 = true

						break
					end
				end

				if not var3_140 then
					table.insert(var1_140, iter1_140)
				end
			end
		end

		if #var1_140 > 0 then
			table.insert(var0_140, function(arg0_141)
				arg0_140.destroyConfirmWindow:ExecuteAction("ShowOneShipProtect", var1_140, arg0_141)
			end)
		end
	end

	local var4_140, var5_140 = ShipCalcHelper.GetEliteAndHightLevelShips(arg1_140)

	if #var4_140 > 0 or #var5_140 > 0 then
		table.insert(var0_140, function(arg0_142)
			local var0_142 = false

			if arg0_140.contextData.mode == var0_0.MODE_DESTROY then
				var0_142 = ({
					ShipCalcHelper.CalcDestoryRes(arg1_140)
				})[4]
			end

			arg0_140.destroyConfirmWindow:ExecuteAction("Show", var4_140, var5_140, var0_142, arg0_142)
		end)
	end

	local var6_140 = underscore.filter(arg1_140, function(arg0_143)
		return arg0_143:getFlag("inElite")
	end)

	if #var6_140 > 0 then
		table.insert(var0_140, function(arg0_144)
			arg0_140.destroyConfirmWindow:ExecuteAction("ShowEliteTag", var6_140, arg0_144)
		end)
	end

	seriesAsync(var0_140, arg2_140)
end

return var0_0
