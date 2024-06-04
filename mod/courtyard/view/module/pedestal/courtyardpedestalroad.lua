local var0 = class("CourtYardPedestalRoad", import(".CourtYardPedestalStructure"))
local var1 = {
	-920,
	-1080,
	-1230,
	-1230
}

function var0.GetAssetPath(arg0)
	return "furnitrues/base/road_" .. arg0.level
end

function var0.OnLoaded(arg0, arg1)
	setAnchoredPosition(arg1, Vector3(0, var1[arg0.level], 0))

	if arg0.level ~= 4 then
		onButton(arg0, arg1.transform:Find("warn"), function()
			if CourtYardConst.MAX_STOREY_LEVEL + 1 == arg0.level then
				return
			end

			if arg0:IsEditModeOrIsVisit() then
				return
			end

			arg0.parent.msgBox:ExecuteAction("Show")
		end, SFX_PANEL)
		onButton(arg0, arg1, function()
			if CourtYardConst.MAX_STOREY_LEVEL + 1 == arg0.level then
				return
			end

			if arg0:IsEditModeOrIsVisit() then
				return
			end

			arg0.parent.msgBox:ExecuteAction("Show")
		end, SFX_PANEL)
	end

	tf(arg1):SetSiblingIndex(0)
end

return var0
