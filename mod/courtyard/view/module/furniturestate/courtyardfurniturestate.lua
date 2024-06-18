local var0_0 = class("CourtyardFurnitureState")

function var0_0.Ctor(arg0_1, arg1_1, arg2_1, arg3_1, arg4_1, arg5_1)
	arg0_1._tf = arg1_1.transform
	arg0_1.rectTF = arg2_1
	arg0_1.rootTF = arg0_1._tf.parent
	arg0_1.furnitureStateImg = arg0_1._tf:GetComponent(typeof(Image))
	arg0_1.furnitureStateAnim = arg0_1._tf:GetComponent(typeof(Animation))
	arg0_1.selectedMat = arg3_1
	arg0_1.canPlaceMat = arg4_1
	arg0_1.cantPlaceMat = arg5_1
end

function var0_0.Init(arg0_2, arg1_2, arg2_2)
	pg.UIMgr.GetInstance():LoadingOn(false)
	setActive(arg0_2._tf, false)
	ResourceMgr.Inst:getAssetAsync("furnitrues/" .. arg2_2:GetPicture(), "", typeof(GameObject), UnityEngine.Events.UnityAction_UnityEngine_Object(function(arg0_3)
		pg.UIMgr.GetInstance():LoadingOff()

		if arg0_2.exited then
			return
		end

		setActive(arg0_2._tf, true)

		arg0_2.furnitureStateImg.sprite = arg0_3:GetComponent(typeof(Image)).sprite
		arg0_2._tf.sizeDelta = arg0_3.transform.sizeDelta
		arg0_2._tf.localPosition = arg1_2:GetCenterPoint()

		arg0_2:OnUpdateScale(arg1_2)
		arg0_2:OnReset()
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
	arg0_6._tf.localPosition = arg1_6:GetCenterPoint()
end

function var0_0.OnCantPlace(arg0_7)
	if arg0_7.furnitureStateImg.material ~= arg0_7.cantPlaceMat then
		arg0_7.furnitureStateImg.material = arg0_7.cantPlaceMat

		arg0_7.furnitureStateAnim:Play("anim_courtyard_iconred")
	end
end

function var0_0.OnCanPlace(arg0_8)
	if arg0_8.furnitureStateImg.material ~= arg0_8.canPlaceMat then
		arg0_8.furnitureStateImg.material = arg0_8.canPlaceMat

		arg0_8.furnitureStateAnim:Play("anim_courtyard_icongreen")
	end
end

function var0_0.OnReset(arg0_9)
	if arg0_9.furnitureStateImg.material ~= arg0_9.selectedMat then
		arg0_9.furnitureStateImg.material = arg0_9.selectedMat

		arg0_9.furnitureStateAnim:Play("anim_courtyard_iconwhite")
	end
end

function var0_0.OnClear(arg0_10)
	arg0_10.furnitureStateAnim:Stop()

	arg0_10.furnitureStateImg.sprite = nil
	arg0_10.furnitureStateImg.material = nil

	setParent(arg0_10._tf, arg0_10.rootTF)
end

return var0_0
