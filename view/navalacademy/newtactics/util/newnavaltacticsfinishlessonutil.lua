local var0_0 = class("NewNavalTacticsFinishLessonUtil")

function var0_0.Ctor(arg0_1, arg1_1, arg2_1, arg3_1)
	arg0_1.studentsPage = arg1_1
	arg0_1.selLessonPage = arg2_1
	arg0_1.selSkillPage = arg3_1
	arg0_1.queue = {}
end

function var0_0.Enter(arg0_2, arg1_2, arg2_2)
	if _.any(arg0_2.queue, function(arg0_3)
		return arg0_3[1] == arg1_2
	end) then
		return
	end

	table.insert(arg0_2.queue, {
		arg1_2,
		arg2_2
	})

	if #arg0_2.queue == 1 then
		arg0_2:Excute()
	end
end

function var0_0.Excute(arg0_4)
	local var0_4 = arg0_4.queue[1]

	if var0_4[2] == Student.CANCEL_TYPE_QUICKLY then
		pg.m02:sendNotification(GAME.QUICK_FINISH_LEARN_TACTICS, {
			shipId = var0_4[1]
		})
	else
		pg.m02:sendNotification(GAME.CANCEL_LEARN_TACTICS, {
			shipId = var0_4[1],
			type = var0_4[2]
		})
	end
end

function var0_0.NextOne(arg0_5)
	table.remove(arg0_5.queue, 1)
	pg.m02:sendNotification(NewNavalTacticsMediator.ON_FINISH_ONE_ANIM)

	if #arg0_5.queue > 0 then
		arg0_5:Excute()
	end
end

function var0_0.IsWorking(arg0_6)
	return #arg0_6.queue > 0
end

function var0_0.WaitForFinish(arg0_7, arg1_7, arg2_7, arg3_7, arg4_7, arg5_7)
	local function var0_7()
		arg0_7:DisplayResult(arg1_7, arg3_7, arg2_7, arg4_7, arg5_7)
	end

	local var1_7 = arg0_7.studentsPage:GetCard(arg1_7)

	var1_7:RemoveTimer()
	arg0_7:DoAnimtion(var1_7, arg3_7, arg4_7, arg5_7, var0_7)
end

function var0_0.DisplayResult(arg0_9, arg1_9, arg2_9, arg3_9, arg4_9, arg5_9)
	local var0_9 = ""
	local var1_9 = getProxy(BayProxy):RawGetShipById(arg3_9)
	local var2_9 = var1_9:getName()
	local var3_9 = arg4_9:GetName()

	if arg5_9.level > arg4_9.level then
		var0_9 = i18n("tactics_end_to_learn", var2_9, var3_9, arg2_9) .. i18n("tactics_skill_level_up", arg4_9.level, arg5_9.level)
	else
		var0_9 = i18n("tactics_end_to_learn", var2_9, var3_9, arg2_9)
	end

	if arg5_9:IsMaxLevel() then
		arg0_9:HandleMaxLevel(arg1_9, var1_9, var0_9, var2_9, var3_9, arg2_9)
	else
		arg0_9:WhetherToContinue(var0_9, arg1_9, var1_9, arg4_9.id)
	end
end

function var0_0.HandleMaxLevel(arg0_10, arg1_10, arg2_10, arg3_10, arg4_10, arg5_10, arg6_10)
	local var0_10 = arg2_10:getSkillList()

	if _.all(var0_10, function(arg0_11)
		return ShipSkill.New(arg2_10.skills[arg0_11]):IsMaxLevel()
	end) then
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			modal = true,
			hideNo = true,
			hideClose = true,
			content = arg3_10,
			onYes = function()
				arg0_10:NextOne()
			end
		})
	else
		arg0_10:WhetherToContinueForOtherSkill(arg1_10, arg2_10, arg4_10, arg5_10, arg6_10)
	end
end

function var0_0.WhetherToContinueForOtherSkill(arg0_13, arg1_13, arg2_13, arg3_13, arg4_13, arg5_13)
	local var0_13 = i18n("tactics_end_to_learn", arg3_13, arg4_13, arg5_13) .. i18n("tactics_continue_to_learn_other_skill")

	pg.MsgboxMgr.GetInstance():ShowMsgBox({
		modal = true,
		hideClose = true,
		content = var0_13,
		onYes = function()
			if arg0_13:ExistBook() then
				arg0_13:ContinuousLearningForOtherSkill(arg1_13, arg2_13)
			else
				pg.TipsMgr.GetInstance():ShowTips(i18n("tactics_no_lesson"))
				arg0_13:NextOne()
			end
		end,
		onNo = function()
			arg0_13:NextOne()
		end
	})
end

function var0_0.ContinuousLearningForOtherSkill(arg0_16, arg1_16, arg2_16)
	local var0_16 = Student.New({
		id = arg1_16,
		ship_id = arg2_16.id
	})

	arg0_16.selSkillPage:SetCancelCallback(function()
		arg0_16:NextOne()
	end)
	arg0_16.selLessonPage:SetHideCallback(function()
		arg0_16:NextOne()
	end)
	arg0_16.selSkillPage:ExecuteAction("Show", var0_16)
end

function var0_0.WhetherToContinue(arg0_19, arg1_19, arg2_19, arg3_19, arg4_19)
	arg1_19 = arg1_19 .. i18n("tactics_continue_to_learn")

	pg.MsgboxMgr.GetInstance():ShowMsgBox({
		modal = true,
		hideClose = true,
		content = arg1_19,
		onYes = function()
			if arg0_19:ExistBook() then
				arg0_19:ContinuousLearning(arg2_19, arg3_19, arg4_19)
			else
				pg.TipsMgr.GetInstance():ShowTips(i18n("tactics_no_lesson"))
				arg0_19:NextOne()
			end
		end,
		onNo = function()
			arg0_19:NextOne()
		end
	})
end

function var0_0.ExistBook(arg0_22)
	return #getProxy(BagProxy):getItemsByType(Item.LESSON_TYPE) > 0
end

function var0_0.ContinuousLearning(arg0_23, arg1_23, arg2_23, arg3_23)
	local var0_23 = Student.New({
		id = arg1_23,
		ship_id = arg2_23.id
	})
	local var1_23 = arg2_23:getSkillList()
	local var2_23 = table.indexof(var1_23, arg3_23)

	assert(var2_23 and var2_23 > 0)
	var0_23:setSkillIndex(var2_23)
	arg0_23.selLessonPage:SetHideCallback(function()
		arg0_23:NextOne()
	end)
	arg0_23.selLessonPage:ExecuteAction("Show", var0_23, false)
end

function var0_0.DoAnimtion(arg0_25, arg1_25, arg2_25, arg3_25, arg4_25, arg5_25)
	if not arg1_25 then
		arg5_25()
	else
		arg1_25:DoAddExpAnim(arg3_25, arg4_25, arg5_25)
	end
end

function var0_0.Dispose(arg0_26)
	arg0_26.studentsPage = nil
	arg0_26.selLessonPage = nil
	arg0_26.selSkillPage = nil
	arg0_26.queue = {}
end

return var0_0
