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

function var0_0.init(arg0_7)
	arg0_7:InitScene()
	arg0_7:InitUI()

	local var0_7 = Dorm3dHxHelper.GetTimelineMainCharacter()

	Dorm3dHxHelper.ReplaceCharacterParts(var0_7)
	Dorm3dHxHelper.ShowHolyLight({
		var0_7
	}, arg0_7.holyLightRoot)
end

function var0_0.InitUI(arg0_8)
	onButton(arg0_8, arg0_8._tf:Find("GameUI/Title/BackBtn"), function()
		arg0_8:emit(var0_0.ON_BACK)
	end, SFX_DORM_CLICK)

	arg0_8.qteTF = arg0_8._tf:Find("GameUI/QTE")

	setActive(arg0_8.qteTF, false)

	arg0_8.countTF = arg0_8._tf:Find("GameUI/Count")

	setActive(arg0_8.countTF, false)
	arg0_8.countTF:GetComponent(typeof(DftAniEvent)):SetEndEvent(function()
		setActive(arg0_8.countTF, false)
	end)

	arg0_8.endUI = arg0_8._tf:Find("EndUI")

	setText(arg0_8._tf:Find("GameUI/Title/Text"), i18n("3ddorm_beach_slide_tip7"))

	arg0_8.ltList = {}
	arg0_8.timerList = {}
	arg0_8.holyLightRoot = arg0_8._tf:Find("HolyLightRoot")
end

function var0_0.InitScene(arg0_11)
	local var0_11 = SceneManager.GetSceneByName(arg0_11.sceneInfo[1].name):GetRootGameObjects()

	table.IpairsCArray(var0_11, function(arg0_12, arg1_12)
		return
	end)

	arg0_11.timelineDic = {}

	local var1_11 = SceneManager.GetSceneByName(arg0_11.sceneInfo[2].name):GetRootGameObjects()

	table.IpairsCArray(var1_11, function(arg0_13, arg1_13)
		local var0_13 = arg1_13.transform:Find("[sequence]")

		if var0_13 then
			local var1_13 = var0_13:GetComponent(typeof(UnityEngine.Playables.PlayableDirector))

			arg0_11.timelineDic[arg1_13.name] = {
				obj = arg1_13,
				seq = var0_13,
				director = var1_13
			}

			TimelineSupport.DisablePlayOnAwake(var1_13)
			setActive(arg1_13, true)
		end
	end)

	arg0_11.speedComp = GetOrAddComponent(arg0_11.timelineDic[arg0_11.gameConfig.perform_catch].seq, typeof(TimelineSpeed))
end

function var0_0.didEnter(arg0_14)
	arg0_14:StartGame()
end

function var0_0.ShowCountDown(arg0_15)
	setActive(arg0_15.countTF, true)
end

function var0_0.StartQTE(arg0_16)
	local var0_16 = {}

	arg0_16.resultList = {}

	for iter0_16 = 1, SlideConst.QTE_COUNT do
		table.insert(var0_16, function(arg0_17)
			local var0_17 = cloneTplTo(arg0_16.qteTF, arg0_16._tf:Find("GameUI"))
			local var1_17 = var0_17:Find("animroot/Perfect")
			local var2_17 = (SlideConst.QTE_TIME - SlideConst.QTE_SUCCESS_RANGE[1]) / SlideConst.QTE_TIME

			setLocalScale(var1_17, Vector3(var2_17, var2_17, var2_17))

			local var3_17 = var0_17:Find("animroot/Centres")
			local var4_17 = (SlideConst.QTE_TIME - SlideConst.QTE_SUCCESS_RANGE[2]) / SlideConst.QTE_TIME

			setLocalScale(var3_17, Vector3(var4_17, var4_17, var4_17))
			setAnchoredPosition(var0_17, {
				x = arg0_16.gameConfig.qte_position[iter0_16][1],
				y = arg0_16.gameConfig.qte_position[iter0_16][2]
			})
			setActive(var0_17, true)

			local var5_17 = var0_17:Find("animroot/Trigger")
			local var6_17 = 0
			local var7_17 = Timer.New(function()
				if var6_17 >= SlideConst.QTE_TIME then
					arg0_16.timerList[iter0_16]:Stop()
					setActive(var0_17, false)

					return
				end

				var6_17 = var6_17 + 0.0166666666666667
				var5_17.localScale = Vector3.Lerp(Vector3(1, 1, 1), Vector3(0, 0, 0), var6_17 / SlideConst.QTE_TIME)
			end, 0.0166666666666667, -1)

			var7_17:Start()

			arg0_16.timerList[iter0_16] = var7_17

			onButton(arg0_16, var0_17, function()
				arg0_16.timerList[iter0_16]:Stop()

				if var6_17 >= SlideConst.QTE_SUCCESS_RANGE[1] and var6_17 <= SlideConst.QTE_SUCCESS_RANGE[2] then
					arg0_16.resultList[iter0_16] = true

					setActive(var0_17:Find("animroot/Result/Hit"), true)
				else
					arg0_16.resultList[iter0_16] = false

					setActive(var0_17:Find("animroot/Result/Miss"), true)
				end
			end)
			table.insert(arg0_16.ltList, LeanTween.delayedCall(iter0_16 == SlideConst.QTE_COUNT and SlideConst.QTE_TIME or SlideConst.QTE_INTERVAL, System.Action(arg0_17)).uniqueId)
		end)
	end

	seriesAsync(var0_16, function()
		arg0_16:EndQTE()
	end)
	arg0_16.speedComp:SetTimelineSpeed(SlideConst.QTE_SLOW_SPEED)
end

function var0_0.EndQTE(arg0_21)
	arg0_21.speedComp:SetTimelineSpeed(1)

	arg0_21.catchSuccess = true

	for iter0_21 = 1, SlideConst.QTE_COUNT do
		if not arg0_21.resultList[iter0_21] then
			arg0_21.catchSuccess = false

			break
		end
	end

	setActive(arg0_21.endUI, true)
	setActive(arg0_21.endUI:Find("Title/Victory"), arg0_21.catchSuccess)
	setActive(arg0_21.endUI:Find("Title/Defeat"), not arg0_21.catchSuccess)
	onDelayTick(function()
		quickPlayAnimation(arg0_21.endUI, "Anim_Dorm3d_volleyball_end_out")
		onDelayTick(function()
			setActive(arg0_21.endUI, false)
		end, 0.1)
	end, 1.167)
end

function var0_0.StartGame(arg0_24)
	seriesAsync({
		function(arg0_25)
			arg0_24:PlayTimeline(arg0_24.gameConfig.perform_ready, arg0_25)
		end,
		function(arg0_26)
			arg0_24:PlayTimeline(arg0_24.gameConfig.perform_down, arg0_26)
		end,
		function(arg0_27)
			arg0_24:PlayTimeline(arg0_24.gameConfig.perform_catch, arg0_27)
		end,
		function(arg0_28)
			if arg0_24.catchSuccess then
				arg0_24:PlayTimeline(arg0_24.gameConfig.perform_success, arg0_28)
			else
				arg0_24:PlayTimeline(arg0_24.gameConfig.perform_fail, arg0_28)
			end
		end
	}, function()
		arg0_24:emit(var0_0.ON_BACK)
	end)
end

function var0_0.PlayTimeline(arg0_30, arg1_30, arg2_30)
	local var0_30 = arg0_30.timelineDic[arg1_30].seq
	local var1_30 = arg0_30.timelineDic[arg1_30].director

	GetOrAddComponent(var0_30, "DftCommonSignalReceiver"):SetCommonEvent(function(arg0_31)
		switch(arg0_31.stringParameter, {
			PrepareQTE = function()
				arg0_30:ShowCountDown()
			end,
			StartQTE = function()
				arg0_30:StartQTE()
			end,
			TimelineEnd = function()
				var1_30:Stop()
				existCall(arg2_30)
			end,
			Vibrate = function()
				return
			end
		}, function()
			warning("other event trigger:" .. arg0_31.stringParameter)
		end)
	end)
	var1_30:Play()
end

function var0_0.willExit(arg0_37)
	for iter0_37, iter1_37 in ipairs(arg0_37.ltList) do
		if LeanTween.isTweening(iter1_37) then
			LeanTween.cancel(iter1_37)
		end
	end

	for iter2_37, iter3_37 in pairs(arg0_37.timerList) do
		iter3_37:Stop()
	end

	local var0_37 = underscore.map(arg0_37.sceneInfo, function(arg0_38)
		return function(arg0_39)
			SceneOpMgr.Inst:UnloadSceneAsync(arg0_38.path, arg0_38.name, arg0_39)
		end
	end)

	seriesAsync(var0_37, function()
		return
	end)
end

return var0_0
