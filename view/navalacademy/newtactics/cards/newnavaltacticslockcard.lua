local var0_0 = class("NewNavalTacticsLockCard", import(".NewNavalTacticsBaseCard"))

function var0_0.UnlockCnt2ShopId(arg0_1, arg1_1)
	return ({
		21,
		22
	})[arg1_1 - 1]
end

function var0_0.OnInit(arg0_2)
	onButton(arg0_2, arg0_2._tf, function()
		local var0_3 = getProxy(NavalAcademyProxy):getSkillClassNum()
		local var1_3 = arg0_2:UnlockCnt2ShopId(var0_3)

		arg0_2:emit(NewNavalTacticsLayer.ON_UNLOCK, var1_3)
	end, SFX_PANEL)
end

return var0_0
