local var0 = class("MailMediator", import("view.base.ContextMediator"))

var0.ON_REQUIRE = "MailMediator.ON_REQUIRE"
var0.ON_OPERATION = "MailMediator.ON_OPERATION"
var0.ON_DELETE_COLLECTION = "MailMediator.ON_DELETE_COLLECTION"
var0.ON_WITHDRAWAL = "MailMediator.ON_WITHDRAWAL"
var0.ON_EXTEND_STORE = "MailMediator.ON_EXTEND_STORE"
var0.ON_GET_MAIL_TITLE = "MailMediator.ON_GET_MAIL_TITLE"

function var0.register(arg0)
	local var0 = getProxy(MailProxy)

	arg0:bind(var0.ON_REQUIRE, function(arg0, arg1, arg2)
		if arg1 == "collection" then
			arg0:sendNotification(GAME.GET_COLLECTION_MAIL_LIST, {
				callback = arg2
			})
		elseif type(arg1) == "number" then
			arg0:sendNotification(GAME.GET_MAIL_LIST_TO_INDEX, {
				index = arg1,
				callback = arg2
			})
		else
			arg0:sendNotification(GAME.GET_MAIL_LIST, {
				cmd = arg1,
				callback = arg2
			})
		end
	end)
	arg0:bind(var0.ON_OPERATION, function(arg0, arg1)
		arg0:sendNotification(GAME.DEAL_MAIL_OPERATION, arg1)
	end)
	arg0:bind(var0.ON_DELETE_COLLECTION, function(arg0, arg1)
		arg0:sendNotification(GAME.DELETE_COLLECTION_MAIL, arg1)
	end)
	arg0:bind(var0.ON_WITHDRAWAL, function(arg0, arg1)
		arg0:sendNotification(GAME.GET_STORE_RES, arg1)
	end)
	arg0:bind(var0.ON_EXTEND_STORE, function(arg0, arg1)
		arg0:sendNotification(GAME.EXTEND_STORE_CAPACITY, {
			isDiamond = arg1
		})
	end)
	arg0:bind(var0.ON_GET_MAIL_TITLE, function(arg0, arg1, arg2)
		arg0:sendNotification(GAME.GET_MAIL_TITLE_LIST, {
			mailList = arg1,
			callback = arg2
		})
	end)
end

function var0.initNotificationHandleDic(arg0)
	arg0.handleDic = {
		[GAME.DEAL_MAIL_OPERATION_DONE] = function(arg0, arg1)
			local var0 = arg1:getBody()

			arg0.viewComponent:UpdateOperationDeal(var0.cmd, var0.ids, var0.ignoreTips)
			arg0:ShowAndCheckDrops(var0.items)
		end,
		[GAME.DELETE_COLLECTION_MAIL_DONE] = function(arg0, arg1)
			local var0 = arg1:getBody()

			arg0.viewComponent:UpdateCollectionDelete(var0)
			pg.TipsMgr.GetInstance():ShowTips(i18n("main_mailMediator_mailDelete"))
		end,
		[GAME.GET_STORE_RES_DONE] = function(arg0, arg1)
			local var0 = arg1:getBody()

			arg0.viewComponent:UpdateStore()
			pg.TipsMgr.GetInstance():ShowTips(i18n("mail_storeroom_taken_1"))
		end,
		[GAME.EXTEND_STORE_CAPACITY_DONE] = function(arg0, arg1)
			local var0 = arg1:getBody()

			arg0.viewComponent:UpdateStore()
			pg.TipsMgr.GetInstance():ShowTips(i18n("mail_storeroom_extend_1"))
		end,
		[GAME.MAIL_DOUBLE_CONFIREMATION_MSGBOX] = function(arg0, arg1)
			local var0 = arg1:getBody()

			arg0.viewComponent:ShowDoubleConfiremationMsgBox(var0)
		end,
		[PlayerProxy.UPDATED] = function(arg0, arg1)
			arg0.viewComponent:UpdateRes()
		end
	}
	arg0.handleElse = nil
end

function var0.ShowAndCheckDrops(arg0, arg1)
	if not arg1 then
		return
	end

	local var0 = {}

	if #arg1 > 0 then
		table.insert(var0, function(arg0)
			arg0.viewComponent:emit(BaseUI.ON_ACHIEVE, arg1, arg0)
		end)
	end

	local var1 = underscore.detect(arg1, function(arg0)
		return arg0.type == DROP_TYPE_ITEM and arg0:getConfig("type") == Item.SKIN_ASSIGNED_TYPE and Item.InTimeLimitSkinAssigned(arg0.id)
	end)

	if var1 then
		table.insert(var0, function(arg0)
			pg.MsgboxMgr.GetInstance():ShowMsgBox({
				hideNo = true,
				content = i18n("skin_exchange_usetip", var1:getName()),
				onYes = arg0,
				onNo = arg0
			})
		end)
	end

	seriesAsync(var0, function()
		local var0
		local var1 = getProxy(TechnologyProxy)

		if PlayerPrefs.GetInt("help_research_package", 0) == 0 then
			for iter0, iter1 in ipairs(arg1) do
				if iter1.type == DROP_TYPE_ITEM then
					var0 = checkExist(var1:getItemCanUnlockBluePrint(iter1.id), {
						1
					})

					if var0 then
						break
					end
				end
			end
		end

		if var0 then
			PlayerPrefs.SetInt("help_research_package", 1)
			PlayerPrefs.Save()
			pg.MsgboxMgr.GetInstance():ShowMsgBox({
				type = MSGBOX_TYPE_HELP,
				helps = i18n("help_research_package"),
				show_blueprint = var0
			})
		end
	end)
end

return var0
