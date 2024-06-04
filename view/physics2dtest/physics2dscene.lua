local var0 = class("Physics2dScene", import("..base.BaseUI"))

function var0.getUIName(arg0)
	return "PhysicsTest"
end

function var0.init(arg0)
	arg0._backBtn = arg0:findTF("back_btn")
	arg0._box = arg0:findTF("box")
	arg0._boxRig = GetComponent(arg0._box, "Rigidbody2D")
	arg0._boxPhyItem = GetComponent(arg0._box, "Physics2DItem")

	Physics2DMgr.Inst:AddSimulateItem(arg0._boxPhyItem)

	arg0._gizmos = arg0:findTF("res/gizmos")
end

function var0.didEnter(arg0)
	onButton(arg0, arg0._backBtn, function()
		arg0:emit(var0.ON_BACK)
	end)

	local var0 = arg0._tf:TransformPoint(Vector3(-578, -390))

	arg0._boxRig.position = var0

	arg0._boxPhyItem.CollisionEnter:AddListener(function(arg0)
		if Physics2D.autoSimulation then
			print("=========================")
			print(arg0.collider.gameObject.name)
			print(arg0.otherCollider.gameObject.name)

			if arg0.collider.gameObject.name ~= "ground" then
				LeanTween.scale(arg0.collider.gameObject, Vector3(0, 0, 0), 1)
			end
		end
	end)
	onDelayTick(function()
		arg0:simulateDrawPath()
	end, 1)
	onDelayTick(function()
		arg0:jump()
	end, 3)
end

function var0.jump(arg0)
	local var0 = arg0._tf:TransformPoint(Vector3(-578, -390))

	arg0._boxRig.position = var0
	arg0._boxRig.velocity = Vector2(10, 10)
end

function var0.simulateDrawPath(arg0)
	Physics2DMgr.Inst:DoPrediction(0.1, 50, function()
		arg0:jump()
	end, function()
		local var0 = instantiate(arg0._gizmos)

		setParent(tf(var0), arg0._tf, false)
		setAnchoredPosition(var0, arg0._tf:InverseTransformVector(arg0._boxRig.position))
	end)
end

function var0.willExit(arg0)
	Physics2DMgr.Inst:RemoveSimulateItem(arg0._boxPhyItem)
	arg0._boxPhyItem.CollisionEnter:RemoveAllListeners()
end

return var0
