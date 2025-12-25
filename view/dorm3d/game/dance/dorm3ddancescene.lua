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

function var0_0.init(arg0_7)
	arg0_7:InitScene()
	arg0_7:InitUI()

	arg0_7.gameState = Dorm3dDanceConst.GAME_STATE.NONE
	arg0_7.criatomPlayer = CriWareMgr.Inst:GetChannelData("C_TIMELINE").channelPlayer.player

	local var0_7 = GameObject.Find("OverlayCamera").transform

	arg0_7.overlayCamera = var0_7:GetComponent(typeof(Camera))
	arg0_7.canvas = var0_7:GetChild(0)

	pg.BgmMgr.GetInstance():StopPlay()

	local var1_7 = Dorm3dHxHelper.GetTimelineMainCharacter()

	Dorm3dHxHelper.ReplaceCharacterParts(var1_7)
	Dorm3dHxHelper.ShowHolyLight({
		var1_7
	}, arg0_7.holyLightRoot)
end

function var0_0.InitUI(arg0_8)
	arg0_8.basePanel = arg0_8._tf:Find("Base")

	onButton(arg0_8, arg0_8._tf:Find("Base/BackBtn"), function()
		arg0_8:emit(BaseUI.ON_BACK)
	end, SFX_DORM_BACK)

	arg0_8.prepareView = Dorm3dDancePrepareSubView.New(arg0_8._tf:Find("Prepare"), arg0_8.event, setmetatable({}, {
		__index = arg0_8.contextData
	}))
	arg0_8.gameView = Dorm3dDanceGameSubView.New(arg0_8._tf:Find("Game"), arg0_8.event, setmetatable({
		onSwitchCamera = function(arg0_10)
			arg0_8:SwtichCamera(arg0_10)
		end,
		onTakePhoto = function()
			arg0_8:TakePhoto()
		end,
		onEndGame = function()
			arg0_8:EndGame()
		end,
		onShowOrHideBaseUI = function(arg0_13)
			setActive(arg0_8.basePanel, arg0_13)
		end,
		onShowRealImage = function(arg0_14, arg1_14, arg2_14)
			arg0_8:ShowRealImage(arg0_14, arg1_14, arg2_14)
		end,
		onShowPhotoWindow = function(arg0_15)
			arg0_8:GamePause()
			arg0_8.photoWindow:Show()
			arg0_8.photoWindow:Flush(arg0_15)
		end
	}, {
		__index = arg0_8.contextData
	}))
	arg0_8.resultView = Dorm3dDanceResultSubView.New(arg0_8._tf:Find("Result"), arg0_8.event, setmetatable({
		onAgain = function()
			arg0_8:InitData()
			arg0_8:PrepareGame()
		end,
		onExit = function()
			arg0_8:emit(BaseUI.ON_BACK)
		end,
		onShowRealImage = function(arg0_18, arg1_18, arg2_18)
			arg0_8:ShowRealImage(arg0_18, arg1_18, arg2_18)
		end
	}, {
		__index = arg0_8.contextData
	}))
	arg0_8.viewDic = {
		[Dorm3dDanceConst.VIEW_ENUM.PREPARE] = arg0_8.prepareView,
		[Dorm3dDanceConst.VIEW_ENUM.GAME] = arg0_8.gameView,
		[Dorm3dDanceConst.VIEW_ENUM.RESULT] = arg0_8.resultView
	}
	arg0_8.photoWindow = Dorm3dDancePhotoWindow.New(arg0_8._tf:Find("Photo"), arg0_8.event, setmetatable({
		onHide = function()
			arg0_8:ShowOrHideUI(true)
			arg0_8:GameResume()
		end,
		onShowRealImage = function(arg0_20, arg1_20, arg2_20)
			arg0_8:ShowRealImage(arg0_20, arg1_20, arg2_20)
		end,
		onSaveImage = function(arg0_21)
			arg0_8:SaveImage(arg0_21)
		end
	}, {
		__index = arg0_8.contextData
	}))
	arg0_8.holyLightRoot = arg0_8._tf:Find("HolyLightRoot")
end

function var0_0.InitScene(arg0_22)
	local var0_22 = SceneManager.GetSceneByName(arg0_22.sceneName):GetRootGameObjects()

	table.IpairsCArray(var0_22, function(arg0_23, arg1_23)
		if arg1_23.name == "MainCamera" then
			arg0_22.mainCamera = arg1_23.transform
		end
	end)

	local var1_22 = SceneManager.GetSceneByName(arg0_22.timelineSceneName):GetRootGameObjects()

	table.IpairsCArray(var1_22, function(arg0_24, arg1_24)
		if arg1_24.name == arg0_22.gameConfig.director_name then
			arg0_22.timelinePlayer = TimelinePlayer.New(arg1_24)
		elseif arg1_24.name == "all_con" then
			arg0_22.timelineCamera = arg1_24.transform:GetComponentInChildren(typeof(Camera))

			setActive(arg0_22.timelineCamera, false)
		end
	end)

	arg0_22.cmTracksDic = {}

	table.IpairsCArray(TimelineHelper.GetTimelineTracks(arg0_22.timelinePlayer.comDirector), function(arg0_25, arg1_25)
		if _.detect(arg0_22.gameConfig.camera_tracks, function(arg0_26)
			return arg0_26 == arg1_25.name
		end) then
			arg0_22.cmTracksDic[arg1_25.name] = arg1_25
		end
	end)
	arg0_22.timelinePlayer:Register(nil, function(arg0_27, arg1_27, arg2_27)
		switch(arg1_27.stringParameter, {
			StartGame = function()
				if arg0_22.gameState == Dorm3dDanceConst.GAME_STATE.GAME then
					return
				end

				arg0_22:StartGame()
			end,
			TimelinePlayOnTime = function()
				arg0_27:RawSetTime(arg1_27.floatParameter)
			end
		})
	end)
end

function var0_0.didEnter(arg0_30)
	arg0_30:PrepareGame()
end

function var0_0.EnterView(arg0_31, arg1_31)
	for iter0_31, iter1_31 in pairs(arg0_31.viewDic) do
		if iter0_31 == arg1_31 then
			iter1_31:Show()
			iter1_31:Flush()

			arg0_31.currentView = iter1_31
		else
			iter1_31:Hide()
		end
	end
end

function var0_0.InitData(arg0_32)
	arg0_32.contextData.cucoloris = {}

	for iter0_32 = 1, Dorm3dDanceConst.CUCOLORIS_COUNT do
		local var0_32 = math.random(1, #arg0_32.gameConfig.cucoloris_group[iter0_32])

		table.insert(arg0_32.contextData.cucoloris, Dorm3dDanceCucoloris.New({
			configId = arg0_32.gameConfig.cucoloris_group[iter0_32][var0_32]
		}))
	end

	if IsUnityEditor then
		warning("随机的剪影信息为：")

		for iter1_32 = 1, Dorm3dDanceConst.CUCOLORIS_COUNT do
			warning("ID" .. arg0_32.contextData.cucoloris[iter1_32].configId, "时间" .. arg0_32.contextData.cucoloris[iter1_32]:GetTime(), "相机" .. arg0_32.contextData.cucoloris[iter1_32]:GetCamera())
		end
	end

	arg0_32.contextData.photoData = {}
	arg0_32.contextData.curCamera = arg0_32.gameConfig.default_camera
end

function var0_0.PrepareGame(arg0_33)
	arg0_33.gameState = Dorm3dDanceConst.GAME_STATE.PREPARE

	arg0_33:InitData()
	arg0_33:EnterView(Dorm3dDanceConst.VIEW_ENUM.PREPARE)
	setActive(arg0_33.mainCamera, false)
	setActive(arg0_33.timelineCamera, true)
	arg0_33:SwtichCamera(arg0_33.gameConfig.default_camera)
	arg0_33.timelinePlayer:Play()
end

function var0_0.StartGame(arg0_34)
	arg0_34.gameView:ClearPhoto()

	arg0_34.gameState = Dorm3dDanceConst.GAME_STATE.GAME

	arg0_34:EnterView(Dorm3dDanceConst.VIEW_ENUM.GAME)
end

function var0_0.EndGame(arg0_35)
	arg0_35:CalcScore()
	setActive(arg0_35.mainCamera, true)
	setActive(arg0_35.timelineCamera, false)
	arg0_35.timelinePlayer:Stop()

	arg0_35.gameState = Dorm3dDanceConst.GAME_STATE.RESULT

	arg0_35:EnterView(Dorm3dDanceConst.VIEW_ENUM.RESULT)
end

function var0_0.CalcScore(arg0_36)
	arg0_36.contextData.match = {}

	if IsUnityEditor then
		warning("照片信息为：")

		for iter0_36 = 1, Dorm3dDanceConst.PHOTO_TIMES do
			local var0_36 = arg0_36.contextData.photoData[iter0_36]

			warning("ID " .. iter0_36 .. " 时间 " .. var0_36.time .. " 相机 " .. var0_36.camera)
		end
	end

	if IsUnityEditor then
		warning("二分图信息为")
	end

	local var1_36 = {}

	for iter1_36 = 1, Dorm3dDanceConst.CUCOLORIS_COUNT do
		local var2_36 = arg0_36.contextData.cucoloris[iter1_36]

		for iter2_36 = 1, Dorm3dDanceConst.PHOTO_TIMES do
			local var3_36 = arg0_36.contextData.photoData[iter2_36]
			local var4_36, var5_36, var6_36 = var2_36:CalcScore(var3_36)

			table.insert(var1_36, {
				iter1_36,
				iter2_36,
				var4_36 + 1000 - var6_36
			})

			if IsUnityEditor then
				warning("剪影ID " .. iter1_36 .. " 照片ID " .. iter2_36 .. " 分数 " .. var4_36 .. " 时间差 " .. var6_36)
			end
		end
	end

	local var7_36 = 0
	local var8_36, var9_36 = AlgorithmHelper.KM(Dorm3dDanceConst.PHOTO_TIMES, var1_36)

	for iter3_36 = 1, Dorm3dDanceConst.CUCOLORIS_COUNT do
		arg0_36.contextData.match[iter3_36] = var9_36[iter3_36]

		local var10_36, var11_36, var12_36 = arg0_36.contextData.cucoloris[iter3_36]:CalcScore(arg0_36.contextData.photoData[var9_36[iter3_36]])

		var7_36 = var7_36 + var10_36

		if IsUnityEditor then
			warning("剪影ID " .. iter3_36 .. " 匹配照片ID " .. var9_36[iter3_36])
		end
	end

	pg.m02:sendNotification(GAME.APARTMENT_TRACK, Dorm3dTrackCommand.BuildDataDance(arg0_36.contextData.groupId, var7_36))
end

function var0_0.TakePhoto(arg0_37)
	arg0_37:GamePause()
	arg0_37:ShowOrHideUI(false)

	local function var0_37(arg0_38)
		table.insert(arg0_37.contextData.photoData, {
			camera = arg0_37.contextData.curCamera,
			time = arg0_37.timelinePlayer:GetTime(),
			texture = arg0_38
		})
		arg0_37.photoWindow:Show()
		arg0_37.photoWindow:Flush(#arg0_37.contextData.photoData, true)
		arg0_37.gameView:Flush()
	end

	local var1_37, var2_37 = Dorm3dHxHelper.GetHolyLightScreenShotInfo(arg0_37.holyLightRoot)

	GraphicsInterface.Instance:TakePhotoWithPost(arg0_37.timelineCamera, var1_37, var2_37, var0_37)
end

function var0_0.GamePause(arg0_39)
	arg0_39.timelinePlayer:SetSpeed(0)
	arg0_39.criatomPlayer:SetVolume(0)
	arg0_39.criatomPlayer:UpdateAll()
end

function var0_0.GameResume(arg0_40)
	arg0_40.timelinePlayer:SetSpeed(1)
	arg0_40.criatomPlayer:SetVolume(1)
	arg0_40.criatomPlayer:UpdateAll()
end

function var0_0.ShowOrHideUI(arg0_41, arg1_41)
	if arg1_41 then
		arg0_41.currentView:Show()
	else
		arg0_41.currentView:Hide()
	end

	setActive(arg0_41.basePanel, arg1_41)
end

function var0_0.SwtichCamera(arg0_42, arg1_42)
	arg0_42.cmTracksDic[arg0_42.contextData.curCamera].muted = true
	arg0_42.cmTracksDic[arg1_42].muted = false

	arg0_42.timelinePlayer:SetTime(arg0_42.timelinePlayer:GetTime())

	arg0_42.contextData.curCamera = arg1_42
end

function var0_0.ShowRealImage(arg0_43, arg1_43, arg2_43, arg3_43)
	local var0_43 = arg0_43.contextData.photoData[arg1_43].texture

	arg2_43:GetComponent(typeof(RawImage)).texture = var0_43
	arg2_43.sizeDelta = arg0_43.canvas.sizeDelta

	local var1_43 = math.max(arg3_43.sizeDelta.x / arg0_43.canvas.sizeDelta.x, arg3_43.sizeDelta.y / arg0_43.canvas.sizeDelta.y)

	arg2_43.localScale = Vector3(var1_43, var1_43, 1)
end

function var0_0.SaveImage(arg0_44, arg1_44)
	local function var0_44(arg0_45)
		local var0_45 = arg1_44.sizeDelta.x / arg0_44.canvas.sizeDelta.x * Screen.width
		local var1_45 = arg1_44.sizeDelta.y / arg0_44.canvas.sizeDelta.y * Screen.height
		local var2_45 = UnityEngine.Texture2D.New(var0_45, var1_45)
		local var3_45 = (Screen.width - var0_45) / 2
		local var4_45 = (Screen.height - var1_45) / 2
		local var5_45 = arg0_45:GetPixels(var3_45, var4_45, var0_45, var1_45)

		var2_45:SetPixels(var5_45)
		var2_45:Apply()

		local var6_45 = Tex2DExtension.EncodeToJPG(var2_45)

		YSNormalTool.MediaTool.SaveImageWithBytes(var6_45, function(arg0_46, arg1_46)
			if arg0_46 then
				pg.TipsMgr.GetInstance():ShowTips(i18n("word_save_ok"))
			end
		end)
	end

	BLHX.Rendering.HotUpdate.ScreenShooterPass.TakePhoto(arg0_44.overlayCamera, var0_44)
end

function var0_0.willExit(arg0_47)
	for iter0_47, iter1_47 in pairs(arg0_47.viewDic) do
		iter1_47:Dispose()
	end

	arg0_47.photoWindow:Dispose()
	pg.BgmMgr.GetInstance():ContinuePlay()

	local var0_47 = underscore.map(arg0_47.sceneInfo, function(arg0_48)
		return function(arg0_49)
			SceneOpMgr.Inst:UnloadSceneAsync(arg0_48.path, arg0_48.name, arg0_49)
		end
	end)

	seriesAsync(var0_47, function()
		return
	end)
end

return var0_0
