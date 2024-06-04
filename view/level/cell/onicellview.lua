local var0 = import(".DynamicCellView")
local var1 = class("OniCellView", var0)

function var1.Ctor(arg0, arg1)
	var1.super.Ctor(arg0, arg1)

	arg0.tfShadow = arg0.tf:Find("shadow")
	arg0.tfIcon = arg0.tf:Find("ship/icon")
end

function var1.GetOrder(arg0)
	return ChapterConst.CellPriorityLittle
end

function var1.SetActive(arg0, arg1)
	SetActive(arg0.tf, arg1)
end

function var1.UpdateChampionCell(arg0, arg1, arg2, arg3)
	local var0 = arg2.trait ~= ChapterConst.TraitLurk and arg1:getChampionVisibility(arg2) and not arg1:existFleet(FleetType.Transport, arg2.row, arg2.column)
	local var1 = 1

	_.each(arg1.fleets, function(arg0)
		if arg2:inAlertRange(arg0.line.row, arg0.line.column) then
			var1 = var1 + 1
		end
	end)
	GetImageSpriteFromAtlasAsync("enemies/sp_" .. var1, "", arg0.tfIcon, true)

	arg0.tfShadow.localEulerAngles = Vector3(arg1.theme.angle, 0, 0)

	arg0:RefreshLinePosition(arg1, arg2)
	arg0:SetActive(var0)
	existCall(arg3)
end

return var1
