local var0_0 = class("ArchivesWorldbossBtn")

function var0_0.Ctor(arg0_1, arg1_1, arg2_1)
	pg.DelegateInfo.New(arg0_1)

	arg0_1._tf = arg1_1
	arg0_1.img = arg0_1._tf:GetComponent(typeof(Image))
	arg0_1.event = arg2_1
	arg0_1.iconText = arg0_1._tf:Find("Text"):GetComponent(typeof(Text))
	arg0_1.tip = arg0_1._tf:Find("tip")

	onButton(arg0_1, arg0_1._tf, function()
		arg0_1.event:emit(WorldBossScene.ON_SWITCH, WorldBossScene.PAGE_ARCHIVES_LIST)
	end, SFX_PANEL)
end

function var0_0.Flush(arg0_3)
	if WorldBossConst.GetAchieveState() == WorldBossConst.ACHIEVE_STATE_STARTING then
		local var0_3 = WorldBossConst.GetArchivesId()
		local var1_3 = WorldBossConst.BossId2MetaId(var0_3)
		local var2_3 = getProxy(MetaCharacterProxy):getMetaProgressVOByID(var1_3)
		local var3_3 = var2_3.metaPtData:GetResProgress()

		arg0_3.iconText.text = var3_3 .. "/" .. var2_3.metaPtData:GetTotalResRequire()
		arg0_3.img.sprite = GetSpriteFromAtlas("MetaWorldboss/" .. var1_3, "btn")
	else
		arg0_3.iconText.text = ""
		arg0_3.img.sprite = LoadSprite("MetaWorldboss/extra_btn")
	end

	setActive(arg0_3.tip, WorldBossConst.AnyArchivesBossCanGetAward())
end

function var0_0.Dispose(arg0_4)
	pg.DelegateInfo.Dispose(arg0_4)
end

return var0_0
