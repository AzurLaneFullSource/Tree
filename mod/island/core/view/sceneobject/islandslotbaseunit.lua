local var0_0 = class("IslandSlotBaseUnit", import(".IslandSceneUnit"))

function var0_0.Ctor(arg0_1, arg1_1, arg2_1)
	var0_0.super.Ctor(arg0_1, arg1_1, arg2_1)
end

function var0_0.GetHudInfo(arg0_2)
	local var0_2 = {}

	var0_2.needShowHud = true

	return var0_2
end

function var0_0.LoadSceneItemRes(arg0_3, arg1_3, arg2_3)
	arg0_3:GetPoolMgr():GetSceneProductItem(arg1_3, arg2_3)
end

function var0_0.UnLoadSceneItemRes(arg0_4, arg1_4, arg2_4)
	arg0_4:GetPoolMgr():ReturnSceneProductItem(arg1_4, arg2_4)
end

function var0_0.LoadSceneEffectItemRes(arg0_5, arg1_5, arg2_5)
	arg0_5:GetPoolMgr():GetSceneProductEffect(arg1_5, arg2_5)
end

function var0_0.UnLoadSceneEffecttemRes(arg0_6, arg1_6, arg2_6)
	arg0_6:GetPoolMgr():ReturnSceneProductEffect(arg1_6, arg2_6)
end

return var0_0
