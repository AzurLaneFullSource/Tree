local var0_0 = class("IslandBaseHudPanel", import(".IslandBaseUnit"))

function var0_0.Ctor(arg0_1, arg1_1, arg2_1, arg3_1)
	var0_0.super.Ctor(arg0_1, arg1_1)

	arg0_1.parentTF = arg3_1
	arg0_1.data = arg2_1
	arg0_1.unitId = arg2_1.id
	arg0_1.unitType = arg2_1.type
	arg0_1.unitTransform = arg2_1.unitTransform
	arg0_1.positionX = arg2_1.positionX
	arg0_1.positionY = arg2_1.positionY
	arg0_1.param1 = arg2_1.param1
end

function var0_0.Init(arg0_2, ...)
	PoolMgr.GetInstance():GetUI(arg0_2:GetUIName(), true, function(arg0_3)
		arg0_2._go = arg0_3
		arg0_2._tf = arg0_3.transform

		setParent(arg0_3, arg0_2.parentTF)
		var0_0.super.Init(arg0_2, arg0_3)
		arg0_2:Show()
		arg0_2:Refresh(arg0_2.data)
	end)
end

function var0_0.GetUIName(arg0_4)
	assert(false, "overwrite me")
end

function var0_0.OnInit(arg0_5)
	return
end

function var0_0.OnShow(arg0_6)
	return
end

function var0_0.Refresh(arg0_7, arg1_7)
	return
end

function var0_0.RefreshHud(arg0_8)
	return
end

function var0_0.Show(arg0_9)
	arg0_9.active = true

	if not arg0_9._tf then
		return
	end

	setActive(arg0_9._tf, true)
	arg0_9:OnShow()
end

function var0_0.Hide(arg0_10)
	if not arg0_10._tf then
		return
	end

	arg0_10.active = false

	setActive(arg0_10._tf, false)
end

function var0_0.OnDispose(arg0_11)
	PoolMgr.GetInstance():ReturnUI(arg0_11:GetUIName(), arg0_11._go)
end

return var0_0
