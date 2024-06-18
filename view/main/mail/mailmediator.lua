local var0_0 = class("MailMediator", import("view.base.ContextMediator"))

var0_0.ON_REQUIRE = "MailMediator.ON_REQUIRE"
var0_0.ON_OPERATION = "MailMediator.ON_OPERATION"
var0_0.ON_DELETE_COLLECTION = "MailMediator.ON_DELETE_COLLECTION"
var0_0.ON_WITHDRAWAL = "MailMediator.ON_WITHDRAWAL"
var0_0.ON_EXTEND_STORE = "MailMediator.ON_EXTEND_STORE"
var0_0.ON_GET_MAIL_TITLE = "MailMediator.ON_GET_MAIL_TITLE"

function var0_0.register(arg0_1)
	local var0_1 = getProxy(MailProxy)

	arg0_1:bind(var0_0.ON_REQUIRE, function(arg0_2, arg1_2, arg2_2)
		if arg1_2 == "collection" then
			arg0_1:sendNotification(GAME.GET_COLLECTION_MAIL_LIST, {
				callback = arg2_2
			})
		elseif type(arg1_2) == "number" then
			arg0_1:sendNotification(GAME.GET_MAIL_LIST_TO_INDEX, {
				index = arg1_2,
				callback = arg2_2
			})
		else
			arg0_1:sendNotification(GAME.GET_MAIL_LIST, {
				cmd = arg1_2,
				callback = arg2_2
			})
		end
	end)
	arg0_1:bind(var0_0.ON_OPERATION, function(arg0_3, arg1_3)
		arg0_1:sendNotification(GAME.DEAL_MAIL_OPERATION, arg1_3)
	end)
	arg0_1:bind(var0_0.ON_DELETE_COLLECTION, function(arg0_4, arg1_4)
		arg0_1:sendNotification(GAME.DELETE_COLLECTION_MAIL, arg1_4)
	end)
	arg0_1:bind(var0_0.ON_WITHDRAWAL, function(arg0_5, arg1_5)
		arg0_1:sendNotification(GAME.GET_STORE_RES, arg1_5)
	end)
	arg0_1:bind(var0_0.ON_EXTEND_STORE, function(arg0_6, arg1_6)
		arg0_1:sendNotification(GAME.EXTEND_STORE_CAPACITY, {
			isDiamond = arg1_6
		})
	end)
	arg0_1:bind(var0_0.ON_GET_MAIL_TITLE, function(arg0_7, arg1_7, arg2_7)
		arg0_1:sendNotification(GAME.GET_MAIL_TITLE_LIST, {
			mailList = arg1_7,
			callback = arg2_7
		})
	end)
end

function var0_0.initNotificationHandleDic(arg0_8)
	arg0_8.handleDic = {
		[GAME.DEAL_MAIL_OPERATION_DONE] = function(arg0_9, arg1_9)
			local var0_9 = arg1_9:getBody()

			arg0_9.viewComponent:UpdateOperationDeal(var0_9.cmd, var0_9.ids, var0_9.ignoreTips)
			arg0_9:ShowAndCheckDrops(var0_9.items)
		end,
		[GAME.DELETE_COLLECTION_MAIL_DONE] = function(arg0_10, arg1_10)
			local var0_10 = arg1_10:getBody()

			arg0_10.viewComponent:UpdateCollectionDelete(var0_10)
			pg.TipsMgr.GetInstance():ShowTips(i18n("main_mailMediator_mailDelete"))
		end,
		[GAME.GET_STORE_RES_DONE] = function(arg0_11, arg1_11)
			local var0_11 = arg1_11:getBody()

			arg0_11.viewComponent:UpdateStore()
			pg.TipsMgr.GetInstance():ShowTips(i18n("mail_storeroom_taken_1"))
		end,
		[GAME.EXTEND_STORE_CAPACITY_DONE] = function(arg0_12, arg1_12)
			local var0_12 = arg1_12:getBody()

			arg0_12.viewComponent:UpdateStore()
			pg.TipsMgr.GetInstance():ShowTips(i18n("mail_storeroom_extend_1"))
		end,
		[GAME.MAIL_DOUBLE_CONFIREMATION_MSGBOX] = function(arg0_13, arg1_13)
			local var0_13 = arg1_13:getBody()

			arg0_13.viewComponent:ShowDoubleConfiremationMsgBox(var0_13)
		end,
		[PlayerProxy.UPDATED] = function(arg0_14, arg1_14)
			arg0_14.viewComponent:UpdateRes()
		end
	}
	arg0_8.handleElse = nil
end

function var0_0.ShowAndCheckDrops(arg0_15, arg1_15)
	if not arg1_15 then
		return
	end

	local var0_15 = {}

	if #arg1_15 > 0 then
		table.insert(var0_15, function(arg0_16)
			arg0_15.viewComponent:emit(BaseUI.ON_ACHIEVE, arg1_15, arg0_16)
		end)
	end

	local var1_15 = underscore.detect(arg1_15, function(arg0_17)
		return arg0_17.type == DROP_TYPE_ITEM and arg0_17:getConfig("type") == Item.SKIN_ASSIGNED_TYPE and Item.InTimeLimitSkinAssigned(arg0_17.id)
	end)

	if var1_15 then
		table.insert(var0_15, function(arg0_18)
			pg.MsgboxMgr.GetInstance():ShowMsgBox({
				hideNo = true,
				content = i18n("skin_exchange_usetip", var1_15:getName()),
				onYes = arg0_18,
				onNo = arg0_18
			})
		end)
	end

	seriesAsync(var0_15, function()
		local var0_19
		local var1_19 = getProxy(TechnologyProxy)

		if PlayerPrefs.GetInt("help_research_package", 0) == 0 then
			for iter0_19, iter1_19 in ipairs(arg1_15) do
				if iter1_19.type == DROP_TYPE_ITEM then
					var0_19 = checkExist(var1_19:getItemCanUnlockBluePrint(iter1_19.id), {
						1
					})

					if var0_19 then
						break
					end
				end
			end
		end

		if var0_19 then
			PlayerPrefs.SetInt("help_research_package", 1)
			PlayerPrefs.Save()
			pg.MsgboxMgr.GetInstance():ShowMsgBox({
				type = MSGBOX_TYPE_HELP,
				helps = i18n("help_research_package"),
				show_blueprint = var0_19
			})
		end
	end)
end

return var0_0
