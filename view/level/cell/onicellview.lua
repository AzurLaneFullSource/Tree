local var0_0 = import(".DynamicCellView")
local var1_0 = class("OniCellView", var0_0)

function var1_0.Ctor(arg0_1, arg1_1)
	var1_0.super.Ctor(arg0_1, arg1_1)

	arg0_1.tfShadow = arg0_1.tf:Find("shadow")
	arg0_1.tfIcon = arg0_1.tf:Find("ship/icon")
end

function var1_0.GetOrder(arg0_2)
	return ChapterConst.CellPriorityLittle
end

function var1_0.SetActive(arg0_3, arg1_3)
	SetActive(arg0_3.tf, arg1_3)
end

function var1_0.UpdateChampionCell(arg0_4, arg1_4, arg2_4, arg3_4)
	local var0_4 = arg2_4.trait ~= ChapterConst.TraitLurk and arg1_4:getChampionVisibility(arg2_4) and not arg1_4:existFleet(FleetType.Transport, arg2_4.row, arg2_4.column)
	local var1_4 = 1

	_.each(arg1_4.fleets, function(arg0_5)
		if arg2_4:inAlertRange(arg0_5.line.row, arg0_5.line.column) then
			var1_4 = var1_4 + 1
		end
	end)
	GetImageSpriteFromAtlasAsync("enemies/sp_" .. var1_4, "", arg0_4.tfIcon, true)

	arg0_4.tfShadow.localEulerAngles = Vector3(arg1_4.theme.angle, 0, 0)

	arg0_4:RefreshLinePosition(arg1_4, arg2_4)
	arg0_4:SetActive(var0_4)
	existCall(arg3_4)
end

return var1_0
