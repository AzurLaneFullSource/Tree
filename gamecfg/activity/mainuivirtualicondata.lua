return {
	CurrentIconList = {
		1
	},
	{
		Image = "doa_virtual_buff",
		IsVirtualIcon = true,
		CheckExist = function()
			local var0_1 = getProxy(ActivityProxy):getActivityById(ActivityConst.DOA_PT_ID)

			if not var0_1 then
				return false
			end

			local var1_1 = ActivityPtData.New(var0_1)

			if not var0_1:isEnd() and var1_1:isInBuffTime() then
				return true
			end

			return false
		end
	}
}
