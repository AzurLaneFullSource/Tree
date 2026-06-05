local var0_0 = class("IslandMorphFormChangeCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody()
	local var1_1 = var0_1.fromBodyDressId
	local var2_1 = var0_1.toBodyDressId
	local var3_1 = var0_1.callback

	if not var1_1 or not var2_1 then
		existCall(var3_1)

		return
	end

	local var4_1 = getProxy(IslandProxy):GetIsland()

	if not var4_1 then
		existCall(var3_1)

		return
	end

	local var5_1 = var4_1:GetDressUpAgency()

	if not var5_1 then
		existCall(var3_1)

		return
	end

	if not pg.island_dress_template[var2_1] then
		existCall(var3_1)

		return
	end

	local var6_1 = pg.island_dress_template[var1_1].cut_out_state
	local var7_1 = pg.island_dress_template.get_id_list_by_related_dress[var2_1] or {}
	local var8_1 = var5_1:GetBodyHatIsOn(var2_1) and (var7_1[1] or 0) or 0

	local function var9_1()
		arg0_1:sendNotification(GAME.ISLAND_CHANGE_COMMANDER_DRESS, {
			hideTip = true,
			dress_List = {
				{
					type = IslandShipDressHelperNew.DressType.Body,
					id = var2_1
				},
				{
					type = IslandShipDressHelperNew.DressType.Hat,
					id = var8_1
				}
			},
			color_list = {},
			island_id = var4_1.id,
			callback = var3_1
		})
	end

	var4_1:DispatchEvent(IslandDressUpAgency.MORPH_PLAYER_DRESS, var1_1, var2_1, var8_1, var6_1, var9_1)
end

return var0_0
