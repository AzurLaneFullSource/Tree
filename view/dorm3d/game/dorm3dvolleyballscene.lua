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
	local var0_8 = arg0_8.contextData.groupId or 20220

	arg0_8:SetApartment(getProxy(ApartmentProxy):getApartment(var0_8))

	arg0_8.volleyballCfg = pg.dorm3d_volleyball[var0_8]
	arg0_8.sceneRootName = "beach"
	arg0_8.sceneName = "map_beach_01"
	arg0_8.timelineSceneRootName = pg.dorm3d_dorm_template[var0_8].asset_name
	arg0_8.timelineSceneName = arg0_8.volleyballCfg.scene_name

	seriesAsync({
		function(arg0_9)
			pg.UIMgr.GetInstance():LoadingOn(false)
			SceneOpMgr.Inst:LoadSceneAsync(string.lower("dorm3d/scenesres/scenes/common/" .. arg0_8.sceneRootName .. "/" .. arg0_8.sceneName .. "_scene"), arg0_8.sceneName, LoadSceneMode.Additive, function(arg0_10, arg1_10)
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

	arg0_15.scoreUI = arg0_15._tf:Find("ScoreUI")

	setActive(arg0_15.scoreUI, false)

	arg0_15.endUI = arg0_15._tf:Find("EndUI")

	setActive(arg0_15.endUI, false)

	arg0_15.resultUI = arg0_15._tf:Find("ResultUI")

	setActive(arg0_15.resultUI, false)
	setText(arg0_15.resultUI:Find("AgainBtn/Text"), i18n("dorm3d_minigame_again"))
	setText(arg0_15.resultUI:Find("CloseBtn/Text"), i18n("dorm3d_minigame_close"))

	local var0_15 = arg0_15._tf:Find("Debug")

	setActive(var0_15, false)

	arg0_15.debugTimelineName = var0_15:Find("Timeline"):GetComponent(typeof(Text))
	arg0_15.debugTrackName = var0_15:Find("Track"):GetComponent(typeof(Text))
end

function var0_0.BindEvent(arg0_16)
	onButton(arg0_16, arg0_16.gameUI:Find("Title/BackBtn"), function()
		arg0_16:onBackPressed()
	end, SFX_CANCEL)
	onButton(arg0_16, arg0_16.gameUI, function()
		if not arg0_16.startQTEUI then
			return
		end

		arg0_16:EndQTE()
	end)
	onButton(arg0_16, arg0_16.skipUI:Find("SkipBtn"), function()
		setActive(arg0_16.skipUI, false)
		arg0_16:StopPlayingTimeline()
		arg0_16:StartGame()
	end, SFX_PANEL)
	onButton(arg0_16, arg0_16.endUI, function()
		arg0_16:emit(Dorm3dGameMediatorTemplate.TRIGGER_FAVOR, arg0_16.apartment.configId)
	end, SFX_PANEL)
	onButton(arg0_16, arg0_16.resultUI:Find("AgainBtn"), function()
		setActive(arg0_16.resultUI, false)
		arg0_16:StartGame()
	end, SFX_PANEL)
	onButton(arg0_16, arg0_16.resultUI:Find("CloseBtn"), function()
		arg0_16:closeView()
	end, SFX_CANCEL)
end

function var0_0.initScene(arg0_23)
	local var0_23 = SceneManager.GetSceneByName(arg0_23.sceneName):GetRootGameObjects()

	table.IpairsCArray(var0_23, function(arg0_24, arg1_24)
		if arg1_24.name == "[MainBlock]" then
			arg0_23.modelRoot = tf(arg1_24):Find("[Model]/scene_root")
			arg0_23.ballTF = arg0_23.modelRoot:Find("fbx/litmap05/pre_db_sportinggoods03")
			arg0_23.ballTF.position = var0_0.BallInitPos

			setActive(arg0_23.ballTF, false)
		elseif arg1_24.name == "MainCamera" then
			arg0_23.mainCamera = arg1_24.transform

			setActive(arg0_23.mainCamera, false)
		elseif arg1_24.name == "PlayerCamera" then
			arg0_23.ballCamera = arg1_24.transform
			arg0_23.ballCameraComp = arg0_23.ballCamera:GetComponent(typeof(Camera))

			setActive(arg0_23.ballCamera, false)
		elseif arg1_24.name == "TriggerPlane" then
			setActive(arg1_24, false)

			local var0_24 = tf(arg1_24):Find("BallCreate")
			local var1_24 = var0_24:GetComponent(typeof(UnityEngine.MeshCollider)).sharedMesh

			arg0_23.ballCreatePlane = Plane.New(var1_24.normals[0], -Vector3.Dot(var0_24.position, var1_24.normals[0]))

			local var2_24 = tf(arg1_24):Find("BallQte")
			local var3_24 = var2_24:GetComponent(typeof(UnityEngine.MeshCollider)).sharedMesh

			arg0_23.ballQtePlane = Plane.New(var3_24.normals[0], -Vector3.Dot(var2_24.position, var3_24.normals[0]))

			local var4_24 = tf(arg1_24):Find("BallMiss")
			local var5_24 = var4_24:GetComponent(typeof(UnityEngine.MeshCollider)).sharedMesh

			arg0_23.ballMissPlane = Plane.New(var5_24.normals[0], -Vector3.Dot(var4_24.position, var5_24.normals[0]))
		end
	end)
	arg0_23:InitLightSettings()

	local var1_23 = SceneManager.GetSceneByName(arg0_23.timelineSceneName):GetRootGameObjects()

	arg0_23.totalDirectorList = {}

	table.IpairsCArray(var1_23, function(arg0_25, arg1_25)
		local var0_25 = tf(arg1_25):Find("[sequence]")

		if IsNil(var0_25) then
			return
		end

		local var1_25 = var0_25:GetComponent(typeof(UnityEngine.Playables.PlayableDirector))

		var1_25.playOnAwake = false

		local var2_25 = var0_25:GetComponentsInChildren(typeof(UnityEngine.Playables.PlayableDirector))

		for iter0_25 = 0, var2_25.Length - 1 do
			var2_25[iter0_25].playOnAwake = false
		end

		table.insert(arg0_23.totalDirectorList, {
			name = arg1_25.name,
			director = var1_25
		})
		setActive(arg1_25, false)
	end)
end

function var0_0.InitLightSettings(arg0_26)
	arg0_26.globalVolume = GameObject.Find("GlobalVolume")
	arg0_26.characterLight = GameObject.Find("CharacterLight")

	local var0_26 = GameObject.Find("[Lighting]").transform

	table.IpairsCArray(var0_26:GetComponentsInChildren(typeof(Light)), function(arg0_27, arg1_27)
		arg1_27.shadows = UnityEngine.LightShadows.None
	end)
end

function var0_0.didEnter(arg0_28)
	arg0_28:InitData()
	setActive(arg0_28.skipUI, true)
	arg0_28:PlayTimeline({
		name = arg0_28:GetWeightTimeline("jinchang")
	}, function()
		if not arg0_28.playingFlag then
			setActive(arg0_28.skipUI, false)
			arg0_28:StartGame()
		end
	end)
end

function var0_0.InitData(arg0_30)
	return
end

function var0_0.PlayTimeline(arg0_31, arg1_31, arg2_31)
	arg0_31:StopPlayingTimeline()

	local var0_31 = {}
	local var1_31 = arg1_31.name
	local var2_31 = arg1_31.track
	local var3_31 = _.detect(arg0_31.totalDirectorList, function(arg0_32)
		return arg0_32.name == var1_31
	end)

	assert(var3_31, "Missing director " .. var1_31)

	if not var3_31 then
		existCall(arg2_31)

		return
	end

	arg0_31.playingDirector = var3_31.director

	local var4_31 = arg0_31.playingDirector.transform

	arg0_31.debugTimelineName.text = var4_31.parent.name

	table.insert(var0_31, function(arg0_33)
		if arg1_31.time then
			arg0_31.playingDirector.time = math.clamp(arg1_31.time, 0, arg0_31.playingDirector.duration)
		end

		TimelineSupport.InitTimeline(arg0_31.playingDirector)

		local var0_33 = {}

		GetOrAddComponent(var4_31, "DftCommonSignalReceiver"):SetCommonEvent(function(arg0_34)
			switch(arg0_34.stringParameter, {
				TimelineRandomTrack = function()
					arg0_31:DoTimelineRandomTrack(arg0_31.playingDirector)
				end,
				TimelineLoop = function()
					arg0_31.playingDirector.time = arg0_34.floatParameter
				end,
				TimelineEnd = function()
					var0_33.finish = true

					arg0_31.playingDirector:Stop()
					setActive(tf(arg0_31.playingDirector).parent, false)
				end
			}, function()
				warning("other event trigger:" .. arg0_34.stringParameter)
			end)

			if var0_33.finish then
				arg0_31.timelineMark = var0_33
				arg0_31.debugTimelineName.text = ""
				arg0_31.debugTrackName.text = ""

				arg0_33()
			end
		end)
		arg0_31.playingDirector:Evaluate()
		arg0_31:DoTimelineRandomTrack(arg0_31.playingDirector)
		setActive(tf(arg0_31.playingDirector).parent, true)
		arg0_31.playingDirector:Play()
		setActive(arg0_31.mainCamera, false)

		if arg0_31.activeDirectorInfo then
			arg0_31.lastDirectorInfo = arg0_31.activeDirectorInfo
		end

		arg0_31.activeDirectorInfo = var3_31
	end)
	seriesAsync(var0_31, function()
		setActive(arg0_31.mainCamera, true)

		arg0_31.playingDirector = nil

		local var0_39 = arg0_31.timelineMark

		arg0_31.timelineMark = nil

		existCall(arg2_31, var0_39)
	end)
end

function var0_0.StopPlayingTimeline(arg0_40)
	if arg0_40.playingDirector then
		arg0_40.playingDirector:Stop()
		setActive(tf(arg0_40.playingDirector).parent, false)

		arg0_40.debugTimelineName.text = ""
		arg0_40.debugTrackName.text = ""

		setActive(arg0_40.mainCamera, true)
	end
end

function var0_0.StartGame(arg0_41)
	setActive(arg0_41.mainCamera, true)

	arg0_41.playingFlag = true
	arg0_41.gameResult = nil
	arg0_41.ourScore, arg0_41.otherScore = 0, 0

	setActive(arg0_41.gameUI, true)
	setActive(arg0_41.gameUI:Find("Score"), false)

	local var0_41 = arg0_41.gameUI:Find("Count")

	setActive(var0_41, true)

	local var1_41 = var0_41:GetComponent(typeof(DftAniEvent))

	var1_41:SetEndEvent(function()
		setActive(var0_41, false)
		arg0_41:StartOneRound()
		setActive(arg0_41.gameUI:Find("Score"), true)
		var1_41:SetEndEvent(nil)
	end)
	pg.CriMgr.GetInstance():PlaySE_V3(var1_0)
end

function var0_0.UpdateGameScore(arg0_43)
	setText(arg0_43.ourScoreTF, arg0_43.ourScore)
	setText(arg0_43.otherScoreTF, arg0_43.otherScore)
end

function var0_0.UpdateScoreTpl(arg0_44, arg1_44)
	setText(arg1_44:Find("Left/Tens/Text"), 0)
	setText(arg1_44:Find("Left/Units/Text"), arg0_44.ourScore % 10)
	setText(arg1_44:Find("Right/Tens/Text"), 0)
	setText(arg1_44:Find("Right/Units/Text"), arg0_44.otherScore % 10)
end

function var0_0.StartOneRound(arg0_45)
	arg0_45:UpdateGameScore()

	arg0_45.roundEndFlag = false
	arg0_45.roundResult = nil

	seriesAsync({
		function(arg0_46)
			arg0_45:FaQiuOP(arg0_46)
		end,
		function(arg0_47)
			arg0_45:OneQTE()
		end
	})
end

function var0_0.OneQTE(arg0_48)
	seriesAsync({
		function(arg0_49)
			arg0_48:StartQTE(arg0_49)
		end,
		function(arg0_50)
			switch(arg0_48.qteResult, {
				[var0_0.QTE_RESULT.MISS] = function()
					arg0_48:QteMissOP(function()
						arg0_48.roundEndFlag = true
						arg0_48.roundResult = var0_0.ROUND_RESULT.OTHER_WIN

						arg0_50()
					end)
				end,
				[var0_0.QTE_RESULT.HIT] = function()
					arg0_48:QteHitOP(arg0_50)
				end,
				[var0_0.QTE_RESULT.PERFECT] = function()
					arg0_48:QtePerfectOP(function()
						arg0_48.roundEndFlag = true
						arg0_48.roundResult = var0_0.ROUND_RESULT.OUR_WIN

						arg0_50()
					end)
				end
			}, function()
				assert(false, "unknow qte result" .. arg0_48.qteResult)
			end)
		end
	}, function()
		if not arg0_48.roundEndFlag then
			arg0_48:OneQTE()
		else
			arg0_48:EndOneRound()
		end
	end)
end

function var0_0.EndOneRound(arg0_58)
	pg.CriMgr.GetInstance():PlaySE_V3(var6_0)

	local var0_58 = arg0_58.scoreUI:GetComponent(typeof(DftAniEvent))

	var0_58:SetEndEvent(function()
		quickPlayAnimation(arg0_58.scoreUI, "Anim_Dorm3d_volleyball_score_out")
		onDelayTick(function()
			setActive(arg0_58.scoreUI, false)
		end, 0.1)

		if arg0_58:CheckEndGame() then
			arg0_58:EndGame()
		else
			setActive(arg0_58.gameUI, true)
			arg0_58:StartOneRound()
		end

		var0_58:SetEndEvent(nil)
	end)
	setActive(arg0_58.gameUI, false)
	arg0_58:UpdateScoreTpl(arg0_58.scoreUI:Find("ScoreTpl"))
	setText(arg0_58.scoreUI:Find("ScoreTpl/Left/Units/new/newText"), arg0_58.ourScore % 10)
	setText(arg0_58.scoreUI:Find("ScoreTpl/Right/Units/new/newText"), arg0_58.otherScore % 10)
	switch(arg0_58.roundResult, {
		[var0_0.ROUND_RESULT.OUR_WIN] = function()
			arg0_58.ourScore = arg0_58.ourScore + 1

			setText(arg0_58.scoreUI:Find("ScoreTpl/Left/Units/new/newText"), arg0_58.ourScore % 10)
			setActive(arg0_58.scoreUI, true)
			quickPlayAnimation(arg0_58.scoreUI, "Anim_Dorm3d_volleyball_score_leftin")
		end,
		[var0_0.ROUND_RESULT.OTHER_WIN] = function()
			arg0_58.otherScore = arg0_58.otherScore + 1

			setText(arg0_58.scoreUI:Find("ScoreTpl/Right/Units/new/newText"), arg0_58.otherScore % 10)
			setActive(arg0_58.scoreUI, true)
			quickPlayAnimation(arg0_58.scoreUI, "Anim_Dorm3d_volleyball_score_rightin")
		end
	}, function()
		assert(false, "unknow round result" .. arg0_58.roundResult)
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
		local var1_70 = arg0_69.contextData.groupId or 20220
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
		gcAll(true)
		setActive(arg0_69.resultUI, true)

		local var0_73

		var0_73 = arg0_69.gameResult == var0_0.GAME_RESULT.VICTORY and "Victory" or "Defeat"

		setText(arg0_69.resultUI:Find("Panel/Text"), i18n("volleyball_end_tip"))

		if arg1_69 then
			setActive(arg0_69.resultUI:Find("Panel/Award"), true)
			setText(arg0_69.resultUI:Find("Panel/Award/Text"), i18n("volleyball_end_award", arg1_69.cost, arg1_69.delta))
		else
			setActive(arg0_69.resultUI:Find("Panel/Award"), false)
		end
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
