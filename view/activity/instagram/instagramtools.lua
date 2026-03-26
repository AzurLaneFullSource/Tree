return {
	ExistOfficialAccounts = function()
		local var0_1 = getProxy(InstagramProxy)

		return table.getCount(var0_1:GetOfficialAccounts()) > 0
	end
}
