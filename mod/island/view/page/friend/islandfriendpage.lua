local var0_0 = class("IslandFriendPage", import("...base.IslandBasePage"))

function var0_0.getUIName(arg0_1)
	return "IslandFriendUI"
end

function var0_0.OnLoaded(arg0_2)
	arg0_2.uiItemList = UIItemList.New(arg0_2:findTF("scrollrect/content"), arg0_2:findTF("scrollrect/content/tpl"))
end

function var0_0.OnInit(arg0_3)
	onButton(arg0_3, arg0_3._tf, function()
		arg0_3:Hide()
	end, SFX_PANEL)
end

function var0_0.AddListeners(arg0_5)
	return
end

function var0_0.RemoveListeners(arg0_6)
	return
end

function var0_0.Show(arg0_7)
	var0_0.super.Show(arg0_7)

	local var0_7 = getProxy(IslandProxy):GetIsland()

	arg0_7:InitList()
end

function var0_0.InitList(arg0_8)
	local var0_8 = getProxy(FriendProxy):getAllFriends()

	arg0_8.uiItemList:make(function(arg0_9, arg1_9, arg2_9)
		if arg0_9 == UIItemList.EventUpdate then
			arg0_8:UpdateFriendCard(arg2_9, var0_8[arg1_9 + 1])
		end
	end)
	arg0_8.uiItemList:align(#var0_8)
end

function var0_0.UpdateFriendCard(arg0_10, arg1_10, arg2_10)
	setText(arg1_10:Find("name"), arg2_10:GetName())
	onButton(arg0_10, arg1_10:Find("enter"), function()
		return
	end, SFX_PANEL)
	onButton(arg0_10, arg1_10:Find("invite"), function()
		arg0_10:emit(IslandMediator.ON_INVITE_PLAYER, arg2_10.id)
	end, SFX_PANEL)
end

function var0_0.Hide(arg0_13)
	var0_0.super.Hide(arg0_13)
end

function var0_0.OnDestroy(arg0_14)
	return
end

return var0_0
