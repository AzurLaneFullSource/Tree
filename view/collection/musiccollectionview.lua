local var0 = class("MusicCollectionView", import("..base.BaseSubView"))

function var0.getUIName(arg0)
	return "MusicCollectionUI"
end

function var0.OnInit(arg0)
	arg0:initData()
	arg0:findUI()
	arg0:addListener()
	arg0:initPlateListPanel()
	arg0:initSongListPanel()
	arg0:Show()
	arg0:recoverRunData()
	arg0:initTimer()
	arg0:tryShowTipMsgBox()
end

function var0.OnDestroy(arg0)
	arg0:stopMusic()
	arg0.resLoader:Clear()

	if arg0.playProgressTimer then
		arg0.playProgressTimer:Stop()

		arg0.playProgressTimer = nil
	end

	if arg0.downloadCheckTimer then
		arg0.downloadCheckTimer:Stop()

		arg0.downloadCheckTimer = nil
	end

	if arg0.playbackInfo then
		arg0.playbackInfo = nil
	end

	if arg0.appreciateUnlockMsgBox and arg0.appreciateUnlockMsgBox:CheckState(BaseSubView.STATES.INITED) then
		arg0.appreciateUnlockMsgBox:Destroy()
	end

	arg0:closeSongListPanel(true)
end

function var0.onBackPressed(arg0)
	if arg0.appreciateUnlockMsgBox and arg0.appreciateUnlockMsgBox:CheckState(BaseSubView.STATES.INITED) then
		arg0.appreciateUnlockMsgBox:hideCustomMsgBox()
		arg0.appreciateUnlockMsgBox:Destroy()

		return false
	elseif isActive(arg0.songListPanel) then
		arg0:closeSongListPanel()

		return false
	else
		return true
	end
end

function var0.initData(arg0)
	arg0.appreciateProxy = getProxy(AppreciateProxy)

	arg0.appreciateProxy:checkMusicFileState()

	arg0.resLoader = AutoLoader.New()
	arg0.criMgr = pg.CriMgr.GetInstance()
	arg0.manager = BundleWizard.Inst:GetGroupMgr("GALLERY_BGM")
	arg0.downloadCheckIDList = {}
	arg0.downloadCheckTimer = nil
	arg0.musicForShowConfigList = {}
	arg0.plateTFList = {}
	arg0.songTFList = {}
	arg0.curMidddleIndex = 1
	arg0.sortValue = MusicCollectionConst.Sort_Order_Up
	arg0.likeValue = MusicCollectionConst.Filte_Normal_Value
	arg0.isPlayingAni = false
	arg0.cueData = nil
	arg0.playbackInfo = nil
	arg0.playProgressTimer = nil
	arg0.onDrag = false
	arg0.hadDrag = false
	arg0.isPlayingSong = false
end

function var0.saveRunData(arg0)
	arg0.appreciateProxy:updateMusicRunData(arg0.sortValue, arg0.curMidddleIndex, arg0.likeValue)
end

function var0.recoverRunData(arg0)
	local var0 = arg0.appreciateProxy:getMusicRunData()

	arg0.sortValue = var0.sortValue
	arg0.curMidddleIndex = var0.middleIndex
	arg0.likeValue = var0.likeValue
	arg0.musicForShowConfigList = arg0:fliteMusicConfigForShow()

	arg0:sortMusicConfigList(arg0.sortValue == MusicCollectionConst.Sort_Order_Down)

	arg0.musicForShowConfigList = arg0:filteMusicConfigByLike()
	arg0.lScrollPageSC.MiddleIndexOnInit = arg0.curMidddleIndex - 1

	arg0:updatePlateListPanel()
	arg0:updateSongListPanel()
	arg0:updatePlayPanel()
	arg0:updateSortToggle()
	arg0:updateLikeToggle()

	if not arg0.appreciateProxy:isMusicHaveNewRes() then
		arg0:tryPlayMusic()
	end
end

function var0.findUI(arg0)
	setLocalPosition(arg0._tf, Vector2.zero)

	arg0._tf.anchorMin = Vector2.zero
	arg0._tf.anchorMax = Vector2.one
	arg0._tf.offsetMax = Vector2.zero
	arg0._tf.offsetMin = Vector2.zero
	arg0.topPanel = arg0:findTF("TopPanel")
	arg0.likeFilteToggle = arg0:findTF("LikeBtn", arg0.topPanel)
	arg0.sortToggle = arg0:findTF("SortBtn", arg0.topPanel)
	arg0.songNameText = arg0:findTF("MusicNameMask/MusicName", arg0.topPanel)
	arg0.staicImg = arg0:findTF("SoundImg", arg0.topPanel)
	arg0.playingAni = arg0:findTF("SoundAni", arg0.topPanel)
	arg0.resRepaireBtn = arg0:findTF("RepaireBtn", arg0.topPanel)

	setActive(arg0.likeFilteToggle, true)

	arg0.plateListPanel = arg0:findTF("PlateList")
	arg0.plateTpl = arg0:findTF("Plate", arg0.plateListPanel)
	arg0.lScrollPageSC = GetComponent(arg0.plateListPanel, "LScrollPage")
	arg0.playPanel = arg0:findTF("PLayPanel")
	arg0.playPanelNameText = arg0:findTF("NameText", arg0.playPanel)
	arg0.likeToggle = arg0:findTF("LikeBtn", arg0.playPanel)
	arg0.songImg = arg0:findTF("SongImg", arg0.playPanel)
	arg0.pauseBtn = arg0:findTF("PlayingBtn", arg0.playPanel)
	arg0.playBtn = arg0:findTF("StopingBtn", arg0.playPanel)
	arg0.lockImg = arg0:findTF("LockedBtn", arg0.playPanel)
	arg0.nextBtn = arg0:findTF("NextBtn", arg0.playPanel)
	arg0.preBtn = arg0:findTF("PreBtn", arg0.playPanel)
	arg0.playProgressBar = arg0:findTF("Progress", arg0.playPanel)
	arg0.nowTimeText = arg0:findTF("NowTimeText", arg0.playProgressBar)
	arg0.totalTimeText = arg0:findTF("TotalTimeText", arg0.playProgressBar)
	arg0.playSliderSC = GetComponent(arg0.playProgressBar, "LSlider")
	arg0.listBtn = arg0:findTF("ListBtn", arg0.playPanel)

	setActive(arg0.likeToggle, true)

	arg0.songListPanel = arg0:findTF("SongListPanel")
	arg0.closeBtn = arg0:findTF("BG", arg0.songListPanel)
	arg0.panel = arg0:findTF("Panel", arg0.songListPanel)
	arg0.songContainer = arg0:findTF("Container/Viewport/Content", arg0.panel)
	arg0.songTpl = arg0:findTF("SongTpl", arg0.panel)
	arg0.upToggle = arg0:findTF("BG2/UpToggle", arg0.panel)
	arg0.downToggle = arg0:findTF("BG2/DownToggle", arg0.panel)
	arg0.songUIItemList = UIItemList.New(arg0.songContainer, arg0.songTpl)
	arg0.emptyPanel = arg0:findTF("EmptyPanel")
	arg0.upImg1 = arg0:findTF("Up", arg0.sortToggle)
	arg0.downImg1 = arg0:findTF("Down", arg0.sortToggle)
	arg0.upImg2 = arg0:findTF("SelImg", arg0.upToggle)
	arg0.downImg2 = arg0:findTF("SelImg", arg0.downToggle)
	arg0.likeFilteOffImg = arg0:findTF("Off", arg0.likeFilteToggle)
	arg0.likeFilteOnImg = arg0:findTF("On", arg0.likeFilteToggle)
	arg0.likeOffImg = arg0:findTF("Off", arg0.likeToggle)
	arg0.likeOnImg = arg0:findTF("On", arg0.likeToggle)
end

function var0.addListener(arg0)
	onButton(arg0, arg0.listBtn, function()
		arg0:openSongListPanel()
	end, SFX_PANEL)
	onButton(arg0, arg0.closeBtn, function()
		arg0:closeSongListPanel()
	end, SFX_PANEL)
	onButton(arg0, arg0.resRepaireBtn, function()
		local var0 = {
			text = i18n("msgbox_repair"),
			onCallback = function()
				if PathMgr.FileExists(Application.persistentDataPath .. "/hashes-bgm.csv") then
					BundleWizard.Inst:GetGroupMgr("GALLERY_BGM"):StartVerifyForLua()
				else
					pg.TipsMgr.GetInstance():ShowTips(i18n("word_no_cache"))
				end
			end
		}

		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			hideYes = true,
			content = i18n("resource_verify_warn"),
			custom = {
				var0
			}
		})
	end, SFX_PANEL)
	onButton(arg0, arg0.sortToggle, function()
		arg0.sortValue = arg0.sortValue == MusicCollectionConst.Sort_Order_Up and MusicCollectionConst.Sort_Order_Down or MusicCollectionConst.Sort_Order_Up

		arg0:saveRunData()
		arg0:sortAndUpdate(arg0.sortValue == MusicCollectionConst.Sort_Order_Down)
	end, SFX_PANEL)
	onButton(arg0, arg0.upToggle, function()
		if arg0.sortValue == MusicCollectionConst.Sort_Order_Up then
			return
		else
			arg0.sortValue = MusicCollectionConst.Sort_Order_Up

			arg0:saveRunData()
			arg0:sortAndUpdate(false)
		end
	end, SFX_PANEL)
	onButton(arg0, arg0.downToggle, function()
		if arg0.sortValue == MusicCollectionConst.Sort_Order_Down then
			return
		else
			arg0.sortValue = MusicCollectionConst.Sort_Order_Down

			arg0:saveRunData()
			arg0:sortAndUpdate(true)
		end
	end, SFX_PANEL)
	onButton(arg0, arg0.likeFilteToggle, function()
		arg0.likeValue = arg0.likeValue == MusicCollectionConst.Filte_Normal_Value and MusicCollectionConst.Filte_Like_Value or MusicCollectionConst.Filte_Normal_Value

		arg0:saveRunData()
		arg0:sortAndUpdate(arg0.sortValue == MusicCollectionConst.Sort_Order_Down)
	end, SFX_PANEL)
	onButton(arg0, arg0.playBtn, function()
		if not arg0.playbackInfo then
			arg0:playMusic()
		elseif arg0.hadDrag then
			arg0.hadDrag = false

			arg0.playbackInfo:SetStartTimeAndPlay(arg0.playSliderSC.value)
			arg0.playProgressTimer:Start()
		else
			arg0.playbackInfo.playback:Resume(CriAtomEx.ResumeMode.PausedPlayback)
		end

		setActive(arg0.playingAni, true)
		setActive(arg0.staicImg, false)
		SetActive(arg0.pauseBtn, true)
		SetActive(arg0.playBtn, false)
	end, SFX_PANEL)
	onButton(arg0, arg0.pauseBtn, function()
		if arg0.playbackInfo then
			arg0.playbackInfo.playback:Pause()
		end

		setActive(arg0.playingAni, false)
		setActive(arg0.staicImg, true)
		SetActive(arg0.pauseBtn, false)
		SetActive(arg0.playBtn, true)
	end, SFX_PANEL)
	onButton(arg0, arg0.preBtn, function()
		if arg0.curMidddleIndex == 1 then
			pg.TipsMgr.GetInstance():ShowTips(i18n("res_music_no_pre_tip"))
		elseif not arg0.isPlayingAni then
			arg0:setAniState(true)
			arg0:closePlateAni(arg0.plateTFList[arg0.curMidddleIndex])
			arg0.lScrollPageSC:MoveToItemID(arg0.curMidddleIndex - 1 - 1)
		end
	end, SFX_PANEL)
	onButton(arg0, arg0.nextBtn, function()
		if arg0.curMidddleIndex == #arg0.musicForShowConfigList then
			pg.TipsMgr.GetInstance():ShowTips(i18n("res_music_no_next_tip"))
		elseif not arg0.isPlayingAni then
			arg0:setAniState(true)
			arg0:closePlateAni(arg0.plateTFList[arg0.curMidddleIndex])
			arg0.lScrollPageSC:MoveToItemID(arg0.curMidddleIndex + 1 - 1)
		end
	end, SFX_PANEL)
	onButton(arg0, arg0.likeToggle, function()
		local var0 = arg0:getMusicConfigForShowByIndex(arg0.curMidddleIndex).id

		if arg0.appreciateProxy:isLikedByMusicID(var0) == true then
			pg.m02:sendNotification(GAME.APPRECIATE_MUSIC_LIKE, {
				isAdd = 1,
				musicID = var0
			})
			setActive(arg0.likeOnImg, false)
			arg0:updateSongTFLikeImg(arg0.songTFList[arg0.curMidddleIndex], false)
		else
			pg.m02:sendNotification(GAME.APPRECIATE_MUSIC_LIKE, {
				isAdd = 0,
				musicID = var0
			})
			setActive(arg0.likeOnImg, true)
			arg0:updateSongTFLikeImg(arg0.songTFList[arg0.curMidddleIndex], true)
		end
	end, SFX_PANEL)
	arg0.playSliderSC:AddPointDownFunc(function(arg0)
		if arg0.playbackInfo and not arg0.onDrag then
			arg0.onDrag = true

			if arg0.playbackInfo.playback:IsPaused() then
				-- block empty
			else
				arg0.playbackInfo.playback:Stop(true)
			end

			arg0.playProgressTimer:Stop()
		end
	end)
	arg0.playSliderSC:AddPointUpFunc(function(arg0)
		if arg0.playbackInfo and arg0.onDrag then
			arg0.onDrag = false

			if arg0.playbackInfo.playback:IsPaused() then
				arg0.hadDrag = true
			else
				arg0.playbackInfo:SetStartTimeAndPlay(arg0.playSliderSC.value)
				arg0.playProgressTimer:Start()
			end
		else
			arg0.playSliderSC:SetValueWithoutEvent(0)
		end
	end)
end

function var0.tryShowTipMsgBox(arg0)
	if arg0.appreciateProxy:isMusicHaveNewRes() then
		local function var0()
			arg0.lScrollPageSC:MoveToItemID(MusicCollectionConst.AutoScrollIndex - 1)
			PlayerPrefs.SetInt("musicVersion", MusicCollectionConst.Version)
			arg0:emit(CollectionScene.UPDATE_RED_POINT)
		end

		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			hideClose = true,
			hideNo = true,
			content = i18n("res_music_new_tip", MusicCollectionConst.NewCount),
			onYes = var0,
			onCancel = var0,
			onClose = var0
		})
	end
end

function var0.initPlateListPanel(arg0)
	function arg0.lScrollPageSC.itemInitedCallback(arg0, arg1)
		local var0 = arg0 + 1

		arg0.plateTFList[var0] = arg1

		arg0:updatePlateTF(arg1, arg0)
	end

	function arg0.lScrollPageSC.itemClickCallback(arg0, arg1)
		local var0 = arg0 + 1

		if arg0.curMidddleIndex ~= var0 and not arg0.isPlayingAni then
			arg0:setAniState(true)
			arg0:closePlateAni(arg0.plateTFList[arg0.curMidddleIndex])
			arg0.lScrollPageSC:MoveToItemID(arg0)
		end
	end

	function arg0.lScrollPageSC.itemPitchCallback(arg0, arg1)
		local var0 = arg0 + 1

		arg0:stopMusic()
		arg0:checkUpdateSongTF()

		arg0.curMidddleIndex = arg0 + 1

		arg0:saveRunData()
		arg0:playPlateAni(arg1, true)
		arg0:updatePlayPanel()
		arg0:tryPlayMusic()
	end

	function arg0.lScrollPageSC.itemRecycleCallback(arg0, arg1)
		arg0.plateTFList[arg0 + 1] = nil
	end

	addSlip(SLIP_TYPE_HRZ, arg0.plateListPanel, function()
		if arg0.curMidddleIndex > 1 and not arg0.isPlayingAni then
			arg0:setAniState(true)
			arg0.lScrollPageSC:MoveToItemID(arg0.curMidddleIndex - 1 - 1)
			arg0:closePlateAni(arg0.plateTFList[arg0.curMidddleIndex])
		end
	end, function()
		if arg0.curMidddleIndex < arg0.lScrollPageSC.DataCount and not arg0.isPlayingAni then
			arg0:setAniState(true)
			arg0.lScrollPageSC:MoveToItemID(arg0.curMidddleIndex + 1 - 1)
			arg0:closePlateAni(arg0.plateTFList[arg0.curMidddleIndex])
		end
	end)
end

function var0.updatePlateListPanel(arg0)
	arg0.plateTFList = {}

	if #arg0.musicForShowConfigList == 0 then
		setActive(arg0.plateListPanel, false)

		return
	else
		setActive(arg0.plateListPanel, true)
	end

	arg0.lScrollPageSC.DataCount = #arg0.musicForShowConfigList

	arg0.lScrollPageSC:Init(arg0.curMidddleIndex - 1)
end

function var0.updatePlateTF(arg0, arg1, arg2)
	if #arg0.musicForShowConfigList == 0 then
		return
	end

	local var0 = arg0:findTF("CirclePanel/SmallImg", arg1)
	local var1 = arg0:findTF("PlateImg", arg1)
	local var2 = arg0:findTF("IndexNum", arg1)
	local var3 = arg0:findTF("BlackMask", arg1)
	local var4 = arg0:findTF("Lock", var3)
	local var5 = arg0:findTF("UnlockTipText", var3)
	local var6 = arg0:findTF("UnlockBtn", var3)
	local var7 = arg0:findTF("DownloadBtn", var3)
	local var8 = arg0:findTF("DownloadingImg", var3)

	setText(var8, i18n("res_downloading"))

	local var9 = arg2 + 1
	local var10 = arg0:getMusicConfigForShowByIndex(var9)
	local var11 = var10.cover
	local var12 = MusicCollectionConst.MUSIC_COVER_PATH_PREFIX .. var11

	arg0.resLoader:LoadSprite(var12, var11, var1, false)
	setText(var2, "#" .. var9)

	local var13 = var10.id
	local var14
	local var15
	local var16 = arg0.appreciateProxy:getMusicExistStateByID(var13)
	local var17 = arg0:getMusicStateByID(var13)

	if var17 == GalleryConst.CardStates.DirectShow then
		print("is impossible to go to this, something wrong")

		if var16 then
			setActive(var3, false)
		else
			setActive(var3, true)
			setActive(var4, false)
			setActive(var5, false)
			setActive(var6, false)
			setActive(var7, true)
			setActive(var8, false)
		end
	elseif var17 == GalleryConst.CardStates.Unlocked then
		if var16 then
			setActive(var3, false)
		else
			local var18 = arg0.manager.state

			if var18 == DownloadState.None or var18 == DownloadState.CheckFailure then
				arg0.manager:CheckD()
			end

			local var19 = var10.music
			local var20 = MusicCollectionConst.MUSIC_SONG_PATH_PREFIX .. var19 .. ".b"
			local var21 = arg0.manager:CheckF(var20)

			if var21 == DownloadState.None or var21 == DownloadState.CheckToUpdate or var21 == DownloadState.UpdateFailure then
				setActive(var3, true)
				setActive(var4, false)
				setActive(var5, false)
				setActive(var6, false)
				setActive(var7, true)
				setActive(var8, false)
				table.removebyvalue(arg0.downloadCheckIDList, var13, true)
				onButton(arg0, var7, function()
					local function var0()
						setActive(var3, true)
						setActive(var4, false)
						setActive(var5, false)
						setActive(var6, false)
						setActive(var7, false)
						setActive(var8, true)
						VersionMgr.Inst:RequestUIForUpdateF("GALLERY_BGM", var20, false)

						if not table.contains(arg0.downloadCheckIDList, var13) then
							table.insert(arg0.downloadCheckIDList, var13)
						end

						arg0:tryStartDownloadCheckTimer()
					end

					if Application.internetReachability == UnityEngine.NetworkReachability.ReachableViaCarrierDataNetwork then
						pg.MsgboxMgr.GetInstance():ShowMsgBox({
							content = i18n("res_wifi_tip"),
							onYes = var0
						})
					else
						var0()
					end
				end, SFX_PANEL)
			elseif var21 == DownloadState.Updating then
				setActive(var3, true)
				setActive(var4, false)
				setActive(var5, false)
				setActive(var6, false)
				setActive(var7, false)
				setActive(var8, true)
			elseif checkABExist(var20) then
				arg0.appreciateProxy:updateMusicFileExistStateTable(var13, true)
				table.removebyvalue(arg0.downloadCheckIDList, var13, true)

				if #arg0.downloadCheckIDList == 0 and arg0.downloadCheckTimer then
					arg0.downloadCheckTimer:Stop()

					arg0.downloadCheckTimer = nil
				end

				setActive(var3, false)
				arg0:updatePlayPanel()
			end
		end
	elseif var17 == GalleryConst.CardStates.Unlockable then
		setActive(var3, true)
		setActive(var4, true)
		setActive(var5, false)
		setActive(var6, true)
		setActive(var7, false)
		setActive(var8, false)
		onButton(arg0, var6, function()
			if not arg0.appreciateUnlockMsgBox then
				arg0.appreciateUnlockMsgBox = AppreciateUnlockMsgBox.New(arg0._tf, arg0.event, arg0.contextData)
			end

			arg0.appreciateUnlockMsgBox:Reset()
			arg0.appreciateUnlockMsgBox:Load()
			arg0.appreciateUnlockMsgBox:ActionInvoke("showCustomMsgBox", {
				content = i18n("res_unlock_tip"),
				items = arg0.appreciateProxy:getMusicUnlockMaterialByID(var13),
				onYes = function()
					pg.m02:sendNotification(GAME.APPRECIATE_MUSIC_UNLOCK, {
						musicID = var13,
						unlockCBFunc = function()
							arg0:updatePlateTF(arg1, arg2)
							arg0:updateSongTF(arg0.songTFList[arg2 + 1], arg2 + 1)
							arg0:updatePlayPanel()
							arg0:tryPlayMusic()
							arg0.appreciateUnlockMsgBox:hideCustomMsgBox()
						end
					})
				end
			})
		end, SFX_PANEL)
	elseif var17 == GalleryConst.CardStates.DisUnlockable then
		setActive(var3, true)
		setActive(var4, true)
		setActive(var5, true)
		setActive(var6, false)
		setActive(var7, false)
		setActive(var8, false)
		setText(var5, var10.illustrate)
	end
end

function var0.initSongListPanel(arg0)
	arg0.songUIItemList:make(function(arg0, arg1, arg2)
		if arg0 == UIItemList.EventUpdate then
			arg1 = arg1 + 1
			arg0.songTFList[arg1] = arg2

			arg0:updateSongTF(arg2, arg1)
		end
	end)
end

function var0.updateSongListPanel(arg0)
	arg0.songTFList = {}

	if #arg0.musicForShowConfigList == 0 then
		return
	end

	arg0.songUIItemList:align(#arg0.musicForShowConfigList)
end

function var0.updateSongTF(arg0, arg1, arg2)
	if #arg0.musicForShowConfigList == 0 then
		return
	end

	local var0 = arg1
	local var1 = arg0:findTF("IndexText", var0)
	local var2 = arg0:findTF("LikeToggle", var0)
	local var3 = arg0:findTF("NameText", var0)
	local var4 = arg0:findTF("PlayingImg", var0)
	local var5 = arg0:findTF("DownloadImg", var0)
	local var6 = arg0:findTF("LockImg", var0)

	setActive(var2, true)

	local var7 = arg0:getMusicConfigForShowByIndex(arg2)
	local var8 = var7.id

	arg0:updateSongTFLikeImg(arg1, arg0.appreciateProxy:isLikedByMusicID(var8))

	local var9
	local var10
	local var11 = arg0.appreciateProxy:getMusicExistStateByID(var8)
	local var12 = arg0:getMusicStateByID(var8)
	local var13 = var7.music
	local var14 = MusicCollectionConst.MUSIC_SONG_PATH_PREFIX .. var13 .. ".b"
	local var15 = arg0.manager:CheckF(var14)
	local var16

	if var12 == MusicCollectionConst.MusicStates.Unlockable then
		var16 = MusicCollectionConst.Color_Of_Empty_Song

		setActive(var4, false)
		setActive(var5, false)
		setActive(var6, true)
	elseif var12 == MusicCollectionConst.MusicStates.DisUnlockable then
		var16 = MusicCollectionConst.Color_Of_Empty_Song

		setActive(var4, false)
		setActive(var5, false)
		setActive(var6, true)
	elseif var12 == MusicCollectionConst.MusicStates.Unlocked then
		if var11 then
			local var17 = arg0.isPlayingSong
			local var18 = arg2 == arg0.curMidddleIndex

			if var17 and var18 then
				var16 = MusicCollectionConst.Color_Of_Playing_Song

				setActive(var4, true)
				setActive(var5, false)
				setActive(var6, false)
			else
				var16 = MusicCollectionConst.Color_Of_Normal_Song

				setActive(var4, false)
				setActive(var5, false)
				setActive(var6, false)
			end
		elseif var15 == DownloadState.None or var15 == DownloadState.CheckToUpdate or var15 == DownloadState.UpdateFailure then
			var16 = MusicCollectionConst.Color_Of_Empty_Song

			setActive(var4, false)
			setActive(var5, false)
			setActive(var6, false)
			table.removebyvalue(arg0.downloadCheckIDList, var8, true)

			if #arg0.downloadCheckIDList == 0 and arg0.downloadCheckTimer then
				arg0.downloadCheckTimer:Stop()

				arg0.downloadCheckTimer = nil

				return
			end
		elseif var15 == DownloadState.Updating then
			var16 = MusicCollectionConst.Color_Of_Empty_Song

			setActive(var4, false)
			setActive(var5, true)
			setActive(var6, false)
		else
			setActive(var4, false)
			setActive(var5, false)
			setActive(var6, false)

			if checkABExist(var14) then
				var16 = MusicCollectionConst.Color_Of_Normal_Song

				arg0.appreciateProxy:updateMusicFileExistStateTable(var8, true)
				table.removebyvalue(arg0.downloadCheckIDList, var8, true)

				if #arg0.downloadCheckIDList == 0 and arg0.downloadCheckTimer then
					arg0.downloadCheckTimer:Stop()

					arg0.downloadCheckTimer = nil
				end
			end
		end
	end

	setText(var1, arg2)
	setText(var3, setColorStr(var7.name, var16))
	onButton(arg0, var0, function()
		if arg0.isPlayingAni then
			return
		else
			if var12 == MusicCollectionConst.MusicStates.Unlocked then
				if var11 then
					if not isActive(var4) then
						arg0:setAniState(true)
						arg0:closePlateAni(arg0.plateTFList[arg0.curMidddleIndex])
						arg0.lScrollPageSC:MoveToItemID(arg2 - 1)
					end
				else
					local function var0()
						setActive(var4, false)
						setActive(var5, true)
						setActive(var6, false)
						VersionMgr.Inst:RequestUIForUpdateF("GALLERY_BGM", var14, false)

						if not table.contains(arg0.downloadCheckIDList, var8) then
							table.insert(arg0.downloadCheckIDList, var8)
						end

						arg0:tryStartDownloadCheckTimer()
						arg0:setAniState(true)
						arg0:closePlateAni(arg0.plateTFList[arg0.curMidddleIndex])
						arg0.lScrollPageSC:MoveToItemID(arg2 - 1)
					end

					if Application.internetReachability == UnityEngine.NetworkReachability.ReachableViaCarrierDataNetwork then
						pg.MsgboxMgr.GetInstance():ShowMsgBox({
							content = i18n("res_wifi_tip"),
							onYes = var0
						})
					else
						var0()
					end
				end
			elseif var12 == MusicCollectionConst.MusicStates.DisUnlockable then
				pg.TipsMgr.GetInstance():ShowTips(var7.illustrate)
			elseif var12 == MusicCollectionConst.MusicStates.Unlockable then
				if not arg0.appreciateUnlockMsgBox then
					arg0.appreciateUnlockMsgBox = AppreciateUnlockMsgBox.New(arg0._tf, arg0.event, arg0.contextData)
				end

				arg0.appreciateUnlockMsgBox:Reset()
				arg0.appreciateUnlockMsgBox:Load()
				arg0.appreciateUnlockMsgBox:ActionInvoke("showCustomMsgBox", {
					content = i18n("res_unlock_tip"),
					items = arg0.appreciateProxy:getMusicUnlockMaterialByID(var8),
					onYes = function()
						pg.m02:sendNotification(GAME.APPRECIATE_MUSIC_UNLOCK, {
							musicID = var8,
							unlockCBFunc = function()
								arg0.lScrollPageSC:MoveToItemID(arg2 - 1)

								if arg0.plateTFList[arg2] then
									arg0:updatePlateTF(arg0.plateTFList[arg2], arg2 - 1)
								end

								arg0:updateSongTF(arg1, arg2)
								arg0.appreciateUnlockMsgBox:hideCustomMsgBox()
							end
						})
					end
				})
			end

			arg0:closeSongListPanel()
		end
	end, SFX_PANEL)
end

function var0.updateSongTFLikeImg(arg0, arg1, arg2)
	local var0 = arg1
	local var1 = arg0:findTF("LikeToggle", var0)

	setActive(var1, true)
	triggerToggle(var1, arg2)
end

function var0.updateSortToggle(arg0)
	setActive(arg0.upImg1, arg0.sortValue == MusicCollectionConst.Sort_Order_Up)
	setActive(arg0.upImg2, arg0.sortValue == MusicCollectionConst.Sort_Order_Up)
	setActive(arg0.downImg1, arg0.sortValue == MusicCollectionConst.Sort_Order_Down)
	setActive(arg0.downImg2, arg0.sortValue == MusicCollectionConst.Sort_Order_Down)
end

function var0.updateLikeToggle(arg0)
	setActive(arg0.likeFilteOnImg, arg0.likeValue == MusicCollectionConst.Filte_Like_Value)
end

function var0.updatePlayPanel(arg0)
	if #arg0.musicForShowConfigList == 0 then
		setActive(arg0.playPanel, false)
		setActive(arg0.playingAni, false)
		setActive(arg0.staicImg, false)
		setActive(arg0.songNameText, false)
		setActive(arg0.emptyPanel, true)

		return
	else
		setActive(arg0.playPanel, true)
		setActive(arg0.playingAni, false)
		setActive(arg0.staicImg, true)
		setActive(arg0.songNameText, true)
		setActive(arg0.emptyPanel, false)
	end

	local var0 = arg0:getMusicConfigForShowByIndex(arg0.curMidddleIndex)
	local var1 = var0.cover
	local var2 = MusicCollectionConst.MUSIC_COVER_PATH_PREFIX .. var1

	arg0.resLoader:LoadSprite(var2, var1, arg0.songImg, false)

	local var3 = var0.name

	setScrollText(arg0.songNameText, var3)
	setText(arg0.playPanelNameText, var3)
	setActive(arg0.likeOnImg, arg0.appreciateProxy:isLikedByMusicID(var0.id))

	local var4
	local var5 = arg0:getMusicStateByID(var0.id)

	if var5 == GalleryConst.CardStates.Unlockable or var5 == GalleryConst.CardStates.DisUnlockable then
		setActive(arg0.likeToggle, false)
	else
		setActive(arg0.likeToggle, true)
	end

	if not arg0:isCanPlayByMusicID(var0.id) then
		setActive(arg0.playBtn, false)
		setActive(arg0.pauseBtn, false)
		setActive(arg0.lockImg, true)

		arg0.playSliderSC.enabled = false

		arg0.playSliderSC:SetValueWithoutEvent(0)
		setActive(arg0.nowTimeText, false)
		setActive(arg0.totalTimeText, false)
	else
		setActive(arg0.playBtn, true)
		setActive(arg0.pauseBtn, false)
		setActive(arg0.lockImg, false)

		arg0.playSliderSC.enabled = true

		arg0.playSliderSC:SetValueWithoutEvent(0)
		setActive(arg0.nowTimeText, true)
		setActive(arg0.totalTimeText, true)
	end
end

function var0.sortAndUpdate(arg0, arg1)
	arg0.curMidddleIndex = 1

	arg0:saveRunData()

	arg0.musicForShowConfigList = arg0:fliteMusicConfigForShow()

	arg0:sortMusicConfigList(arg1)

	arg0.musicForShowConfigList = arg0:filteMusicConfigByLike()

	arg0:stopMusic()
	arg0:checkUpdateSongTF()
	arg0:updatePlateListPanel()
	arg0:updateSongListPanel()
	arg0:updatePlayPanel()
	arg0:updateSortToggle()
	arg0:updateLikeToggle()
	arg0:tryPlayMusic()
end

function var0.initTimer(arg0)
	arg0.playProgressTimer = Timer.New(function()
		if arg0.playbackInfo then
			local var0 = arg0.playbackInfo:GetTime()

			arg0.playSliderSC:SetValueWithoutEvent(var0)
			setText(arg0.nowTimeText, arg0:descTime(var0))

			if arg0.playbackInfo.playback:GetStatus():ToInt() == 3 then
				arg0:stopMusic()
				arg0:checkUpdateSongTF()
				SetActive(arg0.pauseBtn, false)
				SetActive(arg0.playBtn, true)
				arg0:tryPlayMusic()
			end
		end
	end, 0.033, -1)

	arg0.playProgressTimer:Start()
end

function var0.playPlateAni(arg0, arg1, arg2, arg3, arg4)
	local var0 = arg0:findTF("CirclePanel", arg1)
	local var1 = arg0:findTF("BoxImg", arg1)

	setActive(var0, arg2)
	setActive(var1, arg2)

	local var2 = 0.5

	if arg2 == true then
		local var3 = 198
		local var4 = 443
		local var5 = (var4 - var3) / var2
		local var6 = 0
		local var7 = -121
		local var8 = (var7 - var6) / var2

		LeanTween.value(go(arg1), 0, var2, var2):setOnUpdate(System.Action_float(function(arg0)
			local var0 = var3 + var5 * arg0
			local var1 = var6 + var8 * arg0

			setAnchoredPosition(var0, Vector2.New(var0, 0))
			setAnchoredPosition(arg1, Vector2.New(var1, 0))
		end)):setOnComplete(System.Action(function()
			setAnchoredPosition(var0, Vector2.New(var4, 0))
			setAnchoredPosition(arg1, Vector2.New(var7, 0))
			arg0:setAniState(false)
		end))
	else
		local var9 = 448
		local var10 = 198
		local var11 = (var10 - var9) / var2
		local var12 = getAnchoredPosition(arg1).x
		local var13 = (arg3 - arg4) * (arg0.lScrollPageSC.ItemSize.x + arg0.lScrollPageSC.MarginSize.x)
		local var14 = (var13 - var12) / var2

		setAnchoredPosition(var0, Vector2.New(var10, 0))
		setAnchoredPosition(arg1, Vector2.New(var13, 0))
	end
end

function var0.closePlateAni(arg0, arg1)
	local var0 = arg0:findTF("CirclePanel", arg1)
	local var1 = arg0:findTF("BoxImg", arg1)

	setActive(var0, false)
	setActive(var1, false)
	setAnchoredPosition(var0, Vector2.New(198, 0))
	setAnchoredPosition(arg1, Vector2.zero)
end

function var0.setAniState(arg0, arg1)
	arg0.isPlayingAni = arg1
end

function var0.openSongListPanel(arg0)
	pg.UIMgr.GetInstance():BlurPanel(arg0.songListPanel, false, {
		groupName = LayerWeightConst.GROUP_COLLECTION
	})

	arg0.songListPanel.offsetMax = arg0._tf.parent.offsetMax
	arg0.songListPanel.offsetMin = arg0._tf.parent.offsetMin

	setActive(arg0.songListPanel, true)
	LeanTween.value(go(arg0.panel), -460, 500, 0.3):setOnUpdate(System.Action_float(function(arg0)
		setAnchoredPosition(arg0.panel, {
			y = arg0
		})
	end)):setOnComplete(System.Action(function()
		setAnchoredPosition(arg0.panel, {
			y = 500
		})
	end))
end

function var0.closeSongListPanel(arg0, arg1)
	if arg1 == true then
		pg.UIMgr.GetInstance():UnblurPanel(arg0.songListPanel, arg0._tf)
		setActive(arg0.songListPanel, false)
	end

	if isActive(arg0.songListPanel) then
		LeanTween.cancel(go(arg0.panel))

		local var0 = getAnchoredPosition(arg0.panel).y

		LeanTween.value(go(arg0.panel), var0, -460, 0.3):setOnUpdate(System.Action_float(function(arg0)
			setAnchoredPosition(arg0.panel, {
				y = arg0
			})
		end)):setOnComplete(System.Action(function()
			setAnchoredPosition(arg0.panel, {
				y = -460
			})
			pg.UIMgr.GetInstance():UnblurPanel(arg0.songListPanel, arg0._tf)
			setActive(arg0.songListPanel, false)
		end))
	end
end

function var0.playMusic(arg0)
	local var0 = arg0:getMusicConfigForShowByIndex(arg0.curMidddleIndex).music

	if not arg0.cueData then
		arg0.cueData = CueData.GetCueData()
	end

	arg0.cueData.channelName = pg.CriMgr.C_GALLERY_MUSIC
	arg0.cueData.cueSheetName = var0
	arg0.cueData.cueName = ""

	CriWareMgr.Inst:PlaySound(arg0.cueData, CriWareMgr.CRI_FADE_TYPE.FADE_INOUT, function(arg0)
		arg0.playbackInfo = arg0

		arg0.playbackInfo:SetIgnoreAutoUnload(true)

		local var0 = arg0.playbackInfo:GetLength()

		setSlider(arg0.playProgressBar, 0, arg0.playbackInfo:GetLength(), 0)
		setText(arg0.totalTimeText, arg0:descTime(var0))

		arg0.isPlayingSong = true

		setActive(arg0.playingAni, true)
		setActive(arg0.staicImg, false)
		arg0:updateSongTF(arg0.songTFList[arg0.curMidddleIndex], arg0.curMidddleIndex)
	end)
end

function var0.stopMusic(arg0)
	if arg0.playbackInfo then
		arg0.playbackInfo:SetStartTime(0)
		CriWareMgr.Inst:StopSound(arg0.cueData, CriWareMgr.CRI_FADE_TYPE.NONE)

		arg0.playbackInfo = nil
		arg0.isPlayingSong = false
	end

	setActive(arg0.playingAni, false)
	setActive(arg0.staicImg, true)
	arg0.playSliderSC:SetValueWithoutEvent(0)
	setText(arg0.nowTimeText, arg0:descTime(0))
end

function var0.checkUpdateSongTF(arg0)
	if #arg0.songTFList > 0 then
		arg0:updateSongTF(arg0.songTFList[arg0.curMidddleIndex], arg0.curMidddleIndex)
	end
end

function var0.tryPlayMusic(arg0)
	if #arg0.musicForShowConfigList == 0 then
		return
	end

	local var0 = arg0:getMusicConfigForShowByIndex(arg0.curMidddleIndex)

	if arg0:isCanPlayByMusicID(var0.id) and isActive(arg0.playBtn) then
		triggerButton(arg0.playBtn)
	end
end

function var0.tryPauseMusic(arg0)
	if isActive(arg0.pauseBtn) and arg0.playbackInfo then
		triggerButton(arg0.pauseBtn)
	end
end

function var0.fliteMusicConfigForShow(arg0)
	local var0 = {}

	for iter0, iter1 in ipairs(pg.music_collect_config.all) do
		local var1 = arg0.appreciateProxy:getSingleMusicConfigByID(iter1)

		if arg0.appreciateProxy:isMusicNeedUnlockByID(iter1) then
			if not arg0.appreciateProxy:isMusicUnlockedByID(iter1) then
				local var2, var3 = arg0.appreciateProxy:isMusicUnlockableByID(iter1)

				if var2 then
					var0[#var0 + 1] = var1
				elseif var3 then
					var0[#var0 + 1] = var1
				end
			else
				var0[#var0 + 1] = var1
			end
		else
			var0[#var0 + 1] = var1
		end
	end

	return var0
end

function var0.getMusicConfigForShowByIndex(arg0, arg1)
	local var0 = arg0.musicForShowConfigList[arg1]

	if var0 then
		return var0
	else
		assert(false, "不存在的index" .. tostring(arg1))
	end
end

function var0.getMusicStateByID(arg0, arg1)
	if not arg0.appreciateProxy:isMusicNeedUnlockByID(arg1) then
		return MusicCollectionConst.MusicStates.Unlocked
	elseif arg0.appreciateProxy:isMusicUnlockedByID(arg1) then
		return MusicCollectionConst.MusicStates.Unlocked
	elseif arg0.appreciateProxy:isMusicUnlockableByID(arg1) then
		return MusicCollectionConst.MusicStates.Unlockable
	else
		return MusicCollectionConst.MusicStates.DisUnlockable
	end
end

function var0.sortMusicConfigList(arg0, arg1)
	local function var0(arg0, arg1)
		local var0 = arg0.id
		local var1 = arg1.id

		if arg1 == true then
			return var1 < var0
		else
			return var0 < var1
		end
	end

	table.sort(arg0.musicForShowConfigList, var0)
end

function var0.filteMusicConfigByLike(arg0)
	if arg0.likeValue == MusicCollectionConst.Filte_Normal_Value then
		return arg0.musicForShowConfigList
	end

	local var0 = {}

	for iter0, iter1 in ipairs(arg0.musicForShowConfigList) do
		local var1 = iter1.id

		if arg0.appreciateProxy:isLikedByMusicID(var1) then
			var0[#var0 + 1] = iter1
		end
	end

	return var0
end

function var0.isCanPlayByMusicID(arg0, arg1)
	local var0
	local var1
	local var2 = arg0.appreciateProxy:getMusicExistStateByID(arg1)
	local var3 = arg0:getMusicStateByID(arg1)

	if var3 == GalleryConst.CardStates.DirectShow then
		print("is impossible to go to this, something wrong")

		if var2 then
			return true
		else
			return false
		end
	elseif var3 == GalleryConst.CardStates.Unlocked then
		if var2 then
			return true
		else
			return false
		end
	elseif var3 == GalleryConst.CardStates.Unlockable then
		return false
	elseif var3 == GalleryConst.CardStates.DisUnlockable then
		return false
	end
end

function var0.descTime(arg0, arg1)
	local var0 = math.floor(arg1 / 1000)
	local var1 = math.floor(var0 / 3600)
	local var2 = var0 - var1 * 3600
	local var3 = math.floor(var2 / 60)
	local var4 = var2 % 60

	if var1 ~= 0 then
		return string.format("%02d:%02d:%02d", var1, var3, var4)
	else
		return string.format("%02d:%02d", var3, var4)
	end
end

function var0.tryStartDownloadCheckTimer(arg0)
	if #arg0.downloadCheckIDList == 0 and arg0.downloadCheckTimer then
		arg0.downloadCheckTimer:Stop()

		arg0.downloadCheckTimer = nil

		return
	end

	if not arg0.downloadCheckTimer and #arg0.downloadCheckIDList > 0 then
		local function var0()
			for iter0, iter1 in ipairs(arg0.downloadCheckIDList) do
				local var0

				for iter2, iter3 in ipairs(arg0.musicForShowConfigList) do
					if iter3.id == iter1 then
						var0 = iter2

						break
					end
				end

				if var0 then
					local var1 = arg0.plateTFList[var0]

					arg0:updatePlateTF(var1, var0 - 1)

					local var2 = arg0.songTFList[var0]

					arg0:updateSongTF(var2, var0)
				end
			end
		end

		arg0.downloadCheckTimer = Timer.New(var0, 1, -1)

		arg0.downloadCheckTimer:Start()
	end
end

return var0
