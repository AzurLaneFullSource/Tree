local var0_0 = class("SubPageStep", import(".StoryStep"))
local var1_0 = "MonopolyCar2026SetNamePage"

function var0_0.Ctor(arg0_1, arg1_1)
	var0_0.super.Ctor(arg0_1, arg1_1)

	arg0_1.page = arg1_1.name

	if arg1_1.type == 1 then
		arg0_1.page = var1_0
	end
end

function var0_0.GetMode(arg0_2)
	return Story.MODE_SUBPAGE
end

function var0_0.GetSubPageCls(arg0_3)
	return _G[arg0_3.page]
end

function var0_0.ShouldShowSubPage(arg0_4)
	if arg0_4.page == var1_0 then
		local var0_4 = getProxy(ActivityProxy)
		local var1_4 = var0_4:getActivityByType(ActivityConst.ACTIVITY_TYPE_MONOPOLY)

		if not var1_4 or var1_4:isEnd() then
			return false
		end

		local var2_4 = var1_4:getConfig("config_client").link_act
		local var3_4 = var0_4:RawGetActivityById(var2_4)
		local var4_4 = pg.NewStoryMgr.GetInstance():IsReView()

		return var3_4 and not var3_4:isEnd() and not var4_4
	else
		return true
	end
end

return var0_0
