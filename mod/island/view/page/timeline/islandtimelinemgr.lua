local var0_0 = class("IslandTimelineMgr", import("view.base.BaseSubView"))
local var1_0 = 1
local var2_0 = 2
local var3_0 = 3

function var0_0.getUIName(arg0_1)
	return "IslandTimelineUI"
end

function var0_0.Ctor(arg0_2, arg1_2, arg2_2, arg3_2, arg4_2)
	arg0_2.poolMgr = arg1_2

	var0_0.super.Ctor(arg0_2, arg2_2, arg3_2, arg4_2)
end

function var0_0.OnLoaded(arg0_3)
	arg0_3.skipBtn = arg0_3._tf:Find("adapt/skip_button")
	arg0_3.maskCG = arg0_3._tf:Find("mask"):GetComponent(typeof(CanvasGroup))
	arg0_3.state = var1_0
end

function var0_0.GetPoolMgr(arg0_4)
	return arg0_4.poolMgr
end

function var0_0.OnInit(arg0_5)
	onButton(arg0_5, arg0_5.skipBtn, function()
		if not arg0_5:IsPlaying() then
			return
		end

		arg0_5:Stop()
	end, SFX_PANEL)
end

function var0_0.IsPlaying(arg0_7)
	return arg0_7.state == var2_0
end

function var0_0.Show(arg0_8, arg1_8, arg2_8, arg3_8)
	if arg0_8:IsPlaying() then
		return
	end

	var0_0.super.Show(arg0_8)

	arg0_8.state = var2_0
	arg0_8.callback = arg3_8
	arg0_8.loadCharacterList = {}

	arg0_8:PlaySceneTimeline(arg1_8, arg2_8, function()
		arg0_8:Stop()
	end)
end

function var0_0.PlaySceneTimeline(arg0_10, arg1_10, arg2_10, arg3_10)
	setActive(arg0_10.skipBtn, false)

	local var0_10 = pg.island_scene_timeline[arg1_10]

	assert(var0_10, "island_scene_timeline >>>>" .. arg1_10)

	local var1_10 = IslandSceneSwitcher.New()

	arg0_10:Mask()
	seriesAsync({
		function(arg0_11)
			var1_10:Load(var0_10.name, nil, {
				function(arg0_12)
					arg0_12()
					arg0_11()
				end
			}, 2)
		end,
		function(arg0_13)
			arg0_10:ApplyReplace(var0_10, arg2_10, arg0_13)
		end,
		function(arg0_14)
			onNextTick(arg0_14)
		end,
		function(arg0_15)
			setActive(arg0_10.skipBtn, true)
			arg0_10:PlayTimeline(var0_10.sequence, arg0_15)
		end,
		function(arg0_16)
			if not arg0_10:IsPlaying() then
				arg0_16()

				return
			end

			arg0_10:UnloadCharacter()
			arg0_10:RevertReplace()
			var1_10:UnLoad()
			_IslandCore:GetView().weatherSystem:Play()
			gcAll(false)
			SceneOpMgr.Inst:SetActiveSceneByIndex(1)
			arg0_16()
		end
	}, arg3_10)

	arg0_10.sceneLoader = var1_10
end

function var0_0.RevertReplace(arg0_17)
	for iter0_17, iter1_17 in ipairs(arg0_17.revertGo or {}) do
		setParent(iter1_17.go, iter1_17.container)

		iter1_17.go.transform.localPosition = iter1_17.position
		iter1_17.go.transform.localEulerAngles = iter1_17.rotation
		iter1_17.go.transform.localScale = iter1_17.scale

		if _IslandCore and iter1_17.unitId >= 0 then
			local var0_17 = iter1_17.unitId == 0 and _IslandCore:GetView().player or _IslandCore:GetView():GetUnitModule(iter1_17.unitId)

			if var0_17 then
				var0_17:Enable()
			end
		end
	end

	arg0_17.revertGo = {}
end

function var0_0.ApplyReplace(arg0_18, arg1_18, arg2_18, arg3_18)
	arg0_18:ReplcaeCamTracks(arg1_18.sequence)

	if #arg1_18.obj <= 0 then
		arg3_18()

		return
	end

	local var0_18 = {}

	arg0_18.revertGo = {}

	for iter0_18, iter1_18 in ipairs(arg1_18.obj) do
		local var1_18 = arg1_18.tracks[iter0_18]

		table.insert(var0_18, function(arg0_19)
			arg0_18:ReplaceTimelineRes(iter1_18, var1_18, arg2_18, arg0_19)
		end)
	end

	parallelAsync(var0_18, arg3_18)
end

function var0_0.ReplaceTimelineRes(arg0_20, arg1_20, arg2_20, arg3_20, arg4_20)
	local var0_20 = arg1_20[1]
	local var1_20 = BuildVector3(arg1_20[2])
	local var2_20 = BuildVector3(arg1_20[3])
	local var3_20 = arg1_20[4][1]
	local var4_20 = arg1_20[4][2]
	local var5_20 = {}
	local var6_20
	local var7_20 = false
	local var8_20 = -1

	if var3_20 == IslandConst.TIMELINE_REPLACE_TYPE_CREATE then
		table.insert(var5_20, function(arg0_21)
			arg0_20:LoadCharacter(var4_20, function(arg0_22)
				var6_20 = arg0_22

				arg0_21()
			end)
		end)
	elseif var3_20 == IslandConst.TIMELINE_REPLACE_TYPE_PLAYER then
		if _IslandCore then
			local var9_20 = _IslandCore:GetView().player

			if var9_20 then
				var8_20 = 0

				var9_20:Disable()

				var6_20 = var9_20._go
			end
		end

		var7_20 = true
	elseif var3_20 == IslandConst.TIMELINE_REPLACE_TYPE_GEN_OBJ then
		if _IslandCore then
			local var10_20 = _IslandCore:GetView():GetUnitModule(var4_20)

			if var10_20 then
				var8_20 = var10_20.id

				var10_20:Disable()

				var6_20 = var10_20._go
			end
		end

		var7_20 = true
	elseif var3_20 == IslandConst.TIMELINE_REPLACE_TYPE_STATIC_OBJ then
		var6_20 = GameObject.Find(var4_20)
		var7_20 = true
	elseif var3_20 == IslandConst.TIMELINE_REPLACE_TYPE_CODE_OBJ then
		table.insert(var5_20, function(arg0_23)
			arg0_20:LoadCharacter(arg3_20[1], function(arg0_24)
				var6_20 = arg0_24

				arg0_23()
			end)
		end)
	end

	if var7_20 and var6_20 then
		table.insert(arg0_20.revertGo, {
			go = var6_20,
			container = var6_20.transform.parent,
			position = var6_20.transform.localPosition,
			rotation = var6_20.transform.localEulerAngles,
			scale = var6_20.transform.localScale,
			unitId = var8_20
		})
	end

	table.insert(var5_20, function(arg0_25)
		if not var6_20 then
			arg0_25()

			return
		end

		setActive(var6_20, true)

		local var0_25 = GameObject.Find(var0_20)

		setParent(var6_20, var0_25)

		var6_20.transform.localPosition = var1_20
		var6_20.transform.localEulerAngles = var2_20

		arg0_20:ReplaceTracks(var6_20, arg2_20, arg0_25)
	end)
	seriesAsync(var5_20, arg4_20)
end

local function var4_0(arg0_26, arg1_26)
	if arg1_26 == "Animator" then
		local var0_26 = arg0_26.transform:GetChild(0):GetComponent(typeof(Animator))

		if var0_26 then
			return var0_26
		end

		return (GetOrAddComponent(arg0_26, typeof(Animator)))
	elseif arg1_26 == "Transform" then
		return arg0_26.transform
	else
		return arg0_26
	end
end

function var0_0.ReplaceTracks(arg0_27, arg1_27, arg2_27, arg3_27)
	local var0_27 = {}

	for iter0_27, iter1_27 in ipairs(arg2_27) do
		local var1_27 = iter1_27[1]
		local var2_27 = iter1_27[2]
		local var3_27 = iter1_27[3]

		if not var0_27[var1_27] then
			var0_27[var1_27] = {}
		end

		table.insert(var0_27[var1_27], {
			var2_27,
			var3_27
		})
	end

	for iter2_27, iter3_27 in pairs(var0_27) do
		local var4_27 = GameObject.Find(iter2_27):GetComponent(typeof(UnityEngine.Playables.PlayableDirector))
		local var5_27 = TimelineHelper.GetTimelineTracks(var4_27):ToTable()
		local var6_27 = {}

		for iter4_27, iter5_27 in ipairs(var5_27) do
			var6_27[iter5_27.name] = iter5_27
		end

		for iter6_27, iter7_27 in ipairs(iter3_27) do
			local var7_27 = tonumber(iter7_27[1])
			local var8_27 = var7_27 and var5_27[var7_27 + 1] or var6_27[iter7_27[1]]

			if var8_27 then
				TimelineHelper.SetSceneBinding(var4_27, var8_27, var4_0(arg1_27, iter7_27[2]))
			end
		end
	end

	arg3_27()
end

function var0_0.ReplcaeCamTracks(arg0_28, arg1_28)
	local var0_28 = GameObject.Find(arg1_28)

	if not var0_28 then
		return
	end

	local var1_28 = var0_28.transform:GetComponentsInChildren(typeof(UnityEngine.Playables.PlayableDirector), true):ToTable()

	for iter0_28, iter1_28 in ipairs(var1_28) do
		local var2_28 = TimelineHelper.GetTimelineTracks(iter1_28):ToTable()

		for iter2_28, iter3_28 in ipairs(var2_28) do
			if iter3_28:GetType():ToString() == "CinemachineTrack" then
				TimelineHelper.SetSceneBinding(iter1_28, iter3_28, IslandCameraMgr.instance.cinemachineBrain)
			end
		end
	end
end

function var0_0.LoadCharacter(arg0_29, arg1_29, arg2_29)
	local var0_29 = pg.island_unit_character[arg1_29]

	arg0_29:GetPoolMgr():GetCharacter(var0_29.model, var0_29.animator, function(arg0_30)
		table.insert(arg0_29.loadCharacterList, {
			data = var0_29,
			go = arg0_30
		})
		arg2_29(arg0_30)
	end)
end

function var0_0.UnloadCharacter(arg0_31, arg1_31)
	for iter0_31, iter1_31 in ipairs(arg0_31.loadCharacterList) do
		arg0_31:GetPoolMgr():ReturnCharacter(iter1_31.data.model, iter1_31.data.animator, iter1_31.go)
	end

	arg0_31.loadCharacterList = {}
end

function var0_0.Mask(arg0_32)
	arg0_32.maskCG.alpha = 1
	arg0_32.maskCG.blocksRaycasts = true
end

function var0_0.UnMask(arg0_33)
	arg0_33.maskCG.alpha = 0
	arg0_33.maskCG.blocksRaycasts = false
end

function var0_0.PlayTimeline(arg0_34, arg1_34, arg2_34)
	if not arg0_34:IsPlaying() then
		arg2_34()

		return
	end

	arg0_34:UnMask()

	local var0_34 = GameObject.Find(arg1_34)

	assert(var0_34, arg1_34)

	if not var0_34 then
		return
	end

	local var1_34 = var0_34:GetComponent(typeof(UnityEngine.Playables.PlayableDirector))
	local var2_34 = GetOrAddComponent(var0_34, "DftCommonSignalReceiver")

	var2_34:SetCommonEvent(function(arg0_35)
		if arg0_35.stringParameter == "TimelineEnd" then
			var1_34:Stop()
			var2_34:SetCommonEvent(nil)

			arg0_34.dftCommonSignalReceiver = nil
			arg0_34.playableDirector = nil

			arg2_34()
		end
	end)
	var1_34:Play()

	arg0_34.playableDirector = var1_34
	arg0_34.dftCommonSignalReceiver = var2_34
end

function var0_0.Stop(arg0_36)
	arg0_36:UnloadCharacter()
	arg0_36:RevertReplace()

	if arg0_36.playableDirector then
		arg0_36.playableDirector:Stop()

		arg0_36.playableDirector = nil
	end

	if arg0_36.dftCommonSignalReceiver then
		arg0_36.dftCommonSignalReceiver:SetCommonEvent(nil)

		arg0_36.dftCommonSignalReceiver = nil
	end

	if arg0_36.sceneLoader then
		arg0_36.sceneLoader:UnLoad()
		SceneOpMgr.Inst:SetActiveSceneByIndex(1)

		arg0_36.sceneLoader = nil
	end

	if arg0_36.callback then
		arg0_36.callback()
	end

	arg0_36.callback = nil
	arg0_36.state = var3_0

	arg0_36:Hide()
end

function var0_0.Hide(arg0_37)
	var0_0.super.Hide(arg0_37)
	arg0_37:UnMask()
end

function var0_0.OnDestroy(arg0_38)
	if arg0_38:isShowing() then
		arg0_38:Stop()
	end
end

return var0_0
