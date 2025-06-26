local var0_0 = class("MainMusicPlayerView", import("view.base.BaseSubView"))

function var0_0.getUIName(arg0_1)
	return "MusicPlayer"
end

function var0_0.OnLoaded(arg0_2)
	arg0_2.rtPanel = arg0_2._tf:Find("panel")
	arg0_2.rtContainer = arg0_2.rtPanel:Find("view/container")
	arg0_2.playLoopBtn = arg0_2.rtContainer:Find("PlayTypeBtn")
	arg0_2.likeToggle = arg0_2.rtContainer:Find("LikeBtn")
	arg0_2.preBtn = arg0_2.rtContainer:Find("PreBtn")
	arg0_2.nextBtn = arg0_2.rtContainer:Find("NextBtn")
	arg0_2.btnExtend = arg0_2.rtPanel:Find("extend")
	arg0_2.btnIcon = arg0_2.rtContainer:Find("icon")
end

function var0_0.OnInit(arg0_3)
	arg0_3.bgmMgr = pg.BgmMgr.GetInstance()

	onButton(arg0_3, arg0_3.btnExtend, function()
		arg0_3.isOpen = not arg0_3.isOpen

		setActive(arg0_3.btnExtend:Find("on"), not arg0_3.isOpen)
		setActive(arg0_3.btnExtend:Find("off"), arg0_3.isOpen)
		LeanTween.size(arg0_3.rtPanel, Vector2(arg0_3.isOpen and 460 or 130, arg0_3.rtPanel.sizeDelta.y), 0.3)
	end, SFX_PANEL)
	onButton(arg0_3, arg0_3.preBtn, function()
		if not arg0_3.musicPlayer then
			return
		end

		arg0_3.musicPlayer:Last()
	end, SFX_PANEL)
	onButton(arg0_3, arg0_3.nextBtn, function()
		if not arg0_3.musicPlayer then
			return
		end

		arg0_3.musicPlayer:Next()
	end, SFX_PANEL)
	onButton(arg0_3, arg0_3.playLoopBtn, function()
		local var0_7 = getProxy(AppreciateProxy):getMusicPlayerLoopType()

		switch(var0_7, {
			list = function()
				var0_7 = "random"
			end,
			random = function()
				var0_7 = "one"
			end,
			one = function()
				var0_7 = "list"
			end
		})
		pg.m02:sendNotification(GAME.APPRECIATE_CHANGE_MUSIC_PLAY_LOOP_TYPE, {
			loopType = var0_7
		})
		arg0_3:updatePlayType(var0_7)

		if arg0_3.musicPlayer then
			arg0_3.musicPlayer:ChangeData({
				loopType = var0_7
			})
		end
	end, SFX_PANEL)
	onButton(arg0_3, arg0_3.likeToggle, function()
		local var0_11 = arg0_3.musicPlayer:GetCurrentMusicId()
		local var1_11 = pg.music_collect_config[var0_11].id

		pg.m02:sendNotification(GAME.APPRECIATE_MUSIC_LIKE, {
			musicID = var1_11,
			isAdd = arg0_3.isLike and 1 or 0
		})

		arg0_3.isLike = not arg0_3.isLike

		setActive(arg0_3.likeToggle:Find("On"), arg0_3.isLike)
	end, SFX_PANEL)
	onButton(arg0_3, arg0_3.btnIcon, function()
		if not arg0_3.isOpen then
			return
		end

		pg.m02:sendNotification(GAME.GO_SCENE, SCENE.COLLECTSHIP, {
			toggle = CollectionScene.MUSIC_INDEX
		})
	end, SFX_PANEL)
end

function var0_0.Show(arg0_13, arg1_13)
	setActive(arg0_13.btnExtend, arg1_13)

	if arg1_13 then
		arg0_13.isOpen = false
	else
		arg0_13.isOpen = true
	end

	setActive(arg0_13.btnExtend:Find("on"), not arg0_13.isOpen)
	setActive(arg0_13.btnExtend:Find("off"), arg0_13.isOpen)
	assert(arg0_13.bgmMgr:GetNow() == "MainMusicPlayer")

	arg0_13.musicPlayer = arg0_13.bgmMgr:GetMusicPlayer()
	arg0_13.isLike = getProxy(AppreciateProxy):isLikedByMusicID(arg0_13.musicPlayer:GetCurrentMusicId())

	arg0_13:UpdatePlayerDisplay()
	arg0_13:updatePlayType()
	arg0_13.bgmMgr:RegisterMusicCallback(arg0_13.__cname, "MainMusicPlayer", {
		startCall = function(arg0_14)
			arg0_13.isLike = getProxy(AppreciateProxy):isLikedByMusicID(arg0_13.musicPlayer:GetCurrentMusicId())

			arg0_13:UpdatePlayerDisplay()
		end
	})
	var0_0.super.Show(arg0_13)
end

function var0_0.UpdatePlayerDisplay(arg0_15)
	local var0_15 = arg0_15.musicPlayer:GetCurrentMusicId()
	local var1_15 = pg.music_collect_config[var0_15].album_id
	local var2_15 = pg.music_album[var1_15].cover
	local var3_15 = MusicCollectionConst.MUSIC_COVER_PATH_PREFIX .. var2_15

	GetImageSpriteFromAtlasAsync(var3_15, "", arg0_15.rtContainer:Find("icon/face"), false)
	setActive(arg0_15.rtContainer:Find("LikeBtn/On"), arg0_15.isLike)
end

function var0_0.updatePlayType(arg0_16, arg1_16)
	arg1_16 = arg1_16 or getProxy(AppreciateProxy):getMusicPlayerLoopType()

	eachChild(arg0_16.playLoopBtn, function(arg0_17, arg1_17)
		setActive(arg0_17, arg0_17.name == arg1_16)
	end)
end

function var0_0.OnDestroy(arg0_18)
	arg0_18.bgmMgr:UnregisterMusicCallback(arg0_18.__cname)

	arg0_18.bgmMgr = nil
	arg0_18.musicPlayer = nil
end

return var0_0
