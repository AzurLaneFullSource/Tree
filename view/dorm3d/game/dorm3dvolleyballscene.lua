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

local var9_0

function var0_0.Ctor(arg0_2, ...)
	var0_0.super.Ctor(arg0_2, ...)

	arg0_2.loader = AutoLoader.New()
end

function var0_0.preload(arg0_3, arg1_3)
	local var0_3 = arg0_3.contextData.groupId

	arg0_3:SetApartment(getProxy(ApartmentProxy):getApartment(var0_3))

	arg0_3.volleyballCfg = pg.dorm3d_volleyball[var0_3]
	arg0_3.sceneRootName = "beach"
	arg0_3.sceneName = "map_beach_01"
	arg0_3.timelineSceneRootName = pg.dorm3d_dorm_template[var0_3].asset_name
	arg0_3.timelineSceneName = arg0_3.volleyballCfg.scene_name

	seriesAsync({
		function(arg0_4)
			SceneOpMgr.Inst:LoadSceneAsync(string.lower("dorm3d/scenesres/scenes/" .. arg0_3.sceneRootName .. "/" .. arg0_3.sceneName .. "_scene"), arg0_3.sceneName, LoadSceneMode.Additive, function(arg0_5, arg1_5)
				arg0_3:InitGameParam()
				SceneManager.SetActiveScene(arg0_5)
				arg0_4()
			end)
		end,
		function(arg0_6)
			local var0_6 = arg0_3.timelineSceneRootName
			local var1_6 = arg0_3.timelineSceneName

			SceneOpMgr.Inst:LoadSceneAsync(string.lower("dorm3d/character/" .. var0_6 .. "/timeline/" .. var1_6 .. "/" .. var1_6 .. "_scene"), var1_6, LoadSceneMode.Additive, function(arg0_7, arg1_7)
				arg0_6()
			end)
		end
	}, arg1_3)
end

function var0_0.InitGameParam(arg0_8)
	var0_0.BallSpeed = arg0_8.volleyballCfg.BallSpeedParam[1]
	var0_0.BallQTESpeed = arg0_8.volleyballCfg.BallSpeedParam[2]
	var0_0.endScore = arg0_8.volleyballCfg.endScore
end

function var0_0.init(arg0_9)
	arg0_9:initUI()
	arg0_9:initScene()
	arg0_9:BindEvent()
end

function var0_0.initUI(arg0_10)
	arg0_10.skipUI = arg0_10._tf:Find("SkipUI")

	setActive(arg0_10.skipUI, false)

	arg0_10.gameUI = arg0_10._tf:Find("GameUI")

	setText(arg0_10.gameUI:Find("Title/Text"), i18n("dorm3d_volleyball_title"))

	arg0_10.ourScoreTF = arg0_10.gameUI:Find("Score/Content/Left")
	arg0_10.otherScoreTF = arg0_10.gameUI:Find("Score/Content/Right")
	arg0_10.qteTF = arg0_10.gameUI:Find("QTE")
	arg0_10.qteTriggerTF = arg0_10.gameUI:Find("QTE/animroot/Trigger")

	setActive(arg0_10.qteTF, false)
	setActive(arg0_10.gameUI, false)
	arg0_10.gameUI:Find("Count"):GetComponent(typeof(DftAniEvent)):SetEndEvent(function()
		if not arg0_10.isStartGame then
			return
		end

		arg0_10.isStartGame = false

		setActive(arg0_10.gameUI:Find("Count"), false)
		arg0_10:StartOneRound()
		setActive(arg0_10.gameUI:Find("Score"), true)
	end)

	arg0_10.scoreUI = arg0_10._tf:Find("ScoreUI")

	setActive(arg0_10.scoreUI, false)

	arg0_10.endUI = arg0_10._tf:Find("EndUI")

	setActive(arg0_10.endUI, false)

	arg0_10.resultUI = arg0_10._tf:Find("ResultUI")

	setActive(arg0_10.resultUI, false)
	setText(arg0_10.resultUI:Find("AgainBtn/Text"), i18n("dorm3d_minigame_again"))
	setText(arg0_10.resultUI:Find("CloseBtn/Text"), i18n("dorm3d_minigame_close"))
	arg0_10.scoreUI:GetComponent(typeof(DftAniEvent)):SetEndEvent(function()
		if not arg0_10.isEndOneRound then
			return
		end

		arg0_10.isEndOneRound = false

		quickPlayAnimation(arg0_10.scoreUI, "Anim_Dorm3d_volleyball_score_out")
		onDelayTick(function()
			setActive(arg0_10.scoreUI, false)
		end, 0.1)

		if arg0_10:CheckEndGame() then
			arg0_10:EndGame()
		else
			setActive(arg0_10.gameUI, true)
			arg0_10:StartOneRound()
		end
	end)

	local var0_10 = arg0_10._tf:Find("Debug")

	setActive(var0_10, false)

	arg0_10.debugTimelineName = var0_10:Find("Timeline"):GetComponent(typeof(Text))
	arg0_10.debugTrackName = var0_10:Find("Track"):GetComponent(typeof(Text))
end

function var0_0.BindEvent(arg0_14)
	onButton(arg0_14, arg0_14.gameUI:Find("Title/BackBtn"), function()
		arg0_14:onBackPressed()
	end, SFX_CANCEL)
	onButton(arg0_14, arg0_14.gameUI, function()
		if not arg0_14.startQTEUI then
			return
		end

		arg0_14:EndQTE()
	end)
	onButton(arg0_14, arg0_14.skipUI:Find("SkipBtn"), function()
		setActive(arg0_14.skipUI, false)
		arg0_14:StopPlayingTimeline()
		arg0_14:StartGame()
	end, SFX_PANEL)
	onButton(arg0_14, arg0_14.endUI, function()
		arg0_14:emit(Dorm3dGameMediatorTemplate.TRIGGER_FAVOR, arg0_14.apartment.configId)
	end, SFX_PANEL)
	onButton(arg0_14, arg0_14.resultUI:Find("AgainBtn"), function()
		setActive(arg0_14.resultUI, false)
		arg0_14:StartGame()
	end, SFX_PANEL)
	onButton(arg0_14, arg0_14.resultUI:Find("CloseBtn"), function()
		arg0_14:closeView()
	end, SFX_CANCEL)
end

function var0_0.initScene(arg0_21)
	local var0_21 = SceneManager.GetSceneByName(arg0_21.sceneName):GetRootGameObjects()

	table.IpairsCArray(var0_21, function(arg0_22, arg1_22)
		if arg1_22.name == "[MainBlock]" then
			arg0_21.modelRoot = tf(arg1_22):Find("[Model]/scene_root")
			arg0_21.ballTF = arg0_21.modelRoot:Find("fbx/litmap05/pre_db_sportinggoods03")
			arg0_21.ballTF.position = var0_0.BallInitPos

			setActive(arg0_21.ballTF, false)
		elseif arg1_22.name == "MainCamera" then
			arg0_21.mainCamera = arg1_22.transform

			setActive(arg0_21.mainCamera, false)
		elseif arg1_22.name == "PlayerCamera" then
			arg0_21.ballCamera = arg1_22.transform
			arg0_21.ballCameraComp = arg0_21.ballCamera:GetComponent(typeof(Camera))

			setActive(arg0_21.ballCamera, false)
		elseif arg1_22.name == "TriggerPlane" then
			setActive(arg1_22, false)

			local var0_22 = tf(arg1_22):Find("BallCreate")
			local var1_22 = var0_22:GetComponent(typeof(UnityEngine.MeshCollider)).sharedMesh

			arg0_21.ballCreatePlane = Plane.New(var1_22.normals[0], -Vector3.Dot(var0_22.position, var1_22.normals[0]))

			local var2_22 = tf(arg1_22):Find("BallQte")

			setLocalPosition(var2_22, Vector3(arg0_21.volleyballCfg.BallQtePlane[1][1], arg0_21.volleyballCfg.BallQtePlane[1][2], arg0_21.volleyballCfg.BallQtePlane[1][3]))
			setLocalEulerAngles(var2_22, Vector3(arg0_21.volleyballCfg.BallQtePlane[2][1], arg0_21.volleyballCfg.BallQtePlane[2][2], arg0_21.volleyballCfg.BallQtePlane[2][3]))

			local var3_22 = var2_22:GetComponent(typeof(UnityEngine.MeshCollider)).sharedMesh

			arg0_21.ballQtePlane = Plane.New(var3_22.normals[0], -Vector3.Dot(var2_22.position, var3_22.normals[0]))

			local var4_22 = tf(arg1_22):Find("BallMiss")

			setLocalPosition(var4_22, Vector3(arg0_21.volleyballCfg.BallMissPlane[1][1], arg0_21.volleyballCfg.BallMissPlane[1][2], arg0_21.volleyballCfg.BallMissPlane[1][3]))
			setLocalEulerAngles(var4_22, Vector3(arg0_21.volleyballCfg.BallMissPlane[2][1], arg0_21.volleyballCfg.BallMissPlane[2][2], arg0_21.volleyballCfg.BallMissPlane[2][3]))

			local var5_22 = var4_22:GetComponent(typeof(UnityEngine.MeshCollider)).sharedMesh

			arg0_21.ballMissPlane = Plane.New(var5_22.normals[0], -Vector3.Dot(var4_22.position, var5_22.normals[0]))
		end
	end)
	arg0_21:InitLightSettings()

	local var1_21 = SceneManager.GetSceneByName(arg0_21.timelineSceneName):GetRootGameObjects()

	arg0_21.totalDirectorList = {}

	table.IpairsCArray(var1_21, function(arg0_23, arg1_23)
		local var0_23 = tf(arg1_23):Find("[sequence]")

		if IsNil(var0_23) then
			return
		end

		local var1_23 = var0_23:GetComponent(typeof(UnityEngine.Playables.PlayableDirector))

		var1_23.playOnAwake = false

		var1_23:Stop()

		local var2_23 = var0_23:GetComponentsInChildren(typeof(UnityEngine.Playables.PlayableDirector)):ToTable()

		for iter0_23, iter1_23 in ipairs(var2_23) do
			iter1_23.playOnAwake = false

			iter1_23:Stop()
		end

		table.insert(arg0_21.totalDirectorList, {
			name = arg1_23.name,
			director = var1_23
		})
		setActive(arg1_23, false)
	end)
end

function var0_0.InitLightSettings(arg0_24)
	arg0_24.globalVolume = GameObject.Find("GlobalVolume")
	arg0_24.characterLight = GameObject.Find("CharacterLight")

	local var0_24 = GameObject.Find("[Lighting]").transform

	table.IpairsCArray(var0_24:GetComponentsInChildren(typeof(Light)), function(arg0_25, arg1_25)
		arg1_25.shadows = UnityEngine.LightShadows.None
	end)
end

function var0_0.didEnter(arg0_26)
	arg0_26:InitData()
	setActive(arg0_26.skipUI, true)
	arg0_26:PlayTimeline({
		name = arg0_26:GetWeightTimeline("jinchang")
	}, function()
		if not arg0_26.playingFlag then
			setActive(arg0_26.skipUI, false)
			arg0_26:StartGame()
		end
	end)
end

function var0_0.InitData(arg0_28)
	return
end

function var0_0.PlayTimeline(arg0_29, arg1_29, arg2_29)
	local var0_29 = arg1_29.name
	local var1_29 = arg1_29.track
	local var2_29 = _.detect(arg0_29.totalDirectorList, function(arg0_30)
		return arg0_30.name == var0_29
	end)

	assert(var2_29, "Missing director " .. var0_29)
	arg0_29:StopPlayingTimeline(tobool(var2_29))

	if not var2_29 then
		existCall(arg2_29)

		return
	end

	local var3_29 = {}

	arg0_29.playingDirector = var2_29.director

	local var4_29 = arg0_29.playingDirector.transform

	arg0_29.debugTimelineName.text = var4_29.parent.name

	table.insert(var3_29, function(arg0_31)
		if arg1_29.time then
			arg0_29.playingDirector.time = math.clamp(arg1_29.time, 0, arg0_29.playingDirector.duration)
		end

		TimelineSupport.InitTimeline(arg0_29.playingDirector)

		local var0_31 = {}

		GetOrAddComponent(var4_29, "DftCommonSignalReceiver"):SetCommonEvent(function(arg0_32)
			switch(arg0_32.stringParameter, {
				TimelineRandomTrack = function()
					arg0_29:DoTimelineRandomTrack(arg0_29.playingDirector)
				end,
				TimelineLoop = function()
					arg0_29.playingDirector.time = arg0_32.floatParameter
				end,
				TimelineEnd = function()
					var0_31.finish = true

					arg0_29.playingDirector:Stop()
					setActive(tf(arg0_29.playingDirector).parent, false)
				end
			}, function()
				warning("other event trigger:" .. arg0_32.stringParameter)
			end)

			if var0_31.finish then
				arg0_29.timelineMark = var0_31
				arg0_29.debugTimelineName.text = ""
				arg0_29.debugTrackName.text = ""

				arg0_31()
			end
		end)
		arg0_29.playingDirector:Evaluate()
		arg0_29:DoTimelineRandomTrack(arg0_29.playingDirector)
		setActive(tf(arg0_29.playingDirector).parent, true)
		arg0_29.playingDirector:Play()
		setActive(arg0_29.mainCamera, false)

		if arg0_29.activeDirectorInfo then
			arg0_29.lastDirectorInfo = arg0_29.activeDirectorInfo
		end

		arg0_29.activeDirectorInfo = var2_29
	end)
	seriesAsync(var3_29, function()
		setActive(arg0_29.mainCamera, true)

		arg0_29.playingDirector = nil

		local var0_37 = arg0_29.timelineMark

		arg0_29.timelineMark = nil

		existCall(arg2_29, var0_37)
	end)
end

function var0_0.StopPlayingTimeline(arg0_38, arg1_38)
	if arg0_38.playingDirector then
		arg0_38.playingDirector:Stop()
		setActive(tf(arg0_38.playingDirector).parent, false)

		arg0_38.debugTimelineName.text = ""
		arg0_38.debugTrackName.text = ""
		arg0_38.playingDirector = nil

		if not arg1_38 then
			setActive(arg0_38.mainCamera, true)
		end
	end
end

function var0_0.StartGame(arg0_39)
	setActive(arg0_39.mainCamera, true)

	arg0_39.playingFlag = true
	arg0_39.gameResult = nil
	arg0_39.ourScore, arg0_39.otherScore = 0, 0

	setActive(arg0_39.gameUI, true)
	setActive(arg0_39.gameUI:Find("Score"), false)

	local var0_39 = arg0_39.gameUI:Find("Count")

	setActive(var0_39, true)

	arg0_39.isStartGame = true

	pg.CriMgr.GetInstance():PlaySE_V3(var1_0)
end

function var0_0.UpdateGameScore(arg0_40)
	setText(arg0_40.ourScoreTF, arg0_40.ourScore)
	setText(arg0_40.otherScoreTF, arg0_40.otherScore)
end

function var0_0.UpdateScoreTpl(arg0_41, arg1_41)
	setText(arg1_41:Find("Left/Tens/Text"), 0)
	setText(arg1_41:Find("Left/Units/Text"), arg0_41.ourScore % 10)
	setText(arg1_41:Find("Right/Tens/Text"), 0)
	setText(arg1_41:Find("Right/Units/Text"), arg0_41.otherScore % 10)
end

function var0_0.StartOneRound(arg0_42)
	arg0_42:UpdateGameScore()

	arg0_42.roundEndFlag = false
	arg0_42.roundResult = nil

	seriesAsync({
		function(arg0_43)
			arg0_42:FaQiuOP(arg0_43)
		end,
		function(arg0_44)
			arg0_42:OneQTE()
		end
	})
end

function var0_0.OneQTE(arg0_45)
	seriesAsync({
		function(arg0_46)
			arg0_45:StartQTE(arg0_46)
		end,
		function(arg0_47)
			switch(arg0_45.qteResult, {
				[var0_0.QTE_RESULT.MISS] = function()
					arg0_45:QteMissOP(function()
						arg0_45.roundEndFlag = true
						arg0_45.roundResult = var0_0.ROUND_RESULT.OTHER_WIN

						arg0_47()
					end)
				end,
				[var0_0.QTE_RESULT.HIT] = function()
					arg0_45:QteHitOP(arg0_47)
				end,
				[var0_0.QTE_RESULT.PERFECT] = function()
					arg0_45:QtePerfectOP(function()
						arg0_45.roundEndFlag = true
						arg0_45.roundResult = var0_0.ROUND_RESULT.OUR_WIN

						arg0_47()
					end)
				end
			}, function()
				assert(false, "unknow qte result" .. arg0_45.qteResult)
			end)
		end
	}, function()
		if not arg0_45.roundEndFlag then
			arg0_45:OneQTE()
		else
			arg0_45:EndOneRound()
		end
	end)
end

function var0_0.EndOneRound(arg0_55)
	pg.CriMgr.GetInstance():PlaySE_V3(var6_0)

	arg0_55.isEndOneRound = true

	setActive(arg0_55.gameUI, false)
	arg0_55:UpdateScoreTpl(arg0_55.scoreUI:Find("ScoreTpl"))
	setText(arg0_55.scoreUI:Find("ScoreTpl/Left/Units/new/newText"), arg0_55.ourScore % 10)
	setText(arg0_55.scoreUI:Find("ScoreTpl/Right/Units/new/newText"), arg0_55.otherScore % 10)
	switch(arg0_55.roundResult, {
		[var0_0.ROUND_RESULT.OUR_WIN] = function()
			arg0_55.ourScore = arg0_55.ourScore + 1

			setText(arg0_55.scoreUI:Find("ScoreTpl/Left/Units/new/newText"), arg0_55.ourScore % 10)
			setActive(arg0_55.scoreUI, true)
			quickPlayAnimation(arg0_55.scoreUI, "Anim_Dorm3d_volleyball_score_leftin")
		end,
		[var0_0.ROUND_RESULT.OTHER_WIN] = function()
			arg0_55.otherScore = arg0_55.otherScore + 1

			setText(arg0_55.scoreUI:Find("ScoreTpl/Right/Units/new/newText"), arg0_55.otherScore % 10)
			setActive(arg0_55.scoreUI, true)
			quickPlayAnimation(arg0_55.scoreUI, "Anim_Dorm3d_volleyball_score_rightin")
		end
	}, function()
		assert(false, "unknow round result" .. arg0_55.roundResult)
	end)
end

function var0_0.CheckEndGame(arg0_59)
	if arg0_59.ourScore >= var0_0.endScore then
		arg0_59.gameResult = var0_0.GAME_RESULT.VICTORY

		return true
	end

	if arg0_59.otherScore >= var0_0.endScore then
		arg0_59.gameResult = var0_0.GAME_RESULT.DEFEAT

		return true
	end

	return false
end

function var0_0.EndGame(arg0_60)
	if arg0_60.gameResult == var0_0.GAME_RESULT.VICTORY then
		pg.CriMgr.GetInstance():PlaySE_V3(var7_0)
	end

	seriesAsync({
		function(arg0_61)
			local var0_61 = arg0_60.gameResult == var0_0.GAME_RESULT.VICTORY and "shibai" or "shengli"

			arg0_60:PlayTimeline({
				name = arg0_60:GetWeightTimeline(var0_61)
			}, arg0_61)
		end
	}, function()
		arg0_60:PlayTimeline({
			name = arg0_60:GetWeightTimeline("daiji")
		}, function()
			return
		end)
		setActive(arg0_60.endUI, true)
		setActive(arg0_60.endUI:Find("Title/Victory"), arg0_60.gameResult == var0_0.GAME_RESULT.VICTORY)
		setActive(arg0_60.endUI:Find("Title/Defeat"), arg0_60.gameResult == var0_0.GAME_RESULT.DEFEAT)
		arg0_60:UpdateScoreTpl(arg0_60.endUI:Find("ScoreTpl"))
	end)
end

function var0_0.ShowResultUI(arg0_64, arg1_64)
	(function()
		local var0_65 = arg0_64.contextData.roomId
		local var1_65 = arg0_64.contextData.groupId
		local var2_65 = arg0_64.contextData.groupIds or {
			var1_65
		}
		local var3_65 = table.concat(var2_65, ",")
		local var4_65 = arg0_64.ourScore .. ":" .. arg0_64.otherScore

		pg.m02:sendNotification(GAME.APARTMENT_TRACK, Dorm3dTrackCommand.BuildDataRoom(var0_65, 8, var3_65, var4_65))
	end)()
	pg.CriMgr.GetInstance():PlaySE_V3(var8_0)
	seriesAsync({
		function(arg0_66)
			quickPlayAnimation(arg0_64.endUI, "Anim_Dorm3d_volleyball_end_out")
			onDelayTick(function()
				setActive(arg0_64.endUI, false)
			end, 0.1)

			if arg0_64.gameResult == var0_0.GAME_RESULT.VICTORY then
				arg0_64:PlayTimeline({
					name = arg0_64:GetWeightTimeline("jiangli")
				}, arg0_66)
			else
				arg0_64:StopPlayingTimeline()
				arg0_66()
			end
		end
	}, function()
		setActive(arg0_64.resultUI, true)

		local var0_68

		var0_68 = arg0_64.gameResult == var0_0.GAME_RESULT.VICTORY and "Victory" or "Defeat"

		setText(arg0_64.resultUI:Find("Panel/Text"), i18n("volleyball_end_tip", arg0_64.apartment:getConfig("name")))

		if arg1_64 and arg1_64.cost > 0 then
			setActive(arg0_64.resultUI:Find("Panel/Award"), true)
			setText(arg0_64.resultUI:Find("Panel/Award/Text"), i18n("volleyball_end_award", arg0_64.apartment:getConfig("name")))
		else
			setActive(arg0_64.resultUI:Find("Panel/Award"), false)
		end

		gcAll()
	end)
end

function var0_0.FaQiuOP(arg0_69, arg1_69)
	arg0_69:PlayTimeline({
		name = arg0_69:GetWeightTimeline("faqiu")
	}, arg1_69)
end

function var0_0.StartQTE(arg0_70, arg1_70)
	arg0_70.qteCallback = arg1_70

	setActive(arg0_70.ballCamera, true)
	setActive(arg0_70.mainCamera, false)

	arg0_70.randomScreenPos = Vector2(math.random(var0_0.BallRandomDelat.Left, Screen.width - var0_0.BallRandomDelat.Right), math.random(var0_0.BallRandomDelat.Bottom, Screen.height - var0_0.BallRandomDelat.Top))

	local var0_70 = arg0_70.ballCameraComp:ScreenPointToRay(arg0_70.randomScreenPos)

	arg0_70.randomScale = math.random(var0_0.perfectScaleRandoms[1] * 10, arg0_70.perfectScaleRandoms[2] * 10) / 10

	local var1_70 = (var0_0.perfectRadiusMax + var0_0.perfectRadiusMin) / 2 * arg0_70.randomScale / var0_0.triggerRadius
	local var2_70 = arg0_70.ballQtePlane.distance + (arg0_70.ballMissPlane.distance - arg0_70.ballQtePlane.distance) * (1 - var1_70)
	local var3_70, var4_70 = Plane.New(arg0_70.ballQtePlane.normal, var2_70):Raycast(var0_70)

	assert(var3_70, "retPerfect plane not in view")

	arg0_70.ballDir = (var0_70:GetPoint(var4_70) - var0_0.BallInitPos):Normalize()

	local var5_70 = Ray.New(arg0_70.ballDir, var0_0.BallInitPos)
	local var6_70, var7_70 = arg0_70.ballQtePlane:Raycast(var5_70)

	assert(var6_70, "qte plane not in view")

	local var8_70 = var5_70:GetPoint(var7_70)
	local var9_70, var10_70 = arg0_70.ballMissPlane:Raycast(var5_70)

	assert(var9_70, "miss plane not in view")

	local var11_70 = var5_70:GetPoint(var10_70)
	local var12_70 = 0

	arg0_70.qteUITime = (var8_70 - var11_70):Magnitude() / var0_0.BallQTESpeed
	arg0_70.ballTimer = Timer.New(function()
		if var12_70 >= var10_70 then
			arg0_70.ballTimer:Stop()

			arg0_70.ballTimer = nil

			setActive(arg0_70.ballTF, false)

			arg0_70.ballTF.position = var0_0.BallInitPos

			if arg0_70.startQTEUI then
				setLocalScale(arg0_70.qteTriggerTF, {
					x = 0,
					y = 0
				})
				arg0_70:EndQTE(var0_0.QTE_RESULT.MISS)
			end
		elseif var12_70 >= var7_70 then
			var12_70 = var12_70 + var0_0.BallQTESpeed
			arg0_70.ballTF.position = var5_70:GetPoint(var12_70)

			if not arg0_70.startQTEUI then
				arg0_70:StartQTEUI()
			end

			arg0_70.curScale = arg0_70.curScale - 1 / arg0_70.qteUITime

			setLocalScale(arg0_70.qteTriggerTF, {
				x = arg0_70.curScale,
				y = arg0_70.curScale
			})

			arg0_70.curRadius = var0_0.triggerRadius * arg0_70.curScale

			if arg0_70.curScale < 0 then
				arg0_70:EndQTE()
			end
		else
			var12_70 = var12_70 + var0_0.BallSpeed
			arg0_70.ballTF.position = var5_70:GetPoint(var12_70)
		end
	end, 0.0166666666666667, -1)

	setActive(arg0_70.ballTF, true)
	arg0_70.ballTimer:Start()
end

function var0_0.StartQTEUI(arg0_72)
	pg.CriMgr.GetInstance():PlaySE_V3(var2_0)
	setLocalScale(arg0_72.qteTriggerTF, {
		x = 1,
		y = 1
	})
	eachChild(arg0_72.qteTF:Find("animroot/Result"), function(arg0_73)
		setActive(arg0_73, false)
	end)

	arg0_72.qteResult = nil
	arg0_72.curRadius = var0_0.triggerRadius
	arg0_72.curPerfectRadiusMax = var0_0.perfectRadiusMax * arg0_72.randomScale
	arg0_72.curPerfectRadiusMin = var0_0.perfectRadiusMin * arg0_72.randomScale

	setLocalScale(arg0_72.qteTF:Find("animroot/Perfect"), {
		x = arg0_72.randomScale,
		y = arg0_72.randomScale
	})

	arg0_72.curScale = 1

	setLocalPosition(arg0_72.qteTF, LuaHelper.ScreenToLocal(arg0_72.qteTF.parent, arg0_72.randomScreenPos, pg.UIMgr.GetInstance().uiCameraComp))
	setActive(arg0_72.qteTF, true)

	arg0_72.startQTEUI = true
end

function var0_0.EndQTE(arg0_74, arg1_74)
	arg0_74.startQTEUI = nil

	setActive(arg0_74.mainCamera, true)
	setActive(arg0_74.ballCamera, false)

	if arg1_74 then
		arg0_74.qteResult = arg1_74
	elseif arg0_74.curRadius < var0_0.hitRadiusMin or arg0_74.curRadius > var0_0.hitRadiusMax then
		arg0_74.qteResult = var0_0.QTE_RESULT.MISS
	elseif arg0_74.curRadius <= arg0_74.curPerfectRadiusMax and arg0_74.curRadius >= arg0_74.curPerfectRadiusMin then
		arg0_74.qteResult = var0_0.QTE_RESULT.PERFECT
	else
		arg0_74.qteResult = var0_0.QTE_RESULT.HIT
	end

	eachChild(arg0_74.qteTF:Find("animroot/Result"), function(arg0_75)
		setActive(arg0_75, arg0_75.name == arg0_74.qteResult)
	end)

	if arg0_74.ballTimer then
		arg0_74.ballTimer:Stop()

		arg0_74.ballTimer = nil

		setActive(arg0_74.ballTF, false)

		arg0_74.ballTF.position = var0_0.BallInitPos
	end

	if arg0_74.qteCallback then
		arg0_74.qteCallback()

		arg0_74.qteCallback = nil
	end

	onDelayTick(function()
		setActive(arg0_74.qteTF, false)
	end, 1)
end

function var0_0.QteMissOP(arg0_77, arg1_77)
	pg.CriMgr.GetInstance():PlaySE_V3(var5_0)
	arg0_77:PlayTimeline({
		name = arg0_77:GetWeightTimeline("shiqiu")
	}, arg1_77)
end

function var0_0.QteHitOP(arg0_78, arg1_78)
	pg.CriMgr.GetInstance():PlaySE_V3(var3_0)
	seriesAsync({
		function(arg0_79)
			arg0_78:PlayTimeline({
				name = arg0_78:GetWeightTimeline("fly")
			}, arg0_79)
		end,
		function(arg0_80)
			arg0_78:PlayTimeline({
				name = arg0_78:GetWeightTimeline("jieqiu")
			}, arg0_80)
		end
	}, arg1_78)
end

function var0_0.QtePerfectOP(arg0_81, arg1_81)
	pg.CriMgr.GetInstance():PlaySE_V3(var4_0)
	seriesAsync({
		function(arg0_82)
			arg0_81:PlayTimeline({
				name = arg0_81:GetWeightTimeline("max_fly")
			}, arg0_82)
		end,
		function(arg0_83)
			arg0_81:PlayTimeline({
				name = arg0_81:GetWeightTimeline("shouji")
			}, arg0_83)
		end
	}, arg1_81)
end

function var0_0.GetWeightTimeline(arg0_84, arg1_84)
	local var0_84 = arg0_84.volleyballCfg[arg1_84]

	assert(var0_84 ~= "", "volleyball cfg is empty string" .. arg1_84)
	assert(#var0_84 ~= 0, "volleyball cfg is empty table:" .. arg1_84)

	local var1_84 = underscore.reduce(var0_84, 0, function(arg0_85, arg1_85)
		return arg0_85 + arg1_85[2]
	end)
	local var2_84 = math.random() * var1_84
	local var3_84 = 0

	for iter0_84, iter1_84 in ipairs(var0_84) do
		var3_84 = var3_84 + iter1_84[2]

		if var2_84 <= var3_84 then
			return iter1_84[1]
		end
	end
end

function var0_0.DoTimelineRandomTrack(arg0_86, arg1_86)
	local var0_86 = {}

	for iter0_86, iter1_86 in ipairs(TimelineHelper.GetTimelineTracks(arg1_86):ToTable()) do
		if iter1_86.name ~= "Markers" then
			iter1_86.muted = true

			table.insert(var0_86, iter1_86)
		end
	end

	if #var0_86 > 0 then
		local var1_86 = var0_86[math.random(#var0_86)]

		underscore.each(var0_86, function(arg0_87)
			if arg0_87.name == var1_86.name then
				arg0_87.muted = false
			end
		end)

		arg0_86.debugTrackName.text = var1_86.name
	else
		arg0_86.debugTrackName.text = "track cnt 0"
	end
end

function var0_0.OnPause(arg0_88)
	if arg0_88.ballTimer then
		arg0_88.ballTimer:Stop()
	end

	if arg0_88.playingDirector then
		arg0_88.playingDirector:Pause()
	end
end

function var0_0.OnResume(arg0_89)
	if arg0_89.ballTimer then
		arg0_89.ballTimer:Start()
	end

	if arg0_89.playingDirector then
		arg0_89.playingDirector:Play()
	end
end

function var0_0.onBackPressed(arg0_90)
	if not arg0_90.playingFlag or isActive(arg0_90.gameUI:Find("Count")) or isActive(arg0_90.endUI) then
		return
	end

	arg0_90:OnPause()
	pg.NewStyleMsgboxMgr.GetInstance():Show(pg.NewStyleMsgboxMgr.TYPE_MSGBOX, {
		contentText = i18n("sure_exit_volleyball"),
		onConfirm = function()
			arg0_90:emit(var0_0.ON_BACK)
		end,
		onClose = function()
			arg0_90:OnResume()
		end
	})
end

function var0_0.willExit(arg0_93)
	arg0_93.loader:Clear()

	if arg0_93.ballTimer then
		arg0_93.ballTimer:Stop()

		arg0_93.ballTimer = nil
	end

	local var0_93 = {
		{
			path = string.lower("dorm3d/character/" .. arg0_93.timelineSceneRootName .. "/timeline/" .. arg0_93.timelineSceneName .. "/" .. arg0_93.timelineSceneName .. "_scene"),
			name = arg0_93.timelineSceneName
		},
		{
			path = string.lower("dorm3d/scenesres/scenes/common/" .. arg0_93.sceneRootName .. "/" .. arg0_93.sceneName .. "_scene"),
			name = arg0_93.sceneName
		}
	}
	local var1_93 = underscore.map(var0_93, function(arg0_94)
		return function(arg0_95)
			SceneOpMgr.Inst:UnloadSceneAsync(arg0_94.path, arg0_94.name, arg0_95)
		end
	end)

	seriesAsync(var1_93, function()
		ReflectionHelp.RefSetProperty(typeof("UnityEngine.LightmapSettings"), "lightmaps", nil, nil)
	end)
end

return var0_0
