local var0_0 = class("MusicCollectionView", import("..base.BaseSubView"))

function var0_0.getUIName(arg0_1)
	return "MusicCollectionUI"
end

function var0_0.OnInit(arg0_2)
	arg0_2:initData()
	arg0_2:findUI()
	arg0_2:addListener()
	arg0_2:initPlateListPanel()
	arg0_2:Show()
	arg0_2:recoverRunData()
	arg0_2:tryShowTipMsgBox()
end

function var0_0.OnDestroy(arg0_3)
	arg0_3.bgmMgr:UnregisterMusicCallback(arg0_3.__cname)
	arg0_3.resLoader:Clear()
	arg0_3:closeAlbumListPanel(true)
end

function var0_0.onBackPressed(arg0_4)
	if isActive(arg0_4.albumListPanel) then
		arg0_4:closeAlbumListPanel()

		return false
	else
		return true
	end
end

function var0_0.initData(arg0_5)
	arg0_5.bgmMgr = pg.BgmMgr.GetInstance()
	arg0_5.appreciateProxy = getProxy(AppreciateProxy)
	arg0_5.albumNames = underscore.to_array(pg.music_album.all)

	table.sort(arg0_5.albumNames, CompareFuncs({
		function(arg0_6)
			return -pg.music_album[arg0_6].order
		end
	}))

	arg0_5.albumNames = underscore.map(arg0_5.albumNames, function(arg0_7)
		return pg.music_album[arg0_7].album_name
	end)
	arg0_5.plateTFList = {}
	arg0_5.albumTFList = {}
	arg0_5.likeDic = {}
	arg0_5.likeIds = {}
	arg0_5.curMidddleIndex = 1
	arg0_5.isPlayingAni = false
	arg0_5.resLoader = AutoLoader.New()
end

function var0_0.saveRunData(arg0_8)
	arg0_8.appreciateProxy:updateMusicRunData(arg0_8.sortValue, arg0_8.curMidddleIndex, arg0_8.likeValue)
end

function var0_0.recoverRunData(arg0_9)
	local var0_9 = arg0_9.appreciateProxy:getMusicRunData()

	arg0_9.sortValue = var0_9.sortValue
	arg0_9.curMidddleIndex = var0_9.middleIndex
	arg0_9.likeValue = var0_9.likeValue
	arg0_9.albumSortValue = "asc"
	arg0_9.likeIds = arg0_9.appreciateProxy:getAlbumMusicList("favor")

	for iter0_9, iter1_9 in ipairs(arg0_9.likeIds) do
		arg0_9.likeDic[iter1_9] = true
	end

	arg0_9.lScrollPageSC.MiddleIndexOnInit = arg0_9.curMidddleIndex - 1

	arg0_9:updatePlateListPanel()

	if getProxy(AppreciateProxy):CanPlayMainMusicPlayer() then
		arg0_9:NewMusicPlayer(arg0_9.appreciateProxy:getMainPlayerAlbumName())
	else
		arg0_9:NewMusicPlayer(arg0_9.tempPlateList[arg0_9.curMidddleIndex])
	end

	arg0_9.bgmMgr:RegisterMusicCallback(arg0_9.__cname, "TempMusicPlayer", {
		startCall = function(arg0_10)
			if arg0_9.plateTFList[arg0_9.curMidddleIndex] then
				arg0_9:updatePlateList(arg0_9.plateTFList[arg0_9.curMidddleIndex], arg0_9.curMidddleIndex)
			end

			arg0_9:updateAlbumListPanel()
			arg0_9:updatePlayPanel(arg0_10)
		end,
		progressCall = function(arg0_11)
			if arg0_9.onDrag then
				return
			end

			arg0_9:updatePlayProgress(arg0_11)
		end,
		noPlayCall = function()
			arg0_9:NewMusicPlayer(arg0_9.tempPlateList[arg0_9.curMidddleIndex])
		end
	})
	arg0_9:updateAlbumListPanel()
	arg0_9:updateLikeToggle()
	arg0_9:updatePlayType()
end

function var0_0.findUI(arg0_13)
	setLocalPosition(arg0_13._tf, Vector2.zero)

	arg0_13._tf.anchorMin = Vector2.zero
	arg0_13._tf.anchorMax = Vector2.one
	arg0_13._tf.offsetMax = Vector2.zero
	arg0_13._tf.offsetMin = Vector2.zero
	arg0_13.topPanel = arg0_13._tf:Find("TopPanel")
	arg0_13.likeFilteToggle = arg0_13.topPanel:Find("LikeBtn")

	setActive(arg0_13.likeFilteToggle, true)

	arg0_13.serchInputText = arg0_13.topPanel:Find("serch")

	setText(arg0_13.serchInputText:Find("Placeholder"), i18n("NewMusic_2"))

	arg0_13.plateListPanel = arg0_13._tf:Find("PlateList")
	arg0_13.plateTpl = arg0_13.plateListPanel:Find("Plate")

	setActive(arg0_13.plateTpl, false)
	setText(arg0_13.plateTpl:Find("list/panel/view/empty/icon/Text"), i18n("NewMusic_3"))

	arg0_13.lScrollPageSC = GetComponent(arg0_13.plateListPanel, "LScrollPage")
	arg0_13.playPanel = arg0_13._tf:Find("PLayPanel")
	arg0_13.playPanelNameText = arg0_13.playPanel:Find("NameText")
	arg0_13.likeToggle = arg0_13.playPanel:Find("LikeBtn")
	arg0_13.likeOnImg = arg0_13.likeToggle:Find("On")
	arg0_13.songImg = arg0_13.playPanel:Find("SongImg/face")
	arg0_13.pauseBtn = arg0_13.playPanel:Find("PlayingBtn")
	arg0_13.playBtn = arg0_13.playPanel:Find("StopingBtn")
	arg0_13.playDesc = arg0_13.playPanel:Find("PlayDesc")
	arg0_13.nextBtn = arg0_13.playPanel:Find("NextBtn")
	arg0_13.preBtn = arg0_13.playPanel:Find("PreBtn")
	arg0_13.playProgressBar = arg0_13.playPanel:Find("Progress")
	arg0_13.nowTimeText = arg0_13.playProgressBar:Find("NowTimeText")
	arg0_13.totalTimeText = arg0_13.playProgressBar:Find("TotalTimeText")
	arg0_13.playSliderSC = GetComponent(arg0_13.playProgressBar, "LSlider")
	arg0_13.listBtn = arg0_13.playPanel:Find("ListBtn")

	setActive(arg0_13.listBtn:Find("on"), false)
	setActive(arg0_13.listBtn:Find("off"), true)

	arg0_13.albumListPanel = arg0_13._tf:Find("AlbumListPanel")
	arg0_13.closeBtn = arg0_13.albumListPanel:Find("BG")
	arg0_13.panel = arg0_13.albumListPanel:Find("Panel")

	setText(arg0_13.panel:Find("top/name"), i18n("NewMusic_6"))

	arg0_13.albumToggle = arg0_13.panel:Find("bottom/sort_btn")
	arg0_13.albumInputText = arg0_13.panel:Find("bottom/serch")

	setText(arg0_13.albumInputText:Find("Placeholder"), i18n("NewMusic_2"))

	arg0_13.albumContainer = arg0_13.panel:Find("middle/Content")
	arg0_13.albumItemList = UIItemList.New(arg0_13.albumContainer, arg0_13.albumContainer:GetChild(0))

	arg0_13.albumItemList:make(function(arg0_14, arg1_14, arg2_14)
		arg1_14 = arg1_14 + 1

		if arg0_14 == UIItemList.EventUpdate then
			arg0_13.albumTFList[arg1_14] = arg2_14

			arg0_13:updateAlbumTF(arg2_14, arg1_14)
		end
	end)

	arg0_13.likeFilteOnImg = arg0_13.likeFilteToggle:Find("TextLike/On")
	arg0_13.playLoopBtn = arg0_13.playPanel:Find("PlayTypeBtn")
end

function var0_0.addListener(arg0_15)
	onButton(arg0_15, arg0_15.listBtn, function()
		arg0_15:openAlbumListPanel()
	end, SFX_PANEL)
	onButton(arg0_15, arg0_15.closeBtn, function()
		arg0_15:closeAlbumListPanel()
	end, SFX_PANEL)
	onButton(arg0_15, arg0_15.albumToggle, function()
		if arg0_15.albumSortValue == "asc" then
			arg0_15.albumSortValue = "desc"
		elseif arg0_15.albumSortValue == "desc" then
			arg0_15.albumSortValue = "asc"
		end

		arg0_15:updateAlbumListPanel()
	end, SFX_PANEL)
	onButton(arg0_15, arg0_15.likeFilteToggle, function()
		arg0_15.likeValue = 1 - arg0_15.likeValue
		arg0_15.curMidddleIndex = 1

		arg0_15:saveRunData()
		arg0_15:updateLikeToggle()
		arg0_15:updatePlateListPanel()
	end, SFX_PANEL)
	onButton(arg0_15, arg0_15.playBtn, function()
		if not arg0_15.musicPlayer then
			return
		end

		arg0_15.musicPlayer:Resume()
		SetActive(arg0_15.pauseBtn, true)
		SetActive(arg0_15.playBtn, false)
		setActive(arg0_15.playDesc, true)
	end, SFX_PANEL)
	onButton(arg0_15, arg0_15.pauseBtn, function()
		if not arg0_15.musicPlayer then
			return
		end

		arg0_15.musicPlayer:Pause()
		SetActive(arg0_15.pauseBtn, false)
		SetActive(arg0_15.playBtn, true)
		setActive(arg0_15.playDesc, false)
	end, SFX_PANEL)
	onButton(arg0_15, arg0_15.preBtn, function()
		if not arg0_15.musicPlayer then
			return
		end

		if arg0_15.isPlayingAni then
			return
		end

		arg0_15.musicPlayer:Last()
	end, SFX_PANEL)
	onButton(arg0_15, arg0_15.nextBtn, function()
		if not arg0_15.musicPlayer then
			return
		end

		if arg0_15.isPlayingAni then
			return
		end

		arg0_15.musicPlayer:Next()
	end, SFX_PANEL)
	onButton(arg0_15, arg0_15.likeToggle, function()
		local var0_24 = arg0_15.musicPlayer:GetCurrentMusicId()
		local var1_24 = pg.music_collect_config[var0_24].id

		pg.m02:sendNotification(GAME.APPRECIATE_MUSIC_LIKE, {
			musicID = var1_24,
			isAdd = arg0_15.likeDic[var1_24] and 1 or 0
		})
		arg0_15:ChangeLike(var1_24)
		arg0_15:updateLikeToggle()
		setActive(arg0_15.likeOnImg, arg0_15.likeDic[var1_24])
		arg0_15:updatePlateList(arg0_15.plateTFList[arg0_15.curMidddleIndex], arg0_15.curMidddleIndex)
	end, SFX_PANEL)

	local var0_15

	arg0_15.playSliderSC:AddPointDownFunc(function(arg0_25)
		if arg0_15.onDrag then
			return
		end

		arg0_15.onDrag = true
		var0_15 = arg0_15.musicPlayer:IsPaused()

		if not var0_15 then
			arg0_15.musicPlayer:Pause()
		end
	end)
	arg0_15.playSliderSC:AddPointUpFunc(function(arg0_26)
		if not arg0_15.onDrag then
			return
		end

		arg0_15.onDrag = false

		arg0_15.musicPlayer:SetProgress(arg0_15.playSliderSC.value)

		if not var0_15 then
			arg0_15.musicPlayer:Resume()
		end
	end)
	onButton(arg0_15, arg0_15.playLoopBtn, function()
		local var0_27 = getProxy(AppreciateProxy):getMusicPlayerLoopType()

		switch(var0_27, {
			list = function()
				var0_27 = "random"
			end,
			random = function()
				var0_27 = "one"
			end,
			one = function()
				var0_27 = "list"
			end
		})
		pg.m02:sendNotification(GAME.APPRECIATE_CHANGE_MUSIC_PLAY_LOOP_TYPE, {
			loopType = var0_27
		})
		arg0_15:updatePlayType(var0_27)

		if arg0_15.musicPlayer then
			arg0_15.musicPlayer.loopType = var0_27
		end
	end, SFX_PANEL)
	onInputChanged(arg0_15, arg0_15.serchInputText, function(arg0_31)
		if arg0_15.likeValue ~= MusicCollectionConst.Filte_Like_Value then
			return
		end

		arg0_15:updatePlateList(arg0_15.plateTFList[arg0_15.curMidddleIndex], arg0_15.curMidddleIndex)
	end)
	onInputChanged(arg0_15, arg0_15.albumInputText, function(arg0_32)
		arg0_15:updateAlbumListPanel()
	end)
end

function var0_0.tryShowTipMsgBox(arg0_33)
	if arg0_33.appreciateProxy:isMusicHaveNewRes() then
		local function var0_33()
			arg0_33.lScrollPageSC:MoveToItemID(MusicCollectionConst.AutoScrollIndex - 1)
			PlayerPrefs.SetInt("musicVersion", MusicCollectionConst.Version)
			arg0_33:emit(CollectionScene.UPDATE_RED_POINT)
		end

		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			hideClose = true,
			hideNo = true,
			content = i18n("res_music_new_tip", MusicCollectionConst.NewCount),
			onYes = var0_33,
			onCancel = var0_33,
			onClose = var0_33
		})
	end
end

function var0_0.initPlateListPanel(arg0_35)
	function arg0_35.lScrollPageSC.itemInitedCallback(arg0_36, arg1_36)
		local var0_36 = arg0_36 + 1

		arg0_35.plateTFList[var0_36] = arg1_36

		arg1_36:GetComponent("DftAniEvent"):SetEndEvent(function()
			local var0_37 = arg0_35.animCallback

			arg0_35.animCallback = nil

			existCall(var0_37)
		end)
		arg0_35:updatePlateTF(arg1_36, var0_36)
	end

	function arg0_35.lScrollPageSC.itemClickCallback(arg0_38, arg1_38)
		local var0_38 = arg0_38 + 1

		if arg0_35.curMidddleIndex ~= var0_38 and not arg0_35.isPlayingAni then
			arg0_35:setAniState(true)
			arg0_35:closePlateAni(arg0_35.plateTFList[arg0_35.curMidddleIndex])
			arg0_35.lScrollPageSC:MoveToItemID(arg0_38)
		end
	end

	function arg0_35.lScrollPageSC.itemPitchCallback(arg0_39, arg1_39)
		local var0_39 = arg0_39 + 1

		arg0_35.curMidddleIndex = var0_39

		arg0_35:saveRunData()
		arg0_35:updatePlateList(arg1_39, var0_39)
		arg0_35:playPlateAni(arg1_39, true)
	end

	function arg0_35.lScrollPageSC.itemRecycleCallback(arg0_40, arg1_40)
		arg0_35.plateTFList[arg0_40 + 1] = nil
	end

	addSlip(SLIP_TYPE_HRZ, arg0_35.plateListPanel, function()
		if arg0_35.curMidddleIndex > 1 and not arg0_35.isPlayingAni then
			arg0_35:setAniState(true)
			arg0_35.lScrollPageSC:MoveToItemID(arg0_35.curMidddleIndex - 1 - 1)
			arg0_35:closePlateAni(arg0_35.plateTFList[arg0_35.curMidddleIndex])
		end
	end, function()
		if arg0_35.curMidddleIndex < arg0_35.lScrollPageSC.DataCount and not arg0_35.isPlayingAni then
			arg0_35:setAniState(true)
			arg0_35.lScrollPageSC:MoveToItemID(arg0_35.curMidddleIndex + 1 - 1)
			arg0_35:closePlateAni(arg0_35.plateTFList[arg0_35.curMidddleIndex])
		end
	end)
end

function var0_0.updatePlateListPanel(arg0_43)
	local var0_43 = arg0_43.likeValue == MusicCollectionConst.Filte_Like_Value

	if var0_43 then
		arg0_43.tempPlateList = {
			"favor"
		}
	else
		arg0_43.tempPlateList = arg0_43.albumNames
	end

	setActive(arg0_43.serchInputText, var0_43)
	setActive(arg0_43.listBtn, not var0_43)

	arg0_43.lScrollPageSC.DataCount = #arg0_43.tempPlateList

	arg0_43.lScrollPageSC:Init(arg0_43.curMidddleIndex - 1)
end

function var0_0.updatePlateTF(arg0_44, arg1_44, arg2_44)
	local var0_44 = arg0_44.likeValue == MusicCollectionConst.Filte_Like_Value
	local var1_44 = arg0_44.tempPlateList[arg2_44]
	local var2_44 = var0_44 and arg0_44.likeIds or arg0_44.appreciateProxy:getAlbumMusicList(var1_44)
	local var3_44

	if #var2_44 > 0 then
		local var4_44 = var2_44[#var2_44]
		local var5_44 = pg.music_collect_config[var4_44].album_id

		var3_44 = pg.music_album[var5_44].cover
	end

	setText(arg1_44:Find("PlateImg/empty/Text"), i18n("NewMusic_7"))
	setActive(arg1_44:Find("PlateImg/face"), var3_44)
	setActive(arg1_44:Find("PlateImg/empty"), not var3_44)

	if var3_44 then
		local var6_44 = MusicCollectionConst.MUSIC_COVER_PATH_PREFIX .. var3_44

		arg0_44.resLoader:LoadSprite(var6_44, var3_44, arg1_44:Find("PlateImg/face"), false)
	end

	if arg2_44 == arg0_44.curMidddleIndex then
		arg0_44:updatePlateList(arg1_44, arg2_44)
	end
end

function var0_0.updatePlateList(arg0_45, arg1_45, arg2_45)
	local var0_45 = arg0_45.likeValue == MusicCollectionConst.Filte_Like_Value
	local var1_45 = arg0_45.tempPlateList[arg2_45]
	local var2_45 = var0_45 and arg0_45.likeIds or arg0_45.appreciateProxy:getAlbumMusicList(var1_45)
	local var3_45 = arg1_45:Find("list")

	setText(var3_45:Find("album_name"), var1_45 == "favor" and i18n("NewMusic_5") or var1_45)

	local var4_45 = arg0_45.appreciateProxy:getMainPlayerAlbumName() == var1_45
	local var5_45 = var3_45:Find("btn_home")

	setActive(var5_45:Find("off"), not var4_45)
	setActive(var5_45:Find("on"), var4_45)
	onButton(arg0_45, var5_45, function()
		if arg0_45.appreciateProxy:getMainPlayerAlbumName() == var1_45 then
			pg.m02:sendNotification(GAME.APPRECIATE_CHANGE_MAIN_PLAY_ALBUM, {
				albumName = "none"
			})
			setActive(var5_45:Find("off"), true)
			setActive(var5_45:Find("on"), false)
		else
			pg.m02:sendNotification(GAME.APPRECIATE_CHANGE_MAIN_PLAY_ALBUM, {
				albumName = var1_45
			})
			setActive(var5_45:Find("off"), false)
			setActive(var5_45:Find("on"), true)
		end

		arg0_45:updateAlbumListPanel()
	end, SFX_CONFIRM)

	local var6_45 = var3_45:Find("panel/view/container")

	local function var7_45(arg0_47)
		local var0_47

		if not var0_45 or arg0_45.sortValue == MusicCollectionConst.Sort_Order_Down then
			var0_47 = underscore.to_array(var2_45)
		elseif arg0_45.sortValue == MusicCollectionConst.Sort_Order_Up then
			var0_47 = underscore.reverse(var2_45)
		else
			assert(false)
		end

		local var1_47 = string.lower(getInputText(arg0_45.serchInputText))
		local var2_47 = var0_45 and underscore.filter(var0_47, function(arg0_48)
			local var0_48 = pg.music_collect_config[arg0_48].name

			return not var1_47 or var1_47 == "" or string.find(string.lower(var0_48), var1_47)
		end) or underscore.to_array(var0_47)

		UIItemList.StaticAlign(var6_45, var6_45:GetChild(0), #var2_47, function(arg0_49, arg1_49, arg2_49)
			arg1_49 = arg1_49 + 1

			if arg0_49 == UIItemList.EventUpdate then
				local var0_49 = pg.music_collect_config[var2_47[arg1_49]]

				if var0_45 and arg0_45.sortValue == MusicCollectionConst.Sort_Order_Up then
					setText(arg2_49:Find("mark/Text"), string.format("%02d", #var2_47 - arg1_49 + 1))
				else
					setText(arg2_49:Find("mark/Text"), string.format("%02d", arg1_49))
				end

				changeToScrollText(arg2_49:Find("name"), var0_49.name)
				setText(arg2_49:Find("time"), arg0_45:descTime(var0_49.music_time))
				setActive(arg2_49:Find("line"), arg1_49 < #var2_47)
				onButton(arg0_45, arg2_49:Find("like"), function()
					local var0_50 = var0_49.id

					pg.m02:sendNotification(GAME.APPRECIATE_MUSIC_LIKE, {
						musicID = var0_50,
						isAdd = arg0_45.likeDic[var0_50] and 1 or 0
					})
					arg0_45:ChangeLike(var0_50)
					arg0_45:updateLikeToggle()
					arg0_45:updatePlateList(arg1_45, arg2_45)

					if arg0_45.musicPlayer and arg0_45.musicPlayer:GetCurrentMusicId() == var0_50 then
						setActive(arg0_45.likeOnImg, arg0_45.likeDic[var0_50])
					end
				end, SFX_CONFIRM)
				setActive(arg2_49:Find("like/off"), not arg0_45.likeDic[var0_49.id])
				setActive(arg2_49:Find("like/on"), arg0_45.likeDic[var0_49.id])

				local var1_49 = arg0_45.musicPlayer and arg0_45.musicPlayer.albumName == var1_45 and arg0_45.musicPlayer:GetCurrentMusicId() == var0_49.id

				setActive(arg2_49:Find("mark/Text"), not var1_49)
				setActive(arg2_49:Find("mark/icon"), var1_49)
				setTextColor(arg2_49:Find("name/subText"), var1_49 and Color.NewHex("FF596E") or Color.white)
				setTextColor(arg2_49:Find("time"), var1_49 and Color.NewHex("FF596E") or Color.white)
				onButton(arg0_45, arg2_49, function()
					arg0_45:NewMusicPlayer(var1_45, var0_47, var0_49.id)
				end, SFX_CONFIRM)
			end
		end)
		setActive(var3_45:Find("panel/view/empty"), #var2_47 == 0)
	end

	setActive(var3_45:Find("panel/sort"), var0_45)

	if var0_45 then
		local var8_45 = var3_45:Find("panel/sort/bg/asc")
		local var9_45 = var3_45:Find("panel/sort/bg/desc")

		setText(var8_45:Find("Text"), i18n("word_asc"))
		onToggle(arg0_45, var8_45, function(arg0_52)
			if arg0_52 then
				arg0_45.sortValue = MusicCollectionConst.Sort_Order_Up

				arg0_45:saveRunData()
				var7_45(not arg0_52)
			end

			setImageAlpha(var8_45, arg0_52 and 1 or 0)
			setCanvasGroupAlpha(var8_45, arg0_52 and 1 or 0.3)
		end, SFX_PANEL)
		setText(var9_45:Find("Text"), i18n("word_desc"))
		onToggle(arg0_45, var9_45, function(arg0_53)
			if arg0_53 then
				arg0_45.sortValue = MusicCollectionConst.Sort_Order_Down

				arg0_45:saveRunData()
				var7_45(arg0_53)
			end

			setImageAlpha(var9_45, arg0_53 and 1 or 0)
			setCanvasGroupAlpha(var9_45, arg0_53 and 1 or 0.3)
		end, SFX_PANEL)

		if arg0_45.sortValue == MusicCollectionConst.Sort_Order_Up then
			triggerToggle(var8_45, true)
		else
			triggerToggle(var9_45, true)
		end
	else
		var7_45(false)
	end
end

function var0_0.updateAlbumListPanel(arg0_54)
	local var0_54 = string.lower(getInputText(arg0_54.albumInputText))

	arg0_54.tempAlbumList = underscore.filter(arg0_54.albumNames, function(arg0_55)
		if string.find(string.lower(arg0_55), var0_54) then
			return true
		else
			return underscore.any(arg0_54.appreciateProxy:getAlbumMusicList(arg0_55), function(arg0_56)
				return string.find(string.lower(pg.music_collect_config[arg0_56].name), var0_54)
			end)
		end
	end)

	arg0_54.albumItemList:align(#arg0_54.tempAlbumList)
	setActive(arg0_54.panel:Find("middle/empty"), #arg0_54.tempAlbumList == 0)
	setActive(arg0_54.albumToggle:Find("asc"), arg0_54.albumSortValue == "asc")
	setActive(arg0_54.albumToggle:Find("desc"), arg0_54.albumSortValue == "desc")
end

function var0_0.updateAlbumTF(arg0_57, arg1_57, arg2_57)
	if arg0_57.albumSortValue == "desc" then
		arg2_57 = #arg0_57.tempAlbumList + 1 - arg2_57
	end

	local var0_57 = arg0_57.tempAlbumList[arg2_57]

	setText(arg1_57:Find("index"), string.format("%02d", arg2_57))

	local var1_57 = arg0_57.appreciateProxy:getAlbumMusicList(var0_57)
	local var2_57 = pg.music_collect_config[var1_57[1]].album_id
	local var3_57 = pg.music_album[var2_57].cover
	local var4_57 = MusicCollectionConst.MUSIC_COVER_PATH_PREFIX .. var3_57

	arg0_57.resLoader:LoadSprite(var4_57, var3_57, arg1_57:Find("icon/face"), false)
	changeToScrollText(arg1_57:Find("name"), var0_57)
	setActive(arg1_57:Find("icon/main"), var0_57 == arg0_57.appreciateProxy:getMainPlayerAlbumName())

	local var5_57 = arg0_57.musicPlayer and arg0_57.musicPlayer.albumName == var0_57

	setActive(arg1_57:Find("playing"), var5_57)
	setActive(arg1_57:Find("line"), arg2_57 < #arg0_57.tempAlbumList)
	onButton(arg0_57, arg1_57, function()
		arg0_57:closeAlbumListPanel()

		arg0_57.curMidddleIndex = arg2_57

		if arg0_57.likeValue == MusicCollectionConst.Filte_Like_Value then
			arg0_57.likeValue = MusicCollectionConst.Filte_Normal_Value

			arg0_57:updatePlateListPanel()
		else
			arg0_57.lScrollPageSC:Init(arg0_57.curMidddleIndex - 1)
		end

		arg0_57:saveRunData()
	end, SFX_PANEL)
end

function var0_0.updateLikeToggle(arg0_59)
	setActive(arg0_59.likeFilteOnImg, arg0_59.likeValue == MusicCollectionConst.Filte_Like_Value)

	local var0_59 = underscore.reduce(underscore.keys(arg0_59.likeDic), 0, function(arg0_60, arg1_60)
		return arg0_60 + (arg0_59.likeDic[arg1_60] and 1 or 0)
	end)

	setText(arg0_59.likeFilteToggle:Find("TextNum"), string.format("(%d)", var0_59))
end

function var0_0.updatePlayPanel(arg0_61, arg1_61)
	local var0_61 = arg0_61.musicPlayer:GetCurrentMusicId()
	local var1_61 = pg.music_collect_config[var0_61]
	local var2_61 = var1_61.album_id
	local var3_61 = pg.music_album[var2_61].cover
	local var4_61 = MusicCollectionConst.MUSIC_COVER_PATH_PREFIX .. var3_61

	arg0_61.resLoader:LoadSprite(var4_61, var3_61, arg0_61.songImg, false)

	local var5_61 = var1_61.name

	changeToScrollText(arg0_61.playPanelNameText, var5_61)
	setActive(arg0_61.likeOnImg, arg0_61.likeDic[var1_61.id])
	setActive(arg0_61.playBtn, false)
	setActive(arg0_61.playDesc, true)
	setActive(arg0_61.pauseBtn, true)
	setSlider(arg0_61.playProgressBar, 0, arg1_61, 0)
	setText(arg0_61.totalTimeText, arg0_61:descTime(arg1_61))
	setActive(arg0_61.nowTimeText, true)
	setActive(arg0_61.totalTimeText, true)
end

function var0_0.updatePlayType(arg0_62, arg1_62)
	arg1_62 = arg1_62 or getProxy(AppreciateProxy):getMusicPlayerLoopType()

	eachChild(arg0_62.playLoopBtn, function(arg0_63, arg1_63)
		setActive(arg0_63, arg0_63.name == arg1_62)
	end)
end

function var0_0.updatePlayProgress(arg0_64, arg1_64)
	arg0_64.playSliderSC:SetValueWithoutEvent(arg1_64)
	setText(arg0_64.nowTimeText, arg0_64:descTime(arg1_64))
end

function var0_0.playPlateAni(arg0_65, arg1_65, arg2_65, arg3_65, arg4_65)
	arg0_65:setAniState(true)
	setActive(arg1_65:Find("list"), true)

	function arg0_65.animCallback()
		arg0_65:setAniState(false)
	end

	quickPlayAnimation(arg1_65, "anim_MusicCollectionUI_Plate_expand")
end

function var0_0.closePlateAni(arg0_67, arg1_67)
	arg0_67:setAniState(true)

	function arg0_67.animCallback()
		setActive(arg1_67:Find("list"), false)
		arg0_67:setAniState(false)
	end

	quickPlayAnimation(arg1_67, "anim_MusicCollectionUI_Plate_retract")
end

function var0_0.setAniState(arg0_69, arg1_69)
	arg0_69.isPlayingAni = arg1_69
end

function var0_0.openAlbumListPanel(arg0_70)
	setActive(arg0_70.albumListPanel, true)
	setActive(arg0_70.listBtn:Find("on"), true)
	setActive(arg0_70.listBtn:Find("off"), false)
end

function var0_0.closeAlbumListPanel(arg0_71, arg1_71)
	setActive(arg0_71.albumListPanel, false)
	setActive(arg0_71.listBtn:Find("on"), false)
	setActive(arg0_71.listBtn:Find("off"), true)
end

function var0_0.checkupdateAlbumTF(arg0_72)
	if #arg0_72.albumTFList > 0 then
		arg0_72:updateAlbumTF(arg0_72.albumTFList[arg0_72.curMidddleIndex], arg0_72.curMidddleIndex)
	end
end

function var0_0.NewMusicPlayer(arg0_73, arg1_73, arg2_73, arg3_73)
	local var0_73 = {
		loopType = getProxy(AppreciateProxy):getMusicPlayerLoopType(),
		albumName = arg1_73,
		list = arg2_73 or nil,
		index = arg3_73 and table.indexof(arg2_73, arg3_73) or nil
	}

	arg0_73.bgmMgr:TempPlay("TempMusicPlayer", var0_73)

	arg0_73.musicPlayer = arg0_73.bgmMgr:GetMusicPlayer()
end

function var0_0.ChangeLike(arg0_74, arg1_74)
	arg0_74.likeDic[arg1_74] = not arg0_74.likeDic[arg1_74]

	if arg0_74.likeDic[arg1_74] then
		table.insert(arg0_74.likeIds, arg1_74)
	else
		table.removebyvalue(arg0_74.likeIds, arg1_74)
	end
end

function var0_0.tryPlayMusic(arg0_75)
	triggerButton(arg0_75.playBtn)
end

function var0_0.tryPauseMusic(arg0_76)
	triggerButton(arg0_76.pauseBtn)
end

function var0_0.descTime(arg0_77, arg1_77)
	local var0_77 = math.floor(arg1_77 / 1000)
	local var1_77 = math.floor(var0_77 / 3600)
	local var2_77 = var0_77 - var1_77 * 3600
	local var3_77 = math.floor(var2_77 / 60)
	local var4_77 = var2_77 % 60

	if var1_77 ~= 0 then
		return string.format("%02d:%02d:%02d", var1_77, var3_77, var4_77)
	else
		return string.format("%02d:%02d", var3_77, var4_77)
	end
end

return var0_0
