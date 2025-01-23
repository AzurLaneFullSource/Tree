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
			pg.UIMgr.GetInstance():LoadingOn(false)
			SceneOpMgr.Inst:LoadSceneAsync(string.lower("dorm3d/scenesres/scenes/" .. arg0_8.sceneRootName .. "/" .. arg0_8.sceneName .. "_scene"), arg0_8.sceneName, LoadSceneMode.Additive, function(arg0_10, arg1_10)
				arg0_8:InitGameParam()
				SceneManager.SetActiveScene(arg0_10)
				onNextTick(arg0_9)
			end)
		end,
		function(arg0_11)
			local var0_11 = arg0_8.timelineSceneRootName
			local var1_11 = arg0_8.timelineSceneName

			SceneOpMgr.Inst:LoadSceneAsync(string.lower("dorm3d/character/" .. var0_11 .. "/timeline/" .. var1_11 .. "/" .. var1_11 .. "_scene"), var1_11, LoadSceneMode.Additive, function(arg0_12, arg1_12)
				arg0_11()
			end)
		end,
		function(arg0_13)
			pg.UIMgr.GetInstance():LoadingOff()
			arg0_13()
		end,
		arg1_8
	})
end

function var0_0.InitGameParam(arg0_14)
	var0_0.BallSpeed = arg0_14.volleyballCfg.BallSpeedParam[1]
	var0_0.BallQTESpeed = arg0_14.volleyballCfg.BallSpeedParam[2]
	var0_0.endScore = arg0_14.volleyballCfg.endScore
end

function var0_0.init(arg0_15)
	arg0_15:initUI()
	arg0_15:initScene()
	arg0_15:BindEvent()
end

function var0_0.initUI(arg0_16)
	arg0_16.skipUI = arg0_16._tf:Find("SkipUI")

	setActive(arg0_16.skipUI, false)

	arg0_16.gameUI = arg0_16._tf:Find("GameUI")

	setText(arg0_16.gameUI:Find("Title/Text"), i18n("dorm3d_volleyball_title"))

	arg0_16.ourScoreTF = arg0_16.gameUI:Find("Score/Content/Left")
	arg0_16.otherScoreTF = arg0_16.gameUI:Find("Score/Content/Right")
	arg0_16.qteTF = arg0_16.gameUI:Find("QTE")
	arg0_16.qteTriggerTF = arg0_16.gameUI:Find("QTE/animroot/Trigger")

	setActive(arg0_16.qteTF, false)
	setActive(arg0_16.gameUI, false)

	arg0_16.scoreUI = arg0_16._tf:Find("ScoreUI")

	setActive(arg0_16.scoreUI, false)

	arg0_16.endUI = arg0_16._tf:Find("EndUI")

	setActive(arg0_16.endUI, false)

	arg0_16.resultUI = arg0_16._tf:Find("ResultUI")

	setActive(arg0_16.resultUI, false)
	setText(arg0_16.resultUI:Find("AgainBtn/Text"), i18n("dorm3d_minigame_again"))
	setText(arg0_16.resultUI:Find("CloseBtn/Text"), i18n("dorm3d_minigame_close"))

	local var0_16 = arg0_16._tf:Find("Debug")

	setActive(var0_16, false)

	arg0_16.debugTimelineName = var0_16:Find("Timeline"):GetComponent(typeof(Text))
	arg0_16.debugTrackName = var0_16:Find("Track"):GetComponent(typeof(Text))
end

function var0_0.BindEvent(arg0_17)
	onButton(arg0_17, arg0_17.gameUI:Find("Title/BackBtn"), function()
		arg0_17:onBackPressed()
	end, SFX_CANCEL)
	onButton(arg0_17, arg0_17.gameUI, function()
		if not arg0_17.startQTEUI then
			return
		end

		arg0_17:EndQTE()
	end)
	onButton(arg0_17, arg0_17.skipUI:Find("SkipBtn"), function()
		setActive(arg0_17.skipUI, false)
		arg0_17:StopPlayingTimeline()
		arg0_17:StartGame()
	end, SFX_PANEL)
	onButton(arg0_17, arg0_17.endUI, function()
		arg0_17:emit(Dorm3dGameMediatorTemplate.TRIGGER_FAVOR, arg0_17.apartment.configId)
	end, SFX_PANEL)
	onButton(arg0_17, arg0_17.resultUI:Find("AgainBtn"), function()
		setActive(arg0_17.resultUI, false)
		arg0_17:StartGame()
	end, SFX_PANEL)
	onButton(arg0_17, arg0_17.resultUI:Find("CloseBtn"), function()
		arg0_17:closeView()
	end, SFX_CANCEL)
end

function var0_0.initScene(arg0_24)
	local var0_24 = SceneManager.GetSceneByName(arg0_24.sceneName):GetRootGameObjects()

	table.IpairsCArray(var0_24, function(arg0_25, arg1_25)
		if arg1_25.name == "[MainBlock]" then
			arg0_24.modelRoot = tf(arg1_25):Find("[Model]/scene_root")
			arg0_24.ballTF = arg0_24.modelRoot:Find("fbx/litmap05/pre_db_sportinggoods03")
			arg0_24.ballTF.position = var0_0.BallInitPos

			setActive(arg0_24.ballTF, false)
		elseif arg1_25.name == "MainCamera" then
			arg0_24.mainCamera = arg1_25.transform

			setActive(arg0_24.mainCamera, false)
		elseif arg1_25.name == "PlayerCamera" then
			arg0_24.ballCamera = arg1_25.transform
			arg0_24.ballCameraComp = arg0_24.ballCamera:GetComponent(typeof(Camera))

			setActive(arg0_24.ballCamera, false)
		elseif arg1_25.name == "TriggerPlane" then
			setActive(arg1_25, false)

			local var0_25 = tf(arg1_25):Find("BallCreate")
			local var1_25 = var0_25:GetComponent(typeof(UnityEngine.MeshCollider)).sharedMesh

			arg0_24.ballCreatePlane = Plane.New(var1_25.normals[0], -Vector3.Dot(var0_25.position, var1_25.normals[0]))

			local var2_25 = tf(arg1_25):Find("BallQte")

			setLocalPosition(var2_25, Vector3(arg0_24.volleyballCfg.BallQtePlane[1][1], arg0_24.volleyballCfg.BallQtePlane[1][2], arg0_24.volleyballCfg.BallQtePlane[1][3]))
			setLocalEulerAngles(var2_25, Vector3(arg0_24.volleyballCfg.BallQtePlane[2][1], arg0_24.volleyballCfg.BallQtePlane[2][2], arg0_24.volleyballCfg.BallQtePlane[2][3]))

			local var3_25 = var2_25:GetComponent(typeof(UnityEngine.MeshCollider)).sharedMesh

			arg0_24.ballQtePlane = Plane.New(var3_25.normals[0], -Vector3.Dot(var2_25.position, var3_25.normals[0]))

			local var4_25 = tf(arg1_25):Find("BallMiss")

			setLocalPosition(var4_25, Vector3(arg0_24.volleyballCfg.BallMissPlane[1][1], arg0_24.volleyballCfg.BallMissPlane[1][2], arg0_24.volleyballCfg.BallMissPlane[1][3]))
			setLocalEulerAngles(var4_25, Vector3(arg0_24.volleyballCfg.BallMissPlane[2][1], arg0_24.volleyballCfg.BallMissPlane[2][2], arg0_24.volleyballCfg.BallMissPlane[2][3]))

			local var5_25 = var4_25:GetComponent(typeof(UnityEngine.MeshCollider)).sharedMesh

			arg0_24.ballMissPlane = Plane.New(var5_25.normals[0], -Vector3.Dot(var4_25.position, var5_25.normals[0]))
		end
	end)
	arg0_24:InitLightSettings()

	local var1_24 = SceneManager.GetSceneByName(arg0_24.timelineSceneName):GetRootGameObjects()

	arg0_24.totalDirectorList = {}

	table.IpairsCArray(var1_24, function(arg0_26, arg1_26)
		local var0_26 = tf(arg1_26):Find("[sequence]")

		if IsNil(var0_26) then
			return
		end

		local var1_26 = var0_26:GetComponent(typeof(UnityEngine.Playables.PlayableDirector))

		var1_26.playOnAwake = false

		local var2_26 = var0_26:GetComponentsInChildren(typeof(UnityEngine.Playables.PlayableDirector))

		for iter0_26 = 0, var2_26.Length - 1 do
			var2_26[iter0_26].playOnAwake = false
		end

		table.insert(arg0_24.totalDirectorList, {
			name = arg1_26.name,
			director = var1_26
		})
		setActive(arg1_26, false)
	end)
end

function var0_0.InitLightSettings(arg0_27)
	arg0_27.globalVolume = GameObject.Find("GlobalVolume")
	arg0_27.characterLight = GameObject.Find("CharacterLight")

	local var0_27 = GameObject.Find("[Lighting]").transform

	table.IpairsCArray(var0_27:GetComponentsInChildren(typeof(Light)), function(arg0_28, arg1_28)
		arg1_28.shadows = UnityEngine.LightShadows.None
	end)
end

function var0_0.didEnter(arg0_29)
	arg0_29:InitData()
	setActive(arg0_29.skipUI, true)
	arg0_29:PlayTimeline({
		name = arg0_29:GetWeightTimeline("jinchang")
	}, function()
		if not arg0_29.playingFlag then
			setActive(arg0_29.skipUI, false)
			arg0_29:StartGame()
		end
	end)
end

function var0_0.InitData(arg0_31)
	return
end

function var0_0.PlayTimeline(arg0_32, arg1_32, arg2_32)
	arg0_32:StopPlayingTimeline()

	local var0_32 = {}
	local var1_32 = arg1_32.name
	local var2_32 = arg1_32.track
	local var3_32 = _.detect(arg0_32.totalDirectorList, function(arg0_33)
		return arg0_33.name == var1_32
	end)

	assert(var3_32, "Missing director " .. var1_32)

	if not var3_32 then
		existCall(arg2_32)

		return
	end

	arg0_32.playingDirector = var3_32.director

	local var4_32 = arg0_32.playingDirector.transform

	arg0_32.debugTimelineName.text = var4_32.parent.name

	table.insert(var0_32, function(arg0_34)
		if arg1_32.time then
			arg0_32.playingDirector.time = math.clamp(arg1_32.time, 0, arg0_32.playingDirector.duration)
		end

		TimelineSupport.InitTimeline(arg0_32.playingDirector)

		local var0_34 = {}

		GetOrAddComponent(var4_32, "DftCommonSignalReceiver"):SetCommonEvent(function(arg0_35)
			switch(arg0_35.stringParameter, {
				TimelineRandomTrack = function()
					arg0_32:DoTimelineRandomTrack(arg0_32.playingDirector)
				end,
				TimelineLoop = function()
					arg0_32.playingDirector.time = arg0_35.floatParameter
				end,
				TimelineEnd = function()
					var0_34.finish = true

					arg0_32.playingDirector:Stop()
					setActive(tf(arg0_32.playingDirector).parent, false)
				end
			}, function()
				warning("other event trigger:" .. arg0_35.stringParameter)
			end)

			if var0_34.finish then
				arg0_32.timelineMark = var0_34
				arg0_32.debugTimelineName.text = ""
				arg0_32.debugTrackName.text = ""

				arg0_34()
			end
		end)
		arg0_32.playingDirector:Evaluate()
		arg0_32:DoTimelineRandomTrack(arg0_32.playingDirector)
		setActive(tf(arg0_32.playingDirector).parent, true)
		arg0_32.playingDirector:Play()
		setActive(arg0_32.mainCamera, false)

		if arg0_32.activeDirectorInfo then
			arg0_32.lastDirectorInfo = arg0_32.activeDirectorInfo
		end

		arg0_32.activeDirectorInfo = var3_32
	end)
	seriesAsync(var0_32, function()
		setActive(arg0_32.mainCamera, true)

		arg0_32.playingDirector = nil

		local var0_40 = arg0_32.timelineMark

		arg0_32.timelineMark = nil

		existCall(arg2_32, var0_40)
	end)
end

function var0_0.StopPlayingTimeline(arg0_41)
	if arg0_41.playingDirector then
		arg0_41.playingDirector:Stop()
		setActive(tf(arg0_41.playingDirector).parent, false)

		arg0_41.debugTimelineName.text = ""
		arg0_41.debugTrackName.text = ""

		setActive(arg0_41.mainCamera, true)
	end
end

function var0_0.StartGame(arg0_42)
	setActive(arg0_42.mainCamera, true)

	arg0_42.playingFlag = true
	arg0_42.gameResult = nil
	arg0_42.ourScore, arg0_42.otherScore = 0, 0

	setActive(arg0_42.gameUI, true)
	setActive(arg0_42.gameUI:Find("Score"), false)

	local var0_42 = arg0_42.gameUI:Find("Count")

	setActive(var0_42, true)

	local var1_42 = var0_42:GetComponent(typeof(DftAniEvent))

	var1_42:SetEndEvent(function()
		setActive(var0_42, false)
		arg0_42:StartOneRound()
		setActive(arg0_42.gameUI:Find("Score"), true)
		var1_42:SetEndEvent(nil)
	end)
	pg.CriMgr.GetInstance():PlaySE_V3(var1_0)
end

function var0_0.UpdateGameScore(arg0_44)
	setText(arg0_44.ourScoreTF, arg0_44.ourScore)
	setText(arg0_44.otherScoreTF, arg0_44.otherScore)
end

function var0_0.UpdateScoreTpl(arg0_45, arg1_45)
	setText(arg1_45:Find("Left/Tens/Text"), 0)
	setText(arg1_45:Find("Left/Units/Text"), arg0_45.ourScore % 10)
	setText(arg1_45:Find("Right/Tens/Text"), 0)
	setText(arg1_45:Find("Right/Units/Text"), arg0_45.otherScore % 10)
end

function var0_0.StartOneRound(arg0_46)
	arg0_46:UpdateGameScore()

	arg0_46.roundEndFlag = false
	arg0_46.roundResult = nil

	seriesAsync({
		function(arg0_47)
			arg0_46:FaQiuOP(arg0_47)
		end,
		function(arg0_48)
			arg0_46:OneQTE()
		end
	})
end

function var0_0.OneQTE(arg0_49)
	seriesAsync({
		function(arg0_50)
			arg0_49:StartQTE(arg0_50)
		end,
		function(arg0_51)
			switch(arg0_49.qteResult, {
				[var0_0.QTE_RESULT.MISS] = function()
					arg0_49:QteMissOP(function()
						arg0_49.roundEndFlag = true
						arg0_49.roundResult = var0_0.ROUND_RESULT.OTHER_WIN

						arg0_51()
					end)
				end,
				[var0_0.QTE_RESULT.HIT] = function()
					arg0_49:QteHitOP(arg0_51)
				end,
				[var0_0.QTE_RESULT.PERFECT] = function()
					arg0_49:QtePerfectOP(function()
						arg0_49.roundEndFlag = true
						arg0_49.roundResult = var0_0.ROUND_RESULT.OUR_WIN

						arg0_51()
					end)
				end
			}, function()
				assert(false, "unknow qte result" .. arg0_49.qteResult)
			end)
		end
	}, function()
		if not arg0_49.roundEndFlag then
			arg0_49:OneQTE()
		else
			arg0_49:EndOneRound()
		end
	end)
end

function var0_0.EndOneRound(arg0_59)
	pg.CriMgr.GetInstance():PlaySE_V3(var6_0)

	local var0_59 = arg0_59.scoreUI:GetComponent(typeof(DftAniEvent))

	var0_59:SetEndEvent(function()
		quickPlayAnimation(arg0_59.scoreUI, "Anim_Dorm3d_volleyball_score_out")
		onDelayTick(function()
			setActive(arg0_59.scoreUI, false)
		end, 0.1)

		if arg0_59:CheckEndGame() then
			arg0_59:EndGame()
		else
			setActive(arg0_59.gameUI, true)
			arg0_59:StartOneRound()
		end

		var0_59:SetEndEvent(nil)
	end)
	setActive(arg0_59.gameUI, false)
	arg0_59:UpdateScoreTpl(arg0_59.scoreUI:Find("ScoreTpl"))
	setText(arg0_59.scoreUI:Find("ScoreTpl/Left/Units/new/newText"), arg0_59.ourScore % 10)
	setText(arg0_59.scoreUI:Find("ScoreTpl/Right/Units/new/newText"), arg0_59.otherScore % 10)
	switch(arg0_59.roundResult, {
		[var0_0.ROUND_RESULT.OUR_WIN] = function()
			arg0_59.ourScore = arg0_59.ourScore + 1

			setText(arg0_59.scoreUI:Find("ScoreTpl/Left/Units/new/newText"), arg0_59.ourScore % 10)
			setActive(arg0_59.scoreUI, true)
			quickPlayAnimation(arg0_59.scoreUI, "Anim_Dorm3d_volleyball_score_leftin")
		end,
		[var0_0.ROUND_RESULT.OTHER_WIN] = function()
			arg0_59.otherScore = arg0_59.otherScore + 1

			setText(arg0_59.scoreUI:Find("ScoreTpl/Right/Units/new/newText"), arg0_59.otherScore % 10)
			setActive(arg0_59.scoreUI, true)
			quickPlayAnimation(arg0_59.scoreUI, "Anim_Dorm3d_volleyball_score_rightin")
		end
	}, function()
		assert(false, "unknow round result" .. arg0_59.roundResult)
	end)
end

function var0_0.CheckEndGame(arg0_65)
	if arg0_65.ourScore >= var0_0.endScore then
		arg0_65.gameResult = var0_0.GAME_RESULT.VICTORY

		return true
	end

	if arg0_65.otherScore >= var0_0.endScore then
		arg0_65.gameResult = var0_0.GAME_RESULT.DEFEAT

		return true
	end

	return false
end

function var0_0.EndGame(arg0_66)
	if arg0_66.gameResult == var0_0.GAME_RESULT.VICTORY then
		pg.CriMgr.GetInstance():PlaySE_V3(var7_0)
	end

	seriesAsync({
		function(arg0_67)
			local var0_67 = arg0_66.gameResult == var0_0.GAME_RESULT.VICTORY and "shibai" or "shengli"

			arg0_66:PlayTimeline({
				name = arg0_66:GetWeightTimeline(var0_67)
			}, arg0_67)
		end
	}, function()
		arg0_66:PlayTimeline({
			name = arg0_66:GetWeightTimeline("daiji")
		}, function()
			return
		end)
		setActive(arg0_66.endUI, true)
		setActive(arg0_66.endUI:Find("Title/Victory"), arg0_66.gameResult == var0_0.GAME_RESULT.VICTORY)
		setActive(arg0_66.endUI:Find("Title/Defeat"), arg0_66.gameResult == var0_0.GAME_RESULT.DEFEAT)
		arg0_66:UpdateScoreTpl(arg0_66.endUI:Find("ScoreTpl"))
	end)
end

function var0_0.ShowResultUI(arg0_70, arg1_70)
	(function()
		local var0_71 = arg0_70.contextData.roomId
		local var1_71 = arg0_70.contextData.groupId
		local var2_71 = arg0_70.contextData.groupIds or {
			var1_71
		}
		local var3_71 = table.concat(var2_71, ",")
		local var4_71 = arg0_70.ourScore .. ":" .. arg0_70.otherScore

		pg.m02:sendNotification(GAME.APARTMENT_TRACK, Dorm3dTrackCommand.BuildDataRoom(var0_71, 8, var3_71, var4_71))
	end)()
	pg.CriMgr.GetInstance():PlaySE_V3(var8_0)
	seriesAsync({
		function(arg0_72)
			quickPlayAnimation(arg0_70.endUI, "Anim_Dorm3d_volleyball_end_out")
			onDelayTick(function()
				setActive(arg0_70.endUI, false)
			end, 0.1)

			if arg0_70.gameResult == var0_0.GAME_RESULT.VICTORY then
				arg0_70:PlayTimeline({
					name = arg0_70:GetWeightTimeline("jiangli")
				}, arg0_72)
			else
				arg0_70:StopPlayingTimeline()
				arg0_72()
			end
		end
	}, function()
		gcAll(true)
		setActive(arg0_70.resultUI, true)

		local var0_74

		var0_74 = arg0_70.gameResult == var0_0.GAME_RESULT.VICTORY and "Victory" or "Defeat"

		setText(arg0_70.resultUI:Find("Panel/Text"), i18n("volleyball_end_tip", arg0_70.apartment:getConfig("name")))

		if arg1_70 and arg1_70.cost > 0 then
			setActive(arg0_70.resultUI:Find("Panel/Award"), true)
			setText(arg0_70.resultUI:Find("Panel/Award/Text"), i18n("volleyball_end_award", arg0_70.apartment:getConfig("name")))
		else
			setActive(arg0_70.resultUI:Find("Panel/Award"), false)
		end
	end)
end

function var0_0.FaQiuOP(arg0_75, arg1_75)
	arg0_75:PlayTimeline({
		name = arg0_75:GetWeightTimeline("faqiu")
	}, arg1_75)
end

function var0_0.StartQTE(arg0_76, arg1_76)
	arg0_76.qteCallback = arg1_76

	setActive(arg0_76.ballCamera, true)
	setActive(arg0_76.mainCamera, false)

	arg0_76.randomScreenPos = Vector2(math.random(var0_0.BallRandomDelat.Left, Screen.width - var0_0.BallRandomDelat.Right), math.random(var0_0.BallRandomDelat.Bottom, Screen.height - var0_0.BallRandomDelat.Top))

	local var0_76 = arg0_76.ballCameraComp:ScreenPointToRay(arg0_76.randomScreenPos)

	arg0_76.randomScale = math.random(var0_0.perfectScaleRandoms[1] * 10, arg0_76.perfectScaleRandoms[2] * 10) / 10

	local var1_76 = (var0_0.perfectRadiusMax + var0_0.perfectRadiusMin) / 2 * arg0_76.randomScale / var0_0.triggerRadius
	local var2_76 = arg0_76.ballQtePlane.distance + (arg0_76.ballMissPlane.distance - arg0_76.ballQtePlane.distance) * (1 - var1_76)
	local var3_76, var4_76 = Plane.New(arg0_76.ballQtePlane.normal, var2_76):Raycast(var0_76)

	assert(var3_76, "retPerfect plane not in view")

	arg0_76.ballDir = (var0_76:GetPoint(var4_76) - var0_0.BallInitPos):Normalize()

	local var5_76 = Ray.New(arg0_76.ballDir, var0_0.BallInitPos)
	local var6_76, var7_76 = arg0_76.ballQtePlane:Raycast(var5_76)

	assert(var6_76, "qte plane not in view")

	local var8_76 = var5_76:GetPoint(var7_76)
	local var9_76, var10_76 = arg0_76.ballMissPlane:Raycast(var5_76)

	assert(var9_76, "miss plane not in view")

	local var11_76 = var5_76:GetPoint(var10_76)
	local var12_76 = 0

	arg0_76.qteUITime = (var8_76 - var11_76):Magnitude() / var0_0.BallQTESpeed
	arg0_76.ballTimer = Timer.New(function()
		if var12_76 >= var10_76 then
			arg0_76.ballTimer:Stop()

			arg0_76.ballTimer = nil

			setActive(arg0_76.ballTF, false)

			arg0_76.ballTF.position = var0_0.BallInitPos

			if arg0_76.startQTEUI then
				setLocalScale(arg0_76.qteTriggerTF, {
					x = 0,
					y = 0
				})
				arg0_76:EndQTE(var0_0.QTE_RESULT.MISS)
			end
		elseif var12_76 >= var7_76 then
			var12_76 = var12_76 + var0_0.BallQTESpeed
			arg0_76.ballTF.position = var5_76:GetPoint(var12_76)

			if not arg0_76.startQTEUI then
				arg0_76:StartQTEUI()
			end

			arg0_76.curScale = arg0_76.curScale - 1 / arg0_76.qteUITime

			setLocalScale(arg0_76.qteTriggerTF, {
				x = arg0_76.curScale,
				y = arg0_76.curScale
			})

			arg0_76.curRadius = var0_0.triggerRadius * arg0_76.curScale

			if arg0_76.curScale < 0 then
				arg0_76:EndQTE()
			end
		else
			var12_76 = var12_76 + var0_0.BallSpeed
			arg0_76.ballTF.position = var5_76:GetPoint(var12_76)
		end
	end, 0.0166666666666667, -1)

	setActive(arg0_76.ballTF, true)
	arg0_76.ballTimer:Start()
end

function var0_0.StartQTEUI(arg0_78)
	pg.CriMgr.GetInstance():PlaySE_V3(var2_0)
	setLocalScale(arg0_78.qteTriggerTF, {
		x = 1,
		y = 1
	})
	eachChild(arg0_78.qteTF:Find("animroot/Result"), function(arg0_79)
		setActive(arg0_79, false)
	end)

	arg0_78.qteResult = nil
	arg0_78.curRadius = var0_0.triggerRadius
	arg0_78.curPerfectRadiusMax = var0_0.perfectRadiusMax * arg0_78.randomScale
	arg0_78.curPerfectRadiusMin = var0_0.perfectRadiusMin * arg0_78.randomScale

	setLocalScale(arg0_78.qteTF:Find("animroot/Perfect"), {
		x = arg0_78.randomScale,
		y = arg0_78.randomScale
	})

	arg0_78.curScale = 1

	setLocalPosition(arg0_78.qteTF, LuaHelper.ScreenToLocal(arg0_78.qteTF.parent, arg0_78.randomScreenPos, pg.UIMgr.GetInstance().uiCameraComp))
	setActive(arg0_78.qteTF, true)

	arg0_78.startQTEUI = true
end

function var0_0.EndQTE(arg0_80, arg1_80)
	arg0_80.startQTEUI = nil

	setActive(arg0_80.mainCamera, true)
	setActive(arg0_80.ballCamera, false)

	if arg1_80 then
		arg0_80.qteResult = arg1_80
	elseif arg0_80.curRadius < var0_0.hitRadiusMin or arg0_80.curRadius > var0_0.hitRadiusMax then
		arg0_80.qteResult = var0_0.QTE_RESULT.MISS
	elseif arg0_80.curRadius <= arg0_80.curPerfectRadiusMax and arg0_80.curRadius >= arg0_80.curPerfectRadiusMin then
		arg0_80.qteResult = var0_0.QTE_RESULT.PERFECT
	else
		arg0_80.qteResult = var0_0.QTE_RESULT.HIT
	end

	eachChild(arg0_80.qteTF:Find("animroot/Result"), function(arg0_81)
		setActive(arg0_81, arg0_81.name == arg0_80.qteResult)
	end)

	if arg0_80.ballTimer then
		arg0_80.ballTimer:Stop()

		arg0_80.ballTimer = nil

		setActive(arg0_80.ballTF, false)

		arg0_80.ballTF.position = var0_0.BallInitPos
	end

	if arg0_80.qteCallback then
		arg0_80.qteCallback()

		arg0_80.qteCallback = nil
	end

	onDelayTick(function()
		setActive(arg0_80.qteTF, false)
	end, 1)
end

function var0_0.QteMissOP(arg0_83, arg1_83)
	pg.CriMgr.GetInstance():PlaySE_V3(var5_0)
	arg0_83:PlayTimeline({
		name = arg0_83:GetWeightTimeline("shiqiu")
	}, arg1_83)
end

function var0_0.QteHitOP(arg0_84, arg1_84)
	pg.CriMgr.GetInstance():PlaySE_V3(var3_0)
	seriesAsync({
		function(arg0_85)
			arg0_84:PlayTimeline({
				name = arg0_84:GetWeightTimeline("fly")
			}, arg0_85)
		end,
		function(arg0_86)
			arg0_84:PlayTimeline({
				name = arg0_84:GetWeightTimeline("jieqiu")
			}, arg0_86)
		end
	}, arg1_84)
end

function var0_0.QtePerfectOP(arg0_87, arg1_87)
	pg.CriMgr.GetInstance():PlaySE_V3(var4_0)
	seriesAsync({
		function(arg0_88)
			arg0_87:PlayTimeline({
				name = arg0_87:GetWeightTimeline("max_fly")
			}, arg0_88)
		end,
		function(arg0_89)
			arg0_87:PlayTimeline({
				name = arg0_87:GetWeightTimeline("shouji")
			}, arg0_89)
		end
	}, arg1_87)
end

function var0_0.GetWeightTimeline(arg0_90, arg1_90)
	local var0_90 = arg0_90.volleyballCfg[arg1_90]

	assert(var0_90 ~= "", "volleyball cfg is empty string" .. arg1_90)
	assert(#var0_90 ~= 0, "volleyball cfg is empty table:" .. arg1_90)

	local var1_90 = underscore.reduce(var0_90, 0, function(arg0_91, arg1_91)
		return arg0_91 + arg1_91[2]
	end)
	local var2_90 = math.random() * var1_90
	local var3_90 = 0

	for iter0_90, iter1_90 in ipairs(var0_90) do
		var3_90 = var3_90 + iter1_90[2]

		if var2_90 <= var3_90 then
			return iter1_90[1]
		end
	end
end

function var0_0.DoTimelineRandomTrack(arg0_92, arg1_92)
	local var0_92 = {}
	local var1_92 = TimelineHelper.GetTimelineTracks(arg1_92)

	for iter0_92 = 0, var1_92.Length - 1 do
		local var2_92 = var1_92[iter0_92]

		if var2_92.name ~= "Markers" then
			var2_92.muted = true

			table.insert(var0_92, var2_92)
		end
	end

	if #var0_92 > 0 then
		local var3_92 = var0_92[math.random(#var0_92)]

		underscore.each(var0_92, function(arg0_93)
			if arg0_93.name == var3_92.name then
				arg0_93.muted = false
			end
		end)

		arg0_92.debugTrackName.text = var3_92.name
	else
		arg0_92.debugTrackName.text = "track cnt 0"
	end
end

function var0_0.OnPause(arg0_94)
	if arg0_94.ballTimer then
		arg0_94.ballTimer:Stop()
	end

	if arg0_94.playingDirector then
		arg0_94.playingDirector:Pause()
	end
end

function var0_0.OnResume(arg0_95)
	if arg0_95.ballTimer then
		arg0_95.ballTimer:Start()
	end

	if arg0_95.playingDirector then
		arg0_95.playingDirector:Play()
	end
end

function var0_0.onBackPressed(arg0_96)
	if not arg0_96.playingFlag or isActive(arg0_96.gameUI:Find("Count")) or isActive(arg0_96.endUI) then
		return
	end

	arg0_96:OnPause()
	pg.NewStyleMsgboxMgr.GetInstance():Show(pg.NewStyleMsgboxMgr.TYPE_MSGBOX, {
		contentText = i18n("sure_exit_volleyball"),
		onConfirm = function()
			arg0_96:emit(var0_0.ON_BACK)
		end,
		onClose = function()
			arg0_96:OnResume()
		end
	})
end

function var0_0.willExit(arg0_99)
	arg0_99.loader:Clear()

	if arg0_99.ballTimer then
		arg0_99.ballTimer:Stop()

		arg0_99.ballTimer = nil
	end

	local var0_99 = {
		{
			path = string.lower("dorm3d/character/" .. arg0_99.timelineSceneRootName .. "/timeline/" .. arg0_99.timelineSceneName .. "/" .. arg0_99.timelineSceneName .. "_scene"),
			name = arg0_99.timelineSceneName
		},
		{
			path = string.lower("dorm3d/scenesres/scenes/common/" .. arg0_99.sceneRootName .. "/" .. arg0_99.sceneName .. "_scene"),
			name = arg0_99.sceneName
		}
	}
	local var1_99 = underscore.map(var0_99, function(arg0_100)
		return function(arg0_101)
			SceneOpMgr.Inst:UnloadSceneAsync(arg0_100.path, arg0_100.name, arg0_101)
		end
	end)

	seriesAsync(var1_99, function()
		ReflectionHelp.RefSetProperty(typeof("UnityEngine.LightmapSettings"), "lightmaps", nil, nil)
	end)
end

return var0_0
