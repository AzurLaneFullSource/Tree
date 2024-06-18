local var0_0 = class("WorldBossAwardPage", import("....base.BaseSubView"))

function var0_0.getUIName(arg0_1)
	return "WorldBossAwardUI"
end

function var0_0.OnLoaded(arg0_2)
	return
end

function var0_0.OnInit(arg0_3)
	local var0_3 = arg0_3:findTF("frame/list/container1/tpl")

	arg0_3.uilist1 = UIItemList.New(arg0_3:findTF("frame/list/container1"), var0_3)
	arg0_3.uilist2 = UIItemList.New(arg0_3:findTF("frame/list/container2"), var0_3)

	onButton(arg0_3, arg0_3._tf, function()
		arg0_3:Hide()
	end, SFX_PANEL)
end

function var0_0.Update(arg0_5, arg1_5)
	arg0_5.worldBoss = arg1_5

	arg0_5:UpdateAwards()
	arg0_5:Show()
end

function var0_0.UpdateAwards(arg0_6)
	local var0_6 = arg0_6.worldBoss:GetAwards()

	local function var1_6(arg0_7, arg1_7)
		local var0_7 = var0_6[arg0_7 + 1]
		local var1_7 = {
			count = 0,
			type = var0_7[1],
			id = var0_7[2]
		}

		updateDrop(arg1_7:Find("equipment/bg"), var1_7)

		local var2_7 = arg1_7:Find("mask/name"):GetComponent("ScrollText")
		local var3_7 = var1_7:getConfig("name")

		var2_7:SetText(var3_7)
		onButton(arg0_6, arg1_7, function()
			arg0_6:emit(BaseUI.ON_DROP, var1_7)
		end, SFX_PANEL)
	end

	arg0_6.uilist1:make(function(arg0_9, arg1_9, arg2_9)
		if arg0_9 == UIItemList.EventUpdate then
			var1_6(arg1_9, arg2_9)
		end
	end)
	arg0_6.uilist2:make(function(arg0_10, arg1_10, arg2_10)
		if arg0_10 == UIItemList.EventUpdate then
			var1_6(arg1_10 + 4, arg2_10)
		end
	end)
	arg0_6.uilist1:align(math.min(#var0_6, 4))
	arg0_6.uilist2:align(math.max(0, #var0_6 - 4))
end

function var0_0.OnDestroy(arg0_11)
	return
end

return var0_0
