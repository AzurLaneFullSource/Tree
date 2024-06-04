local var0 = class("DockyardScene", import("..base.BaseUI"))
local var1 = 2
local var2 = 0.2
local var3 = 1

var0.MODE_OVERVIEW = "overview"
var0.MODE_DESTROY = "destroy"
var0.MODE_SELECT = "select"
var0.MODE_MOD = "modify"
var0.MODE_WORLD = "world"
var0.MODE_REMOULD = "remould"
var0.MODE_UPGRADE = "upgrade"
var0.MODE_GUILD_BOSS = "guildboss"
var0.TITLE_CN_OVERVIEW = i18n("word_dockyard")
var0.TITLE_CN_UPGRADE = i18n("word_dockyardUpgrade")
var0.TITLE_CN_DESTROY = i18n("word_dockyardDestroy")
var0.TITLE_EN_OVERVIEW = "dockyard"
var0.TITLE_EN_UPGRADE = "modernization"
var0.TITLE_EN_DESTROY = "retirement"
var0.PRIOR_MODE_EQUIP_UP = 1
var0.PRIOR_MODE_SHIP_UP = 2

function var0.getUIName(arg0)
	return "DockyardUI"
end

function var0.init(arg0)
	arg0._tf:SetAsLastSibling()

	local var0 = arg0.contextData

	var0.mode = defaultValue(var0.mode, var0.MODE_SELECT)
	var0.otherSelectedIds = defaultValue(var0.otherSelectedIds, {})
	arg0.teamTypeFilter = var0.teamFilter
	arg0.selectedMin = var0.selectedMin or 1
	arg0.leastLimitMsg = var0.leastLimitMsg
	arg0.selectedMax = var0.selectedMax or 0
	var0.selectedIds = var0.selectedIds or {}

	if var0.infoShipId then
		table.insert(var0.selectedIds, var0.infoShipId)

		var0.infoShipId = nil
	end

	arg0.selectedIds = underscore(var0.selectedIds):chain():select(function(arg0)
		return getProxy(BayProxy):RawGetShipById(arg0) ~= nil
	end):first(arg0.selectedMax):value()
	var0.selectedIds = nil
	arg0.checkShip = var0.onShip or function(arg0, arg1, arg2)
		return true
	end
	arg0.onCancelShip = var0.onCancelShip or function(arg0, arg1, arg2)
		return true
	end
	arg0.onClick = var0.onClick or function(arg0, arg1, arg2)
		arg0:emit(DockyardMediator.ON_SHIP_DETAIL, arg0, arg1, arg2)
	end
	arg0.confirmSelect = var0.confirmSelect
	arg0.callbackQuit = var0.callbackQuit
	arg0.onSelected = var0.onSelected or function(arg0, arg1)
		warning("not implemented.")
	end
	arg0.blurPanel = arg0:findTF("blur_panel")
	arg0.settingBtn = arg0.blurPanel:Find("adapt/left_length/frame/setting")
	arg0.settingPanel = DockyardQuickSelectSettingPage.New(arg0._tf, arg0.event)

	arg0.settingPanel:OnSettingChanged(function()
		arg0:unselecteAllShips()
	end)

	arg0.topPanel = arg0.blurPanel:Find("adapt/top")
	arg0.sortBtn = arg0.topPanel:Find("sort_button")
	arg0.sortImgAsc = arg0.sortBtn:Find("asc")
	arg0.sortImgDesc = arg0.sortBtn:Find("desc")
	arg0.leftTipsText = arg0.topPanel:Find("capacity")

	onButton(arg0, arg0.leftTipsText:Find("switch"), function()
		arg0.isCapacityMeta = not arg0.isCapacityMeta

		arg0:updateCapacityDisplay()
	end, SFX_PANEL)
	onButton(arg0, arg0.leftTipsText:Find("plus"), function()
		gotoChargeScene()
	end, SFX_PANEL)
	onButton(arg0, arg0.leftTipsText:Find("tip"), function()
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			hideNo = true,
			content = i18n("specialshipyard_tip")
		})
	end, SFX_PANEL)
	setActive(arg0.leftTipsText, false)

	arg0.indexBtn = arg0.topPanel:Find("index_button")
	arg0.switchPanel = arg0.topPanel:Find("switch")

	triggerToggle(arg0.switchPanel:Find("Image"), true)

	arg0.preferenceBtn = arg0.switchPanel:Find("toggles/preference_toggle")
	arg0.attrBtn = arg0.switchPanel:Find("toggles/attr_toggle")
	arg0.nameSearchInput = arg0.switchPanel:Find("search")

	setText(arg0.nameSearchInput:Find("holder"), i18n("dockyard_search_holder"))
	setInputText(arg0.nameSearchInput, "")
	onInputChanged(arg0, arg0.nameSearchInput, function()
		arg0:filter()
	end)

	arg0.modLockFilter = arg0:findTF("mod_flter_lock", arg0.topPanel)
	arg0.modLeveFilter = arg0:findTF("mod_flter_level", arg0.topPanel)
	arg0.energyDescTF = arg0:findTF("energy_desc")
	arg0.energyDescTextTF = arg0.energyDescTF:Find("Text")
	arg0.selectPanel = arg0.blurPanel:Find("select_panel")
	arg0.bottomTipsText = arg0.selectPanel:Find("tip")
	arg0.bottomTipsWithFrame = arg0.selectPanel:Find("tipwithframe")

	setText(arg0.selectPanel:Find("bottom_info/bg_input/selected"), i18n("disassemble_selected") .. ":")

	arg0.awardTF = arg0.selectPanel:Find("bottom_info/bg_award")

	setText(arg0.awardTF:Find("label"), i18n("disassemble_available") .. ":")

	arg0.modAttrsTF = arg0.selectPanel:Find("bottom_info/bg_mod")
	arg0.viewEquipmentBtn = arg0.selectPanel:Find("view_equipments")
	arg0.tipPanel = arg0.blurPanel:Find("TipPanel")

	setActive(arg0.tipPanel, false)

	arg0.worldPanel = arg0.blurPanel:Find("world_port_panel")

	setActive(arg0.worldPanel, arg0.contextData.mode == var0.MODE_WORLD)

	arg0.assultBtn = arg0.blurPanel:Find("adapt/top/assult_btn")
	arg0.stampBtn = arg0.topPanel:Find("stamp")
	arg0.isRemouldOrUpgradeMode = arg0.contextData.mode == var0.MODE_REMOULD or arg0.contextData.mode == var0.MODE_UPGRADE

	setActive(arg0.switchPanel, not arg0.isRemouldOrUpgradeMode)
	setActive(arg0.indexBtn, not arg0.isRemouldOrUpgradeMode)
	setActive(arg0.sortBtn, not arg0.isRemouldOrUpgradeMode)
	setActive(arg0.modLeveFilter, arg0.isRemouldOrUpgradeMode)
	setActive(arg0.modLockFilter, arg0.isRemouldOrUpgradeMode)
	setActive(arg0.assultBtn, arg0.contextData.mode == var0.MODE_GUILD_BOSS)
	switch(arg0.contextData.mode, {
		[var0.MODE_OVERVIEW] = function()
			arg0.selecteEnabled = false
		end,
		[var0.MODE_DESTROY] = function()
			arg0.selecteEnabled = true
			arg0.blacklist = {}
			arg0.destroyResList = UIItemList.New(arg0.awardTF:Find("res_list"), arg0.awardTF:Find("res_list/res"))
		end,
		[var0.MODE_MOD] = function()
			arg0.selecteEnabled = true

			setText(arg0.modAttrsTF:Find("title/Text"), i18n("word_mod_value"))

			arg0.modAttrContainer = arg0.modAttrsTF:Find("attrs")
		end
	}, function()
		arg0.selecteEnabled = true
	end)
	setActive(arg0.selectPanel, arg0.selecteEnabled and arg0.contextData.mode ~= var0.MODE_WORLD)
	setActive(arg0.worldPanel, arg0.contextData.mode == var0.MODE_WORLD)

	local var1 = arg0.contextData.mode == var0.MODE_DESTROY

	setActive(arg0.settingBtn, var1)
	setActive(arg0.selectPanel:Find("quick_select"), var1)

	if arg0.contextData.priorEquipUpShipIDList and arg0.contextData.priorMode then
		setActive(arg0.tipPanel, true)

		local var2 = arg0:findTF("EquipUP", arg0.tipPanel)
		local var3 = arg0:findTF("ShipUP", arg0.tipPanel)

		setText(var2, i18n("fightfail_choiceequip"))
		setText(var3, i18n("fightfail_choicestrengthen"))
		setActive(var2, arg0.contextData.priorMode == var0.PRIOR_MODE_EQUIP_UP)
		setActive(var3, arg0.contextData.priorMode == var0.PRIOR_MODE_SHIP_UP)
	end

	if arg0.contextData.selectFriend then
		arg0.shipContainer = arg0:findTF("main/friend_container/ships"):GetComponent("LScrollRect")
	else
		arg0.shipContainer = arg0:findTF("main/ship_container/ships"):GetComponent("LScrollRect")
	end

	arg0.shipContainer.enabled = true
	arg0.shipContainer.decelerationRate = 0.07

	setActive(arg0:findTF("main/ship_container"), not arg0.contextData.selectFriend)

	function arg0.shipContainer.onInitItem(arg0)
		arg0:onInitItem(arg0)
	end

	function arg0.shipContainer.onUpdateItem(arg0, arg1)
		arg0:onUpdateItem(arg0, arg1)
	end

	function arg0.shipContainer.onReturnItem(arg0, arg1)
		arg0:onReturnItem(arg0, arg1)
	end

	function arg0.shipContainer.onStart()
		arg0:updateSelected()
	end

	arg0.shipLayout = arg0:findTF("main/ship_container/ships")
	arg0.scrollItems = {}

	local var4 = _G[arg0.contextData.preView]

	if var4 then
		arg0.sortIndex = var4.sortIndex or ShipIndexConst.SortLevel
		arg0.selectAsc = var4.selectAsc or false
		arg0.typeIndex = var4.typeIndex or ShipIndexConst.TypeAll
		arg0.campIndex = var4.campIndex or ShipIndexConst.CampAll
		arg0.rarityIndex = var4.rarityIndex or ShipIndexConst.RarityAll
		arg0.extraIndex = var4.extraIndex or ShipIndexConst.ExtraAll
		arg0.commonTag = var4.commonTag or Ship.PREFERENCE_TAG_NONE
	elseif arg0.contextData.sortData then
		local var5 = arg0.contextData.sortData

		arg0.sortIndex = var5.sort or ShipIndexConst.SortLevel
		arg0.selectAsc = var5.Asc or false
		arg0.typeIndex = var5.typeIndex or ShipIndexConst.TypeAll
		arg0.campIndex = var5.campIndex or ShipIndexConst.CampAll
		arg0.rarityIndex = var5.rarityIndex or ShipIndexConst.RarityAll
		arg0.extraIndex = var5.extraIndex or ShipIndexConst.ExtraAll
		arg0.commonTag = var5.commonTag or Ship.PREFERENCE_TAG_NONE
	else
		arg0.selectAsc = DockyardScene.selectAsc or false
		arg0.sortIndex = DockyardScene.sortIndex or ShipIndexConst.SortLevel
		arg0.typeIndex = DockyardScene.typeIndex or ShipIndexConst.TypeAll
		arg0.campIndex = DockyardScene.campIndex or ShipIndexConst.CampAll
		arg0.rarityIndex = DockyardScene.rarityIndex or ShipIndexConst.RarityAll
		arg0.extraIndex = DockyardScene.extraIndex or ShipIndexConst.ExtraAll
		arg0.commonTag = DockyardScene.commonTag or Ship.PREFERENCE_TAG_NONE
	end

	arg0:updateIndexDatas()
	triggerToggle(arg0.preferenceBtn, arg0.commonTag == Ship.PREFERENCE_TAG_COMMON)
	arg0:initIndexPanel()

	arg0.itemDetailType = -1
	arg0.listEmptyTF = arg0:findTF("empty")

	setActive(arg0.listEmptyTF, false)

	arg0.listEmptyTxt = arg0:findTF("Text", arg0.listEmptyTF)

	setText(arg0.listEmptyTxt, i18n("list_empty_tip_dockyardui"))

	if arg0.contextData.mode == var0.MODE_DESTROY then
		arg0.blacklist = {}
		arg0.selectPanel:GetComponent("HorizontalLayoutGroup").padding.right = 50

		setActive(arg0.selectPanel:Find("quick_select"), true)
		setActive(arg0.settingBtn, true)
	else
		arg0.selectPanel:GetComponent("HorizontalLayoutGroup").padding.right = 90

		setActive(arg0.selectPanel:Find("quick_select"), false)
		setActive(arg0.settingBtn, false)
	end

	arg0.destroyPage = ShipDestroyPage.New(arg0._tf, arg0.event)

	arg0.destroyPage:SetCardClickCallBack(function(arg0)
		arg0.blacklist[arg0.shipVO:getGroupId()] = true

		local var0 = table.indexof(arg0.selectedIds, arg0.shipVO.id)

		if var0 and var0 > 0 then
			table.remove(arg0.selectedIds, var0)
		end

		arg0:updateDestroyRes()
		arg0:updateSelected()
	end)
	arg0.destroyPage:SetConfirmCallBack(function()
		local var0 = {}
		local var1, var2 = arg0:checkDestroyGold()

		if not var2 then
			table.insert(var0, function(arg0)
				pg.MsgboxMgr.GetInstance():ShowMsgBox({
					content = i18n("oil_max_tip_title") .. i18n("resource_max_tip_retire_1"),
					onYes = arg0
				})
			end)
		end

		local var3 = underscore.map(arg0.selectedIds, function(arg0)
			return arg0.shipVOsById[arg0]
		end)

		table.insert(var0, function(arg0)
			arg0:checkDestroyShips(var3, arg0)
		end)
		seriesAsync(var0, function()
			arg0:emit(DockyardMediator.ON_DESTROY_SHIPS, arg0.selectedIds)
		end)
	end)

	arg0.destroyConfirmWindow = ShipDestoryConfirmWindow.New(arg0._tf, arg0.event)
end

function var0.isDefaultStatus(arg0)
	return arg0.sortIndex == ShipIndexConst.SortLevel and (not arg0.typeIndex or arg0.typeIndex == ShipIndexConst.TypeAll) and (not arg0.campIndex or arg0.campIndex == ShipIndexConst.CampAll) and (not arg0.rarityIndex or arg0.rarityIndex == ShipIndexConst.RarityAll) and (not arg0.extraIndex or arg0.extraIndex == ShipIndexConst.ExtraAll)
end

function var0.setShipsCount(arg0, arg1, arg2)
	arg0.shipsCount = arg1
	arg0.specialShipCount = arg2
end

function var0.GetCard(arg0, arg1)
	local var0

	if arg0.contextData.selectFriend then
		var0 = DockyardFriend.New(arg1)
	else
		var0 = DockyardShipItem.New(arg1, arg0.contextData.hideTagFlags, arg0.contextData.blockTagFlags)
	end

	return var0
end

function var0.OnClickCard(arg0, arg1)
	if arg1.shipVO then
		if not arg0.selecteEnabled then
			pg.CriMgr.GetInstance():PlaySoundEffect_V3(SFX_UI_CLICK)

			DockyardScene.value = arg0.shipContainer.value

			arg0.onClick(arg1.shipVO, arg0.shipVOs)
		else
			pg.CriMgr.GetInstance():PlaySoundEffect_V3(table.contains(arg0.selectedIds, arg1.shipVO.id) and SFX_UI_CANCEL or SFX_UI_FORMATION_SELECT)
			arg0:selectShip(arg1.shipVO)
		end
	else
		pg.CriMgr.GetInstance():PlaySoundEffect_V3(SFX_UI_CLICK)

		if arg0.callbackQuit then
			arg0.onSelected({}, function()
				arg0:back()
			end)
		elseif not arg1.isLoading then
			arg0.onSelected({})
			arg0:back()
		end
	end
end

function var0.onInitItem(arg0, arg1)
	local var0 = arg0:GetCard(arg1)

	var0:updateDetail(arg0.itemDetailType)

	var0.isLoading = true

	onButton(arg0, var0.go, function()
		arg0:OnClickCard(var0)
	end)

	local var1 = GetOrAddComponent(var0.go, "UILongPressTrigger").onLongPressed

	if arg0.contextData.preView == NewBackYardShipInfoLayer.__cname then
		var1:RemoveAllListeners()
		var1:AddListener(function()
			if var0.shipVO then
				arg0.contextData.selectedIds = arg0.selectedIds

				arg0.onClick(var0.shipVO, underscore.select(arg0.shipVOs, function(arg0)
					return arg0
				end), arg0.contextData)
			end
		end)
	else
		var1:RemoveAllListeners()
	end

	arg0.scrollItems[arg1] = var0

	return var0
end

function var0.showEnergyDesc(arg0, arg1, arg2)
	if LeanTween.isTweening(go(arg0.energyDescTF)) then
		LeanTween.cancel(go(arg0.energyDescTF))

		arg0.energyDescTF.localScale = Vector3.one
	end

	setText(arg0.energyDescTextTF, i18n(arg2))

	arg0.energyDescTF.position = arg1

	setActive(arg0.energyDescTF, true)
	LeanTween.scale(arg0.energyDescTF, Vector3.zero, 0.2):setDelay(1):setFrom(Vector3.one):setOnComplete(System.Action(function()
		arg0.energyDescTF.localScale = Vector3.one

		setActive(arg0.energyDescTF, false)
	end))
end

function var0.onUpdateItem(arg0, arg1, arg2)
	local var0 = arg0.scrollItems[arg2] or arg0:onInitItem(arg2)
	local var1 = arg0.shipVOs[arg1 + 1]

	if arg0.contextData.selectFriend then
		var0:update(var1, arg0.friends)
	else
		var0:update(var1)
	end

	if arg0.contextData.mode == DockyardScene.MODE_WORLD then
		var0:updateWorld()
	end

	local var2 = false

	if var0.shipVO then
		for iter0, iter1 in ipairs(arg0.selectedIds) do
			if var0.shipVO.id == iter1 then
				var2 = true

				break
			end
		end
	end

	var0:updateSelected(var2)
	arg0:updateItemBlackBlock(var0)

	var0.isLoading = false

	var0:updateIntimacyEnergy(arg0.contextData.energyDisplay or arg0.sortIndex == ShipIndexConst.SortEnergy)

	local var3 = (arg0.sortIndex == ShipIndexConst.SortIntimacy or arg0.extraIndex == ShipIndexConst.ExtraMarry) and arg0.contextData.mode ~= DockyardScene.MODE_UPGRADE

	var0:updateIntimacy(var3)
end

function var0.onReturnItem(arg0, arg1, arg2)
	if arg0.exited then
		return
	end

	local var0 = arg0.scrollItems[arg2]

	if var0 then
		var0:clear()
	end
end

function var0.updateIndexDatas(arg0)
	arg0.contextData.indexDatas = arg0.contextData.indexDatas or {}
	arg0.contextData.indexDatas.sortIndex = arg0.sortIndex
	arg0.contextData.indexDatas.typeIndex = arg0.typeIndex
	arg0.contextData.indexDatas.campIndex = arg0.campIndex
	arg0.contextData.indexDatas.rarityIndex = arg0.rarityIndex
	arg0.contextData.indexDatas.extraIndex = arg0.extraIndex
end

function var0.initIndexPanel(arg0)
	onButton(arg0, arg0.indexBtn, function()
		local var0 = {
			indexDatas = Clone(arg0.contextData.indexDatas),
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
			callback = function(arg0)
				arg0.sortIndex = arg0.sortIndex
				arg0.typeIndex = arg0.typeIndex
				arg0.campIndex = arg0.campIndex
				arg0.rarityIndex = arg0.rarityIndex
				arg0.extraIndex = arg0.extraIndex

				arg0:updateIndexDatas()
				arg0:filter()
			end
		}

		arg0:emit(DockyardMediator.OPEN_DOCKYARD_INDEX, var0)
	end, SFX_PANEL)
	onToggle(arg0, arg0.preferenceBtn, function(arg0)
		if arg0 then
			arg0.commonTag = Ship.PREFERENCE_TAG_COMMON
		else
			arg0.commonTag = Ship.PREFERENCE_TAG_NONE
		end

		arg0:filter()
	end)
end

function var0.setShips(arg0, arg1)
	arg0.shipVOsById = arg1
end

function var0.setPlayer(arg0, arg1)
	arg0.player = arg1

	arg0:updateBarInfo()
end

function var0.setFriends(arg0, arg1)
	arg0.friends = {}

	for iter0, iter1 in pairs(arg1) do
		arg0.friends[iter1.id] = iter1
	end
end

function var0.updateBarInfo(arg0)
	setActive(arg0.bottomTipsText, arg0.contextData.leftTopInfo)
	setText(arg0.bottomTipsText, arg0.contextData.leftTopInfo and i18n("dock_yard_left_tips", arg0.contextData.leftTopInfo) or "")
	setActive(arg0.bottomTipsWithFrame, arg0.contextData.leftTopWithFrameInfo)
	setText(arg0.bottomTipsWithFrame:Find("Text"), arg0.contextData.leftTopWithFrameInfo or "")

	if arg0.contextData.mode == var0.MODE_WORLD or arg0.contextData.mode == var0.MODE_GUILD_BOSS or arg0.contextData.mode == var0.MODE_REMOULD then
		setActive(arg0.leftTipsText, false)
	else
		setActive(arg0.leftTipsText, true)
		arg0:updateCapacityDisplay()
	end
end

function var0.updateCapacityDisplay(arg0)
	setActive(arg0.leftTipsText:Find("plus"), not arg0.isCapacityMeta)
	setActive(arg0.leftTipsText:Find("tip"), arg0.isCapacityMeta)
	setActive(arg0.leftTipsText:Find("switch/off"), not arg0.isCapacityMeta)
	setActive(arg0.leftTipsText:Find("switch/on"), arg0.isCapacityMeta)

	if arg0.isCapacityMeta then
		setText(arg0.leftTipsText:Find("label"), i18n("specialshipyard_name"))
		setText(arg0.leftTipsText:Find("Text"), arg0.specialShipCount)
	else
		setText(arg0.leftTipsText:Find("label"), i18n("ship_dockyardScene_capacity"))
		setText(arg0.leftTipsText:Find("Text"), arg0.shipsCount .. "/" .. arg0.player:getMaxShipBag())
	end
end

function var0.initWorldPanel(arg0)
	onButton(arg0, arg0.worldPanel:Find("btn_repair"), function()
		if #arg0.selectedIds > 0 then
			arg0:repairWorldShip(arg0.shipVOsById[arg0.selectedIds[1]])
		end
	end, SFX_PANEL)
	onButton(arg0, arg0.worldPanel:Find("btn_repair_all"), function()
		local var0 = {}
		local var1 = 0

		for iter0, iter1 in pairs(arg0.shipVOsById) do
			local var2 = WorldConst.FetchWorldShip(iter1.id)

			if var2:IsBroken() or not var2:IsHpFull() then
				table.insert(var0, var2.id)

				var1 = var1 + nowWorld():CalcRepairCost(var2)
			end
		end

		if #var0 == 0 then
			pg.TipsMgr.GetInstance():ShowTips(i18n("world_ship_repair_no_need"))
		else
			pg.MsgboxMgr.GetInstance():ShowMsgBox({
				content = i18n("world_ship_repair_all", var1),
				onYes = function()
					arg0:emit(DockyardMediator.ON_SHIP_REPAIR, var0, var1)
				end
			})
		end
	end, SFX_PANEL)
end

function var0.repairWorldShip(arg0, arg1)
	local var0 = WorldConst.FetchWorldShip(arg1.id)
	local var1 = nowWorld():CalcRepairCost(var0)

	if var0:IsBroken() then
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			content = i18n("world_ship_repair_2", arg1:getName(), var1),
			onYes = function()
				arg0:emit(DockyardMediator.ON_SHIP_REPAIR, {
					var0.id
				}, var1)
			end
		})
	elseif not var0:IsHpFull() then
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			content = i18n("world_ship_repair_1", arg1:getName(), var1),
			onYes = function()
				arg0:emit(DockyardMediator.ON_SHIP_REPAIR, {
					var0.id
				}, var1)
			end
		})
	else
		pg.TipsMgr.GetInstance():ShowTips(i18n("world_ship_repair_no_need"))
	end
end

function var0.filter(arg0)
	local var0 = arg0:isDefaultStatus() and "shaixuan_off" or "shaixuan_on"

	GetSpriteFromAtlasAsync("ui/dockyardui_atlas", var0, function(arg0)
		setImageSprite(arg0.indexBtn, arg0, true)
	end)

	if arg0.isRemouldOrUpgradeMode then
		arg0:filterForRemouldAndUpgrade()
	else
		arg0:filterCommon()
	end

	local var1 = 0

	if arg0.contextData.quitTeam then
		var1 = var1 + 1

		table.insert(arg0.shipVOs, var1, false)
	end

	if arg0.contextData.priorEquipUpShipIDList then
		local var2 = {}

		for iter0, iter1 in ipairs(arg0.contextData.priorEquipUpShipIDList) do
			var2[iter1] = true
		end

		for iter2 = #arg0.shipVOs, 1, -1 do
			local var3 = type(arg0.shipVOs[iter2]) == "table" and arg0.shipVOs[iter2].id

			if var2[var3] then
				var2[var3] = table.remove(arg0.shipVOs, iter2)
			end
		end

		for iter3, iter4 in ipairs(arg0.contextData.priorEquipUpShipIDList) do
			local var4 = var2[iter4]

			if type(var4) == "table" then
				var1 = var1 + 1

				table.insert(arg0.shipVOs, var1, var4)
			end
		end
	end

	if var0.MODE_OVERVIEW == arg0.contextData.mode and DockyardScene.value then
		arg0:updateShipCount(DockyardScene.value or 0)

		DockyardScene.value = nil
	else
		arg0:updateShipCount(0)
	end
end

function var0.filterForRemouldAndUpgrade(arg0)
	arg0.shipVOs = {}

	local var0 = arg0.isFilterLockForMod
	local var1 = arg0.isFilterLevelForMod

	local function var2(arg0)
		local var0 = true

		if not var0 and arg0.lockState == Ship.LOCK_STATE_LOCK then
			var0 = false
		end

		if not var1 and arg0.level > 1 then
			var0 = false
		end

		return var0
	end

	for iter0, iter1 in pairs(arg0.shipVOsById) do
		if var2(iter1) then
			table.insert(arg0.shipVOs, iter1)
		end
	end

	table.sort(arg0.shipVOs, CompareFuncs({
		function(arg0)
			return arg0.level
		end,
		function(arg0)
			return arg0:isTestShip() and 1 or 0
		end
	}))
end

function var0.filterCommon(arg0)
	arg0.shipVOs = {}

	local var0 = arg0.sortIndex

	local function var1(arg0)
		if arg0.contextData.mode ~= var0.MODE_GUILD_BOSS then
			return true
		end

		if arg0.isShowAssultShips then
			return true
		end

		if not arg0.user then
			return true
		end

		if arg0.user.id == arg0.player.id then
			return true
		end

		return false
	end

	for iter0, iter1 in pairs(arg0.shipVOsById) do
		if arg0.contextData.blockLock and iter1:GetLockState() == Ship.LOCK_STATE_LOCK then
			-- block empty
		elseif arg0.teamTypeFilter and iter1:getTeamType() ~= arg0.teamTypeFilter then
			-- block empty
		elseif ShipIndexConst.filterByType(iter1, arg0.typeIndex) and ShipIndexConst.filterByCamp(iter1, arg0.campIndex) and ShipIndexConst.filterByRarity(iter1, arg0.rarityIndex) and ShipIndexConst.filterByExtra(iter1, arg0.extraIndex) and (arg0.commonTag == Ship.PREFERENCE_TAG_NONE or arg0.commonTag == iter1:GetPreferenceTag()) and var1(iter1) then
			table.insert(arg0.shipVOs, iter1)
		end
	end

	local var2 = getInputText(arg0.nameSearchInput)

	if var2 and var2 ~= "" then
		arg0.shipVOs = underscore.filter(arg0.shipVOs, function(arg0)
			return arg0:IsMatchKey(var2)
		end)
	end

	local var3, var4 = ShipIndexConst.getSortFuncAndName(var0, arg0.selectAsc)

	if (var0 ~= ShipIndexConst.SortIntimacy and true or false) and not defaultValue((arg0.contextData.hideTagFlags or {}).inFleet, ShipStatus.TAG_HIDE_BASE.inFleet) then
		table.insert(var3, 1, function(arg0)
			return arg0:getFlag("inFleet") and 0 or 1
		end)
	end

	if var3 then
		arg0:SortShips(var3)
	end

	arg0:updateSelected()
	setActive(arg0.sortImgAsc, arg0.selectAsc)
	setActive(arg0.sortImgDesc, not arg0.selectAsc)
	setText(arg0:findTF("Image", arg0.sortBtn), i18n(var4))
end

function var0.SortShips(arg0, arg1)
	if pg.NewGuideMgr.GetInstance():IsBusy() then
		local var0 = {
			101171,
			201211,
			401231,
			301051
		}

		arg1 = {
			function(arg0)
				return table.contains(var0, arg0.configId) and 0 or 1
			end
		}
	elseif arg0.isFormTactics then
		table.insert(arg1, 1, function(arg0)
			return arg0:getNation() == Nation.META and 1 or 0
		end)
		table.insert(arg1, 1, function(arg0)
			return arg0:isFullSkillLevel() and 1 or 0
		end)
	elseif arg0.contextData.mode == var0.MODE_OVERVIEW or arg0.contextData.mode == var0.MODE_SELECT then
		table.insert(arg1, 1, function(arg0)
			return -arg0.activityNpc
		end)
	elseif arg0.contextData.mode == var0.MODE_GUILD_BOSS then
		table.insert(arg1, 1, function(arg0)
			return arg0.guildRecommand and 0 or 1
		end)
	end

	table.sort(arg0.shipVOs, CompareFuncs(arg1))
end

function var0.UpdateGuildViewEquipmentsBtn(arg0)
	setActive(arg0.viewEquipmentBtn, arg0.contextData.mode == var0.MODE_GUILD_BOSS and #arg0.selectedIds > 0)
end

function var0.didEnter(arg0)
	pg.UIMgr.GetInstance():OverlayPanel(arg0.blurPanel)
	setActive(arg0.stampBtn, getProxy(TaskProxy):mingshiTouchFlagEnabled() and arg0.contextData.mode ~= var0.MODE_GUILD_BOSS)
	arg0:UpdateGuildViewEquipmentsBtn()
	onButton(arg0, arg0.stampBtn, function()
		getProxy(TaskProxy):dealMingshiTouchFlag(1)
	end, SFX_CONFIRM)
	onButton(arg0, arg0:findTF("back", arg0.topPanel), function()
		arg0:back()
	end, SFX_CANCEL)
	onButton(arg0, arg0.sortBtn, function()
		arg0.selectAsc = not arg0.selectAsc

		arg0:filter()
	end, SFX_UI_CLICK)

	if arg0.contextData.mode == var0.MODE_GUILD_BOSS then
		arg0.isShowAssultShips = false

		onToggle(arg0, arg0.assultBtn, function(arg0)
			arg0.isShowAssultShips = arg0

			arg0:filter()
		end, SFX_PANEL)
		triggerToggle(arg0.assultBtn, true)

		arg0.guildShipEquipmentsPage = GuildShipEquipmentsPage.New(arg0._tf, arg0.event)

		arg0.guildShipEquipmentsPage:SetCallBack(function()
			arg0:TriggerCard(-1)
		end, function()
			arg0:TriggerCard(1)
		end)
		onButton(arg0, arg0.viewEquipmentBtn, function()
			local var0 = arg0.selectedIds[#arg0.selectedIds]

			if not var0 then
				return
			end

			local var1 = arg0.shipVOsById[var0]
			local var2 = var1.user

			arg0.guildShipEquipmentsPage:ExecuteAction("Show", var1, var2)
		end, SFX_PANEL)
	end

	local var0 = arg0.attrBtn:GetComponent("Button")

	eachChild(var0, function(arg0)
		setActive(arg0, false)
	end)

	arg0.isFormTactics = arg0.contextData.prevPage == "NewNavalTacticsMediator"

	local var1 = arg0:findTF("off", var0):GetComponent("Image")
	local var2 = arg0:findTF("on", var0):GetComponent("Image")

	if arg0.isFormTactics then
		GetImageSpriteFromAtlasAsync("ui/dockyardui_atlas", "skill_off", var1)
		GetImageSpriteFromAtlasAsync("ui/dockyardui_atlas", "skill_on", var2)
	else
		GetImageSpriteFromAtlasAsync("ui/dockyardui_atlas", "attr_off", var1)
		GetImageSpriteFromAtlasAsync("ui/dockyardui_atlas", "attr_on", var2)
	end

	if arg0.isRemouldOrUpgradeMode then
		local var3 = getProxy(SettingsProxy)

		arg0.isFilterLevelForMod = var3:GetDockYardLevelBtnFlag()

		arg0:OnSwitch(arg0.modLeveFilter, arg0.isFilterLevelForMod, function(arg0)
			arg0.isFilterLevelForMod = arg0

			arg0:filter()
		end)

		arg0.isFilterLockForMod = var3:GetDockYardLockBtnFlag()

		arg0:OnSwitch(arg0.modLockFilter, arg0.isFilterLockForMod, function(arg0)
			arg0.isFilterLockForMod = arg0

			arg0:filter()
		end)
	end

	onButton(arg0, var0, function()
		if not arg0.isFormTactics then
			arg0.itemDetailType = (arg0.itemDetailType + 1) % 4
		else
			arg0.itemDetailType = arg0.itemDetailType == DockyardShipItem.DetailType0 and DockyardShipItem.DetailType3 or DockyardShipItem.DetailType0
		end

		setActive(var2, arg0.itemDetailType ~= DockyardShipItem.DetailType0)
		setActive(var1, arg0.itemDetailType == DockyardShipItem.DetailType0)

		var0.targetGraphic = arg0.itemDetailType == DockyardShipItem.DetailType0 and var1 or var2

		arg0:updateItemDetailType()
	end, SFX_PANEL)
	triggerButton(var0)
	onButton(arg0, arg0.selectPanel:Find("cancel_button"), function()
		if arg0.animating then
			return
		end

		if arg0.contextData.mode == var0.MODE_DESTROY then
			if #arg0.selectedIds > 0 then
				arg0:unselecteAllShips()
				arg0:back()
			else
				arg0:back()
			end
		else
			arg0:back()

			return
		end
	end, SFX_CANCEL)
	onButton(arg0, arg0.selectPanel:Find("confirm_button"), function()
		if arg0.animating then
			return
		end

		if arg0.contextData.mode == var0.MODE_DESTROY then
			local var0, var1 = arg0:checkDestroyGold()

			if not var0 or not var1 then
				if not var0 then
					pg.TipsMgr.GetInstance():ShowTips(i18n("gold_max_tip_title") .. i18n("resource_max_tip_retire"))
				elseif not var0 then
					pg.TipsMgr.GetInstance():ShowTips(i18n("oil_max_tip_title") .. i18n("resource_max_tip_retire"))
				end

				return
			end
		end

		if #arg0.selectedIds < arg0.selectedMin then
			if arg0.leastLimitMsg then
				pg.TipsMgr.GetInstance():ShowTips(arg0.leastLimitMsg)
			else
				pg.TipsMgr.GetInstance():ShowTips(i18n("ship_dockyardScene_error_choiseRoleMore", arg0.selectedMin))
			end

			return
		end

		if arg0.contextData.mode == var0.MODE_DESTROY then
			arg0:displayDestroyPanel()
		else
			local var2 = {}

			if arg0.contextData.destroyCheck then
				local var3 = underscore.map(arg0.selectedIds, function(arg0)
					return arg0.shipVOsById[arg0]
				end)

				table.insert(var2, function(arg0)
					arg0:checkDestroyShips(var3, arg0)
				end)
			end

			seriesAsync(var2, function()
				if arg0.confirmSelect then
					arg0.confirmSelect(arg0.selectedIds, function()
						arg0.onSelected(arg0.selectedIds)
						arg0:back()
					end, function()
						arg0:back()
					end)
				elseif arg0.callbackQuit then
					arg0.onSelected(arg0.selectedIds, function()
						arg0:back()
					end)
				else
					arg0.onSelected(arg0.selectedIds)
					arg0:back()
				end
			end)
		end
	end, SFX_CONFIRM)
	onButton(arg0, arg0.selectPanel:Find("quick_select"), function()
		if arg0.animating then
			return
		end

		local var0 = {
			PlayerPrefs.GetInt("QuickSelectRarity1", 3),
			PlayerPrefs.GetInt("QuickSelectRarity2", 4),
			PlayerPrefs.GetInt("QuickSelectRarity3", 2)
		}
		local var1 = 3
		local var2 = {}

		for iter0, iter1 in pairs(var0) do
			if iter1 ~= 0 then
				var2[iter1] = var2[iter1] or var1
				var1 = var1 - 1
			end
		end

		local var3 = getProxy(BayProxy):getShips()
		local var4 = {}
		local var5 = {}

		for iter2, iter3 in pairs(var3) do
			if iter3:isMaxStar() then
				var4[iter3:getGroupId()] = true
			else
				local var6 = iter3:getMaxStar() - iter3:getStar() + 1

				if iter3:GetLockState() == Ship.LOCK_STATE_UNLOCK then
					var6 = var6 + 1
				end

				local var7 = var5[iter3:getGroupId()]

				var5[iter3:getGroupId()] = var7 and var7 < var6 and var7 or var6
			end
		end

		local var8 = _.select(arg0.shipVOs, function(arg0)
			return arg0.configId ~= 100001 and arg0.configId ~= 100011 and arg0:GetLockState() == Ship.LOCK_STATE_UNLOCK and table.contains(var0, arg0:getRarity()) and arg0.level == 1 and not arg0.blacklist[arg0:getGroupId()] and not table.contains(arg0.selectedIds, arg0.id) and not arg0:hasAnyFlag({
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

		if not _.all(var8, function(arg0)
			return arg0.blacklist[arg0:getGroupId()]
		end) then
			var8 = _.select(var8, function(arg0)
				return not arg0.blacklist[arg0:getGroupId()]
			end)
		elseif #arg0.selectedIds > 0 then
			var8 = {}
		end

		table.sort(var8, function(arg0, arg1)
			local var0 = var2[arg0:getRarity()] or 0
			local var1 = var2[arg1:getRarity()] or 0

			if var0 == var1 then
				if arg0:getGroupId() == arg1:getGroupId() then
					return arg0.createTime > arg1.createTime
				end

				return arg0.configId > arg1.configId
			else
				return var1 < var0
			end
		end)

		local var9 = PlayerPrefs.GetString("QuickSelectWhenHasAtLeastOneMaxstar", "KeepNone")
		local var10 = PlayerPrefs.GetString("QuickSelectWithoutMaxstar", "KeepAll")
		local var11 = {}
		local var12 = _.select(var8, function(arg0)
			if var4[arg0:getGroupId()] then
				if var9 == "KeepNone" then
					return true
				elseif var9 == "KeepOne" then
					if not var11[arg0:getGroupId()] then
						var11[arg0:getGroupId()] = true

						return false
					end

					return true
				elseif var9 == "KeepAll" then
					return false
				end
			elseif var10 == "KeepNone" then
				return true
			elseif var10 == "KeepNeeded" then
				if var5[arg0:getGroupId()] > 0 then
					var5[arg0:getGroupId()] = var5[arg0:getGroupId()] - 1

					return false
				end

				return true
			elseif var10 == "KeepAll" then
				return false
			end
		end)
		local var13 = 0
		local var14 = false
		local var15 = false
		local var16 = 0
		local var17 = 0

		for iter4, iter5 in ipairs(arg0.selectedIds) do
			local var18, var19 = arg0.shipVOsById[iter5]:calReturnRes()

			var16 = var16 + var18
			var17 = var17 + var19
		end

		for iter6, iter7 in ipairs(var12) do
			if arg0.selectedMax > 0 and arg0.selectedMax <= #arg0.selectedIds then
				break
			end

			local var20, var21 = iter7:calReturnRes()

			var16 = var16 + var20
			var17 = var17 + var21
			var14 = arg0.player:OilMax(var17)
			var15 = arg0.player:GoldMax(var16)

			if var15 then
				break
			end

			var13 = var13 + 1

			arg0:selectShip(iter7, true)
		end

		if var13 == 0 then
			if var15 then
				if #arg0.selectedIds == 0 then
					pg.TipsMgr.GetInstance():ShowTips(i18n("gold_max_tip_title") .. i18n("resource_max_tip_retire"))
				else
					pg.TipsMgr.GetInstance():ShowTips(i18n("gold_max_tip_title"))
				end
			elseif #arg0.selectedIds > 0 then
				arg0:displayDestroyPanel()
			else
				pg.TipsMgr.GetInstance():ShowTips(i18n("retire_selectzero"))
			end
		elseif var14 then
			pg.MsgboxMgr.GetInstance():ShowMsgBox({
				content = i18n("oil_max_tip_title") .. i18n("resource_max_tip_retire_1"),
				onYes = function()
					arg0:displayDestroyPanel()
				end
			})
		else
			arg0:displayDestroyPanel()
		end
	end, SFX_CONFIRM)

	if not arg0.contextData.selectFriend then
		arg0.shipContainer:GetComponentInChildren(typeof(GridLayoutGroup)).constraintCount = 7
	end

	arg0:filter()
	arg0:updateBarInfo()

	if arg0.contextData.mode == var0.MODE_WORLD then
		arg0:initWorldPanel()
	elseif arg0.contextData.mode == var0.MODE_DESTROY and not LOCK_DESTROY_GUIDE then
		pg.SystemGuideMgr.GetInstance():Play(arg0)
	end

	setAnchoredPosition(arg0.topPanel, {
		y = arg0.topPanel.rect.height
	})
	setAnchoredPosition(arg0.selectPanel, {
		y = -1 * arg0.selectPanel.rect.height
	})
	onNextTick(function()
		if arg0.exited then
			return
		end

		arg0:uiStartAnimating()
	end)

	if arg0.contextData.selectShipId then
		arg0.selectedIds = {}

		table.insert(arg0.selectedIds, arg0.contextData.selectShipId)
		arg0:updateSelected()
	end

	arg0.bulinTip = AprilFoolBulinSubView.ShowAprilFoolBulin(arg0)

	onButton(arg0, arg0.settingBtn, function()
		arg0.settingPanel:Load()
		arg0.settingPanel:ActionInvoke("Show")
	end)
	pg.SystemGuideMgr.GetInstance():Play(arg0)
end

function var0.TriggerCard(arg0, arg1)
	local var0 = arg0.selectedIds[1]

	if not var0 then
		return
	end

	local var1

	for iter0, iter1 in ipairs(arg0.shipVOs) do
		if iter1 and iter1.id == var0 then
			var1 = iter0

			break
		end
	end

	if not var1 then
		return
	end

	local var2 = var1
	local var3

	local function var4()
		var2 = var2 + arg1

		local var0 = arg0.shipVOs[var2]

		if not var0 or arg0.checkShip(var0) then
			return var0
		else
			return var4()
		end
	end

	local var5 = var4()

	if not var5 then
		return
	end

	local function var6()
		local var0

		for iter0, iter1 in pairs(arg0.scrollItems) do
			if iter1.shipVO and iter1.go.name ~= "-1" and iter1.shipVO.id == var5.id then
				var0 = iter1

				break
			end
		end

		return var0
	end

	local var7 = var6()

	if var7 then
		local var8 = getBounds(arg0:findTF("main/ship_container"))
		local var9 = getBounds(var7.tr)

		if not var8:Intersects(var9) then
			local var10 = arg1 * (arg0.shipContainer:HeadIndexToValue(7) - arg0.shipContainer:HeadIndexToValue(1))
			local var11 = arg0.shipContainer.value + var10

			arg0.shipContainer:SetNormalizedPosition(var11, 1)
		end
	end

	if not var7 then
		local var12 = (math.ceil(var2 / 7) - math.ceil(var1 / 7)) * (arg0.shipContainer:HeadIndexToValue(21) - arg0.shipContainer:HeadIndexToValue(1))
		local var13 = arg0.shipContainer.value + var12

		arg0.shipContainer:SetNormalizedPosition(var13, 1)

		var7 = var6()
	end

	if var7 then
		triggerButton(var7.tr)

		local var14 = arg0.shipVOsById[var7.shipVO.id]

		arg0.guildShipEquipmentsPage:Refresh(var14, var14.user)
	end
end

function var0.OnSwitch(arg0, arg1, arg2, arg3)
	local function var0()
		setActive(arg1:Find("off"), not arg2)
		setActive(arg1:Find("on"), arg2)
	end

	onButton(arg0, arg1, function()
		arg2 = not arg2

		if arg3 then
			arg3(arg2)
		end

		var0()
	end, SFX_PANEL)
	var0()
end

function var0.onBackPressed(arg0)
	if arg0.destroyConfirmWindow:isShowing() then
		arg0.destroyConfirmWindow:Hide()

		return
	end

	if arg0.destroyPage:isShowing() then
		arg0.destroyPage:Hide()

		return
	end

	if arg0.settingPanel:isShowing() then
		arg0.settingPanel:Hide()

		return
	end

	pg.CriMgr.GetInstance():PlaySoundEffect_V3(SFX_CANCEL)
	arg0:back()
end

function var0.updateShipStatusById(arg0, arg1)
	for iter0, iter1 in pairs(arg0.scrollItems) do
		if iter1.shipVO and iter1.shipVO.id == arg1 then
			iter1:flush(arg0.selectedIds)

			if arg0.contextData.mode == DockyardScene.MODE_WORLD then
				iter1:updateWorld()
			end
		end
	end
end

function var0.checkDestroyGold(arg0, arg1)
	local var0 = 0
	local var1 = 0

	for iter0, iter1 in ipairs(arg0.selectedIds) do
		local var2, var3 = arg0.shipVOsById[iter1]:calReturnRes()

		var0 = var0 + var2
		var1 = var1 + var3
	end

	if arg1 then
		local var4, var5 = arg1:calReturnRes()

		var0 = var0 + var4
		var1 = var1 + var5
	end

	local var6 = arg0.player:OilMax(var1)

	if arg0.player:GoldMax(var0) then
		return false, not var6
	end

	return true, not var6
end

function var0.selectShip(arg0, arg1, arg2)
	local var0 = false
	local var1

	for iter0, iter1 in ipairs(arg0.selectedIds) do
		if iter1 == arg1.id then
			var0 = true
			var1 = iter0

			break
		end
	end

	if not var0 then
		local var2, var3 = arg0.checkShip(arg1, function()
			if not arg0.exited then
				arg0:selectShip(arg1)
			end
		end, arg0.selectedMax == 1 and {} or arg0.selectedIds)

		if not var2 then
			if var3 then
				pg.TipsMgr.GetInstance():ShowTips(var3)
			end

			return
		end

		if arg0.selectedMax == 1 then
			local var4 = arg0.selectedIds[1]

			arg0.selectedIds[1] = arg1.id
		elseif arg0.selectedMax == 0 or #arg0.selectedIds < arg0.selectedMax then
			table.insert(arg0.selectedIds, arg1.id)
			arg0:updateBlackBlocks(arg1)
		else
			pg.TipsMgr.GetInstance():ShowTips(i18n("ship_dockyardScene_error_choiseRoleLess", arg0.selectedMax))

			return
		end
	else
		local var5, var6 = arg0.onCancelShip(arg1, function()
			if not arg0.exited then
				arg0:selectShip(arg1)
			end
		end, arg0.selectedIds)

		if not var5 then
			if var6 then
				pg.TipsMgr.GetInstance():ShowTips(var6)
			end

			return
		end

		table.remove(arg0.selectedIds, var1)

		if arg0.selectedMax ~= 1 then
			arg0:updateBlackBlocks(arg1)
		end
	end

	arg0:updateSelected()

	if arg0.contextData.mode == var0.MODE_DESTROY then
		arg0:updateDestroyRes()
	elseif arg0.contextData.mode == var0.MODE_MOD then
		arg0:updateModAttr()
	end

	arg0:UpdateGuildViewEquipmentsBtn()
end

function var0.updateBlackBlocks(arg0, arg1)
	if not arg0.contextData.useBlackBlock or not arg1 then
		return
	end

	for iter0, iter1 in pairs(arg0.scrollItems) do
		arg0:updateItemBlackBlock(iter1)
	end
end

function var0.updateItemBlackBlock(arg0, arg1)
	if arg0.contextData.useBlackBlock then
		if arg0.selectedMax == 1 then
			arg1:updateBlackBlock(arg0.contextData.otherSelectedIds)
		else
			arg1:updateBlackBlock(arg0.selectedIds)
		end
	else
		arg1:updateBlackBlock()
	end
end

function var0.unselecteAllShips(arg0)
	arg0.selectedIds = {}

	arg0:updateSelected()
	arg0:updateDestroyRes()
end

function var0.updateSelected(arg0)
	for iter0, iter1 in pairs(arg0.scrollItems) do
		if iter1.shipVO then
			local var0 = false

			for iter2, iter3 in ipairs(arg0.selectedIds) do
				if iter1.shipVO.id == iter3 then
					var0 = true

					break
				end
			end

			iter1:updateSelected(var0)
		end
	end

	if arg0.selectedMax == 0 then
		setText(arg0.selectPanel:Find("bottom_info/bg_input/count"), #arg0.selectedIds)
	else
		local var1 = #arg0.selectedIds

		if arg0.contextData.mode ~= var0.MODE_DESTROY or #arg0.selectedIds == 0 then
			var1 = setColorStr(#arg0.selectedIds, COLOR_WHITE)
		elseif arg0.contextData.mode == var0.MODE_DESTROY then
			var1 = #arg0.selectedIds == 10 and setColorStr(#arg0.selectedIds, COLOR_RED) or setColorStr(#arg0.selectedIds, COLOR_GREEN)
		end

		setText(arg0.selectPanel:Find("bottom_info/bg_input/count"), var1 .. "/" .. arg0.selectedMax)
	end

	if #arg0.selectedIds < arg0.selectedMin then
		setActive(arg0.selectPanel:Find("confirm_button/mask"), true)
	else
		setActive(arg0.selectPanel:Find("confirm_button/mask"), false)
	end

	if arg0.contextData.mode == var0.MODE_MOD then
		arg0:updateModAttr()
	end
end

function var0.updateItemDetailType(arg0)
	for iter0, iter1 in pairs(arg0.scrollItems) do
		iter1:updateDetail(arg0.itemDetailType)
	end

	arg0.shipLayout.anchoredPosition = arg0.shipLayout.anchoredPosition + Vector3(0, 0.001, 0)
end

function var0.closeDestroyMode(arg0)
	setActive(arg0.awardTF, false)
	setActive(arg0.bottomTipsText, true)
end

function var0.updateDestroyRes(arg0)
	if table.getCount(arg0.selectedIds) == 0 then
		arg0:closeDestroyMode()
	else
		setActive(arg0.awardTF, true)
		setActive(arg0.bottomTipsText, false)
	end

	local var0 = _.map(arg0.selectedIds, function(arg0)
		return arg0.shipVOsById[arg0]
	end)
	local var1, var2, var3 = ShipCalcHelper.CalcDestoryRes(var0)
	local var4 = var2 == 0

	if arg0.destroyResList then
		local var5 = (var4 and 1 or 2) + #var3

		arg0.destroyResList:make(function(arg0, arg1, arg2)
			if arg0 == UIItemList.EventUpdate then
				local var0 = ""
				local var1 = 0

				if arg1 == 0 then
					var0, var1 = "Props/gold", var1
				elseif arg1 == 1 then
					if not var4 then
						var0, var1 = "Props/oil", var2
					else
						local var2 = var3[1]

						var0, var1 = Item.getConfigData(var2.id).icon, var2.count
					end
				elseif arg1 > 1 then
					local var3 = var4 and var3[arg1] or var3[arg1 - 1]

					var0, var1 = Item.getConfigData(var3.id).icon, var3.count
				end

				GetImageSpriteFromAtlasAsync(var0, "", arg2:Find("icon"))
				setText(arg2:Find("Text"), "X" .. var1)
			end
		end)
		arg0.destroyResList:align(var5)
	end

	if arg0.destroyPage and arg0.destroyPage:GetLoaded() and arg0.destroyPage:isShowing() then
		arg0.destroyPage:RefreshRes()
	end
end

function var0.setModShip(arg0, arg1)
	arg0.modShip = arg1
end

function var0.updateModAttr(arg0)
	if table.getCount(arg0.selectedIds) == 0 then
		arg0:closeModAttr()
	else
		setActive(arg0.modAttrsTF, true)
		setActive(arg0.bottomTipsText, false)
	end

	local var0 = arg0.contextData.ignoredIds[1]
	local var1 = {}

	for iter0, iter1 in ipairs(arg0.selectedIds) do
		table.insert(var1, arg0.shipVOsById[iter1])
	end

	local var2 = ShipModLayer.getModExpAdditions(arg0.modShip, var1)

	for iter2, iter3 in pairs(ShipModAttr.ID_TO_ATTR) do
		if iter2 ~= ShipModLayer.IGNORE_ID then
			local var3 = arg0.modAttrContainer:Find("attr_" .. iter2)

			setText(var3:Find("value"), var2[iter3])
			setText(var3:Find("name"), ShipModAttr.id2Name(iter2))
		end
	end
end

function var0.closeModAttr(arg0)
	setActive(arg0.modAttrsTF, false)
	setActive(arg0.bottomTipsText, true)
end

function var0.removeShip(arg0, arg1)
	for iter0, iter1 in ipairs(arg0.selectedIds) do
		if iter1 == arg1 then
			table.remove(arg0.selectedIds, iter0)

			break
		end
	end

	for iter2 = #arg0.shipVOs, 1, -1 do
		if arg0.shipVOs[iter2].id == arg1 then
			table.remove(arg0.shipVOs, iter2)

			break
		end
	end

	arg0.shipVOsById[arg1] = nil
end

function var0.updateShipCount(arg0, arg1)
	arg0.shipContainer:SetTotalCount(#arg0.shipVOs, defaultValue(arg1, -1))
	setActive(arg0.listEmptyTF, #arg0.shipVOs <= 0)
end

function var0.ClearShipsBlackBlock(arg0)
	if not arg0.shipVOsById then
		return
	end

	for iter0, iter1 in pairs(arg0.shipVOsById) do
		iter1.blackBlock = false
	end
end

function var0.willExit(arg0)
	arg0:closeDestroyMode()
	arg0:closeModAttr()
	arg0:ClearShipsBlackBlock()

	if arg0.guildShipEquipmentsPage then
		arg0.guildShipEquipmentsPage:Destroy()
	end

	if arg0.settingPanel then
		arg0.settingPanel:Destroy()
	end

	if arg0.destroyPage then
		arg0.destroyPage:Destroy()
	end

	if arg0.destroyConfirmWindow then
		arg0.destroyConfirmWindow:Destroy()
	end

	if arg0.contextData.mode == var0.MODE_MOD then
		-- block empty
	elseif not arg0.contextData.sortData then
		if _G[arg0.contextData.preView] then
			_G[arg0.contextData.preView].sortIndex = arg0.sortIndex
			_G[arg0.contextData.preView].selectAsc = arg0.selectAsc
			_G[arg0.contextData.preView].typeIndex = arg0.typeIndex
			_G[arg0.contextData.preView].campIndex = arg0.campIndex
			_G[arg0.contextData.preView].rarityIndex = arg0.rarityIndex
			_G[arg0.contextData.preView].extraIndex = arg0.extraIndex
			_G[arg0.contextData.preView].commonTag = arg0.commonTag
		else
			DockyardScene.sortIndex = arg0.sortIndex
			DockyardScene.selectAsc = arg0.selectAsc
			DockyardScene.typeIndex = arg0.typeIndex
			DockyardScene.campIndex = arg0.campIndex
			DockyardScene.rarityIndex = arg0.rarityIndex
			DockyardScene.extraIndex = arg0.extraIndex
			DockyardScene.commonTag = arg0.commonTag
		end
	end

	arg0.shipContainer.enabled = false

	for iter0, iter1 in pairs(arg0.scrollItems) do
		iter1:clear()
		GetOrAddComponent(iter1.go, "UILongPressTrigger").onLongPressed:RemoveAllListeners()
	end

	if LeanTween.isTweening(go(arg0.energyDescTF)) then
		setActive(arg0.energyDescTF, false)
		LeanTween.cancel(go(arg0.energyDescTF))
	end

	arg0:cancelAnimating()

	if arg0.isRemouldOrUpgradeMode then
		local var0 = getProxy(SettingsProxy)

		var0:SetDockYardLockBtnFlag(arg0.isFilterLockForMod)
		var0:SetDockYardLevelBtnFlag(arg0.isFilterLevelForMod)
	end

	if arg0.bulinTip then
		arg0.bulinTip:Destroy()

		arg0.bulinTip = nil
	end

	pg.UIMgr.GetInstance():UnOverlayPanel(arg0.blurPanel, arg0._tf)
end

function var0.uiStartAnimating(arg0)
	local var0 = arg0:findTF("back", arg0.topPanel)
	local var1 = 0
	local var2 = 0.3

	if isActive(arg0.selectPanel) then
		shiftPanel(arg0.selectPanel, nil, 0, var2, var1, true, true)
	end
end

function var0.uiExitAnimating(arg0)
	if arg0.contextData.mode == var0.MODE_OVERVIEW then
		-- block empty
	else
		local var0 = 0
		local var1 = 0.3

		shiftPanel(arg0.selectPanel, nil, -1 * arg0.selectPanel.rect.height, var1, var0, true, true)
	end
end

function var0.back(arg0)
	if arg0.exited then
		return
	end

	arg0:closeView()
end

function var0.cancelAnimating(arg0)
	if LeanTween.isTweening(go(arg0.topPanel)) then
		LeanTween.cancel(go(arg0.topPanel))
	end

	if LeanTween.isTweening(go(arg0.selectPanel)) then
		LeanTween.cancel(go(arg0.selectPanel))
	end

	if arg0.tweens then
		cancelTweens(arg0.tweens)
	end
end

function var0.quickExitFunc(arg0)
	seriesAsync({
		function(arg0)
			if arg0.contextData.onQuickHome then
				arg0.contextData.onQuickHome(arg0)
			else
				arg0()
			end
		end,
		function(arg0)
			arg0:emit(var0.ON_HOME)
		end
	})
end

function var0.displayDestroyPanel(arg0)
	arg0.destroyPage:ExecuteAction("Show")
	arg0.destroyPage:ActionInvoke("Refresh", arg0.selectedIds, arg0.shipVOsById)
end

function var0.closeDestroyPanel(arg0)
	if arg0.destroyPage:isShowing() then
		arg0.destroyPage:Hide()
	end
end

function var0.checkDestroyShips(arg0, arg1, arg2)
	local var0 = {}
	local var1, var2 = ShipCalcHelper.GetEliteAndHightLevelShips(arg1)

	if #var1 > 0 or #var2 > 0 then
		table.insert(var0, function(arg0)
			local var0 = false

			if arg0.contextData.mode == var0.MODE_DESTROY then
				var0 = ({
					ShipCalcHelper.CalcDestoryRes(arg1)
				})[4]
			end

			arg0.destroyConfirmWindow:ExecuteAction("Show", var1, var2, var0, arg0)
		end)
	end

	local var3 = underscore.filter(arg1, function(arg0)
		return arg0:getFlag("inElite")
	end)

	if #var3 > 0 then
		table.insert(var0, function(arg0)
			arg0.destroyConfirmWindow:ExecuteAction("ShowEliteTag", var3, arg0)
		end)
	end

	seriesAsync(var0, arg2)
end

return var0
