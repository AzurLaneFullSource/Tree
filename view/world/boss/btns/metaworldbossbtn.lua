local var0_0 = class("MetaWorldbossBtn")

function var0_0.Ctor(arg0_1, arg1_1, arg2_1)
	pg.DelegateInfo.New(arg0_1)

	arg0_1.event = arg2_1
	arg0_1.metaBtn = arg1_1
	arg0_1.metaProgress = arg1_1:Find("Text"):GetComponent(typeof(Text))
	arg0_1.metaTip = arg1_1:Find("tip")

	arg0_1:Init()
end

function var0_0.Init(arg0_2)
	onButton(arg0_2, arg0_2.metaBtn, function()
		local var0_3 = WorldBossConst.GetCurrBossGroup()

		arg0_2.event:emit(WorldBossMediator.GO_META, var0_3)
	end, SFX_PANEL)
	arg0_2:Update()
end

function var0_0.Update(arg0_4)
	local var0_4 = WorldBossConst.GetCurrBossGroup()

	setActive(arg0_4.metaTip, MetaCharacterConst.isMetaSynRedTag(var0_4))
end

function var0_0.Dispose(arg0_5)
	pg.DelegateInfo.Dispose(arg0_5)
end

return var0_0
