local var0 = class("CourtYardPlaceableModule", import(".CourtYardBaseModule"))

function var0.Ctor(arg0, arg1, arg2)
	arg0.state = 0

	pg.DelegateInfo.New(arg0)

	arg0._go = arg2
	arg0._tf = arg2.transform
	arg0.data = arg1
	arg0.callbacks = {}
	arg0.iconLoaded = false
	arg0.pudding = false
	arg0.completion = false
	arg0.cg = arg0._tf:GetComponent(typeof(CanvasGroup))
	arg0.rect = arg0:GetView():GetRect()
	arg0.floor = arg0.rect:Find("floor")
	arg0.wall = arg0.rect:Find("wall")
	arg0.mat = arg0.rect:Find("carpet")
	arg0.gridsTF = arg0._tf:Find("grids")
	arg0.childsTF = arg0._tf:Find("childs")
	arg0.interactionTF = arg0._tf:Find("interaction")
	arg0.bones = {}

	local var0 = arg0.data:GetDirection()

	arg0._tf.localScale = Vector3(var0 == 1 and 1 or -1, 1, 1)

	setParent(arg0._tf, arg0:GetParentTF())
	arg0:UpdatePosition(arg0.data:GetPosition(), Vector3.zero)
end

function var0.IsCompletion(arg0)
	return arg0.completion and not arg0.doPuddingAniming
end

function var0.OnIconLoaed(arg0)
	arg0.iconLoaded = true

	if arg0.pudding then
		arg0:PuddingAnim()
	end
end

function var0.OnInit(arg0)
	arg0.dragAgent = CourtYardDragAgent.New(arg0, arg0:GetView():GetRect())
	arg0.completion = true
end

function var0.CreateWhenStoreyInit(arg0)
	arg0:PuddingAnim()
end

function var0.BlocksRaycasts(arg0, arg1)
	return
end

local var1 = "follower_"

function var0.NewBoneFollower(arg0, arg1)
	local var0 = var1 .. arg1
	local var1 = GameObject.New(var0, typeof(RectTransform))
	local var2 = var1.transform

	var2:SetParent(arg0.interactionTF, false)

	local var3 = GetOrAddComponent(var1, typeof(Spine.Unity.BoneFollowerGraphic))

	var3.followLocalScale = true
	var3.skeletonGraphic = arg0:GetSpine():GetComponent("Spine.Unity.SkeletonGraphic")

	var3:SetBone(arg1)

	arg0.bones[var0] = var2

	return var2.transform
end

function var0.FindBoneFollower(arg0, arg1)
	local var0 = var1 .. arg1

	return arg0.bones[var0]
end

function var0.PuddingAnim(arg0)
	if not arg0.iconLoaded then
		arg0.pudding = true

		return
	end

	arg0.doPuddingAniming = true

	local var0 = arg0._tf.localScale.x
	local var1 = arg0._tf.localScale.y

	arg0.normalX, arg0.normalY = var0, var1

	LeanTween.scale(rtf(arg0._tf), Vector3(var0 + 0.2, var1 + 0.2, 1), 0.2):setFrom(0):setOnComplete(System.Action(function()
		LeanTween.scale(rtf(arg0._tf), Vector3(var0, var1, 1), 0.1):setOnComplete(System.Action(function()
			arg0.doPuddingAniming = false
		end))
	end))

	arg0.pudding = false
end

function var0.CancelPuddingAnim(arg0)
	if arg0.doPuddingAniming then
		LeanTween.cancel(arg0._tf.gameObject)

		arg0._tf.localScale = Vector3(arg0.normalX, arg0.normalY, 1)
		arg0.doPuddingAniming = nil
	end
end

function var0.GetParentTF(arg0)
	if arg0.data:GetDeathType() == CourtYardConst.DEPTH_TYPE_MAT then
		return arg0.mat
	else
		return arg0.floor
	end
end

function var0.GetSpine(arg0)
	assert(false)
end

function var0.GetData(arg0)
	return arg0.data
end

function var0.SetSiblingIndex(arg0, arg1)
	if arg1 ~= arg0._tf:GetSiblingIndex() then
		arg0._tf:SetSiblingIndex(arg1)
	end

	arg0._go.name = arg0.data.id .. "_" .. arg1
end

function var0.SetAsLastSibling(arg0)
	arg0._go.name = arg0.data.id

	arg0._tf:SetAsLastSibling()
end

function var0.SetActive(arg0, arg1)
	setActive(arg0._tf, arg1)
end

function var0.UpdatePosition(arg0, arg1, arg2)
	local var0 = CourtYardCalcUtil.Map2Local(arg1) + (arg2 or Vector3.zero)
	local var1 = CourtYardCalcUtil.TrPosition2LocalPos(arg0:GetParentTF(), arg0._tf.parent, var0)

	arg0._tf.localPosition = var1
end

function var0.OnDispose(arg0)
	for iter0, iter1 in pairs(arg0.bones) do
		if not IsNil(iter1) then
			Object.Destroy(iter1.gameObject)
		end
	end

	arg0.bones = {}

	if arg0.dragAgent then
		arg0.dragAgent:Dispose()

		arg0.dragAgent = nil
	end

	if LeanTween.isTweening(go(arg0._tf)) then
		LeanTween.cancel(go(arg0._tf))
	end
end

function var0.OnDestroy(arg0)
	return
end

function var0.OnBeginDrag(arg0)
	return
end

function var0.OnDragging(arg0, arg1)
	return
end

function var0.OnDragEnd(arg0, arg1)
	return
end

return var0
