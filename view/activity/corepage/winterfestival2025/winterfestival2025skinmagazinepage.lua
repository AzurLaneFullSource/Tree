local var0_0 = class("WinterFestival2025SkinMagazinePage", import("view.activity.CorePage.CorSkinMagazineTemplatePage"))

var0_0.EXPAND_WIDTH = 761
var0_0.CLOSE_WIDTH = 164
var0_0.DURATION_PARAMETER = 2500

function var0_0.OnFirstFlush(arg0_1)
	var0_0.super.OnFirstFlush(arg0_1)

	for iter0_1, iter1_1 in ipairs(arg0_1.taskList) do
		local var0_1 = arg0_1.items:GetChild(iter0_1 - 1):Find("got")
		local var1_1 = arg0_1.items:GetChild(iter0_1 - 1):Find("got_short")

		setActive(var0_1, false)
		setActive(var1_1, false)
	end

	local var2_1 = arg0_1.activity:getConfig("config_client").story

	for iter2_1, iter3_1 in ipairs(arg0_1.taskList) do
		local var3_1 = arg0_1.taskProxy:getFinishTaskById(iter3_1)

		if var3_1 and var3_1:getTaskStatus() == 2 and checkExist(var2_1, {
			iter2_1
		}, {
			1
		}) then
			local var4_1 = var2_1[iter2_1][1]
			local var5_1, var6_1 = pg.NewStoryMgr.GetInstance():StoryName2StoryId(var4_1)

			pg.m02:sendNotification(GAME.STORY_UPDATE, {
				storyId = var4_1
			})
		end
	end
end

function var0_0.OnUpdateFlush(arg0_2)
	local var0_2 = 0
	local var1_2 = {}

	for iter0_2, iter1_2 in ipairs(arg0_2.taskList) do
		var1_2[iter1_2] = tobool(arg0_2.taskProxy:getFinishTaskById(iter1_2))

		if var1_2[iter1_2] then
			var0_2 = var0_2 + 1
		end

		local var2_2 = arg0_2.items:GetChild(iter0_2 - 1):Find("got")
		local var3_2 = arg0_2.items:GetChild(iter0_2 - 1):Find("got_short")
		local var4_2 = var2_2:GetComponent(typeof(DftAniEvent))
		local var5_2 = var3_2:GetComponent(typeof(DftAniEvent))

		local function var6_2()
			local var0_3 = arg0_2.activity:getConfig("config_client").story

			for iter0_3, iter1_3 in ipairs(arg0_2.taskList) do
				if arg0_2.taskProxy:getFinishTaskById(iter1_3) and checkExist(var0_3, {
					iter0_3
				}, {
					1
				}) then
					local var1_3 = var0_3[iter0_3][1]

					playStory(var1_3)
				end
			end
		end

		var4_2:SetEndEvent(var6_2)
		var5_2:SetEndEvent(var6_2)

		if arg0_2.index == iter0_2 then
			setActive(var2_2, var1_2[iter1_2])
			setActive(var3_2, false)
		else
			setActive(var2_2, false)
			setActive(var3_2, var1_2[iter1_2])
		end
	end

	if arg0_2.usedCnt ~= var0_2 then
		arg0_2.usedCnt = var0_2

		local var7_2 = arg0_2.activity

		var7_2.data1 = arg0_2.usedCnt

		getProxy(ActivityProxy):updateActivity(var7_2)
	end

	arg0_2:RefreshData()
	setText(arg0_2.countTf, arg0_2.remainCnt)

	local var8_2 = var1_2[arg0_2.taskList[arg0_2.index]]

	setActive(arg0_2.awardTf:Find("got"), var8_2)
	setActive(arg0_2.awardTf:Find("get"), arg0_2.remainCnt > 0 and not var8_2)
end

return var0_0
