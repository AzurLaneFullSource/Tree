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
	arg0_5.albumNames = underscore.keys(pg.music_collect_config.get_id_list_by_album_name)

	table.sort(arg0_5.albumNames, CompareFuncs({
		function(arg0_6)
			return pg.music_collect_config.get_id_list_by_album_name[arg0_6][1]
		end
	}))

	arg0_5.plateTFList = {}
	arg0_5.albumTFList = {}
	arg0_5.likeDic = {}
	arg0_5.likeIds = {}
	arg0_5.curMidddleIndex = 1
	arg0_5.isPlayingAni = false
	arg0_5.resLoader = AutoLoader.New()
end

function var0_0.saveRunData(arg0_7)
	arg0_7.appreciateProxy:updateMusicRunData(arg0_7.sortValue, arg0_7.curMidddleIndex, arg0_7.likeValue)
end

function var0_0.recoverRunData(arg0_8)
	local var0_8 = arg0_8.appreciateProxy:getMusicRunData()

	arg0_8.sortValue = var0_8.sortValue
	arg0_8.curMidddleIndex = var0_8.middleIndex
	arg0_8.likeValue = var0_8.likeValue
	arg0_8.albumSortValue = "asc"
	arg0_8.likeIds = arg0_8.appreciateProxy:getAlbumMusicList("favor")

	for iter0_8, iter1_8 in ipairs(arg0_8.likeIds) do
		arg0_8.likeDic[iter1_8] = true
	end

	arg0_8.lScrollPageSC.MiddleIndexOnInit = arg0_8.curMidddleIndex - 1

	arg0_8:updatePlateListPanel()

	if getProxy(AppreciateProxy):CanPlayMainMusicPlayer() then
		arg0_8:NewMusicPlayer(arg0_8.appreciateProxy:getMainPlayerAlbumName())
	else
		arg0_8:NewMusicPlayer(arg0_8.tempPlateList[arg0_8.curMidddleIndex])
	end

	arg0_8.bgmMgr:RegisterMusicCallback(arg0_8.__cname, "TempMusicPlayer", {
		startCall = function(arg0_9)
			if arg0_8.plateTFList[arg0_8.curMidddleIndex] then
				arg0_8:updatePlateList(arg0_8.plateTFList[arg0_8.curMidddleIndex], arg0_8.curMidddleIndex)
			end

			arg0_8:updateAlbumListPanel()
			arg0_8:updatePlayPanel(arg0_9)
		end,
		progressCall = function(arg0_10)
			if arg0_8.onDrag then
				return
			end

			arg0_8:updatePlayProgress(arg0_10)
		end,
		noPlayCall = function()
			arg0_8:NewMusicPlayer(arg0_8.tempPlateList[arg0_8.curMidddleIndex])
		end
	})
	arg0_8:updateAlbumListPanel()
	arg0_8:updateLikeToggle()
	arg0_8:updatePlayType()
end

function var0_0.findUI(arg0_12)
	setLocalPosition(arg0_12._tf, Vector2.zero)

	arg0_12._tf.anchorMin = Vector2.zero
	arg0_12._tf.anchorMax = Vector2.one
	arg0_12._tf.offsetMax = Vector2.zero
	arg0_12._tf.offsetMin = Vector2.zero
	arg0_12.topPanel = arg0_12:findTF("TopPanel")
	arg0_12.likeFilteToggle = arg0_12:findTF("LikeBtn", arg0_12.topPanel)

	setActive(arg0_12.likeFilteToggle, true)

	arg0_12.serchInputText = arg0_12.topPanel:Find("serch")

	setText(arg0_12.serchInputText:Find("Placeholder"), i18n("NewMusic_2"))

	arg0_12.plateListPanel = arg0_12:findTF("PlateList")
	arg0_12.plateTpl = arg0_12:findTF("Plate", arg0_12.plateListPanel)

	setActive(arg0_12.plateTpl, false)
	setText(arg0_12.plateTpl:Find("list/panel/view/empty/icon/Text"), i18n("NewMusic_3"))

	arg0_12.lScrollPageSC = GetComponent(arg0_12.plateListPanel, "LScrollPage")
	arg0_12.playPanel = arg0_12:findTF("PLayPanel")
	arg0_12.playPanelNameText = arg0_12:findTF("NameText", arg0_12.playPanel)
	arg0_12.likeToggle = arg0_12:findTF("LikeBtn", arg0_12.playPanel)
	arg0_12.likeOnImg = arg0_12:findTF("On", arg0_12.likeToggle)
	arg0_12.songImg = arg0_12:findTF("SongImg/face", arg0_12.playPanel)
	arg0_12.pauseBtn = arg0_12:findTF("PlayingBtn", arg0_12.playPanel)
	arg0_12.playBtn = arg0_12:findTF("StopingBtn", arg0_12.playPanel)
	arg0_12.playDesc = arg0_12.playPanel:Find("PlayDesc")
	arg0_12.nextBtn = arg0_12:findTF("NextBtn", arg0_12.playPanel)
	arg0_12.preBtn = arg0_12:findTF("PreBtn", arg0_12.playPanel)
	arg0_12.playProgressBar = arg0_12:findTF("Progress", arg0_12.playPanel)
	arg0_12.nowTimeText = arg0_12:findTF("NowTimeText", arg0_12.playProgressBar)
	arg0_12.totalTimeText = arg0_12:findTF("TotalTimeText", arg0_12.playProgressBar)
	arg0_12.playSliderSC = GetComponent(arg0_12.playProgressBar, "LSlider")
	arg0_12.listBtn = arg0_12:findTF("ListBtn", arg0_12.playPanel)

	setActive(arg0_12.listBtn:Find("on"), false)
	setActive(arg0_12.listBtn:Find("off"), true)

	arg0_12.albumListPanel = arg0_12._tf:Find("AlbumListPanel")
	arg0_12.closeBtn = arg0_12.albumListPanel:Find("BG")
	arg0_12.panel = arg0_12.albumListPanel:Find("Panel")

	setText(arg0_12.panel:Find("top/name"), i18n("NewMusic_6"))

	arg0_12.albumToggle = arg0_12.panel:Find("bottom/sort_btn")
	arg0_12.albumInputText = arg0_12.panel:Find("bottom/serch")

	setText(arg0_12.albumInputText:Find("Placeholder"), i18n("NewMusic_2"))

	arg0_12.albumContainer = arg0_12.panel:Find("middle/Content")
	arg0_12.albumItemList = UIItemList.New(arg0_12.albumContainer, arg0_12.albumContainer:GetChild(0))

	arg0_12.albumItemList:make(function(arg0_13, arg1_13, arg2_13)
		arg1_13 = arg1_13 + 1

		if arg0_13 == UIItemList.EventUpdate then
			arg0_12.albumTFList[arg1_13] = arg2_13

			arg0_12:updateAlbumTF(arg2_13, arg1_13)
		end
	end)

	arg0_12.likeFilteOnImg = arg0_12.likeFilteToggle:Find("TextLike/On")
	arg0_12.playLoopBtn = arg0_12.playPanel:Find("PlayTypeBtn")
end

function var0_0.addListener(arg0_14)
	onButton(arg0_14, arg0_14.listBtn, function()
		arg0_14:openAlbumListPanel()
	end, SFX_PANEL)
	onButton(arg0_14, arg0_14.closeBtn, function()
		arg0_14:closeAlbumListPanel()
	end, SFX_PANEL)
	onButton(arg0_14, arg0_14.albumToggle, function()
		if arg0_14.albumSortValue == "asc" then
			arg0_14.albumSortValue = "desc"
		elseif arg0_14.albumSortValue == "desc" then
			arg0_14.albumSortValue = "asc"
		end

		arg0_14:updateAlbumListPanel()
	end, SFX_PANEL)
	onButton(arg0_14, arg0_14.likeFilteToggle, function()
		arg0_14.likeValue = 1 - arg0_14.likeValue
		arg0_14.curMidddleIndex = 1

		arg0_14:saveRunData()
		arg0_14:updateLikeToggle()
		arg0_14:updatePlateListPanel()
	end, SFX_PANEL)
	onButton(arg0_14, arg0_14.playBtn, function()
		if not arg0_14.musicPlayer then
			return
		end

		arg0_14.musicPlayer:Resume()
		SetActive(arg0_14.pauseBtn, true)
		SetActive(arg0_14.playBtn, false)
		setActive(arg0_14.playDesc, true)
	end, SFX_PANEL)
	onButton(arg0_14, arg0_14.pauseBtn, function()
		if not arg0_14.musicPlayer then
			return
		end

		arg0_14.musicPlayer:Pause()
		SetActive(arg0_14.pauseBtn, false)
		SetActive(arg0_14.playBtn, true)
		setActive(arg0_14.playDesc, false)
	end, SFX_PANEL)
	onButton(arg0_14, arg0_14.preBtn, function()
		if not arg0_14.musicPlayer then
			return
		end

		if arg0_14.isPlayingAni then
			return
		end

		arg0_14.musicPlayer:Last()
	end, SFX_PANEL)
	onButton(arg0_14, arg0_14.nextBtn, function()
		if not arg0_14.musicPlayer then
			return
		end

		if arg0_14.isPlayingAni then
			return
		end

		arg0_14.musicPlayer:Next()
	end, SFX_PANEL)
	onButton(arg0_14, arg0_14.likeToggle, function()
		local var0_23 = arg0_14.musicPlayer:GetCurrentMusicId()
		local var1_23 = pg.music_collect_config[var0_23].id

		pg.m02:sendNotification(GAME.APPRECIATE_MUSIC_LIKE, {
			musicID = var1_23,
			isAdd = arg0_14.likeDic[var1_23] and 1 or 0
		})
		arg0_14:ChangeLike(var1_23)
		arg0_14:updateLikeToggle()
		setActive(arg0_14.likeOnImg, arg0_14.likeDic[var1_23])
		arg0_14:updatePlateList(arg0_14.plateTFList[arg0_14.curMidddleIndex], arg0_14.curMidddleIndex)
	end, SFX_PANEL)

	local var0_14

	arg0_14.playSliderSC:AddPointDownFunc(function(arg0_24)
		if arg0_14.onDrag then
			return
		end

		arg0_14.onDrag = true
		var0_14 = arg0_14.musicPlayer:IsPaused()

		if not var0_14 then
			arg0_14.musicPlayer:Pause()
		end
	end)
	arg0_14.playSliderSC:AddPointUpFunc(function(arg0_25)
		if not arg0_14.onDrag then
			return
		end

		arg0_14.onDrag = false

		arg0_14.musicPlayer:SetProgress(arg0_14.playSliderSC.value)

		if not var0_14 then
			arg0_14.musicPlayer:Resume()
		end
	end)
	onButton(arg0_14, arg0_14.playLoopBtn, function()
		local var0_26 = getProxy(AppreciateProxy):getMusicPlayerLoopType()

		switch(var0_26, {
			list = function()
				var0_26 = "random"
			end,
			random = function()
				var0_26 = "one"
			end,
			one = function()
				var0_26 = "list"
			end
		})
		pg.m02:sendNotification(GAME.APPRECIATE_CHANGE_MUSIC_PLAY_LOOP_TYPE, {
			loopType = var0_26
		})
		arg0_14:updatePlayType(var0_26)

		if arg0_14.musicPlayer then
			arg0_14.musicPlayer.loopType = var0_26
		end
	end, SFX_PANEL)
	onInputChanged(arg0_14, arg0_14.serchInputText, function(arg0_30)
		if arg0_14.likeValue ~= MusicCollectionConst.Filte_Like_Value then
			return
		end

		arg0_14:updatePlateList(arg0_14.plateTFList[arg0_14.curMidddleIndex], arg0_14.curMidddleIndex)
	end)
	onInputChanged(arg0_14, arg0_14.albumInputText, function(arg0_31)
		arg0_14:updateAlbumListPanel()
	end)
end

function var0_0.tryShowTipMsgBox(arg0_32)
	if arg0_32.appreciateProxy:isMusicHaveNewRes() then
		local function var0_32()
			arg0_32.lScrollPageSC:MoveToItemID(MusicCollectionConst.AutoScrollIndex - 1)
			PlayerPrefs.SetInt("musicVersion", MusicCollectionConst.Version)
			arg0_32:emit(CollectionScene.UPDATE_RED_POINT)
		end

		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			hideClose = true,
			hideNo = true,
			content = i18n("res_music_new_tip", MusicCollectionConst.NewCount),
			onYes = var0_32,
			onCancel = var0_32,
			onClose = var0_32
		})
	end
end

function var0_0.initPlateListPanel(arg0_34)
	function arg0_34.lScrollPageSC.itemInitedCallback(arg0_35, arg1_35)
		local var0_35 = arg0_35 + 1

		arg0_34.plateTFList[var0_35] = arg1_35

		arg1_35:GetComponent("DftAniEvent"):SetEndEvent(function()
			local var0_36 = arg0_34.animCallback

			arg0_34.animCallback = nil

			existCall(var0_36)
		end)
		arg0_34:updatePlateTF(arg1_35, var0_35)
	end

	function arg0_34.lScrollPageSC.itemClickCallback(arg0_37, arg1_37)
		local var0_37 = arg0_37 + 1

		if arg0_34.curMidddleIndex ~= var0_37 and not arg0_34.isPlayingAni then
			arg0_34:setAniState(true)
			arg0_34:closePlateAni(arg0_34.plateTFList[arg0_34.curMidddleIndex])
			arg0_34.lScrollPageSC:MoveToItemID(arg0_37)
		end
	end

	function arg0_34.lScrollPageSC.itemPitchCallback(arg0_38, arg1_38)
		local var0_38 = arg0_38 + 1

		arg0_34.curMidddleIndex = var0_38

		arg0_34:saveRunData()
		arg0_34:updatePlateList(arg1_38, var0_38)
		arg0_34:playPlateAni(arg1_38, true)
	end

	function arg0_34.lScrollPageSC.itemRecycleCallback(arg0_39, arg1_39)
		arg0_34.plateTFList[arg0_39 + 1] = nil
	end

	addSlip(SLIP_TYPE_HRZ, arg0_34.plateListPanel, function()
		if arg0_34.curMidddleIndex > 1 and not arg0_34.isPlayingAni then
			arg0_34:setAniState(true)
			arg0_34.lScrollPageSC:MoveToItemID(arg0_34.curMidddleIndex - 1 - 1)
			arg0_34:closePlateAni(arg0_34.plateTFList[arg0_34.curMidddleIndex])
		end
	end, function()
		if arg0_34.curMidddleIndex < arg0_34.lScrollPageSC.DataCount and not arg0_34.isPlayingAni then
			arg0_34:setAniState(true)
			arg0_34.lScrollPageSC:MoveToItemID(arg0_34.curMidddleIndex + 1 - 1)
			arg0_34:closePlateAni(arg0_34.plateTFList[arg0_34.curMidddleIndex])
		end
	end)
end

function var0_0.updatePlateListPanel(arg0_42)
	local var0_42 = arg0_42.likeValue == MusicCollectionConst.Filte_Like_Value

	if var0_42 then
		arg0_42.tempPlateList = {
			"favor"
		}
	else
		arg0_42.tempPlateList = arg0_42.albumNames
	end

	setActive(arg0_42.serchInputText, var0_42)
	setActive(arg0_42.listBtn, not var0_42)

	arg0_42.lScrollPageSC.DataCount = #arg0_42.tempPlateList

	arg0_42.lScrollPageSC:Init(arg0_42.curMidddleIndex - 1)
end

function var0_0.updatePlateTF(arg0_43, arg1_43, arg2_43)
	local var0_43 = arg0_43.likeValue == MusicCollectionConst.Filte_Like_Value
	local var1_43 = arg0_43.tempPlateList[arg2_43]
	local var2_43 = var0_43 and arg0_43.likeIds or arg0_43.appreciateProxy:getAlbumMusicList(var1_43)
	local var3_43

	if var0_43 then
		if #var2_43 > 0 then
			var3_43 = pg.music_collect_config[var2_43[#var2_43]].cover
		end
	else
		var3_43 = pg.music_collect_config[var2_43[1]].cover
	end

	setText(arg1_43:Find("PlateImg/empty/Text"), i18n("NewMusic_7"))
	setActive(arg1_43:Find("PlateImg/face"), var3_43)
	setActive(arg1_43:Find("PlateImg/empty"), not var3_43)

	if var3_43 then
		local var4_43 = MusicCollectionConst.MUSIC_COVER_PATH_PREFIX .. var3_43

		arg0_43.resLoader:LoadSprite(var4_43, var3_43, arg1_43:Find("PlateImg/face"), false)
	end

	if arg2_43 == arg0_43.curMidddleIndex then
		arg0_43:updatePlateList(arg1_43, arg2_43)
	end
end

function var0_0.updatePlateList(arg0_44, arg1_44, arg2_44)
	local var0_44 = arg0_44.likeValue == MusicCollectionConst.Filte_Like_Value
	local var1_44 = arg0_44.tempPlateList[arg2_44]
	local var2_44 = var0_44 and arg0_44.likeIds or arg0_44.appreciateProxy:getAlbumMusicList(var1_44)
	local var3_44 = arg1_44:Find("list")

	setText(var3_44:Find("album_name"), var1_44 == "favor" and i18n("NewMusic_5") or var1_44)

	local var4_44 = arg0_44.appreciateProxy:getMainPlayerAlbumName() == var1_44
	local var5_44 = var3_44:Find("btn_home")

	setActive(var5_44:Find("off"), not var4_44)
	setActive(var5_44:Find("on"), var4_44)
	onButton(arg0_44, var5_44, function()
		if arg0_44.appreciateProxy:getMainPlayerAlbumName() == var1_44 then
			pg.m02:sendNotification(GAME.APPRECIATE_CHANGE_MAIN_PLAY_ALBUM, {
				albumName = "none"
			})
			setActive(var5_44:Find("off"), true)
			setActive(var5_44:Find("on"), false)
		else
			pg.m02:sendNotification(GAME.APPRECIATE_CHANGE_MAIN_PLAY_ALBUM, {
				albumName = var1_44
			})
			setActive(var5_44:Find("off"), false)
			setActive(var5_44:Find("on"), true)
		end

		arg0_44:updateAlbumListPanel()
	end, SFX_CONFIRM)

	local var6_44 = var3_44:Find("panel/view/container")

	local function var7_44(arg0_46)
		local var0_46

		if not var0_44 or arg0_44.sortValue == MusicCollectionConst.Sort_Order_Down then
			var0_46 = underscore.to_array(var2_44)
		elseif arg0_44.sortValue == MusicCollectionConst.Sort_Order_Up then
			var0_46 = underscore.reverse(var2_44)
		else
			assert(false)
		end

		local var1_46 = string.lower(getInputText(arg0_44.serchInputText))
		local var2_46 = var0_44 and underscore.filter(var0_46, function(arg0_47)
			local var0_47 = pg.music_collect_config[arg0_47].name

			return not var1_46 or var1_46 == "" or string.find(string.lower(var0_47), var1_46)
		end) or underscore.to_array(var0_46)

		UIItemList.StaticAlign(var6_44, var6_44:GetChild(0), #var2_46, function(arg0_48, arg1_48, arg2_48)
			arg1_48 = arg1_48 + 1

			if arg0_48 == UIItemList.EventUpdate then
				local var0_48 = pg.music_collect_config[var2_46[arg1_48]]

				if var0_44 and arg0_44.sortValue == MusicCollectionConst.Sort_Order_Up then
					setText(arg2_48:Find("mark/Text"), string.format("%02d", #var2_46 - arg1_48 + 1))
				else
					setText(arg2_48:Find("mark/Text"), string.format("%02d", arg1_48))
				end

				changeToScrollText(arg2_48:Find("name"), var0_48.name)
				setText(arg2_48:Find("time"), arg0_44:descTime(var0_48.music_time))
				setActive(arg2_48:Find("line"), arg1_48 < #var2_46)
				onButton(arg0_44, arg2_48:Find("like"), function()
					local var0_49 = var0_48.id

					pg.m02:sendNotification(GAME.APPRECIATE_MUSIC_LIKE, {
						musicID = var0_49,
						isAdd = arg0_44.likeDic[var0_49] and 1 or 0
					})
					arg0_44:ChangeLike(var0_49)
					arg0_44:updateLikeToggle()
					arg0_44:updatePlateList(arg1_44, arg2_44)

					if arg0_44.musicPlayer and arg0_44.musicPlayer:GetCurrentMusicId() == var0_49 then
						setActive(arg0_44.likeOnImg, arg0_44.likeDic[var0_49])
					end
				end, SFX_CONFIRM)
				setActive(arg2_48:Find("like/off"), not arg0_44.likeDic[var0_48.id])
				setActive(arg2_48:Find("like/on"), arg0_44.likeDic[var0_48.id])

				local var1_48 = arg0_44.musicPlayer and arg0_44.musicPlayer.albumName == var1_44 and arg0_44.musicPlayer:GetCurrentMusicId() == var0_48.id

				setActive(arg2_48:Find("mark/Text"), not var1_48)
				setActive(arg2_48:Find("mark/icon"), var1_48)
				setTextColor(arg2_48:Find("name/subText"), var1_48 and Color.NewHex("FF596E") or Color.white)
				setTextColor(arg2_48:Find("time"), var1_48 and Color.NewHex("FF596E") or Color.white)
				onButton(arg0_44, arg2_48, function()
					arg0_44:NewMusicPlayer(var1_44, var0_46, var0_48.id)
				end, SFX_CONFIRM)
			end
		end)
		setActive(var3_44:Find("panel/view/empty"), #var2_46 == 0)
	end

	setActive(var3_44:Find("panel/sort"), var0_44)

	if var0_44 then
		local var8_44 = var3_44:Find("panel/sort/bg/asc")
		local var9_44 = var3_44:Find("panel/sort/bg/desc")

		setText(var8_44:Find("Text"), i18n("word_asc"))
		onToggle(arg0_44, var8_44, function(arg0_51)
			if arg0_51 then
				arg0_44.sortValue = MusicCollectionConst.Sort_Order_Up

				arg0_44:saveRunData()
				var7_44(not arg0_51)
			end

			setImageAlpha(var8_44, arg0_51 and 1 or 0)
			setCanvasGroupAlpha(var8_44, arg0_51 and 1 or 0.3)
		end, SFX_PANEL)
		setText(var9_44:Find("Text"), i18n("word_desc"))
		onToggle(arg0_44, var9_44, function(arg0_52)
			if arg0_52 then
				arg0_44.sortValue = MusicCollectionConst.Sort_Order_Down

				arg0_44:saveRunData()
				var7_44(arg0_52)
			end

			setImageAlpha(var9_44, arg0_52 and 1 or 0)
			setCanvasGroupAlpha(var9_44, arg0_52 and 1 or 0.3)
		end, SFX_PANEL)

		if arg0_44.sortValue == MusicCollectionConst.Sort_Order_Up then
			triggerToggle(var8_44, true)
		else
			triggerToggle(var9_44, true)
		end
	else
		var7_44(false)
	end
end

function var0_0.updateAlbumListPanel(arg0_53)
	local var0_53 = string.lower(getInputText(arg0_53.albumInputText))

	arg0_53.tempAlbumList = underscore.filter(arg0_53.albumNames, function(arg0_54)
		if string.find(string.lower(arg0_54), var0_53) then
			return true
		else
			return underscore.any(arg0_53.appreciateProxy:getAlbumMusicList(arg0_54), function(arg0_55)
				return string.find(string.lower(pg.music_collect_config[arg0_55].name), var0_53)
			end)
		end
	end)

	arg0_53.albumItemList:align(#arg0_53.tempAlbumList)
	setActive(arg0_53.panel:Find("middle/empty"), #arg0_53.tempAlbumList == 0)
	setActive(arg0_53.albumToggle:Find("asc"), arg0_53.albumSortValue == "asc")
	setActive(arg0_53.albumToggle:Find("desc"), arg0_53.albumSortValue == "desc")
end

function var0_0.updateAlbumTF(arg0_56, arg1_56, arg2_56)
	if arg0_56.albumSortValue == "desc" then
		arg2_56 = #arg0_56.tempAlbumList + 1 - arg2_56
	end

	local var0_56 = arg0_56.tempAlbumList[arg2_56]

	setText(arg1_56:Find("index"), string.format("%02d", arg2_56))

	local var1_56 = arg0_56.appreciateProxy:getAlbumMusicList(var0_56)
	local var2_56 = pg.music_collect_config[var1_56[1]].cover
	local var3_56 = MusicCollectionConst.MUSIC_COVER_PATH_PREFIX .. var2_56

	arg0_56.resLoader:LoadSprite(var3_56, var2_56, arg1_56:Find("icon/face"), false)
	changeToScrollText(arg1_56:Find("name"), var0_56)
	setActive(arg1_56:Find("icon/main"), var0_56 == arg0_56.appreciateProxy:getMainPlayerAlbumName())

	local var4_56 = arg0_56.musicPlayer and arg0_56.musicPlayer.albumName == var0_56

	setActive(arg1_56:Find("playing"), var4_56)
	setActive(arg1_56:Find("line"), arg2_56 < #arg0_56.tempAlbumList)
	onButton(arg0_56, arg1_56, function()
		arg0_56:closeAlbumListPanel()

		arg0_56.curMidddleIndex = arg2_56

		if arg0_56.likeValue == MusicCollectionConst.Filte_Like_Value then
			arg0_56.likeValue = MusicCollectionConst.Filte_Normal_Value

			arg0_56:updatePlateListPanel()
		else
			arg0_56.lScrollPageSC:Init(arg0_56.curMidddleIndex - 1)
		end

		arg0_56:saveRunData()
	end, SFX_PANEL)
end

function var0_0.updateLikeToggle(arg0_58)
	setActive(arg0_58.likeFilteOnImg, arg0_58.likeValue == MusicCollectionConst.Filte_Like_Value)

	local var0_58 = underscore.reduce(underscore.keys(arg0_58.likeDic), 0, function(arg0_59, arg1_59)
		return arg0_59 + (arg0_58.likeDic[arg1_59] and 1 or 0)
	end)

	setText(arg0_58.likeFilteToggle:Find("TextNum"), string.format("(%d)", var0_58))
end

function var0_0.updatePlayPanel(arg0_60, arg1_60)
	local var0_60 = arg0_60.musicPlayer:GetCurrentMusicId()
	local var1_60 = pg.music_collect_config[var0_60]
	local var2_60 = var1_60.cover
	local var3_60 = MusicCollectionConst.MUSIC_COVER_PATH_PREFIX .. var2_60

	arg0_60.resLoader:LoadSprite(var3_60, var2_60, arg0_60.songImg, false)

	local var4_60 = var1_60.name

	changeToScrollText(arg0_60.playPanelNameText, var4_60)
	setActive(arg0_60.likeOnImg, arg0_60.likeDic[var1_60.id])
	setActive(arg0_60.playBtn, false)
	setActive(arg0_60.playDesc, true)
	setActive(arg0_60.pauseBtn, true)
	setSlider(arg0_60.playProgressBar, 0, arg1_60, 0)
	setText(arg0_60.totalTimeText, arg0_60:descTime(arg1_60))
	setActive(arg0_60.nowTimeText, true)
	setActive(arg0_60.totalTimeText, true)
end

function var0_0.updatePlayType(arg0_61, arg1_61)
	arg1_61 = arg1_61 or getProxy(AppreciateProxy):getMusicPlayerLoopType()

	eachChild(arg0_61.playLoopBtn, function(arg0_62, arg1_62)
		setActive(arg0_62, arg0_62.name == arg1_61)
	end)
end

function var0_0.updatePlayProgress(arg0_63, arg1_63)
	arg0_63.playSliderSC:SetValueWithoutEvent(arg1_63)
	setText(arg0_63.nowTimeText, arg0_63:descTime(arg1_63))
end

function var0_0.playPlateAni(arg0_64, arg1_64, arg2_64, arg3_64, arg4_64)
	arg0_64:setAniState(true)
	setActive(arg1_64:Find("list"), true)

	function arg0_64.animCallback()
		arg0_64:setAniState(false)
	end

	quickPlayAnimation(arg1_64, "anim_MusicCollectionUI_Plate_expand")
end

function var0_0.closePlateAni(arg0_66, arg1_66)
	arg0_66:setAniState(true)

	function arg0_66.animCallback()
		setActive(arg1_66:Find("list"), false)
		arg0_66:setAniState(false)
	end

	quickPlayAnimation(arg1_66, "anim_MusicCollectionUI_Plate_retract")
end

function var0_0.setAniState(arg0_68, arg1_68)
	arg0_68.isPlayingAni = arg1_68
end

function var0_0.openAlbumListPanel(arg0_69)
	setActive(arg0_69.albumListPanel, true)
	setActive(arg0_69.listBtn:Find("on"), true)
	setActive(arg0_69.listBtn:Find("off"), false)
end

function var0_0.closeAlbumListPanel(arg0_70, arg1_70)
	setActive(arg0_70.albumListPanel, false)
	setActive(arg0_70.listBtn:Find("on"), false)
	setActive(arg0_70.listBtn:Find("off"), true)
end

function var0_0.checkupdateAlbumTF(arg0_71)
	if #arg0_71.albumTFList > 0 then
		arg0_71:updateAlbumTF(arg0_71.albumTFList[arg0_71.curMidddleIndex], arg0_71.curMidddleIndex)
	end
end

function var0_0.NewMusicPlayer(arg0_72, arg1_72, arg2_72, arg3_72)
	local var0_72 = {
		loopType = getProxy(AppreciateProxy):getMusicPlayerLoopType(),
		albumName = arg1_72,
		list = arg2_72 or nil,
		index = arg3_72 and table.indexof(arg2_72, arg3_72) or nil
	}

	arg0_72.bgmMgr:TempPlay("TempMusicPlayer", var0_72)

	arg0_72.musicPlayer = arg0_72.bgmMgr:GetMusicPlayer()
end

function var0_0.ChangeLike(arg0_73, arg1_73)
	arg0_73.likeDic[arg1_73] = not arg0_73.likeDic[arg1_73]

	if arg0_73.likeDic[arg1_73] then
		table.insert(arg0_73.likeIds, arg1_73)
	else
		table.removebyvalue(arg0_73.likeIds, arg1_73)
	end
end

function var0_0.tryPlayMusic(arg0_74)
	triggerButton(arg0_74.playBtn)
end

function var0_0.tryPauseMusic(arg0_75)
	triggerButton(arg0_75.pauseBtn)
end

function var0_0.descTime(arg0_76, arg1_76)
	local var0_76 = math.floor(arg1_76 / 1000)
	local var1_76 = math.floor(var0_76 / 3600)
	local var2_76 = var0_76 - var1_76 * 3600
	local var3_76 = math.floor(var2_76 / 60)
	local var4_76 = var2_76 % 60

	if var1_76 ~= 0 then
		return string.format("%02d:%02d:%02d", var1_76, var3_76, var4_76)
	else
		return string.format("%02d:%02d", var3_76, var4_76)
	end
end

return var0_0
