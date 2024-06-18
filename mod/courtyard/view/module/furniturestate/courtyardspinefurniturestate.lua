local var0_0 = class("CourtyardSpineFurnitureState")

function var0_0.Ctor(arg0_1, arg1_1, arg2_1, arg3_1, arg4_1, arg5_1)
	arg0_1._tf = arg1_1.transform
	arg0_1.rectTF = arg2_1
	arg0_1.rootTF = arg0_1._tf.parent
	arg0_1.furnitureSpineStateSkeletonGraphic = arg0_1._tf:GetComponent("Spine.Unity.SkeletonGraphic")
	arg0_1.furnitureSpineStateAnim = arg0_1._tf:GetComponent(typeof(Animation))
	arg0_1.selectedMat = arg3_1
	arg0_1.canPlaceMat = arg4_1
	arg0_1.cantPlaceMat = arg5_1
end

function var0_0.Init(arg0_2, arg1_2, arg2_2)
	pg.UIMgr.GetInstance():LoadingOn(false)
	setActive(arg0_2._tf, false)
	ResourceMgr.Inst:getAssetAsync("sfurniture/" .. arg2_2:GetFirstSlot():GetName(), "", typeof(GameObject), UnityEngine.Events.UnityAction_UnityEngine_Object(function(arg0_3)
		pg.UIMgr.GetInstance():LoadingOff()

		if arg0_2.exited then
			return
		end

		arg0_2._tf.pivot = arg0_3.transform.pivot
		arg0_2._tf.sizeDelta = arg0_3.transform.sizeDelta
		arg0_2._tf.localPosition = arg1_2:GetSpinePoint()
		arg0_2.furnitureSpineStateSkeletonGraphic.skeletonDataAsset = arg0_3.transform:Find("spine"):GetComponent("Spine.Unity.SkeletonGraphic").skeletonDataAsset

		arg0_2.furnitureSpineStateSkeletonGraphic:Initialize(true)
		setActive(arg0_2._tf, true)

		arg0_2.furnitureSpineStateAnimUI = GetOrAddComponent(arg0_2._tf, typeof(SpineAnimUI))

		arg0_2:OnUpdateScale(arg1_2)
		arg0_2:OnReset(arg1_2)
	end), true, true)
end

function var0_0.OnInit(arg0_4, arg1_4, arg2_4)
	arg0_4:Init(arg1_4, arg2_4)
	setParent(arg0_4._tf, arg0_4.rectTF)
end

function var0_0.OnUpdateScale(arg0_5, arg1_5)
	local var0_5 = CourtYardCalcUtil.GetSign(arg1_5._tf.localScale.x)

	arg0_5._tf.localScale = Vector3(var0_5, 1, 1)
end

function var0_0.OnUpdate(arg0_6, arg1_6)
	arg0_6._tf.localPosition = arg1_6:GetSpinePoint()
end

function var0_0.OnCantPlace(arg0_7)
	if arg0_7.furnitureSpineStateSkeletonGraphic.material ~= arg0_7.cantPlaceMat then
		arg0_7.furnitureSpineStateSkeletonGraphic.material = arg0_7.cantPlaceMat

		arg0_7.furnitureSpineStateAnim:Play("anim_courtyard_spinered")
	end
end

function var0_0.OnCanPlace(arg0_8)
	if arg0_8.furnitureSpineStateSkeletonGraphic.material ~= arg0_8.canPlaceMat then
		arg0_8.furnitureSpineStateSkeletonGraphic.material = arg0_8.canPlaceMat

		arg0_8.furnitureSpineStateAnim:Play("anim_courtyard_spinegreen")
	end
end

function var0_0.OnReset(arg0_9, arg1_9)
	if arg0_9.furnitureSpineStateSkeletonGraphic.material ~= arg0_9.selectedMat then
		arg0_9.furnitureSpineStateSkeletonGraphic.material = arg0_9.selectedMat

		arg0_9.furnitureSpineStateAnim:Play("anim_courtyard_spinewhite")
	end

	local var0_9 = arg1_9.animator:GetNormalAnimationName()

	if var0_9 then
		arg1_9.animator:RestartAnimation(var0_9)
		arg0_9.furnitureSpineStateAnimUI:SetAction(var0_9, 0)
	end
end

function var0_0.OnClear(arg0_10)
	if arg0_10.furnitureSpineStateAnimUI then
		Object.Destroy(arg0_10.furnitureSpineStateAnimUI)

		arg0_10.furnitureSpineStateAnimUI = nil
	end

	setParent(arg0_10._tf, arg0_10.rootTF)
end

return var0_0
