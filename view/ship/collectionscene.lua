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

function var0_0.getResource(arg0_3, arg1_3)
	local var0_3 = {
		"ui/collectionui",
		"ui/share/index_atlas"
	}

	local function var1_3()
		local var0_4 = {}

		for iter0_4, iter1_4 in ipairs(pg.storeup_data_template.all) do
			local var1_4 = pg.storeup_data_template[iter1_4]

			for iter2_4, iter3_4 in ipairs(var1_4.char_list or {}) do
				local var2_4 = ShipGroup.getDefaultSkin(iter3_4)

				if var2_4 then
					table.insertto(var0_4, ResPathSupport.GetShipSkinSpineShipModelList(var2_4.id))
				end
			end
		end

		return var0_4
	end

	local function var2_3()
		local var0_5 = {}

		local function var1_5(arg0_6)
			local var0_6 = Drop.New({
				type = arg0_6[1],
				id = arg0_6[2],
				count = arg0_6[3]
			})

			if var0_6.type == DROP_TYPE_SHIP then
				local var1_6 = Ship.New({
					configId = var0_6.id
				})

				table.insertto(var0_5, ResPathSupport.GetPaintingSquareIconListByPaintingName(var1_6:getPainting()))
				table.insertto(var0_5, ResPathSupport.GetPaintingShipYardIconListByPaintingName(var1_6:getPainting()))
				table.insert(var0_5, string.format(ResPathSupport.ConstPath.BG.ShipCard, var1_6:rarity2bgPrint()))
			elseif var0_6.type == DROP_TYPE_EQUIP then
				local var2_6 = var0_6:getSubClass()

				table.insert(var0_5, ResPathSupport.CombinePath(ResPathSupport.ConstPath.Equipment.Equip, var2_6:getConfig("icon")))
			elseif var0_6.type == DROP_TYPE_FURNITURE then
				table.insert(var0_5, ResPathSupport.CombinePath(ResPathSupport.ConstPath.FurnitureIcon, var0_6:getIcon()))
			elseif var0_6.type == DROP_TYPE_ITEM or var0_6.type == DROP_TYPE_VITEM or var0_6.type == DROP_TYPE_META_PT or var0_6.type == DROP_TYPE_LOVE_LETTER then
				local var3_6 = var0_6:getSubClass()
				local var4_6 = var3_6.icon or var3_6:getConfig("icon")

				if noEmptyStr(var4_6) then
					table.insert(var0_5, var4_6)
				end
			elseif var0_6.type == DROP_TYPE_RESOURCE then
				local var5_6 = id2ItemId(var0_6.id)

				if var5_6 then
					var1_5({
						DROP_TYPE_ITEM,
						var5_6,
						var0_6.count
					})
				end
			end
		end

		for iter0_5, iter1_5 in ipairs(pg.storeup_data_template.all) do
			local var2_5 = pg.storeup_data_template[iter1_5]

			for iter2_5, iter3_5 in ipairs(var2_5.award_display or {}) do
				var1_5(iter3_5)
			end
		end

		return var0_5
	end

	local function var3_3()
		local var0_7 = {}

		for iter0_7, iter1_7 in ipairs(pg.ship_data_group.all) do
			local var1_7 = pg.ship_data_group[iter1_7].group_type
			local var2_7 = ShipGroup.getDefaultSkin(var1_7)
			local var3_7 = ShipGroup.New({
				id = var1_7
			})

			if var2_7 then
				table.insertto(var0_7, ResPathSupport.GetShipSkinPaintingShipYardIconList(var2_7.id))
			end

			table.insert(var0_7, string.format(ResPathSupport.ConstPath.BG.ShipCard, var3_7:rarity2bgPrint(false)))

			if pg.ship_data_trans[var1_7] then
				local var4_7 = ShipGroup.getModSkin(var1_7)

				if var4_7 then
					table.insertto(var0_7, ResPathSupport.GetShipSkinPaintingShipYardIconList(var4_7.id))
				end

				var3_7.trans = true

				table.insert(var0_7, string.format(ResPathSupport.ConstPath.BG.ShipCard, var3_7:rarity2bgPrint(true)))
			end
		end

		return var0_7
	end

	local function var4_3()
		local var0_8 = {}

		for iter0_8, iter1_8 in ipairs(pg.cartoon.all) do
			local var1_8 = MangaConst.GetMangaPicPathByID(iter1_8)

			if var1_8 then
				table.insert(var0_8, var1_8)
			end
		end

		return var0_8
	end

	local function var5_3()
		local var0_9 = {}

		for iter0_9, iter1_9 in ipairs(pg.gallery_config.all) do
			local var1_9 = GalleryConst.GetGalleryPicPathByID(iter1_9)
			local var2_9 = GalleryConst.GetGalleryPreviewPicPathByID(iter1_9)

			if var1_9 then
				table.insert(var0_9, var1_9)
			end

			if var2_9 then
				table.insert(var0_9, var2_9)
			end
		end

		return var0_9
	end

	local function var6_3()
		local var0_10 = {}

		for iter0_10, iter1_10 in ipairs(pg.music_album.all) do
			local var1_10 = pg.music_album[iter1_10].cover

			if var1_10 and var1_10 ~= "" then
				table.insert(var0_10, MusicCollectionConst.MUSIC_COVER_PATH_PREFIX .. var1_10)
			end
		end

		return var0_10
	end

	return ResPathSupport.UniqueLuaArr(ResPathSupport.MergeLuaArr(var0_0.super.getResource(arg0_3, arg1_3), var0_3, var1_3(), var3_3(), var2_3(), var4_3(), var5_3(), var6_3()))
end

function var0_0.setShipGroups(arg0_11, arg1_11)
	arg0_11.shipGroups = arg1_11
end

function var0_0.setAwards(arg0_12, arg1_12)
	arg0_12.awards = arg1_12
end

function var0_0.setCollectionRate(arg0_13, arg1_13, arg2_13, arg3_13)
	arg0_13.rate = arg1_13
	arg0_13.count = arg2_13
	arg0_13.totalCount = arg3_13
end

function var0_0.setLinkCollectionCount(arg0_14, arg1_14)
	arg0_14.linkCount = arg1_14
end

function var0_0.setPlayer(arg0_15, arg1_15)
	arg0_15.player = arg1_15
end

function var0_0.setProposeList(arg0_16, arg1_16)
	arg0_16.proposeList = arg1_16
end

function var0_0.init(arg0_17)
	arg0_17:initEvents()

	arg0_17.blurPanel = arg0_17._tf:Find("blur_panel")
	arg0_17.top = arg0_17._tf:Find("blur_panel/adapt/top")
	arg0_17.leftPanel = arg0_17._tf:Find("blur_panel/adapt/left_length")
	arg0_17.backBtn = findTF(arg0_17.top, "back_btn")
	arg0_17.contextData.toggle = arg0_17.contextData.toggle or 2
	arg0_17.toggles = {
		arg0_17.leftPanel:Find("frame/tagRoot/card"),
		arg0_17.leftPanel:Find("frame/tagRoot/display"),
		arg0_17.leftPanel:Find("frame/tagRoot/trans"),
		arg0_17.leftPanel:Find("frame/tagRoot/manga"),
		arg0_17.leftPanel:Find("frame/tagRoot/gallery"),
		arg0_17.leftPanel:Find("frame/tagRoot/music")
	}
	arg0_17.toggleUpdates = {
		"initCardPanel",
		"initDisplayPanel",
		"initCardPanel",
		"initMangaPanel",
		"initGalleryPanel",
		"initMusicPanel"
	}
	arg0_17.cardList = arg0_17._tf:Find("main/list_card/scroll"):GetComponent("LScrollRect")

	function arg0_17.cardList.onInitItem(arg0_18)
		arg0_17:onInitCard(arg0_18)
	end

	function arg0_17.cardList.onUpdateItem(arg0_19, arg1_19)
		arg0_17:onUpdateCard(arg0_19, arg1_19)
	end

	function arg0_17.cardList.onReturnItem(arg0_20, arg1_20)
		arg0_17:onReturnCard(arg0_20, arg1_20)
	end

	arg0_17.cardItems = {}
	arg0_17.cardContent = tf(arg0_17.cardList):Find("ships")
	arg0_17.contextData.cardToggle = arg0_17.contextData.cardToggle or 1
	arg0_17.cardToggleGroup = arg0_17._tf:Find("main/list_card/types")
	arg0_17.cardToggles = {
		arg0_17.cardToggleGroup:Find("char"),
		arg0_17.cardToggleGroup:Find("link"),
		arg0_17.cardToggleGroup:Find("blueprint"),
		arg0_17.cardToggleGroup:Find("meta")
	}
	arg0_17.cardList.decelerationRate = 0.07
	arg0_17.bonusPanel = arg0_17._tf:Find("bonus_panel")
	arg0_17.charTpl = arg0_17:getTpl("chartpl")
	arg0_17.tip = arg0_17.toggles[2]:Find("tip")

	local var0_17 = pg.storeup_data_template

	arg0_17.favoriteVOs = {}

	for iter0_17, iter1_17 in ipairs(var0_17.all) do
		local var1_17 = Favorite.New({
			id = iter0_17
		})

		table.insert(arg0_17.favoriteVOs, var1_17)
	end

	arg0_17.memoryGroups = _.map(pg.memory_group.all, function(arg0_21)
		return pg.memory_group[arg0_21]
	end)
	arg0_17.memories = nil
	arg0_17.memoryList = arg0_17._tf:Find("main/list_memory"):GetComponent("LScrollRect")

	function arg0_17.memoryList.onInitItem(arg0_22)
		arg0_17:onInitMemory(arg0_22)
	end

	function arg0_17.memoryList.onUpdateItem(arg0_23, arg1_23)
		arg0_17:onUpdateMemory(arg0_23, arg1_23)
	end

	function arg0_17.memoryList.onReturnItem(arg0_24, arg1_24)
		arg0_17:onReturnMemory(arg0_24, arg1_24)
	end

	arg0_17.memoryViewport = arg0_17._tf:Find("main/list_memory/viewport")
	arg0_17.memoriesGrid = arg0_17._tf:Find("main/list_memory/viewport/memories"):GetComponent(typeof(GridLayoutGroup))
	arg0_17.memoryItems = {}

	local var2_17 = tf(arg0_17.memoryList):Find("memory")

	arg0_17.memoryMask = arg0_17._tf:Find("blur_panel/story_mask")

	setActive(var2_17, false)
	setActive(arg0_17.memoryMask, false)

	arg0_17.memoryTogGroup = arg0_17.top:Find("memory")

	setActive(arg0_17.memoryTogGroup, false)

	arg0_17.memoryToggles = {
		arg0_17.top:Find("memory/0"),
		arg0_17.top:Find("memory/1"),
		arg0_17.top:Find("memory/2"),
		arg0_17.top:Find("memory/3")
	}
	arg0_17.memoryFilterIndex = {
		true,
		true,
		true
	}
	arg0_17.galleryPanelContainer = arg0_17._tf:Find("main/GalleryContainer")
	arg0_17.musicPanelContainer = arg0_17._tf:Find("main/MusicContainer")
	arg0_17.mangaPanelContainer = arg0_17._tf:Find("main/MangaContainer")

	arg0_17:initIndexPanel()
end

function var0_0.didEnter(arg0_25)
	onButton(arg0_25, arg0_25.backBtn, function()
		arg0_25.contextData.cardScrollValue = 0

		arg0_25:emit(var0_0.ON_BACK)
	end, SFX_CANCEL)

	arg0_25.helpBtn = arg0_25.leftPanel:Find("help_btn")

	onButton(arg0_25, arg0_25.helpBtn, function()
		if arg0_25.contextData.toggle == var0_0.MUSIC_INDEX then
			pg.MsgboxMgr.GetInstance():ShowMsgBox({
				type = MSGBOX_TYPE_HELP,
				helps = pg.gametip.NewMusic_help.tip
			})
		else
			pg.MsgboxMgr.GetInstance():ShowMsgBox({
				type = MSGBOX_TYPE_HELP,
				helps = pg.gametip.collection_help.tip
			})
		end
	end, SFX_PANEL)

	local var0_25 = arg0_25.top:Find("stamp")

	setActive(var0_25, getProxy(TaskProxy):mingshiTouchFlagEnabled())
	onButton(arg0_25, var0_25, function()
		getProxy(TaskProxy):dealMingshiTouchFlag(8)
	end, SFX_CONFIRM)

	for iter0_25, iter1_25 in ipairs(arg0_25.toggles) do
		if PLATFORM_CODE == PLATFORM_CH and (iter0_25 == 1 or iter0_25 == 3) and LOCK_COLLECTION then
			setActive(iter1_25, false)
		else
			onToggle(arg0_25, iter1_25, function(arg0_29)
				if arg0_29 then
					if arg0_25.contextData.toggle ~= iter0_25 then
						if arg0_25.contextData.toggle == var0_0.SHIPCOLLECTION_INDEX then
							setActive(arg0_25.helpBtn, false)

							if arg0_25.bulinTip then
								arg0_25.bulinTip.buffer:Hide()
							end

							if arg0_25.contextData.cardToggle == 1 then
								arg0_25.contextData.cardScrollValue = arg0_25.cardList.value
							end
						end

						arg0_25.contextData.toggle = iter0_25

						if arg0_25.toggleUpdates[iter0_25] then
							arg0_25[arg0_25.toggleUpdates[iter0_25]](arg0_25)
							arg0_25:calFavoriteRate()
						end
					end

					if iter0_25 == var0_0.SHIPCOLLECTION_INDEX then
						setActive(arg0_25.helpBtn, true)

						local var0_29 = getProxy(SettingsProxy)

						if not var0_29:IsShowCollectionHelp() then
							triggerButton(arg0_25.helpBtn)
							var0_29:SetCollectionHelpFlag(true)
						end

						if arg0_25.bulinTip then
							arg0_25.bulinTip.buffer:Show()
						else
							arg0_25.bulinTip = AprilFoolBulinSubView.ShowAprilFoolBulin(arg0_25, arg0_25._tf:Find("main"))
						end
					end

					if iter0_25 ~= var0_0.MUSIC_INDEX then
						if arg0_25.musicView and arg0_25.musicView:CheckState(BaseSubView.STATES.INITED) then
							arg0_25.musicView:tryPauseMusic()
							arg0_25.musicView:closeAlbumListPanel()
						end

						pg.BgmMgr.GetInstance():ContinuePlay()
					elseif iter0_25 == var0_0.MUSIC_INDEX then
						pg.BgmMgr.GetInstance():StopPlay()

						if arg0_25.musicView and arg0_25.musicView:CheckState(BaseSubView.STATES.INITED) then
							arg0_25.musicView:tryPlayMusic()
						end
					end
				end
			end, SFX_UI_TAG)
		end
	end

	for iter2_25, iter3_25 in ipairs(arg0_25.memoryToggles) do
		onToggle(arg0_25, iter3_25, function(arg0_30)
			if arg0_30 then
				if iter2_25 == 1 then
					arg0_25.memoryFilterIndex = {
						true,
						true,
						true
					}
				else
					for iter0_30 in ipairs(arg0_25.memoryFilterIndex) do
						arg0_25.memoryFilterIndex[iter0_30] = iter2_25 - 1 == iter0_30
					end
				end

				arg0_25:memoryFilter()
			end
		end, SFX_UI_TAG)
	end

	local var1_25 = arg0_25.contextData.toggle

	arg0_25.contextData.toggle = -1

	triggerToggle(arg0_25.toggles[var1_25], true)

	local var2_25 = arg0_25.contextData.memoryGroup

	if var2_25 and pg.memory_group[var2_25] then
		arg0_25:showSubMemories(pg.memory_group[var2_25])
	else
		triggerToggle(arg0_25.memoryToggles[1], true)
	end

	for iter4_25, iter5_25 in ipairs(arg0_25.cardToggles) do
		triggerToggle(iter5_25, arg0_25.contextData.cardToggle == iter4_25)
		onToggle(arg0_25, iter5_25, function(arg0_31)
			if arg0_31 and arg0_25.contextData.cardToggle ~= iter4_25 then
				if arg0_25.contextData.cardToggle == 1 then
					arg0_25.contextData.cardScrollValue = arg0_25.cardList.value
				end

				arg0_25.contextData.cardToggle = iter4_25

				arg0_25:initCardPanel()
				arg0_25:calFavoriteRate()
			end
		end)
	end

	arg0_25:calFavoriteRate()
	arg0_25:OverlayPanel(arg0_25.blurPanel)
	onButton(arg0_25, arg0_25.bonusPanel, function()
		arg0_25:closeBonus()
	end, SFX_PANEL)
end

function var0_0.updateCollectNotices(arg0_33, arg1_33)
	setActive(arg0_33.tip, arg1_33)
	setActive(arg0_33.toggles[var0_0.GALLERY_INDEX]:Find("tip"), getProxy(AppreciateProxy):isGalleryHaveNewRes())
	setActive(arg0_33.toggles[var0_0.MUSIC_INDEX]:Find("tip"), getProxy(AppreciateProxy):isMusicHaveNewRes())
	setActive(arg0_33.toggles[var0_0.MANGA_INDEX]:Find("tip"), getProxy(AppreciateProxy):isMangaHaveNewRes())
end

function var0_0.calFavoriteRate(arg0_34)
	local var0_34 = arg0_34.contextData.toggle == 1 and arg0_34.contextData.cardToggle == 2

	setActive(arg0_34.top:Find("total/char"), not var0_34)
	setActive(arg0_34.top:Find("total/link"), var0_34)
	setText(arg0_34.top:Find("total/char/rate/Text"), arg0_34.rate * 100 .. "%")
	setText(arg0_34.top:Find("total/char/count/Text"), arg0_34.count .. "/" .. arg0_34.totalCount)
	setText(arg0_34.top:Find("total/link/count/Text"), arg0_34.linkCount)
end

function var0_0.initCardPanel(arg0_35)
	local var0_35 = arg0_35:isDefaultStatus() and "shaixuan_off" or "shaixuan_on"

	GetSpriteFromAtlasAsync("ui/share/index_atlas", var0_35, function(arg0_36)
		setImageSprite(arg0_35.indexBtn, arg0_36, true)
	end)

	if arg0_35.contextData.toggle == 1 then
		setActive(arg0_35.cardToggleGroup, true)
		arg0_35:cardFilter()
	elseif arg0_35.contextData.toggle == 3 then
		setActive(arg0_35.cardToggleGroup, false)
		arg0_35:transFilter()
	end

	table.sort(arg0_35.codeShips, function(arg0_37, arg1_37)
		return arg0_37.index_id < arg1_37.index_id
	end)
	arg0_35.cardList:SetTotalCount(#arg0_35.codeShips, arg0_35.contextData.cardScrollValue or 0)
end

function var0_0.initIndexPanel(arg0_38)
	arg0_38.indexBtn = arg0_38.top:Find("index_button")

	onButton(arg0_38, arg0_38.indexBtn, function()
		local var0_39 = Clone(var0_0.ShipIndexData)

		if arg0_38.contextData.toggle == 1 and arg0_38.contextData.cardToggle == 2 then
			var0_39.customPanels.campIndex = nil
			var0_39.groupList[2] = nil
		end

		var0_39.indexDatas = Clone(var0_0.ShipIndex)

		function var0_39.callback(arg0_40)
			var0_0.ShipIndex.typeIndex = arg0_40.typeIndex

			if arg0_40.campIndex then
				var0_0.ShipIndex.campIndex = arg0_40.campIndex
			end

			var0_0.ShipIndex.rarityIndex = arg0_40.rarityIndex
			var0_0.ShipIndex.collExtraIndex = arg0_40.collExtraIndex

			arg0_38:initCardPanel()
		end

		arg0_38:emit(var0_0.ON_INDEX, var0_39)
	end, SFX_PANEL)
end

function var0_0.onInitCard(arg0_41, arg1_41)
	if arg0_41.exited then
		return
	end

	local var0_41 = CollectionShipCard.New(arg1_41)

	onButton(arg0_41, var0_41.go, function()
		if not arg0_41.isClicked then
			arg0_41.isClicked = true

			LeanTween.delayedCall(0.2, System.Action(function()
				arg0_41.isClicked = false

				if not var0_41:getIsInited() then
					return
				end

				if var0_41.state == ShipGroup.STATE_UNLOCK then
					arg0_41.contextData.cardScrollValue = arg0_41.cardList.value

					arg0_41:emit(var0_0.SHOW_DETAIL, var0_41.showTrans, var0_41.shipGroup.id)
				elseif var0_41.state == ShipGroup.STATE_NOTGET then
					if var0_41.showTrans == true and var0_41.shipGroup.trans == true then
						return
					end

					if var0_41.config then
						arg0_41:showObtain(var0_41.config.description, var0_41.shipGroup:getShipConfigId())
					end
				end
			end))
		end
	end, SOUND_BACK)

	arg0_41.cardItems[arg1_41] = var0_41
end

function var0_0.showObtain(arg0_44, arg1_44, arg2_44)
	local var0_44 = {
		type = MSGBOX_TYPE_OBTAIN,
		shipId = arg2_44,
		list = arg1_44,
		mediatorName = CollectionMediator.__cname
	}

	if PLATFORM_CODE == PLATFORM_CH and HXSet.isHx() then
		var0_44.unknown_small = true
	end

	arg0_44.contextData.cardScrollValue = arg0_44.cardList.value

	pg.MsgboxMgr.GetInstance():ShowMsgBox(var0_44)
end

function var0_0.skipIn(arg0_45, arg1_45, arg2_45)
	arg0_45.contextData.displayGroupId = arg2_45

	triggerToggle(arg0_45.toggles[arg1_45], true)
end

function var0_0.onUpdateCard(arg0_46, arg1_46, arg2_46)
	if arg0_46.exited then
		return
	end

	local var0_46 = arg0_46.cardItems[arg2_46]

	if not var0_46 then
		arg0_46:onInitCard(arg2_46)

		var0_46 = arg0_46.cardItems[arg2_46]
	end

	local var1_46 = arg1_46 + 1
	local var2_46 = arg0_46.codeShips[var1_46]

	if not var2_46 then
		return
	end

	local var3_46 = false

	if var2_46.group then
		var3_46 = arg0_46.proposeList[var2_46.group.id]
	end

	var0_46:update(var2_46.code, var2_46.group, var2_46.showTrans, var3_46, var2_46.id)
end

function var0_0.onReturnCard(arg0_47, arg1_47, arg2_47)
	if arg0_47.exited then
		return
	end

	local var0_47 = arg0_47.cardItems[arg2_47]

	if var0_47 then
		var0_47:clear()
	end
end

function var0_0.cardFilter(arg0_48)
	arg0_48.codeShips = {}

	local var0_48 = _.filter(pg.ship_data_group.all, function(arg0_49)
		return pg.ship_data_group[arg0_49].handbook_type == arg0_48.contextData.cardToggle - 1
	end)

	table.sort(var0_48)

	for iter0_48, iter1_48 in ipairs(var0_48) do
		local var1_48 = pg.ship_data_group[iter1_48]
		local var2_48 = arg0_48.shipGroups[var1_48.group_type] or ShipGroup.New({
			id = var1_48.group_type
		})

		if ShipIndexConst.filterByType(var2_48, var0_0.ShipIndex.typeIndex) and (arg0_48.contextData.cardToggle == 2 or ShipIndexConst.filterByCamp(var2_48, var0_0.ShipIndex.campIndex)) and arg0_48.contextData.cardToggle == 4 == Nation.IsMeta(ShipGroup.getDefaultShipConfig(var1_48.group_type).nationality) and ShipIndexConst.filterByRarity(var2_48, var0_0.ShipIndex.rarityIndex) and ShipIndexConst.filterByCollExtra(var2_48, var0_0.ShipIndex.collExtraIndex) then
			arg0_48.codeShips[#arg0_48.codeShips + 1] = {
				showTrans = false,
				id = iter1_48,
				code = iter1_48 - (arg0_48.contextData.cardToggle - 1) * 10000,
				group = arg0_48.shipGroups[var1_48.group_type],
				index_id = var1_48.index_id
			}
		end
	end
end

function var0_0.transFilter(arg0_50)
	arg0_50.codeShips = {}

	local var0_50 = _.filter(pg.ship_data_group.all, function(arg0_51)
		return pg.ship_data_group[arg0_51].handbook_type == 0
	end)

	table.sort(var0_50)

	for iter0_50, iter1_50 in ipairs(var0_50) do
		local var1_50 = pg.ship_data_group[iter1_50]

		if pg.ship_data_trans[var1_50.group_type] then
			local var2_50 = arg0_50.shipGroups[var1_50.group_type] or ShipGroup.New({
				remoulded = true,
				id = var1_50.group_type
			})

			if ShipIndexConst.filterByType(var2_50, var0_0.ShipIndex.typeIndex) and ShipIndexConst.filterByCamp(var2_50, var0_0.ShipIndex.campIndex) and ShipIndexConst.filterByRarity(var2_50, var0_0.ShipIndex.rarityIndex) and ShipIndexConst.filterByCollExtra(var2_50, var0_0.ShipIndex.collExtraIndex) then
				arg0_50.codeShips[#arg0_50.codeShips + 1] = {
					showTrans = true,
					id = iter1_50,
					code = 3000 + iter1_50,
					group = var2_50.trans and var2_50 or nil,
					index_id = var1_50.index_id
				}
			end
		end
	end
end

function var0_0.sortDisplay(arg0_52)
	table.sort(arg0_52.favoriteVOs, function(arg0_53, arg1_53)
		local var0_53 = arg0_53:getState(arg0_52.shipGroups, arg0_52.awards)
		local var1_53 = arg1_53:getState(arg0_52.shipGroups, arg0_52.awards)

		if var0_53 == var1_53 then
			return arg0_53.id < arg1_53.id
		else
			return var0_53 < var1_53
		end
	end)

	local var0_52 = 0
	local var1_52 = arg0_52.contextData.displayGroupId

	for iter0_52, iter1_52 in ipairs(arg0_52.favoriteVOs) do
		if iter1_52:containShipGroup(var1_52) then
			var0_52 = iter0_52

			break
		end
	end

	arg0_52.displayRect:SetTotalCount(#arg0_52.favoriteVOs, arg0_52.displayRect:HeadIndexToValue(var0_52 - 1))
end

function var0_0.initDisplayPanel(arg0_54)
	if not arg0_54.isInitDisplay then
		arg0_54.isInitDisplay = true
		arg0_54.displayRect = arg0_54._tf:Find("main/list_display"):GetComponent("LScrollRect")
		arg0_54.displayRect.decelerationRate = 0.07

		function arg0_54.displayRect.onInitItem(arg0_55)
			arg0_54:initFavoriteCard(arg0_55)
		end

		function arg0_54.displayRect.onUpdateItem(arg0_56, arg1_56)
			arg0_54:updateFavoriteCard(arg0_56, arg1_56)
		end

		arg0_54.favoriteCards = {}
	end

	arg0_54:sortDisplay()
end

function var0_0.initFavoriteCard(arg0_57, arg1_57)
	if arg0_57.exited then
		return
	end

	local var0_57 = FavoriteCard.New(arg1_57, arg0_57.charTpl)

	onButton(arg0_57, var0_57.awardTF, function()
		if var0_57.state == Favorite.STATE_AWARD then
			arg0_57:emit(var0_0.GET_AWARD, var0_57.favoriteVO.id, var0_57.favoriteVO:getNextAwardIndex(var0_57.awards))
		elseif var0_57.state == Favorite.STATE_LOCK then
			pg.TipsMgr.GetInstance():ShowTips(i18n("collection_lock"))
		elseif var0_57.state == Favorite.STATE_FETCHED then
			pg.TipsMgr.GetInstance():ShowTips(i18n("collection_fetched"))
		elseif var0_57.state == Favorite.STATE_STATE_WAIT then
			pg.TipsMgr.GetInstance():ShowTips(i18n("collection_nostar"))
		end
	end, SFX_PANEL)
	onButton(arg0_57, var0_57.box, function()
		arg0_57:openBonus(var0_57.favoriteVO)
	end, SFX_PANEL)

	arg0_57.favoriteCards[arg1_57] = var0_57
end

function var0_0.updateFavoriteCard(arg0_60, arg1_60, arg2_60)
	if arg0_60.exited then
		return
	end

	local var0_60 = arg0_60.favoriteCards[arg2_60]

	if not var0_60 then
		arg0_60:initFavoriteCard(arg2_60)

		var0_60 = arg0_60.favoriteCards[arg2_60]
	end

	local var1_60 = arg0_60.favoriteVOs[arg1_60 + 1]

	var0_60:update(var1_60, arg0_60.shipGroups, arg0_60.awards)
end

function var0_0.openBonus(arg0_61, arg1_61)
	if not arg0_61.isInitBound then
		arg0_61.isInitBound = true
		arg0_61.boundName = findTF(arg0_61.bonusPanel, "frame/name/Text"):GetComponent(typeof(Text))
		arg0_61.progressSlider = findTF(arg0_61.bonusPanel, "frame/process"):GetComponent(typeof(Slider))
	end

	pg.UIMgr.GetInstance():BlurPanel(arg0_61.bonusPanel)
	setActive(arg0_61.bonusPanel, true)

	arg0_61.boundName.text = arg1_61:getConfig("name")

	local var0_61 = arg1_61:getConfig("award_display")
	local var1_61 = arg1_61:getConfig("level")

	for iter0_61, iter1_61 in ipairs(var1_61) do
		local var2_61 = var0_61[iter0_61]
		local var3_61 = findTF(arg0_61.bonusPanel, "frame/awards/award" .. iter0_61)

		setText(findTF(var3_61, "process"), iter1_61)

		local var4_61 = arg1_61:getAwardState(arg0_61.shipGroups, arg0_61.awards, iter0_61)

		setActive(findTF(var3_61, "item_tpl/unfinish"), var4_61 == Favorite.STATE_WAIT)
		setActive(findTF(var3_61, "item_tpl/get"), var4_61 == Favorite.STATE_AWARD)
		setActive(findTF(var3_61, "item_tpl/got"), var4_61 == Favorite.STATE_FETCHED)
		setActive(findTF(var3_61, "item_tpl/lock"), var4_61 == Favorite.STATE_LOCK)
		setActive(findTF(var3_61, "item_tpl/icon_bg"), var4_61 ~= Favorite.STATE_LOCK)
		setActive(findTF(var3_61, "item_tpl/bg"), var4_61 ~= Favorite.STATE_LOCK)

		if var2_61 then
			local var5_61 = {
				count = 0,
				type = var2_61[1],
				id = var2_61[2]
			}

			updateDrop(findTF(var3_61, "item_tpl"), var5_61)

			var5_61.count = var2_61[3]

			onButton(arg0_61, var3_61, function()
				arg0_61:emit(var0_0.ON_DROP, var5_61)
			end, SFX_PANEL)
		else
			GetOrAddComponent(var3_61, typeof(Button)).onClick:RemoveAllListeners()
		end
	end

	local var6_61 = arg1_61:getStarCount(arg0_61.shipGroups)

	arg0_61.progressSlider.value = var6_61 / var1_61[#var1_61]
end

function var0_0.closeBonus(arg0_63)
	pg.UIMgr.GetInstance():UnOverlayPanel(arg0_63.bonusPanel, arg0_63._tf)
	setActive(arg0_63.bonusPanel, false)
end

function var0_0.showSubMemories(arg0_64, arg1_64)
	arg0_64.contextData.memoryGroup = arg1_64.id
	arg0_64.memories = _.map(arg1_64.memories, function(arg0_65)
		return pg.memory_template[arg0_65]
	end)

	for iter0_64 in ipairs(arg0_64.memories) do
		arg0_64.memories[iter0_64].index = iter0_64
	end

	arg0_64.memoryList:SetTotalCount(#arg0_64.memories, 0)
	setActive(arg0_64.top:Find("memory"), false)
end

local var1_0 = 3

function var0_0.return2MemoryGroup(arg0_66)
	local var0_66 = arg0_66.contextData.memoryGroup

	arg0_66.contextData.memoryGroup = nil
	arg0_66.memories = nil

	local var1_66 = 0

	if var0_66 then
		local var2_66 = 0

		for iter0_66, iter1_66 in ipairs(arg0_66.memoryGroups) do
			if iter1_66.id == var0_66 then
				var2_66 = iter0_66

				break
			end
		end

		if var2_66 >= 0 then
			local var3_66 = arg0_66.memoryList
			local var4_66 = arg0_66.memoriesGrid.cellSize.y + arg0_66.memoriesGrid.spacing.y
			local var5_66 = var4_66 * math.ceil(#arg0_66.memoryGroups / var1_0)

			var1_66 = (var4_66 * math.floor((var2_66 - 1) / var1_0) + var3_66.paddingFront) / (var5_66 - arg0_66.memoryViewport.rect.height)
			var1_66 = Mathf.Clamp01(var1_66)
		end
	end

	arg0_66.memoryList:SetTotalCount(#arg0_66.memoryGroups, var1_66)
	setActive(arg0_66.top:Find("memory"), true)
end

function var0_0.initMemoryPanel(arg0_67)
	local var0_67 = getProxy(ActivityProxy):getActivityById(ActivityConst.QIXI_ACTIVITY_ID)

	if var0_67 and not var0_67:isEnd() then
		local var1_67 = var0_67:getConfig("config_data")
		local var2_67 = _.flatten(var1_67)
		local var3_67 = var2_67[#var2_67]
		local var4_67 = getProxy(TaskProxy):getTaskById(var3_67)

		if var4_67 and not var4_67:isFinish() then
			pg.NewStoryMgr.GetInstance():Play("HOSHO8", function()
				arg0_67:emit(CollectionScene.ACTIVITY_OP, {
					cmd = 2,
					activity_id = var0_67.id
				})
			end, true)
		end
	end

	arg0_67:memoryFilter()
end

function var0_0.onInitMemory(arg0_69, arg1_69)
	if arg0_69.exited then
		return
	end

	local var0_69 = MemoryCard.New(arg1_69)

	onButton(arg0_69, var0_69.go, function()
		if var0_69.info then
			if var0_69.isGroup then
				arg0_69:showSubMemories(var0_69.info)
			elseif var0_69.info.is_open == 1 or pg.NewStoryMgr.GetInstance():IsPlayed(var0_69.info.unlock_pre, true) then
				arg0_69:playMemory(var0_69.info)
			end
		end
	end, SOUND_BACK)

	arg0_69.memoryItems[arg1_69] = var0_69
end

function var0_0.onUpdateMemory(arg0_71, arg1_71, arg2_71)
	if arg0_71.exited then
		return
	end

	local var0_71 = arg0_71.memoryItems[arg2_71]

	if not var0_71 then
		arg0_71:onInitMemory(arg2_71)

		var0_71 = arg0_71.memoryItems[arg2_71]
	end

	if arg0_71.memories then
		var0_71:update(false, arg0_71.memories[arg1_71 + 1])
	else
		var0_71:update(true, arg0_71.memoryGroups[arg1_71 + 1])
	end

	local var1_71 = {
		var0_71.lock,
		var0_71.normal,
		var0_71.group
	}

	_.any(var1_71, function(arg0_72)
		local var0_72 = isActive(arg0_72)

		if var0_72 then
			var0_71.go:GetComponent(typeof(Button)).targetGraphic = arg0_72:GetComponent(typeof(Image))
		end

		return var0_72
	end)
end

function var0_0.onReturnMemory(arg0_73, arg1_73, arg2_73)
	if arg0_73.exited then
		return
	end

	local var0_73 = arg0_73.memoryItems[arg2_73]

	if var0_73 then
		var0_73:clear()
	end
end

function var0_0.playMemory(arg0_74, arg1_74)
	if arg1_74.type == 1 then
		local var0_74 = findTF(arg0_74.memoryMask, "pic")

		if string.len(arg1_74.mask) > 0 then
			setActive(var0_74, true)

			var0_74:GetComponent(typeof(Image)).sprite = LoadSprite(arg1_74.mask)
		else
			setActive(var0_74, false)
		end

		setActive(arg0_74.memoryMask, true)
		pg.NewStoryMgr.GetInstance():Play(arg1_74.story, function()
			setActive(arg0_74.memoryMask, false)
		end, true)
	elseif arg1_74.type == 2 then
		local var1_74 = pg.NewStoryMgr.GetInstance():StoryName2StoryId(arg1_74.story)

		arg0_74:emit(var0_0.BEGIN_STAGE, {
			memory = true,
			system = SYSTEM_PERFORM,
			stageId = var1_74
		})
	end
end

function var0_0.memoryFilter(arg0_76)
	arg0_76.memoryGroups = {}

	for iter0_76, iter1_76 in ipairs(pg.memory_group.all) do
		local var0_76 = pg.memory_group[iter1_76]

		if arg0_76.memoryFilterIndex[var0_76.type] then
			table.insert(arg0_76.memoryGroups, var0_76)
		end
	end

	table.sort(arg0_76.memoryGroups, function(arg0_77, arg1_77)
		return arg0_77.id < arg1_77.id
	end)
	arg0_76.memoryList:SetTotalCount(#arg0_76.memoryGroups, 0)
end

function var0_0.willExit(arg0_78)
	if arg0_78.bulinTip then
		arg0_78.bulinTip:Destroy()

		arg0_78.bulinTip = nil
	end

	if arg0_78.tweens then
		cancelTweens(arg0_78.tweens)
	end

	arg0_78:UnOverlayPanel(arg0_78.blurPanel, arg0_78._tf)

	if arg0_78.bonusPanel.gameObject.activeSelf then
		arg0_78:closeBonus()
	end

	Destroy(arg0_78.bonusPanel)

	arg0_78.bonusPanel = nil

	for iter0_78, iter1_78 in pairs(arg0_78.cardItems) do
		iter1_78:clear()
	end

	if arg0_78.resPanel then
		arg0_78.resPanel:exit()

		arg0_78.resPanel = nil
	end

	if arg0_78.galleryView then
		arg0_78.galleryView:Destroy()

		arg0_78.galleryView = nil
	end

	if arg0_78.musicView then
		arg0_78.musicView:Destroy()

		arg0_78.musicView = nil
	end

	if arg0_78.mangaView then
		arg0_78.mangaView:Destroy()

		arg0_78.mangaView = nil
	end
end

function var0_0.initGalleryPanel(arg0_79)
	if not arg0_79.galleryView then
		arg0_79.galleryView = GalleryView.New(arg0_79.galleryPanelContainer, arg0_79.event, arg0_79.contextData)

		arg0_79.galleryView:RegisterView(arg0_79)
		arg0_79.galleryView:Reset()
		arg0_79.galleryView:Load()
	end
end

function var0_0.initMusicPanel(arg0_80)
	if not arg0_80.musicView then
		arg0_80.musicView = MusicCollectionView.New(arg0_80.musicPanelContainer, arg0_80.event, arg0_80.contextData)

		arg0_80.musicView:Reset()
		arg0_80.musicView:Load()
		pg.CriMgr.GetInstance():StopBGM()
	end
end

function var0_0.initMangaPanel(arg0_81)
	if not arg0_81.mangaView then
		arg0_81.mangaView = MangaView.New(arg0_81.mangaPanelContainer, arg0_81.event, arg0_81.contextData)

		arg0_81.mangaView:Reset()
		arg0_81.mangaView:Load()
	end
end

function var0_0.initEvents(arg0_82)
	arg0_82:bind(var0_0.UPDATE_RED_POINT, function()
		arg0_82:updateCollectNotices()
	end)
end

function var0_0.onBackPressed(arg0_84)
	pg.CriMgr.GetInstance():PlaySoundEffect_V3(SFX_CANCEL)

	if arg0_84.bonusPanel.gameObject.activeSelf then
		arg0_84:closeBonus()

		return
	end

	if arg0_84.galleryView then
		if arg0_84.galleryView:onBackPressed() == true then
			arg0_84.galleryView:Destroy()

			arg0_84.galleryView = nil
		else
			return
		end
	end

	if arg0_84.musicView then
		if arg0_84.musicView:onBackPressed() == true then
			arg0_84.musicView:Destroy()

			arg0_84.musicView = nil
		else
			return
		end
	end

	if arg0_84.mangaView then
		if arg0_84.mangaView:onBackPressed() == true then
			arg0_84.mangaView:Destroy()

			arg0_84.mangaView = nil
		else
			return
		end
	end

	triggerButton(arg0_84.backBtn)
end

return var0_0
