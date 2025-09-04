local var0_0 = class("SyncLocalPlayer")

var0_0.ANIMATOR_LAYER = {
	0,
	1,
	2
}

function var0_0.Ctor(arg0_1, arg1_1, arg2_1)
	arg0_1.id = arg1_1
	arg0_1.sceneObject = arg2_1
	arg0_1.animator = arg2_1:GetAnimator()
end

function var0_0.GetStatus(arg0_2)
	local var0_2 = {}

	for iter0_2, iter1_2 in ipairs(arg0_2.ANIMATOR_LAYER) do
		var0_2[iter0_2] = arg0_2.animator:GetCurrentAnimatorStateInfo(iter1_2).shortNameHash
	end

	return var0_2
end

function var0_0.IsLoaded(arg0_3)
	return arg0_3.sceneObject and arg0_3.sceneObject:IsLoaded()
end

function var0_0.SetInTimeline(arg0_4, arg1_4)
	arg0_4.inTimeline = arg1_4
end

function var0_0.InTimeline(arg0_5)
	return arg0_5.inTimeline
end

function var0_0.CreateSyncData(arg0_6)
	return (SyncUnitData.New({
		id = arg0_6.id,
		pos = arg0_6:GetLocalPosition(),
		dir = arg0_6:GetRotation(),
		status = arg0_6:GetStatus()
	}))
end

function var0_0.GetLocalPosition(arg0_7)
	return arg0_7.sceneObject._go.transform.localPosition
end

function var0_0.GetRotation(arg0_8)
	return arg0_8.sceneObject._go.transform.rotation
end

return var0_0
