local var0_0 = class("NieRAutomataMainPage", import("view.activity.CorePage.CoreActivityPage"))

function var0_0.OnFirstFlush(arg0_1)
	arg0_1.super.OnFirstFlush(arg0_1)

	local var0_1 = arg0_1.activity:getConfig("config_client").intro_story

	if not pg.NewStoryMgr.GetInstance():IsPlayed(var0_1) then
		pg.NewStoryMgr.GetInstance():Play(var0_1[1])
	end
end

return var0_0
