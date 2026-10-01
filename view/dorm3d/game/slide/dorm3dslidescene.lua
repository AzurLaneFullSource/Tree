local var0_0 = class("Dorm3dSlideScene", import("view.dorm3d.Game.Dorm3dGameTemplate"))

function var0_0.getUIName(arg0_1)
	return "Dorm3dSlideUI"
end

function var0_0.preload(arg0_2, arg1_2)
	local var0_2 = arg0_2.contextData.groupId

	arg0_2.gameConfig = pg.dorm3d_minigame_slide[var0_2]

	arg0_2:SetApartment(getProxy(ApartmentProxy):getApartment(var0_2))

	arg0_2.sceneInfo = {
		{
			path = arg0_2.gameConfig.peform_scene_info[1],
			name = arg0_2.gameConfig.peform_scene_info[2]
		},
		{
			path = arg0_2.gameConfig.perform_timeline_info[1],
			name = arg0_2.gameConfig.perform_timeline_info[2]
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

	arg0_7.gameConfig = pg.dorm3d_minigame_slide[var1_7]

	local var2_7 = {
		arg0_7.gameConfig.peform_scene_info[1],
		arg0_7.gameConfig.peform_scene_info[2]
	}

	for iter0_7, iter1_7 in ipairs(var2_7) do
		if not table.contains(var0_7, iter1_7) then
			table.insert(var0_7, iter1_7)
		end
	end

	return var0_7
end

function var0_0.init(arg0_8)
	arg0_8:InitScene()
	arg0_8:InitUI()

	local var0_8 = Dorm3dHxHelper.GetTimelineMainCharacter()

	Dorm3dHxHelper.ReplaceCharacterParts(var0_8)
	Dorm3dHxHelper.HideCharacterPart(var0_8, nil, true)
	Dorm3dHxHelper.ShowHolyLight({
		var0_8
	}, arg0_8.holyLightRoot)
end

function var0_0.InitUI(arg0_9)
	onButton(arg0_9, arg0_9._tf:Find("GameUI/Title/BackBtn"), function()
		arg0_9:emit(var0_0.ON_BACK)
	end, SFX_DORM_CLICK)

	arg0_9.qteTF = arg0_9._tf:Find("GameUI/QTE")

	setActive(arg0_9.qteTF, false)

	arg0_9.countTF = arg0_9._tf:Find("GameUI/Count")

	setActive(arg0_9.countTF, false)
	arg0_9.countTF:GetComponent(typeof(DftAniEvent)):SetEndEvent(function()
		setActive(arg0_9.countTF, false)
	end)

	arg0_9.endUI = arg0_9._tf:Find("EndUI")

	setText(arg0_9._tf:Find("GameUI/Title/Text"), i18n("3ddorm_beach_slide_tip7"))

	arg0_9.ltList = {}
	arg0_9.timerList = {}
	arg0_9.holyLightRoot = arg0_9._tf:Find("HolyLightRoot")
end

function var0_0.InitScene(arg0_12)
	local var0_12 = SceneManager.GetSceneByName(arg0_12.sceneInfo[1].name):GetRootGameObjects()

	table.IpairsCArray(var0_12, function(arg0_13, arg1_13)
		return
	end)

	arg0_12.timelineDic = {}

	local var1_12 = SceneManager.GetSceneByName(arg0_12.sceneInfo[2].name):GetRootGameObjects()

	table.IpairsCArray(var1_12, function(arg0_14, arg1_14)
		local var0_14 = arg1_14.transform:Find("[sequence]")

		if var0_14 then
			local var1_14 = var0_14:GetComponent(typeof(UnityEngine.Playables.PlayableDirector))

			arg0_12.timelineDic[arg1_14.name] = {
				obj = arg1_14,
				seq = var0_14,
				director = var1_14
			}

			TimelineSupport.DisablePlayOnAwake(var1_14)
			setActive(arg1_14, true)
		end
	end)

	arg0_12.speedComp = GetOrAddComponent(arg0_12.timelineDic[arg0_12.gameConfig.perform_catch].seq, typeof(TimelineSpeed))
end

function var0_0.didEnter(arg0_15)
	arg0_15:StartGame()
end

function var0_0.ShowCountDown(arg0_16)
	setActive(arg0_16.countTF, true)
end

function var0_0.StartQTE(arg0_17)
	local var0_17 = {}

	arg0_17.resultList = {}

	for iter0_17 = 1, SlideConst.QTE_COUNT do
		table.insert(var0_17, function(arg0_18)
			local var0_18 = cloneTplTo(arg0_17.qteTF, arg0_17._tf:Find("GameUI"))
			local var1_18 = var0_18:Find("animroot/Perfect")
			local var2_18 = (SlideConst.QTE_TIME - SlideConst.QTE_SUCCESS_RANGE[1]) / SlideConst.QTE_TIME

			setLocalScale(var1_18, Vector3(var2_18, var2_18, var2_18))

			local var3_18 = var0_18:Find("animroot/Centres")
			local var4_18 = (SlideConst.QTE_TIME - SlideConst.QTE_SUCCESS_RANGE[2]) / SlideConst.QTE_TIME

			setLocalScale(var3_18, Vector3(var4_18, var4_18, var4_18))
			setAnchoredPosition(var0_18, {
				x = arg0_17.gameConfig.qte_position[iter0_17][1],
				y = arg0_17.gameConfig.qte_position[iter0_17][2]
			})
			setActive(var0_18, true)

			local var5_18 = var0_18:Find("animroot/Trigger")
			local var6_18 = 0
			local var7_18 = Timer.New(function()
				if var6_18 >= SlideConst.QTE_TIME then
					arg0_17.timerList[iter0_17]:Stop()
					setActive(var0_18, false)

					return
				end

				var6_18 = var6_18 + 0.0166666666666667
				var5_18.localScale = Vector3.Lerp(Vector3(1, 1, 1), Vector3(0, 0, 0), var6_18 / SlideConst.QTE_TIME)
			end, 0.0166666666666667, -1)

			var7_18:Start()

			arg0_17.timerList[iter0_17] = var7_18

			onButton(arg0_17, var0_18, function()
				arg0_17.timerList[iter0_17]:Stop()

				if var6_18 >= SlideConst.QTE_SUCCESS_RANGE[1] and var6_18 <= SlideConst.QTE_SUCCESS_RANGE[2] then
					arg0_17.resultList[iter0_17] = true

					setActive(var0_18:Find("animroot/Result/Hit"), true)
				else
					arg0_17.resultList[iter0_17] = false

					setActive(var0_18:Find("animroot/Result/Miss"), true)
				end
			end)
			table.insert(arg0_17.ltList, LeanTween.delayedCall(iter0_17 == SlideConst.QTE_COUNT and SlideConst.QTE_TIME or SlideConst.QTE_INTERVAL, System.Action(arg0_18)).uniqueId)
		end)
	end

	seriesAsync(var0_17, function()
		arg0_17:EndQTE()
	end)
	arg0_17.speedComp:SetTimelineSpeed(SlideConst.QTE_SLOW_SPEED)
end

function var0_0.EndQTE(arg0_22)
	arg0_22.speedComp:SetTimelineSpeed(1)

	arg0_22.catchSuccess = true

	for iter0_22 = 1, SlideConst.QTE_COUNT do
		if not arg0_22.resultList[iter0_22] then
			arg0_22.catchSuccess = false

			break
		end
	end

	setActive(arg0_22.endUI, true)
	setActive(arg0_22.endUI:Find("Title/Victory"), arg0_22.catchSuccess)
	setActive(arg0_22.endUI:Find("Title/Defeat"), not arg0_22.catchSuccess)
	onDelayTick(function()
		quickPlayAnimation(arg0_22.endUI, "Anim_Dorm3d_volleyball_end_out")
		onDelayTick(function()
			setActive(arg0_22.endUI, false)
		end, 0.1)
	end, 1.167)
end

function var0_0.StartGame(arg0_25)
	seriesAsync({
		function(arg0_26)
			arg0_25:PlayTimeline(arg0_25.gameConfig.perform_ready, arg0_26)
		end,
		function(arg0_27)
			arg0_25:PlayTimeline(arg0_25.gameConfig.perform_down, arg0_27)
		end,
		function(arg0_28)
			arg0_25:PlayTimeline(arg0_25.gameConfig.perform_catch, arg0_28)
		end,
		function(arg0_29)
			if arg0_25.catchSuccess then
				arg0_25:PlayTimeline(arg0_25.gameConfig.perform_success, arg0_29)
			else
				arg0_25:PlayTimeline(arg0_25.gameConfig.perform_fail, arg0_29)
			end
		end
	}, function()
		arg0_25:emit(var0_0.ON_BACK)
	end)
end

function var0_0.PlayTimeline(arg0_31, arg1_31, arg2_31)
	local var0_31 = arg0_31.timelineDic[arg1_31].seq
	local var1_31 = arg0_31.timelineDic[arg1_31].director

	GetOrAddComponent(var0_31, "DftCommonSignalReceiver"):SetCommonEvent(function(arg0_32)
		switch(arg0_32.stringParameter, {
			PrepareQTE = function()
				arg0_31:ShowCountDown()
			end,
			StartQTE = function()
				arg0_31:StartQTE()
			end,
			TimelineEnd = function()
				var1_31:Stop()
				existCall(arg2_31)
			end,
			Vibrate = function()
				return
			end
		}, function()
			warning("other event trigger:" .. arg0_32.stringParameter)
		end)
	end)
	var1_31:Play()
end

function var0_0.willExit(arg0_38)
	for iter0_38, iter1_38 in ipairs(arg0_38.ltList) do
		if LeanTween.isTweening(iter1_38) then
			LeanTween.cancel(iter1_38)
		end
	end

	for iter2_38, iter3_38 in pairs(arg0_38.timerList) do
		iter3_38:Stop()
	end

	local var0_38 = underscore.map(arg0_38.sceneInfo, function(arg0_39)
		return function(arg0_40)
			SceneOpMgr.Inst:UnloadSceneAsync(arg0_39.path, arg0_39.name, arg0_40)
		end
	end)

	seriesAsync(var0_38, function()
		return
	end)
end

return var0_0
