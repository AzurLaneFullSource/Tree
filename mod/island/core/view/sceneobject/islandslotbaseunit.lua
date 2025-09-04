local var0_0 = class("IslandSlotBaseUnit", import(".IslandSceneUnit"))

function var0_0.Ctor(arg0_1, arg1_1, arg2_1)
	var0_0.super.Ctor(arg0_1, arg1_1, arg2_1)
end

function var0_0.OnInit(arg0_2, arg1_2, arg2_2)
	var0_0.super.OnInit(arg0_2, arg1_2, arg2_2)
	arg0_2:LoadProductItem()
end

function var0_0.LoadProductItem(arg0_3)
	local var0_3 = arg0_3.data:GetProductModelId()

	if not var0_3 then
		if arg0_3.productItemGo then
			arg0_3:UnLoadProductItemRes()
		end

		return
	end

	arg0_3.productItemPath = pg.island_unit_item[var0_3].model

	local function var1_3(arg0_4)
		setParent(arg0_4, arg0_3:GetView().root)

		arg0_4.transform.position = arg0_3.position
		arg0_4.transform.eulerAngles = arg0_3.rotation
		arg0_3.productItemGo = arg0_4
	end

	arg0_3:LoadProductItemRes(var1_3)
end

function var0_0.ChangeModel(arg0_5)
	if arg0_5.data:ChangeModel() then
		if arg0_5.productItemGo then
			arg0_5:UnLoadProductItemRes()
		end

		arg0_5:LoadProductItem()
	end
end

function var0_0.OnUpdate(arg0_6)
	arg0_6:ChangeModel()
end

function var0_0.OnDispose(arg0_7)
	var0_0.super.OnDispose(arg0_7)

	if arg0_7.productItemGo then
		arg0_7:UnLoadProductItemRes()
	end
end

function var0_0.GetHudInfo(arg0_8)
	local var0_8 = {}

	var0_8.needShowHud = true

	return var0_8
end

function var0_0.LoadProductItemRes(arg0_9, arg1_9)
	arg0_9:GetPoolMgr():GetSceneProductItem(arg0_9.productItemPath, arg1_9)
end

function var0_0.UnLoadProductItemRes(arg0_10)
	arg0_10:GetPoolMgr():ReturnSceneProductItem(arg0_10.productItemPath, arg0_10.productItemGo)
end

function var0_0.LoadEffectItemRes(arg0_11, arg1_11)
	arg0_11:GetPoolMgr():GetSceneProductEffect(arg0_11.effectPath, arg1_11)
end

function var0_0.UnLoadEffectItemRes(arg0_12)
	arg0_12:GetPoolMgr():ReturnSceneProductEffect(arg0_12.effectPath, arg0_12.effectGo)
end

function var0_0.OnDetach(arg0_13)
	arg0_13:GetPoolMgr():ClearSceneProductItem()
	arg0_13:GetPoolMgr():ClearSceneProductEffect()
end

return var0_0
