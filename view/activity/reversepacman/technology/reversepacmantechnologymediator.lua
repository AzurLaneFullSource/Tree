local var0_0 = class("ReversePacmanTechnologyMediator", import("view.base.ContextMediator"))

var0_0.CMD_GIFT = "ReversePacmanTechnologyMediator::CMD_GIFT"
var0_0.CMD_SELECTED_OPTIONAL = "ReversePacmanTechnologyMediator::CMD_SELECTED_OPTIONAL"
var0_0.BUY_SHOP_ITEM = "ReversePacmanTechnologyMediator::BUY_SHOP_ITEM"

function var0_0.register(arg0_1)
	local var0_1 = ReversePacmanTools.GetActivity().id

	arg0_1:bind(var0_0.CMD_GIFT, function(arg0_2, arg1_2)
		arg0_1:sendNotification(GAME.REVERSE_PACMAN_GIFT_ROLE, {
			activityID = var0_1,
			roleID = arg1_2.roleID,
			itemID = arg1_2.itemID
		})
	end)
	arg0_1:bind(var0_0.CMD_SELECTED_OPTIONAL, function(arg0_3, arg1_3)
		arg0_1:sendNotification(GAME.REVERSE_PACMAN_ADD_FAVORABILITY, {
			activityID = var0_1,
			roleID = arg1_3.roleID
		})
	end)
	arg0_1:bind(var0_0.BUY_SHOP_ITEM, function(arg0_4, arg1_4)
		arg0_1:sendNotification(GAME.ACTIVITY_OPERATION, {
			cmd = 1,
			arg2 = 1,
			activity_id = arg1_4.activityID,
			arg1 = arg1_4.shopID
		})
	end)
end

function var0_0.initNotificationHandleDic(arg0_5)
	arg0_5.handleDic = {
		[GAME.REVERSE_PACMAN_GIFT_ROLE_DONE] = function(arg0_6, arg1_6)
			local var0_6 = ReversePacmanTools.GetActivity()

			if var0_6:GetGiftTip() then
				var0_6:SetGiftTip()
			end

			arg0_6.viewComponent:RefreshTips()
			arg0_6:sendNotification(GAME.REVERSE_PACMAN_REFRESH_TIP)
			arg0_6.viewComponent:emit(ReversePacmanTechnologyHrView.GIFT_SUCCESS, arg1_6:getBody())
		end,
		[STORY_EVENT.OPTION_SELECTED] = function(arg0_7, arg1_7)
			arg0_7.viewComponent:emit(ReversePacmanTechnologyHrView.STORY_SELECTED_OPTIONAL, arg1_7:getBody())
		end,
		[GAME.REVERSE_PACMAN_ADD_FAVORABILITY_DONE] = function(arg0_8, arg1_8)
			arg0_8.viewComponent:emit(ReversePacmanTechnologyHrView.STORY_ADD_FAVORABILITY, arg1_8:getBody())
		end,
		[ShopsProxy.ACTIVITY_SHOP_GOODS_UPDATED] = function(arg0_9, arg1_9)
			local var0_9 = arg1_9:getBody().goodsId
			local var1_9 = ReversePacmanTools.GetActivity()

			if table.keyof(var1_9:getConfig("config_client").technologyShopIDList, var0_9) then
				if var1_9:GetRoleSkillTip() then
					var1_9:SetRoleSkillTip()
				end
			elseif var1_9:GetPlayerSkillTip() then
				var1_9:SetPlayerSkillTip()
			end

			arg0_9.viewComponent:emit(ReversePacmanTechnologyRoleSkillView.BUY_SHOP_ITEM_SUCCESS, var0_9)
		end,
		[ActivityProxy.ACTIVITY_SHOP_SHOW_AWARDS] = function(arg0_10, arg1_10)
			local var0_10 = arg1_10:getBody()

			arg0_10.viewComponent:emit(BaseUI.ON_ACHIEVE, var0_10.awards, var0_10.callback)
		end,
		[PlayerProxy.UPDATED] = function(arg0_11, arg1_11)
			arg0_11.viewComponent:RefreshTips()
			arg0_11:sendNotification(GAME.REVERSE_PACMAN_REFRESH_TIP)
			arg0_11.viewComponent:emit(ReversePacmanTechnologyRoleSkillView.REFRESH_ITEM_CNT)
		end
	}
end

function var0_0.remove(arg0_12)
	return
end

return var0_0
