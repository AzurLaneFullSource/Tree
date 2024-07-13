local var0_0 = class("MusicCollectionView", import("..base.BaseSubView"))

function var0_0.getUIName(arg0_1)
	return "MusicCollectionUI"
end

function var0_0.OnInit(arg0_2)
	arg0_2:initData()
	arg0_2:findUI()
	arg0_2:addListener()
	arg0_2:initPlateListPanel()
	arg0_2:initSongListPanel()
	arg0_2:Show()
	arg0_2:recoverRunData()
	arg0_2:initTimer()
	arg0_2:tryShowTipMsgBox()
end

function var0_0.OnDestroy(arg0_3)
	arg0_3:stopMusic()
	arg0_3.resLoader:Clear()

	if arg0_3.playProgressTimer then
		arg0_3.playProgressTimer:Stop()

		arg0_3.playProgressTimer = nil
	end

	if arg0_3.downloadCheckTimer then
		arg0_3.downloadCheckTimer:Stop()

		arg0_3.downloadCheckTimer = nil
	end

	if arg0_3.playbackInfo then
		arg0_3.playbackInfo = nil
	end

	if arg0_3.appreciateUnlockMsgBox and arg0_3.appreciateUnlockMsgBox:CheckState(BaseSubView.STATES.INITED) then
		arg0_3.appreciateUnlockMsgBox:Destroy()
	end

	arg0_3:closeSongListPanel(true)
end

function var0_0.onBackPressed(arg0_4)
	if arg0_4.appreciateUnlockMsgBox and arg0_4.appreciateUnlockMsgBox:CheckState(BaseSubView.STATES.INITED) then
		arg0_4.appreciateUnlockMsgBox:hideCustomMsgBox()
		arg0_4.appreciateUnlockMsgBox:Destroy()

		return false
	elseif isActive(arg0_4.songListPanel) then
		arg0_4:closeSongListPanel()

		return false
	else
		return true
	end
end

function var0_0.initData(arg0_5)
	arg0_5.appreciateProxy = getProxy(AppreciateProxy)

	arg0_5.appreciateProxy:checkMusicFileState()

	arg0_5.resLoader = AutoLoader.New()
	arg0_5.criMgr = pg.CriMgr.GetInstance()
	arg0_5.manager = BundleWizard.Inst:GetGroupMgr("GALLERY_BGM")
	arg0_5.downloadCheckIDList = {}
	arg0_5.downloadCheckTimer = nil
	arg0_5.musicForShowConfigList = {}
	arg0_5.plateTFList = {}
	arg0_5.songTFList = {}
	arg0_5.curMidddleIndex = 1
	arg0_5.sortValue = MusicCollectionConst.Sort_Order_Up
	arg0_5.likeValue = MusicCollectionConst.Filte_Normal_Value
	arg0_5.isPlayingAni = false
	arg0_5.cueData = nil
	arg0_5.playbackInfo = nil
	arg0_5.playProgressTimer = nil
	arg0_5.onDrag = false
	arg0_5.hadDrag = false
	arg0_5.isPlayingSong = false
end

function var0_0.saveRunData(arg0_6)
	arg0_6.appreciateProxy:updateMusicRunData(arg0_6.sortValue, arg0_6.curMidddleIndex, arg0_6.likeValue)
end

function var0_0.recoverRunData(arg0_7)
	local var0_7 = arg0_7.appreciateProxy:getMusicRunData()

	arg0_7.sortValue = var0_7.sortValue
	arg0_7.curMidddleIndex = var0_7.middleIndex
	arg0_7.likeValue = var0_7.likeValue
	arg0_7.musicForShowConfigList = arg0_7:fliteMusicConfigForShow()

	arg0_7:sortMusicConfigList(arg0_7.sortValue == MusicCollectionConst.Sort_Order_Down)

	arg0_7.musicForShowConfigList = arg0_7:filteMusicConfigByLike()
	arg0_7.lScrollPageSC.MiddleIndexOnInit = arg0_7.curMidddleIndex - 1

	arg0_7:updatePlateListPanel()
	arg0_7:updateSongListPanel()
	arg0_7:updatePlayPanel()
	arg0_7:updateSortToggle()
	arg0_7:updateLikeToggle()

	if not arg0_7.appreciateProxy:isMusicHaveNewRes() then
		arg0_7:tryPlayMusic()
	end
end

function var0_0.findUI(arg0_8)
	setLocalPosition(arg0_8._tf, Vector2.zero)

	arg0_8._tf.anchorMin = Vector2.zero
	arg0_8._tf.anchorMax = Vector2.one
	arg0_8._tf.offsetMax = Vector2.zero
	arg0_8._tf.offsetMin = Vector2.zero
	arg0_8.topPanel = arg0_8:findTF("TopPanel")
	arg0_8.likeFilteToggle = arg0_8:findTF("LikeBtn", arg0_8.topPanel)
	arg0_8.sortToggle = arg0_8:findTF("SortBtn", arg0_8.topPanel)
	arg0_8.songNameText = arg0_8:findTF("MusicNameMask/MusicName", arg0_8.topPanel)
	arg0_8.staicImg = arg0_8:findTF("SoundImg", arg0_8.topPanel)
	arg0_8.playingAni = arg0_8:findTF("SoundAni", arg0_8.topPanel)
	arg0_8.resRepaireBtn = arg0_8:findTF("RepaireBtn", arg0_8.topPanel)

	setActive(arg0_8.likeFilteToggle, true)

	arg0_8.plateListPanel = arg0_8:findTF("PlateList")
	arg0_8.plateTpl = arg0_8:findTF("Plate", arg0_8.plateListPanel)
	arg0_8.lScrollPageSC = GetComponent(arg0_8.plateListPanel, "LScrollPage")
	arg0_8.playPanel = arg0_8:findTF("PLayPanel")
	arg0_8.playPanelNameText = arg0_8:findTF("NameText", arg0_8.playPanel)
	arg0_8.likeToggle = arg0_8:findTF("LikeBtn", arg0_8.playPanel)
	arg0_8.songImg = arg0_8:findTF("SongImg", arg0_8.playPanel)
	arg0_8.pauseBtn = arg0_8:findTF("PlayingBtn", arg0_8.playPanel)
	arg0_8.playBtn = arg0_8:findTF("StopingBtn", arg0_8.playPanel)
	arg0_8.lockImg = arg0_8:findTF("LockedBtn", arg0_8.playPanel)
	arg0_8.nextBtn = arg0_8:findTF("NextBtn", arg0_8.playPanel)
	arg0_8.preBtn = arg0_8:findTF("PreBtn", arg0_8.playPanel)
	arg0_8.playProgressBar = arg0_8:findTF("Progress", arg0_8.playPanel)
	arg0_8.nowTimeText = arg0_8:findTF("NowTimeText", arg0_8.playProgressBar)
	arg0_8.totalTimeText = arg0_8:findTF("TotalTimeText", arg0_8.playProgressBar)
	arg0_8.playSliderSC = GetComponent(arg0_8.playProgressBar, "LSlider")
	arg0_8.listBtn = arg0_8:findTF("ListBtn", arg0_8.playPanel)

	setActive(arg0_8.likeToggle, true)

	arg0_8.songListPanel = arg0_8:findTF("SongListPanel")
	arg0_8.closeBtn = arg0_8:findTF("BG", arg0_8.songListPanel)
	arg0_8.panel = arg0_8:findTF("Panel", arg0_8.songListPanel)
	arg0_8.songContainer = arg0_8:findTF("Container/Viewport/Content", arg0_8.panel)
	arg0_8.songTpl = arg0_8:findTF("SongTpl", arg0_8.panel)
	arg0_8.upToggle = arg0_8:findTF("BG2/UpToggle", arg0_8.panel)
	arg0_8.downToggle = arg0_8:findTF("BG2/DownToggle", arg0_8.panel)
	arg0_8.songUIItemList = UIItemList.New(arg0_8.songContainer, arg0_8.songTpl)
	arg0_8.emptyPanel = arg0_8:findTF("EmptyPanel")
	arg0_8.upImg1 = arg0_8:findTF("Up", arg0_8.sortToggle)
	arg0_8.downImg1 = arg0_8:findTF("Down", arg0_8.sortToggle)
	arg0_8.upImg2 = arg0_8:findTF("SelImg", arg0_8.upToggle)
	arg0_8.downImg2 = arg0_8:findTF("SelImg", arg0_8.downToggle)
	arg0_8.likeFilteOffImg = arg0_8:findTF("Off", arg0_8.likeFilteToggle)
	arg0_8.likeFilteOnImg = arg0_8:findTF("On", arg0_8.likeFilteToggle)
	arg0_8.likeOffImg = arg0_8:findTF("Off", arg0_8.likeToggle)
	arg0_8.likeOnImg = arg0_8:findTF("On", arg0_8.likeToggle)
end

function var0_0.addListener(arg0_9)
	onButton(arg0_9, arg0_9.listBtn, function()
		arg0_9:openSongListPanel()
	end, SFX_PANEL)
	onButton(arg0_9, arg0_9.closeBtn, function()
		arg0_9:closeSongListPanel()
	end, SFX_PANEL)
	onButton(arg0_9, arg0_9.resRepaireBtn, function()
		local var0_12 = {
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
				var0_12
			}
		})
	end, SFX_PANEL)
	onButton(arg0_9, arg0_9.sortToggle, function()
		arg0_9.sortValue = arg0_9.sortValue == MusicCollectionConst.Sort_Order_Up and MusicCollectionConst.Sort_Order_Down or MusicCollectionConst.Sort_Order_Up

		arg0_9:saveRunData()
		arg0_9:sortAndUpdate(arg0_9.sortValue == MusicCollectionConst.Sort_Order_Down)
	end, SFX_PANEL)
	onButton(arg0_9, arg0_9.upToggle, function()
		if arg0_9.sortValue == MusicCollectionConst.Sort_Order_Up then
			return
		else
			arg0_9.sortValue = MusicCollectionConst.Sort_Order_Up

			arg0_9:saveRunData()
			arg0_9:sortAndUpdate(false)
		end
	end, SFX_PANEL)
	onButton(arg0_9, arg0_9.downToggle, function()
		if arg0_9.sortValue == MusicCollectionConst.Sort_Order_Down then
			return
		else
			arg0_9.sortValue = MusicCollectionConst.Sort_Order_Down

			arg0_9:saveRunData()
			arg0_9:sortAndUpdate(true)
		end
	end, SFX_PANEL)
	onButton(arg0_9, arg0_9.likeFilteToggle, function()
		arg0_9.likeValue = arg0_9.likeValue == MusicCollectionConst.Filte_Normal_Value and MusicCollectionConst.Filte_Like_Value or MusicCollectionConst.Filte_Normal_Value

		arg0_9:saveRunData()
		arg0_9:sortAndUpdate(arg0_9.sortValue == MusicCollectionConst.Sort_Order_Down)
	end, SFX_PANEL)
	onButton(arg0_9, arg0_9.playBtn, function()
		if not arg0_9.playbackInfo then
			arg0_9:playMusic()
		elseif arg0_9.hadDrag then
			arg0_9.hadDrag = false

			arg0_9.playbackInfo:SetStartTimeAndPlay(arg0_9.playSliderSC.value)
			arg0_9.playProgressTimer:Start()
		else
			arg0_9.playbackInfo.playback:Resume(CriAtomEx.ResumeMode.PausedPlayback)
		end

		setActive(arg0_9.playingAni, true)
		setActive(arg0_9.staicImg, false)
		SetActive(arg0_9.pauseBtn, true)
		SetActive(arg0_9.playBtn, false)
	end, SFX_PANEL)
	onButton(arg0_9, arg0_9.pauseBtn, function()
		if arg0_9.playbackInfo then
			arg0_9.playbackInfo.playback:Pause()
		end

		setActive(arg0_9.playingAni, false)
		setActive(arg0_9.staicImg, true)
		SetActive(arg0_9.pauseBtn, false)
		SetActive(arg0_9.playBtn, true)
	end, SFX_PANEL)
	onButton(arg0_9, arg0_9.preBtn, function()
		if arg0_9.curMidddleIndex == 1 then
			pg.TipsMgr.GetInstance():ShowTips(i18n("res_music_no_pre_tip"))
		elseif not arg0_9.isPlayingAni then
			arg0_9:setAniState(true)
			arg0_9:closePlateAni(arg0_9.plateTFList[arg0_9.curMidddleIndex])
			arg0_9.lScrollPageSC:MoveToItemID(arg0_9.curMidddleIndex - 1 - 1)
		end
	end, SFX_PANEL)
	onButton(arg0_9, arg0_9.nextBtn, function()
		if arg0_9.curMidddleIndex == #arg0_9.musicForShowConfigList then
			pg.TipsMgr.GetInstance():ShowTips(i18n("res_music_no_next_tip"))
		elseif not arg0_9.isPlayingAni then
			arg0_9:setAniState(true)
			arg0_9:closePlateAni(arg0_9.plateTFList[arg0_9.curMidddleIndex])
			arg0_9.lScrollPageSC:MoveToItemID(arg0_9.curMidddleIndex + 1 - 1)
		end
	end, SFX_PANEL)
	onButton(arg0_9, arg0_9.likeToggle, function()
		local var0_22 = arg0_9:getMusicConfigForShowByIndex(arg0_9.curMidddleIndex).id

		if arg0_9.appreciateProxy:isLikedByMusicID(var0_22) == true then
			pg.m02:sendNotification(GAME.APPRECIATE_MUSIC_LIKE, {
				isAdd = 1,
				musicID = var0_22
			})
			setActive(arg0_9.likeOnImg, false)
			arg0_9:updateSongTFLikeImg(arg0_9.songTFList[arg0_9.curMidddleIndex], false)
		else
			pg.m02:sendNotification(GAME.APPRECIATE_MUSIC_LIKE, {
				isAdd = 0,
				musicID = var0_22
			})
			setActive(arg0_9.likeOnImg, true)
			arg0_9:updateSongTFLikeImg(arg0_9.songTFList[arg0_9.curMidddleIndex], true)
		end
	end, SFX_PANEL)
	arg0_9.playSliderSC:AddPointDownFunc(function(arg0_23)
		if arg0_9.playbackInfo and not arg0_9.onDrag then
			arg0_9.onDrag = true

			if arg0_9.playbackInfo.playback:IsPaused() then
				-- block empty
			else
				arg0_9.playbackInfo.playback:Stop(true)
			end

			arg0_9.playProgressTimer:Stop()
		end
	end)
	arg0_9.playSliderSC:AddPointUpFunc(function(arg0_24)
		if arg0_9.playbackInfo and arg0_9.onDrag then
			arg0_9.onDrag = false

			if arg0_9.playbackInfo.playback:IsPaused() then
				arg0_9.hadDrag = true
			else
				arg0_9.playbackInfo:SetStartTimeAndPlay(arg0_9.playSliderSC.value)
				arg0_9.playProgressTimer:Start()
			end
		else
			arg0_9.playSliderSC:SetValueWithoutEvent(0)
		end
	end)
end

function var0_0.tryShowTipMsgBox(arg0_25)
	if arg0_25.appreciateProxy:isMusicHaveNewRes() then
		local function var0_25()
			arg0_25.lScrollPageSC:MoveToItemID(MusicCollectionConst.AutoScrollIndex - 1)
			PlayerPrefs.SetInt("musicVersion", MusicCollectionConst.Version)
			arg0_25:emit(CollectionScene.UPDATE_RED_POINT)
		end

		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			hideClose = true,
			hideNo = true,
			content = i18n("res_music_new_tip", MusicCollectionConst.NewCount),
			onYes = var0_25,
			onCancel = var0_25,
			onClose = var0_25
		})
	end
end

function var0_0.initPlateListPanel(arg0_27)
	function arg0_27.lScrollPageSC.itemInitedCallback(arg0_28, arg1_28)
		local var0_28 = arg0_28 + 1

		arg0_27.plateTFList[var0_28] = arg1_28

		arg0_27:updatePlateTF(arg1_28, arg0_28)
	end

	function arg0_27.lScrollPageSC.itemClickCallback(arg0_29, arg1_29)
		local var0_29 = arg0_29 + 1

		if arg0_27.curMidddleIndex ~= var0_29 and not arg0_27.isPlayingAni then
			arg0_27:setAniState(true)
			arg0_27:closePlateAni(arg0_27.plateTFList[arg0_27.curMidddleIndex])
			arg0_27.lScrollPageSC:MoveToItemID(arg0_29)
		end
	end

	function arg0_27.lScrollPageSC.itemPitchCallback(arg0_30, arg1_30)
		local var0_30 = arg0_30 + 1

		arg0_27:stopMusic()
		arg0_27:checkUpdateSongTF()

		arg0_27.curMidddleIndex = arg0_30 + 1

		arg0_27:saveRunData()
		arg0_27:playPlateAni(arg1_30, true)
		arg0_27:updatePlayPanel()
		arg0_27:tryPlayMusic()
	end

	function arg0_27.lScrollPageSC.itemRecycleCallback(arg0_31, arg1_31)
		arg0_27.plateTFList[arg0_31 + 1] = nil
	end

	addSlip(SLIP_TYPE_HRZ, arg0_27.plateListPanel, function()
		if arg0_27.curMidddleIndex > 1 and not arg0_27.isPlayingAni then
			arg0_27:setAniState(true)
			arg0_27.lScrollPageSC:MoveToItemID(arg0_27.curMidddleIndex - 1 - 1)
			arg0_27:closePlateAni(arg0_27.plateTFList[arg0_27.curMidddleIndex])
		end
	end, function()
		if arg0_27.curMidddleIndex < arg0_27.lScrollPageSC.DataCount and not arg0_27.isPlayingAni then
			arg0_27:setAniState(true)
			arg0_27.lScrollPageSC:MoveToItemID(arg0_27.curMidddleIndex + 1 - 1)
			arg0_27:closePlateAni(arg0_27.plateTFList[arg0_27.curMidddleIndex])
		end
	end)
end

function var0_0.updatePlateListPanel(arg0_34)
	arg0_34.plateTFList = {}

	if #arg0_34.musicForShowConfigList == 0 then
		setActive(arg0_34.plateListPanel, false)

		return
	else
		setActive(arg0_34.plateListPanel, true)
	end

	arg0_34.lScrollPageSC.DataCount = #arg0_34.musicForShowConfigList

	arg0_34.lScrollPageSC:Init(arg0_34.curMidddleIndex - 1)
end

function var0_0.updatePlateTF(arg0_35, arg1_35, arg2_35)
	if #arg0_35.musicForShowConfigList == 0 then
		return
	end

	local var0_35 = arg0_35:findTF("CirclePanel/SmallImg", arg1_35)
	local var1_35 = arg0_35:findTF("PlateImg", arg1_35)
	local var2_35 = arg0_35:findTF("IndexNum", arg1_35)
	local var3_35 = arg0_35:findTF("BlackMask", arg1_35)
	local var4_35 = arg0_35:findTF("Lock", var3_35)
	local var5_35 = arg0_35:findTF("UnlockTipText", var3_35)
	local var6_35 = arg0_35:findTF("UnlockBtn", var3_35)
	local var7_35 = arg0_35:findTF("DownloadBtn", var3_35)
	local var8_35 = arg0_35:findTF("DownloadingImg", var3_35)

	setText(var8_35, i18n("res_downloading"))

	local var9_35 = arg2_35 + 1
	local var10_35 = arg0_35:getMusicConfigForShowByIndex(var9_35)
	local var11_35 = var10_35.cover
	local var12_35 = MusicCollectionConst.MUSIC_COVER_PATH_PREFIX .. var11_35

	arg0_35.resLoader:LoadSprite(var12_35, var11_35, var1_35, false)
	setText(var2_35, "#" .. var9_35)

	local var13_35 = var10_35.id
	local var14_35
	local var15_35
	local var16_35 = arg0_35.appreciateProxy:getMusicExistStateByID(var13_35)
	local var17_35 = arg0_35:getMusicStateByID(var13_35)

	if var17_35 == GalleryConst.CardStates.DirectShow then
		print("is impossible to go to this, something wrong")

		if var16_35 then
			setActive(var3_35, false)
		else
			setActive(var3_35, true)
			setActive(var4_35, false)
			setActive(var5_35, false)
			setActive(var6_35, false)
			setActive(var7_35, true)
			setActive(var8_35, false)
		end
	elseif var17_35 == GalleryConst.CardStates.Unlocked then
		if var16_35 then
			setActive(var3_35, false)
		else
			local var18_35 = arg0_35.manager.state

			if var18_35 == DownloadState.None or var18_35 == DownloadState.CheckFailure then
				arg0_35.manager:CheckD()
			end

			local var19_35 = var10_35.music
			local var20_35 = MusicCollectionConst.MUSIC_SONG_PATH_PREFIX .. var19_35 .. ".b"
			local var21_35 = arg0_35.manager:CheckF(var20_35)

			if var21_35 == DownloadState.None or var21_35 == DownloadState.CheckToUpdate or var21_35 == DownloadState.UpdateFailure then
				setActive(var3_35, true)
				setActive(var4_35, false)
				setActive(var5_35, false)
				setActive(var6_35, false)
				setActive(var7_35, true)
				setActive(var8_35, false)
				table.removebyvalue(arg0_35.downloadCheckIDList, var13_35, true)
				onButton(arg0_35, var7_35, function()
					local function var0_36()
						setActive(var3_35, true)
						setActive(var4_35, false)
						setActive(var5_35, false)
						setActive(var6_35, false)
						setActive(var7_35, false)
						setActive(var8_35, true)
						VersionMgr.Inst:RequestUIForUpdateF("GALLERY_BGM", var20_35, false)

						if not table.contains(arg0_35.downloadCheckIDList, var13_35) then
							table.insert(arg0_35.downloadCheckIDList, var13_35)
						end

						arg0_35:tryStartDownloadCheckTimer()
					end

					if Application.internetReachability == UnityEngine.NetworkReachability.ReachableViaCarrierDataNetwork then
						pg.MsgboxMgr.GetInstance():ShowMsgBox({
							content = i18n("res_wifi_tip"),
							onYes = var0_36
						})
					else
						var0_36()
					end
				end, SFX_PANEL)
			elseif var21_35 == DownloadState.Updating then
				setActive(var3_35, true)
				setActive(var4_35, false)
				setActive(var5_35, false)
				setActive(var6_35, false)
				setActive(var7_35, false)
				setActive(var8_35, true)
			elseif checkABExist(var20_35) then
				arg0_35.appreciateProxy:updateMusicFileExistStateTable(var13_35, true)
				table.removebyvalue(arg0_35.downloadCheckIDList, var13_35, true)

				if #arg0_35.downloadCheckIDList == 0 and arg0_35.downloadCheckTimer then
					arg0_35.downloadCheckTimer:Stop()

					arg0_35.downloadCheckTimer = nil
				end

				setActive(var3_35, false)
				arg0_35:updatePlayPanel()
			end
		end
	elseif var17_35 == GalleryConst.CardStates.Unlockable then
		setActive(var3_35, true)
		setActive(var4_35, true)
		setActive(var5_35, false)
		setActive(var6_35, true)
		setActive(var7_35, false)
		setActive(var8_35, false)
		onButton(arg0_35, var6_35, function()
			if not arg0_35.appreciateUnlockMsgBox then
				arg0_35.appreciateUnlockMsgBox = AppreciateUnlockMsgBox.New(arg0_35._tf, arg0_35.event, arg0_35.contextData)
			end

			arg0_35.appreciateUnlockMsgBox:Reset()
			arg0_35.appreciateUnlockMsgBox:Load()
			arg0_35.appreciateUnlockMsgBox:ActionInvoke("showCustomMsgBox", {
				content = i18n("res_unlock_tip"),
				items = arg0_35.appreciateProxy:getMusicUnlockMaterialByID(var13_35),
				onYes = function()
					pg.m02:sendNotification(GAME.APPRECIATE_MUSIC_UNLOCK, {
						musicID = var13_35,
						unlockCBFunc = function()
							arg0_35:updatePlateTF(arg1_35, arg2_35)
							arg0_35:updateSongTF(arg0_35.songTFList[arg2_35 + 1], arg2_35 + 1)
							arg0_35:updatePlayPanel()
							arg0_35:tryPlayMusic()
							arg0_35.appreciateUnlockMsgBox:hideCustomMsgBox()
						end
					})
				end
			})
		end, SFX_PANEL)
	elseif var17_35 == GalleryConst.CardStates.DisUnlockable then
		setActive(var3_35, true)
		setActive(var4_35, true)
		setActive(var5_35, true)
		setActive(var6_35, false)
		setActive(var7_35, false)
		setActive(var8_35, false)
		setText(var5_35, var10_35.illustrate)
	end
end

function var0_0.initSongListPanel(arg0_41)
	arg0_41.songUIItemList:make(function(arg0_42, arg1_42, arg2_42)
		if arg0_42 == UIItemList.EventUpdate then
			arg1_42 = arg1_42 + 1
			arg0_41.songTFList[arg1_42] = arg2_42

			arg0_41:updateSongTF(arg2_42, arg1_42)
		end
	end)
end

function var0_0.updateSongListPanel(arg0_43)
	arg0_43.songTFList = {}

	if #arg0_43.musicForShowConfigList == 0 then
		return
	end

	arg0_43.songUIItemList:align(#arg0_43.musicForShowConfigList)
end

function var0_0.updateSongTF(arg0_44, arg1_44, arg2_44)
	if #arg0_44.musicForShowConfigList == 0 then
		return
	end

	local var0_44 = arg1_44
	local var1_44 = arg0_44:findTF("IndexText", var0_44)
	local var2_44 = arg0_44:findTF("LikeToggle", var0_44)
	local var3_44 = arg0_44:findTF("NameText", var0_44)
	local var4_44 = arg0_44:findTF("PlayingImg", var0_44)
	local var5_44 = arg0_44:findTF("DownloadImg", var0_44)
	local var6_44 = arg0_44:findTF("LockImg", var0_44)

	setActive(var2_44, true)

	local var7_44 = arg0_44:getMusicConfigForShowByIndex(arg2_44)
	local var8_44 = var7_44.id

	arg0_44:updateSongTFLikeImg(arg1_44, arg0_44.appreciateProxy:isLikedByMusicID(var8_44))

	local var9_44
	local var10_44
	local var11_44 = arg0_44.appreciateProxy:getMusicExistStateByID(var8_44)
	local var12_44 = arg0_44:getMusicStateByID(var8_44)
	local var13_44 = var7_44.music
	local var14_44 = MusicCollectionConst.MUSIC_SONG_PATH_PREFIX .. var13_44 .. ".b"
	local var15_44 = arg0_44.manager:CheckF(var14_44)
	local var16_44

	if var12_44 == MusicCollectionConst.MusicStates.Unlockable then
		var16_44 = MusicCollectionConst.Color_Of_Empty_Song

		setActive(var4_44, false)
		setActive(var5_44, false)
		setActive(var6_44, true)
	elseif var12_44 == MusicCollectionConst.MusicStates.DisUnlockable then
		var16_44 = MusicCollectionConst.Color_Of_Empty_Song

		setActive(var4_44, false)
		setActive(var5_44, false)
		setActive(var6_44, true)
	elseif var12_44 == MusicCollectionConst.MusicStates.Unlocked then
		if var11_44 then
			local var17_44 = arg0_44.isPlayingSong
			local var18_44 = arg2_44 == arg0_44.curMidddleIndex

			if var17_44 and var18_44 then
				var16_44 = MusicCollectionConst.Color_Of_Playing_Song

				setActive(var4_44, true)
				setActive(var5_44, false)
				setActive(var6_44, false)
			else
				var16_44 = MusicCollectionConst.Color_Of_Normal_Song

				setActive(var4_44, false)
				setActive(var5_44, false)
				setActive(var6_44, false)
			end
		elseif var15_44 == DownloadState.None or var15_44 == DownloadState.CheckToUpdate or var15_44 == DownloadState.UpdateFailure then
			var16_44 = MusicCollectionConst.Color_Of_Empty_Song

			setActive(var4_44, false)
			setActive(var5_44, false)
			setActive(var6_44, false)
			table.removebyvalue(arg0_44.downloadCheckIDList, var8_44, true)

			if #arg0_44.downloadCheckIDList == 0 and arg0_44.downloadCheckTimer then
				arg0_44.downloadCheckTimer:Stop()

				arg0_44.downloadCheckTimer = nil

				return
			end
		elseif var15_44 == DownloadState.Updating then
			var16_44 = MusicCollectionConst.Color_Of_Empty_Song

			setActive(var4_44, false)
			setActive(var5_44, true)
			setActive(var6_44, false)
		else
			setActive(var4_44, false)
			setActive(var5_44, false)
			setActive(var6_44, false)

			if checkABExist(var14_44) then
				var16_44 = MusicCollectionConst.Color_Of_Normal_Song

				arg0_44.appreciateProxy:updateMusicFileExistStateTable(var8_44, true)
				table.removebyvalue(arg0_44.downloadCheckIDList, var8_44, true)

				if #arg0_44.downloadCheckIDList == 0 and arg0_44.downloadCheckTimer then
					arg0_44.downloadCheckTimer:Stop()

					arg0_44.downloadCheckTimer = nil
				end
			end
		end
	end

	setText(var1_44, arg2_44)
	setText(var3_44, setColorStr(var7_44.name, var16_44))
	onButton(arg0_44, var0_44, function()
		if arg0_44.isPlayingAni then
			return
		else
			if var12_44 == MusicCollectionConst.MusicStates.Unlocked then
				if var11_44 then
					if not isActive(var4_44) then
						arg0_44:setAniState(true)
						arg0_44:closePlateAni(arg0_44.plateTFList[arg0_44.curMidddleIndex])
						arg0_44.lScrollPageSC:MoveToItemID(arg2_44 - 1)
					end
				else
					local function var0_45()
						setActive(var4_44, false)
						setActive(var5_44, true)
						setActive(var6_44, false)
						VersionMgr.Inst:RequestUIForUpdateF("GALLERY_BGM", var14_44, false)

						if not table.contains(arg0_44.downloadCheckIDList, var8_44) then
							table.insert(arg0_44.downloadCheckIDList, var8_44)
						end

						arg0_44:tryStartDownloadCheckTimer()
						arg0_44:setAniState(true)
						arg0_44:closePlateAni(arg0_44.plateTFList[arg0_44.curMidddleIndex])
						arg0_44.lScrollPageSC:MoveToItemID(arg2_44 - 1)
					end

					if Application.internetReachability == UnityEngine.NetworkReachability.ReachableViaCarrierDataNetwork then
						pg.MsgboxMgr.GetInstance():ShowMsgBox({
							content = i18n("res_wifi_tip"),
							onYes = var0_45
						})
					else
						var0_45()
					end
				end
			elseif var12_44 == MusicCollectionConst.MusicStates.DisUnlockable then
				pg.TipsMgr.GetInstance():ShowTips(var7_44.illustrate)
			elseif var12_44 == MusicCollectionConst.MusicStates.Unlockable then
				if not arg0_44.appreciateUnlockMsgBox then
					arg0_44.appreciateUnlockMsgBox = AppreciateUnlockMsgBox.New(arg0_44._tf, arg0_44.event, arg0_44.contextData)
				end

				arg0_44.appreciateUnlockMsgBox:Reset()
				arg0_44.appreciateUnlockMsgBox:Load()
				arg0_44.appreciateUnlockMsgBox:ActionInvoke("showCustomMsgBox", {
					content = i18n("res_unlock_tip"),
					items = arg0_44.appreciateProxy:getMusicUnlockMaterialByID(var8_44),
					onYes = function()
						pg.m02:sendNotification(GAME.APPRECIATE_MUSIC_UNLOCK, {
							musicID = var8_44,
							unlockCBFunc = function()
								arg0_44.lScrollPageSC:MoveToItemID(arg2_44 - 1)

								if arg0_44.plateTFList[arg2_44] then
									arg0_44:updatePlateTF(arg0_44.plateTFList[arg2_44], arg2_44 - 1)
								end

								arg0_44:updateSongTF(arg1_44, arg2_44)
								arg0_44.appreciateUnlockMsgBox:hideCustomMsgBox()
							end
						})
					end
				})
			end

			arg0_44:closeSongListPanel()
		end
	end, SFX_PANEL)
end

function var0_0.updateSongTFLikeImg(arg0_49, arg1_49, arg2_49)
	local var0_49 = arg1_49
	local var1_49 = arg0_49:findTF("LikeToggle", var0_49)

	setActive(var1_49, true)
	triggerToggle(var1_49, arg2_49)
end

function var0_0.updateSortToggle(arg0_50)
	setActive(arg0_50.upImg1, arg0_50.sortValue == MusicCollectionConst.Sort_Order_Up)
	setActive(arg0_50.upImg2, arg0_50.sortValue == MusicCollectionConst.Sort_Order_Up)
	setActive(arg0_50.downImg1, arg0_50.sortValue == MusicCollectionConst.Sort_Order_Down)
	setActive(arg0_50.downImg2, arg0_50.sortValue == MusicCollectionConst.Sort_Order_Down)
end

function var0_0.updateLikeToggle(arg0_51)
	setActive(arg0_51.likeFilteOnImg, arg0_51.likeValue == MusicCollectionConst.Filte_Like_Value)
end

function var0_0.updatePlayPanel(arg0_52)
	if #arg0_52.musicForShowConfigList == 0 then
		setActive(arg0_52.playPanel, false)
		setActive(arg0_52.playingAni, false)
		setActive(arg0_52.staicImg, false)
		setActive(arg0_52.songNameText, false)
		setActive(arg0_52.emptyPanel, true)

		return
	else
		setActive(arg0_52.playPanel, true)
		setActive(arg0_52.playingAni, false)
		setActive(arg0_52.staicImg, true)
		setActive(arg0_52.songNameText, true)
		setActive(arg0_52.emptyPanel, false)
	end

	local var0_52 = arg0_52:getMusicConfigForShowByIndex(arg0_52.curMidddleIndex)
	local var1_52 = var0_52.cover
	local var2_52 = MusicCollectionConst.MUSIC_COVER_PATH_PREFIX .. var1_52

	arg0_52.resLoader:LoadSprite(var2_52, var1_52, arg0_52.songImg, false)

	local var3_52 = var0_52.name

	setScrollText(arg0_52.songNameText, var3_52)
	setText(arg0_52.playPanelNameText, var3_52)
	setActive(arg0_52.likeOnImg, arg0_52.appreciateProxy:isLikedByMusicID(var0_52.id))

	local var4_52
	local var5_52 = arg0_52:getMusicStateByID(var0_52.id)

	if var5_52 == GalleryConst.CardStates.Unlockable or var5_52 == GalleryConst.CardStates.DisUnlockable then
		setActive(arg0_52.likeToggle, false)
	else
		setActive(arg0_52.likeToggle, true)
	end

	if not arg0_52:isCanPlayByMusicID(var0_52.id) then
		setActive(arg0_52.playBtn, false)
		setActive(arg0_52.pauseBtn, false)
		setActive(arg0_52.lockImg, true)

		arg0_52.playSliderSC.enabled = false

		arg0_52.playSliderSC:SetValueWithoutEvent(0)
		setActive(arg0_52.nowTimeText, false)
		setActive(arg0_52.totalTimeText, false)
	else
		setActive(arg0_52.playBtn, true)
		setActive(arg0_52.pauseBtn, false)
		setActive(arg0_52.lockImg, false)

		arg0_52.playSliderSC.enabled = true

		arg0_52.playSliderSC:SetValueWithoutEvent(0)
		setActive(arg0_52.nowTimeText, true)
		setActive(arg0_52.totalTimeText, true)
	end
end

function var0_0.sortAndUpdate(arg0_53, arg1_53)
	arg0_53.curMidddleIndex = 1

	arg0_53:saveRunData()

	arg0_53.musicForShowConfigList = arg0_53:fliteMusicConfigForShow()

	arg0_53:sortMusicConfigList(arg1_53)

	arg0_53.musicForShowConfigList = arg0_53:filteMusicConfigByLike()

	arg0_53:stopMusic()
	arg0_53:checkUpdateSongTF()
	arg0_53:updatePlateListPanel()
	arg0_53:updateSongListPanel()
	arg0_53:updatePlayPanel()
	arg0_53:updateSortToggle()
	arg0_53:updateLikeToggle()
	arg0_53:tryPlayMusic()
end

function var0_0.initTimer(arg0_54)
	arg0_54.playProgressTimer = Timer.New(function()
		if arg0_54.playbackInfo then
			local var0_55 = arg0_54.playbackInfo:GetTime()

			arg0_54.playSliderSC:SetValueWithoutEvent(var0_55)
			setText(arg0_54.nowTimeText, arg0_54:descTime(var0_55))

			if arg0_54.playbackInfo.playback:GetStatus():ToInt() == 3 then
				arg0_54:stopMusic()
				arg0_54:checkUpdateSongTF()
				SetActive(arg0_54.pauseBtn, false)
				SetActive(arg0_54.playBtn, true)
				arg0_54:tryPlayMusic()
			end
		end
	end, 0.033, -1)

	arg0_54.playProgressTimer:Start()
end

function var0_0.playPlateAni(arg0_56, arg1_56, arg2_56, arg3_56, arg4_56)
	local var0_56 = arg0_56:findTF("CirclePanel", arg1_56)
	local var1_56 = arg0_56:findTF("BoxImg", arg1_56)

	setActive(var0_56, arg2_56)
	setActive(var1_56, arg2_56)

	local var2_56 = 0.5

	if arg2_56 == true then
		local var3_56 = 198
		local var4_56 = 443
		local var5_56 = (var4_56 - var3_56) / var2_56
		local var6_56 = 0
		local var7_56 = -121
		local var8_56 = (var7_56 - var6_56) / var2_56

		LeanTween.value(go(arg1_56), 0, var2_56, var2_56):setOnUpdate(System.Action_float(function(arg0_57)
			local var0_57 = var3_56 + var5_56 * arg0_57
			local var1_57 = var6_56 + var8_56 * arg0_57

			setAnchoredPosition(var0_56, Vector2.New(var0_57, 0))
			setAnchoredPosition(arg1_56, Vector2.New(var1_57, 0))
		end)):setOnComplete(System.Action(function()
			setAnchoredPosition(var0_56, Vector2.New(var4_56, 0))
			setAnchoredPosition(arg1_56, Vector2.New(var7_56, 0))
			arg0_56:setAniState(false)
		end))
	else
		local var9_56 = 448
		local var10_56 = 198
		local var11_56 = (var10_56 - var9_56) / var2_56
		local var12_56 = getAnchoredPosition(arg1_56).x
		local var13_56 = (arg3_56 - arg4_56) * (arg0_56.lScrollPageSC.ItemSize.x + arg0_56.lScrollPageSC.MarginSize.x)
		local var14_56 = (var13_56 - var12_56) / var2_56

		setAnchoredPosition(var0_56, Vector2.New(var10_56, 0))
		setAnchoredPosition(arg1_56, Vector2.New(var13_56, 0))
	end
end

function var0_0.closePlateAni(arg0_59, arg1_59)
	local var0_59 = arg0_59:findTF("CirclePanel", arg1_59)
	local var1_59 = arg0_59:findTF("BoxImg", arg1_59)

	setActive(var0_59, false)
	setActive(var1_59, false)
	setAnchoredPosition(var0_59, Vector2.New(198, 0))
	setAnchoredPosition(arg1_59, Vector2.zero)
end

function var0_0.setAniState(arg0_60, arg1_60)
	arg0_60.isPlayingAni = arg1_60
end

function var0_0.openSongListPanel(arg0_61)
	pg.UIMgr.GetInstance():BlurPanel(arg0_61.songListPanel, false, {
		groupName = LayerWeightConst.GROUP_COLLECTION
	})

	arg0_61.songListPanel.offsetMax = arg0_61._tf.parent.offsetMax
	arg0_61.songListPanel.offsetMin = arg0_61._tf.parent.offsetMin

	setActive(arg0_61.songListPanel, true)
	LeanTween.value(go(arg0_61.panel), -460, 500, 0.3):setOnUpdate(System.Action_float(function(arg0_62)
		setAnchoredPosition(arg0_61.panel, {
			y = arg0_62
		})
	end)):setOnComplete(System.Action(function()
		setAnchoredPosition(arg0_61.panel, {
			y = 500
		})
	end))
end

function var0_0.closeSongListPanel(arg0_64, arg1_64)
	if arg1_64 == true then
		pg.UIMgr.GetInstance():UnblurPanel(arg0_64.songListPanel, arg0_64._tf)
		setActive(arg0_64.songListPanel, false)
	end

	if isActive(arg0_64.songListPanel) then
		LeanTween.cancel(go(arg0_64.panel))

		local var0_64 = getAnchoredPosition(arg0_64.panel).y

		LeanTween.value(go(arg0_64.panel), var0_64, -460, 0.3):setOnUpdate(System.Action_float(function(arg0_65)
			setAnchoredPosition(arg0_64.panel, {
				y = arg0_65
			})
		end)):setOnComplete(System.Action(function()
			setAnchoredPosition(arg0_64.panel, {
				y = -460
			})
			pg.UIMgr.GetInstance():UnblurPanel(arg0_64.songListPanel, arg0_64._tf)
			setActive(arg0_64.songListPanel, false)
		end))
	end
end

function var0_0.playMusic(arg0_67)
	local var0_67 = arg0_67:getMusicConfigForShowByIndex(arg0_67.curMidddleIndex).music

	if not arg0_67.cueData then
		arg0_67.cueData = CueData.GetCueData()
	end

	arg0_67.cueData.channelName = pg.CriMgr.C_GALLERY_MUSIC
	arg0_67.cueData.cueSheetName = var0_67
	arg0_67.cueData.cueName = ""

	CriWareMgr.Inst:PlaySound(arg0_67.cueData, CriWareMgr.CRI_FADE_TYPE.FADE_INOUT, function(arg0_68)
		arg0_67.playbackInfo = arg0_68

		arg0_67.playbackInfo:SetIgnoreAutoUnload(true)

		local var0_68 = arg0_67.playbackInfo:GetLength()

		setSlider(arg0_67.playProgressBar, 0, arg0_67.playbackInfo:GetLength(), 0)
		setText(arg0_67.totalTimeText, arg0_67:descTime(var0_68))

		arg0_67.isPlayingSong = true

		setActive(arg0_67.playingAni, true)
		setActive(arg0_67.staicImg, false)
		arg0_67:updateSongTF(arg0_67.songTFList[arg0_67.curMidddleIndex], arg0_67.curMidddleIndex)
	end)
end

function var0_0.stopMusic(arg0_69)
	if arg0_69.playbackInfo then
		arg0_69.playbackInfo:SetStartTime(0)
		CriWareMgr.Inst:StopSound(arg0_69.cueData, CriWareMgr.CRI_FADE_TYPE.NONE)

		arg0_69.playbackInfo = nil
		arg0_69.isPlayingSong = false
	end

	setActive(arg0_69.playingAni, false)
	setActive(arg0_69.staicImg, true)
	arg0_69.playSliderSC:SetValueWithoutEvent(0)
	setText(arg0_69.nowTimeText, arg0_69:descTime(0))
end

function var0_0.checkUpdateSongTF(arg0_70)
	if #arg0_70.songTFList > 0 then
		arg0_70:updateSongTF(arg0_70.songTFList[arg0_70.curMidddleIndex], arg0_70.curMidddleIndex)
	end
end

function var0_0.tryPlayMusic(arg0_71)
	if #arg0_71.musicForShowConfigList == 0 then
		return
	end

	local var0_71 = arg0_71:getMusicConfigForShowByIndex(arg0_71.curMidddleIndex)

	if arg0_71:isCanPlayByMusicID(var0_71.id) and isActive(arg0_71.playBtn) then
		triggerButton(arg0_71.playBtn)
	end
end

function var0_0.tryPauseMusic(arg0_72)
	if isActive(arg0_72.pauseBtn) and arg0_72.playbackInfo then
		triggerButton(arg0_72.pauseBtn)
	end
end

function var0_0.fliteMusicConfigForShow(arg0_73)
	local var0_73 = {}

	for iter0_73, iter1_73 in ipairs(pg.music_collect_config.all) do
		local var1_73 = arg0_73.appreciateProxy:getSingleMusicConfigByID(iter1_73)

		if arg0_73.appreciateProxy:isMusicNeedUnlockByID(iter1_73) then
			if not arg0_73.appreciateProxy:isMusicUnlockedByID(iter1_73) then
				local var2_73, var3_73 = arg0_73.appreciateProxy:isMusicUnlockableByID(iter1_73)

				if var2_73 then
					var0_73[#var0_73 + 1] = var1_73
				elseif var3_73 then
					var0_73[#var0_73 + 1] = var1_73
				end
			else
				var0_73[#var0_73 + 1] = var1_73
			end
		else
			var0_73[#var0_73 + 1] = var1_73
		end
	end

	return var0_73
end

function var0_0.getMusicConfigForShowByIndex(arg0_74, arg1_74)
	local var0_74 = arg0_74.musicForShowConfigList[arg1_74]

	if var0_74 then
		return var0_74
	else
		assert(false, "不存在的index" .. tostring(arg1_74))
	end
end

function var0_0.getMusicStateByID(arg0_75, arg1_75)
	if not arg0_75.appreciateProxy:isMusicNeedUnlockByID(arg1_75) then
		return MusicCollectionConst.MusicStates.Unlocked
	elseif arg0_75.appreciateProxy:isMusicUnlockedByID(arg1_75) then
		return MusicCollectionConst.MusicStates.Unlocked
	elseif arg0_75.appreciateProxy:isMusicUnlockableByID(arg1_75) then
		return MusicCollectionConst.MusicStates.Unlockable
	else
		return MusicCollectionConst.MusicStates.DisUnlockable
	end
end

function var0_0.sortMusicConfigList(arg0_76, arg1_76)
	local function var0_76(arg0_77, arg1_77)
		local var0_77 = arg0_77.id
		local var1_77 = arg1_77.id

		if arg1_76 == true then
			return var1_77 < var0_77
		else
			return var0_77 < var1_77
		end
	end

	table.sort(arg0_76.musicForShowConfigList, var0_76)
end

function var0_0.filteMusicConfigByLike(arg0_78)
	if arg0_78.likeValue == MusicCollectionConst.Filte_Normal_Value then
		return arg0_78.musicForShowConfigList
	end

	local var0_78 = {}

	for iter0_78, iter1_78 in ipairs(arg0_78.musicForShowConfigList) do
		local var1_78 = iter1_78.id

		if arg0_78.appreciateProxy:isLikedByMusicID(var1_78) then
			var0_78[#var0_78 + 1] = iter1_78
		end
	end

	return var0_78
end

function var0_0.isCanPlayByMusicID(arg0_79, arg1_79)
	local var0_79
	local var1_79
	local var2_79 = arg0_79.appreciateProxy:getMusicExistStateByID(arg1_79)
	local var3_79 = arg0_79:getMusicStateByID(arg1_79)

	if var3_79 == GalleryConst.CardStates.DirectShow then
		print("is impossible to go to this, something wrong")

		if var2_79 then
			return true
		else
			return false
		end
	elseif var3_79 == GalleryConst.CardStates.Unlocked then
		if var2_79 then
			return true
		else
			return false
		end
	elseif var3_79 == GalleryConst.CardStates.Unlockable then
		return false
	elseif var3_79 == GalleryConst.CardStates.DisUnlockable then
		return false
	end
end

function var0_0.descTime(arg0_80, arg1_80)
	local var0_80 = math.floor(arg1_80 / 1000)
	local var1_80 = math.floor(var0_80 / 3600)
	local var2_80 = var0_80 - var1_80 * 3600
	local var3_80 = math.floor(var2_80 / 60)
	local var4_80 = var2_80 % 60

	if var1_80 ~= 0 then
		return string.format("%02d:%02d:%02d", var1_80, var3_80, var4_80)
	else
		return string.format("%02d:%02d", var3_80, var4_80)
	end
end

function var0_0.tryStartDownloadCheckTimer(arg0_81)
	if #arg0_81.downloadCheckIDList == 0 and arg0_81.downloadCheckTimer then
		arg0_81.downloadCheckTimer:Stop()

		arg0_81.downloadCheckTimer = nil

		return
	end

	if not arg0_81.downloadCheckTimer and #arg0_81.downloadCheckIDList > 0 then
		local function var0_81()
			for iter0_82, iter1_82 in ipairs(arg0_81.downloadCheckIDList) do
				local var0_82

				for iter2_82, iter3_82 in ipairs(arg0_81.musicForShowConfigList) do
					if iter3_82.id == iter1_82 then
						var0_82 = iter2_82

						break
					end
				end

				if var0_82 then
					local var1_82 = arg0_81.plateTFList[var0_82]

					arg0_81:updatePlateTF(var1_82, var0_82 - 1)

					local var2_82 = arg0_81.songTFList[var0_82]

					arg0_81:updateSongTF(var2_82, var0_82)
				end
			end
		end

		arg0_81.downloadCheckTimer = Timer.New(var0_81, 1, -1)

		arg0_81.downloadCheckTimer:Start()
	end
end

return var0_0
