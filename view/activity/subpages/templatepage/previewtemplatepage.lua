local var0 = class("PreviewTemplatePage", import("view.base.BaseActivityPage"))

function var0.OnInit(arg0)
	arg0.bg = arg0:findTF("AD")
	arg0.btnList = arg0:findTF("btn_list", arg0.bg)
end

function var0.OnFirstFlush(arg0)
	arg0:initBtn()
	eachChild(arg0.btnList, function(arg0)
		arg0.btnFuncList[arg0.name](arg0)
	end)
end

function var0.initBtn(arg0)
	local function var0(arg0)
		local var0 = getProxy(ActivityProxy):getActivityById(arg0)

		if not var0 or var0 and var0:isEnd() then
			return true
		else
			return false
		end
	end

	local var1 = arg0.activity:getConfig("config_client")

	arg0.btnFuncList = {
		task = function(arg0)
			onButton(arg0, arg0, function()
				if var1.taskLinkActID and var0(var1.taskLinkActID) then
					pg.TipsMgr.GetInstance():ShowTips(i18n("common_activity_end"))

					return
				end

				arg0:emit(ActivityMediator.EVENT_GO_SCENE, SCENE.TASK, {
					page = "activity"
				})
			end)
		end,
		academy = function(arg0)
			onButton(arg0, arg0, function()
				arg0:emit(ActivityMediator.EVENT_GO_SCENE, SCENE.NAVALACADEMYSCENE, {
					page = "activity"
				})
			end)
		end,
		shop = function(arg0)
			local var0 = _.detect(getProxy(ActivityProxy):getActivitiesByType(ActivityConst.ACTIVITY_TYPE_SHOP), function(arg0)
				return arg0:getConfig("config_client").pt_id == pg.gameset.activity_res_id.key_value
			end)

			onButton(arg0, arg0, function()
				if var1.shopLinkActID and var0(var1.shopLinkActID) then
					pg.TipsMgr.GetInstance():ShowTips(i18n("common_activity_end"))

					return
				end

				arg0:emit(ActivityMediator.GO_SHOPS_LAYER, {
					warp = NewShopsScene.TYPE_ACTIVITY,
					actId = var0 and var0.id
				})
			end)
		end,
		build = function(arg0)
			onButton(arg0, arg0, function()
				if var1.buildLinkActID and var0(var1.buildLinkActID) then
					pg.TipsMgr.GetInstance():ShowTips(i18n("common_activity_end"))

					return
				end

				arg0:emit(ActivityMediator.EVENT_GO_SCENE, SCENE.GETBOAT, {
					page = BuildShipScene.PAGE_BUILD,
					projectName = BuildShipScene.PROJECTS.ACTIVITY
				})
			end)
		end,
		fight = function(arg0)
			onButton(arg0, arg0, function()
				if var1.fightLinkActID and var0(var1.fightLinkActID) then
					pg.TipsMgr.GetInstance():ShowTips(i18n("common_activity_end"))

					return
				end

				arg0:emit(ActivityMediator.BATTLE_OPERA)
			end)
		end,
		lottery = function(arg0)
			onButton(arg0, arg0, function()
				if var1.lotteryLinkActID and var0(var1.lotteryLinkActID) then
					pg.TipsMgr.GetInstance():ShowTips(i18n("common_activity_end"))

					return
				end

				arg0:emit(ActivityMediator.GO_LOTTERY)
			end)
		end,
		memory = function(arg0)
			return
		end,
		activity = function(arg0)
			return
		end,
		mountain = function(arg0)
			return
		end,
		skinshop = function(arg0)
			onButton(arg0, arg0, function()
				arg0:emit(ActivityMediator.EVENT_GO_SCENE, SCENE.SKINSHOP)
			end)
		end
	}
end

return var0
