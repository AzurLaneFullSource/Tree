local var0_0 = class("ActivityDrawAwardCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody()
	local var1_1 = getProxy(ActivityProxy):getActivityById(var0_1.activity_id)

	if not var1_1 or var1_1:isEnd() then
		return
	end

	local var2_1 = switch(var0_1.op, {
		set_list = function()
			if not var1_1:CheckList(var0_1.list) then
				return nil
			end

			return {
				arg1 = 0,
				arg2 = 0,
				cmd = 1,
				activity_id = var0_1.activity_id,
				arg_list = underscore.to_array(var0_1.list)
			}
		end,
		do_draw = function()
			if var0_1.count > var1_1:GetDrawTimes() then
				return nil
			end

			return {
				cmd = 2,
				arg2 = 0,
				activity_id = var0_1.activity_id,
				arg1 = var0_1.count,
				arg_list = {}
			}
		end,
		count_award = function()
			if not var1_1:CanCountAward(var0_1.target_id) then
				return nil
			end

			return {
				cmd = 3,
				arg2 = 0,
				activity_id = var0_1.activity_id,
				arg1 = var0_1.target_id,
				arg_list = {}
			}
		end
	}, function()
		assert(false, "error draw award activity cmd:" .. var0_1.op)
	end)

	if not var2_1 then
		return
	end

	pg.ConnectionMgr.GetInstance():Send(11202, var2_1, 11203, function(arg0_6)
		if arg0_6.result == 0 then
			local var0_6 = IslandDropHelper.AddItems({
				drop_list = arg0_6.award_list
			})
			local var1_6 = getProxy(ActivityProxy):getActivityById(var0_1.activity_id)
			local var2_6 = {}

			switch(var0_1.op, {
				set_list = function()
					var1_6:SetList(var0_1.list)
				end,
				do_draw = function()
					var2_6 = underscore.to_array(arg0_6.number)

					var1_6:ResultDraw(var2_6)
				end,
				count_award = function()
					var2_6 = {
						var0_1.target_id
					}

					var1_6:CountAward(var0_1.target_id)
				end
			}, function()
				assert(false, "error draw award activity cmd:" .. var0_1.op)
			end)
			getProxy(ActivityProxy):updateActivity(var1_6)
			arg0_1:sendNotification(GAME.ACTIVITY_DRAW_AWARD_OPERATION_DONE, {
				op = var0_1.op,
				dropData = var0_6,
				awards = var2_6
			})
		else
			pg.TipsMgr.GetInstance():ShowTips(ERROR_MESSAGE[arg0_6.result] .. arg0_6.result)
		end
	end)
end

return var0_0
