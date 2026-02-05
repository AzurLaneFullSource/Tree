local var0_0 = class("EnterIslandCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody()
	local var1_1 = var0_1.id
	local var2_1 = var0_1.code
	local var3_1 = var0_1.reconnect
	local var4_1 = getProxy(PlayerProxy):getRawData()

	if var4_1 then
		local var5_1, var6_1 = pg.SystemOpenMgr.GetInstance():isOpenSystem(var4_1.level, IslandMediator.__cname)

		if not var5_1 then
			pg.TipsMgr.GetInstance():ShowTips(var6_1)

			return
		end
	end

	if var2_1 and var2_1 ~= "" then
		arg0_1:Send(0, var2_1, var3_1)
	else
		arg0_1:Send(var1_1, 0, var3_1)
	end
end

function var0_0.Send(arg0_2, arg1_2, arg2_2, arg3_2)
	pg.ConnectionMgr.GetInstance():Send(21202, {
		island_id = arg1_2,
		code = tostring(arg2_2)
	}, 21203, function(arg0_3)
		if arg0_3.result == 0 then
			local var0_3 = {}
			local var1_3 = arg0_2:IsSelf(arg1_2)

			table.insert(var0_3, function(arg0_4)
				arg0_2:sendNotification(GAME.ISLAND_GET_DATA, {
					id = arg0_3.island_id,
					list = arg0_3.player_list,
					reconnect = arg3_2,
					checkCanEnterMap = arg0_4
				})
			end)

			local var2_3 = false

			table.insert(var0_3, function(arg0_5)
				if var1_3 then
					var2_3 = getProxy(IslandProxy):GetIsland():GetSeasonAgency():NeedReset()

					if var2_3 then
						arg0_2:sendNotification(GAME.ISLAND_RESET_SEASON, {
							callback = arg0_5
						})
					else
						arg0_5()
					end
				else
					arg0_5()
				end
			end)
			table.insert(var0_3, function(arg0_6)
				if var2_3 then
					arg0_2:sendNotification(GAME.ISLAND_GET_DATA, {
						id = arg0_3.island_id,
						list = arg0_3.player_list,
						reconnect = arg3_2,
						checkCanEnterMap = arg0_6
					})
				else
					arg0_6()
				end
			end)
			seriesAsync(var0_3, function()
				local var0_7 = var1_3 and getProxy(IslandProxy):GetIsland() or getProxy(IslandProxy):GetSharedIsland()

				arg0_2:sendNotification(GAME.ISLAND_ENTER_MAP, {
					islandId = arg1_2,
					mapId = var0_7:GetMapId(),
					callback = function()
						arg0_2:GoScene(arg1_2)
					end
				})
				getProxy(IslandProxy):EnterIsland(arg0_3.island_id)
			end)
		elseif arg0_3.result == 6 then
			arg0_2:sendNotification(GAME.ISLAND_QUEUE_UP, {
				pos = arg0_3.pos,
				id = arg0_3.island_id
			})
		elseif arg0_3.result == 19 then
			local var3_3 = pg.TimeMgr.GetInstance():GetServerTime()
			local var4_3 = arg0_3.cd - var3_3
			local var5_3 = pg.TimeMgr.GetInstance():DescCDTime(var4_3)

			pg.TipsMgr.GetInstance():ShowTips(i18n("island_visit_tip5", var5_3))
		elseif arg0_3.result == 1 then
			pg.TipsMgr.GetInstance():ShowTips(i18n("island_visit_tip1"))
		elseif arg0_3.result == 20 or arg0_3.result == 40 then
			pg.TipsMgr.GetInstance():ShowTips(i18n("island_visit_tip2"))
		elseif arg0_3.result == 9 then
			pg.TipsMgr.GetInstance():ShowTips(i18n("island_visit_tip3"))
		else
			pg.TipsMgr.GetInstance():ShowTips(ERROR_MESSAGE[arg0_3.result] .. arg0_3.result)
		end
	end)
end

function var0_0.IsSelf(arg0_9, arg1_9)
	return getProxy(PlayerProxy):getRawData().id == arg1_9
end

function var0_0.GoScene(arg0_10, arg1_10)
	if arg0_10:IsSelf(arg1_10) then
		arg0_10:sendNotification(GAME.GO_SCENE, SCENE.ISLAND, {
			id = arg1_10
		})
	else
		arg0_10:sendNotification(GAME.GO_SCENE, SCENE.SHARED_ISLAND, {
			id = arg1_10
		})
	end
end

return var0_0
