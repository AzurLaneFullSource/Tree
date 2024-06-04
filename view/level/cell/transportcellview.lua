local var0 = class("TransportCellView", import(".OniCellView"))

function var0.Ctor(arg0, arg1)
	var0.super.Ctor(arg0, arg1)

	arg0.tfShadow = arg0.tf:Find("shadow")
	arg0.tfIcon = arg0.tf:Find("ship/icon")
	arg0.tfHp = arg0.tf:Find("hp")
	arg0.tfHpText = arg0.tf:Find("hp/text")
	arg0.tfFighting = arg0.tf:Find("fighting")
end

function var0.GetRotatePivot(arg0)
	return arg0.tfIcon
end

function var0.GetOrder(arg0)
	return ChapterConst.CellPriorityLittle
end

function var0.SetActive(arg0, arg1)
	SetActive(arg0.tf, arg1)
end

function var0.LoadIcon(arg0, arg1, arg2)
	if arg1 == "" or arg0.lastPrefab == arg1 then
		existCall(arg2)

		return
	end

	arg0.lastPrefab = arg1

	arg0:GetLoader():GetSpriteQuiet("enemies/" .. arg1, arg1, arg0.tfIcon)
	existCall(arg2)
end

return var0
