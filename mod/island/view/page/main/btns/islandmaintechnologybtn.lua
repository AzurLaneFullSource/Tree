local var0_0 = class("IslandMainTechnologyBtn", import(".IslandMainBaseBtn"))

var0_0.STATUS = {
	STUDYING = 1,
	NORMAL = 3,
	UNLOCK = 2
}
var0_0.STATUS2ICON = {
	[var0_0.STATUS.STUDYING] = "technology_studying",
	[var0_0.STATUS.UNLOCK] = "technology_unlock",
	[var0_0.STATUS.NORMAL] = "technology"
}

function var0_0.Init(arg0_1)
	arg0_1._tf.name = arg0_1.config.btn_name

	onButton(arg0_1, arg0_1._tf, function()
		arg0_1:OnClick()
	end, SFX_PANEL)
end

function var0_0.Flush(arg0_3)
	var0_0.super.Flush(arg0_3)
	arg0_3:StatusCheck()
end

function var0_0.StatusCheck(arg0_4)
	local var0_4 = arg0_4:GetStatus()

	if not arg0_4.status or arg0_4.status ~= var0_4 then
		arg0_4.status = var0_4

		LoadImageSpriteAtlasAsync("island/islandbtnicon", var0_0.STATUS2ICON[arg0_4.status], arg0_4.iconTF, true)
	end
end

function var0_0.GetStatus(arg0_5)
	local var0_5 = getProxy(IslandProxy):GetIsland()
	local var1_5 = var0_5:GetTechnologyAgency()
	local var2_5 = var0_5:GetBuildingAgency():GetBuilding(IslandTechnologyAgency.PLACE_ID)
	local var3_5 = IslandTechnologyAgency.GetSlotIds()

	for iter0_5, iter1_5 in ipairs(var3_5) do
		local var4_5 = var2_5:GetDelegationSlotData(iter1_5)

		if var4_5 and var4_5:GetSlotRoleData() then
			return var0_0.STATUS.STUDYING
		end
	end

	for iter2_5, iter3_5 in pairs(var1_5:GetTechnologys()) do
		if iter3_5:IsUnlock() and iter3_5:GetFinishedCnt() <= 0 then
			return var0_0.STATUS.UNLOCK
		end
	end

	return var0_0.STATUS.NORMAL
end

return var0_0
