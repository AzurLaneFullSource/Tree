local var0_0 = class("BackYardShipCard", import(".BackYardBaseCard"))

function var0_0.OnInit(arg0_1)
	arg0_1.info = BackYardFormationCard.New(arg0_1._go)

	onButton(arg0_1, arg0_1._content, function()
		arg0_1:emit(NewBackYardShipInfoMediator.OPEN_CHUANWU, arg0_1.type, arg0_1.ship)
	end, SFX_PANEL)

	arg0_1.press = GetOrAddComponent(arg0_1._content, typeof(UILongPressTrigger))

	arg0_1.press.onLongPressed:RemoveAllListeners()
	arg0_1.press.onLongPressed:AddListener(function()
		if not arg0_1.ship then
			return
		end

		arg0_1:emit(NewBackYardShipInfoMediator.LOOG_PRESS_SHIP, arg0_1.type, arg0_1.ship)
	end)
end

function var0_0.OnFlush(arg0_4)
	local var0_4 = arg0_4.ship
	local var1_4 = arg0_4.info

	if not arg0_4.targteShipId or arg0_4.targteShipId ~= var0_4.id then
		var1_4:update(var0_4)

		arg0_4.targteShipId = var0_4.id
	end

	local var2_4 = var0_4:getLevelExpConfig()
	local var3_4 = arg0_4:CalcShipAddExpSpeed()
	local var4_4 = {}
	local var5_4 = getProxy(ActivityProxy):getActivitiesByType(ActivityConst.ACTIVITY_TYPE_HOTSPRING)

	table.Foreach(var5_4, function(arg0_5, arg1_5)
		if arg1_5 and not arg1_5:isEnd() then
			local var0_5 = arg1_5:getConfig("config_data")[1][4]

			_.each(arg1_5:getData1List(), function(arg0_6)
				var4_4[arg0_6] = (var4_4[arg0_6] or 0) + var0_5
			end)
		end
	end)

	local var6_4 = 0
	local var7_4 = 0

	for iter0_4, iter1_4 in ipairs(getProxy(ActivityProxy):getBackyardEnergyActivityBuffs()) do
		var7_4 = var7_4 + tonumber(iter1_4:getConfig("benefit_effect"))
	end

	if arg0_4.type == Ship.STATE_TRAIN then
		local var8_4 = var0_4:getRecoverEnergyPoint() + Ship.BACKYARD_1F_ENERGY_ADDITION + (var4_4[var0_4.id] or 0)

		var1_4:updateProps({
			{
				i18n("word_lv"),
				var0_4.level
			},
			{
				i18n("word_next_level"),
				math.max(var2_4.exp - var0_4.exp, 0)
			},
			{
				i18n("word_exp_chinese") .. i18n("word_get"),
				var3_4
			},
			{
				i18n("word_nowenergy"),
				var0_4.energy
			},
			{
				i18n("word_energy_recov_speed"),
				10 * var8_4 .. (var7_4 > 0 and setColorStr("+" .. 10 * var7_4, COLOR_GREEN) or "") .. "/h"
			}
		})
	elseif arg0_4.type == Ship.STATE_REST then
		local var9_4 = var0_4:getRecoverEnergyPoint() + Ship.BACKYARD_2F_ENERGY_ADDITION + (var4_4[var0_4.id] or 0)

		var1_4:updateProps1({
			{
				i18n("word_lv"),
				var0_4.level
			},
			{
				i18n("word_nowenergy"),
				var0_4.energy
			},
			{
				i18n("word_energy_recov_speed"),
				10 * var9_4 .. (var7_4 > 0 and setColorStr("+" .. 10 * var7_4, COLOR_GREEN) or "") .. "/h"
			}
		})
	end

	setActive(var1_4.propsTr, arg0_4.type == Ship.STATE_TRAIN)
	setActive(var1_4.propsTr1, arg0_4.type == Ship.STATE_REST)
end

function var0_0.CalcShipAddExpSpeed(arg0_7)
	local var0_7 = 0
	local var1_7 = getProxy(DormProxy):getRawData()
	local var2_7 = arg0_7:GetBaseExp(var1_7)

	return (math.floor(var2_7 * 3600 / pg.dorm_data_template[var1_7.id].time))
end

function var0_0.GetBaseExp(arg0_8, arg1_8)
	local var0_8 = getProxy(PlayerProxy):getRawData()
	local var1_8 = arg1_8:GetStateShipCnt(Ship.STATE_TRAIN)

	if var1_8 <= 0 then
		return 0
	end

	local var2_8 = pg.dorm_data_template[arg1_8.id]
	local var3_8 = BuffHelper.GetBackYardExpBuffs()
	local var4_8 = 1

	for iter0_8, iter1_8 in pairs(var3_8) do
		if iter1_8:isActivate() then
			local var5_8 = iter1_8:getConfig("benefit_effect")

			var4_8 = tonumber(var5_8) / 100 + var4_8
		end
	end

	local var6_8 = pg.gameset.dorm_exp_base.key_value
	local var7_8 = pg.gameset.dorm_exp_ratio_comfort_degree.key_value
	local var8_8 = pg.gameset["dorm_exp_ratio_by_" .. var1_8].key_value / 100
	local var9_8 = arg1_8:getComfortable()

	return var8_8 * (var6_8 + var2_8.exp * (var9_8 / (var9_8 + var7_8))) * var4_8 * (1 + 0.05 * var0_8.level)
end

function var0_0.OnDispose(arg0_9)
	arg0_9.press.onLongPressed:RemoveAllListeners()
	arg0_9.press.onLongPressed:AddListener(nil)

	if arg0_9.info then
		arg0_9.info:clear()
	end
end

return var0_0
