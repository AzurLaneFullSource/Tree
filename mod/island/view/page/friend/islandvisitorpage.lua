local var0_0 = class("IslandVisitorPage", import("...base.IslandBasePage"))

function var0_0.getUIName(arg0_1)
	return "IslandVisitorUI"
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
	arg0_5:AddListener(IslandVisitorAgency.PLAYER_ADD, arg0_5.OnFlush)
	arg0_5:AddListener(IslandVisitorAgency.PLAYER_EXIT, arg0_5.OnFlush)
end

function var0_0.RemoveListeners(arg0_6)
	arg0_6:RemoveListener(IslandVisitorAgency.PLAYER_ADD, arg0_6.OnFlush)
	arg0_6:RemoveListener(IslandVisitorAgency.PLAYER_EXIT, arg0_6.OnFlush)
end

function var0_0.Show(arg0_7)
	var0_0.super.Show(arg0_7)
	arg0_7:OnFlush()
end

function var0_0.OnFlush(arg0_8)
	local var0_8 = arg0_8:GetIsland()

	arg0_8:InitList(var0_8)
end

function var0_0.FilterPlayerList(arg0_9, arg1_9)
	local var0_9 = {}
	local var1_9 = arg1_9:GetVisitorAgency():GetPlayerList()

	for iter0_9, iter1_9 in pairs(var1_9) do
		if not iter1_9:IsSelf() then
			table.insert(var0_9, iter1_9)
		end
	end

	return var0_9
end

function var0_0.InitList(arg0_10, arg1_10)
	local var0_10 = arg0_10:FilterPlayerList(arg1_10)

	arg0_10.uiItemList:make(function(arg0_11, arg1_11, arg2_11)
		if arg0_11 == UIItemList.EventUpdate then
			arg0_10:UpdateFriendCard(arg2_11, var0_10[arg1_11 + 1])
		end
	end)
	arg0_10.uiItemList:align(#var0_10)
end

function var0_0.UpdateFriendCard(arg0_12, arg1_12, arg2_12)
	setText(arg1_12:Find("name"), arg2_12:GetName())
	onButton(arg0_12, arg1_12:Find("kick"), function()
		arg0_12:emit(IslandMediator.ON_KICK_PLAYER, IslandConst.ACCESS_OP_KICK, arg2_12.id)
	end, SFX_PANEL)
end

function var0_0.Hide(arg0_14)
	var0_0.super.Hide(arg0_14)
end

function var0_0.OnDestroy(arg0_15)
	return
end

return var0_0
