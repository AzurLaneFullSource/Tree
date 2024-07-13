local var0_0 = class("TransportCellView", import(".OniCellView"))

function var0_0.Ctor(arg0_1, arg1_1)
	var0_0.super.Ctor(arg0_1, arg1_1)

	arg0_1.tfShadow = arg0_1.tf:Find("shadow")
	arg0_1.tfIcon = arg0_1.tf:Find("ship/icon")
	arg0_1.tfHp = arg0_1.tf:Find("hp")
	arg0_1.tfHpText = arg0_1.tf:Find("hp/text")
	arg0_1.tfFighting = arg0_1.tf:Find("fighting")
end

function var0_0.GetRotatePivot(arg0_2)
	return arg0_2.tfIcon
end

function var0_0.GetOrder(arg0_3)
	return ChapterConst.CellPriorityLittle
end

function var0_0.SetActive(arg0_4, arg1_4)
	SetActive(arg0_4.tf, arg1_4)
end

function var0_0.LoadIcon(arg0_5, arg1_5, arg2_5)
	if arg1_5 == "" or arg0_5.lastPrefab == arg1_5 then
		existCall(arg2_5)

		return
	end

	arg0_5.lastPrefab = arg1_5

	arg0_5:GetLoader():GetSpriteQuiet("enemies/" .. arg1_5, arg1_5, arg0_5.tfIcon)
	existCall(arg2_5)
end

return var0_0
