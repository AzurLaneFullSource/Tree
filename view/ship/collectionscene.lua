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

function var0_0.getResource(arg0_3)
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

		for iter0_8, iter1_8 in ipairs(pg.music_album.all) do
			local var1_8 = pg.music_album[iter1_8].cover

			if var1_8 and var1_8 ~= "" then
				table.insert(var0_8, MusicCollectionConst.MUSIC_COVER_PATH_PREFIX .. var1_8)
			end
		end

		for iter2_8, iter3_8 in ipairs(pg.music_collect_config.all) do
			local var2_8 = pg.music_collect_config[iter3_8].music
			local var3_8 = MusicCollectionConst.MUSIC_SONG_PATH_PREFIX .. var2_8 .. ".b"

			table.insert(var0_8, var3_8)
		end

		return var0_8
	end

	return ResPathSupport.UniqueLuaArr(ResPathSupport.MergeLuaArr(var0_0.super.getResource(arg0_3), var0_3, var1_3(), var3_3(), var2_3(), var4_3()))
end

function var0_0.setShipGroups(arg0_9, arg1_9)
	arg0_9.shipGroups = arg1_9
end

function var0_0.setAwards(arg0_10, arg1_10)
	arg0_10.awards = arg1_10
end

function var0_0.setCollectionRate(arg0_11, arg1_11, arg2_11, arg3_11)
	arg0_11.rate = arg1_11
	arg0_11.count = arg2_11
	arg0_11.totalCount = arg3_11
end

function var0_0.setLinkCollectionCount(arg0_12, arg1_12)
	arg0_12.linkCount = arg1_12
end

function var0_0.setPlayer(arg0_13, arg1_13)
	arg0_13.player = arg1_13
end

function var0_0.setProposeList(arg0_14, arg1_14)
	arg0_14.proposeList = arg1_14
end

function var0_0.init(arg0_15)
	arg0_15:initEvents()

	arg0_15.blurPanel = arg0_15._tf:Find("blur_panel")
	arg0_15.top = arg0_15._tf:Find("blur_panel/adapt/top")
	arg0_15.leftPanel = arg0_15._tf:Find("blur_panel/adapt/left_length")
	arg0_15.backBtn = findTF(arg0_15.top, "back_btn")
	arg0_15.contextData.toggle = arg0_15.contextData.toggle or 2
	arg0_15.toggles = {
		arg0_15.leftPanel:Find("frame/tagRoot/card"),
		arg0_15.leftPanel:Find("frame/tagRoot/display"),
		arg0_15.leftPanel:Find("frame/tagRoot/trans"),
		arg0_15.leftPanel:Find("frame/tagRoot/manga"),
		arg0_15.leftPanel:Find("frame/tagRoot/gallery"),
		arg0_15.leftPanel:Find("frame/tagRoot/music")
	}
	arg0_15.toggleUpdates = {
		"initCardPanel",
		"initDisplayPanel",
		"initCardPanel",
		"initMangaPanel",
		"initGalleryPanel",
		"initMusicPanel"
	}
	arg0_15.cardList = arg0_15._tf:Find("main/list_card/scroll"):GetComponent("LScrollRect")

	function arg0_15.cardList.onInitItem(arg0_16)
		arg0_15:onInitCard(arg0_16)
	end

	function arg0_15.cardList.onUpdateItem(arg0_17, arg1_17)
		arg0_15:onUpdateCard(arg0_17, arg1_17)
	end

	function arg0_15.cardList.onReturnItem(arg0_18, arg1_18)
		arg0_15:onReturnCard(arg0_18, arg1_18)
	end

	arg0_15.cardItems = {}
	arg0_15.cardContent = tf(arg0_15.cardList):Find("ships")
	arg0_15.contextData.cardToggle = arg0_15.contextData.cardToggle or 1
	arg0_15.cardToggleGroup = arg0_15._tf:Find("main/list_card/types")
	arg0_15.cardToggles = {
		arg0_15.cardToggleGroup:Find("char"),
		arg0_15.cardToggleGroup:Find("link"),
		arg0_15.cardToggleGroup:Find("blueprint"),
		arg0_15.cardToggleGroup:Find("meta")
	}
	arg0_15.cardList.decelerationRate = 0.07

	local var0_15 = arg0_15.cardContent:GetComponentInChildren(typeof(GridLayoutGroup))
	local var1_15 = tf(arg0_15.cardList).rect.width
	local var2_15 = var0_15.cellSize.x
	local var3_15 = var0_15.spacing.x
	local var4_15 = var1_15 - var0_15.padding.left - var0_15.padding.right
	local var5_15 = var2_15 + var3_15

	if var5_15 > 0 then
		local var6_15 = math.floor((var4_15 + var3_15) / var5_15)

		var0_15.constraintCount = math.max(6, var6_15)
	end

	arg0_15.bonusPanel = arg0_15._tf:Find("bonus_panel")
	arg0_15.charTpl = arg0_15:getTpl("chartpl")
	arg0_15.tip = arg0_15.toggles[2]:Find("tip")

	local var7_15 = pg.storeup_data_template

	arg0_15.favoriteVOs = {}

	for iter0_15, iter1_15 in ipairs(var7_15.all) do
		local var8_15 = Favorite.New({
			id = iter0_15
		})

		table.insert(arg0_15.favoriteVOs, var8_15)
	end

	arg0_15.memoryGroups = _.map(pg.memory_group.all, function(arg0_19)
		return pg.memory_group[arg0_19]
	end)
	arg0_15.memories = nil
	arg0_15.memoryList = arg0_15._tf:Find("main/list_memory"):GetComponent("LScrollRect")

	function arg0_15.memoryList.onInitItem(arg0_20)
		arg0_15:onInitMemory(arg0_20)
	end

	function arg0_15.memoryList.onUpdateItem(arg0_21, arg1_21)
		arg0_15:onUpdateMemory(arg0_21, arg1_21)
	end

	function arg0_15.memoryList.onReturnItem(arg0_22, arg1_22)
		arg0_15:onReturnMemory(arg0_22, arg1_22)
	end

	arg0_15.memoryViewport = arg0_15._tf:Find("main/list_memory/viewport")
	arg0_15.memoriesGrid = arg0_15._tf:Find("main/list_memory/viewport/memories"):GetComponent(typeof(GridLayoutGroup))
	arg0_15.memoryItems = {}

	local var9_15 = tf(arg0_15.memoryList):Find("memory")

	arg0_15.memoryMask = arg0_15._tf:Find("blur_panel/story_mask")

	setActive(var9_15, false)
	setActive(arg0_15.memoryMask, false)

	arg0_15.memoryTogGroup = arg0_15.top:Find("memory")

	setActive(arg0_15.memoryTogGroup, false)

	arg0_15.memoryToggles = {
		arg0_15.top:Find("memory/0"),
		arg0_15.top:Find("memory/1"),
		arg0_15.top:Find("memory/2"),
		arg0_15.top:Find("memory/3")
	}
	arg0_15.memoryFilterIndex = {
		true,
		true,
		true
	}
	arg0_15.galleryPanelContainer = arg0_15._tf:Find("main/GalleryContainer")
	arg0_15.musicPanelContainer = arg0_15._tf:Find("main/MusicContainer")
	arg0_15.mangaPanelContainer = arg0_15._tf:Find("main/MangaContainer")

	arg0_15:initIndexPanel()
end

function var0_0.didEnter(arg0_23)
	onButton(arg0_23, arg0_23.backBtn, function()
		arg0_23.contextData.cardScrollValue = 0

		arg0_23:emit(var0_0.ON_BACK)
	end, SFX_CANCEL)

	arg0_23.helpBtn = arg0_23.leftPanel:Find("help_btn")

	onButton(arg0_23, arg0_23.helpBtn, function()
		if arg0_23.contextData.toggle == var0_0.MUSIC_INDEX then
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

	local var0_23 = arg0_23.top:Find("stamp")

	setActive(var0_23, getProxy(TaskProxy):mingshiTouchFlagEnabled())
	onButton(arg0_23, var0_23, function()
		getProxy(TaskProxy):dealMingshiTouchFlag(8)
	end, SFX_CONFIRM)

	for iter0_23, iter1_23 in ipairs(arg0_23.toggles) do
		if PLATFORM_CODE == PLATFORM_CH and (iter0_23 == 1 or iter0_23 == 3) and LOCK_COLLECTION then
			setActive(iter1_23, false)
		else
			onToggle(arg0_23, iter1_23, function(arg0_27)
				if arg0_27 then
					if arg0_23.contextData.toggle ~= iter0_23 then
						if arg0_23.contextData.toggle == var0_0.SHIPCOLLECTION_INDEX then
							setActive(arg0_23.helpBtn, false)

							if arg0_23.bulinTip then
								arg0_23.bulinTip.buffer:Hide()
							end

							if arg0_23.contextData.cardToggle == 1 then
								arg0_23.contextData.cardScrollValue = arg0_23.cardList.value
							end
						end

						arg0_23.contextData.toggle = iter0_23

						if arg0_23.toggleUpdates[iter0_23] then
							arg0_23[arg0_23.toggleUpdates[iter0_23]](arg0_23)
							arg0_23:calFavoriteRate()
						end
					end

					if iter0_23 == var0_0.SHIPCOLLECTION_INDEX then
						setActive(arg0_23.helpBtn, true)

						local var0_27 = getProxy(SettingsProxy)

						if not var0_27:IsShowCollectionHelp() then
							triggerButton(arg0_23.helpBtn)
							var0_27:SetCollectionHelpFlag(true)
						end

						if arg0_23.bulinTip then
							arg0_23.bulinTip.buffer:Show()
						else
							arg0_23.bulinTip = AprilFoolBulinSubView.ShowAprilFoolBulin(arg0_23, arg0_23._tf:Find("main"))
						end
					end

					if iter0_23 ~= var0_0.MUSIC_INDEX then
						if arg0_23.musicView and arg0_23.musicView:CheckState(BaseSubView.STATES.INITED) then
							arg0_23.musicView:tryPauseMusic()
							arg0_23.musicView:closeAlbumListPanel()
						end

						pg.BgmMgr.GetInstance():ContinuePlay()
					elseif iter0_23 == var0_0.MUSIC_INDEX then
						pg.BgmMgr.GetInstance():StopPlay()

						if arg0_23.musicView and arg0_23.musicView:CheckState(BaseSubView.STATES.INITED) then
							arg0_23.musicView:tryPlayMusic()
						end
					end
				end
			end, SFX_UI_TAG)
		end
	end

	for iter2_23, iter3_23 in ipairs(arg0_23.memoryToggles) do
		onToggle(arg0_23, iter3_23, function(arg0_28)
			if arg0_28 then
				if iter2_23 == 1 then
					arg0_23.memoryFilterIndex = {
						true,
						true,
						true
					}
				else
					for iter0_28 in ipairs(arg0_23.memoryFilterIndex) do
						arg0_23.memoryFilterIndex[iter0_28] = iter2_23 - 1 == iter0_28
					end
				end

				arg0_23:memoryFilter()
			end
		end, SFX_UI_TAG)
	end

	local var1_23 = arg0_23.contextData.toggle

	arg0_23.contextData.toggle = -1

	triggerToggle(arg0_23.toggles[var1_23], true)

	local var2_23 = arg0_23.contextData.memoryGroup

	if var2_23 and pg.memory_group[var2_23] then
		arg0_23:showSubMemories(pg.memory_group[var2_23])
	else
		triggerToggle(arg0_23.memoryToggles[1], true)
	end

	for iter4_23, iter5_23 in ipairs(arg0_23.cardToggles) do
		triggerToggle(iter5_23, arg0_23.contextData.cardToggle == iter4_23)
		onToggle(arg0_23, iter5_23, function(arg0_29)
			if arg0_29 and arg0_23.contextData.cardToggle ~= iter4_23 then
				if arg0_23.contextData.cardToggle == 1 then
					arg0_23.contextData.cardScrollValue = arg0_23.cardList.value
				end

				arg0_23.contextData.cardToggle = iter4_23

				arg0_23:initCardPanel()
				arg0_23:calFavoriteRate()
			end
		end)
	end

	arg0_23:calFavoriteRate()
	arg0_23:OverlayPanel(arg0_23.blurPanel)
	onButton(arg0_23, arg0_23.bonusPanel, function()
		arg0_23:closeBonus()
	end, SFX_PANEL)
end

function var0_0.updateCollectNotices(arg0_31, arg1_31)
	setActive(arg0_31.tip, arg1_31)
	setActive(arg0_31.toggles[var0_0.GALLERY_INDEX]:Find("tip"), getProxy(AppreciateProxy):isGalleryHaveNewRes())
	setActive(arg0_31.toggles[var0_0.MUSIC_INDEX]:Find("tip"), getProxy(AppreciateProxy):isMusicHaveNewRes())
	setActive(arg0_31.toggles[var0_0.MANGA_INDEX]:Find("tip"), getProxy(AppreciateProxy):isMangaHaveNewRes())
end

function var0_0.calFavoriteRate(arg0_32)
	local var0_32 = arg0_32.contextData.toggle == 1 and arg0_32.contextData.cardToggle == 2

	setActive(arg0_32.top:Find("total/char"), not var0_32)
	setActive(arg0_32.top:Find("total/link"), var0_32)
	setText(arg0_32.top:Find("total/char/rate/Text"), arg0_32.rate * 100 .. "%")
	setText(arg0_32.top:Find("total/char/count/Text"), arg0_32.count .. "/" .. arg0_32.totalCount)
	setText(arg0_32.top:Find("total/link/count/Text"), arg0_32.linkCount)
end

function var0_0.initCardPanel(arg0_33)
	local var0_33 = arg0_33:isDefaultStatus() and "shaixuan_off" or "shaixuan_on"

	GetSpriteFromAtlasAsync("ui/share/index_atlas", var0_33, function(arg0_34)
		setImageSprite(arg0_33.indexBtn, arg0_34, true)
	end)

	if arg0_33.contextData.toggle == 1 then
		setActive(arg0_33.cardToggleGroup, true)
		arg0_33:cardFilter()
	elseif arg0_33.contextData.toggle == 3 then
		setActive(arg0_33.cardToggleGroup, false)
		arg0_33:transFilter()
	end

	table.sort(arg0_33.codeShips, function(arg0_35, arg1_35)
		return arg0_35.index_id < arg1_35.index_id
	end)
	arg0_33.cardList:SetTotalCount(#arg0_33.codeShips, arg0_33.contextData.cardScrollValue or 0)
end

function var0_0.initIndexPanel(arg0_36)
	arg0_36.indexBtn = arg0_36.top:Find("index_button")

	onButton(arg0_36, arg0_36.indexBtn, function()
		local var0_37 = Clone(var0_0.ShipIndexData)

		if arg0_36.contextData.toggle == 1 and arg0_36.contextData.cardToggle == 2 then
			var0_37.customPanels.campIndex = nil
			var0_37.groupList[2] = nil
		end

		var0_37.indexDatas = Clone(var0_0.ShipIndex)

		function var0_37.callback(arg0_38)
			var0_0.ShipIndex.typeIndex = arg0_38.typeIndex

			if arg0_38.campIndex then
				var0_0.ShipIndex.campIndex = arg0_38.campIndex
			end

			var0_0.ShipIndex.rarityIndex = arg0_38.rarityIndex
			var0_0.ShipIndex.collExtraIndex = arg0_38.collExtraIndex

			arg0_36:initCardPanel()
		end

		arg0_36:emit(var0_0.ON_INDEX, var0_37)
	end, SFX_PANEL)
end

function var0_0.onInitCard(arg0_39, arg1_39)
	if arg0_39.exited then
		return
	end

	local var0_39 = CollectionShipCard.New(arg1_39)

	onButton(arg0_39, var0_39.go, function()
		if not arg0_39.isClicked then
			arg0_39.isClicked = true

			LeanTween.delayedCall(0.2, System.Action(function()
				arg0_39.isClicked = false

				if not var0_39:getIsInited() then
					return
				end

				if var0_39.state == ShipGroup.STATE_UNLOCK then
					arg0_39.contextData.cardScrollValue = arg0_39.cardList.value

					arg0_39:emit(var0_0.SHOW_DETAIL, var0_39.showTrans, var0_39.shipGroup.id)
				elseif var0_39.state == ShipGroup.STATE_NOTGET then
					if var0_39.showTrans == true and var0_39.shipGroup.trans == true then
						return
					end

					if var0_39.config then
						arg0_39:showObtain(var0_39.config.description, var0_39.shipGroup:getShipConfigId())
					end
				end
			end))
		end
	end, SOUND_BACK)

	arg0_39.cardItems[arg1_39] = var0_39
end

function var0_0.showObtain(arg0_42, arg1_42, arg2_42)
	local var0_42 = {
		type = MSGBOX_TYPE_OBTAIN,
		shipId = arg2_42,
		list = arg1_42,
		mediatorName = CollectionMediator.__cname
	}

	if PLATFORM_CODE == PLATFORM_CH and HXSet.isHx() then
		var0_42.unknown_small = true
	end

	arg0_42.contextData.cardScrollValue = arg0_42.cardList.value

	pg.MsgboxMgr.GetInstance():ShowMsgBox(var0_42)
end

function var0_0.skipIn(arg0_43, arg1_43, arg2_43)
	arg0_43.contextData.displayGroupId = arg2_43

	triggerToggle(arg0_43.toggles[arg1_43], true)
end

function var0_0.onUpdateCard(arg0_44, arg1_44, arg2_44)
	if arg0_44.exited then
		return
	end

	local var0_44 = arg0_44.cardItems[arg2_44]

	if not var0_44 then
		arg0_44:onInitCard(arg2_44)

		var0_44 = arg0_44.cardItems[arg2_44]
	end

	local var1_44 = arg1_44 + 1
	local var2_44 = arg0_44.codeShips[var1_44]

	if not var2_44 then
		return
	end

	local var3_44 = false

	if var2_44.group then
		var3_44 = arg0_44.proposeList[var2_44.group.id]
	end

	var0_44:update(var2_44.code, var2_44.group, var2_44.showTrans, var3_44, var2_44.id)
end

function var0_0.onReturnCard(arg0_45, arg1_45, arg2_45)
	if arg0_45.exited then
		return
	end

	local var0_45 = arg0_45.cardItems[arg2_45]

	if var0_45 then
		var0_45:clear()
	end
end

function var0_0.cardFilter(arg0_46)
	arg0_46.codeShips = {}

	local var0_46 = _.filter(pg.ship_data_group.all, function(arg0_47)
		return pg.ship_data_group[arg0_47].handbook_type == arg0_46.contextData.cardToggle - 1
	end)

	table.sort(var0_46)

	for iter0_46, iter1_46 in ipairs(var0_46) do
		local var1_46 = pg.ship_data_group[iter1_46]
		local var2_46 = arg0_46.shipGroups[var1_46.group_type] or ShipGroup.New({
			id = var1_46.group_type
		})

		if ShipIndexConst.filterByType(var2_46, var0_0.ShipIndex.typeIndex) and (arg0_46.contextData.cardToggle == 2 or ShipIndexConst.filterByCamp(var2_46, var0_0.ShipIndex.campIndex)) and arg0_46.contextData.cardToggle == 4 == Nation.IsMeta(ShipGroup.getDefaultShipConfig(var1_46.group_type).nationality) and ShipIndexConst.filterByRarity(var2_46, var0_0.ShipIndex.rarityIndex) and ShipIndexConst.filterByCollExtra(var2_46, var0_0.ShipIndex.collExtraIndex) then
			arg0_46.codeShips[#arg0_46.codeShips + 1] = {
				showTrans = false,
				id = iter1_46,
				code = iter1_46 - (arg0_46.contextData.cardToggle - 1) * 10000,
				group = arg0_46.shipGroups[var1_46.group_type],
				index_id = var1_46.index_id
			}
		end
	end
end

function var0_0.transFilter(arg0_48)
	arg0_48.codeShips = {}

	local var0_48 = _.filter(pg.ship_data_group.all, function(arg0_49)
		return pg.ship_data_group[arg0_49].handbook_type == 0
	end)

	table.sort(var0_48)

	for iter0_48, iter1_48 in ipairs(var0_48) do
		local var1_48 = pg.ship_data_group[iter1_48]

		if pg.ship_data_trans[var1_48.group_type] then
			local var2_48 = arg0_48.shipGroups[var1_48.group_type] or ShipGroup.New({
				remoulded = true,
				id = var1_48.group_type
			})

			if ShipIndexConst.filterByType(var2_48, var0_0.ShipIndex.typeIndex) and ShipIndexConst.filterByCamp(var2_48, var0_0.ShipIndex.campIndex) and ShipIndexConst.filterByRarity(var2_48, var0_0.ShipIndex.rarityIndex) and ShipIndexConst.filterByCollExtra(var2_48, var0_0.ShipIndex.collExtraIndex) then
				arg0_48.codeShips[#arg0_48.codeShips + 1] = {
					showTrans = true,
					id = iter1_48,
					code = 3000 + iter1_48,
					group = var2_48.trans and var2_48 or nil,
					index_id = var1_48.index_id
				}
			end
		end
	end
end

function var0_0.sortDisplay(arg0_50)
	table.sort(arg0_50.favoriteVOs, function(arg0_51, arg1_51)
		local var0_51 = arg0_51:getState(arg0_50.shipGroups, arg0_50.awards)
		local var1_51 = arg1_51:getState(arg0_50.shipGroups, arg0_50.awards)

		if var0_51 == var1_51 then
			return arg0_51.id < arg1_51.id
		else
			return var0_51 < var1_51
		end
	end)

	local var0_50 = 0
	local var1_50 = arg0_50.contextData.displayGroupId

	for iter0_50, iter1_50 in ipairs(arg0_50.favoriteVOs) do
		if iter1_50:containShipGroup(var1_50) then
			var0_50 = iter0_50

			break
		end
	end

	arg0_50.displayRect:SetTotalCount(#arg0_50.favoriteVOs, arg0_50.displayRect:HeadIndexToValue(var0_50 - 1))
end

function var0_0.initDisplayPanel(arg0_52)
	if not arg0_52.isInitDisplay then
		arg0_52.isInitDisplay = true
		arg0_52.displayRect = arg0_52._tf:Find("main/list_display"):GetComponent("LScrollRect")
		arg0_52.displayRect.decelerationRate = 0.07

		function arg0_52.displayRect.onInitItem(arg0_53)
			arg0_52:initFavoriteCard(arg0_53)
		end

		function arg0_52.displayRect.onUpdateItem(arg0_54, arg1_54)
			arg0_52:updateFavoriteCard(arg0_54, arg1_54)
		end

		arg0_52.favoriteCards = {}
	end

	arg0_52:sortDisplay()
end

function var0_0.initFavoriteCard(arg0_55, arg1_55)
	if arg0_55.exited then
		return
	end

	local var0_55 = FavoriteCard.New(arg1_55, arg0_55.charTpl)

	onButton(arg0_55, var0_55.awardTF, function()
		if var0_55.state == Favorite.STATE_AWARD then
			arg0_55:emit(var0_0.GET_AWARD, var0_55.favoriteVO.id, var0_55.favoriteVO:getNextAwardIndex(var0_55.awards))
		elseif var0_55.state == Favorite.STATE_LOCK then
			pg.TipsMgr.GetInstance():ShowTips(i18n("collection_lock"))
		elseif var0_55.state == Favorite.STATE_FETCHED then
			pg.TipsMgr.GetInstance():ShowTips(i18n("collection_fetched"))
		elseif var0_55.state == Favorite.STATE_STATE_WAIT then
			pg.TipsMgr.GetInstance():ShowTips(i18n("collection_nostar"))
		end
	end, SFX_PANEL)
	onButton(arg0_55, var0_55.box, function()
		arg0_55:openBonus(var0_55.favoriteVO)
	end, SFX_PANEL)

	arg0_55.favoriteCards[arg1_55] = var0_55
end

function var0_0.updateFavoriteCard(arg0_58, arg1_58, arg2_58)
	if arg0_58.exited then
		return
	end

	local var0_58 = arg0_58.favoriteCards[arg2_58]

	if not var0_58 then
		arg0_58:initFavoriteCard(arg2_58)

		var0_58 = arg0_58.favoriteCards[arg2_58]
	end

	local var1_58 = arg0_58.favoriteVOs[arg1_58 + 1]

	var0_58:update(var1_58, arg0_58.shipGroups, arg0_58.awards)
end

function var0_0.openBonus(arg0_59, arg1_59)
	if not arg0_59.isInitBound then
		arg0_59.isInitBound = true
		arg0_59.boundName = findTF(arg0_59.bonusPanel, "frame/name/Text"):GetComponent(typeof(Text))
		arg0_59.progressSlider = findTF(arg0_59.bonusPanel, "frame/process"):GetComponent(typeof(Slider))
	end

	pg.UIMgr.GetInstance():BlurPanel(arg0_59.bonusPanel)
	setActive(arg0_59.bonusPanel, true)

	arg0_59.boundName.text = arg1_59:getConfig("name")

	local var0_59 = arg1_59:getConfig("award_display")
	local var1_59 = arg1_59:getConfig("level")

	for iter0_59, iter1_59 in ipairs(var1_59) do
		local var2_59 = var0_59[iter0_59]
		local var3_59 = findTF(arg0_59.bonusPanel, "frame/awards/award" .. iter0_59)

		setText(findTF(var3_59, "process"), iter1_59)

		local var4_59 = arg1_59:getAwardState(arg0_59.shipGroups, arg0_59.awards, iter0_59)

		setActive(findTF(var3_59, "item_tpl/unfinish"), var4_59 == Favorite.STATE_WAIT)
		setActive(findTF(var3_59, "item_tpl/get"), var4_59 == Favorite.STATE_AWARD)
		setActive(findTF(var3_59, "item_tpl/got"), var4_59 == Favorite.STATE_FETCHED)
		setActive(findTF(var3_59, "item_tpl/lock"), var4_59 == Favorite.STATE_LOCK)
		setActive(findTF(var3_59, "item_tpl/icon_bg"), var4_59 ~= Favorite.STATE_LOCK)
		setActive(findTF(var3_59, "item_tpl/bg"), var4_59 ~= Favorite.STATE_LOCK)

		if var2_59 then
			local var5_59 = {
				count = 0,
				type = var2_59[1],
				id = var2_59[2]
			}

			updateDrop(findTF(var3_59, "item_tpl"), var5_59)

			var5_59.count = var2_59[3]

			onButton(arg0_59, var3_59, function()
				arg0_59:emit(var0_0.ON_DROP, var5_59)
			end, SFX_PANEL)
		else
			GetOrAddComponent(var3_59, typeof(Button)).onClick:RemoveAllListeners()
		end
	end

	local var6_59 = arg1_59:getStarCount(arg0_59.shipGroups)

	arg0_59.progressSlider.value = var6_59 / var1_59[#var1_59]
end

function var0_0.closeBonus(arg0_61)
	pg.UIMgr.GetInstance():UnOverlayPanel(arg0_61.bonusPanel, arg0_61._tf)
	setActive(arg0_61.bonusPanel, false)
end

function var0_0.showSubMemories(arg0_62, arg1_62)
	arg0_62.contextData.memoryGroup = arg1_62.id
	arg0_62.memories = _.map(arg1_62.memories, function(arg0_63)
		return pg.memory_template[arg0_63]
	end)

	for iter0_62 in ipairs(arg0_62.memories) do
		arg0_62.memories[iter0_62].index = iter0_62
	end

	arg0_62.memoryList:SetTotalCount(#arg0_62.memories, 0)
	setActive(arg0_62.top:Find("memory"), false)
end

local var1_0 = 3

function var0_0.return2MemoryGroup(arg0_64)
	local var0_64 = arg0_64.contextData.memoryGroup

	arg0_64.contextData.memoryGroup = nil
	arg0_64.memories = nil

	local var1_64 = 0

	if var0_64 then
		local var2_64 = 0

		for iter0_64, iter1_64 in ipairs(arg0_64.memoryGroups) do
			if iter1_64.id == var0_64 then
				var2_64 = iter0_64

				break
			end
		end

		if var2_64 >= 0 then
			local var3_64 = arg0_64.memoryList
			local var4_64 = arg0_64.memoriesGrid.cellSize.y + arg0_64.memoriesGrid.spacing.y
			local var5_64 = var4_64 * math.ceil(#arg0_64.memoryGroups / var1_0)

			var1_64 = (var4_64 * math.floor((var2_64 - 1) / var1_0) + var3_64.paddingFront) / (var5_64 - arg0_64.memoryViewport.rect.height)
			var1_64 = Mathf.Clamp01(var1_64)
		end
	end

	arg0_64.memoryList:SetTotalCount(#arg0_64.memoryGroups, var1_64)
	setActive(arg0_64.top:Find("memory"), true)
end

function var0_0.initMemoryPanel(arg0_65)
	local var0_65 = getProxy(ActivityProxy):getActivityById(ActivityConst.QIXI_ACTIVITY_ID)

	if var0_65 and not var0_65:isEnd() then
		local var1_65 = var0_65:getConfig("config_data")
		local var2_65 = _.flatten(var1_65)
		local var3_65 = var2_65[#var2_65]
		local var4_65 = getProxy(TaskProxy):getTaskById(var3_65)

		if var4_65 and not var4_65:isFinish() then
			pg.NewStoryMgr.GetInstance():Play("HOSHO8", function()
				arg0_65:emit(CollectionScene.ACTIVITY_OP, {
					cmd = 2,
					activity_id = var0_65.id
				})
			end, true)
		end
	end

	arg0_65:memoryFilter()
end

function var0_0.onInitMemory(arg0_67, arg1_67)
	if arg0_67.exited then
		return
	end

	local var0_67 = MemoryCard.New(arg1_67)

	onButton(arg0_67, var0_67.go, function()
		if var0_67.info then
			if var0_67.isGroup then
				arg0_67:showSubMemories(var0_67.info)
			elseif var0_67.info.is_open == 1 or pg.NewStoryMgr.GetInstance():IsPlayed(var0_67.info.unlock_pre, true) then
				arg0_67:playMemory(var0_67.info)
			end
		end
	end, SOUND_BACK)

	arg0_67.memoryItems[arg1_67] = var0_67
end

function var0_0.onUpdateMemory(arg0_69, arg1_69, arg2_69)
	if arg0_69.exited then
		return
	end

	local var0_69 = arg0_69.memoryItems[arg2_69]

	if not var0_69 then
		arg0_69:onInitMemory(arg2_69)

		var0_69 = arg0_69.memoryItems[arg2_69]
	end

	if arg0_69.memories then
		var0_69:update(false, arg0_69.memories[arg1_69 + 1])
	else
		var0_69:update(true, arg0_69.memoryGroups[arg1_69 + 1])
	end

	local var1_69 = {
		var0_69.lock,
		var0_69.normal,
		var0_69.group
	}

	_.any(var1_69, function(arg0_70)
		local var0_70 = isActive(arg0_70)

		if var0_70 then
			var0_69.go:GetComponent(typeof(Button)).targetGraphic = arg0_70:GetComponent(typeof(Image))
		end

		return var0_70
	end)
end

function var0_0.onReturnMemory(arg0_71, arg1_71, arg2_71)
	if arg0_71.exited then
		return
	end

	local var0_71 = arg0_71.memoryItems[arg2_71]

	if var0_71 then
		var0_71:clear()
	end
end

function var0_0.playMemory(arg0_72, arg1_72)
	if arg1_72.type == 1 then
		local var0_72 = findTF(arg0_72.memoryMask, "pic")

		if string.len(arg1_72.mask) > 0 then
			setActive(var0_72, true)

			var0_72:GetComponent(typeof(Image)).sprite = LoadSprite(arg1_72.mask)
		else
			setActive(var0_72, false)
		end

		setActive(arg0_72.memoryMask, true)
		pg.NewStoryMgr.GetInstance():Play(arg1_72.story, function()
			setActive(arg0_72.memoryMask, false)
		end, true)
	elseif arg1_72.type == 2 then
		local var1_72 = pg.NewStoryMgr.GetInstance():StoryName2StoryId(arg1_72.story)

		arg0_72:emit(var0_0.BEGIN_STAGE, {
			memory = true,
			system = SYSTEM_PERFORM,
			stageId = var1_72
		})
	end
end

function var0_0.memoryFilter(arg0_74)
	arg0_74.memoryGroups = {}

	for iter0_74, iter1_74 in ipairs(pg.memory_group.all) do
		local var0_74 = pg.memory_group[iter1_74]

		if arg0_74.memoryFilterIndex[var0_74.type] then
			table.insert(arg0_74.memoryGroups, var0_74)
		end
	end

	table.sort(arg0_74.memoryGroups, function(arg0_75, arg1_75)
		return arg0_75.id < arg1_75.id
	end)
	arg0_74.memoryList:SetTotalCount(#arg0_74.memoryGroups, 0)
end

function var0_0.willExit(arg0_76)
	if arg0_76.bulinTip then
		arg0_76.bulinTip:Destroy()

		arg0_76.bulinTip = nil
	end

	if arg0_76.tweens then
		cancelTweens(arg0_76.tweens)
	end

	arg0_76:UnOverlayPanel(arg0_76.blurPanel, arg0_76._tf)

	if arg0_76.bonusPanel.gameObject.activeSelf then
		arg0_76:closeBonus()
	end

	Destroy(arg0_76.bonusPanel)

	arg0_76.bonusPanel = nil

	for iter0_76, iter1_76 in pairs(arg0_76.cardItems) do
		iter1_76:clear()
	end

	if arg0_76.resPanel then
		arg0_76.resPanel:exit()

		arg0_76.resPanel = nil
	end

	if arg0_76.galleryView then
		arg0_76.galleryView:Destroy()

		arg0_76.galleryView = nil
	end

	if arg0_76.musicView then
		arg0_76.musicView:Destroy()

		arg0_76.musicView = nil
	end

	if arg0_76.mangaView then
		arg0_76.mangaView:Destroy()

		arg0_76.mangaView = nil
	end
end

function var0_0.initGalleryPanel(arg0_77)
	if not arg0_77.galleryView then
		arg0_77.galleryView = GalleryView.New(arg0_77.galleryPanelContainer, arg0_77.event, arg0_77.contextData)

		arg0_77.galleryView:RegisterView(arg0_77)
		arg0_77.galleryView:Reset()
		arg0_77.galleryView:Load()
	end
end

function var0_0.initMusicPanel(arg0_78)
	if not arg0_78.musicView then
		arg0_78.musicView = MusicCollectionView.New(arg0_78.musicPanelContainer, arg0_78.event, arg0_78.contextData)

		arg0_78.musicView:Reset()
		arg0_78.musicView:Load()
		pg.CriMgr.GetInstance():StopBGM()
	end
end

function var0_0.initMangaPanel(arg0_79)
	if not arg0_79.mangaView then
		arg0_79.mangaView = MangaView.New(arg0_79.mangaPanelContainer, arg0_79.event, arg0_79.contextData)

		arg0_79.mangaView:Reset()
		arg0_79.mangaView:Load()
	end
end

function var0_0.initEvents(arg0_80)
	arg0_80:bind(var0_0.UPDATE_RED_POINT, function()
		arg0_80:updateCollectNotices()
	end)
end

function var0_0.onBackPressed(arg0_82)
	pg.CriMgr.GetInstance():PlaySoundEffect_V3(SFX_CANCEL)

	if arg0_82.bonusPanel.gameObject.activeSelf then
		arg0_82:closeBonus()

		return
	end

	if arg0_82.galleryView then
		if arg0_82.galleryView:onBackPressed() == true then
			arg0_82.galleryView:Destroy()

			arg0_82.galleryView = nil
		else
			return
		end
	end

	if arg0_82.musicView then
		if arg0_82.musicView:onBackPressed() == true then
			arg0_82.musicView:Destroy()

			arg0_82.musicView = nil
		else
			return
		end
	end

	if arg0_82.mangaView then
		if arg0_82.mangaView:onBackPressed() == true then
			arg0_82.mangaView:Destroy()

			arg0_82.mangaView = nil
		else
			return
		end
	end

	triggerButton(arg0_82.backBtn)
end

return var0_0
