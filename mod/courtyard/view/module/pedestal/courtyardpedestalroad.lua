local var0_0 = class("CourtYardPedestalRoad", import(".CourtYardPedestalStructure"))
local var1_0 = {
	-920,
	-1080,
	-1230,
	-1230
}

function var0_0.GetAssetPath(arg0_1)
	return "furnitrues/base/road_" .. arg0_1.level
end

function var0_0.OnLoaded(arg0_2, arg1_2)
	setAnchoredPosition(arg1_2, Vector3(0, var1_0[arg0_2.level], 0))

	if arg0_2.level ~= 4 then
		onButton(arg0_2, arg1_2.transform:Find("warn"), function()
			if CourtYardConst.MAX_STOREY_LEVEL + 1 == arg0_2.level then
				return
			end

			if arg0_2:IsEditModeOrIsVisit() then
				return
			end

			arg0_2.parent.msgBox:ExecuteAction("Show")
		end, SFX_PANEL)
		onButton(arg0_2, arg1_2, function()
			if CourtYardConst.MAX_STOREY_LEVEL + 1 == arg0_2.level then
				return
			end

			if arg0_2:IsEditModeOrIsVisit() then
				return
			end

			arg0_2.parent.msgBox:ExecuteAction("Show")
		end, SFX_PANEL)
	end

	tf(arg1_2):SetSiblingIndex(0)
end

return var0_0
