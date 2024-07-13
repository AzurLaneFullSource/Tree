local var0_0 = class("CourtYardPlaceableModule", import(".CourtYardBaseModule"))

function var0_0.Ctor(arg0_1, arg1_1, arg2_1)
	arg0_1.state = 0

	pg.DelegateInfo.New(arg0_1)

	arg0_1._go = arg2_1
	arg0_1._tf = arg2_1.transform
	arg0_1.data = arg1_1
	arg0_1.callbacks = {}
	arg0_1.iconLoaded = false
	arg0_1.pudding = false
	arg0_1.completion = false
	arg0_1.cg = arg0_1._tf:GetComponent(typeof(CanvasGroup))
	arg0_1.rect = arg0_1:GetView():GetRect()
	arg0_1.floor = arg0_1.rect:Find("floor")
	arg0_1.wall = arg0_1.rect:Find("wall")
	arg0_1.mat = arg0_1.rect:Find("carpet")
	arg0_1.gridsTF = arg0_1._tf:Find("grids")
	arg0_1.childsTF = arg0_1._tf:Find("childs")
	arg0_1.interactionTF = arg0_1._tf:Find("interaction")
	arg0_1.bones = {}

	local var0_1 = arg0_1.data:GetDirection()

	arg0_1._tf.localScale = Vector3(var0_1 == 1 and 1 or -1, 1, 1)

	setParent(arg0_1._tf, arg0_1:GetParentTF())
	arg0_1:UpdatePosition(arg0_1.data:GetPosition(), Vector3.zero)
end

function var0_0.IsCompletion(arg0_2)
	return arg0_2.completion and not arg0_2.doPuddingAniming
end

function var0_0.OnIconLoaed(arg0_3)
	arg0_3.iconLoaded = true

	if arg0_3.pudding then
		arg0_3:PuddingAnim()
	end
end

function var0_0.OnInit(arg0_4)
	arg0_4.dragAgent = CourtYardDragAgent.New(arg0_4, arg0_4:GetView():GetRect())
	arg0_4.completion = true
end

function var0_0.CreateWhenStoreyInit(arg0_5)
	arg0_5:PuddingAnim()
end

function var0_0.BlocksRaycasts(arg0_6, arg1_6)
	return
end

local var1_0 = "follower_"

function var0_0.NewBoneFollower(arg0_7, arg1_7)
	local var0_7 = var1_0 .. arg1_7
	local var1_7 = GameObject.New(var0_7, typeof(RectTransform))
	local var2_7 = var1_7.transform

	var2_7:SetParent(arg0_7.interactionTF, false)

	local var3_7 = GetOrAddComponent(var1_7, typeof(Spine.Unity.BoneFollowerGraphic))

	var3_7.followLocalScale = true
	var3_7.skeletonGraphic = arg0_7:GetSpine():GetComponent("Spine.Unity.SkeletonGraphic")

	var3_7:SetBone(arg1_7)

	arg0_7.bones[var0_7] = var2_7

	return var2_7.transform
end

function var0_0.FindBoneFollower(arg0_8, arg1_8)
	local var0_8 = var1_0 .. arg1_8

	return arg0_8.bones[var0_8]
end

function var0_0.PuddingAnim(arg0_9)
	if not arg0_9.iconLoaded then
		arg0_9.pudding = true

		return
	end

	arg0_9.doPuddingAniming = true

	local var0_9 = arg0_9._tf.localScale.x
	local var1_9 = arg0_9._tf.localScale.y

	arg0_9.normalX, arg0_9.normalY = var0_9, var1_9

	LeanTween.scale(rtf(arg0_9._tf), Vector3(var0_9 + 0.2, var1_9 + 0.2, 1), 0.2):setFrom(0):setOnComplete(System.Action(function()
		LeanTween.scale(rtf(arg0_9._tf), Vector3(var0_9, var1_9, 1), 0.1):setOnComplete(System.Action(function()
			arg0_9.doPuddingAniming = false
		end))
	end))

	arg0_9.pudding = false
end

function var0_0.CancelPuddingAnim(arg0_12)
	if arg0_12.doPuddingAniming then
		LeanTween.cancel(arg0_12._tf.gameObject)

		arg0_12._tf.localScale = Vector3(arg0_12.normalX, arg0_12.normalY, 1)
		arg0_12.doPuddingAniming = nil
	end
end

function var0_0.GetParentTF(arg0_13)
	if arg0_13.data:GetDeathType() == CourtYardConst.DEPTH_TYPE_MAT then
		return arg0_13.mat
	else
		return arg0_13.floor
	end
end

function var0_0.GetSpine(arg0_14)
	assert(false)
end

function var0_0.GetData(arg0_15)
	return arg0_15.data
end

function var0_0.SetSiblingIndex(arg0_16, arg1_16)
	if arg1_16 ~= arg0_16._tf:GetSiblingIndex() then
		arg0_16._tf:SetSiblingIndex(arg1_16)
	end

	arg0_16._go.name = arg0_16.data.id .. "_" .. arg1_16
end

function var0_0.SetAsLastSibling(arg0_17)
	arg0_17._go.name = arg0_17.data.id

	arg0_17._tf:SetAsLastSibling()
end

function var0_0.SetActive(arg0_18, arg1_18)
	setActive(arg0_18._tf, arg1_18)
end

function var0_0.UpdatePosition(arg0_19, arg1_19, arg2_19)
	local var0_19 = CourtYardCalcUtil.Map2Local(arg1_19) + (arg2_19 or Vector3.zero)
	local var1_19 = CourtYardCalcUtil.TrPosition2LocalPos(arg0_19:GetParentTF(), arg0_19._tf.parent, var0_19)

	arg0_19._tf.localPosition = var1_19
end

function var0_0.OnDispose(arg0_20)
	for iter0_20, iter1_20 in pairs(arg0_20.bones) do
		if not IsNil(iter1_20) then
			Object.Destroy(iter1_20.gameObject)
		end
	end

	arg0_20.bones = {}

	if arg0_20.dragAgent then
		arg0_20.dragAgent:Dispose()

		arg0_20.dragAgent = nil
	end

	if LeanTween.isTweening(go(arg0_20._tf)) then
		LeanTween.cancel(go(arg0_20._tf))
	end
end

function var0_0.OnDestroy(arg0_21)
	return
end

function var0_0.OnBeginDrag(arg0_22)
	return
end

function var0_0.OnDragging(arg0_23, arg1_23)
	return
end

function var0_0.OnDragEnd(arg0_24, arg1_24)
	return
end

return var0_0
