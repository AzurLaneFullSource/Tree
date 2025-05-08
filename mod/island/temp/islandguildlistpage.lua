local var0_0 = class("IslandGuildListPage", import(".IslandFriendListPage"))

function var0_0.UpdateData(arg0_1, arg1_1)
	local var0_1 = arg1_1.memberVOs

	var0_0.super.UpdateData(arg0_1, {
		friendVOs = var0_1
	})
end

return var0_0
