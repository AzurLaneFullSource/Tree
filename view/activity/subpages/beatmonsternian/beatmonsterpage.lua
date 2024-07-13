local var0_0 = class("BeatMonsterPage", import("....base.BaseActivityPage"))

function var0_0.OnInit(arg0_1)
	arg0_1.bg = arg0_1:findTF("AD")
end

function var0_0.OnFirstFlush(arg0_2)
	return
end

function var0_0.OnUpdateFlush(arg0_3)
	arg0_3:Show()

	local var0_3 = arg0_3.activity
	local var1_3 = arg0_3:PacketData(var0_3)

	if not arg0_3.controller then
		arg0_3.controller = BeatMonsterController.New()

		arg0_3.controller.mediator:SetUI(arg0_3._go)
		arg0_3.controller:SetUp(var1_3, function(arg0_4)
			arg0_3:emit(ActivityMainScene.LOCK_ACT_MAIN, arg0_4)
		end)
	else
		arg0_3.controller:NetData(var1_3)
	end
end

function var0_0.PacketData(arg0_5, arg1_5)
	local var0_5 = arg1_5:GetDataConfig("hp")
	local var1_5 = var0_5 - arg1_5.data3
	local var2_5 = arg1_5:GetCountForHitMonster()
	local var3_5 = arg1_5:GetDataConfig("story")

	return {
		hp = math.max(var1_5, 0),
		maxHp = var0_5,
		leftCount = var2_5,
		storys = var3_5
	}
end

function var0_0.OnDestroy(arg0_6)
	arg0_6.controller:Dispose()
end

return var0_0
