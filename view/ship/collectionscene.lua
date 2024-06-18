local var0_0 = class("CollectionScene", import("..base.BaseUI"))

var0_0.SHOW_DETAIL = "event show detail"
var0_0.GET_AWARD = "event get award"
var0_0.ACTIVITY_OP = "event activity op"
var0_0.BEGIN_STAGE = "event begin state"
var0_0.ON_INDEX = "event on index"
var0_0.UPDATE_RED_POINT = "CollectionScene:UPDATE_RED_POINT"
var0_0.ShipOrderAsc = false
var0_0.ShipIndex = {
	typeIndex = ShipIndexConst.TypeAll,
	campIndex = ShipIndexConst.CampAll,
	rarityIndex = ShipIndexConst.RarityAll,
	collExtraIndex = ShipIndexConst.CollExtraAll
}
var0_0.ShipIndexData = {
	customPanels = {
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
		collExtraIndex = {
			blueSeleted = true,
			mode = CustomIndexLayer.Mode.AND,
			options = ShipIndexConst.CollExtraIndexs,
			names = ShipIndexConst.CollExtraNames
		}
	},
	groupList = {
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
				"collExtraIndex"
			}
		}
	}
}
var0_0.SHIPCOLLECTION_INDEX = 1
var0_0.MANGA_INDEX = 4
var0_0.GALLERY_INDEX = 5
var0_0.MUSIC_INDEX = 6

function var0_0.isDefaultStatus(arg0_1)
	return var0_0.ShipIndex.typeIndex == ShipIndexConst.TypeAll and (var0_0.ShipIndex.campIndex == ShipIndexConst.CampAll or arg0_1.contextData.toggle == 1 and arg0_1.contextData.cardToggle == 2) and var0_0.ShipIndex.rarityIndex == ShipIndexConst.RarityAll and var0_0.ShipIndex.collExtraIndex == ShipIndexConst.CollExtraAll
end

function var0_0.getUIName(arg0_2)
	return "CollectionUI"
end

function var0_0.setShipGroups(arg0_3, arg1_3)
	arg0_3.shipGroups = arg1_3
end

function var0_0.setAwards(arg0_4, arg1_4)
	arg0_4.awards = arg1_4
end

function var0_0.setCollectionRate(arg0_5, arg1_5, arg2_5, arg3_5)
	arg0_5.rate = arg1_5
	arg0_5.count = arg2_5
	arg0_5.totalCount = arg3_5
end

function var0_0.setLinkCollectionCount(arg0_6, arg1_6)
	arg0_6.linkCount = arg1_6
end

function var0_0.setPlayer(arg0_7, arg1_7)
	arg0_7.player = arg1_7
end

function var0_0.setProposeList(arg0_8, arg1_8)
	arg0_8.proposeList = arg1_8
end

function var0_0.init(arg0_9)
	arg0_9:initEvents()

	arg0_9.blurPanel = arg0_9:findTF("blur_panel")
	arg0_9.top = arg0_9:findTF("blur_panel/adapt/top")
	arg0_9.leftPanel = arg0_9:findTF("blur_panel/adapt/left_length")
	arg0_9.UIMgr = pg.UIMgr.GetInstance()
	arg0_9.backBtn = findTF(arg0_9.top, "back_btn")
	arg0_9.contextData.toggle = arg0_9.contextData.toggle or 2
	arg0_9.toggles = {
		arg0_9:findTF("frame/tagRoot/card", arg0_9.leftPanel),
		arg0_9:findTF("frame/tagRoot/display", arg0_9.leftPanel),
		arg0_9:findTF("frame/tagRoot/trans", arg0_9.leftPanel),
		arg0_9:findTF("frame/tagRoot/manga", arg0_9.leftPanel),
		arg0_9:findTF("frame/tagRoot/gallery", arg0_9.leftPanel),
		arg0_9:findTF("frame/tagRoot/music", arg0_9.leftPanel)
	}
	arg0_9.toggleUpdates = {
		"initCardPanel",
		"initDisplayPanel",
		"initCardPanel",
		"initMangaPanel",
		"initGalleryPanel",
		"initMusicPanel"
	}
	arg0_9.cardList = arg0_9:findTF("main/list_card/scroll"):GetComponent("LScrollRect")

	function arg0_9.cardList.onInitItem(arg0_10)
		arg0_9:onInitCard(arg0_10)
	end

	function arg0_9.cardList.onUpdateItem(arg0_11, arg1_11)
		arg0_9:onUpdateCard(arg0_11, arg1_11)
	end

	function arg0_9.cardList.onReturnItem(arg0_12, arg1_12)
		arg0_9:onReturnCard(arg0_12, arg1_12)
	end

	arg0_9.cardItems = {}
	arg0_9.cardContent = arg0_9:findTF("ships", arg0_9.cardList)
	arg0_9.contextData.cardToggle = arg0_9.contextData.cardToggle or 1
	arg0_9.cardToggleGroup = arg0_9:findTF("main/list_card/types")
	arg0_9.cardToggles = {
		arg0_9:findTF("char", arg0_9.cardToggleGroup),
		arg0_9:findTF("link", arg0_9.cardToggleGroup),
		arg0_9:findTF("blueprint", arg0_9.cardToggleGroup),
		arg0_9:findTF("meta", arg0_9.cardToggleGroup)
	}
	arg0_9.cardList.decelerationRate = 0.07
	arg0_9.bonusPanel = arg0_9:findTF("bonus_panel")
	arg0_9.charTpl = arg0_9:getTpl("chartpl")
	arg0_9.tip = arg0_9:findTF("tip", arg0_9.toggles[2])

	local var0_9 = pg.storeup_data_template

	arg0_9.favoriteVOs = {}

	for iter0_9, iter1_9 in ipairs(var0_9.all) do
		local var1_9 = Favorite.New({
			id = iter0_9
		})

		table.insert(arg0_9.favoriteVOs, var1_9)
	end

	arg0_9.memoryGroups = _.map(pg.memory_group.all, function(arg0_13)
		return pg.memory_group[arg0_13]
	end)
	arg0_9.memories = nil
	arg0_9.memoryList = arg0_9:findTF("main/list_memory"):GetComponent("LScrollRect")

	function arg0_9.memoryList.onInitItem(arg0_14)
		arg0_9:onInitMemory(arg0_14)
	end

	function arg0_9.memoryList.onUpdateItem(arg0_15, arg1_15)
		arg0_9:onUpdateMemory(arg0_15, arg1_15)
	end

	function arg0_9.memoryList.onReturnItem(arg0_16, arg1_16)
		arg0_9:onReturnMemory(arg0_16, arg1_16)
	end

	arg0_9.memoryViewport = arg0_9:findTF("main/list_memory/viewport")
	arg0_9.memoriesGrid = arg0_9:findTF("main/list_memory/viewport/memories"):GetComponent(typeof(GridLayoutGroup))
	arg0_9.memoryItems = {}

	local var2_9 = arg0_9:findTF("memory", arg0_9.memoryList)

	arg0_9.memoryMask = arg0_9:findTF("blur_panel/adapt/story_mask")

	setActive(var2_9, false)
	setActive(arg0_9.memoryMask, false)

	arg0_9.memoryTogGroup = arg0_9:findTF("memory", arg0_9.top)

	setActive(arg0_9.memoryTogGroup, false)

	arg0_9.memoryToggles = {
		arg0_9:findTF("memory/0", arg0_9.top),
		arg0_9:findTF("memory/1", arg0_9.top),
		arg0_9:findTF("memory/2", arg0_9.top),
		arg0_9:findTF("memory/3", arg0_9.top)
	}
	arg0_9.memoryFilterIndex = {
		true,
		true,
		true
	}
	arg0_9.galleryPanelContainer = arg0_9:findTF("main/GalleryContainer")
	arg0_9.musicPanelContainer = arg0_9:findTF("main/MusicContainer")
	arg0_9.mangaPanelContainer = arg0_9:findTF("main/MangaContainer")

	arg0_9:initIndexPanel()
end

function var0_0.didEnter(arg0_17)
	onButton(arg0_17, arg0_17.backBtn, function()
		arg0_17.contextData.cardScrollValue = 0

		arg0_17:emit(var0_0.ON_BACK)
	end, SFX_CANCEL)

	arg0_17.helpBtn = arg0_17:findTF("help_btn", arg0_17.leftPanel)

	onButton(arg0_17, arg0_17.helpBtn, function()
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_HELP,
			helps = pg.gametip.collection_help.tip,
			weight = LayerWeightConst.THIRD_LAYER
		})
	end, SFX_PANEL)

	local var0_17 = arg0_17:findTF("stamp", arg0_17.top)

	setActive(var0_17, getProxy(TaskProxy):mingshiTouchFlagEnabled())
	onButton(arg0_17, var0_17, function()
		getProxy(TaskProxy):dealMingshiTouchFlag(8)
	end, SFX_CONFIRM)

	for iter0_17, iter1_17 in ipairs(arg0_17.toggles) do
		if PLATFORM_CODE == PLATFORM_CH and (iter0_17 == 1 or iter0_17 == 3) and LOCK_COLLECTION then
			setActive(iter1_17, false)
		else
			onToggle(arg0_17, iter1_17, function(arg0_21)
				if arg0_21 then
					if arg0_17.contextData.toggle ~= iter0_17 then
						if arg0_17.contextData.toggle == var0_0.SHIPCOLLECTION_INDEX then
							setActive(arg0_17.helpBtn, false)

							if arg0_17.bulinTip then
								arg0_17.bulinTip.buffer:Hide()
							end

							if arg0_17.contextData.cardToggle == 1 then
								arg0_17.contextData.cardScrollValue = arg0_17.cardList.value
							end
						end

						arg0_17.contextData.toggle = iter0_17

						if arg0_17.toggleUpdates[iter0_17] then
							arg0_17[arg0_17.toggleUpdates[iter0_17]](arg0_17)
							arg0_17:calFavoriteRate()
						end
					end

					if iter0_17 == var0_0.SHIPCOLLECTION_INDEX then
						setActive(arg0_17.helpBtn, true)

						local var0_21 = getProxy(SettingsProxy)

						if not var0_21:IsShowCollectionHelp() then
							triggerButton(arg0_17.helpBtn)
							var0_21:SetCollectionHelpFlag(true)
						end

						if arg0_17.bulinTip then
							arg0_17.bulinTip.buffer:Show()
						else
							arg0_17.bulinTip = AprilFoolBulinSubView.ShowAprilFoolBulin(arg0_17, arg0_17:findTF("main"))
						end
					end

					if iter0_17 ~= var0_0.MUSIC_INDEX then
						if arg0_17.musicView and arg0_17.musicView:CheckState(BaseSubView.STATES.INITED) then
							arg0_17.musicView:tryPauseMusic()
							arg0_17.musicView:closeSongListPanel()
						end

						pg.BgmMgr.GetInstance():ContinuePlay()
					elseif iter0_17 == var0_0.MUSIC_INDEX then
						pg.BgmMgr.GetInstance():StopPlay()

						if arg0_17.musicView and arg0_17.musicView:CheckState(BaseSubView.STATES.INITED) then
							arg0_17.musicView:tryPlayMusic()
						end
					end

					if iter0_17 ~= var0_0.GALLERY_INDEX and arg0_17.galleryView and arg0_17.galleryView:CheckState(BaseSubView.STATES.INITED) then
						arg0_17.galleryView:closePicPanel()
					end
				end
			end, SFX_UI_TAG)
		end
	end

	for iter2_17, iter3_17 in ipairs(arg0_17.memoryToggles) do
		onToggle(arg0_17, iter3_17, function(arg0_22)
			if arg0_22 then
				if iter2_17 == 1 then
					arg0_17.memoryFilterIndex = {
						true,
						true,
						true
					}
				else
					for iter0_22 in ipairs(arg0_17.memoryFilterIndex) do
						arg0_17.memoryFilterIndex[iter0_22] = iter2_17 - 1 == iter0_22
					end
				end

				arg0_17:memoryFilter()
			end
		end, SFX_UI_TAG)
	end

	local var1_17 = arg0_17.contextData.toggle

	arg0_17.contextData.toggle = -1

	triggerToggle(arg0_17.toggles[var1_17], true)

	local var2_17 = arg0_17.contextData.memoryGroup

	if var2_17 and pg.memory_group[var2_17] then
		arg0_17:showSubMemories(pg.memory_group[var2_17])
	else
		triggerToggle(arg0_17.memoryToggles[1], true)
	end

	for iter4_17, iter5_17 in ipairs(arg0_17.cardToggles) do
		triggerToggle(iter5_17, arg0_17.contextData.cardToggle == iter4_17)
		onToggle(arg0_17, iter5_17, function(arg0_23)
			if arg0_23 and arg0_17.contextData.cardToggle ~= iter4_17 then
				if arg0_17.contextData.cardToggle == 1 then
					arg0_17.contextData.cardScrollValue = arg0_17.cardList.value
				end

				arg0_17.contextData.cardToggle = iter4_17

				arg0_17:initCardPanel()
				arg0_17:calFavoriteRate()
			end
		end)
	end

	arg0_17:calFavoriteRate()
	pg.UIMgr.GetInstance():OverlayPanelPB(arg0_17.blurPanel, {
		groupName = LayerWeightConst.GROUP_COLLECTION
	})
	onButton(arg0_17, arg0_17.bonusPanel, function()
		arg0_17:closeBonus()
	end, SFX_PANEL)
end

function var0_0.updateCollectNotices(arg0_25, arg1_25)
	setActive(arg0_25.tip, arg1_25)
	setActive(arg0_25:findTF("tip", arg0_25.toggles[var0_0.GALLERY_INDEX]), getProxy(AppreciateProxy):isGalleryHaveNewRes())
	setActive(arg0_25:findTF("tip", arg0_25.toggles[var0_0.MUSIC_INDEX]), getProxy(AppreciateProxy):isMusicHaveNewRes())
	setActive(arg0_25:findTF("tip", arg0_25.toggles[var0_0.MANGA_INDEX]), getProxy(AppreciateProxy):isMangaHaveNewRes())
end

function var0_0.calFavoriteRate(arg0_26)
	local var0_26 = arg0_26.contextData.toggle == 1 and arg0_26.contextData.cardToggle == 2

	setActive(arg0_26:findTF("total/char", arg0_26.top), not var0_26)
	setActive(arg0_26:findTF("total/link", arg0_26.top), var0_26)
	setText(arg0_26:findTF("total/char/rate/Text", arg0_26.top), arg0_26.rate * 100 .. "%")
	setText(arg0_26:findTF("total/char/count/Text", arg0_26.top), arg0_26.count .. "/" .. arg0_26.totalCount)
	setText(arg0_26:findTF("total/link/count/Text", arg0_26.top), arg0_26.linkCount)
end

function var0_0.initCardPanel(arg0_27)
	local var0_27 = arg0_27:isDefaultStatus() and "shaixuan_off" or "shaixuan_on"

	GetSpriteFromAtlasAsync("ui/share/index_atlas", var0_27, function(arg0_28)
		setImageSprite(arg0_27.indexBtn, arg0_28, true)
	end)

	if arg0_27.contextData.toggle == 1 then
		setActive(arg0_27.cardToggleGroup, true)
		arg0_27:cardFilter()
	elseif arg0_27.contextData.toggle == 3 then
		setActive(arg0_27.cardToggleGroup, false)
		arg0_27:transFilter()
	end

	table.sort(arg0_27.codeShips, function(arg0_29, arg1_29)
		return arg0_29.index_id < arg1_29.index_id
	end)
	arg0_27.cardList:SetTotalCount(#arg0_27.codeShips, arg0_27.contextData.cardScrollValue or 0)
end

function var0_0.initIndexPanel(arg0_30)
	arg0_30.indexBtn = arg0_30:findTF("index_button", arg0_30.top)

	onButton(arg0_30, arg0_30.indexBtn, function()
		local var0_31 = Clone(var0_0.ShipIndexData)

		if arg0_30.contextData.toggle == 1 and arg0_30.contextData.cardToggle == 2 then
			var0_31.customPanels.campIndex = nil
			var0_31.groupList[2] = nil
		end

		var0_31.indexDatas = Clone(var0_0.ShipIndex)

		function var0_31.callback(arg0_32)
			var0_0.ShipIndex.typeIndex = arg0_32.typeIndex

			if arg0_32.campIndex then
				var0_0.ShipIndex.campIndex = arg0_32.campIndex
			end

			var0_0.ShipIndex.rarityIndex = arg0_32.rarityIndex
			var0_0.ShipIndex.collExtraIndex = arg0_32.collExtraIndex

			arg0_30:initCardPanel()
		end

		arg0_30:emit(var0_0.ON_INDEX, var0_31)
	end, SFX_PANEL)
end

function var0_0.onInitCard(arg0_33, arg1_33)
	if arg0_33.exited then
		return
	end

	local var0_33 = CollectionShipCard.New(arg1_33)

	onButton(arg0_33, var0_33.go, function()
		if not arg0_33.isClicked then
			arg0_33.isClicked = true

			LeanTween.delayedCall(0.2, System.Action(function()
				arg0_33.isClicked = false

				if not var0_33:getIsInited() then
					return
				end

				if var0_33.state == ShipGroup.STATE_UNLOCK then
					arg0_33.contextData.cardScrollValue = arg0_33.cardList.value

					arg0_33:emit(var0_0.SHOW_DETAIL, var0_33.showTrans, var0_33.shipGroup.id)
				elseif var0_33.state == ShipGroup.STATE_NOTGET then
					if var0_33.showTrans == true and var0_33.shipGroup.trans == true then
						return
					end

					if var0_33.config then
						arg0_33:showObtain(var0_33.config.description, var0_33.shipGroup:getShipConfigId())
					end
				end
			end))
		end
	end, SOUND_BACK)

	arg0_33.cardItems[arg1_33] = var0_33
end

function var0_0.showObtain(arg0_36, arg1_36, arg2_36)
	local var0_36 = {
		type = MSGBOX_TYPE_OBTAIN,
		shipId = arg2_36,
		list = arg1_36,
		mediatorName = CollectionMediator.__cname
	}

	if PLATFORM_CODE == PLATFORM_CH and HXSet.isHx() then
		var0_36.unknown_small = true
	end

	arg0_36.contextData.cardScrollValue = arg0_36.cardList.value

	pg.MsgboxMgr.GetInstance():ShowMsgBox(var0_36)
end

function var0_0.skipIn(arg0_37, arg1_37, arg2_37)
	arg0_37.contextData.displayGroupId = arg2_37

	triggerToggle(arg0_37.toggles[arg1_37], true)
end

function var0_0.onUpdateCard(arg0_38, arg1_38, arg2_38)
	if arg0_38.exited then
		return
	end

	local var0_38 = arg0_38.cardItems[arg2_38]

	if not var0_38 then
		arg0_38:onInitCard(arg2_38)

		var0_38 = arg0_38.cardItems[arg2_38]
	end

	local var1_38 = arg1_38 + 1
	local var2_38 = arg0_38.codeShips[var1_38]

	if not var2_38 then
		return
	end

	local var3_38 = false

	if var2_38.group then
		var3_38 = arg0_38.proposeList[var2_38.group.id]
	end

	var0_38:update(var2_38.code, var2_38.group, var2_38.showTrans, var3_38, var2_38.id)
end

function var0_0.onReturnCard(arg0_39, arg1_39, arg2_39)
	if arg0_39.exited then
		return
	end

	local var0_39 = arg0_39.cardItems[arg2_39]

	if var0_39 then
		var0_39:clear()
	end
end

function var0_0.cardFilter(arg0_40)
	arg0_40.codeShips = {}

	local var0_40 = _.filter(pg.ship_data_group.all, function(arg0_41)
		return pg.ship_data_group[arg0_41].handbook_type == arg0_40.contextData.cardToggle - 1
	end)

	table.sort(var0_40)

	for iter0_40, iter1_40 in ipairs(var0_40) do
		local var1_40 = pg.ship_data_group[iter1_40]
		local var2_40 = arg0_40.shipGroups[var1_40.group_type] or ShipGroup.New({
			id = var1_40.group_type
		})

		if ShipIndexConst.filterByType(var2_40, var0_0.ShipIndex.typeIndex) and (arg0_40.contextData.cardToggle == 2 or ShipIndexConst.filterByCamp(var2_40, var0_0.ShipIndex.campIndex)) and arg0_40.contextData.cardToggle == 4 == Nation.IsMeta(ShipGroup.getDefaultShipConfig(var1_40.group_type).nationality) and ShipIndexConst.filterByRarity(var2_40, var0_0.ShipIndex.rarityIndex) and ShipIndexConst.filterByCollExtra(var2_40, var0_0.ShipIndex.collExtraIndex) then
			arg0_40.codeShips[#arg0_40.codeShips + 1] = {
				showTrans = false,
				id = iter1_40,
				code = iter1_40 - (arg0_40.contextData.cardToggle - 1) * 10000,
				group = arg0_40.shipGroups[var1_40.group_type],
				index_id = var1_40.index_id
			}
		end
	end
end

function var0_0.transFilter(arg0_42)
	arg0_42.codeShips = {}

	local var0_42 = _.filter(pg.ship_data_group.all, function(arg0_43)
		return pg.ship_data_group[arg0_43].handbook_type == 0
	end)

	table.sort(var0_42)

	for iter0_42, iter1_42 in ipairs(var0_42) do
		local var1_42 = pg.ship_data_group[iter1_42]

		if pg.ship_data_trans[var1_42.group_type] then
			local var2_42 = arg0_42.shipGroups[var1_42.group_type] or ShipGroup.New({
				remoulded = true,
				id = var1_42.group_type
			})

			if ShipIndexConst.filterByType(var2_42, var0_0.ShipIndex.typeIndex) and ShipIndexConst.filterByCamp(var2_42, var0_0.ShipIndex.campIndex) and ShipIndexConst.filterByRarity(var2_42, var0_0.ShipIndex.rarityIndex) and ShipIndexConst.filterByCollExtra(var2_42, var0_0.ShipIndex.collExtraIndex) then
				arg0_42.codeShips[#arg0_42.codeShips + 1] = {
					showTrans = true,
					id = iter1_42,
					code = 3000 + iter1_42,
					group = var2_42.trans and var2_42 or nil,
					index_id = var1_42.index_id
				}
			end
		end
	end
end

function var0_0.sortDisplay(arg0_44)
	table.sort(arg0_44.favoriteVOs, function(arg0_45, arg1_45)
		local var0_45 = arg0_45:getState(arg0_44.shipGroups, arg0_44.awards)
		local var1_45 = arg1_45:getState(arg0_44.shipGroups, arg0_44.awards)

		if var0_45 == var1_45 then
			return arg0_45.id < arg1_45.id
		else
			return var0_45 < var1_45
		end
	end)

	local var0_44 = 0
	local var1_44 = arg0_44.contextData.displayGroupId

	for iter0_44, iter1_44 in ipairs(arg0_44.favoriteVOs) do
		if iter1_44:containShipGroup(var1_44) then
			var0_44 = iter0_44

			break
		end
	end

	arg0_44.displayRect:SetTotalCount(#arg0_44.favoriteVOs, arg0_44.displayRect:HeadIndexToValue(var0_44 - 1))
end

function var0_0.initDisplayPanel(arg0_46)
	if not arg0_46.isInitDisplay then
		arg0_46.isInitDisplay = true
		arg0_46.displayRect = arg0_46:findTF("main/list_display"):GetComponent("LScrollRect")
		arg0_46.displayRect.decelerationRate = 0.07

		function arg0_46.displayRect.onInitItem(arg0_47)
			arg0_46:initFavoriteCard(arg0_47)
		end

		function arg0_46.displayRect.onUpdateItem(arg0_48, arg1_48)
			arg0_46:updateFavoriteCard(arg0_48, arg1_48)
		end

		arg0_46.favoriteCards = {}
	end

	arg0_46:sortDisplay()
end

function var0_0.initFavoriteCard(arg0_49, arg1_49)
	if arg0_49.exited then
		return
	end

	local var0_49 = FavoriteCard.New(arg1_49, arg0_49.charTpl)

	onButton(arg0_49, var0_49.awardTF, function()
		if var0_49.state == Favorite.STATE_AWARD then
			arg0_49:emit(var0_0.GET_AWARD, var0_49.favoriteVO.id, var0_49.favoriteVO:getNextAwardIndex(var0_49.awards))
		elseif var0_49.state == Favorite.STATE_LOCK then
			pg.TipsMgr.GetInstance():ShowTips(i18n("collection_lock"))
		elseif var0_49.state == Favorite.STATE_FETCHED then
			pg.TipsMgr.GetInstance():ShowTips(i18n("collection_fetched"))
		elseif var0_49.state == Favorite.STATE_STATE_WAIT then
			pg.TipsMgr.GetInstance():ShowTips(i18n("collection_nostar"))
		end
	end, SFX_PANEL)
	onButton(arg0_49, var0_49.box, function()
		arg0_49:openBonus(var0_49.favoriteVO)
	end, SFX_PANEL)

	arg0_49.favoriteCards[arg1_49] = var0_49
end

function var0_0.updateFavoriteCard(arg0_52, arg1_52, arg2_52)
	if arg0_52.exited then
		return
	end

	local var0_52 = arg0_52.favoriteCards[arg2_52]

	if not var0_52 then
		arg0_52:initFavoriteCard(arg2_52)

		var0_52 = arg0_52.favoriteCards[arg2_52]
	end

	local var1_52 = arg0_52.favoriteVOs[arg1_52 + 1]

	var0_52:update(var1_52, arg0_52.shipGroups, arg0_52.awards)
end

function var0_0.openBonus(arg0_53, arg1_53)
	if not arg0_53.isInitBound then
		arg0_53.isInitBound = true
		arg0_53.boundName = findTF(arg0_53.bonusPanel, "frame/name/Text"):GetComponent(typeof(Text))
		arg0_53.progressSlider = findTF(arg0_53.bonusPanel, "frame/process"):GetComponent(typeof(Slider))
	end

	pg.UIMgr.GetInstance():BlurPanel(arg0_53.bonusPanel)
	setActive(arg0_53.bonusPanel, true)

	arg0_53.boundName.text = arg1_53:getConfig("name")

	local var0_53 = arg1_53:getConfig("award_display")
	local var1_53 = arg1_53:getConfig("level")

	for iter0_53, iter1_53 in ipairs(var1_53) do
		local var2_53 = var0_53[iter0_53]
		local var3_53 = findTF(arg0_53.bonusPanel, "frame/awards/award" .. iter0_53)

		setText(findTF(var3_53, "process"), iter1_53)

		local var4_53 = arg1_53:getAwardState(arg0_53.shipGroups, arg0_53.awards, iter0_53)

		setActive(findTF(var3_53, "item_tpl/unfinish"), var4_53 == Favorite.STATE_WAIT)
		setActive(findTF(var3_53, "item_tpl/get"), var4_53 == Favorite.STATE_AWARD)
		setActive(findTF(var3_53, "item_tpl/got"), var4_53 == Favorite.STATE_FETCHED)
		setActive(findTF(var3_53, "item_tpl/lock"), var4_53 == Favorite.STATE_LOCK)
		setActive(findTF(var3_53, "item_tpl/icon_bg"), var4_53 ~= Favorite.STATE_LOCK)
		setActive(findTF(var3_53, "item_tpl/bg"), var4_53 ~= Favorite.STATE_LOCK)

		if var2_53 then
			local var5_53 = {
				count = 0,
				type = var2_53[1],
				id = var2_53[2]
			}

			updateDrop(findTF(var3_53, "item_tpl"), var5_53)

			var5_53.count = var2_53[3]

			onButton(arg0_53, var3_53, function()
				arg0_53:emit(var0_0.ON_DROP, var5_53)
			end, SFX_PANEL)
		else
			GetOrAddComponent(var3_53, typeof(Button)).onClick:RemoveAllListeners()
		end
	end

	local var6_53 = arg1_53:getStarCount(arg0_53.shipGroups)

	arg0_53.progressSlider.value = var6_53 / var1_53[#var1_53]
end

function var0_0.closeBonus(arg0_55)
	pg.UIMgr.GetInstance():UnblurPanel(arg0_55.bonusPanel, arg0_55._tf)
	setActive(arg0_55.bonusPanel, false)
end

function var0_0.showSubMemories(arg0_56, arg1_56)
	arg0_56.contextData.memoryGroup = arg1_56.id
	arg0_56.memories = _.map(arg1_56.memories, function(arg0_57)
		return pg.memory_template[arg0_57]
	end)

	for iter0_56 in ipairs(arg0_56.memories) do
		arg0_56.memories[iter0_56].index = iter0_56
	end

	arg0_56.memoryList:SetTotalCount(#arg0_56.memories, 0)
	setActive(arg0_56:findTF("memory", arg0_56.top), false)
end

local var1_0 = 3

function var0_0.return2MemoryGroup(arg0_58)
	local var0_58 = arg0_58.contextData.memoryGroup

	arg0_58.contextData.memoryGroup = nil
	arg0_58.memories = nil

	local var1_58 = 0

	if var0_58 then
		local var2_58 = 0

		for iter0_58, iter1_58 in ipairs(arg0_58.memoryGroups) do
			if iter1_58.id == var0_58 then
				var2_58 = iter0_58

				break
			end
		end

		if var2_58 >= 0 then
			local var3_58 = arg0_58.memoryList
			local var4_58 = arg0_58.memoriesGrid.cellSize.y + arg0_58.memoriesGrid.spacing.y
			local var5_58 = var4_58 * math.ceil(#arg0_58.memoryGroups / var1_0)

			var1_58 = (var4_58 * math.floor((var2_58 - 1) / var1_0) + var3_58.paddingFront) / (var5_58 - arg0_58.memoryViewport.rect.height)
			var1_58 = Mathf.Clamp01(var1_58)
		end
	end

	arg0_58.memoryList:SetTotalCount(#arg0_58.memoryGroups, var1_58)
	setActive(arg0_58:findTF("memory", arg0_58.top), true)
end

function var0_0.initMemoryPanel(arg0_59)
	local var0_59 = getProxy(ActivityProxy):getActivityById(ActivityConst.QIXI_ACTIVITY_ID)

	if var0_59 and not var0_59:isEnd() then
		local var1_59 = var0_59:getConfig("config_data")
		local var2_59 = _.flatten(var1_59)
		local var3_59 = var2_59[#var2_59]
		local var4_59 = getProxy(TaskProxy):getTaskById(var3_59)

		if var4_59 and not var4_59:isFinish() then
			pg.NewStoryMgr.GetInstance():Play("HOSHO8", function()
				arg0_59:emit(CollectionScene.ACTIVITY_OP, {
					cmd = 2,
					activity_id = var0_59.id
				})
			end, true)
		end
	end

	arg0_59:memoryFilter()
end

function var0_0.onInitMemory(arg0_61, arg1_61)
	if arg0_61.exited then
		return
	end

	local var0_61 = MemoryCard.New(arg1_61)

	onButton(arg0_61, var0_61.go, function()
		if var0_61.info then
			if var0_61.isGroup then
				arg0_61:showSubMemories(var0_61.info)
			elseif var0_61.info.is_open == 1 or pg.NewStoryMgr.GetInstance():IsPlayed(var0_61.info.story, true) then
				arg0_61:playMemory(var0_61.info)
			end
		end
	end, SOUND_BACK)

	arg0_61.memoryItems[arg1_61] = var0_61
end

function var0_0.onUpdateMemory(arg0_63, arg1_63, arg2_63)
	if arg0_63.exited then
		return
	end

	local var0_63 = arg0_63.memoryItems[arg2_63]

	if not var0_63 then
		arg0_63:onInitMemory(arg2_63)

		var0_63 = arg0_63.memoryItems[arg2_63]
	end

	if arg0_63.memories then
		var0_63:update(false, arg0_63.memories[arg1_63 + 1])
	else
		var0_63:update(true, arg0_63.memoryGroups[arg1_63 + 1])
	end

	local var1_63 = {
		var0_63.lock,
		var0_63.normal,
		var0_63.group
	}

	_.any(var1_63, function(arg0_64)
		local var0_64 = isActive(arg0_64)

		if var0_64 then
			var0_63.go:GetComponent(typeof(Button)).targetGraphic = arg0_64:GetComponent(typeof(Image))
		end

		return var0_64
	end)
end

function var0_0.onReturnMemory(arg0_65, arg1_65, arg2_65)
	if arg0_65.exited then
		return
	end

	local var0_65 = arg0_65.memoryItems[arg2_65]

	if var0_65 then
		var0_65:clear()
	end
end

function var0_0.playMemory(arg0_66, arg1_66)
	if arg1_66.type == 1 then
		local var0_66 = findTF(arg0_66.memoryMask, "pic")

		if string.len(arg1_66.mask) > 0 then
			setActive(var0_66, true)

			var0_66:GetComponent(typeof(Image)).sprite = LoadSprite(arg1_66.mask)
		else
			setActive(var0_66, false)
		end

		setActive(arg0_66.memoryMask, true)
		pg.NewStoryMgr.GetInstance():Play(arg1_66.story, function()
			setActive(arg0_66.memoryMask, false)
		end, true)
	elseif arg1_66.type == 2 then
		local var1_66 = pg.NewStoryMgr.GetInstance():StoryName2StoryId(arg1_66.story)

		arg0_66:emit(var0_0.BEGIN_STAGE, {
			memory = true,
			system = SYSTEM_PERFORM,
			stageId = var1_66
		})
	end
end

function var0_0.memoryFilter(arg0_68)
	arg0_68.memoryGroups = {}

	for iter0_68, iter1_68 in ipairs(pg.memory_group.all) do
		local var0_68 = pg.memory_group[iter1_68]

		if arg0_68.memoryFilterIndex[var0_68.type] then
			table.insert(arg0_68.memoryGroups, var0_68)
		end
	end

	table.sort(arg0_68.memoryGroups, function(arg0_69, arg1_69)
		return arg0_69.id < arg1_69.id
	end)
	arg0_68.memoryList:SetTotalCount(#arg0_68.memoryGroups, 0)
end

function var0_0.willExit(arg0_70)
	if arg0_70.bulinTip then
		arg0_70.bulinTip:Destroy()

		arg0_70.bulinTip = nil
	end

	if arg0_70.tweens then
		cancelTweens(arg0_70.tweens)
	end

	pg.UIMgr.GetInstance():UnOverlayPanel(arg0_70.blurPanel, arg0_70._tf)

	if arg0_70.bonusPanel.gameObject.activeSelf then
		arg0_70:closeBonus()
	end

	Destroy(arg0_70.bonusPanel)

	arg0_70.bonusPanel = nil

	for iter0_70, iter1_70 in pairs(arg0_70.cardItems) do
		iter1_70:clear()
	end

	if arg0_70.resPanel then
		arg0_70.resPanel:exit()

		arg0_70.resPanel = nil
	end

	if arg0_70.galleryView then
		arg0_70.galleryView:Destroy()

		arg0_70.galleryView = nil
	end

	if arg0_70.musicView then
		arg0_70.musicView:Destroy()

		arg0_70.musicView = nil
	end

	if arg0_70.mangaView then
		arg0_70.mangaView:Destroy()

		arg0_70.mangaView = nil
	end
end

function var0_0.initGalleryPanel(arg0_71)
	if not arg0_71.galleryView then
		arg0_71.galleryView = GalleryView.New(arg0_71.galleryPanelContainer, arg0_71.event, arg0_71.contextData)

		arg0_71.galleryView:Reset()
		arg0_71.galleryView:Load()
	end
end

function var0_0.initMusicPanel(arg0_72)
	if not arg0_72.musicView then
		arg0_72.musicView = MusicCollectionView.New(arg0_72.musicPanelContainer, arg0_72.event, arg0_72.contextData)

		arg0_72.musicView:Reset()
		arg0_72.musicView:Load()
		pg.CriMgr.GetInstance():StopBGM()
	end
end

function var0_0.initMangaPanel(arg0_73)
	if not arg0_73.mangaView then
		arg0_73.mangaView = MangaView.New(arg0_73.mangaPanelContainer, arg0_73.event, arg0_73.contextData)

		arg0_73.mangaView:Reset()
		arg0_73.mangaView:Load()
	end
end

function var0_0.initEvents(arg0_74)
	arg0_74:bind(GalleryConst.OPEN_FULL_SCREEN_PIC_VIEW, function(arg0_75, arg1_75)
		arg0_74:emit(CollectionMediator.EVENT_OPEN_FULL_SCREEN_PIC_VIEW, arg1_75)
	end)
	arg0_74:bind(var0_0.UPDATE_RED_POINT, function()
		arg0_74:updateCollectNotices()
	end)
end

function var0_0.onBackPressed(arg0_77)
	pg.CriMgr.GetInstance():PlaySoundEffect_V3(SFX_CANCEL)

	if arg0_77.bonusPanel.gameObject.activeSelf then
		arg0_77:closeBonus()

		return
	end

	if arg0_77.galleryView then
		if arg0_77.galleryView:onBackPressed() == true then
			arg0_77.galleryView:Destroy()

			arg0_77.galleryView = nil
		else
			return
		end
	end

	if arg0_77.musicView then
		if arg0_77.musicView:onBackPressed() == true then
			arg0_77.musicView:Destroy()

			arg0_77.musicView = nil
		else
			return
		end
	end

	if arg0_77.mangaView then
		if arg0_77.mangaView:onBackPressed() == true then
			arg0_77.mangaView:Destroy()

			arg0_77.mangaView = nil
		else
			return
		end
	end

	triggerButton(arg0_77.backBtn)
end

return var0_0
