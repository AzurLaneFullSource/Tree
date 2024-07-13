local var0_0 = class("Physics2dScene", import("..base.BaseUI"))

function var0_0.getUIName(arg0_1)
	return "PhysicsTest"
end

function var0_0.init(arg0_2)
	arg0_2._backBtn = arg0_2:findTF("back_btn")
	arg0_2._box = arg0_2:findTF("box")
	arg0_2._boxRig = GetComponent(arg0_2._box, "Rigidbody2D")
	arg0_2._boxPhyItem = GetComponent(arg0_2._box, "Physics2DItem")

	Physics2DMgr.Inst:AddSimulateItem(arg0_2._boxPhyItem)

	arg0_2._gizmos = arg0_2:findTF("res/gizmos")
end

function var0_0.didEnter(arg0_3)
	onButton(arg0_3, arg0_3._backBtn, function()
		arg0_3:emit(var0_0.ON_BACK)
	end)

	local var0_3 = arg0_3._tf:TransformPoint(Vector3(-578, -390))

	arg0_3._boxRig.position = var0_3

	arg0_3._boxPhyItem.CollisionEnter:AddListener(function(arg0_5)
		if Physics2D.autoSimulation then
			print("=========================")
			print(arg0_5.collider.gameObject.name)
			print(arg0_5.otherCollider.gameObject.name)

			if arg0_5.collider.gameObject.name ~= "ground" then
				LeanTween.scale(arg0_5.collider.gameObject, Vector3(0, 0, 0), 1)
			end
		end
	end)
	onDelayTick(function()
		arg0_3:simulateDrawPath()
	end, 1)
	onDelayTick(function()
		arg0_3:jump()
	end, 3)
end

function var0_0.jump(arg0_8)
	local var0_8 = arg0_8._tf:TransformPoint(Vector3(-578, -390))

	arg0_8._boxRig.position = var0_8
	arg0_8._boxRig.velocity = Vector2(10, 10)
end

function var0_0.simulateDrawPath(arg0_9)
	Physics2DMgr.Inst:DoPrediction(0.1, 50, function()
		arg0_9:jump()
	end, function()
		local var0_11 = instantiate(arg0_9._gizmos)

		setParent(tf(var0_11), arg0_9._tf, false)
		setAnchoredPosition(var0_11, arg0_9._tf:InverseTransformVector(arg0_9._boxRig.position))
	end)
end

function var0_0.willExit(arg0_12)
	Physics2DMgr.Inst:RemoveSimulateItem(arg0_12._boxPhyItem)
	arg0_12._boxPhyItem.CollisionEnter:RemoveAllListeners()
end

return var0_0
