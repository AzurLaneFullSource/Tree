local var0 = class("CourtyardSpineFurnitureState")

function var0.Ctor(arg0, arg1, arg2, arg3, arg4, arg5)
	arg0._tf = arg1.transform
	arg0.rectTF = arg2
	arg0.rootTF = arg0._tf.parent
	arg0.furnitureSpineStateSkeletonGraphic = arg0._tf:GetComponent("Spine.Unity.SkeletonGraphic")
	arg0.furnitureSpineStateAnim = arg0._tf:GetComponent(typeof(Animation))
	arg0.selectedMat = arg3
	arg0.canPlaceMat = arg4
	arg0.cantPlaceMat = arg5
end

function var0.Init(arg0, arg1, arg2)
	pg.UIMgr.GetInstance():LoadingOn(false)
	setActive(arg0._tf, false)
	ResourceMgr.Inst:getAssetAsync("sfurniture/" .. arg2:GetFirstSlot():GetName(), "", typeof(GameObject), UnityEngine.Events.UnityAction_UnityEngine_Object(function(arg0)
		pg.UIMgr.GetInstance():LoadingOff()

		if arg0.exited then
			return
		end

		arg0._tf.pivot = arg0.transform.pivot
		arg0._tf.sizeDelta = arg0.transform.sizeDelta
		arg0._tf.localPosition = arg1:GetSpinePoint()
		arg0.furnitureSpineStateSkeletonGraphic.skeletonDataAsset = arg0.transform:Find("spine"):GetComponent("Spine.Unity.SkeletonGraphic").skeletonDataAsset

		arg0.furnitureSpineStateSkeletonGraphic:Initialize(true)
		setActive(arg0._tf, true)

		arg0.furnitureSpineStateAnimUI = GetOrAddComponent(arg0._tf, typeof(SpineAnimUI))

		arg0:OnUpdateScale(arg1)
		arg0:OnReset(arg1)
	end), true, true)
end

function var0.OnInit(arg0, arg1, arg2)
	arg0:Init(arg1, arg2)
	setParent(arg0._tf, arg0.rectTF)
end

function var0.OnUpdateScale(arg0, arg1)
	local var0 = CourtYardCalcUtil.GetSign(arg1._tf.localScale.x)

	arg0._tf.localScale = Vector3(var0, 1, 1)
end

function var0.OnUpdate(arg0, arg1)
	arg0._tf.localPosition = arg1:GetSpinePoint()
end

function var0.OnCantPlace(arg0)
	if arg0.furnitureSpineStateSkeletonGraphic.material ~= arg0.cantPlaceMat then
		arg0.furnitureSpineStateSkeletonGraphic.material = arg0.cantPlaceMat

		arg0.furnitureSpineStateAnim:Play("anim_courtyard_spinered")
	end
end

function var0.OnCanPlace(arg0)
	if arg0.furnitureSpineStateSkeletonGraphic.material ~= arg0.canPlaceMat then
		arg0.furnitureSpineStateSkeletonGraphic.material = arg0.canPlaceMat

		arg0.furnitureSpineStateAnim:Play("anim_courtyard_spinegreen")
	end
end

function var0.OnReset(arg0, arg1)
	if arg0.furnitureSpineStateSkeletonGraphic.material ~= arg0.selectedMat then
		arg0.furnitureSpineStateSkeletonGraphic.material = arg0.selectedMat

		arg0.furnitureSpineStateAnim:Play("anim_courtyard_spinewhite")
	end

	local var0 = arg1.animator:GetNormalAnimationName()

	if var0 then
		arg1.animator:RestartAnimation(var0)
		arg0.furnitureSpineStateAnimUI:SetAction(var0, 0)
	end
end

function var0.OnClear(arg0)
	if arg0.furnitureSpineStateAnimUI then
		Object.Destroy(arg0.furnitureSpineStateAnimUI)

		arg0.furnitureSpineStateAnimUI = nil
	end

	setParent(arg0._tf, arg0.rootTF)
end

return var0
