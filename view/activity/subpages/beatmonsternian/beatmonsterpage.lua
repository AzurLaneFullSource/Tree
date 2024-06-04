local var0 = class("BeatMonsterPage", import("....base.BaseActivityPage"))

function var0.OnInit(arg0)
	arg0.bg = arg0:findTF("AD")
end

function var0.OnFirstFlush(arg0)
	return
end

function var0.OnUpdateFlush(arg0)
	arg0:Show()

	local var0 = arg0.activity
	local var1 = arg0:PacketData(var0)

	if not arg0.controller then
		arg0.controller = BeatMonsterController.New()

		arg0.controller.mediator:SetUI(arg0._go)
		arg0.controller:SetUp(var1, function(arg0)
			arg0:emit(ActivityMainScene.LOCK_ACT_MAIN, arg0)
		end)
	else
		arg0.controller:NetData(var1)
	end
end

function var0.PacketData(arg0, arg1)
	local var0 = arg1:GetDataConfig("hp")
	local var1 = var0 - arg1.data3
	local var2 = arg1:GetCountForHitMonster()
	local var3 = arg1:GetDataConfig("story")

	return {
		hp = math.max(var1, 0),
		maxHp = var0,
		leftCount = var2,
		storys = var3
	}
end

function var0.OnDestroy(arg0)
	arg0.controller:Dispose()
end

return var0
