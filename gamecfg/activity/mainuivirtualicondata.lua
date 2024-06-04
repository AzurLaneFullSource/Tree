return {
	CurrentIconList = {
		1
	},
	{
		Image = "doa_virtual_buff",
		IsVirtualIcon = true,
		CheckExist = function()
			local var0 = getProxy(ActivityProxy):getActivityById(ActivityConst.DOA_PT_ID)

			if not var0 then
				return false
			end

			local var1 = ActivityPtData.New(var0)

			if not var0:isEnd() and var1:isInBuffTime() then
				return true
			end

			return false
		end
	}
}
