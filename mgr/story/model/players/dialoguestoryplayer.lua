local var0_0 = class("DialogueStoryPlayer", import(".StoryPlayer"))
local var1_0 = 159
local var2_0 = 411
local var3_0 = 250

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
	arg0_2.conentLineTr = arg0_2:findTF("line", arg0_2.dialogueWin)
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

	arg0_3:UpdateContentPosition(arg1_3)
	arg0_3:SetContentBgAlpha(arg1_3:GetContentBGAlpha())
	arg3_3()
end

function var0_0.UpdateContentPosition(arg0_4, arg1_4)
	local var0_4 = arg1_4:ExistPortrait()
	local var1_4 = arg1_4:IsMiniPortrait()
	local var2_4 = var0_4 and (var1_4 and var3_0 or var2_0) or var1_0

	arg0_4.conentTr.offsetMin = Vector2(var2_4, arg0_4.conentTr.offsetMin.y)

	local var3_4 = var1_4 and var3_0 or var1_0

	arg0_4.conentLineTr.offsetMin = Vector2(var3_4, arg0_4.conentLineTr.offsetMin.y)
end

local function var4_0(arg0_5, arg1_5)
	if not arg1_5 then
		return false
	end

	local var0_5

	if arg0_5:IsLive2dPainting() then
		var0_5 = arg1_5:Find("live2d")
	elseif arg0_5:IsSpinePainting() then
		var0_5 = arg1_5:Find("spine")
	else
		var0_5 = arg1_5:Find("fitter")
	end

	if var0_5.childCount <= 0 then
		return false
	end

	return var0_5:GetChild(0).name == arg0_5:GetPainting()
end

function var0_0.GetRecycleActorList(arg0_6, arg1_6, arg2_6)
	local var0_6 = arg1_6:GetSide()
	local var1_6 = arg0_6:GetSideTF(var0_6)
	local var2_6 = {}

	if arg1_6:HideOtherPainting() then
		var2_6 = {
			arg0_6.actorLeft,
			arg0_6.actorMiddle,
			arg0_6.actorRgiht
		}
	else
		if arg2_6 and arg2_6:IsDialogueMode() and arg1_6:IsDialogueMode() and arg1_6:IsSameSide(arg2_6) and arg1_6:IsSamePainting(arg2_6) or var4_0(arg1_6, var1_6) then
			-- block empty
		else
			table.insert(var2_6, var1_6)
		end

		if var0_6 == DialogueStep.SIDE_MIDDLE then
			table.insert(var2_6, arg0_6.actorLeft)
			table.insert(var2_6, arg0_6.actorRgiht)
		end
	end

	return var2_6
end

function var0_0.ResetActorTF(arg0_7, arg1_7, arg2_7)
	local var0_7 = arg1_7:GetSide()
	local var1_7 = arg0_7:GetSideTF(var0_7)

	if var1_7 then
		arg0_7:CancelTween(var1_7.gameObject)

		var1_7.localScale = Vector3(1, 1, 1)
		var1_7.eulerAngles = Vector3(0, 0, 0)

		if var1_7 == arg0_7.actorRgiht then
			var1_7.localPosition = arg0_7.initActorRgihtPos
		elseif var1_7 == arg0_7.actorMiddle then
			var1_7.localPosition = arg0_7.initActorMiddlePos
		elseif var1_7 == arg0_7.actorLeft then
			var1_7.localPosition = arg0_7.initActorLeftPos
		end
	end

	local var2_7 = arg0_7:GetRecycleActorList(arg1_7, arg2_7)

	if var1_7 and _.all(var2_7, function(arg0_8)
		return arg0_8 ~= var1_7
	end) then
		arg0_7.paintingStay = true

		arg0_7:ResetMeshPainting(var1_7)

		if arg1_7:IsSpinePainting() then
			arg0_7:HideSpineEffect(var1_7, arg1_7)
		end
	end

	arg0_7:RecyclePaintingList(var2_7)
	arg0_7:RecyclesSubPantings(arg0_7.subActorMiddle)
	arg0_7:RecyclesSubPantings(arg0_7.subActorRgiht)
	arg0_7:RecyclesSubPantings(arg0_7.subActorLeft)

	for iter0_7, iter1_7 in ipairs({
		arg0_7.actorLeft,
		arg0_7.actorMiddle,
		arg0_7.actorRgiht
	}) do
		iter1_7:GetComponent(typeof(CanvasGroup)).alpha = 1
	end
end

function var0_0.HideSpineEffect(arg0_9, arg1_9)
	arg0_9.spineEffectOrderCaches = {}

	local function var0_9(arg0_10)
		local var0_10 = arg0_10:GetComponentsInChildren(typeof("UnityEngine.ParticleSystemRenderer"))

		for iter0_10 = 1, var0_10.Length do
			local var1_10 = var0_10[iter0_10 - 1]
			local var2_10 = ReflectionHelp.RefGetProperty(typeof("UnityEngine.ParticleSystemRenderer"), "sortingOrder", var1_10)

			ReflectionHelp.RefSetProperty(typeof("UnityEngine.ParticleSystemRenderer"), "sortingOrder", var1_10, -1)

			arg0_9.spineEffectOrderCaches[var1_10] = var2_10
		end
	end

	local var1_9 = arg1_9:Find("spine")
	local var2_9 = arg1_9:Find("spinebg")

	var0_9(var1_9)
	var0_9(var2_9)
end

function var0_0.RevertSpineEffect(arg0_11, arg1_11, arg2_11)
	if not arg2_11 then
		return
	end

	local function var0_11(arg0_12)
		local var0_12 = arg0_12:GetComponentsInChildren(typeof("UnityEngine.ParticleSystemRenderer"))

		for iter0_12 = 1, var0_12.Length do
			local var1_12 = var0_12[iter0_12 - 1]
			local var2_12 = arg2_11[var1_12] or 950

			ReflectionHelp.RefSetProperty(typeof("UnityEngine.ParticleSystemRenderer"), "sortingOrder", var1_12, var2_12)
		end
	end

	local var1_11 = arg1_11:Find("spine")
	local var2_11 = arg1_11:Find("spinebg")

	var0_11(var1_11)
	var0_11(var2_11)
end

function var0_0.OnInit(arg0_13, arg1_13, arg2_13, arg3_13)
	local var0_13 = {
		function(arg0_14)
			arg0_13:UpdateContent(arg1_13, arg0_14)
		end,
		function(arg0_15)
			arg0_13:UpdatePortrait(arg1_13, arg0_15)
		end,
		function(arg0_16)
			arg0_13:UpdateSubPaintings(arg1_13, arg0_16)
		end,
		function(arg0_17)
			arg0_13:UpdatePainting(arg1_13, arg2_13, arg0_17)
		end,
		function(arg0_18)
			arg0_13:GrayingInPainting(arg1_13, arg2_13, arg0_18)
		end,
		function(arg0_19)
			arg0_13:StartMovePrevPaintingToSide(arg1_13, arg2_13, arg0_19)
		end,
		function(arg0_20)
			arg0_13:GrayingOutPrevPainting(arg2_13, arg1_13, arg0_20)
		end
	}

	parallelAsync(var0_13, arg3_13)
end

function var0_0.UpdatePortrait(arg0_21, arg1_21, arg2_21)
	if not arg1_21:ExistPortrait() then
		arg2_21()

		return
	end

	local var0_21 = arg1_21:GetPortrait()

	LoadSpriteAsync("StoryIcon/" .. var0_21, function(arg0_22)
		setImageSprite(arg0_21.portraitTr, arg0_22, true)
		setActive(arg0_21.portraitTr, true)
		arg0_21:AdjustPortraitPosition(arg1_21)

		if arg1_21:ShouldGlitchArtForPortrait() then
			arg0_21:SetGlitchArtForPortrait()
		else
			arg0_21:ClearGlitchArtForPortrait()
		end

		arg2_21()
	end)
end

function var0_0.AdjustPortraitPosition(arg0_23, arg1_23)
	if arg1_23:IsMiniPortrait() then
		setAnchoredPosition3D(arg0_23.portraitTr, {
			x = 211,
			y = 133
		})
	else
		local var0_23 = arg0_23.portraitTr.sizeDelta.x < var2_0 and var2_0 or 539

		setAnchoredPosition3D(arg0_23.portraitTr, {
			y = 0,
			x = var0_23
		})
	end
end

function var0_0.SetGlitchArtForPortrait(arg0_24)
	if arg0_24.portraitImg.material ~= arg0_24.glitchArtMaterialForPainting then
		arg0_24.portraitImg.material = arg0_24.glitchArtMaterialForPainting
	end
end

function var0_0.ClearGlitchArtForPortrait(arg0_25)
	if not arg0_25.portraitImg then
		return
	end

	if arg0_25.portraitImg.material ~= arg0_25.portraitImg.defaultGraphicMaterial then
		arg0_25.portraitImg.material = arg0_25.portraitImg.defaultGraphicMaterial
	end
end

function var0_0.UpdateSubPaintings(arg0_26, arg1_26, arg2_26)
	local var0_26, var1_26, var2_26, var3_26 = arg0_26:GetSideTF(arg1_26:GetSide())

	if not arg1_26:ExistPainting() then
		arg2_26()

		return
	end

	arg0_26:InitSubPainting(var3_26, arg1_26:GetSubPaintings(), arg1_26)

	if arg1_26:NeedDispppearSubPainting() then
		arg0_26:DisappearSubPainting(var3_26, arg1_26, arg2_26)
	else
		arg2_26()
	end
end

function var0_0.OnStartUIAnimations(arg0_27, arg1_27, arg2_27)
	if not arg1_27:ShouldShakeDailogue() then
		arg2_27()

		return
	end

	local var0_27 = arg1_27:GetShakeDailogueData()
	local var1_27 = var0_27.x
	local var2_27 = var0_27.number
	local var3_27 = var0_27.delay
	local var4_27 = var0_27.speed
	local var5_27 = arg0_27.dialogueWin.localPosition.x

	arg0_27:TweenMovex(arg0_27.dialogueWin, var1_27, var5_27, var4_27, var3_27, var2_27, arg2_27)
end

function var0_0.OnEnter(arg0_28, arg1_28, arg2_28, arg3_28)
	parallelAsync({
		function(arg0_29)
			arg0_28:UpdateCanMarkNode(arg1_28, arg0_29)
		end,
		function(arg0_30)
			arg0_28:UpdateIcon(arg1_28, arg0_30)
		end
	}, arg3_28)
end

local function var5_0(arg0_31, arg1_31)
	ResourceMgr.Inst:getAssetAsync("Story/" .. arg0_31, "", UnityEngine.Events.UnityAction_UnityEngine_Object(function(arg0_32)
		arg1_31(arg0_32)
	end), true, true)
end

local function var6_0(arg0_33, arg1_33)
	if not arg1_33 then
		return false
	end

	return arg0_33:GetCanMarkNodeData().name == arg1_33.name
end

function var0_0.UpdateCanMarkNode(arg0_34, arg1_34, arg2_34)
	local var0_34 = arg1_34:ExistCanMarkNode()

	if not var0_34 or not var6_0(arg1_34, arg0_34.canMarkNode) then
		arg0_34:ClearCanMarkNode(arg0_34.canMarkNode)
	end

	if not var0_34 then
		arg2_34()

		return
	end

	local var1_34 = arg1_34:GetCanMarkNodeData()

	local function var2_34(arg0_35)
		eachChild(arg0_35, function(arg0_36)
			local var0_36 = table.contains(var1_34.marks, arg0_36.gameObject.name)

			if var0_36 ~= isActive(arg0_36) then
				setActive(arg0_36, var0_36)
			end
		end)
	end

	if not arg0_34.canMarkNode then
		var5_0(var1_34.name, function(arg0_37)
			if arg0_34.stop or not arg0_37 then
				arg2_34()

				return
			end

			local var0_37 = Object.Instantiate(arg0_37, arg0_34.backPanel)

			arg0_34.canMarkNode = {
				name = var1_34.name,
				go = var0_37
			}

			var2_34(var0_37)
			arg2_34()
		end)
	else
		var2_34(arg0_34.canMarkNode.go)
		arg2_34()
	end
end

function var0_0.ClearCanMarkNode(arg0_38)
	if arg0_38.canMarkNode then
		Destroy(arg0_38.canMarkNode.go)

		arg0_38.canMarkNode = nil
	end
end

function var0_0.GrayingOutPrevPainting(arg0_39, arg1_39, arg2_39, arg3_39)
	if not arg1_39 or not arg1_39:IsDialogueMode() then
		arg3_39()

		return
	end

	local var0_39 = arg0_39:GetSideTF(arg2_39:GetPrevSide(arg1_39))

	if var0_39 and arg2_39 and arg2_39:IsDialogueMode() and arg2_39:ShouldGrayingOutPainting(arg1_39) then
		local var1_39 = arg1_39:GetPaintingData()
		local var2_39 = arg1_39:GetPaintingAlpha() or 1

		arg0_39:fadeTransform(var0_39, var2_39, var1_39.alpha, var1_39.time, false, arg3_39)
	else
		arg3_39()
	end
end

function var0_0.GrayingInPainting(arg0_40, arg1_40, arg2_40, arg3_40)
	if not arg1_40:ExistPainting() then
		arg3_40()

		return
	end

	if arg2_40 and arg2_40:IsDialogueMode() and arg1_40:ShouldGrayingPainting(arg2_40) then
		local var0_40 = arg0_40:GetSideTF(arg1_40:GetSide())
		local var1_40 = arg1_40:GetPaintingData()

		if not IsNil(var0_40) and not arg1_40:GetPaintingAlpha() then
			arg0_40:fadeTransform(var0_40, var1_40.alpha, 1, var1_40.time, false)
		end
	end

	arg3_40()
end

function var0_0.UpdateTypeWriter(arg0_41, arg1_41, arg2_41)
	local var0_41 = arg1_41:GetTypewriter()

	if not var0_41 then
		arg2_41()

		return
	end

	function arg0_41.typewriter.endFunc()
		arg0_41.typewriterSpeed = 0
		arg0_41.typewriter.endFunc = nil

		removeOnButton(arg0_41._tf)
		arg2_41()
	end

	arg0_41.typewriterSpeed = math.max((var0_41.speed or 0.1) * arg0_41.timeScale, 0.001)

	local var1_41 = var0_41.speedUp or arg0_41.typewriterSpeed

	arg0_41.typewriter:setSpeed(arg0_41.typewriterSpeed)
	arg0_41.typewriter:Play()
	onButton(arg0_41, arg0_41._tf, function()
		if arg0_41.puase or arg0_41.stop then
			return
		end

		arg0_41.typewriterSpeed = math.min(arg0_41.typewriterSpeed, var1_41)

		arg0_41.typewriter:setSpeed(arg0_41.typewriterSpeed)
	end, SFX_PANEL)
end

function var0_0.UpdatePainting(arg0_44, arg1_44, arg2_44, arg3_44)
	if not arg1_44:ExistPainting() then
		arg3_44()

		return
	end

	local var0_44 = not arg0_44.paintingStay

	if arg0_44.paintingStay and arg0_44.spineEffectOrderCaches and arg1_44:IsSpinePainting() then
		local var1_44 = arg0_44:GetSideTF(arg1_44:GetSide())

		arg0_44:RevertSpineEffect(var1_44, arg0_44.spineEffectOrderCaches)
	end

	arg0_44.spineEffectOrderCaches = nil
	arg0_44.paintingStay = nil

	local var2_44, var3_44, var4_44, var5_44 = arg0_44:GetSideTF(arg1_44:GetSide())
	local var6_44 = arg2_44 and arg2_44:IsDialogueMode() and (arg1_44:ShouldGrayingOutPainting(arg2_44) or arg1_44:ShouldGrayingPainting(arg2_44)) or not arg1_44:ShouldFadeInPainting() or not var0_44
	local var7_44 = arg2_44 and arg2_44:IsDialogueMode() and arg1_44:ShouldGrayingPainting(arg2_44)

	seriesAsync({
		function(arg0_45)
			if not var6_44 then
				var2_44:GetComponent(typeof(CanvasGroup)).alpha = 0
			end

			arg0_44:LoadPainting(arg1_44, var0_44, arg0_45)

			if var7_44 then
				local var0_45 = arg1_44:GetPaintingData()

				arg0_44:SetFadeColor(var2_44, var0_45.alpha)
			end
		end,
		function(arg0_46)
			if var6_44 then
				arg0_46()

				return
			end

			arg0_44:FadeInPainting(var2_44, arg1_44, arg0_46)
		end,
		function(arg0_47)
			arg0_44:AnimationPainting(arg1_44, arg0_47)
		end
	}, arg3_44)
end

function var0_0.FadeInPainting(arg0_48, arg1_48, arg2_48, arg3_48)
	local var0_48 = arg1_48:GetComponent(typeof(CanvasGroup))
	local var1_48 = arg2_48:GetFadeInPaintingTime()
	local var2_48 = arg2_48:ShouldAddHeadMaskWhenFade()

	if var2_48 then
		arg0_48:AddHeadMask(arg1_48)
	end

	arg0_48:TweenValueForcanvasGroup(var0_48, 0, 1, var1_48, 0, function()
		if var2_48 then
			arg0_48:ClearHeadMask(arg1_48)
		end

		arg3_48()
	end)
end

function var0_0.AddHeadMask(arg0_50, arg1_50)
	local var0_50 = arg1_50:Find("fitter")

	if not var0_50 or var0_50.childCount <= 0 then
		return
	end

	local var1_50 = var0_50:GetChild(0)
	local var2_50 = var1_50:Find("face")
	local var3_50 = cloneTplTo(var2_50, var2_50.parent, "head_mask")
	local var4_50 = var1_50:Find("layers")
	local var5_50 = arg1_50:GetComponentsInChildren(typeof(Image))

	if var4_50 then
		for iter0_50 = 0, var5_50.Length - 1 do
			local var6_50 = var5_50[iter0_50]

			if var6_50.gameObject.name == "head_mask" then
				var6_50.material = arg0_50.headMaskMat
			elseif var6_50.gameObject.name == "face" then
				-- block empty
			elseif var6_50.gameObject.transform.parent == var4_50 then
				var6_50.material = arg0_50.headObjectMat
			end
		end
	else
		for iter1_50 = 0, var5_50.Length - 1 do
			local var7_50 = var5_50[iter1_50]

			if var7_50.gameObject.name == "head_mask" then
				var7_50.material = arg0_50.headMaskMat
			elseif var7_50.gameObject.name == "face" then
				-- block empty
			else
				var7_50.material = arg0_50.headObjectMat
			end
		end
	end
end

function var0_0.ClearHeadMask(arg0_51, arg1_51)
	local var0_51 = arg1_51:Find("fitter")

	if not var0_51 or var0_51.childCount <= 0 then
		return
	end

	local var1_51 = var0_51:GetChild(0):Find("head_mask")

	Destroy(var1_51.gameObject)

	local var2_51 = arg1_51:GetComponentsInChildren(typeof(Image))

	for iter0_51 = 0, var2_51.Length - 1 do
		local var3_51 = var2_51[iter0_51]

		var3_51.material = var3_51.defaultGraphicMaterial
	end
end

function var0_0.AnimationPainting(arg0_52, arg1_52, arg2_52)
	if arg1_52:IsLive2dPainting() or arg1_52:IsSpinePainting() then
		arg2_52()

		return
	end

	local var0_52, var1_52, var2_52, var3_52 = arg0_52:GetSideTF(arg1_52:GetSide())

	arg0_52:StartPaintingActions(var0_52, arg1_52, arg2_52)
end

function var0_0.LoadPainting(arg0_53, arg1_53, arg2_53, arg3_53)
	local var0_53, var1_53, var2_53, var3_53 = arg0_53:GetSideTF(arg1_53:GetSide())
	local var4_53, var5_53 = arg1_53:GetPaintingAndName()

	if arg1_53:IsLive2dPainting() and checkABExist("live2d/" .. var5_53) then
		arg0_53:UpdateLive2dPainting(arg1_53, var0_53, arg2_53, arg3_53)
	elseif arg1_53:IsSpinePainting() and checkABExist("spinepainting/" .. var5_53) then
		arg0_53:UpdateSpinePainting(arg1_53, var0_53, arg2_53, arg3_53)
	else
		arg0_53:UpdateMeshPainting(arg1_53, var0_53, var3_53, arg2_53, arg3_53)
	end
end

function var0_0.UpdateLive2dPainting(arg0_54, arg1_54, arg2_54, arg3_54, arg4_54)
	local function var0_54(arg0_55)
		local var0_55 = arg1_54:GetVirtualShip()
		local var1_55 = arg1_54:GetLive2dPos()
		local var2_55 = Live2D.GenerateData({
			ship = var0_55,
			scale = Vector3(70, 70, 70),
			position = var1_55 or Vector3(0, 0, 0),
			parent = arg2_54:Find("live2d")
		})
		local var3_55 = GetOrAddComponent(arg0_54._go, typeof(CanvasGroup))

		var3_55.blocksRaycasts = false

		local var4_55 = Live2D.New(var2_55, function(arg0_56)
			arg0_56._go.name = arg1_54:GetPainting()

			local var0_56 = arg0_56._go:GetComponent("Live2D.Cubism.Rendering.CubismRenderController")
			local var1_56 = arg0_54.sortingOrder + 1
			local var2_56 = typeof("Live2D.Cubism.Rendering.CubismRenderController")

			ReflectionHelp.RefSetProperty(var2_56, "SortingOrder", var0_56, var1_56)

			local var3_56 = ReflectionHelp.RefGetField(typeof("Live2D.Cubism.Rendering.CubismSortingMode"), "BackToFrontOrder")

			ReflectionHelp.RefSetProperty(var2_56, "SortingMode", var0_56, var3_56)

			local var4_56 = GetOrAddComponent(arg0_54.front, typeof(Canvas))

			GetOrAddComponent(arg0_54.front, typeof(GraphicRaycaster))

			var4_56.overrideSorting = true
			var4_56.sortingOrder = var1_56 + arg0_56._tf:Find("Drawables").childCount
			var3_55.blocksRaycasts = true

			if arg0_55 then
				arg0_55(arg0_56)
			end
		end)

		arg0_54.live2dChars[arg2_54] = var4_55
	end

	local function var1_54(arg0_57)
		if arg0_57 then
			local var0_57 = arg1_54:GetLive2dAction()

			if var0_57 and var0_57 ~= "" then
				arg0_57:TriggerAction(var0_57)
			end

			local var1_57 = arg1_54:GetL2dIdleIndex()

			if var1_57 and var1_57 ~= "" and var1_57 > 0 then
				arg0_57:changeIdleIndex(var1_57)
			end
		end

		arg4_54()
	end

	if not arg3_54 and arg0_54.live2dChars[arg2_54] then
		local var2_54 = arg0_54.live2dChars[arg2_54]

		var1_54(var2_54)
	else
		var0_54(var1_54)
	end
end

local function var7_0(arg0_58, arg1_58, arg2_58)
	local var0_58 = arg0_58:GetComponentsInChildren(typeof(Canvas))
	local var1_58

	for iter0_58 = 1, var0_58.Length do
		var1_58 = var0_58[iter0_58 - 1].sortingOrder
	end

	local var2_58 = math.huge
	local var3_58 = arg1_58:GetComponentsInChildren(typeof(Canvas))

	if var3_58.Length == 0 then
		var2_58 = 0
	else
		for iter1_58 = 1, var3_58.Length do
			local var4_58 = var3_58[iter1_58 - 1].sortingOrder - var1_58

			if var4_58 < var2_58 then
				var2_58 = var4_58
			end
		end
	end

	local var5_58 = arg1_58:GetComponentsInChildren(typeof("UnityEngine.ParticleSystemRenderer"))
	local var6_58 = {}

	for iter2_58 = 1, var5_58.Length do
		local var7_58 = var5_58[iter2_58 - 1]
		local var8_58 = ReflectionHelp.RefGetProperty(typeof("UnityEngine.ParticleSystemRenderer"), "sortingOrder", var7_58)

		var6_58[iter2_58] = var8_58

		local var9_58 = var8_58 - var1_58

		if var9_58 < var2_58 then
			var2_58 = var9_58
		end
	end

	local var10_58 = arg2_58 - var2_58 + 1

	for iter3_58 = 1, var0_58.Length do
		var0_58[iter3_58 - 1].sortingOrder = var10_58 + (iter3_58 - 1)
	end

	local var11_58 = var10_58 + 1

	for iter4_58 = 1, var3_58.Length do
		local var12_58 = var3_58[iter4_58 - 1]
		local var13_58 = var10_58 + (var12_58.sortingOrder - var1_58)

		var12_58.sortingOrder = var13_58

		if var10_58 < var13_58 then
			var11_58 = var13_58
		end
	end

	for iter5_58 = 1, var5_58.Length do
		local var14_58 = var5_58[iter5_58 - 1]
		local var15_58 = var10_58 + (var6_58[iter5_58] - var1_58)

		ReflectionHelp.RefSetProperty(typeof("UnityEngine.ParticleSystemRenderer"), "sortingOrder", var14_58, var15_58)

		if var10_58 < var15_58 then
			var11_58 = var15_58
		end
	end

	return var11_58
end

local function var8_0(arg0_59, arg1_59, arg2_59)
	local var0_59 = arg0_59:GetComponentsInChildren(typeof(Canvas))
	local var1_59 = arg0_59:GetComponentsInChildren(typeof("UnityEngine.ParticleSystemRenderer"))
	local var2_59 = math.huge

	if var0_59.Length == 0 then
		var2_59 = 0
	else
		for iter0_59 = 1, var0_59.Length do
			local var3_59 = var0_59[iter0_59 - 1].sortingOrder

			if var3_59 < var2_59 then
				var2_59 = var3_59
			end
		end
	end

	local var4_59 = {}

	for iter1_59 = 1, var1_59.Length do
		local var5_59 = var1_59[iter1_59 - 1]
		local var6_59 = ReflectionHelp.RefGetProperty(typeof("UnityEngine.ParticleSystemRenderer"), "sortingOrder", var5_59)

		var4_59[iter1_59] = var6_59

		if var6_59 < var2_59 then
			var2_59 = var6_59
		end
	end

	local var7_59 = arg2_59 + 1
	local var8_59 = var7_59 - var2_59

	for iter2_59 = 1, var0_59.Length do
		local var9_59 = var0_59[iter2_59 - 1]
		local var10_59 = var8_59 + var9_59.sortingOrder

		var9_59.sortingOrder = var10_59

		if var7_59 < var10_59 then
			var7_59 = var10_59
		end
	end

	for iter3_59 = 1, var1_59.Length do
		local var11_59 = var1_59[iter3_59 - 1]
		local var12_59 = var8_59 + var4_59[iter3_59]

		ReflectionHelp.RefSetProperty(typeof("UnityEngine.ParticleSystemRenderer"), "sortingOrder", var11_59, var12_59)

		if var12_59 < var7_59 then
			var7_59 = var12_59
		end
	end

	return var7_59
end

function var0_0.UpdateSpinePainting(arg0_60, arg1_60, arg2_60, arg3_60, arg4_60)
	local function var0_60(arg0_61)
		local var0_61 = arg2_60:Find("spine")
		local var1_61 = arg2_60:Find("spinebg")
		local var2_61 = arg1_60:GetVirtualShip()
		local var3_61 = SpinePainting.GenerateData({
			ship = var2_61,
			position = Vector3(0, 0, 0),
			parent = var0_61,
			effectParent = var1_61
		})

		setActive(var1_61, not arg1_60:IsHideSpineBg())

		local var4_61 = SpinePainting.New(var3_61, function(arg0_62)
			arg0_62._go.name = arg1_60:GetPainting()

			local var0_62 = arg0_60.sortingOrder
			local var1_62 = arg1_60:GetSpineOrderIndex()

			if not var1_62 then
				var0_62 = var7_0(var0_61, var1_61, arg0_60.sortingOrder)
			else
				var0_62 = var8_0(var0_61, var1_62, arg0_60.sortingOrder)
			end

			local var2_62 = GetOrAddComponent(arg0_60.front, typeof(Canvas))

			GetOrAddComponent(arg0_60.front, typeof(GraphicRaycaster))

			var2_62.overrideSorting = true
			var2_62.sortingOrder = var0_62 + 1

			arg0_60:UpdateSpineExpression(arg0_62, arg1_60)

			if arg0_61 then
				arg0_61()
			end
		end)

		arg0_60.spinePainings[arg2_60] = var4_61
	end

	if not arg3_60 and arg0_60.spinePainings[arg2_60] then
		arg0_60:UpdateSpineExpression(arg0_60.spinePainings[arg2_60], arg1_60)
		arg4_60()
	else
		var0_60(arg4_60)
	end
end

function var0_0.UpdateSpineExpression(arg0_63, arg1_63, arg2_63)
	local var0_63 = arg2_63:GetSpineExPression()

	if var0_63 then
		arg1_63:SetAction(var0_63, 1)
	else
		arg1_63:SetEmptyAction(1)
	end
end

function var0_0.UpdateMeshPainting(arg0_64, arg1_64, arg2_64, arg3_64, arg4_64, arg5_64)
	local var0_64 = arg1_64:GetPainting()
	local var1_64 = false

	local function var2_64()
		if arg1_64:IsShowNPainting() and checkABExist("painting/" .. var0_64 .. "_n") then
			var0_64 = var0_64 .. "_n"
		end

		if arg1_64:IsShowWJZPainting() and checkABExist("painting/" .. var0_64 .. "_wjz") then
			var0_64 = var0_64 .. "_wjz"
		end

		setPaintingPrefab(arg2_64, var0_64, "duihua")
	end

	if var0_64 then
		local var3_64 = findTF(arg2_64, "fitter").childCount

		if arg4_64 or var3_64 <= 0 then
			var2_64()
		end

		local var4_64 = arg1_64:GetPaintingDir()
		local var5_64 = math.abs(var4_64)

		if arg1_64:ShouldFlipPaintingY() then
			var5_64 = -var5_64
		end

		arg2_64.localScale = Vector3(var4_64, var5_64, 1)

		local var6_64 = findTF(arg2_64, "fitter"):GetChild(0)

		var6_64.name = var0_64

		arg0_64:UpdateActorPostion(arg2_64, arg1_64)
		arg0_64:UpdateExpression(var6_64, arg1_64)
		arg0_64:AddGlitchArtEffectForPating(arg2_64, var6_64, arg1_64)
		arg2_64:SetAsLastSibling()

		if arg1_64:ShouldGrayPainting() then
			setGray(var6_64, true, true)
		end

		local var7_64 = findTF(var6_64, "shadow")

		if var7_64 then
			setActive(var7_64, arg1_64:ShouldFaceBlack())
		end

		local var8_64 = arg1_64:GetPaintingAlpha()

		if var8_64 then
			arg0_64:setPaintingAlpha(arg2_64, var8_64)
		end
	end

	arg5_64()
end

local function var9_0(arg0_66)
	local var0_66 = arg0_66.name

	if arg0_66.showNPainting and checkABExist("painting/" .. var0_66 .. "_n") then
		var0_66 = var0_66 .. "_n"
	end

	return var0_66
end

function var0_0.InitSubPainting(arg0_67, arg1_67, arg2_67, arg3_67)
	local function var0_67(arg0_68, arg1_68)
		local var0_68 = var9_0(arg0_68)

		setPaintingPrefab(arg1_68, var0_68, "duihua")

		local var1_68 = findTF(arg1_68, "fitter"):GetChild(0)
		local var2_68 = findTF(var1_68, "face")
		local var3_68 = arg0_68.expression

		if not arg0_68.expression and arg0_68.name and ShipExpressionHelper.DefaultFaceless(arg0_68.name) then
			var3_68 = ShipExpressionHelper.GetDefaultFace(arg0_68.name)
		end

		if var3_68 then
			setActive(var2_68, true)

			local var4_68 = GetSpriteFromAtlas("paintingface/" .. arg0_68.name, arg0_68.expression)

			setImageSprite(var2_68, var4_68)
		end

		if arg0_68.pos then
			setAnchoredPosition(arg1_68, arg0_68.pos)
		end

		if arg0_68.dir then
			arg1_68.transform.localScale = Vector3(arg0_68.dir, 1, 1)
		end

		if arg0_68.paintingNoise then
			arg0_67:AddGlitchArtEffectForPating(arg1_68, var1_68, arg3_67)
		end
	end

	arg1_67:make(function(arg0_69, arg1_69, arg2_69)
		if arg0_69 == UIItemList.EventUpdate then
			var0_67(arg2_67[arg1_69 + 1], arg2_69)
		end
	end)
	arg1_67:align(#arg2_67)
end

function var0_0.DisappearSubPainting(arg0_70, arg1_70, arg2_70, arg3_70)
	local var0_70 = arg2_70:GetSubPaintings()
	local var1_70, var2_70 = arg2_70:GetDisappearTime()
	local var3_70 = arg2_70:GetDisappearSeq()
	local var4_70 = {}
	local var5_70 = {}

	for iter0_70, iter1_70 in ipairs(var0_70) do
		table.insert(var5_70, iter1_70)
	end

	for iter2_70, iter3_70 in ipairs(var3_70) do
		local var6_70 = iter3_70

		table.insert(var4_70, function(arg0_71)
			for iter0_71, iter1_71 in ipairs(var5_70) do
				if iter1_71.actor == var6_70 then
					table.remove(var5_70, iter0_71)

					break
				end
			end

			arg0_70:InitSubPainting(arg1_70, var5_70, arg2_70)
			arg0_70:DelayCall(var2_70, arg0_71)
		end)
	end

	arg1_70.container:SetAsFirstSibling()
	arg0_70:DelayCall(var1_70, function()
		seriesAsync(var4_70, function()
			arg1_70.container:SetAsLastSibling()
			arg3_70()
		end)
	end)
end

function var0_0.UpdateActorPostion(arg0_74, arg1_74, arg2_74)
	local var0_74 = arg2_74:GetPaitingOffst()

	if var0_74 then
		local var1_74 = arg1_74.localPosition

		arg1_74.localPosition = Vector3(var1_74.x + (var0_74.x or 0), var1_74.y + (var0_74.y or 0), 0)
	end
end

function var0_0.UpdateExpression(arg0_75, arg1_75, arg2_75)
	local var0_75 = arg2_75:GetExPression()
	local var1_75 = findTF(arg1_75, "face")

	if var0_75 then
		local var2_75 = arg2_75:GetPainting()
		local var3_75 = GetSpriteFromAtlas("paintingface/" .. var2_75, var0_75)

		setActive(var1_75, true)
		setImageSprite(var1_75, var3_75)
	else
		setActive(var1_75, false)
	end
end

function var0_0.StartPaintingActions(arg0_76, arg1_76, arg2_76, arg3_76)
	local var0_76 = {
		function(arg0_77)
			arg0_76:StartPatiningMoveAction(arg1_76, arg2_76, arg0_77)
		end,
		function(arg0_78)
			arg0_76:StartPatiningShakeAction(arg1_76, arg2_76, arg0_78)
		end,
		function(arg0_79)
			arg0_76:StartPatiningZoomAction(arg1_76, arg2_76, arg0_79)
		end,
		function(arg0_80)
			arg0_76:StartPatiningRotateAction(arg1_76, arg2_76, arg0_80)
		end
	}

	parallelAsync(var0_76, function()
		if arg3_76 then
			arg3_76()
		end
	end)
end

function var0_0.StartPatiningShakeAction(arg0_82, arg1_82, arg2_82, arg3_82)
	local var0_82 = arg2_82:GetPaintingAction(DialogueStep.PAINTING_ACTION_SHAKE)

	if not var0_82 then
		arg3_82()

		return
	end

	local function var1_82(arg0_83, arg1_83)
		local var0_83 = arg0_83.x or 0
		local var1_83 = arg0_83.y or 10
		local var2_83 = arg0_83.dur or 1
		local var3_83 = arg0_83.delay or 0
		local var4_83 = arg0_83.number or 1
		local var5_83 = tf(arg1_82).localPosition

		arg0_82:TweenMove(arg1_82, Vector3(var5_83.x + var0_83, var5_83.y + var1_83, 0), var2_83, var4_83, var3_83, arg1_83)
	end

	local var2_82 = {}

	for iter0_82, iter1_82 in pairs(var0_82) do
		table.insert(var2_82, function(arg0_84)
			var1_82(iter1_82, arg0_84)
		end)
	end

	parallelAsync(var2_82, function()
		if arg3_82 then
			arg3_82()
		end
	end)
end

function var0_0.StartPatiningZoomAction(arg0_86, arg1_86, arg2_86, arg3_86)
	local var0_86 = arg2_86:GetPaintingAction(DialogueStep.PAINTING_ACTION_ZOOM)

	if not var0_86 then
		arg3_86()

		return
	end

	local function var1_86(arg0_87, arg1_87)
		if not arg0_87.from then
			local var0_87 = {
				0,
				0,
				0
			}
		end

		local var1_87 = arg0_87.to or {
			1,
			1,
			1
		}
		local var2_87 = arg0_87.dur or 0
		local var3_87 = arg0_87.delay or 0

		arg0_86:TweenScale(arg1_86, Vector3(var1_87[1], var1_87[2], var1_87[3]), var2_87, var3_87, arg1_87)
	end

	local var2_86 = {}

	for iter0_86, iter1_86 in pairs(var0_86) do
		table.insert(var2_86, function(arg0_88)
			var1_86(iter1_86, arg0_88)
		end)
	end

	parallelAsync(var2_86, function()
		if arg3_86 then
			arg3_86()
		end
	end)
end

function var0_0.StartPatiningRotateAction(arg0_90, arg1_90, arg2_90, arg3_90)
	local var0_90 = arg2_90:GetPaintingAction(DialogueStep.PAINTING_ACTION_ROTATE)

	if not var0_90 then
		arg3_90()

		return
	end

	local function var1_90(arg0_91, arg1_91)
		local var0_91 = arg0_91.value
		local var1_91 = arg0_91.dur or 1
		local var2_91 = arg0_91.number or 1
		local var3_91 = arg0_91.delay or 0

		arg0_90:TweenRotate(arg1_90, var0_91, var1_91, var2_91, var3_91, arg1_91)
	end

	local var2_90 = {}

	for iter0_90, iter1_90 in pairs(var0_90) do
		table.insert(var2_90, function(arg0_92)
			var1_90(iter1_90, arg0_92)
		end)
	end

	parallelAsync(var2_90, function()
		if arg3_90 then
			arg3_90()
		end
	end)
end

function var0_0.StartPatiningMoveAction(arg0_94, arg1_94, arg2_94, arg3_94)
	local var0_94 = arg2_94:GetPaintingAction(DialogueStep.PAINTING_ACTION_MOVE)

	if not var0_94 then
		arg3_94()

		return
	end

	local function var1_94(arg0_95, arg1_95)
		local var0_95 = arg0_95.x or 0
		local var1_95 = arg0_95.y or 0
		local var2_95 = arg0_95.dur or 1
		local var3_95 = arg0_95.delay or 0
		local var4_95 = tf(arg1_94).localPosition

		arg0_94:TweenMove(arg1_94, Vector3(var4_95.x + var0_95, var4_95.y + var1_95, 0), var2_95, 1, var3_95, arg1_95)
	end

	local var2_94 = {}

	for iter0_94, iter1_94 in pairs(var0_94) do
		table.insert(var2_94, function(arg0_96)
			var1_94(iter1_94, arg0_96)
		end)
	end

	parallelAsync(var2_94, function()
		if arg3_94 then
			arg3_94()
		end
	end)
end

function var0_0.StartMovePrevPaintingToSide(arg0_98, arg1_98, arg2_98, arg3_98)
	local var0_98 = arg1_98:GetPaintingMoveToSide()

	if not var0_98 or not arg2_98 then
		arg3_98()

		return
	end

	local var1_98 = arg0_98:GetSideTF(arg2_98:GetSide())

	if not var1_98 then
		arg3_98()

		return
	end

	local var2_98 = var0_98.time
	local var3_98 = var0_98.side
	local var4_98 = arg0_98:GetSideTF(var3_98)

	if not var4_98 then
		arg3_98()

		return
	end

	if arg1_98.side ~= arg2_98.side then
		if var1_98:Find("fitter").childCount > 0 then
			local var5_98 = var1_98:Find("fitter"):GetChild(0)

			removeAllChildren(var4_98:Find("fitter"))
			setParent(var5_98, var4_98:Find("fitter"))

			local var6_98 = arg2_98:GetPaintingDir()

			var4_98.localScale = Vector3(var6_98, math.abs(var6_98), 1)
		end
	else
		local var7_98 = arg2_98:GetPainting()

		if var7_98 then
			setPaintingPrefab(var4_98, var7_98, "duihua")
		end
	end

	local var8_98 = tf(var4_98).localPosition

	arg0_98:TweenValue(var4_98, var1_98.localPosition.x, var8_98.x, var2_98, 0, function(arg0_99)
		setAnchoredPosition(var4_98, {
			x = arg0_99
		})
	end, arg3_98)

	var4_98.localPosition = Vector2(var1_98.localPosition.x, var4_98.localPosition.y, 0)
end

local function var10_0(arg0_100, arg1_100, arg2_100, arg3_100, arg4_100)
	local var0_100 = arg1_100:GetComponentsInChildren(typeof(Image))

	for iter0_100 = 0, var0_100.Length - 1 do
		local var1_100 = var0_100[iter0_100]

		if var1_100.gameObject.name == "temp_mask" then
			var1_100.material = arg4_100 and arg0_100.maskMaterial or arg0_100.maskMaterialForWithLayer
		elseif var1_100.gameObject.name == "face" then
			var1_100.material = arg0_100.glitchArtMaterial
		elseif arg3_100.hasPaintbg and var1_100.gameObject == arg2_100.gameObject then
			var1_100.material = arg0_100.glitchArtMaterialForPaintingBg
		else
			var1_100.material = arg0_100.glitchArtMaterialForPainting
		end
	end
end

local function var11_0(arg0_101, arg1_101, arg2_101, arg3_101, arg4_101)
	local var0_101 = arg1_101:GetComponentsInChildren(typeof(Image))
	local var1_101 = {}
	local var2_101 = arg2_101:GetComponent(typeof(Image))

	if var2_101 then
		table.insert(var1_101, var2_101.gameObject)
	end

	for iter0_101 = 1, arg3_101 - 1 do
		local var3_101 = arg4_101:GetChild(iter0_101 - 1)

		table.insert(var1_101, var3_101.gameObject)
	end

	for iter1_101 = 0, var0_101.Length - 1 do
		local var4_101 = var0_101[iter1_101]

		if var4_101.gameObject.name == "temp_mask" then
			var4_101.material = arg0_101.maskMaterial
		elseif var4_101.gameObject.name == "face" then
			var4_101.material = arg0_101.glitchArtMaterial
		elseif table.contains(var1_101, var4_101.gameObject) then
			var4_101.material = arg0_101.glitchArtMaterialForPaintingBg
		else
			var4_101.material = arg0_101.glitchArtMaterialForPainting
		end
	end
end

function var0_0.AddGlitchArtEffectForPating(arg0_102, arg1_102, arg2_102, arg3_102)
	local var0_102 = arg3_102:ShouldAddGlitchArtEffect()
	local var1_102 = arg3_102:IsNoHeadPainting()

	if var0_102 and arg3_102:GetExPression() ~= nil and not var1_102 then
		local var2_102 = arg2_102:Find("face")

		cloneTplTo(var2_102, var2_102.parent, "temp_mask"):SetAsFirstSibling()

		local var3_102 = arg2_102:Find("layers")
		local var4_102 = IsNil(var3_102)

		if not var4_102 and arg3_102:GetPaintingRwIndex() > 0 then
			var11_0(arg0_102, arg1_102, arg2_102, arg3_102:GetPaintingRwIndex(), var3_102)
		else
			var10_0(arg0_102, arg1_102, arg2_102, arg3_102, var4_102)
		end
	elseif var0_102 then
		local var5_102 = arg1_102:GetComponentsInChildren(typeof(Image))

		for iter0_102 = 0, var5_102.Length - 1 do
			var5_102[iter0_102].material = arg0_102.glitchArtMaterial
		end
	end

	if var0_102 then
		local var6_102 = GameObject.Find("/OverlayCamera/Overlay/UIMain/AwardInfoUI(Clone)/items/SpriteMask")

		if var6_102 and var6_102.activeInHierarchy then
			setActive(var6_102, false)

			arg0_102.spriteMask = var6_102
		end
	end
end

function var0_0.UpdateContent(arg0_103, arg1_103, arg2_103)
	local function var0_103()
		setActive(arg0_103.nextTr, true)
		arg2_103()
	end

	for iter0_103, iter1_103 in ipairs(arg0_103.tags) do
		setActive(iter1_103, iter0_103 == arg1_103:GetTag())
	end

	arg0_103.conentTxt.fontSize = arg1_103:GetFontSize() or arg0_103.defualtFontSize

	local var1_103 = arg1_103:GetContent()

	arg0_103.conentTxt.text = var1_103

	local var2_103 = 999

	if var1_103 and var1_103 ~= "" then
		var2_103 = System.String.New(var1_103).Length
	end

	if var1_103 and var1_103 ~= "" and var1_103 ~= "…" and #var1_103 > 1 and var2_103 > 1 then
		arg0_103:UpdateTypeWriter(arg1_103, var0_103)
	else
		var0_103()
	end

	local var3_103 = false
	local var4_103, var5_103, var6_103, var7_103 = arg0_103:GetSideTF(arg1_103:GetSide())

	if var5_103 then
		local var8_103 = arg1_103:GetNameWithColor()
		local var9_103 = var8_103 and var8_103 ~= ""

		var3_103 = var9_103

		setActive(var5_103, var9_103)

		if var9_103 then
			local var10_103 = arg1_103:GetNameColorCode()

			var5_103:Find("Text"):GetComponent(typeof(Outline)).effectColor = Color.NewHex(var10_103)
		end

		var6_103.text = var8_103

		setText(var6_103.gameObject.transform:Find("subText"), arg1_103:GetSubActorName())
	end

	if arg0_103.script:IsDialogueStyle2() then
		setActive(arg0_103.tag4Dialog2, not var3_103)
	end
end

function var0_0.SetContentBgAlpha(arg0_105, arg1_105)
	if arg0_105.contentBgAlpha ~= arg1_105 then
		for iter0_105, iter1_105 in ipairs(arg0_105.contentBgs) do
			GetOrAddComponent(iter1_105, typeof(CanvasGroup)).alpha = arg1_105
		end

		arg0_105.contentBgAlpha = arg1_105
	end
end

function var0_0.GetSideTF(arg0_106, arg1_106)
	local var0_106
	local var1_106
	local var2_106
	local var3_106

	if DialogueStep.SIDE_LEFT == arg1_106 then
		var0_106, var1_106, var2_106, var3_106 = arg0_106.actorLeft, arg0_106.nameTr, arg0_106.nameTxt, arg0_106.subActorLeft
	elseif DialogueStep.SIDE_RIGHT == arg1_106 then
		var0_106, var1_106, var2_106, var3_106 = arg0_106.actorRgiht, arg0_106.nameTr, arg0_106.nameTxt, arg0_106.subActorRgiht
	elseif DialogueStep.SIDE_MIDDLE == arg1_106 then
		var0_106, var1_106, var2_106, var3_106 = arg0_106.actorMiddle, arg0_106.nameTr, arg0_106.nameTxt, arg0_106.subActorMiddle
	end

	return var0_106, var1_106, var2_106, var3_106
end

function var0_0.RecyclesSubPantings(arg0_107, arg1_107)
	arg1_107:each(function(arg0_108, arg1_108)
		arg0_107:RecyclePainting(arg1_108)
	end)
end

local function var12_0(arg0_109)
	if arg0_109:Find("fitter").childCount == 0 then
		return
	end

	local var0_109 = arg0_109:Find("fitter"):GetChild(0)

	if var0_109 then
		local var1_109 = findTF(var0_109, "shadow")

		if var1_109 then
			setActive(var1_109, false)
		end

		local var2_109 = arg0_109:GetComponentsInChildren(typeof(Image))

		for iter0_109 = 0, var2_109.Length - 1 do
			local var3_109 = var2_109[iter0_109]
			local var4_109 = Color.white

			if var3_109.material ~= var3_109.defaultGraphicMaterial then
				var3_109.material = var3_109.defaultGraphicMaterial
			end

			var3_109.material:SetColor("_Color", var4_109)
		end

		setGray(var0_109, false, true)
		retPaintingPrefab(arg0_109, var0_109.name)

		local var5_109 = var0_109:Find("temp_mask")

		if var5_109 then
			Destroy(var5_109.gameObject)
		end
	end
end

function var0_0.ClearMeshPainting(arg0_110, arg1_110)
	arg0_110:ResetMeshPainting(arg1_110)

	if arg1_110:Find("fitter").childCount == 0 then
		return
	end

	local var0_110 = arg1_110:Find("fitter"):GetChild(0)

	if var0_110 then
		retPaintingPrefab(arg1_110, var0_110.name)
	end
end

function var0_0.ResetMeshPainting(arg0_111, arg1_111)
	if arg1_111:Find("fitter").childCount == 0 then
		return
	end

	local var0_111 = arg1_111:Find("fitter"):GetChild(0)

	if var0_111 then
		local var1_111 = findTF(var0_111, "shadow")

		if var1_111 then
			setActive(var1_111, false)
		end

		local var2_111 = arg1_111:GetComponentsInChildren(typeof(Image))

		for iter0_111 = 0, var2_111.Length - 1 do
			local var3_111 = var2_111[iter0_111]
			local var4_111 = Color.white

			if var3_111.material ~= var3_111.defaultGraphicMaterial then
				var3_111.material = var3_111.defaultGraphicMaterial

				var3_111.material:SetColor("_Color", var4_111)
			else
				var3_111.material = nil
			end
		end

		setGray(var0_111, false, true)

		local var5_111 = var0_111:Find("temp_mask")

		if var5_111 then
			Destroy(var5_111.gameObject)
		end
	end
end

local function var13_0(arg0_112, arg1_112)
	local var0_112 = arg0_112.live2dChars[arg1_112]
	local var1_112 = false

	if var0_112 and var0_112._go then
		local var2_112 = var0_112._go:GetComponent("Live2D.Cubism.Rendering.CubismRenderController")

		ReflectionHelp.RefSetProperty(typeof("Live2D.Cubism.Rendering.CubismRenderController"), "SortingOrder", var2_112, 0)
		var0_112:Dispose()

		arg0_112.live2dChars[arg1_112] = nil
		var1_112 = true
	end

	local var3_112 = table.getCount(arg0_112.live2dChars) <= 0

	if var1_112 and var3_112 then
		RemoveComponent(arg0_112.front, "GraphicRaycaster")
		RemoveComponent(arg0_112.front, "Canvas")
	end
end

local function var14_0(arg0_113, arg1_113)
	local var0_113 = arg0_113.spinePainings[arg1_113]
	local var1_113 = false

	if var0_113 then
		var0_113:Dispose()

		arg0_113.spinePainings[arg1_113] = nil
		var1_113 = true
	end

	local var2_113 = table.getCount(arg0_113.spinePainings) <= 0

	if var1_113 and var2_113 then
		RemoveComponent(arg0_113.front, "GraphicRaycaster")
		RemoveComponent(arg0_113.front, "Canvas")
	end
end

function var0_0.RecyclePainting(arg0_114, arg1_114)
	if type(arg1_114) == "table" then
		local var0_114 = _.map(arg1_114, function(arg0_115)
			return arg0_114[arg0_115]
		end)

		arg0_114:RecyclePaintingList(var0_114)
	else
		arg0_114:ClearMeshPainting(arg1_114)
		var13_0(arg0_114, arg1_114)
		var14_0(arg0_114, arg1_114)
	end
end

function var0_0.RecyclePaintingList(arg0_116, arg1_116)
	for iter0_116, iter1_116 in ipairs(arg1_116) do
		arg0_116:ClearMeshPainting(iter1_116)
		var13_0(arg0_116, iter1_116)
		var14_0(arg0_116, iter1_116)
	end
end

function var0_0.Resume(arg0_117)
	var0_0.super.Resume(arg0_117)

	if arg0_117.typewriterSpeed ~= 0 then
		arg0_117.typewriter:setSpeed(arg0_117.typewriterSpeed)
	end
end

function var0_0.Pause(arg0_118)
	var0_0.super.Pause(arg0_118)

	if arg0_118.typewriterSpeed ~= 0 then
		arg0_118.typewriter:setSpeed(100000000)
	end
end

function var0_0.OnClear(arg0_119)
	if arg0_119.spriteMask then
		setActive(arg0_119.spriteMask, true)

		arg0_119.spriteMask = nil
	end
end

function var0_0.FadeOutPainting(arg0_120, arg1_120, arg2_120, arg3_120)
	local var0_120 = arg2_120:GetComponent(typeof(CanvasGroup))
	local var1_120 = arg1_120:GetFadeOutPaintingTime()

	if var1_120 <= 0 then
		arg3_120()

		return
	end

	local var2_120 = arg1_120:ShouldAddHeadMaskWhenFade()

	if var2_120 then
		arg0_120:AddHeadMask(arg2_120)
	end

	arg0_120:TweenValueForcanvasGroup(var0_120, 1, 0, var1_120, 0, function()
		if var2_120 then
			arg0_120:ClearHeadMask(arg2_120)
		end

		arg3_120()
	end)
end

function var0_0.OnWillExit(arg0_122, arg1_122, arg2_122, arg3_122)
	if not arg2_122 or not arg2_122:IsDialogueMode() then
		arg3_122()

		return
	end

	local var0_122 = arg0_122:GetRecycleActorList(arg2_122, arg1_122)
	local var1_122

	if arg2_122:ShouldMoveToSide() then
		var1_122 = arg0_122:GetSideTF(arg1_122:GetSide())
	end

	local var2_122 = {}

	for iter0_122, iter1_122 in pairs(var0_122) do
		if (not var1_122 or iter1_122 ~= var1_122) and iter1_122:Find("fitter").childCount > 0 then
			table.insert(var2_122, function(arg0_123)
				arg0_122:FadeOutPainting(arg1_122, iter1_122, arg0_123)
			end)
		end
	end

	parallelAsync(var2_122, arg3_122)
end

function var0_0.OnEnd(arg0_124)
	if arg0_124.conentTxt then
		arg0_124.conentTxt.fontSize = arg0_124.defualtFontSize
		arg0_124.conentTxt.text = ""
	end

	if arg0_124.nameTxt then
		arg0_124.nameTxt.text = ""
	end

	arg0_124:ClearGlitchArtForPortrait()
	arg0_124:ClearCanMarkNode()

	local var0_124 = {
		"actorLeft",
		"actorMiddle",
		"actorRgiht"
	}

	arg0_124:RecyclePainting(var0_124)

	for iter0_124, iter1_124 in ipairs({
		"actorLeft",
		"actorMiddle",
		"actorRgiht"
	}) do
		arg0_124[iter1_124]:GetComponent(typeof(CanvasGroup)).alpha = 1
	end
end

return var0_0
