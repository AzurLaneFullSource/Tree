local var0_0 = class("IslandFriendListPage", import("view.friend.subPages.FriendListPage"))

function var0_0.getUIName(arg0_1)
	return "IslandFriendListUI"
end

function var0_0.onInitItem(arg0_2, arg1_2)
	var0_0.super.onInitItem(arg0_2, arg1_2)

	local var0_2 = arg0_2.friendItems[arg1_2]

	onButton(arg0_2, var0_2.tf:Find("frame/btns/island_btn"), function()
		arg0_2:emit(IslandFriendMediator.ENTER_ISLAND, var0_2.friendVO.id)
	end, SFX_PANEL)
end

function var0_0.onUpdateItem(arg0_4, arg1_4, arg2_4)
	var0_0.super.onUpdateItem(arg0_4, arg1_4, arg2_4)

	local var0_4 = arg0_4.friendItems[arg2_4]
	local var1_4 = var0_4.tf:Find("frame/btns")
	local var2_4 = var0_4.tf:Find("frame/access")

	setActive(var1_4, arg0_4.contextData.editMode == IslandFriendScene.MODE_VIEW)
	setActive(var2_4, arg0_4.contextData.editMode == IslandFriendScene.MODE_EDIT)

	local var3_4 = var2_4:Find("Toggle")

	removeOnToggle(var3_4)

	local var4_4 = getProxy(IslandProxy):GetIsland():GetAccessAgency()

	triggerToggle(var3_4, arg0_4:InWhiteList(var0_4.friendVO.id))
	onToggle(arg0_4, var3_4, function(arg0_5)
		if arg0_5 then
			arg0_4:AddWhiteList(var0_4.friendVO.id)
		else
			arg0_4:RemoveWhiteList(var0_4.friendVO.id)
		end
	end, SFX_PANEL)
end

function var0_0.InWhiteList(arg0_6, arg1_6)
	return table.contains(arg0_6.contextData.whiteList, arg1_6)
end

function var0_0.AddWhiteList(arg0_7, arg1_7)
	if not arg0_7:InWhiteList(arg1_7) then
		table.insert(arg0_7.contextData.whiteList, arg1_7)
	end
end

function var0_0.RemoveWhiteList(arg0_8, arg1_8)
	if arg0_8:InWhiteList(arg1_8) then
		table.removebyvalue(arg0_8.contextData.whiteList, arg1_8)
	end
end

return var0_0
