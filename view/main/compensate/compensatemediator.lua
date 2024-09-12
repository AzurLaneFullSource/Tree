local var0_0 = class("CompensateMediator", import("view.base.ContextMediator"))

var0_0.ON_GET_REWARD = "CompensateMediator.ON_GET_REWARD"

function var0_0.register(arg0_1)
	local var0_1 = getProxy(CompensateProxy)

	arg0_1:bind(var0_0.ON_GET_REWARD, function(arg0_2, arg1_2)
		arg0_1:sendNotification(GAME.GET_COMPENSATE_REWARD, arg1_2)
	end)
end

function var0_0.initNotificationHandleDic(arg0_3)
	arg0_3.handleDic = {
		[GAME.DEAL_COMPENSATE_REWARD_DONE] = function(arg0_4, arg1_4)
			local var0_4 = arg1_4:getBody()

			arg0_4.viewComponent:UpdateOperationDeal()
			arg0_4:ShowAndCheckDrops(var0_4.items)
		end,
		[PlayerProxy.UPDATED] = function(arg0_5, arg1_5)
			arg0_5.viewComponent:UpdateRes()
		end,
		[CompensateProxy.Compensate_Remove] = function(arg0_6, arg1_6)
			arg0_6.viewComponent:UpdateOperationDeal()
		end
	}
end

function var0_0.ShowAndCheckDrops(arg0_7, arg1_7)
	if not arg1_7 then
		return
	end

	local var0_7 = {}

	if #arg1_7 > 0 then
		table.insert(var0_7, function(arg0_8)
			arg0_7.viewComponent:emit(BaseUI.ON_ACHIEVE, arg1_7, arg0_8)
		end)
	end

	local var1_7 = underscore.detect(arg1_7, function(arg0_9)
		return arg0_9.type == DROP_TYPE_ITEM and arg0_9:getConfig("type") == Item.SKIN_ASSIGNED_TYPE and Item.InTimeLimitSkinAssigned(arg0_9.id)
	end)

	if var1_7 then
		table.insert(var0_7, function(arg0_10)
			pg.MsgboxMgr.GetInstance():ShowMsgBox({
				hideNo = true,
				content = i18n("skin_exchange_usetip", var1_7:getName()),
				onYes = arg0_10,
				onNo = arg0_10
			})
		end)
	end

	seriesAsync(var0_7, function()
		local var0_11
		local var1_11 = getProxy(TechnologyProxy)

		if PlayerPrefs.GetInt("help_research_package", 0) == 0 then
			for iter0_11, iter1_11 in ipairs(arg1_7) do
				if iter1_11.type == DROP_TYPE_ITEM then
					var0_11 = checkExist(var1_11:getItemCanUnlockBluePrint(iter1_11.id), {
						1
					})

					if var0_11 then
						break
					end
				end
			end
		end

		if var0_11 then
			PlayerPrefs.SetInt("help_research_package", 1)
			PlayerPrefs.Save()
			pg.MsgboxMgr.GetInstance():ShowMsgBox({
				type = MSGBOX_TYPE_HELP,
				helps = i18n("help_research_package"),
				show_blueprint = var0_11
			})
		end
	end)
end

return var0_0
