local var0 = class("WorldBossAwardPage", import("....base.BaseSubView"))

function var0.getUIName(arg0)
	return "WorldBossAwardUI"
end

function var0.OnLoaded(arg0)
	return
end

function var0.OnInit(arg0)
	local var0 = arg0:findTF("frame/list/container1/tpl")

	arg0.uilist1 = UIItemList.New(arg0:findTF("frame/list/container1"), var0)
	arg0.uilist2 = UIItemList.New(arg0:findTF("frame/list/container2"), var0)

	onButton(arg0, arg0._tf, function()
		arg0:Hide()
	end, SFX_PANEL)
end

function var0.Update(arg0, arg1)
	arg0.worldBoss = arg1

	arg0:UpdateAwards()
	arg0:Show()
end

function var0.UpdateAwards(arg0)
	local var0 = arg0.worldBoss:GetAwards()

	local function var1(arg0, arg1)
		local var0 = var0[arg0 + 1]
		local var1 = {
			count = 0,
			type = var0[1],
			id = var0[2]
		}

		updateDrop(arg1:Find("equipment/bg"), var1)

		local var2 = arg1:Find("mask/name"):GetComponent("ScrollText")
		local var3 = var1:getConfig("name")

		var2:SetText(var3)
		onButton(arg0, arg1, function()
			arg0:emit(BaseUI.ON_DROP, var1)
		end, SFX_PANEL)
	end

	arg0.uilist1:make(function(arg0, arg1, arg2)
		if arg0 == UIItemList.EventUpdate then
			var1(arg1, arg2)
		end
	end)
	arg0.uilist2:make(function(arg0, arg1, arg2)
		if arg0 == UIItemList.EventUpdate then
			var1(arg1 + 4, arg2)
		end
	end)
	arg0.uilist1:align(math.min(#var0, 4))
	arg0.uilist2:align(math.max(0, #var0 - 4))
end

function var0.OnDestroy(arg0)
	return
end

return var0
