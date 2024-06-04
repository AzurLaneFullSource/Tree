local var0 = class("DialogueStoryPlayer", import(".StoryPlayer"))
local var1 = 159
local var2 = 411

function var0.Ctor(arg0, arg1)
	var0.super.Ctor(arg0, arg1)

	arg0.actorPanel = arg0:findTF("actor")
	arg0.actorLeft = arg0:findTF("actor_left", arg0.actorPanel)
	arg0.initActorLeftPos = arg0.actorLeft.localPosition
	arg0.actorMiddle = arg0:findTF("actor_middle", arg0.actorPanel)
	arg0.initActorMiddlePos = arg0.actorMiddle.localPosition
	arg0.actorRgiht = arg0:findTF("actor_right", arg0.actorPanel)
	arg0.initActorRgihtPos = arg0.actorRgiht.localPosition
	arg0.sortingOrder = arg0._go:GetComponent(typeof(Canvas)).sortingOrder
	arg0.subActorMiddle = UIItemList.New(arg0:findTF("actor_middle/sub", arg0.actorPanel), arg0:findTF("actor_middle/sub/tpl", arg0.actorPanel))
	arg0.subActorRgiht = UIItemList.New(arg0:findTF("actor_right/sub", arg0.actorPanel), arg0:findTF("actor_right/sub/tpl", arg0.actorPanel))
	arg0.subActorLeft = UIItemList.New(arg0:findTF("actor_left/sub", arg0.actorPanel), arg0:findTF("actor_left/sub/tpl", arg0.actorPanel))
	arg0.glitchArtMaterial = arg0:findTF("resource/material1"):GetComponent(typeof(Image)).material
	arg0.maskMaterial = arg0:findTF("resource/material2"):GetComponent(typeof(Image)).material
	arg0.maskMaterialForWithLayer = arg0:findTF("resource/material5"):GetComponent(typeof(Image)).material
	arg0.glitchArtMaterialForPainting = arg0:findTF("resource/material3"):GetComponent(typeof(Image)).material
	arg0.glitchArtMaterialForPaintingBg = arg0:findTF("resource/material4"):GetComponent(typeof(Image)).material
	arg0.headObjectMat = arg0:findTF("resource/material6"):GetComponent(typeof(Image)).material
	arg0.headMaskMat = arg0:findTF("resource/material7"):GetComponent(typeof(Image)).material
	arg0.typewriterSpeed = 0
	arg0.contentBgAlpha = 1
	arg0.live2dChars = {}
	arg0.spinePainings = {}
end

function var0.OnStart(arg0, arg1)
	arg0.nextTr = arg0:findTF("next", arg0.dialogueWin)
	arg0.conentTr = arg0:findTF("content", arg0.dialogueWin)
	arg0.conentTxt = arg0:findTF("content", arg0.dialogueWin):GetComponent(typeof(Text))
	arg0.typewriter = arg0:findTF("content", arg0.dialogueWin):GetComponent(typeof(Typewriter))
	arg0.nameTr = arg0:findTF("content/name", arg0.dialogueWin)
	arg0.nameTxt = arg0:findTF("Text", arg0.nameTr):GetComponent(typeof(Text))
	arg0.portraitTr = arg0:findTF("portrait", arg0.dialogueWin)
	arg0.portraitImg = arg0.portraitTr:GetComponent(typeof(Image))
	arg0.tags = {
		arg0.nameTr:Find("tags/1"),
		arg0.nameTr:Find("tags/2")
	}
	arg0.contentBgs = {
		arg0:findTF("bg", arg0.nameTr),
		arg0:findTF("bg", arg0.dialogueWin)
	}
	arg0.defualtFontSize = arg0.conentTxt.fontSize
end

function var0.OnReset(arg0, arg1, arg2, arg3)
	arg0:ResetActorTF(arg1, arg2)
	setActive(arg0.nameTr, false)
	setActive(arg0.nameTr, false)
	setActive(arg0.dialoguePanel, true)
	setActive(arg0.actorPanel, true)
	setActive(arg0.nextTr, false)

	arg0.conentTxt.text = ""

	local var0 = arg1:ExistPortrait()
	local var1 = arg2 and arg2:IsDialogueMode() and arg2:ExistPortrait() and var0

	setActive(arg0.portraitTr, var1)

	if not var1 and arg2 and arg2:IsDialogueMode() and arg2:ShouldGlitchArtForPortrait() then
		arg0:ClearGlitchArtForPortrait()
	end

	arg0.conentTr.offsetMin = Vector2(var0 and var2 or var1, arg0.conentTr.offsetMin.y)

	arg0:SetContentBgAlpha(arg1:GetContentBGAlpha())
	arg3()
end

local function var3(arg0, arg1)
	if not arg1 then
		return false
	end

	local var0

	if arg0:IsLive2dPainting() then
		var0 = arg1:Find("live2d")
	elseif arg0:IsSpinePainting() then
		var0 = arg1:Find("spine")
	else
		var0 = arg1:Find("fitter")
	end

	if var0.childCount <= 0 then
		return false
	end

	return var0:GetChild(0).name == arg0:GetPainting()
end

function var0.GetRecycleActorList(arg0, arg1, arg2)
	local var0 = arg1:GetSide()
	local var1 = arg0:GetSideTF(var0)
	local var2 = {}

	if arg1:HideOtherPainting() then
		var2 = {
			arg0.actorLeft,
			arg0.actorMiddle,
			arg0.actorRgiht
		}
	else
		if arg2 and arg2:IsDialogueMode() and arg1:IsDialogueMode() and arg1:IsSameSide(arg2) and arg1:IsSamePainting(arg2) or var3(arg1, var1) then
			-- block empty
		else
			table.insert(var2, var1)
		end

		if var0 == DialogueStep.SIDE_MIDDLE then
			table.insert(var2, arg0.actorLeft)
			table.insert(var2, arg0.actorRgiht)
		end
	end

	return var2
end

function var0.ResetActorTF(arg0, arg1, arg2)
	local var0 = arg1:GetSide()
	local var1 = arg0:GetSideTF(var0)

	if var1 then
		arg0:CancelTween(var1.gameObject)

		var1.localScale = Vector3(1, 1, 1)
		var1.eulerAngles = Vector3(0, 0, 0)

		if var1 == arg0.actorRgiht then
			var1.localPosition = arg0.initActorRgihtPos
		elseif var1 == arg0.actorMiddle then
			var1.localPosition = arg0.initActorMiddlePos
		elseif var1 == arg0.actorLeft then
			var1.localPosition = arg0.initActorLeftPos
		end
	end

	local var2 = arg0:GetRecycleActorList(arg1, arg2)

	if var1 and _.all(var2, function(arg0)
		return arg0 ~= var1
	end) then
		arg0.paintingStay = true

		arg0:ResetMeshPainting(var1)

		if arg1:IsSpinePainting() then
			arg0:HideSpineEffect(var1, arg1)
		end
	end

	arg0:RecyclePaintingList(var2)
	arg0:RecyclesSubPantings(arg0.subActorMiddle)
	arg0:RecyclesSubPantings(arg0.subActorRgiht)
	arg0:RecyclesSubPantings(arg0.subActorLeft)

	for iter0, iter1 in ipairs({
		arg0.actorLeft,
		arg0.actorMiddle,
		arg0.actorRgiht
	}) do
		iter1:GetComponent(typeof(CanvasGroup)).alpha = 1
	end
end

function var0.HideSpineEffect(arg0, arg1)
	arg0.spineEffectOrderCaches = {}

	local function var0(arg0)
		local var0 = arg0:GetComponentsInChildren(typeof("UnityEngine.ParticleSystemRenderer"))

		for iter0 = 1, var0.Length do
			local var1 = var0[iter0 - 1]
			local var2 = ReflectionHelp.RefGetProperty(typeof("UnityEngine.ParticleSystemRenderer"), "sortingOrder", var1)

			ReflectionHelp.RefSetProperty(typeof("UnityEngine.ParticleSystemRenderer"), "sortingOrder", var1, -1)

			arg0.spineEffectOrderCaches[var1] = var2
		end
	end

	local var1 = arg1:Find("spine")
	local var2 = arg1:Find("spinebg")

	var0(var1)
	var0(var2)
end

function var0.RevertSpineEffect(arg0, arg1, arg2)
	if not arg2 then
		return
	end

	local function var0(arg0)
		local var0 = arg0:GetComponentsInChildren(typeof("UnityEngine.ParticleSystemRenderer"))

		for iter0 = 1, var0.Length do
			local var1 = var0[iter0 - 1]
			local var2 = arg2[var1] or 950

			ReflectionHelp.RefSetProperty(typeof("UnityEngine.ParticleSystemRenderer"), "sortingOrder", var1, var2)
		end
	end

	local var1 = arg1:Find("spine")
	local var2 = arg1:Find("spinebg")

	var0(var1)
	var0(var2)
end

function var0.OnInit(arg0, arg1, arg2, arg3)
	local var0 = {
		function(arg0)
			arg0:UpdateContent(arg1, arg0)
		end,
		function(arg0)
			arg0:UpdatePortrait(arg1, arg0)
		end,
		function(arg0)
			arg0:UpdateSubPaintings(arg1, arg0)
		end,
		function(arg0)
			arg0:UpdatePainting(arg1, arg2, arg0)
		end,
		function(arg0)
			arg0:GrayingInPainting(arg1, arg2, arg0)
		end,
		function(arg0)
			arg0:StartMovePrevPaintingToSide(arg1, arg2, arg0)
		end,
		function(arg0)
			arg0:GrayingOutPrevPainting(arg2, arg1, arg0)
		end
	}

	parallelAsync(var0, arg3)
end

function var0.UpdatePortrait(arg0, arg1, arg2)
	if not arg1:ExistPortrait() then
		arg2()

		return
	end

	local var0 = arg1:GetPortrait()

	LoadSpriteAsync("StoryIcon/" .. var0, function(arg0)
		setImageSprite(arg0.portraitTr, arg0, true)
		setActive(arg0.portraitTr, true)
		arg0:AdjustPortraitPosition()

		if arg1:ShouldGlitchArtForPortrait() then
			arg0:SetGlitchArtForPortrait()
		else
			arg0:ClearGlitchArtForPortrait()
		end

		arg2()
	end)
end

function var0.AdjustPortraitPosition(arg0)
	local var0 = arg0.portraitTr.sizeDelta.x < var2 and var2 or 539

	setAnchoredPosition3D(arg0.portraitTr, {
		x = var0
	})
end

function var0.SetGlitchArtForPortrait(arg0)
	if arg0.portraitImg.material ~= arg0.glitchArtMaterialForPainting then
		arg0.portraitImg.material = arg0.glitchArtMaterialForPainting
	end
end

function var0.ClearGlitchArtForPortrait(arg0)
	if arg0.portraitImg.material ~= arg0.portraitImg.defaultGraphicMaterial then
		arg0.portraitImg.material = arg0.portraitImg.defaultGraphicMaterial
	end
end

function var0.UpdateSubPaintings(arg0, arg1, arg2)
	local var0, var1, var2, var3 = arg0:GetSideTF(arg1:GetSide())

	if not arg1:ExistPainting() then
		arg2()

		return
	end

	arg0:InitSubPainting(var3, arg1:GetSubPaintings(), arg1)

	if arg1:NeedDispppearSubPainting() then
		arg0:DisappearSubPainting(var3, arg1, arg2)
	else
		arg2()
	end
end

function var0.OnStartUIAnimations(arg0, arg1, arg2)
	if not arg1:ShouldShakeDailogue() then
		arg2()

		return
	end

	local var0 = arg1:GetShakeDailogueData()
	local var1 = var0.x
	local var2 = var0.number
	local var3 = var0.delay
	local var4 = var0.speed
	local var5 = arg0.dialogueWin.localPosition.x

	arg0:TweenMovex(arg0.dialogueWin, var1, var5, var4, var3, var2, arg2)
end

function var0.OnEnter(arg0, arg1, arg2, arg3)
	parallelAsync({
		function(arg0)
			arg0:UpdateCanMarkNode(arg1, arg0)
		end,
		function(arg0)
			arg0:UpdateIcon(arg1, arg0)
		end
	}, arg3)
end

local function var4(arg0, arg1)
	ResourceMgr.Inst:getAssetAsync("Story/" .. arg0, arg0, UnityEngine.Events.UnityAction_UnityEngine_Object(function(arg0)
		arg1(arg0)
	end), true, true)
end

local function var5(arg0, arg1)
	if not arg1 then
		return false
	end

	return arg0:GetCanMarkNodeData().name == arg1.name
end

function var0.UpdateCanMarkNode(arg0, arg1, arg2)
	local var0 = arg1:ExistCanMarkNode()

	if not var0 or not var5(arg1, arg0.canMarkNode) then
		arg0:ClearCanMarkNode(arg0.canMarkNode)
	end

	if not var0 then
		arg2()

		return
	end

	local var1 = arg1:GetCanMarkNodeData()

	local function var2(arg0)
		eachChild(arg0, function(arg0)
			local var0 = table.contains(var1.marks, arg0.gameObject.name)

			if var0 ~= isActive(arg0) then
				setActive(arg0, var0)
			end
		end)
	end

	if not arg0.canMarkNode then
		var4(var1.name, function(arg0)
			if arg0.stop or not arg0 then
				arg2()

				return
			end

			local var0 = Object.Instantiate(arg0, arg0.backPanel)

			arg0.canMarkNode = {
				name = var1.name,
				go = var0
			}

			var2(var0)
			arg2()
		end)
	else
		var2(arg0.canMarkNode.go)
		arg2()
	end
end

function var0.ClearCanMarkNode(arg0)
	if arg0.canMarkNode then
		Object.Destroy(arg0.canMarkNode.go)

		arg0.canMarkNode = nil
	end
end

function var0.GrayingOutPrevPainting(arg0, arg1, arg2, arg3)
	if not arg1 or not arg1:IsDialogueMode() then
		arg3()

		return
	end

	local var0 = arg0:GetSideTF(arg2:GetPrevSide(arg1))

	if var0 and arg2 and arg2:IsDialogueMode() and arg2:ShouldGrayingOutPainting(arg1) then
		local var1 = arg1:GetPaintingData()
		local var2 = arg1:GetPaintingAlpha() or 1

		arg0:fadeTransform(var0, var2, var1.alpha, var1.time, false, arg3)
	else
		arg3()
	end
end

function var0.GrayingInPainting(arg0, arg1, arg2, arg3)
	if not arg1:ExistPainting() then
		arg3()

		return
	end

	if arg2 and arg2:IsDialogueMode() and arg1:ShouldGrayingPainting(arg2) then
		local var0 = arg0:GetSideTF(arg1:GetSide())
		local var1 = arg1:GetPaintingData()

		if not IsNil(var0) and not arg1:GetPaintingAlpha() then
			arg0:fadeTransform(var0, var1.alpha, 1, var1.time, false)
		end
	end

	arg3()
end

function var0.UpdateTypeWriter(arg0, arg1, arg2)
	local var0 = arg1:GetTypewriter()

	if not var0 then
		arg2()

		return
	end

	function arg0.typewriter.endFunc()
		arg0.typewriterSpeed = 0
		arg0.typewriter.endFunc = nil

		removeOnButton(arg0._tf)
		arg2()
	end

	arg0.typewriterSpeed = math.max((var0.speed or 0.1) * arg0.timeScale, 0.001)

	local var1 = var0.speedUp or arg0.typewriterSpeed

	arg0.typewriter:setSpeed(arg0.typewriterSpeed)
	arg0.typewriter:Play()
	onButton(arg0, arg0._tf, function()
		if arg0.puase or arg0.stop then
			return
		end

		arg0.typewriterSpeed = math.min(arg0.typewriterSpeed, var1)

		arg0.typewriter:setSpeed(arg0.typewriterSpeed)
	end, SFX_PANEL)
end

function var0.UpdatePainting(arg0, arg1, arg2, arg3)
	if not arg1:ExistPainting() then
		arg3()

		return
	end

	local var0 = not arg0.paintingStay

	if arg0.paintingStay and arg0.spineEffectOrderCaches and arg1:IsSpinePainting() then
		local var1 = arg0:GetSideTF(arg1:GetSide())

		arg0:RevertSpineEffect(var1, arg0.spineEffectOrderCaches)
	end

	arg0.spineEffectOrderCaches = nil
	arg0.paintingStay = nil

	local var2, var3, var4, var5 = arg0:GetSideTF(arg1:GetSide())
	local var6 = arg2 and arg2:IsDialogueMode() and (arg1:ShouldGrayingOutPainting(arg2) or arg1:ShouldGrayingPainting(arg2)) or not arg1:ShouldFadeInPainting() or not var0
	local var7 = arg2 and arg2:IsDialogueMode() and arg1:ShouldGrayingPainting(arg2)

	seriesAsync({
		function(arg0)
			if not var6 then
				var2:GetComponent(typeof(CanvasGroup)).alpha = 0
			end

			arg0:LoadPainting(arg1, var0, arg0)

			if var7 then
				local var0 = arg1:GetPaintingData()

				arg0:SetFadeColor(var2, var0.alpha)
			end
		end,
		function(arg0)
			if var6 then
				arg0()

				return
			end

			arg0:FadeInPainting(var2, arg1, arg0)
		end,
		function(arg0)
			arg0:AnimationPainting(arg1, arg0)
		end
	}, arg3)
end

function var0.FadeInPainting(arg0, arg1, arg2, arg3)
	local var0 = arg1:GetComponent(typeof(CanvasGroup))
	local var1 = arg2:GetFadeInPaintingTime()
	local var2 = arg2:ShouldAddHeadMaskWhenFade()

	if var2 then
		arg0:AddHeadMask(arg1)
	end

	arg0:TweenValueForcanvasGroup(var0, 0, 1, var1, 0, function()
		if var2 then
			arg0:ClearHeadMask(arg1)
		end

		arg3()
	end)
end

function var0.AddHeadMask(arg0, arg1)
	local var0 = arg1:Find("fitter")

	if not var0 or var0.childCount <= 0 then
		return
	end

	local var1 = var0:GetChild(0)
	local var2 = var1:Find("face")
	local var3 = cloneTplTo(var2, var2.parent, "head_mask")
	local var4 = var1:Find("layers")
	local var5 = arg1:GetComponentsInChildren(typeof(Image))

	if var4 then
		for iter0 = 0, var5.Length - 1 do
			local var6 = var5[iter0]

			if var6.gameObject.name == "head_mask" then
				var6.material = arg0.headMaskMat
			elseif var6.gameObject.name == "face" then
				-- block empty
			elseif var6.gameObject.transform.parent == var4 then
				var6.material = arg0.headObjectMat
			end
		end
	else
		for iter1 = 0, var5.Length - 1 do
			local var7 = var5[iter1]

			if var7.gameObject.name == "head_mask" then
				var7.material = arg0.headMaskMat
			elseif var7.gameObject.name == "face" then
				-- block empty
			else
				var7.material = arg0.headObjectMat
			end
		end
	end
end

function var0.ClearHeadMask(arg0, arg1)
	local var0 = arg1:Find("fitter")

	if not var0 or var0.childCount <= 0 then
		return
	end

	local var1 = var0:GetChild(0):Find("head_mask")

	Object.Destroy(var1.gameObject)

	local var2 = arg1:GetComponentsInChildren(typeof(Image))

	for iter0 = 0, var2.Length - 1 do
		local var3 = var2[iter0]

		var3.material = var3.defaultGraphicMaterial
	end
end

function var0.AnimationPainting(arg0, arg1, arg2)
	if arg1:IsLive2dPainting() or arg1:IsSpinePainting() then
		arg2()

		return
	end

	local var0, var1, var2, var3 = arg0:GetSideTF(arg1:GetSide())

	arg0:StartPaintingActions(var0, arg1, arg2)
end

function var0.LoadPainting(arg0, arg1, arg2, arg3)
	local var0, var1, var2, var3 = arg0:GetSideTF(arg1:GetSide())
	local var4, var5 = arg1:GetPaintingAndName()

	if arg1:IsLive2dPainting() and checkABExist("live2d/" .. var5) then
		arg0:UpdateLive2dPainting(arg1, var0, arg2, arg3)
	elseif arg1:IsSpinePainting() and checkABExist("spinepainting/" .. var5) then
		arg0:UpdateSpinePainting(arg1, var0, arg2, arg3)
	else
		arg0:UpdateMeshPainting(arg1, var0, var3, arg2, arg3)
	end
end

function var0.UpdateLive2dPainting(arg0, arg1, arg2, arg3, arg4)
	local function var0(arg0)
		local var0 = arg1:GetVirtualShip()
		local var1 = arg1:GetLive2dPos()
		local var2 = Live2D.GenerateData({
			ship = var0,
			scale = Vector3(70, 70, 70),
			position = var1 or Vector3(0, 0, 0),
			parent = arg2:Find("live2d")
		})
		local var3 = GetOrAddComponent(arg0._go, typeof(CanvasGroup))

		var3.blocksRaycasts = false

		local var4 = Live2D.New(var2, function(arg0)
			arg0._go.name = arg1:GetPainting()

			local var0 = arg0._go:GetComponent("Live2D.Cubism.Rendering.CubismRenderController")
			local var1 = arg0.sortingOrder + 1
			local var2 = typeof("Live2D.Cubism.Rendering.CubismRenderController")

			ReflectionHelp.RefSetProperty(var2, "SortingOrder", var0, var1)

			local var3 = ReflectionHelp.RefGetField(typeof("Live2D.Cubism.Rendering.CubismSortingMode"), "BackToFrontOrder")

			ReflectionHelp.RefSetProperty(var2, "SortingMode", var0, var3)

			local var4 = GetOrAddComponent(arg0.front, typeof(Canvas))

			GetOrAddComponent(arg0.front, typeof(GraphicRaycaster))

			var4.overrideSorting = true
			var4.sortingOrder = var1 + arg0._tf:Find("Drawables").childCount
			var3.blocksRaycasts = true

			if arg0 then
				arg0(arg0)
			end
		end)

		arg0.live2dChars[arg2] = var4
	end

	local function var1(arg0)
		if arg0 then
			local var0 = arg1:GetLive2dAction()

			if var0 and var0 ~= "" then
				arg0:TriggerAction(var0)
			end

			local var1 = arg1:GetL2dIdleIndex()

			if var1 and var1 ~= "" and var1 > 0 then
				arg0:changeIdleIndex(var1)
			end
		end

		arg4()
	end

	if not arg3 and arg0.live2dChars[arg2] then
		local var2 = arg0.live2dChars[arg2]

		var1(var2)
	else
		var0(var1)
	end
end

local function var6(arg0, arg1, arg2)
	local var0 = arg0:GetComponentsInChildren(typeof(Canvas))
	local var1

	for iter0 = 1, var0.Length do
		var1 = var0[iter0 - 1].sortingOrder
	end

	local var2 = math.huge
	local var3 = arg1:GetComponentsInChildren(typeof(Canvas))

	if var3.Length == 0 then
		var2 = 0
	else
		for iter1 = 1, var3.Length do
			local var4 = var3[iter1 - 1].sortingOrder - var1

			if var4 < var2 then
				var2 = var4
			end
		end
	end

	local var5 = arg1:GetComponentsInChildren(typeof("UnityEngine.ParticleSystemRenderer"))
	local var6 = {}

	for iter2 = 1, var5.Length do
		local var7 = var5[iter2 - 1]
		local var8 = ReflectionHelp.RefGetProperty(typeof("UnityEngine.ParticleSystemRenderer"), "sortingOrder", var7)

		var6[iter2] = var8

		local var9 = var8 - var1

		if var9 < var2 then
			var2 = var9
		end
	end

	local var10 = arg2 - var2 + 1

	for iter3 = 1, var0.Length do
		var0[iter3 - 1].sortingOrder = var10 + (iter3 - 1)
	end

	local var11 = var10 + 1

	for iter4 = 1, var3.Length do
		local var12 = var3[iter4 - 1]
		local var13 = var10 + (var12.sortingOrder - var1)

		var12.sortingOrder = var13

		if var10 < var13 then
			var11 = var13
		end
	end

	for iter5 = 1, var5.Length do
		local var14 = var5[iter5 - 1]
		local var15 = var10 + (var6[iter5] - var1)

		ReflectionHelp.RefSetProperty(typeof("UnityEngine.ParticleSystemRenderer"), "sortingOrder", var14, var15)

		if var10 < var15 then
			var11 = var15
		end
	end

	return var11
end

local function var7(arg0, arg1, arg2)
	local var0 = arg0:GetComponentsInChildren(typeof(Canvas))
	local var1 = arg0:GetComponentsInChildren(typeof("UnityEngine.ParticleSystemRenderer"))
	local var2 = math.huge

	if var0.Length == 0 then
		var2 = 0
	else
		for iter0 = 1, var0.Length do
			local var3 = var0[iter0 - 1].sortingOrder

			if var3 < var2 then
				var2 = var3
			end
		end
	end

	local var4 = {}

	for iter1 = 1, var1.Length do
		local var5 = var1[iter1 - 1]
		local var6 = ReflectionHelp.RefGetProperty(typeof("UnityEngine.ParticleSystemRenderer"), "sortingOrder", var5)

		var4[iter1] = var6

		if var6 < var2 then
			var2 = var6
		end
	end

	local var7 = arg2 + 1
	local var8 = var7 - var2

	for iter2 = 1, var0.Length do
		local var9 = var0[iter2 - 1]
		local var10 = var8 + var9.sortingOrder

		var9.sortingOrder = var10

		if var7 < var10 then
			var7 = var10
		end
	end

	for iter3 = 1, var1.Length do
		local var11 = var1[iter3 - 1]
		local var12 = var8 + var4[iter3]

		ReflectionHelp.RefSetProperty(typeof("UnityEngine.ParticleSystemRenderer"), "sortingOrder", var11, var12)

		if var12 < var7 then
			var7 = var12
		end
	end

	return var7
end

function var0.UpdateSpinePainting(arg0, arg1, arg2, arg3, arg4)
	local function var0(arg0)
		local var0 = arg2:Find("spine")
		local var1 = arg2:Find("spinebg")
		local var2 = arg1:GetVirtualShip()
		local var3 = SpinePainting.GenerateData({
			ship = var2,
			position = Vector3(0, 0, 0),
			parent = var0,
			effectParent = var1
		})

		setActive(var1, not arg1:IsHideSpineBg())

		local var4 = SpinePainting.New(var3, function(arg0)
			arg0._go.name = arg1:GetPainting()

			local var0 = arg0.sortingOrder
			local var1 = arg1:GetSpineOrderIndex()

			if not var1 then
				var0 = var6(var0, var1, arg0.sortingOrder)
			else
				var0 = var7(var0, var1, arg0.sortingOrder)
			end

			local var2 = GetOrAddComponent(arg0.front, typeof(Canvas))

			GetOrAddComponent(arg0.front, typeof(GraphicRaycaster))

			var2.overrideSorting = true
			var2.sortingOrder = var0 + 1

			arg0:UpdateSpineExpression(arg0, arg1)

			if arg0 then
				arg0()
			end
		end)

		arg0.spinePainings[arg2] = var4
	end

	if not arg3 and arg0.spinePainings[arg2] then
		arg0:UpdateSpineExpression(arg0.spinePainings[arg2], arg1)
		arg4()
	else
		var0(arg4)
	end
end

function var0.UpdateSpineExpression(arg0, arg1, arg2)
	local var0 = arg2:GetSpineExPression()

	if var0 then
		arg1:SetAction(var0, 1)
	else
		arg1:SetEmptyAction(1)
	end
end

function var0.UpdateMeshPainting(arg0, arg1, arg2, arg3, arg4, arg5)
	local var0 = arg1:GetPainting()
	local var1 = false

	local function var2()
		if arg1:IsShowNPainting() and checkABExist("painting/" .. var0 .. "_n") then
			var0 = var0 .. "_n"
		end

		if arg1:IsShowWJZPainting() and checkABExist("painting/" .. var0 .. "_wjz") then
			var0 = var0 .. "_wjz"
		end

		setPaintingPrefab(arg2, var0, "duihua")
	end

	if var0 then
		local var3 = findTF(arg2, "fitter").childCount

		if arg4 or var3 <= 0 then
			var2()
		end

		local var4 = arg1:GetPaintingDir()
		local var5 = math.abs(var4)

		arg2.localScale = Vector3(var4, var5, 1)

		local var6 = findTF(arg2, "fitter"):GetChild(0)

		var6.name = var0

		arg0:UpdateActorPostion(arg2, arg1)
		arg0:UpdateExpression(var6, arg1)
		arg0:AddGlitchArtEffectForPating(arg2, var6, arg1)
		arg2:SetAsLastSibling()

		if arg1:ShouldGrayPainting() then
			setGray(var6, true, true)
		end

		local var7 = findTF(var6, "shadow")

		if var7 then
			setActive(var7, arg1:ShouldFaceBlack())
		end

		local var8 = arg1:GetPaintingAlpha()

		if var8 then
			arg0:setPaintingAlpha(arg2, var8)
		end
	end

	arg5()
end

local function var8(arg0)
	local var0 = arg0.name

	if arg0.showNPainting and checkABExist("painting/" .. var0 .. "_n") then
		var0 = var0 .. "_n"
	end

	return var0
end

function var0.InitSubPainting(arg0, arg1, arg2, arg3)
	local function var0(arg0, arg1)
		local var0 = var8(arg0)

		setPaintingPrefab(arg1, var0, "duihua")

		local var1 = findTF(arg1, "fitter"):GetChild(0)
		local var2 = findTF(var1, "face")
		local var3 = arg0.expression

		if not arg0.expression and arg0.name and ShipExpressionHelper.DefaultFaceless(arg0.name) then
			var3 = ShipExpressionHelper.GetDefaultFace(arg0.name)
		end

		if var3 then
			setActive(var2, true)

			local var4 = GetSpriteFromAtlas("paintingface/" .. arg0.name, arg0.expression)

			setImageSprite(var2, var4)
		end

		if arg0.pos then
			setAnchoredPosition(arg1, arg0.pos)
		end

		if arg0.dir then
			arg1.transform.localScale = Vector3(arg0.dir, 1, 1)
		end

		if arg0.paintingNoise then
			arg0:AddGlitchArtEffectForPating(arg1, var1, arg3)
		end
	end

	arg1:make(function(arg0, arg1, arg2)
		if arg0 == UIItemList.EventUpdate then
			var0(arg2[arg1 + 1], arg2)
		end
	end)
	arg1:align(#arg2)
end

function var0.DisappearSubPainting(arg0, arg1, arg2, arg3)
	local var0 = arg2:GetSubPaintings()
	local var1, var2 = arg2:GetDisappearTime()
	local var3 = arg2:GetDisappearSeq()
	local var4 = {}
	local var5 = {}

	for iter0, iter1 in ipairs(var0) do
		table.insert(var5, iter1)
	end

	for iter2, iter3 in ipairs(var3) do
		local var6 = iter3

		table.insert(var4, function(arg0)
			for iter0, iter1 in ipairs(var5) do
				if iter1.actor == var6 then
					table.remove(var5, iter0)

					break
				end
			end

			arg0:InitSubPainting(arg1, var5, arg2)
			arg0:DelayCall(var2, arg0)
		end)
	end

	arg1.container:SetAsFirstSibling()
	arg0:DelayCall(var1, function()
		seriesAsync(var4, function()
			arg1.container:SetAsLastSibling()
			arg3()
		end)
	end)
end

function var0.UpdateActorPostion(arg0, arg1, arg2)
	local var0 = arg2:GetPaitingOffst()

	if var0 then
		local var1 = arg1.localPosition

		arg1.localPosition = Vector3(var1.x + (var0.x or 0), var1.y + (var0.y or 0), 0)
	end
end

function var0.UpdateExpression(arg0, arg1, arg2)
	local var0 = arg2:GetExPression()
	local var1 = findTF(arg1, "face")

	if var0 then
		local var2 = arg2:GetPainting()
		local var3 = GetSpriteFromAtlas("paintingface/" .. var2, var0)

		setActive(var1, true)
		setImageSprite(var1, var3)
	else
		setActive(var1, false)
	end
end

function var0.StartPaintingActions(arg0, arg1, arg2, arg3)
	local var0 = {
		function(arg0)
			arg0:StartPatiningMoveAction(arg1, arg2, arg0)
		end,
		function(arg0)
			arg0:StartPatiningShakeAction(arg1, arg2, arg0)
		end,
		function(arg0)
			arg0:StartPatiningZoomAction(arg1, arg2, arg0)
		end,
		function(arg0)
			arg0:StartPatiningRotateAction(arg1, arg2, arg0)
		end
	}

	parallelAsync(var0, function()
		if arg3 then
			arg3()
		end
	end)
end

function var0.StartPatiningShakeAction(arg0, arg1, arg2, arg3)
	local var0 = arg2:GetPaintingAction(DialogueStep.PAINTING_ACTION_SHAKE)

	if not var0 then
		arg3()

		return
	end

	local function var1(arg0, arg1)
		local var0 = arg0.x or 0
		local var1 = arg0.y or 10
		local var2 = arg0.dur or 1
		local var3 = arg0.delay or 0
		local var4 = arg0.number or 1
		local var5 = tf(arg1).localPosition

		arg0:TweenMove(arg1, Vector3(var5.x + var0, var5.y + var1, 0), var2, var4, var3, arg1)
	end

	local var2 = {}

	for iter0, iter1 in pairs(var0) do
		table.insert(var2, function(arg0)
			var1(iter1, arg0)
		end)
	end

	parallelAsync(var2, function()
		if arg3 then
			arg3()
		end
	end)
end

function var0.StartPatiningZoomAction(arg0, arg1, arg2, arg3)
	local var0 = arg2:GetPaintingAction(DialogueStep.PAINTING_ACTION_ZOOM)

	if not var0 then
		arg3()

		return
	end

	local function var1(arg0, arg1)
		if not arg0.from then
			local var0 = {
				0,
				0,
				0
			}
		end

		local var1 = arg0.to or {
			1,
			1,
			1
		}
		local var2 = arg0.dur or 0
		local var3 = arg0.delay or 0

		arg0:TweenScale(arg1, Vector3(var1[1], var1[2], var1[3]), var2, var3, arg1)
	end

	local var2 = {}

	for iter0, iter1 in pairs(var0) do
		table.insert(var2, function(arg0)
			var1(iter1, arg0)
		end)
	end

	parallelAsync(var2, function()
		if arg3 then
			arg3()
		end
	end)
end

function var0.StartPatiningRotateAction(arg0, arg1, arg2, arg3)
	local var0 = arg2:GetPaintingAction(DialogueStep.PAINTING_ACTION_ROTATE)

	if not var0 then
		arg3()

		return
	end

	local function var1(arg0, arg1)
		local var0 = arg0.value
		local var1 = arg0.dur or 1
		local var2 = arg0.number or 1
		local var3 = arg0.delay or 0

		arg0:TweenRotate(arg1, var0, var1, var2, var3, arg1)
	end

	local var2 = {}

	for iter0, iter1 in pairs(var0) do
		table.insert(var2, function(arg0)
			var1(iter1, arg0)
		end)
	end

	parallelAsync(var2, function()
		if arg3 then
			arg3()
		end
	end)
end

function var0.StartPatiningMoveAction(arg0, arg1, arg2, arg3)
	local var0 = arg2:GetPaintingAction(DialogueStep.PAINTING_ACTION_MOVE)

	if not var0 then
		arg3()

		return
	end

	local function var1(arg0, arg1)
		local var0 = arg0.x or 0
		local var1 = arg0.y or 0
		local var2 = arg0.dur or 1
		local var3 = arg0.delay or 0
		local var4 = tf(arg1).localPosition

		arg0:TweenMove(arg1, Vector3(var4.x + var0, var4.y + var1, 0), var2, 1, var3, arg1)
	end

	local var2 = {}

	for iter0, iter1 in pairs(var0) do
		table.insert(var2, function(arg0)
			var1(iter1, arg0)
		end)
	end

	parallelAsync(var2, function()
		if arg3 then
			arg3()
		end
	end)
end

function var0.StartMovePrevPaintingToSide(arg0, arg1, arg2, arg3)
	local var0 = arg1:GetPaintingMoveToSide()

	if not var0 or not arg2 then
		arg3()

		return
	end

	local var1 = arg0:GetSideTF(arg2:GetSide())

	if not var1 then
		arg3()

		return
	end

	local var2 = var0.time
	local var3 = var0.side
	local var4 = arg0:GetSideTF(var3)

	if not var4 then
		arg3()

		return
	end

	if arg1.side ~= arg2.side then
		if var1:Find("fitter").childCount > 0 then
			local var5 = var1:Find("fitter"):GetChild(0)

			removeAllChildren(var4:Find("fitter"))
			setParent(var5, var4:Find("fitter"))

			local var6 = arg2:GetPaintingDir()

			var4.localScale = Vector3(var6, math.abs(var6), 1)
		end
	else
		local var7 = arg2:GetPainting()

		if var7 then
			setPaintingPrefab(var4, var7, "duihua")
		end
	end

	local var8 = tf(var4).localPosition

	arg0:TweenValue(var4, var1.localPosition.x, var8.x, var2, 0, function(arg0)
		setAnchoredPosition(var4, {
			x = arg0
		})
	end, arg3)

	var4.localPosition = Vector2(var1.localPosition.x, var4.localPosition.y, 0)
end

local function var9(arg0, arg1, arg2, arg3, arg4)
	local var0 = arg1:GetComponentsInChildren(typeof(Image))

	for iter0 = 0, var0.Length - 1 do
		local var1 = var0[iter0]

		if var1.gameObject.name == "temp_mask" then
			var1.material = arg4 and arg0.maskMaterial or arg0.maskMaterialForWithLayer
		elseif var1.gameObject.name == "face" then
			var1.material = arg0.glitchArtMaterial
		elseif arg3.hasPaintbg and var1.gameObject == arg2.gameObject then
			var1.material = arg0.glitchArtMaterialForPaintingBg
		else
			var1.material = arg0.glitchArtMaterialForPainting
		end
	end
end

local function var10(arg0, arg1, arg2, arg3, arg4)
	local var0 = arg1:GetComponentsInChildren(typeof(Image))
	local var1 = {}
	local var2 = arg2:GetComponent(typeof(Image))

	if var2 then
		table.insert(var1, var2.gameObject)
	end

	for iter0 = 1, arg3 - 1 do
		local var3 = arg4:GetChild(iter0 - 1)

		table.insert(var1, var3.gameObject)
	end

	for iter1 = 0, var0.Length - 1 do
		local var4 = var0[iter1]

		if var4.gameObject.name == "temp_mask" then
			var4.material = arg0.maskMaterial
		elseif var4.gameObject.name == "face" then
			var4.material = arg0.glitchArtMaterial
		elseif table.contains(var1, var4.gameObject) then
			var4.material = arg0.glitchArtMaterialForPaintingBg
		else
			var4.material = arg0.glitchArtMaterialForPainting
		end
	end
end

function var0.AddGlitchArtEffectForPating(arg0, arg1, arg2, arg3)
	local var0 = arg3:ShouldAddGlitchArtEffect()
	local var1 = arg3:IsNoHeadPainting()

	if var0 and arg3:GetExPression() ~= nil and not var1 then
		local var2 = arg2:Find("face")

		cloneTplTo(var2, var2.parent, "temp_mask"):SetAsFirstSibling()

		local var3 = arg2:Find("layers")
		local var4 = IsNil(var3)

		if not var4 and arg3:GetPaintingRwIndex() > 0 then
			var10(arg0, arg1, arg2, arg3:GetPaintingRwIndex(), var3)
		else
			var9(arg0, arg1, arg2, arg3, var4)
		end
	elseif var0 then
		local var5 = arg1:GetComponentsInChildren(typeof(Image))

		for iter0 = 0, var5.Length - 1 do
			var5[iter0].material = arg0.glitchArtMaterial
		end
	end

	if var0 then
		local var6 = GameObject.Find("/OverlayCamera/Overlay/UIMain/AwardInfoUI(Clone)/items/SpriteMask")

		if var6 and var6.activeInHierarchy then
			setActive(var6, false)

			arg0.spriteMask = var6
		end
	end
end

function var0.UpdateContent(arg0, arg1, arg2)
	local function var0()
		setActive(arg0.nextTr, true)
		arg2()
	end

	for iter0, iter1 in ipairs(arg0.tags) do
		setActive(iter1, iter0 == arg1:GetTag())
	end

	arg0.conentTxt.fontSize = arg1:GetFontSize() or arg0.defualtFontSize

	local var1 = arg1:GetContent()

	arg0.conentTxt.text = var1

	local var2 = 999

	if var1 and var1 ~= "" then
		var2 = System.String.New(var1).Length
	end

	if var1 and var1 ~= "" and var1 ~= "…" and #var1 > 1 and var2 > 1 then
		arg0:UpdateTypeWriter(arg1, var0)
	else
		var0()
	end

	local var3, var4, var5, var6 = arg0:GetSideTF(arg1:GetSide())

	if var4 then
		local var7 = arg1:GetNameWithColor()
		local var8 = var7 and var7 ~= ""

		setActive(var4, var8)

		if var8 then
			local var9 = arg1:GetNameColorCode()

			var4:Find("Text"):GetComponent(typeof(Outline)).effectColor = Color.NewHex(var9)
		end

		var5.text = var7

		setText(var5.gameObject.transform:Find("subText"), arg1:GetSubActorName())
	end
end

function var0.SetContentBgAlpha(arg0, arg1)
	if arg0.contentBgAlpha ~= arg1 then
		for iter0, iter1 in ipairs(arg0.contentBgs) do
			GetOrAddComponent(iter1, typeof(CanvasGroup)).alpha = arg1
		end

		arg0.contentBgAlpha = arg1
	end
end

function var0.GetSideTF(arg0, arg1)
	local var0
	local var1
	local var2
	local var3

	if DialogueStep.SIDE_LEFT == arg1 then
		var0, var1, var2, var3 = arg0.actorLeft, arg0.nameTr, arg0.nameTxt, arg0.subActorLeft
	elseif DialogueStep.SIDE_RIGHT == arg1 then
		var0, var1, var2, var3 = arg0.actorRgiht, arg0.nameTr, arg0.nameTxt, arg0.subActorRgiht
	elseif DialogueStep.SIDE_MIDDLE == arg1 then
		var0, var1, var2, var3 = arg0.actorMiddle, arg0.nameTr, arg0.nameTxt, arg0.subActorMiddle
	end

	return var0, var1, var2, var3
end

function var0.RecyclesSubPantings(arg0, arg1)
	arg1:each(function(arg0, arg1)
		arg0:RecyclePainting(arg1)
	end)
end

local function var11(arg0)
	if arg0:Find("fitter").childCount == 0 then
		return
	end

	local var0 = arg0:Find("fitter"):GetChild(0)

	if var0 then
		local var1 = findTF(var0, "shadow")

		if var1 then
			setActive(var1, false)
		end

		local var2 = arg0:GetComponentsInChildren(typeof(Image))

		for iter0 = 0, var2.Length - 1 do
			local var3 = var2[iter0]
			local var4 = Color.white

			if var3.material ~= var3.defaultGraphicMaterial then
				var3.material = var3.defaultGraphicMaterial
			end

			var3.material:SetColor("_Color", var4)
		end

		setGray(arg0, false, true)
		retPaintingPrefab(arg0, var0.name)

		local var5 = var0:Find("temp_mask")

		if var5 then
			Destroy(var5)
		end
	end
end

function var0.ClearMeshPainting(arg0, arg1)
	arg0:ResetMeshPainting(arg1)

	if arg1:Find("fitter").childCount == 0 then
		return
	end

	local var0 = arg1:Find("fitter"):GetChild(0)

	if var0 then
		retPaintingPrefab(arg1, var0.name)
	end
end

function var0.ResetMeshPainting(arg0, arg1)
	if arg1:Find("fitter").childCount == 0 then
		return
	end

	local var0 = arg1:Find("fitter"):GetChild(0)

	if var0 then
		local var1 = findTF(var0, "shadow")

		if var1 then
			setActive(var1, false)
		end

		local var2 = arg1:GetComponentsInChildren(typeof(Image))

		for iter0 = 0, var2.Length - 1 do
			local var3 = var2[iter0]
			local var4 = Color.white

			if var3.material ~= var3.defaultGraphicMaterial then
				var3.material = var3.defaultGraphicMaterial

				var3.material:SetColor("_Color", var4)
			else
				var3.material = nil
			end
		end

		setGray(arg1, false, true)

		local var5 = var0:Find("temp_mask")

		if var5 then
			Destroy(var5)
		end
	end
end

local function var12(arg0, arg1)
	local var0 = arg0.live2dChars[arg1]
	local var1 = false

	if var0 then
		local var2 = var0._go:GetComponent("Live2D.Cubism.Rendering.CubismRenderController")

		ReflectionHelp.RefSetProperty(typeof("Live2D.Cubism.Rendering.CubismRenderController"), "SortingOrder", var2, 0)
		var0:Dispose()

		arg0.live2dChars[arg1] = nil
		var1 = true
	end

	local var3 = table.getCount(arg0.live2dChars) <= 0

	if var1 and var3 then
		local var4 = arg0.front:GetComponent(typeof(GraphicRaycaster))

		if var4 then
			Object.Destroy(var4)
		end

		local var5 = arg0.front:GetComponent(typeof(Canvas))

		if var5 then
			Object.Destroy(var5)
		end
	end
end

local function var13(arg0, arg1)
	local var0 = arg0.spinePainings[arg1]
	local var1 = false

	if var0 then
		var0:Dispose()

		arg0.spinePainings[arg1] = nil
		var1 = true
	end

	local var2 = table.getCount(arg0.spinePainings) <= 0

	if var1 and var2 then
		local var3 = arg0.front:GetComponent(typeof(GraphicRaycaster))

		if var3 then
			Object.Destroy(var3)
		end

		local var4 = arg0.front:GetComponent(typeof(Canvas))

		if var4 then
			Object.Destroy(var4)
		end
	end
end

function var0.RecyclePainting(arg0, arg1)
	if type(arg1) == "table" then
		local var0 = _.map(arg1, function(arg0)
			return arg0[arg0]
		end)

		arg0:RecyclePaintingList(var0)
	else
		arg0:ClearMeshPainting(arg1)
		var12(arg0, arg1)
		var13(arg0, arg1)
	end
end

function var0.RecyclePaintingList(arg0, arg1)
	for iter0, iter1 in ipairs(arg1) do
		arg0:ClearMeshPainting(iter1)
		var12(arg0, iter1)
		var13(arg0, iter1)
	end
end

function var0.Resume(arg0)
	var0.super.Resume(arg0)

	if arg0.typewriterSpeed ~= 0 then
		arg0.typewriter:setSpeed(arg0.typewriterSpeed)
	end
end

function var0.Pause(arg0)
	var0.super.Pause(arg0)

	if arg0.typewriterSpeed ~= 0 then
		arg0.typewriter:setSpeed(100000000)
	end
end

function var0.OnClear(arg0)
	if arg0.spriteMask then
		setActive(arg0.spriteMask, true)

		arg0.spriteMask = nil
	end
end

function var0.FadeOutPainting(arg0, arg1, arg2, arg3)
	local var0 = arg2:GetComponent(typeof(CanvasGroup))
	local var1 = arg1:GetFadeOutPaintingTime()

	if var1 <= 0 then
		arg3()

		return
	end

	local var2 = arg1:ShouldAddHeadMaskWhenFade()

	if var2 then
		arg0:AddHeadMask(arg2)
	end

	arg0:TweenValueForcanvasGroup(var0, 1, 0, var1, 0, function()
		if var2 then
			arg0:ClearHeadMask(arg2)
		end

		arg3()
	end)
end

function var0.OnWillExit(arg0, arg1, arg2, arg3)
	if not arg2 or not arg2:IsDialogueMode() then
		arg3()

		return
	end

	local var0 = arg0:GetRecycleActorList(arg2, arg1)
	local var1

	if arg2:ShouldMoveToSide() then
		var1 = arg0:GetSideTF(arg1:GetSide())
	end

	local var2 = {}

	for iter0, iter1 in pairs(var0) do
		if (not var1 or iter1 ~= var1) and iter1:Find("fitter").childCount > 0 then
			table.insert(var2, function(arg0)
				arg0:FadeOutPainting(arg1, iter1, arg0)
			end)
		end
	end

	parallelAsync(var2, arg3)
end

function var0.OnEnd(arg0)
	arg0.conentTxt.fontSize = arg0.defualtFontSize

	arg0:ClearGlitchArtForPortrait()
	arg0:ClearCanMarkNode()

	local var0 = {
		"actorLeft",
		"actorMiddle",
		"actorRgiht"
	}

	arg0:RecyclePainting(var0)

	arg0.conentTxt.text = ""
	arg0.nameTxt.text = ""

	for iter0, iter1 in ipairs({
		"actorLeft",
		"actorMiddle",
		"actorRgiht"
	}) do
		arg0[iter1]:GetComponent(typeof(CanvasGroup)).alpha = 1
	end
end

return var0
