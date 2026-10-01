local var0_0 = class("Dorm3dDanceScene", import("view.dorm3d.Game.Dorm3dGameTemplate"))

function var0_0.getUIName(arg0_1)
	return "Dorm3dDanceUI"
end

function var0_0.preload(arg0_2, arg1_2)
	local var0_2 = arg0_2.contextData.groupId

	arg0_2.gameConfig = pg.dorm3d_dance[var0_2]

	arg0_2:SetApartment(getProxy(ApartmentProxy):getApartment(var0_2))

	arg0_2.sceneRootName = "publiccafe"
	arg0_2.sceneName = "map_publiccafe_01_blue"
	arg0_2.timelineSceneRootName = pg.dorm3d_dorm_template[var0_2].asset_name
	arg0_2.timelineSceneName = arg0_2.gameConfig.timeline_scene
	arg0_2.sceneInfo = {
		{
			path = string.lower("dorm3d/scenesres/scenes/" .. arg0_2.sceneRootName .. "/" .. arg0_2.sceneName .. "_scene"),
			name = arg0_2.sceneName
		},
		{
			path = string.lower("dorm3d/character/" .. arg0_2.timelineSceneRootName .. "/timeline/" .. arg0_2.timelineSceneName .. "/" .. arg0_2.timelineSceneName .. "_scene"),
			name = arg0_2.timelineSceneName
		}
	}

	seriesAsync({
		function(arg0_3)
			SceneOpMgr.Inst:LoadSceneAsync(arg0_2.sceneInfo[1].path, arg0_2.sceneInfo[1].name, LoadSceneMode.Additive, function(arg0_4, arg1_4)
				SceneManager.SetActiveScene(arg0_4)
				arg0_3()
			end)
		end,
		function(arg0_5)
			SceneOpMgr.Inst:LoadSceneAsync(arg0_2.sceneInfo[2].path, arg0_2.sceneInfo[2].name, LoadSceneMode.Additive, function(arg0_6, arg1_6)
				arg0_5()
			end)
		end
	}, arg1_2)
end

function var0_0.getResource(arg0_7)
	local var0_7 = var0_0.super.getResource(arg0_7)
	local var1_7 = arg0_7.contextData.groupId
	local var2_7 = pg.dorm3d_dance[var1_7]
	local var3_7 = pg.dorm3d_dorm_template[var1_7]
	local var4_7 = {
		string.lower("dorm3d/scenesres/scenes/publiccafe/map_publiccafe_01_blue_scene"),
		string.lower("dorm3d/character/" .. var3_7.asset_name .. "/timeline/" .. var2_7.timeline_scene .. "/" .. var2_7.timeline_scene .. "_scene")
	}

	for iter0_7, iter1_7 in ipairs(var4_7) do
		if not table.contains(var0_7, iter1_7) then
			table.insert(var0_7, iter1_7)
		end
	end

	return var0_7
end

function var0_0.init(arg0_8)
	arg0_8:InitScene()
	arg0_8:InitUI()

	arg0_8.gameState = Dorm3dDanceConst.GAME_STATE.NONE
	arg0_8.criatomPlayer = CriWareMgr.Inst:GetChannelData("C_TIMELINE").channelPlayer.player

	local var0_8 = GameObject.Find("OverlayCamera").transform

	arg0_8.overlayCamera = var0_8:GetComponent(typeof(Camera))
	arg0_8.canvas = var0_8:GetChild(0)

	pg.BgmMgr.GetInstance():StopPlay()

	local var1_8 = Dorm3dHxHelper.GetTimelineMainCharacter()

	Dorm3dHxHelper.ReplaceCharacterParts(var1_8)
	Dorm3dHxHelper.HideCharacterPart(var1_8, nil, true)
	Dorm3dHxHelper.ShowHolyLight({
		var1_8
	}, arg0_8.holyLightRoot)
end

function var0_0.InitUI(arg0_9)
	arg0_9.basePanel = arg0_9._tf:Find("Base")

	onButton(arg0_9, arg0_9._tf:Find("Base/BackBtn"), function()
		arg0_9:emit(BaseUI.ON_BACK)
	end, SFX_DORM_BACK)

	arg0_9.prepareView = Dorm3dDancePrepareSubView.New(arg0_9._tf:Find("Prepare"), arg0_9.event, setmetatable({}, {
		__index = arg0_9.contextData
	}))
	arg0_9.gameView = Dorm3dDanceGameSubView.New(arg0_9._tf:Find("Game"), arg0_9.event, setmetatable({
		onSwitchCamera = function(arg0_11)
			arg0_9:SwtichCamera(arg0_11)
		end,
		onTakePhoto = function()
			arg0_9:TakePhoto()
		end,
		onEndGame = function()
			arg0_9:EndGame()
		end,
		onShowOrHideBaseUI = function(arg0_14)
			setActive(arg0_9.basePanel, arg0_14)
		end,
		onShowRealImage = function(arg0_15, arg1_15, arg2_15)
			arg0_9:ShowRealImage(arg0_15, arg1_15, arg2_15)
		end,
		onShowPhotoWindow = function(arg0_16)
			arg0_9:GamePause()
			arg0_9.photoWindow:Show()
			arg0_9.photoWindow:Flush(arg0_16)
		end
	}, {
		__index = arg0_9.contextData
	}))
	arg0_9.resultView = Dorm3dDanceResultSubView.New(arg0_9._tf:Find("Result"), arg0_9.event, setmetatable({
		onAgain = function()
			arg0_9:InitData()
			arg0_9:PrepareGame()
		end,
		onExit = function()
			arg0_9:emit(BaseUI.ON_BACK)
		end,
		onShowRealImage = function(arg0_19, arg1_19, arg2_19)
			arg0_9:ShowRealImage(arg0_19, arg1_19, arg2_19)
		end
	}, {
		__index = arg0_9.contextData
	}))
	arg0_9.viewDic = {
		[Dorm3dDanceConst.VIEW_ENUM.PREPARE] = arg0_9.prepareView,
		[Dorm3dDanceConst.VIEW_ENUM.GAME] = arg0_9.gameView,
		[Dorm3dDanceConst.VIEW_ENUM.RESULT] = arg0_9.resultView
	}
	arg0_9.photoWindow = Dorm3dDancePhotoWindow.New(arg0_9._tf:Find("Photo"), arg0_9.event, setmetatable({
		onHide = function()
			arg0_9:ShowOrHideUI(true)
			arg0_9:GameResume()
		end,
		onShowRealImage = function(arg0_21, arg1_21, arg2_21)
			arg0_9:ShowRealImage(arg0_21, arg1_21, arg2_21)
		end,
		onSaveImage = function(arg0_22)
			arg0_9:SaveImage(arg0_22)
		end
	}, {
		__index = arg0_9.contextData
	}))
	arg0_9.holyLightRoot = arg0_9._tf:Find("HolyLightRoot")
end

function var0_0.InitScene(arg0_23)
	local var0_23 = SceneManager.GetSceneByName(arg0_23.sceneName):GetRootGameObjects()

	table.IpairsCArray(var0_23, function(arg0_24, arg1_24)
		if arg1_24.name == "MainCamera" then
			arg0_23.mainCamera = arg1_24.transform
		end
	end)

	local var1_23 = SceneManager.GetSceneByName(arg0_23.timelineSceneName):GetRootGameObjects()

	table.IpairsCArray(var1_23, function(arg0_25, arg1_25)
		if arg1_25.name == arg0_23.gameConfig.director_name then
			arg0_23.timelinePlayer = TimelinePlayer.New(arg1_25)
		elseif arg1_25.name == "all_con" then
			arg0_23.timelineCamera = arg1_25.transform:GetComponentInChildren(typeof(Camera))

			setActive(arg0_23.timelineCamera, false)
		end
	end)

	arg0_23.cmTracksDic = {}

	table.IpairsCArray(TimelineHelper.GetTimelineTracks(arg0_23.timelinePlayer.comDirector), function(arg0_26, arg1_26)
		if _.detect(arg0_23.gameConfig.camera_tracks, function(arg0_27)
			return arg0_27 == arg1_26.name
		end) then
			arg0_23.cmTracksDic[arg1_26.name] = arg1_26
		end
	end)
	arg0_23.timelinePlayer:Register(nil, function(arg0_28, arg1_28, arg2_28)
		switch(arg1_28.stringParameter, {
			StartGame = function()
				if arg0_23.gameState == Dorm3dDanceConst.GAME_STATE.GAME then
					return
				end

				arg0_23:StartGame()
			end,
			TimelinePlayOnTime = function()
				arg0_28:RawSetTime(arg1_28.floatParameter)
			end
		})
	end)
end

function var0_0.didEnter(arg0_31)
	arg0_31:PrepareGame()
end

function var0_0.EnterView(arg0_32, arg1_32)
	for iter0_32, iter1_32 in pairs(arg0_32.viewDic) do
		if iter0_32 == arg1_32 then
			iter1_32:Show()
			iter1_32:Flush()

			arg0_32.currentView = iter1_32
		else
			iter1_32:Hide()
		end
	end
end

function var0_0.InitData(arg0_33)
	arg0_33.contextData.cucoloris = {}

	for iter0_33 = 1, Dorm3dDanceConst.CUCOLORIS_COUNT do
		local var0_33 = math.random(1, #arg0_33.gameConfig.cucoloris_group[iter0_33])

		table.insert(arg0_33.contextData.cucoloris, Dorm3dDanceCucoloris.New({
			configId = arg0_33.gameConfig.cucoloris_group[iter0_33][var0_33]
		}))
	end

	if IsUnityEditor then
		warning("随机的剪影信息为：")

		for iter1_33 = 1, Dorm3dDanceConst.CUCOLORIS_COUNT do
			warning("ID" .. arg0_33.contextData.cucoloris[iter1_33].configId, "时间" .. arg0_33.contextData.cucoloris[iter1_33]:GetTime(), "相机" .. arg0_33.contextData.cucoloris[iter1_33]:GetCamera())
		end
	end

	arg0_33.contextData.photoData = {}
	arg0_33.contextData.curCamera = arg0_33.gameConfig.default_camera
end

function var0_0.PrepareGame(arg0_34)
	arg0_34.gameState = Dorm3dDanceConst.GAME_STATE.PREPARE

	arg0_34:InitData()
	arg0_34:EnterView(Dorm3dDanceConst.VIEW_ENUM.PREPARE)
	setActive(arg0_34.mainCamera, false)
	setActive(arg0_34.timelineCamera, true)
	arg0_34:SwtichCamera(arg0_34.gameConfig.default_camera)
	arg0_34.timelinePlayer:Play()
end

function var0_0.StartGame(arg0_35)
	arg0_35.gameView:ClearPhoto()

	arg0_35.gameState = Dorm3dDanceConst.GAME_STATE.GAME

	arg0_35:EnterView(Dorm3dDanceConst.VIEW_ENUM.GAME)
end

function var0_0.EndGame(arg0_36)
	arg0_36:CalcScore()
	setActive(arg0_36.mainCamera, true)
	setActive(arg0_36.timelineCamera, false)
	arg0_36.timelinePlayer:Stop()

	arg0_36.gameState = Dorm3dDanceConst.GAME_STATE.RESULT

	arg0_36:EnterView(Dorm3dDanceConst.VIEW_ENUM.RESULT)
end

function var0_0.CalcScore(arg0_37)
	arg0_37.contextData.match = {}

	if IsUnityEditor then
		warning("照片信息为：")

		for iter0_37 = 1, Dorm3dDanceConst.PHOTO_TIMES do
			local var0_37 = arg0_37.contextData.photoData[iter0_37]

			warning("ID " .. iter0_37 .. " 时间 " .. var0_37.time .. " 相机 " .. var0_37.camera)
		end
	end

	if IsUnityEditor then
		warning("二分图信息为")
	end

	local var1_37 = {}

	for iter1_37 = 1, Dorm3dDanceConst.CUCOLORIS_COUNT do
		local var2_37 = arg0_37.contextData.cucoloris[iter1_37]

		for iter2_37 = 1, Dorm3dDanceConst.PHOTO_TIMES do
			local var3_37 = arg0_37.contextData.photoData[iter2_37]
			local var4_37, var5_37, var6_37 = var2_37:CalcScore(var3_37)

			table.insert(var1_37, {
				iter1_37,
				iter2_37,
				var4_37 + 1000 - var6_37
			})

			if IsUnityEditor then
				warning("剪影ID " .. iter1_37 .. " 照片ID " .. iter2_37 .. " 分数 " .. var4_37 .. " 时间差 " .. var6_37)
			end
		end
	end

	local var7_37 = 0
	local var8_37, var9_37 = AlgorithmHelper.KM(Dorm3dDanceConst.PHOTO_TIMES, var1_37)

	for iter3_37 = 1, Dorm3dDanceConst.CUCOLORIS_COUNT do
		arg0_37.contextData.match[iter3_37] = var9_37[iter3_37]

		local var10_37, var11_37, var12_37 = arg0_37.contextData.cucoloris[iter3_37]:CalcScore(arg0_37.contextData.photoData[var9_37[iter3_37]])

		var7_37 = var7_37 + var10_37

		if IsUnityEditor then
			warning("剪影ID " .. iter3_37 .. " 匹配照片ID " .. var9_37[iter3_37])
		end
	end

	pg.m02:sendNotification(GAME.APARTMENT_TRACK, Dorm3dTrackCommand.BuildDataDance(arg0_37.contextData.groupId, var7_37))
end

function var0_0.TakePhoto(arg0_38)
	arg0_38:GamePause()
	arg0_38:ShowOrHideUI(false)

	local function var0_38(arg0_39)
		table.insert(arg0_38.contextData.photoData, {
			camera = arg0_38.contextData.curCamera,
			time = arg0_38.timelinePlayer:GetTime(),
			texture = arg0_39
		})
		arg0_38.photoWindow:Show()
		arg0_38.photoWindow:Flush(#arg0_38.contextData.photoData, true)
		arg0_38.gameView:Flush()
	end

	local var1_38, var2_38 = Dorm3dHxHelper.GetHolyLightScreenShotInfo(arg0_38.holyLightRoot)

	GraphicsInterface.Instance:TakePhotoWithPost(arg0_38.timelineCamera, var1_38, var2_38, var0_38)
end

function var0_0.GamePause(arg0_40)
	arg0_40.timelinePlayer:SetSpeed(0)
	arg0_40.criatomPlayer:SetVolume(0)
	arg0_40.criatomPlayer:UpdateAll()
end

function var0_0.GameResume(arg0_41)
	arg0_41.timelinePlayer:SetSpeed(1)
	arg0_41.criatomPlayer:SetVolume(1)
	arg0_41.criatomPlayer:UpdateAll()
end

function var0_0.ShowOrHideUI(arg0_42, arg1_42)
	if arg1_42 then
		arg0_42.currentView:Show()
	else
		arg0_42.currentView:Hide()
	end

	setActive(arg0_42.basePanel, arg1_42)
end

function var0_0.SwtichCamera(arg0_43, arg1_43)
	arg0_43.cmTracksDic[arg0_43.contextData.curCamera].muted = true
	arg0_43.cmTracksDic[arg1_43].muted = false

	arg0_43.timelinePlayer:SetTime(arg0_43.timelinePlayer:GetTime())

	arg0_43.contextData.curCamera = arg1_43
end

function var0_0.ShowRealImage(arg0_44, arg1_44, arg2_44, arg3_44)
	local var0_44 = arg0_44.contextData.photoData[arg1_44].texture

	arg2_44:GetComponent(typeof(RawImage)).texture = var0_44
	arg2_44.sizeDelta = arg0_44.canvas.sizeDelta

	local var1_44 = math.max(arg3_44.sizeDelta.x / arg0_44.canvas.sizeDelta.x, arg3_44.sizeDelta.y / arg0_44.canvas.sizeDelta.y)

	arg2_44.localScale = Vector3(var1_44, var1_44, 1)
end

function var0_0.SaveImage(arg0_45, arg1_45)
	local function var0_45(arg0_46)
		local var0_46 = arg1_45.sizeDelta.x / arg0_45.canvas.sizeDelta.x * Screen.width
		local var1_46 = arg1_45.sizeDelta.y / arg0_45.canvas.sizeDelta.y * Screen.height
		local var2_46 = UnityEngine.Texture2D.New(var0_46, var1_46)
		local var3_46 = (Screen.width - var0_46) / 2
		local var4_46 = (Screen.height - var1_46) / 2
		local var5_46 = arg0_46:GetPixels(var3_46, var4_46, var0_46, var1_46)

		var2_46:SetPixels(var5_46)
		var2_46:Apply()

		local var6_46 = Tex2DExtension.EncodeToJPG(var2_46)

		YSNormalTool.MediaTool.SaveImageWithBytes(var6_46, function(arg0_47, arg1_47)
			if arg0_47 then
				pg.TipsMgr.GetInstance():ShowTips(i18n("word_save_ok"))
			end
		end)
	end

	BLHX.Rendering.HotUpdate.ScreenShooterPass.TakePhoto(arg0_45.overlayCamera, var0_45)
end

function var0_0.willExit(arg0_48)
	for iter0_48, iter1_48 in pairs(arg0_48.viewDic) do
		iter1_48:Dispose()
	end

	arg0_48.photoWindow:Dispose()
	pg.BgmMgr.GetInstance():ContinuePlay()

	local var0_48 = underscore.map(arg0_48.sceneInfo, function(arg0_49)
		return function(arg0_50)
			SceneOpMgr.Inst:UnloadSceneAsync(arg0_49.path, arg0_49.name, arg0_50)
		end
	end)

	seriesAsync(var0_48, function()
		return
	end)
end

return var0_0
