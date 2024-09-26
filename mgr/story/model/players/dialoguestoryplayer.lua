local var0_0 = class("DialogueStoryPlayer", import(".StoryPlayer"))
local var1_0 = 159
local var2_0 = 411

function var0_0.Ctor(arg0_1, arg1_1)
	var0_0.super.Ctor(arg0_1, arg1_1)

	arg0_1.actorPanel = arg0_1:findTF("actor")
	arg0_1.actorLeft = arg0_1:findTF("actor_left", arg0_1.actorPanel)
	arg0_1.initActorLeftPos = arg0_1.actorLeft.localPosition
	arg0_1.actorMiddle = arg0_1:findTF("actor_middle", arg0_1.actorPanel)
	arg0_1.initActorMiddlePos = arg0_1.actorMiddle.localPosition
	arg0_1.actorRgiht = arg0_1:findTF("actor_right", arg0_1.actorPanel)
	arg0_1.initActorRgihtPos = arg0_1.actorRgiht.localPosition
	arg0_1.sortingOrder = arg0_1._go:GetComponent(typeof(Canvas)).sortingOrder
	arg0_1.subActorMiddle = UIItemList.New(arg0_1:findTF("actor_middle/sub", arg0_1.actorPanel), arg0_1:findTF("actor_middle/sub/tpl", arg0_1.actorPanel))
	arg0_1.subActorRgiht = UIItemList.New(arg0_1:findTF("actor_right/sub", arg0_1.actorPanel), arg0_1:findTF("actor_right/sub/tpl", arg0_1.actorPanel))
	arg0_1.subActorLeft = UIItemList.New(arg0_1:findTF("actor_left/sub", arg0_1.actorPanel), arg0_1:findTF("actor_left/sub/tpl", arg0_1.actorPanel))
	arg0_1.glitchArtMaterial = arg0_1:findTF("resource/material1"):GetComponent(typeof(Image)).material
	arg0_1.maskMaterial = arg0_1:findTF("resource/material2"):GetComponent(typeof(Image)).material
	arg0_1.maskMaterialForWithLayer = arg0_1:findTF("resource/material5"):GetComponent(typeof(Image)).material
	arg0_1.glitchArtMaterialForPainting = arg0_1:findTF("resource/material3"):GetComponent(typeof(Image)).material
	arg0_1.glitchArtMaterialForPaintingBg = arg0_1:findTF("resource/material4"):GetComponent(typeof(Image)).material
	arg0_1.headObjectMat = arg0_1:findTF("resource/material6"):GetComponent(typeof(Image)).material
	arg0_1.headMaskMat = arg0_1:findTF("resource/material7"):GetComponent(typeof(Image)).material
	arg0_1.typewriterSpeed = 0
	arg0_1.contentBgAlpha = 1
	arg0_1.live2dChars = {}
	arg0_1.spinePainings = {}
end

function var0_0.OnStart(arg0_2, arg1_2)
	arg0_2.nextTr = arg0_2:findTF("next", arg0_2.dialogueWin)
	arg0_2.conentTr = arg0_2:findTF("content", arg0_2.dialogueWin)
	arg0_2.conentTxt = arg0_2:findTF("content", arg0_2.dialogueWin):GetComponent(typeof(Text))
	arg0_2.typewriter = arg0_2:findTF("content", arg0_2.dialogueWin):GetComponent(typeof(Typewriter))
	arg0_2.nameTr = arg0_2:findTF("content/name", arg0_2.dialogueWin)
	arg0_2.tag4Dialog2 = arg0_2:findTF("content/tag", arg0_2.dialogueWin)
	arg0_2.nameTxt = arg0_2:findTF("Text", arg0_2.nameTr):GetComponent(typeof(Text))
	arg0_2.portraitTr = arg0_2:findTF("portrait", arg0_2.dialogueWin)
	arg0_2.portraitImg = arg0_2.portraitTr:GetComponent(typeof(Image))
	arg0_2.tags = {
		arg0_2.nameTr:Find("tags/1"),
		arg0_2.nameTr:Find("tags/2")
	}
	arg0_2.contentBgs = {
		arg0_2:findTF("bg", arg0_2.nameTr),
		arg0_2:findTF("bg", arg0_2.dialogueWin)
	}
	arg0_2.defualtFontSize = arg0_2.conentTxt.fontSize
end

function var0_0.OnReset(arg0_3, arg1_3, arg2_3, arg3_3)
	arg0_3:ResetActorTF(arg1_3, arg2_3)
	setActive(arg0_3.nameTr, false)
	setActive(arg0_3.nameTr, false)
	setActive(arg0_3.dialoguePanel, true)
	setActive(arg0_3.actorPanel, true)
	setActive(arg0_3.nextTr, false)

	arg0_3.conentTxt.text = ""

	local var0_3 = arg1_3:ExistPortrait()
	local var1_3 = arg2_3 and arg2_3:IsDialogueMode() and arg2_3:ExistPortrait() and var0_3

	setActive(arg0_3.portraitTr, var1_3)

	if not var1_3 and arg2_3 and arg2_3:IsDialogueMode() and arg2_3:ShouldGlitchArtForPortrait() then
		arg0_3:ClearGlitchArtForPortrait()
	end

	arg0_3.conentTr.offsetMin = Vector2(var0_3 and var2_0 or var1_0, arg0_3.conentTr.offsetMin.y)

	arg0_3:SetContentBgAlpha(arg1_3:GetContentBGAlpha())
	arg3_3()
end

local function var3_0(arg0_4, arg1_4)
	if not arg1_4 then
		return false
	end

	local var0_4

	if arg0_4:IsLive2dPainting() then
		var0_4 = arg1_4:Find("live2d")
	elseif arg0_4:IsSpinePainting() then
		var0_4 = arg1_4:Find("spine")
	else
		var0_4 = arg1_4:Find("fitter")
	end

	if var0_4.childCount <= 0 then
		return false
	end

	return var0_4:GetChild(0).name == arg0_4:GetPainting()
end

function var0_0.GetRecycleActorList(arg0_5, arg1_5, arg2_5)
	local var0_5 = arg1_5:GetSide()
	local var1_5 = arg0_5:GetSideTF(var0_5)
	local var2_5 = {}

	if arg1_5:HideOtherPainting() then
		var2_5 = {
			arg0_5.actorLeft,
			arg0_5.actorMiddle,
			arg0_5.actorRgiht
		}
	else
		if arg2_5 and arg2_5:IsDialogueMode() and arg1_5:IsDialogueMode() and arg1_5:IsSameSide(arg2_5) and arg1_5:IsSamePainting(arg2_5) or var3_0(arg1_5, var1_5) then
			-- block empty
		else
			table.insert(var2_5, var1_5)
		end

		if var0_5 == DialogueStep.SIDE_MIDDLE then
			table.insert(var2_5, arg0_5.actorLeft)
			table.insert(var2_5, arg0_5.actorRgiht)
		end
	end

	return var2_5
end

function var0_0.ResetActorTF(arg0_6, arg1_6, arg2_6)
	local var0_6 = arg1_6:GetSide()
	local var1_6 = arg0_6:GetSideTF(var0_6)

	if var1_6 then
		arg0_6:CancelTween(var1_6.gameObject)

		var1_6.localScale = Vector3(1, 1, 1)
		var1_6.eulerAngles = Vector3(0, 0, 0)

		if var1_6 == arg0_6.actorRgiht then
			var1_6.localPosition = arg0_6.initActorRgihtPos
		elseif var1_6 == arg0_6.actorMiddle then
			var1_6.localPosition = arg0_6.initActorMiddlePos
		elseif var1_6 == arg0_6.actorLeft then
			var1_6.localPosition = arg0_6.initActorLeftPos
		end
	end

	local var2_6 = arg0_6:GetRecycleActorList(arg1_6, arg2_6)

	if var1_6 and _.all(var2_6, function(arg0_7)
		return arg0_7 ~= var1_6
	end) then
		arg0_6.paintingStay = true

		arg0_6:ResetMeshPainting(var1_6)

		if arg1_6:IsSpinePainting() then
			arg0_6:HideSpineEffect(var1_6, arg1_6)
		end
	end

	arg0_6:RecyclePaintingList(var2_6)
	arg0_6:RecyclesSubPantings(arg0_6.subActorMiddle)
	arg0_6:RecyclesSubPantings(arg0_6.subActorRgiht)
	arg0_6:RecyclesSubPantings(arg0_6.subActorLeft)

	for iter0_6, iter1_6 in ipairs({
		arg0_6.actorLeft,
		arg0_6.actorMiddle,
		arg0_6.actorRgiht
	}) do
		iter1_6:GetComponent(typeof(CanvasGroup)).alpha = 1
	end
end

function var0_0.HideSpineEffect(arg0_8, arg1_8)
	arg0_8.spineEffectOrderCaches = {}

	local function var0_8(arg0_9)
		local var0_9 = arg0_9:GetComponentsInChildren(typeof("UnityEngine.ParticleSystemRenderer"))

		for iter0_9 = 1, var0_9.Length do
			local var1_9 = var0_9[iter0_9 - 1]
			local var2_9 = ReflectionHelp.RefGetProperty(typeof("UnityEngine.ParticleSystemRenderer"), "sortingOrder", var1_9)

			ReflectionHelp.RefSetProperty(typeof("UnityEngine.ParticleSystemRenderer"), "sortingOrder", var1_9, -1)

			arg0_8.spineEffectOrderCaches[var1_9] = var2_9
		end
	end

	local var1_8 = arg1_8:Find("spine")
	local var2_8 = arg1_8:Find("spinebg")

	var0_8(var1_8)
	var0_8(var2_8)
end

function var0_0.RevertSpineEffect(arg0_10, arg1_10, arg2_10)
	if not arg2_10 then
		return
	end

	local function var0_10(arg0_11)
		local var0_11 = arg0_11:GetComponentsInChildren(typeof("UnityEngine.ParticleSystemRenderer"))

		for iter0_11 = 1, var0_11.Length do
			local var1_11 = var0_11[iter0_11 - 1]
			local var2_11 = arg2_10[var1_11] or 950

			ReflectionHelp.RefSetProperty(typeof("UnityEngine.ParticleSystemRenderer"), "sortingOrder", var1_11, var2_11)
		end
	end

	local var1_10 = arg1_10:Find("spine")
	local var2_10 = arg1_10:Find("spinebg")

	var0_10(var1_10)
	var0_10(var2_10)
end

function var0_0.OnInit(arg0_12, arg1_12, arg2_12, arg3_12)
	local var0_12 = {
		function(arg0_13)
			arg0_12:UpdateContent(arg1_12, arg0_13)
		end,
		function(arg0_14)
			arg0_12:UpdatePortrait(arg1_12, arg0_14)
		end,
		function(arg0_15)
			arg0_12:UpdateSubPaintings(arg1_12, arg0_15)
		end,
		function(arg0_16)
			arg0_12:UpdatePainting(arg1_12, arg2_12, arg0_16)
		end,
		function(arg0_17)
			arg0_12:GrayingInPainting(arg1_12, arg2_12, arg0_17)
		end,
		function(arg0_18)
			arg0_12:StartMovePrevPaintingToSide(arg1_12, arg2_12, arg0_18)
		end,
		function(arg0_19)
			arg0_12:GrayingOutPrevPainting(arg2_12, arg1_12, arg0_19)
		end
	}

	parallelAsync(var0_12, arg3_12)
end

function var0_0.UpdatePortrait(arg0_20, arg1_20, arg2_20)
	if not arg1_20:ExistPortrait() then
		arg2_20()

		return
	end

	local var0_20 = arg1_20:GetPortrait()

	LoadSpriteAsync("StoryIcon/" .. var0_20, function(arg0_21)
		setImageSprite(arg0_20.portraitTr, arg0_21, true)
		setActive(arg0_20.portraitTr, true)
		arg0_20:AdjustPortraitPosition()

		if arg1_20:ShouldGlitchArtForPortrait() then
			arg0_20:SetGlitchArtForPortrait()
		else
			arg0_20:ClearGlitchArtForPortrait()
		end

		arg2_20()
	end)
end

function var0_0.AdjustPortraitPosition(arg0_22)
	local var0_22 = arg0_22.portraitTr.sizeDelta.x < var2_0 and var2_0 or 539

	setAnchoredPosition3D(arg0_22.portraitTr, {
		x = var0_22
	})
end

function var0_0.SetGlitchArtForPortrait(arg0_23)
	if arg0_23.portraitImg.material ~= arg0_23.glitchArtMaterialForPainting then
		arg0_23.portraitImg.material = arg0_23.glitchArtMaterialForPainting
	end
end

function var0_0.ClearGlitchArtForPortrait(arg0_24)
	if not arg0_24.portraitImg then
		return
	end

	if arg0_24.portraitImg.material ~= arg0_24.portraitImg.defaultGraphicMaterial then
		arg0_24.portraitImg.material = arg0_24.portraitImg.defaultGraphicMaterial
	end
end

function var0_0.UpdateSubPaintings(arg0_25, arg1_25, arg2_25)
	local var0_25, var1_25, var2_25, var3_25 = arg0_25:GetSideTF(arg1_25:GetSide())

	if not arg1_25:ExistPainting() then
		arg2_25()

		return
	end

	arg0_25:InitSubPainting(var3_25, arg1_25:GetSubPaintings(), arg1_25)

	if arg1_25:NeedDispppearSubPainting() then
		arg0_25:DisappearSubPainting(var3_25, arg1_25, arg2_25)
	else
		arg2_25()
	end
end

function var0_0.OnStartUIAnimations(arg0_26, arg1_26, arg2_26)
	if not arg1_26:ShouldShakeDailogue() then
		arg2_26()

		return
	end

	local var0_26 = arg1_26:GetShakeDailogueData()
	local var1_26 = var0_26.x
	local var2_26 = var0_26.number
	local var3_26 = var0_26.delay
	local var4_26 = var0_26.speed
	local var5_26 = arg0_26.dialogueWin.localPosition.x

	arg0_26:TweenMovex(arg0_26.dialogueWin, var1_26, var5_26, var4_26, var3_26, var2_26, arg2_26)
end

function var0_0.OnEnter(arg0_27, arg1_27, arg2_27, arg3_27)
	parallelAsync({
		function(arg0_28)
			arg0_27:UpdateCanMarkNode(arg1_27, arg0_28)
		end,
		function(arg0_29)
			arg0_27:UpdateIcon(arg1_27, arg0_29)
		end
	}, arg3_27)
end

local function var4_0(arg0_30, arg1_30)
	ResourceMgr.Inst:getAssetAsync("Story/" .. arg0_30, arg0_30, UnityEngine.Events.UnityAction_UnityEngine_Object(function(arg0_31)
		arg1_30(arg0_31)
	end), true, true)
end

local function var5_0(arg0_32, arg1_32)
	if not arg1_32 then
		return false
	end

	return arg0_32:GetCanMarkNodeData().name == arg1_32.name
end

function var0_0.UpdateCanMarkNode(arg0_33, arg1_33, arg2_33)
	local var0_33 = arg1_33:ExistCanMarkNode()

	if not var0_33 or not var5_0(arg1_33, arg0_33.canMarkNode) then
		arg0_33:ClearCanMarkNode(arg0_33.canMarkNode)
	end

	if not var0_33 then
		arg2_33()

		return
	end

	local var1_33 = arg1_33:GetCanMarkNodeData()

	local function var2_33(arg0_34)
		eachChild(arg0_34, function(arg0_35)
			local var0_35 = table.contains(var1_33.marks, arg0_35.gameObject.name)

			if var0_35 ~= isActive(arg0_35) then
				setActive(arg0_35, var0_35)
			end
		end)
	end

	if not arg0_33.canMarkNode then
		var4_0(var1_33.name, function(arg0_36)
			if arg0_33.stop or not arg0_36 then
				arg2_33()

				return
			end

			local var0_36 = Object.Instantiate(arg0_36, arg0_33.backPanel)

			arg0_33.canMarkNode = {
				name = var1_33.name,
				go = var0_36
			}

			var2_33(var0_36)
			arg2_33()
		end)
	else
		var2_33(arg0_33.canMarkNode.go)
		arg2_33()
	end
end

function var0_0.ClearCanMarkNode(arg0_37)
	if arg0_37.canMarkNode then
		Destroy(arg0_37.canMarkNode.go)

		arg0_37.canMarkNode = nil
	end
end

function var0_0.GrayingOutPrevPainting(arg0_38, arg1_38, arg2_38, arg3_38)
	if not arg1_38 or not arg1_38:IsDialogueMode() then
		arg3_38()

		return
	end

	local var0_38 = arg0_38:GetSideTF(arg2_38:GetPrevSide(arg1_38))

	if var0_38 and arg2_38 and arg2_38:IsDialogueMode() and arg2_38:ShouldGrayingOutPainting(arg1_38) then
		local var1_38 = arg1_38:GetPaintingData()
		local var2_38 = arg1_38:GetPaintingAlpha() or 1

		arg0_38:fadeTransform(var0_38, var2_38, var1_38.alpha, var1_38.time, false, arg3_38)
	else
		arg3_38()
	end
end

function var0_0.GrayingInPainting(arg0_39, arg1_39, arg2_39, arg3_39)
	if not arg1_39:ExistPainting() then
		arg3_39()

		return
	end

	if arg2_39 and arg2_39:IsDialogueMode() and arg1_39:ShouldGrayingPainting(arg2_39) then
		local var0_39 = arg0_39:GetSideTF(arg1_39:GetSide())
		local var1_39 = arg1_39:GetPaintingData()

		if not IsNil(var0_39) and not arg1_39:GetPaintingAlpha() then
			arg0_39:fadeTransform(var0_39, var1_39.alpha, 1, var1_39.time, false)
		end
	end

	arg3_39()
end

function var0_0.UpdateTypeWriter(arg0_40, arg1_40, arg2_40)
	local var0_40 = arg1_40:GetTypewriter()

	if not var0_40 then
		arg2_40()

		return
	end

	function arg0_40.typewriter.endFunc()
		arg0_40.typewriterSpeed = 0
		arg0_40.typewriter.endFunc = nil

		removeOnButton(arg0_40._tf)
		arg2_40()
	end

	arg0_40.typewriterSpeed = math.max((var0_40.speed or 0.1) * arg0_40.timeScale, 0.001)

	local var1_40 = var0_40.speedUp or arg0_40.typewriterSpeed

	arg0_40.typewriter:setSpeed(arg0_40.typewriterSpeed)
	arg0_40.typewriter:Play()
	onButton(arg0_40, arg0_40._tf, function()
		if arg0_40.puase or arg0_40.stop then
			return
		end

		arg0_40.typewriterSpeed = math.min(arg0_40.typewriterSpeed, var1_40)

		arg0_40.typewriter:setSpeed(arg0_40.typewriterSpeed)
	end, SFX_PANEL)
end

function var0_0.UpdatePainting(arg0_43, arg1_43, arg2_43, arg3_43)
	if not arg1_43:ExistPainting() then
		arg3_43()

		return
	end

	local var0_43 = not arg0_43.paintingStay

	if arg0_43.paintingStay and arg0_43.spineEffectOrderCaches and arg1_43:IsSpinePainting() then
		local var1_43 = arg0_43:GetSideTF(arg1_43:GetSide())

		arg0_43:RevertSpineEffect(var1_43, arg0_43.spineEffectOrderCaches)
	end

	arg0_43.spineEffectOrderCaches = nil
	arg0_43.paintingStay = nil

	local var2_43, var3_43, var4_43, var5_43 = arg0_43:GetSideTF(arg1_43:GetSide())
	local var6_43 = arg2_43 and arg2_43:IsDialogueMode() and (arg1_43:ShouldGrayingOutPainting(arg2_43) or arg1_43:ShouldGrayingPainting(arg2_43)) or not arg1_43:ShouldFadeInPainting() or not var0_43
	local var7_43 = arg2_43 and arg2_43:IsDialogueMode() and arg1_43:ShouldGrayingPainting(arg2_43)

	seriesAsync({
		function(arg0_44)
			if not var6_43 then
				var2_43:GetComponent(typeof(CanvasGroup)).alpha = 0
			end

			arg0_43:LoadPainting(arg1_43, var0_43, arg0_44)

			if var7_43 then
				local var0_44 = arg1_43:GetPaintingData()

				arg0_43:SetFadeColor(var2_43, var0_44.alpha)
			end
		end,
		function(arg0_45)
			if var6_43 then
				arg0_45()

				return
			end

			arg0_43:FadeInPainting(var2_43, arg1_43, arg0_45)
		end,
		function(arg0_46)
			arg0_43:AnimationPainting(arg1_43, arg0_46)
		end
	}, arg3_43)
end

function var0_0.FadeInPainting(arg0_47, arg1_47, arg2_47, arg3_47)
	local var0_47 = arg1_47:GetComponent(typeof(CanvasGroup))
	local var1_47 = arg2_47:GetFadeInPaintingTime()
	local var2_47 = arg2_47:ShouldAddHeadMaskWhenFade()

	if var2_47 then
		arg0_47:AddHeadMask(arg1_47)
	end

	arg0_47:TweenValueForcanvasGroup(var0_47, 0, 1, var1_47, 0, function()
		if var2_47 then
			arg0_47:ClearHeadMask(arg1_47)
		end

		arg3_47()
	end)
end

function var0_0.AddHeadMask(arg0_49, arg1_49)
	local var0_49 = arg1_49:Find("fitter")

	if not var0_49 or var0_49.childCount <= 0 then
		return
	end

	local var1_49 = var0_49:GetChild(0)
	local var2_49 = var1_49:Find("face")
	local var3_49 = cloneTplTo(var2_49, var2_49.parent, "head_mask")
	local var4_49 = var1_49:Find("layers")
	local var5_49 = arg1_49:GetComponentsInChildren(typeof(Image))

	if var4_49 then
		for iter0_49 = 0, var5_49.Length - 1 do
			local var6_49 = var5_49[iter0_49]

			if var6_49.gameObject.name == "head_mask" then
				var6_49.material = arg0_49.headMaskMat
			elseif var6_49.gameObject.name == "face" then
				-- block empty
			elseif var6_49.gameObject.transform.parent == var4_49 then
				var6_49.material = arg0_49.headObjectMat
			end
		end
	else
		for iter1_49 = 0, var5_49.Length - 1 do
			local var7_49 = var5_49[iter1_49]

			if var7_49.gameObject.name == "head_mask" then
				var7_49.material = arg0_49.headMaskMat
			elseif var7_49.gameObject.name == "face" then
				-- block empty
			else
				var7_49.material = arg0_49.headObjectMat
			end
		end
	end
end

function var0_0.ClearHeadMask(arg0_50, arg1_50)
	local var0_50 = arg1_50:Find("fitter")

	if not var0_50 or var0_50.childCount <= 0 then
		return
	end

	local var1_50 = var0_50:GetChild(0):Find("head_mask")

	Destroy(var1_50.gameObject)

	local var2_50 = arg1_50:GetComponentsInChildren(typeof(Image))

	for iter0_50 = 0, var2_50.Length - 1 do
		local var3_50 = var2_50[iter0_50]

		var3_50.material = var3_50.defaultGraphicMaterial
	end
end

function var0_0.AnimationPainting(arg0_51, arg1_51, arg2_51)
	if arg1_51:IsLive2dPainting() or arg1_51:IsSpinePainting() then
		arg2_51()

		return
	end

	local var0_51, var1_51, var2_51, var3_51 = arg0_51:GetSideTF(arg1_51:GetSide())

	arg0_51:StartPaintingActions(var0_51, arg1_51, arg2_51)
end

function var0_0.LoadPainting(arg0_52, arg1_52, arg2_52, arg3_52)
	local var0_52, var1_52, var2_52, var3_52 = arg0_52:GetSideTF(arg1_52:GetSide())
	local var4_52, var5_52 = arg1_52:GetPaintingAndName()

	if arg1_52:IsLive2dPainting() and checkABExist("live2d/" .. var5_52) then
		arg0_52:UpdateLive2dPainting(arg1_52, var0_52, arg2_52, arg3_52)
	elseif arg1_52:IsSpinePainting() and checkABExist("spinepainting/" .. var5_52) then
		arg0_52:UpdateSpinePainting(arg1_52, var0_52, arg2_52, arg3_52)
	else
		arg0_52:UpdateMeshPainting(arg1_52, var0_52, var3_52, arg2_52, arg3_52)
	end
end

function var0_0.UpdateLive2dPainting(arg0_53, arg1_53, arg2_53, arg3_53, arg4_53)
	local function var0_53(arg0_54)
		local var0_54 = arg1_53:GetVirtualShip()
		local var1_54 = arg1_53:GetLive2dPos()
		local var2_54 = Live2D.GenerateData({
			ship = var0_54,
			scale = Vector3(70, 70, 70),
			position = var1_54 or Vector3(0, 0, 0),
			parent = arg2_53:Find("live2d")
		})
		local var3_54 = GetOrAddComponent(arg0_53._go, typeof(CanvasGroup))

		var3_54.blocksRaycasts = false

		local var4_54 = Live2D.New(var2_54, function(arg0_55)
			arg0_55._go.name = arg1_53:GetPainting()

			local var0_55 = arg0_55._go:GetComponent("Live2D.Cubism.Rendering.CubismRenderController")
			local var1_55 = arg0_53.sortingOrder + 1
			local var2_55 = typeof("Live2D.Cubism.Rendering.CubismRenderController")

			ReflectionHelp.RefSetProperty(var2_55, "SortingOrder", var0_55, var1_55)

			local var3_55 = ReflectionHelp.RefGetField(typeof("Live2D.Cubism.Rendering.CubismSortingMode"), "BackToFrontOrder")

			ReflectionHelp.RefSetProperty(var2_55, "SortingMode", var0_55, var3_55)

			local var4_55 = GetOrAddComponent(arg0_53.front, typeof(Canvas))

			GetOrAddComponent(arg0_53.front, typeof(GraphicRaycaster))

			var4_55.overrideSorting = true
			var4_55.sortingOrder = var1_55 + arg0_55._tf:Find("Drawables").childCount
			var3_54.blocksRaycasts = true

			if arg0_54 then
				arg0_54(arg0_55)
			end
		end)

		arg0_53.live2dChars[arg2_53] = var4_54
	end

	local function var1_53(arg0_56)
		if arg0_56 then
			local var0_56 = arg1_53:GetLive2dAction()

			if var0_56 and var0_56 ~= "" then
				arg0_56:TriggerAction(var0_56)
			end

			local var1_56 = arg1_53:GetL2dIdleIndex()

			if var1_56 and var1_56 ~= "" and var1_56 > 0 then
				arg0_56:changeIdleIndex(var1_56)
			end
		end

		arg4_53()
	end

	if not arg3_53 and arg0_53.live2dChars[arg2_53] then
		local var2_53 = arg0_53.live2dChars[arg2_53]

		var1_53(var2_53)
	else
		var0_53(var1_53)
	end
end

local function var6_0(arg0_57, arg1_57, arg2_57)
	local var0_57 = arg0_57:GetComponentsInChildren(typeof(Canvas))
	local var1_57

	for iter0_57 = 1, var0_57.Length do
		var1_57 = var0_57[iter0_57 - 1].sortingOrder
	end

	local var2_57 = math.huge
	local var3_57 = arg1_57:GetComponentsInChildren(typeof(Canvas))

	if var3_57.Length == 0 then
		var2_57 = 0
	else
		for iter1_57 = 1, var3_57.Length do
			local var4_57 = var3_57[iter1_57 - 1].sortingOrder - var1_57

			if var4_57 < var2_57 then
				var2_57 = var4_57
			end
		end
	end

	local var5_57 = arg1_57:GetComponentsInChildren(typeof("UnityEngine.ParticleSystemRenderer"))
	local var6_57 = {}

	for iter2_57 = 1, var5_57.Length do
		local var7_57 = var5_57[iter2_57 - 1]
		local var8_57 = ReflectionHelp.RefGetProperty(typeof("UnityEngine.ParticleSystemRenderer"), "sortingOrder", var7_57)

		var6_57[iter2_57] = var8_57

		local var9_57 = var8_57 - var1_57

		if var9_57 < var2_57 then
			var2_57 = var9_57
		end
	end

	local var10_57 = arg2_57 - var2_57 + 1

	for iter3_57 = 1, var0_57.Length do
		var0_57[iter3_57 - 1].sortingOrder = var10_57 + (iter3_57 - 1)
	end

	local var11_57 = var10_57 + 1

	for iter4_57 = 1, var3_57.Length do
		local var12_57 = var3_57[iter4_57 - 1]
		local var13_57 = var10_57 + (var12_57.sortingOrder - var1_57)

		var12_57.sortingOrder = var13_57

		if var10_57 < var13_57 then
			var11_57 = var13_57
		end
	end

	for iter5_57 = 1, var5_57.Length do
		local var14_57 = var5_57[iter5_57 - 1]
		local var15_57 = var10_57 + (var6_57[iter5_57] - var1_57)

		ReflectionHelp.RefSetProperty(typeof("UnityEngine.ParticleSystemRenderer"), "sortingOrder", var14_57, var15_57)

		if var10_57 < var15_57 then
			var11_57 = var15_57
		end
	end

	return var11_57
end

local function var7_0(arg0_58, arg1_58, arg2_58)
	local var0_58 = arg0_58:GetComponentsInChildren(typeof(Canvas))
	local var1_58 = arg0_58:GetComponentsInChildren(typeof("UnityEngine.ParticleSystemRenderer"))
	local var2_58 = math.huge

	if var0_58.Length == 0 then
		var2_58 = 0
	else
		for iter0_58 = 1, var0_58.Length do
			local var3_58 = var0_58[iter0_58 - 1].sortingOrder

			if var3_58 < var2_58 then
				var2_58 = var3_58
			end
		end
	end

	local var4_58 = {}

	for iter1_58 = 1, var1_58.Length do
		local var5_58 = var1_58[iter1_58 - 1]
		local var6_58 = ReflectionHelp.RefGetProperty(typeof("UnityEngine.ParticleSystemRenderer"), "sortingOrder", var5_58)

		var4_58[iter1_58] = var6_58

		if var6_58 < var2_58 then
			var2_58 = var6_58
		end
	end

	local var7_58 = arg2_58 + 1
	local var8_58 = var7_58 - var2_58

	for iter2_58 = 1, var0_58.Length do
		local var9_58 = var0_58[iter2_58 - 1]
		local var10_58 = var8_58 + var9_58.sortingOrder

		var9_58.sortingOrder = var10_58

		if var7_58 < var10_58 then
			var7_58 = var10_58
		end
	end

	for iter3_58 = 1, var1_58.Length do
		local var11_58 = var1_58[iter3_58 - 1]
		local var12_58 = var8_58 + var4_58[iter3_58]

		ReflectionHelp.RefSetProperty(typeof("UnityEngine.ParticleSystemRenderer"), "sortingOrder", var11_58, var12_58)

		if var12_58 < var7_58 then
			var7_58 = var12_58
		end
	end

	return var7_58
end

function var0_0.UpdateSpinePainting(arg0_59, arg1_59, arg2_59, arg3_59, arg4_59)
	local function var0_59(arg0_60)
		local var0_60 = arg2_59:Find("spine")
		local var1_60 = arg2_59:Find("spinebg")
		local var2_60 = arg1_59:GetVirtualShip()
		local var3_60 = SpinePainting.GenerateData({
			ship = var2_60,
			position = Vector3(0, 0, 0),
			parent = var0_60,
			effectParent = var1_60
		})

		setActive(var1_60, not arg1_59:IsHideSpineBg())

		local var4_60 = SpinePainting.New(var3_60, function(arg0_61)
			arg0_61._go.name = arg1_59:GetPainting()

			local var0_61 = arg0_59.sortingOrder
			local var1_61 = arg1_59:GetSpineOrderIndex()

			if not var1_61 then
				var0_61 = var6_0(var0_60, var1_60, arg0_59.sortingOrder)
			else
				var0_61 = var7_0(var0_60, var1_61, arg0_59.sortingOrder)
			end

			local var2_61 = GetOrAddComponent(arg0_59.front, typeof(Canvas))

			GetOrAddComponent(arg0_59.front, typeof(GraphicRaycaster))

			var2_61.overrideSorting = true
			var2_61.sortingOrder = var0_61 + 1

			arg0_59:UpdateSpineExpression(arg0_61, arg1_59)

			if arg0_60 then
				arg0_60()
			end
		end)

		arg0_59.spinePainings[arg2_59] = var4_60
	end

	if not arg3_59 and arg0_59.spinePainings[arg2_59] then
		arg0_59:UpdateSpineExpression(arg0_59.spinePainings[arg2_59], arg1_59)
		arg4_59()
	else
		var0_59(arg4_59)
	end
end

function var0_0.UpdateSpineExpression(arg0_62, arg1_62, arg2_62)
	local var0_62 = arg2_62:GetSpineExPression()

	if var0_62 then
		arg1_62:SetAction(var0_62, 1)
	else
		arg1_62:SetEmptyAction(1)
	end
end

function var0_0.UpdateMeshPainting(arg0_63, arg1_63, arg2_63, arg3_63, arg4_63, arg5_63)
	local var0_63 = arg1_63:GetPainting()
	local var1_63 = false

	local function var2_63()
		if arg1_63:IsShowNPainting() and checkABExist("painting/" .. var0_63 .. "_n") then
			var0_63 = var0_63 .. "_n"
		end

		if arg1_63:IsShowWJZPainting() and checkABExist("painting/" .. var0_63 .. "_wjz") then
			var0_63 = var0_63 .. "_wjz"
		end

		setPaintingPrefab(arg2_63, var0_63, "duihua")
	end

	if var0_63 then
		local var3_63 = findTF(arg2_63, "fitter").childCount

		if arg4_63 or var3_63 <= 0 then
			var2_63()
		end

		local var4_63 = arg1_63:GetPaintingDir()
		local var5_63 = math.abs(var4_63)

		arg2_63.localScale = Vector3(var4_63, var5_63, 1)

		local var6_63 = findTF(arg2_63, "fitter"):GetChild(0)

		var6_63.name = var0_63

		arg0_63:UpdateActorPostion(arg2_63, arg1_63)
		arg0_63:UpdateExpression(var6_63, arg1_63)
		arg0_63:AddGlitchArtEffectForPating(arg2_63, var6_63, arg1_63)
		arg2_63:SetAsLastSibling()

		if arg1_63:ShouldGrayPainting() then
			setGray(var6_63, true, true)
		end

		local var7_63 = findTF(var6_63, "shadow")

		if var7_63 then
			setActive(var7_63, arg1_63:ShouldFaceBlack())
		end

		local var8_63 = arg1_63:GetPaintingAlpha()

		if var8_63 then
			arg0_63:setPaintingAlpha(arg2_63, var8_63)
		end
	end

	arg5_63()
end

local function var8_0(arg0_65)
	local var0_65 = arg0_65.name

	if arg0_65.showNPainting and checkABExist("painting/" .. var0_65 .. "_n") then
		var0_65 = var0_65 .. "_n"
	end

	return var0_65
end

function var0_0.InitSubPainting(arg0_66, arg1_66, arg2_66, arg3_66)
	local function var0_66(arg0_67, arg1_67)
		local var0_67 = var8_0(arg0_67)

		setPaintingPrefab(arg1_67, var0_67, "duihua")

		local var1_67 = findTF(arg1_67, "fitter"):GetChild(0)
		local var2_67 = findTF(var1_67, "face")
		local var3_67 = arg0_67.expression

		if not arg0_67.expression and arg0_67.name and ShipExpressionHelper.DefaultFaceless(arg0_67.name) then
			var3_67 = ShipExpressionHelper.GetDefaultFace(arg0_67.name)
		end

		if var3_67 then
			setActive(var2_67, true)

			local var4_67 = GetSpriteFromAtlas("paintingface/" .. arg0_67.name, arg0_67.expression)

			setImageSprite(var2_67, var4_67)
		end

		if arg0_67.pos then
			setAnchoredPosition(arg1_67, arg0_67.pos)
		end

		if arg0_67.dir then
			arg1_67.transform.localScale = Vector3(arg0_67.dir, 1, 1)
		end

		if arg0_67.paintingNoise then
			arg0_66:AddGlitchArtEffectForPating(arg1_67, var1_67, arg3_66)
		end
	end

	arg1_66:make(function(arg0_68, arg1_68, arg2_68)
		if arg0_68 == UIItemList.EventUpdate then
			var0_66(arg2_66[arg1_68 + 1], arg2_68)
		end
	end)
	arg1_66:align(#arg2_66)
end

function var0_0.DisappearSubPainting(arg0_69, arg1_69, arg2_69, arg3_69)
	local var0_69 = arg2_69:GetSubPaintings()
	local var1_69, var2_69 = arg2_69:GetDisappearTime()
	local var3_69 = arg2_69:GetDisappearSeq()
	local var4_69 = {}
	local var5_69 = {}

	for iter0_69, iter1_69 in ipairs(var0_69) do
		table.insert(var5_69, iter1_69)
	end

	for iter2_69, iter3_69 in ipairs(var3_69) do
		local var6_69 = iter3_69

		table.insert(var4_69, function(arg0_70)
			for iter0_70, iter1_70 in ipairs(var5_69) do
				if iter1_70.actor == var6_69 then
					table.remove(var5_69, iter0_70)

					break
				end
			end

			arg0_69:InitSubPainting(arg1_69, var5_69, arg2_69)
			arg0_69:DelayCall(var2_69, arg0_70)
		end)
	end

	arg1_69.container:SetAsFirstSibling()
	arg0_69:DelayCall(var1_69, function()
		seriesAsync(var4_69, function()
			arg1_69.container:SetAsLastSibling()
			arg3_69()
		end)
	end)
end

function var0_0.UpdateActorPostion(arg0_73, arg1_73, arg2_73)
	local var0_73 = arg2_73:GetPaitingOffst()

	if var0_73 then
		local var1_73 = arg1_73.localPosition

		arg1_73.localPosition = Vector3(var1_73.x + (var0_73.x or 0), var1_73.y + (var0_73.y or 0), 0)
	end
end

function var0_0.UpdateExpression(arg0_74, arg1_74, arg2_74)
	local var0_74 = arg2_74:GetExPression()
	local var1_74 = findTF(arg1_74, "face")

	if var0_74 then
		local var2_74 = arg2_74:GetPainting()
		local var3_74 = GetSpriteFromAtlas("paintingface/" .. var2_74, var0_74)

		setActive(var1_74, true)
		setImageSprite(var1_74, var3_74)
	else
		setActive(var1_74, false)
	end
end

function var0_0.StartPaintingActions(arg0_75, arg1_75, arg2_75, arg3_75)
	local var0_75 = {
		function(arg0_76)
			arg0_75:StartPatiningMoveAction(arg1_75, arg2_75, arg0_76)
		end,
		function(arg0_77)
			arg0_75:StartPatiningShakeAction(arg1_75, arg2_75, arg0_77)
		end,
		function(arg0_78)
			arg0_75:StartPatiningZoomAction(arg1_75, arg2_75, arg0_78)
		end,
		function(arg0_79)
			arg0_75:StartPatiningRotateAction(arg1_75, arg2_75, arg0_79)
		end
	}

	parallelAsync(var0_75, function()
		if arg3_75 then
			arg3_75()
		end
	end)
end

function var0_0.StartPatiningShakeAction(arg0_81, arg1_81, arg2_81, arg3_81)
	local var0_81 = arg2_81:GetPaintingAction(DialogueStep.PAINTING_ACTION_SHAKE)

	if not var0_81 then
		arg3_81()

		return
	end

	local function var1_81(arg0_82, arg1_82)
		local var0_82 = arg0_82.x or 0
		local var1_82 = arg0_82.y or 10
		local var2_82 = arg0_82.dur or 1
		local var3_82 = arg0_82.delay or 0
		local var4_82 = arg0_82.number or 1
		local var5_82 = tf(arg1_81).localPosition

		arg0_81:TweenMove(arg1_81, Vector3(var5_82.x + var0_82, var5_82.y + var1_82, 0), var2_82, var4_82, var3_82, arg1_82)
	end

	local var2_81 = {}

	for iter0_81, iter1_81 in pairs(var0_81) do
		table.insert(var2_81, function(arg0_83)
			var1_81(iter1_81, arg0_83)
		end)
	end

	parallelAsync(var2_81, function()
		if arg3_81 then
			arg3_81()
		end
	end)
end

function var0_0.StartPatiningZoomAction(arg0_85, arg1_85, arg2_85, arg3_85)
	local var0_85 = arg2_85:GetPaintingAction(DialogueStep.PAINTING_ACTION_ZOOM)

	if not var0_85 then
		arg3_85()

		return
	end

	local function var1_85(arg0_86, arg1_86)
		if not arg0_86.from then
			local var0_86 = {
				0,
				0,
				0
			}
		end

		local var1_86 = arg0_86.to or {
			1,
			1,
			1
		}
		local var2_86 = arg0_86.dur or 0
		local var3_86 = arg0_86.delay or 0

		arg0_85:TweenScale(arg1_85, Vector3(var1_86[1], var1_86[2], var1_86[3]), var2_86, var3_86, arg1_86)
	end

	local var2_85 = {}

	for iter0_85, iter1_85 in pairs(var0_85) do
		table.insert(var2_85, function(arg0_87)
			var1_85(iter1_85, arg0_87)
		end)
	end

	parallelAsync(var2_85, function()
		if arg3_85 then
			arg3_85()
		end
	end)
end

function var0_0.StartPatiningRotateAction(arg0_89, arg1_89, arg2_89, arg3_89)
	local var0_89 = arg2_89:GetPaintingAction(DialogueStep.PAINTING_ACTION_ROTATE)

	if not var0_89 then
		arg3_89()

		return
	end

	local function var1_89(arg0_90, arg1_90)
		local var0_90 = arg0_90.value
		local var1_90 = arg0_90.dur or 1
		local var2_90 = arg0_90.number or 1
		local var3_90 = arg0_90.delay or 0

		arg0_89:TweenRotate(arg1_89, var0_90, var1_90, var2_90, var3_90, arg1_90)
	end

	local var2_89 = {}

	for iter0_89, iter1_89 in pairs(var0_89) do
		table.insert(var2_89, function(arg0_91)
			var1_89(iter1_89, arg0_91)
		end)
	end

	parallelAsync(var2_89, function()
		if arg3_89 then
			arg3_89()
		end
	end)
end

function var0_0.StartPatiningMoveAction(arg0_93, arg1_93, arg2_93, arg3_93)
	local var0_93 = arg2_93:GetPaintingAction(DialogueStep.PAINTING_ACTION_MOVE)

	if not var0_93 then
		arg3_93()

		return
	end

	local function var1_93(arg0_94, arg1_94)
		local var0_94 = arg0_94.x or 0
		local var1_94 = arg0_94.y or 0
		local var2_94 = arg0_94.dur or 1
		local var3_94 = arg0_94.delay or 0
		local var4_94 = tf(arg1_93).localPosition

		arg0_93:TweenMove(arg1_93, Vector3(var4_94.x + var0_94, var4_94.y + var1_94, 0), var2_94, 1, var3_94, arg1_94)
	end

	local var2_93 = {}

	for iter0_93, iter1_93 in pairs(var0_93) do
		table.insert(var2_93, function(arg0_95)
			var1_93(iter1_93, arg0_95)
		end)
	end

	parallelAsync(var2_93, function()
		if arg3_93 then
			arg3_93()
		end
	end)
end

function var0_0.StartMovePrevPaintingToSide(arg0_97, arg1_97, arg2_97, arg3_97)
	local var0_97 = arg1_97:GetPaintingMoveToSide()

	if not var0_97 or not arg2_97 then
		arg3_97()

		return
	end

	local var1_97 = arg0_97:GetSideTF(arg2_97:GetSide())

	if not var1_97 then
		arg3_97()

		return
	end

	local var2_97 = var0_97.time
	local var3_97 = var0_97.side
	local var4_97 = arg0_97:GetSideTF(var3_97)

	if not var4_97 then
		arg3_97()

		return
	end

	if arg1_97.side ~= arg2_97.side then
		if var1_97:Find("fitter").childCount > 0 then
			local var5_97 = var1_97:Find("fitter"):GetChild(0)

			removeAllChildren(var4_97:Find("fitter"))
			setParent(var5_97, var4_97:Find("fitter"))

			local var6_97 = arg2_97:GetPaintingDir()

			var4_97.localScale = Vector3(var6_97, math.abs(var6_97), 1)
		end
	else
		local var7_97 = arg2_97:GetPainting()

		if var7_97 then
			setPaintingPrefab(var4_97, var7_97, "duihua")
		end
	end

	local var8_97 = tf(var4_97).localPosition

	arg0_97:TweenValue(var4_97, var1_97.localPosition.x, var8_97.x, var2_97, 0, function(arg0_98)
		setAnchoredPosition(var4_97, {
			x = arg0_98
		})
	end, arg3_97)

	var4_97.localPosition = Vector2(var1_97.localPosition.x, var4_97.localPosition.y, 0)
end

local function var9_0(arg0_99, arg1_99, arg2_99, arg3_99, arg4_99)
	local var0_99 = arg1_99:GetComponentsInChildren(typeof(Image))

	for iter0_99 = 0, var0_99.Length - 1 do
		local var1_99 = var0_99[iter0_99]

		if var1_99.gameObject.name == "temp_mask" then
			var1_99.material = arg4_99 and arg0_99.maskMaterial or arg0_99.maskMaterialForWithLayer
		elseif var1_99.gameObject.name == "face" then
			var1_99.material = arg0_99.glitchArtMaterial
		elseif arg3_99.hasPaintbg and var1_99.gameObject == arg2_99.gameObject then
			var1_99.material = arg0_99.glitchArtMaterialForPaintingBg
		else
			var1_99.material = arg0_99.glitchArtMaterialForPainting
		end
	end
end

local function var10_0(arg0_100, arg1_100, arg2_100, arg3_100, arg4_100)
	local var0_100 = arg1_100:GetComponentsInChildren(typeof(Image))
	local var1_100 = {}
	local var2_100 = arg2_100:GetComponent(typeof(Image))

	if var2_100 then
		table.insert(var1_100, var2_100.gameObject)
	end

	for iter0_100 = 1, arg3_100 - 1 do
		local var3_100 = arg4_100:GetChild(iter0_100 - 1)

		table.insert(var1_100, var3_100.gameObject)
	end

	for iter1_100 = 0, var0_100.Length - 1 do
		local var4_100 = var0_100[iter1_100]

		if var4_100.gameObject.name == "temp_mask" then
			var4_100.material = arg0_100.maskMaterial
		elseif var4_100.gameObject.name == "face" then
			var4_100.material = arg0_100.glitchArtMaterial
		elseif table.contains(var1_100, var4_100.gameObject) then
			var4_100.material = arg0_100.glitchArtMaterialForPaintingBg
		else
			var4_100.material = arg0_100.glitchArtMaterialForPainting
		end
	end
end

function var0_0.AddGlitchArtEffectForPating(arg0_101, arg1_101, arg2_101, arg3_101)
	local var0_101 = arg3_101:ShouldAddGlitchArtEffect()
	local var1_101 = arg3_101:IsNoHeadPainting()

	if var0_101 and arg3_101:GetExPression() ~= nil and not var1_101 then
		local var2_101 = arg2_101:Find("face")

		cloneTplTo(var2_101, var2_101.parent, "temp_mask"):SetAsFirstSibling()

		local var3_101 = arg2_101:Find("layers")
		local var4_101 = IsNil(var3_101)

		if not var4_101 and arg3_101:GetPaintingRwIndex() > 0 then
			var10_0(arg0_101, arg1_101, arg2_101, arg3_101:GetPaintingRwIndex(), var3_101)
		else
			var9_0(arg0_101, arg1_101, arg2_101, arg3_101, var4_101)
		end
	elseif var0_101 then
		local var5_101 = arg1_101:GetComponentsInChildren(typeof(Image))

		for iter0_101 = 0, var5_101.Length - 1 do
			var5_101[iter0_101].material = arg0_101.glitchArtMaterial
		end
	end

	if var0_101 then
		local var6_101 = GameObject.Find("/OverlayCamera/Overlay/UIMain/AwardInfoUI(Clone)/items/SpriteMask")

		if var6_101 and var6_101.activeInHierarchy then
			setActive(var6_101, false)

			arg0_101.spriteMask = var6_101
		end
	end
end

function var0_0.UpdateContent(arg0_102, arg1_102, arg2_102)
	local function var0_102()
		setActive(arg0_102.nextTr, true)
		arg2_102()
	end

	for iter0_102, iter1_102 in ipairs(arg0_102.tags) do
		setActive(iter1_102, iter0_102 == arg1_102:GetTag())
	end

	arg0_102.conentTxt.fontSize = arg1_102:GetFontSize() or arg0_102.defualtFontSize

	local var1_102 = arg1_102:GetContent()

	arg0_102.conentTxt.text = var1_102

	local var2_102 = 999

	if var1_102 and var1_102 ~= "" then
		var2_102 = System.String.New(var1_102).Length
	end

	if var1_102 and var1_102 ~= "" and var1_102 ~= "…" and #var1_102 > 1 and var2_102 > 1 then
		arg0_102:UpdateTypeWriter(arg1_102, var0_102)
	else
		var0_102()
	end

	local var3_102 = false
	local var4_102, var5_102, var6_102, var7_102 = arg0_102:GetSideTF(arg1_102:GetSide())

	if var5_102 then
		local var8_102 = arg1_102:GetNameWithColor()
		local var9_102 = var8_102 and var8_102 ~= ""

		var3_102 = var9_102

		setActive(var5_102, var9_102)

		if var9_102 then
			local var10_102 = arg1_102:GetNameColorCode()

			var5_102:Find("Text"):GetComponent(typeof(Outline)).effectColor = Color.NewHex(var10_102)
		end

		var6_102.text = var8_102

		setText(var6_102.gameObject.transform:Find("subText"), arg1_102:GetSubActorName())
	end

	if arg0_102.script:IsDialogueStyle2() then
		setActive(arg0_102.tag4Dialog2, not var3_102)
	end
end

function var0_0.SetContentBgAlpha(arg0_104, arg1_104)
	if arg0_104.contentBgAlpha ~= arg1_104 then
		for iter0_104, iter1_104 in ipairs(arg0_104.contentBgs) do
			GetOrAddComponent(iter1_104, typeof(CanvasGroup)).alpha = arg1_104
		end

		arg0_104.contentBgAlpha = arg1_104
	end
end

function var0_0.GetSideTF(arg0_105, arg1_105)
	local var0_105
	local var1_105
	local var2_105
	local var3_105

	if DialogueStep.SIDE_LEFT == arg1_105 then
		var0_105, var1_105, var2_105, var3_105 = arg0_105.actorLeft, arg0_105.nameTr, arg0_105.nameTxt, arg0_105.subActorLeft
	elseif DialogueStep.SIDE_RIGHT == arg1_105 then
		var0_105, var1_105, var2_105, var3_105 = arg0_105.actorRgiht, arg0_105.nameTr, arg0_105.nameTxt, arg0_105.subActorRgiht
	elseif DialogueStep.SIDE_MIDDLE == arg1_105 then
		var0_105, var1_105, var2_105, var3_105 = arg0_105.actorMiddle, arg0_105.nameTr, arg0_105.nameTxt, arg0_105.subActorMiddle
	end

	return var0_105, var1_105, var2_105, var3_105
end

function var0_0.RecyclesSubPantings(arg0_106, arg1_106)
	arg1_106:each(function(arg0_107, arg1_107)
		arg0_106:RecyclePainting(arg1_107)
	end)
end

local function var11_0(arg0_108)
	if arg0_108:Find("fitter").childCount == 0 then
		return
	end

	local var0_108 = arg0_108:Find("fitter"):GetChild(0)

	if var0_108 then
		local var1_108 = findTF(var0_108, "shadow")

		if var1_108 then
			setActive(var1_108, false)
		end

		local var2_108 = arg0_108:GetComponentsInChildren(typeof(Image))

		for iter0_108 = 0, var2_108.Length - 1 do
			local var3_108 = var2_108[iter0_108]
			local var4_108 = Color.white

			if var3_108.material ~= var3_108.defaultGraphicMaterial then
				var3_108.material = var3_108.defaultGraphicMaterial
			end

			var3_108.material:SetColor("_Color", var4_108)
		end

		setGray(var0_108, false, true)
		retPaintingPrefab(arg0_108, var0_108.name)

		local var5_108 = var0_108:Find("temp_mask")

		if var5_108 then
			Destroy(var5_108.gameObject)
		end
	end
end

function var0_0.ClearMeshPainting(arg0_109, arg1_109)
	arg0_109:ResetMeshPainting(arg1_109)

	if arg1_109:Find("fitter").childCount == 0 then
		return
	end

	local var0_109 = arg1_109:Find("fitter"):GetChild(0)

	if var0_109 then
		retPaintingPrefab(arg1_109, var0_109.name)
	end
end

function var0_0.ResetMeshPainting(arg0_110, arg1_110)
	if arg1_110:Find("fitter").childCount == 0 then
		return
	end

	local var0_110 = arg1_110:Find("fitter"):GetChild(0)

	if var0_110 then
		local var1_110 = findTF(var0_110, "shadow")

		if var1_110 then
			setActive(var1_110, false)
		end

		local var2_110 = arg1_110:GetComponentsInChildren(typeof(Image))

		for iter0_110 = 0, var2_110.Length - 1 do
			local var3_110 = var2_110[iter0_110]
			local var4_110 = Color.white

			if var3_110.material ~= var3_110.defaultGraphicMaterial then
				var3_110.material = var3_110.defaultGraphicMaterial

				var3_110.material:SetColor("_Color", var4_110)
			else
				var3_110.material = nil
			end
		end

		setGray(var0_110, false, true)

		local var5_110 = var0_110:Find("temp_mask")

		if var5_110 then
			Destroy(var5_110.gameObject)
		end
	end
end

local function var12_0(arg0_111, arg1_111)
	local var0_111 = arg0_111.live2dChars[arg1_111]
	local var1_111 = false

	if var0_111 and var0_111._go then
		local var2_111 = var0_111._go:GetComponent("Live2D.Cubism.Rendering.CubismRenderController")

		ReflectionHelp.RefSetProperty(typeof("Live2D.Cubism.Rendering.CubismRenderController"), "SortingOrder", var2_111, 0)
		var0_111:Dispose()

		arg0_111.live2dChars[arg1_111] = nil
		var1_111 = true
	end

	local var3_111 = table.getCount(arg0_111.live2dChars) <= 0

	if var1_111 and var3_111 then
		RemoveComponent(arg0_111.front, "GraphicRaycaster")
		RemoveComponent(arg0_111.front, "Canvas")
	end
end

local function var13_0(arg0_112, arg1_112)
	local var0_112 = arg0_112.spinePainings[arg1_112]
	local var1_112 = false

	if var0_112 then
		var0_112:Dispose()

		arg0_112.spinePainings[arg1_112] = nil
		var1_112 = true
	end

	local var2_112 = table.getCount(arg0_112.spinePainings) <= 0

	if var1_112 and var2_112 then
		RemoveComponent(arg0_112.front, "GraphicRaycaster")
		RemoveComponent(arg0_112.front, "Canvas")
	end
end

function var0_0.RecyclePainting(arg0_113, arg1_113)
	if type(arg1_113) == "table" then
		local var0_113 = _.map(arg1_113, function(arg0_114)
			return arg0_113[arg0_114]
		end)

		arg0_113:RecyclePaintingList(var0_113)
	else
		arg0_113:ClearMeshPainting(arg1_113)
		var12_0(arg0_113, arg1_113)
		var13_0(arg0_113, arg1_113)
	end
end

function var0_0.RecyclePaintingList(arg0_115, arg1_115)
	for iter0_115, iter1_115 in ipairs(arg1_115) do
		arg0_115:ClearMeshPainting(iter1_115)
		var12_0(arg0_115, iter1_115)
		var13_0(arg0_115, iter1_115)
	end
end

function var0_0.Resume(arg0_116)
	var0_0.super.Resume(arg0_116)

	if arg0_116.typewriterSpeed ~= 0 then
		arg0_116.typewriter:setSpeed(arg0_116.typewriterSpeed)
	end
end

function var0_0.Pause(arg0_117)
	var0_0.super.Pause(arg0_117)

	if arg0_117.typewriterSpeed ~= 0 then
		arg0_117.typewriter:setSpeed(100000000)
	end
end

function var0_0.OnClear(arg0_118)
	if arg0_118.spriteMask then
		setActive(arg0_118.spriteMask, true)

		arg0_118.spriteMask = nil
	end
end

function var0_0.FadeOutPainting(arg0_119, arg1_119, arg2_119, arg3_119)
	local var0_119 = arg2_119:GetComponent(typeof(CanvasGroup))
	local var1_119 = arg1_119:GetFadeOutPaintingTime()

	if var1_119 <= 0 then
		arg3_119()

		return
	end

	local var2_119 = arg1_119:ShouldAddHeadMaskWhenFade()

	if var2_119 then
		arg0_119:AddHeadMask(arg2_119)
	end

	arg0_119:TweenValueForcanvasGroup(var0_119, 1, 0, var1_119, 0, function()
		if var2_119 then
			arg0_119:ClearHeadMask(arg2_119)
		end

		arg3_119()
	end)
end

function var0_0.OnWillExit(arg0_121, arg1_121, arg2_121, arg3_121)
	if not arg2_121 or not arg2_121:IsDialogueMode() then
		arg3_121()

		return
	end

	local var0_121 = arg0_121:GetRecycleActorList(arg2_121, arg1_121)
	local var1_121

	if arg2_121:ShouldMoveToSide() then
		var1_121 = arg0_121:GetSideTF(arg1_121:GetSide())
	end

	local var2_121 = {}

	for iter0_121, iter1_121 in pairs(var0_121) do
		if (not var1_121 or iter1_121 ~= var1_121) and iter1_121:Find("fitter").childCount > 0 then
			table.insert(var2_121, function(arg0_122)
				arg0_121:FadeOutPainting(arg1_121, iter1_121, arg0_122)
			end)
		end
	end

	parallelAsync(var2_121, arg3_121)
end

function var0_0.OnEnd(arg0_123)
	if arg0_123.conentTxt then
		arg0_123.conentTxt.fontSize = arg0_123.defualtFontSize
		arg0_123.conentTxt.text = ""
	end

	if arg0_123.nameTxt then
		arg0_123.nameTxt.text = ""
	end

	arg0_123:ClearGlitchArtForPortrait()
	arg0_123:ClearCanMarkNode()

	local var0_123 = {
		"actorLeft",
		"actorMiddle",
		"actorRgiht"
	}

	arg0_123:RecyclePainting(var0_123)

	for iter0_123, iter1_123 in ipairs({
		"actorLeft",
		"actorMiddle",
		"actorRgiht"
	}) do
		arg0_123[iter1_123]:GetComponent(typeof(CanvasGroup)).alpha = 1
	end
end

return var0_0
