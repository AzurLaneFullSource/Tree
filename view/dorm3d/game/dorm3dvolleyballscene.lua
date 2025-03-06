local var0_0 = class("Dorm3dVolleyballScene", import("view.dorm3d.Game.Dorm3dGameTemplate"))
local var1_0 = "ui-dorm_countdown"
local var2_0 = "ui-dorm_qte_appear"
local var3_0 = "ui-dorm_qte_hit"
local var4_0 = "ui-dorm_qte_citical"
local var5_0 = "ui-dorm_qte_miss"
local var6_0 = "ui-dorm_scoring"
local var7_0 = "ui-dorm_victory"
local var8_0 = "ui-dorm_pop_up"

var0_0.QTE_RESULT = {
	MISS = "Miss",
	PERFECT = "Critical",
	HIT = "Hit"
}
var0_0.ROUND_RESULT = {
	OUR_WIN = 1,
	OTHER_WIN = 2
}
var0_0.GAME_RESULT = {
	VICTORY = 1,
	DEFEAT = 2
}
var0_0.hitRadiusMax = 231
var0_0.hitRadiusMin = 50
var0_0.perfectRadiusMax = 139
var0_0.perfectRadiusMin = 85
var0_0.perfectScaleRandoms = {
	0.7,
	1.7
}
var0_0.triggerRadius = 255
var0_0.endScore = 6
var0_0.BallInitPos = Vector3(22, 4.5, -22.4)
var0_0.BallSpeed = 0.1
var0_0.BallQTESpeed = 0.01
var0_0.BallRandomDelat = {
	Top = 300,
	Bottom = 300,
	Left = 300,
	Right = 300
}

function var0_0.getUIName(arg0_1)
	return "Dorm3dVolleyballUI"
end

function var0_0.forceGC(arg0_2)
	return true
end

function var0_0.loadingQueue(arg0_3)
	return function(arg0_4)
		pg.SceneAnimMgr.GetInstance():Dorm3DSceneChange(function(arg0_5)
			return arg0_4(arg0_5)
		end)
	end
end

function var0_0.lowerAdpter(arg0_6)
	return true
end

local var9_0

function var0_0.Ctor(arg0_7, ...)
	var0_0.super.Ctor(arg0_7, ...)

	arg0_7.loader = AutoLoader.New()
end

function var0_0.preload(arg0_8, arg1_8)
	local var0_8 = arg0_8.contextData.groupId

	arg0_8:SetApartment(getProxy(ApartmentProxy):getApartment(var0_8))

	arg0_8.volleyballCfg = pg.dorm3d_volleyball[var0_8]
	arg0_8.sceneRootName = "beach"
	arg0_8.sceneName = "map_beach_01"
	arg0_8.timelineSceneRootName = pg.dorm3d_dorm_template[var0_8].asset_name
	arg0_8.timelineSceneName = string.lower(arg0_8.volleyballCfg.scene_name)

	seriesAsync({
		function(arg0_9)
			SceneOpMgr.Inst:LoadSceneAsync(string.lower("dorm3d/scenesres/scenes/" .. arg0_8.sceneRootName .. "/" .. arg0_8.sceneName .. "_scene"), arg0_8.sceneName, LoadSceneMode.Additive, function(arg0_10, arg1_10)
				arg0_8:InitGameParam()
				SceneManager.SetActiveScene(arg0_10)
				arg0_9()
			end)
		end,
		function(arg0_11)
			local var0_11 = arg0_8.timelineSceneRootName
			local var1_11 = arg0_8.timelineSceneName

			SceneOpMgr.Inst:LoadSceneAsync(string.lower("dorm3d/character/" .. var0_11 .. "/timeline/" .. var1_11 .. "/" .. var1_11 .. "_scene"), var1_11, LoadSceneMode.Additive, function(arg0_12, arg1_12)
				arg0_11()
			end)
		end
	}, arg1_8)
end

function var0_0.InitGameParam(arg0_13)
	var0_0.BallSpeed = arg0_13.volleyballCfg.BallSpeedParam[1]
	var0_0.BallQTESpeed = arg0_13.volleyballCfg.BallSpeedParam[2]
	var0_0.endScore = arg0_13.volleyballCfg.endScore
end

function var0_0.init(arg0_14)
	arg0_14:initUI()
	arg0_14:initScene()
	arg0_14:BindEvent()
end

function var0_0.initUI(arg0_15)
	arg0_15.skipUI = arg0_15._tf:Find("SkipUI")

	setActive(arg0_15.skipUI, false)

	arg0_15.gameUI = arg0_15._tf:Find("GameUI")

	setText(arg0_15.gameUI:Find("Title/Text"), i18n("dorm3d_volleyball_title"))

	arg0_15.ourScoreTF = arg0_15.gameUI:Find("Score/Content/Left")
	arg0_15.otherScoreTF = arg0_15.gameUI:Find("Score/Content/Right")
	arg0_15.qteTF = arg0_15.gameUI:Find("QTE")
	arg0_15.qteTriggerTF = arg0_15.gameUI:Find("QTE/animroot/Trigger")

	setActive(arg0_15.qteTF, false)
	setActive(arg0_15.gameUI, false)
	arg0_15.gameUI:Find("Count"):GetComponent(typeof(DftAniEvent)):SetEndEvent(function()
		if not arg0_15.isStartGame then
			return
		end

		arg0_15.isStartGame = false

		setActive(arg0_15.gameUI:Find("Count"), false)
		arg0_15:StartOneRound()
		setActive(arg0_15.gameUI:Find("Score"), true)
	end)

	arg0_15.scoreUI = arg0_15._tf:Find("ScoreUI")

	setActive(arg0_15.scoreUI, false)

	arg0_15.endUI = arg0_15._tf:Find("EndUI")

	setActive(arg0_15.endUI, false)

	arg0_15.resultUI = arg0_15._tf:Find("ResultUI")

	setActive(arg0_15.resultUI, false)
	setText(arg0_15.resultUI:Find("AgainBtn/Text"), i18n("dorm3d_minigame_again"))
	setText(arg0_15.resultUI:Find("CloseBtn/Text"), i18n("dorm3d_minigame_close"))
	arg0_15.scoreUI:GetComponent(typeof(DftAniEvent)):SetEndEvent(function()
		if not arg0_15.isEndOneRound then
			return
		end

		arg0_15.isEndOneRound = false

		quickPlayAnimation(arg0_15.scoreUI, "Anim_Dorm3d_volleyball_score_out")
		onDelayTick(function()
			setActive(arg0_15.scoreUI, false)
		end, 0.1)

		if arg0_15:CheckEndGame() then
			arg0_15:EndGame()
		else
			setActive(arg0_15.gameUI, true)
			arg0_15:StartOneRound()
		end
	end)

	local var0_15 = arg0_15._tf:Find("Debug")

	setActive(var0_15, false)

	arg0_15.debugTimelineName = var0_15:Find("Timeline"):GetComponent(typeof(Text))
	arg0_15.debugTrackName = var0_15:Find("Track"):GetComponent(typeof(Text))
end

function var0_0.BindEvent(arg0_19)
	onButton(arg0_19, arg0_19.gameUI:Find("Title/BackBtn"), function()
		arg0_19:onBackPressed()
	end, SFX_CANCEL)
	onButton(arg0_19, arg0_19.gameUI, function()
		if not arg0_19.startQTEUI then
			return
		end

		arg0_19:EndQTE()
	end)
	onButton(arg0_19, arg0_19.skipUI:Find("SkipBtn"), function()
		setActive(arg0_19.skipUI, false)
		arg0_19:StopPlayingTimeline()
		arg0_19:StartGame()
	end, SFX_PANEL)
	onButton(arg0_19, arg0_19.endUI, function()
		arg0_19:emit(Dorm3dGameMediatorTemplate.TRIGGER_FAVOR, arg0_19.apartment.configId)
	end, SFX_PANEL)
	onButton(arg0_19, arg0_19.resultUI:Find("AgainBtn"), function()
		setActive(arg0_19.resultUI, false)
		arg0_19:StartGame()
	end, SFX_PANEL)
	onButton(arg0_19, arg0_19.resultUI:Find("CloseBtn"), function()
		arg0_19:closeView()
	end, SFX_CANCEL)
end

function var0_0.initScene(arg0_26)
	local var0_26 = SceneManager.GetSceneByName(arg0_26.sceneName):GetRootGameObjects()

	table.IpairsCArray(var0_26, function(arg0_27, arg1_27)
		if arg1_27.name == "[MainBlock]" then
			arg0_26.modelRoot = tf(arg1_27):Find("[Model]/scene_root")
			arg0_26.ballTF = arg0_26.modelRoot:Find("fbx/litmap05/pre_db_sportinggoods03")
			arg0_26.ballTF.position = var0_0.BallInitPos

			setActive(arg0_26.ballTF, false)
		elseif arg1_27.name == "MainCamera" then
			arg0_26.mainCamera = arg1_27.transform

			setActive(arg0_26.mainCamera, false)
		elseif arg1_27.name == "PlayerCamera" then
			arg0_26.ballCamera = arg1_27.transform
			arg0_26.ballCameraComp = arg0_26.ballCamera:GetComponent(typeof(Camera))

			setActive(arg0_26.ballCamera, false)
		elseif arg1_27.name == "TriggerPlane" then
			setActive(arg1_27, false)

			local var0_27 = tf(arg1_27):Find("BallCreate")
			local var1_27 = var0_27:GetComponent(typeof(UnityEngine.MeshCollider)).sharedMesh

			arg0_26.ballCreatePlane = Plane.New(var1_27.normals[0], -Vector3.Dot(var0_27.position, var1_27.normals[0]))

			local var2_27 = tf(arg1_27):Find("BallQte")

			setLocalPosition(var2_27, Vector3(arg0_26.volleyballCfg.BallQtePlane[1][1], arg0_26.volleyballCfg.BallQtePlane[1][2], arg0_26.volleyballCfg.BallQtePlane[1][3]))
			setLocalEulerAngles(var2_27, Vector3(arg0_26.volleyballCfg.BallQtePlane[2][1], arg0_26.volleyballCfg.BallQtePlane[2][2], arg0_26.volleyballCfg.BallQtePlane[2][3]))

			local var3_27 = var2_27:GetComponent(typeof(UnityEngine.MeshCollider)).sharedMesh

			arg0_26.ballQtePlane = Plane.New(var3_27.normals[0], -Vector3.Dot(var2_27.position, var3_27.normals[0]))

			local var4_27 = tf(arg1_27):Find("BallMiss")

			setLocalPosition(var4_27, Vector3(arg0_26.volleyballCfg.BallMissPlane[1][1], arg0_26.volleyballCfg.BallMissPlane[1][2], arg0_26.volleyballCfg.BallMissPlane[1][3]))
			setLocalEulerAngles(var4_27, Vector3(arg0_26.volleyballCfg.BallMissPlane[2][1], arg0_26.volleyballCfg.BallMissPlane[2][2], arg0_26.volleyballCfg.BallMissPlane[2][3]))

			local var5_27 = var4_27:GetComponent(typeof(UnityEngine.MeshCollider)).sharedMesh

			arg0_26.ballMissPlane = Plane.New(var5_27.normals[0], -Vector3.Dot(var4_27.position, var5_27.normals[0]))
		end
	end)
	arg0_26:InitLightSettings()

	local var1_26 = SceneManager.GetSceneByName(arg0_26.timelineSceneName):GetRootGameObjects()

	arg0_26.totalDirectorList = {}

	local var2_26 = tolua.createinstance(typeof("BLHX.Rendering.FinalBlit"))

	table.IpairsCArray(var1_26, function(arg0_28, arg1_28)
		local var0_28 = tf(arg1_28):Find("[sequence]")

		if IsNil(var0_28) then
			return
		end

		local var1_28 = tf(arg1_28):Find("[camera]/MainCamera"):GetComponent("BLHX.Rendering.BuiltinAdditionalCameraData")

		ReflectionHelp.RefSetField(typeof("BLHX.Rendering.BuiltinAdditionalCameraData"), "m_FinalBlit", var1_28, var2_26)

		local var2_28 = var0_28:GetComponent(typeof(UnityEngine.Playables.PlayableDirector))

		var2_28.playOnAwake = false

		var2_28:Stop()

		local var3_28 = var0_28:GetComponentsInChildren(typeof(UnityEngine.Playables.PlayableDirector), true)

		for iter0_28 = 0, var3_28.Length - 1 do
			var3_28[iter0_28].playOnAwake = false

			var3_28[iter0_28]:Stop()
		end

		table.insert(arg0_26.totalDirectorList, {
			name = arg1_28.name,
			director = var2_28
		})
		setActive(arg1_28, false)
	end)
end

function var0_0.InitLightSettings(arg0_29)
	arg0_29.globalVolume = GameObject.Find("GlobalVolume")
	arg0_29.characterLight = GameObject.Find("CharacterLight")

	local var0_29 = GameObject.Find("[Lighting]").transform

	table.IpairsCArray(var0_29:GetComponentsInChildren(typeof(Light)), function(arg0_30, arg1_30)
		arg1_30.shadows = UnityEngine.LightShadows.None
	end)
end

function var0_0.didEnter(arg0_31)
	arg0_31:InitData()
	setActive(arg0_31.skipUI, true)
	arg0_31:PlayTimeline({
		name = arg0_31:GetWeightTimeline("jinchang")
	}, function()
		if not arg0_31.playingFlag then
			setActive(arg0_31.skipUI, false)
			arg0_31:StartGame()
		end
	end)
end

function var0_0.InitData(arg0_33)
	return
end

function var0_0.PlayTimeline(arg0_34, arg1_34, arg2_34)
	local var0_34 = arg1_34.name
	local var1_34 = arg1_34.track
	local var2_34 = _.detect(arg0_34.totalDirectorList, function(arg0_35)
		return arg0_35.name == var0_34
	end)

	assert(var2_34, "Missing director " .. var0_34)
	arg0_34:StopPlayingTimeline(tobool(var2_34))

	if not var2_34 then
		existCall(arg2_34)

		return
	end

	local var3_34 = {}

	arg0_34.playingDirector = var2_34.director

	local var4_34 = arg0_34.playingDirector.transform

	arg0_34.debugTimelineName.text = var4_34.parent.name

	table.insert(var3_34, function(arg0_36)
		if arg1_34.time then
			arg0_34.playingDirector.time = math.clamp(arg1_34.time, 0, arg0_34.playingDirector.duration)
		end

		TimelineSupport.InitTimeline(arg0_34.playingDirector)

		local var0_36 = {}

		GetOrAddComponent(var4_34, "DftCommonSignalReceiver"):SetCommonEvent(function(arg0_37)
			switch(arg0_37.stringParameter, {
				TimelineRandomTrack = function()
					arg0_34:DoTimelineRandomTrack(arg0_34.playingDirector)
				end,
				TimelineLoop = function()
					arg0_34.playingDirector.time = arg0_37.floatParameter
				end,
				TimelineEnd = function()
					var0_36.finish = true

					arg0_34.playingDirector:Stop()
					setActive(tf(arg0_34.playingDirector).parent, false)
				end
			}, function()
				warning("other event trigger:" .. arg0_37.stringParameter)
			end)

			if var0_36.finish then
				arg0_34.timelineMark = var0_36
				arg0_34.debugTimelineName.text = ""
				arg0_34.debugTrackName.text = ""

				arg0_36()
			end
		end)
		arg0_34.playingDirector:Evaluate()
		arg0_34:DoTimelineRandomTrack(arg0_34.playingDirector)
		setActive(tf(arg0_34.playingDirector).parent, true)
		arg0_34.playingDirector:Play()
		setActive(arg0_34.mainCamera, false)

		if arg0_34.activeDirectorInfo then
			arg0_34.lastDirectorInfo = arg0_34.activeDirectorInfo
		end

		arg0_34.activeDirectorInfo = var2_34
	end)
	seriesAsync(var3_34, function()
		setActive(arg0_34.mainCamera, true)

		arg0_34.playingDirector = nil

		local var0_42 = arg0_34.timelineMark

		arg0_34.timelineMark = nil

		existCall(arg2_34, var0_42)
	end)
end

function var0_0.StopPlayingTimeline(arg0_43, arg1_43)
	if arg0_43.playingDirector then
		arg0_43.playingDirector:Stop()
		setActive(tf(arg0_43.playingDirector).parent, false)

		arg0_43.debugTimelineName.text = ""
		arg0_43.debugTrackName.text = ""
		arg0_43.playingDirector = nil

		if not arg1_43 then
			setActive(arg0_43.mainCamera, true)
		end
	end
end

function var0_0.StartGame(arg0_44)
	setActive(arg0_44.mainCamera, true)

	arg0_44.playingFlag = true
	arg0_44.gameResult = nil
	arg0_44.ourScore, arg0_44.otherScore = 0, 0

	setActive(arg0_44.gameUI, true)
	setActive(arg0_44.gameUI:Find("Score"), false)

	local var0_44 = arg0_44.gameUI:Find("Count")

	setActive(var0_44, true)

	arg0_44.isStartGame = true

	pg.CriMgr.GetInstance():PlaySE_V3(var1_0)
end

function var0_0.UpdateGameScore(arg0_45)
	setText(arg0_45.ourScoreTF, arg0_45.ourScore)
	setText(arg0_45.otherScoreTF, arg0_45.otherScore)
end

function var0_0.UpdateScoreTpl(arg0_46, arg1_46)
	setText(arg1_46:Find("Left/Tens/Text"), 0)
	setText(arg1_46:Find("Left/Units/Text"), arg0_46.ourScore % 10)
	setText(arg1_46:Find("Right/Tens/Text"), 0)
	setText(arg1_46:Find("Right/Units/Text"), arg0_46.otherScore % 10)
end

function var0_0.StartOneRound(arg0_47)
	arg0_47:UpdateGameScore()

	arg0_47.roundEndFlag = false
	arg0_47.roundResult = nil

	seriesAsync({
		function(arg0_48)
			arg0_47:FaQiuOP(arg0_48)
		end,
		function(arg0_49)
			arg0_47:OneQTE()
		end
	})
end

function var0_0.OneQTE(arg0_50)
	seriesAsync({
		function(arg0_51)
			arg0_50:StartQTE(arg0_51)
		end,
		function(arg0_52)
			switch(arg0_50.qteResult, {
				[var0_0.QTE_RESULT.MISS] = function()
					arg0_50:QteMissOP(function()
						arg0_50.roundEndFlag = true
						arg0_50.roundResult = var0_0.ROUND_RESULT.OTHER_WIN

						arg0_52()
					end)
				end,
				[var0_0.QTE_RESULT.HIT] = function()
					arg0_50:QteHitOP(arg0_52)
				end,
				[var0_0.QTE_RESULT.PERFECT] = function()
					arg0_50:QtePerfectOP(function()
						arg0_50.roundEndFlag = true
						arg0_50.roundResult = var0_0.ROUND_RESULT.OUR_WIN

						arg0_52()
					end)
				end
			}, function()
				assert(false, "unknow qte result" .. arg0_50.qteResult)
			end)
		end
	}, function()
		if not arg0_50.roundEndFlag then
			arg0_50:OneQTE()
		else
			arg0_50:EndOneRound()
		end
	end)
end

function var0_0.EndOneRound(arg0_60)
	pg.CriMgr.GetInstance():PlaySE_V3(var6_0)

	arg0_60.isEndOneRound = true

	setActive(arg0_60.gameUI, false)
	arg0_60:UpdateScoreTpl(arg0_60.scoreUI:Find("ScoreTpl"))
	setText(arg0_60.scoreUI:Find("ScoreTpl/Left/Units/new/newText"), arg0_60.ourScore % 10)
	setText(arg0_60.scoreUI:Find("ScoreTpl/Right/Units/new/newText"), arg0_60.otherScore % 10)
	switch(arg0_60.roundResult, {
		[var0_0.ROUND_RESULT.OUR_WIN] = function()
			arg0_60.ourScore = arg0_60.ourScore + 1

			setText(arg0_60.scoreUI:Find("ScoreTpl/Left/Units/new/newText"), arg0_60.ourScore % 10)
			setActive(arg0_60.scoreUI, true)
			quickPlayAnimation(arg0_60.scoreUI, "Anim_Dorm3d_volleyball_score_leftin")
		end,
		[var0_0.ROUND_RESULT.OTHER_WIN] = function()
			arg0_60.otherScore = arg0_60.otherScore + 1

			setText(arg0_60.scoreUI:Find("ScoreTpl/Right/Units/new/newText"), arg0_60.otherScore % 10)
			setActive(arg0_60.scoreUI, true)
			quickPlayAnimation(arg0_60.scoreUI, "Anim_Dorm3d_volleyball_score_rightin")
		end
	}, function()
		assert(false, "unknow round result" .. arg0_60.roundResult)
	end)
end

function var0_0.CheckEndGame(arg0_64)
	if arg0_64.ourScore >= var0_0.endScore then
		arg0_64.gameResult = var0_0.GAME_RESULT.VICTORY

		return true
	end

	if arg0_64.otherScore >= var0_0.endScore then
		arg0_64.gameResult = var0_0.GAME_RESULT.DEFEAT

		return true
	end

	return false
end

function var0_0.EndGame(arg0_65)
	if arg0_65.gameResult == var0_0.GAME_RESULT.VICTORY then
		pg.CriMgr.GetInstance():PlaySE_V3(var7_0)
	end

	seriesAsync({
		function(arg0_66)
			local var0_66 = arg0_65.gameResult == var0_0.GAME_RESULT.VICTORY and "shibai" or "shengli"

			arg0_65:PlayTimeline({
				name = arg0_65:GetWeightTimeline(var0_66)
			}, arg0_66)
		end
	}, function()
		arg0_65:PlayTimeline({
			name = arg0_65:GetWeightTimeline("daiji")
		}, function()
			return
		end)
		setActive(arg0_65.endUI, true)
		setActive(arg0_65.endUI:Find("Title/Victory"), arg0_65.gameResult == var0_0.GAME_RESULT.VICTORY)
		setActive(arg0_65.endUI:Find("Title/Defeat"), arg0_65.gameResult == var0_0.GAME_RESULT.DEFEAT)
		arg0_65:UpdateScoreTpl(arg0_65.endUI:Find("ScoreTpl"))
	end)
end

function var0_0.ShowResultUI(arg0_69, arg1_69)
	(function()
		local var0_70 = arg0_69.contextData.roomId
		local var1_70 = arg0_69.contextData.groupId
		local var2_70 = arg0_69.contextData.groupIds or {
			var1_70
		}
		local var3_70 = table.concat(var2_70, ",")
		local var4_70 = arg0_69.ourScore .. ":" .. arg0_69.otherScore

		pg.m02:sendNotification(GAME.APARTMENT_TRACK, Dorm3dTrackCommand.BuildDataRoom(var0_70, 8, var3_70, var4_70))
	end)()
	pg.CriMgr.GetInstance():PlaySE_V3(var8_0)
	seriesAsync({
		function(arg0_71)
			quickPlayAnimation(arg0_69.endUI, "Anim_Dorm3d_volleyball_end_out")
			onDelayTick(function()
				setActive(arg0_69.endUI, false)
			end, 0.1)

			if arg0_69.gameResult == var0_0.GAME_RESULT.VICTORY then
				arg0_69:PlayTimeline({
					name = arg0_69:GetWeightTimeline("jiangli")
				}, arg0_71)
			else
				arg0_69:StopPlayingTimeline()
				arg0_71()
			end
		end
	}, function()
		setActive(arg0_69.resultUI, true)

		local var0_73

		var0_73 = arg0_69.gameResult == var0_0.GAME_RESULT.VICTORY and "Victory" or "Defeat"

		setText(arg0_69.resultUI:Find("Panel/Text"), i18n("volleyball_end_tip", arg0_69.apartment:getConfig("name")))

		if arg1_69 and arg1_69.cost > 0 then
			setActive(arg0_69.resultUI:Find("Panel/Award"), true)
			setText(arg0_69.resultUI:Find("Panel/Award/Text"), i18n("volleyball_end_award", arg0_69.apartment:getConfig("name")))
		else
			setActive(arg0_69.resultUI:Find("Panel/Award"), false)
		end

		gcAll()
	end)
end

function var0_0.FaQiuOP(arg0_74, arg1_74)
	arg0_74:PlayTimeline({
		name = arg0_74:GetWeightTimeline("faqiu")
	}, arg1_74)
end

function var0_0.StartQTE(arg0_75, arg1_75)
	arg0_75.qteCallback = arg1_75

	setActive(arg0_75.ballCamera, true)
	setActive(arg0_75.mainCamera, false)

	arg0_75.randomScreenPos = Vector2(math.random(var0_0.BallRandomDelat.Left, Screen.width - var0_0.BallRandomDelat.Right), math.random(var0_0.BallRandomDelat.Bottom, Screen.height - var0_0.BallRandomDelat.Top))

	local var0_75 = arg0_75.ballCameraComp:ScreenPointToRay(arg0_75.randomScreenPos)

	arg0_75.randomScale = math.random(var0_0.perfectScaleRandoms[1] * 10, arg0_75.perfectScaleRandoms[2] * 10) / 10

	local var1_75 = (var0_0.perfectRadiusMax + var0_0.perfectRadiusMin) / 2 * arg0_75.randomScale / var0_0.triggerRadius
	local var2_75 = arg0_75.ballQtePlane.distance + (arg0_75.ballMissPlane.distance - arg0_75.ballQtePlane.distance) * (1 - var1_75)
	local var3_75, var4_75 = Plane.New(arg0_75.ballQtePlane.normal, var2_75):Raycast(var0_75)

	assert(var3_75, "retPerfect plane not in view")

	arg0_75.ballDir = (var0_75:GetPoint(var4_75) - var0_0.BallInitPos):Normalize()

	local var5_75 = Ray.New(arg0_75.ballDir, var0_0.BallInitPos)
	local var6_75, var7_75 = arg0_75.ballQtePlane:Raycast(var5_75)

	assert(var6_75, "qte plane not in view")

	local var8_75 = var5_75:GetPoint(var7_75)
	local var9_75, var10_75 = arg0_75.ballMissPlane:Raycast(var5_75)

	assert(var9_75, "miss plane not in view")

	local var11_75 = var5_75:GetPoint(var10_75)
	local var12_75 = 0

	arg0_75.qteUITime = (var8_75 - var11_75):Magnitude() / var0_0.BallQTESpeed
	arg0_75.ballTimer = Timer.New(function()
		if var12_75 >= var10_75 then
			arg0_75.ballTimer:Stop()

			arg0_75.ballTimer = nil

			setActive(arg0_75.ballTF, false)

			arg0_75.ballTF.position = var0_0.BallInitPos

			if arg0_75.startQTEUI then
				setLocalScale(arg0_75.qteTriggerTF, {
					x = 0,
					y = 0
				})
				arg0_75:EndQTE(var0_0.QTE_RESULT.MISS)
			end
		elseif var12_75 >= var7_75 then
			var12_75 = var12_75 + var0_0.BallQTESpeed
			arg0_75.ballTF.position = var5_75:GetPoint(var12_75)

			if not arg0_75.startQTEUI then
				arg0_75:StartQTEUI()
			end

			arg0_75.curScale = arg0_75.curScale - 1 / arg0_75.qteUITime

			setLocalScale(arg0_75.qteTriggerTF, {
				x = arg0_75.curScale,
				y = arg0_75.curScale
			})

			arg0_75.curRadius = var0_0.triggerRadius * arg0_75.curScale

			if arg0_75.curScale < 0 then
				arg0_75:EndQTE()
			end
		else
			var12_75 = var12_75 + var0_0.BallSpeed
			arg0_75.ballTF.position = var5_75:GetPoint(var12_75)
		end
	end, 0.0166666666666667, -1)

	setActive(arg0_75.ballTF, true)
	arg0_75.ballTimer:Start()
end

function var0_0.StartQTEUI(arg0_77)
	pg.CriMgr.GetInstance():PlaySE_V3(var2_0)
	setLocalScale(arg0_77.qteTriggerTF, {
		x = 1,
		y = 1
	})
	eachChild(arg0_77.qteTF:Find("animroot/Result"), function(arg0_78)
		setActive(arg0_78, false)
	end)

	arg0_77.qteResult = nil
	arg0_77.curRadius = var0_0.triggerRadius
	arg0_77.curPerfectRadiusMax = var0_0.perfectRadiusMax * arg0_77.randomScale
	arg0_77.curPerfectRadiusMin = var0_0.perfectRadiusMin * arg0_77.randomScale

	setLocalScale(arg0_77.qteTF:Find("animroot/Perfect"), {
		x = arg0_77.randomScale,
		y = arg0_77.randomScale
	})

	arg0_77.curScale = 1

	setLocalPosition(arg0_77.qteTF, LuaHelper.ScreenToLocal(arg0_77.qteTF.parent, arg0_77.randomScreenPos, pg.UIMgr.GetInstance().uiCameraComp))
	setActive(arg0_77.qteTF, true)

	arg0_77.startQTEUI = true
end

function var0_0.EndQTE(arg0_79, arg1_79)
	arg0_79.startQTEUI = nil

	setActive(arg0_79.mainCamera, true)
	setActive(arg0_79.ballCamera, false)

	if arg1_79 then
		arg0_79.qteResult = arg1_79
	elseif arg0_79.curRadius < var0_0.hitRadiusMin or arg0_79.curRadius > var0_0.hitRadiusMax then
		arg0_79.qteResult = var0_0.QTE_RESULT.MISS
	elseif arg0_79.curRadius <= arg0_79.curPerfectRadiusMax and arg0_79.curRadius >= arg0_79.curPerfectRadiusMin then
		arg0_79.qteResult = var0_0.QTE_RESULT.PERFECT
	else
		arg0_79.qteResult = var0_0.QTE_RESULT.HIT
	end

	eachChild(arg0_79.qteTF:Find("animroot/Result"), function(arg0_80)
		setActive(arg0_80, arg0_80.name == arg0_79.qteResult)
	end)

	if arg0_79.ballTimer then
		arg0_79.ballTimer:Stop()

		arg0_79.ballTimer = nil

		setActive(arg0_79.ballTF, false)

		arg0_79.ballTF.position = var0_0.BallInitPos
	end

	if arg0_79.qteCallback then
		arg0_79.qteCallback()

		arg0_79.qteCallback = nil
	end

	onDelayTick(function()
		setActive(arg0_79.qteTF, false)
	end, 1)
end

function var0_0.QteMissOP(arg0_82, arg1_82)
	pg.CriMgr.GetInstance():PlaySE_V3(var5_0)
	arg0_82:PlayTimeline({
		name = arg0_82:GetWeightTimeline("shiqiu")
	}, arg1_82)
end

function var0_0.QteHitOP(arg0_83, arg1_83)
	pg.CriMgr.GetInstance():PlaySE_V3(var3_0)
	seriesAsync({
		function(arg0_84)
			arg0_83:PlayTimeline({
				name = arg0_83:GetWeightTimeline("fly")
			}, arg0_84)
		end,
		function(arg0_85)
			arg0_83:PlayTimeline({
				name = arg0_83:GetWeightTimeline("jieqiu")
			}, arg0_85)
		end
	}, arg1_83)
end

function var0_0.QtePerfectOP(arg0_86, arg1_86)
	pg.CriMgr.GetInstance():PlaySE_V3(var4_0)
	seriesAsync({
		function(arg0_87)
			arg0_86:PlayTimeline({
				name = arg0_86:GetWeightTimeline("max_fly")
			}, arg0_87)
		end,
		function(arg0_88)
			arg0_86:PlayTimeline({
				name = arg0_86:GetWeightTimeline("shouji")
			}, arg0_88)
		end
	}, arg1_86)
end

function var0_0.GetWeightTimeline(arg0_89, arg1_89)
	local var0_89 = arg0_89.volleyballCfg[arg1_89]

	assert(var0_89 ~= "", "volleyball cfg is empty string" .. arg1_89)
	assert(#var0_89 ~= 0, "volleyball cfg is empty table:" .. arg1_89)

	local var1_89 = underscore.reduce(var0_89, 0, function(arg0_90, arg1_90)
		return arg0_90 + arg1_90[2]
	end)
	local var2_89 = math.random() * var1_89
	local var3_89 = 0

	for iter0_89, iter1_89 in ipairs(var0_89) do
		var3_89 = var3_89 + iter1_89[2]

		if var2_89 <= var3_89 then
			return iter1_89[1]
		end
	end
end

function var0_0.DoTimelineRandomTrack(arg0_91, arg1_91)
	local var0_91 = {}
	local var1_91 = TimelineHelper.GetTimelineTracks(arg1_91)

	for iter0_91 = 0, var1_91.Length - 1 do
		local var2_91 = var1_91[iter0_91]

		if var2_91.name ~= "Markers" then
			var2_91.muted = true

			table.insert(var0_91, var2_91)
		end
	end

	if #var0_91 > 0 then
		local var3_91 = var0_91[math.random(#var0_91)]

		underscore.each(var0_91, function(arg0_92)
			if arg0_92.name == var3_91.name then
				arg0_92.muted = false
			end
		end)

		arg0_91.debugTrackName.text = var3_91.name
	else
		arg0_91.debugTrackName.text = "track cnt 0"
	end
end

function var0_0.OnPause(arg0_93)
	if arg0_93.ballTimer then
		arg0_93.ballTimer:Stop()
	end

	if arg0_93.playingDirector then
		arg0_93.playingDirector:Pause()
	end
end

function var0_0.OnResume(arg0_94)
	if arg0_94.ballTimer then
		arg0_94.ballTimer:Start()
	end

	if arg0_94.playingDirector then
		arg0_94.playingDirector:Play()
	end
end

function var0_0.onBackPressed(arg0_95)
	if not arg0_95.playingFlag or isActive(arg0_95.gameUI:Find("Count")) or isActive(arg0_95.endUI) then
		return
	end

	arg0_95:OnPause()
	pg.NewStyleMsgboxMgr.GetInstance():Show(pg.NewStyleMsgboxMgr.TYPE_MSGBOX, {
		contentText = i18n("sure_exit_volleyball"),
		onConfirm = function()
			arg0_95:emit(var0_0.ON_BACK)
		end,
		onClose = function()
			arg0_95:OnResume()
		end
	})
end

function var0_0.willExit(arg0_98)
	arg0_98.loader:Clear()

	if arg0_98.ballTimer then
		arg0_98.ballTimer:Stop()

		arg0_98.ballTimer = nil
	end

	local var0_98 = {
		{
			path = string.lower("dorm3d/character/" .. arg0_98.timelineSceneRootName .. "/timeline/" .. arg0_98.timelineSceneName .. "/" .. arg0_98.timelineSceneName .. "_scene"),
			name = arg0_98.timelineSceneName
		},
		{
			path = string.lower("dorm3d/scenesres/scenes/common/" .. arg0_98.sceneRootName .. "/" .. arg0_98.sceneName .. "_scene"),
			name = arg0_98.sceneName
		}
	}
	local var1_98 = underscore.map(var0_98, function(arg0_99)
		return function(arg0_100)
			SceneOpMgr.Inst:UnloadSceneAsync(arg0_99.path, arg0_99.name, arg0_100)
		end
	end)

	seriesAsync(var1_98, function()
		ReflectionHelp.RefSetProperty(typeof("UnityEngine.LightmapSettings"), "lightmaps", nil, nil)
	end)
end

return var0_0
