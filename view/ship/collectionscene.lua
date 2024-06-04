local var0 = class("CollectionScene", import("..base.BaseUI"))

var0.SHOW_DETAIL = "event show detail"
var0.GET_AWARD = "event get award"
var0.ACTIVITY_OP = "event activity op"
var0.BEGIN_STAGE = "event begin state"
var0.ON_INDEX = "event on index"
var0.UPDATE_RED_POINT = "CollectionScene:UPDATE_RED_POINT"
var0.ShipOrderAsc = false
var0.ShipIndex = {
	typeIndex = ShipIndexConst.TypeAll,
	campIndex = ShipIndexConst.CampAll,
	rarityIndex = ShipIndexConst.RarityAll,
	collExtraIndex = ShipIndexConst.CollExtraAll
}
var0.ShipIndexData = {
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
var0.SHIPCOLLECTION_INDEX = 1
var0.MANGA_INDEX = 4
var0.GALLERY_INDEX = 5
var0.MUSIC_INDEX = 6

function var0.isDefaultStatus(arg0)
	return var0.ShipIndex.typeIndex == ShipIndexConst.TypeAll and (var0.ShipIndex.campIndex == ShipIndexConst.CampAll or arg0.contextData.toggle == 1 and arg0.contextData.cardToggle == 2) and var0.ShipIndex.rarityIndex == ShipIndexConst.RarityAll and var0.ShipIndex.collExtraIndex == ShipIndexConst.CollExtraAll
end

function var0.getUIName(arg0)
	return "CollectionUI"
end

function var0.setShipGroups(arg0, arg1)
	arg0.shipGroups = arg1
end

function var0.setAwards(arg0, arg1)
	arg0.awards = arg1
end

function var0.setCollectionRate(arg0, arg1, arg2, arg3)
	arg0.rate = arg1
	arg0.count = arg2
	arg0.totalCount = arg3
end

function var0.setLinkCollectionCount(arg0, arg1)
	arg0.linkCount = arg1
end

function var0.setPlayer(arg0, arg1)
	arg0.player = arg1
end

function var0.setProposeList(arg0, arg1)
	arg0.proposeList = arg1
end

function var0.init(arg0)
	arg0:initEvents()

	arg0.blurPanel = arg0:findTF("blur_panel")
	arg0.top = arg0:findTF("blur_panel/adapt/top")
	arg0.leftPanel = arg0:findTF("blur_panel/adapt/left_length")
	arg0.UIMgr = pg.UIMgr.GetInstance()
	arg0.backBtn = findTF(arg0.top, "back_btn")
	arg0.contextData.toggle = arg0.contextData.toggle or 2
	arg0.toggles = {
		arg0:findTF("frame/tagRoot/card", arg0.leftPanel),
		arg0:findTF("frame/tagRoot/display", arg0.leftPanel),
		arg0:findTF("frame/tagRoot/trans", arg0.leftPanel),
		arg0:findTF("frame/tagRoot/manga", arg0.leftPanel),
		arg0:findTF("frame/tagRoot/gallery", arg0.leftPanel),
		arg0:findTF("frame/tagRoot/music", arg0.leftPanel)
	}
	arg0.toggleUpdates = {
		"initCardPanel",
		"initDisplayPanel",
		"initCardPanel",
		"initMangaPanel",
		"initGalleryPanel",
		"initMusicPanel"
	}
	arg0.cardList = arg0:findTF("main/list_card/scroll"):GetComponent("LScrollRect")

	function arg0.cardList.onInitItem(arg0)
		arg0:onInitCard(arg0)
	end

	function arg0.cardList.onUpdateItem(arg0, arg1)
		arg0:onUpdateCard(arg0, arg1)
	end

	function arg0.cardList.onReturnItem(arg0, arg1)
		arg0:onReturnCard(arg0, arg1)
	end

	arg0.cardItems = {}
	arg0.cardContent = arg0:findTF("ships", arg0.cardList)
	arg0.contextData.cardToggle = arg0.contextData.cardToggle or 1
	arg0.cardToggleGroup = arg0:findTF("main/list_card/types")
	arg0.cardToggles = {
		arg0:findTF("char", arg0.cardToggleGroup),
		arg0:findTF("link", arg0.cardToggleGroup),
		arg0:findTF("blueprint", arg0.cardToggleGroup),
		arg0:findTF("meta", arg0.cardToggleGroup)
	}
	arg0.cardList.decelerationRate = 0.07
	arg0.bonusPanel = arg0:findTF("bonus_panel")
	arg0.charTpl = arg0:getTpl("chartpl")
	arg0.tip = arg0:findTF("tip", arg0.toggles[2])

	local var0 = pg.storeup_data_template

	arg0.favoriteVOs = {}

	for iter0, iter1 in ipairs(var0.all) do
		local var1 = Favorite.New({
			id = iter0
		})

		table.insert(arg0.favoriteVOs, var1)
	end

	arg0.memoryGroups = _.map(pg.memory_group.all, function(arg0)
		return pg.memory_group[arg0]
	end)
	arg0.memories = nil
	arg0.memoryList = arg0:findTF("main/list_memory"):GetComponent("LScrollRect")

	function arg0.memoryList.onInitItem(arg0)
		arg0:onInitMemory(arg0)
	end

	function arg0.memoryList.onUpdateItem(arg0, arg1)
		arg0:onUpdateMemory(arg0, arg1)
	end

	function arg0.memoryList.onReturnItem(arg0, arg1)
		arg0:onReturnMemory(arg0, arg1)
	end

	arg0.memoryViewport = arg0:findTF("main/list_memory/viewport")
	arg0.memoriesGrid = arg0:findTF("main/list_memory/viewport/memories"):GetComponent(typeof(GridLayoutGroup))
	arg0.memoryItems = {}

	local var2 = arg0:findTF("memory", arg0.memoryList)

	arg0.memoryMask = arg0:findTF("blur_panel/adapt/story_mask")

	setActive(var2, false)
	setActive(arg0.memoryMask, false)

	arg0.memoryTogGroup = arg0:findTF("memory", arg0.top)

	setActive(arg0.memoryTogGroup, false)

	arg0.memoryToggles = {
		arg0:findTF("memory/0", arg0.top),
		arg0:findTF("memory/1", arg0.top),
		arg0:findTF("memory/2", arg0.top),
		arg0:findTF("memory/3", arg0.top)
	}
	arg0.memoryFilterIndex = {
		true,
		true,
		true
	}
	arg0.galleryPanelContainer = arg0:findTF("main/GalleryContainer")
	arg0.musicPanelContainer = arg0:findTF("main/MusicContainer")
	arg0.mangaPanelContainer = arg0:findTF("main/MangaContainer")

	arg0:initIndexPanel()
end

function var0.didEnter(arg0)
	onButton(arg0, arg0.backBtn, function()
		arg0.contextData.cardScrollValue = 0

		arg0:emit(var0.ON_BACK)
	end, SFX_CANCEL)

	arg0.helpBtn = arg0:findTF("help_btn", arg0.leftPanel)

	onButton(arg0, arg0.helpBtn, function()
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_HELP,
			helps = pg.gametip.collection_help.tip,
			weight = LayerWeightConst.THIRD_LAYER
		})
	end, SFX_PANEL)

	local var0 = arg0:findTF("stamp", arg0.top)

	setActive(var0, getProxy(TaskProxy):mingshiTouchFlagEnabled())
	onButton(arg0, var0, function()
		getProxy(TaskProxy):dealMingshiTouchFlag(8)
	end, SFX_CONFIRM)

	for iter0, iter1 in ipairs(arg0.toggles) do
		if PLATFORM_CODE == PLATFORM_CH and (iter0 == 1 or iter0 == 3) and LOCK_COLLECTION then
			setActive(iter1, false)
		else
			onToggle(arg0, iter1, function(arg0)
				if arg0 then
					if arg0.contextData.toggle ~= iter0 then
						if arg0.contextData.toggle == var0.SHIPCOLLECTION_INDEX then
							setActive(arg0.helpBtn, false)

							if arg0.bulinTip then
								arg0.bulinTip.buffer:Hide()
							end

							if arg0.contextData.cardToggle == 1 then
								arg0.contextData.cardScrollValue = arg0.cardList.value
							end
						end

						arg0.contextData.toggle = iter0

						if arg0.toggleUpdates[iter0] then
							arg0[arg0.toggleUpdates[iter0]](arg0)
							arg0:calFavoriteRate()
						end
					end

					if iter0 == var0.SHIPCOLLECTION_INDEX then
						setActive(arg0.helpBtn, true)

						local var0 = getProxy(SettingsProxy)

						if not var0:IsShowCollectionHelp() then
							triggerButton(arg0.helpBtn)
							var0:SetCollectionHelpFlag(true)
						end

						if arg0.bulinTip then
							arg0.bulinTip.buffer:Show()
						else
							arg0.bulinTip = AprilFoolBulinSubView.ShowAprilFoolBulin(arg0, arg0:findTF("main"))
						end
					end

					if iter0 ~= var0.MUSIC_INDEX then
						if arg0.musicView and arg0.musicView:CheckState(BaseSubView.STATES.INITED) then
							arg0.musicView:tryPauseMusic()
							arg0.musicView:closeSongListPanel()
						end

						pg.BgmMgr.GetInstance():ContinuePlay()
					elseif iter0 == var0.MUSIC_INDEX then
						pg.BgmMgr.GetInstance():StopPlay()

						if arg0.musicView and arg0.musicView:CheckState(BaseSubView.STATES.INITED) then
							arg0.musicView:tryPlayMusic()
						end
					end

					if iter0 ~= var0.GALLERY_INDEX and arg0.galleryView and arg0.galleryView:CheckState(BaseSubView.STATES.INITED) then
						arg0.galleryView:closePicPanel()
					end
				end
			end, SFX_UI_TAG)
		end
	end

	for iter2, iter3 in ipairs(arg0.memoryToggles) do
		onToggle(arg0, iter3, function(arg0)
			if arg0 then
				if iter2 == 1 then
					arg0.memoryFilterIndex = {
						true,
						true,
						true
					}
				else
					for iter0 in ipairs(arg0.memoryFilterIndex) do
						arg0.memoryFilterIndex[iter0] = iter2 - 1 == iter0
					end
				end

				arg0:memoryFilter()
			end
		end, SFX_UI_TAG)
	end

	local var1 = arg0.contextData.toggle

	arg0.contextData.toggle = -1

	triggerToggle(arg0.toggles[var1], true)

	local var2 = arg0.contextData.memoryGroup

	if var2 and pg.memory_group[var2] then
		arg0:showSubMemories(pg.memory_group[var2])
	else
		triggerToggle(arg0.memoryToggles[1], true)
	end

	for iter4, iter5 in ipairs(arg0.cardToggles) do
		triggerToggle(iter5, arg0.contextData.cardToggle == iter4)
		onToggle(arg0, iter5, function(arg0)
			if arg0 and arg0.contextData.cardToggle ~= iter4 then
				if arg0.contextData.cardToggle == 1 then
					arg0.contextData.cardScrollValue = arg0.cardList.value
				end

				arg0.contextData.cardToggle = iter4

				arg0:initCardPanel()
				arg0:calFavoriteRate()
			end
		end)
	end

	arg0:calFavoriteRate()
	pg.UIMgr.GetInstance():OverlayPanelPB(arg0.blurPanel, {
		groupName = LayerWeightConst.GROUP_COLLECTION
	})
	onButton(arg0, arg0.bonusPanel, function()
		arg0:closeBonus()
	end, SFX_PANEL)
end

function var0.updateCollectNotices(arg0, arg1)
	setActive(arg0.tip, arg1)
	setActive(arg0:findTF("tip", arg0.toggles[var0.GALLERY_INDEX]), getProxy(AppreciateProxy):isGalleryHaveNewRes())
	setActive(arg0:findTF("tip", arg0.toggles[var0.MUSIC_INDEX]), getProxy(AppreciateProxy):isMusicHaveNewRes())
	setActive(arg0:findTF("tip", arg0.toggles[var0.MANGA_INDEX]), getProxy(AppreciateProxy):isMangaHaveNewRes())
end

function var0.calFavoriteRate(arg0)
	local var0 = arg0.contextData.toggle == 1 and arg0.contextData.cardToggle == 2

	setActive(arg0:findTF("total/char", arg0.top), not var0)
	setActive(arg0:findTF("total/link", arg0.top), var0)
	setText(arg0:findTF("total/char/rate/Text", arg0.top), arg0.rate * 100 .. "%")
	setText(arg0:findTF("total/char/count/Text", arg0.top), arg0.count .. "/" .. arg0.totalCount)
	setText(arg0:findTF("total/link/count/Text", arg0.top), arg0.linkCount)
end

function var0.initCardPanel(arg0)
	local var0 = arg0:isDefaultStatus() and "shaixuan_off" or "shaixuan_on"

	GetSpriteFromAtlasAsync("ui/share/index_atlas", var0, function(arg0)
		setImageSprite(arg0.indexBtn, arg0, true)
	end)

	if arg0.contextData.toggle == 1 then
		setActive(arg0.cardToggleGroup, true)
		arg0:cardFilter()
	elseif arg0.contextData.toggle == 3 then
		setActive(arg0.cardToggleGroup, false)
		arg0:transFilter()
	end

	table.sort(arg0.codeShips, function(arg0, arg1)
		return arg0.index_id < arg1.index_id
	end)
	arg0.cardList:SetTotalCount(#arg0.codeShips, arg0.contextData.cardScrollValue or 0)
end

function var0.initIndexPanel(arg0)
	arg0.indexBtn = arg0:findTF("index_button", arg0.top)

	onButton(arg0, arg0.indexBtn, function()
		local var0 = Clone(var0.ShipIndexData)

		if arg0.contextData.toggle == 1 and arg0.contextData.cardToggle == 2 then
			var0.customPanels.campIndex = nil
			var0.groupList[2] = nil
		end

		var0.indexDatas = Clone(var0.ShipIndex)

		function var0.callback(arg0)
			var0.ShipIndex.typeIndex = arg0.typeIndex

			if arg0.campIndex then
				var0.ShipIndex.campIndex = arg0.campIndex
			end

			var0.ShipIndex.rarityIndex = arg0.rarityIndex
			var0.ShipIndex.collExtraIndex = arg0.collExtraIndex

			arg0:initCardPanel()
		end

		arg0:emit(var0.ON_INDEX, var0)
	end, SFX_PANEL)
end

function var0.onInitCard(arg0, arg1)
	if arg0.exited then
		return
	end

	local var0 = CollectionShipCard.New(arg1)

	onButton(arg0, var0.go, function()
		if not arg0.isClicked then
			arg0.isClicked = true

			LeanTween.delayedCall(0.2, System.Action(function()
				arg0.isClicked = false

				if not var0:getIsInited() then
					return
				end

				if var0.state == ShipGroup.STATE_UNLOCK then
					arg0.contextData.cardScrollValue = arg0.cardList.value

					arg0:emit(var0.SHOW_DETAIL, var0.showTrans, var0.shipGroup.id)
				elseif var0.state == ShipGroup.STATE_NOTGET then
					if var0.showTrans == true and var0.shipGroup.trans == true then
						return
					end

					if var0.config then
						arg0:showObtain(var0.config.description, var0.shipGroup:getShipConfigId())
					end
				end
			end))
		end
	end, SOUND_BACK)

	arg0.cardItems[arg1] = var0
end

function var0.showObtain(arg0, arg1, arg2)
	local var0 = {
		type = MSGBOX_TYPE_OBTAIN,
		shipId = arg2,
		list = arg1,
		mediatorName = CollectionMediator.__cname
	}

	if PLATFORM_CODE == PLATFORM_CH and HXSet.isHx() then
		var0.unknown_small = true
	end

	arg0.contextData.cardScrollValue = arg0.cardList.value

	pg.MsgboxMgr.GetInstance():ShowMsgBox(var0)
end

function var0.skipIn(arg0, arg1, arg2)
	arg0.contextData.displayGroupId = arg2

	triggerToggle(arg0.toggles[arg1], true)
end

function var0.onUpdateCard(arg0, arg1, arg2)
	if arg0.exited then
		return
	end

	local var0 = arg0.cardItems[arg2]

	if not var0 then
		arg0:onInitCard(arg2)

		var0 = arg0.cardItems[arg2]
	end

	local var1 = arg1 + 1
	local var2 = arg0.codeShips[var1]

	if not var2 then
		return
	end

	local var3 = false

	if var2.group then
		var3 = arg0.proposeList[var2.group.id]
	end

	var0:update(var2.code, var2.group, var2.showTrans, var3, var2.id)
end

function var0.onReturnCard(arg0, arg1, arg2)
	if arg0.exited then
		return
	end

	local var0 = arg0.cardItems[arg2]

	if var0 then
		var0:clear()
	end
end

function var0.cardFilter(arg0)
	arg0.codeShips = {}

	local var0 = _.filter(pg.ship_data_group.all, function(arg0)
		return pg.ship_data_group[arg0].handbook_type == arg0.contextData.cardToggle - 1
	end)

	table.sort(var0)

	for iter0, iter1 in ipairs(var0) do
		local var1 = pg.ship_data_group[iter1]
		local var2 = arg0.shipGroups[var1.group_type] or ShipGroup.New({
			id = var1.group_type
		})

		if ShipIndexConst.filterByType(var2, var0.ShipIndex.typeIndex) and (arg0.contextData.cardToggle == 2 or ShipIndexConst.filterByCamp(var2, var0.ShipIndex.campIndex)) and arg0.contextData.cardToggle == 4 == Nation.IsMeta(ShipGroup.getDefaultShipConfig(var1.group_type).nationality) and ShipIndexConst.filterByRarity(var2, var0.ShipIndex.rarityIndex) and ShipIndexConst.filterByCollExtra(var2, var0.ShipIndex.collExtraIndex) then
			arg0.codeShips[#arg0.codeShips + 1] = {
				showTrans = false,
				id = iter1,
				code = iter1 - (arg0.contextData.cardToggle - 1) * 10000,
				group = arg0.shipGroups[var1.group_type],
				index_id = var1.index_id
			}
		end
	end
end

function var0.transFilter(arg0)
	arg0.codeShips = {}

	local var0 = _.filter(pg.ship_data_group.all, function(arg0)
		return pg.ship_data_group[arg0].handbook_type == 0
	end)

	table.sort(var0)

	for iter0, iter1 in ipairs(var0) do
		local var1 = pg.ship_data_group[iter1]

		if pg.ship_data_trans[var1.group_type] then
			local var2 = arg0.shipGroups[var1.group_type] or ShipGroup.New({
				remoulded = true,
				id = var1.group_type
			})

			if ShipIndexConst.filterByType(var2, var0.ShipIndex.typeIndex) and ShipIndexConst.filterByCamp(var2, var0.ShipIndex.campIndex) and ShipIndexConst.filterByRarity(var2, var0.ShipIndex.rarityIndex) and ShipIndexConst.filterByCollExtra(var2, var0.ShipIndex.collExtraIndex) then
				arg0.codeShips[#arg0.codeShips + 1] = {
					showTrans = true,
					id = iter1,
					code = 3000 + iter1,
					group = var2.trans and var2 or nil,
					index_id = var1.index_id
				}
			end
		end
	end
end

function var0.sortDisplay(arg0)
	table.sort(arg0.favoriteVOs, function(arg0, arg1)
		local var0 = arg0:getState(arg0.shipGroups, arg0.awards)
		local var1 = arg1:getState(arg0.shipGroups, arg0.awards)

		if var0 == var1 then
			return arg0.id < arg1.id
		else
			return var0 < var1
		end
	end)

	local var0 = 0
	local var1 = arg0.contextData.displayGroupId

	for iter0, iter1 in ipairs(arg0.favoriteVOs) do
		if iter1:containShipGroup(var1) then
			var0 = iter0

			break
		end
	end

	arg0.displayRect:SetTotalCount(#arg0.favoriteVOs, arg0.displayRect:HeadIndexToValue(var0 - 1))
end

function var0.initDisplayPanel(arg0)
	if not arg0.isInitDisplay then
		arg0.isInitDisplay = true
		arg0.displayRect = arg0:findTF("main/list_display"):GetComponent("LScrollRect")
		arg0.displayRect.decelerationRate = 0.07

		function arg0.displayRect.onInitItem(arg0)
			arg0:initFavoriteCard(arg0)
		end

		function arg0.displayRect.onUpdateItem(arg0, arg1)
			arg0:updateFavoriteCard(arg0, arg1)
		end

		arg0.favoriteCards = {}
	end

	arg0:sortDisplay()
end

function var0.initFavoriteCard(arg0, arg1)
	if arg0.exited then
		return
	end

	local var0 = FavoriteCard.New(arg1, arg0.charTpl)

	onButton(arg0, var0.awardTF, function()
		if var0.state == Favorite.STATE_AWARD then
			arg0:emit(var0.GET_AWARD, var0.favoriteVO.id, var0.favoriteVO:getNextAwardIndex(var0.awards))
		elseif var0.state == Favorite.STATE_LOCK then
			pg.TipsMgr.GetInstance():ShowTips(i18n("collection_lock"))
		elseif var0.state == Favorite.STATE_FETCHED then
			pg.TipsMgr.GetInstance():ShowTips(i18n("collection_fetched"))
		elseif var0.state == Favorite.STATE_STATE_WAIT then
			pg.TipsMgr.GetInstance():ShowTips(i18n("collection_nostar"))
		end
	end, SFX_PANEL)
	onButton(arg0, var0.box, function()
		arg0:openBonus(var0.favoriteVO)
	end, SFX_PANEL)

	arg0.favoriteCards[arg1] = var0
end

function var0.updateFavoriteCard(arg0, arg1, arg2)
	if arg0.exited then
		return
	end

	local var0 = arg0.favoriteCards[arg2]

	if not var0 then
		arg0:initFavoriteCard(arg2)

		var0 = arg0.favoriteCards[arg2]
	end

	local var1 = arg0.favoriteVOs[arg1 + 1]

	var0:update(var1, arg0.shipGroups, arg0.awards)
end

function var0.openBonus(arg0, arg1)
	if not arg0.isInitBound then
		arg0.isInitBound = true
		arg0.boundName = findTF(arg0.bonusPanel, "frame/name/Text"):GetComponent(typeof(Text))
		arg0.progressSlider = findTF(arg0.bonusPanel, "frame/process"):GetComponent(typeof(Slider))
	end

	pg.UIMgr.GetInstance():BlurPanel(arg0.bonusPanel)
	setActive(arg0.bonusPanel, true)

	arg0.boundName.text = arg1:getConfig("name")

	local var0 = arg1:getConfig("award_display")
	local var1 = arg1:getConfig("level")

	for iter0, iter1 in ipairs(var1) do
		local var2 = var0[iter0]
		local var3 = findTF(arg0.bonusPanel, "frame/awards/award" .. iter0)

		setText(findTF(var3, "process"), iter1)

		local var4 = arg1:getAwardState(arg0.shipGroups, arg0.awards, iter0)

		setActive(findTF(var3, "item_tpl/unfinish"), var4 == Favorite.STATE_WAIT)
		setActive(findTF(var3, "item_tpl/get"), var4 == Favorite.STATE_AWARD)
		setActive(findTF(var3, "item_tpl/got"), var4 == Favorite.STATE_FETCHED)
		setActive(findTF(var3, "item_tpl/lock"), var4 == Favorite.STATE_LOCK)
		setActive(findTF(var3, "item_tpl/icon_bg"), var4 ~= Favorite.STATE_LOCK)
		setActive(findTF(var3, "item_tpl/bg"), var4 ~= Favorite.STATE_LOCK)

		if var2 then
			local var5 = {
				count = 0,
				type = var2[1],
				id = var2[2]
			}

			updateDrop(findTF(var3, "item_tpl"), var5)

			var5.count = var2[3]

			onButton(arg0, var3, function()
				arg0:emit(var0.ON_DROP, var5)
			end, SFX_PANEL)
		else
			GetOrAddComponent(var3, typeof(Button)).onClick:RemoveAllListeners()
		end
	end

	local var6 = arg1:getStarCount(arg0.shipGroups)

	arg0.progressSlider.value = var6 / var1[#var1]
end

function var0.closeBonus(arg0)
	pg.UIMgr.GetInstance():UnblurPanel(arg0.bonusPanel, arg0._tf)
	setActive(arg0.bonusPanel, false)
end

function var0.showSubMemories(arg0, arg1)
	arg0.contextData.memoryGroup = arg1.id
	arg0.memories = _.map(arg1.memories, function(arg0)
		return pg.memory_template[arg0]
	end)

	for iter0 in ipairs(arg0.memories) do
		arg0.memories[iter0].index = iter0
	end

	arg0.memoryList:SetTotalCount(#arg0.memories, 0)
	setActive(arg0:findTF("memory", arg0.top), false)
end

local var1 = 3

function var0.return2MemoryGroup(arg0)
	local var0 = arg0.contextData.memoryGroup

	arg0.contextData.memoryGroup = nil
	arg0.memories = nil

	local var1 = 0

	if var0 then
		local var2 = 0

		for iter0, iter1 in ipairs(arg0.memoryGroups) do
			if iter1.id == var0 then
				var2 = iter0

				break
			end
		end

		if var2 >= 0 then
			local var3 = arg0.memoryList
			local var4 = arg0.memoriesGrid.cellSize.y + arg0.memoriesGrid.spacing.y
			local var5 = var4 * math.ceil(#arg0.memoryGroups / var1)

			var1 = (var4 * math.floor((var2 - 1) / var1) + var3.paddingFront) / (var5 - arg0.memoryViewport.rect.height)
			var1 = Mathf.Clamp01(var1)
		end
	end

	arg0.memoryList:SetTotalCount(#arg0.memoryGroups, var1)
	setActive(arg0:findTF("memory", arg0.top), true)
end

function var0.initMemoryPanel(arg0)
	local var0 = getProxy(ActivityProxy):getActivityById(ActivityConst.QIXI_ACTIVITY_ID)

	if var0 and not var0:isEnd() then
		local var1 = var0:getConfig("config_data")
		local var2 = _.flatten(var1)
		local var3 = var2[#var2]
		local var4 = getProxy(TaskProxy):getTaskById(var3)

		if var4 and not var4:isFinish() then
			pg.NewStoryMgr.GetInstance():Play("HOSHO8", function()
				arg0:emit(CollectionScene.ACTIVITY_OP, {
					cmd = 2,
					activity_id = var0.id
				})
			end, true)
		end
	end

	arg0:memoryFilter()
end

function var0.onInitMemory(arg0, arg1)
	if arg0.exited then
		return
	end

	local var0 = MemoryCard.New(arg1)

	onButton(arg0, var0.go, function()
		if var0.info then
			if var0.isGroup then
				arg0:showSubMemories(var0.info)
			elseif var0.info.is_open == 1 or pg.NewStoryMgr.GetInstance():IsPlayed(var0.info.story, true) then
				arg0:playMemory(var0.info)
			end
		end
	end, SOUND_BACK)

	arg0.memoryItems[arg1] = var0
end

function var0.onUpdateMemory(arg0, arg1, arg2)
	if arg0.exited then
		return
	end

	local var0 = arg0.memoryItems[arg2]

	if not var0 then
		arg0:onInitMemory(arg2)

		var0 = arg0.memoryItems[arg2]
	end

	if arg0.memories then
		var0:update(false, arg0.memories[arg1 + 1])
	else
		var0:update(true, arg0.memoryGroups[arg1 + 1])
	end

	local var1 = {
		var0.lock,
		var0.normal,
		var0.group
	}

	_.any(var1, function(arg0)
		local var0 = isActive(arg0)

		if var0 then
			var0.go:GetComponent(typeof(Button)).targetGraphic = arg0:GetComponent(typeof(Image))
		end

		return var0
	end)
end

function var0.onReturnMemory(arg0, arg1, arg2)
	if arg0.exited then
		return
	end

	local var0 = arg0.memoryItems[arg2]

	if var0 then
		var0:clear()
	end
end

function var0.playMemory(arg0, arg1)
	if arg1.type == 1 then
		local var0 = findTF(arg0.memoryMask, "pic")

		if string.len(arg1.mask) > 0 then
			setActive(var0, true)

			var0:GetComponent(typeof(Image)).sprite = LoadSprite(arg1.mask)
		else
			setActive(var0, false)
		end

		setActive(arg0.memoryMask, true)
		pg.NewStoryMgr.GetInstance():Play(arg1.story, function()
			setActive(arg0.memoryMask, false)
		end, true)
	elseif arg1.type == 2 then
		local var1 = pg.NewStoryMgr.GetInstance():StoryName2StoryId(arg1.story)

		arg0:emit(var0.BEGIN_STAGE, {
			memory = true,
			system = SYSTEM_PERFORM,
			stageId = var1
		})
	end
end

function var0.memoryFilter(arg0)
	arg0.memoryGroups = {}

	for iter0, iter1 in ipairs(pg.memory_group.all) do
		local var0 = pg.memory_group[iter1]

		if arg0.memoryFilterIndex[var0.type] then
			table.insert(arg0.memoryGroups, var0)
		end
	end

	table.sort(arg0.memoryGroups, function(arg0, arg1)
		return arg0.id < arg1.id
	end)
	arg0.memoryList:SetTotalCount(#arg0.memoryGroups, 0)
end

function var0.willExit(arg0)
	if arg0.bulinTip then
		arg0.bulinTip:Destroy()

		arg0.bulinTip = nil
	end

	if arg0.tweens then
		cancelTweens(arg0.tweens)
	end

	pg.UIMgr.GetInstance():UnOverlayPanel(arg0.blurPanel, arg0._tf)

	if arg0.bonusPanel.gameObject.activeSelf then
		arg0:closeBonus()
	end

	Destroy(arg0.bonusPanel)

	arg0.bonusPanel = nil

	for iter0, iter1 in pairs(arg0.cardItems) do
		iter1:clear()
	end

	if arg0.resPanel then
		arg0.resPanel:exit()

		arg0.resPanel = nil
	end

	if arg0.galleryView then
		arg0.galleryView:Destroy()

		arg0.galleryView = nil
	end

	if arg0.musicView then
		arg0.musicView:Destroy()

		arg0.musicView = nil
	end

	if arg0.mangaView then
		arg0.mangaView:Destroy()

		arg0.mangaView = nil
	end
end

function var0.initGalleryPanel(arg0)
	if not arg0.galleryView then
		arg0.galleryView = GalleryView.New(arg0.galleryPanelContainer, arg0.event, arg0.contextData)

		arg0.galleryView:Reset()
		arg0.galleryView:Load()
	end
end

function var0.initMusicPanel(arg0)
	if not arg0.musicView then
		arg0.musicView = MusicCollectionView.New(arg0.musicPanelContainer, arg0.event, arg0.contextData)

		arg0.musicView:Reset()
		arg0.musicView:Load()
		pg.CriMgr.GetInstance():StopBGM()
	end
end

function var0.initMangaPanel(arg0)
	if not arg0.mangaView then
		arg0.mangaView = MangaView.New(arg0.mangaPanelContainer, arg0.event, arg0.contextData)

		arg0.mangaView:Reset()
		arg0.mangaView:Load()
	end
end

function var0.initEvents(arg0)
	arg0:bind(GalleryConst.OPEN_FULL_SCREEN_PIC_VIEW, function(arg0, arg1)
		arg0:emit(CollectionMediator.EVENT_OPEN_FULL_SCREEN_PIC_VIEW, arg1)
	end)
	arg0:bind(var0.UPDATE_RED_POINT, function()
		arg0:updateCollectNotices()
	end)
end

function var0.onBackPressed(arg0)
	pg.CriMgr.GetInstance():PlaySoundEffect_V3(SFX_CANCEL)

	if arg0.bonusPanel.gameObject.activeSelf then
		arg0:closeBonus()

		return
	end

	if arg0.galleryView then
		if arg0.galleryView:onBackPressed() == true then
			arg0.galleryView:Destroy()

			arg0.galleryView = nil
		else
			return
		end
	end

	if arg0.musicView then
		if arg0.musicView:onBackPressed() == true then
			arg0.musicView:Destroy()

			arg0.musicView = nil
		else
			return
		end
	end

	if arg0.mangaView then
		if arg0.mangaView:onBackPressed() == true then
			arg0.mangaView:Destroy()

			arg0.mangaView = nil
		else
			return
		end
	end

	triggerButton(arg0.backBtn)
end

return var0
