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

function var0_0.lowerAdpter(arg0_2)
	return true
end

local var9_0

function var0_0.Ctor(arg0_3, ...)
	var0_0.super.Ctor(arg0_3, ...)

	arg0_3.loader = AutoLoader.New()
end

function var0_0.preload(arg0_4, arg1_4)
	local var0_4 = arg0_4.contextData.groupId

	arg0_4:SetApartment(getProxy(ApartmentProxy):getApartment(var0_4))

	arg0_4.volleyballCfg = pg.dorm3d_volleyball[var0_4]
	arg0_4.sceneRootName = "beach"
	arg0_4.sceneName = "map_beach_01"
	arg0_4.timelineSceneRootName = pg.dorm3d_dorm_template[var0_4].asset_name
	arg0_4.timelineSceneName = arg0_4.volleyballCfg.scene_name

	seriesAsync({
		function(arg0_5)
			SceneOpMgr.Inst:LoadSceneAsync(string.lower("dorm3d/scenesres/scenes/" .. arg0_4.sceneRootName .. "/" .. arg0_4.sceneName .. "_scene"), arg0_4.sceneName, LoadSceneMode.Additive, function(arg0_6, arg1_6)
				arg0_4:InitGameParam()
				SceneManager.SetActiveScene(arg0_6)
				arg0_5()
			end)
		end,
		function(arg0_7)
			local var0_7 = arg0_4.timelineSceneRootName
			local var1_7 = arg0_4.timelineSceneName

			SceneOpMgr.Inst:LoadSceneAsync(string.lower("dorm3d/character/" .. var0_7 .. "/timeline/" .. var1_7 .. "/" .. var1_7 .. "_scene"), var1_7, LoadSceneMode.Additive, function(arg0_8, arg1_8)
				arg0_7()
			end)
		end
	}, arg1_4)
end

function var0_0.InitGameParam(arg0_9)
	var0_0.BallSpeed = arg0_9.volleyballCfg.BallSpeedParam[1]
	var0_0.BallQTESpeed = arg0_9.volleyballCfg.BallSpeedParam[2]
	var0_0.endScore = arg0_9.volleyballCfg.endScore
end

function var0_0.init(arg0_10)
	arg0_10:initUI()
	arg0_10:initScene()
	arg0_10:BindEvent()
end

function var0_0.initUI(arg0_11)
	arg0_11.skipUI = arg0_11._tf:Find("SkipUI")

	setActive(arg0_11.skipUI, false)

	arg0_11.gameUI = arg0_11._tf:Find("GameUI")

	setText(arg0_11.gameUI:Find("Title/Text"), i18n("dorm3d_volleyball_title"))

	arg0_11.ourScoreTF = arg0_11.gameUI:Find("Score/Content/Left")
	arg0_11.otherScoreTF = arg0_11.gameUI:Find("Score/Content/Right")
	arg0_11.qteTF = arg0_11.gameUI:Find("QTE")
	arg0_11.qteTriggerTF = arg0_11.gameUI:Find("QTE/animroot/Trigger")

	setActive(arg0_11.qteTF, false)
	setActive(arg0_11.gameUI, false)
	arg0_11.gameUI:Find("Count"):GetComponent(typeof(DftAniEvent)):SetEndEvent(function()
		if not arg0_11.isStartGame then
			return
		end

		arg0_11.isStartGame = false

		setActive(arg0_11.gameUI:Find("Count"), false)
		arg0_11:StartOneRound()
		setActive(arg0_11.gameUI:Find("Score"), true)
	end)

	arg0_11.scoreUI = arg0_11._tf:Find("ScoreUI")

	setActive(arg0_11.scoreUI, false)

	arg0_11.endUI = arg0_11._tf:Find("EndUI")

	setActive(arg0_11.endUI, false)

	arg0_11.resultUI = arg0_11._tf:Find("ResultUI")

	setActive(arg0_11.resultUI, false)
	setText(arg0_11.resultUI:Find("AgainBtn/Text"), i18n("dorm3d_minigame_again"))
	setText(arg0_11.resultUI:Find("CloseBtn/Text"), i18n("dorm3d_minigame_close"))
	arg0_11.scoreUI:GetComponent(typeof(DftAniEvent)):SetEndEvent(function()
		if not arg0_11.isEndOneRound then
			return
		end

		arg0_11.isEndOneRound = false

		quickPlayAnimation(arg0_11.scoreUI, "Anim_Dorm3d_volleyball_score_out")
		onDelayTick(function()
			setActive(arg0_11.scoreUI, false)
		end, 0.1)

		if arg0_11:CheckEndGame() then
			arg0_11:EndGame()
		else
			setActive(arg0_11.gameUI, true)
			arg0_11:StartOneRound()
		end
	end)

	local var0_11 = arg0_11._tf:Find("Debug")

	setActive(var0_11, false)

	arg0_11.debugTimelineName = var0_11:Find("Timeline"):GetComponent(typeof(Text))
	arg0_11.debugTrackName = var0_11:Find("Track"):GetComponent(typeof(Text))
end

function var0_0.BindEvent(arg0_15)
	onButton(arg0_15, arg0_15.gameUI:Find("Title/BackBtn"), function()
		arg0_15:onBackPressed()
	end, SFX_CANCEL)
	onButton(arg0_15, arg0_15.gameUI, function()
		if not arg0_15.startQTEUI then
			return
		end

		arg0_15:EndQTE()
	end)
	onButton(arg0_15, arg0_15.skipUI:Find("SkipBtn"), function()
		setActive(arg0_15.skipUI, false)
		arg0_15:StopPlayingTimeline()
		arg0_15:StartGame()
	end, SFX_PANEL)
	onButton(arg0_15, arg0_15.endUI, function()
		arg0_15:emit(Dorm3dGameMediatorTemplate.TRIGGER_FAVOR, arg0_15.apartment.configId)
	end, SFX_PANEL)
	onButton(arg0_15, arg0_15.resultUI:Find("AgainBtn"), function()
		setActive(arg0_15.resultUI, false)
		arg0_15:StartGame()
	end, SFX_PANEL)
	onButton(arg0_15, arg0_15.resultUI:Find("CloseBtn"), function()
		arg0_15:closeView()
	end, SFX_CANCEL)
end

function var0_0.initScene(arg0_22)
	local var0_22 = SceneManager.GetSceneByName(arg0_22.sceneName):GetRootGameObjects()

	table.IpairsCArray(var0_22, function(arg0_23, arg1_23)
		if arg1_23.name == "[MainBlock]" then
			arg0_22.modelRoot = tf(arg1_23):Find("[Model]/scene_root")
			arg0_22.ballTF = arg0_22.modelRoot:Find("fbx/litmap05/pre_db_sportinggoods03")
			arg0_22.ballTF.position = var0_0.BallInitPos

			setActive(arg0_22.ballTF, false)
		elseif arg1_23.name == "MainCamera" then
			arg0_22.mainCamera = arg1_23.transform

			setActive(arg0_22.mainCamera, false)
		elseif arg1_23.name == "PlayerCamera" then
			arg0_22.ballCamera = arg1_23.transform
			arg0_22.ballCameraComp = arg0_22.ballCamera:GetComponent(typeof(Camera))

			setActive(arg0_22.ballCamera, false)
		elseif arg1_23.name == "TriggerPlane" then
			setActive(arg1_23, false)

			local var0_23 = tf(arg1_23):Find("BallCreate")
			local var1_23 = var0_23:GetComponent(typeof(UnityEngine.MeshCollider)).sharedMesh

			arg0_22.ballCreatePlane = Plane.New(var1_23.normals[0], -Vector3.Dot(var0_23.position, var1_23.normals[0]))

			local var2_23 = tf(arg1_23):Find("BallQte")

			setLocalPosition(var2_23, Vector3(arg0_22.volleyballCfg.BallQtePlane[1][1], arg0_22.volleyballCfg.BallQtePlane[1][2], arg0_22.volleyballCfg.BallQtePlane[1][3]))
			setLocalEulerAngles(var2_23, Vector3(arg0_22.volleyballCfg.BallQtePlane[2][1], arg0_22.volleyballCfg.BallQtePlane[2][2], arg0_22.volleyballCfg.BallQtePlane[2][3]))

			local var3_23 = var2_23:GetComponent(typeof(UnityEngine.MeshCollider)).sharedMesh

			arg0_22.ballQtePlane = Plane.New(var3_23.normals[0], -Vector3.Dot(var2_23.position, var3_23.normals[0]))

			local var4_23 = tf(arg1_23):Find("BallMiss")

			setLocalPosition(var4_23, Vector3(arg0_22.volleyballCfg.BallMissPlane[1][1], arg0_22.volleyballCfg.BallMissPlane[1][2], arg0_22.volleyballCfg.BallMissPlane[1][3]))
			setLocalEulerAngles(var4_23, Vector3(arg0_22.volleyballCfg.BallMissPlane[2][1], arg0_22.volleyballCfg.BallMissPlane[2][2], arg0_22.volleyballCfg.BallMissPlane[2][3]))

			local var5_23 = var4_23:GetComponent(typeof(UnityEngine.MeshCollider)).sharedMesh

			arg0_22.ballMissPlane = Plane.New(var5_23.normals[0], -Vector3.Dot(var4_23.position, var5_23.normals[0]))
		end
	end)
	arg0_22:InitLightSettings()

	local var1_22 = SceneManager.GetSceneByName(arg0_22.timelineSceneName):GetRootGameObjects()

	arg0_22.totalDirectorList = {}

	table.IpairsCArray(var1_22, function(arg0_24, arg1_24)
		local var0_24 = tf(arg1_24):Find("[sequence]")

		if IsNil(var0_24) then
			return
		end

		local var1_24 = var0_24:GetComponent(typeof(UnityEngine.Playables.PlayableDirector))

		var1_24.playOnAwake = false

		var1_24:Stop()

		local var2_24 = var0_24:GetComponentsInChildren(typeof(UnityEngine.Playables.PlayableDirector)):ToTable()

		for iter0_24, iter1_24 in ipairs(var2_24) do
			iter1_24.playOnAwake = false

			iter1_24:Stop()
		end

		table.insert(arg0_22.totalDirectorList, {
			name = arg1_24.name,
			director = var1_24
		})
		setActive(arg1_24, false)
	end)
end

function var0_0.InitLightSettings(arg0_25)
	arg0_25.globalVolume = GameObject.Find("GlobalVolume")
	arg0_25.characterLight = GameObject.Find("CharacterLight")

	local var0_25 = GameObject.Find("[Lighting]").transform

	table.IpairsCArray(var0_25:GetComponentsInChildren(typeof(Light)), function(arg0_26, arg1_26)
		arg1_26.shadows = UnityEngine.LightShadows.None
	end)
end

function var0_0.didEnter(arg0_27)
	arg0_27:InitData()
	setActive(arg0_27.skipUI, true)
	arg0_27:PlayTimeline({
		name = arg0_27:GetWeightTimeline("jinchang")
	}, function()
		if not arg0_27.playingFlag then
			setActive(arg0_27.skipUI, false)
			arg0_27:StartGame()
		end
	end)
end

function var0_0.InitData(arg0_29)
	return
end

function var0_0.PlayTimeline(arg0_30, arg1_30, arg2_30)
	local var0_30 = arg1_30.name
	local var1_30 = arg1_30.track
	local var2_30 = _.detect(arg0_30.totalDirectorList, function(arg0_31)
		return arg0_31.name == var0_30
	end)

	assert(var2_30, "Missing director " .. var0_30)
	arg0_30:StopPlayingTimeline(tobool(var2_30))

	if not var2_30 then
		existCall(arg2_30)

		return
	end

	local var3_30 = {}

	arg0_30.playingDirector = var2_30.director

	local var4_30 = arg0_30.playingDirector.transform

	arg0_30.debugTimelineName.text = var4_30.parent.name

	table.insert(var3_30, function(arg0_32)
		if arg1_30.time then
			arg0_30.playingDirector.time = math.clamp(arg1_30.time, 0, arg0_30.playingDirector.duration)
		end

		TimelineSupport.InitTimeline(arg0_30.playingDirector)

		local var0_32 = {}

		GetOrAddComponent(var4_30, "DftCommonSignalReceiver"):SetCommonEvent(function(arg0_33)
			switch(arg0_33.stringParameter, {
				TimelineRandomTrack = function()
					arg0_30:DoTimelineRandomTrack(arg0_30.playingDirector)
				end,
				TimelineLoop = function()
					arg0_30.playingDirector.time = arg0_33.floatParameter
				end,
				TimelineEnd = function()
					var0_32.finish = true

					arg0_30.playingDirector:Stop()
					setActive(tf(arg0_30.playingDirector).parent, false)
				end
			}, function()
				warning("other event trigger:" .. arg0_33.stringParameter)
			end)

			if var0_32.finish then
				arg0_30.timelineMark = var0_32
				arg0_30.debugTimelineName.text = ""
				arg0_30.debugTrackName.text = ""

				arg0_32()
			end
		end)
		arg0_30.playingDirector:Evaluate()
		arg0_30:DoTimelineRandomTrack(arg0_30.playingDirector)
		setActive(tf(arg0_30.playingDirector).parent, true)
		arg0_30.playingDirector:Play()
		setActive(arg0_30.mainCamera, false)

		if arg0_30.activeDirectorInfo then
			arg0_30.lastDirectorInfo = arg0_30.activeDirectorInfo
		end

		arg0_30.activeDirectorInfo = var2_30
	end)
	seriesAsync(var3_30, function()
		setActive(arg0_30.mainCamera, true)

		arg0_30.playingDirector = nil

		local var0_38 = arg0_30.timelineMark

		arg0_30.timelineMark = nil

		existCall(arg2_30, var0_38)
	end)
end

function var0_0.StopPlayingTimeline(arg0_39, arg1_39)
	if arg0_39.playingDirector then
		arg0_39.playingDirector:Stop()
		setActive(tf(arg0_39.playingDirector).parent, false)

		arg0_39.debugTimelineName.text = ""
		arg0_39.debugTrackName.text = ""
		arg0_39.playingDirector = nil

		if not arg1_39 then
			setActive(arg0_39.mainCamera, true)
		end
	end
end

function var0_0.StartGame(arg0_40)
	setActive(arg0_40.mainCamera, true)

	arg0_40.playingFlag = true
	arg0_40.gameResult = nil
	arg0_40.ourScore, arg0_40.otherScore = 0, 0

	setActive(arg0_40.gameUI, true)
	setActive(arg0_40.gameUI:Find("Score"), false)

	local var0_40 = arg0_40.gameUI:Find("Count")

	setActive(var0_40, true)

	arg0_40.isStartGame = true

	pg.CriMgr.GetInstance():PlaySE_V3(var1_0)
end

function var0_0.UpdateGameScore(arg0_41)
	setText(arg0_41.ourScoreTF, arg0_41.ourScore)
	setText(arg0_41.otherScoreTF, arg0_41.otherScore)
end

function var0_0.UpdateScoreTpl(arg0_42, arg1_42)
	setText(arg1_42:Find("Left/Tens/Text"), 0)
	setText(arg1_42:Find("Left/Units/Text"), arg0_42.ourScore % 10)
	setText(arg1_42:Find("Right/Tens/Text"), 0)
	setText(arg1_42:Find("Right/Units/Text"), arg0_42.otherScore % 10)
end

function var0_0.StartOneRound(arg0_43)
	arg0_43:UpdateGameScore()

	arg0_43.roundEndFlag = false
	arg0_43.roundResult = nil

	seriesAsync({
		function(arg0_44)
			arg0_43:FaQiuOP(arg0_44)
		end,
		function(arg0_45)
			arg0_43:OneQTE()
		end
	})
end

function var0_0.OneQTE(arg0_46)
	seriesAsync({
		function(arg0_47)
			arg0_46:StartQTE(arg0_47)
		end,
		function(arg0_48)
			switch(arg0_46.qteResult, {
				[var0_0.QTE_RESULT.MISS] = function()
					arg0_46:QteMissOP(function()
						arg0_46.roundEndFlag = true
						arg0_46.roundResult = var0_0.ROUND_RESULT.OTHER_WIN

						arg0_48()
					end)
				end,
				[var0_0.QTE_RESULT.HIT] = function()
					arg0_46:QteHitOP(arg0_48)
				end,
				[var0_0.QTE_RESULT.PERFECT] = function()
					arg0_46:QtePerfectOP(function()
						arg0_46.roundEndFlag = true
						arg0_46.roundResult = var0_0.ROUND_RESULT.OUR_WIN

						arg0_48()
					end)
				end
			}, function()
				assert(false, "unknow qte result" .. arg0_46.qteResult)
			end)
		end
	}, function()
		if not arg0_46.roundEndFlag then
			arg0_46:OneQTE()
		else
			arg0_46:EndOneRound()
		end
	end)
end

function var0_0.EndOneRound(arg0_56)
	pg.CriMgr.GetInstance():PlaySE_V3(var6_0)

	arg0_56.isEndOneRound = true

	setActive(arg0_56.gameUI, false)
	arg0_56:UpdateScoreTpl(arg0_56.scoreUI:Find("ScoreTpl"))
	setText(arg0_56.scoreUI:Find("ScoreTpl/Left/Units/new/newText"), arg0_56.ourScore % 10)
	setText(arg0_56.scoreUI:Find("ScoreTpl/Right/Units/new/newText"), arg0_56.otherScore % 10)
	switch(arg0_56.roundResult, {
		[var0_0.ROUND_RESULT.OUR_WIN] = function()
			arg0_56.ourScore = arg0_56.ourScore + 1

			setText(arg0_56.scoreUI:Find("ScoreTpl/Left/Units/new/newText"), arg0_56.ourScore % 10)
			setActive(arg0_56.scoreUI, true)
			quickPlayAnimation(arg0_56.scoreUI, "Anim_Dorm3d_volleyball_score_leftin")
		end,
		[var0_0.ROUND_RESULT.OTHER_WIN] = function()
			arg0_56.otherScore = arg0_56.otherScore + 1

			setText(arg0_56.scoreUI:Find("ScoreTpl/Right/Units/new/newText"), arg0_56.otherScore % 10)
			setActive(arg0_56.scoreUI, true)
			quickPlayAnimation(arg0_56.scoreUI, "Anim_Dorm3d_volleyball_score_rightin")
		end
	}, function()
		assert(false, "unknow round result" .. arg0_56.roundResult)
	end)
end

function var0_0.CheckEndGame(arg0_60)
	if arg0_60.ourScore >= var0_0.endScore then
		arg0_60.gameResult = var0_0.GAME_RESULT.VICTORY

		return true
	end

	if arg0_60.otherScore >= var0_0.endScore then
		arg0_60.gameResult = var0_0.GAME_RESULT.DEFEAT

		return true
	end

	return false
end

function var0_0.EndGame(arg0_61)
	if arg0_61.gameResult == var0_0.GAME_RESULT.VICTORY then
		pg.CriMgr.GetInstance():PlaySE_V3(var7_0)
	end

	seriesAsync({
		function(arg0_62)
			local var0_62 = arg0_61.gameResult == var0_0.GAME_RESULT.VICTORY and "shibai" or "shengli"

			arg0_61:PlayTimeline({
				name = arg0_61:GetWeightTimeline(var0_62)
			}, arg0_62)
		end
	}, function()
		arg0_61:PlayTimeline({
			name = arg0_61:GetWeightTimeline("daiji")
		}, function()
			return
		end)
		setActive(arg0_61.endUI, true)
		setActive(arg0_61.endUI:Find("Title/Victory"), arg0_61.gameResult == var0_0.GAME_RESULT.VICTORY)
		setActive(arg0_61.endUI:Find("Title/Defeat"), arg0_61.gameResult == var0_0.GAME_RESULT.DEFEAT)
		arg0_61:UpdateScoreTpl(arg0_61.endUI:Find("ScoreTpl"))
	end)
end

function var0_0.ShowResultUI(arg0_65, arg1_65)
	(function()
		local var0_66 = arg0_65.contextData.roomId
		local var1_66 = arg0_65.contextData.groupId
		local var2_66 = arg0_65.contextData.groupIds or {
			var1_66
		}
		local var3_66 = table.concat(var2_66, ",")
		local var4_66 = arg0_65.ourScore .. ":" .. arg0_65.otherScore

		pg.m02:sendNotification(GAME.APARTMENT_TRACK, Dorm3dTrackCommand.BuildDataRoom(var0_66, 8, var3_66, var4_66))
	end)()
	pg.CriMgr.GetInstance():PlaySE_V3(var8_0)
	seriesAsync({
		function(arg0_67)
			quickPlayAnimation(arg0_65.endUI, "Anim_Dorm3d_volleyball_end_out")
			onDelayTick(function()
				setActive(arg0_65.endUI, false)
			end, 0.1)

			if arg0_65.gameResult == var0_0.GAME_RESULT.VICTORY then
				arg0_65:PlayTimeline({
					name = arg0_65:GetWeightTimeline("jiangli")
				}, arg0_67)
			else
				arg0_65:StopPlayingTimeline()
				arg0_67()
			end
		end
	}, function()
		setActive(arg0_65.resultUI, true)

		local var0_69

		var0_69 = arg0_65.gameResult == var0_0.GAME_RESULT.VICTORY and "Victory" or "Defeat"

		setText(arg0_65.resultUI:Find("Panel/Text"), i18n("volleyball_end_tip", arg0_65.apartment:getConfig("name")))

		if arg1_65 and arg1_65.cost > 0 then
			setActive(arg0_65.resultUI:Find("Panel/Award"), true)
			setText(arg0_65.resultUI:Find("Panel/Award/Text"), i18n("volleyball_end_award", arg0_65.apartment:getConfig("name")))
		else
			setActive(arg0_65.resultUI:Find("Panel/Award"), false)
		end

		gcAll()
	end)
end

function var0_0.FaQiuOP(arg0_70, arg1_70)
	arg0_70:PlayTimeline({
		name = arg0_70:GetWeightTimeline("faqiu")
	}, arg1_70)
end

function var0_0.StartQTE(arg0_71, arg1_71)
	arg0_71.qteCallback = arg1_71

	setActive(arg0_71.ballCamera, true)
	setActive(arg0_71.mainCamera, false)

	arg0_71.randomScreenPos = Vector2(math.random(var0_0.BallRandomDelat.Left, Screen.width - var0_0.BallRandomDelat.Right), math.random(var0_0.BallRandomDelat.Bottom, Screen.height - var0_0.BallRandomDelat.Top))

	local var0_71 = arg0_71.ballCameraComp:ScreenPointToRay(arg0_71.randomScreenPos)

	arg0_71.randomScale = math.random(var0_0.perfectScaleRandoms[1] * 10, arg0_71.perfectScaleRandoms[2] * 10) / 10

	local var1_71 = (var0_0.perfectRadiusMax + var0_0.perfectRadiusMin) / 2 * arg0_71.randomScale / var0_0.triggerRadius
	local var2_71 = arg0_71.ballQtePlane.distance + (arg0_71.ballMissPlane.distance - arg0_71.ballQtePlane.distance) * (1 - var1_71)
	local var3_71, var4_71 = Plane.New(arg0_71.ballQtePlane.normal, var2_71):Raycast(var0_71)

	assert(var3_71, "retPerfect plane not in view")

	arg0_71.ballDir = (var0_71:GetPoint(var4_71) - var0_0.BallInitPos):Normalize()

	local var5_71 = Ray.New(arg0_71.ballDir, var0_0.BallInitPos)
	local var6_71, var7_71 = arg0_71.ballQtePlane:Raycast(var5_71)

	assert(var6_71, "qte plane not in view")

	local var8_71 = var5_71:GetPoint(var7_71)
	local var9_71, var10_71 = arg0_71.ballMissPlane:Raycast(var5_71)

	assert(var9_71, "miss plane not in view")

	local var11_71 = var5_71:GetPoint(var10_71)
	local var12_71 = 0

	arg0_71.qteUITime = (var8_71 - var11_71):Magnitude() / var0_0.BallQTESpeed
	arg0_71.ballTimer = Timer.New(function()
		if var12_71 >= var10_71 then
			arg0_71.ballTimer:Stop()

			arg0_71.ballTimer = nil

			setActive(arg0_71.ballTF, false)

			arg0_71.ballTF.position = var0_0.BallInitPos

			if arg0_71.startQTEUI then
				setLocalScale(arg0_71.qteTriggerTF, {
					x = 0,
					y = 0
				})
				arg0_71:EndQTE(var0_0.QTE_RESULT.MISS)
			end
		elseif var12_71 >= var7_71 then
			var12_71 = var12_71 + var0_0.BallQTESpeed
			arg0_71.ballTF.position = var5_71:GetPoint(var12_71)

			if not arg0_71.startQTEUI then
				arg0_71:StartQTEUI()
			end

			arg0_71.curScale = arg0_71.curScale - 1 / arg0_71.qteUITime

			setLocalScale(arg0_71.qteTriggerTF, {
				x = arg0_71.curScale,
				y = arg0_71.curScale
			})

			arg0_71.curRadius = var0_0.triggerRadius * arg0_71.curScale

			if arg0_71.curScale < 0 then
				arg0_71:EndQTE()
			end
		else
			var12_71 = var12_71 + var0_0.BallSpeed
			arg0_71.ballTF.position = var5_71:GetPoint(var12_71)
		end
	end, 0.0166666666666667, -1)

	setActive(arg0_71.ballTF, true)
	arg0_71.ballTimer:Start()
end

function var0_0.StartQTEUI(arg0_73)
	pg.CriMgr.GetInstance():PlaySE_V3(var2_0)
	setLocalScale(arg0_73.qteTriggerTF, {
		x = 1,
		y = 1
	})
	eachChild(arg0_73.qteTF:Find("animroot/Result"), function(arg0_74)
		setActive(arg0_74, false)
	end)

	arg0_73.qteResult = nil
	arg0_73.curRadius = var0_0.triggerRadius
	arg0_73.curPerfectRadiusMax = var0_0.perfectRadiusMax * arg0_73.randomScale
	arg0_73.curPerfectRadiusMin = var0_0.perfectRadiusMin * arg0_73.randomScale

	setLocalScale(arg0_73.qteTF:Find("animroot/Perfect"), {
		x = arg0_73.randomScale,
		y = arg0_73.randomScale
	})

	arg0_73.curScale = 1

	setLocalPosition(arg0_73.qteTF, LuaHelper.ScreenToLocal(arg0_73.qteTF.parent, arg0_73.randomScreenPos, pg.UIMgr.GetInstance().uiCameraComp))
	setActive(arg0_73.qteTF, true)

	arg0_73.startQTEUI = true
end

function var0_0.EndQTE(arg0_75, arg1_75)
	arg0_75.startQTEUI = nil

	setActive(arg0_75.mainCamera, true)
	setActive(arg0_75.ballCamera, false)

	if arg1_75 then
		arg0_75.qteResult = arg1_75
	elseif arg0_75.curRadius < var0_0.hitRadiusMin or arg0_75.curRadius > var0_0.hitRadiusMax then
		arg0_75.qteResult = var0_0.QTE_RESULT.MISS
	elseif arg0_75.curRadius <= arg0_75.curPerfectRadiusMax and arg0_75.curRadius >= arg0_75.curPerfectRadiusMin then
		arg0_75.qteResult = var0_0.QTE_RESULT.PERFECT
	else
		arg0_75.qteResult = var0_0.QTE_RESULT.HIT
	end

	eachChild(arg0_75.qteTF:Find("animroot/Result"), function(arg0_76)
		setActive(arg0_76, arg0_76.name == arg0_75.qteResult)
	end)

	if arg0_75.ballTimer then
		arg0_75.ballTimer:Stop()

		arg0_75.ballTimer = nil

		setActive(arg0_75.ballTF, false)

		arg0_75.ballTF.position = var0_0.BallInitPos
	end

	if arg0_75.qteCallback then
		arg0_75.qteCallback()

		arg0_75.qteCallback = nil
	end

	onDelayTick(function()
		setActive(arg0_75.qteTF, false)
	end, 1)
end

function var0_0.QteMissOP(arg0_78, arg1_78)
	pg.CriMgr.GetInstance():PlaySE_V3(var5_0)
	arg0_78:PlayTimeline({
		name = arg0_78:GetWeightTimeline("shiqiu")
	}, arg1_78)
end

function var0_0.QteHitOP(arg0_79, arg1_79)
	pg.CriMgr.GetInstance():PlaySE_V3(var3_0)
	seriesAsync({
		function(arg0_80)
			arg0_79:PlayTimeline({
				name = arg0_79:GetWeightTimeline("fly")
			}, arg0_80)
		end,
		function(arg0_81)
			arg0_79:PlayTimeline({
				name = arg0_79:GetWeightTimeline("jieqiu")
			}, arg0_81)
		end
	}, arg1_79)
end

function var0_0.QtePerfectOP(arg0_82, arg1_82)
	pg.CriMgr.GetInstance():PlaySE_V3(var4_0)
	seriesAsync({
		function(arg0_83)
			arg0_82:PlayTimeline({
				name = arg0_82:GetWeightTimeline("max_fly")
			}, arg0_83)
		end,
		function(arg0_84)
			arg0_82:PlayTimeline({
				name = arg0_82:GetWeightTimeline("shouji")
			}, arg0_84)
		end
	}, arg1_82)
end

function var0_0.GetWeightTimeline(arg0_85, arg1_85)
	local var0_85 = arg0_85.volleyballCfg[arg1_85]

	assert(var0_85 ~= "", "volleyball cfg is empty string" .. arg1_85)
	assert(#var0_85 ~= 0, "volleyball cfg is empty table:" .. arg1_85)

	local var1_85 = underscore.reduce(var0_85, 0, function(arg0_86, arg1_86)
		return arg0_86 + arg1_86[2]
	end)
	local var2_85 = math.random() * var1_85
	local var3_85 = 0

	for iter0_85, iter1_85 in ipairs(var0_85) do
		var3_85 = var3_85 + iter1_85[2]

		if var2_85 <= var3_85 then
			return iter1_85[1]
		end
	end
end

function var0_0.DoTimelineRandomTrack(arg0_87, arg1_87)
	local var0_87 = {}

	for iter0_87, iter1_87 in ipairs(TimelineHelper.GetTimelineTracks(arg1_87):ToTable()) do
		if iter1_87.name ~= "Markers" then
			iter1_87.muted = true

			table.insert(var0_87, iter1_87)
		end
	end

	if #var0_87 > 0 then
		local var1_87 = var0_87[math.random(#var0_87)]

		underscore.each(var0_87, function(arg0_88)
			if arg0_88.name == var1_87.name then
				arg0_88.muted = false
			end
		end)

		arg0_87.debugTrackName.text = var1_87.name
	else
		arg0_87.debugTrackName.text = "track cnt 0"
	end
end

function var0_0.OnPause(arg0_89)
	if arg0_89.ballTimer then
		arg0_89.ballTimer:Stop()
	end

	if arg0_89.playingDirector then
		arg0_89.playingDirector:Pause()
	end
end

function var0_0.OnResume(arg0_90)
	if arg0_90.ballTimer then
		arg0_90.ballTimer:Start()
	end

	if arg0_90.playingDirector then
		arg0_90.playingDirector:Play()
	end
end

function var0_0.onBackPressed(arg0_91)
	if not arg0_91.playingFlag or isActive(arg0_91.gameUI:Find("Count")) or isActive(arg0_91.endUI) then
		return
	end

	arg0_91:OnPause()
	pg.NewStyleMsgboxMgr.GetInstance():Show(pg.NewStyleMsgboxMgr.TYPE_MSGBOX, {
		contentText = i18n("sure_exit_volleyball"),
		onConfirm = function()
			arg0_91:emit(var0_0.ON_BACK)
		end,
		onClose = function()
			arg0_91:OnResume()
		end
	})
end

function var0_0.willExit(arg0_94)
	arg0_94.loader:Clear()

	if arg0_94.ballTimer then
		arg0_94.ballTimer:Stop()

		arg0_94.ballTimer = nil
	end

	local var0_94 = {
		{
			path = string.lower("dorm3d/character/" .. arg0_94.timelineSceneRootName .. "/timeline/" .. arg0_94.timelineSceneName .. "/" .. arg0_94.timelineSceneName .. "_scene"),
			name = arg0_94.timelineSceneName
		},
		{
			path = string.lower("dorm3d/scenesres/scenes/common/" .. arg0_94.sceneRootName .. "/" .. arg0_94.sceneName .. "_scene"),
			name = arg0_94.sceneName
		}
	}
	local var1_94 = underscore.map(var0_94, function(arg0_95)
		return function(arg0_96)
			SceneOpMgr.Inst:UnloadSceneAsync(arg0_95.path, arg0_95.name, arg0_96)
		end
	end)

	seriesAsync(var1_94, function()
		ReflectionHelp.RefSetProperty(typeof("UnityEngine.LightmapSettings"), "lightmaps", nil, nil)
	end)
end

return var0_0
