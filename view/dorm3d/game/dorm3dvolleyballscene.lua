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

		arg0_31.bindingConfig = arg0_31.bindingConfig or _.reduce(pg.dorm3d_timeline_dynamic_binding, {}, function(arg0_34, arg1_34)
			if arg1_34.track_name then
				arg0_34[arg1_34.track_name] = arg1_34.object_name
			end

			return arg0_34
		end)

		eachChild(arg0_31.playingDirector, function(arg0_35)
			local var0_35 = arg0_35:GetComponent(typeof(UnityEngine.Playables.PlayableDirector))

			if not var0_35 then
				return
			end

			table.IpairsCArray(TimelineHelper.GetTimelineTracks(var0_35), function(arg0_36, arg1_36)
				if arg0_31.bindingConfig[arg1_36.name] then
					local var0_36 = GameObject.Find(arg0_31.bindingConfig[arg1_36.name])

					if var0_36 then
						TimelineHelper.SetSceneBinding(var0_35, arg1_36, var0_36)
					else
						warning(string.format("轨道%s需要绑定的物体%s不存在", arg1_36.name, arg0_31.bindingConfig[arg1_36.name]))
					end
				end
			end)
		end)

		local var0_33 = {}

		GetOrAddComponent(var4_31, "DftCommonSignalReceiver"):SetCommonEvent(function(arg0_37)
			switch(arg0_37.stringParameter, {
				TimelineRandomTrack = function()
					arg0_31:DoTimelineRandomTrack(arg0_31.playingDirector)
				end,
				TimelineLoop = function()
					arg0_31.playingDirector.time = arg0_37.floatParameter
				end,
				TimelineEnd = function()
					var0_33.finish = true

					arg0_31.playingDirector:Stop()
					setActive(tf(arg0_31.playingDirector).parent, false)
				end
			}, function()
				warning("other event trigger:" .. arg0_37.stringParameter)
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

		local var0_42 = arg0_31.timelineMark

		arg0_31.timelineMark = nil

		existCall(arg2_31, var0_42)
	end)
end

function var0_0.StopPlayingTimeline(arg0_43)
	if arg0_43.playingDirector then
		arg0_43.playingDirector:Stop()
		setActive(tf(arg0_43.playingDirector).parent, false)

		arg0_43.debugTimelineName.text = ""
		arg0_43.debugTrackName.text = ""

		setActive(arg0_43.mainCamera, true)
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

	local var1_44 = var0_44:GetComponent(typeof(DftAniEvent))

	var1_44:SetEndEvent(function()
		setActive(var0_44, false)
		arg0_44:StartOneRound()
		setActive(arg0_44.gameUI:Find("Score"), true)
		var1_44:SetEndEvent(nil)
	end)
	pg.CriMgr.GetInstance():PlaySE_V3(var1_0)
end

function var0_0.UpdateGameScore(arg0_46)
	setText(arg0_46.ourScoreTF, arg0_46.ourScore)
	setText(arg0_46.otherScoreTF, arg0_46.otherScore)
end

function var0_0.UpdateScoreTpl(arg0_47, arg1_47)
	setText(arg1_47:Find("Left/Tens/Text"), 0)
	setText(arg1_47:Find("Left/Units/Text"), arg0_47.ourScore % 10)
	setText(arg1_47:Find("Right/Tens/Text"), 0)
	setText(arg1_47:Find("Right/Units/Text"), arg0_47.otherScore % 10)
end

function var0_0.StartOneRound(arg0_48)
	arg0_48:UpdateGameScore()

	arg0_48.roundEndFlag = false
	arg0_48.roundResult = nil

	seriesAsync({
		function(arg0_49)
			arg0_48:FaQiuOP(arg0_49)
		end,
		function(arg0_50)
			arg0_48:OneQTE()
		end
	})
end

function var0_0.OneQTE(arg0_51)
	seriesAsync({
		function(arg0_52)
			arg0_51:StartQTE(arg0_52)
		end,
		function(arg0_53)
			switch(arg0_51.qteResult, {
				[var0_0.QTE_RESULT.MISS] = function()
					arg0_51:QteMissOP(function()
						arg0_51.roundEndFlag = true
						arg0_51.roundResult = var0_0.ROUND_RESULT.OTHER_WIN

						arg0_53()
					end)
				end,
				[var0_0.QTE_RESULT.HIT] = function()
					arg0_51:QteHitOP(arg0_53)
				end,
				[var0_0.QTE_RESULT.PERFECT] = function()
					arg0_51:QtePerfectOP(function()
						arg0_51.roundEndFlag = true
						arg0_51.roundResult = var0_0.ROUND_RESULT.OUR_WIN

						arg0_53()
					end)
				end
			}, function()
				assert(false, "unknow qte result" .. arg0_51.qteResult)
			end)
		end
	}, function()
		if not arg0_51.roundEndFlag then
			arg0_51:OneQTE()
		else
			arg0_51:EndOneRound()
		end
	end)
end

function var0_0.EndOneRound(arg0_61)
	pg.CriMgr.GetInstance():PlaySE_V3(var6_0)

	local var0_61 = arg0_61.scoreUI:GetComponent(typeof(DftAniEvent))

	var0_61:SetEndEvent(function()
		quickPlayAnimation(arg0_61.scoreUI, "Anim_Dorm3d_volleyball_score_out")
		onDelayTick(function()
			setActive(arg0_61.scoreUI, false)
		end, 0.1)

		if arg0_61:CheckEndGame() then
			arg0_61:EndGame()
		else
			setActive(arg0_61.gameUI, true)
			arg0_61:StartOneRound()
		end

		var0_61:SetEndEvent(nil)
	end)
	setActive(arg0_61.gameUI, false)
	arg0_61:UpdateScoreTpl(arg0_61.scoreUI:Find("ScoreTpl"))
	setText(arg0_61.scoreUI:Find("ScoreTpl/Left/Units/new/newText"), arg0_61.ourScore % 10)
	setText(arg0_61.scoreUI:Find("ScoreTpl/Right/Units/new/newText"), arg0_61.otherScore % 10)
	switch(arg0_61.roundResult, {
		[var0_0.ROUND_RESULT.OUR_WIN] = function()
			arg0_61.ourScore = arg0_61.ourScore + 1

			setText(arg0_61.scoreUI:Find("ScoreTpl/Left/Units/new/newText"), arg0_61.ourScore % 10)
			setActive(arg0_61.scoreUI, true)
			quickPlayAnimation(arg0_61.scoreUI, "Anim_Dorm3d_volleyball_score_leftin")
		end,
		[var0_0.ROUND_RESULT.OTHER_WIN] = function()
			arg0_61.otherScore = arg0_61.otherScore + 1

			setText(arg0_61.scoreUI:Find("ScoreTpl/Right/Units/new/newText"), arg0_61.otherScore % 10)
			setActive(arg0_61.scoreUI, true)
			quickPlayAnimation(arg0_61.scoreUI, "Anim_Dorm3d_volleyball_score_rightin")
		end
	}, function()
		assert(false, "unknow round result" .. arg0_61.roundResult)
	end)
end

function var0_0.CheckEndGame(arg0_67)
	if arg0_67.ourScore >= var0_0.endScore then
		arg0_67.gameResult = var0_0.GAME_RESULT.VICTORY

		return true
	end

	if arg0_67.otherScore >= var0_0.endScore then
		arg0_67.gameResult = var0_0.GAME_RESULT.DEFEAT

		return true
	end

	return false
end

function var0_0.EndGame(arg0_68)
	if arg0_68.gameResult == var0_0.GAME_RESULT.VICTORY then
		pg.CriMgr.GetInstance():PlaySE_V3(var7_0)
	end

	seriesAsync({
		function(arg0_69)
			local var0_69 = arg0_68.gameResult == var0_0.GAME_RESULT.VICTORY and "shibai" or "shengli"

			arg0_68:PlayTimeline({
				name = arg0_68:GetWeightTimeline(var0_69)
			}, arg0_69)
		end
	}, function()
		arg0_68:PlayTimeline({
			name = arg0_68:GetWeightTimeline("daiji")
		}, function()
			return
		end)
		setActive(arg0_68.endUI, true)
		setActive(arg0_68.endUI:Find("Title/Victory"), arg0_68.gameResult == var0_0.GAME_RESULT.VICTORY)
		setActive(arg0_68.endUI:Find("Title/Defeat"), arg0_68.gameResult == var0_0.GAME_RESULT.DEFEAT)
		arg0_68:UpdateScoreTpl(arg0_68.endUI:Find("ScoreTpl"))
	end)
end

function var0_0.ShowResultUI(arg0_72, arg1_72)
	(function()
		local var0_73 = arg0_72.contextData.roomId
		local var1_73 = arg0_72.contextData.groupId or 20220
		local var2_73 = arg0_72.contextData.groupIds or {
			var1_73
		}
		local var3_73 = table.concat(var2_73, ",")
		local var4_73 = arg0_72.ourScore .. ":" .. arg0_72.otherScore

		pg.m02:sendNotification(GAME.APARTMENT_TRACK, Dorm3dTrackCommand.BuildDataRoom(var0_73, 8, var3_73, var4_73))
	end)()
	pg.CriMgr.GetInstance():PlaySE_V3(var8_0)
	seriesAsync({
		function(arg0_74)
			quickPlayAnimation(arg0_72.endUI, "Anim_Dorm3d_volleyball_end_out")
			onDelayTick(function()
				setActive(arg0_72.endUI, false)
			end, 0.1)

			if arg0_72.gameResult == var0_0.GAME_RESULT.VICTORY then
				arg0_72:PlayTimeline({
					name = arg0_72:GetWeightTimeline("jiangli")
				}, arg0_74)
			else
				arg0_72:StopPlayingTimeline()
				arg0_74()
			end
		end
	}, function()
		gcAll(true)
		setActive(arg0_72.resultUI, true)

		local var0_76

		var0_76 = arg0_72.gameResult == var0_0.GAME_RESULT.VICTORY and "Victory" or "Defeat"

		setText(arg0_72.resultUI:Find("Panel/Text"), i18n("volleyball_end_tip"))

		if arg1_72 then
			setActive(arg0_72.resultUI:Find("Panel/Award"), true)
			setText(arg0_72.resultUI:Find("Panel/Award/Text"), i18n("volleyball_end_award", arg1_72.cost, arg1_72.delta))
		else
			setActive(arg0_72.resultUI:Find("Panel/Award"), false)
		end
	end)
end

function var0_0.FaQiuOP(arg0_77, arg1_77)
	arg0_77:PlayTimeline({
		name = arg0_77:GetWeightTimeline("faqiu")
	}, arg1_77)
end

function var0_0.StartQTE(arg0_78, arg1_78)
	arg0_78.qteCallback = arg1_78

	setActive(arg0_78.ballCamera, true)
	setActive(arg0_78.mainCamera, false)

	arg0_78.randomScreenPos = Vector2(math.random(var0_0.BallRandomDelat.Left, Screen.width - var0_0.BallRandomDelat.Right), math.random(var0_0.BallRandomDelat.Bottom, Screen.height - var0_0.BallRandomDelat.Top))

	local var0_78 = arg0_78.ballCameraComp:ScreenPointToRay(arg0_78.randomScreenPos)

	arg0_78.randomScale = math.random(var0_0.perfectScaleRandoms[1] * 10, arg0_78.perfectScaleRandoms[2] * 10) / 10

	local var1_78 = (var0_0.perfectRadiusMax + var0_0.perfectRadiusMin) / 2 * arg0_78.randomScale / var0_0.triggerRadius
	local var2_78 = arg0_78.ballQtePlane.distance + (arg0_78.ballMissPlane.distance - arg0_78.ballQtePlane.distance) * (1 - var1_78)
	local var3_78, var4_78 = Plane.New(arg0_78.ballQtePlane.normal, var2_78):Raycast(var0_78)

	assert(var3_78, "retPerfect plane not in view")

	arg0_78.ballDir = (var0_78:GetPoint(var4_78) - var0_0.BallInitPos):Normalize()

	local var5_78 = Ray.New(arg0_78.ballDir, var0_0.BallInitPos)
	local var6_78, var7_78 = arg0_78.ballQtePlane:Raycast(var5_78)

	assert(var6_78, "qte plane not in view")

	local var8_78 = var5_78:GetPoint(var7_78)
	local var9_78, var10_78 = arg0_78.ballMissPlane:Raycast(var5_78)

	assert(var9_78, "miss plane not in view")

	local var11_78 = var5_78:GetPoint(var10_78)
	local var12_78 = 0

	arg0_78.qteUITime = (var8_78 - var11_78):Magnitude() / var0_0.BallQTESpeed
	arg0_78.ballTimer = Timer.New(function()
		if var12_78 >= var10_78 then
			arg0_78.ballTimer:Stop()

			arg0_78.ballTimer = nil

			setActive(arg0_78.ballTF, false)

			arg0_78.ballTF.position = var0_0.BallInitPos

			if arg0_78.startQTEUI then
				setLocalScale(arg0_78.qteTriggerTF, {
					x = 0,
					y = 0
				})
				arg0_78:EndQTE(var0_0.QTE_RESULT.MISS)
			end
		elseif var12_78 >= var7_78 then
			var12_78 = var12_78 + var0_0.BallQTESpeed
			arg0_78.ballTF.position = var5_78:GetPoint(var12_78)

			if not arg0_78.startQTEUI then
				arg0_78:StartQTEUI()
			end

			arg0_78.curScale = arg0_78.curScale - 1 / arg0_78.qteUITime

			setLocalScale(arg0_78.qteTriggerTF, {
				x = arg0_78.curScale,
				y = arg0_78.curScale
			})

			arg0_78.curRadius = var0_0.triggerRadius * arg0_78.curScale

			if arg0_78.curScale < 0 then
				arg0_78:EndQTE()
			end
		else
			var12_78 = var12_78 + var0_0.BallSpeed
			arg0_78.ballTF.position = var5_78:GetPoint(var12_78)
		end
	end, 0.0166666666666667, -1)

	setActive(arg0_78.ballTF, true)
	arg0_78.ballTimer:Start()
end

function var0_0.StartQTEUI(arg0_80)
	pg.CriMgr.GetInstance():PlaySE_V3(var2_0)
	setLocalScale(arg0_80.qteTriggerTF, {
		x = 1,
		y = 1
	})
	eachChild(arg0_80.qteTF:Find("animroot/Result"), function(arg0_81)
		setActive(arg0_81, false)
	end)

	arg0_80.qteResult = nil
	arg0_80.curRadius = var0_0.triggerRadius
	arg0_80.curPerfectRadiusMax = var0_0.perfectRadiusMax * arg0_80.randomScale
	arg0_80.curPerfectRadiusMin = var0_0.perfectRadiusMin * arg0_80.randomScale

	setLocalScale(arg0_80.qteTF:Find("animroot/Perfect"), {
		x = arg0_80.randomScale,
		y = arg0_80.randomScale
	})

	arg0_80.curScale = 1

	setLocalPosition(arg0_80.qteTF, LuaHelper.ScreenToLocal(arg0_80.qteTF.parent, arg0_80.randomScreenPos, pg.UIMgr.GetInstance().uiCameraComp))
	setActive(arg0_80.qteTF, true)

	arg0_80.startQTEUI = true
end

function var0_0.EndQTE(arg0_82, arg1_82)
	arg0_82.startQTEUI = nil

	setActive(arg0_82.mainCamera, true)
	setActive(arg0_82.ballCamera, false)

	if arg1_82 then
		arg0_82.qteResult = arg1_82
	elseif arg0_82.curRadius < var0_0.hitRadiusMin or arg0_82.curRadius > var0_0.hitRadiusMax then
		arg0_82.qteResult = var0_0.QTE_RESULT.MISS
	elseif arg0_82.curRadius <= arg0_82.curPerfectRadiusMax and arg0_82.curRadius >= arg0_82.curPerfectRadiusMin then
		arg0_82.qteResult = var0_0.QTE_RESULT.PERFECT
	else
		arg0_82.qteResult = var0_0.QTE_RESULT.HIT
	end

	eachChild(arg0_82.qteTF:Find("animroot/Result"), function(arg0_83)
		setActive(arg0_83, arg0_83.name == arg0_82.qteResult)
	end)

	if arg0_82.ballTimer then
		arg0_82.ballTimer:Stop()

		arg0_82.ballTimer = nil

		setActive(arg0_82.ballTF, false)

		arg0_82.ballTF.position = var0_0.BallInitPos
	end

	if arg0_82.qteCallback then
		arg0_82.qteCallback()

		arg0_82.qteCallback = nil
	end

	onDelayTick(function()
		setActive(arg0_82.qteTF, false)
	end, 1)
end

function var0_0.QteMissOP(arg0_85, arg1_85)
	pg.CriMgr.GetInstance():PlaySE_V3(var5_0)
	arg0_85:PlayTimeline({
		name = arg0_85:GetWeightTimeline("shiqiu")
	}, arg1_85)
end

function var0_0.QteHitOP(arg0_86, arg1_86)
	pg.CriMgr.GetInstance():PlaySE_V3(var3_0)
	seriesAsync({
		function(arg0_87)
			arg0_86:PlayTimeline({
				name = arg0_86:GetWeightTimeline("fly")
			}, arg0_87)
		end,
		function(arg0_88)
			arg0_86:PlayTimeline({
				name = arg0_86:GetWeightTimeline("jieqiu")
			}, arg0_88)
		end
	}, arg1_86)
end

function var0_0.QtePerfectOP(arg0_89, arg1_89)
	pg.CriMgr.GetInstance():PlaySE_V3(var4_0)
	seriesAsync({
		function(arg0_90)
			arg0_89:PlayTimeline({
				name = arg0_89:GetWeightTimeline("max_fly")
			}, arg0_90)
		end,
		function(arg0_91)
			arg0_89:PlayTimeline({
				name = arg0_89:GetWeightTimeline("shouji")
			}, arg0_91)
		end
	}, arg1_89)
end

function var0_0.GetWeightTimeline(arg0_92, arg1_92)
	local var0_92 = arg0_92.volleyballCfg[arg1_92]

	assert(var0_92 ~= "", "volleyball cfg is empty string" .. arg1_92)
	assert(#var0_92 ~= 0, "volleyball cfg is empty table:" .. arg1_92)

	local var1_92 = underscore.reduce(var0_92, 0, function(arg0_93, arg1_93)
		return arg0_93 + arg1_93[2]
	end)
	local var2_92 = math.random() * var1_92
	local var3_92 = 0

	for iter0_92, iter1_92 in ipairs(var0_92) do
		var3_92 = var3_92 + iter1_92[2]

		if var2_92 <= var3_92 then
			return iter1_92[1]
		end
	end
end

function var0_0.DoTimelineRandomTrack(arg0_94, arg1_94)
	local var0_94 = {}
	local var1_94 = TimelineHelper.GetTimelineTracks(arg1_94)

	for iter0_94 = 0, var1_94.Length - 1 do
		local var2_94 = var1_94[iter0_94]

		if var2_94.name ~= "Markers" then
			var2_94.muted = true

			table.insert(var0_94, var2_94)
		end
	end

	if #var0_94 > 0 then
		local var3_94 = var0_94[math.random(#var0_94)]

		underscore.each(var0_94, function(arg0_95)
			if arg0_95.name == var3_94.name then
				arg0_95.muted = false
			end
		end)

		arg0_94.debugTrackName.text = var3_94.name
	else
		arg0_94.debugTrackName.text = "track cnt 0"
	end
end

function var0_0.OnPause(arg0_96)
	if arg0_96.ballTimer then
		arg0_96.ballTimer:Stop()
	end

	if arg0_96.playingDirector then
		arg0_96.playingDirector:Pause()
	end
end

function var0_0.OnResume(arg0_97)
	if arg0_97.ballTimer then
		arg0_97.ballTimer:Start()
	end

	if arg0_97.playingDirector then
		arg0_97.playingDirector:Play()
	end
end

function var0_0.onBackPressed(arg0_98)
	if not arg0_98.playingFlag or isActive(arg0_98.gameUI:Find("Count")) or isActive(arg0_98.endUI) then
		return
	end

	arg0_98:OnPause()
	pg.NewStyleMsgboxMgr.GetInstance():Show(pg.NewStyleMsgboxMgr.TYPE_MSGBOX, {
		contentText = i18n("sure_exit_volleyball"),
		onConfirm = function()
			arg0_98:emit(var0_0.ON_BACK)
		end,
		onClose = function()
			arg0_98:OnResume()
		end
	})
end

function var0_0.willExit(arg0_101)
	arg0_101.loader:Clear()

	if arg0_101.ballTimer then
		arg0_101.ballTimer:Stop()

		arg0_101.ballTimer = nil
	end

	local var0_101 = {
		{
			path = string.lower("dorm3d/character/" .. arg0_101.timelineSceneRootName .. "/timeline/" .. arg0_101.timelineSceneName .. "/" .. arg0_101.timelineSceneName .. "_scene"),
			name = arg0_101.timelineSceneName
		},
		{
			path = string.lower("dorm3d/scenesres/scenes/common/" .. arg0_101.sceneRootName .. "/" .. arg0_101.sceneName .. "_scene"),
			name = arg0_101.sceneName
		}
	}
	local var1_101 = underscore.map(var0_101, function(arg0_102)
		return function(arg0_103)
			SceneOpMgr.Inst:UnloadSceneAsync(arg0_102.path, arg0_102.name, arg0_103)
		end
	end)

	seriesAsync(var1_101, function()
		ReflectionHelp.RefSetProperty(typeof("UnityEngine.LightmapSettings"), "lightmaps", nil, nil)
	end)
end

return var0_0
