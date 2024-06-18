local var0_0 = class("MainGuildBtn", import(".MainBaseBtn"))

function var0_0.Ctor(arg0_1, arg1_1, arg2_1)
	var0_0.super.Ctor(arg0_1, arg1_1, arg2_1)

	arg0_1.guildLock = arg1_1:Find("lock")
	arg0_1.guildImage = arg1_1:GetComponent(typeof(Image))
end

function var0_0.OnClick(arg0_2)
	if getProxy(GuildProxy):getRawData() then
		arg0_2:emit(NewMainMediator.GO_SCENE, SCENE.GUILD)
	else
		arg0_2:emit(NewMainMediator.GO_SCENE, SCENE.NEWGUILD)
	end
end

function var0_0.Flush(arg0_3, arg1_3)
	local var0_3 = getProxy(PlayerProxy):getRawData()
	local var1_3 = pg.SystemOpenMgr.GetInstance():isOpenSystem(var0_3.level, "NewGuildMediator")

	if not arg0_3.isOpenGuild or arg0_3.isOpenGuild ~= var1_3 then
		setActive(arg0_3.guildLock, not var1_3)

		local var2_3 = var1_3 and Color(1, 1, 1, 1) or Color(0.3, 0.3, 0.3, 1)

		arg0_3.guildImage.color = var2_3
		arg0_3.isOpenGuild = var1_3
	end
end

return var0_0
